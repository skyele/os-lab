
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
  800044:	e8 dd 12 00 00       	call   801326 <fork>
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
  8000ba:	68 7b 2b 80 00       	push   $0x802b7b
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
  8000d4:	68 40 2b 80 00       	push   $0x802b40
  8000d9:	6a 21                	push   $0x21
  8000db:	68 68 2b 80 00       	push   $0x802b68
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

	cprintf("call umain!\n");
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	68 99 2b 80 00       	push   $0x802b99
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
  80018d:	e8 fe 15 00 00       	call   801790 <close_all>
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
  8001b1:	68 e0 2b 80 00       	push   $0x802be0
  8001b6:	50                   	push   %eax
  8001b7:	68 b0 2b 80 00       	push   $0x802bb0
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
  8001da:	68 bc 2b 80 00       	push   $0x802bbc
  8001df:	e8 b3 00 00 00       	call   800297 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e4:	83 c4 18             	add    $0x18,%esp
  8001e7:	53                   	push   %ebx
  8001e8:	ff 75 10             	pushl  0x10(%ebp)
  8001eb:	e8 56 00 00 00       	call   800246 <vcprintf>
	cprintf("\n");
  8001f0:	c7 04 24 a4 2b 80 00 	movl   $0x802ba4,(%esp)
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
  800344:	e8 97 25 00 00       	call   8028e0 <__udivdi3>
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
  80036d:	e8 7e 26 00 00       	call   8029f0 <__umoddi3>
  800372:	83 c4 14             	add    $0x14,%esp
  800375:	0f be 80 e7 2b 80 00 	movsbl 0x802be7(%eax),%eax
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
  8004f5:	68 31 31 80 00       	push   $0x803131
  8004fa:	53                   	push   %ebx
  8004fb:	56                   	push   %esi
  8004fc:	e8 a6 fe ff ff       	call   8003a7 <printfmt>
  800501:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800504:	89 7d 14             	mov    %edi,0x14(%ebp)
  800507:	e9 fe 02 00 00       	jmp    80080a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80050c:	50                   	push   %eax
  80050d:	68 ff 2b 80 00       	push   $0x802bff
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
  800534:	b8 f8 2b 80 00       	mov    $0x802bf8,%eax
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
  8008cc:	bf 1d 2d 80 00       	mov    $0x802d1d,%edi
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
  8008f8:	bf 55 2d 80 00       	mov    $0x802d55,%edi
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

008010bd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	53                   	push   %ebx
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8010c7:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010c9:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8010cd:	0f 84 99 00 00 00    	je     80116c <pgfault+0xaf>
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	c1 ea 16             	shr    $0x16,%edx
  8010d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	0f 84 84 00 00 00    	je     80116c <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	c1 ea 0c             	shr    $0xc,%edx
  8010ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f4:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010fa:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801100:	75 6a                	jne    80116c <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801107:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	6a 07                	push   $0x7
  80110e:	68 00 f0 7f 00       	push   $0x7ff000
  801113:	6a 00                	push   $0x0
  801115:	e8 ce fc ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	78 5f                	js     801180 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 00 10 00 00       	push   $0x1000
  801129:	53                   	push   %ebx
  80112a:	68 00 f0 7f 00       	push   $0x7ff000
  80112f:	e8 b2 fa ff ff       	call   800be6 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801134:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80113b:	53                   	push   %ebx
  80113c:	6a 00                	push   $0x0
  80113e:	68 00 f0 7f 00       	push   $0x7ff000
  801143:	6a 00                	push   $0x0
  801145:	e8 e1 fc ff ff       	call   800e2b <sys_page_map>
	if(ret < 0)
  80114a:	83 c4 20             	add    $0x20,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	78 43                	js     801194 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801151:	83 ec 08             	sub    $0x8,%esp
  801154:	68 00 f0 7f 00       	push   $0x7ff000
  801159:	6a 00                	push   $0x0
  80115b:	e8 0d fd ff ff       	call   800e6d <sys_page_unmap>
	if(ret < 0)
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	78 41                	js     8011a8 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    
		panic("panic at pgfault()\n");
  80116c:	83 ec 04             	sub    $0x4,%esp
  80116f:	68 8f 2f 80 00       	push   $0x802f8f
  801174:	6a 26                	push   $0x26
  801176:	68 a3 2f 80 00       	push   $0x802fa3
  80117b:	e8 21 f0 ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_alloc()\n");
  801180:	83 ec 04             	sub    $0x4,%esp
  801183:	68 ae 2f 80 00       	push   $0x802fae
  801188:	6a 31                	push   $0x31
  80118a:	68 a3 2f 80 00       	push   $0x802fa3
  80118f:	e8 0d f0 ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_map()\n");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 c9 2f 80 00       	push   $0x802fc9
  80119c:	6a 36                	push   $0x36
  80119e:	68 a3 2f 80 00       	push   $0x802fa3
  8011a3:	e8 f9 ef ff ff       	call   8001a1 <_panic>
		panic("panic in sys_page_unmap()\n");
  8011a8:	83 ec 04             	sub    $0x4,%esp
  8011ab:	68 e2 2f 80 00       	push   $0x802fe2
  8011b0:	6a 39                	push   $0x39
  8011b2:	68 a3 2f 80 00       	push   $0x802fa3
  8011b7:	e8 e5 ef ff ff       	call   8001a1 <_panic>

008011bc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
  8011c1:	89 c6                	mov    %eax,%esi
  8011c3:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	68 80 30 80 00       	push   $0x803080
  8011cd:	68 b4 2b 80 00       	push   $0x802bb4
  8011d2:	e8 c0 f0 ff ff       	call   800297 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011d7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	f6 c4 04             	test   $0x4,%ah
  8011e4:	75 45                	jne    80122b <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011e6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011ed:	83 e0 07             	and    $0x7,%eax
  8011f0:	83 f8 07             	cmp    $0x7,%eax
  8011f3:	74 6e                	je     801263 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011f5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011fc:	25 05 08 00 00       	and    $0x805,%eax
  801201:	3d 05 08 00 00       	cmp    $0x805,%eax
  801206:	0f 84 b5 00 00 00    	je     8012c1 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80120c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801213:	83 e0 05             	and    $0x5,%eax
  801216:	83 f8 05             	cmp    $0x5,%eax
  801219:	0f 84 d6 00 00 00    	je     8012f5 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
  801224:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80122b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801232:	c1 e3 0c             	shl    $0xc,%ebx
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	25 07 0e 00 00       	and    $0xe07,%eax
  80123d:	50                   	push   %eax
  80123e:	53                   	push   %ebx
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	6a 00                	push   $0x0
  801243:	e8 e3 fb ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801248:	83 c4 20             	add    $0x20,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	79 d0                	jns    80121f <duppage+0x63>
			panic("sys_page_map() panic\n");
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	68 fd 2f 80 00       	push   $0x802ffd
  801257:	6a 55                	push   $0x55
  801259:	68 a3 2f 80 00       	push   $0x802fa3
  80125e:	e8 3e ef ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801263:	c1 e3 0c             	shl    $0xc,%ebx
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	68 05 08 00 00       	push   $0x805
  80126e:	53                   	push   %ebx
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
  801271:	6a 00                	push   $0x0
  801273:	e8 b3 fb ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801278:	83 c4 20             	add    $0x20,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	78 2e                	js     8012ad <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	68 05 08 00 00       	push   $0x805
  801287:	53                   	push   %ebx
  801288:	6a 00                	push   $0x0
  80128a:	53                   	push   %ebx
  80128b:	6a 00                	push   $0x0
  80128d:	e8 99 fb ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801292:	83 c4 20             	add    $0x20,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	79 86                	jns    80121f <duppage+0x63>
			panic("sys_page_map() panic\n");
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	68 fd 2f 80 00       	push   $0x802ffd
  8012a1:	6a 60                	push   $0x60
  8012a3:	68 a3 2f 80 00       	push   $0x802fa3
  8012a8:	e8 f4 ee ff ff       	call   8001a1 <_panic>
			panic("sys_page_map() panic\n");
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	68 fd 2f 80 00       	push   $0x802ffd
  8012b5:	6a 5c                	push   $0x5c
  8012b7:	68 a3 2f 80 00       	push   $0x802fa3
  8012bc:	e8 e0 ee ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012c1:	c1 e3 0c             	shl    $0xc,%ebx
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	68 05 08 00 00       	push   $0x805
  8012cc:	53                   	push   %ebx
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 55 fb ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  8012d6:	83 c4 20             	add    $0x20,%esp
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	0f 89 3e ff ff ff    	jns    80121f <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	68 fd 2f 80 00       	push   $0x802ffd
  8012e9:	6a 67                	push   $0x67
  8012eb:	68 a3 2f 80 00       	push   $0x802fa3
  8012f0:	e8 ac ee ff ff       	call   8001a1 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012f5:	c1 e3 0c             	shl    $0xc,%ebx
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	6a 05                	push   $0x5
  8012fd:	53                   	push   %ebx
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
  801300:	6a 00                	push   $0x0
  801302:	e8 24 fb ff ff       	call   800e2b <sys_page_map>
		if(r < 0)
  801307:	83 c4 20             	add    $0x20,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	0f 89 0d ff ff ff    	jns    80121f <duppage+0x63>
			panic("sys_page_map() panic\n");
  801312:	83 ec 04             	sub    $0x4,%esp
  801315:	68 fd 2f 80 00       	push   $0x802ffd
  80131a:	6a 6e                	push   $0x6e
  80131c:	68 a3 2f 80 00       	push   $0x802fa3
  801321:	e8 7b ee ff ff       	call   8001a1 <_panic>

