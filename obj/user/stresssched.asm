
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b4 00 00 00       	call   8000e5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 6d 0d 00 00       	call   800daa <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 c9 12 00 00       	call   801312 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 6f 0d 00 00       	call   800dc9 <sys_yield>
		return;
  80005a:	eb 6b                	jmp    8000c7 <umain+0x94>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	89 f2                	mov    %esi,%edx
  800064:	c1 e2 07             	shl    $0x7,%edx
  800067:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006d:	eb 02                	jmp    800071 <umain+0x3e>
		asm volatile("pause");
  80006f:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800071:	8b 42 54             	mov    0x54(%edx),%eax
  800074:	85 c0                	test   %eax,%eax
  800076:	75 f7                	jne    80006f <umain+0x3c>
  800078:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007d:	e8 47 0d 00 00       	call   800dc9 <sys_yield>
  800082:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800087:	a1 08 50 80 00       	mov    0x805008,%eax
  80008c:	83 c0 01             	add    $0x1,%eax
  80008f:	a3 08 50 80 00       	mov    %eax,0x805008
		for (j = 0; j < 10000; j++)
  800094:	83 ea 01             	sub    $0x1,%edx
  800097:	75 ee                	jne    800087 <umain+0x54>
	for (i = 0; i < 10; i++) {
  800099:	83 eb 01             	sub    $0x1,%ebx
  80009c:	75 df                	jne    80007d <umain+0x4a>
	}

	if (counter != 10*10000)
  80009e:	a1 08 50 80 00       	mov    0x805008,%eax
  8000a3:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a8:	75 24                	jne    8000ce <umain+0x9b>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000aa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000af:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b2:	8b 40 48             	mov    0x48(%eax),%eax
  8000b5:	83 ec 04             	sub    $0x4,%esp
  8000b8:	52                   	push   %edx
  8000b9:	50                   	push   %eax
  8000ba:	68 5b 2b 80 00       	push   $0x802b5b
  8000bf:	e8 d3 01 00 00       	call   800297 <cprintf>
  8000c4:	83 c4 10             	add    $0x10,%esp

}
  8000c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000ce:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d3:	50                   	push   %eax
  8000d4:	68 20 2b 80 00       	push   $0x802b20
  8000d9:	6a 21                	push   $0x21
  8000db:	68 48 2b 80 00       	push   $0x802b48
  8000e0:	e8 bc 00 00 00       	call   8001a1 <_panic>

008000e5 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ee:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8000f5:	00 00 00 
	envid_t find = sys_getenvid();
  8000f8:	e8 ad 0c 00 00       	call   800daa <sys_getenvid>
  8000fd:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  800103:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800108:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010d:	bf 01 00 00 00       	mov    $0x1,%edi
  800112:	eb 0b                	jmp    80011f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800114:	83 c2 01             	add    $0x1,%edx
  800117:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011d:	74 21                	je     800140 <libmain+0x5b>
		if(envs[i].env_id == find)
  80011f:	89 d1                	mov    %edx,%ecx
  800121:	c1 e1 07             	shl    $0x7,%ecx
  800124:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80012a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012d:	39 c1                	cmp    %eax,%ecx
  80012f:	75 e3                	jne    800114 <libmain+0x2f>
  800131:	89 d3                	mov    %edx,%ebx
  800133:	c1 e3 07             	shl    $0x7,%ebx
  800136:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013c:	89 fe                	mov    %edi,%esi
  80013e:	eb d4                	jmp    800114 <libmain+0x2f>
  800140:	89 f0                	mov    %esi,%eax
  800142:	84 c0                	test   %al,%al
  800144:	74 06                	je     80014c <libmain+0x67>
  800146:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800150:	7e 0a                	jle    80015c <libmain+0x77>
		binaryname = argv[0];
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	8b 00                	mov    (%eax),%eax
  800157:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	68 79 2b 80 00       	push   $0x802b79
  800164:	e8 2e 01 00 00       	call   800297 <cprintf>
	// call user main routine
	umain(argc, argv);
  800169:	83 c4 08             	add    $0x8,%esp
  80016c:	ff 75 0c             	pushl  0xc(%ebp)
  80016f:	ff 75 08             	pushl  0x8(%ebp)
  800172:	e8 bc fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800177:	e8 0b 00 00 00       	call   800187 <exit>
}
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800182:	5b                   	pop    %ebx
  800183:	5e                   	pop    %esi
  800184:	5f                   	pop    %edi
  800185:	5d                   	pop    %ebp
  800186:	c3                   	ret    

00800187 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018d:	e8 ea 15 00 00       	call   80177c <close_all>
	sys_env_destroy(0);
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	6a 00                	push   $0x0
  800197:	e8 cd 0b 00 00       	call   800d69 <sys_env_destroy>
}
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	c9                   	leave  
  8001a0:	c3                   	ret    

008001a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001a6:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001ab:	8b 40 48             	mov    0x48(%eax),%eax
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 cc 2b 80 00       	push   $0x802bcc
  8001b6:	50                   	push   %eax
  8001b7:	68 9d 2b 80 00       	push   $0x802b9d
  8001bc:	e8 d6 00 00 00       	call   800297 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ca:	e8 db 0b 00 00       	call   800daa <sys_getenvid>
  8001cf:	83 c4 04             	add    $0x4,%esp
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	56                   	push   %esi
  8001d9:	50                   	push   %eax
  8001da:	68 a8 2b 80 00       	push   $0x802ba8
  8001df:	e8 b3 00 00 00       	call   800297 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e4:	83 c4 18             	add    $0x18,%esp
  8001e7:	53                   	push   %ebx
  8001e8:	ff 75 10             	pushl  0x10(%ebp)
  8001eb:	e8 56 00 00 00       	call   800246 <vcprintf>
	cprintf("\n");
  8001f0:	c7 04 24 91 2b 80 00 	movl   $0x802b91,(%esp)
  8001f7:	e8 9b 00 00 00       	call   800297 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ff:	cc                   	int3   
  800200:	eb fd                	jmp    8001ff <_panic+0x5e>

00800202 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	53                   	push   %ebx
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80020c:	8b 13                	mov    (%ebx),%edx
  80020e:	8d 42 01             	lea    0x1(%edx),%eax
  800211:	89 03                	mov    %eax,(%ebx)
  800213:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800216:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80021a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021f:	74 09                	je     80022a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800221:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800228:	c9                   	leave  
  800229:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	68 ff 00 00 00       	push   $0xff
  800232:	8d 43 08             	lea    0x8(%ebx),%eax
  800235:	50                   	push   %eax
  800236:	e8 f1 0a 00 00       	call   800d2c <sys_cputs>
		b->idx = 0;
  80023b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	eb db                	jmp    800221 <putch+0x1f>

00800246 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800246:	55                   	push   %ebp
  800247:	89 e5                	mov    %esp,%ebp
  800249:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800256:	00 00 00 
	b.cnt = 0;
  800259:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800260:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800263:	ff 75 0c             	pushl  0xc(%ebp)
  800266:	ff 75 08             	pushl  0x8(%ebp)
  800269:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026f:	50                   	push   %eax
  800270:	68 02 02 80 00       	push   $0x800202
  800275:	e8 4a 01 00 00       	call   8003c4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80027a:	83 c4 08             	add    $0x8,%esp
  80027d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800283:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800289:	50                   	push   %eax
  80028a:	e8 9d 0a 00 00       	call   800d2c <sys_cputs>

	return b.cnt;
}
  80028f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a0:	50                   	push   %eax
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	e8 9d ff ff ff       	call   800246 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	57                   	push   %edi
  8002af:	56                   	push   %esi
  8002b0:	53                   	push   %ebx
  8002b1:	83 ec 1c             	sub    $0x1c,%esp
  8002b4:	89 c6                	mov    %eax,%esi
  8002b6:	89 d7                	mov    %edx,%edi
  8002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002ca:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ce:	74 2c                	je     8002fc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002e5:	73 43                	jae    80032a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002e7:	83 eb 01             	sub    $0x1,%ebx
  8002ea:	85 db                	test   %ebx,%ebx
  8002ec:	7e 6c                	jle    80035a <printnum+0xaf>
				putch(padc, putdat);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	57                   	push   %edi
  8002f2:	ff 75 18             	pushl  0x18(%ebp)
  8002f5:	ff d6                	call   *%esi
  8002f7:	83 c4 10             	add    $0x10,%esp
  8002fa:	eb eb                	jmp    8002e7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	6a 20                	push   $0x20
  800301:	6a 00                	push   $0x0
  800303:	50                   	push   %eax
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	89 fa                	mov    %edi,%edx
  80030c:	89 f0                	mov    %esi,%eax
  80030e:	e8 98 ff ff ff       	call   8002ab <printnum>
		while (--width > 0)
  800313:	83 c4 20             	add    $0x20,%esp
  800316:	83 eb 01             	sub    $0x1,%ebx
  800319:	85 db                	test   %ebx,%ebx
  80031b:	7e 65                	jle    800382 <printnum+0xd7>
			putch(padc, putdat);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	57                   	push   %edi
  800321:	6a 20                	push   $0x20
  800323:	ff d6                	call   *%esi
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	eb ec                	jmp    800316 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	ff 75 18             	pushl  0x18(%ebp)
  800330:	83 eb 01             	sub    $0x1,%ebx
  800333:	53                   	push   %ebx
  800334:	50                   	push   %eax
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 dc             	pushl  -0x24(%ebp)
  80033b:	ff 75 d8             	pushl  -0x28(%ebp)
  80033e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800341:	ff 75 e0             	pushl  -0x20(%ebp)
  800344:	e8 87 25 00 00       	call   8028d0 <__udivdi3>
  800349:	83 c4 18             	add    $0x18,%esp
  80034c:	52                   	push   %edx
  80034d:	50                   	push   %eax
  80034e:	89 fa                	mov    %edi,%edx
  800350:	89 f0                	mov    %esi,%eax
  800352:	e8 54 ff ff ff       	call   8002ab <printnum>
  800357:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	57                   	push   %edi
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	ff 75 dc             	pushl  -0x24(%ebp)
  800364:	ff 75 d8             	pushl  -0x28(%ebp)
  800367:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036a:	ff 75 e0             	pushl  -0x20(%ebp)
  80036d:	e8 6e 26 00 00       	call   8029e0 <__umoddi3>
  800372:	83 c4 14             	add    $0x14,%esp
  800375:	0f be 80 d3 2b 80 00 	movsbl 0x802bd3(%eax),%eax
  80037c:	50                   	push   %eax
  80037d:	ff d6                	call   *%esi
  80037f:	83 c4 10             	add    $0x10,%esp
	}
}
  800382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800385:	5b                   	pop    %ebx
  800386:	5e                   	pop    %esi
  800387:	5f                   	pop    %edi
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    

0080038a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800390:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800394:	8b 10                	mov    (%eax),%edx
  800396:	3b 50 04             	cmp    0x4(%eax),%edx
  800399:	73 0a                	jae    8003a5 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	88 02                	mov    %al,(%edx)
}
  8003a5:	5d                   	pop    %ebp
  8003a6:	c3                   	ret    

