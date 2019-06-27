
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
  80003c:	68 e4 2b 80 00       	push   $0x802be4
  800041:	68 4a 2c 80 00       	push   $0x802c4a
  800046:	e8 c2 02 00 00       	call   80030d <cprintf>
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
  800059:	e8 e2 15 00 00       	call   801640 <ipc_recv>
  80005e:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800060:	a1 08 50 80 00       	mov    0x805008,%eax
  800065:	8b 40 5c             	mov    0x5c(%eax),%eax
  800068:	83 c4 0c             	add    $0xc,%esp
  80006b:	53                   	push   %ebx
  80006c:	50                   	push   %eax
  80006d:	68 c0 2b 80 00       	push   $0x802bc0
  800072:	e8 96 02 00 00       	call   80030d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800077:	e8 2c 13 00 00       	call   8013a8 <fork>
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
  80008d:	68 cc 2b 80 00       	push   $0x802bcc
  800092:	6a 1b                	push   $0x1b
  800094:	68 d5 2b 80 00       	push   $0x802bd5
  800099:	e8 79 01 00 00       	call   800217 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	51                   	push   %ecx
  8000a3:	57                   	push   %edi
  8000a4:	e8 00 16 00 00       	call   8016a9 <ipc_send>
  8000a9:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  8000ac:	83 ec 04             	sub    $0x4,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	56                   	push   %esi
  8000b4:	e8 87 15 00 00       	call   801640 <ipc_recv>
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
  8000cc:	e8 d7 12 00 00       	call   8013a8 <fork>
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
  8000e4:	e8 c0 15 00 00       	call   8016a9 <ipc_send>
	for (i = 2; ; i++)
  8000e9:	83 c3 01             	add    $0x1,%ebx
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	eb ed                	jmp    8000de <umain+0x17>
		panic("fork: %e", id);
  8000f1:	50                   	push   %eax
  8000f2:	68 cc 2b 80 00       	push   $0x802bcc
  8000f7:	6a 2e                	push   $0x2e
  8000f9:	68 d5 2b 80 00       	push   $0x802bd5
  8000fe:	e8 14 01 00 00       	call   800217 <_panic>
		primeproc();
  800103:	e8 2b ff ff ff       	call   800033 <primeproc>

00800108 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800111:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800118:	00 00 00 
	envid_t find = sys_getenvid();
  80011b:	e8 00 0d 00 00       	call   800e20 <sys_getenvid>
  800120:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800126:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80012b:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800130:	bf 01 00 00 00       	mov    $0x1,%edi
  800135:	eb 0b                	jmp    800142 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800137:	83 c2 01             	add    $0x1,%edx
  80013a:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800140:	74 23                	je     800165 <libmain+0x5d>
		if(envs[i].env_id == find)
  800142:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800148:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80014e:	8b 49 48             	mov    0x48(%ecx),%ecx
  800151:	39 c1                	cmp    %eax,%ecx
  800153:	75 e2                	jne    800137 <libmain+0x2f>
  800155:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80015b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800161:	89 fe                	mov    %edi,%esi
  800163:	eb d2                	jmp    800137 <libmain+0x2f>
  800165:	89 f0                	mov    %esi,%eax
  800167:	84 c0                	test   %al,%al
  800169:	74 06                	je     800171 <libmain+0x69>
  80016b:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800175:	7e 0a                	jle    800181 <libmain+0x79>
		binaryname = argv[0];
  800177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800181:	a1 08 50 80 00       	mov    0x805008,%eax
  800186:	8b 40 48             	mov    0x48(%eax),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	68 ee 2b 80 00       	push   $0x802bee
  800192:	e8 76 01 00 00       	call   80030d <cprintf>
	cprintf("before umain\n");
  800197:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  80019e:	e8 6a 01 00 00       	call   80030d <cprintf>
	// call user main routine
	umain(argc, argv);
  8001a3:	83 c4 08             	add    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 16 ff ff ff       	call   8000c7 <umain>
	cprintf("after umain\n");
  8001b1:	c7 04 24 1a 2c 80 00 	movl   $0x802c1a,(%esp)
  8001b8:	e8 50 01 00 00       	call   80030d <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001bd:	a1 08 50 80 00       	mov    0x805008,%eax
  8001c2:	8b 40 48             	mov    0x48(%eax),%eax
  8001c5:	83 c4 08             	add    $0x8,%esp
  8001c8:	50                   	push   %eax
  8001c9:	68 27 2c 80 00       	push   $0x802c27
  8001ce:	e8 3a 01 00 00       	call   80030d <cprintf>
	// exit gracefully
	exit();
  8001d3:	e8 0b 00 00 00       	call   8001e3 <exit>
}
  8001d8:	83 c4 10             	add    $0x10,%esp
  8001db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5f                   	pop    %edi
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    

008001e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001e9:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ee:	8b 40 48             	mov    0x48(%eax),%eax
  8001f1:	68 54 2c 80 00       	push   $0x802c54
  8001f6:	50                   	push   %eax
  8001f7:	68 46 2c 80 00       	push   $0x802c46
  8001fc:	e8 0c 01 00 00       	call   80030d <cprintf>
	close_all();
  800201:	e8 12 17 00 00       	call   801918 <close_all>
	sys_env_destroy(0);
  800206:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80020d:	e8 cd 0b 00 00       	call   800ddf <sys_env_destroy>
}
  800212:	83 c4 10             	add    $0x10,%esp
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	56                   	push   %esi
  80021b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80021c:	a1 08 50 80 00       	mov    0x805008,%eax
  800221:	8b 40 48             	mov    0x48(%eax),%eax
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 80 2c 80 00       	push   $0x802c80
  80022c:	50                   	push   %eax
  80022d:	68 46 2c 80 00       	push   $0x802c46
  800232:	e8 d6 00 00 00       	call   80030d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800237:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023a:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800240:	e8 db 0b 00 00       	call   800e20 <sys_getenvid>
  800245:	83 c4 04             	add    $0x4,%esp
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	56                   	push   %esi
  80024f:	50                   	push   %eax
  800250:	68 5c 2c 80 00       	push   $0x802c5c
  800255:	e8 b3 00 00 00       	call   80030d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	53                   	push   %ebx
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	e8 56 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  800266:	c7 04 24 0a 2c 80 00 	movl   $0x802c0a,(%esp)
  80026d:	e8 9b 00 00 00       	call   80030d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x5e>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	74 09                	je     8002a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800297:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	68 ff 00 00 00       	push   $0xff
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	50                   	push   %eax
  8002ac:	e8 f1 0a 00 00       	call   800da2 <sys_cputs>
		b->idx = 0;
  8002b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb db                	jmp    800297 <putch+0x1f>

008002bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	68 78 02 80 00       	push   $0x800278
  8002eb:	e8 4a 01 00 00       	call   80043a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f0:	83 c4 08             	add    $0x8,%esp
  8002f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 9d 0a 00 00       	call   800da2 <sys_cputs>

	return b.cnt;
}
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 9d ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 1c             	sub    $0x1c,%esp
  80032a:	89 c6                	mov    %eax,%esi
  80032c:	89 d7                	mov    %edx,%edi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	8b 55 0c             	mov    0xc(%ebp),%edx
  800334:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800337:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800340:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800344:	74 2c                	je     800372 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800346:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800349:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800350:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800353:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800356:	39 c2                	cmp    %eax,%edx
  800358:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80035b:	73 43                	jae    8003a0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80035d:	83 eb 01             	sub    $0x1,%ebx
  800360:	85 db                	test   %ebx,%ebx
  800362:	7e 6c                	jle    8003d0 <printnum+0xaf>
				putch(padc, putdat);
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	57                   	push   %edi
  800368:	ff 75 18             	pushl  0x18(%ebp)
  80036b:	ff d6                	call   *%esi
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	eb eb                	jmp    80035d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 20                	push   $0x20
  800377:	6a 00                	push   $0x0
  800379:	50                   	push   %eax
  80037a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037d:	ff 75 e0             	pushl  -0x20(%ebp)
  800380:	89 fa                	mov    %edi,%edx
  800382:	89 f0                	mov    %esi,%eax
  800384:	e8 98 ff ff ff       	call   800321 <printnum>
		while (--width > 0)
  800389:	83 c4 20             	add    $0x20,%esp
  80038c:	83 eb 01             	sub    $0x1,%ebx
  80038f:	85 db                	test   %ebx,%ebx
  800391:	7e 65                	jle    8003f8 <printnum+0xd7>
			putch(padc, putdat);
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	57                   	push   %edi
  800397:	6a 20                	push   $0x20
  800399:	ff d6                	call   *%esi
  80039b:	83 c4 10             	add    $0x10,%esp
  80039e:	eb ec                	jmp    80038c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	ff 75 18             	pushl  0x18(%ebp)
  8003a6:	83 eb 01             	sub    $0x1,%ebx
  8003a9:	53                   	push   %ebx
  8003aa:	50                   	push   %eax
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ba:	e8 b1 25 00 00       	call   802970 <__udivdi3>
  8003bf:	83 c4 18             	add    $0x18,%esp
  8003c2:	52                   	push   %edx
  8003c3:	50                   	push   %eax
  8003c4:	89 fa                	mov    %edi,%edx
  8003c6:	89 f0                	mov    %esi,%eax
  8003c8:	e8 54 ff ff ff       	call   800321 <printnum>
  8003cd:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003d0:	83 ec 08             	sub    $0x8,%esp
  8003d3:	57                   	push   %edi
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8003da:	ff 75 d8             	pushl  -0x28(%ebp)
  8003dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e3:	e8 98 26 00 00       	call   802a80 <__umoddi3>
  8003e8:	83 c4 14             	add    $0x14,%esp
  8003eb:	0f be 80 87 2c 80 00 	movsbl 0x802c87(%eax),%eax
  8003f2:	50                   	push   %eax
  8003f3:	ff d6                	call   *%esi
  8003f5:	83 c4 10             	add    $0x10,%esp
	}
}
  8003f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fb:	5b                   	pop    %ebx
  8003fc:	5e                   	pop    %esi
  8003fd:	5f                   	pop    %edi
  8003fe:	5d                   	pop    %ebp
  8003ff:	c3                   	ret    

00800400 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800406:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80040a:	8b 10                	mov    (%eax),%edx
  80040c:	3b 50 04             	cmp    0x4(%eax),%edx
  80040f:	73 0a                	jae    80041b <sprintputch+0x1b>
		*b->buf++ = ch;
  800411:	8d 4a 01             	lea    0x1(%edx),%ecx
  800414:	89 08                	mov    %ecx,(%eax)
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	88 02                	mov    %al,(%edx)
}
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    

