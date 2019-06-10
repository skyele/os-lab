
obj/user/testtime.debug:     file format elf32-i386


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

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003a:	e8 3d 10 00 00       	call   80107c <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 ef             	cmp    $0xffffffef,%eax
  80004f:	7d 14                	jge    800065 <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	77 22                	ja     800077 <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  800055:	e8 22 10 00 00       	call   80107c <sys_time_msec>
  80005a:	39 d8                	cmp    %ebx,%eax
  80005c:	73 2d                	jae    80008b <sleep+0x58>
		sys_yield();
  80005e:	e8 c8 0d 00 00       	call   800e2b <sys_yield>
  800063:	eb f0                	jmp    800055 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800065:	50                   	push   %eax
  800066:	68 20 26 80 00       	push   $0x802620
  80006b:	6a 0b                	push   $0xb
  80006d:	68 32 26 80 00       	push   $0x802632
  800072:	e8 8c 01 00 00       	call   800203 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 42 26 80 00       	push   $0x802642
  80007f:	6a 0d                	push   $0xd
  800081:	68 32 26 80 00       	push   $0x802632
  800086:	e8 78 01 00 00       	call   800203 <_panic>
}
  80008b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008e:	c9                   	leave  
  80008f:	c3                   	ret    

00800090 <umain>:

void
umain(int argc, char **argv)
{
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	53                   	push   %ebx
  800094:	83 ec 04             	sub    $0x4,%esp
  800097:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80009c:	e8 8a 0d 00 00       	call   800e2b <sys_yield>
	for (i = 0; i < 50; i++)
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 f6                	jne    80009c <umain+0xc>

	cprintf("starting count down: ");
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	68 4e 26 80 00       	push   $0x80264e
  8000ae:	e8 46 02 00 00       	call   8002f9 <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 64 26 80 00       	push   $0x802664
  8000c4:	e8 30 02 00 00       	call   8002f9 <cprintf>
		sleep(1);
  8000c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d0:	e8 5e ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000d5:	83 eb 01             	sub    $0x1,%ebx
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000de:	75 db                	jne    8000bb <umain+0x2b>
	}
	cprintf("\n");
  8000e0:	83 ec 0c             	sub    $0xc,%esp
  8000e3:	68 84 26 80 00       	push   $0x802684
  8000e8:	e8 0c 02 00 00       	call   8002f9 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000ed:	cc                   	int3   
	breakpoint();
}
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

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
  8000ff:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800106:	00 00 00 
	envid_t find = sys_getenvid();
  800109:	e8 fe 0c 00 00       	call   800e0c <sys_getenvid>
  80010e:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
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
  800157:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800161:	7e 0a                	jle    80016d <libmain+0x77>
		binaryname = argv[0];
  800163:	8b 45 0c             	mov    0xc(%ebp),%eax
  800166:	8b 00                	mov    (%eax),%eax
  800168:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80016d:	a1 08 40 80 00       	mov    0x804008,%eax
  800172:	8b 40 48             	mov    0x48(%eax),%eax
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	50                   	push   %eax
  800179:	68 68 26 80 00       	push   $0x802668
  80017e:	e8 76 01 00 00       	call   8002f9 <cprintf>
	cprintf("before umain\n");
  800183:	c7 04 24 86 26 80 00 	movl   $0x802686,(%esp)
  80018a:	e8 6a 01 00 00       	call   8002f9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 f3 fe ff ff       	call   800090 <umain>
	cprintf("after umain\n");
  80019d:	c7 04 24 94 26 80 00 	movl   $0x802694,(%esp)
  8001a4:	e8 50 01 00 00       	call   8002f9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	50                   	push   %eax
  8001b5:	68 a1 26 80 00       	push   $0x8026a1
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
  8001d5:	a1 08 40 80 00       	mov    0x804008,%eax
  8001da:	8b 40 48             	mov    0x48(%eax),%eax
  8001dd:	68 cc 26 80 00       	push   $0x8026cc
  8001e2:	50                   	push   %eax
  8001e3:	68 c0 26 80 00       	push   $0x8026c0
  8001e8:	e8 0c 01 00 00       	call   8002f9 <cprintf>
	close_all();
  8001ed:	e8 25 11 00 00       	call   801317 <close_all>
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
  800208:	a1 08 40 80 00       	mov    0x804008,%eax
  80020d:	8b 40 48             	mov    0x48(%eax),%eax
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	68 f8 26 80 00       	push   $0x8026f8
  800218:	50                   	push   %eax
  800219:	68 c0 26 80 00       	push   $0x8026c0
  80021e:	e8 d6 00 00 00       	call   8002f9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800223:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800226:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80022c:	e8 db 0b 00 00       	call   800e0c <sys_getenvid>
  800231:	83 c4 04             	add    $0x4,%esp
  800234:	ff 75 0c             	pushl  0xc(%ebp)
  800237:	ff 75 08             	pushl  0x8(%ebp)
  80023a:	56                   	push   %esi
  80023b:	50                   	push   %eax
  80023c:	68 d4 26 80 00       	push   $0x8026d4
  800241:	e8 b3 00 00 00       	call   8002f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800246:	83 c4 18             	add    $0x18,%esp
  800249:	53                   	push   %ebx
  80024a:	ff 75 10             	pushl  0x10(%ebp)
  80024d:	e8 56 00 00 00       	call   8002a8 <vcprintf>
	cprintf("\n");
  800252:	c7 04 24 84 26 80 00 	movl   $0x802684,(%esp)
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
  8003a6:	e8 25 20 00 00       	call   8023d0 <__udivdi3>
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
  8003cf:	e8 0c 21 00 00       	call   8024e0 <__umoddi3>
  8003d4:	83 c4 14             	add    $0x14,%esp
  8003d7:	0f be 80 ff 26 80 00 	movsbl 0x8026ff(%eax),%eax
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
  800480:	ff 24 85 e0 28 80 00 	jmp    *0x8028e0(,%eax,4)
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
  80054b:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	74 18                	je     80056e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800556:	52                   	push   %edx
  800557:	68 61 2b 80 00       	push   $0x802b61
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 a6 fe ff ff       	call   800409 <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
  800569:	e9 fe 02 00 00       	jmp    80086c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056e:	50                   	push   %eax
  80056f:	68 17 27 80 00       	push   $0x802717
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
  800596:	b8 10 27 80 00       	mov    $0x802710,%eax
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
  80092e:	bf 35 28 80 00       	mov    $0x802835,%edi
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
  80095a:	bf 6d 28 80 00       	mov    $0x80286d,%edi
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
  800dfb:	68 88 2a 80 00       	push   $0x802a88
  800e00:	6a 43                	push   $0x43
  800e02:	68 a5 2a 80 00       	push   $0x802aa5
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
  800e7c:	68 88 2a 80 00       	push   $0x802a88
  800e81:	6a 43                	push   $0x43
  800e83:	68 a5 2a 80 00       	push   $0x802aa5
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
  800ebe:	68 88 2a 80 00       	push   $0x802a88
  800ec3:	6a 43                	push   $0x43
  800ec5:	68 a5 2a 80 00       	push   $0x802aa5
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
  800f00:	68 88 2a 80 00       	push   $0x802a88
  800f05:	6a 43                	push   $0x43
  800f07:	68 a5 2a 80 00       	push   $0x802aa5
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
  800f42:	68 88 2a 80 00       	push   $0x802a88
  800f47:	6a 43                	push   $0x43
  800f49:	68 a5 2a 80 00       	push   $0x802aa5
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
  800f84:	68 88 2a 80 00       	push   $0x802a88
  800f89:	6a 43                	push   $0x43
  800f8b:	68 a5 2a 80 00       	push   $0x802aa5
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
  800fc6:	68 88 2a 80 00       	push   $0x802a88
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 a5 2a 80 00       	push   $0x802aa5
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
  80102a:	68 88 2a 80 00       	push   $0x802a88
  80102f:	6a 43                	push   $0x43
  801031:	68 a5 2a 80 00       	push   $0x802aa5
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
  80110e:	68 88 2a 80 00       	push   $0x802a88
  801113:	6a 43                	push   $0x43
  801115:	68 a5 2a 80 00       	push   $0x802aa5
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

0080113f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
  801145:	05 00 00 00 30       	add    $0x30000000,%eax
  80114a:	c1 e8 0c             	shr    $0xc,%eax
}
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80115a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80116e:	89 c2                	mov    %eax,%edx
  801170:	c1 ea 16             	shr    $0x16,%edx
  801173:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117a:	f6 c2 01             	test   $0x1,%dl
  80117d:	74 2d                	je     8011ac <fd_alloc+0x46>
  80117f:	89 c2                	mov    %eax,%edx
  801181:	c1 ea 0c             	shr    $0xc,%edx
  801184:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118b:	f6 c2 01             	test   $0x1,%dl
  80118e:	74 1c                	je     8011ac <fd_alloc+0x46>
  801190:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801195:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80119a:	75 d2                	jne    80116e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011a5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011aa:	eb 0a                	jmp    8011b6 <fd_alloc+0x50>
			*fd_store = fd;
  8011ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011af:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    

