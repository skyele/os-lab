
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 f1 13 00 00       	call   80143f <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 a4 14 00 00       	call   80150b <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 60 27 80 00       	push   $0x802760
  80007a:	6a 0d                	push   $0xd
  80007c:	68 7b 27 80 00       	push   $0x80277b
  800081:	e8 b4 01 00 00       	call   80023a <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 86 27 80 00       	push   $0x802786
  80009b:	6a 0f                	push   $0xf
  80009d:	68 7b 27 80 00       	push   $0x80277b
  8000a2:	e8 93 01 00 00       	call   80023a <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 9b 	movl   $0x80279b,0x803000
  8000ba:	27 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 9f 27 80 00       	push   $0x80279f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 a7 27 80 00       	push   $0x8027a7
  8000ee:	e8 8d 19 00 00       	call   801a80 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 d2 17 00 00       	call   8018dd <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 d9 11 00 00       	call   801301 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	57                   	push   %edi
  800131:	56                   	push   %esi
  800132:	53                   	push   %ebx
  800133:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800136:	c7 05 20 60 80 00 00 	movl   $0x0,0x806020
  80013d:	00 00 00 
	envid_t find = sys_getenvid();
  800140:	e8 fe 0c 00 00       	call   800e43 <sys_getenvid>
  800145:	8b 1d 20 60 80 00    	mov    0x806020,%ebx
  80014b:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800150:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800155:	bf 01 00 00 00       	mov    $0x1,%edi
  80015a:	eb 0b                	jmp    800167 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80015c:	83 c2 01             	add    $0x1,%edx
  80015f:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800165:	74 21                	je     800188 <libmain+0x5b>
		if(envs[i].env_id == find)
  800167:	89 d1                	mov    %edx,%ecx
  800169:	c1 e1 07             	shl    $0x7,%ecx
  80016c:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800172:	8b 49 48             	mov    0x48(%ecx),%ecx
  800175:	39 c1                	cmp    %eax,%ecx
  800177:	75 e3                	jne    80015c <libmain+0x2f>
  800179:	89 d3                	mov    %edx,%ebx
  80017b:	c1 e3 07             	shl    $0x7,%ebx
  80017e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800184:	89 fe                	mov    %edi,%esi
  800186:	eb d4                	jmp    80015c <libmain+0x2f>
  800188:	89 f0                	mov    %esi,%eax
  80018a:	84 c0                	test   %al,%al
  80018c:	74 06                	je     800194 <libmain+0x67>
  80018e:	89 1d 20 60 80 00    	mov    %ebx,0x806020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800198:	7e 0a                	jle    8001a4 <libmain+0x77>
		binaryname = argv[0];
  80019a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001a4:	a1 20 60 80 00       	mov    0x806020,%eax
  8001a9:	8b 40 48             	mov    0x48(%eax),%eax
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	50                   	push   %eax
  8001b0:	68 ba 27 80 00       	push   $0x8027ba
  8001b5:	e8 76 01 00 00       	call   800330 <cprintf>
	cprintf("before umain\n");
  8001ba:	c7 04 24 d8 27 80 00 	movl   $0x8027d8,(%esp)
  8001c1:	e8 6a 01 00 00       	call   800330 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001c6:	83 c4 08             	add    $0x8,%esp
  8001c9:	ff 75 0c             	pushl  0xc(%ebp)
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	e8 d3 fe ff ff       	call   8000a7 <umain>
	cprintf("after umain\n");
  8001d4:	c7 04 24 e6 27 80 00 	movl   $0x8027e6,(%esp)
  8001db:	e8 50 01 00 00       	call   800330 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001e5:	8b 40 48             	mov    0x48(%eax),%eax
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	50                   	push   %eax
  8001ec:	68 f3 27 80 00       	push   $0x8027f3
  8001f1:	e8 3a 01 00 00       	call   800330 <cprintf>
	// exit gracefully
	exit();
  8001f6:	e8 0b 00 00 00       	call   800206 <exit>
}
  8001fb:	83 c4 10             	add    $0x10,%esp
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    

00800206 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80020c:	a1 20 60 80 00       	mov    0x806020,%eax
  800211:	8b 40 48             	mov    0x48(%eax),%eax
  800214:	68 20 28 80 00       	push   $0x802820
  800219:	50                   	push   %eax
  80021a:	68 12 28 80 00       	push   $0x802812
  80021f:	e8 0c 01 00 00       	call   800330 <cprintf>
	close_all();
  800224:	e8 05 11 00 00       	call   80132e <close_all>
	sys_env_destroy(0);
  800229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800230:	e8 cd 0b 00 00       	call   800e02 <sys_env_destroy>
}
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80023f:	a1 20 60 80 00       	mov    0x806020,%eax
  800244:	8b 40 48             	mov    0x48(%eax),%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 4c 28 80 00       	push   $0x80284c
  80024f:	50                   	push   %eax
  800250:	68 12 28 80 00       	push   $0x802812
  800255:	e8 d6 00 00 00       	call   800330 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80025a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800263:	e8 db 0b 00 00       	call   800e43 <sys_getenvid>
  800268:	83 c4 04             	add    $0x4,%esp
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	56                   	push   %esi
  800272:	50                   	push   %eax
  800273:	68 28 28 80 00       	push   $0x802828
  800278:	e8 b3 00 00 00       	call   800330 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80027d:	83 c4 18             	add    $0x18,%esp
  800280:	53                   	push   %ebx
  800281:	ff 75 10             	pushl  0x10(%ebp)
  800284:	e8 56 00 00 00       	call   8002df <vcprintf>
	cprintf("\n");
  800289:	c7 04 24 d6 27 80 00 	movl   $0x8027d6,(%esp)
  800290:	e8 9b 00 00 00       	call   800330 <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800298:	cc                   	int3   
  800299:	eb fd                	jmp    800298 <_panic+0x5e>

0080029b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	53                   	push   %ebx
  80029f:	83 ec 04             	sub    $0x4,%esp
  8002a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a5:	8b 13                	mov    (%ebx),%edx
  8002a7:	8d 42 01             	lea    0x1(%edx),%eax
  8002aa:	89 03                	mov    %eax,(%ebx)
  8002ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002af:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b8:	74 09                	je     8002c3 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002ba:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	68 ff 00 00 00       	push   $0xff
  8002cb:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ce:	50                   	push   %eax
  8002cf:	e8 f1 0a 00 00       	call   800dc5 <sys_cputs>
		b->idx = 0;
  8002d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	eb db                	jmp    8002ba <putch+0x1f>

008002df <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ef:	00 00 00 
	b.cnt = 0;
  8002f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002fc:	ff 75 0c             	pushl  0xc(%ebp)
  8002ff:	ff 75 08             	pushl  0x8(%ebp)
  800302:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	68 9b 02 80 00       	push   $0x80029b
  80030e:	e8 4a 01 00 00       	call   80045d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800313:	83 c4 08             	add    $0x8,%esp
  800316:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80031c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800322:	50                   	push   %eax
  800323:	e8 9d 0a 00 00       	call   800dc5 <sys_cputs>

	return b.cnt;
}
  800328:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800336:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800339:	50                   	push   %eax
  80033a:	ff 75 08             	pushl  0x8(%ebp)
  80033d:	e8 9d ff ff ff       	call   8002df <vcprintf>
	va_end(ap);

	return cnt;
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	57                   	push   %edi
  800348:	56                   	push   %esi
  800349:	53                   	push   %ebx
  80034a:	83 ec 1c             	sub    $0x1c,%esp
  80034d:	89 c6                	mov    %eax,%esi
  80034f:	89 d7                	mov    %edx,%edi
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	8b 55 0c             	mov    0xc(%ebp),%edx
  800357:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80035d:	8b 45 10             	mov    0x10(%ebp),%eax
  800360:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800363:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800367:	74 2c                	je     800395 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800369:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800373:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800376:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800379:	39 c2                	cmp    %eax,%edx
  80037b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80037e:	73 43                	jae    8003c3 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800380:	83 eb 01             	sub    $0x1,%ebx
  800383:	85 db                	test   %ebx,%ebx
  800385:	7e 6c                	jle    8003f3 <printnum+0xaf>
				putch(padc, putdat);
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	57                   	push   %edi
  80038b:	ff 75 18             	pushl  0x18(%ebp)
  80038e:	ff d6                	call   *%esi
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	eb eb                	jmp    800380 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800395:	83 ec 0c             	sub    $0xc,%esp
  800398:	6a 20                	push   $0x20
  80039a:	6a 00                	push   $0x0
  80039c:	50                   	push   %eax
  80039d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a3:	89 fa                	mov    %edi,%edx
  8003a5:	89 f0                	mov    %esi,%eax
  8003a7:	e8 98 ff ff ff       	call   800344 <printnum>
		while (--width > 0)
  8003ac:	83 c4 20             	add    $0x20,%esp
  8003af:	83 eb 01             	sub    $0x1,%ebx
  8003b2:	85 db                	test   %ebx,%ebx
  8003b4:	7e 65                	jle    80041b <printnum+0xd7>
			putch(padc, putdat);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	57                   	push   %edi
  8003ba:	6a 20                	push   $0x20
  8003bc:	ff d6                	call   *%esi
  8003be:	83 c4 10             	add    $0x10,%esp
  8003c1:	eb ec                	jmp    8003af <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c3:	83 ec 0c             	sub    $0xc,%esp
  8003c6:	ff 75 18             	pushl  0x18(%ebp)
  8003c9:	83 eb 01             	sub    $0x1,%ebx
  8003cc:	53                   	push   %ebx
  8003cd:	50                   	push   %eax
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003da:	ff 75 e0             	pushl  -0x20(%ebp)
  8003dd:	e8 1e 21 00 00       	call   802500 <__udivdi3>
  8003e2:	83 c4 18             	add    $0x18,%esp
  8003e5:	52                   	push   %edx
  8003e6:	50                   	push   %eax
  8003e7:	89 fa                	mov    %edi,%edx
  8003e9:	89 f0                	mov    %esi,%eax
  8003eb:	e8 54 ff ff ff       	call   800344 <printnum>
  8003f0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	57                   	push   %edi
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800400:	ff 75 e4             	pushl  -0x1c(%ebp)
  800403:	ff 75 e0             	pushl  -0x20(%ebp)
  800406:	e8 05 22 00 00       	call   802610 <__umoddi3>
  80040b:	83 c4 14             	add    $0x14,%esp
  80040e:	0f be 80 53 28 80 00 	movsbl 0x802853(%eax),%eax
  800415:	50                   	push   %eax
  800416:	ff d6                	call   *%esi
  800418:	83 c4 10             	add    $0x10,%esp
	}
}
  80041b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041e:	5b                   	pop    %ebx
  80041f:	5e                   	pop    %esi
  800420:	5f                   	pop    %edi
  800421:	5d                   	pop    %ebp
  800422:	c3                   	ret    

