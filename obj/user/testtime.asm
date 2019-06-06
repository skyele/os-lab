
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
  800066:	68 00 26 80 00       	push   $0x802600
  80006b:	6a 0b                	push   $0xb
  80006d:	68 12 26 80 00       	push   $0x802612
  800072:	e8 8c 01 00 00       	call   800203 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 22 26 80 00       	push   $0x802622
  80007f:	6a 0d                	push   $0xd
  800081:	68 12 26 80 00       	push   $0x802612
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
  8000a9:	68 2e 26 80 00       	push   $0x80262e
  8000ae:	e8 46 02 00 00       	call   8002f9 <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 44 26 80 00       	push   $0x802644
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
  8000e3:	68 64 26 80 00       	push   $0x802664
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
  800179:	68 48 26 80 00       	push   $0x802648
  80017e:	e8 76 01 00 00       	call   8002f9 <cprintf>
	cprintf("before umain\n");
  800183:	c7 04 24 66 26 80 00 	movl   $0x802666,(%esp)
  80018a:	e8 6a 01 00 00       	call   8002f9 <cprintf>
	// call user main routine
	umain(argc, argv);
  80018f:	83 c4 08             	add    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 f3 fe ff ff       	call   800090 <umain>
	cprintf("after umain\n");
  80019d:	c7 04 24 74 26 80 00 	movl   $0x802674,(%esp)
  8001a4:	e8 50 01 00 00       	call   8002f9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	50                   	push   %eax
  8001b5:	68 81 26 80 00       	push   $0x802681
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
  8001dd:	68 ac 26 80 00       	push   $0x8026ac
  8001e2:	50                   	push   %eax
  8001e3:	68 a0 26 80 00       	push   $0x8026a0
  8001e8:	e8 0c 01 00 00       	call   8002f9 <cprintf>
	close_all();
  8001ed:	e8 05 11 00 00       	call   8012f7 <close_all>
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
  800213:	68 d8 26 80 00       	push   $0x8026d8
  800218:	50                   	push   %eax
  800219:	68 a0 26 80 00       	push   $0x8026a0
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
  80023c:	68 b4 26 80 00       	push   $0x8026b4
  800241:	e8 b3 00 00 00       	call   8002f9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800246:	83 c4 18             	add    $0x18,%esp
  800249:	53                   	push   %ebx
  80024a:	ff 75 10             	pushl  0x10(%ebp)
  80024d:	e8 56 00 00 00       	call   8002a8 <vcprintf>
	cprintf("\n");
  800252:	c7 04 24 64 26 80 00 	movl   $0x802664,(%esp)
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
  8003a6:	e8 05 20 00 00       	call   8023b0 <__udivdi3>
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
  8003cf:	e8 ec 20 00 00       	call   8024c0 <__umoddi3>
  8003d4:	83 c4 14             	add    $0x14,%esp
  8003d7:	0f be 80 df 26 80 00 	movsbl 0x8026df(%eax),%eax
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
  800480:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
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
  80054b:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  800552:	85 d2                	test   %edx,%edx
  800554:	74 18                	je     80056e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800556:	52                   	push   %edx
  800557:	68 41 2b 80 00       	push   $0x802b41
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 a6 fe ff ff       	call   800409 <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
  800569:	e9 fe 02 00 00       	jmp    80086c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80056e:	50                   	push   %eax
  80056f:	68 f7 26 80 00       	push   $0x8026f7
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
  800596:	b8 f0 26 80 00       	mov    $0x8026f0,%eax
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
  80092e:	bf 15 28 80 00       	mov    $0x802815,%edi
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
  80095a:	bf 4d 28 80 00       	mov    $0x80284d,%edi
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
  800dfb:	68 68 2a 80 00       	push   $0x802a68
  800e00:	6a 43                	push   $0x43
  800e02:	68 85 2a 80 00       	push   $0x802a85
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
  800e7c:	68 68 2a 80 00       	push   $0x802a68
  800e81:	6a 43                	push   $0x43
  800e83:	68 85 2a 80 00       	push   $0x802a85
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
  800ebe:	68 68 2a 80 00       	push   $0x802a68
  800ec3:	6a 43                	push   $0x43
  800ec5:	68 85 2a 80 00       	push   $0x802a85
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
  800f00:	68 68 2a 80 00       	push   $0x802a68
  800f05:	6a 43                	push   $0x43
  800f07:	68 85 2a 80 00       	push   $0x802a85
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
  800f42:	68 68 2a 80 00       	push   $0x802a68
  800f47:	6a 43                	push   $0x43
  800f49:	68 85 2a 80 00       	push   $0x802a85
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
  800f84:	68 68 2a 80 00       	push   $0x802a68
  800f89:	6a 43                	push   $0x43
  800f8b:	68 85 2a 80 00       	push   $0x802a85
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
  800fc6:	68 68 2a 80 00       	push   $0x802a68
  800fcb:	6a 43                	push   $0x43
  800fcd:	68 85 2a 80 00       	push   $0x802a85
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
  80102a:	68 68 2a 80 00       	push   $0x802a68
  80102f:	6a 43                	push   $0x43
  801031:	68 85 2a 80 00       	push   $0x802a85
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
  80110e:	68 68 2a 80 00       	push   $0x802a68
  801113:	6a 43                	push   $0x43
  801115:	68 85 2a 80 00       	push   $0x802a85
  80111a:	e8 e4 f0 ff ff       	call   800203 <_panic>

0080111f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	05 00 00 00 30       	add    $0x30000000,%eax
  80112a:	c1 e8 0c             	shr    $0xc,%eax
}
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    

0080112f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80113a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80113f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80114e:	89 c2                	mov    %eax,%edx
  801150:	c1 ea 16             	shr    $0x16,%edx
  801153:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80115a:	f6 c2 01             	test   $0x1,%dl
  80115d:	74 2d                	je     80118c <fd_alloc+0x46>
  80115f:	89 c2                	mov    %eax,%edx
  801161:	c1 ea 0c             	shr    $0xc,%edx
  801164:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80116b:	f6 c2 01             	test   $0x1,%dl
  80116e:	74 1c                	je     80118c <fd_alloc+0x46>
  801170:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801175:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80117a:	75 d2                	jne    80114e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801185:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80118a:	eb 0a                	jmp    801196 <fd_alloc+0x50>
			*fd_store = fd;
  80118c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80119e:	83 f8 1f             	cmp    $0x1f,%eax
  8011a1:	77 30                	ja     8011d3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a3:	c1 e0 0c             	shl    $0xc,%eax
  8011a6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011ab:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011b1:	f6 c2 01             	test   $0x1,%dl
  8011b4:	74 24                	je     8011da <fd_lookup+0x42>
  8011b6:	89 c2                	mov    %eax,%edx
  8011b8:	c1 ea 0c             	shr    $0xc,%edx
  8011bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c2:	f6 c2 01             	test   $0x1,%dl
  8011c5:	74 1a                	je     8011e1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ca:	89 02                	mov    %eax,(%edx)
	return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    
		return -E_INVAL;
  8011d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d8:	eb f7                	jmp    8011d1 <fd_lookup+0x39>
		return -E_INVAL;
  8011da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011df:	eb f0                	jmp    8011d1 <fd_lookup+0x39>
  8011e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e6:	eb e9                	jmp    8011d1 <fd_lookup+0x39>

008011e8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011fb:	39 08                	cmp    %ecx,(%eax)
  8011fd:	74 38                	je     801237 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ff:	83 c2 01             	add    $0x1,%edx
  801202:	8b 04 95 14 2b 80 00 	mov    0x802b14(,%edx,4),%eax
  801209:	85 c0                	test   %eax,%eax
  80120b:	75 ee                	jne    8011fb <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120d:	a1 08 40 80 00       	mov    0x804008,%eax
  801212:	8b 40 48             	mov    0x48(%eax),%eax
  801215:	83 ec 04             	sub    $0x4,%esp
  801218:	51                   	push   %ecx
  801219:	50                   	push   %eax
  80121a:	68 94 2a 80 00       	push   $0x802a94
  80121f:	e8 d5 f0 ff ff       	call   8002f9 <cprintf>
	*dev = 0;
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    
			*dev = devtab[i];
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
  801241:	eb f2                	jmp    801235 <dev_lookup+0x4d>

