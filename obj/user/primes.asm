
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
  800047:	e8 da 15 00 00       	call   801626 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 50 80 00       	mov    0x805008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 a0 2b 80 00       	push   $0x802ba0
  800060:	e8 94 02 00 00       	call   8002f9 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 2a 13 00 00       	call   801394 <fork>
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
  80007b:	68 ac 2b 80 00       	push   $0x802bac
  800080:	6a 1a                	push   $0x1a
  800082:	68 b5 2b 80 00       	push   $0x802bb5
  800087:	e8 77 01 00 00       	call   800203 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 f8 15 00 00       	call   80168f <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 7f 15 00 00       	call   801626 <ipc_recv>
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
  8000ba:	e8 d5 12 00 00       	call   801394 <fork>
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
  8000d2:	e8 b8 15 00 00       	call   80168f <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 ac 2b 80 00       	push   $0x802bac
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 b5 2b 80 00       	push   $0x802bb5
  8000ec:	e8 12 01 00 00       	call   800203 <_panic>
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
  800109:	e8 fe 0c 00 00       	call   800e0c <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80016d:	a1 08 50 80 00       	mov    0x805008,%eax
  800172:	8b 40 48             	mov    0x48(%eax),%eax
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	50                   	push   %eax
  800179:	68 c3 2b 80 00       	push   $0x802bc3
  80017e:	e8 76 01 00 00       	call   8002f9 <cprintf>
	cprintf("before umain\n");
  800183:	c7 04 24 e1 2b 80 00 	movl   $0x802be1,(%esp)
  80018a:	e8 6a 01 00 00       	call   8002f9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 18 ff ff ff       	call   8000b5 <umain>
	cprintf("after umain\n");
  80019d:	c7 04 24 ef 2b 80 00 	movl   $0x802bef,(%esp)
  8001a4:	e8 50 01 00 00       	call   8002f9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	50                   	push   %eax
  8001b5:	68 fc 2b 80 00       	push   $0x802bfc
  8001ba:	e8 3a 01 00 00       	call   8002f9 <cprintf>
	// exit gracefully
	exit();
  8001bf:	e8 0b 00 00 00       	call   8001cf <exit>
}
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5f                   	pop    %edi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    

008001cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8001da:	8b 40 48             	mov    0x48(%eax),%eax
  8001dd:	68 28 2c 80 00       	push   $0x802c28
  8001e2:	50                   	push   %eax
  8001e3:	68 1b 2c 80 00       	push   $0x802c1b
  8001e8:	e8 0c 01 00 00       	call   8002f9 <cprintf>
	close_all();
  8001ed:	e8 08 17 00 00       	call   8018fa <close_all>
	sys_env_destroy(0);
  8001f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001f9:	e8 cd 0b 00 00       	call   800dcb <sys_env_destroy>
}
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	c9                   	leave  
  800202:	c3                   	ret    

00800203 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800208:	a1 08 50 80 00       	mov    0x805008,%eax
  80020d:	8b 40 48             	mov    0x48(%eax),%eax
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	68 54 2c 80 00       	push   $0x802c54
  800218:	50                   	push   %eax
  800219:	68 1b 2c 80 00       	push   $0x802c1b
  80021e:	e8 d6 00 00 00       	call   8002f9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800223:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800226:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80022c:	e8 db 0b 00 00       	call   800e0c <sys_getenvid>
  800231:	83 c4 04             	add    $0x4,%esp
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	56                   	push   %esi
  80023b:	50                   	push   %eax
  80023c:	68 30 2c 80 00       	push   $0x802c30
  800241:	e8 b3 00 00 00       	call   8002f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800246:	83 c4 18             	add    $0x18,%esp
  800249:	53                   	push   %ebx
  80024a:	ff 75 10             	pushl  0x10(%ebp)
  80024d:	e8 56 00 00 00       	call   8002a8 <vcprintf>
	cprintf("\n");
  800252:	c7 04 24 df 2b 80 00 	movl   $0x802bdf,(%esp)
  800259:	e8 9b 00 00 00       	call   8002f9 <cprintf>
  80025e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800261:	cc                   	int3   
  800262:	eb fd                	jmp    800261 <_panic+0x5e>

00800264 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	53                   	push   %ebx
  800268:	83 ec 04             	sub    $0x4,%esp
  80026b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80026e:	8b 13                	mov    (%ebx),%edx
  800270:	8d 42 01             	lea    0x1(%edx),%eax
  800273:	89 03                	mov    %eax,(%ebx)
  800275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800278:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80027c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800281:	74 09                	je     80028c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800283:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800287:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	68 ff 00 00 00       	push   $0xff
  800294:	8d 43 08             	lea    0x8(%ebx),%eax
  800297:	50                   	push   %eax
  800298:	e8 f1 0a 00 00       	call   800d8e <sys_cputs>
		b->idx = 0;
  80029d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	eb db                	jmp    800283 <putch+0x1f>

