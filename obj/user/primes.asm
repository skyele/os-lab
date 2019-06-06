
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
  800047:	e8 ba 15 00 00       	call   801606 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 50 80 00       	mov    0x805008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 80 2b 80 00       	push   $0x802b80
  800060:	e8 94 02 00 00       	call   8002f9 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 0a 13 00 00       	call   801374 <fork>
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
  80007b:	68 8c 2b 80 00       	push   $0x802b8c
  800080:	6a 1a                	push   $0x1a
  800082:	68 95 2b 80 00       	push   $0x802b95
  800087:	e8 77 01 00 00       	call   800203 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	51                   	push   %ecx
  800091:	57                   	push   %edi
  800092:	e8 d8 15 00 00       	call   80166f <ipc_send>
  800097:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	6a 00                	push   $0x0
  80009f:	6a 00                	push   $0x0
  8000a1:	56                   	push   %esi
  8000a2:	e8 5f 15 00 00       	call   801606 <ipc_recv>
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
  8000ba:	e8 b5 12 00 00       	call   801374 <fork>
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
  8000d2:	e8 98 15 00 00       	call   80166f <ipc_send>
	for (i = 2; ; i++)
  8000d7:	83 c3 01             	add    $0x1,%ebx
  8000da:	83 c4 10             	add    $0x10,%esp
  8000dd:	eb ed                	jmp    8000cc <umain+0x17>
		panic("fork: %e", id);
  8000df:	50                   	push   %eax
  8000e0:	68 8c 2b 80 00       	push   $0x802b8c
  8000e5:	6a 2d                	push   $0x2d
  8000e7:	68 95 2b 80 00       	push   $0x802b95
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
  800179:	68 a3 2b 80 00       	push   $0x802ba3
  80017e:	e8 76 01 00 00       	call   8002f9 <cprintf>
	cprintf("before umain\n");
  800183:	c7 04 24 c1 2b 80 00 	movl   $0x802bc1,(%esp)
  80018a:	e8 6a 01 00 00       	call   8002f9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 18 ff ff ff       	call   8000b5 <umain>
	cprintf("after umain\n");
  80019d:	c7 04 24 cf 2b 80 00 	movl   $0x802bcf,(%esp)
  8001a4:	e8 50 01 00 00       	call   8002f9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	50                   	push   %eax
  8001b5:	68 dc 2b 80 00       	push   $0x802bdc
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
  8001dd:	68 08 2c 80 00       	push   $0x802c08
  8001e2:	50                   	push   %eax
  8001e3:	68 fb 2b 80 00       	push   $0x802bfb
  8001e8:	e8 0c 01 00 00       	call   8002f9 <cprintf>
	close_all();
  8001ed:	e8 e8 16 00 00       	call   8018da <close_all>
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
  800213:	68 34 2c 80 00       	push   $0x802c34
  800218:	50                   	push   %eax
  800219:	68 fb 2b 80 00       	push   $0x802bfb
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
  80023c:	68 10 2c 80 00       	push   $0x802c10
  800241:	e8 b3 00 00 00       	call   8002f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800246:	83 c4 18             	add    $0x18,%esp
  800249:	53                   	push   %ebx
  80024a:	ff 75 10             	pushl  0x10(%ebp)
  80024d:	e8 56 00 00 00       	call   8002a8 <vcprintf>
	cprintf("\n");
  800252:	c7 04 24 bf 2b 80 00 	movl   $0x802bbf,(%esp)
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
  8003a6:	e8 85 25 00 00       	call   802930 <__udivdi3>
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
  8003cf:	e8 6c 26 00 00       	call   802a40 <__umoddi3>
  8003d4:	83 c4 14             	add    $0x14,%esp
  8003d7:	0f be 80 3b 2c 80 00 	movsbl 0x802c3b(%eax),%eax
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
  800480:	ff 24 85 20 2e 80 00 	jmp    *0x802e20(,%eax,4)
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
  80054b:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	74 18                	je     80056e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800556:	52                   	push   %edx
  800557:	68 ad 31 80 00       	push   $0x8031ad
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 a6 fe ff ff       	call   800409 <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
  800569:	e9 fe 02 00 00       	jmp    80086c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056e:	50                   	push   %eax
  80056f:	68 53 2c 80 00       	push   $0x802c53
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
  800596:	b8 4c 2c 80 00       	mov    $0x802c4c,%eax
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
  80092e:	bf 71 2d 80 00       	mov    $0x802d71,%edi
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
  80095a:	bf a9 2d 80 00       	mov    $0x802da9,%edi
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
  800dfb:	68 c8 2f 80 00       	push   $0x802fc8
  800e00:	6a 43                	push   $0x43
  800e02:	68 e5 2f 80 00       	push   $0x802fe5
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
  800e7c:	68 c8 2f 80 00       	push   $0x802fc8
  800e81:	6a 43                	push   $0x43
  800e83:	68 e5 2f 80 00       	push   $0x802fe5
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
  800ebe:	68 c8 2f 80 00       	push   $0x802fc8
  800ec3:	6a 43                	push   $0x43
  800ec5:	68 e5 2f 80 00       	push   $0x802fe5
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
  800f00:	68 c8 2f 80 00       	push   $0x802fc8
  800f05:	6a 43                	push   $0x43
  800f07:	68 e5 2f 80 00       	push   $0x802fe5
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
  800f42:	68 c8 2f 80 00       	push   $0x802fc8
  800f47:	6a 43                	push   $0x43
  800f49:	68 e5 2f 80 00       	push   $0x802fe5
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
  800f84:	68 c8 2f 80 00       	push   $0x802fc8
  800f89:	6a 43                	push   $0x43
  800f8b:	68 e5 2f 80 00       	push   $0x802fe5
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
  800fc6:	68 c8 2f 80 00       	push   $0x802fc8
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 e5 2f 80 00       	push   $0x802fe5
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
  80102a:	68 c8 2f 80 00       	push   $0x802fc8
  80102f:	6a 43                	push   $0x43
  801031:	68 e5 2f 80 00       	push   $0x802fe5
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
  80110e:	68 c8 2f 80 00       	push   $0x802fc8
  801113:	6a 43                	push   $0x43
  801115:	68 e5 2f 80 00       	push   $0x802fe5
  80111a:	e8 e4 f0 ff ff       	call   800203 <_panic>

0080111f <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	53                   	push   %ebx
  801123:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801126:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80112d:	f6 c5 04             	test   $0x4,%ch
  801130:	75 45                	jne    801177 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801132:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801139:	83 e1 07             	and    $0x7,%ecx
  80113c:	83 f9 07             	cmp    $0x7,%ecx
  80113f:	74 6f                	je     8011b0 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801141:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801148:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80114e:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801154:	0f 84 b6 00 00 00    	je     801210 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80115a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801161:	83 e1 05             	and    $0x5,%ecx
  801164:	83 f9 05             	cmp    $0x5,%ecx
  801167:	0f 84 d7 00 00 00    	je     801244 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
  801172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801175:	c9                   	leave  
  801176:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801177:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80117e:	c1 e2 0c             	shl    $0xc,%edx
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80118a:	51                   	push   %ecx
  80118b:	52                   	push   %edx
  80118c:	50                   	push   %eax
  80118d:	52                   	push   %edx
  80118e:	6a 00                	push   $0x0
  801190:	e8 f8 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801195:	83 c4 20             	add    $0x20,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	79 d1                	jns    80116d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80119c:	83 ec 04             	sub    $0x4,%esp
  80119f:	68 f3 2f 80 00       	push   $0x802ff3
  8011a4:	6a 54                	push   $0x54
  8011a6:	68 09 30 80 00       	push   $0x803009
  8011ab:	e8 53 f0 ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011b0:	89 d3                	mov    %edx,%ebx
  8011b2:	c1 e3 0c             	shl    $0xc,%ebx
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	68 05 08 00 00       	push   $0x805
  8011bd:	53                   	push   %ebx
  8011be:	50                   	push   %eax
  8011bf:	53                   	push   %ebx
  8011c0:	6a 00                	push   $0x0
  8011c2:	e8 c6 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  8011c7:	83 c4 20             	add    $0x20,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	78 2e                	js     8011fc <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	68 05 08 00 00       	push   $0x805
  8011d6:	53                   	push   %ebx
  8011d7:	6a 00                	push   $0x0
  8011d9:	53                   	push   %ebx
  8011da:	6a 00                	push   $0x0
  8011dc:	e8 ac fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  8011e1:	83 c4 20             	add    $0x20,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	79 85                	jns    80116d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011e8:	83 ec 04             	sub    $0x4,%esp
  8011eb:	68 f3 2f 80 00       	push   $0x802ff3
  8011f0:	6a 5f                	push   $0x5f
  8011f2:	68 09 30 80 00       	push   $0x803009
  8011f7:	e8 07 f0 ff ff       	call   800203 <_panic>
			panic("sys_page_map() panic\n");
  8011fc:	83 ec 04             	sub    $0x4,%esp
  8011ff:	68 f3 2f 80 00       	push   $0x802ff3
  801204:	6a 5b                	push   $0x5b
  801206:	68 09 30 80 00       	push   $0x803009
  80120b:	e8 f3 ef ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801210:	c1 e2 0c             	shl    $0xc,%edx
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	68 05 08 00 00       	push   $0x805
  80121b:	52                   	push   %edx
  80121c:	50                   	push   %eax
  80121d:	52                   	push   %edx
  80121e:	6a 00                	push   $0x0
  801220:	e8 68 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801225:	83 c4 20             	add    $0x20,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	0f 89 3d ff ff ff    	jns    80116d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	68 f3 2f 80 00       	push   $0x802ff3
  801238:	6a 66                	push   $0x66
  80123a:	68 09 30 80 00       	push   $0x803009
  80123f:	e8 bf ef ff ff       	call   800203 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801244:	c1 e2 0c             	shl    $0xc,%edx
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	6a 05                	push   $0x5
  80124c:	52                   	push   %edx
  80124d:	50                   	push   %eax
  80124e:	52                   	push   %edx
  80124f:	6a 00                	push   $0x0
  801251:	e8 37 fc ff ff       	call   800e8d <sys_page_map>
		if(r < 0)
  801256:	83 c4 20             	add    $0x20,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	0f 89 0c ff ff ff    	jns    80116d <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	68 f3 2f 80 00       	push   $0x802ff3
  801269:	6a 6d                	push   $0x6d
  80126b:	68 09 30 80 00       	push   $0x803009
  801270:	e8 8e ef ff ff       	call   800203 <_panic>