00801243 <fd_close>:
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	57                   	push   %edi
  801247:	56                   	push   %esi
  801248:	53                   	push   %ebx
  801249:	83 ec 24             	sub    $0x24,%esp
  80124c:	8b 75 08             	mov    0x8(%ebp),%esi
  80124f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801252:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801255:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801256:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80125c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80125f:	50                   	push   %eax
  801260:	e8 33 ff ff ff       	call   801198 <fd_lookup>
  801265:	89 c3                	mov    %eax,%ebx
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 05                	js     801273 <fd_close+0x30>
	    || fd != fd2)
  80126e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801271:	74 16                	je     801289 <fd_close+0x46>
		return (must_exist ? r : 0);
  801273:	89 f8                	mov    %edi,%eax
  801275:	84 c0                	test   %al,%al
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
  80127c:	0f 44 d8             	cmove  %eax,%ebx
}
  80127f:	89 d8                	mov    %ebx,%eax
  801281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801284:	5b                   	pop    %ebx
  801285:	5e                   	pop    %esi
  801286:	5f                   	pop    %edi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801289:	83 ec 08             	sub    $0x8,%esp
  80128c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80128f:	50                   	push   %eax
  801290:	ff 36                	pushl  (%esi)
  801292:	e8 51 ff ff ff       	call   8011e8 <dev_lookup>
  801297:	89 c3                	mov    %eax,%ebx
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 1a                	js     8012ba <fd_close+0x77>
		if (dev->dev_close)
  8012a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	74 0b                	je     8012ba <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	56                   	push   %esi
  8012b3:	ff d0                	call   *%eax
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	56                   	push   %esi
  8012be:	6a 00                	push   $0x0
  8012c0:	e8 0a fc ff ff       	call   800ecf <sys_page_unmap>
	return r;
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	eb b5                	jmp    80127f <fd_close+0x3c>

008012ca <close>:

int
close(int fdnum)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d3:	50                   	push   %eax
  8012d4:	ff 75 08             	pushl  0x8(%ebp)
  8012d7:	e8 bc fe ff ff       	call   801198 <fd_lookup>
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	79 02                	jns    8012e5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    
		return fd_close(fd, 1);
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	6a 01                	push   $0x1
  8012ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ed:	e8 51 ff ff ff       	call   801243 <fd_close>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	eb ec                	jmp    8012e3 <close+0x19>

008012f7 <close_all>:

void
close_all(void)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	53                   	push   %ebx
  8012fb:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012fe:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801303:	83 ec 0c             	sub    $0xc,%esp
  801306:	53                   	push   %ebx
  801307:	e8 be ff ff ff       	call   8012ca <close>
	for (i = 0; i < MAXFD; i++)
  80130c:	83 c3 01             	add    $0x1,%ebx
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	83 fb 20             	cmp    $0x20,%ebx
  801315:	75 ec                	jne    801303 <close_all+0xc>
}
  801317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801325:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801328:	50                   	push   %eax
  801329:	ff 75 08             	pushl  0x8(%ebp)
  80132c:	e8 67 fe ff ff       	call   801198 <fd_lookup>
  801331:	89 c3                	mov    %eax,%ebx
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	0f 88 81 00 00 00    	js     8013bf <dup+0xa3>
		return r;
	close(newfdnum);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	e8 81 ff ff ff       	call   8012ca <close>

	newfd = INDEX2FD(newfdnum);
  801349:	8b 75 0c             	mov    0xc(%ebp),%esi
  80134c:	c1 e6 0c             	shl    $0xc,%esi
  80134f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801355:	83 c4 04             	add    $0x4,%esp
  801358:	ff 75 e4             	pushl  -0x1c(%ebp)
  80135b:	e8 cf fd ff ff       	call   80112f <fd2data>
  801360:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801362:	89 34 24             	mov    %esi,(%esp)
  801365:	e8 c5 fd ff ff       	call   80112f <fd2data>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80136f:	89 d8                	mov    %ebx,%eax
  801371:	c1 e8 16             	shr    $0x16,%eax
  801374:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137b:	a8 01                	test   $0x1,%al
  80137d:	74 11                	je     801390 <dup+0x74>
  80137f:	89 d8                	mov    %ebx,%eax
  801381:	c1 e8 0c             	shr    $0xc,%eax
  801384:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	75 39                	jne    8013c9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	c1 e8 0c             	shr    $0xc,%eax
  801398:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a7:	50                   	push   %eax
  8013a8:	56                   	push   %esi
  8013a9:	6a 00                	push   $0x0
  8013ab:	52                   	push   %edx
  8013ac:	6a 00                	push   $0x0
  8013ae:	e8 da fa ff ff       	call   800e8d <sys_page_map>
  8013b3:	89 c3                	mov    %eax,%ebx
  8013b5:	83 c4 20             	add    $0x20,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	78 31                	js     8013ed <dup+0xd1>
		goto err;

	return newfdnum;
  8013bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013bf:	89 d8                	mov    %ebx,%eax
  8013c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c4:	5b                   	pop    %ebx
  8013c5:	5e                   	pop    %esi
  8013c6:	5f                   	pop    %edi
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d8:	50                   	push   %eax
  8013d9:	57                   	push   %edi
  8013da:	6a 00                	push   $0x0
  8013dc:	53                   	push   %ebx
  8013dd:	6a 00                	push   $0x0
  8013df:	e8 a9 fa ff ff       	call   800e8d <sys_page_map>
  8013e4:	89 c3                	mov    %eax,%ebx
  8013e6:	83 c4 20             	add    $0x20,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	79 a3                	jns    801390 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	56                   	push   %esi
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 d7 fa ff ff       	call   800ecf <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f8:	83 c4 08             	add    $0x8,%esp
  8013fb:	57                   	push   %edi
  8013fc:	6a 00                	push   $0x0
  8013fe:	e8 cc fa ff ff       	call   800ecf <sys_page_unmap>
	return r;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	eb b7                	jmp    8013bf <dup+0xa3>

00801408 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
  80140b:	53                   	push   %ebx
  80140c:	83 ec 1c             	sub    $0x1c,%esp
  80140f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801412:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	53                   	push   %ebx
  801417:	e8 7c fd ff ff       	call   801198 <fd_lookup>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 3f                	js     801462 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801429:	50                   	push   %eax
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	ff 30                	pushl  (%eax)
  80142f:	e8 b4 fd ff ff       	call   8011e8 <dev_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 27                	js     801462 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80143b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143e:	8b 42 08             	mov    0x8(%edx),%eax
  801441:	83 e0 03             	and    $0x3,%eax
  801444:	83 f8 01             	cmp    $0x1,%eax
  801447:	74 1e                	je     801467 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144c:	8b 40 08             	mov    0x8(%eax),%eax
  80144f:	85 c0                	test   %eax,%eax
  801451:	74 35                	je     801488 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	ff 75 10             	pushl  0x10(%ebp)
  801459:	ff 75 0c             	pushl  0xc(%ebp)
  80145c:	52                   	push   %edx
  80145d:	ff d0                	call   *%eax
  80145f:	83 c4 10             	add    $0x10,%esp
}
  801462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801465:	c9                   	leave  
  801466:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801467:	a1 08 40 80 00       	mov    0x804008,%eax
  80146c:	8b 40 48             	mov    0x48(%eax),%eax
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	53                   	push   %ebx
  801473:	50                   	push   %eax
  801474:	68 d8 2a 80 00       	push   $0x802ad8
  801479:	e8 7b ee ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801486:	eb da                	jmp    801462 <read+0x5a>
		return -E_NOT_SUPP;
  801488:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148d:	eb d3                	jmp    801462 <read+0x5a>

0080148f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	57                   	push   %edi
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	8b 7d 08             	mov    0x8(%ebp),%edi
  80149b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80149e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a3:	39 f3                	cmp    %esi,%ebx
  8014a5:	73 23                	jae    8014ca <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	89 f0                	mov    %esi,%eax
  8014ac:	29 d8                	sub    %ebx,%eax
  8014ae:	50                   	push   %eax
  8014af:	89 d8                	mov    %ebx,%eax
  8014b1:	03 45 0c             	add    0xc(%ebp),%eax
  8014b4:	50                   	push   %eax
  8014b5:	57                   	push   %edi
  8014b6:	e8 4d ff ff ff       	call   801408 <read>
		if (m < 0)
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 06                	js     8014c8 <readn+0x39>
			return m;
		if (m == 0)
  8014c2:	74 06                	je     8014ca <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014c4:	01 c3                	add    %eax,%ebx
  8014c6:	eb db                	jmp    8014a3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5f                   	pop    %edi
  8014d2:	5d                   	pop    %ebp
  8014d3:	c3                   	ret    