008003a7 <printfmt>:
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ad:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b0:	50                   	push   %eax
  8003b1:	ff 75 10             	pushl  0x10(%ebp)
  8003b4:	ff 75 0c             	pushl  0xc(%ebp)
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	e8 05 00 00 00       	call   8003c4 <vprintfmt>
}
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <vprintfmt>:
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	57                   	push   %edi
  8003c8:	56                   	push   %esi
  8003c9:	53                   	push   %ebx
  8003ca:	83 ec 3c             	sub    $0x3c,%esp
  8003cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d6:	e9 32 04 00 00       	jmp    80080d <vprintfmt+0x449>
		padc = ' ';
  8003db:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003df:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003e6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003ed:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003fb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800402:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8d 47 01             	lea    0x1(%edi),%eax
  80040a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80040d:	0f b6 17             	movzbl (%edi),%edx
  800410:	8d 42 dd             	lea    -0x23(%edx),%eax
  800413:	3c 55                	cmp    $0x55,%al
  800415:	0f 87 12 05 00 00    	ja     80092d <vprintfmt+0x569>
  80041b:	0f b6 c0             	movzbl %al,%eax
  80041e:	ff 24 85 c0 2d 80 00 	jmp    *0x802dc0(,%eax,4)
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800428:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80042c:	eb d9                	jmp    800407 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80042e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800431:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800435:	eb d0                	jmp    800407 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800437:	0f b6 d2             	movzbl %dl,%edx
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80043d:	b8 00 00 00 00       	mov    $0x0,%eax
  800442:	89 75 08             	mov    %esi,0x8(%ebp)
  800445:	eb 03                	jmp    80044a <vprintfmt+0x86>
  800447:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80044a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80044d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800451:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800454:	8d 72 d0             	lea    -0x30(%edx),%esi
  800457:	83 fe 09             	cmp    $0x9,%esi
  80045a:	76 eb                	jbe    800447 <vprintfmt+0x83>
  80045c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045f:	8b 75 08             	mov    0x8(%ebp),%esi
  800462:	eb 14                	jmp    800478 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8d 40 04             	lea    0x4(%eax),%eax
  800472:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800478:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80047c:	79 89                	jns    800407 <vprintfmt+0x43>
				width = precision, precision = -1;
  80047e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800481:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800484:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80048b:	e9 77 ff ff ff       	jmp    800407 <vprintfmt+0x43>
  800490:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	0f 48 c1             	cmovs  %ecx,%eax
  800498:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80049e:	e9 64 ff ff ff       	jmp    800407 <vprintfmt+0x43>
  8004a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004ad:	e9 55 ff ff ff       	jmp    800407 <vprintfmt+0x43>
			lflag++;
  8004b2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b9:	e9 49 ff ff ff       	jmp    800407 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8d 78 04             	lea    0x4(%eax),%edi
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	53                   	push   %ebx
  8004c8:	ff 30                	pushl  (%eax)
  8004ca:	ff d6                	call   *%esi
			break;
  8004cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004d2:	e9 33 03 00 00       	jmp    80080a <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004da:	8d 78 04             	lea    0x4(%eax),%edi
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	99                   	cltd   
  8004e0:	31 d0                	xor    %edx,%eax
  8004e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e4:	83 f8 10             	cmp    $0x10,%eax
  8004e7:	7f 23                	jg     80050c <vprintfmt+0x148>
  8004e9:	8b 14 85 20 2f 80 00 	mov    0x802f20(,%eax,4),%edx
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	74 18                	je     80050c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004f4:	52                   	push   %edx
  8004f5:	68 29 31 80 00       	push   $0x803129
  8004fa:	53                   	push   %ebx
  8004fb:	56                   	push   %esi
  8004fc:	e8 a6 fe ff ff       	call   8003a7 <printfmt>
  800501:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800504:	89 7d 14             	mov    %edi,0x14(%ebp)
  800507:	e9 fe 02 00 00       	jmp    80080a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80050c:	50                   	push   %eax
  80050d:	68 eb 2b 80 00       	push   $0x802beb
  800512:	53                   	push   %ebx
  800513:	56                   	push   %esi
  800514:	e8 8e fe ff ff       	call   8003a7 <printfmt>
  800519:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80051c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051f:	e9 e6 02 00 00       	jmp    80080a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	83 c0 04             	add    $0x4,%eax
  80052a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800532:	85 c9                	test   %ecx,%ecx
  800534:	b8 e4 2b 80 00       	mov    $0x802be4,%eax
  800539:	0f 45 c1             	cmovne %ecx,%eax
  80053c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80053f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800543:	7e 06                	jle    80054b <vprintfmt+0x187>
  800545:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800549:	75 0d                	jne    800558 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80054e:	89 c7                	mov    %eax,%edi
  800550:	03 45 e0             	add    -0x20(%ebp),%eax
  800553:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800556:	eb 53                	jmp    8005ab <vprintfmt+0x1e7>
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	ff 75 d8             	pushl  -0x28(%ebp)
  80055e:	50                   	push   %eax
  80055f:	e8 71 04 00 00       	call   8009d5 <strnlen>
  800564:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800567:	29 c1                	sub    %eax,%ecx
  800569:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800571:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800578:	eb 0f                	jmp    800589 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	ff 75 e0             	pushl  -0x20(%ebp)
  800581:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800583:	83 ef 01             	sub    $0x1,%edi
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	85 ff                	test   %edi,%edi
  80058b:	7f ed                	jg     80057a <vprintfmt+0x1b6>
  80058d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800590:	85 c9                	test   %ecx,%ecx
  800592:	b8 00 00 00 00       	mov    $0x0,%eax
  800597:	0f 49 c1             	cmovns %ecx,%eax
  80059a:	29 c1                	sub    %eax,%ecx
  80059c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80059f:	eb aa                	jmp    80054b <vprintfmt+0x187>
					putch(ch, putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	53                   	push   %ebx
  8005a5:	52                   	push   %edx
  8005a6:	ff d6                	call   *%esi
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ae:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b0:	83 c7 01             	add    $0x1,%edi
  8005b3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b7:	0f be d0             	movsbl %al,%edx
  8005ba:	85 d2                	test   %edx,%edx
  8005bc:	74 4b                	je     800609 <vprintfmt+0x245>
  8005be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005c2:	78 06                	js     8005ca <vprintfmt+0x206>
  8005c4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005c8:	78 1e                	js     8005e8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ca:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ce:	74 d1                	je     8005a1 <vprintfmt+0x1dd>
  8005d0:	0f be c0             	movsbl %al,%eax
  8005d3:	83 e8 20             	sub    $0x20,%eax
  8005d6:	83 f8 5e             	cmp    $0x5e,%eax
  8005d9:	76 c6                	jbe    8005a1 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 3f                	push   $0x3f
  8005e1:	ff d6                	call   *%esi
  8005e3:	83 c4 10             	add    $0x10,%esp
  8005e6:	eb c3                	jmp    8005ab <vprintfmt+0x1e7>
  8005e8:	89 cf                	mov    %ecx,%edi
  8005ea:	eb 0e                	jmp    8005fa <vprintfmt+0x236>
				putch(' ', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 20                	push   $0x20
  8005f2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005f4:	83 ef 01             	sub    $0x1,%edi
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	85 ff                	test   %edi,%edi
  8005fc:	7f ee                	jg     8005ec <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
  800604:	e9 01 02 00 00       	jmp    80080a <vprintfmt+0x446>
  800609:	89 cf                	mov    %ecx,%edi
  80060b:	eb ed                	jmp    8005fa <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80060d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800610:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800617:	e9 eb fd ff ff       	jmp    800407 <vprintfmt+0x43>
	if (lflag >= 2)
  80061c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800620:	7f 21                	jg     800643 <vprintfmt+0x27f>
	else if (lflag)
  800622:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800626:	74 68                	je     800690 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800630:	89 c1                	mov    %eax,%ecx
  800632:	c1 f9 1f             	sar    $0x1f,%ecx
  800635:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 04             	lea    0x4(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
  800641:	eb 17                	jmp    80065a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	8b 50 04             	mov    0x4(%eax),%edx
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8d 40 08             	lea    0x8(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80065a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800666:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80066a:	78 3f                	js     8006ab <vprintfmt+0x2e7>
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800671:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800675:	0f 84 71 01 00 00    	je     8007ec <vprintfmt+0x428>
				putch('+', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2b                	push   $0x2b
  800681:	ff d6                	call   *%esi
  800683:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068b:	e9 5c 01 00 00       	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, int);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800698:	89 c1                	mov    %eax,%ecx
  80069a:	c1 f9 1f             	sar    $0x1f,%ecx
  80069d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	eb af                	jmp    80065a <vprintfmt+0x296>
				putch('-', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 2d                	push   $0x2d
  8006b1:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b9:	f7 d8                	neg    %eax
  8006bb:	83 d2 00             	adc    $0x0,%edx
  8006be:	f7 da                	neg    %edx
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 19 01 00 00       	jmp    8007ec <vprintfmt+0x428>
	if (lflag >= 2)
  8006d3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006d7:	7f 29                	jg     800702 <vprintfmt+0x33e>
	else if (lflag)
  8006d9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006dd:	74 44                	je     800723 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fd:	e9 ea 00 00 00       	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 50 04             	mov    0x4(%eax),%edx
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8d 40 08             	lea    0x8(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800719:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071e:	e9 c9 00 00 00       	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800741:	e9 a6 00 00 00       	jmp    8007ec <vprintfmt+0x428>
			putch('0', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	53                   	push   %ebx
  80074a:	6a 30                	push   $0x30
  80074c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800755:	7f 26                	jg     80077d <vprintfmt+0x3b9>
	else if (lflag)
  800757:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80075b:	74 3e                	je     80079b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
  80077b:	eb 6f                	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 50 04             	mov    0x4(%eax),%edx
  800783:	8b 00                	mov    (%eax),%eax
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 08             	lea    0x8(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800794:	b8 08 00 00 00       	mov    $0x8,%eax
  800799:	eb 51                	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b9:	eb 31                	jmp    8007ec <vprintfmt+0x428>
			putch('0', putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	6a 30                	push   $0x30
  8007c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	6a 78                	push   $0x78
  8007c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007db:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ec:	83 ec 0c             	sub    $0xc,%esp
  8007ef:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007f3:	52                   	push   %edx
  8007f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007fe:	89 da                	mov    %ebx,%edx
  800800:	89 f0                	mov    %esi,%eax
  800802:	e8 a4 fa ff ff       	call   8002ab <printnum>
			break;
  800807:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80080a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080d:	83 c7 01             	add    $0x1,%edi
  800810:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800814:	83 f8 25             	cmp    $0x25,%eax
  800817:	0f 84 be fb ff ff    	je     8003db <vprintfmt+0x17>
			if (ch == '\0')
  80081d:	85 c0                	test   %eax,%eax
  80081f:	0f 84 28 01 00 00    	je     80094d <vprintfmt+0x589>
			putch(ch, putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	50                   	push   %eax
  80082a:	ff d6                	call   *%esi
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	eb dc                	jmp    80080d <vprintfmt+0x449>
	if (lflag >= 2)
  800831:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800835:	7f 26                	jg     80085d <vprintfmt+0x499>
	else if (lflag)
  800837:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80083b:	74 41                	je     80087e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
  80085b:	eb 8f                	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 50 04             	mov    0x4(%eax),%edx
  800863:	8b 00                	mov    (%eax),%eax
  800865:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800868:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 08             	lea    0x8(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800874:	b8 10 00 00 00       	mov    $0x10,%eax
  800879:	e9 6e ff ff ff       	jmp    8007ec <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	ba 00 00 00 00       	mov    $0x0,%edx
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8d 40 04             	lea    0x4(%eax),%eax
  800894:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800897:	b8 10 00 00 00       	mov    $0x10,%eax
  80089c:	e9 4b ff ff ff       	jmp    8007ec <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 c0 04             	add    $0x4,%eax
  8008a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	74 14                	je     8008c7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008b3:	8b 13                	mov    (%ebx),%edx
  8008b5:	83 fa 7f             	cmp    $0x7f,%edx
  8008b8:	7f 37                	jg     8008f1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008ba:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c2:	e9 43 ff ff ff       	jmp    80080a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008cc:	bf 09 2d 80 00       	mov    $0x802d09,%edi
							putch(ch, putdat);
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	53                   	push   %ebx
  8008d5:	50                   	push   %eax
  8008d6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008d8:	83 c7 01             	add    $0x1,%edi
  8008db:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008df:	83 c4 10             	add    $0x10,%esp
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	75 eb                	jne    8008d1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ec:	e9 19 ff ff ff       	jmp    80080a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008f1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f8:	bf 41 2d 80 00       	mov    $0x802d41,%edi
							putch(ch, putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	53                   	push   %ebx
  800901:	50                   	push   %eax
  800902:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800904:	83 c7 01             	add    $0x1,%edi
  800907:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	85 c0                	test   %eax,%eax
  800910:	75 eb                	jne    8008fd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800912:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800915:	89 45 14             	mov    %eax,0x14(%ebp)
  800918:	e9 ed fe ff ff       	jmp    80080a <vprintfmt+0x446>
			putch(ch, putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	53                   	push   %ebx
  800921:	6a 25                	push   $0x25
  800923:	ff d6                	call   *%esi
			break;
  800925:	83 c4 10             	add    $0x10,%esp
  800928:	e9 dd fe ff ff       	jmp    80080a <vprintfmt+0x446>
			putch('%', putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	53                   	push   %ebx
  800931:	6a 25                	push   $0x25
  800933:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	89 f8                	mov    %edi,%eax
  80093a:	eb 03                	jmp    80093f <vprintfmt+0x57b>
  80093c:	83 e8 01             	sub    $0x1,%eax
  80093f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800943:	75 f7                	jne    80093c <vprintfmt+0x578>
  800945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800948:	e9 bd fe ff ff       	jmp    80080a <vprintfmt+0x446>
}
  80094d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 18             	sub    $0x18,%esp
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800961:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800964:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800968:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80096b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800972:	85 c0                	test   %eax,%eax
  800974:	74 26                	je     80099c <vsnprintf+0x47>
  800976:	85 d2                	test   %edx,%edx
  800978:	7e 22                	jle    80099c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097a:	ff 75 14             	pushl  0x14(%ebp)
  80097d:	ff 75 10             	pushl  0x10(%ebp)
  800980:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800983:	50                   	push   %eax
  800984:	68 8a 03 80 00       	push   $0x80038a
  800989:	e8 36 fa ff ff       	call   8003c4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80098e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800991:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800997:	83 c4 10             	add    $0x10,%esp
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    
		return -E_INVAL;
  80099c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009a1:	eb f7                	jmp    80099a <vsnprintf+0x45>

008009a3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ac:	50                   	push   %eax
  8009ad:	ff 75 10             	pushl  0x10(%ebp)
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	ff 75 08             	pushl  0x8(%ebp)
  8009b6:	e8 9a ff ff ff       	call   800955 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009cc:	74 05                	je     8009d3 <strlen+0x16>
		n++;
  8009ce:	83 c0 01             	add    $0x1,%eax
  8009d1:	eb f5                	jmp    8009c8 <strlen+0xb>
	return n;
}
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009de:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e3:	39 c2                	cmp    %eax,%edx
  8009e5:	74 0d                	je     8009f4 <strnlen+0x1f>
  8009e7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009eb:	74 05                	je     8009f2 <strnlen+0x1d>
		n++;
  8009ed:	83 c2 01             	add    $0x1,%edx
  8009f0:	eb f1                	jmp    8009e3 <strnlen+0xe>
  8009f2:	89 d0                	mov    %edx,%eax
	return n;
}
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	53                   	push   %ebx
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a00:	ba 00 00 00 00       	mov    $0x0,%edx
  800a05:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a09:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	84 c9                	test   %cl,%cl
  800a11:	75 f2                	jne    800a05 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a13:	5b                   	pop    %ebx
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 10             	sub    $0x10,%esp
  800a1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a20:	53                   	push   %ebx
  800a21:	e8 97 ff ff ff       	call   8009bd <strlen>
  800a26:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	01 d8                	add    %ebx,%eax
  800a2e:	50                   	push   %eax
  800a2f:	e8 c2 ff ff ff       	call   8009f6 <strcpy>
	return dst;
}
  800a34:	89 d8                	mov    %ebx,%eax
  800a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a39:	c9                   	leave  
  800a3a:	c3                   	ret    

00800a3b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	56                   	push   %esi
  800a3f:	53                   	push   %ebx
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a46:	89 c6                	mov    %eax,%esi
  800a48:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a4b:	89 c2                	mov    %eax,%edx
  800a4d:	39 f2                	cmp    %esi,%edx
  800a4f:	74 11                	je     800a62 <strncpy+0x27>
		*dst++ = *src;
  800a51:	83 c2 01             	add    $0x1,%edx
  800a54:	0f b6 19             	movzbl (%ecx),%ebx
  800a57:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a5a:	80 fb 01             	cmp    $0x1,%bl
  800a5d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a60:	eb eb                	jmp    800a4d <strncpy+0x12>
	}
	return ret;
}
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	56                   	push   %esi
  800a6a:	53                   	push   %ebx
  800a6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a71:	8b 55 10             	mov    0x10(%ebp),%edx
  800a74:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a76:	85 d2                	test   %edx,%edx
  800a78:	74 21                	je     800a9b <strlcpy+0x35>
  800a7a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a7e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a80:	39 c2                	cmp    %eax,%edx
  800a82:	74 14                	je     800a98 <strlcpy+0x32>
  800a84:	0f b6 19             	movzbl (%ecx),%ebx
  800a87:	84 db                	test   %bl,%bl
  800a89:	74 0b                	je     800a96 <strlcpy+0x30>
			*dst++ = *src++;
  800a8b:	83 c1 01             	add    $0x1,%ecx
  800a8e:	83 c2 01             	add    $0x1,%edx
  800a91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a94:	eb ea                	jmp    800a80 <strlcpy+0x1a>
  800a96:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a9b:	29 f0                	sub    %esi,%eax
}
  800a9d:	5b                   	pop    %ebx
  800a9e:	5e                   	pop    %esi
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aaa:	0f b6 01             	movzbl (%ecx),%eax
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 0c                	je     800abd <strcmp+0x1c>
  800ab1:	3a 02                	cmp    (%edx),%al
  800ab3:	75 08                	jne    800abd <strcmp+0x1c>
		p++, q++;
  800ab5:	83 c1 01             	add    $0x1,%ecx
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	eb ed                	jmp    800aaa <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800abd:	0f b6 c0             	movzbl %al,%eax
  800ac0:	0f b6 12             	movzbl (%edx),%edx
  800ac3:	29 d0                	sub    %edx,%eax
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad1:	89 c3                	mov    %eax,%ebx
  800ad3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad6:	eb 06                	jmp    800ade <strncmp+0x17>
		n--, p++, q++;
  800ad8:	83 c0 01             	add    $0x1,%eax
  800adb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ade:	39 d8                	cmp    %ebx,%eax
  800ae0:	74 16                	je     800af8 <strncmp+0x31>
  800ae2:	0f b6 08             	movzbl (%eax),%ecx
  800ae5:	84 c9                	test   %cl,%cl
  800ae7:	74 04                	je     800aed <strncmp+0x26>
  800ae9:	3a 0a                	cmp    (%edx),%cl
  800aeb:	74 eb                	je     800ad8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aed:	0f b6 00             	movzbl (%eax),%eax
  800af0:	0f b6 12             	movzbl (%edx),%edx
  800af3:	29 d0                	sub    %edx,%eax
}
  800af5:	5b                   	pop    %ebx
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    
		return 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
  800afd:	eb f6                	jmp    800af5 <strncmp+0x2e>

00800aff <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b09:	0f b6 10             	movzbl (%eax),%edx
  800b0c:	84 d2                	test   %dl,%dl
  800b0e:	74 09                	je     800b19 <strchr+0x1a>
		if (*s == c)
  800b10:	38 ca                	cmp    %cl,%dl
  800b12:	74 0a                	je     800b1e <strchr+0x1f>
	for (; *s; s++)
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	eb f0                	jmp    800b09 <strchr+0xa>
			return (char *) s;
	return 0;
  800b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b2a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b2d:	38 ca                	cmp    %cl,%dl
  800b2f:	74 09                	je     800b3a <strfind+0x1a>
  800b31:	84 d2                	test   %dl,%dl
  800b33:	74 05                	je     800b3a <strfind+0x1a>
	for (; *s; s++)
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	eb f0                	jmp    800b2a <strfind+0xa>
			break;
	return (char *) s;
}
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b48:	85 c9                	test   %ecx,%ecx
  800b4a:	74 31                	je     800b7d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b4c:	89 f8                	mov    %edi,%eax
  800b4e:	09 c8                	or     %ecx,%eax
  800b50:	a8 03                	test   $0x3,%al
  800b52:	75 23                	jne    800b77 <memset+0x3b>
		c &= 0xFF;
  800b54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b58:	89 d3                	mov    %edx,%ebx
  800b5a:	c1 e3 08             	shl    $0x8,%ebx
  800b5d:	89 d0                	mov    %edx,%eax
  800b5f:	c1 e0 18             	shl    $0x18,%eax
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	c1 e6 10             	shl    $0x10,%esi
  800b67:	09 f0                	or     %esi,%eax
  800b69:	09 c2                	or     %eax,%edx
  800b6b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b6d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b70:	89 d0                	mov    %edx,%eax
  800b72:	fc                   	cld    
  800b73:	f3 ab                	rep stos %eax,%es:(%edi)
  800b75:	eb 06                	jmp    800b7d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	fc                   	cld    
  800b7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b7d:	89 f8                	mov    %edi,%eax
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b92:	39 c6                	cmp    %eax,%esi
  800b94:	73 32                	jae    800bc8 <memmove+0x44>
  800b96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b99:	39 c2                	cmp    %eax,%edx
  800b9b:	76 2b                	jbe    800bc8 <memmove+0x44>
		s += n;
		d += n;
  800b9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba0:	89 fe                	mov    %edi,%esi
  800ba2:	09 ce                	or     %ecx,%esi
  800ba4:	09 d6                	or     %edx,%esi
  800ba6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bac:	75 0e                	jne    800bbc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bae:	83 ef 04             	sub    $0x4,%edi
  800bb1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bb4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bb7:	fd                   	std    
  800bb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bba:	eb 09                	jmp    800bc5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bbc:	83 ef 01             	sub    $0x1,%edi
  800bbf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bc2:	fd                   	std    
  800bc3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bc5:	fc                   	cld    
  800bc6:	eb 1a                	jmp    800be2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	09 ca                	or     %ecx,%edx
  800bcc:	09 f2                	or     %esi,%edx
  800bce:	f6 c2 03             	test   $0x3,%dl
  800bd1:	75 0a                	jne    800bdd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bd3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bd6:	89 c7                	mov    %eax,%edi
  800bd8:	fc                   	cld    
  800bd9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bdb:	eb 05                	jmp    800be2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bdd:	89 c7                	mov    %eax,%edi
  800bdf:	fc                   	cld    
  800be0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bec:	ff 75 10             	pushl  0x10(%ebp)
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	ff 75 08             	pushl  0x8(%ebp)
  800bf5:	e8 8a ff ff ff       	call   800b84 <memmove>
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c07:	89 c6                	mov    %eax,%esi
  800c09:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c0c:	39 f0                	cmp    %esi,%eax
  800c0e:	74 1c                	je     800c2c <memcmp+0x30>
		if (*s1 != *s2)
  800c10:	0f b6 08             	movzbl (%eax),%ecx
  800c13:	0f b6 1a             	movzbl (%edx),%ebx
  800c16:	38 d9                	cmp    %bl,%cl
  800c18:	75 08                	jne    800c22 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	83 c2 01             	add    $0x1,%edx
  800c20:	eb ea                	jmp    800c0c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c22:	0f b6 c1             	movzbl %cl,%eax
  800c25:	0f b6 db             	movzbl %bl,%ebx
  800c28:	29 d8                	sub    %ebx,%eax
  800c2a:	eb 05                	jmp    800c31 <memcmp+0x35>
	}

	return 0;
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c3e:	89 c2                	mov    %eax,%edx
  800c40:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c43:	39 d0                	cmp    %edx,%eax
  800c45:	73 09                	jae    800c50 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c47:	38 08                	cmp    %cl,(%eax)
  800c49:	74 05                	je     800c50 <memfind+0x1b>
	for (; s < ends; s++)
  800c4b:	83 c0 01             	add    $0x1,%eax
  800c4e:	eb f3                	jmp    800c43 <memfind+0xe>
			break;
	return (void *) s;
}
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5e:	eb 03                	jmp    800c63 <strtol+0x11>
		s++;
  800c60:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c63:	0f b6 01             	movzbl (%ecx),%eax
  800c66:	3c 20                	cmp    $0x20,%al
  800c68:	74 f6                	je     800c60 <strtol+0xe>
  800c6a:	3c 09                	cmp    $0x9,%al
  800c6c:	74 f2                	je     800c60 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c6e:	3c 2b                	cmp    $0x2b,%al
  800c70:	74 2a                	je     800c9c <strtol+0x4a>
	int neg = 0;
  800c72:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c77:	3c 2d                	cmp    $0x2d,%al
  800c79:	74 2b                	je     800ca6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c81:	75 0f                	jne    800c92 <strtol+0x40>
  800c83:	80 39 30             	cmpb   $0x30,(%ecx)
  800c86:	74 28                	je     800cb0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c88:	85 db                	test   %ebx,%ebx
  800c8a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8f:	0f 44 d8             	cmove  %eax,%ebx
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
  800c97:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c9a:	eb 50                	jmp    800cec <strtol+0x9a>
		s++;
  800c9c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c9f:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca4:	eb d5                	jmp    800c7b <strtol+0x29>
		s++, neg = 1;
  800ca6:	83 c1 01             	add    $0x1,%ecx
  800ca9:	bf 01 00 00 00       	mov    $0x1,%edi
  800cae:	eb cb                	jmp    800c7b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cb4:	74 0e                	je     800cc4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cb6:	85 db                	test   %ebx,%ebx
  800cb8:	75 d8                	jne    800c92 <strtol+0x40>
		s++, base = 8;
  800cba:	83 c1 01             	add    $0x1,%ecx
  800cbd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cc2:	eb ce                	jmp    800c92 <strtol+0x40>
		s += 2, base = 16;
  800cc4:	83 c1 02             	add    $0x2,%ecx
  800cc7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ccc:	eb c4                	jmp    800c92 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cce:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cd1:	89 f3                	mov    %esi,%ebx
  800cd3:	80 fb 19             	cmp    $0x19,%bl
  800cd6:	77 29                	ja     800d01 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cd8:	0f be d2             	movsbl %dl,%edx
  800cdb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cde:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ce1:	7d 30                	jge    800d13 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800ce3:	83 c1 01             	add    $0x1,%ecx
  800ce6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cea:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cec:	0f b6 11             	movzbl (%ecx),%edx
  800cef:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cf2:	89 f3                	mov    %esi,%ebx
  800cf4:	80 fb 09             	cmp    $0x9,%bl
  800cf7:	77 d5                	ja     800cce <strtol+0x7c>
			dig = *s - '0';
  800cf9:	0f be d2             	movsbl %dl,%edx
  800cfc:	83 ea 30             	sub    $0x30,%edx
  800cff:	eb dd                	jmp    800cde <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d01:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d04:	89 f3                	mov    %esi,%ebx
  800d06:	80 fb 19             	cmp    $0x19,%bl
  800d09:	77 08                	ja     800d13 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d0b:	0f be d2             	movsbl %dl,%edx
  800d0e:	83 ea 37             	sub    $0x37,%edx
  800d11:	eb cb                	jmp    800cde <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d17:	74 05                	je     800d1e <strtol+0xcc>
		*endptr = (char *) s;
  800d19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d1c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d1e:	89 c2                	mov    %eax,%edx
  800d20:	f7 da                	neg    %edx
  800d22:	85 ff                	test   %edi,%edi
  800d24:	0f 45 c2             	cmovne %edx,%eax
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3d:	89 c3                	mov    %eax,%ebx
  800d3f:	89 c7                	mov    %eax,%edi
  800d41:	89 c6                	mov    %eax,%esi
  800d43:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 01 00 00 00       	mov    $0x1,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	89 cb                	mov    %ecx,%ebx
  800d81:	89 cf                	mov    %ecx,%edi
  800d83:	89 ce                	mov    %ecx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 03                	push   $0x3
  800d99:	68 64 2f 80 00       	push   $0x802f64
  800d9e:	6a 43                	push   $0x43
  800da0:	68 81 2f 80 00       	push   $0x802f81
  800da5:	e8 f7 f3 ff ff       	call   8001a1 <_panic>

00800daa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db0:	ba 00 00 00 00       	mov    $0x0,%edx
  800db5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dba:	89 d1                	mov    %edx,%ecx
  800dbc:	89 d3                	mov    %edx,%ebx
  800dbe:	89 d7                	mov    %edx,%edi
  800dc0:	89 d6                	mov    %edx,%esi
  800dc2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_yield>:

void
sys_yield(void)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd9:	89 d1                	mov    %edx,%ecx
  800ddb:	89 d3                	mov    %edx,%ebx
  800ddd:	89 d7                	mov    %edx,%edi
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	be 00 00 00 00       	mov    $0x0,%esi
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfc:	b8 04 00 00 00       	mov    $0x4,%eax
  800e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e04:	89 f7                	mov    %esi,%edi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 04                	push   $0x4
  800e1a:	68 64 2f 80 00       	push   $0x802f64
  800e1f:	6a 43                	push   $0x43
  800e21:	68 81 2f 80 00       	push   $0x802f81
  800e26:	e8 76 f3 ff ff       	call   8001a1 <_panic>

00800e2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e34:	8b 55 08             	mov    0x8(%ebp),%edx
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e45:	8b 75 18             	mov    0x18(%ebp),%esi
  800e48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	7f 08                	jg     800e56 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	6a 05                	push   $0x5
  800e5c:	68 64 2f 80 00       	push   $0x802f64
  800e61:	6a 43                	push   $0x43
  800e63:	68 81 2f 80 00       	push   $0x802f81
  800e68:	e8 34 f3 ff ff       	call   8001a1 <_panic>

00800e6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	b8 06 00 00 00       	mov    $0x6,%eax
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7f 08                	jg     800e98 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e93:	5b                   	pop    %ebx
  800e94:	5e                   	pop    %esi
  800e95:	5f                   	pop    %edi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	50                   	push   %eax
  800e9c:	6a 06                	push   $0x6
  800e9e:	68 64 2f 80 00       	push   $0x802f64
  800ea3:	6a 43                	push   $0x43
  800ea5:	68 81 2f 80 00       	push   $0x802f81
  800eaa:	e8 f2 f2 ff ff       	call   8001a1 <_panic>

00800eaf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	57                   	push   %edi
  800eb3:	56                   	push   %esi
  800eb4:	53                   	push   %ebx
  800eb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec8:	89 df                	mov    %ebx,%edi
  800eca:	89 de                	mov    %ebx,%esi
  800ecc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	7f 08                	jg     800eda <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	83 ec 0c             	sub    $0xc,%esp
  800edd:	50                   	push   %eax
  800ede:	6a 08                	push   $0x8
  800ee0:	68 64 2f 80 00       	push   $0x802f64
  800ee5:	6a 43                	push   $0x43
  800ee7:	68 81 2f 80 00       	push   $0x802f81
  800eec:	e8 b0 f2 ff ff       	call   8001a1 <_panic>

00800ef1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 09                	push   $0x9
  800f22:	68 64 2f 80 00       	push   $0x802f64
  800f27:	6a 43                	push   $0x43
  800f29:	68 81 2f 80 00       	push   $0x802f81
  800f2e:	e8 6e f2 ff ff       	call   8001a1 <_panic>

00800f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
  800f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f4c:	89 df                	mov    %ebx,%edi
  800f4e:	89 de                	mov    %ebx,%esi
  800f50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	7f 08                	jg     800f5e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5e:	83 ec 0c             	sub    $0xc,%esp
  800f61:	50                   	push   %eax
  800f62:	6a 0a                	push   $0xa
  800f64:	68 64 2f 80 00       	push   $0x802f64
  800f69:	6a 43                	push   $0x43
  800f6b:	68 81 2f 80 00       	push   $0x802f81
  800f70:	e8 2c f2 ff ff       	call   8001a1 <_panic>

00800f75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f86:	be 00 00 00 00       	mov    $0x0,%esi
  800f8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f91:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
  800f9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fae:	89 cb                	mov    %ecx,%ebx
  800fb0:	89 cf                	mov    %ecx,%edi
  800fb2:	89 ce                	mov    %ecx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 0d                	push   $0xd
  800fc8:	68 64 2f 80 00       	push   $0x802f64
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 81 2f 80 00       	push   $0x802f81
  800fd4:	e8 c8 f1 ff ff       	call   8001a1 <_panic>

00800fd9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fef:	89 df                	mov    %ebx,%edi
  800ff1:	89 de                	mov    %ebx,%esi
  800ff3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801000:	b9 00 00 00 00       	mov    $0x0,%ecx
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	b8 0f 00 00 00       	mov    $0xf,%eax
  80100d:	89 cb                	mov    %ecx,%ebx
  80100f:	89 cf                	mov    %ecx,%edi
  801011:	89 ce                	mov    %ecx,%esi
  801013:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	ba 00 00 00 00       	mov    $0x0,%edx
  801025:	b8 10 00 00 00       	mov    $0x10,%eax
  80102a:	89 d1                	mov    %edx,%ecx
  80102c:	89 d3                	mov    %edx,%ebx
  80102e:	89 d7                	mov    %edx,%edi
  801030:	89 d6                	mov    %edx,%esi
  801032:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104a:	b8 11 00 00 00       	mov    $0x11,%eax
  80104f:	89 df                	mov    %ebx,%edi
  801051:	89 de                	mov    %ebx,%esi
  801053:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801060:	bb 00 00 00 00       	mov    $0x0,%ebx
  801065:	8b 55 08             	mov    0x8(%ebp),%edx
  801068:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106b:	b8 12 00 00 00       	mov    $0x12,%eax
  801070:	89 df                	mov    %ebx,%edi
  801072:	89 de                	mov    %ebx,%esi
  801074:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801076:	5b                   	pop    %ebx
  801077:	5e                   	pop    %esi
  801078:	5f                   	pop    %edi
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108f:	b8 13 00 00 00       	mov    $0x13,%eax
  801094:	89 df                	mov    %ebx,%edi
  801096:	89 de                	mov    %ebx,%esi
  801098:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	7f 08                	jg     8010a6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	50                   	push   %eax
  8010aa:	6a 13                	push   $0x13
  8010ac:	68 64 2f 80 00       	push   $0x802f64
  8010b1:	6a 43                	push   $0x43
  8010b3:	68 81 2f 80 00       	push   $0x802f81
  8010b8:	e8 e4 f0 ff ff       	call   8001a1 <_panic>

008010bd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	53                   	push   %ebx
  8010c1:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010cb:	f6 c5 04             	test   $0x4,%ch
  8010ce:	75 45                	jne    801115 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010d0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d7:	83 e1 07             	and    $0x7,%ecx
  8010da:	83 f9 07             	cmp    $0x7,%ecx
  8010dd:	74 6f                	je     80114e <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010df:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e6:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010ec:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010f2:	0f 84 b6 00 00 00    	je     8011ae <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010f8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ff:	83 e1 05             	and    $0x5,%ecx
  801102:	83 f9 05             	cmp    $0x5,%ecx
  801105:	0f 84 d7 00 00 00    	je     8011e2 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80110b:	b8 00 00 00 00       	mov    $0x0,%eax
  801110:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801113:	c9                   	leave  
  801114:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801115:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80111c:	c1 e2 0c             	shl    $0xc,%edx
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801128:	51                   	push   %ecx
  801129:	52                   	push   %edx
  80112a:	50                   	push   %eax
  80112b:	52                   	push   %edx
  80112c:	6a 00                	push   $0x0
  80112e:	e8 f8 fc ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801133:	83 c4 20             	add    $0x20,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	79 d1                	jns    80110b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80113a:	83 ec 04             	sub    $0x4,%esp
  80113d:	68 8f 2f 80 00       	push   $0x802f8f
  801142:	6a 54                	push   $0x54
  801144:	68 a5 2f 80 00       	push   $0x802fa5
  801149:	e8 53 f0 ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80114e:	89 d3                	mov    %edx,%ebx
  801150:	c1 e3 0c             	shl    $0xc,%ebx
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	68 05 08 00 00       	push   $0x805
  80115b:	53                   	push   %ebx
  80115c:	50                   	push   %eax
  80115d:	53                   	push   %ebx
  80115e:	6a 00                	push   $0x0
  801160:	e8 c6 fc ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801165:	83 c4 20             	add    $0x20,%esp
  801168:	85 c0                	test   %eax,%eax
  80116a:	78 2e                	js     80119a <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	68 05 08 00 00       	push   $0x805
  801174:	53                   	push   %ebx
  801175:	6a 00                	push   $0x0
  801177:	53                   	push   %ebx
  801178:	6a 00                	push   $0x0
  80117a:	e8 ac fc ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  80117f:	83 c4 20             	add    $0x20,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	79 85                	jns    80110b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	68 8f 2f 80 00       	push   $0x802f8f
  80118e:	6a 5f                	push   $0x5f
  801190:	68 a5 2f 80 00       	push   $0x802fa5
  801195:	e8 07 f0 ff ff       	call   8001a1 <_panic>
			panic("sys_page_map() panic\n");
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	68 8f 2f 80 00       	push   $0x802f8f
  8011a2:	6a 5b                	push   $0x5b
  8011a4:	68 a5 2f 80 00       	push   $0x802fa5
  8011a9:	e8 f3 ef ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ae:	c1 e2 0c             	shl    $0xc,%edx
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 05 08 00 00       	push   $0x805
  8011b9:	52                   	push   %edx
  8011ba:	50                   	push   %eax
  8011bb:	52                   	push   %edx
  8011bc:	6a 00                	push   $0x0
  8011be:	e8 68 fc ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  8011c3:	83 c4 20             	add    $0x20,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	0f 89 3d ff ff ff    	jns    80110b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	68 8f 2f 80 00       	push   $0x802f8f
  8011d6:	6a 66                	push   $0x66
  8011d8:	68 a5 2f 80 00       	push   $0x802fa5
  8011dd:	e8 bf ef ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011e2:	c1 e2 0c             	shl    $0xc,%edx
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	6a 05                	push   $0x5
  8011ea:	52                   	push   %edx
  8011eb:	50                   	push   %eax
  8011ec:	52                   	push   %edx
  8011ed:	6a 00                	push   $0x0
  8011ef:	e8 37 fc ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  8011f4:	83 c4 20             	add    $0x20,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	0f 89 0c ff ff ff    	jns    80110b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	68 8f 2f 80 00       	push   $0x802f8f
  801207:	6a 6d                	push   $0x6d
  801209:	68 a5 2f 80 00       	push   $0x802fa5
  80120e:	e8 8e ef ff ff       	call   8001a1 <_panic>

00801213 <pgfault>:
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	53                   	push   %ebx
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80121d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80121f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801223:	0f 84 99 00 00 00    	je     8012c2 <pgfault+0xaf>
  801229:	89 c2                	mov    %eax,%edx
  80122b:	c1 ea 16             	shr    $0x16,%edx
  80122e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801235:	f6 c2 01             	test   $0x1,%dl
  801238:	0f 84 84 00 00 00    	je     8012c2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80123e:	89 c2                	mov    %eax,%edx
  801240:	c1 ea 0c             	shr    $0xc,%edx
  801243:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801250:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801256:	75 6a                	jne    8012c2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801258:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80125d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80125f:	83 ec 04             	sub    $0x4,%esp
  801262:	6a 07                	push   $0x7
  801264:	68 00 f0 7f 00       	push   $0x7ff000
  801269:	6a 00                	push   $0x0
  80126b:	e8 78 fb ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 5f                	js     8012d6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801277:	83 ec 04             	sub    $0x4,%esp
  80127a:	68 00 10 00 00       	push   $0x1000
  80127f:	53                   	push   %ebx
  801280:	68 00 f0 7f 00       	push   $0x7ff000
  801285:	e8 5c f9 ff ff       	call   800be6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80128a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801291:	53                   	push   %ebx
  801292:	6a 00                	push   $0x0
  801294:	68 00 f0 7f 00       	push   $0x7ff000
  801299:	6a 00                	push   $0x0
  80129b:	e8 8b fb ff ff       	call   800e2b <sys_page_map>
	if(ret < 0)
  8012a0:	83 c4 20             	add    $0x20,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	78 43                	js     8012ea <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	68 00 f0 7f 00       	push   $0x7ff000
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 b7 fb ff ff       	call   800e6d <sys_page_unmap>
	if(ret < 0)
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	78 41                	js     8012fe <pgfault+0xeb>
}
  8012bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	68 b0 2f 80 00       	push   $0x802fb0
  8012ca:	6a 26                	push   $0x26
  8012cc:	68 a5 2f 80 00       	push   $0x802fa5
  8012d1:	e8 cb ee ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	68 c4 2f 80 00       	push   $0x802fc4
  8012de:	6a 31                	push   $0x31
  8012e0:	68 a5 2f 80 00       	push   $0x802fa5
  8012e5:	e8 b7 ee ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_map()\n");
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	68 df 2f 80 00       	push   $0x802fdf
  8012f2:	6a 36                	push   $0x36
  8012f4:	68 a5 2f 80 00       	push   $0x802fa5
  8012f9:	e8 a3 ee ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	68 f8 2f 80 00       	push   $0x802ff8
  801306:	6a 39                	push   $0x39
  801308:	68 a5 2f 80 00       	push   $0x802fa5
  80130d:	e8 8f ee ff ff       	call   8001a1 <_panic>

00801312 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80131b:	68 13 12 80 00       	push   $0x801213
  801320:	e8 d5 13 00 00       	call   8026fa <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801325:	b8 07 00 00 00       	mov    $0x7,%eax
  80132a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 27                	js     80135a <fork+0x48>
  801333:	89 c6                	mov    %eax,%esi
  801335:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801337:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80133c:	75 48                	jne    801386 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80133e:	e8 67 fa ff ff       	call   800daa <sys_getenvid>
  801343:	25 ff 03 00 00       	and    $0x3ff,%eax
  801348:	c1 e0 07             	shl    $0x7,%eax
  80134b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801350:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801355:	e9 90 00 00 00       	jmp    8013ea <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	68 14 30 80 00       	push   $0x803014
  801362:	68 8c 00 00 00       	push   $0x8c
  801367:	68 a5 2f 80 00       	push   $0x802fa5
  80136c:	e8 30 ee ff ff       	call   8001a1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801371:	89 f8                	mov    %edi,%eax
  801373:	e8 45 fd ff ff       	call   8010bd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801378:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80137e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801384:	74 26                	je     8013ac <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801386:	89 d8                	mov    %ebx,%eax
  801388:	c1 e8 16             	shr    $0x16,%eax
  80138b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801392:	a8 01                	test   $0x1,%al
  801394:	74 e2                	je     801378 <fork+0x66>
  801396:	89 da                	mov    %ebx,%edx
  801398:	c1 ea 0c             	shr    $0xc,%edx
  80139b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013a2:	83 e0 05             	and    $0x5,%eax
  8013a5:	83 f8 05             	cmp    $0x5,%eax
  8013a8:	75 ce                	jne    801378 <fork+0x66>
  8013aa:	eb c5                	jmp    801371 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	6a 07                	push   $0x7
  8013b1:	68 00 f0 bf ee       	push   $0xeebff000
  8013b6:	56                   	push   %esi
  8013b7:	e8 2c fa ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 31                	js     8013f4 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	68 69 27 80 00       	push   $0x802769
  8013cb:	56                   	push   %esi
  8013cc:	e8 62 fb ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	78 33                	js     80140b <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013d8:	83 ec 08             	sub    $0x8,%esp
  8013db:	6a 02                	push   $0x2
  8013dd:	56                   	push   %esi
  8013de:	e8 cc fa ff ff       	call   800eaf <sys_env_set_status>
	if(ret < 0)
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 38                	js     801422 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013ea:	89 f0                	mov    %esi,%eax
  8013ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5f                   	pop    %edi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	68 c4 2f 80 00       	push   $0x802fc4
  8013fc:	68 98 00 00 00       	push   $0x98
  801401:	68 a5 2f 80 00       	push   $0x802fa5
  801406:	e8 96 ed ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80140b:	83 ec 04             	sub    $0x4,%esp
  80140e:	68 38 30 80 00       	push   $0x803038
  801413:	68 9b 00 00 00       	push   $0x9b
  801418:	68 a5 2f 80 00       	push   $0x802fa5
  80141d:	e8 7f ed ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	68 60 30 80 00       	push   $0x803060
  80142a:	68 9e 00 00 00       	push   $0x9e
  80142f:	68 a5 2f 80 00       	push   $0x802fa5
  801434:	e8 68 ed ff ff       	call   8001a1 <_panic>

00801439 <sfork>:

// Challenge!
int
sfork(void)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	57                   	push   %edi
  80143d:	56                   	push   %esi
  80143e:	53                   	push   %ebx
  80143f:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801442:	68 13 12 80 00       	push   $0x801213
  801447:	e8 ae 12 00 00       	call   8026fa <set_pgfault_handler>
  80144c:	b8 07 00 00 00       	mov    $0x7,%eax
  801451:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 27                	js     801481 <sfork+0x48>
  80145a:	89 c7                	mov    %eax,%edi
  80145c:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80145e:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801463:	75 55                	jne    8014ba <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801465:	e8 40 f9 ff ff       	call   800daa <sys_getenvid>
  80146a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80146f:	c1 e0 07             	shl    $0x7,%eax
  801472:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801477:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80147c:	e9 d4 00 00 00       	jmp    801555 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	68 14 30 80 00       	push   $0x803014
  801489:	68 af 00 00 00       	push   $0xaf
  80148e:	68 a5 2f 80 00       	push   $0x802fa5
  801493:	e8 09 ed ff ff       	call   8001a1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801498:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80149d:	89 f0                	mov    %esi,%eax
  80149f:	e8 19 fc ff ff       	call   8010bd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014aa:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014b0:	77 65                	ja     801517 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014b2:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014b8:	74 de                	je     801498 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014ba:	89 d8                	mov    %ebx,%eax
  8014bc:	c1 e8 16             	shr    $0x16,%eax
  8014bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014c6:	a8 01                	test   $0x1,%al
  8014c8:	74 da                	je     8014a4 <sfork+0x6b>
  8014ca:	89 da                	mov    %ebx,%edx
  8014cc:	c1 ea 0c             	shr    $0xc,%edx
  8014cf:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014d6:	83 e0 05             	and    $0x5,%eax
  8014d9:	83 f8 05             	cmp    $0x5,%eax
  8014dc:	75 c6                	jne    8014a4 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014de:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014e5:	c1 e2 0c             	shl    $0xc,%edx
  8014e8:	83 ec 0c             	sub    $0xc,%esp
  8014eb:	83 e0 07             	and    $0x7,%eax
  8014ee:	50                   	push   %eax
  8014ef:	52                   	push   %edx
  8014f0:	56                   	push   %esi
  8014f1:	52                   	push   %edx
  8014f2:	6a 00                	push   $0x0
  8014f4:	e8 32 f9 ff ff       	call   800e2b <sys_page_map>
  8014f9:	83 c4 20             	add    $0x20,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	74 a4                	je     8014a4 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	68 8f 2f 80 00       	push   $0x802f8f
  801508:	68 ba 00 00 00       	push   $0xba
  80150d:	68 a5 2f 80 00       	push   $0x802fa5
  801512:	e8 8a ec ff ff       	call   8001a1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	6a 07                	push   $0x7
  80151c:	68 00 f0 bf ee       	push   $0xeebff000
  801521:	57                   	push   %edi
  801522:	e8 c1 f8 ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 31                	js     80155f <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80152e:	83 ec 08             	sub    $0x8,%esp
  801531:	68 69 27 80 00       	push   $0x802769
  801536:	57                   	push   %edi
  801537:	e8 f7 f9 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 33                	js     801576 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	6a 02                	push   $0x2
  801548:	57                   	push   %edi
  801549:	e8 61 f9 ff ff       	call   800eaf <sys_env_set_status>
	if(ret < 0)
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 38                	js     80158d <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801555:	89 f8                	mov    %edi,%eax
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 c4 2f 80 00       	push   $0x802fc4
  801567:	68 c0 00 00 00       	push   $0xc0
  80156c:	68 a5 2f 80 00       	push   $0x802fa5
  801571:	e8 2b ec ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 38 30 80 00       	push   $0x803038
  80157e:	68 c3 00 00 00       	push   $0xc3
  801583:	68 a5 2f 80 00       	push   $0x802fa5
  801588:	e8 14 ec ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 60 30 80 00       	push   $0x803060
  801595:	68 c6 00 00 00       	push   $0xc6
  80159a:	68 a5 2f 80 00       	push   $0x802fa5
  80159f:	e8 fd eb ff ff       	call   8001a1 <_panic>

008015a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8015af:	c1 e8 0c             	shr    $0xc,%eax
}
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    

008015b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    

008015cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d3:	89 c2                	mov    %eax,%edx
  8015d5:	c1 ea 16             	shr    $0x16,%edx
  8015d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015df:	f6 c2 01             	test   $0x1,%dl
  8015e2:	74 2d                	je     801611 <fd_alloc+0x46>
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	c1 ea 0c             	shr    $0xc,%edx
  8015e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f0:	f6 c2 01             	test   $0x1,%dl
  8015f3:	74 1c                	je     801611 <fd_alloc+0x46>
  8015f5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015fa:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015ff:	75 d2                	jne    8015d3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80160a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80160f:	eb 0a                	jmp    80161b <fd_alloc+0x50>
			*fd_store = fd;
  801611:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801614:	89 01                	mov    %eax,(%ecx)
			return 0;
  801616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801623:	83 f8 1f             	cmp    $0x1f,%eax
  801626:	77 30                	ja     801658 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801628:	c1 e0 0c             	shl    $0xc,%eax
  80162b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801630:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801636:	f6 c2 01             	test   $0x1,%dl
  801639:	74 24                	je     80165f <fd_lookup+0x42>
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	c1 ea 0c             	shr    $0xc,%edx
  801640:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801647:	f6 c2 01             	test   $0x1,%dl
  80164a:	74 1a                	je     801666 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	89 02                	mov    %eax,(%edx)
	return 0;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    
		return -E_INVAL;
  801658:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165d:	eb f7                	jmp    801656 <fd_lookup+0x39>
		return -E_INVAL;
  80165f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801664:	eb f0                	jmp    801656 <fd_lookup+0x39>
  801666:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166b:	eb e9                	jmp    801656 <fd_lookup+0x39>

0080166d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801676:	ba 00 00 00 00       	mov    $0x0,%edx
  80167b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801680:	39 08                	cmp    %ecx,(%eax)
  801682:	74 38                	je     8016bc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801684:	83 c2 01             	add    $0x1,%edx
  801687:	8b 04 95 fc 30 80 00 	mov    0x8030fc(,%edx,4),%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 ee                	jne    801680 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801692:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801697:	8b 40 48             	mov    0x48(%eax),%eax
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	51                   	push   %ecx
  80169e:	50                   	push   %eax
  80169f:	68 80 30 80 00       	push   $0x803080
  8016a4:	e8 ee eb ff ff       	call   800297 <cprintf>
	*dev = 0;
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    
			*dev = devtab[i];
  8016bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	eb f2                	jmp    8016ba <dev_lookup+0x4d>

008016c8 <fd_close>:
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 24             	sub    $0x24,%esp
  8016d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e4:	50                   	push   %eax
  8016e5:	e8 33 ff ff ff       	call   80161d <fd_lookup>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 05                	js     8016f8 <fd_close+0x30>
	    || fd != fd2)
  8016f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016f6:	74 16                	je     80170e <fd_close+0x46>
		return (must_exist ? r : 0);
  8016f8:	89 f8                	mov    %edi,%eax
  8016fa:	84 c0                	test   %al,%al
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801701:	0f 44 d8             	cmove  %eax,%ebx
}
  801704:	89 d8                	mov    %ebx,%eax
  801706:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801709:	5b                   	pop    %ebx
  80170a:	5e                   	pop    %esi
  80170b:	5f                   	pop    %edi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801714:	50                   	push   %eax
  801715:	ff 36                	pushl  (%esi)
  801717:	e8 51 ff ff ff       	call   80166d <dev_lookup>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 1a                	js     80173f <fd_close+0x77>
		if (dev->dev_close)
  801725:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801728:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80172b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801730:	85 c0                	test   %eax,%eax
  801732:	74 0b                	je     80173f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	56                   	push   %esi
  801738:	ff d0                	call   *%eax
  80173a:	89 c3                	mov    %eax,%ebx
  80173c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	56                   	push   %esi
  801743:	6a 00                	push   $0x0
  801745:	e8 23 f7 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	eb b5                	jmp    801704 <fd_close+0x3c>