00801275 <pgfault>:
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	53                   	push   %ebx
  801279:	83 ec 04             	sub    $0x4,%esp
  80127c:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80127f:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801281:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801285:	0f 84 99 00 00 00    	je     801324 <pgfault+0xaf>
  80128b:	89 c2                	mov    %eax,%edx
  80128d:	c1 ea 16             	shr    $0x16,%edx
  801290:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801297:	f6 c2 01             	test   $0x1,%dl
  80129a:	0f 84 84 00 00 00    	je     801324 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	c1 ea 0c             	shr    $0xc,%edx
  8012a5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ac:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012b2:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012b8:	75 6a                	jne    801324 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012bf:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	6a 07                	push   $0x7
  8012c6:	68 00 f0 7f 00       	push   $0x7ff000
  8012cb:	6a 00                	push   $0x0
  8012cd:	e8 78 fb ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 5f                	js     801338 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	68 00 10 00 00       	push   $0x1000
  8012e1:	53                   	push   %ebx
  8012e2:	68 00 f0 7f 00       	push   $0x7ff000
  8012e7:	e8 5c f9 ff ff       	call   800c48 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8012ec:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012f3:	53                   	push   %ebx
  8012f4:	6a 00                	push   $0x0
  8012f6:	68 00 f0 7f 00       	push   $0x7ff000
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 8b fb ff ff       	call   800e8d <sys_page_map>
	if(ret < 0)
  801302:	83 c4 20             	add    $0x20,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 43                	js     80134c <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	68 00 f0 7f 00       	push   $0x7ff000
  801311:	6a 00                	push   $0x0
  801313:	e8 b7 fb ff ff       	call   800ecf <sys_page_unmap>
	if(ret < 0)
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 41                	js     801360 <pgfault+0xeb>
}
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    
		panic("panic at pgfault()\n");
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	68 14 30 80 00       	push   $0x803014
  80132c:	6a 26                	push   $0x26
  80132e:	68 09 30 80 00       	push   $0x803009
  801333:	e8 cb ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_alloc()\n");
  801338:	83 ec 04             	sub    $0x4,%esp
  80133b:	68 28 30 80 00       	push   $0x803028
  801340:	6a 31                	push   $0x31
  801342:	68 09 30 80 00       	push   $0x803009
  801347:	e8 b7 ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_map()\n");
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	68 43 30 80 00       	push   $0x803043
  801354:	6a 36                	push   $0x36
  801356:	68 09 30 80 00       	push   $0x803009
  80135b:	e8 a3 ee ff ff       	call   800203 <_panic>
		panic("panic in sys_page_unmap()\n");
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	68 5c 30 80 00       	push   $0x80305c
  801368:	6a 39                	push   $0x39
  80136a:	68 09 30 80 00       	push   $0x803009
  80136f:	e8 8f ee ff ff       	call   800203 <_panic>

00801374 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	57                   	push   %edi
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
  80137a:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80137d:	68 75 12 80 00       	push   $0x801275
  801382:	e8 d1 14 00 00       	call   802858 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801387:	b8 07 00 00 00       	mov    $0x7,%eax
  80138c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 27                	js     8013bc <fork+0x48>
  801395:	89 c6                	mov    %eax,%esi
  801397:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801399:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80139e:	75 48                	jne    8013e8 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013a0:	e8 67 fa ff ff       	call   800e0c <sys_getenvid>
  8013a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013aa:	c1 e0 07             	shl    $0x7,%eax
  8013ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013b2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013b7:	e9 90 00 00 00       	jmp    80144c <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 78 30 80 00       	push   $0x803078
  8013c4:	68 8c 00 00 00       	push   $0x8c
  8013c9:	68 09 30 80 00       	push   $0x803009
  8013ce:	e8 30 ee ff ff       	call   800203 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  8013d3:	89 f8                	mov    %edi,%eax
  8013d5:	e8 45 fd ff ff       	call   80111f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013da:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013e0:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013e6:	74 26                	je     80140e <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  8013e8:	89 d8                	mov    %ebx,%eax
  8013ea:	c1 e8 16             	shr    $0x16,%eax
  8013ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f4:	a8 01                	test   $0x1,%al
  8013f6:	74 e2                	je     8013da <fork+0x66>
  8013f8:	89 da                	mov    %ebx,%edx
  8013fa:	c1 ea 0c             	shr    $0xc,%edx
  8013fd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801404:	83 e0 05             	and    $0x5,%eax
  801407:	83 f8 05             	cmp    $0x5,%eax
  80140a:	75 ce                	jne    8013da <fork+0x66>
  80140c:	eb c5                	jmp    8013d3 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	6a 07                	push   $0x7
  801413:	68 00 f0 bf ee       	push   $0xeebff000
  801418:	56                   	push   %esi
  801419:	e8 2c fa ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 31                	js     801456 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	68 c7 28 80 00       	push   $0x8028c7
  80142d:	56                   	push   %esi
  80142e:	e8 62 fb ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 33                	js     80146d <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80143a:	83 ec 08             	sub    $0x8,%esp
  80143d:	6a 02                	push   $0x2
  80143f:	56                   	push   %esi
  801440:	e8 cc fa ff ff       	call   800f11 <sys_env_set_status>
	if(ret < 0)
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	78 38                	js     801484 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80144c:	89 f0                	mov    %esi,%eax
  80144e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801451:	5b                   	pop    %ebx
  801452:	5e                   	pop    %esi
  801453:	5f                   	pop    %edi
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	68 28 30 80 00       	push   $0x803028
  80145e:	68 98 00 00 00       	push   $0x98
  801463:	68 09 30 80 00       	push   $0x803009
  801468:	e8 96 ed ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	68 9c 30 80 00       	push   $0x80309c
  801475:	68 9b 00 00 00       	push   $0x9b
  80147a:	68 09 30 80 00       	push   $0x803009
  80147f:	e8 7f ed ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_status()\n");
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	68 c4 30 80 00       	push   $0x8030c4
  80148c:	68 9e 00 00 00       	push   $0x9e
  801491:	68 09 30 80 00       	push   $0x803009
  801496:	e8 68 ed ff ff       	call   800203 <_panic>

0080149b <sfork>:

// Challenge!
int
sfork(void)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	57                   	push   %edi
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
  8014a1:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014a4:	68 75 12 80 00       	push   $0x801275
  8014a9:	e8 aa 13 00 00       	call   802858 <set_pgfault_handler>
  8014ae:	b8 07 00 00 00       	mov    $0x7,%eax
  8014b3:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	78 27                	js     8014e3 <sfork+0x48>
  8014bc:	89 c7                	mov    %eax,%edi
  8014be:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014c0:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014c5:	75 55                	jne    80151c <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014c7:	e8 40 f9 ff ff       	call   800e0c <sys_getenvid>
  8014cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014d1:	c1 e0 07             	shl    $0x7,%eax
  8014d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014d9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014de:	e9 d4 00 00 00       	jmp    8015b7 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	68 78 30 80 00       	push   $0x803078
  8014eb:	68 af 00 00 00       	push   $0xaf
  8014f0:	68 09 30 80 00       	push   $0x803009
  8014f5:	e8 09 ed ff ff       	call   800203 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014fa:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014ff:	89 f0                	mov    %esi,%eax
  801501:	e8 19 fc ff ff       	call   80111f <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801506:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80150c:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801512:	77 65                	ja     801579 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801514:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80151a:	74 de                	je     8014fa <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80151c:	89 d8                	mov    %ebx,%eax
  80151e:	c1 e8 16             	shr    $0x16,%eax
  801521:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801528:	a8 01                	test   $0x1,%al
  80152a:	74 da                	je     801506 <sfork+0x6b>
  80152c:	89 da                	mov    %ebx,%edx
  80152e:	c1 ea 0c             	shr    $0xc,%edx
  801531:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801538:	83 e0 05             	and    $0x5,%eax
  80153b:	83 f8 05             	cmp    $0x5,%eax
  80153e:	75 c6                	jne    801506 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801540:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801547:	c1 e2 0c             	shl    $0xc,%edx
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	83 e0 07             	and    $0x7,%eax
  801550:	50                   	push   %eax
  801551:	52                   	push   %edx
  801552:	56                   	push   %esi
  801553:	52                   	push   %edx
  801554:	6a 00                	push   $0x0
  801556:	e8 32 f9 ff ff       	call   800e8d <sys_page_map>
  80155b:	83 c4 20             	add    $0x20,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	74 a4                	je     801506 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	68 f3 2f 80 00       	push   $0x802ff3
  80156a:	68 ba 00 00 00       	push   $0xba
  80156f:	68 09 30 80 00       	push   $0x803009
  801574:	e8 8a ec ff ff       	call   800203 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	6a 07                	push   $0x7
  80157e:	68 00 f0 bf ee       	push   $0xeebff000
  801583:	57                   	push   %edi
  801584:	e8 c1 f8 ff ff       	call   800e4a <sys_page_alloc>
	if(ret < 0)
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 31                	js     8015c1 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	68 c7 28 80 00       	push   $0x8028c7
  801598:	57                   	push   %edi
  801599:	e8 f7 f9 ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 33                	js     8015d8 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	6a 02                	push   $0x2
  8015aa:	57                   	push   %edi
  8015ab:	e8 61 f9 ff ff       	call   800f11 <sys_env_set_status>
	if(ret < 0)
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	78 38                	js     8015ef <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015b7:	89 f8                	mov    %edi,%eax
  8015b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015bc:	5b                   	pop    %ebx
  8015bd:	5e                   	pop    %esi
  8015be:	5f                   	pop    %edi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 28 30 80 00       	push   $0x803028
  8015c9:	68 c0 00 00 00       	push   $0xc0
  8015ce:	68 09 30 80 00       	push   $0x803009
  8015d3:	e8 2b ec ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 9c 30 80 00       	push   $0x80309c
  8015e0:	68 c3 00 00 00       	push   $0xc3
  8015e5:	68 09 30 80 00       	push   $0x803009
  8015ea:	e8 14 ec ff ff       	call   800203 <_panic>
		panic("panic in sys_env_set_status()\n");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 c4 30 80 00       	push   $0x8030c4
  8015f7:	68 c6 00 00 00       	push   $0xc6
  8015fc:	68 09 30 80 00       	push   $0x803009
  801601:	e8 fd eb ff ff       	call   800203 <_panic>

00801606 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	56                   	push   %esi
  80160a:	53                   	push   %ebx
  80160b:	8b 75 08             	mov    0x8(%ebp),%esi
  80160e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801611:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801614:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801616:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80161b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	50                   	push   %eax
  801622:	e8 d3 f9 ff ff       	call   800ffa <sys_ipc_recv>
	if(ret < 0){
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 2b                	js     801659 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80162e:	85 f6                	test   %esi,%esi
  801630:	74 0a                	je     80163c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  801632:	a1 08 50 80 00       	mov    0x805008,%eax
  801637:	8b 40 74             	mov    0x74(%eax),%eax
  80163a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80163c:	85 db                	test   %ebx,%ebx
  80163e:	74 0a                	je     80164a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801640:	a1 08 50 80 00       	mov    0x805008,%eax
  801645:	8b 40 78             	mov    0x78(%eax),%eax
  801648:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80164a:	a1 08 50 80 00       	mov    0x805008,%eax
  80164f:	8b 40 70             	mov    0x70(%eax),%eax
}
  801652:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    
		if(from_env_store)
  801659:	85 f6                	test   %esi,%esi
  80165b:	74 06                	je     801663 <ipc_recv+0x5d>
			*from_env_store = 0;
  80165d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801663:	85 db                	test   %ebx,%ebx
  801665:	74 eb                	je     801652 <ipc_recv+0x4c>
			*perm_store = 0;
  801667:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80166d:	eb e3                	jmp    801652 <ipc_recv+0x4c>

