
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
  800038:	e8 be 0d 00 00       	call   800dfb <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 1a 13 00 00       	call   801363 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 c0 0d 00 00       	call   800e1a <sys_yield>
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
  80007d:	e8 98 0d 00 00       	call   800e1a <sys_yield>
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
  8000ba:	68 bb 2b 80 00       	push   $0x802bbb
  8000bf:	e8 24 02 00 00       	call   8002e8 <cprintf>
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
  8000d4:	68 80 2b 80 00       	push   $0x802b80
  8000d9:	6a 21                	push   $0x21
  8000db:	68 a8 2b 80 00       	push   $0x802ba8
  8000e0:	e8 0d 01 00 00       	call   8001f2 <_panic>

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
  8000f8:	e8 fe 0c 00 00       	call   800dfb <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800161:	8b 40 48             	mov    0x48(%eax),%eax
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	50                   	push   %eax
  800168:	68 d9 2b 80 00       	push   $0x802bd9
  80016d:	e8 76 01 00 00       	call   8002e8 <cprintf>
	cprintf("before umain\n");
  800172:	c7 04 24 f7 2b 80 00 	movl   $0x802bf7,(%esp)
  800179:	e8 6a 01 00 00       	call   8002e8 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	e8 a7 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018c:	c7 04 24 05 2c 80 00 	movl   $0x802c05,(%esp)
  800193:	e8 50 01 00 00       	call   8002e8 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800198:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80019d:	8b 40 48             	mov    0x48(%eax),%eax
  8001a0:	83 c4 08             	add    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 12 2c 80 00       	push   $0x802c12
  8001a9:	e8 3a 01 00 00       	call   8002e8 <cprintf>
	// exit gracefully
	exit();
  8001ae:	e8 0b 00 00 00       	call   8001be <exit>
}
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b9:	5b                   	pop    %ebx
  8001ba:	5e                   	pop    %esi
  8001bb:	5f                   	pop    %edi
  8001bc:	5d                   	pop    %ebp
  8001bd:	c3                   	ret    

008001be <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	68 3c 2c 80 00       	push   $0x802c3c
  8001d1:	50                   	push   %eax
  8001d2:	68 31 2c 80 00       	push   $0x802c31
  8001d7:	e8 0c 01 00 00       	call   8002e8 <cprintf>
	close_all();
  8001dc:	e8 ec 15 00 00       	call   8017cd <close_all>
	sys_env_destroy(0);
  8001e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e8:	e8 cd 0b 00 00       	call   800dba <sys_env_destroy>
}
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	56                   	push   %esi
  8001f6:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001fc:	8b 40 48             	mov    0x48(%eax),%eax
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 68 2c 80 00       	push   $0x802c68
  800207:	50                   	push   %eax
  800208:	68 31 2c 80 00       	push   $0x802c31
  80020d:	e8 d6 00 00 00       	call   8002e8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800212:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800215:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80021b:	e8 db 0b 00 00       	call   800dfb <sys_getenvid>
  800220:	83 c4 04             	add    $0x4,%esp
  800223:	ff 75 0c             	pushl  0xc(%ebp)
  800226:	ff 75 08             	pushl  0x8(%ebp)
  800229:	56                   	push   %esi
  80022a:	50                   	push   %eax
  80022b:	68 44 2c 80 00       	push   $0x802c44
  800230:	e8 b3 00 00 00       	call   8002e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800235:	83 c4 18             	add    $0x18,%esp
  800238:	53                   	push   %ebx
  800239:	ff 75 10             	pushl  0x10(%ebp)
  80023c:	e8 56 00 00 00       	call   800297 <vcprintf>
	cprintf("\n");
  800241:	c7 04 24 f5 2b 80 00 	movl   $0x802bf5,(%esp)
  800248:	e8 9b 00 00 00       	call   8002e8 <cprintf>
  80024d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800250:	cc                   	int3   
  800251:	eb fd                	jmp    800250 <_panic+0x5e>

00800253 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	53                   	push   %ebx
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025d:	8b 13                	mov    (%ebx),%edx
  80025f:	8d 42 01             	lea    0x1(%edx),%eax
  800262:	89 03                	mov    %eax,(%ebx)
  800264:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800267:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800270:	74 09                	je     80027b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800272:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800279:	c9                   	leave  
  80027a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	68 ff 00 00 00       	push   $0xff
  800283:	8d 43 08             	lea    0x8(%ebx),%eax
  800286:	50                   	push   %eax
  800287:	e8 f1 0a 00 00       	call   800d7d <sys_cputs>
		b->idx = 0;
  80028c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	eb db                	jmp    800272 <putch+0x1f>

00800297 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a7:	00 00 00 
	b.cnt = 0;
  8002aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b4:	ff 75 0c             	pushl  0xc(%ebp)
  8002b7:	ff 75 08             	pushl  0x8(%ebp)
  8002ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c0:	50                   	push   %eax
  8002c1:	68 53 02 80 00       	push   $0x800253
  8002c6:	e8 4a 01 00 00       	call   800415 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002cb:	83 c4 08             	add    $0x8,%esp
  8002ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002da:	50                   	push   %eax
  8002db:	e8 9d 0a 00 00       	call   800d7d <sys_cputs>

	return b.cnt;
}
  8002e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e6:	c9                   	leave  
  8002e7:	c3                   	ret    

008002e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ee:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f1:	50                   	push   %eax
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	e8 9d ff ff ff       	call   800297 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    

008002fc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	57                   	push   %edi
  800300:	56                   	push   %esi
  800301:	53                   	push   %ebx
  800302:	83 ec 1c             	sub    $0x1c,%esp
  800305:	89 c6                	mov    %eax,%esi
  800307:	89 d7                	mov    %edx,%edi
  800309:	8b 45 08             	mov    0x8(%ebp),%eax
  80030c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800312:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80031b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80031f:	74 2c                	je     80034d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800324:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80032b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800331:	39 c2                	cmp    %eax,%edx
  800333:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800336:	73 43                	jae    80037b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800338:	83 eb 01             	sub    $0x1,%ebx
  80033b:	85 db                	test   %ebx,%ebx
  80033d:	7e 6c                	jle    8003ab <printnum+0xaf>
				putch(padc, putdat);
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	57                   	push   %edi
  800343:	ff 75 18             	pushl  0x18(%ebp)
  800346:	ff d6                	call   *%esi
  800348:	83 c4 10             	add    $0x10,%esp
  80034b:	eb eb                	jmp    800338 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	6a 20                	push   $0x20
  800352:	6a 00                	push   $0x0
  800354:	50                   	push   %eax
  800355:	ff 75 e4             	pushl  -0x1c(%ebp)
  800358:	ff 75 e0             	pushl  -0x20(%ebp)
  80035b:	89 fa                	mov    %edi,%edx
  80035d:	89 f0                	mov    %esi,%eax
  80035f:	e8 98 ff ff ff       	call   8002fc <printnum>
		while (--width > 0)
  800364:	83 c4 20             	add    $0x20,%esp
  800367:	83 eb 01             	sub    $0x1,%ebx
  80036a:	85 db                	test   %ebx,%ebx
  80036c:	7e 65                	jle    8003d3 <printnum+0xd7>
			putch(padc, putdat);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	57                   	push   %edi
  800372:	6a 20                	push   $0x20
  800374:	ff d6                	call   *%esi
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	eb ec                	jmp    800367 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80037b:	83 ec 0c             	sub    $0xc,%esp
  80037e:	ff 75 18             	pushl  0x18(%ebp)
  800381:	83 eb 01             	sub    $0x1,%ebx
  800384:	53                   	push   %ebx
  800385:	50                   	push   %eax
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	ff 75 dc             	pushl  -0x24(%ebp)
  80038c:	ff 75 d8             	pushl  -0x28(%ebp)
  80038f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800392:	ff 75 e0             	pushl  -0x20(%ebp)
  800395:	e8 86 25 00 00       	call   802920 <__udivdi3>
  80039a:	83 c4 18             	add    $0x18,%esp
  80039d:	52                   	push   %edx
  80039e:	50                   	push   %eax
  80039f:	89 fa                	mov    %edi,%edx
  8003a1:	89 f0                	mov    %esi,%eax
  8003a3:	e8 54 ff ff ff       	call   8002fc <printnum>
  8003a8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	57                   	push   %edi
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8003be:	e8 6d 26 00 00       	call   802a30 <__umoddi3>
  8003c3:	83 c4 14             	add    $0x14,%esp
  8003c6:	0f be 80 6f 2c 80 00 	movsbl 0x802c6f(%eax),%eax
  8003cd:	50                   	push   %eax
  8003ce:	ff d6                	call   *%esi
  8003d0:	83 c4 10             	add    $0x10,%esp
	}
}
  8003d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d6:	5b                   	pop    %ebx
  8003d7:	5e                   	pop    %esi
  8003d8:	5f                   	pop    %edi
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003e5:	8b 10                	mov    (%eax),%edx
  8003e7:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ea:	73 0a                	jae    8003f6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ec:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ef:	89 08                	mov    %ecx,(%eax)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	88 02                	mov    %al,(%edx)
}
  8003f6:	5d                   	pop    %ebp
  8003f7:	c3                   	ret    

008003f8 <printfmt>:
{
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003fe:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800401:	50                   	push   %eax
  800402:	ff 75 10             	pushl  0x10(%ebp)
  800405:	ff 75 0c             	pushl  0xc(%ebp)
  800408:	ff 75 08             	pushl  0x8(%ebp)
  80040b:	e8 05 00 00 00       	call   800415 <vprintfmt>
}
  800410:	83 c4 10             	add    $0x10,%esp
  800413:	c9                   	leave  
  800414:	c3                   	ret    