008011b8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011be:	83 f8 1f             	cmp    $0x1f,%eax
  8011c1:	77 30                	ja     8011f3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011c3:	c1 e0 0c             	shl    $0xc,%eax
  8011c6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011cb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011d1:	f6 c2 01             	test   $0x1,%dl
  8011d4:	74 24                	je     8011fa <fd_lookup+0x42>
  8011d6:	89 c2                	mov    %eax,%edx
  8011d8:	c1 ea 0c             	shr    $0xc,%edx
  8011db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e2:	f6 c2 01             	test   $0x1,%dl
  8011e5:	74 1a                	je     801201 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	89 02                	mov    %eax,(%edx)
	return 0;
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    
		return -E_INVAL;
  8011f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f8:	eb f7                	jmp    8011f1 <fd_lookup+0x39>
		return -E_INVAL;
  8011fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ff:	eb f0                	jmp    8011f1 <fd_lookup+0x39>
  801201:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801206:	eb e9                	jmp    8011f1 <fd_lookup+0x39>

00801208 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 08             	sub    $0x8,%esp
  80120e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801211:	ba 00 00 00 00       	mov    $0x0,%edx
  801216:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80121b:	39 08                	cmp    %ecx,(%eax)
  80121d:	74 38                	je     801257 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80121f:	83 c2 01             	add    $0x1,%edx
  801222:	8b 04 95 34 2b 80 00 	mov    0x802b34(,%edx,4),%eax
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 ee                	jne    80121b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80122d:	a1 08 40 80 00       	mov    0x804008,%eax
  801232:	8b 40 48             	mov    0x48(%eax),%eax
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	51                   	push   %ecx
  801239:	50                   	push   %eax
  80123a:	68 b4 2a 80 00       	push   $0x802ab4
  80123f:	e8 b5 f0 ff ff       	call   8002f9 <cprintf>
	*dev = 0;
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    
			*dev = devtab[i];
  801257:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	eb f2                	jmp    801255 <dev_lookup+0x4d>

00801263 <fd_close>:
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	57                   	push   %edi
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	83 ec 24             	sub    $0x24,%esp
  80126c:	8b 75 08             	mov    0x8(%ebp),%esi
  80126f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801272:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801275:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801276:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80127c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80127f:	50                   	push   %eax
  801280:	e8 33 ff ff ff       	call   8011b8 <fd_lookup>
  801285:	89 c3                	mov    %eax,%ebx
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 05                	js     801293 <fd_close+0x30>
	    || fd != fd2)
  80128e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801291:	74 16                	je     8012a9 <fd_close+0x46>
		return (must_exist ? r : 0);
  801293:	89 f8                	mov    %edi,%eax
  801295:	84 c0                	test   %al,%al
  801297:	b8 00 00 00 00       	mov    $0x0,%eax
  80129c:	0f 44 d8             	cmove  %eax,%ebx
}
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5e                   	pop    %esi
  8012a6:	5f                   	pop    %edi
  8012a7:	5d                   	pop    %ebp
  8012a8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a9:	83 ec 08             	sub    $0x8,%esp
  8012ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012af:	50                   	push   %eax
  8012b0:	ff 36                	pushl  (%esi)
  8012b2:	e8 51 ff ff ff       	call   801208 <dev_lookup>
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 1a                	js     8012da <fd_close+0x77>
		if (dev->dev_close)
  8012c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 0b                	je     8012da <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	56                   	push   %esi
  8012d3:	ff d0                	call   *%eax
  8012d5:	89 c3                	mov    %eax,%ebx
  8012d7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	56                   	push   %esi
  8012de:	6a 00                	push   $0x0
  8012e0:	e8 ea fb ff ff       	call   800ecf <sys_page_unmap>
	return r;
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	eb b5                	jmp    80129f <fd_close+0x3c>

008012ea <close>:

int
close(int fdnum)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 08             	pushl  0x8(%ebp)
  8012f7:	e8 bc fe ff ff       	call   8011b8 <fd_lookup>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	79 02                	jns    801305 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    
		return fd_close(fd, 1);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	6a 01                	push   $0x1
  80130a:	ff 75 f4             	pushl  -0xc(%ebp)
  80130d:	e8 51 ff ff ff       	call   801263 <fd_close>
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	eb ec                	jmp    801303 <close+0x19>

00801317 <close_all>:

void
close_all(void)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	53                   	push   %ebx
  80131b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80131e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	53                   	push   %ebx
  801327:	e8 be ff ff ff       	call   8012ea <close>
	for (i = 0; i < MAXFD; i++)
  80132c:	83 c3 01             	add    $0x1,%ebx
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	83 fb 20             	cmp    $0x20,%ebx
  801335:	75 ec                	jne    801323 <close_all+0xc>
}
  801337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801345:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801348:	50                   	push   %eax
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 67 fe ff ff       	call   8011b8 <fd_lookup>
  801351:	89 c3                	mov    %eax,%ebx
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	85 c0                	test   %eax,%eax
  801358:	0f 88 81 00 00 00    	js     8013df <dup+0xa3>
		return r;
	close(newfdnum);
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	e8 81 ff ff ff       	call   8012ea <close>

	newfd = INDEX2FD(newfdnum);
  801369:	8b 75 0c             	mov    0xc(%ebp),%esi
  80136c:	c1 e6 0c             	shl    $0xc,%esi
  80136f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801375:	83 c4 04             	add    $0x4,%esp
  801378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80137b:	e8 cf fd ff ff       	call   80114f <fd2data>
  801380:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801382:	89 34 24             	mov    %esi,(%esp)
  801385:	e8 c5 fd ff ff       	call   80114f <fd2data>
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80138f:	89 d8                	mov    %ebx,%eax
  801391:	c1 e8 16             	shr    $0x16,%eax
  801394:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80139b:	a8 01                	test   $0x1,%al
  80139d:	74 11                	je     8013b0 <dup+0x74>
  80139f:	89 d8                	mov    %ebx,%eax
  8013a1:	c1 e8 0c             	shr    $0xc,%eax
  8013a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ab:	f6 c2 01             	test   $0x1,%dl
  8013ae:	75 39                	jne    8013e9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	c1 e8 0c             	shr    $0xc,%eax
  8013b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013bf:	83 ec 0c             	sub    $0xc,%esp
  8013c2:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c7:	50                   	push   %eax
  8013c8:	56                   	push   %esi
  8013c9:	6a 00                	push   $0x0
  8013cb:	52                   	push   %edx
  8013cc:	6a 00                	push   $0x0
  8013ce:	e8 ba fa ff ff       	call   800e8d <sys_page_map>
  8013d3:	89 c3                	mov    %eax,%ebx
  8013d5:	83 c4 20             	add    $0x20,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	78 31                	js     80140d <dup+0xd1>
		goto err;

	return newfdnum;
  8013dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013df:	89 d8                	mov    %ebx,%eax
  8013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e4:	5b                   	pop    %ebx
  8013e5:	5e                   	pop    %esi
  8013e6:	5f                   	pop    %edi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f8:	50                   	push   %eax
  8013f9:	57                   	push   %edi
  8013fa:	6a 00                	push   $0x0
  8013fc:	53                   	push   %ebx
  8013fd:	6a 00                	push   $0x0
  8013ff:	e8 89 fa ff ff       	call   800e8d <sys_page_map>
  801404:	89 c3                	mov    %eax,%ebx
  801406:	83 c4 20             	add    $0x20,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	79 a3                	jns    8013b0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	56                   	push   %esi
  801411:	6a 00                	push   $0x0
  801413:	e8 b7 fa ff ff       	call   800ecf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801418:	83 c4 08             	add    $0x8,%esp
  80141b:	57                   	push   %edi
  80141c:	6a 00                	push   $0x0
  80141e:	e8 ac fa ff ff       	call   800ecf <sys_page_unmap>
	return r;
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	eb b7                	jmp    8013df <dup+0xa3>