00801326 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80132f:	68 bd 10 80 00       	push   $0x8010bd
  801334:	e8 d5 13 00 00       	call   80270e <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801339:	b8 07 00 00 00       	mov    $0x7,%eax
  80133e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	78 27                	js     80136e <fork+0x48>
  801347:	89 c6                	mov    %eax,%esi
  801349:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80134b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801350:	75 48                	jne    80139a <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801352:	e8 53 fa ff ff       	call   800daa <sys_getenvid>
  801357:	25 ff 03 00 00       	and    $0x3ff,%eax
  80135c:	c1 e0 07             	shl    $0x7,%eax
  80135f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801364:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801369:	e9 90 00 00 00       	jmp    8013fe <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 14 30 80 00       	push   $0x803014
  801376:	68 8d 00 00 00       	push   $0x8d
  80137b:	68 a3 2f 80 00       	push   $0x802fa3
  801380:	e8 1c ee ff ff       	call   8001a1 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801385:	89 f8                	mov    %edi,%eax
  801387:	e8 30 fe ff ff       	call   8011bc <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80138c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801392:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801398:	74 26                	je     8013c0 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80139a:	89 d8                	mov    %ebx,%eax
  80139c:	c1 e8 16             	shr    $0x16,%eax
  80139f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a6:	a8 01                	test   $0x1,%al
  8013a8:	74 e2                	je     80138c <fork+0x66>
  8013aa:	89 da                	mov    %ebx,%edx
  8013ac:	c1 ea 0c             	shr    $0xc,%edx
  8013af:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013b6:	83 e0 05             	and    $0x5,%eax
  8013b9:	83 f8 05             	cmp    $0x5,%eax
  8013bc:	75 ce                	jne    80138c <fork+0x66>
  8013be:	eb c5                	jmp    801385 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	6a 07                	push   $0x7
  8013c5:	68 00 f0 bf ee       	push   $0xeebff000
  8013ca:	56                   	push   %esi
  8013cb:	e8 18 fa ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 31                	js     801408 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	68 7d 27 80 00       	push   $0x80277d
  8013df:	56                   	push   %esi
  8013e0:	e8 4e fb ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	78 33                	js     80141f <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	6a 02                	push   $0x2
  8013f1:	56                   	push   %esi
  8013f2:	e8 b8 fa ff ff       	call   800eaf <sys_env_set_status>
	if(ret < 0)
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 38                	js     801436 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013fe:	89 f0                	mov    %esi,%eax
  801400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	68 ae 2f 80 00       	push   $0x802fae
  801410:	68 99 00 00 00       	push   $0x99
  801415:	68 a3 2f 80 00       	push   $0x802fa3
  80141a:	e8 82 ed ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80141f:	83 ec 04             	sub    $0x4,%esp
  801422:	68 38 30 80 00       	push   $0x803038
  801427:	68 9c 00 00 00       	push   $0x9c
  80142c:	68 a3 2f 80 00       	push   $0x802fa3
  801431:	e8 6b ed ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	68 60 30 80 00       	push   $0x803060
  80143e:	68 9f 00 00 00       	push   $0x9f
  801443:	68 a3 2f 80 00       	push   $0x802fa3
  801448:	e8 54 ed ff ff       	call   8001a1 <_panic>

0080144d <sfork>:

// Challenge!
int
sfork(void)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	57                   	push   %edi
  801451:	56                   	push   %esi
  801452:	53                   	push   %ebx
  801453:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801456:	68 bd 10 80 00       	push   $0x8010bd
  80145b:	e8 ae 12 00 00       	call   80270e <set_pgfault_handler>
  801460:	b8 07 00 00 00       	mov    $0x7,%eax
  801465:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 27                	js     801495 <sfork+0x48>
  80146e:	89 c7                	mov    %eax,%edi
  801470:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801472:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801477:	75 55                	jne    8014ce <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801479:	e8 2c f9 ff ff       	call   800daa <sys_getenvid>
  80147e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801483:	c1 e0 07             	shl    $0x7,%eax
  801486:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80148b:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801490:	e9 d4 00 00 00       	jmp    801569 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	68 14 30 80 00       	push   $0x803014
  80149d:	68 b0 00 00 00       	push   $0xb0
  8014a2:	68 a3 2f 80 00       	push   $0x802fa3
  8014a7:	e8 f5 ec ff ff       	call   8001a1 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014ac:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014b1:	89 f0                	mov    %esi,%eax
  8014b3:	e8 04 fd ff ff       	call   8011bc <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014be:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014c4:	77 65                	ja     80152b <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014c6:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014cc:	74 de                	je     8014ac <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014ce:	89 d8                	mov    %ebx,%eax
  8014d0:	c1 e8 16             	shr    $0x16,%eax
  8014d3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014da:	a8 01                	test   $0x1,%al
  8014dc:	74 da                	je     8014b8 <sfork+0x6b>
  8014de:	89 da                	mov    %ebx,%edx
  8014e0:	c1 ea 0c             	shr    $0xc,%edx
  8014e3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014ea:	83 e0 05             	and    $0x5,%eax
  8014ed:	83 f8 05             	cmp    $0x5,%eax
  8014f0:	75 c6                	jne    8014b8 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014f2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014f9:	c1 e2 0c             	shl    $0xc,%edx
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	83 e0 07             	and    $0x7,%eax
  801502:	50                   	push   %eax
  801503:	52                   	push   %edx
  801504:	56                   	push   %esi
  801505:	52                   	push   %edx
  801506:	6a 00                	push   $0x0
  801508:	e8 1e f9 ff ff       	call   800e2b <sys_page_map>
  80150d:	83 c4 20             	add    $0x20,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	74 a4                	je     8014b8 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 fd 2f 80 00       	push   $0x802ffd
  80151c:	68 bb 00 00 00       	push   $0xbb
  801521:	68 a3 2f 80 00       	push   $0x802fa3
  801526:	e8 76 ec ff ff       	call   8001a1 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	6a 07                	push   $0x7
  801530:	68 00 f0 bf ee       	push   $0xeebff000
  801535:	57                   	push   %edi
  801536:	e8 ad f8 ff ff       	call   800de8 <sys_page_alloc>
	if(ret < 0)
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 31                	js     801573 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	68 7d 27 80 00       	push   $0x80277d
  80154a:	57                   	push   %edi
  80154b:	e8 e3 f9 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 33                	js     80158a <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	6a 02                	push   $0x2
  80155c:	57                   	push   %edi
  80155d:	e8 4d f9 ff ff       	call   800eaf <sys_env_set_status>
	if(ret < 0)
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 38                	js     8015a1 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801569:	89 f8                	mov    %edi,%eax
  80156b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156e:	5b                   	pop    %ebx
  80156f:	5e                   	pop    %esi
  801570:	5f                   	pop    %edi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 ae 2f 80 00       	push   $0x802fae
  80157b:	68 c1 00 00 00       	push   $0xc1
  801580:	68 a3 2f 80 00       	push   $0x802fa3
  801585:	e8 17 ec ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	68 38 30 80 00       	push   $0x803038
  801592:	68 c4 00 00 00       	push   $0xc4
  801597:	68 a3 2f 80 00       	push   $0x802fa3
  80159c:	e8 00 ec ff ff       	call   8001a1 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 60 30 80 00       	push   $0x803060
  8015a9:	68 c7 00 00 00       	push   $0xc7
  8015ae:	68 a3 2f 80 00       	push   $0x802fa3
  8015b3:	e8 e9 eb ff ff       	call   8001a1 <_panic>

008015b8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	05 00 00 00 30       	add    $0x30000000,%eax
  8015c3:	c1 e8 0c             	shr    $0xc,%eax
}
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    

008015c8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015e7:	89 c2                	mov    %eax,%edx
  8015e9:	c1 ea 16             	shr    $0x16,%edx
  8015ec:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f3:	f6 c2 01             	test   $0x1,%dl
  8015f6:	74 2d                	je     801625 <fd_alloc+0x46>
  8015f8:	89 c2                	mov    %eax,%edx
  8015fa:	c1 ea 0c             	shr    $0xc,%edx
  8015fd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801604:	f6 c2 01             	test   $0x1,%dl
  801607:	74 1c                	je     801625 <fd_alloc+0x46>
  801609:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80160e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801613:	75 d2                	jne    8015e7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80161e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801623:	eb 0a                	jmp    80162f <fd_alloc+0x50>
			*fd_store = fd;
  801625:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801628:	89 01                	mov    %eax,(%ecx)
			return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801637:	83 f8 1f             	cmp    $0x1f,%eax
  80163a:	77 30                	ja     80166c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80163c:	c1 e0 0c             	shl    $0xc,%eax
  80163f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801644:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80164a:	f6 c2 01             	test   $0x1,%dl
  80164d:	74 24                	je     801673 <fd_lookup+0x42>
  80164f:	89 c2                	mov    %eax,%edx
  801651:	c1 ea 0c             	shr    $0xc,%edx
  801654:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165b:	f6 c2 01             	test   $0x1,%dl
  80165e:	74 1a                	je     80167a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	89 02                	mov    %eax,(%edx)
	return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    
		return -E_INVAL;
  80166c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801671:	eb f7                	jmp    80166a <fd_lookup+0x39>
		return -E_INVAL;
  801673:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801678:	eb f0                	jmp    80166a <fd_lookup+0x39>
  80167a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167f:	eb e9                	jmp    80166a <fd_lookup+0x39>

00801681 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801694:	39 08                	cmp    %ecx,(%eax)
  801696:	74 38                	je     8016d0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801698:	83 c2 01             	add    $0x1,%edx
  80169b:	8b 04 95 04 31 80 00 	mov    0x803104(,%edx,4),%eax
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	75 ee                	jne    801694 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016a6:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016ab:	8b 40 48             	mov    0x48(%eax),%eax
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	51                   	push   %ecx
  8016b2:	50                   	push   %eax
  8016b3:	68 88 30 80 00       	push   $0x803088
  8016b8:	e8 da eb ff ff       	call   800297 <cprintf>
	*dev = 0;
  8016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    
			*dev = devtab[i];
  8016d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb f2                	jmp    8016ce <dev_lookup+0x4d>

008016dc <fd_close>:
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 24             	sub    $0x24,%esp
  8016e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8016e8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016ee:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016ef:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016f5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f8:	50                   	push   %eax
  8016f9:	e8 33 ff ff ff       	call   801631 <fd_lookup>
  8016fe:	89 c3                	mov    %eax,%ebx
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 05                	js     80170c <fd_close+0x30>
	    || fd != fd2)
  801707:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80170a:	74 16                	je     801722 <fd_close+0x46>
		return (must_exist ? r : 0);
  80170c:	89 f8                	mov    %edi,%eax
  80170e:	84 c0                	test   %al,%al
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	0f 44 d8             	cmove  %eax,%ebx
}
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5f                   	pop    %edi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801728:	50                   	push   %eax
  801729:	ff 36                	pushl  (%esi)
  80172b:	e8 51 ff ff ff       	call   801681 <dev_lookup>
  801730:	89 c3                	mov    %eax,%ebx
  801732:	83 c4 10             	add    $0x10,%esp
  801735:	85 c0                	test   %eax,%eax
  801737:	78 1a                	js     801753 <fd_close+0x77>
		if (dev->dev_close)
  801739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80173f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801744:	85 c0                	test   %eax,%eax
  801746:	74 0b                	je     801753 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	56                   	push   %esi
  80174c:	ff d0                	call   *%eax
  80174e:	89 c3                	mov    %eax,%ebx
  801750:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801753:	83 ec 08             	sub    $0x8,%esp
  801756:	56                   	push   %esi
  801757:	6a 00                	push   $0x0
  801759:	e8 0f f7 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  80175e:	83 c4 10             	add    $0x10,%esp
  801761:	eb b5                	jmp    801718 <fd_close+0x3c>