00800415 <vprintfmt>:
{
  800415:	55                   	push   %ebp
  800416:	89 e5                	mov    %esp,%ebp
  800418:	57                   	push   %edi
  800419:	56                   	push   %esi
  80041a:	53                   	push   %ebx
  80041b:	83 ec 3c             	sub    $0x3c,%esp
  80041e:	8b 75 08             	mov    0x8(%ebp),%esi
  800421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800424:	8b 7d 10             	mov    0x10(%ebp),%edi
  800427:	e9 32 04 00 00       	jmp    80085e <vprintfmt+0x449>
		padc = ' ';
  80042c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800430:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800437:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80043e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800445:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80044c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800453:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800458:	8d 47 01             	lea    0x1(%edi),%eax
  80045b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045e:	0f b6 17             	movzbl (%edi),%edx
  800461:	8d 42 dd             	lea    -0x23(%edx),%eax
  800464:	3c 55                	cmp    $0x55,%al
  800466:	0f 87 12 05 00 00    	ja     80097e <vprintfmt+0x569>
  80046c:	0f b6 c0             	movzbl %al,%eax
  80046f:	ff 24 85 40 2e 80 00 	jmp    *0x802e40(,%eax,4)
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800479:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80047d:	eb d9                	jmp    800458 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800482:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800486:	eb d0                	jmp    800458 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800488:	0f b6 d2             	movzbl %dl,%edx
  80048b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80048e:	b8 00 00 00 00       	mov    $0x0,%eax
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	eb 03                	jmp    80049b <vprintfmt+0x86>
  800498:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80049b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004a8:	83 fe 09             	cmp    $0x9,%esi
  8004ab:	76 eb                	jbe    800498 <vprintfmt+0x83>
  8004ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b3:	eb 14                	jmp    8004c9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8d 40 04             	lea    0x4(%eax),%eax
  8004c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cd:	79 89                	jns    800458 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004dc:	e9 77 ff ff ff       	jmp    800458 <vprintfmt+0x43>
  8004e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	0f 48 c1             	cmovs  %ecx,%eax
  8004e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	e9 64 ff ff ff       	jmp    800458 <vprintfmt+0x43>
  8004f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004fe:	e9 55 ff ff ff       	jmp    800458 <vprintfmt+0x43>
			lflag++;
  800503:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050a:	e9 49 ff ff ff       	jmp    800458 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 78 04             	lea    0x4(%eax),%edi
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	ff 30                	pushl  (%eax)
  80051b:	ff d6                	call   *%esi
			break;
  80051d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800520:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800523:	e9 33 03 00 00       	jmp    80085b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8d 78 04             	lea    0x4(%eax),%edi
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	99                   	cltd   
  800531:	31 d0                	xor    %edx,%eax
  800533:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800535:	83 f8 11             	cmp    $0x11,%eax
  800538:	7f 23                	jg     80055d <vprintfmt+0x148>
  80053a:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  800541:	85 d2                	test   %edx,%edx
  800543:	74 18                	je     80055d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800545:	52                   	push   %edx
  800546:	68 ad 31 80 00       	push   $0x8031ad
  80054b:	53                   	push   %ebx
  80054c:	56                   	push   %esi
  80054d:	e8 a6 fe ff ff       	call   8003f8 <printfmt>
  800552:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800555:	89 7d 14             	mov    %edi,0x14(%ebp)
  800558:	e9 fe 02 00 00       	jmp    80085b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80055d:	50                   	push   %eax
  80055e:	68 87 2c 80 00       	push   $0x802c87
  800563:	53                   	push   %ebx
  800564:	56                   	push   %esi
  800565:	e8 8e fe ff ff       	call   8003f8 <printfmt>
  80056a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800570:	e9 e6 02 00 00       	jmp    80085b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	83 c0 04             	add    $0x4,%eax
  80057b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800583:	85 c9                	test   %ecx,%ecx
  800585:	b8 80 2c 80 00       	mov    $0x802c80,%eax
  80058a:	0f 45 c1             	cmovne %ecx,%eax
  80058d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800590:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800594:	7e 06                	jle    80059c <vprintfmt+0x187>
  800596:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80059a:	75 0d                	jne    8005a9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80059f:	89 c7                	mov    %eax,%edi
  8005a1:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a7:	eb 53                	jmp    8005fc <vprintfmt+0x1e7>
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 71 04 00 00       	call   800a26 <strnlen>
  8005b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b8:	29 c1                	sub    %eax,%ecx
  8005ba:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005c2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c9:	eb 0f                	jmp    8005da <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	53                   	push   %ebx
  8005cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	83 ef 01             	sub    $0x1,%edi
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	85 ff                	test   %edi,%edi
  8005dc:	7f ed                	jg     8005cb <vprintfmt+0x1b6>
  8005de:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e8:	0f 49 c1             	cmovns %ecx,%eax
  8005eb:	29 c1                	sub    %eax,%ecx
  8005ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005f0:	eb aa                	jmp    80059c <vprintfmt+0x187>
					putch(ch, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	53                   	push   %ebx
  8005f6:	52                   	push   %edx
  8005f7:	ff d6                	call   *%esi
  8005f9:	83 c4 10             	add    $0x10,%esp
  8005fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ff:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800601:	83 c7 01             	add    $0x1,%edi
  800604:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800608:	0f be d0             	movsbl %al,%edx
  80060b:	85 d2                	test   %edx,%edx
  80060d:	74 4b                	je     80065a <vprintfmt+0x245>
  80060f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800613:	78 06                	js     80061b <vprintfmt+0x206>
  800615:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800619:	78 1e                	js     800639 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80061f:	74 d1                	je     8005f2 <vprintfmt+0x1dd>
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 e8 20             	sub    $0x20,%eax
  800627:	83 f8 5e             	cmp    $0x5e,%eax
  80062a:	76 c6                	jbe    8005f2 <vprintfmt+0x1dd>
					putch('?', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	53                   	push   %ebx
  800630:	6a 3f                	push   $0x3f
  800632:	ff d6                	call   *%esi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb c3                	jmp    8005fc <vprintfmt+0x1e7>
  800639:	89 cf                	mov    %ecx,%edi
  80063b:	eb 0e                	jmp    80064b <vprintfmt+0x236>
				putch(' ', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 20                	push   $0x20
  800643:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800645:	83 ef 01             	sub    $0x1,%edi
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	85 ff                	test   %edi,%edi
  80064d:	7f ee                	jg     80063d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80064f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	e9 01 02 00 00       	jmp    80085b <vprintfmt+0x446>
  80065a:	89 cf                	mov    %ecx,%edi
  80065c:	eb ed                	jmp    80064b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80065e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800661:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800668:	e9 eb fd ff ff       	jmp    800458 <vprintfmt+0x43>
	if (lflag >= 2)
  80066d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800671:	7f 21                	jg     800694 <vprintfmt+0x27f>
	else if (lflag)
  800673:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800677:	74 68                	je     8006e1 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800681:	89 c1                	mov    %eax,%ecx
  800683:	c1 f9 1f             	sar    $0x1f,%ecx
  800686:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	eb 17                	jmp    8006ab <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80069f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006b7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006bb:	78 3f                	js     8006fc <vprintfmt+0x2e7>
			base = 10;
  8006bd:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006c2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006c6:	0f 84 71 01 00 00    	je     80083d <vprintfmt+0x428>
				putch('+', putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	53                   	push   %ebx
  8006d0:	6a 2b                	push   $0x2b
  8006d2:	ff d6                	call   *%esi
  8006d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006dc:	e9 5c 01 00 00       	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e9:	89 c1                	mov    %eax,%ecx
  8006eb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ee:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8d 40 04             	lea    0x4(%eax),%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fa:	eb af                	jmp    8006ab <vprintfmt+0x296>
				putch('-', putdat);
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	53                   	push   %ebx
  800700:	6a 2d                	push   $0x2d
  800702:	ff d6                	call   *%esi
				num = -(long long) num;
  800704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800707:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80070a:	f7 d8                	neg    %eax
  80070c:	83 d2 00             	adc    $0x0,%edx
  80070f:	f7 da                	neg    %edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80071a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071f:	e9 19 01 00 00       	jmp    80083d <vprintfmt+0x428>
	if (lflag >= 2)
  800724:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800728:	7f 29                	jg     800753 <vprintfmt+0x33e>
	else if (lflag)
  80072a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072e:	74 44                	je     800774 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 40 04             	lea    0x4(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800749:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074e:	e9 ea 00 00 00       	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 50 04             	mov    0x4(%eax),%edx
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8d 40 08             	lea    0x8(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076f:	e9 c9 00 00 00       	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	ba 00 00 00 00       	mov    $0x0,%edx
  80077e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800781:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800792:	e9 a6 00 00 00       	jmp    80083d <vprintfmt+0x428>
			putch('0', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 30                	push   $0x30
  80079d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80079f:	83 c4 10             	add    $0x10,%esp
  8007a2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a6:	7f 26                	jg     8007ce <vprintfmt+0x3b9>
	else if (lflag)
  8007a8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ac:	74 3e                	je     8007ec <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 40 04             	lea    0x4(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007cc:	eb 6f                	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 50 04             	mov    0x4(%eax),%edx
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8d 40 08             	lea    0x8(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ea:	eb 51                	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 00                	mov    (%eax),%eax
  8007f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800805:	b8 08 00 00 00       	mov    $0x8,%eax
  80080a:	eb 31                	jmp    80083d <vprintfmt+0x428>
			putch('0', putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	6a 30                	push   $0x30
  800812:	ff d6                	call   *%esi
			putch('x', putdat);
  800814:	83 c4 08             	add    $0x8,%esp
  800817:	53                   	push   %ebx
  800818:	6a 78                	push   $0x78
  80081a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800829:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80082c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80083d:	83 ec 0c             	sub    $0xc,%esp
  800840:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800844:	52                   	push   %edx
  800845:	ff 75 e0             	pushl  -0x20(%ebp)
  800848:	50                   	push   %eax
  800849:	ff 75 dc             	pushl  -0x24(%ebp)
  80084c:	ff 75 d8             	pushl  -0x28(%ebp)
  80084f:	89 da                	mov    %ebx,%edx
  800851:	89 f0                	mov    %esi,%eax
  800853:	e8 a4 fa ff ff       	call   8002fc <printnum>
			break;
  800858:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80085b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085e:	83 c7 01             	add    $0x1,%edi
  800861:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800865:	83 f8 25             	cmp    $0x25,%eax
  800868:	0f 84 be fb ff ff    	je     80042c <vprintfmt+0x17>
			if (ch == '\0')
  80086e:	85 c0                	test   %eax,%eax
  800870:	0f 84 28 01 00 00    	je     80099e <vprintfmt+0x589>
			putch(ch, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	50                   	push   %eax
  80087b:	ff d6                	call   *%esi
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	eb dc                	jmp    80085e <vprintfmt+0x449>
	if (lflag >= 2)
  800882:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800886:	7f 26                	jg     8008ae <vprintfmt+0x499>
	else if (lflag)
  800888:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80088c:	74 41                	je     8008cf <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 40 04             	lea    0x4(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ac:	eb 8f                	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8b 50 04             	mov    0x4(%eax),%edx
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 08             	lea    0x8(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ca:	e9 6e ff ff ff       	jmp    80083d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8d 40 04             	lea    0x4(%eax),%eax
  8008e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ed:	e9 4b ff ff ff       	jmp    80083d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	83 c0 04             	add    $0x4,%eax
  8008f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	85 c0                	test   %eax,%eax
  800902:	74 14                	je     800918 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800904:	8b 13                	mov    (%ebx),%edx
  800906:	83 fa 7f             	cmp    $0x7f,%edx
  800909:	7f 37                	jg     800942 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80090b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80090d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	e9 43 ff ff ff       	jmp    80085b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800918:	b8 0a 00 00 00       	mov    $0xa,%eax
  80091d:	bf a5 2d 80 00       	mov    $0x802da5,%edi
							putch(ch, putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	53                   	push   %ebx
  800926:	50                   	push   %eax
  800927:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800929:	83 c7 01             	add    $0x1,%edi
  80092c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	85 c0                	test   %eax,%eax
  800935:	75 eb                	jne    800922 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800937:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80093a:	89 45 14             	mov    %eax,0x14(%ebp)
  80093d:	e9 19 ff ff ff       	jmp    80085b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800942:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800944:	b8 0a 00 00 00       	mov    $0xa,%eax
  800949:	bf dd 2d 80 00       	mov    $0x802ddd,%edi
							putch(ch, putdat);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	53                   	push   %ebx
  800952:	50                   	push   %eax
  800953:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800955:	83 c7 01             	add    $0x1,%edi
  800958:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	85 c0                	test   %eax,%eax
  800961:	75 eb                	jne    80094e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800963:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800966:	89 45 14             	mov    %eax,0x14(%ebp)
  800969:	e9 ed fe ff ff       	jmp    80085b <vprintfmt+0x446>
			putch(ch, putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	53                   	push   %ebx
  800972:	6a 25                	push   $0x25
  800974:	ff d6                	call   *%esi
			break;
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	e9 dd fe ff ff       	jmp    80085b <vprintfmt+0x446>
			putch('%', putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	53                   	push   %ebx
  800982:	6a 25                	push   $0x25
  800984:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	89 f8                	mov    %edi,%eax
  80098b:	eb 03                	jmp    800990 <vprintfmt+0x57b>
  80098d:	83 e8 01             	sub    $0x1,%eax
  800990:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800994:	75 f7                	jne    80098d <vprintfmt+0x578>
  800996:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800999:	e9 bd fe ff ff       	jmp    80085b <vprintfmt+0x446>
}
  80099e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5f                   	pop    %edi
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 18             	sub    $0x18,%esp
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c3:	85 c0                	test   %eax,%eax
  8009c5:	74 26                	je     8009ed <vsnprintf+0x47>
  8009c7:	85 d2                	test   %edx,%edx
  8009c9:	7e 22                	jle    8009ed <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009cb:	ff 75 14             	pushl  0x14(%ebp)
  8009ce:	ff 75 10             	pushl  0x10(%ebp)
  8009d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	68 db 03 80 00       	push   $0x8003db
  8009da:	e8 36 fa ff ff       	call   800415 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    
		return -E_INVAL;
  8009ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f2:	eb f7                	jmp    8009eb <vsnprintf+0x45>

008009f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 10             	pushl  0x10(%ebp)
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 9a ff ff ff       	call   8009a6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
  800a19:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a1d:	74 05                	je     800a24 <strlen+0x16>
		n++;
  800a1f:	83 c0 01             	add    $0x1,%eax
  800a22:	eb f5                	jmp    800a19 <strlen+0xb>
	return n;
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 0d                	je     800a45 <strnlen+0x1f>
  800a38:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a3c:	74 05                	je     800a43 <strnlen+0x1d>
		n++;
  800a3e:	83 c2 01             	add    $0x1,%edx
  800a41:	eb f1                	jmp    800a34 <strnlen+0xe>
  800a43:	89 d0                	mov    %edx,%eax
	return n;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a51:	ba 00 00 00 00       	mov    $0x0,%edx
  800a56:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	84 c9                	test   %cl,%cl
  800a62:	75 f2                	jne    800a56 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a64:	5b                   	pop    %ebx
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 10             	sub    $0x10,%esp
  800a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a71:	53                   	push   %ebx
  800a72:	e8 97 ff ff ff       	call   800a0e <strlen>
  800a77:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	01 d8                	add    %ebx,%eax
  800a7f:	50                   	push   %eax
  800a80:	e8 c2 ff ff ff       	call   800a47 <strcpy>
	return dst;
}
  800a85:	89 d8                	mov    %ebx,%eax
  800a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	56                   	push   %esi
  800a90:	53                   	push   %ebx
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a97:	89 c6                	mov    %eax,%esi
  800a99:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9c:	89 c2                	mov    %eax,%edx
  800a9e:	39 f2                	cmp    %esi,%edx
  800aa0:	74 11                	je     800ab3 <strncpy+0x27>
		*dst++ = *src;
  800aa2:	83 c2 01             	add    $0x1,%edx
  800aa5:	0f b6 19             	movzbl (%ecx),%ebx
  800aa8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aab:	80 fb 01             	cmp    $0x1,%bl
  800aae:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ab1:	eb eb                	jmp    800a9e <strncpy+0x12>
	}
	return ret;
}
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	8b 75 08             	mov    0x8(%ebp),%esi
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac7:	85 d2                	test   %edx,%edx
  800ac9:	74 21                	je     800aec <strlcpy+0x35>
  800acb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad1:	39 c2                	cmp    %eax,%edx
  800ad3:	74 14                	je     800ae9 <strlcpy+0x32>
  800ad5:	0f b6 19             	movzbl (%ecx),%ebx
  800ad8:	84 db                	test   %bl,%bl
  800ada:	74 0b                	je     800ae7 <strlcpy+0x30>
			*dst++ = *src++;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	83 c2 01             	add    $0x1,%edx
  800ae2:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae5:	eb ea                	jmp    800ad1 <strlcpy+0x1a>
  800ae7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aec:	29 f0                	sub    %esi,%eax
}
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afb:	0f b6 01             	movzbl (%ecx),%eax
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0c                	je     800b0e <strcmp+0x1c>
  800b02:	3a 02                	cmp    (%edx),%al
  800b04:	75 08                	jne    800b0e <strcmp+0x1c>
		p++, q++;
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	eb ed                	jmp    800afb <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	0f b6 12             	movzbl (%edx),%edx
  800b14:	29 d0                	sub    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	53                   	push   %ebx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	89 c3                	mov    %eax,%ebx
  800b24:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b27:	eb 06                	jmp    800b2f <strncmp+0x17>
		n--, p++, q++;
  800b29:	83 c0 01             	add    $0x1,%eax
  800b2c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2f:	39 d8                	cmp    %ebx,%eax
  800b31:	74 16                	je     800b49 <strncmp+0x31>
  800b33:	0f b6 08             	movzbl (%eax),%ecx
  800b36:	84 c9                	test   %cl,%cl
  800b38:	74 04                	je     800b3e <strncmp+0x26>
  800b3a:	3a 0a                	cmp    (%edx),%cl
  800b3c:	74 eb                	je     800b29 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3e:	0f b6 00             	movzbl (%eax),%eax
  800b41:	0f b6 12             	movzbl (%edx),%edx
  800b44:	29 d0                	sub    %edx,%eax
}
  800b46:	5b                   	pop    %ebx
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    
		return 0;
  800b49:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4e:	eb f6                	jmp    800b46 <strncmp+0x2e>

00800b50 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5a:	0f b6 10             	movzbl (%eax),%edx
  800b5d:	84 d2                	test   %dl,%dl
  800b5f:	74 09                	je     800b6a <strchr+0x1a>
		if (*s == c)
  800b61:	38 ca                	cmp    %cl,%dl
  800b63:	74 0a                	je     800b6f <strchr+0x1f>
	for (; *s; s++)
  800b65:	83 c0 01             	add    $0x1,%eax
  800b68:	eb f0                	jmp    800b5a <strchr+0xa>
			return (char *) s;
	return 0;
  800b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b7e:	38 ca                	cmp    %cl,%dl
  800b80:	74 09                	je     800b8b <strfind+0x1a>
  800b82:	84 d2                	test   %dl,%dl
  800b84:	74 05                	je     800b8b <strfind+0x1a>
	for (; *s; s++)
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	eb f0                	jmp    800b7b <strfind+0xa>
			break;
	return (char *) s;
}
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b96:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b99:	85 c9                	test   %ecx,%ecx
  800b9b:	74 31                	je     800bce <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9d:	89 f8                	mov    %edi,%eax
  800b9f:	09 c8                	or     %ecx,%eax
  800ba1:	a8 03                	test   $0x3,%al
  800ba3:	75 23                	jne    800bc8 <memset+0x3b>
		c &= 0xFF;
  800ba5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	c1 e3 08             	shl    $0x8,%ebx
  800bae:	89 d0                	mov    %edx,%eax
  800bb0:	c1 e0 18             	shl    $0x18,%eax
  800bb3:	89 d6                	mov    %edx,%esi
  800bb5:	c1 e6 10             	shl    $0x10,%esi
  800bb8:	09 f0                	or     %esi,%eax
  800bba:	09 c2                	or     %eax,%edx
  800bbc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bbe:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	fc                   	cld    
  800bc4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc6:	eb 06                	jmp    800bce <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	fc                   	cld    
  800bcc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bce:	89 f8                	mov    %edi,%eax
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be3:	39 c6                	cmp    %eax,%esi
  800be5:	73 32                	jae    800c19 <memmove+0x44>
  800be7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bea:	39 c2                	cmp    %eax,%edx
  800bec:	76 2b                	jbe    800c19 <memmove+0x44>
		s += n;
		d += n;
  800bee:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf1:	89 fe                	mov    %edi,%esi
  800bf3:	09 ce                	or     %ecx,%esi
  800bf5:	09 d6                	or     %edx,%esi
  800bf7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bfd:	75 0e                	jne    800c0d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bff:	83 ef 04             	sub    $0x4,%edi
  800c02:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c05:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c08:	fd                   	std    
  800c09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0b:	eb 09                	jmp    800c16 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c0d:	83 ef 01             	sub    $0x1,%edi
  800c10:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c13:	fd                   	std    
  800c14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c16:	fc                   	cld    
  800c17:	eb 1a                	jmp    800c33 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c19:	89 c2                	mov    %eax,%edx
  800c1b:	09 ca                	or     %ecx,%edx
  800c1d:	09 f2                	or     %esi,%edx
  800c1f:	f6 c2 03             	test   $0x3,%dl
  800c22:	75 0a                	jne    800c2e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c24:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c27:	89 c7                	mov    %eax,%edi
  800c29:	fc                   	cld    
  800c2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2c:	eb 05                	jmp    800c33 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c2e:	89 c7                	mov    %eax,%edi
  800c30:	fc                   	cld    
  800c31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c3d:	ff 75 10             	pushl  0x10(%ebp)
  800c40:	ff 75 0c             	pushl  0xc(%ebp)
  800c43:	ff 75 08             	pushl  0x8(%ebp)
  800c46:	e8 8a ff ff ff       	call   800bd5 <memmove>
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c58:	89 c6                	mov    %eax,%esi
  800c5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5d:	39 f0                	cmp    %esi,%eax
  800c5f:	74 1c                	je     800c7d <memcmp+0x30>
		if (*s1 != *s2)
  800c61:	0f b6 08             	movzbl (%eax),%ecx
  800c64:	0f b6 1a             	movzbl (%edx),%ebx
  800c67:	38 d9                	cmp    %bl,%cl
  800c69:	75 08                	jne    800c73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c6b:	83 c0 01             	add    $0x1,%eax
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	eb ea                	jmp    800c5d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c73:	0f b6 c1             	movzbl %cl,%eax
  800c76:	0f b6 db             	movzbl %bl,%ebx
  800c79:	29 d8                	sub    %ebx,%eax
  800c7b:	eb 05                	jmp    800c82 <memcmp+0x35>
	}

	return 0;
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c8f:	89 c2                	mov    %eax,%edx
  800c91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c94:	39 d0                	cmp    %edx,%eax
  800c96:	73 09                	jae    800ca1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c98:	38 08                	cmp    %cl,(%eax)
  800c9a:	74 05                	je     800ca1 <memfind+0x1b>
	for (; s < ends; s++)
  800c9c:	83 c0 01             	add    $0x1,%eax
  800c9f:	eb f3                	jmp    800c94 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800caf:	eb 03                	jmp    800cb4 <strtol+0x11>
		s++;
  800cb1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb4:	0f b6 01             	movzbl (%ecx),%eax
  800cb7:	3c 20                	cmp    $0x20,%al
  800cb9:	74 f6                	je     800cb1 <strtol+0xe>
  800cbb:	3c 09                	cmp    $0x9,%al
  800cbd:	74 f2                	je     800cb1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cbf:	3c 2b                	cmp    $0x2b,%al
  800cc1:	74 2a                	je     800ced <strtol+0x4a>
	int neg = 0;
  800cc3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc8:	3c 2d                	cmp    $0x2d,%al
  800cca:	74 2b                	je     800cf7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd2:	75 0f                	jne    800ce3 <strtol+0x40>
  800cd4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd7:	74 28                	je     800d01 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd9:	85 db                	test   %ebx,%ebx
  800cdb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce0:	0f 44 d8             	cmove  %eax,%ebx
  800ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ceb:	eb 50                	jmp    800d3d <strtol+0x9a>
		s++;
  800ced:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf5:	eb d5                	jmp    800ccc <strtol+0x29>
		s++, neg = 1;
  800cf7:	83 c1 01             	add    $0x1,%ecx
  800cfa:	bf 01 00 00 00       	mov    $0x1,%edi
  800cff:	eb cb                	jmp    800ccc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d05:	74 0e                	je     800d15 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	75 d8                	jne    800ce3 <strtol+0x40>
		s++, base = 8;
  800d0b:	83 c1 01             	add    $0x1,%ecx
  800d0e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d13:	eb ce                	jmp    800ce3 <strtol+0x40>
		s += 2, base = 16;
  800d15:	83 c1 02             	add    $0x2,%ecx
  800d18:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d1d:	eb c4                	jmp    800ce3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d1f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d22:	89 f3                	mov    %esi,%ebx
  800d24:	80 fb 19             	cmp    $0x19,%bl
  800d27:	77 29                	ja     800d52 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d29:	0f be d2             	movsbl %dl,%edx
  800d2c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d2f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d32:	7d 30                	jge    800d64 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d34:	83 c1 01             	add    $0x1,%ecx
  800d37:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d3b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d3d:	0f b6 11             	movzbl (%ecx),%edx
  800d40:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d43:	89 f3                	mov    %esi,%ebx
  800d45:	80 fb 09             	cmp    $0x9,%bl
  800d48:	77 d5                	ja     800d1f <strtol+0x7c>
			dig = *s - '0';
  800d4a:	0f be d2             	movsbl %dl,%edx
  800d4d:	83 ea 30             	sub    $0x30,%edx
  800d50:	eb dd                	jmp    800d2f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d52:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d55:	89 f3                	mov    %esi,%ebx
  800d57:	80 fb 19             	cmp    $0x19,%bl
  800d5a:	77 08                	ja     800d64 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d5c:	0f be d2             	movsbl %dl,%edx
  800d5f:	83 ea 37             	sub    $0x37,%edx
  800d62:	eb cb                	jmp    800d2f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	74 05                	je     800d6f <strtol+0xcc>
		*endptr = (char *) s;
  800d6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d6f:	89 c2                	mov    %eax,%edx
  800d71:	f7 da                	neg    %edx
  800d73:	85 ff                	test   %edi,%edi
  800d75:	0f 45 c2             	cmovne %edx,%eax
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	89 c3                	mov    %eax,%ebx
  800d90:	89 c7                	mov    %eax,%edi
  800d92:	89 c6                	mov    %eax,%esi
  800d94:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dab:	89 d1                	mov    %edx,%ecx
  800dad:	89 d3                	mov    %edx,%ebx
  800daf:	89 d7                	mov    %edx,%edi
  800db1:	89 d6                	mov    %edx,%esi
  800db3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd0:	89 cb                	mov    %ecx,%ebx
  800dd2:	89 cf                	mov    %ecx,%edi
  800dd4:	89 ce                	mov    %ecx,%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800de8:	6a 03                	push   $0x3
  800dea:	68 e8 2f 80 00       	push   $0x802fe8
  800def:	6a 43                	push   $0x43
  800df1:	68 05 30 80 00       	push   $0x803005
  800df6:	e8 f7 f3 ff ff       	call   8001f2 <_panic>

00800dfb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 02 00 00 00       	mov    $0x2,%eax
  800e0b:	89 d1                	mov    %edx,%ecx
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	89 d7                	mov    %edx,%edi
  800e11:	89 d6                	mov    %edx,%esi
  800e13:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_yield>:

void
sys_yield(void)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e20:	ba 00 00 00 00       	mov    $0x0,%edx
  800e25:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e2a:	89 d1                	mov    %edx,%ecx
  800e2c:	89 d3                	mov    %edx,%ebx
  800e2e:	89 d7                	mov    %edx,%edi
  800e30:	89 d6                	mov    %edx,%esi
  800e32:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
  800e3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e42:	be 00 00 00 00       	mov    $0x0,%esi
  800e47:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e55:	89 f7                	mov    %esi,%edi
  800e57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7f 08                	jg     800e65 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e65:	83 ec 0c             	sub    $0xc,%esp
  800e68:	50                   	push   %eax
  800e69:	6a 04                	push   $0x4
  800e6b:	68 e8 2f 80 00       	push   $0x802fe8
  800e70:	6a 43                	push   $0x43
  800e72:	68 05 30 80 00       	push   $0x803005
  800e77:	e8 76 f3 ff ff       	call   8001f2 <_panic>

00800e7c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	b8 05 00 00 00       	mov    $0x5,%eax
  800e90:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e93:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e96:	8b 75 18             	mov    0x18(%ebp),%esi
  800e99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	7f 08                	jg     800ea7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea2:	5b                   	pop    %ebx
  800ea3:	5e                   	pop    %esi
  800ea4:	5f                   	pop    %edi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	83 ec 0c             	sub    $0xc,%esp
  800eaa:	50                   	push   %eax
  800eab:	6a 05                	push   $0x5
  800ead:	68 e8 2f 80 00       	push   $0x802fe8
  800eb2:	6a 43                	push   $0x43
  800eb4:	68 05 30 80 00       	push   $0x803005
  800eb9:	e8 34 f3 ff ff       	call   8001f2 <_panic>

00800ebe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ed7:	89 df                	mov    %ebx,%edi
  800ed9:	89 de                	mov    %ebx,%esi
  800edb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	7f 08                	jg     800ee9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	50                   	push   %eax
  800eed:	6a 06                	push   $0x6
  800eef:	68 e8 2f 80 00       	push   $0x802fe8
  800ef4:	6a 43                	push   $0x43
  800ef6:	68 05 30 80 00       	push   $0x803005
  800efb:	e8 f2 f2 ff ff       	call   8001f2 <_panic>

00800f00 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f14:	b8 08 00 00 00       	mov    $0x8,%eax
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7f 08                	jg     800f2b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	50                   	push   %eax
  800f2f:	6a 08                	push   $0x8
  800f31:	68 e8 2f 80 00       	push   $0x802fe8
  800f36:	6a 43                	push   $0x43
  800f38:	68 05 30 80 00       	push   $0x803005
  800f3d:	e8 b0 f2 ff ff       	call   8001f2 <_panic>

00800f42 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	57                   	push   %edi
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f56:	b8 09 00 00 00       	mov    $0x9,%eax
  800f5b:	89 df                	mov    %ebx,%edi
  800f5d:	89 de                	mov    %ebx,%esi
  800f5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f61:	85 c0                	test   %eax,%eax
  800f63:	7f 08                	jg     800f6d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f68:	5b                   	pop    %ebx
  800f69:	5e                   	pop    %esi
  800f6a:	5f                   	pop    %edi
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6d:	83 ec 0c             	sub    $0xc,%esp
  800f70:	50                   	push   %eax
  800f71:	6a 09                	push   $0x9
  800f73:	68 e8 2f 80 00       	push   $0x802fe8
  800f78:	6a 43                	push   $0x43
  800f7a:	68 05 30 80 00       	push   $0x803005
  800f7f:	e8 6e f2 ff ff       	call   8001f2 <_panic>

00800f84 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
  800f8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9d:	89 df                	mov    %ebx,%edi
  800f9f:	89 de                	mov    %ebx,%esi
  800fa1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	7f 08                	jg     800faf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	50                   	push   %eax
  800fb3:	6a 0a                	push   $0xa
  800fb5:	68 e8 2f 80 00       	push   $0x802fe8
  800fba:	6a 43                	push   $0x43
  800fbc:	68 05 30 80 00       	push   $0x803005
  800fc1:	e8 2c f2 ff ff       	call   8001f2 <_panic>

00800fc6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fd7:	be 00 00 00 00       	mov    $0x0,%esi
  800fdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
  800fef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fff:	89 cb                	mov    %ecx,%ebx
  801001:	89 cf                	mov    %ecx,%edi
  801003:	89 ce                	mov    %ecx,%esi
  801005:	cd 30                	int    $0x30
	if(check && ret > 0)
  801007:	85 c0                	test   %eax,%eax
  801009:	7f 08                	jg     801013 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801013:	83 ec 0c             	sub    $0xc,%esp
  801016:	50                   	push   %eax
  801017:	6a 0d                	push   $0xd
  801019:	68 e8 2f 80 00       	push   $0x802fe8
  80101e:	6a 43                	push   $0x43
  801020:	68 05 30 80 00       	push   $0x803005
  801025:	e8 c8 f1 ff ff       	call   8001f2 <_panic>

0080102a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801040:	89 df                	mov    %ebx,%edi
  801042:	89 de                	mov    %ebx,%esi
  801044:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
	asm volatile("int %1\n"
  801051:	b9 00 00 00 00       	mov    $0x0,%ecx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105e:	89 cb                	mov    %ecx,%ebx
  801060:	89 cf                	mov    %ecx,%edi
  801062:	89 ce                	mov    %ecx,%esi
  801064:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
	asm volatile("int %1\n"
  801071:	ba 00 00 00 00       	mov    $0x0,%edx
  801076:	b8 10 00 00 00       	mov    $0x10,%eax
  80107b:	89 d1                	mov    %edx,%ecx
  80107d:	89 d3                	mov    %edx,%ebx
  80107f:	89 d7                	mov    %edx,%edi
  801081:	89 d6                	mov    %edx,%esi
  801083:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	8b 55 08             	mov    0x8(%ebp),%edx
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5f                   	pop    %edi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	57                   	push   %edi
  8010af:	56                   	push   %esi
  8010b0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bc:	b8 12 00 00 00       	mov    $0x12,%eax
  8010c1:	89 df                	mov    %ebx,%edi
  8010c3:	89 de                	mov    %ebx,%esi
  8010c5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	57                   	push   %edi
  8010d0:	56                   	push   %esi
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e0:	b8 13 00 00 00       	mov    $0x13,%eax
  8010e5:	89 df                	mov    %ebx,%edi
  8010e7:	89 de                	mov    %ebx,%esi
  8010e9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	7f 08                	jg     8010f7 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	5d                   	pop    %ebp
  8010f6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	50                   	push   %eax
  8010fb:	6a 13                	push   $0x13
  8010fd:	68 e8 2f 80 00       	push   $0x802fe8
  801102:	6a 43                	push   $0x43
  801104:	68 05 30 80 00       	push   $0x803005
  801109:	e8 e4 f0 ff ff       	call   8001f2 <_panic>

0080110e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	53                   	push   %ebx
  801112:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801115:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80111c:	f6 c5 04             	test   $0x4,%ch
  80111f:	75 45                	jne    801166 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801121:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801128:	83 e1 07             	and    $0x7,%ecx
  80112b:	83 f9 07             	cmp    $0x7,%ecx
  80112e:	74 6f                	je     80119f <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801130:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801137:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80113d:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801143:	0f 84 b6 00 00 00    	je     8011ff <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801149:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801150:	83 e1 05             	and    $0x5,%ecx
  801153:	83 f9 05             	cmp    $0x5,%ecx
  801156:	0f 84 d7 00 00 00    	je     801233 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
  801161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801164:	c9                   	leave  
  801165:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801166:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80116d:	c1 e2 0c             	shl    $0xc,%edx
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801179:	51                   	push   %ecx
  80117a:	52                   	push   %edx
  80117b:	50                   	push   %eax
  80117c:	52                   	push   %edx
  80117d:	6a 00                	push   $0x0
  80117f:	e8 f8 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  801184:	83 c4 20             	add    $0x20,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	79 d1                	jns    80115c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	68 13 30 80 00       	push   $0x803013
  801193:	6a 54                	push   $0x54
  801195:	68 29 30 80 00       	push   $0x803029
  80119a:	e8 53 f0 ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80119f:	89 d3                	mov    %edx,%ebx
  8011a1:	c1 e3 0c             	shl    $0xc,%ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	68 05 08 00 00       	push   $0x805
  8011ac:	53                   	push   %ebx
  8011ad:	50                   	push   %eax
  8011ae:	53                   	push   %ebx
  8011af:	6a 00                	push   $0x0
  8011b1:	e8 c6 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  8011b6:	83 c4 20             	add    $0x20,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 2e                	js     8011eb <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	68 05 08 00 00       	push   $0x805
  8011c5:	53                   	push   %ebx
  8011c6:	6a 00                	push   $0x0
  8011c8:	53                   	push   %ebx
  8011c9:	6a 00                	push   $0x0
  8011cb:	e8 ac fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  8011d0:	83 c4 20             	add    $0x20,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	79 85                	jns    80115c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011d7:	83 ec 04             	sub    $0x4,%esp
  8011da:	68 13 30 80 00       	push   $0x803013
  8011df:	6a 5f                	push   $0x5f
  8011e1:	68 29 30 80 00       	push   $0x803029
  8011e6:	e8 07 f0 ff ff       	call   8001f2 <_panic>
			panic("sys_page_map() panic\n");
  8011eb:	83 ec 04             	sub    $0x4,%esp
  8011ee:	68 13 30 80 00       	push   $0x803013
  8011f3:	6a 5b                	push   $0x5b
  8011f5:	68 29 30 80 00       	push   $0x803029
  8011fa:	e8 f3 ef ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ff:	c1 e2 0c             	shl    $0xc,%edx
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	68 05 08 00 00       	push   $0x805
  80120a:	52                   	push   %edx
  80120b:	50                   	push   %eax
  80120c:	52                   	push   %edx
  80120d:	6a 00                	push   $0x0
  80120f:	e8 68 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  801214:	83 c4 20             	add    $0x20,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	0f 89 3d ff ff ff    	jns    80115c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	68 13 30 80 00       	push   $0x803013
  801227:	6a 66                	push   $0x66
  801229:	68 29 30 80 00       	push   $0x803029
  80122e:	e8 bf ef ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801233:	c1 e2 0c             	shl    $0xc,%edx
  801236:	83 ec 0c             	sub    $0xc,%esp
  801239:	6a 05                	push   $0x5
  80123b:	52                   	push   %edx
  80123c:	50                   	push   %eax
  80123d:	52                   	push   %edx
  80123e:	6a 00                	push   $0x0
  801240:	e8 37 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 89 0c ff ff ff    	jns    80115c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	68 13 30 80 00       	push   $0x803013
  801258:	6a 6d                	push   $0x6d
  80125a:	68 29 30 80 00       	push   $0x803029
  80125f:	e8 8e ef ff ff       	call   8001f2 <_panic>

00801264 <pgfault>:
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	53                   	push   %ebx
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80126e:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801270:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801274:	0f 84 99 00 00 00    	je     801313 <pgfault+0xaf>
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	c1 ea 16             	shr    $0x16,%edx
  80127f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801286:	f6 c2 01             	test   $0x1,%dl
  801289:	0f 84 84 00 00 00    	je     801313 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80128f:	89 c2                	mov    %eax,%edx
  801291:	c1 ea 0c             	shr    $0xc,%edx
  801294:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129b:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012a1:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012a7:	75 6a                	jne    801313 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ae:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	6a 07                	push   $0x7
  8012b5:	68 00 f0 7f 00       	push   $0x7ff000
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 78 fb ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	78 5f                	js     801327 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	68 00 10 00 00       	push   $0x1000
  8012d0:	53                   	push   %ebx
  8012d1:	68 00 f0 7f 00       	push   $0x7ff000
  8012d6:	e8 5c f9 ff ff       	call   800c37 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012db:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012e2:	53                   	push   %ebx
  8012e3:	6a 00                	push   $0x0
  8012e5:	68 00 f0 7f 00       	push   $0x7ff000
  8012ea:	6a 00                	push   $0x0
  8012ec:	e8 8b fb ff ff       	call   800e7c <sys_page_map>
	if(ret < 0)
  8012f1:	83 c4 20             	add    $0x20,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 43                	js     80133b <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	68 00 f0 7f 00       	push   $0x7ff000
  801300:	6a 00                	push   $0x0
  801302:	e8 b7 fb ff ff       	call   800ebe <sys_page_unmap>
	if(ret < 0)
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 41                	js     80134f <pgfault+0xeb>
}
  80130e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801311:	c9                   	leave  
  801312:	c3                   	ret    
		panic("panic at pgfault()\n");
  801313:	83 ec 04             	sub    $0x4,%esp
  801316:	68 34 30 80 00       	push   $0x803034
  80131b:	6a 26                	push   $0x26
  80131d:	68 29 30 80 00       	push   $0x803029
  801322:	e8 cb ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_alloc()\n");
  801327:	83 ec 04             	sub    $0x4,%esp
  80132a:	68 48 30 80 00       	push   $0x803048
  80132f:	6a 31                	push   $0x31
  801331:	68 29 30 80 00       	push   $0x803029
  801336:	e8 b7 ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_map()\n");
  80133b:	83 ec 04             	sub    $0x4,%esp
  80133e:	68 63 30 80 00       	push   $0x803063
  801343:	6a 36                	push   $0x36
  801345:	68 29 30 80 00       	push   $0x803029
  80134a:	e8 a3 ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_unmap()\n");
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	68 7c 30 80 00       	push   $0x80307c
  801357:	6a 39                	push   $0x39
  801359:	68 29 30 80 00       	push   $0x803029
  80135e:	e8 8f ee ff ff       	call   8001f2 <_panic>

00801363 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	57                   	push   %edi
  801367:	56                   	push   %esi
  801368:	53                   	push   %ebx
  801369:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80136c:	68 64 12 80 00       	push   $0x801264
  801371:	e8 d5 13 00 00       	call   80274b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801376:	b8 07 00 00 00       	mov    $0x7,%eax
  80137b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 27                	js     8013ab <fork+0x48>
  801384:	89 c6                	mov    %eax,%esi
  801386:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801388:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80138d:	75 48                	jne    8013d7 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80138f:	e8 67 fa ff ff       	call   800dfb <sys_getenvid>
  801394:	25 ff 03 00 00       	and    $0x3ff,%eax
  801399:	c1 e0 07             	shl    $0x7,%eax
  80139c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013a1:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013a6:	e9 90 00 00 00       	jmp    80143b <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	68 98 30 80 00       	push   $0x803098
  8013b3:	68 8c 00 00 00       	push   $0x8c
  8013b8:	68 29 30 80 00       	push   $0x803029
  8013bd:	e8 30 ee ff ff       	call   8001f2 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013c2:	89 f8                	mov    %edi,%eax
  8013c4:	e8 45 fd ff ff       	call   80110e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013cf:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013d5:	74 26                	je     8013fd <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	c1 e8 16             	shr    $0x16,%eax
  8013dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e3:	a8 01                	test   $0x1,%al
  8013e5:	74 e2                	je     8013c9 <fork+0x66>
  8013e7:	89 da                	mov    %ebx,%edx
  8013e9:	c1 ea 0c             	shr    $0xc,%edx
  8013ec:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013f3:	83 e0 05             	and    $0x5,%eax
  8013f6:	83 f8 05             	cmp    $0x5,%eax
  8013f9:	75 ce                	jne    8013c9 <fork+0x66>
  8013fb:	eb c5                	jmp    8013c2 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	6a 07                	push   $0x7
  801402:	68 00 f0 bf ee       	push   $0xeebff000
  801407:	56                   	push   %esi
  801408:	e8 2c fa ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  80140d:	83 c4 10             	add    $0x10,%esp
  801410:	85 c0                	test   %eax,%eax
  801412:	78 31                	js     801445 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	68 ba 27 80 00       	push   $0x8027ba
  80141c:	56                   	push   %esi
  80141d:	e8 62 fb ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 33                	js     80145c <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	6a 02                	push   $0x2
  80142e:	56                   	push   %esi
  80142f:	e8 cc fa ff ff       	call   800f00 <sys_env_set_status>
	if(ret < 0)
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 38                	js     801473 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80143b:	89 f0                	mov    %esi,%eax
  80143d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5f                   	pop    %edi
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 48 30 80 00       	push   $0x803048
  80144d:	68 98 00 00 00       	push   $0x98
  801452:	68 29 30 80 00       	push   $0x803029
  801457:	e8 96 ed ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80145c:	83 ec 04             	sub    $0x4,%esp
  80145f:	68 bc 30 80 00       	push   $0x8030bc
  801464:	68 9b 00 00 00       	push   $0x9b
  801469:	68 29 30 80 00       	push   $0x803029
  80146e:	e8 7f ed ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_status()\n");
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 e4 30 80 00       	push   $0x8030e4
  80147b:	68 9e 00 00 00       	push   $0x9e
  801480:	68 29 30 80 00       	push   $0x803029
  801485:	e8 68 ed ff ff       	call   8001f2 <_panic>

0080148a <sfork>:

// Challenge!
int
sfork(void)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	57                   	push   %edi
  80148e:	56                   	push   %esi
  80148f:	53                   	push   %ebx
  801490:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801493:	68 64 12 80 00       	push   $0x801264
  801498:	e8 ae 12 00 00       	call   80274b <set_pgfault_handler>
  80149d:	b8 07 00 00 00       	mov    $0x7,%eax
  8014a2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 27                	js     8014d2 <sfork+0x48>
  8014ab:	89 c7                	mov    %eax,%edi
  8014ad:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014af:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014b4:	75 55                	jne    80150b <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014b6:	e8 40 f9 ff ff       	call   800dfb <sys_getenvid>
  8014bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014c0:	c1 e0 07             	shl    $0x7,%eax
  8014c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014c8:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8014cd:	e9 d4 00 00 00       	jmp    8015a6 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	68 98 30 80 00       	push   $0x803098
  8014da:	68 af 00 00 00       	push   $0xaf
  8014df:	68 29 30 80 00       	push   $0x803029
  8014e4:	e8 09 ed ff ff       	call   8001f2 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014e9:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014ee:	89 f0                	mov    %esi,%eax
  8014f0:	e8 19 fc ff ff       	call   80110e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014fb:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801501:	77 65                	ja     801568 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801503:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801509:	74 de                	je     8014e9 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80150b:	89 d8                	mov    %ebx,%eax
  80150d:	c1 e8 16             	shr    $0x16,%eax
  801510:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801517:	a8 01                	test   $0x1,%al
  801519:	74 da                	je     8014f5 <sfork+0x6b>
  80151b:	89 da                	mov    %ebx,%edx
  80151d:	c1 ea 0c             	shr    $0xc,%edx
  801520:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801527:	83 e0 05             	and    $0x5,%eax
  80152a:	83 f8 05             	cmp    $0x5,%eax
  80152d:	75 c6                	jne    8014f5 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80152f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801536:	c1 e2 0c             	shl    $0xc,%edx
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	83 e0 07             	and    $0x7,%eax
  80153f:	50                   	push   %eax
  801540:	52                   	push   %edx
  801541:	56                   	push   %esi
  801542:	52                   	push   %edx
  801543:	6a 00                	push   $0x0
  801545:	e8 32 f9 ff ff       	call   800e7c <sys_page_map>
  80154a:	83 c4 20             	add    $0x20,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 a4                	je     8014f5 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	68 13 30 80 00       	push   $0x803013
  801559:	68 ba 00 00 00       	push   $0xba
  80155e:	68 29 30 80 00       	push   $0x803029
  801563:	e8 8a ec ff ff       	call   8001f2 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	6a 07                	push   $0x7
  80156d:	68 00 f0 bf ee       	push   $0xeebff000
  801572:	57                   	push   %edi
  801573:	e8 c1 f8 ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 31                	js     8015b0 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	68 ba 27 80 00       	push   $0x8027ba
  801587:	57                   	push   %edi
  801588:	e8 f7 f9 ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 33                	js     8015c7 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	6a 02                	push   $0x2
  801599:	57                   	push   %edi
  80159a:	e8 61 f9 ff ff       	call   800f00 <sys_env_set_status>
	if(ret < 0)
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 38                	js     8015de <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015a6:	89 f8                	mov    %edi,%eax
  8015a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5e                   	pop    %esi
  8015ad:	5f                   	pop    %edi
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	68 48 30 80 00       	push   $0x803048
  8015b8:	68 c0 00 00 00       	push   $0xc0
  8015bd:	68 29 30 80 00       	push   $0x803029
  8015c2:	e8 2b ec ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	68 bc 30 80 00       	push   $0x8030bc
  8015cf:	68 c3 00 00 00       	push   $0xc3
  8015d4:	68 29 30 80 00       	push   $0x803029
  8015d9:	e8 14 ec ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	68 e4 30 80 00       	push   $0x8030e4
  8015e6:	68 c6 00 00 00       	push   $0xc6
  8015eb:	68 29 30 80 00       	push   $0x803029
  8015f0:	e8 fd eb ff ff       	call   8001f2 <_panic>

008015f5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	05 00 00 00 30       	add    $0x30000000,%eax
  801600:	c1 e8 0c             	shr    $0xc,%eax
}
  801603:	5d                   	pop    %ebp
  801604:	c3                   	ret    

00801605 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801610:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801615:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801624:	89 c2                	mov    %eax,%edx
  801626:	c1 ea 16             	shr    $0x16,%edx
  801629:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801630:	f6 c2 01             	test   $0x1,%dl
  801633:	74 2d                	je     801662 <fd_alloc+0x46>
  801635:	89 c2                	mov    %eax,%edx
  801637:	c1 ea 0c             	shr    $0xc,%edx
  80163a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801641:	f6 c2 01             	test   $0x1,%dl
  801644:	74 1c                	je     801662 <fd_alloc+0x46>
  801646:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80164b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801650:	75 d2                	jne    801624 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80165b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801660:	eb 0a                	jmp    80166c <fd_alloc+0x50>
			*fd_store = fd;
  801662:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801665:	89 01                	mov    %eax,(%ecx)
			return 0;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801674:	83 f8 1f             	cmp    $0x1f,%eax
  801677:	77 30                	ja     8016a9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801679:	c1 e0 0c             	shl    $0xc,%eax
  80167c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801681:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801687:	f6 c2 01             	test   $0x1,%dl
  80168a:	74 24                	je     8016b0 <fd_lookup+0x42>
  80168c:	89 c2                	mov    %eax,%edx
  80168e:	c1 ea 0c             	shr    $0xc,%edx
  801691:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801698:	f6 c2 01             	test   $0x1,%dl
  80169b:	74 1a                	je     8016b7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	89 02                	mov    %eax,(%edx)
	return 0;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
		return -E_INVAL;
  8016a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ae:	eb f7                	jmp    8016a7 <fd_lookup+0x39>
		return -E_INVAL;
  8016b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b5:	eb f0                	jmp    8016a7 <fd_lookup+0x39>
  8016b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016bc:	eb e9                	jmp    8016a7 <fd_lookup+0x39>

008016be <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cc:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016d1:	39 08                	cmp    %ecx,(%eax)
  8016d3:	74 38                	je     80170d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016d5:	83 c2 01             	add    $0x1,%edx
  8016d8:	8b 04 95 80 31 80 00 	mov    0x803180(,%edx,4),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	75 ee                	jne    8016d1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016e3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016e8:	8b 40 48             	mov    0x48(%eax),%eax
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	51                   	push   %ecx
  8016ef:	50                   	push   %eax
  8016f0:	68 04 31 80 00       	push   $0x803104
  8016f5:	e8 ee eb ff ff       	call   8002e8 <cprintf>
	*dev = 0;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
			*dev = devtab[i];
  80170d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801710:	89 01                	mov    %eax,(%ecx)
			return 0;
  801712:	b8 00 00 00 00       	mov    $0x0,%eax
  801717:	eb f2                	jmp    80170b <dev_lookup+0x4d>

00801719 <fd_close>:
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	83 ec 24             	sub    $0x24,%esp
  801722:	8b 75 08             	mov    0x8(%ebp),%esi
  801725:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801728:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80172b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80172c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801732:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801735:	50                   	push   %eax
  801736:	e8 33 ff ff ff       	call   80166e <fd_lookup>
  80173b:	89 c3                	mov    %eax,%ebx
  80173d:	83 c4 10             	add    $0x10,%esp
  801740:	85 c0                	test   %eax,%eax
  801742:	78 05                	js     801749 <fd_close+0x30>
	    || fd != fd2)
  801744:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801747:	74 16                	je     80175f <fd_close+0x46>
		return (must_exist ? r : 0);
  801749:	89 f8                	mov    %edi,%eax
  80174b:	84 c0                	test   %al,%al
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	0f 44 d8             	cmove  %eax,%ebx
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5f                   	pop    %edi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	ff 36                	pushl  (%esi)
  801768:	e8 51 ff ff ff       	call   8016be <dev_lookup>
  80176d:	89 c3                	mov    %eax,%ebx
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 1a                	js     801790 <fd_close+0x77>
		if (dev->dev_close)
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80177c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801781:	85 c0                	test   %eax,%eax
  801783:	74 0b                	je     801790 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	56                   	push   %esi
  801789:	ff d0                	call   *%eax
  80178b:	89 c3                	mov    %eax,%ebx
  80178d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	56                   	push   %esi
  801794:	6a 00                	push   $0x0
  801796:	e8 23 f7 ff ff       	call   800ebe <sys_page_unmap>
	return r;
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb b5                	jmp    801755 <fd_close+0x3c>

008017a0 <close>:

int
close(int fdnum)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a9:	50                   	push   %eax
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 bc fe ff ff       	call   80166e <fd_lookup>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	79 02                	jns    8017bb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
		return fd_close(fd, 1);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	6a 01                	push   $0x1
  8017c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c3:	e8 51 ff ff ff       	call   801719 <fd_close>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	eb ec                	jmp    8017b9 <close+0x19>

008017cd <close_all>:

void
close_all(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	53                   	push   %ebx
  8017dd:	e8 be ff ff ff       	call   8017a0 <close>
	for (i = 0; i < MAXFD; i++)
  8017e2:	83 c3 01             	add    $0x1,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	83 fb 20             	cmp    $0x20,%ebx
  8017eb:	75 ec                	jne    8017d9 <close_all+0xc>
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	57                   	push   %edi
  8017f6:	56                   	push   %esi
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 08             	pushl  0x8(%ebp)
  801802:	e8 67 fe ff ff       	call   80166e <fd_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 88 81 00 00 00    	js     801895 <dup+0xa3>
		return r;
	close(newfdnum);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	e8 81 ff ff ff       	call   8017a0 <close>

	newfd = INDEX2FD(newfdnum);
  80181f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801822:	c1 e6 0c             	shl    $0xc,%esi
  801825:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80182b:	83 c4 04             	add    $0x4,%esp
  80182e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801831:	e8 cf fd ff ff       	call   801605 <fd2data>
  801836:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801838:	89 34 24             	mov    %esi,(%esp)
  80183b:	e8 c5 fd ff ff       	call   801605 <fd2data>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801845:	89 d8                	mov    %ebx,%eax
  801847:	c1 e8 16             	shr    $0x16,%eax
  80184a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801851:	a8 01                	test   $0x1,%al
  801853:	74 11                	je     801866 <dup+0x74>
  801855:	89 d8                	mov    %ebx,%eax
  801857:	c1 e8 0c             	shr    $0xc,%eax
  80185a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801861:	f6 c2 01             	test   $0x1,%dl
  801864:	75 39                	jne    80189f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801869:	89 d0                	mov    %edx,%eax
  80186b:	c1 e8 0c             	shr    $0xc,%eax
  80186e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	25 07 0e 00 00       	and    $0xe07,%eax
  80187d:	50                   	push   %eax
  80187e:	56                   	push   %esi
  80187f:	6a 00                	push   $0x0
  801881:	52                   	push   %edx
  801882:	6a 00                	push   $0x0
  801884:	e8 f3 f5 ff ff       	call   800e7c <sys_page_map>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	83 c4 20             	add    $0x20,%esp
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 31                	js     8018c3 <dup+0xd1>
		goto err;

	return newfdnum;
  801892:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801895:	89 d8                	mov    %ebx,%eax
  801897:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80189f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ae:	50                   	push   %eax
  8018af:	57                   	push   %edi
  8018b0:	6a 00                	push   $0x0
  8018b2:	53                   	push   %ebx
  8018b3:	6a 00                	push   $0x0
  8018b5:	e8 c2 f5 ff ff       	call   800e7c <sys_page_map>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 20             	add    $0x20,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	79 a3                	jns    801866 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	56                   	push   %esi
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 f0 f5 ff ff       	call   800ebe <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018ce:	83 c4 08             	add    $0x8,%esp
  8018d1:	57                   	push   %edi
  8018d2:	6a 00                	push   $0x0
  8018d4:	e8 e5 f5 ff ff       	call   800ebe <sys_page_unmap>
	return r;
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb b7                	jmp    801895 <dup+0xa3>

008018de <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 1c             	sub    $0x1c,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	50                   	push   %eax
  8018ec:	53                   	push   %ebx
  8018ed:	e8 7c fd ff ff       	call   80166e <fd_lookup>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 3f                	js     801938 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ff:	50                   	push   %eax
  801900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801903:	ff 30                	pushl  (%eax)
  801905:	e8 b4 fd ff ff       	call   8016be <dev_lookup>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 27                	js     801938 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801911:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801914:	8b 42 08             	mov    0x8(%edx),%eax
  801917:	83 e0 03             	and    $0x3,%eax
  80191a:	83 f8 01             	cmp    $0x1,%eax
  80191d:	74 1e                	je     80193d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	8b 40 08             	mov    0x8(%eax),%eax
  801925:	85 c0                	test   %eax,%eax
  801927:	74 35                	je     80195e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	52                   	push   %edx
  801933:	ff d0                	call   *%eax
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80193d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801942:	8b 40 48             	mov    0x48(%eax),%eax
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	53                   	push   %ebx
  801949:	50                   	push   %eax
  80194a:	68 45 31 80 00       	push   $0x803145
  80194f:	e8 94 e9 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80195c:	eb da                	jmp    801938 <read+0x5a>
		return -E_NOT_SUPP;
  80195e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801963:	eb d3                	jmp    801938 <read+0x5a>

00801965 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	57                   	push   %edi
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801971:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801974:	bb 00 00 00 00       	mov    $0x0,%ebx
  801979:	39 f3                	cmp    %esi,%ebx
  80197b:	73 23                	jae    8019a0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	89 f0                	mov    %esi,%eax
  801982:	29 d8                	sub    %ebx,%eax
  801984:	50                   	push   %eax
  801985:	89 d8                	mov    %ebx,%eax
  801987:	03 45 0c             	add    0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	57                   	push   %edi
  80198c:	e8 4d ff ff ff       	call   8018de <read>
		if (m < 0)
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 06                	js     80199e <readn+0x39>
			return m;
		if (m == 0)
  801998:	74 06                	je     8019a0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80199a:	01 c3                	add    %eax,%ebx
  80199c:	eb db                	jmp    801979 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80199e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5f                   	pop    %edi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    

008019aa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	53                   	push   %ebx
  8019ae:	83 ec 1c             	sub    $0x1c,%esp
  8019b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b7:	50                   	push   %eax
  8019b8:	53                   	push   %ebx
  8019b9:	e8 b0 fc ff ff       	call   80166e <fd_lookup>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 3a                	js     8019ff <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	50                   	push   %eax
  8019cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cf:	ff 30                	pushl  (%eax)
  8019d1:	e8 e8 fc ff ff       	call   8016be <dev_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 22                	js     8019ff <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019e4:	74 1e                	je     801a04 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ec:	85 d2                	test   %edx,%edx
  8019ee:	74 35                	je     801a25 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	ff d2                	call   *%edx
  8019fc:	83 c4 10             	add    $0x10,%esp
}
  8019ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a04:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a09:	8b 40 48             	mov    0x48(%eax),%eax
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	53                   	push   %ebx
  801a10:	50                   	push   %eax
  801a11:	68 61 31 80 00       	push   $0x803161
  801a16:	e8 cd e8 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a23:	eb da                	jmp    8019ff <write+0x55>
		return -E_NOT_SUPP;
  801a25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a2a:	eb d3                	jmp    8019ff <write+0x55>

00801a2c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a35:	50                   	push   %eax
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	e8 30 fc ff ff       	call   80166e <fd_lookup>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 0e                	js     801a53 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 1c             	sub    $0x1c,%esp
  801a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	53                   	push   %ebx
  801a64:	e8 05 fc ff ff       	call   80166e <fd_lookup>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 37                	js     801aa7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	ff 30                	pushl  (%eax)
  801a7c:	e8 3d fc ff ff       	call   8016be <dev_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 1f                	js     801aa7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8f:	74 1b                	je     801aac <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a94:	8b 52 18             	mov    0x18(%edx),%edx
  801a97:	85 d2                	test   %edx,%edx
  801a99:	74 32                	je     801acd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	ff d2                	call   *%edx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
			thisenv->env_id, fdnum);
  801aac:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	50                   	push   %eax
  801ab9:	68 24 31 80 00       	push   $0x803124
  801abe:	e8 25 e8 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acb:	eb da                	jmp    801aa7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801acd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad2:	eb d3                	jmp    801aa7 <ftruncate+0x52>

00801ad4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 1c             	sub    $0x1c,%esp
  801adb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ade:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	e8 84 fb ff ff       	call   80166e <fd_lookup>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 4b                	js     801b3c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	ff 30                	pushl  (%eax)
  801afd:	e8 bc fb ff ff       	call   8016be <dev_lookup>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 33                	js     801b3c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b10:	74 2f                	je     801b41 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b12:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b15:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b1c:	00 00 00 
	stat->st_isdir = 0;
  801b1f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b26:	00 00 00 
	stat->st_dev = dev;
  801b29:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	53                   	push   %ebx
  801b33:	ff 75 f0             	pushl  -0x10(%ebp)
  801b36:	ff 50 14             	call   *0x14(%eax)
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    
		return -E_NOT_SUPP;
  801b41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b46:	eb f4                	jmp    801b3c <fstat+0x68>

00801b48 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b4d:	83 ec 08             	sub    $0x8,%esp
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	e8 22 02 00 00       	call   801d7c <open>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 1b                	js     801b7e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	e8 65 ff ff ff       	call   801ad4 <fstat>
  801b6f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b71:	89 1c 24             	mov    %ebx,(%esp)
  801b74:	e8 27 fc ff ff       	call   8017a0 <close>
	return r;
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	89 f3                	mov    %esi,%ebx
}
  801b7e:	89 d8                	mov    %ebx,%eax
  801b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    

00801b87 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	89 c6                	mov    %eax,%esi
  801b8e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b90:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b97:	74 27                	je     801bc0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b99:	6a 07                	push   $0x7
  801b9b:	68 00 60 80 00       	push   $0x806000
  801ba0:	56                   	push   %esi
  801ba1:	ff 35 00 50 80 00    	pushl  0x805000
  801ba7:	e8 9d 0c 00 00       	call   802849 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bac:	83 c4 0c             	add    $0xc,%esp
  801baf:	6a 00                	push   $0x0
  801bb1:	53                   	push   %ebx
  801bb2:	6a 00                	push   $0x0
  801bb4:	e8 27 0c 00 00       	call   8027e0 <ipc_recv>
}
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	6a 01                	push   $0x1
  801bc5:	e8 d7 0c 00 00       	call   8028a1 <ipc_find_env>
  801bca:	a3 00 50 80 00       	mov    %eax,0x805000
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	eb c5                	jmp    801b99 <fsipc+0x12>

00801bd4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  801be0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bed:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf2:	b8 02 00 00 00       	mov    $0x2,%eax
  801bf7:	e8 8b ff ff ff       	call   801b87 <fsipc>
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <devfile_flush>:
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c14:	b8 06 00 00 00       	mov    $0x6,%eax
  801c19:	e8 69 ff ff ff       	call   801b87 <fsipc>
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <devfile_stat>:
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c30:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c35:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3f:	e8 43 ff ff ff       	call   801b87 <fsipc>
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 2c                	js     801c74 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	68 00 60 80 00       	push   $0x806000
  801c50:	53                   	push   %ebx
  801c51:	e8 f1 ed ff ff       	call   800a47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c56:	a1 80 60 80 00       	mov    0x806080,%eax
  801c5b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c61:	a1 84 60 80 00       	mov    0x806084,%eax
  801c66:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c6c:	83 c4 10             	add    $0x10,%esp
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <devfile_write>:
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8b 40 0c             	mov    0xc(%eax),%eax
  801c89:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801c8e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801c94:	53                   	push   %ebx
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	68 08 60 80 00       	push   $0x806008
  801c9d:	e8 95 ef ff ff       	call   800c37 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	b8 04 00 00 00       	mov    $0x4,%eax
  801cac:	e8 d6 fe ff ff       	call   801b87 <fsipc>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	78 0b                	js     801cc3 <devfile_write+0x4a>
	assert(r <= n);
  801cb8:	39 d8                	cmp    %ebx,%eax
  801cba:	77 0c                	ja     801cc8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cbc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc1:	7f 1e                	jg     801ce1 <devfile_write+0x68>
}
  801cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    
	assert(r <= n);
  801cc8:	68 94 31 80 00       	push   $0x803194
  801ccd:	68 9b 31 80 00       	push   $0x80319b
  801cd2:	68 98 00 00 00       	push   $0x98
  801cd7:	68 b0 31 80 00       	push   $0x8031b0
  801cdc:	e8 11 e5 ff ff       	call   8001f2 <_panic>
	assert(r <= PGSIZE);
  801ce1:	68 bb 31 80 00       	push   $0x8031bb
  801ce6:	68 9b 31 80 00       	push   $0x80319b
  801ceb:	68 99 00 00 00       	push   $0x99
  801cf0:	68 b0 31 80 00       	push   $0x8031b0
  801cf5:	e8 f8 e4 ff ff       	call   8001f2 <_panic>

00801cfa <devfile_read>:
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	56                   	push   %esi
  801cfe:	53                   	push   %ebx
  801cff:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d0d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d13:	ba 00 00 00 00       	mov    $0x0,%edx
  801d18:	b8 03 00 00 00       	mov    $0x3,%eax
  801d1d:	e8 65 fe ff ff       	call   801b87 <fsipc>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	85 c0                	test   %eax,%eax
  801d26:	78 1f                	js     801d47 <devfile_read+0x4d>
	assert(r <= n);
  801d28:	39 f0                	cmp    %esi,%eax
  801d2a:	77 24                	ja     801d50 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d2c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d31:	7f 33                	jg     801d66 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d33:	83 ec 04             	sub    $0x4,%esp
  801d36:	50                   	push   %eax
  801d37:	68 00 60 80 00       	push   $0x806000
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	e8 91 ee ff ff       	call   800bd5 <memmove>
	return r;
  801d44:	83 c4 10             	add    $0x10,%esp
}
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4c:	5b                   	pop    %ebx
  801d4d:	5e                   	pop    %esi
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    
	assert(r <= n);
  801d50:	68 94 31 80 00       	push   $0x803194
  801d55:	68 9b 31 80 00       	push   $0x80319b
  801d5a:	6a 7c                	push   $0x7c
  801d5c:	68 b0 31 80 00       	push   $0x8031b0
  801d61:	e8 8c e4 ff ff       	call   8001f2 <_panic>
	assert(r <= PGSIZE);
  801d66:	68 bb 31 80 00       	push   $0x8031bb
  801d6b:	68 9b 31 80 00       	push   $0x80319b
  801d70:	6a 7d                	push   $0x7d
  801d72:	68 b0 31 80 00       	push   $0x8031b0
  801d77:	e8 76 e4 ff ff       	call   8001f2 <_panic>

00801d7c <open>:
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	56                   	push   %esi
  801d80:	53                   	push   %ebx
  801d81:	83 ec 1c             	sub    $0x1c,%esp
  801d84:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d87:	56                   	push   %esi
  801d88:	e8 81 ec ff ff       	call   800a0e <strlen>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d95:	7f 6c                	jg     801e03 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d97:	83 ec 0c             	sub    $0xc,%esp
  801d9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9d:	50                   	push   %eax
  801d9e:	e8 79 f8 ff ff       	call   80161c <fd_alloc>
  801da3:	89 c3                	mov    %eax,%ebx
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 3c                	js     801de8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dac:	83 ec 08             	sub    $0x8,%esp
  801daf:	56                   	push   %esi
  801db0:	68 00 60 80 00       	push   $0x806000
  801db5:	e8 8d ec ff ff       	call   800a47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dca:	e8 b8 fd ff ff       	call   801b87 <fsipc>
  801dcf:	89 c3                	mov    %eax,%ebx
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 19                	js     801df1 <open+0x75>
	return fd2num(fd);
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dde:	e8 12 f8 ff ff       	call   8015f5 <fd2num>
  801de3:	89 c3                	mov    %eax,%ebx
  801de5:	83 c4 10             	add    $0x10,%esp
}
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
		fd_close(fd, 0);
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 f4             	pushl  -0xc(%ebp)
  801df9:	e8 1b f9 ff ff       	call   801719 <fd_close>
		return r;
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	eb e5                	jmp    801de8 <open+0x6c>
		return -E_BAD_PATH;
  801e03:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e08:	eb de                	jmp    801de8 <open+0x6c>

00801e0a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e10:	ba 00 00 00 00       	mov    $0x0,%edx
  801e15:	b8 08 00 00 00       	mov    $0x8,%eax
  801e1a:	e8 68 fd ff ff       	call   801b87 <fsipc>
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e27:	68 c7 31 80 00       	push   $0x8031c7
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	e8 13 ec ff ff       	call   800a47 <strcpy>
	return 0;
}
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devsock_close>:
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	53                   	push   %ebx
  801e3f:	83 ec 10             	sub    $0x10,%esp
  801e42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e45:	53                   	push   %ebx
  801e46:	e8 91 0a 00 00       	call   8028dc <pageref>
  801e4b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e4e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e53:	83 f8 01             	cmp    $0x1,%eax
  801e56:	74 07                	je     801e5f <devsock_close+0x24>
}
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	ff 73 0c             	pushl  0xc(%ebx)
  801e65:	e8 b9 02 00 00       	call   802123 <nsipc_close>
  801e6a:	89 c2                	mov    %eax,%edx
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	eb e7                	jmp    801e58 <devsock_close+0x1d>

