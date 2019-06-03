
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c5 00 00 00       	call   8000f6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 7d 15 00 00       	call   8015c9 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 50 80 00       	mov    0x805008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 40 2b 80 00       	push   $0x802b40
  800060:	e8 43 02 00 00       	call   8002a8 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 cd 12 00 00       	call   801337 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 07                	js     80007a <primeproc+0x47>
		panic("fork: %e", id);
	if (id == 0)
  800073:	74 ca                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800075:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800078:	eb 20                	jmp    80009a <primeproc+0x67>
		panic("fork: %e", id);
  80007a:	50                   	push   %eax
  80007b:	68 4c 2b 80 00       	push   $0x802b4c
  800080:	6a 1a                	push   $0x1a
  800082:	68 55 2b 80 00       	push   $0x802b55
  800087:	e8 26 01 00 00       	call   8001b2 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 9b 15 00 00       	call   801632 <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 22 15 00 00       	call   8015c9 <ipc_recv>
  8000a7:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000a9:	99                   	cltd   
  8000aa:	f7 fb                	idiv   %ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 d2                	test   %edx,%edx
  8000b1:	74 e7                	je     80009a <primeproc+0x67>
  8000b3:	eb d7                	jmp    80008c <primeproc+0x59>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 78 12 00 00       	call   801337 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1a                	js     8000df <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	74 25                	je     8000f1 <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000cc:	6a 00                	push   $0x0
  8000ce:	6a 00                	push   $0x0
  8000d0:	53                   	push   %ebx
  8000d1:	56                   	push   %esi
  8000d2:	e8 5b 15 00 00       	call   801632 <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 4c 2b 80 00       	push   $0x802b4c
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 55 2b 80 00       	push   $0x802b55
  8000ec:	e8 c1 00 00 00       	call   8001b2 <_panic>
		primeproc();
  8000f1:	e8 3d ff ff ff       	call   800033 <primeproc>

008000f6 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ff:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800106:	00 00 00 
	envid_t find = sys_getenvid();
  800109:	e8 ad 0c 00 00       	call   800dbb <sys_getenvid>
  80010e:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800114:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800119:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80011e:	bf 01 00 00 00       	mov    $0x1,%edi
  800123:	eb 0b                	jmp    800130 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800125:	83 c2 01             	add    $0x1,%edx
  800128:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80012e:	74 21                	je     800151 <libmain+0x5b>
		if(envs[i].env_id == find)
  800130:	89 d1                	mov    %edx,%ecx
  800132:	c1 e1 07             	shl    $0x7,%ecx
  800135:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80013b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80013e:	39 c1                	cmp    %eax,%ecx
  800140:	75 e3                	jne    800125 <libmain+0x2f>
  800142:	89 d3                	mov    %edx,%ebx
  800144:	c1 e3 07             	shl    $0x7,%ebx
  800147:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80014d:	89 fe                	mov    %edi,%esi
  80014f:	eb d4                	jmp    800125 <libmain+0x2f>
  800151:	89 f0                	mov    %esi,%eax
  800153:	84 c0                	test   %al,%al
  800155:	74 06                	je     80015d <libmain+0x67>
  800157:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800161:	7e 0a                	jle    80016d <libmain+0x77>
		binaryname = argv[0];
  800163:	8b 45 0c             	mov    0xc(%ebp),%eax
  800166:	8b 00                	mov    (%eax),%eax
  800168:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("call umain!\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 63 2b 80 00       	push   $0x802b63
  800175:	e8 2e 01 00 00       	call   8002a8 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017a:	83 c4 08             	add    $0x8,%esp
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	e8 2d ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  800188:	e8 0b 00 00 00       	call   800198 <exit>
}
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80019e:	e8 fa 16 00 00       	call   80189d <close_all>
	sys_env_destroy(0);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	6a 00                	push   $0x0
  8001a8:	e8 cd 0b 00 00       	call   800d7a <sys_env_destroy>
}
  8001ad:	83 c4 10             	add    $0x10,%esp
  8001b0:	c9                   	leave  
  8001b1:	c3                   	ret    

008001b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	56                   	push   %esi
  8001b6:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001b7:	a1 08 50 80 00       	mov    0x805008,%eax
  8001bc:	8b 40 48             	mov    0x48(%eax),%eax
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	68 ac 2b 80 00       	push   $0x802bac
  8001c7:	50                   	push   %eax
  8001c8:	68 7a 2b 80 00       	push   $0x802b7a
  8001cd:	e8 d6 00 00 00       	call   8002a8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d5:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001db:	e8 db 0b 00 00       	call   800dbb <sys_getenvid>
  8001e0:	83 c4 04             	add    $0x4,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	56                   	push   %esi
  8001ea:	50                   	push   %eax
  8001eb:	68 88 2b 80 00       	push   $0x802b88
  8001f0:	e8 b3 00 00 00       	call   8002a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f5:	83 c4 18             	add    $0x18,%esp
  8001f8:	53                   	push   %ebx
  8001f9:	ff 75 10             	pushl  0x10(%ebp)
  8001fc:	e8 56 00 00 00       	call   800257 <vcprintf>
	cprintf("\n");
  800201:	c7 04 24 6e 2b 80 00 	movl   $0x802b6e,(%esp)
  800208:	e8 9b 00 00 00       	call   8002a8 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800210:	cc                   	int3   
  800211:	eb fd                	jmp    800210 <_panic+0x5e>

00800213 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	53                   	push   %ebx
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021d:	8b 13                	mov    (%ebx),%edx
  80021f:	8d 42 01             	lea    0x1(%edx),%eax
  800222:	89 03                	mov    %eax,(%ebx)
  800224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800227:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800230:	74 09                	je     80023b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800232:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800236:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800239:	c9                   	leave  
  80023a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	68 ff 00 00 00       	push   $0xff
  800243:	8d 43 08             	lea    0x8(%ebx),%eax
  800246:	50                   	push   %eax
  800247:	e8 f1 0a 00 00       	call   800d3d <sys_cputs>
		b->idx = 0;
  80024c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	eb db                	jmp    800232 <putch+0x1f>

00800257 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800260:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800267:	00 00 00 
	b.cnt = 0;
  80026a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800271:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800280:	50                   	push   %eax
  800281:	68 13 02 80 00       	push   $0x800213
  800286:	e8 4a 01 00 00       	call   8003d5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028b:	83 c4 08             	add    $0x8,%esp
  80028e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800294:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029a:	50                   	push   %eax
  80029b:	e8 9d 0a 00 00       	call   800d3d <sys_cputs>

	return b.cnt;
}
  8002a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b1:	50                   	push   %eax
  8002b2:	ff 75 08             	pushl  0x8(%ebp)
  8002b5:	e8 9d ff ff ff       	call   800257 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	57                   	push   %edi
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 1c             	sub    $0x1c,%esp
  8002c5:	89 c6                	mov    %eax,%esi
  8002c7:	89 d7                	mov    %edx,%edi
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002db:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002df:	74 2c                	je     80030d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002f1:	39 c2                	cmp    %eax,%edx
  8002f3:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002f6:	73 43                	jae    80033b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002f8:	83 eb 01             	sub    $0x1,%ebx
  8002fb:	85 db                	test   %ebx,%ebx
  8002fd:	7e 6c                	jle    80036b <printnum+0xaf>
				putch(padc, putdat);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	57                   	push   %edi
  800303:	ff 75 18             	pushl  0x18(%ebp)
  800306:	ff d6                	call   *%esi
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	eb eb                	jmp    8002f8 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	6a 20                	push   $0x20
  800312:	6a 00                	push   $0x0
  800314:	50                   	push   %eax
  800315:	ff 75 e4             	pushl  -0x1c(%ebp)
  800318:	ff 75 e0             	pushl  -0x20(%ebp)
  80031b:	89 fa                	mov    %edi,%edx
  80031d:	89 f0                	mov    %esi,%eax
  80031f:	e8 98 ff ff ff       	call   8002bc <printnum>
		while (--width > 0)
  800324:	83 c4 20             	add    $0x20,%esp
  800327:	83 eb 01             	sub    $0x1,%ebx
  80032a:	85 db                	test   %ebx,%ebx
  80032c:	7e 65                	jle    800393 <printnum+0xd7>
			putch(padc, putdat);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	57                   	push   %edi
  800332:	6a 20                	push   $0x20
  800334:	ff d6                	call   *%esi
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	eb ec                	jmp    800327 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 18             	pushl  0x18(%ebp)
  800341:	83 eb 01             	sub    $0x1,%ebx
  800344:	53                   	push   %ebx
  800345:	50                   	push   %eax
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	ff 75 dc             	pushl  -0x24(%ebp)
  80034c:	ff 75 d8             	pushl  -0x28(%ebp)
  80034f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800352:	ff 75 e0             	pushl  -0x20(%ebp)
  800355:	e8 96 25 00 00       	call   8028f0 <__udivdi3>
  80035a:	83 c4 18             	add    $0x18,%esp
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	89 fa                	mov    %edi,%edx
  800361:	89 f0                	mov    %esi,%eax
  800363:	e8 54 ff ff ff       	call   8002bc <printnum>
  800368:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	57                   	push   %edi
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff 75 dc             	pushl  -0x24(%ebp)
  800375:	ff 75 d8             	pushl  -0x28(%ebp)
  800378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037b:	ff 75 e0             	pushl  -0x20(%ebp)
  80037e:	e8 7d 26 00 00       	call   802a00 <__umoddi3>
  800383:	83 c4 14             	add    $0x14,%esp
  800386:	0f be 80 b3 2b 80 00 	movsbl 0x802bb3(%eax),%eax
  80038d:	50                   	push   %eax
  80038e:	ff d6                	call   *%esi
  800390:	83 c4 10             	add    $0x10,%esp
	}
}
  800393:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800396:	5b                   	pop    %ebx
  800397:	5e                   	pop    %esi
  800398:	5f                   	pop    %edi
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    

