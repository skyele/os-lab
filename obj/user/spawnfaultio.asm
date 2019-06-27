
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
  800042:	68 e0 2b 80 00       	push   $0x802be0
  800047:	e8 34 02 00 00       	call   800280 <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 fe 2b 80 00       	push   $0x802bfe
  800056:	68 fe 2b 80 00       	push   $0x802bfe
  80005b:	e8 20 1e 00 00       	call   801e80 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 06 2c 80 00       	push   $0x802c06
  80006f:	6a 09                	push   $0x9
  800071:	68 20 2c 80 00       	push   $0x802c20
  800076:	e8 0f 01 00 00       	call   80018a <_panic>

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
  80008e:	e8 00 0d 00 00       	call   800d93 <sys_getenvid>
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
  8000b3:	74 23                	je     8000d8 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000b5:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000bb:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c1:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000c4:	39 c1                	cmp    %eax,%ecx
  8000c6:	75 e2                	jne    8000aa <libmain+0x2f>
  8000c8:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000ce:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000d4:	89 fe                	mov    %edi,%esi
  8000d6:	eb d2                	jmp    8000aa <libmain+0x2f>
  8000d8:	89 f0                	mov    %esi,%eax
  8000da:	84 c0                	test   %al,%al
  8000dc:	74 06                	je     8000e4 <libmain+0x69>
  8000de:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e8:	7e 0a                	jle    8000f4 <libmain+0x79>
		binaryname = argv[0];
  8000ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ed:	8b 00                	mov    (%eax),%eax
  8000ef:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000f4:	a1 08 50 80 00       	mov    0x805008,%eax
  8000f9:	8b 40 48             	mov    0x48(%eax),%eax
  8000fc:	83 ec 08             	sub    $0x8,%esp
  8000ff:	50                   	push   %eax
  800100:	68 34 2c 80 00       	push   $0x802c34
  800105:	e8 76 01 00 00       	call   800280 <cprintf>
	cprintf("before umain\n");
  80010a:	c7 04 24 52 2c 80 00 	movl   $0x802c52,(%esp)
  800111:	e8 6a 01 00 00       	call   800280 <cprintf>
	// call user main routine
	umain(argc, argv);
  800116:	83 c4 08             	add    $0x8,%esp
  800119:	ff 75 0c             	pushl  0xc(%ebp)
  80011c:	ff 75 08             	pushl  0x8(%ebp)
  80011f:	e8 0f ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800124:	c7 04 24 60 2c 80 00 	movl   $0x802c60,(%esp)
  80012b:	e8 50 01 00 00       	call   800280 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800130:	a1 08 50 80 00       	mov    0x805008,%eax
  800135:	8b 40 48             	mov    0x48(%eax),%eax
  800138:	83 c4 08             	add    $0x8,%esp
  80013b:	50                   	push   %eax
  80013c:	68 6d 2c 80 00       	push   $0x802c6d
  800141:	e8 3a 01 00 00       	call   800280 <cprintf>
	// exit gracefully
	exit();
  800146:	e8 0b 00 00 00       	call   800156 <exit>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    

00800156 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800156:	55                   	push   %ebp
  800157:	89 e5                	mov    %esp,%ebp
  800159:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80015c:	a1 08 50 80 00       	mov    0x805008,%eax
  800161:	8b 40 48             	mov    0x48(%eax),%eax
  800164:	68 98 2c 80 00       	push   $0x802c98
  800169:	50                   	push   %eax
  80016a:	68 8c 2c 80 00       	push   $0x802c8c
  80016f:	e8 0c 01 00 00       	call   800280 <cprintf>
	close_all();
  800174:	e8 25 11 00 00       	call   80129e <close_all>
	sys_env_destroy(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 cd 0b 00 00       	call   800d52 <sys_env_destroy>
}
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	c9                   	leave  
  800189:	c3                   	ret    

0080018a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80018f:	a1 08 50 80 00       	mov    0x805008,%eax
  800194:	8b 40 48             	mov    0x48(%eax),%eax
  800197:	83 ec 04             	sub    $0x4,%esp
  80019a:	68 c4 2c 80 00       	push   $0x802cc4
  80019f:	50                   	push   %eax
  8001a0:	68 8c 2c 80 00       	push   $0x802c8c
  8001a5:	e8 d6 00 00 00       	call   800280 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ad:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001b3:	e8 db 0b 00 00       	call   800d93 <sys_getenvid>
  8001b8:	83 c4 04             	add    $0x4,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	56                   	push   %esi
  8001c2:	50                   	push   %eax
  8001c3:	68 a0 2c 80 00       	push   $0x802ca0
  8001c8:	e8 b3 00 00 00       	call   800280 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cd:	83 c4 18             	add    $0x18,%esp
  8001d0:	53                   	push   %ebx
  8001d1:	ff 75 10             	pushl  0x10(%ebp)
  8001d4:	e8 56 00 00 00       	call   80022f <vcprintf>
	cprintf("\n");
  8001d9:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  8001e0:	e8 9b 00 00 00       	call   800280 <cprintf>
  8001e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e8:	cc                   	int3   
  8001e9:	eb fd                	jmp    8001e8 <_panic+0x5e>

008001eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f5:	8b 13                	mov    (%ebx),%edx
  8001f7:	8d 42 01             	lea    0x1(%edx),%eax
  8001fa:	89 03                	mov    %eax,(%ebx)
  8001fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800203:	3d ff 00 00 00       	cmp    $0xff,%eax
  800208:	74 09                	je     800213 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800211:	c9                   	leave  
  800212:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	68 ff 00 00 00       	push   $0xff
  80021b:	8d 43 08             	lea    0x8(%ebx),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 f1 0a 00 00       	call   800d15 <sys_cputs>
		b->idx = 0;
  800224:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb db                	jmp    80020a <putch+0x1f>

0080022f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800238:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023f:	00 00 00 
	b.cnt = 0;
  800242:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800249:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024c:	ff 75 0c             	pushl  0xc(%ebp)
  80024f:	ff 75 08             	pushl  0x8(%ebp)
  800252:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	68 eb 01 80 00       	push   $0x8001eb
  80025e:	e8 4a 01 00 00       	call   8003ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800263:	83 c4 08             	add    $0x8,%esp
  800266:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80026c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800272:	50                   	push   %eax
  800273:	e8 9d 0a 00 00       	call   800d15 <sys_cputs>

	return b.cnt;
}
  800278:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800286:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800289:	50                   	push   %eax
  80028a:	ff 75 08             	pushl  0x8(%ebp)
  80028d:	e8 9d ff ff ff       	call   80022f <vcprintf>
	va_end(ap);

	return cnt;
}
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 1c             	sub    $0x1c,%esp
  80029d:	89 c6                	mov    %eax,%esi
  80029f:	89 d7                	mov    %edx,%edi
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002b3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b7:	74 2c                	je     8002e5 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002bc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ce:	73 43                	jae    800313 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d0:	83 eb 01             	sub    $0x1,%ebx
  8002d3:	85 db                	test   %ebx,%ebx
  8002d5:	7e 6c                	jle    800343 <printnum+0xaf>
				putch(padc, putdat);
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	57                   	push   %edi
  8002db:	ff 75 18             	pushl  0x18(%ebp)
  8002de:	ff d6                	call   *%esi
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	eb eb                	jmp    8002d0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	6a 20                	push   $0x20
  8002ea:	6a 00                	push   $0x0
  8002ec:	50                   	push   %eax
  8002ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f3:	89 fa                	mov    %edi,%edx
  8002f5:	89 f0                	mov    %esi,%eax
  8002f7:	e8 98 ff ff ff       	call   800294 <printnum>
		while (--width > 0)
  8002fc:	83 c4 20             	add    $0x20,%esp
  8002ff:	83 eb 01             	sub    $0x1,%ebx
  800302:	85 db                	test   %ebx,%ebx
  800304:	7e 65                	jle    80036b <printnum+0xd7>
			putch(padc, putdat);
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	57                   	push   %edi
  80030a:	6a 20                	push   $0x20
  80030c:	ff d6                	call   *%esi
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	eb ec                	jmp    8002ff <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	ff 75 18             	pushl  0x18(%ebp)
  800319:	83 eb 01             	sub    $0x1,%ebx
  80031c:	53                   	push   %ebx
  80031d:	50                   	push   %eax
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	ff 75 dc             	pushl  -0x24(%ebp)
  800324:	ff 75 d8             	pushl  -0x28(%ebp)
  800327:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032a:	ff 75 e0             	pushl  -0x20(%ebp)
  80032d:	e8 4e 26 00 00       	call   802980 <__udivdi3>
  800332:	83 c4 18             	add    $0x18,%esp
  800335:	52                   	push   %edx
  800336:	50                   	push   %eax
  800337:	89 fa                	mov    %edi,%edx
  800339:	89 f0                	mov    %esi,%eax
  80033b:	e8 54 ff ff ff       	call   800294 <printnum>
  800340:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	57                   	push   %edi
  800347:	83 ec 04             	sub    $0x4,%esp
  80034a:	ff 75 dc             	pushl  -0x24(%ebp)
  80034d:	ff 75 d8             	pushl  -0x28(%ebp)
  800350:	ff 75 e4             	pushl  -0x1c(%ebp)
  800353:	ff 75 e0             	pushl  -0x20(%ebp)
  800356:	e8 35 27 00 00       	call   802a90 <__umoddi3>
  80035b:	83 c4 14             	add    $0x14,%esp
  80035e:	0f be 80 cb 2c 80 00 	movsbl 0x802ccb(%eax),%eax
  800365:	50                   	push   %eax
  800366:	ff d6                	call   *%esi
  800368:	83 c4 10             	add    $0x10,%esp
	}
}
  80036b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800379:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037d:	8b 10                	mov    (%eax),%edx
  80037f:	3b 50 04             	cmp    0x4(%eax),%edx
  800382:	73 0a                	jae    80038e <sprintputch+0x1b>
		*b->buf++ = ch;
  800384:	8d 4a 01             	lea    0x1(%edx),%ecx
  800387:	89 08                	mov    %ecx,(%eax)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	88 02                	mov    %al,(%edx)
}
  80038e:	5d                   	pop    %ebp
  80038f:	c3                   	ret    