00801428 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	83 ec 1c             	sub    $0x1c,%esp
  80142f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801432:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801435:	50                   	push   %eax
  801436:	53                   	push   %ebx
  801437:	e8 7c fd ff ff       	call   8011b8 <fd_lookup>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 3f                	js     801482 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801449:	50                   	push   %eax
  80144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144d:	ff 30                	pushl  (%eax)
  80144f:	e8 b4 fd ff ff       	call   801208 <dev_lookup>
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	78 27                	js     801482 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80145b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145e:	8b 42 08             	mov    0x8(%edx),%eax
  801461:	83 e0 03             	and    $0x3,%eax
  801464:	83 f8 01             	cmp    $0x1,%eax
  801467:	74 1e                	je     801487 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	8b 40 08             	mov    0x8(%eax),%eax
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 35                	je     8014a8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	ff 75 10             	pushl  0x10(%ebp)
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	52                   	push   %edx
  80147d:	ff d0                	call   *%eax
  80147f:	83 c4 10             	add    $0x10,%esp
}
  801482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801485:	c9                   	leave  
  801486:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801487:	a1 08 40 80 00       	mov    0x804008,%eax
  80148c:	8b 40 48             	mov    0x48(%eax),%eax
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	53                   	push   %ebx
  801493:	50                   	push   %eax
  801494:	68 f8 2a 80 00       	push   $0x802af8
  801499:	e8 5b ee ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a6:	eb da                	jmp    801482 <read+0x5a>
		return -E_NOT_SUPP;
  8014a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ad:	eb d3                	jmp    801482 <read+0x5a>

008014af <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	57                   	push   %edi
  8014b3:	56                   	push   %esi
  8014b4:	53                   	push   %ebx
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014bb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c3:	39 f3                	cmp    %esi,%ebx
  8014c5:	73 23                	jae    8014ea <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	89 f0                	mov    %esi,%eax
  8014cc:	29 d8                	sub    %ebx,%eax
  8014ce:	50                   	push   %eax
  8014cf:	89 d8                	mov    %ebx,%eax
  8014d1:	03 45 0c             	add    0xc(%ebp),%eax
  8014d4:	50                   	push   %eax
  8014d5:	57                   	push   %edi
  8014d6:	e8 4d ff ff ff       	call   801428 <read>
		if (m < 0)
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 06                	js     8014e8 <readn+0x39>
			return m;
		if (m == 0)
  8014e2:	74 06                	je     8014ea <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014e4:	01 c3                	add    %eax,%ebx
  8014e6:	eb db                	jmp    8014c3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014ea:	89 d8                	mov    %ebx,%eax
  8014ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ef:	5b                   	pop    %ebx
  8014f0:	5e                   	pop    %esi
  8014f1:	5f                   	pop    %edi
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	53                   	push   %ebx
  8014f8:	83 ec 1c             	sub    $0x1c,%esp
  8014fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801501:	50                   	push   %eax
  801502:	53                   	push   %ebx
  801503:	e8 b0 fc ff ff       	call   8011b8 <fd_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 3a                	js     801549 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	ff 30                	pushl  (%eax)
  80151b:	e8 e8 fc ff ff       	call   801208 <dev_lookup>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 22                	js     801549 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152e:	74 1e                	je     80154e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801533:	8b 52 0c             	mov    0xc(%edx),%edx
  801536:	85 d2                	test   %edx,%edx
  801538:	74 35                	je     80156f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	ff 75 10             	pushl  0x10(%ebp)
  801540:	ff 75 0c             	pushl  0xc(%ebp)
  801543:	50                   	push   %eax
  801544:	ff d2                	call   *%edx
  801546:	83 c4 10             	add    $0x10,%esp
}
  801549:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80154e:	a1 08 40 80 00       	mov    0x804008,%eax
  801553:	8b 40 48             	mov    0x48(%eax),%eax
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	53                   	push   %ebx
  80155a:	50                   	push   %eax
  80155b:	68 14 2b 80 00       	push   $0x802b14
  801560:	e8 94 ed ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156d:	eb da                	jmp    801549 <write+0x55>
		return -E_NOT_SUPP;
  80156f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801574:	eb d3                	jmp    801549 <write+0x55>

00801576 <seek>:

int
seek(int fdnum, off_t offset)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157f:	50                   	push   %eax
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	e8 30 fc ff ff       	call   8011b8 <fd_lookup>
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 0e                	js     80159d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 1c             	sub    $0x1c,%esp
  8015a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	53                   	push   %ebx
  8015ae:	e8 05 fc ff ff       	call   8011b8 <fd_lookup>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 37                	js     8015f1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c0:	50                   	push   %eax
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	ff 30                	pushl  (%eax)
  8015c6:	e8 3d fc ff ff       	call   801208 <dev_lookup>
  8015cb:	83 c4 10             	add    $0x10,%esp
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 1f                	js     8015f1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d9:	74 1b                	je     8015f6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	8b 52 18             	mov    0x18(%edx),%edx
  8015e1:	85 d2                	test   %edx,%edx
  8015e3:	74 32                	je     801617 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	ff 75 0c             	pushl  0xc(%ebp)
  8015eb:	50                   	push   %eax
  8015ec:	ff d2                	call   *%edx
  8015ee:	83 c4 10             	add    $0x10,%esp
}
  8015f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015f6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015fb:	8b 40 48             	mov    0x48(%eax),%eax
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	53                   	push   %ebx
  801602:	50                   	push   %eax
  801603:	68 d4 2a 80 00       	push   $0x802ad4
  801608:	e8 ec ec ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801615:	eb da                	jmp    8015f1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801617:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161c:	eb d3                	jmp    8015f1 <ftruncate+0x52>

0080161e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	53                   	push   %ebx
  801622:	83 ec 1c             	sub    $0x1c,%esp
  801625:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801628:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	e8 84 fb ff ff       	call   8011b8 <fd_lookup>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 4b                	js     801686 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801641:	50                   	push   %eax
  801642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801645:	ff 30                	pushl  (%eax)
  801647:	e8 bc fb ff ff       	call   801208 <dev_lookup>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	85 c0                	test   %eax,%eax
  801651:	78 33                	js     801686 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801656:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80165a:	74 2f                	je     80168b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80165c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80165f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801666:	00 00 00 
	stat->st_isdir = 0;
  801669:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801670:	00 00 00 
	stat->st_dev = dev;
  801673:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	53                   	push   %ebx
  80167d:	ff 75 f0             	pushl  -0x10(%ebp)
  801680:	ff 50 14             	call   *0x14(%eax)
  801683:	83 c4 10             	add    $0x10,%esp
}
  801686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801689:	c9                   	leave  
  80168a:	c3                   	ret    
		return -E_NOT_SUPP;
  80168b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801690:	eb f4                	jmp    801686 <fstat+0x68>

00801692 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	56                   	push   %esi
  801696:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	e8 22 02 00 00       	call   8018c6 <open>
  8016a4:	89 c3                	mov    %eax,%ebx
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	78 1b                	js     8016c8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016ad:	83 ec 08             	sub    $0x8,%esp
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	50                   	push   %eax
  8016b4:	e8 65 ff ff ff       	call   80161e <fstat>
  8016b9:	89 c6                	mov    %eax,%esi
	close(fd);
  8016bb:	89 1c 24             	mov    %ebx,(%esp)
  8016be:	e8 27 fc ff ff       	call   8012ea <close>
	return r;
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 f3                	mov    %esi,%ebx
}
  8016c8:	89 d8                	mov    %ebx,%eax
  8016ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5e                   	pop    %esi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	89 c6                	mov    %eax,%esi
  8016d8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016da:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016e1:	74 27                	je     80170a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016e3:	6a 07                	push   $0x7
  8016e5:	68 00 50 80 00       	push   $0x805000
  8016ea:	56                   	push   %esi
  8016eb:	ff 35 00 40 80 00    	pushl  0x804000
  8016f1:	e8 08 0c 00 00       	call   8022fe <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016f6:	83 c4 0c             	add    $0xc,%esp
  8016f9:	6a 00                	push   $0x0
  8016fb:	53                   	push   %ebx
  8016fc:	6a 00                	push   $0x0
  8016fe:	e8 92 0b 00 00       	call   802295 <ipc_recv>
}
  801703:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	6a 01                	push   $0x1
  80170f:	e8 42 0c 00 00       	call   802356 <ipc_find_env>
  801714:	a3 00 40 80 00       	mov    %eax,0x804000
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	eb c5                	jmp    8016e3 <fsipc+0x12>