008002a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b8:	00 00 00 
	b.cnt = 0;
  8002bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c5:	ff 75 0c             	pushl  0xc(%ebp)
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	68 64 02 80 00       	push   $0x800264
  8002d7:	e8 4a 01 00 00       	call   800426 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002dc:	83 c4 08             	add    $0x8,%esp
  8002df:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002eb:	50                   	push   %eax
  8002ec:	e8 9d 0a 00 00       	call   800d8e <sys_cputs>

	return b.cnt;
}
  8002f1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ff:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800302:	50                   	push   %eax
  800303:	ff 75 08             	pushl  0x8(%ebp)
  800306:	e8 9d ff ff ff       	call   8002a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 1c             	sub    $0x1c,%esp
  800316:	89 c6                	mov    %eax,%esi
  800318:	89 d7                	mov    %edx,%edi
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800320:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800323:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800326:	8b 45 10             	mov    0x10(%ebp),%eax
  800329:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80032c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800330:	74 2c                	je     80035e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800335:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80033c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80033f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800342:	39 c2                	cmp    %eax,%edx
  800344:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800347:	73 43                	jae    80038c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800349:	83 eb 01             	sub    $0x1,%ebx
  80034c:	85 db                	test   %ebx,%ebx
  80034e:	7e 6c                	jle    8003bc <printnum+0xaf>
				putch(padc, putdat);
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	57                   	push   %edi
  800354:	ff 75 18             	pushl  0x18(%ebp)
  800357:	ff d6                	call   *%esi
  800359:	83 c4 10             	add    $0x10,%esp
  80035c:	eb eb                	jmp    800349 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	6a 20                	push   $0x20
  800363:	6a 00                	push   $0x0
  800365:	50                   	push   %eax
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	89 fa                	mov    %edi,%edx
  80036e:	89 f0                	mov    %esi,%eax
  800370:	e8 98 ff ff ff       	call   80030d <printnum>
		while (--width > 0)
  800375:	83 c4 20             	add    $0x20,%esp
  800378:	83 eb 01             	sub    $0x1,%ebx
  80037b:	85 db                	test   %ebx,%ebx
  80037d:	7e 65                	jle    8003e4 <printnum+0xd7>
			putch(padc, putdat);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	57                   	push   %edi
  800383:	6a 20                	push   $0x20
  800385:	ff d6                	call   *%esi
  800387:	83 c4 10             	add    $0x10,%esp
  80038a:	eb ec                	jmp    800378 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80038c:	83 ec 0c             	sub    $0xc,%esp
  80038f:	ff 75 18             	pushl  0x18(%ebp)
  800392:	83 eb 01             	sub    $0x1,%ebx
  800395:	53                   	push   %ebx
  800396:	50                   	push   %eax
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	ff 75 dc             	pushl  -0x24(%ebp)
  80039d:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a6:	e8 a5 25 00 00       	call   802950 <__udivdi3>
  8003ab:	83 c4 18             	add    $0x18,%esp
  8003ae:	52                   	push   %edx
  8003af:	50                   	push   %eax
  8003b0:	89 fa                	mov    %edi,%edx
  8003b2:	89 f0                	mov    %esi,%eax
  8003b4:	e8 54 ff ff ff       	call   80030d <printnum>
  8003b9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	57                   	push   %edi
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cf:	e8 8c 26 00 00       	call   802a60 <__umoddi3>
  8003d4:	83 c4 14             	add    $0x14,%esp
  8003d7:	0f be 80 5b 2c 80 00 	movsbl 0x802c5b(%eax),%eax
  8003de:	50                   	push   %eax
  8003df:	ff d6                	call   *%esi
  8003e1:	83 c4 10             	add    $0x10,%esp
	}
}
  8003e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e7:	5b                   	pop    %ebx
  8003e8:	5e                   	pop    %esi
  8003e9:	5f                   	pop    %edi
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f6:	8b 10                	mov    (%eax),%edx
  8003f8:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fb:	73 0a                	jae    800407 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003fd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800400:	89 08                	mov    %ecx,(%eax)
  800402:	8b 45 08             	mov    0x8(%ebp),%eax
  800405:	88 02                	mov    %al,(%edx)
}
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <printfmt>:
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800412:	50                   	push   %eax
  800413:	ff 75 10             	pushl  0x10(%ebp)
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	e8 05 00 00 00       	call   800426 <vprintfmt>
}
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <vprintfmt>:
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	57                   	push   %edi
  80042a:	56                   	push   %esi
  80042b:	53                   	push   %ebx
  80042c:	83 ec 3c             	sub    $0x3c,%esp
  80042f:	8b 75 08             	mov    0x8(%ebp),%esi
  800432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800435:	8b 7d 10             	mov    0x10(%ebp),%edi
  800438:	e9 32 04 00 00       	jmp    80086f <vprintfmt+0x449>
		padc = ' ';
  80043d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800441:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800448:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80044f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800456:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80045d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800464:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8d 47 01             	lea    0x1(%edi),%eax
  80046c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046f:	0f b6 17             	movzbl (%edi),%edx
  800472:	8d 42 dd             	lea    -0x23(%edx),%eax
  800475:	3c 55                	cmp    $0x55,%al
  800477:	0f 87 12 05 00 00    	ja     80098f <vprintfmt+0x569>
  80047d:	0f b6 c0             	movzbl %al,%eax
  800480:	ff 24 85 40 2e 80 00 	jmp    *0x802e40(,%eax,4)
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80048a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80048e:	eb d9                	jmp    800469 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800493:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800497:	eb d0                	jmp    800469 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800499:	0f b6 d2             	movzbl %dl,%edx
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80049f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a7:	eb 03                	jmp    8004ac <vprintfmt+0x86>
  8004a9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004b3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004b9:	83 fe 09             	cmp    $0x9,%esi
  8004bc:	76 eb                	jbe    8004a9 <vprintfmt+0x83>
  8004be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c4:	eb 14                	jmp    8004da <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8d 40 04             	lea    0x4(%eax),%eax
  8004d4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004de:	79 89                	jns    800469 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004ed:	e9 77 ff ff ff       	jmp    800469 <vprintfmt+0x43>
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	0f 48 c1             	cmovs  %ecx,%eax
  8004fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800500:	e9 64 ff ff ff       	jmp    800469 <vprintfmt+0x43>
  800505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800508:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80050f:	e9 55 ff ff ff       	jmp    800469 <vprintfmt+0x43>
			lflag++;
  800514:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800518:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051b:	e9 49 ff ff ff       	jmp    800469 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 78 04             	lea    0x4(%eax),%edi
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	53                   	push   %ebx
  80052a:	ff 30                	pushl  (%eax)
  80052c:	ff d6                	call   *%esi
			break;
  80052e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800531:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800534:	e9 33 03 00 00       	jmp    80086c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8d 78 04             	lea    0x4(%eax),%edi
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	99                   	cltd   
  800542:	31 d0                	xor    %edx,%eax
  800544:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800546:	83 f8 11             	cmp    $0x11,%eax
  800549:	7f 23                	jg     80056e <vprintfmt+0x148>
  80054b:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	74 18                	je     80056e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800556:	52                   	push   %edx
  800557:	68 cd 31 80 00       	push   $0x8031cd
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 a6 fe ff ff       	call   800409 <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
  800569:	e9 fe 02 00 00       	jmp    80086c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056e:	50                   	push   %eax
  80056f:	68 73 2c 80 00       	push   $0x802c73
  800574:	53                   	push   %ebx
  800575:	56                   	push   %esi
  800576:	e8 8e fe ff ff       	call   800409 <printfmt>
  80057b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800581:	e9 e6 02 00 00       	jmp    80086c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	83 c0 04             	add    $0x4,%eax
  80058c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800594:	85 c9                	test   %ecx,%ecx
  800596:	b8 6c 2c 80 00       	mov    $0x802c6c,%eax
  80059b:	0f 45 c1             	cmovne %ecx,%eax
  80059e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a5:	7e 06                	jle    8005ad <vprintfmt+0x187>
  8005a7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005ab:	75 0d                	jne    8005ba <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b0:	89 c7                	mov    %eax,%edi
  8005b2:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b8:	eb 53                	jmp    80060d <vprintfmt+0x1e7>
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c0:	50                   	push   %eax
  8005c1:	e8 71 04 00 00       	call   800a37 <strnlen>
  8005c6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c9:	29 c1                	sub    %eax,%ecx
  8005cb:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005d3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005da:	eb 0f                	jmp    8005eb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005dc:	83 ec 08             	sub    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e5:	83 ef 01             	sub    $0x1,%edi
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	85 ff                	test   %edi,%edi
  8005ed:	7f ed                	jg     8005dc <vprintfmt+0x1b6>
  8005ef:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005f2:	85 c9                	test   %ecx,%ecx
  8005f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f9:	0f 49 c1             	cmovns %ecx,%eax
  8005fc:	29 c1                	sub    %eax,%ecx
  8005fe:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800601:	eb aa                	jmp    8005ad <vprintfmt+0x187>
					putch(ch, putdat);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	53                   	push   %ebx
  800607:	52                   	push   %edx
  800608:	ff d6                	call   *%esi
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800610:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800612:	83 c7 01             	add    $0x1,%edi
  800615:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800619:	0f be d0             	movsbl %al,%edx
  80061c:	85 d2                	test   %edx,%edx
  80061e:	74 4b                	je     80066b <vprintfmt+0x245>
  800620:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800624:	78 06                	js     80062c <vprintfmt+0x206>
  800626:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062a:	78 1e                	js     80064a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80062c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800630:	74 d1                	je     800603 <vprintfmt+0x1dd>
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 e8 20             	sub    $0x20,%eax
  800638:	83 f8 5e             	cmp    $0x5e,%eax
  80063b:	76 c6                	jbe    800603 <vprintfmt+0x1dd>
					putch('?', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 3f                	push   $0x3f
  800643:	ff d6                	call   *%esi
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	eb c3                	jmp    80060d <vprintfmt+0x1e7>
  80064a:	89 cf                	mov    %ecx,%edi
  80064c:	eb 0e                	jmp    80065c <vprintfmt+0x236>
				putch(' ', putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	6a 20                	push   $0x20
  800654:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800656:	83 ef 01             	sub    $0x1,%edi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	85 ff                	test   %edi,%edi
  80065e:	7f ee                	jg     80064e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800660:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
  800666:	e9 01 02 00 00       	jmp    80086c <vprintfmt+0x446>
  80066b:	89 cf                	mov    %ecx,%edi
  80066d:	eb ed                	jmp    80065c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80066f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800672:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800679:	e9 eb fd ff ff       	jmp    800469 <vprintfmt+0x43>
	if (lflag >= 2)
  80067e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800682:	7f 21                	jg     8006a5 <vprintfmt+0x27f>
	else if (lflag)
  800684:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800688:	74 68                	je     8006f2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800692:	89 c1                	mov    %eax,%ecx
  800694:	c1 f9 1f             	sar    $0x1f,%ecx
  800697:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a3:	eb 17                	jmp    8006bc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 40 08             	lea    0x8(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006cc:	78 3f                	js     80070d <vprintfmt+0x2e7>
			base = 10;
  8006ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006d3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006d7:	0f 84 71 01 00 00    	je     80084e <vprintfmt+0x428>
				putch('+', putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 2b                	push   $0x2b
  8006e3:	ff d6                	call   *%esi
  8006e5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ed:	e9 5c 01 00 00       	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006fa:	89 c1                	mov    %eax,%ecx
  8006fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	eb af                	jmp    8006bc <vprintfmt+0x296>
				putch('-', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 2d                	push   $0x2d
  800713:	ff d6                	call   *%esi
				num = -(long long) num;
  800715:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800718:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80071b:	f7 d8                	neg    %eax
  80071d:	83 d2 00             	adc    $0x0,%edx
  800720:	f7 da                	neg    %edx
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80072b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800730:	e9 19 01 00 00       	jmp    80084e <vprintfmt+0x428>
	if (lflag >= 2)
  800735:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800739:	7f 29                	jg     800764 <vprintfmt+0x33e>
	else if (lflag)
  80073b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073f:	74 44                	je     800785 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075f:	e9 ea 00 00 00       	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800780:	e9 c9 00 00 00       	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	ba 00 00 00 00       	mov    $0x0,%edx
  80078f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800792:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 40 04             	lea    0x4(%eax),%eax
  80079b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a3:	e9 a6 00 00 00       	jmp    80084e <vprintfmt+0x428>
			putch('0', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 30                	push   $0x30
  8007ae:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007b0:	83 c4 10             	add    $0x10,%esp
  8007b3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b7:	7f 26                	jg     8007df <vprintfmt+0x3b9>
	else if (lflag)
  8007b9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007bd:	74 3e                	je     8007fd <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 04             	lea    0x4(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007dd:	eb 6f                	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8d 40 08             	lea    0x8(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8007fb:	eb 51                	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8b 00                	mov    (%eax),%eax
  800802:	ba 00 00 00 00       	mov    $0x0,%edx
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800816:	b8 08 00 00 00       	mov    $0x8,%eax
  80081b:	eb 31                	jmp    80084e <vprintfmt+0x428>
			putch('0', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 30                	push   $0x30
  800823:	ff d6                	call   *%esi
			putch('x', putdat);
  800825:	83 c4 08             	add    $0x8,%esp
  800828:	53                   	push   %ebx
  800829:	6a 78                	push   $0x78
  80082b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80083d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	8d 40 04             	lea    0x4(%eax),%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800849:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80084e:	83 ec 0c             	sub    $0xc,%esp
  800851:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800855:	52                   	push   %edx
  800856:	ff 75 e0             	pushl  -0x20(%ebp)
  800859:	50                   	push   %eax
  80085a:	ff 75 dc             	pushl  -0x24(%ebp)
  80085d:	ff 75 d8             	pushl  -0x28(%ebp)
  800860:	89 da                	mov    %ebx,%edx
  800862:	89 f0                	mov    %esi,%eax
  800864:	e8 a4 fa ff ff       	call   80030d <printnum>
			break;
  800869:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80086c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80086f:	83 c7 01             	add    $0x1,%edi
  800872:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800876:	83 f8 25             	cmp    $0x25,%eax
  800879:	0f 84 be fb ff ff    	je     80043d <vprintfmt+0x17>
			if (ch == '\0')
  80087f:	85 c0                	test   %eax,%eax
  800881:	0f 84 28 01 00 00    	je     8009af <vprintfmt+0x589>
			putch(ch, putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	53                   	push   %ebx
  80088b:	50                   	push   %eax
  80088c:	ff d6                	call   *%esi
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	eb dc                	jmp    80086f <vprintfmt+0x449>
	if (lflag >= 2)
  800893:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800897:	7f 26                	jg     8008bf <vprintfmt+0x499>
	else if (lflag)
  800899:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80089d:	74 41                	je     8008e0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ac:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 40 04             	lea    0x4(%eax),%eax
  8008b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008bd:	eb 8f                	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8b 50 04             	mov    0x4(%eax),%edx
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 08             	lea    0x8(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008db:	e9 6e ff ff ff       	jmp    80084e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	8d 40 04             	lea    0x4(%eax),%eax
  8008f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8008fe:	e9 4b ff ff ff       	jmp    80084e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	85 c0                	test   %eax,%eax
  800913:	74 14                	je     800929 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800915:	8b 13                	mov    (%ebx),%edx
  800917:	83 fa 7f             	cmp    $0x7f,%edx
  80091a:	7f 37                	jg     800953 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80091c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80091e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
  800924:	e9 43 ff ff ff       	jmp    80086c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800929:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092e:	bf 91 2d 80 00       	mov    $0x802d91,%edi
							putch(ch, putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	53                   	push   %ebx
  800937:	50                   	push   %eax
  800938:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80093a:	83 c7 01             	add    $0x1,%edi
  80093d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 eb                	jne    800933 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800948:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
  80094e:	e9 19 ff ff ff       	jmp    80086c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800953:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800955:	b8 0a 00 00 00       	mov    $0xa,%eax
  80095a:	bf c9 2d 80 00       	mov    $0x802dc9,%edi
							putch(ch, putdat);
  80095f:	83 ec 08             	sub    $0x8,%esp
  800962:	53                   	push   %ebx
  800963:	50                   	push   %eax
  800964:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800966:	83 c7 01             	add    $0x1,%edi
  800969:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	85 c0                	test   %eax,%eax
  800972:	75 eb                	jne    80095f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800974:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
  80097a:	e9 ed fe ff ff       	jmp    80086c <vprintfmt+0x446>
			putch(ch, putdat);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	53                   	push   %ebx
  800983:	6a 25                	push   $0x25
  800985:	ff d6                	call   *%esi
			break;
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	e9 dd fe ff ff       	jmp    80086c <vprintfmt+0x446>
			putch('%', putdat);
  80098f:	83 ec 08             	sub    $0x8,%esp
  800992:	53                   	push   %ebx
  800993:	6a 25                	push   $0x25
  800995:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	89 f8                	mov    %edi,%eax
  80099c:	eb 03                	jmp    8009a1 <vprintfmt+0x57b>
  80099e:	83 e8 01             	sub    $0x1,%eax
  8009a1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a5:	75 f7                	jne    80099e <vprintfmt+0x578>
  8009a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009aa:	e9 bd fe ff ff       	jmp    80086c <vprintfmt+0x446>
}
  8009af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 18             	sub    $0x18,%esp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d4:	85 c0                	test   %eax,%eax
  8009d6:	74 26                	je     8009fe <vsnprintf+0x47>
  8009d8:	85 d2                	test   %edx,%edx
  8009da:	7e 22                	jle    8009fe <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009dc:	ff 75 14             	pushl  0x14(%ebp)
  8009df:	ff 75 10             	pushl  0x10(%ebp)
  8009e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e5:	50                   	push   %eax
  8009e6:	68 ec 03 80 00       	push   $0x8003ec
  8009eb:	e8 36 fa ff ff       	call   800426 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    
		return -E_INVAL;
  8009fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a03:	eb f7                	jmp    8009fc <vsnprintf+0x45>

00800a05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a0b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a0e:	50                   	push   %eax
  800a0f:	ff 75 10             	pushl  0x10(%ebp)
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	ff 75 08             	pushl  0x8(%ebp)
  800a18:	e8 9a ff ff ff       	call   8009b7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a2e:	74 05                	je     800a35 <strlen+0x16>
		n++;
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	eb f5                	jmp    800a2a <strlen+0xb>
	return n;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a40:	ba 00 00 00 00       	mov    $0x0,%edx
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	74 0d                	je     800a56 <strnlen+0x1f>
  800a49:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a4d:	74 05                	je     800a54 <strnlen+0x1d>
		n++;
  800a4f:	83 c2 01             	add    $0x1,%edx
  800a52:	eb f1                	jmp    800a45 <strnlen+0xe>
  800a54:	89 d0                	mov    %edx,%eax
	return n;
}
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	53                   	push   %ebx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a6b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a6e:	83 c2 01             	add    $0x1,%edx
  800a71:	84 c9                	test   %cl,%cl
  800a73:	75 f2                	jne    800a67 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a75:	5b                   	pop    %ebx
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	53                   	push   %ebx
  800a7c:	83 ec 10             	sub    $0x10,%esp
  800a7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a82:	53                   	push   %ebx
  800a83:	e8 97 ff ff ff       	call   800a1f <strlen>
  800a88:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	01 d8                	add    %ebx,%eax
  800a90:	50                   	push   %eax
  800a91:	e8 c2 ff ff ff       	call   800a58 <strcpy>
	return dst;
}
  800a96:	89 d8                	mov    %ebx,%eax
  800a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 c6                	mov    %eax,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aad:	89 c2                	mov    %eax,%edx
  800aaf:	39 f2                	cmp    %esi,%edx
  800ab1:	74 11                	je     800ac4 <strncpy+0x27>
		*dst++ = *src;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	0f b6 19             	movzbl (%ecx),%ebx
  800ab9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800abc:	80 fb 01             	cmp    $0x1,%bl
  800abf:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ac2:	eb eb                	jmp    800aaf <strncpy+0x12>
	}
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad3:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad8:	85 d2                	test   %edx,%edx
  800ada:	74 21                	je     800afd <strlcpy+0x35>
  800adc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ae0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 14                	je     800afa <strlcpy+0x32>
  800ae6:	0f b6 19             	movzbl (%ecx),%ebx
  800ae9:	84 db                	test   %bl,%bl
  800aeb:	74 0b                	je     800af8 <strlcpy+0x30>
			*dst++ = *src++;
  800aed:	83 c1 01             	add    $0x1,%ecx
  800af0:	83 c2 01             	add    $0x1,%edx
  800af3:	88 5a ff             	mov    %bl,-0x1(%edx)
  800af6:	eb ea                	jmp    800ae2 <strlcpy+0x1a>
  800af8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	29 f0                	sub    %esi,%eax
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b0c:	0f b6 01             	movzbl (%ecx),%eax
  800b0f:	84 c0                	test   %al,%al
  800b11:	74 0c                	je     800b1f <strcmp+0x1c>
  800b13:	3a 02                	cmp    (%edx),%al
  800b15:	75 08                	jne    800b1f <strcmp+0x1c>
		p++, q++;
  800b17:	83 c1 01             	add    $0x1,%ecx
  800b1a:	83 c2 01             	add    $0x1,%edx
  800b1d:	eb ed                	jmp    800b0c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1f:	0f b6 c0             	movzbl %al,%eax
  800b22:	0f b6 12             	movzbl (%edx),%edx
  800b25:	29 d0                	sub    %edx,%eax
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	53                   	push   %ebx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	89 c3                	mov    %eax,%ebx
  800b35:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b38:	eb 06                	jmp    800b40 <strncmp+0x17>
		n--, p++, q++;
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b40:	39 d8                	cmp    %ebx,%eax
  800b42:	74 16                	je     800b5a <strncmp+0x31>
  800b44:	0f b6 08             	movzbl (%eax),%ecx
  800b47:	84 c9                	test   %cl,%cl
  800b49:	74 04                	je     800b4f <strncmp+0x26>
  800b4b:	3a 0a                	cmp    (%edx),%cl
  800b4d:	74 eb                	je     800b3a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4f:	0f b6 00             	movzbl (%eax),%eax
  800b52:	0f b6 12             	movzbl (%edx),%edx
  800b55:	29 d0                	sub    %edx,%eax
}
  800b57:	5b                   	pop    %ebx
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    
		return 0;
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5f:	eb f6                	jmp    800b57 <strncmp+0x2e>

00800b61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6b:	0f b6 10             	movzbl (%eax),%edx
  800b6e:	84 d2                	test   %dl,%dl
  800b70:	74 09                	je     800b7b <strchr+0x1a>
		if (*s == c)
  800b72:	38 ca                	cmp    %cl,%dl
  800b74:	74 0a                	je     800b80 <strchr+0x1f>
	for (; *s; s++)
  800b76:	83 c0 01             	add    $0x1,%eax
  800b79:	eb f0                	jmp    800b6b <strchr+0xa>
			return (char *) s;
	return 0;
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8f:	38 ca                	cmp    %cl,%dl
  800b91:	74 09                	je     800b9c <strfind+0x1a>
  800b93:	84 d2                	test   %dl,%dl
  800b95:	74 05                	je     800b9c <strfind+0x1a>
	for (; *s; s++)
  800b97:	83 c0 01             	add    $0x1,%eax
  800b9a:	eb f0                	jmp    800b8c <strfind+0xa>
			break;
	return (char *) s;
}
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800baa:	85 c9                	test   %ecx,%ecx
  800bac:	74 31                	je     800bdf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bae:	89 f8                	mov    %edi,%eax
  800bb0:	09 c8                	or     %ecx,%eax
  800bb2:	a8 03                	test   $0x3,%al
  800bb4:	75 23                	jne    800bd9 <memset+0x3b>
		c &= 0xFF;
  800bb6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bba:	89 d3                	mov    %edx,%ebx
  800bbc:	c1 e3 08             	shl    $0x8,%ebx
  800bbf:	89 d0                	mov    %edx,%eax
  800bc1:	c1 e0 18             	shl    $0x18,%eax
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	c1 e6 10             	shl    $0x10,%esi
  800bc9:	09 f0                	or     %esi,%eax
  800bcb:	09 c2                	or     %eax,%edx
  800bcd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd2:	89 d0                	mov    %edx,%eax
  800bd4:	fc                   	cld    
  800bd5:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd7:	eb 06                	jmp    800bdf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	fc                   	cld    
  800bdd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdf:	89 f8                	mov    %edi,%eax
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf4:	39 c6                	cmp    %eax,%esi
  800bf6:	73 32                	jae    800c2a <memmove+0x44>
  800bf8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfb:	39 c2                	cmp    %eax,%edx
  800bfd:	76 2b                	jbe    800c2a <memmove+0x44>
		s += n;
		d += n;
  800bff:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c02:	89 fe                	mov    %edi,%esi
  800c04:	09 ce                	or     %ecx,%esi
  800c06:	09 d6                	or     %edx,%esi
  800c08:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0e:	75 0e                	jne    800c1e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c10:	83 ef 04             	sub    $0x4,%edi
  800c13:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c16:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c19:	fd                   	std    
  800c1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1c:	eb 09                	jmp    800c27 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1e:	83 ef 01             	sub    $0x1,%edi
  800c21:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c24:	fd                   	std    
  800c25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c27:	fc                   	cld    
  800c28:	eb 1a                	jmp    800c44 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2a:	89 c2                	mov    %eax,%edx
  800c2c:	09 ca                	or     %ecx,%edx
  800c2e:	09 f2                	or     %esi,%edx
  800c30:	f6 c2 03             	test   $0x3,%dl
  800c33:	75 0a                	jne    800c3f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c38:	89 c7                	mov    %eax,%edi
  800c3a:	fc                   	cld    
  800c3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3d:	eb 05                	jmp    800c44 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	fc                   	cld    
  800c42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c4e:	ff 75 10             	pushl  0x10(%ebp)
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	ff 75 08             	pushl  0x8(%ebp)
  800c57:	e8 8a ff ff ff       	call   800be6 <memmove>
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	56                   	push   %esi
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c69:	89 c6                	mov    %eax,%esi
  800c6b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6e:	39 f0                	cmp    %esi,%eax
  800c70:	74 1c                	je     800c8e <memcmp+0x30>
		if (*s1 != *s2)
  800c72:	0f b6 08             	movzbl (%eax),%ecx
  800c75:	0f b6 1a             	movzbl (%edx),%ebx
  800c78:	38 d9                	cmp    %bl,%cl
  800c7a:	75 08                	jne    800c84 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c7c:	83 c0 01             	add    $0x1,%eax
  800c7f:	83 c2 01             	add    $0x1,%edx
  800c82:	eb ea                	jmp    800c6e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c84:	0f b6 c1             	movzbl %cl,%eax
  800c87:	0f b6 db             	movzbl %bl,%ebx
  800c8a:	29 d8                	sub    %ebx,%eax
  800c8c:	eb 05                	jmp    800c93 <memcmp+0x35>
	}

	return 0;
  800c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca0:	89 c2                	mov    %eax,%edx
  800ca2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ca5:	39 d0                	cmp    %edx,%eax
  800ca7:	73 09                	jae    800cb2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ca9:	38 08                	cmp    %cl,(%eax)
  800cab:	74 05                	je     800cb2 <memfind+0x1b>
	for (; s < ends; s++)
  800cad:	83 c0 01             	add    $0x1,%eax
  800cb0:	eb f3                	jmp    800ca5 <memfind+0xe>
			break;
	return (void *) s;
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc0:	eb 03                	jmp    800cc5 <strtol+0x11>
		s++;
  800cc2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cc5:	0f b6 01             	movzbl (%ecx),%eax
  800cc8:	3c 20                	cmp    $0x20,%al
  800cca:	74 f6                	je     800cc2 <strtol+0xe>
  800ccc:	3c 09                	cmp    $0x9,%al
  800cce:	74 f2                	je     800cc2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cd0:	3c 2b                	cmp    $0x2b,%al
  800cd2:	74 2a                	je     800cfe <strtol+0x4a>
	int neg = 0;
  800cd4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cd9:	3c 2d                	cmp    $0x2d,%al
  800cdb:	74 2b                	je     800d08 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cdd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ce3:	75 0f                	jne    800cf4 <strtol+0x40>
  800ce5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ce8:	74 28                	je     800d12 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cea:	85 db                	test   %ebx,%ebx
  800cec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf1:	0f 44 d8             	cmove  %eax,%ebx
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cfc:	eb 50                	jmp    800d4e <strtol+0x9a>
		s++;
  800cfe:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d01:	bf 00 00 00 00       	mov    $0x0,%edi
  800d06:	eb d5                	jmp    800cdd <strtol+0x29>
		s++, neg = 1;
  800d08:	83 c1 01             	add    $0x1,%ecx
  800d0b:	bf 01 00 00 00       	mov    $0x1,%edi
  800d10:	eb cb                	jmp    800cdd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d12:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d16:	74 0e                	je     800d26 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	75 d8                	jne    800cf4 <strtol+0x40>
		s++, base = 8;
  800d1c:	83 c1 01             	add    $0x1,%ecx
  800d1f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d24:	eb ce                	jmp    800cf4 <strtol+0x40>
		s += 2, base = 16;
  800d26:	83 c1 02             	add    $0x2,%ecx
  800d29:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d2e:	eb c4                	jmp    800cf4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d30:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d33:	89 f3                	mov    %esi,%ebx
  800d35:	80 fb 19             	cmp    $0x19,%bl
  800d38:	77 29                	ja     800d63 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d3a:	0f be d2             	movsbl %dl,%edx
  800d3d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d40:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d43:	7d 30                	jge    800d75 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d45:	83 c1 01             	add    $0x1,%ecx
  800d48:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d4e:	0f b6 11             	movzbl (%ecx),%edx
  800d51:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d54:	89 f3                	mov    %esi,%ebx
  800d56:	80 fb 09             	cmp    $0x9,%bl
  800d59:	77 d5                	ja     800d30 <strtol+0x7c>
			dig = *s - '0';
  800d5b:	0f be d2             	movsbl %dl,%edx
  800d5e:	83 ea 30             	sub    $0x30,%edx
  800d61:	eb dd                	jmp    800d40 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d63:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d66:	89 f3                	mov    %esi,%ebx
  800d68:	80 fb 19             	cmp    $0x19,%bl
  800d6b:	77 08                	ja     800d75 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d6d:	0f be d2             	movsbl %dl,%edx
  800d70:	83 ea 37             	sub    $0x37,%edx
  800d73:	eb cb                	jmp    800d40 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d79:	74 05                	je     800d80 <strtol+0xcc>
		*endptr = (char *) s;
  800d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d80:	89 c2                	mov    %eax,%edx
  800d82:	f7 da                	neg    %edx
  800d84:	85 ff                	test   %edi,%edi
  800d86:	0f 45 c2             	cmovne %edx,%eax
}
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	89 c3                	mov    %eax,%ebx
  800da1:	89 c7                	mov    %eax,%edi
  800da3:	89 c6                	mov    %eax,%esi
  800da5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_cgetc>:

int
sys_cgetc(void)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db2:	ba 00 00 00 00       	mov    $0x0,%edx
  800db7:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbc:	89 d1                	mov    %edx,%ecx
  800dbe:	89 d3                	mov    %edx,%ebx
  800dc0:	89 d7                	mov    %edx,%edi
  800dc2:	89 d6                	mov    %edx,%esi
  800dc4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	b8 03 00 00 00       	mov    $0x3,%eax
  800de1:	89 cb                	mov    %ecx,%ebx
  800de3:	89 cf                	mov    %ecx,%edi
  800de5:	89 ce                	mov    %ecx,%esi
  800de7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 03                	push   $0x3
  800dfb:	68 e8 2f 80 00       	push   $0x802fe8
  800e00:	6a 43                	push   $0x43
  800e02:	68 05 30 80 00       	push   $0x803005
  800e07:	e8 f7 f3 ff ff       	call   800203 <_panic>

00800e0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e12:	ba 00 00 00 00       	mov    $0x0,%edx
  800e17:	b8 02 00 00 00       	mov    $0x2,%eax
  800e1c:	89 d1                	mov    %edx,%ecx
  800e1e:	89 d3                	mov    %edx,%ebx
  800e20:	89 d7                	mov    %edx,%edi
  800e22:	89 d6                	mov    %edx,%esi
  800e24:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <sys_yield>:

void
sys_yield(void)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e3b:	89 d1                	mov    %edx,%ecx
  800e3d:	89 d3                	mov    %edx,%ebx
  800e3f:	89 d7                	mov    %edx,%edi
  800e41:	89 d6                	mov    %edx,%esi
  800e43:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    

00800e4a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e53:	be 00 00 00 00       	mov    $0x0,%esi
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	b8 04 00 00 00       	mov    $0x4,%eax
  800e63:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e66:	89 f7                	mov    %esi,%edi
  800e68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7f 08                	jg     800e76 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 04                	push   $0x4
  800e7c:	68 e8 2f 80 00       	push   $0x802fe8
  800e81:	6a 43                	push   $0x43
  800e83:	68 05 30 80 00       	push   $0x803005
  800e88:	e8 76 f3 ff ff       	call   800203 <_panic>

00800e8d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea7:	8b 75 18             	mov    0x18(%ebp),%esi
  800eaa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7f 08                	jg     800eb8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	50                   	push   %eax
  800ebc:	6a 05                	push   $0x5
  800ebe:	68 e8 2f 80 00       	push   $0x802fe8
  800ec3:	6a 43                	push   $0x43
  800ec5:	68 05 30 80 00       	push   $0x803005
  800eca:	e8 34 f3 ff ff       	call   800203 <_panic>

00800ecf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee3:	b8 06 00 00 00       	mov    $0x6,%eax
  800ee8:	89 df                	mov    %ebx,%edi
  800eea:	89 de                	mov    %ebx,%esi
  800eec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	7f 08                	jg     800efa <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efa:	83 ec 0c             	sub    $0xc,%esp
  800efd:	50                   	push   %eax
  800efe:	6a 06                	push   $0x6
  800f00:	68 e8 2f 80 00       	push   $0x802fe8
  800f05:	6a 43                	push   $0x43
  800f07:	68 05 30 80 00       	push   $0x803005
  800f0c:	e8 f2 f2 ff ff       	call   800203 <_panic>

00800f11 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	57                   	push   %edi
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
  800f17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 08 00 00 00       	mov    $0x8,%eax
  800f2a:	89 df                	mov    %ebx,%edi
  800f2c:	89 de                	mov    %ebx,%esi
  800f2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7f 08                	jg     800f3c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	50                   	push   %eax
  800f40:	6a 08                	push   $0x8
  800f42:	68 e8 2f 80 00       	push   $0x802fe8
  800f47:	6a 43                	push   $0x43
  800f49:	68 05 30 80 00       	push   $0x803005
  800f4e:	e8 b0 f2 ff ff       	call   800203 <_panic>

00800f53 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f67:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6c:	89 df                	mov    %ebx,%edi
  800f6e:	89 de                	mov    %ebx,%esi
  800f70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7f 08                	jg     800f7e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	50                   	push   %eax
  800f82:	6a 09                	push   $0x9
  800f84:	68 e8 2f 80 00       	push   $0x802fe8
  800f89:	6a 43                	push   $0x43
  800f8b:	68 05 30 80 00       	push   $0x803005
  800f90:	e8 6e f2 ff ff       	call   800203 <_panic>

00800f95 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7f 08                	jg     800fc0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	50                   	push   %eax
  800fc4:	6a 0a                	push   $0xa
  800fc6:	68 e8 2f 80 00       	push   $0x802fe8
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 05 30 80 00       	push   $0x803005
  800fd2:	e8 2c f2 ff ff       	call   800203 <_panic>

00800fd7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	57                   	push   %edi
  800fdb:	56                   	push   %esi
  800fdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fe8:	be 00 00 00 00       	mov    $0x0,%esi
  800fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
  801000:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801003:	b9 00 00 00 00       	mov    $0x0,%ecx
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801010:	89 cb                	mov    %ecx,%ebx
  801012:	89 cf                	mov    %ecx,%edi
  801014:	89 ce                	mov    %ecx,%esi
  801016:	cd 30                	int    $0x30
	if(check && ret > 0)
  801018:	85 c0                	test   %eax,%eax
  80101a:	7f 08                	jg     801024 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80101c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101f:	5b                   	pop    %ebx
  801020:	5e                   	pop    %esi
  801021:	5f                   	pop    %edi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801024:	83 ec 0c             	sub    $0xc,%esp
  801027:	50                   	push   %eax
  801028:	6a 0d                	push   $0xd
  80102a:	68 e8 2f 80 00       	push   $0x802fe8
  80102f:	6a 43                	push   $0x43
  801031:	68 05 30 80 00       	push   $0x803005
  801036:	e8 c8 f1 ff ff       	call   800203 <_panic>

0080103b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	57                   	push   %edi
  80103f:	56                   	push   %esi
  801040:	53                   	push   %ebx
	asm volatile("int %1\n"
  801041:	bb 00 00 00 00       	mov    $0x0,%ebx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801051:	89 df                	mov    %ebx,%edi
  801053:	89 de                	mov    %ebx,%esi
  801055:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	57                   	push   %edi
  801060:	56                   	push   %esi
  801061:	53                   	push   %ebx
	asm volatile("int %1\n"
  801062:	b9 00 00 00 00       	mov    $0x0,%ecx
  801067:	8b 55 08             	mov    0x8(%ebp),%edx
  80106a:	b8 0f 00 00 00       	mov    $0xf,%eax
  80106f:	89 cb                	mov    %ecx,%ebx
  801071:	89 cf                	mov    %ecx,%edi
  801073:	89 ce                	mov    %ecx,%esi
  801075:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	57                   	push   %edi
  801080:	56                   	push   %esi
  801081:	53                   	push   %ebx
	asm volatile("int %1\n"
  801082:	ba 00 00 00 00       	mov    $0x0,%edx
  801087:	b8 10 00 00 00       	mov    $0x10,%eax
  80108c:	89 d1                	mov    %edx,%ecx
  80108e:	89 d3                	mov    %edx,%ebx
  801090:	89 d7                	mov    %edx,%edi
  801092:	89 d6                	mov    %edx,%esi
  801094:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	57                   	push   %edi
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	b8 11 00 00 00       	mov    $0x11,%eax
  8010b1:	89 df                	mov    %ebx,%edi
  8010b3:	89 de                	mov    %ebx,%esi
  8010b5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cd:	b8 12 00 00 00       	mov    $0x12,%eax
  8010d2:	89 df                	mov    %ebx,%edi
  8010d4:	89 de                	mov    %ebx,%esi
  8010d6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5f                   	pop    %edi
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f1:	b8 13 00 00 00       	mov    $0x13,%eax
  8010f6:	89 df                	mov    %ebx,%edi
  8010f8:	89 de                	mov    %ebx,%esi
  8010fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	7f 08                	jg     801108 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5e                   	pop    %esi
  801105:	5f                   	pop    %edi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	50                   	push   %eax
  80110c:	6a 13                	push   $0x13
  80110e:	68 e8 2f 80 00       	push   $0x802fe8
  801113:	6a 43                	push   $0x43
  801115:	68 05 30 80 00       	push   $0x803005
  80111a:	e8 e4 f0 ff ff       	call   800203 <_panic>

0080111f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
	asm volatile("int %1\n"
  801125:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	b8 14 00 00 00       	mov    $0x14,%eax
  801132:	89 cb                	mov    %ecx,%ebx
  801134:	89 cf                	mov    %ecx,%edi
  801136:	89 ce                	mov    %ecx,%esi
  801138:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801146:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80114d:	f6 c5 04             	test   $0x4,%ch
  801150:	75 45                	jne    801197 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801152:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801159:	83 e1 07             	and    $0x7,%ecx
  80115c:	83 f9 07             	cmp    $0x7,%ecx
  80115f:	74 6f                	je     8011d0 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801161:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801168:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80116e:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801174:	0f 84 b6 00 00 00    	je     801230 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80117a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801181:	83 e1 05             	and    $0x5,%ecx
  801184:	83 f9 05             	cmp    $0x5,%ecx
  801187:	0f 84 d7 00 00 00    	je     801264 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80118d:	b8 00 00 00 00       	mov    $0x0,%eax
  801192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801195:	c9                   	leave  
  801196:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801197:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80119e:	c1 e2 0c             	shl    $0xc,%edx
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011aa:	51                   	push   %ecx
  8011ab:	52                   	push   %edx
  8011ac:	50                   	push   %eax
  8011ad:	52                   	push   %edx
  8011ae:	6a 00                	push   $0x0
  8011b0:	e8 d8 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  8011b5:	83 c4 20             	add    $0x20,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	79 d1                	jns    80118d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	68 13 30 80 00       	push   $0x803013
  8011c4:	6a 54                	push   $0x54
  8011c6:	68 29 30 80 00       	push   $0x803029
  8011cb:	e8 33 f0 ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011d0:	89 d3                	mov    %edx,%ebx
  8011d2:	c1 e3 0c             	shl    $0xc,%ebx
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	68 05 08 00 00       	push   $0x805
  8011dd:	53                   	push   %ebx
  8011de:	50                   	push   %eax
  8011df:	53                   	push   %ebx
  8011e0:	6a 00                	push   $0x0
  8011e2:	e8 a6 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  8011e7:	83 c4 20             	add    $0x20,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 2e                	js     80121c <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011ee:	83 ec 0c             	sub    $0xc,%esp
  8011f1:	68 05 08 00 00       	push   $0x805
  8011f6:	53                   	push   %ebx
  8011f7:	6a 00                	push   $0x0
  8011f9:	53                   	push   %ebx
  8011fa:	6a 00                	push   $0x0
  8011fc:	e8 8c fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801201:	83 c4 20             	add    $0x20,%esp
  801204:	85 c0                	test   %eax,%eax
  801206:	79 85                	jns    80118d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801208:	83 ec 04             	sub    $0x4,%esp
  80120b:	68 13 30 80 00       	push   $0x803013
  801210:	6a 5f                	push   $0x5f
  801212:	68 29 30 80 00       	push   $0x803029
  801217:	e8 e7 ef ff ff       	call   800203 <_panic>
			panic("sys_page_map() panic\n");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 13 30 80 00       	push   $0x803013
  801224:	6a 5b                	push   $0x5b
  801226:	68 29 30 80 00       	push   $0x803029
  80122b:	e8 d3 ef ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801230:	c1 e2 0c             	shl    $0xc,%edx
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	68 05 08 00 00       	push   $0x805
  80123b:	52                   	push   %edx
  80123c:	50                   	push   %eax
  80123d:	52                   	push   %edx
  80123e:	6a 00                	push   $0x0
  801240:	e8 48 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801245:	83 c4 20             	add    $0x20,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 89 3d ff ff ff    	jns    80118d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	68 13 30 80 00       	push   $0x803013
  801258:	6a 66                	push   $0x66
  80125a:	68 29 30 80 00       	push   $0x803029
  80125f:	e8 9f ef ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801264:	c1 e2 0c             	shl    $0xc,%edx
  801267:	83 ec 0c             	sub    $0xc,%esp
  80126a:	6a 05                	push   $0x5
  80126c:	52                   	push   %edx
  80126d:	50                   	push   %eax
  80126e:	52                   	push   %edx
  80126f:	6a 00                	push   $0x0
  801271:	e8 17 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801276:	83 c4 20             	add    $0x20,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	0f 89 0c ff ff ff    	jns    80118d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801281:	83 ec 04             	sub    $0x4,%esp
  801284:	68 13 30 80 00       	push   $0x803013
  801289:	6a 6d                	push   $0x6d
  80128b:	68 29 30 80 00       	push   $0x803029
  801290:	e8 6e ef ff ff       	call   800203 <_panic>

00801295 <pgfault>:
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	53                   	push   %ebx
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80129f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012a1:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012a5:	0f 84 99 00 00 00    	je     801344 <pgfault+0xaf>
  8012ab:	89 c2                	mov    %eax,%edx
  8012ad:	c1 ea 16             	shr    $0x16,%edx
  8012b0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012b7:	f6 c2 01             	test   $0x1,%dl
  8012ba:	0f 84 84 00 00 00    	je     801344 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	c1 ea 0c             	shr    $0xc,%edx
  8012c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012cc:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012d2:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012d8:	75 6a                	jne    801344 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012df:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	6a 07                	push   $0x7
  8012e6:	68 00 f0 7f 00       	push   $0x7ff000
  8012eb:	6a 00                	push   $0x0
  8012ed:	e8 58 fb ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 5f                	js     801358 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	68 00 10 00 00       	push   $0x1000
  801301:	53                   	push   %ebx
  801302:	68 00 f0 7f 00       	push   $0x7ff000
  801307:	e8 3c f9 ff ff       	call   800c48 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80130c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801313:	53                   	push   %ebx
  801314:	6a 00                	push   $0x0
  801316:	68 00 f0 7f 00       	push   $0x7ff000
  80131b:	6a 00                	push   $0x0
  80131d:	e8 6b fb ff ff       	call   800e8d <sys_page_map>
	if(ret < 0)
  801322:	83 c4 20             	add    $0x20,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 43                	js     80136c <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	68 00 f0 7f 00       	push   $0x7ff000
  801331:	6a 00                	push   $0x0
  801333:	e8 97 fb ff ff       	call   800ecf <sys_page_unmap>
	if(ret < 0)
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	85 c0                	test   %eax,%eax
  80133d:	78 41                	js     801380 <pgfault+0xeb>
}
  80133f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801342:	c9                   	leave  
  801343:	c3                   	ret    
		panic("panic at pgfault()\n");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 34 30 80 00       	push   $0x803034
  80134c:	6a 26                	push   $0x26
  80134e:	68 29 30 80 00       	push   $0x803029
  801353:	e8 ab ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_alloc()\n");
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	68 48 30 80 00       	push   $0x803048
  801360:	6a 31                	push   $0x31
  801362:	68 29 30 80 00       	push   $0x803029
  801367:	e8 97 ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_map()\n");
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 63 30 80 00       	push   $0x803063
  801374:	6a 36                	push   $0x36
  801376:	68 29 30 80 00       	push   $0x803029
  80137b:	e8 83 ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_unmap()\n");
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	68 7c 30 80 00       	push   $0x80307c
  801388:	6a 39                	push   $0x39
  80138a:	68 29 30 80 00       	push   $0x803029
  80138f:	e8 6f ee ff ff       	call   800203 <_panic>

00801394 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	57                   	push   %edi
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
  80139a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80139d:	68 95 12 80 00       	push   $0x801295
  8013a2:	e8 d1 14 00 00       	call   802878 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013a7:	b8 07 00 00 00       	mov    $0x7,%eax
  8013ac:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 27                	js     8013dc <fork+0x48>
  8013b5:	89 c6                	mov    %eax,%esi
  8013b7:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013b9:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013be:	75 48                	jne    801408 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013c0:	e8 47 fa ff ff       	call   800e0c <sys_getenvid>
  8013c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013ca:	c1 e0 07             	shl    $0x7,%eax
  8013cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013d2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013d7:	e9 90 00 00 00       	jmp    80146c <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013dc:	83 ec 04             	sub    $0x4,%esp
  8013df:	68 98 30 80 00       	push   $0x803098
  8013e4:	68 8c 00 00 00       	push   $0x8c
  8013e9:	68 29 30 80 00       	push   $0x803029
  8013ee:	e8 10 ee ff ff       	call   800203 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013f3:	89 f8                	mov    %edi,%eax
  8013f5:	e8 45 fd ff ff       	call   80113f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801400:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801406:	74 26                	je     80142e <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801408:	89 d8                	mov    %ebx,%eax
  80140a:	c1 e8 16             	shr    $0x16,%eax
  80140d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801414:	a8 01                	test   $0x1,%al
  801416:	74 e2                	je     8013fa <fork+0x66>
  801418:	89 da                	mov    %ebx,%edx
  80141a:	c1 ea 0c             	shr    $0xc,%edx
  80141d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801424:	83 e0 05             	and    $0x5,%eax
  801427:	83 f8 05             	cmp    $0x5,%eax
  80142a:	75 ce                	jne    8013fa <fork+0x66>
  80142c:	eb c5                	jmp    8013f3 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	6a 07                	push   $0x7
  801433:	68 00 f0 bf ee       	push   $0xeebff000
  801438:	56                   	push   %esi
  801439:	e8 0c fa ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 31                	js     801476 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	68 e7 28 80 00       	push   $0x8028e7
  80144d:	56                   	push   %esi
  80144e:	e8 42 fb ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	85 c0                	test   %eax,%eax
  801458:	78 33                	js     80148d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	6a 02                	push   $0x2
  80145f:	56                   	push   %esi
  801460:	e8 ac fa ff ff       	call   800f11 <sys_env_set_status>
	if(ret < 0)
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 38                	js     8014a4 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80146c:	89 f0                	mov    %esi,%eax
  80146e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5f                   	pop    %edi
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	68 48 30 80 00       	push   $0x803048
  80147e:	68 98 00 00 00       	push   $0x98
  801483:	68 29 30 80 00       	push   $0x803029
  801488:	e8 76 ed ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 bc 30 80 00       	push   $0x8030bc
  801495:	68 9b 00 00 00       	push   $0x9b
  80149a:	68 29 30 80 00       	push   $0x803029
  80149f:	e8 5f ed ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	68 e4 30 80 00       	push   $0x8030e4
  8014ac:	68 9e 00 00 00       	push   $0x9e
  8014b1:	68 29 30 80 00       	push   $0x803029
  8014b6:	e8 48 ed ff ff       	call   800203 <_panic>

008014bb <sfork>:

// Challenge!
int
sfork(void)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	57                   	push   %edi
  8014bf:	56                   	push   %esi
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014c4:	68 95 12 80 00       	push   $0x801295
  8014c9:	e8 aa 13 00 00       	call   802878 <set_pgfault_handler>
  8014ce:	b8 07 00 00 00       	mov    $0x7,%eax
  8014d3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 27                	js     801503 <sfork+0x48>
  8014dc:	89 c7                	mov    %eax,%edi
  8014de:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014e0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014e5:	75 55                	jne    80153c <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014e7:	e8 20 f9 ff ff       	call   800e0c <sys_getenvid>
  8014ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014f1:	c1 e0 07             	shl    $0x7,%eax
  8014f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014f9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014fe:	e9 d4 00 00 00       	jmp    8015d7 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	68 98 30 80 00       	push   $0x803098
  80150b:	68 af 00 00 00       	push   $0xaf
  801510:	68 29 30 80 00       	push   $0x803029
  801515:	e8 e9 ec ff ff       	call   800203 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80151a:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80151f:	89 f0                	mov    %esi,%eax
  801521:	e8 19 fc ff ff       	call   80113f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801526:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80152c:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801532:	77 65                	ja     801599 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801534:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80153a:	74 de                	je     80151a <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	c1 e8 16             	shr    $0x16,%eax
  801541:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801548:	a8 01                	test   $0x1,%al
  80154a:	74 da                	je     801526 <sfork+0x6b>
  80154c:	89 da                	mov    %ebx,%edx
  80154e:	c1 ea 0c             	shr    $0xc,%edx
  801551:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801558:	83 e0 05             	and    $0x5,%eax
  80155b:	83 f8 05             	cmp    $0x5,%eax
  80155e:	75 c6                	jne    801526 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801560:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801567:	c1 e2 0c             	shl    $0xc,%edx
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	83 e0 07             	and    $0x7,%eax
  801570:	50                   	push   %eax
  801571:	52                   	push   %edx
  801572:	56                   	push   %esi
  801573:	52                   	push   %edx
  801574:	6a 00                	push   $0x0
  801576:	e8 12 f9 ff ff       	call   800e8d <sys_page_map>
  80157b:	83 c4 20             	add    $0x20,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	74 a4                	je     801526 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 13 30 80 00       	push   $0x803013
  80158a:	68 ba 00 00 00       	push   $0xba
  80158f:	68 29 30 80 00       	push   $0x803029
  801594:	e8 6a ec ff ff       	call   800203 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801599:	83 ec 04             	sub    $0x4,%esp
  80159c:	6a 07                	push   $0x7
  80159e:	68 00 f0 bf ee       	push   $0xeebff000
  8015a3:	57                   	push   %edi
  8015a4:	e8 a1 f8 ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 31                	js     8015e1 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	68 e7 28 80 00       	push   $0x8028e7
  8015b8:	57                   	push   %edi
  8015b9:	e8 d7 f9 ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	78 33                	js     8015f8 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	6a 02                	push   $0x2
  8015ca:	57                   	push   %edi
  8015cb:	e8 41 f9 ff ff       	call   800f11 <sys_env_set_status>
	if(ret < 0)
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	78 38                	js     80160f <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015d7:	89 f8                	mov    %edi,%eax
  8015d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dc:	5b                   	pop    %ebx
  8015dd:	5e                   	pop    %esi
  8015de:	5f                   	pop    %edi
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	68 48 30 80 00       	push   $0x803048
  8015e9:	68 c0 00 00 00       	push   $0xc0
  8015ee:	68 29 30 80 00       	push   $0x803029
  8015f3:	e8 0b ec ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 bc 30 80 00       	push   $0x8030bc
  801600:	68 c3 00 00 00       	push   $0xc3
  801605:	68 29 30 80 00       	push   $0x803029
  80160a:	e8 f4 eb ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_status()\n");
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	68 e4 30 80 00       	push   $0x8030e4
  801617:	68 c6 00 00 00       	push   $0xc6
  80161c:	68 29 30 80 00       	push   $0x803029
  801621:	e8 dd eb ff ff       	call   800203 <_panic>

00801626 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	8b 75 08             	mov    0x8(%ebp),%esi
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801634:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801636:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80163b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80163e:	83 ec 0c             	sub    $0xc,%esp
  801641:	50                   	push   %eax
  801642:	e8 b3 f9 ff ff       	call   800ffa <sys_ipc_recv>
	if(ret < 0){
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 2b                	js     801679 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80164e:	85 f6                	test   %esi,%esi
  801650:	74 0a                	je     80165c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801652:	a1 08 50 80 00       	mov    0x805008,%eax
  801657:	8b 40 74             	mov    0x74(%eax),%eax
  80165a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80165c:	85 db                	test   %ebx,%ebx
  80165e:	74 0a                	je     80166a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801660:	a1 08 50 80 00       	mov    0x805008,%eax
  801665:	8b 40 78             	mov    0x78(%eax),%eax
  801668:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80166a:	a1 08 50 80 00       	mov    0x805008,%eax
  80166f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801672:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    
		if(from_env_store)
  801679:	85 f6                	test   %esi,%esi
  80167b:	74 06                	je     801683 <ipc_recv+0x5d>
			*from_env_store = 0;
  80167d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801683:	85 db                	test   %ebx,%ebx
  801685:	74 eb                	je     801672 <ipc_recv+0x4c>
			*perm_store = 0;
  801687:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80168d:	eb e3                	jmp    801672 <ipc_recv+0x4c>

0080168f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	57                   	push   %edi
  801693:	56                   	push   %esi
  801694:	53                   	push   %ebx
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	8b 7d 08             	mov    0x8(%ebp),%edi
  80169b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80169e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016a1:	85 db                	test   %ebx,%ebx
  8016a3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016a8:	0f 44 d8             	cmove  %eax,%ebx
  8016ab:	eb 05                	jmp    8016b2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8016ad:	e8 79 f7 ff ff       	call   800e2b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016b2:	ff 75 14             	pushl  0x14(%ebp)
  8016b5:	53                   	push   %ebx
  8016b6:	56                   	push   %esi
  8016b7:	57                   	push   %edi
  8016b8:	e8 1a f9 ff ff       	call   800fd7 <sys_ipc_try_send>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	74 1b                	je     8016df <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016c4:	79 e7                	jns    8016ad <ipc_send+0x1e>
  8016c6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016c9:	74 e2                	je     8016ad <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 03 31 80 00       	push   $0x803103
  8016d3:	6a 46                	push   $0x46
  8016d5:	68 18 31 80 00       	push   $0x803118
  8016da:	e8 24 eb ff ff       	call   800203 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5e                   	pop    %esi
  8016e4:	5f                   	pop    %edi
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016f2:	89 c2                	mov    %eax,%edx
  8016f4:	c1 e2 07             	shl    $0x7,%edx
  8016f7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016fd:	8b 52 50             	mov    0x50(%edx),%edx
  801700:	39 ca                	cmp    %ecx,%edx
  801702:	74 11                	je     801715 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801704:	83 c0 01             	add    $0x1,%eax
  801707:	3d 00 04 00 00       	cmp    $0x400,%eax
  80170c:	75 e4                	jne    8016f2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 0b                	jmp    801720 <ipc_find_env+0x39>
			return envs[i].env_id;
  801715:	c1 e0 07             	shl    $0x7,%eax
  801718:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80171d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	05 00 00 00 30       	add    $0x30000000,%eax
  80172d:	c1 e8 0c             	shr    $0xc,%eax
}
  801730:	5d                   	pop    %ebp
  801731:	c3                   	ret    

00801732 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80173d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801742:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801751:	89 c2                	mov    %eax,%edx
  801753:	c1 ea 16             	shr    $0x16,%edx
  801756:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80175d:	f6 c2 01             	test   $0x1,%dl
  801760:	74 2d                	je     80178f <fd_alloc+0x46>
  801762:	89 c2                	mov    %eax,%edx
  801764:	c1 ea 0c             	shr    $0xc,%edx
  801767:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80176e:	f6 c2 01             	test   $0x1,%dl
  801771:	74 1c                	je     80178f <fd_alloc+0x46>
  801773:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801778:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80177d:	75 d2                	jne    801751 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801788:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80178d:	eb 0a                	jmp    801799 <fd_alloc+0x50>
			*fd_store = fd;
  80178f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801792:	89 01                	mov    %eax,(%ecx)
			return 0;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017a1:	83 f8 1f             	cmp    $0x1f,%eax
  8017a4:	77 30                	ja     8017d6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017a6:	c1 e0 0c             	shl    $0xc,%eax
  8017a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017ae:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017b4:	f6 c2 01             	test   $0x1,%dl
  8017b7:	74 24                	je     8017dd <fd_lookup+0x42>
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	c1 ea 0c             	shr    $0xc,%edx
  8017be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c5:	f6 c2 01             	test   $0x1,%dl
  8017c8:	74 1a                	je     8017e4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	89 02                	mov    %eax,(%edx)
	return 0;
  8017cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    
		return -E_INVAL;
  8017d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017db:	eb f7                	jmp    8017d4 <fd_lookup+0x39>
		return -E_INVAL;
  8017dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e2:	eb f0                	jmp    8017d4 <fd_lookup+0x39>
  8017e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e9:	eb e9                	jmp    8017d4 <fd_lookup+0x39>

008017eb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f9:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017fe:	39 08                	cmp    %ecx,(%eax)
  801800:	74 38                	je     80183a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801802:	83 c2 01             	add    $0x1,%edx
  801805:	8b 04 95 a0 31 80 00 	mov    0x8031a0(,%edx,4),%eax
  80180c:	85 c0                	test   %eax,%eax
  80180e:	75 ee                	jne    8017fe <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801810:	a1 08 50 80 00       	mov    0x805008,%eax
  801815:	8b 40 48             	mov    0x48(%eax),%eax
  801818:	83 ec 04             	sub    $0x4,%esp
  80181b:	51                   	push   %ecx
  80181c:	50                   	push   %eax
  80181d:	68 24 31 80 00       	push   $0x803124
  801822:	e8 d2 ea ff ff       	call   8002f9 <cprintf>
	*dev = 0;
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    
			*dev = devtab[i];
  80183a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	eb f2                	jmp    801838 <dev_lookup+0x4d>

00801846 <fd_close>:
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	57                   	push   %edi
  80184a:	56                   	push   %esi
  80184b:	53                   	push   %ebx
  80184c:	83 ec 24             	sub    $0x24,%esp
  80184f:	8b 75 08             	mov    0x8(%ebp),%esi
  801852:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801855:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801858:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801859:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80185f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801862:	50                   	push   %eax
  801863:	e8 33 ff ff ff       	call   80179b <fd_lookup>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	78 05                	js     801876 <fd_close+0x30>
	    || fd != fd2)
  801871:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801874:	74 16                	je     80188c <fd_close+0x46>
		return (must_exist ? r : 0);
  801876:	89 f8                	mov    %edi,%eax
  801878:	84 c0                	test   %al,%al
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
  80187f:	0f 44 d8             	cmove  %eax,%ebx
}
  801882:	89 d8                	mov    %ebx,%eax
  801884:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801892:	50                   	push   %eax
  801893:	ff 36                	pushl  (%esi)
  801895:	e8 51 ff ff ff       	call   8017eb <dev_lookup>
  80189a:	89 c3                	mov    %eax,%ebx
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 1a                	js     8018bd <fd_close+0x77>
		if (dev->dev_close)
  8018a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	74 0b                	je     8018bd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018b2:	83 ec 0c             	sub    $0xc,%esp
  8018b5:	56                   	push   %esi
  8018b6:	ff d0                	call   *%eax
  8018b8:	89 c3                	mov    %eax,%ebx
  8018ba:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	56                   	push   %esi
  8018c1:	6a 00                	push   $0x0
  8018c3:	e8 07 f6 ff ff       	call   800ecf <sys_page_unmap>
	return r;
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	eb b5                	jmp    801882 <fd_close+0x3c>

008018cd <close>:

int
close(int fdnum)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d6:	50                   	push   %eax
  8018d7:	ff 75 08             	pushl  0x8(%ebp)
  8018da:	e8 bc fe ff ff       	call   80179b <fd_lookup>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	79 02                	jns    8018e8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    
		return fd_close(fd, 1);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	6a 01                	push   $0x1
  8018ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f0:	e8 51 ff ff ff       	call   801846 <fd_close>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	eb ec                	jmp    8018e6 <close+0x19>

008018fa <close_all>:

void
close_all(void)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801901:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	53                   	push   %ebx
  80190a:	e8 be ff ff ff       	call   8018cd <close>
	for (i = 0; i < MAXFD; i++)
  80190f:	83 c3 01             	add    $0x1,%ebx
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	83 fb 20             	cmp    $0x20,%ebx
  801918:	75 ec                	jne    801906 <close_all+0xc>
}
  80191a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	57                   	push   %edi
  801923:	56                   	push   %esi
  801924:	53                   	push   %ebx
  801925:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801928:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 67 fe ff ff       	call   80179b <fd_lookup>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	0f 88 81 00 00 00    	js     8019c2 <dup+0xa3>
		return r;
	close(newfdnum);
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 81 ff ff ff       	call   8018cd <close>

	newfd = INDEX2FD(newfdnum);
  80194c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80194f:	c1 e6 0c             	shl    $0xc,%esi
  801952:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801958:	83 c4 04             	add    $0x4,%esp
  80195b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80195e:	e8 cf fd ff ff       	call   801732 <fd2data>
  801963:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801965:	89 34 24             	mov    %esi,(%esp)
  801968:	e8 c5 fd ff ff       	call   801732 <fd2data>
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801972:	89 d8                	mov    %ebx,%eax
  801974:	c1 e8 16             	shr    $0x16,%eax
  801977:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80197e:	a8 01                	test   $0x1,%al
  801980:	74 11                	je     801993 <dup+0x74>
  801982:	89 d8                	mov    %ebx,%eax
  801984:	c1 e8 0c             	shr    $0xc,%eax
  801987:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80198e:	f6 c2 01             	test   $0x1,%dl
  801991:	75 39                	jne    8019cc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801993:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801996:	89 d0                	mov    %edx,%eax
  801998:	c1 e8 0c             	shr    $0xc,%eax
  80199b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019a2:	83 ec 0c             	sub    $0xc,%esp
  8019a5:	25 07 0e 00 00       	and    $0xe07,%eax
  8019aa:	50                   	push   %eax
  8019ab:	56                   	push   %esi
  8019ac:	6a 00                	push   $0x0
  8019ae:	52                   	push   %edx
  8019af:	6a 00                	push   $0x0
  8019b1:	e8 d7 f4 ff ff       	call   800e8d <sys_page_map>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	83 c4 20             	add    $0x20,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 31                	js     8019f0 <dup+0xd1>
		goto err;

	return newfdnum;
  8019bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019c2:	89 d8                	mov    %ebx,%eax
  8019c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019c7:	5b                   	pop    %ebx
  8019c8:	5e                   	pop    %esi
  8019c9:	5f                   	pop    %edi
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d3:	83 ec 0c             	sub    $0xc,%esp
  8019d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8019db:	50                   	push   %eax
  8019dc:	57                   	push   %edi
  8019dd:	6a 00                	push   $0x0
  8019df:	53                   	push   %ebx
  8019e0:	6a 00                	push   $0x0
  8019e2:	e8 a6 f4 ff ff       	call   800e8d <sys_page_map>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	83 c4 20             	add    $0x20,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	79 a3                	jns    801993 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	56                   	push   %esi
  8019f4:	6a 00                	push   $0x0
  8019f6:	e8 d4 f4 ff ff       	call   800ecf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019fb:	83 c4 08             	add    $0x8,%esp
  8019fe:	57                   	push   %edi
  8019ff:	6a 00                	push   $0x0
  801a01:	e8 c9 f4 ff ff       	call   800ecf <sys_page_unmap>
	return r;
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	eb b7                	jmp    8019c2 <dup+0xa3>

00801a0b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	53                   	push   %ebx
  801a0f:	83 ec 1c             	sub    $0x1c,%esp
  801a12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a15:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a18:	50                   	push   %eax
  801a19:	53                   	push   %ebx
  801a1a:	e8 7c fd ff ff       	call   80179b <fd_lookup>
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	85 c0                	test   %eax,%eax
  801a24:	78 3f                	js     801a65 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a26:	83 ec 08             	sub    $0x8,%esp
  801a29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2c:	50                   	push   %eax
  801a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a30:	ff 30                	pushl  (%eax)
  801a32:	e8 b4 fd ff ff       	call   8017eb <dev_lookup>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 27                	js     801a65 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a41:	8b 42 08             	mov    0x8(%edx),%eax
  801a44:	83 e0 03             	and    $0x3,%eax
  801a47:	83 f8 01             	cmp    $0x1,%eax
  801a4a:	74 1e                	je     801a6a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	8b 40 08             	mov    0x8(%eax),%eax
  801a52:	85 c0                	test   %eax,%eax
  801a54:	74 35                	je     801a8b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	ff 75 10             	pushl  0x10(%ebp)
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	52                   	push   %edx
  801a60:	ff d0                	call   *%eax
  801a62:	83 c4 10             	add    $0x10,%esp
}
  801a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a6a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a6f:	8b 40 48             	mov    0x48(%eax),%eax
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	53                   	push   %ebx
  801a76:	50                   	push   %eax
  801a77:	68 65 31 80 00       	push   $0x803165
  801a7c:	e8 78 e8 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a89:	eb da                	jmp    801a65 <read+0x5a>
		return -E_NOT_SUPP;
  801a8b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a90:	eb d3                	jmp    801a65 <read+0x5a>

00801a92 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	57                   	push   %edi
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
  801a98:	83 ec 0c             	sub    $0xc,%esp
  801a9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a9e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa6:	39 f3                	cmp    %esi,%ebx
  801aa8:	73 23                	jae    801acd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	89 f0                	mov    %esi,%eax
  801aaf:	29 d8                	sub    %ebx,%eax
  801ab1:	50                   	push   %eax
  801ab2:	89 d8                	mov    %ebx,%eax
  801ab4:	03 45 0c             	add    0xc(%ebp),%eax
  801ab7:	50                   	push   %eax
  801ab8:	57                   	push   %edi
  801ab9:	e8 4d ff ff ff       	call   801a0b <read>
		if (m < 0)
  801abe:	83 c4 10             	add    $0x10,%esp
  801ac1:	85 c0                	test   %eax,%eax
  801ac3:	78 06                	js     801acb <readn+0x39>
			return m;
		if (m == 0)
  801ac5:	74 06                	je     801acd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ac7:	01 c3                	add    %eax,%ebx
  801ac9:	eb db                	jmp    801aa6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801acb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5e                   	pop    %esi
  801ad4:	5f                   	pop    %edi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	53                   	push   %ebx
  801adb:	83 ec 1c             	sub    $0x1c,%esp
  801ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae4:	50                   	push   %eax
  801ae5:	53                   	push   %ebx
  801ae6:	e8 b0 fc ff ff       	call   80179b <fd_lookup>
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	85 c0                	test   %eax,%eax
  801af0:	78 3a                	js     801b2c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af2:	83 ec 08             	sub    $0x8,%esp
  801af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af8:	50                   	push   %eax
  801af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afc:	ff 30                	pushl  (%eax)
  801afe:	e8 e8 fc ff ff       	call   8017eb <dev_lookup>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	85 c0                	test   %eax,%eax
  801b08:	78 22                	js     801b2c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b11:	74 1e                	je     801b31 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b16:	8b 52 0c             	mov    0xc(%edx),%edx
  801b19:	85 d2                	test   %edx,%edx
  801b1b:	74 35                	je     801b52 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	ff 75 10             	pushl  0x10(%ebp)
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	50                   	push   %eax
  801b27:	ff d2                	call   *%edx
  801b29:	83 c4 10             	add    $0x10,%esp
}
  801b2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b31:	a1 08 50 80 00       	mov    0x805008,%eax
  801b36:	8b 40 48             	mov    0x48(%eax),%eax
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	53                   	push   %ebx
  801b3d:	50                   	push   %eax
  801b3e:	68 81 31 80 00       	push   $0x803181
  801b43:	e8 b1 e7 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b50:	eb da                	jmp    801b2c <write+0x55>
		return -E_NOT_SUPP;
  801b52:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b57:	eb d3                	jmp    801b2c <write+0x55>

00801b59 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b62:	50                   	push   %eax
  801b63:	ff 75 08             	pushl  0x8(%ebp)
  801b66:	e8 30 fc ff ff       	call   80179b <fd_lookup>
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 0e                	js     801b80 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
  801b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8f:	50                   	push   %eax
  801b90:	53                   	push   %ebx
  801b91:	e8 05 fc ff ff       	call   80179b <fd_lookup>
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 37                	js     801bd4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9d:	83 ec 08             	sub    $0x8,%esp
  801ba0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba3:	50                   	push   %eax
  801ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba7:	ff 30                	pushl  (%eax)
  801ba9:	e8 3d fc ff ff       	call   8017eb <dev_lookup>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 1f                	js     801bd4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bbc:	74 1b                	je     801bd9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc1:	8b 52 18             	mov    0x18(%edx),%edx
  801bc4:	85 d2                	test   %edx,%edx
  801bc6:	74 32                	je     801bfa <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	50                   	push   %eax
  801bcf:	ff d2                	call   *%edx
  801bd1:	83 c4 10             	add    $0x10,%esp
}
  801bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bd9:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bde:	8b 40 48             	mov    0x48(%eax),%eax
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	53                   	push   %ebx
  801be5:	50                   	push   %eax
  801be6:	68 44 31 80 00       	push   $0x803144
  801beb:	e8 09 e7 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bf8:	eb da                	jmp    801bd4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bfa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bff:	eb d3                	jmp    801bd4 <ftruncate+0x52>

00801c01 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	53                   	push   %ebx
  801c05:	83 ec 1c             	sub    $0x1c,%esp
  801c08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0e:	50                   	push   %eax
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	e8 84 fb ff ff       	call   80179b <fd_lookup>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	78 4b                	js     801c69 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c24:	50                   	push   %eax
  801c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c28:	ff 30                	pushl  (%eax)
  801c2a:	e8 bc fb ff ff       	call   8017eb <dev_lookup>
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	78 33                	js     801c69 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c39:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c3d:	74 2f                	je     801c6e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c3f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c42:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c49:	00 00 00 
	stat->st_isdir = 0;
  801c4c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c53:	00 00 00 
	stat->st_dev = dev;
  801c56:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	53                   	push   %ebx
  801c60:	ff 75 f0             	pushl  -0x10(%ebp)
  801c63:	ff 50 14             	call   *0x14(%eax)
  801c66:	83 c4 10             	add    $0x10,%esp
}
  801c69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c6e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c73:	eb f4                	jmp    801c69 <fstat+0x68>

