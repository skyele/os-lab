
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
  800047:	e8 69 15 00 00       	call   8015b5 <ipc_recv>
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
  800065:	e8 b9 12 00 00       	call   801323 <fork>
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
  800092:	e8 87 15 00 00       	call   80161e <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 0e 15 00 00       	call   8015b5 <ipc_recv>
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
  8000ba:	e8 64 12 00 00       	call   801323 <fork>
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
  8000d2:	e8 47 15 00 00       	call   80161e <ipc_send>
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

	cprintf("in libmain.c call umain!\n");
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
  80019e:	e8 e6 16 00 00       	call   801889 <close_all>
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
  8001c2:	68 b8 2b 80 00       	push   $0x802bb8
  8001c7:	50                   	push   %eax
  8001c8:	68 87 2b 80 00       	push   $0x802b87
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
  8001eb:	68 94 2b 80 00       	push   $0x802b94
  8001f0:	e8 b3 00 00 00       	call   8002a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f5:	83 c4 18             	add    $0x18,%esp
  8001f8:	53                   	push   %ebx
  8001f9:	ff 75 10             	pushl  0x10(%ebp)
  8001fc:	e8 56 00 00 00       	call   800257 <vcprintf>
	cprintf("\n");
  800201:	c7 04 24 7b 2b 80 00 	movl   $0x802b7b,(%esp)
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
  800355:	e8 86 25 00 00       	call   8028e0 <__udivdi3>
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
  80037e:	e8 6d 26 00 00       	call   8029f0 <__umoddi3>
  800383:	83 c4 14             	add    $0x14,%esp
  800386:	0f be 80 bf 2b 80 00 	movsbl 0x802bbf(%eax),%eax
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
  800506:	68 29 31 80 00       	push   $0x803129
  80050b:	53                   	push   %ebx
  80050c:	56                   	push   %esi
  80050d:	e8 a6 fe ff ff       	call   8003b8 <printfmt>
  800512:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800515:	89 7d 14             	mov    %edi,0x14(%ebp)
  800518:	e9 fe 02 00 00       	jmp    80081b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80051d:	50                   	push   %eax
  80051e:	68 d7 2b 80 00       	push   $0x802bd7
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
  800545:	b8 d0 2b 80 00       	mov    $0x802bd0,%eax
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
  8008dd:	bf f5 2c 80 00       	mov    $0x802cf5,%edi
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
  800909:	bf 2d 2d 80 00       	mov    $0x802d2d,%edi
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

008010ce <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	53                   	push   %ebx
  8010d2:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010d5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010dc:	f6 c5 04             	test   $0x4,%ch
  8010df:	75 45                	jne    801126 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010e1:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e8:	83 e1 07             	and    $0x7,%ecx
  8010eb:	83 f9 07             	cmp    $0x7,%ecx
  8010ee:	74 6f                	je     80115f <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010f0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010f7:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010fd:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801103:	0f 84 b6 00 00 00    	je     8011bf <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801109:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801110:	83 e1 05             	and    $0x5,%ecx
  801113:	83 f9 05             	cmp    $0x5,%ecx
  801116:	0f 84 d7 00 00 00    	je     8011f3 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80111c:	b8 00 00 00 00       	mov    $0x0,%eax
  801121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801124:	c9                   	leave  
  801125:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801126:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80112d:	c1 e2 0c             	shl    $0xc,%edx
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801139:	51                   	push   %ecx
  80113a:	52                   	push   %edx
  80113b:	50                   	push   %eax
  80113c:	52                   	push   %edx
  80113d:	6a 00                	push   $0x0
  80113f:	e8 f8 fc ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801144:	83 c4 20             	add    $0x20,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	79 d1                	jns    80111c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114b:	83 ec 04             	sub    $0x4,%esp
  80114e:	68 6f 2f 80 00       	push   $0x802f6f
  801153:	6a 54                	push   $0x54
  801155:	68 85 2f 80 00       	push   $0x802f85
  80115a:	e8 53 f0 ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115f:	89 d3                	mov    %edx,%ebx
  801161:	c1 e3 0c             	shl    $0xc,%ebx
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	68 05 08 00 00       	push   $0x805
  80116c:	53                   	push   %ebx
  80116d:	50                   	push   %eax
  80116e:	53                   	push   %ebx
  80116f:	6a 00                	push   $0x0
  801171:	e8 c6 fc ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801176:	83 c4 20             	add    $0x20,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	78 2e                	js     8011ab <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	68 05 08 00 00       	push   $0x805
  801185:	53                   	push   %ebx
  801186:	6a 00                	push   $0x0
  801188:	53                   	push   %ebx
  801189:	6a 00                	push   $0x0
  80118b:	e8 ac fc ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801190:	83 c4 20             	add    $0x20,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	79 85                	jns    80111c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801197:	83 ec 04             	sub    $0x4,%esp
  80119a:	68 6f 2f 80 00       	push   $0x802f6f
  80119f:	6a 5f                	push   $0x5f
  8011a1:	68 85 2f 80 00       	push   $0x802f85
  8011a6:	e8 07 f0 ff ff       	call   8001b2 <_panic>
			panic("sys_page_map() panic\n");
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	68 6f 2f 80 00       	push   $0x802f6f
  8011b3:	6a 5b                	push   $0x5b
  8011b5:	68 85 2f 80 00       	push   $0x802f85
  8011ba:	e8 f3 ef ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011bf:	c1 e2 0c             	shl    $0xc,%edx
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	68 05 08 00 00       	push   $0x805
  8011ca:	52                   	push   %edx
  8011cb:	50                   	push   %eax
  8011cc:	52                   	push   %edx
  8011cd:	6a 00                	push   $0x0
  8011cf:	e8 68 fc ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  8011d4:	83 c4 20             	add    $0x20,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	0f 89 3d ff ff ff    	jns    80111c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	68 6f 2f 80 00       	push   $0x802f6f
  8011e7:	6a 66                	push   $0x66
  8011e9:	68 85 2f 80 00       	push   $0x802f85
  8011ee:	e8 bf ef ff ff       	call   8001b2 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011f3:	c1 e2 0c             	shl    $0xc,%edx
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	6a 05                	push   $0x5
  8011fb:	52                   	push   %edx
  8011fc:	50                   	push   %eax
  8011fd:	52                   	push   %edx
  8011fe:	6a 00                	push   $0x0
  801200:	e8 37 fc ff ff       	call   800e3c <sys_page_map>
		if(r < 0)
  801205:	83 c4 20             	add    $0x20,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	0f 89 0c ff ff ff    	jns    80111c <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801210:	83 ec 04             	sub    $0x4,%esp
  801213:	68 6f 2f 80 00       	push   $0x802f6f
  801218:	6a 6d                	push   $0x6d
  80121a:	68 85 2f 80 00       	push   $0x802f85
  80121f:	e8 8e ef ff ff       	call   8001b2 <_panic>

00801224 <pgfault>:
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	53                   	push   %ebx
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80122e:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801230:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801234:	0f 84 99 00 00 00    	je     8012d3 <pgfault+0xaf>
  80123a:	89 c2                	mov    %eax,%edx
  80123c:	c1 ea 16             	shr    $0x16,%edx
  80123f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801246:	f6 c2 01             	test   $0x1,%dl
  801249:	0f 84 84 00 00 00    	je     8012d3 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  80124f:	89 c2                	mov    %eax,%edx
  801251:	c1 ea 0c             	shr    $0xc,%edx
  801254:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80125b:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801261:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801267:	75 6a                	jne    8012d3 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801269:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126e:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	6a 07                	push   $0x7
  801275:	68 00 f0 7f 00       	push   $0x7ff000
  80127a:	6a 00                	push   $0x0
  80127c:	e8 78 fb ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 5f                	js     8012e7 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801288:	83 ec 04             	sub    $0x4,%esp
  80128b:	68 00 10 00 00       	push   $0x1000
  801290:	53                   	push   %ebx
  801291:	68 00 f0 7f 00       	push   $0x7ff000
  801296:	e8 5c f9 ff ff       	call   800bf7 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80129b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012a2:	53                   	push   %ebx
  8012a3:	6a 00                	push   $0x0
  8012a5:	68 00 f0 7f 00       	push   $0x7ff000
  8012aa:	6a 00                	push   $0x0
  8012ac:	e8 8b fb ff ff       	call   800e3c <sys_page_map>
	if(ret < 0)
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 43                	js     8012fb <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012b8:	83 ec 08             	sub    $0x8,%esp
  8012bb:	68 00 f0 7f 00       	push   $0x7ff000
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 b7 fb ff ff       	call   800e7e <sys_page_unmap>
	if(ret < 0)
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 41                	js     80130f <pgfault+0xeb>
}
  8012ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012d3:	83 ec 04             	sub    $0x4,%esp
  8012d6:	68 90 2f 80 00       	push   $0x802f90
  8012db:	6a 26                	push   $0x26
  8012dd:	68 85 2f 80 00       	push   $0x802f85
  8012e2:	e8 cb ee ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	68 a4 2f 80 00       	push   $0x802fa4
  8012ef:	6a 31                	push   $0x31
  8012f1:	68 85 2f 80 00       	push   $0x802f85
  8012f6:	e8 b7 ee ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_map()\n");
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	68 bf 2f 80 00       	push   $0x802fbf
  801303:	6a 36                	push   $0x36
  801305:	68 85 2f 80 00       	push   $0x802f85
  80130a:	e8 a3 ee ff ff       	call   8001b2 <_panic>
		panic("panic in sys_page_unmap()\n");
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	68 d8 2f 80 00       	push   $0x802fd8
  801317:	6a 39                	push   $0x39
  801319:	68 85 2f 80 00       	push   $0x802f85
  80131e:	e8 8f ee ff ff       	call   8001b2 <_panic>