008014d4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 1c             	sub    $0x1c,%esp
  8014db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e1:	50                   	push   %eax
  8014e2:	53                   	push   %ebx
  8014e3:	e8 b0 fc ff ff       	call   801198 <fd_lookup>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 3a                	js     801529 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	ff 30                	pushl  (%eax)
  8014fb:	e8 e8 fc ff ff       	call   8011e8 <dev_lookup>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 22                	js     801529 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80150e:	74 1e                	je     80152e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801513:	8b 52 0c             	mov    0xc(%edx),%edx
  801516:	85 d2                	test   %edx,%edx
  801518:	74 35                	je     80154f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	ff 75 10             	pushl  0x10(%ebp)
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	50                   	push   %eax
  801524:	ff d2                	call   *%edx
  801526:	83 c4 10             	add    $0x10,%esp
}
  801529:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80152e:	a1 08 40 80 00       	mov    0x804008,%eax
  801533:	8b 40 48             	mov    0x48(%eax),%eax
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	53                   	push   %ebx
  80153a:	50                   	push   %eax
  80153b:	68 f4 2a 80 00       	push   $0x802af4
  801540:	e8 b4 ed ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154d:	eb da                	jmp    801529 <write+0x55>
		return -E_NOT_SUPP;
  80154f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801554:	eb d3                	jmp    801529 <write+0x55>

00801556 <seek>:

int
seek(int fdnum, off_t offset)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155f:	50                   	push   %eax
  801560:	ff 75 08             	pushl  0x8(%ebp)
  801563:	e8 30 fc ff ff       	call   801198 <fd_lookup>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 0e                	js     80157d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80156f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801575:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 1c             	sub    $0x1c,%esp
  801586:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801589:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	53                   	push   %ebx
  80158e:	e8 05 fc ff ff       	call   801198 <fd_lookup>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 37                	js     8015d1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	ff 30                	pushl  (%eax)
  8015a6:	e8 3d fc ff ff       	call   8011e8 <dev_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 1f                	js     8015d1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b9:	74 1b                	je     8015d6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8b 52 18             	mov    0x18(%edx),%edx
  8015c1:	85 d2                	test   %edx,%edx
  8015c3:	74 32                	je     8015f7 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	50                   	push   %eax
  8015cc:	ff d2                	call   *%edx
  8015ce:	83 c4 10             	add    $0x10,%esp
}
  8015d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015d6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015db:	8b 40 48             	mov    0x48(%eax),%eax
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	53                   	push   %ebx
  8015e2:	50                   	push   %eax
  8015e3:	68 b4 2a 80 00       	push   $0x802ab4
  8015e8:	e8 0c ed ff ff       	call   8002f9 <cprintf>
		return -E_INVAL;
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f5:	eb da                	jmp    8015d1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015fc:	eb d3                	jmp    8015d1 <ftruncate+0x52>

008015fe <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	53                   	push   %ebx
  801602:	83 ec 1c             	sub    $0x1c,%esp
  801605:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801608:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160b:	50                   	push   %eax
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 84 fb ff ff       	call   801198 <fd_lookup>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	78 4b                	js     801666 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801621:	50                   	push   %eax
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	ff 30                	pushl  (%eax)
  801627:	e8 bc fb ff ff       	call   8011e8 <dev_lookup>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 33                	js     801666 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80163a:	74 2f                	je     80166b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80163c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80163f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801646:	00 00 00 
	stat->st_isdir = 0;
  801649:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801650:	00 00 00 
	stat->st_dev = dev;
  801653:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	53                   	push   %ebx
  80165d:	ff 75 f0             	pushl  -0x10(%ebp)
  801660:	ff 50 14             	call   *0x14(%eax)
  801663:	83 c4 10             	add    $0x10,%esp
}
  801666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801669:	c9                   	leave  
  80166a:	c3                   	ret    
		return -E_NOT_SUPP;
  80166b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801670:	eb f4                	jmp    801666 <fstat+0x68>

00801672 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	56                   	push   %esi
  801676:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	6a 00                	push   $0x0
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 22 02 00 00       	call   8018a6 <open>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 1b                	js     8016a8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	e8 65 ff ff ff       	call   8015fe <fstat>
  801699:	89 c6                	mov    %eax,%esi
	close(fd);
  80169b:	89 1c 24             	mov    %ebx,(%esp)
  80169e:	e8 27 fc ff ff       	call   8012ca <close>
	return r;
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 f3                	mov    %esi,%ebx
}
  8016a8:	89 d8                	mov    %ebx,%eax
  8016aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5e                   	pop    %esi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    

008016b1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	89 c6                	mov    %eax,%esi
  8016b8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ba:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016c1:	74 27                	je     8016ea <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c3:	6a 07                	push   $0x7
  8016c5:	68 00 50 80 00       	push   $0x805000
  8016ca:	56                   	push   %esi
  8016cb:	ff 35 00 40 80 00    	pushl  0x804000
  8016d1:	e8 08 0c 00 00       	call   8022de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016d6:	83 c4 0c             	add    $0xc,%esp
  8016d9:	6a 00                	push   $0x0
  8016db:	53                   	push   %ebx
  8016dc:	6a 00                	push   $0x0
  8016de:	e8 92 0b 00 00       	call   802275 <ipc_recv>
}
  8016e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	6a 01                	push   $0x1
  8016ef:	e8 42 0c 00 00       	call   802336 <ipc_find_env>
  8016f4:	a3 00 40 80 00       	mov    %eax,0x804000
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	eb c5                	jmp    8016c3 <fsipc+0x12>

008016fe <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 40 0c             	mov    0xc(%eax),%eax
  80170a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80170f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801712:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801717:	ba 00 00 00 00       	mov    $0x0,%edx
  80171c:	b8 02 00 00 00       	mov    $0x2,%eax
  801721:	e8 8b ff ff ff       	call   8016b1 <fsipc>
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <devfile_flush>:
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	8b 40 0c             	mov    0xc(%eax),%eax
  801734:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	b8 06 00 00 00       	mov    $0x6,%eax
  801743:	e8 69 ff ff ff       	call   8016b1 <fsipc>
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <devfile_stat>:
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	53                   	push   %ebx
  80174e:	83 ec 04             	sub    $0x4,%esp
  801751:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 40 0c             	mov    0xc(%eax),%eax
  80175a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80175f:	ba 00 00 00 00       	mov    $0x0,%edx
  801764:	b8 05 00 00 00       	mov    $0x5,%eax
  801769:	e8 43 ff ff ff       	call   8016b1 <fsipc>
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 2c                	js     80179e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	68 00 50 80 00       	push   $0x805000
  80177a:	53                   	push   %ebx
  80177b:	e8 d8 f2 ff ff       	call   800a58 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801780:	a1 80 50 80 00       	mov    0x805080,%eax
  801785:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80178b:	a1 84 50 80 00       	mov    0x805084,%eax
  801790:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <devfile_write>:
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017b8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017be:	53                   	push   %ebx
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	68 08 50 80 00       	push   $0x805008
  8017c7:	e8 7c f4 ff ff       	call   800c48 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 04 00 00 00       	mov    $0x4,%eax
  8017d6:	e8 d6 fe ff ff       	call   8016b1 <fsipc>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 0b                	js     8017ed <devfile_write+0x4a>
	assert(r <= n);
  8017e2:	39 d8                	cmp    %ebx,%eax
  8017e4:	77 0c                	ja     8017f2 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017e6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017eb:	7f 1e                	jg     80180b <devfile_write+0x68>
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    
	assert(r <= n);
  8017f2:	68 28 2b 80 00       	push   $0x802b28
  8017f7:	68 2f 2b 80 00       	push   $0x802b2f
  8017fc:	68 98 00 00 00       	push   $0x98
  801801:	68 44 2b 80 00       	push   $0x802b44
  801806:	e8 f8 e9 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  80180b:	68 4f 2b 80 00       	push   $0x802b4f
  801810:	68 2f 2b 80 00       	push   $0x802b2f
  801815:	68 99 00 00 00       	push   $0x99
  80181a:	68 44 2b 80 00       	push   $0x802b44
  80181f:	e8 df e9 ff ff       	call   800203 <_panic>