00800423 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800423:	55                   	push   %ebp
  800424:	89 e5                	mov    %esp,%ebp
  800426:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800429:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042d:	8b 10                	mov    (%eax),%edx
  80042f:	3b 50 04             	cmp    0x4(%eax),%edx
  800432:	73 0a                	jae    80043e <sprintputch+0x1b>
		*b->buf++ = ch;
  800434:	8d 4a 01             	lea    0x1(%edx),%ecx
  800437:	89 08                	mov    %ecx,(%eax)
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	88 02                	mov    %al,(%edx)
}
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <printfmt>:
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800446:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800449:	50                   	push   %eax
  80044a:	ff 75 10             	pushl  0x10(%ebp)
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	ff 75 08             	pushl  0x8(%ebp)
  800453:	e8 05 00 00 00       	call   80045d <vprintfmt>
}
  800458:	83 c4 10             	add    $0x10,%esp
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <vprintfmt>:
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	57                   	push   %edi
  800461:	56                   	push   %esi
  800462:	53                   	push   %ebx
  800463:	83 ec 3c             	sub    $0x3c,%esp
  800466:	8b 75 08             	mov    0x8(%ebp),%esi
  800469:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80046f:	e9 32 04 00 00       	jmp    8008a6 <vprintfmt+0x449>
		padc = ' ';
  800474:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800478:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80047f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800486:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80048d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800494:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80049b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8d 47 01             	lea    0x1(%edi),%eax
  8004a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a6:	0f b6 17             	movzbl (%edi),%edx
  8004a9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ac:	3c 55                	cmp    $0x55,%al
  8004ae:	0f 87 12 05 00 00    	ja     8009c6 <vprintfmt+0x569>
  8004b4:	0f b6 c0             	movzbl %al,%eax
  8004b7:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c1:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004c5:	eb d9                	jmp    8004a0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004ca:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004ce:	eb d0                	jmp    8004a0 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	0f b6 d2             	movzbl %dl,%edx
  8004d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004db:	89 75 08             	mov    %esi,0x8(%ebp)
  8004de:	eb 03                	jmp    8004e3 <vprintfmt+0x86>
  8004e0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ea:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ed:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f0:	83 fe 09             	cmp    $0x9,%esi
  8004f3:	76 eb                	jbe    8004e0 <vprintfmt+0x83>
  8004f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fb:	eb 14                	jmp    800511 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800511:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800515:	79 89                	jns    8004a0 <vprintfmt+0x43>
				width = precision, precision = -1;
  800517:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800524:	e9 77 ff ff ff       	jmp    8004a0 <vprintfmt+0x43>
  800529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052c:	85 c0                	test   %eax,%eax
  80052e:	0f 48 c1             	cmovs  %ecx,%eax
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800537:	e9 64 ff ff ff       	jmp    8004a0 <vprintfmt+0x43>
  80053c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80053f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800546:	e9 55 ff ff ff       	jmp    8004a0 <vprintfmt+0x43>
			lflag++;
  80054b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800552:	e9 49 ff ff ff       	jmp    8004a0 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 78 04             	lea    0x4(%eax),%edi
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	53                   	push   %ebx
  800561:	ff 30                	pushl  (%eax)
  800563:	ff d6                	call   *%esi
			break;
  800565:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800568:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056b:	e9 33 03 00 00       	jmp    8008a3 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8d 78 04             	lea    0x4(%eax),%edi
  800576:	8b 00                	mov    (%eax),%eax
  800578:	99                   	cltd   
  800579:	31 d0                	xor    %edx,%eax
  80057b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057d:	83 f8 11             	cmp    $0x11,%eax
  800580:	7f 23                	jg     8005a5 <vprintfmt+0x148>
  800582:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  800589:	85 d2                	test   %edx,%edx
  80058b:	74 18                	je     8005a5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80058d:	52                   	push   %edx
  80058e:	68 c1 2c 80 00       	push   $0x802cc1
  800593:	53                   	push   %ebx
  800594:	56                   	push   %esi
  800595:	e8 a6 fe ff ff       	call   800440 <printfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059d:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a0:	e9 fe 02 00 00       	jmp    8008a3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005a5:	50                   	push   %eax
  8005a6:	68 6b 28 80 00       	push   $0x80286b
  8005ab:	53                   	push   %ebx
  8005ac:	56                   	push   %esi
  8005ad:	e8 8e fe ff ff       	call   800440 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005b8:	e9 e6 02 00 00       	jmp    8008a3 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	83 c0 04             	add    $0x4,%eax
  8005c3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	b8 64 28 80 00       	mov    $0x802864,%eax
  8005d2:	0f 45 c1             	cmovne %ecx,%eax
  8005d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dc:	7e 06                	jle    8005e4 <vprintfmt+0x187>
  8005de:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005e2:	75 0d                	jne    8005f1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e7:	89 c7                	mov    %eax,%edi
  8005e9:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ef:	eb 53                	jmp    800644 <vprintfmt+0x1e7>
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	e8 71 04 00 00       	call   800a6e <strnlen>
  8005fd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800600:	29 c1                	sub    %eax,%ecx
  800602:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80060a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80060e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	eb 0f                	jmp    800622 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	ff 75 e0             	pushl  -0x20(%ebp)
  80061a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061c:	83 ef 01             	sub    $0x1,%edi
  80061f:	83 c4 10             	add    $0x10,%esp
  800622:	85 ff                	test   %edi,%edi
  800624:	7f ed                	jg     800613 <vprintfmt+0x1b6>
  800626:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800629:	85 c9                	test   %ecx,%ecx
  80062b:	b8 00 00 00 00       	mov    $0x0,%eax
  800630:	0f 49 c1             	cmovns %ecx,%eax
  800633:	29 c1                	sub    %eax,%ecx
  800635:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800638:	eb aa                	jmp    8005e4 <vprintfmt+0x187>
					putch(ch, putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	52                   	push   %edx
  80063f:	ff d6                	call   *%esi
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800647:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800649:	83 c7 01             	add    $0x1,%edi
  80064c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800650:	0f be d0             	movsbl %al,%edx
  800653:	85 d2                	test   %edx,%edx
  800655:	74 4b                	je     8006a2 <vprintfmt+0x245>
  800657:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065b:	78 06                	js     800663 <vprintfmt+0x206>
  80065d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800661:	78 1e                	js     800681 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800663:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800667:	74 d1                	je     80063a <vprintfmt+0x1dd>
  800669:	0f be c0             	movsbl %al,%eax
  80066c:	83 e8 20             	sub    $0x20,%eax
  80066f:	83 f8 5e             	cmp    $0x5e,%eax
  800672:	76 c6                	jbe    80063a <vprintfmt+0x1dd>
					putch('?', putdat);
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	53                   	push   %ebx
  800678:	6a 3f                	push   $0x3f
  80067a:	ff d6                	call   *%esi
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	eb c3                	jmp    800644 <vprintfmt+0x1e7>
  800681:	89 cf                	mov    %ecx,%edi
  800683:	eb 0e                	jmp    800693 <vprintfmt+0x236>
				putch(' ', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 20                	push   $0x20
  80068b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80068d:	83 ef 01             	sub    $0x1,%edi
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	85 ff                	test   %edi,%edi
  800695:	7f ee                	jg     800685 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800697:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80069a:	89 45 14             	mov    %eax,0x14(%ebp)
  80069d:	e9 01 02 00 00       	jmp    8008a3 <vprintfmt+0x446>
  8006a2:	89 cf                	mov    %ecx,%edi
  8006a4:	eb ed                	jmp    800693 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006a9:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b0:	e9 eb fd ff ff       	jmp    8004a0 <vprintfmt+0x43>
	if (lflag >= 2)
  8006b5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b9:	7f 21                	jg     8006dc <vprintfmt+0x27f>
	else if (lflag)
  8006bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006bf:	74 68                	je     800729 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006c9:	89 c1                	mov    %eax,%ecx
  8006cb:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ce:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006da:	eb 17                	jmp    8006f3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 50 04             	mov    0x4(%eax),%edx
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 08             	lea    0x8(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800703:	78 3f                	js     800744 <vprintfmt+0x2e7>
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80070a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80070e:	0f 84 71 01 00 00    	je     800885 <vprintfmt+0x428>
				putch('+', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 2b                	push   $0x2b
  80071a:	ff d6                	call   *%esi
  80071c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80071f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800724:	e9 5c 01 00 00       	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800731:	89 c1                	mov    %eax,%ecx
  800733:	c1 f9 1f             	sar    $0x1f,%ecx
  800736:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	eb af                	jmp    8006f3 <vprintfmt+0x296>
				putch('-', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	53                   	push   %ebx
  800748:	6a 2d                	push   $0x2d
  80074a:	ff d6                	call   *%esi
				num = -(long long) num;
  80074c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80074f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800752:	f7 d8                	neg    %eax
  800754:	83 d2 00             	adc    $0x0,%edx
  800757:	f7 da                	neg    %edx
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800762:	b8 0a 00 00 00       	mov    $0xa,%eax
  800767:	e9 19 01 00 00       	jmp    800885 <vprintfmt+0x428>
	if (lflag >= 2)
  80076c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800770:	7f 29                	jg     80079b <vprintfmt+0x33e>
	else if (lflag)
  800772:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800776:	74 44                	je     8007bc <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800785:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800791:	b8 0a 00 00 00       	mov    $0xa,%eax
  800796:	e9 ea 00 00 00       	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 08             	lea    0x8(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b7:	e9 c9 00 00 00       	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8d 40 04             	lea    0x4(%eax),%eax
  8007d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007da:	e9 a6 00 00 00       	jmp    800885 <vprintfmt+0x428>
			putch('0', putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	53                   	push   %ebx
  8007e3:	6a 30                	push   $0x30
  8007e5:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ee:	7f 26                	jg     800816 <vprintfmt+0x3b9>
	else if (lflag)
  8007f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f4:	74 3e                	je     800834 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800800:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800803:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8d 40 04             	lea    0x4(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080f:	b8 08 00 00 00       	mov    $0x8,%eax
  800814:	eb 6f                	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8b 50 04             	mov    0x4(%eax),%edx
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800821:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8d 40 08             	lea    0x8(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082d:	b8 08 00 00 00       	mov    $0x8,%eax
  800832:	eb 51                	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	ba 00 00 00 00       	mov    $0x0,%edx
  80083e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800841:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 40 04             	lea    0x4(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084d:	b8 08 00 00 00       	mov    $0x8,%eax
  800852:	eb 31                	jmp    800885 <vprintfmt+0x428>
			putch('0', putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	53                   	push   %ebx
  800858:	6a 30                	push   $0x30
  80085a:	ff d6                	call   *%esi
			putch('x', putdat);
  80085c:	83 c4 08             	add    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 78                	push   $0x78
  800862:	ff d6                	call   *%esi
			num = (unsigned long long)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800874:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 40 04             	lea    0x4(%eax),%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800880:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800885:	83 ec 0c             	sub    $0xc,%esp
  800888:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80088c:	52                   	push   %edx
  80088d:	ff 75 e0             	pushl  -0x20(%ebp)
  800890:	50                   	push   %eax
  800891:	ff 75 dc             	pushl  -0x24(%ebp)
  800894:	ff 75 d8             	pushl  -0x28(%ebp)
  800897:	89 da                	mov    %ebx,%edx
  800899:	89 f0                	mov    %esi,%eax
  80089b:	e8 a4 fa ff ff       	call   800344 <printnum>
			break;
  8008a0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a6:	83 c7 01             	add    $0x1,%edi
  8008a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ad:	83 f8 25             	cmp    $0x25,%eax
  8008b0:	0f 84 be fb ff ff    	je     800474 <vprintfmt+0x17>
			if (ch == '\0')
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	0f 84 28 01 00 00    	je     8009e6 <vprintfmt+0x589>
			putch(ch, putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	53                   	push   %ebx
  8008c2:	50                   	push   %eax
  8008c3:	ff d6                	call   *%esi
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	eb dc                	jmp    8008a6 <vprintfmt+0x449>
	if (lflag >= 2)
  8008ca:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008ce:	7f 26                	jg     8008f6 <vprintfmt+0x499>
	else if (lflag)
  8008d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d4:	74 41                	je     800917 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ef:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f4:	eb 8f                	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	8b 50 04             	mov    0x4(%eax),%edx
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800901:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8d 40 08             	lea    0x8(%eax),%eax
  80090a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090d:	b8 10 00 00 00       	mov    $0x10,%eax
  800912:	e9 6e ff ff ff       	jmp    800885 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	8b 00                	mov    (%eax),%eax
  80091c:	ba 00 00 00 00       	mov    $0x0,%edx
  800921:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800924:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	8d 40 04             	lea    0x4(%eax),%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800930:	b8 10 00 00 00       	mov    $0x10,%eax
  800935:	e9 4b ff ff ff       	jmp    800885 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	83 c0 04             	add    $0x4,%eax
  800940:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	85 c0                	test   %eax,%eax
  80094a:	74 14                	je     800960 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80094c:	8b 13                	mov    (%ebx),%edx
  80094e:	83 fa 7f             	cmp    $0x7f,%edx
  800951:	7f 37                	jg     80098a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800953:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	89 45 14             	mov    %eax,0x14(%ebp)
  80095b:	e9 43 ff ff ff       	jmp    8008a3 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800960:	b8 0a 00 00 00       	mov    $0xa,%eax
  800965:	bf 89 29 80 00       	mov    $0x802989,%edi
							putch(ch, putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	53                   	push   %ebx
  80096e:	50                   	push   %eax
  80096f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800971:	83 c7 01             	add    $0x1,%edi
  800974:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	85 c0                	test   %eax,%eax
  80097d:	75 eb                	jne    80096a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	e9 19 ff ff ff       	jmp    8008a3 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80098a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80098c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800991:	bf c1 29 80 00       	mov    $0x8029c1,%edi
							putch(ch, putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	53                   	push   %ebx
  80099a:	50                   	push   %eax
  80099b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80099d:	83 c7 01             	add    $0x1,%edi
  8009a0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	85 c0                	test   %eax,%eax
  8009a9:	75 eb                	jne    800996 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b1:	e9 ed fe ff ff       	jmp    8008a3 <vprintfmt+0x446>
			putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	53                   	push   %ebx
  8009ba:	6a 25                	push   $0x25
  8009bc:	ff d6                	call   *%esi
			break;
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	e9 dd fe ff ff       	jmp    8008a3 <vprintfmt+0x446>
			putch('%', putdat);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	53                   	push   %ebx
  8009ca:	6a 25                	push   $0x25
  8009cc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	89 f8                	mov    %edi,%eax
  8009d3:	eb 03                	jmp    8009d8 <vprintfmt+0x57b>
  8009d5:	83 e8 01             	sub    $0x1,%eax
  8009d8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009dc:	75 f7                	jne    8009d5 <vprintfmt+0x578>
  8009de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e1:	e9 bd fe ff ff       	jmp    8008a3 <vprintfmt+0x446>
}
  8009e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009e9:	5b                   	pop    %ebx
  8009ea:	5e                   	pop    %esi
  8009eb:	5f                   	pop    %edi
  8009ec:	5d                   	pop    %ebp
  8009ed:	c3                   	ret    

008009ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	83 ec 18             	sub    $0x18,%esp
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009fd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a01:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0b:	85 c0                	test   %eax,%eax
  800a0d:	74 26                	je     800a35 <vsnprintf+0x47>
  800a0f:	85 d2                	test   %edx,%edx
  800a11:	7e 22                	jle    800a35 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a13:	ff 75 14             	pushl  0x14(%ebp)
  800a16:	ff 75 10             	pushl  0x10(%ebp)
  800a19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1c:	50                   	push   %eax
  800a1d:	68 23 04 80 00       	push   $0x800423
  800a22:	e8 36 fa ff ff       	call   80045d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a30:	83 c4 10             	add    $0x10,%esp
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    
		return -E_INVAL;
  800a35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a3a:	eb f7                	jmp    800a33 <vsnprintf+0x45>

00800a3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a42:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a45:	50                   	push   %eax
  800a46:	ff 75 10             	pushl  0x10(%ebp)
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	ff 75 08             	pushl  0x8(%ebp)
  800a4f:	e8 9a ff ff ff       	call   8009ee <vsnprintf>
	va_end(ap);

	return rc;
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a61:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a65:	74 05                	je     800a6c <strlen+0x16>
		n++;
  800a67:	83 c0 01             	add    $0x1,%eax
  800a6a:	eb f5                	jmp    800a61 <strlen+0xb>
	return n;
}
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a77:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7c:	39 c2                	cmp    %eax,%edx
  800a7e:	74 0d                	je     800a8d <strnlen+0x1f>
  800a80:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a84:	74 05                	je     800a8b <strnlen+0x1d>
		n++;
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	eb f1                	jmp    800a7c <strnlen+0xe>
  800a8b:	89 d0                	mov    %edx,%eax
	return n;
}
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a99:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa2:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aa5:	83 c2 01             	add    $0x1,%edx
  800aa8:	84 c9                	test   %cl,%cl
  800aaa:	75 f2                	jne    800a9e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aac:	5b                   	pop    %ebx
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	53                   	push   %ebx
  800ab3:	83 ec 10             	sub    $0x10,%esp
  800ab6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ab9:	53                   	push   %ebx
  800aba:	e8 97 ff ff ff       	call   800a56 <strlen>
  800abf:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	01 d8                	add    %ebx,%eax
  800ac7:	50                   	push   %eax
  800ac8:	e8 c2 ff ff ff       	call   800a8f <strcpy>
	return dst;
}
  800acd:	89 d8                	mov    %ebx,%eax
  800acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    

00800ad4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800adf:	89 c6                	mov    %eax,%esi
  800ae1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae4:	89 c2                	mov    %eax,%edx
  800ae6:	39 f2                	cmp    %esi,%edx
  800ae8:	74 11                	je     800afb <strncpy+0x27>
		*dst++ = *src;
  800aea:	83 c2 01             	add    $0x1,%edx
  800aed:	0f b6 19             	movzbl (%ecx),%ebx
  800af0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af3:	80 fb 01             	cmp    $0x1,%bl
  800af6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800af9:	eb eb                	jmp    800ae6 <strncpy+0x12>
	}
	return ret;
}
  800afb:	5b                   	pop    %ebx
  800afc:	5e                   	pop    %esi
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
  800b04:	8b 75 08             	mov    0x8(%ebp),%esi
  800b07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0a:	8b 55 10             	mov    0x10(%ebp),%edx
  800b0d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b0f:	85 d2                	test   %edx,%edx
  800b11:	74 21                	je     800b34 <strlcpy+0x35>
  800b13:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b17:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b19:	39 c2                	cmp    %eax,%edx
  800b1b:	74 14                	je     800b31 <strlcpy+0x32>
  800b1d:	0f b6 19             	movzbl (%ecx),%ebx
  800b20:	84 db                	test   %bl,%bl
  800b22:	74 0b                	je     800b2f <strlcpy+0x30>
			*dst++ = *src++;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b2d:	eb ea                	jmp    800b19 <strlcpy+0x1a>
  800b2f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b34:	29 f0                	sub    %esi,%eax
}
  800b36:	5b                   	pop    %ebx
  800b37:	5e                   	pop    %esi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b43:	0f b6 01             	movzbl (%ecx),%eax
  800b46:	84 c0                	test   %al,%al
  800b48:	74 0c                	je     800b56 <strcmp+0x1c>
  800b4a:	3a 02                	cmp    (%edx),%al
  800b4c:	75 08                	jne    800b56 <strcmp+0x1c>
		p++, q++;
  800b4e:	83 c1 01             	add    $0x1,%ecx
  800b51:	83 c2 01             	add    $0x1,%edx
  800b54:	eb ed                	jmp    800b43 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b56:	0f b6 c0             	movzbl %al,%eax
  800b59:	0f b6 12             	movzbl (%edx),%edx
  800b5c:	29 d0                	sub    %edx,%eax
}
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	53                   	push   %ebx
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	89 c3                	mov    %eax,%ebx
  800b6c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b6f:	eb 06                	jmp    800b77 <strncmp+0x17>
		n--, p++, q++;
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b77:	39 d8                	cmp    %ebx,%eax
  800b79:	74 16                	je     800b91 <strncmp+0x31>
  800b7b:	0f b6 08             	movzbl (%eax),%ecx
  800b7e:	84 c9                	test   %cl,%cl
  800b80:	74 04                	je     800b86 <strncmp+0x26>
  800b82:	3a 0a                	cmp    (%edx),%cl
  800b84:	74 eb                	je     800b71 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b86:	0f b6 00             	movzbl (%eax),%eax
  800b89:	0f b6 12             	movzbl (%edx),%edx
  800b8c:	29 d0                	sub    %edx,%eax
}
  800b8e:	5b                   	pop    %ebx
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    
		return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	eb f6                	jmp    800b8e <strncmp+0x2e>

00800b98 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba2:	0f b6 10             	movzbl (%eax),%edx
  800ba5:	84 d2                	test   %dl,%dl
  800ba7:	74 09                	je     800bb2 <strchr+0x1a>
		if (*s == c)
  800ba9:	38 ca                	cmp    %cl,%dl
  800bab:	74 0a                	je     800bb7 <strchr+0x1f>
	for (; *s; s++)
  800bad:	83 c0 01             	add    $0x1,%eax
  800bb0:	eb f0                	jmp    800ba2 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc6:	38 ca                	cmp    %cl,%dl
  800bc8:	74 09                	je     800bd3 <strfind+0x1a>
  800bca:	84 d2                	test   %dl,%dl
  800bcc:	74 05                	je     800bd3 <strfind+0x1a>
	for (; *s; s++)
  800bce:	83 c0 01             	add    $0x1,%eax
  800bd1:	eb f0                	jmp    800bc3 <strfind+0xa>
			break;
	return (char *) s;
}
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
  800bdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be1:	85 c9                	test   %ecx,%ecx
  800be3:	74 31                	je     800c16 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be5:	89 f8                	mov    %edi,%eax
  800be7:	09 c8                	or     %ecx,%eax
  800be9:	a8 03                	test   $0x3,%al
  800beb:	75 23                	jne    800c10 <memset+0x3b>
		c &= 0xFF;
  800bed:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf1:	89 d3                	mov    %edx,%ebx
  800bf3:	c1 e3 08             	shl    $0x8,%ebx
  800bf6:	89 d0                	mov    %edx,%eax
  800bf8:	c1 e0 18             	shl    $0x18,%eax
  800bfb:	89 d6                	mov    %edx,%esi
  800bfd:	c1 e6 10             	shl    $0x10,%esi
  800c00:	09 f0                	or     %esi,%eax
  800c02:	09 c2                	or     %eax,%edx
  800c04:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c06:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	fc                   	cld    
  800c0c:	f3 ab                	rep stos %eax,%es:(%edi)
  800c0e:	eb 06                	jmp    800c16 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	fc                   	cld    
  800c14:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c16:	89 f8                	mov    %edi,%eax
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c2b:	39 c6                	cmp    %eax,%esi
  800c2d:	73 32                	jae    800c61 <memmove+0x44>
  800c2f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c32:	39 c2                	cmp    %eax,%edx
  800c34:	76 2b                	jbe    800c61 <memmove+0x44>
		s += n;
		d += n;
  800c36:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c39:	89 fe                	mov    %edi,%esi
  800c3b:	09 ce                	or     %ecx,%esi
  800c3d:	09 d6                	or     %edx,%esi
  800c3f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c45:	75 0e                	jne    800c55 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c47:	83 ef 04             	sub    $0x4,%edi
  800c4a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c4d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c50:	fd                   	std    
  800c51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c53:	eb 09                	jmp    800c5e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c55:	83 ef 01             	sub    $0x1,%edi
  800c58:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c5b:	fd                   	std    
  800c5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c5e:	fc                   	cld    
  800c5f:	eb 1a                	jmp    800c7b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	09 ca                	or     %ecx,%edx
  800c65:	09 f2                	or     %esi,%edx
  800c67:	f6 c2 03             	test   $0x3,%dl
  800c6a:	75 0a                	jne    800c76 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c6c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c6f:	89 c7                	mov    %eax,%edi
  800c71:	fc                   	cld    
  800c72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c74:	eb 05                	jmp    800c7b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	fc                   	cld    
  800c79:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c85:	ff 75 10             	pushl  0x10(%ebp)
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	ff 75 08             	pushl  0x8(%ebp)
  800c8e:	e8 8a ff ff ff       	call   800c1d <memmove>
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca0:	89 c6                	mov    %eax,%esi
  800ca2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca5:	39 f0                	cmp    %esi,%eax
  800ca7:	74 1c                	je     800cc5 <memcmp+0x30>
		if (*s1 != *s2)
  800ca9:	0f b6 08             	movzbl (%eax),%ecx
  800cac:	0f b6 1a             	movzbl (%edx),%ebx
  800caf:	38 d9                	cmp    %bl,%cl
  800cb1:	75 08                	jne    800cbb <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cb3:	83 c0 01             	add    $0x1,%eax
  800cb6:	83 c2 01             	add    $0x1,%edx
  800cb9:	eb ea                	jmp    800ca5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cbb:	0f b6 c1             	movzbl %cl,%eax
  800cbe:	0f b6 db             	movzbl %bl,%ebx
  800cc1:	29 d8                	sub    %ebx,%eax
  800cc3:	eb 05                	jmp    800cca <memcmp+0x35>
	}

	return 0;
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cd7:	89 c2                	mov    %eax,%edx
  800cd9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cdc:	39 d0                	cmp    %edx,%eax
  800cde:	73 09                	jae    800ce9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce0:	38 08                	cmp    %cl,(%eax)
  800ce2:	74 05                	je     800ce9 <memfind+0x1b>
	for (; s < ends; s++)
  800ce4:	83 c0 01             	add    $0x1,%eax
  800ce7:	eb f3                	jmp    800cdc <memfind+0xe>
			break;
	return (void *) s;
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf7:	eb 03                	jmp    800cfc <strtol+0x11>
		s++;
  800cf9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cfc:	0f b6 01             	movzbl (%ecx),%eax
  800cff:	3c 20                	cmp    $0x20,%al
  800d01:	74 f6                	je     800cf9 <strtol+0xe>
  800d03:	3c 09                	cmp    $0x9,%al
  800d05:	74 f2                	je     800cf9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d07:	3c 2b                	cmp    $0x2b,%al
  800d09:	74 2a                	je     800d35 <strtol+0x4a>
	int neg = 0;
  800d0b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d10:	3c 2d                	cmp    $0x2d,%al
  800d12:	74 2b                	je     800d3f <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d14:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d1a:	75 0f                	jne    800d2b <strtol+0x40>
  800d1c:	80 39 30             	cmpb   $0x30,(%ecx)
  800d1f:	74 28                	je     800d49 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d21:	85 db                	test   %ebx,%ebx
  800d23:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d28:	0f 44 d8             	cmove  %eax,%ebx
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d30:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d33:	eb 50                	jmp    800d85 <strtol+0x9a>
		s++;
  800d35:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d38:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3d:	eb d5                	jmp    800d14 <strtol+0x29>
		s++, neg = 1;
  800d3f:	83 c1 01             	add    $0x1,%ecx
  800d42:	bf 01 00 00 00       	mov    $0x1,%edi
  800d47:	eb cb                	jmp    800d14 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d49:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d4d:	74 0e                	je     800d5d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d4f:	85 db                	test   %ebx,%ebx
  800d51:	75 d8                	jne    800d2b <strtol+0x40>
		s++, base = 8;
  800d53:	83 c1 01             	add    $0x1,%ecx
  800d56:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d5b:	eb ce                	jmp    800d2b <strtol+0x40>
		s += 2, base = 16;
  800d5d:	83 c1 02             	add    $0x2,%ecx
  800d60:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d65:	eb c4                	jmp    800d2b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d67:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6a:	89 f3                	mov    %esi,%ebx
  800d6c:	80 fb 19             	cmp    $0x19,%bl
  800d6f:	77 29                	ja     800d9a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d71:	0f be d2             	movsbl %dl,%edx
  800d74:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d77:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d7a:	7d 30                	jge    800dac <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d7c:	83 c1 01             	add    $0x1,%ecx
  800d7f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d83:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d85:	0f b6 11             	movzbl (%ecx),%edx
  800d88:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d8b:	89 f3                	mov    %esi,%ebx
  800d8d:	80 fb 09             	cmp    $0x9,%bl
  800d90:	77 d5                	ja     800d67 <strtol+0x7c>
			dig = *s - '0';
  800d92:	0f be d2             	movsbl %dl,%edx
  800d95:	83 ea 30             	sub    $0x30,%edx
  800d98:	eb dd                	jmp    800d77 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d9a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d9d:	89 f3                	mov    %esi,%ebx
  800d9f:	80 fb 19             	cmp    $0x19,%bl
  800da2:	77 08                	ja     800dac <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da4:	0f be d2             	movsbl %dl,%edx
  800da7:	83 ea 37             	sub    $0x37,%edx
  800daa:	eb cb                	jmp    800d77 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db0:	74 05                	je     800db7 <strtol+0xcc>
		*endptr = (char *) s;
  800db2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800db7:	89 c2                	mov    %eax,%edx
  800db9:	f7 da                	neg    %edx
  800dbb:	85 ff                	test   %edi,%edi
  800dbd:	0f 45 c2             	cmovne %edx,%eax
}
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	89 c3                	mov    %eax,%ebx
  800dd8:	89 c7                	mov    %eax,%edi
  800dda:	89 c6                	mov    %eax,%esi
  800ddc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dee:	b8 01 00 00 00       	mov    $0x1,%eax
  800df3:	89 d1                	mov    %edx,%ecx
  800df5:	89 d3                	mov    %edx,%ebx
  800df7:	89 d7                	mov    %edx,%edi
  800df9:	89 d6                	mov    %edx,%esi
  800dfb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	b8 03 00 00 00       	mov    $0x3,%eax
  800e18:	89 cb                	mov    %ecx,%ebx
  800e1a:	89 cf                	mov    %ecx,%edi
  800e1c:	89 ce                	mov    %ecx,%esi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 03                	push   $0x3
  800e32:	68 e8 2b 80 00       	push   $0x802be8
  800e37:	6a 43                	push   $0x43
  800e39:	68 05 2c 80 00       	push   $0x802c05
  800e3e:	e8 f7 f3 ff ff       	call   80023a <_panic>

00800e43 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e49:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e53:	89 d1                	mov    %edx,%ecx
  800e55:	89 d3                	mov    %edx,%ebx
  800e57:	89 d7                	mov    %edx,%edi
  800e59:	89 d6                	mov    %edx,%esi
  800e5b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <sys_yield>:

void
sys_yield(void)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e68:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e72:	89 d1                	mov    %edx,%ecx
  800e74:	89 d3                	mov    %edx,%ebx
  800e76:	89 d7                	mov    %edx,%edi
  800e78:	89 d6                	mov    %edx,%esi
  800e7a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
  800e87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e95:	b8 04 00 00 00       	mov    $0x4,%eax
  800e9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9d:	89 f7                	mov    %esi,%edi
  800e9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7f 08                	jg     800ead <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ead:	83 ec 0c             	sub    $0xc,%esp
  800eb0:	50                   	push   %eax
  800eb1:	6a 04                	push   $0x4
  800eb3:	68 e8 2b 80 00       	push   $0x802be8
  800eb8:	6a 43                	push   $0x43
  800eba:	68 05 2c 80 00       	push   $0x802c05
  800ebf:	e8 76 f3 ff ff       	call   80023a <_panic>

00800ec4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
  800eca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ede:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	7f 08                	jg     800eef <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eef:	83 ec 0c             	sub    $0xc,%esp
  800ef2:	50                   	push   %eax
  800ef3:	6a 05                	push   $0x5
  800ef5:	68 e8 2b 80 00       	push   $0x802be8
  800efa:	6a 43                	push   $0x43
  800efc:	68 05 2c 80 00       	push   $0x802c05
  800f01:	e8 34 f3 ff ff       	call   80023a <_panic>

00800f06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 06                	push   $0x6
  800f37:	68 e8 2b 80 00       	push   $0x802be8
  800f3c:	6a 43                	push   $0x43
  800f3e:	68 05 2c 80 00       	push   $0x802c05
  800f43:	e8 f2 f2 ff ff       	call   80023a <_panic>

00800f48 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f61:	89 df                	mov    %ebx,%edi
  800f63:	89 de                	mov    %ebx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	6a 08                	push   $0x8
  800f79:	68 e8 2b 80 00       	push   $0x802be8
  800f7e:	6a 43                	push   $0x43
  800f80:	68 05 2c 80 00       	push   $0x802c05
  800f85:	e8 b0 f2 ff ff       	call   80023a <_panic>

00800f8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f98:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa3:	89 df                	mov    %ebx,%edi
  800fa5:	89 de                	mov    %ebx,%esi
  800fa7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7f 08                	jg     800fb5 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb5:	83 ec 0c             	sub    $0xc,%esp
  800fb8:	50                   	push   %eax
  800fb9:	6a 09                	push   $0x9
  800fbb:	68 e8 2b 80 00       	push   $0x802be8
  800fc0:	6a 43                	push   $0x43
  800fc2:	68 05 2c 80 00       	push   $0x802c05
  800fc7:	e8 6e f2 ff ff       	call   80023a <_panic>

00800fcc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe5:	89 df                	mov    %ebx,%edi
  800fe7:	89 de                	mov    %ebx,%esi
  800fe9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800feb:	85 c0                	test   %eax,%eax
  800fed:	7f 08                	jg     800ff7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5f                   	pop    %edi
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	50                   	push   %eax
  800ffb:	6a 0a                	push   $0xa
  800ffd:	68 e8 2b 80 00       	push   $0x802be8
  801002:	6a 43                	push   $0x43
  801004:	68 05 2c 80 00       	push   $0x802c05
  801009:	e8 2c f2 ff ff       	call   80023a <_panic>

0080100e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
	asm volatile("int %1\n"
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80101f:	be 00 00 00 00       	mov    $0x0,%esi
  801024:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801027:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    

00801031 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
  801037:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	b8 0d 00 00 00       	mov    $0xd,%eax
  801047:	89 cb                	mov    %ecx,%ebx
  801049:	89 cf                	mov    %ecx,%edi
  80104b:	89 ce                	mov    %ecx,%esi
  80104d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80104f:	85 c0                	test   %eax,%eax
  801051:	7f 08                	jg     80105b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801053:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	50                   	push   %eax
  80105f:	6a 0d                	push   $0xd
  801061:	68 e8 2b 80 00       	push   $0x802be8
  801066:	6a 43                	push   $0x43
  801068:	68 05 2c 80 00       	push   $0x802c05
  80106d:	e8 c8 f1 ff ff       	call   80023a <_panic>

00801072 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
	asm volatile("int %1\n"
  801078:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801083:	b8 0e 00 00 00       	mov    $0xe,%eax
  801088:	89 df                	mov    %ebx,%edi
  80108a:	89 de                	mov    %ebx,%esi
  80108c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80108e:	5b                   	pop    %ebx
  80108f:	5e                   	pop    %esi
  801090:	5f                   	pop    %edi
  801091:	5d                   	pop    %ebp
  801092:	c3                   	ret    

00801093 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801093:	55                   	push   %ebp
  801094:	89 e5                	mov    %esp,%ebp
  801096:	57                   	push   %edi
  801097:	56                   	push   %esi
  801098:	53                   	push   %ebx
	asm volatile("int %1\n"
  801099:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109e:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010a6:	89 cb                	mov    %ecx,%ebx
  8010a8:	89 cf                	mov    %ecx,%edi
  8010aa:	89 ce                	mov    %ecx,%esi
  8010ac:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8010be:	b8 10 00 00 00       	mov    $0x10,%eax
  8010c3:	89 d1                	mov    %edx,%ecx
  8010c5:	89 d3                	mov    %edx,%ebx
  8010c7:	89 d7                	mov    %edx,%edi
  8010c9:	89 d6                	mov    %edx,%esi
  8010cb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010cd:	5b                   	pop    %ebx
  8010ce:	5e                   	pop    %esi
  8010cf:	5f                   	pop    %edi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e3:	b8 11 00 00 00       	mov    $0x11,%eax
  8010e8:	89 df                	mov    %ebx,%edi
  8010ea:	89 de                	mov    %ebx,%esi
  8010ec:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801104:	b8 12 00 00 00       	mov    $0x12,%eax
  801109:	89 df                	mov    %ebx,%edi
  80110b:	89 de                	mov    %ebx,%esi
  80110d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801122:	8b 55 08             	mov    0x8(%ebp),%edx
  801125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801128:	b8 13 00 00 00       	mov    $0x13,%eax
  80112d:	89 df                	mov    %ebx,%edi
  80112f:	89 de                	mov    %ebx,%esi
  801131:	cd 30                	int    $0x30
	if(check && ret > 0)
  801133:	85 c0                	test   %eax,%eax
  801135:	7f 08                	jg     80113f <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	50                   	push   %eax
  801143:	6a 13                	push   $0x13
  801145:	68 e8 2b 80 00       	push   $0x802be8
  80114a:	6a 43                	push   $0x43
  80114c:	68 05 2c 80 00       	push   $0x802c05
  801151:	e8 e4 f0 ff ff       	call   80023a <_panic>

00801156 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	05 00 00 00 30       	add    $0x30000000,%eax
  801161:	c1 e8 0c             	shr    $0xc,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801171:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801176:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801185:	89 c2                	mov    %eax,%edx
  801187:	c1 ea 16             	shr    $0x16,%edx
  80118a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801191:	f6 c2 01             	test   $0x1,%dl
  801194:	74 2d                	je     8011c3 <fd_alloc+0x46>
  801196:	89 c2                	mov    %eax,%edx
  801198:	c1 ea 0c             	shr    $0xc,%edx
  80119b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a2:	f6 c2 01             	test   $0x1,%dl
  8011a5:	74 1c                	je     8011c3 <fd_alloc+0x46>
  8011a7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011ac:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b1:	75 d2                	jne    801185 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011bc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c1:	eb 0a                	jmp    8011cd <fd_alloc+0x50>
			*fd_store = fd;
  8011c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d5:	83 f8 1f             	cmp    $0x1f,%eax
  8011d8:	77 30                	ja     80120a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011da:	c1 e0 0c             	shl    $0xc,%eax
  8011dd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011e8:	f6 c2 01             	test   $0x1,%dl
  8011eb:	74 24                	je     801211 <fd_lookup+0x42>
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	c1 ea 0c             	shr    $0xc,%edx
  8011f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f9:	f6 c2 01             	test   $0x1,%dl
  8011fc:	74 1a                	je     801218 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801201:	89 02                	mov    %eax,(%edx)
	return 0;
  801203:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    
		return -E_INVAL;
  80120a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120f:	eb f7                	jmp    801208 <fd_lookup+0x39>
		return -E_INVAL;
  801211:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801216:	eb f0                	jmp    801208 <fd_lookup+0x39>
  801218:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121d:	eb e9                	jmp    801208 <fd_lookup+0x39>

0080121f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801228:	ba 00 00 00 00       	mov    $0x0,%edx
  80122d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801232:	39 08                	cmp    %ecx,(%eax)
  801234:	74 38                	je     80126e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801236:	83 c2 01             	add    $0x1,%edx
  801239:	8b 04 95 94 2c 80 00 	mov    0x802c94(,%edx,4),%eax
  801240:	85 c0                	test   %eax,%eax
  801242:	75 ee                	jne    801232 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801244:	a1 20 60 80 00       	mov    0x806020,%eax
  801249:	8b 40 48             	mov    0x48(%eax),%eax
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	51                   	push   %ecx
  801250:	50                   	push   %eax
  801251:	68 14 2c 80 00       	push   $0x802c14
  801256:	e8 d5 f0 ff ff       	call   800330 <cprintf>
	*dev = 0;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    
			*dev = devtab[i];
  80126e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801271:	89 01                	mov    %eax,(%ecx)
			return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
  801278:	eb f2                	jmp    80126c <dev_lookup+0x4d>

0080127a <fd_close>:
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	57                   	push   %edi
  80127e:	56                   	push   %esi
  80127f:	53                   	push   %ebx
  801280:	83 ec 24             	sub    $0x24,%esp
  801283:	8b 75 08             	mov    0x8(%ebp),%esi
  801286:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801289:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801296:	50                   	push   %eax
  801297:	e8 33 ff ff ff       	call   8011cf <fd_lookup>
  80129c:	89 c3                	mov    %eax,%ebx
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 05                	js     8012aa <fd_close+0x30>
	    || fd != fd2)
  8012a5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012a8:	74 16                	je     8012c0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012aa:	89 f8                	mov    %edi,%eax
  8012ac:	84 c0                	test   %al,%al
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	0f 44 d8             	cmove  %eax,%ebx
}
  8012b6:	89 d8                	mov    %ebx,%eax
  8012b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c6:	50                   	push   %eax
  8012c7:	ff 36                	pushl  (%esi)
  8012c9:	e8 51 ff ff ff       	call   80121f <dev_lookup>
  8012ce:	89 c3                	mov    %eax,%ebx
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 1a                	js     8012f1 <fd_close+0x77>
		if (dev->dev_close)
  8012d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012da:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	74 0b                	je     8012f1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012e6:	83 ec 0c             	sub    $0xc,%esp
  8012e9:	56                   	push   %esi
  8012ea:	ff d0                	call   *%eax
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	56                   	push   %esi
  8012f5:	6a 00                	push   $0x0
  8012f7:	e8 0a fc ff ff       	call   800f06 <sys_page_unmap>
	return r;
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	eb b5                	jmp    8012b6 <fd_close+0x3c>

00801301 <close>:

int
close(int fdnum)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801307:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130a:	50                   	push   %eax
  80130b:	ff 75 08             	pushl  0x8(%ebp)
  80130e:	e8 bc fe ff ff       	call   8011cf <fd_lookup>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	79 02                	jns    80131c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    
		return fd_close(fd, 1);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	6a 01                	push   $0x1
  801321:	ff 75 f4             	pushl  -0xc(%ebp)
  801324:	e8 51 ff ff ff       	call   80127a <fd_close>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	eb ec                	jmp    80131a <close+0x19>

0080132e <close_all>:

void
close_all(void)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	53                   	push   %ebx
  801332:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801335:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	53                   	push   %ebx
  80133e:	e8 be ff ff ff       	call   801301 <close>
	for (i = 0; i < MAXFD; i++)
  801343:	83 c3 01             	add    $0x1,%ebx
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	83 fb 20             	cmp    $0x20,%ebx
  80134c:	75 ec                	jne    80133a <close_all+0xc>
}
  80134e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	57                   	push   %edi
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
  801359:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80135c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80135f:	50                   	push   %eax
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 67 fe ff ff       	call   8011cf <fd_lookup>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	0f 88 81 00 00 00    	js     8013f6 <dup+0xa3>
		return r;
	close(newfdnum);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 0c             	pushl  0xc(%ebp)
  80137b:	e8 81 ff ff ff       	call   801301 <close>

	newfd = INDEX2FD(newfdnum);
  801380:	8b 75 0c             	mov    0xc(%ebp),%esi
  801383:	c1 e6 0c             	shl    $0xc,%esi
  801386:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80138c:	83 c4 04             	add    $0x4,%esp
  80138f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801392:	e8 cf fd ff ff       	call   801166 <fd2data>
  801397:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801399:	89 34 24             	mov    %esi,(%esp)
  80139c:	e8 c5 fd ff ff       	call   801166 <fd2data>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a6:	89 d8                	mov    %ebx,%eax
  8013a8:	c1 e8 16             	shr    $0x16,%eax
  8013ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b2:	a8 01                	test   $0x1,%al
  8013b4:	74 11                	je     8013c7 <dup+0x74>
  8013b6:	89 d8                	mov    %ebx,%eax
  8013b8:	c1 e8 0c             	shr    $0xc,%eax
  8013bb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c2:	f6 c2 01             	test   $0x1,%dl
  8013c5:	75 39                	jne    801400 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	c1 e8 0c             	shr    $0xc,%eax
  8013cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013de:	50                   	push   %eax
  8013df:	56                   	push   %esi
  8013e0:	6a 00                	push   $0x0
  8013e2:	52                   	push   %edx
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 da fa ff ff       	call   800ec4 <sys_page_map>
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 20             	add    $0x20,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 31                	js     801424 <dup+0xd1>
		goto err;

	return newfdnum;
  8013f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013f6:	89 d8                	mov    %ebx,%eax
  8013f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5e                   	pop    %esi
  8013fd:	5f                   	pop    %edi
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801400:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801407:	83 ec 0c             	sub    $0xc,%esp
  80140a:	25 07 0e 00 00       	and    $0xe07,%eax
  80140f:	50                   	push   %eax
  801410:	57                   	push   %edi
  801411:	6a 00                	push   $0x0
  801413:	53                   	push   %ebx
  801414:	6a 00                	push   $0x0
  801416:	e8 a9 fa ff ff       	call   800ec4 <sys_page_map>
  80141b:	89 c3                	mov    %eax,%ebx
  80141d:	83 c4 20             	add    $0x20,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	79 a3                	jns    8013c7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801424:	83 ec 08             	sub    $0x8,%esp
  801427:	56                   	push   %esi
  801428:	6a 00                	push   $0x0
  80142a:	e8 d7 fa ff ff       	call   800f06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80142f:	83 c4 08             	add    $0x8,%esp
  801432:	57                   	push   %edi
  801433:	6a 00                	push   $0x0
  801435:	e8 cc fa ff ff       	call   800f06 <sys_page_unmap>
	return r;
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	eb b7                	jmp    8013f6 <dup+0xa3>

0080143f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	53                   	push   %ebx
  801443:	83 ec 1c             	sub    $0x1c,%esp
  801446:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801449:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	53                   	push   %ebx
  80144e:	e8 7c fd ff ff       	call   8011cf <fd_lookup>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 3f                	js     801499 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801464:	ff 30                	pushl  (%eax)
  801466:	e8 b4 fd ff ff       	call   80121f <dev_lookup>
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 27                	js     801499 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801475:	8b 42 08             	mov    0x8(%edx),%eax
  801478:	83 e0 03             	and    $0x3,%eax
  80147b:	83 f8 01             	cmp    $0x1,%eax
  80147e:	74 1e                	je     80149e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	8b 40 08             	mov    0x8(%eax),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	74 35                	je     8014bf <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148a:	83 ec 04             	sub    $0x4,%esp
  80148d:	ff 75 10             	pushl  0x10(%ebp)
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	52                   	push   %edx
  801494:	ff d0                	call   *%eax
  801496:	83 c4 10             	add    $0x10,%esp
}
  801499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80149e:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a3:	8b 40 48             	mov    0x48(%eax),%eax
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	53                   	push   %ebx
  8014aa:	50                   	push   %eax
  8014ab:	68 58 2c 80 00       	push   $0x802c58
  8014b0:	e8 7b ee ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bd:	eb da                	jmp    801499 <read+0x5a>
		return -E_NOT_SUPP;
  8014bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c4:	eb d3                	jmp    801499 <read+0x5a>

008014c6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	57                   	push   %edi
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014da:	39 f3                	cmp    %esi,%ebx
  8014dc:	73 23                	jae    801501 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	89 f0                	mov    %esi,%eax
  8014e3:	29 d8                	sub    %ebx,%eax
  8014e5:	50                   	push   %eax
  8014e6:	89 d8                	mov    %ebx,%eax
  8014e8:	03 45 0c             	add    0xc(%ebp),%eax
  8014eb:	50                   	push   %eax
  8014ec:	57                   	push   %edi
  8014ed:	e8 4d ff ff ff       	call   80143f <read>
		if (m < 0)
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 06                	js     8014ff <readn+0x39>
			return m;
		if (m == 0)
  8014f9:	74 06                	je     801501 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014fb:	01 c3                	add    %eax,%ebx
  8014fd:	eb db                	jmp    8014da <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ff:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801501:	89 d8                	mov    %ebx,%eax
  801503:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5f                   	pop    %edi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    

0080150b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	53                   	push   %ebx
  80150f:	83 ec 1c             	sub    $0x1c,%esp
  801512:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801515:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801518:	50                   	push   %eax
  801519:	53                   	push   %ebx
  80151a:	e8 b0 fc ff ff       	call   8011cf <fd_lookup>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 3a                	js     801560 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801526:	83 ec 08             	sub    $0x8,%esp
  801529:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	ff 30                	pushl  (%eax)
  801532:	e8 e8 fc ff ff       	call   80121f <dev_lookup>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 22                	js     801560 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801545:	74 1e                	je     801565 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154a:	8b 52 0c             	mov    0xc(%edx),%edx
  80154d:	85 d2                	test   %edx,%edx
  80154f:	74 35                	je     801586 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	ff 75 10             	pushl  0x10(%ebp)
  801557:	ff 75 0c             	pushl  0xc(%ebp)
  80155a:	50                   	push   %eax
  80155b:	ff d2                	call   *%edx
  80155d:	83 c4 10             	add    $0x10,%esp
}
  801560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801563:	c9                   	leave  
  801564:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801565:	a1 20 60 80 00       	mov    0x806020,%eax
  80156a:	8b 40 48             	mov    0x48(%eax),%eax
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	53                   	push   %ebx
  801571:	50                   	push   %eax
  801572:	68 74 2c 80 00       	push   $0x802c74
  801577:	e8 b4 ed ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801584:	eb da                	jmp    801560 <write+0x55>
		return -E_NOT_SUPP;
  801586:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158b:	eb d3                	jmp    801560 <write+0x55>

