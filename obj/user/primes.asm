
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
  800047:	e8 82 14 00 00       	call   8014ce <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 04 20 80 00       	mov    0x802004,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 c0 18 80 00       	push   $0x8018c0
  800060:	e8 2e 02 00 00       	call   800293 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 b8 11 00 00       	call   801222 <fork>
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
  80007b:	68 cc 18 80 00       	push   $0x8018cc
  800080:	6a 1a                	push   $0x1a
  800082:	68 d5 18 80 00       	push   $0x8018d5
  800087:	e8 11 01 00 00       	call   80019d <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 a0 14 00 00       	call   801537 <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 27 14 00 00       	call   8014ce <ipc_recv>
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
  8000ba:	e8 63 11 00 00       	call   801222 <fork>
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
  8000d2:	e8 60 14 00 00       	call   801537 <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 cc 18 80 00       	push   $0x8018cc
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 d5 18 80 00       	push   $0x8018d5
  8000ec:	e8 ac 00 00 00       	call   80019d <_panic>
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
  8000ff:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800106:	00 00 00 
	envid_t find = sys_getenvid();
  800109:	e8 98 0c 00 00       	call   800da6 <sys_getenvid>
  80010e:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
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
  800157:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800161:	7e 0a                	jle    80016d <libmain+0x77>
		binaryname = argv[0];
  800163:	8b 45 0c             	mov    0xc(%ebp),%eax
  800166:	8b 00                	mov    (%eax),%eax
  800168:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	ff 75 0c             	pushl  0xc(%ebp)
  800173:	ff 75 08             	pushl  0x8(%ebp)
  800176:	e8 3a ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80017b:	e8 0b 00 00 00       	call   80018b <exit>
}
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800186:	5b                   	pop    %ebx
  800187:	5e                   	pop    %esi
  800188:	5f                   	pop    %edi
  800189:	5d                   	pop    %ebp
  80018a:	c3                   	ret    

0080018b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800191:	6a 00                	push   $0x0
  800193:	e8 cd 0b 00 00       	call   800d65 <sys_env_destroy>
}
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	56                   	push   %esi
  8001a1:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001a2:	a1 04 20 80 00       	mov    0x802004,%eax
  8001a7:	8b 40 48             	mov    0x48(%eax),%eax
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 1c 19 80 00       	push   $0x80191c
  8001b2:	50                   	push   %eax
  8001b3:	68 ed 18 80 00       	push   $0x8018ed
  8001b8:	e8 d6 00 00 00       	call   800293 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001bd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c0:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8001c6:	e8 db 0b 00 00       	call   800da6 <sys_getenvid>
  8001cb:	83 c4 04             	add    $0x4,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	56                   	push   %esi
  8001d5:	50                   	push   %eax
  8001d6:	68 f8 18 80 00       	push   $0x8018f8
  8001db:	e8 b3 00 00 00       	call   800293 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e0:	83 c4 18             	add    $0x18,%esp
  8001e3:	53                   	push   %ebx
  8001e4:	ff 75 10             	pushl  0x10(%ebp)
  8001e7:	e8 56 00 00 00       	call   800242 <vcprintf>
	cprintf("\n");
  8001ec:	c7 04 24 19 1d 80 00 	movl   $0x801d19,(%esp)
  8001f3:	e8 9b 00 00 00       	call   800293 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001fb:	cc                   	int3   
  8001fc:	eb fd                	jmp    8001fb <_panic+0x5e>

008001fe <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	53                   	push   %ebx
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800208:	8b 13                	mov    (%ebx),%edx
  80020a:	8d 42 01             	lea    0x1(%edx),%eax
  80020d:	89 03                	mov    %eax,(%ebx)
  80020f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800212:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800216:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021b:	74 09                	je     800226 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800221:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800224:	c9                   	leave  
  800225:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	68 ff 00 00 00       	push   $0xff
  80022e:	8d 43 08             	lea    0x8(%ebx),%eax
  800231:	50                   	push   %eax
  800232:	e8 f1 0a 00 00       	call   800d28 <sys_cputs>
		b->idx = 0;
  800237:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	eb db                	jmp    80021d <putch+0x1f>

00800242 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800252:	00 00 00 
	b.cnt = 0;
  800255:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025f:	ff 75 0c             	pushl  0xc(%ebp)
  800262:	ff 75 08             	pushl  0x8(%ebp)
  800265:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	68 fe 01 80 00       	push   $0x8001fe
  800271:	e8 4a 01 00 00       	call   8003c0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800276:	83 c4 08             	add    $0x8,%esp
  800279:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80027f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	e8 9d 0a 00 00       	call   800d28 <sys_cputs>

	return b.cnt;
}
  80028b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800299:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029c:	50                   	push   %eax
  80029d:	ff 75 08             	pushl  0x8(%ebp)
  8002a0:	e8 9d ff ff ff       	call   800242 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 1c             	sub    $0x1c,%esp
  8002b0:	89 c6                	mov    %eax,%esi
  8002b2:	89 d7                	mov    %edx,%edi
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002c6:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ca:	74 2c                	je     8002f8 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002d9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002e1:	73 43                	jae    800326 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002e3:	83 eb 01             	sub    $0x1,%ebx
  8002e6:	85 db                	test   %ebx,%ebx
  8002e8:	7e 6c                	jle    800356 <printnum+0xaf>
				putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	57                   	push   %edi
  8002ee:	ff 75 18             	pushl  0x18(%ebp)
  8002f1:	ff d6                	call   *%esi
  8002f3:	83 c4 10             	add    $0x10,%esp
  8002f6:	eb eb                	jmp    8002e3 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	6a 20                	push   $0x20
  8002fd:	6a 00                	push   $0x0
  8002ff:	50                   	push   %eax
  800300:	ff 75 e4             	pushl  -0x1c(%ebp)
  800303:	ff 75 e0             	pushl  -0x20(%ebp)
  800306:	89 fa                	mov    %edi,%edx
  800308:	89 f0                	mov    %esi,%eax
  80030a:	e8 98 ff ff ff       	call   8002a7 <printnum>
		while (--width > 0)
  80030f:	83 c4 20             	add    $0x20,%esp
  800312:	83 eb 01             	sub    $0x1,%ebx
  800315:	85 db                	test   %ebx,%ebx
  800317:	7e 65                	jle    80037e <printnum+0xd7>
			putch(padc, putdat);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	57                   	push   %edi
  80031d:	6a 20                	push   $0x20
  80031f:	ff d6                	call   *%esi
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	eb ec                	jmp    800312 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	ff 75 18             	pushl  0x18(%ebp)
  80032c:	83 eb 01             	sub    $0x1,%ebx
  80032f:	53                   	push   %ebx
  800330:	50                   	push   %eax
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	ff 75 dc             	pushl  -0x24(%ebp)
  800337:	ff 75 d8             	pushl  -0x28(%ebp)
  80033a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033d:	ff 75 e0             	pushl  -0x20(%ebp)
  800340:	e8 1b 13 00 00       	call   801660 <__udivdi3>
  800345:	83 c4 18             	add    $0x18,%esp
  800348:	52                   	push   %edx
  800349:	50                   	push   %eax
  80034a:	89 fa                	mov    %edi,%edx
  80034c:	89 f0                	mov    %esi,%eax
  80034e:	e8 54 ff ff ff       	call   8002a7 <printnum>
  800353:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	57                   	push   %edi
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	ff 75 dc             	pushl  -0x24(%ebp)
  800360:	ff 75 d8             	pushl  -0x28(%ebp)
  800363:	ff 75 e4             	pushl  -0x1c(%ebp)
  800366:	ff 75 e0             	pushl  -0x20(%ebp)
  800369:	e8 02 14 00 00       	call   801770 <__umoddi3>
  80036e:	83 c4 14             	add    $0x14,%esp
  800371:	0f be 80 23 19 80 00 	movsbl 0x801923(%eax),%eax
  800378:	50                   	push   %eax
  800379:	ff d6                	call   *%esi
  80037b:	83 c4 10             	add    $0x10,%esp
	}
}
  80037e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800381:	5b                   	pop    %ebx
  800382:	5e                   	pop    %esi
  800383:	5f                   	pop    %edi
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800390:	8b 10                	mov    (%eax),%edx
  800392:	3b 50 04             	cmp    0x4(%eax),%edx
  800395:	73 0a                	jae    8003a1 <sprintputch+0x1b>
		*b->buf++ = ch;
  800397:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039a:	89 08                	mov    %ecx,(%eax)
  80039c:	8b 45 08             	mov    0x8(%ebp),%eax
  80039f:	88 02                	mov    %al,(%edx)
}
  8003a1:	5d                   	pop    %ebp
  8003a2:	c3                   	ret    