0080166f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80167e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801681:	85 db                	test   %ebx,%ebx
  801683:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801688:	0f 44 d8             	cmove  %eax,%ebx
  80168b:	eb 05                	jmp    801692 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80168d:	e8 99 f7 ff ff       	call   800e2b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801692:	ff 75 14             	pushl  0x14(%ebp)
  801695:	53                   	push   %ebx
  801696:	56                   	push   %esi
  801697:	57                   	push   %edi
  801698:	e8 3a f9 ff ff       	call   800fd7 <sys_ipc_try_send>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	74 1b                	je     8016bf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016a4:	79 e7                	jns    80168d <ipc_send+0x1e>
  8016a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016a9:	74 e2                	je     80168d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 e3 30 80 00       	push   $0x8030e3
  8016b3:	6a 46                	push   $0x46
  8016b5:	68 f8 30 80 00       	push   $0x8030f8
  8016ba:	e8 44 eb ff ff       	call   800203 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	c1 e2 07             	shl    $0x7,%edx
  8016d7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8016dd:	8b 52 50             	mov    0x50(%edx),%edx
  8016e0:	39 ca                	cmp    %ecx,%edx
  8016e2:	74 11                	je     8016f5 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8016e4:	83 c0 01             	add    $0x1,%eax
  8016e7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8016ec:	75 e4                	jne    8016d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f3:	eb 0b                	jmp    801700 <ipc_find_env+0x39>
			return envs[i].env_id;
  8016f5:	c1 e0 07             	shl    $0x7,%eax
  8016f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016fd:	8b 40 48             	mov    0x48(%eax),%eax
}
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    

00801702 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	05 00 00 00 30       	add    $0x30000000,%eax
  80170d:	c1 e8 0c             	shr    $0xc,%eax
}
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    

00801712 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80171d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801722:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801731:	89 c2                	mov    %eax,%edx
  801733:	c1 ea 16             	shr    $0x16,%edx
  801736:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80173d:	f6 c2 01             	test   $0x1,%dl
  801740:	74 2d                	je     80176f <fd_alloc+0x46>
  801742:	89 c2                	mov    %eax,%edx
  801744:	c1 ea 0c             	shr    $0xc,%edx
  801747:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174e:	f6 c2 01             	test   $0x1,%dl
  801751:	74 1c                	je     80176f <fd_alloc+0x46>
  801753:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801758:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80175d:	75 d2                	jne    801731 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801768:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80176d:	eb 0a                	jmp    801779 <fd_alloc+0x50>
			*fd_store = fd;
  80176f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801772:	89 01                	mov    %eax,(%ecx)
			return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801781:	83 f8 1f             	cmp    $0x1f,%eax
  801784:	77 30                	ja     8017b6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801786:	c1 e0 0c             	shl    $0xc,%eax
  801789:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80178e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801794:	f6 c2 01             	test   $0x1,%dl
  801797:	74 24                	je     8017bd <fd_lookup+0x42>
  801799:	89 c2                	mov    %eax,%edx
  80179b:	c1 ea 0c             	shr    $0xc,%edx
  80179e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a5:	f6 c2 01             	test   $0x1,%dl
  8017a8:	74 1a                	je     8017c4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	89 02                	mov    %eax,(%edx)
	return 0;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    
		return -E_INVAL;
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bb:	eb f7                	jmp    8017b4 <fd_lookup+0x39>
		return -E_INVAL;
  8017bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c2:	eb f0                	jmp    8017b4 <fd_lookup+0x39>
  8017c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c9:	eb e9                	jmp    8017b4 <fd_lookup+0x39>

008017cb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8017de:	39 08                	cmp    %ecx,(%eax)
  8017e0:	74 38                	je     80181a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8017e2:	83 c2 01             	add    $0x1,%edx
  8017e5:	8b 04 95 80 31 80 00 	mov    0x803180(,%edx,4),%eax
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	75 ee                	jne    8017de <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8017f0:	a1 08 50 80 00       	mov    0x805008,%eax
  8017f5:	8b 40 48             	mov    0x48(%eax),%eax
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	51                   	push   %ecx
  8017fc:	50                   	push   %eax
  8017fd:	68 04 31 80 00       	push   $0x803104
  801802:	e8 f2 ea ff ff       	call   8002f9 <cprintf>
	*dev = 0;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    
			*dev = devtab[i];
  80181a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80181f:	b8 00 00 00 00       	mov    $0x0,%eax
  801824:	eb f2                	jmp    801818 <dev_lookup+0x4d>

00801826 <fd_close>:
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	57                   	push   %edi
  80182a:	56                   	push   %esi
  80182b:	53                   	push   %ebx
  80182c:	83 ec 24             	sub    $0x24,%esp
  80182f:	8b 75 08             	mov    0x8(%ebp),%esi
  801832:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801835:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801838:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801839:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80183f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801842:	50                   	push   %eax
  801843:	e8 33 ff ff ff       	call   80177b <fd_lookup>
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 05                	js     801856 <fd_close+0x30>
	    || fd != fd2)
  801851:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801854:	74 16                	je     80186c <fd_close+0x46>
		return (must_exist ? r : 0);
  801856:	89 f8                	mov    %edi,%eax
  801858:	84 c0                	test   %al,%al
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
  80185f:	0f 44 d8             	cmove  %eax,%ebx
}
  801862:	89 d8                	mov    %ebx,%eax
  801864:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801867:	5b                   	pop    %ebx
  801868:	5e                   	pop    %esi
  801869:	5f                   	pop    %edi
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801872:	50                   	push   %eax
  801873:	ff 36                	pushl  (%esi)
  801875:	e8 51 ff ff ff       	call   8017cb <dev_lookup>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 1a                	js     80189d <fd_close+0x77>
		if (dev->dev_close)
  801883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801886:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801889:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80188e:	85 c0                	test   %eax,%eax
  801890:	74 0b                	je     80189d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	56                   	push   %esi
  801896:	ff d0                	call   *%eax
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	56                   	push   %esi
  8018a1:	6a 00                	push   $0x0
  8018a3:	e8 27 f6 ff ff       	call   800ecf <sys_page_unmap>
	return r;
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb b5                	jmp    801862 <fd_close+0x3c>

008018ad <close>:

int
close(int fdnum)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b6:	50                   	push   %eax
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	e8 bc fe ff ff       	call   80177b <fd_lookup>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	79 02                	jns    8018c8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    
		return fd_close(fd, 1);
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	6a 01                	push   $0x1
  8018cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d0:	e8 51 ff ff ff       	call   801826 <fd_close>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	eb ec                	jmp    8018c6 <close+0x19>

008018da <close_all>:

void
close_all(void)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018e6:	83 ec 0c             	sub    $0xc,%esp
  8018e9:	53                   	push   %ebx
  8018ea:	e8 be ff ff ff       	call   8018ad <close>
	for (i = 0; i < MAXFD; i++)
  8018ef:	83 c3 01             	add    $0x1,%ebx
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	83 fb 20             	cmp    $0x20,%ebx
  8018f8:	75 ec                	jne    8018e6 <close_all+0xc>
}
  8018fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	57                   	push   %edi
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801908:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80190b:	50                   	push   %eax
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	e8 67 fe ff ff       	call   80177b <fd_lookup>
  801914:	89 c3                	mov    %eax,%ebx
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	0f 88 81 00 00 00    	js     8019a2 <dup+0xa3>
		return r;
	close(newfdnum);
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	e8 81 ff ff ff       	call   8018ad <close>

	newfd = INDEX2FD(newfdnum);
  80192c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80192f:	c1 e6 0c             	shl    $0xc,%esi
  801932:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801938:	83 c4 04             	add    $0x4,%esp
  80193b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80193e:	e8 cf fd ff ff       	call   801712 <fd2data>
  801943:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801945:	89 34 24             	mov    %esi,(%esp)
  801948:	e8 c5 fd ff ff       	call   801712 <fd2data>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801952:	89 d8                	mov    %ebx,%eax
  801954:	c1 e8 16             	shr    $0x16,%eax
  801957:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80195e:	a8 01                	test   $0x1,%al
  801960:	74 11                	je     801973 <dup+0x74>
  801962:	89 d8                	mov    %ebx,%eax
  801964:	c1 e8 0c             	shr    $0xc,%eax
  801967:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80196e:	f6 c2 01             	test   $0x1,%dl
  801971:	75 39                	jne    8019ac <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801973:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801976:	89 d0                	mov    %edx,%eax
  801978:	c1 e8 0c             	shr    $0xc,%eax
  80197b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	25 07 0e 00 00       	and    $0xe07,%eax
  80198a:	50                   	push   %eax
  80198b:	56                   	push   %esi
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	6a 00                	push   $0x0
  801991:	e8 f7 f4 ff ff       	call   800e8d <sys_page_map>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	83 c4 20             	add    $0x20,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 31                	js     8019d0 <dup+0xd1>
		goto err;

	return newfdnum;
  80199f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019a2:	89 d8                	mov    %ebx,%eax
  8019a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019a7:	5b                   	pop    %ebx
  8019a8:	5e                   	pop    %esi
  8019a9:	5f                   	pop    %edi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8019bb:	50                   	push   %eax
  8019bc:	57                   	push   %edi
  8019bd:	6a 00                	push   $0x0
  8019bf:	53                   	push   %ebx
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 c6 f4 ff ff       	call   800e8d <sys_page_map>
  8019c7:	89 c3                	mov    %eax,%ebx
  8019c9:	83 c4 20             	add    $0x20,%esp
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	79 a3                	jns    801973 <dup+0x74>
	sys_page_unmap(0, newfd);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	56                   	push   %esi
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 f4 f4 ff ff       	call   800ecf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8019db:	83 c4 08             	add    $0x8,%esp
  8019de:	57                   	push   %edi
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 e9 f4 ff ff       	call   800ecf <sys_page_unmap>
	return r;
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	eb b7                	jmp    8019a2 <dup+0xa3>

008019eb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 1c             	sub    $0x1c,%esp
  8019f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	53                   	push   %ebx
  8019fa:	e8 7c fd ff ff       	call   80177b <fd_lookup>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 3f                	js     801a45 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0c:	50                   	push   %eax
  801a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a10:	ff 30                	pushl  (%eax)
  801a12:	e8 b4 fd ff ff       	call   8017cb <dev_lookup>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 27                	js     801a45 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a21:	8b 42 08             	mov    0x8(%edx),%eax
  801a24:	83 e0 03             	and    $0x3,%eax
  801a27:	83 f8 01             	cmp    $0x1,%eax
  801a2a:	74 1e                	je     801a4a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2f:	8b 40 08             	mov    0x8(%eax),%eax
  801a32:	85 c0                	test   %eax,%eax
  801a34:	74 35                	je     801a6b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	52                   	push   %edx
  801a40:	ff d0                	call   *%eax
  801a42:	83 c4 10             	add    $0x10,%esp
}
  801a45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a4a:	a1 08 50 80 00       	mov    0x805008,%eax
  801a4f:	8b 40 48             	mov    0x48(%eax),%eax
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	53                   	push   %ebx
  801a56:	50                   	push   %eax
  801a57:	68 45 31 80 00       	push   $0x803145
  801a5c:	e8 98 e8 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a69:	eb da                	jmp    801a45 <read+0x5a>
		return -E_NOT_SUPP;
  801a6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a70:	eb d3                	jmp    801a45 <read+0x5a>

