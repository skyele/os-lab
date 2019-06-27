
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
  80002c:	e8 b5 00 00 00       	call   8000e6 <libmain>
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
  800038:	e8 c1 0d 00 00       	call   800dfe <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 3d 13 00 00       	call   801386 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 c3 0d 00 00       	call   800e1d <sys_yield>
		return;
  80005a:	eb 6c                	jmp    8000c8 <umain+0x95>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80005c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800062:	69 d6 84 00 00 00    	imul   $0x84,%esi,%edx
  800068:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80006e:	eb 02                	jmp    800072 <umain+0x3f>
		asm volatile("pause");
  800070:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800072:	8b 42 54             	mov    0x54(%edx),%eax
  800075:	85 c0                	test   %eax,%eax
  800077:	75 f7                	jne    800070 <umain+0x3d>
  800079:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007e:	e8 9a 0d 00 00       	call   800e1d <sys_yield>
  800083:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800088:	a1 08 50 80 00       	mov    0x805008,%eax
  80008d:	83 c0 01             	add    $0x1,%eax
  800090:	a3 08 50 80 00       	mov    %eax,0x805008
		for (j = 0; j < 10000; j++)
  800095:	83 ea 01             	sub    $0x1,%edx
  800098:	75 ee                	jne    800088 <umain+0x55>
	for (i = 0; i < 10; i++) {
  80009a:	83 eb 01             	sub    $0x1,%ebx
  80009d:	75 df                	jne    80007e <umain+0x4b>
	}

	if (counter != 10*10000)
  80009f:	a1 08 50 80 00       	mov    0x805008,%eax
  8000a4:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000a9:	75 24                	jne    8000cf <umain+0x9c>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ab:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000b0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b3:	8b 40 48             	mov    0x48(%eax),%eax
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	52                   	push   %edx
  8000ba:	50                   	push   %eax
  8000bb:	68 db 2b 80 00       	push   $0x802bdb
  8000c0:	e8 26 02 00 00       	call   8002eb <cprintf>
  8000c5:	83 c4 10             	add    $0x10,%esp

}
  8000c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cb:	5b                   	pop    %ebx
  8000cc:	5e                   	pop    %esi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d4:	50                   	push   %eax
  8000d5:	68 a0 2b 80 00       	push   $0x802ba0
  8000da:	6a 21                	push   $0x21
  8000dc:	68 c8 2b 80 00       	push   $0x802bc8
  8000e1:	e8 0f 01 00 00       	call   8001f5 <_panic>

008000e6 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
  8000ec:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ef:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8000f6:	00 00 00 
	envid_t find = sys_getenvid();
  8000f9:	e8 00 0d 00 00       	call   800dfe <sys_getenvid>
  8000fe:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  800104:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800109:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010e:	bf 01 00 00 00       	mov    $0x1,%edi
  800113:	eb 0b                	jmp    800120 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800115:	83 c2 01             	add    $0x1,%edx
  800118:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011e:	74 23                	je     800143 <libmain+0x5d>
		if(envs[i].env_id == find)
  800120:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800126:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80012c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012f:	39 c1                	cmp    %eax,%ecx
  800131:	75 e2                	jne    800115 <libmain+0x2f>
  800133:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800139:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013f:	89 fe                	mov    %edi,%esi
  800141:	eb d2                	jmp    800115 <libmain+0x2f>
  800143:	89 f0                	mov    %esi,%eax
  800145:	84 c0                	test   %al,%al
  800147:	74 06                	je     80014f <libmain+0x69>
  800149:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800153:	7e 0a                	jle    80015f <libmain+0x79>
		binaryname = argv[0];
  800155:	8b 45 0c             	mov    0xc(%ebp),%eax
  800158:	8b 00                	mov    (%eax),%eax
  80015a:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800164:	8b 40 48             	mov    0x48(%eax),%eax
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	50                   	push   %eax
  80016b:	68 f9 2b 80 00       	push   $0x802bf9
  800170:	e8 76 01 00 00       	call   8002eb <cprintf>
	cprintf("before umain\n");
  800175:	c7 04 24 17 2c 80 00 	movl   $0x802c17,(%esp)
  80017c:	e8 6a 01 00 00       	call   8002eb <cprintf>
	// call user main routine
	umain(argc, argv);
  800181:	83 c4 08             	add    $0x8,%esp
  800184:	ff 75 0c             	pushl  0xc(%ebp)
  800187:	ff 75 08             	pushl  0x8(%ebp)
  80018a:	e8 a4 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018f:	c7 04 24 25 2c 80 00 	movl   $0x802c25,(%esp)
  800196:	e8 50 01 00 00       	call   8002eb <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80019b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001a0:	8b 40 48             	mov    0x48(%eax),%eax
  8001a3:	83 c4 08             	add    $0x8,%esp
  8001a6:	50                   	push   %eax
  8001a7:	68 32 2c 80 00       	push   $0x802c32
  8001ac:	e8 3a 01 00 00       	call   8002eb <cprintf>
	// exit gracefully
	exit();
  8001b1:	e8 0b 00 00 00       	call   8001c1 <exit>
}
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bc:	5b                   	pop    %ebx
  8001bd:	5e                   	pop    %esi
  8001be:	5f                   	pop    %edi
  8001bf:	5d                   	pop    %ebp
  8001c0:	c3                   	ret    

008001c1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001cc:	8b 40 48             	mov    0x48(%eax),%eax
  8001cf:	68 5c 2c 80 00       	push   $0x802c5c
  8001d4:	50                   	push   %eax
  8001d5:	68 51 2c 80 00       	push   $0x802c51
  8001da:	e8 0c 01 00 00       	call   8002eb <cprintf>
	close_all();
  8001df:	e8 12 16 00 00       	call   8017f6 <close_all>
	sys_env_destroy(0);
  8001e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001eb:	e8 cd 0b 00 00       	call   800dbd <sys_env_destroy>
}
  8001f0:	83 c4 10             	add    $0x10,%esp
  8001f3:	c9                   	leave  
  8001f4:	c3                   	ret    

008001f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8001ff:	8b 40 48             	mov    0x48(%eax),%eax
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	68 88 2c 80 00       	push   $0x802c88
  80020a:	50                   	push   %eax
  80020b:	68 51 2c 80 00       	push   $0x802c51
  800210:	e8 d6 00 00 00       	call   8002eb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800215:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800218:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80021e:	e8 db 0b 00 00       	call   800dfe <sys_getenvid>
  800223:	83 c4 04             	add    $0x4,%esp
  800226:	ff 75 0c             	pushl  0xc(%ebp)
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	56                   	push   %esi
  80022d:	50                   	push   %eax
  80022e:	68 64 2c 80 00       	push   $0x802c64
  800233:	e8 b3 00 00 00       	call   8002eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800238:	83 c4 18             	add    $0x18,%esp
  80023b:	53                   	push   %ebx
  80023c:	ff 75 10             	pushl  0x10(%ebp)
  80023f:	e8 56 00 00 00       	call   80029a <vcprintf>
	cprintf("\n");
  800244:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  80024b:	e8 9b 00 00 00       	call   8002eb <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800253:	cc                   	int3   
  800254:	eb fd                	jmp    800253 <_panic+0x5e>

00800256 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	53                   	push   %ebx
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800260:	8b 13                	mov    (%ebx),%edx
  800262:	8d 42 01             	lea    0x1(%edx),%eax
  800265:	89 03                	mov    %eax,(%ebx)
  800267:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800273:	74 09                	je     80027e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800275:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800279:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	68 ff 00 00 00       	push   $0xff
  800286:	8d 43 08             	lea    0x8(%ebx),%eax
  800289:	50                   	push   %eax
  80028a:	e8 f1 0a 00 00       	call   800d80 <sys_cputs>
		b->idx = 0;
  80028f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	eb db                	jmp    800275 <putch+0x1f>

0080029a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002aa:	00 00 00 
	b.cnt = 0;
  8002ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	68 56 02 80 00       	push   $0x800256
  8002c9:	e8 4a 01 00 00       	call   800418 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ce:	83 c4 08             	add    $0x8,%esp
  8002d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 9d 0a 00 00       	call   800d80 <sys_cputs>

	return b.cnt;
}
  8002e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f4:	50                   	push   %eax
  8002f5:	ff 75 08             	pushl  0x8(%ebp)
  8002f8:	e8 9d ff ff ff       	call   80029a <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	57                   	push   %edi
  800303:	56                   	push   %esi
  800304:	53                   	push   %ebx
  800305:	83 ec 1c             	sub    $0x1c,%esp
  800308:	89 c6                	mov    %eax,%esi
  80030a:	89 d7                	mov    %edx,%edi
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800312:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800315:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80031e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800322:	74 2c                	je     800350 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800324:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800327:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80032e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800331:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800334:	39 c2                	cmp    %eax,%edx
  800336:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800339:	73 43                	jae    80037e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80033b:	83 eb 01             	sub    $0x1,%ebx
  80033e:	85 db                	test   %ebx,%ebx
  800340:	7e 6c                	jle    8003ae <printnum+0xaf>
				putch(padc, putdat);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	57                   	push   %edi
  800346:	ff 75 18             	pushl  0x18(%ebp)
  800349:	ff d6                	call   *%esi
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	eb eb                	jmp    80033b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	6a 20                	push   $0x20
  800355:	6a 00                	push   $0x0
  800357:	50                   	push   %eax
  800358:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035b:	ff 75 e0             	pushl  -0x20(%ebp)
  80035e:	89 fa                	mov    %edi,%edx
  800360:	89 f0                	mov    %esi,%eax
  800362:	e8 98 ff ff ff       	call   8002ff <printnum>
		while (--width > 0)
  800367:	83 c4 20             	add    $0x20,%esp
  80036a:	83 eb 01             	sub    $0x1,%ebx
  80036d:	85 db                	test   %ebx,%ebx
  80036f:	7e 65                	jle    8003d6 <printnum+0xd7>
			putch(padc, putdat);
  800371:	83 ec 08             	sub    $0x8,%esp
  800374:	57                   	push   %edi
  800375:	6a 20                	push   $0x20
  800377:	ff d6                	call   *%esi
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	eb ec                	jmp    80036a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80037e:	83 ec 0c             	sub    $0xc,%esp
  800381:	ff 75 18             	pushl  0x18(%ebp)
  800384:	83 eb 01             	sub    $0x1,%ebx
  800387:	53                   	push   %ebx
  800388:	50                   	push   %eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 dc             	pushl  -0x24(%ebp)
  80038f:	ff 75 d8             	pushl  -0x28(%ebp)
  800392:	ff 75 e4             	pushl  -0x1c(%ebp)
  800395:	ff 75 e0             	pushl  -0x20(%ebp)
  800398:	e8 b3 25 00 00       	call   802950 <__udivdi3>
  80039d:	83 c4 18             	add    $0x18,%esp
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	89 fa                	mov    %edi,%edx
  8003a4:	89 f0                	mov    %esi,%eax
  8003a6:	e8 54 ff ff ff       	call   8002ff <printnum>
  8003ab:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	57                   	push   %edi
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003be:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c1:	e8 9a 26 00 00       	call   802a60 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 8f 2c 80 00 	movsbl 0x802c8f(%eax),%eax
  8003d0:	50                   	push   %eax
  8003d1:	ff d6                	call   *%esi
  8003d3:	83 c4 10             	add    $0x10,%esp
	}
}
  8003d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003e8:	8b 10                	mov    (%eax),%edx
  8003ea:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ed:	73 0a                	jae    8003f9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f2:	89 08                	mov    %ecx,(%eax)
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	88 02                	mov    %al,(%edx)
}
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <printfmt>:
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800401:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800404:	50                   	push   %eax
  800405:	ff 75 10             	pushl  0x10(%ebp)
  800408:	ff 75 0c             	pushl  0xc(%ebp)
  80040b:	ff 75 08             	pushl  0x8(%ebp)
  80040e:	e8 05 00 00 00       	call   800418 <vprintfmt>
}
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	c9                   	leave  
  800417:	c3                   	ret    