00801824 <devfile_read>:
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
  801829:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 40 0c             	mov    0xc(%eax),%eax
  801832:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801837:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80183d:	ba 00 00 00 00       	mov    $0x0,%edx
  801842:	b8 03 00 00 00       	mov    $0x3,%eax
  801847:	e8 65 fe ff ff       	call   8016b1 <fsipc>
  80184c:	89 c3                	mov    %eax,%ebx
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 1f                	js     801871 <devfile_read+0x4d>
	assert(r <= n);
  801852:	39 f0                	cmp    %esi,%eax
  801854:	77 24                	ja     80187a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801856:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80185b:	7f 33                	jg     801890 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	50                   	push   %eax
  801861:	68 00 50 80 00       	push   $0x805000
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	e8 78 f3 ff ff       	call   800be6 <memmove>
	return r;
  80186e:	83 c4 10             	add    $0x10,%esp
}
  801871:	89 d8                	mov    %ebx,%eax
  801873:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801876:	5b                   	pop    %ebx
  801877:	5e                   	pop    %esi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
	assert(r <= n);
  80187a:	68 28 2b 80 00       	push   $0x802b28
  80187f:	68 2f 2b 80 00       	push   $0x802b2f
  801884:	6a 7c                	push   $0x7c
  801886:	68 44 2b 80 00       	push   $0x802b44
  80188b:	e8 73 e9 ff ff       	call   800203 <_panic>
	assert(r <= PGSIZE);
  801890:	68 4f 2b 80 00       	push   $0x802b4f
  801895:	68 2f 2b 80 00       	push   $0x802b2f
  80189a:	6a 7d                	push   $0x7d
  80189c:	68 44 2b 80 00       	push   $0x802b44
  8018a1:	e8 5d e9 ff ff       	call   800203 <_panic>

008018a6 <open>:
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
  8018ab:	83 ec 1c             	sub    $0x1c,%esp
  8018ae:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018b1:	56                   	push   %esi
  8018b2:	e8 68 f1 ff ff       	call   800a1f <strlen>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018bf:	7f 6c                	jg     80192d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	50                   	push   %eax
  8018c8:	e8 79 f8 ff ff       	call   801146 <fd_alloc>
  8018cd:	89 c3                	mov    %eax,%ebx
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 3c                	js     801912 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	56                   	push   %esi
  8018da:	68 00 50 80 00       	push   $0x805000
  8018df:	e8 74 f1 ff ff       	call   800a58 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f4:	e8 b8 fd ff ff       	call   8016b1 <fsipc>
  8018f9:	89 c3                	mov    %eax,%ebx
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 19                	js     80191b <open+0x75>
	return fd2num(fd);
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	ff 75 f4             	pushl  -0xc(%ebp)
  801908:	e8 12 f8 ff ff       	call   80111f <fd2num>
  80190d:	89 c3                	mov    %eax,%ebx
  80190f:	83 c4 10             	add    $0x10,%esp
}
  801912:	89 d8                	mov    %ebx,%eax
  801914:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    
		fd_close(fd, 0);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	6a 00                	push   $0x0
  801920:	ff 75 f4             	pushl  -0xc(%ebp)
  801923:	e8 1b f9 ff ff       	call   801243 <fd_close>
		return r;
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	eb e5                	jmp    801912 <open+0x6c>
		return -E_BAD_PATH;
  80192d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801932:	eb de                	jmp    801912 <open+0x6c>

00801934 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
  80193f:	b8 08 00 00 00       	mov    $0x8,%eax
  801944:	e8 68 fd ff ff       	call   8016b1 <fsipc>
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801951:	68 5b 2b 80 00       	push   $0x802b5b
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	e8 fa f0 ff ff       	call   800a58 <strcpy>
	return 0;
}
  80195e:	b8 00 00 00 00       	mov    $0x0,%eax
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <devsock_close>:
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	53                   	push   %ebx
  801969:	83 ec 10             	sub    $0x10,%esp
  80196c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80196f:	53                   	push   %ebx
  801970:	e8 fc 09 00 00       	call   802371 <pageref>
  801975:	83 c4 10             	add    $0x10,%esp
		return 0;
  801978:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80197d:	83 f8 01             	cmp    $0x1,%eax
  801980:	74 07                	je     801989 <devsock_close+0x24>
}
  801982:	89 d0                	mov    %edx,%eax
  801984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801987:	c9                   	leave  
  801988:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	ff 73 0c             	pushl  0xc(%ebx)
  80198f:	e8 b9 02 00 00       	call   801c4d <nsipc_close>
  801994:	89 c2                	mov    %eax,%edx
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	eb e7                	jmp    801982 <devsock_close+0x1d>

0080199b <devsock_write>:
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	ff 70 0c             	pushl  0xc(%eax)
  8019af:	e8 76 03 00 00       	call   801d2a <nsipc_send>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <devsock_read>:
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	ff 70 0c             	pushl  0xc(%eax)
  8019ca:	e8 ef 02 00 00       	call   801cbe <nsipc_recv>
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <fd2sockid>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019da:	52                   	push   %edx
  8019db:	50                   	push   %eax
  8019dc:	e8 b7 f7 ff ff       	call   801198 <fd_lookup>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 10                	js     8019f8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019f1:	39 08                	cmp    %ecx,(%eax)
  8019f3:	75 05                	jne    8019fa <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019f5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    
		return -E_NOT_SUPP;
  8019fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ff:	eb f7                	jmp    8019f8 <fd2sockid+0x27>

00801a01 <alloc_sockfd>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	83 ec 1c             	sub    $0x1c,%esp
  801a09:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0e:	50                   	push   %eax
  801a0f:	e8 32 f7 ff ff       	call   801146 <fd_alloc>
  801a14:	89 c3                	mov    %eax,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	78 43                	js     801a60 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	68 07 04 00 00       	push   $0x407
  801a25:	ff 75 f4             	pushl  -0xc(%ebp)
  801a28:	6a 00                	push   $0x0
  801a2a:	e8 1b f4 ff ff       	call   800e4a <sys_page_alloc>
  801a2f:	89 c3                	mov    %eax,%ebx
  801a31:	83 c4 10             	add    $0x10,%esp
  801a34:	85 c0                	test   %eax,%eax
  801a36:	78 28                	js     801a60 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a41:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a46:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a4d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	50                   	push   %eax
  801a54:	e8 c6 f6 ff ff       	call   80111f <fd2num>
  801a59:	89 c3                	mov    %eax,%ebx
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	eb 0c                	jmp    801a6c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	56                   	push   %esi
  801a64:	e8 e4 01 00 00       	call   801c4d <nsipc_close>
		return r;
  801a69:	83 c4 10             	add    $0x10,%esp
}
  801a6c:	89 d8                	mov    %ebx,%eax
  801a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a71:	5b                   	pop    %ebx
  801a72:	5e                   	pop    %esi
  801a73:	5d                   	pop    %ebp
  801a74:	c3                   	ret    