00801e71 <devsock_write>:
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 10             	pushl  0x10(%ebp)
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	ff 70 0c             	pushl  0xc(%eax)
  801e85:	e8 76 03 00 00       	call   802200 <nsipc_send>
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <devsock_read>:
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	ff 70 0c             	pushl  0xc(%eax)
  801ea0:	e8 ef 02 00 00       	call   802194 <nsipc_recv>
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <fd2sockid>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ead:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	e8 b7 f7 ff ff       	call   80166e <fd_lookup>
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 10                	js     801ece <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ec7:	39 08                	cmp    %ecx,(%eax)
  801ec9:	75 05                	jne    801ed0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ecb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    
		return -E_NOT_SUPP;
  801ed0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ed5:	eb f7                	jmp    801ece <fd2sockid+0x27>

00801ed7 <alloc_sockfd>:
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	83 ec 1c             	sub    $0x1c,%esp
  801edf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ee1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee4:	50                   	push   %eax
  801ee5:	e8 32 f7 ff ff       	call   80161c <fd_alloc>
  801eea:	89 c3                	mov    %eax,%ebx
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 43                	js     801f36 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	68 07 04 00 00       	push   $0x407
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	6a 00                	push   $0x0
  801f00:	e8 34 ef ff ff       	call   800e39 <sys_page_alloc>
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 28                	js     801f36 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f17:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f23:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	50                   	push   %eax
  801f2a:	e8 c6 f6 ff ff       	call   8015f5 <fd2num>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	eb 0c                	jmp    801f42 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	56                   	push   %esi
  801f3a:	e8 e4 01 00 00       	call   802123 <nsipc_close>
		return r;
  801f3f:	83 c4 10             	add    $0x10,%esp
}
  801f42:	89 d8                	mov    %ebx,%eax
  801f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <accept>:
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	e8 4e ff ff ff       	call   801ea7 <fd2sockid>
  801f59:	85 c0                	test   %eax,%eax
  801f5b:	78 1b                	js     801f78 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	ff 75 10             	pushl  0x10(%ebp)
  801f63:	ff 75 0c             	pushl  0xc(%ebp)
  801f66:	50                   	push   %eax
  801f67:	e8 0e 01 00 00       	call   80207a <nsipc_accept>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 05                	js     801f78 <accept+0x2d>
	return alloc_sockfd(r);
  801f73:	e8 5f ff ff ff       	call   801ed7 <alloc_sockfd>
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <bind>:
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	e8 1f ff ff ff       	call   801ea7 <fd2sockid>
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	78 12                	js     801f9e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	ff 75 10             	pushl  0x10(%ebp)
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	50                   	push   %eax
  801f96:	e8 31 01 00 00       	call   8020cc <nsipc_bind>
  801f9b:	83 c4 10             	add    $0x10,%esp
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <shutdown>:
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	e8 f9 fe ff ff       	call   801ea7 <fd2sockid>
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 0f                	js     801fc1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	50                   	push   %eax
  801fb9:	e8 43 01 00 00       	call   802101 <nsipc_shutdown>
  801fbe:	83 c4 10             	add    $0x10,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <connect>:
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	e8 d6 fe ff ff       	call   801ea7 <fd2sockid>
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 12                	js     801fe7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	ff 75 10             	pushl  0x10(%ebp)
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	50                   	push   %eax
  801fdf:	e8 59 01 00 00       	call   80213d <nsipc_connect>
  801fe4:	83 c4 10             	add    $0x10,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <listen>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	e8 b0 fe ff ff       	call   801ea7 <fd2sockid>
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 0f                	js     80200a <listen+0x21>
	return nsipc_listen(r, backlog);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	50                   	push   %eax
  802002:	e8 6b 01 00 00       	call   802172 <nsipc_listen>
  802007:	83 c4 10             	add    $0x10,%esp
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <socket>:

int
socket(int domain, int type, int protocol)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802012:	ff 75 10             	pushl  0x10(%ebp)
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	e8 3e 02 00 00       	call   80225e <nsipc_socket>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	78 05                	js     80202c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802027:	e8 ab fe ff ff       	call   801ed7 <alloc_sockfd>
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	53                   	push   %ebx
  802032:	83 ec 04             	sub    $0x4,%esp
  802035:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802037:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80203e:	74 26                	je     802066 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802040:	6a 07                	push   $0x7
  802042:	68 00 70 80 00       	push   $0x807000
  802047:	53                   	push   %ebx
  802048:	ff 35 04 50 80 00    	pushl  0x805004
  80204e:	e8 f6 07 00 00       	call   802849 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802053:	83 c4 0c             	add    $0xc,%esp
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	e8 7f 07 00 00       	call   8027e0 <ipc_recv>
}
  802061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802064:	c9                   	leave  
  802065:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	6a 02                	push   $0x2
  80206b:	e8 31 08 00 00       	call   8028a1 <ipc_find_env>
  802070:	a3 04 50 80 00       	mov    %eax,0x805004
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	eb c6                	jmp    802040 <nsipc+0x12>

0080207a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	56                   	push   %esi
  80207e:	53                   	push   %ebx
  80207f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80208a:	8b 06                	mov    (%esi),%eax
  80208c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	e8 93 ff ff ff       	call   80202e <nsipc>
  80209b:	89 c3                	mov    %eax,%ebx
  80209d:	85 c0                	test   %eax,%eax
  80209f:	79 09                	jns    8020aa <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020a1:	89 d8                	mov    %ebx,%eax
  8020a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5e                   	pop    %esi
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	ff 35 10 70 80 00    	pushl  0x807010
  8020b3:	68 00 70 80 00       	push   $0x807000
  8020b8:	ff 75 0c             	pushl  0xc(%ebp)
  8020bb:	e8 15 eb ff ff       	call   800bd5 <memmove>
		*addrlen = ret->ret_addrlen;
  8020c0:	a1 10 70 80 00       	mov    0x807010,%eax
  8020c5:	89 06                	mov    %eax,(%esi)
  8020c7:	83 c4 10             	add    $0x10,%esp
	return r;
  8020ca:	eb d5                	jmp    8020a1 <nsipc_accept+0x27>

