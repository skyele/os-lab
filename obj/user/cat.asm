
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
  800049:	e8 11 14 00 00       	call   80145f <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 c4 14 00 00       	call   80152b <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 80 27 80 00       	push   $0x802780
  80007a:	6a 0d                	push   $0xd
  80007c:	68 9b 27 80 00       	push   $0x80279b
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
  800096:	68 a6 27 80 00       	push   $0x8027a6
  80009b:	6a 0f                	push   $0xf
  80009d:	68 9b 27 80 00       	push   $0x80279b
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
  8000b3:	c7 05 00 30 80 00 bb 	movl   $0x8027bb,0x803000
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
  8000cb:	68 bf 27 80 00       	push   $0x8027bf
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
  8000e9:	68 c7 27 80 00       	push   $0x8027c7
  8000ee:	e8 ad 19 00 00       	call   801aa0 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 f2 17 00 00       	call   8018fd <open>
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
  800123:	e8 f9 11 00 00       	call   801321 <close>
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
  8001b0:	68 da 27 80 00       	push   $0x8027da
  8001b5:	e8 76 01 00 00       	call   800330 <cprintf>
	cprintf("before umain\n");
  8001ba:	c7 04 24 f8 27 80 00 	movl   $0x8027f8,(%esp)
  8001c1:	e8 6a 01 00 00       	call   800330 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001c6:	83 c4 08             	add    $0x8,%esp
  8001c9:	ff 75 0c             	pushl  0xc(%ebp)
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	e8 d3 fe ff ff       	call   8000a7 <umain>
	cprintf("after umain\n");
  8001d4:	c7 04 24 06 28 80 00 	movl   $0x802806,(%esp)
  8001db:	e8 50 01 00 00       	call   800330 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001e5:	8b 40 48             	mov    0x48(%eax),%eax
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	50                   	push   %eax
  8001ec:	68 13 28 80 00       	push   $0x802813
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
  800214:	68 40 28 80 00       	push   $0x802840
  800219:	50                   	push   %eax
  80021a:	68 32 28 80 00       	push   $0x802832
  80021f:	e8 0c 01 00 00       	call   800330 <cprintf>
	close_all();
  800224:	e8 25 11 00 00       	call   80134e <close_all>
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
  80024a:	68 6c 28 80 00       	push   $0x80286c
  80024f:	50                   	push   %eax
  800250:	68 32 28 80 00       	push   $0x802832
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
  800273:	68 48 28 80 00       	push   $0x802848
  800278:	e8 b3 00 00 00       	call   800330 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80027d:	83 c4 18             	add    $0x18,%esp
  800280:	53                   	push   %ebx
  800281:	ff 75 10             	pushl  0x10(%ebp)
  800284:	e8 56 00 00 00       	call   8002df <vcprintf>
	cprintf("\n");
  800289:	c7 04 24 f6 27 80 00 	movl   $0x8027f6,(%esp)
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
  8003dd:	e8 3e 21 00 00       	call   802520 <__udivdi3>
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
  800406:	e8 25 22 00 00       	call   802630 <__umoddi3>
  80040b:	83 c4 14             	add    $0x14,%esp
  80040e:	0f be 80 73 28 80 00 	movsbl 0x802873(%eax),%eax
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
  8004b7:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
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
  800582:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  800589:	85 d2                	test   %edx,%edx
  80058b:	74 18                	je     8005a5 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80058d:	52                   	push   %edx
  80058e:	68 e1 2c 80 00       	push   $0x802ce1
  800593:	53                   	push   %ebx
  800594:	56                   	push   %esi
  800595:	e8 a6 fe ff ff       	call   800440 <printfmt>
  80059a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059d:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a0:	e9 fe 02 00 00       	jmp    8008a3 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005a5:	50                   	push   %eax
  8005a6:	68 8b 28 80 00       	push   $0x80288b
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
  8005cd:	b8 84 28 80 00       	mov    $0x802884,%eax
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
  800965:	bf a9 29 80 00       	mov    $0x8029a9,%edi
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
  800991:	bf e1 29 80 00       	mov    $0x8029e1,%edi
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
  800e32:	68 08 2c 80 00       	push   $0x802c08
  800e37:	6a 43                	push   $0x43
  800e39:	68 25 2c 80 00       	push   $0x802c25
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
  800eb3:	68 08 2c 80 00       	push   $0x802c08
  800eb8:	6a 43                	push   $0x43
  800eba:	68 25 2c 80 00       	push   $0x802c25
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
  800ef5:	68 08 2c 80 00       	push   $0x802c08
  800efa:	6a 43                	push   $0x43
  800efc:	68 25 2c 80 00       	push   $0x802c25
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
  800f37:	68 08 2c 80 00       	push   $0x802c08
  800f3c:	6a 43                	push   $0x43
  800f3e:	68 25 2c 80 00       	push   $0x802c25
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
  800f79:	68 08 2c 80 00       	push   $0x802c08
  800f7e:	6a 43                	push   $0x43
  800f80:	68 25 2c 80 00       	push   $0x802c25
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
  800fbb:	68 08 2c 80 00       	push   $0x802c08
  800fc0:	6a 43                	push   $0x43
  800fc2:	68 25 2c 80 00       	push   $0x802c25
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
  800ffd:	68 08 2c 80 00       	push   $0x802c08
  801002:	6a 43                	push   $0x43
  801004:	68 25 2c 80 00       	push   $0x802c25
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
  801061:	68 08 2c 80 00       	push   $0x802c08
  801066:	6a 43                	push   $0x43
  801068:	68 25 2c 80 00       	push   $0x802c25
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
  801145:	68 08 2c 80 00       	push   $0x802c08
  80114a:	6a 43                	push   $0x43
  80114c:	68 25 2c 80 00       	push   $0x802c25
  801151:	e8 e4 f0 ff ff       	call   80023a <_panic>

00801156 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801161:	8b 55 08             	mov    0x8(%ebp),%edx
  801164:	b8 14 00 00 00       	mov    $0x14,%eax
  801169:	89 cb                	mov    %ecx,%ebx
  80116b:	89 cf                	mov    %ecx,%edi
  80116d:	89 ce                	mov    %ecx,%esi
  80116f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	05 00 00 00 30       	add    $0x30000000,%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
}
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801191:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801196:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a5:	89 c2                	mov    %eax,%edx
  8011a7:	c1 ea 16             	shr    $0x16,%edx
  8011aa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b1:	f6 c2 01             	test   $0x1,%dl
  8011b4:	74 2d                	je     8011e3 <fd_alloc+0x46>
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	c1 ea 0c             	shr    $0xc,%edx
  8011bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c2:	f6 c2 01             	test   $0x1,%dl
  8011c5:	74 1c                	je     8011e3 <fd_alloc+0x46>
  8011c7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011cc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d1:	75 d2                	jne    8011a5 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011dc:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e1:	eb 0a                	jmp    8011ed <fd_alloc+0x50>
			*fd_store = fd;
  8011e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011f5:	83 f8 1f             	cmp    $0x1f,%eax
  8011f8:	77 30                	ja     80122a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011fa:	c1 e0 0c             	shl    $0xc,%eax
  8011fd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801202:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801208:	f6 c2 01             	test   $0x1,%dl
  80120b:	74 24                	je     801231 <fd_lookup+0x42>
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	c1 ea 0c             	shr    $0xc,%edx
  801212:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801219:	f6 c2 01             	test   $0x1,%dl
  80121c:	74 1a                	je     801238 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80121e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801221:	89 02                	mov    %eax,(%edx)
	return 0;
  801223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    
		return -E_INVAL;
  80122a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122f:	eb f7                	jmp    801228 <fd_lookup+0x39>
		return -E_INVAL;
  801231:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801236:	eb f0                	jmp    801228 <fd_lookup+0x39>
  801238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123d:	eb e9                	jmp    801228 <fd_lookup+0x39>

0080123f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 08             	sub    $0x8,%esp
  801245:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801248:	ba 00 00 00 00       	mov    $0x0,%edx
  80124d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801252:	39 08                	cmp    %ecx,(%eax)
  801254:	74 38                	je     80128e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801256:	83 c2 01             	add    $0x1,%edx
  801259:	8b 04 95 b4 2c 80 00 	mov    0x802cb4(,%edx,4),%eax
  801260:	85 c0                	test   %eax,%eax
  801262:	75 ee                	jne    801252 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801264:	a1 20 60 80 00       	mov    0x806020,%eax
  801269:	8b 40 48             	mov    0x48(%eax),%eax
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	51                   	push   %ecx
  801270:	50                   	push   %eax
  801271:	68 34 2c 80 00       	push   $0x802c34
  801276:	e8 b5 f0 ff ff       	call   800330 <cprintf>
	*dev = 0;
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    
			*dev = devtab[i];
  80128e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801291:	89 01                	mov    %eax,(%ecx)
			return 0;
  801293:	b8 00 00 00 00       	mov    $0x0,%eax
  801298:	eb f2                	jmp    80128c <dev_lookup+0x4d>