00800390 <printfmt>:
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800396:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800399:	50                   	push   %eax
  80039a:	ff 75 10             	pushl  0x10(%ebp)
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	e8 05 00 00 00       	call   8003ad <vprintfmt>
}
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <vprintfmt>:
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	57                   	push   %edi
  8003b1:	56                   	push   %esi
  8003b2:	53                   	push   %ebx
  8003b3:	83 ec 3c             	sub    $0x3c,%esp
  8003b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003bf:	e9 32 04 00 00       	jmp    8007f6 <vprintfmt+0x449>
		padc = ' ';
  8003c4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003c8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003cf:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e4:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8d 47 01             	lea    0x1(%edi),%eax
  8003f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f6:	0f b6 17             	movzbl (%edi),%edx
  8003f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fc:	3c 55                	cmp    $0x55,%al
  8003fe:	0f 87 12 05 00 00    	ja     800916 <vprintfmt+0x569>
  800404:	0f b6 c0             	movzbl %al,%eax
  800407:	ff 24 85 a0 2e 80 00 	jmp    *0x802ea0(,%eax,4)
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800411:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800415:	eb d9                	jmp    8003f0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80041e:	eb d0                	jmp    8003f0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	0f b6 d2             	movzbl %dl,%edx
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	89 75 08             	mov    %esi,0x8(%ebp)
  80042e:	eb 03                	jmp    800433 <vprintfmt+0x86>
  800430:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800433:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800436:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80043a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80043d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800440:	83 fe 09             	cmp    $0x9,%esi
  800443:	76 eb                	jbe    800430 <vprintfmt+0x83>
  800445:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800448:	8b 75 08             	mov    0x8(%ebp),%esi
  80044b:	eb 14                	jmp    800461 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	8d 40 04             	lea    0x4(%eax),%eax
  80045b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800465:	79 89                	jns    8003f0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800467:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80046a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800474:	e9 77 ff ff ff       	jmp    8003f0 <vprintfmt+0x43>
  800479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047c:	85 c0                	test   %eax,%eax
  80047e:	0f 48 c1             	cmovs  %ecx,%eax
  800481:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800487:	e9 64 ff ff ff       	jmp    8003f0 <vprintfmt+0x43>
  80048c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80048f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800496:	e9 55 ff ff ff       	jmp    8003f0 <vprintfmt+0x43>
			lflag++;
  80049b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a2:	e9 49 ff ff ff       	jmp    8003f0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 78 04             	lea    0x4(%eax),%edi
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	53                   	push   %ebx
  8004b1:	ff 30                	pushl  (%eax)
  8004b3:	ff d6                	call   *%esi
			break;
  8004b5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004bb:	e9 33 03 00 00       	jmp    8007f3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8d 78 04             	lea    0x4(%eax),%edi
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	99                   	cltd   
  8004c9:	31 d0                	xor    %edx,%eax
  8004cb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cd:	83 f8 11             	cmp    $0x11,%eax
  8004d0:	7f 23                	jg     8004f5 <vprintfmt+0x148>
  8004d2:	8b 14 85 00 30 80 00 	mov    0x803000(,%eax,4),%edx
  8004d9:	85 d2                	test   %edx,%edx
  8004db:	74 18                	je     8004f5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004dd:	52                   	push   %edx
  8004de:	68 1d 31 80 00       	push   $0x80311d
  8004e3:	53                   	push   %ebx
  8004e4:	56                   	push   %esi
  8004e5:	e8 a6 fe ff ff       	call   800390 <printfmt>
  8004ea:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ed:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f0:	e9 fe 02 00 00       	jmp    8007f3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f5:	50                   	push   %eax
  8004f6:	68 e3 2c 80 00       	push   $0x802ce3
  8004fb:	53                   	push   %ebx
  8004fc:	56                   	push   %esi
  8004fd:	e8 8e fe ff ff       	call   800390 <printfmt>
  800502:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800505:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800508:	e9 e6 02 00 00       	jmp    8007f3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	83 c0 04             	add    $0x4,%eax
  800513:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80051b:	85 c9                	test   %ecx,%ecx
  80051d:	b8 dc 2c 80 00       	mov    $0x802cdc,%eax
  800522:	0f 45 c1             	cmovne %ecx,%eax
  800525:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800528:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052c:	7e 06                	jle    800534 <vprintfmt+0x187>
  80052e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800532:	75 0d                	jne    800541 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800534:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800537:	89 c7                	mov    %eax,%edi
  800539:	03 45 e0             	add    -0x20(%ebp),%eax
  80053c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053f:	eb 53                	jmp    800594 <vprintfmt+0x1e7>
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 d8             	pushl  -0x28(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 71 04 00 00       	call   8009be <strnlen>
  80054d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800550:	29 c1                	sub    %eax,%ecx
  800552:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80055a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800561:	eb 0f                	jmp    800572 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	53                   	push   %ebx
  800567:	ff 75 e0             	pushl  -0x20(%ebp)
  80056a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056c:	83 ef 01             	sub    $0x1,%edi
  80056f:	83 c4 10             	add    $0x10,%esp
  800572:	85 ff                	test   %edi,%edi
  800574:	7f ed                	jg     800563 <vprintfmt+0x1b6>
  800576:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800579:	85 c9                	test   %ecx,%ecx
  80057b:	b8 00 00 00 00       	mov    $0x0,%eax
  800580:	0f 49 c1             	cmovns %ecx,%eax
  800583:	29 c1                	sub    %eax,%ecx
  800585:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800588:	eb aa                	jmp    800534 <vprintfmt+0x187>
					putch(ch, putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	53                   	push   %ebx
  80058e:	52                   	push   %edx
  80058f:	ff d6                	call   *%esi
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800597:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800599:	83 c7 01             	add    $0x1,%edi
  80059c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a0:	0f be d0             	movsbl %al,%edx
  8005a3:	85 d2                	test   %edx,%edx
  8005a5:	74 4b                	je     8005f2 <vprintfmt+0x245>
  8005a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ab:	78 06                	js     8005b3 <vprintfmt+0x206>
  8005ad:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b1:	78 1e                	js     8005d1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b7:	74 d1                	je     80058a <vprintfmt+0x1dd>
  8005b9:	0f be c0             	movsbl %al,%eax
  8005bc:	83 e8 20             	sub    $0x20,%eax
  8005bf:	83 f8 5e             	cmp    $0x5e,%eax
  8005c2:	76 c6                	jbe    80058a <vprintfmt+0x1dd>
					putch('?', putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	6a 3f                	push   $0x3f
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	eb c3                	jmp    800594 <vprintfmt+0x1e7>
  8005d1:	89 cf                	mov    %ecx,%edi
  8005d3:	eb 0e                	jmp    8005e3 <vprintfmt+0x236>
				putch(' ', putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	53                   	push   %ebx
  8005d9:	6a 20                	push   $0x20
  8005db:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005dd:	83 ef 01             	sub    $0x1,%edi
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	85 ff                	test   %edi,%edi
  8005e5:	7f ee                	jg     8005d5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ed:	e9 01 02 00 00       	jmp    8007f3 <vprintfmt+0x446>
  8005f2:	89 cf                	mov    %ecx,%edi
  8005f4:	eb ed                	jmp    8005e3 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005f9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800600:	e9 eb fd ff ff       	jmp    8003f0 <vprintfmt+0x43>
	if (lflag >= 2)
  800605:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800609:	7f 21                	jg     80062c <vprintfmt+0x27f>
	else if (lflag)
  80060b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060f:	74 68                	je     800679 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8b 00                	mov    (%eax),%eax
  800616:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	c1 f9 1f             	sar    $0x1f,%ecx
  80061e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 04             	lea    0x4(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
  80062a:	eb 17                	jmp    800643 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 50 04             	mov    0x4(%eax),%edx
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800637:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8d 40 08             	lea    0x8(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800643:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800646:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80064f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800653:	78 3f                	js     800694 <vprintfmt+0x2e7>
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80065a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80065e:	0f 84 71 01 00 00    	je     8007d5 <vprintfmt+0x428>
				putch('+', putdat);
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	53                   	push   %ebx
  800668:	6a 2b                	push   $0x2b
  80066a:	ff d6                	call   *%esi
  80066c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 5c 01 00 00       	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800681:	89 c1                	mov    %eax,%ecx
  800683:	c1 f9 1f             	sar    $0x1f,%ecx
  800686:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	eb af                	jmp    800643 <vprintfmt+0x296>
				putch('-', putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	53                   	push   %ebx
  800698:	6a 2d                	push   $0x2d
  80069a:	ff d6                	call   *%esi
				num = -(long long) num;
  80069c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80069f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a2:	f7 d8                	neg    %eax
  8006a4:	83 d2 00             	adc    $0x0,%edx
  8006a7:	f7 da                	neg    %edx
  8006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006af:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b7:	e9 19 01 00 00       	jmp    8007d5 <vprintfmt+0x428>
	if (lflag >= 2)
  8006bc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c0:	7f 29                	jg     8006eb <vprintfmt+0x33e>
	else if (lflag)
  8006c2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c6:	74 44                	je     80070c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e6:	e9 ea 00 00 00       	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8d 40 08             	lea    0x8(%eax),%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800702:	b8 0a 00 00 00       	mov    $0xa,%eax
  800707:	e9 c9 00 00 00       	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
  800716:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800719:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800725:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072a:	e9 a6 00 00 00       	jmp    8007d5 <vprintfmt+0x428>
			putch('0', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	53                   	push   %ebx
  800733:	6a 30                	push   $0x30
  800735:	ff d6                	call   *%esi
	if (lflag >= 2)
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073e:	7f 26                	jg     800766 <vprintfmt+0x3b9>
	else if (lflag)
  800740:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800744:	74 3e                	je     800784 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	ba 00 00 00 00       	mov    $0x0,%edx
  800750:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800753:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8d 40 04             	lea    0x4(%eax),%eax
  80075c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075f:	b8 08 00 00 00       	mov    $0x8,%eax
  800764:	eb 6f                	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 50 04             	mov    0x4(%eax),%edx
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 08             	lea    0x8(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077d:	b8 08 00 00 00       	mov    $0x8,%eax
  800782:	eb 51                	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079d:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a2:	eb 31                	jmp    8007d5 <vprintfmt+0x428>
			putch('0', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	53                   	push   %ebx
  8007a8:	6a 30                	push   $0x30
  8007aa:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ac:	83 c4 08             	add    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 78                	push   $0x78
  8007b2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 40 04             	lea    0x4(%eax),%eax
  8007cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d5:	83 ec 0c             	sub    $0xc,%esp
  8007d8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007dc:	52                   	push   %edx
  8007dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e0:	50                   	push   %eax
  8007e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e7:	89 da                	mov    %ebx,%edx
  8007e9:	89 f0                	mov    %esi,%eax
  8007eb:	e8 a4 fa ff ff       	call   800294 <printnum>
			break;
  8007f0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f6:	83 c7 01             	add    $0x1,%edi
  8007f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007fd:	83 f8 25             	cmp    $0x25,%eax
  800800:	0f 84 be fb ff ff    	je     8003c4 <vprintfmt+0x17>
			if (ch == '\0')
  800806:	85 c0                	test   %eax,%eax
  800808:	0f 84 28 01 00 00    	je     800936 <vprintfmt+0x589>
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	50                   	push   %eax
  800813:	ff d6                	call   *%esi
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	eb dc                	jmp    8007f6 <vprintfmt+0x449>
	if (lflag >= 2)
  80081a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80081e:	7f 26                	jg     800846 <vprintfmt+0x499>
	else if (lflag)
  800820:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800824:	74 41                	je     800867 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
  800844:	eb 8f                	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 08             	lea    0x8(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
  800862:	e9 6e ff ff ff       	jmp    8007d5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	ba 00 00 00 00       	mov    $0x0,%edx
  800871:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800874:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 40 04             	lea    0x4(%eax),%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800880:	b8 10 00 00 00       	mov    $0x10,%eax
  800885:	e9 4b ff ff ff       	jmp    8007d5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	85 c0                	test   %eax,%eax
  80089a:	74 14                	je     8008b0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80089c:	8b 13                	mov    (%ebx),%edx
  80089e:	83 fa 7f             	cmp    $0x7f,%edx
  8008a1:	7f 37                	jg     8008da <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008a3:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ab:	e9 43 ff ff ff       	jmp    8007f3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b5:	bf 01 2e 80 00       	mov    $0x802e01,%edi
							putch(ch, putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	53                   	push   %ebx
  8008be:	50                   	push   %eax
  8008bf:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c1:	83 c7 01             	add    $0x1,%edi
  8008c4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	75 eb                	jne    8008ba <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	e9 19 ff ff ff       	jmp    8007f3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008da:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e1:	bf 39 2e 80 00       	mov    $0x802e39,%edi
							putch(ch, putdat);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	53                   	push   %ebx
  8008ea:	50                   	push   %eax
  8008eb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ed:	83 c7 01             	add    $0x1,%edi
  8008f0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	75 eb                	jne    8008e6 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800901:	e9 ed fe ff ff       	jmp    8007f3 <vprintfmt+0x446>
			putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	53                   	push   %ebx
  80090a:	6a 25                	push   $0x25
  80090c:	ff d6                	call   *%esi
			break;
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	e9 dd fe ff ff       	jmp    8007f3 <vprintfmt+0x446>
			putch('%', putdat);
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	53                   	push   %ebx
  80091a:	6a 25                	push   $0x25
  80091c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	89 f8                	mov    %edi,%eax
  800923:	eb 03                	jmp    800928 <vprintfmt+0x57b>
  800925:	83 e8 01             	sub    $0x1,%eax
  800928:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80092c:	75 f7                	jne    800925 <vprintfmt+0x578>
  80092e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800931:	e9 bd fe ff ff       	jmp    8007f3 <vprintfmt+0x446>
}
  800936:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800939:	5b                   	pop    %ebx
  80093a:	5e                   	pop    %esi
  80093b:	5f                   	pop    %edi
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	83 ec 18             	sub    $0x18,%esp
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800951:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095b:	85 c0                	test   %eax,%eax
  80095d:	74 26                	je     800985 <vsnprintf+0x47>
  80095f:	85 d2                	test   %edx,%edx
  800961:	7e 22                	jle    800985 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800963:	ff 75 14             	pushl  0x14(%ebp)
  800966:	ff 75 10             	pushl  0x10(%ebp)
  800969:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	68 73 03 80 00       	push   $0x800373
  800972:	e8 36 fa ff ff       	call   8003ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80097a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	83 c4 10             	add    $0x10,%esp
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    
		return -E_INVAL;
  800985:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098a:	eb f7                	jmp    800983 <vsnprintf+0x45>

0080098c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800992:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800995:	50                   	push   %eax
  800996:	ff 75 10             	pushl  0x10(%ebp)
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	ff 75 08             	pushl  0x8(%ebp)
  80099f:	e8 9a ff ff ff       	call   80093e <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a4:	c9                   	leave  
  8009a5:	c3                   	ret    

008009a6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b5:	74 05                	je     8009bc <strlen+0x16>
		n++;
  8009b7:	83 c0 01             	add    $0x1,%eax
  8009ba:	eb f5                	jmp    8009b1 <strlen+0xb>
	return n;
}
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cc:	39 c2                	cmp    %eax,%edx
  8009ce:	74 0d                	je     8009dd <strnlen+0x1f>
  8009d0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d4:	74 05                	je     8009db <strnlen+0x1d>
		n++;
  8009d6:	83 c2 01             	add    $0x1,%edx
  8009d9:	eb f1                	jmp    8009cc <strnlen+0xe>
  8009db:	89 d0                	mov    %edx,%eax
	return n;
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ee:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f5:	83 c2 01             	add    $0x1,%edx
  8009f8:	84 c9                	test   %cl,%cl
  8009fa:	75 f2                	jne    8009ee <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	53                   	push   %ebx
  800a03:	83 ec 10             	sub    $0x10,%esp
  800a06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a09:	53                   	push   %ebx
  800a0a:	e8 97 ff ff ff       	call   8009a6 <strlen>
  800a0f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	01 d8                	add    %ebx,%eax
  800a17:	50                   	push   %eax
  800a18:	e8 c2 ff ff ff       	call   8009df <strcpy>
	return dst;
}
  800a1d:	89 d8                	mov    %ebx,%eax
  800a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	56                   	push   %esi
  800a28:	53                   	push   %ebx
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2f:	89 c6                	mov    %eax,%esi
  800a31:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	39 f2                	cmp    %esi,%edx
  800a38:	74 11                	je     800a4b <strncpy+0x27>
		*dst++ = *src;
  800a3a:	83 c2 01             	add    $0x1,%edx
  800a3d:	0f b6 19             	movzbl (%ecx),%ebx
  800a40:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a43:	80 fb 01             	cmp    $0x1,%bl
  800a46:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a49:	eb eb                	jmp    800a36 <strncpy+0x12>
	}
	return ret;
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	8b 75 08             	mov    0x8(%ebp),%esi
  800a57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a5a:	8b 55 10             	mov    0x10(%ebp),%edx
  800a5d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5f:	85 d2                	test   %edx,%edx
  800a61:	74 21                	je     800a84 <strlcpy+0x35>
  800a63:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a67:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a69:	39 c2                	cmp    %eax,%edx
  800a6b:	74 14                	je     800a81 <strlcpy+0x32>
  800a6d:	0f b6 19             	movzbl (%ecx),%ebx
  800a70:	84 db                	test   %bl,%bl
  800a72:	74 0b                	je     800a7f <strlcpy+0x30>
			*dst++ = *src++;
  800a74:	83 c1 01             	add    $0x1,%ecx
  800a77:	83 c2 01             	add    $0x1,%edx
  800a7a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7d:	eb ea                	jmp    800a69 <strlcpy+0x1a>
  800a7f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a84:	29 f0                	sub    %esi,%eax
}
  800a86:	5b                   	pop    %ebx
  800a87:	5e                   	pop    %esi
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a90:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a93:	0f b6 01             	movzbl (%ecx),%eax
  800a96:	84 c0                	test   %al,%al
  800a98:	74 0c                	je     800aa6 <strcmp+0x1c>
  800a9a:	3a 02                	cmp    (%edx),%al
  800a9c:	75 08                	jne    800aa6 <strcmp+0x1c>
		p++, q++;
  800a9e:	83 c1 01             	add    $0x1,%ecx
  800aa1:	83 c2 01             	add    $0x1,%edx
  800aa4:	eb ed                	jmp    800a93 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa6:	0f b6 c0             	movzbl %al,%eax
  800aa9:	0f b6 12             	movzbl (%edx),%edx
  800aac:	29 d0                	sub    %edx,%eax
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	53                   	push   %ebx
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	89 c3                	mov    %eax,%ebx
  800abc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800abf:	eb 06                	jmp    800ac7 <strncmp+0x17>
		n--, p++, q++;
  800ac1:	83 c0 01             	add    $0x1,%eax
  800ac4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac7:	39 d8                	cmp    %ebx,%eax
  800ac9:	74 16                	je     800ae1 <strncmp+0x31>
  800acb:	0f b6 08             	movzbl (%eax),%ecx
  800ace:	84 c9                	test   %cl,%cl
  800ad0:	74 04                	je     800ad6 <strncmp+0x26>
  800ad2:	3a 0a                	cmp    (%edx),%cl
  800ad4:	74 eb                	je     800ac1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad6:	0f b6 00             	movzbl (%eax),%eax
  800ad9:	0f b6 12             	movzbl (%edx),%edx
  800adc:	29 d0                	sub    %edx,%eax
}
  800ade:	5b                   	pop    %ebx
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    
		return 0;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	eb f6                	jmp    800ade <strncmp+0x2e>

00800ae8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af2:	0f b6 10             	movzbl (%eax),%edx
  800af5:	84 d2                	test   %dl,%dl
  800af7:	74 09                	je     800b02 <strchr+0x1a>
		if (*s == c)
  800af9:	38 ca                	cmp    %cl,%dl
  800afb:	74 0a                	je     800b07 <strchr+0x1f>
	for (; *s; s++)
  800afd:	83 c0 01             	add    $0x1,%eax
  800b00:	eb f0                	jmp    800af2 <strchr+0xa>
			return (char *) s;
	return 0;
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b13:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b16:	38 ca                	cmp    %cl,%dl
  800b18:	74 09                	je     800b23 <strfind+0x1a>
  800b1a:	84 d2                	test   %dl,%dl
  800b1c:	74 05                	je     800b23 <strfind+0x1a>
	for (; *s; s++)
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	eb f0                	jmp    800b13 <strfind+0xa>
			break;
	return (char *) s;
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	57                   	push   %edi
  800b29:	56                   	push   %esi
  800b2a:	53                   	push   %ebx
  800b2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b31:	85 c9                	test   %ecx,%ecx
  800b33:	74 31                	je     800b66 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b35:	89 f8                	mov    %edi,%eax
  800b37:	09 c8                	or     %ecx,%eax
  800b39:	a8 03                	test   $0x3,%al
  800b3b:	75 23                	jne    800b60 <memset+0x3b>
		c &= 0xFF;
  800b3d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	c1 e3 08             	shl    $0x8,%ebx
  800b46:	89 d0                	mov    %edx,%eax
  800b48:	c1 e0 18             	shl    $0x18,%eax
  800b4b:	89 d6                	mov    %edx,%esi
  800b4d:	c1 e6 10             	shl    $0x10,%esi
  800b50:	09 f0                	or     %esi,%eax
  800b52:	09 c2                	or     %eax,%edx
  800b54:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b56:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b59:	89 d0                	mov    %edx,%eax
  800b5b:	fc                   	cld    
  800b5c:	f3 ab                	rep stos %eax,%es:(%edi)
  800b5e:	eb 06                	jmp    800b66 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	fc                   	cld    
  800b64:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b66:	89 f8                	mov    %edi,%eax
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b7b:	39 c6                	cmp    %eax,%esi
  800b7d:	73 32                	jae    800bb1 <memmove+0x44>
  800b7f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b82:	39 c2                	cmp    %eax,%edx
  800b84:	76 2b                	jbe    800bb1 <memmove+0x44>
		s += n;
		d += n;
  800b86:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b89:	89 fe                	mov    %edi,%esi
  800b8b:	09 ce                	or     %ecx,%esi
  800b8d:	09 d6                	or     %edx,%esi
  800b8f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b95:	75 0e                	jne    800ba5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b97:	83 ef 04             	sub    $0x4,%edi
  800b9a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b9d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba0:	fd                   	std    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 09                	jmp    800bae <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba5:	83 ef 01             	sub    $0x1,%edi
  800ba8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bab:	fd                   	std    
  800bac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bae:	fc                   	cld    
  800baf:	eb 1a                	jmp    800bcb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb1:	89 c2                	mov    %eax,%edx
  800bb3:	09 ca                	or     %ecx,%edx
  800bb5:	09 f2                	or     %esi,%edx
  800bb7:	f6 c2 03             	test   $0x3,%dl
  800bba:	75 0a                	jne    800bc6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bbc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bbf:	89 c7                	mov    %eax,%edi
  800bc1:	fc                   	cld    
  800bc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc4:	eb 05                	jmp    800bcb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc6:	89 c7                	mov    %eax,%edi
  800bc8:	fc                   	cld    
  800bc9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bcb:	5e                   	pop    %esi
  800bcc:	5f                   	pop    %edi
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd5:	ff 75 10             	pushl  0x10(%ebp)
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	ff 75 08             	pushl  0x8(%ebp)
  800bde:	e8 8a ff ff ff       	call   800b6d <memmove>
}
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf0:	89 c6                	mov    %eax,%esi
  800bf2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf5:	39 f0                	cmp    %esi,%eax
  800bf7:	74 1c                	je     800c15 <memcmp+0x30>
		if (*s1 != *s2)
  800bf9:	0f b6 08             	movzbl (%eax),%ecx
  800bfc:	0f b6 1a             	movzbl (%edx),%ebx
  800bff:	38 d9                	cmp    %bl,%cl
  800c01:	75 08                	jne    800c0b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c03:	83 c0 01             	add    $0x1,%eax
  800c06:	83 c2 01             	add    $0x1,%edx
  800c09:	eb ea                	jmp    800bf5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c0b:	0f b6 c1             	movzbl %cl,%eax
  800c0e:	0f b6 db             	movzbl %bl,%ebx
  800c11:	29 d8                	sub    %ebx,%eax
  800c13:	eb 05                	jmp    800c1a <memcmp+0x35>
	}

	return 0;
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2c:	39 d0                	cmp    %edx,%eax
  800c2e:	73 09                	jae    800c39 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c30:	38 08                	cmp    %cl,(%eax)
  800c32:	74 05                	je     800c39 <memfind+0x1b>
	for (; s < ends; s++)
  800c34:	83 c0 01             	add    $0x1,%eax
  800c37:	eb f3                	jmp    800c2c <memfind+0xe>
			break;
	return (void *) s;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c47:	eb 03                	jmp    800c4c <strtol+0x11>
		s++;
  800c49:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c4c:	0f b6 01             	movzbl (%ecx),%eax
  800c4f:	3c 20                	cmp    $0x20,%al
  800c51:	74 f6                	je     800c49 <strtol+0xe>
  800c53:	3c 09                	cmp    $0x9,%al
  800c55:	74 f2                	je     800c49 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c57:	3c 2b                	cmp    $0x2b,%al
  800c59:	74 2a                	je     800c85 <strtol+0x4a>
	int neg = 0;
  800c5b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c60:	3c 2d                	cmp    $0x2d,%al
  800c62:	74 2b                	je     800c8f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c64:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c6a:	75 0f                	jne    800c7b <strtol+0x40>
  800c6c:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6f:	74 28                	je     800c99 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c71:	85 db                	test   %ebx,%ebx
  800c73:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c78:	0f 44 d8             	cmove  %eax,%ebx
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c80:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c83:	eb 50                	jmp    800cd5 <strtol+0x9a>
		s++;
  800c85:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c88:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8d:	eb d5                	jmp    800c64 <strtol+0x29>
		s++, neg = 1;
  800c8f:	83 c1 01             	add    $0x1,%ecx
  800c92:	bf 01 00 00 00       	mov    $0x1,%edi
  800c97:	eb cb                	jmp    800c64 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c99:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c9d:	74 0e                	je     800cad <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9f:	85 db                	test   %ebx,%ebx
  800ca1:	75 d8                	jne    800c7b <strtol+0x40>
		s++, base = 8;
  800ca3:	83 c1 01             	add    $0x1,%ecx
  800ca6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cab:	eb ce                	jmp    800c7b <strtol+0x40>
		s += 2, base = 16;
  800cad:	83 c1 02             	add    $0x2,%ecx
  800cb0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb5:	eb c4                	jmp    800c7b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cba:	89 f3                	mov    %esi,%ebx
  800cbc:	80 fb 19             	cmp    $0x19,%bl
  800cbf:	77 29                	ja     800cea <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc1:	0f be d2             	movsbl %dl,%edx
  800cc4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cca:	7d 30                	jge    800cfc <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ccc:	83 c1 01             	add    $0x1,%ecx
  800ccf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd5:	0f b6 11             	movzbl (%ecx),%edx
  800cd8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cdb:	89 f3                	mov    %esi,%ebx
  800cdd:	80 fb 09             	cmp    $0x9,%bl
  800ce0:	77 d5                	ja     800cb7 <strtol+0x7c>
			dig = *s - '0';
  800ce2:	0f be d2             	movsbl %dl,%edx
  800ce5:	83 ea 30             	sub    $0x30,%edx
  800ce8:	eb dd                	jmp    800cc7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cea:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ced:	89 f3                	mov    %esi,%ebx
  800cef:	80 fb 19             	cmp    $0x19,%bl
  800cf2:	77 08                	ja     800cfc <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf4:	0f be d2             	movsbl %dl,%edx
  800cf7:	83 ea 37             	sub    $0x37,%edx
  800cfa:	eb cb                	jmp    800cc7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d00:	74 05                	je     800d07 <strtol+0xcc>
		*endptr = (char *) s;
  800d02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d05:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d07:	89 c2                	mov    %eax,%edx
  800d09:	f7 da                	neg    %edx
  800d0b:	85 ff                	test   %edi,%edi
  800d0d:	0f 45 c2             	cmovne %edx,%eax
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	89 c3                	mov    %eax,%ebx
  800d28:	89 c7                	mov    %eax,%edi
  800d2a:	89 c6                	mov    %eax,%esi
  800d2c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d43:	89 d1                	mov    %edx,%ecx
  800d45:	89 d3                	mov    %edx,%ebx
  800d47:	89 d7                	mov    %edx,%edi
  800d49:	89 d6                	mov    %edx,%esi
  800d4b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    

00800d52 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	b8 03 00 00 00       	mov    $0x3,%eax
  800d68:	89 cb                	mov    %ecx,%ebx
  800d6a:	89 cf                	mov    %ecx,%edi
  800d6c:	89 ce                	mov    %ecx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 03                	push   $0x3
  800d82:	68 48 30 80 00       	push   $0x803048
  800d87:	6a 43                	push   $0x43
  800d89:	68 65 30 80 00       	push   $0x803065
  800d8e:	e8 f7 f3 ff ff       	call   80018a <_panic>

00800d93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d99:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9e:	b8 02 00 00 00       	mov    $0x2,%eax
  800da3:	89 d1                	mov    %edx,%ecx
  800da5:	89 d3                	mov    %edx,%ebx
  800da7:	89 d7                	mov    %edx,%edi
  800da9:	89 d6                	mov    %edx,%esi
  800dab:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <sys_yield>:

void
sys_yield(void)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc2:	89 d1                	mov    %edx,%ecx
  800dc4:	89 d3                	mov    %edx,%ebx
  800dc6:	89 d7                	mov    %edx,%edi
  800dc8:	89 d6                	mov    %edx,%esi
  800dca:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	be 00 00 00 00       	mov    $0x0,%esi
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	b8 04 00 00 00       	mov    $0x4,%eax
  800dea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ded:	89 f7                	mov    %esi,%edi
  800def:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 04                	push   $0x4
  800e03:	68 48 30 80 00       	push   $0x803048
  800e08:	6a 43                	push   $0x43
  800e0a:	68 65 30 80 00       	push   $0x803065
  800e0f:	e8 76 f3 ff ff       	call   80018a <_panic>

00800e14 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	b8 05 00 00 00       	mov    $0x5,%eax
  800e28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 05                	push   $0x5
  800e45:	68 48 30 80 00       	push   $0x803048
  800e4a:	6a 43                	push   $0x43
  800e4c:	68 65 30 80 00       	push   $0x803065
  800e51:	e8 34 f3 ff ff       	call   80018a <_panic>

00800e56 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6f:	89 df                	mov    %ebx,%edi
  800e71:	89 de                	mov    %ebx,%esi
  800e73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7f 08                	jg     800e81 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	6a 06                	push   $0x6
  800e87:	68 48 30 80 00       	push   $0x803048
  800e8c:	6a 43                	push   $0x43
  800e8e:	68 65 30 80 00       	push   $0x803065
  800e93:	e8 f2 f2 ff ff       	call   80018a <_panic>

00800e98 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 08                	push   $0x8
  800ec9:	68 48 30 80 00       	push   $0x803048
  800ece:	6a 43                	push   $0x43
  800ed0:	68 65 30 80 00       	push   $0x803065
  800ed5:	e8 b0 f2 ff ff       	call   80018a <_panic>

00800eda <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 09                	push   $0x9
  800f0b:	68 48 30 80 00       	push   $0x803048
  800f10:	6a 43                	push   $0x43
  800f12:	68 65 30 80 00       	push   $0x803065
  800f17:	e8 6e f2 ff ff       	call   80018a <_panic>

00800f1c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7f 08                	jg     800f47 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	6a 0a                	push   $0xa
  800f4d:	68 48 30 80 00       	push   $0x803048
  800f52:	6a 43                	push   $0x43
  800f54:	68 65 30 80 00       	push   $0x803065
  800f59:	e8 2c f2 ff ff       	call   80018a <_panic>

00800f5e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6f:	be 00 00 00 00       	mov    $0x0,%esi
  800f74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f97:	89 cb                	mov    %ecx,%ebx
  800f99:	89 cf                	mov    %ecx,%edi
  800f9b:	89 ce                	mov    %ecx,%esi
  800f9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	7f 08                	jg     800fab <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fab:	83 ec 0c             	sub    $0xc,%esp
  800fae:	50                   	push   %eax
  800faf:	6a 0d                	push   $0xd
  800fb1:	68 48 30 80 00       	push   $0x803048
  800fb6:	6a 43                	push   $0x43
  800fb8:	68 65 30 80 00       	push   $0x803065
  800fbd:	e8 c8 f1 ff ff       	call   80018a <_panic>

00800fc2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd8:	89 df                	mov    %ebx,%edi
  800fda:	89 de                	mov    %ebx,%esi
  800fdc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff6:	89 cb                	mov    %ecx,%ebx
  800ff8:	89 cf                	mov    %ecx,%edi
  800ffa:	89 ce                	mov    %ecx,%esi
  800ffc:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
	asm volatile("int %1\n"
  801009:	ba 00 00 00 00       	mov    $0x0,%edx
  80100e:	b8 10 00 00 00       	mov    $0x10,%eax
  801013:	89 d1                	mov    %edx,%ecx
  801015:	89 d3                	mov    %edx,%ebx
  801017:	89 d7                	mov    %edx,%edi
  801019:	89 d6                	mov    %edx,%esi
  80101b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
	asm volatile("int %1\n"
  801028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	b8 11 00 00 00       	mov    $0x11,%eax
  801038:	89 df                	mov    %ebx,%edi
  80103a:	89 de                	mov    %ebx,%esi
  80103c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
	asm volatile("int %1\n"
  801049:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104e:	8b 55 08             	mov    0x8(%ebp),%edx
  801051:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801054:	b8 12 00 00 00       	mov    $0x12,%eax
  801059:	89 df                	mov    %ebx,%edi
  80105b:	89 de                	mov    %ebx,%esi
  80105d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
  80106a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801072:	8b 55 08             	mov    0x8(%ebp),%edx
  801075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801078:	b8 13 00 00 00       	mov    $0x13,%eax
  80107d:	89 df                	mov    %ebx,%edi
  80107f:	89 de                	mov    %ebx,%esi
  801081:	cd 30                	int    $0x30
	if(check && ret > 0)
  801083:	85 c0                	test   %eax,%eax
  801085:	7f 08                	jg     80108f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801087:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80108a:	5b                   	pop    %ebx
  80108b:	5e                   	pop    %esi
  80108c:	5f                   	pop    %edi
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108f:	83 ec 0c             	sub    $0xc,%esp
  801092:	50                   	push   %eax
  801093:	6a 13                	push   $0x13
  801095:	68 48 30 80 00       	push   $0x803048
  80109a:	6a 43                	push   $0x43
  80109c:	68 65 30 80 00       	push   $0x803065
  8010a1:	e8 e4 f0 ff ff       	call   80018a <_panic>

008010a6 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b4:	b8 14 00 00 00       	mov    $0x14,%eax
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	05 00 00 00 30       	add    $0x30000000,%eax
  8010d1:	c1 e8 0c             	shr    $0xc,%eax
}
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f5:	89 c2                	mov    %eax,%edx
  8010f7:	c1 ea 16             	shr    $0x16,%edx
  8010fa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801101:	f6 c2 01             	test   $0x1,%dl
  801104:	74 2d                	je     801133 <fd_alloc+0x46>
  801106:	89 c2                	mov    %eax,%edx
  801108:	c1 ea 0c             	shr    $0xc,%edx
  80110b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801112:	f6 c2 01             	test   $0x1,%dl
  801115:	74 1c                	je     801133 <fd_alloc+0x46>
  801117:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80111c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801121:	75 d2                	jne    8010f5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80112c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801131:	eb 0a                	jmp    80113d <fd_alloc+0x50>
			*fd_store = fd;
  801133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801136:	89 01                	mov    %eax,(%ecx)
			return 0;
  801138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801145:	83 f8 1f             	cmp    $0x1f,%eax
  801148:	77 30                	ja     80117a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80114a:	c1 e0 0c             	shl    $0xc,%eax
  80114d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801152:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801158:	f6 c2 01             	test   $0x1,%dl
  80115b:	74 24                	je     801181 <fd_lookup+0x42>
  80115d:	89 c2                	mov    %eax,%edx
  80115f:	c1 ea 0c             	shr    $0xc,%edx
  801162:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801169:	f6 c2 01             	test   $0x1,%dl
  80116c:	74 1a                	je     801188 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80116e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801171:	89 02                	mov    %eax,(%edx)
	return 0;
  801173:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    
		return -E_INVAL;
  80117a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117f:	eb f7                	jmp    801178 <fd_lookup+0x39>
		return -E_INVAL;
  801181:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801186:	eb f0                	jmp    801178 <fd_lookup+0x39>
  801188:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118d:	eb e9                	jmp    801178 <fd_lookup+0x39>

0080118f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 08             	sub    $0x8,%esp
  801195:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801198:	ba 00 00 00 00       	mov    $0x0,%edx
  80119d:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011a2:	39 08                	cmp    %ecx,(%eax)
  8011a4:	74 38                	je     8011de <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011a6:	83 c2 01             	add    $0x1,%edx
  8011a9:	8b 04 95 f0 30 80 00 	mov    0x8030f0(,%edx,4),%eax
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	75 ee                	jne    8011a2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011b4:	a1 08 50 80 00       	mov    0x805008,%eax
  8011b9:	8b 40 48             	mov    0x48(%eax),%eax
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	51                   	push   %ecx
  8011c0:	50                   	push   %eax
  8011c1:	68 74 30 80 00       	push   $0x803074
  8011c6:	e8 b5 f0 ff ff       	call   800280 <cprintf>
	*dev = 0;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    
			*dev = devtab[i];
  8011de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e8:	eb f2                	jmp    8011dc <dev_lookup+0x4d>

008011ea <fd_close>:
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 24             	sub    $0x24,%esp
  8011f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801203:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801206:	50                   	push   %eax
  801207:	e8 33 ff ff ff       	call   80113f <fd_lookup>
  80120c:	89 c3                	mov    %eax,%ebx
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	78 05                	js     80121a <fd_close+0x30>
	    || fd != fd2)
  801215:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801218:	74 16                	je     801230 <fd_close+0x46>
		return (must_exist ? r : 0);
  80121a:	89 f8                	mov    %edi,%eax
  80121c:	84 c0                	test   %al,%al
  80121e:	b8 00 00 00 00       	mov    $0x0,%eax
  801223:	0f 44 d8             	cmove  %eax,%ebx
}
  801226:	89 d8                	mov    %ebx,%eax
  801228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	ff 36                	pushl  (%esi)
  801239:	e8 51 ff ff ff       	call   80118f <dev_lookup>
  80123e:	89 c3                	mov    %eax,%ebx
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	78 1a                	js     801261 <fd_close+0x77>
		if (dev->dev_close)
  801247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80124a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80124d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801252:	85 c0                	test   %eax,%eax
  801254:	74 0b                	je     801261 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	56                   	push   %esi
  80125a:	ff d0                	call   *%eax
  80125c:	89 c3                	mov    %eax,%ebx
  80125e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	56                   	push   %esi
  801265:	6a 00                	push   $0x0
  801267:	e8 ea fb ff ff       	call   800e56 <sys_page_unmap>
	return r;
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	eb b5                	jmp    801226 <fd_close+0x3c>

00801271 <close>:

int
close(int fdnum)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801277:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 08             	pushl  0x8(%ebp)
  80127e:	e8 bc fe ff ff       	call   80113f <fd_lookup>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	79 02                	jns    80128c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    
		return fd_close(fd, 1);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	6a 01                	push   $0x1
  801291:	ff 75 f4             	pushl  -0xc(%ebp)
  801294:	e8 51 ff ff ff       	call   8011ea <fd_close>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	eb ec                	jmp    80128a <close+0x19>

0080129e <close_all>:

void
close_all(void)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	53                   	push   %ebx
  8012ae:	e8 be ff ff ff       	call   801271 <close>
	for (i = 0; i < MAXFD; i++)
  8012b3:	83 c3 01             	add    $0x1,%ebx
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	83 fb 20             	cmp    $0x20,%ebx
  8012bc:	75 ec                	jne    8012aa <close_all+0xc>
}
  8012be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	57                   	push   %edi
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012cf:	50                   	push   %eax
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 67 fe ff ff       	call   80113f <fd_lookup>
  8012d8:	89 c3                	mov    %eax,%ebx
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	0f 88 81 00 00 00    	js     801366 <dup+0xa3>
		return r;
	close(newfdnum);
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	e8 81 ff ff ff       	call   801271 <close>

	newfd = INDEX2FD(newfdnum);
  8012f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f3:	c1 e6 0c             	shl    $0xc,%esi
  8012f6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012fc:	83 c4 04             	add    $0x4,%esp
  8012ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801302:	e8 cf fd ff ff       	call   8010d6 <fd2data>
  801307:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801309:	89 34 24             	mov    %esi,(%esp)
  80130c:	e8 c5 fd ff ff       	call   8010d6 <fd2data>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801316:	89 d8                	mov    %ebx,%eax
  801318:	c1 e8 16             	shr    $0x16,%eax
  80131b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801322:	a8 01                	test   $0x1,%al
  801324:	74 11                	je     801337 <dup+0x74>
  801326:	89 d8                	mov    %ebx,%eax
  801328:	c1 e8 0c             	shr    $0xc,%eax
  80132b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801332:	f6 c2 01             	test   $0x1,%dl
  801335:	75 39                	jne    801370 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80133a:	89 d0                	mov    %edx,%eax
  80133c:	c1 e8 0c             	shr    $0xc,%eax
  80133f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	25 07 0e 00 00       	and    $0xe07,%eax
  80134e:	50                   	push   %eax
  80134f:	56                   	push   %esi
  801350:	6a 00                	push   $0x0
  801352:	52                   	push   %edx
  801353:	6a 00                	push   $0x0
  801355:	e8 ba fa ff ff       	call   800e14 <sys_page_map>
  80135a:	89 c3                	mov    %eax,%ebx
  80135c:	83 c4 20             	add    $0x20,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	78 31                	js     801394 <dup+0xd1>
		goto err;

	return newfdnum;
  801363:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801366:	89 d8                	mov    %ebx,%eax
  801368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136b:	5b                   	pop    %ebx
  80136c:	5e                   	pop    %esi
  80136d:	5f                   	pop    %edi
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801370:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801377:	83 ec 0c             	sub    $0xc,%esp
  80137a:	25 07 0e 00 00       	and    $0xe07,%eax
  80137f:	50                   	push   %eax
  801380:	57                   	push   %edi
  801381:	6a 00                	push   $0x0
  801383:	53                   	push   %ebx
  801384:	6a 00                	push   $0x0
  801386:	e8 89 fa ff ff       	call   800e14 <sys_page_map>
  80138b:	89 c3                	mov    %eax,%ebx
  80138d:	83 c4 20             	add    $0x20,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	79 a3                	jns    801337 <dup+0x74>
	sys_page_unmap(0, newfd);
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	56                   	push   %esi
  801398:	6a 00                	push   $0x0
  80139a:	e8 b7 fa ff ff       	call   800e56 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80139f:	83 c4 08             	add    $0x8,%esp
  8013a2:	57                   	push   %edi
  8013a3:	6a 00                	push   $0x0
  8013a5:	e8 ac fa ff ff       	call   800e56 <sys_page_unmap>
	return r;
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	eb b7                	jmp    801366 <dup+0xa3>

008013af <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	53                   	push   %ebx
  8013b3:	83 ec 1c             	sub    $0x1c,%esp
  8013b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	53                   	push   %ebx
  8013be:	e8 7c fd ff ff       	call   80113f <fd_lookup>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 3f                	js     801409 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d0:	50                   	push   %eax
  8013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d4:	ff 30                	pushl  (%eax)
  8013d6:	e8 b4 fd ff ff       	call   80118f <dev_lookup>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 27                	js     801409 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e5:	8b 42 08             	mov    0x8(%edx),%eax
  8013e8:	83 e0 03             	and    $0x3,%eax
  8013eb:	83 f8 01             	cmp    $0x1,%eax
  8013ee:	74 1e                	je     80140e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f3:	8b 40 08             	mov    0x8(%eax),%eax
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 35                	je     80142f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	ff 75 10             	pushl  0x10(%ebp)
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	52                   	push   %edx
  801404:	ff d0                	call   *%eax
  801406:	83 c4 10             	add    $0x10,%esp
}
  801409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140e:	a1 08 50 80 00       	mov    0x805008,%eax
  801413:	8b 40 48             	mov    0x48(%eax),%eax
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	53                   	push   %ebx
  80141a:	50                   	push   %eax
  80141b:	68 b5 30 80 00       	push   $0x8030b5
  801420:	e8 5b ee ff ff       	call   800280 <cprintf>
		return -E_INVAL;
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142d:	eb da                	jmp    801409 <read+0x5a>
		return -E_NOT_SUPP;
  80142f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801434:	eb d3                	jmp    801409 <read+0x5a>

00801436 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	57                   	push   %edi
  80143a:	56                   	push   %esi
  80143b:	53                   	push   %ebx
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801442:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801445:	bb 00 00 00 00       	mov    $0x0,%ebx
  80144a:	39 f3                	cmp    %esi,%ebx
  80144c:	73 23                	jae    801471 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	89 f0                	mov    %esi,%eax
  801453:	29 d8                	sub    %ebx,%eax
  801455:	50                   	push   %eax
  801456:	89 d8                	mov    %ebx,%eax
  801458:	03 45 0c             	add    0xc(%ebp),%eax
  80145b:	50                   	push   %eax
  80145c:	57                   	push   %edi
  80145d:	e8 4d ff ff ff       	call   8013af <read>
		if (m < 0)
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	85 c0                	test   %eax,%eax
  801467:	78 06                	js     80146f <readn+0x39>
			return m;
		if (m == 0)
  801469:	74 06                	je     801471 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80146b:	01 c3                	add    %eax,%ebx
  80146d:	eb db                	jmp    80144a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801471:	89 d8                	mov    %ebx,%eax
  801473:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801476:	5b                   	pop    %ebx
  801477:	5e                   	pop    %esi
  801478:	5f                   	pop    %edi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    

0080147b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	53                   	push   %ebx
  80147f:	83 ec 1c             	sub    $0x1c,%esp
  801482:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801485:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801488:	50                   	push   %eax
  801489:	53                   	push   %ebx
  80148a:	e8 b0 fc ff ff       	call   80113f <fd_lookup>
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 3a                	js     8014d0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a0:	ff 30                	pushl  (%eax)
  8014a2:	e8 e8 fc ff ff       	call   80118f <dev_lookup>
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 22                	js     8014d0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b5:	74 1e                	je     8014d5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8014bd:	85 d2                	test   %edx,%edx
  8014bf:	74 35                	je     8014f6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	ff 75 10             	pushl  0x10(%ebp)
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	50                   	push   %eax
  8014cb:	ff d2                	call   *%edx
  8014cd:	83 c4 10             	add    $0x10,%esp
}
  8014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8014da:	8b 40 48             	mov    0x48(%eax),%eax
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	53                   	push   %ebx
  8014e1:	50                   	push   %eax
  8014e2:	68 d1 30 80 00       	push   $0x8030d1
  8014e7:	e8 94 ed ff ff       	call   800280 <cprintf>
		return -E_INVAL;
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb da                	jmp    8014d0 <write+0x55>
		return -E_NOT_SUPP;
  8014f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fb:	eb d3                	jmp    8014d0 <write+0x55>

008014fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801503:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	ff 75 08             	pushl  0x8(%ebp)
  80150a:	e8 30 fc ff ff       	call   80113f <fd_lookup>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 0e                	js     801524 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801516:	8b 55 0c             	mov    0xc(%ebp),%edx
  801519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80151f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	53                   	push   %ebx
  80152a:	83 ec 1c             	sub    $0x1c,%esp
  80152d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801530:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801533:	50                   	push   %eax
  801534:	53                   	push   %ebx
  801535:	e8 05 fc ff ff       	call   80113f <fd_lookup>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 37                	js     801578 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801547:	50                   	push   %eax
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	ff 30                	pushl  (%eax)
  80154d:	e8 3d fc ff ff       	call   80118f <dev_lookup>
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 1f                	js     801578 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801560:	74 1b                	je     80157d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801565:	8b 52 18             	mov    0x18(%edx),%edx
  801568:	85 d2                	test   %edx,%edx
  80156a:	74 32                	je     80159e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	50                   	push   %eax
  801573:	ff d2                	call   *%edx
  801575:	83 c4 10             	add    $0x10,%esp
}
  801578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80157d:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801582:	8b 40 48             	mov    0x48(%eax),%eax
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	53                   	push   %ebx
  801589:	50                   	push   %eax
  80158a:	68 94 30 80 00       	push   $0x803094
  80158f:	e8 ec ec ff ff       	call   800280 <cprintf>
		return -E_INVAL;
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159c:	eb da                	jmp    801578 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80159e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a3:	eb d3                	jmp    801578 <ftruncate+0x52>