0080171e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	8b 40 0c             	mov    0xc(%eax),%eax
  80172a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80172f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801732:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	b8 02 00 00 00       	mov    $0x2,%eax
  801741:	e8 8b ff ff ff       	call   8016d1 <fsipc>
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <devfile_flush>:
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8b 40 0c             	mov    0xc(%eax),%eax
  801754:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801759:	ba 00 00 00 00       	mov    $0x0,%edx
  80175e:	b8 06 00 00 00       	mov    $0x6,%eax
  801763:	e8 69 ff ff ff       	call   8016d1 <fsipc>
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <devfile_stat>:
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	53                   	push   %ebx
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8b 40 0c             	mov    0xc(%eax),%eax
  80177a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	b8 05 00 00 00       	mov    $0x5,%eax
  801789:	e8 43 ff ff ff       	call   8016d1 <fsipc>
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 2c                	js     8017be <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	68 00 50 80 00       	push   $0x805000
  80179a:	53                   	push   %ebx
  80179b:	e8 b8 f2 ff ff       	call   800a58 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017a0:	a1 80 50 80 00       	mov    0x805080,%eax
  8017a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ab:	a1 84 50 80 00       	mov    0x805084,%eax
  8017b0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <devfile_write>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 08             	sub    $0x8,%esp
  8017ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017d8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017de:	53                   	push   %ebx
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	68 08 50 80 00       	push   $0x805008
  8017e7:	e8 5c f4 ff ff       	call   800c48 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f6:	e8 d6 fe ff ff       	call   8016d1 <fsipc>
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 0b                	js     80180d <devfile_write+0x4a>
	assert(r <= n);
  801802:	39 d8                	cmp    %ebx,%eax
  801804:	77 0c                	ja     801812 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801806:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180b:	7f 1e                	jg     80182b <devfile_write+0x68>
}
  80180d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801810:	c9                   	leave  
  801811:	c3                   	ret    
	assert(r <= n);
  801812:	68 48 2b 80 00       	push   $0x802b48
  801817:	68 4f 2b 80 00       	push   $0x802b4f
  80181c:	68 98 00 00 00       	push   $0x98
  801821:	68 64 2b 80 00       	push   $0x802b64
  801826:	e8 d8 e9 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  80182b:	68 6f 2b 80 00       	push   $0x802b6f
  801830:	68 4f 2b 80 00       	push   $0x802b4f
  801835:	68 99 00 00 00       	push   $0x99
  80183a:	68 64 2b 80 00       	push   $0x802b64
  80183f:	e8 bf e9 ff ff       	call   800203 <_panic>

00801844 <devfile_read>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	8b 40 0c             	mov    0xc(%eax),%eax
  801852:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801857:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	b8 03 00 00 00       	mov    $0x3,%eax
  801867:	e8 65 fe ff ff       	call   8016d1 <fsipc>
  80186c:	89 c3                	mov    %eax,%ebx
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 1f                	js     801891 <devfile_read+0x4d>
	assert(r <= n);
  801872:	39 f0                	cmp    %esi,%eax
  801874:	77 24                	ja     80189a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801876:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187b:	7f 33                	jg     8018b0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	50                   	push   %eax
  801881:	68 00 50 80 00       	push   $0x805000
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	e8 58 f3 ff ff       	call   800be6 <memmove>
	return r;
  80188e:	83 c4 10             	add    $0x10,%esp
}
  801891:	89 d8                	mov    %ebx,%eax
  801893:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801896:	5b                   	pop    %ebx
  801897:	5e                   	pop    %esi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    
	assert(r <= n);
  80189a:	68 48 2b 80 00       	push   $0x802b48
  80189f:	68 4f 2b 80 00       	push   $0x802b4f
  8018a4:	6a 7c                	push   $0x7c
  8018a6:	68 64 2b 80 00       	push   $0x802b64
  8018ab:	e8 53 e9 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  8018b0:	68 6f 2b 80 00       	push   $0x802b6f
  8018b5:	68 4f 2b 80 00       	push   $0x802b4f
  8018ba:	6a 7d                	push   $0x7d
  8018bc:	68 64 2b 80 00       	push   $0x802b64
  8018c1:	e8 3d e9 ff ff       	call   800203 <_panic>

008018c6 <open>:
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 1c             	sub    $0x1c,%esp
  8018ce:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018d1:	56                   	push   %esi
  8018d2:	e8 48 f1 ff ff       	call   800a1f <strlen>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018df:	7f 6c                	jg     80194d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018e1:	83 ec 0c             	sub    $0xc,%esp
  8018e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	e8 79 f8 ff ff       	call   801166 <fd_alloc>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 3c                	js     801932 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	56                   	push   %esi
  8018fa:	68 00 50 80 00       	push   $0x805000
  8018ff:	e8 54 f1 ff ff       	call   800a58 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80190c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190f:	b8 01 00 00 00       	mov    $0x1,%eax
  801914:	e8 b8 fd ff ff       	call   8016d1 <fsipc>
  801919:	89 c3                	mov    %eax,%ebx
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 19                	js     80193b <open+0x75>
	return fd2num(fd);
  801922:	83 ec 0c             	sub    $0xc,%esp
  801925:	ff 75 f4             	pushl  -0xc(%ebp)
  801928:	e8 12 f8 ff ff       	call   80113f <fd2num>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	83 c4 10             	add    $0x10,%esp
}
  801932:	89 d8                	mov    %ebx,%eax
  801934:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    
		fd_close(fd, 0);
  80193b:	83 ec 08             	sub    $0x8,%esp
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 f4             	pushl  -0xc(%ebp)
  801943:	e8 1b f9 ff ff       	call   801263 <fd_close>
		return r;
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	eb e5                	jmp    801932 <open+0x6c>
		return -E_BAD_PATH;
  80194d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801952:	eb de                	jmp    801932 <open+0x6c>

00801954 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80195a:	ba 00 00 00 00       	mov    $0x0,%edx
  80195f:	b8 08 00 00 00       	mov    $0x8,%eax
  801964:	e8 68 fd ff ff       	call   8016d1 <fsipc>
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801971:	68 7b 2b 80 00       	push   $0x802b7b
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	e8 da f0 ff ff       	call   800a58 <strcpy>
	return 0;
}
  80197e:	b8 00 00 00 00       	mov    $0x0,%eax
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <devsock_close>:
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
  801989:	83 ec 10             	sub    $0x10,%esp
  80198c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80198f:	53                   	push   %ebx
  801990:	e8 fc 09 00 00       	call   802391 <pageref>
  801995:	83 c4 10             	add    $0x10,%esp
		return 0;
  801998:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80199d:	83 f8 01             	cmp    $0x1,%eax
  8019a0:	74 07                	je     8019a9 <devsock_close+0x24>
}
  8019a2:	89 d0                	mov    %edx,%eax
  8019a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019a9:	83 ec 0c             	sub    $0xc,%esp
  8019ac:	ff 73 0c             	pushl  0xc(%ebx)
  8019af:	e8 b9 02 00 00       	call   801c6d <nsipc_close>
  8019b4:	89 c2                	mov    %eax,%edx
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	eb e7                	jmp    8019a2 <devsock_close+0x1d>

008019bb <devsock_write>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	ff 70 0c             	pushl  0xc(%eax)
  8019cf:	e8 76 03 00 00       	call   801d4a <nsipc_send>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <devsock_read>:
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	ff 70 0c             	pushl  0xc(%eax)
  8019ea:	e8 ef 02 00 00       	call   801cde <nsipc_recv>
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <fd2sockid>:
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019fa:	52                   	push   %edx
  8019fb:	50                   	push   %eax
  8019fc:	e8 b7 f7 ff ff       	call   8011b8 <fd_lookup>
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 10                	js     801a18 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0b:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a11:	39 08                	cmp    %ecx,(%eax)
  801a13:	75 05                	jne    801a1a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a15:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    
		return -E_NOT_SUPP;
  801a1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1f:	eb f7                	jmp    801a18 <fd2sockid+0x27>