0080041d <printfmt>:
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800423:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800426:	50                   	push   %eax
  800427:	ff 75 10             	pushl  0x10(%ebp)
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	e8 05 00 00 00       	call   80043a <vprintfmt>
}
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <vprintfmt>:
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	57                   	push   %edi
  80043e:	56                   	push   %esi
  80043f:	53                   	push   %ebx
  800440:	83 ec 3c             	sub    $0x3c,%esp
  800443:	8b 75 08             	mov    0x8(%ebp),%esi
  800446:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800449:	8b 7d 10             	mov    0x10(%ebp),%edi
  80044c:	e9 32 04 00 00       	jmp    800883 <vprintfmt+0x449>
		padc = ' ';
  800451:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800455:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80045c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800463:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80046a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800471:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800478:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8d 47 01             	lea    0x1(%edi),%eax
  800480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800483:	0f b6 17             	movzbl (%edi),%edx
  800486:	8d 42 dd             	lea    -0x23(%edx),%eax
  800489:	3c 55                	cmp    $0x55,%al
  80048b:	0f 87 12 05 00 00    	ja     8009a3 <vprintfmt+0x569>
  800491:	0f b6 c0             	movzbl %al,%eax
  800494:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
  80049b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004a2:	eb d9                	jmp    80047d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004a7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004ab:	eb d0                	jmp    80047d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	0f b6 d2             	movzbl %dl,%edx
  8004b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004bb:	eb 03                	jmp    8004c0 <vprintfmt+0x86>
  8004bd:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004c3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ca:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004cd:	83 fe 09             	cmp    $0x9,%esi
  8004d0:	76 eb                	jbe    8004bd <vprintfmt+0x83>
  8004d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d8:	eb 14                	jmp    8004ee <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	8d 40 04             	lea    0x4(%eax),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f2:	79 89                	jns    80047d <vprintfmt+0x43>
				width = precision, precision = -1;
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800501:	e9 77 ff ff ff       	jmp    80047d <vprintfmt+0x43>
  800506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800509:	85 c0                	test   %eax,%eax
  80050b:	0f 48 c1             	cmovs  %ecx,%eax
  80050e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800511:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800514:	e9 64 ff ff ff       	jmp    80047d <vprintfmt+0x43>
  800519:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80051c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800523:	e9 55 ff ff ff       	jmp    80047d <vprintfmt+0x43>
			lflag++;
  800528:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80052f:	e9 49 ff ff ff       	jmp    80047d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 78 04             	lea    0x4(%eax),%edi
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	ff 30                	pushl  (%eax)
  800540:	ff d6                	call   *%esi
			break;
  800542:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800545:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800548:	e9 33 03 00 00       	jmp    800880 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80054d:	8b 45 14             	mov    0x14(%ebp),%eax
  800550:	8d 78 04             	lea    0x4(%eax),%edi
  800553:	8b 00                	mov    (%eax),%eax
  800555:	99                   	cltd   
  800556:	31 d0                	xor    %edx,%eax
  800558:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055a:	83 f8 11             	cmp    $0x11,%eax
  80055d:	7f 23                	jg     800582 <vprintfmt+0x148>
  80055f:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800566:	85 d2                	test   %edx,%edx
  800568:	74 18                	je     800582 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80056a:	52                   	push   %edx
  80056b:	68 ed 31 80 00       	push   $0x8031ed
  800570:	53                   	push   %ebx
  800571:	56                   	push   %esi
  800572:	e8 a6 fe ff ff       	call   80041d <printfmt>
  800577:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057d:	e9 fe 02 00 00       	jmp    800880 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800582:	50                   	push   %eax
  800583:	68 9f 2c 80 00       	push   $0x802c9f
  800588:	53                   	push   %ebx
  800589:	56                   	push   %esi
  80058a:	e8 8e fe ff ff       	call   80041d <printfmt>
  80058f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800592:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800595:	e9 e6 02 00 00       	jmp    800880 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	83 c0 04             	add    $0x4,%eax
  8005a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005a8:	85 c9                	test   %ecx,%ecx
  8005aa:	b8 98 2c 80 00       	mov    $0x802c98,%eax
  8005af:	0f 45 c1             	cmovne %ecx,%eax
  8005b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b9:	7e 06                	jle    8005c1 <vprintfmt+0x187>
  8005bb:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005bf:	75 0d                	jne    8005ce <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c4:	89 c7                	mov    %eax,%edi
  8005c6:	03 45 e0             	add    -0x20(%ebp),%eax
  8005c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cc:	eb 53                	jmp    800621 <vprintfmt+0x1e7>
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d4:	50                   	push   %eax
  8005d5:	e8 71 04 00 00       	call   800a4b <strnlen>
  8005da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005e7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ee:	eb 0f                	jmp    8005ff <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	83 ef 01             	sub    $0x1,%edi
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	85 ff                	test   %edi,%edi
  800601:	7f ed                	jg     8005f0 <vprintfmt+0x1b6>
  800603:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800606:	85 c9                	test   %ecx,%ecx
  800608:	b8 00 00 00 00       	mov    $0x0,%eax
  80060d:	0f 49 c1             	cmovns %ecx,%eax
  800610:	29 c1                	sub    %eax,%ecx
  800612:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800615:	eb aa                	jmp    8005c1 <vprintfmt+0x187>
					putch(ch, putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	52                   	push   %edx
  80061c:	ff d6                	call   *%esi
  80061e:	83 c4 10             	add    $0x10,%esp
  800621:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800624:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800626:	83 c7 01             	add    $0x1,%edi
  800629:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062d:	0f be d0             	movsbl %al,%edx
  800630:	85 d2                	test   %edx,%edx
  800632:	74 4b                	je     80067f <vprintfmt+0x245>
  800634:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800638:	78 06                	js     800640 <vprintfmt+0x206>
  80063a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80063e:	78 1e                	js     80065e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800640:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800644:	74 d1                	je     800617 <vprintfmt+0x1dd>
  800646:	0f be c0             	movsbl %al,%eax
  800649:	83 e8 20             	sub    $0x20,%eax
  80064c:	83 f8 5e             	cmp    $0x5e,%eax
  80064f:	76 c6                	jbe    800617 <vprintfmt+0x1dd>
					putch('?', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	6a 3f                	push   $0x3f
  800657:	ff d6                	call   *%esi
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	eb c3                	jmp    800621 <vprintfmt+0x1e7>
  80065e:	89 cf                	mov    %ecx,%edi
  800660:	eb 0e                	jmp    800670 <vprintfmt+0x236>
				putch(' ', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 20                	push   $0x20
  800668:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066a:	83 ef 01             	sub    $0x1,%edi
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	85 ff                	test   %edi,%edi
  800672:	7f ee                	jg     800662 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800674:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
  80067a:	e9 01 02 00 00       	jmp    800880 <vprintfmt+0x446>
  80067f:	89 cf                	mov    %ecx,%edi
  800681:	eb ed                	jmp    800670 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800683:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800686:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80068d:	e9 eb fd ff ff       	jmp    80047d <vprintfmt+0x43>
	if (lflag >= 2)
  800692:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800696:	7f 21                	jg     8006b9 <vprintfmt+0x27f>
	else if (lflag)
  800698:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069c:	74 68                	je     800706 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a6:	89 c1                	mov    %eax,%ecx
  8006a8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ab:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	eb 17                	jmp    8006d0 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 50 04             	mov    0x4(%eax),%edx
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 40 08             	lea    0x8(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006e0:	78 3f                	js     800721 <vprintfmt+0x2e7>
			base = 10;
  8006e2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006e7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006eb:	0f 84 71 01 00 00    	je     800862 <vprintfmt+0x428>
				putch('+', putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	6a 2b                	push   $0x2b
  8006f7:	ff d6                	call   *%esi
  8006f9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	e9 5c 01 00 00       	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80070e:	89 c1                	mov    %eax,%ecx
  800710:	c1 f9 1f             	sar    $0x1f,%ecx
  800713:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
  80071f:	eb af                	jmp    8006d0 <vprintfmt+0x296>
				putch('-', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	53                   	push   %ebx
  800725:	6a 2d                	push   $0x2d
  800727:	ff d6                	call   *%esi
				num = -(long long) num;
  800729:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80072c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80072f:	f7 d8                	neg    %eax
  800731:	83 d2 00             	adc    $0x0,%edx
  800734:	f7 da                	neg    %edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80073f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800744:	e9 19 01 00 00       	jmp    800862 <vprintfmt+0x428>
	if (lflag >= 2)
  800749:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074d:	7f 29                	jg     800778 <vprintfmt+0x33e>
	else if (lflag)
  80074f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800753:	74 44                	je     800799 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	ba 00 00 00 00       	mov    $0x0,%edx
  80075f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800762:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 40 04             	lea    0x4(%eax),%eax
  80076b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800773:	e9 ea 00 00 00       	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 50 04             	mov    0x4(%eax),%edx
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800783:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 40 08             	lea    0x8(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800794:	e9 c9 00 00 00       	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b7:	e9 a6 00 00 00       	jmp    800862 <vprintfmt+0x428>
			putch('0', putdat);
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	53                   	push   %ebx
  8007c0:	6a 30                	push   $0x30
  8007c2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007cb:	7f 26                	jg     8007f3 <vprintfmt+0x3b9>
	else if (lflag)
  8007cd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d1:	74 3e                	je     800811 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f1:	eb 6f                	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8b 50 04             	mov    0x4(%eax),%edx
  8007f9:	8b 00                	mov    (%eax),%eax
  8007fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8d 40 08             	lea    0x8(%eax),%eax
  800807:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80080a:	b8 08 00 00 00       	mov    $0x8,%eax
  80080f:	eb 51                	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	ba 00 00 00 00       	mov    $0x0,%edx
  80081b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082a:	b8 08 00 00 00       	mov    $0x8,%eax
  80082f:	eb 31                	jmp    800862 <vprintfmt+0x428>
			putch('0', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 30                	push   $0x30
  800837:	ff d6                	call   *%esi
			putch('x', putdat);
  800839:	83 c4 08             	add    $0x8,%esp
  80083c:	53                   	push   %ebx
  80083d:	6a 78                	push   $0x78
  80083f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	ba 00 00 00 00       	mov    $0x0,%edx
  80084b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800851:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800862:	83 ec 0c             	sub    $0xc,%esp
  800865:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800869:	52                   	push   %edx
  80086a:	ff 75 e0             	pushl  -0x20(%ebp)
  80086d:	50                   	push   %eax
  80086e:	ff 75 dc             	pushl  -0x24(%ebp)
  800871:	ff 75 d8             	pushl  -0x28(%ebp)
  800874:	89 da                	mov    %ebx,%edx
  800876:	89 f0                	mov    %esi,%eax
  800878:	e8 a4 fa ff ff       	call   800321 <printnum>
			break;
  80087d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800880:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800883:	83 c7 01             	add    $0x1,%edi
  800886:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80088a:	83 f8 25             	cmp    $0x25,%eax
  80088d:	0f 84 be fb ff ff    	je     800451 <vprintfmt+0x17>
			if (ch == '\0')
  800893:	85 c0                	test   %eax,%eax
  800895:	0f 84 28 01 00 00    	je     8009c3 <vprintfmt+0x589>
			putch(ch, putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	50                   	push   %eax
  8008a0:	ff d6                	call   *%esi
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	eb dc                	jmp    800883 <vprintfmt+0x449>
	if (lflag >= 2)
  8008a7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008ab:	7f 26                	jg     8008d3 <vprintfmt+0x499>
	else if (lflag)
  8008ad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008b1:	74 41                	je     8008f4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	8d 40 04             	lea    0x4(%eax),%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cc:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d1:	eb 8f                	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8d 40 08             	lea    0x8(%eax),%eax
  8008e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ea:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ef:	e9 6e ff ff ff       	jmp    800862 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800901:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	8d 40 04             	lea    0x4(%eax),%eax
  80090a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090d:	b8 10 00 00 00       	mov    $0x10,%eax
  800912:	e9 4b ff ff ff       	jmp    800862 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800917:	8b 45 14             	mov    0x14(%ebp),%eax
  80091a:	83 c0 04             	add    $0x4,%eax
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	85 c0                	test   %eax,%eax
  800927:	74 14                	je     80093d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800929:	8b 13                	mov    (%ebx),%edx
  80092b:	83 fa 7f             	cmp    $0x7f,%edx
  80092e:	7f 37                	jg     800967 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800930:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800932:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	e9 43 ff ff ff       	jmp    800880 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80093d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800942:	bf bd 2d 80 00       	mov    $0x802dbd,%edi
							putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	53                   	push   %ebx
  80094b:	50                   	push   %eax
  80094c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80094e:	83 c7 01             	add    $0x1,%edi
  800951:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	85 c0                	test   %eax,%eax
  80095a:	75 eb                	jne    800947 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
  800962:	e9 19 ff ff ff       	jmp    800880 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800967:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800969:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096e:	bf f5 2d 80 00       	mov    $0x802df5,%edi
							putch(ch, putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	50                   	push   %eax
  800978:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80097a:	83 c7 01             	add    $0x1,%edi
  80097d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	85 c0                	test   %eax,%eax
  800986:	75 eb                	jne    800973 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800988:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
  80098e:	e9 ed fe ff ff       	jmp    800880 <vprintfmt+0x446>
			putch(ch, putdat);
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	53                   	push   %ebx
  800997:	6a 25                	push   $0x25
  800999:	ff d6                	call   *%esi
			break;
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	e9 dd fe ff ff       	jmp    800880 <vprintfmt+0x446>
			putch('%', putdat);
  8009a3:	83 ec 08             	sub    $0x8,%esp
  8009a6:	53                   	push   %ebx
  8009a7:	6a 25                	push   $0x25
  8009a9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	89 f8                	mov    %edi,%eax
  8009b0:	eb 03                	jmp    8009b5 <vprintfmt+0x57b>
  8009b2:	83 e8 01             	sub    $0x1,%eax
  8009b5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b9:	75 f7                	jne    8009b2 <vprintfmt+0x578>
  8009bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009be:	e9 bd fe ff ff       	jmp    800880 <vprintfmt+0x446>
}
  8009c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c6:	5b                   	pop    %ebx
  8009c7:	5e                   	pop    %esi
  8009c8:	5f                   	pop    %edi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 18             	sub    $0x18,%esp
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009da:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009de:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e8:	85 c0                	test   %eax,%eax
  8009ea:	74 26                	je     800a12 <vsnprintf+0x47>
  8009ec:	85 d2                	test   %edx,%edx
  8009ee:	7e 22                	jle    800a12 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f0:	ff 75 14             	pushl  0x14(%ebp)
  8009f3:	ff 75 10             	pushl  0x10(%ebp)
  8009f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f9:	50                   	push   %eax
  8009fa:	68 00 04 80 00       	push   $0x800400
  8009ff:	e8 36 fa ff ff       	call   80043a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a07:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0d:	83 c4 10             	add    $0x10,%esp
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    
		return -E_INVAL;
  800a12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a17:	eb f7                	jmp    800a10 <vsnprintf+0x45>

00800a19 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a22:	50                   	push   %eax
  800a23:	ff 75 10             	pushl  0x10(%ebp)
  800a26:	ff 75 0c             	pushl  0xc(%ebp)
  800a29:	ff 75 08             	pushl  0x8(%ebp)
  800a2c:	e8 9a ff ff ff       	call   8009cb <vsnprintf>
	va_end(ap);

	return rc;
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a42:	74 05                	je     800a49 <strlen+0x16>
		n++;
  800a44:	83 c0 01             	add    $0x1,%eax
  800a47:	eb f5                	jmp    800a3e <strlen+0xb>
	return n;
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a54:	ba 00 00 00 00       	mov    $0x0,%edx
  800a59:	39 c2                	cmp    %eax,%edx
  800a5b:	74 0d                	je     800a6a <strnlen+0x1f>
  800a5d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a61:	74 05                	je     800a68 <strnlen+0x1d>
		n++;
  800a63:	83 c2 01             	add    $0x1,%edx
  800a66:	eb f1                	jmp    800a59 <strnlen+0xe>
  800a68:	89 d0                	mov    %edx,%eax
	return n;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	53                   	push   %ebx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a7f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a82:	83 c2 01             	add    $0x1,%edx
  800a85:	84 c9                	test   %cl,%cl
  800a87:	75 f2                	jne    800a7b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a89:	5b                   	pop    %ebx
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	53                   	push   %ebx
  800a90:	83 ec 10             	sub    $0x10,%esp
  800a93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a96:	53                   	push   %ebx
  800a97:	e8 97 ff ff ff       	call   800a33 <strlen>
  800a9c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	01 d8                	add    %ebx,%eax
  800aa4:	50                   	push   %eax
  800aa5:	e8 c2 ff ff ff       	call   800a6c <strcpy>
	return dst;
}
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abc:	89 c6                	mov    %eax,%esi
  800abe:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ac1:	89 c2                	mov    %eax,%edx
  800ac3:	39 f2                	cmp    %esi,%edx
  800ac5:	74 11                	je     800ad8 <strncpy+0x27>
		*dst++ = *src;
  800ac7:	83 c2 01             	add    $0x1,%edx
  800aca:	0f b6 19             	movzbl (%ecx),%ebx
  800acd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ad0:	80 fb 01             	cmp    $0x1,%bl
  800ad3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ad6:	eb eb                	jmp    800ac3 <strncpy+0x12>
	}
	return ret;
}
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
  800ae1:	8b 75 08             	mov    0x8(%ebp),%esi
  800ae4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae7:	8b 55 10             	mov    0x10(%ebp),%edx
  800aea:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aec:	85 d2                	test   %edx,%edx
  800aee:	74 21                	je     800b11 <strlcpy+0x35>
  800af0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800af4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	74 14                	je     800b0e <strlcpy+0x32>
  800afa:	0f b6 19             	movzbl (%ecx),%ebx
  800afd:	84 db                	test   %bl,%bl
  800aff:	74 0b                	je     800b0c <strlcpy+0x30>
			*dst++ = *src++;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	83 c2 01             	add    $0x1,%edx
  800b07:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b0a:	eb ea                	jmp    800af6 <strlcpy+0x1a>
  800b0c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b0e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b11:	29 f0                	sub    %esi,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b20:	0f b6 01             	movzbl (%ecx),%eax
  800b23:	84 c0                	test   %al,%al
  800b25:	74 0c                	je     800b33 <strcmp+0x1c>
  800b27:	3a 02                	cmp    (%edx),%al
  800b29:	75 08                	jne    800b33 <strcmp+0x1c>
		p++, q++;
  800b2b:	83 c1 01             	add    $0x1,%ecx
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	eb ed                	jmp    800b20 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b33:	0f b6 c0             	movzbl %al,%eax
  800b36:	0f b6 12             	movzbl (%edx),%edx
  800b39:	29 d0                	sub    %edx,%eax
}
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	53                   	push   %ebx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b47:	89 c3                	mov    %eax,%ebx
  800b49:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b4c:	eb 06                	jmp    800b54 <strncmp+0x17>
		n--, p++, q++;
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b54:	39 d8                	cmp    %ebx,%eax
  800b56:	74 16                	je     800b6e <strncmp+0x31>
  800b58:	0f b6 08             	movzbl (%eax),%ecx
  800b5b:	84 c9                	test   %cl,%cl
  800b5d:	74 04                	je     800b63 <strncmp+0x26>
  800b5f:	3a 0a                	cmp    (%edx),%cl
  800b61:	74 eb                	je     800b4e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b63:	0f b6 00             	movzbl (%eax),%eax
  800b66:	0f b6 12             	movzbl (%edx),%edx
  800b69:	29 d0                	sub    %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    
		return 0;
  800b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b73:	eb f6                	jmp    800b6b <strncmp+0x2e>

00800b75 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7f:	0f b6 10             	movzbl (%eax),%edx
  800b82:	84 d2                	test   %dl,%dl
  800b84:	74 09                	je     800b8f <strchr+0x1a>
		if (*s == c)
  800b86:	38 ca                	cmp    %cl,%dl
  800b88:	74 0a                	je     800b94 <strchr+0x1f>
	for (; *s; s++)
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	eb f0                	jmp    800b7f <strchr+0xa>
			return (char *) s;
	return 0;
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ba3:	38 ca                	cmp    %cl,%dl
  800ba5:	74 09                	je     800bb0 <strfind+0x1a>
  800ba7:	84 d2                	test   %dl,%dl
  800ba9:	74 05                	je     800bb0 <strfind+0x1a>
	for (; *s; s++)
  800bab:	83 c0 01             	add    $0x1,%eax
  800bae:	eb f0                	jmp    800ba0 <strfind+0xa>
			break;
	return (char *) s;
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bbe:	85 c9                	test   %ecx,%ecx
  800bc0:	74 31                	je     800bf3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bc2:	89 f8                	mov    %edi,%eax
  800bc4:	09 c8                	or     %ecx,%eax
  800bc6:	a8 03                	test   $0x3,%al
  800bc8:	75 23                	jne    800bed <memset+0x3b>
		c &= 0xFF;
  800bca:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bce:	89 d3                	mov    %edx,%ebx
  800bd0:	c1 e3 08             	shl    $0x8,%ebx
  800bd3:	89 d0                	mov    %edx,%eax
  800bd5:	c1 e0 18             	shl    $0x18,%eax
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	c1 e6 10             	shl    $0x10,%esi
  800bdd:	09 f0                	or     %esi,%eax
  800bdf:	09 c2                	or     %eax,%edx
  800be1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800be3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be6:	89 d0                	mov    %edx,%eax
  800be8:	fc                   	cld    
  800be9:	f3 ab                	rep stos %eax,%es:(%edi)
  800beb:	eb 06                	jmp    800bf3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	fc                   	cld    
  800bf1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bf3:	89 f8                	mov    %edi,%eax
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c08:	39 c6                	cmp    %eax,%esi
  800c0a:	73 32                	jae    800c3e <memmove+0x44>
  800c0c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c0f:	39 c2                	cmp    %eax,%edx
  800c11:	76 2b                	jbe    800c3e <memmove+0x44>
		s += n;
		d += n;
  800c13:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c16:	89 fe                	mov    %edi,%esi
  800c18:	09 ce                	or     %ecx,%esi
  800c1a:	09 d6                	or     %edx,%esi
  800c1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c22:	75 0e                	jne    800c32 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c24:	83 ef 04             	sub    $0x4,%edi
  800c27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c2d:	fd                   	std    
  800c2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c30:	eb 09                	jmp    800c3b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c32:	83 ef 01             	sub    $0x1,%edi
  800c35:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c38:	fd                   	std    
  800c39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c3b:	fc                   	cld    
  800c3c:	eb 1a                	jmp    800c58 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3e:	89 c2                	mov    %eax,%edx
  800c40:	09 ca                	or     %ecx,%edx
  800c42:	09 f2                	or     %esi,%edx
  800c44:	f6 c2 03             	test   $0x3,%dl
  800c47:	75 0a                	jne    800c53 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c4c:	89 c7                	mov    %eax,%edi
  800c4e:	fc                   	cld    
  800c4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c51:	eb 05                	jmp    800c58 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c53:	89 c7                	mov    %eax,%edi
  800c55:	fc                   	cld    
  800c56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c58:	5e                   	pop    %esi
  800c59:	5f                   	pop    %edi
  800c5a:	5d                   	pop    %ebp
  800c5b:	c3                   	ret    

00800c5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c62:	ff 75 10             	pushl  0x10(%ebp)
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	ff 75 08             	pushl  0x8(%ebp)
  800c6b:	e8 8a ff ff ff       	call   800bfa <memmove>
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7d:	89 c6                	mov    %eax,%esi
  800c7f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c82:	39 f0                	cmp    %esi,%eax
  800c84:	74 1c                	je     800ca2 <memcmp+0x30>
		if (*s1 != *s2)
  800c86:	0f b6 08             	movzbl (%eax),%ecx
  800c89:	0f b6 1a             	movzbl (%edx),%ebx
  800c8c:	38 d9                	cmp    %bl,%cl
  800c8e:	75 08                	jne    800c98 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c90:	83 c0 01             	add    $0x1,%eax
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	eb ea                	jmp    800c82 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c98:	0f b6 c1             	movzbl %cl,%eax
  800c9b:	0f b6 db             	movzbl %bl,%ebx
  800c9e:	29 d8                	sub    %ebx,%eax
  800ca0:	eb 05                	jmp    800ca7 <memcmp+0x35>
	}

	return 0;
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb9:	39 d0                	cmp    %edx,%eax
  800cbb:	73 09                	jae    800cc6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cbd:	38 08                	cmp    %cl,(%eax)
  800cbf:	74 05                	je     800cc6 <memfind+0x1b>
	for (; s < ends; s++)
  800cc1:	83 c0 01             	add    $0x1,%eax
  800cc4:	eb f3                	jmp    800cb9 <memfind+0xe>
			break;
	return (void *) s;
}
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd4:	eb 03                	jmp    800cd9 <strtol+0x11>
		s++;
  800cd6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd9:	0f b6 01             	movzbl (%ecx),%eax
  800cdc:	3c 20                	cmp    $0x20,%al
  800cde:	74 f6                	je     800cd6 <strtol+0xe>
  800ce0:	3c 09                	cmp    $0x9,%al
  800ce2:	74 f2                	je     800cd6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ce4:	3c 2b                	cmp    $0x2b,%al
  800ce6:	74 2a                	je     800d12 <strtol+0x4a>
	int neg = 0;
  800ce8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ced:	3c 2d                	cmp    $0x2d,%al
  800cef:	74 2b                	je     800d1c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf7:	75 0f                	jne    800d08 <strtol+0x40>
  800cf9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfc:	74 28                	je     800d26 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfe:	85 db                	test   %ebx,%ebx
  800d00:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d05:	0f 44 d8             	cmove  %eax,%ebx
  800d08:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d10:	eb 50                	jmp    800d62 <strtol+0x9a>
		s++;
  800d12:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d15:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1a:	eb d5                	jmp    800cf1 <strtol+0x29>
		s++, neg = 1;
  800d1c:	83 c1 01             	add    $0x1,%ecx
  800d1f:	bf 01 00 00 00       	mov    $0x1,%edi
  800d24:	eb cb                	jmp    800cf1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d26:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d2a:	74 0e                	je     800d3a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d2c:	85 db                	test   %ebx,%ebx
  800d2e:	75 d8                	jne    800d08 <strtol+0x40>
		s++, base = 8;
  800d30:	83 c1 01             	add    $0x1,%ecx
  800d33:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d38:	eb ce                	jmp    800d08 <strtol+0x40>
		s += 2, base = 16;
  800d3a:	83 c1 02             	add    $0x2,%ecx
  800d3d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d42:	eb c4                	jmp    800d08 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d44:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d47:	89 f3                	mov    %esi,%ebx
  800d49:	80 fb 19             	cmp    $0x19,%bl
  800d4c:	77 29                	ja     800d77 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d4e:	0f be d2             	movsbl %dl,%edx
  800d51:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d54:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d57:	7d 30                	jge    800d89 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d59:	83 c1 01             	add    $0x1,%ecx
  800d5c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d60:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d62:	0f b6 11             	movzbl (%ecx),%edx
  800d65:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d68:	89 f3                	mov    %esi,%ebx
  800d6a:	80 fb 09             	cmp    $0x9,%bl
  800d6d:	77 d5                	ja     800d44 <strtol+0x7c>
			dig = *s - '0';
  800d6f:	0f be d2             	movsbl %dl,%edx
  800d72:	83 ea 30             	sub    $0x30,%edx
  800d75:	eb dd                	jmp    800d54 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d77:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d7a:	89 f3                	mov    %esi,%ebx
  800d7c:	80 fb 19             	cmp    $0x19,%bl
  800d7f:	77 08                	ja     800d89 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d81:	0f be d2             	movsbl %dl,%edx
  800d84:	83 ea 37             	sub    $0x37,%edx
  800d87:	eb cb                	jmp    800d54 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8d:	74 05                	je     800d94 <strtol+0xcc>
		*endptr = (char *) s;
  800d8f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d92:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d94:	89 c2                	mov    %eax,%edx
  800d96:	f7 da                	neg    %edx
  800d98:	85 ff                	test   %edi,%edi
  800d9a:	0f 45 c2             	cmovne %edx,%eax
}
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	89 c3                	mov    %eax,%ebx
  800db5:	89 c7                	mov    %eax,%edi
  800db7:	89 c6                	mov    %eax,%esi
  800db9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcb:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd0:	89 d1                	mov    %edx,%ecx
  800dd2:	89 d3                	mov    %edx,%ebx
  800dd4:	89 d7                	mov    %edx,%edi
  800dd6:	89 d6                	mov    %edx,%esi
  800dd8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	b8 03 00 00 00       	mov    $0x3,%eax
  800df5:	89 cb                	mov    %ecx,%ebx
  800df7:	89 cf                	mov    %ecx,%edi
  800df9:	89 ce                	mov    %ecx,%esi
  800dfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7f 08                	jg     800e09 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 03                	push   $0x3
  800e0f:	68 08 30 80 00       	push   $0x803008
  800e14:	6a 43                	push   $0x43
  800e16:	68 25 30 80 00       	push   $0x803025
  800e1b:	e8 f7 f3 ff ff       	call   800217 <_panic>

00800e20 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	b8 02 00 00 00       	mov    $0x2,%eax
  800e30:	89 d1                	mov    %edx,%ecx
  800e32:	89 d3                	mov    %edx,%ebx
  800e34:	89 d7                	mov    %edx,%edi
  800e36:	89 d6                	mov    %edx,%esi
  800e38:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_yield>:

void
sys_yield(void)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e45:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e4f:	89 d1                	mov    %edx,%ecx
  800e51:	89 d3                	mov    %edx,%ebx
  800e53:	89 d7                	mov    %edx,%edi
  800e55:	89 d6                	mov    %edx,%esi
  800e57:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	be 00 00 00 00       	mov    $0x0,%esi
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 04 00 00 00       	mov    $0x4,%eax
  800e77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7a:	89 f7                	mov    %esi,%edi
  800e7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7f 08                	jg     800e8a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	50                   	push   %eax
  800e8e:	6a 04                	push   $0x4
  800e90:	68 08 30 80 00       	push   $0x803008
  800e95:	6a 43                	push   $0x43
  800e97:	68 25 30 80 00       	push   $0x803025
  800e9c:	e8 76 f3 ff ff       	call   800217 <_panic>

00800ea1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	b8 05 00 00 00       	mov    $0x5,%eax
  800eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebb:	8b 75 18             	mov    0x18(%ebp),%esi
  800ebe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	7f 08                	jg     800ecc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	50                   	push   %eax
  800ed0:	6a 05                	push   $0x5
  800ed2:	68 08 30 80 00       	push   $0x803008
  800ed7:	6a 43                	push   $0x43
  800ed9:	68 25 30 80 00       	push   $0x803025
  800ede:	e8 34 f3 ff ff       	call   800217 <_panic>

00800ee3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef7:	b8 06 00 00 00       	mov    $0x6,%eax
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	89 de                	mov    %ebx,%esi
  800f00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7f 08                	jg     800f0e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	83 ec 0c             	sub    $0xc,%esp
  800f11:	50                   	push   %eax
  800f12:	6a 06                	push   $0x6
  800f14:	68 08 30 80 00       	push   $0x803008
  800f19:	6a 43                	push   $0x43
  800f1b:	68 25 30 80 00       	push   $0x803025
  800f20:	e8 f2 f2 ff ff       	call   800217 <_panic>

00800f25 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	b8 08 00 00 00       	mov    $0x8,%eax
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	89 de                	mov    %ebx,%esi
  800f42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	7f 08                	jg     800f50 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	50                   	push   %eax
  800f54:	6a 08                	push   $0x8
  800f56:	68 08 30 80 00       	push   $0x803008
  800f5b:	6a 43                	push   $0x43
  800f5d:	68 25 30 80 00       	push   $0x803025
  800f62:	e8 b0 f2 ff ff       	call   800217 <_panic>

00800f67 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
  800f6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	b8 09 00 00 00       	mov    $0x9,%eax
  800f80:	89 df                	mov    %ebx,%edi
  800f82:	89 de                	mov    %ebx,%esi
  800f84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	7f 08                	jg     800f92 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f92:	83 ec 0c             	sub    $0xc,%esp
  800f95:	50                   	push   %eax
  800f96:	6a 09                	push   $0x9
  800f98:	68 08 30 80 00       	push   $0x803008
  800f9d:	6a 43                	push   $0x43
  800f9f:	68 25 30 80 00       	push   $0x803025
  800fa4:	e8 6e f2 ff ff       	call   800217 <_panic>

00800fa9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc2:	89 df                	mov    %ebx,%edi
  800fc4:	89 de                	mov    %ebx,%esi
  800fc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	7f 08                	jg     800fd4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5f                   	pop    %edi
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	50                   	push   %eax
  800fd8:	6a 0a                	push   $0xa
  800fda:	68 08 30 80 00       	push   $0x803008
  800fdf:	6a 43                	push   $0x43
  800fe1:	68 25 30 80 00       	push   $0x803025
  800fe6:	e8 2c f2 ff ff       	call   800217 <_panic>

00800feb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ffc:	be 00 00 00 00       	mov    $0x0,%esi
  801001:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801004:	8b 7d 14             	mov    0x14(%ebp),%edi
  801007:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5f                   	pop    %edi
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801017:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801024:	89 cb                	mov    %ecx,%ebx
  801026:	89 cf                	mov    %ecx,%edi
  801028:	89 ce                	mov    %ecx,%esi
  80102a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	7f 08                	jg     801038 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801030:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801038:	83 ec 0c             	sub    $0xc,%esp
  80103b:	50                   	push   %eax
  80103c:	6a 0d                	push   $0xd
  80103e:	68 08 30 80 00       	push   $0x803008
  801043:	6a 43                	push   $0x43
  801045:	68 25 30 80 00       	push   $0x803025
  80104a:	e8 c8 f1 ff ff       	call   800217 <_panic>

0080104f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
	asm volatile("int %1\n"
  801055:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	b8 0e 00 00 00       	mov    $0xe,%eax
  801065:	89 df                	mov    %ebx,%edi
  801067:	89 de                	mov    %ebx,%esi
  801069:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
	asm volatile("int %1\n"
  801076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801083:	89 cb                	mov    %ecx,%ebx
  801085:	89 cf                	mov    %ecx,%edi
  801087:	89 ce                	mov    %ecx,%esi
  801089:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
	asm volatile("int %1\n"
  801096:	ba 00 00 00 00       	mov    $0x0,%edx
  80109b:	b8 10 00 00 00       	mov    $0x10,%eax
  8010a0:	89 d1                	mov    %edx,%ecx
  8010a2:	89 d3                	mov    %edx,%ebx
  8010a4:	89 d7                	mov    %edx,%edi
  8010a6:	89 d6                	mov    %edx,%esi
  8010a8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c0:	b8 11 00 00 00       	mov    $0x11,%eax
  8010c5:	89 df                	mov    %ebx,%edi
  8010c7:	89 de                	mov    %ebx,%esi
  8010c9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e1:	b8 12 00 00 00       	mov    $0x12,%eax
  8010e6:	89 df                	mov    %ebx,%edi
  8010e8:	89 de                	mov    %ebx,%esi
  8010ea:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5f                   	pop    %edi
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    

008010f1 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	57                   	push   %edi
  8010f5:	56                   	push   %esi
  8010f6:	53                   	push   %ebx
  8010f7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801105:	b8 13 00 00 00       	mov    $0x13,%eax
  80110a:	89 df                	mov    %ebx,%edi
  80110c:	89 de                	mov    %ebx,%esi
  80110e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801110:	85 c0                	test   %eax,%eax
  801112:	7f 08                	jg     80111c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	50                   	push   %eax
  801120:	6a 13                	push   $0x13
  801122:	68 08 30 80 00       	push   $0x803008
  801127:	6a 43                	push   $0x43
  801129:	68 25 30 80 00       	push   $0x803025
  80112e:	e8 e4 f0 ff ff       	call   800217 <_panic>

00801133 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	57                   	push   %edi
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
	asm volatile("int %1\n"
  801139:	b9 00 00 00 00       	mov    $0x0,%ecx
  80113e:	8b 55 08             	mov    0x8(%ebp),%edx
  801141:	b8 14 00 00 00       	mov    $0x14,%eax
  801146:	89 cb                	mov    %ecx,%ebx
  801148:	89 cf                	mov    %ecx,%edi
  80114a:	89 ce                	mov    %ecx,%esi
  80114c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	53                   	push   %ebx
  801157:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80115a:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801161:	f6 c5 04             	test   $0x4,%ch
  801164:	75 45                	jne    8011ab <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801166:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80116d:	83 e1 07             	and    $0x7,%ecx
  801170:	83 f9 07             	cmp    $0x7,%ecx
  801173:	74 6f                	je     8011e4 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801175:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80117c:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801182:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801188:	0f 84 b6 00 00 00    	je     801244 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80118e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801195:	83 e1 05             	and    $0x5,%ecx
  801198:	83 f9 05             	cmp    $0x5,%ecx
  80119b:	0f 84 d7 00 00 00    	je     801278 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011ab:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011b2:	c1 e2 0c             	shl    $0xc,%edx
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011be:	51                   	push   %ecx
  8011bf:	52                   	push   %edx
  8011c0:	50                   	push   %eax
  8011c1:	52                   	push   %edx
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 d8 fc ff ff       	call   800ea1 <sys_page_map>
		if(r < 0)
  8011c9:	83 c4 20             	add    $0x20,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	79 d1                	jns    8011a1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	68 33 30 80 00       	push   $0x803033
  8011d8:	6a 54                	push   $0x54
  8011da:	68 49 30 80 00       	push   $0x803049
  8011df:	e8 33 f0 ff ff       	call   800217 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011e4:	89 d3                	mov    %edx,%ebx
  8011e6:	c1 e3 0c             	shl    $0xc,%ebx
  8011e9:	83 ec 0c             	sub    $0xc,%esp
  8011ec:	68 05 08 00 00       	push   $0x805
  8011f1:	53                   	push   %ebx
  8011f2:	50                   	push   %eax
  8011f3:	53                   	push   %ebx
  8011f4:	6a 00                	push   $0x0
  8011f6:	e8 a6 fc ff ff       	call   800ea1 <sys_page_map>
		if(r < 0)
  8011fb:	83 c4 20             	add    $0x20,%esp
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 2e                	js     801230 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	68 05 08 00 00       	push   $0x805
  80120a:	53                   	push   %ebx
  80120b:	6a 00                	push   $0x0
  80120d:	53                   	push   %ebx
  80120e:	6a 00                	push   $0x0
  801210:	e8 8c fc ff ff       	call   800ea1 <sys_page_map>
		if(r < 0)
  801215:	83 c4 20             	add    $0x20,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	79 85                	jns    8011a1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	68 33 30 80 00       	push   $0x803033
  801224:	6a 5f                	push   $0x5f
  801226:	68 49 30 80 00       	push   $0x803049
  80122b:	e8 e7 ef ff ff       	call   800217 <_panic>
			panic("sys_page_map() panic\n");
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	68 33 30 80 00       	push   $0x803033
  801238:	6a 5b                	push   $0x5b
  80123a:	68 49 30 80 00       	push   $0x803049
  80123f:	e8 d3 ef ff ff       	call   800217 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801244:	c1 e2 0c             	shl    $0xc,%edx
  801247:	83 ec 0c             	sub    $0xc,%esp
  80124a:	68 05 08 00 00       	push   $0x805
  80124f:	52                   	push   %edx
  801250:	50                   	push   %eax
  801251:	52                   	push   %edx
  801252:	6a 00                	push   $0x0
  801254:	e8 48 fc ff ff       	call   800ea1 <sys_page_map>
		if(r < 0)
  801259:	83 c4 20             	add    $0x20,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	0f 89 3d ff ff ff    	jns    8011a1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	68 33 30 80 00       	push   $0x803033
  80126c:	6a 66                	push   $0x66
  80126e:	68 49 30 80 00       	push   $0x803049
  801273:	e8 9f ef ff ff       	call   800217 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801278:	c1 e2 0c             	shl    $0xc,%edx
  80127b:	83 ec 0c             	sub    $0xc,%esp
  80127e:	6a 05                	push   $0x5
  801280:	52                   	push   %edx
  801281:	50                   	push   %eax
  801282:	52                   	push   %edx
  801283:	6a 00                	push   $0x0
  801285:	e8 17 fc ff ff       	call   800ea1 <sys_page_map>
		if(r < 0)
  80128a:	83 c4 20             	add    $0x20,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	0f 89 0c ff ff ff    	jns    8011a1 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	68 33 30 80 00       	push   $0x803033
  80129d:	6a 6d                	push   $0x6d
  80129f:	68 49 30 80 00       	push   $0x803049
  8012a4:	e8 6e ef ff ff       	call   800217 <_panic>

008012a9 <pgfault>:
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	53                   	push   %ebx
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012b3:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012b5:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012b9:	0f 84 99 00 00 00    	je     801358 <pgfault+0xaf>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	c1 ea 16             	shr    $0x16,%edx
  8012c4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cb:	f6 c2 01             	test   $0x1,%dl
  8012ce:	0f 84 84 00 00 00    	je     801358 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012d4:	89 c2                	mov    %eax,%edx
  8012d6:	c1 ea 0c             	shr    $0xc,%edx
  8012d9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e0:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012e6:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012ec:	75 6a                	jne    801358 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f3:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012f5:	83 ec 04             	sub    $0x4,%esp
  8012f8:	6a 07                	push   $0x7
  8012fa:	68 00 f0 7f 00       	push   $0x7ff000
  8012ff:	6a 00                	push   $0x0
  801301:	e8 58 fb ff ff       	call   800e5e <sys_page_alloc>
	if(ret < 0)
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 5f                	js     80136c <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	68 00 10 00 00       	push   $0x1000
  801315:	53                   	push   %ebx
  801316:	68 00 f0 7f 00       	push   $0x7ff000
  80131b:	e8 3c f9 ff ff       	call   800c5c <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801320:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801327:	53                   	push   %ebx
  801328:	6a 00                	push   $0x0
  80132a:	68 00 f0 7f 00       	push   $0x7ff000
  80132f:	6a 00                	push   $0x0
  801331:	e8 6b fb ff ff       	call   800ea1 <sys_page_map>
	if(ret < 0)
  801336:	83 c4 20             	add    $0x20,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 43                	js     801380 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	68 00 f0 7f 00       	push   $0x7ff000
  801345:	6a 00                	push   $0x0
  801347:	e8 97 fb ff ff       	call   800ee3 <sys_page_unmap>
	if(ret < 0)
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 41                	js     801394 <pgfault+0xeb>
}
  801353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801356:	c9                   	leave  
  801357:	c3                   	ret    
		panic("panic at pgfault()\n");
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	68 54 30 80 00       	push   $0x803054
  801360:	6a 26                	push   $0x26
  801362:	68 49 30 80 00       	push   $0x803049
  801367:	e8 ab ee ff ff       	call   800217 <_panic>
		panic("panic in sys_page_alloc()\n");
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 68 30 80 00       	push   $0x803068
  801374:	6a 31                	push   $0x31
  801376:	68 49 30 80 00       	push   $0x803049
  80137b:	e8 97 ee ff ff       	call   800217 <_panic>
		panic("panic in sys_page_map()\n");
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	68 83 30 80 00       	push   $0x803083
  801388:	6a 36                	push   $0x36
  80138a:	68 49 30 80 00       	push   $0x803049
  80138f:	e8 83 ee ff ff       	call   800217 <_panic>
		panic("panic in sys_page_unmap()\n");
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	68 9c 30 80 00       	push   $0x80309c
  80139c:	6a 39                	push   $0x39
  80139e:	68 49 30 80 00       	push   $0x803049
  8013a3:	e8 6f ee ff ff       	call   800217 <_panic>

008013a8 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013b1:	68 a9 12 80 00       	push   $0x8012a9
  8013b6:	e8 db 14 00 00       	call   802896 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8013c0:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 2a                	js     8013f3 <fork+0x4b>
  8013c9:	89 c6                	mov    %eax,%esi
  8013cb:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013cd:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013d2:	75 4b                	jne    80141f <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013d4:	e8 47 fa ff ff       	call   800e20 <sys_getenvid>
  8013d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013de:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013e9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013ee:	e9 90 00 00 00       	jmp    801483 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	68 b8 30 80 00       	push   $0x8030b8
  8013fb:	68 8c 00 00 00       	push   $0x8c
  801400:	68 49 30 80 00       	push   $0x803049
  801405:	e8 0d ee ff ff       	call   800217 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80140a:	89 f8                	mov    %edi,%eax
  80140c:	e8 42 fd ff ff       	call   801153 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801417:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80141d:	74 26                	je     801445 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  80141f:	89 d8                	mov    %ebx,%eax
  801421:	c1 e8 16             	shr    $0x16,%eax
  801424:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142b:	a8 01                	test   $0x1,%al
  80142d:	74 e2                	je     801411 <fork+0x69>
  80142f:	89 da                	mov    %ebx,%edx
  801431:	c1 ea 0c             	shr    $0xc,%edx
  801434:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80143b:	83 e0 05             	and    $0x5,%eax
  80143e:	83 f8 05             	cmp    $0x5,%eax
  801441:	75 ce                	jne    801411 <fork+0x69>
  801443:	eb c5                	jmp    80140a <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	6a 07                	push   $0x7
  80144a:	68 00 f0 bf ee       	push   $0xeebff000
  80144f:	56                   	push   %esi
  801450:	e8 09 fa ff ff       	call   800e5e <sys_page_alloc>
	if(ret < 0)
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	78 31                	js     80148d <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	68 05 29 80 00       	push   $0x802905
  801464:	56                   	push   %esi
  801465:	e8 3f fb ff ff       	call   800fa9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 33                	js     8014a4 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	6a 02                	push   $0x2
  801476:	56                   	push   %esi
  801477:	e8 a9 fa ff ff       	call   800f25 <sys_env_set_status>
	if(ret < 0)
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 38                	js     8014bb <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801483:	89 f0                	mov    %esi,%eax
  801485:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	68 68 30 80 00       	push   $0x803068
  801495:	68 98 00 00 00       	push   $0x98
  80149a:	68 49 30 80 00       	push   $0x803049
  80149f:	e8 73 ed ff ff       	call   800217 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	68 dc 30 80 00       	push   $0x8030dc
  8014ac:	68 9b 00 00 00       	push   $0x9b
  8014b1:	68 49 30 80 00       	push   $0x803049
  8014b6:	e8 5c ed ff ff       	call   800217 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	68 04 31 80 00       	push   $0x803104
  8014c3:	68 9e 00 00 00       	push   $0x9e
  8014c8:	68 49 30 80 00       	push   $0x803049
  8014cd:	e8 45 ed ff ff       	call   800217 <_panic>

008014d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	57                   	push   %edi
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014db:	68 a9 12 80 00       	push   $0x8012a9
  8014e0:	e8 b1 13 00 00       	call   802896 <set_pgfault_handler>
  8014e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8014ea:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014ec:	83 c4 10             	add    $0x10,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 2a                	js     80151d <sfork+0x4b>
  8014f3:	89 c7                	mov    %eax,%edi
  8014f5:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014fc:	75 58                	jne    801556 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014fe:	e8 1d f9 ff ff       	call   800e20 <sys_getenvid>
  801503:	25 ff 03 00 00       	and    $0x3ff,%eax
  801508:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80150e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801513:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801518:	e9 d4 00 00 00       	jmp    8015f1 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	68 b8 30 80 00       	push   $0x8030b8
  801525:	68 af 00 00 00       	push   $0xaf
  80152a:	68 49 30 80 00       	push   $0x803049
  80152f:	e8 e3 ec ff ff       	call   800217 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801534:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801539:	89 f0                	mov    %esi,%eax
  80153b:	e8 13 fc ff ff       	call   801153 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801540:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801546:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80154c:	77 65                	ja     8015b3 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  80154e:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801554:	74 de                	je     801534 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801556:	89 d8                	mov    %ebx,%eax
  801558:	c1 e8 16             	shr    $0x16,%eax
  80155b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801562:	a8 01                	test   $0x1,%al
  801564:	74 da                	je     801540 <sfork+0x6e>
  801566:	89 da                	mov    %ebx,%edx
  801568:	c1 ea 0c             	shr    $0xc,%edx
  80156b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801572:	83 e0 05             	and    $0x5,%eax
  801575:	83 f8 05             	cmp    $0x5,%eax
  801578:	75 c6                	jne    801540 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80157a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801581:	c1 e2 0c             	shl    $0xc,%edx
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	83 e0 07             	and    $0x7,%eax
  80158a:	50                   	push   %eax
  80158b:	52                   	push   %edx
  80158c:	56                   	push   %esi
  80158d:	52                   	push   %edx
  80158e:	6a 00                	push   $0x0
  801590:	e8 0c f9 ff ff       	call   800ea1 <sys_page_map>
  801595:	83 c4 20             	add    $0x20,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 a4                	je     801540 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	68 33 30 80 00       	push   $0x803033
  8015a4:	68 ba 00 00 00       	push   $0xba
  8015a9:	68 49 30 80 00       	push   $0x803049
  8015ae:	e8 64 ec ff ff       	call   800217 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	6a 07                	push   $0x7
  8015b8:	68 00 f0 bf ee       	push   $0xeebff000
  8015bd:	57                   	push   %edi
  8015be:	e8 9b f8 ff ff       	call   800e5e <sys_page_alloc>
	if(ret < 0)
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 31                	js     8015fb <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	68 05 29 80 00       	push   $0x802905
  8015d2:	57                   	push   %edi
  8015d3:	e8 d1 f9 ff ff       	call   800fa9 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 33                	js     801612 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	6a 02                	push   $0x2
  8015e4:	57                   	push   %edi
  8015e5:	e8 3b f9 ff ff       	call   800f25 <sys_env_set_status>
	if(ret < 0)
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 38                	js     801629 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015f1:	89 f8                	mov    %edi,%eax
  8015f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5f                   	pop    %edi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	68 68 30 80 00       	push   $0x803068
  801603:	68 c0 00 00 00       	push   $0xc0
  801608:	68 49 30 80 00       	push   $0x803049
  80160d:	e8 05 ec ff ff       	call   800217 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 dc 30 80 00       	push   $0x8030dc
  80161a:	68 c3 00 00 00       	push   $0xc3
  80161f:	68 49 30 80 00       	push   $0x803049
  801624:	e8 ee eb ff ff       	call   800217 <_panic>
		panic("panic in sys_env_set_status()\n");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 04 31 80 00       	push   $0x803104
  801631:	68 c6 00 00 00       	push   $0xc6
  801636:	68 49 30 80 00       	push   $0x803049
  80163b:	e8 d7 eb ff ff       	call   800217 <_panic>

00801640 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	8b 75 08             	mov    0x8(%ebp),%esi
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80164e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801650:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801655:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	50                   	push   %eax
  80165c:	e8 ad f9 ff ff       	call   80100e <sys_ipc_recv>
	if(ret < 0){
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 2b                	js     801693 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801668:	85 f6                	test   %esi,%esi
  80166a:	74 0a                	je     801676 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80166c:	a1 08 50 80 00       	mov    0x805008,%eax
  801671:	8b 40 78             	mov    0x78(%eax),%eax
  801674:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801676:	85 db                	test   %ebx,%ebx
  801678:	74 0a                	je     801684 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80167a:	a1 08 50 80 00       	mov    0x805008,%eax
  80167f:	8b 40 7c             	mov    0x7c(%eax),%eax
  801682:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  801684:	a1 08 50 80 00       	mov    0x805008,%eax
  801689:	8b 40 74             	mov    0x74(%eax),%eax
}
  80168c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    
		if(from_env_store)
  801693:	85 f6                	test   %esi,%esi
  801695:	74 06                	je     80169d <ipc_recv+0x5d>
			*from_env_store = 0;
  801697:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80169d:	85 db                	test   %ebx,%ebx
  80169f:	74 eb                	je     80168c <ipc_recv+0x4c>
			*perm_store = 0;
  8016a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016a7:	eb e3                	jmp    80168c <ipc_recv+0x4c>

008016a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	57                   	push   %edi
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8016bb:	85 db                	test   %ebx,%ebx
  8016bd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8016c2:	0f 44 d8             	cmove  %eax,%ebx
  8016c5:	eb 05                	jmp    8016cc <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8016c7:	e8 73 f7 ff ff       	call   800e3f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8016cc:	ff 75 14             	pushl  0x14(%ebp)
  8016cf:	53                   	push   %ebx
  8016d0:	56                   	push   %esi
  8016d1:	57                   	push   %edi
  8016d2:	e8 14 f9 ff ff       	call   800feb <sys_ipc_try_send>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	74 1b                	je     8016f9 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8016de:	79 e7                	jns    8016c7 <ipc_send+0x1e>
  8016e0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8016e3:	74 e2                	je     8016c7 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 23 31 80 00       	push   $0x803123
  8016ed:	6a 46                	push   $0x46
  8016ef:	68 38 31 80 00       	push   $0x803138
  8016f4:	e8 1e eb ff ff       	call   800217 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8016f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fc:	5b                   	pop    %ebx
  8016fd:	5e                   	pop    %esi
  8016fe:	5f                   	pop    %edi
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80170c:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801712:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801718:	8b 52 50             	mov    0x50(%edx),%edx
  80171b:	39 ca                	cmp    %ecx,%edx
  80171d:	74 11                	je     801730 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80171f:	83 c0 01             	add    $0x1,%eax
  801722:	3d 00 04 00 00       	cmp    $0x400,%eax
  801727:	75 e3                	jne    80170c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 0e                	jmp    80173e <ipc_find_env+0x3d>
			return envs[i].env_id;
  801730:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801736:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80173b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	05 00 00 00 30       	add    $0x30000000,%eax
  80174b:	c1 e8 0c             	shr    $0xc,%eax
}
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80175b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801760:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80176f:	89 c2                	mov    %eax,%edx
  801771:	c1 ea 16             	shr    $0x16,%edx
  801774:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80177b:	f6 c2 01             	test   $0x1,%dl
  80177e:	74 2d                	je     8017ad <fd_alloc+0x46>
  801780:	89 c2                	mov    %eax,%edx
  801782:	c1 ea 0c             	shr    $0xc,%edx
  801785:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80178c:	f6 c2 01             	test   $0x1,%dl
  80178f:	74 1c                	je     8017ad <fd_alloc+0x46>
  801791:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801796:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80179b:	75 d2                	jne    80176f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8017a6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8017ab:	eb 0a                	jmp    8017b7 <fd_alloc+0x50>
			*fd_store = fd;
  8017ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017bf:	83 f8 1f             	cmp    $0x1f,%eax
  8017c2:	77 30                	ja     8017f4 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017c4:	c1 e0 0c             	shl    $0xc,%eax
  8017c7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017cc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8017d2:	f6 c2 01             	test   $0x1,%dl
  8017d5:	74 24                	je     8017fb <fd_lookup+0x42>
  8017d7:	89 c2                	mov    %eax,%edx
  8017d9:	c1 ea 0c             	shr    $0xc,%edx
  8017dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017e3:	f6 c2 01             	test   $0x1,%dl
  8017e6:	74 1a                	je     801802 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017eb:	89 02                	mov    %eax,(%edx)
	return 0;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    
		return -E_INVAL;
  8017f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f9:	eb f7                	jmp    8017f2 <fd_lookup+0x39>
		return -E_INVAL;
  8017fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801800:	eb f0                	jmp    8017f2 <fd_lookup+0x39>
  801802:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801807:	eb e9                	jmp    8017f2 <fd_lookup+0x39>

00801809 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801812:	ba 00 00 00 00       	mov    $0x0,%edx
  801817:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80181c:	39 08                	cmp    %ecx,(%eax)
  80181e:	74 38                	je     801858 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801820:	83 c2 01             	add    $0x1,%edx
  801823:	8b 04 95 c0 31 80 00 	mov    0x8031c0(,%edx,4),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	75 ee                	jne    80181c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80182e:	a1 08 50 80 00       	mov    0x805008,%eax
  801833:	8b 40 48             	mov    0x48(%eax),%eax
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	51                   	push   %ecx
  80183a:	50                   	push   %eax
  80183b:	68 44 31 80 00       	push   $0x803144
  801840:	e8 c8 ea ff ff       	call   80030d <cprintf>
	*dev = 0;
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    
			*dev = devtab[i];
  801858:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
  801862:	eb f2                	jmp    801856 <dev_lookup+0x4d>

00801864 <fd_close>:
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	57                   	push   %edi
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	83 ec 24             	sub    $0x24,%esp
  80186d:	8b 75 08             	mov    0x8(%ebp),%esi
  801870:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801873:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801876:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801877:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80187d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801880:	50                   	push   %eax
  801881:	e8 33 ff ff ff       	call   8017b9 <fd_lookup>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 05                	js     801894 <fd_close+0x30>
	    || fd != fd2)
  80188f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801892:	74 16                	je     8018aa <fd_close+0x46>
		return (must_exist ? r : 0);
  801894:	89 f8                	mov    %edi,%eax
  801896:	84 c0                	test   %al,%al
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
  80189d:	0f 44 d8             	cmove  %eax,%ebx
}
  8018a0:	89 d8                	mov    %ebx,%eax
  8018a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	ff 36                	pushl  (%esi)
  8018b3:	e8 51 ff ff ff       	call   801809 <dev_lookup>
  8018b8:	89 c3                	mov    %eax,%ebx
  8018ba:	83 c4 10             	add    $0x10,%esp
  8018bd:	85 c0                	test   %eax,%eax
  8018bf:	78 1a                	js     8018db <fd_close+0x77>
		if (dev->dev_close)
  8018c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8018c7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	74 0b                	je     8018db <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	56                   	push   %esi
  8018d4:	ff d0                	call   *%eax
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	56                   	push   %esi
  8018df:	6a 00                	push   $0x0
  8018e1:	e8 fd f5 ff ff       	call   800ee3 <sys_page_unmap>
	return r;
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	eb b5                	jmp    8018a0 <fd_close+0x3c>

008018eb <close>:

int
close(int fdnum)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f4:	50                   	push   %eax
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	e8 bc fe ff ff       	call   8017b9 <fd_lookup>
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	79 02                	jns    801906 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    
		return fd_close(fd, 1);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	6a 01                	push   $0x1
  80190b:	ff 75 f4             	pushl  -0xc(%ebp)
  80190e:	e8 51 ff ff ff       	call   801864 <fd_close>
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	eb ec                	jmp    801904 <close+0x19>

00801918 <close_all>:

void
close_all(void)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	53                   	push   %ebx
  80191c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80191f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	53                   	push   %ebx
  801928:	e8 be ff ff ff       	call   8018eb <close>
	for (i = 0; i < MAXFD; i++)
  80192d:	83 c3 01             	add    $0x1,%ebx
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	83 fb 20             	cmp    $0x20,%ebx
  801936:	75 ec                	jne    801924 <close_all+0xc>
}
  801938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	57                   	push   %edi
  801941:	56                   	push   %esi
  801942:	53                   	push   %ebx
  801943:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801946:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801949:	50                   	push   %eax
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	e8 67 fe ff ff       	call   8017b9 <fd_lookup>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	0f 88 81 00 00 00    	js     8019e0 <dup+0xa3>
		return r;
	close(newfdnum);
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	e8 81 ff ff ff       	call   8018eb <close>

	newfd = INDEX2FD(newfdnum);
  80196a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80196d:	c1 e6 0c             	shl    $0xc,%esi
  801970:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801976:	83 c4 04             	add    $0x4,%esp
  801979:	ff 75 e4             	pushl  -0x1c(%ebp)
  80197c:	e8 cf fd ff ff       	call   801750 <fd2data>
  801981:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801983:	89 34 24             	mov    %esi,(%esp)
  801986:	e8 c5 fd ff ff       	call   801750 <fd2data>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801990:	89 d8                	mov    %ebx,%eax
  801992:	c1 e8 16             	shr    $0x16,%eax
  801995:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80199c:	a8 01                	test   $0x1,%al
  80199e:	74 11                	je     8019b1 <dup+0x74>
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	c1 e8 0c             	shr    $0xc,%eax
  8019a5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019ac:	f6 c2 01             	test   $0x1,%dl
  8019af:	75 39                	jne    8019ea <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	c1 e8 0c             	shr    $0xc,%eax
  8019b9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8019c8:	50                   	push   %eax
  8019c9:	56                   	push   %esi
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	6a 00                	push   $0x0
  8019cf:	e8 cd f4 ff ff       	call   800ea1 <sys_page_map>
  8019d4:	89 c3                	mov    %eax,%ebx
  8019d6:	83 c4 20             	add    $0x20,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 31                	js     801a0e <dup+0xd1>
		goto err;

	return newfdnum;
  8019dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8019e0:	89 d8                	mov    %ebx,%eax
  8019e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019ea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f1:	83 ec 0c             	sub    $0xc,%esp
  8019f4:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f9:	50                   	push   %eax
  8019fa:	57                   	push   %edi
  8019fb:	6a 00                	push   $0x0
  8019fd:	53                   	push   %ebx
  8019fe:	6a 00                	push   $0x0
  801a00:	e8 9c f4 ff ff       	call   800ea1 <sys_page_map>
  801a05:	89 c3                	mov    %eax,%ebx
  801a07:	83 c4 20             	add    $0x20,%esp
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	79 a3                	jns    8019b1 <dup+0x74>
	sys_page_unmap(0, newfd);
  801a0e:	83 ec 08             	sub    $0x8,%esp
  801a11:	56                   	push   %esi
  801a12:	6a 00                	push   $0x0
  801a14:	e8 ca f4 ff ff       	call   800ee3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a19:	83 c4 08             	add    $0x8,%esp
  801a1c:	57                   	push   %edi
  801a1d:	6a 00                	push   $0x0
  801a1f:	e8 bf f4 ff ff       	call   800ee3 <sys_page_unmap>
	return r;
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb b7                	jmp    8019e0 <dup+0xa3>

00801a29 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 1c             	sub    $0x1c,%esp
  801a30:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a33:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a36:	50                   	push   %eax
  801a37:	53                   	push   %ebx
  801a38:	e8 7c fd ff ff       	call   8017b9 <fd_lookup>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 3f                	js     801a83 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4a:	50                   	push   %eax
  801a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4e:	ff 30                	pushl  (%eax)
  801a50:	e8 b4 fd ff ff       	call   801809 <dev_lookup>
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	78 27                	js     801a83 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a5f:	8b 42 08             	mov    0x8(%edx),%eax
  801a62:	83 e0 03             	and    $0x3,%eax
  801a65:	83 f8 01             	cmp    $0x1,%eax
  801a68:	74 1e                	je     801a88 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	8b 40 08             	mov    0x8(%eax),%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 35                	je     801aa9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	52                   	push   %edx
  801a7e:	ff d0                	call   *%eax
  801a80:	83 c4 10             	add    $0x10,%esp
}
  801a83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a88:	a1 08 50 80 00       	mov    0x805008,%eax
  801a8d:	8b 40 48             	mov    0x48(%eax),%eax
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	53                   	push   %ebx
  801a94:	50                   	push   %eax
  801a95:	68 85 31 80 00       	push   $0x803185
  801a9a:	e8 6e e8 ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa7:	eb da                	jmp    801a83 <read+0x5a>
		return -E_NOT_SUPP;
  801aa9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aae:	eb d3                	jmp    801a83 <read+0x5a>