0080129a <fd_close>:
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	57                   	push   %edi
  80129e:	56                   	push   %esi
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 24             	sub    $0x24,%esp
  8012a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ac:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ad:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012b3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b6:	50                   	push   %eax
  8012b7:	e8 33 ff ff ff       	call   8011ef <fd_lookup>
  8012bc:	89 c3                	mov    %eax,%ebx
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 05                	js     8012ca <fd_close+0x30>
	    || fd != fd2)
  8012c5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012c8:	74 16                	je     8012e0 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012ca:	89 f8                	mov    %edi,%eax
  8012cc:	84 c0                	test   %al,%al
  8012ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d3:	0f 44 d8             	cmove  %eax,%ebx
}
  8012d6:	89 d8                	mov    %ebx,%eax
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	ff 36                	pushl  (%esi)
  8012e9:	e8 51 ff ff ff       	call   80123f <dev_lookup>
  8012ee:	89 c3                	mov    %eax,%ebx
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 1a                	js     801311 <fd_close+0x77>
		if (dev->dev_close)
  8012f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801302:	85 c0                	test   %eax,%eax
  801304:	74 0b                	je     801311 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	56                   	push   %esi
  80130a:	ff d0                	call   *%eax
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	56                   	push   %esi
  801315:	6a 00                	push   $0x0
  801317:	e8 ea fb ff ff       	call   800f06 <sys_page_unmap>
	return r;
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	eb b5                	jmp    8012d6 <fd_close+0x3c>

00801321 <close>:

int
close(int fdnum)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801327:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	e8 bc fe ff ff       	call   8011ef <fd_lookup>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	79 02                	jns    80133c <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    
		return fd_close(fd, 1);
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	6a 01                	push   $0x1
  801341:	ff 75 f4             	pushl  -0xc(%ebp)
  801344:	e8 51 ff ff ff       	call   80129a <fd_close>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	eb ec                	jmp    80133a <close+0x19>

0080134e <close_all>:

void
close_all(void)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	53                   	push   %ebx
  801352:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801355:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	53                   	push   %ebx
  80135e:	e8 be ff ff ff       	call   801321 <close>
	for (i = 0; i < MAXFD; i++)
  801363:	83 c3 01             	add    $0x1,%ebx
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	83 fb 20             	cmp    $0x20,%ebx
  80136c:	75 ec                	jne    80135a <close_all+0xc>
}
  80136e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	57                   	push   %edi
  801377:	56                   	push   %esi
  801378:	53                   	push   %ebx
  801379:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80137c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80137f:	50                   	push   %eax
  801380:	ff 75 08             	pushl  0x8(%ebp)
  801383:	e8 67 fe ff ff       	call   8011ef <fd_lookup>
  801388:	89 c3                	mov    %eax,%ebx
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	0f 88 81 00 00 00    	js     801416 <dup+0xa3>
		return r;
	close(newfdnum);
  801395:	83 ec 0c             	sub    $0xc,%esp
  801398:	ff 75 0c             	pushl  0xc(%ebp)
  80139b:	e8 81 ff ff ff       	call   801321 <close>

	newfd = INDEX2FD(newfdnum);
  8013a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013a3:	c1 e6 0c             	shl    $0xc,%esi
  8013a6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013ac:	83 c4 04             	add    $0x4,%esp
  8013af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b2:	e8 cf fd ff ff       	call   801186 <fd2data>
  8013b7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013b9:	89 34 24             	mov    %esi,(%esp)
  8013bc:	e8 c5 fd ff ff       	call   801186 <fd2data>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013c6:	89 d8                	mov    %ebx,%eax
  8013c8:	c1 e8 16             	shr    $0x16,%eax
  8013cb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d2:	a8 01                	test   $0x1,%al
  8013d4:	74 11                	je     8013e7 <dup+0x74>
  8013d6:	89 d8                	mov    %ebx,%eax
  8013d8:	c1 e8 0c             	shr    $0xc,%eax
  8013db:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e2:	f6 c2 01             	test   $0x1,%dl
  8013e5:	75 39                	jne    801420 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ea:	89 d0                	mov    %edx,%eax
  8013ec:	c1 e8 0c             	shr    $0xc,%eax
  8013ef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f6:	83 ec 0c             	sub    $0xc,%esp
  8013f9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013fe:	50                   	push   %eax
  8013ff:	56                   	push   %esi
  801400:	6a 00                	push   $0x0
  801402:	52                   	push   %edx
  801403:	6a 00                	push   $0x0
  801405:	e8 ba fa ff ff       	call   800ec4 <sys_page_map>
  80140a:	89 c3                	mov    %eax,%ebx
  80140c:	83 c4 20             	add    $0x20,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 31                	js     801444 <dup+0xd1>
		goto err;

	return newfdnum;
  801413:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801416:	89 d8                	mov    %ebx,%eax
  801418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5f                   	pop    %edi
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801420:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801427:	83 ec 0c             	sub    $0xc,%esp
  80142a:	25 07 0e 00 00       	and    $0xe07,%eax
  80142f:	50                   	push   %eax
  801430:	57                   	push   %edi
  801431:	6a 00                	push   $0x0
  801433:	53                   	push   %ebx
  801434:	6a 00                	push   $0x0
  801436:	e8 89 fa ff ff       	call   800ec4 <sys_page_map>
  80143b:	89 c3                	mov    %eax,%ebx
  80143d:	83 c4 20             	add    $0x20,%esp
  801440:	85 c0                	test   %eax,%eax
  801442:	79 a3                	jns    8013e7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801444:	83 ec 08             	sub    $0x8,%esp
  801447:	56                   	push   %esi
  801448:	6a 00                	push   $0x0
  80144a:	e8 b7 fa ff ff       	call   800f06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80144f:	83 c4 08             	add    $0x8,%esp
  801452:	57                   	push   %edi
  801453:	6a 00                	push   $0x0
  801455:	e8 ac fa ff ff       	call   800f06 <sys_page_unmap>
	return r;
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	eb b7                	jmp    801416 <dup+0xa3>

0080145f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	53                   	push   %ebx
  801463:	83 ec 1c             	sub    $0x1c,%esp
  801466:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801469:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146c:	50                   	push   %eax
  80146d:	53                   	push   %ebx
  80146e:	e8 7c fd ff ff       	call   8011ef <fd_lookup>
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 3f                	js     8014b9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147a:	83 ec 08             	sub    $0x8,%esp
  80147d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801484:	ff 30                	pushl  (%eax)
  801486:	e8 b4 fd ff ff       	call   80123f <dev_lookup>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 27                	js     8014b9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801495:	8b 42 08             	mov    0x8(%edx),%eax
  801498:	83 e0 03             	and    $0x3,%eax
  80149b:	83 f8 01             	cmp    $0x1,%eax
  80149e:	74 1e                	je     8014be <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	8b 40 08             	mov    0x8(%eax),%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 35                	je     8014df <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	ff 75 10             	pushl  0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	52                   	push   %edx
  8014b4:	ff d0                	call   *%eax
  8014b6:	83 c4 10             	add    $0x10,%esp
}
  8014b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014be:	a1 20 60 80 00       	mov    0x806020,%eax
  8014c3:	8b 40 48             	mov    0x48(%eax),%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	53                   	push   %ebx
  8014ca:	50                   	push   %eax
  8014cb:	68 78 2c 80 00       	push   $0x802c78
  8014d0:	e8 5b ee ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dd:	eb da                	jmp    8014b9 <read+0x5a>
		return -E_NOT_SUPP;
  8014df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e4:	eb d3                	jmp    8014b9 <read+0x5a>

008014e6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	57                   	push   %edi
  8014ea:	56                   	push   %esi
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fa:	39 f3                	cmp    %esi,%ebx
  8014fc:	73 23                	jae    801521 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	89 f0                	mov    %esi,%eax
  801503:	29 d8                	sub    %ebx,%eax
  801505:	50                   	push   %eax
  801506:	89 d8                	mov    %ebx,%eax
  801508:	03 45 0c             	add    0xc(%ebp),%eax
  80150b:	50                   	push   %eax
  80150c:	57                   	push   %edi
  80150d:	e8 4d ff ff ff       	call   80145f <read>
		if (m < 0)
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	78 06                	js     80151f <readn+0x39>
			return m;
		if (m == 0)
  801519:	74 06                	je     801521 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80151b:	01 c3                	add    %eax,%ebx
  80151d:	eb db                	jmp    8014fa <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801521:	89 d8                	mov    %ebx,%eax
  801523:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801526:	5b                   	pop    %ebx
  801527:	5e                   	pop    %esi
  801528:	5f                   	pop    %edi
  801529:	5d                   	pop    %ebp
  80152a:	c3                   	ret    

