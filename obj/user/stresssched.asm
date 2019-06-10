
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
  800044:	e8 3a 13 00 00       	call   801383 <fork>
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
  8000ba:	68 db 2b 80 00       	push   $0x802bdb
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
  8000d4:	68 a0 2b 80 00       	push   $0x802ba0
  8000d9:	6a 21                	push   $0x21
  8000db:	68 c8 2b 80 00       	push   $0x802bc8
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
  800168:	68 f9 2b 80 00       	push   $0x802bf9
  80016d:	e8 76 01 00 00       	call   8002e8 <cprintf>
	cprintf("before umain\n");
  800172:	c7 04 24 17 2c 80 00 	movl   $0x802c17,(%esp)
  800179:	e8 6a 01 00 00       	call   8002e8 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017e:	83 c4 08             	add    $0x8,%esp
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	e8 a7 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018c:	c7 04 24 25 2c 80 00 	movl   $0x802c25,(%esp)
  800193:	e8 50 01 00 00       	call   8002e8 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800198:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80019d:	8b 40 48             	mov    0x48(%eax),%eax
  8001a0:	83 c4 08             	add    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 32 2c 80 00       	push   $0x802c32
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
  8001cc:	68 5c 2c 80 00       	push   $0x802c5c
  8001d1:	50                   	push   %eax
  8001d2:	68 51 2c 80 00       	push   $0x802c51
  8001d7:	e8 0c 01 00 00       	call   8002e8 <cprintf>
	close_all();
  8001dc:	e8 0c 16 00 00       	call   8017ed <close_all>
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
  800202:	68 88 2c 80 00       	push   $0x802c88
  800207:	50                   	push   %eax
  800208:	68 51 2c 80 00       	push   $0x802c51
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
  80022b:	68 64 2c 80 00       	push   $0x802c64
  800230:	e8 b3 00 00 00       	call   8002e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800235:	83 c4 18             	add    $0x18,%esp
  800238:	53                   	push   %ebx
  800239:	ff 75 10             	pushl  0x10(%ebp)
  80023c:	e8 56 00 00 00       	call   800297 <vcprintf>
	cprintf("\n");
  800241:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
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
  800395:	e8 a6 25 00 00       	call   802940 <__udivdi3>
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
  8003be:	e8 8d 26 00 00       	call   802a50 <__umoddi3>
  8003c3:	83 c4 14             	add    $0x14,%esp
  8003c6:	0f be 80 8f 2c 80 00 	movsbl 0x802c8f(%eax),%eax
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
  80046f:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
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
  80053a:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800541:	85 d2                	test   %edx,%edx
  800543:	74 18                	je     80055d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800545:	52                   	push   %edx
  800546:	68 cd 31 80 00       	push   $0x8031cd
  80054b:	53                   	push   %ebx
  80054c:	56                   	push   %esi
  80054d:	e8 a6 fe ff ff       	call   8003f8 <printfmt>
  800552:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800555:	89 7d 14             	mov    %edi,0x14(%ebp)
  800558:	e9 fe 02 00 00       	jmp    80085b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80055d:	50                   	push   %eax
  80055e:	68 a7 2c 80 00       	push   $0x802ca7
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
  800585:	b8 a0 2c 80 00       	mov    $0x802ca0,%eax
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
  80091d:	bf c5 2d 80 00       	mov    $0x802dc5,%edi
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
  800949:	bf fd 2d 80 00       	mov    $0x802dfd,%edi
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
  800dea:	68 08 30 80 00       	push   $0x803008
  800def:	6a 43                	push   $0x43
  800df1:	68 25 30 80 00       	push   $0x803025
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
  800e6b:	68 08 30 80 00       	push   $0x803008
  800e70:	6a 43                	push   $0x43
  800e72:	68 25 30 80 00       	push   $0x803025
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
  800ead:	68 08 30 80 00       	push   $0x803008
  800eb2:	6a 43                	push   $0x43
  800eb4:	68 25 30 80 00       	push   $0x803025
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
  800eef:	68 08 30 80 00       	push   $0x803008
  800ef4:	6a 43                	push   $0x43
  800ef6:	68 25 30 80 00       	push   $0x803025
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
  800f31:	68 08 30 80 00       	push   $0x803008
  800f36:	6a 43                	push   $0x43
  800f38:	68 25 30 80 00       	push   $0x803025
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
  800f73:	68 08 30 80 00       	push   $0x803008
  800f78:	6a 43                	push   $0x43
  800f7a:	68 25 30 80 00       	push   $0x803025
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
  800fb5:	68 08 30 80 00       	push   $0x803008
  800fba:	6a 43                	push   $0x43
  800fbc:	68 25 30 80 00       	push   $0x803025
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
  801019:	68 08 30 80 00       	push   $0x803008
  80101e:	6a 43                	push   $0x43
  801020:	68 25 30 80 00       	push   $0x803025
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
  8010fd:	68 08 30 80 00       	push   $0x803008
  801102:	6a 43                	push   $0x43
  801104:	68 25 30 80 00       	push   $0x803025
  801109:	e8 e4 f0 ff ff       	call   8001f2 <_panic>

0080110e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	57                   	push   %edi
  801112:	56                   	push   %esi
  801113:	53                   	push   %ebx
	asm volatile("int %1\n"
  801114:	b9 00 00 00 00       	mov    $0x0,%ecx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	b8 14 00 00 00       	mov    $0x14,%eax
  801121:	89 cb                	mov    %ecx,%ebx
  801123:	89 cf                	mov    %ecx,%edi
  801125:	89 ce                	mov    %ecx,%esi
  801127:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801129:	5b                   	pop    %ebx
  80112a:	5e                   	pop    %esi
  80112b:	5f                   	pop    %edi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	53                   	push   %ebx
  801132:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801135:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80113c:	f6 c5 04             	test   $0x4,%ch
  80113f:	75 45                	jne    801186 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801141:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801148:	83 e1 07             	and    $0x7,%ecx
  80114b:	83 f9 07             	cmp    $0x7,%ecx
  80114e:	74 6f                	je     8011bf <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801150:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801157:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80115d:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801163:	0f 84 b6 00 00 00    	je     80121f <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801169:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801170:	83 e1 05             	and    $0x5,%ecx
  801173:	83 f9 05             	cmp    $0x5,%ecx
  801176:	0f 84 d7 00 00 00    	je     801253 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80117c:	b8 00 00 00 00       	mov    $0x0,%eax
  801181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801184:	c9                   	leave  
  801185:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801186:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80118d:	c1 e2 0c             	shl    $0xc,%edx
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801199:	51                   	push   %ecx
  80119a:	52                   	push   %edx
  80119b:	50                   	push   %eax
  80119c:	52                   	push   %edx
  80119d:	6a 00                	push   $0x0
  80119f:	e8 d8 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  8011a4:	83 c4 20             	add    $0x20,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	79 d1                	jns    80117c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	68 33 30 80 00       	push   $0x803033
  8011b3:	6a 54                	push   $0x54
  8011b5:	68 49 30 80 00       	push   $0x803049
  8011ba:	e8 33 f0 ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011bf:	89 d3                	mov    %edx,%ebx
  8011c1:	c1 e3 0c             	shl    $0xc,%ebx
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	68 05 08 00 00       	push   $0x805
  8011cc:	53                   	push   %ebx
  8011cd:	50                   	push   %eax
  8011ce:	53                   	push   %ebx
  8011cf:	6a 00                	push   $0x0
  8011d1:	e8 a6 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  8011d6:	83 c4 20             	add    $0x20,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	78 2e                	js     80120b <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	68 05 08 00 00       	push   $0x805
  8011e5:	53                   	push   %ebx
  8011e6:	6a 00                	push   $0x0
  8011e8:	53                   	push   %ebx
  8011e9:	6a 00                	push   $0x0
  8011eb:	e8 8c fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	79 85                	jns    80117c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	68 33 30 80 00       	push   $0x803033
  8011ff:	6a 5f                	push   $0x5f
  801201:	68 49 30 80 00       	push   $0x803049
  801206:	e8 e7 ef ff ff       	call   8001f2 <_panic>
			panic("sys_page_map() panic\n");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 33 30 80 00       	push   $0x803033
  801213:	6a 5b                	push   $0x5b
  801215:	68 49 30 80 00       	push   $0x803049
  80121a:	e8 d3 ef ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80121f:	c1 e2 0c             	shl    $0xc,%edx
  801222:	83 ec 0c             	sub    $0xc,%esp
  801225:	68 05 08 00 00       	push   $0x805
  80122a:	52                   	push   %edx
  80122b:	50                   	push   %eax
  80122c:	52                   	push   %edx
  80122d:	6a 00                	push   $0x0
  80122f:	e8 48 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  801234:	83 c4 20             	add    $0x20,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	0f 89 3d ff ff ff    	jns    80117c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	68 33 30 80 00       	push   $0x803033
  801247:	6a 66                	push   $0x66
  801249:	68 49 30 80 00       	push   $0x803049
  80124e:	e8 9f ef ff ff       	call   8001f2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801253:	c1 e2 0c             	shl    $0xc,%edx
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	6a 05                	push   $0x5
  80125b:	52                   	push   %edx
  80125c:	50                   	push   %eax
  80125d:	52                   	push   %edx
  80125e:	6a 00                	push   $0x0
  801260:	e8 17 fc ff ff       	call   800e7c <sys_page_map>
		if(r < 0)
  801265:	83 c4 20             	add    $0x20,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	0f 89 0c ff ff ff    	jns    80117c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	68 33 30 80 00       	push   $0x803033
  801278:	6a 6d                	push   $0x6d
  80127a:	68 49 30 80 00       	push   $0x803049
  80127f:	e8 6e ef ff ff       	call   8001f2 <_panic>

00801284 <pgfault>:
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	53                   	push   %ebx
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80128e:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801290:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801294:	0f 84 99 00 00 00    	je     801333 <pgfault+0xaf>
  80129a:	89 c2                	mov    %eax,%edx
  80129c:	c1 ea 16             	shr    $0x16,%edx
  80129f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012a6:	f6 c2 01             	test   $0x1,%dl
  8012a9:	0f 84 84 00 00 00    	je     801333 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	c1 ea 0c             	shr    $0xc,%edx
  8012b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012bb:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012c1:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012c7:	75 6a                	jne    801333 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ce:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	6a 07                	push   $0x7
  8012d5:	68 00 f0 7f 00       	push   $0x7ff000
  8012da:	6a 00                	push   $0x0
  8012dc:	e8 58 fb ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 5f                	js     801347 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 00 10 00 00       	push   $0x1000
  8012f0:	53                   	push   %ebx
  8012f1:	68 00 f0 7f 00       	push   $0x7ff000
  8012f6:	e8 3c f9 ff ff       	call   800c37 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012fb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801302:	53                   	push   %ebx
  801303:	6a 00                	push   $0x0
  801305:	68 00 f0 7f 00       	push   $0x7ff000
  80130a:	6a 00                	push   $0x0
  80130c:	e8 6b fb ff ff       	call   800e7c <sys_page_map>
	if(ret < 0)
  801311:	83 c4 20             	add    $0x20,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 43                	js     80135b <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	68 00 f0 7f 00       	push   $0x7ff000
  801320:	6a 00                	push   $0x0
  801322:	e8 97 fb ff ff       	call   800ebe <sys_page_unmap>
	if(ret < 0)
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	85 c0                	test   %eax,%eax
  80132c:	78 41                	js     80136f <pgfault+0xeb>
}
  80132e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801331:	c9                   	leave  
  801332:	c3                   	ret    
		panic("panic at pgfault()\n");
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	68 54 30 80 00       	push   $0x803054
  80133b:	6a 26                	push   $0x26
  80133d:	68 49 30 80 00       	push   $0x803049
  801342:	e8 ab ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_alloc()\n");
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	68 68 30 80 00       	push   $0x803068
  80134f:	6a 31                	push   $0x31
  801351:	68 49 30 80 00       	push   $0x803049
  801356:	e8 97 ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_map()\n");
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	68 83 30 80 00       	push   $0x803083
  801363:	6a 36                	push   $0x36
  801365:	68 49 30 80 00       	push   $0x803049
  80136a:	e8 83 ee ff ff       	call   8001f2 <_panic>
		panic("panic in sys_page_unmap()\n");
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	68 9c 30 80 00       	push   $0x80309c
  801377:	6a 39                	push   $0x39
  801379:	68 49 30 80 00       	push   $0x803049
  80137e:	e8 6f ee ff ff       	call   8001f2 <_panic>