00801ab0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	57                   	push   %edi
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	8b 7d 08             	mov    0x8(%ebp),%edi
  801abc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801abf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ac4:	39 f3                	cmp    %esi,%ebx
  801ac6:	73 23                	jae    801aeb <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	89 f0                	mov    %esi,%eax
  801acd:	29 d8                	sub    %ebx,%eax
  801acf:	50                   	push   %eax
  801ad0:	89 d8                	mov    %ebx,%eax
  801ad2:	03 45 0c             	add    0xc(%ebp),%eax
  801ad5:	50                   	push   %eax
  801ad6:	57                   	push   %edi
  801ad7:	e8 4d ff ff ff       	call   801a29 <read>
		if (m < 0)
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	78 06                	js     801ae9 <readn+0x39>
			return m;
		if (m == 0)
  801ae3:	74 06                	je     801aeb <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801ae5:	01 c3                	add    %eax,%ebx
  801ae7:	eb db                	jmp    801ac4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801ae9:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 1c             	sub    $0x1c,%esp
  801afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b02:	50                   	push   %eax
  801b03:	53                   	push   %ebx
  801b04:	e8 b0 fc ff ff       	call   8017b9 <fd_lookup>
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 3a                	js     801b4a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1a:	ff 30                	pushl  (%eax)
  801b1c:	e8 e8 fc ff ff       	call   801809 <dev_lookup>
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 22                	js     801b4a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b2f:	74 1e                	je     801b4f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b34:	8b 52 0c             	mov    0xc(%edx),%edx
  801b37:	85 d2                	test   %edx,%edx
  801b39:	74 35                	je     801b70 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	ff 75 10             	pushl  0x10(%ebp)
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	ff d2                	call   *%edx
  801b47:	83 c4 10             	add    $0x10,%esp
}
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b4f:	a1 08 50 80 00       	mov    0x805008,%eax
  801b54:	8b 40 48             	mov    0x48(%eax),%eax
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	53                   	push   %ebx
  801b5b:	50                   	push   %eax
  801b5c:	68 a1 31 80 00       	push   $0x8031a1
  801b61:	e8 a7 e7 ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6e:	eb da                	jmp    801b4a <write+0x55>
		return -E_NOT_SUPP;
  801b70:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b75:	eb d3                	jmp    801b4a <write+0x55>