0080174f <close>:

int
close(int fdnum)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801755:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801758:	50                   	push   %eax
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	e8 bc fe ff ff       	call   80161d <fd_lookup>
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	79 02                	jns    80176a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    
		return fd_close(fd, 1);
  80176a:	83 ec 08             	sub    $0x8,%esp
  80176d:	6a 01                	push   $0x1
  80176f:	ff 75 f4             	pushl  -0xc(%ebp)
  801772:	e8 51 ff ff ff       	call   8016c8 <fd_close>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	eb ec                	jmp    801768 <close+0x19>

0080177c <close_all>:

void
close_all(void)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	53                   	push   %ebx
  801780:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801783:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	53                   	push   %ebx
  80178c:	e8 be ff ff ff       	call   80174f <close>
	for (i = 0; i < MAXFD; i++)
  801791:	83 c3 01             	add    $0x1,%ebx
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	83 fb 20             	cmp    $0x20,%ebx
  80179a:	75 ec                	jne    801788 <close_all+0xc>
}
  80179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	57                   	push   %edi
  8017a5:	56                   	push   %esi
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017ad:	50                   	push   %eax
  8017ae:	ff 75 08             	pushl  0x8(%ebp)
  8017b1:	e8 67 fe ff ff       	call   80161d <fd_lookup>
  8017b6:	89 c3                	mov    %eax,%ebx
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	0f 88 81 00 00 00    	js     801844 <dup+0xa3>
		return r;
	close(newfdnum);
  8017c3:	83 ec 0c             	sub    $0xc,%esp
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	e8 81 ff ff ff       	call   80174f <close>

	newfd = INDEX2FD(newfdnum);
  8017ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017d1:	c1 e6 0c             	shl    $0xc,%esi
  8017d4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017da:	83 c4 04             	add    $0x4,%esp
  8017dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017e0:	e8 cf fd ff ff       	call   8015b4 <fd2data>
  8017e5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017e7:	89 34 24             	mov    %esi,(%esp)
  8017ea:	e8 c5 fd ff ff       	call   8015b4 <fd2data>
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017f4:	89 d8                	mov    %ebx,%eax
  8017f6:	c1 e8 16             	shr    $0x16,%eax
  8017f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801800:	a8 01                	test   $0x1,%al
  801802:	74 11                	je     801815 <dup+0x74>
  801804:	89 d8                	mov    %ebx,%eax
  801806:	c1 e8 0c             	shr    $0xc,%eax
  801809:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801810:	f6 c2 01             	test   $0x1,%dl
  801813:	75 39                	jne    80184e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801818:	89 d0                	mov    %edx,%eax
  80181a:	c1 e8 0c             	shr    $0xc,%eax
  80181d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	25 07 0e 00 00       	and    $0xe07,%eax
  80182c:	50                   	push   %eax
  80182d:	56                   	push   %esi
  80182e:	6a 00                	push   $0x0
  801830:	52                   	push   %edx
  801831:	6a 00                	push   $0x0
  801833:	e8 f3 f5 ff ff       	call   800e2b <sys_page_map>
  801838:	89 c3                	mov    %eax,%ebx
  80183a:	83 c4 20             	add    $0x20,%esp
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 31                	js     801872 <dup+0xd1>
		goto err;

	return newfdnum;
  801841:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801844:	89 d8                	mov    %ebx,%eax
  801846:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5f                   	pop    %edi
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80184e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	25 07 0e 00 00       	and    $0xe07,%eax
  80185d:	50                   	push   %eax
  80185e:	57                   	push   %edi
  80185f:	6a 00                	push   $0x0
  801861:	53                   	push   %ebx
  801862:	6a 00                	push   $0x0
  801864:	e8 c2 f5 ff ff       	call   800e2b <sys_page_map>
  801869:	89 c3                	mov    %eax,%ebx
  80186b:	83 c4 20             	add    $0x20,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	79 a3                	jns    801815 <dup+0x74>
	sys_page_unmap(0, newfd);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	56                   	push   %esi
  801876:	6a 00                	push   $0x0
  801878:	e8 f0 f5 ff ff       	call   800e6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80187d:	83 c4 08             	add    $0x8,%esp
  801880:	57                   	push   %edi
  801881:	6a 00                	push   $0x0
  801883:	e8 e5 f5 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	eb b7                	jmp    801844 <dup+0xa3>