008003a3 <printfmt>:
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ac:	50                   	push   %eax
  8003ad:	ff 75 10             	pushl  0x10(%ebp)
  8003b0:	ff 75 0c             	pushl  0xc(%ebp)
  8003b3:	ff 75 08             	pushl  0x8(%ebp)
  8003b6:	e8 05 00 00 00       	call   8003c0 <vprintfmt>
}
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <vprintfmt>:
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	57                   	push   %edi
  8003c4:	56                   	push   %esi
  8003c5:	53                   	push   %ebx
  8003c6:	83 ec 3c             	sub    $0x3c,%esp
  8003c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8003cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003d2:	e9 32 04 00 00       	jmp    800809 <vprintfmt+0x449>
		padc = ' ';
  8003d7:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003db:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003e2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003f7:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8d 47 01             	lea    0x1(%edi),%eax
  800406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800409:	0f b6 17             	movzbl (%edi),%edx
  80040c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040f:	3c 55                	cmp    $0x55,%al
  800411:	0f 87 12 05 00 00    	ja     800929 <vprintfmt+0x569>
  800417:	0f b6 c0             	movzbl %al,%eax
  80041a:	ff 24 85 00 1b 80 00 	jmp    *0x801b00(,%eax,4)
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800424:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800428:	eb d9                	jmp    800403 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80042d:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800431:	eb d0                	jmp    800403 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800433:	0f b6 d2             	movzbl %dl,%edx
  800436:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	89 75 08             	mov    %esi,0x8(%ebp)
  800441:	eb 03                	jmp    800446 <vprintfmt+0x86>
  800443:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800446:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800449:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80044d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800450:	8d 72 d0             	lea    -0x30(%edx),%esi
  800453:	83 fe 09             	cmp    $0x9,%esi
  800456:	76 eb                	jbe    800443 <vprintfmt+0x83>
  800458:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045b:	8b 75 08             	mov    0x8(%ebp),%esi
  80045e:	eb 14                	jmp    800474 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8d 40 04             	lea    0x4(%eax),%eax
  80046e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800471:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800478:	79 89                	jns    800403 <vprintfmt+0x43>
				width = precision, precision = -1;
  80047a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80047d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800480:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800487:	e9 77 ff ff ff       	jmp    800403 <vprintfmt+0x43>
  80048c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048f:	85 c0                	test   %eax,%eax
  800491:	0f 48 c1             	cmovs  %ecx,%eax
  800494:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800497:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80049a:	e9 64 ff ff ff       	jmp    800403 <vprintfmt+0x43>
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004a2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004a9:	e9 55 ff ff ff       	jmp    800403 <vprintfmt+0x43>
			lflag++;
  8004ae:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b5:	e9 49 ff ff ff       	jmp    800403 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 78 04             	lea    0x4(%eax),%edi
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	53                   	push   %ebx
  8004c4:	ff 30                	pushl  (%eax)
  8004c6:	ff d6                	call   *%esi
			break;
  8004c8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004ce:	e9 33 03 00 00       	jmp    800806 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 78 04             	lea    0x4(%eax),%edi
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	99                   	cltd   
  8004dc:	31 d0                	xor    %edx,%eax
  8004de:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e0:	83 f8 0f             	cmp    $0xf,%eax
  8004e3:	7f 23                	jg     800508 <vprintfmt+0x148>
  8004e5:	8b 14 85 60 1c 80 00 	mov    0x801c60(,%eax,4),%edx
  8004ec:	85 d2                	test   %edx,%edx
  8004ee:	74 18                	je     800508 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004f0:	52                   	push   %edx
  8004f1:	68 44 19 80 00       	push   $0x801944
  8004f6:	53                   	push   %ebx
  8004f7:	56                   	push   %esi
  8004f8:	e8 a6 fe ff ff       	call   8003a3 <printfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
  800503:	e9 fe 02 00 00       	jmp    800806 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800508:	50                   	push   %eax
  800509:	68 3b 19 80 00       	push   $0x80193b
  80050e:	53                   	push   %ebx
  80050f:	56                   	push   %esi
  800510:	e8 8e fe ff ff       	call   8003a3 <printfmt>
  800515:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800518:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051b:	e9 e6 02 00 00       	jmp    800806 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	83 c0 04             	add    $0x4,%eax
  800526:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 34 19 80 00       	mov    $0x801934,%eax
  800535:	0f 45 c1             	cmovne %ecx,%eax
  800538:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80053b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053f:	7e 06                	jle    800547 <vprintfmt+0x187>
  800541:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800545:	75 0d                	jne    800554 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800547:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80054a:	89 c7                	mov    %eax,%edi
  80054c:	03 45 e0             	add    -0x20(%ebp),%eax
  80054f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800552:	eb 53                	jmp    8005a7 <vprintfmt+0x1e7>
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	ff 75 d8             	pushl  -0x28(%ebp)
  80055a:	50                   	push   %eax
  80055b:	e8 71 04 00 00       	call   8009d1 <strnlen>
  800560:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800563:	29 c1                	sub    %eax,%ecx
  800565:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80056d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800571:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800574:	eb 0f                	jmp    800585 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	ff 75 e0             	pushl  -0x20(%ebp)
  80057d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057f:	83 ef 01             	sub    $0x1,%edi
  800582:	83 c4 10             	add    $0x10,%esp
  800585:	85 ff                	test   %edi,%edi
  800587:	7f ed                	jg     800576 <vprintfmt+0x1b6>
  800589:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	b8 00 00 00 00       	mov    $0x0,%eax
  800593:	0f 49 c1             	cmovns %ecx,%eax
  800596:	29 c1                	sub    %eax,%ecx
  800598:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80059b:	eb aa                	jmp    800547 <vprintfmt+0x187>
					putch(ch, putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	52                   	push   %edx
  8005a2:	ff d6                	call   *%esi
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005aa:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ac:	83 c7 01             	add    $0x1,%edi
  8005af:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005b3:	0f be d0             	movsbl %al,%edx
  8005b6:	85 d2                	test   %edx,%edx
  8005b8:	74 4b                	je     800605 <vprintfmt+0x245>
  8005ba:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005be:	78 06                	js     8005c6 <vprintfmt+0x206>
  8005c0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005c4:	78 1e                	js     8005e4 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ca:	74 d1                	je     80059d <vprintfmt+0x1dd>
  8005cc:	0f be c0             	movsbl %al,%eax
  8005cf:	83 e8 20             	sub    $0x20,%eax
  8005d2:	83 f8 5e             	cmp    $0x5e,%eax
  8005d5:	76 c6                	jbe    80059d <vprintfmt+0x1dd>
					putch('?', putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	53                   	push   %ebx
  8005db:	6a 3f                	push   $0x3f
  8005dd:	ff d6                	call   *%esi
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	eb c3                	jmp    8005a7 <vprintfmt+0x1e7>
  8005e4:	89 cf                	mov    %ecx,%edi
  8005e6:	eb 0e                	jmp    8005f6 <vprintfmt+0x236>
				putch(' ', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 20                	push   $0x20
  8005ee:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005f0:	83 ef 01             	sub    $0x1,%edi
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	85 ff                	test   %edi,%edi
  8005f8:	7f ee                	jg     8005e8 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800600:	e9 01 02 00 00       	jmp    800806 <vprintfmt+0x446>
  800605:	89 cf                	mov    %ecx,%edi
  800607:	eb ed                	jmp    8005f6 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80060c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800613:	e9 eb fd ff ff       	jmp    800403 <vprintfmt+0x43>
	if (lflag >= 2)
  800618:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061c:	7f 21                	jg     80063f <vprintfmt+0x27f>
	else if (lflag)
  80061e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800622:	74 68                	je     80068c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80062c:	89 c1                	mov    %eax,%ecx
  80062e:	c1 f9 1f             	sar    $0x1f,%ecx
  800631:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
  80063d:	eb 17                	jmp    800656 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 50 04             	mov    0x4(%eax),%edx
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 08             	lea    0x8(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800656:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800659:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800662:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800666:	78 3f                	js     8006a7 <vprintfmt+0x2e7>
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80066d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800671:	0f 84 71 01 00 00    	je     8007e8 <vprintfmt+0x428>
				putch('+', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 2b                	push   $0x2b
  80067d:	ff d6                	call   *%esi
  80067f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800682:	b8 0a 00 00 00       	mov    $0xa,%eax
  800687:	e9 5c 01 00 00       	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800694:	89 c1                	mov    %eax,%ecx
  800696:	c1 f9 1f             	sar    $0x1f,%ecx
  800699:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb af                	jmp    800656 <vprintfmt+0x296>
				putch('-', putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 2d                	push   $0x2d
  8006ad:	ff d6                	call   *%esi
				num = -(long long) num;
  8006af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b5:	f7 d8                	neg    %eax
  8006b7:	83 d2 00             	adc    $0x0,%edx
  8006ba:	f7 da                	neg    %edx
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 19 01 00 00       	jmp    8007e8 <vprintfmt+0x428>
	if (lflag >= 2)
  8006cf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006d3:	7f 29                	jg     8006fe <vprintfmt+0x33e>
	else if (lflag)
  8006d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d9:	74 44                	je     80071f <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f9:	e9 ea 00 00 00       	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 50 04             	mov    0x4(%eax),%edx
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800709:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070c:	8b 45 14             	mov    0x14(%ebp),%eax
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800715:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071a:	e9 c9 00 00 00       	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	ba 00 00 00 00       	mov    $0x0,%edx
  800729:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 40 04             	lea    0x4(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800738:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073d:	e9 a6 00 00 00       	jmp    8007e8 <vprintfmt+0x428>
			putch('0', putdat);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	53                   	push   %ebx
  800746:	6a 30                	push   $0x30
  800748:	ff d6                	call   *%esi
	if (lflag >= 2)
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800751:	7f 26                	jg     800779 <vprintfmt+0x3b9>
	else if (lflag)
  800753:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800757:	74 3e                	je     800797 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800772:	b8 08 00 00 00       	mov    $0x8,%eax
  800777:	eb 6f                	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 50 04             	mov    0x4(%eax),%edx
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 40 08             	lea    0x8(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800790:	b8 08 00 00 00       	mov    $0x8,%eax
  800795:	eb 51                	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b5:	eb 31                	jmp    8007e8 <vprintfmt+0x428>
			putch('0', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	6a 30                	push   $0x30
  8007bd:	ff d6                	call   *%esi
			putch('x', putdat);
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 78                	push   $0x78
  8007c5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007d7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007ef:	52                   	push   %edx
  8007f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f3:	50                   	push   %eax
  8007f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8007f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8007fa:	89 da                	mov    %ebx,%edx
  8007fc:	89 f0                	mov    %esi,%eax
  8007fe:	e8 a4 fa ff ff       	call   8002a7 <printnum>
			break;
  800803:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800806:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800809:	83 c7 01             	add    $0x1,%edi
  80080c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800810:	83 f8 25             	cmp    $0x25,%eax
  800813:	0f 84 be fb ff ff    	je     8003d7 <vprintfmt+0x17>
			if (ch == '\0')
  800819:	85 c0                	test   %eax,%eax
  80081b:	0f 84 28 01 00 00    	je     800949 <vprintfmt+0x589>
			putch(ch, putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	53                   	push   %ebx
  800825:	50                   	push   %eax
  800826:	ff d6                	call   *%esi
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb dc                	jmp    800809 <vprintfmt+0x449>
	if (lflag >= 2)
  80082d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800831:	7f 26                	jg     800859 <vprintfmt+0x499>
	else if (lflag)
  800833:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800837:	74 41                	je     80087a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	ba 00 00 00 00       	mov    $0x0,%edx
  800843:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800846:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8d 40 04             	lea    0x4(%eax),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800852:	b8 10 00 00 00       	mov    $0x10,%eax
  800857:	eb 8f                	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 50 04             	mov    0x4(%eax),%edx
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800864:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8d 40 08             	lea    0x8(%eax),%eax
  80086d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800870:	b8 10 00 00 00       	mov    $0x10,%eax
  800875:	e9 6e ff ff ff       	jmp    8007e8 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	8d 40 04             	lea    0x4(%eax),%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800893:	b8 10 00 00 00       	mov    $0x10,%eax
  800898:	e9 4b ff ff ff       	jmp    8007e8 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 c0 04             	add    $0x4,%eax
  8008a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	85 c0                	test   %eax,%eax
  8008ad:	74 14                	je     8008c3 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008af:	8b 13                	mov    (%ebx),%edx
  8008b1:	83 fa 7f             	cmp    $0x7f,%edx
  8008b4:	7f 37                	jg     8008ed <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008b6:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	e9 43 ff ff ff       	jmp    800806 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c8:	bf 5d 1a 80 00       	mov    $0x801a5d,%edi
							putch(ch, putdat);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	53                   	push   %ebx
  8008d1:	50                   	push   %eax
  8008d2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008d4:	83 c7 01             	add    $0x1,%edi
  8008d7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	75 eb                	jne    8008cd <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e8:	e9 19 ff ff ff       	jmp    800806 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008ed:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f4:	bf 95 1a 80 00       	mov    $0x801a95,%edi
							putch(ch, putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	53                   	push   %ebx
  8008fd:	50                   	push   %eax
  8008fe:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800900:	83 c7 01             	add    $0x1,%edi
  800903:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	85 c0                	test   %eax,%eax
  80090c:	75 eb                	jne    8008f9 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80090e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
  800914:	e9 ed fe ff ff       	jmp    800806 <vprintfmt+0x446>
			putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	6a 25                	push   $0x25
  80091f:	ff d6                	call   *%esi
			break;
  800921:	83 c4 10             	add    $0x10,%esp
  800924:	e9 dd fe ff ff       	jmp    800806 <vprintfmt+0x446>
			putch('%', putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	53                   	push   %ebx
  80092d:	6a 25                	push   $0x25
  80092f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	89 f8                	mov    %edi,%eax
  800936:	eb 03                	jmp    80093b <vprintfmt+0x57b>
  800938:	83 e8 01             	sub    $0x1,%eax
  80093b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80093f:	75 f7                	jne    800938 <vprintfmt+0x578>
  800941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800944:	e9 bd fe ff ff       	jmp    800806 <vprintfmt+0x446>
}
  800949:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80094c:	5b                   	pop    %ebx
  80094d:	5e                   	pop    %esi
  80094e:	5f                   	pop    %edi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 18             	sub    $0x18,%esp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800960:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800964:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800967:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096e:	85 c0                	test   %eax,%eax
  800970:	74 26                	je     800998 <vsnprintf+0x47>
  800972:	85 d2                	test   %edx,%edx
  800974:	7e 22                	jle    800998 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800976:	ff 75 14             	pushl  0x14(%ebp)
  800979:	ff 75 10             	pushl  0x10(%ebp)
  80097c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097f:	50                   	push   %eax
  800980:	68 86 03 80 00       	push   $0x800386
  800985:	e8 36 fa ff ff       	call   8003c0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80098a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80098d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800993:	83 c4 10             	add    $0x10,%esp
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    
		return -E_INVAL;
  800998:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80099d:	eb f7                	jmp    800996 <vsnprintf+0x45>

0080099f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009a8:	50                   	push   %eax
  8009a9:	ff 75 10             	pushl  0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 9a ff ff ff       	call   800951 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c8:	74 05                	je     8009cf <strlen+0x16>
		n++;
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	eb f5                	jmp    8009c4 <strlen+0xb>
	return n;
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	39 c2                	cmp    %eax,%edx
  8009e1:	74 0d                	je     8009f0 <strnlen+0x1f>
  8009e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009e7:	74 05                	je     8009ee <strnlen+0x1d>
		n++;
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	eb f1                	jmp    8009df <strnlen+0xe>
  8009ee:	89 d0                	mov    %edx,%eax
	return n;
}
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800a01:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a05:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a08:	83 c2 01             	add    $0x1,%edx
  800a0b:	84 c9                	test   %cl,%cl
  800a0d:	75 f2                	jne    800a01 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	83 ec 10             	sub    $0x10,%esp
  800a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a1c:	53                   	push   %ebx
  800a1d:	e8 97 ff ff ff       	call   8009b9 <strlen>
  800a22:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	01 d8                	add    %ebx,%eax
  800a2a:	50                   	push   %eax
  800a2b:	e8 c2 ff ff ff       	call   8009f2 <strcpy>
	return dst;
}
  800a30:	89 d8                	mov    %ebx,%eax
  800a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	56                   	push   %esi
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a42:	89 c6                	mov    %eax,%esi
  800a44:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a47:	89 c2                	mov    %eax,%edx
  800a49:	39 f2                	cmp    %esi,%edx
  800a4b:	74 11                	je     800a5e <strncpy+0x27>
		*dst++ = *src;
  800a4d:	83 c2 01             	add    $0x1,%edx
  800a50:	0f b6 19             	movzbl (%ecx),%ebx
  800a53:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a56:	80 fb 01             	cmp    $0x1,%bl
  800a59:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a5c:	eb eb                	jmp    800a49 <strncpy+0x12>
	}
	return ret;
}
  800a5e:	5b                   	pop    %ebx
  800a5f:	5e                   	pop    %esi
  800a60:	5d                   	pop    %ebp
  800a61:	c3                   	ret    

00800a62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 75 08             	mov    0x8(%ebp),%esi
  800a6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6d:	8b 55 10             	mov    0x10(%ebp),%edx
  800a70:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a72:	85 d2                	test   %edx,%edx
  800a74:	74 21                	je     800a97 <strlcpy+0x35>
  800a76:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a7a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a7c:	39 c2                	cmp    %eax,%edx
  800a7e:	74 14                	je     800a94 <strlcpy+0x32>
  800a80:	0f b6 19             	movzbl (%ecx),%ebx
  800a83:	84 db                	test   %bl,%bl
  800a85:	74 0b                	je     800a92 <strlcpy+0x30>
			*dst++ = *src++;
  800a87:	83 c1 01             	add    $0x1,%ecx
  800a8a:	83 c2 01             	add    $0x1,%edx
  800a8d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a90:	eb ea                	jmp    800a7c <strlcpy+0x1a>
  800a92:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a97:	29 f0                	sub    %esi,%eax
}
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa6:	0f b6 01             	movzbl (%ecx),%eax
  800aa9:	84 c0                	test   %al,%al
  800aab:	74 0c                	je     800ab9 <strcmp+0x1c>
  800aad:	3a 02                	cmp    (%edx),%al
  800aaf:	75 08                	jne    800ab9 <strcmp+0x1c>
		p++, q++;
  800ab1:	83 c1 01             	add    $0x1,%ecx
  800ab4:	83 c2 01             	add    $0x1,%edx
  800ab7:	eb ed                	jmp    800aa6 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 12             	movzbl (%edx),%edx
  800abf:	29 d0                	sub    %edx,%eax
}
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	53                   	push   %ebx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acd:	89 c3                	mov    %eax,%ebx
  800acf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad2:	eb 06                	jmp    800ada <strncmp+0x17>
		n--, p++, q++;
  800ad4:	83 c0 01             	add    $0x1,%eax
  800ad7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ada:	39 d8                	cmp    %ebx,%eax
  800adc:	74 16                	je     800af4 <strncmp+0x31>
  800ade:	0f b6 08             	movzbl (%eax),%ecx
  800ae1:	84 c9                	test   %cl,%cl
  800ae3:	74 04                	je     800ae9 <strncmp+0x26>
  800ae5:	3a 0a                	cmp    (%edx),%cl
  800ae7:	74 eb                	je     800ad4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae9:	0f b6 00             	movzbl (%eax),%eax
  800aec:	0f b6 12             	movzbl (%edx),%edx
  800aef:	29 d0                	sub    %edx,%eax
}
  800af1:	5b                   	pop    %ebx
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
		return 0;
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
  800af9:	eb f6                	jmp    800af1 <strncmp+0x2e>

00800afb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b05:	0f b6 10             	movzbl (%eax),%edx
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	74 09                	je     800b15 <strchr+0x1a>
		if (*s == c)
  800b0c:	38 ca                	cmp    %cl,%dl
  800b0e:	74 0a                	je     800b1a <strchr+0x1f>
	for (; *s; s++)
  800b10:	83 c0 01             	add    $0x1,%eax
  800b13:	eb f0                	jmp    800b05 <strchr+0xa>
			return (char *) s;
	return 0;
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b26:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b29:	38 ca                	cmp    %cl,%dl
  800b2b:	74 09                	je     800b36 <strfind+0x1a>
  800b2d:	84 d2                	test   %dl,%dl
  800b2f:	74 05                	je     800b36 <strfind+0x1a>
	for (; *s; s++)
  800b31:	83 c0 01             	add    $0x1,%eax
  800b34:	eb f0                	jmp    800b26 <strfind+0xa>
			break;
	return (char *) s;
}
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	57                   	push   %edi
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b44:	85 c9                	test   %ecx,%ecx
  800b46:	74 31                	je     800b79 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b48:	89 f8                	mov    %edi,%eax
  800b4a:	09 c8                	or     %ecx,%eax
  800b4c:	a8 03                	test   $0x3,%al
  800b4e:	75 23                	jne    800b73 <memset+0x3b>
		c &= 0xFF;
  800b50:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b54:	89 d3                	mov    %edx,%ebx
  800b56:	c1 e3 08             	shl    $0x8,%ebx
  800b59:	89 d0                	mov    %edx,%eax
  800b5b:	c1 e0 18             	shl    $0x18,%eax
  800b5e:	89 d6                	mov    %edx,%esi
  800b60:	c1 e6 10             	shl    $0x10,%esi
  800b63:	09 f0                	or     %esi,%eax
  800b65:	09 c2                	or     %eax,%edx
  800b67:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b69:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b6c:	89 d0                	mov    %edx,%eax
  800b6e:	fc                   	cld    
  800b6f:	f3 ab                	rep stos %eax,%es:(%edi)
  800b71:	eb 06                	jmp    800b79 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	fc                   	cld    
  800b77:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b79:	89 f8                	mov    %edi,%eax
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8e:	39 c6                	cmp    %eax,%esi
  800b90:	73 32                	jae    800bc4 <memmove+0x44>
  800b92:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b95:	39 c2                	cmp    %eax,%edx
  800b97:	76 2b                	jbe    800bc4 <memmove+0x44>
		s += n;
		d += n;
  800b99:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9c:	89 fe                	mov    %edi,%esi
  800b9e:	09 ce                	or     %ecx,%esi
  800ba0:	09 d6                	or     %edx,%esi
  800ba2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ba8:	75 0e                	jne    800bb8 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800baa:	83 ef 04             	sub    $0x4,%edi
  800bad:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bb0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bb3:	fd                   	std    
  800bb4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb6:	eb 09                	jmp    800bc1 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bb8:	83 ef 01             	sub    $0x1,%edi
  800bbb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bbe:	fd                   	std    
  800bbf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bc1:	fc                   	cld    
  800bc2:	eb 1a                	jmp    800bde <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc4:	89 c2                	mov    %eax,%edx
  800bc6:	09 ca                	or     %ecx,%edx
  800bc8:	09 f2                	or     %esi,%edx
  800bca:	f6 c2 03             	test   $0x3,%dl
  800bcd:	75 0a                	jne    800bd9 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bd2:	89 c7                	mov    %eax,%edi
  800bd4:	fc                   	cld    
  800bd5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd7:	eb 05                	jmp    800bde <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	fc                   	cld    
  800bdc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be8:	ff 75 10             	pushl  0x10(%ebp)
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 8a ff ff ff       	call   800b80 <memmove>
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	89 c6                	mov    %eax,%esi
  800c05:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c08:	39 f0                	cmp    %esi,%eax
  800c0a:	74 1c                	je     800c28 <memcmp+0x30>
		if (*s1 != *s2)
  800c0c:	0f b6 08             	movzbl (%eax),%ecx
  800c0f:	0f b6 1a             	movzbl (%edx),%ebx
  800c12:	38 d9                	cmp    %bl,%cl
  800c14:	75 08                	jne    800c1e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c16:	83 c0 01             	add    $0x1,%eax
  800c19:	83 c2 01             	add    $0x1,%edx
  800c1c:	eb ea                	jmp    800c08 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c1e:	0f b6 c1             	movzbl %cl,%eax
  800c21:	0f b6 db             	movzbl %bl,%ebx
  800c24:	29 d8                	sub    %ebx,%eax
  800c26:	eb 05                	jmp    800c2d <memcmp+0x35>
	}

	return 0;
  800c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c3a:	89 c2                	mov    %eax,%edx
  800c3c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c3f:	39 d0                	cmp    %edx,%eax
  800c41:	73 09                	jae    800c4c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c43:	38 08                	cmp    %cl,(%eax)
  800c45:	74 05                	je     800c4c <memfind+0x1b>
	for (; s < ends; s++)
  800c47:	83 c0 01             	add    $0x1,%eax
  800c4a:	eb f3                	jmp    800c3f <memfind+0xe>
			break;
	return (void *) s;
}
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5a:	eb 03                	jmp    800c5f <strtol+0x11>
		s++;
  800c5c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c5f:	0f b6 01             	movzbl (%ecx),%eax
  800c62:	3c 20                	cmp    $0x20,%al
  800c64:	74 f6                	je     800c5c <strtol+0xe>
  800c66:	3c 09                	cmp    $0x9,%al
  800c68:	74 f2                	je     800c5c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c6a:	3c 2b                	cmp    $0x2b,%al
  800c6c:	74 2a                	je     800c98 <strtol+0x4a>
	int neg = 0;
  800c6e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c73:	3c 2d                	cmp    $0x2d,%al
  800c75:	74 2b                	je     800ca2 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c77:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c7d:	75 0f                	jne    800c8e <strtol+0x40>
  800c7f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c82:	74 28                	je     800cac <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c84:	85 db                	test   %ebx,%ebx
  800c86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c8b:	0f 44 d8             	cmove  %eax,%ebx
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c93:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c96:	eb 50                	jmp    800ce8 <strtol+0x9a>
		s++;
  800c98:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c9b:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca0:	eb d5                	jmp    800c77 <strtol+0x29>
		s++, neg = 1;
  800ca2:	83 c1 01             	add    $0x1,%ecx
  800ca5:	bf 01 00 00 00       	mov    $0x1,%edi
  800caa:	eb cb                	jmp    800c77 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cac:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cb0:	74 0e                	je     800cc0 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cb2:	85 db                	test   %ebx,%ebx
  800cb4:	75 d8                	jne    800c8e <strtol+0x40>
		s++, base = 8;
  800cb6:	83 c1 01             	add    $0x1,%ecx
  800cb9:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cbe:	eb ce                	jmp    800c8e <strtol+0x40>
		s += 2, base = 16;
  800cc0:	83 c1 02             	add    $0x2,%ecx
  800cc3:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cc8:	eb c4                	jmp    800c8e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cca:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ccd:	89 f3                	mov    %esi,%ebx
  800ccf:	80 fb 19             	cmp    $0x19,%bl
  800cd2:	77 29                	ja     800cfd <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cd4:	0f be d2             	movsbl %dl,%edx
  800cd7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cda:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cdd:	7d 30                	jge    800d0f <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cdf:	83 c1 01             	add    $0x1,%ecx
  800ce2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ce6:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ce8:	0f b6 11             	movzbl (%ecx),%edx
  800ceb:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cee:	89 f3                	mov    %esi,%ebx
  800cf0:	80 fb 09             	cmp    $0x9,%bl
  800cf3:	77 d5                	ja     800cca <strtol+0x7c>
			dig = *s - '0';
  800cf5:	0f be d2             	movsbl %dl,%edx
  800cf8:	83 ea 30             	sub    $0x30,%edx
  800cfb:	eb dd                	jmp    800cda <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cfd:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d00:	89 f3                	mov    %esi,%ebx
  800d02:	80 fb 19             	cmp    $0x19,%bl
  800d05:	77 08                	ja     800d0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d07:	0f be d2             	movsbl %dl,%edx
  800d0a:	83 ea 37             	sub    $0x37,%edx
  800d0d:	eb cb                	jmp    800cda <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d13:	74 05                	je     800d1a <strtol+0xcc>
		*endptr = (char *) s;
  800d15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d18:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d1a:	89 c2                	mov    %eax,%edx
  800d1c:	f7 da                	neg    %edx
  800d1e:	85 ff                	test   %edi,%edi
  800d20:	0f 45 c2             	cmovne %edx,%eax
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
  800d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d39:	89 c3                	mov    %eax,%ebx
  800d3b:	89 c7                	mov    %eax,%edi
  800d3d:	89 c6                	mov    %eax,%esi
  800d3f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d51:	b8 01 00 00 00       	mov    $0x1,%eax
  800d56:	89 d1                	mov    %edx,%ecx
  800d58:	89 d3                	mov    %edx,%ebx
  800d5a:	89 d7                	mov    %edx,%edi
  800d5c:	89 d6                	mov    %edx,%esi
  800d5e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7b:	89 cb                	mov    %ecx,%ebx
  800d7d:	89 cf                	mov    %ecx,%edi
  800d7f:	89 ce                	mov    %ecx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 03                	push   $0x3
  800d95:	68 a0 1c 80 00       	push   $0x801ca0
  800d9a:	6a 43                	push   $0x43
  800d9c:	68 bd 1c 80 00       	push   $0x801cbd
  800da1:	e8 f7 f3 ff ff       	call   80019d <_panic>

00800da6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	b8 02 00 00 00       	mov    $0x2,%eax
  800db6:	89 d1                	mov    %edx,%ecx
  800db8:	89 d3                	mov    %edx,%ebx
  800dba:	89 d7                	mov    %edx,%edi
  800dbc:	89 d6                	mov    %edx,%esi
  800dbe:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_yield>:

void
sys_yield(void)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd5:	89 d1                	mov    %edx,%ecx
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	89 d7                	mov    %edx,%edi
  800ddb:	89 d6                	mov    %edx,%esi
  800ddd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
  800dea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ded:	be 00 00 00 00       	mov    $0x0,%esi
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 04 00 00 00       	mov    $0x4,%eax
  800dfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e00:	89 f7                	mov    %esi,%edi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 04                	push   $0x4
  800e16:	68 a0 1c 80 00       	push   $0x801ca0
  800e1b:	6a 43                	push   $0x43
  800e1d:	68 bd 1c 80 00       	push   $0x801cbd
  800e22:	e8 76 f3 ff ff       	call   80019d <_panic>

00800e27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 05 00 00 00       	mov    $0x5,%eax
  800e3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e41:	8b 75 18             	mov    0x18(%ebp),%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 05                	push   $0x5
  800e58:	68 a0 1c 80 00       	push   $0x801ca0
  800e5d:	6a 43                	push   $0x43
  800e5f:	68 bd 1c 80 00       	push   $0x801cbd
  800e64:	e8 34 f3 ff ff       	call   80019d <_panic>

00800e69 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e82:	89 df                	mov    %ebx,%edi
  800e84:	89 de                	mov    %ebx,%esi
  800e86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	7f 08                	jg     800e94 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	50                   	push   %eax
  800e98:	6a 06                	push   $0x6
  800e9a:	68 a0 1c 80 00       	push   $0x801ca0
  800e9f:	6a 43                	push   $0x43
  800ea1:	68 bd 1c 80 00       	push   $0x801cbd
  800ea6:	e8 f2 f2 ff ff       	call   80019d <_panic>

00800eab <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 08                	push   $0x8
  800edc:	68 a0 1c 80 00       	push   $0x801ca0
  800ee1:	6a 43                	push   $0x43
  800ee3:	68 bd 1c 80 00       	push   $0x801cbd
  800ee8:	e8 b0 f2 ff ff       	call   80019d <_panic>

00800eed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f01:	b8 09 00 00 00       	mov    $0x9,%eax
  800f06:	89 df                	mov    %ebx,%edi
  800f08:	89 de                	mov    %ebx,%esi
  800f0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	7f 08                	jg     800f18 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5f                   	pop    %edi
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	50                   	push   %eax
  800f1c:	6a 09                	push   $0x9
  800f1e:	68 a0 1c 80 00       	push   $0x801ca0
  800f23:	6a 43                	push   $0x43
  800f25:	68 bd 1c 80 00       	push   $0x801cbd
  800f2a:	e8 6e f2 ff ff       	call   80019d <_panic>

00800f2f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	57                   	push   %edi
  800f33:	56                   	push   %esi
  800f34:	53                   	push   %ebx
  800f35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f48:	89 df                	mov    %ebx,%edi
  800f4a:	89 de                	mov    %ebx,%esi
  800f4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4e:	85 c0                	test   %eax,%eax
  800f50:	7f 08                	jg     800f5a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5a:	83 ec 0c             	sub    $0xc,%esp
  800f5d:	50                   	push   %eax
  800f5e:	6a 0a                	push   $0xa
  800f60:	68 a0 1c 80 00       	push   $0x801ca0
  800f65:	6a 43                	push   $0x43
  800f67:	68 bd 1c 80 00       	push   $0x801cbd
  800f6c:	e8 2c f2 ff ff       	call   80019d <_panic>

00800f71 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	57                   	push   %edi
  800f75:	56                   	push   %esi
  800f76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f82:	be 00 00 00 00       	mov    $0x0,%esi
  800f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
  800f9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800faa:	89 cb                	mov    %ecx,%ebx
  800fac:	89 cf                	mov    %ecx,%edi
  800fae:	89 ce                	mov    %ecx,%esi
  800fb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	7f 08                	jg     800fbe <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbe:	83 ec 0c             	sub    $0xc,%esp
  800fc1:	50                   	push   %eax
  800fc2:	6a 0d                	push   $0xd
  800fc4:	68 a0 1c 80 00       	push   $0x801ca0
  800fc9:	6a 43                	push   $0x43
  800fcb:	68 bd 1c 80 00       	push   $0x801cbd
  800fd0:	e8 c8 f1 ff ff       	call   80019d <_panic>

00800fd5 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	57                   	push   %edi
  800fd9:	56                   	push   %esi
  800fda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800feb:	89 df                	mov    %ebx,%edi
  800fed:	89 de                	mov    %ebx,%esi
  800fef:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	b8 0f 00 00 00       	mov    $0xf,%eax
  801009:	89 cb                	mov    %ecx,%ebx
  80100b:	89 cf                	mov    %ecx,%edi
  80100d:	89 ce                	mov    %ecx,%esi
  80100f:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	53                   	push   %ebx
  80101a:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80101d:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801024:	83 e1 07             	and    $0x7,%ecx
  801027:	83 f9 07             	cmp    $0x7,%ecx
  80102a:	74 32                	je     80105e <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80102c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801033:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801039:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  80103f:	74 7d                	je     8010be <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801041:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801048:	83 e1 05             	and    $0x5,%ecx
  80104b:	83 f9 05             	cmp    $0x5,%ecx
  80104e:	0f 84 9e 00 00 00    	je     8010f2 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
  801059:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80105e:	89 d3                	mov    %edx,%ebx
  801060:	c1 e3 0c             	shl    $0xc,%ebx
  801063:	83 ec 0c             	sub    $0xc,%esp
  801066:	68 05 08 00 00       	push   $0x805
  80106b:	53                   	push   %ebx
  80106c:	50                   	push   %eax
  80106d:	53                   	push   %ebx
  80106e:	6a 00                	push   $0x0
  801070:	e8 b2 fd ff ff       	call   800e27 <sys_page_map>
		if(r < 0)
  801075:	83 c4 20             	add    $0x20,%esp
  801078:	85 c0                	test   %eax,%eax
  80107a:	78 2e                	js     8010aa <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80107c:	83 ec 0c             	sub    $0xc,%esp
  80107f:	68 05 08 00 00       	push   $0x805
  801084:	53                   	push   %ebx
  801085:	6a 00                	push   $0x0
  801087:	53                   	push   %ebx
  801088:	6a 00                	push   $0x0
  80108a:	e8 98 fd ff ff       	call   800e27 <sys_page_map>
		if(r < 0)
  80108f:	83 c4 20             	add    $0x20,%esp
  801092:	85 c0                	test   %eax,%eax
  801094:	79 be                	jns    801054 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801096:	83 ec 04             	sub    $0x4,%esp
  801099:	68 cb 1c 80 00       	push   $0x801ccb
  80109e:	6a 57                	push   $0x57
  8010a0:	68 e1 1c 80 00       	push   $0x801ce1
  8010a5:	e8 f3 f0 ff ff       	call   80019d <_panic>
			panic("sys_page_map() panic\n");
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	68 cb 1c 80 00       	push   $0x801ccb
  8010b2:	6a 53                	push   $0x53
  8010b4:	68 e1 1c 80 00       	push   $0x801ce1
  8010b9:	e8 df f0 ff ff       	call   80019d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010be:	c1 e2 0c             	shl    $0xc,%edx
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	68 05 08 00 00       	push   $0x805
  8010c9:	52                   	push   %edx
  8010ca:	50                   	push   %eax
  8010cb:	52                   	push   %edx
  8010cc:	6a 00                	push   $0x0
  8010ce:	e8 54 fd ff ff       	call   800e27 <sys_page_map>
		if(r < 0)
  8010d3:	83 c4 20             	add    $0x20,%esp
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	0f 89 76 ff ff ff    	jns    801054 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	68 cb 1c 80 00       	push   $0x801ccb
  8010e6:	6a 5e                	push   $0x5e
  8010e8:	68 e1 1c 80 00       	push   $0x801ce1
  8010ed:	e8 ab f0 ff ff       	call   80019d <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010f2:	c1 e2 0c             	shl    $0xc,%edx
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	6a 05                	push   $0x5
  8010fa:	52                   	push   %edx
  8010fb:	50                   	push   %eax
  8010fc:	52                   	push   %edx
  8010fd:	6a 00                	push   $0x0
  8010ff:	e8 23 fd ff ff       	call   800e27 <sys_page_map>
		if(r < 0)
  801104:	83 c4 20             	add    $0x20,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	0f 89 45 ff ff ff    	jns    801054 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80110f:	83 ec 04             	sub    $0x4,%esp
  801112:	68 cb 1c 80 00       	push   $0x801ccb
  801117:	6a 65                	push   $0x65
  801119:	68 e1 1c 80 00       	push   $0x801ce1
  80111e:	e8 7a f0 ff ff       	call   80019d <_panic>

00801123 <pgfault>:
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
  801126:	53                   	push   %ebx
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80112d:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80112f:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801133:	0f 84 99 00 00 00    	je     8011d2 <pgfault+0xaf>
  801139:	89 c2                	mov    %eax,%edx
  80113b:	c1 ea 16             	shr    $0x16,%edx
  80113e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801145:	f6 c2 01             	test   $0x1,%dl
  801148:	0f 84 84 00 00 00    	je     8011d2 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80114e:	89 c2                	mov    %eax,%edx
  801150:	c1 ea 0c             	shr    $0xc,%edx
  801153:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80115a:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801160:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801166:	75 6a                	jne    8011d2 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801168:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80116d:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	6a 07                	push   $0x7
  801174:	68 00 f0 7f 00       	push   $0x7ff000
  801179:	6a 00                	push   $0x0
  80117b:	e8 64 fc ff ff       	call   800de4 <sys_page_alloc>
	if(ret < 0)
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 5f                	js     8011e6 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 00 10 00 00       	push   $0x1000
  80118f:	53                   	push   %ebx
  801190:	68 00 f0 7f 00       	push   $0x7ff000
  801195:	e8 48 fa ff ff       	call   800be2 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80119a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011a1:	53                   	push   %ebx
  8011a2:	6a 00                	push   $0x0
  8011a4:	68 00 f0 7f 00       	push   $0x7ff000
  8011a9:	6a 00                	push   $0x0
  8011ab:	e8 77 fc ff ff       	call   800e27 <sys_page_map>
	if(ret < 0)
  8011b0:	83 c4 20             	add    $0x20,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 43                	js     8011fa <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	68 00 f0 7f 00       	push   $0x7ff000
  8011bf:	6a 00                	push   $0x0
  8011c1:	e8 a3 fc ff ff       	call   800e69 <sys_page_unmap>
	if(ret < 0)
  8011c6:	83 c4 10             	add    $0x10,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	78 41                	js     80120e <pgfault+0xeb>
}
  8011cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    
		panic("panic at pgfault()\n");
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	68 ec 1c 80 00       	push   $0x801cec
  8011da:	6a 26                	push   $0x26
  8011dc:	68 e1 1c 80 00       	push   $0x801ce1
  8011e1:	e8 b7 ef ff ff       	call   80019d <_panic>
		panic("panic in sys_page_alloc()\n");
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	68 00 1d 80 00       	push   $0x801d00
  8011ee:	6a 31                	push   $0x31
  8011f0:	68 e1 1c 80 00       	push   $0x801ce1
  8011f5:	e8 a3 ef ff ff       	call   80019d <_panic>
		panic("panic in sys_page_map()\n");
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	68 1b 1d 80 00       	push   $0x801d1b
  801202:	6a 36                	push   $0x36
  801204:	68 e1 1c 80 00       	push   $0x801ce1
  801209:	e8 8f ef ff ff       	call   80019d <_panic>
		panic("panic in sys_page_unmap()\n");
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	68 34 1d 80 00       	push   $0x801d34
  801216:	6a 39                	push   $0x39
  801218:	68 e1 1c 80 00       	push   $0x801ce1
  80121d:	e8 7b ef ff ff       	call   80019d <_panic>

