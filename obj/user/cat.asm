
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
  800049:	e8 e3 12 00 00       	call   801331 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 96 13 00 00       	call   8013fd <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 80 21 80 00       	push   $0x802180
  80007a:	6a 0d                	push   $0xd
  80007c:	68 9b 21 80 00       	push   $0x80219b
  800081:	e8 4e 01 00 00       	call   8001d4 <_panic>
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
  800096:	68 a6 21 80 00       	push   $0x8021a6
  80009b:	6a 0f                	push   $0xf
  80009d:	68 9b 21 80 00       	push   $0x80219b
  8000a2:	e8 2d 01 00 00       	call   8001d4 <_panic>

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
  8000b3:	c7 05 00 30 80 00 bb 	movl   $0x8021bb,0x803000
  8000ba:	21 80 00 
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
  8000cb:	68 bf 21 80 00       	push   $0x8021bf
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
  8000e9:	68 c7 21 80 00       	push   $0x8021c7
  8000ee:	e8 18 18 00 00       	call   80190b <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 5d 16 00 00       	call   801768 <open>
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
  800123:	e8 cb 10 00 00       	call   8011f3 <close>
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
  800140:	e8 98 0c 00 00       	call   800ddd <sys_getenvid>
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

	// call user main routine
	umain(argc, argv);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 0c             	pushl  0xc(%ebp)
  8001aa:	ff 75 08             	pushl  0x8(%ebp)
  8001ad:	e8 f5 fe ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  8001b2:	e8 0b 00 00 00       	call   8001c2 <exit>
}
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bd:	5b                   	pop    %ebx
  8001be:	5e                   	pop    %esi
  8001bf:	5f                   	pop    %edi
  8001c0:	5d                   	pop    %ebp
  8001c1:	c3                   	ret    

008001c2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001c8:	6a 00                	push   $0x0
  8001ca:	e8 cd 0b 00 00       	call   800d9c <sys_env_destroy>
}
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8001de:	8b 40 48             	mov    0x48(%eax),%eax
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	68 14 22 80 00       	push   $0x802214
  8001e9:	50                   	push   %eax
  8001ea:	68 e4 21 80 00       	push   $0x8021e4
  8001ef:	e8 d6 00 00 00       	call   8002ca <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001f4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001f7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001fd:	e8 db 0b 00 00       	call   800ddd <sys_getenvid>
  800202:	83 c4 04             	add    $0x4,%esp
  800205:	ff 75 0c             	pushl  0xc(%ebp)
  800208:	ff 75 08             	pushl  0x8(%ebp)
  80020b:	56                   	push   %esi
  80020c:	50                   	push   %eax
  80020d:	68 f0 21 80 00       	push   $0x8021f0
  800212:	e8 b3 00 00 00       	call   8002ca <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	53                   	push   %ebx
  80021b:	ff 75 10             	pushl  0x10(%ebp)
  80021e:	e8 56 00 00 00       	call   800279 <vcprintf>
	cprintf("\n");
  800223:	c7 04 24 eb 26 80 00 	movl   $0x8026eb,(%esp)
  80022a:	e8 9b 00 00 00       	call   8002ca <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800232:	cc                   	int3   
  800233:	eb fd                	jmp    800232 <_panic+0x5e>

00800235 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	53                   	push   %ebx
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023f:	8b 13                	mov    (%ebx),%edx
  800241:	8d 42 01             	lea    0x1(%edx),%eax
  800244:	89 03                	mov    %eax,(%ebx)
  800246:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800249:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80024d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800252:	74 09                	je     80025d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80025d:	83 ec 08             	sub    $0x8,%esp
  800260:	68 ff 00 00 00       	push   $0xff
  800265:	8d 43 08             	lea    0x8(%ebx),%eax
  800268:	50                   	push   %eax
  800269:	e8 f1 0a 00 00       	call   800d5f <sys_cputs>
		b->idx = 0;
  80026e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	eb db                	jmp    800254 <putch+0x1f>