008020cc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 08             	sub    $0x8,%esp
  8020d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020de:	53                   	push   %ebx
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	68 04 70 80 00       	push   $0x807004
  8020e7:	e8 e9 ea ff ff       	call   800bd5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020ec:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8020f7:	e8 32 ff ff ff       	call   80202e <nsipc>
}
  8020fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80210f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802112:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802117:	b8 03 00 00 00       	mov    $0x3,%eax
  80211c:	e8 0d ff ff ff       	call   80202e <nsipc>
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <nsipc_close>:

int
nsipc_close(int s)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802131:	b8 04 00 00 00       	mov    $0x4,%eax
  802136:	e8 f3 fe ff ff       	call   80202e <nsipc>
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	53                   	push   %ebx
  802141:	83 ec 08             	sub    $0x8,%esp
  802144:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80214f:	53                   	push   %ebx
  802150:	ff 75 0c             	pushl  0xc(%ebp)
  802153:	68 04 70 80 00       	push   $0x807004
  802158:	e8 78 ea ff ff       	call   800bd5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80215d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802163:	b8 05 00 00 00       	mov    $0x5,%eax
  802168:	e8 c1 fe ff ff       	call   80202e <nsipc>
}
  80216d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802188:	b8 06 00 00 00       	mov    $0x6,%eax
  80218d:	e8 9c fe ff ff       	call   80202e <nsipc>
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	56                   	push   %esi
  802198:	53                   	push   %ebx
  802199:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021a4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ad:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021b2:	b8 07 00 00 00       	mov    $0x7,%eax
  8021b7:	e8 72 fe ff ff       	call   80202e <nsipc>
  8021bc:	89 c3                	mov    %eax,%ebx
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 1f                	js     8021e1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021c2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021c7:	7f 21                	jg     8021ea <nsipc_recv+0x56>
  8021c9:	39 c6                	cmp    %eax,%esi
  8021cb:	7c 1d                	jl     8021ea <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	50                   	push   %eax
  8021d1:	68 00 70 80 00       	push   $0x807000
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	e8 f7 e9 ff ff       	call   800bd5 <memmove>
  8021de:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021e1:	89 d8                	mov    %ebx,%eax
  8021e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021ea:	68 d3 31 80 00       	push   $0x8031d3
  8021ef:	68 9b 31 80 00       	push   $0x80319b
  8021f4:	6a 62                	push   $0x62
  8021f6:	68 e8 31 80 00       	push   $0x8031e8
  8021fb:	e8 f2 df ff ff       	call   8001f2 <_panic>