008015a5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 1c             	sub    $0x1c,%esp
  8015ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	ff 75 08             	pushl  0x8(%ebp)
  8015b6:	e8 84 fb ff ff       	call   80113f <fd_lookup>
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	78 4b                	js     80160d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	ff 30                	pushl  (%eax)
  8015ce:	e8 bc fb ff ff       	call   80118f <dev_lookup>
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	78 33                	js     80160d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e1:	74 2f                	je     801612 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015e6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ed:	00 00 00 
	stat->st_isdir = 0;
  8015f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015f7:	00 00 00 
	stat->st_dev = dev;
  8015fa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	53                   	push   %ebx
  801604:	ff 75 f0             	pushl  -0x10(%ebp)
  801607:	ff 50 14             	call   *0x14(%eax)
  80160a:	83 c4 10             	add    $0x10,%esp
}
  80160d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801610:	c9                   	leave  
  801611:	c3                   	ret    
		return -E_NOT_SUPP;
  801612:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801617:	eb f4                	jmp    80160d <fstat+0x68>

00801619 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	6a 00                	push   $0x0
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	e8 22 02 00 00       	call   80184d <open>
  80162b:	89 c3                	mov    %eax,%ebx
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 1b                	js     80164f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	50                   	push   %eax
  80163b:	e8 65 ff ff ff       	call   8015a5 <fstat>
  801640:	89 c6                	mov    %eax,%esi
	close(fd);
  801642:	89 1c 24             	mov    %ebx,(%esp)
  801645:	e8 27 fc ff ff       	call   801271 <close>
	return r;
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	89 f3                	mov    %esi,%ebx
}
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    