0080158d <seek>:

int
seek(int fdnum, off_t offset)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801593:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801596:	50                   	push   %eax
  801597:	ff 75 08             	pushl  0x8(%ebp)
  80159a:	e8 30 fc ff ff       	call   8011cf <fd_lookup>
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 0e                	js     8015b4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ac:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	53                   	push   %ebx
  8015ba:	83 ec 1c             	sub    $0x1c,%esp
  8015bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c3:	50                   	push   %eax
  8015c4:	53                   	push   %ebx
  8015c5:	e8 05 fc ff ff       	call   8011cf <fd_lookup>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 37                	js     801608 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d1:	83 ec 08             	sub    $0x8,%esp
  8015d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d7:	50                   	push   %eax
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	ff 30                	pushl  (%eax)
  8015dd:	e8 3d fc ff ff       	call   80121f <dev_lookup>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 1f                	js     801608 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f0:	74 1b                	je     80160d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f5:	8b 52 18             	mov    0x18(%edx),%edx
  8015f8:	85 d2                	test   %edx,%edx
  8015fa:	74 32                	je     80162e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	50                   	push   %eax
  801603:	ff d2                	call   *%edx
  801605:	83 c4 10             	add    $0x10,%esp
}
  801608:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80160d:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801612:	8b 40 48             	mov    0x48(%eax),%eax
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	53                   	push   %ebx
  801619:	50                   	push   %eax
  80161a:	68 34 2c 80 00       	push   $0x802c34
  80161f:	e8 0c ed ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162c:	eb da                	jmp    801608 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80162e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801633:	eb d3                	jmp    801608 <ftruncate+0x52>