00801a72 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a7e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a86:	39 f3                	cmp    %esi,%ebx
  801a88:	73 23                	jae    801aad <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	89 f0                	mov    %esi,%eax
  801a8f:	29 d8                	sub    %ebx,%eax
  801a91:	50                   	push   %eax
  801a92:	89 d8                	mov    %ebx,%eax
  801a94:	03 45 0c             	add    0xc(%ebp),%eax
  801a97:	50                   	push   %eax
  801a98:	57                   	push   %edi
  801a99:	e8 4d ff ff ff       	call   8019eb <read>
		if (m < 0)
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 06                	js     801aab <readn+0x39>
			return m;
		if (m == 0)
  801aa5:	74 06                	je     801aad <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801aa7:	01 c3                	add    %eax,%ebx
  801aa9:	eb db                	jmp    801a86 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aab:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5e                   	pop    %esi
  801ab4:	5f                   	pop    %edi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	53                   	push   %ebx
  801abb:	83 ec 1c             	sub    $0x1c,%esp
  801abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac4:	50                   	push   %eax
  801ac5:	53                   	push   %ebx
  801ac6:	e8 b0 fc ff ff       	call   80177b <fd_lookup>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 3a                	js     801b0c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad8:	50                   	push   %eax
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adc:	ff 30                	pushl  (%eax)
  801ade:	e8 e8 fc ff ff       	call   8017cb <dev_lookup>
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 22                	js     801b0c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801af1:	74 1e                	je     801b11 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af6:	8b 52 0c             	mov    0xc(%edx),%edx
  801af9:	85 d2                	test   %edx,%edx
  801afb:	74 35                	je     801b32 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	ff 75 10             	pushl  0x10(%ebp)
  801b03:	ff 75 0c             	pushl  0xc(%ebp)
  801b06:	50                   	push   %eax
  801b07:	ff d2                	call   *%edx
  801b09:	83 c4 10             	add    $0x10,%esp
}
  801b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b11:	a1 08 50 80 00       	mov    0x805008,%eax
  801b16:	8b 40 48             	mov    0x48(%eax),%eax
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	53                   	push   %ebx
  801b1d:	50                   	push   %eax
  801b1e:	68 61 31 80 00       	push   $0x803161
  801b23:	e8 d1 e7 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b30:	eb da                	jmp    801b0c <write+0x55>
		return -E_NOT_SUPP;
  801b32:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b37:	eb d3                	jmp    801b0c <write+0x55>

00801b39 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b42:	50                   	push   %eax
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	e8 30 fc ff ff       	call   80177b <fd_lookup>
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 0e                	js     801b60 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b58:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	53                   	push   %ebx
  801b66:	83 ec 1c             	sub    $0x1c,%esp
  801b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b6c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b6f:	50                   	push   %eax
  801b70:	53                   	push   %ebx
  801b71:	e8 05 fc ff ff       	call   80177b <fd_lookup>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 37                	js     801bb4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b83:	50                   	push   %eax
  801b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b87:	ff 30                	pushl  (%eax)
  801b89:	e8 3d fc ff ff       	call   8017cb <dev_lookup>
  801b8e:	83 c4 10             	add    $0x10,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 1f                	js     801bb4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b98:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b9c:	74 1b                	je     801bb9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba1:	8b 52 18             	mov    0x18(%edx),%edx
  801ba4:	85 d2                	test   %edx,%edx
  801ba6:	74 32                	je     801bda <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	ff d2                	call   *%edx
  801bb1:	83 c4 10             	add    $0x10,%esp
}
  801bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bb9:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bbe:	8b 40 48             	mov    0x48(%eax),%eax
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	53                   	push   %ebx
  801bc5:	50                   	push   %eax
  801bc6:	68 24 31 80 00       	push   $0x803124
  801bcb:	e8 29 e7 ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb da                	jmp    801bb4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801bda:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bdf:	eb d3                	jmp    801bb4 <ftruncate+0x52>

00801be1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 1c             	sub    $0x1c,%esp
  801be8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801beb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	e8 84 fb ff ff       	call   80177b <fd_lookup>
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 4b                	js     801c49 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c08:	ff 30                	pushl  (%eax)
  801c0a:	e8 bc fb ff ff       	call   8017cb <dev_lookup>
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 33                	js     801c49 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c19:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c1d:	74 2f                	je     801c4e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c1f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c22:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c29:	00 00 00 
	stat->st_isdir = 0;
  801c2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c33:	00 00 00 
	stat->st_dev = dev;
  801c36:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	53                   	push   %ebx
  801c40:	ff 75 f0             	pushl  -0x10(%ebp)
  801c43:	ff 50 14             	call   *0x14(%eax)
  801c46:	83 c4 10             	add    $0x10,%esp
}
  801c49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    
		return -E_NOT_SUPP;
  801c4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c53:	eb f4                	jmp    801c49 <fstat+0x68>

00801c55 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	56                   	push   %esi
  801c59:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c5a:	83 ec 08             	sub    $0x8,%esp
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 08             	pushl  0x8(%ebp)
  801c62:	e8 22 02 00 00       	call   801e89 <open>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 1b                	js     801c8b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c70:	83 ec 08             	sub    $0x8,%esp
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	50                   	push   %eax
  801c77:	e8 65 ff ff ff       	call   801be1 <fstat>
  801c7c:	89 c6                	mov    %eax,%esi
	close(fd);
  801c7e:	89 1c 24             	mov    %ebx,(%esp)
  801c81:	e8 27 fc ff ff       	call   8018ad <close>
	return r;
  801c86:	83 c4 10             	add    $0x10,%esp
  801c89:	89 f3                	mov    %esi,%ebx
}
  801c8b:	89 d8                	mov    %ebx,%eax
  801c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    

00801c94 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	56                   	push   %esi
  801c98:	53                   	push   %ebx
  801c99:	89 c6                	mov    %eax,%esi
  801c9b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c9d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ca4:	74 27                	je     801ccd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ca6:	6a 07                	push   $0x7
  801ca8:	68 00 60 80 00       	push   $0x806000
  801cad:	56                   	push   %esi
  801cae:	ff 35 00 50 80 00    	pushl  0x805000
  801cb4:	e8 b6 f9 ff ff       	call   80166f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cb9:	83 c4 0c             	add    $0xc,%esp
  801cbc:	6a 00                	push   $0x0
  801cbe:	53                   	push   %ebx
  801cbf:	6a 00                	push   $0x0
  801cc1:	e8 40 f9 ff ff       	call   801606 <ipc_recv>
}
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	6a 01                	push   $0x1
  801cd2:	e8 f0 f9 ff ff       	call   8016c7 <ipc_find_env>
  801cd7:	a3 00 50 80 00       	mov    %eax,0x805000
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	eb c5                	jmp    801ca6 <fsipc+0x12>

00801ce1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ced:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801cff:	b8 02 00 00 00       	mov    $0x2,%eax
  801d04:	e8 8b ff ff ff       	call   801c94 <fsipc>
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <devfile_flush>:
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	8b 40 0c             	mov    0xc(%eax),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d21:	b8 06 00 00 00       	mov    $0x6,%eax
  801d26:	e8 69 ff ff ff       	call   801c94 <fsipc>
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <devfile_stat>:
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3d:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d42:	ba 00 00 00 00       	mov    $0x0,%edx
  801d47:	b8 05 00 00 00       	mov    $0x5,%eax
  801d4c:	e8 43 ff ff ff       	call   801c94 <fsipc>
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 2c                	js     801d81 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	68 00 60 80 00       	push   $0x806000
  801d5d:	53                   	push   %ebx
  801d5e:	e8 f5 ec ff ff       	call   800a58 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d63:	a1 80 60 80 00       	mov    0x806080,%eax
  801d68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d6e:	a1 84 60 80 00       	mov    0x806084,%eax
  801d73:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <devfile_write>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	53                   	push   %ebx
  801d8a:	83 ec 08             	sub    $0x8,%esp
  801d8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	8b 40 0c             	mov    0xc(%eax),%eax
  801d96:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d9b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801da1:	53                   	push   %ebx
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	68 08 60 80 00       	push   $0x806008
  801daa:	e8 99 ee ff ff       	call   800c48 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801daf:	ba 00 00 00 00       	mov    $0x0,%edx
  801db4:	b8 04 00 00 00       	mov    $0x4,%eax
  801db9:	e8 d6 fe ff ff       	call   801c94 <fsipc>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	78 0b                	js     801dd0 <devfile_write+0x4a>
	assert(r <= n);
  801dc5:	39 d8                	cmp    %ebx,%eax
  801dc7:	77 0c                	ja     801dd5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801dc9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dce:	7f 1e                	jg     801dee <devfile_write+0x68>
}
  801dd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    
	assert(r <= n);
  801dd5:	68 94 31 80 00       	push   $0x803194
  801dda:	68 9b 31 80 00       	push   $0x80319b
  801ddf:	68 98 00 00 00       	push   $0x98
  801de4:	68 b0 31 80 00       	push   $0x8031b0
  801de9:	e8 15 e4 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  801dee:	68 bb 31 80 00       	push   $0x8031bb
  801df3:	68 9b 31 80 00       	push   $0x80319b
  801df8:	68 99 00 00 00       	push   $0x99
  801dfd:	68 b0 31 80 00       	push   $0x8031b0
  801e02:	e8 fc e3 ff ff       	call   800203 <_panic>

00801e07 <devfile_read>:
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	8b 40 0c             	mov    0xc(%eax),%eax
  801e15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e1a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	b8 03 00 00 00       	mov    $0x3,%eax
  801e2a:	e8 65 fe ff ff       	call   801c94 <fsipc>
  801e2f:	89 c3                	mov    %eax,%ebx
  801e31:	85 c0                	test   %eax,%eax
  801e33:	78 1f                	js     801e54 <devfile_read+0x4d>
	assert(r <= n);
  801e35:	39 f0                	cmp    %esi,%eax
  801e37:	77 24                	ja     801e5d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e3e:	7f 33                	jg     801e73 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	50                   	push   %eax
  801e44:	68 00 60 80 00       	push   $0x806000
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	e8 95 ed ff ff       	call   800be6 <memmove>
	return r;
  801e51:	83 c4 10             	add    $0x10,%esp
}
  801e54:	89 d8                	mov    %ebx,%eax
  801e56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e59:	5b                   	pop    %ebx
  801e5a:	5e                   	pop    %esi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
	assert(r <= n);
  801e5d:	68 94 31 80 00       	push   $0x803194
  801e62:	68 9b 31 80 00       	push   $0x80319b
  801e67:	6a 7c                	push   $0x7c
  801e69:	68 b0 31 80 00       	push   $0x8031b0
  801e6e:	e8 90 e3 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  801e73:	68 bb 31 80 00       	push   $0x8031bb
  801e78:	68 9b 31 80 00       	push   $0x80319b
  801e7d:	6a 7d                	push   $0x7d
  801e7f:	68 b0 31 80 00       	push   $0x8031b0
  801e84:	e8 7a e3 ff ff       	call   800203 <_panic>