0080152b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	53                   	push   %ebx
  80152f:	83 ec 1c             	sub    $0x1c,%esp
  801532:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801535:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801538:	50                   	push   %eax
  801539:	53                   	push   %ebx
  80153a:	e8 b0 fc ff ff       	call   8011ef <fd_lookup>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	85 c0                	test   %eax,%eax
  801544:	78 3a                	js     801580 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154c:	50                   	push   %eax
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	ff 30                	pushl  (%eax)
  801552:	e8 e8 fc ff ff       	call   80123f <dev_lookup>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 22                	js     801580 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801565:	74 1e                	je     801585 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156a:	8b 52 0c             	mov    0xc(%edx),%edx
  80156d:	85 d2                	test   %edx,%edx
  80156f:	74 35                	je     8015a6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801571:	83 ec 04             	sub    $0x4,%esp
  801574:	ff 75 10             	pushl  0x10(%ebp)
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	ff d2                	call   *%edx
  80157d:	83 c4 10             	add    $0x10,%esp
}
  801580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801583:	c9                   	leave  
  801584:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801585:	a1 20 60 80 00       	mov    0x806020,%eax
  80158a:	8b 40 48             	mov    0x48(%eax),%eax
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	53                   	push   %ebx
  801591:	50                   	push   %eax
  801592:	68 94 2c 80 00       	push   $0x802c94
  801597:	e8 94 ed ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a4:	eb da                	jmp    801580 <write+0x55>
		return -E_NOT_SUPP;
  8015a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ab:	eb d3                	jmp    801580 <write+0x55>

008015ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	ff 75 08             	pushl  0x8(%ebp)
  8015ba:	e8 30 fc ff ff       	call   8011ef <fd_lookup>
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	78 0e                	js     8015d4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 1c             	sub    $0x1c,%esp
  8015dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e3:	50                   	push   %eax
  8015e4:	53                   	push   %ebx
  8015e5:	e8 05 fc ff ff       	call   8011ef <fd_lookup>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 37                	js     801628 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f7:	50                   	push   %eax
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	ff 30                	pushl  (%eax)
  8015fd:	e8 3d fc ff ff       	call   80123f <dev_lookup>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	78 1f                	js     801628 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801610:	74 1b                	je     80162d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801615:	8b 52 18             	mov    0x18(%edx),%edx
  801618:	85 d2                	test   %edx,%edx
  80161a:	74 32                	je     80164e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	ff 75 0c             	pushl  0xc(%ebp)
  801622:	50                   	push   %eax
  801623:	ff d2                	call   *%edx
  801625:	83 c4 10             	add    $0x10,%esp
}
  801628:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80162d:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801632:	8b 40 48             	mov    0x48(%eax),%eax
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	53                   	push   %ebx
  801639:	50                   	push   %eax
  80163a:	68 54 2c 80 00       	push   $0x802c54
  80163f:	e8 ec ec ff ff       	call   800330 <cprintf>
		return -E_INVAL;
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164c:	eb da                	jmp    801628 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80164e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801653:	eb d3                	jmp    801628 <ftruncate+0x52>

00801655 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	53                   	push   %ebx
  801659:	83 ec 1c             	sub    $0x1c,%esp
  80165c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801662:	50                   	push   %eax
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 84 fb ff ff       	call   8011ef <fd_lookup>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 4b                	js     8016bd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	ff 30                	pushl  (%eax)
  80167e:	e8 bc fb ff ff       	call   80123f <dev_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 33                	js     8016bd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80168a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801691:	74 2f                	je     8016c2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801693:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801696:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80169d:	00 00 00 
	stat->st_isdir = 0;
  8016a0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a7:	00 00 00 
	stat->st_dev = dev;
  8016aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	53                   	push   %ebx
  8016b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b7:	ff 50 14             	call   *0x14(%eax)
  8016ba:	83 c4 10             	add    $0x10,%esp
}
  8016bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c7:	eb f4                	jmp    8016bd <fstat+0x68>

008016c9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016ce:	83 ec 08             	sub    $0x8,%esp
  8016d1:	6a 00                	push   $0x0
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	e8 22 02 00 00       	call   8018fd <open>
  8016db:	89 c3                	mov    %eax,%ebx
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 1b                	js     8016ff <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	50                   	push   %eax
  8016eb:	e8 65 ff ff ff       	call   801655 <fstat>
  8016f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f2:	89 1c 24             	mov    %ebx,(%esp)
  8016f5:	e8 27 fc ff ff       	call   801321 <close>
	return r;
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	89 f3                	mov    %esi,%ebx
}
  8016ff:	89 d8                	mov    %ebx,%eax
  801701:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801704:	5b                   	pop    %ebx
  801705:	5e                   	pop    %esi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	89 c6                	mov    %eax,%esi
  80170f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801711:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801718:	74 27                	je     801741 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80171a:	6a 07                	push   $0x7
  80171c:	68 00 70 80 00       	push   $0x807000
  801721:	56                   	push   %esi
  801722:	ff 35 00 40 80 00    	pushl  0x804000
  801728:	e8 1c 0d 00 00       	call   802449 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80172d:	83 c4 0c             	add    $0xc,%esp
  801730:	6a 00                	push   $0x0
  801732:	53                   	push   %ebx
  801733:	6a 00                	push   $0x0
  801735:	e8 a6 0c 00 00       	call   8023e0 <ipc_recv>
}
  80173a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5e                   	pop    %esi
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801741:	83 ec 0c             	sub    $0xc,%esp
  801744:	6a 01                	push   $0x1
  801746:	e8 56 0d 00 00       	call   8024a1 <ipc_find_env>
  80174b:	a3 00 40 80 00       	mov    %eax,0x804000
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	eb c5                	jmp    80171a <fsipc+0x12>

00801755 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 40 0c             	mov    0xc(%eax),%eax
  801761:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	b8 02 00 00 00       	mov    $0x2,%eax
  801778:	e8 8b ff ff ff       	call   801708 <fsipc>
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <devfile_flush>:
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8b 40 0c             	mov    0xc(%eax),%eax
  80178b:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801790:	ba 00 00 00 00       	mov    $0x0,%edx
  801795:	b8 06 00 00 00       	mov    $0x6,%eax
  80179a:	e8 69 ff ff ff       	call   801708 <fsipc>
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <devfile_stat>:
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	53                   	push   %ebx
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b1:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c0:	e8 43 ff ff ff       	call   801708 <fsipc>
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 2c                	js     8017f5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	68 00 70 80 00       	push   $0x807000
  8017d1:	53                   	push   %ebx
  8017d2:	e8 b8 f2 ff ff       	call   800a8f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017d7:	a1 80 70 80 00       	mov    0x807080,%eax
  8017dc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017e2:	a1 84 70 80 00       	mov    0x807084,%eax
  8017e7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <devfile_write>:
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8b 40 0c             	mov    0xc(%eax),%eax
  80180a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  80180f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801815:	53                   	push   %ebx
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	68 08 70 80 00       	push   $0x807008
  80181e:	e8 5c f4 ff ff       	call   800c7f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	b8 04 00 00 00       	mov    $0x4,%eax
  80182d:	e8 d6 fe ff ff       	call   801708 <fsipc>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	78 0b                	js     801844 <devfile_write+0x4a>
	assert(r <= n);
  801839:	39 d8                	cmp    %ebx,%eax
  80183b:	77 0c                	ja     801849 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80183d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801842:	7f 1e                	jg     801862 <devfile_write+0x68>
}
  801844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801847:	c9                   	leave  
  801848:	c3                   	ret    
	assert(r <= n);
  801849:	68 c8 2c 80 00       	push   $0x802cc8
  80184e:	68 cf 2c 80 00       	push   $0x802ccf
  801853:	68 98 00 00 00       	push   $0x98
  801858:	68 e4 2c 80 00       	push   $0x802ce4
  80185d:	e8 d8 e9 ff ff       	call   80023a <_panic>
	assert(r <= PGSIZE);
  801862:	68 ef 2c 80 00       	push   $0x802cef
  801867:	68 cf 2c 80 00       	push   $0x802ccf
  80186c:	68 99 00 00 00       	push   $0x99
  801871:	68 e4 2c 80 00       	push   $0x802ce4
  801876:	e8 bf e9 ff ff       	call   80023a <_panic>

0080187b <devfile_read>:
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 40 0c             	mov    0xc(%eax),%eax
  801889:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80188e:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801894:	ba 00 00 00 00       	mov    $0x0,%edx
  801899:	b8 03 00 00 00       	mov    $0x3,%eax
  80189e:	e8 65 fe ff ff       	call   801708 <fsipc>
  8018a3:	89 c3                	mov    %eax,%ebx
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 1f                	js     8018c8 <devfile_read+0x4d>
	assert(r <= n);
  8018a9:	39 f0                	cmp    %esi,%eax
  8018ab:	77 24                	ja     8018d1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ad:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b2:	7f 33                	jg     8018e7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	50                   	push   %eax
  8018b8:	68 00 70 80 00       	push   $0x807000
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	e8 58 f3 ff ff       	call   800c1d <memmove>
	return r;
  8018c5:	83 c4 10             	add    $0x10,%esp
}
  8018c8:	89 d8                	mov    %ebx,%eax
  8018ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018cd:	5b                   	pop    %ebx
  8018ce:	5e                   	pop    %esi
  8018cf:	5d                   	pop    %ebp
  8018d0:	c3                   	ret    
	assert(r <= n);
  8018d1:	68 c8 2c 80 00       	push   $0x802cc8
  8018d6:	68 cf 2c 80 00       	push   $0x802ccf
  8018db:	6a 7c                	push   $0x7c
  8018dd:	68 e4 2c 80 00       	push   $0x802ce4
  8018e2:	e8 53 e9 ff ff       	call   80023a <_panic>
	assert(r <= PGSIZE);
  8018e7:	68 ef 2c 80 00       	push   $0x802cef
  8018ec:	68 cf 2c 80 00       	push   $0x802ccf
  8018f1:	6a 7d                	push   $0x7d
  8018f3:	68 e4 2c 80 00       	push   $0x802ce4
  8018f8:	e8 3d e9 ff ff       	call   80023a <_panic>