00801a21 <alloc_sockfd>:
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	56                   	push   %esi
  801a25:	53                   	push   %ebx
  801a26:	83 ec 1c             	sub    $0x1c,%esp
  801a29:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2e:	50                   	push   %eax
  801a2f:	e8 32 f7 ff ff       	call   801166 <fd_alloc>
  801a34:	89 c3                	mov    %eax,%ebx
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	85 c0                	test   %eax,%eax
  801a3b:	78 43                	js     801a80 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 07 04 00 00       	push   $0x407
  801a45:	ff 75 f4             	pushl  -0xc(%ebp)
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 fb f3 ff ff       	call   800e4a <sys_page_alloc>
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 28                	js     801a80 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a61:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a66:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a6d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a70:	83 ec 0c             	sub    $0xc,%esp
  801a73:	50                   	push   %eax
  801a74:	e8 c6 f6 ff ff       	call   80113f <fd2num>
  801a79:	89 c3                	mov    %eax,%ebx
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	eb 0c                	jmp    801a8c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a80:	83 ec 0c             	sub    $0xc,%esp
  801a83:	56                   	push   %esi
  801a84:	e8 e4 01 00 00       	call   801c6d <nsipc_close>
		return r;
  801a89:	83 c4 10             	add    $0x10,%esp
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <accept>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	e8 4e ff ff ff       	call   8019f1 <fd2sockid>
  801aa3:	85 c0                	test   %eax,%eax
  801aa5:	78 1b                	js     801ac2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	e8 0e 01 00 00       	call   801bc4 <nsipc_accept>
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	78 05                	js     801ac2 <accept+0x2d>
	return alloc_sockfd(r);
  801abd:	e8 5f ff ff ff       	call   801a21 <alloc_sockfd>
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <bind>:
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	e8 1f ff ff ff       	call   8019f1 <fd2sockid>
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	78 12                	js     801ae8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	ff 75 10             	pushl  0x10(%ebp)
  801adc:	ff 75 0c             	pushl  0xc(%ebp)
  801adf:	50                   	push   %eax
  801ae0:	e8 31 01 00 00       	call   801c16 <nsipc_bind>
  801ae5:	83 c4 10             	add    $0x10,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <shutdown>:
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	e8 f9 fe ff ff       	call   8019f1 <fd2sockid>
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 0f                	js     801b0b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	e8 43 01 00 00       	call   801c4b <nsipc_shutdown>
  801b08:	83 c4 10             	add    $0x10,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <connect>:
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	e8 d6 fe ff ff       	call   8019f1 <fd2sockid>
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 12                	js     801b31 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	50                   	push   %eax
  801b29:	e8 59 01 00 00       	call   801c87 <nsipc_connect>
  801b2e:	83 c4 10             	add    $0x10,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <listen>:
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	e8 b0 fe ff ff       	call   8019f1 <fd2sockid>
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 0f                	js     801b54 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	e8 6b 01 00 00       	call   801cbc <nsipc_listen>
  801b51:	83 c4 10             	add    $0x10,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b5c:	ff 75 10             	pushl  0x10(%ebp)
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	e8 3e 02 00 00       	call   801da8 <nsipc_socket>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 05                	js     801b76 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b71:	e8 ab fe ff ff       	call   801a21 <alloc_sockfd>
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b81:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b88:	74 26                	je     801bb0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b8a:	6a 07                	push   $0x7
  801b8c:	68 00 60 80 00       	push   $0x806000
  801b91:	53                   	push   %ebx
  801b92:	ff 35 04 40 80 00    	pushl  0x804004
  801b98:	e8 61 07 00 00       	call   8022fe <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b9d:	83 c4 0c             	add    $0xc,%esp
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	e8 ea 06 00 00       	call   802295 <ipc_recv>
}
  801bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bb0:	83 ec 0c             	sub    $0xc,%esp
  801bb3:	6a 02                	push   $0x2
  801bb5:	e8 9c 07 00 00       	call   802356 <ipc_find_env>
  801bba:	a3 04 40 80 00       	mov    %eax,0x804004
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	eb c6                	jmp    801b8a <nsipc+0x12>

00801bc4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	56                   	push   %esi
  801bc8:	53                   	push   %ebx
  801bc9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bd4:	8b 06                	mov    (%esi),%eax
  801bd6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801be0:	e8 93 ff ff ff       	call   801b78 <nsipc>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	85 c0                	test   %eax,%eax
  801be9:	79 09                	jns    801bf4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	ff 35 10 60 80 00    	pushl  0x806010
  801bfd:	68 00 60 80 00       	push   $0x806000
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	e8 dc ef ff ff       	call   800be6 <memmove>
		*addrlen = ret->ret_addrlen;
  801c0a:	a1 10 60 80 00       	mov    0x806010,%eax
  801c0f:	89 06                	mov    %eax,(%esi)
  801c11:	83 c4 10             	add    $0x10,%esp
	return r;
  801c14:	eb d5                	jmp    801beb <nsipc_accept+0x27>

00801c16 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 08             	sub    $0x8,%esp
  801c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c28:	53                   	push   %ebx
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	68 04 60 80 00       	push   $0x806004
  801c31:	e8 b0 ef ff ff       	call   800be6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c36:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c3c:	b8 02 00 00 00       	mov    $0x2,%eax
  801c41:	e8 32 ff ff ff       	call   801b78 <nsipc>
}
  801c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c61:	b8 03 00 00 00       	mov    $0x3,%eax
  801c66:	e8 0d ff ff ff       	call   801b78 <nsipc>
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <nsipc_close>:

int
nsipc_close(int s)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c7b:	b8 04 00 00 00       	mov    $0x4,%eax
  801c80:	e8 f3 fe ff ff       	call   801b78 <nsipc>
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c99:	53                   	push   %ebx
  801c9a:	ff 75 0c             	pushl  0xc(%ebp)
  801c9d:	68 04 60 80 00       	push   $0x806004
  801ca2:	e8 3f ef ff ff       	call   800be6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ca7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cad:	b8 05 00 00 00       	mov    $0x5,%eax
  801cb2:	e8 c1 fe ff ff       	call   801b78 <nsipc>
}
  801cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cd2:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd7:	e8 9c fe ff ff       	call   801b78 <nsipc>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
  801ce3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cee:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cfc:	b8 07 00 00 00       	mov    $0x7,%eax
  801d01:	e8 72 fe ff ff       	call   801b78 <nsipc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 1f                	js     801d2b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d0c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d11:	7f 21                	jg     801d34 <nsipc_recv+0x56>
  801d13:	39 c6                	cmp    %eax,%esi
  801d15:	7c 1d                	jl     801d34 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	50                   	push   %eax
  801d1b:	68 00 60 80 00       	push   $0x806000
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	e8 be ee ff ff       	call   800be6 <memmove>
  801d28:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d2b:	89 d8                	mov    %ebx,%eax
  801d2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5d                   	pop    %ebp
  801d33:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d34:	68 87 2b 80 00       	push   $0x802b87
  801d39:	68 4f 2b 80 00       	push   $0x802b4f
  801d3e:	6a 62                	push   $0x62
  801d40:	68 9c 2b 80 00       	push   $0x802b9c
  801d45:	e8 b9 e4 ff ff       	call   800203 <_panic>

00801d4a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	53                   	push   %ebx
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d5c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d62:	7f 2e                	jg     801d92 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	53                   	push   %ebx
  801d68:	ff 75 0c             	pushl  0xc(%ebp)
  801d6b:	68 0c 60 80 00       	push   $0x80600c
  801d70:	e8 71 ee ff ff       	call   800be6 <memmove>
	nsipcbuf.send.req_size = size;
  801d75:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d83:	b8 08 00 00 00       	mov    $0x8,%eax
  801d88:	e8 eb fd ff ff       	call   801b78 <nsipc>
}
  801d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    
	assert(size < 1600);
  801d92:	68 a8 2b 80 00       	push   $0x802ba8
  801d97:	68 4f 2b 80 00       	push   $0x802b4f
  801d9c:	6a 6d                	push   $0x6d
  801d9e:	68 9c 2b 80 00       	push   $0x802b9c
  801da3:	e8 5b e4 ff ff       	call   800203 <_panic>

00801da8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dc6:	b8 09 00 00 00       	mov    $0x9,%eax
  801dcb:	e8 a8 fd ff ff       	call   801b78 <nsipc>
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	56                   	push   %esi
  801dd6:	53                   	push   %ebx
  801dd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 6a f3 ff ff       	call   80114f <fd2data>
  801de5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801de7:	83 c4 08             	add    $0x8,%esp
  801dea:	68 b4 2b 80 00       	push   $0x802bb4
  801def:	53                   	push   %ebx
  801df0:	e8 63 ec ff ff       	call   800a58 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801df5:	8b 46 04             	mov    0x4(%esi),%eax
  801df8:	2b 06                	sub    (%esi),%eax
  801dfa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e00:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e07:	00 00 00 
	stat->st_dev = &devpipe;
  801e0a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e11:	30 80 00 
	return 0;
}
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
  801e19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5d                   	pop    %ebp
  801e1f:	c3                   	ret    