00801e89 <open>:
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 1c             	sub    $0x1c,%esp
  801e91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e94:	56                   	push   %esi
  801e95:	e8 85 eb ff ff       	call   800a1f <strlen>
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea2:	7f 6c                	jg     801f10 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	e8 79 f8 ff ff       	call   801729 <fd_alloc>
  801eb0:	89 c3                	mov    %eax,%ebx
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 3c                	js     801ef5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	56                   	push   %esi
  801ebd:	68 00 60 80 00       	push   $0x806000
  801ec2:	e8 91 eb ff ff       	call   800a58 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	e8 b8 fd ff ff       	call   801c94 <fsipc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	78 19                	js     801efe <open+0x75>
	return fd2num(fd);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  801eeb:	e8 12 f8 ff ff       	call   801702 <fd2num>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
}
  801ef5:	89 d8                	mov    %ebx,%eax
  801ef7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5e                   	pop    %esi
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    
		fd_close(fd, 0);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 f4             	pushl  -0xc(%ebp)
  801f06:	e8 1b f9 ff ff       	call   801826 <fd_close>
		return r;
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	eb e5                	jmp    801ef5 <open+0x6c>
		return -E_BAD_PATH;
  801f10:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f15:	eb de                	jmp    801ef5 <open+0x6c>

00801f17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f22:	b8 08 00 00 00       	mov    $0x8,%eax
  801f27:	e8 68 fd ff ff       	call   801c94 <fsipc>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f34:	68 c7 31 80 00       	push   $0x8031c7
  801f39:	ff 75 0c             	pushl  0xc(%ebp)
  801f3c:	e8 17 eb ff ff       	call   800a58 <strcpy>
	return 0;
}
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <devsock_close>:
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	53                   	push   %ebx
  801f4c:	83 ec 10             	sub    $0x10,%esp
  801f4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f52:	53                   	push   %ebx
  801f53:	e8 95 09 00 00       	call   8028ed <pageref>
  801f58:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f5b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f60:	83 f8 01             	cmp    $0x1,%eax
  801f63:	74 07                	je     801f6c <devsock_close+0x24>
}
  801f65:	89 d0                	mov    %edx,%eax
  801f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	ff 73 0c             	pushl  0xc(%ebx)
  801f72:	e8 b9 02 00 00       	call   802230 <nsipc_close>
  801f77:	89 c2                	mov    %eax,%edx
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	eb e7                	jmp    801f65 <devsock_close+0x1d>

00801f7e <devsock_write>:
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 10             	pushl  0x10(%ebp)
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	ff 70 0c             	pushl  0xc(%eax)
  801f92:	e8 76 03 00 00       	call   80230d <nsipc_send>
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <devsock_read>:
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f9f:	6a 00                	push   $0x0
  801fa1:	ff 75 10             	pushl  0x10(%ebp)
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	ff 70 0c             	pushl  0xc(%eax)
  801fad:	e8 ef 02 00 00       	call   8022a1 <nsipc_recv>
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <fd2sockid>:
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fba:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fbd:	52                   	push   %edx
  801fbe:	50                   	push   %eax
  801fbf:	e8 b7 f7 ff ff       	call   80177b <fd_lookup>
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 10                	js     801fdb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fd4:	39 08                	cmp    %ecx,(%eax)
  801fd6:	75 05                	jne    801fdd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fd8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    
		return -E_NOT_SUPP;
  801fdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fe2:	eb f7                	jmp    801fdb <fd2sockid+0x27>

00801fe4 <alloc_sockfd>:
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	56                   	push   %esi
  801fe8:	53                   	push   %ebx
  801fe9:	83 ec 1c             	sub    $0x1c,%esp
  801fec:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff1:	50                   	push   %eax
  801ff2:	e8 32 f7 ff ff       	call   801729 <fd_alloc>
  801ff7:	89 c3                	mov    %eax,%ebx
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 43                	js     802043 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 07 04 00 00       	push   $0x407
  802008:	ff 75 f4             	pushl  -0xc(%ebp)
  80200b:	6a 00                	push   $0x0
  80200d:	e8 38 ee ff ff       	call   800e4a <sys_page_alloc>
  802012:	89 c3                	mov    %eax,%ebx
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 28                	js     802043 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802024:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802030:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	50                   	push   %eax
  802037:	e8 c6 f6 ff ff       	call   801702 <fd2num>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	eb 0c                	jmp    80204f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	56                   	push   %esi
  802047:	e8 e4 01 00 00       	call   802230 <nsipc_close>
		return r;
  80204c:	83 c4 10             	add    $0x10,%esp
}
  80204f:	89 d8                	mov    %ebx,%eax
  802051:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802054:	5b                   	pop    %ebx
  802055:	5e                   	pop    %esi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    

00802058 <accept>:
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	e8 4e ff ff ff       	call   801fb4 <fd2sockid>
  802066:	85 c0                	test   %eax,%eax
  802068:	78 1b                	js     802085 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	ff 75 10             	pushl  0x10(%ebp)
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	50                   	push   %eax
  802074:	e8 0e 01 00 00       	call   802187 <nsipc_accept>
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 05                	js     802085 <accept+0x2d>
	return alloc_sockfd(r);
  802080:	e8 5f ff ff ff       	call   801fe4 <alloc_sockfd>
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <bind>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	e8 1f ff ff ff       	call   801fb4 <fd2sockid>
  802095:	85 c0                	test   %eax,%eax
  802097:	78 12                	js     8020ab <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	ff 75 10             	pushl  0x10(%ebp)
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	50                   	push   %eax
  8020a3:	e8 31 01 00 00       	call   8021d9 <nsipc_bind>
  8020a8:	83 c4 10             	add    $0x10,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <shutdown>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	e8 f9 fe ff ff       	call   801fb4 <fd2sockid>
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 0f                	js     8020ce <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020bf:	83 ec 08             	sub    $0x8,%esp
  8020c2:	ff 75 0c             	pushl  0xc(%ebp)
  8020c5:	50                   	push   %eax
  8020c6:	e8 43 01 00 00       	call   80220e <nsipc_shutdown>
  8020cb:	83 c4 10             	add    $0x10,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <connect>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	e8 d6 fe ff ff       	call   801fb4 <fd2sockid>
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 12                	js     8020f4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	ff 75 10             	pushl  0x10(%ebp)
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	50                   	push   %eax
  8020ec:	e8 59 01 00 00       	call   80224a <nsipc_connect>
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <listen>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	e8 b0 fe ff ff       	call   801fb4 <fd2sockid>
  802104:	85 c0                	test   %eax,%eax
  802106:	78 0f                	js     802117 <listen+0x21>
	return nsipc_listen(r, backlog);
  802108:	83 ec 08             	sub    $0x8,%esp
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	50                   	push   %eax
  80210f:	e8 6b 01 00 00       	call   80227f <nsipc_listen>
  802114:	83 c4 10             	add    $0x10,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <socket>:

int
socket(int domain, int type, int protocol)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80211f:	ff 75 10             	pushl  0x10(%ebp)
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	e8 3e 02 00 00       	call   80236b <nsipc_socket>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	78 05                	js     802139 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802134:	e8 ab fe ff ff       	call   801fe4 <alloc_sockfd>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	53                   	push   %ebx
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802144:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80214b:	74 26                	je     802173 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80214d:	6a 07                	push   $0x7
  80214f:	68 00 70 80 00       	push   $0x807000
  802154:	53                   	push   %ebx
  802155:	ff 35 04 50 80 00    	pushl  0x805004
  80215b:	e8 0f f5 ff ff       	call   80166f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802160:	83 c4 0c             	add    $0xc,%esp
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	e8 98 f4 ff ff       	call   801606 <ipc_recv>
}
  80216e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802171:	c9                   	leave  
  802172:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	6a 02                	push   $0x2
  802178:	e8 4a f5 ff ff       	call   8016c7 <ipc_find_env>
  80217d:	a3 04 50 80 00       	mov    %eax,0x805004
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	eb c6                	jmp    80214d <nsipc+0x12>

00802187 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	56                   	push   %esi
  80218b:	53                   	push   %ebx
  80218c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802197:	8b 06                	mov    (%esi),%eax
  802199:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80219e:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a3:	e8 93 ff ff ff       	call   80213b <nsipc>
  8021a8:	89 c3                	mov    %eax,%ebx
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	79 09                	jns    8021b7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021ae:	89 d8                	mov    %ebx,%eax
  8021b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5d                   	pop    %ebp
  8021b6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	ff 35 10 70 80 00    	pushl  0x807010
  8021c0:	68 00 70 80 00       	push   $0x807000
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	e8 19 ea ff ff       	call   800be6 <memmove>
		*addrlen = ret->ret_addrlen;
  8021cd:	a1 10 70 80 00       	mov    0x807010,%eax
  8021d2:	89 06                	mov    %eax,(%esi)
  8021d4:	83 c4 10             	add    $0x10,%esp
	return r;
  8021d7:	eb d5                	jmp    8021ae <nsipc_accept+0x27>

008021d9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021eb:	53                   	push   %ebx
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	68 04 70 80 00       	push   $0x807004
  8021f4:	e8 ed e9 ff ff       	call   800be6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021f9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802204:	e8 32 ff ff ff       	call   80213b <nsipc>
}
  802209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80221c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802224:	b8 03 00 00 00       	mov    $0x3,%eax
  802229:	e8 0d ff ff ff       	call   80213b <nsipc>
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <nsipc_close>:

int
nsipc_close(int s)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80223e:	b8 04 00 00 00       	mov    $0x4,%eax
  802243:	e8 f3 fe ff ff       	call   80213b <nsipc>
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 08             	sub    $0x8,%esp
  802251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80225c:	53                   	push   %ebx
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	68 04 70 80 00       	push   $0x807004
  802265:	e8 7c e9 ff ff       	call   800be6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80226a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802270:	b8 05 00 00 00       	mov    $0x5,%eax
  802275:	e8 c1 fe ff ff       	call   80213b <nsipc>
}
  80227a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802295:	b8 06 00 00 00       	mov    $0x6,%eax
  80229a:	e8 9c fe ff ff       	call   80213b <nsipc>
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	56                   	push   %esi
  8022a5:	53                   	push   %ebx
  8022a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022b1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ba:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8022c4:	e8 72 fe ff ff       	call   80213b <nsipc>
  8022c9:	89 c3                	mov    %eax,%ebx
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	78 1f                	js     8022ee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022cf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022d4:	7f 21                	jg     8022f7 <nsipc_recv+0x56>
  8022d6:	39 c6                	cmp    %eax,%esi
  8022d8:	7c 1d                	jl     8022f7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	50                   	push   %eax
  8022de:	68 00 70 80 00       	push   $0x807000
  8022e3:	ff 75 0c             	pushl  0xc(%ebp)
  8022e6:	e8 fb e8 ff ff       	call   800be6 <memmove>
  8022eb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ee:	89 d8                	mov    %ebx,%eax
  8022f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022f7:	68 d3 31 80 00       	push   $0x8031d3
  8022fc:	68 9b 31 80 00       	push   $0x80319b
  802301:	6a 62                	push   $0x62
  802303:	68 e8 31 80 00       	push   $0x8031e8
  802308:	e8 f6 de ff ff       	call   800203 <_panic>

0080230d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	53                   	push   %ebx
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80231f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802325:	7f 2e                	jg     802355 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	53                   	push   %ebx
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	68 0c 70 80 00       	push   $0x80700c
  802333:	e8 ae e8 ff ff       	call   800be6 <memmove>
	nsipcbuf.send.req_size = size;
  802338:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80233e:	8b 45 14             	mov    0x14(%ebp),%eax
  802341:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802346:	b8 08 00 00 00       	mov    $0x8,%eax
  80234b:	e8 eb fd ff ff       	call   80213b <nsipc>
}
  802350:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802353:	c9                   	leave  
  802354:	c3                   	ret    
	assert(size < 1600);
  802355:	68 f4 31 80 00       	push   $0x8031f4
  80235a:	68 9b 31 80 00       	push   $0x80319b
  80235f:	6a 6d                	push   $0x6d
  802361:	68 e8 31 80 00       	push   $0x8031e8
  802366:	e8 98 de ff ff       	call   800203 <_panic>

0080236b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802381:	8b 45 10             	mov    0x10(%ebp),%eax
  802384:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802389:	b8 09 00 00 00       	mov    $0x9,%eax
  80238e:	e8 a8 fd ff ff       	call   80213b <nsipc>
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	56                   	push   %esi
  802399:	53                   	push   %ebx
  80239a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	e8 6a f3 ff ff       	call   801712 <fd2data>
  8023a8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023aa:	83 c4 08             	add    $0x8,%esp
  8023ad:	68 00 32 80 00       	push   $0x803200
  8023b2:	53                   	push   %ebx
  8023b3:	e8 a0 e6 ff ff       	call   800a58 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b8:	8b 46 04             	mov    0x4(%esi),%eax
  8023bb:	2b 06                	sub    (%esi),%eax
  8023bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023c3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023ca:	00 00 00 
	stat->st_dev = &devpipe;
  8023cd:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023d4:	40 80 00 
	return 0;
}
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5d                   	pop    %ebp
  8023e2:	c3                   	ret    

008023e3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	53                   	push   %ebx
  8023e7:	83 ec 0c             	sub    $0xc,%esp
  8023ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ed:	53                   	push   %ebx
  8023ee:	6a 00                	push   $0x0
  8023f0:	e8 da ea ff ff       	call   800ecf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f5:	89 1c 24             	mov    %ebx,(%esp)
  8023f8:	e8 15 f3 ff ff       	call   801712 <fd2data>
  8023fd:	83 c4 08             	add    $0x8,%esp
  802400:	50                   	push   %eax
  802401:	6a 00                	push   $0x0
  802403:	e8 c7 ea ff ff       	call   800ecf <sys_page_unmap>
}
  802408:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <_pipeisclosed>:
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	57                   	push   %edi
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	83 ec 1c             	sub    $0x1c,%esp
  802416:	89 c7                	mov    %eax,%edi
  802418:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80241a:	a1 08 50 80 00       	mov    0x805008,%eax
  80241f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802422:	83 ec 0c             	sub    $0xc,%esp
  802425:	57                   	push   %edi
  802426:	e8 c2 04 00 00       	call   8028ed <pageref>
  80242b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80242e:	89 34 24             	mov    %esi,(%esp)
  802431:	e8 b7 04 00 00       	call   8028ed <pageref>
		nn = thisenv->env_runs;
  802436:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80243c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80243f:	83 c4 10             	add    $0x10,%esp
  802442:	39 cb                	cmp    %ecx,%ebx
  802444:	74 1b                	je     802461 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802446:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802449:	75 cf                	jne    80241a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80244b:	8b 42 58             	mov    0x58(%edx),%eax
  80244e:	6a 01                	push   $0x1
  802450:	50                   	push   %eax
  802451:	53                   	push   %ebx
  802452:	68 07 32 80 00       	push   $0x803207
  802457:	e8 9d de ff ff       	call   8002f9 <cprintf>
  80245c:	83 c4 10             	add    $0x10,%esp
  80245f:	eb b9                	jmp    80241a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802461:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802464:	0f 94 c0             	sete   %al
  802467:	0f b6 c0             	movzbl %al,%eax
}
  80246a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <devpipe_write>:
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	57                   	push   %edi
  802476:	56                   	push   %esi
  802477:	53                   	push   %ebx
  802478:	83 ec 28             	sub    $0x28,%esp
  80247b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80247e:	56                   	push   %esi
  80247f:	e8 8e f2 ff ff       	call   801712 <fd2data>
  802484:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802486:	83 c4 10             	add    $0x10,%esp
  802489:	bf 00 00 00 00       	mov    $0x0,%edi
  80248e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802491:	74 4f                	je     8024e2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802493:	8b 43 04             	mov    0x4(%ebx),%eax
  802496:	8b 0b                	mov    (%ebx),%ecx
  802498:	8d 51 20             	lea    0x20(%ecx),%edx
  80249b:	39 d0                	cmp    %edx,%eax
  80249d:	72 14                	jb     8024b3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80249f:	89 da                	mov    %ebx,%edx
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	e8 65 ff ff ff       	call   80240d <_pipeisclosed>
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	75 3b                	jne    8024e7 <devpipe_write+0x75>
			sys_yield();
  8024ac:	e8 7a e9 ff ff       	call   800e2b <sys_yield>
  8024b1:	eb e0                	jmp    802493 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024bd:	89 c2                	mov    %eax,%edx
  8024bf:	c1 fa 1f             	sar    $0x1f,%edx
  8024c2:	89 d1                	mov    %edx,%ecx
  8024c4:	c1 e9 1b             	shr    $0x1b,%ecx
  8024c7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024ca:	83 e2 1f             	and    $0x1f,%edx
  8024cd:	29 ca                	sub    %ecx,%edx
  8024cf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024d3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024d7:	83 c0 01             	add    $0x1,%eax
  8024da:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024dd:	83 c7 01             	add    $0x1,%edi
  8024e0:	eb ac                	jmp    80248e <devpipe_write+0x1c>
	return i;
  8024e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_write+0x7a>
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <devpipe_read>:
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	57                   	push   %edi
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	83 ec 18             	sub    $0x18,%esp
  8024fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802500:	57                   	push   %edi
  802501:	e8 0c f2 ff ff       	call   801712 <fd2data>
  802506:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	be 00 00 00 00       	mov    $0x0,%esi
  802510:	3b 75 10             	cmp    0x10(%ebp),%esi
  802513:	75 14                	jne    802529 <devpipe_read+0x35>
	return i;
  802515:	8b 45 10             	mov    0x10(%ebp),%eax
  802518:	eb 02                	jmp    80251c <devpipe_read+0x28>
				return i;
  80251a:	89 f0                	mov    %esi,%eax
}
  80251c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
			sys_yield();
  802524:	e8 02 e9 ff ff       	call   800e2b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802529:	8b 03                	mov    (%ebx),%eax
  80252b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80252e:	75 18                	jne    802548 <devpipe_read+0x54>
			if (i > 0)
  802530:	85 f6                	test   %esi,%esi
  802532:	75 e6                	jne    80251a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802534:	89 da                	mov    %ebx,%edx
  802536:	89 f8                	mov    %edi,%eax
  802538:	e8 d0 fe ff ff       	call   80240d <_pipeisclosed>
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 e3                	je     802524 <devpipe_read+0x30>
				return 0;
  802541:	b8 00 00 00 00       	mov    $0x0,%eax
  802546:	eb d4                	jmp    80251c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802548:	99                   	cltd   
  802549:	c1 ea 1b             	shr    $0x1b,%edx
  80254c:	01 d0                	add    %edx,%eax
  80254e:	83 e0 1f             	and    $0x1f,%eax
  802551:	29 d0                	sub    %edx,%eax
  802553:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802558:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80255b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80255e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802561:	83 c6 01             	add    $0x1,%esi
  802564:	eb aa                	jmp    802510 <devpipe_read+0x1c>

00802566 <pipe>:
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	56                   	push   %esi
  80256a:	53                   	push   %ebx
  80256b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80256e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802571:	50                   	push   %eax
  802572:	e8 b2 f1 ff ff       	call   801729 <fd_alloc>
  802577:	89 c3                	mov    %eax,%ebx
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	85 c0                	test   %eax,%eax
  80257e:	0f 88 23 01 00 00    	js     8026a7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 07 04 00 00       	push   $0x407
  80258c:	ff 75 f4             	pushl  -0xc(%ebp)
  80258f:	6a 00                	push   $0x0
  802591:	e8 b4 e8 ff ff       	call   800e4a <sys_page_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 88 04 01 00 00    	js     8026a7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a9:	50                   	push   %eax
  8025aa:	e8 7a f1 ff ff       	call   801729 <fd_alloc>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	0f 88 db 00 00 00    	js     802697 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bc:	83 ec 04             	sub    $0x4,%esp
  8025bf:	68 07 04 00 00       	push   $0x407
  8025c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c7:	6a 00                	push   $0x0
  8025c9:	e8 7c e8 ff ff       	call   800e4a <sys_page_alloc>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	83 c4 10             	add    $0x10,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 88 bc 00 00 00    	js     802697 <pipe+0x131>
	va = fd2data(fd0);
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e1:	e8 2c f1 ff ff       	call   801712 <fd2data>
  8025e6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e8:	83 c4 0c             	add    $0xc,%esp
  8025eb:	68 07 04 00 00       	push   $0x407
  8025f0:	50                   	push   %eax
  8025f1:	6a 00                	push   $0x0
  8025f3:	e8 52 e8 ff ff       	call   800e4a <sys_page_alloc>
  8025f8:	89 c3                	mov    %eax,%ebx
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 88 82 00 00 00    	js     802687 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 f0             	pushl  -0x10(%ebp)
  80260b:	e8 02 f1 ff ff       	call   801712 <fd2data>
  802610:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802617:	50                   	push   %eax
  802618:	6a 00                	push   $0x0
  80261a:	56                   	push   %esi
  80261b:	6a 00                	push   $0x0
  80261d:	e8 6b e8 ff ff       	call   800e8d <sys_page_map>
  802622:	89 c3                	mov    %eax,%ebx
  802624:	83 c4 20             	add    $0x20,%esp
  802627:	85 c0                	test   %eax,%eax
  802629:	78 4e                	js     802679 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80262b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802630:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802633:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80263f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802642:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	ff 75 f4             	pushl  -0xc(%ebp)
  802654:	e8 a9 f0 ff ff       	call   801702 <fd2num>
  802659:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80265c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80265e:	83 c4 04             	add    $0x4,%esp
  802661:	ff 75 f0             	pushl  -0x10(%ebp)
  802664:	e8 99 f0 ff ff       	call   801702 <fd2num>
  802669:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80266c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80266f:	83 c4 10             	add    $0x10,%esp
  802672:	bb 00 00 00 00       	mov    $0x0,%ebx
  802677:	eb 2e                	jmp    8026a7 <pipe+0x141>
	sys_page_unmap(0, va);
  802679:	83 ec 08             	sub    $0x8,%esp
  80267c:	56                   	push   %esi
  80267d:	6a 00                	push   $0x0
  80267f:	e8 4b e8 ff ff       	call   800ecf <sys_page_unmap>
  802684:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802687:	83 ec 08             	sub    $0x8,%esp
  80268a:	ff 75 f0             	pushl  -0x10(%ebp)
  80268d:	6a 00                	push   $0x0
  80268f:	e8 3b e8 ff ff       	call   800ecf <sys_page_unmap>
  802694:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802697:	83 ec 08             	sub    $0x8,%esp
  80269a:	ff 75 f4             	pushl  -0xc(%ebp)
  80269d:	6a 00                	push   $0x0
  80269f:	e8 2b e8 ff ff       	call   800ecf <sys_page_unmap>
  8026a4:	83 c4 10             	add    $0x10,%esp
}
  8026a7:	89 d8                	mov    %ebx,%eax
  8026a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    