0080039b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a5:	8b 10                	mov    (%eax),%edx
  8003a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8003aa:	73 0a                	jae    8003b6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003af:	89 08                	mov    %ecx,(%eax)
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	88 02                	mov    %al,(%edx)
}
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <printfmt>:
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003be:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c1:	50                   	push   %eax
  8003c2:	ff 75 10             	pushl  0x10(%ebp)
  8003c5:	ff 75 0c             	pushl  0xc(%ebp)
  8003c8:	ff 75 08             	pushl  0x8(%ebp)
  8003cb:	e8 05 00 00 00       	call   8003d5 <vprintfmt>
}
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <vprintfmt>:
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	57                   	push   %edi
  8003d9:	56                   	push   %esi
  8003da:	53                   	push   %ebx
  8003db:	83 ec 3c             	sub    $0x3c,%esp
  8003de:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003e7:	e9 32 04 00 00       	jmp    80081e <vprintfmt+0x449>
		padc = ' ';
  8003ec:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003f0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003f7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fe:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800405:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80040c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800413:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8d 47 01             	lea    0x1(%edi),%eax
  80041b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041e:	0f b6 17             	movzbl (%edi),%edx
  800421:	8d 42 dd             	lea    -0x23(%edx),%eax
  800424:	3c 55                	cmp    $0x55,%al
  800426:	0f 87 12 05 00 00    	ja     80093e <vprintfmt+0x569>
  80042c:	0f b6 c0             	movzbl %al,%eax
  80042f:	ff 24 85 a0 2d 80 00 	jmp    *0x802da0(,%eax,4)
  800436:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800439:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80043d:	eb d9                	jmp    800418 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800442:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800446:	eb d0                	jmp    800418 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800448:	0f b6 d2             	movzbl %dl,%edx
  80044b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80044e:	b8 00 00 00 00       	mov    $0x0,%eax
  800453:	89 75 08             	mov    %esi,0x8(%ebp)
  800456:	eb 03                	jmp    80045b <vprintfmt+0x86>
  800458:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80045b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80045e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800462:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800465:	8d 72 d0             	lea    -0x30(%edx),%esi
  800468:	83 fe 09             	cmp    $0x9,%esi
  80046b:	76 eb                	jbe    800458 <vprintfmt+0x83>
  80046d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800470:	8b 75 08             	mov    0x8(%ebp),%esi
  800473:	eb 14                	jmp    800489 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800475:	8b 45 14             	mov    0x14(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8d 40 04             	lea    0x4(%eax),%eax
  800483:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800489:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048d:	79 89                	jns    800418 <vprintfmt+0x43>
				width = precision, precision = -1;
  80048f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800492:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800495:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049c:	e9 77 ff ff ff       	jmp    800418 <vprintfmt+0x43>
  8004a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	0f 48 c1             	cmovs  %ecx,%eax
  8004a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004af:	e9 64 ff ff ff       	jmp    800418 <vprintfmt+0x43>
  8004b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004b7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004be:	e9 55 ff ff ff       	jmp    800418 <vprintfmt+0x43>
			lflag++;
  8004c3:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ca:	e9 49 ff ff ff       	jmp    800418 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8d 78 04             	lea    0x4(%eax),%edi
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	ff 30                	pushl  (%eax)
  8004db:	ff d6                	call   *%esi
			break;
  8004dd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004e0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004e3:	e9 33 03 00 00       	jmp    80081b <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 78 04             	lea    0x4(%eax),%edi
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	99                   	cltd   
  8004f1:	31 d0                	xor    %edx,%eax
  8004f3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f5:	83 f8 10             	cmp    $0x10,%eax
  8004f8:	7f 23                	jg     80051d <vprintfmt+0x148>
  8004fa:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  800501:	85 d2                	test   %edx,%edx
  800503:	74 18                	je     80051d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800505:	52                   	push   %edx
  800506:	68 31 31 80 00       	push   $0x803131
  80050b:	53                   	push   %ebx
  80050c:	56                   	push   %esi
  80050d:	e8 a6 fe ff ff       	call   8003b8 <printfmt>
  800512:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800515:	89 7d 14             	mov    %edi,0x14(%ebp)
  800518:	e9 fe 02 00 00       	jmp    80081b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80051d:	50                   	push   %eax
  80051e:	68 cb 2b 80 00       	push   $0x802bcb
  800523:	53                   	push   %ebx
  800524:	56                   	push   %esi
  800525:	e8 8e fe ff ff       	call   8003b8 <printfmt>
  80052a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800530:	e9 e6 02 00 00       	jmp    80081b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	83 c0 04             	add    $0x4,%eax
  80053b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80053e:	8b 45 14             	mov    0x14(%ebp),%eax
  800541:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800543:	85 c9                	test   %ecx,%ecx
  800545:	b8 c4 2b 80 00       	mov    $0x802bc4,%eax
  80054a:	0f 45 c1             	cmovne %ecx,%eax
  80054d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800550:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800554:	7e 06                	jle    80055c <vprintfmt+0x187>
  800556:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80055a:	75 0d                	jne    800569 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055f:	89 c7                	mov    %eax,%edi
  800561:	03 45 e0             	add    -0x20(%ebp),%eax
  800564:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800567:	eb 53                	jmp    8005bc <vprintfmt+0x1e7>
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	ff 75 d8             	pushl  -0x28(%ebp)
  80056f:	50                   	push   %eax
  800570:	e8 71 04 00 00       	call   8009e6 <strnlen>
  800575:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800578:	29 c1                	sub    %eax,%ecx
  80057a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800582:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800589:	eb 0f                	jmp    80059a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	ff 75 e0             	pushl  -0x20(%ebp)
  800592:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800594:	83 ef 01             	sub    $0x1,%edi
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	85 ff                	test   %edi,%edi
  80059c:	7f ed                	jg     80058b <vprintfmt+0x1b6>
  80059e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	0f 49 c1             	cmovns %ecx,%eax
  8005ab:	29 c1                	sub    %eax,%ecx
  8005ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005b0:	eb aa                	jmp    80055c <vprintfmt+0x187>
					putch(ch, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	52                   	push   %edx
  8005b7:	ff d6                	call   *%esi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 c7 01             	add    $0x1,%edi
  8005c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c8:	0f be d0             	movsbl %al,%edx
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 4b                	je     80061a <vprintfmt+0x245>
  8005cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d3:	78 06                	js     8005db <vprintfmt+0x206>
  8005d5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d9:	78 1e                	js     8005f9 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005db:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005df:	74 d1                	je     8005b2 <vprintfmt+0x1dd>
  8005e1:	0f be c0             	movsbl %al,%eax
  8005e4:	83 e8 20             	sub    $0x20,%eax
  8005e7:	83 f8 5e             	cmp    $0x5e,%eax
  8005ea:	76 c6                	jbe    8005b2 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 3f                	push   $0x3f
  8005f2:	ff d6                	call   *%esi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	eb c3                	jmp    8005bc <vprintfmt+0x1e7>
  8005f9:	89 cf                	mov    %ecx,%edi
  8005fb:	eb 0e                	jmp    80060b <vprintfmt+0x236>
				putch(' ', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	6a 20                	push   $0x20
  800603:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	85 ff                	test   %edi,%edi
  80060d:	7f ee                	jg     8005fd <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80060f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	e9 01 02 00 00       	jmp    80081b <vprintfmt+0x446>
  80061a:	89 cf                	mov    %ecx,%edi
  80061c:	eb ed                	jmp    80060b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80061e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800621:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800628:	e9 eb fd ff ff       	jmp    800418 <vprintfmt+0x43>
	if (lflag >= 2)
  80062d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800631:	7f 21                	jg     800654 <vprintfmt+0x27f>
	else if (lflag)
  800633:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800637:	74 68                	je     8006a1 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800641:	89 c1                	mov    %eax,%ecx
  800643:	c1 f9 1f             	sar    $0x1f,%ecx
  800646:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	eb 17                	jmp    80066b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80065f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 08             	lea    0x8(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80066b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800677:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80067b:	78 3f                	js     8006bc <vprintfmt+0x2e7>
			base = 10;
  80067d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800682:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800686:	0f 84 71 01 00 00    	je     8007fd <vprintfmt+0x428>
				putch('+', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 2b                	push   $0x2b
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800697:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069c:	e9 5c 01 00 00       	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ae:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ba:	eb af                	jmp    80066b <vprintfmt+0x296>
				putch('-', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 2d                	push   $0x2d
  8006c2:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ca:	f7 d8                	neg    %eax
  8006cc:	83 d2 00             	adc    $0x0,%edx
  8006cf:	f7 da                	neg    %edx
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 19 01 00 00       	jmp    8007fd <vprintfmt+0x428>
	if (lflag >= 2)
  8006e4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e8:	7f 29                	jg     800713 <vprintfmt+0x33e>
	else if (lflag)
  8006ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ee:	74 44                	je     800734 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800709:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070e:	e9 ea 00 00 00       	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 50 04             	mov    0x4(%eax),%edx
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 40 08             	lea    0x8(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072f:	e9 c9 00 00 00       	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
  80073e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800741:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8d 40 04             	lea    0x4(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800752:	e9 a6 00 00 00       	jmp    8007fd <vprintfmt+0x428>
			putch('0', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	6a 30                	push   $0x30
  80075d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800766:	7f 26                	jg     80078e <vprintfmt+0x3b9>
	else if (lflag)
  800768:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80076c:	74 3e                	je     8007ac <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 40 04             	lea    0x4(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800787:	b8 08 00 00 00       	mov    $0x8,%eax
  80078c:	eb 6f                	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 50 04             	mov    0x4(%eax),%edx
  800794:	8b 00                	mov    (%eax),%eax
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 08             	lea    0x8(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007aa:	eb 51                	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8d 40 04             	lea    0x4(%eax),%eax
  8007c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ca:	eb 31                	jmp    8007fd <vprintfmt+0x428>
			putch('0', putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 30                	push   $0x30
  8007d2:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d4:	83 c4 08             	add    $0x8,%esp
  8007d7:	53                   	push   %ebx
  8007d8:	6a 78                	push   $0x78
  8007da:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ec:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007fd:	83 ec 0c             	sub    $0xc,%esp
  800800:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800804:	52                   	push   %edx
  800805:	ff 75 e0             	pushl  -0x20(%ebp)
  800808:	50                   	push   %eax
  800809:	ff 75 dc             	pushl  -0x24(%ebp)
  80080c:	ff 75 d8             	pushl  -0x28(%ebp)
  80080f:	89 da                	mov    %ebx,%edx
  800811:	89 f0                	mov    %esi,%eax
  800813:	e8 a4 fa ff ff       	call   8002bc <printnum>
			break;
  800818:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80081b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081e:	83 c7 01             	add    $0x1,%edi
  800821:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800825:	83 f8 25             	cmp    $0x25,%eax
  800828:	0f 84 be fb ff ff    	je     8003ec <vprintfmt+0x17>
			if (ch == '\0')
  80082e:	85 c0                	test   %eax,%eax
  800830:	0f 84 28 01 00 00    	je     80095e <vprintfmt+0x589>
			putch(ch, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	53                   	push   %ebx
  80083a:	50                   	push   %eax
  80083b:	ff d6                	call   *%esi
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	eb dc                	jmp    80081e <vprintfmt+0x449>
	if (lflag >= 2)
  800842:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800846:	7f 26                	jg     80086e <vprintfmt+0x499>
	else if (lflag)
  800848:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80084c:	74 41                	je     80088f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
  800858:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800867:	b8 10 00 00 00       	mov    $0x10,%eax
  80086c:	eb 8f                	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	8b 50 04             	mov    0x4(%eax),%edx
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	8d 40 08             	lea    0x8(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800885:	b8 10 00 00 00       	mov    $0x10,%eax
  80088a:	e9 6e ff ff ff       	jmp    8007fd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
  800899:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8d 40 04             	lea    0x4(%eax),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ad:	e9 4b ff ff ff       	jmp    8007fd <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 14                	je     8008d8 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008c4:	8b 13                	mov    (%ebx),%edx
  8008c6:	83 fa 7f             	cmp    $0x7f,%edx
  8008c9:	7f 37                	jg     800902 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008cb:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d3:	e9 43 ff ff ff       	jmp    80081b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008dd:	bf e9 2c 80 00       	mov    $0x802ce9,%edi
							putch(ch, putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	53                   	push   %ebx
  8008e6:	50                   	push   %eax
  8008e7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e9:	83 c7 01             	add    $0x1,%edi
  8008ec:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	75 eb                	jne    8008e2 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	e9 19 ff ff ff       	jmp    80081b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800902:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800904:	b8 0a 00 00 00       	mov    $0xa,%eax
  800909:	bf 21 2d 80 00       	mov    $0x802d21,%edi
							putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	53                   	push   %ebx
  800912:	50                   	push   %eax
  800913:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800915:	83 c7 01             	add    $0x1,%edi
  800918:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	85 c0                	test   %eax,%eax
  800921:	75 eb                	jne    80090e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800923:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800926:	89 45 14             	mov    %eax,0x14(%ebp)
  800929:	e9 ed fe ff ff       	jmp    80081b <vprintfmt+0x446>
			putch(ch, putdat);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	53                   	push   %ebx
  800932:	6a 25                	push   $0x25
  800934:	ff d6                	call   *%esi
			break;
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	e9 dd fe ff ff       	jmp    80081b <vprintfmt+0x446>
			putch('%', putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	53                   	push   %ebx
  800942:	6a 25                	push   $0x25
  800944:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	89 f8                	mov    %edi,%eax
  80094b:	eb 03                	jmp    800950 <vprintfmt+0x57b>
  80094d:	83 e8 01             	sub    $0x1,%eax
  800950:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800954:	75 f7                	jne    80094d <vprintfmt+0x578>
  800956:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800959:	e9 bd fe ff ff       	jmp    80081b <vprintfmt+0x446>
}
  80095e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800961:	5b                   	pop    %ebx
  800962:	5e                   	pop    %esi
  800963:	5f                   	pop    %edi
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	83 ec 18             	sub    $0x18,%esp
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800972:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800975:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800979:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80097c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800983:	85 c0                	test   %eax,%eax
  800985:	74 26                	je     8009ad <vsnprintf+0x47>
  800987:	85 d2                	test   %edx,%edx
  800989:	7e 22                	jle    8009ad <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098b:	ff 75 14             	pushl  0x14(%ebp)
  80098e:	ff 75 10             	pushl  0x10(%ebp)
  800991:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800994:	50                   	push   %eax
  800995:	68 9b 03 80 00       	push   $0x80039b
  80099a:	e8 36 fa ff ff       	call   8003d5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80099f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a8:	83 c4 10             	add    $0x10,%esp
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    
		return -E_INVAL;
  8009ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009b2:	eb f7                	jmp    8009ab <vsnprintf+0x45>

008009b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009bd:	50                   	push   %eax
  8009be:	ff 75 10             	pushl  0x10(%ebp)
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	ff 75 08             	pushl  0x8(%ebp)
  8009c7:	e8 9a ff ff ff       	call   800966 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009cc:	c9                   	leave  
  8009cd:	c3                   	ret    

008009ce <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009dd:	74 05                	je     8009e4 <strlen+0x16>
		n++;
  8009df:	83 c0 01             	add    $0x1,%eax
  8009e2:	eb f5                	jmp    8009d9 <strlen+0xb>
	return n;
}
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f4:	39 c2                	cmp    %eax,%edx
  8009f6:	74 0d                	je     800a05 <strnlen+0x1f>
  8009f8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009fc:	74 05                	je     800a03 <strnlen+0x1d>
		n++;
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	eb f1                	jmp    8009f4 <strnlen+0xe>
  800a03:	89 d0                	mov    %edx,%eax
	return n;
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	53                   	push   %ebx
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a11:	ba 00 00 00 00       	mov    $0x0,%edx
  800a16:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a1a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a1d:	83 c2 01             	add    $0x1,%edx
  800a20:	84 c9                	test   %cl,%cl
  800a22:	75 f2                	jne    800a16 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a24:	5b                   	pop    %ebx
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 10             	sub    $0x10,%esp
  800a2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a31:	53                   	push   %ebx
  800a32:	e8 97 ff ff ff       	call   8009ce <strlen>
  800a37:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	01 d8                	add    %ebx,%eax
  800a3f:	50                   	push   %eax
  800a40:	e8 c2 ff ff ff       	call   800a07 <strcpy>
	return dst;
}
  800a45:	89 d8                	mov    %ebx,%eax
  800a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	56                   	push   %esi
  800a50:	53                   	push   %ebx
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a57:	89 c6                	mov    %eax,%esi
  800a59:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a5c:	89 c2                	mov    %eax,%edx
  800a5e:	39 f2                	cmp    %esi,%edx
  800a60:	74 11                	je     800a73 <strncpy+0x27>
		*dst++ = *src;
  800a62:	83 c2 01             	add    $0x1,%edx
  800a65:	0f b6 19             	movzbl (%ecx),%ebx
  800a68:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a6b:	80 fb 01             	cmp    $0x1,%bl
  800a6e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a71:	eb eb                	jmp    800a5e <strncpy+0x12>
	}
	return ret;
}
  800a73:	5b                   	pop    %ebx
  800a74:	5e                   	pop    %esi
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a82:	8b 55 10             	mov    0x10(%ebp),%edx
  800a85:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a87:	85 d2                	test   %edx,%edx
  800a89:	74 21                	je     800aac <strlcpy+0x35>
  800a8b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a8f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a91:	39 c2                	cmp    %eax,%edx
  800a93:	74 14                	je     800aa9 <strlcpy+0x32>
  800a95:	0f b6 19             	movzbl (%ecx),%ebx
  800a98:	84 db                	test   %bl,%bl
  800a9a:	74 0b                	je     800aa7 <strlcpy+0x30>
			*dst++ = *src++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aa5:	eb ea                	jmp    800a91 <strlcpy+0x1a>
  800aa7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aa9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aac:	29 f0                	sub    %esi,%eax
}
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800abb:	0f b6 01             	movzbl (%ecx),%eax
  800abe:	84 c0                	test   %al,%al
  800ac0:	74 0c                	je     800ace <strcmp+0x1c>
  800ac2:	3a 02                	cmp    (%edx),%al
  800ac4:	75 08                	jne    800ace <strcmp+0x1c>
		p++, q++;
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	83 c2 01             	add    $0x1,%edx
  800acc:	eb ed                	jmp    800abb <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ace:	0f b6 c0             	movzbl %al,%eax
  800ad1:	0f b6 12             	movzbl (%edx),%edx
  800ad4:	29 d0                	sub    %edx,%eax
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	53                   	push   %ebx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae2:	89 c3                	mov    %eax,%ebx
  800ae4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ae7:	eb 06                	jmp    800aef <strncmp+0x17>
		n--, p++, q++;
  800ae9:	83 c0 01             	add    $0x1,%eax
  800aec:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aef:	39 d8                	cmp    %ebx,%eax
  800af1:	74 16                	je     800b09 <strncmp+0x31>
  800af3:	0f b6 08             	movzbl (%eax),%ecx
  800af6:	84 c9                	test   %cl,%cl
  800af8:	74 04                	je     800afe <strncmp+0x26>
  800afa:	3a 0a                	cmp    (%edx),%cl
  800afc:	74 eb                	je     800ae9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800afe:	0f b6 00             	movzbl (%eax),%eax
  800b01:	0f b6 12             	movzbl (%edx),%edx
  800b04:	29 d0                	sub    %edx,%eax
}
  800b06:	5b                   	pop    %ebx
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    
		return 0;
  800b09:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0e:	eb f6                	jmp    800b06 <strncmp+0x2e>

00800b10 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1a:	0f b6 10             	movzbl (%eax),%edx
  800b1d:	84 d2                	test   %dl,%dl
  800b1f:	74 09                	je     800b2a <strchr+0x1a>
		if (*s == c)
  800b21:	38 ca                	cmp    %cl,%dl
  800b23:	74 0a                	je     800b2f <strchr+0x1f>
	for (; *s; s++)
  800b25:	83 c0 01             	add    $0x1,%eax
  800b28:	eb f0                	jmp    800b1a <strchr+0xa>
			return (char *) s;
	return 0;
  800b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b3e:	38 ca                	cmp    %cl,%dl
  800b40:	74 09                	je     800b4b <strfind+0x1a>
  800b42:	84 d2                	test   %dl,%dl
  800b44:	74 05                	je     800b4b <strfind+0x1a>
	for (; *s; s++)
  800b46:	83 c0 01             	add    $0x1,%eax
  800b49:	eb f0                	jmp    800b3b <strfind+0xa>
			break;
	return (char *) s;
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	57                   	push   %edi
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b59:	85 c9                	test   %ecx,%ecx
  800b5b:	74 31                	je     800b8e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b5d:	89 f8                	mov    %edi,%eax
  800b5f:	09 c8                	or     %ecx,%eax
  800b61:	a8 03                	test   $0x3,%al
  800b63:	75 23                	jne    800b88 <memset+0x3b>
		c &= 0xFF;
  800b65:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b69:	89 d3                	mov    %edx,%ebx
  800b6b:	c1 e3 08             	shl    $0x8,%ebx
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	c1 e0 18             	shl    $0x18,%eax
  800b73:	89 d6                	mov    %edx,%esi
  800b75:	c1 e6 10             	shl    $0x10,%esi
  800b78:	09 f0                	or     %esi,%eax
  800b7a:	09 c2                	or     %eax,%edx
  800b7c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b7e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b81:	89 d0                	mov    %edx,%eax
  800b83:	fc                   	cld    
  800b84:	f3 ab                	rep stos %eax,%es:(%edi)
  800b86:	eb 06                	jmp    800b8e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	fc                   	cld    
  800b8c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8e:	89 f8                	mov    %edi,%eax
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba3:	39 c6                	cmp    %eax,%esi
  800ba5:	73 32                	jae    800bd9 <memmove+0x44>
  800ba7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	76 2b                	jbe    800bd9 <memmove+0x44>
		s += n;
		d += n;
  800bae:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb1:	89 fe                	mov    %edi,%esi
  800bb3:	09 ce                	or     %ecx,%esi
  800bb5:	09 d6                	or     %edx,%esi
  800bb7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bbd:	75 0e                	jne    800bcd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bbf:	83 ef 04             	sub    $0x4,%edi
  800bc2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bc8:	fd                   	std    
  800bc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcb:	eb 09                	jmp    800bd6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bcd:	83 ef 01             	sub    $0x1,%edi
  800bd0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bd3:	fd                   	std    
  800bd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd6:	fc                   	cld    
  800bd7:	eb 1a                	jmp    800bf3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	09 ca                	or     %ecx,%edx
  800bdd:	09 f2                	or     %esi,%edx
  800bdf:	f6 c2 03             	test   $0x3,%dl
  800be2:	75 0a                	jne    800bee <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800be4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800be7:	89 c7                	mov    %eax,%edi
  800be9:	fc                   	cld    
  800bea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bec:	eb 05                	jmp    800bf3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bee:	89 c7                	mov    %eax,%edi
  800bf0:	fc                   	cld    
  800bf1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bfd:	ff 75 10             	pushl  0x10(%ebp)
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	ff 75 08             	pushl  0x8(%ebp)
  800c06:	e8 8a ff ff ff       	call   800b95 <memmove>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 c6                	mov    %eax,%esi
  800c1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1d:	39 f0                	cmp    %esi,%eax
  800c1f:	74 1c                	je     800c3d <memcmp+0x30>
		if (*s1 != *s2)
  800c21:	0f b6 08             	movzbl (%eax),%ecx
  800c24:	0f b6 1a             	movzbl (%edx),%ebx
  800c27:	38 d9                	cmp    %bl,%cl
  800c29:	75 08                	jne    800c33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c2b:	83 c0 01             	add    $0x1,%eax
  800c2e:	83 c2 01             	add    $0x1,%edx
  800c31:	eb ea                	jmp    800c1d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c33:	0f b6 c1             	movzbl %cl,%eax
  800c36:	0f b6 db             	movzbl %bl,%ebx
  800c39:	29 d8                	sub    %ebx,%eax
  800c3b:	eb 05                	jmp    800c42 <memcmp+0x35>
	}

	return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c54:	39 d0                	cmp    %edx,%eax
  800c56:	73 09                	jae    800c61 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c58:	38 08                	cmp    %cl,(%eax)
  800c5a:	74 05                	je     800c61 <memfind+0x1b>
	for (; s < ends; s++)
  800c5c:	83 c0 01             	add    $0x1,%eax
  800c5f:	eb f3                	jmp    800c54 <memfind+0xe>
			break;
	return (void *) s;
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6f:	eb 03                	jmp    800c74 <strtol+0x11>
		s++;
  800c71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c74:	0f b6 01             	movzbl (%ecx),%eax
  800c77:	3c 20                	cmp    $0x20,%al
  800c79:	74 f6                	je     800c71 <strtol+0xe>
  800c7b:	3c 09                	cmp    $0x9,%al
  800c7d:	74 f2                	je     800c71 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c7f:	3c 2b                	cmp    $0x2b,%al
  800c81:	74 2a                	je     800cad <strtol+0x4a>
	int neg = 0;
  800c83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c88:	3c 2d                	cmp    $0x2d,%al
  800c8a:	74 2b                	je     800cb7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c92:	75 0f                	jne    800ca3 <strtol+0x40>
  800c94:	80 39 30             	cmpb   $0x30,(%ecx)
  800c97:	74 28                	je     800cc1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c99:	85 db                	test   %ebx,%ebx
  800c9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ca0:	0f 44 d8             	cmove  %eax,%ebx
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cab:	eb 50                	jmp    800cfd <strtol+0x9a>
		s++;
  800cad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb5:	eb d5                	jmp    800c8c <strtol+0x29>
		s++, neg = 1;
  800cb7:	83 c1 01             	add    $0x1,%ecx
  800cba:	bf 01 00 00 00       	mov    $0x1,%edi
  800cbf:	eb cb                	jmp    800c8c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cc5:	74 0e                	je     800cd5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cc7:	85 db                	test   %ebx,%ebx
  800cc9:	75 d8                	jne    800ca3 <strtol+0x40>
		s++, base = 8;
  800ccb:	83 c1 01             	add    $0x1,%ecx
  800cce:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cd3:	eb ce                	jmp    800ca3 <strtol+0x40>
		s += 2, base = 16;
  800cd5:	83 c1 02             	add    $0x2,%ecx
  800cd8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cdd:	eb c4                	jmp    800ca3 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cdf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ce2:	89 f3                	mov    %esi,%ebx
  800ce4:	80 fb 19             	cmp    $0x19,%bl
  800ce7:	77 29                	ja     800d12 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ce9:	0f be d2             	movsbl %dl,%edx
  800cec:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cef:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cf2:	7d 30                	jge    800d24 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cf4:	83 c1 01             	add    $0x1,%ecx
  800cf7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cfb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cfd:	0f b6 11             	movzbl (%ecx),%edx
  800d00:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d03:	89 f3                	mov    %esi,%ebx
  800d05:	80 fb 09             	cmp    $0x9,%bl
  800d08:	77 d5                	ja     800cdf <strtol+0x7c>
			dig = *s - '0';
  800d0a:	0f be d2             	movsbl %dl,%edx
  800d0d:	83 ea 30             	sub    $0x30,%edx
  800d10:	eb dd                	jmp    800cef <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d15:	89 f3                	mov    %esi,%ebx
  800d17:	80 fb 19             	cmp    $0x19,%bl
  800d1a:	77 08                	ja     800d24 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d1c:	0f be d2             	movsbl %dl,%edx
  800d1f:	83 ea 37             	sub    $0x37,%edx
  800d22:	eb cb                	jmp    800cef <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d28:	74 05                	je     800d2f <strtol+0xcc>
		*endptr = (char *) s;
  800d2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d2f:	89 c2                	mov    %eax,%edx
  800d31:	f7 da                	neg    %edx
  800d33:	85 ff                	test   %edi,%edi
  800d35:	0f 45 c2             	cmovne %edx,%eax
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d43:	b8 00 00 00 00       	mov    $0x0,%eax
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	89 c3                	mov    %eax,%ebx
  800d50:	89 c7                	mov    %eax,%edi
  800d52:	89 c6                	mov    %eax,%esi
  800d54:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d61:	ba 00 00 00 00       	mov    $0x0,%edx
  800d66:	b8 01 00 00 00       	mov    $0x1,%eax
  800d6b:	89 d1                	mov    %edx,%ecx
  800d6d:	89 d3                	mov    %edx,%ebx
  800d6f:	89 d7                	mov    %edx,%edi
  800d71:	89 d6                	mov    %edx,%esi
  800d73:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d90:	89 cb                	mov    %ecx,%ebx
  800d92:	89 cf                	mov    %ecx,%edi
  800d94:	89 ce                	mov    %ecx,%esi
  800d96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	7f 08                	jg     800da4 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	50                   	push   %eax
  800da8:	6a 03                	push   $0x3
  800daa:	68 44 2f 80 00       	push   $0x802f44
  800daf:	6a 43                	push   $0x43
  800db1:	68 61 2f 80 00       	push   $0x802f61
  800db6:	e8 f7 f3 ff ff       	call   8001b2 <_panic>

00800dbb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dcb:	89 d1                	mov    %edx,%ecx
  800dcd:	89 d3                	mov    %edx,%ebx
  800dcf:	89 d7                	mov    %edx,%edi
  800dd1:	89 d6                	mov    %edx,%esi
  800dd3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <sys_yield>:

void
sys_yield(void)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de0:	ba 00 00 00 00       	mov    $0x0,%edx
  800de5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dea:	89 d1                	mov    %edx,%ecx
  800dec:	89 d3                	mov    %edx,%ebx
  800dee:	89 d7                	mov    %edx,%edi
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e02:	be 00 00 00 00       	mov    $0x0,%esi
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e15:	89 f7                	mov    %esi,%edi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 04                	push   $0x4
  800e2b:	68 44 2f 80 00       	push   $0x802f44
  800e30:	6a 43                	push   $0x43
  800e32:	68 61 2f 80 00       	push   $0x802f61
  800e37:	e8 76 f3 ff ff       	call   8001b2 <_panic>

00800e3c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
  800e42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 05 00 00 00       	mov    $0x5,%eax
  800e50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e53:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e56:	8b 75 18             	mov    0x18(%ebp),%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 05                	push   $0x5
  800e6d:	68 44 2f 80 00       	push   $0x802f44
  800e72:	6a 43                	push   $0x43
  800e74:	68 61 2f 80 00       	push   $0x802f61
  800e79:	e8 34 f3 ff ff       	call   8001b2 <_panic>

00800e7e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	b8 06 00 00 00       	mov    $0x6,%eax
  800e97:	89 df                	mov    %ebx,%edi
  800e99:	89 de                	mov    %ebx,%esi
  800e9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	7f 08                	jg     800ea9 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea9:	83 ec 0c             	sub    $0xc,%esp
  800eac:	50                   	push   %eax
  800ead:	6a 06                	push   $0x6
  800eaf:	68 44 2f 80 00       	push   $0x802f44
  800eb4:	6a 43                	push   $0x43
  800eb6:	68 61 2f 80 00       	push   $0x802f61
  800ebb:	e8 f2 f2 ff ff       	call   8001b2 <_panic>

00800ec0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed9:	89 df                	mov    %ebx,%edi
  800edb:	89 de                	mov    %ebx,%esi
  800edd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7f 08                	jg     800eeb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	50                   	push   %eax
  800eef:	6a 08                	push   $0x8
  800ef1:	68 44 2f 80 00       	push   $0x802f44
  800ef6:	6a 43                	push   $0x43
  800ef8:	68 61 2f 80 00       	push   $0x802f61
  800efd:	e8 b0 f2 ff ff       	call   8001b2 <_panic>

00800f02 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 09 00 00 00       	mov    $0x9,%eax
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 09                	push   $0x9
  800f33:	68 44 2f 80 00       	push   $0x802f44
  800f38:	6a 43                	push   $0x43
  800f3a:	68 61 2f 80 00       	push   $0x802f61
  800f3f:	e8 6e f2 ff ff       	call   8001b2 <_panic>

00800f44 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5d:	89 df                	mov    %ebx,%edi
  800f5f:	89 de                	mov    %ebx,%esi
  800f61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f63:	85 c0                	test   %eax,%eax
  800f65:	7f 08                	jg     800f6f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	50                   	push   %eax
  800f73:	6a 0a                	push   $0xa
  800f75:	68 44 2f 80 00       	push   $0x802f44
  800f7a:	6a 43                	push   $0x43
  800f7c:	68 61 2f 80 00       	push   $0x802f61
  800f81:	e8 2c f2 ff ff       	call   8001b2 <_panic>

00800f86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f92:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f97:	be 00 00 00 00       	mov    $0x0,%esi
  800f9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fba:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fbf:	89 cb                	mov    %ecx,%ebx
  800fc1:	89 cf                	mov    %ecx,%edi
  800fc3:	89 ce                	mov    %ecx,%esi
  800fc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7f 08                	jg     800fd3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fce:	5b                   	pop    %ebx
  800fcf:	5e                   	pop    %esi
  800fd0:	5f                   	pop    %edi
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	50                   	push   %eax
  800fd7:	6a 0d                	push   $0xd
  800fd9:	68 44 2f 80 00       	push   $0x802f44
  800fde:	6a 43                	push   $0x43
  800fe0:	68 61 2f 80 00       	push   $0x802f61
  800fe5:	e8 c8 f1 ff ff       	call   8001b2 <_panic>

00800fea <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 0e 00 00 00       	mov    $0xe,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
	asm volatile("int %1\n"
  801011:	b9 00 00 00 00       	mov    $0x0,%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	b8 0f 00 00 00       	mov    $0xf,%eax
  80101e:	89 cb                	mov    %ecx,%ebx
  801020:	89 cf                	mov    %ecx,%edi
  801022:	89 ce                	mov    %ecx,%esi
  801024:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	asm volatile("int %1\n"
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	b8 10 00 00 00       	mov    $0x10,%eax
  80103b:	89 d1                	mov    %edx,%ecx
  80103d:	89 d3                	mov    %edx,%ebx
  80103f:	89 d7                	mov    %edx,%edi
  801041:	89 d6                	mov    %edx,%esi
  801043:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801050:	bb 00 00 00 00       	mov    $0x0,%ebx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	b8 11 00 00 00       	mov    $0x11,%eax
  801060:	89 df                	mov    %ebx,%edi
  801062:	89 de                	mov    %ebx,%esi
  801064:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
	asm volatile("int %1\n"
  801071:	bb 00 00 00 00       	mov    $0x0,%ebx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107c:	b8 12 00 00 00       	mov    $0x12,%eax
  801081:	89 df                	mov    %ebx,%edi
  801083:	89 de                	mov    %ebx,%esi
  801085:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801087:	5b                   	pop    %ebx
  801088:	5e                   	pop    %esi
  801089:	5f                   	pop    %edi
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	57                   	push   %edi
  801090:	56                   	push   %esi
  801091:	53                   	push   %ebx
  801092:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801095:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109a:	8b 55 08             	mov    0x8(%ebp),%edx
  80109d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a0:	b8 13 00 00 00       	mov    $0x13,%eax
  8010a5:	89 df                	mov    %ebx,%edi
  8010a7:	89 de                	mov    %ebx,%esi
  8010a9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	7f 08                	jg     8010b7 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b7:	83 ec 0c             	sub    $0xc,%esp
  8010ba:	50                   	push   %eax
  8010bb:	6a 13                	push   $0x13
  8010bd:	68 44 2f 80 00       	push   $0x802f44
  8010c2:	6a 43                	push   $0x43
  8010c4:	68 61 2f 80 00       	push   $0x802f61
  8010c9:	e8 e4 f0 ff ff       	call   8001b2 <_panic>

008010ce <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 04             	sub    $0x4,%esp
  8010d5:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8010d8:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8010da:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8010de:	0f 84 99 00 00 00    	je     80117d <pgfault+0xaf>
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 ea 16             	shr    $0x16,%edx
  8010e9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010f0:	f6 c2 01             	test   $0x1,%dl
  8010f3:	0f 84 84 00 00 00    	je     80117d <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 0c             	shr    $0xc,%edx
  8010fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801105:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80110b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801111:	75 6a                	jne    80117d <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  801113:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801118:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	6a 07                	push   $0x7
  80111f:	68 00 f0 7f 00       	push   $0x7ff000
  801124:	6a 00                	push   $0x0
  801126:	e8 ce fc ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 5f                	js     801191 <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	68 00 10 00 00       	push   $0x1000
  80113a:	53                   	push   %ebx
  80113b:	68 00 f0 7f 00       	push   $0x7ff000
  801140:	e8 b2 fa ff ff       	call   800bf7 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801145:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80114c:	53                   	push   %ebx
  80114d:	6a 00                	push   $0x0
  80114f:	68 00 f0 7f 00       	push   $0x7ff000
  801154:	6a 00                	push   $0x0
  801156:	e8 e1 fc ff ff       	call   800e3c <sys_page_map>
	if(ret < 0)
  80115b:	83 c4 20             	add    $0x20,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	78 43                	js     8011a5 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	68 00 f0 7f 00       	push   $0x7ff000
  80116a:	6a 00                	push   $0x0
  80116c:	e8 0d fd ff ff       	call   800e7e <sys_page_unmap>
	if(ret < 0)
  801171:	83 c4 10             	add    $0x10,%esp
  801174:	85 c0                	test   %eax,%eax
  801176:	78 41                	js     8011b9 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    
		panic("panic at pgfault()\n");
  80117d:	83 ec 04             	sub    $0x4,%esp
  801180:	68 6f 2f 80 00       	push   $0x802f6f
  801185:	6a 26                	push   $0x26
  801187:	68 83 2f 80 00       	push   $0x802f83
  80118c:	e8 21 f0 ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_alloc()\n");
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	68 8e 2f 80 00       	push   $0x802f8e
  801199:	6a 31                	push   $0x31
  80119b:	68 83 2f 80 00       	push   $0x802f83
  8011a0:	e8 0d f0 ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_map()\n");
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	68 a9 2f 80 00       	push   $0x802fa9
  8011ad:	6a 36                	push   $0x36
  8011af:	68 83 2f 80 00       	push   $0x802f83
  8011b4:	e8 f9 ef ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_unmap()\n");
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 c2 2f 80 00       	push   $0x802fc2
  8011c1:	6a 39                	push   $0x39
  8011c3:	68 83 2f 80 00       	push   $0x802f83
  8011c8:	e8 e5 ef ff ff       	call   8001b2 <_panic>

008011cd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	56                   	push   %esi
  8011d1:	53                   	push   %ebx
  8011d2:	89 c6                	mov    %eax,%esi
  8011d4:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	68 60 30 80 00       	push   $0x803060
  8011de:	68 7e 2b 80 00       	push   $0x802b7e
  8011e3:	e8 c0 f0 ff ff       	call   8002a8 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011e8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	f6 c4 04             	test   $0x4,%ah
  8011f5:	75 45                	jne    80123c <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011f7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011fe:	83 e0 07             	and    $0x7,%eax
  801201:	83 f8 07             	cmp    $0x7,%eax
  801204:	74 6e                	je     801274 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801206:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80120d:	25 05 08 00 00       	and    $0x805,%eax
  801212:	3d 05 08 00 00       	cmp    $0x805,%eax
  801217:	0f 84 b5 00 00 00    	je     8012d2 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80121d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801224:	83 e0 05             	and    $0x5,%eax
  801227:	83 f8 05             	cmp    $0x5,%eax
  80122a:	0f 84 d6 00 00 00    	je     801306 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
  801235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  80123c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801243:	c1 e3 0c             	shl    $0xc,%ebx
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	25 07 0e 00 00       	and    $0xe07,%eax
  80124e:	50                   	push   %eax
  80124f:	53                   	push   %ebx
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	6a 00                	push   $0x0
  801254:	e8 e3 fb ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	79 d0                	jns    801230 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801260:	83 ec 04             	sub    $0x4,%esp
  801263:	68 dd 2f 80 00       	push   $0x802fdd
  801268:	6a 55                	push   $0x55
  80126a:	68 83 2f 80 00       	push   $0x802f83
  80126f:	e8 3e ef ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801274:	c1 e3 0c             	shl    $0xc,%ebx
  801277:	83 ec 0c             	sub    $0xc,%esp
  80127a:	68 05 08 00 00       	push   $0x805
  80127f:	53                   	push   %ebx
  801280:	56                   	push   %esi
  801281:	53                   	push   %ebx
  801282:	6a 00                	push   $0x0
  801284:	e8 b3 fb ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801289:	83 c4 20             	add    $0x20,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 2e                	js     8012be <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	68 05 08 00 00       	push   $0x805
  801298:	53                   	push   %ebx
  801299:	6a 00                	push   $0x0
  80129b:	53                   	push   %ebx
  80129c:	6a 00                	push   $0x0
  80129e:	e8 99 fb ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  8012a3:	83 c4 20             	add    $0x20,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	79 86                	jns    801230 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012aa:	83 ec 04             	sub    $0x4,%esp
  8012ad:	68 dd 2f 80 00       	push   $0x802fdd
  8012b2:	6a 60                	push   $0x60
  8012b4:	68 83 2f 80 00       	push   $0x802f83
  8012b9:	e8 f4 ee ff ff       	call   8001b2 <_panic>
			panic("sys_page_map() panic\n");
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	68 dd 2f 80 00       	push   $0x802fdd
  8012c6:	6a 5c                	push   $0x5c
  8012c8:	68 83 2f 80 00       	push   $0x802f83
  8012cd:	e8 e0 ee ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012d2:	c1 e3 0c             	shl    $0xc,%ebx
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 05 08 00 00       	push   $0x805
  8012dd:	53                   	push   %ebx
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
  8012e0:	6a 00                	push   $0x0
  8012e2:	e8 55 fb ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  8012e7:	83 c4 20             	add    $0x20,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	0f 89 3e ff ff ff    	jns    801230 <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	68 dd 2f 80 00       	push   $0x802fdd
  8012fa:	6a 67                	push   $0x67
  8012fc:	68 83 2f 80 00       	push   $0x802f83
  801301:	e8 ac ee ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801306:	c1 e3 0c             	shl    $0xc,%ebx
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	6a 05                	push   $0x5
  80130e:	53                   	push   %ebx
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
  801311:	6a 00                	push   $0x0
  801313:	e8 24 fb ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801318:	83 c4 20             	add    $0x20,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	0f 89 0d ff ff ff    	jns    801230 <duppage+0x63>
			panic("sys_page_map() panic\n");
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	68 dd 2f 80 00       	push   $0x802fdd
  80132b:	6a 6e                	push   $0x6e
  80132d:	68 83 2f 80 00       	push   $0x802f83
  801332:	e8 7b ee ff ff       	call   8001b2 <_panic>

00801337 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	57                   	push   %edi
  80133b:	56                   	push   %esi
  80133c:	53                   	push   %ebx
  80133d:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801340:	68 ce 10 80 00       	push   $0x8010ce
  801345:	e8 d1 14 00 00       	call   80281b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80134a:	b8 07 00 00 00       	mov    $0x7,%eax
  80134f:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 27                	js     80137f <fork+0x48>
  801358:	89 c6                	mov    %eax,%esi
  80135a:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80135c:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801361:	75 48                	jne    8013ab <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801363:	e8 53 fa ff ff       	call   800dbb <sys_getenvid>
  801368:	25 ff 03 00 00       	and    $0x3ff,%eax
  80136d:	c1 e0 07             	shl    $0x7,%eax
  801370:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801375:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80137a:	e9 90 00 00 00       	jmp    80140f <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 f4 2f 80 00       	push   $0x802ff4
  801387:	68 8d 00 00 00       	push   $0x8d
  80138c:	68 83 2f 80 00       	push   $0x802f83
  801391:	e8 1c ee ff ff       	call   8001b2 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801396:	89 f8                	mov    %edi,%eax
  801398:	e8 30 fe ff ff       	call   8011cd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80139d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013a3:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013a9:	74 26                	je     8013d1 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013ab:	89 d8                	mov    %ebx,%eax
  8013ad:	c1 e8 16             	shr    $0x16,%eax
  8013b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b7:	a8 01                	test   $0x1,%al
  8013b9:	74 e2                	je     80139d <fork+0x66>
  8013bb:	89 da                	mov    %ebx,%edx
  8013bd:	c1 ea 0c             	shr    $0xc,%edx
  8013c0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013c7:	83 e0 05             	and    $0x5,%eax
  8013ca:	83 f8 05             	cmp    $0x5,%eax
  8013cd:	75 ce                	jne    80139d <fork+0x66>
  8013cf:	eb c5                	jmp    801396 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	6a 07                	push   $0x7
  8013d6:	68 00 f0 bf ee       	push   $0xeebff000
  8013db:	56                   	push   %esi
  8013dc:	e8 18 fa ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 31                	js     801419 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013e8:	83 ec 08             	sub    $0x8,%esp
  8013eb:	68 8a 28 80 00       	push   $0x80288a
  8013f0:	56                   	push   %esi
  8013f1:	e8 4e fb ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 33                	js     801430 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	6a 02                	push   $0x2
  801402:	56                   	push   %esi
  801403:	e8 b8 fa ff ff       	call   800ec0 <sys_env_set_status>
	if(ret < 0)
  801408:	83 c4 10             	add    $0x10,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 38                	js     801447 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80140f:	89 f0                	mov    %esi,%eax
  801411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	68 8e 2f 80 00       	push   $0x802f8e
  801421:	68 99 00 00 00       	push   $0x99
  801426:	68 83 2f 80 00       	push   $0x802f83
  80142b:	e8 82 ed ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 18 30 80 00       	push   $0x803018
  801438:	68 9c 00 00 00       	push   $0x9c
  80143d:	68 83 2f 80 00       	push   $0x802f83
  801442:	e8 6b ed ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_status()\n");
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	68 40 30 80 00       	push   $0x803040
  80144f:	68 9f 00 00 00       	push   $0x9f
  801454:	68 83 2f 80 00       	push   $0x802f83
  801459:	e8 54 ed ff ff       	call   8001b2 <_panic>

0080145e <sfork>:

// Challenge!
int
sfork(void)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	57                   	push   %edi
  801462:	56                   	push   %esi
  801463:	53                   	push   %ebx
  801464:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801467:	68 ce 10 80 00       	push   $0x8010ce
  80146c:	e8 aa 13 00 00       	call   80281b <set_pgfault_handler>
  801471:	b8 07 00 00 00       	mov    $0x7,%eax
  801476:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 27                	js     8014a6 <sfork+0x48>
  80147f:	89 c7                	mov    %eax,%edi
  801481:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801483:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801488:	75 55                	jne    8014df <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  80148a:	e8 2c f9 ff ff       	call   800dbb <sys_getenvid>
  80148f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801494:	c1 e0 07             	shl    $0x7,%eax
  801497:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80149c:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014a1:	e9 d4 00 00 00       	jmp    80157a <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	68 f4 2f 80 00       	push   $0x802ff4
  8014ae:	68 b0 00 00 00       	push   $0xb0
  8014b3:	68 83 2f 80 00       	push   $0x802f83
  8014b8:	e8 f5 ec ff ff       	call   8001b2 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014bd:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	e8 04 fd ff ff       	call   8011cd <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014cf:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014d5:	77 65                	ja     80153c <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014d7:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014dd:	74 de                	je     8014bd <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014df:	89 d8                	mov    %ebx,%eax
  8014e1:	c1 e8 16             	shr    $0x16,%eax
  8014e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014eb:	a8 01                	test   $0x1,%al
  8014ed:	74 da                	je     8014c9 <sfork+0x6b>
  8014ef:	89 da                	mov    %ebx,%edx
  8014f1:	c1 ea 0c             	shr    $0xc,%edx
  8014f4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014fb:	83 e0 05             	and    $0x5,%eax
  8014fe:	83 f8 05             	cmp    $0x5,%eax
  801501:	75 c6                	jne    8014c9 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801503:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80150a:	c1 e2 0c             	shl    $0xc,%edx
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	83 e0 07             	and    $0x7,%eax
  801513:	50                   	push   %eax
  801514:	52                   	push   %edx
  801515:	56                   	push   %esi
  801516:	52                   	push   %edx
  801517:	6a 00                	push   $0x0
  801519:	e8 1e f9 ff ff       	call   800e3c <sys_page_map>
  80151e:	83 c4 20             	add    $0x20,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	74 a4                	je     8014c9 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 dd 2f 80 00       	push   $0x802fdd
  80152d:	68 bb 00 00 00       	push   $0xbb
  801532:	68 83 2f 80 00       	push   $0x802f83
  801537:	e8 76 ec ff ff       	call   8001b2 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	6a 07                	push   $0x7
  801541:	68 00 f0 bf ee       	push   $0xeebff000
  801546:	57                   	push   %edi
  801547:	e8 ad f8 ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 31                	js     801584 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	68 8a 28 80 00       	push   $0x80288a
  80155b:	57                   	push   %edi
  80155c:	e8 e3 f9 ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 33                	js     80159b <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	6a 02                	push   $0x2
  80156d:	57                   	push   %edi
  80156e:	e8 4d f9 ff ff       	call   800ec0 <sys_env_set_status>
	if(ret < 0)
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 38                	js     8015b2 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80157a:	89 f8                	mov    %edi,%eax
  80157c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157f:	5b                   	pop    %ebx
  801580:	5e                   	pop    %esi
  801581:	5f                   	pop    %edi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 8e 2f 80 00       	push   $0x802f8e
  80158c:	68 c1 00 00 00       	push   $0xc1
  801591:	68 83 2f 80 00       	push   $0x802f83
  801596:	e8 17 ec ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	68 18 30 80 00       	push   $0x803018
  8015a3:	68 c4 00 00 00       	push   $0xc4
  8015a8:	68 83 2f 80 00       	push   $0x802f83
  8015ad:	e8 00 ec ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 40 30 80 00       	push   $0x803040
  8015ba:	68 c7 00 00 00       	push   $0xc7
  8015bf:	68 83 2f 80 00       	push   $0x802f83
  8015c4:	e8 e9 eb ff ff       	call   8001b2 <_panic>

008015c9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8015d7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015d9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015de:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	50                   	push   %eax
  8015e5:	e8 bf f9 ff ff       	call   800fa9 <sys_ipc_recv>
	if(ret < 0){
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 2b                	js     80161c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015f1:	85 f6                	test   %esi,%esi
  8015f3:	74 0a                	je     8015ff <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8015f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8015fa:	8b 40 74             	mov    0x74(%eax),%eax
  8015fd:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015ff:	85 db                	test   %ebx,%ebx
  801601:	74 0a                	je     80160d <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801603:	a1 08 50 80 00       	mov    0x805008,%eax
  801608:	8b 40 78             	mov    0x78(%eax),%eax
  80160b:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80160d:	a1 08 50 80 00       	mov    0x805008,%eax
  801612:	8b 40 70             	mov    0x70(%eax),%eax
}
  801615:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    
		if(from_env_store)
  80161c:	85 f6                	test   %esi,%esi
  80161e:	74 06                	je     801626 <ipc_recv+0x5d>
			*from_env_store = 0;
  801620:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801626:	85 db                	test   %ebx,%ebx
  801628:	74 eb                	je     801615 <ipc_recv+0x4c>
			*perm_store = 0;
  80162a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801630:	eb e3                	jmp    801615 <ipc_recv+0x4c>

00801632 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	57                   	push   %edi
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80163e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801641:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801644:	85 db                	test   %ebx,%ebx
  801646:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80164b:	0f 44 d8             	cmove  %eax,%ebx
  80164e:	eb 05                	jmp    801655 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801650:	e8 85 f7 ff ff       	call   800dda <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801655:	ff 75 14             	pushl  0x14(%ebp)
  801658:	53                   	push   %ebx
  801659:	56                   	push   %esi
  80165a:	57                   	push   %edi
  80165b:	e8 26 f9 ff ff       	call   800f86 <sys_ipc_try_send>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	74 1b                	je     801682 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801667:	79 e7                	jns    801650 <ipc_send+0x1e>
  801669:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80166c:	74 e2                	je     801650 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 68 30 80 00       	push   $0x803068
  801676:	6a 48                	push   $0x48
  801678:	68 7d 30 80 00       	push   $0x80307d
  80167d:	e8 30 eb ff ff       	call   8001b2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801682:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5f                   	pop    %edi
  801688:	5d                   	pop    %ebp
  801689:	c3                   	ret    

0080168a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801695:	89 c2                	mov    %eax,%edx
  801697:	c1 e2 07             	shl    $0x7,%edx
  80169a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016a0:	8b 52 50             	mov    0x50(%edx),%edx
  8016a3:	39 ca                	cmp    %ecx,%edx
  8016a5:	74 11                	je     8016b8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8016a7:	83 c0 01             	add    $0x1,%eax
  8016aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016af:	75 e4                	jne    801695 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b6:	eb 0b                	jmp    8016c3 <ipc_find_env+0x39>
			return envs[i].env_id;
  8016b8:	c1 e0 07             	shl    $0x7,%eax
  8016bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016c3:	5d                   	pop    %ebp
  8016c4:	c3                   	ret    

008016c5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	05 00 00 00 30       	add    $0x30000000,%eax
  8016d0:	c1 e8 0c             	shr    $0xc,%eax
}
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	c1 ea 16             	shr    $0x16,%edx
  8016f9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801700:	f6 c2 01             	test   $0x1,%dl
  801703:	74 2d                	je     801732 <fd_alloc+0x46>
  801705:	89 c2                	mov    %eax,%edx
  801707:	c1 ea 0c             	shr    $0xc,%edx
  80170a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801711:	f6 c2 01             	test   $0x1,%dl
  801714:	74 1c                	je     801732 <fd_alloc+0x46>
  801716:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80171b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801720:	75 d2                	jne    8016f4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80172b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801730:	eb 0a                	jmp    80173c <fd_alloc+0x50>
			*fd_store = fd;
  801732:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801735:	89 01                	mov    %eax,(%ecx)
			return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801744:	83 f8 1f             	cmp    $0x1f,%eax
  801747:	77 30                	ja     801779 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801749:	c1 e0 0c             	shl    $0xc,%eax
  80174c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801751:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801757:	f6 c2 01             	test   $0x1,%dl
  80175a:	74 24                	je     801780 <fd_lookup+0x42>
  80175c:	89 c2                	mov    %eax,%edx
  80175e:	c1 ea 0c             	shr    $0xc,%edx
  801761:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801768:	f6 c2 01             	test   $0x1,%dl
  80176b:	74 1a                	je     801787 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80176d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801770:	89 02                	mov    %eax,(%edx)
	return 0;
  801772:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    
		return -E_INVAL;
  801779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80177e:	eb f7                	jmp    801777 <fd_lookup+0x39>
		return -E_INVAL;
  801780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801785:	eb f0                	jmp    801777 <fd_lookup+0x39>
  801787:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80178c:	eb e9                	jmp    801777 <fd_lookup+0x39>

0080178e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017a1:	39 08                	cmp    %ecx,(%eax)
  8017a3:	74 38                	je     8017dd <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017a5:	83 c2 01             	add    $0x1,%edx
  8017a8:	8b 04 95 04 31 80 00 	mov    0x803104(,%edx,4),%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	75 ee                	jne    8017a1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017b3:	a1 08 50 80 00       	mov    0x805008,%eax
  8017b8:	8b 40 48             	mov    0x48(%eax),%eax
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	51                   	push   %ecx
  8017bf:	50                   	push   %eax
  8017c0:	68 88 30 80 00       	push   $0x803088
  8017c5:	e8 de ea ff ff       	call   8002a8 <cprintf>
	*dev = 0;
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    
			*dev = devtab[i];
  8017dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e7:	eb f2                	jmp    8017db <dev_lookup+0x4d>

008017e9 <fd_close>:
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	57                   	push   %edi
  8017ed:	56                   	push   %esi
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 24             	sub    $0x24,%esp
  8017f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8017f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017fb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017fc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801802:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801805:	50                   	push   %eax
  801806:	e8 33 ff ff ff       	call   80173e <fd_lookup>
  80180b:	89 c3                	mov    %eax,%ebx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 05                	js     801819 <fd_close+0x30>
	    || fd != fd2)
  801814:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801817:	74 16                	je     80182f <fd_close+0x46>
		return (must_exist ? r : 0);
  801819:	89 f8                	mov    %edi,%eax
  80181b:	84 c0                	test   %al,%al
  80181d:	b8 00 00 00 00       	mov    $0x0,%eax
  801822:	0f 44 d8             	cmove  %eax,%ebx
}
  801825:	89 d8                	mov    %ebx,%eax
  801827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80182f:	83 ec 08             	sub    $0x8,%esp
  801832:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801835:	50                   	push   %eax
  801836:	ff 36                	pushl  (%esi)
  801838:	e8 51 ff ff ff       	call   80178e <dev_lookup>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 1a                	js     801860 <fd_close+0x77>
		if (dev->dev_close)
  801846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801849:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80184c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801851:	85 c0                	test   %eax,%eax
  801853:	74 0b                	je     801860 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	56                   	push   %esi
  801859:	ff d0                	call   *%eax
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	56                   	push   %esi
  801864:	6a 00                	push   $0x0
  801866:	e8 13 f6 ff ff       	call   800e7e <sys_page_unmap>
	return r;
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	eb b5                	jmp    801825 <fd_close+0x3c>

00801870 <close>:

int
close(int fdnum)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 bc fe ff ff       	call   80173e <fd_lookup>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 c0                	test   %eax,%eax
  801887:	79 02                	jns    80188b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    
		return fd_close(fd, 1);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	6a 01                	push   $0x1
  801890:	ff 75 f4             	pushl  -0xc(%ebp)
  801893:	e8 51 ff ff ff       	call   8017e9 <fd_close>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	eb ec                	jmp    801889 <close+0x19>

0080189d <close_all>:

void
close_all(void)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	53                   	push   %ebx
  8018a1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	53                   	push   %ebx
  8018ad:	e8 be ff ff ff       	call   801870 <close>
	for (i = 0; i < MAXFD; i++)
  8018b2:	83 c3 01             	add    $0x1,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	83 fb 20             	cmp    $0x20,%ebx
  8018bb:	75 ec                	jne    8018a9 <close_all+0xc>
}
  8018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ce:	50                   	push   %eax
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	e8 67 fe ff ff       	call   80173e <fd_lookup>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	0f 88 81 00 00 00    	js     801965 <dup+0xa3>
		return r;
	close(newfdnum);
  8018e4:	83 ec 0c             	sub    $0xc,%esp
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 81 ff ff ff       	call   801870 <close>

	newfd = INDEX2FD(newfdnum);
  8018ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018f2:	c1 e6 0c             	shl    $0xc,%esi
  8018f5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018fb:	83 c4 04             	add    $0x4,%esp
  8018fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801901:	e8 cf fd ff ff       	call   8016d5 <fd2data>
  801906:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801908:	89 34 24             	mov    %esi,(%esp)
  80190b:	e8 c5 fd ff ff       	call   8016d5 <fd2data>
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801915:	89 d8                	mov    %ebx,%eax
  801917:	c1 e8 16             	shr    $0x16,%eax
  80191a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801921:	a8 01                	test   $0x1,%al
  801923:	74 11                	je     801936 <dup+0x74>
  801925:	89 d8                	mov    %ebx,%eax
  801927:	c1 e8 0c             	shr    $0xc,%eax
  80192a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801931:	f6 c2 01             	test   $0x1,%dl
  801934:	75 39                	jne    80196f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801936:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e8 0c             	shr    $0xc,%eax
  80193e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	25 07 0e 00 00       	and    $0xe07,%eax
  80194d:	50                   	push   %eax
  80194e:	56                   	push   %esi
  80194f:	6a 00                	push   $0x0
  801951:	52                   	push   %edx
  801952:	6a 00                	push   $0x0
  801954:	e8 e3 f4 ff ff       	call   800e3c <sys_page_map>
  801959:	89 c3                	mov    %eax,%ebx
  80195b:	83 c4 20             	add    $0x20,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 31                	js     801993 <dup+0xd1>
		goto err;

	return newfdnum;
  801962:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801965:	89 d8                	mov    %ebx,%eax
  801967:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5f                   	pop    %edi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80196f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	25 07 0e 00 00       	and    $0xe07,%eax
  80197e:	50                   	push   %eax
  80197f:	57                   	push   %edi
  801980:	6a 00                	push   $0x0
  801982:	53                   	push   %ebx
  801983:	6a 00                	push   $0x0
  801985:	e8 b2 f4 ff ff       	call   800e3c <sys_page_map>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 20             	add    $0x20,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	79 a3                	jns    801936 <dup+0x74>
	sys_page_unmap(0, newfd);
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	56                   	push   %esi
  801997:	6a 00                	push   $0x0
  801999:	e8 e0 f4 ff ff       	call   800e7e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80199e:	83 c4 08             	add    $0x8,%esp
  8019a1:	57                   	push   %edi
  8019a2:	6a 00                	push   $0x0
  8019a4:	e8 d5 f4 ff ff       	call   800e7e <sys_page_unmap>
	return r;
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	eb b7                	jmp    801965 <dup+0xa3>

008019ae <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 1c             	sub    $0x1c,%esp
  8019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	53                   	push   %ebx
  8019bd:	e8 7c fd ff ff       	call   80173e <fd_lookup>
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 3f                	js     801a08 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c9:	83 ec 08             	sub    $0x8,%esp
  8019cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d3:	ff 30                	pushl  (%eax)
  8019d5:	e8 b4 fd ff ff       	call   80178e <dev_lookup>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 27                	js     801a08 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e4:	8b 42 08             	mov    0x8(%edx),%eax
  8019e7:	83 e0 03             	and    $0x3,%eax
  8019ea:	83 f8 01             	cmp    $0x1,%eax
  8019ed:	74 1e                	je     801a0d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f2:	8b 40 08             	mov    0x8(%eax),%eax
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	74 35                	je     801a2e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	52                   	push   %edx
  801a03:	ff d0                	call   *%eax
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a0d:	a1 08 50 80 00       	mov    0x805008,%eax
  801a12:	8b 40 48             	mov    0x48(%eax),%eax
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	53                   	push   %ebx
  801a19:	50                   	push   %eax
  801a1a:	68 c9 30 80 00       	push   $0x8030c9
  801a1f:	e8 84 e8 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a2c:	eb da                	jmp    801a08 <read+0x5a>
		return -E_NOT_SUPP;
  801a2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a33:	eb d3                	jmp    801a08 <read+0x5a>

00801a35 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	57                   	push   %edi
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a41:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a44:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a49:	39 f3                	cmp    %esi,%ebx
  801a4b:	73 23                	jae    801a70 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	89 f0                	mov    %esi,%eax
  801a52:	29 d8                	sub    %ebx,%eax
  801a54:	50                   	push   %eax
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	03 45 0c             	add    0xc(%ebp),%eax
  801a5a:	50                   	push   %eax
  801a5b:	57                   	push   %edi
  801a5c:	e8 4d ff ff ff       	call   8019ae <read>
		if (m < 0)
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 06                	js     801a6e <readn+0x39>
			return m;
		if (m == 0)
  801a68:	74 06                	je     801a70 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a6a:	01 c3                	add    %eax,%ebx
  801a6c:	eb db                	jmp    801a49 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a6e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a70:	89 d8                	mov    %ebx,%eax
  801a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a75:	5b                   	pop    %ebx
  801a76:	5e                   	pop    %esi
  801a77:	5f                   	pop    %edi
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 1c             	sub    $0x1c,%esp
  801a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	53                   	push   %ebx
  801a89:	e8 b0 fc ff ff       	call   80173e <fd_lookup>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 3a                	js     801acf <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a95:	83 ec 08             	sub    $0x8,%esp
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	50                   	push   %eax
  801a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9f:	ff 30                	pushl  (%eax)
  801aa1:	e8 e8 fc ff ff       	call   80178e <dev_lookup>
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	78 22                	js     801acf <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ab4:	74 1e                	je     801ad4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab9:	8b 52 0c             	mov    0xc(%edx),%edx
  801abc:	85 d2                	test   %edx,%edx
  801abe:	74 35                	je     801af5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	ff 75 10             	pushl  0x10(%ebp)
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	50                   	push   %eax
  801aca:	ff d2                	call   *%edx
  801acc:	83 c4 10             	add    $0x10,%esp
}
  801acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ad4:	a1 08 50 80 00       	mov    0x805008,%eax
  801ad9:	8b 40 48             	mov    0x48(%eax),%eax
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	53                   	push   %ebx
  801ae0:	50                   	push   %eax
  801ae1:	68 e5 30 80 00       	push   $0x8030e5
  801ae6:	e8 bd e7 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af3:	eb da                	jmp    801acf <write+0x55>
		return -E_NOT_SUPP;
  801af5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801afa:	eb d3                	jmp    801acf <write+0x55>

00801afc <seek>:

int
seek(int fdnum, off_t offset)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b05:	50                   	push   %eax
  801b06:	ff 75 08             	pushl  0x8(%ebp)
  801b09:	e8 30 fc ff ff       	call   80173e <fd_lookup>
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	85 c0                	test   %eax,%eax
  801b13:	78 0e                	js     801b23 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	53                   	push   %ebx
  801b29:	83 ec 1c             	sub    $0x1c,%esp
  801b2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b32:	50                   	push   %eax
  801b33:	53                   	push   %ebx
  801b34:	e8 05 fc ff ff       	call   80173e <fd_lookup>
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 37                	js     801b77 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b40:	83 ec 08             	sub    $0x8,%esp
  801b43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b46:	50                   	push   %eax
  801b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4a:	ff 30                	pushl  (%eax)
  801b4c:	e8 3d fc ff ff       	call   80178e <dev_lookup>
  801b51:	83 c4 10             	add    $0x10,%esp
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 1f                	js     801b77 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b5f:	74 1b                	je     801b7c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b64:	8b 52 18             	mov    0x18(%edx),%edx
  801b67:	85 d2                	test   %edx,%edx
  801b69:	74 32                	je     801b9d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	ff d2                	call   *%edx
  801b74:	83 c4 10             	add    $0x10,%esp
}
  801b77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b7c:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b81:	8b 40 48             	mov    0x48(%eax),%eax
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	53                   	push   %ebx
  801b88:	50                   	push   %eax
  801b89:	68 a8 30 80 00       	push   $0x8030a8
  801b8e:	e8 15 e7 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b9b:	eb da                	jmp    801b77 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b9d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba2:	eb d3                	jmp    801b77 <ftruncate+0x52>

00801ba4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bb1:	50                   	push   %eax
  801bb2:	ff 75 08             	pushl  0x8(%ebp)
  801bb5:	e8 84 fb ff ff       	call   80173e <fd_lookup>
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 4b                	js     801c0c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bc1:	83 ec 08             	sub    $0x8,%esp
  801bc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc7:	50                   	push   %eax
  801bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcb:	ff 30                	pushl  (%eax)
  801bcd:	e8 bc fb ff ff       	call   80178e <dev_lookup>
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 33                	js     801c0c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801be0:	74 2f                	je     801c11 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801be2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801be5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bec:	00 00 00 
	stat->st_isdir = 0;
  801bef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf6:	00 00 00 
	stat->st_dev = dev;
  801bf9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	53                   	push   %ebx
  801c03:	ff 75 f0             	pushl  -0x10(%ebp)
  801c06:	ff 50 14             	call   *0x14(%eax)
  801c09:	83 c4 10             	add    $0x10,%esp
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    
		return -E_NOT_SUPP;
  801c11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c16:	eb f4                	jmp    801c0c <fstat+0x68>

00801c18 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c1d:	83 ec 08             	sub    $0x8,%esp
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	e8 22 02 00 00       	call   801e4c <open>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 1b                	js     801c4e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	50                   	push   %eax
  801c3a:	e8 65 ff ff ff       	call   801ba4 <fstat>
  801c3f:	89 c6                	mov    %eax,%esi
	close(fd);
  801c41:	89 1c 24             	mov    %ebx,(%esp)
  801c44:	e8 27 fc ff ff       	call   801870 <close>
	return r;
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	89 f3                	mov    %esi,%ebx
}
  801c4e:	89 d8                	mov    %ebx,%eax
  801c50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	56                   	push   %esi
  801c5b:	53                   	push   %ebx
  801c5c:	89 c6                	mov    %eax,%esi
  801c5e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c60:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c67:	74 27                	je     801c90 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c69:	6a 07                	push   $0x7
  801c6b:	68 00 60 80 00       	push   $0x806000
  801c70:	56                   	push   %esi
  801c71:	ff 35 00 50 80 00    	pushl  0x805000
  801c77:	e8 b6 f9 ff ff       	call   801632 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c7c:	83 c4 0c             	add    $0xc,%esp
  801c7f:	6a 00                	push   $0x0
  801c81:	53                   	push   %ebx
  801c82:	6a 00                	push   $0x0
  801c84:	e8 40 f9 ff ff       	call   8015c9 <ipc_recv>
}
  801c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c90:	83 ec 0c             	sub    $0xc,%esp
  801c93:	6a 01                	push   $0x1
  801c95:	e8 f0 f9 ff ff       	call   80168a <ipc_find_env>
  801c9a:	a3 00 50 80 00       	mov    %eax,0x805000
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	eb c5                	jmp    801c69 <fsipc+0x12>

00801ca4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb8:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc2:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc7:	e8 8b ff ff ff       	call   801c57 <fsipc>
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <devfile_flush>:
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cda:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce9:	e8 69 ff ff ff       	call   801c57 <fsipc>
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <devfile_stat>:
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801d00:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d05:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0a:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0f:	e8 43 ff ff ff       	call   801c57 <fsipc>
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 2c                	js     801d44 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	68 00 60 80 00       	push   $0x806000
  801d20:	53                   	push   %ebx
  801d21:	e8 e1 ec ff ff       	call   800a07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d26:	a1 80 60 80 00       	mov    0x806080,%eax
  801d2b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d31:	a1 84 60 80 00       	mov    0x806084,%eax
  801d36:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <devfile_write>:
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	53                   	push   %ebx
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	8b 40 0c             	mov    0xc(%eax),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d5e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d64:	53                   	push   %ebx
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	68 08 60 80 00       	push   $0x806008
  801d6d:	e8 85 ee ff ff       	call   800bf7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d72:	ba 00 00 00 00       	mov    $0x0,%edx
  801d77:	b8 04 00 00 00       	mov    $0x4,%eax
  801d7c:	e8 d6 fe ff ff       	call   801c57 <fsipc>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 0b                	js     801d93 <devfile_write+0x4a>
	assert(r <= n);
  801d88:	39 d8                	cmp    %ebx,%eax
  801d8a:	77 0c                	ja     801d98 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d8c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d91:	7f 1e                	jg     801db1 <devfile_write+0x68>
}
  801d93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    
	assert(r <= n);
  801d98:	68 18 31 80 00       	push   $0x803118
  801d9d:	68 1f 31 80 00       	push   $0x80311f
  801da2:	68 98 00 00 00       	push   $0x98
  801da7:	68 34 31 80 00       	push   $0x803134
  801dac:	e8 01 e4 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  801db1:	68 3f 31 80 00       	push   $0x80313f
  801db6:	68 1f 31 80 00       	push   $0x80311f
  801dbb:	68 99 00 00 00       	push   $0x99
  801dc0:	68 34 31 80 00       	push   $0x803134
  801dc5:	e8 e8 e3 ff ff       	call   8001b2 <_panic>

00801dca <devfile_read>:
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ddd:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801de3:	ba 00 00 00 00       	mov    $0x0,%edx
  801de8:	b8 03 00 00 00       	mov    $0x3,%eax
  801ded:	e8 65 fe ff ff       	call   801c57 <fsipc>
  801df2:	89 c3                	mov    %eax,%ebx
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 1f                	js     801e17 <devfile_read+0x4d>
	assert(r <= n);
  801df8:	39 f0                	cmp    %esi,%eax
  801dfa:	77 24                	ja     801e20 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dfc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e01:	7f 33                	jg     801e36 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	50                   	push   %eax
  801e07:	68 00 60 80 00       	push   $0x806000
  801e0c:	ff 75 0c             	pushl  0xc(%ebp)
  801e0f:	e8 81 ed ff ff       	call   800b95 <memmove>
	return r;
  801e14:	83 c4 10             	add    $0x10,%esp
}
  801e17:	89 d8                	mov    %ebx,%eax
  801e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    
	assert(r <= n);
  801e20:	68 18 31 80 00       	push   $0x803118
  801e25:	68 1f 31 80 00       	push   $0x80311f
  801e2a:	6a 7c                	push   $0x7c
  801e2c:	68 34 31 80 00       	push   $0x803134
  801e31:	e8 7c e3 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  801e36:	68 3f 31 80 00       	push   $0x80313f
  801e3b:	68 1f 31 80 00       	push   $0x80311f
  801e40:	6a 7d                	push   $0x7d
  801e42:	68 34 31 80 00       	push   $0x803134
  801e47:	e8 66 e3 ff ff       	call   8001b2 <_panic>

00801e4c <open>:
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	56                   	push   %esi
  801e50:	53                   	push   %ebx
  801e51:	83 ec 1c             	sub    $0x1c,%esp
  801e54:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e57:	56                   	push   %esi
  801e58:	e8 71 eb ff ff       	call   8009ce <strlen>
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e65:	7f 6c                	jg     801ed3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6d:	50                   	push   %eax
  801e6e:	e8 79 f8 ff ff       	call   8016ec <fd_alloc>
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	78 3c                	js     801eb8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e7c:	83 ec 08             	sub    $0x8,%esp
  801e7f:	56                   	push   %esi
  801e80:	68 00 60 80 00       	push   $0x806000
  801e85:	e8 7d eb ff ff       	call   800a07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	e8 b8 fd ff ff       	call   801c57 <fsipc>
  801e9f:	89 c3                	mov    %eax,%ebx
  801ea1:	83 c4 10             	add    $0x10,%esp
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	78 19                	js     801ec1 <open+0x75>
	return fd2num(fd);
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	e8 12 f8 ff ff       	call   8016c5 <fd2num>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 10             	add    $0x10,%esp
}
  801eb8:	89 d8                	mov    %ebx,%eax
  801eba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5e                   	pop    %esi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    
		fd_close(fd, 0);
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	6a 00                	push   $0x0
  801ec6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec9:	e8 1b f9 ff ff       	call   8017e9 <fd_close>
		return r;
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	eb e5                	jmp    801eb8 <open+0x6c>
		return -E_BAD_PATH;
  801ed3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ed8:	eb de                	jmp    801eb8 <open+0x6c>