00801e20 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	53                   	push   %ebx
  801e24:	83 ec 0c             	sub    $0xc,%esp
  801e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e2a:	53                   	push   %ebx
  801e2b:	6a 00                	push   $0x0
  801e2d:	e8 9d f0 ff ff       	call   800ecf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e32:	89 1c 24             	mov    %ebx,(%esp)
  801e35:	e8 15 f3 ff ff       	call   80114f <fd2data>
  801e3a:	83 c4 08             	add    $0x8,%esp
  801e3d:	50                   	push   %eax
  801e3e:	6a 00                	push   $0x0
  801e40:	e8 8a f0 ff ff       	call   800ecf <sys_page_unmap>
}
  801e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <_pipeisclosed>:
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	57                   	push   %edi
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 1c             	sub    $0x1c,%esp
  801e53:	89 c7                	mov    %eax,%edi
  801e55:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e57:	a1 08 40 80 00       	mov    0x804008,%eax
  801e5c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	57                   	push   %edi
  801e63:	e8 29 05 00 00       	call   802391 <pageref>
  801e68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e6b:	89 34 24             	mov    %esi,(%esp)
  801e6e:	e8 1e 05 00 00       	call   802391 <pageref>
		nn = thisenv->env_runs;
  801e73:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e79:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	39 cb                	cmp    %ecx,%ebx
  801e81:	74 1b                	je     801e9e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e83:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e86:	75 cf                	jne    801e57 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e88:	8b 42 58             	mov    0x58(%edx),%eax
  801e8b:	6a 01                	push   $0x1
  801e8d:	50                   	push   %eax
  801e8e:	53                   	push   %ebx
  801e8f:	68 bb 2b 80 00       	push   $0x802bbb
  801e94:	e8 60 e4 ff ff       	call   8002f9 <cprintf>
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	eb b9                	jmp    801e57 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e9e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ea1:	0f 94 c0             	sete   %al
  801ea4:	0f b6 c0             	movzbl %al,%eax
}
  801ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eaa:	5b                   	pop    %ebx
  801eab:	5e                   	pop    %esi
  801eac:	5f                   	pop    %edi
  801ead:	5d                   	pop    %ebp
  801eae:	c3                   	ret    

00801eaf <devpipe_write>:
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	57                   	push   %edi
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	83 ec 28             	sub    $0x28,%esp
  801eb8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ebb:	56                   	push   %esi
  801ebc:	e8 8e f2 ff ff       	call   80114f <fd2data>
  801ec1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ece:	74 4f                	je     801f1f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ed0:	8b 43 04             	mov    0x4(%ebx),%eax
  801ed3:	8b 0b                	mov    (%ebx),%ecx
  801ed5:	8d 51 20             	lea    0x20(%ecx),%edx
  801ed8:	39 d0                	cmp    %edx,%eax
  801eda:	72 14                	jb     801ef0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801edc:	89 da                	mov    %ebx,%edx
  801ede:	89 f0                	mov    %esi,%eax
  801ee0:	e8 65 ff ff ff       	call   801e4a <_pipeisclosed>
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	75 3b                	jne    801f24 <devpipe_write+0x75>
			sys_yield();
  801ee9:	e8 3d ef ff ff       	call   800e2b <sys_yield>
  801eee:	eb e0                	jmp    801ed0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ef7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801efa:	89 c2                	mov    %eax,%edx
  801efc:	c1 fa 1f             	sar    $0x1f,%edx
  801eff:	89 d1                	mov    %edx,%ecx
  801f01:	c1 e9 1b             	shr    $0x1b,%ecx
  801f04:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f07:	83 e2 1f             	and    $0x1f,%edx
  801f0a:	29 ca                	sub    %ecx,%edx
  801f0c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f10:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f14:	83 c0 01             	add    $0x1,%eax
  801f17:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f1a:	83 c7 01             	add    $0x1,%edi
  801f1d:	eb ac                	jmp    801ecb <devpipe_write+0x1c>
	return i;
  801f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f22:	eb 05                	jmp    801f29 <devpipe_write+0x7a>
				return 0;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <devpipe_read>:
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 18             	sub    $0x18,%esp
  801f3a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f3d:	57                   	push   %edi
  801f3e:	e8 0c f2 ff ff       	call   80114f <fd2data>
  801f43:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	be 00 00 00 00       	mov    $0x0,%esi
  801f4d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f50:	75 14                	jne    801f66 <devpipe_read+0x35>
	return i;
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	eb 02                	jmp    801f59 <devpipe_read+0x28>
				return i;
  801f57:	89 f0                	mov    %esi,%eax
}
  801f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5f                   	pop    %edi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    
			sys_yield();
  801f61:	e8 c5 ee ff ff       	call   800e2b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f66:	8b 03                	mov    (%ebx),%eax
  801f68:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6b:	75 18                	jne    801f85 <devpipe_read+0x54>
			if (i > 0)
  801f6d:	85 f6                	test   %esi,%esi
  801f6f:	75 e6                	jne    801f57 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f71:	89 da                	mov    %ebx,%edx
  801f73:	89 f8                	mov    %edi,%eax
  801f75:	e8 d0 fe ff ff       	call   801e4a <_pipeisclosed>
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	74 e3                	je     801f61 <devpipe_read+0x30>
				return 0;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	eb d4                	jmp    801f59 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f85:	99                   	cltd   
  801f86:	c1 ea 1b             	shr    $0x1b,%edx
  801f89:	01 d0                	add    %edx,%eax
  801f8b:	83 e0 1f             	and    $0x1f,%eax
  801f8e:	29 d0                	sub    %edx,%eax
  801f90:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f98:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f9b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f9e:	83 c6 01             	add    $0x1,%esi
  801fa1:	eb aa                	jmp    801f4d <devpipe_read+0x1c>

00801fa3 <pipe>:
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fae:	50                   	push   %eax
  801faf:	e8 b2 f1 ff ff       	call   801166 <fd_alloc>
  801fb4:	89 c3                	mov    %eax,%ebx
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	0f 88 23 01 00 00    	js     8020e4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	68 07 04 00 00       	push   $0x407
  801fc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcc:	6a 00                	push   $0x0
  801fce:	e8 77 ee ff ff       	call   800e4a <sys_page_alloc>
  801fd3:	89 c3                	mov    %eax,%ebx
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 04 01 00 00    	js     8020e4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fe6:	50                   	push   %eax
  801fe7:	e8 7a f1 ff ff       	call   801166 <fd_alloc>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	0f 88 db 00 00 00    	js     8020d4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	68 07 04 00 00       	push   $0x407
  802001:	ff 75 f0             	pushl  -0x10(%ebp)
  802004:	6a 00                	push   $0x0
  802006:	e8 3f ee ff ff       	call   800e4a <sys_page_alloc>
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	85 c0                	test   %eax,%eax
  802012:	0f 88 bc 00 00 00    	js     8020d4 <pipe+0x131>
	va = fd2data(fd0);
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 f4             	pushl  -0xc(%ebp)
  80201e:	e8 2c f1 ff ff       	call   80114f <fd2data>
  802023:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802025:	83 c4 0c             	add    $0xc,%esp
  802028:	68 07 04 00 00       	push   $0x407
  80202d:	50                   	push   %eax
  80202e:	6a 00                	push   $0x0
  802030:	e8 15 ee ff ff       	call   800e4a <sys_page_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	0f 88 82 00 00 00    	js     8020c4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	ff 75 f0             	pushl  -0x10(%ebp)
  802048:	e8 02 f1 ff ff       	call   80114f <fd2data>
  80204d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802054:	50                   	push   %eax
  802055:	6a 00                	push   $0x0
  802057:	56                   	push   %esi
  802058:	6a 00                	push   $0x0
  80205a:	e8 2e ee ff ff       	call   800e8d <sys_page_map>
  80205f:	89 c3                	mov    %eax,%ebx
  802061:	83 c4 20             	add    $0x20,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	78 4e                	js     8020b6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802068:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80206d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802070:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80207c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80207f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	ff 75 f4             	pushl  -0xc(%ebp)
  802091:	e8 a9 f0 ff ff       	call   80113f <fd2num>
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802099:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80209b:	83 c4 04             	add    $0x4,%esp
  80209e:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a1:	e8 99 f0 ff ff       	call   80113f <fd2num>
  8020a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020b4:	eb 2e                	jmp    8020e4 <pipe+0x141>
	sys_page_unmap(0, va);
  8020b6:	83 ec 08             	sub    $0x8,%esp
  8020b9:	56                   	push   %esi
  8020ba:	6a 00                	push   $0x0
  8020bc:	e8 0e ee ff ff       	call   800ecf <sys_page_unmap>
  8020c1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020c4:	83 ec 08             	sub    $0x8,%esp
  8020c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ca:	6a 00                	push   $0x0
  8020cc:	e8 fe ed ff ff       	call   800ecf <sys_page_unmap>
  8020d1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020d4:	83 ec 08             	sub    $0x8,%esp
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	6a 00                	push   $0x0
  8020dc:	e8 ee ed ff ff       	call   800ecf <sys_page_unmap>
  8020e1:	83 c4 10             	add    $0x10,%esp
}
  8020e4:	89 d8                	mov    %ebx,%eax
  8020e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5e                   	pop    %esi
  8020eb:	5d                   	pop    %ebp
  8020ec:	c3                   	ret    

