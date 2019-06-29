
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
  80002c:	e8 d7 00 00 00       	call   800108 <libmain>
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
  800039:	83 ec 24             	sub    $0x24,%esp
	cprintf("in %s\n", __FUNCTION__);
  80003c:	68 64 2b 80 00       	push   $0x802b64
  800041:	68 7c 2b 80 00       	push   $0x802b7c
  800046:	e8 30 02 00 00       	call   80027b <cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80004e:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 50 15 00 00       	call   8015ae <ipc_recv>
  80005e:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800060:	a1 08 50 80 00       	mov    0x805008,%eax
  800065:	8b 40 5c             	mov    0x5c(%eax),%eax
  800068:	83 c4 0c             	add    $0xc,%esp
  80006b:	53                   	push   %ebx
  80006c:	50                   	push   %eax
  80006d:	68 40 2b 80 00       	push   $0x802b40
  800072:	e8 04 02 00 00       	call   80027b <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800077:	e8 9a 12 00 00       	call   801316 <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	85 c0                	test   %eax,%eax
  800083:	78 07                	js     80008c <primeproc+0x59>
		panic("fork: %e", id);
	if (id == 0)
  800085:	74 ca                	je     800051 <primeproc+0x1e>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800087:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80008a:	eb 20                	jmp    8000ac <primeproc+0x79>
		panic("fork: %e", id);
  80008c:	50                   	push   %eax
  80008d:	68 4c 2b 80 00       	push   $0x802b4c
  800092:	6a 1b                	push   $0x1b
  800094:	68 55 2b 80 00       	push   $0x802b55
  800099:	e8 e7 00 00 00       	call   800185 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	51                   	push   %ecx
  8000a3:	57                   	push   %edi
  8000a4:	e8 6e 15 00 00       	call   801617 <ipc_send>
  8000a9:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	56                   	push   %esi
  8000b4:	e8 f5 14 00 00       	call   8015ae <ipc_recv>
  8000b9:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000bb:	99                   	cltd   
  8000bc:	f7 fb                	idiv   %ebx
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	85 d2                	test   %edx,%edx
  8000c3:	74 e7                	je     8000ac <primeproc+0x79>
  8000c5:	eb d7                	jmp    80009e <primeproc+0x6b>

008000c7 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000cc:	e8 45 12 00 00       	call   801316 <fork>
  8000d1:	89 c6                	mov    %eax,%esi
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	78 1a                	js     8000f1 <umain+0x2a>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000d7:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000dc:	74 25                	je     800103 <umain+0x3c>
		ipc_send(id, i, 0, 0);
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 00                	push   $0x0
  8000e2:	53                   	push   %ebx
  8000e3:	56                   	push   %esi
  8000e4:	e8 2e 15 00 00       	call   801617 <ipc_send>
	for (i = 2; ; i++)
  8000e9:	83 c3 01             	add    $0x1,%ebx
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	eb ed                	jmp    8000de <umain+0x17>
		panic("fork: %e", id);
  8000f1:	50                   	push   %eax
  8000f2:	68 4c 2b 80 00       	push   $0x802b4c
  8000f7:	6a 2e                	push   $0x2e
  8000f9:	68 55 2b 80 00       	push   $0x802b55
  8000fe:	e8 82 00 00 00       	call   800185 <_panic>
		primeproc();
  800103:	e8 2b ff ff ff       	call   800033 <primeproc>

00800108 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	56                   	push   %esi
  80010c:	53                   	push   %ebx
  80010d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800110:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800113:	e8 76 0c 00 00       	call   800d8e <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800118:	25 ff 03 00 00       	and    $0x3ff,%eax
  80011d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 db                	test   %ebx,%ebx
  80012f:	7e 07                	jle    800138 <libmain+0x30>
		binaryname = argv[0];
  800131:	8b 06                	mov    (%esi),%eax
  800133:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
  80013d:	e8 85 ff ff ff       	call   8000c7 <umain>

	// exit gracefully
	exit();
  800142:	e8 0a 00 00 00       	call   800151 <exit>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800151:	55                   	push   %ebp
  800152:	89 e5                	mov    %esp,%ebp
  800154:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800157:	a1 08 50 80 00       	mov    0x805008,%eax
  80015c:	8b 40 48             	mov    0x48(%eax),%eax
  80015f:	68 84 2b 80 00       	push   $0x802b84
  800164:	50                   	push   %eax
  800165:	68 78 2b 80 00       	push   $0x802b78
  80016a:	e8 0c 01 00 00       	call   80027b <cprintf>
	close_all();
  80016f:	e8 12 17 00 00       	call   801886 <close_all>
	sys_env_destroy(0);
  800174:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017b:	e8 cd 0b 00 00       	call   800d4d <sys_env_destroy>
}
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	c9                   	leave  
  800184:	c3                   	ret    

00800185 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80018a:	a1 08 50 80 00       	mov    0x805008,%eax
  80018f:	8b 40 48             	mov    0x48(%eax),%eax
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	68 b0 2b 80 00       	push   $0x802bb0
  80019a:	50                   	push   %eax
  80019b:	68 78 2b 80 00       	push   $0x802b78
  8001a0:	e8 d6 00 00 00       	call   80027b <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001a5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a8:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ae:	e8 db 0b 00 00       	call   800d8e <sys_getenvid>
  8001b3:	83 c4 04             	add    $0x4,%esp
  8001b6:	ff 75 0c             	pushl  0xc(%ebp)
  8001b9:	ff 75 08             	pushl  0x8(%ebp)
  8001bc:	56                   	push   %esi
  8001bd:	50                   	push   %eax
  8001be:	68 8c 2b 80 00       	push   $0x802b8c
  8001c3:	e8 b3 00 00 00       	call   80027b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c8:	83 c4 18             	add    $0x18,%esp
  8001cb:	53                   	push   %ebx
  8001cc:	ff 75 10             	pushl  0x10(%ebp)
  8001cf:	e8 56 00 00 00       	call   80022a <vcprintf>
	cprintf("\n");
  8001d4:	c7 04 24 c1 2f 80 00 	movl   $0x802fc1,(%esp)
  8001db:	e8 9b 00 00 00       	call   80027b <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e3:	cc                   	int3   
  8001e4:	eb fd                	jmp    8001e3 <_panic+0x5e>

008001e6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	53                   	push   %ebx
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f0:	8b 13                	mov    (%ebx),%edx
  8001f2:	8d 42 01             	lea    0x1(%edx),%eax
  8001f5:	89 03                	mov    %eax,(%ebx)
  8001f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800203:	74 09                	je     80020e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800205:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800209:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80020c:	c9                   	leave  
  80020d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020e:	83 ec 08             	sub    $0x8,%esp
  800211:	68 ff 00 00 00       	push   $0xff
  800216:	8d 43 08             	lea    0x8(%ebx),%eax
  800219:	50                   	push   %eax
  80021a:	e8 f1 0a 00 00       	call   800d10 <sys_cputs>
		b->idx = 0;
  80021f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	eb db                	jmp    800205 <putch+0x1f>

0080022a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800233:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023a:	00 00 00 
	b.cnt = 0;
  80023d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800244:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800247:	ff 75 0c             	pushl  0xc(%ebp)
  80024a:	ff 75 08             	pushl  0x8(%ebp)
  80024d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800253:	50                   	push   %eax
  800254:	68 e6 01 80 00       	push   $0x8001e6
  800259:	e8 4a 01 00 00       	call   8003a8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025e:	83 c4 08             	add    $0x8,%esp
  800261:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800267:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026d:	50                   	push   %eax
  80026e:	e8 9d 0a 00 00       	call   800d10 <sys_cputs>

	return b.cnt;
}
  800273:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800281:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800284:	50                   	push   %eax
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	e8 9d ff ff ff       	call   80022a <vcprintf>
	va_end(ap);

	return cnt;
}
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	57                   	push   %edi
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 1c             	sub    $0x1c,%esp
  800298:	89 c6                	mov    %eax,%esi
  80029a:	89 d7                	mov    %edx,%edi
  80029c:	8b 45 08             	mov    0x8(%ebp),%eax
  80029f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002ae:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b2:	74 2c                	je     8002e0 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002c4:	39 c2                	cmp    %eax,%edx
  8002c6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002c9:	73 43                	jae    80030e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002cb:	83 eb 01             	sub    $0x1,%ebx
  8002ce:	85 db                	test   %ebx,%ebx
  8002d0:	7e 6c                	jle    80033e <printnum+0xaf>
				putch(padc, putdat);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	57                   	push   %edi
  8002d6:	ff 75 18             	pushl  0x18(%ebp)
  8002d9:	ff d6                	call   *%esi
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	eb eb                	jmp    8002cb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	6a 20                	push   $0x20
  8002e5:	6a 00                	push   $0x0
  8002e7:	50                   	push   %eax
  8002e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ee:	89 fa                	mov    %edi,%edx
  8002f0:	89 f0                	mov    %esi,%eax
  8002f2:	e8 98 ff ff ff       	call   80028f <printnum>
		while (--width > 0)
  8002f7:	83 c4 20             	add    $0x20,%esp
  8002fa:	83 eb 01             	sub    $0x1,%ebx
  8002fd:	85 db                	test   %ebx,%ebx
  8002ff:	7e 65                	jle    800366 <printnum+0xd7>
			putch(padc, putdat);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	57                   	push   %edi
  800305:	6a 20                	push   $0x20
  800307:	ff d6                	call   *%esi
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	eb ec                	jmp    8002fa <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80030e:	83 ec 0c             	sub    $0xc,%esp
  800311:	ff 75 18             	pushl  0x18(%ebp)
  800314:	83 eb 01             	sub    $0x1,%ebx
  800317:	53                   	push   %ebx
  800318:	50                   	push   %eax
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	ff 75 dc             	pushl  -0x24(%ebp)
  80031f:	ff 75 d8             	pushl  -0x28(%ebp)
  800322:	ff 75 e4             	pushl  -0x1c(%ebp)
  800325:	ff 75 e0             	pushl  -0x20(%ebp)
  800328:	e8 b3 25 00 00       	call   8028e0 <__udivdi3>
  80032d:	83 c4 18             	add    $0x18,%esp
  800330:	52                   	push   %edx
  800331:	50                   	push   %eax
  800332:	89 fa                	mov    %edi,%edx
  800334:	89 f0                	mov    %esi,%eax
  800336:	e8 54 ff ff ff       	call   80028f <printnum>
  80033b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	57                   	push   %edi
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	ff 75 dc             	pushl  -0x24(%ebp)
  800348:	ff 75 d8             	pushl  -0x28(%ebp)
  80034b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034e:	ff 75 e0             	pushl  -0x20(%ebp)
  800351:	e8 9a 26 00 00       	call   8029f0 <__umoddi3>
  800356:	83 c4 14             	add    $0x14,%esp
  800359:	0f be 80 b7 2b 80 00 	movsbl 0x802bb7(%eax),%eax
  800360:	50                   	push   %eax
  800361:	ff d6                	call   *%esi
  800363:	83 c4 10             	add    $0x10,%esp
	}
}
  800366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800374:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800378:	8b 10                	mov    (%eax),%edx
  80037a:	3b 50 04             	cmp    0x4(%eax),%edx
  80037d:	73 0a                	jae    800389 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800382:	89 08                	mov    %ecx,(%eax)
  800384:	8b 45 08             	mov    0x8(%ebp),%eax
  800387:	88 02                	mov    %al,(%edx)
}
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    