00801c75 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	56                   	push   %esi
  801c79:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	e8 22 02 00 00       	call   801ea9 <open>
  801c87:	89 c3                	mov    %eax,%ebx
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 1b                	js     801cab <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	50                   	push   %eax
  801c97:	e8 65 ff ff ff       	call   801c01 <fstat>
  801c9c:	89 c6                	mov    %eax,%esi
	close(fd);
  801c9e:	89 1c 24             	mov    %ebx,(%esp)
  801ca1:	e8 27 fc ff ff       	call   8018cd <close>
	return r;
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	89 f3                	mov    %esi,%ebx
}
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	56                   	push   %esi
  801cb8:	53                   	push   %ebx
  801cb9:	89 c6                	mov    %eax,%esi
  801cbb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cbd:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801cc4:	74 27                	je     801ced <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cc6:	6a 07                	push   $0x7
  801cc8:	68 00 60 80 00       	push   $0x806000
  801ccd:	56                   	push   %esi
  801cce:	ff 35 00 50 80 00    	pushl  0x805000
  801cd4:	e8 b6 f9 ff ff       	call   80168f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cd9:	83 c4 0c             	add    $0xc,%esp
  801cdc:	6a 00                	push   $0x0
  801cde:	53                   	push   %ebx
  801cdf:	6a 00                	push   $0x0
  801ce1:	e8 40 f9 ff ff       	call   801626 <ipc_recv>
}
  801ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce9:	5b                   	pop    %ebx
  801cea:	5e                   	pop    %esi
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ced:	83 ec 0c             	sub    $0xc,%esp
  801cf0:	6a 01                	push   $0x1
  801cf2:	e8 f0 f9 ff ff       	call   8016e7 <ipc_find_env>
  801cf7:	a3 00 50 80 00       	mov    %eax,0x805000
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	eb c5                	jmp    801cc6 <fsipc+0x12>