00800279 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800282:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800289:	00 00 00 
	b.cnt = 0;
  80028c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800293:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	68 35 02 80 00       	push   $0x800235
  8002a8:	e8 4a 01 00 00       	call   8003f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ad:	83 c4 08             	add    $0x8,%esp
  8002b0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002bc:	50                   	push   %eax
  8002bd:	e8 9d 0a 00 00       	call   800d5f <sys_cputs>

	return b.cnt;
}
  8002c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 08             	pushl  0x8(%ebp)
  8002d7:	e8 9d ff ff ff       	call   800279 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 1c             	sub    $0x1c,%esp
  8002e7:	89 c6                	mov    %eax,%esi
  8002e9:	89 d7                	mov    %edx,%edi
  8002eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002fd:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800301:	74 2c                	je     80032f <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800303:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800306:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80030d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800313:	39 c2                	cmp    %eax,%edx
  800315:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800318:	73 43                	jae    80035d <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80031a:	83 eb 01             	sub    $0x1,%ebx
  80031d:	85 db                	test   %ebx,%ebx
  80031f:	7e 6c                	jle    80038d <printnum+0xaf>
				putch(padc, putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	57                   	push   %edi
  800325:	ff 75 18             	pushl  0x18(%ebp)
  800328:	ff d6                	call   *%esi
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	eb eb                	jmp    80031a <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 20                	push   $0x20
  800334:	6a 00                	push   $0x0
  800336:	50                   	push   %eax
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	ff 75 e0             	pushl  -0x20(%ebp)
  80033d:	89 fa                	mov    %edi,%edx
  80033f:	89 f0                	mov    %esi,%eax
  800341:	e8 98 ff ff ff       	call   8002de <printnum>
		while (--width > 0)
  800346:	83 c4 20             	add    $0x20,%esp
  800349:	83 eb 01             	sub    $0x1,%ebx
  80034c:	85 db                	test   %ebx,%ebx
  80034e:	7e 65                	jle    8003b5 <printnum+0xd7>
			putch(padc, putdat);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	57                   	push   %edi
  800354:	6a 20                	push   $0x20
  800356:	ff d6                	call   *%esi
  800358:	83 c4 10             	add    $0x10,%esp
  80035b:	eb ec                	jmp    800349 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80035d:	83 ec 0c             	sub    $0xc,%esp
  800360:	ff 75 18             	pushl  0x18(%ebp)
  800363:	83 eb 01             	sub    $0x1,%ebx
  800366:	53                   	push   %ebx
  800367:	50                   	push   %eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 dc             	pushl  -0x24(%ebp)
  80036e:	ff 75 d8             	pushl  -0x28(%ebp)
  800371:	ff 75 e4             	pushl  -0x1c(%ebp)
  800374:	ff 75 e0             	pushl  -0x20(%ebp)
  800377:	e8 a4 1b 00 00       	call   801f20 <__udivdi3>
  80037c:	83 c4 18             	add    $0x18,%esp
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	89 fa                	mov    %edi,%edx
  800383:	89 f0                	mov    %esi,%eax
  800385:	e8 54 ff ff ff       	call   8002de <printnum>
  80038a:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	57                   	push   %edi
  800391:	83 ec 04             	sub    $0x4,%esp
  800394:	ff 75 dc             	pushl  -0x24(%ebp)
  800397:	ff 75 d8             	pushl  -0x28(%ebp)
  80039a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039d:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a0:	e8 8b 1c 00 00       	call   802030 <__umoddi3>
  8003a5:	83 c4 14             	add    $0x14,%esp
  8003a8:	0f be 80 1b 22 80 00 	movsbl 0x80221b(%eax),%eax
  8003af:	50                   	push   %eax
  8003b0:	ff d6                	call   *%esi
  8003b2:	83 c4 10             	add    $0x10,%esp
	}
}
  8003b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5f                   	pop    %edi
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cc:	73 0a                	jae    8003d8 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d1:	89 08                	mov    %ecx,(%eax)
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	88 02                	mov    %al,(%edx)
}
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <printfmt>:
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e3:	50                   	push   %eax
  8003e4:	ff 75 10             	pushl  0x10(%ebp)
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 05 00 00 00       	call   8003f7 <vprintfmt>
}
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <vprintfmt>:
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	57                   	push   %edi
  8003fb:	56                   	push   %esi
  8003fc:	53                   	push   %ebx
  8003fd:	83 ec 3c             	sub    $0x3c,%esp
  800400:	8b 75 08             	mov    0x8(%ebp),%esi
  800403:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800406:	8b 7d 10             	mov    0x10(%ebp),%edi
  800409:	e9 32 04 00 00       	jmp    800840 <vprintfmt+0x449>
		padc = ' ';
  80040e:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800412:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800419:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800420:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800427:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80042e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800435:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8d 47 01             	lea    0x1(%edi),%eax
  80043d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800440:	0f b6 17             	movzbl (%edi),%edx
  800443:	8d 42 dd             	lea    -0x23(%edx),%eax
  800446:	3c 55                	cmp    $0x55,%al
  800448:	0f 87 12 05 00 00    	ja     800960 <vprintfmt+0x569>
  80044e:	0f b6 c0             	movzbl %al,%eax
  800451:	ff 24 85 00 24 80 00 	jmp    *0x802400(,%eax,4)
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045b:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80045f:	eb d9                	jmp    80043a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800461:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800464:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800468:	eb d0                	jmp    80043a <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	0f b6 d2             	movzbl %dl,%edx
  80046d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	89 75 08             	mov    %esi,0x8(%ebp)
  800478:	eb 03                	jmp    80047d <vprintfmt+0x86>
  80047a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80047d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800480:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800484:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800487:	8d 72 d0             	lea    -0x30(%edx),%esi
  80048a:	83 fe 09             	cmp    $0x9,%esi
  80048d:	76 eb                	jbe    80047a <vprintfmt+0x83>
  80048f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800492:	8b 75 08             	mov    0x8(%ebp),%esi
  800495:	eb 14                	jmp    8004ab <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8d 40 04             	lea    0x4(%eax),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004af:	79 89                	jns    80043a <vprintfmt+0x43>
				width = precision, precision = -1;
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004be:	e9 77 ff ff ff       	jmp    80043a <vprintfmt+0x43>
  8004c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	0f 48 c1             	cmovs  %ecx,%eax
  8004cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d1:	e9 64 ff ff ff       	jmp    80043a <vprintfmt+0x43>
  8004d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004e0:	e9 55 ff ff ff       	jmp    80043a <vprintfmt+0x43>
			lflag++;
  8004e5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ec:	e9 49 ff ff ff       	jmp    80043a <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 78 04             	lea    0x4(%eax),%edi
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	ff 30                	pushl  (%eax)
  8004fd:	ff d6                	call   *%esi
			break;
  8004ff:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800502:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800505:	e9 33 03 00 00       	jmp    80083d <vprintfmt+0x446>
			err = va_arg(ap, int);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 78 04             	lea    0x4(%eax),%edi
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
  800513:	31 d0                	xor    %edx,%eax
  800515:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800517:	83 f8 0f             	cmp    $0xf,%eax
  80051a:	7f 23                	jg     80053f <vprintfmt+0x148>
  80051c:	8b 14 85 60 25 80 00 	mov    0x802560(,%eax,4),%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	74 18                	je     80053f <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800527:	52                   	push   %edx
  800528:	68 9e 26 80 00       	push   $0x80269e
  80052d:	53                   	push   %ebx
  80052e:	56                   	push   %esi
  80052f:	e8 a6 fe ff ff       	call   8003da <printfmt>
  800534:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800537:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053a:	e9 fe 02 00 00       	jmp    80083d <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80053f:	50                   	push   %eax
  800540:	68 33 22 80 00       	push   $0x802233
  800545:	53                   	push   %ebx
  800546:	56                   	push   %esi
  800547:	e8 8e fe ff ff       	call   8003da <printfmt>
  80054c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800552:	e9 e6 02 00 00       	jmp    80083d <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800565:	85 c9                	test   %ecx,%ecx
  800567:	b8 2c 22 80 00       	mov    $0x80222c,%eax
  80056c:	0f 45 c1             	cmovne %ecx,%eax
  80056f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800572:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800576:	7e 06                	jle    80057e <vprintfmt+0x187>
  800578:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057c:	75 0d                	jne    80058b <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800581:	89 c7                	mov    %eax,%edi
  800583:	03 45 e0             	add    -0x20(%ebp),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800589:	eb 53                	jmp    8005de <vprintfmt+0x1e7>
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	ff 75 d8             	pushl  -0x28(%ebp)
  800591:	50                   	push   %eax
  800592:	e8 71 04 00 00       	call   800a08 <strnlen>
  800597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059a:	29 c1                	sub    %eax,%ecx
  80059c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005a4:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ab:	eb 0f                	jmp    8005bc <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	53                   	push   %ebx
  8005b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b6:	83 ef 01             	sub    $0x1,%edi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	85 ff                	test   %edi,%edi
  8005be:	7f ed                	jg     8005ad <vprintfmt+0x1b6>
  8005c0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ca:	0f 49 c1             	cmovns %ecx,%eax
  8005cd:	29 c1                	sub    %eax,%ecx
  8005cf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005d2:	eb aa                	jmp    80057e <vprintfmt+0x187>
					putch(ch, putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	52                   	push   %edx
  8005d9:	ff d6                	call   *%esi
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e1:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e3:	83 c7 01             	add    $0x1,%edi
  8005e6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ea:	0f be d0             	movsbl %al,%edx
  8005ed:	85 d2                	test   %edx,%edx
  8005ef:	74 4b                	je     80063c <vprintfmt+0x245>
  8005f1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f5:	78 06                	js     8005fd <vprintfmt+0x206>
  8005f7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005fb:	78 1e                	js     80061b <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005fd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800601:	74 d1                	je     8005d4 <vprintfmt+0x1dd>
  800603:	0f be c0             	movsbl %al,%eax
  800606:	83 e8 20             	sub    $0x20,%eax
  800609:	83 f8 5e             	cmp    $0x5e,%eax
  80060c:	76 c6                	jbe    8005d4 <vprintfmt+0x1dd>
					putch('?', putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	6a 3f                	push   $0x3f
  800614:	ff d6                	call   *%esi
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	eb c3                	jmp    8005de <vprintfmt+0x1e7>
  80061b:	89 cf                	mov    %ecx,%edi
  80061d:	eb 0e                	jmp    80062d <vprintfmt+0x236>
				putch(' ', putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	6a 20                	push   $0x20
  800625:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800627:	83 ef 01             	sub    $0x1,%edi
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	85 ff                	test   %edi,%edi
  80062f:	7f ee                	jg     80061f <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800631:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	e9 01 02 00 00       	jmp    80083d <vprintfmt+0x446>
  80063c:	89 cf                	mov    %ecx,%edi
  80063e:	eb ed                	jmp    80062d <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800640:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800643:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80064a:	e9 eb fd ff ff       	jmp    80043a <vprintfmt+0x43>
	if (lflag >= 2)
  80064f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800653:	7f 21                	jg     800676 <vprintfmt+0x27f>
	else if (lflag)
  800655:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800659:	74 68                	je     8006c3 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800663:	89 c1                	mov    %eax,%ecx
  800665:	c1 f9 1f             	sar    $0x1f,%ecx
  800668:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb 17                	jmp    80068d <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800681:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80068d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800690:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800696:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800699:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80069d:	78 3f                	js     8006de <vprintfmt+0x2e7>
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006a4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006a8:	0f 84 71 01 00 00    	je     80081f <vprintfmt+0x428>
				putch('+', putdat);
  8006ae:	83 ec 08             	sub    $0x8,%esp
  8006b1:	53                   	push   %ebx
  8006b2:	6a 2b                	push   $0x2b
  8006b4:	ff d6                	call   *%esi
  8006b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006be:	e9 5c 01 00 00       	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006cb:	89 c1                	mov    %eax,%ecx
  8006cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dc:	eb af                	jmp    80068d <vprintfmt+0x296>
				putch('-', putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	6a 2d                	push   $0x2d
  8006e4:	ff d6                	call   *%esi
				num = -(long long) num;
  8006e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ec:	f7 d8                	neg    %eax
  8006ee:	83 d2 00             	adc    $0x0,%edx
  8006f1:	f7 da                	neg    %edx
  8006f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	e9 19 01 00 00       	jmp    80081f <vprintfmt+0x428>
	if (lflag >= 2)
  800706:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070a:	7f 29                	jg     800735 <vprintfmt+0x33e>
	else if (lflag)
  80070c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800710:	74 44                	je     800756 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 04             	lea    0x4(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800730:	e9 ea 00 00 00       	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 50 04             	mov    0x4(%eax),%edx
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 08             	lea    0x8(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	e9 c9 00 00 00       	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	ba 00 00 00 00       	mov    $0x0,%edx
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8d 40 04             	lea    0x4(%eax),%eax
  80076c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800774:	e9 a6 00 00 00       	jmp    80081f <vprintfmt+0x428>
			putch('0', putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	53                   	push   %ebx
  80077d:	6a 30                	push   $0x30
  80077f:	ff d6                	call   *%esi
	if (lflag >= 2)
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800788:	7f 26                	jg     8007b0 <vprintfmt+0x3b9>
	else if (lflag)
  80078a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078e:	74 3e                	je     8007ce <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a9:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ae:	eb 6f                	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 50 04             	mov    0x4(%eax),%edx
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 40 08             	lea    0x8(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007cc:	eb 51                	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ec:	eb 31                	jmp    80081f <vprintfmt+0x428>
			putch('0', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	6a 30                	push   $0x30
  8007f4:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f6:	83 c4 08             	add    $0x8,%esp
  8007f9:	53                   	push   %ebx
  8007fa:	6a 78                	push   $0x78
  8007fc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8b 00                	mov    (%eax),%eax
  800803:	ba 00 00 00 00       	mov    $0x0,%edx
  800808:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80080e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8d 40 04             	lea    0x4(%eax),%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800826:	52                   	push   %edx
  800827:	ff 75 e0             	pushl  -0x20(%ebp)
  80082a:	50                   	push   %eax
  80082b:	ff 75 dc             	pushl  -0x24(%ebp)
  80082e:	ff 75 d8             	pushl  -0x28(%ebp)
  800831:	89 da                	mov    %ebx,%edx
  800833:	89 f0                	mov    %esi,%eax
  800835:	e8 a4 fa ff ff       	call   8002de <printnum>
			break;
  80083a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80083d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800840:	83 c7 01             	add    $0x1,%edi
  800843:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800847:	83 f8 25             	cmp    $0x25,%eax
  80084a:	0f 84 be fb ff ff    	je     80040e <vprintfmt+0x17>
			if (ch == '\0')
  800850:	85 c0                	test   %eax,%eax
  800852:	0f 84 28 01 00 00    	je     800980 <vprintfmt+0x589>
			putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	50                   	push   %eax
  80085d:	ff d6                	call   *%esi
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	eb dc                	jmp    800840 <vprintfmt+0x449>
	if (lflag >= 2)
  800864:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800868:	7f 26                	jg     800890 <vprintfmt+0x499>
	else if (lflag)
  80086a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80086e:	74 41                	je     8008b1 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	ba 00 00 00 00       	mov    $0x0,%edx
  80087a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800889:	b8 10 00 00 00       	mov    $0x10,%eax
  80088e:	eb 8f                	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	8b 50 04             	mov    0x4(%eax),%edx
  800896:	8b 00                	mov    (%eax),%eax
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 40 08             	lea    0x8(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ac:	e9 6e ff ff ff       	jmp    80081f <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8d 40 04             	lea    0x4(%eax),%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ca:	b8 10 00 00 00       	mov    $0x10,%eax
  8008cf:	e9 4b ff ff ff       	jmp    80081f <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	83 c0 04             	add    $0x4,%eax
  8008da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	74 14                	je     8008fa <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008e6:	8b 13                	mov    (%ebx),%edx
  8008e8:	83 fa 7f             	cmp    $0x7f,%edx
  8008eb:	7f 37                	jg     800924 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008ed:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f5:	e9 43 ff ff ff       	jmp    80083d <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ff:	bf 51 23 80 00       	mov    $0x802351,%edi
							putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	50                   	push   %eax
  800909:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80090b:	83 c7 01             	add    $0x1,%edi
  80090e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	85 c0                	test   %eax,%eax
  800917:	75 eb                	jne    800904 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800919:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091c:	89 45 14             	mov    %eax,0x14(%ebp)
  80091f:	e9 19 ff ff ff       	jmp    80083d <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800924:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800926:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092b:	bf 89 23 80 00       	mov    $0x802389,%edi
							putch(ch, putdat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	53                   	push   %ebx
  800934:	50                   	push   %eax
  800935:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800937:	83 c7 01             	add    $0x1,%edi
  80093a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	85 c0                	test   %eax,%eax
  800943:	75 eb                	jne    800930 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800945:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
  80094b:	e9 ed fe ff ff       	jmp    80083d <vprintfmt+0x446>
			putch(ch, putdat);
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	53                   	push   %ebx
  800954:	6a 25                	push   $0x25
  800956:	ff d6                	call   *%esi
			break;
  800958:	83 c4 10             	add    $0x10,%esp
  80095b:	e9 dd fe ff ff       	jmp    80083d <vprintfmt+0x446>
			putch('%', putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	53                   	push   %ebx
  800964:	6a 25                	push   $0x25
  800966:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	89 f8                	mov    %edi,%eax
  80096d:	eb 03                	jmp    800972 <vprintfmt+0x57b>
  80096f:	83 e8 01             	sub    $0x1,%eax
  800972:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800976:	75 f7                	jne    80096f <vprintfmt+0x578>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097b:	e9 bd fe ff ff       	jmp    80083d <vprintfmt+0x446>
}
  800980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800983:	5b                   	pop    %ebx
  800984:	5e                   	pop    %esi
  800985:	5f                   	pop    %edi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	83 ec 18             	sub    $0x18,%esp
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800994:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800997:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	74 26                	je     8009cf <vsnprintf+0x47>
  8009a9:	85 d2                	test   %edx,%edx
  8009ab:	7e 22                	jle    8009cf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ad:	ff 75 14             	pushl  0x14(%ebp)
  8009b0:	ff 75 10             	pushl  0x10(%ebp)
  8009b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b6:	50                   	push   %eax
  8009b7:	68 bd 03 80 00       	push   $0x8003bd
  8009bc:	e8 36 fa ff ff       	call   8003f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
}
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    
		return -E_INVAL;
  8009cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d4:	eb f7                	jmp    8009cd <vsnprintf+0x45>

008009d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009df:	50                   	push   %eax
  8009e0:	ff 75 10             	pushl  0x10(%ebp)
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	ff 75 08             	pushl  0x8(%ebp)
  8009e9:	e8 9a ff ff ff       	call   800988 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ff:	74 05                	je     800a06 <strlen+0x16>
		n++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f5                	jmp    8009fb <strlen+0xb>
	return n;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a11:	ba 00 00 00 00       	mov    $0x0,%edx
  800a16:	39 c2                	cmp    %eax,%edx
  800a18:	74 0d                	je     800a27 <strnlen+0x1f>
  800a1a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a1e:	74 05                	je     800a25 <strnlen+0x1d>
		n++;
  800a20:	83 c2 01             	add    $0x1,%edx
  800a23:	eb f1                	jmp    800a16 <strnlen+0xe>
  800a25:	89 d0                	mov    %edx,%eax
	return n;
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a33:	ba 00 00 00 00       	mov    $0x0,%edx
  800a38:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a3c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a3f:	83 c2 01             	add    $0x1,%edx
  800a42:	84 c9                	test   %cl,%cl
  800a44:	75 f2                	jne    800a38 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a46:	5b                   	pop    %ebx
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	53                   	push   %ebx
  800a4d:	83 ec 10             	sub    $0x10,%esp
  800a50:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a53:	53                   	push   %ebx
  800a54:	e8 97 ff ff ff       	call   8009f0 <strlen>
  800a59:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	01 d8                	add    %ebx,%eax
  800a61:	50                   	push   %eax
  800a62:	e8 c2 ff ff ff       	call   800a29 <strcpy>
	return dst;
}
  800a67:	89 d8                	mov    %ebx,%eax
  800a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a79:	89 c6                	mov    %eax,%esi
  800a7b:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	39 f2                	cmp    %esi,%edx
  800a82:	74 11                	je     800a95 <strncpy+0x27>
		*dst++ = *src;
  800a84:	83 c2 01             	add    $0x1,%edx
  800a87:	0f b6 19             	movzbl (%ecx),%ebx
  800a8a:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a8d:	80 fb 01             	cmp    $0x1,%bl
  800a90:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a93:	eb eb                	jmp    800a80 <strncpy+0x12>
	}
	return ret;
}
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
  800a9e:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa4:	8b 55 10             	mov    0x10(%ebp),%edx
  800aa7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aa9:	85 d2                	test   %edx,%edx
  800aab:	74 21                	je     800ace <strlcpy+0x35>
  800aad:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ab1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ab3:	39 c2                	cmp    %eax,%edx
  800ab5:	74 14                	je     800acb <strlcpy+0x32>
  800ab7:	0f b6 19             	movzbl (%ecx),%ebx
  800aba:	84 db                	test   %bl,%bl
  800abc:	74 0b                	je     800ac9 <strlcpy+0x30>
			*dst++ = *src++;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	83 c2 01             	add    $0x1,%edx
  800ac4:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac7:	eb ea                	jmp    800ab3 <strlcpy+0x1a>
  800ac9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800acb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ace:	29 f0                	sub    %esi,%eax
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ada:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800add:	0f b6 01             	movzbl (%ecx),%eax
  800ae0:	84 c0                	test   %al,%al
  800ae2:	74 0c                	je     800af0 <strcmp+0x1c>
  800ae4:	3a 02                	cmp    (%edx),%al
  800ae6:	75 08                	jne    800af0 <strcmp+0x1c>
		p++, q++;
  800ae8:	83 c1 01             	add    $0x1,%ecx
  800aeb:	83 c2 01             	add    $0x1,%edx
  800aee:	eb ed                	jmp    800add <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af0:	0f b6 c0             	movzbl %al,%eax
  800af3:	0f b6 12             	movzbl (%edx),%edx
  800af6:	29 d0                	sub    %edx,%eax
}
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	53                   	push   %ebx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b04:	89 c3                	mov    %eax,%ebx
  800b06:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b09:	eb 06                	jmp    800b11 <strncmp+0x17>
		n--, p++, q++;
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b11:	39 d8                	cmp    %ebx,%eax
  800b13:	74 16                	je     800b2b <strncmp+0x31>
  800b15:	0f b6 08             	movzbl (%eax),%ecx
  800b18:	84 c9                	test   %cl,%cl
  800b1a:	74 04                	je     800b20 <strncmp+0x26>
  800b1c:	3a 0a                	cmp    (%edx),%cl
  800b1e:	74 eb                	je     800b0b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b20:	0f b6 00             	movzbl (%eax),%eax
  800b23:	0f b6 12             	movzbl (%edx),%edx
  800b26:	29 d0                	sub    %edx,%eax
}
  800b28:	5b                   	pop    %ebx
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    
		return 0;
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b30:	eb f6                	jmp    800b28 <strncmp+0x2e>

00800b32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3c:	0f b6 10             	movzbl (%eax),%edx
  800b3f:	84 d2                	test   %dl,%dl
  800b41:	74 09                	je     800b4c <strchr+0x1a>
		if (*s == c)
  800b43:	38 ca                	cmp    %cl,%dl
  800b45:	74 0a                	je     800b51 <strchr+0x1f>
	for (; *s; s++)
  800b47:	83 c0 01             	add    $0x1,%eax
  800b4a:	eb f0                	jmp    800b3c <strchr+0xa>
			return (char *) s;
	return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b5d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b60:	38 ca                	cmp    %cl,%dl
  800b62:	74 09                	je     800b6d <strfind+0x1a>
  800b64:	84 d2                	test   %dl,%dl
  800b66:	74 05                	je     800b6d <strfind+0x1a>
	for (; *s; s++)
  800b68:	83 c0 01             	add    $0x1,%eax
  800b6b:	eb f0                	jmp    800b5d <strfind+0xa>
			break;
	return (char *) s;
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b7b:	85 c9                	test   %ecx,%ecx
  800b7d:	74 31                	je     800bb0 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7f:	89 f8                	mov    %edi,%eax
  800b81:	09 c8                	or     %ecx,%eax
  800b83:	a8 03                	test   $0x3,%al
  800b85:	75 23                	jne    800baa <memset+0x3b>
		c &= 0xFF;
  800b87:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b8b:	89 d3                	mov    %edx,%ebx
  800b8d:	c1 e3 08             	shl    $0x8,%ebx
  800b90:	89 d0                	mov    %edx,%eax
  800b92:	c1 e0 18             	shl    $0x18,%eax
  800b95:	89 d6                	mov    %edx,%esi
  800b97:	c1 e6 10             	shl    $0x10,%esi
  800b9a:	09 f0                	or     %esi,%eax
  800b9c:	09 c2                	or     %eax,%edx
  800b9e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ba0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba3:	89 d0                	mov    %edx,%eax
  800ba5:	fc                   	cld    
  800ba6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ba8:	eb 06                	jmp    800bb0 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	fc                   	cld    
  800bae:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb0:	89 f8                	mov    %edi,%eax
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5f                   	pop    %edi
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc5:	39 c6                	cmp    %eax,%esi
  800bc7:	73 32                	jae    800bfb <memmove+0x44>
  800bc9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bcc:	39 c2                	cmp    %eax,%edx
  800bce:	76 2b                	jbe    800bfb <memmove+0x44>
		s += n;
		d += n;
  800bd0:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd3:	89 fe                	mov    %edi,%esi
  800bd5:	09 ce                	or     %ecx,%esi
  800bd7:	09 d6                	or     %edx,%esi
  800bd9:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bdf:	75 0e                	jne    800bef <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be1:	83 ef 04             	sub    $0x4,%edi
  800be4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800be7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bea:	fd                   	std    
  800beb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bed:	eb 09                	jmp    800bf8 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bef:	83 ef 01             	sub    $0x1,%edi
  800bf2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf5:	fd                   	std    
  800bf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bf8:	fc                   	cld    
  800bf9:	eb 1a                	jmp    800c15 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfb:	89 c2                	mov    %eax,%edx
  800bfd:	09 ca                	or     %ecx,%edx
  800bff:	09 f2                	or     %esi,%edx
  800c01:	f6 c2 03             	test   $0x3,%dl
  800c04:	75 0a                	jne    800c10 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c09:	89 c7                	mov    %eax,%edi
  800c0b:	fc                   	cld    
  800c0c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c0e:	eb 05                	jmp    800c15 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	fc                   	cld    
  800c13:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c1f:	ff 75 10             	pushl  0x10(%ebp)
  800c22:	ff 75 0c             	pushl  0xc(%ebp)
  800c25:	ff 75 08             	pushl  0x8(%ebp)
  800c28:	e8 8a ff ff ff       	call   800bb7 <memmove>
}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 c6                	mov    %eax,%esi
  800c3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3f:	39 f0                	cmp    %esi,%eax
  800c41:	74 1c                	je     800c5f <memcmp+0x30>
		if (*s1 != *s2)
  800c43:	0f b6 08             	movzbl (%eax),%ecx
  800c46:	0f b6 1a             	movzbl (%edx),%ebx
  800c49:	38 d9                	cmp    %bl,%cl
  800c4b:	75 08                	jne    800c55 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c4d:	83 c0 01             	add    $0x1,%eax
  800c50:	83 c2 01             	add    $0x1,%edx
  800c53:	eb ea                	jmp    800c3f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c55:	0f b6 c1             	movzbl %cl,%eax
  800c58:	0f b6 db             	movzbl %bl,%ebx
  800c5b:	29 d8                	sub    %ebx,%eax
  800c5d:	eb 05                	jmp    800c64 <memcmp+0x35>
	}

	return 0;
  800c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c71:	89 c2                	mov    %eax,%edx
  800c73:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c76:	39 d0                	cmp    %edx,%eax
  800c78:	73 09                	jae    800c83 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7a:	38 08                	cmp    %cl,(%eax)
  800c7c:	74 05                	je     800c83 <memfind+0x1b>
	for (; s < ends; s++)
  800c7e:	83 c0 01             	add    $0x1,%eax
  800c81:	eb f3                	jmp    800c76 <memfind+0xe>
			break;
	return (void *) s;
}
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c91:	eb 03                	jmp    800c96 <strtol+0x11>
		s++;
  800c93:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c96:	0f b6 01             	movzbl (%ecx),%eax
  800c99:	3c 20                	cmp    $0x20,%al
  800c9b:	74 f6                	je     800c93 <strtol+0xe>
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	74 f2                	je     800c93 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca1:	3c 2b                	cmp    $0x2b,%al
  800ca3:	74 2a                	je     800ccf <strtol+0x4a>
	int neg = 0;
  800ca5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800caa:	3c 2d                	cmp    $0x2d,%al
  800cac:	74 2b                	je     800cd9 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cae:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb4:	75 0f                	jne    800cc5 <strtol+0x40>
  800cb6:	80 39 30             	cmpb   $0x30,(%ecx)
  800cb9:	74 28                	je     800ce3 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbb:	85 db                	test   %ebx,%ebx
  800cbd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc2:	0f 44 d8             	cmove  %eax,%ebx
  800cc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800cca:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ccd:	eb 50                	jmp    800d1f <strtol+0x9a>
		s++;
  800ccf:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd7:	eb d5                	jmp    800cae <strtol+0x29>
		s++, neg = 1;
  800cd9:	83 c1 01             	add    $0x1,%ecx
  800cdc:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce1:	eb cb                	jmp    800cae <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ce7:	74 0e                	je     800cf7 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ce9:	85 db                	test   %ebx,%ebx
  800ceb:	75 d8                	jne    800cc5 <strtol+0x40>
		s++, base = 8;
  800ced:	83 c1 01             	add    $0x1,%ecx
  800cf0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf5:	eb ce                	jmp    800cc5 <strtol+0x40>
		s += 2, base = 16;
  800cf7:	83 c1 02             	add    $0x2,%ecx
  800cfa:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cff:	eb c4                	jmp    800cc5 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d01:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d04:	89 f3                	mov    %esi,%ebx
  800d06:	80 fb 19             	cmp    $0x19,%bl
  800d09:	77 29                	ja     800d34 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d0b:	0f be d2             	movsbl %dl,%edx
  800d0e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d11:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d14:	7d 30                	jge    800d46 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d16:	83 c1 01             	add    $0x1,%ecx
  800d19:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d1d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d1f:	0f b6 11             	movzbl (%ecx),%edx
  800d22:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d25:	89 f3                	mov    %esi,%ebx
  800d27:	80 fb 09             	cmp    $0x9,%bl
  800d2a:	77 d5                	ja     800d01 <strtol+0x7c>
			dig = *s - '0';
  800d2c:	0f be d2             	movsbl %dl,%edx
  800d2f:	83 ea 30             	sub    $0x30,%edx
  800d32:	eb dd                	jmp    800d11 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d34:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d37:	89 f3                	mov    %esi,%ebx
  800d39:	80 fb 19             	cmp    $0x19,%bl
  800d3c:	77 08                	ja     800d46 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d3e:	0f be d2             	movsbl %dl,%edx
  800d41:	83 ea 37             	sub    $0x37,%edx
  800d44:	eb cb                	jmp    800d11 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4a:	74 05                	je     800d51 <strtol+0xcc>
		*endptr = (char *) s;
  800d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d4f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d51:	89 c2                	mov    %eax,%edx
  800d53:	f7 da                	neg    %edx
  800d55:	85 ff                	test   %edi,%edi
  800d57:	0f 45 c2             	cmovne %edx,%eax
}
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	57                   	push   %edi
  800d63:	56                   	push   %esi
  800d64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d65:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	89 c3                	mov    %eax,%ebx
  800d72:	89 c7                	mov    %eax,%edi
  800d74:	89 c6                	mov    %eax,%esi
  800d76:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_cgetc>:

int
sys_cgetc(void)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d83:	ba 00 00 00 00       	mov    $0x0,%edx
  800d88:	b8 01 00 00 00       	mov    $0x1,%eax
  800d8d:	89 d1                	mov    %edx,%ecx
  800d8f:	89 d3                	mov    %edx,%ebx
  800d91:	89 d7                	mov    %edx,%edi
  800d93:	89 d6                	mov    %edx,%esi
  800d95:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
  800da2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	b8 03 00 00 00       	mov    $0x3,%eax
  800db2:	89 cb                	mov    %ecx,%ebx
  800db4:	89 cf                	mov    %ecx,%edi
  800db6:	89 ce                	mov    %ecx,%esi
  800db8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7f 08                	jg     800dc6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	50                   	push   %eax
  800dca:	6a 03                	push   $0x3
  800dcc:	68 a0 25 80 00       	push   $0x8025a0
  800dd1:	6a 43                	push   $0x43
  800dd3:	68 bd 25 80 00       	push   $0x8025bd
  800dd8:	e8 f7 f3 ff ff       	call   8001d4 <_panic>

00800ddd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de3:	ba 00 00 00 00       	mov    $0x0,%edx
  800de8:	b8 02 00 00 00       	mov    $0x2,%eax
  800ded:	89 d1                	mov    %edx,%ecx
  800def:	89 d3                	mov    %edx,%ebx
  800df1:	89 d7                	mov    %edx,%edi
  800df3:	89 d6                	mov    %edx,%esi
  800df5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <sys_yield>:

void
sys_yield(void)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e02:	ba 00 00 00 00       	mov    $0x0,%edx
  800e07:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e0c:	89 d1                	mov    %edx,%ecx
  800e0e:	89 d3                	mov    %edx,%ebx
  800e10:	89 d7                	mov    %edx,%edi
  800e12:	89 d6                	mov    %edx,%esi
  800e14:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e24:	be 00 00 00 00       	mov    $0x0,%esi
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	b8 04 00 00 00       	mov    $0x4,%eax
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e37:	89 f7                	mov    %esi,%edi
  800e39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7f 08                	jg     800e47 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	83 ec 0c             	sub    $0xc,%esp
  800e4a:	50                   	push   %eax
  800e4b:	6a 04                	push   $0x4
  800e4d:	68 a0 25 80 00       	push   $0x8025a0
  800e52:	6a 43                	push   $0x43
  800e54:	68 bd 25 80 00       	push   $0x8025bd
  800e59:	e8 76 f3 ff ff       	call   8001d4 <_panic>

00800e5e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	b8 05 00 00 00       	mov    $0x5,%eax
  800e72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e78:	8b 75 18             	mov    0x18(%ebp),%esi
  800e7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7f 08                	jg     800e89 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	50                   	push   %eax
  800e8d:	6a 05                	push   $0x5
  800e8f:	68 a0 25 80 00       	push   $0x8025a0
  800e94:	6a 43                	push   $0x43
  800e96:	68 bd 25 80 00       	push   $0x8025bd
  800e9b:	e8 34 f3 ff ff       	call   8001d4 <_panic>

00800ea0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 06 00 00 00       	mov    $0x6,%eax
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 06                	push   $0x6
  800ed1:	68 a0 25 80 00       	push   $0x8025a0
  800ed6:	6a 43                	push   $0x43
  800ed8:	68 bd 25 80 00       	push   $0x8025bd
  800edd:	e8 f2 f2 ff ff       	call   8001d4 <_panic>

00800ee2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 08 00 00 00       	mov    $0x8,%eax
  800efb:	89 df                	mov    %ebx,%edi
  800efd:	89 de                	mov    %ebx,%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0d:	83 ec 0c             	sub    $0xc,%esp
  800f10:	50                   	push   %eax
  800f11:	6a 08                	push   $0x8
  800f13:	68 a0 25 80 00       	push   $0x8025a0
  800f18:	6a 43                	push   $0x43
  800f1a:	68 bd 25 80 00       	push   $0x8025bd
  800f1f:	e8 b0 f2 ff ff       	call   8001d4 <_panic>

00800f24 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 09 00 00 00       	mov    $0x9,%eax
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 09                	push   $0x9
  800f55:	68 a0 25 80 00       	push   $0x8025a0
  800f5a:	6a 43                	push   $0x43
  800f5c:	68 bd 25 80 00       	push   $0x8025bd
  800f61:	e8 6e f2 ff ff       	call   8001d4 <_panic>

00800f66 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7f 08                	jg     800f91 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8c:	5b                   	pop    %ebx
  800f8d:	5e                   	pop    %esi
  800f8e:	5f                   	pop    %edi
  800f8f:	5d                   	pop    %ebp
  800f90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	50                   	push   %eax
  800f95:	6a 0a                	push   $0xa
  800f97:	68 a0 25 80 00       	push   $0x8025a0
  800f9c:	6a 43                	push   $0x43
  800f9e:	68 bd 25 80 00       	push   $0x8025bd
  800fa3:	e8 2c f2 ff ff       	call   8001d4 <_panic>

00800fa8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
  800fbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 0d                	push   $0xd
  800ffb:	68 a0 25 80 00       	push   $0x8025a0
  801000:	6a 43                	push   $0x43
  801002:	68 bd 25 80 00       	push   $0x8025bd
  801007:	e8 c8 f1 ff ff       	call   8001d4 <_panic>

0080100c <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
	asm volatile("int %1\n"
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801022:	89 df                	mov    %ebx,%edi
  801024:	89 de                	mov    %ebx,%esi
  801026:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801028:	5b                   	pop    %ebx
  801029:	5e                   	pop    %esi
  80102a:	5f                   	pop    %edi
  80102b:	5d                   	pop    %ebp
  80102c:	c3                   	ret    

0080102d <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	57                   	push   %edi
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
	asm volatile("int %1\n"
  801033:	b9 00 00 00 00       	mov    $0x0,%ecx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	b8 0f 00 00 00       	mov    $0xf,%eax
  801040:	89 cb                	mov    %ecx,%ebx
  801042:	89 cf                	mov    %ecx,%edi
  801044:	89 ce                	mov    %ecx,%esi
  801046:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	05 00 00 00 30       	add    $0x30000000,%eax
  801058:	c1 e8 0c             	shr    $0xc,%eax
}
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801068:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80106d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	c1 ea 16             	shr    $0x16,%edx
  801081:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	74 2d                	je     8010ba <fd_alloc+0x46>
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	c1 ea 0c             	shr    $0xc,%edx
  801092:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801099:	f6 c2 01             	test   $0x1,%dl
  80109c:	74 1c                	je     8010ba <fd_alloc+0x46>
  80109e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a8:	75 d2                	jne    80107c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010b8:	eb 0a                	jmp    8010c4 <fd_alloc+0x50>
			*fd_store = fd;
  8010ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010cc:	83 f8 1f             	cmp    $0x1f,%eax
  8010cf:	77 30                	ja     801101 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d1:	c1 e0 0c             	shl    $0xc,%eax
  8010d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	74 24                	je     801108 <fd_lookup+0x42>
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 ea 0c             	shr    $0xc,%edx
  8010e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f0:	f6 c2 01             	test   $0x1,%dl
  8010f3:	74 1a                	je     80110f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
		return -E_INVAL;
  801101:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801106:	eb f7                	jmp    8010ff <fd_lookup+0x39>
		return -E_INVAL;
  801108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110d:	eb f0                	jmp    8010ff <fd_lookup+0x39>
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801114:	eb e9                	jmp    8010ff <fd_lookup+0x39>

00801116 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111f:	ba 4c 26 80 00       	mov    $0x80264c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801124:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801129:	39 08                	cmp    %ecx,(%eax)
  80112b:	74 33                	je     801160 <dev_lookup+0x4a>
  80112d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801130:	8b 02                	mov    (%edx),%eax
  801132:	85 c0                	test   %eax,%eax
  801134:	75 f3                	jne    801129 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801136:	a1 20 60 80 00       	mov    0x806020,%eax
  80113b:	8b 40 48             	mov    0x48(%eax),%eax
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	51                   	push   %ecx
  801142:	50                   	push   %eax
  801143:	68 cc 25 80 00       	push   $0x8025cc
  801148:	e8 7d f1 ff ff       	call   8002ca <cprintf>
	*dev = 0;
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    
			*dev = devtab[i];
  801160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801163:	89 01                	mov    %eax,(%ecx)
			return 0;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	eb f2                	jmp    80115e <dev_lookup+0x48>

0080116c <fd_close>:
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
  801172:	83 ec 24             	sub    $0x24,%esp
  801175:	8b 75 08             	mov    0x8(%ebp),%esi
  801178:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80117b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80117e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801185:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801188:	50                   	push   %eax
  801189:	e8 38 ff ff ff       	call   8010c6 <fd_lookup>
  80118e:	89 c3                	mov    %eax,%ebx
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	78 05                	js     80119c <fd_close+0x30>
	    || fd != fd2)
  801197:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80119a:	74 16                	je     8011b2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80119c:	89 f8                	mov    %edi,%eax
  80119e:	84 c0                	test   %al,%al
  8011a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a5:	0f 44 d8             	cmove  %eax,%ebx
}
  8011a8:	89 d8                	mov    %ebx,%eax
  8011aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ad:	5b                   	pop    %ebx
  8011ae:	5e                   	pop    %esi
  8011af:	5f                   	pop    %edi
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011b8:	50                   	push   %eax
  8011b9:	ff 36                	pushl  (%esi)
  8011bb:	e8 56 ff ff ff       	call   801116 <dev_lookup>
  8011c0:	89 c3                	mov    %eax,%ebx
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 1a                	js     8011e3 <fd_close+0x77>
		if (dev->dev_close)
  8011c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011cc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	74 0b                	je     8011e3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011d8:	83 ec 0c             	sub    $0xc,%esp
  8011db:	56                   	push   %esi
  8011dc:	ff d0                	call   *%eax
  8011de:	89 c3                	mov    %eax,%ebx
  8011e0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	56                   	push   %esi
  8011e7:	6a 00                	push   $0x0
  8011e9:	e8 b2 fc ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	eb b5                	jmp    8011a8 <fd_close+0x3c>