00801763 <close>:

int
close(int fdnum)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176c:	50                   	push   %eax
  80176d:	ff 75 08             	pushl  0x8(%ebp)
  801770:	e8 bc fe ff ff       	call   801631 <fd_lookup>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	85 c0                	test   %eax,%eax
  80177a:	79 02                	jns    80177e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
		return fd_close(fd, 1);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	6a 01                	push   $0x1
  801783:	ff 75 f4             	pushl  -0xc(%ebp)
  801786:	e8 51 ff ff ff       	call   8016dc <fd_close>
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	eb ec                	jmp    80177c <close+0x19>

00801790 <close_all>:

void
close_all(void)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801797:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	53                   	push   %ebx
  8017a0:	e8 be ff ff ff       	call   801763 <close>
	for (i = 0; i < MAXFD; i++)
  8017a5:	83 c3 01             	add    $0x1,%ebx
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	83 fb 20             	cmp    $0x20,%ebx
  8017ae:	75 ec                	jne    80179c <close_all+0xc>
}
  8017b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	57                   	push   %edi
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c1:	50                   	push   %eax
  8017c2:	ff 75 08             	pushl  0x8(%ebp)
  8017c5:	e8 67 fe ff ff       	call   801631 <fd_lookup>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	0f 88 81 00 00 00    	js     801858 <dup+0xa3>
		return r;
	close(newfdnum);
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	e8 81 ff ff ff       	call   801763 <close>

	newfd = INDEX2FD(newfdnum);
  8017e2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017e5:	c1 e6 0c             	shl    $0xc,%esi
  8017e8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017f4:	e8 cf fd ff ff       	call   8015c8 <fd2data>
  8017f9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017fb:	89 34 24             	mov    %esi,(%esp)
  8017fe:	e8 c5 fd ff ff       	call   8015c8 <fd2data>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801808:	89 d8                	mov    %ebx,%eax
  80180a:	c1 e8 16             	shr    $0x16,%eax
  80180d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801814:	a8 01                	test   $0x1,%al
  801816:	74 11                	je     801829 <dup+0x74>
  801818:	89 d8                	mov    %ebx,%eax
  80181a:	c1 e8 0c             	shr    $0xc,%eax
  80181d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801824:	f6 c2 01             	test   $0x1,%dl
  801827:	75 39                	jne    801862 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801829:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80182c:	89 d0                	mov    %edx,%eax
  80182e:	c1 e8 0c             	shr    $0xc,%eax
  801831:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801838:	83 ec 0c             	sub    $0xc,%esp
  80183b:	25 07 0e 00 00       	and    $0xe07,%eax
  801840:	50                   	push   %eax
  801841:	56                   	push   %esi
  801842:	6a 00                	push   $0x0
  801844:	52                   	push   %edx
  801845:	6a 00                	push   $0x0
  801847:	e8 df f5 ff ff       	call   800e2b <sys_page_map>
  80184c:	89 c3                	mov    %eax,%ebx
  80184e:	83 c4 20             	add    $0x20,%esp
  801851:	85 c0                	test   %eax,%eax
  801853:	78 31                	js     801886 <dup+0xd1>
		goto err;

	return newfdnum;
  801855:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801858:	89 d8                	mov    %ebx,%eax
  80185a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801862:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801869:	83 ec 0c             	sub    $0xc,%esp
  80186c:	25 07 0e 00 00       	and    $0xe07,%eax
  801871:	50                   	push   %eax
  801872:	57                   	push   %edi
  801873:	6a 00                	push   $0x0
  801875:	53                   	push   %ebx
  801876:	6a 00                	push   $0x0
  801878:	e8 ae f5 ff ff       	call   800e2b <sys_page_map>
  80187d:	89 c3                	mov    %eax,%ebx
  80187f:	83 c4 20             	add    $0x20,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	79 a3                	jns    801829 <dup+0x74>
	sys_page_unmap(0, newfd);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	56                   	push   %esi
  80188a:	6a 00                	push   $0x0
  80188c:	e8 dc f5 ff ff       	call   800e6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801891:	83 c4 08             	add    $0x8,%esp
  801894:	57                   	push   %edi
  801895:	6a 00                	push   $0x0
  801897:	e8 d1 f5 ff ff       	call   800e6d <sys_page_unmap>
	return r;
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	eb b7                	jmp    801858 <dup+0xa3>

008018a1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 1c             	sub    $0x1c,%esp
  8018a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ae:	50                   	push   %eax
  8018af:	53                   	push   %ebx
  8018b0:	e8 7c fd ff ff       	call   801631 <fd_lookup>
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 3f                	js     8018fb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c2:	50                   	push   %eax
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	ff 30                	pushl  (%eax)
  8018c8:	e8 b4 fd ff ff       	call   801681 <dev_lookup>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	78 27                	js     8018fb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d7:	8b 42 08             	mov    0x8(%edx),%eax
  8018da:	83 e0 03             	and    $0x3,%eax
  8018dd:	83 f8 01             	cmp    $0x1,%eax
  8018e0:	74 1e                	je     801900 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e5:	8b 40 08             	mov    0x8(%eax),%eax
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	74 35                	je     801921 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	52                   	push   %edx
  8018f6:	ff d0                	call   *%eax
  8018f8:	83 c4 10             	add    $0x10,%esp
}
  8018fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801900:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801905:	8b 40 48             	mov    0x48(%eax),%eax
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	53                   	push   %ebx
  80190c:	50                   	push   %eax
  80190d:	68 c9 30 80 00       	push   $0x8030c9
  801912:	e8 80 e9 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80191f:	eb da                	jmp    8018fb <read+0x5a>
		return -E_NOT_SUPP;
  801921:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801926:	eb d3                	jmp    8018fb <read+0x5a>

00801928 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	57                   	push   %edi
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	8b 7d 08             	mov    0x8(%ebp),%edi
  801934:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801937:	bb 00 00 00 00       	mov    $0x0,%ebx
  80193c:	39 f3                	cmp    %esi,%ebx
  80193e:	73 23                	jae    801963 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	89 f0                	mov    %esi,%eax
  801945:	29 d8                	sub    %ebx,%eax
  801947:	50                   	push   %eax
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	03 45 0c             	add    0xc(%ebp),%eax
  80194d:	50                   	push   %eax
  80194e:	57                   	push   %edi
  80194f:	e8 4d ff ff ff       	call   8018a1 <read>
		if (m < 0)
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 06                	js     801961 <readn+0x39>
			return m;
		if (m == 0)
  80195b:	74 06                	je     801963 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80195d:	01 c3                	add    %eax,%ebx
  80195f:	eb db                	jmp    80193c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801961:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801963:	89 d8                	mov    %ebx,%eax
  801965:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5f                   	pop    %edi
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    

0080196d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 1c             	sub    $0x1c,%esp
  801974:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801977:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197a:	50                   	push   %eax
  80197b:	53                   	push   %ebx
  80197c:	e8 b0 fc ff ff       	call   801631 <fd_lookup>
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 3a                	js     8019c2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801988:	83 ec 08             	sub    $0x8,%esp
  80198b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198e:	50                   	push   %eax
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	ff 30                	pushl  (%eax)
  801994:	e8 e8 fc ff ff       	call   801681 <dev_lookup>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 22                	js     8019c2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a7:	74 1e                	je     8019c7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8019af:	85 d2                	test   %edx,%edx
  8019b1:	74 35                	je     8019e8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	ff 75 10             	pushl  0x10(%ebp)
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	50                   	push   %eax
  8019bd:	ff d2                	call   *%edx
  8019bf:	83 c4 10             	add    $0x10,%esp
}
  8019c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019cc:	8b 40 48             	mov    0x48(%eax),%eax
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	53                   	push   %ebx
  8019d3:	50                   	push   %eax
  8019d4:	68 e5 30 80 00       	push   $0x8030e5
  8019d9:	e8 b9 e8 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e6:	eb da                	jmp    8019c2 <write+0x55>
		return -E_NOT_SUPP;
  8019e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ed:	eb d3                	jmp    8019c2 <write+0x55>

008019ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 30 fc ff ff       	call   801631 <fd_lookup>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 0e                	js     801a16 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 1c             	sub    $0x1c,%esp
  801a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a22:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a25:	50                   	push   %eax
  801a26:	53                   	push   %ebx
  801a27:	e8 05 fc ff ff       	call   801631 <fd_lookup>
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 37                	js     801a6a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a39:	50                   	push   %eax
  801a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3d:	ff 30                	pushl  (%eax)
  801a3f:	e8 3d fc ff ff       	call   801681 <dev_lookup>
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 1f                	js     801a6a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a52:	74 1b                	je     801a6f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a57:	8b 52 18             	mov    0x18(%edx),%edx
  801a5a:	85 d2                	test   %edx,%edx
  801a5c:	74 32                	je     801a90 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a5e:	83 ec 08             	sub    $0x8,%esp
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	50                   	push   %eax
  801a65:	ff d2                	call   *%edx
  801a67:	83 c4 10             	add    $0x10,%esp
}
  801a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a6f:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a74:	8b 40 48             	mov    0x48(%eax),%eax
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	53                   	push   %ebx
  801a7b:	50                   	push   %eax
  801a7c:	68 a8 30 80 00       	push   $0x8030a8
  801a81:	e8 11 e8 ff ff       	call   800297 <cprintf>
		return -E_INVAL;
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a8e:	eb da                	jmp    801a6a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a90:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a95:	eb d3                	jmp    801a6a <ftruncate+0x52>