00801d01 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d15:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1f:	b8 02 00 00 00       	mov    $0x2,%eax
  801d24:	e8 8b ff ff ff       	call   801cb4 <fsipc>
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <devfile_flush>:
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	8b 40 0c             	mov    0xc(%eax),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	b8 06 00 00 00       	mov    $0x6,%eax
  801d46:	e8 69 ff ff ff       	call   801cb4 <fsipc>
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <devfile_stat>:
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	53                   	push   %ebx
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d62:	ba 00 00 00 00       	mov    $0x0,%edx
  801d67:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6c:	e8 43 ff ff ff       	call   801cb4 <fsipc>
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 2c                	js     801da1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	68 00 60 80 00       	push   $0x806000
  801d7d:	53                   	push   %ebx
  801d7e:	e8 d5 ec ff ff       	call   800a58 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d83:	a1 80 60 80 00       	mov    0x806080,%eax
  801d88:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d8e:	a1 84 60 80 00       	mov    0x806084,%eax
  801d93:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <devfile_write>:
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	53                   	push   %ebx
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8b 40 0c             	mov    0xc(%eax),%eax
  801db6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dbb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801dc1:	53                   	push   %ebx
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	68 08 60 80 00       	push   $0x806008
  801dca:	e8 79 ee ff ff       	call   800c48 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd4:	b8 04 00 00 00       	mov    $0x4,%eax
  801dd9:	e8 d6 fe ff ff       	call   801cb4 <fsipc>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 0b                	js     801df0 <devfile_write+0x4a>
	assert(r <= n);
  801de5:	39 d8                	cmp    %ebx,%eax
  801de7:	77 0c                	ja     801df5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801de9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dee:	7f 1e                	jg     801e0e <devfile_write+0x68>
}
  801df0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    
	assert(r <= n);
  801df5:	68 b4 31 80 00       	push   $0x8031b4
  801dfa:	68 bb 31 80 00       	push   $0x8031bb
  801dff:	68 98 00 00 00       	push   $0x98
  801e04:	68 d0 31 80 00       	push   $0x8031d0
  801e09:	e8 f5 e3 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  801e0e:	68 db 31 80 00       	push   $0x8031db
  801e13:	68 bb 31 80 00       	push   $0x8031bb
  801e18:	68 99 00 00 00       	push   $0x99
  801e1d:	68 d0 31 80 00       	push   $0x8031d0
  801e22:	e8 dc e3 ff ff       	call   800203 <_panic>