008018fd <open>:
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 1c             	sub    $0x1c,%esp
  801905:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801908:	56                   	push   %esi
  801909:	e8 48 f1 ff ff       	call   800a56 <strlen>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801916:	7f 6c                	jg     801984 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191e:	50                   	push   %eax
  80191f:	e8 79 f8 ff ff       	call   80119d <fd_alloc>
  801924:	89 c3                	mov    %eax,%ebx
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 3c                	js     801969 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	56                   	push   %esi
  801931:	68 00 70 80 00       	push   $0x807000
  801936:	e8 54 f1 ff ff       	call   800a8f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801943:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801946:	b8 01 00 00 00       	mov    $0x1,%eax
  80194b:	e8 b8 fd ff ff       	call   801708 <fsipc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 19                	js     801972 <open+0x75>
	return fd2num(fd);
  801959:	83 ec 0c             	sub    $0xc,%esp
  80195c:	ff 75 f4             	pushl  -0xc(%ebp)
  80195f:	e8 12 f8 ff ff       	call   801176 <fd2num>
  801964:	89 c3                	mov    %eax,%ebx
  801966:	83 c4 10             	add    $0x10,%esp
}
  801969:	89 d8                	mov    %ebx,%eax
  80196b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    
		fd_close(fd, 0);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	6a 00                	push   $0x0
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	e8 1b f9 ff ff       	call   80129a <fd_close>
		return r;
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	eb e5                	jmp    801969 <open+0x6c>
		return -E_BAD_PATH;
  801984:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801989:	eb de                	jmp    801969 <open+0x6c>

0080198b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801991:	ba 00 00 00 00       	mov    $0x0,%edx
  801996:	b8 08 00 00 00       	mov    $0x8,%eax
  80199b:	e8 68 fd ff ff       	call   801708 <fsipc>
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019a2:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019a6:	7f 01                	jg     8019a9 <writebuf+0x7>
  8019a8:	c3                   	ret    
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	53                   	push   %ebx
  8019ad:	83 ec 08             	sub    $0x8,%esp
  8019b0:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019b2:	ff 70 04             	pushl  0x4(%eax)
  8019b5:	8d 40 10             	lea    0x10(%eax),%eax
  8019b8:	50                   	push   %eax
  8019b9:	ff 33                	pushl  (%ebx)
  8019bb:	e8 6b fb ff ff       	call   80152b <write>
		if (result > 0)
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	7e 03                	jle    8019ca <writebuf+0x28>
			b->result += result;
  8019c7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019ca:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019cd:	74 0d                	je     8019dc <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d6:	0f 4f c2             	cmovg  %edx,%eax
  8019d9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <putch>:

static void
putch(int ch, void *thunk)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	53                   	push   %ebx
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019eb:	8b 53 04             	mov    0x4(%ebx),%edx
  8019ee:	8d 42 01             	lea    0x1(%edx),%eax
  8019f1:	89 43 04             	mov    %eax,0x4(%ebx)
  8019f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f7:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019fb:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a00:	74 06                	je     801a08 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a02:	83 c4 04             	add    $0x4,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
		writebuf(b);
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	e8 93 ff ff ff       	call   8019a2 <writebuf>
		b->idx = 0;
  801a0f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a16:	eb ea                	jmp    801a02 <putch+0x21>

00801a18 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a2a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a31:	00 00 00 
	b.result = 0;
  801a34:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a3b:	00 00 00 
	b.error = 1;
  801a3e:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a45:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a54:	50                   	push   %eax
  801a55:	68 e1 19 80 00       	push   $0x8019e1
  801a5a:	e8 fe e9 ff ff       	call   80045d <vprintfmt>
	if (b.idx > 0)
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a69:	7f 11                	jg     801a7c <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a6b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a71:	85 c0                	test   %eax,%eax
  801a73:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    
		writebuf(&b);
  801a7c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a82:	e8 1b ff ff ff       	call   8019a2 <writebuf>
  801a87:	eb e2                	jmp    801a6b <vfprintf+0x53>

00801a89 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a8f:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a92:	50                   	push   %eax
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	ff 75 08             	pushl  0x8(%ebp)
  801a99:	e8 7a ff ff ff       	call   801a18 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <printf>:

int
printf(const char *fmt, ...)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aa6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	6a 01                	push   $0x1
  801aaf:	e8 64 ff ff ff       	call   801a18 <vfprintf>
	va_end(ap);

	return cnt;
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801abc:	68 fb 2c 80 00       	push   $0x802cfb
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	e8 c6 ef ff ff       	call   800a8f <strcpy>
	return 0;
}
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <devsock_close>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 10             	sub    $0x10,%esp
  801ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ada:	53                   	push   %ebx
  801adb:	e8 fc 09 00 00       	call   8024dc <pageref>
  801ae0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ae3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ae8:	83 f8 01             	cmp    $0x1,%eax
  801aeb:	74 07                	je     801af4 <devsock_close+0x24>
}
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	ff 73 0c             	pushl  0xc(%ebx)
  801afa:	e8 b9 02 00 00       	call   801db8 <nsipc_close>
  801aff:	89 c2                	mov    %eax,%edx
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	eb e7                	jmp    801aed <devsock_close+0x1d>

00801b06 <devsock_write>:
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	ff 75 10             	pushl  0x10(%ebp)
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	ff 70 0c             	pushl  0xc(%eax)
  801b1a:	e8 76 03 00 00       	call   801e95 <nsipc_send>
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <devsock_read>:
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	ff 75 10             	pushl  0x10(%ebp)
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	ff 70 0c             	pushl  0xc(%eax)
  801b35:	e8 ef 02 00 00       	call   801e29 <nsipc_recv>
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <fd2sockid>:
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b42:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	e8 a3 f6 ff ff       	call   8011ef <fd_lookup>
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	78 10                	js     801b63 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b56:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b5c:	39 08                	cmp    %ecx,(%eax)
  801b5e:	75 05                	jne    801b65 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b60:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    
		return -E_NOT_SUPP;
  801b65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6a:	eb f7                	jmp    801b63 <fd2sockid+0x27>

00801b6c <alloc_sockfd>:
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	56                   	push   %esi
  801b70:	53                   	push   %ebx
  801b71:	83 ec 1c             	sub    $0x1c,%esp
  801b74:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b79:	50                   	push   %eax
  801b7a:	e8 1e f6 ff ff       	call   80119d <fd_alloc>
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 43                	js     801bcb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 07 04 00 00       	push   $0x407
  801b90:	ff 75 f4             	pushl  -0xc(%ebp)
  801b93:	6a 00                	push   $0x0
  801b95:	e8 e7 f2 ff ff       	call   800e81 <sys_page_alloc>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 28                	js     801bcb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bb8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	50                   	push   %eax
  801bbf:	e8 b2 f5 ff ff       	call   801176 <fd2num>
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	eb 0c                	jmp    801bd7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	56                   	push   %esi
  801bcf:	e8 e4 01 00 00       	call   801db8 <nsipc_close>
		return r;
  801bd4:	83 c4 10             	add    $0x10,%esp
}
  801bd7:	89 d8                	mov    %ebx,%eax
  801bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <accept>:
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	e8 4e ff ff ff       	call   801b3c <fd2sockid>
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 1b                	js     801c0d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	ff 75 10             	pushl  0x10(%ebp)
  801bf8:	ff 75 0c             	pushl  0xc(%ebp)
  801bfb:	50                   	push   %eax
  801bfc:	e8 0e 01 00 00       	call   801d0f <nsipc_accept>
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	85 c0                	test   %eax,%eax
  801c06:	78 05                	js     801c0d <accept+0x2d>
	return alloc_sockfd(r);
  801c08:	e8 5f ff ff ff       	call   801b6c <alloc_sockfd>
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <bind>:
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	e8 1f ff ff ff       	call   801b3c <fd2sockid>
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	78 12                	js     801c33 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	50                   	push   %eax
  801c2b:	e8 31 01 00 00       	call   801d61 <nsipc_bind>
  801c30:	83 c4 10             	add    $0x10,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <shutdown>:
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	e8 f9 fe ff ff       	call   801b3c <fd2sockid>
  801c43:	85 c0                	test   %eax,%eax
  801c45:	78 0f                	js     801c56 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c47:	83 ec 08             	sub    $0x8,%esp
  801c4a:	ff 75 0c             	pushl  0xc(%ebp)
  801c4d:	50                   	push   %eax
  801c4e:	e8 43 01 00 00       	call   801d96 <nsipc_shutdown>
  801c53:	83 c4 10             	add    $0x10,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <connect>:
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	e8 d6 fe ff ff       	call   801b3c <fd2sockid>
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 12                	js     801c7c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	ff 75 10             	pushl  0x10(%ebp)
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	50                   	push   %eax
  801c74:	e8 59 01 00 00       	call   801dd2 <nsipc_connect>
  801c79:	83 c4 10             	add    $0x10,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <listen>:
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	e8 b0 fe ff ff       	call   801b3c <fd2sockid>
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 0f                	js     801c9f <listen+0x21>
	return nsipc_listen(r, backlog);
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	50                   	push   %eax
  801c97:	e8 6b 01 00 00       	call   801e07 <nsipc_listen>
  801c9c:	83 c4 10             	add    $0x10,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ca7:	ff 75 10             	pushl  0x10(%ebp)
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	ff 75 08             	pushl  0x8(%ebp)
  801cb0:	e8 3e 02 00 00       	call   801ef3 <nsipc_socket>
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 05                	js     801cc1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cbc:	e8 ab fe ff ff       	call   801b6c <alloc_sockfd>
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ccc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cd3:	74 26                	je     801cfb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cd5:	6a 07                	push   $0x7
  801cd7:	68 00 80 80 00       	push   $0x808000
  801cdc:	53                   	push   %ebx
  801cdd:	ff 35 04 40 80 00    	pushl  0x804004
  801ce3:	e8 61 07 00 00       	call   802449 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ce8:	83 c4 0c             	add    $0xc,%esp
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	e8 ea 06 00 00       	call   8023e0 <ipc_recv>
}
  801cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	6a 02                	push   $0x2
  801d00:	e8 9c 07 00 00       	call   8024a1 <ipc_find_env>
  801d05:	a3 04 40 80 00       	mov    %eax,0x804004
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	eb c6                	jmp    801cd5 <nsipc+0x12>