00801eda <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee5:	b8 08 00 00 00       	mov    $0x8,%eax
  801eea:	e8 68 fd ff ff       	call   801c57 <fsipc>
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef7:	68 4b 31 80 00       	push   $0x80314b
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	e8 03 eb ff ff       	call   800a07 <strcpy>
	return 0;
}
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <devsock_close>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 10             	sub    $0x10,%esp
  801f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f15:	53                   	push   %ebx
  801f16:	e8 95 09 00 00       	call   8028b0 <pageref>
  801f1b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f1e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f23:	83 f8 01             	cmp    $0x1,%eax
  801f26:	74 07                	je     801f2f <devsock_close+0x24>
}
  801f28:	89 d0                	mov    %edx,%eax
  801f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	ff 73 0c             	pushl  0xc(%ebx)
  801f35:	e8 b9 02 00 00       	call   8021f3 <nsipc_close>
  801f3a:	89 c2                	mov    %eax,%edx
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	eb e7                	jmp    801f28 <devsock_close+0x1d>

00801f41 <devsock_write>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	ff 75 10             	pushl  0x10(%ebp)
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	ff 70 0c             	pushl  0xc(%eax)
  801f55:	e8 76 03 00 00       	call   8022d0 <nsipc_send>
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <devsock_read>:
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 10             	pushl  0x10(%ebp)
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	ff 70 0c             	pushl  0xc(%eax)
  801f70:	e8 ef 02 00 00       	call   802264 <nsipc_recv>
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <fd2sockid>:
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f7d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	e8 b7 f7 ff ff       	call   80173e <fd_lookup>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 10                	js     801f9e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f97:	39 08                	cmp    %ecx,(%eax)
  801f99:	75 05                	jne    801fa0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f9b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    
		return -E_NOT_SUPP;
  801fa0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fa5:	eb f7                	jmp    801f9e <fd2sockid+0x27>