00801b77 <seek>:

int
seek(int fdnum, off_t offset)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b80:	50                   	push   %eax
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	e8 30 fc ff ff       	call   8017b9 <fd_lookup>
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 0e                	js     801b9e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 1c             	sub    $0x1c,%esp
  801ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801baa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	53                   	push   %ebx
  801baf:	e8 05 fc ff ff       	call   8017b9 <fd_lookup>
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	78 37                	js     801bf2 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bbb:	83 ec 08             	sub    $0x8,%esp
  801bbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc1:	50                   	push   %eax
  801bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc5:	ff 30                	pushl  (%eax)
  801bc7:	e8 3d fc ff ff       	call   801809 <dev_lookup>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 1f                	js     801bf2 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bda:	74 1b                	je     801bf7 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdf:	8b 52 18             	mov    0x18(%edx),%edx
  801be2:	85 d2                	test   %edx,%edx
  801be4:	74 32                	je     801c18 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801be6:	83 ec 08             	sub    $0x8,%esp
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	50                   	push   %eax
  801bed:	ff d2                	call   *%edx
  801bef:	83 c4 10             	add    $0x10,%esp
}
  801bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    
			thisenv->env_id, fdnum);
  801bf7:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bfc:	8b 40 48             	mov    0x48(%eax),%eax
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	53                   	push   %ebx
  801c03:	50                   	push   %eax
  801c04:	68 64 31 80 00       	push   $0x803164
  801c09:	e8 ff e6 ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c16:	eb da                	jmp    801bf2 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801c18:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c1d:	eb d3                	jmp    801bf2 <ftruncate+0x52>