00801635 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	53                   	push   %ebx
  801639:	83 ec 1c             	sub    $0x1c,%esp
  80163c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	ff 75 08             	pushl  0x8(%ebp)
  801646:	e8 84 fb ff ff       	call   8011cf <fd_lookup>
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 4b                	js     80169d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801658:	50                   	push   %eax
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165c:	ff 30                	pushl  (%eax)
  80165e:	e8 bc fb ff ff       	call   80121f <dev_lookup>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 33                	js     80169d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801671:	74 2f                	je     8016a2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801673:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801676:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80167d:	00 00 00 
	stat->st_isdir = 0;
  801680:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801687:	00 00 00 
	stat->st_dev = dev;
  80168a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801690:	83 ec 08             	sub    $0x8,%esp
  801693:	53                   	push   %ebx
  801694:	ff 75 f0             	pushl  -0x10(%ebp)
  801697:	ff 50 14             	call   *0x14(%eax)
  80169a:	83 c4 10             	add    $0x10,%esp
}
  80169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a7:	eb f4                	jmp    80169d <fstat+0x68>

008016a9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	6a 00                	push   $0x0
  8016b3:	ff 75 08             	pushl  0x8(%ebp)
  8016b6:	e8 22 02 00 00       	call   8018dd <open>
  8016bb:	89 c3                	mov    %eax,%ebx
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 1b                	js     8016df <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ca:	50                   	push   %eax
  8016cb:	e8 65 ff ff ff       	call   801635 <fstat>
  8016d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d2:	89 1c 24             	mov    %ebx,(%esp)
  8016d5:	e8 27 fc ff ff       	call   801301 <close>
	return r;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 f3                	mov    %esi,%ebx
}
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e4:	5b                   	pop    %ebx
  8016e5:	5e                   	pop    %esi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    