00801a75 <accept>:
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	e8 4e ff ff ff       	call   8019d1 <fd2sockid>
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 1b                	js     801aa2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	ff 75 10             	pushl  0x10(%ebp)
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	50                   	push   %eax
  801a91:	e8 0e 01 00 00       	call   801ba4 <nsipc_accept>
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 05                	js     801aa2 <accept+0x2d>
	return alloc_sockfd(r);
  801a9d:	e8 5f ff ff ff       	call   801a01 <alloc_sockfd>
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <bind>:
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	e8 1f ff ff ff       	call   8019d1 <fd2sockid>
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 12                	js     801ac8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	ff 75 10             	pushl  0x10(%ebp)
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	50                   	push   %eax
  801ac0:	e8 31 01 00 00       	call   801bf6 <nsipc_bind>
  801ac5:	83 c4 10             	add    $0x10,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <shutdown>:
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	e8 f9 fe ff ff       	call   8019d1 <fd2sockid>
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 0f                	js     801aeb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	50                   	push   %eax
  801ae3:	e8 43 01 00 00       	call   801c2b <nsipc_shutdown>
  801ae8:	83 c4 10             	add    $0x10,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <connect>:
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	e8 d6 fe ff ff       	call   8019d1 <fd2sockid>
  801afb:	85 c0                	test   %eax,%eax
  801afd:	78 12                	js     801b11 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aff:	83 ec 04             	sub    $0x4,%esp
  801b02:	ff 75 10             	pushl  0x10(%ebp)
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	50                   	push   %eax
  801b09:	e8 59 01 00 00       	call   801c67 <nsipc_connect>
  801b0e:	83 c4 10             	add    $0x10,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <listen>:
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	e8 b0 fe ff ff       	call   8019d1 <fd2sockid>
  801b21:	85 c0                	test   %eax,%eax
  801b23:	78 0f                	js     801b34 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	50                   	push   %eax
  801b2c:	e8 6b 01 00 00       	call   801c9c <nsipc_listen>
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	e8 3e 02 00 00       	call   801d88 <nsipc_socket>
  801b4a:	83 c4 10             	add    $0x10,%esp
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	78 05                	js     801b56 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b51:	e8 ab fe ff ff       	call   801a01 <alloc_sockfd>
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b61:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b68:	74 26                	je     801b90 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b6a:	6a 07                	push   $0x7
  801b6c:	68 00 60 80 00       	push   $0x806000
  801b71:	53                   	push   %ebx
  801b72:	ff 35 04 40 80 00    	pushl  0x804004
  801b78:	e8 61 07 00 00       	call   8022de <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b7d:	83 c4 0c             	add    $0xc,%esp
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	e8 ea 06 00 00       	call   802275 <ipc_recv>
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b90:	83 ec 0c             	sub    $0xc,%esp
  801b93:	6a 02                	push   $0x2
  801b95:	e8 9c 07 00 00       	call   802336 <ipc_find_env>
  801b9a:	a3 04 40 80 00       	mov    %eax,0x804004
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	eb c6                	jmp    801b6a <nsipc+0x12>

00801ba4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bb4:	8b 06                	mov    (%esi),%eax
  801bb6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc0:	e8 93 ff ff ff       	call   801b58 <nsipc>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	79 09                	jns    801bd4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bcb:	89 d8                	mov    %ebx,%eax
  801bcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	ff 35 10 60 80 00    	pushl  0x806010
  801bdd:	68 00 60 80 00       	push   $0x806000
  801be2:	ff 75 0c             	pushl  0xc(%ebp)
  801be5:	e8 fc ef ff ff       	call   800be6 <memmove>
		*addrlen = ret->ret_addrlen;
  801bea:	a1 10 60 80 00       	mov    0x806010,%eax
  801bef:	89 06                	mov    %eax,(%esi)
  801bf1:	83 c4 10             	add    $0x10,%esp
	return r;
  801bf4:	eb d5                	jmp    801bcb <nsipc_accept+0x27>

00801bf6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	53                   	push   %ebx
  801bfa:	83 ec 08             	sub    $0x8,%esp
  801bfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c08:	53                   	push   %ebx
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	68 04 60 80 00       	push   $0x806004
  801c11:	e8 d0 ef ff ff       	call   800be6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c16:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c1c:	b8 02 00 00 00       	mov    $0x2,%eax
  801c21:	e8 32 ff ff ff       	call   801b58 <nsipc>
}
  801c26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c41:	b8 03 00 00 00       	mov    $0x3,%eax
  801c46:	e8 0d ff ff ff       	call   801b58 <nsipc>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <nsipc_close>:

int
nsipc_close(int s)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c5b:	b8 04 00 00 00       	mov    $0x4,%eax
  801c60:	e8 f3 fe ff ff       	call   801b58 <nsipc>
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c79:	53                   	push   %ebx
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	68 04 60 80 00       	push   $0x806004
  801c82:	e8 5f ef ff ff       	call   800be6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c87:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c8d:	b8 05 00 00 00       	mov    $0x5,%eax
  801c92:	e8 c1 fe ff ff       	call   801b58 <nsipc>
}
  801c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cb2:	b8 06 00 00 00       	mov    $0x6,%eax
  801cb7:	e8 9c fe ff ff       	call   801b58 <nsipc>
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	56                   	push   %esi
  801cc2:	53                   	push   %ebx
  801cc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cdc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce1:	e8 72 fe ff ff       	call   801b58 <nsipc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 1f                	js     801d0b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cec:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cf1:	7f 21                	jg     801d14 <nsipc_recv+0x56>
  801cf3:	39 c6                	cmp    %eax,%esi
  801cf5:	7c 1d                	jl     801d14 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cf7:	83 ec 04             	sub    $0x4,%esp
  801cfa:	50                   	push   %eax
  801cfb:	68 00 60 80 00       	push   $0x806000
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	e8 de ee ff ff       	call   800be6 <memmove>
  801d08:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d0b:	89 d8                	mov    %ebx,%eax
  801d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d14:	68 67 2b 80 00       	push   $0x802b67
  801d19:	68 2f 2b 80 00       	push   $0x802b2f
  801d1e:	6a 62                	push   $0x62
  801d20:	68 7c 2b 80 00       	push   $0x802b7c
  801d25:	e8 d9 e4 ff ff       	call   800203 <_panic>

00801d2a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d3c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d42:	7f 2e                	jg     801d72 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d44:	83 ec 04             	sub    $0x4,%esp
  801d47:	53                   	push   %ebx
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	68 0c 60 80 00       	push   $0x80600c
  801d50:	e8 91 ee ff ff       	call   800be6 <memmove>
	nsipcbuf.send.req_size = size;
  801d55:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d63:	b8 08 00 00 00       	mov    $0x8,%eax
  801d68:	e8 eb fd ff ff       	call   801b58 <nsipc>
}
  801d6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    
	assert(size < 1600);
  801d72:	68 88 2b 80 00       	push   $0x802b88
  801d77:	68 2f 2b 80 00       	push   $0x802b2f
  801d7c:	6a 6d                	push   $0x6d
  801d7e:	68 7c 2b 80 00       	push   $0x802b7c
  801d83:	e8 7b e4 ff ff       	call   800203 <_panic>

00801d88 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d99:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801da1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801da6:	b8 09 00 00 00       	mov    $0x9,%eax
  801dab:	e8 a8 fd ff ff       	call   801b58 <nsipc>
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 6a f3 ff ff       	call   80112f <fd2data>
  801dc5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	68 94 2b 80 00       	push   $0x802b94
  801dcf:	53                   	push   %ebx
  801dd0:	e8 83 ec ff ff       	call   800a58 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd5:	8b 46 04             	mov    0x4(%esi),%eax
  801dd8:	2b 06                	sub    (%esi),%eax
  801dda:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801de7:	00 00 00 
	stat->st_dev = &devpipe;
  801dea:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801df1:	30 80 00 
	return 0;
}
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
  801e04:	83 ec 0c             	sub    $0xc,%esp
  801e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e0a:	53                   	push   %ebx
  801e0b:	6a 00                	push   $0x0
  801e0d:	e8 bd f0 ff ff       	call   800ecf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e12:	89 1c 24             	mov    %ebx,(%esp)
  801e15:	e8 15 f3 ff ff       	call   80112f <fd2data>
  801e1a:	83 c4 08             	add    $0x8,%esp
  801e1d:	50                   	push   %eax
  801e1e:	6a 00                	push   $0x0
  801e20:	e8 aa f0 ff ff       	call   800ecf <sys_page_unmap>
}
  801e25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <_pipeisclosed>:
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	57                   	push   %edi
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 1c             	sub    $0x1c,%esp
  801e33:	89 c7                	mov    %eax,%edi
  801e35:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e37:	a1 08 40 80 00       	mov    0x804008,%eax
  801e3c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	57                   	push   %edi
  801e43:	e8 29 05 00 00       	call   802371 <pageref>
  801e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e4b:	89 34 24             	mov    %esi,(%esp)
  801e4e:	e8 1e 05 00 00       	call   802371 <pageref>
		nn = thisenv->env_runs;
  801e53:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e59:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	39 cb                	cmp    %ecx,%ebx
  801e61:	74 1b                	je     801e7e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e63:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e66:	75 cf                	jne    801e37 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e68:	8b 42 58             	mov    0x58(%edx),%eax
  801e6b:	6a 01                	push   $0x1
  801e6d:	50                   	push   %eax
  801e6e:	53                   	push   %ebx
  801e6f:	68 9b 2b 80 00       	push   $0x802b9b
  801e74:	e8 80 e4 ff ff       	call   8002f9 <cprintf>
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	eb b9                	jmp    801e37 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e7e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e81:	0f 94 c0             	sete   %al
  801e84:	0f b6 c0             	movzbl %al,%eax
}
  801e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8a:	5b                   	pop    %ebx
  801e8b:	5e                   	pop    %esi
  801e8c:	5f                   	pop    %edi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    