00801d0f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d1f:	8b 06                	mov    (%esi),%eax
  801d21:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d26:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2b:	e8 93 ff ff ff       	call   801cc3 <nsipc>
  801d30:	89 c3                	mov    %eax,%ebx
  801d32:	85 c0                	test   %eax,%eax
  801d34:	79 09                	jns    801d3f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d36:	89 d8                	mov    %ebx,%eax
  801d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	ff 35 10 80 80 00    	pushl  0x808010
  801d48:	68 00 80 80 00       	push   $0x808000
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	e8 c8 ee ff ff       	call   800c1d <memmove>
		*addrlen = ret->ret_addrlen;
  801d55:	a1 10 80 80 00       	mov    0x808010,%eax
  801d5a:	89 06                	mov    %eax,(%esi)
  801d5c:	83 c4 10             	add    $0x10,%esp
	return r;
  801d5f:	eb d5                	jmp    801d36 <nsipc_accept+0x27>

00801d61 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	53                   	push   %ebx
  801d65:	83 ec 08             	sub    $0x8,%esp
  801d68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d73:	53                   	push   %ebx
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	68 04 80 80 00       	push   $0x808004
  801d7c:	e8 9c ee ff ff       	call   800c1d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d81:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801d87:	b8 02 00 00 00       	mov    $0x2,%eax
  801d8c:	e8 32 ff ff ff       	call   801cc3 <nsipc>
}
  801d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da7:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801dac:	b8 03 00 00 00       	mov    $0x3,%eax
  801db1:	e8 0d ff ff ff       	call   801cc3 <nsipc>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <nsipc_close>:

int
nsipc_close(int s)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801dc6:	b8 04 00 00 00       	mov    $0x4,%eax
  801dcb:	e8 f3 fe ff ff       	call   801cc3 <nsipc>
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	53                   	push   %ebx
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801de4:	53                   	push   %ebx
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	68 04 80 80 00       	push   $0x808004
  801ded:	e8 2b ee ff ff       	call   800c1d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801df2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801df8:	b8 05 00 00 00       	mov    $0x5,%eax
  801dfd:	e8 c1 fe ff ff       	call   801cc3 <nsipc>
}
  801e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e18:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801e1d:	b8 06 00 00 00       	mov    $0x6,%eax
  801e22:	e8 9c fe ff ff       	call   801cc3 <nsipc>
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801e39:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e42:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e47:	b8 07 00 00 00       	mov    $0x7,%eax
  801e4c:	e8 72 fe ff ff       	call   801cc3 <nsipc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	85 c0                	test   %eax,%eax
  801e55:	78 1f                	js     801e76 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e57:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e5c:	7f 21                	jg     801e7f <nsipc_recv+0x56>
  801e5e:	39 c6                	cmp    %eax,%esi
  801e60:	7c 1d                	jl     801e7f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	50                   	push   %eax
  801e66:	68 00 80 80 00       	push   $0x808000
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	e8 aa ed ff ff       	call   800c1d <memmove>
  801e73:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e76:	89 d8                	mov    %ebx,%eax
  801e78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e7f:	68 07 2d 80 00       	push   $0x802d07
  801e84:	68 cf 2c 80 00       	push   $0x802ccf
  801e89:	6a 62                	push   $0x62
  801e8b:	68 1c 2d 80 00       	push   $0x802d1c
  801e90:	e8 a5 e3 ff ff       	call   80023a <_panic>

00801e95 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	53                   	push   %ebx
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801ea7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ead:	7f 2e                	jg     801edd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	53                   	push   %ebx
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	68 0c 80 80 00       	push   $0x80800c
  801ebb:	e8 5d ed ff ff       	call   800c1d <memmove>
	nsipcbuf.send.req_size = size;
  801ec0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801ece:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed3:	e8 eb fd ff ff       	call   801cc3 <nsipc>
}
  801ed8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    
	assert(size < 1600);
  801edd:	68 28 2d 80 00       	push   $0x802d28
  801ee2:	68 cf 2c 80 00       	push   $0x802ccf
  801ee7:	6a 6d                	push   $0x6d
  801ee9:	68 1c 2d 80 00       	push   $0x802d1c
  801eee:	e8 47 e3 ff ff       	call   80023a <_panic>