008016e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	89 c6                	mov    %eax,%esi
  8016ef:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f8:	74 27                	je     801721 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016fa:	6a 07                	push   $0x7
  8016fc:	68 00 70 80 00       	push   $0x807000
  801701:	56                   	push   %esi
  801702:	ff 35 00 40 80 00    	pushl  0x804000
  801708:	e8 1c 0d 00 00       	call   802429 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80170d:	83 c4 0c             	add    $0xc,%esp
  801710:	6a 00                	push   $0x0
  801712:	53                   	push   %ebx
  801713:	6a 00                	push   $0x0
  801715:	e8 a6 0c 00 00       	call   8023c0 <ipc_recv>
}
  80171a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5e                   	pop    %esi
  80171f:	5d                   	pop    %ebp
  801720:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	6a 01                	push   $0x1
  801726:	e8 56 0d 00 00       	call   802481 <ipc_find_env>
  80172b:	a3 00 40 80 00       	mov    %eax,0x804000
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	eb c5                	jmp    8016fa <fsipc+0x12>

00801735 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8b 40 0c             	mov    0xc(%eax),%eax
  801741:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	b8 02 00 00 00       	mov    $0x2,%eax
  801758:	e8 8b ff ff ff       	call   8016e8 <fsipc>
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <devfile_flush>:
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	8b 40 0c             	mov    0xc(%eax),%eax
  80176b:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801770:	ba 00 00 00 00       	mov    $0x0,%edx
  801775:	b8 06 00 00 00       	mov    $0x6,%eax
  80177a:	e8 69 ff ff ff       	call   8016e8 <fsipc>
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <devfile_stat>:
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	53                   	push   %ebx
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8b 40 0c             	mov    0xc(%eax),%eax
  801791:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a0:	e8 43 ff ff ff       	call   8016e8 <fsipc>
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 2c                	js     8017d5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	68 00 70 80 00       	push   $0x807000
  8017b1:	53                   	push   %ebx
  8017b2:	e8 d8 f2 ff ff       	call   800a8f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b7:	a1 80 70 80 00       	mov    0x807080,%eax
  8017bc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c2:	a1 84 70 80 00       	mov    0x807084,%eax
  8017c7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <devfile_write>:
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ea:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  8017ef:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017f5:	53                   	push   %ebx
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	68 08 70 80 00       	push   $0x807008
  8017fe:	e8 7c f4 ff ff       	call   800c7f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	b8 04 00 00 00       	mov    $0x4,%eax
  80180d:	e8 d6 fe ff ff       	call   8016e8 <fsipc>
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 0b                	js     801824 <devfile_write+0x4a>
	assert(r <= n);
  801819:	39 d8                	cmp    %ebx,%eax
  80181b:	77 0c                	ja     801829 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80181d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801822:	7f 1e                	jg     801842 <devfile_write+0x68>
}
  801824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801827:	c9                   	leave  
  801828:	c3                   	ret    
	assert(r <= n);
  801829:	68 a8 2c 80 00       	push   $0x802ca8
  80182e:	68 af 2c 80 00       	push   $0x802caf
  801833:	68 98 00 00 00       	push   $0x98
  801838:	68 c4 2c 80 00       	push   $0x802cc4
  80183d:	e8 f8 e9 ff ff       	call   80023a <_panic>
	assert(r <= PGSIZE);
  801842:	68 cf 2c 80 00       	push   $0x802ccf
  801847:	68 af 2c 80 00       	push   $0x802caf
  80184c:	68 99 00 00 00       	push   $0x99
  801851:	68 c4 2c 80 00       	push   $0x802cc4
  801856:	e8 df e9 ff ff       	call   80023a <_panic>

0080185b <devfile_read>:
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	56                   	push   %esi
  80185f:	53                   	push   %ebx
  801860:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	8b 40 0c             	mov    0xc(%eax),%eax
  801869:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80186e:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801874:	ba 00 00 00 00       	mov    $0x0,%edx
  801879:	b8 03 00 00 00       	mov    $0x3,%eax
  80187e:	e8 65 fe ff ff       	call   8016e8 <fsipc>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	85 c0                	test   %eax,%eax
  801887:	78 1f                	js     8018a8 <devfile_read+0x4d>
	assert(r <= n);
  801889:	39 f0                	cmp    %esi,%eax
  80188b:	77 24                	ja     8018b1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80188d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801892:	7f 33                	jg     8018c7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	50                   	push   %eax
  801898:	68 00 70 80 00       	push   $0x807000
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	e8 78 f3 ff ff       	call   800c1d <memmove>
	return r;
  8018a5:	83 c4 10             	add    $0x10,%esp
}
  8018a8:	89 d8                	mov    %ebx,%eax
  8018aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5d                   	pop    %ebp
  8018b0:	c3                   	ret    
	assert(r <= n);
  8018b1:	68 a8 2c 80 00       	push   $0x802ca8
  8018b6:	68 af 2c 80 00       	push   $0x802caf
  8018bb:	6a 7c                	push   $0x7c
  8018bd:	68 c4 2c 80 00       	push   $0x802cc4
  8018c2:	e8 73 e9 ff ff       	call   80023a <_panic>
	assert(r <= PGSIZE);
  8018c7:	68 cf 2c 80 00       	push   $0x802ccf
  8018cc:	68 af 2c 80 00       	push   $0x802caf
  8018d1:	6a 7d                	push   $0x7d
  8018d3:	68 c4 2c 80 00       	push   $0x802cc4
  8018d8:	e8 5d e9 ff ff       	call   80023a <_panic>