00801383 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	57                   	push   %edi
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
  801389:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80138c:	68 84 12 80 00       	push   $0x801284
  801391:	e8 d5 13 00 00       	call   80276b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801396:	b8 07 00 00 00       	mov    $0x7,%eax
  80139b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 27                	js     8013cb <fork+0x48>
  8013a4:	89 c6                	mov    %eax,%esi
  8013a6:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013a8:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013ad:	75 48                	jne    8013f7 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013af:	e8 47 fa ff ff       	call   800dfb <sys_getenvid>
  8013b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013b9:	c1 e0 07             	shl    $0x7,%eax
  8013bc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c1:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013c6:	e9 90 00 00 00       	jmp    80145b <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	68 b8 30 80 00       	push   $0x8030b8
  8013d3:	68 8c 00 00 00       	push   $0x8c
  8013d8:	68 49 30 80 00       	push   $0x803049
  8013dd:	e8 10 ee ff ff       	call   8001f2 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013e2:	89 f8                	mov    %edi,%eax
  8013e4:	e8 45 fd ff ff       	call   80112e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013ef:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013f5:	74 26                	je     80141d <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013f7:	89 d8                	mov    %ebx,%eax
  8013f9:	c1 e8 16             	shr    $0x16,%eax
  8013fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801403:	a8 01                	test   $0x1,%al
  801405:	74 e2                	je     8013e9 <fork+0x66>
  801407:	89 da                	mov    %ebx,%edx
  801409:	c1 ea 0c             	shr    $0xc,%edx
  80140c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801413:	83 e0 05             	and    $0x5,%eax
  801416:	83 f8 05             	cmp    $0x5,%eax
  801419:	75 ce                	jne    8013e9 <fork+0x66>
  80141b:	eb c5                	jmp    8013e2 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	6a 07                	push   $0x7
  801422:	68 00 f0 bf ee       	push   $0xeebff000
  801427:	56                   	push   %esi
  801428:	e8 0c fa ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 31                	js     801465 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801434:	83 ec 08             	sub    $0x8,%esp
  801437:	68 da 27 80 00       	push   $0x8027da
  80143c:	56                   	push   %esi
  80143d:	e8 42 fb ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801442:	83 c4 10             	add    $0x10,%esp
  801445:	85 c0                	test   %eax,%eax
  801447:	78 33                	js     80147c <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	6a 02                	push   $0x2
  80144e:	56                   	push   %esi
  80144f:	e8 ac fa ff ff       	call   800f00 <sys_env_set_status>
	if(ret < 0)
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 38                	js     801493 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80145b:	89 f0                	mov    %esi,%eax
  80145d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801460:	5b                   	pop    %ebx
  801461:	5e                   	pop    %esi
  801462:	5f                   	pop    %edi
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	68 68 30 80 00       	push   $0x803068
  80146d:	68 98 00 00 00       	push   $0x98
  801472:	68 49 30 80 00       	push   $0x803049
  801477:	e8 76 ed ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	68 dc 30 80 00       	push   $0x8030dc
  801484:	68 9b 00 00 00       	push   $0x9b
  801489:	68 49 30 80 00       	push   $0x803049
  80148e:	e8 5f ed ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_status()\n");
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	68 04 31 80 00       	push   $0x803104
  80149b:	68 9e 00 00 00       	push   $0x9e
  8014a0:	68 49 30 80 00       	push   $0x803049
  8014a5:	e8 48 ed ff ff       	call   8001f2 <_panic>

008014aa <sfork>:

// Challenge!
int
sfork(void)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	57                   	push   %edi
  8014ae:	56                   	push   %esi
  8014af:	53                   	push   %ebx
  8014b0:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014b3:	68 84 12 80 00       	push   $0x801284
  8014b8:	e8 ae 12 00 00       	call   80276b <set_pgfault_handler>
  8014bd:	b8 07 00 00 00       	mov    $0x7,%eax
  8014c2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 27                	js     8014f2 <sfork+0x48>
  8014cb:	89 c7                	mov    %eax,%edi
  8014cd:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014cf:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014d4:	75 55                	jne    80152b <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014d6:	e8 20 f9 ff ff       	call   800dfb <sys_getenvid>
  8014db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014e0:	c1 e0 07             	shl    $0x7,%eax
  8014e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014e8:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8014ed:	e9 d4 00 00 00       	jmp    8015c6 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	68 b8 30 80 00       	push   $0x8030b8
  8014fa:	68 af 00 00 00       	push   $0xaf
  8014ff:	68 49 30 80 00       	push   $0x803049
  801504:	e8 e9 ec ff ff       	call   8001f2 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801509:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80150e:	89 f0                	mov    %esi,%eax
  801510:	e8 19 fc ff ff       	call   80112e <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801515:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80151b:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801521:	77 65                	ja     801588 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801523:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801529:	74 de                	je     801509 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80152b:	89 d8                	mov    %ebx,%eax
  80152d:	c1 e8 16             	shr    $0x16,%eax
  801530:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801537:	a8 01                	test   $0x1,%al
  801539:	74 da                	je     801515 <sfork+0x6b>
  80153b:	89 da                	mov    %ebx,%edx
  80153d:	c1 ea 0c             	shr    $0xc,%edx
  801540:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801547:	83 e0 05             	and    $0x5,%eax
  80154a:	83 f8 05             	cmp    $0x5,%eax
  80154d:	75 c6                	jne    801515 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80154f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801556:	c1 e2 0c             	shl    $0xc,%edx
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	83 e0 07             	and    $0x7,%eax
  80155f:	50                   	push   %eax
  801560:	52                   	push   %edx
  801561:	56                   	push   %esi
  801562:	52                   	push   %edx
  801563:	6a 00                	push   $0x0
  801565:	e8 12 f9 ff ff       	call   800e7c <sys_page_map>
  80156a:	83 c4 20             	add    $0x20,%esp
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 a4                	je     801515 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	68 33 30 80 00       	push   $0x803033
  801579:	68 ba 00 00 00       	push   $0xba
  80157e:	68 49 30 80 00       	push   $0x803049
  801583:	e8 6a ec ff ff       	call   8001f2 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	6a 07                	push   $0x7
  80158d:	68 00 f0 bf ee       	push   $0xeebff000
  801592:	57                   	push   %edi
  801593:	e8 a1 f8 ff ff       	call   800e39 <sys_page_alloc>
	if(ret < 0)
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 31                	js     8015d0 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	68 da 27 80 00       	push   $0x8027da
  8015a7:	57                   	push   %edi
  8015a8:	e8 d7 f9 ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 33                	js     8015e7 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	6a 02                	push   $0x2
  8015b9:	57                   	push   %edi
  8015ba:	e8 41 f9 ff ff       	call   800f00 <sys_env_set_status>
	if(ret < 0)
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	78 38                	js     8015fe <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015c6:	89 f8                	mov    %edi,%eax
  8015c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5e                   	pop    %esi
  8015cd:	5f                   	pop    %edi
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	68 68 30 80 00       	push   $0x803068
  8015d8:	68 c0 00 00 00       	push   $0xc0
  8015dd:	68 49 30 80 00       	push   $0x803049
  8015e2:	e8 0b ec ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015e7:	83 ec 04             	sub    $0x4,%esp
  8015ea:	68 dc 30 80 00       	push   $0x8030dc
  8015ef:	68 c3 00 00 00       	push   $0xc3
  8015f4:	68 49 30 80 00       	push   $0x803049
  8015f9:	e8 f4 eb ff ff       	call   8001f2 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 04 31 80 00       	push   $0x803104
  801606:	68 c6 00 00 00       	push   $0xc6
  80160b:	68 49 30 80 00       	push   $0x803049
  801610:	e8 dd eb ff ff       	call   8001f2 <_panic>

00801615 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	05 00 00 00 30       	add    $0x30000000,%eax
  801620:	c1 e8 0c             	shr    $0xc,%eax
}
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801630:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801635:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801644:	89 c2                	mov    %eax,%edx
  801646:	c1 ea 16             	shr    $0x16,%edx
  801649:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801650:	f6 c2 01             	test   $0x1,%dl
  801653:	74 2d                	je     801682 <fd_alloc+0x46>
  801655:	89 c2                	mov    %eax,%edx
  801657:	c1 ea 0c             	shr    $0xc,%edx
  80165a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801661:	f6 c2 01             	test   $0x1,%dl
  801664:	74 1c                	je     801682 <fd_alloc+0x46>
  801666:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80166b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801670:	75 d2                	jne    801644 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80167b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801680:	eb 0a                	jmp    80168c <fd_alloc+0x50>
			*fd_store = fd;
  801682:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801685:	89 01                	mov    %eax,(%ecx)
			return 0;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801694:	83 f8 1f             	cmp    $0x1f,%eax
  801697:	77 30                	ja     8016c9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801699:	c1 e0 0c             	shl    $0xc,%eax
  80169c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016a1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016a7:	f6 c2 01             	test   $0x1,%dl
  8016aa:	74 24                	je     8016d0 <fd_lookup+0x42>
  8016ac:	89 c2                	mov    %eax,%edx
  8016ae:	c1 ea 0c             	shr    $0xc,%edx
  8016b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b8:	f6 c2 01             	test   $0x1,%dl
  8016bb:	74 1a                	je     8016d7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	89 02                	mov    %eax,(%edx)
	return 0;
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    
		return -E_INVAL;
  8016c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ce:	eb f7                	jmp    8016c7 <fd_lookup+0x39>
		return -E_INVAL;
  8016d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d5:	eb f0                	jmp    8016c7 <fd_lookup+0x39>
  8016d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016dc:	eb e9                	jmp    8016c7 <fd_lookup+0x39>