00801323 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80132c:	68 24 12 80 00       	push   $0x801224
  801331:	e8 d1 14 00 00       	call   802807 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801336:	b8 07 00 00 00       	mov    $0x7,%eax
  80133b:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	78 27                	js     80136b <fork+0x48>
  801344:	89 c6                	mov    %eax,%esi
  801346:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801348:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80134d:	75 48                	jne    801397 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80134f:	e8 67 fa ff ff       	call   800dbb <sys_getenvid>
  801354:	25 ff 03 00 00       	and    $0x3ff,%eax
  801359:	c1 e0 07             	shl    $0x7,%eax
  80135c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801361:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801366:	e9 90 00 00 00       	jmp    8013fb <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	68 f4 2f 80 00       	push   $0x802ff4
  801373:	68 8c 00 00 00       	push   $0x8c
  801378:	68 85 2f 80 00       	push   $0x802f85
  80137d:	e8 30 ee ff ff       	call   8001b2 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801382:	89 f8                	mov    %edi,%eax
  801384:	e8 45 fd ff ff       	call   8010ce <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801389:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80138f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801395:	74 26                	je     8013bd <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801397:	89 d8                	mov    %ebx,%eax
  801399:	c1 e8 16             	shr    $0x16,%eax
  80139c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013a3:	a8 01                	test   $0x1,%al
  8013a5:	74 e2                	je     801389 <fork+0x66>
  8013a7:	89 da                	mov    %ebx,%edx
  8013a9:	c1 ea 0c             	shr    $0xc,%edx
  8013ac:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013b3:	83 e0 05             	and    $0x5,%eax
  8013b6:	83 f8 05             	cmp    $0x5,%eax
  8013b9:	75 ce                	jne    801389 <fork+0x66>
  8013bb:	eb c5                	jmp    801382 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	6a 07                	push   $0x7
  8013c2:	68 00 f0 bf ee       	push   $0xeebff000
  8013c7:	56                   	push   %esi
  8013c8:	e8 2c fa ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 31                	js     801405 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	68 76 28 80 00       	push   $0x802876
  8013dc:	56                   	push   %esi
  8013dd:	e8 62 fb ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 33                	js     80141c <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013e9:	83 ec 08             	sub    $0x8,%esp
  8013ec:	6a 02                	push   $0x2
  8013ee:	56                   	push   %esi
  8013ef:	e8 cc fa ff ff       	call   800ec0 <sys_env_set_status>
	if(ret < 0)
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 38                	js     801433 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013fb:	89 f0                	mov    %esi,%eax
  8013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801405:	83 ec 04             	sub    $0x4,%esp
  801408:	68 a4 2f 80 00       	push   $0x802fa4
  80140d:	68 98 00 00 00       	push   $0x98
  801412:	68 85 2f 80 00       	push   $0x802f85
  801417:	e8 96 ed ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	68 18 30 80 00       	push   $0x803018
  801424:	68 9b 00 00 00       	push   $0x9b
  801429:	68 85 2f 80 00       	push   $0x802f85
  80142e:	e8 7f ed ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_status()\n");
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 40 30 80 00       	push   $0x803040
  80143b:	68 9e 00 00 00       	push   $0x9e
  801440:	68 85 2f 80 00       	push   $0x802f85
  801445:	e8 68 ed ff ff       	call   8001b2 <_panic>

0080144a <sfork>:

// Challenge!
int
sfork(void)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	57                   	push   %edi
  80144e:	56                   	push   %esi
  80144f:	53                   	push   %ebx
  801450:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801453:	68 24 12 80 00       	push   $0x801224
  801458:	e8 aa 13 00 00       	call   802807 <set_pgfault_handler>
  80145d:	b8 07 00 00 00       	mov    $0x7,%eax
  801462:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 27                	js     801492 <sfork+0x48>
  80146b:	89 c7                	mov    %eax,%edi
  80146d:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80146f:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801474:	75 55                	jne    8014cb <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801476:	e8 40 f9 ff ff       	call   800dbb <sys_getenvid>
  80147b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801480:	c1 e0 07             	shl    $0x7,%eax
  801483:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801488:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80148d:	e9 d4 00 00 00       	jmp    801566 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	68 f4 2f 80 00       	push   $0x802ff4
  80149a:	68 af 00 00 00       	push   $0xaf
  80149f:	68 85 2f 80 00       	push   $0x802f85
  8014a4:	e8 09 ed ff ff       	call   8001b2 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014a9:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014ae:	89 f0                	mov    %esi,%eax
  8014b0:	e8 19 fc ff ff       	call   8010ce <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014bb:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014c1:	77 65                	ja     801528 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8014c3:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014c9:	74 de                	je     8014a9 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014cb:	89 d8                	mov    %ebx,%eax
  8014cd:	c1 e8 16             	shr    $0x16,%eax
  8014d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014d7:	a8 01                	test   $0x1,%al
  8014d9:	74 da                	je     8014b5 <sfork+0x6b>
  8014db:	89 da                	mov    %ebx,%edx
  8014dd:	c1 ea 0c             	shr    $0xc,%edx
  8014e0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014e7:	83 e0 05             	and    $0x5,%eax
  8014ea:	83 f8 05             	cmp    $0x5,%eax
  8014ed:	75 c6                	jne    8014b5 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014ef:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014f6:	c1 e2 0c             	shl    $0xc,%edx
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	83 e0 07             	and    $0x7,%eax
  8014ff:	50                   	push   %eax
  801500:	52                   	push   %edx
  801501:	56                   	push   %esi
  801502:	52                   	push   %edx
  801503:	6a 00                	push   $0x0
  801505:	e8 32 f9 ff ff       	call   800e3c <sys_page_map>
  80150a:	83 c4 20             	add    $0x20,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	74 a4                	je     8014b5 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 6f 2f 80 00       	push   $0x802f6f
  801519:	68 ba 00 00 00       	push   $0xba
  80151e:	68 85 2f 80 00       	push   $0x802f85
  801523:	e8 8a ec ff ff       	call   8001b2 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801528:	83 ec 04             	sub    $0x4,%esp
  80152b:	6a 07                	push   $0x7
  80152d:	68 00 f0 bf ee       	push   $0xeebff000
  801532:	57                   	push   %edi
  801533:	e8 c1 f8 ff ff       	call   800df9 <sys_page_alloc>
	if(ret < 0)
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 31                	js     801570 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	68 76 28 80 00       	push   $0x802876
  801547:	57                   	push   %edi
  801548:	e8 f7 f9 ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	78 33                	js     801587 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	6a 02                	push   $0x2
  801559:	57                   	push   %edi
  80155a:	e8 61 f9 ff ff       	call   800ec0 <sys_env_set_status>
	if(ret < 0)
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	85 c0                	test   %eax,%eax
  801564:	78 38                	js     80159e <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801566:	89 f8                	mov    %edi,%eax
  801568:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	68 a4 2f 80 00       	push   $0x802fa4
  801578:	68 c0 00 00 00       	push   $0xc0
  80157d:	68 85 2f 80 00       	push   $0x802f85
  801582:	e8 2b ec ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	68 18 30 80 00       	push   $0x803018
  80158f:	68 c3 00 00 00       	push   $0xc3
  801594:	68 85 2f 80 00       	push   $0x802f85
  801599:	e8 14 ec ff ff       	call   8001b2 <_panic>
		panic("panic in sys_env_set_status()\n");
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	68 40 30 80 00       	push   $0x803040
  8015a6:	68 c6 00 00 00       	push   $0xc6
  8015ab:	68 85 2f 80 00       	push   $0x802f85
  8015b0:	e8 fd eb ff ff       	call   8001b2 <_panic>