008018dd <open>:
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 1c             	sub    $0x1c,%esp
  8018e5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018e8:	56                   	push   %esi
  8018e9:	e8 68 f1 ff ff       	call   800a56 <strlen>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018f6:	7f 6c                	jg     801964 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fe:	50                   	push   %eax
  8018ff:	e8 79 f8 ff ff       	call   80117d <fd_alloc>
  801904:	89 c3                	mov    %eax,%ebx
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 3c                	js     801949 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	56                   	push   %esi
  801911:	68 00 70 80 00       	push   $0x807000
  801916:	e8 74 f1 ff ff       	call   800a8f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80191b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191e:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801926:	b8 01 00 00 00       	mov    $0x1,%eax
  80192b:	e8 b8 fd ff ff       	call   8016e8 <fsipc>
  801930:	89 c3                	mov    %eax,%ebx
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	85 c0                	test   %eax,%eax
  801937:	78 19                	js     801952 <open+0x75>
	return fd2num(fd);
  801939:	83 ec 0c             	sub    $0xc,%esp
  80193c:	ff 75 f4             	pushl  -0xc(%ebp)
  80193f:	e8 12 f8 ff ff       	call   801156 <fd2num>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
}
  801949:	89 d8                	mov    %ebx,%eax
  80194b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194e:	5b                   	pop    %ebx
  80194f:	5e                   	pop    %esi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    
		fd_close(fd, 0);
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	6a 00                	push   $0x0
  801957:	ff 75 f4             	pushl  -0xc(%ebp)
  80195a:	e8 1b f9 ff ff       	call   80127a <fd_close>
		return r;
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	eb e5                	jmp    801949 <open+0x6c>
		return -E_BAD_PATH;
  801964:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801969:	eb de                	jmp    801949 <open+0x6c>

0080196b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801971:	ba 00 00 00 00       	mov    $0x0,%edx
  801976:	b8 08 00 00 00       	mov    $0x8,%eax
  80197b:	e8 68 fd ff ff       	call   8016e8 <fsipc>
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801982:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801986:	7f 01                	jg     801989 <writebuf+0x7>
  801988:	c3                   	ret    
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	53                   	push   %ebx
  80198d:	83 ec 08             	sub    $0x8,%esp
  801990:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801992:	ff 70 04             	pushl  0x4(%eax)
  801995:	8d 40 10             	lea    0x10(%eax),%eax
  801998:	50                   	push   %eax
  801999:	ff 33                	pushl  (%ebx)
  80199b:	e8 6b fb ff ff       	call   80150b <write>
		if (result > 0)
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	7e 03                	jle    8019aa <writebuf+0x28>
			b->result += result;
  8019a7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019aa:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019ad:	74 0d                	je     8019bc <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b6:	0f 4f c2             	cmovg  %edx,%eax
  8019b9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <putch>:

static void
putch(int ch, void *thunk)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019cb:	8b 53 04             	mov    0x4(%ebx),%edx
  8019ce:	8d 42 01             	lea    0x1(%edx),%eax
  8019d1:	89 43 04             	mov    %eax,0x4(%ebx)
  8019d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019d7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019db:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019e0:	74 06                	je     8019e8 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019e2:	83 c4 04             	add    $0x4,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    
		writebuf(b);
  8019e8:	89 d8                	mov    %ebx,%eax
  8019ea:	e8 93 ff ff ff       	call   801982 <writebuf>
		b->idx = 0;
  8019ef:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019f6:	eb ea                	jmp    8019e2 <putch+0x21>

008019f8 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a0a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a11:	00 00 00 
	b.result = 0;
  801a14:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a1b:	00 00 00 
	b.error = 1;
  801a1e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a25:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a28:	ff 75 10             	pushl  0x10(%ebp)
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a34:	50                   	push   %eax
  801a35:	68 c1 19 80 00       	push   $0x8019c1
  801a3a:	e8 1e ea ff ff       	call   80045d <vprintfmt>
	if (b.idx > 0)
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a49:	7f 11                	jg     801a5c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a4b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    
		writebuf(&b);
  801a5c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a62:	e8 1b ff ff ff       	call   801982 <writebuf>
  801a67:	eb e2                	jmp    801a4b <vfprintf+0x53>

00801a69 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a6f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a72:	50                   	push   %eax
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	e8 7a ff ff ff       	call   8019f8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <printf>:

int
printf(const char *fmt, ...)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a86:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a89:	50                   	push   %eax
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	6a 01                	push   $0x1
  801a8f:	e8 64 ff ff ff       	call   8019f8 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a9c:	68 db 2c 80 00       	push   $0x802cdb
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	e8 e6 ef ff ff       	call   800a8f <strcpy>
	return 0;
}
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <devsock_close>:
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 10             	sub    $0x10,%esp
  801ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801aba:	53                   	push   %ebx
  801abb:	e8 fc 09 00 00       	call   8024bc <pageref>
  801ac0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ac3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ac8:	83 f8 01             	cmp    $0x1,%eax
  801acb:	74 07                	je     801ad4 <devsock_close+0x24>
}
  801acd:	89 d0                	mov    %edx,%eax
  801acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ad4:	83 ec 0c             	sub    $0xc,%esp
  801ad7:	ff 73 0c             	pushl  0xc(%ebx)
  801ada:	e8 b9 02 00 00       	call   801d98 <nsipc_close>
  801adf:	89 c2                	mov    %eax,%edx
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	eb e7                	jmp    801acd <devsock_close+0x1d>

00801ae6 <devsock_write>:
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	ff 70 0c             	pushl  0xc(%eax)
  801afa:	e8 76 03 00 00       	call   801e75 <nsipc_send>
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <devsock_read>:
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	ff 75 10             	pushl  0x10(%ebp)
  801b0c:	ff 75 0c             	pushl  0xc(%ebp)
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	ff 70 0c             	pushl  0xc(%eax)
  801b15:	e8 ef 02 00 00       	call   801e09 <nsipc_recv>
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <fd2sockid>:
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b22:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	e8 a3 f6 ff ff       	call   8011cf <fd_lookup>
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	78 10                	js     801b43 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b36:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b3c:	39 08                	cmp    %ecx,(%eax)
  801b3e:	75 05                	jne    801b45 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b40:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    
		return -E_NOT_SUPP;
  801b45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4a:	eb f7                	jmp    801b43 <fd2sockid+0x27>

00801b4c <alloc_sockfd>:
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	56                   	push   %esi
  801b50:	53                   	push   %ebx
  801b51:	83 ec 1c             	sub    $0x1c,%esp
  801b54:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b59:	50                   	push   %eax
  801b5a:	e8 1e f6 ff ff       	call   80117d <fd_alloc>
  801b5f:	89 c3                	mov    %eax,%ebx
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 43                	js     801bab <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	68 07 04 00 00       	push   $0x407
  801b70:	ff 75 f4             	pushl  -0xc(%ebp)
  801b73:	6a 00                	push   $0x0
  801b75:	e8 07 f3 ff ff       	call   800e81 <sys_page_alloc>
  801b7a:	89 c3                	mov    %eax,%ebx
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 28                	js     801bab <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b98:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	50                   	push   %eax
  801b9f:	e8 b2 f5 ff ff       	call   801156 <fd2num>
  801ba4:	89 c3                	mov    %eax,%ebx
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	eb 0c                	jmp    801bb7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bab:	83 ec 0c             	sub    $0xc,%esp
  801bae:	56                   	push   %esi
  801baf:	e8 e4 01 00 00       	call   801d98 <nsipc_close>
		return r;
  801bb4:	83 c4 10             	add    $0x10,%esp
}
  801bb7:	89 d8                	mov    %ebx,%eax
  801bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <accept>:
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	e8 4e ff ff ff       	call   801b1c <fd2sockid>
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 1b                	js     801bed <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	ff 75 10             	pushl  0x10(%ebp)
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	50                   	push   %eax
  801bdc:	e8 0e 01 00 00       	call   801cef <nsipc_accept>
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 05                	js     801bed <accept+0x2d>
	return alloc_sockfd(r);
  801be8:	e8 5f ff ff ff       	call   801b4c <alloc_sockfd>
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <bind>:
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	e8 1f ff ff ff       	call   801b1c <fd2sockid>
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	78 12                	js     801c13 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	50                   	push   %eax
  801c0b:	e8 31 01 00 00       	call   801d41 <nsipc_bind>
  801c10:	83 c4 10             	add    $0x10,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <shutdown>:
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	e8 f9 fe ff ff       	call   801b1c <fd2sockid>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 0f                	js     801c36 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c27:	83 ec 08             	sub    $0x8,%esp
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	50                   	push   %eax
  801c2e:	e8 43 01 00 00       	call   801d76 <nsipc_shutdown>
  801c33:	83 c4 10             	add    $0x10,%esp
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <connect>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	e8 d6 fe ff ff       	call   801b1c <fd2sockid>
  801c46:	85 c0                	test   %eax,%eax
  801c48:	78 12                	js     801c5c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	e8 59 01 00 00       	call   801db2 <nsipc_connect>
  801c59:	83 c4 10             	add    $0x10,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <listen>:
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	e8 b0 fe ff ff       	call   801b1c <fd2sockid>
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 0f                	js     801c7f <listen+0x21>
	return nsipc_listen(r, backlog);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	50                   	push   %eax
  801c77:	e8 6b 01 00 00       	call   801de7 <nsipc_listen>
  801c7c:	83 c4 10             	add    $0x10,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	e8 3e 02 00 00       	call   801ed3 <nsipc_socket>
  801c95:	83 c4 10             	add    $0x10,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 05                	js     801ca1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c9c:	e8 ab fe ff ff       	call   801b4c <alloc_sockfd>
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cb3:	74 26                	je     801cdb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cb5:	6a 07                	push   $0x7
  801cb7:	68 00 80 80 00       	push   $0x808000
  801cbc:	53                   	push   %ebx
  801cbd:	ff 35 04 40 80 00    	pushl  0x804004
  801cc3:	e8 61 07 00 00       	call   802429 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cc8:	83 c4 0c             	add    $0xc,%esp
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	e8 ea 06 00 00       	call   8023c0 <ipc_recv>
}
  801cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	6a 02                	push   $0x2
  801ce0:	e8 9c 07 00 00       	call   802481 <ipc_find_env>
  801ce5:	a3 04 40 80 00       	mov    %eax,0x804004
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	eb c6                	jmp    801cb5 <nsipc+0x12>

00801cef <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	56                   	push   %esi
  801cf3:	53                   	push   %ebx
  801cf4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cff:	8b 06                	mov    (%esi),%eax
  801d01:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	e8 93 ff ff ff       	call   801ca3 <nsipc>
  801d10:	89 c3                	mov    %eax,%ebx
  801d12:	85 c0                	test   %eax,%eax
  801d14:	79 09                	jns    801d1f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d16:	89 d8                	mov    %ebx,%eax
  801d18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d1f:	83 ec 04             	sub    $0x4,%esp
  801d22:	ff 35 10 80 80 00    	pushl  0x808010
  801d28:	68 00 80 80 00       	push   $0x808000
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	e8 e8 ee ff ff       	call   800c1d <memmove>
		*addrlen = ret->ret_addrlen;
  801d35:	a1 10 80 80 00       	mov    0x808010,%eax
  801d3a:	89 06                	mov    %eax,(%esi)
  801d3c:	83 c4 10             	add    $0x10,%esp
	return r;
  801d3f:	eb d5                	jmp    801d16 <nsipc_accept+0x27>

00801d41 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	53                   	push   %ebx
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d53:	53                   	push   %ebx
  801d54:	ff 75 0c             	pushl  0xc(%ebp)
  801d57:	68 04 80 80 00       	push   $0x808004
  801d5c:	e8 bc ee ff ff       	call   800c1d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d61:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801d67:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6c:	e8 32 ff ff ff       	call   801ca3 <nsipc>
}
  801d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d87:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801d8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d91:	e8 0d ff ff ff       	call   801ca3 <nsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <nsipc_close>:

int
nsipc_close(int s)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801da6:	b8 04 00 00 00       	mov    $0x4,%eax
  801dab:	e8 f3 fe ff ff       	call   801ca3 <nsipc>
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	53                   	push   %ebx
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dc4:	53                   	push   %ebx
  801dc5:	ff 75 0c             	pushl  0xc(%ebp)
  801dc8:	68 04 80 80 00       	push   $0x808004
  801dcd:	e8 4b ee ff ff       	call   800c1d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dd2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801dd8:	b8 05 00 00 00       	mov    $0x5,%eax
  801ddd:	e8 c1 fe ff ff       	call   801ca3 <nsipc>
}
  801de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801dfd:	b8 06 00 00 00       	mov    $0x6,%eax
  801e02:	e8 9c fe ff ff       	call   801ca3 <nsipc>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801e19:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e27:	b8 07 00 00 00       	mov    $0x7,%eax
  801e2c:	e8 72 fe ff ff       	call   801ca3 <nsipc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 1f                	js     801e56 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e37:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e3c:	7f 21                	jg     801e5f <nsipc_recv+0x56>
  801e3e:	39 c6                	cmp    %eax,%esi
  801e40:	7c 1d                	jl     801e5f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	50                   	push   %eax
  801e46:	68 00 80 80 00       	push   $0x808000
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	e8 ca ed ff ff       	call   800c1d <memmove>
  801e53:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e56:	89 d8                	mov    %ebx,%eax
  801e58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e5f:	68 e7 2c 80 00       	push   $0x802ce7
  801e64:	68 af 2c 80 00       	push   $0x802caf
  801e69:	6a 62                	push   $0x62
  801e6b:	68 fc 2c 80 00       	push   $0x802cfc
  801e70:	e8 c5 e3 ff ff       	call   80023a <_panic>