008016de <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016f1:	39 08                	cmp    %ecx,(%eax)
  8016f3:	74 38                	je     80172d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016f5:	83 c2 01             	add    $0x1,%edx
  8016f8:	8b 04 95 a0 31 80 00 	mov    0x8031a0(,%edx,4),%eax
  8016ff:	85 c0                	test   %eax,%eax
  801701:	75 ee                	jne    8016f1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801703:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801708:	8b 40 48             	mov    0x48(%eax),%eax
  80170b:	83 ec 04             	sub    $0x4,%esp
  80170e:	51                   	push   %ecx
  80170f:	50                   	push   %eax
  801710:	68 24 31 80 00       	push   $0x803124
  801715:	e8 ce eb ff ff       	call   8002e8 <cprintf>
	*dev = 0;
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    
			*dev = devtab[i];
  80172d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801730:	89 01                	mov    %eax,(%ecx)
			return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb f2                	jmp    80172b <dev_lookup+0x4d>

00801739 <fd_close>:
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	57                   	push   %edi
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	83 ec 24             	sub    $0x24,%esp
  801742:	8b 75 08             	mov    0x8(%ebp),%esi
  801745:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801748:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80174b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80174c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801752:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801755:	50                   	push   %eax
  801756:	e8 33 ff ff ff       	call   80168e <fd_lookup>
  80175b:	89 c3                	mov    %eax,%ebx
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	78 05                	js     801769 <fd_close+0x30>
	    || fd != fd2)
  801764:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801767:	74 16                	je     80177f <fd_close+0x46>
		return (must_exist ? r : 0);
  801769:	89 f8                	mov    %edi,%eax
  80176b:	84 c0                	test   %al,%al
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
  801772:	0f 44 d8             	cmove  %eax,%ebx
}
  801775:	89 d8                	mov    %ebx,%eax
  801777:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177a:	5b                   	pop    %ebx
  80177b:	5e                   	pop    %esi
  80177c:	5f                   	pop    %edi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80177f:	83 ec 08             	sub    $0x8,%esp
  801782:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801785:	50                   	push   %eax
  801786:	ff 36                	pushl  (%esi)
  801788:	e8 51 ff ff ff       	call   8016de <dev_lookup>
  80178d:	89 c3                	mov    %eax,%ebx
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 1a                	js     8017b0 <fd_close+0x77>
		if (dev->dev_close)
  801796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801799:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80179c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	74 0b                	je     8017b0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	56                   	push   %esi
  8017a9:	ff d0                	call   *%eax
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	56                   	push   %esi
  8017b4:	6a 00                	push   $0x0
  8017b6:	e8 03 f7 ff ff       	call   800ebe <sys_page_unmap>
	return r;
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	eb b5                	jmp    801775 <fd_close+0x3c>

008017c0 <close>:

int
close(int fdnum)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c9:	50                   	push   %eax
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	e8 bc fe ff ff       	call   80168e <fd_lookup>
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	79 02                	jns    8017db <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    
		return fd_close(fd, 1);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	6a 01                	push   $0x1
  8017e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e3:	e8 51 ff ff ff       	call   801739 <fd_close>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	eb ec                	jmp    8017d9 <close+0x19>

008017ed <close_all>:

void
close_all(void)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	53                   	push   %ebx
  8017f1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017f9:	83 ec 0c             	sub    $0xc,%esp
  8017fc:	53                   	push   %ebx
  8017fd:	e8 be ff ff ff       	call   8017c0 <close>
	for (i = 0; i < MAXFD; i++)
  801802:	83 c3 01             	add    $0x1,%ebx
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	83 fb 20             	cmp    $0x20,%ebx
  80180b:	75 ec                	jne    8017f9 <close_all+0xc>
}
  80180d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	57                   	push   %edi
  801816:	56                   	push   %esi
  801817:	53                   	push   %ebx
  801818:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80181b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	ff 75 08             	pushl  0x8(%ebp)
  801822:	e8 67 fe ff ff       	call   80168e <fd_lookup>
  801827:	89 c3                	mov    %eax,%ebx
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	0f 88 81 00 00 00    	js     8018b5 <dup+0xa3>
		return r;
	close(newfdnum);
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 81 ff ff ff       	call   8017c0 <close>

	newfd = INDEX2FD(newfdnum);
  80183f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801842:	c1 e6 0c             	shl    $0xc,%esi
  801845:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80184b:	83 c4 04             	add    $0x4,%esp
  80184e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801851:	e8 cf fd ff ff       	call   801625 <fd2data>
  801856:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801858:	89 34 24             	mov    %esi,(%esp)
  80185b:	e8 c5 fd ff ff       	call   801625 <fd2data>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801865:	89 d8                	mov    %ebx,%eax
  801867:	c1 e8 16             	shr    $0x16,%eax
  80186a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801871:	a8 01                	test   $0x1,%al
  801873:	74 11                	je     801886 <dup+0x74>
  801875:	89 d8                	mov    %ebx,%eax
  801877:	c1 e8 0c             	shr    $0xc,%eax
  80187a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801881:	f6 c2 01             	test   $0x1,%dl
  801884:	75 39                	jne    8018bf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801886:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801889:	89 d0                	mov    %edx,%eax
  80188b:	c1 e8 0c             	shr    $0xc,%eax
  80188e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	25 07 0e 00 00       	and    $0xe07,%eax
  80189d:	50                   	push   %eax
  80189e:	56                   	push   %esi
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	6a 00                	push   $0x0
  8018a4:	e8 d3 f5 ff ff       	call   800e7c <sys_page_map>
  8018a9:	89 c3                	mov    %eax,%ebx
  8018ab:	83 c4 20             	add    $0x20,%esp
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 31                	js     8018e3 <dup+0xd1>
		goto err;

	return newfdnum;
  8018b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018b5:	89 d8                	mov    %ebx,%eax
  8018b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018ba:	5b                   	pop    %ebx
  8018bb:	5e                   	pop    %esi
  8018bc:	5f                   	pop    %edi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ce:	50                   	push   %eax
  8018cf:	57                   	push   %edi
  8018d0:	6a 00                	push   $0x0
  8018d2:	53                   	push   %ebx
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 a2 f5 ff ff       	call   800e7c <sys_page_map>
  8018da:	89 c3                	mov    %eax,%ebx
  8018dc:	83 c4 20             	add    $0x20,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	79 a3                	jns    801886 <dup+0x74>
	sys_page_unmap(0, newfd);
  8018e3:	83 ec 08             	sub    $0x8,%esp
  8018e6:	56                   	push   %esi
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 d0 f5 ff ff       	call   800ebe <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018ee:	83 c4 08             	add    $0x8,%esp
  8018f1:	57                   	push   %edi
  8018f2:	6a 00                	push   $0x0
  8018f4:	e8 c5 f5 ff ff       	call   800ebe <sys_page_unmap>
	return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	eb b7                	jmp    8018b5 <dup+0xa3>

008018fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	53                   	push   %ebx
  801902:	83 ec 1c             	sub    $0x1c,%esp
  801905:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801908:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190b:	50                   	push   %eax
  80190c:	53                   	push   %ebx
  80190d:	e8 7c fd ff ff       	call   80168e <fd_lookup>
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	85 c0                	test   %eax,%eax
  801917:	78 3f                	js     801958 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801919:	83 ec 08             	sub    $0x8,%esp
  80191c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191f:	50                   	push   %eax
  801920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801923:	ff 30                	pushl  (%eax)
  801925:	e8 b4 fd ff ff       	call   8016de <dev_lookup>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 27                	js     801958 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801931:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801934:	8b 42 08             	mov    0x8(%edx),%eax
  801937:	83 e0 03             	and    $0x3,%eax
  80193a:	83 f8 01             	cmp    $0x1,%eax
  80193d:	74 1e                	je     80195d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	8b 40 08             	mov    0x8(%eax),%eax
  801945:	85 c0                	test   %eax,%eax
  801947:	74 35                	je     80197e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	ff 75 10             	pushl  0x10(%ebp)
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	52                   	push   %edx
  801953:	ff d0                	call   *%eax
  801955:	83 c4 10             	add    $0x10,%esp
}
  801958:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80195d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801962:	8b 40 48             	mov    0x48(%eax),%eax
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	53                   	push   %ebx
  801969:	50                   	push   %eax
  80196a:	68 65 31 80 00       	push   $0x803165
  80196f:	e8 74 e9 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80197c:	eb da                	jmp    801958 <read+0x5a>
		return -E_NOT_SUPP;
  80197e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801983:	eb d3                	jmp    801958 <read+0x5a>

00801985 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	57                   	push   %edi
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801991:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801994:	bb 00 00 00 00       	mov    $0x0,%ebx
  801999:	39 f3                	cmp    %esi,%ebx
  80199b:	73 23                	jae    8019c0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	89 f0                	mov    %esi,%eax
  8019a2:	29 d8                	sub    %ebx,%eax
  8019a4:	50                   	push   %eax
  8019a5:	89 d8                	mov    %ebx,%eax
  8019a7:	03 45 0c             	add    0xc(%ebp),%eax
  8019aa:	50                   	push   %eax
  8019ab:	57                   	push   %edi
  8019ac:	e8 4d ff ff ff       	call   8018fe <read>
		if (m < 0)
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 06                	js     8019be <readn+0x39>
			return m;
		if (m == 0)
  8019b8:	74 06                	je     8019c0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019ba:	01 c3                	add    %eax,%ebx
  8019bc:	eb db                	jmp    801999 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c5:	5b                   	pop    %ebx
  8019c6:	5e                   	pop    %esi
  8019c7:	5f                   	pop    %edi
  8019c8:	5d                   	pop    %ebp
  8019c9:	c3                   	ret    

008019ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	53                   	push   %ebx
  8019ce:	83 ec 1c             	sub    $0x1c,%esp
  8019d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	53                   	push   %ebx
  8019d9:	e8 b0 fc ff ff       	call   80168e <fd_lookup>
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 3a                	js     801a1f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019eb:	50                   	push   %eax
  8019ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ef:	ff 30                	pushl  (%eax)
  8019f1:	e8 e8 fc ff ff       	call   8016de <dev_lookup>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 22                	js     801a1f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a00:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a04:	74 1e                	je     801a24 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a09:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0c:	85 d2                	test   %edx,%edx
  801a0e:	74 35                	je     801a45 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	ff 75 10             	pushl  0x10(%ebp)
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	50                   	push   %eax
  801a1a:	ff d2                	call   *%edx
  801a1c:	83 c4 10             	add    $0x10,%esp
}
  801a1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a24:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a29:	8b 40 48             	mov    0x48(%eax),%eax
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	53                   	push   %ebx
  801a30:	50                   	push   %eax
  801a31:	68 81 31 80 00       	push   $0x803181
  801a36:	e8 ad e8 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a43:	eb da                	jmp    801a1f <write+0x55>
		return -E_NOT_SUPP;
  801a45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4a:	eb d3                	jmp    801a1f <write+0x55>

00801a4c <seek>:

int
seek(int fdnum, off_t offset)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a55:	50                   	push   %eax
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	e8 30 fc ff ff       	call   80168e <fd_lookup>
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 0e                	js     801a73 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	53                   	push   %ebx
  801a79:	83 ec 1c             	sub    $0x1c,%esp
  801a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a82:	50                   	push   %eax
  801a83:	53                   	push   %ebx
  801a84:	e8 05 fc ff ff       	call   80168e <fd_lookup>
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 37                	js     801ac7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a96:	50                   	push   %eax
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	ff 30                	pushl  (%eax)
  801a9c:	e8 3d fc ff ff       	call   8016de <dev_lookup>
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 1f                	js     801ac7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aaf:	74 1b                	je     801acc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ab1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab4:	8b 52 18             	mov    0x18(%edx),%edx
  801ab7:	85 d2                	test   %edx,%edx
  801ab9:	74 32                	je     801aed <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801abb:	83 ec 08             	sub    $0x8,%esp
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	50                   	push   %eax
  801ac2:	ff d2                	call   *%edx
  801ac4:	83 c4 10             	add    $0x10,%esp
}
  801ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    
			thisenv->env_id, fdnum);
  801acc:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ad1:	8b 40 48             	mov    0x48(%eax),%eax
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	53                   	push   %ebx
  801ad8:	50                   	push   %eax
  801ad9:	68 44 31 80 00       	push   $0x803144
  801ade:	e8 05 e8 ff ff       	call   8002e8 <cprintf>
		return -E_INVAL;
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aeb:	eb da                	jmp    801ac7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801aed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af2:	eb d3                	jmp    801ac7 <ftruncate+0x52>

00801af4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	53                   	push   %ebx
  801af8:	83 ec 1c             	sub    $0x1c,%esp
  801afb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801afe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b01:	50                   	push   %eax
  801b02:	ff 75 08             	pushl  0x8(%ebp)
  801b05:	e8 84 fb ff ff       	call   80168e <fd_lookup>
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 4b                	js     801b5c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b17:	50                   	push   %eax
  801b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1b:	ff 30                	pushl  (%eax)
  801b1d:	e8 bc fb ff ff       	call   8016de <dev_lookup>
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 33                	js     801b5c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b30:	74 2f                	je     801b61 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b32:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b35:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b3c:	00 00 00 
	stat->st_isdir = 0;
  801b3f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b46:	00 00 00 
	stat->st_dev = dev;
  801b49:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	53                   	push   %ebx
  801b53:	ff 75 f0             	pushl  -0x10(%ebp)
  801b56:	ff 50 14             	call   *0x14(%eax)
  801b59:	83 c4 10             	add    $0x10,%esp
}
  801b5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    
		return -E_NOT_SUPP;
  801b61:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b66:	eb f4                	jmp    801b5c <fstat+0x68>

00801b68 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b6d:	83 ec 08             	sub    $0x8,%esp
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	e8 22 02 00 00       	call   801d9c <open>
  801b7a:	89 c3                	mov    %eax,%ebx
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 1b                	js     801b9e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	e8 65 ff ff ff       	call   801af4 <fstat>
  801b8f:	89 c6                	mov    %eax,%esi
	close(fd);
  801b91:	89 1c 24             	mov    %ebx,(%esp)
  801b94:	e8 27 fc ff ff       	call   8017c0 <close>
	return r;
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	89 f3                	mov    %esi,%ebx
}
  801b9e:	89 d8                	mov    %ebx,%eax
  801ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    

00801ba7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	89 c6                	mov    %eax,%esi
  801bae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bb0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bb7:	74 27                	je     801be0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bb9:	6a 07                	push   $0x7
  801bbb:	68 00 60 80 00       	push   $0x806000
  801bc0:	56                   	push   %esi
  801bc1:	ff 35 00 50 80 00    	pushl  0x805000
  801bc7:	e8 9d 0c 00 00       	call   802869 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bcc:	83 c4 0c             	add    $0xc,%esp
  801bcf:	6a 00                	push   $0x0
  801bd1:	53                   	push   %ebx
  801bd2:	6a 00                	push   $0x0
  801bd4:	e8 27 0c 00 00       	call   802800 <ipc_recv>
}
  801bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	6a 01                	push   $0x1
  801be5:	e8 d7 0c 00 00       	call   8028c1 <ipc_find_env>
  801bea:	a3 00 50 80 00       	mov    %eax,0x805000
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	eb c5                	jmp    801bb9 <fsipc+0x12>

00801bf4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801c00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c08:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c12:	b8 02 00 00 00       	mov    $0x2,%eax
  801c17:	e8 8b ff ff ff       	call   801ba7 <fsipc>
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <devfile_flush>:
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	b8 06 00 00 00       	mov    $0x6,%eax
  801c39:	e8 69 ff ff ff       	call   801ba7 <fsipc>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <devfile_stat>:
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	53                   	push   %ebx
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c50:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c55:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c5f:	e8 43 ff ff ff       	call   801ba7 <fsipc>
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 2c                	js     801c94 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	68 00 60 80 00       	push   $0x806000
  801c70:	53                   	push   %ebx
  801c71:	e8 d1 ed ff ff       	call   800a47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c76:	a1 80 60 80 00       	mov    0x806080,%eax
  801c7b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c81:	a1 84 60 80 00       	mov    0x806084,%eax
  801c86:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <devfile_write>:
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cae:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cb4:	53                   	push   %ebx
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	68 08 60 80 00       	push   $0x806008
  801cbd:	e8 75 ef ff ff       	call   800c37 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc7:	b8 04 00 00 00       	mov    $0x4,%eax
  801ccc:	e8 d6 fe ff ff       	call   801ba7 <fsipc>
  801cd1:	83 c4 10             	add    $0x10,%esp
  801cd4:	85 c0                	test   %eax,%eax
  801cd6:	78 0b                	js     801ce3 <devfile_write+0x4a>
	assert(r <= n);
  801cd8:	39 d8                	cmp    %ebx,%eax
  801cda:	77 0c                	ja     801ce8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801cdc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ce1:	7f 1e                	jg     801d01 <devfile_write+0x68>
}
  801ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    
	assert(r <= n);
  801ce8:	68 b4 31 80 00       	push   $0x8031b4
  801ced:	68 bb 31 80 00       	push   $0x8031bb
  801cf2:	68 98 00 00 00       	push   $0x98
  801cf7:	68 d0 31 80 00       	push   $0x8031d0
  801cfc:	e8 f1 e4 ff ff       	call   8001f2 <_panic>
	assert(r <= PGSIZE);
  801d01:	68 db 31 80 00       	push   $0x8031db
  801d06:	68 bb 31 80 00       	push   $0x8031bb
  801d0b:	68 99 00 00 00       	push   $0x99
  801d10:	68 d0 31 80 00       	push   $0x8031d0
  801d15:	e8 d8 e4 ff ff       	call   8001f2 <_panic>

00801d1a <devfile_read>:
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	56                   	push   %esi
  801d1e:	53                   	push   %ebx
  801d1f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	8b 40 0c             	mov    0xc(%eax),%eax
  801d28:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d2d:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d33:	ba 00 00 00 00       	mov    $0x0,%edx
  801d38:	b8 03 00 00 00       	mov    $0x3,%eax
  801d3d:	e8 65 fe ff ff       	call   801ba7 <fsipc>
  801d42:	89 c3                	mov    %eax,%ebx
  801d44:	85 c0                	test   %eax,%eax
  801d46:	78 1f                	js     801d67 <devfile_read+0x4d>
	assert(r <= n);
  801d48:	39 f0                	cmp    %esi,%eax
  801d4a:	77 24                	ja     801d70 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d4c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d51:	7f 33                	jg     801d86 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	50                   	push   %eax
  801d57:	68 00 60 80 00       	push   $0x806000
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	e8 71 ee ff ff       	call   800bd5 <memmove>
	return r;
  801d64:	83 c4 10             	add    $0x10,%esp
}
  801d67:	89 d8                	mov    %ebx,%eax
  801d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
	assert(r <= n);
  801d70:	68 b4 31 80 00       	push   $0x8031b4
  801d75:	68 bb 31 80 00       	push   $0x8031bb
  801d7a:	6a 7c                	push   $0x7c
  801d7c:	68 d0 31 80 00       	push   $0x8031d0
  801d81:	e8 6c e4 ff ff       	call   8001f2 <_panic>
	assert(r <= PGSIZE);
  801d86:	68 db 31 80 00       	push   $0x8031db
  801d8b:	68 bb 31 80 00       	push   $0x8031bb
  801d90:	6a 7d                	push   $0x7d
  801d92:	68 d0 31 80 00       	push   $0x8031d0
  801d97:	e8 56 e4 ff ff       	call   8001f2 <_panic>

00801d9c <open>:
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	83 ec 1c             	sub    $0x1c,%esp
  801da4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801da7:	56                   	push   %esi
  801da8:	e8 61 ec ff ff       	call   800a0e <strlen>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801db5:	7f 6c                	jg     801e23 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbd:	50                   	push   %eax
  801dbe:	e8 79 f8 ff ff       	call   80163c <fd_alloc>
  801dc3:	89 c3                	mov    %eax,%ebx
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	78 3c                	js     801e08 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	56                   	push   %esi
  801dd0:	68 00 60 80 00       	push   $0x806000
  801dd5:	e8 6d ec ff ff       	call   800a47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	e8 b8 fd ff ff       	call   801ba7 <fsipc>
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 19                	js     801e11 <open+0x75>
	return fd2num(fd);
  801df8:	83 ec 0c             	sub    $0xc,%esp
  801dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfe:	e8 12 f8 ff ff       	call   801615 <fd2num>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
}
  801e08:	89 d8                	mov    %ebx,%eax
  801e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5e                   	pop    %esi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    
		fd_close(fd, 0);
  801e11:	83 ec 08             	sub    $0x8,%esp
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 f4             	pushl  -0xc(%ebp)
  801e19:	e8 1b f9 ff ff       	call   801739 <fd_close>
		return r;
  801e1e:	83 c4 10             	add    $0x10,%esp
  801e21:	eb e5                	jmp    801e08 <open+0x6c>
		return -E_BAD_PATH;
  801e23:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e28:	eb de                	jmp    801e08 <open+0x6c>

00801e2a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	b8 08 00 00 00       	mov    $0x8,%eax
  801e3a:	e8 68 fd ff ff       	call   801ba7 <fsipc>
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e47:	68 e7 31 80 00       	push   $0x8031e7
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	e8 f3 eb ff ff       	call   800a47 <strcpy>
	return 0;
}
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <devsock_close>:
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 10             	sub    $0x10,%esp
  801e62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e65:	53                   	push   %ebx
  801e66:	e8 91 0a 00 00       	call   8028fc <pageref>
  801e6b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e6e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e73:	83 f8 01             	cmp    $0x1,%eax
  801e76:	74 07                	je     801e7f <devsock_close+0x24>
}
  801e78:	89 d0                	mov    %edx,%eax
  801e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	ff 73 0c             	pushl  0xc(%ebx)
  801e85:	e8 b9 02 00 00       	call   802143 <nsipc_close>
  801e8a:	89 c2                	mov    %eax,%edx
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	eb e7                	jmp    801e78 <devsock_close+0x1d>