008015b5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
  8015ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8015c3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015c5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015ca:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	50                   	push   %eax
  8015d1:	e8 d3 f9 ff ff       	call   800fa9 <sys_ipc_recv>
	if(ret < 0){
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 2b                	js     801608 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015dd:	85 f6                	test   %esi,%esi
  8015df:	74 0a                	je     8015eb <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8015e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8015e6:	8b 40 74             	mov    0x74(%eax),%eax
  8015e9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015eb:	85 db                	test   %ebx,%ebx
  8015ed:	74 0a                	je     8015f9 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8015ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8015f4:	8b 40 78             	mov    0x78(%eax),%eax
  8015f7:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8015f9:	a1 08 50 80 00       	mov    0x805008,%eax
  8015fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  801601:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801604:	5b                   	pop    %ebx
  801605:	5e                   	pop    %esi
  801606:	5d                   	pop    %ebp
  801607:	c3                   	ret    
		if(from_env_store)
  801608:	85 f6                	test   %esi,%esi
  80160a:	74 06                	je     801612 <ipc_recv+0x5d>
			*from_env_store = 0;
  80160c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801612:	85 db                	test   %ebx,%ebx
  801614:	74 eb                	je     801601 <ipc_recv+0x4c>
			*perm_store = 0;
  801616:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80161c:	eb e3                	jmp    801601 <ipc_recv+0x4c>

0080161e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	57                   	push   %edi
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	8b 7d 08             	mov    0x8(%ebp),%edi
  80162a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80162d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801630:	85 db                	test   %ebx,%ebx
  801632:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801637:	0f 44 d8             	cmove  %eax,%ebx
  80163a:	eb 05                	jmp    801641 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80163c:	e8 99 f7 ff ff       	call   800dda <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801641:	ff 75 14             	pushl  0x14(%ebp)
  801644:	53                   	push   %ebx
  801645:	56                   	push   %esi
  801646:	57                   	push   %edi
  801647:	e8 3a f9 ff ff       	call   800f86 <sys_ipc_try_send>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 1b                	je     80166e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801653:	79 e7                	jns    80163c <ipc_send+0x1e>
  801655:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801658:	74 e2                	je     80163c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	68 5f 30 80 00       	push   $0x80305f
  801662:	6a 48                	push   $0x48
  801664:	68 74 30 80 00       	push   $0x803074
  801669:	e8 44 eb ff ff       	call   8001b2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801681:	89 c2                	mov    %eax,%edx
  801683:	c1 e2 07             	shl    $0x7,%edx
  801686:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80168c:	8b 52 50             	mov    0x50(%edx),%edx
  80168f:	39 ca                	cmp    %ecx,%edx
  801691:	74 11                	je     8016a4 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801693:	83 c0 01             	add    $0x1,%eax
  801696:	3d 00 04 00 00       	cmp    $0x400,%eax
  80169b:	75 e4                	jne    801681 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80169d:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a2:	eb 0b                	jmp    8016af <ipc_find_env+0x39>
			return envs[i].env_id;
  8016a4:	c1 e0 07             	shl    $0x7,%eax
  8016a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016ac:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	05 00 00 00 30       	add    $0x30000000,%eax
  8016bc:	c1 e8 0c             	shr    $0xc,%eax
}
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016d6:	5d                   	pop    %ebp
  8016d7:	c3                   	ret    

008016d8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016e0:	89 c2                	mov    %eax,%edx
  8016e2:	c1 ea 16             	shr    $0x16,%edx
  8016e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ec:	f6 c2 01             	test   $0x1,%dl
  8016ef:	74 2d                	je     80171e <fd_alloc+0x46>
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	c1 ea 0c             	shr    $0xc,%edx
  8016f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016fd:	f6 c2 01             	test   $0x1,%dl
  801700:	74 1c                	je     80171e <fd_alloc+0x46>
  801702:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801707:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80170c:	75 d2                	jne    8016e0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801717:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80171c:	eb 0a                	jmp    801728 <fd_alloc+0x50>
			*fd_store = fd;
  80171e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801721:	89 01                	mov    %eax,(%ecx)
			return 0;
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801728:	5d                   	pop    %ebp
  801729:	c3                   	ret    

0080172a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801730:	83 f8 1f             	cmp    $0x1f,%eax
  801733:	77 30                	ja     801765 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801735:	c1 e0 0c             	shl    $0xc,%eax
  801738:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80173d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801743:	f6 c2 01             	test   $0x1,%dl
  801746:	74 24                	je     80176c <fd_lookup+0x42>
  801748:	89 c2                	mov    %eax,%edx
  80174a:	c1 ea 0c             	shr    $0xc,%edx
  80174d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801754:	f6 c2 01             	test   $0x1,%dl
  801757:	74 1a                	je     801773 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	89 02                	mov    %eax,(%edx)
	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    
		return -E_INVAL;
  801765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176a:	eb f7                	jmp    801763 <fd_lookup+0x39>
		return -E_INVAL;
  80176c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801771:	eb f0                	jmp    801763 <fd_lookup+0x39>
  801773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801778:	eb e9                	jmp    801763 <fd_lookup+0x39>

0080177a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 08             	sub    $0x8,%esp
  801780:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801783:	ba 00 00 00 00       	mov    $0x0,%edx
  801788:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80178d:	39 08                	cmp    %ecx,(%eax)
  80178f:	74 38                	je     8017c9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801791:	83 c2 01             	add    $0x1,%edx
  801794:	8b 04 95 fc 30 80 00 	mov    0x8030fc(,%edx,4),%eax
  80179b:	85 c0                	test   %eax,%eax
  80179d:	75 ee                	jne    80178d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80179f:	a1 08 50 80 00       	mov    0x805008,%eax
  8017a4:	8b 40 48             	mov    0x48(%eax),%eax
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	51                   	push   %ecx
  8017ab:	50                   	push   %eax
  8017ac:	68 80 30 80 00       	push   $0x803080
  8017b1:	e8 f2 ea ff ff       	call   8002a8 <cprintf>
	*dev = 0;
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    
			*dev = devtab[i];
  8017c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017cc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d3:	eb f2                	jmp    8017c7 <dev_lookup+0x4d>

008017d5 <fd_close>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	57                   	push   %edi
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 24             	sub    $0x24,%esp
  8017de:	8b 75 08             	mov    0x8(%ebp),%esi
  8017e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017e8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017ee:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017f1:	50                   	push   %eax
  8017f2:	e8 33 ff ff ff       	call   80172a <fd_lookup>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 05                	js     801805 <fd_close+0x30>
	    || fd != fd2)
  801800:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801803:	74 16                	je     80181b <fd_close+0x46>
		return (must_exist ? r : 0);
  801805:	89 f8                	mov    %edi,%eax
  801807:	84 c0                	test   %al,%al
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
  80180e:	0f 44 d8             	cmove  %eax,%ebx
}
  801811:	89 d8                	mov    %ebx,%eax
  801813:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801816:	5b                   	pop    %ebx
  801817:	5e                   	pop    %esi
  801818:	5f                   	pop    %edi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801821:	50                   	push   %eax
  801822:	ff 36                	pushl  (%esi)
  801824:	e8 51 ff ff ff       	call   80177a <dev_lookup>
  801829:	89 c3                	mov    %eax,%ebx
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 1a                	js     80184c <fd_close+0x77>
		if (dev->dev_close)
  801832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801835:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801838:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80183d:	85 c0                	test   %eax,%eax
  80183f:	74 0b                	je     80184c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	56                   	push   %esi
  801845:	ff d0                	call   *%eax
  801847:	89 c3                	mov    %eax,%ebx
  801849:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	56                   	push   %esi
  801850:	6a 00                	push   $0x0
  801852:	e8 27 f6 ff ff       	call   800e7e <sys_page_unmap>
	return r;
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	eb b5                	jmp    801811 <fd_close+0x3c>

0080185c <close>:

int
close(int fdnum)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801865:	50                   	push   %eax
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	e8 bc fe ff ff       	call   80172a <fd_lookup>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	79 02                	jns    801877 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    
		return fd_close(fd, 1);
  801877:	83 ec 08             	sub    $0x8,%esp
  80187a:	6a 01                	push   $0x1
  80187c:	ff 75 f4             	pushl  -0xc(%ebp)
  80187f:	e8 51 ff ff ff       	call   8017d5 <fd_close>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	eb ec                	jmp    801875 <close+0x19>

00801889 <close_all>:

void
close_all(void)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	53                   	push   %ebx
  80188d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801890:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	53                   	push   %ebx
  801899:	e8 be ff ff ff       	call   80185c <close>
	for (i = 0; i < MAXFD; i++)
  80189e:	83 c3 01             	add    $0x1,%ebx
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	83 fb 20             	cmp    $0x20,%ebx
  8018a7:	75 ec                	jne    801895 <close_all+0xc>
}
  8018a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ba:	50                   	push   %eax
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	e8 67 fe ff ff       	call   80172a <fd_lookup>
  8018c3:	89 c3                	mov    %eax,%ebx
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	85 c0                	test   %eax,%eax
  8018ca:	0f 88 81 00 00 00    	js     801951 <dup+0xa3>
		return r;
	close(newfdnum);
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	e8 81 ff ff ff       	call   80185c <close>

	newfd = INDEX2FD(newfdnum);
  8018db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018de:	c1 e6 0c             	shl    $0xc,%esi
  8018e1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018e7:	83 c4 04             	add    $0x4,%esp
  8018ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ed:	e8 cf fd ff ff       	call   8016c1 <fd2data>
  8018f2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018f4:	89 34 24             	mov    %esi,(%esp)
  8018f7:	e8 c5 fd ff ff       	call   8016c1 <fd2data>
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801901:	89 d8                	mov    %ebx,%eax
  801903:	c1 e8 16             	shr    $0x16,%eax
  801906:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80190d:	a8 01                	test   $0x1,%al
  80190f:	74 11                	je     801922 <dup+0x74>
  801911:	89 d8                	mov    %ebx,%eax
  801913:	c1 e8 0c             	shr    $0xc,%eax
  801916:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80191d:	f6 c2 01             	test   $0x1,%dl
  801920:	75 39                	jne    80195b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801922:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801925:	89 d0                	mov    %edx,%eax
  801927:	c1 e8 0c             	shr    $0xc,%eax
  80192a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801931:	83 ec 0c             	sub    $0xc,%esp
  801934:	25 07 0e 00 00       	and    $0xe07,%eax
  801939:	50                   	push   %eax
  80193a:	56                   	push   %esi
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	6a 00                	push   $0x0
  801940:	e8 f7 f4 ff ff       	call   800e3c <sys_page_map>
  801945:	89 c3                	mov    %eax,%ebx
  801947:	83 c4 20             	add    $0x20,%esp
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 31                	js     80197f <dup+0xd1>
		goto err;

	return newfdnum;
  80194e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801951:	89 d8                	mov    %ebx,%eax
  801953:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80195b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	25 07 0e 00 00       	and    $0xe07,%eax
  80196a:	50                   	push   %eax
  80196b:	57                   	push   %edi
  80196c:	6a 00                	push   $0x0
  80196e:	53                   	push   %ebx
  80196f:	6a 00                	push   $0x0
  801971:	e8 c6 f4 ff ff       	call   800e3c <sys_page_map>
  801976:	89 c3                	mov    %eax,%ebx
  801978:	83 c4 20             	add    $0x20,%esp
  80197b:	85 c0                	test   %eax,%eax
  80197d:	79 a3                	jns    801922 <dup+0x74>
	sys_page_unmap(0, newfd);
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	56                   	push   %esi
  801983:	6a 00                	push   $0x0
  801985:	e8 f4 f4 ff ff       	call   800e7e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80198a:	83 c4 08             	add    $0x8,%esp
  80198d:	57                   	push   %edi
  80198e:	6a 00                	push   $0x0
  801990:	e8 e9 f4 ff ff       	call   800e7e <sys_page_unmap>
	return r;
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	eb b7                	jmp    801951 <dup+0xa3>