0080038b <printfmt>:
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800391:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800394:	50                   	push   %eax
  800395:	ff 75 10             	pushl  0x10(%ebp)
  800398:	ff 75 0c             	pushl  0xc(%ebp)
  80039b:	ff 75 08             	pushl  0x8(%ebp)
  80039e:	e8 05 00 00 00       	call   8003a8 <vprintfmt>
}
  8003a3:	83 c4 10             	add    $0x10,%esp
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <vprintfmt>:
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	57                   	push   %edi
  8003ac:	56                   	push   %esi
  8003ad:	53                   	push   %ebx
  8003ae:	83 ec 3c             	sub    $0x3c,%esp
  8003b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003b7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003ba:	e9 32 04 00 00       	jmp    8007f1 <vprintfmt+0x449>
		padc = ' ';
  8003bf:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003c3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003d1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003d8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003df:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003e6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8d 47 01             	lea    0x1(%edi),%eax
  8003ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f1:	0f b6 17             	movzbl (%edi),%edx
  8003f4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f7:	3c 55                	cmp    $0x55,%al
  8003f9:	0f 87 12 05 00 00    	ja     800911 <vprintfmt+0x569>
  8003ff:	0f b6 c0             	movzbl %al,%eax
  800402:	ff 24 85 a0 2d 80 00 	jmp    *0x802da0(,%eax,4)
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800410:	eb d9                	jmp    8003eb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800415:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800419:	eb d0                	jmp    8003eb <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	0f b6 d2             	movzbl %dl,%edx
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800421:	b8 00 00 00 00       	mov    $0x0,%eax
  800426:	89 75 08             	mov    %esi,0x8(%ebp)
  800429:	eb 03                	jmp    80042e <vprintfmt+0x86>
  80042b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800431:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800435:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800438:	8d 72 d0             	lea    -0x30(%edx),%esi
  80043b:	83 fe 09             	cmp    $0x9,%esi
  80043e:	76 eb                	jbe    80042b <vprintfmt+0x83>
  800440:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800443:	8b 75 08             	mov    0x8(%ebp),%esi
  800446:	eb 14                	jmp    80045c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8d 40 04             	lea    0x4(%eax),%eax
  800456:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80045c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800460:	79 89                	jns    8003eb <vprintfmt+0x43>
				width = precision, precision = -1;
  800462:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800465:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800468:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80046f:	e9 77 ff ff ff       	jmp    8003eb <vprintfmt+0x43>
  800474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800477:	85 c0                	test   %eax,%eax
  800479:	0f 48 c1             	cmovs  %ecx,%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800482:	e9 64 ff ff ff       	jmp    8003eb <vprintfmt+0x43>
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80048a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800491:	e9 55 ff ff ff       	jmp    8003eb <vprintfmt+0x43>
			lflag++;
  800496:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049d:	e9 49 ff ff ff       	jmp    8003eb <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	ff 30                	pushl  (%eax)
  8004ae:	ff d6                	call   *%esi
			break;
  8004b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b6:	e9 33 03 00 00       	jmp    8007ee <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
  8004c4:	31 d0                	xor    %edx,%eax
  8004c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c8:	83 f8 11             	cmp    $0x11,%eax
  8004cb:	7f 23                	jg     8004f0 <vprintfmt+0x148>
  8004cd:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 18                	je     8004f0 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004d8:	52                   	push   %edx
  8004d9:	68 2d 31 80 00       	push   $0x80312d
  8004de:	53                   	push   %ebx
  8004df:	56                   	push   %esi
  8004e0:	e8 a6 fe ff ff       	call   80038b <printfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004eb:	e9 fe 02 00 00       	jmp    8007ee <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 cf 2b 80 00       	push   $0x802bcf
  8004f6:	53                   	push   %ebx
  8004f7:	56                   	push   %esi
  8004f8:	e8 8e fe ff ff       	call   80038b <printfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800503:	e9 e6 02 00 00       	jmp    8007ee <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800516:	85 c9                	test   %ecx,%ecx
  800518:	b8 c8 2b 80 00       	mov    $0x802bc8,%eax
  80051d:	0f 45 c1             	cmovne %ecx,%eax
  800520:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800523:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800527:	7e 06                	jle    80052f <vprintfmt+0x187>
  800529:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80052d:	75 0d                	jne    80053c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800532:	89 c7                	mov    %eax,%edi
  800534:	03 45 e0             	add    -0x20(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	eb 53                	jmp    80058f <vprintfmt+0x1e7>
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 71 04 00 00       	call   8009b9 <strnlen>
  800548:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054b:	29 c1                	sub    %eax,%ecx
  80054d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800555:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800559:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055c:	eb 0f                	jmp    80056d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	ff 75 e0             	pushl  -0x20(%ebp)
  800565:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	83 ef 01             	sub    $0x1,%edi
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	85 ff                	test   %edi,%edi
  80056f:	7f ed                	jg     80055e <vprintfmt+0x1b6>
  800571:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800574:	85 c9                	test   %ecx,%ecx
  800576:	b8 00 00 00 00       	mov    $0x0,%eax
  80057b:	0f 49 c1             	cmovns %ecx,%eax
  80057e:	29 c1                	sub    %eax,%ecx
  800580:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800583:	eb aa                	jmp    80052f <vprintfmt+0x187>
					putch(ch, putdat);
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	53                   	push   %ebx
  800589:	52                   	push   %edx
  80058a:	ff d6                	call   *%esi
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800592:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800594:	83 c7 01             	add    $0x1,%edi
  800597:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059b:	0f be d0             	movsbl %al,%edx
  80059e:	85 d2                	test   %edx,%edx
  8005a0:	74 4b                	je     8005ed <vprintfmt+0x245>
  8005a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a6:	78 06                	js     8005ae <vprintfmt+0x206>
  8005a8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ac:	78 1e                	js     8005cc <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b2:	74 d1                	je     800585 <vprintfmt+0x1dd>
  8005b4:	0f be c0             	movsbl %al,%eax
  8005b7:	83 e8 20             	sub    $0x20,%eax
  8005ba:	83 f8 5e             	cmp    $0x5e,%eax
  8005bd:	76 c6                	jbe    800585 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 3f                	push   $0x3f
  8005c5:	ff d6                	call   *%esi
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	eb c3                	jmp    80058f <vprintfmt+0x1e7>
  8005cc:	89 cf                	mov    %ecx,%edi
  8005ce:	eb 0e                	jmp    8005de <vprintfmt+0x236>
				putch(' ', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 20                	push   $0x20
  8005d6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d8:	83 ef 01             	sub    $0x1,%edi
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	85 ff                	test   %edi,%edi
  8005e0:	7f ee                	jg     8005d0 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	e9 01 02 00 00       	jmp    8007ee <vprintfmt+0x446>
  8005ed:	89 cf                	mov    %ecx,%edi
  8005ef:	eb ed                	jmp    8005de <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005f4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005fb:	e9 eb fd ff ff       	jmp    8003eb <vprintfmt+0x43>
	if (lflag >= 2)
  800600:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800604:	7f 21                	jg     800627 <vprintfmt+0x27f>
	else if (lflag)
  800606:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060a:	74 68                	je     800674 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800614:	89 c1                	mov    %eax,%ecx
  800616:	c1 f9 1f             	sar    $0x1f,%ecx
  800619:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
  800625:	eb 17                	jmp    80063e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 50 04             	mov    0x4(%eax),%edx
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800632:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 08             	lea    0x8(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80063e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800641:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80064a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80064e:	78 3f                	js     80068f <vprintfmt+0x2e7>
			base = 10;
  800650:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800655:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800659:	0f 84 71 01 00 00    	je     8007d0 <vprintfmt+0x428>
				putch('+', putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	53                   	push   %ebx
  800663:	6a 2b                	push   $0x2b
  800665:	ff d6                	call   *%esi
  800667:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066f:	e9 5c 01 00 00       	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 00                	mov    (%eax),%eax
  800679:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067c:	89 c1                	mov    %eax,%ecx
  80067e:	c1 f9 1f             	sar    $0x1f,%ecx
  800681:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
  80068d:	eb af                	jmp    80063e <vprintfmt+0x296>
				putch('-', putdat);
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	53                   	push   %ebx
  800693:	6a 2d                	push   $0x2d
  800695:	ff d6                	call   *%esi
				num = -(long long) num;
  800697:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80069a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069d:	f7 d8                	neg    %eax
  80069f:	83 d2 00             	adc    $0x0,%edx
  8006a2:	f7 da                	neg    %edx
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006aa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b2:	e9 19 01 00 00       	jmp    8007d0 <vprintfmt+0x428>
	if (lflag >= 2)
  8006b7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006bb:	7f 29                	jg     8006e6 <vprintfmt+0x33e>
	else if (lflag)
  8006bd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c1:	74 44                	je     800707 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e1:	e9 ea 00 00 00       	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8b 50 04             	mov    0x4(%eax),%edx
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 08             	lea    0x8(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800702:	e9 c9 00 00 00       	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
  800711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 40 04             	lea    0x4(%eax),%eax
  80071d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
  800725:	e9 a6 00 00 00       	jmp    8007d0 <vprintfmt+0x428>
			putch('0', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 30                	push   $0x30
  800730:	ff d6                	call   *%esi
	if (lflag >= 2)
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800739:	7f 26                	jg     800761 <vprintfmt+0x3b9>
	else if (lflag)
  80073b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073f:	74 3e                	je     80077f <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
  80075f:	eb 6f                	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 40 08             	lea    0x8(%eax),%eax
  800775:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800778:	b8 08 00 00 00       	mov    $0x8,%eax
  80077d:	eb 51                	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800798:	b8 08 00 00 00       	mov    $0x8,%eax
  80079d:	eb 31                	jmp    8007d0 <vprintfmt+0x428>
			putch('0', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 30                	push   $0x30
  8007a5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a7:	83 c4 08             	add    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 78                	push   $0x78
  8007ad:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007bf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8d 40 04             	lea    0x4(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007d7:	52                   	push   %edx
  8007d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8007df:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e2:	89 da                	mov    %ebx,%edx
  8007e4:	89 f0                	mov    %esi,%eax
  8007e6:	e8 a4 fa ff ff       	call   80028f <printnum>
			break;
  8007eb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f1:	83 c7 01             	add    $0x1,%edi
  8007f4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f8:	83 f8 25             	cmp    $0x25,%eax
  8007fb:	0f 84 be fb ff ff    	je     8003bf <vprintfmt+0x17>
			if (ch == '\0')
  800801:	85 c0                	test   %eax,%eax
  800803:	0f 84 28 01 00 00    	je     800931 <vprintfmt+0x589>
			putch(ch, putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	53                   	push   %ebx
  80080d:	50                   	push   %eax
  80080e:	ff d6                	call   *%esi
  800810:	83 c4 10             	add    $0x10,%esp
  800813:	eb dc                	jmp    8007f1 <vprintfmt+0x449>
	if (lflag >= 2)
  800815:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800819:	7f 26                	jg     800841 <vprintfmt+0x499>
	else if (lflag)
  80081b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80081f:	74 41                	je     800862 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	ba 00 00 00 00       	mov    $0x0,%edx
  80082b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083a:	b8 10 00 00 00       	mov    $0x10,%eax
  80083f:	eb 8f                	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 50 04             	mov    0x4(%eax),%edx
  800847:	8b 00                	mov    (%eax),%eax
  800849:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 08             	lea    0x8(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800858:	b8 10 00 00 00       	mov    $0x10,%eax
  80085d:	e9 6e ff ff ff       	jmp    8007d0 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	ba 00 00 00 00       	mov    $0x0,%edx
  80086c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8d 40 04             	lea    0x4(%eax),%eax
  800878:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087b:	b8 10 00 00 00       	mov    $0x10,%eax
  800880:	e9 4b ff ff ff       	jmp    8007d0 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	85 c0                	test   %eax,%eax
  800895:	74 14                	je     8008ab <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800897:	8b 13                	mov    (%ebx),%edx
  800899:	83 fa 7f             	cmp    $0x7f,%edx
  80089c:	7f 37                	jg     8008d5 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80089e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	e9 43 ff ff ff       	jmp    8007ee <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b0:	bf ed 2c 80 00       	mov    $0x802ced,%edi
							putch(ch, putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	50                   	push   %eax
  8008ba:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008bc:	83 c7 01             	add    $0x1,%edi
  8008bf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	75 eb                	jne    8008b5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d0:	e9 19 ff ff ff       	jmp    8007ee <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008d5:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008dc:	bf 25 2d 80 00       	mov    $0x802d25,%edi
							putch(ch, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	50                   	push   %eax
  8008e6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e8:	83 c7 01             	add    $0x1,%edi
  8008eb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	85 c0                	test   %eax,%eax
  8008f4:	75 eb                	jne    8008e1 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	e9 ed fe ff ff       	jmp    8007ee <vprintfmt+0x446>
			putch(ch, putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	53                   	push   %ebx
  800905:	6a 25                	push   $0x25
  800907:	ff d6                	call   *%esi
			break;
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	e9 dd fe ff ff       	jmp    8007ee <vprintfmt+0x446>
			putch('%', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	6a 25                	push   $0x25
  800917:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 f8                	mov    %edi,%eax
  80091e:	eb 03                	jmp    800923 <vprintfmt+0x57b>
  800920:	83 e8 01             	sub    $0x1,%eax
  800923:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800927:	75 f7                	jne    800920 <vprintfmt+0x578>
  800929:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092c:	e9 bd fe ff ff       	jmp    8007ee <vprintfmt+0x446>
}
  800931:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5f                   	pop    %edi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 18             	sub    $0x18,%esp
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800945:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800948:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80094f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800956:	85 c0                	test   %eax,%eax
  800958:	74 26                	je     800980 <vsnprintf+0x47>
  80095a:	85 d2                	test   %edx,%edx
  80095c:	7e 22                	jle    800980 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095e:	ff 75 14             	pushl  0x14(%ebp)
  800961:	ff 75 10             	pushl  0x10(%ebp)
  800964:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800967:	50                   	push   %eax
  800968:	68 6e 03 80 00       	push   $0x80036e
  80096d:	e8 36 fa ff ff       	call   8003a8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800975:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097b:	83 c4 10             	add    $0x10,%esp
}
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    
		return -E_INVAL;
  800980:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800985:	eb f7                	jmp    80097e <vsnprintf+0x45>

00800987 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800990:	50                   	push   %eax
  800991:	ff 75 10             	pushl  0x10(%ebp)
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 08             	pushl  0x8(%ebp)
  80099a:	e8 9a ff ff ff       	call   800939 <vsnprintf>
	va_end(ap);

	return rc;
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ac:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b0:	74 05                	je     8009b7 <strlen+0x16>
		n++;
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	eb f5                	jmp    8009ac <strlen+0xb>
	return n;
}
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c7:	39 c2                	cmp    %eax,%edx
  8009c9:	74 0d                	je     8009d8 <strnlen+0x1f>
  8009cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009cf:	74 05                	je     8009d6 <strnlen+0x1d>
		n++;
  8009d1:	83 c2 01             	add    $0x1,%edx
  8009d4:	eb f1                	jmp    8009c7 <strnlen+0xe>
  8009d6:	89 d0                	mov    %edx,%eax
	return n;
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f0:	83 c2 01             	add    $0x1,%edx
  8009f3:	84 c9                	test   %cl,%cl
  8009f5:	75 f2                	jne    8009e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	83 ec 10             	sub    $0x10,%esp
  800a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a04:	53                   	push   %ebx
  800a05:	e8 97 ff ff ff       	call   8009a1 <strlen>
  800a0a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	01 d8                	add    %ebx,%eax
  800a12:	50                   	push   %eax
  800a13:	e8 c2 ff ff ff       	call   8009da <strcpy>
	return dst;
}
  800a18:	89 d8                	mov    %ebx,%eax
  800a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2a:	89 c6                	mov    %eax,%esi
  800a2c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	39 f2                	cmp    %esi,%edx
  800a33:	74 11                	je     800a46 <strncpy+0x27>
		*dst++ = *src;
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	0f b6 19             	movzbl (%ecx),%ebx
  800a3b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a3e:	80 fb 01             	cmp    $0x1,%bl
  800a41:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a44:	eb eb                	jmp    800a31 <strncpy+0x12>
	}
	return ret;
}
  800a46:	5b                   	pop    %ebx
  800a47:	5e                   	pop    %esi
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	56                   	push   %esi
  800a4e:	53                   	push   %ebx
  800a4f:	8b 75 08             	mov    0x8(%ebp),%esi
  800a52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a55:	8b 55 10             	mov    0x10(%ebp),%edx
  800a58:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5a:	85 d2                	test   %edx,%edx
  800a5c:	74 21                	je     800a7f <strlcpy+0x35>
  800a5e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a62:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a64:	39 c2                	cmp    %eax,%edx
  800a66:	74 14                	je     800a7c <strlcpy+0x32>
  800a68:	0f b6 19             	movzbl (%ecx),%ebx
  800a6b:	84 db                	test   %bl,%bl
  800a6d:	74 0b                	je     800a7a <strlcpy+0x30>
			*dst++ = *src++;
  800a6f:	83 c1 01             	add    $0x1,%ecx
  800a72:	83 c2 01             	add    $0x1,%edx
  800a75:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a78:	eb ea                	jmp    800a64 <strlcpy+0x1a>
  800a7a:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a7f:	29 f0                	sub    %esi,%eax
}
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a8e:	0f b6 01             	movzbl (%ecx),%eax
  800a91:	84 c0                	test   %al,%al
  800a93:	74 0c                	je     800aa1 <strcmp+0x1c>
  800a95:	3a 02                	cmp    (%edx),%al
  800a97:	75 08                	jne    800aa1 <strcmp+0x1c>
		p++, q++;
  800a99:	83 c1 01             	add    $0x1,%ecx
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	eb ed                	jmp    800a8e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa1:	0f b6 c0             	movzbl %al,%eax
  800aa4:	0f b6 12             	movzbl (%edx),%edx
  800aa7:	29 d0                	sub    %edx,%eax
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab5:	89 c3                	mov    %eax,%ebx
  800ab7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aba:	eb 06                	jmp    800ac2 <strncmp+0x17>
		n--, p++, q++;
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac2:	39 d8                	cmp    %ebx,%eax
  800ac4:	74 16                	je     800adc <strncmp+0x31>
  800ac6:	0f b6 08             	movzbl (%eax),%ecx
  800ac9:	84 c9                	test   %cl,%cl
  800acb:	74 04                	je     800ad1 <strncmp+0x26>
  800acd:	3a 0a                	cmp    (%edx),%cl
  800acf:	74 eb                	je     800abc <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad1:	0f b6 00             	movzbl (%eax),%eax
  800ad4:	0f b6 12             	movzbl (%edx),%edx
  800ad7:	29 d0                	sub    %edx,%eax
}
  800ad9:	5b                   	pop    %ebx
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    
		return 0;
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	eb f6                	jmp    800ad9 <strncmp+0x2e>

00800ae3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aed:	0f b6 10             	movzbl (%eax),%edx
  800af0:	84 d2                	test   %dl,%dl
  800af2:	74 09                	je     800afd <strchr+0x1a>
		if (*s == c)
  800af4:	38 ca                	cmp    %cl,%dl
  800af6:	74 0a                	je     800b02 <strchr+0x1f>
	for (; *s; s++)
  800af8:	83 c0 01             	add    $0x1,%eax
  800afb:	eb f0                	jmp    800aed <strchr+0xa>
			return (char *) s;
	return 0;
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b0e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b11:	38 ca                	cmp    %cl,%dl
  800b13:	74 09                	je     800b1e <strfind+0x1a>
  800b15:	84 d2                	test   %dl,%dl
  800b17:	74 05                	je     800b1e <strfind+0x1a>
	for (; *s; s++)
  800b19:	83 c0 01             	add    $0x1,%eax
  800b1c:	eb f0                	jmp    800b0e <strfind+0xa>
			break;
	return (char *) s;
}
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    

00800b20 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	57                   	push   %edi
  800b24:	56                   	push   %esi
  800b25:	53                   	push   %ebx
  800b26:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2c:	85 c9                	test   %ecx,%ecx
  800b2e:	74 31                	je     800b61 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b30:	89 f8                	mov    %edi,%eax
  800b32:	09 c8                	or     %ecx,%eax
  800b34:	a8 03                	test   $0x3,%al
  800b36:	75 23                	jne    800b5b <memset+0x3b>
		c &= 0xFF;
  800b38:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3c:	89 d3                	mov    %edx,%ebx
  800b3e:	c1 e3 08             	shl    $0x8,%ebx
  800b41:	89 d0                	mov    %edx,%eax
  800b43:	c1 e0 18             	shl    $0x18,%eax
  800b46:	89 d6                	mov    %edx,%esi
  800b48:	c1 e6 10             	shl    $0x10,%esi
  800b4b:	09 f0                	or     %esi,%eax
  800b4d:	09 c2                	or     %eax,%edx
  800b4f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b51:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b54:	89 d0                	mov    %edx,%eax
  800b56:	fc                   	cld    
  800b57:	f3 ab                	rep stos %eax,%es:(%edi)
  800b59:	eb 06                	jmp    800b61 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	fc                   	cld    
  800b5f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b61:	89 f8                	mov    %edi,%eax
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5f                   	pop    %edi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b73:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b76:	39 c6                	cmp    %eax,%esi
  800b78:	73 32                	jae    800bac <memmove+0x44>
  800b7a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b7d:	39 c2                	cmp    %eax,%edx
  800b7f:	76 2b                	jbe    800bac <memmove+0x44>
		s += n;
		d += n;
  800b81:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b84:	89 fe                	mov    %edi,%esi
  800b86:	09 ce                	or     %ecx,%esi
  800b88:	09 d6                	or     %edx,%esi
  800b8a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b90:	75 0e                	jne    800ba0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b92:	83 ef 04             	sub    $0x4,%edi
  800b95:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b98:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b9b:	fd                   	std    
  800b9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9e:	eb 09                	jmp    800ba9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba0:	83 ef 01             	sub    $0x1,%edi
  800ba3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba6:	fd                   	std    
  800ba7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ba9:	fc                   	cld    
  800baa:	eb 1a                	jmp    800bc6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	09 ca                	or     %ecx,%edx
  800bb0:	09 f2                	or     %esi,%edx
  800bb2:	f6 c2 03             	test   $0x3,%dl
  800bb5:	75 0a                	jne    800bc1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bba:	89 c7                	mov    %eax,%edi
  800bbc:	fc                   	cld    
  800bbd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbf:	eb 05                	jmp    800bc6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc1:	89 c7                	mov    %eax,%edi
  800bc3:	fc                   	cld    
  800bc4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc6:	5e                   	pop    %esi
  800bc7:	5f                   	pop    %edi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd0:	ff 75 10             	pushl  0x10(%ebp)
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	ff 75 08             	pushl  0x8(%ebp)
  800bd9:	e8 8a ff ff ff       	call   800b68 <memmove>
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800beb:	89 c6                	mov    %eax,%esi
  800bed:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf0:	39 f0                	cmp    %esi,%eax
  800bf2:	74 1c                	je     800c10 <memcmp+0x30>
		if (*s1 != *s2)
  800bf4:	0f b6 08             	movzbl (%eax),%ecx
  800bf7:	0f b6 1a             	movzbl (%edx),%ebx
  800bfa:	38 d9                	cmp    %bl,%cl
  800bfc:	75 08                	jne    800c06 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bfe:	83 c0 01             	add    $0x1,%eax
  800c01:	83 c2 01             	add    $0x1,%edx
  800c04:	eb ea                	jmp    800bf0 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c06:	0f b6 c1             	movzbl %cl,%eax
  800c09:	0f b6 db             	movzbl %bl,%ebx
  800c0c:	29 d8                	sub    %ebx,%eax
  800c0e:	eb 05                	jmp    800c15 <memcmp+0x35>
	}

	return 0;
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c22:	89 c2                	mov    %eax,%edx
  800c24:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c27:	39 d0                	cmp    %edx,%eax
  800c29:	73 09                	jae    800c34 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2b:	38 08                	cmp    %cl,(%eax)
  800c2d:	74 05                	je     800c34 <memfind+0x1b>
	for (; s < ends; s++)
  800c2f:	83 c0 01             	add    $0x1,%eax
  800c32:	eb f3                	jmp    800c27 <memfind+0xe>
			break;
	return (void *) s;
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c42:	eb 03                	jmp    800c47 <strtol+0x11>
		s++;
  800c44:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c47:	0f b6 01             	movzbl (%ecx),%eax
  800c4a:	3c 20                	cmp    $0x20,%al
  800c4c:	74 f6                	je     800c44 <strtol+0xe>
  800c4e:	3c 09                	cmp    $0x9,%al
  800c50:	74 f2                	je     800c44 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c52:	3c 2b                	cmp    $0x2b,%al
  800c54:	74 2a                	je     800c80 <strtol+0x4a>
	int neg = 0;
  800c56:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c5b:	3c 2d                	cmp    $0x2d,%al
  800c5d:	74 2b                	je     800c8a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c65:	75 0f                	jne    800c76 <strtol+0x40>
  800c67:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6a:	74 28                	je     800c94 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6c:	85 db                	test   %ebx,%ebx
  800c6e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c73:	0f 44 d8             	cmove  %eax,%ebx
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c7e:	eb 50                	jmp    800cd0 <strtol+0x9a>
		s++;
  800c80:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c83:	bf 00 00 00 00       	mov    $0x0,%edi
  800c88:	eb d5                	jmp    800c5f <strtol+0x29>
		s++, neg = 1;
  800c8a:	83 c1 01             	add    $0x1,%ecx
  800c8d:	bf 01 00 00 00       	mov    $0x1,%edi
  800c92:	eb cb                	jmp    800c5f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c94:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c98:	74 0e                	je     800ca8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9a:	85 db                	test   %ebx,%ebx
  800c9c:	75 d8                	jne    800c76 <strtol+0x40>
		s++, base = 8;
  800c9e:	83 c1 01             	add    $0x1,%ecx
  800ca1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca6:	eb ce                	jmp    800c76 <strtol+0x40>
		s += 2, base = 16;
  800ca8:	83 c1 02             	add    $0x2,%ecx
  800cab:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb0:	eb c4                	jmp    800c76 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb5:	89 f3                	mov    %esi,%ebx
  800cb7:	80 fb 19             	cmp    $0x19,%bl
  800cba:	77 29                	ja     800ce5 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cbc:	0f be d2             	movsbl %dl,%edx
  800cbf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc5:	7d 30                	jge    800cf7 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cc7:	83 c1 01             	add    $0x1,%ecx
  800cca:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cce:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd0:	0f b6 11             	movzbl (%ecx),%edx
  800cd3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd6:	89 f3                	mov    %esi,%ebx
  800cd8:	80 fb 09             	cmp    $0x9,%bl
  800cdb:	77 d5                	ja     800cb2 <strtol+0x7c>
			dig = *s - '0';
  800cdd:	0f be d2             	movsbl %dl,%edx
  800ce0:	83 ea 30             	sub    $0x30,%edx
  800ce3:	eb dd                	jmp    800cc2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce8:	89 f3                	mov    %esi,%ebx
  800cea:	80 fb 19             	cmp    $0x19,%bl
  800ced:	77 08                	ja     800cf7 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cef:	0f be d2             	movsbl %dl,%edx
  800cf2:	83 ea 37             	sub    $0x37,%edx
  800cf5:	eb cb                	jmp    800cc2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfb:	74 05                	je     800d02 <strtol+0xcc>
		*endptr = (char *) s;
  800cfd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d00:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d02:	89 c2                	mov    %eax,%edx
  800d04:	f7 da                	neg    %edx
  800d06:	85 ff                	test   %edi,%edi
  800d08:	0f 45 c2             	cmovne %edx,%eax
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	89 c3                	mov    %eax,%ebx
  800d23:	89 c7                	mov    %eax,%edi
  800d25:	89 c6                	mov    %eax,%esi
  800d27:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
  800d39:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3e:	89 d1                	mov    %edx,%ecx
  800d40:	89 d3                	mov    %edx,%ebx
  800d42:	89 d7                	mov    %edx,%edi
  800d44:	89 d6                	mov    %edx,%esi
  800d46:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d63:	89 cb                	mov    %ecx,%ebx
  800d65:	89 cf                	mov    %ecx,%edi
  800d67:	89 ce                	mov    %ecx,%esi
  800d69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7f 08                	jg     800d77 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	50                   	push   %eax
  800d7b:	6a 03                	push   $0x3
  800d7d:	68 48 2f 80 00       	push   $0x802f48
  800d82:	6a 43                	push   $0x43
  800d84:	68 65 2f 80 00       	push   $0x802f65
  800d89:	e8 f7 f3 ff ff       	call   800185 <_panic>

00800d8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d94:	ba 00 00 00 00       	mov    $0x0,%edx
  800d99:	b8 02 00 00 00       	mov    $0x2,%eax
  800d9e:	89 d1                	mov    %edx,%ecx
  800da0:	89 d3                	mov    %edx,%ebx
  800da2:	89 d7                	mov    %edx,%edi
  800da4:	89 d6                	mov    %edx,%esi
  800da6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_yield>:

void
sys_yield(void)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db3:	ba 00 00 00 00       	mov    $0x0,%edx
  800db8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dbd:	89 d1                	mov    %edx,%ecx
  800dbf:	89 d3                	mov    %edx,%ebx
  800dc1:	89 d7                	mov    %edx,%edi
  800dc3:	89 d6                	mov    %edx,%esi
  800dc5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd5:	be 00 00 00 00       	mov    $0x0,%esi
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 04 00 00 00       	mov    $0x4,%eax
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de8:	89 f7                	mov    %esi,%edi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 04                	push   $0x4
  800dfe:	68 48 2f 80 00       	push   $0x802f48
  800e03:	6a 43                	push   $0x43
  800e05:	68 65 2f 80 00       	push   $0x802f65
  800e0a:	e8 76 f3 ff ff       	call   800185 <_panic>

00800e0f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
  800e15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 05 00 00 00       	mov    $0x5,%eax
  800e23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e26:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e29:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 05                	push   $0x5
  800e40:	68 48 2f 80 00       	push   $0x802f48
  800e45:	6a 43                	push   $0x43
  800e47:	68 65 2f 80 00       	push   $0x802f65
  800e4c:	e8 34 f3 ff ff       	call   800185 <_panic>

00800e51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	57                   	push   %edi
  800e55:	56                   	push   %esi
  800e56:	53                   	push   %ebx
  800e57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e65:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6a:	89 df                	mov    %ebx,%edi
  800e6c:	89 de                	mov    %ebx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 06                	push   $0x6
  800e82:	68 48 2f 80 00       	push   $0x802f48
  800e87:	6a 43                	push   $0x43
  800e89:	68 65 2f 80 00       	push   $0x802f65
  800e8e:	e8 f2 f2 ff ff       	call   800185 <_panic>

00800e93 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	b8 08 00 00 00       	mov    $0x8,%eax
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7f 08                	jg     800ebe <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	50                   	push   %eax
  800ec2:	6a 08                	push   $0x8
  800ec4:	68 48 2f 80 00       	push   $0x802f48
  800ec9:	6a 43                	push   $0x43
  800ecb:	68 65 2f 80 00       	push   $0x802f65
  800ed0:	e8 b0 f2 ff ff       	call   800185 <_panic>

00800ed5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
  800edb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ede:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	b8 09 00 00 00       	mov    $0x9,%eax
  800eee:	89 df                	mov    %ebx,%edi
  800ef0:	89 de                	mov    %ebx,%esi
  800ef2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	7f 08                	jg     800f00 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efb:	5b                   	pop    %ebx
  800efc:	5e                   	pop    %esi
  800efd:	5f                   	pop    %edi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f00:	83 ec 0c             	sub    $0xc,%esp
  800f03:	50                   	push   %eax
  800f04:	6a 09                	push   $0x9
  800f06:	68 48 2f 80 00       	push   $0x802f48
  800f0b:	6a 43                	push   $0x43
  800f0d:	68 65 2f 80 00       	push   $0x802f65
  800f12:	e8 6e f2 ff ff       	call   800185 <_panic>

00800f17 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f30:	89 df                	mov    %ebx,%edi
  800f32:	89 de                	mov    %ebx,%esi
  800f34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f36:	85 c0                	test   %eax,%eax
  800f38:	7f 08                	jg     800f42 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f42:	83 ec 0c             	sub    $0xc,%esp
  800f45:	50                   	push   %eax
  800f46:	6a 0a                	push   $0xa
  800f48:	68 48 2f 80 00       	push   $0x802f48
  800f4d:	6a 43                	push   $0x43
  800f4f:	68 65 2f 80 00       	push   $0x802f65
  800f54:	e8 2c f2 ff ff       	call   800185 <_panic>

00800f59 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6a:	be 00 00 00 00       	mov    $0x0,%esi
  800f6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f72:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f75:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f92:	89 cb                	mov    %ecx,%ebx
  800f94:	89 cf                	mov    %ecx,%edi
  800f96:	89 ce                	mov    %ecx,%esi
  800f98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	7f 08                	jg     800fa6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa6:	83 ec 0c             	sub    $0xc,%esp
  800fa9:	50                   	push   %eax
  800faa:	6a 0d                	push   $0xd
  800fac:	68 48 2f 80 00       	push   $0x802f48
  800fb1:	6a 43                	push   $0x43
  800fb3:	68 65 2f 80 00       	push   $0x802f65
  800fb8:	e8 c8 f1 ff ff       	call   800185 <_panic>

00800fbd <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fce:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd3:	89 df                	mov    %ebx,%edi
  800fd5:	89 de                	mov    %ebx,%esi
  800fd7:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fd9:	5b                   	pop    %ebx
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fec:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff1:	89 cb                	mov    %ecx,%ebx
  800ff3:	89 cf                	mov    %ecx,%edi
  800ff5:	89 ce                	mov    %ecx,%esi
  800ff7:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ff9:	5b                   	pop    %ebx
  800ffa:	5e                   	pop    %esi
  800ffb:	5f                   	pop    %edi
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
	asm volatile("int %1\n"
  801004:	ba 00 00 00 00       	mov    $0x0,%edx
  801009:	b8 10 00 00 00       	mov    $0x10,%eax
  80100e:	89 d1                	mov    %edx,%ecx
  801010:	89 d3                	mov    %edx,%ebx
  801012:	89 d7                	mov    %edx,%edi
  801014:	89 d6                	mov    %edx,%esi
  801016:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
	asm volatile("int %1\n"
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102e:	b8 11 00 00 00       	mov    $0x11,%eax
  801033:	89 df                	mov    %ebx,%edi
  801035:	89 de                	mov    %ebx,%esi
  801037:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	57                   	push   %edi
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
	asm volatile("int %1\n"
  801044:	bb 00 00 00 00       	mov    $0x0,%ebx
  801049:	8b 55 08             	mov    0x8(%ebp),%edx
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	b8 12 00 00 00       	mov    $0x12,%eax
  801054:	89 df                	mov    %ebx,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	57                   	push   %edi
  801063:	56                   	push   %esi
  801064:	53                   	push   %ebx
  801065:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801068:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106d:	8b 55 08             	mov    0x8(%ebp),%edx
  801070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801073:	b8 13 00 00 00       	mov    $0x13,%eax
  801078:	89 df                	mov    %ebx,%edi
  80107a:	89 de                	mov    %ebx,%esi
  80107c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7f 08                	jg     80108a <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	50                   	push   %eax
  80108e:	6a 13                	push   $0x13
  801090:	68 48 2f 80 00       	push   $0x802f48
  801095:	6a 43                	push   $0x43
  801097:	68 65 2f 80 00       	push   $0x802f65
  80109c:	e8 e4 f0 ff ff       	call   800185 <_panic>

008010a1 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	57                   	push   %edi
  8010a5:	56                   	push   %esi
  8010a6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8010af:	b8 14 00 00 00       	mov    $0x14,%eax
  8010b4:	89 cb                	mov    %ecx,%ebx
  8010b6:	89 cf                	mov    %ecx,%edi
  8010b8:	89 ce                	mov    %ecx,%esi
  8010ba:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8010c8:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010cf:	f6 c5 04             	test   $0x4,%ch
  8010d2:	75 45                	jne    801119 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010d4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010db:	83 e1 07             	and    $0x7,%ecx
  8010de:	83 f9 07             	cmp    $0x7,%ecx
  8010e1:	74 6f                	je     801152 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010e3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ea:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010f0:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010f6:	0f 84 b6 00 00 00    	je     8011b2 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010fc:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801103:	83 e1 05             	and    $0x5,%ecx
  801106:	83 f9 05             	cmp    $0x5,%ecx
  801109:	0f 84 d7 00 00 00    	je     8011e6 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
  801114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801117:	c9                   	leave  
  801118:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801119:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801120:	c1 e2 0c             	shl    $0xc,%edx
  801123:	83 ec 0c             	sub    $0xc,%esp
  801126:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  80112c:	51                   	push   %ecx
  80112d:	52                   	push   %edx
  80112e:	50                   	push   %eax
  80112f:	52                   	push   %edx
  801130:	6a 00                	push   $0x0
  801132:	e8 d8 fc ff ff       	call   800e0f <sys_page_map>
		if(r < 0)
  801137:	83 c4 20             	add    $0x20,%esp
  80113a:	85 c0                	test   %eax,%eax
  80113c:	79 d1                	jns    80110f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80113e:	83 ec 04             	sub    $0x4,%esp
  801141:	68 73 2f 80 00       	push   $0x802f73
  801146:	6a 54                	push   $0x54
  801148:	68 89 2f 80 00       	push   $0x802f89
  80114d:	e8 33 f0 ff ff       	call   800185 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801152:	89 d3                	mov    %edx,%ebx
  801154:	c1 e3 0c             	shl    $0xc,%ebx
  801157:	83 ec 0c             	sub    $0xc,%esp
  80115a:	68 05 08 00 00       	push   $0x805
  80115f:	53                   	push   %ebx
  801160:	50                   	push   %eax
  801161:	53                   	push   %ebx
  801162:	6a 00                	push   $0x0
  801164:	e8 a6 fc ff ff       	call   800e0f <sys_page_map>
		if(r < 0)
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 2e                	js     80119e <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	68 05 08 00 00       	push   $0x805
  801178:	53                   	push   %ebx
  801179:	6a 00                	push   $0x0
  80117b:	53                   	push   %ebx
  80117c:	6a 00                	push   $0x0
  80117e:	e8 8c fc ff ff       	call   800e0f <sys_page_map>
		if(r < 0)
  801183:	83 c4 20             	add    $0x20,%esp
  801186:	85 c0                	test   %eax,%eax
  801188:	79 85                	jns    80110f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80118a:	83 ec 04             	sub    $0x4,%esp
  80118d:	68 73 2f 80 00       	push   $0x802f73
  801192:	6a 5f                	push   $0x5f
  801194:	68 89 2f 80 00       	push   $0x802f89
  801199:	e8 e7 ef ff ff       	call   800185 <_panic>
			panic("sys_page_map() panic\n");
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	68 73 2f 80 00       	push   $0x802f73
  8011a6:	6a 5b                	push   $0x5b
  8011a8:	68 89 2f 80 00       	push   $0x802f89
  8011ad:	e8 d3 ef ff ff       	call   800185 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011b2:	c1 e2 0c             	shl    $0xc,%edx
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	68 05 08 00 00       	push   $0x805
  8011bd:	52                   	push   %edx
  8011be:	50                   	push   %eax
  8011bf:	52                   	push   %edx
  8011c0:	6a 00                	push   $0x0
  8011c2:	e8 48 fc ff ff       	call   800e0f <sys_page_map>
		if(r < 0)
  8011c7:	83 c4 20             	add    $0x20,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	0f 89 3d ff ff ff    	jns    80110f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	68 73 2f 80 00       	push   $0x802f73
  8011da:	6a 66                	push   $0x66
  8011dc:	68 89 2f 80 00       	push   $0x802f89
  8011e1:	e8 9f ef ff ff       	call   800185 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011e6:	c1 e2 0c             	shl    $0xc,%edx
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	6a 05                	push   $0x5
  8011ee:	52                   	push   %edx
  8011ef:	50                   	push   %eax
  8011f0:	52                   	push   %edx
  8011f1:	6a 00                	push   $0x0
  8011f3:	e8 17 fc ff ff       	call   800e0f <sys_page_map>
		if(r < 0)
  8011f8:	83 c4 20             	add    $0x20,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	0f 89 0c ff ff ff    	jns    80110f <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	68 73 2f 80 00       	push   $0x802f73
  80120b:	6a 6d                	push   $0x6d
  80120d:	68 89 2f 80 00       	push   $0x802f89
  801212:	e8 6e ef ff ff       	call   800185 <_panic>

00801217 <pgfault>:
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	53                   	push   %ebx
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801221:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801223:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  801227:	0f 84 99 00 00 00    	je     8012c6 <pgfault+0xaf>
  80122d:	89 c2                	mov    %eax,%edx
  80122f:	c1 ea 16             	shr    $0x16,%edx
  801232:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801239:	f6 c2 01             	test   $0x1,%dl
  80123c:	0f 84 84 00 00 00    	je     8012c6 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801242:	89 c2                	mov    %eax,%edx
  801244:	c1 ea 0c             	shr    $0xc,%edx
  801247:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124e:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801254:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80125a:	75 6a                	jne    8012c6 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  80125c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801261:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	6a 07                	push   $0x7
  801268:	68 00 f0 7f 00       	push   $0x7ff000
  80126d:	6a 00                	push   $0x0
  80126f:	e8 58 fb ff ff       	call   800dcc <sys_page_alloc>
	if(ret < 0)
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	78 5f                	js     8012da <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	68 00 10 00 00       	push   $0x1000
  801283:	53                   	push   %ebx
  801284:	68 00 f0 7f 00       	push   $0x7ff000
  801289:	e8 3c f9 ff ff       	call   800bca <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80128e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801295:	53                   	push   %ebx
  801296:	6a 00                	push   $0x0
  801298:	68 00 f0 7f 00       	push   $0x7ff000
  80129d:	6a 00                	push   $0x0
  80129f:	e8 6b fb ff ff       	call   800e0f <sys_page_map>
	if(ret < 0)
  8012a4:	83 c4 20             	add    $0x20,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	78 43                	js     8012ee <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	68 00 f0 7f 00       	push   $0x7ff000
  8012b3:	6a 00                	push   $0x0
  8012b5:	e8 97 fb ff ff       	call   800e51 <sys_page_unmap>
	if(ret < 0)
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 41                	js     801302 <pgfault+0xeb>
}
  8012c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	68 94 2f 80 00       	push   $0x802f94
  8012ce:	6a 26                	push   $0x26
  8012d0:	68 89 2f 80 00       	push   $0x802f89
  8012d5:	e8 ab ee ff ff       	call   800185 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012da:	83 ec 04             	sub    $0x4,%esp
  8012dd:	68 a8 2f 80 00       	push   $0x802fa8
  8012e2:	6a 31                	push   $0x31
  8012e4:	68 89 2f 80 00       	push   $0x802f89
  8012e9:	e8 97 ee ff ff       	call   800185 <_panic>
		panic("panic in sys_page_map()\n");
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 c3 2f 80 00       	push   $0x802fc3
  8012f6:	6a 36                	push   $0x36
  8012f8:	68 89 2f 80 00       	push   $0x802f89
  8012fd:	e8 83 ee ff ff       	call   800185 <_panic>
		panic("panic in sys_page_unmap()\n");
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 dc 2f 80 00       	push   $0x802fdc
  80130a:	6a 39                	push   $0x39
  80130c:	68 89 2f 80 00       	push   $0x802f89
  801311:	e8 6f ee ff ff       	call   800185 <_panic>

00801316 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80131f:	68 17 12 80 00       	push   $0x801217
  801324:	e8 db 14 00 00       	call   802804 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801329:	b8 07 00 00 00       	mov    $0x7,%eax
  80132e:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 2a                	js     801361 <fork+0x4b>
  801337:	89 c6                	mov    %eax,%esi
  801339:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80133b:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801340:	75 4b                	jne    80138d <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801342:	e8 47 fa ff ff       	call   800d8e <sys_getenvid>
  801347:	25 ff 03 00 00       	and    $0x3ff,%eax
  80134c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801352:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801357:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80135c:	e9 90 00 00 00       	jmp    8013f1 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	68 f8 2f 80 00       	push   $0x802ff8
  801369:	68 8c 00 00 00       	push   $0x8c
  80136e:	68 89 2f 80 00       	push   $0x802f89
  801373:	e8 0d ee ff ff       	call   800185 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801378:	89 f8                	mov    %edi,%eax
  80137a:	e8 42 fd ff ff       	call   8010c1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80137f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801385:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80138b:	74 26                	je     8013b3 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	c1 e8 16             	shr    $0x16,%eax
  801392:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801399:	a8 01                	test   $0x1,%al
  80139b:	74 e2                	je     80137f <fork+0x69>
  80139d:	89 da                	mov    %ebx,%edx
  80139f:	c1 ea 0c             	shr    $0xc,%edx
  8013a2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013a9:	83 e0 05             	and    $0x5,%eax
  8013ac:	83 f8 05             	cmp    $0x5,%eax
  8013af:	75 ce                	jne    80137f <fork+0x69>
  8013b1:	eb c5                	jmp    801378 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	6a 07                	push   $0x7
  8013b8:	68 00 f0 bf ee       	push   $0xeebff000
  8013bd:	56                   	push   %esi
  8013be:	e8 09 fa ff ff       	call   800dcc <sys_page_alloc>
	if(ret < 0)
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 31                	js     8013fb <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	68 73 28 80 00       	push   $0x802873
  8013d2:	56                   	push   %esi
  8013d3:	e8 3f fb ff ff       	call   800f17 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 33                	js     801412 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	6a 02                	push   $0x2
  8013e4:	56                   	push   %esi
  8013e5:	e8 a9 fa ff ff       	call   800e93 <sys_env_set_status>
	if(ret < 0)
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	78 38                	js     801429 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013f1:	89 f0                	mov    %esi,%eax
  8013f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5f                   	pop    %edi
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 a8 2f 80 00       	push   $0x802fa8
  801403:	68 98 00 00 00       	push   $0x98
  801408:	68 89 2f 80 00       	push   $0x802f89
  80140d:	e8 73 ed ff ff       	call   800185 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	68 1c 30 80 00       	push   $0x80301c
  80141a:	68 9b 00 00 00       	push   $0x9b
  80141f:	68 89 2f 80 00       	push   $0x802f89
  801424:	e8 5c ed ff ff       	call   800185 <_panic>
		panic("panic in sys_env_set_status()\n");
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	68 44 30 80 00       	push   $0x803044
  801431:	68 9e 00 00 00       	push   $0x9e
  801436:	68 89 2f 80 00       	push   $0x802f89
  80143b:	e8 45 ed ff ff       	call   800185 <_panic>

00801440 <sfork>:

// Challenge!
int
sfork(void)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	57                   	push   %edi
  801444:	56                   	push   %esi
  801445:	53                   	push   %ebx
  801446:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801449:	68 17 12 80 00       	push   $0x801217
  80144e:	e8 b1 13 00 00       	call   802804 <set_pgfault_handler>
  801453:	b8 07 00 00 00       	mov    $0x7,%eax
  801458:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 2a                	js     80148b <sfork+0x4b>
  801461:	89 c7                	mov    %eax,%edi
  801463:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801465:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80146a:	75 58                	jne    8014c4 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  80146c:	e8 1d f9 ff ff       	call   800d8e <sys_getenvid>
  801471:	25 ff 03 00 00       	and    $0x3ff,%eax
  801476:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80147c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801481:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801486:	e9 d4 00 00 00       	jmp    80155f <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 f8 2f 80 00       	push   $0x802ff8
  801493:	68 af 00 00 00       	push   $0xaf
  801498:	68 89 2f 80 00       	push   $0x802f89
  80149d:	e8 e3 ec ff ff       	call   800185 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  8014a2:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014a7:	89 f0                	mov    %esi,%eax
  8014a9:	e8 13 fc ff ff       	call   8010c1 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014ae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014b4:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014ba:	77 65                	ja     801521 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  8014bc:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014c2:	74 de                	je     8014a2 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014c4:	89 d8                	mov    %ebx,%eax
  8014c6:	c1 e8 16             	shr    $0x16,%eax
  8014c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014d0:	a8 01                	test   $0x1,%al
  8014d2:	74 da                	je     8014ae <sfork+0x6e>
  8014d4:	89 da                	mov    %ebx,%edx
  8014d6:	c1 ea 0c             	shr    $0xc,%edx
  8014d9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014e0:	83 e0 05             	and    $0x5,%eax
  8014e3:	83 f8 05             	cmp    $0x5,%eax
  8014e6:	75 c6                	jne    8014ae <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014e8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014ef:	c1 e2 0c             	shl    $0xc,%edx
  8014f2:	83 ec 0c             	sub    $0xc,%esp
  8014f5:	83 e0 07             	and    $0x7,%eax
  8014f8:	50                   	push   %eax
  8014f9:	52                   	push   %edx
  8014fa:	56                   	push   %esi
  8014fb:	52                   	push   %edx
  8014fc:	6a 00                	push   $0x0
  8014fe:	e8 0c f9 ff ff       	call   800e0f <sys_page_map>
  801503:	83 c4 20             	add    $0x20,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	74 a4                	je     8014ae <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 73 2f 80 00       	push   $0x802f73
  801512:	68 ba 00 00 00       	push   $0xba
  801517:	68 89 2f 80 00       	push   $0x802f89
  80151c:	e8 64 ec ff ff       	call   800185 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	6a 07                	push   $0x7
  801526:	68 00 f0 bf ee       	push   $0xeebff000
  80152b:	57                   	push   %edi
  80152c:	e8 9b f8 ff ff       	call   800dcc <sys_page_alloc>
	if(ret < 0)
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 31                	js     801569 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	68 73 28 80 00       	push   $0x802873
  801540:	57                   	push   %edi
  801541:	e8 d1 f9 ff ff       	call   800f17 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 33                	js     801580 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	6a 02                	push   $0x2
  801552:	57                   	push   %edi
  801553:	e8 3b f9 ff ff       	call   800e93 <sys_env_set_status>
	if(ret < 0)
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 38                	js     801597 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80155f:	89 f8                	mov    %edi,%eax
  801561:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5f                   	pop    %edi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	68 a8 2f 80 00       	push   $0x802fa8
  801571:	68 c0 00 00 00       	push   $0xc0
  801576:	68 89 2f 80 00       	push   $0x802f89
  80157b:	e8 05 ec ff ff       	call   800185 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 1c 30 80 00       	push   $0x80301c
  801588:	68 c3 00 00 00       	push   $0xc3
  80158d:	68 89 2f 80 00       	push   $0x802f89
  801592:	e8 ee eb ff ff       	call   800185 <_panic>
		panic("panic in sys_env_set_status()\n");
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	68 44 30 80 00       	push   $0x803044
  80159f:	68 c6 00 00 00       	push   $0xc6
  8015a4:	68 89 2f 80 00       	push   $0x802f89
  8015a9:	e8 d7 eb ff ff       	call   800185 <_panic>

008015ae <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	56                   	push   %esi
  8015b2:	53                   	push   %ebx
  8015b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8015bc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8015be:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8015c3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	50                   	push   %eax
  8015ca:	e8 ad f9 ff ff       	call   800f7c <sys_ipc_recv>
	if(ret < 0){
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	85 c0                	test   %eax,%eax
  8015d4:	78 2b                	js     801601 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8015d6:	85 f6                	test   %esi,%esi
  8015d8:	74 0a                	je     8015e4 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8015da:	a1 08 50 80 00       	mov    0x805008,%eax
  8015df:	8b 40 78             	mov    0x78(%eax),%eax
  8015e2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015e4:	85 db                	test   %ebx,%ebx
  8015e6:	74 0a                	je     8015f2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8015e8:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ed:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015f0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8015f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8015f7:	8b 40 74             	mov    0x74(%eax),%eax
}
  8015fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5e                   	pop    %esi
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    
		if(from_env_store)
  801601:	85 f6                	test   %esi,%esi
  801603:	74 06                	je     80160b <ipc_recv+0x5d>
			*from_env_store = 0;
  801605:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80160b:	85 db                	test   %ebx,%ebx
  80160d:	74 eb                	je     8015fa <ipc_recv+0x4c>
			*perm_store = 0;
  80160f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801615:	eb e3                	jmp    8015fa <ipc_recv+0x4c>

00801617 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	57                   	push   %edi
  80161b:	56                   	push   %esi
  80161c:	53                   	push   %ebx
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	8b 7d 08             	mov    0x8(%ebp),%edi
  801623:	8b 75 0c             	mov    0xc(%ebp),%esi
  801626:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801629:	85 db                	test   %ebx,%ebx
  80162b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801630:	0f 44 d8             	cmove  %eax,%ebx
  801633:	eb 05                	jmp    80163a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801635:	e8 73 f7 ff ff       	call   800dad <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80163a:	ff 75 14             	pushl  0x14(%ebp)
  80163d:	53                   	push   %ebx
  80163e:	56                   	push   %esi
  80163f:	57                   	push   %edi
  801640:	e8 14 f9 ff ff       	call   800f59 <sys_ipc_try_send>
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 1b                	je     801667 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80164c:	79 e7                	jns    801635 <ipc_send+0x1e>
  80164e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801651:	74 e2                	je     801635 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 63 30 80 00       	push   $0x803063
  80165b:	6a 46                	push   $0x46
  80165d:	68 78 30 80 00       	push   $0x803078
  801662:	e8 1e eb ff ff       	call   800185 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801667:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5f                   	pop    %edi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    

0080166f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80167a:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801680:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801686:	8b 52 50             	mov    0x50(%edx),%edx
  801689:	39 ca                	cmp    %ecx,%edx
  80168b:	74 11                	je     80169e <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80168d:	83 c0 01             	add    $0x1,%eax
  801690:	3d 00 04 00 00       	cmp    $0x400,%eax
  801695:	75 e3                	jne    80167a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	eb 0e                	jmp    8016ac <ipc_find_env+0x3d>
			return envs[i].env_id;
  80169e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8016a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016a9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	05 00 00 00 30       	add    $0x30000000,%eax
  8016b9:	c1 e8 0c             	shr    $0xc,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ce:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016d3:	5d                   	pop    %ebp
  8016d4:	c3                   	ret    

008016d5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016dd:	89 c2                	mov    %eax,%edx
  8016df:	c1 ea 16             	shr    $0x16,%edx
  8016e2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016e9:	f6 c2 01             	test   $0x1,%dl
  8016ec:	74 2d                	je     80171b <fd_alloc+0x46>
  8016ee:	89 c2                	mov    %eax,%edx
  8016f0:	c1 ea 0c             	shr    $0xc,%edx
  8016f3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016fa:	f6 c2 01             	test   $0x1,%dl
  8016fd:	74 1c                	je     80171b <fd_alloc+0x46>
  8016ff:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801704:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801709:	75 d2                	jne    8016dd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801714:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801719:	eb 0a                	jmp    801725 <fd_alloc+0x50>
			*fd_store = fd;
  80171b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80171e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    

00801727 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80172d:	83 f8 1f             	cmp    $0x1f,%eax
  801730:	77 30                	ja     801762 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801732:	c1 e0 0c             	shl    $0xc,%eax
  801735:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80173a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801740:	f6 c2 01             	test   $0x1,%dl
  801743:	74 24                	je     801769 <fd_lookup+0x42>
  801745:	89 c2                	mov    %eax,%edx
  801747:	c1 ea 0c             	shr    $0xc,%edx
  80174a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801751:	f6 c2 01             	test   $0x1,%dl
  801754:	74 1a                	je     801770 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	89 02                	mov    %eax,(%edx)
	return 0;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    
		return -E_INVAL;
  801762:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801767:	eb f7                	jmp    801760 <fd_lookup+0x39>
		return -E_INVAL;
  801769:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176e:	eb f0                	jmp    801760 <fd_lookup+0x39>
  801770:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801775:	eb e9                	jmp    801760 <fd_lookup+0x39>

00801777 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80178a:	39 08                	cmp    %ecx,(%eax)
  80178c:	74 38                	je     8017c6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80178e:	83 c2 01             	add    $0x1,%edx
  801791:	8b 04 95 00 31 80 00 	mov    0x803100(,%edx,4),%eax
  801798:	85 c0                	test   %eax,%eax
  80179a:	75 ee                	jne    80178a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80179c:	a1 08 50 80 00       	mov    0x805008,%eax
  8017a1:	8b 40 48             	mov    0x48(%eax),%eax
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	51                   	push   %ecx
  8017a8:	50                   	push   %eax
  8017a9:	68 84 30 80 00       	push   $0x803084
  8017ae:	e8 c8 ea ff ff       	call   80027b <cprintf>
	*dev = 0;
  8017b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    
			*dev = devtab[i];
  8017c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017c9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d0:	eb f2                	jmp    8017c4 <dev_lookup+0x4d>

008017d2 <fd_close>:
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	57                   	push   %edi
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	83 ec 24             	sub    $0x24,%esp
  8017db:	8b 75 08             	mov    0x8(%ebp),%esi
  8017de:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017e5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017eb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017ee:	50                   	push   %eax
  8017ef:	e8 33 ff ff ff       	call   801727 <fd_lookup>
  8017f4:	89 c3                	mov    %eax,%ebx
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 05                	js     801802 <fd_close+0x30>
	    || fd != fd2)
  8017fd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801800:	74 16                	je     801818 <fd_close+0x46>
		return (must_exist ? r : 0);
  801802:	89 f8                	mov    %edi,%eax
  801804:	84 c0                	test   %al,%al
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	0f 44 d8             	cmove  %eax,%ebx
}
  80180e:	89 d8                	mov    %ebx,%eax
  801810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80181e:	50                   	push   %eax
  80181f:	ff 36                	pushl  (%esi)
  801821:	e8 51 ff ff ff       	call   801777 <dev_lookup>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	85 c0                	test   %eax,%eax
  80182d:	78 1a                	js     801849 <fd_close+0x77>
		if (dev->dev_close)
  80182f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801832:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801835:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80183a:	85 c0                	test   %eax,%eax
  80183c:	74 0b                	je     801849 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	56                   	push   %esi
  801842:	ff d0                	call   *%eax
  801844:	89 c3                	mov    %eax,%ebx
  801846:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	56                   	push   %esi
  80184d:	6a 00                	push   $0x0
  80184f:	e8 fd f5 ff ff       	call   800e51 <sys_page_unmap>
	return r;
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	eb b5                	jmp    80180e <fd_close+0x3c>

00801859 <close>:

int
close(int fdnum)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	50                   	push   %eax
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	e8 bc fe ff ff       	call   801727 <fd_lookup>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	85 c0                	test   %eax,%eax
  801870:	79 02                	jns    801874 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    
		return fd_close(fd, 1);
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	6a 01                	push   $0x1
  801879:	ff 75 f4             	pushl  -0xc(%ebp)
  80187c:	e8 51 ff ff ff       	call   8017d2 <fd_close>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	eb ec                	jmp    801872 <close+0x19>

00801886 <close_all>:

void
close_all(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80188d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801892:	83 ec 0c             	sub    $0xc,%esp
  801895:	53                   	push   %ebx
  801896:	e8 be ff ff ff       	call   801859 <close>
	for (i = 0; i < MAXFD; i++)
  80189b:	83 c3 01             	add    $0x1,%ebx
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	83 fb 20             	cmp    $0x20,%ebx
  8018a4:	75 ec                	jne    801892 <close_all+0xc>
}
  8018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	57                   	push   %edi
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018b7:	50                   	push   %eax
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	e8 67 fe ff ff       	call   801727 <fd_lookup>
  8018c0:	89 c3                	mov    %eax,%ebx
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	0f 88 81 00 00 00    	js     80194e <dup+0xa3>
		return r;
	close(newfdnum);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	e8 81 ff ff ff       	call   801859 <close>

	newfd = INDEX2FD(newfdnum);
  8018d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018db:	c1 e6 0c             	shl    $0xc,%esi
  8018de:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018e4:	83 c4 04             	add    $0x4,%esp
  8018e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ea:	e8 cf fd ff ff       	call   8016be <fd2data>
  8018ef:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018f1:	89 34 24             	mov    %esi,(%esp)
  8018f4:	e8 c5 fd ff ff       	call   8016be <fd2data>
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018fe:	89 d8                	mov    %ebx,%eax
  801900:	c1 e8 16             	shr    $0x16,%eax
  801903:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80190a:	a8 01                	test   $0x1,%al
  80190c:	74 11                	je     80191f <dup+0x74>
  80190e:	89 d8                	mov    %ebx,%eax
  801910:	c1 e8 0c             	shr    $0xc,%eax
  801913:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80191a:	f6 c2 01             	test   $0x1,%dl
  80191d:	75 39                	jne    801958 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80191f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801922:	89 d0                	mov    %edx,%eax
  801924:	c1 e8 0c             	shr    $0xc,%eax
  801927:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	25 07 0e 00 00       	and    $0xe07,%eax
  801936:	50                   	push   %eax
  801937:	56                   	push   %esi
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	6a 00                	push   $0x0
  80193d:	e8 cd f4 ff ff       	call   800e0f <sys_page_map>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 20             	add    $0x20,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 31                	js     80197c <dup+0xd1>
		goto err;

	return newfdnum;
  80194b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5f                   	pop    %edi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801958:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	25 07 0e 00 00       	and    $0xe07,%eax
  801967:	50                   	push   %eax
  801968:	57                   	push   %edi
  801969:	6a 00                	push   $0x0
  80196b:	53                   	push   %ebx
  80196c:	6a 00                	push   $0x0
  80196e:	e8 9c f4 ff ff       	call   800e0f <sys_page_map>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 20             	add    $0x20,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	79 a3                	jns    80191f <dup+0x74>
	sys_page_unmap(0, newfd);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	56                   	push   %esi
  801980:	6a 00                	push   $0x0
  801982:	e8 ca f4 ff ff       	call   800e51 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801987:	83 c4 08             	add    $0x8,%esp
  80198a:	57                   	push   %edi
  80198b:	6a 00                	push   $0x0
  80198d:	e8 bf f4 ff ff       	call   800e51 <sys_page_unmap>
	return r;
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	eb b7                	jmp    80194e <dup+0xa3>

00801997 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 1c             	sub    $0x1c,%esp
  80199e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a4:	50                   	push   %eax
  8019a5:	53                   	push   %ebx
  8019a6:	e8 7c fd ff ff       	call   801727 <fd_lookup>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 3f                	js     8019f1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b8:	50                   	push   %eax
  8019b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bc:	ff 30                	pushl  (%eax)
  8019be:	e8 b4 fd ff ff       	call   801777 <dev_lookup>
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 27                	js     8019f1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019cd:	8b 42 08             	mov    0x8(%edx),%eax
  8019d0:	83 e0 03             	and    $0x3,%eax
  8019d3:	83 f8 01             	cmp    $0x1,%eax
  8019d6:	74 1e                	je     8019f6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019db:	8b 40 08             	mov    0x8(%eax),%eax
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	74 35                	je     801a17 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	ff 75 10             	pushl  0x10(%ebp)
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	52                   	push   %edx
  8019ec:	ff d0                	call   *%eax
  8019ee:	83 c4 10             	add    $0x10,%esp
}
  8019f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019f6:	a1 08 50 80 00       	mov    0x805008,%eax
  8019fb:	8b 40 48             	mov    0x48(%eax),%eax
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	53                   	push   %ebx
  801a02:	50                   	push   %eax
  801a03:	68 c5 30 80 00       	push   $0x8030c5
  801a08:	e8 6e e8 ff ff       	call   80027b <cprintf>
		return -E_INVAL;
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a15:	eb da                	jmp    8019f1 <read+0x5a>
		return -E_NOT_SUPP;
  801a17:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1c:	eb d3                	jmp    8019f1 <read+0x5a>

00801a1e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	57                   	push   %edi
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a2a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a32:	39 f3                	cmp    %esi,%ebx
  801a34:	73 23                	jae    801a59 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	89 f0                	mov    %esi,%eax
  801a3b:	29 d8                	sub    %ebx,%eax
  801a3d:	50                   	push   %eax
  801a3e:	89 d8                	mov    %ebx,%eax
  801a40:	03 45 0c             	add    0xc(%ebp),%eax
  801a43:	50                   	push   %eax
  801a44:	57                   	push   %edi
  801a45:	e8 4d ff ff ff       	call   801997 <read>
		if (m < 0)
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 06                	js     801a57 <readn+0x39>
			return m;
		if (m == 0)
  801a51:	74 06                	je     801a59 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a53:	01 c3                	add    %eax,%ebx
  801a55:	eb db                	jmp    801a32 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a57:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5f                   	pop    %edi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 1c             	sub    $0x1c,%esp
  801a6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a70:	50                   	push   %eax
  801a71:	53                   	push   %ebx
  801a72:	e8 b0 fc ff ff       	call   801727 <fd_lookup>
  801a77:	83 c4 10             	add    $0x10,%esp
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 3a                	js     801ab8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a7e:	83 ec 08             	sub    $0x8,%esp
  801a81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a84:	50                   	push   %eax
  801a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a88:	ff 30                	pushl  (%eax)
  801a8a:	e8 e8 fc ff ff       	call   801777 <dev_lookup>
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 22                	js     801ab8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a99:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a9d:	74 1e                	je     801abd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa2:	8b 52 0c             	mov    0xc(%edx),%edx
  801aa5:	85 d2                	test   %edx,%edx
  801aa7:	74 35                	je     801ade <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	ff 75 10             	pushl  0x10(%ebp)
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	ff d2                	call   *%edx
  801ab5:	83 c4 10             	add    $0x10,%esp
}
  801ab8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801abd:	a1 08 50 80 00       	mov    0x805008,%eax
  801ac2:	8b 40 48             	mov    0x48(%eax),%eax
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	53                   	push   %ebx
  801ac9:	50                   	push   %eax
  801aca:	68 e1 30 80 00       	push   $0x8030e1
  801acf:	e8 a7 e7 ff ff       	call   80027b <cprintf>
		return -E_INVAL;
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801adc:	eb da                	jmp    801ab8 <write+0x55>
		return -E_NOT_SUPP;
  801ade:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae3:	eb d3                	jmp    801ab8 <write+0x55>

00801ae5 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aee:	50                   	push   %eax
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	e8 30 fc ff ff       	call   801727 <fd_lookup>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 0e                	js     801b0c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b04:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	53                   	push   %ebx
  801b12:	83 ec 1c             	sub    $0x1c,%esp
  801b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1b:	50                   	push   %eax
  801b1c:	53                   	push   %ebx
  801b1d:	e8 05 fc ff ff       	call   801727 <fd_lookup>
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 37                	js     801b60 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b29:	83 ec 08             	sub    $0x8,%esp
  801b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b2f:	50                   	push   %eax
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	ff 30                	pushl  (%eax)
  801b35:	e8 3d fc ff ff       	call   801777 <dev_lookup>
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 1f                	js     801b60 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b44:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b48:	74 1b                	je     801b65 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4d:	8b 52 18             	mov    0x18(%edx),%edx
  801b50:	85 d2                	test   %edx,%edx
  801b52:	74 32                	je     801b86 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	50                   	push   %eax
  801b5b:	ff d2                	call   *%edx
  801b5d:	83 c4 10             	add    $0x10,%esp
}
  801b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b65:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b6a:	8b 40 48             	mov    0x48(%eax),%eax
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	53                   	push   %ebx
  801b71:	50                   	push   %eax
  801b72:	68 a4 30 80 00       	push   $0x8030a4
  801b77:	e8 ff e6 ff ff       	call   80027b <cprintf>
		return -E_INVAL;
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b84:	eb da                	jmp    801b60 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8b:	eb d3                	jmp    801b60 <ftruncate+0x52>

00801b8d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	53                   	push   %ebx
  801b91:	83 ec 1c             	sub    $0x1c,%esp
  801b94:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b97:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b9a:	50                   	push   %eax
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	e8 84 fb ff ff       	call   801727 <fd_lookup>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	78 4b                	js     801bf5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801baa:	83 ec 08             	sub    $0x8,%esp
  801bad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb0:	50                   	push   %eax
  801bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb4:	ff 30                	pushl  (%eax)
  801bb6:	e8 bc fb ff ff       	call   801777 <dev_lookup>
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	78 33                	js     801bf5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bc9:	74 2f                	je     801bfa <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bcb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bce:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bd5:	00 00 00 
	stat->st_isdir = 0;
  801bd8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bdf:	00 00 00 
	stat->st_dev = dev;
  801be2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	53                   	push   %ebx
  801bec:	ff 75 f0             	pushl  -0x10(%ebp)
  801bef:	ff 50 14             	call   *0x14(%eax)
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    
		return -E_NOT_SUPP;
  801bfa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bff:	eb f4                	jmp    801bf5 <fstat+0x68>

00801c01 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	56                   	push   %esi
  801c05:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c06:	83 ec 08             	sub    $0x8,%esp
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	e8 22 02 00 00       	call   801e35 <open>
  801c13:	89 c3                	mov    %eax,%ebx
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 1b                	js     801c37 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c1c:	83 ec 08             	sub    $0x8,%esp
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	50                   	push   %eax
  801c23:	e8 65 ff ff ff       	call   801b8d <fstat>
  801c28:	89 c6                	mov    %eax,%esi
	close(fd);
  801c2a:	89 1c 24             	mov    %ebx,(%esp)
  801c2d:	e8 27 fc ff ff       	call   801859 <close>
	return r;
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	89 f3                	mov    %esi,%ebx
}
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	56                   	push   %esi
  801c44:	53                   	push   %ebx
  801c45:	89 c6                	mov    %eax,%esi
  801c47:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c49:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c50:	74 27                	je     801c79 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c52:	6a 07                	push   $0x7
  801c54:	68 00 60 80 00       	push   $0x806000
  801c59:	56                   	push   %esi
  801c5a:	ff 35 00 50 80 00    	pushl  0x805000
  801c60:	e8 b2 f9 ff ff       	call   801617 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c65:	83 c4 0c             	add    $0xc,%esp
  801c68:	6a 00                	push   $0x0
  801c6a:	53                   	push   %ebx
  801c6b:	6a 00                	push   $0x0
  801c6d:	e8 3c f9 ff ff       	call   8015ae <ipc_recv>
}
  801c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	6a 01                	push   $0x1
  801c7e:	e8 ec f9 ff ff       	call   80166f <ipc_find_env>
  801c83:	a3 00 50 80 00       	mov    %eax,0x805000
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	eb c5                	jmp    801c52 <fsipc+0x12>