00801e91 <devsock_write>:
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	ff 70 0c             	pushl  0xc(%eax)
  801ea5:	e8 76 03 00 00       	call   802220 <nsipc_send>
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <devsock_read>:
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	ff 75 10             	pushl  0x10(%ebp)
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	ff 70 0c             	pushl  0xc(%eax)
  801ec0:	e8 ef 02 00 00       	call   8021b4 <nsipc_recv>
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <fd2sockid>:
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ecd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	e8 b7 f7 ff ff       	call   80168e <fd_lookup>
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	85 c0                	test   %eax,%eax
  801edc:	78 10                	js     801eee <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ee7:	39 08                	cmp    %ecx,(%eax)
  801ee9:	75 05                	jne    801ef0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801eeb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    
		return -E_NOT_SUPP;
  801ef0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ef5:	eb f7                	jmp    801eee <fd2sockid+0x27>

00801ef7 <alloc_sockfd>:
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	83 ec 1c             	sub    $0x1c,%esp
  801eff:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f04:	50                   	push   %eax
  801f05:	e8 32 f7 ff ff       	call   80163c <fd_alloc>
  801f0a:	89 c3                	mov    %eax,%ebx
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 43                	js     801f56 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	68 07 04 00 00       	push   $0x407
  801f1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 14 ef ff ff       	call   800e39 <sys_page_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 28                	js     801f56 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f37:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f43:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	50                   	push   %eax
  801f4a:	e8 c6 f6 ff ff       	call   801615 <fd2num>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	eb 0c                	jmp    801f62 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	56                   	push   %esi
  801f5a:	e8 e4 01 00 00       	call   802143 <nsipc_close>
		return r;
  801f5f:	83 c4 10             	add    $0x10,%esp
}
  801f62:	89 d8                	mov    %ebx,%eax
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <accept>:
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	e8 4e ff ff ff       	call   801ec7 <fd2sockid>
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	78 1b                	js     801f98 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	50                   	push   %eax
  801f87:	e8 0e 01 00 00       	call   80209a <nsipc_accept>
  801f8c:	83 c4 10             	add    $0x10,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 05                	js     801f98 <accept+0x2d>
	return alloc_sockfd(r);
  801f93:	e8 5f ff ff ff       	call   801ef7 <alloc_sockfd>
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <bind>:
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	e8 1f ff ff ff       	call   801ec7 <fd2sockid>
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 12                	js     801fbe <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	ff 75 10             	pushl  0x10(%ebp)
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	50                   	push   %eax
  801fb6:	e8 31 01 00 00       	call   8020ec <nsipc_bind>
  801fbb:	83 c4 10             	add    $0x10,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <shutdown>:
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	e8 f9 fe ff ff       	call   801ec7 <fd2sockid>
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	78 0f                	js     801fe1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	50                   	push   %eax
  801fd9:	e8 43 01 00 00       	call   802121 <nsipc_shutdown>
  801fde:	83 c4 10             	add    $0x10,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <connect>:
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	e8 d6 fe ff ff       	call   801ec7 <fd2sockid>
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	78 12                	js     802007 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	ff 75 10             	pushl  0x10(%ebp)
  801ffb:	ff 75 0c             	pushl  0xc(%ebp)
  801ffe:	50                   	push   %eax
  801fff:	e8 59 01 00 00       	call   80215d <nsipc_connect>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <listen>:
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	e8 b0 fe ff ff       	call   801ec7 <fd2sockid>
  802017:	85 c0                	test   %eax,%eax
  802019:	78 0f                	js     80202a <listen+0x21>
	return nsipc_listen(r, backlog);
  80201b:	83 ec 08             	sub    $0x8,%esp
  80201e:	ff 75 0c             	pushl  0xc(%ebp)
  802021:	50                   	push   %eax
  802022:	e8 6b 01 00 00       	call   802192 <nsipc_listen>
  802027:	83 c4 10             	add    $0x10,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <socket>:

int
socket(int domain, int type, int protocol)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802032:	ff 75 10             	pushl  0x10(%ebp)
  802035:	ff 75 0c             	pushl  0xc(%ebp)
  802038:	ff 75 08             	pushl  0x8(%ebp)
  80203b:	e8 3e 02 00 00       	call   80227e <nsipc_socket>
  802040:	83 c4 10             	add    $0x10,%esp
  802043:	85 c0                	test   %eax,%eax
  802045:	78 05                	js     80204c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802047:	e8 ab fe ff ff       	call   801ef7 <alloc_sockfd>
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	53                   	push   %ebx
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802057:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80205e:	74 26                	je     802086 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802060:	6a 07                	push   $0x7
  802062:	68 00 70 80 00       	push   $0x807000
  802067:	53                   	push   %ebx
  802068:	ff 35 04 50 80 00    	pushl  0x805004
  80206e:	e8 f6 07 00 00       	call   802869 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802073:	83 c4 0c             	add    $0xc,%esp
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	e8 7f 07 00 00       	call   802800 <ipc_recv>
}
  802081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802084:	c9                   	leave  
  802085:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	6a 02                	push   $0x2
  80208b:	e8 31 08 00 00       	call   8028c1 <ipc_find_env>
  802090:	a3 04 50 80 00       	mov    %eax,0x805004
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	eb c6                	jmp    802060 <nsipc+0x12>

0080209a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020aa:	8b 06                	mov    (%esi),%eax
  8020ac:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b6:	e8 93 ff ff ff       	call   80204e <nsipc>
  8020bb:	89 c3                	mov    %eax,%ebx
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	79 09                	jns    8020ca <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020c1:	89 d8                	mov    %ebx,%eax
  8020c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5e                   	pop    %esi
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	ff 35 10 70 80 00    	pushl  0x807010
  8020d3:	68 00 70 80 00       	push   $0x807000
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	e8 f5 ea ff ff       	call   800bd5 <memmove>
		*addrlen = ret->ret_addrlen;
  8020e0:	a1 10 70 80 00       	mov    0x807010,%eax
  8020e5:	89 06                	mov    %eax,(%esi)
  8020e7:	83 c4 10             	add    $0x10,%esp
	return r;
  8020ea:	eb d5                	jmp    8020c1 <nsipc_accept+0x27>

008020ec <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	53                   	push   %ebx
  8020f0:	83 ec 08             	sub    $0x8,%esp
  8020f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020fe:	53                   	push   %ebx
  8020ff:	ff 75 0c             	pushl  0xc(%ebp)
  802102:	68 04 70 80 00       	push   $0x807004
  802107:	e8 c9 ea ff ff       	call   800bd5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80210c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802112:	b8 02 00 00 00       	mov    $0x2,%eax
  802117:	e8 32 ff ff ff       	call   80204e <nsipc>
}
  80211c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80212f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802132:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802137:	b8 03 00 00 00       	mov    $0x3,%eax
  80213c:	e8 0d ff ff ff       	call   80204e <nsipc>
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <nsipc_close>:

int
nsipc_close(int s)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802151:	b8 04 00 00 00       	mov    $0x4,%eax
  802156:	e8 f3 fe ff ff       	call   80204e <nsipc>
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	53                   	push   %ebx
  802161:	83 ec 08             	sub    $0x8,%esp
  802164:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80216f:	53                   	push   %ebx
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	68 04 70 80 00       	push   $0x807004
  802178:	e8 58 ea ff ff       	call   800bd5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80217d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802183:	b8 05 00 00 00       	mov    $0x5,%eax
  802188:	e8 c1 fe ff ff       	call   80204e <nsipc>
}
  80218d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8021ad:	e8 9c fe ff ff       	call   80204e <nsipc>
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021c4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8021cd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8021d7:	e8 72 fe ff ff       	call   80204e <nsipc>
  8021dc:	89 c3                	mov    %eax,%ebx
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 1f                	js     802201 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021e2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021e7:	7f 21                	jg     80220a <nsipc_recv+0x56>
  8021e9:	39 c6                	cmp    %eax,%esi
  8021eb:	7c 1d                	jl     80220a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	50                   	push   %eax
  8021f1:	68 00 70 80 00       	push   $0x807000
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	e8 d7 e9 ff ff       	call   800bd5 <memmove>
  8021fe:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802201:	89 d8                	mov    %ebx,%eax
  802203:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802206:	5b                   	pop    %ebx
  802207:	5e                   	pop    %esi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80220a:	68 f3 31 80 00       	push   $0x8031f3
  80220f:	68 bb 31 80 00       	push   $0x8031bb
  802214:	6a 62                	push   $0x62
  802216:	68 08 32 80 00       	push   $0x803208
  80221b:	e8 d2 df ff ff       	call   8001f2 <_panic>

00802220 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	53                   	push   %ebx
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802232:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802238:	7f 2e                	jg     802268 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	53                   	push   %ebx
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	68 0c 70 80 00       	push   $0x80700c
  802246:	e8 8a e9 ff ff       	call   800bd5 <memmove>
	nsipcbuf.send.req_size = size;
  80224b:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802251:	8b 45 14             	mov    0x14(%ebp),%eax
  802254:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802259:	b8 08 00 00 00       	mov    $0x8,%eax
  80225e:	e8 eb fd ff ff       	call   80204e <nsipc>
}
  802263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802266:	c9                   	leave  
  802267:	c3                   	ret    
	assert(size < 1600);
  802268:	68 14 32 80 00       	push   $0x803214
  80226d:	68 bb 31 80 00       	push   $0x8031bb
  802272:	6a 6d                	push   $0x6d
  802274:	68 08 32 80 00       	push   $0x803208
  802279:	e8 74 df ff ff       	call   8001f2 <_panic>

0080227e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80229c:	b8 09 00 00 00       	mov    $0x9,%eax
  8022a1:	e8 a8 fd ff ff       	call   80204e <nsipc>
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	56                   	push   %esi
  8022ac:	53                   	push   %ebx
  8022ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	ff 75 08             	pushl  0x8(%ebp)
  8022b6:	e8 6a f3 ff ff       	call   801625 <fd2data>
  8022bb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	68 20 32 80 00       	push   $0x803220
  8022c5:	53                   	push   %ebx
  8022c6:	e8 7c e7 ff ff       	call   800a47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022cb:	8b 46 04             	mov    0x4(%esi),%eax
  8022ce:	2b 06                	sub    (%esi),%eax
  8022d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022dd:	00 00 00 
	stat->st_dev = &devpipe;
  8022e0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022e7:	40 80 00 
	return 0;
}
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f2:	5b                   	pop    %ebx
  8022f3:	5e                   	pop    %esi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	53                   	push   %ebx
  8022fa:	83 ec 0c             	sub    $0xc,%esp
  8022fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802300:	53                   	push   %ebx
  802301:	6a 00                	push   $0x0
  802303:	e8 b6 eb ff ff       	call   800ebe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802308:	89 1c 24             	mov    %ebx,(%esp)
  80230b:	e8 15 f3 ff ff       	call   801625 <fd2data>
  802310:	83 c4 08             	add    $0x8,%esp
  802313:	50                   	push   %eax
  802314:	6a 00                	push   $0x0
  802316:	e8 a3 eb ff ff       	call   800ebe <sys_page_unmap>
}
  80231b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <_pipeisclosed>:
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	57                   	push   %edi
  802324:	56                   	push   %esi
  802325:	53                   	push   %ebx
  802326:	83 ec 1c             	sub    $0x1c,%esp
  802329:	89 c7                	mov    %eax,%edi
  80232b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80232d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802332:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	57                   	push   %edi
  802339:	e8 be 05 00 00       	call   8028fc <pageref>
  80233e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802341:	89 34 24             	mov    %esi,(%esp)
  802344:	e8 b3 05 00 00       	call   8028fc <pageref>
		nn = thisenv->env_runs;
  802349:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  80234f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	39 cb                	cmp    %ecx,%ebx
  802357:	74 1b                	je     802374 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802359:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80235c:	75 cf                	jne    80232d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80235e:	8b 42 58             	mov    0x58(%edx),%eax
  802361:	6a 01                	push   $0x1
  802363:	50                   	push   %eax
  802364:	53                   	push   %ebx
  802365:	68 27 32 80 00       	push   $0x803227
  80236a:	e8 79 df ff ff       	call   8002e8 <cprintf>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	eb b9                	jmp    80232d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802374:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802377:	0f 94 c0             	sete   %al
  80237a:	0f b6 c0             	movzbl %al,%eax
}
  80237d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5f                   	pop    %edi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    