00801e8f <devpipe_write>:
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	57                   	push   %edi
  801e93:	56                   	push   %esi
  801e94:	53                   	push   %ebx
  801e95:	83 ec 28             	sub    $0x28,%esp
  801e98:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e9b:	56                   	push   %esi
  801e9c:	e8 8e f2 ff ff       	call   80112f <fd2data>
  801ea1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea3:	83 c4 10             	add    $0x10,%esp
  801ea6:	bf 00 00 00 00       	mov    $0x0,%edi
  801eab:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eae:	74 4f                	je     801eff <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb0:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb3:	8b 0b                	mov    (%ebx),%ecx
  801eb5:	8d 51 20             	lea    0x20(%ecx),%edx
  801eb8:	39 d0                	cmp    %edx,%eax
  801eba:	72 14                	jb     801ed0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ebc:	89 da                	mov    %ebx,%edx
  801ebe:	89 f0                	mov    %esi,%eax
  801ec0:	e8 65 ff ff ff       	call   801e2a <_pipeisclosed>
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	75 3b                	jne    801f04 <devpipe_write+0x75>
			sys_yield();
  801ec9:	e8 5d ef ff ff       	call   800e2b <sys_yield>
  801ece:	eb e0                	jmp    801eb0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ed7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eda:	89 c2                	mov    %eax,%edx
  801edc:	c1 fa 1f             	sar    $0x1f,%edx
  801edf:	89 d1                	mov    %edx,%ecx
  801ee1:	c1 e9 1b             	shr    $0x1b,%ecx
  801ee4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ee7:	83 e2 1f             	and    $0x1f,%edx
  801eea:	29 ca                	sub    %ecx,%edx
  801eec:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ef0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ef4:	83 c0 01             	add    $0x1,%eax
  801ef7:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801efa:	83 c7 01             	add    $0x1,%edi
  801efd:	eb ac                	jmp    801eab <devpipe_write+0x1c>
	return i;
  801eff:	8b 45 10             	mov    0x10(%ebp),%eax
  801f02:	eb 05                	jmp    801f09 <devpipe_write+0x7a>
				return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5f                   	pop    %edi
  801f0f:	5d                   	pop    %ebp
  801f10:	c3                   	ret    

00801f11 <devpipe_read>:
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	57                   	push   %edi
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	83 ec 18             	sub    $0x18,%esp
  801f1a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f1d:	57                   	push   %edi
  801f1e:	e8 0c f2 ff ff       	call   80112f <fd2data>
  801f23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	be 00 00 00 00       	mov    $0x0,%esi
  801f2d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f30:	75 14                	jne    801f46 <devpipe_read+0x35>
	return i;
  801f32:	8b 45 10             	mov    0x10(%ebp),%eax
  801f35:	eb 02                	jmp    801f39 <devpipe_read+0x28>
				return i;
  801f37:	89 f0                	mov    %esi,%eax
}
  801f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5f                   	pop    %edi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    
			sys_yield();
  801f41:	e8 e5 ee ff ff       	call   800e2b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f46:	8b 03                	mov    (%ebx),%eax
  801f48:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f4b:	75 18                	jne    801f65 <devpipe_read+0x54>
			if (i > 0)
  801f4d:	85 f6                	test   %esi,%esi
  801f4f:	75 e6                	jne    801f37 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f51:	89 da                	mov    %ebx,%edx
  801f53:	89 f8                	mov    %edi,%eax
  801f55:	e8 d0 fe ff ff       	call   801e2a <_pipeisclosed>
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	74 e3                	je     801f41 <devpipe_read+0x30>
				return 0;
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	eb d4                	jmp    801f39 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f65:	99                   	cltd   
  801f66:	c1 ea 1b             	shr    $0x1b,%edx
  801f69:	01 d0                	add    %edx,%eax
  801f6b:	83 e0 1f             	and    $0x1f,%eax
  801f6e:	29 d0                	sub    %edx,%eax
  801f70:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f78:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f7b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f7e:	83 c6 01             	add    $0x1,%esi
  801f81:	eb aa                	jmp    801f2d <devpipe_read+0x1c>

00801f83 <pipe>:
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	56                   	push   %esi
  801f87:	53                   	push   %ebx
  801f88:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8e:	50                   	push   %eax
  801f8f:	e8 b2 f1 ff ff       	call   801146 <fd_alloc>
  801f94:	89 c3                	mov    %eax,%ebx
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	0f 88 23 01 00 00    	js     8020c4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 07 04 00 00       	push   $0x407
  801fa9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fac:	6a 00                	push   $0x0
  801fae:	e8 97 ee ff ff       	call   800e4a <sys_page_alloc>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	0f 88 04 01 00 00    	js     8020c4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fc6:	50                   	push   %eax
  801fc7:	e8 7a f1 ff ff       	call   801146 <fd_alloc>
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	0f 88 db 00 00 00    	js     8020b4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	68 07 04 00 00       	push   $0x407
  801fe1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe4:	6a 00                	push   $0x0
  801fe6:	e8 5f ee ff ff       	call   800e4a <sys_page_alloc>
  801feb:	89 c3                	mov    %eax,%ebx
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	0f 88 bc 00 00 00    	js     8020b4 <pipe+0x131>
	va = fd2data(fd0);
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffe:	e8 2c f1 ff ff       	call   80112f <fd2data>
  802003:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802005:	83 c4 0c             	add    $0xc,%esp
  802008:	68 07 04 00 00       	push   $0x407
  80200d:	50                   	push   %eax
  80200e:	6a 00                	push   $0x0
  802010:	e8 35 ee ff ff       	call   800e4a <sys_page_alloc>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	85 c0                	test   %eax,%eax
  80201c:	0f 88 82 00 00 00    	js     8020a4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802022:	83 ec 0c             	sub    $0xc,%esp
  802025:	ff 75 f0             	pushl  -0x10(%ebp)
  802028:	e8 02 f1 ff ff       	call   80112f <fd2data>
  80202d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802034:	50                   	push   %eax
  802035:	6a 00                	push   $0x0
  802037:	56                   	push   %esi
  802038:	6a 00                	push   $0x0
  80203a:	e8 4e ee ff ff       	call   800e8d <sys_page_map>
  80203f:	89 c3                	mov    %eax,%ebx
  802041:	83 c4 20             	add    $0x20,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	78 4e                	js     802096 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802048:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80204d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802050:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802055:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80205c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802064:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	ff 75 f4             	pushl  -0xc(%ebp)
  802071:	e8 a9 f0 ff ff       	call   80111f <fd2num>
  802076:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802079:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80207b:	83 c4 04             	add    $0x4,%esp
  80207e:	ff 75 f0             	pushl  -0x10(%ebp)
  802081:	e8 99 f0 ff ff       	call   80111f <fd2num>
  802086:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802089:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802094:	eb 2e                	jmp    8020c4 <pipe+0x141>
	sys_page_unmap(0, va);
  802096:	83 ec 08             	sub    $0x8,%esp
  802099:	56                   	push   %esi
  80209a:	6a 00                	push   $0x0
  80209c:	e8 2e ee ff ff       	call   800ecf <sys_page_unmap>
  8020a1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020a4:	83 ec 08             	sub    $0x8,%esp
  8020a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020aa:	6a 00                	push   $0x0
  8020ac:	e8 1e ee ff ff       	call   800ecf <sys_page_unmap>
  8020b1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020b4:	83 ec 08             	sub    $0x8,%esp
  8020b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ba:	6a 00                	push   $0x0
  8020bc:	e8 0e ee ff ff       	call   800ecf <sys_page_unmap>
  8020c1:	83 c4 10             	add    $0x10,%esp
}
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c9:	5b                   	pop    %ebx
  8020ca:	5e                   	pop    %esi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    