00800418 <vprintfmt>:
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	57                   	push   %edi
  80041c:	56                   	push   %esi
  80041d:	53                   	push   %ebx
  80041e:	83 ec 3c             	sub    $0x3c,%esp
  800421:	8b 75 08             	mov    0x8(%ebp),%esi
  800424:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800427:	8b 7d 10             	mov    0x10(%ebp),%edi
  80042a:	e9 32 04 00 00       	jmp    800861 <vprintfmt+0x449>
		padc = ' ';
  80042f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800433:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80043a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800441:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800448:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80044f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800456:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8d 47 01             	lea    0x1(%edi),%eax
  80045e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800461:	0f b6 17             	movzbl (%edi),%edx
  800464:	8d 42 dd             	lea    -0x23(%edx),%eax
  800467:	3c 55                	cmp    $0x55,%al
  800469:	0f 87 12 05 00 00    	ja     800981 <vprintfmt+0x569>
  80046f:	0f b6 c0             	movzbl %al,%eax
  800472:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
  800479:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800480:	eb d9                	jmp    80045b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800485:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800489:	eb d0                	jmp    80045b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	0f b6 d2             	movzbl %dl,%edx
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800491:	b8 00 00 00 00       	mov    $0x0,%eax
  800496:	89 75 08             	mov    %esi,0x8(%ebp)
  800499:	eb 03                	jmp    80049e <vprintfmt+0x86>
  80049b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80049e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a8:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004ab:	83 fe 09             	cmp    $0x9,%esi
  8004ae:	76 eb                	jbe    80049b <vprintfmt+0x83>
  8004b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b6:	eb 14                	jmp    8004cc <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c3:	8d 40 04             	lea    0x4(%eax),%eax
  8004c6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d0:	79 89                	jns    80045b <vprintfmt+0x43>
				width = precision, precision = -1;
  8004d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004df:	e9 77 ff ff ff       	jmp    80045b <vprintfmt+0x43>
  8004e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e7:	85 c0                	test   %eax,%eax
  8004e9:	0f 48 c1             	cmovs  %ecx,%eax
  8004ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f2:	e9 64 ff ff ff       	jmp    80045b <vprintfmt+0x43>
  8004f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004fa:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800501:	e9 55 ff ff ff       	jmp    80045b <vprintfmt+0x43>
			lflag++;
  800506:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050d:	e9 49 ff ff ff       	jmp    80045b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 30                	pushl  (%eax)
  80051e:	ff d6                	call   *%esi
			break;
  800520:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800526:	e9 33 03 00 00       	jmp    80085e <vprintfmt+0x446>
			err = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 78 04             	lea    0x4(%eax),%edi
  800531:	8b 00                	mov    (%eax),%eax
  800533:	99                   	cltd   
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 11             	cmp    $0x11,%eax
  80053b:	7f 23                	jg     800560 <vprintfmt+0x148>
  80053d:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 18                	je     800560 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 cd 31 80 00       	push   $0x8031cd
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 a6 fe ff ff       	call   8003fb <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055b:	e9 fe 02 00 00       	jmp    80085e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800560:	50                   	push   %eax
  800561:	68 a7 2c 80 00       	push   $0x802ca7
  800566:	53                   	push   %ebx
  800567:	56                   	push   %esi
  800568:	e8 8e fe ff ff       	call   8003fb <printfmt>
  80056d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800570:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800573:	e9 e6 02 00 00       	jmp    80085e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	83 c0 04             	add    $0x4,%eax
  80057e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800586:	85 c9                	test   %ecx,%ecx
  800588:	b8 a0 2c 80 00       	mov    $0x802ca0,%eax
  80058d:	0f 45 c1             	cmovne %ecx,%eax
  800590:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x187>
  800599:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80059d:	75 0d                	jne    8005ac <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	eb 53                	jmp    8005ff <vprintfmt+0x1e7>
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b2:	50                   	push   %eax
  8005b3:	e8 71 04 00 00       	call   800a29 <strnlen>
  8005b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bb:	29 c1                	sub    %eax,%ecx
  8005bd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005c5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cc:	eb 0f                	jmp    8005dd <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d7:	83 ef 01             	sub    $0x1,%edi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	85 ff                	test   %edi,%edi
  8005df:	7f ed                	jg     8005ce <vprintfmt+0x1b6>
  8005e1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005e4:	85 c9                	test   %ecx,%ecx
  8005e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005eb:	0f 49 c1             	cmovns %ecx,%eax
  8005ee:	29 c1                	sub    %eax,%ecx
  8005f0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005f3:	eb aa                	jmp    80059f <vprintfmt+0x187>
					putch(ch, putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	52                   	push   %edx
  8005fa:	ff d6                	call   *%esi
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800602:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800604:	83 c7 01             	add    $0x1,%edi
  800607:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060b:	0f be d0             	movsbl %al,%edx
  80060e:	85 d2                	test   %edx,%edx
  800610:	74 4b                	je     80065d <vprintfmt+0x245>
  800612:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800616:	78 06                	js     80061e <vprintfmt+0x206>
  800618:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061c:	78 1e                	js     80063c <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80061e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800622:	74 d1                	je     8005f5 <vprintfmt+0x1dd>
  800624:	0f be c0             	movsbl %al,%eax
  800627:	83 e8 20             	sub    $0x20,%eax
  80062a:	83 f8 5e             	cmp    $0x5e,%eax
  80062d:	76 c6                	jbe    8005f5 <vprintfmt+0x1dd>
					putch('?', putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	6a 3f                	push   $0x3f
  800635:	ff d6                	call   *%esi
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	eb c3                	jmp    8005ff <vprintfmt+0x1e7>
  80063c:	89 cf                	mov    %ecx,%edi
  80063e:	eb 0e                	jmp    80064e <vprintfmt+0x236>
				putch(' ', putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	6a 20                	push   $0x20
  800646:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800648:	83 ef 01             	sub    $0x1,%edi
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	85 ff                	test   %edi,%edi
  800650:	7f ee                	jg     800640 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800652:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
  800658:	e9 01 02 00 00       	jmp    80085e <vprintfmt+0x446>
  80065d:	89 cf                	mov    %ecx,%edi
  80065f:	eb ed                	jmp    80064e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800661:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800664:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80066b:	e9 eb fd ff ff       	jmp    80045b <vprintfmt+0x43>
	if (lflag >= 2)
  800670:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800674:	7f 21                	jg     800697 <vprintfmt+0x27f>
	else if (lflag)
  800676:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80067a:	74 68                	je     8006e4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800684:	89 c1                	mov    %eax,%ecx
  800686:	c1 f9 1f             	sar    $0x1f,%ecx
  800689:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	eb 17                	jmp    8006ae <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 50 04             	mov    0x4(%eax),%edx
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 08             	lea    0x8(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006be:	78 3f                	js     8006ff <vprintfmt+0x2e7>
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006c5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006c9:	0f 84 71 01 00 00    	je     800840 <vprintfmt+0x428>
				putch('+', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	6a 2b                	push   $0x2b
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 5c 01 00 00       	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ec:	89 c1                	mov    %eax,%ecx
  8006ee:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fd:	eb af                	jmp    8006ae <vprintfmt+0x296>
				putch('-', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	6a 2d                	push   $0x2d
  800705:	ff d6                	call   *%esi
				num = -(long long) num;
  800707:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80070d:	f7 d8                	neg    %eax
  80070f:	83 d2 00             	adc    $0x0,%edx
  800712:	f7 da                	neg    %edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800722:	e9 19 01 00 00       	jmp    800840 <vprintfmt+0x428>
	if (lflag >= 2)
  800727:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80072b:	7f 29                	jg     800756 <vprintfmt+0x33e>
	else if (lflag)
  80072d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800731:	74 44                	je     800777 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	e9 ea 00 00 00       	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 50 04             	mov    0x4(%eax),%edx
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 40 08             	lea    0x8(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800772:	e9 c9 00 00 00       	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	ba 00 00 00 00       	mov    $0x0,%edx
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 04             	lea    0x4(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800790:	b8 0a 00 00 00       	mov    $0xa,%eax
  800795:	e9 a6 00 00 00       	jmp    800840 <vprintfmt+0x428>
			putch('0', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 30                	push   $0x30
  8007a0:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a9:	7f 26                	jg     8007d1 <vprintfmt+0x3b9>
	else if (lflag)
  8007ab:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007af:	74 3e                	je     8007ef <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8d 40 04             	lea    0x4(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8007cf:	eb 6f                	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 50 04             	mov    0x4(%eax),%edx
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8d 40 08             	lea    0x8(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ed:	eb 51                	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 40 04             	lea    0x4(%eax),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800808:	b8 08 00 00 00       	mov    $0x8,%eax
  80080d:	eb 31                	jmp    800840 <vprintfmt+0x428>
			putch('0', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	53                   	push   %ebx
  800813:	6a 30                	push   $0x30
  800815:	ff d6                	call   *%esi
			putch('x', putdat);
  800817:	83 c4 08             	add    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	6a 78                	push   $0x78
  80081d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80082f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800840:	83 ec 0c             	sub    $0xc,%esp
  800843:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800847:	52                   	push   %edx
  800848:	ff 75 e0             	pushl  -0x20(%ebp)
  80084b:	50                   	push   %eax
  80084c:	ff 75 dc             	pushl  -0x24(%ebp)
  80084f:	ff 75 d8             	pushl  -0x28(%ebp)
  800852:	89 da                	mov    %ebx,%edx
  800854:	89 f0                	mov    %esi,%eax
  800856:	e8 a4 fa ff ff       	call   8002ff <printnum>
			break;
  80085b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80085e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800861:	83 c7 01             	add    $0x1,%edi
  800864:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800868:	83 f8 25             	cmp    $0x25,%eax
  80086b:	0f 84 be fb ff ff    	je     80042f <vprintfmt+0x17>
			if (ch == '\0')
  800871:	85 c0                	test   %eax,%eax
  800873:	0f 84 28 01 00 00    	je     8009a1 <vprintfmt+0x589>
			putch(ch, putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	53                   	push   %ebx
  80087d:	50                   	push   %eax
  80087e:	ff d6                	call   *%esi
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	eb dc                	jmp    800861 <vprintfmt+0x449>
	if (lflag >= 2)
  800885:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800889:	7f 26                	jg     8008b1 <vprintfmt+0x499>
	else if (lflag)
  80088b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80088f:	74 41                	je     8008d2 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	ba 00 00 00 00       	mov    $0x0,%edx
  80089b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 40 04             	lea    0x4(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8008af:	eb 8f                	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 50 04             	mov    0x4(%eax),%edx
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 40 08             	lea    0x8(%eax),%eax
  8008c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008cd:	e9 6e ff ff ff       	jmp    800840 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8d 40 04             	lea    0x4(%eax),%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f0:	e9 4b ff ff ff       	jmp    800840 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	83 c0 04             	add    $0x4,%eax
  8008fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 00                	mov    (%eax),%eax
  800903:	85 c0                	test   %eax,%eax
  800905:	74 14                	je     80091b <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800907:	8b 13                	mov    (%ebx),%edx
  800909:	83 fa 7f             	cmp    $0x7f,%edx
  80090c:	7f 37                	jg     800945 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80090e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800910:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
  800916:	e9 43 ff ff ff       	jmp    80085e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80091b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800920:	bf c5 2d 80 00       	mov    $0x802dc5,%edi
							putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	53                   	push   %ebx
  800929:	50                   	push   %eax
  80092a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80092c:	83 c7 01             	add    $0x1,%edi
  80092f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800933:	83 c4 10             	add    $0x10,%esp
  800936:	85 c0                	test   %eax,%eax
  800938:	75 eb                	jne    800925 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80093a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	e9 19 ff ff ff       	jmp    80085e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800945:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800947:	b8 0a 00 00 00       	mov    $0xa,%eax
  80094c:	bf fd 2d 80 00       	mov    $0x802dfd,%edi
							putch(ch, putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	53                   	push   %ebx
  800955:	50                   	push   %eax
  800956:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800958:	83 c7 01             	add    $0x1,%edi
  80095b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	85 c0                	test   %eax,%eax
  800964:	75 eb                	jne    800951 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800966:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800969:	89 45 14             	mov    %eax,0x14(%ebp)
  80096c:	e9 ed fe ff ff       	jmp    80085e <vprintfmt+0x446>
			putch(ch, putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	53                   	push   %ebx
  800975:	6a 25                	push   $0x25
  800977:	ff d6                	call   *%esi
			break;
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	e9 dd fe ff ff       	jmp    80085e <vprintfmt+0x446>
			putch('%', putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	6a 25                	push   $0x25
  800987:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 f8                	mov    %edi,%eax
  80098e:	eb 03                	jmp    800993 <vprintfmt+0x57b>
  800990:	83 e8 01             	sub    $0x1,%eax
  800993:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800997:	75 f7                	jne    800990 <vprintfmt+0x578>
  800999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80099c:	e9 bd fe ff ff       	jmp    80085e <vprintfmt+0x446>
}
  8009a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5f                   	pop    %edi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 18             	sub    $0x18,%esp
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009bc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c6:	85 c0                	test   %eax,%eax
  8009c8:	74 26                	je     8009f0 <vsnprintf+0x47>
  8009ca:	85 d2                	test   %edx,%edx
  8009cc:	7e 22                	jle    8009f0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ce:	ff 75 14             	pushl  0x14(%ebp)
  8009d1:	ff 75 10             	pushl  0x10(%ebp)
  8009d4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d7:	50                   	push   %eax
  8009d8:	68 de 03 80 00       	push   $0x8003de
  8009dd:	e8 36 fa ff ff       	call   800418 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009eb:	83 c4 10             	add    $0x10,%esp
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    
		return -E_INVAL;
  8009f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f5:	eb f7                	jmp    8009ee <vsnprintf+0x45>

008009f7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009fd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a00:	50                   	push   %eax
  800a01:	ff 75 10             	pushl  0x10(%ebp)
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	ff 75 08             	pushl  0x8(%ebp)
  800a0a:	e8 9a ff ff ff       	call   8009a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a20:	74 05                	je     800a27 <strlen+0x16>
		n++;
  800a22:	83 c0 01             	add    $0x1,%eax
  800a25:	eb f5                	jmp    800a1c <strlen+0xb>
	return n;
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ba 00 00 00 00       	mov    $0x0,%edx
  800a37:	39 c2                	cmp    %eax,%edx
  800a39:	74 0d                	je     800a48 <strnlen+0x1f>
  800a3b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a3f:	74 05                	je     800a46 <strnlen+0x1d>
		n++;
  800a41:	83 c2 01             	add    $0x1,%edx
  800a44:	eb f1                	jmp    800a37 <strnlen+0xe>
  800a46:	89 d0                	mov    %edx,%eax
	return n;
}
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	53                   	push   %ebx
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a54:	ba 00 00 00 00       	mov    $0x0,%edx
  800a59:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a5d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a60:	83 c2 01             	add    $0x1,%edx
  800a63:	84 c9                	test   %cl,%cl
  800a65:	75 f2                	jne    800a59 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a67:	5b                   	pop    %ebx
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 10             	sub    $0x10,%esp
  800a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a74:	53                   	push   %ebx
  800a75:	e8 97 ff ff ff       	call   800a11 <strlen>
  800a7a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	50                   	push   %eax
  800a83:	e8 c2 ff ff ff       	call   800a4a <strcpy>
	return dst;
}
  800a88:	89 d8                	mov    %ebx,%eax
  800a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	39 f2                	cmp    %esi,%edx
  800aa3:	74 11                	je     800ab6 <strncpy+0x27>
		*dst++ = *src;
  800aa5:	83 c2 01             	add    $0x1,%edx
  800aa8:	0f b6 19             	movzbl (%ecx),%ebx
  800aab:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aae:	80 fb 01             	cmp    $0x1,%bl
  800ab1:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ab4:	eb eb                	jmp    800aa1 <strncpy+0x12>
	}
	return ret;
}
  800ab6:	5b                   	pop    %ebx
  800ab7:	5e                   	pop    %esi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac5:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aca:	85 d2                	test   %edx,%edx
  800acc:	74 21                	je     800aef <strlcpy+0x35>
  800ace:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ad2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad4:	39 c2                	cmp    %eax,%edx
  800ad6:	74 14                	je     800aec <strlcpy+0x32>
  800ad8:	0f b6 19             	movzbl (%ecx),%ebx
  800adb:	84 db                	test   %bl,%bl
  800add:	74 0b                	je     800aea <strlcpy+0x30>
			*dst++ = *src++;
  800adf:	83 c1 01             	add    $0x1,%ecx
  800ae2:	83 c2 01             	add    $0x1,%edx
  800ae5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae8:	eb ea                	jmp    800ad4 <strlcpy+0x1a>
  800aea:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aef:	29 f0                	sub    %esi,%eax
}
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afe:	0f b6 01             	movzbl (%ecx),%eax
  800b01:	84 c0                	test   %al,%al
  800b03:	74 0c                	je     800b11 <strcmp+0x1c>
  800b05:	3a 02                	cmp    (%edx),%al
  800b07:	75 08                	jne    800b11 <strcmp+0x1c>
		p++, q++;
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	83 c2 01             	add    $0x1,%edx
  800b0f:	eb ed                	jmp    800afe <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	0f b6 12             	movzbl (%edx),%edx
  800b17:	29 d0                	sub    %edx,%eax
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b25:	89 c3                	mov    %eax,%ebx
  800b27:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2a:	eb 06                	jmp    800b32 <strncmp+0x17>
		n--, p++, q++;
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b32:	39 d8                	cmp    %ebx,%eax
  800b34:	74 16                	je     800b4c <strncmp+0x31>
  800b36:	0f b6 08             	movzbl (%eax),%ecx
  800b39:	84 c9                	test   %cl,%cl
  800b3b:	74 04                	je     800b41 <strncmp+0x26>
  800b3d:	3a 0a                	cmp    (%edx),%cl
  800b3f:	74 eb                	je     800b2c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b41:	0f b6 00             	movzbl (%eax),%eax
  800b44:	0f b6 12             	movzbl (%edx),%edx
  800b47:	29 d0                	sub    %edx,%eax
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    
		return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	eb f6                	jmp    800b49 <strncmp+0x2e>

00800b53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5d:	0f b6 10             	movzbl (%eax),%edx
  800b60:	84 d2                	test   %dl,%dl
  800b62:	74 09                	je     800b6d <strchr+0x1a>
		if (*s == c)
  800b64:	38 ca                	cmp    %cl,%dl
  800b66:	74 0a                	je     800b72 <strchr+0x1f>
	for (; *s; s++)
  800b68:	83 c0 01             	add    $0x1,%eax
  800b6b:	eb f0                	jmp    800b5d <strchr+0xa>
			return (char *) s;
	return 0;
  800b6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b81:	38 ca                	cmp    %cl,%dl
  800b83:	74 09                	je     800b8e <strfind+0x1a>
  800b85:	84 d2                	test   %dl,%dl
  800b87:	74 05                	je     800b8e <strfind+0x1a>
	for (; *s; s++)
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	eb f0                	jmp    800b7e <strfind+0xa>
			break;
	return (char *) s;
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b99:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b9c:	85 c9                	test   %ecx,%ecx
  800b9e:	74 31                	je     800bd1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba0:	89 f8                	mov    %edi,%eax
  800ba2:	09 c8                	or     %ecx,%eax
  800ba4:	a8 03                	test   $0x3,%al
  800ba6:	75 23                	jne    800bcb <memset+0x3b>
		c &= 0xFF;
  800ba8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bac:	89 d3                	mov    %edx,%ebx
  800bae:	c1 e3 08             	shl    $0x8,%ebx
  800bb1:	89 d0                	mov    %edx,%eax
  800bb3:	c1 e0 18             	shl    $0x18,%eax
  800bb6:	89 d6                	mov    %edx,%esi
  800bb8:	c1 e6 10             	shl    $0x10,%esi
  800bbb:	09 f0                	or     %esi,%eax
  800bbd:	09 c2                	or     %eax,%edx
  800bbf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bc1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bc4:	89 d0                	mov    %edx,%eax
  800bc6:	fc                   	cld    
  800bc7:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc9:	eb 06                	jmp    800bd1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bce:	fc                   	cld    
  800bcf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd1:	89 f8                	mov    %edi,%eax
  800bd3:	5b                   	pop    %ebx
  800bd4:	5e                   	pop    %esi
  800bd5:	5f                   	pop    %edi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be6:	39 c6                	cmp    %eax,%esi
  800be8:	73 32                	jae    800c1c <memmove+0x44>
  800bea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bed:	39 c2                	cmp    %eax,%edx
  800bef:	76 2b                	jbe    800c1c <memmove+0x44>
		s += n;
		d += n;
  800bf1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf4:	89 fe                	mov    %edi,%esi
  800bf6:	09 ce                	or     %ecx,%esi
  800bf8:	09 d6                	or     %edx,%esi
  800bfa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c00:	75 0e                	jne    800c10 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c02:	83 ef 04             	sub    $0x4,%edi
  800c05:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c08:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c0b:	fd                   	std    
  800c0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0e:	eb 09                	jmp    800c19 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c10:	83 ef 01             	sub    $0x1,%edi
  800c13:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c16:	fd                   	std    
  800c17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c19:	fc                   	cld    
  800c1a:	eb 1a                	jmp    800c36 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1c:	89 c2                	mov    %eax,%edx
  800c1e:	09 ca                	or     %ecx,%edx
  800c20:	09 f2                	or     %esi,%edx
  800c22:	f6 c2 03             	test   $0x3,%dl
  800c25:	75 0a                	jne    800c31 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c2a:	89 c7                	mov    %eax,%edi
  800c2c:	fc                   	cld    
  800c2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2f:	eb 05                	jmp    800c36 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c31:	89 c7                	mov    %eax,%edi
  800c33:	fc                   	cld    
  800c34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c40:	ff 75 10             	pushl  0x10(%ebp)
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	ff 75 08             	pushl  0x8(%ebp)
  800c49:	e8 8a ff ff ff       	call   800bd8 <memmove>
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	89 c6                	mov    %eax,%esi
  800c5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c60:	39 f0                	cmp    %esi,%eax
  800c62:	74 1c                	je     800c80 <memcmp+0x30>
		if (*s1 != *s2)
  800c64:	0f b6 08             	movzbl (%eax),%ecx
  800c67:	0f b6 1a             	movzbl (%edx),%ebx
  800c6a:	38 d9                	cmp    %bl,%cl
  800c6c:	75 08                	jne    800c76 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c6e:	83 c0 01             	add    $0x1,%eax
  800c71:	83 c2 01             	add    $0x1,%edx
  800c74:	eb ea                	jmp    800c60 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c76:	0f b6 c1             	movzbl %cl,%eax
  800c79:	0f b6 db             	movzbl %bl,%ebx
  800c7c:	29 d8                	sub    %ebx,%eax
  800c7e:	eb 05                	jmp    800c85 <memcmp+0x35>
	}

	return 0;
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c97:	39 d0                	cmp    %edx,%eax
  800c99:	73 09                	jae    800ca4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c9b:	38 08                	cmp    %cl,(%eax)
  800c9d:	74 05                	je     800ca4 <memfind+0x1b>
	for (; s < ends; s++)
  800c9f:	83 c0 01             	add    $0x1,%eax
  800ca2:	eb f3                	jmp    800c97 <memfind+0xe>
			break;
	return (void *) s;
}
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb2:	eb 03                	jmp    800cb7 <strtol+0x11>
		s++;
  800cb4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb7:	0f b6 01             	movzbl (%ecx),%eax
  800cba:	3c 20                	cmp    $0x20,%al
  800cbc:	74 f6                	je     800cb4 <strtol+0xe>
  800cbe:	3c 09                	cmp    $0x9,%al
  800cc0:	74 f2                	je     800cb4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cc2:	3c 2b                	cmp    $0x2b,%al
  800cc4:	74 2a                	je     800cf0 <strtol+0x4a>
	int neg = 0;
  800cc6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ccb:	3c 2d                	cmp    $0x2d,%al
  800ccd:	74 2b                	je     800cfa <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ccf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd5:	75 0f                	jne    800ce6 <strtol+0x40>
  800cd7:	80 39 30             	cmpb   $0x30,(%ecx)
  800cda:	74 28                	je     800d04 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cdc:	85 db                	test   %ebx,%ebx
  800cde:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce3:	0f 44 d8             	cmove  %eax,%ebx
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cee:	eb 50                	jmp    800d40 <strtol+0x9a>
		s++;
  800cf0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cf3:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf8:	eb d5                	jmp    800ccf <strtol+0x29>
		s++, neg = 1;
  800cfa:	83 c1 01             	add    $0x1,%ecx
  800cfd:	bf 01 00 00 00       	mov    $0x1,%edi
  800d02:	eb cb                	jmp    800ccf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d04:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d08:	74 0e                	je     800d18 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d0a:	85 db                	test   %ebx,%ebx
  800d0c:	75 d8                	jne    800ce6 <strtol+0x40>
		s++, base = 8;
  800d0e:	83 c1 01             	add    $0x1,%ecx
  800d11:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d16:	eb ce                	jmp    800ce6 <strtol+0x40>
		s += 2, base = 16;
  800d18:	83 c1 02             	add    $0x2,%ecx
  800d1b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d20:	eb c4                	jmp    800ce6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d22:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d25:	89 f3                	mov    %esi,%ebx
  800d27:	80 fb 19             	cmp    $0x19,%bl
  800d2a:	77 29                	ja     800d55 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d2c:	0f be d2             	movsbl %dl,%edx
  800d2f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d32:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d35:	7d 30                	jge    800d67 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d37:	83 c1 01             	add    $0x1,%ecx
  800d3a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d3e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d40:	0f b6 11             	movzbl (%ecx),%edx
  800d43:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d46:	89 f3                	mov    %esi,%ebx
  800d48:	80 fb 09             	cmp    $0x9,%bl
  800d4b:	77 d5                	ja     800d22 <strtol+0x7c>
			dig = *s - '0';
  800d4d:	0f be d2             	movsbl %dl,%edx
  800d50:	83 ea 30             	sub    $0x30,%edx
  800d53:	eb dd                	jmp    800d32 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d55:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 19             	cmp    $0x19,%bl
  800d5d:	77 08                	ja     800d67 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	83 ea 37             	sub    $0x37,%edx
  800d65:	eb cb                	jmp    800d32 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6b:	74 05                	je     800d72 <strtol+0xcc>
		*endptr = (char *) s;
  800d6d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d70:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d72:	89 c2                	mov    %eax,%edx
  800d74:	f7 da                	neg    %edx
  800d76:	85 ff                	test   %edi,%edi
  800d78:	0f 45 c2             	cmovne %edx,%eax
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d86:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	89 c3                	mov    %eax,%ebx
  800d93:	89 c7                	mov    %eax,%edi
  800d95:	89 c6                	mov    %eax,%esi
  800d97:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d99:	5b                   	pop    %ebx
  800d9a:	5e                   	pop    %esi
  800d9b:	5f                   	pop    %edi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    

00800d9e <sys_cgetc>:

int
sys_cgetc(void)
{
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	57                   	push   %edi
  800da2:	56                   	push   %esi
  800da3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da4:	ba 00 00 00 00       	mov    $0x0,%edx
  800da9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dae:	89 d1                	mov    %edx,%ecx
  800db0:	89 d3                	mov    %edx,%ebx
  800db2:	89 d7                	mov    %edx,%edi
  800db4:	89 d6                	mov    %edx,%esi
  800db6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd3:	89 cb                	mov    %ecx,%ebx
  800dd5:	89 cf                	mov    %ecx,%edi
  800dd7:	89 ce                	mov    %ecx,%esi
  800dd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	7f 08                	jg     800de7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	83 ec 0c             	sub    $0xc,%esp
  800dea:	50                   	push   %eax
  800deb:	6a 03                	push   $0x3
  800ded:	68 08 30 80 00       	push   $0x803008
  800df2:	6a 43                	push   $0x43
  800df4:	68 25 30 80 00       	push   $0x803025
  800df9:	e8 f7 f3 ff ff       	call   8001f5 <_panic>

00800dfe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	57                   	push   %edi
  800e02:	56                   	push   %esi
  800e03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e04:	ba 00 00 00 00       	mov    $0x0,%edx
  800e09:	b8 02 00 00 00       	mov    $0x2,%eax
  800e0e:	89 d1                	mov    %edx,%ecx
  800e10:	89 d3                	mov    %edx,%ebx
  800e12:	89 d7                	mov    %edx,%edi
  800e14:	89 d6                	mov    %edx,%esi
  800e16:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <sys_yield>:

void
sys_yield(void)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e23:	ba 00 00 00 00       	mov    $0x0,%edx
  800e28:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e2d:	89 d1                	mov    %edx,%ecx
  800e2f:	89 d3                	mov    %edx,%ebx
  800e31:	89 d7                	mov    %edx,%edi
  800e33:	89 d6                	mov    %edx,%esi
  800e35:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e37:	5b                   	pop    %ebx
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	be 00 00 00 00       	mov    $0x0,%esi
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	b8 04 00 00 00       	mov    $0x4,%eax
  800e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e58:	89 f7                	mov    %esi,%edi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800e6c:	6a 04                	push   $0x4
  800e6e:	68 08 30 80 00       	push   $0x803008
  800e73:	6a 43                	push   $0x43
  800e75:	68 25 30 80 00       	push   $0x803025
  800e7a:	e8 76 f3 ff ff       	call   8001f5 <_panic>

00800e7f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	b8 05 00 00 00       	mov    $0x5,%eax
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e99:	8b 75 18             	mov    0x18(%ebp),%esi
  800e9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800eae:	6a 05                	push   $0x5
  800eb0:	68 08 30 80 00       	push   $0x803008
  800eb5:	6a 43                	push   $0x43
  800eb7:	68 25 30 80 00       	push   $0x803025
  800ebc:	e8 34 f3 ff ff       	call   8001f5 <_panic>

00800ec1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800ed5:	b8 06 00 00 00       	mov    $0x6,%eax
  800eda:	89 df                	mov    %ebx,%edi
  800edc:	89 de                	mov    %ebx,%esi
  800ede:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	7f 08                	jg     800eec <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800ef0:	6a 06                	push   $0x6
  800ef2:	68 08 30 80 00       	push   $0x803008
  800ef7:	6a 43                	push   $0x43
  800ef9:	68 25 30 80 00       	push   $0x803025
  800efe:	e8 f2 f2 ff ff       	call   8001f5 <_panic>

00800f03 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800f17:	b8 08 00 00 00       	mov    $0x8,%eax
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7f 08                	jg     800f2e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800f32:	6a 08                	push   $0x8
  800f34:	68 08 30 80 00       	push   $0x803008
  800f39:	6a 43                	push   $0x43
  800f3b:	68 25 30 80 00       	push   $0x803025
  800f40:	e8 b0 f2 ff ff       	call   8001f5 <_panic>

00800f45 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f53:	8b 55 08             	mov    0x8(%ebp),%edx
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	b8 09 00 00 00       	mov    $0x9,%eax
  800f5e:	89 df                	mov    %ebx,%edi
  800f60:	89 de                	mov    %ebx,%esi
  800f62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7f 08                	jg     800f70 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	50                   	push   %eax
  800f74:	6a 09                	push   $0x9
  800f76:	68 08 30 80 00       	push   $0x803008
  800f7b:	6a 43                	push   $0x43
  800f7d:	68 25 30 80 00       	push   $0x803025
  800f82:	e8 6e f2 ff ff       	call   8001f5 <_panic>

00800f87 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa0:	89 df                	mov    %ebx,%edi
  800fa2:	89 de                	mov    %ebx,%esi
  800fa4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	7f 08                	jg     800fb2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	50                   	push   %eax
  800fb6:	6a 0a                	push   $0xa
  800fb8:	68 08 30 80 00       	push   $0x803008
  800fbd:	6a 43                	push   $0x43
  800fbf:	68 25 30 80 00       	push   $0x803025
  800fc4:	e8 2c f2 ff ff       	call   8001f5 <_panic>

00800fc9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fda:	be 00 00 00 00       	mov    $0x0,%esi
  800fdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	b8 0d 00 00 00       	mov    $0xd,%eax
  801002:	89 cb                	mov    %ecx,%ebx
  801004:	89 cf                	mov    %ecx,%edi
  801006:	89 ce                	mov    %ecx,%esi
  801008:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100a:	85 c0                	test   %eax,%eax
  80100c:	7f 08                	jg     801016 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80100e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	50                   	push   %eax
  80101a:	6a 0d                	push   $0xd
  80101c:	68 08 30 80 00       	push   $0x803008
  801021:	6a 43                	push   $0x43
  801023:	68 25 30 80 00       	push   $0x803025
  801028:	e8 c8 f1 ff ff       	call   8001f5 <_panic>

0080102d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	57                   	push   %edi
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
	asm volatile("int %1\n"
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801043:	89 df                	mov    %ebx,%edi
  801045:	89 de                	mov    %ebx,%esi
  801047:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	57                   	push   %edi
  801052:	56                   	push   %esi
  801053:	53                   	push   %ebx
	asm volatile("int %1\n"
  801054:	b9 00 00 00 00       	mov    $0x0,%ecx
  801059:	8b 55 08             	mov    0x8(%ebp),%edx
  80105c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801061:	89 cb                	mov    %ecx,%ebx
  801063:	89 cf                	mov    %ecx,%edi
  801065:	89 ce                	mov    %ecx,%esi
  801067:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
	asm volatile("int %1\n"
  801074:	ba 00 00 00 00       	mov    $0x0,%edx
  801079:	b8 10 00 00 00       	mov    $0x10,%eax
  80107e:	89 d1                	mov    %edx,%ecx
  801080:	89 d3                	mov    %edx,%ebx
  801082:	89 d7                	mov    %edx,%edi
  801084:	89 d6                	mov    %edx,%esi
  801086:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	57                   	push   %edi
  801091:	56                   	push   %esi
  801092:	53                   	push   %ebx
	asm volatile("int %1\n"
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109e:	b8 11 00 00 00       	mov    $0x11,%eax
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	89 de                	mov    %ebx,%esi
  8010a7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010a9:	5b                   	pop    %ebx
  8010aa:	5e                   	pop    %esi
  8010ab:	5f                   	pop    %edi
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bf:	b8 12 00 00 00       	mov    $0x12,%eax
  8010c4:	89 df                	mov    %ebx,%edi
  8010c6:	89 de                	mov    %ebx,%esi
  8010c8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	5f                   	pop    %edi
  8010cd:	5d                   	pop    %ebp
  8010ce:	c3                   	ret    

008010cf <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	57                   	push   %edi
  8010d3:	56                   	push   %esi
  8010d4:	53                   	push   %ebx
  8010d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e3:	b8 13 00 00 00       	mov    $0x13,%eax
  8010e8:	89 df                	mov    %ebx,%edi
  8010ea:	89 de                	mov    %ebx,%esi
  8010ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	7f 08                	jg     8010fa <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	50                   	push   %eax
  8010fe:	6a 13                	push   $0x13
  801100:	68 08 30 80 00       	push   $0x803008
  801105:	6a 43                	push   $0x43
  801107:	68 25 30 80 00       	push   $0x803025
  80110c:	e8 e4 f0 ff ff       	call   8001f5 <_panic>

00801111 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	57                   	push   %edi
  801115:	56                   	push   %esi
  801116:	53                   	push   %ebx
	asm volatile("int %1\n"
  801117:	b9 00 00 00 00       	mov    $0x0,%ecx
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	b8 14 00 00 00       	mov    $0x14,%eax
  801124:	89 cb                	mov    %ecx,%ebx
  801126:	89 cf                	mov    %ecx,%edi
  801128:	89 ce                	mov    %ecx,%esi
  80112a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    

00801131 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	53                   	push   %ebx
  801135:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801138:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80113f:	f6 c5 04             	test   $0x4,%ch
  801142:	75 45                	jne    801189 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801144:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80114b:	83 e1 07             	and    $0x7,%ecx
  80114e:	83 f9 07             	cmp    $0x7,%ecx
  801151:	74 6f                	je     8011c2 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801153:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80115a:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801160:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801166:	0f 84 b6 00 00 00    	je     801222 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80116c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801173:	83 e1 05             	and    $0x5,%ecx
  801176:	83 f9 05             	cmp    $0x5,%ecx
  801179:	0f 84 d7 00 00 00    	je     801256 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801187:	c9                   	leave  
  801188:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801189:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801190:	c1 e2 0c             	shl    $0xc,%edx
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80119c:	51                   	push   %ecx
  80119d:	52                   	push   %edx
  80119e:	50                   	push   %eax
  80119f:	52                   	push   %edx
  8011a0:	6a 00                	push   $0x0
  8011a2:	e8 d8 fc ff ff       	call   800e7f <sys_page_map>
		if(r < 0)
  8011a7:	83 c4 20             	add    $0x20,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	79 d1                	jns    80117f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	68 33 30 80 00       	push   $0x803033
  8011b6:	6a 54                	push   $0x54
  8011b8:	68 49 30 80 00       	push   $0x803049
  8011bd:	e8 33 f0 ff ff       	call   8001f5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011c2:	89 d3                	mov    %edx,%ebx
  8011c4:	c1 e3 0c             	shl    $0xc,%ebx
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	68 05 08 00 00       	push   $0x805
  8011cf:	53                   	push   %ebx
  8011d0:	50                   	push   %eax
  8011d1:	53                   	push   %ebx
  8011d2:	6a 00                	push   $0x0
  8011d4:	e8 a6 fc ff ff       	call   800e7f <sys_page_map>
		if(r < 0)
  8011d9:	83 c4 20             	add    $0x20,%esp
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	78 2e                	js     80120e <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	68 05 08 00 00       	push   $0x805
  8011e8:	53                   	push   %ebx
  8011e9:	6a 00                	push   $0x0
  8011eb:	53                   	push   %ebx
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 8c fc ff ff       	call   800e7f <sys_page_map>
		if(r < 0)
  8011f3:	83 c4 20             	add    $0x20,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 85                	jns    80117f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	68 33 30 80 00       	push   $0x803033
  801202:	6a 5f                	push   $0x5f
  801204:	68 49 30 80 00       	push   $0x803049
  801209:	e8 e7 ef ff ff       	call   8001f5 <_panic>
			panic("sys_page_map() panic\n");
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	68 33 30 80 00       	push   $0x803033
  801216:	6a 5b                	push   $0x5b
  801218:	68 49 30 80 00       	push   $0x803049
  80121d:	e8 d3 ef ff ff       	call   8001f5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801222:	c1 e2 0c             	shl    $0xc,%edx
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	68 05 08 00 00       	push   $0x805
  80122d:	52                   	push   %edx
  80122e:	50                   	push   %eax
  80122f:	52                   	push   %edx
  801230:	6a 00                	push   $0x0
  801232:	e8 48 fc ff ff       	call   800e7f <sys_page_map>
		if(r < 0)
  801237:	83 c4 20             	add    $0x20,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	0f 89 3d ff ff ff    	jns    80117f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801242:	83 ec 04             	sub    $0x4,%esp
  801245:	68 33 30 80 00       	push   $0x803033
  80124a:	6a 66                	push   $0x66
  80124c:	68 49 30 80 00       	push   $0x803049
  801251:	e8 9f ef ff ff       	call   8001f5 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801256:	c1 e2 0c             	shl    $0xc,%edx
  801259:	83 ec 0c             	sub    $0xc,%esp
  80125c:	6a 05                	push   $0x5
  80125e:	52                   	push   %edx
  80125f:	50                   	push   %eax
  801260:	52                   	push   %edx
  801261:	6a 00                	push   $0x0
  801263:	e8 17 fc ff ff       	call   800e7f <sys_page_map>
		if(r < 0)
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	0f 89 0c ff ff ff    	jns    80117f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 33 30 80 00       	push   $0x803033
  80127b:	6a 6d                	push   $0x6d
  80127d:	68 49 30 80 00       	push   $0x803049
  801282:	e8 6e ef ff ff       	call   8001f5 <_panic>

00801287 <pgfault>:
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	53                   	push   %ebx
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801291:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801293:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801297:	0f 84 99 00 00 00    	je     801336 <pgfault+0xaf>
  80129d:	89 c2                	mov    %eax,%edx
  80129f:	c1 ea 16             	shr    $0x16,%edx
  8012a2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012a9:	f6 c2 01             	test   $0x1,%dl
  8012ac:	0f 84 84 00 00 00    	je     801336 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	c1 ea 0c             	shr    $0xc,%edx
  8012b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012be:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012c4:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012ca:	75 6a                	jne    801336 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d1:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012d3:	83 ec 04             	sub    $0x4,%esp
  8012d6:	6a 07                	push   $0x7
  8012d8:	68 00 f0 7f 00       	push   $0x7ff000
  8012dd:	6a 00                	push   $0x0
  8012df:	e8 58 fb ff ff       	call   800e3c <sys_page_alloc>
	if(ret < 0)
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 5f                	js     80134a <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	68 00 10 00 00       	push   $0x1000
  8012f3:	53                   	push   %ebx
  8012f4:	68 00 f0 7f 00       	push   $0x7ff000
  8012f9:	e8 3c f9 ff ff       	call   800c3a <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012fe:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801305:	53                   	push   %ebx
  801306:	6a 00                	push   $0x0
  801308:	68 00 f0 7f 00       	push   $0x7ff000
  80130d:	6a 00                	push   $0x0
  80130f:	e8 6b fb ff ff       	call   800e7f <sys_page_map>
	if(ret < 0)
  801314:	83 c4 20             	add    $0x20,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 43                	js     80135e <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	68 00 f0 7f 00       	push   $0x7ff000
  801323:	6a 00                	push   $0x0
  801325:	e8 97 fb ff ff       	call   800ec1 <sys_page_unmap>
	if(ret < 0)
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 41                	js     801372 <pgfault+0xeb>
}
  801331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801334:	c9                   	leave  
  801335:	c3                   	ret    
		panic("panic at pgfault()\n");
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	68 54 30 80 00       	push   $0x803054
  80133e:	6a 26                	push   $0x26
  801340:	68 49 30 80 00       	push   $0x803049
  801345:	e8 ab ee ff ff       	call   8001f5 <_panic>
		panic("panic in sys_page_alloc()\n");
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	68 68 30 80 00       	push   $0x803068
  801352:	6a 31                	push   $0x31
  801354:	68 49 30 80 00       	push   $0x803049
  801359:	e8 97 ee ff ff       	call   8001f5 <_panic>
		panic("panic in sys_page_map()\n");
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	68 83 30 80 00       	push   $0x803083
  801366:	6a 36                	push   $0x36
  801368:	68 49 30 80 00       	push   $0x803049
  80136d:	e8 83 ee ff ff       	call   8001f5 <_panic>
		panic("panic in sys_page_unmap()\n");
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	68 9c 30 80 00       	push   $0x80309c
  80137a:	6a 39                	push   $0x39
  80137c:	68 49 30 80 00       	push   $0x803049
  801381:	e8 6f ee ff ff       	call   8001f5 <_panic>

00801386 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	57                   	push   %edi
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
  80138c:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80138f:	68 87 12 80 00       	push   $0x801287
  801394:	e8 db 13 00 00       	call   802774 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801399:	b8 07 00 00 00       	mov    $0x7,%eax
  80139e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 2a                	js     8013d1 <fork+0x4b>
  8013a7:	89 c6                	mov    %eax,%esi
  8013a9:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ab:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013b0:	75 4b                	jne    8013fd <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013b2:	e8 47 fa ff ff       	call   800dfe <sys_getenvid>
  8013b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013bc:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c7:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013cc:	e9 90 00 00 00       	jmp    801461 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	68 b8 30 80 00       	push   $0x8030b8
  8013d9:	68 8c 00 00 00       	push   $0x8c
  8013de:	68 49 30 80 00       	push   $0x803049
  8013e3:	e8 0d ee ff ff       	call   8001f5 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013e8:	89 f8                	mov    %edi,%eax
  8013ea:	e8 42 fd ff ff       	call   801131 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013f5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013fb:	74 26                	je     801423 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013fd:	89 d8                	mov    %ebx,%eax
  8013ff:	c1 e8 16             	shr    $0x16,%eax
  801402:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801409:	a8 01                	test   $0x1,%al
  80140b:	74 e2                	je     8013ef <fork+0x69>
  80140d:	89 da                	mov    %ebx,%edx
  80140f:	c1 ea 0c             	shr    $0xc,%edx
  801412:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801419:	83 e0 05             	and    $0x5,%eax
  80141c:	83 f8 05             	cmp    $0x5,%eax
  80141f:	75 ce                	jne    8013ef <fork+0x69>
  801421:	eb c5                	jmp    8013e8 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	6a 07                	push   $0x7
  801428:	68 00 f0 bf ee       	push   $0xeebff000
  80142d:	56                   	push   %esi
  80142e:	e8 09 fa ff ff       	call   800e3c <sys_page_alloc>
	if(ret < 0)
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 31                	js     80146b <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	68 e3 27 80 00       	push   $0x8027e3
  801442:	56                   	push   %esi
  801443:	e8 3f fb ff ff       	call   800f87 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 33                	js     801482 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80144f:	83 ec 08             	sub    $0x8,%esp
  801452:	6a 02                	push   $0x2
  801454:	56                   	push   %esi
  801455:	e8 a9 fa ff ff       	call   800f03 <sys_env_set_status>
	if(ret < 0)
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 38                	js     801499 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801461:	89 f0                	mov    %esi,%eax
  801463:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801466:	5b                   	pop    %ebx
  801467:	5e                   	pop    %esi
  801468:	5f                   	pop    %edi
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 68 30 80 00       	push   $0x803068
  801473:	68 98 00 00 00       	push   $0x98
  801478:	68 49 30 80 00       	push   $0x803049
  80147d:	e8 73 ed ff ff       	call   8001f5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	68 dc 30 80 00       	push   $0x8030dc
  80148a:	68 9b 00 00 00       	push   $0x9b
  80148f:	68 49 30 80 00       	push   $0x803049
  801494:	e8 5c ed ff ff       	call   8001f5 <_panic>
		panic("panic in sys_env_set_status()\n");
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	68 04 31 80 00       	push   $0x803104
  8014a1:	68 9e 00 00 00       	push   $0x9e
  8014a6:	68 49 30 80 00       	push   $0x803049
  8014ab:	e8 45 ed ff ff       	call   8001f5 <_panic>

008014b0 <sfork>:

// Challenge!
int
sfork(void)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	57                   	push   %edi
  8014b4:	56                   	push   %esi
  8014b5:	53                   	push   %ebx
  8014b6:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014b9:	68 87 12 80 00       	push   $0x801287
  8014be:	e8 b1 12 00 00       	call   802774 <set_pgfault_handler>
  8014c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8014c8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 2a                	js     8014fb <sfork+0x4b>
  8014d1:	89 c7                	mov    %eax,%edi
  8014d3:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014d5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014da:	75 58                	jne    801534 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014dc:	e8 1d f9 ff ff       	call   800dfe <sys_getenvid>
  8014e1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014e6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8014ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014f1:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8014f6:	e9 d4 00 00 00       	jmp    8015cf <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	68 b8 30 80 00       	push   $0x8030b8
  801503:	68 af 00 00 00       	push   $0xaf
  801508:	68 49 30 80 00       	push   $0x803049
  80150d:	e8 e3 ec ff ff       	call   8001f5 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801512:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801517:	89 f0                	mov    %esi,%eax
  801519:	e8 13 fc ff ff       	call   801131 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80151e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801524:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80152a:	77 65                	ja     801591 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80152c:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801532:	74 de                	je     801512 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801534:	89 d8                	mov    %ebx,%eax
  801536:	c1 e8 16             	shr    $0x16,%eax
  801539:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801540:	a8 01                	test   $0x1,%al
  801542:	74 da                	je     80151e <sfork+0x6e>
  801544:	89 da                	mov    %ebx,%edx
  801546:	c1 ea 0c             	shr    $0xc,%edx
  801549:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801550:	83 e0 05             	and    $0x5,%eax
  801553:	83 f8 05             	cmp    $0x5,%eax
  801556:	75 c6                	jne    80151e <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801558:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80155f:	c1 e2 0c             	shl    $0xc,%edx
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	83 e0 07             	and    $0x7,%eax
  801568:	50                   	push   %eax
  801569:	52                   	push   %edx
  80156a:	56                   	push   %esi
  80156b:	52                   	push   %edx
  80156c:	6a 00                	push   $0x0
  80156e:	e8 0c f9 ff ff       	call   800e7f <sys_page_map>
  801573:	83 c4 20             	add    $0x20,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	74 a4                	je     80151e <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 33 30 80 00       	push   $0x803033
  801582:	68 ba 00 00 00       	push   $0xba
  801587:	68 49 30 80 00       	push   $0x803049
  80158c:	e8 64 ec ff ff       	call   8001f5 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	6a 07                	push   $0x7
  801596:	68 00 f0 bf ee       	push   $0xeebff000
  80159b:	57                   	push   %edi
  80159c:	e8 9b f8 ff ff       	call   800e3c <sys_page_alloc>
	if(ret < 0)
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 31                	js     8015d9 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	68 e3 27 80 00       	push   $0x8027e3
  8015b0:	57                   	push   %edi
  8015b1:	e8 d1 f9 ff ff       	call   800f87 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 33                	js     8015f0 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	6a 02                	push   $0x2
  8015c2:	57                   	push   %edi
  8015c3:	e8 3b f9 ff ff       	call   800f03 <sys_env_set_status>
	if(ret < 0)
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 38                	js     801607 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015cf:	89 f8                	mov    %edi,%eax
  8015d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d4:	5b                   	pop    %ebx
  8015d5:	5e                   	pop    %esi
  8015d6:	5f                   	pop    %edi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 68 30 80 00       	push   $0x803068
  8015e1:	68 c0 00 00 00       	push   $0xc0
  8015e6:	68 49 30 80 00       	push   $0x803049
  8015eb:	e8 05 ec ff ff       	call   8001f5 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	68 dc 30 80 00       	push   $0x8030dc
  8015f8:	68 c3 00 00 00       	push   $0xc3
  8015fd:	68 49 30 80 00       	push   $0x803049
  801602:	e8 ee eb ff ff       	call   8001f5 <_panic>
		panic("panic in sys_env_set_status()\n");
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	68 04 31 80 00       	push   $0x803104
  80160f:	68 c6 00 00 00       	push   $0xc6
  801614:	68 49 30 80 00       	push   $0x803049
  801619:	e8 d7 eb ff ff       	call   8001f5 <_panic>

0080161e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	05 00 00 00 30       	add    $0x30000000,%eax
  801629:	c1 e8 0c             	shr    $0xc,%eax
}
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801639:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80163e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801643:	5d                   	pop    %ebp
  801644:	c3                   	ret    

00801645 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80164d:	89 c2                	mov    %eax,%edx
  80164f:	c1 ea 16             	shr    $0x16,%edx
  801652:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801659:	f6 c2 01             	test   $0x1,%dl
  80165c:	74 2d                	je     80168b <fd_alloc+0x46>
  80165e:	89 c2                	mov    %eax,%edx
  801660:	c1 ea 0c             	shr    $0xc,%edx
  801663:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80166a:	f6 c2 01             	test   $0x1,%dl
  80166d:	74 1c                	je     80168b <fd_alloc+0x46>
  80166f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801674:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801679:	75 d2                	jne    80164d <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801684:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801689:	eb 0a                	jmp    801695 <fd_alloc+0x50>
			*fd_store = fd;
  80168b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80169d:	83 f8 1f             	cmp    $0x1f,%eax
  8016a0:	77 30                	ja     8016d2 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016a2:	c1 e0 0c             	shl    $0xc,%eax
  8016a5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016aa:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016b0:	f6 c2 01             	test   $0x1,%dl
  8016b3:	74 24                	je     8016d9 <fd_lookup+0x42>
  8016b5:	89 c2                	mov    %eax,%edx
  8016b7:	c1 ea 0c             	shr    $0xc,%edx
  8016ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016c1:	f6 c2 01             	test   $0x1,%dl
  8016c4:	74 1a                	je     8016e0 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c9:	89 02                	mov    %eax,(%edx)
	return 0;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    
		return -E_INVAL;
  8016d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d7:	eb f7                	jmp    8016d0 <fd_lookup+0x39>
		return -E_INVAL;
  8016d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016de:	eb f0                	jmp    8016d0 <fd_lookup+0x39>
  8016e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e5:	eb e9                	jmp    8016d0 <fd_lookup+0x39>

008016e7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f5:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016fa:	39 08                	cmp    %ecx,(%eax)
  8016fc:	74 38                	je     801736 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8016fe:	83 c2 01             	add    $0x1,%edx
  801701:	8b 04 95 a0 31 80 00 	mov    0x8031a0(,%edx,4),%eax
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 ee                	jne    8016fa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80170c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801711:	8b 40 48             	mov    0x48(%eax),%eax
  801714:	83 ec 04             	sub    $0x4,%esp
  801717:	51                   	push   %ecx
  801718:	50                   	push   %eax
  801719:	68 24 31 80 00       	push   $0x803124
  80171e:	e8 c8 eb ff ff       	call   8002eb <cprintf>
	*dev = 0;
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    
			*dev = devtab[i];
  801736:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801739:	89 01                	mov    %eax,(%ecx)
			return 0;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	eb f2                	jmp    801734 <dev_lookup+0x4d>

00801742 <fd_close>:
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 24             	sub    $0x24,%esp
  80174b:	8b 75 08             	mov    0x8(%ebp),%esi
  80174e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801751:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801754:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801755:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80175b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80175e:	50                   	push   %eax
  80175f:	e8 33 ff ff ff       	call   801697 <fd_lookup>
  801764:	89 c3                	mov    %eax,%ebx
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 05                	js     801772 <fd_close+0x30>
	    || fd != fd2)
  80176d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801770:	74 16                	je     801788 <fd_close+0x46>
		return (must_exist ? r : 0);
  801772:	89 f8                	mov    %edi,%eax
  801774:	84 c0                	test   %al,%al
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
  80177b:	0f 44 d8             	cmove  %eax,%ebx
}
  80177e:	89 d8                	mov    %ebx,%eax
  801780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801783:	5b                   	pop    %ebx
  801784:	5e                   	pop    %esi
  801785:	5f                   	pop    %edi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	ff 36                	pushl  (%esi)
  801791:	e8 51 ff ff ff       	call   8016e7 <dev_lookup>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 1a                	js     8017b9 <fd_close+0x77>
		if (dev->dev_close)
  80179f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	74 0b                	je     8017b9 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	56                   	push   %esi
  8017b2:	ff d0                	call   *%eax
  8017b4:	89 c3                	mov    %eax,%ebx
  8017b6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	56                   	push   %esi
  8017bd:	6a 00                	push   $0x0
  8017bf:	e8 fd f6 ff ff       	call   800ec1 <sys_page_unmap>
	return r;
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	eb b5                	jmp    80177e <fd_close+0x3c>

008017c9 <close>:

int
close(int fdnum)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 bc fe ff ff       	call   801697 <fd_lookup>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	79 02                	jns    8017e4 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    
		return fd_close(fd, 1);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	6a 01                	push   $0x1
  8017e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ec:	e8 51 ff ff ff       	call   801742 <fd_close>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	eb ec                	jmp    8017e2 <close+0x19>

008017f6 <close_all>:

void
close_all(void)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	53                   	push   %ebx
  801806:	e8 be ff ff ff       	call   8017c9 <close>
	for (i = 0; i < MAXFD; i++)
  80180b:	83 c3 01             	add    $0x1,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	83 fb 20             	cmp    $0x20,%ebx
  801814:	75 ec                	jne    801802 <close_all+0xc>
}
  801816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	57                   	push   %edi
  80181f:	56                   	push   %esi
  801820:	53                   	push   %ebx
  801821:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801824:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801827:	50                   	push   %eax
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	e8 67 fe ff ff       	call   801697 <fd_lookup>
  801830:	89 c3                	mov    %eax,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	0f 88 81 00 00 00    	js     8018be <dup+0xa3>
		return r;
	close(newfdnum);
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	e8 81 ff ff ff       	call   8017c9 <close>

	newfd = INDEX2FD(newfdnum);
  801848:	8b 75 0c             	mov    0xc(%ebp),%esi
  80184b:	c1 e6 0c             	shl    $0xc,%esi
  80184e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801854:	83 c4 04             	add    $0x4,%esp
  801857:	ff 75 e4             	pushl  -0x1c(%ebp)
  80185a:	e8 cf fd ff ff       	call   80162e <fd2data>
  80185f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801861:	89 34 24             	mov    %esi,(%esp)
  801864:	e8 c5 fd ff ff       	call   80162e <fd2data>
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80186e:	89 d8                	mov    %ebx,%eax
  801870:	c1 e8 16             	shr    $0x16,%eax
  801873:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80187a:	a8 01                	test   $0x1,%al
  80187c:	74 11                	je     80188f <dup+0x74>
  80187e:	89 d8                	mov    %ebx,%eax
  801880:	c1 e8 0c             	shr    $0xc,%eax
  801883:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80188a:	f6 c2 01             	test   $0x1,%dl
  80188d:	75 39                	jne    8018c8 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80188f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801892:	89 d0                	mov    %edx,%eax
  801894:	c1 e8 0c             	shr    $0xc,%eax
  801897:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8018a6:	50                   	push   %eax
  8018a7:	56                   	push   %esi
  8018a8:	6a 00                	push   $0x0
  8018aa:	52                   	push   %edx
  8018ab:	6a 00                	push   $0x0
  8018ad:	e8 cd f5 ff ff       	call   800e7f <sys_page_map>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 20             	add    $0x20,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 31                	js     8018ec <dup+0xd1>
		goto err;

	return newfdnum;
  8018bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018be:	89 d8                	mov    %ebx,%eax
  8018c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018cf:	83 ec 0c             	sub    $0xc,%esp
  8018d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d7:	50                   	push   %eax
  8018d8:	57                   	push   %edi
  8018d9:	6a 00                	push   $0x0
  8018db:	53                   	push   %ebx
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 9c f5 ff ff       	call   800e7f <sys_page_map>
  8018e3:	89 c3                	mov    %eax,%ebx
  8018e5:	83 c4 20             	add    $0x20,%esp
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	79 a3                	jns    80188f <dup+0x74>
	sys_page_unmap(0, newfd);
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	56                   	push   %esi
  8018f0:	6a 00                	push   $0x0
  8018f2:	e8 ca f5 ff ff       	call   800ec1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018f7:	83 c4 08             	add    $0x8,%esp
  8018fa:	57                   	push   %edi
  8018fb:	6a 00                	push   $0x0
  8018fd:	e8 bf f5 ff ff       	call   800ec1 <sys_page_unmap>
	return r;
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	eb b7                	jmp    8018be <dup+0xa3>

00801907 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	53                   	push   %ebx
  80190b:	83 ec 1c             	sub    $0x1c,%esp
  80190e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801911:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801914:	50                   	push   %eax
  801915:	53                   	push   %ebx
  801916:	e8 7c fd ff ff       	call   801697 <fd_lookup>
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 3f                	js     801961 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801922:	83 ec 08             	sub    $0x8,%esp
  801925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801928:	50                   	push   %eax
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	ff 30                	pushl  (%eax)
  80192e:	e8 b4 fd ff ff       	call   8016e7 <dev_lookup>
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 27                	js     801961 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80193a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193d:	8b 42 08             	mov    0x8(%edx),%eax
  801940:	83 e0 03             	and    $0x3,%eax
  801943:	83 f8 01             	cmp    $0x1,%eax
  801946:	74 1e                	je     801966 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	8b 40 08             	mov    0x8(%eax),%eax
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 35                	je     801987 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	ff 75 10             	pushl  0x10(%ebp)
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	52                   	push   %edx
  80195c:	ff d0                	call   *%eax
  80195e:	83 c4 10             	add    $0x10,%esp
}
  801961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801964:	c9                   	leave  
  801965:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801966:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80196b:	8b 40 48             	mov    0x48(%eax),%eax
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	53                   	push   %ebx
  801972:	50                   	push   %eax
  801973:	68 65 31 80 00       	push   $0x803165
  801978:	e8 6e e9 ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801985:	eb da                	jmp    801961 <read+0x5a>
		return -E_NOT_SUPP;
  801987:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198c:	eb d3                	jmp    801961 <read+0x5a>

0080198e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	8b 7d 08             	mov    0x8(%ebp),%edi
  80199a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80199d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019a2:	39 f3                	cmp    %esi,%ebx
  8019a4:	73 23                	jae    8019c9 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	89 f0                	mov    %esi,%eax
  8019ab:	29 d8                	sub    %ebx,%eax
  8019ad:	50                   	push   %eax
  8019ae:	89 d8                	mov    %ebx,%eax
  8019b0:	03 45 0c             	add    0xc(%ebp),%eax
  8019b3:	50                   	push   %eax
  8019b4:	57                   	push   %edi
  8019b5:	e8 4d ff ff ff       	call   801907 <read>
		if (m < 0)
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 06                	js     8019c7 <readn+0x39>
			return m;
		if (m == 0)
  8019c1:	74 06                	je     8019c9 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019c3:	01 c3                	add    %eax,%ebx
  8019c5:	eb db                	jmp    8019a2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019c9:	89 d8                	mov    %ebx,%eax
  8019cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 1c             	sub    $0x1c,%esp
  8019da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e0:	50                   	push   %eax
  8019e1:	53                   	push   %ebx
  8019e2:	e8 b0 fc ff ff       	call   801697 <fd_lookup>
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 3a                	js     801a28 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f4:	50                   	push   %eax
  8019f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f8:	ff 30                	pushl  (%eax)
  8019fa:	e8 e8 fc ff ff       	call   8016e7 <dev_lookup>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 22                	js     801a28 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a0d:	74 1e                	je     801a2d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a12:	8b 52 0c             	mov    0xc(%edx),%edx
  801a15:	85 d2                	test   %edx,%edx
  801a17:	74 35                	je     801a4e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	ff d2                	call   *%edx
  801a25:	83 c4 10             	add    $0x10,%esp
}
  801a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a2d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a32:	8b 40 48             	mov    0x48(%eax),%eax
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	53                   	push   %ebx
  801a39:	50                   	push   %eax
  801a3a:	68 81 31 80 00       	push   $0x803181
  801a3f:	e8 a7 e8 ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4c:	eb da                	jmp    801a28 <write+0x55>
		return -E_NOT_SUPP;
  801a4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a53:	eb d3                	jmp    801a28 <write+0x55>

00801a55 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5e:	50                   	push   %eax
  801a5f:	ff 75 08             	pushl  0x8(%ebp)
  801a62:	e8 30 fc ff ff       	call   801697 <fd_lookup>
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 0e                	js     801a7c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a74:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a88:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	53                   	push   %ebx
  801a8d:	e8 05 fc ff ff       	call   801697 <fd_lookup>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 37                	js     801ad0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9f:	50                   	push   %eax
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	ff 30                	pushl  (%eax)
  801aa5:	e8 3d fc ff ff       	call   8016e7 <dev_lookup>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 1f                	js     801ad0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab8:	74 1b                	je     801ad5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abd:	8b 52 18             	mov    0x18(%edx),%edx
  801ac0:	85 d2                	test   %edx,%edx
  801ac2:	74 32                	je     801af6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	50                   	push   %eax
  801acb:	ff d2                	call   *%edx
  801acd:	83 c4 10             	add    $0x10,%esp
}
  801ad0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    
			thisenv->env_id, fdnum);
  801ad5:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ada:	8b 40 48             	mov    0x48(%eax),%eax
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	53                   	push   %ebx
  801ae1:	50                   	push   %eax
  801ae2:	68 44 31 80 00       	push   $0x803144
  801ae7:	e8 ff e7 ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af4:	eb da                	jmp    801ad0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801af6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801afb:	eb d3                	jmp    801ad0 <ftruncate+0x52>

00801afd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	53                   	push   %ebx
  801b01:	83 ec 1c             	sub    $0x1c,%esp
  801b04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b07:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0a:	50                   	push   %eax
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	e8 84 fb ff ff       	call   801697 <fd_lookup>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 4b                	js     801b65 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b20:	50                   	push   %eax
  801b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b24:	ff 30                	pushl  (%eax)
  801b26:	e8 bc fb ff ff       	call   8016e7 <dev_lookup>
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	78 33                	js     801b65 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b39:	74 2f                	je     801b6a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b3b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b3e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b45:	00 00 00 
	stat->st_isdir = 0;
  801b48:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b4f:	00 00 00 
	stat->st_dev = dev;
  801b52:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	53                   	push   %ebx
  801b5c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b5f:	ff 50 14             	call   *0x14(%eax)
  801b62:	83 c4 10             	add    $0x10,%esp
}
  801b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    
		return -E_NOT_SUPP;
  801b6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6f:	eb f4                	jmp    801b65 <fstat+0x68>

00801b71 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	e8 22 02 00 00       	call   801da5 <open>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 1b                	js     801ba7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b8c:	83 ec 08             	sub    $0x8,%esp
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	50                   	push   %eax
  801b93:	e8 65 ff ff ff       	call   801afd <fstat>
  801b98:	89 c6                	mov    %eax,%esi
	close(fd);
  801b9a:	89 1c 24             	mov    %ebx,(%esp)
  801b9d:	e8 27 fc ff ff       	call   8017c9 <close>
	return r;
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	89 f3                	mov    %esi,%ebx
}
  801ba7:	89 d8                	mov    %ebx,%eax
  801ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    

00801bb0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	89 c6                	mov    %eax,%esi
  801bb7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bb9:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bc0:	74 27                	je     801be9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bc2:	6a 07                	push   $0x7
  801bc4:	68 00 60 80 00       	push   $0x806000
  801bc9:	56                   	push   %esi
  801bca:	ff 35 00 50 80 00    	pushl  0x805000
  801bd0:	e8 9d 0c 00 00       	call   802872 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bd5:	83 c4 0c             	add    $0xc,%esp
  801bd8:	6a 00                	push   $0x0
  801bda:	53                   	push   %ebx
  801bdb:	6a 00                	push   $0x0
  801bdd:	e8 27 0c 00 00       	call   802809 <ipc_recv>
}
  801be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801be9:	83 ec 0c             	sub    $0xc,%esp
  801bec:	6a 01                	push   $0x1
  801bee:	e8 d7 0c 00 00       	call   8028ca <ipc_find_env>
  801bf3:	a3 00 50 80 00       	mov    %eax,0x805000
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	eb c5                	jmp    801bc2 <fsipc+0x12>

00801bfd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	8b 40 0c             	mov    0xc(%eax),%eax
  801c09:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c11:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c16:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1b:	b8 02 00 00 00       	mov    $0x2,%eax
  801c20:	e8 8b ff ff ff       	call   801bb0 <fsipc>
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <devfile_flush>:
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c38:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3d:	b8 06 00 00 00       	mov    $0x6,%eax
  801c42:	e8 69 ff ff ff       	call   801bb0 <fsipc>
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <devfile_stat>:
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	53                   	push   %ebx
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	8b 40 0c             	mov    0xc(%eax),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c63:	b8 05 00 00 00       	mov    $0x5,%eax
  801c68:	e8 43 ff ff ff       	call   801bb0 <fsipc>
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	78 2c                	js     801c9d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	68 00 60 80 00       	push   $0x806000
  801c79:	53                   	push   %ebx
  801c7a:	e8 cb ed ff ff       	call   800a4a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c7f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c8a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <devfile_write>:
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cb7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cbd:	53                   	push   %ebx
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	68 08 60 80 00       	push   $0x806008
  801cc6:	e8 6f ef ff ff       	call   800c3a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd0:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd5:	e8 d6 fe ff ff       	call   801bb0 <fsipc>
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	78 0b                	js     801cec <devfile_write+0x4a>
	assert(r <= n);
  801ce1:	39 d8                	cmp    %ebx,%eax
  801ce3:	77 0c                	ja     801cf1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801ce5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cea:	7f 1e                	jg     801d0a <devfile_write+0x68>
}
  801cec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    
	assert(r <= n);
  801cf1:	68 b4 31 80 00       	push   $0x8031b4
  801cf6:	68 bb 31 80 00       	push   $0x8031bb
  801cfb:	68 98 00 00 00       	push   $0x98
  801d00:	68 d0 31 80 00       	push   $0x8031d0
  801d05:	e8 eb e4 ff ff       	call   8001f5 <_panic>
	assert(r <= PGSIZE);
  801d0a:	68 db 31 80 00       	push   $0x8031db
  801d0f:	68 bb 31 80 00       	push   $0x8031bb
  801d14:	68 99 00 00 00       	push   $0x99
  801d19:	68 d0 31 80 00       	push   $0x8031d0
  801d1e:	e8 d2 e4 ff ff       	call   8001f5 <_panic>

00801d23 <devfile_read>:
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d36:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	b8 03 00 00 00       	mov    $0x3,%eax
  801d46:	e8 65 fe ff ff       	call   801bb0 <fsipc>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 1f                	js     801d70 <devfile_read+0x4d>
	assert(r <= n);
  801d51:	39 f0                	cmp    %esi,%eax
  801d53:	77 24                	ja     801d79 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d55:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d5a:	7f 33                	jg     801d8f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	50                   	push   %eax
  801d60:	68 00 60 80 00       	push   $0x806000
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	e8 6b ee ff ff       	call   800bd8 <memmove>
	return r;
  801d6d:	83 c4 10             	add    $0x10,%esp
}
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d75:	5b                   	pop    %ebx
  801d76:	5e                   	pop    %esi
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    
	assert(r <= n);
  801d79:	68 b4 31 80 00       	push   $0x8031b4
  801d7e:	68 bb 31 80 00       	push   $0x8031bb
  801d83:	6a 7c                	push   $0x7c
  801d85:	68 d0 31 80 00       	push   $0x8031d0
  801d8a:	e8 66 e4 ff ff       	call   8001f5 <_panic>
	assert(r <= PGSIZE);
  801d8f:	68 db 31 80 00       	push   $0x8031db
  801d94:	68 bb 31 80 00       	push   $0x8031bb
  801d99:	6a 7d                	push   $0x7d
  801d9b:	68 d0 31 80 00       	push   $0x8031d0
  801da0:	e8 50 e4 ff ff       	call   8001f5 <_panic>

00801da5 <open>:
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	56                   	push   %esi
  801da9:	53                   	push   %ebx
  801daa:	83 ec 1c             	sub    $0x1c,%esp
  801dad:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801db0:	56                   	push   %esi
  801db1:	e8 5b ec ff ff       	call   800a11 <strlen>
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dbe:	7f 6c                	jg     801e2c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc6:	50                   	push   %eax
  801dc7:	e8 79 f8 ff ff       	call   801645 <fd_alloc>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	85 c0                	test   %eax,%eax
  801dd3:	78 3c                	js     801e11 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	56                   	push   %esi
  801dd9:	68 00 60 80 00       	push   $0x806000
  801dde:	e8 67 ec ff ff       	call   800a4a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de6:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801deb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	e8 b8 fd ff ff       	call   801bb0 <fsipc>
  801df8:	89 c3                	mov    %eax,%ebx
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	78 19                	js     801e1a <open+0x75>
	return fd2num(fd);
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	ff 75 f4             	pushl  -0xc(%ebp)
  801e07:	e8 12 f8 ff ff       	call   80161e <fd2num>
  801e0c:	89 c3                	mov    %eax,%ebx
  801e0e:	83 c4 10             	add    $0x10,%esp
}
  801e11:	89 d8                	mov    %ebx,%eax
  801e13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5e                   	pop    %esi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    
		fd_close(fd, 0);
  801e1a:	83 ec 08             	sub    $0x8,%esp
  801e1d:	6a 00                	push   $0x0
  801e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e22:	e8 1b f9 ff ff       	call   801742 <fd_close>
		return r;
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	eb e5                	jmp    801e11 <open+0x6c>
		return -E_BAD_PATH;
  801e2c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e31:	eb de                	jmp    801e11 <open+0x6c>