00801e27 <devfile_read>:
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	56                   	push   %esi
  801e2b:	53                   	push   %ebx
  801e2c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e3a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e40:	ba 00 00 00 00       	mov    $0x0,%edx
  801e45:	b8 03 00 00 00       	mov    $0x3,%eax
  801e4a:	e8 65 fe ff ff       	call   801cb4 <fsipc>
  801e4f:	89 c3                	mov    %eax,%ebx
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 1f                	js     801e74 <devfile_read+0x4d>
	assert(r <= n);
  801e55:	39 f0                	cmp    %esi,%eax
  801e57:	77 24                	ja     801e7d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e59:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e5e:	7f 33                	jg     801e93 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	50                   	push   %eax
  801e64:	68 00 60 80 00       	push   $0x806000
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	e8 75 ed ff ff       	call   800be6 <memmove>
	return r;
  801e71:	83 c4 10             	add    $0x10,%esp
}
  801e74:	89 d8                	mov    %ebx,%eax
  801e76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
	assert(r <= n);
  801e7d:	68 b4 31 80 00       	push   $0x8031b4
  801e82:	68 bb 31 80 00       	push   $0x8031bb
  801e87:	6a 7c                	push   $0x7c
  801e89:	68 d0 31 80 00       	push   $0x8031d0
  801e8e:	e8 70 e3 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  801e93:	68 db 31 80 00       	push   $0x8031db
  801e98:	68 bb 31 80 00       	push   $0x8031bb
  801e9d:	6a 7d                	push   $0x7d
  801e9f:	68 d0 31 80 00       	push   $0x8031d0
  801ea4:	e8 5a e3 ff ff       	call   800203 <_panic>