00801c8d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	8b 40 0c             	mov    0xc(%eax),%eax
  801c99:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca1:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb0:	e8 8b ff ff ff       	call   801c40 <fsipc>
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <devfile_flush>:
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc3:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cc8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccd:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd2:	e8 69 ff ff ff       	call   801c40 <fsipc>
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <devfile_stat>:
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cee:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  801cf8:	e8 43 ff ff ff       	call   801c40 <fsipc>
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	78 2c                	js     801d2d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d01:	83 ec 08             	sub    $0x8,%esp
  801d04:	68 00 60 80 00       	push   $0x806000
  801d09:	53                   	push   %ebx
  801d0a:	e8 cb ec ff ff       	call   8009da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d0f:	a1 80 60 80 00       	mov    0x806080,%eax
  801d14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d1a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d25:	83 c4 10             	add    $0x10,%esp
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <devfile_write>:
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	53                   	push   %ebx
  801d36:	83 ec 08             	sub    $0x8,%esp
  801d39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d42:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d47:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d4d:	53                   	push   %ebx
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	68 08 60 80 00       	push   $0x806008
  801d56:	e8 6f ee ff ff       	call   800bca <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d60:	b8 04 00 00 00       	mov    $0x4,%eax
  801d65:	e8 d6 fe ff ff       	call   801c40 <fsipc>
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	85 c0                	test   %eax,%eax
  801d6f:	78 0b                	js     801d7c <devfile_write+0x4a>
	assert(r <= n);
  801d71:	39 d8                	cmp    %ebx,%eax
  801d73:	77 0c                	ja     801d81 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d75:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d7a:	7f 1e                	jg     801d9a <devfile_write+0x68>
}
  801d7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    
	assert(r <= n);
  801d81:	68 14 31 80 00       	push   $0x803114
  801d86:	68 1b 31 80 00       	push   $0x80311b
  801d8b:	68 98 00 00 00       	push   $0x98
  801d90:	68 30 31 80 00       	push   $0x803130
  801d95:	e8 eb e3 ff ff       	call   800185 <_panic>
	assert(r <= PGSIZE);
  801d9a:	68 3b 31 80 00       	push   $0x80313b
  801d9f:	68 1b 31 80 00       	push   $0x80311b
  801da4:	68 99 00 00 00       	push   $0x99
  801da9:	68 30 31 80 00       	push   $0x803130
  801dae:	e8 d2 e3 ff ff       	call   800185 <_panic>