00801e33 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e39:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e43:	e8 68 fd ff ff       	call   801bb0 <fsipc>
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801e50:	68 e7 31 80 00       	push   $0x8031e7
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	e8 ed eb ff ff       	call   800a4a <strcpy>
	return 0;
}
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <devsock_close>:
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	53                   	push   %ebx
  801e68:	83 ec 10             	sub    $0x10,%esp
  801e6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e6e:	53                   	push   %ebx
  801e6f:	e8 95 0a 00 00       	call   802909 <pageref>
  801e74:	83 c4 10             	add    $0x10,%esp
		return 0;
  801e77:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801e7c:	83 f8 01             	cmp    $0x1,%eax
  801e7f:	74 07                	je     801e88 <devsock_close+0x24>
}
  801e81:	89 d0                	mov    %edx,%eax
  801e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	ff 73 0c             	pushl  0xc(%ebx)
  801e8e:	e8 b9 02 00 00       	call   80214c <nsipc_close>
  801e93:	89 c2                	mov    %eax,%edx
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	eb e7                	jmp    801e81 <devsock_close+0x1d>

00801e9a <devsock_write>:
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 10             	pushl  0x10(%ebp)
  801ea5:	ff 75 0c             	pushl  0xc(%ebp)
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	ff 70 0c             	pushl  0xc(%eax)
  801eae:	e8 76 03 00 00       	call   802229 <nsipc_send>
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <devsock_read>:
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	ff 75 10             	pushl  0x10(%ebp)
  801ec0:	ff 75 0c             	pushl  0xc(%ebp)
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	ff 70 0c             	pushl  0xc(%eax)
  801ec9:	e8 ef 02 00 00       	call   8021bd <nsipc_recv>
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <fd2sockid>:
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ed6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	e8 b7 f7 ff ff       	call   801697 <fd_lookup>
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 10                	js     801ef7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ef0:	39 08                	cmp    %ecx,(%eax)
  801ef2:	75 05                	jne    801ef9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ef4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    
		return -E_NOT_SUPP;
  801ef9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801efe:	eb f7                	jmp    801ef7 <fd2sockid+0x27>