008020ed <pipeisclosed>:
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f6:	50                   	push   %eax
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	e8 b9 f0 ff ff       	call   8011b8 <fd_lookup>
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	85 c0                	test   %eax,%eax
  802104:	78 18                	js     80211e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	ff 75 f4             	pushl  -0xc(%ebp)
  80210c:	e8 3e f0 ff ff       	call   80114f <fd2data>
	return _pipeisclosed(fd, p);
  802111:	89 c2                	mov    %eax,%edx
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	e8 2f fd ff ff       	call   801e4a <_pipeisclosed>
  80211b:	83 c4 10             	add    $0x10,%esp
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
  802125:	c3                   	ret    

00802126 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80212c:	68 d3 2b 80 00       	push   $0x802bd3
  802131:	ff 75 0c             	pushl  0xc(%ebp)
  802134:	e8 1f e9 ff ff       	call   800a58 <strcpy>
	return 0;
}
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <devcons_write>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	57                   	push   %edi
  802144:	56                   	push   %esi
  802145:	53                   	push   %ebx
  802146:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80214c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802151:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802157:	3b 75 10             	cmp    0x10(%ebp),%esi
  80215a:	73 31                	jae    80218d <devcons_write+0x4d>
		m = n - tot;
  80215c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80215f:	29 f3                	sub    %esi,%ebx
  802161:	83 fb 7f             	cmp    $0x7f,%ebx
  802164:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802169:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	53                   	push   %ebx
  802170:	89 f0                	mov    %esi,%eax
  802172:	03 45 0c             	add    0xc(%ebp),%eax
  802175:	50                   	push   %eax
  802176:	57                   	push   %edi
  802177:	e8 6a ea ff ff       	call   800be6 <memmove>
		sys_cputs(buf, m);
  80217c:	83 c4 08             	add    $0x8,%esp
  80217f:	53                   	push   %ebx
  802180:	57                   	push   %edi
  802181:	e8 08 ec ff ff       	call   800d8e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802186:	01 de                	add    %ebx,%esi
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	eb ca                	jmp    802157 <devcons_write+0x17>
}
  80218d:	89 f0                	mov    %esi,%eax
  80218f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802192:	5b                   	pop    %ebx
  802193:	5e                   	pop    %esi
  802194:	5f                   	pop    %edi
  802195:	5d                   	pop    %ebp
  802196:	c3                   	ret    

00802197 <devcons_read>:
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 08             	sub    $0x8,%esp
  80219d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a6:	74 21                	je     8021c9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021a8:	e8 ff eb ff ff       	call   800dac <sys_cgetc>
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	75 07                	jne    8021b8 <devcons_read+0x21>
		sys_yield();
  8021b1:	e8 75 ec ff ff       	call   800e2b <sys_yield>
  8021b6:	eb f0                	jmp    8021a8 <devcons_read+0x11>
	if (c < 0)
  8021b8:	78 0f                	js     8021c9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021ba:	83 f8 04             	cmp    $0x4,%eax
  8021bd:	74 0c                	je     8021cb <devcons_read+0x34>
	*(char*)vbuf = c;
  8021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c2:	88 02                	mov    %al,(%edx)
	return 1;
  8021c4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    
		return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d0:	eb f7                	jmp    8021c9 <devcons_read+0x32>

008021d2 <cputchar>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021de:	6a 01                	push   $0x1
  8021e0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e3:	50                   	push   %eax
  8021e4:	e8 a5 eb ff ff       	call   800d8e <sys_cputs>
}
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <getchar>:
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021f4:	6a 01                	push   $0x1
  8021f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f9:	50                   	push   %eax
  8021fa:	6a 00                	push   $0x0
  8021fc:	e8 27 f2 ff ff       	call   801428 <read>
	if (r < 0)
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	85 c0                	test   %eax,%eax
  802206:	78 06                	js     80220e <getchar+0x20>
	if (r < 1)
  802208:	74 06                	je     802210 <getchar+0x22>
	return c;
  80220a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    
		return -E_EOF;
  802210:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802215:	eb f7                	jmp    80220e <getchar+0x20>