008011f3 <close>:

int
close(int fdnum)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	e8 c1 fe ff ff       	call   8010c6 <fd_lookup>
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	79 02                	jns    80120e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    
		return fd_close(fd, 1);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	6a 01                	push   $0x1
  801213:	ff 75 f4             	pushl  -0xc(%ebp)
  801216:	e8 51 ff ff ff       	call   80116c <fd_close>
  80121b:	83 c4 10             	add    $0x10,%esp
  80121e:	eb ec                	jmp    80120c <close+0x19>

00801220 <close_all>:

void
close_all(void)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	53                   	push   %ebx
  801224:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801227:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	53                   	push   %ebx
  801230:	e8 be ff ff ff       	call   8011f3 <close>
	for (i = 0; i < MAXFD; i++)
  801235:	83 c3 01             	add    $0x1,%ebx
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	83 fb 20             	cmp    $0x20,%ebx
  80123e:	75 ec                	jne    80122c <close_all+0xc>
}
  801240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	57                   	push   %edi
  801249:	56                   	push   %esi
  80124a:	53                   	push   %ebx
  80124b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80124e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801251:	50                   	push   %eax
  801252:	ff 75 08             	pushl  0x8(%ebp)
  801255:	e8 6c fe ff ff       	call   8010c6 <fd_lookup>
  80125a:	89 c3                	mov    %eax,%ebx
  80125c:	83 c4 10             	add    $0x10,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	0f 88 81 00 00 00    	js     8012e8 <dup+0xa3>
		return r;
	close(newfdnum);
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 81 ff ff ff       	call   8011f3 <close>

	newfd = INDEX2FD(newfdnum);
  801272:	8b 75 0c             	mov    0xc(%ebp),%esi
  801275:	c1 e6 0c             	shl    $0xc,%esi
  801278:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80127e:	83 c4 04             	add    $0x4,%esp
  801281:	ff 75 e4             	pushl  -0x1c(%ebp)
  801284:	e8 d4 fd ff ff       	call   80105d <fd2data>
  801289:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80128b:	89 34 24             	mov    %esi,(%esp)
  80128e:	e8 ca fd ff ff       	call   80105d <fd2data>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801298:	89 d8                	mov    %ebx,%eax
  80129a:	c1 e8 16             	shr    $0x16,%eax
  80129d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012a4:	a8 01                	test   $0x1,%al
  8012a6:	74 11                	je     8012b9 <dup+0x74>
  8012a8:	89 d8                	mov    %ebx,%eax
  8012aa:	c1 e8 0c             	shr    $0xc,%eax
  8012ad:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012b4:	f6 c2 01             	test   $0x1,%dl
  8012b7:	75 39                	jne    8012f2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012bc:	89 d0                	mov    %edx,%eax
  8012be:	c1 e8 0c             	shr    $0xc,%eax
  8012c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d0:	50                   	push   %eax
  8012d1:	56                   	push   %esi
  8012d2:	6a 00                	push   $0x0
  8012d4:	52                   	push   %edx
  8012d5:	6a 00                	push   $0x0
  8012d7:	e8 82 fb ff ff       	call   800e5e <sys_page_map>
  8012dc:	89 c3                	mov    %eax,%ebx
  8012de:	83 c4 20             	add    $0x20,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 31                	js     801316 <dup+0xd1>
		goto err;

	return newfdnum;
  8012e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012e8:	89 d8                	mov    %ebx,%eax
  8012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012f9:	83 ec 0c             	sub    $0xc,%esp
  8012fc:	25 07 0e 00 00       	and    $0xe07,%eax
  801301:	50                   	push   %eax
  801302:	57                   	push   %edi
  801303:	6a 00                	push   $0x0
  801305:	53                   	push   %ebx
  801306:	6a 00                	push   $0x0
  801308:	e8 51 fb ff ff       	call   800e5e <sys_page_map>
  80130d:	89 c3                	mov    %eax,%ebx
  80130f:	83 c4 20             	add    $0x20,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	79 a3                	jns    8012b9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	56                   	push   %esi
  80131a:	6a 00                	push   $0x0
  80131c:	e8 7f fb ff ff       	call   800ea0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801321:	83 c4 08             	add    $0x8,%esp
  801324:	57                   	push   %edi
  801325:	6a 00                	push   $0x0
  801327:	e8 74 fb ff ff       	call   800ea0 <sys_page_unmap>
	return r;
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	eb b7                	jmp    8012e8 <dup+0xa3>