00801f00 <alloc_sockfd>:
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	56                   	push   %esi
  801f04:	53                   	push   %ebx
  801f05:	83 ec 1c             	sub    $0x1c,%esp
  801f08:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0d:	50                   	push   %eax
  801f0e:	e8 32 f7 ff ff       	call   801645 <fd_alloc>
  801f13:	89 c3                	mov    %eax,%ebx
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 43                	js     801f5f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	ff 75 f4             	pushl  -0xc(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 0e ef ff ff       	call   800e3c <sys_page_alloc>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 28                	js     801f5f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f40:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f4c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	50                   	push   %eax
  801f53:	e8 c6 f6 ff ff       	call   80161e <fd2num>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	eb 0c                	jmp    801f6b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	56                   	push   %esi
  801f63:	e8 e4 01 00 00       	call   80214c <nsipc_close>
		return r;
  801f68:	83 c4 10             	add    $0x10,%esp
}
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    

00801f74 <accept>:
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	e8 4e ff ff ff       	call   801ed0 <fd2sockid>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 1b                	js     801fa1 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	50                   	push   %eax
  801f90:	e8 0e 01 00 00       	call   8020a3 <nsipc_accept>
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	78 05                	js     801fa1 <accept+0x2d>
	return alloc_sockfd(r);
  801f9c:	e8 5f ff ff ff       	call   801f00 <alloc_sockfd>
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <bind>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	e8 1f ff ff ff       	call   801ed0 <fd2sockid>
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 12                	js     801fc7 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	ff 75 10             	pushl  0x10(%ebp)
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	50                   	push   %eax
  801fbf:	e8 31 01 00 00       	call   8020f5 <nsipc_bind>
  801fc4:	83 c4 10             	add    $0x10,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <shutdown>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	e8 f9 fe ff ff       	call   801ed0 <fd2sockid>
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	78 0f                	js     801fea <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801fdb:	83 ec 08             	sub    $0x8,%esp
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	50                   	push   %eax
  801fe2:	e8 43 01 00 00       	call   80212a <nsipc_shutdown>
  801fe7:	83 c4 10             	add    $0x10,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <connect>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	e8 d6 fe ff ff       	call   801ed0 <fd2sockid>
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 12                	js     802010 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	ff 75 10             	pushl  0x10(%ebp)
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	50                   	push   %eax
  802008:	e8 59 01 00 00       	call   802166 <nsipc_connect>
  80200d:	83 c4 10             	add    $0x10,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <listen>:
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	e8 b0 fe ff ff       	call   801ed0 <fd2sockid>
  802020:	85 c0                	test   %eax,%eax
  802022:	78 0f                	js     802033 <listen+0x21>
	return nsipc_listen(r, backlog);
  802024:	83 ec 08             	sub    $0x8,%esp
  802027:	ff 75 0c             	pushl  0xc(%ebp)
  80202a:	50                   	push   %eax
  80202b:	e8 6b 01 00 00       	call   80219b <nsipc_listen>
  802030:	83 c4 10             	add    $0x10,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <socket>:

int
socket(int domain, int type, int protocol)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80203b:	ff 75 10             	pushl  0x10(%ebp)
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	ff 75 08             	pushl  0x8(%ebp)
  802044:	e8 3e 02 00 00       	call   802287 <nsipc_socket>
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 05                	js     802055 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802050:	e8 ab fe ff ff       	call   801f00 <alloc_sockfd>
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	53                   	push   %ebx
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802060:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802067:	74 26                	je     80208f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802069:	6a 07                	push   $0x7
  80206b:	68 00 70 80 00       	push   $0x807000
  802070:	53                   	push   %ebx
  802071:	ff 35 04 50 80 00    	pushl  0x805004
  802077:	e8 f6 07 00 00       	call   802872 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80207c:	83 c4 0c             	add    $0xc,%esp
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	e8 7f 07 00 00       	call   802809 <ipc_recv>
}
  80208a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	6a 02                	push   $0x2
  802094:	e8 31 08 00 00       	call   8028ca <ipc_find_env>
  802099:	a3 04 50 80 00       	mov    %eax,0x805004
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	eb c6                	jmp    802069 <nsipc+0x12>

008020a3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	56                   	push   %esi
  8020a7:	53                   	push   %ebx
  8020a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020b3:	8b 06                	mov    (%esi),%eax
  8020b5:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bf:	e8 93 ff ff ff       	call   802057 <nsipc>
  8020c4:	89 c3                	mov    %eax,%ebx
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	79 09                	jns    8020d3 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8020ca:	89 d8                	mov    %ebx,%eax
  8020cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020d3:	83 ec 04             	sub    $0x4,%esp
  8020d6:	ff 35 10 70 80 00    	pushl  0x807010
  8020dc:	68 00 70 80 00       	push   $0x807000
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	e8 ef ea ff ff       	call   800bd8 <memmove>
		*addrlen = ret->ret_addrlen;
  8020e9:	a1 10 70 80 00       	mov    0x807010,%eax
  8020ee:	89 06                	mov    %eax,(%esi)
  8020f0:	83 c4 10             	add    $0x10,%esp
	return r;
  8020f3:	eb d5                	jmp    8020ca <nsipc_accept+0x27>