00801a97 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	53                   	push   %ebx
  801a9b:	83 ec 1c             	sub    $0x1c,%esp
  801a9e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	e8 84 fb ff ff       	call   801631 <fd_lookup>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 4b                	js     801aff <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aba:	50                   	push   %eax
  801abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abe:	ff 30                	pushl  (%eax)
  801ac0:	e8 bc fb ff ff       	call   801681 <dev_lookup>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	78 33                	js     801aff <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ad3:	74 2f                	je     801b04 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ad5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ad8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801adf:	00 00 00 
	stat->st_isdir = 0;
  801ae2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ae9:	00 00 00 
	stat->st_dev = dev;
  801aec:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	53                   	push   %ebx
  801af6:	ff 75 f0             	pushl  -0x10(%ebp)
  801af9:	ff 50 14             	call   *0x14(%eax)
  801afc:	83 c4 10             	add    $0x10,%esp
}
  801aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    
		return -E_NOT_SUPP;
  801b04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b09:	eb f4                	jmp    801aff <fstat+0x68>

00801b0b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	6a 00                	push   $0x0
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	e8 22 02 00 00       	call   801d3f <open>
  801b1d:	89 c3                	mov    %eax,%ebx
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 1b                	js     801b41 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	50                   	push   %eax
  801b2d:	e8 65 ff ff ff       	call   801a97 <fstat>
  801b32:	89 c6                	mov    %eax,%esi
	close(fd);
  801b34:	89 1c 24             	mov    %ebx,(%esp)
  801b37:	e8 27 fc ff ff       	call   801763 <close>
	return r;
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	89 f3                	mov    %esi,%ebx
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	89 c6                	mov    %eax,%esi
  801b51:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b53:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b5a:	74 27                	je     801b83 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b5c:	6a 07                	push   $0x7
  801b5e:	68 00 60 80 00       	push   $0x806000
  801b63:	56                   	push   %esi
  801b64:	ff 35 00 50 80 00    	pushl  0x805000
  801b6a:	e8 9d 0c 00 00       	call   80280c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b6f:	83 c4 0c             	add    $0xc,%esp
  801b72:	6a 00                	push   $0x0
  801b74:	53                   	push   %ebx
  801b75:	6a 00                	push   $0x0
  801b77:	e8 27 0c 00 00       	call   8027a3 <ipc_recv>
}
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b83:	83 ec 0c             	sub    $0xc,%esp
  801b86:	6a 01                	push   $0x1
  801b88:	e8 d7 0c 00 00       	call   802864 <ipc_find_env>
  801b8d:	a3 00 50 80 00       	mov    %eax,0x805000
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	eb c5                	jmp    801b5c <fsipc+0x12>

00801b97 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba3:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bab:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb5:	b8 02 00 00 00       	mov    $0x2,%eax
  801bba:	e8 8b ff ff ff       	call   801b4a <fsipc>
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <devfile_flush>:
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcd:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 06 00 00 00       	mov    $0x6,%eax
  801bdc:	e8 69 ff ff ff       	call   801b4a <fsipc>
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <devfile_stat>:
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	53                   	push   %ebx
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf3:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  801c02:	e8 43 ff ff ff       	call   801b4a <fsipc>
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 2c                	js     801c37 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c0b:	83 ec 08             	sub    $0x8,%esp
  801c0e:	68 00 60 80 00       	push   $0x806000
  801c13:	53                   	push   %ebx
  801c14:	e8 dd ed ff ff       	call   8009f6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c19:	a1 80 60 80 00       	mov    0x806080,%eax
  801c1e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c24:	a1 84 60 80 00       	mov    0x806084,%eax
  801c29:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <devfile_write>:
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 08             	sub    $0x8,%esp
  801c43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c51:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c57:	53                   	push   %ebx
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	68 08 60 80 00       	push   $0x806008
  801c60:	e8 81 ef ff ff       	call   800be6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c65:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c6f:	e8 d6 fe ff ff       	call   801b4a <fsipc>
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	85 c0                	test   %eax,%eax
  801c79:	78 0b                	js     801c86 <devfile_write+0x4a>
	assert(r <= n);
  801c7b:	39 d8                	cmp    %ebx,%eax
  801c7d:	77 0c                	ja     801c8b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801c7f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c84:	7f 1e                	jg     801ca4 <devfile_write+0x68>
}
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    
	assert(r <= n);
  801c8b:	68 18 31 80 00       	push   $0x803118
  801c90:	68 1f 31 80 00       	push   $0x80311f
  801c95:	68 98 00 00 00       	push   $0x98
  801c9a:	68 34 31 80 00       	push   $0x803134
  801c9f:	e8 fd e4 ff ff       	call   8001a1 <_panic>
	assert(r <= PGSIZE);
  801ca4:	68 3f 31 80 00       	push   $0x80313f
  801ca9:	68 1f 31 80 00       	push   $0x80311f
  801cae:	68 99 00 00 00       	push   $0x99
  801cb3:	68 34 31 80 00       	push   $0x803134
  801cb8:	e8 e4 e4 ff ff       	call   8001a1 <_panic>

00801cbd <devfile_read>:
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cd0:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce0:	e8 65 fe ff ff       	call   801b4a <fsipc>
  801ce5:	89 c3                	mov    %eax,%ebx
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 1f                	js     801d0a <devfile_read+0x4d>
	assert(r <= n);
  801ceb:	39 f0                	cmp    %esi,%eax
  801ced:	77 24                	ja     801d13 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cf4:	7f 33                	jg     801d29 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	50                   	push   %eax
  801cfa:	68 00 60 80 00       	push   $0x806000
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	e8 7d ee ff ff       	call   800b84 <memmove>
	return r;
  801d07:	83 c4 10             	add    $0x10,%esp
}
  801d0a:	89 d8                	mov    %ebx,%eax
  801d0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5d                   	pop    %ebp
  801d12:	c3                   	ret    
	assert(r <= n);
  801d13:	68 18 31 80 00       	push   $0x803118
  801d18:	68 1f 31 80 00       	push   $0x80311f
  801d1d:	6a 7c                	push   $0x7c
  801d1f:	68 34 31 80 00       	push   $0x803134
  801d24:	e8 78 e4 ff ff       	call   8001a1 <_panic>
	assert(r <= PGSIZE);
  801d29:	68 3f 31 80 00       	push   $0x80313f
  801d2e:	68 1f 31 80 00       	push   $0x80311f
  801d33:	6a 7d                	push   $0x7d
  801d35:	68 34 31 80 00       	push   $0x803134
  801d3a:	e8 62 e4 ff ff       	call   8001a1 <_panic>

00801d3f <open>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
  801d47:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d4a:	56                   	push   %esi
  801d4b:	e8 6d ec ff ff       	call   8009bd <strlen>
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d58:	7f 6c                	jg     801dc6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d5a:	83 ec 0c             	sub    $0xc,%esp
  801d5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d60:	50                   	push   %eax
  801d61:	e8 79 f8 ff ff       	call   8015df <fd_alloc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	78 3c                	js     801dab <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d6f:	83 ec 08             	sub    $0x8,%esp
  801d72:	56                   	push   %esi
  801d73:	68 00 60 80 00       	push   $0x806000
  801d78:	e8 79 ec ff ff       	call   8009f6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d80:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d88:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8d:	e8 b8 fd ff ff       	call   801b4a <fsipc>
  801d92:	89 c3                	mov    %eax,%ebx
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	85 c0                	test   %eax,%eax
  801d99:	78 19                	js     801db4 <open+0x75>
	return fd2num(fd);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801da1:	e8 12 f8 ff ff       	call   8015b8 <fd2num>
  801da6:	89 c3                	mov    %eax,%ebx
  801da8:	83 c4 10             	add    $0x10,%esp
}
  801dab:	89 d8                	mov    %ebx,%eax
  801dad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5d                   	pop    %ebp
  801db3:	c3                   	ret    
		fd_close(fd, 0);
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	6a 00                	push   $0x0
  801db9:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbc:	e8 1b f9 ff ff       	call   8016dc <fd_close>
		return r;
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	eb e5                	jmp    801dab <open+0x6c>
		return -E_BAD_PATH;
  801dc6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801dcb:	eb de                	jmp    801dab <open+0x6c>

00801dcd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd8:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddd:	e8 68 fd ff ff       	call   801b4a <fsipc>
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dea:	68 4b 31 80 00       	push   $0x80314b
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	e8 ff eb ff ff       	call   8009f6 <strcpy>
	return 0;
}
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <devsock_close>:
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	53                   	push   %ebx
  801e02:	83 ec 10             	sub    $0x10,%esp
  801e05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e08:	53                   	push   %ebx
  801e09:	e8 91 0a 00 00       	call   80289f <pageref>
  801e0e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e11:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e16:	83 f8 01             	cmp    $0x1,%eax
  801e19:	74 07                	je     801e22 <devsock_close+0x24>
}
  801e1b:	89 d0                	mov    %edx,%eax
  801e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 73 0c             	pushl  0xc(%ebx)
  801e28:	e8 b9 02 00 00       	call   8020e6 <nsipc_close>
  801e2d:	89 c2                	mov    %eax,%edx
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	eb e7                	jmp    801e1b <devsock_close+0x1d>

00801e34 <devsock_write>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	ff 75 10             	pushl  0x10(%ebp)
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	ff 70 0c             	pushl  0xc(%eax)
  801e48:	e8 76 03 00 00       	call   8021c3 <nsipc_send>
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <devsock_read>:
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	ff 75 10             	pushl  0x10(%ebp)
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	ff 70 0c             	pushl  0xc(%eax)
  801e63:	e8 ef 02 00 00       	call   802157 <nsipc_recv>
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <fd2sockid>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e70:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	e8 b7 f7 ff ff       	call   801631 <fd_lookup>
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	78 10                	js     801e91 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e8a:	39 08                	cmp    %ecx,(%eax)
  801e8c:	75 05                	jne    801e93 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e8e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    
		return -E_NOT_SUPP;
  801e93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e98:	eb f7                	jmp    801e91 <fd2sockid+0x27>

00801e9a <alloc_sockfd>:
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 1c             	sub    $0x1c,%esp
  801ea2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea7:	50                   	push   %eax
  801ea8:	e8 32 f7 ff ff       	call   8015df <fd_alloc>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	78 43                	js     801ef9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 07 04 00 00       	push   $0x407
  801ebe:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec1:	6a 00                	push   $0x0
  801ec3:	e8 20 ef ff ff       	call   800de8 <sys_page_alloc>
  801ec8:	89 c3                	mov    %eax,%ebx
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	78 28                	js     801ef9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801eda:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ee6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	50                   	push   %eax
  801eed:	e8 c6 f6 ff ff       	call   8015b8 <fd2num>
  801ef2:	89 c3                	mov    %eax,%ebx
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	eb 0c                	jmp    801f05 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	56                   	push   %esi
  801efd:	e8 e4 01 00 00       	call   8020e6 <nsipc_close>
		return r;
  801f02:	83 c4 10             	add    $0x10,%esp
}
  801f05:	89 d8                	mov    %ebx,%eax
  801f07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5e                   	pop    %esi
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    