00801db3 <devfile_read>:
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dc6:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd1:	b8 03 00 00 00       	mov    $0x3,%eax
  801dd6:	e8 65 fe ff ff       	call   801c40 <fsipc>
  801ddb:	89 c3                	mov    %eax,%ebx
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	78 1f                	js     801e00 <devfile_read+0x4d>
	assert(r <= n);
  801de1:	39 f0                	cmp    %esi,%eax
  801de3:	77 24                	ja     801e09 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801de5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dea:	7f 33                	jg     801e1f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dec:	83 ec 04             	sub    $0x4,%esp
  801def:	50                   	push   %eax
  801df0:	68 00 60 80 00       	push   $0x806000
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	e8 6b ed ff ff       	call   800b68 <memmove>
	return r;
  801dfd:	83 c4 10             	add    $0x10,%esp
}
  801e00:	89 d8                	mov    %ebx,%eax
  801e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
	assert(r <= n);
  801e09:	68 14 31 80 00       	push   $0x803114
  801e0e:	68 1b 31 80 00       	push   $0x80311b
  801e13:	6a 7c                	push   $0x7c
  801e15:	68 30 31 80 00       	push   $0x803130
  801e1a:	e8 66 e3 ff ff       	call   800185 <_panic>
	assert(r <= PGSIZE);
  801e1f:	68 3b 31 80 00       	push   $0x80313b
  801e24:	68 1b 31 80 00       	push   $0x80311b
  801e29:	6a 7d                	push   $0x7d
  801e2b:	68 30 31 80 00       	push   $0x803130
  801e30:	e8 50 e3 ff ff       	call   800185 <_panic>