008020f5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	53                   	push   %ebx
  8020f9:	83 ec 08             	sub    $0x8,%esp
  8020fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802107:	53                   	push   %ebx
  802108:	ff 75 0c             	pushl  0xc(%ebp)
  80210b:	68 04 70 80 00       	push   $0x807004
  802110:	e8 c3 ea ff ff       	call   800bd8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802115:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80211b:	b8 02 00 00 00       	mov    $0x2,%eax
  802120:	e8 32 ff ff ff       	call   802057 <nsipc>
}
  802125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802140:	b8 03 00 00 00       	mov    $0x3,%eax
  802145:	e8 0d ff ff ff       	call   802057 <nsipc>
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <nsipc_close>:

int
nsipc_close(int s)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80215a:	b8 04 00 00 00       	mov    $0x4,%eax
  80215f:	e8 f3 fe ff ff       	call   802057 <nsipc>
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	53                   	push   %ebx
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802178:	53                   	push   %ebx
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	68 04 70 80 00       	push   $0x807004
  802181:	e8 52 ea ff ff       	call   800bd8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802186:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80218c:	b8 05 00 00 00       	mov    $0x5,%eax
  802191:	e8 c1 fe ff ff       	call   802057 <nsipc>
}
  802196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8021b6:	e8 9c fe ff ff       	call   802057 <nsipc>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021cd:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d6:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021db:	b8 07 00 00 00       	mov    $0x7,%eax
  8021e0:	e8 72 fe ff ff       	call   802057 <nsipc>
  8021e5:	89 c3                	mov    %eax,%ebx
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	78 1f                	js     80220a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8021eb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021f0:	7f 21                	jg     802213 <nsipc_recv+0x56>
  8021f2:	39 c6                	cmp    %eax,%esi
  8021f4:	7c 1d                	jl     802213 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	50                   	push   %eax
  8021fa:	68 00 70 80 00       	push   $0x807000
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	e8 d1 e9 ff ff       	call   800bd8 <memmove>
  802207:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80220a:	89 d8                	mov    %ebx,%eax
  80220c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80220f:	5b                   	pop    %ebx
  802210:	5e                   	pop    %esi
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802213:	68 f3 31 80 00       	push   $0x8031f3
  802218:	68 bb 31 80 00       	push   $0x8031bb
  80221d:	6a 62                	push   $0x62
  80221f:	68 08 32 80 00       	push   $0x803208
  802224:	e8 cc df ff ff       	call   8001f5 <_panic>