00801c1f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	53                   	push   %ebx
  801c23:	83 ec 1c             	sub    $0x1c,%esp
  801c26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c29:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c2c:	50                   	push   %eax
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	e8 84 fb ff ff       	call   8017b9 <fd_lookup>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	78 4b                	js     801c87 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c3c:	83 ec 08             	sub    $0x8,%esp
  801c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c42:	50                   	push   %eax
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	ff 30                	pushl  (%eax)
  801c48:	e8 bc fb ff ff       	call   801809 <dev_lookup>
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	85 c0                	test   %eax,%eax
  801c52:	78 33                	js     801c87 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c57:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801c5b:	74 2f                	je     801c8c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c5d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c60:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c67:	00 00 00 
	stat->st_isdir = 0;
  801c6a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c71:	00 00 00 
	stat->st_dev = dev;
  801c74:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	53                   	push   %ebx
  801c7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c81:	ff 50 14             	call   *0x14(%eax)
  801c84:	83 c4 10             	add    $0x10,%esp
}
  801c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    
		return -E_NOT_SUPP;
  801c8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c91:	eb f4                	jmp    801c87 <fstat+0x68>

00801c93 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c98:	83 ec 08             	sub    $0x8,%esp
  801c9b:	6a 00                	push   $0x0
  801c9d:	ff 75 08             	pushl  0x8(%ebp)
  801ca0:	e8 22 02 00 00       	call   801ec7 <open>
  801ca5:	89 c3                	mov    %eax,%ebx
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 1b                	js     801cc9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	50                   	push   %eax
  801cb5:	e8 65 ff ff ff       	call   801c1f <fstat>
  801cba:	89 c6                	mov    %eax,%esi
	close(fd);
  801cbc:	89 1c 24             	mov    %ebx,(%esp)
  801cbf:	e8 27 fc ff ff       	call   8018eb <close>
	return r;
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	89 f3                	mov    %esi,%ebx
}
  801cc9:	89 d8                	mov    %ebx,%eax
  801ccb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5e                   	pop    %esi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    