008026b0 <pipeisclosed>:
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b9:	50                   	push   %eax
  8026ba:	ff 75 08             	pushl  0x8(%ebp)
  8026bd:	e8 b9 f0 ff ff       	call   80177b <fd_lookup>
  8026c2:	83 c4 10             	add    $0x10,%esp
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	78 18                	js     8026e1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cf:	e8 3e f0 ff ff       	call   801712 <fd2data>
	return _pipeisclosed(fd, p);
  8026d4:	89 c2                	mov    %eax,%edx
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	e8 2f fd ff ff       	call   80240d <_pipeisclosed>
  8026de:	83 c4 10             	add    $0x10,%esp
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	c3                   	ret    

008026e9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ef:	68 1f 32 80 00       	push   $0x80321f
  8026f4:	ff 75 0c             	pushl  0xc(%ebp)
  8026f7:	e8 5c e3 ff ff       	call   800a58 <strcpy>
	return 0;
}
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <devcons_write>:
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	57                   	push   %edi
  802707:	56                   	push   %esi
  802708:	53                   	push   %ebx
  802709:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80270f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802714:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80271a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80271d:	73 31                	jae    802750 <devcons_write+0x4d>
		m = n - tot;
  80271f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802722:	29 f3                	sub    %esi,%ebx
  802724:	83 fb 7f             	cmp    $0x7f,%ebx
  802727:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80272c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	53                   	push   %ebx
  802733:	89 f0                	mov    %esi,%eax
  802735:	03 45 0c             	add    0xc(%ebp),%eax
  802738:	50                   	push   %eax
  802739:	57                   	push   %edi
  80273a:	e8 a7 e4 ff ff       	call   800be6 <memmove>
		sys_cputs(buf, m);
  80273f:	83 c4 08             	add    $0x8,%esp
  802742:	53                   	push   %ebx
  802743:	57                   	push   %edi
  802744:	e8 45 e6 ff ff       	call   800d8e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802749:	01 de                	add    %ebx,%esi
  80274b:	83 c4 10             	add    $0x10,%esp
  80274e:	eb ca                	jmp    80271a <devcons_write+0x17>
}
  802750:	89 f0                	mov    %esi,%eax
  802752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <devcons_read>:
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 08             	sub    $0x8,%esp
  802760:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802765:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802769:	74 21                	je     80278c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80276b:	e8 3c e6 ff ff       	call   800dac <sys_cgetc>
  802770:	85 c0                	test   %eax,%eax
  802772:	75 07                	jne    80277b <devcons_read+0x21>
		sys_yield();
  802774:	e8 b2 e6 ff ff       	call   800e2b <sys_yield>
  802779:	eb f0                	jmp    80276b <devcons_read+0x11>
	if (c < 0)
  80277b:	78 0f                	js     80278c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80277d:	83 f8 04             	cmp    $0x4,%eax
  802780:	74 0c                	je     80278e <devcons_read+0x34>
	*(char*)vbuf = c;
  802782:	8b 55 0c             	mov    0xc(%ebp),%edx
  802785:	88 02                	mov    %al,(%edx)
	return 1;
  802787:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80278c:	c9                   	leave  
  80278d:	c3                   	ret    
		return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
  802793:	eb f7                	jmp    80278c <devcons_read+0x32>

00802795 <cputchar>:
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027a1:	6a 01                	push   $0x1
  8027a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a6:	50                   	push   %eax
  8027a7:	e8 e2 e5 ff ff       	call   800d8e <sys_cputs>
}
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <getchar>:
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027b7:	6a 01                	push   $0x1
  8027b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027bc:	50                   	push   %eax
  8027bd:	6a 00                	push   $0x0
  8027bf:	e8 27 f2 ff ff       	call   8019eb <read>
	if (r < 0)
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	78 06                	js     8027d1 <getchar+0x20>
	if (r < 1)
  8027cb:	74 06                	je     8027d3 <getchar+0x22>
	return c;
  8027cd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    
		return -E_EOF;
  8027d3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027d8:	eb f7                	jmp    8027d1 <getchar+0x20>

008027da <iscons>:
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e3:	50                   	push   %eax
  8027e4:	ff 75 08             	pushl  0x8(%ebp)
  8027e7:	e8 8f ef ff ff       	call   80177b <fd_lookup>
  8027ec:	83 c4 10             	add    $0x10,%esp
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	78 11                	js     802804 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027fc:	39 10                	cmp    %edx,(%eax)
  8027fe:	0f 94 c0             	sete   %al
  802801:	0f b6 c0             	movzbl %al,%eax
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <opencons>:
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80280c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80280f:	50                   	push   %eax
  802810:	e8 14 ef ff ff       	call   801729 <fd_alloc>
  802815:	83 c4 10             	add    $0x10,%esp
  802818:	85 c0                	test   %eax,%eax
  80281a:	78 3a                	js     802856 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80281c:	83 ec 04             	sub    $0x4,%esp
  80281f:	68 07 04 00 00       	push   $0x407
  802824:	ff 75 f4             	pushl  -0xc(%ebp)
  802827:	6a 00                	push   $0x0
  802829:	e8 1c e6 ff ff       	call   800e4a <sys_page_alloc>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	85 c0                	test   %eax,%eax
  802833:	78 21                	js     802856 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80283e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80284a:	83 ec 0c             	sub    $0xc,%esp
  80284d:	50                   	push   %eax
  80284e:	e8 af ee ff ff       	call   801702 <fd2num>
  802853:	83 c4 10             	add    $0x10,%esp
}
  802856:	c9                   	leave  
  802857:	c3                   	ret    

00802858 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802858:	55                   	push   %ebp
  802859:	89 e5                	mov    %esp,%ebp
  80285b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80285e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802865:	74 0a                	je     802871 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80286f:	c9                   	leave  
  802870:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802871:	83 ec 04             	sub    $0x4,%esp
  802874:	6a 07                	push   $0x7
  802876:	68 00 f0 bf ee       	push   $0xeebff000
  80287b:	6a 00                	push   $0x0
  80287d:	e8 c8 e5 ff ff       	call   800e4a <sys_page_alloc>
		if(r < 0)
  802882:	83 c4 10             	add    $0x10,%esp
  802885:	85 c0                	test   %eax,%eax
  802887:	78 2a                	js     8028b3 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802889:	83 ec 08             	sub    $0x8,%esp
  80288c:	68 c7 28 80 00       	push   $0x8028c7
  802891:	6a 00                	push   $0x0
  802893:	e8 fd e6 ff ff       	call   800f95 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802898:	83 c4 10             	add    $0x10,%esp
  80289b:	85 c0                	test   %eax,%eax
  80289d:	79 c8                	jns    802867 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 5c 32 80 00       	push   $0x80325c
  8028a7:	6a 25                	push   $0x25
  8028a9:	68 98 32 80 00       	push   $0x803298
  8028ae:	e8 50 d9 ff ff       	call   800203 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028b3:	83 ec 04             	sub    $0x4,%esp
  8028b6:	68 2c 32 80 00       	push   $0x80322c
  8028bb:	6a 22                	push   $0x22
  8028bd:	68 98 32 80 00       	push   $0x803298
  8028c2:	e8 3c d9 ff ff       	call   800203 <_panic>

008028c7 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028c7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028c8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028cd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028cf:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028d2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028d6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028da:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028dd:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028df:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028e3:	83 c4 08             	add    $0x8,%esp
	popal
  8028e6:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028e7:	83 c4 04             	add    $0x4,%esp
	popfl
  8028ea:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028eb:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028ec:	c3                   	ret    