00802229 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	53                   	push   %ebx
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80223b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802241:	7f 2e                	jg     802271 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	53                   	push   %ebx
  802247:	ff 75 0c             	pushl  0xc(%ebp)
  80224a:	68 0c 70 80 00       	push   $0x80700c
  80224f:	e8 84 e9 ff ff       	call   800bd8 <memmove>
	nsipcbuf.send.req_size = size;
  802254:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80225a:	8b 45 14             	mov    0x14(%ebp),%eax
  80225d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802262:	b8 08 00 00 00       	mov    $0x8,%eax
  802267:	e8 eb fd ff ff       	call   802057 <nsipc>
}
  80226c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80226f:	c9                   	leave  
  802270:	c3                   	ret    
	assert(size < 1600);
  802271:	68 14 32 80 00       	push   $0x803214
  802276:	68 bb 31 80 00       	push   $0x8031bb
  80227b:	6a 6d                	push   $0x6d
  80227d:	68 08 32 80 00       	push   $0x803208
  802282:	e8 6e df ff ff       	call   8001f5 <_panic>

00802287 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022a5:	b8 09 00 00 00       	mov    $0x9,%eax
  8022aa:	e8 a8 fd ff ff       	call   802057 <nsipc>
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	56                   	push   %esi
  8022b5:	53                   	push   %ebx
  8022b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022b9:	83 ec 0c             	sub    $0xc,%esp
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	e8 6a f3 ff ff       	call   80162e <fd2data>
  8022c4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022c6:	83 c4 08             	add    $0x8,%esp
  8022c9:	68 20 32 80 00       	push   $0x803220
  8022ce:	53                   	push   %ebx
  8022cf:	e8 76 e7 ff ff       	call   800a4a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022d4:	8b 46 04             	mov    0x4(%esi),%eax
  8022d7:	2b 06                	sub    (%esi),%eax
  8022d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022e6:	00 00 00 
	stat->st_dev = &devpipe;
  8022e9:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022f0:	40 80 00 
	return 0;
}
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    

008022ff <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	53                   	push   %ebx
  802303:	83 ec 0c             	sub    $0xc,%esp
  802306:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802309:	53                   	push   %ebx
  80230a:	6a 00                	push   $0x0
  80230c:	e8 b0 eb ff ff       	call   800ec1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802311:	89 1c 24             	mov    %ebx,(%esp)
  802314:	e8 15 f3 ff ff       	call   80162e <fd2data>
  802319:	83 c4 08             	add    $0x8,%esp
  80231c:	50                   	push   %eax
  80231d:	6a 00                	push   $0x0
  80231f:	e8 9d eb ff ff       	call   800ec1 <sys_page_unmap>
}
  802324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <_pipeisclosed>:
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	57                   	push   %edi
  80232d:	56                   	push   %esi
  80232e:	53                   	push   %ebx
  80232f:	83 ec 1c             	sub    $0x1c,%esp
  802332:	89 c7                	mov    %eax,%edi
  802334:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802336:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80233b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80233e:	83 ec 0c             	sub    $0xc,%esp
  802341:	57                   	push   %edi
  802342:	e8 c2 05 00 00       	call   802909 <pageref>
  802347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80234a:	89 34 24             	mov    %esi,(%esp)
  80234d:	e8 b7 05 00 00       	call   802909 <pageref>
		nn = thisenv->env_runs;
  802352:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  802358:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	39 cb                	cmp    %ecx,%ebx
  802360:	74 1b                	je     80237d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802362:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802365:	75 cf                	jne    802336 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802367:	8b 42 58             	mov    0x58(%edx),%eax
  80236a:	6a 01                	push   $0x1
  80236c:	50                   	push   %eax
  80236d:	53                   	push   %ebx
  80236e:	68 27 32 80 00       	push   $0x803227
  802373:	e8 73 df ff ff       	call   8002eb <cprintf>
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	eb b9                	jmp    802336 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80237d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802380:	0f 94 c0             	sete   %al
  802383:	0f b6 c0             	movzbl %al,%eax
}
  802386:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802389:	5b                   	pop    %ebx
  80238a:	5e                   	pop    %esi
  80238b:	5f                   	pop    %edi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    

0080238e <devpipe_write>:
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 28             	sub    $0x28,%esp
  802397:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80239a:	56                   	push   %esi
  80239b:	e8 8e f2 ff ff       	call   80162e <fd2data>
  8023a0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023a2:	83 c4 10             	add    $0x10,%esp
  8023a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8023aa:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023ad:	74 4f                	je     8023fe <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023af:	8b 43 04             	mov    0x4(%ebx),%eax
  8023b2:	8b 0b                	mov    (%ebx),%ecx
  8023b4:	8d 51 20             	lea    0x20(%ecx),%edx
  8023b7:	39 d0                	cmp    %edx,%eax
  8023b9:	72 14                	jb     8023cf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8023bb:	89 da                	mov    %ebx,%edx
  8023bd:	89 f0                	mov    %esi,%eax
  8023bf:	e8 65 ff ff ff       	call   802329 <_pipeisclosed>
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	75 3b                	jne    802403 <devpipe_write+0x75>
			sys_yield();
  8023c8:	e8 50 ea ff ff       	call   800e1d <sys_yield>
  8023cd:	eb e0                	jmp    8023af <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023d2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023d6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023d9:	89 c2                	mov    %eax,%edx
  8023db:	c1 fa 1f             	sar    $0x1f,%edx
  8023de:	89 d1                	mov    %edx,%ecx
  8023e0:	c1 e9 1b             	shr    $0x1b,%ecx
  8023e3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023e6:	83 e2 1f             	and    $0x1f,%edx
  8023e9:	29 ca                	sub    %ecx,%edx
  8023eb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023ef:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023f3:	83 c0 01             	add    $0x1,%eax
  8023f6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023f9:	83 c7 01             	add    $0x1,%edi
  8023fc:	eb ac                	jmp    8023aa <devpipe_write+0x1c>
	return i;
  8023fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802401:	eb 05                	jmp    802408 <devpipe_write+0x7a>
				return 0;
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5f                   	pop    %edi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <devpipe_read>:
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	57                   	push   %edi
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
  802416:	83 ec 18             	sub    $0x18,%esp
  802419:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80241c:	57                   	push   %edi
  80241d:	e8 0c f2 ff ff       	call   80162e <fd2data>
  802422:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	be 00 00 00 00       	mov    $0x0,%esi
  80242c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80242f:	75 14                	jne    802445 <devpipe_read+0x35>
	return i;
  802431:	8b 45 10             	mov    0x10(%ebp),%eax
  802434:	eb 02                	jmp    802438 <devpipe_read+0x28>
				return i;
  802436:	89 f0                	mov    %esi,%eax
}
  802438:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80243b:	5b                   	pop    %ebx
  80243c:	5e                   	pop    %esi
  80243d:	5f                   	pop    %edi
  80243e:	5d                   	pop    %ebp
  80243f:	c3                   	ret    
			sys_yield();
  802440:	e8 d8 e9 ff ff       	call   800e1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802445:	8b 03                	mov    (%ebx),%eax
  802447:	3b 43 04             	cmp    0x4(%ebx),%eax
  80244a:	75 18                	jne    802464 <devpipe_read+0x54>
			if (i > 0)
  80244c:	85 f6                	test   %esi,%esi
  80244e:	75 e6                	jne    802436 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802450:	89 da                	mov    %ebx,%edx
  802452:	89 f8                	mov    %edi,%eax
  802454:	e8 d0 fe ff ff       	call   802329 <_pipeisclosed>
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 e3                	je     802440 <devpipe_read+0x30>
				return 0;
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	eb d4                	jmp    802438 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802464:	99                   	cltd   
  802465:	c1 ea 1b             	shr    $0x1b,%edx
  802468:	01 d0                	add    %edx,%eax
  80246a:	83 e0 1f             	and    $0x1f,%eax
  80246d:	29 d0                	sub    %edx,%eax
  80246f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802474:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802477:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80247a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80247d:	83 c6 01             	add    $0x1,%esi
  802480:	eb aa                	jmp    80242c <devpipe_read+0x1c>