008020cd <pipeisclosed>:
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d6:	50                   	push   %eax
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	e8 b9 f0 ff ff       	call   801198 <fd_lookup>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	78 18                	js     8020fe <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ec:	e8 3e f0 ff ff       	call   80112f <fd2data>
	return _pipeisclosed(fd, p);
  8020f1:	89 c2                	mov    %eax,%edx
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	e8 2f fd ff ff       	call   801e2a <_pipeisclosed>
  8020fb:	83 c4 10             	add    $0x10,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	c3                   	ret    

00802106 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80210c:	68 b3 2b 80 00       	push   $0x802bb3
  802111:	ff 75 0c             	pushl  0xc(%ebp)
  802114:	e8 3f e9 ff ff       	call   800a58 <strcpy>
	return 0;
}
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <devcons_write>:
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	57                   	push   %edi
  802124:	56                   	push   %esi
  802125:	53                   	push   %ebx
  802126:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80212c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802131:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802137:	3b 75 10             	cmp    0x10(%ebp),%esi
  80213a:	73 31                	jae    80216d <devcons_write+0x4d>
		m = n - tot;
  80213c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80213f:	29 f3                	sub    %esi,%ebx
  802141:	83 fb 7f             	cmp    $0x7f,%ebx
  802144:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802149:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	53                   	push   %ebx
  802150:	89 f0                	mov    %esi,%eax
  802152:	03 45 0c             	add    0xc(%ebp),%eax
  802155:	50                   	push   %eax
  802156:	57                   	push   %edi
  802157:	e8 8a ea ff ff       	call   800be6 <memmove>
		sys_cputs(buf, m);
  80215c:	83 c4 08             	add    $0x8,%esp
  80215f:	53                   	push   %ebx
  802160:	57                   	push   %edi
  802161:	e8 28 ec ff ff       	call   800d8e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802166:	01 de                	add    %ebx,%esi
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	eb ca                	jmp    802137 <devcons_write+0x17>
}
  80216d:	89 f0                	mov    %esi,%eax
  80216f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802172:	5b                   	pop    %ebx
  802173:	5e                   	pop    %esi
  802174:	5f                   	pop    %edi
  802175:	5d                   	pop    %ebp
  802176:	c3                   	ret    

00802177 <devcons_read>:
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802182:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802186:	74 21                	je     8021a9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802188:	e8 1f ec ff ff       	call   800dac <sys_cgetc>
  80218d:	85 c0                	test   %eax,%eax
  80218f:	75 07                	jne    802198 <devcons_read+0x21>
		sys_yield();
  802191:	e8 95 ec ff ff       	call   800e2b <sys_yield>
  802196:	eb f0                	jmp    802188 <devcons_read+0x11>
	if (c < 0)
  802198:	78 0f                	js     8021a9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80219a:	83 f8 04             	cmp    $0x4,%eax
  80219d:	74 0c                	je     8021ab <devcons_read+0x34>
	*(char*)vbuf = c;
  80219f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a2:	88 02                	mov    %al,(%edx)
	return 1;
  8021a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    
		return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b0:	eb f7                	jmp    8021a9 <devcons_read+0x32>

008021b2 <cputchar>:
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021be:	6a 01                	push   $0x1
  8021c0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c3:	50                   	push   %eax
  8021c4:	e8 c5 eb ff ff       	call   800d8e <sys_cputs>
}
  8021c9:	83 c4 10             	add    $0x10,%esp
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <getchar>:
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021d4:	6a 01                	push   $0x1
  8021d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d9:	50                   	push   %eax
  8021da:	6a 00                	push   $0x0
  8021dc:	e8 27 f2 ff ff       	call   801408 <read>
	if (r < 0)
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 06                	js     8021ee <getchar+0x20>
	if (r < 1)
  8021e8:	74 06                	je     8021f0 <getchar+0x22>
	return c;
  8021ea:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    
		return -E_EOF;
  8021f0:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021f5:	eb f7                	jmp    8021ee <getchar+0x20>