00801ea9 <open>:
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 1c             	sub    $0x1c,%esp
  801eb1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801eb4:	56                   	push   %esi
  801eb5:	e8 65 eb ff ff       	call   800a1f <strlen>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ec2:	7f 6c                	jg     801f30 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eca:	50                   	push   %eax
  801ecb:	e8 79 f8 ff ff       	call   801749 <fd_alloc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	78 3c                	js     801f15 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ed9:	83 ec 08             	sub    $0x8,%esp
  801edc:	56                   	push   %esi
  801edd:	68 00 60 80 00       	push   $0x806000
  801ee2:	e8 71 eb ff ff       	call   800a58 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eea:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef7:	e8 b8 fd ff ff       	call   801cb4 <fsipc>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 19                	js     801f1e <open+0x75>
	return fd2num(fd);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0b:	e8 12 f8 ff ff       	call   801722 <fd2num>
  801f10:	89 c3                	mov    %eax,%ebx
  801f12:	83 c4 10             	add    $0x10,%esp
}
  801f15:	89 d8                	mov    %ebx,%eax
  801f17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f1a:	5b                   	pop    %ebx
  801f1b:	5e                   	pop    %esi
  801f1c:	5d                   	pop    %ebp
  801f1d:	c3                   	ret    
		fd_close(fd, 0);
  801f1e:	83 ec 08             	sub    $0x8,%esp
  801f21:	6a 00                	push   $0x0
  801f23:	ff 75 f4             	pushl  -0xc(%ebp)
  801f26:	e8 1b f9 ff ff       	call   801846 <fd_close>
		return r;
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	eb e5                	jmp    801f15 <open+0x6c>
		return -E_BAD_PATH;
  801f30:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f35:	eb de                	jmp    801f15 <open+0x6c>

00801f37 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f42:	b8 08 00 00 00       	mov    $0x8,%eax
  801f47:	e8 68 fd ff ff       	call   801cb4 <fsipc>
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f54:	68 e7 31 80 00       	push   $0x8031e7
  801f59:	ff 75 0c             	pushl  0xc(%ebp)
  801f5c:	e8 f7 ea ff ff       	call   800a58 <strcpy>
	return 0;
}
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <devsock_close>:
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	53                   	push   %ebx
  801f6c:	83 ec 10             	sub    $0x10,%esp
  801f6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f72:	53                   	push   %ebx
  801f73:	e8 95 09 00 00       	call   80290d <pageref>
  801f78:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f7b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f80:	83 f8 01             	cmp    $0x1,%eax
  801f83:	74 07                	je     801f8c <devsock_close+0x24>
}
  801f85:	89 d0                	mov    %edx,%eax
  801f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	ff 73 0c             	pushl  0xc(%ebx)
  801f92:	e8 b9 02 00 00       	call   802250 <nsipc_close>
  801f97:	89 c2                	mov    %eax,%edx
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	eb e7                	jmp    801f85 <devsock_close+0x1d>

00801f9e <devsock_write>:
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	ff 75 10             	pushl  0x10(%ebp)
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	ff 70 0c             	pushl  0xc(%eax)
  801fb2:	e8 76 03 00 00       	call   80232d <nsipc_send>
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <devsock_read>:
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	ff 75 10             	pushl  0x10(%ebp)
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	ff 70 0c             	pushl  0xc(%eax)
  801fcd:	e8 ef 02 00 00       	call   8022c1 <nsipc_recv>
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <fd2sockid>:
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fda:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fdd:	52                   	push   %edx
  801fde:	50                   	push   %eax
  801fdf:	e8 b7 f7 ff ff       	call   80179b <fd_lookup>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	78 10                	js     801ffb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ff4:	39 08                	cmp    %ecx,(%eax)
  801ff6:	75 05                	jne    801ffd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ff8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    
		return -E_NOT_SUPP;
  801ffd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802002:	eb f7                	jmp    801ffb <fd2sockid+0x27>