00801cd2 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	56                   	push   %esi
  801cd6:	53                   	push   %ebx
  801cd7:	89 c6                	mov    %eax,%esi
  801cd9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801cdb:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ce2:	74 27                	je     801d0b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ce4:	6a 07                	push   $0x7
  801ce6:	68 00 60 80 00       	push   $0x806000
  801ceb:	56                   	push   %esi
  801cec:	ff 35 00 50 80 00    	pushl  0x805000
  801cf2:	e8 b2 f9 ff ff       	call   8016a9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cf7:	83 c4 0c             	add    $0xc,%esp
  801cfa:	6a 00                	push   $0x0
  801cfc:	53                   	push   %ebx
  801cfd:	6a 00                	push   $0x0
  801cff:	e8 3c f9 ff ff       	call   801640 <ipc_recv>
}
  801d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d07:	5b                   	pop    %ebx
  801d08:	5e                   	pop    %esi
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	6a 01                	push   $0x1
  801d10:	e8 ec f9 ff ff       	call   801701 <ipc_find_env>
  801d15:	a3 00 50 80 00       	mov    %eax,0x805000
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	eb c5                	jmp    801ce4 <fsipc+0x12>

00801d1f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d33:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d38:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3d:	b8 02 00 00 00       	mov    $0x2,%eax
  801d42:	e8 8b ff ff ff       	call   801cd2 <fsipc>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <devfile_flush>:
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d64:	e8 69 ff ff ff       	call   801cd2 <fsipc>
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <devfile_stat>:
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	53                   	push   %ebx
  801d6f:	83 ec 04             	sub    $0x4,%esp
  801d72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7b:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	b8 05 00 00 00       	mov    $0x5,%eax
  801d8a:	e8 43 ff ff ff       	call   801cd2 <fsipc>
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	78 2c                	js     801dbf <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d93:	83 ec 08             	sub    $0x8,%esp
  801d96:	68 00 60 80 00       	push   $0x806000
  801d9b:	53                   	push   %ebx
  801d9c:	e8 cb ec ff ff       	call   800a6c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801da1:	a1 80 60 80 00       	mov    0x806080,%eax
  801da6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dac:	a1 84 60 80 00       	mov    0x806084,%eax
  801db1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <devfile_write>:
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 08             	sub    $0x8,%esp
  801dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd4:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801dd9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801ddf:	53                   	push   %ebx
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	68 08 60 80 00       	push   $0x806008
  801de8:	e8 6f ee ff ff       	call   800c5c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ded:	ba 00 00 00 00       	mov    $0x0,%edx
  801df2:	b8 04 00 00 00       	mov    $0x4,%eax
  801df7:	e8 d6 fe ff ff       	call   801cd2 <fsipc>
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 0b                	js     801e0e <devfile_write+0x4a>
	assert(r <= n);
  801e03:	39 d8                	cmp    %ebx,%eax
  801e05:	77 0c                	ja     801e13 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801e07:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e0c:	7f 1e                	jg     801e2c <devfile_write+0x68>
}
  801e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    
	assert(r <= n);
  801e13:	68 d4 31 80 00       	push   $0x8031d4
  801e18:	68 db 31 80 00       	push   $0x8031db
  801e1d:	68 98 00 00 00       	push   $0x98
  801e22:	68 f0 31 80 00       	push   $0x8031f0
  801e27:	e8 eb e3 ff ff       	call   800217 <_panic>
	assert(r <= PGSIZE);
  801e2c:	68 fb 31 80 00       	push   $0x8031fb
  801e31:	68 db 31 80 00       	push   $0x8031db
  801e36:	68 99 00 00 00       	push   $0x99
  801e3b:	68 f0 31 80 00       	push   $0x8031f0
  801e40:	e8 d2 e3 ff ff       	call   800217 <_panic>

00801e45 <devfile_read>:
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	56                   	push   %esi
  801e49:	53                   	push   %ebx
  801e4a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	8b 40 0c             	mov    0xc(%eax),%eax
  801e53:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801e58:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e63:	b8 03 00 00 00       	mov    $0x3,%eax
  801e68:	e8 65 fe ff ff       	call   801cd2 <fsipc>
  801e6d:	89 c3                	mov    %eax,%ebx
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 1f                	js     801e92 <devfile_read+0x4d>
	assert(r <= n);
  801e73:	39 f0                	cmp    %esi,%eax
  801e75:	77 24                	ja     801e9b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801e77:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e7c:	7f 33                	jg     801eb1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	50                   	push   %eax
  801e82:	68 00 60 80 00       	push   $0x806000
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	e8 6b ed ff ff       	call   800bfa <memmove>
	return r;
  801e8f:	83 c4 10             	add    $0x10,%esp
}
  801e92:	89 d8                	mov    %ebx,%eax
  801e94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    
	assert(r <= n);
  801e9b:	68 d4 31 80 00       	push   $0x8031d4
  801ea0:	68 db 31 80 00       	push   $0x8031db
  801ea5:	6a 7c                	push   $0x7c
  801ea7:	68 f0 31 80 00       	push   $0x8031f0
  801eac:	e8 66 e3 ff ff       	call   800217 <_panic>
	assert(r <= PGSIZE);
  801eb1:	68 fb 31 80 00       	push   $0x8031fb
  801eb6:	68 db 31 80 00       	push   $0x8031db
  801ebb:	6a 7d                	push   $0x7d
  801ebd:	68 f0 31 80 00       	push   $0x8031f0
  801ec2:	e8 50 e3 ff ff       	call   800217 <_panic>

00801ec7 <open>:
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
  801ecc:	83 ec 1c             	sub    $0x1c,%esp
  801ecf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ed2:	56                   	push   %esi
  801ed3:	e8 5b eb ff ff       	call   800a33 <strlen>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ee0:	7f 6c                	jg     801f4e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	e8 79 f8 ff ff       	call   801767 <fd_alloc>
  801eee:	89 c3                	mov    %eax,%ebx
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	78 3c                	js     801f33 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801ef7:	83 ec 08             	sub    $0x8,%esp
  801efa:	56                   	push   %esi
  801efb:	68 00 60 80 00       	push   $0x806000
  801f00:	e8 67 eb ff ff       	call   800a6c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f08:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f10:	b8 01 00 00 00       	mov    $0x1,%eax
  801f15:	e8 b8 fd ff ff       	call   801cd2 <fsipc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 19                	js     801f3c <open+0x75>
	return fd2num(fd);
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	e8 12 f8 ff ff       	call   801740 <fd2num>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
}
  801f33:	89 d8                	mov    %ebx,%eax
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
		fd_close(fd, 0);
  801f3c:	83 ec 08             	sub    $0x8,%esp
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 f4             	pushl  -0xc(%ebp)
  801f44:	e8 1b f9 ff ff       	call   801864 <fd_close>
		return r;
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	eb e5                	jmp    801f33 <open+0x6c>
		return -E_BAD_PATH;
  801f4e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f53:	eb de                	jmp    801f33 <open+0x6c>

00801f55 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f60:	b8 08 00 00 00       	mov    $0x8,%eax
  801f65:	e8 68 fd ff ff       	call   801cd2 <fsipc>
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f72:	68 07 32 80 00       	push   $0x803207
  801f77:	ff 75 0c             	pushl  0xc(%ebp)
  801f7a:	e8 ed ea ff ff       	call   800a6c <strcpy>
	return 0;
}
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <devsock_close>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	53                   	push   %ebx
  801f8a:	83 ec 10             	sub    $0x10,%esp
  801f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f90:	53                   	push   %ebx
  801f91:	e8 95 09 00 00       	call   80292b <pageref>
  801f96:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f99:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f9e:	83 f8 01             	cmp    $0x1,%eax
  801fa1:	74 07                	je     801faa <devsock_close+0x24>
}
  801fa3:	89 d0                	mov    %edx,%eax
  801fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	ff 73 0c             	pushl  0xc(%ebx)
  801fb0:	e8 b9 02 00 00       	call   80226e <nsipc_close>
  801fb5:	89 c2                	mov    %eax,%edx
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	eb e7                	jmp    801fa3 <devsock_close+0x1d>

00801fbc <devsock_write>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 10             	pushl  0x10(%ebp)
  801fc7:	ff 75 0c             	pushl  0xc(%ebp)
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	ff 70 0c             	pushl  0xc(%eax)
  801fd0:	e8 76 03 00 00       	call   80234b <nsipc_send>
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <devsock_read>:
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	ff 75 10             	pushl  0x10(%ebp)
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	ff 70 0c             	pushl  0xc(%eax)
  801feb:	e8 ef 02 00 00       	call   8022df <nsipc_recv>
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <fd2sockid>:
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ff8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ffb:	52                   	push   %edx
  801ffc:	50                   	push   %eax
  801ffd:	e8 b7 f7 ff ff       	call   8017b9 <fd_lookup>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 10                	js     802019 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  802012:	39 08                	cmp    %ecx,(%eax)
  802014:	75 05                	jne    80201b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802016:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    
		return -E_NOT_SUPP;
  80201b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802020:	eb f7                	jmp    802019 <fd2sockid+0x27>

00802022 <alloc_sockfd>:
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	56                   	push   %esi
  802026:	53                   	push   %ebx
  802027:	83 ec 1c             	sub    $0x1c,%esp
  80202a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80202c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202f:	50                   	push   %eax
  802030:	e8 32 f7 ff ff       	call   801767 <fd_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 43                	js     802081 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 07 04 00 00       	push   $0x407
  802046:	ff 75 f4             	pushl  -0xc(%ebp)
  802049:	6a 00                	push   $0x0
  80204b:	e8 0e ee ff ff       	call   800e5e <sys_page_alloc>
  802050:	89 c3                	mov    %eax,%ebx
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	78 28                	js     802081 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802062:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80206e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	50                   	push   %eax
  802075:	e8 c6 f6 ff ff       	call   801740 <fd2num>
  80207a:	89 c3                	mov    %eax,%ebx
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	eb 0c                	jmp    80208d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	56                   	push   %esi
  802085:	e8 e4 01 00 00       	call   80226e <nsipc_close>
		return r;
  80208a:	83 c4 10             	add    $0x10,%esp
}
  80208d:	89 d8                	mov    %ebx,%eax
  80208f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802092:	5b                   	pop    %ebx
  802093:	5e                   	pop    %esi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <accept>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	e8 4e ff ff ff       	call   801ff2 <fd2sockid>
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	78 1b                	js     8020c3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	ff 75 10             	pushl  0x10(%ebp)
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	50                   	push   %eax
  8020b2:	e8 0e 01 00 00       	call   8021c5 <nsipc_accept>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	78 05                	js     8020c3 <accept+0x2d>
	return alloc_sockfd(r);
  8020be:	e8 5f ff ff ff       	call   802022 <alloc_sockfd>
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <bind>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	e8 1f ff ff ff       	call   801ff2 <fd2sockid>
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 12                	js     8020e9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	ff 75 10             	pushl  0x10(%ebp)
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	50                   	push   %eax
  8020e1:	e8 31 01 00 00       	call   802217 <nsipc_bind>
  8020e6:	83 c4 10             	add    $0x10,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <shutdown>:
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	e8 f9 fe ff ff       	call   801ff2 <fd2sockid>
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 0f                	js     80210c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020fd:	83 ec 08             	sub    $0x8,%esp
  802100:	ff 75 0c             	pushl  0xc(%ebp)
  802103:	50                   	push   %eax
  802104:	e8 43 01 00 00       	call   80224c <nsipc_shutdown>
  802109:	83 c4 10             	add    $0x10,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <connect>:
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	e8 d6 fe ff ff       	call   801ff2 <fd2sockid>
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 12                	js     802132 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	ff 75 10             	pushl  0x10(%ebp)
  802126:	ff 75 0c             	pushl  0xc(%ebp)
  802129:	50                   	push   %eax
  80212a:	e8 59 01 00 00       	call   802288 <nsipc_connect>
  80212f:	83 c4 10             	add    $0x10,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <listen>:
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	e8 b0 fe ff ff       	call   801ff2 <fd2sockid>
  802142:	85 c0                	test   %eax,%eax
  802144:	78 0f                	js     802155 <listen+0x21>
	return nsipc_listen(r, backlog);
  802146:	83 ec 08             	sub    $0x8,%esp
  802149:	ff 75 0c             	pushl  0xc(%ebp)
  80214c:	50                   	push   %eax
  80214d:	e8 6b 01 00 00       	call   8022bd <nsipc_listen>
  802152:	83 c4 10             	add    $0x10,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <socket>:

int
socket(int domain, int type, int protocol)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	e8 3e 02 00 00       	call   8023a9 <nsipc_socket>
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	85 c0                	test   %eax,%eax
  802170:	78 05                	js     802177 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802172:	e8 ab fe ff ff       	call   802022 <alloc_sockfd>
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	53                   	push   %ebx
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802182:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802189:	74 26                	je     8021b1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80218b:	6a 07                	push   $0x7
  80218d:	68 00 70 80 00       	push   $0x807000
  802192:	53                   	push   %ebx
  802193:	ff 35 04 50 80 00    	pushl  0x805004
  802199:	e8 0b f5 ff ff       	call   8016a9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80219e:	83 c4 0c             	add    $0xc,%esp
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	e8 94 f4 ff ff       	call   801640 <ipc_recv>
}
  8021ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	6a 02                	push   $0x2
  8021b6:	e8 46 f5 ff ff       	call   801701 <ipc_find_env>
  8021bb:	a3 04 50 80 00       	mov    %eax,0x805004
  8021c0:	83 c4 10             	add    $0x10,%esp
  8021c3:	eb c6                	jmp    80218b <nsipc+0x12>

008021c5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	56                   	push   %esi
  8021c9:	53                   	push   %ebx
  8021ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021d5:	8b 06                	mov    (%esi),%eax
  8021d7:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e1:	e8 93 ff ff ff       	call   802179 <nsipc>
  8021e6:	89 c3                	mov    %eax,%ebx
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	79 09                	jns    8021f5 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021ec:	89 d8                	mov    %ebx,%eax
  8021ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021f5:	83 ec 04             	sub    $0x4,%esp
  8021f8:	ff 35 10 70 80 00    	pushl  0x807010
  8021fe:	68 00 70 80 00       	push   $0x807000
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	e8 ef e9 ff ff       	call   800bfa <memmove>
		*addrlen = ret->ret_addrlen;
  80220b:	a1 10 70 80 00       	mov    0x807010,%eax
  802210:	89 06                	mov    %eax,(%esi)
  802212:	83 c4 10             	add    $0x10,%esp
	return r;
  802215:	eb d5                	jmp    8021ec <nsipc_accept+0x27>