00801fa7 <alloc_sockfd>:
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	56                   	push   %esi
  801fab:	53                   	push   %ebx
  801fac:	83 ec 1c             	sub    $0x1c,%esp
  801faf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb4:	50                   	push   %eax
  801fb5:	e8 32 f7 ff ff       	call   8016ec <fd_alloc>
  801fba:	89 c3                	mov    %eax,%ebx
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 43                	js     802006 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	68 07 04 00 00       	push   $0x407
  801fcb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fce:	6a 00                	push   $0x0
  801fd0:	e8 24 ee ff ff       	call   800df9 <sys_page_alloc>
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 28                	js     802006 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ff3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	50                   	push   %eax
  801ffa:	e8 c6 f6 ff ff       	call   8016c5 <fd2num>
  801fff:	89 c3                	mov    %eax,%ebx
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	eb 0c                	jmp    802012 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	56                   	push   %esi
  80200a:	e8 e4 01 00 00       	call   8021f3 <nsipc_close>
		return r;
  80200f:	83 c4 10             	add    $0x10,%esp
}
  802012:	89 d8                	mov    %ebx,%eax
  802014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <accept>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	e8 4e ff ff ff       	call   801f77 <fd2sockid>
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 1b                	js     802048 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	ff 75 10             	pushl  0x10(%ebp)
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	50                   	push   %eax
  802037:	e8 0e 01 00 00       	call   80214a <nsipc_accept>
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	85 c0                	test   %eax,%eax
  802041:	78 05                	js     802048 <accept+0x2d>
	return alloc_sockfd(r);
  802043:	e8 5f ff ff ff       	call   801fa7 <alloc_sockfd>
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <bind>:
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	e8 1f ff ff ff       	call   801f77 <fd2sockid>
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 12                	js     80206e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	ff 75 10             	pushl  0x10(%ebp)
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	50                   	push   %eax
  802066:	e8 31 01 00 00       	call   80219c <nsipc_bind>
  80206b:	83 c4 10             	add    $0x10,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <shutdown>:
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	e8 f9 fe ff ff       	call   801f77 <fd2sockid>
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 0f                	js     802091 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802082:	83 ec 08             	sub    $0x8,%esp
  802085:	ff 75 0c             	pushl  0xc(%ebp)
  802088:	50                   	push   %eax
  802089:	e8 43 01 00 00       	call   8021d1 <nsipc_shutdown>
  80208e:	83 c4 10             	add    $0x10,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <connect>:
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	e8 d6 fe ff ff       	call   801f77 <fd2sockid>
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 12                	js     8020b7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	ff 75 10             	pushl  0x10(%ebp)
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	50                   	push   %eax
  8020af:	e8 59 01 00 00       	call   80220d <nsipc_connect>
  8020b4:	83 c4 10             	add    $0x10,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <listen>:
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	e8 b0 fe ff ff       	call   801f77 <fd2sockid>
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 0f                	js     8020da <listen+0x21>
	return nsipc_listen(r, backlog);
  8020cb:	83 ec 08             	sub    $0x8,%esp
  8020ce:	ff 75 0c             	pushl  0xc(%ebp)
  8020d1:	50                   	push   %eax
  8020d2:	e8 6b 01 00 00       	call   802242 <nsipc_listen>
  8020d7:	83 c4 10             	add    $0x10,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <socket>:

int
socket(int domain, int type, int protocol)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020e2:	ff 75 10             	pushl  0x10(%ebp)
  8020e5:	ff 75 0c             	pushl  0xc(%ebp)
  8020e8:	ff 75 08             	pushl  0x8(%ebp)
  8020eb:	e8 3e 02 00 00       	call   80232e <nsipc_socket>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 05                	js     8020fc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f7:	e8 ab fe ff ff       	call   801fa7 <alloc_sockfd>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	53                   	push   %ebx
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802107:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80210e:	74 26                	je     802136 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802110:	6a 07                	push   $0x7
  802112:	68 00 70 80 00       	push   $0x807000
  802117:	53                   	push   %ebx
  802118:	ff 35 04 50 80 00    	pushl  0x805004
  80211e:	e8 0f f5 ff ff       	call   801632 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802123:	83 c4 0c             	add    $0xc,%esp
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	e8 98 f4 ff ff       	call   8015c9 <ipc_recv>
}
  802131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802134:	c9                   	leave  
  802135:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	6a 02                	push   $0x2
  80213b:	e8 4a f5 ff ff       	call   80168a <ipc_find_env>
  802140:	a3 04 50 80 00       	mov    %eax,0x805004
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	eb c6                	jmp    802110 <nsipc+0x12>