00802482 <pipe>:
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	56                   	push   %esi
  802486:	53                   	push   %ebx
  802487:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80248a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248d:	50                   	push   %eax
  80248e:	e8 b2 f1 ff ff       	call   801645 <fd_alloc>
  802493:	89 c3                	mov    %eax,%ebx
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	85 c0                	test   %eax,%eax
  80249a:	0f 88 23 01 00 00    	js     8025c3 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	68 07 04 00 00       	push   $0x407
  8024a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ab:	6a 00                	push   $0x0
  8024ad:	e8 8a e9 ff ff       	call   800e3c <sys_page_alloc>
  8024b2:	89 c3                	mov    %eax,%ebx
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	0f 88 04 01 00 00    	js     8025c3 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8024bf:	83 ec 0c             	sub    $0xc,%esp
  8024c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024c5:	50                   	push   %eax
  8024c6:	e8 7a f1 ff ff       	call   801645 <fd_alloc>
  8024cb:	89 c3                	mov    %eax,%ebx
  8024cd:	83 c4 10             	add    $0x10,%esp
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	0f 88 db 00 00 00    	js     8025b3 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024d8:	83 ec 04             	sub    $0x4,%esp
  8024db:	68 07 04 00 00       	push   $0x407
  8024e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e3:	6a 00                	push   $0x0
  8024e5:	e8 52 e9 ff ff       	call   800e3c <sys_page_alloc>
  8024ea:	89 c3                	mov    %eax,%ebx
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	0f 88 bc 00 00 00    	js     8025b3 <pipe+0x131>
	va = fd2data(fd0);
  8024f7:	83 ec 0c             	sub    $0xc,%esp
  8024fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fd:	e8 2c f1 ff ff       	call   80162e <fd2data>
  802502:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802504:	83 c4 0c             	add    $0xc,%esp
  802507:	68 07 04 00 00       	push   $0x407
  80250c:	50                   	push   %eax
  80250d:	6a 00                	push   $0x0
  80250f:	e8 28 e9 ff ff       	call   800e3c <sys_page_alloc>
  802514:	89 c3                	mov    %eax,%ebx
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	85 c0                	test   %eax,%eax
  80251b:	0f 88 82 00 00 00    	js     8025a3 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802521:	83 ec 0c             	sub    $0xc,%esp
  802524:	ff 75 f0             	pushl  -0x10(%ebp)
  802527:	e8 02 f1 ff ff       	call   80162e <fd2data>
  80252c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802533:	50                   	push   %eax
  802534:	6a 00                	push   $0x0
  802536:	56                   	push   %esi
  802537:	6a 00                	push   $0x0
  802539:	e8 41 e9 ff ff       	call   800e7f <sys_page_map>
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	83 c4 20             	add    $0x20,%esp
  802543:	85 c0                	test   %eax,%eax
  802545:	78 4e                	js     802595 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802547:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80255b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802563:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	ff 75 f4             	pushl  -0xc(%ebp)
  802570:	e8 a9 f0 ff ff       	call   80161e <fd2num>
  802575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802578:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80257a:	83 c4 04             	add    $0x4,%esp
  80257d:	ff 75 f0             	pushl  -0x10(%ebp)
  802580:	e8 99 f0 ff ff       	call   80161e <fd2num>
  802585:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802588:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80258b:	83 c4 10             	add    $0x10,%esp
  80258e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802593:	eb 2e                	jmp    8025c3 <pipe+0x141>
	sys_page_unmap(0, va);
  802595:	83 ec 08             	sub    $0x8,%esp
  802598:	56                   	push   %esi
  802599:	6a 00                	push   $0x0
  80259b:	e8 21 e9 ff ff       	call   800ec1 <sys_page_unmap>
  8025a0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025a3:	83 ec 08             	sub    $0x8,%esp
  8025a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a9:	6a 00                	push   $0x0
  8025ab:	e8 11 e9 ff ff       	call   800ec1 <sys_page_unmap>
  8025b0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8025b3:	83 ec 08             	sub    $0x8,%esp
  8025b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b9:	6a 00                	push   $0x0
  8025bb:	e8 01 e9 ff ff       	call   800ec1 <sys_page_unmap>
  8025c0:	83 c4 10             	add    $0x10,%esp
}
  8025c3:	89 d8                	mov    %ebx,%eax
  8025c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c8:	5b                   	pop    %ebx
  8025c9:	5e                   	pop    %esi
  8025ca:	5d                   	pop    %ebp
  8025cb:	c3                   	ret    

008025cc <pipeisclosed>:
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d5:	50                   	push   %eax
  8025d6:	ff 75 08             	pushl  0x8(%ebp)
  8025d9:	e8 b9 f0 ff ff       	call   801697 <fd_lookup>
  8025de:	83 c4 10             	add    $0x10,%esp
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	78 18                	js     8025fd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8025e5:	83 ec 0c             	sub    $0xc,%esp
  8025e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025eb:	e8 3e f0 ff ff       	call   80162e <fd2data>
	return _pipeisclosed(fd, p);
  8025f0:	89 c2                	mov    %eax,%edx
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	e8 2f fd ff ff       	call   802329 <_pipeisclosed>
  8025fa:	83 c4 10             	add    $0x10,%esp
}
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	c3                   	ret    

00802605 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80260b:	68 3f 32 80 00       	push   $0x80323f
  802610:	ff 75 0c             	pushl  0xc(%ebp)
  802613:	e8 32 e4 ff ff       	call   800a4a <strcpy>
	return 0;
}
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <devcons_write>:
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	57                   	push   %edi
  802623:	56                   	push   %esi
  802624:	53                   	push   %ebx
  802625:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80262b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802630:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802636:	3b 75 10             	cmp    0x10(%ebp),%esi
  802639:	73 31                	jae    80266c <devcons_write+0x4d>
		m = n - tot;
  80263b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80263e:	29 f3                	sub    %esi,%ebx
  802640:	83 fb 7f             	cmp    $0x7f,%ebx
  802643:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802648:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	53                   	push   %ebx
  80264f:	89 f0                	mov    %esi,%eax
  802651:	03 45 0c             	add    0xc(%ebp),%eax
  802654:	50                   	push   %eax
  802655:	57                   	push   %edi
  802656:	e8 7d e5 ff ff       	call   800bd8 <memmove>
		sys_cputs(buf, m);
  80265b:	83 c4 08             	add    $0x8,%esp
  80265e:	53                   	push   %ebx
  80265f:	57                   	push   %edi
  802660:	e8 1b e7 ff ff       	call   800d80 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802665:	01 de                	add    %ebx,%esi
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	eb ca                	jmp    802636 <devcons_write+0x17>
}
  80266c:	89 f0                	mov    %esi,%eax
  80266e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <devcons_read>:
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 08             	sub    $0x8,%esp
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802681:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802685:	74 21                	je     8026a8 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802687:	e8 12 e7 ff ff       	call   800d9e <sys_cgetc>
  80268c:	85 c0                	test   %eax,%eax
  80268e:	75 07                	jne    802697 <devcons_read+0x21>
		sys_yield();
  802690:	e8 88 e7 ff ff       	call   800e1d <sys_yield>
  802695:	eb f0                	jmp    802687 <devcons_read+0x11>
	if (c < 0)
  802697:	78 0f                	js     8026a8 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802699:	83 f8 04             	cmp    $0x4,%eax
  80269c:	74 0c                	je     8026aa <devcons_read+0x34>
	*(char*)vbuf = c;
  80269e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a1:	88 02                	mov    %al,(%edx)
	return 1;
  8026a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    
		return 0;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026af:	eb f7                	jmp    8026a8 <devcons_read+0x32>

008026b1 <cputchar>:
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026bd:	6a 01                	push   $0x1
  8026bf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026c2:	50                   	push   %eax
  8026c3:	e8 b8 e6 ff ff       	call   800d80 <sys_cputs>
}
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <getchar>:
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026d3:	6a 01                	push   $0x1
  8026d5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d8:	50                   	push   %eax
  8026d9:	6a 00                	push   $0x0
  8026db:	e8 27 f2 ff ff       	call   801907 <read>
	if (r < 0)
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	78 06                	js     8026ed <getchar+0x20>
	if (r < 1)
  8026e7:	74 06                	je     8026ef <getchar+0x22>
	return c;
  8026e9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    
		return -E_EOF;
  8026ef:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026f4:	eb f7                	jmp    8026ed <getchar+0x20>

008026f6 <iscons>:
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ff:	50                   	push   %eax
  802700:	ff 75 08             	pushl  0x8(%ebp)
  802703:	e8 8f ef ff ff       	call   801697 <fd_lookup>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	85 c0                	test   %eax,%eax
  80270d:	78 11                	js     802720 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802718:	39 10                	cmp    %edx,(%eax)
  80271a:	0f 94 c0             	sete   %al
  80271d:	0f b6 c0             	movzbl %al,%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <opencons>:
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802728:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272b:	50                   	push   %eax
  80272c:	e8 14 ef ff ff       	call   801645 <fd_alloc>
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	85 c0                	test   %eax,%eax
  802736:	78 3a                	js     802772 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 07 04 00 00       	push   $0x407
  802740:	ff 75 f4             	pushl  -0xc(%ebp)
  802743:	6a 00                	push   $0x0
  802745:	e8 f2 e6 ff ff       	call   800e3c <sys_page_alloc>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	85 c0                	test   %eax,%eax
  80274f:	78 21                	js     802772 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80275a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	50                   	push   %eax
  80276a:	e8 af ee ff ff       	call   80161e <fd2num>
  80276f:	83 c4 10             	add    $0x10,%esp
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80277a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802781:	74 0a                	je     80278d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80278b:	c9                   	leave  
  80278c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	6a 07                	push   $0x7
  802792:	68 00 f0 bf ee       	push   $0xeebff000
  802797:	6a 00                	push   $0x0
  802799:	e8 9e e6 ff ff       	call   800e3c <sys_page_alloc>
		if(r < 0)
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	78 2a                	js     8027cf <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8027a5:	83 ec 08             	sub    $0x8,%esp
  8027a8:	68 e3 27 80 00       	push   $0x8027e3
  8027ad:	6a 00                	push   $0x0
  8027af:	e8 d3 e7 ff ff       	call   800f87 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	79 c8                	jns    802783 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 7c 32 80 00       	push   $0x80327c
  8027c3:	6a 25                	push   $0x25
  8027c5:	68 b8 32 80 00       	push   $0x8032b8
  8027ca:	e8 26 da ff ff       	call   8001f5 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	68 4c 32 80 00       	push   $0x80324c
  8027d7:	6a 22                	push   $0x22
  8027d9:	68 b8 32 80 00       	push   $0x8032b8
  8027de:	e8 12 da ff ff       	call   8001f5 <_panic>

008027e3 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027e3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027e4:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027e9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027eb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8027ee:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8027f2:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8027f6:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8027f9:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8027fb:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8027ff:	83 c4 08             	add    $0x8,%esp
	popal
  802802:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802803:	83 c4 04             	add    $0x4,%esp
	popfl
  802806:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802807:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802808:	c3                   	ret    

00802809 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802809:	55                   	push   %ebp
  80280a:	89 e5                	mov    %esp,%ebp
  80280c:	56                   	push   %esi
  80280d:	53                   	push   %ebx
  80280e:	8b 75 08             	mov    0x8(%ebp),%esi
  802811:	8b 45 0c             	mov    0xc(%ebp),%eax
  802814:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802817:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802819:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80281e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802821:	83 ec 0c             	sub    $0xc,%esp
  802824:	50                   	push   %eax
  802825:	e8 c2 e7 ff ff       	call   800fec <sys_ipc_recv>
	if(ret < 0){
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	85 c0                	test   %eax,%eax
  80282f:	78 2b                	js     80285c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802831:	85 f6                	test   %esi,%esi
  802833:	74 0a                	je     80283f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802835:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80283a:	8b 40 78             	mov    0x78(%eax),%eax
  80283d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80283f:	85 db                	test   %ebx,%ebx
  802841:	74 0a                	je     80284d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802843:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802848:	8b 40 7c             	mov    0x7c(%eax),%eax
  80284b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80284d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802852:	8b 40 74             	mov    0x74(%eax),%eax
}
  802855:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802858:	5b                   	pop    %ebx
  802859:	5e                   	pop    %esi
  80285a:	5d                   	pop    %ebp
  80285b:	c3                   	ret    
		if(from_env_store)
  80285c:	85 f6                	test   %esi,%esi
  80285e:	74 06                	je     802866 <ipc_recv+0x5d>
			*from_env_store = 0;
  802860:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802866:	85 db                	test   %ebx,%ebx
  802868:	74 eb                	je     802855 <ipc_recv+0x4c>
			*perm_store = 0;
  80286a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802870:	eb e3                	jmp    802855 <ipc_recv+0x4c>

00802872 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802872:	55                   	push   %ebp
  802873:	89 e5                	mov    %esp,%ebp
  802875:	57                   	push   %edi
  802876:	56                   	push   %esi
  802877:	53                   	push   %ebx
  802878:	83 ec 0c             	sub    $0xc,%esp
  80287b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80287e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802881:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802884:	85 db                	test   %ebx,%ebx
  802886:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80288b:	0f 44 d8             	cmove  %eax,%ebx
  80288e:	eb 05                	jmp    802895 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802890:	e8 88 e5 ff ff       	call   800e1d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802895:	ff 75 14             	pushl  0x14(%ebp)
  802898:	53                   	push   %ebx
  802899:	56                   	push   %esi
  80289a:	57                   	push   %edi
  80289b:	e8 29 e7 ff ff       	call   800fc9 <sys_ipc_try_send>
  8028a0:	83 c4 10             	add    $0x10,%esp
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 1b                	je     8028c2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028a7:	79 e7                	jns    802890 <ipc_send+0x1e>
  8028a9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028ac:	74 e2                	je     802890 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 c6 32 80 00       	push   $0x8032c6
  8028b6:	6a 46                	push   $0x46
  8028b8:	68 db 32 80 00       	push   $0x8032db
  8028bd:	e8 33 d9 ff ff       	call   8001f5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    

008028ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
  8028cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028d5:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8028db:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028e1:	8b 52 50             	mov    0x50(%edx),%edx
  8028e4:	39 ca                	cmp    %ecx,%edx
  8028e6:	74 11                	je     8028f9 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8028e8:	83 c0 01             	add    $0x1,%eax
  8028eb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028f0:	75 e3                	jne    8028d5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f7:	eb 0e                	jmp    802907 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8028f9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8028ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802904:	8b 40 48             	mov    0x48(%eax),%eax
}
  802907:	5d                   	pop    %ebp
  802908:	c3                   	ret    

00802909 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802909:	55                   	push   %ebp
  80290a:	89 e5                	mov    %esp,%ebp
  80290c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80290f:	89 d0                	mov    %edx,%eax
  802911:	c1 e8 16             	shr    $0x16,%eax
  802914:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802920:	f6 c1 01             	test   $0x1,%cl
  802923:	74 1d                	je     802942 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802925:	c1 ea 0c             	shr    $0xc,%edx
  802928:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80292f:	f6 c2 01             	test   $0x1,%dl
  802932:	74 0e                	je     802942 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802934:	c1 ea 0c             	shr    $0xc,%edx
  802937:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80293e:	ef 
  80293f:	0f b7 c0             	movzwl %ax,%eax
}
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    
  802944:	66 90                	xchg   %ax,%ax
  802946:	66 90                	xchg   %ax,%ax
  802948:	66 90                	xchg   %ax,%ax
  80294a:	66 90                	xchg   %ax,%ax
  80294c:	66 90                	xchg   %ax,%ax
  80294e:	66 90                	xchg   %ax,%ax

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