00801222 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  80122b:	68 23 11 80 00       	push   $0x801123
  801230:	e8 95 03 00 00       	call   8015ca <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801235:	b8 07 00 00 00       	mov    $0x7,%eax
  80123a:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80123c:	83 c4 10             	add    $0x10,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	78 27                	js     80126a <fork+0x48>
  801243:	89 c6                	mov    %eax,%esi
  801245:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801247:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80124c:	75 48                	jne    801296 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80124e:	e8 53 fb ff ff       	call   800da6 <sys_getenvid>
  801253:	25 ff 03 00 00       	and    $0x3ff,%eax
  801258:	c1 e0 07             	shl    $0x7,%eax
  80125b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801260:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  801265:	e9 90 00 00 00       	jmp    8012fa <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	68 50 1d 80 00       	push   $0x801d50
  801272:	68 85 00 00 00       	push   $0x85
  801277:	68 e1 1c 80 00       	push   $0x801ce1
  80127c:	e8 1c ef ff ff       	call   80019d <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801281:	89 f8                	mov    %edi,%eax
  801283:	e8 8e fd ff ff       	call   801016 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801288:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80128e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801294:	74 26                	je     8012bc <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801296:	89 d8                	mov    %ebx,%eax
  801298:	c1 e8 16             	shr    $0x16,%eax
  80129b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012a2:	a8 01                	test   $0x1,%al
  8012a4:	74 e2                	je     801288 <fork+0x66>
  8012a6:	89 da                	mov    %ebx,%edx
  8012a8:	c1 ea 0c             	shr    $0xc,%edx
  8012ab:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012b2:	83 e0 05             	and    $0x5,%eax
  8012b5:	83 f8 05             	cmp    $0x5,%eax
  8012b8:	75 ce                	jne    801288 <fork+0x66>
  8012ba:	eb c5                	jmp    801281 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	6a 07                	push   $0x7
  8012c1:	68 00 f0 bf ee       	push   $0xeebff000
  8012c6:	56                   	push   %esi
  8012c7:	e8 18 fb ff ff       	call   800de4 <sys_page_alloc>
	if(ret < 0)
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 31                	js     801304 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8012d3:	83 ec 08             	sub    $0x8,%esp
  8012d6:	68 39 16 80 00       	push   $0x801639
  8012db:	56                   	push   %esi
  8012dc:	e8 4e fc ff ff       	call   800f2f <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 33                	js     80131b <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	6a 02                	push   $0x2
  8012ed:	56                   	push   %esi
  8012ee:	e8 b8 fb ff ff       	call   800eab <sys_env_set_status>
	if(ret < 0)
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	78 38                	js     801332 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8012fa:	89 f0                	mov    %esi,%eax
  8012fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	68 00 1d 80 00       	push   $0x801d00
  80130c:	68 91 00 00 00       	push   $0x91
  801311:	68 e1 1c 80 00       	push   $0x801ce1
  801316:	e8 82 ee ff ff       	call   80019d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	68 74 1d 80 00       	push   $0x801d74
  801323:	68 94 00 00 00       	push   $0x94
  801328:	68 e1 1c 80 00       	push   $0x801ce1
  80132d:	e8 6b ee ff ff       	call   80019d <_panic>
		panic("panic in sys_env_set_status()\n");
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	68 9c 1d 80 00       	push   $0x801d9c
  80133a:	68 97 00 00 00       	push   $0x97
  80133f:	68 e1 1c 80 00       	push   $0x801ce1
  801344:	e8 54 ee ff ff       	call   80019d <_panic>