0080214a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	56                   	push   %esi
  80214e:	53                   	push   %ebx
  80214f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80215a:	8b 06                	mov    (%esi),%eax
  80215c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802161:	b8 01 00 00 00       	mov    $0x1,%eax
  802166:	e8 93 ff ff ff       	call   8020fe <nsipc>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	79 09                	jns    80217a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802171:	89 d8                	mov    %ebx,%eax
  802173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802176:	5b                   	pop    %ebx
  802177:	5e                   	pop    %esi
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	ff 35 10 70 80 00    	pushl  0x807010
  802183:	68 00 70 80 00       	push   $0x807000
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	e8 05 ea ff ff       	call   800b95 <memmove>
		*addrlen = ret->ret_addrlen;
  802190:	a1 10 70 80 00       	mov    0x807010,%eax
  802195:	89 06                	mov    %eax,(%esi)
  802197:	83 c4 10             	add    $0x10,%esp
	return r;
  80219a:	eb d5                	jmp    802171 <nsipc_accept+0x27>

0080219c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 08             	sub    $0x8,%esp
  8021a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021ae:	53                   	push   %ebx
  8021af:	ff 75 0c             	pushl  0xc(%ebp)
  8021b2:	68 04 70 80 00       	push   $0x807004
  8021b7:	e8 d9 e9 ff ff       	call   800b95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021bc:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c7:	e8 32 ff ff ff       	call   8020fe <nsipc>
}
  8021cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e2:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8021ec:	e8 0d ff ff ff       	call   8020fe <nsipc>
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <nsipc_close>:

int
nsipc_close(int s)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802201:	b8 04 00 00 00       	mov    $0x4,%eax
  802206:	e8 f3 fe ff ff       	call   8020fe <nsipc>
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	53                   	push   %ebx
  802211:	83 ec 08             	sub    $0x8,%esp
  802214:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80221f:	53                   	push   %ebx
  802220:	ff 75 0c             	pushl  0xc(%ebp)
  802223:	68 04 70 80 00       	push   $0x807004
  802228:	e8 68 e9 ff ff       	call   800b95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80222d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802233:	b8 05 00 00 00       	mov    $0x5,%eax
  802238:	e8 c1 fe ff ff       	call   8020fe <nsipc>
}
  80223d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802258:	b8 06 00 00 00       	mov    $0x6,%eax
  80225d:	e8 9c fe ff ff       	call   8020fe <nsipc>
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	56                   	push   %esi
  802268:	53                   	push   %ebx
  802269:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802274:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80227a:	8b 45 14             	mov    0x14(%ebp),%eax
  80227d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802282:	b8 07 00 00 00       	mov    $0x7,%eax
  802287:	e8 72 fe ff ff       	call   8020fe <nsipc>
  80228c:	89 c3                	mov    %eax,%ebx
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 1f                	js     8022b1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802292:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802297:	7f 21                	jg     8022ba <nsipc_recv+0x56>
  802299:	39 c6                	cmp    %eax,%esi
  80229b:	7c 1d                	jl     8022ba <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	50                   	push   %eax
  8022a1:	68 00 70 80 00       	push   $0x807000
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	e8 e7 e8 ff ff       	call   800b95 <memmove>
  8022ae:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022b1:	89 d8                	mov    %ebx,%eax
  8022b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b6:	5b                   	pop    %ebx
  8022b7:	5e                   	pop    %esi
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022ba:	68 57 31 80 00       	push   $0x803157
  8022bf:	68 1f 31 80 00       	push   $0x80311f
  8022c4:	6a 62                	push   $0x62
  8022c6:	68 6c 31 80 00       	push   $0x80316c
  8022cb:	e8 e2 de ff ff       	call   8001b2 <_panic>