00801331 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	53                   	push   %ebx
  801335:	83 ec 1c             	sub    $0x1c,%esp
  801338:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	53                   	push   %ebx
  801340:	e8 81 fd ff ff       	call   8010c6 <fd_lookup>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 3f                	js     80138b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80134c:	83 ec 08             	sub    $0x8,%esp
  80134f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801352:	50                   	push   %eax
  801353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801356:	ff 30                	pushl  (%eax)
  801358:	e8 b9 fd ff ff       	call   801116 <dev_lookup>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 27                	js     80138b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801364:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801367:	8b 42 08             	mov    0x8(%edx),%eax
  80136a:	83 e0 03             	and    $0x3,%eax
  80136d:	83 f8 01             	cmp    $0x1,%eax
  801370:	74 1e                	je     801390 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	8b 40 08             	mov    0x8(%eax),%eax
  801378:	85 c0                	test   %eax,%eax
  80137a:	74 35                	je     8013b1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	ff 75 10             	pushl  0x10(%ebp)
  801382:	ff 75 0c             	pushl  0xc(%ebp)
  801385:	52                   	push   %edx
  801386:	ff d0                	call   *%eax
  801388:	83 c4 10             	add    $0x10,%esp
}
  80138b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801390:	a1 20 60 80 00       	mov    0x806020,%eax
  801395:	8b 40 48             	mov    0x48(%eax),%eax
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	53                   	push   %ebx
  80139c:	50                   	push   %eax
  80139d:	68 10 26 80 00       	push   $0x802610
  8013a2:	e8 23 ef ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  8013a7:	83 c4 10             	add    $0x10,%esp
  8013aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013af:	eb da                	jmp    80138b <read+0x5a>
		return -E_NOT_SUPP;
  8013b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b6:	eb d3                	jmp    80138b <read+0x5a>