00801349 <sfork>:

// Challenge!
int
sfork(void)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801352:	a1 04 20 80 00       	mov    0x802004,%eax
  801357:	8b 40 48             	mov    0x48(%eax),%eax
  80135a:	68 bc 1d 80 00       	push   $0x801dbc
  80135f:	50                   	push   %eax
  801360:	68 ed 18 80 00       	push   $0x8018ed
  801365:	e8 29 ef ff ff       	call   800293 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80136a:	c7 04 24 23 11 80 00 	movl   $0x801123,(%esp)
  801371:	e8 54 02 00 00       	call   8015ca <set_pgfault_handler>
  801376:	b8 07 00 00 00       	mov    $0x7,%eax
  80137b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 27                	js     8013ab <sfork+0x62>
  801384:	89 c7                	mov    %eax,%edi
  801386:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801388:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80138d:	75 55                	jne    8013e4 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80138f:	e8 12 fa ff ff       	call   800da6 <sys_getenvid>
  801394:	25 ff 03 00 00       	and    $0x3ff,%eax
  801399:	c1 e0 07             	shl    $0x7,%eax
  80139c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013a1:	a3 04 20 80 00       	mov    %eax,0x802004
		return 0;
  8013a6:	e9 d4 00 00 00       	jmp    80147f <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	68 50 1d 80 00       	push   $0x801d50
  8013b3:	68 a9 00 00 00       	push   $0xa9
  8013b8:	68 e1 1c 80 00       	push   $0x801ce1
  8013bd:	e8 db ed ff ff       	call   80019d <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8013c2:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013c7:	89 f0                	mov    %esi,%eax
  8013c9:	e8 48 fc ff ff       	call   801016 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013ce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013d4:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8013da:	77 65                	ja     801441 <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8013dc:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8013e2:	74 de                	je     8013c2 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8013e4:	89 d8                	mov    %ebx,%eax
  8013e6:	c1 e8 16             	shr    $0x16,%eax
  8013e9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f0:	a8 01                	test   $0x1,%al
  8013f2:	74 da                	je     8013ce <sfork+0x85>
  8013f4:	89 da                	mov    %ebx,%edx
  8013f6:	c1 ea 0c             	shr    $0xc,%edx
  8013f9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801400:	83 e0 05             	and    $0x5,%eax
  801403:	83 f8 05             	cmp    $0x5,%eax
  801406:	75 c6                	jne    8013ce <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801408:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80140f:	c1 e2 0c             	shl    $0xc,%edx
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	83 e0 07             	and    $0x7,%eax
  801418:	50                   	push   %eax
  801419:	52                   	push   %edx
  80141a:	56                   	push   %esi
  80141b:	52                   	push   %edx
  80141c:	6a 00                	push   $0x0
  80141e:	e8 04 fa ff ff       	call   800e27 <sys_page_map>
  801423:	83 c4 20             	add    $0x20,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	74 a4                	je     8013ce <sfork+0x85>
				panic("sys_page_map() panic\n");
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	68 cb 1c 80 00       	push   $0x801ccb
  801432:	68 b4 00 00 00       	push   $0xb4
  801437:	68 e1 1c 80 00       	push   $0x801ce1
  80143c:	e8 5c ed ff ff       	call   80019d <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	6a 07                	push   $0x7
  801446:	68 00 f0 bf ee       	push   $0xeebff000
  80144b:	57                   	push   %edi
  80144c:	e8 93 f9 ff ff       	call   800de4 <sys_page_alloc>
	if(ret < 0)
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 31                	js     801489 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801458:	83 ec 08             	sub    $0x8,%esp
  80145b:	68 39 16 80 00       	push   $0x801639
  801460:	57                   	push   %edi
  801461:	e8 c9 fa ff ff       	call   800f2f <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 33                	js     8014a0 <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	6a 02                	push   $0x2
  801472:	57                   	push   %edi
  801473:	e8 33 fa ff ff       	call   800eab <sys_env_set_status>
	if(ret < 0)
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 38                	js     8014b7 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80147f:	89 f8                	mov    %edi,%eax
  801481:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801484:	5b                   	pop    %ebx
  801485:	5e                   	pop    %esi
  801486:	5f                   	pop    %edi
  801487:	5d                   	pop    %ebp
  801488:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 00 1d 80 00       	push   $0x801d00
  801491:	68 ba 00 00 00       	push   $0xba
  801496:	68 e1 1c 80 00       	push   $0x801ce1
  80149b:	e8 fd ec ff ff       	call   80019d <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	68 74 1d 80 00       	push   $0x801d74
  8014a8:	68 bd 00 00 00       	push   $0xbd
  8014ad:	68 e1 1c 80 00       	push   $0x801ce1
  8014b2:	e8 e6 ec ff ff       	call   80019d <_panic>
		panic("panic in sys_env_set_status()\n");
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 9c 1d 80 00       	push   $0x801d9c
  8014bf:	68 c0 00 00 00       	push   $0xc0
  8014c4:	68 e1 1c 80 00       	push   $0x801ce1
  8014c9:	e8 cf ec ff ff       	call   80019d <_panic>