00801e35 <open>:
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 1c             	sub    $0x1c,%esp
  801e3d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e40:	56                   	push   %esi
  801e41:	e8 5b eb ff ff       	call   8009a1 <strlen>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e4e:	7f 6c                	jg     801ebc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e56:	50                   	push   %eax
  801e57:	e8 79 f8 ff ff       	call   8016d5 <fd_alloc>
  801e5c:	89 c3                	mov    %eax,%ebx
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	85 c0                	test   %eax,%eax
  801e63:	78 3c                	js     801ea1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e65:	83 ec 08             	sub    $0x8,%esp
  801e68:	56                   	push   %esi
  801e69:	68 00 60 80 00       	push   $0x806000
  801e6e:	e8 67 eb ff ff       	call   8009da <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e76:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e83:	e8 b8 fd ff ff       	call   801c40 <fsipc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 19                	js     801eaa <open+0x75>
	return fd2num(fd);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 f4             	pushl  -0xc(%ebp)
  801e97:	e8 12 f8 ff ff       	call   8016ae <fd2num>
  801e9c:	89 c3                	mov    %eax,%ebx
  801e9e:	83 c4 10             	add    $0x10,%esp
}
  801ea1:	89 d8                	mov    %ebx,%eax
  801ea3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ea6:	5b                   	pop    %ebx
  801ea7:	5e                   	pop    %esi
  801ea8:	5d                   	pop    %ebp
  801ea9:	c3                   	ret    
		fd_close(fd, 0);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	6a 00                	push   $0x0
  801eaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb2:	e8 1b f9 ff ff       	call   8017d2 <fd_close>
		return r;
  801eb7:	83 c4 10             	add    $0x10,%esp
  801eba:	eb e5                	jmp    801ea1 <open+0x6c>
		return -E_BAD_PATH;
  801ebc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ec1:	eb de                	jmp    801ea1 <open+0x6c>