0080188d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	53                   	push   %ebx
  801891:	83 ec 1c             	sub    $0x1c,%esp
  801894:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801897:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189a:	50                   	push   %eax
  80189b:	53                   	push   %ebx
  80189c:	e8 7c fd ff ff       	call   80161d <fd_lookup>
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	78 3f                	js     8018e7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ae:	50                   	push   %eax
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	ff 30                	pushl  (%eax)
  8018b4:	e8 b4 fd ff ff       	call   80166d <dev_lookup>
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 27                	js     8018e7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c3:	8b 42 08             	mov    0x8(%edx),%eax
  8018c6:	83 e0 03             	and    $0x3,%eax
  8018c9:	83 f8 01             	cmp    $0x1,%eax
  8018cc:	74 1e                	je     8018ec <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d1:	8b 40 08             	mov    0x8(%eax),%eax
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	74 35                	je     80190d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	52                   	push   %edx
  8018e2:	ff d0                	call   *%eax
  8018e4:	83 c4 10             	add    $0x10,%esp
}
  8018e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ec:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8018f1:	8b 40 48             	mov    0x48(%eax),%eax
  8018f4:	83 ec 04             	sub    $0x4,%esp
  8018f7:	53                   	push   %ebx
  8018f8:	50                   	push   %eax
  8018f9:	68 c1 30 80 00       	push   $0x8030c1
  8018fe:	e8 94 e9 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190b:	eb da                	jmp    8018e7 <read+0x5a>
		return -E_NOT_SUPP;
  80190d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801912:	eb d3                	jmp    8018e7 <read+0x5a>