0080199a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 1c             	sub    $0x1c,%esp
  8019a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a7:	50                   	push   %eax
  8019a8:	53                   	push   %ebx
  8019a9:	e8 7c fd ff ff       	call   80172a <fd_lookup>
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 3f                	js     8019f4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bf:	ff 30                	pushl  (%eax)
  8019c1:	e8 b4 fd ff ff       	call   80177a <dev_lookup>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 27                	js     8019f4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d0:	8b 42 08             	mov    0x8(%edx),%eax
  8019d3:	83 e0 03             	and    $0x3,%eax
  8019d6:	83 f8 01             	cmp    $0x1,%eax
  8019d9:	74 1e                	je     8019f9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	8b 40 08             	mov    0x8(%eax),%eax
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	74 35                	je     801a1a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	ff 75 10             	pushl  0x10(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	52                   	push   %edx
  8019ef:	ff d0                	call   *%eax
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019f9:	a1 08 50 80 00       	mov    0x805008,%eax
  8019fe:	8b 40 48             	mov    0x48(%eax),%eax
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	53                   	push   %ebx
  801a05:	50                   	push   %eax
  801a06:	68 c1 30 80 00       	push   $0x8030c1
  801a0b:	e8 98 e8 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a18:	eb da                	jmp    8019f4 <read+0x5a>
		return -E_NOT_SUPP;
  801a1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1f:	eb d3                	jmp    8019f4 <read+0x5a>

00801a21 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	57                   	push   %edi
  801a25:	56                   	push   %esi
  801a26:	53                   	push   %ebx
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a2d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a30:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a35:	39 f3                	cmp    %esi,%ebx
  801a37:	73 23                	jae    801a5c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	89 f0                	mov    %esi,%eax
  801a3e:	29 d8                	sub    %ebx,%eax
  801a40:	50                   	push   %eax
  801a41:	89 d8                	mov    %ebx,%eax
  801a43:	03 45 0c             	add    0xc(%ebp),%eax
  801a46:	50                   	push   %eax
  801a47:	57                   	push   %edi
  801a48:	e8 4d ff ff ff       	call   80199a <read>
		if (m < 0)
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 06                	js     801a5a <readn+0x39>
			return m;
		if (m == 0)
  801a54:	74 06                	je     801a5c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a56:	01 c3                	add    %eax,%ebx
  801a58:	eb db                	jmp    801a35 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a5a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 1c             	sub    $0x1c,%esp
  801a6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a73:	50                   	push   %eax
  801a74:	53                   	push   %ebx
  801a75:	e8 b0 fc ff ff       	call   80172a <fd_lookup>
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 3a                	js     801abb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	ff 30                	pushl  (%eax)
  801a8d:	e8 e8 fc ff ff       	call   80177a <dev_lookup>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 22                	js     801abb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aa0:	74 1e                	je     801ac0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa5:	8b 52 0c             	mov    0xc(%edx),%edx
  801aa8:	85 d2                	test   %edx,%edx
  801aaa:	74 35                	je     801ae1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	ff d2                	call   *%edx
  801ab8:	83 c4 10             	add    $0x10,%esp
}
  801abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ac0:	a1 08 50 80 00       	mov    0x805008,%eax
  801ac5:	8b 40 48             	mov    0x48(%eax),%eax
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	53                   	push   %ebx
  801acc:	50                   	push   %eax
  801acd:	68 dd 30 80 00       	push   $0x8030dd
  801ad2:	e8 d1 e7 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801adf:	eb da                	jmp    801abb <write+0x55>
		return -E_NOT_SUPP;
  801ae1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae6:	eb d3                	jmp    801abb <write+0x55>

00801ae8 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af1:	50                   	push   %eax
  801af2:	ff 75 08             	pushl  0x8(%ebp)
  801af5:	e8 30 fc ff ff       	call   80172a <fd_lookup>
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	85 c0                	test   %eax,%eax
  801aff:	78 0e                	js     801b0f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b07:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	53                   	push   %ebx
  801b15:	83 ec 1c             	sub    $0x1c,%esp
  801b18:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b1b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1e:	50                   	push   %eax
  801b1f:	53                   	push   %ebx
  801b20:	e8 05 fc ff ff       	call   80172a <fd_lookup>
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 37                	js     801b63 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b32:	50                   	push   %eax
  801b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b36:	ff 30                	pushl  (%eax)
  801b38:	e8 3d fc ff ff       	call   80177a <dev_lookup>
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	85 c0                	test   %eax,%eax
  801b42:	78 1f                	js     801b63 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b4b:	74 1b                	je     801b68 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b50:	8b 52 18             	mov    0x18(%edx),%edx
  801b53:	85 d2                	test   %edx,%edx
  801b55:	74 32                	je     801b89 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	ff 75 0c             	pushl  0xc(%ebp)
  801b5d:	50                   	push   %eax
  801b5e:	ff d2                	call   *%edx
  801b60:	83 c4 10             	add    $0x10,%esp
}
  801b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b68:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b6d:	8b 40 48             	mov    0x48(%eax),%eax
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	53                   	push   %ebx
  801b74:	50                   	push   %eax
  801b75:	68 a0 30 80 00       	push   $0x8030a0
  801b7a:	e8 29 e7 ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b87:	eb da                	jmp    801b63 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b89:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8e:	eb d3                	jmp    801b63 <ftruncate+0x52>

00801b90 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	83 ec 1c             	sub    $0x1c,%esp
  801b97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b9a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b9d:	50                   	push   %eax
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	e8 84 fb ff ff       	call   80172a <fd_lookup>
  801ba6:	83 c4 10             	add    $0x10,%esp
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	78 4b                	js     801bf8 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bad:	83 ec 08             	sub    $0x8,%esp
  801bb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb3:	50                   	push   %eax
  801bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb7:	ff 30                	pushl  (%eax)
  801bb9:	e8 bc fb ff ff       	call   80177a <dev_lookup>
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	78 33                	js     801bf8 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bcc:	74 2f                	je     801bfd <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bce:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bd1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bd8:	00 00 00 
	stat->st_isdir = 0;
  801bdb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801be2:	00 00 00 
	stat->st_dev = dev;
  801be5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	53                   	push   %ebx
  801bef:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf2:	ff 50 14             	call   *0x14(%eax)
  801bf5:	83 c4 10             	add    $0x10,%esp
}
  801bf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    
		return -E_NOT_SUPP;
  801bfd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c02:	eb f4                	jmp    801bf8 <fstat+0x68>

00801c04 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	56                   	push   %esi
  801c08:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	6a 00                	push   $0x0
  801c0e:	ff 75 08             	pushl  0x8(%ebp)
  801c11:	e8 22 02 00 00       	call   801e38 <open>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 1b                	js     801c3a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	ff 75 0c             	pushl  0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	e8 65 ff ff ff       	call   801b90 <fstat>
  801c2b:	89 c6                	mov    %eax,%esi
	close(fd);
  801c2d:	89 1c 24             	mov    %ebx,(%esp)
  801c30:	e8 27 fc ff ff       	call   80185c <close>
	return r;
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	89 f3                	mov    %esi,%ebx
}
  801c3a:	89 d8                	mov    %ebx,%eax
  801c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    

00801c43 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	89 c6                	mov    %eax,%esi
  801c4a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c4c:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c53:	74 27                	je     801c7c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c55:	6a 07                	push   $0x7
  801c57:	68 00 60 80 00       	push   $0x806000
  801c5c:	56                   	push   %esi
  801c5d:	ff 35 00 50 80 00    	pushl  0x805000
  801c63:	e8 b6 f9 ff ff       	call   80161e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c68:	83 c4 0c             	add    $0xc,%esp
  801c6b:	6a 00                	push   $0x0
  801c6d:	53                   	push   %ebx
  801c6e:	6a 00                	push   $0x0
  801c70:	e8 40 f9 ff ff       	call   8015b5 <ipc_recv>
}
  801c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c7c:	83 ec 0c             	sub    $0xc,%esp
  801c7f:	6a 01                	push   $0x1
  801c81:	e8 f0 f9 ff ff       	call   801676 <ipc_find_env>
  801c86:	a3 00 50 80 00       	mov    %eax,0x805000
  801c8b:	83 c4 10             	add    $0x10,%esp
  801c8e:	eb c5                	jmp    801c55 <fsipc+0x12>