008021f7 <iscons>:
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802200:	50                   	push   %eax
  802201:	ff 75 08             	pushl  0x8(%ebp)
  802204:	e8 8f ef ff ff       	call   801198 <fd_lookup>
  802209:	83 c4 10             	add    $0x10,%esp
  80220c:	85 c0                	test   %eax,%eax
  80220e:	78 11                	js     802221 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802219:	39 10                	cmp    %edx,(%eax)
  80221b:	0f 94 c0             	sete   %al
  80221e:	0f b6 c0             	movzbl %al,%eax
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <opencons>:
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802229:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80222c:	50                   	push   %eax
  80222d:	e8 14 ef ff ff       	call   801146 <fd_alloc>
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	85 c0                	test   %eax,%eax
  802237:	78 3a                	js     802273 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	68 07 04 00 00       	push   $0x407
  802241:	ff 75 f4             	pushl  -0xc(%ebp)
  802244:	6a 00                	push   $0x0
  802246:	e8 ff eb ff ff       	call   800e4a <sys_page_alloc>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	85 c0                	test   %eax,%eax
  802250:	78 21                	js     802273 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80225b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	50                   	push   %eax
  80226b:	e8 af ee ff ff       	call   80111f <fd2num>
  802270:	83 c4 10             	add    $0x10,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	56                   	push   %esi
  802279:	53                   	push   %ebx
  80227a:	8b 75 08             	mov    0x8(%ebp),%esi
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802283:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802285:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80228a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	50                   	push   %eax
  802291:	e8 64 ed ff ff       	call   800ffa <sys_ipc_recv>
	if(ret < 0){
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 2b                	js     8022c8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80229d:	85 f6                	test   %esi,%esi
  80229f:	74 0a                	je     8022ab <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a6:	8b 40 74             	mov    0x74(%eax),%eax
  8022a9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022ab:	85 db                	test   %ebx,%ebx
  8022ad:	74 0a                	je     8022b9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022af:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b4:	8b 40 78             	mov    0x78(%eax),%eax
  8022b7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    
		if(from_env_store)
  8022c8:	85 f6                	test   %esi,%esi
  8022ca:	74 06                	je     8022d2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022d2:	85 db                	test   %ebx,%ebx
  8022d4:	74 eb                	je     8022c1 <ipc_recv+0x4c>
			*perm_store = 0;
  8022d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022dc:	eb e3                	jmp    8022c1 <ipc_recv+0x4c>

008022de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 0c             	sub    $0xc,%esp
  8022e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022f0:	85 db                	test   %ebx,%ebx
  8022f2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022f7:	0f 44 d8             	cmove  %eax,%ebx
  8022fa:	eb 05                	jmp    802301 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022fc:	e8 2a eb ff ff       	call   800e2b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802301:	ff 75 14             	pushl  0x14(%ebp)
  802304:	53                   	push   %ebx
  802305:	56                   	push   %esi
  802306:	57                   	push   %edi
  802307:	e8 cb ec ff ff       	call   800fd7 <sys_ipc_try_send>
  80230c:	83 c4 10             	add    $0x10,%esp
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 1b                	je     80232e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802313:	79 e7                	jns    8022fc <ipc_send+0x1e>
  802315:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802318:	74 e2                	je     8022fc <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	68 bf 2b 80 00       	push   $0x802bbf
  802322:	6a 46                	push   $0x46
  802324:	68 d4 2b 80 00       	push   $0x802bd4
  802329:	e8 d5 de ff ff       	call   800203 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80232e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802341:	89 c2                	mov    %eax,%edx
  802343:	c1 e2 07             	shl    $0x7,%edx
  802346:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80234c:	8b 52 50             	mov    0x50(%edx),%edx
  80234f:	39 ca                	cmp    %ecx,%edx
  802351:	74 11                	je     802364 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802353:	83 c0 01             	add    $0x1,%eax
  802356:	3d 00 04 00 00       	cmp    $0x400,%eax
  80235b:	75 e4                	jne    802341 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
  802362:	eb 0b                	jmp    80236f <ipc_find_env+0x39>
			return envs[i].env_id;
  802364:	c1 e0 07             	shl    $0x7,%eax
  802367:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80236c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802377:	89 d0                	mov    %edx,%eax
  802379:	c1 e8 16             	shr    $0x16,%eax
  80237c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802388:	f6 c1 01             	test   $0x1,%cl
  80238b:	74 1d                	je     8023aa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80238d:	c1 ea 0c             	shr    $0xc,%edx
  802390:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802397:	f6 c2 01             	test   $0x1,%dl
  80239a:	74 0e                	je     8023aa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80239c:	c1 ea 0c             	shr    $0xc,%edx
  80239f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023a6:	ef 
  8023a7:	0f b7 c0             	movzwl %ax,%eax
}
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023c7:	85 d2                	test   %edx,%edx
  8023c9:	75 4d                	jne    802418 <__udivdi3+0x68>
  8023cb:	39 f3                	cmp    %esi,%ebx
  8023cd:	76 19                	jbe    8023e8 <__udivdi3+0x38>
  8023cf:	31 ff                	xor    %edi,%edi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f2                	mov    %esi,%edx
  8023d5:	f7 f3                	div    %ebx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 d9                	mov    %ebx,%ecx
  8023ea:	85 db                	test   %ebx,%ebx
  8023ec:	75 0b                	jne    8023f9 <__udivdi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	89 f0                	mov    %esi,%eax
  8023fd:	f7 f1                	div    %ecx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f7                	mov    %esi,%edi
  802405:	f7 f1                	div    %ecx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	39 f2                	cmp    %esi,%edx
  80241a:	77 1c                	ja     802438 <__udivdi3+0x88>
  80241c:	0f bd fa             	bsr    %edx,%edi
  80241f:	83 f7 1f             	xor    $0x1f,%edi
  802422:	75 2c                	jne    802450 <__udivdi3+0xa0>
  802424:	39 f2                	cmp    %esi,%edx
  802426:	72 06                	jb     80242e <__udivdi3+0x7e>
  802428:	31 c0                	xor    %eax,%eax
  80242a:	39 eb                	cmp    %ebp,%ebx
  80242c:	77 a9                	ja     8023d7 <__udivdi3+0x27>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	eb a2                	jmp    8023d7 <__udivdi3+0x27>
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 f9                	mov    %edi,%ecx
  802452:	b8 20 00 00 00       	mov    $0x20,%eax
  802457:	29 f8                	sub    %edi,%eax
  802459:	d3 e2                	shl    %cl,%edx
  80245b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245f:	89 c1                	mov    %eax,%ecx
  802461:	89 da                	mov    %ebx,%edx
  802463:	d3 ea                	shr    %cl,%edx
  802465:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802469:	09 d1                	or     %edx,%ecx
  80246b:	89 f2                	mov    %esi,%edx
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e3                	shl    %cl,%ebx
  802475:	89 c1                	mov    %eax,%ecx
  802477:	d3 ea                	shr    %cl,%edx
  802479:	89 f9                	mov    %edi,%ecx
  80247b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80247f:	89 eb                	mov    %ebp,%ebx
  802481:	d3 e6                	shl    %cl,%esi
  802483:	89 c1                	mov    %eax,%ecx
  802485:	d3 eb                	shr    %cl,%ebx
  802487:	09 de                	or     %ebx,%esi
  802489:	89 f0                	mov    %esi,%eax
  80248b:	f7 74 24 08          	divl   0x8(%esp)
  80248f:	89 d6                	mov    %edx,%esi
  802491:	89 c3                	mov    %eax,%ebx
  802493:	f7 64 24 0c          	mull   0xc(%esp)
  802497:	39 d6                	cmp    %edx,%esi
  802499:	72 15                	jb     8024b0 <__udivdi3+0x100>
  80249b:	89 f9                	mov    %edi,%ecx
  80249d:	d3 e5                	shl    %cl,%ebp
  80249f:	39 c5                	cmp    %eax,%ebp
  8024a1:	73 04                	jae    8024a7 <__udivdi3+0xf7>
  8024a3:	39 d6                	cmp    %edx,%esi
  8024a5:	74 09                	je     8024b0 <__udivdi3+0x100>
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	31 ff                	xor    %edi,%edi
  8024ab:	e9 27 ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	e9 1d ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d7:	89 da                	mov    %ebx,%edx
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 43                	jne    802520 <__umoddi3+0x60>
  8024dd:	39 df                	cmp    %ebx,%edi
  8024df:	76 17                	jbe    8024f8 <__umoddi3+0x38>
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	f7 f7                	div    %edi
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 fd                	mov    %edi,%ebp
  8024fa:	85 ff                	test   %edi,%edi
  8024fc:	75 0b                	jne    802509 <__umoddi3+0x49>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f7                	div    %edi
  802507:	89 c5                	mov    %eax,%ebp
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f5                	div    %ebp
  80250f:	89 f0                	mov    %esi,%eax
  802511:	f7 f5                	div    %ebp
  802513:	89 d0                	mov    %edx,%eax
  802515:	eb d0                	jmp    8024e7 <__umoddi3+0x27>
  802517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251e:	66 90                	xchg   %ax,%ax
  802520:	89 f1                	mov    %esi,%ecx
  802522:	39 d8                	cmp    %ebx,%eax
  802524:	76 0a                	jbe    802530 <__umoddi3+0x70>
  802526:	89 f0                	mov    %esi,%eax
  802528:	83 c4 1c             	add    $0x1c,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	75 20                	jne    802558 <__umoddi3+0x98>
  802538:	39 d8                	cmp    %ebx,%eax
  80253a:	0f 82 b0 00 00 00    	jb     8025f0 <__umoddi3+0x130>
  802540:	39 f7                	cmp    %esi,%edi
  802542:	0f 86 a8 00 00 00    	jbe    8025f0 <__umoddi3+0x130>
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	83 c4 1c             	add    $0x1c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	ba 20 00 00 00       	mov    $0x20,%edx
  80255f:	29 ea                	sub    %ebp,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 44 24 08          	mov    %eax,0x8(%esp)
  802567:	89 d1                	mov    %edx,%ecx
  802569:	89 f8                	mov    %edi,%eax
  80256b:	d3 e8                	shr    %cl,%eax
  80256d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802571:	89 54 24 04          	mov    %edx,0x4(%esp)
  802575:	8b 54 24 04          	mov    0x4(%esp),%edx
  802579:	09 c1                	or     %eax,%ecx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 d1                	mov    %edx,%ecx
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 c7                	mov    %eax,%edi
  802593:	89 d1                	mov    %edx,%ecx
  802595:	89 f0                	mov    %esi,%eax
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	d3 e6                	shl    %cl,%esi
  80259f:	09 d8                	or     %ebx,%eax
  8025a1:	f7 74 24 08          	divl   0x8(%esp)
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ad:	89 c6                	mov    %eax,%esi
  8025af:	89 d7                	mov    %edx,%edi
  8025b1:	39 d1                	cmp    %edx,%ecx
  8025b3:	72 06                	jb     8025bb <__umoddi3+0xfb>
  8025b5:	75 10                	jne    8025c7 <__umoddi3+0x107>
  8025b7:	39 c3                	cmp    %eax,%ebx
  8025b9:	73 0c                	jae    8025c7 <__umoddi3+0x107>
  8025bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025c3:	89 d7                	mov    %edx,%edi
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 ca                	mov    %ecx,%edx
  8025c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ce:	29 f3                	sub    %esi,%ebx
  8025d0:	19 fa                	sbb    %edi,%edx
  8025d2:	89 d0                	mov    %edx,%eax
  8025d4:	d3 e0                	shl    %cl,%eax
  8025d6:	89 e9                	mov    %ebp,%ecx
  8025d8:	d3 eb                	shr    %cl,%ebx
  8025da:	d3 ea                	shr    %cl,%edx
  8025dc:	09 d8                	or     %ebx,%eax
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 da                	mov    %ebx,%edx
  8025f2:	29 fe                	sub    %edi,%esi
  8025f4:	19 c2                	sbb    %eax,%edx
  8025f6:	89 f1                	mov    %esi,%ecx
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	e9 4b ff ff ff       	jmp    80254a <__umoddi3+0x8a>