00802385 <devpipe_write>:
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	57                   	push   %edi
  802389:	56                   	push   %esi
  80238a:	53                   	push   %ebx
  80238b:	83 ec 28             	sub    $0x28,%esp
  80238e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802391:	56                   	push   %esi
  802392:	e8 8e f2 ff ff       	call   801625 <fd2data>
  802397:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	bf 00 00 00 00       	mov    $0x0,%edi
  8023a1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023a4:	74 4f                	je     8023f5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023a6:	8b 43 04             	mov    0x4(%ebx),%eax
  8023a9:	8b 0b                	mov    (%ebx),%ecx
  8023ab:	8d 51 20             	lea    0x20(%ecx),%edx
  8023ae:	39 d0                	cmp    %edx,%eax
  8023b0:	72 14                	jb     8023c6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023b2:	89 da                	mov    %ebx,%edx
  8023b4:	89 f0                	mov    %esi,%eax
  8023b6:	e8 65 ff ff ff       	call   802320 <_pipeisclosed>
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	75 3b                	jne    8023fa <devpipe_write+0x75>
			sys_yield();
  8023bf:	e8 56 ea ff ff       	call   800e1a <sys_yield>
  8023c4:	eb e0                	jmp    8023a6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023cd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023d0:	89 c2                	mov    %eax,%edx
  8023d2:	c1 fa 1f             	sar    $0x1f,%edx
  8023d5:	89 d1                	mov    %edx,%ecx
  8023d7:	c1 e9 1b             	shr    $0x1b,%ecx
  8023da:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023dd:	83 e2 1f             	and    $0x1f,%edx
  8023e0:	29 ca                	sub    %ecx,%edx
  8023e2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023ea:	83 c0 01             	add    $0x1,%eax
  8023ed:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023f0:	83 c7 01             	add    $0x1,%edi
  8023f3:	eb ac                	jmp    8023a1 <devpipe_write+0x1c>
	return i;
  8023f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f8:	eb 05                	jmp    8023ff <devpipe_write+0x7a>
				return 0;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802402:	5b                   	pop    %ebx
  802403:	5e                   	pop    %esi
  802404:	5f                   	pop    %edi
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    

00802407 <devpipe_read>:
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
  80240a:	57                   	push   %edi
  80240b:	56                   	push   %esi
  80240c:	53                   	push   %ebx
  80240d:	83 ec 18             	sub    $0x18,%esp
  802410:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802413:	57                   	push   %edi
  802414:	e8 0c f2 ff ff       	call   801625 <fd2data>
  802419:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	be 00 00 00 00       	mov    $0x0,%esi
  802423:	3b 75 10             	cmp    0x10(%ebp),%esi
  802426:	75 14                	jne    80243c <devpipe_read+0x35>
	return i;
  802428:	8b 45 10             	mov    0x10(%ebp),%eax
  80242b:	eb 02                	jmp    80242f <devpipe_read+0x28>
				return i;
  80242d:	89 f0                	mov    %esi,%eax
}
  80242f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802432:	5b                   	pop    %ebx
  802433:	5e                   	pop    %esi
  802434:	5f                   	pop    %edi
  802435:	5d                   	pop    %ebp
  802436:	c3                   	ret    
			sys_yield();
  802437:	e8 de e9 ff ff       	call   800e1a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80243c:	8b 03                	mov    (%ebx),%eax
  80243e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802441:	75 18                	jne    80245b <devpipe_read+0x54>
			if (i > 0)
  802443:	85 f6                	test   %esi,%esi
  802445:	75 e6                	jne    80242d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802447:	89 da                	mov    %ebx,%edx
  802449:	89 f8                	mov    %edi,%eax
  80244b:	e8 d0 fe ff ff       	call   802320 <_pipeisclosed>
  802450:	85 c0                	test   %eax,%eax
  802452:	74 e3                	je     802437 <devpipe_read+0x30>
				return 0;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	eb d4                	jmp    80242f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80245b:	99                   	cltd   
  80245c:	c1 ea 1b             	shr    $0x1b,%edx
  80245f:	01 d0                	add    %edx,%eax
  802461:	83 e0 1f             	and    $0x1f,%eax
  802464:	29 d0                	sub    %edx,%eax
  802466:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80246b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80246e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802471:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802474:	83 c6 01             	add    $0x1,%esi
  802477:	eb aa                	jmp    802423 <devpipe_read+0x1c>

00802479 <pipe>:
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	56                   	push   %esi
  80247d:	53                   	push   %ebx
  80247e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802484:	50                   	push   %eax
  802485:	e8 b2 f1 ff ff       	call   80163c <fd_alloc>
  80248a:	89 c3                	mov    %eax,%ebx
  80248c:	83 c4 10             	add    $0x10,%esp
  80248f:	85 c0                	test   %eax,%eax
  802491:	0f 88 23 01 00 00    	js     8025ba <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802497:	83 ec 04             	sub    $0x4,%esp
  80249a:	68 07 04 00 00       	push   $0x407
  80249f:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a2:	6a 00                	push   $0x0
  8024a4:	e8 90 e9 ff ff       	call   800e39 <sys_page_alloc>
  8024a9:	89 c3                	mov    %eax,%ebx
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	0f 88 04 01 00 00    	js     8025ba <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024b6:	83 ec 0c             	sub    $0xc,%esp
  8024b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024bc:	50                   	push   %eax
  8024bd:	e8 7a f1 ff ff       	call   80163c <fd_alloc>
  8024c2:	89 c3                	mov    %eax,%ebx
  8024c4:	83 c4 10             	add    $0x10,%esp
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	0f 88 db 00 00 00    	js     8025aa <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 07 04 00 00       	push   $0x407
  8024d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8024da:	6a 00                	push   $0x0
  8024dc:	e8 58 e9 ff ff       	call   800e39 <sys_page_alloc>
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	0f 88 bc 00 00 00    	js     8025aa <pipe+0x131>
	va = fd2data(fd0);
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f4:	e8 2c f1 ff ff       	call   801625 <fd2data>
  8024f9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024fb:	83 c4 0c             	add    $0xc,%esp
  8024fe:	68 07 04 00 00       	push   $0x407
  802503:	50                   	push   %eax
  802504:	6a 00                	push   $0x0
  802506:	e8 2e e9 ff ff       	call   800e39 <sys_page_alloc>
  80250b:	89 c3                	mov    %eax,%ebx
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	85 c0                	test   %eax,%eax
  802512:	0f 88 82 00 00 00    	js     80259a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	ff 75 f0             	pushl  -0x10(%ebp)
  80251e:	e8 02 f1 ff ff       	call   801625 <fd2data>
  802523:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80252a:	50                   	push   %eax
  80252b:	6a 00                	push   $0x0
  80252d:	56                   	push   %esi
  80252e:	6a 00                	push   $0x0
  802530:	e8 47 e9 ff ff       	call   800e7c <sys_page_map>
  802535:	89 c3                	mov    %eax,%ebx
  802537:	83 c4 20             	add    $0x20,%esp
  80253a:	85 c0                	test   %eax,%eax
  80253c:	78 4e                	js     80258c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80253e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802552:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802555:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	ff 75 f4             	pushl  -0xc(%ebp)
  802567:	e8 a9 f0 ff ff       	call   801615 <fd2num>
  80256c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80256f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802571:	83 c4 04             	add    $0x4,%esp
  802574:	ff 75 f0             	pushl  -0x10(%ebp)
  802577:	e8 99 f0 ff ff       	call   801615 <fd2num>
  80257c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80257f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	bb 00 00 00 00       	mov    $0x0,%ebx
  80258a:	eb 2e                	jmp    8025ba <pipe+0x141>
	sys_page_unmap(0, va);
  80258c:	83 ec 08             	sub    $0x8,%esp
  80258f:	56                   	push   %esi
  802590:	6a 00                	push   $0x0
  802592:	e8 27 e9 ff ff       	call   800ebe <sys_page_unmap>
  802597:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a0:	6a 00                	push   $0x0
  8025a2:	e8 17 e9 ff ff       	call   800ebe <sys_page_unmap>
  8025a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025aa:	83 ec 08             	sub    $0x8,%esp
  8025ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b0:	6a 00                	push   $0x0
  8025b2:	e8 07 e9 ff ff       	call   800ebe <sys_page_unmap>
  8025b7:	83 c4 10             	add    $0x10,%esp
}
  8025ba:	89 d8                	mov    %ebx,%eax
  8025bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025bf:	5b                   	pop    %ebx
  8025c0:	5e                   	pop    %esi
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    

008025c3 <pipeisclosed>:
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cc:	50                   	push   %eax
  8025cd:	ff 75 08             	pushl  0x8(%ebp)
  8025d0:	e8 b9 f0 ff ff       	call   80168e <fd_lookup>
  8025d5:	83 c4 10             	add    $0x10,%esp
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	78 18                	js     8025f4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025dc:	83 ec 0c             	sub    $0xc,%esp
  8025df:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e2:	e8 3e f0 ff ff       	call   801625 <fd2data>
	return _pipeisclosed(fd, p);
  8025e7:	89 c2                	mov    %eax,%edx
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	e8 2f fd ff ff       	call   802320 <_pipeisclosed>
  8025f1:	83 c4 10             	add    $0x10,%esp
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fb:	c3                   	ret    