00801f0e <accept>:
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	e8 4e ff ff ff       	call   801e6a <fd2sockid>
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 1b                	js     801f3b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	ff 75 10             	pushl  0x10(%ebp)
  801f26:	ff 75 0c             	pushl  0xc(%ebp)
  801f29:	50                   	push   %eax
  801f2a:	e8 0e 01 00 00       	call   80203d <nsipc_accept>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 05                	js     801f3b <accept+0x2d>
	return alloc_sockfd(r);
  801f36:	e8 5f ff ff ff       	call   801e9a <alloc_sockfd>
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <bind>:
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	e8 1f ff ff ff       	call   801e6a <fd2sockid>
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 12                	js     801f61 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f4f:	83 ec 04             	sub    $0x4,%esp
  801f52:	ff 75 10             	pushl  0x10(%ebp)
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	50                   	push   %eax
  801f59:	e8 31 01 00 00       	call   80208f <nsipc_bind>
  801f5e:	83 c4 10             	add    $0x10,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <shutdown>:
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	e8 f9 fe ff ff       	call   801e6a <fd2sockid>
  801f71:	85 c0                	test   %eax,%eax
  801f73:	78 0f                	js     801f84 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	50                   	push   %eax
  801f7c:	e8 43 01 00 00       	call   8020c4 <nsipc_shutdown>
  801f81:	83 c4 10             	add    $0x10,%esp
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <connect>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	e8 d6 fe ff ff       	call   801e6a <fd2sockid>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 12                	js     801faa <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	50                   	push   %eax
  801fa2:	e8 59 01 00 00       	call   802100 <nsipc_connect>
  801fa7:	83 c4 10             	add    $0x10,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <listen>:
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	e8 b0 fe ff ff       	call   801e6a <fd2sockid>
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 0f                	js     801fcd <listen+0x21>
	return nsipc_listen(r, backlog);
  801fbe:	83 ec 08             	sub    $0x8,%esp
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	50                   	push   %eax
  801fc5:	e8 6b 01 00 00       	call   802135 <nsipc_listen>
  801fca:	83 c4 10             	add    $0x10,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <socket>:

int
socket(int domain, int type, int protocol)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fd5:	ff 75 10             	pushl  0x10(%ebp)
  801fd8:	ff 75 0c             	pushl  0xc(%ebp)
  801fdb:	ff 75 08             	pushl  0x8(%ebp)
  801fde:	e8 3e 02 00 00       	call   802221 <nsipc_socket>
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 05                	js     801fef <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801fea:	e8 ab fe ff ff       	call   801e9a <alloc_sockfd>
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	53                   	push   %ebx
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ffa:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802001:	74 26                	je     802029 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802003:	6a 07                	push   $0x7
  802005:	68 00 70 80 00       	push   $0x807000
  80200a:	53                   	push   %ebx
  80200b:	ff 35 04 50 80 00    	pushl  0x805004
  802011:	e8 f6 07 00 00       	call   80280c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802016:	83 c4 0c             	add    $0xc,%esp
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	e8 7f 07 00 00       	call   8027a3 <ipc_recv>
}
  802024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802027:	c9                   	leave  
  802028:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	6a 02                	push   $0x2
  80202e:	e8 31 08 00 00       	call   802864 <ipc_find_env>
  802033:	a3 04 50 80 00       	mov    %eax,0x805004
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	eb c6                	jmp    802003 <nsipc+0x12>

0080203d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	56                   	push   %esi
  802041:	53                   	push   %ebx
  802042:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80204d:	8b 06                	mov    (%esi),%eax
  80204f:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802054:	b8 01 00 00 00       	mov    $0x1,%eax
  802059:	e8 93 ff ff ff       	call   801ff1 <nsipc>
  80205e:	89 c3                	mov    %eax,%ebx
  802060:	85 c0                	test   %eax,%eax
  802062:	79 09                	jns    80206d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802064:	89 d8                	mov    %ebx,%eax
  802066:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	ff 35 10 70 80 00    	pushl  0x807010
  802076:	68 00 70 80 00       	push   $0x807000
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	e8 01 eb ff ff       	call   800b84 <memmove>
		*addrlen = ret->ret_addrlen;
  802083:	a1 10 70 80 00       	mov    0x807010,%eax
  802088:	89 06                	mov    %eax,(%esi)
  80208a:	83 c4 10             	add    $0x10,%esp
	return r;
  80208d:	eb d5                	jmp    802064 <nsipc_accept+0x27>

0080208f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	53                   	push   %ebx
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a1:	53                   	push   %ebx
  8020a2:	ff 75 0c             	pushl  0xc(%ebp)
  8020a5:	68 04 70 80 00       	push   $0x807004
  8020aa:	e8 d5 ea ff ff       	call   800b84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020af:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8020ba:	e8 32 ff ff ff       	call   801ff1 <nsipc>
}
  8020bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020da:	b8 03 00 00 00       	mov    $0x3,%eax
  8020df:	e8 0d ff ff ff       	call   801ff1 <nsipc>
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8020f9:	e8 f3 fe ff ff       	call   801ff1 <nsipc>
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	53                   	push   %ebx
  802104:	83 ec 08             	sub    $0x8,%esp
  802107:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802112:	53                   	push   %ebx
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	68 04 70 80 00       	push   $0x807004
  80211b:	e8 64 ea ff ff       	call   800b84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802120:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802126:	b8 05 00 00 00       	mov    $0x5,%eax
  80212b:	e8 c1 fe ff ff       	call   801ff1 <nsipc>
}
  802130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802143:	8b 45 0c             	mov    0xc(%ebp),%eax
  802146:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80214b:	b8 06 00 00 00       	mov    $0x6,%eax
  802150:	e8 9c fe ff ff       	call   801ff1 <nsipc>
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	56                   	push   %esi
  80215b:	53                   	push   %ebx
  80215c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802167:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80216d:	8b 45 14             	mov    0x14(%ebp),%eax
  802170:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802175:	b8 07 00 00 00       	mov    $0x7,%eax
  80217a:	e8 72 fe ff ff       	call   801ff1 <nsipc>
  80217f:	89 c3                	mov    %eax,%ebx
  802181:	85 c0                	test   %eax,%eax
  802183:	78 1f                	js     8021a4 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802185:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80218a:	7f 21                	jg     8021ad <nsipc_recv+0x56>
  80218c:	39 c6                	cmp    %eax,%esi
  80218e:	7c 1d                	jl     8021ad <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	50                   	push   %eax
  802194:	68 00 70 80 00       	push   $0x807000
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	e8 e3 e9 ff ff       	call   800b84 <memmove>
  8021a1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5d                   	pop    %ebp
  8021ac:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021ad:	68 57 31 80 00       	push   $0x803157
  8021b2:	68 1f 31 80 00       	push   $0x80311f
  8021b7:	6a 62                	push   $0x62
  8021b9:	68 6c 31 80 00       	push   $0x80316c
  8021be:	e8 de df ff ff       	call   8001a1 <_panic>

008021c3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	53                   	push   %ebx
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021d5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021db:	7f 2e                	jg     80220b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	53                   	push   %ebx
  8021e1:	ff 75 0c             	pushl  0xc(%ebp)
  8021e4:	68 0c 70 80 00       	push   $0x80700c
  8021e9:	e8 96 e9 ff ff       	call   800b84 <memmove>
	nsipcbuf.send.req_size = size;
  8021ee:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021fc:	b8 08 00 00 00       	mov    $0x8,%eax
  802201:	e8 eb fd ff ff       	call   801ff1 <nsipc>
}
  802206:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802209:	c9                   	leave  
  80220a:	c3                   	ret    
	assert(size < 1600);
  80220b:	68 78 31 80 00       	push   $0x803178
  802210:	68 1f 31 80 00       	push   $0x80311f
  802215:	6a 6d                	push   $0x6d
  802217:	68 6c 31 80 00       	push   $0x80316c
  80221c:	e8 80 df ff ff       	call   8001a1 <_panic>

00802221 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80222f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802232:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802237:	8b 45 10             	mov    0x10(%ebp),%eax
  80223a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80223f:	b8 09 00 00 00       	mov    $0x9,%eax
  802244:	e8 a8 fd ff ff       	call   801ff1 <nsipc>
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	56                   	push   %esi
  80224f:	53                   	push   %ebx
  802250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	e8 6a f3 ff ff       	call   8015c8 <fd2data>
  80225e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802260:	83 c4 08             	add    $0x8,%esp
  802263:	68 84 31 80 00       	push   $0x803184
  802268:	53                   	push   %ebx
  802269:	e8 88 e7 ff ff       	call   8009f6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80226e:	8b 46 04             	mov    0x4(%esi),%eax
  802271:	2b 06                	sub    (%esi),%eax
  802273:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802279:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802280:	00 00 00 
	stat->st_dev = &devpipe;
  802283:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80228a:	40 80 00 
	return 0;
}
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
  802292:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802295:	5b                   	pop    %ebx
  802296:	5e                   	pop    %esi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    

00802299 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	53                   	push   %ebx
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022a3:	53                   	push   %ebx
  8022a4:	6a 00                	push   $0x0
  8022a6:	e8 c2 eb ff ff       	call   800e6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022ab:	89 1c 24             	mov    %ebx,(%esp)
  8022ae:	e8 15 f3 ff ff       	call   8015c8 <fd2data>
  8022b3:	83 c4 08             	add    $0x8,%esp
  8022b6:	50                   	push   %eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	e8 af eb ff ff       	call   800e6d <sys_page_unmap>
}
  8022be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <_pipeisclosed>:
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	57                   	push   %edi
  8022c7:	56                   	push   %esi
  8022c8:	53                   	push   %ebx
  8022c9:	83 ec 1c             	sub    $0x1c,%esp
  8022cc:	89 c7                	mov    %eax,%edi
  8022ce:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022d0:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8022d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	57                   	push   %edi
  8022dc:	e8 be 05 00 00       	call   80289f <pageref>
  8022e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022e4:	89 34 24             	mov    %esi,(%esp)
  8022e7:	e8 b3 05 00 00       	call   80289f <pageref>
		nn = thisenv->env_runs;
  8022ec:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8022f2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022f5:	83 c4 10             	add    $0x10,%esp
  8022f8:	39 cb                	cmp    %ecx,%ebx
  8022fa:	74 1b                	je     802317 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022fc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022ff:	75 cf                	jne    8022d0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802301:	8b 42 58             	mov    0x58(%edx),%eax
  802304:	6a 01                	push   $0x1
  802306:	50                   	push   %eax
  802307:	53                   	push   %ebx
  802308:	68 8b 31 80 00       	push   $0x80318b
  80230d:	e8 85 df ff ff       	call   800297 <cprintf>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	eb b9                	jmp    8022d0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802317:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80231a:	0f 94 c0             	sete   %al
  80231d:	0f b6 c0             	movzbl %al,%eax
}
  802320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5f                   	pop    %edi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    