008014ce <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	56                   	push   %esi
  8014d2:	53                   	push   %ebx
  8014d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8014dc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8014de:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8014e3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	50                   	push   %eax
  8014ea:	e8 a5 fa ff ff       	call   800f94 <sys_ipc_recv>
	if(ret < 0){
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 2b                	js     801521 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8014f6:	85 f6                	test   %esi,%esi
  8014f8:	74 0a                	je     801504 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8014fa:	a1 04 20 80 00       	mov    0x802004,%eax
  8014ff:	8b 40 74             	mov    0x74(%eax),%eax
  801502:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801504:	85 db                	test   %ebx,%ebx
  801506:	74 0a                	je     801512 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801508:	a1 04 20 80 00       	mov    0x802004,%eax
  80150d:	8b 40 78             	mov    0x78(%eax),%eax
  801510:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801512:	a1 04 20 80 00       	mov    0x802004,%eax
  801517:	8b 40 70             	mov    0x70(%eax),%eax
}
  80151a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151d:	5b                   	pop    %ebx
  80151e:	5e                   	pop    %esi
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    
		if(from_env_store)
  801521:	85 f6                	test   %esi,%esi
  801523:	74 06                	je     80152b <ipc_recv+0x5d>
			*from_env_store = 0;
  801525:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80152b:	85 db                	test   %ebx,%ebx
  80152d:	74 eb                	je     80151a <ipc_recv+0x4c>
			*perm_store = 0;
  80152f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801535:	eb e3                	jmp    80151a <ipc_recv+0x4c>