00801914 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	57                   	push   %edi
  801918:	56                   	push   %esi
  801919:	53                   	push   %ebx
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801920:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801923:	bb 00 00 00 00       	mov    $0x0,%ebx
  801928:	39 f3                	cmp    %esi,%ebx
  80192a:	73 23                	jae    80194f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	89 f0                	mov    %esi,%eax
  801931:	29 d8                	sub    %ebx,%eax
  801933:	50                   	push   %eax
  801934:	89 d8                	mov    %ebx,%eax
  801936:	03 45 0c             	add    0xc(%ebp),%eax
  801939:	50                   	push   %eax
  80193a:	57                   	push   %edi
  80193b:	e8 4d ff ff ff       	call   80188d <read>
		if (m < 0)
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	85 c0                	test   %eax,%eax
  801945:	78 06                	js     80194d <readn+0x39>
			return m;
		if (m == 0)
  801947:	74 06                	je     80194f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801949:	01 c3                	add    %eax,%ebx
  80194b:	eb db                	jmp    801928 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80194d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80194f:	89 d8                	mov    %ebx,%eax
  801951:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	53                   	push   %ebx
  80195d:	83 ec 1c             	sub    $0x1c,%esp
  801960:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801963:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801966:	50                   	push   %eax
  801967:	53                   	push   %ebx
  801968:	e8 b0 fc ff ff       	call   80161d <fd_lookup>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 3a                	js     8019ae <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197a:	50                   	push   %eax
  80197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197e:	ff 30                	pushl  (%eax)
  801980:	e8 e8 fc ff ff       	call   80166d <dev_lookup>
  801985:	83 c4 10             	add    $0x10,%esp
  801988:	85 c0                	test   %eax,%eax
  80198a:	78 22                	js     8019ae <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801993:	74 1e                	je     8019b3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801995:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801998:	8b 52 0c             	mov    0xc(%edx),%edx
  80199b:	85 d2                	test   %edx,%edx
  80199d:	74 35                	je     8019d4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	ff 75 10             	pushl  0x10(%ebp)
  8019a5:	ff 75 0c             	pushl  0xc(%ebp)
  8019a8:	50                   	push   %eax
  8019a9:	ff d2                	call   *%edx
  8019ab:	83 c4 10             	add    $0x10,%esp
}
  8019ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019b3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019b8:	8b 40 48             	mov    0x48(%eax),%eax
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	53                   	push   %ebx
  8019bf:	50                   	push   %eax
  8019c0:	68 dd 30 80 00       	push   $0x8030dd
  8019c5:	e8 cd e8 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d2:	eb da                	jmp    8019ae <write+0x55>
		return -E_NOT_SUPP;
  8019d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d9:	eb d3                	jmp    8019ae <write+0x55>

008019db <seek>:

int
seek(int fdnum, off_t offset)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e4:	50                   	push   %eax
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	e8 30 fc ff ff       	call   80161d <fd_lookup>
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 0e                	js     801a02 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	53                   	push   %ebx
  801a08:	83 ec 1c             	sub    $0x1c,%esp
  801a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a11:	50                   	push   %eax
  801a12:	53                   	push   %ebx
  801a13:	e8 05 fc ff ff       	call   80161d <fd_lookup>
  801a18:	83 c4 10             	add    $0x10,%esp
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 37                	js     801a56 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a25:	50                   	push   %eax
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	ff 30                	pushl  (%eax)
  801a2b:	e8 3d fc ff ff       	call   80166d <dev_lookup>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 1f                	js     801a56 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3e:	74 1b                	je     801a5b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a43:	8b 52 18             	mov    0x18(%edx),%edx
  801a46:	85 d2                	test   %edx,%edx
  801a48:	74 32                	je     801a7c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a4a:	83 ec 08             	sub    $0x8,%esp
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	50                   	push   %eax
  801a51:	ff d2                	call   *%edx
  801a53:	83 c4 10             	add    $0x10,%esp
}
  801a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a5b:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a60:	8b 40 48             	mov    0x48(%eax),%eax
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	53                   	push   %ebx
  801a67:	50                   	push   %eax
  801a68:	68 a0 30 80 00       	push   $0x8030a0
  801a6d:	e8 25 e8 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a7a:	eb da                	jmp    801a56 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a7c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a81:	eb d3                	jmp    801a56 <ftruncate+0x52>

00801a83 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 1c             	sub    $0x1c,%esp
  801a8a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	ff 75 08             	pushl  0x8(%ebp)
  801a94:	e8 84 fb ff ff       	call   80161d <fd_lookup>
  801a99:	83 c4 10             	add    $0x10,%esp
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 4b                	js     801aeb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa0:	83 ec 08             	sub    $0x8,%esp
  801aa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa6:	50                   	push   %eax
  801aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaa:	ff 30                	pushl  (%eax)
  801aac:	e8 bc fb ff ff       	call   80166d <dev_lookup>
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	78 33                	js     801aeb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801abf:	74 2f                	je     801af0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ac1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ac4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801acb:	00 00 00 
	stat->st_isdir = 0;
  801ace:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad5:	00 00 00 
	stat->st_dev = dev;
  801ad8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ade:	83 ec 08             	sub    $0x8,%esp
  801ae1:	53                   	push   %ebx
  801ae2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae5:	ff 50 14             	call   *0x14(%eax)
  801ae8:	83 c4 10             	add    $0x10,%esp
}
  801aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    
		return -E_NOT_SUPP;
  801af0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af5:	eb f4                	jmp    801aeb <fstat+0x68>

00801af7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	6a 00                	push   $0x0
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	e8 22 02 00 00       	call   801d2b <open>
  801b09:	89 c3                	mov    %eax,%ebx
  801b0b:	83 c4 10             	add    $0x10,%esp
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	78 1b                	js     801b2d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b12:	83 ec 08             	sub    $0x8,%esp
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	50                   	push   %eax
  801b19:	e8 65 ff ff ff       	call   801a83 <fstat>
  801b1e:	89 c6                	mov    %eax,%esi
	close(fd);
  801b20:	89 1c 24             	mov    %ebx,(%esp)
  801b23:	e8 27 fc ff ff       	call   80174f <close>
	return r;
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	89 f3                	mov    %esi,%ebx
}
  801b2d:	89 d8                	mov    %ebx,%eax
  801b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5e                   	pop    %esi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	56                   	push   %esi
  801b3a:	53                   	push   %ebx
  801b3b:	89 c6                	mov    %eax,%esi
  801b3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b46:	74 27                	je     801b6f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b48:	6a 07                	push   $0x7
  801b4a:	68 00 60 80 00       	push   $0x806000
  801b4f:	56                   	push   %esi
  801b50:	ff 35 00 50 80 00    	pushl  0x805000
  801b56:	e8 9d 0c 00 00       	call   8027f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b5b:	83 c4 0c             	add    $0xc,%esp
  801b5e:	6a 00                	push   $0x0
  801b60:	53                   	push   %ebx
  801b61:	6a 00                	push   $0x0
  801b63:	e8 27 0c 00 00       	call   80278f <ipc_recv>
}
  801b68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6b:	5b                   	pop    %ebx
  801b6c:	5e                   	pop    %esi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	6a 01                	push   $0x1
  801b74:	e8 d7 0c 00 00       	call   802850 <ipc_find_env>
  801b79:	a3 00 50 80 00       	mov    %eax,0x805000
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	eb c5                	jmp    801b48 <fsipc+0x12>

00801b83 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba1:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba6:	e8 8b ff ff ff       	call   801b36 <fsipc>
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <devfile_flush>:
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc3:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc8:	e8 69 ff ff ff       	call   801b36 <fsipc>
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <devfile_stat>:
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdf:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801be4:	ba 00 00 00 00       	mov    $0x0,%edx
  801be9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bee:	e8 43 ff ff ff       	call   801b36 <fsipc>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 2c                	js     801c23 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	68 00 60 80 00       	push   $0x806000
  801bff:	53                   	push   %ebx
  801c00:	e8 f1 ed ff ff       	call   8009f6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c05:	a1 80 60 80 00       	mov    0x806080,%eax
  801c0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c10:	a1 84 60 80 00       	mov    0x806084,%eax
  801c15:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c1b:	83 c4 10             	add    $0x10,%esp
  801c1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <devfile_write>:
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	8b 40 0c             	mov    0xc(%eax),%eax
  801c38:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c3d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c43:	53                   	push   %ebx
  801c44:	ff 75 0c             	pushl  0xc(%ebp)
  801c47:	68 08 60 80 00       	push   $0x806008
  801c4c:	e8 95 ef ff ff       	call   800be6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	b8 04 00 00 00       	mov    $0x4,%eax
  801c5b:	e8 d6 fe ff ff       	call   801b36 <fsipc>
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 0b                	js     801c72 <devfile_write+0x4a>
	assert(r <= n);
  801c67:	39 d8                	cmp    %ebx,%eax
  801c69:	77 0c                	ja     801c77 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c70:	7f 1e                	jg     801c90 <devfile_write+0x68>
}
  801c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    
	assert(r <= n);
  801c77:	68 10 31 80 00       	push   $0x803110
  801c7c:	68 17 31 80 00       	push   $0x803117
  801c81:	68 98 00 00 00       	push   $0x98
  801c86:	68 2c 31 80 00       	push   $0x80312c
  801c8b:	e8 11 e5 ff ff       	call   8001a1 <_panic>
	assert(r <= PGSIZE);
  801c90:	68 37 31 80 00       	push   $0x803137
  801c95:	68 17 31 80 00       	push   $0x803117
  801c9a:	68 99 00 00 00       	push   $0x99
  801c9f:	68 2c 31 80 00       	push   $0x80312c
  801ca4:	e8 f8 e4 ff ff       	call   8001a1 <_panic>