00801c90 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cae:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb3:	e8 8b ff ff ff       	call   801c43 <fsipc>
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <devfile_flush>:
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd0:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd5:	e8 69 ff ff ff       	call   801c43 <fsipc>
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <devfile_stat>:
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 04             	sub    $0x4,%esp
  801ce3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cec:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf6:	b8 05 00 00 00       	mov    $0x5,%eax
  801cfb:	e8 43 ff ff ff       	call   801c43 <fsipc>
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 2c                	js     801d30 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d04:	83 ec 08             	sub    $0x8,%esp
  801d07:	68 00 60 80 00       	push   $0x806000
  801d0c:	53                   	push   %ebx
  801d0d:	e8 f5 ec ff ff       	call   800a07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d12:	a1 80 60 80 00       	mov    0x806080,%eax
  801d17:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d1d:	a1 84 60 80 00       	mov    0x806084,%eax
  801d22:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <devfile_write>:
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	53                   	push   %ebx
  801d39:	83 ec 08             	sub    $0x8,%esp
  801d3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	8b 40 0c             	mov    0xc(%eax),%eax
  801d45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d4a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d50:	53                   	push   %ebx
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	68 08 60 80 00       	push   $0x806008
  801d59:	e8 99 ee ff ff       	call   800bf7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	b8 04 00 00 00       	mov    $0x4,%eax
  801d68:	e8 d6 fe ff ff       	call   801c43 <fsipc>
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 0b                	js     801d7f <devfile_write+0x4a>
	assert(r <= n);
  801d74:	39 d8                	cmp    %ebx,%eax
  801d76:	77 0c                	ja     801d84 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d7d:	7f 1e                	jg     801d9d <devfile_write+0x68>
}
  801d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    
	assert(r <= n);
  801d84:	68 10 31 80 00       	push   $0x803110
  801d89:	68 17 31 80 00       	push   $0x803117
  801d8e:	68 98 00 00 00       	push   $0x98
  801d93:	68 2c 31 80 00       	push   $0x80312c
  801d98:	e8 15 e4 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  801d9d:	68 37 31 80 00       	push   $0x803137
  801da2:	68 17 31 80 00       	push   $0x803117
  801da7:	68 99 00 00 00       	push   $0x99
  801dac:	68 2c 31 80 00       	push   $0x80312c
  801db1:	e8 fc e3 ff ff       	call   8001b2 <_panic>

00801db6 <devfile_read>:
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dc9:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801dd9:	e8 65 fe ff ff       	call   801c43 <fsipc>
  801dde:	89 c3                	mov    %eax,%ebx
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 1f                	js     801e03 <devfile_read+0x4d>
	assert(r <= n);
  801de4:	39 f0                	cmp    %esi,%eax
  801de6:	77 24                	ja     801e0c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801de8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ded:	7f 33                	jg     801e22 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	50                   	push   %eax
  801df3:	68 00 60 80 00       	push   $0x806000
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	e8 95 ed ff ff       	call   800b95 <memmove>
	return r;
  801e00:	83 c4 10             	add    $0x10,%esp
}
  801e03:	89 d8                	mov    %ebx,%eax
  801e05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    
	assert(r <= n);
  801e0c:	68 10 31 80 00       	push   $0x803110
  801e11:	68 17 31 80 00       	push   $0x803117
  801e16:	6a 7c                	push   $0x7c
  801e18:	68 2c 31 80 00       	push   $0x80312c
  801e1d:	e8 90 e3 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  801e22:	68 37 31 80 00       	push   $0x803137
  801e27:	68 17 31 80 00       	push   $0x803117
  801e2c:	6a 7d                	push   $0x7d
  801e2e:	68 2c 31 80 00       	push   $0x80312c
  801e33:	e8 7a e3 ff ff       	call   8001b2 <_panic>

00801e38 <open>:
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	56                   	push   %esi
  801e3c:	53                   	push   %ebx
  801e3d:	83 ec 1c             	sub    $0x1c,%esp
  801e40:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e43:	56                   	push   %esi
  801e44:	e8 85 eb ff ff       	call   8009ce <strlen>
  801e49:	83 c4 10             	add    $0x10,%esp
  801e4c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e51:	7f 6c                	jg     801ebf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e59:	50                   	push   %eax
  801e5a:	e8 79 f8 ff ff       	call   8016d8 <fd_alloc>
  801e5f:	89 c3                	mov    %eax,%ebx
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 3c                	js     801ea4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e68:	83 ec 08             	sub    $0x8,%esp
  801e6b:	56                   	push   %esi
  801e6c:	68 00 60 80 00       	push   $0x806000
  801e71:	e8 91 eb ff ff       	call   800a07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	b8 01 00 00 00       	mov    $0x1,%eax
  801e86:	e8 b8 fd ff ff       	call   801c43 <fsipc>
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 19                	js     801ead <open+0x75>
	return fd2num(fd);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9a:	e8 12 f8 ff ff       	call   8016b1 <fd2num>
  801e9f:	89 c3                	mov    %eax,%ebx
  801ea1:	83 c4 10             	add    $0x10,%esp
}
  801ea4:	89 d8                	mov    %ebx,%eax
  801ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea9:	5b                   	pop    %ebx
  801eaa:	5e                   	pop    %esi
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    
		fd_close(fd, 0);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb5:	e8 1b f9 ff ff       	call   8017d5 <fd_close>
		return r;
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	eb e5                	jmp    801ea4 <open+0x6c>
		return -E_BAD_PATH;
  801ebf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ec4:	eb de                	jmp    801ea4 <open+0x6c>

00801ec6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed6:	e8 68 fd ff ff       	call   801c43 <fsipc>
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ee3:	68 43 31 80 00       	push   $0x803143
  801ee8:	ff 75 0c             	pushl  0xc(%ebp)
  801eeb:	e8 17 eb ff ff       	call   800a07 <strcpy>
	return 0;
}
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <devsock_close>:
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	53                   	push   %ebx
  801efb:	83 ec 10             	sub    $0x10,%esp
  801efe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f01:	53                   	push   %ebx
  801f02:	e8 95 09 00 00       	call   80289c <pageref>
  801f07:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f0a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f0f:	83 f8 01             	cmp    $0x1,%eax
  801f12:	74 07                	je     801f1b <devsock_close+0x24>
}
  801f14:	89 d0                	mov    %edx,%eax
  801f16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	ff 73 0c             	pushl  0xc(%ebx)
  801f21:	e8 b9 02 00 00       	call   8021df <nsipc_close>
  801f26:	89 c2                	mov    %eax,%edx
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	eb e7                	jmp    801f14 <devsock_close+0x1d>

00801f2d <devsock_write>:
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f33:	6a 00                	push   $0x0
  801f35:	ff 75 10             	pushl  0x10(%ebp)
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	ff 70 0c             	pushl  0xc(%eax)
  801f41:	e8 76 03 00 00       	call   8022bc <nsipc_send>
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <devsock_read>:
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 10             	pushl  0x10(%ebp)
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	ff 70 0c             	pushl  0xc(%eax)
  801f5c:	e8 ef 02 00 00       	call   802250 <nsipc_recv>
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <fd2sockid>:
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f69:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	e8 b7 f7 ff ff       	call   80172a <fd_lookup>
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 10                	js     801f8a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f83:	39 08                	cmp    %ecx,(%eax)
  801f85:	75 05                	jne    801f8c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f87:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    
		return -E_NOT_SUPP;
  801f8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f91:	eb f7                	jmp    801f8a <fd2sockid+0x27>

00801f93 <alloc_sockfd>:
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
  801f98:	83 ec 1c             	sub    $0x1c,%esp
  801f9b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa0:	50                   	push   %eax
  801fa1:	e8 32 f7 ff ff       	call   8016d8 <fd_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 43                	js     801ff2 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	68 07 04 00 00       	push   $0x407
  801fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 38 ee ff ff       	call   800df9 <sys_page_alloc>
  801fc1:	89 c3                	mov    %eax,%ebx
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	78 28                	js     801ff2 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fd3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fdf:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	50                   	push   %eax
  801fe6:	e8 c6 f6 ff ff       	call   8016b1 <fd2num>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	eb 0c                	jmp    801ffe <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	56                   	push   %esi
  801ff6:	e8 e4 01 00 00       	call   8021df <nsipc_close>
		return r;
  801ffb:	83 c4 10             	add    $0x10,%esp
}
  801ffe:	89 d8                	mov    %ebx,%eax
  802000:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802003:	5b                   	pop    %ebx
  802004:	5e                   	pop    %esi
  802005:	5d                   	pop    %ebp
  802006:	c3                   	ret    