00801ef3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f04:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801f09:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0c:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801f11:	b8 09 00 00 00       	mov    $0x9,%eax
  801f16:	e8 a8 fd ff ff       	call   801cc3 <nsipc>
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	56                   	push   %esi
  801f21:	53                   	push   %ebx
  801f22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	ff 75 08             	pushl  0x8(%ebp)
  801f2b:	e8 56 f2 ff ff       	call   801186 <fd2data>
  801f30:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f32:	83 c4 08             	add    $0x8,%esp
  801f35:	68 34 2d 80 00       	push   $0x802d34
  801f3a:	53                   	push   %ebx
  801f3b:	e8 4f eb ff ff       	call   800a8f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f40:	8b 46 04             	mov    0x4(%esi),%eax
  801f43:	2b 06                	sub    (%esi),%eax
  801f45:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f52:	00 00 00 
	stat->st_dev = &devpipe;
  801f55:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f5c:	30 80 00 
	return 0;
}
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	53                   	push   %ebx
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f75:	53                   	push   %ebx
  801f76:	6a 00                	push   $0x0
  801f78:	e8 89 ef ff ff       	call   800f06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f7d:	89 1c 24             	mov    %ebx,(%esp)
  801f80:	e8 01 f2 ff ff       	call   801186 <fd2data>
  801f85:	83 c4 08             	add    $0x8,%esp
  801f88:	50                   	push   %eax
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 76 ef ff ff       	call   800f06 <sys_page_unmap>
}
  801f90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <_pipeisclosed>:
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	57                   	push   %edi
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 1c             	sub    $0x1c,%esp
  801f9e:	89 c7                	mov    %eax,%edi
  801fa0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fa2:	a1 20 60 80 00       	mov    0x806020,%eax
  801fa7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	57                   	push   %edi
  801fae:	e8 29 05 00 00       	call   8024dc <pageref>
  801fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fb6:	89 34 24             	mov    %esi,(%esp)
  801fb9:	e8 1e 05 00 00       	call   8024dc <pageref>
		nn = thisenv->env_runs;
  801fbe:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801fc4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	39 cb                	cmp    %ecx,%ebx
  801fcc:	74 1b                	je     801fe9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fd1:	75 cf                	jne    801fa2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fd3:	8b 42 58             	mov    0x58(%edx),%eax
  801fd6:	6a 01                	push   $0x1
  801fd8:	50                   	push   %eax
  801fd9:	53                   	push   %ebx
  801fda:	68 3b 2d 80 00       	push   $0x802d3b
  801fdf:	e8 4c e3 ff ff       	call   800330 <cprintf>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	eb b9                	jmp    801fa2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fe9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fec:	0f 94 c0             	sete   %al
  801fef:	0f b6 c0             	movzbl %al,%eax
}
  801ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5f                   	pop    %edi
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <devpipe_write>:
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	57                   	push   %edi
  801ffe:	56                   	push   %esi
  801fff:	53                   	push   %ebx
  802000:	83 ec 28             	sub    $0x28,%esp
  802003:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802006:	56                   	push   %esi
  802007:	e8 7a f1 ff ff       	call   801186 <fd2data>
  80200c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	bf 00 00 00 00       	mov    $0x0,%edi
  802016:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802019:	74 4f                	je     80206a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80201b:	8b 43 04             	mov    0x4(%ebx),%eax
  80201e:	8b 0b                	mov    (%ebx),%ecx
  802020:	8d 51 20             	lea    0x20(%ecx),%edx
  802023:	39 d0                	cmp    %edx,%eax
  802025:	72 14                	jb     80203b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802027:	89 da                	mov    %ebx,%edx
  802029:	89 f0                	mov    %esi,%eax
  80202b:	e8 65 ff ff ff       	call   801f95 <_pipeisclosed>
  802030:	85 c0                	test   %eax,%eax
  802032:	75 3b                	jne    80206f <devpipe_write+0x75>
			sys_yield();
  802034:	e8 29 ee ff ff       	call   800e62 <sys_yield>
  802039:	eb e0                	jmp    80201b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80203b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802042:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802045:	89 c2                	mov    %eax,%edx
  802047:	c1 fa 1f             	sar    $0x1f,%edx
  80204a:	89 d1                	mov    %edx,%ecx
  80204c:	c1 e9 1b             	shr    $0x1b,%ecx
  80204f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802052:	83 e2 1f             	and    $0x1f,%edx
  802055:	29 ca                	sub    %ecx,%edx
  802057:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80205b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80205f:	83 c0 01             	add    $0x1,%eax
  802062:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802065:	83 c7 01             	add    $0x1,%edi
  802068:	eb ac                	jmp    802016 <devpipe_write+0x1c>
	return i;
  80206a:	8b 45 10             	mov    0x10(%ebp),%eax
  80206d:	eb 05                	jmp    802074 <devpipe_write+0x7a>
				return 0;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802074:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <devpipe_read>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	57                   	push   %edi
  802080:	56                   	push   %esi
  802081:	53                   	push   %ebx
  802082:	83 ec 18             	sub    $0x18,%esp
  802085:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802088:	57                   	push   %edi
  802089:	e8 f8 f0 ff ff       	call   801186 <fd2data>
  80208e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	be 00 00 00 00       	mov    $0x0,%esi
  802098:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209b:	75 14                	jne    8020b1 <devpipe_read+0x35>
	return i;
  80209d:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a0:	eb 02                	jmp    8020a4 <devpipe_read+0x28>
				return i;
  8020a2:	89 f0                	mov    %esi,%eax
}
  8020a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
			sys_yield();
  8020ac:	e8 b1 ed ff ff       	call   800e62 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020b1:	8b 03                	mov    (%ebx),%eax
  8020b3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b6:	75 18                	jne    8020d0 <devpipe_read+0x54>
			if (i > 0)
  8020b8:	85 f6                	test   %esi,%esi
  8020ba:	75 e6                	jne    8020a2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8020bc:	89 da                	mov    %ebx,%edx
  8020be:	89 f8                	mov    %edi,%eax
  8020c0:	e8 d0 fe ff ff       	call   801f95 <_pipeisclosed>
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	74 e3                	je     8020ac <devpipe_read+0x30>
				return 0;
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ce:	eb d4                	jmp    8020a4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020d0:	99                   	cltd   
  8020d1:	c1 ea 1b             	shr    $0x1b,%edx
  8020d4:	01 d0                	add    %edx,%eax
  8020d6:	83 e0 1f             	and    $0x1f,%eax
  8020d9:	29 d0                	sub    %edx,%eax
  8020db:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020e6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020e9:	83 c6 01             	add    $0x1,%esi
  8020ec:	eb aa                	jmp    802098 <devpipe_read+0x1c>

008020ee <pipe>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	56                   	push   %esi
  8020f2:	53                   	push   %ebx
  8020f3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f9:	50                   	push   %eax
  8020fa:	e8 9e f0 ff ff       	call   80119d <fd_alloc>
  8020ff:	89 c3                	mov    %eax,%ebx
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	85 c0                	test   %eax,%eax
  802106:	0f 88 23 01 00 00    	js     80222f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 07 04 00 00       	push   $0x407
  802114:	ff 75 f4             	pushl  -0xc(%ebp)
  802117:	6a 00                	push   $0x0
  802119:	e8 63 ed ff ff       	call   800e81 <sys_page_alloc>
  80211e:	89 c3                	mov    %eax,%ebx
  802120:	83 c4 10             	add    $0x10,%esp
  802123:	85 c0                	test   %eax,%eax
  802125:	0f 88 04 01 00 00    	js     80222f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802131:	50                   	push   %eax
  802132:	e8 66 f0 ff ff       	call   80119d <fd_alloc>
  802137:	89 c3                	mov    %eax,%ebx
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	85 c0                	test   %eax,%eax
  80213e:	0f 88 db 00 00 00    	js     80221f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 07 04 00 00       	push   $0x407
  80214c:	ff 75 f0             	pushl  -0x10(%ebp)
  80214f:	6a 00                	push   $0x0
  802151:	e8 2b ed ff ff       	call   800e81 <sys_page_alloc>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	0f 88 bc 00 00 00    	js     80221f <pipe+0x131>
	va = fd2data(fd0);
  802163:	83 ec 0c             	sub    $0xc,%esp
  802166:	ff 75 f4             	pushl  -0xc(%ebp)
  802169:	e8 18 f0 ff ff       	call   801186 <fd2data>
  80216e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802170:	83 c4 0c             	add    $0xc,%esp
  802173:	68 07 04 00 00       	push   $0x407
  802178:	50                   	push   %eax
  802179:	6a 00                	push   $0x0
  80217b:	e8 01 ed ff ff       	call   800e81 <sys_page_alloc>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	0f 88 82 00 00 00    	js     80220f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	ff 75 f0             	pushl  -0x10(%ebp)
  802193:	e8 ee ef ff ff       	call   801186 <fd2data>
  802198:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80219f:	50                   	push   %eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	56                   	push   %esi
  8021a3:	6a 00                	push   $0x0
  8021a5:	e8 1a ed ff ff       	call   800ec4 <sys_page_map>
  8021aa:	89 c3                	mov    %eax,%ebx
  8021ac:	83 c4 20             	add    $0x20,%esp
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	78 4e                	js     802201 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8021b3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ca:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021dc:	e8 95 ef ff ff       	call   801176 <fd2num>
  8021e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021e6:	83 c4 04             	add    $0x4,%esp
  8021e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8021ec:	e8 85 ef ff ff       	call   801176 <fd2num>
  8021f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021f4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021f7:	83 c4 10             	add    $0x10,%esp
  8021fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021ff:	eb 2e                	jmp    80222f <pipe+0x141>
	sys_page_unmap(0, va);
  802201:	83 ec 08             	sub    $0x8,%esp
  802204:	56                   	push   %esi
  802205:	6a 00                	push   $0x0
  802207:	e8 fa ec ff ff       	call   800f06 <sys_page_unmap>
  80220c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80220f:	83 ec 08             	sub    $0x8,%esp
  802212:	ff 75 f0             	pushl  -0x10(%ebp)
  802215:	6a 00                	push   $0x0
  802217:	e8 ea ec ff ff       	call   800f06 <sys_page_unmap>
  80221c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80221f:	83 ec 08             	sub    $0x8,%esp
  802222:	ff 75 f4             	pushl  -0xc(%ebp)
  802225:	6a 00                	push   $0x0
  802227:	e8 da ec ff ff       	call   800f06 <sys_page_unmap>
  80222c:	83 c4 10             	add    $0x10,%esp
}
  80222f:	89 d8                	mov    %ebx,%eax
  802231:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    

00802238 <pipeisclosed>:
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80223e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802241:	50                   	push   %eax
  802242:	ff 75 08             	pushl  0x8(%ebp)
  802245:	e8 a5 ef ff ff       	call   8011ef <fd_lookup>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 18                	js     802269 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802251:	83 ec 0c             	sub    $0xc,%esp
  802254:	ff 75 f4             	pushl  -0xc(%ebp)
  802257:	e8 2a ef ff ff       	call   801186 <fd2data>
	return _pipeisclosed(fd, p);
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	e8 2f fd ff ff       	call   801f95 <_pipeisclosed>
  802266:	83 c4 10             	add    $0x10,%esp
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	c3                   	ret    