00801658 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
  80165d:	89 c6                	mov    %eax,%esi
  80165f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801661:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801668:	74 27                	je     801691 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80166a:	6a 07                	push   $0x7
  80166c:	68 00 60 80 00       	push   $0x806000
  801671:	56                   	push   %esi
  801672:	ff 35 00 50 80 00    	pushl  0x805000
  801678:	e8 25 12 00 00       	call   8028a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167d:	83 c4 0c             	add    $0xc,%esp
  801680:	6a 00                	push   $0x0
  801682:	53                   	push   %ebx
  801683:	6a 00                	push   $0x0
  801685:	e8 af 11 00 00       	call   802839 <ipc_recv>
}
  80168a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	6a 01                	push   $0x1
  801696:	e8 5f 12 00 00       	call   8028fa <ipc_find_env>
  80169b:	a3 00 50 80 00       	mov    %eax,0x805000
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	eb c5                	jmp    80166a <fsipc+0x12>

008016a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016be:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8016c8:	e8 8b ff ff ff       	call   801658 <fsipc>
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <devfile_flush>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016db:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ea:	e8 69 ff ff ff       	call   801658 <fsipc>
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <devfile_stat>:
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801701:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801706:	ba 00 00 00 00       	mov    $0x0,%edx
  80170b:	b8 05 00 00 00       	mov    $0x5,%eax
  801710:	e8 43 ff ff ff       	call   801658 <fsipc>
  801715:	85 c0                	test   %eax,%eax
  801717:	78 2c                	js     801745 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801719:	83 ec 08             	sub    $0x8,%esp
  80171c:	68 00 60 80 00       	push   $0x806000
  801721:	53                   	push   %ebx
  801722:	e8 b8 f2 ff ff       	call   8009df <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801727:	a1 80 60 80 00       	mov    0x806080,%eax
  80172c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801732:	a1 84 60 80 00       	mov    0x806084,%eax
  801737:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <devfile_write>:
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 40 0c             	mov    0xc(%eax),%eax
  80175a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80175f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801765:	53                   	push   %ebx
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	68 08 60 80 00       	push   $0x806008
  80176e:	e8 5c f4 ff ff       	call   800bcf <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	b8 04 00 00 00       	mov    $0x4,%eax
  80177d:	e8 d6 fe ff ff       	call   801658 <fsipc>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 0b                	js     801794 <devfile_write+0x4a>
	assert(r <= n);
  801789:	39 d8                	cmp    %ebx,%eax
  80178b:	77 0c                	ja     801799 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80178d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801792:	7f 1e                	jg     8017b2 <devfile_write+0x68>
}
  801794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801797:	c9                   	leave  
  801798:	c3                   	ret    
	assert(r <= n);
  801799:	68 04 31 80 00       	push   $0x803104
  80179e:	68 0b 31 80 00       	push   $0x80310b
  8017a3:	68 98 00 00 00       	push   $0x98
  8017a8:	68 20 31 80 00       	push   $0x803120
  8017ad:	e8 d8 e9 ff ff       	call   80018a <_panic>
	assert(r <= PGSIZE);
  8017b2:	68 2b 31 80 00       	push   $0x80312b
  8017b7:	68 0b 31 80 00       	push   $0x80310b
  8017bc:	68 99 00 00 00       	push   $0x99
  8017c1:	68 20 31 80 00       	push   $0x803120
  8017c6:	e8 bf e9 ff ff       	call   80018a <_panic>