00802007 <accept>:
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	e8 4e ff ff ff       	call   801f63 <fd2sockid>
  802015:	85 c0                	test   %eax,%eax
  802017:	78 1b                	js     802034 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	ff 75 10             	pushl  0x10(%ebp)
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	50                   	push   %eax
  802023:	e8 0e 01 00 00       	call   802136 <nsipc_accept>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 05                	js     802034 <accept+0x2d>
	return alloc_sockfd(r);
  80202f:	e8 5f ff ff ff       	call   801f93 <alloc_sockfd>
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <bind>:
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	e8 1f ff ff ff       	call   801f63 <fd2sockid>
  802044:	85 c0                	test   %eax,%eax
  802046:	78 12                	js     80205a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	ff 75 10             	pushl  0x10(%ebp)
  80204e:	ff 75 0c             	pushl  0xc(%ebp)
  802051:	50                   	push   %eax
  802052:	e8 31 01 00 00       	call   802188 <nsipc_bind>
  802057:	83 c4 10             	add    $0x10,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <shutdown>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	e8 f9 fe ff ff       	call   801f63 <fd2sockid>
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 0f                	js     80207d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	50                   	push   %eax
  802075:	e8 43 01 00 00       	call   8021bd <nsipc_shutdown>
  80207a:	83 c4 10             	add    $0x10,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <connect>:
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	e8 d6 fe ff ff       	call   801f63 <fd2sockid>
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 12                	js     8020a3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	ff 75 10             	pushl  0x10(%ebp)
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	50                   	push   %eax
  80209b:	e8 59 01 00 00       	call   8021f9 <nsipc_connect>
  8020a0:	83 c4 10             	add    $0x10,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <listen>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	e8 b0 fe ff ff       	call   801f63 <fd2sockid>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 0f                	js     8020c6 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020b7:	83 ec 08             	sub    $0x8,%esp
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	50                   	push   %eax
  8020be:	e8 6b 01 00 00       	call   80222e <nsipc_listen>
  8020c3:	83 c4 10             	add    $0x10,%esp
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ce:	ff 75 10             	pushl  0x10(%ebp)
  8020d1:	ff 75 0c             	pushl  0xc(%ebp)
  8020d4:	ff 75 08             	pushl  0x8(%ebp)
  8020d7:	e8 3e 02 00 00       	call   80231a <nsipc_socket>
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 05                	js     8020e8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020e3:	e8 ab fe ff ff       	call   801f93 <alloc_sockfd>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	53                   	push   %ebx
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020f3:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020fa:	74 26                	je     802122 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020fc:	6a 07                	push   $0x7
  8020fe:	68 00 70 80 00       	push   $0x807000
  802103:	53                   	push   %ebx
  802104:	ff 35 04 50 80 00    	pushl  0x805004
  80210a:	e8 0f f5 ff ff       	call   80161e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80210f:	83 c4 0c             	add    $0xc,%esp
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	e8 98 f4 ff ff       	call   8015b5 <ipc_recv>
}
  80211d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802120:	c9                   	leave  
  802121:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	6a 02                	push   $0x2
  802127:	e8 4a f5 ff ff       	call   801676 <ipc_find_env>
  80212c:	a3 04 50 80 00       	mov    %eax,0x805004
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	eb c6                	jmp    8020fc <nsipc+0x12>

00802136 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	56                   	push   %esi
  80213a:	53                   	push   %ebx
  80213b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802146:	8b 06                	mov    (%esi),%eax
  802148:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80214d:	b8 01 00 00 00       	mov    $0x1,%eax
  802152:	e8 93 ff ff ff       	call   8020ea <nsipc>
  802157:	89 c3                	mov    %eax,%ebx
  802159:	85 c0                	test   %eax,%eax
  80215b:	79 09                	jns    802166 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80215d:	89 d8                	mov    %ebx,%eax
  80215f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802162:	5b                   	pop    %ebx
  802163:	5e                   	pop    %esi
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802166:	83 ec 04             	sub    $0x4,%esp
  802169:	ff 35 10 70 80 00    	pushl  0x807010
  80216f:	68 00 70 80 00       	push   $0x807000
  802174:	ff 75 0c             	pushl  0xc(%ebp)
  802177:	e8 19 ea ff ff       	call   800b95 <memmove>
		*addrlen = ret->ret_addrlen;
  80217c:	a1 10 70 80 00       	mov    0x807010,%eax
  802181:	89 06                	mov    %eax,(%esi)
  802183:	83 c4 10             	add    $0x10,%esp
	return r;
  802186:	eb d5                	jmp    80215d <nsipc_accept+0x27>

00802188 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	53                   	push   %ebx
  80218c:	83 ec 08             	sub    $0x8,%esp
  80218f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80219a:	53                   	push   %ebx
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	68 04 70 80 00       	push   $0x807004
  8021a3:	e8 ed e9 ff ff       	call   800b95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8021b3:	e8 32 ff ff ff       	call   8020ea <nsipc>
}
  8021b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ce:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021d3:	b8 03 00 00 00       	mov    $0x3,%eax
  8021d8:	e8 0d ff ff ff       	call   8020ea <nsipc>
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <nsipc_close>:

int
nsipc_close(int s)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8021f2:	e8 f3 fe ff ff       	call   8020ea <nsipc>
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 08             	sub    $0x8,%esp
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80220b:	53                   	push   %ebx
  80220c:	ff 75 0c             	pushl  0xc(%ebp)
  80220f:	68 04 70 80 00       	push   $0x807004
  802214:	e8 7c e9 ff ff       	call   800b95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802219:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80221f:	b8 05 00 00 00       	mov    $0x5,%eax
  802224:	e8 c1 fe ff ff       	call   8020ea <nsipc>
}
  802229:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802244:	b8 06 00 00 00       	mov    $0x6,%eax
  802249:	e8 9c fe ff ff       	call   8020ea <nsipc>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	56                   	push   %esi
  802254:	53                   	push   %ebx
  802255:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802260:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802266:	8b 45 14             	mov    0x14(%ebp),%eax
  802269:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80226e:	b8 07 00 00 00       	mov    $0x7,%eax
  802273:	e8 72 fe ff ff       	call   8020ea <nsipc>
  802278:	89 c3                	mov    %eax,%ebx
  80227a:	85 c0                	test   %eax,%eax
  80227c:	78 1f                	js     80229d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80227e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802283:	7f 21                	jg     8022a6 <nsipc_recv+0x56>
  802285:	39 c6                	cmp    %eax,%esi
  802287:	7c 1d                	jl     8022a6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802289:	83 ec 04             	sub    $0x4,%esp
  80228c:	50                   	push   %eax
  80228d:	68 00 70 80 00       	push   $0x807000
  802292:	ff 75 0c             	pushl  0xc(%ebp)
  802295:	e8 fb e8 ff ff       	call   800b95 <memmove>
  80229a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80229d:	89 d8                	mov    %ebx,%eax
  80229f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a2:	5b                   	pop    %ebx
  8022a3:	5e                   	pop    %esi
  8022a4:	5d                   	pop    %ebp
  8022a5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022a6:	68 4f 31 80 00       	push   $0x80314f
  8022ab:	68 17 31 80 00       	push   $0x803117
  8022b0:	6a 62                	push   $0x62
  8022b2:	68 64 31 80 00       	push   $0x803164
  8022b7:	e8 f6 de ff ff       	call   8001b2 <_panic>

008022bc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022ce:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022d4:	7f 2e                	jg     802304 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	53                   	push   %ebx
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	68 0c 70 80 00       	push   $0x80700c
  8022e2:	e8 ae e8 ff ff       	call   800b95 <memmove>
	nsipcbuf.send.req_size = size;
  8022e7:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8022fa:	e8 eb fd ff ff       	call   8020ea <nsipc>
}
  8022ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802302:	c9                   	leave  
  802303:	c3                   	ret    
	assert(size < 1600);
  802304:	68 70 31 80 00       	push   $0x803170
  802309:	68 17 31 80 00       	push   $0x803117
  80230e:	6a 6d                	push   $0x6d
  802310:	68 64 31 80 00       	push   $0x803164
  802315:	e8 98 de ff ff       	call   8001b2 <_panic>

0080231a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802330:	8b 45 10             	mov    0x10(%ebp),%eax
  802333:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802338:	b8 09 00 00 00       	mov    $0x9,%eax
  80233d:	e8 a8 fd ff ff       	call   8020ea <nsipc>
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	e8 6a f3 ff ff       	call   8016c1 <fd2data>
  802357:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802359:	83 c4 08             	add    $0x8,%esp
  80235c:	68 7c 31 80 00       	push   $0x80317c
  802361:	53                   	push   %ebx
  802362:	e8 a0 e6 ff ff       	call   800a07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802367:	8b 46 04             	mov    0x4(%esi),%eax
  80236a:	2b 06                	sub    (%esi),%eax
  80236c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802372:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802379:	00 00 00 
	stat->st_dev = &devpipe;
  80237c:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802383:	40 80 00 
	return 0;
}
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
  80238b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80238e:	5b                   	pop    %ebx
  80238f:	5e                   	pop    %esi
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    