008013b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	57                   	push   %edi
  8013bc:	56                   	push   %esi
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cc:	39 f3                	cmp    %esi,%ebx
  8013ce:	73 23                	jae    8013f3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	89 f0                	mov    %esi,%eax
  8013d5:	29 d8                	sub    %ebx,%eax
  8013d7:	50                   	push   %eax
  8013d8:	89 d8                	mov    %ebx,%eax
  8013da:	03 45 0c             	add    0xc(%ebp),%eax
  8013dd:	50                   	push   %eax
  8013de:	57                   	push   %edi
  8013df:	e8 4d ff ff ff       	call   801331 <read>
		if (m < 0)
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 06                	js     8013f1 <readn+0x39>
			return m;
		if (m == 0)
  8013eb:	74 06                	je     8013f3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013ed:	01 c3                	add    %eax,%ebx
  8013ef:	eb db                	jmp    8013cc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013f3:	89 d8                	mov    %ebx,%eax
  8013f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f8:	5b                   	pop    %ebx
  8013f9:	5e                   	pop    %esi
  8013fa:	5f                   	pop    %edi
  8013fb:	5d                   	pop    %ebp
  8013fc:	c3                   	ret    

008013fd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	53                   	push   %ebx
  801401:	83 ec 1c             	sub    $0x1c,%esp
  801404:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801407:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140a:	50                   	push   %eax
  80140b:	53                   	push   %ebx
  80140c:	e8 b5 fc ff ff       	call   8010c6 <fd_lookup>
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 3a                	js     801452 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801422:	ff 30                	pushl  (%eax)
  801424:	e8 ed fc ff ff       	call   801116 <dev_lookup>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 22                	js     801452 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801437:	74 1e                	je     801457 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 52 0c             	mov    0xc(%edx),%edx
  80143f:	85 d2                	test   %edx,%edx
  801441:	74 35                	je     801478 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801443:	83 ec 04             	sub    $0x4,%esp
  801446:	ff 75 10             	pushl  0x10(%ebp)
  801449:	ff 75 0c             	pushl  0xc(%ebp)
  80144c:	50                   	push   %eax
  80144d:	ff d2                	call   *%edx
  80144f:	83 c4 10             	add    $0x10,%esp
}
  801452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801455:	c9                   	leave  
  801456:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801457:	a1 20 60 80 00       	mov    0x806020,%eax
  80145c:	8b 40 48             	mov    0x48(%eax),%eax
  80145f:	83 ec 04             	sub    $0x4,%esp
  801462:	53                   	push   %ebx
  801463:	50                   	push   %eax
  801464:	68 2c 26 80 00       	push   $0x80262c
  801469:	e8 5c ee ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801476:	eb da                	jmp    801452 <write+0x55>
		return -E_NOT_SUPP;
  801478:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147d:	eb d3                	jmp    801452 <write+0x55>

0080147f <seek>:

int
seek(int fdnum, off_t offset)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801485:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801488:	50                   	push   %eax
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 35 fc ff ff       	call   8010c6 <fd_lookup>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 0e                	js     8014a6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	53                   	push   %ebx
  8014ac:	83 ec 1c             	sub    $0x1c,%esp
  8014af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b5:	50                   	push   %eax
  8014b6:	53                   	push   %ebx
  8014b7:	e8 0a fc ff ff       	call   8010c6 <fd_lookup>
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 37                	js     8014fa <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c9:	50                   	push   %eax
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	ff 30                	pushl  (%eax)
  8014cf:	e8 42 fc ff ff       	call   801116 <dev_lookup>
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	78 1f                	js     8014fa <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014de:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e2:	74 1b                	je     8014ff <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e7:	8b 52 18             	mov    0x18(%edx),%edx
  8014ea:	85 d2                	test   %edx,%edx
  8014ec:	74 32                	je     801520 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	50                   	push   %eax
  8014f5:	ff d2                	call   *%edx
  8014f7:	83 c4 10             	add    $0x10,%esp
}
  8014fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014ff:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801504:	8b 40 48             	mov    0x48(%eax),%eax
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	53                   	push   %ebx
  80150b:	50                   	push   %eax
  80150c:	68 ec 25 80 00       	push   $0x8025ec
  801511:	e8 b4 ed ff ff       	call   8002ca <cprintf>
		return -E_INVAL;
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151e:	eb da                	jmp    8014fa <ftruncate+0x52>
		return -E_NOT_SUPP;
  801520:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801525:	eb d3                	jmp    8014fa <ftruncate+0x52>

00801527 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	53                   	push   %ebx
  80152b:	83 ec 1c             	sub    $0x1c,%esp
  80152e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801531:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801534:	50                   	push   %eax
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	e8 89 fb ff ff       	call   8010c6 <fd_lookup>
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	78 4b                	js     80158f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154a:	50                   	push   %eax
  80154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154e:	ff 30                	pushl  (%eax)
  801550:	e8 c1 fb ff ff       	call   801116 <dev_lookup>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 33                	js     80158f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801563:	74 2f                	je     801594 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801565:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801568:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80156f:	00 00 00 
	stat->st_isdir = 0;
  801572:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801579:	00 00 00 
	stat->st_dev = dev;
  80157c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	53                   	push   %ebx
  801586:	ff 75 f0             	pushl  -0x10(%ebp)
  801589:	ff 50 14             	call   *0x14(%eax)
  80158c:	83 c4 10             	add    $0x10,%esp
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
		return -E_NOT_SUPP;
  801594:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801599:	eb f4                	jmp    80158f <fstat+0x68>

0080159b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	56                   	push   %esi
  80159f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	6a 00                	push   $0x0
  8015a5:	ff 75 08             	pushl  0x8(%ebp)
  8015a8:	e8 bb 01 00 00       	call   801768 <open>
  8015ad:	89 c3                	mov    %eax,%ebx
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 1b                	js     8015d1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015b6:	83 ec 08             	sub    $0x8,%esp
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	50                   	push   %eax
  8015bd:	e8 65 ff ff ff       	call   801527 <fstat>
  8015c2:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c4:	89 1c 24             	mov    %ebx,(%esp)
  8015c7:	e8 27 fc ff ff       	call   8011f3 <close>
	return r;
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 f3                	mov    %esi,%ebx
}
  8015d1:	89 d8                	mov    %ebx,%eax
  8015d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	56                   	push   %esi
  8015de:	53                   	push   %ebx
  8015df:	89 c6                	mov    %eax,%esi
  8015e1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015e3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ea:	74 27                	je     801613 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ec:	6a 07                	push   $0x7
  8015ee:	68 00 70 80 00       	push   $0x807000
  8015f3:	56                   	push   %esi
  8015f4:	ff 35 00 40 80 00    	pushl  0x804000
  8015fa:	e8 4e 08 00 00       	call   801e4d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ff:	83 c4 0c             	add    $0xc,%esp
  801602:	6a 00                	push   $0x0
  801604:	53                   	push   %ebx
  801605:	6a 00                	push   $0x0
  801607:	e8 d8 07 00 00       	call   801de4 <ipc_recv>
}
  80160c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	6a 01                	push   $0x1
  801618:	e8 88 08 00 00       	call   801ea5 <ipc_find_env>
  80161d:	a3 00 40 80 00       	mov    %eax,0x804000
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	eb c5                	jmp    8015ec <fsipc+0x12>