00802217 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	53                   	push   %ebx
  80221b:	83 ec 08             	sub    $0x8,%esp
  80221e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802229:	53                   	push   %ebx
  80222a:	ff 75 0c             	pushl  0xc(%ebp)
  80222d:	68 04 70 80 00       	push   $0x807004
  802232:	e8 c3 e9 ff ff       	call   800bfa <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802237:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80223d:	b8 02 00 00 00       	mov    $0x2,%eax
  802242:	e8 32 ff ff ff       	call   802179 <nsipc>
}
  802247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80225a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802262:	b8 03 00 00 00       	mov    $0x3,%eax
  802267:	e8 0d ff ff ff       	call   802179 <nsipc>
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <nsipc_close>:

int
nsipc_close(int s)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80227c:	b8 04 00 00 00       	mov    $0x4,%eax
  802281:	e8 f3 fe ff ff       	call   802179 <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	53                   	push   %ebx
  80228c:	83 ec 08             	sub    $0x8,%esp
  80228f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80229a:	53                   	push   %ebx
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	68 04 70 80 00       	push   $0x807004
  8022a3:	e8 52 e9 ff ff       	call   800bfa <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022ae:	b8 05 00 00 00       	mov    $0x5,%eax
  8022b3:	e8 c1 fe ff ff       	call   802179 <nsipc>
}
  8022b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
  8022c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8022d8:	e8 9c fe ff ff       	call   802179 <nsipc>
}
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022ef:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f8:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022fd:	b8 07 00 00 00       	mov    $0x7,%eax
  802302:	e8 72 fe ff ff       	call   802179 <nsipc>
  802307:	89 c3                	mov    %eax,%ebx
  802309:	85 c0                	test   %eax,%eax
  80230b:	78 1f                	js     80232c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80230d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802312:	7f 21                	jg     802335 <nsipc_recv+0x56>
  802314:	39 c6                	cmp    %eax,%esi
  802316:	7c 1d                	jl     802335 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802318:	83 ec 04             	sub    $0x4,%esp
  80231b:	50                   	push   %eax
  80231c:	68 00 70 80 00       	push   $0x807000
  802321:	ff 75 0c             	pushl  0xc(%ebp)
  802324:	e8 d1 e8 ff ff       	call   800bfa <memmove>
  802329:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80232c:	89 d8                	mov    %ebx,%eax
  80232e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802335:	68 13 32 80 00       	push   $0x803213
  80233a:	68 db 31 80 00       	push   $0x8031db
  80233f:	6a 62                	push   $0x62
  802341:	68 28 32 80 00       	push   $0x803228
  802346:	e8 cc de ff ff       	call   800217 <_panic>

0080234b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80235d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802363:	7f 2e                	jg     802393 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	53                   	push   %ebx
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	68 0c 70 80 00       	push   $0x80700c
  802371:	e8 84 e8 ff ff       	call   800bfa <memmove>
	nsipcbuf.send.req_size = size;
  802376:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80237c:	8b 45 14             	mov    0x14(%ebp),%eax
  80237f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802384:	b8 08 00 00 00       	mov    $0x8,%eax
  802389:	e8 eb fd ff ff       	call   802179 <nsipc>
}
  80238e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802391:	c9                   	leave  
  802392:	c3                   	ret    
	assert(size < 1600);
  802393:	68 34 32 80 00       	push   $0x803234
  802398:	68 db 31 80 00       	push   $0x8031db
  80239d:	6a 6d                	push   $0x6d
  80239f:	68 28 32 80 00       	push   $0x803228
  8023a4:	e8 6e de ff ff       	call   800217 <_panic>

008023a9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ba:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8023cc:	e8 a8 fd ff ff       	call   802179 <nsipc>
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023db:	83 ec 0c             	sub    $0xc,%esp
  8023de:	ff 75 08             	pushl  0x8(%ebp)
  8023e1:	e8 6a f3 ff ff       	call   801750 <fd2data>
  8023e6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023e8:	83 c4 08             	add    $0x8,%esp
  8023eb:	68 40 32 80 00       	push   $0x803240
  8023f0:	53                   	push   %ebx
  8023f1:	e8 76 e6 ff ff       	call   800a6c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023f6:	8b 46 04             	mov    0x4(%esi),%eax
  8023f9:	2b 06                	sub    (%esi),%eax
  8023fb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802401:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802408:	00 00 00 
	stat->st_dev = &devpipe;
  80240b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802412:	40 80 00 
	return 0;
}
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
  80241a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	53                   	push   %ebx
  802425:	83 ec 0c             	sub    $0xc,%esp
  802428:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80242b:	53                   	push   %ebx
  80242c:	6a 00                	push   $0x0
  80242e:	e8 b0 ea ff ff       	call   800ee3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802433:	89 1c 24             	mov    %ebx,(%esp)
  802436:	e8 15 f3 ff ff       	call   801750 <fd2data>
  80243b:	83 c4 08             	add    $0x8,%esp
  80243e:	50                   	push   %eax
  80243f:	6a 00                	push   $0x0
  802441:	e8 9d ea ff ff       	call   800ee3 <sys_page_unmap>
}
  802446:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <_pipeisclosed>:
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	57                   	push   %edi
  80244f:	56                   	push   %esi
  802450:	53                   	push   %ebx
  802451:	83 ec 1c             	sub    $0x1c,%esp
  802454:	89 c7                	mov    %eax,%edi
  802456:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802458:	a1 08 50 80 00       	mov    0x805008,%eax
  80245d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802460:	83 ec 0c             	sub    $0xc,%esp
  802463:	57                   	push   %edi
  802464:	e8 c2 04 00 00       	call   80292b <pageref>
  802469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80246c:	89 34 24             	mov    %esi,(%esp)
  80246f:	e8 b7 04 00 00       	call   80292b <pageref>
		nn = thisenv->env_runs;
  802474:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80247a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80247d:	83 c4 10             	add    $0x10,%esp
  802480:	39 cb                	cmp    %ecx,%ebx
  802482:	74 1b                	je     80249f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802484:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802487:	75 cf                	jne    802458 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802489:	8b 42 58             	mov    0x58(%edx),%eax
  80248c:	6a 01                	push   $0x1
  80248e:	50                   	push   %eax
  80248f:	53                   	push   %ebx
  802490:	68 47 32 80 00       	push   $0x803247
  802495:	e8 73 de ff ff       	call   80030d <cprintf>
  80249a:	83 c4 10             	add    $0x10,%esp
  80249d:	eb b9                	jmp    802458 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80249f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024a2:	0f 94 c0             	sete   %al
  8024a5:	0f b6 c0             	movzbl %al,%eax
}
  8024a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <devpipe_write>:
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	57                   	push   %edi
  8024b4:	56                   	push   %esi
  8024b5:	53                   	push   %ebx
  8024b6:	83 ec 28             	sub    $0x28,%esp
  8024b9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024bc:	56                   	push   %esi
  8024bd:	e8 8e f2 ff ff       	call   801750 <fd2data>
  8024c2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c4:	83 c4 10             	add    $0x10,%esp
  8024c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024cf:	74 4f                	je     802520 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024d4:	8b 0b                	mov    (%ebx),%ecx
  8024d6:	8d 51 20             	lea    0x20(%ecx),%edx
  8024d9:	39 d0                	cmp    %edx,%eax
  8024db:	72 14                	jb     8024f1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024dd:	89 da                	mov    %ebx,%edx
  8024df:	89 f0                	mov    %esi,%eax
  8024e1:	e8 65 ff ff ff       	call   80244b <_pipeisclosed>
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	75 3b                	jne    802525 <devpipe_write+0x75>
			sys_yield();
  8024ea:	e8 50 e9 ff ff       	call   800e3f <sys_yield>
  8024ef:	eb e0                	jmp    8024d1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024f4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024f8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024fb:	89 c2                	mov    %eax,%edx
  8024fd:	c1 fa 1f             	sar    $0x1f,%edx
  802500:	89 d1                	mov    %edx,%ecx
  802502:	c1 e9 1b             	shr    $0x1b,%ecx
  802505:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802508:	83 e2 1f             	and    $0x1f,%edx
  80250b:	29 ca                	sub    %ecx,%edx
  80250d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802511:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802515:	83 c0 01             	add    $0x1,%eax
  802518:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80251b:	83 c7 01             	add    $0x1,%edi
  80251e:	eb ac                	jmp    8024cc <devpipe_write+0x1c>
	return i;
  802520:	8b 45 10             	mov    0x10(%ebp),%eax
  802523:	eb 05                	jmp    80252a <devpipe_write+0x7a>
				return 0;
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80252d:	5b                   	pop    %ebx
  80252e:	5e                   	pop    %esi
  80252f:	5f                   	pop    %edi
  802530:	5d                   	pop    %ebp
  802531:	c3                   	ret    

00802532 <devpipe_read>:
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	57                   	push   %edi
  802536:	56                   	push   %esi
  802537:	53                   	push   %ebx
  802538:	83 ec 18             	sub    $0x18,%esp
  80253b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80253e:	57                   	push   %edi
  80253f:	e8 0c f2 ff ff       	call   801750 <fd2data>
  802544:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	be 00 00 00 00       	mov    $0x0,%esi
  80254e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802551:	75 14                	jne    802567 <devpipe_read+0x35>
	return i;
  802553:	8b 45 10             	mov    0x10(%ebp),%eax
  802556:	eb 02                	jmp    80255a <devpipe_read+0x28>
				return i;
  802558:	89 f0                	mov    %esi,%eax
}
  80255a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5f                   	pop    %edi
  802560:	5d                   	pop    %ebp
  802561:	c3                   	ret    
			sys_yield();
  802562:	e8 d8 e8 ff ff       	call   800e3f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802567:	8b 03                	mov    (%ebx),%eax
  802569:	3b 43 04             	cmp    0x4(%ebx),%eax
  80256c:	75 18                	jne    802586 <devpipe_read+0x54>
			if (i > 0)
  80256e:	85 f6                	test   %esi,%esi
  802570:	75 e6                	jne    802558 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802572:	89 da                	mov    %ebx,%edx
  802574:	89 f8                	mov    %edi,%eax
  802576:	e8 d0 fe ff ff       	call   80244b <_pipeisclosed>
  80257b:	85 c0                	test   %eax,%eax
  80257d:	74 e3                	je     802562 <devpipe_read+0x30>
				return 0;
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	eb d4                	jmp    80255a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802586:	99                   	cltd   
  802587:	c1 ea 1b             	shr    $0x1b,%edx
  80258a:	01 d0                	add    %edx,%eax
  80258c:	83 e0 1f             	and    $0x1f,%eax
  80258f:	29 d0                	sub    %edx,%eax
  802591:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802596:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802599:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80259c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80259f:	83 c6 01             	add    $0x1,%esi
  8025a2:	eb aa                	jmp    80254e <devpipe_read+0x1c>

008025a4 <pipe>:
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	56                   	push   %esi
  8025a8:	53                   	push   %ebx
  8025a9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025af:	50                   	push   %eax
  8025b0:	e8 b2 f1 ff ff       	call   801767 <fd_alloc>
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	83 c4 10             	add    $0x10,%esp
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 88 23 01 00 00    	js     8026e5 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 07 04 00 00       	push   $0x407
  8025ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8025cd:	6a 00                	push   $0x0
  8025cf:	e8 8a e8 ff ff       	call   800e5e <sys_page_alloc>
  8025d4:	89 c3                	mov    %eax,%ebx
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	0f 88 04 01 00 00    	js     8026e5 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025e7:	50                   	push   %eax
  8025e8:	e8 7a f1 ff ff       	call   801767 <fd_alloc>
  8025ed:	89 c3                	mov    %eax,%ebx
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	0f 88 db 00 00 00    	js     8026d5 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 07 04 00 00       	push   $0x407
  802602:	ff 75 f0             	pushl  -0x10(%ebp)
  802605:	6a 00                	push   $0x0
  802607:	e8 52 e8 ff ff       	call   800e5e <sys_page_alloc>
  80260c:	89 c3                	mov    %eax,%ebx
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	0f 88 bc 00 00 00    	js     8026d5 <pipe+0x131>
	va = fd2data(fd0);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	ff 75 f4             	pushl  -0xc(%ebp)
  80261f:	e8 2c f1 ff ff       	call   801750 <fd2data>
  802624:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802626:	83 c4 0c             	add    $0xc,%esp
  802629:	68 07 04 00 00       	push   $0x407
  80262e:	50                   	push   %eax
  80262f:	6a 00                	push   $0x0
  802631:	e8 28 e8 ff ff       	call   800e5e <sys_page_alloc>
  802636:	89 c3                	mov    %eax,%ebx
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	85 c0                	test   %eax,%eax
  80263d:	0f 88 82 00 00 00    	js     8026c5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	ff 75 f0             	pushl  -0x10(%ebp)
  802649:	e8 02 f1 ff ff       	call   801750 <fd2data>
  80264e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802655:	50                   	push   %eax
  802656:	6a 00                	push   $0x0
  802658:	56                   	push   %esi
  802659:	6a 00                	push   $0x0
  80265b:	e8 41 e8 ff ff       	call   800ea1 <sys_page_map>
  802660:	89 c3                	mov    %eax,%ebx
  802662:	83 c4 20             	add    $0x20,%esp
  802665:	85 c0                	test   %eax,%eax
  802667:	78 4e                	js     8026b7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802669:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80266e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802671:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802676:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80267d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802680:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80268c:	83 ec 0c             	sub    $0xc,%esp
  80268f:	ff 75 f4             	pushl  -0xc(%ebp)
  802692:	e8 a9 f0 ff ff       	call   801740 <fd2num>
  802697:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80269c:	83 c4 04             	add    $0x4,%esp
  80269f:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a2:	e8 99 f0 ff ff       	call   801740 <fd2num>
  8026a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026aa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ad:	83 c4 10             	add    $0x10,%esp
  8026b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026b5:	eb 2e                	jmp    8026e5 <pipe+0x141>
	sys_page_unmap(0, va);
  8026b7:	83 ec 08             	sub    $0x8,%esp
  8026ba:	56                   	push   %esi
  8026bb:	6a 00                	push   $0x0
  8026bd:	e8 21 e8 ff ff       	call   800ee3 <sys_page_unmap>
  8026c2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026c5:	83 ec 08             	sub    $0x8,%esp
  8026c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026cb:	6a 00                	push   $0x0
  8026cd:	e8 11 e8 ff ff       	call   800ee3 <sys_page_unmap>
  8026d2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026d5:	83 ec 08             	sub    $0x8,%esp
  8026d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026db:	6a 00                	push   $0x0
  8026dd:	e8 01 e8 ff ff       	call   800ee3 <sys_page_unmap>
  8026e2:	83 c4 10             	add    $0x10,%esp
}
  8026e5:	89 d8                	mov    %ebx,%eax
  8026e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026ea:	5b                   	pop    %ebx
  8026eb:	5e                   	pop    %esi
  8026ec:	5d                   	pop    %ebp
  8026ed:	c3                   	ret    