008017cb <devfile_read>:
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
  8017d0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017de:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ee:	e8 65 fe ff ff       	call   801658 <fsipc>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 1f                	js     801818 <devfile_read+0x4d>
	assert(r <= n);
  8017f9:	39 f0                	cmp    %esi,%eax
  8017fb:	77 24                	ja     801821 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017fd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801802:	7f 33                	jg     801837 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801804:	83 ec 04             	sub    $0x4,%esp
  801807:	50                   	push   %eax
  801808:	68 00 60 80 00       	push   $0x806000
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	e8 58 f3 ff ff       	call   800b6d <memmove>
	return r;
  801815:	83 c4 10             	add    $0x10,%esp
}
  801818:	89 d8                	mov    %ebx,%eax
  80181a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5e                   	pop    %esi
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    
	assert(r <= n);
  801821:	68 04 31 80 00       	push   $0x803104
  801826:	68 0b 31 80 00       	push   $0x80310b
  80182b:	6a 7c                	push   $0x7c
  80182d:	68 20 31 80 00       	push   $0x803120
  801832:	e8 53 e9 ff ff       	call   80018a <_panic>
	assert(r <= PGSIZE);
  801837:	68 2b 31 80 00       	push   $0x80312b
  80183c:	68 0b 31 80 00       	push   $0x80310b
  801841:	6a 7d                	push   $0x7d
  801843:	68 20 31 80 00       	push   $0x803120
  801848:	e8 3d e9 ff ff       	call   80018a <_panic>

0080184d <open>:
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	56                   	push   %esi
  801851:	53                   	push   %ebx
  801852:	83 ec 1c             	sub    $0x1c,%esp
  801855:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801858:	56                   	push   %esi
  801859:	e8 48 f1 ff ff       	call   8009a6 <strlen>
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801866:	7f 6c                	jg     8018d4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186e:	50                   	push   %eax
  80186f:	e8 79 f8 ff ff       	call   8010ed <fd_alloc>
  801874:	89 c3                	mov    %eax,%ebx
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 3c                	js     8018b9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	56                   	push   %esi
  801881:	68 00 60 80 00       	push   $0x806000
  801886:	e8 54 f1 ff ff       	call   8009df <strcpy>
	fsipcbuf.open.req_omode = mode;
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	b8 01 00 00 00       	mov    $0x1,%eax
  80189b:	e8 b8 fd ff ff       	call   801658 <fsipc>
  8018a0:	89 c3                	mov    %eax,%ebx
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 19                	js     8018c2 <open+0x75>
	return fd2num(fd);
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8018af:	e8 12 f8 ff ff       	call   8010c6 <fd2num>
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	83 c4 10             	add    $0x10,%esp
}
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    
		fd_close(fd, 0);
  8018c2:	83 ec 08             	sub    $0x8,%esp
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ca:	e8 1b f9 ff ff       	call   8011ea <fd_close>
		return r;
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	eb e5                	jmp    8018b9 <open+0x6c>
		return -E_BAD_PATH;
  8018d4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018d9:	eb de                	jmp    8018b9 <open+0x6c>

008018db <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8018eb:	e8 68 fd ff ff       	call   801658 <fsipc>
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	57                   	push   %edi
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
  8018f8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8018fe:	68 10 32 80 00       	push   $0x803210
  801903:	68 90 2c 80 00       	push   $0x802c90
  801908:	e8 73 e9 ff ff       	call   800280 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80190d:	83 c4 08             	add    $0x8,%esp
  801910:	6a 00                	push   $0x0
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 33 ff ff ff       	call   80184d <open>
  80191a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	0f 88 0b 05 00 00    	js     801e36 <spawn+0x544>
  80192b:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 00 02 00 00       	push   $0x200
  801935:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80193b:	50                   	push   %eax
  80193c:	51                   	push   %ecx
  80193d:	e8 f4 fa ff ff       	call   801436 <readn>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	3d 00 02 00 00       	cmp    $0x200,%eax
  80194a:	75 75                	jne    8019c1 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  80194c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801953:	45 4c 46 
  801956:	75 69                	jne    8019c1 <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801958:	b8 07 00 00 00       	mov    $0x7,%eax
  80195d:	cd 30                	int    $0x30
  80195f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801965:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80196b:	85 c0                	test   %eax,%eax
  80196d:	0f 88 b7 04 00 00    	js     801e2a <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801973:	25 ff 03 00 00       	and    $0x3ff,%eax
  801978:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  80197e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801984:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80198a:	b9 11 00 00 00       	mov    $0x11,%ecx
  80198f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801991:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801997:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	68 04 32 80 00       	push   $0x803204
  8019a5:	68 90 2c 80 00       	push   $0x802c90
  8019aa:	e8 d1 e8 ff ff       	call   800280 <cprintf>
  8019af:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019b2:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019b7:	be 00 00 00 00       	mov    $0x0,%esi
  8019bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019bf:	eb 4b                	jmp    801a0c <spawn+0x11a>
		close(fd);
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019ca:	e8 a2 f8 ff ff       	call   801271 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019cf:	83 c4 0c             	add    $0xc,%esp
  8019d2:	68 7f 45 4c 46       	push   $0x464c457f
  8019d7:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019dd:	68 37 31 80 00       	push   $0x803137
  8019e2:	e8 99 e8 ff ff       	call   800280 <cprintf>
		return -E_NOT_EXEC;
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8019f1:	ff ff ff 
  8019f4:	e9 3d 04 00 00       	jmp    801e36 <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	50                   	push   %eax
  8019fd:	e8 a4 ef ff ff       	call   8009a6 <strlen>
  801a02:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a06:	83 c3 01             	add    $0x1,%ebx
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a13:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a16:	85 c0                	test   %eax,%eax
  801a18:	75 df                	jne    8019f9 <spawn+0x107>
  801a1a:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a20:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a26:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a2b:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a2d:	89 fa                	mov    %edi,%edx
  801a2f:	83 e2 fc             	and    $0xfffffffc,%edx
  801a32:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a39:	29 c2                	sub    %eax,%edx
  801a3b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a41:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a44:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a49:	0f 86 0a 04 00 00    	jbe    801e59 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	6a 07                	push   $0x7
  801a54:	68 00 00 40 00       	push   $0x400000
  801a59:	6a 00                	push   $0x0
  801a5b:	e8 71 f3 ff ff       	call   800dd1 <sys_page_alloc>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	0f 88 f3 03 00 00    	js     801e5e <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a6b:	be 00 00 00 00       	mov    $0x0,%esi
  801a70:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a79:	eb 30                	jmp    801aab <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a7b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a81:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801a87:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a90:	57                   	push   %edi
  801a91:	e8 49 ef ff ff       	call   8009df <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a96:	83 c4 04             	add    $0x4,%esp
  801a99:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a9c:	e8 05 ef ff ff       	call   8009a6 <strlen>
  801aa1:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801aa5:	83 c6 01             	add    $0x1,%esi
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801ab1:	7f c8                	jg     801a7b <spawn+0x189>
	}
	argv_store[argc] = 0;
  801ab3:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ab9:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801abf:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ac6:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801acc:	0f 85 86 00 00 00    	jne    801b58 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ad2:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801ad8:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801ade:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801ae1:	89 d0                	mov    %edx,%eax
  801ae3:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ae9:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801aec:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801af1:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801af7:	83 ec 0c             	sub    $0xc,%esp
  801afa:	6a 07                	push   $0x7
  801afc:	68 00 d0 bf ee       	push   $0xeebfd000
  801b01:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b07:	68 00 00 40 00       	push   $0x400000
  801b0c:	6a 00                	push   $0x0
  801b0e:	e8 01 f3 ff ff       	call   800e14 <sys_page_map>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	83 c4 20             	add    $0x20,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	0f 88 46 03 00 00    	js     801e66 <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	68 00 00 40 00       	push   $0x400000
  801b28:	6a 00                	push   $0x0
  801b2a:	e8 27 f3 ff ff       	call   800e56 <sys_page_unmap>
  801b2f:	89 c3                	mov    %eax,%ebx
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	85 c0                	test   %eax,%eax
  801b36:	0f 88 2a 03 00 00    	js     801e66 <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b3c:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b42:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b49:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b50:	00 00 00 
  801b53:	e9 4f 01 00 00       	jmp    801ca7 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b58:	68 c0 31 80 00       	push   $0x8031c0
  801b5d:	68 0b 31 80 00       	push   $0x80310b
  801b62:	68 f8 00 00 00       	push   $0xf8
  801b67:	68 51 31 80 00       	push   $0x803151
  801b6c:	e8 19 e6 ff ff       	call   80018a <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	6a 07                	push   $0x7
  801b76:	68 00 00 40 00       	push   $0x400000
  801b7b:	6a 00                	push   $0x0
  801b7d:	e8 4f f2 ff ff       	call   800dd1 <sys_page_alloc>
  801b82:	83 c4 10             	add    $0x10,%esp
  801b85:	85 c0                	test   %eax,%eax
  801b87:	0f 88 b7 02 00 00    	js     801e44 <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b96:	01 f0                	add    %esi,%eax
  801b98:	50                   	push   %eax
  801b99:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b9f:	e8 59 f9 ff ff       	call   8014fd <seek>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	0f 88 9c 02 00 00    	js     801e4b <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bb8:	29 f0                	sub    %esi,%eax
  801bba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bbf:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801bc4:	0f 47 c1             	cmova  %ecx,%eax
  801bc7:	50                   	push   %eax
  801bc8:	68 00 00 40 00       	push   $0x400000
  801bcd:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bd3:	e8 5e f8 ff ff       	call   801436 <readn>
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	0f 88 6f 02 00 00    	js     801e52 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801bec:	53                   	push   %ebx
  801bed:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801bf3:	68 00 00 40 00       	push   $0x400000
  801bf8:	6a 00                	push   $0x0
  801bfa:	e8 15 f2 ff ff       	call   800e14 <sys_page_map>
  801bff:	83 c4 20             	add    $0x20,%esp
  801c02:	85 c0                	test   %eax,%eax
  801c04:	78 7c                	js     801c82 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	68 00 00 40 00       	push   $0x400000
  801c0e:	6a 00                	push   $0x0
  801c10:	e8 41 f2 ff ff       	call   800e56 <sys_page_unmap>
  801c15:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c18:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c24:	89 fe                	mov    %edi,%esi
  801c26:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c2c:	76 69                	jbe    801c97 <spawn+0x3a5>
		if (i >= filesz) {
  801c2e:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c34:	0f 87 37 ff ff ff    	ja     801b71 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c43:	53                   	push   %ebx
  801c44:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c4a:	e8 82 f1 ff ff       	call   800dd1 <sys_page_alloc>
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	85 c0                	test   %eax,%eax
  801c54:	79 c2                	jns    801c18 <spawn+0x326>
  801c56:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c61:	e8 ec f0 ff ff       	call   800d52 <sys_env_destroy>
	close(fd);
  801c66:	83 c4 04             	add    $0x4,%esp
  801c69:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c6f:	e8 fd f5 ff ff       	call   801271 <close>
	return r;
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801c7d:	e9 b4 01 00 00       	jmp    801e36 <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  801c82:	50                   	push   %eax
  801c83:	68 5d 31 80 00       	push   $0x80315d
  801c88:	68 2b 01 00 00       	push   $0x12b
  801c8d:	68 51 31 80 00       	push   $0x803151
  801c92:	e8 f3 e4 ff ff       	call   80018a <_panic>
  801c97:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c9d:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ca4:	83 c6 20             	add    $0x20,%esi
  801ca7:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cae:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801cb4:	7e 6d                	jle    801d23 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801cb6:	83 3e 01             	cmpl   $0x1,(%esi)
  801cb9:	75 e2                	jne    801c9d <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801cbb:	8b 46 18             	mov    0x18(%esi),%eax
  801cbe:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801cc1:	83 f8 01             	cmp    $0x1,%eax
  801cc4:	19 c0                	sbb    %eax,%eax
  801cc6:	83 e0 fe             	and    $0xfffffffe,%eax
  801cc9:	83 c0 07             	add    $0x7,%eax
  801ccc:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cd2:	8b 4e 04             	mov    0x4(%esi),%ecx
  801cd5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801cdb:	8b 56 10             	mov    0x10(%esi),%edx
  801cde:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801ce4:	8b 7e 14             	mov    0x14(%esi),%edi
  801ce7:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801ced:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801cf7:	74 1a                	je     801d13 <spawn+0x421>
		va -= i;
  801cf9:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801cfb:	01 c7                	add    %eax,%edi
  801cfd:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d03:	01 c2                	add    %eax,%edx
  801d05:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801d0b:	29 c1                	sub    %eax,%ecx
  801d0d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d13:	bf 00 00 00 00       	mov    $0x0,%edi
  801d18:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801d1e:	e9 01 ff ff ff       	jmp    801c24 <spawn+0x332>
	close(fd);
  801d23:	83 ec 0c             	sub    $0xc,%esp
  801d26:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d2c:	e8 40 f5 ff ff       	call   801271 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801d31:	83 c4 08             	add    $0x8,%esp
  801d34:	68 f0 31 80 00       	push   $0x8031f0
  801d39:	68 90 2c 80 00       	push   $0x802c90
  801d3e:	e8 3d e5 ff ff       	call   800280 <cprintf>
  801d43:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801d46:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801d4b:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d51:	eb 0e                	jmp    801d61 <spawn+0x46f>
  801d53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d59:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d5f:	74 5e                	je     801dbf <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	c1 e8 16             	shr    $0x16,%eax
  801d66:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d6d:	a8 01                	test   $0x1,%al
  801d6f:	74 e2                	je     801d53 <spawn+0x461>
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	c1 ea 0c             	shr    $0xc,%edx
  801d76:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d7d:	25 05 04 00 00       	and    $0x405,%eax
  801d82:	3d 05 04 00 00       	cmp    $0x405,%eax
  801d87:	75 ca                	jne    801d53 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801d89:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	25 07 0e 00 00       	and    $0xe07,%eax
  801d98:	50                   	push   %eax
  801d99:	53                   	push   %ebx
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	6a 00                	push   $0x0
  801d9e:	e8 71 f0 ff ff       	call   800e14 <sys_page_map>
  801da3:	83 c4 20             	add    $0x20,%esp
  801da6:	85 c0                	test   %eax,%eax
  801da8:	79 a9                	jns    801d53 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  801daa:	50                   	push   %eax
  801dab:	68 7a 31 80 00       	push   $0x80317a
  801db0:	68 3b 01 00 00       	push   $0x13b
  801db5:	68 51 31 80 00       	push   $0x803151
  801dba:	e8 cb e3 ff ff       	call   80018a <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801dc8:	50                   	push   %eax
  801dc9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dcf:	e8 06 f1 ff ff       	call   800eda <sys_env_set_trapframe>
  801dd4:	83 c4 10             	add    $0x10,%esp
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	78 25                	js     801e00 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801ddb:	83 ec 08             	sub    $0x8,%esp
  801dde:	6a 02                	push   $0x2
  801de0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801de6:	e8 ad f0 ff ff       	call   800e98 <sys_env_set_status>
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	85 c0                	test   %eax,%eax
  801df0:	78 23                	js     801e15 <spawn+0x523>
	return child;
  801df2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801df8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801dfe:	eb 36                	jmp    801e36 <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  801e00:	50                   	push   %eax
  801e01:	68 8c 31 80 00       	push   $0x80318c
  801e06:	68 8a 00 00 00       	push   $0x8a
  801e0b:	68 51 31 80 00       	push   $0x803151
  801e10:	e8 75 e3 ff ff       	call   80018a <_panic>
		panic("sys_env_set_status: %e", r);
  801e15:	50                   	push   %eax
  801e16:	68 a6 31 80 00       	push   $0x8031a6
  801e1b:	68 8d 00 00 00       	push   $0x8d
  801e20:	68 51 31 80 00       	push   $0x803151
  801e25:	e8 60 e3 ff ff       	call   80018a <_panic>
		return r;
  801e2a:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e30:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e36:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5f                   	pop    %edi
  801e42:	5d                   	pop    %ebp
  801e43:	c3                   	ret    
  801e44:	89 c7                	mov    %eax,%edi
  801e46:	e9 0d fe ff ff       	jmp    801c58 <spawn+0x366>
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	e9 06 fe ff ff       	jmp    801c58 <spawn+0x366>
  801e52:	89 c7                	mov    %eax,%edi
  801e54:	e9 ff fd ff ff       	jmp    801c58 <spawn+0x366>
		return -E_NO_MEM;
  801e59:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801e5e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e64:	eb d0                	jmp    801e36 <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  801e66:	83 ec 08             	sub    $0x8,%esp
  801e69:	68 00 00 40 00       	push   $0x400000
  801e6e:	6a 00                	push   $0x0
  801e70:	e8 e1 ef ff ff       	call   800e56 <sys_page_unmap>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801e7e:	eb b6                	jmp    801e36 <spawn+0x544>

00801e80 <spawnl>:
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	57                   	push   %edi
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e89:	68 e8 31 80 00       	push   $0x8031e8
  801e8e:	68 90 2c 80 00       	push   $0x802c90
  801e93:	e8 e8 e3 ff ff       	call   800280 <cprintf>
	va_start(vl, arg0);
  801e98:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801e9b:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ea3:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ea6:	83 3a 00             	cmpl   $0x0,(%edx)
  801ea9:	74 07                	je     801eb2 <spawnl+0x32>
		argc++;
  801eab:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801eae:	89 ca                	mov    %ecx,%edx
  801eb0:	eb f1                	jmp    801ea3 <spawnl+0x23>
	const char *argv[argc+2];
  801eb2:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801eb9:	83 e2 f0             	and    $0xfffffff0,%edx
  801ebc:	29 d4                	sub    %edx,%esp
  801ebe:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ec2:	c1 ea 02             	shr    $0x2,%edx
  801ec5:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ecc:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed1:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801ed8:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801edf:	00 
	va_start(vl, arg0);
  801ee0:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ee3:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	eb 0b                	jmp    801ef7 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801eec:	83 c0 01             	add    $0x1,%eax
  801eef:	8b 39                	mov    (%ecx),%edi
  801ef1:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ef4:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ef7:	39 d0                	cmp    %edx,%eax
  801ef9:	75 f1                	jne    801eec <spawnl+0x6c>
	return spawn(prog, argv);
  801efb:	83 ec 08             	sub    $0x8,%esp
  801efe:	56                   	push   %esi
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	e8 eb f9 ff ff       	call   8018f2 <spawn>
}
  801f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5f                   	pop    %edi
  801f0d:	5d                   	pop    %ebp
  801f0e:	c3                   	ret    