00802200 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	53                   	push   %ebx
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802212:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802218:	7f 2e                	jg     802248 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	53                   	push   %ebx
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	68 0c 70 80 00       	push   $0x80700c
  802226:	e8 aa e9 ff ff       	call   800bd5 <memmove>
	nsipcbuf.send.req_size = size;
  80222b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802231:	8b 45 14             	mov    0x14(%ebp),%eax
  802234:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802239:	b8 08 00 00 00       	mov    $0x8,%eax
  80223e:	e8 eb fd ff ff       	call   80202e <nsipc>
}
  802243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802246:	c9                   	leave  
  802247:	c3                   	ret    
	assert(size < 1600);
  802248:	68 f4 31 80 00       	push   $0x8031f4
  80224d:	68 9b 31 80 00       	push   $0x80319b
  802252:	6a 6d                	push   $0x6d
  802254:	68 e8 31 80 00       	push   $0x8031e8
  802259:	e8 94 df ff ff       	call   8001f2 <_panic>

0080225e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802274:	8b 45 10             	mov    0x10(%ebp),%eax
  802277:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80227c:	b8 09 00 00 00       	mov    $0x9,%eax
  802281:	e8 a8 fd ff ff       	call   80202e <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	ff 75 08             	pushl  0x8(%ebp)
  802296:	e8 6a f3 ff ff       	call   801605 <fd2data>
  80229b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80229d:	83 c4 08             	add    $0x8,%esp
  8022a0:	68 00 32 80 00       	push   $0x803200
  8022a5:	53                   	push   %ebx
  8022a6:	e8 9c e7 ff ff       	call   800a47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022ab:	8b 46 04             	mov    0x4(%esi),%eax
  8022ae:	2b 06                	sub    (%esi),%eax
  8022b0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022bd:	00 00 00 
	stat->st_dev = &devpipe;
  8022c0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022c7:	40 80 00 
	return 0;
}
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d2:	5b                   	pop    %ebx
  8022d3:	5e                   	pop    %esi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 0c             	sub    $0xc,%esp
  8022dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022e0:	53                   	push   %ebx
  8022e1:	6a 00                	push   $0x0
  8022e3:	e8 d6 eb ff ff       	call   800ebe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022e8:	89 1c 24             	mov    %ebx,(%esp)
  8022eb:	e8 15 f3 ff ff       	call   801605 <fd2data>
  8022f0:	83 c4 08             	add    $0x8,%esp
  8022f3:	50                   	push   %eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	e8 c3 eb ff ff       	call   800ebe <sys_page_unmap>
}
  8022fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <_pipeisclosed>:
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	57                   	push   %edi
  802304:	56                   	push   %esi
  802305:	53                   	push   %ebx
  802306:	83 ec 1c             	sub    $0x1c,%esp
  802309:	89 c7                	mov    %eax,%edi
  80230b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80230d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802312:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	57                   	push   %edi
  802319:	e8 be 05 00 00       	call   8028dc <pageref>
  80231e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802321:	89 34 24             	mov    %esi,(%esp)
  802324:	e8 b3 05 00 00       	call   8028dc <pageref>
		nn = thisenv->env_runs;
  802329:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80232f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802332:	83 c4 10             	add    $0x10,%esp
  802335:	39 cb                	cmp    %ecx,%ebx
  802337:	74 1b                	je     802354 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802339:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80233c:	75 cf                	jne    80230d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80233e:	8b 42 58             	mov    0x58(%edx),%eax
  802341:	6a 01                	push   $0x1
  802343:	50                   	push   %eax
  802344:	53                   	push   %ebx
  802345:	68 07 32 80 00       	push   $0x803207
  80234a:	e8 99 df ff ff       	call   8002e8 <cprintf>
  80234f:	83 c4 10             	add    $0x10,%esp
  802352:	eb b9                	jmp    80230d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802354:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802357:	0f 94 c0             	sete   %al
  80235a:	0f b6 c0             	movzbl %al,%eax
}
  80235d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    