008025fc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802602:	68 3f 32 80 00       	push   $0x80323f
  802607:	ff 75 0c             	pushl  0xc(%ebp)
  80260a:	e8 38 e4 ff ff       	call   800a47 <strcpy>
	return 0;
}
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <devcons_write>:
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	57                   	push   %edi
  80261a:	56                   	push   %esi
  80261b:	53                   	push   %ebx
  80261c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802622:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802627:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80262d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802630:	73 31                	jae    802663 <devcons_write+0x4d>
		m = n - tot;
  802632:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802635:	29 f3                	sub    %esi,%ebx
  802637:	83 fb 7f             	cmp    $0x7f,%ebx
  80263a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80263f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	53                   	push   %ebx
  802646:	89 f0                	mov    %esi,%eax
  802648:	03 45 0c             	add    0xc(%ebp),%eax
  80264b:	50                   	push   %eax
  80264c:	57                   	push   %edi
  80264d:	e8 83 e5 ff ff       	call   800bd5 <memmove>
		sys_cputs(buf, m);
  802652:	83 c4 08             	add    $0x8,%esp
  802655:	53                   	push   %ebx
  802656:	57                   	push   %edi
  802657:	e8 21 e7 ff ff       	call   800d7d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80265c:	01 de                	add    %ebx,%esi
  80265e:	83 c4 10             	add    $0x10,%esp
  802661:	eb ca                	jmp    80262d <devcons_write+0x17>
}
  802663:	89 f0                	mov    %esi,%eax
  802665:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802668:	5b                   	pop    %ebx
  802669:	5e                   	pop    %esi
  80266a:	5f                   	pop    %edi
  80266b:	5d                   	pop    %ebp
  80266c:	c3                   	ret    

0080266d <devcons_read>:
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
  802670:	83 ec 08             	sub    $0x8,%esp
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802678:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80267c:	74 21                	je     80269f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80267e:	e8 18 e7 ff ff       	call   800d9b <sys_cgetc>
  802683:	85 c0                	test   %eax,%eax
  802685:	75 07                	jne    80268e <devcons_read+0x21>
		sys_yield();
  802687:	e8 8e e7 ff ff       	call   800e1a <sys_yield>
  80268c:	eb f0                	jmp    80267e <devcons_read+0x11>
	if (c < 0)
  80268e:	78 0f                	js     80269f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802690:	83 f8 04             	cmp    $0x4,%eax
  802693:	74 0c                	je     8026a1 <devcons_read+0x34>
	*(char*)vbuf = c;
  802695:	8b 55 0c             	mov    0xc(%ebp),%edx
  802698:	88 02                	mov    %al,(%edx)
	return 1;
  80269a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    
		return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a6:	eb f7                	jmp    80269f <devcons_read+0x32>

008026a8 <cputchar>:
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026b4:	6a 01                	push   $0x1
  8026b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026b9:	50                   	push   %eax
  8026ba:	e8 be e6 ff ff       	call   800d7d <sys_cputs>
}
  8026bf:	83 c4 10             	add    $0x10,%esp
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <getchar>:
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026ca:	6a 01                	push   $0x1
  8026cc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026cf:	50                   	push   %eax
  8026d0:	6a 00                	push   $0x0
  8026d2:	e8 27 f2 ff ff       	call   8018fe <read>
	if (r < 0)
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	78 06                	js     8026e4 <getchar+0x20>
	if (r < 1)
  8026de:	74 06                	je     8026e6 <getchar+0x22>
	return c;
  8026e0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    
		return -E_EOF;
  8026e6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026eb:	eb f7                	jmp    8026e4 <getchar+0x20>

008026ed <iscons>:
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026f6:	50                   	push   %eax
  8026f7:	ff 75 08             	pushl  0x8(%ebp)
  8026fa:	e8 8f ef ff ff       	call   80168e <fd_lookup>
  8026ff:	83 c4 10             	add    $0x10,%esp
  802702:	85 c0                	test   %eax,%eax
  802704:	78 11                	js     802717 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80270f:	39 10                	cmp    %edx,(%eax)
  802711:	0f 94 c0             	sete   %al
  802714:	0f b6 c0             	movzbl %al,%eax
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <opencons>:
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80271f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802722:	50                   	push   %eax
  802723:	e8 14 ef ff ff       	call   80163c <fd_alloc>
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	85 c0                	test   %eax,%eax
  80272d:	78 3a                	js     802769 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 07 04 00 00       	push   $0x407
  802737:	ff 75 f4             	pushl  -0xc(%ebp)
  80273a:	6a 00                	push   $0x0
  80273c:	e8 f8 e6 ff ff       	call   800e39 <sys_page_alloc>
  802741:	83 c4 10             	add    $0x10,%esp
  802744:	85 c0                	test   %eax,%eax
  802746:	78 21                	js     802769 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802751:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80275d:	83 ec 0c             	sub    $0xc,%esp
  802760:	50                   	push   %eax
  802761:	e8 af ee ff ff       	call   801615 <fd2num>
  802766:	83 c4 10             	add    $0x10,%esp
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802771:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802778:	74 0a                	je     802784 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	6a 07                	push   $0x7
  802789:	68 00 f0 bf ee       	push   $0xeebff000
  80278e:	6a 00                	push   $0x0
  802790:	e8 a4 e6 ff ff       	call   800e39 <sys_page_alloc>
		if(r < 0)
  802795:	83 c4 10             	add    $0x10,%esp
  802798:	85 c0                	test   %eax,%eax
  80279a:	78 2a                	js     8027c6 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80279c:	83 ec 08             	sub    $0x8,%esp
  80279f:	68 da 27 80 00       	push   $0x8027da
  8027a4:	6a 00                	push   $0x0
  8027a6:	e8 d9 e7 ff ff       	call   800f84 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027ab:	83 c4 10             	add    $0x10,%esp
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	79 c8                	jns    80277a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027b2:	83 ec 04             	sub    $0x4,%esp
  8027b5:	68 7c 32 80 00       	push   $0x80327c
  8027ba:	6a 25                	push   $0x25
  8027bc:	68 b8 32 80 00       	push   $0x8032b8
  8027c1:	e8 2c da ff ff       	call   8001f2 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027c6:	83 ec 04             	sub    $0x4,%esp
  8027c9:	68 4c 32 80 00       	push   $0x80324c
  8027ce:	6a 22                	push   $0x22
  8027d0:	68 b8 32 80 00       	push   $0x8032b8
  8027d5:	e8 18 da ff ff       	call   8001f2 <_panic>

008027da <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027da:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027db:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027e0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027e2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027e5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027e9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027ed:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027f0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027f2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027f6:	83 c4 08             	add    $0x8,%esp
	popal
  8027f9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027fa:	83 c4 04             	add    $0x4,%esp
	popfl
  8027fd:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027fe:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8027ff:	c3                   	ret    

00802800 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	56                   	push   %esi
  802804:	53                   	push   %ebx
  802805:	8b 75 08             	mov    0x8(%ebp),%esi
  802808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80280e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802810:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802815:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	50                   	push   %eax
  80281c:	e8 c8 e7 ff ff       	call   800fe9 <sys_ipc_recv>
	if(ret < 0){
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	85 c0                	test   %eax,%eax
  802826:	78 2b                	js     802853 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802828:	85 f6                	test   %esi,%esi
  80282a:	74 0a                	je     802836 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80282c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802831:	8b 40 74             	mov    0x74(%eax),%eax
  802834:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802836:	85 db                	test   %ebx,%ebx
  802838:	74 0a                	je     802844 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80283a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80283f:	8b 40 78             	mov    0x78(%eax),%eax
  802842:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802844:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802849:	8b 40 70             	mov    0x70(%eax),%eax
}
  80284c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80284f:	5b                   	pop    %ebx
  802850:	5e                   	pop    %esi
  802851:	5d                   	pop    %ebp
  802852:	c3                   	ret    
		if(from_env_store)
  802853:	85 f6                	test   %esi,%esi
  802855:	74 06                	je     80285d <ipc_recv+0x5d>
			*from_env_store = 0;
  802857:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80285d:	85 db                	test   %ebx,%ebx
  80285f:	74 eb                	je     80284c <ipc_recv+0x4c>
			*perm_store = 0;
  802861:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802867:	eb e3                	jmp    80284c <ipc_recv+0x4c>

00802869 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	57                   	push   %edi
  80286d:	56                   	push   %esi
  80286e:	53                   	push   %ebx
  80286f:	83 ec 0c             	sub    $0xc,%esp
  802872:	8b 7d 08             	mov    0x8(%ebp),%edi
  802875:	8b 75 0c             	mov    0xc(%ebp),%esi
  802878:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80287b:	85 db                	test   %ebx,%ebx
  80287d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802882:	0f 44 d8             	cmove  %eax,%ebx
  802885:	eb 05                	jmp    80288c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802887:	e8 8e e5 ff ff       	call   800e1a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80288c:	ff 75 14             	pushl  0x14(%ebp)
  80288f:	53                   	push   %ebx
  802890:	56                   	push   %esi
  802891:	57                   	push   %edi
  802892:	e8 2f e7 ff ff       	call   800fc6 <sys_ipc_try_send>
  802897:	83 c4 10             	add    $0x10,%esp
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 1b                	je     8028b9 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80289e:	79 e7                	jns    802887 <ipc_send+0x1e>
  8028a0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028a3:	74 e2                	je     802887 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 c6 32 80 00       	push   $0x8032c6
  8028ad:	6a 46                	push   $0x46
  8028af:	68 db 32 80 00       	push   $0x8032db
  8028b4:	e8 39 d9 ff ff       	call   8001f2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028bc:	5b                   	pop    %ebx
  8028bd:	5e                   	pop    %esi
  8028be:	5f                   	pop    %edi
  8028bf:	5d                   	pop    %ebp
  8028c0:	c3                   	ret    

008028c1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028cc:	89 c2                	mov    %eax,%edx
  8028ce:	c1 e2 07             	shl    $0x7,%edx
  8028d1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028d7:	8b 52 50             	mov    0x50(%edx),%edx
  8028da:	39 ca                	cmp    %ecx,%edx
  8028dc:	74 11                	je     8028ef <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028de:	83 c0 01             	add    $0x1,%eax
  8028e1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028e6:	75 e4                	jne    8028cc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ed:	eb 0b                	jmp    8028fa <ipc_find_env+0x39>
			return envs[i].env_id;
  8028ef:	c1 e0 07             	shl    $0x7,%eax
  8028f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8028f7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8028fa:	5d                   	pop    %ebp
  8028fb:	c3                   	ret    

008028fc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802902:	89 d0                	mov    %edx,%eax
  802904:	c1 e8 16             	shr    $0x16,%eax
  802907:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802913:	f6 c1 01             	test   $0x1,%cl
  802916:	74 1d                	je     802935 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802918:	c1 ea 0c             	shr    $0xc,%edx
  80291b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802922:	f6 c2 01             	test   $0x1,%dl
  802925:	74 0e                	je     802935 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802927:	c1 ea 0c             	shr    $0xc,%edx
  80292a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802931:	ef 
  802932:	0f b7 c0             	movzwl %ax,%eax
}
  802935:	5d                   	pop    %ebp
  802936:	c3                   	ret    
  802937:	66 90                	xchg   %ax,%ax
  802939:	66 90                	xchg   %ax,%ax
  80293b:	66 90                	xchg   %ax,%ax
  80293d:	66 90                	xchg   %ax,%ax
  80293f:	90                   	nop