008022d0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022e2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e8:	7f 2e                	jg     802318 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	53                   	push   %ebx
  8022ee:	ff 75 0c             	pushl  0xc(%ebp)
  8022f1:	68 0c 70 80 00       	push   $0x80700c
  8022f6:	e8 9a e8 ff ff       	call   800b95 <memmove>
	nsipcbuf.send.req_size = size;
  8022fb:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802301:	8b 45 14             	mov    0x14(%ebp),%eax
  802304:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802309:	b8 08 00 00 00       	mov    $0x8,%eax
  80230e:	e8 eb fd ff ff       	call   8020fe <nsipc>
}
  802313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802316:	c9                   	leave  
  802317:	c3                   	ret    
	assert(size < 1600);
  802318:	68 78 31 80 00       	push   $0x803178
  80231d:	68 1f 31 80 00       	push   $0x80311f
  802322:	6a 6d                	push   $0x6d
  802324:	68 6c 31 80 00       	push   $0x80316c
  802329:	e8 84 de ff ff       	call   8001b2 <_panic>

0080232e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80233c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80234c:	b8 09 00 00 00       	mov    $0x9,%eax
  802351:	e8 a8 fd ff ff       	call   8020fe <nsipc>
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	56                   	push   %esi
  80235c:	53                   	push   %ebx
  80235d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	ff 75 08             	pushl  0x8(%ebp)
  802366:	e8 6a f3 ff ff       	call   8016d5 <fd2data>
  80236b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80236d:	83 c4 08             	add    $0x8,%esp
  802370:	68 84 31 80 00       	push   $0x803184
  802375:	53                   	push   %ebx
  802376:	e8 8c e6 ff ff       	call   800a07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80237b:	8b 46 04             	mov    0x4(%esi),%eax
  80237e:	2b 06                	sub    (%esi),%eax
  802380:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802386:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80238d:	00 00 00 
	stat->st_dev = &devpipe;
  802390:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802397:	40 80 00 
	return 0;
}
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
  80239f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023a2:	5b                   	pop    %ebx
  8023a3:	5e                   	pop    %esi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    

008023a6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	53                   	push   %ebx
  8023aa:	83 ec 0c             	sub    $0xc,%esp
  8023ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023b0:	53                   	push   %ebx
  8023b1:	6a 00                	push   $0x0
  8023b3:	e8 c6 ea ff ff       	call   800e7e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b8:	89 1c 24             	mov    %ebx,(%esp)
  8023bb:	e8 15 f3 ff ff       	call   8016d5 <fd2data>
  8023c0:	83 c4 08             	add    $0x8,%esp
  8023c3:	50                   	push   %eax
  8023c4:	6a 00                	push   $0x0
  8023c6:	e8 b3 ea ff ff       	call   800e7e <sys_page_unmap>
}
  8023cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <_pipeisclosed>:
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	57                   	push   %edi
  8023d4:	56                   	push   %esi
  8023d5:	53                   	push   %ebx
  8023d6:	83 ec 1c             	sub    $0x1c,%esp
  8023d9:	89 c7                	mov    %eax,%edi
  8023db:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023dd:	a1 08 50 80 00       	mov    0x805008,%eax
  8023e2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	57                   	push   %edi
  8023e9:	e8 c2 04 00 00       	call   8028b0 <pageref>
  8023ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023f1:	89 34 24             	mov    %esi,(%esp)
  8023f4:	e8 b7 04 00 00       	call   8028b0 <pageref>
		nn = thisenv->env_runs;
  8023f9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023ff:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	39 cb                	cmp    %ecx,%ebx
  802407:	74 1b                	je     802424 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802409:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80240c:	75 cf                	jne    8023dd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80240e:	8b 42 58             	mov    0x58(%edx),%eax
  802411:	6a 01                	push   $0x1
  802413:	50                   	push   %eax
  802414:	53                   	push   %ebx
  802415:	68 8b 31 80 00       	push   $0x80318b
  80241a:	e8 89 de ff ff       	call   8002a8 <cprintf>
  80241f:	83 c4 10             	add    $0x10,%esp
  802422:	eb b9                	jmp    8023dd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802424:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802427:	0f 94 c0             	sete   %al
  80242a:	0f b6 c0             	movzbl %al,%eax
}
  80242d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802430:	5b                   	pop    %ebx
  802431:	5e                   	pop    %esi
  802432:	5f                   	pop    %edi
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    

00802435 <devpipe_write>:
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	57                   	push   %edi
  802439:	56                   	push   %esi
  80243a:	53                   	push   %ebx
  80243b:	83 ec 28             	sub    $0x28,%esp
  80243e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802441:	56                   	push   %esi
  802442:	e8 8e f2 ff ff       	call   8016d5 <fd2data>
  802447:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802449:	83 c4 10             	add    $0x10,%esp
  80244c:	bf 00 00 00 00       	mov    $0x0,%edi
  802451:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802454:	74 4f                	je     8024a5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802456:	8b 43 04             	mov    0x4(%ebx),%eax
  802459:	8b 0b                	mov    (%ebx),%ecx
  80245b:	8d 51 20             	lea    0x20(%ecx),%edx
  80245e:	39 d0                	cmp    %edx,%eax
  802460:	72 14                	jb     802476 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802462:	89 da                	mov    %ebx,%edx
  802464:	89 f0                	mov    %esi,%eax
  802466:	e8 65 ff ff ff       	call   8023d0 <_pipeisclosed>
  80246b:	85 c0                	test   %eax,%eax
  80246d:	75 3b                	jne    8024aa <devpipe_write+0x75>
			sys_yield();
  80246f:	e8 66 e9 ff ff       	call   800dda <sys_yield>
  802474:	eb e0                	jmp    802456 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802476:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802479:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80247d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802480:	89 c2                	mov    %eax,%edx
  802482:	c1 fa 1f             	sar    $0x1f,%edx
  802485:	89 d1                	mov    %edx,%ecx
  802487:	c1 e9 1b             	shr    $0x1b,%ecx
  80248a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80248d:	83 e2 1f             	and    $0x1f,%edx
  802490:	29 ca                	sub    %ecx,%edx
  802492:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802496:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80249a:	83 c0 01             	add    $0x1,%eax
  80249d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024a0:	83 c7 01             	add    $0x1,%edi
  8024a3:	eb ac                	jmp    802451 <devpipe_write+0x1c>
	return i;
  8024a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a8:	eb 05                	jmp    8024af <devpipe_write+0x7a>
				return 0;
  8024aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b2:	5b                   	pop    %ebx
  8024b3:	5e                   	pop    %esi
  8024b4:	5f                   	pop    %edi
  8024b5:	5d                   	pop    %ebp
  8024b6:	c3                   	ret    

008024b7 <devpipe_read>:
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	57                   	push   %edi
  8024bb:	56                   	push   %esi
  8024bc:	53                   	push   %ebx
  8024bd:	83 ec 18             	sub    $0x18,%esp
  8024c0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024c3:	57                   	push   %edi
  8024c4:	e8 0c f2 ff ff       	call   8016d5 <fd2data>
  8024c9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	be 00 00 00 00       	mov    $0x0,%esi
  8024d3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d6:	75 14                	jne    8024ec <devpipe_read+0x35>
	return i;
  8024d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024db:	eb 02                	jmp    8024df <devpipe_read+0x28>
				return i;
  8024dd:	89 f0                	mov    %esi,%eax
}
  8024df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e2:	5b                   	pop    %ebx
  8024e3:	5e                   	pop    %esi
  8024e4:	5f                   	pop    %edi
  8024e5:	5d                   	pop    %ebp
  8024e6:	c3                   	ret    
			sys_yield();
  8024e7:	e8 ee e8 ff ff       	call   800dda <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024ec:	8b 03                	mov    (%ebx),%eax
  8024ee:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024f1:	75 18                	jne    80250b <devpipe_read+0x54>
			if (i > 0)
  8024f3:	85 f6                	test   %esi,%esi
  8024f5:	75 e6                	jne    8024dd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024f7:	89 da                	mov    %ebx,%edx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	e8 d0 fe ff ff       	call   8023d0 <_pipeisclosed>
  802500:	85 c0                	test   %eax,%eax
  802502:	74 e3                	je     8024e7 <devpipe_read+0x30>
				return 0;
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
  802509:	eb d4                	jmp    8024df <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80250b:	99                   	cltd   
  80250c:	c1 ea 1b             	shr    $0x1b,%edx
  80250f:	01 d0                	add    %edx,%eax
  802511:	83 e0 1f             	and    $0x1f,%eax
  802514:	29 d0                	sub    %edx,%eax
  802516:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80251b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802521:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802524:	83 c6 01             	add    $0x1,%esi
  802527:	eb aa                	jmp    8024d3 <devpipe_read+0x1c>

00802529 <pipe>:
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	56                   	push   %esi
  80252d:	53                   	push   %ebx
  80252e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802531:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802534:	50                   	push   %eax
  802535:	e8 b2 f1 ff ff       	call   8016ec <fd_alloc>
  80253a:	89 c3                	mov    %eax,%ebx
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	85 c0                	test   %eax,%eax
  802541:	0f 88 23 01 00 00    	js     80266a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	68 07 04 00 00       	push   $0x407
  80254f:	ff 75 f4             	pushl  -0xc(%ebp)
  802552:	6a 00                	push   $0x0
  802554:	e8 a0 e8 ff ff       	call   800df9 <sys_page_alloc>
  802559:	89 c3                	mov    %eax,%ebx
  80255b:	83 c4 10             	add    $0x10,%esp
  80255e:	85 c0                	test   %eax,%eax
  802560:	0f 88 04 01 00 00    	js     80266a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80256c:	50                   	push   %eax
  80256d:	e8 7a f1 ff ff       	call   8016ec <fd_alloc>
  802572:	89 c3                	mov    %eax,%ebx
  802574:	83 c4 10             	add    $0x10,%esp
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 88 db 00 00 00    	js     80265a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 07 04 00 00       	push   $0x407
  802587:	ff 75 f0             	pushl  -0x10(%ebp)
  80258a:	6a 00                	push   $0x0
  80258c:	e8 68 e8 ff ff       	call   800df9 <sys_page_alloc>
  802591:	89 c3                	mov    %eax,%ebx
  802593:	83 c4 10             	add    $0x10,%esp
  802596:	85 c0                	test   %eax,%eax
  802598:	0f 88 bc 00 00 00    	js     80265a <pipe+0x131>
	va = fd2data(fd0);
  80259e:	83 ec 0c             	sub    $0xc,%esp
  8025a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a4:	e8 2c f1 ff ff       	call   8016d5 <fd2data>
  8025a9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ab:	83 c4 0c             	add    $0xc,%esp
  8025ae:	68 07 04 00 00       	push   $0x407
  8025b3:	50                   	push   %eax
  8025b4:	6a 00                	push   $0x0
  8025b6:	e8 3e e8 ff ff       	call   800df9 <sys_page_alloc>
  8025bb:	89 c3                	mov    %eax,%ebx
  8025bd:	83 c4 10             	add    $0x10,%esp
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	0f 88 82 00 00 00    	js     80264a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ce:	e8 02 f1 ff ff       	call   8016d5 <fd2data>
  8025d3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025da:	50                   	push   %eax
  8025db:	6a 00                	push   $0x0
  8025dd:	56                   	push   %esi
  8025de:	6a 00                	push   $0x0
  8025e0:	e8 57 e8 ff ff       	call   800e3c <sys_page_map>
  8025e5:	89 c3                	mov    %eax,%ebx
  8025e7:	83 c4 20             	add    $0x20,%esp
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	78 4e                	js     80263c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025ee:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802602:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802605:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802611:	83 ec 0c             	sub    $0xc,%esp
  802614:	ff 75 f4             	pushl  -0xc(%ebp)
  802617:	e8 a9 f0 ff ff       	call   8016c5 <fd2num>
  80261c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802621:	83 c4 04             	add    $0x4,%esp
  802624:	ff 75 f0             	pushl  -0x10(%ebp)
  802627:	e8 99 f0 ff ff       	call   8016c5 <fd2num>
  80262c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	bb 00 00 00 00       	mov    $0x0,%ebx
  80263a:	eb 2e                	jmp    80266a <pipe+0x141>
	sys_page_unmap(0, va);
  80263c:	83 ec 08             	sub    $0x8,%esp
  80263f:	56                   	push   %esi
  802640:	6a 00                	push   $0x0
  802642:	e8 37 e8 ff ff       	call   800e7e <sys_page_unmap>
  802647:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80264a:	83 ec 08             	sub    $0x8,%esp
  80264d:	ff 75 f0             	pushl  -0x10(%ebp)
  802650:	6a 00                	push   $0x0
  802652:	e8 27 e8 ff ff       	call   800e7e <sys_page_unmap>
  802657:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80265a:	83 ec 08             	sub    $0x8,%esp
  80265d:	ff 75 f4             	pushl  -0xc(%ebp)
  802660:	6a 00                	push   $0x0
  802662:	e8 17 e8 ff ff       	call   800e7e <sys_page_unmap>
  802667:	83 c4 10             	add    $0x10,%esp
}
  80266a:	89 d8                	mov    %ebx,%eax
  80266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80266f:	5b                   	pop    %ebx
  802670:	5e                   	pop    %esi
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <pipeisclosed>:
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267c:	50                   	push   %eax
  80267d:	ff 75 08             	pushl  0x8(%ebp)
  802680:	e8 b9 f0 ff ff       	call   80173e <fd_lookup>
  802685:	83 c4 10             	add    $0x10,%esp
  802688:	85 c0                	test   %eax,%eax
  80268a:	78 18                	js     8026a4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	ff 75 f4             	pushl  -0xc(%ebp)
  802692:	e8 3e f0 ff ff       	call   8016d5 <fd2data>
	return _pipeisclosed(fd, p);
  802697:	89 c2                	mov    %eax,%edx
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	e8 2f fd ff ff       	call   8023d0 <_pipeisclosed>
  8026a1:	83 c4 10             	add    $0x10,%esp
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	c3                   	ret    

008026ac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026b2:	68 a3 31 80 00       	push   $0x8031a3
  8026b7:	ff 75 0c             	pushl  0xc(%ebp)
  8026ba:	e8 48 e3 ff ff       	call   800a07 <strcpy>
	return 0;
}
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <devcons_write>:
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	57                   	push   %edi
  8026ca:	56                   	push   %esi
  8026cb:	53                   	push   %ebx
  8026cc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026d2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026d7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026dd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026e0:	73 31                	jae    802713 <devcons_write+0x4d>
		m = n - tot;
  8026e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e5:	29 f3                	sub    %esi,%ebx
  8026e7:	83 fb 7f             	cmp    $0x7f,%ebx
  8026ea:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026ef:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	53                   	push   %ebx
  8026f6:	89 f0                	mov    %esi,%eax
  8026f8:	03 45 0c             	add    0xc(%ebp),%eax
  8026fb:	50                   	push   %eax
  8026fc:	57                   	push   %edi
  8026fd:	e8 93 e4 ff ff       	call   800b95 <memmove>
		sys_cputs(buf, m);
  802702:	83 c4 08             	add    $0x8,%esp
  802705:	53                   	push   %ebx
  802706:	57                   	push   %edi
  802707:	e8 31 e6 ff ff       	call   800d3d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80270c:	01 de                	add    %ebx,%esi
  80270e:	83 c4 10             	add    $0x10,%esp
  802711:	eb ca                	jmp    8026dd <devcons_write+0x17>
}
  802713:	89 f0                	mov    %esi,%eax
  802715:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802718:	5b                   	pop    %ebx
  802719:	5e                   	pop    %esi
  80271a:	5f                   	pop    %edi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    