00802328 <devpipe_write>:
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	57                   	push   %edi
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 28             	sub    $0x28,%esp
  802331:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802334:	56                   	push   %esi
  802335:	e8 8e f2 ff ff       	call   8015c8 <fd2data>
  80233a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80233c:	83 c4 10             	add    $0x10,%esp
  80233f:	bf 00 00 00 00       	mov    $0x0,%edi
  802344:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802347:	74 4f                	je     802398 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802349:	8b 43 04             	mov    0x4(%ebx),%eax
  80234c:	8b 0b                	mov    (%ebx),%ecx
  80234e:	8d 51 20             	lea    0x20(%ecx),%edx
  802351:	39 d0                	cmp    %edx,%eax
  802353:	72 14                	jb     802369 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802355:	89 da                	mov    %ebx,%edx
  802357:	89 f0                	mov    %esi,%eax
  802359:	e8 65 ff ff ff       	call   8022c3 <_pipeisclosed>
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 3b                	jne    80239d <devpipe_write+0x75>
			sys_yield();
  802362:	e8 62 ea ff ff       	call   800dc9 <sys_yield>
  802367:	eb e0                	jmp    802349 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80236c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802370:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802373:	89 c2                	mov    %eax,%edx
  802375:	c1 fa 1f             	sar    $0x1f,%edx
  802378:	89 d1                	mov    %edx,%ecx
  80237a:	c1 e9 1b             	shr    $0x1b,%ecx
  80237d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802380:	83 e2 1f             	and    $0x1f,%edx
  802383:	29 ca                	sub    %ecx,%edx
  802385:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802389:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80238d:	83 c0 01             	add    $0x1,%eax
  802390:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802393:	83 c7 01             	add    $0x1,%edi
  802396:	eb ac                	jmp    802344 <devpipe_write+0x1c>
	return i;
  802398:	8b 45 10             	mov    0x10(%ebp),%eax
  80239b:	eb 05                	jmp    8023a2 <devpipe_write+0x7a>
				return 0;
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a5:	5b                   	pop    %ebx
  8023a6:	5e                   	pop    %esi
  8023a7:	5f                   	pop    %edi
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    

008023aa <devpipe_read>:
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	57                   	push   %edi
  8023ae:	56                   	push   %esi
  8023af:	53                   	push   %ebx
  8023b0:	83 ec 18             	sub    $0x18,%esp
  8023b3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023b6:	57                   	push   %edi
  8023b7:	e8 0c f2 ff ff       	call   8015c8 <fd2data>
  8023bc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023be:	83 c4 10             	add    $0x10,%esp
  8023c1:	be 00 00 00 00       	mov    $0x0,%esi
  8023c6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c9:	75 14                	jne    8023df <devpipe_read+0x35>
	return i;
  8023cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ce:	eb 02                	jmp    8023d2 <devpipe_read+0x28>
				return i;
  8023d0:	89 f0                	mov    %esi,%eax
}
  8023d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
			sys_yield();
  8023da:	e8 ea e9 ff ff       	call   800dc9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023df:	8b 03                	mov    (%ebx),%eax
  8023e1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023e4:	75 18                	jne    8023fe <devpipe_read+0x54>
			if (i > 0)
  8023e6:	85 f6                	test   %esi,%esi
  8023e8:	75 e6                	jne    8023d0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8023ea:	89 da                	mov    %ebx,%edx
  8023ec:	89 f8                	mov    %edi,%eax
  8023ee:	e8 d0 fe ff ff       	call   8022c3 <_pipeisclosed>
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	74 e3                	je     8023da <devpipe_read+0x30>
				return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	eb d4                	jmp    8023d2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023fe:	99                   	cltd   
  8023ff:	c1 ea 1b             	shr    $0x1b,%edx
  802402:	01 d0                	add    %edx,%eax
  802404:	83 e0 1f             	and    $0x1f,%eax
  802407:	29 d0                	sub    %edx,%eax
  802409:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80240e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802411:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802414:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802417:	83 c6 01             	add    $0x1,%esi
  80241a:	eb aa                	jmp    8023c6 <devpipe_read+0x1c>

0080241c <pipe>:
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	56                   	push   %esi
  802420:	53                   	push   %ebx
  802421:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802424:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802427:	50                   	push   %eax
  802428:	e8 b2 f1 ff ff       	call   8015df <fd_alloc>
  80242d:	89 c3                	mov    %eax,%ebx
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 88 23 01 00 00    	js     80255d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	68 07 04 00 00       	push   $0x407
  802442:	ff 75 f4             	pushl  -0xc(%ebp)
  802445:	6a 00                	push   $0x0
  802447:	e8 9c e9 ff ff       	call   800de8 <sys_page_alloc>
  80244c:	89 c3                	mov    %eax,%ebx
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 88 04 01 00 00    	js     80255d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802459:	83 ec 0c             	sub    $0xc,%esp
  80245c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80245f:	50                   	push   %eax
  802460:	e8 7a f1 ff ff       	call   8015df <fd_alloc>
  802465:	89 c3                	mov    %eax,%ebx
  802467:	83 c4 10             	add    $0x10,%esp
  80246a:	85 c0                	test   %eax,%eax
  80246c:	0f 88 db 00 00 00    	js     80254d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 07 04 00 00       	push   $0x407
  80247a:	ff 75 f0             	pushl  -0x10(%ebp)
  80247d:	6a 00                	push   $0x0
  80247f:	e8 64 e9 ff ff       	call   800de8 <sys_page_alloc>
  802484:	89 c3                	mov    %eax,%ebx
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	85 c0                	test   %eax,%eax
  80248b:	0f 88 bc 00 00 00    	js     80254d <pipe+0x131>
	va = fd2data(fd0);
  802491:	83 ec 0c             	sub    $0xc,%esp
  802494:	ff 75 f4             	pushl  -0xc(%ebp)
  802497:	e8 2c f1 ff ff       	call   8015c8 <fd2data>
  80249c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80249e:	83 c4 0c             	add    $0xc,%esp
  8024a1:	68 07 04 00 00       	push   $0x407
  8024a6:	50                   	push   %eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	e8 3a e9 ff ff       	call   800de8 <sys_page_alloc>
  8024ae:	89 c3                	mov    %eax,%ebx
  8024b0:	83 c4 10             	add    $0x10,%esp
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	0f 88 82 00 00 00    	js     80253d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c1:	e8 02 f1 ff ff       	call   8015c8 <fd2data>
  8024c6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024cd:	50                   	push   %eax
  8024ce:	6a 00                	push   $0x0
  8024d0:	56                   	push   %esi
  8024d1:	6a 00                	push   $0x0
  8024d3:	e8 53 e9 ff ff       	call   800e2b <sys_page_map>
  8024d8:	89 c3                	mov    %eax,%ebx
  8024da:	83 c4 20             	add    $0x20,%esp
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	78 4e                	js     80252f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8024e1:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	ff 75 f4             	pushl  -0xc(%ebp)
  80250a:	e8 a9 f0 ff ff       	call   8015b8 <fd2num>
  80250f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802512:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802514:	83 c4 04             	add    $0x4,%esp
  802517:	ff 75 f0             	pushl  -0x10(%ebp)
  80251a:	e8 99 f0 ff ff       	call   8015b8 <fd2num>
  80251f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802522:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	bb 00 00 00 00       	mov    $0x0,%ebx
  80252d:	eb 2e                	jmp    80255d <pipe+0x141>
	sys_page_unmap(0, va);
  80252f:	83 ec 08             	sub    $0x8,%esp
  802532:	56                   	push   %esi
  802533:	6a 00                	push   $0x0
  802535:	e8 33 e9 ff ff       	call   800e6d <sys_page_unmap>
  80253a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80253d:	83 ec 08             	sub    $0x8,%esp
  802540:	ff 75 f0             	pushl  -0x10(%ebp)
  802543:	6a 00                	push   $0x0
  802545:	e8 23 e9 ff ff       	call   800e6d <sys_page_unmap>
  80254a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80254d:	83 ec 08             	sub    $0x8,%esp
  802550:	ff 75 f4             	pushl  -0xc(%ebp)
  802553:	6a 00                	push   $0x0
  802555:	e8 13 e9 ff ff       	call   800e6d <sys_page_unmap>
  80255a:	83 c4 10             	add    $0x10,%esp
}
  80255d:	89 d8                	mov    %ebx,%eax
  80255f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    

00802566 <pipeisclosed>:
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80256c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256f:	50                   	push   %eax
  802570:	ff 75 08             	pushl  0x8(%ebp)
  802573:	e8 b9 f0 ff ff       	call   801631 <fd_lookup>
  802578:	83 c4 10             	add    $0x10,%esp
  80257b:	85 c0                	test   %eax,%eax
  80257d:	78 18                	js     802597 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	ff 75 f4             	pushl  -0xc(%ebp)
  802585:	e8 3e f0 ff ff       	call   8015c8 <fd2data>
	return _pipeisclosed(fd, p);
  80258a:	89 c2                	mov    %eax,%edx
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	e8 2f fd ff ff       	call   8022c3 <_pipeisclosed>
  802594:	83 c4 10             	add    $0x10,%esp
}
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
  80259e:	c3                   	ret    