00802365 <devpipe_write>:
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	57                   	push   %edi
  802369:	56                   	push   %esi
  80236a:	53                   	push   %ebx
  80236b:	83 ec 28             	sub    $0x28,%esp
  80236e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802371:	56                   	push   %esi
  802372:	e8 8e f2 ff ff       	call   801605 <fd2data>
  802377:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802379:	83 c4 10             	add    $0x10,%esp
  80237c:	bf 00 00 00 00       	mov    $0x0,%edi
  802381:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802384:	74 4f                	je     8023d5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802386:	8b 43 04             	mov    0x4(%ebx),%eax
  802389:	8b 0b                	mov    (%ebx),%ecx
  80238b:	8d 51 20             	lea    0x20(%ecx),%edx
  80238e:	39 d0                	cmp    %edx,%eax
  802390:	72 14                	jb     8023a6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802392:	89 da                	mov    %ebx,%edx
  802394:	89 f0                	mov    %esi,%eax
  802396:	e8 65 ff ff ff       	call   802300 <_pipeisclosed>
  80239b:	85 c0                	test   %eax,%eax
  80239d:	75 3b                	jne    8023da <devpipe_write+0x75>
			sys_yield();
  80239f:	e8 76 ea ff ff       	call   800e1a <sys_yield>
  8023a4:	eb e0                	jmp    802386 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023a9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023ad:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023b0:	89 c2                	mov    %eax,%edx
  8023b2:	c1 fa 1f             	sar    $0x1f,%edx
  8023b5:	89 d1                	mov    %edx,%ecx
  8023b7:	c1 e9 1b             	shr    $0x1b,%ecx
  8023ba:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023bd:	83 e2 1f             	and    $0x1f,%edx
  8023c0:	29 ca                	sub    %ecx,%edx
  8023c2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023ca:	83 c0 01             	add    $0x1,%eax
  8023cd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023d0:	83 c7 01             	add    $0x1,%edi
  8023d3:	eb ac                	jmp    802381 <devpipe_write+0x1c>
	return i;
  8023d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d8:	eb 05                	jmp    8023df <devpipe_write+0x7a>
				return 0;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023e2:	5b                   	pop    %ebx
  8023e3:	5e                   	pop    %esi
  8023e4:	5f                   	pop    %edi
  8023e5:	5d                   	pop    %ebp
  8023e6:	c3                   	ret    

008023e7 <devpipe_read>:
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	57                   	push   %edi
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 18             	sub    $0x18,%esp
  8023f0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023f3:	57                   	push   %edi
  8023f4:	e8 0c f2 ff ff       	call   801605 <fd2data>
  8023f9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	be 00 00 00 00       	mov    $0x0,%esi
  802403:	3b 75 10             	cmp    0x10(%ebp),%esi
  802406:	75 14                	jne    80241c <devpipe_read+0x35>
	return i;
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	eb 02                	jmp    80240f <devpipe_read+0x28>
				return i;
  80240d:	89 f0                	mov    %esi,%eax
}
  80240f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802412:	5b                   	pop    %ebx
  802413:	5e                   	pop    %esi
  802414:	5f                   	pop    %edi
  802415:	5d                   	pop    %ebp
  802416:	c3                   	ret    
			sys_yield();
  802417:	e8 fe e9 ff ff       	call   800e1a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80241c:	8b 03                	mov    (%ebx),%eax
  80241e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802421:	75 18                	jne    80243b <devpipe_read+0x54>
			if (i > 0)
  802423:	85 f6                	test   %esi,%esi
  802425:	75 e6                	jne    80240d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802427:	89 da                	mov    %ebx,%edx
  802429:	89 f8                	mov    %edi,%eax
  80242b:	e8 d0 fe ff ff       	call   802300 <_pipeisclosed>
  802430:	85 c0                	test   %eax,%eax
  802432:	74 e3                	je     802417 <devpipe_read+0x30>
				return 0;
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	eb d4                	jmp    80240f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80243b:	99                   	cltd   
  80243c:	c1 ea 1b             	shr    $0x1b,%edx
  80243f:	01 d0                	add    %edx,%eax
  802441:	83 e0 1f             	and    $0x1f,%eax
  802444:	29 d0                	sub    %edx,%eax
  802446:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80244b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802451:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802454:	83 c6 01             	add    $0x1,%esi
  802457:	eb aa                	jmp    802403 <devpipe_read+0x1c>

00802459 <pipe>:
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	56                   	push   %esi
  80245d:	53                   	push   %ebx
  80245e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802461:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802464:	50                   	push   %eax
  802465:	e8 b2 f1 ff ff       	call   80161c <fd_alloc>
  80246a:	89 c3                	mov    %eax,%ebx
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	85 c0                	test   %eax,%eax
  802471:	0f 88 23 01 00 00    	js     80259a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	68 07 04 00 00       	push   $0x407
  80247f:	ff 75 f4             	pushl  -0xc(%ebp)
  802482:	6a 00                	push   $0x0
  802484:	e8 b0 e9 ff ff       	call   800e39 <sys_page_alloc>
  802489:	89 c3                	mov    %eax,%ebx
  80248b:	83 c4 10             	add    $0x10,%esp
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 88 04 01 00 00    	js     80259a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80249c:	50                   	push   %eax
  80249d:	e8 7a f1 ff ff       	call   80161c <fd_alloc>
  8024a2:	89 c3                	mov    %eax,%ebx
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	0f 88 db 00 00 00    	js     80258a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	68 07 04 00 00       	push   $0x407
  8024b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ba:	6a 00                	push   $0x0
  8024bc:	e8 78 e9 ff ff       	call   800e39 <sys_page_alloc>
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	83 c4 10             	add    $0x10,%esp
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	0f 88 bc 00 00 00    	js     80258a <pipe+0x131>
	va = fd2data(fd0);
  8024ce:	83 ec 0c             	sub    $0xc,%esp
  8024d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d4:	e8 2c f1 ff ff       	call   801605 <fd2data>
  8024d9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024db:	83 c4 0c             	add    $0xc,%esp
  8024de:	68 07 04 00 00       	push   $0x407
  8024e3:	50                   	push   %eax
  8024e4:	6a 00                	push   $0x0
  8024e6:	e8 4e e9 ff ff       	call   800e39 <sys_page_alloc>
  8024eb:	89 c3                	mov    %eax,%ebx
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 88 82 00 00 00    	js     80257a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f8:	83 ec 0c             	sub    $0xc,%esp
  8024fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8024fe:	e8 02 f1 ff ff       	call   801605 <fd2data>
  802503:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80250a:	50                   	push   %eax
  80250b:	6a 00                	push   $0x0
  80250d:	56                   	push   %esi
  80250e:	6a 00                	push   $0x0
  802510:	e8 67 e9 ff ff       	call   800e7c <sys_page_map>
  802515:	89 c3                	mov    %eax,%ebx
  802517:	83 c4 20             	add    $0x20,%esp
  80251a:	85 c0                	test   %eax,%eax
  80251c:	78 4e                	js     80256c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80251e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802526:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	ff 75 f4             	pushl  -0xc(%ebp)
  802547:	e8 a9 f0 ff ff       	call   8015f5 <fd2num>
  80254c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802551:	83 c4 04             	add    $0x4,%esp
  802554:	ff 75 f0             	pushl  -0x10(%ebp)
  802557:	e8 99 f0 ff ff       	call   8015f5 <fd2num>
  80255c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	bb 00 00 00 00       	mov    $0x0,%ebx
  80256a:	eb 2e                	jmp    80259a <pipe+0x141>
	sys_page_unmap(0, va);
  80256c:	83 ec 08             	sub    $0x8,%esp
  80256f:	56                   	push   %esi
  802570:	6a 00                	push   $0x0
  802572:	e8 47 e9 ff ff       	call   800ebe <sys_page_unmap>
  802577:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80257a:	83 ec 08             	sub    $0x8,%esp
  80257d:	ff 75 f0             	pushl  -0x10(%ebp)
  802580:	6a 00                	push   $0x0
  802582:	e8 37 e9 ff ff       	call   800ebe <sys_page_unmap>
  802587:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80258a:	83 ec 08             	sub    $0x8,%esp
  80258d:	ff 75 f4             	pushl  -0xc(%ebp)
  802590:	6a 00                	push   $0x0
  802592:	e8 27 e9 ff ff       	call   800ebe <sys_page_unmap>
  802597:	83 c4 10             	add    $0x10,%esp
}
  80259a:	89 d8                	mov    %ebx,%eax
  80259c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5d                   	pop    %ebp
  8025a2:	c3                   	ret    

008025a3 <pipeisclosed>:
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
  8025a6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ac:	50                   	push   %eax
  8025ad:	ff 75 08             	pushl  0x8(%ebp)
  8025b0:	e8 b9 f0 ff ff       	call   80166e <fd_lookup>
  8025b5:	83 c4 10             	add    $0x10,%esp
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	78 18                	js     8025d4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025bc:	83 ec 0c             	sub    $0xc,%esp
  8025bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c2:	e8 3e f0 ff ff       	call   801605 <fd2data>
	return _pipeisclosed(fd, p);
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	e8 2f fd ff ff       	call   802300 <_pipeisclosed>
  8025d1:	83 c4 10             	add    $0x10,%esp
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	c3                   	ret    

008025dc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025e2:	68 1f 32 80 00       	push   $0x80321f
  8025e7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ea:	e8 58 e4 ff ff       	call   800a47 <strcpy>
	return 0;
}
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <devcons_write>:
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	57                   	push   %edi
  8025fa:	56                   	push   %esi
  8025fb:	53                   	push   %ebx
  8025fc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802602:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802607:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80260d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802610:	73 31                	jae    802643 <devcons_write+0x4d>
		m = n - tot;
  802612:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802615:	29 f3                	sub    %esi,%ebx
  802617:	83 fb 7f             	cmp    $0x7f,%ebx
  80261a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80261f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	53                   	push   %ebx
  802626:	89 f0                	mov    %esi,%eax
  802628:	03 45 0c             	add    0xc(%ebp),%eax
  80262b:	50                   	push   %eax
  80262c:	57                   	push   %edi
  80262d:	e8 a3 e5 ff ff       	call   800bd5 <memmove>
		sys_cputs(buf, m);
  802632:	83 c4 08             	add    $0x8,%esp
  802635:	53                   	push   %ebx
  802636:	57                   	push   %edi
  802637:	e8 41 e7 ff ff       	call   800d7d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80263c:	01 de                	add    %ebx,%esi
  80263e:	83 c4 10             	add    $0x10,%esp
  802641:	eb ca                	jmp    80260d <devcons_write+0x17>
}
  802643:	89 f0                	mov    %esi,%eax
  802645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802648:	5b                   	pop    %ebx
  802649:	5e                   	pop    %esi
  80264a:	5f                   	pop    %edi
  80264b:	5d                   	pop    %ebp
  80264c:	c3                   	ret    

0080264d <devcons_read>:
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 08             	sub    $0x8,%esp
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80265c:	74 21                	je     80267f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80265e:	e8 38 e7 ff ff       	call   800d9b <sys_cgetc>
  802663:	85 c0                	test   %eax,%eax
  802665:	75 07                	jne    80266e <devcons_read+0x21>
		sys_yield();
  802667:	e8 ae e7 ff ff       	call   800e1a <sys_yield>
  80266c:	eb f0                	jmp    80265e <devcons_read+0x11>
	if (c < 0)
  80266e:	78 0f                	js     80267f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802670:	83 f8 04             	cmp    $0x4,%eax
  802673:	74 0c                	je     802681 <devcons_read+0x34>
	*(char*)vbuf = c;
  802675:	8b 55 0c             	mov    0xc(%ebp),%edx
  802678:	88 02                	mov    %al,(%edx)
	return 1;
  80267a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    
		return 0;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
  802686:	eb f7                	jmp    80267f <devcons_read+0x32>

00802688 <cputchar>:
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802694:	6a 01                	push   $0x1
  802696:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802699:	50                   	push   %eax
  80269a:	e8 de e6 ff ff       	call   800d7d <sys_cputs>
}
  80269f:	83 c4 10             	add    $0x10,%esp
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <getchar>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026aa:	6a 01                	push   $0x1
  8026ac:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026af:	50                   	push   %eax
  8026b0:	6a 00                	push   $0x0
  8026b2:	e8 27 f2 ff ff       	call   8018de <read>
	if (r < 0)
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	78 06                	js     8026c4 <getchar+0x20>
	if (r < 1)
  8026be:	74 06                	je     8026c6 <getchar+0x22>
	return c;
  8026c0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    
		return -E_EOF;
  8026c6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026cb:	eb f7                	jmp    8026c4 <getchar+0x20>

008026cd <iscons>:
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d6:	50                   	push   %eax
  8026d7:	ff 75 08             	pushl  0x8(%ebp)
  8026da:	e8 8f ef ff ff       	call   80166e <fd_lookup>
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	78 11                	js     8026f7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026ef:	39 10                	cmp    %edx,(%eax)
  8026f1:	0f 94 c0             	sete   %al
  8026f4:	0f b6 c0             	movzbl %al,%eax
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <opencons>:
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
  8026fc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802702:	50                   	push   %eax
  802703:	e8 14 ef ff ff       	call   80161c <fd_alloc>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	85 c0                	test   %eax,%eax
  80270d:	78 3a                	js     802749 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	68 07 04 00 00       	push   $0x407
  802717:	ff 75 f4             	pushl  -0xc(%ebp)
  80271a:	6a 00                	push   $0x0
  80271c:	e8 18 e7 ff ff       	call   800e39 <sys_page_alloc>
  802721:	83 c4 10             	add    $0x10,%esp
  802724:	85 c0                	test   %eax,%eax
  802726:	78 21                	js     802749 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802731:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	50                   	push   %eax
  802741:	e8 af ee ff ff       	call   8015f5 <fd2num>
  802746:	83 c4 10             	add    $0x10,%esp
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802751:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802758:	74 0a                	je     802764 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802762:	c9                   	leave  
  802763:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802764:	83 ec 04             	sub    $0x4,%esp
  802767:	6a 07                	push   $0x7
  802769:	68 00 f0 bf ee       	push   $0xeebff000
  80276e:	6a 00                	push   $0x0
  802770:	e8 c4 e6 ff ff       	call   800e39 <sys_page_alloc>
		if(r < 0)
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	85 c0                	test   %eax,%eax
  80277a:	78 2a                	js     8027a6 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80277c:	83 ec 08             	sub    $0x8,%esp
  80277f:	68 ba 27 80 00       	push   $0x8027ba
  802784:	6a 00                	push   $0x0
  802786:	e8 f9 e7 ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80278b:	83 c4 10             	add    $0x10,%esp
  80278e:	85 c0                	test   %eax,%eax
  802790:	79 c8                	jns    80275a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802792:	83 ec 04             	sub    $0x4,%esp
  802795:	68 5c 32 80 00       	push   $0x80325c
  80279a:	6a 25                	push   $0x25
  80279c:	68 98 32 80 00       	push   $0x803298
  8027a1:	e8 4c da ff ff       	call   8001f2 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027a6:	83 ec 04             	sub    $0x4,%esp
  8027a9:	68 2c 32 80 00       	push   $0x80322c
  8027ae:	6a 22                	push   $0x22
  8027b0:	68 98 32 80 00       	push   $0x803298
  8027b5:	e8 38 da ff ff       	call   8001f2 <_panic>