00801627 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	8b 40 0c             	mov    0xc(%eax),%eax
  801633:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163b:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 02 00 00 00       	mov    $0x2,%eax
  80164a:	e8 8b ff ff ff       	call   8015da <fsipc>
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <devfile_flush>:
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8b 40 0c             	mov    0xc(%eax),%eax
  80165d:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 06 00 00 00       	mov    $0x6,%eax
  80166c:	e8 69 ff ff ff       	call   8015da <fsipc>
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <devfile_stat>:
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	8b 40 0c             	mov    0xc(%eax),%eax
  801683:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	b8 05 00 00 00       	mov    $0x5,%eax
  801692:	e8 43 ff ff ff       	call   8015da <fsipc>
  801697:	85 c0                	test   %eax,%eax
  801699:	78 2c                	js     8016c7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	68 00 70 80 00       	push   $0x807000
  8016a3:	53                   	push   %ebx
  8016a4:	e8 80 f3 ff ff       	call   800a29 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016a9:	a1 80 70 80 00       	mov    0x807080,%eax
  8016ae:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b4:	a1 84 70 80 00       	mov    0x807084,%eax
  8016b9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <devfile_write>:
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8016d2:	68 5c 26 80 00       	push   $0x80265c
  8016d7:	68 90 00 00 00       	push   $0x90
  8016dc:	68 7a 26 80 00       	push   $0x80267a
  8016e1:	e8 ee ea ff ff       	call   8001d4 <_panic>

008016e6 <devfile_read>:
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	56                   	push   %esi
  8016ea:	53                   	push   %ebx
  8016eb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f4:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8016f9:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801704:	b8 03 00 00 00       	mov    $0x3,%eax
  801709:	e8 cc fe ff ff       	call   8015da <fsipc>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	85 c0                	test   %eax,%eax
  801712:	78 1f                	js     801733 <devfile_read+0x4d>
	assert(r <= n);
  801714:	39 f0                	cmp    %esi,%eax
  801716:	77 24                	ja     80173c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801718:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80171d:	7f 33                	jg     801752 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	50                   	push   %eax
  801723:	68 00 70 80 00       	push   $0x807000
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	e8 87 f4 ff ff       	call   800bb7 <memmove>
	return r;
  801730:	83 c4 10             	add    $0x10,%esp
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    
	assert(r <= n);
  80173c:	68 85 26 80 00       	push   $0x802685
  801741:	68 8c 26 80 00       	push   $0x80268c
  801746:	6a 7c                	push   $0x7c
  801748:	68 7a 26 80 00       	push   $0x80267a
  80174d:	e8 82 ea ff ff       	call   8001d4 <_panic>
	assert(r <= PGSIZE);
  801752:	68 a1 26 80 00       	push   $0x8026a1
  801757:	68 8c 26 80 00       	push   $0x80268c
  80175c:	6a 7d                	push   $0x7d
  80175e:	68 7a 26 80 00       	push   $0x80267a
  801763:	e8 6c ea ff ff       	call   8001d4 <_panic>

00801768 <open>:
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	83 ec 1c             	sub    $0x1c,%esp
  801770:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801773:	56                   	push   %esi
  801774:	e8 77 f2 ff ff       	call   8009f0 <strlen>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801781:	7f 6c                	jg     8017ef <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801789:	50                   	push   %eax
  80178a:	e8 e5 f8 ff ff       	call   801074 <fd_alloc>
  80178f:	89 c3                	mov    %eax,%ebx
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	85 c0                	test   %eax,%eax
  801796:	78 3c                	js     8017d4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801798:	83 ec 08             	sub    $0x8,%esp
  80179b:	56                   	push   %esi
  80179c:	68 00 70 80 00       	push   $0x807000
  8017a1:	e8 83 f2 ff ff       	call   800a29 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b6:	e8 1f fe ff ff       	call   8015da <fsipc>
  8017bb:	89 c3                	mov    %eax,%ebx
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	78 19                	js     8017dd <open+0x75>
	return fd2num(fd);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ca:	e8 7e f8 ff ff       	call   80104d <fd2num>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 10             	add    $0x10,%esp
}
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d9:	5b                   	pop    %ebx
  8017da:	5e                   	pop    %esi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    
		fd_close(fd, 0);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	6a 00                	push   $0x0
  8017e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e5:	e8 82 f9 ff ff       	call   80116c <fd_close>
		return r;
  8017ea:	83 c4 10             	add    $0x10,%esp
  8017ed:	eb e5                	jmp    8017d4 <open+0x6c>
		return -E_BAD_PATH;
  8017ef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017f4:	eb de                	jmp    8017d4 <open+0x6c>

008017f6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801801:	b8 08 00 00 00       	mov    $0x8,%eax
  801806:	e8 cf fd ff ff       	call   8015da <fsipc>
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80180d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801811:	7f 01                	jg     801814 <writebuf+0x7>
  801813:	c3                   	ret    
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	53                   	push   %ebx
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80181d:	ff 70 04             	pushl  0x4(%eax)
  801820:	8d 40 10             	lea    0x10(%eax),%eax
  801823:	50                   	push   %eax
  801824:	ff 33                	pushl  (%ebx)
  801826:	e8 d2 fb ff ff       	call   8013fd <write>
		if (result > 0)
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	7e 03                	jle    801835 <writebuf+0x28>
			b->result += result;
  801832:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801835:	39 43 04             	cmp    %eax,0x4(%ebx)
  801838:	74 0d                	je     801847 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80183a:	85 c0                	test   %eax,%eax
  80183c:	ba 00 00 00 00       	mov    $0x0,%edx
  801841:	0f 4f c2             	cmovg  %edx,%eax
  801844:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <putch>:

static void
putch(int ch, void *thunk)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801856:	8b 53 04             	mov    0x4(%ebx),%edx
  801859:	8d 42 01             	lea    0x1(%edx),%eax
  80185c:	89 43 04             	mov    %eax,0x4(%ebx)
  80185f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801862:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801866:	3d 00 01 00 00       	cmp    $0x100,%eax
  80186b:	74 06                	je     801873 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80186d:	83 c4 04             	add    $0x4,%esp
  801870:	5b                   	pop    %ebx
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    
		writebuf(b);
  801873:	89 d8                	mov    %ebx,%eax
  801875:	e8 93 ff ff ff       	call   80180d <writebuf>
		b->idx = 0;
  80187a:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801881:	eb ea                	jmp    80186d <putch+0x21>

00801883 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801895:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80189c:	00 00 00 
	b.result = 0;
  80189f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018a6:	00 00 00 
	b.error = 1;
  8018a9:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018b0:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018b3:	ff 75 10             	pushl  0x10(%ebp)
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018bf:	50                   	push   %eax
  8018c0:	68 4c 18 80 00       	push   $0x80184c
  8018c5:	e8 2d eb ff ff       	call   8003f7 <vprintfmt>
	if (b.idx > 0)
  8018ca:	83 c4 10             	add    $0x10,%esp
  8018cd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018d4:	7f 11                	jg     8018e7 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8018d6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    
		writebuf(&b);
  8018e7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018ed:	e8 1b ff ff ff       	call   80180d <writebuf>
  8018f2:	eb e2                	jmp    8018d6 <vfprintf+0x53>

008018f4 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018fa:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 7a ff ff ff       	call   801883 <vfprintf>
	va_end(ap);

	return cnt;
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <printf>:

int
printf(const char *fmt, ...)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801911:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801914:	50                   	push   %eax
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	6a 01                	push   $0x1
  80191a:	e8 64 ff ff ff       	call   801883 <vfprintf>
	va_end(ap);

	return cnt;
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 29 f7 ff ff       	call   80105d <fd2data>
  801934:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801936:	83 c4 08             	add    $0x8,%esp
  801939:	68 ad 26 80 00       	push   $0x8026ad
  80193e:	53                   	push   %ebx
  80193f:	e8 e5 f0 ff ff       	call   800a29 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801944:	8b 46 04             	mov    0x4(%esi),%eax
  801947:	2b 06                	sub    (%esi),%eax
  801949:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80194f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801956:	00 00 00 
	stat->st_dev = &devpipe;
  801959:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801960:	30 80 00 
	return 0;
}
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
  801968:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	53                   	push   %ebx
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801979:	53                   	push   %ebx
  80197a:	6a 00                	push   $0x0
  80197c:	e8 1f f5 ff ff       	call   800ea0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801981:	89 1c 24             	mov    %ebx,(%esp)
  801984:	e8 d4 f6 ff ff       	call   80105d <fd2data>
  801989:	83 c4 08             	add    $0x8,%esp
  80198c:	50                   	push   %eax
  80198d:	6a 00                	push   $0x0
  80198f:	e8 0c f5 ff ff       	call   800ea0 <sys_page_unmap>
}
  801994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <_pipeisclosed>:
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	57                   	push   %edi
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
  80199f:	83 ec 1c             	sub    $0x1c,%esp
  8019a2:	89 c7                	mov    %eax,%edi
  8019a4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8019ab:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	57                   	push   %edi
  8019b2:	e8 29 05 00 00       	call   801ee0 <pageref>
  8019b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ba:	89 34 24             	mov    %esi,(%esp)
  8019bd:	e8 1e 05 00 00       	call   801ee0 <pageref>
		nn = thisenv->env_runs;
  8019c2:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8019c8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	39 cb                	cmp    %ecx,%ebx
  8019d0:	74 1b                	je     8019ed <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019d5:	75 cf                	jne    8019a6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019d7:	8b 42 58             	mov    0x58(%edx),%eax
  8019da:	6a 01                	push   $0x1
  8019dc:	50                   	push   %eax
  8019dd:	53                   	push   %ebx
  8019de:	68 b4 26 80 00       	push   $0x8026b4
  8019e3:	e8 e2 e8 ff ff       	call   8002ca <cprintf>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	eb b9                	jmp    8019a6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019f0:	0f 94 c0             	sete   %al
  8019f3:	0f b6 c0             	movzbl %al,%eax
}
  8019f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    

008019fe <devpipe_write>:
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	57                   	push   %edi
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
  801a04:	83 ec 28             	sub    $0x28,%esp
  801a07:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a0a:	56                   	push   %esi
  801a0b:	e8 4d f6 ff ff       	call   80105d <fd2data>
  801a10:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	bf 00 00 00 00       	mov    $0x0,%edi
  801a1a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a1d:	74 4f                	je     801a6e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a1f:	8b 43 04             	mov    0x4(%ebx),%eax
  801a22:	8b 0b                	mov    (%ebx),%ecx
  801a24:	8d 51 20             	lea    0x20(%ecx),%edx
  801a27:	39 d0                	cmp    %edx,%eax
  801a29:	72 14                	jb     801a3f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a2b:	89 da                	mov    %ebx,%edx
  801a2d:	89 f0                	mov    %esi,%eax
  801a2f:	e8 65 ff ff ff       	call   801999 <_pipeisclosed>
  801a34:	85 c0                	test   %eax,%eax
  801a36:	75 3b                	jne    801a73 <devpipe_write+0x75>
			sys_yield();
  801a38:	e8 bf f3 ff ff       	call   800dfc <sys_yield>
  801a3d:	eb e0                	jmp    801a1f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a42:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a46:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a49:	89 c2                	mov    %eax,%edx
  801a4b:	c1 fa 1f             	sar    $0x1f,%edx
  801a4e:	89 d1                	mov    %edx,%ecx
  801a50:	c1 e9 1b             	shr    $0x1b,%ecx
  801a53:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801a56:	83 e2 1f             	and    $0x1f,%edx
  801a59:	29 ca                	sub    %ecx,%edx
  801a5b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801a5f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801a63:	83 c0 01             	add    $0x1,%eax
  801a66:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a69:	83 c7 01             	add    $0x1,%edi
  801a6c:	eb ac                	jmp    801a1a <devpipe_write+0x1c>
	return i;
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	eb 05                	jmp    801a78 <devpipe_write+0x7a>
				return 0;
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devpipe_read>:
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	57                   	push   %edi
  801a84:	56                   	push   %esi
  801a85:	53                   	push   %ebx
  801a86:	83 ec 18             	sub    $0x18,%esp
  801a89:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a8c:	57                   	push   %edi
  801a8d:	e8 cb f5 ff ff       	call   80105d <fd2data>
  801a92:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	be 00 00 00 00       	mov    $0x0,%esi
  801a9c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a9f:	75 14                	jne    801ab5 <devpipe_read+0x35>
	return i;
  801aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa4:	eb 02                	jmp    801aa8 <devpipe_read+0x28>
				return i;
  801aa6:	89 f0                	mov    %esi,%eax
}
  801aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    
			sys_yield();
  801ab0:	e8 47 f3 ff ff       	call   800dfc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ab5:	8b 03                	mov    (%ebx),%eax
  801ab7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801aba:	75 18                	jne    801ad4 <devpipe_read+0x54>
			if (i > 0)
  801abc:	85 f6                	test   %esi,%esi
  801abe:	75 e6                	jne    801aa6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ac0:	89 da                	mov    %ebx,%edx
  801ac2:	89 f8                	mov    %edi,%eax
  801ac4:	e8 d0 fe ff ff       	call   801999 <_pipeisclosed>
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	74 e3                	je     801ab0 <devpipe_read+0x30>
				return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad2:	eb d4                	jmp    801aa8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ad4:	99                   	cltd   
  801ad5:	c1 ea 1b             	shr    $0x1b,%edx
  801ad8:	01 d0                	add    %edx,%eax
  801ada:	83 e0 1f             	and    $0x1f,%eax
  801add:	29 d0                	sub    %edx,%eax
  801adf:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ae4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae7:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801aea:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801aed:	83 c6 01             	add    $0x1,%esi
  801af0:	eb aa                	jmp    801a9c <devpipe_read+0x1c>