00802940 <__udivdi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	53                   	push   %ebx
  802944:	83 ec 1c             	sub    $0x1c,%esp
  802947:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80294b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80294f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802953:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802957:	85 d2                	test   %edx,%edx
  802959:	75 4d                	jne    8029a8 <__udivdi3+0x68>
  80295b:	39 f3                	cmp    %esi,%ebx
  80295d:	76 19                	jbe    802978 <__udivdi3+0x38>
  80295f:	31 ff                	xor    %edi,%edi
  802961:	89 e8                	mov    %ebp,%eax
  802963:	89 f2                	mov    %esi,%edx
  802965:	f7 f3                	div    %ebx
  802967:	89 fa                	mov    %edi,%edx
  802969:	83 c4 1c             	add    $0x1c,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5f                   	pop    %edi
  80296f:	5d                   	pop    %ebp
  802970:	c3                   	ret    
  802971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802978:	89 d9                	mov    %ebx,%ecx
  80297a:	85 db                	test   %ebx,%ebx
  80297c:	75 0b                	jne    802989 <__udivdi3+0x49>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	31 d2                	xor    %edx,%edx
  802985:	f7 f3                	div    %ebx
  802987:	89 c1                	mov    %eax,%ecx
  802989:	31 d2                	xor    %edx,%edx
  80298b:	89 f0                	mov    %esi,%eax
  80298d:	f7 f1                	div    %ecx
  80298f:	89 c6                	mov    %eax,%esi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f7                	mov    %esi,%edi
  802995:	f7 f1                	div    %ecx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	39 f2                	cmp    %esi,%edx
  8029aa:	77 1c                	ja     8029c8 <__udivdi3+0x88>
  8029ac:	0f bd fa             	bsr    %edx,%edi
  8029af:	83 f7 1f             	xor    $0x1f,%edi
  8029b2:	75 2c                	jne    8029e0 <__udivdi3+0xa0>
  8029b4:	39 f2                	cmp    %esi,%edx
  8029b6:	72 06                	jb     8029be <__udivdi3+0x7e>
  8029b8:	31 c0                	xor    %eax,%eax
  8029ba:	39 eb                	cmp    %ebp,%ebx
  8029bc:	77 a9                	ja     802967 <__udivdi3+0x27>
  8029be:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c3:	eb a2                	jmp    802967 <__udivdi3+0x27>
  8029c5:	8d 76 00             	lea    0x0(%esi),%esi
  8029c8:	31 ff                	xor    %edi,%edi
  8029ca:	31 c0                	xor    %eax,%eax
  8029cc:	89 fa                	mov    %edi,%edx
  8029ce:	83 c4 1c             	add    $0x1c,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5f                   	pop    %edi
  8029d4:	5d                   	pop    %ebp
  8029d5:	c3                   	ret    
  8029d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	89 f9                	mov    %edi,%ecx
  8029e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029e7:	29 f8                	sub    %edi,%eax
  8029e9:	d3 e2                	shl    %cl,%edx
  8029eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ef:	89 c1                	mov    %eax,%ecx
  8029f1:	89 da                	mov    %ebx,%edx
  8029f3:	d3 ea                	shr    %cl,%edx
  8029f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029f9:	09 d1                	or     %edx,%ecx
  8029fb:	89 f2                	mov    %esi,%edx
  8029fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a01:	89 f9                	mov    %edi,%ecx
  802a03:	d3 e3                	shl    %cl,%ebx
  802a05:	89 c1                	mov    %eax,%ecx
  802a07:	d3 ea                	shr    %cl,%edx
  802a09:	89 f9                	mov    %edi,%ecx
  802a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a0f:	89 eb                	mov    %ebp,%ebx
  802a11:	d3 e6                	shl    %cl,%esi
  802a13:	89 c1                	mov    %eax,%ecx
  802a15:	d3 eb                	shr    %cl,%ebx
  802a17:	09 de                	or     %ebx,%esi
  802a19:	89 f0                	mov    %esi,%eax
  802a1b:	f7 74 24 08          	divl   0x8(%esp)
  802a1f:	89 d6                	mov    %edx,%esi
  802a21:	89 c3                	mov    %eax,%ebx
  802a23:	f7 64 24 0c          	mull   0xc(%esp)
  802a27:	39 d6                	cmp    %edx,%esi
  802a29:	72 15                	jb     802a40 <__udivdi3+0x100>
  802a2b:	89 f9                	mov    %edi,%ecx
  802a2d:	d3 e5                	shl    %cl,%ebp
  802a2f:	39 c5                	cmp    %eax,%ebp
  802a31:	73 04                	jae    802a37 <__udivdi3+0xf7>
  802a33:	39 d6                	cmp    %edx,%esi
  802a35:	74 09                	je     802a40 <__udivdi3+0x100>
  802a37:	89 d8                	mov    %ebx,%eax
  802a39:	31 ff                	xor    %edi,%edi
  802a3b:	e9 27 ff ff ff       	jmp    802967 <__udivdi3+0x27>
  802a40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a43:	31 ff                	xor    %edi,%edi
  802a45:	e9 1d ff ff ff       	jmp    802967 <__udivdi3+0x27>
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	66 90                	xchg   %ax,%ax
  802a4e:	66 90                	xchg   %ax,%ax

00802a50 <__umoddi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	83 ec 1c             	sub    $0x1c,%esp
  802a57:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a5f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a67:	89 da                	mov    %ebx,%edx
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	75 43                	jne    802ab0 <__umoddi3+0x60>
  802a6d:	39 df                	cmp    %ebx,%edi
  802a6f:	76 17                	jbe    802a88 <__umoddi3+0x38>
  802a71:	89 f0                	mov    %esi,%eax
  802a73:	f7 f7                	div    %edi
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	31 d2                	xor    %edx,%edx
  802a79:	83 c4 1c             	add    $0x1c,%esp
  802a7c:	5b                   	pop    %ebx
  802a7d:	5e                   	pop    %esi
  802a7e:	5f                   	pop    %edi
  802a7f:	5d                   	pop    %ebp
  802a80:	c3                   	ret    
  802a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 fd                	mov    %edi,%ebp
  802a8a:	85 ff                	test   %edi,%edi
  802a8c:	75 0b                	jne    802a99 <__umoddi3+0x49>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f7                	div    %edi
  802a97:	89 c5                	mov    %eax,%ebp
  802a99:	89 d8                	mov    %ebx,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f5                	div    %ebp
  802a9f:	89 f0                	mov    %esi,%eax
  802aa1:	f7 f5                	div    %ebp
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	eb d0                	jmp    802a77 <__umoddi3+0x27>
  802aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aae:	66 90                	xchg   %ax,%ax
  802ab0:	89 f1                	mov    %esi,%ecx
  802ab2:	39 d8                	cmp    %ebx,%eax
  802ab4:	76 0a                	jbe    802ac0 <__umoddi3+0x70>
  802ab6:	89 f0                	mov    %esi,%eax
  802ab8:	83 c4 1c             	add    $0x1c,%esp
  802abb:	5b                   	pop    %ebx
  802abc:	5e                   	pop    %esi
  802abd:	5f                   	pop    %edi
  802abe:	5d                   	pop    %ebp
  802abf:	c3                   	ret    
  802ac0:	0f bd e8             	bsr    %eax,%ebp
  802ac3:	83 f5 1f             	xor    $0x1f,%ebp
  802ac6:	75 20                	jne    802ae8 <__umoddi3+0x98>
  802ac8:	39 d8                	cmp    %ebx,%eax
  802aca:	0f 82 b0 00 00 00    	jb     802b80 <__umoddi3+0x130>
  802ad0:	39 f7                	cmp    %esi,%edi
  802ad2:	0f 86 a8 00 00 00    	jbe    802b80 <__umoddi3+0x130>
  802ad8:	89 c8                	mov    %ecx,%eax
  802ada:	83 c4 1c             	add    $0x1c,%esp
  802add:	5b                   	pop    %ebx
  802ade:	5e                   	pop    %esi
  802adf:	5f                   	pop    %edi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    
  802ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	ba 20 00 00 00       	mov    $0x20,%edx
  802aef:	29 ea                	sub    %ebp,%edx
  802af1:	d3 e0                	shl    %cl,%eax
  802af3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af7:	89 d1                	mov    %edx,%ecx
  802af9:	89 f8                	mov    %edi,%eax
  802afb:	d3 e8                	shr    %cl,%eax
  802afd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b01:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b05:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b09:	09 c1                	or     %eax,%ecx
  802b0b:	89 d8                	mov    %ebx,%eax
  802b0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b11:	89 e9                	mov    %ebp,%ecx
  802b13:	d3 e7                	shl    %cl,%edi
  802b15:	89 d1                	mov    %edx,%ecx
  802b17:	d3 e8                	shr    %cl,%eax
  802b19:	89 e9                	mov    %ebp,%ecx
  802b1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b1f:	d3 e3                	shl    %cl,%ebx
  802b21:	89 c7                	mov    %eax,%edi
  802b23:	89 d1                	mov    %edx,%ecx
  802b25:	89 f0                	mov    %esi,%eax
  802b27:	d3 e8                	shr    %cl,%eax
  802b29:	89 e9                	mov    %ebp,%ecx
  802b2b:	89 fa                	mov    %edi,%edx
  802b2d:	d3 e6                	shl    %cl,%esi
  802b2f:	09 d8                	or     %ebx,%eax
  802b31:	f7 74 24 08          	divl   0x8(%esp)
  802b35:	89 d1                	mov    %edx,%ecx
  802b37:	89 f3                	mov    %esi,%ebx
  802b39:	f7 64 24 0c          	mull   0xc(%esp)
  802b3d:	89 c6                	mov    %eax,%esi
  802b3f:	89 d7                	mov    %edx,%edi
  802b41:	39 d1                	cmp    %edx,%ecx
  802b43:	72 06                	jb     802b4b <__umoddi3+0xfb>
  802b45:	75 10                	jne    802b57 <__umoddi3+0x107>
  802b47:	39 c3                	cmp    %eax,%ebx
  802b49:	73 0c                	jae    802b57 <__umoddi3+0x107>
  802b4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b53:	89 d7                	mov    %edx,%edi
  802b55:	89 c6                	mov    %eax,%esi
  802b57:	89 ca                	mov    %ecx,%edx
  802b59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b5e:	29 f3                	sub    %esi,%ebx
  802b60:	19 fa                	sbb    %edi,%edx
  802b62:	89 d0                	mov    %edx,%eax
  802b64:	d3 e0                	shl    %cl,%eax
  802b66:	89 e9                	mov    %ebp,%ecx
  802b68:	d3 eb                	shr    %cl,%ebx
  802b6a:	d3 ea                	shr    %cl,%edx
  802b6c:	09 d8                	or     %ebx,%eax
  802b6e:	83 c4 1c             	add    $0x1c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    
  802b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b7d:	8d 76 00             	lea    0x0(%esi),%esi
  802b80:	89 da                	mov    %ebx,%edx
  802b82:	29 fe                	sub    %edi,%esi
  802b84:	19 c2                	sbb    %eax,%edx
  802b86:	89 f1                	mov    %esi,%ecx
  802b88:	89 c8                	mov    %ecx,%eax
  802b8a:	e9 4b ff ff ff       	jmp    802ada <__umoddi3+0x8a>