008027ba <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027ba:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027bb:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027c0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027c2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027c5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027c9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027cd:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027d0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027d2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027d6:	83 c4 08             	add    $0x8,%esp
	popal
  8027d9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027da:	83 c4 04             	add    $0x4,%esp
	popfl
  8027dd:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027de:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027df:	c3                   	ret    

008027e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	56                   	push   %esi
  8027e4:	53                   	push   %ebx
  8027e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8027e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8027ee:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8027f0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8027f5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8027f8:	83 ec 0c             	sub    $0xc,%esp
  8027fb:	50                   	push   %eax
  8027fc:	e8 e8 e7 ff ff       	call   800fe9 <sys_ipc_recv>
	if(ret < 0){
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	85 c0                	test   %eax,%eax
  802806:	78 2b                	js     802833 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802808:	85 f6                	test   %esi,%esi
  80280a:	74 0a                	je     802816 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80280c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802811:	8b 40 74             	mov    0x74(%eax),%eax
  802814:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802816:	85 db                	test   %ebx,%ebx
  802818:	74 0a                	je     802824 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80281a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80281f:	8b 40 78             	mov    0x78(%eax),%eax
  802822:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802824:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802829:	8b 40 70             	mov    0x70(%eax),%eax
}
  80282c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80282f:	5b                   	pop    %ebx
  802830:	5e                   	pop    %esi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    
		if(from_env_store)
  802833:	85 f6                	test   %esi,%esi
  802835:	74 06                	je     80283d <ipc_recv+0x5d>
			*from_env_store = 0;
  802837:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80283d:	85 db                	test   %ebx,%ebx
  80283f:	74 eb                	je     80282c <ipc_recv+0x4c>
			*perm_store = 0;
  802841:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802847:	eb e3                	jmp    80282c <ipc_recv+0x4c>

00802849 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	57                   	push   %edi
  80284d:	56                   	push   %esi
  80284e:	53                   	push   %ebx
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	8b 7d 08             	mov    0x8(%ebp),%edi
  802855:	8b 75 0c             	mov    0xc(%ebp),%esi
  802858:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80285b:	85 db                	test   %ebx,%ebx
  80285d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802862:	0f 44 d8             	cmove  %eax,%ebx
  802865:	eb 05                	jmp    80286c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802867:	e8 ae e5 ff ff       	call   800e1a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80286c:	ff 75 14             	pushl  0x14(%ebp)
  80286f:	53                   	push   %ebx
  802870:	56                   	push   %esi
  802871:	57                   	push   %edi
  802872:	e8 4f e7 ff ff       	call   800fc6 <sys_ipc_try_send>
  802877:	83 c4 10             	add    $0x10,%esp
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 1b                	je     802899 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80287e:	79 e7                	jns    802867 <ipc_send+0x1e>
  802880:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802883:	74 e2                	je     802867 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	68 a6 32 80 00       	push   $0x8032a6
  80288d:	6a 4a                	push   $0x4a
  80288f:	68 bb 32 80 00       	push   $0x8032bb
  802894:	e8 59 d9 ff ff       	call   8001f2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802899:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80289c:	5b                   	pop    %ebx
  80289d:	5e                   	pop    %esi
  80289e:	5f                   	pop    %edi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    

008028a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028ac:	89 c2                	mov    %eax,%edx
  8028ae:	c1 e2 07             	shl    $0x7,%edx
  8028b1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028b7:	8b 52 50             	mov    0x50(%edx),%edx
  8028ba:	39 ca                	cmp    %ecx,%edx
  8028bc:	74 11                	je     8028cf <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028be:	83 c0 01             	add    $0x1,%eax
  8028c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028c6:	75 e4                	jne    8028ac <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cd:	eb 0b                	jmp    8028da <ipc_find_env+0x39>
			return envs[i].env_id;
  8028cf:	c1 e0 07             	shl    $0x7,%eax
  8028d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028d7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028da:	5d                   	pop    %ebp
  8028db:	c3                   	ret    

008028dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028dc:	55                   	push   %ebp
  8028dd:	89 e5                	mov    %esp,%ebp
  8028df:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028e2:	89 d0                	mov    %edx,%eax
  8028e4:	c1 e8 16             	shr    $0x16,%eax
  8028e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028f3:	f6 c1 01             	test   $0x1,%cl
  8028f6:	74 1d                	je     802915 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028f8:	c1 ea 0c             	shr    $0xc,%edx
  8028fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802902:	f6 c2 01             	test   $0x1,%dl
  802905:	74 0e                	je     802915 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802907:	c1 ea 0c             	shr    $0xc,%edx
  80290a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802911:	ef 
  802912:	0f b7 c0             	movzwl %ax,%eax
}
  802915:	5d                   	pop    %ebp
  802916:	c3                   	ret    
  802917:	66 90                	xchg   %ax,%ax
  802919:	66 90                	xchg   %ax,%ax
  80291b:	66 90                	xchg   %ax,%ax
  80291d:	66 90                	xchg   %ax,%ax
  80291f:	90                   	nop

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80292b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80292f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802933:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802937:	85 d2                	test   %edx,%edx
  802939:	75 4d                	jne    802988 <__udivdi3+0x68>
  80293b:	39 f3                	cmp    %esi,%ebx
  80293d:	76 19                	jbe    802958 <__udivdi3+0x38>
  80293f:	31 ff                	xor    %edi,%edi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f2                	mov    %esi,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	89 d9                	mov    %ebx,%ecx
  80295a:	85 db                	test   %ebx,%ebx
  80295c:	75 0b                	jne    802969 <__udivdi3+0x49>
  80295e:	b8 01 00 00 00       	mov    $0x1,%eax
  802963:	31 d2                	xor    %edx,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 c1                	mov    %eax,%ecx
  802969:	31 d2                	xor    %edx,%edx
  80296b:	89 f0                	mov    %esi,%eax
  80296d:	f7 f1                	div    %ecx
  80296f:	89 c6                	mov    %eax,%esi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f7                	mov    %esi,%edi
  802975:	f7 f1                	div    %ecx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	39 f2                	cmp    %esi,%edx
  80298a:	77 1c                	ja     8029a8 <__udivdi3+0x88>
  80298c:	0f bd fa             	bsr    %edx,%edi
  80298f:	83 f7 1f             	xor    $0x1f,%edi
  802992:	75 2c                	jne    8029c0 <__udivdi3+0xa0>
  802994:	39 f2                	cmp    %esi,%edx
  802996:	72 06                	jb     80299e <__udivdi3+0x7e>
  802998:	31 c0                	xor    %eax,%eax
  80299a:	39 eb                	cmp    %ebp,%ebx
  80299c:	77 a9                	ja     802947 <__udivdi3+0x27>
  80299e:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a3:	eb a2                	jmp    802947 <__udivdi3+0x27>
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	89 fa                	mov    %edi,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 f9                	mov    %edi,%ecx
  8029c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c7:	29 f8                	sub    %edi,%eax
  8029c9:	d3 e2                	shl    %cl,%edx
  8029cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029cf:	89 c1                	mov    %eax,%ecx
  8029d1:	89 da                	mov    %ebx,%edx
  8029d3:	d3 ea                	shr    %cl,%edx
  8029d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029d9:	09 d1                	or     %edx,%ecx
  8029db:	89 f2                	mov    %esi,%edx
  8029dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029e1:	89 f9                	mov    %edi,%ecx
  8029e3:	d3 e3                	shl    %cl,%ebx
  8029e5:	89 c1                	mov    %eax,%ecx
  8029e7:	d3 ea                	shr    %cl,%edx
  8029e9:	89 f9                	mov    %edi,%ecx
  8029eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ef:	89 eb                	mov    %ebp,%ebx
  8029f1:	d3 e6                	shl    %cl,%esi
  8029f3:	89 c1                	mov    %eax,%ecx
  8029f5:	d3 eb                	shr    %cl,%ebx
  8029f7:	09 de                	or     %ebx,%esi
  8029f9:	89 f0                	mov    %esi,%eax
  8029fb:	f7 74 24 08          	divl   0x8(%esp)
  8029ff:	89 d6                	mov    %edx,%esi
  802a01:	89 c3                	mov    %eax,%ebx
  802a03:	f7 64 24 0c          	mull   0xc(%esp)
  802a07:	39 d6                	cmp    %edx,%esi
  802a09:	72 15                	jb     802a20 <__udivdi3+0x100>
  802a0b:	89 f9                	mov    %edi,%ecx
  802a0d:	d3 e5                	shl    %cl,%ebp
  802a0f:	39 c5                	cmp    %eax,%ebp
  802a11:	73 04                	jae    802a17 <__udivdi3+0xf7>
  802a13:	39 d6                	cmp    %edx,%esi
  802a15:	74 09                	je     802a20 <__udivdi3+0x100>
  802a17:	89 d8                	mov    %ebx,%eax
  802a19:	31 ff                	xor    %edi,%edi
  802a1b:	e9 27 ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a23:	31 ff                	xor    %edi,%edi
  802a25:	e9 1d ff ff ff       	jmp    802947 <__udivdi3+0x27>
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__umoddi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a47:	89 da                	mov    %ebx,%edx
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	75 43                	jne    802a90 <__umoddi3+0x60>
  802a4d:	39 df                	cmp    %ebx,%edi
  802a4f:	76 17                	jbe    802a68 <__umoddi3+0x38>
  802a51:	89 f0                	mov    %esi,%eax
  802a53:	f7 f7                	div    %edi
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	31 d2                	xor    %edx,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	89 fd                	mov    %edi,%ebp
  802a6a:	85 ff                	test   %edi,%edi
  802a6c:	75 0b                	jne    802a79 <__umoddi3+0x49>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f7                	div    %edi
  802a77:	89 c5                	mov    %eax,%ebp
  802a79:	89 d8                	mov    %ebx,%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	f7 f5                	div    %ebp
  802a7f:	89 f0                	mov    %esi,%eax
  802a81:	f7 f5                	div    %ebp
  802a83:	89 d0                	mov    %edx,%eax
  802a85:	eb d0                	jmp    802a57 <__umoddi3+0x27>
  802a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a8e:	66 90                	xchg   %ax,%ax
  802a90:	89 f1                	mov    %esi,%ecx
  802a92:	39 d8                	cmp    %ebx,%eax
  802a94:	76 0a                	jbe    802aa0 <__umoddi3+0x70>
  802a96:	89 f0                	mov    %esi,%eax
  802a98:	83 c4 1c             	add    $0x1c,%esp
  802a9b:	5b                   	pop    %ebx
  802a9c:	5e                   	pop    %esi
  802a9d:	5f                   	pop    %edi
  802a9e:	5d                   	pop    %ebp
  802a9f:	c3                   	ret    
  802aa0:	0f bd e8             	bsr    %eax,%ebp
  802aa3:	83 f5 1f             	xor    $0x1f,%ebp
  802aa6:	75 20                	jne    802ac8 <__umoddi3+0x98>
  802aa8:	39 d8                	cmp    %ebx,%eax
  802aaa:	0f 82 b0 00 00 00    	jb     802b60 <__umoddi3+0x130>
  802ab0:	39 f7                	cmp    %esi,%edi
  802ab2:	0f 86 a8 00 00 00    	jbe    802b60 <__umoddi3+0x130>
  802ab8:	89 c8                	mov    %ecx,%eax
  802aba:	83 c4 1c             	add    $0x1c,%esp
  802abd:	5b                   	pop    %ebx
  802abe:	5e                   	pop    %esi
  802abf:	5f                   	pop    %edi
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    
  802ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	ba 20 00 00 00       	mov    $0x20,%edx
  802acf:	29 ea                	sub    %ebp,%edx
  802ad1:	d3 e0                	shl    %cl,%eax
  802ad3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ad7:	89 d1                	mov    %edx,%ecx
  802ad9:	89 f8                	mov    %edi,%eax
  802adb:	d3 e8                	shr    %cl,%eax
  802add:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ae1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ae5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ae9:	09 c1                	or     %eax,%ecx
  802aeb:	89 d8                	mov    %ebx,%eax
  802aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 e7                	shl    %cl,%edi
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	d3 e8                	shr    %cl,%eax
  802af9:	89 e9                	mov    %ebp,%ecx
  802afb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aff:	d3 e3                	shl    %cl,%ebx
  802b01:	89 c7                	mov    %eax,%edi
  802b03:	89 d1                	mov    %edx,%ecx
  802b05:	89 f0                	mov    %esi,%eax
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 fa                	mov    %edi,%edx
  802b0d:	d3 e6                	shl    %cl,%esi
  802b0f:	09 d8                	or     %ebx,%eax
  802b11:	f7 74 24 08          	divl   0x8(%esp)
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	89 f3                	mov    %esi,%ebx
  802b19:	f7 64 24 0c          	mull   0xc(%esp)
  802b1d:	89 c6                	mov    %eax,%esi
  802b1f:	89 d7                	mov    %edx,%edi
  802b21:	39 d1                	cmp    %edx,%ecx
  802b23:	72 06                	jb     802b2b <__umoddi3+0xfb>
  802b25:	75 10                	jne    802b37 <__umoddi3+0x107>
  802b27:	39 c3                	cmp    %eax,%ebx
  802b29:	73 0c                	jae    802b37 <__umoddi3+0x107>
  802b2b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b2f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b33:	89 d7                	mov    %edx,%edi
  802b35:	89 c6                	mov    %eax,%esi
  802b37:	89 ca                	mov    %ecx,%edx
  802b39:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b3e:	29 f3                	sub    %esi,%ebx
  802b40:	19 fa                	sbb    %edi,%edx
  802b42:	89 d0                	mov    %edx,%eax
  802b44:	d3 e0                	shl    %cl,%eax
  802b46:	89 e9                	mov    %ebp,%ecx
  802b48:	d3 eb                	shr    %cl,%ebx
  802b4a:	d3 ea                	shr    %cl,%edx
  802b4c:	09 d8                	or     %ebx,%eax
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 da                	mov    %ebx,%edx
  802b62:	29 fe                	sub    %edi,%esi
  802b64:	19 c2                	sbb    %eax,%edx
  802b66:	89 f1                	mov    %esi,%ecx
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	e9 4b ff ff ff       	jmp    802aba <__umoddi3+0x8a>