00801e75 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	53                   	push   %ebx
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801e87:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e8d:	7f 2e                	jg     801ebd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	53                   	push   %ebx
  801e93:	ff 75 0c             	pushl  0xc(%ebp)
  801e96:	68 0c 80 80 00       	push   $0x80800c
  801e9b:	e8 7d ed ff ff       	call   800c1d <memmove>
	nsipcbuf.send.req_size = size;
  801ea0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801eae:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb3:	e8 eb fd ff ff       	call   801ca3 <nsipc>
}
  801eb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    
	assert(size < 1600);
  801ebd:	68 08 2d 80 00       	push   $0x802d08
  801ec2:	68 af 2c 80 00       	push   $0x802caf
  801ec7:	6a 6d                	push   $0x6d
  801ec9:	68 fc 2c 80 00       	push   $0x802cfc
  801ece:	e8 67 e3 ff ff       	call   80023a <_panic>

00801ed3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee4:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eec:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801ef1:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef6:	e8 a8 fd ff ff       	call   801ca3 <nsipc>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
  801f02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 08             	pushl  0x8(%ebp)
  801f0b:	e8 56 f2 ff ff       	call   801166 <fd2data>
  801f10:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f12:	83 c4 08             	add    $0x8,%esp
  801f15:	68 14 2d 80 00       	push   $0x802d14
  801f1a:	53                   	push   %ebx
  801f1b:	e8 6f eb ff ff       	call   800a8f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f20:	8b 46 04             	mov    0x4(%esi),%eax
  801f23:	2b 06                	sub    (%esi),%eax
  801f25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f32:	00 00 00 
	stat->st_dev = &devpipe;
  801f35:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f3c:	30 80 00 
	return 0;
}
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	53                   	push   %ebx
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f55:	53                   	push   %ebx
  801f56:	6a 00                	push   $0x0
  801f58:	e8 a9 ef ff ff       	call   800f06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f5d:	89 1c 24             	mov    %ebx,(%esp)
  801f60:	e8 01 f2 ff ff       	call   801166 <fd2data>
  801f65:	83 c4 08             	add    $0x8,%esp
  801f68:	50                   	push   %eax
  801f69:	6a 00                	push   $0x0
  801f6b:	e8 96 ef ff ff       	call   800f06 <sys_page_unmap>
}
  801f70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <_pipeisclosed>:
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	57                   	push   %edi
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	83 ec 1c             	sub    $0x1c,%esp
  801f7e:	89 c7                	mov    %eax,%edi
  801f80:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f82:	a1 20 60 80 00       	mov    0x806020,%eax
  801f87:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	57                   	push   %edi
  801f8e:	e8 29 05 00 00       	call   8024bc <pageref>
  801f93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f96:	89 34 24             	mov    %esi,(%esp)
  801f99:	e8 1e 05 00 00       	call   8024bc <pageref>
		nn = thisenv->env_runs;
  801f9e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801fa4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fa7:	83 c4 10             	add    $0x10,%esp
  801faa:	39 cb                	cmp    %ecx,%ebx
  801fac:	74 1b                	je     801fc9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb1:	75 cf                	jne    801f82 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fb3:	8b 42 58             	mov    0x58(%edx),%eax
  801fb6:	6a 01                	push   $0x1
  801fb8:	50                   	push   %eax
  801fb9:	53                   	push   %ebx
  801fba:	68 1b 2d 80 00       	push   $0x802d1b
  801fbf:	e8 6c e3 ff ff       	call   800330 <cprintf>
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	eb b9                	jmp    801f82 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fc9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fcc:	0f 94 c0             	sete   %al
  801fcf:	0f b6 c0             	movzbl %al,%eax
}
  801fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd5:	5b                   	pop    %ebx
  801fd6:	5e                   	pop    %esi
  801fd7:	5f                   	pop    %edi
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    

00801fda <devpipe_write>:
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	57                   	push   %edi
  801fde:	56                   	push   %esi
  801fdf:	53                   	push   %ebx
  801fe0:	83 ec 28             	sub    $0x28,%esp
  801fe3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fe6:	56                   	push   %esi
  801fe7:	e8 7a f1 ff ff       	call   801166 <fd2data>
  801fec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ff9:	74 4f                	je     80204a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ffb:	8b 43 04             	mov    0x4(%ebx),%eax
  801ffe:	8b 0b                	mov    (%ebx),%ecx
  802000:	8d 51 20             	lea    0x20(%ecx),%edx
  802003:	39 d0                	cmp    %edx,%eax
  802005:	72 14                	jb     80201b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802007:	89 da                	mov    %ebx,%edx
  802009:	89 f0                	mov    %esi,%eax
  80200b:	e8 65 ff ff ff       	call   801f75 <_pipeisclosed>
  802010:	85 c0                	test   %eax,%eax
  802012:	75 3b                	jne    80204f <devpipe_write+0x75>
			sys_yield();
  802014:	e8 49 ee ff ff       	call   800e62 <sys_yield>
  802019:	eb e0                	jmp    801ffb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80201b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80201e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802022:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802025:	89 c2                	mov    %eax,%edx
  802027:	c1 fa 1f             	sar    $0x1f,%edx
  80202a:	89 d1                	mov    %edx,%ecx
  80202c:	c1 e9 1b             	shr    $0x1b,%ecx
  80202f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802032:	83 e2 1f             	and    $0x1f,%edx
  802035:	29 ca                	sub    %ecx,%edx
  802037:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80203b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80203f:	83 c0 01             	add    $0x1,%eax
  802042:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802045:	83 c7 01             	add    $0x1,%edi
  802048:	eb ac                	jmp    801ff6 <devpipe_write+0x1c>
	return i;
  80204a:	8b 45 10             	mov    0x10(%ebp),%eax
  80204d:	eb 05                	jmp    802054 <devpipe_write+0x7a>
				return 0;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802054:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <devpipe_read>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	57                   	push   %edi
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	83 ec 18             	sub    $0x18,%esp
  802065:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802068:	57                   	push   %edi
  802069:	e8 f8 f0 ff ff       	call   801166 <fd2data>
  80206e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	be 00 00 00 00       	mov    $0x0,%esi
  802078:	3b 75 10             	cmp    0x10(%ebp),%esi
  80207b:	75 14                	jne    802091 <devpipe_read+0x35>
	return i;
  80207d:	8b 45 10             	mov    0x10(%ebp),%eax
  802080:	eb 02                	jmp    802084 <devpipe_read+0x28>
				return i;
  802082:	89 f0                	mov    %esi,%eax
}
  802084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5f                   	pop    %edi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    
			sys_yield();
  80208c:	e8 d1 ed ff ff       	call   800e62 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802091:	8b 03                	mov    (%ebx),%eax
  802093:	3b 43 04             	cmp    0x4(%ebx),%eax
  802096:	75 18                	jne    8020b0 <devpipe_read+0x54>
			if (i > 0)
  802098:	85 f6                	test   %esi,%esi
  80209a:	75 e6                	jne    802082 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80209c:	89 da                	mov    %ebx,%edx
  80209e:	89 f8                	mov    %edi,%eax
  8020a0:	e8 d0 fe ff ff       	call   801f75 <_pipeisclosed>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	74 e3                	je     80208c <devpipe_read+0x30>
				return 0;
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	eb d4                	jmp    802084 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020b0:	99                   	cltd   
  8020b1:	c1 ea 1b             	shr    $0x1b,%edx
  8020b4:	01 d0                	add    %edx,%eax
  8020b6:	83 e0 1f             	and    $0x1f,%eax
  8020b9:	29 d0                	sub    %edx,%eax
  8020bb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020c6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020c9:	83 c6 01             	add    $0x1,%esi
  8020cc:	eb aa                	jmp    802078 <devpipe_read+0x1c>

008020ce <pipe>:
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	56                   	push   %esi
  8020d2:	53                   	push   %ebx
  8020d3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d9:	50                   	push   %eax
  8020da:	e8 9e f0 ff ff       	call   80117d <fd_alloc>
  8020df:	89 c3                	mov    %eax,%ebx
  8020e1:	83 c4 10             	add    $0x10,%esp
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	0f 88 23 01 00 00    	js     80220f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 07 04 00 00       	push   $0x407
  8020f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f7:	6a 00                	push   $0x0
  8020f9:	e8 83 ed ff ff       	call   800e81 <sys_page_alloc>
  8020fe:	89 c3                	mov    %eax,%ebx
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	85 c0                	test   %eax,%eax
  802105:	0f 88 04 01 00 00    	js     80220f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80210b:	83 ec 0c             	sub    $0xc,%esp
  80210e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802111:	50                   	push   %eax
  802112:	e8 66 f0 ff ff       	call   80117d <fd_alloc>
  802117:	89 c3                	mov    %eax,%ebx
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	0f 88 db 00 00 00    	js     8021ff <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 07 04 00 00       	push   $0x407
  80212c:	ff 75 f0             	pushl  -0x10(%ebp)
  80212f:	6a 00                	push   $0x0
  802131:	e8 4b ed ff ff       	call   800e81 <sys_page_alloc>
  802136:	89 c3                	mov    %eax,%ebx
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	85 c0                	test   %eax,%eax
  80213d:	0f 88 bc 00 00 00    	js     8021ff <pipe+0x131>
	va = fd2data(fd0);
  802143:	83 ec 0c             	sub    $0xc,%esp
  802146:	ff 75 f4             	pushl  -0xc(%ebp)
  802149:	e8 18 f0 ff ff       	call   801166 <fd2data>
  80214e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802150:	83 c4 0c             	add    $0xc,%esp
  802153:	68 07 04 00 00       	push   $0x407
  802158:	50                   	push   %eax
  802159:	6a 00                	push   $0x0
  80215b:	e8 21 ed ff ff       	call   800e81 <sys_page_alloc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	0f 88 82 00 00 00    	js     8021ef <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff 75 f0             	pushl  -0x10(%ebp)
  802173:	e8 ee ef ff ff       	call   801166 <fd2data>
  802178:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80217f:	50                   	push   %eax
  802180:	6a 00                	push   $0x0
  802182:	56                   	push   %esi
  802183:	6a 00                	push   $0x0
  802185:	e8 3a ed ff ff       	call   800ec4 <sys_page_map>
  80218a:	89 c3                	mov    %eax,%ebx
  80218c:	83 c4 20             	add    $0x20,%esp
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 4e                	js     8021e1 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802193:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80219d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021aa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021b6:	83 ec 0c             	sub    $0xc,%esp
  8021b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bc:	e8 95 ef ff ff       	call   801156 <fd2num>
  8021c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021c4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021c6:	83 c4 04             	add    $0x4,%esp
  8021c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021cc:	e8 85 ef ff ff       	call   801156 <fd2num>
  8021d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021df:	eb 2e                	jmp    80220f <pipe+0x141>
	sys_page_unmap(0, va);
  8021e1:	83 ec 08             	sub    $0x8,%esp
  8021e4:	56                   	push   %esi
  8021e5:	6a 00                	push   $0x0
  8021e7:	e8 1a ed ff ff       	call   800f06 <sys_page_unmap>
  8021ec:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021ef:	83 ec 08             	sub    $0x8,%esp
  8021f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f5:	6a 00                	push   $0x0
  8021f7:	e8 0a ed ff ff       	call   800f06 <sys_page_unmap>
  8021fc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021ff:	83 ec 08             	sub    $0x8,%esp
  802202:	ff 75 f4             	pushl  -0xc(%ebp)
  802205:	6a 00                	push   $0x0
  802207:	e8 fa ec ff ff       	call   800f06 <sys_page_unmap>
  80220c:	83 c4 10             	add    $0x10,%esp
}
  80220f:	89 d8                	mov    %ebx,%eax
  802211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    

00802218 <pipeisclosed>:
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80221e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802221:	50                   	push   %eax
  802222:	ff 75 08             	pushl  0x8(%ebp)
  802225:	e8 a5 ef ff ff       	call   8011cf <fd_lookup>
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 18                	js     802249 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	ff 75 f4             	pushl  -0xc(%ebp)
  802237:	e8 2a ef ff ff       	call   801166 <fd2data>
	return _pipeisclosed(fd, p);
  80223c:	89 c2                	mov    %eax,%edx
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	e8 2f fd ff ff       	call   801f75 <_pipeisclosed>
  802246:	83 c4 10             	add    $0x10,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	c3                   	ret    