00801ec3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ec9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ece:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed3:	e8 68 fd ff ff       	call   801c40 <fsipc>
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ee0:	68 47 31 80 00       	push   $0x803147
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	e8 ed ea ff ff       	call   8009da <strcpy>
	return 0;
}
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <devsock_close>:
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 10             	sub    $0x10,%esp
  801efb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801efe:	53                   	push   %ebx
  801eff:	e8 95 09 00 00       	call   802899 <pageref>
  801f04:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f07:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f0c:	83 f8 01             	cmp    $0x1,%eax
  801f0f:	74 07                	je     801f18 <devsock_close+0x24>
}
  801f11:	89 d0                	mov    %edx,%eax
  801f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	ff 73 0c             	pushl  0xc(%ebx)
  801f1e:	e8 b9 02 00 00       	call   8021dc <nsipc_close>
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	eb e7                	jmp    801f11 <devsock_close+0x1d>

00801f2a <devsock_write>:
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	ff 75 10             	pushl  0x10(%ebp)
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	ff 70 0c             	pushl  0xc(%eax)
  801f3e:	e8 76 03 00 00       	call   8022b9 <nsipc_send>
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <devsock_read>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	ff 75 10             	pushl  0x10(%ebp)
  801f50:	ff 75 0c             	pushl  0xc(%ebp)
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	ff 70 0c             	pushl  0xc(%eax)
  801f59:	e8 ef 02 00 00       	call   80224d <nsipc_recv>
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <fd2sockid>:
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f66:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	e8 b7 f7 ff ff       	call   801727 <fd_lookup>
  801f70:	83 c4 10             	add    $0x10,%esp
  801f73:	85 c0                	test   %eax,%eax
  801f75:	78 10                	js     801f87 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f80:	39 08                	cmp    %ecx,(%eax)
  801f82:	75 05                	jne    801f89 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f84:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    
		return -E_NOT_SUPP;
  801f89:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f8e:	eb f7                	jmp    801f87 <fd2sockid+0x27>