00802004 <alloc_sockfd>:
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	56                   	push   %esi
  802008:	53                   	push   %ebx
  802009:	83 ec 1c             	sub    $0x1c,%esp
  80200c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80200e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802011:	50                   	push   %eax
  802012:	e8 32 f7 ff ff       	call   801749 <fd_alloc>
  802017:	89 c3                	mov    %eax,%ebx
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 43                	js     802063 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802020:	83 ec 04             	sub    $0x4,%esp
  802023:	68 07 04 00 00       	push   $0x407
  802028:	ff 75 f4             	pushl  -0xc(%ebp)
  80202b:	6a 00                	push   $0x0
  80202d:	e8 18 ee ff ff       	call   800e4a <sys_page_alloc>
  802032:	89 c3                	mov    %eax,%ebx
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	78 28                	js     802063 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802044:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802050:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	50                   	push   %eax
  802057:	e8 c6 f6 ff ff       	call   801722 <fd2num>
  80205c:	89 c3                	mov    %eax,%ebx
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	eb 0c                	jmp    80206f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	56                   	push   %esi
  802067:	e8 e4 01 00 00       	call   802250 <nsipc_close>
		return r;
  80206c:	83 c4 10             	add    $0x10,%esp
}
  80206f:	89 d8                	mov    %ebx,%eax
  802071:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802074:	5b                   	pop    %ebx
  802075:	5e                   	pop    %esi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    

00802078 <accept>:
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	e8 4e ff ff ff       	call   801fd4 <fd2sockid>
  802086:	85 c0                	test   %eax,%eax
  802088:	78 1b                	js     8020a5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	50                   	push   %eax
  802094:	e8 0e 01 00 00       	call   8021a7 <nsipc_accept>
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 05                	js     8020a5 <accept+0x2d>
	return alloc_sockfd(r);
  8020a0:	e8 5f ff ff ff       	call   802004 <alloc_sockfd>
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <bind>:
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	e8 1f ff ff ff       	call   801fd4 <fd2sockid>
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	78 12                	js     8020cb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020b9:	83 ec 04             	sub    $0x4,%esp
  8020bc:	ff 75 10             	pushl  0x10(%ebp)
  8020bf:	ff 75 0c             	pushl  0xc(%ebp)
  8020c2:	50                   	push   %eax
  8020c3:	e8 31 01 00 00       	call   8021f9 <nsipc_bind>
  8020c8:	83 c4 10             	add    $0x10,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <shutdown>:
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	e8 f9 fe ff ff       	call   801fd4 <fd2sockid>
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 0f                	js     8020ee <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020df:	83 ec 08             	sub    $0x8,%esp
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	50                   	push   %eax
  8020e6:	e8 43 01 00 00       	call   80222e <nsipc_shutdown>
  8020eb:	83 c4 10             	add    $0x10,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <connect>:
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	e8 d6 fe ff ff       	call   801fd4 <fd2sockid>
  8020fe:	85 c0                	test   %eax,%eax
  802100:	78 12                	js     802114 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	ff 75 10             	pushl  0x10(%ebp)
  802108:	ff 75 0c             	pushl  0xc(%ebp)
  80210b:	50                   	push   %eax
  80210c:	e8 59 01 00 00       	call   80226a <nsipc_connect>
  802111:	83 c4 10             	add    $0x10,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <listen>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	e8 b0 fe ff ff       	call   801fd4 <fd2sockid>
  802124:	85 c0                	test   %eax,%eax
  802126:	78 0f                	js     802137 <listen+0x21>
	return nsipc_listen(r, backlog);
  802128:	83 ec 08             	sub    $0x8,%esp
  80212b:	ff 75 0c             	pushl  0xc(%ebp)
  80212e:	50                   	push   %eax
  80212f:	e8 6b 01 00 00       	call   80229f <nsipc_listen>
  802134:	83 c4 10             	add    $0x10,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <socket>:

int
socket(int domain, int type, int protocol)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80213f:	ff 75 10             	pushl  0x10(%ebp)
  802142:	ff 75 0c             	pushl  0xc(%ebp)
  802145:	ff 75 08             	pushl  0x8(%ebp)
  802148:	e8 3e 02 00 00       	call   80238b <nsipc_socket>
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	85 c0                	test   %eax,%eax
  802152:	78 05                	js     802159 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802154:	e8 ab fe ff ff       	call   802004 <alloc_sockfd>
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	53                   	push   %ebx
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802164:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80216b:	74 26                	je     802193 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80216d:	6a 07                	push   $0x7
  80216f:	68 00 70 80 00       	push   $0x807000
  802174:	53                   	push   %ebx
  802175:	ff 35 04 50 80 00    	pushl  0x805004
  80217b:	e8 0f f5 ff ff       	call   80168f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802180:	83 c4 0c             	add    $0xc,%esp
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	e8 98 f4 ff ff       	call   801626 <ipc_recv>
}
  80218e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802191:	c9                   	leave  
  802192:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	6a 02                	push   $0x2
  802198:	e8 4a f5 ff ff       	call   8016e7 <ipc_find_env>
  80219d:	a3 04 50 80 00       	mov    %eax,0x805004
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	eb c6                	jmp    80216d <nsipc+0x12>

008021a7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021b7:	8b 06                	mov    (%esi),%eax
  8021b9:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021be:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c3:	e8 93 ff ff ff       	call   80215b <nsipc>
  8021c8:	89 c3                	mov    %eax,%ebx
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	79 09                	jns    8021d7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021ce:	89 d8                	mov    %ebx,%eax
  8021d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	ff 35 10 70 80 00    	pushl  0x807010
  8021e0:	68 00 70 80 00       	push   $0x807000
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	e8 f9 e9 ff ff       	call   800be6 <memmove>
		*addrlen = ret->ret_addrlen;
  8021ed:	a1 10 70 80 00       	mov    0x807010,%eax
  8021f2:	89 06                	mov    %eax,(%esi)
  8021f4:	83 c4 10             	add    $0x10,%esp
	return r;
  8021f7:	eb d5                	jmp    8021ce <nsipc_accept+0x27>

008021f9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 08             	sub    $0x8,%esp
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80220b:	53                   	push   %ebx
  80220c:	ff 75 0c             	pushl  0xc(%ebp)
  80220f:	68 04 70 80 00       	push   $0x807004
  802214:	e8 cd e9 ff ff       	call   800be6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802219:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80221f:	b8 02 00 00 00       	mov    $0x2,%eax
  802224:	e8 32 ff ff ff       	call   80215b <nsipc>
}
  802229:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802244:	b8 03 00 00 00       	mov    $0x3,%eax
  802249:	e8 0d ff ff ff       	call   80215b <nsipc>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <nsipc_close>:

int
nsipc_close(int s)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80225e:	b8 04 00 00 00       	mov    $0x4,%eax
  802263:	e8 f3 fe ff ff       	call   80215b <nsipc>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	53                   	push   %ebx
  80226e:	83 ec 08             	sub    $0x8,%esp
  802271:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80227c:	53                   	push   %ebx
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	68 04 70 80 00       	push   $0x807004
  802285:	e8 5c e9 ff ff       	call   800be6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80228a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802290:	b8 05 00 00 00       	mov    $0x5,%eax
  802295:	e8 c1 fe ff ff       	call   80215b <nsipc>
}
  80229a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022b5:	b8 06 00 00 00       	mov    $0x6,%eax
  8022ba:	e8 9c fe ff ff       	call   80215b <nsipc>
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022d1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022da:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022df:	b8 07 00 00 00       	mov    $0x7,%eax
  8022e4:	e8 72 fe ff ff       	call   80215b <nsipc>
  8022e9:	89 c3                	mov    %eax,%ebx
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	78 1f                	js     80230e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022ef:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022f4:	7f 21                	jg     802317 <nsipc_recv+0x56>
  8022f6:	39 c6                	cmp    %eax,%esi
  8022f8:	7c 1d                	jl     802317 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	50                   	push   %eax
  8022fe:	68 00 70 80 00       	push   $0x807000
  802303:	ff 75 0c             	pushl  0xc(%ebp)
  802306:	e8 db e8 ff ff       	call   800be6 <memmove>
  80230b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80230e:	89 d8                	mov    %ebx,%eax
  802310:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5d                   	pop    %ebp
  802316:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802317:	68 f3 31 80 00       	push   $0x8031f3
  80231c:	68 bb 31 80 00       	push   $0x8031bb
  802321:	6a 62                	push   $0x62
  802323:	68 08 32 80 00       	push   $0x803208
  802328:	e8 d6 de ff ff       	call   800203 <_panic>

0080232d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	53                   	push   %ebx
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80233f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802345:	7f 2e                	jg     802375 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	53                   	push   %ebx
  80234b:	ff 75 0c             	pushl  0xc(%ebp)
  80234e:	68 0c 70 80 00       	push   $0x80700c
  802353:	e8 8e e8 ff ff       	call   800be6 <memmove>
	nsipcbuf.send.req_size = size;
  802358:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80235e:	8b 45 14             	mov    0x14(%ebp),%eax
  802361:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802366:	b8 08 00 00 00       	mov    $0x8,%eax
  80236b:	e8 eb fd ff ff       	call   80215b <nsipc>
}
  802370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802373:	c9                   	leave  
  802374:	c3                   	ret    
	assert(size < 1600);
  802375:	68 14 32 80 00       	push   $0x803214
  80237a:	68 bb 31 80 00       	push   $0x8031bb
  80237f:	6a 6d                	push   $0x6d
  802381:	68 08 32 80 00       	push   $0x803208
  802386:	e8 78 de ff ff       	call   800203 <_panic>

0080238b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023a4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023a9:	b8 09 00 00 00       	mov    $0x9,%eax
  8023ae:	e8 a8 fd ff ff       	call   80215b <nsipc>
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	56                   	push   %esi
  8023b9:	53                   	push   %ebx
  8023ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	e8 6a f3 ff ff       	call   801732 <fd2data>
  8023c8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023ca:	83 c4 08             	add    $0x8,%esp
  8023cd:	68 20 32 80 00       	push   $0x803220
  8023d2:	53                   	push   %ebx
  8023d3:	e8 80 e6 ff ff       	call   800a58 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023d8:	8b 46 04             	mov    0x4(%esi),%eax
  8023db:	2b 06                	sub    (%esi),%eax
  8023dd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023ea:	00 00 00 
	stat->st_dev = &devpipe;
  8023ed:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023f4:	40 80 00 
	return 0;
}
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5d                   	pop    %ebp
  802402:	c3                   	ret    

00802403 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	53                   	push   %ebx
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80240d:	53                   	push   %ebx
  80240e:	6a 00                	push   $0x0
  802410:	e8 ba ea ff ff       	call   800ecf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802415:	89 1c 24             	mov    %ebx,(%esp)
  802418:	e8 15 f3 ff ff       	call   801732 <fd2data>
  80241d:	83 c4 08             	add    $0x8,%esp
  802420:	50                   	push   %eax
  802421:	6a 00                	push   $0x0
  802423:	e8 a7 ea ff ff       	call   800ecf <sys_page_unmap>
}
  802428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <_pipeisclosed>:
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	57                   	push   %edi
  802431:	56                   	push   %esi
  802432:	53                   	push   %ebx
  802433:	83 ec 1c             	sub    $0x1c,%esp
  802436:	89 c7                	mov    %eax,%edi
  802438:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80243a:	a1 08 50 80 00       	mov    0x805008,%eax
  80243f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802442:	83 ec 0c             	sub    $0xc,%esp
  802445:	57                   	push   %edi
  802446:	e8 c2 04 00 00       	call   80290d <pageref>
  80244b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80244e:	89 34 24             	mov    %esi,(%esp)
  802451:	e8 b7 04 00 00       	call   80290d <pageref>
		nn = thisenv->env_runs;
  802456:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80245c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	39 cb                	cmp    %ecx,%ebx
  802464:	74 1b                	je     802481 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802466:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802469:	75 cf                	jne    80243a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80246b:	8b 42 58             	mov    0x58(%edx),%eax
  80246e:	6a 01                	push   $0x1
  802470:	50                   	push   %eax
  802471:	53                   	push   %ebx
  802472:	68 27 32 80 00       	push   $0x803227
  802477:	e8 7d de ff ff       	call   8002f9 <cprintf>
  80247c:	83 c4 10             	add    $0x10,%esp
  80247f:	eb b9                	jmp    80243a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802481:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802484:	0f 94 c0             	sete   %al
  802487:	0f b6 c0             	movzbl %al,%eax
}
  80248a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    

00802492 <devpipe_write>:
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	57                   	push   %edi
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	83 ec 28             	sub    $0x28,%esp
  80249b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80249e:	56                   	push   %esi
  80249f:	e8 8e f2 ff ff       	call   801732 <fd2data>
  8024a4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8024ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024b1:	74 4f                	je     802502 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024b3:	8b 43 04             	mov    0x4(%ebx),%eax
  8024b6:	8b 0b                	mov    (%ebx),%ecx
  8024b8:	8d 51 20             	lea    0x20(%ecx),%edx
  8024bb:	39 d0                	cmp    %edx,%eax
  8024bd:	72 14                	jb     8024d3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024bf:	89 da                	mov    %ebx,%edx
  8024c1:	89 f0                	mov    %esi,%eax
  8024c3:	e8 65 ff ff ff       	call   80242d <_pipeisclosed>
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	75 3b                	jne    802507 <devpipe_write+0x75>
			sys_yield();
  8024cc:	e8 5a e9 ff ff       	call   800e2b <sys_yield>
  8024d1:	eb e0                	jmp    8024b3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024da:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024dd:	89 c2                	mov    %eax,%edx
  8024df:	c1 fa 1f             	sar    $0x1f,%edx
  8024e2:	89 d1                	mov    %edx,%ecx
  8024e4:	c1 e9 1b             	shr    $0x1b,%ecx
  8024e7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024ea:	83 e2 1f             	and    $0x1f,%edx
  8024ed:	29 ca                	sub    %ecx,%edx
  8024ef:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024f3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024f7:	83 c0 01             	add    $0x1,%eax
  8024fa:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024fd:	83 c7 01             	add    $0x1,%edi
  802500:	eb ac                	jmp    8024ae <devpipe_write+0x1c>
	return i;
  802502:	8b 45 10             	mov    0x10(%ebp),%eax
  802505:	eb 05                	jmp    80250c <devpipe_write+0x7a>
				return 0;
  802507:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80250f:	5b                   	pop    %ebx
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    