00801ca9 <devfile_read>:
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	56                   	push   %esi
  801cad:	53                   	push   %ebx
  801cae:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cbc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc7:	b8 03 00 00 00       	mov    $0x3,%eax
  801ccc:	e8 65 fe ff ff       	call   801b36 <fsipc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 1f                	js     801cf6 <devfile_read+0x4d>
	assert(r <= n);
  801cd7:	39 f0                	cmp    %esi,%eax
  801cd9:	77 24                	ja     801cff <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cdb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce0:	7f 33                	jg     801d15 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ce2:	83 ec 04             	sub    $0x4,%esp
  801ce5:	50                   	push   %eax
  801ce6:	68 00 60 80 00       	push   $0x806000
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	e8 91 ee ff ff       	call   800b84 <memmove>
	return r;
  801cf3:	83 c4 10             	add    $0x10,%esp
}
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    
	assert(r <= n);
  801cff:	68 10 31 80 00       	push   $0x803110
  801d04:	68 17 31 80 00       	push   $0x803117
  801d09:	6a 7c                	push   $0x7c
  801d0b:	68 2c 31 80 00       	push   $0x80312c
  801d10:	e8 8c e4 ff ff       	call   8001a1 <_panic>
	assert(r <= PGSIZE);
  801d15:	68 37 31 80 00       	push   $0x803137
  801d1a:	68 17 31 80 00       	push   $0x803117
  801d1f:	6a 7d                	push   $0x7d
  801d21:	68 2c 31 80 00       	push   $0x80312c
  801d26:	e8 76 e4 ff ff       	call   8001a1 <_panic>

00801d2b <open>:
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 1c             	sub    $0x1c,%esp
  801d33:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d36:	56                   	push   %esi
  801d37:	e8 81 ec ff ff       	call   8009bd <strlen>
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d44:	7f 6c                	jg     801db2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4c:	50                   	push   %eax
  801d4d:	e8 79 f8 ff ff       	call   8015cb <fd_alloc>
  801d52:	89 c3                	mov    %eax,%ebx
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	85 c0                	test   %eax,%eax
  801d59:	78 3c                	js     801d97 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	56                   	push   %esi
  801d5f:	68 00 60 80 00       	push   $0x806000
  801d64:	e8 8d ec ff ff       	call   8009f6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d74:	b8 01 00 00 00       	mov    $0x1,%eax
  801d79:	e8 b8 fd ff ff       	call   801b36 <fsipc>
  801d7e:	89 c3                	mov    %eax,%ebx
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 19                	js     801da0 <open+0x75>
	return fd2num(fd);
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8d:	e8 12 f8 ff ff       	call   8015a4 <fd2num>
  801d92:	89 c3                	mov    %eax,%ebx
  801d94:	83 c4 10             	add    $0x10,%esp
}
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
		fd_close(fd, 0);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 f4             	pushl  -0xc(%ebp)
  801da8:	e8 1b f9 ff ff       	call   8016c8 <fd_close>
		return r;
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	eb e5                	jmp    801d97 <open+0x6c>
		return -E_BAD_PATH;
  801db2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801db7:	eb de                	jmp    801d97 <open+0x6c>

00801db9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc4:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc9:	e8 68 fd ff ff       	call   801b36 <fsipc>
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dd6:	68 43 31 80 00       	push   $0x803143
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	e8 13 ec ff ff       	call   8009f6 <strcpy>
	return 0;
}
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <devsock_close>:
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	53                   	push   %ebx
  801dee:	83 ec 10             	sub    $0x10,%esp
  801df1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801df4:	53                   	push   %ebx
  801df5:	e8 91 0a 00 00       	call   80288b <pageref>
  801dfa:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dfd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e02:	83 f8 01             	cmp    $0x1,%eax
  801e05:	74 07                	je     801e0e <devsock_close+0x24>
}
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	ff 73 0c             	pushl  0xc(%ebx)
  801e14:	e8 b9 02 00 00       	call   8020d2 <nsipc_close>
  801e19:	89 c2                	mov    %eax,%edx
  801e1b:	83 c4 10             	add    $0x10,%esp
  801e1e:	eb e7                	jmp    801e07 <devsock_close+0x1d>

00801e20 <devsock_write>:
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	ff 75 10             	pushl  0x10(%ebp)
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	ff 70 0c             	pushl  0xc(%eax)
  801e34:	e8 76 03 00 00       	call   8021af <nsipc_send>
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devsock_read>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	ff 75 10             	pushl  0x10(%ebp)
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	ff 70 0c             	pushl  0xc(%eax)
  801e4f:	e8 ef 02 00 00       	call   802143 <nsipc_recv>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <fd2sockid>:
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e5c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e5f:	52                   	push   %edx
  801e60:	50                   	push   %eax
  801e61:	e8 b7 f7 ff ff       	call   80161d <fd_lookup>
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	78 10                	js     801e7d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e76:	39 08                	cmp    %ecx,(%eax)
  801e78:	75 05                	jne    801e7f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e7a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    
		return -E_NOT_SUPP;
  801e7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e84:	eb f7                	jmp    801e7d <fd2sockid+0x27>

00801e86 <alloc_sockfd>:
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	56                   	push   %esi
  801e8a:	53                   	push   %ebx
  801e8b:	83 ec 1c             	sub    $0x1c,%esp
  801e8e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e93:	50                   	push   %eax
  801e94:	e8 32 f7 ff ff       	call   8015cb <fd_alloc>
  801e99:	89 c3                	mov    %eax,%ebx
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 43                	js     801ee5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	68 07 04 00 00       	push   $0x407
  801eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ead:	6a 00                	push   $0x0
  801eaf:	e8 34 ef ff ff       	call   800de8 <sys_page_alloc>
  801eb4:	89 c3                	mov    %eax,%ebx
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	78 28                	js     801ee5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ec6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ed2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	50                   	push   %eax
  801ed9:	e8 c6 f6 ff ff       	call   8015a4 <fd2num>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	eb 0c                	jmp    801ef1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	56                   	push   %esi
  801ee9:	e8 e4 01 00 00       	call   8020d2 <nsipc_close>
		return r;
  801eee:	83 c4 10             	add    $0x10,%esp
}
  801ef1:	89 d8                	mov    %ebx,%eax
  801ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5e                   	pop    %esi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <accept>:
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	e8 4e ff ff ff       	call   801e56 <fd2sockid>
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 1b                	js     801f27 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	50                   	push   %eax
  801f16:	e8 0e 01 00 00       	call   802029 <nsipc_accept>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	78 05                	js     801f27 <accept+0x2d>
	return alloc_sockfd(r);
  801f22:	e8 5f ff ff ff       	call   801e86 <alloc_sockfd>
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <bind>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	e8 1f ff ff ff       	call   801e56 <fd2sockid>
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 12                	js     801f4d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	ff 75 10             	pushl  0x10(%ebp)
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	50                   	push   %eax
  801f45:	e8 31 01 00 00       	call   80207b <nsipc_bind>
  801f4a:	83 c4 10             	add    $0x10,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <shutdown>:
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	e8 f9 fe ff ff       	call   801e56 <fd2sockid>
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	78 0f                	js     801f70 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f61:	83 ec 08             	sub    $0x8,%esp
  801f64:	ff 75 0c             	pushl  0xc(%ebp)
  801f67:	50                   	push   %eax
  801f68:	e8 43 01 00 00       	call   8020b0 <nsipc_shutdown>
  801f6d:	83 c4 10             	add    $0x10,%esp
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <connect>:
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	e8 d6 fe ff ff       	call   801e56 <fd2sockid>
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 12                	js     801f96 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f84:	83 ec 04             	sub    $0x4,%esp
  801f87:	ff 75 10             	pushl  0x10(%ebp)
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	50                   	push   %eax
  801f8e:	e8 59 01 00 00       	call   8020ec <nsipc_connect>
  801f93:	83 c4 10             	add    $0x10,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <listen>:
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	e8 b0 fe ff ff       	call   801e56 <fd2sockid>
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	78 0f                	js     801fb9 <listen+0x21>
	return nsipc_listen(r, backlog);
  801faa:	83 ec 08             	sub    $0x8,%esp
  801fad:	ff 75 0c             	pushl  0xc(%ebp)
  801fb0:	50                   	push   %eax
  801fb1:	e8 6b 01 00 00       	call   802121 <nsipc_listen>
  801fb6:	83 c4 10             	add    $0x10,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <socket>:

int
socket(int domain, int type, int protocol)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fc1:	ff 75 10             	pushl  0x10(%ebp)
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	e8 3e 02 00 00       	call   80220d <nsipc_socket>
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	78 05                	js     801fdb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fd6:	e8 ab fe ff ff       	call   801e86 <alloc_sockfd>
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	53                   	push   %ebx
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fe6:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fed:	74 26                	je     802015 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fef:	6a 07                	push   $0x7
  801ff1:	68 00 70 80 00       	push   $0x807000
  801ff6:	53                   	push   %ebx
  801ff7:	ff 35 04 50 80 00    	pushl  0x805004
  801ffd:	e8 f6 07 00 00       	call   8027f8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802002:	83 c4 0c             	add    $0xc,%esp
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	e8 7f 07 00 00       	call   80278f <ipc_recv>
}
  802010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802013:	c9                   	leave  
  802014:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	6a 02                	push   $0x2
  80201a:	e8 31 08 00 00       	call   802850 <ipc_find_env>
  80201f:	a3 04 50 80 00       	mov    %eax,0x805004
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	eb c6                	jmp    801fef <nsipc+0x12>

00802029 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802039:	8b 06                	mov    (%esi),%eax
  80203b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802040:	b8 01 00 00 00       	mov    $0x1,%eax
  802045:	e8 93 ff ff ff       	call   801fdd <nsipc>
  80204a:	89 c3                	mov    %eax,%ebx
  80204c:	85 c0                	test   %eax,%eax
  80204e:	79 09                	jns    802059 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802050:	89 d8                	mov    %ebx,%eax
  802052:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	ff 35 10 70 80 00    	pushl  0x807010
  802062:	68 00 70 80 00       	push   $0x807000
  802067:	ff 75 0c             	pushl  0xc(%ebp)
  80206a:	e8 15 eb ff ff       	call   800b84 <memmove>
		*addrlen = ret->ret_addrlen;
  80206f:	a1 10 70 80 00       	mov    0x807010,%eax
  802074:	89 06                	mov    %eax,(%esi)
  802076:	83 c4 10             	add    $0x10,%esp
	return r;
  802079:	eb d5                	jmp    802050 <nsipc_accept+0x27>

0080207b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	53                   	push   %ebx
  80207f:	83 ec 08             	sub    $0x8,%esp
  802082:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80208d:	53                   	push   %ebx
  80208e:	ff 75 0c             	pushl  0xc(%ebp)
  802091:	68 04 70 80 00       	push   $0x807004
  802096:	e8 e9 ea ff ff       	call   800b84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80209b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020a1:	b8 02 00 00 00       	mov    $0x2,%eax
  8020a6:	e8 32 ff ff ff       	call   801fdd <nsipc>
}
  8020ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8020cb:	e8 0d ff ff ff       	call   801fdd <nsipc>
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <nsipc_close>:

int
nsipc_close(int s)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020e0:	b8 04 00 00 00       	mov    $0x4,%eax
  8020e5:	e8 f3 fe ff ff       	call   801fdd <nsipc>
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	53                   	push   %ebx
  8020f0:	83 ec 08             	sub    $0x8,%esp
  8020f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020fe:	53                   	push   %ebx
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	68 04 70 80 00       	push   $0x807004
  802107:	e8 78 ea ff ff       	call   800b84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80210c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802112:	b8 05 00 00 00       	mov    $0x5,%eax
  802117:	e8 c1 fe ff ff       	call   801fdd <nsipc>
}
  80211c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80212f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802132:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802137:	b8 06 00 00 00       	mov    $0x6,%eax
  80213c:	e8 9c fe ff ff       	call   801fdd <nsipc>
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802153:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802159:	8b 45 14             	mov    0x14(%ebp),%eax
  80215c:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802161:	b8 07 00 00 00       	mov    $0x7,%eax
  802166:	e8 72 fe ff ff       	call   801fdd <nsipc>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 1f                	js     802190 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802171:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802176:	7f 21                	jg     802199 <nsipc_recv+0x56>
  802178:	39 c6                	cmp    %eax,%esi
  80217a:	7c 1d                	jl     802199 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	50                   	push   %eax
  802180:	68 00 70 80 00       	push   $0x807000
  802185:	ff 75 0c             	pushl  0xc(%ebp)
  802188:	e8 f7 e9 ff ff       	call   800b84 <memmove>
  80218d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802190:	89 d8                	mov    %ebx,%eax
  802192:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802199:	68 4f 31 80 00       	push   $0x80314f
  80219e:	68 17 31 80 00       	push   $0x803117
  8021a3:	6a 62                	push   $0x62
  8021a5:	68 64 31 80 00       	push   $0x803164
  8021aa:	e8 f2 df ff ff       	call   8001a1 <_panic>

008021af <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	53                   	push   %ebx
  8021b3:	83 ec 04             	sub    $0x4,%esp
  8021b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021c1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021c7:	7f 2e                	jg     8021f7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	53                   	push   %ebx
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	68 0c 70 80 00       	push   $0x80700c
  8021d5:	e8 aa e9 ff ff       	call   800b84 <memmove>
	nsipcbuf.send.req_size = size;
  8021da:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8021ed:	e8 eb fd ff ff       	call   801fdd <nsipc>
}
  8021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    
	assert(size < 1600);
  8021f7:	68 70 31 80 00       	push   $0x803170
  8021fc:	68 17 31 80 00       	push   $0x803117
  802201:	6a 6d                	push   $0x6d
  802203:	68 64 31 80 00       	push   $0x803164
  802208:	e8 94 df ff ff       	call   8001a1 <_panic>