00801f0f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f15:	68 16 32 80 00       	push   $0x803216
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	e8 bd ea ff ff       	call   8009df <strcpy>
	return 0;
}
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <devsock_close>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 10             	sub    $0x10,%esp
  801f30:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f33:	53                   	push   %ebx
  801f34:	e8 00 0a 00 00       	call   802939 <pageref>
  801f39:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f3c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f41:	83 f8 01             	cmp    $0x1,%eax
  801f44:	74 07                	je     801f4d <devsock_close+0x24>
}
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	ff 73 0c             	pushl  0xc(%ebx)
  801f53:	e8 b9 02 00 00       	call   802211 <nsipc_close>
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	eb e7                	jmp    801f46 <devsock_close+0x1d>

00801f5f <devsock_write>:
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	ff 75 10             	pushl  0x10(%ebp)
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	ff 70 0c             	pushl  0xc(%eax)
  801f73:	e8 76 03 00 00       	call   8022ee <nsipc_send>
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <devsock_read>:
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 10             	pushl  0x10(%ebp)
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	ff 70 0c             	pushl  0xc(%eax)
  801f8e:	e8 ef 02 00 00       	call   802282 <nsipc_recv>
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <fd2sockid>:
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f9b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	e8 9a f1 ff ff       	call   80113f <fd_lookup>
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 10                	js     801fbc <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fb5:	39 08                	cmp    %ecx,(%eax)
  801fb7:	75 05                	jne    801fbe <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fb9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    
		return -E_NOT_SUPP;
  801fbe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fc3:	eb f7                	jmp    801fbc <fd2sockid+0x27>

00801fc5 <alloc_sockfd>:
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 1c             	sub    $0x1c,%esp
  801fcd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd2:	50                   	push   %eax
  801fd3:	e8 15 f1 ff ff       	call   8010ed <fd_alloc>
  801fd8:	89 c3                	mov    %eax,%ebx
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 43                	js     802024 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	68 07 04 00 00       	push   $0x407
  801fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fec:	6a 00                	push   $0x0
  801fee:	e8 de ed ff ff       	call   800dd1 <sys_page_alloc>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	78 28                	js     802024 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802005:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802011:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	50                   	push   %eax
  802018:	e8 a9 f0 ff ff       	call   8010c6 <fd2num>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	eb 0c                	jmp    802030 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	56                   	push   %esi
  802028:	e8 e4 01 00 00       	call   802211 <nsipc_close>
		return r;
  80202d:	83 c4 10             	add    $0x10,%esp
}
  802030:	89 d8                	mov    %ebx,%eax
  802032:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5d                   	pop    %ebp
  802038:	c3                   	ret    

00802039 <accept>:
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	e8 4e ff ff ff       	call   801f95 <fd2sockid>
  802047:	85 c0                	test   %eax,%eax
  802049:	78 1b                	js     802066 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	ff 75 10             	pushl  0x10(%ebp)
  802051:	ff 75 0c             	pushl  0xc(%ebp)
  802054:	50                   	push   %eax
  802055:	e8 0e 01 00 00       	call   802168 <nsipc_accept>
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	85 c0                	test   %eax,%eax
  80205f:	78 05                	js     802066 <accept+0x2d>
	return alloc_sockfd(r);
  802061:	e8 5f ff ff ff       	call   801fc5 <alloc_sockfd>
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <bind>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	e8 1f ff ff ff       	call   801f95 <fd2sockid>
  802076:	85 c0                	test   %eax,%eax
  802078:	78 12                	js     80208c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	ff 75 10             	pushl  0x10(%ebp)
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	50                   	push   %eax
  802084:	e8 31 01 00 00       	call   8021ba <nsipc_bind>
  802089:	83 c4 10             	add    $0x10,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <shutdown>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	e8 f9 fe ff ff       	call   801f95 <fd2sockid>
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 0f                	js     8020af <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020a0:	83 ec 08             	sub    $0x8,%esp
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	50                   	push   %eax
  8020a7:	e8 43 01 00 00       	call   8021ef <nsipc_shutdown>
  8020ac:	83 c4 10             	add    $0x10,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <connect>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	e8 d6 fe ff ff       	call   801f95 <fd2sockid>
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	78 12                	js     8020d5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	ff 75 10             	pushl  0x10(%ebp)
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	50                   	push   %eax
  8020cd:	e8 59 01 00 00       	call   80222b <nsipc_connect>
  8020d2:	83 c4 10             	add    $0x10,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <listen>:
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	e8 b0 fe ff ff       	call   801f95 <fd2sockid>
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 0f                	js     8020f8 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020e9:	83 ec 08             	sub    $0x8,%esp
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	50                   	push   %eax
  8020f0:	e8 6b 01 00 00       	call   802260 <nsipc_listen>
  8020f5:	83 c4 10             	add    $0x10,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <socket>:

int
socket(int domain, int type, int protocol)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802100:	ff 75 10             	pushl  0x10(%ebp)
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	e8 3e 02 00 00       	call   80234c <nsipc_socket>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	78 05                	js     80211a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802115:	e8 ab fe ff ff       	call   801fc5 <alloc_sockfd>
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	53                   	push   %ebx
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802125:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80212c:	74 26                	je     802154 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80212e:	6a 07                	push   $0x7
  802130:	68 00 70 80 00       	push   $0x807000
  802135:	53                   	push   %ebx
  802136:	ff 35 04 50 80 00    	pushl  0x805004
  80213c:	e8 61 07 00 00       	call   8028a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802141:	83 c4 0c             	add    $0xc,%esp
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	e8 ea 06 00 00       	call   802839 <ipc_recv>
}
  80214f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802152:	c9                   	leave  
  802153:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802154:	83 ec 0c             	sub    $0xc,%esp
  802157:	6a 02                	push   $0x2
  802159:	e8 9c 07 00 00       	call   8028fa <ipc_find_env>
  80215e:	a3 04 50 80 00       	mov    %eax,0x805004
  802163:	83 c4 10             	add    $0x10,%esp
  802166:	eb c6                	jmp    80212e <nsipc+0x12>

00802168 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
  80216d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802178:	8b 06                	mov    (%esi),%eax
  80217a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80217f:	b8 01 00 00 00       	mov    $0x1,%eax
  802184:	e8 93 ff ff ff       	call   80211c <nsipc>
  802189:	89 c3                	mov    %eax,%ebx
  80218b:	85 c0                	test   %eax,%eax
  80218d:	79 09                	jns    802198 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80218f:	89 d8                	mov    %ebx,%eax
  802191:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5d                   	pop    %ebp
  802197:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	ff 35 10 70 80 00    	pushl  0x807010
  8021a1:	68 00 70 80 00       	push   $0x807000
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	e8 bf e9 ff ff       	call   800b6d <memmove>
		*addrlen = ret->ret_addrlen;
  8021ae:	a1 10 70 80 00       	mov    0x807010,%eax
  8021b3:	89 06                	mov    %eax,(%esi)
  8021b5:	83 c4 10             	add    $0x10,%esp
	return r;
  8021b8:	eb d5                	jmp    80218f <nsipc_accept+0x27>

008021ba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	53                   	push   %ebx
  8021be:	83 ec 08             	sub    $0x8,%esp
  8021c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021cc:	53                   	push   %ebx
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	68 04 70 80 00       	push   $0x807004
  8021d5:	e8 93 e9 ff ff       	call   800b6d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021da:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8021e5:	e8 32 ff ff ff       	call   80211c <nsipc>
}
  8021ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802205:	b8 03 00 00 00       	mov    $0x3,%eax
  80220a:	e8 0d ff ff ff       	call   80211c <nsipc>
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <nsipc_close>:

int
nsipc_close(int s)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80221f:	b8 04 00 00 00       	mov    $0x4,%eax
  802224:	e8 f3 fe ff ff       	call   80211c <nsipc>
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	53                   	push   %ebx
  80222f:	83 ec 08             	sub    $0x8,%esp
  802232:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80223d:	53                   	push   %ebx
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	68 04 70 80 00       	push   $0x807004
  802246:	e8 22 e9 ff ff       	call   800b6d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80224b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802251:	b8 05 00 00 00       	mov    $0x5,%eax
  802256:	e8 c1 fe ff ff       	call   80211c <nsipc>
}
  80225b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80226e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802271:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802276:	b8 06 00 00 00       	mov    $0x6,%eax
  80227b:	e8 9c fe ff ff       	call   80211c <nsipc>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	56                   	push   %esi
  802286:	53                   	push   %ebx
  802287:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802292:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802298:	8b 45 14             	mov    0x14(%ebp),%eax
  80229b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022a0:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a5:	e8 72 fe ff ff       	call   80211c <nsipc>
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	78 1f                	js     8022cf <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022b5:	7f 21                	jg     8022d8 <nsipc_recv+0x56>
  8022b7:	39 c6                	cmp    %eax,%esi
  8022b9:	7c 1d                	jl     8022d8 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	50                   	push   %eax
  8022bf:	68 00 70 80 00       	push   $0x807000
  8022c4:	ff 75 0c             	pushl  0xc(%ebp)
  8022c7:	e8 a1 e8 ff ff       	call   800b6d <memmove>
  8022cc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022cf:	89 d8                	mov    %ebx,%eax
  8022d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022d8:	68 22 32 80 00       	push   $0x803222
  8022dd:	68 0b 31 80 00       	push   $0x80310b
  8022e2:	6a 62                	push   $0x62
  8022e4:	68 37 32 80 00       	push   $0x803237
  8022e9:	e8 9c de ff ff       	call   80018a <_panic>

008022ee <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	53                   	push   %ebx
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802300:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802306:	7f 2e                	jg     802336 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	53                   	push   %ebx
  80230c:	ff 75 0c             	pushl  0xc(%ebp)
  80230f:	68 0c 70 80 00       	push   $0x80700c
  802314:	e8 54 e8 ff ff       	call   800b6d <memmove>
	nsipcbuf.send.req_size = size;
  802319:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80231f:	8b 45 14             	mov    0x14(%ebp),%eax
  802322:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802327:	b8 08 00 00 00       	mov    $0x8,%eax
  80232c:	e8 eb fd ff ff       	call   80211c <nsipc>
}
  802331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802334:	c9                   	leave  
  802335:	c3                   	ret    
	assert(size < 1600);
  802336:	68 43 32 80 00       	push   $0x803243
  80233b:	68 0b 31 80 00       	push   $0x80310b
  802340:	6a 6d                	push   $0x6d
  802342:	68 37 32 80 00       	push   $0x803237
  802347:	e8 3e de ff ff       	call   80018a <_panic>

0080234c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80235a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235d:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802362:	8b 45 10             	mov    0x10(%ebp),%eax
  802365:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80236a:	b8 09 00 00 00       	mov    $0x9,%eax
  80236f:	e8 a8 fd ff ff       	call   80211c <nsipc>
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	56                   	push   %esi
  80237a:	53                   	push   %ebx
  80237b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80237e:	83 ec 0c             	sub    $0xc,%esp
  802381:	ff 75 08             	pushl  0x8(%ebp)
  802384:	e8 4d ed ff ff       	call   8010d6 <fd2data>
  802389:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80238b:	83 c4 08             	add    $0x8,%esp
  80238e:	68 4f 32 80 00       	push   $0x80324f
  802393:	53                   	push   %ebx
  802394:	e8 46 e6 ff ff       	call   8009df <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802399:	8b 46 04             	mov    0x4(%esi),%eax
  80239c:	2b 06                	sub    (%esi),%eax
  80239e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023a4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023ab:	00 00 00 
	stat->st_dev = &devpipe;
  8023ae:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023b5:	40 80 00 
	return 0;
}
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    