00802514 <devpipe_read>:
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	57                   	push   %edi
  802518:	56                   	push   %esi
  802519:	53                   	push   %ebx
  80251a:	83 ec 18             	sub    $0x18,%esp
  80251d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802520:	57                   	push   %edi
  802521:	e8 0c f2 ff ff       	call   801732 <fd2data>
  802526:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802528:	83 c4 10             	add    $0x10,%esp
  80252b:	be 00 00 00 00       	mov    $0x0,%esi
  802530:	3b 75 10             	cmp    0x10(%ebp),%esi
  802533:	75 14                	jne    802549 <devpipe_read+0x35>
	return i;
  802535:	8b 45 10             	mov    0x10(%ebp),%eax
  802538:	eb 02                	jmp    80253c <devpipe_read+0x28>
				return i;
  80253a:	89 f0                	mov    %esi,%eax
}
  80253c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253f:	5b                   	pop    %ebx
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
			sys_yield();
  802544:	e8 e2 e8 ff ff       	call   800e2b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802549:	8b 03                	mov    (%ebx),%eax
  80254b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80254e:	75 18                	jne    802568 <devpipe_read+0x54>
			if (i > 0)
  802550:	85 f6                	test   %esi,%esi
  802552:	75 e6                	jne    80253a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802554:	89 da                	mov    %ebx,%edx
  802556:	89 f8                	mov    %edi,%eax
  802558:	e8 d0 fe ff ff       	call   80242d <_pipeisclosed>
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 e3                	je     802544 <devpipe_read+0x30>
				return 0;
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
  802566:	eb d4                	jmp    80253c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802568:	99                   	cltd   
  802569:	c1 ea 1b             	shr    $0x1b,%edx
  80256c:	01 d0                	add    %edx,%eax
  80256e:	83 e0 1f             	and    $0x1f,%eax
  802571:	29 d0                	sub    %edx,%eax
  802573:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80257e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802581:	83 c6 01             	add    $0x1,%esi
  802584:	eb aa                	jmp    802530 <devpipe_read+0x1c>

00802586 <pipe>:
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	56                   	push   %esi
  80258a:	53                   	push   %ebx
  80258b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80258e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802591:	50                   	push   %eax
  802592:	e8 b2 f1 ff ff       	call   801749 <fd_alloc>
  802597:	89 c3                	mov    %eax,%ebx
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	85 c0                	test   %eax,%eax
  80259e:	0f 88 23 01 00 00    	js     8026c7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a4:	83 ec 04             	sub    $0x4,%esp
  8025a7:	68 07 04 00 00       	push   $0x407
  8025ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8025af:	6a 00                	push   $0x0
  8025b1:	e8 94 e8 ff ff       	call   800e4a <sys_page_alloc>
  8025b6:	89 c3                	mov    %eax,%ebx
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	0f 88 04 01 00 00    	js     8026c7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025c3:	83 ec 0c             	sub    $0xc,%esp
  8025c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025c9:	50                   	push   %eax
  8025ca:	e8 7a f1 ff ff       	call   801749 <fd_alloc>
  8025cf:	89 c3                	mov    %eax,%ebx
  8025d1:	83 c4 10             	add    $0x10,%esp
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	0f 88 db 00 00 00    	js     8026b7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	68 07 04 00 00       	push   $0x407
  8025e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e7:	6a 00                	push   $0x0
  8025e9:	e8 5c e8 ff ff       	call   800e4a <sys_page_alloc>
  8025ee:	89 c3                	mov    %eax,%ebx
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 bc 00 00 00    	js     8026b7 <pipe+0x131>
	va = fd2data(fd0);
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802601:	e8 2c f1 ff ff       	call   801732 <fd2data>
  802606:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802608:	83 c4 0c             	add    $0xc,%esp
  80260b:	68 07 04 00 00       	push   $0x407
  802610:	50                   	push   %eax
  802611:	6a 00                	push   $0x0
  802613:	e8 32 e8 ff ff       	call   800e4a <sys_page_alloc>
  802618:	89 c3                	mov    %eax,%ebx
  80261a:	83 c4 10             	add    $0x10,%esp
  80261d:	85 c0                	test   %eax,%eax
  80261f:	0f 88 82 00 00 00    	js     8026a7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802625:	83 ec 0c             	sub    $0xc,%esp
  802628:	ff 75 f0             	pushl  -0x10(%ebp)
  80262b:	e8 02 f1 ff ff       	call   801732 <fd2data>
  802630:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802637:	50                   	push   %eax
  802638:	6a 00                	push   $0x0
  80263a:	56                   	push   %esi
  80263b:	6a 00                	push   $0x0
  80263d:	e8 4b e8 ff ff       	call   800e8d <sys_page_map>
  802642:	89 c3                	mov    %eax,%ebx
  802644:	83 c4 20             	add    $0x20,%esp
  802647:	85 c0                	test   %eax,%eax
  802649:	78 4e                	js     802699 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80264b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802655:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802658:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80265f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802662:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80266e:	83 ec 0c             	sub    $0xc,%esp
  802671:	ff 75 f4             	pushl  -0xc(%ebp)
  802674:	e8 a9 f0 ff ff       	call   801722 <fd2num>
  802679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80267e:	83 c4 04             	add    $0x4,%esp
  802681:	ff 75 f0             	pushl  -0x10(%ebp)
  802684:	e8 99 f0 ff ff       	call   801722 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	bb 00 00 00 00       	mov    $0x0,%ebx
  802697:	eb 2e                	jmp    8026c7 <pipe+0x141>
	sys_page_unmap(0, va);
  802699:	83 ec 08             	sub    $0x8,%esp
  80269c:	56                   	push   %esi
  80269d:	6a 00                	push   $0x0
  80269f:	e8 2b e8 ff ff       	call   800ecf <sys_page_unmap>
  8026a4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026a7:	83 ec 08             	sub    $0x8,%esp
  8026aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ad:	6a 00                	push   $0x0
  8026af:	e8 1b e8 ff ff       	call   800ecf <sys_page_unmap>
  8026b4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026b7:	83 ec 08             	sub    $0x8,%esp
  8026ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8026bd:	6a 00                	push   $0x0
  8026bf:	e8 0b e8 ff ff       	call   800ecf <sys_page_unmap>
  8026c4:	83 c4 10             	add    $0x10,%esp
}
  8026c7:	89 d8                	mov    %ebx,%eax
  8026c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026cc:	5b                   	pop    %ebx
  8026cd:	5e                   	pop    %esi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    

008026d0 <pipeisclosed>:
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d9:	50                   	push   %eax
  8026da:	ff 75 08             	pushl  0x8(%ebp)
  8026dd:	e8 b9 f0 ff ff       	call   80179b <fd_lookup>
  8026e2:	83 c4 10             	add    $0x10,%esp
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	78 18                	js     802701 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026e9:	83 ec 0c             	sub    $0xc,%esp
  8026ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ef:	e8 3e f0 ff ff       	call   801732 <fd2data>
	return _pipeisclosed(fd, p);
  8026f4:	89 c2                	mov    %eax,%edx
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	e8 2f fd ff ff       	call   80242d <_pipeisclosed>
  8026fe:	83 c4 10             	add    $0x10,%esp
}
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	c3                   	ret    

00802709 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80270f:	68 3f 32 80 00       	push   $0x80323f
  802714:	ff 75 0c             	pushl  0xc(%ebp)
  802717:	e8 3c e3 ff ff       	call   800a58 <strcpy>
	return 0;
}
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <devcons_write>:
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
  802726:	57                   	push   %edi
  802727:	56                   	push   %esi
  802728:	53                   	push   %ebx
  802729:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80272f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802734:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80273a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80273d:	73 31                	jae    802770 <devcons_write+0x4d>
		m = n - tot;
  80273f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802742:	29 f3                	sub    %esi,%ebx
  802744:	83 fb 7f             	cmp    $0x7f,%ebx
  802747:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80274c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	53                   	push   %ebx
  802753:	89 f0                	mov    %esi,%eax
  802755:	03 45 0c             	add    0xc(%ebp),%eax
  802758:	50                   	push   %eax
  802759:	57                   	push   %edi
  80275a:	e8 87 e4 ff ff       	call   800be6 <memmove>
		sys_cputs(buf, m);
  80275f:	83 c4 08             	add    $0x8,%esp
  802762:	53                   	push   %ebx
  802763:	57                   	push   %edi
  802764:	e8 25 e6 ff ff       	call   800d8e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802769:	01 de                	add    %ebx,%esi
  80276b:	83 c4 10             	add    $0x10,%esp
  80276e:	eb ca                	jmp    80273a <devcons_write+0x17>
}
  802770:	89 f0                	mov    %esi,%eax
  802772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802775:	5b                   	pop    %ebx
  802776:	5e                   	pop    %esi
  802777:	5f                   	pop    %edi
  802778:	5d                   	pop    %ebp
  802779:	c3                   	ret    

0080277a <devcons_read>:
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 08             	sub    $0x8,%esp
  802780:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802789:	74 21                	je     8027ac <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80278b:	e8 1c e6 ff ff       	call   800dac <sys_cgetc>
  802790:	85 c0                	test   %eax,%eax
  802792:	75 07                	jne    80279b <devcons_read+0x21>
		sys_yield();
  802794:	e8 92 e6 ff ff       	call   800e2b <sys_yield>
  802799:	eb f0                	jmp    80278b <devcons_read+0x11>
	if (c < 0)
  80279b:	78 0f                	js     8027ac <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80279d:	83 f8 04             	cmp    $0x4,%eax
  8027a0:	74 0c                	je     8027ae <devcons_read+0x34>
	*(char*)vbuf = c;
  8027a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a5:	88 02                	mov    %al,(%edx)
	return 1;
  8027a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    
		return 0;
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	eb f7                	jmp    8027ac <devcons_read+0x32>

008027b5 <cputchar>:
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027c1:	6a 01                	push   $0x1
  8027c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c6:	50                   	push   %eax
  8027c7:	e8 c2 e5 ff ff       	call   800d8e <sys_cputs>
}
  8027cc:	83 c4 10             	add    $0x10,%esp
  8027cf:	c9                   	leave  
  8027d0:	c3                   	ret    

008027d1 <getchar>:
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027d7:	6a 01                	push   $0x1
  8027d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027dc:	50                   	push   %eax
  8027dd:	6a 00                	push   $0x0
  8027df:	e8 27 f2 ff ff       	call   801a0b <read>
	if (r < 0)
  8027e4:	83 c4 10             	add    $0x10,%esp
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	78 06                	js     8027f1 <getchar+0x20>
	if (r < 1)
  8027eb:	74 06                	je     8027f3 <getchar+0x22>
	return c;
  8027ed:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    
		return -E_EOF;
  8027f3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027f8:	eb f7                	jmp    8027f1 <getchar+0x20>

008027fa <iscons>:
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802803:	50                   	push   %eax
  802804:	ff 75 08             	pushl  0x8(%ebp)
  802807:	e8 8f ef ff ff       	call   80179b <fd_lookup>
  80280c:	83 c4 10             	add    $0x10,%esp
  80280f:	85 c0                	test   %eax,%eax
  802811:	78 11                	js     802824 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80281c:	39 10                	cmp    %edx,(%eax)
  80281e:	0f 94 c0             	sete   %al
  802821:	0f b6 c0             	movzbl %al,%eax
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <opencons>:
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80282c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282f:	50                   	push   %eax
  802830:	e8 14 ef ff ff       	call   801749 <fd_alloc>
  802835:	83 c4 10             	add    $0x10,%esp
  802838:	85 c0                	test   %eax,%eax
  80283a:	78 3a                	js     802876 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80283c:	83 ec 04             	sub    $0x4,%esp
  80283f:	68 07 04 00 00       	push   $0x407
  802844:	ff 75 f4             	pushl  -0xc(%ebp)
  802847:	6a 00                	push   $0x0
  802849:	e8 fc e5 ff ff       	call   800e4a <sys_page_alloc>
  80284e:	83 c4 10             	add    $0x10,%esp
  802851:	85 c0                	test   %eax,%eax
  802853:	78 21                	js     802876 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80285e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80286a:	83 ec 0c             	sub    $0xc,%esp
  80286d:	50                   	push   %eax
  80286e:	e8 af ee ff ff       	call   801722 <fd2num>
  802873:	83 c4 10             	add    $0x10,%esp
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80287e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802885:	74 0a                	je     802891 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80288f:	c9                   	leave  
  802890:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	6a 07                	push   $0x7
  802896:	68 00 f0 bf ee       	push   $0xeebff000
  80289b:	6a 00                	push   $0x0
  80289d:	e8 a8 e5 ff ff       	call   800e4a <sys_page_alloc>
		if(r < 0)
  8028a2:	83 c4 10             	add    $0x10,%esp
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	78 2a                	js     8028d3 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028a9:	83 ec 08             	sub    $0x8,%esp
  8028ac:	68 e7 28 80 00       	push   $0x8028e7
  8028b1:	6a 00                	push   $0x0
  8028b3:	e8 dd e6 ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028b8:	83 c4 10             	add    $0x10,%esp
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	79 c8                	jns    802887 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 7c 32 80 00       	push   $0x80327c
  8028c7:	6a 25                	push   $0x25
  8028c9:	68 b8 32 80 00       	push   $0x8032b8
  8028ce:	e8 30 d9 ff ff       	call   800203 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028d3:	83 ec 04             	sub    $0x4,%esp
  8028d6:	68 4c 32 80 00       	push   $0x80324c
  8028db:	6a 22                	push   $0x22
  8028dd:	68 b8 32 80 00       	push   $0x8032b8
  8028e2:	e8 1c d9 ff ff       	call   800203 <_panic>

008028e7 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028e7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028e8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028ed:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028ef:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028f2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028f6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028fa:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028fd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028ff:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802903:	83 c4 08             	add    $0x8,%esp
	popal
  802906:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802907:	83 c4 04             	add    $0x4,%esp
	popfl
  80290a:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80290b:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80290c:	c3                   	ret    

0080290d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802913:	89 d0                	mov    %edx,%eax
  802915:	c1 e8 16             	shr    $0x16,%eax
  802918:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802924:	f6 c1 01             	test   $0x1,%cl
  802927:	74 1d                	je     802946 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802929:	c1 ea 0c             	shr    $0xc,%edx
  80292c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802933:	f6 c2 01             	test   $0x1,%dl
  802936:	74 0e                	je     802946 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802938:	c1 ea 0c             	shr    $0xc,%edx
  80293b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802942:	ef 
  802943:	0f b7 c0             	movzwl %ax,%eax
}
  802946:	5d                   	pop    %ebp
  802947:	c3                   	ret    
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