0080220d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80221b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221e:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802223:	8b 45 10             	mov    0x10(%ebp),%eax
  802226:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80222b:	b8 09 00 00 00       	mov    $0x9,%eax
  802230:	e8 a8 fd ff ff       	call   801fdd <nsipc>
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	56                   	push   %esi
  80223b:	53                   	push   %ebx
  80223c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	ff 75 08             	pushl  0x8(%ebp)
  802245:	e8 6a f3 ff ff       	call   8015b4 <fd2data>
  80224a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80224c:	83 c4 08             	add    $0x8,%esp
  80224f:	68 7c 31 80 00       	push   $0x80317c
  802254:	53                   	push   %ebx
  802255:	e8 9c e7 ff ff       	call   8009f6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80225a:	8b 46 04             	mov    0x4(%esi),%eax
  80225d:	2b 06                	sub    (%esi),%eax
  80225f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802265:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80226c:	00 00 00 
	stat->st_dev = &devpipe;
  80226f:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802276:	40 80 00 
	return 0;
}
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	53                   	push   %ebx
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80228f:	53                   	push   %ebx
  802290:	6a 00                	push   $0x0
  802292:	e8 d6 eb ff ff       	call   800e6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802297:	89 1c 24             	mov    %ebx,(%esp)
  80229a:	e8 15 f3 ff ff       	call   8015b4 <fd2data>
  80229f:	83 c4 08             	add    $0x8,%esp
  8022a2:	50                   	push   %eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 c3 eb ff ff       	call   800e6d <sys_page_unmap>
}
  8022aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <_pipeisclosed>:
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	57                   	push   %edi
  8022b3:	56                   	push   %esi
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 1c             	sub    $0x1c,%esp
  8022b8:	89 c7                	mov    %eax,%edi
  8022ba:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022bc:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8022c1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	57                   	push   %edi
  8022c8:	e8 be 05 00 00       	call   80288b <pageref>
  8022cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022d0:	89 34 24             	mov    %esi,(%esp)
  8022d3:	e8 b3 05 00 00       	call   80288b <pageref>
		nn = thisenv->env_runs;
  8022d8:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8022de:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	39 cb                	cmp    %ecx,%ebx
  8022e6:	74 1b                	je     802303 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022e8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022eb:	75 cf                	jne    8022bc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022ed:	8b 42 58             	mov    0x58(%edx),%eax
  8022f0:	6a 01                	push   $0x1
  8022f2:	50                   	push   %eax
  8022f3:	53                   	push   %ebx
  8022f4:	68 83 31 80 00       	push   $0x803183
  8022f9:	e8 99 df ff ff       	call   800297 <cprintf>
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	eb b9                	jmp    8022bc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802303:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802306:	0f 94 c0             	sete   %al
  802309:	0f b6 c0             	movzbl %al,%eax
}
  80230c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <devpipe_write>:
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	57                   	push   %edi
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
  80231a:	83 ec 28             	sub    $0x28,%esp
  80231d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802320:	56                   	push   %esi
  802321:	e8 8e f2 ff ff       	call   8015b4 <fd2data>
  802326:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	bf 00 00 00 00       	mov    $0x0,%edi
  802330:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802333:	74 4f                	je     802384 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802335:	8b 43 04             	mov    0x4(%ebx),%eax
  802338:	8b 0b                	mov    (%ebx),%ecx
  80233a:	8d 51 20             	lea    0x20(%ecx),%edx
  80233d:	39 d0                	cmp    %edx,%eax
  80233f:	72 14                	jb     802355 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802341:	89 da                	mov    %ebx,%edx
  802343:	89 f0                	mov    %esi,%eax
  802345:	e8 65 ff ff ff       	call   8022af <_pipeisclosed>
  80234a:	85 c0                	test   %eax,%eax
  80234c:	75 3b                	jne    802389 <devpipe_write+0x75>
			sys_yield();
  80234e:	e8 76 ea ff ff       	call   800dc9 <sys_yield>
  802353:	eb e0                	jmp    802335 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802355:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802358:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80235c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80235f:	89 c2                	mov    %eax,%edx
  802361:	c1 fa 1f             	sar    $0x1f,%edx
  802364:	89 d1                	mov    %edx,%ecx
  802366:	c1 e9 1b             	shr    $0x1b,%ecx
  802369:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80236c:	83 e2 1f             	and    $0x1f,%edx
  80236f:	29 ca                	sub    %ecx,%edx
  802371:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802375:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802379:	83 c0 01             	add    $0x1,%eax
  80237c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80237f:	83 c7 01             	add    $0x1,%edi
  802382:	eb ac                	jmp    802330 <devpipe_write+0x1c>
	return i;
  802384:	8b 45 10             	mov    0x10(%ebp),%eax
  802387:	eb 05                	jmp    80238e <devpipe_write+0x7a>
				return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    

00802396 <devpipe_read>:
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	57                   	push   %edi
  80239a:	56                   	push   %esi
  80239b:	53                   	push   %ebx
  80239c:	83 ec 18             	sub    $0x18,%esp
  80239f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023a2:	57                   	push   %edi
  8023a3:	e8 0c f2 ff ff       	call   8015b4 <fd2data>
  8023a8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023aa:	83 c4 10             	add    $0x10,%esp
  8023ad:	be 00 00 00 00       	mov    $0x0,%esi
  8023b2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b5:	75 14                	jne    8023cb <devpipe_read+0x35>
	return i;
  8023b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ba:	eb 02                	jmp    8023be <devpipe_read+0x28>
				return i;
  8023bc:	89 f0                	mov    %esi,%eax
}
  8023be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
			sys_yield();
  8023c6:	e8 fe e9 ff ff       	call   800dc9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023cb:	8b 03                	mov    (%ebx),%eax
  8023cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023d0:	75 18                	jne    8023ea <devpipe_read+0x54>
			if (i > 0)
  8023d2:	85 f6                	test   %esi,%esi
  8023d4:	75 e6                	jne    8023bc <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023d6:	89 da                	mov    %ebx,%edx
  8023d8:	89 f8                	mov    %edi,%eax
  8023da:	e8 d0 fe ff ff       	call   8022af <_pipeisclosed>
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 e3                	je     8023c6 <devpipe_read+0x30>
				return 0;
  8023e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e8:	eb d4                	jmp    8023be <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023ea:	99                   	cltd   
  8023eb:	c1 ea 1b             	shr    $0x1b,%edx
  8023ee:	01 d0                	add    %edx,%eax
  8023f0:	83 e0 1f             	and    $0x1f,%eax
  8023f3:	29 d0                	sub    %edx,%eax
  8023f5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023fd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802400:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802403:	83 c6 01             	add    $0x1,%esi
  802406:	eb aa                	jmp    8023b2 <devpipe_read+0x1c>

00802408 <pipe>:
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	56                   	push   %esi
  80240c:	53                   	push   %ebx
  80240d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802413:	50                   	push   %eax
  802414:	e8 b2 f1 ff ff       	call   8015cb <fd_alloc>
  802419:	89 c3                	mov    %eax,%ebx
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	85 c0                	test   %eax,%eax
  802420:	0f 88 23 01 00 00    	js     802549 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802426:	83 ec 04             	sub    $0x4,%esp
  802429:	68 07 04 00 00       	push   $0x407
  80242e:	ff 75 f4             	pushl  -0xc(%ebp)
  802431:	6a 00                	push   $0x0
  802433:	e8 b0 e9 ff ff       	call   800de8 <sys_page_alloc>
  802438:	89 c3                	mov    %eax,%ebx
  80243a:	83 c4 10             	add    $0x10,%esp
  80243d:	85 c0                	test   %eax,%eax
  80243f:	0f 88 04 01 00 00    	js     802549 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80244b:	50                   	push   %eax
  80244c:	e8 7a f1 ff ff       	call   8015cb <fd_alloc>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	83 c4 10             	add    $0x10,%esp
  802456:	85 c0                	test   %eax,%eax
  802458:	0f 88 db 00 00 00    	js     802539 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 07 04 00 00       	push   $0x407
  802466:	ff 75 f0             	pushl  -0x10(%ebp)
  802469:	6a 00                	push   $0x0
  80246b:	e8 78 e9 ff ff       	call   800de8 <sys_page_alloc>
  802470:	89 c3                	mov    %eax,%ebx
  802472:	83 c4 10             	add    $0x10,%esp
  802475:	85 c0                	test   %eax,%eax
  802477:	0f 88 bc 00 00 00    	js     802539 <pipe+0x131>
	va = fd2data(fd0);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff 75 f4             	pushl  -0xc(%ebp)
  802483:	e8 2c f1 ff ff       	call   8015b4 <fd2data>
  802488:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248a:	83 c4 0c             	add    $0xc,%esp
  80248d:	68 07 04 00 00       	push   $0x407
  802492:	50                   	push   %eax
  802493:	6a 00                	push   $0x0
  802495:	e8 4e e9 ff ff       	call   800de8 <sys_page_alloc>
  80249a:	89 c3                	mov    %eax,%ebx
  80249c:	83 c4 10             	add    $0x10,%esp
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	0f 88 82 00 00 00    	js     802529 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ad:	e8 02 f1 ff ff       	call   8015b4 <fd2data>
  8024b2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024b9:	50                   	push   %eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	56                   	push   %esi
  8024bd:	6a 00                	push   $0x0
  8024bf:	e8 67 e9 ff ff       	call   800e2b <sys_page_map>
  8024c4:	89 c3                	mov    %eax,%ebx
  8024c6:	83 c4 20             	add    $0x20,%esp
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	78 4e                	js     80251b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024cd:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024da:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f6:	e8 a9 f0 ff ff       	call   8015a4 <fd2num>
  8024fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024fe:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802500:	83 c4 04             	add    $0x4,%esp
  802503:	ff 75 f0             	pushl  -0x10(%ebp)
  802506:	e8 99 f0 ff ff       	call   8015a4 <fd2num>
  80250b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	bb 00 00 00 00       	mov    $0x0,%ebx
  802519:	eb 2e                	jmp    802549 <pipe+0x141>
	sys_page_unmap(0, va);
  80251b:	83 ec 08             	sub    $0x8,%esp
  80251e:	56                   	push   %esi
  80251f:	6a 00                	push   $0x0
  802521:	e8 47 e9 ff ff       	call   800e6d <sys_page_unmap>
  802526:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802529:	83 ec 08             	sub    $0x8,%esp
  80252c:	ff 75 f0             	pushl  -0x10(%ebp)
  80252f:	6a 00                	push   $0x0
  802531:	e8 37 e9 ff ff       	call   800e6d <sys_page_unmap>
  802536:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802539:	83 ec 08             	sub    $0x8,%esp
  80253c:	ff 75 f4             	pushl  -0xc(%ebp)
  80253f:	6a 00                	push   $0x0
  802541:	e8 27 e9 ff ff       	call   800e6d <sys_page_unmap>
  802546:	83 c4 10             	add    $0x10,%esp
}
  802549:	89 d8                	mov    %ebx,%eax
  80254b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80254e:	5b                   	pop    %ebx
  80254f:	5e                   	pop    %esi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    

00802552 <pipeisclosed>:
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255b:	50                   	push   %eax
  80255c:	ff 75 08             	pushl  0x8(%ebp)
  80255f:	e8 b9 f0 ff ff       	call   80161d <fd_lookup>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	85 c0                	test   %eax,%eax
  802569:	78 18                	js     802583 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80256b:	83 ec 0c             	sub    $0xc,%esp
  80256e:	ff 75 f4             	pushl  -0xc(%ebp)
  802571:	e8 3e f0 ff ff       	call   8015b4 <fd2data>
	return _pipeisclosed(fd, p);
  802576:	89 c2                	mov    %eax,%edx
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	e8 2f fd ff ff       	call   8022af <_pipeisclosed>
  802580:	83 c4 10             	add    $0x10,%esp
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	c3                   	ret    

0080258b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802591:	68 9b 31 80 00       	push   $0x80319b
  802596:	ff 75 0c             	pushl  0xc(%ebp)
  802599:	e8 58 e4 ff ff       	call   8009f6 <strcpy>
	return 0;
}
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <devcons_write>:
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	57                   	push   %edi
  8025a9:	56                   	push   %esi
  8025aa:	53                   	push   %ebx
  8025ab:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025b1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025b6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025bc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025bf:	73 31                	jae    8025f2 <devcons_write+0x4d>
		m = n - tot;
  8025c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025c4:	29 f3                	sub    %esi,%ebx
  8025c6:	83 fb 7f             	cmp    $0x7f,%ebx
  8025c9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025ce:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025d1:	83 ec 04             	sub    $0x4,%esp
  8025d4:	53                   	push   %ebx
  8025d5:	89 f0                	mov    %esi,%eax
  8025d7:	03 45 0c             	add    0xc(%ebp),%eax
  8025da:	50                   	push   %eax
  8025db:	57                   	push   %edi
  8025dc:	e8 a3 e5 ff ff       	call   800b84 <memmove>
		sys_cputs(buf, m);
  8025e1:	83 c4 08             	add    $0x8,%esp
  8025e4:	53                   	push   %ebx
  8025e5:	57                   	push   %edi
  8025e6:	e8 41 e7 ff ff       	call   800d2c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025eb:	01 de                	add    %ebx,%esi
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	eb ca                	jmp    8025bc <devcons_write+0x17>
}
  8025f2:	89 f0                	mov    %esi,%eax
  8025f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f7:	5b                   	pop    %ebx
  8025f8:	5e                   	pop    %esi
  8025f9:	5f                   	pop    %edi
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <devcons_read>:
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 08             	sub    $0x8,%esp
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80260b:	74 21                	je     80262e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80260d:	e8 38 e7 ff ff       	call   800d4a <sys_cgetc>
  802612:	85 c0                	test   %eax,%eax
  802614:	75 07                	jne    80261d <devcons_read+0x21>
		sys_yield();
  802616:	e8 ae e7 ff ff       	call   800dc9 <sys_yield>
  80261b:	eb f0                	jmp    80260d <devcons_read+0x11>
	if (c < 0)
  80261d:	78 0f                	js     80262e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80261f:	83 f8 04             	cmp    $0x4,%eax
  802622:	74 0c                	je     802630 <devcons_read+0x34>
	*(char*)vbuf = c;
  802624:	8b 55 0c             	mov    0xc(%ebp),%edx
  802627:	88 02                	mov    %al,(%edx)
	return 1;
  802629:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    
		return 0;
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
  802635:	eb f7                	jmp    80262e <devcons_read+0x32>

00802637 <cputchar>:
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802643:	6a 01                	push   $0x1
  802645:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802648:	50                   	push   %eax
  802649:	e8 de e6 ff ff       	call   800d2c <sys_cputs>
}
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <getchar>:
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802659:	6a 01                	push   $0x1
  80265b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80265e:	50                   	push   %eax
  80265f:	6a 00                	push   $0x0
  802661:	e8 27 f2 ff ff       	call   80188d <read>
	if (r < 0)
  802666:	83 c4 10             	add    $0x10,%esp
  802669:	85 c0                	test   %eax,%eax
  80266b:	78 06                	js     802673 <getchar+0x20>
	if (r < 1)
  80266d:	74 06                	je     802675 <getchar+0x22>
	return c;
  80266f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    
		return -E_EOF;
  802675:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80267a:	eb f7                	jmp    802673 <getchar+0x20>

0080267c <iscons>:
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802682:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802685:	50                   	push   %eax
  802686:	ff 75 08             	pushl  0x8(%ebp)
  802689:	e8 8f ef ff ff       	call   80161d <fd_lookup>
  80268e:	83 c4 10             	add    $0x10,%esp
  802691:	85 c0                	test   %eax,%eax
  802693:	78 11                	js     8026a6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80269e:	39 10                	cmp    %edx,(%eax)
  8026a0:	0f 94 c0             	sete   %al
  8026a3:	0f b6 c0             	movzbl %al,%eax
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <opencons>:
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b1:	50                   	push   %eax
  8026b2:	e8 14 ef ff ff       	call   8015cb <fd_alloc>
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	78 3a                	js     8026f8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 07 04 00 00       	push   $0x407
  8026c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c9:	6a 00                	push   $0x0
  8026cb:	e8 18 e7 ff ff       	call   800de8 <sys_page_alloc>
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	78 21                	js     8026f8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026e0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026ec:	83 ec 0c             	sub    $0xc,%esp
  8026ef:	50                   	push   %eax
  8026f0:	e8 af ee ff ff       	call   8015a4 <fd2num>
  8026f5:	83 c4 10             	add    $0x10,%esp
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802700:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802707:	74 0a                	je     802713 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	6a 07                	push   $0x7
  802718:	68 00 f0 bf ee       	push   $0xeebff000
  80271d:	6a 00                	push   $0x0
  80271f:	e8 c4 e6 ff ff       	call   800de8 <sys_page_alloc>
		if(r < 0)
  802724:	83 c4 10             	add    $0x10,%esp
  802727:	85 c0                	test   %eax,%eax
  802729:	78 2a                	js     802755 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80272b:	83 ec 08             	sub    $0x8,%esp
  80272e:	68 69 27 80 00       	push   $0x802769
  802733:	6a 00                	push   $0x0
  802735:	e8 f9 e7 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80273a:	83 c4 10             	add    $0x10,%esp
  80273d:	85 c0                	test   %eax,%eax
  80273f:	79 c8                	jns    802709 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802741:	83 ec 04             	sub    $0x4,%esp
  802744:	68 d8 31 80 00       	push   $0x8031d8
  802749:	6a 25                	push   $0x25
  80274b:	68 14 32 80 00       	push   $0x803214
  802750:	e8 4c da ff ff       	call   8001a1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 a8 31 80 00       	push   $0x8031a8
  80275d:	6a 22                	push   $0x22
  80275f:	68 14 32 80 00       	push   $0x803214
  802764:	e8 38 da ff ff       	call   8001a1 <_panic>