008023c4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	53                   	push   %ebx
  8023c8:	83 ec 0c             	sub    $0xc,%esp
  8023cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ce:	53                   	push   %ebx
  8023cf:	6a 00                	push   $0x0
  8023d1:	e8 80 ea ff ff       	call   800e56 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023d6:	89 1c 24             	mov    %ebx,(%esp)
  8023d9:	e8 f8 ec ff ff       	call   8010d6 <fd2data>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	50                   	push   %eax
  8023e2:	6a 00                	push   $0x0
  8023e4:	e8 6d ea ff ff       	call   800e56 <sys_page_unmap>
}
  8023e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <_pipeisclosed>:
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	53                   	push   %ebx
  8023f4:	83 ec 1c             	sub    $0x1c,%esp
  8023f7:	89 c7                	mov    %eax,%edi
  8023f9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023fb:	a1 08 50 80 00       	mov    0x805008,%eax
  802400:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802403:	83 ec 0c             	sub    $0xc,%esp
  802406:	57                   	push   %edi
  802407:	e8 2d 05 00 00       	call   802939 <pageref>
  80240c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80240f:	89 34 24             	mov    %esi,(%esp)
  802412:	e8 22 05 00 00       	call   802939 <pageref>
		nn = thisenv->env_runs;
  802417:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80241d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802420:	83 c4 10             	add    $0x10,%esp
  802423:	39 cb                	cmp    %ecx,%ebx
  802425:	74 1b                	je     802442 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802427:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80242a:	75 cf                	jne    8023fb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80242c:	8b 42 58             	mov    0x58(%edx),%eax
  80242f:	6a 01                	push   $0x1
  802431:	50                   	push   %eax
  802432:	53                   	push   %ebx
  802433:	68 56 32 80 00       	push   $0x803256
  802438:	e8 43 de ff ff       	call   800280 <cprintf>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	eb b9                	jmp    8023fb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802442:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802445:	0f 94 c0             	sete   %al
  802448:	0f b6 c0             	movzbl %al,%eax
}
  80244b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244e:	5b                   	pop    %ebx
  80244f:	5e                   	pop    %esi
  802450:	5f                   	pop    %edi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    

00802453 <devpipe_write>:
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	57                   	push   %edi
  802457:	56                   	push   %esi
  802458:	53                   	push   %ebx
  802459:	83 ec 28             	sub    $0x28,%esp
  80245c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80245f:	56                   	push   %esi
  802460:	e8 71 ec ff ff       	call   8010d6 <fd2data>
  802465:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	bf 00 00 00 00       	mov    $0x0,%edi
  80246f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802472:	74 4f                	je     8024c3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802474:	8b 43 04             	mov    0x4(%ebx),%eax
  802477:	8b 0b                	mov    (%ebx),%ecx
  802479:	8d 51 20             	lea    0x20(%ecx),%edx
  80247c:	39 d0                	cmp    %edx,%eax
  80247e:	72 14                	jb     802494 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802480:	89 da                	mov    %ebx,%edx
  802482:	89 f0                	mov    %esi,%eax
  802484:	e8 65 ff ff ff       	call   8023ee <_pipeisclosed>
  802489:	85 c0                	test   %eax,%eax
  80248b:	75 3b                	jne    8024c8 <devpipe_write+0x75>
			sys_yield();
  80248d:	e8 20 e9 ff ff       	call   800db2 <sys_yield>
  802492:	eb e0                	jmp    802474 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802494:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802497:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80249b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80249e:	89 c2                	mov    %eax,%edx
  8024a0:	c1 fa 1f             	sar    $0x1f,%edx
  8024a3:	89 d1                	mov    %edx,%ecx
  8024a5:	c1 e9 1b             	shr    $0x1b,%ecx
  8024a8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024ab:	83 e2 1f             	and    $0x1f,%edx
  8024ae:	29 ca                	sub    %ecx,%edx
  8024b0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024b4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024b8:	83 c0 01             	add    $0x1,%eax
  8024bb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024be:	83 c7 01             	add    $0x1,%edi
  8024c1:	eb ac                	jmp    80246f <devpipe_write+0x1c>
	return i;
  8024c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c6:	eb 05                	jmp    8024cd <devpipe_write+0x7a>
				return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <devpipe_read>:
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	57                   	push   %edi
  8024d9:	56                   	push   %esi
  8024da:	53                   	push   %ebx
  8024db:	83 ec 18             	sub    $0x18,%esp
  8024de:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024e1:	57                   	push   %edi
  8024e2:	e8 ef eb ff ff       	call   8010d6 <fd2data>
  8024e7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024e9:	83 c4 10             	add    $0x10,%esp
  8024ec:	be 00 00 00 00       	mov    $0x0,%esi
  8024f1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024f4:	75 14                	jne    80250a <devpipe_read+0x35>
	return i;
  8024f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f9:	eb 02                	jmp    8024fd <devpipe_read+0x28>
				return i;
  8024fb:	89 f0                	mov    %esi,%eax
}
  8024fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802500:	5b                   	pop    %ebx
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
			sys_yield();
  802505:	e8 a8 e8 ff ff       	call   800db2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80250a:	8b 03                	mov    (%ebx),%eax
  80250c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80250f:	75 18                	jne    802529 <devpipe_read+0x54>
			if (i > 0)
  802511:	85 f6                	test   %esi,%esi
  802513:	75 e6                	jne    8024fb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802515:	89 da                	mov    %ebx,%edx
  802517:	89 f8                	mov    %edi,%eax
  802519:	e8 d0 fe ff ff       	call   8023ee <_pipeisclosed>
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 e3                	je     802505 <devpipe_read+0x30>
				return 0;
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
  802527:	eb d4                	jmp    8024fd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802529:	99                   	cltd   
  80252a:	c1 ea 1b             	shr    $0x1b,%edx
  80252d:	01 d0                	add    %edx,%eax
  80252f:	83 e0 1f             	and    $0x1f,%eax
  802532:	29 d0                	sub    %edx,%eax
  802534:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802539:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80253c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80253f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802542:	83 c6 01             	add    $0x1,%esi
  802545:	eb aa                	jmp    8024f1 <devpipe_read+0x1c>

00802547 <pipe>:
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	56                   	push   %esi
  80254b:	53                   	push   %ebx
  80254c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80254f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802552:	50                   	push   %eax
  802553:	e8 95 eb ff ff       	call   8010ed <fd_alloc>
  802558:	89 c3                	mov    %eax,%ebx
  80255a:	83 c4 10             	add    $0x10,%esp
  80255d:	85 c0                	test   %eax,%eax
  80255f:	0f 88 23 01 00 00    	js     802688 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 07 04 00 00       	push   $0x407
  80256d:	ff 75 f4             	pushl  -0xc(%ebp)
  802570:	6a 00                	push   $0x0
  802572:	e8 5a e8 ff ff       	call   800dd1 <sys_page_alloc>
  802577:	89 c3                	mov    %eax,%ebx
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	85 c0                	test   %eax,%eax
  80257e:	0f 88 04 01 00 00    	js     802688 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802584:	83 ec 0c             	sub    $0xc,%esp
  802587:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80258a:	50                   	push   %eax
  80258b:	e8 5d eb ff ff       	call   8010ed <fd_alloc>
  802590:	89 c3                	mov    %eax,%ebx
  802592:	83 c4 10             	add    $0x10,%esp
  802595:	85 c0                	test   %eax,%eax
  802597:	0f 88 db 00 00 00    	js     802678 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259d:	83 ec 04             	sub    $0x4,%esp
  8025a0:	68 07 04 00 00       	push   $0x407
  8025a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a8:	6a 00                	push   $0x0
  8025aa:	e8 22 e8 ff ff       	call   800dd1 <sys_page_alloc>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	0f 88 bc 00 00 00    	js     802678 <pipe+0x131>
	va = fd2data(fd0);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c2:	e8 0f eb ff ff       	call   8010d6 <fd2data>
  8025c7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c9:	83 c4 0c             	add    $0xc,%esp
  8025cc:	68 07 04 00 00       	push   $0x407
  8025d1:	50                   	push   %eax
  8025d2:	6a 00                	push   $0x0
  8025d4:	e8 f8 e7 ff ff       	call   800dd1 <sys_page_alloc>
  8025d9:	89 c3                	mov    %eax,%ebx
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	0f 88 82 00 00 00    	js     802668 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e6:	83 ec 0c             	sub    $0xc,%esp
  8025e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ec:	e8 e5 ea ff ff       	call   8010d6 <fd2data>
  8025f1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025f8:	50                   	push   %eax
  8025f9:	6a 00                	push   $0x0
  8025fb:	56                   	push   %esi
  8025fc:	6a 00                	push   $0x0
  8025fe:	e8 11 e8 ff ff       	call   800e14 <sys_page_map>
  802603:	89 c3                	mov    %eax,%ebx
  802605:	83 c4 20             	add    $0x20,%esp
  802608:	85 c0                	test   %eax,%eax
  80260a:	78 4e                	js     80265a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80260c:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802614:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802620:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802623:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 f4             	pushl  -0xc(%ebp)
  802635:	e8 8c ea ff ff       	call   8010c6 <fd2num>
  80263a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80263f:	83 c4 04             	add    $0x4,%esp
  802642:	ff 75 f0             	pushl  -0x10(%ebp)
  802645:	e8 7c ea ff ff       	call   8010c6 <fd2num>
  80264a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	bb 00 00 00 00       	mov    $0x0,%ebx
  802658:	eb 2e                	jmp    802688 <pipe+0x141>
	sys_page_unmap(0, va);
  80265a:	83 ec 08             	sub    $0x8,%esp
  80265d:	56                   	push   %esi
  80265e:	6a 00                	push   $0x0
  802660:	e8 f1 e7 ff ff       	call   800e56 <sys_page_unmap>
  802665:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802668:	83 ec 08             	sub    $0x8,%esp
  80266b:	ff 75 f0             	pushl  -0x10(%ebp)
  80266e:	6a 00                	push   $0x0
  802670:	e8 e1 e7 ff ff       	call   800e56 <sys_page_unmap>
  802675:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802678:	83 ec 08             	sub    $0x8,%esp
  80267b:	ff 75 f4             	pushl  -0xc(%ebp)
  80267e:	6a 00                	push   $0x0
  802680:	e8 d1 e7 ff ff       	call   800e56 <sys_page_unmap>
  802685:	83 c4 10             	add    $0x10,%esp
}
  802688:	89 d8                	mov    %ebx,%eax
  80268a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80268d:	5b                   	pop    %ebx
  80268e:	5e                   	pop    %esi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    

00802691 <pipeisclosed>:
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802697:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269a:	50                   	push   %eax
  80269b:	ff 75 08             	pushl  0x8(%ebp)
  80269e:	e8 9c ea ff ff       	call   80113f <fd_lookup>
  8026a3:	83 c4 10             	add    $0x10,%esp
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	78 18                	js     8026c2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026aa:	83 ec 0c             	sub    $0xc,%esp
  8026ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b0:	e8 21 ea ff ff       	call   8010d6 <fd2data>
	return _pipeisclosed(fd, p);
  8026b5:	89 c2                	mov    %eax,%edx
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	e8 2f fd ff ff       	call   8023ee <_pipeisclosed>
  8026bf:	83 c4 10             	add    $0x10,%esp
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	c3                   	ret    

008026ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026d0:	68 6e 32 80 00       	push   $0x80326e
  8026d5:	ff 75 0c             	pushl  0xc(%ebp)
  8026d8:	e8 02 e3 ff ff       	call   8009df <strcpy>
	return 0;
}
  8026dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e2:	c9                   	leave  
  8026e3:	c3                   	ret    

008026e4 <devcons_write>:
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	57                   	push   %edi
  8026e8:	56                   	push   %esi
  8026e9:	53                   	push   %ebx
  8026ea:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026f0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026f5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026fb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026fe:	73 31                	jae    802731 <devcons_write+0x4d>
		m = n - tot;
  802700:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802703:	29 f3                	sub    %esi,%ebx
  802705:	83 fb 7f             	cmp    $0x7f,%ebx
  802708:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80270d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	53                   	push   %ebx
  802714:	89 f0                	mov    %esi,%eax
  802716:	03 45 0c             	add    0xc(%ebp),%eax
  802719:	50                   	push   %eax
  80271a:	57                   	push   %edi
  80271b:	e8 4d e4 ff ff       	call   800b6d <memmove>
		sys_cputs(buf, m);
  802720:	83 c4 08             	add    $0x8,%esp
  802723:	53                   	push   %ebx
  802724:	57                   	push   %edi
  802725:	e8 eb e5 ff ff       	call   800d15 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80272a:	01 de                	add    %ebx,%esi
  80272c:	83 c4 10             	add    $0x10,%esp
  80272f:	eb ca                	jmp    8026fb <devcons_write+0x17>
}
  802731:	89 f0                	mov    %esi,%eax
  802733:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802736:	5b                   	pop    %ebx
  802737:	5e                   	pop    %esi
  802738:	5f                   	pop    %edi
  802739:	5d                   	pop    %ebp
  80273a:	c3                   	ret    

0080273b <devcons_read>:
{
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	83 ec 08             	sub    $0x8,%esp
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802746:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80274a:	74 21                	je     80276d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80274c:	e8 e2 e5 ff ff       	call   800d33 <sys_cgetc>
  802751:	85 c0                	test   %eax,%eax
  802753:	75 07                	jne    80275c <devcons_read+0x21>
		sys_yield();
  802755:	e8 58 e6 ff ff       	call   800db2 <sys_yield>
  80275a:	eb f0                	jmp    80274c <devcons_read+0x11>
	if (c < 0)
  80275c:	78 0f                	js     80276d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80275e:	83 f8 04             	cmp    $0x4,%eax
  802761:	74 0c                	je     80276f <devcons_read+0x34>
	*(char*)vbuf = c;
  802763:	8b 55 0c             	mov    0xc(%ebp),%edx
  802766:	88 02                	mov    %al,(%edx)
	return 1;
  802768:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    
		return 0;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	eb f7                	jmp    80276d <devcons_read+0x32>

00802776 <cputchar>:
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802782:	6a 01                	push   $0x1
  802784:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802787:	50                   	push   %eax
  802788:	e8 88 e5 ff ff       	call   800d15 <sys_cputs>
}
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	c9                   	leave  
  802791:	c3                   	ret    

00802792 <getchar>:
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802798:	6a 01                	push   $0x1
  80279a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80279d:	50                   	push   %eax
  80279e:	6a 00                	push   $0x0
  8027a0:	e8 0a ec ff ff       	call   8013af <read>
	if (r < 0)
  8027a5:	83 c4 10             	add    $0x10,%esp
  8027a8:	85 c0                	test   %eax,%eax
  8027aa:	78 06                	js     8027b2 <getchar+0x20>
	if (r < 1)
  8027ac:	74 06                	je     8027b4 <getchar+0x22>
	return c;
  8027ae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    
		return -E_EOF;
  8027b4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027b9:	eb f7                	jmp    8027b2 <getchar+0x20>

008027bb <iscons>:
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c4:	50                   	push   %eax
  8027c5:	ff 75 08             	pushl  0x8(%ebp)
  8027c8:	e8 72 e9 ff ff       	call   80113f <fd_lookup>
  8027cd:	83 c4 10             	add    $0x10,%esp
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	78 11                	js     8027e5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027dd:	39 10                	cmp    %edx,(%eax)
  8027df:	0f 94 c0             	sete   %al
  8027e2:	0f b6 c0             	movzbl %al,%eax
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <opencons>:
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f0:	50                   	push   %eax
  8027f1:	e8 f7 e8 ff ff       	call   8010ed <fd_alloc>
  8027f6:	83 c4 10             	add    $0x10,%esp
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	78 3a                	js     802837 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	68 07 04 00 00       	push   $0x407
  802805:	ff 75 f4             	pushl  -0xc(%ebp)
  802808:	6a 00                	push   $0x0
  80280a:	e8 c2 e5 ff ff       	call   800dd1 <sys_page_alloc>
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	85 c0                	test   %eax,%eax
  802814:	78 21                	js     802837 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80281f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	50                   	push   %eax
  80282f:	e8 92 e8 ff ff       	call   8010c6 <fd2num>
  802834:	83 c4 10             	add    $0x10,%esp
}
  802837:	c9                   	leave  
  802838:	c3                   	ret    