00802217 <iscons>:
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80221d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802220:	50                   	push   %eax
  802221:	ff 75 08             	pushl  0x8(%ebp)
  802224:	e8 8f ef ff ff       	call   8011b8 <fd_lookup>
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 11                	js     802241 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802239:	39 10                	cmp    %edx,(%eax)
  80223b:	0f 94 c0             	sete   %al
  80223e:	0f b6 c0             	movzbl %al,%eax
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <opencons>:
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802249:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224c:	50                   	push   %eax
  80224d:	e8 14 ef ff ff       	call   801166 <fd_alloc>
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	85 c0                	test   %eax,%eax
  802257:	78 3a                	js     802293 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 07 04 00 00       	push   $0x407
  802261:	ff 75 f4             	pushl  -0xc(%ebp)
  802264:	6a 00                	push   $0x0
  802266:	e8 df eb ff ff       	call   800e4a <sys_page_alloc>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 21                	js     802293 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80227b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802287:	83 ec 0c             	sub    $0xc,%esp
  80228a:	50                   	push   %eax
  80228b:	e8 af ee ff ff       	call   80113f <fd2num>
  802290:	83 c4 10             	add    $0x10,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	56                   	push   %esi
  802299:	53                   	push   %ebx
  80229a:	8b 75 08             	mov    0x8(%ebp),%esi
  80229d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022a3:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022a5:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022aa:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	50                   	push   %eax
  8022b1:	e8 44 ed ff ff       	call   800ffa <sys_ipc_recv>
	if(ret < 0){
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	78 2b                	js     8022e8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022bd:	85 f6                	test   %esi,%esi
  8022bf:	74 0a                	je     8022cb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c6:	8b 40 74             	mov    0x74(%eax),%eax
  8022c9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022cb:	85 db                	test   %ebx,%ebx
  8022cd:	74 0a                	je     8022d9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d4:	8b 40 78             	mov    0x78(%eax),%eax
  8022d7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022de:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    
		if(from_env_store)
  8022e8:	85 f6                	test   %esi,%esi
  8022ea:	74 06                	je     8022f2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022ec:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022f2:	85 db                	test   %ebx,%ebx
  8022f4:	74 eb                	je     8022e1 <ipc_recv+0x4c>
			*perm_store = 0;
  8022f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022fc:	eb e3                	jmp    8022e1 <ipc_recv+0x4c>

008022fe <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	57                   	push   %edi
  802302:	56                   	push   %esi
  802303:	53                   	push   %ebx
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	8b 7d 08             	mov    0x8(%ebp),%edi
  80230a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80230d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802310:	85 db                	test   %ebx,%ebx
  802312:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802317:	0f 44 d8             	cmove  %eax,%ebx
  80231a:	eb 05                	jmp    802321 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80231c:	e8 0a eb ff ff       	call   800e2b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802321:	ff 75 14             	pushl  0x14(%ebp)
  802324:	53                   	push   %ebx
  802325:	56                   	push   %esi
  802326:	57                   	push   %edi
  802327:	e8 ab ec ff ff       	call   800fd7 <sys_ipc_try_send>
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	85 c0                	test   %eax,%eax
  802331:	74 1b                	je     80234e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802333:	79 e7                	jns    80231c <ipc_send+0x1e>
  802335:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802338:	74 e2                	je     80231c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 df 2b 80 00       	push   $0x802bdf
  802342:	6a 46                	push   $0x46
  802344:	68 f4 2b 80 00       	push   $0x802bf4
  802349:	e8 b5 de ff ff       	call   800203 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80234e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802351:	5b                   	pop    %ebx
  802352:	5e                   	pop    %esi
  802353:	5f                   	pop    %edi
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80235c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802361:	89 c2                	mov    %eax,%edx
  802363:	c1 e2 07             	shl    $0x7,%edx
  802366:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80236c:	8b 52 50             	mov    0x50(%edx),%edx
  80236f:	39 ca                	cmp    %ecx,%edx
  802371:	74 11                	je     802384 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802373:	83 c0 01             	add    $0x1,%eax
  802376:	3d 00 04 00 00       	cmp    $0x400,%eax
  80237b:	75 e4                	jne    802361 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	eb 0b                	jmp    80238f <ipc_find_env+0x39>
			return envs[i].env_id;
  802384:	c1 e0 07             	shl    $0x7,%eax
  802387:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80238c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    

00802391 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802397:	89 d0                	mov    %edx,%eax
  802399:	c1 e8 16             	shr    $0x16,%eax
  80239c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023a3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023a8:	f6 c1 01             	test   $0x1,%cl
  8023ab:	74 1d                	je     8023ca <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023ad:	c1 ea 0c             	shr    $0xc,%edx
  8023b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023b7:	f6 c2 01             	test   $0x1,%dl
  8023ba:	74 0e                	je     8023ca <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023bc:	c1 ea 0c             	shr    $0xc,%edx
  8023bf:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023c6:	ef 
  8023c7:	0f b7 c0             	movzwl %ax,%eax
}
  8023ca:	5d                   	pop    %ebp
  8023cb:	c3                   	ret    
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	75 4d                	jne    802438 <__udivdi3+0x68>
  8023eb:	39 f3                	cmp    %esi,%ebx
  8023ed:	76 19                	jbe    802408 <__udivdi3+0x38>
  8023ef:	31 ff                	xor    %edi,%edi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 d9                	mov    %ebx,%ecx
  80240a:	85 db                	test   %ebx,%ebx
  80240c:	75 0b                	jne    802419 <__udivdi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f3                	div    %ebx
  802417:	89 c1                	mov    %eax,%ecx
  802419:	31 d2                	xor    %edx,%edx
  80241b:	89 f0                	mov    %esi,%eax
  80241d:	f7 f1                	div    %ecx
  80241f:	89 c6                	mov    %eax,%esi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f7                	mov    %esi,%edi
  802425:	f7 f1                	div    %ecx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	39 f2                	cmp    %esi,%edx
  80243a:	77 1c                	ja     802458 <__udivdi3+0x88>
  80243c:	0f bd fa             	bsr    %edx,%edi
  80243f:	83 f7 1f             	xor    $0x1f,%edi
  802442:	75 2c                	jne    802470 <__udivdi3+0xa0>
  802444:	39 f2                	cmp    %esi,%edx
  802446:	72 06                	jb     80244e <__udivdi3+0x7e>
  802448:	31 c0                	xor    %eax,%eax
  80244a:	39 eb                	cmp    %ebp,%ebx
  80244c:	77 a9                	ja     8023f7 <__udivdi3+0x27>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb a2                	jmp    8023f7 <__udivdi3+0x27>
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	31 ff                	xor    %edi,%edi
  80245a:	31 c0                	xor    %eax,%eax
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	89 f9                	mov    %edi,%ecx
  802472:	b8 20 00 00 00       	mov    $0x20,%eax
  802477:	29 f8                	sub    %edi,%eax
  802479:	d3 e2                	shl    %cl,%edx
  80247b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80247f:	89 c1                	mov    %eax,%ecx
  802481:	89 da                	mov    %ebx,%edx
  802483:	d3 ea                	shr    %cl,%edx
  802485:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802489:	09 d1                	or     %edx,%ecx
  80248b:	89 f2                	mov    %esi,%edx
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 f9                	mov    %edi,%ecx
  802493:	d3 e3                	shl    %cl,%ebx
  802495:	89 c1                	mov    %eax,%ecx
  802497:	d3 ea                	shr    %cl,%edx
  802499:	89 f9                	mov    %edi,%ecx
  80249b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80249f:	89 eb                	mov    %ebp,%ebx
  8024a1:	d3 e6                	shl    %cl,%esi
  8024a3:	89 c1                	mov    %eax,%ecx
  8024a5:	d3 eb                	shr    %cl,%ebx
  8024a7:	09 de                	or     %ebx,%esi
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	f7 74 24 08          	divl   0x8(%esp)
  8024af:	89 d6                	mov    %edx,%esi
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	f7 64 24 0c          	mull   0xc(%esp)
  8024b7:	39 d6                	cmp    %edx,%esi
  8024b9:	72 15                	jb     8024d0 <__udivdi3+0x100>
  8024bb:	89 f9                	mov    %edi,%ecx
  8024bd:	d3 e5                	shl    %cl,%ebp
  8024bf:	39 c5                	cmp    %eax,%ebp
  8024c1:	73 04                	jae    8024c7 <__udivdi3+0xf7>
  8024c3:	39 d6                	cmp    %edx,%esi
  8024c5:	74 09                	je     8024d0 <__udivdi3+0x100>
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	31 ff                	xor    %edi,%edi
  8024cb:	e9 27 ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024d3:	31 ff                	xor    %edi,%edi
  8024d5:	e9 1d ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024f7:	89 da                	mov    %ebx,%edx
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	75 43                	jne    802540 <__umoddi3+0x60>
  8024fd:	39 df                	cmp    %ebx,%edi
  8024ff:	76 17                	jbe    802518 <__umoddi3+0x38>
  802501:	89 f0                	mov    %esi,%eax
  802503:	f7 f7                	div    %edi
  802505:	89 d0                	mov    %edx,%eax
  802507:	31 d2                	xor    %edx,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 fd                	mov    %edi,%ebp
  80251a:	85 ff                	test   %edi,%edi
  80251c:	75 0b                	jne    802529 <__umoddi3+0x49>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f7                	div    %edi
  802527:	89 c5                	mov    %eax,%ebp
  802529:	89 d8                	mov    %ebx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f5                	div    %ebp
  80252f:	89 f0                	mov    %esi,%eax
  802531:	f7 f5                	div    %ebp
  802533:	89 d0                	mov    %edx,%eax
  802535:	eb d0                	jmp    802507 <__umoddi3+0x27>
  802537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253e:	66 90                	xchg   %ax,%ax
  802540:	89 f1                	mov    %esi,%ecx
  802542:	39 d8                	cmp    %ebx,%eax
  802544:	76 0a                	jbe    802550 <__umoddi3+0x70>
  802546:	89 f0                	mov    %esi,%eax
  802548:	83 c4 1c             	add    $0x1c,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5e                   	pop    %esi
  80254d:	5f                   	pop    %edi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
  802550:	0f bd e8             	bsr    %eax,%ebp
  802553:	83 f5 1f             	xor    $0x1f,%ebp
  802556:	75 20                	jne    802578 <__umoddi3+0x98>
  802558:	39 d8                	cmp    %ebx,%eax
  80255a:	0f 82 b0 00 00 00    	jb     802610 <__umoddi3+0x130>
  802560:	39 f7                	cmp    %esi,%edi
  802562:	0f 86 a8 00 00 00    	jbe    802610 <__umoddi3+0x130>
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	ba 20 00 00 00       	mov    $0x20,%edx
  80257f:	29 ea                	sub    %ebp,%edx
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 44 24 08          	mov    %eax,0x8(%esp)
  802587:	89 d1                	mov    %edx,%ecx
  802589:	89 f8                	mov    %edi,%eax
  80258b:	d3 e8                	shr    %cl,%eax
  80258d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802591:	89 54 24 04          	mov    %edx,0x4(%esp)
  802595:	8b 54 24 04          	mov    0x4(%esp),%edx
  802599:	09 c1                	or     %eax,%ecx
  80259b:	89 d8                	mov    %ebx,%eax
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 e9                	mov    %ebp,%ecx
  8025a3:	d3 e7                	shl    %cl,%edi
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	d3 e3                	shl    %cl,%ebx
  8025b1:	89 c7                	mov    %eax,%edi
  8025b3:	89 d1                	mov    %edx,%ecx
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 fa                	mov    %edi,%edx
  8025bd:	d3 e6                	shl    %cl,%esi
  8025bf:	09 d8                	or     %ebx,%eax
  8025c1:	f7 74 24 08          	divl   0x8(%esp)
  8025c5:	89 d1                	mov    %edx,%ecx
  8025c7:	89 f3                	mov    %esi,%ebx
  8025c9:	f7 64 24 0c          	mull   0xc(%esp)
  8025cd:	89 c6                	mov    %eax,%esi
  8025cf:	89 d7                	mov    %edx,%edi
  8025d1:	39 d1                	cmp    %edx,%ecx
  8025d3:	72 06                	jb     8025db <__umoddi3+0xfb>
  8025d5:	75 10                	jne    8025e7 <__umoddi3+0x107>
  8025d7:	39 c3                	cmp    %eax,%ebx
  8025d9:	73 0c                	jae    8025e7 <__umoddi3+0x107>
  8025db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025e3:	89 d7                	mov    %edx,%edi
  8025e5:	89 c6                	mov    %eax,%esi
  8025e7:	89 ca                	mov    %ecx,%edx
  8025e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ee:	29 f3                	sub    %esi,%ebx
  8025f0:	19 fa                	sbb    %edi,%edx
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	d3 e0                	shl    %cl,%eax
  8025f6:	89 e9                	mov    %ebp,%ecx
  8025f8:	d3 eb                	shr    %cl,%ebx
  8025fa:	d3 ea                	shr    %cl,%edx
  8025fc:	09 d8                	or     %ebx,%eax
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80260d:	8d 76 00             	lea    0x0(%esi),%esi
  802610:	89 da                	mov    %ebx,%edx
  802612:	29 fe                	sub    %edi,%esi
  802614:	19 c2                	sbb    %eax,%edx
  802616:	89 f1                	mov    %esi,%ecx
  802618:	89 c8                	mov    %ecx,%eax
  80261a:	e9 4b ff ff ff       	jmp    80256a <__umoddi3+0x8a>