00801f90 <alloc_sockfd>:
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	56                   	push   %esi
  801f94:	53                   	push   %ebx
  801f95:	83 ec 1c             	sub    $0x1c,%esp
  801f98:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f9d:	50                   	push   %eax
  801f9e:	e8 32 f7 ff ff       	call   8016d5 <fd_alloc>
  801fa3:	89 c3                	mov    %eax,%ebx
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 43                	js     801fef <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 07 04 00 00       	push   $0x407
  801fb4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb7:	6a 00                	push   $0x0
  801fb9:	e8 0e ee ff ff       	call   800dcc <sys_page_alloc>
  801fbe:	89 c3                	mov    %eax,%ebx
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 28                	js     801fef <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fd0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fdc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fdf:	83 ec 0c             	sub    $0xc,%esp
  801fe2:	50                   	push   %eax
  801fe3:	e8 c6 f6 ff ff       	call   8016ae <fd2num>
  801fe8:	89 c3                	mov    %eax,%ebx
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	eb 0c                	jmp    801ffb <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	56                   	push   %esi
  801ff3:	e8 e4 01 00 00       	call   8021dc <nsipc_close>
		return r;
  801ff8:	83 c4 10             	add    $0x10,%esp
}
  801ffb:	89 d8                	mov    %ebx,%eax
  801ffd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802000:	5b                   	pop    %ebx
  802001:	5e                   	pop    %esi
  802002:	5d                   	pop    %ebp
  802003:	c3                   	ret    

00802004 <accept>:
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	e8 4e ff ff ff       	call   801f60 <fd2sockid>
  802012:	85 c0                	test   %eax,%eax
  802014:	78 1b                	js     802031 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	ff 75 10             	pushl  0x10(%ebp)
  80201c:	ff 75 0c             	pushl  0xc(%ebp)
  80201f:	50                   	push   %eax
  802020:	e8 0e 01 00 00       	call   802133 <nsipc_accept>
  802025:	83 c4 10             	add    $0x10,%esp
  802028:	85 c0                	test   %eax,%eax
  80202a:	78 05                	js     802031 <accept+0x2d>
	return alloc_sockfd(r);
  80202c:	e8 5f ff ff ff       	call   801f90 <alloc_sockfd>
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <bind>:
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	e8 1f ff ff ff       	call   801f60 <fd2sockid>
  802041:	85 c0                	test   %eax,%eax
  802043:	78 12                	js     802057 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	ff 75 10             	pushl  0x10(%ebp)
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	50                   	push   %eax
  80204f:	e8 31 01 00 00       	call   802185 <nsipc_bind>
  802054:	83 c4 10             	add    $0x10,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <shutdown>:
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	e8 f9 fe ff ff       	call   801f60 <fd2sockid>
  802067:	85 c0                	test   %eax,%eax
  802069:	78 0f                	js     80207a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80206b:	83 ec 08             	sub    $0x8,%esp
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	50                   	push   %eax
  802072:	e8 43 01 00 00       	call   8021ba <nsipc_shutdown>
  802077:	83 c4 10             	add    $0x10,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <connect>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	e8 d6 fe ff ff       	call   801f60 <fd2sockid>
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 12                	js     8020a0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	ff 75 10             	pushl  0x10(%ebp)
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	50                   	push   %eax
  802098:	e8 59 01 00 00       	call   8021f6 <nsipc_connect>
  80209d:	83 c4 10             	add    $0x10,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <listen>:
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	e8 b0 fe ff ff       	call   801f60 <fd2sockid>
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 0f                	js     8020c3 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020b4:	83 ec 08             	sub    $0x8,%esp
  8020b7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ba:	50                   	push   %eax
  8020bb:	e8 6b 01 00 00       	call   80222b <nsipc_listen>
  8020c0:	83 c4 10             	add    $0x10,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020cb:	ff 75 10             	pushl  0x10(%ebp)
  8020ce:	ff 75 0c             	pushl  0xc(%ebp)
  8020d1:	ff 75 08             	pushl  0x8(%ebp)
  8020d4:	e8 3e 02 00 00       	call   802317 <nsipc_socket>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 05                	js     8020e5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020e0:	e8 ab fe ff ff       	call   801f90 <alloc_sockfd>
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	53                   	push   %ebx
  8020eb:	83 ec 04             	sub    $0x4,%esp
  8020ee:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020f0:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020f7:	74 26                	je     80211f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f9:	6a 07                	push   $0x7
  8020fb:	68 00 70 80 00       	push   $0x807000
  802100:	53                   	push   %ebx
  802101:	ff 35 04 50 80 00    	pushl  0x805004
  802107:	e8 0b f5 ff ff       	call   801617 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80210c:	83 c4 0c             	add    $0xc,%esp
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	e8 94 f4 ff ff       	call   8015ae <ipc_recv>
}
  80211a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	6a 02                	push   $0x2
  802124:	e8 46 f5 ff ff       	call   80166f <ipc_find_env>
  802129:	a3 04 50 80 00       	mov    %eax,0x805004
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	eb c6                	jmp    8020f9 <nsipc+0x12>

00802133 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802143:	8b 06                	mov    (%esi),%eax
  802145:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80214a:	b8 01 00 00 00       	mov    $0x1,%eax
  80214f:	e8 93 ff ff ff       	call   8020e7 <nsipc>
  802154:	89 c3                	mov    %eax,%ebx
  802156:	85 c0                	test   %eax,%eax
  802158:	79 09                	jns    802163 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80215a:	89 d8                	mov    %ebx,%eax
  80215c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	ff 35 10 70 80 00    	pushl  0x807010
  80216c:	68 00 70 80 00       	push   $0x807000
  802171:	ff 75 0c             	pushl  0xc(%ebp)
  802174:	e8 ef e9 ff ff       	call   800b68 <memmove>
		*addrlen = ret->ret_addrlen;
  802179:	a1 10 70 80 00       	mov    0x807010,%eax
  80217e:	89 06                	mov    %eax,(%esi)
  802180:	83 c4 10             	add    $0x10,%esp
	return r;
  802183:	eb d5                	jmp    80215a <nsipc_accept+0x27>

00802185 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	53                   	push   %ebx
  802189:	83 ec 08             	sub    $0x8,%esp
  80218c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802197:	53                   	push   %ebx
  802198:	ff 75 0c             	pushl  0xc(%ebp)
  80219b:	68 04 70 80 00       	push   $0x807004
  8021a0:	e8 c3 e9 ff ff       	call   800b68 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021a5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ab:	b8 02 00 00 00       	mov    $0x2,%eax
  8021b0:	e8 32 ff ff ff       	call   8020e7 <nsipc>
}
  8021b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cb:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8021d5:	e8 0d ff ff ff       	call   8020e7 <nsipc>
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <nsipc_close>:

int
nsipc_close(int s)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8021ef:	e8 f3 fe ff ff       	call   8020e7 <nsipc>
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	53                   	push   %ebx
  8021fa:	83 ec 08             	sub    $0x8,%esp
  8021fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802208:	53                   	push   %ebx
  802209:	ff 75 0c             	pushl  0xc(%ebp)
  80220c:	68 04 70 80 00       	push   $0x807004
  802211:	e8 52 e9 ff ff       	call   800b68 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802216:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80221c:	b8 05 00 00 00       	mov    $0x5,%eax
  802221:	e8 c1 fe ff ff       	call   8020e7 <nsipc>
}
  802226:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802241:	b8 06 00 00 00       	mov    $0x6,%eax
  802246:	e8 9c fe ff ff       	call   8020e7 <nsipc>
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80225d:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802263:	8b 45 14             	mov    0x14(%ebp),%eax
  802266:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80226b:	b8 07 00 00 00       	mov    $0x7,%eax
  802270:	e8 72 fe ff ff       	call   8020e7 <nsipc>
  802275:	89 c3                	mov    %eax,%ebx
  802277:	85 c0                	test   %eax,%eax
  802279:	78 1f                	js     80229a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80227b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802280:	7f 21                	jg     8022a3 <nsipc_recv+0x56>
  802282:	39 c6                	cmp    %eax,%esi
  802284:	7c 1d                	jl     8022a3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	50                   	push   %eax
  80228a:	68 00 70 80 00       	push   $0x807000
  80228f:	ff 75 0c             	pushl  0xc(%ebp)
  802292:	e8 d1 e8 ff ff       	call   800b68 <memmove>
  802297:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80229a:	89 d8                	mov    %ebx,%eax
  80229c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022a3:	68 53 31 80 00       	push   $0x803153
  8022a8:	68 1b 31 80 00       	push   $0x80311b
  8022ad:	6a 62                	push   $0x62
  8022af:	68 68 31 80 00       	push   $0x803168
  8022b4:	e8 cc de ff ff       	call   800185 <_panic>

008022b9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	53                   	push   %ebx
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022cb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022d1:	7f 2e                	jg     802301 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	53                   	push   %ebx
  8022d7:	ff 75 0c             	pushl  0xc(%ebp)
  8022da:	68 0c 70 80 00       	push   $0x80700c
  8022df:	e8 84 e8 ff ff       	call   800b68 <memmove>
	nsipcbuf.send.req_size = size;
  8022e4:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ed:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8022f7:	e8 eb fd ff ff       	call   8020e7 <nsipc>
}
  8022fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    
	assert(size < 1600);
  802301:	68 74 31 80 00       	push   $0x803174
  802306:	68 1b 31 80 00       	push   $0x80311b
  80230b:	6a 6d                	push   $0x6d
  80230d:	68 68 31 80 00       	push   $0x803168
  802312:	e8 6e de ff ff       	call   800185 <_panic>

00802317 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802325:	8b 45 0c             	mov    0xc(%ebp),%eax
  802328:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80232d:	8b 45 10             	mov    0x10(%ebp),%eax
  802330:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802335:	b8 09 00 00 00       	mov    $0x9,%eax
  80233a:	e8 a8 fd ff ff       	call   8020e7 <nsipc>
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	56                   	push   %esi
  802345:	53                   	push   %ebx
  802346:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802349:	83 ec 0c             	sub    $0xc,%esp
  80234c:	ff 75 08             	pushl  0x8(%ebp)
  80234f:	e8 6a f3 ff ff       	call   8016be <fd2data>
  802354:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802356:	83 c4 08             	add    $0x8,%esp
  802359:	68 80 31 80 00       	push   $0x803180
  80235e:	53                   	push   %ebx
  80235f:	e8 76 e6 ff ff       	call   8009da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802364:	8b 46 04             	mov    0x4(%esi),%eax
  802367:	2b 06                	sub    (%esi),%eax
  802369:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80236f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802376:	00 00 00 
	stat->st_dev = &devpipe;
  802379:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802380:	40 80 00 
	return 0;
}
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    

0080238f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	53                   	push   %ebx
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802399:	53                   	push   %ebx
  80239a:	6a 00                	push   $0x0
  80239c:	e8 b0 ea ff ff       	call   800e51 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023a1:	89 1c 24             	mov    %ebx,(%esp)
  8023a4:	e8 15 f3 ff ff       	call   8016be <fd2data>
  8023a9:	83 c4 08             	add    $0x8,%esp
  8023ac:	50                   	push   %eax
  8023ad:	6a 00                	push   $0x0
  8023af:	e8 9d ea ff ff       	call   800e51 <sys_page_unmap>
}
  8023b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <_pipeisclosed>:
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	57                   	push   %edi
  8023bd:	56                   	push   %esi
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 1c             	sub    $0x1c,%esp
  8023c2:	89 c7                	mov    %eax,%edi
  8023c4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8023cb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	57                   	push   %edi
  8023d2:	e8 c2 04 00 00       	call   802899 <pageref>
  8023d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023da:	89 34 24             	mov    %esi,(%esp)
  8023dd:	e8 b7 04 00 00       	call   802899 <pageref>
		nn = thisenv->env_runs;
  8023e2:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023e8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	39 cb                	cmp    %ecx,%ebx
  8023f0:	74 1b                	je     80240d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023f2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f5:	75 cf                	jne    8023c6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023f7:	8b 42 58             	mov    0x58(%edx),%eax
  8023fa:	6a 01                	push   $0x1
  8023fc:	50                   	push   %eax
  8023fd:	53                   	push   %ebx
  8023fe:	68 87 31 80 00       	push   $0x803187
  802403:	e8 73 de ff ff       	call   80027b <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	eb b9                	jmp    8023c6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80240d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802410:	0f 94 c0             	sete   %al
  802413:	0f b6 c0             	movzbl %al,%eax
}
  802416:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802419:	5b                   	pop    %ebx
  80241a:	5e                   	pop    %esi
  80241b:	5f                   	pop    %edi
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <devpipe_write>:
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 28             	sub    $0x28,%esp
  802427:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80242a:	56                   	push   %esi
  80242b:	e8 8e f2 ff ff       	call   8016be <fd2data>
  802430:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802432:	83 c4 10             	add    $0x10,%esp
  802435:	bf 00 00 00 00       	mov    $0x0,%edi
  80243a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80243d:	74 4f                	je     80248e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80243f:	8b 43 04             	mov    0x4(%ebx),%eax
  802442:	8b 0b                	mov    (%ebx),%ecx
  802444:	8d 51 20             	lea    0x20(%ecx),%edx
  802447:	39 d0                	cmp    %edx,%eax
  802449:	72 14                	jb     80245f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80244b:	89 da                	mov    %ebx,%edx
  80244d:	89 f0                	mov    %esi,%eax
  80244f:	e8 65 ff ff ff       	call   8023b9 <_pipeisclosed>
  802454:	85 c0                	test   %eax,%eax
  802456:	75 3b                	jne    802493 <devpipe_write+0x75>
			sys_yield();
  802458:	e8 50 e9 ff ff       	call   800dad <sys_yield>
  80245d:	eb e0                	jmp    80243f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80245f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802462:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802466:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802469:	89 c2                	mov    %eax,%edx
  80246b:	c1 fa 1f             	sar    $0x1f,%edx
  80246e:	89 d1                	mov    %edx,%ecx
  802470:	c1 e9 1b             	shr    $0x1b,%ecx
  802473:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802476:	83 e2 1f             	and    $0x1f,%edx
  802479:	29 ca                	sub    %ecx,%edx
  80247b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80247f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802483:	83 c0 01             	add    $0x1,%eax
  802486:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802489:	83 c7 01             	add    $0x1,%edi
  80248c:	eb ac                	jmp    80243a <devpipe_write+0x1c>
	return i;
  80248e:	8b 45 10             	mov    0x10(%ebp),%eax
  802491:	eb 05                	jmp    802498 <devpipe_write+0x7a>
				return 0;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    