00802251 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802257:	68 33 2d 80 00       	push   $0x802d33
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	e8 2b e8 ff ff       	call   800a8f <strcpy>
	return 0;
}
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <devcons_write>:
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	57                   	push   %edi
  80226f:	56                   	push   %esi
  802270:	53                   	push   %ebx
  802271:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802277:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80227c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802282:	3b 75 10             	cmp    0x10(%ebp),%esi
  802285:	73 31                	jae    8022b8 <devcons_write+0x4d>
		m = n - tot;
  802287:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80228a:	29 f3                	sub    %esi,%ebx
  80228c:	83 fb 7f             	cmp    $0x7f,%ebx
  80228f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802294:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	53                   	push   %ebx
  80229b:	89 f0                	mov    %esi,%eax
  80229d:	03 45 0c             	add    0xc(%ebp),%eax
  8022a0:	50                   	push   %eax
  8022a1:	57                   	push   %edi
  8022a2:	e8 76 e9 ff ff       	call   800c1d <memmove>
		sys_cputs(buf, m);
  8022a7:	83 c4 08             	add    $0x8,%esp
  8022aa:	53                   	push   %ebx
  8022ab:	57                   	push   %edi
  8022ac:	e8 14 eb ff ff       	call   800dc5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022b1:	01 de                	add    %ebx,%esi
  8022b3:	83 c4 10             	add    $0x10,%esp
  8022b6:	eb ca                	jmp    802282 <devcons_write+0x17>
}
  8022b8:	89 f0                	mov    %esi,%eax
  8022ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5f                   	pop    %edi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <devcons_read>:
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 08             	sub    $0x8,%esp
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d1:	74 21                	je     8022f4 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022d3:	e8 0b eb ff ff       	call   800de3 <sys_cgetc>
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	75 07                	jne    8022e3 <devcons_read+0x21>
		sys_yield();
  8022dc:	e8 81 eb ff ff       	call   800e62 <sys_yield>
  8022e1:	eb f0                	jmp    8022d3 <devcons_read+0x11>
	if (c < 0)
  8022e3:	78 0f                	js     8022f4 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022e5:	83 f8 04             	cmp    $0x4,%eax
  8022e8:	74 0c                	je     8022f6 <devcons_read+0x34>
	*(char*)vbuf = c;
  8022ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ed:	88 02                	mov    %al,(%edx)
	return 1;
  8022ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    
		return 0;
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	eb f7                	jmp    8022f4 <devcons_read+0x32>

008022fd <cputchar>:
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802309:	6a 01                	push   $0x1
  80230b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80230e:	50                   	push   %eax
  80230f:	e8 b1 ea ff ff       	call   800dc5 <sys_cputs>
}
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <getchar>:
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80231f:	6a 01                	push   $0x1
  802321:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802324:	50                   	push   %eax
  802325:	6a 00                	push   $0x0
  802327:	e8 13 f1 ff ff       	call   80143f <read>
	if (r < 0)
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 06                	js     802339 <getchar+0x20>
	if (r < 1)
  802333:	74 06                	je     80233b <getchar+0x22>
	return c;
  802335:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    
		return -E_EOF;
  80233b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802340:	eb f7                	jmp    802339 <getchar+0x20>

00802342 <iscons>:
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802348:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234b:	50                   	push   %eax
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	e8 7b ee ff ff       	call   8011cf <fd_lookup>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	85 c0                	test   %eax,%eax
  802359:	78 11                	js     80236c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802364:	39 10                	cmp    %edx,(%eax)
  802366:	0f 94 c0             	sete   %al
  802369:	0f b6 c0             	movzbl %al,%eax
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <opencons>:
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802374:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802377:	50                   	push   %eax
  802378:	e8 00 ee ff ff       	call   80117d <fd_alloc>
  80237d:	83 c4 10             	add    $0x10,%esp
  802380:	85 c0                	test   %eax,%eax
  802382:	78 3a                	js     8023be <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	68 07 04 00 00       	push   $0x407
  80238c:	ff 75 f4             	pushl  -0xc(%ebp)
  80238f:	6a 00                	push   $0x0
  802391:	e8 eb ea ff ff       	call   800e81 <sys_page_alloc>
  802396:	83 c4 10             	add    $0x10,%esp
  802399:	85 c0                	test   %eax,%eax
  80239b:	78 21                	js     8023be <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	50                   	push   %eax
  8023b6:	e8 9b ed ff ff       	call   801156 <fd2num>
  8023bb:	83 c4 10             	add    $0x10,%esp
}
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	56                   	push   %esi
  8023c4:	53                   	push   %ebx
  8023c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8023ce:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023d0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023d5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	50                   	push   %eax
  8023dc:	e8 50 ec ff ff       	call   801031 <sys_ipc_recv>
	if(ret < 0){
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 2b                	js     802413 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8023e8:	85 f6                	test   %esi,%esi
  8023ea:	74 0a                	je     8023f6 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8023ec:	a1 20 60 80 00       	mov    0x806020,%eax
  8023f1:	8b 40 74             	mov    0x74(%eax),%eax
  8023f4:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023f6:	85 db                	test   %ebx,%ebx
  8023f8:	74 0a                	je     802404 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8023fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8023ff:	8b 40 78             	mov    0x78(%eax),%eax
  802402:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802404:	a1 20 60 80 00       	mov    0x806020,%eax
  802409:	8b 40 70             	mov    0x70(%eax),%eax
}
  80240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80240f:	5b                   	pop    %ebx
  802410:	5e                   	pop    %esi
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    
		if(from_env_store)
  802413:	85 f6                	test   %esi,%esi
  802415:	74 06                	je     80241d <ipc_recv+0x5d>
			*from_env_store = 0;
  802417:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80241d:	85 db                	test   %ebx,%ebx
  80241f:	74 eb                	je     80240c <ipc_recv+0x4c>
			*perm_store = 0;
  802421:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802427:	eb e3                	jmp    80240c <ipc_recv+0x4c>

00802429 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	57                   	push   %edi
  80242d:	56                   	push   %esi
  80242e:	53                   	push   %ebx
  80242f:	83 ec 0c             	sub    $0xc,%esp
  802432:	8b 7d 08             	mov    0x8(%ebp),%edi
  802435:	8b 75 0c             	mov    0xc(%ebp),%esi
  802438:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80243b:	85 db                	test   %ebx,%ebx
  80243d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802442:	0f 44 d8             	cmove  %eax,%ebx
  802445:	eb 05                	jmp    80244c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802447:	e8 16 ea ff ff       	call   800e62 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80244c:	ff 75 14             	pushl  0x14(%ebp)
  80244f:	53                   	push   %ebx
  802450:	56                   	push   %esi
  802451:	57                   	push   %edi
  802452:	e8 b7 eb ff ff       	call   80100e <sys_ipc_try_send>
  802457:	83 c4 10             	add    $0x10,%esp
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 1b                	je     802479 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80245e:	79 e7                	jns    802447 <ipc_send+0x1e>
  802460:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802463:	74 e2                	je     802447 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 3f 2d 80 00       	push   $0x802d3f
  80246d:	6a 4a                	push   $0x4a
  80246f:	68 54 2d 80 00       	push   $0x802d54
  802474:	e8 c1 dd ff ff       	call   80023a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248c:	89 c2                	mov    %eax,%edx
  80248e:	c1 e2 07             	shl    $0x7,%edx
  802491:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802497:	8b 52 50             	mov    0x50(%edx),%edx
  80249a:	39 ca                	cmp    %ecx,%edx
  80249c:	74 11                	je     8024af <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80249e:	83 c0 01             	add    $0x1,%eax
  8024a1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a6:	75 e4                	jne    80248c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ad:	eb 0b                	jmp    8024ba <ipc_find_env+0x39>
			return envs[i].env_id;
  8024af:	c1 e0 07             	shl    $0x7,%eax
  8024b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024b7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	c1 e8 16             	shr    $0x16,%eax
  8024c7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d3:	f6 c1 01             	test   $0x1,%cl
  8024d6:	74 1d                	je     8024f5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024d8:	c1 ea 0c             	shr    $0xc,%edx
  8024db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e2:	f6 c2 01             	test   $0x1,%dl
  8024e5:	74 0e                	je     8024f5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e7:	c1 ea 0c             	shr    $0xc,%edx
  8024ea:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f1:	ef 
  8024f2:	0f b7 c0             	movzwl %ax,%eax
}
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    
  8024f7:	66 90                	xchg   %ax,%ax
  8024f9:	66 90                	xchg   %ax,%ax
  8024fb:	66 90                	xchg   %ax,%ax
  8024fd:	66 90                	xchg   %ax,%ax
  8024ff:	90                   	nop

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80250f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802517:	85 d2                	test   %edx,%edx
  802519:	75 4d                	jne    802568 <__udivdi3+0x68>
  80251b:	39 f3                	cmp    %esi,%ebx
  80251d:	76 19                	jbe    802538 <__udivdi3+0x38>
  80251f:	31 ff                	xor    %edi,%edi
  802521:	89 e8                	mov    %ebp,%eax
  802523:	89 f2                	mov    %esi,%edx
  802525:	f7 f3                	div    %ebx
  802527:	89 fa                	mov    %edi,%edx
  802529:	83 c4 1c             	add    $0x1c,%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5f                   	pop    %edi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 d9                	mov    %ebx,%ecx
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	75 0b                	jne    802549 <__udivdi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 c1                	mov    %eax,%ecx
  802549:	31 d2                	xor    %edx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	f7 f1                	div    %ecx
  80254f:	89 c6                	mov    %eax,%esi
  802551:	89 e8                	mov    %ebp,%eax
  802553:	89 f7                	mov    %esi,%edi
  802555:	f7 f1                	div    %ecx
  802557:	89 fa                	mov    %edi,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	77 1c                	ja     802588 <__udivdi3+0x88>
  80256c:	0f bd fa             	bsr    %edx,%edi
  80256f:	83 f7 1f             	xor    $0x1f,%edi
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	39 f2                	cmp    %esi,%edx
  802576:	72 06                	jb     80257e <__udivdi3+0x7e>
  802578:	31 c0                	xor    %eax,%eax
  80257a:	39 eb                	cmp    %ebp,%ebx
  80257c:	77 a9                	ja     802527 <__udivdi3+0x27>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb a2                	jmp    802527 <__udivdi3+0x27>
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	89 eb                	mov    %ebp,%ebx
  8025d1:	d3 e6                	shl    %cl,%esi
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 15                	jb     802600 <__udivdi3+0x100>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 04                	jae    8025f7 <__udivdi3+0xf7>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	74 09                	je     802600 <__udivdi3+0x100>
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	31 ff                	xor    %edi,%edi
  8025fb:	e9 27 ff ff ff       	jmp    802527 <__udivdi3+0x27>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 1d ff ff ff       	jmp    802527 <__udivdi3+0x27>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	55                   	push   %ebp
  802611:	57                   	push   %edi
  802612:	56                   	push   %esi
  802613:	53                   	push   %ebx
  802614:	83 ec 1c             	sub    $0x1c,%esp
  802617:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80261b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80261f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802627:	89 da                	mov    %ebx,%edx
  802629:	85 c0                	test   %eax,%eax
  80262b:	75 43                	jne    802670 <__umoddi3+0x60>
  80262d:	39 df                	cmp    %ebx,%edi
  80262f:	76 17                	jbe    802648 <__umoddi3+0x38>
  802631:	89 f0                	mov    %esi,%eax
  802633:	f7 f7                	div    %edi
  802635:	89 d0                	mov    %edx,%eax
  802637:	31 d2                	xor    %edx,%edx
  802639:	83 c4 1c             	add    $0x1c,%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5f                   	pop    %edi
  80263f:	5d                   	pop    %ebp
  802640:	c3                   	ret    
  802641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802648:	89 fd                	mov    %edi,%ebp
  80264a:	85 ff                	test   %edi,%edi
  80264c:	75 0b                	jne    802659 <__umoddi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f7                	div    %edi
  802657:	89 c5                	mov    %eax,%ebp
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f5                	div    %ebp
  80265f:	89 f0                	mov    %esi,%eax
  802661:	f7 f5                	div    %ebp
  802663:	89 d0                	mov    %edx,%eax
  802665:	eb d0                	jmp    802637 <__umoddi3+0x27>
  802667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266e:	66 90                	xchg   %ax,%ax
  802670:	89 f1                	mov    %esi,%ecx
  802672:	39 d8                	cmp    %ebx,%eax
  802674:	76 0a                	jbe    802680 <__umoddi3+0x70>
  802676:	89 f0                	mov    %esi,%eax
  802678:	83 c4 1c             	add    $0x1c,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	75 20                	jne    8026a8 <__umoddi3+0x98>
  802688:	39 d8                	cmp    %ebx,%eax
  80268a:	0f 82 b0 00 00 00    	jb     802740 <__umoddi3+0x130>
  802690:	39 f7                	cmp    %esi,%edi
  802692:	0f 86 a8 00 00 00    	jbe    802740 <__umoddi3+0x130>
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026af:	29 ea                	sub    %ebp,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	d3 e8                	shr    %cl,%eax
  8026bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026c9:	09 c1                	or     %eax,%ecx
  8026cb:	89 d8                	mov    %ebx,%eax
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	d3 e6                	shl    %cl,%esi
  8026ef:	09 d8                	or     %ebx,%eax
  8026f1:	f7 74 24 08          	divl   0x8(%esp)
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	89 f3                	mov    %esi,%ebx
  8026f9:	f7 64 24 0c          	mull   0xc(%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d7                	mov    %edx,%edi
  802701:	39 d1                	cmp    %edx,%ecx
  802703:	72 06                	jb     80270b <__umoddi3+0xfb>
  802705:	75 10                	jne    802717 <__umoddi3+0x107>
  802707:	39 c3                	cmp    %eax,%ebx
  802709:	73 0c                	jae    802717 <__umoddi3+0x107>
  80270b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80270f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802713:	89 d7                	mov    %edx,%edi
  802715:	89 c6                	mov    %eax,%esi
  802717:	89 ca                	mov    %ecx,%edx
  802719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	19 fa                	sbb    %edi,%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	d3 e0                	shl    %cl,%eax
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	d3 eb                	shr    %cl,%ebx
  80272a:	d3 ea                	shr    %cl,%edx
  80272c:	09 d8                	or     %ebx,%eax
  80272e:	83 c4 1c             	add    $0x1c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	89 da                	mov    %ebx,%edx
  802742:	29 fe                	sub    %edi,%esi
  802744:	19 c2                	sbb    %eax,%edx
  802746:	89 f1                	mov    %esi,%ecx
  802748:	89 c8                	mov    %ecx,%eax
  80274a:	e9 4b ff ff ff       	jmp    80269a <__umoddi3+0x8a>