00802769 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802769:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80276a:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80276f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802771:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802774:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802778:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80277c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80277f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802781:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802785:	83 c4 08             	add    $0x8,%esp
	popal
  802788:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802789:	83 c4 04             	add    $0x4,%esp
	popfl
  80278c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80278d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80278e:	c3                   	ret    

0080278f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	56                   	push   %esi
  802793:	53                   	push   %ebx
  802794:	8b 75 08             	mov    0x8(%ebp),%esi
  802797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80279d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80279f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027a4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027a7:	83 ec 0c             	sub    $0xc,%esp
  8027aa:	50                   	push   %eax
  8027ab:	e8 e8 e7 ff ff       	call   800f98 <sys_ipc_recv>
	if(ret < 0){
  8027b0:	83 c4 10             	add    $0x10,%esp
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	78 2b                	js     8027e2 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027b7:	85 f6                	test   %esi,%esi
  8027b9:	74 0a                	je     8027c5 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027bb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027c0:	8b 40 74             	mov    0x74(%eax),%eax
  8027c3:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027c5:	85 db                	test   %ebx,%ebx
  8027c7:	74 0a                	je     8027d3 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027c9:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027ce:	8b 40 78             	mov    0x78(%eax),%eax
  8027d1:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027d3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027d8:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027de:	5b                   	pop    %ebx
  8027df:	5e                   	pop    %esi
  8027e0:	5d                   	pop    %ebp
  8027e1:	c3                   	ret    
		if(from_env_store)
  8027e2:	85 f6                	test   %esi,%esi
  8027e4:	74 06                	je     8027ec <ipc_recv+0x5d>
			*from_env_store = 0;
  8027e6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8027ec:	85 db                	test   %ebx,%ebx
  8027ee:	74 eb                	je     8027db <ipc_recv+0x4c>
			*perm_store = 0;
  8027f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027f6:	eb e3                	jmp    8027db <ipc_recv+0x4c>

008027f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	57                   	push   %edi
  8027fc:	56                   	push   %esi
  8027fd:	53                   	push   %ebx
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	8b 7d 08             	mov    0x8(%ebp),%edi
  802804:	8b 75 0c             	mov    0xc(%ebp),%esi
  802807:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80280a:	85 db                	test   %ebx,%ebx
  80280c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802811:	0f 44 d8             	cmove  %eax,%ebx
  802814:	eb 05                	jmp    80281b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802816:	e8 ae e5 ff ff       	call   800dc9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80281b:	ff 75 14             	pushl  0x14(%ebp)
  80281e:	53                   	push   %ebx
  80281f:	56                   	push   %esi
  802820:	57                   	push   %edi
  802821:	e8 4f e7 ff ff       	call   800f75 <sys_ipc_try_send>
  802826:	83 c4 10             	add    $0x10,%esp
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 1b                	je     802848 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80282d:	79 e7                	jns    802816 <ipc_send+0x1e>
  80282f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802832:	74 e2                	je     802816 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	68 22 32 80 00       	push   $0x803222
  80283c:	6a 48                	push   $0x48
  80283e:	68 37 32 80 00       	push   $0x803237
  802843:	e8 59 d9 ff ff       	call   8001a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80284b:	5b                   	pop    %ebx
  80284c:	5e                   	pop    %esi
  80284d:	5f                   	pop    %edi
  80284e:	5d                   	pop    %ebp
  80284f:	c3                   	ret    

00802850 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80285b:	89 c2                	mov    %eax,%edx
  80285d:	c1 e2 07             	shl    $0x7,%edx
  802860:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802866:	8b 52 50             	mov    0x50(%edx),%edx
  802869:	39 ca                	cmp    %ecx,%edx
  80286b:	74 11                	je     80287e <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80286d:	83 c0 01             	add    $0x1,%eax
  802870:	3d 00 04 00 00       	cmp    $0x400,%eax
  802875:	75 e4                	jne    80285b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	eb 0b                	jmp    802889 <ipc_find_env+0x39>
			return envs[i].env_id;
  80287e:	c1 e0 07             	shl    $0x7,%eax
  802881:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802886:	8b 40 48             	mov    0x48(%eax),%eax
}
  802889:	5d                   	pop    %ebp
  80288a:	c3                   	ret    

0080288b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80288b:	55                   	push   %ebp
  80288c:	89 e5                	mov    %esp,%ebp
  80288e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802891:	89 d0                	mov    %edx,%eax
  802893:	c1 e8 16             	shr    $0x16,%eax
  802896:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028a2:	f6 c1 01             	test   $0x1,%cl
  8028a5:	74 1d                	je     8028c4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028a7:	c1 ea 0c             	shr    $0xc,%edx
  8028aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028b1:	f6 c2 01             	test   $0x1,%dl
  8028b4:	74 0e                	je     8028c4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028b6:	c1 ea 0c             	shr    $0xc,%edx
  8028b9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028c0:	ef 
  8028c1:	0f b7 c0             	movzwl %ax,%eax
}
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
  8028c6:	66 90                	xchg   %ax,%ax
  8028c8:	66 90                	xchg   %ax,%ax
  8028ca:	66 90                	xchg   %ax,%ax
  8028cc:	66 90                	xchg   %ax,%ax
  8028ce:	66 90                	xchg   %ax,%ax

008028d0 <__udivdi3>:
  8028d0:	55                   	push   %ebp
  8028d1:	57                   	push   %edi
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	83 ec 1c             	sub    $0x1c,%esp
  8028d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028e7:	85 d2                	test   %edx,%edx
  8028e9:	75 4d                	jne    802938 <__udivdi3+0x68>
  8028eb:	39 f3                	cmp    %esi,%ebx
  8028ed:	76 19                	jbe    802908 <__udivdi3+0x38>
  8028ef:	31 ff                	xor    %edi,%edi
  8028f1:	89 e8                	mov    %ebp,%eax
  8028f3:	89 f2                	mov    %esi,%edx
  8028f5:	f7 f3                	div    %ebx
  8028f7:	89 fa                	mov    %edi,%edx
  8028f9:	83 c4 1c             	add    $0x1c,%esp
  8028fc:	5b                   	pop    %ebx
  8028fd:	5e                   	pop    %esi
  8028fe:	5f                   	pop    %edi
  8028ff:	5d                   	pop    %ebp
  802900:	c3                   	ret    
  802901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802908:	89 d9                	mov    %ebx,%ecx
  80290a:	85 db                	test   %ebx,%ebx
  80290c:	75 0b                	jne    802919 <__udivdi3+0x49>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	31 d2                	xor    %edx,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 c1                	mov    %eax,%ecx
  802919:	31 d2                	xor    %edx,%edx
  80291b:	89 f0                	mov    %esi,%eax
  80291d:	f7 f1                	div    %ecx
  80291f:	89 c6                	mov    %eax,%esi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f7                	mov    %esi,%edi
  802925:	f7 f1                	div    %ecx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	39 f2                	cmp    %esi,%edx
  80293a:	77 1c                	ja     802958 <__udivdi3+0x88>
  80293c:	0f bd fa             	bsr    %edx,%edi
  80293f:	83 f7 1f             	xor    $0x1f,%edi
  802942:	75 2c                	jne    802970 <__udivdi3+0xa0>
  802944:	39 f2                	cmp    %esi,%edx
  802946:	72 06                	jb     80294e <__udivdi3+0x7e>
  802948:	31 c0                	xor    %eax,%eax
  80294a:	39 eb                	cmp    %ebp,%ebx
  80294c:	77 a9                	ja     8028f7 <__udivdi3+0x27>
  80294e:	b8 01 00 00 00       	mov    $0x1,%eax
  802953:	eb a2                	jmp    8028f7 <__udivdi3+0x27>
  802955:	8d 76 00             	lea    0x0(%esi),%esi
  802958:	31 ff                	xor    %edi,%edi
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	89 fa                	mov    %edi,%edx
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	89 f9                	mov    %edi,%ecx
  802972:	b8 20 00 00 00       	mov    $0x20,%eax
  802977:	29 f8                	sub    %edi,%eax
  802979:	d3 e2                	shl    %cl,%edx
  80297b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80297f:	89 c1                	mov    %eax,%ecx
  802981:	89 da                	mov    %ebx,%edx
  802983:	d3 ea                	shr    %cl,%edx
  802985:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802989:	09 d1                	or     %edx,%ecx
  80298b:	89 f2                	mov    %esi,%edx
  80298d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802991:	89 f9                	mov    %edi,%ecx
  802993:	d3 e3                	shl    %cl,%ebx
  802995:	89 c1                	mov    %eax,%ecx
  802997:	d3 ea                	shr    %cl,%edx
  802999:	89 f9                	mov    %edi,%ecx
  80299b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80299f:	89 eb                	mov    %ebp,%ebx
  8029a1:	d3 e6                	shl    %cl,%esi
  8029a3:	89 c1                	mov    %eax,%ecx
  8029a5:	d3 eb                	shr    %cl,%ebx
  8029a7:	09 de                	or     %ebx,%esi
  8029a9:	89 f0                	mov    %esi,%eax
  8029ab:	f7 74 24 08          	divl   0x8(%esp)
  8029af:	89 d6                	mov    %edx,%esi
  8029b1:	89 c3                	mov    %eax,%ebx
  8029b3:	f7 64 24 0c          	mull   0xc(%esp)
  8029b7:	39 d6                	cmp    %edx,%esi
  8029b9:	72 15                	jb     8029d0 <__udivdi3+0x100>
  8029bb:	89 f9                	mov    %edi,%ecx
  8029bd:	d3 e5                	shl    %cl,%ebp
  8029bf:	39 c5                	cmp    %eax,%ebp
  8029c1:	73 04                	jae    8029c7 <__udivdi3+0xf7>
  8029c3:	39 d6                	cmp    %edx,%esi
  8029c5:	74 09                	je     8029d0 <__udivdi3+0x100>
  8029c7:	89 d8                	mov    %ebx,%eax
  8029c9:	31 ff                	xor    %edi,%edi
  8029cb:	e9 27 ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029d3:	31 ff                	xor    %edi,%edi
  8029d5:	e9 1d ff ff ff       	jmp    8028f7 <__udivdi3+0x27>
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__umoddi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	53                   	push   %ebx
  8029e4:	83 ec 1c             	sub    $0x1c,%esp
  8029e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029f7:	89 da                	mov    %ebx,%edx
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	75 43                	jne    802a40 <__umoddi3+0x60>
  8029fd:	39 df                	cmp    %ebx,%edi
  8029ff:	76 17                	jbe    802a18 <__umoddi3+0x38>
  802a01:	89 f0                	mov    %esi,%eax
  802a03:	f7 f7                	div    %edi
  802a05:	89 d0                	mov    %edx,%eax
  802a07:	31 d2                	xor    %edx,%edx
  802a09:	83 c4 1c             	add    $0x1c,%esp
  802a0c:	5b                   	pop    %ebx
  802a0d:	5e                   	pop    %esi
  802a0e:	5f                   	pop    %edi
  802a0f:	5d                   	pop    %ebp
  802a10:	c3                   	ret    
  802a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 fd                	mov    %edi,%ebp
  802a1a:	85 ff                	test   %edi,%edi
  802a1c:	75 0b                	jne    802a29 <__umoddi3+0x49>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f7                	div    %edi
  802a27:	89 c5                	mov    %eax,%ebp
  802a29:	89 d8                	mov    %ebx,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	f7 f5                	div    %ebp
  802a2f:	89 f0                	mov    %esi,%eax
  802a31:	f7 f5                	div    %ebp
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	eb d0                	jmp    802a07 <__umoddi3+0x27>
  802a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3e:	66 90                	xchg   %ax,%ax
  802a40:	89 f1                	mov    %esi,%ecx
  802a42:	39 d8                	cmp    %ebx,%eax
  802a44:	76 0a                	jbe    802a50 <__umoddi3+0x70>
  802a46:	89 f0                	mov    %esi,%eax
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	0f bd e8             	bsr    %eax,%ebp
  802a53:	83 f5 1f             	xor    $0x1f,%ebp
  802a56:	75 20                	jne    802a78 <__umoddi3+0x98>
  802a58:	39 d8                	cmp    %ebx,%eax
  802a5a:	0f 82 b0 00 00 00    	jb     802b10 <__umoddi3+0x130>
  802a60:	39 f7                	cmp    %esi,%edi
  802a62:	0f 86 a8 00 00 00    	jbe    802b10 <__umoddi3+0x130>
  802a68:	89 c8                	mov    %ecx,%eax
  802a6a:	83 c4 1c             	add    $0x1c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    
  802a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a7f:	29 ea                	sub    %ebp,%edx
  802a81:	d3 e0                	shl    %cl,%eax
  802a83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a87:	89 d1                	mov    %edx,%ecx
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	d3 e8                	shr    %cl,%eax
  802a8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a99:	09 c1                	or     %eax,%ecx
  802a9b:	89 d8                	mov    %ebx,%eax
  802a9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802aa1:	89 e9                	mov    %ebp,%ecx
  802aa3:	d3 e7                	shl    %cl,%edi
  802aa5:	89 d1                	mov    %edx,%ecx
  802aa7:	d3 e8                	shr    %cl,%eax
  802aa9:	89 e9                	mov    %ebp,%ecx
  802aab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aaf:	d3 e3                	shl    %cl,%ebx
  802ab1:	89 c7                	mov    %eax,%edi
  802ab3:	89 d1                	mov    %edx,%ecx
  802ab5:	89 f0                	mov    %esi,%eax
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 fa                	mov    %edi,%edx
  802abd:	d3 e6                	shl    %cl,%esi
  802abf:	09 d8                	or     %ebx,%eax
  802ac1:	f7 74 24 08          	divl   0x8(%esp)
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	89 f3                	mov    %esi,%ebx
  802ac9:	f7 64 24 0c          	mull   0xc(%esp)
  802acd:	89 c6                	mov    %eax,%esi
  802acf:	89 d7                	mov    %edx,%edi
  802ad1:	39 d1                	cmp    %edx,%ecx
  802ad3:	72 06                	jb     802adb <__umoddi3+0xfb>
  802ad5:	75 10                	jne    802ae7 <__umoddi3+0x107>
  802ad7:	39 c3                	cmp    %eax,%ebx
  802ad9:	73 0c                	jae    802ae7 <__umoddi3+0x107>
  802adb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802adf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ae3:	89 d7                	mov    %edx,%edi
  802ae5:	89 c6                	mov    %eax,%esi
  802ae7:	89 ca                	mov    %ecx,%edx
  802ae9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aee:	29 f3                	sub    %esi,%ebx
  802af0:	19 fa                	sbb    %edi,%edx
  802af2:	89 d0                	mov    %edx,%eax
  802af4:	d3 e0                	shl    %cl,%eax
  802af6:	89 e9                	mov    %ebp,%ecx
  802af8:	d3 eb                	shr    %cl,%ebx
  802afa:	d3 ea                	shr    %cl,%edx
  802afc:	09 d8                	or     %ebx,%eax
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 da                	mov    %ebx,%edx
  802b12:	29 fe                	sub    %edi,%esi
  802b14:	19 c2                	sbb    %eax,%edx
  802b16:	89 f1                	mov    %esi,%ecx
  802b18:	89 c8                	mov    %ecx,%eax
  802b1a:	e9 4b ff ff ff       	jmp    802a6a <__umoddi3+0x8a>