0080271d <devcons_read>:
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 08             	sub    $0x8,%esp
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80272c:	74 21                	je     80274f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80272e:	e8 28 e6 ff ff       	call   800d5b <sys_cgetc>
  802733:	85 c0                	test   %eax,%eax
  802735:	75 07                	jne    80273e <devcons_read+0x21>
		sys_yield();
  802737:	e8 9e e6 ff ff       	call   800dda <sys_yield>
  80273c:	eb f0                	jmp    80272e <devcons_read+0x11>
	if (c < 0)
  80273e:	78 0f                	js     80274f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802740:	83 f8 04             	cmp    $0x4,%eax
  802743:	74 0c                	je     802751 <devcons_read+0x34>
	*(char*)vbuf = c;
  802745:	8b 55 0c             	mov    0xc(%ebp),%edx
  802748:	88 02                	mov    %al,(%edx)
	return 1;
  80274a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274f:	c9                   	leave  
  802750:	c3                   	ret    
		return 0;
  802751:	b8 00 00 00 00       	mov    $0x0,%eax
  802756:	eb f7                	jmp    80274f <devcons_read+0x32>

00802758 <cputchar>:
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802764:	6a 01                	push   $0x1
  802766:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802769:	50                   	push   %eax
  80276a:	e8 ce e5 ff ff       	call   800d3d <sys_cputs>
}
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	c9                   	leave  
  802773:	c3                   	ret    

00802774 <getchar>:
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80277a:	6a 01                	push   $0x1
  80277c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277f:	50                   	push   %eax
  802780:	6a 00                	push   $0x0
  802782:	e8 27 f2 ff ff       	call   8019ae <read>
	if (r < 0)
  802787:	83 c4 10             	add    $0x10,%esp
  80278a:	85 c0                	test   %eax,%eax
  80278c:	78 06                	js     802794 <getchar+0x20>
	if (r < 1)
  80278e:	74 06                	je     802796 <getchar+0x22>
	return c;
  802790:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    
		return -E_EOF;
  802796:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80279b:	eb f7                	jmp    802794 <getchar+0x20>

0080279d <iscons>:
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a6:	50                   	push   %eax
  8027a7:	ff 75 08             	pushl  0x8(%ebp)
  8027aa:	e8 8f ef ff ff       	call   80173e <fd_lookup>
  8027af:	83 c4 10             	add    $0x10,%esp
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	78 11                	js     8027c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027bf:	39 10                	cmp    %edx,(%eax)
  8027c1:	0f 94 c0             	sete   %al
  8027c4:	0f b6 c0             	movzbl %al,%eax
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <opencons>:
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d2:	50                   	push   %eax
  8027d3:	e8 14 ef ff ff       	call   8016ec <fd_alloc>
  8027d8:	83 c4 10             	add    $0x10,%esp
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	78 3a                	js     802819 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027df:	83 ec 04             	sub    $0x4,%esp
  8027e2:	68 07 04 00 00       	push   $0x407
  8027e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ea:	6a 00                	push   $0x0
  8027ec:	e8 08 e6 ff ff       	call   800df9 <sys_page_alloc>
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	78 21                	js     802819 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802801:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	50                   	push   %eax
  802811:	e8 af ee ff ff       	call   8016c5 <fd2num>
  802816:	83 c4 10             	add    $0x10,%esp
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802821:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802828:	74 0a                	je     802834 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	6a 07                	push   $0x7
  802839:	68 00 f0 bf ee       	push   $0xeebff000
  80283e:	6a 00                	push   $0x0
  802840:	e8 b4 e5 ff ff       	call   800df9 <sys_page_alloc>
		if(r < 0)
  802845:	83 c4 10             	add    $0x10,%esp
  802848:	85 c0                	test   %eax,%eax
  80284a:	78 2a                	js     802876 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80284c:	83 ec 08             	sub    $0x8,%esp
  80284f:	68 8a 28 80 00       	push   $0x80288a
  802854:	6a 00                	push   $0x0
  802856:	e8 e9 e6 ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	85 c0                	test   %eax,%eax
  802860:	79 c8                	jns    80282a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 e0 31 80 00       	push   $0x8031e0
  80286a:	6a 25                	push   $0x25
  80286c:	68 1c 32 80 00       	push   $0x80321c
  802871:	e8 3c d9 ff ff       	call   8001b2 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	68 b0 31 80 00       	push   $0x8031b0
  80287e:	6a 22                	push   $0x22
  802880:	68 1c 32 80 00       	push   $0x80321c
  802885:	e8 28 d9 ff ff       	call   8001b2 <_panic>

0080288a <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80288a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80288b:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802890:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802892:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802895:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802899:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80289d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028a0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028a2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028a6:	83 c4 08             	add    $0x8,%esp
	popal
  8028a9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028aa:	83 c4 04             	add    $0x4,%esp
	popfl
  8028ad:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028ae:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028af:	c3                   	ret    

008028b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028b6:	89 d0                	mov    %edx,%eax
  8028b8:	c1 e8 16             	shr    $0x16,%eax
  8028bb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028c7:	f6 c1 01             	test   $0x1,%cl
  8028ca:	74 1d                	je     8028e9 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028cc:	c1 ea 0c             	shr    $0xc,%edx
  8028cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028d6:	f6 c2 01             	test   $0x1,%dl
  8028d9:	74 0e                	je     8028e9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028db:	c1 ea 0c             	shr    $0xc,%edx
  8028de:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028e5:	ef 
  8028e6:	0f b7 c0             	movzwl %ax,%eax
}
  8028e9:	5d                   	pop    %ebp
  8028ea:	c3                   	ret    
  8028eb:	66 90                	xchg   %ax,%ax
  8028ed:	66 90                	xchg   %ax,%ax
  8028ef:	90                   	nop

008028f0 <__udivdi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8028fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8028ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802903:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802907:	85 d2                	test   %edx,%edx
  802909:	75 4d                	jne    802958 <__udivdi3+0x68>
  80290b:	39 f3                	cmp    %esi,%ebx
  80290d:	76 19                	jbe    802928 <__udivdi3+0x38>
  80290f:	31 ff                	xor    %edi,%edi
  802911:	89 e8                	mov    %ebp,%eax
  802913:	89 f2                	mov    %esi,%edx
  802915:	f7 f3                	div    %ebx
  802917:	89 fa                	mov    %edi,%edx
  802919:	83 c4 1c             	add    $0x1c,%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 d9                	mov    %ebx,%ecx
  80292a:	85 db                	test   %ebx,%ebx
  80292c:	75 0b                	jne    802939 <__udivdi3+0x49>
  80292e:	b8 01 00 00 00       	mov    $0x1,%eax
  802933:	31 d2                	xor    %edx,%edx
  802935:	f7 f3                	div    %ebx
  802937:	89 c1                	mov    %eax,%ecx
  802939:	31 d2                	xor    %edx,%edx
  80293b:	89 f0                	mov    %esi,%eax
  80293d:	f7 f1                	div    %ecx
  80293f:	89 c6                	mov    %eax,%esi
  802941:	89 e8                	mov    %ebp,%eax
  802943:	89 f7                	mov    %esi,%edi
  802945:	f7 f1                	div    %ecx
  802947:	89 fa                	mov    %edi,%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	39 f2                	cmp    %esi,%edx
  80295a:	77 1c                	ja     802978 <__udivdi3+0x88>
  80295c:	0f bd fa             	bsr    %edx,%edi
  80295f:	83 f7 1f             	xor    $0x1f,%edi
  802962:	75 2c                	jne    802990 <__udivdi3+0xa0>
  802964:	39 f2                	cmp    %esi,%edx
  802966:	72 06                	jb     80296e <__udivdi3+0x7e>
  802968:	31 c0                	xor    %eax,%eax
  80296a:	39 eb                	cmp    %ebp,%ebx
  80296c:	77 a9                	ja     802917 <__udivdi3+0x27>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	eb a2                	jmp    802917 <__udivdi3+0x27>
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	31 ff                	xor    %edi,%edi
  80297a:	31 c0                	xor    %eax,%eax
  80297c:	89 fa                	mov    %edi,%edx
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	89 f9                	mov    %edi,%ecx
  802992:	b8 20 00 00 00       	mov    $0x20,%eax
  802997:	29 f8                	sub    %edi,%eax
  802999:	d3 e2                	shl    %cl,%edx
  80299b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80299f:	89 c1                	mov    %eax,%ecx
  8029a1:	89 da                	mov    %ebx,%edx
  8029a3:	d3 ea                	shr    %cl,%edx
  8029a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029a9:	09 d1                	or     %edx,%ecx
  8029ab:	89 f2                	mov    %esi,%edx
  8029ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b1:	89 f9                	mov    %edi,%ecx
  8029b3:	d3 e3                	shl    %cl,%ebx
  8029b5:	89 c1                	mov    %eax,%ecx
  8029b7:	d3 ea                	shr    %cl,%edx
  8029b9:	89 f9                	mov    %edi,%ecx
  8029bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029bf:	89 eb                	mov    %ebp,%ebx
  8029c1:	d3 e6                	shl    %cl,%esi
  8029c3:	89 c1                	mov    %eax,%ecx
  8029c5:	d3 eb                	shr    %cl,%ebx
  8029c7:	09 de                	or     %ebx,%esi
  8029c9:	89 f0                	mov    %esi,%eax
  8029cb:	f7 74 24 08          	divl   0x8(%esp)
  8029cf:	89 d6                	mov    %edx,%esi
  8029d1:	89 c3                	mov    %eax,%ebx
  8029d3:	f7 64 24 0c          	mull   0xc(%esp)
  8029d7:	39 d6                	cmp    %edx,%esi
  8029d9:	72 15                	jb     8029f0 <__udivdi3+0x100>
  8029db:	89 f9                	mov    %edi,%ecx
  8029dd:	d3 e5                	shl    %cl,%ebp
  8029df:	39 c5                	cmp    %eax,%ebp
  8029e1:	73 04                	jae    8029e7 <__udivdi3+0xf7>
  8029e3:	39 d6                	cmp    %edx,%esi
  8029e5:	74 09                	je     8029f0 <__udivdi3+0x100>
  8029e7:	89 d8                	mov    %ebx,%eax
  8029e9:	31 ff                	xor    %edi,%edi
  8029eb:	e9 27 ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029f3:	31 ff                	xor    %edi,%edi
  8029f5:	e9 1d ff ff ff       	jmp    802917 <__udivdi3+0x27>
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__umoddi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a0f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a17:	89 da                	mov    %ebx,%edx
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 43                	jne    802a60 <__umoddi3+0x60>
  802a1d:	39 df                	cmp    %ebx,%edi
  802a1f:	76 17                	jbe    802a38 <__umoddi3+0x38>
  802a21:	89 f0                	mov    %esi,%eax
  802a23:	f7 f7                	div    %edi
  802a25:	89 d0                	mov    %edx,%eax
  802a27:	31 d2                	xor    %edx,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 fd                	mov    %edi,%ebp
  802a3a:	85 ff                	test   %edi,%edi
  802a3c:	75 0b                	jne    802a49 <__umoddi3+0x49>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	31 d2                	xor    %edx,%edx
  802a45:	f7 f7                	div    %edi
  802a47:	89 c5                	mov    %eax,%ebp
  802a49:	89 d8                	mov    %ebx,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f5                	div    %ebp
  802a4f:	89 f0                	mov    %esi,%eax
  802a51:	f7 f5                	div    %ebp
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	eb d0                	jmp    802a27 <__umoddi3+0x27>
  802a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5e:	66 90                	xchg   %ax,%ax
  802a60:	89 f1                	mov    %esi,%ecx
  802a62:	39 d8                	cmp    %ebx,%eax
  802a64:	76 0a                	jbe    802a70 <__umoddi3+0x70>
  802a66:	89 f0                	mov    %esi,%eax
  802a68:	83 c4 1c             	add    $0x1c,%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    
  802a70:	0f bd e8             	bsr    %eax,%ebp
  802a73:	83 f5 1f             	xor    $0x1f,%ebp
  802a76:	75 20                	jne    802a98 <__umoddi3+0x98>
  802a78:	39 d8                	cmp    %ebx,%eax
  802a7a:	0f 82 b0 00 00 00    	jb     802b30 <__umoddi3+0x130>
  802a80:	39 f7                	cmp    %esi,%edi
  802a82:	0f 86 a8 00 00 00    	jbe    802b30 <__umoddi3+0x130>
  802a88:	89 c8                	mov    %ecx,%eax
  802a8a:	83 c4 1c             	add    $0x1c,%esp
  802a8d:	5b                   	pop    %ebx
  802a8e:	5e                   	pop    %esi
  802a8f:	5f                   	pop    %edi
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a9f:	29 ea                	sub    %ebp,%edx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aa7:	89 d1                	mov    %edx,%ecx
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	d3 e8                	shr    %cl,%eax
  802aad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ab1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ab5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ab9:	09 c1                	or     %eax,%ecx
  802abb:	89 d8                	mov    %ebx,%eax
  802abd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ac1:	89 e9                	mov    %ebp,%ecx
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	89 d1                	mov    %edx,%ecx
  802ac7:	d3 e8                	shr    %cl,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802acf:	d3 e3                	shl    %cl,%ebx
  802ad1:	89 c7                	mov    %eax,%edi
  802ad3:	89 d1                	mov    %edx,%ecx
  802ad5:	89 f0                	mov    %esi,%eax
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 fa                	mov    %edi,%edx
  802add:	d3 e6                	shl    %cl,%esi
  802adf:	09 d8                	or     %ebx,%eax
  802ae1:	f7 74 24 08          	divl   0x8(%esp)
  802ae5:	89 d1                	mov    %edx,%ecx
  802ae7:	89 f3                	mov    %esi,%ebx
  802ae9:	f7 64 24 0c          	mull   0xc(%esp)
  802aed:	89 c6                	mov    %eax,%esi
  802aef:	89 d7                	mov    %edx,%edi
  802af1:	39 d1                	cmp    %edx,%ecx
  802af3:	72 06                	jb     802afb <__umoddi3+0xfb>
  802af5:	75 10                	jne    802b07 <__umoddi3+0x107>
  802af7:	39 c3                	cmp    %eax,%ebx
  802af9:	73 0c                	jae    802b07 <__umoddi3+0x107>
  802afb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802aff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b03:	89 d7                	mov    %edx,%edi
  802b05:	89 c6                	mov    %eax,%esi
  802b07:	89 ca                	mov    %ecx,%edx
  802b09:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b0e:	29 f3                	sub    %esi,%ebx
  802b10:	19 fa                	sbb    %edi,%edx
  802b12:	89 d0                	mov    %edx,%eax
  802b14:	d3 e0                	shl    %cl,%eax
  802b16:	89 e9                	mov    %ebp,%ecx
  802b18:	d3 eb                	shr    %cl,%ebx
  802b1a:	d3 ea                	shr    %cl,%edx
  802b1c:	09 d8                	or     %ebx,%eax
  802b1e:	83 c4 1c             	add    $0x1c,%esp
  802b21:	5b                   	pop    %ebx
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	89 da                	mov    %ebx,%edx
  802b32:	29 fe                	sub    %edi,%esi
  802b34:	19 c2                	sbb    %eax,%edx
  802b36:	89 f1                	mov    %esi,%ecx
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	e9 4b ff ff ff       	jmp    802a8a <__umoddi3+0x8a>