00801af2 <pipe>:
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	56                   	push   %esi
  801af6:	53                   	push   %ebx
  801af7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801afa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afd:	50                   	push   %eax
  801afe:	e8 71 f5 ff ff       	call   801074 <fd_alloc>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	0f 88 23 01 00 00    	js     801c33 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	68 07 04 00 00       	push   $0x407
  801b18:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1b:	6a 00                	push   $0x0
  801b1d:	e8 f9 f2 ff ff       	call   800e1b <sys_page_alloc>
  801b22:	89 c3                	mov    %eax,%ebx
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	0f 88 04 01 00 00    	js     801c33 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b35:	50                   	push   %eax
  801b36:	e8 39 f5 ff ff       	call   801074 <fd_alloc>
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	0f 88 db 00 00 00    	js     801c23 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	68 07 04 00 00       	push   $0x407
  801b50:	ff 75 f0             	pushl  -0x10(%ebp)
  801b53:	6a 00                	push   $0x0
  801b55:	e8 c1 f2 ff ff       	call   800e1b <sys_page_alloc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	0f 88 bc 00 00 00    	js     801c23 <pipe+0x131>
	va = fd2data(fd0);
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6d:	e8 eb f4 ff ff       	call   80105d <fd2data>
  801b72:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b74:	83 c4 0c             	add    $0xc,%esp
  801b77:	68 07 04 00 00       	push   $0x407
  801b7c:	50                   	push   %eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	e8 97 f2 ff ff       	call   800e1b <sys_page_alloc>
  801b84:	89 c3                	mov    %eax,%ebx
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	0f 88 82 00 00 00    	js     801c13 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	ff 75 f0             	pushl  -0x10(%ebp)
  801b97:	e8 c1 f4 ff ff       	call   80105d <fd2data>
  801b9c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ba3:	50                   	push   %eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	56                   	push   %esi
  801ba7:	6a 00                	push   $0x0
  801ba9:	e8 b0 f2 ff ff       	call   800e5e <sys_page_map>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	83 c4 20             	add    $0x20,%esp
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 4e                	js     801c05 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801bb7:	a1 20 30 80 00       	mov    0x803020,%eax
  801bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbf:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801bcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bce:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bda:	83 ec 0c             	sub    $0xc,%esp
  801bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801be0:	e8 68 f4 ff ff       	call   80104d <fd2num>
  801be5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bea:	83 c4 04             	add    $0x4,%esp
  801bed:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf0:	e8 58 f4 ff ff       	call   80104d <fd2num>
  801bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c03:	eb 2e                	jmp    801c33 <pipe+0x141>
	sys_page_unmap(0, va);
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	56                   	push   %esi
  801c09:	6a 00                	push   $0x0
  801c0b:	e8 90 f2 ff ff       	call   800ea0 <sys_page_unmap>
  801c10:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	ff 75 f0             	pushl  -0x10(%ebp)
  801c19:	6a 00                	push   $0x0
  801c1b:	e8 80 f2 ff ff       	call   800ea0 <sys_page_unmap>
  801c20:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	ff 75 f4             	pushl  -0xc(%ebp)
  801c29:	6a 00                	push   $0x0
  801c2b:	e8 70 f2 ff ff       	call   800ea0 <sys_page_unmap>
  801c30:	83 c4 10             	add    $0x10,%esp
}
  801c33:	89 d8                	mov    %ebx,%eax
  801c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    

00801c3c <pipeisclosed>:
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c45:	50                   	push   %eax
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	e8 78 f4 ff ff       	call   8010c6 <fd_lookup>
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 18                	js     801c6d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c55:	83 ec 0c             	sub    $0xc,%esp
  801c58:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5b:	e8 fd f3 ff ff       	call   80105d <fd2data>
	return _pipeisclosed(fd, p);
  801c60:	89 c2                	mov    %eax,%edx
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	e8 2f fd ff ff       	call   801999 <_pipeisclosed>
  801c6a:	83 c4 10             	add    $0x10,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c74:	c3                   	ret    

00801c75 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801c7b:	68 cc 26 80 00       	push   $0x8026cc
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	e8 a1 ed ff ff       	call   800a29 <strcpy>
	return 0;
}
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <devcons_write>:
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	57                   	push   %edi
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c9b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ca0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ca6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ca9:	73 31                	jae    801cdc <devcons_write+0x4d>
		m = n - tot;
  801cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cae:	29 f3                	sub    %esi,%ebx
  801cb0:	83 fb 7f             	cmp    $0x7f,%ebx
  801cb3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801cb8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	53                   	push   %ebx
  801cbf:	89 f0                	mov    %esi,%eax
  801cc1:	03 45 0c             	add    0xc(%ebp),%eax
  801cc4:	50                   	push   %eax
  801cc5:	57                   	push   %edi
  801cc6:	e8 ec ee ff ff       	call   800bb7 <memmove>
		sys_cputs(buf, m);
  801ccb:	83 c4 08             	add    $0x8,%esp
  801cce:	53                   	push   %ebx
  801ccf:	57                   	push   %edi
  801cd0:	e8 8a f0 ff ff       	call   800d5f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cd5:	01 de                	add    %ebx,%esi
  801cd7:	83 c4 10             	add    $0x10,%esp
  801cda:	eb ca                	jmp    801ca6 <devcons_write+0x17>
}
  801cdc:	89 f0                	mov    %esi,%eax
  801cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5f                   	pop    %edi
  801ce4:	5d                   	pop    %ebp
  801ce5:	c3                   	ret    

00801ce6 <devcons_read>:
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cf5:	74 21                	je     801d18 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801cf7:	e8 81 f0 ff ff       	call   800d7d <sys_cgetc>
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	75 07                	jne    801d07 <devcons_read+0x21>
		sys_yield();
  801d00:	e8 f7 f0 ff ff       	call   800dfc <sys_yield>
  801d05:	eb f0                	jmp    801cf7 <devcons_read+0x11>
	if (c < 0)
  801d07:	78 0f                	js     801d18 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801d09:	83 f8 04             	cmp    $0x4,%eax
  801d0c:	74 0c                	je     801d1a <devcons_read+0x34>
	*(char*)vbuf = c;
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	88 02                	mov    %al,(%edx)
	return 1;
  801d13:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    
		return 0;
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	eb f7                	jmp    801d18 <devcons_read+0x32>

00801d21 <cputchar>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d2d:	6a 01                	push   $0x1
  801d2f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d32:	50                   	push   %eax
  801d33:	e8 27 f0 ff ff       	call   800d5f <sys_cputs>
}
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <getchar>:
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d43:	6a 01                	push   $0x1
  801d45:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d48:	50                   	push   %eax
  801d49:	6a 00                	push   $0x0
  801d4b:	e8 e1 f5 ff ff       	call   801331 <read>
	if (r < 0)
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 06                	js     801d5d <getchar+0x20>
	if (r < 1)
  801d57:	74 06                	je     801d5f <getchar+0x22>
	return c;
  801d59:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    
		return -E_EOF;
  801d5f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d64:	eb f7                	jmp    801d5d <getchar+0x20>

00801d66 <iscons>:
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6f:	50                   	push   %eax
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	e8 4e f3 ff ff       	call   8010c6 <fd_lookup>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	78 11                	js     801d90 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d88:	39 10                	cmp    %edx,(%eax)
  801d8a:	0f 94 c0             	sete   %al
  801d8d:	0f b6 c0             	movzbl %al,%eax
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <opencons>:
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9b:	50                   	push   %eax
  801d9c:	e8 d3 f2 ff ff       	call   801074 <fd_alloc>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 3a                	js     801de2 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	68 07 04 00 00       	push   $0x407
  801db0:	ff 75 f4             	pushl  -0xc(%ebp)
  801db3:	6a 00                	push   $0x0
  801db5:	e8 61 f0 ff ff       	call   800e1b <sys_page_alloc>
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 21                	js     801de2 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dca:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	50                   	push   %eax
  801dda:	e8 6e f2 ff ff       	call   80104d <fd2num>
  801ddf:	83 c4 10             	add    $0x10,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	8b 75 08             	mov    0x8(%ebp),%esi
  801dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801def:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801df2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801df4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801df9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801dfc:	83 ec 0c             	sub    $0xc,%esp
  801dff:	50                   	push   %eax
  801e00:	e8 c6 f1 ff ff       	call   800fcb <sys_ipc_recv>
	if(ret < 0){
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 2b                	js     801e37 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801e0c:	85 f6                	test   %esi,%esi
  801e0e:	74 0a                	je     801e1a <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801e10:	a1 20 60 80 00       	mov    0x806020,%eax
  801e15:	8b 40 74             	mov    0x74(%eax),%eax
  801e18:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801e1a:	85 db                	test   %ebx,%ebx
  801e1c:	74 0a                	je     801e28 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801e1e:	a1 20 60 80 00       	mov    0x806020,%eax
  801e23:	8b 40 78             	mov    0x78(%eax),%eax
  801e26:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801e28:	a1 20 60 80 00       	mov    0x806020,%eax
  801e2d:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    
		if(from_env_store)
  801e37:	85 f6                	test   %esi,%esi
  801e39:	74 06                	je     801e41 <ipc_recv+0x5d>
			*from_env_store = 0;
  801e3b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801e41:	85 db                	test   %ebx,%ebx
  801e43:	74 eb                	je     801e30 <ipc_recv+0x4c>
			*perm_store = 0;
  801e45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e4b:	eb e3                	jmp    801e30 <ipc_recv+0x4c>

00801e4d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	57                   	push   %edi
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e59:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801e5f:	85 db                	test   %ebx,%ebx
  801e61:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e66:	0f 44 d8             	cmove  %eax,%ebx
  801e69:	eb 05                	jmp    801e70 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801e6b:	e8 8c ef ff ff       	call   800dfc <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801e70:	ff 75 14             	pushl  0x14(%ebp)
  801e73:	53                   	push   %ebx
  801e74:	56                   	push   %esi
  801e75:	57                   	push   %edi
  801e76:	e8 2d f1 ff ff       	call   800fa8 <sys_ipc_try_send>
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	74 1b                	je     801e9d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801e82:	79 e7                	jns    801e6b <ipc_send+0x1e>
  801e84:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e87:	74 e2                	je     801e6b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 d8 26 80 00       	push   $0x8026d8
  801e91:	6a 49                	push   $0x49
  801e93:	68 ed 26 80 00       	push   $0x8026ed
  801e98:	e8 37 e3 ff ff       	call   8001d4 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	5d                   	pop    %ebp
  801ea4:	c3                   	ret    

00801ea5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	c1 e2 07             	shl    $0x7,%edx
  801eb5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ebb:	8b 52 50             	mov    0x50(%edx),%edx
  801ebe:	39 ca                	cmp    %ecx,%edx
  801ec0:	74 11                	je     801ed3 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801ec2:	83 c0 01             	add    $0x1,%eax
  801ec5:	3d 00 04 00 00       	cmp    $0x400,%eax
  801eca:	75 e4                	jne    801eb0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed1:	eb 0b                	jmp    801ede <ipc_find_env+0x39>
			return envs[i].env_id;
  801ed3:	c1 e0 07             	shl    $0x7,%eax
  801ed6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801edb:	8b 40 48             	mov    0x48(%eax),%eax
}
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee6:	89 d0                	mov    %edx,%eax
  801ee8:	c1 e8 16             	shr    $0x16,%eax
  801eeb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ef7:	f6 c1 01             	test   $0x1,%cl
  801efa:	74 1d                	je     801f19 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801efc:	c1 ea 0c             	shr    $0xc,%edx
  801eff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f06:	f6 c2 01             	test   $0x1,%dl
  801f09:	74 0e                	je     801f19 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f0b:	c1 ea 0c             	shr    $0xc,%edx
  801f0e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f15:	ef 
  801f16:	0f b7 c0             	movzwl %ax,%eax
}
  801f19:	5d                   	pop    %ebp
  801f1a:	c3                   	ret    
  801f1b:	66 90                	xchg   %ax,%ax
  801f1d:	66 90                	xchg   %ax,%ax
  801f1f:	90                   	nop