00802392 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	53                   	push   %ebx
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80239c:	53                   	push   %ebx
  80239d:	6a 00                	push   $0x0
  80239f:	e8 da ea ff ff       	call   800e7e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023a4:	89 1c 24             	mov    %ebx,(%esp)
  8023a7:	e8 15 f3 ff ff       	call   8016c1 <fd2data>
  8023ac:	83 c4 08             	add    $0x8,%esp
  8023af:	50                   	push   %eax
  8023b0:	6a 00                	push   $0x0
  8023b2:	e8 c7 ea ff ff       	call   800e7e <sys_page_unmap>
}
  8023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <_pipeisclosed>:
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	57                   	push   %edi
  8023c0:	56                   	push   %esi
  8023c1:	53                   	push   %ebx
  8023c2:	83 ec 1c             	sub    $0x1c,%esp
  8023c5:	89 c7                	mov    %eax,%edi
  8023c7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8023ce:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023d1:	83 ec 0c             	sub    $0xc,%esp
  8023d4:	57                   	push   %edi
  8023d5:	e8 c2 04 00 00       	call   80289c <pageref>
  8023da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023dd:	89 34 24             	mov    %esi,(%esp)
  8023e0:	e8 b7 04 00 00       	call   80289c <pageref>
		nn = thisenv->env_runs;
  8023e5:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023ee:	83 c4 10             	add    $0x10,%esp
  8023f1:	39 cb                	cmp    %ecx,%ebx
  8023f3:	74 1b                	je     802410 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f8:	75 cf                	jne    8023c9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023fa:	8b 42 58             	mov    0x58(%edx),%eax
  8023fd:	6a 01                	push   $0x1
  8023ff:	50                   	push   %eax
  802400:	53                   	push   %ebx
  802401:	68 83 31 80 00       	push   $0x803183
  802406:	e8 9d de ff ff       	call   8002a8 <cprintf>
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	eb b9                	jmp    8023c9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802410:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802413:	0f 94 c0             	sete   %al
  802416:	0f b6 c0             	movzbl %al,%eax
}
  802419:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <devpipe_write>:
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	57                   	push   %edi
  802425:	56                   	push   %esi
  802426:	53                   	push   %ebx
  802427:	83 ec 28             	sub    $0x28,%esp
  80242a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80242d:	56                   	push   %esi
  80242e:	e8 8e f2 ff ff       	call   8016c1 <fd2data>
  802433:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	bf 00 00 00 00       	mov    $0x0,%edi
  80243d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802440:	74 4f                	je     802491 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802442:	8b 43 04             	mov    0x4(%ebx),%eax
  802445:	8b 0b                	mov    (%ebx),%ecx
  802447:	8d 51 20             	lea    0x20(%ecx),%edx
  80244a:	39 d0                	cmp    %edx,%eax
  80244c:	72 14                	jb     802462 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80244e:	89 da                	mov    %ebx,%edx
  802450:	89 f0                	mov    %esi,%eax
  802452:	e8 65 ff ff ff       	call   8023bc <_pipeisclosed>
  802457:	85 c0                	test   %eax,%eax
  802459:	75 3b                	jne    802496 <devpipe_write+0x75>
			sys_yield();
  80245b:	e8 7a e9 ff ff       	call   800dda <sys_yield>
  802460:	eb e0                	jmp    802442 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802462:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802465:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802469:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80246c:	89 c2                	mov    %eax,%edx
  80246e:	c1 fa 1f             	sar    $0x1f,%edx
  802471:	89 d1                	mov    %edx,%ecx
  802473:	c1 e9 1b             	shr    $0x1b,%ecx
  802476:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802479:	83 e2 1f             	and    $0x1f,%edx
  80247c:	29 ca                	sub    %ecx,%edx
  80247e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802482:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802486:	83 c0 01             	add    $0x1,%eax
  802489:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80248c:	83 c7 01             	add    $0x1,%edi
  80248f:	eb ac                	jmp    80243d <devpipe_write+0x1c>
	return i;
  802491:	8b 45 10             	mov    0x10(%ebp),%eax
  802494:	eb 05                	jmp    80249b <devpipe_write+0x7a>
				return 0;
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249e:	5b                   	pop    %ebx
  80249f:	5e                   	pop    %esi
  8024a0:	5f                   	pop    %edi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <devpipe_read>:
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	57                   	push   %edi
  8024a7:	56                   	push   %esi
  8024a8:	53                   	push   %ebx
  8024a9:	83 ec 18             	sub    $0x18,%esp
  8024ac:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024af:	57                   	push   %edi
  8024b0:	e8 0c f2 ff ff       	call   8016c1 <fd2data>
  8024b5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	be 00 00 00 00       	mov    $0x0,%esi
  8024bf:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c2:	75 14                	jne    8024d8 <devpipe_read+0x35>
	return i;
  8024c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c7:	eb 02                	jmp    8024cb <devpipe_read+0x28>
				return i;
  8024c9:	89 f0                	mov    %esi,%eax
}
  8024cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ce:	5b                   	pop    %ebx
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    
			sys_yield();
  8024d3:	e8 02 e9 ff ff       	call   800dda <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024d8:	8b 03                	mov    (%ebx),%eax
  8024da:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024dd:	75 18                	jne    8024f7 <devpipe_read+0x54>
			if (i > 0)
  8024df:	85 f6                	test   %esi,%esi
  8024e1:	75 e6                	jne    8024c9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024e3:	89 da                	mov    %ebx,%edx
  8024e5:	89 f8                	mov    %edi,%eax
  8024e7:	e8 d0 fe ff ff       	call   8023bc <_pipeisclosed>
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	74 e3                	je     8024d3 <devpipe_read+0x30>
				return 0;
  8024f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f5:	eb d4                	jmp    8024cb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024f7:	99                   	cltd   
  8024f8:	c1 ea 1b             	shr    $0x1b,%edx
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	83 e0 1f             	and    $0x1f,%eax
  802500:	29 d0                	sub    %edx,%eax
  802502:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80250a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80250d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802510:	83 c6 01             	add    $0x1,%esi
  802513:	eb aa                	jmp    8024bf <devpipe_read+0x1c>

00802515 <pipe>:
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	56                   	push   %esi
  802519:	53                   	push   %ebx
  80251a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80251d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802520:	50                   	push   %eax
  802521:	e8 b2 f1 ff ff       	call   8016d8 <fd_alloc>
  802526:	89 c3                	mov    %eax,%ebx
  802528:	83 c4 10             	add    $0x10,%esp
  80252b:	85 c0                	test   %eax,%eax
  80252d:	0f 88 23 01 00 00    	js     802656 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802533:	83 ec 04             	sub    $0x4,%esp
  802536:	68 07 04 00 00       	push   $0x407
  80253b:	ff 75 f4             	pushl  -0xc(%ebp)
  80253e:	6a 00                	push   $0x0
  802540:	e8 b4 e8 ff ff       	call   800df9 <sys_page_alloc>
  802545:	89 c3                	mov    %eax,%ebx
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	85 c0                	test   %eax,%eax
  80254c:	0f 88 04 01 00 00    	js     802656 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802552:	83 ec 0c             	sub    $0xc,%esp
  802555:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802558:	50                   	push   %eax
  802559:	e8 7a f1 ff ff       	call   8016d8 <fd_alloc>
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	83 c4 10             	add    $0x10,%esp
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 88 db 00 00 00    	js     802646 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 07 04 00 00       	push   $0x407
  802573:	ff 75 f0             	pushl  -0x10(%ebp)
  802576:	6a 00                	push   $0x0
  802578:	e8 7c e8 ff ff       	call   800df9 <sys_page_alloc>
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	85 c0                	test   %eax,%eax
  802584:	0f 88 bc 00 00 00    	js     802646 <pipe+0x131>
	va = fd2data(fd0);
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	ff 75 f4             	pushl  -0xc(%ebp)
  802590:	e8 2c f1 ff ff       	call   8016c1 <fd2data>
  802595:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802597:	83 c4 0c             	add    $0xc,%esp
  80259a:	68 07 04 00 00       	push   $0x407
  80259f:	50                   	push   %eax
  8025a0:	6a 00                	push   $0x0
  8025a2:	e8 52 e8 ff ff       	call   800df9 <sys_page_alloc>
  8025a7:	89 c3                	mov    %eax,%ebx
  8025a9:	83 c4 10             	add    $0x10,%esp
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	0f 88 82 00 00 00    	js     802636 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ba:	e8 02 f1 ff ff       	call   8016c1 <fd2data>
  8025bf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025c6:	50                   	push   %eax
  8025c7:	6a 00                	push   $0x0
  8025c9:	56                   	push   %esi
  8025ca:	6a 00                	push   $0x0
  8025cc:	e8 6b e8 ff ff       	call   800e3c <sys_page_map>
  8025d1:	89 c3                	mov    %eax,%ebx
  8025d3:	83 c4 20             	add    $0x20,%esp
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	78 4e                	js     802628 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025da:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025fd:	83 ec 0c             	sub    $0xc,%esp
  802600:	ff 75 f4             	pushl  -0xc(%ebp)
  802603:	e8 a9 f0 ff ff       	call   8016b1 <fd2num>
  802608:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80260d:	83 c4 04             	add    $0x4,%esp
  802610:	ff 75 f0             	pushl  -0x10(%ebp)
  802613:	e8 99 f0 ff ff       	call   8016b1 <fd2num>
  802618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80261e:	83 c4 10             	add    $0x10,%esp
  802621:	bb 00 00 00 00       	mov    $0x0,%ebx
  802626:	eb 2e                	jmp    802656 <pipe+0x141>
	sys_page_unmap(0, va);
  802628:	83 ec 08             	sub    $0x8,%esp
  80262b:	56                   	push   %esi
  80262c:	6a 00                	push   $0x0
  80262e:	e8 4b e8 ff ff       	call   800e7e <sys_page_unmap>
  802633:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802636:	83 ec 08             	sub    $0x8,%esp
  802639:	ff 75 f0             	pushl  -0x10(%ebp)
  80263c:	6a 00                	push   $0x0
  80263e:	e8 3b e8 ff ff       	call   800e7e <sys_page_unmap>
  802643:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802646:	83 ec 08             	sub    $0x8,%esp
  802649:	ff 75 f4             	pushl  -0xc(%ebp)
  80264c:	6a 00                	push   $0x0
  80264e:	e8 2b e8 ff ff       	call   800e7e <sys_page_unmap>
  802653:	83 c4 10             	add    $0x10,%esp
}
  802656:	89 d8                	mov    %ebx,%eax
  802658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5e                   	pop    %esi
  80265d:	5d                   	pop    %ebp
  80265e:	c3                   	ret    