008026ee <pipeisclosed>:
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026f7:	50                   	push   %eax
  8026f8:	ff 75 08             	pushl  0x8(%ebp)
  8026fb:	e8 b9 f0 ff ff       	call   8017b9 <fd_lookup>
  802700:	83 c4 10             	add    $0x10,%esp
  802703:	85 c0                	test   %eax,%eax
  802705:	78 18                	js     80271f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802707:	83 ec 0c             	sub    $0xc,%esp
  80270a:	ff 75 f4             	pushl  -0xc(%ebp)
  80270d:	e8 3e f0 ff ff       	call   801750 <fd2data>
	return _pipeisclosed(fd, p);
  802712:	89 c2                	mov    %eax,%edx
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	e8 2f fd ff ff       	call   80244b <_pipeisclosed>
  80271c:	83 c4 10             	add    $0x10,%esp
}
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
  802726:	c3                   	ret    

00802727 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80272d:	68 5f 32 80 00       	push   $0x80325f
  802732:	ff 75 0c             	pushl  0xc(%ebp)
  802735:	e8 32 e3 ff ff       	call   800a6c <strcpy>
	return 0;
}
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <devcons_write>:
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	57                   	push   %edi
  802745:	56                   	push   %esi
  802746:	53                   	push   %ebx
  802747:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80274d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802752:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802758:	3b 75 10             	cmp    0x10(%ebp),%esi
  80275b:	73 31                	jae    80278e <devcons_write+0x4d>
		m = n - tot;
  80275d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802760:	29 f3                	sub    %esi,%ebx
  802762:	83 fb 7f             	cmp    $0x7f,%ebx
  802765:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80276a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	53                   	push   %ebx
  802771:	89 f0                	mov    %esi,%eax
  802773:	03 45 0c             	add    0xc(%ebp),%eax
  802776:	50                   	push   %eax
  802777:	57                   	push   %edi
  802778:	e8 7d e4 ff ff       	call   800bfa <memmove>
		sys_cputs(buf, m);
  80277d:	83 c4 08             	add    $0x8,%esp
  802780:	53                   	push   %ebx
  802781:	57                   	push   %edi
  802782:	e8 1b e6 ff ff       	call   800da2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802787:	01 de                	add    %ebx,%esi
  802789:	83 c4 10             	add    $0x10,%esp
  80278c:	eb ca                	jmp    802758 <devcons_write+0x17>
}
  80278e:	89 f0                	mov    %esi,%eax
  802790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802793:	5b                   	pop    %ebx
  802794:	5e                   	pop    %esi
  802795:	5f                   	pop    %edi
  802796:	5d                   	pop    %ebp
  802797:	c3                   	ret    

00802798 <devcons_read>:
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 08             	sub    $0x8,%esp
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027a7:	74 21                	je     8027ca <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027a9:	e8 12 e6 ff ff       	call   800dc0 <sys_cgetc>
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	75 07                	jne    8027b9 <devcons_read+0x21>
		sys_yield();
  8027b2:	e8 88 e6 ff ff       	call   800e3f <sys_yield>
  8027b7:	eb f0                	jmp    8027a9 <devcons_read+0x11>
	if (c < 0)
  8027b9:	78 0f                	js     8027ca <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027bb:	83 f8 04             	cmp    $0x4,%eax
  8027be:	74 0c                	je     8027cc <devcons_read+0x34>
	*(char*)vbuf = c;
  8027c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c3:	88 02                	mov    %al,(%edx)
	return 1;
  8027c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    
		return 0;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	eb f7                	jmp    8027ca <devcons_read+0x32>

008027d3 <cputchar>:
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027df:	6a 01                	push   $0x1
  8027e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027e4:	50                   	push   %eax
  8027e5:	e8 b8 e5 ff ff       	call   800da2 <sys_cputs>
}
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <getchar>:
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027f5:	6a 01                	push   $0x1
  8027f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fa:	50                   	push   %eax
  8027fb:	6a 00                	push   $0x0
  8027fd:	e8 27 f2 ff ff       	call   801a29 <read>
	if (r < 0)
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	85 c0                	test   %eax,%eax
  802807:	78 06                	js     80280f <getchar+0x20>
	if (r < 1)
  802809:	74 06                	je     802811 <getchar+0x22>
	return c;
  80280b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    
		return -E_EOF;
  802811:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802816:	eb f7                	jmp    80280f <getchar+0x20>

00802818 <iscons>:
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80281e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802821:	50                   	push   %eax
  802822:	ff 75 08             	pushl  0x8(%ebp)
  802825:	e8 8f ef ff ff       	call   8017b9 <fd_lookup>
  80282a:	83 c4 10             	add    $0x10,%esp
  80282d:	85 c0                	test   %eax,%eax
  80282f:	78 11                	js     802842 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80283a:	39 10                	cmp    %edx,(%eax)
  80283c:	0f 94 c0             	sete   %al
  80283f:	0f b6 c0             	movzbl %al,%eax
}
  802842:	c9                   	leave  
  802843:	c3                   	ret    

00802844 <opencons>:
{
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80284a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284d:	50                   	push   %eax
  80284e:	e8 14 ef ff ff       	call   801767 <fd_alloc>
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	78 3a                	js     802894 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 07 04 00 00       	push   $0x407
  802862:	ff 75 f4             	pushl  -0xc(%ebp)
  802865:	6a 00                	push   $0x0
  802867:	e8 f2 e5 ff ff       	call   800e5e <sys_page_alloc>
  80286c:	83 c4 10             	add    $0x10,%esp
  80286f:	85 c0                	test   %eax,%eax
  802871:	78 21                	js     802894 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80287c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802888:	83 ec 0c             	sub    $0xc,%esp
  80288b:	50                   	push   %eax
  80288c:	e8 af ee ff ff       	call   801740 <fd2num>
  802891:	83 c4 10             	add    $0x10,%esp
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80289c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028a3:	74 0a                	je     8028af <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	6a 07                	push   $0x7
  8028b4:	68 00 f0 bf ee       	push   $0xeebff000
  8028b9:	6a 00                	push   $0x0
  8028bb:	e8 9e e5 ff ff       	call   800e5e <sys_page_alloc>
		if(r < 0)
  8028c0:	83 c4 10             	add    $0x10,%esp
  8028c3:	85 c0                	test   %eax,%eax
  8028c5:	78 2a                	js     8028f1 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8028c7:	83 ec 08             	sub    $0x8,%esp
  8028ca:	68 05 29 80 00       	push   $0x802905
  8028cf:	6a 00                	push   $0x0
  8028d1:	e8 d3 e6 ff ff       	call   800fa9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8028d6:	83 c4 10             	add    $0x10,%esp
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	79 c8                	jns    8028a5 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 9c 32 80 00       	push   $0x80329c
  8028e5:	6a 25                	push   $0x25
  8028e7:	68 d8 32 80 00       	push   $0x8032d8
  8028ec:	e8 26 d9 ff ff       	call   800217 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 6c 32 80 00       	push   $0x80326c
  8028f9:	6a 22                	push   $0x22
  8028fb:	68 d8 32 80 00       	push   $0x8032d8
  802900:	e8 12 d9 ff ff       	call   800217 <_panic>

00802905 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802905:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802906:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80290b:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80290d:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802910:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802914:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802918:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80291b:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80291d:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802921:	83 c4 08             	add    $0x8,%esp
	popal
  802924:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802925:	83 c4 04             	add    $0x4,%esp
	popfl
  802928:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802929:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80292a:	c3                   	ret    

0080292b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802931:	89 d0                	mov    %edx,%eax
  802933:	c1 e8 16             	shr    $0x16,%eax
  802936:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802942:	f6 c1 01             	test   $0x1,%cl
  802945:	74 1d                	je     802964 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802947:	c1 ea 0c             	shr    $0xc,%edx
  80294a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802951:	f6 c2 01             	test   $0x1,%dl
  802954:	74 0e                	je     802964 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802956:	c1 ea 0c             	shr    $0xc,%edx
  802959:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802960:	ef 
  802961:	0f b7 c0             	movzwl %ax,%eax
}
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	66 90                	xchg   %ax,%ax
  802968:	66 90                	xchg   %ax,%ax
  80296a:	66 90                	xchg   %ax,%ax
  80296c:	66 90                	xchg   %ax,%ax
  80296e:	66 90                	xchg   %ax,%ax

00802970 <__udivdi3>:
  802970:	55                   	push   %ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	83 ec 1c             	sub    $0x1c,%esp
  802977:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80297b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80297f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802983:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802987:	85 d2                	test   %edx,%edx
  802989:	75 4d                	jne    8029d8 <__udivdi3+0x68>
  80298b:	39 f3                	cmp    %esi,%ebx
  80298d:	76 19                	jbe    8029a8 <__udivdi3+0x38>
  80298f:	31 ff                	xor    %edi,%edi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f2                	mov    %esi,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 d9                	mov    %ebx,%ecx
  8029aa:	85 db                	test   %ebx,%ebx
  8029ac:	75 0b                	jne    8029b9 <__udivdi3+0x49>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	31 d2                	xor    %edx,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 c1                	mov    %eax,%ecx
  8029b9:	31 d2                	xor    %edx,%edx
  8029bb:	89 f0                	mov    %esi,%eax
  8029bd:	f7 f1                	div    %ecx
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f7                	mov    %esi,%edi
  8029c5:	f7 f1                	div    %ecx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	77 1c                	ja     8029f8 <__udivdi3+0x88>
  8029dc:	0f bd fa             	bsr    %edx,%edi
  8029df:	83 f7 1f             	xor    $0x1f,%edi
  8029e2:	75 2c                	jne    802a10 <__udivdi3+0xa0>
  8029e4:	39 f2                	cmp    %esi,%edx
  8029e6:	72 06                	jb     8029ee <__udivdi3+0x7e>
  8029e8:	31 c0                	xor    %eax,%eax
  8029ea:	39 eb                	cmp    %ebp,%ebx
  8029ec:	77 a9                	ja     802997 <__udivdi3+0x27>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	eb a2                	jmp    802997 <__udivdi3+0x27>
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	31 ff                	xor    %edi,%edi
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	89 fa                	mov    %edi,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 f9                	mov    %edi,%ecx
  802a12:	b8 20 00 00 00       	mov    $0x20,%eax
  802a17:	29 f8                	sub    %edi,%eax
  802a19:	d3 e2                	shl    %cl,%edx
  802a1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	89 da                	mov    %ebx,%edx
  802a23:	d3 ea                	shr    %cl,%edx
  802a25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a29:	09 d1                	or     %edx,%ecx
  802a2b:	89 f2                	mov    %esi,%edx
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 f9                	mov    %edi,%ecx
  802a33:	d3 e3                	shl    %cl,%ebx
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	d3 ea                	shr    %cl,%edx
  802a39:	89 f9                	mov    %edi,%ecx
  802a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a3f:	89 eb                	mov    %ebp,%ebx
  802a41:	d3 e6                	shl    %cl,%esi
  802a43:	89 c1                	mov    %eax,%ecx
  802a45:	d3 eb                	shr    %cl,%ebx
  802a47:	09 de                	or     %ebx,%esi
  802a49:	89 f0                	mov    %esi,%eax
  802a4b:	f7 74 24 08          	divl   0x8(%esp)
  802a4f:	89 d6                	mov    %edx,%esi
  802a51:	89 c3                	mov    %eax,%ebx
  802a53:	f7 64 24 0c          	mull   0xc(%esp)
  802a57:	39 d6                	cmp    %edx,%esi
  802a59:	72 15                	jb     802a70 <__udivdi3+0x100>
  802a5b:	89 f9                	mov    %edi,%ecx
  802a5d:	d3 e5                	shl    %cl,%ebp
  802a5f:	39 c5                	cmp    %eax,%ebp
  802a61:	73 04                	jae    802a67 <__udivdi3+0xf7>
  802a63:	39 d6                	cmp    %edx,%esi
  802a65:	74 09                	je     802a70 <__udivdi3+0x100>
  802a67:	89 d8                	mov    %ebx,%eax
  802a69:	31 ff                	xor    %edi,%edi
  802a6b:	e9 27 ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	e9 1d ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	66 90                	xchg   %ax,%ax
  802a7e:	66 90                	xchg   %ax,%ax

00802a80 <__umoddi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a97:	89 da                	mov    %ebx,%edx
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	75 43                	jne    802ae0 <__umoddi3+0x60>
  802a9d:	39 df                	cmp    %ebx,%edi
  802a9f:	76 17                	jbe    802ab8 <__umoddi3+0x38>
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	f7 f7                	div    %edi
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	31 d2                	xor    %edx,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 fd                	mov    %edi,%ebp
  802aba:	85 ff                	test   %edi,%edi
  802abc:	75 0b                	jne    802ac9 <__umoddi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f7                	div    %edi
  802ac7:	89 c5                	mov    %eax,%ebp
  802ac9:	89 d8                	mov    %ebx,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f5                	div    %ebp
  802acf:	89 f0                	mov    %esi,%eax
  802ad1:	f7 f5                	div    %ebp
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	eb d0                	jmp    802aa7 <__umoddi3+0x27>
  802ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ade:	66 90                	xchg   %ax,%ax
  802ae0:	89 f1                	mov    %esi,%ecx
  802ae2:	39 d8                	cmp    %ebx,%eax
  802ae4:	76 0a                	jbe    802af0 <__umoddi3+0x70>
  802ae6:	89 f0                	mov    %esi,%eax
  802ae8:	83 c4 1c             	add    $0x1c,%esp
  802aeb:	5b                   	pop    %ebx
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	0f bd e8             	bsr    %eax,%ebp
  802af3:	83 f5 1f             	xor    $0x1f,%ebp
  802af6:	75 20                	jne    802b18 <__umoddi3+0x98>
  802af8:	39 d8                	cmp    %ebx,%eax
  802afa:	0f 82 b0 00 00 00    	jb     802bb0 <__umoddi3+0x130>
  802b00:	39 f7                	cmp    %esi,%edi
  802b02:	0f 86 a8 00 00 00    	jbe    802bb0 <__umoddi3+0x130>
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	83 c4 1c             	add    $0x1c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b1f:	29 ea                	sub    %ebp,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	d3 e8                	shr    %cl,%eax
  802b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b39:	09 c1                	or     %eax,%ecx
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	d3 e3                	shl    %cl,%ebx
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	89 d1                	mov    %edx,%ecx
  802b55:	89 f0                	mov    %esi,%eax
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 fa                	mov    %edi,%edx
  802b5d:	d3 e6                	shl    %cl,%esi
  802b5f:	09 d8                	or     %ebx,%eax
  802b61:	f7 74 24 08          	divl   0x8(%esp)
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	f7 64 24 0c          	mull   0xc(%esp)
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	89 d7                	mov    %edx,%edi
  802b71:	39 d1                	cmp    %edx,%ecx
  802b73:	72 06                	jb     802b7b <__umoddi3+0xfb>
  802b75:	75 10                	jne    802b87 <__umoddi3+0x107>
  802b77:	39 c3                	cmp    %eax,%ebx
  802b79:	73 0c                	jae    802b87 <__umoddi3+0x107>
  802b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b83:	89 d7                	mov    %edx,%edi
  802b85:	89 c6                	mov    %eax,%esi
  802b87:	89 ca                	mov    %ecx,%edx
  802b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b8e:	29 f3                	sub    %esi,%ebx
  802b90:	19 fa                	sbb    %edi,%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	d3 e0                	shl    %cl,%eax
  802b96:	89 e9                	mov    %ebp,%ecx
  802b98:	d3 eb                	shr    %cl,%ebx
  802b9a:	d3 ea                	shr    %cl,%edx
  802b9c:	09 d8                	or     %ebx,%eax
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	89 da                	mov    %ebx,%edx
  802bb2:	29 fe                	sub    %edi,%esi
  802bb4:	19 c2                	sbb    %eax,%edx
  802bb6:	89 f1                	mov    %esi,%ecx
  802bb8:	89 c8                	mov    %ecx,%eax
  802bba:	e9 4b ff ff ff       	jmp    802b0a <__umoddi3+0x8a>