00801537 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	57                   	push   %edi
  80153b:	56                   	push   %esi
  80153c:	53                   	push   %ebx
  80153d:	83 ec 0c             	sub    $0xc,%esp
  801540:	8b 7d 08             	mov    0x8(%ebp),%edi
  801543:	8b 75 0c             	mov    0xc(%ebp),%esi
  801546:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801549:	85 db                	test   %ebx,%ebx
  80154b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801550:	0f 44 d8             	cmove  %eax,%ebx
  801553:	eb 05                	jmp    80155a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801555:	e8 6b f8 ff ff       	call   800dc5 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80155a:	ff 75 14             	pushl  0x14(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	56                   	push   %esi
  80155f:	57                   	push   %edi
  801560:	e8 0c fa ff ff       	call   800f71 <sys_ipc_try_send>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	74 1b                	je     801587 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80156c:	79 e7                	jns    801555 <ipc_send+0x1e>
  80156e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801571:	74 e2                	je     801555 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 c2 1d 80 00       	push   $0x801dc2
  80157b:	6a 49                	push   $0x49
  80157d:	68 d7 1d 80 00       	push   $0x801dd7
  801582:	e8 16 ec ff ff       	call   80019d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801587:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80158a:	5b                   	pop    %ebx
  80158b:	5e                   	pop    %esi
  80158c:	5f                   	pop    %edi
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    

0080158f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80159a:	89 c2                	mov    %eax,%edx
  80159c:	c1 e2 07             	shl    $0x7,%edx
  80159f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8015a5:	8b 52 50             	mov    0x50(%edx),%edx
  8015a8:	39 ca                	cmp    %ecx,%edx
  8015aa:	74 11                	je     8015bd <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8015ac:	83 c0 01             	add    $0x1,%eax
  8015af:	3d 00 04 00 00       	cmp    $0x400,%eax
  8015b4:	75 e4                	jne    80159a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	eb 0b                	jmp    8015c8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8015bd:	c1 e0 07             	shl    $0x7,%eax
  8015c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015c5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8015d0:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8015d7:	74 0a                	je     8015e3 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	a3 08 20 80 00       	mov    %eax,0x802008
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	6a 07                	push   $0x7
  8015e8:	68 00 f0 bf ee       	push   $0xeebff000
  8015ed:	6a 00                	push   $0x0
  8015ef:	e8 f0 f7 ff ff       	call   800de4 <sys_page_alloc>
		if(r < 0)
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	85 c0                	test   %eax,%eax
  8015f9:	78 2a                	js     801625 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	68 39 16 80 00       	push   $0x801639
  801603:	6a 00                	push   $0x0
  801605:	e8 25 f9 ff ff       	call   800f2f <sys_env_set_pgfault_upcall>
		if(r < 0)
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	79 c8                	jns    8015d9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 14 1e 80 00       	push   $0x801e14
  801619:	6a 25                	push   $0x25
  80161b:	68 50 1e 80 00       	push   $0x801e50
  801620:	e8 78 eb ff ff       	call   80019d <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 e4 1d 80 00       	push   $0x801de4
  80162d:	6a 22                	push   $0x22
  80162f:	68 50 1e 80 00       	push   $0x801e50
  801634:	e8 64 eb ff ff       	call   80019d <_panic>

00801639 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801639:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80163a:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80163f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801641:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801644:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801648:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80164c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80164f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801651:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801655:	83 c4 08             	add    $0x8,%esp
	popal
  801658:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801659:	83 c4 04             	add    $0x4,%esp
	popfl
  80165c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80165d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80165e:	c3                   	ret    
  80165f:	90                   	nop

00801660 <__udivdi3>:
  801660:	55                   	push   %ebp
  801661:	57                   	push   %edi
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 1c             	sub    $0x1c,%esp
  801667:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80166b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80166f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801673:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801677:	85 d2                	test   %edx,%edx
  801679:	75 4d                	jne    8016c8 <__udivdi3+0x68>
  80167b:	39 f3                	cmp    %esi,%ebx
  80167d:	76 19                	jbe    801698 <__udivdi3+0x38>
  80167f:	31 ff                	xor    %edi,%edi
  801681:	89 e8                	mov    %ebp,%eax
  801683:	89 f2                	mov    %esi,%edx
  801685:	f7 f3                	div    %ebx
  801687:	89 fa                	mov    %edi,%edx
  801689:	83 c4 1c             	add    $0x1c,%esp
  80168c:	5b                   	pop    %ebx
  80168d:	5e                   	pop    %esi
  80168e:	5f                   	pop    %edi
  80168f:	5d                   	pop    %ebp
  801690:	c3                   	ret    
  801691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801698:	89 d9                	mov    %ebx,%ecx
  80169a:	85 db                	test   %ebx,%ebx
  80169c:	75 0b                	jne    8016a9 <__udivdi3+0x49>
  80169e:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a3:	31 d2                	xor    %edx,%edx
  8016a5:	f7 f3                	div    %ebx
  8016a7:	89 c1                	mov    %eax,%ecx
  8016a9:	31 d2                	xor    %edx,%edx
  8016ab:	89 f0                	mov    %esi,%eax
  8016ad:	f7 f1                	div    %ecx
  8016af:	89 c6                	mov    %eax,%esi
  8016b1:	89 e8                	mov    %ebp,%eax
  8016b3:	89 f7                	mov    %esi,%edi
  8016b5:	f7 f1                	div    %ecx
  8016b7:	89 fa                	mov    %edi,%edx
  8016b9:	83 c4 1c             	add    $0x1c,%esp
  8016bc:	5b                   	pop    %ebx
  8016bd:	5e                   	pop    %esi
  8016be:	5f                   	pop    %edi
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    
  8016c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016c8:	39 f2                	cmp    %esi,%edx
  8016ca:	77 1c                	ja     8016e8 <__udivdi3+0x88>
  8016cc:	0f bd fa             	bsr    %edx,%edi
  8016cf:	83 f7 1f             	xor    $0x1f,%edi
  8016d2:	75 2c                	jne    801700 <__udivdi3+0xa0>
  8016d4:	39 f2                	cmp    %esi,%edx
  8016d6:	72 06                	jb     8016de <__udivdi3+0x7e>
  8016d8:	31 c0                	xor    %eax,%eax
  8016da:	39 eb                	cmp    %ebp,%ebx
  8016dc:	77 a9                	ja     801687 <__udivdi3+0x27>
  8016de:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e3:	eb a2                	jmp    801687 <__udivdi3+0x27>
  8016e5:	8d 76 00             	lea    0x0(%esi),%esi
  8016e8:	31 ff                	xor    %edi,%edi
  8016ea:	31 c0                	xor    %eax,%eax
  8016ec:	89 fa                	mov    %edi,%edx
  8016ee:	83 c4 1c             	add    $0x1c,%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5f                   	pop    %edi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    
  8016f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8016fd:	8d 76 00             	lea    0x0(%esi),%esi
  801700:	89 f9                	mov    %edi,%ecx
  801702:	b8 20 00 00 00       	mov    $0x20,%eax
  801707:	29 f8                	sub    %edi,%eax
  801709:	d3 e2                	shl    %cl,%edx
  80170b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80170f:	89 c1                	mov    %eax,%ecx
  801711:	89 da                	mov    %ebx,%edx
  801713:	d3 ea                	shr    %cl,%edx
  801715:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801719:	09 d1                	or     %edx,%ecx
  80171b:	89 f2                	mov    %esi,%edx
  80171d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801721:	89 f9                	mov    %edi,%ecx
  801723:	d3 e3                	shl    %cl,%ebx
  801725:	89 c1                	mov    %eax,%ecx
  801727:	d3 ea                	shr    %cl,%edx
  801729:	89 f9                	mov    %edi,%ecx
  80172b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80172f:	89 eb                	mov    %ebp,%ebx
  801731:	d3 e6                	shl    %cl,%esi
  801733:	89 c1                	mov    %eax,%ecx
  801735:	d3 eb                	shr    %cl,%ebx
  801737:	09 de                	or     %ebx,%esi
  801739:	89 f0                	mov    %esi,%eax
  80173b:	f7 74 24 08          	divl   0x8(%esp)
  80173f:	89 d6                	mov    %edx,%esi
  801741:	89 c3                	mov    %eax,%ebx
  801743:	f7 64 24 0c          	mull   0xc(%esp)
  801747:	39 d6                	cmp    %edx,%esi
  801749:	72 15                	jb     801760 <__udivdi3+0x100>
  80174b:	89 f9                	mov    %edi,%ecx
  80174d:	d3 e5                	shl    %cl,%ebp
  80174f:	39 c5                	cmp    %eax,%ebp
  801751:	73 04                	jae    801757 <__udivdi3+0xf7>
  801753:	39 d6                	cmp    %edx,%esi
  801755:	74 09                	je     801760 <__udivdi3+0x100>
  801757:	89 d8                	mov    %ebx,%eax
  801759:	31 ff                	xor    %edi,%edi
  80175b:	e9 27 ff ff ff       	jmp    801687 <__udivdi3+0x27>
  801760:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801763:	31 ff                	xor    %edi,%edi
  801765:	e9 1d ff ff ff       	jmp    801687 <__udivdi3+0x27>
  80176a:	66 90                	xchg   %ax,%ax
  80176c:	66 90                	xchg   %ax,%ax
  80176e:	66 90                	xchg   %ax,%ax

00801770 <__umoddi3>:
  801770:	55                   	push   %ebp
  801771:	57                   	push   %edi
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
  801774:	83 ec 1c             	sub    $0x1c,%esp
  801777:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80177b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80177f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801783:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801787:	89 da                	mov    %ebx,%edx
  801789:	85 c0                	test   %eax,%eax
  80178b:	75 43                	jne    8017d0 <__umoddi3+0x60>
  80178d:	39 df                	cmp    %ebx,%edi
  80178f:	76 17                	jbe    8017a8 <__umoddi3+0x38>
  801791:	89 f0                	mov    %esi,%eax
  801793:	f7 f7                	div    %edi
  801795:	89 d0                	mov    %edx,%eax
  801797:	31 d2                	xor    %edx,%edx
  801799:	83 c4 1c             	add    $0x1c,%esp
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5f                   	pop    %edi
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    
  8017a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8017a8:	89 fd                	mov    %edi,%ebp
  8017aa:	85 ff                	test   %edi,%edi
  8017ac:	75 0b                	jne    8017b9 <__umoddi3+0x49>
  8017ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b3:	31 d2                	xor    %edx,%edx
  8017b5:	f7 f7                	div    %edi
  8017b7:	89 c5                	mov    %eax,%ebp
  8017b9:	89 d8                	mov    %ebx,%eax
  8017bb:	31 d2                	xor    %edx,%edx
  8017bd:	f7 f5                	div    %ebp
  8017bf:	89 f0                	mov    %esi,%eax
  8017c1:	f7 f5                	div    %ebp
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	eb d0                	jmp    801797 <__umoddi3+0x27>
  8017c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8017ce:	66 90                	xchg   %ax,%ax
  8017d0:	89 f1                	mov    %esi,%ecx
  8017d2:	39 d8                	cmp    %ebx,%eax
  8017d4:	76 0a                	jbe    8017e0 <__umoddi3+0x70>
  8017d6:	89 f0                	mov    %esi,%eax
  8017d8:	83 c4 1c             	add    $0x1c,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
  8017e0:	0f bd e8             	bsr    %eax,%ebp
  8017e3:	83 f5 1f             	xor    $0x1f,%ebp
  8017e6:	75 20                	jne    801808 <__umoddi3+0x98>
  8017e8:	39 d8                	cmp    %ebx,%eax
  8017ea:	0f 82 b0 00 00 00    	jb     8018a0 <__umoddi3+0x130>
  8017f0:	39 f7                	cmp    %esi,%edi
  8017f2:	0f 86 a8 00 00 00    	jbe    8018a0 <__umoddi3+0x130>
  8017f8:	89 c8                	mov    %ecx,%eax
  8017fa:	83 c4 1c             	add    $0x1c,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5f                   	pop    %edi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    
  801802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801808:	89 e9                	mov    %ebp,%ecx
  80180a:	ba 20 00 00 00       	mov    $0x20,%edx
  80180f:	29 ea                	sub    %ebp,%edx
  801811:	d3 e0                	shl    %cl,%eax
  801813:	89 44 24 08          	mov    %eax,0x8(%esp)
  801817:	89 d1                	mov    %edx,%ecx
  801819:	89 f8                	mov    %edi,%eax
  80181b:	d3 e8                	shr    %cl,%eax
  80181d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801821:	89 54 24 04          	mov    %edx,0x4(%esp)
  801825:	8b 54 24 04          	mov    0x4(%esp),%edx
  801829:	09 c1                	or     %eax,%ecx
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801831:	89 e9                	mov    %ebp,%ecx
  801833:	d3 e7                	shl    %cl,%edi
  801835:	89 d1                	mov    %edx,%ecx
  801837:	d3 e8                	shr    %cl,%eax
  801839:	89 e9                	mov    %ebp,%ecx
  80183b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80183f:	d3 e3                	shl    %cl,%ebx
  801841:	89 c7                	mov    %eax,%edi
  801843:	89 d1                	mov    %edx,%ecx
  801845:	89 f0                	mov    %esi,%eax
  801847:	d3 e8                	shr    %cl,%eax
  801849:	89 e9                	mov    %ebp,%ecx
  80184b:	89 fa                	mov    %edi,%edx
  80184d:	d3 e6                	shl    %cl,%esi
  80184f:	09 d8                	or     %ebx,%eax
  801851:	f7 74 24 08          	divl   0x8(%esp)
  801855:	89 d1                	mov    %edx,%ecx
  801857:	89 f3                	mov    %esi,%ebx
  801859:	f7 64 24 0c          	mull   0xc(%esp)
  80185d:	89 c6                	mov    %eax,%esi
  80185f:	89 d7                	mov    %edx,%edi
  801861:	39 d1                	cmp    %edx,%ecx
  801863:	72 06                	jb     80186b <__umoddi3+0xfb>
  801865:	75 10                	jne    801877 <__umoddi3+0x107>
  801867:	39 c3                	cmp    %eax,%ebx
  801869:	73 0c                	jae    801877 <__umoddi3+0x107>
  80186b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80186f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801873:	89 d7                	mov    %edx,%edi
  801875:	89 c6                	mov    %eax,%esi
  801877:	89 ca                	mov    %ecx,%edx
  801879:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80187e:	29 f3                	sub    %esi,%ebx
  801880:	19 fa                	sbb    %edi,%edx
  801882:	89 d0                	mov    %edx,%eax
  801884:	d3 e0                	shl    %cl,%eax
  801886:	89 e9                	mov    %ebp,%ecx
  801888:	d3 eb                	shr    %cl,%ebx
  80188a:	d3 ea                	shr    %cl,%edx
  80188c:	09 d8                	or     %ebx,%eax
  80188e:	83 c4 1c             	add    $0x1c,%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5f                   	pop    %edi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    
  801896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80189d:	8d 76 00             	lea    0x0(%esi),%esi
  8018a0:	89 da                	mov    %ebx,%edx
  8018a2:	29 fe                	sub    %edi,%esi
  8018a4:	19 c2                	sbb    %eax,%edx
  8018a6:	89 f1                	mov    %esi,%ecx
  8018a8:	89 c8                	mov    %ecx,%eax
  8018aa:	e9 4b ff ff ff       	jmp    8017fa <__umoddi3+0x8a>