0080265f <pipeisclosed>:
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802665:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802668:	50                   	push   %eax
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	e8 b9 f0 ff ff       	call   80172a <fd_lookup>
  802671:	83 c4 10             	add    $0x10,%esp
  802674:	85 c0                	test   %eax,%eax
  802676:	78 18                	js     802690 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802678:	83 ec 0c             	sub    $0xc,%esp
  80267b:	ff 75 f4             	pushl  -0xc(%ebp)
  80267e:	e8 3e f0 ff ff       	call   8016c1 <fd2data>
	return _pipeisclosed(fd, p);
  802683:	89 c2                	mov    %eax,%edx
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	e8 2f fd ff ff       	call   8023bc <_pipeisclosed>
  80268d:	83 c4 10             	add    $0x10,%esp
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
  802697:	c3                   	ret    

00802698 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802698:	55                   	push   %ebp
  802699:	89 e5                	mov    %esp,%ebp
  80269b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80269e:	68 9b 31 80 00       	push   $0x80319b
  8026a3:	ff 75 0c             	pushl  0xc(%ebp)
  8026a6:	e8 5c e3 ff ff       	call   800a07 <strcpy>
	return 0;
}
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <devcons_write>:
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	57                   	push   %edi
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026be:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026c3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026c9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026cc:	73 31                	jae    8026ff <devcons_write+0x4d>
		m = n - tot;
  8026ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026d1:	29 f3                	sub    %esi,%ebx
  8026d3:	83 fb 7f             	cmp    $0x7f,%ebx
  8026d6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026db:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	53                   	push   %ebx
  8026e2:	89 f0                	mov    %esi,%eax
  8026e4:	03 45 0c             	add    0xc(%ebp),%eax
  8026e7:	50                   	push   %eax
  8026e8:	57                   	push   %edi
  8026e9:	e8 a7 e4 ff ff       	call   800b95 <memmove>
		sys_cputs(buf, m);
  8026ee:	83 c4 08             	add    $0x8,%esp
  8026f1:	53                   	push   %ebx
  8026f2:	57                   	push   %edi
  8026f3:	e8 45 e6 ff ff       	call   800d3d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026f8:	01 de                	add    %ebx,%esi
  8026fa:	83 c4 10             	add    $0x10,%esp
  8026fd:	eb ca                	jmp    8026c9 <devcons_write+0x17>
}
  8026ff:	89 f0                	mov    %esi,%eax
  802701:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802704:	5b                   	pop    %ebx
  802705:	5e                   	pop    %esi
  802706:	5f                   	pop    %edi
  802707:	5d                   	pop    %ebp
  802708:	c3                   	ret    

00802709 <devcons_read>:
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 08             	sub    $0x8,%esp
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802714:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802718:	74 21                	je     80273b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80271a:	e8 3c e6 ff ff       	call   800d5b <sys_cgetc>
  80271f:	85 c0                	test   %eax,%eax
  802721:	75 07                	jne    80272a <devcons_read+0x21>
		sys_yield();
  802723:	e8 b2 e6 ff ff       	call   800dda <sys_yield>
  802728:	eb f0                	jmp    80271a <devcons_read+0x11>
	if (c < 0)
  80272a:	78 0f                	js     80273b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80272c:	83 f8 04             	cmp    $0x4,%eax
  80272f:	74 0c                	je     80273d <devcons_read+0x34>
	*(char*)vbuf = c;
  802731:	8b 55 0c             	mov    0xc(%ebp),%edx
  802734:	88 02                	mov    %al,(%edx)
	return 1;
  802736:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    
		return 0;
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	eb f7                	jmp    80273b <devcons_read+0x32>

00802744 <cputchar>:
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802750:	6a 01                	push   $0x1
  802752:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802755:	50                   	push   %eax
  802756:	e8 e2 e5 ff ff       	call   800d3d <sys_cputs>
}
  80275b:	83 c4 10             	add    $0x10,%esp
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <getchar>:
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802766:	6a 01                	push   $0x1
  802768:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80276b:	50                   	push   %eax
  80276c:	6a 00                	push   $0x0
  80276e:	e8 27 f2 ff ff       	call   80199a <read>
	if (r < 0)
  802773:	83 c4 10             	add    $0x10,%esp
  802776:	85 c0                	test   %eax,%eax
  802778:	78 06                	js     802780 <getchar+0x20>
	if (r < 1)
  80277a:	74 06                	je     802782 <getchar+0x22>
	return c;
  80277c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    
		return -E_EOF;
  802782:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802787:	eb f7                	jmp    802780 <getchar+0x20>

00802789 <iscons>:
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802792:	50                   	push   %eax
  802793:	ff 75 08             	pushl  0x8(%ebp)
  802796:	e8 8f ef ff ff       	call   80172a <fd_lookup>
  80279b:	83 c4 10             	add    $0x10,%esp
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	78 11                	js     8027b3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ab:	39 10                	cmp    %edx,(%eax)
  8027ad:	0f 94 c0             	sete   %al
  8027b0:	0f b6 c0             	movzbl %al,%eax
}
  8027b3:	c9                   	leave  
  8027b4:	c3                   	ret    

008027b5 <opencons>:
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027be:	50                   	push   %eax
  8027bf:	e8 14 ef ff ff       	call   8016d8 <fd_alloc>
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	78 3a                	js     802805 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 07 04 00 00       	push   $0x407
  8027d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d6:	6a 00                	push   $0x0
  8027d8:	e8 1c e6 ff ff       	call   800df9 <sys_page_alloc>
  8027dd:	83 c4 10             	add    $0x10,%esp
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	78 21                	js     802805 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ed:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027f9:	83 ec 0c             	sub    $0xc,%esp
  8027fc:	50                   	push   %eax
  8027fd:	e8 af ee ff ff       	call   8016b1 <fd2num>
  802802:	83 c4 10             	add    $0x10,%esp
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80280d:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802814:	74 0a                	je     802820 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	6a 07                	push   $0x7
  802825:	68 00 f0 bf ee       	push   $0xeebff000
  80282a:	6a 00                	push   $0x0
  80282c:	e8 c8 e5 ff ff       	call   800df9 <sys_page_alloc>
		if(r < 0)
  802831:	83 c4 10             	add    $0x10,%esp
  802834:	85 c0                	test   %eax,%eax
  802836:	78 2a                	js     802862 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802838:	83 ec 08             	sub    $0x8,%esp
  80283b:	68 76 28 80 00       	push   $0x802876
  802840:	6a 00                	push   $0x0
  802842:	e8 fd e6 ff ff       	call   800f44 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802847:	83 c4 10             	add    $0x10,%esp
  80284a:	85 c0                	test   %eax,%eax
  80284c:	79 c8                	jns    802816 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80284e:	83 ec 04             	sub    $0x4,%esp
  802851:	68 d8 31 80 00       	push   $0x8031d8
  802856:	6a 25                	push   $0x25
  802858:	68 14 32 80 00       	push   $0x803214
  80285d:	e8 50 d9 ff ff       	call   8001b2 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 a8 31 80 00       	push   $0x8031a8
  80286a:	6a 22                	push   $0x22
  80286c:	68 14 32 80 00       	push   $0x803214
  802871:	e8 3c d9 ff ff       	call   8001b2 <_panic>

00802876 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802876:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802877:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80287c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80287e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802881:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802885:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802889:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80288c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80288e:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802892:	83 c4 08             	add    $0x8,%esp
	popal
  802895:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802896:	83 c4 04             	add    $0x4,%esp
	popfl
  802899:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80289a:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80289b:	c3                   	ret    

0080289c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a2:	89 d0                	mov    %edx,%eax
  8028a4:	c1 e8 16             	shr    $0x16,%eax
  8028a7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b3:	f6 c1 01             	test   $0x1,%cl
  8028b6:	74 1d                	je     8028d5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028b8:	c1 ea 0c             	shr    $0xc,%edx
  8028bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c2:	f6 c2 01             	test   $0x1,%dl
  8028c5:	74 0e                	je     8028d5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028c7:	c1 ea 0c             	shr    $0xc,%edx
  8028ca:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d1:	ef 
  8028d2:	0f b7 c0             	movzwl %ax,%eax
}
  8028d5:	5d                   	pop    %ebp
  8028d6:	c3                   	ret    
  8028d7:	66 90                	xchg   %ax,%ax
  8028d9:	66 90                	xchg   %ax,%ax
  8028db:	66 90                	xchg   %ax,%ax
  8028dd:	66 90                	xchg   %ax,%ax
  8028df:	90                   	nop

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