00802839 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802839:	55                   	push   %ebp
  80283a:	89 e5                	mov    %esp,%ebp
  80283c:	56                   	push   %esi
  80283d:	53                   	push   %ebx
  80283e:	8b 75 08             	mov    0x8(%ebp),%esi
  802841:	8b 45 0c             	mov    0xc(%ebp),%eax
  802844:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802847:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802849:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80284e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802851:	83 ec 0c             	sub    $0xc,%esp
  802854:	50                   	push   %eax
  802855:	e8 27 e7 ff ff       	call   800f81 <sys_ipc_recv>
	if(ret < 0){
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	85 c0                	test   %eax,%eax
  80285f:	78 2b                	js     80288c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802861:	85 f6                	test   %esi,%esi
  802863:	74 0a                	je     80286f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802865:	a1 08 50 80 00       	mov    0x805008,%eax
  80286a:	8b 40 78             	mov    0x78(%eax),%eax
  80286d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80286f:	85 db                	test   %ebx,%ebx
  802871:	74 0a                	je     80287d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802873:	a1 08 50 80 00       	mov    0x805008,%eax
  802878:	8b 40 7c             	mov    0x7c(%eax),%eax
  80287b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80287d:	a1 08 50 80 00       	mov    0x805008,%eax
  802882:	8b 40 74             	mov    0x74(%eax),%eax
}
  802885:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802888:	5b                   	pop    %ebx
  802889:	5e                   	pop    %esi
  80288a:	5d                   	pop    %ebp
  80288b:	c3                   	ret    
		if(from_env_store)
  80288c:	85 f6                	test   %esi,%esi
  80288e:	74 06                	je     802896 <ipc_recv+0x5d>
			*from_env_store = 0;
  802890:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802896:	85 db                	test   %ebx,%ebx
  802898:	74 eb                	je     802885 <ipc_recv+0x4c>
			*perm_store = 0;
  80289a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028a0:	eb e3                	jmp    802885 <ipc_recv+0x4c>

008028a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	57                   	push   %edi
  8028a6:	56                   	push   %esi
  8028a7:	53                   	push   %ebx
  8028a8:	83 ec 0c             	sub    $0xc,%esp
  8028ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028b4:	85 db                	test   %ebx,%ebx
  8028b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028bb:	0f 44 d8             	cmove  %eax,%ebx
  8028be:	eb 05                	jmp    8028c5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8028c0:	e8 ed e4 ff ff       	call   800db2 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028c5:	ff 75 14             	pushl  0x14(%ebp)
  8028c8:	53                   	push   %ebx
  8028c9:	56                   	push   %esi
  8028ca:	57                   	push   %edi
  8028cb:	e8 8e e6 ff ff       	call   800f5e <sys_ipc_try_send>
  8028d0:	83 c4 10             	add    $0x10,%esp
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 1b                	je     8028f2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028d7:	79 e7                	jns    8028c0 <ipc_send+0x1e>
  8028d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028dc:	74 e2                	je     8028c0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 7a 32 80 00       	push   $0x80327a
  8028e6:	6a 46                	push   $0x46
  8028e8:	68 8f 32 80 00       	push   $0x80328f
  8028ed:	e8 98 d8 ff ff       	call   80018a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028f5:	5b                   	pop    %ebx
  8028f6:	5e                   	pop    %esi
  8028f7:	5f                   	pop    %edi
  8028f8:	5d                   	pop    %ebp
  8028f9:	c3                   	ret    

008028fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802905:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80290b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802911:	8b 52 50             	mov    0x50(%edx),%edx
  802914:	39 ca                	cmp    %ecx,%edx
  802916:	74 11                	je     802929 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802918:	83 c0 01             	add    $0x1,%eax
  80291b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802920:	75 e3                	jne    802905 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	eb 0e                	jmp    802937 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802929:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80292f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802934:	8b 40 48             	mov    0x48(%eax),%eax
}
  802937:	5d                   	pop    %ebp
  802938:	c3                   	ret    

00802939 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80293f:	89 d0                	mov    %edx,%eax
  802941:	c1 e8 16             	shr    $0x16,%eax
  802944:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802950:	f6 c1 01             	test   $0x1,%cl
  802953:	74 1d                	je     802972 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802955:	c1 ea 0c             	shr    $0xc,%edx
  802958:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80295f:	f6 c2 01             	test   $0x1,%dl
  802962:	74 0e                	je     802972 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802964:	c1 ea 0c             	shr    $0xc,%edx
  802967:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80296e:	ef 
  80296f:	0f b7 c0             	movzwl %ax,%eax
}
  802972:	5d                   	pop    %ebp
  802973:	c3                   	ret    
  802974:	66 90                	xchg   %ax,%ax
  802976:	66 90                	xchg   %ax,%ax
  802978:	66 90                	xchg   %ax,%ax
  80297a:	66 90                	xchg   %ax,%ax
  80297c:	66 90                	xchg   %ax,%ax
  80297e:	66 90                	xchg   %ax,%ax

00802980 <__udivdi3>:
  802980:	55                   	push   %ebp
  802981:	57                   	push   %edi
  802982:	56                   	push   %esi
  802983:	53                   	push   %ebx
  802984:	83 ec 1c             	sub    $0x1c,%esp
  802987:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80298b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80298f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802993:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802997:	85 d2                	test   %edx,%edx
  802999:	75 4d                	jne    8029e8 <__udivdi3+0x68>
  80299b:	39 f3                	cmp    %esi,%ebx
  80299d:	76 19                	jbe    8029b8 <__udivdi3+0x38>
  80299f:	31 ff                	xor    %edi,%edi
  8029a1:	89 e8                	mov    %ebp,%eax
  8029a3:	89 f2                	mov    %esi,%edx
  8029a5:	f7 f3                	div    %ebx
  8029a7:	89 fa                	mov    %edi,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	89 d9                	mov    %ebx,%ecx
  8029ba:	85 db                	test   %ebx,%ebx
  8029bc:	75 0b                	jne    8029c9 <__udivdi3+0x49>
  8029be:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c3:	31 d2                	xor    %edx,%edx
  8029c5:	f7 f3                	div    %ebx
  8029c7:	89 c1                	mov    %eax,%ecx
  8029c9:	31 d2                	xor    %edx,%edx
  8029cb:	89 f0                	mov    %esi,%eax
  8029cd:	f7 f1                	div    %ecx
  8029cf:	89 c6                	mov    %eax,%esi
  8029d1:	89 e8                	mov    %ebp,%eax
  8029d3:	89 f7                	mov    %esi,%edi
  8029d5:	f7 f1                	div    %ecx
  8029d7:	89 fa                	mov    %edi,%edx
  8029d9:	83 c4 1c             	add    $0x1c,%esp
  8029dc:	5b                   	pop    %ebx
  8029dd:	5e                   	pop    %esi
  8029de:	5f                   	pop    %edi
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	39 f2                	cmp    %esi,%edx
  8029ea:	77 1c                	ja     802a08 <__udivdi3+0x88>
  8029ec:	0f bd fa             	bsr    %edx,%edi
  8029ef:	83 f7 1f             	xor    $0x1f,%edi
  8029f2:	75 2c                	jne    802a20 <__udivdi3+0xa0>
  8029f4:	39 f2                	cmp    %esi,%edx
  8029f6:	72 06                	jb     8029fe <__udivdi3+0x7e>
  8029f8:	31 c0                	xor    %eax,%eax
  8029fa:	39 eb                	cmp    %ebp,%ebx
  8029fc:	77 a9                	ja     8029a7 <__udivdi3+0x27>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	eb a2                	jmp    8029a7 <__udivdi3+0x27>
  802a05:	8d 76 00             	lea    0x0(%esi),%esi
  802a08:	31 ff                	xor    %edi,%edi
  802a0a:	31 c0                	xor    %eax,%eax
  802a0c:	89 fa                	mov    %edi,%edx
  802a0e:	83 c4 1c             	add    $0x1c,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a1d:	8d 76 00             	lea    0x0(%esi),%esi
  802a20:	89 f9                	mov    %edi,%ecx
  802a22:	b8 20 00 00 00       	mov    $0x20,%eax
  802a27:	29 f8                	sub    %edi,%eax
  802a29:	d3 e2                	shl    %cl,%edx
  802a2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a2f:	89 c1                	mov    %eax,%ecx
  802a31:	89 da                	mov    %ebx,%edx
  802a33:	d3 ea                	shr    %cl,%edx
  802a35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a39:	09 d1                	or     %edx,%ecx
  802a3b:	89 f2                	mov    %esi,%edx
  802a3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a41:	89 f9                	mov    %edi,%ecx
  802a43:	d3 e3                	shl    %cl,%ebx
  802a45:	89 c1                	mov    %eax,%ecx
  802a47:	d3 ea                	shr    %cl,%edx
  802a49:	89 f9                	mov    %edi,%ecx
  802a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a4f:	89 eb                	mov    %ebp,%ebx
  802a51:	d3 e6                	shl    %cl,%esi
  802a53:	89 c1                	mov    %eax,%ecx
  802a55:	d3 eb                	shr    %cl,%ebx
  802a57:	09 de                	or     %ebx,%esi
  802a59:	89 f0                	mov    %esi,%eax
  802a5b:	f7 74 24 08          	divl   0x8(%esp)
  802a5f:	89 d6                	mov    %edx,%esi
  802a61:	89 c3                	mov    %eax,%ebx
  802a63:	f7 64 24 0c          	mull   0xc(%esp)
  802a67:	39 d6                	cmp    %edx,%esi
  802a69:	72 15                	jb     802a80 <__udivdi3+0x100>
  802a6b:	89 f9                	mov    %edi,%ecx
  802a6d:	d3 e5                	shl    %cl,%ebp
  802a6f:	39 c5                	cmp    %eax,%ebp
  802a71:	73 04                	jae    802a77 <__udivdi3+0xf7>
  802a73:	39 d6                	cmp    %edx,%esi
  802a75:	74 09                	je     802a80 <__udivdi3+0x100>
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	31 ff                	xor    %edi,%edi
  802a7b:	e9 27 ff ff ff       	jmp    8029a7 <__udivdi3+0x27>
  802a80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a83:	31 ff                	xor    %edi,%edi
  802a85:	e9 1d ff ff ff       	jmp    8029a7 <__udivdi3+0x27>
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__umoddi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	53                   	push   %ebx
  802a94:	83 ec 1c             	sub    $0x1c,%esp
  802a97:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802aa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aa7:	89 da                	mov    %ebx,%edx
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	75 43                	jne    802af0 <__umoddi3+0x60>
  802aad:	39 df                	cmp    %ebx,%edi
  802aaf:	76 17                	jbe    802ac8 <__umoddi3+0x38>
  802ab1:	89 f0                	mov    %esi,%eax
  802ab3:	f7 f7                	div    %edi
  802ab5:	89 d0                	mov    %edx,%eax
  802ab7:	31 d2                	xor    %edx,%edx
  802ab9:	83 c4 1c             	add    $0x1c,%esp
  802abc:	5b                   	pop    %ebx
  802abd:	5e                   	pop    %esi
  802abe:	5f                   	pop    %edi
  802abf:	5d                   	pop    %ebp
  802ac0:	c3                   	ret    
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	89 fd                	mov    %edi,%ebp
  802aca:	85 ff                	test   %edi,%edi
  802acc:	75 0b                	jne    802ad9 <__umoddi3+0x49>
  802ace:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad3:	31 d2                	xor    %edx,%edx
  802ad5:	f7 f7                	div    %edi
  802ad7:	89 c5                	mov    %eax,%ebp
  802ad9:	89 d8                	mov    %ebx,%eax
  802adb:	31 d2                	xor    %edx,%edx
  802add:	f7 f5                	div    %ebp
  802adf:	89 f0                	mov    %esi,%eax
  802ae1:	f7 f5                	div    %ebp
  802ae3:	89 d0                	mov    %edx,%eax
  802ae5:	eb d0                	jmp    802ab7 <__umoddi3+0x27>
  802ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aee:	66 90                	xchg   %ax,%ax
  802af0:	89 f1                	mov    %esi,%ecx
  802af2:	39 d8                	cmp    %ebx,%eax
  802af4:	76 0a                	jbe    802b00 <__umoddi3+0x70>
  802af6:	89 f0                	mov    %esi,%eax
  802af8:	83 c4 1c             	add    $0x1c,%esp
  802afb:	5b                   	pop    %ebx
  802afc:	5e                   	pop    %esi
  802afd:	5f                   	pop    %edi
  802afe:	5d                   	pop    %ebp
  802aff:	c3                   	ret    
  802b00:	0f bd e8             	bsr    %eax,%ebp
  802b03:	83 f5 1f             	xor    $0x1f,%ebp
  802b06:	75 20                	jne    802b28 <__umoddi3+0x98>
  802b08:	39 d8                	cmp    %ebx,%eax
  802b0a:	0f 82 b0 00 00 00    	jb     802bc0 <__umoddi3+0x130>
  802b10:	39 f7                	cmp    %esi,%edi
  802b12:	0f 86 a8 00 00 00    	jbe    802bc0 <__umoddi3+0x130>
  802b18:	89 c8                	mov    %ecx,%eax
  802b1a:	83 c4 1c             	add    $0x1c,%esp
  802b1d:	5b                   	pop    %ebx
  802b1e:	5e                   	pop    %esi
  802b1f:	5f                   	pop    %edi
  802b20:	5d                   	pop    %ebp
  802b21:	c3                   	ret    
  802b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b2f:	29 ea                	sub    %ebp,%edx
  802b31:	d3 e0                	shl    %cl,%eax
  802b33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b37:	89 d1                	mov    %edx,%ecx
  802b39:	89 f8                	mov    %edi,%eax
  802b3b:	d3 e8                	shr    %cl,%eax
  802b3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b49:	09 c1                	or     %eax,%ecx
  802b4b:	89 d8                	mov    %ebx,%eax
  802b4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b51:	89 e9                	mov    %ebp,%ecx
  802b53:	d3 e7                	shl    %cl,%edi
  802b55:	89 d1                	mov    %edx,%ecx
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b5f:	d3 e3                	shl    %cl,%ebx
  802b61:	89 c7                	mov    %eax,%edi
  802b63:	89 d1                	mov    %edx,%ecx
  802b65:	89 f0                	mov    %esi,%eax
  802b67:	d3 e8                	shr    %cl,%eax
  802b69:	89 e9                	mov    %ebp,%ecx
  802b6b:	89 fa                	mov    %edi,%edx
  802b6d:	d3 e6                	shl    %cl,%esi
  802b6f:	09 d8                	or     %ebx,%eax
  802b71:	f7 74 24 08          	divl   0x8(%esp)
  802b75:	89 d1                	mov    %edx,%ecx
  802b77:	89 f3                	mov    %esi,%ebx
  802b79:	f7 64 24 0c          	mull   0xc(%esp)
  802b7d:	89 c6                	mov    %eax,%esi
  802b7f:	89 d7                	mov    %edx,%edi
  802b81:	39 d1                	cmp    %edx,%ecx
  802b83:	72 06                	jb     802b8b <__umoddi3+0xfb>
  802b85:	75 10                	jne    802b97 <__umoddi3+0x107>
  802b87:	39 c3                	cmp    %eax,%ebx
  802b89:	73 0c                	jae    802b97 <__umoddi3+0x107>
  802b8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b93:	89 d7                	mov    %edx,%edi
  802b95:	89 c6                	mov    %eax,%esi
  802b97:	89 ca                	mov    %ecx,%edx
  802b99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b9e:	29 f3                	sub    %esi,%ebx
  802ba0:	19 fa                	sbb    %edi,%edx
  802ba2:	89 d0                	mov    %edx,%eax
  802ba4:	d3 e0                	shl    %cl,%eax
  802ba6:	89 e9                	mov    %ebp,%ecx
  802ba8:	d3 eb                	shr    %cl,%ebx
  802baa:	d3 ea                	shr    %cl,%edx
  802bac:	09 d8                	or     %ebx,%eax
  802bae:	83 c4 1c             	add    $0x1c,%esp
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    
  802bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bbd:	8d 76 00             	lea    0x0(%esi),%esi
  802bc0:	89 da                	mov    %ebx,%edx
  802bc2:	29 fe                	sub    %edi,%esi
  802bc4:	19 c2                	sbb    %eax,%edx
  802bc6:	89 f1                	mov    %esi,%ecx
  802bc8:	89 c8                	mov    %ecx,%eax
  802bca:	e9 4b ff ff ff       	jmp    802b1a <__umoddi3+0x8a>