008024a0 <devpipe_read>:
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	57                   	push   %edi
  8024a4:	56                   	push   %esi
  8024a5:	53                   	push   %ebx
  8024a6:	83 ec 18             	sub    $0x18,%esp
  8024a9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024ac:	57                   	push   %edi
  8024ad:	e8 0c f2 ff ff       	call   8016be <fd2data>
  8024b2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024b4:	83 c4 10             	add    $0x10,%esp
  8024b7:	be 00 00 00 00       	mov    $0x0,%esi
  8024bc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024bf:	75 14                	jne    8024d5 <devpipe_read+0x35>
	return i;
  8024c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c4:	eb 02                	jmp    8024c8 <devpipe_read+0x28>
				return i;
  8024c6:	89 f0                	mov    %esi,%eax
}
  8024c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
			sys_yield();
  8024d0:	e8 d8 e8 ff ff       	call   800dad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024d5:	8b 03                	mov    (%ebx),%eax
  8024d7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024da:	75 18                	jne    8024f4 <devpipe_read+0x54>
			if (i > 0)
  8024dc:	85 f6                	test   %esi,%esi
  8024de:	75 e6                	jne    8024c6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	89 f8                	mov    %edi,%eax
  8024e4:	e8 d0 fe ff ff       	call   8023b9 <_pipeisclosed>
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 e3                	je     8024d0 <devpipe_read+0x30>
				return 0;
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f2:	eb d4                	jmp    8024c8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024f4:	99                   	cltd   
  8024f5:	c1 ea 1b             	shr    $0x1b,%edx
  8024f8:	01 d0                	add    %edx,%eax
  8024fa:	83 e0 1f             	and    $0x1f,%eax
  8024fd:	29 d0                	sub    %edx,%eax
  8024ff:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802504:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802507:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80250a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80250d:	83 c6 01             	add    $0x1,%esi
  802510:	eb aa                	jmp    8024bc <devpipe_read+0x1c>

00802512 <pipe>:
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
  802515:	56                   	push   %esi
  802516:	53                   	push   %ebx
  802517:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80251a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251d:	50                   	push   %eax
  80251e:	e8 b2 f1 ff ff       	call   8016d5 <fd_alloc>
  802523:	89 c3                	mov    %eax,%ebx
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	85 c0                	test   %eax,%eax
  80252a:	0f 88 23 01 00 00    	js     802653 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	68 07 04 00 00       	push   $0x407
  802538:	ff 75 f4             	pushl  -0xc(%ebp)
  80253b:	6a 00                	push   $0x0
  80253d:	e8 8a e8 ff ff       	call   800dcc <sys_page_alloc>
  802542:	89 c3                	mov    %eax,%ebx
  802544:	83 c4 10             	add    $0x10,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	0f 88 04 01 00 00    	js     802653 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802555:	50                   	push   %eax
  802556:	e8 7a f1 ff ff       	call   8016d5 <fd_alloc>
  80255b:	89 c3                	mov    %eax,%ebx
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	85 c0                	test   %eax,%eax
  802562:	0f 88 db 00 00 00    	js     802643 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802568:	83 ec 04             	sub    $0x4,%esp
  80256b:	68 07 04 00 00       	push   $0x407
  802570:	ff 75 f0             	pushl  -0x10(%ebp)
  802573:	6a 00                	push   $0x0
  802575:	e8 52 e8 ff ff       	call   800dcc <sys_page_alloc>
  80257a:	89 c3                	mov    %eax,%ebx
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	85 c0                	test   %eax,%eax
  802581:	0f 88 bc 00 00 00    	js     802643 <pipe+0x131>
	va = fd2data(fd0);
  802587:	83 ec 0c             	sub    $0xc,%esp
  80258a:	ff 75 f4             	pushl  -0xc(%ebp)
  80258d:	e8 2c f1 ff ff       	call   8016be <fd2data>
  802592:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802594:	83 c4 0c             	add    $0xc,%esp
  802597:	68 07 04 00 00       	push   $0x407
  80259c:	50                   	push   %eax
  80259d:	6a 00                	push   $0x0
  80259f:	e8 28 e8 ff ff       	call   800dcc <sys_page_alloc>
  8025a4:	89 c3                	mov    %eax,%ebx
  8025a6:	83 c4 10             	add    $0x10,%esp
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	0f 88 82 00 00 00    	js     802633 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8025b7:	e8 02 f1 ff ff       	call   8016be <fd2data>
  8025bc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025c3:	50                   	push   %eax
  8025c4:	6a 00                	push   $0x0
  8025c6:	56                   	push   %esi
  8025c7:	6a 00                	push   $0x0
  8025c9:	e8 41 e8 ff ff       	call   800e0f <sys_page_map>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	83 c4 20             	add    $0x20,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	78 4e                	js     802625 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025d7:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025df:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ee:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025fa:	83 ec 0c             	sub    $0xc,%esp
  8025fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802600:	e8 a9 f0 ff ff       	call   8016ae <fd2num>
  802605:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802608:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80260a:	83 c4 04             	add    $0x4,%esp
  80260d:	ff 75 f0             	pushl  -0x10(%ebp)
  802610:	e8 99 f0 ff ff       	call   8016ae <fd2num>
  802615:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802618:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80261b:	83 c4 10             	add    $0x10,%esp
  80261e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802623:	eb 2e                	jmp    802653 <pipe+0x141>
	sys_page_unmap(0, va);
  802625:	83 ec 08             	sub    $0x8,%esp
  802628:	56                   	push   %esi
  802629:	6a 00                	push   $0x0
  80262b:	e8 21 e8 ff ff       	call   800e51 <sys_page_unmap>
  802630:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802633:	83 ec 08             	sub    $0x8,%esp
  802636:	ff 75 f0             	pushl  -0x10(%ebp)
  802639:	6a 00                	push   $0x0
  80263b:	e8 11 e8 ff ff       	call   800e51 <sys_page_unmap>
  802640:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802643:	83 ec 08             	sub    $0x8,%esp
  802646:	ff 75 f4             	pushl  -0xc(%ebp)
  802649:	6a 00                	push   $0x0
  80264b:	e8 01 e8 ff ff       	call   800e51 <sys_page_unmap>
  802650:	83 c4 10             	add    $0x10,%esp
}
  802653:	89 d8                	mov    %ebx,%eax
  802655:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802658:	5b                   	pop    %ebx
  802659:	5e                   	pop    %esi
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    

0080265c <pipeisclosed>:
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802662:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802665:	50                   	push   %eax
  802666:	ff 75 08             	pushl  0x8(%ebp)
  802669:	e8 b9 f0 ff ff       	call   801727 <fd_lookup>
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	85 c0                	test   %eax,%eax
  802673:	78 18                	js     80268d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	ff 75 f4             	pushl  -0xc(%ebp)
  80267b:	e8 3e f0 ff ff       	call   8016be <fd2data>
	return _pipeisclosed(fd, p);
  802680:	89 c2                	mov    %eax,%edx
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	e8 2f fd ff ff       	call   8023b9 <_pipeisclosed>
  80268a:	83 c4 10             	add    $0x10,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	c3                   	ret    

00802695 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80269b:	68 9f 31 80 00       	push   $0x80319f
  8026a0:	ff 75 0c             	pushl  0xc(%ebp)
  8026a3:	e8 32 e3 ff ff       	call   8009da <strcpy>
	return 0;
}
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <devcons_write>:
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	57                   	push   %edi
  8026b3:	56                   	push   %esi
  8026b4:	53                   	push   %ebx
  8026b5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026bb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026c0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026c6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026c9:	73 31                	jae    8026fc <devcons_write+0x4d>
		m = n - tot;
  8026cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026ce:	29 f3                	sub    %esi,%ebx
  8026d0:	83 fb 7f             	cmp    $0x7f,%ebx
  8026d3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026d8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	53                   	push   %ebx
  8026df:	89 f0                	mov    %esi,%eax
  8026e1:	03 45 0c             	add    0xc(%ebp),%eax
  8026e4:	50                   	push   %eax
  8026e5:	57                   	push   %edi
  8026e6:	e8 7d e4 ff ff       	call   800b68 <memmove>
		sys_cputs(buf, m);
  8026eb:	83 c4 08             	add    $0x8,%esp
  8026ee:	53                   	push   %ebx
  8026ef:	57                   	push   %edi
  8026f0:	e8 1b e6 ff ff       	call   800d10 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026f5:	01 de                	add    %ebx,%esi
  8026f7:	83 c4 10             	add    $0x10,%esp
  8026fa:	eb ca                	jmp    8026c6 <devcons_write+0x17>
}
  8026fc:	89 f0                	mov    %esi,%eax
  8026fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <devcons_read>:
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 08             	sub    $0x8,%esp
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802711:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802715:	74 21                	je     802738 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802717:	e8 12 e6 ff ff       	call   800d2e <sys_cgetc>
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 07                	jne    802727 <devcons_read+0x21>
		sys_yield();
  802720:	e8 88 e6 ff ff       	call   800dad <sys_yield>
  802725:	eb f0                	jmp    802717 <devcons_read+0x11>
	if (c < 0)
  802727:	78 0f                	js     802738 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802729:	83 f8 04             	cmp    $0x4,%eax
  80272c:	74 0c                	je     80273a <devcons_read+0x34>
	*(char*)vbuf = c;
  80272e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802731:	88 02                	mov    %al,(%edx)
	return 1;
  802733:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802738:	c9                   	leave  
  802739:	c3                   	ret    
		return 0;
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	eb f7                	jmp    802738 <devcons_read+0x32>

00802741 <cputchar>:
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80274d:	6a 01                	push   $0x1
  80274f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802752:	50                   	push   %eax
  802753:	e8 b8 e5 ff ff       	call   800d10 <sys_cputs>
}
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <getchar>:
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802763:	6a 01                	push   $0x1
  802765:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802768:	50                   	push   %eax
  802769:	6a 00                	push   $0x0
  80276b:	e8 27 f2 ff ff       	call   801997 <read>
	if (r < 0)
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	85 c0                	test   %eax,%eax
  802775:	78 06                	js     80277d <getchar+0x20>
	if (r < 1)
  802777:	74 06                	je     80277f <getchar+0x22>
	return c;
  802779:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    
		return -E_EOF;
  80277f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802784:	eb f7                	jmp    80277d <getchar+0x20>

00802786 <iscons>:
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80278f:	50                   	push   %eax
  802790:	ff 75 08             	pushl  0x8(%ebp)
  802793:	e8 8f ef ff ff       	call   801727 <fd_lookup>
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	85 c0                	test   %eax,%eax
  80279d:	78 11                	js     8027b0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027a8:	39 10                	cmp    %edx,(%eax)
  8027aa:	0f 94 c0             	sete   %al
  8027ad:	0f b6 c0             	movzbl %al,%eax
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <opencons>:
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
  8027b5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027bb:	50                   	push   %eax
  8027bc:	e8 14 ef ff ff       	call   8016d5 <fd_alloc>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 3a                	js     802802 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 07 04 00 00       	push   $0x407
  8027d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8027d3:	6a 00                	push   $0x0
  8027d5:	e8 f2 e5 ff ff       	call   800dcc <sys_page_alloc>
  8027da:	83 c4 10             	add    $0x10,%esp
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	78 21                	js     802802 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ea:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	50                   	push   %eax
  8027fa:	e8 af ee ff ff       	call   8016ae <fd2num>
  8027ff:	83 c4 10             	add    $0x10,%esp
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80280a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802811:	74 0a                	je     80281d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	6a 07                	push   $0x7
  802822:	68 00 f0 bf ee       	push   $0xeebff000
  802827:	6a 00                	push   $0x0
  802829:	e8 9e e5 ff ff       	call   800dcc <sys_page_alloc>
		if(r < 0)
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	85 c0                	test   %eax,%eax
  802833:	78 2a                	js     80285f <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802835:	83 ec 08             	sub    $0x8,%esp
  802838:	68 73 28 80 00       	push   $0x802873
  80283d:	6a 00                	push   $0x0
  80283f:	e8 d3 e6 ff ff       	call   800f17 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802844:	83 c4 10             	add    $0x10,%esp
  802847:	85 c0                	test   %eax,%eax
  802849:	79 c8                	jns    802813 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 dc 31 80 00       	push   $0x8031dc
  802853:	6a 25                	push   $0x25
  802855:	68 18 32 80 00       	push   $0x803218
  80285a:	e8 26 d9 ff ff       	call   800185 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 ac 31 80 00       	push   $0x8031ac
  802867:	6a 22                	push   $0x22
  802869:	68 18 32 80 00       	push   $0x803218
  80286e:	e8 12 d9 ff ff       	call   800185 <_panic>

00802873 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802873:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802874:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802879:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80287b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80287e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802882:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802886:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802889:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80288b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80288f:	83 c4 08             	add    $0x8,%esp
	popal
  802892:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802893:	83 c4 04             	add    $0x4,%esp
	popfl
  802896:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802897:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802898:	c3                   	ret    

00802899 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802899:	55                   	push   %ebp
  80289a:	89 e5                	mov    %esp,%ebp
  80289c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80289f:	89 d0                	mov    %edx,%eax
  8028a1:	c1 e8 16             	shr    $0x16,%eax
  8028a4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028ab:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028b0:	f6 c1 01             	test   $0x1,%cl
  8028b3:	74 1d                	je     8028d2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028b5:	c1 ea 0c             	shr    $0xc,%edx
  8028b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028bf:	f6 c2 01             	test   $0x1,%dl
  8028c2:	74 0e                	je     8028d2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028c4:	c1 ea 0c             	shr    $0xc,%edx
  8028c7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028ce:	ef 
  8028cf:	0f b7 c0             	movzwl %ax,%eax
}
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
  8028d4:	66 90                	xchg   %ax,%ax
  8028d6:	66 90                	xchg   %ax,%ax
  8028d8:	66 90                	xchg   %ax,%ax
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

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