00801f20 <__udivdi3>:
  801f20:	55                   	push   %ebp
  801f21:	57                   	push   %edi
  801f22:	56                   	push   %esi
  801f23:	53                   	push   %ebx
  801f24:	83 ec 1c             	sub    $0x1c,%esp
  801f27:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f2b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f37:	85 d2                	test   %edx,%edx
  801f39:	75 4d                	jne    801f88 <__udivdi3+0x68>
  801f3b:	39 f3                	cmp    %esi,%ebx
  801f3d:	76 19                	jbe    801f58 <__udivdi3+0x38>
  801f3f:	31 ff                	xor    %edi,%edi
  801f41:	89 e8                	mov    %ebp,%eax
  801f43:	89 f2                	mov    %esi,%edx
  801f45:	f7 f3                	div    %ebx
  801f47:	89 fa                	mov    %edi,%edx
  801f49:	83 c4 1c             	add    $0x1c,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
  801f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f58:	89 d9                	mov    %ebx,%ecx
  801f5a:	85 db                	test   %ebx,%ebx
  801f5c:	75 0b                	jne    801f69 <__udivdi3+0x49>
  801f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f63:	31 d2                	xor    %edx,%edx
  801f65:	f7 f3                	div    %ebx
  801f67:	89 c1                	mov    %eax,%ecx
  801f69:	31 d2                	xor    %edx,%edx
  801f6b:	89 f0                	mov    %esi,%eax
  801f6d:	f7 f1                	div    %ecx
  801f6f:	89 c6                	mov    %eax,%esi
  801f71:	89 e8                	mov    %ebp,%eax
  801f73:	89 f7                	mov    %esi,%edi
  801f75:	f7 f1                	div    %ecx
  801f77:	89 fa                	mov    %edi,%edx
  801f79:	83 c4 1c             	add    $0x1c,%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    
  801f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f88:	39 f2                	cmp    %esi,%edx
  801f8a:	77 1c                	ja     801fa8 <__udivdi3+0x88>
  801f8c:	0f bd fa             	bsr    %edx,%edi
  801f8f:	83 f7 1f             	xor    $0x1f,%edi
  801f92:	75 2c                	jne    801fc0 <__udivdi3+0xa0>
  801f94:	39 f2                	cmp    %esi,%edx
  801f96:	72 06                	jb     801f9e <__udivdi3+0x7e>
  801f98:	31 c0                	xor    %eax,%eax
  801f9a:	39 eb                	cmp    %ebp,%ebx
  801f9c:	77 a9                	ja     801f47 <__udivdi3+0x27>
  801f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa3:	eb a2                	jmp    801f47 <__udivdi3+0x27>
  801fa5:	8d 76 00             	lea    0x0(%esi),%esi
  801fa8:	31 ff                	xor    %edi,%edi
  801faa:	31 c0                	xor    %eax,%eax
  801fac:	89 fa                	mov    %edi,%edx
  801fae:	83 c4 1c             	add    $0x1c,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fbd:	8d 76 00             	lea    0x0(%esi),%esi
  801fc0:	89 f9                	mov    %edi,%ecx
  801fc2:	b8 20 00 00 00       	mov    $0x20,%eax
  801fc7:	29 f8                	sub    %edi,%eax
  801fc9:	d3 e2                	shl    %cl,%edx
  801fcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fcf:	89 c1                	mov    %eax,%ecx
  801fd1:	89 da                	mov    %ebx,%edx
  801fd3:	d3 ea                	shr    %cl,%edx
  801fd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801fd9:	09 d1                	or     %edx,%ecx
  801fdb:	89 f2                	mov    %esi,%edx
  801fdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fe1:	89 f9                	mov    %edi,%ecx
  801fe3:	d3 e3                	shl    %cl,%ebx
  801fe5:	89 c1                	mov    %eax,%ecx
  801fe7:	d3 ea                	shr    %cl,%edx
  801fe9:	89 f9                	mov    %edi,%ecx
  801feb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fef:	89 eb                	mov    %ebp,%ebx
  801ff1:	d3 e6                	shl    %cl,%esi
  801ff3:	89 c1                	mov    %eax,%ecx
  801ff5:	d3 eb                	shr    %cl,%ebx
  801ff7:	09 de                	or     %ebx,%esi
  801ff9:	89 f0                	mov    %esi,%eax
  801ffb:	f7 74 24 08          	divl   0x8(%esp)
  801fff:	89 d6                	mov    %edx,%esi
  802001:	89 c3                	mov    %eax,%ebx
  802003:	f7 64 24 0c          	mull   0xc(%esp)
  802007:	39 d6                	cmp    %edx,%esi
  802009:	72 15                	jb     802020 <__udivdi3+0x100>
  80200b:	89 f9                	mov    %edi,%ecx
  80200d:	d3 e5                	shl    %cl,%ebp
  80200f:	39 c5                	cmp    %eax,%ebp
  802011:	73 04                	jae    802017 <__udivdi3+0xf7>
  802013:	39 d6                	cmp    %edx,%esi
  802015:	74 09                	je     802020 <__udivdi3+0x100>
  802017:	89 d8                	mov    %ebx,%eax
  802019:	31 ff                	xor    %edi,%edi
  80201b:	e9 27 ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  802020:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802023:	31 ff                	xor    %edi,%edi
  802025:	e9 1d ff ff ff       	jmp    801f47 <__udivdi3+0x27>
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <__umoddi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80203b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80203f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802047:	89 da                	mov    %ebx,%edx
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 43                	jne    802090 <__umoddi3+0x60>
  80204d:	39 df                	cmp    %ebx,%edi
  80204f:	76 17                	jbe    802068 <__umoddi3+0x38>
  802051:	89 f0                	mov    %esi,%eax
  802053:	f7 f7                	div    %edi
  802055:	89 d0                	mov    %edx,%eax
  802057:	31 d2                	xor    %edx,%edx
  802059:	83 c4 1c             	add    $0x1c,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5f                   	pop    %edi
  80205f:	5d                   	pop    %ebp
  802060:	c3                   	ret    
  802061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802068:	89 fd                	mov    %edi,%ebp
  80206a:	85 ff                	test   %edi,%edi
  80206c:	75 0b                	jne    802079 <__umoddi3+0x49>
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	f7 f7                	div    %edi
  802077:	89 c5                	mov    %eax,%ebp
  802079:	89 d8                	mov    %ebx,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f5                	div    %ebp
  80207f:	89 f0                	mov    %esi,%eax
  802081:	f7 f5                	div    %ebp
  802083:	89 d0                	mov    %edx,%eax
  802085:	eb d0                	jmp    802057 <__umoddi3+0x27>
  802087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80208e:	66 90                	xchg   %ax,%ax
  802090:	89 f1                	mov    %esi,%ecx
  802092:	39 d8                	cmp    %ebx,%eax
  802094:	76 0a                	jbe    8020a0 <__umoddi3+0x70>
  802096:	89 f0                	mov    %esi,%eax
  802098:	83 c4 1c             	add    $0x1c,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5f                   	pop    %edi
  80209e:	5d                   	pop    %ebp
  80209f:	c3                   	ret    
  8020a0:	0f bd e8             	bsr    %eax,%ebp
  8020a3:	83 f5 1f             	xor    $0x1f,%ebp
  8020a6:	75 20                	jne    8020c8 <__umoddi3+0x98>
  8020a8:	39 d8                	cmp    %ebx,%eax
  8020aa:	0f 82 b0 00 00 00    	jb     802160 <__umoddi3+0x130>
  8020b0:	39 f7                	cmp    %esi,%edi
  8020b2:	0f 86 a8 00 00 00    	jbe    802160 <__umoddi3+0x130>
  8020b8:	89 c8                	mov    %ecx,%eax
  8020ba:	83 c4 1c             	add    $0x1c,%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5f                   	pop    %edi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    
  8020c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020c8:	89 e9                	mov    %ebp,%ecx
  8020ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8020cf:	29 ea                	sub    %ebp,%edx
  8020d1:	d3 e0                	shl    %cl,%eax
  8020d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d7:	89 d1                	mov    %edx,%ecx
  8020d9:	89 f8                	mov    %edi,%eax
  8020db:	d3 e8                	shr    %cl,%eax
  8020dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020e9:	09 c1                	or     %eax,%ecx
  8020eb:	89 d8                	mov    %ebx,%eax
  8020ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f1:	89 e9                	mov    %ebp,%ecx
  8020f3:	d3 e7                	shl    %cl,%edi
  8020f5:	89 d1                	mov    %edx,%ecx
  8020f7:	d3 e8                	shr    %cl,%eax
  8020f9:	89 e9                	mov    %ebp,%ecx
  8020fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020ff:	d3 e3                	shl    %cl,%ebx
  802101:	89 c7                	mov    %eax,%edi
  802103:	89 d1                	mov    %edx,%ecx
  802105:	89 f0                	mov    %esi,%eax
  802107:	d3 e8                	shr    %cl,%eax
  802109:	89 e9                	mov    %ebp,%ecx
  80210b:	89 fa                	mov    %edi,%edx
  80210d:	d3 e6                	shl    %cl,%esi
  80210f:	09 d8                	or     %ebx,%eax
  802111:	f7 74 24 08          	divl   0x8(%esp)
  802115:	89 d1                	mov    %edx,%ecx
  802117:	89 f3                	mov    %esi,%ebx
  802119:	f7 64 24 0c          	mull   0xc(%esp)
  80211d:	89 c6                	mov    %eax,%esi
  80211f:	89 d7                	mov    %edx,%edi
  802121:	39 d1                	cmp    %edx,%ecx
  802123:	72 06                	jb     80212b <__umoddi3+0xfb>
  802125:	75 10                	jne    802137 <__umoddi3+0x107>
  802127:	39 c3                	cmp    %eax,%ebx
  802129:	73 0c                	jae    802137 <__umoddi3+0x107>
  80212b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80212f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802133:	89 d7                	mov    %edx,%edi
  802135:	89 c6                	mov    %eax,%esi
  802137:	89 ca                	mov    %ecx,%edx
  802139:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80213e:	29 f3                	sub    %esi,%ebx
  802140:	19 fa                	sbb    %edi,%edx
  802142:	89 d0                	mov    %edx,%eax
  802144:	d3 e0                	shl    %cl,%eax
  802146:	89 e9                	mov    %ebp,%ecx
  802148:	d3 eb                	shr    %cl,%ebx
  80214a:	d3 ea                	shr    %cl,%edx
  80214c:	09 d8                	or     %ebx,%eax
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80215d:	8d 76 00             	lea    0x0(%esi),%esi
  802160:	89 da                	mov    %ebx,%edx
  802162:	29 fe                	sub    %edi,%esi
  802164:	19 c2                	sbb    %eax,%edx
  802166:	89 f1                	mov    %esi,%ecx
  802168:	89 c8                	mov    %ecx,%eax
  80216a:	e9 4b ff ff ff       	jmp    8020ba <__umoddi3+0x8a>