008028ed <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028ed:	55                   	push   %ebp
  8028ee:	89 e5                	mov    %esp,%ebp
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028f3:	89 d0                	mov    %edx,%eax
  8028f5:	c1 e8 16             	shr    $0x16,%eax
  8028f8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802904:	f6 c1 01             	test   $0x1,%cl
  802907:	74 1d                	je     802926 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802909:	c1 ea 0c             	shr    $0xc,%edx
  80290c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802913:	f6 c2 01             	test   $0x1,%dl
  802916:	74 0e                	je     802926 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802918:	c1 ea 0c             	shr    $0xc,%edx
  80291b:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802922:	ef 
  802923:	0f b7 c0             	movzwl %ax,%eax
}
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    
  802928:	66 90                	xchg   %ax,%ax
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__udivdi3>:
  802930:	55                   	push   %ebp
  802931:	57                   	push   %edi
  802932:	56                   	push   %esi
  802933:	53                   	push   %ebx
  802934:	83 ec 1c             	sub    $0x1c,%esp
  802937:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80293b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80293f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802943:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802947:	85 d2                	test   %edx,%edx
  802949:	75 4d                	jne    802998 <__udivdi3+0x68>
  80294b:	39 f3                	cmp    %esi,%ebx
  80294d:	76 19                	jbe    802968 <__udivdi3+0x38>
  80294f:	31 ff                	xor    %edi,%edi
  802951:	89 e8                	mov    %ebp,%eax
  802953:	89 f2                	mov    %esi,%edx
  802955:	f7 f3                	div    %ebx
  802957:	89 fa                	mov    %edi,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 d9                	mov    %ebx,%ecx
  80296a:	85 db                	test   %ebx,%ebx
  80296c:	75 0b                	jne    802979 <__udivdi3+0x49>
  80296e:	b8 01 00 00 00       	mov    $0x1,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f3                	div    %ebx
  802977:	89 c1                	mov    %eax,%ecx
  802979:	31 d2                	xor    %edx,%edx
  80297b:	89 f0                	mov    %esi,%eax
  80297d:	f7 f1                	div    %ecx
  80297f:	89 c6                	mov    %eax,%esi
  802981:	89 e8                	mov    %ebp,%eax
  802983:	89 f7                	mov    %esi,%edi
  802985:	f7 f1                	div    %ecx
  802987:	89 fa                	mov    %edi,%edx
  802989:	83 c4 1c             	add    $0x1c,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5f                   	pop    %edi
  80298f:	5d                   	pop    %ebp
  802990:	c3                   	ret    
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	39 f2                	cmp    %esi,%edx
  80299a:	77 1c                	ja     8029b8 <__udivdi3+0x88>
  80299c:	0f bd fa             	bsr    %edx,%edi
  80299f:	83 f7 1f             	xor    $0x1f,%edi
  8029a2:	75 2c                	jne    8029d0 <__udivdi3+0xa0>
  8029a4:	39 f2                	cmp    %esi,%edx
  8029a6:	72 06                	jb     8029ae <__udivdi3+0x7e>
  8029a8:	31 c0                	xor    %eax,%eax
  8029aa:	39 eb                	cmp    %ebp,%ebx
  8029ac:	77 a9                	ja     802957 <__udivdi3+0x27>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	eb a2                	jmp    802957 <__udivdi3+0x27>
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	31 ff                	xor    %edi,%edi
  8029ba:	31 c0                	xor    %eax,%eax
  8029bc:	89 fa                	mov    %edi,%edx
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	89 f9                	mov    %edi,%ecx
  8029d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029d7:	29 f8                	sub    %edi,%eax
  8029d9:	d3 e2                	shl    %cl,%edx
  8029db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029df:	89 c1                	mov    %eax,%ecx
  8029e1:	89 da                	mov    %ebx,%edx
  8029e3:	d3 ea                	shr    %cl,%edx
  8029e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029e9:	09 d1                	or     %edx,%ecx
  8029eb:	89 f2                	mov    %esi,%edx
  8029ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029f1:	89 f9                	mov    %edi,%ecx
  8029f3:	d3 e3                	shl    %cl,%ebx
  8029f5:	89 c1                	mov    %eax,%ecx
  8029f7:	d3 ea                	shr    %cl,%edx
  8029f9:	89 f9                	mov    %edi,%ecx
  8029fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029ff:	89 eb                	mov    %ebp,%ebx
  802a01:	d3 e6                	shl    %cl,%esi
  802a03:	89 c1                	mov    %eax,%ecx
  802a05:	d3 eb                	shr    %cl,%ebx
  802a07:	09 de                	or     %ebx,%esi
  802a09:	89 f0                	mov    %esi,%eax
  802a0b:	f7 74 24 08          	divl   0x8(%esp)
  802a0f:	89 d6                	mov    %edx,%esi
  802a11:	89 c3                	mov    %eax,%ebx
  802a13:	f7 64 24 0c          	mull   0xc(%esp)
  802a17:	39 d6                	cmp    %edx,%esi
  802a19:	72 15                	jb     802a30 <__udivdi3+0x100>
  802a1b:	89 f9                	mov    %edi,%ecx
  802a1d:	d3 e5                	shl    %cl,%ebp
  802a1f:	39 c5                	cmp    %eax,%ebp
  802a21:	73 04                	jae    802a27 <__udivdi3+0xf7>
  802a23:	39 d6                	cmp    %edx,%esi
  802a25:	74 09                	je     802a30 <__udivdi3+0x100>
  802a27:	89 d8                	mov    %ebx,%eax
  802a29:	31 ff                	xor    %edi,%edi
  802a2b:	e9 27 ff ff ff       	jmp    802957 <__udivdi3+0x27>
  802a30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a33:	31 ff                	xor    %edi,%edi
  802a35:	e9 1d ff ff ff       	jmp    802957 <__udivdi3+0x27>
  802a3a:	66 90                	xchg   %ax,%ax
  802a3c:	66 90                	xchg   %ax,%ax
  802a3e:	66 90                	xchg   %ax,%ax

00802a40 <__umoddi3>:
  802a40:	55                   	push   %ebp
  802a41:	57                   	push   %edi
  802a42:	56                   	push   %esi
  802a43:	53                   	push   %ebx
  802a44:	83 ec 1c             	sub    $0x1c,%esp
  802a47:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a57:	89 da                	mov    %ebx,%edx
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	75 43                	jne    802aa0 <__umoddi3+0x60>
  802a5d:	39 df                	cmp    %ebx,%edi
  802a5f:	76 17                	jbe    802a78 <__umoddi3+0x38>
  802a61:	89 f0                	mov    %esi,%eax
  802a63:	f7 f7                	div    %edi
  802a65:	89 d0                	mov    %edx,%eax
  802a67:	31 d2                	xor    %edx,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	89 fd                	mov    %edi,%ebp
  802a7a:	85 ff                	test   %edi,%edi
  802a7c:	75 0b                	jne    802a89 <__umoddi3+0x49>
  802a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a83:	31 d2                	xor    %edx,%edx
  802a85:	f7 f7                	div    %edi
  802a87:	89 c5                	mov    %eax,%ebp
  802a89:	89 d8                	mov    %ebx,%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	f7 f5                	div    %ebp
  802a8f:	89 f0                	mov    %esi,%eax
  802a91:	f7 f5                	div    %ebp
  802a93:	89 d0                	mov    %edx,%eax
  802a95:	eb d0                	jmp    802a67 <__umoddi3+0x27>
  802a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a9e:	66 90                	xchg   %ax,%ax
  802aa0:	89 f1                	mov    %esi,%ecx
  802aa2:	39 d8                	cmp    %ebx,%eax
  802aa4:	76 0a                	jbe    802ab0 <__umoddi3+0x70>
  802aa6:	89 f0                	mov    %esi,%eax
  802aa8:	83 c4 1c             	add    $0x1c,%esp
  802aab:	5b                   	pop    %ebx
  802aac:	5e                   	pop    %esi
  802aad:	5f                   	pop    %edi
  802aae:	5d                   	pop    %ebp
  802aaf:	c3                   	ret    
  802ab0:	0f bd e8             	bsr    %eax,%ebp
  802ab3:	83 f5 1f             	xor    $0x1f,%ebp
  802ab6:	75 20                	jne    802ad8 <__umoddi3+0x98>
  802ab8:	39 d8                	cmp    %ebx,%eax
  802aba:	0f 82 b0 00 00 00    	jb     802b70 <__umoddi3+0x130>
  802ac0:	39 f7                	cmp    %esi,%edi
  802ac2:	0f 86 a8 00 00 00    	jbe    802b70 <__umoddi3+0x130>
  802ac8:	89 c8                	mov    %ecx,%eax
  802aca:	83 c4 1c             	add    $0x1c,%esp
  802acd:	5b                   	pop    %ebx
  802ace:	5e                   	pop    %esi
  802acf:	5f                   	pop    %edi
  802ad0:	5d                   	pop    %ebp
  802ad1:	c3                   	ret    
  802ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ad8:	89 e9                	mov    %ebp,%ecx
  802ada:	ba 20 00 00 00       	mov    $0x20,%edx
  802adf:	29 ea                	sub    %ebp,%edx
  802ae1:	d3 e0                	shl    %cl,%eax
  802ae3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ae7:	89 d1                	mov    %edx,%ecx
  802ae9:	89 f8                	mov    %edi,%eax
  802aeb:	d3 e8                	shr    %cl,%eax
  802aed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802af1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802af5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802af9:	09 c1                	or     %eax,%ecx
  802afb:	89 d8                	mov    %ebx,%eax
  802afd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b01:	89 e9                	mov    %ebp,%ecx
  802b03:	d3 e7                	shl    %cl,%edi
  802b05:	89 d1                	mov    %edx,%ecx
  802b07:	d3 e8                	shr    %cl,%eax
  802b09:	89 e9                	mov    %ebp,%ecx
  802b0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b0f:	d3 e3                	shl    %cl,%ebx
  802b11:	89 c7                	mov    %eax,%edi
  802b13:	89 d1                	mov    %edx,%ecx
  802b15:	89 f0                	mov    %esi,%eax
  802b17:	d3 e8                	shr    %cl,%eax
  802b19:	89 e9                	mov    %ebp,%ecx
  802b1b:	89 fa                	mov    %edi,%edx
  802b1d:	d3 e6                	shl    %cl,%esi
  802b1f:	09 d8                	or     %ebx,%eax
  802b21:	f7 74 24 08          	divl   0x8(%esp)
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	89 f3                	mov    %esi,%ebx
  802b29:	f7 64 24 0c          	mull   0xc(%esp)
  802b2d:	89 c6                	mov    %eax,%esi
  802b2f:	89 d7                	mov    %edx,%edi
  802b31:	39 d1                	cmp    %edx,%ecx
  802b33:	72 06                	jb     802b3b <__umoddi3+0xfb>
  802b35:	75 10                	jne    802b47 <__umoddi3+0x107>
  802b37:	39 c3                	cmp    %eax,%ebx
  802b39:	73 0c                	jae    802b47 <__umoddi3+0x107>
  802b3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b43:	89 d7                	mov    %edx,%edi
  802b45:	89 c6                	mov    %eax,%esi
  802b47:	89 ca                	mov    %ecx,%edx
  802b49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b4e:	29 f3                	sub    %esi,%ebx
  802b50:	19 fa                	sbb    %edi,%edx
  802b52:	89 d0                	mov    %edx,%eax
  802b54:	d3 e0                	shl    %cl,%eax
  802b56:	89 e9                	mov    %ebp,%ecx
  802b58:	d3 eb                	shr    %cl,%ebx
  802b5a:	d3 ea                	shr    %cl,%edx
  802b5c:	09 d8                	or     %ebx,%eax
  802b5e:	83 c4 1c             	add    $0x1c,%esp
  802b61:	5b                   	pop    %ebx
  802b62:	5e                   	pop    %esi
  802b63:	5f                   	pop    %edi
  802b64:	5d                   	pop    %ebp
  802b65:	c3                   	ret    
  802b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b6d:	8d 76 00             	lea    0x0(%esi),%esi
  802b70:	89 da                	mov    %ebx,%edx
  802b72:	29 fe                	sub    %edi,%esi
  802b74:	19 c2                	sbb    %eax,%edx
  802b76:	89 f1                	mov    %esi,%ecx
  802b78:	89 c8                	mov    %ecx,%eax
  802b7a:	e9 4b ff ff ff       	jmp    802aca <__umoddi3+0x8a>