0080259f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025a5:	68 a3 31 80 00       	push   $0x8031a3
  8025aa:	ff 75 0c             	pushl  0xc(%ebp)
  8025ad:	e8 44 e4 ff ff       	call   8009f6 <strcpy>
	return 0;
}
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <devcons_write>:
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	57                   	push   %edi
  8025bd:	56                   	push   %esi
  8025be:	53                   	push   %ebx
  8025bf:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025c5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025ca:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025d3:	73 31                	jae    802606 <devcons_write+0x4d>
		m = n - tot;
  8025d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025d8:	29 f3                	sub    %esi,%ebx
  8025da:	83 fb 7f             	cmp    $0x7f,%ebx
  8025dd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025e2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	53                   	push   %ebx
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	03 45 0c             	add    0xc(%ebp),%eax
  8025ee:	50                   	push   %eax
  8025ef:	57                   	push   %edi
  8025f0:	e8 8f e5 ff ff       	call   800b84 <memmove>
		sys_cputs(buf, m);
  8025f5:	83 c4 08             	add    $0x8,%esp
  8025f8:	53                   	push   %ebx
  8025f9:	57                   	push   %edi
  8025fa:	e8 2d e7 ff ff       	call   800d2c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8025ff:	01 de                	add    %ebx,%esi
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	eb ca                	jmp    8025d0 <devcons_write+0x17>
}
  802606:	89 f0                	mov    %esi,%eax
  802608:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    

00802610 <devcons_read>:
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 08             	sub    $0x8,%esp
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80261b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261f:	74 21                	je     802642 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802621:	e8 24 e7 ff ff       	call   800d4a <sys_cgetc>
  802626:	85 c0                	test   %eax,%eax
  802628:	75 07                	jne    802631 <devcons_read+0x21>
		sys_yield();
  80262a:	e8 9a e7 ff ff       	call   800dc9 <sys_yield>
  80262f:	eb f0                	jmp    802621 <devcons_read+0x11>
	if (c < 0)
  802631:	78 0f                	js     802642 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802633:	83 f8 04             	cmp    $0x4,%eax
  802636:	74 0c                	je     802644 <devcons_read+0x34>
	*(char*)vbuf = c;
  802638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80263b:	88 02                	mov    %al,(%edx)
	return 1;
  80263d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    
		return 0;
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	eb f7                	jmp    802642 <devcons_read+0x32>

0080264b <cputchar>:
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802657:	6a 01                	push   $0x1
  802659:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80265c:	50                   	push   %eax
  80265d:	e8 ca e6 ff ff       	call   800d2c <sys_cputs>
}
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <getchar>:
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80266d:	6a 01                	push   $0x1
  80266f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802672:	50                   	push   %eax
  802673:	6a 00                	push   $0x0
  802675:	e8 27 f2 ff ff       	call   8018a1 <read>
	if (r < 0)
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	85 c0                	test   %eax,%eax
  80267f:	78 06                	js     802687 <getchar+0x20>
	if (r < 1)
  802681:	74 06                	je     802689 <getchar+0x22>
	return c;
  802683:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    
		return -E_EOF;
  802689:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80268e:	eb f7                	jmp    802687 <getchar+0x20>

00802690 <iscons>:
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802699:	50                   	push   %eax
  80269a:	ff 75 08             	pushl  0x8(%ebp)
  80269d:	e8 8f ef ff ff       	call   801631 <fd_lookup>
  8026a2:	83 c4 10             	add    $0x10,%esp
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	78 11                	js     8026ba <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026b2:	39 10                	cmp    %edx,(%eax)
  8026b4:	0f 94 c0             	sete   %al
  8026b7:	0f b6 c0             	movzbl %al,%eax
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <opencons>:
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c5:	50                   	push   %eax
  8026c6:	e8 14 ef ff ff       	call   8015df <fd_alloc>
  8026cb:	83 c4 10             	add    $0x10,%esp
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	78 3a                	js     80270c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 07 04 00 00       	push   $0x407
  8026da:	ff 75 f4             	pushl  -0xc(%ebp)
  8026dd:	6a 00                	push   $0x0
  8026df:	e8 04 e7 ff ff       	call   800de8 <sys_page_alloc>
  8026e4:	83 c4 10             	add    $0x10,%esp
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	78 21                	js     80270c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026f4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	50                   	push   %eax
  802704:	e8 af ee ff ff       	call   8015b8 <fd2num>
  802709:	83 c4 10             	add    $0x10,%esp
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802714:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80271b:	74 0a                	je     802727 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	6a 07                	push   $0x7
  80272c:	68 00 f0 bf ee       	push   $0xeebff000
  802731:	6a 00                	push   $0x0
  802733:	e8 b0 e6 ff ff       	call   800de8 <sys_page_alloc>
		if(r < 0)
  802738:	83 c4 10             	add    $0x10,%esp
  80273b:	85 c0                	test   %eax,%eax
  80273d:	78 2a                	js     802769 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80273f:	83 ec 08             	sub    $0x8,%esp
  802742:	68 7d 27 80 00       	push   $0x80277d
  802747:	6a 00                	push   $0x0
  802749:	e8 e5 e7 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80274e:	83 c4 10             	add    $0x10,%esp
  802751:	85 c0                	test   %eax,%eax
  802753:	79 c8                	jns    80271d <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 e0 31 80 00       	push   $0x8031e0
  80275d:	6a 25                	push   $0x25
  80275f:	68 1c 32 80 00       	push   $0x80321c
  802764:	e8 38 da ff ff       	call   8001a1 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	68 b0 31 80 00       	push   $0x8031b0
  802771:	6a 22                	push   $0x22
  802773:	68 1c 32 80 00       	push   $0x80321c
  802778:	e8 24 da ff ff       	call   8001a1 <_panic>

0080277d <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80277d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80277e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802783:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802785:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802788:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80278c:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802790:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802793:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802795:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802799:	83 c4 08             	add    $0x8,%esp
	popal
  80279c:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80279d:	83 c4 04             	add    $0x4,%esp
	popfl
  8027a0:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027a1:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027a2:	c3                   	ret    

008027a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027a3:	55                   	push   %ebp
  8027a4:	89 e5                	mov    %esp,%ebp
  8027a6:	56                   	push   %esi
  8027a7:	53                   	push   %ebx
  8027a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8027b1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027b3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027b8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027bb:	83 ec 0c             	sub    $0xc,%esp
  8027be:	50                   	push   %eax
  8027bf:	e8 d4 e7 ff ff       	call   800f98 <sys_ipc_recv>
	if(ret < 0){
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	78 2b                	js     8027f6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8027cb:	85 f6                	test   %esi,%esi
  8027cd:	74 0a                	je     8027d9 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8027cf:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027d4:	8b 40 74             	mov    0x74(%eax),%eax
  8027d7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8027d9:	85 db                	test   %ebx,%ebx
  8027db:	74 0a                	je     8027e7 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8027dd:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027e2:	8b 40 78             	mov    0x78(%eax),%eax
  8027e5:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8027e7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027ec:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027f2:	5b                   	pop    %ebx
  8027f3:	5e                   	pop    %esi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
		if(from_env_store)
  8027f6:	85 f6                	test   %esi,%esi
  8027f8:	74 06                	je     802800 <ipc_recv+0x5d>
			*from_env_store = 0;
  8027fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802800:	85 db                	test   %ebx,%ebx
  802802:	74 eb                	je     8027ef <ipc_recv+0x4c>
			*perm_store = 0;
  802804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80280a:	eb e3                	jmp    8027ef <ipc_recv+0x4c>

0080280c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	57                   	push   %edi
  802810:	56                   	push   %esi
  802811:	53                   	push   %ebx
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	8b 7d 08             	mov    0x8(%ebp),%edi
  802818:	8b 75 0c             	mov    0xc(%ebp),%esi
  80281b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80281e:	85 db                	test   %ebx,%ebx
  802820:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802825:	0f 44 d8             	cmove  %eax,%ebx
  802828:	eb 05                	jmp    80282f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80282a:	e8 9a e5 ff ff       	call   800dc9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80282f:	ff 75 14             	pushl  0x14(%ebp)
  802832:	53                   	push   %ebx
  802833:	56                   	push   %esi
  802834:	57                   	push   %edi
  802835:	e8 3b e7 ff ff       	call   800f75 <sys_ipc_try_send>
  80283a:	83 c4 10             	add    $0x10,%esp
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 1b                	je     80285c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802841:	79 e7                	jns    80282a <ipc_send+0x1e>
  802843:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802846:	74 e2                	je     80282a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802848:	83 ec 04             	sub    $0x4,%esp
  80284b:	68 2a 32 80 00       	push   $0x80322a
  802850:	6a 48                	push   $0x48
  802852:	68 3f 32 80 00       	push   $0x80323f
  802857:	e8 45 d9 ff ff       	call   8001a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80285c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    

00802864 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80286a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80286f:	89 c2                	mov    %eax,%edx
  802871:	c1 e2 07             	shl    $0x7,%edx
  802874:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80287a:	8b 52 50             	mov    0x50(%edx),%edx
  80287d:	39 ca                	cmp    %ecx,%edx
  80287f:	74 11                	je     802892 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802881:	83 c0 01             	add    $0x1,%eax
  802884:	3d 00 04 00 00       	cmp    $0x400,%eax
  802889:	75 e4                	jne    80286f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
  802890:	eb 0b                	jmp    80289d <ipc_find_env+0x39>
			return envs[i].env_id;
  802892:	c1 e0 07             	shl    $0x7,%eax
  802895:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80289a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    

0080289f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a5:	89 d0                	mov    %edx,%eax
  8028a7:	c1 e8 16             	shr    $0x16,%eax
  8028aa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b6:	f6 c1 01             	test   $0x1,%cl
  8028b9:	74 1d                	je     8028d8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028bb:	c1 ea 0c             	shr    $0xc,%edx
  8028be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c5:	f6 c2 01             	test   $0x1,%dl
  8028c8:	74 0e                	je     8028d8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028ca:	c1 ea 0c             	shr    $0xc,%edx
  8028cd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d4:	ef 
  8028d5:	0f b7 c0             	movzwl %ax,%eax
}
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	53                   	push   %ebx
  8028e4:	83 ec 1c             	sub    $0x1c,%esp
  8028e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8028f7:	85 d2                	test   %edx,%edx
  8028f9:	75 4d                	jne    802948 <__udivdi3+0x68>
  8028fb:	39 f3                	cmp    %esi,%ebx
  8028fd:	76 19                	jbe    802918 <__udivdi3+0x38>
  8028ff:	31 ff                	xor    %edi,%edi
  802901:	89 e8                	mov    %ebp,%eax
  802903:	89 f2                	mov    %esi,%edx
  802905:	f7 f3                	div    %ebx
  802907:	89 fa                	mov    %edi,%edx
  802909:	83 c4 1c             	add    $0x1c,%esp
  80290c:	5b                   	pop    %ebx
  80290d:	5e                   	pop    %esi
  80290e:	5f                   	pop    %edi
  80290f:	5d                   	pop    %ebp
  802910:	c3                   	ret    
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	89 d9                	mov    %ebx,%ecx
  80291a:	85 db                	test   %ebx,%ebx
  80291c:	75 0b                	jne    802929 <__udivdi3+0x49>
  80291e:	b8 01 00 00 00       	mov    $0x1,%eax
  802923:	31 d2                	xor    %edx,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 c1                	mov    %eax,%ecx
  802929:	31 d2                	xor    %edx,%edx
  80292b:	89 f0                	mov    %esi,%eax
  80292d:	f7 f1                	div    %ecx
  80292f:	89 c6                	mov    %eax,%esi
  802931:	89 e8                	mov    %ebp,%eax
  802933:	89 f7                	mov    %esi,%edi
  802935:	f7 f1                	div    %ecx
  802937:	89 fa                	mov    %edi,%edx
  802939:	83 c4 1c             	add    $0x1c,%esp
  80293c:	5b                   	pop    %ebx
  80293d:	5e                   	pop    %esi
  80293e:	5f                   	pop    %edi
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
  802941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802948:	39 f2                	cmp    %esi,%edx
  80294a:	77 1c                	ja     802968 <__udivdi3+0x88>
  80294c:	0f bd fa             	bsr    %edx,%edi
  80294f:	83 f7 1f             	xor    $0x1f,%edi
  802952:	75 2c                	jne    802980 <__udivdi3+0xa0>
  802954:	39 f2                	cmp    %esi,%edx
  802956:	72 06                	jb     80295e <__udivdi3+0x7e>
  802958:	31 c0                	xor    %eax,%eax
  80295a:	39 eb                	cmp    %ebp,%ebx
  80295c:	77 a9                	ja     802907 <__udivdi3+0x27>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	eb a2                	jmp    802907 <__udivdi3+0x27>
  802965:	8d 76 00             	lea    0x0(%esi),%esi
  802968:	31 ff                	xor    %edi,%edi
  80296a:	31 c0                	xor    %eax,%eax
  80296c:	89 fa                	mov    %edi,%edx
  80296e:	83 c4 1c             	add    $0x1c,%esp
  802971:	5b                   	pop    %ebx
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	89 f9                	mov    %edi,%ecx
  802982:	b8 20 00 00 00       	mov    $0x20,%eax
  802987:	29 f8                	sub    %edi,%eax
  802989:	d3 e2                	shl    %cl,%edx
  80298b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80298f:	89 c1                	mov    %eax,%ecx
  802991:	89 da                	mov    %ebx,%edx
  802993:	d3 ea                	shr    %cl,%edx
  802995:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802999:	09 d1                	or     %edx,%ecx
  80299b:	89 f2                	mov    %esi,%edx
  80299d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029a1:	89 f9                	mov    %edi,%ecx
  8029a3:	d3 e3                	shl    %cl,%ebx
  8029a5:	89 c1                	mov    %eax,%ecx
  8029a7:	d3 ea                	shr    %cl,%edx
  8029a9:	89 f9                	mov    %edi,%ecx
  8029ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029af:	89 eb                	mov    %ebp,%ebx
  8029b1:	d3 e6                	shl    %cl,%esi
  8029b3:	89 c1                	mov    %eax,%ecx
  8029b5:	d3 eb                	shr    %cl,%ebx
  8029b7:	09 de                	or     %ebx,%esi
  8029b9:	89 f0                	mov    %esi,%eax
  8029bb:	f7 74 24 08          	divl   0x8(%esp)
  8029bf:	89 d6                	mov    %edx,%esi
  8029c1:	89 c3                	mov    %eax,%ebx
  8029c3:	f7 64 24 0c          	mull   0xc(%esp)
  8029c7:	39 d6                	cmp    %edx,%esi
  8029c9:	72 15                	jb     8029e0 <__udivdi3+0x100>
  8029cb:	89 f9                	mov    %edi,%ecx
  8029cd:	d3 e5                	shl    %cl,%ebp
  8029cf:	39 c5                	cmp    %eax,%ebp
  8029d1:	73 04                	jae    8029d7 <__udivdi3+0xf7>
  8029d3:	39 d6                	cmp    %edx,%esi
  8029d5:	74 09                	je     8029e0 <__udivdi3+0x100>
  8029d7:	89 d8                	mov    %ebx,%eax
  8029d9:	31 ff                	xor    %edi,%edi
  8029db:	e9 27 ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029e3:	31 ff                	xor    %edi,%edi
  8029e5:	e9 1d ff ff ff       	jmp    802907 <__udivdi3+0x27>
  8029ea:	66 90                	xchg   %ax,%ax
  8029ec:	66 90                	xchg   %ax,%ax
  8029ee:	66 90                	xchg   %ax,%ax