00802271 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802277:	68 53 2d 80 00       	push   $0x802d53
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	e8 0b e8 ff ff       	call   800a8f <strcpy>
	return 0;
}
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <devcons_write>:
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	57                   	push   %edi
  80228f:	56                   	push   %esi
  802290:	53                   	push   %ebx
  802291:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802297:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80229c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022a2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a5:	73 31                	jae    8022d8 <devcons_write+0x4d>
		m = n - tot;
  8022a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022aa:	29 f3                	sub    %esi,%ebx
  8022ac:	83 fb 7f             	cmp    $0x7f,%ebx
  8022af:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022b4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	53                   	push   %ebx
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	03 45 0c             	add    0xc(%ebp),%eax
  8022c0:	50                   	push   %eax
  8022c1:	57                   	push   %edi
  8022c2:	e8 56 e9 ff ff       	call   800c1d <memmove>
		sys_cputs(buf, m);
  8022c7:	83 c4 08             	add    $0x8,%esp
  8022ca:	53                   	push   %ebx
  8022cb:	57                   	push   %edi
  8022cc:	e8 f4 ea ff ff       	call   800dc5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022d1:	01 de                	add    %ebx,%esi
  8022d3:	83 c4 10             	add    $0x10,%esp
  8022d6:	eb ca                	jmp    8022a2 <devcons_write+0x17>
}
  8022d8:	89 f0                	mov    %esi,%eax
  8022da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <devcons_read>:
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 08             	sub    $0x8,%esp
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f1:	74 21                	je     802314 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022f3:	e8 eb ea ff ff       	call   800de3 <sys_cgetc>
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	75 07                	jne    802303 <devcons_read+0x21>
		sys_yield();
  8022fc:	e8 61 eb ff ff       	call   800e62 <sys_yield>
  802301:	eb f0                	jmp    8022f3 <devcons_read+0x11>
	if (c < 0)
  802303:	78 0f                	js     802314 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802305:	83 f8 04             	cmp    $0x4,%eax
  802308:	74 0c                	je     802316 <devcons_read+0x34>
	*(char*)vbuf = c;
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	88 02                	mov    %al,(%edx)
	return 1;
  80230f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    
		return 0;
  802316:	b8 00 00 00 00       	mov    $0x0,%eax
  80231b:	eb f7                	jmp    802314 <devcons_read+0x32>

0080231d <cputchar>:
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802329:	6a 01                	push   $0x1
  80232b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80232e:	50                   	push   %eax
  80232f:	e8 91 ea ff ff       	call   800dc5 <sys_cputs>
}
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <getchar>:
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80233f:	6a 01                	push   $0x1
  802341:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802344:	50                   	push   %eax
  802345:	6a 00                	push   $0x0
  802347:	e8 13 f1 ff ff       	call   80145f <read>
	if (r < 0)
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 06                	js     802359 <getchar+0x20>
	if (r < 1)
  802353:	74 06                	je     80235b <getchar+0x22>
	return c;
  802355:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    
		return -E_EOF;
  80235b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802360:	eb f7                	jmp    802359 <getchar+0x20>

00802362 <iscons>:
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236b:	50                   	push   %eax
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	e8 7b ee ff ff       	call   8011ef <fd_lookup>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	85 c0                	test   %eax,%eax
  802379:	78 11                	js     80238c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802384:	39 10                	cmp    %edx,(%eax)
  802386:	0f 94 c0             	sete   %al
  802389:	0f b6 c0             	movzbl %al,%eax
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <opencons>:
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802397:	50                   	push   %eax
  802398:	e8 00 ee ff ff       	call   80119d <fd_alloc>
  80239d:	83 c4 10             	add    $0x10,%esp
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	78 3a                	js     8023de <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	68 07 04 00 00       	push   $0x407
  8023ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8023af:	6a 00                	push   $0x0
  8023b1:	e8 cb ea ff ff       	call   800e81 <sys_page_alloc>
  8023b6:	83 c4 10             	add    $0x10,%esp
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	78 21                	js     8023de <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023d2:	83 ec 0c             	sub    $0xc,%esp
  8023d5:	50                   	push   %eax
  8023d6:	e8 9b ed ff ff       	call   801176 <fd2num>
  8023db:	83 c4 10             	add    $0x10,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	56                   	push   %esi
  8023e4:	53                   	push   %ebx
  8023e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8023ee:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023f0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023f5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023f8:	83 ec 0c             	sub    $0xc,%esp
  8023fb:	50                   	push   %eax
  8023fc:	e8 30 ec ff ff       	call   801031 <sys_ipc_recv>
	if(ret < 0){
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	85 c0                	test   %eax,%eax
  802406:	78 2b                	js     802433 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802408:	85 f6                	test   %esi,%esi
  80240a:	74 0a                	je     802416 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80240c:	a1 20 60 80 00       	mov    0x806020,%eax
  802411:	8b 40 74             	mov    0x74(%eax),%eax
  802414:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802416:	85 db                	test   %ebx,%ebx
  802418:	74 0a                	je     802424 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80241a:	a1 20 60 80 00       	mov    0x806020,%eax
  80241f:	8b 40 78             	mov    0x78(%eax),%eax
  802422:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802424:	a1 20 60 80 00       	mov    0x806020,%eax
  802429:	8b 40 70             	mov    0x70(%eax),%eax
}
  80242c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242f:	5b                   	pop    %ebx
  802430:	5e                   	pop    %esi
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    
		if(from_env_store)
  802433:	85 f6                	test   %esi,%esi
  802435:	74 06                	je     80243d <ipc_recv+0x5d>
			*from_env_store = 0;
  802437:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80243d:	85 db                	test   %ebx,%ebx
  80243f:	74 eb                	je     80242c <ipc_recv+0x4c>
			*perm_store = 0;
  802441:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802447:	eb e3                	jmp    80242c <ipc_recv+0x4c>

00802449 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	57                   	push   %edi
  80244d:	56                   	push   %esi
  80244e:	53                   	push   %ebx
  80244f:	83 ec 0c             	sub    $0xc,%esp
  802452:	8b 7d 08             	mov    0x8(%ebp),%edi
  802455:	8b 75 0c             	mov    0xc(%ebp),%esi
  802458:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80245b:	85 db                	test   %ebx,%ebx
  80245d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802462:	0f 44 d8             	cmove  %eax,%ebx
  802465:	eb 05                	jmp    80246c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802467:	e8 f6 e9 ff ff       	call   800e62 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80246c:	ff 75 14             	pushl  0x14(%ebp)
  80246f:	53                   	push   %ebx
  802470:	56                   	push   %esi
  802471:	57                   	push   %edi
  802472:	e8 97 eb ff ff       	call   80100e <sys_ipc_try_send>
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 1b                	je     802499 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80247e:	79 e7                	jns    802467 <ipc_send+0x1e>
  802480:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802483:	74 e2                	je     802467 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	68 5f 2d 80 00       	push   $0x802d5f
  80248d:	6a 46                	push   $0x46
  80248f:	68 74 2d 80 00       	push   $0x802d74
  802494:	e8 a1 dd ff ff       	call   80023a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802499:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    

008024a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024ac:	89 c2                	mov    %eax,%edx
  8024ae:	c1 e2 07             	shl    $0x7,%edx
  8024b1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024b7:	8b 52 50             	mov    0x50(%edx),%edx
  8024ba:	39 ca                	cmp    %ecx,%edx
  8024bc:	74 11                	je     8024cf <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8024be:	83 c0 01             	add    $0x1,%eax
  8024c1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024c6:	75 e4                	jne    8024ac <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	eb 0b                	jmp    8024da <ipc_find_env+0x39>
			return envs[i].env_id;
  8024cf:	c1 e0 07             	shl    $0x7,%eax
  8024d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024d7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    

008024dc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024e2:	89 d0                	mov    %edx,%eax
  8024e4:	c1 e8 16             	shr    $0x16,%eax
  8024e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024f3:	f6 c1 01             	test   $0x1,%cl
  8024f6:	74 1d                	je     802515 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024f8:	c1 ea 0c             	shr    $0xc,%edx
  8024fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802502:	f6 c2 01             	test   $0x1,%dl
  802505:	74 0e                	je     802515 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802507:	c1 ea 0c             	shr    $0xc,%edx
  80250a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802511:	ef 
  802512:	0f b7 c0             	movzwl %ax,%eax
}
  802515:	5d                   	pop    %ebp
  802516:	c3                   	ret    
  802517:	66 90                	xchg   %ax,%ax
  802519:	66 90                	xchg   %ax,%ax
  80251b:	66 90                	xchg   %ax,%ax
  80251d:	66 90                	xchg   %ax,%ax
  80251f:	90                   	nop

00802520 <__udivdi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	53                   	push   %ebx
  802524:	83 ec 1c             	sub    $0x1c,%esp
  802527:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80252b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80252f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802533:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802537:	85 d2                	test   %edx,%edx
  802539:	75 4d                	jne    802588 <__udivdi3+0x68>
  80253b:	39 f3                	cmp    %esi,%ebx
  80253d:	76 19                	jbe    802558 <__udivdi3+0x38>
  80253f:	31 ff                	xor    %edi,%edi
  802541:	89 e8                	mov    %ebp,%eax
  802543:	89 f2                	mov    %esi,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 fa                	mov    %edi,%edx
  802549:	83 c4 1c             	add    $0x1c,%esp
  80254c:	5b                   	pop    %ebx
  80254d:	5e                   	pop    %esi
  80254e:	5f                   	pop    %edi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
  802551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802558:	89 d9                	mov    %ebx,%ecx
  80255a:	85 db                	test   %ebx,%ebx
  80255c:	75 0b                	jne    802569 <__udivdi3+0x49>
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	31 d2                	xor    %edx,%edx
  802565:	f7 f3                	div    %ebx
  802567:	89 c1                	mov    %eax,%ecx
  802569:	31 d2                	xor    %edx,%edx
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	f7 f1                	div    %ecx
  80256f:	89 c6                	mov    %eax,%esi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f7                	mov    %esi,%edi
  802575:	f7 f1                	div    %ecx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	39 f2                	cmp    %esi,%edx
  80258a:	77 1c                	ja     8025a8 <__udivdi3+0x88>
  80258c:	0f bd fa             	bsr    %edx,%edi
  80258f:	83 f7 1f             	xor    $0x1f,%edi
  802592:	75 2c                	jne    8025c0 <__udivdi3+0xa0>
  802594:	39 f2                	cmp    %esi,%edx
  802596:	72 06                	jb     80259e <__udivdi3+0x7e>
  802598:	31 c0                	xor    %eax,%eax
  80259a:	39 eb                	cmp    %ebp,%ebx
  80259c:	77 a9                	ja     802547 <__udivdi3+0x27>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	eb a2                	jmp    802547 <__udivdi3+0x27>
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	31 ff                	xor    %edi,%edi
  8025aa:	31 c0                	xor    %eax,%eax
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	89 f9                	mov    %edi,%ecx
  8025c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025c7:	29 f8                	sub    %edi,%eax
  8025c9:	d3 e2                	shl    %cl,%edx
  8025cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025cf:	89 c1                	mov    %eax,%ecx
  8025d1:	89 da                	mov    %ebx,%edx
  8025d3:	d3 ea                	shr    %cl,%edx
  8025d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025d9:	09 d1                	or     %edx,%ecx
  8025db:	89 f2                	mov    %esi,%edx
  8025dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e1:	89 f9                	mov    %edi,%ecx
  8025e3:	d3 e3                	shl    %cl,%ebx
  8025e5:	89 c1                	mov    %eax,%ecx
  8025e7:	d3 ea                	shr    %cl,%edx
  8025e9:	89 f9                	mov    %edi,%ecx
  8025eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025ef:	89 eb                	mov    %ebp,%ebx
  8025f1:	d3 e6                	shl    %cl,%esi
  8025f3:	89 c1                	mov    %eax,%ecx
  8025f5:	d3 eb                	shr    %cl,%ebx
  8025f7:	09 de                	or     %ebx,%esi
  8025f9:	89 f0                	mov    %esi,%eax
  8025fb:	f7 74 24 08          	divl   0x8(%esp)
  8025ff:	89 d6                	mov    %edx,%esi
  802601:	89 c3                	mov    %eax,%ebx
  802603:	f7 64 24 0c          	mull   0xc(%esp)
  802607:	39 d6                	cmp    %edx,%esi
  802609:	72 15                	jb     802620 <__udivdi3+0x100>
  80260b:	89 f9                	mov    %edi,%ecx
  80260d:	d3 e5                	shl    %cl,%ebp
  80260f:	39 c5                	cmp    %eax,%ebp
  802611:	73 04                	jae    802617 <__udivdi3+0xf7>
  802613:	39 d6                	cmp    %edx,%esi
  802615:	74 09                	je     802620 <__udivdi3+0x100>
  802617:	89 d8                	mov    %ebx,%eax
  802619:	31 ff                	xor    %edi,%edi
  80261b:	e9 27 ff ff ff       	jmp    802547 <__udivdi3+0x27>
  802620:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802623:	31 ff                	xor    %edi,%edi
  802625:	e9 1d ff ff ff       	jmp    802547 <__udivdi3+0x27>
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80263b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80263f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802647:	89 da                	mov    %ebx,%edx
  802649:	85 c0                	test   %eax,%eax
  80264b:	75 43                	jne    802690 <__umoddi3+0x60>
  80264d:	39 df                	cmp    %ebx,%edi
  80264f:	76 17                	jbe    802668 <__umoddi3+0x38>
  802651:	89 f0                	mov    %esi,%eax
  802653:	f7 f7                	div    %edi
  802655:	89 d0                	mov    %edx,%eax
  802657:	31 d2                	xor    %edx,%edx
  802659:	83 c4 1c             	add    $0x1c,%esp
  80265c:	5b                   	pop    %ebx
  80265d:	5e                   	pop    %esi
  80265e:	5f                   	pop    %edi
  80265f:	5d                   	pop    %ebp
  802660:	c3                   	ret    
  802661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802668:	89 fd                	mov    %edi,%ebp
  80266a:	85 ff                	test   %edi,%edi
  80266c:	75 0b                	jne    802679 <__umoddi3+0x49>
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	31 d2                	xor    %edx,%edx
  802675:	f7 f7                	div    %edi
  802677:	89 c5                	mov    %eax,%ebp
  802679:	89 d8                	mov    %ebx,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f5                	div    %ebp
  80267f:	89 f0                	mov    %esi,%eax
  802681:	f7 f5                	div    %ebp
  802683:	89 d0                	mov    %edx,%eax
  802685:	eb d0                	jmp    802657 <__umoddi3+0x27>
  802687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80268e:	66 90                	xchg   %ax,%ax
  802690:	89 f1                	mov    %esi,%ecx
  802692:	39 d8                	cmp    %ebx,%eax
  802694:	76 0a                	jbe    8026a0 <__umoddi3+0x70>
  802696:	89 f0                	mov    %esi,%eax
  802698:	83 c4 1c             	add    $0x1c,%esp
  80269b:	5b                   	pop    %ebx
  80269c:	5e                   	pop    %esi
  80269d:	5f                   	pop    %edi
  80269e:	5d                   	pop    %ebp
  80269f:	c3                   	ret    
  8026a0:	0f bd e8             	bsr    %eax,%ebp
  8026a3:	83 f5 1f             	xor    $0x1f,%ebp
  8026a6:	75 20                	jne    8026c8 <__umoddi3+0x98>
  8026a8:	39 d8                	cmp    %ebx,%eax
  8026aa:	0f 82 b0 00 00 00    	jb     802760 <__umoddi3+0x130>
  8026b0:	39 f7                	cmp    %esi,%edi
  8026b2:	0f 86 a8 00 00 00    	jbe    802760 <__umoddi3+0x130>
  8026b8:	89 c8                	mov    %ecx,%eax
  8026ba:	83 c4 1c             	add    $0x1c,%esp
  8026bd:	5b                   	pop    %ebx
  8026be:	5e                   	pop    %esi
  8026bf:	5f                   	pop    %edi
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    
  8026c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c8:	89 e9                	mov    %ebp,%ecx
  8026ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8026cf:	29 ea                	sub    %ebp,%edx
  8026d1:	d3 e0                	shl    %cl,%eax
  8026d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d7:	89 d1                	mov    %edx,%ecx
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	d3 e8                	shr    %cl,%eax
  8026dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026e9:	09 c1                	or     %eax,%ecx
  8026eb:	89 d8                	mov    %ebx,%eax
  8026ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026f1:	89 e9                	mov    %ebp,%ecx
  8026f3:	d3 e7                	shl    %cl,%edi
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	d3 e8                	shr    %cl,%eax
  8026f9:	89 e9                	mov    %ebp,%ecx
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	d3 e3                	shl    %cl,%ebx
  802701:	89 c7                	mov    %eax,%edi
  802703:	89 d1                	mov    %edx,%ecx
  802705:	89 f0                	mov    %esi,%eax
  802707:	d3 e8                	shr    %cl,%eax
  802709:	89 e9                	mov    %ebp,%ecx
  80270b:	89 fa                	mov    %edi,%edx
  80270d:	d3 e6                	shl    %cl,%esi
  80270f:	09 d8                	or     %ebx,%eax
  802711:	f7 74 24 08          	divl   0x8(%esp)
  802715:	89 d1                	mov    %edx,%ecx
  802717:	89 f3                	mov    %esi,%ebx
  802719:	f7 64 24 0c          	mull   0xc(%esp)
  80271d:	89 c6                	mov    %eax,%esi
  80271f:	89 d7                	mov    %edx,%edi
  802721:	39 d1                	cmp    %edx,%ecx
  802723:	72 06                	jb     80272b <__umoddi3+0xfb>
  802725:	75 10                	jne    802737 <__umoddi3+0x107>
  802727:	39 c3                	cmp    %eax,%ebx
  802729:	73 0c                	jae    802737 <__umoddi3+0x107>
  80272b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80272f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802733:	89 d7                	mov    %edx,%edi
  802735:	89 c6                	mov    %eax,%esi
  802737:	89 ca                	mov    %ecx,%edx
  802739:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80273e:	29 f3                	sub    %esi,%ebx
  802740:	19 fa                	sbb    %edi,%edx
  802742:	89 d0                	mov    %edx,%eax
  802744:	d3 e0                	shl    %cl,%eax
  802746:	89 e9                	mov    %ebp,%ecx
  802748:	d3 eb                	shr    %cl,%ebx
  80274a:	d3 ea                	shr    %cl,%edx
  80274c:	09 d8                	or     %ebx,%eax
  80274e:	83 c4 1c             	add    $0x1c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	89 da                	mov    %ebx,%edx
  802762:	29 fe                	sub    %edi,%esi
  802764:	19 c2                	sbb    %eax,%edx
  802766:	89 f1                	mov    %esi,%ecx
  802768:	89 c8                	mov    %ecx,%eax
  80276a:	e9 4b ff ff ff       	jmp    8026ba <__umoddi3+0x8a>