008029f0 <__umoddi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	57                   	push   %edi
  8029f2:	56                   	push   %esi
  8029f3:	53                   	push   %ebx
  8029f4:	83 ec 1c             	sub    $0x1c,%esp
  8029f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a07:	89 da                	mov    %ebx,%edx
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	75 43                	jne    802a50 <__umoddi3+0x60>
  802a0d:	39 df                	cmp    %ebx,%edi
  802a0f:	76 17                	jbe    802a28 <__umoddi3+0x38>
  802a11:	89 f0                	mov    %esi,%eax
  802a13:	f7 f7                	div    %edi
  802a15:	89 d0                	mov    %edx,%eax
  802a17:	31 d2                	xor    %edx,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	89 fd                	mov    %edi,%ebp
  802a2a:	85 ff                	test   %edi,%edi
  802a2c:	75 0b                	jne    802a39 <__umoddi3+0x49>
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	31 d2                	xor    %edx,%edx
  802a35:	f7 f7                	div    %edi
  802a37:	89 c5                	mov    %eax,%ebp
  802a39:	89 d8                	mov    %ebx,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	f7 f5                	div    %ebp
  802a3f:	89 f0                	mov    %esi,%eax
  802a41:	f7 f5                	div    %ebp
  802a43:	89 d0                	mov    %edx,%eax
  802a45:	eb d0                	jmp    802a17 <__umoddi3+0x27>
  802a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a4e:	66 90                	xchg   %ax,%ax
  802a50:	89 f1                	mov    %esi,%ecx
  802a52:	39 d8                	cmp    %ebx,%eax
  802a54:	76 0a                	jbe    802a60 <__umoddi3+0x70>
  802a56:	89 f0                	mov    %esi,%eax
  802a58:	83 c4 1c             	add    $0x1c,%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	0f bd e8             	bsr    %eax,%ebp
  802a63:	83 f5 1f             	xor    $0x1f,%ebp
  802a66:	75 20                	jne    802a88 <__umoddi3+0x98>
  802a68:	39 d8                	cmp    %ebx,%eax
  802a6a:	0f 82 b0 00 00 00    	jb     802b20 <__umoddi3+0x130>
  802a70:	39 f7                	cmp    %esi,%edi
  802a72:	0f 86 a8 00 00 00    	jbe    802b20 <__umoddi3+0x130>
  802a78:	89 c8                	mov    %ecx,%eax
  802a7a:	83 c4 1c             	add    $0x1c,%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    
  802a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a8f:	29 ea                	sub    %ebp,%edx
  802a91:	d3 e0                	shl    %cl,%eax
  802a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a97:	89 d1                	mov    %edx,%ecx
  802a99:	89 f8                	mov    %edi,%eax
  802a9b:	d3 e8                	shr    %cl,%eax
  802a9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aa5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aa9:	09 c1                	or     %eax,%ecx
  802aab:	89 d8                	mov    %ebx,%eax
  802aad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab1:	89 e9                	mov    %ebp,%ecx
  802ab3:	d3 e7                	shl    %cl,%edi
  802ab5:	89 d1                	mov    %edx,%ecx
  802ab7:	d3 e8                	shr    %cl,%eax
  802ab9:	89 e9                	mov    %ebp,%ecx
  802abb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802abf:	d3 e3                	shl    %cl,%ebx
  802ac1:	89 c7                	mov    %eax,%edi
  802ac3:	89 d1                	mov    %edx,%ecx
  802ac5:	89 f0                	mov    %esi,%eax
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 fa                	mov    %edi,%edx
  802acd:	d3 e6                	shl    %cl,%esi
  802acf:	09 d8                	or     %ebx,%eax
  802ad1:	f7 74 24 08          	divl   0x8(%esp)
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	89 f3                	mov    %esi,%ebx
  802ad9:	f7 64 24 0c          	mull   0xc(%esp)
  802add:	89 c6                	mov    %eax,%esi
  802adf:	89 d7                	mov    %edx,%edi
  802ae1:	39 d1                	cmp    %edx,%ecx
  802ae3:	72 06                	jb     802aeb <__umoddi3+0xfb>
  802ae5:	75 10                	jne    802af7 <__umoddi3+0x107>
  802ae7:	39 c3                	cmp    %eax,%ebx
  802ae9:	73 0c                	jae    802af7 <__umoddi3+0x107>
  802aeb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802af3:	89 d7                	mov    %edx,%edi
  802af5:	89 c6                	mov    %eax,%esi
  802af7:	89 ca                	mov    %ecx,%edx
  802af9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802afe:	29 f3                	sub    %esi,%ebx
  802b00:	19 fa                	sbb    %edi,%edx
  802b02:	89 d0                	mov    %edx,%eax
  802b04:	d3 e0                	shl    %cl,%eax
  802b06:	89 e9                	mov    %ebp,%ecx
  802b08:	d3 eb                	shr    %cl,%ebx
  802b0a:	d3 ea                	shr    %cl,%edx
  802b0c:	09 d8                	or     %ebx,%eax
  802b0e:	83 c4 1c             	add    $0x1c,%esp
  802b11:	5b                   	pop    %ebx
  802b12:	5e                   	pop    %esi
  802b13:	5f                   	pop    %edi
  802b14:	5d                   	pop    %ebp
  802b15:	c3                   	ret    
  802b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b1d:	8d 76 00             	lea    0x0(%esi),%esi
  802b20:	89 da                	mov    %ebx,%edx
  802b22:	29 fe                	sub    %edi,%esi
  802b24:	19 c2                	sbb    %eax,%edx
  802b26:	89 f1                	mov    %esi,%ecx
  802b28:	89 c8                	mov    %ecx,%eax
  802b2a:	e9 4b ff ff ff       	jmp    802a7a <__umoddi3+0x8a>
