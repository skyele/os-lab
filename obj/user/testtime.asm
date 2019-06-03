
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
  80003a:	e8 ec 0f 00 00       	call   80102b <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 f0             	cmp    $0xfffffff0,%eax
  80004f:	7d 14                	jge    800065 <sleep+0x32>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	77 22                	ja     800077 <sleep+0x44>
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  800055:	e8 d1 0f 00 00       	call   80102b <sys_time_msec>
  80005a:	39 d8                	cmp    %ebx,%eax
  80005c:	73 2d                	jae    80008b <sleep+0x58>
		sys_yield();
  80005e:	e8 77 0d 00 00       	call   800dda <sys_yield>
  800063:	eb f0                	jmp    800055 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800065:	50                   	push   %eax
  800066:	68 c0 25 80 00       	push   $0x8025c0
  80006b:	6a 0b                	push   $0xb
  80006d:	68 d2 25 80 00       	push   $0x8025d2
  800072:	e8 3b 01 00 00       	call   8001b2 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 e2 25 80 00       	push   $0x8025e2
  80007f:	6a 0d                	push   $0xd
  800081:	68 d2 25 80 00       	push   $0x8025d2
  800086:	e8 27 01 00 00       	call   8001b2 <_panic>
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
  80009c:	e8 39 0d 00 00       	call   800dda <sys_yield>
	for (i = 0; i < 50; i++)
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 f6                	jne    80009c <umain+0xc>

	cprintf("starting count down: ");
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	68 ee 25 80 00       	push   $0x8025ee
  8000ae:	e8 f5 01 00 00       	call   8002a8 <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 04 26 80 00       	push   $0x802604
  8000c4:	e8 df 01 00 00       	call   8002a8 <cprintf>
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
  8000e3:	68 13 26 80 00       	push   $0x802613
  8000e8:	e8 bb 01 00 00       	call   8002a8 <cprintf>
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
  800109:	e8 ad 0c 00 00       	call   800dbb <sys_getenvid>
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

	cprintf("call umain!\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 08 26 80 00       	push   $0x802608
  800175:	e8 2e 01 00 00       	call   8002a8 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017a:	83 c4 08             	add    $0x8,%esp
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	e8 08 ff ff ff       	call   800090 <umain>

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
  80019e:	e8 03 11 00 00       	call   8012a6 <close_all>
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
  8001b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8001bc:	8b 40 48             	mov    0x48(%eax),%eax
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	68 50 26 80 00       	push   $0x802650
  8001c7:	50                   	push   %eax
  8001c8:	68 1f 26 80 00       	push   $0x80261f
  8001cd:	e8 d6 00 00 00       	call   8002a8 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001d2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001db:	e8 db 0b 00 00       	call   800dbb <sys_getenvid>
  8001e0:	83 c4 04             	add    $0x4,%esp
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	56                   	push   %esi
  8001ea:	50                   	push   %eax
  8001eb:	68 2c 26 80 00       	push   $0x80262c
  8001f0:	e8 b3 00 00 00       	call   8002a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f5:	83 c4 18             	add    $0x18,%esp
  8001f8:	53                   	push   %ebx
  8001f9:	ff 75 10             	pushl  0x10(%ebp)
  8001fc:	e8 56 00 00 00       	call   800257 <vcprintf>
	cprintf("\n");
  800201:	c7 04 24 13 26 80 00 	movl   $0x802613,(%esp)
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
  800355:	e8 06 20 00 00       	call   802360 <__udivdi3>
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
  80037e:	e8 ed 20 00 00       	call   802470 <__umoddi3>
  800383:	83 c4 14             	add    $0x14,%esp
  800386:	0f be 80 57 26 80 00 	movsbl 0x802657(%eax),%eax
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
  80042f:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
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
  8004fa:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  800501:	85 d2                	test   %edx,%edx
  800503:	74 18                	je     80051d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800505:	52                   	push   %edx
  800506:	68 bd 2a 80 00       	push   $0x802abd
  80050b:	53                   	push   %ebx
  80050c:	56                   	push   %esi
  80050d:	e8 a6 fe ff ff       	call   8003b8 <printfmt>
  800512:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800515:	89 7d 14             	mov    %edi,0x14(%ebp)
  800518:	e9 fe 02 00 00       	jmp    80081b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80051d:	50                   	push   %eax
  80051e:	68 6f 26 80 00       	push   $0x80266f
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
  800545:	b8 68 26 80 00       	mov    $0x802668,%eax
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
  8008dd:	bf 8d 27 80 00       	mov    $0x80278d,%edi
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
  800909:	bf c5 27 80 00       	mov    $0x8027c5,%edi
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
  800daa:	68 e4 29 80 00       	push   $0x8029e4
  800daf:	6a 43                	push   $0x43
  800db1:	68 01 2a 80 00       	push   $0x802a01
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
  800e2b:	68 e4 29 80 00       	push   $0x8029e4
  800e30:	6a 43                	push   $0x43
  800e32:	68 01 2a 80 00       	push   $0x802a01
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
  800e6d:	68 e4 29 80 00       	push   $0x8029e4
  800e72:	6a 43                	push   $0x43
  800e74:	68 01 2a 80 00       	push   $0x802a01
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
  800eaf:	68 e4 29 80 00       	push   $0x8029e4
  800eb4:	6a 43                	push   $0x43
  800eb6:	68 01 2a 80 00       	push   $0x802a01
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
  800ef1:	68 e4 29 80 00       	push   $0x8029e4
  800ef6:	6a 43                	push   $0x43
  800ef8:	68 01 2a 80 00       	push   $0x802a01
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
  800f33:	68 e4 29 80 00       	push   $0x8029e4
  800f38:	6a 43                	push   $0x43
  800f3a:	68 01 2a 80 00       	push   $0x802a01
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
  800f75:	68 e4 29 80 00       	push   $0x8029e4
  800f7a:	6a 43                	push   $0x43
  800f7c:	68 01 2a 80 00       	push   $0x802a01
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
  800fd9:	68 e4 29 80 00       	push   $0x8029e4
  800fde:	6a 43                	push   $0x43
  800fe0:	68 01 2a 80 00       	push   $0x802a01
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
  8010bd:	68 e4 29 80 00       	push   $0x8029e4
  8010c2:	6a 43                	push   $0x43
  8010c4:	68 01 2a 80 00       	push   $0x802a01
  8010c9:	e8 e4 f0 ff ff       	call   8001b2 <_panic>

008010ce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	05 00 00 00 30       	add    $0x30000000,%eax
  8010d9:	c1 e8 0c             	shr    $0xc,%eax
}
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010ee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	c1 ea 16             	shr    $0x16,%edx
  801102:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801109:	f6 c2 01             	test   $0x1,%dl
  80110c:	74 2d                	je     80113b <fd_alloc+0x46>
  80110e:	89 c2                	mov    %eax,%edx
  801110:	c1 ea 0c             	shr    $0xc,%edx
  801113:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80111a:	f6 c2 01             	test   $0x1,%dl
  80111d:	74 1c                	je     80113b <fd_alloc+0x46>
  80111f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801124:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801129:	75 d2                	jne    8010fd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801134:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801139:	eb 0a                	jmp    801145 <fd_alloc+0x50>
			*fd_store = fd;
  80113b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114d:	83 f8 1f             	cmp    $0x1f,%eax
  801150:	77 30                	ja     801182 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801152:	c1 e0 0c             	shl    $0xc,%eax
  801155:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801160:	f6 c2 01             	test   $0x1,%dl
  801163:	74 24                	je     801189 <fd_lookup+0x42>
  801165:	89 c2                	mov    %eax,%edx
  801167:	c1 ea 0c             	shr    $0xc,%edx
  80116a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801171:	f6 c2 01             	test   $0x1,%dl
  801174:	74 1a                	je     801190 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801176:	8b 55 0c             	mov    0xc(%ebp),%edx
  801179:	89 02                	mov    %eax,(%edx)
	return 0;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    
		return -E_INVAL;
  801182:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801187:	eb f7                	jmp    801180 <fd_lookup+0x39>
		return -E_INVAL;
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118e:	eb f0                	jmp    801180 <fd_lookup+0x39>
  801190:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801195:	eb e9                	jmp    801180 <fd_lookup+0x39>

00801197 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 08             	sub    $0x8,%esp
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011aa:	39 08                	cmp    %ecx,(%eax)
  8011ac:	74 38                	je     8011e6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ae:	83 c2 01             	add    $0x1,%edx
  8011b1:	8b 04 95 90 2a 80 00 	mov    0x802a90(,%edx,4),%eax
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	75 ee                	jne    8011aa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8011c1:	8b 40 48             	mov    0x48(%eax),%eax
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	51                   	push   %ecx
  8011c8:	50                   	push   %eax
  8011c9:	68 10 2a 80 00       	push   $0x802a10
  8011ce:	e8 d5 f0 ff ff       	call   8002a8 <cprintf>
	*dev = 0;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
			*dev = devtab[i];
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f0:	eb f2                	jmp    8011e4 <dev_lookup+0x4d>

008011f2 <fd_close>:
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
  8011f8:	83 ec 24             	sub    $0x24,%esp
  8011fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801201:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801204:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801205:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80120b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120e:	50                   	push   %eax
  80120f:	e8 33 ff ff ff       	call   801147 <fd_lookup>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 05                	js     801222 <fd_close+0x30>
	    || fd != fd2)
  80121d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801220:	74 16                	je     801238 <fd_close+0x46>
		return (must_exist ? r : 0);
  801222:	89 f8                	mov    %edi,%eax
  801224:	84 c0                	test   %al,%al
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	0f 44 d8             	cmove  %eax,%ebx
}
  80122e:	89 d8                	mov    %ebx,%eax
  801230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80123e:	50                   	push   %eax
  80123f:	ff 36                	pushl  (%esi)
  801241:	e8 51 ff ff ff       	call   801197 <dev_lookup>
  801246:	89 c3                	mov    %eax,%ebx
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	78 1a                	js     801269 <fd_close+0x77>
		if (dev->dev_close)
  80124f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801252:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801255:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 0b                	je     801269 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	56                   	push   %esi
  801262:	ff d0                	call   *%eax
  801264:	89 c3                	mov    %eax,%ebx
  801266:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801269:	83 ec 08             	sub    $0x8,%esp
  80126c:	56                   	push   %esi
  80126d:	6a 00                	push   $0x0
  80126f:	e8 0a fc ff ff       	call   800e7e <sys_page_unmap>
	return r;
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	eb b5                	jmp    80122e <fd_close+0x3c>

00801279 <close>:

int
close(int fdnum)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801282:	50                   	push   %eax
  801283:	ff 75 08             	pushl  0x8(%ebp)
  801286:	e8 bc fe ff ff       	call   801147 <fd_lookup>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	79 02                	jns    801294 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    
		return fd_close(fd, 1);
  801294:	83 ec 08             	sub    $0x8,%esp
  801297:	6a 01                	push   $0x1
  801299:	ff 75 f4             	pushl  -0xc(%ebp)
  80129c:	e8 51 ff ff ff       	call   8011f2 <fd_close>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	eb ec                	jmp    801292 <close+0x19>

008012a6 <close_all>:

void
close_all(void)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	53                   	push   %ebx
  8012aa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	53                   	push   %ebx
  8012b6:	e8 be ff ff ff       	call   801279 <close>
	for (i = 0; i < MAXFD; i++)
  8012bb:	83 c3 01             	add    $0x1,%ebx
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 fb 20             	cmp    $0x20,%ebx
  8012c4:	75 ec                	jne    8012b2 <close_all+0xc>
}
  8012c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 67 fe ff ff       	call   801147 <fd_lookup>
  8012e0:	89 c3                	mov    %eax,%ebx
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	0f 88 81 00 00 00    	js     80136e <dup+0xa3>
		return r;
	close(newfdnum);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	e8 81 ff ff ff       	call   801279 <close>

	newfd = INDEX2FD(newfdnum);
  8012f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012fb:	c1 e6 0c             	shl    $0xc,%esi
  8012fe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801304:	83 c4 04             	add    $0x4,%esp
  801307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80130a:	e8 cf fd ff ff       	call   8010de <fd2data>
  80130f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801311:	89 34 24             	mov    %esi,(%esp)
  801314:	e8 c5 fd ff ff       	call   8010de <fd2data>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	c1 e8 16             	shr    $0x16,%eax
  801323:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132a:	a8 01                	test   $0x1,%al
  80132c:	74 11                	je     80133f <dup+0x74>
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	c1 e8 0c             	shr    $0xc,%eax
  801333:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80133a:	f6 c2 01             	test   $0x1,%dl
  80133d:	75 39                	jne    801378 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	c1 e8 0c             	shr    $0xc,%eax
  801347:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	25 07 0e 00 00       	and    $0xe07,%eax
  801356:	50                   	push   %eax
  801357:	56                   	push   %esi
  801358:	6a 00                	push   $0x0
  80135a:	52                   	push   %edx
  80135b:	6a 00                	push   $0x0
  80135d:	e8 da fa ff ff       	call   800e3c <sys_page_map>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 20             	add    $0x20,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 31                	js     80139c <dup+0xd1>
		goto err;

	return newfdnum;
  80136b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80136e:	89 d8                	mov    %ebx,%eax
  801370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801378:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	25 07 0e 00 00       	and    $0xe07,%eax
  801387:	50                   	push   %eax
  801388:	57                   	push   %edi
  801389:	6a 00                	push   $0x0
  80138b:	53                   	push   %ebx
  80138c:	6a 00                	push   $0x0
  80138e:	e8 a9 fa ff ff       	call   800e3c <sys_page_map>
  801393:	89 c3                	mov    %eax,%ebx
  801395:	83 c4 20             	add    $0x20,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	79 a3                	jns    80133f <dup+0x74>
	sys_page_unmap(0, newfd);
  80139c:	83 ec 08             	sub    $0x8,%esp
  80139f:	56                   	push   %esi
  8013a0:	6a 00                	push   $0x0
  8013a2:	e8 d7 fa ff ff       	call   800e7e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	57                   	push   %edi
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 cc fa ff ff       	call   800e7e <sys_page_unmap>
	return r;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	eb b7                	jmp    80136e <dup+0xa3>

008013b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 1c             	sub    $0x1c,%esp
  8013be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	53                   	push   %ebx
  8013c6:	e8 7c fd ff ff       	call   801147 <fd_lookup>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3f                	js     801411 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	ff 30                	pushl  (%eax)
  8013de:	e8 b4 fd ff ff       	call   801197 <dev_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 27                	js     801411 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 42 08             	mov    0x8(%edx),%eax
  8013f0:	83 e0 03             	and    $0x3,%eax
  8013f3:	83 f8 01             	cmp    $0x1,%eax
  8013f6:	74 1e                	je     801416 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fb:	8b 40 08             	mov    0x8(%eax),%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	74 35                	je     801437 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	ff 75 10             	pushl  0x10(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	52                   	push   %edx
  80140c:	ff d0                	call   *%eax
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801416:	a1 08 40 80 00       	mov    0x804008,%eax
  80141b:	8b 40 48             	mov    0x48(%eax),%eax
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	53                   	push   %ebx
  801422:	50                   	push   %eax
  801423:	68 54 2a 80 00       	push   $0x802a54
  801428:	e8 7b ee ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb da                	jmp    801411 <read+0x5a>
		return -E_NOT_SUPP;
  801437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143c:	eb d3                	jmp    801411 <read+0x5a>

0080143e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	8b 7d 08             	mov    0x8(%ebp),%edi
  80144a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801452:	39 f3                	cmp    %esi,%ebx
  801454:	73 23                	jae    801479 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	89 f0                	mov    %esi,%eax
  80145b:	29 d8                	sub    %ebx,%eax
  80145d:	50                   	push   %eax
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	03 45 0c             	add    0xc(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	57                   	push   %edi
  801465:	e8 4d ff ff ff       	call   8013b7 <read>
		if (m < 0)
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 06                	js     801477 <readn+0x39>
			return m;
		if (m == 0)
  801471:	74 06                	je     801479 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801473:	01 c3                	add    %eax,%ebx
  801475:	eb db                	jmp    801452 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801477:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5f                   	pop    %edi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	53                   	push   %ebx
  801487:	83 ec 1c             	sub    $0x1c,%esp
  80148a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	53                   	push   %ebx
  801492:	e8 b0 fc ff ff       	call   801147 <fd_lookup>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 3a                	js     8014d8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a8:	ff 30                	pushl  (%eax)
  8014aa:	e8 e8 fc ff ff       	call   801197 <dev_lookup>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 22                	js     8014d8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014bd:	74 1e                	je     8014dd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c5:	85 d2                	test   %edx,%edx
  8014c7:	74 35                	je     8014fe <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	ff 75 10             	pushl  0x10(%ebp)
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	ff d2                	call   *%edx
  8014d5:	83 c4 10             	add    $0x10,%esp
}
  8014d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8014e2:	8b 40 48             	mov    0x48(%eax),%eax
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	50                   	push   %eax
  8014ea:	68 70 2a 80 00       	push   $0x802a70
  8014ef:	e8 b4 ed ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb da                	jmp    8014d8 <write+0x55>
		return -E_NOT_SUPP;
  8014fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801503:	eb d3                	jmp    8014d8 <write+0x55>

00801505 <seek>:

int
seek(int fdnum, off_t offset)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 30 fc ff ff       	call   801147 <fd_lookup>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 0e                	js     80152c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	53                   	push   %ebx
  801532:	83 ec 1c             	sub    $0x1c,%esp
  801535:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801538:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	53                   	push   %ebx
  80153d:	e8 05 fc ff ff       	call   801147 <fd_lookup>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 37                	js     801580 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801553:	ff 30                	pushl  (%eax)
  801555:	e8 3d fc ff ff       	call   801197 <dev_lookup>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 1f                	js     801580 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801568:	74 1b                	je     801585 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 52 18             	mov    0x18(%edx),%edx
  801570:	85 d2                	test   %edx,%edx
  801572:	74 32                	je     8015a6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	ff d2                	call   *%edx
  80157d:	83 c4 10             	add    $0x10,%esp
}
  801580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801583:	c9                   	leave  
  801584:	c3                   	ret    
			thisenv->env_id, fdnum);
  801585:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80158a:	8b 40 48             	mov    0x48(%eax),%eax
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	53                   	push   %ebx
  801591:	50                   	push   %eax
  801592:	68 30 2a 80 00       	push   $0x802a30
  801597:	e8 0c ed ff ff       	call   8002a8 <cprintf>
		return -E_INVAL;
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a4:	eb da                	jmp    801580 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ab:	eb d3                	jmp    801580 <ftruncate+0x52>

008015ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	53                   	push   %ebx
  8015b1:	83 ec 1c             	sub    $0x1c,%esp
  8015b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 84 fb ff ff       	call   801147 <fd_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 4b                	js     801615 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d0:	50                   	push   %eax
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	ff 30                	pushl  (%eax)
  8015d6:	e8 bc fb ff ff       	call   801197 <dev_lookup>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 33                	js     801615 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e9:	74 2f                	je     80161a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015f5:	00 00 00 
	stat->st_isdir = 0;
  8015f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ff:	00 00 00 
	stat->st_dev = dev;
  801602:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	53                   	push   %ebx
  80160c:	ff 75 f0             	pushl  -0x10(%ebp)
  80160f:	ff 50 14             	call   *0x14(%eax)
  801612:	83 c4 10             	add    $0x10,%esp
}
  801615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801618:	c9                   	leave  
  801619:	c3                   	ret    
		return -E_NOT_SUPP;
  80161a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161f:	eb f4                	jmp    801615 <fstat+0x68>

00801621 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	56                   	push   %esi
  801625:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	6a 00                	push   $0x0
  80162b:	ff 75 08             	pushl  0x8(%ebp)
  80162e:	e8 22 02 00 00       	call   801855 <open>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 1b                	js     801657 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	50                   	push   %eax
  801643:	e8 65 ff ff ff       	call   8015ad <fstat>
  801648:	89 c6                	mov    %eax,%esi
	close(fd);
  80164a:	89 1c 24             	mov    %ebx,(%esp)
  80164d:	e8 27 fc ff ff       	call   801279 <close>
	return r;
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 f3                	mov    %esi,%ebx
}
  801657:	89 d8                	mov    %ebx,%eax
  801659:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	89 c6                	mov    %eax,%esi
  801667:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801669:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801670:	74 27                	je     801699 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801672:	6a 07                	push   $0x7
  801674:	68 00 50 80 00       	push   $0x805000
  801679:	56                   	push   %esi
  80167a:	ff 35 00 40 80 00    	pushl  0x804000
  801680:	e8 08 0c 00 00       	call   80228d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801685:	83 c4 0c             	add    $0xc,%esp
  801688:	6a 00                	push   $0x0
  80168a:	53                   	push   %ebx
  80168b:	6a 00                	push   $0x0
  80168d:	e8 92 0b 00 00       	call   802224 <ipc_recv>
}
  801692:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	6a 01                	push   $0x1
  80169e:	e8 42 0c 00 00       	call   8022e5 <ipc_find_env>
  8016a3:	a3 00 40 80 00       	mov    %eax,0x804000
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	eb c5                	jmp    801672 <fsipc+0x12>

008016ad <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8016d0:	e8 8b ff ff ff       	call   801660 <fsipc>
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <devfile_flush>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8016f2:	e8 69 ff ff ff       	call   801660 <fsipc>
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <devfile_stat>:
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	8b 40 0c             	mov    0xc(%eax),%eax
  801709:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	b8 05 00 00 00       	mov    $0x5,%eax
  801718:	e8 43 ff ff ff       	call   801660 <fsipc>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 2c                	js     80174d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	68 00 50 80 00       	push   $0x805000
  801729:	53                   	push   %ebx
  80172a:	e8 d8 f2 ff ff       	call   800a07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80172f:	a1 80 50 80 00       	mov    0x805080,%eax
  801734:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80173a:	a1 84 50 80 00       	mov    0x805084,%eax
  80173f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <devfile_write>:
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	53                   	push   %ebx
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8b 40 0c             	mov    0xc(%eax),%eax
  801762:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801767:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80176d:	53                   	push   %ebx
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	68 08 50 80 00       	push   $0x805008
  801776:	e8 7c f4 ff ff       	call   800bf7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	b8 04 00 00 00       	mov    $0x4,%eax
  801785:	e8 d6 fe ff ff       	call   801660 <fsipc>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 0b                	js     80179c <devfile_write+0x4a>
	assert(r <= n);
  801791:	39 d8                	cmp    %ebx,%eax
  801793:	77 0c                	ja     8017a1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801795:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179a:	7f 1e                	jg     8017ba <devfile_write+0x68>
}
  80179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    
	assert(r <= n);
  8017a1:	68 a4 2a 80 00       	push   $0x802aa4
  8017a6:	68 ab 2a 80 00       	push   $0x802aab
  8017ab:	68 98 00 00 00       	push   $0x98
  8017b0:	68 c0 2a 80 00       	push   $0x802ac0
  8017b5:	e8 f8 e9 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  8017ba:	68 cb 2a 80 00       	push   $0x802acb
  8017bf:	68 ab 2a 80 00       	push   $0x802aab
  8017c4:	68 99 00 00 00       	push   $0x99
  8017c9:	68 c0 2a 80 00       	push   $0x802ac0
  8017ce:	e8 df e9 ff ff       	call   8001b2 <_panic>

008017d3 <devfile_read>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017e6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017f6:	e8 65 fe ff ff       	call   801660 <fsipc>
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 1f                	js     801820 <devfile_read+0x4d>
	assert(r <= n);
  801801:	39 f0                	cmp    %esi,%eax
  801803:	77 24                	ja     801829 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801805:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180a:	7f 33                	jg     80183f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	50                   	push   %eax
  801810:	68 00 50 80 00       	push   $0x805000
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	e8 78 f3 ff ff       	call   800b95 <memmove>
	return r;
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	89 d8                	mov    %ebx,%eax
  801822:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    
	assert(r <= n);
  801829:	68 a4 2a 80 00       	push   $0x802aa4
  80182e:	68 ab 2a 80 00       	push   $0x802aab
  801833:	6a 7c                	push   $0x7c
  801835:	68 c0 2a 80 00       	push   $0x802ac0
  80183a:	e8 73 e9 ff ff       	call   8001b2 <_panic>
	assert(r <= PGSIZE);
  80183f:	68 cb 2a 80 00       	push   $0x802acb
  801844:	68 ab 2a 80 00       	push   $0x802aab
  801849:	6a 7d                	push   $0x7d
  80184b:	68 c0 2a 80 00       	push   $0x802ac0
  801850:	e8 5d e9 ff ff       	call   8001b2 <_panic>

00801855 <open>:
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801860:	56                   	push   %esi
  801861:	e8 68 f1 ff ff       	call   8009ce <strlen>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186e:	7f 6c                	jg     8018dc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801876:	50                   	push   %eax
  801877:	e8 79 f8 ff ff       	call   8010f5 <fd_alloc>
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 3c                	js     8018c1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	56                   	push   %esi
  801889:	68 00 50 80 00       	push   $0x805000
  80188e:	e8 74 f1 ff ff       	call   800a07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801893:	8b 45 0c             	mov    0xc(%ebp),%eax
  801896:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80189b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189e:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a3:	e8 b8 fd ff ff       	call   801660 <fsipc>
  8018a8:	89 c3                	mov    %eax,%ebx
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 19                	js     8018ca <open+0x75>
	return fd2num(fd);
  8018b1:	83 ec 0c             	sub    $0xc,%esp
  8018b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b7:	e8 12 f8 ff ff       	call   8010ce <fd2num>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
}
  8018c1:	89 d8                	mov    %ebx,%eax
  8018c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    
		fd_close(fd, 0);
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d2:	e8 1b f9 ff ff       	call   8011f2 <fd_close>
		return r;
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	eb e5                	jmp    8018c1 <open+0x6c>
		return -E_BAD_PATH;
  8018dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018e1:	eb de                	jmp    8018c1 <open+0x6c>

008018e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8018f3:	e8 68 fd ff ff       	call   801660 <fsipc>
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801900:	68 d7 2a 80 00       	push   $0x802ad7
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	e8 fa f0 ff ff       	call   800a07 <strcpy>
	return 0;
}
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <devsock_close>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
  801918:	83 ec 10             	sub    $0x10,%esp
  80191b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80191e:	53                   	push   %ebx
  80191f:	e8 fc 09 00 00       	call   802320 <pageref>
  801924:	83 c4 10             	add    $0x10,%esp
		return 0;
  801927:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80192c:	83 f8 01             	cmp    $0x1,%eax
  80192f:	74 07                	je     801938 <devsock_close+0x24>
}
  801931:	89 d0                	mov    %edx,%eax
  801933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801936:	c9                   	leave  
  801937:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	ff 73 0c             	pushl  0xc(%ebx)
  80193e:	e8 b9 02 00 00       	call   801bfc <nsipc_close>
  801943:	89 c2                	mov    %eax,%edx
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	eb e7                	jmp    801931 <devsock_close+0x1d>

0080194a <devsock_write>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801950:	6a 00                	push   $0x0
  801952:	ff 75 10             	pushl  0x10(%ebp)
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	ff 70 0c             	pushl  0xc(%eax)
  80195e:	e8 76 03 00 00       	call   801cd9 <nsipc_send>
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <devsock_read>:
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 10             	pushl  0x10(%ebp)
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	ff 70 0c             	pushl  0xc(%eax)
  801979:	e8 ef 02 00 00       	call   801c6d <nsipc_recv>
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <fd2sockid>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801986:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	e8 b7 f7 ff ff       	call   801147 <fd_lookup>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 10                	js     8019a7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019a0:	39 08                	cmp    %ecx,(%eax)
  8019a2:	75 05                	jne    8019a9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019a4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ae:	eb f7                	jmp    8019a7 <fd2sockid+0x27>

008019b0 <alloc_sockfd>:
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	83 ec 1c             	sub    $0x1c,%esp
  8019b8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bd:	50                   	push   %eax
  8019be:	e8 32 f7 ff ff       	call   8010f5 <fd_alloc>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 43                	js     801a0f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 07 04 00 00       	push   $0x407
  8019d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d7:	6a 00                	push   $0x0
  8019d9:	e8 1b f4 ff ff       	call   800df9 <sys_page_alloc>
  8019de:	89 c3                	mov    %eax,%ebx
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 28                	js     801a0f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019f0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019fc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	50                   	push   %eax
  801a03:	e8 c6 f6 ff ff       	call   8010ce <fd2num>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	eb 0c                	jmp    801a1b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a0f:	83 ec 0c             	sub    $0xc,%esp
  801a12:	56                   	push   %esi
  801a13:	e8 e4 01 00 00       	call   801bfc <nsipc_close>
		return r;
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <accept>:
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	e8 4e ff ff ff       	call   801980 <fd2sockid>
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1b                	js     801a51 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	50                   	push   %eax
  801a40:	e8 0e 01 00 00       	call   801b53 <nsipc_accept>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 05                	js     801a51 <accept+0x2d>
	return alloc_sockfd(r);
  801a4c:	e8 5f ff ff ff       	call   8019b0 <alloc_sockfd>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <bind>:
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	e8 1f ff ff ff       	call   801980 <fd2sockid>
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 12                	js     801a77 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	ff 75 10             	pushl  0x10(%ebp)
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	e8 31 01 00 00       	call   801ba5 <nsipc_bind>
  801a74:	83 c4 10             	add    $0x10,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <shutdown>:
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	e8 f9 fe ff ff       	call   801980 <fd2sockid>
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 0f                	js     801a9a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	e8 43 01 00 00       	call   801bda <nsipc_shutdown>
  801a97:	83 c4 10             	add    $0x10,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <connect>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	e8 d6 fe ff ff       	call   801980 <fd2sockid>
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 12                	js     801ac0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	ff 75 10             	pushl  0x10(%ebp)
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	50                   	push   %eax
  801ab8:	e8 59 01 00 00       	call   801c16 <nsipc_connect>
  801abd:	83 c4 10             	add    $0x10,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <listen>:
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	e8 b0 fe ff ff       	call   801980 <fd2sockid>
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 0f                	js     801ae3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	e8 6b 01 00 00       	call   801c4b <nsipc_listen>
  801ae0:	83 c4 10             	add    $0x10,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	e8 3e 02 00 00       	call   801d37 <nsipc_socket>
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 05                	js     801b05 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b00:	e8 ab fe ff ff       	call   8019b0 <alloc_sockfd>
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	53                   	push   %ebx
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b10:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b17:	74 26                	je     801b3f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b19:	6a 07                	push   $0x7
  801b1b:	68 00 60 80 00       	push   $0x806000
  801b20:	53                   	push   %ebx
  801b21:	ff 35 04 40 80 00    	pushl  0x804004
  801b27:	e8 61 07 00 00       	call   80228d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b2c:	83 c4 0c             	add    $0xc,%esp
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	e8 ea 06 00 00       	call   802224 <ipc_recv>
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	6a 02                	push   $0x2
  801b44:	e8 9c 07 00 00       	call   8022e5 <ipc_find_env>
  801b49:	a3 04 40 80 00       	mov    %eax,0x804004
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	eb c6                	jmp    801b19 <nsipc+0x12>

00801b53 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b63:	8b 06                	mov    (%esi),%eax
  801b65:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6f:	e8 93 ff ff ff       	call   801b07 <nsipc>
  801b74:	89 c3                	mov    %eax,%ebx
  801b76:	85 c0                	test   %eax,%eax
  801b78:	79 09                	jns    801b83 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	ff 35 10 60 80 00    	pushl  0x806010
  801b8c:	68 00 60 80 00       	push   $0x806000
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	e8 fc ef ff ff       	call   800b95 <memmove>
		*addrlen = ret->ret_addrlen;
  801b99:	a1 10 60 80 00       	mov    0x806010,%eax
  801b9e:	89 06                	mov    %eax,(%esi)
  801ba0:	83 c4 10             	add    $0x10,%esp
	return r;
  801ba3:	eb d5                	jmp    801b7a <nsipc_accept+0x27>

00801ba5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb7:	53                   	push   %ebx
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	68 04 60 80 00       	push   $0x806004
  801bc0:	e8 d0 ef ff ff       	call   800b95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bc5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bcb:	b8 02 00 00 00       	mov    $0x2,%eax
  801bd0:	e8 32 ff ff ff       	call   801b07 <nsipc>
}
  801bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801beb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bf0:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf5:	e8 0d ff ff ff       	call   801b07 <nsipc>
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <nsipc_close>:

int
nsipc_close(int s)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c0a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c0f:	e8 f3 fe ff ff       	call   801b07 <nsipc>
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 08             	sub    $0x8,%esp
  801c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c28:	53                   	push   %ebx
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	68 04 60 80 00       	push   $0x806004
  801c31:	e8 5f ef ff ff       	call   800b95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c36:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c3c:	b8 05 00 00 00       	mov    $0x5,%eax
  801c41:	e8 c1 fe ff ff       	call   801b07 <nsipc>
}
  801c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c61:	b8 06 00 00 00       	mov    $0x6,%eax
  801c66:	e8 9c fe ff ff       	call   801b07 <nsipc>
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	56                   	push   %esi
  801c71:	53                   	push   %ebx
  801c72:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c7d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c83:	8b 45 14             	mov    0x14(%ebp),%eax
  801c86:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c8b:	b8 07 00 00 00       	mov    $0x7,%eax
  801c90:	e8 72 fe ff ff       	call   801b07 <nsipc>
  801c95:	89 c3                	mov    %eax,%ebx
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 1f                	js     801cba <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c9b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ca0:	7f 21                	jg     801cc3 <nsipc_recv+0x56>
  801ca2:	39 c6                	cmp    %eax,%esi
  801ca4:	7c 1d                	jl     801cc3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	50                   	push   %eax
  801caa:	68 00 60 80 00       	push   $0x806000
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	e8 de ee ff ff       	call   800b95 <memmove>
  801cb7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cba:	89 d8                	mov    %ebx,%eax
  801cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cc3:	68 e3 2a 80 00       	push   $0x802ae3
  801cc8:	68 ab 2a 80 00       	push   $0x802aab
  801ccd:	6a 62                	push   $0x62
  801ccf:	68 f8 2a 80 00       	push   $0x802af8
  801cd4:	e8 d9 e4 ff ff       	call   8001b2 <_panic>

00801cd9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ceb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cf1:	7f 2e                	jg     801d21 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	53                   	push   %ebx
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	68 0c 60 80 00       	push   $0x80600c
  801cff:	e8 91 ee ff ff       	call   800b95 <memmove>
	nsipcbuf.send.req_size = size;
  801d04:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d12:	b8 08 00 00 00       	mov    $0x8,%eax
  801d17:	e8 eb fd ff ff       	call   801b07 <nsipc>
}
  801d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    
	assert(size < 1600);
  801d21:	68 04 2b 80 00       	push   $0x802b04
  801d26:	68 ab 2a 80 00       	push   $0x802aab
  801d2b:	6a 6d                	push   $0x6d
  801d2d:	68 f8 2a 80 00       	push   $0x802af8
  801d32:	e8 7b e4 ff ff       	call   8001b2 <_panic>

00801d37 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d48:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d50:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d55:	b8 09 00 00 00       	mov    $0x9,%eax
  801d5a:	e8 a8 fd ff ff       	call   801b07 <nsipc>
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	e8 6a f3 ff ff       	call   8010de <fd2data>
  801d74:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d76:	83 c4 08             	add    $0x8,%esp
  801d79:	68 10 2b 80 00       	push   $0x802b10
  801d7e:	53                   	push   %ebx
  801d7f:	e8 83 ec ff ff       	call   800a07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d84:	8b 46 04             	mov    0x4(%esi),%eax
  801d87:	2b 06                	sub    (%esi),%eax
  801d89:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d8f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d96:	00 00 00 
	stat->st_dev = &devpipe;
  801d99:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801da0:	30 80 00 
	return 0;
}
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801db9:	53                   	push   %ebx
  801dba:	6a 00                	push   $0x0
  801dbc:	e8 bd f0 ff ff       	call   800e7e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dc1:	89 1c 24             	mov    %ebx,(%esp)
  801dc4:	e8 15 f3 ff ff       	call   8010de <fd2data>
  801dc9:	83 c4 08             	add    $0x8,%esp
  801dcc:	50                   	push   %eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 aa f0 ff ff       	call   800e7e <sys_page_unmap>
}
  801dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <_pipeisclosed>:
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	57                   	push   %edi
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 1c             	sub    $0x1c,%esp
  801de2:	89 c7                	mov    %eax,%edi
  801de4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801de6:	a1 08 40 80 00       	mov    0x804008,%eax
  801deb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	57                   	push   %edi
  801df2:	e8 29 05 00 00       	call   802320 <pageref>
  801df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dfa:	89 34 24             	mov    %esi,(%esp)
  801dfd:	e8 1e 05 00 00       	call   802320 <pageref>
		nn = thisenv->env_runs;
  801e02:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e08:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	39 cb                	cmp    %ecx,%ebx
  801e10:	74 1b                	je     801e2d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e12:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e15:	75 cf                	jne    801de6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e17:	8b 42 58             	mov    0x58(%edx),%eax
  801e1a:	6a 01                	push   $0x1
  801e1c:	50                   	push   %eax
  801e1d:	53                   	push   %ebx
  801e1e:	68 17 2b 80 00       	push   $0x802b17
  801e23:	e8 80 e4 ff ff       	call   8002a8 <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	eb b9                	jmp    801de6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e2d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e30:	0f 94 c0             	sete   %al
  801e33:	0f b6 c0             	movzbl %al,%eax
}
  801e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e39:	5b                   	pop    %ebx
  801e3a:	5e                   	pop    %esi
  801e3b:	5f                   	pop    %edi
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    

00801e3e <devpipe_write>:
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	57                   	push   %edi
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	83 ec 28             	sub    $0x28,%esp
  801e47:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e4a:	56                   	push   %esi
  801e4b:	e8 8e f2 ff ff       	call   8010de <fd2data>
  801e50:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e5d:	74 4f                	je     801eae <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e5f:	8b 43 04             	mov    0x4(%ebx),%eax
  801e62:	8b 0b                	mov    (%ebx),%ecx
  801e64:	8d 51 20             	lea    0x20(%ecx),%edx
  801e67:	39 d0                	cmp    %edx,%eax
  801e69:	72 14                	jb     801e7f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e6b:	89 da                	mov    %ebx,%edx
  801e6d:	89 f0                	mov    %esi,%eax
  801e6f:	e8 65 ff ff ff       	call   801dd9 <_pipeisclosed>
  801e74:	85 c0                	test   %eax,%eax
  801e76:	75 3b                	jne    801eb3 <devpipe_write+0x75>
			sys_yield();
  801e78:	e8 5d ef ff ff       	call   800dda <sys_yield>
  801e7d:	eb e0                	jmp    801e5f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e82:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e86:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	c1 fa 1f             	sar    $0x1f,%edx
  801e8e:	89 d1                	mov    %edx,%ecx
  801e90:	c1 e9 1b             	shr    $0x1b,%ecx
  801e93:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e96:	83 e2 1f             	and    $0x1f,%edx
  801e99:	29 ca                	sub    %ecx,%edx
  801e9b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e9f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ea3:	83 c0 01             	add    $0x1,%eax
  801ea6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ea9:	83 c7 01             	add    $0x1,%edi
  801eac:	eb ac                	jmp    801e5a <devpipe_write+0x1c>
	return i;
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	eb 05                	jmp    801eb8 <devpipe_write+0x7a>
				return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5f                   	pop    %edi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devpipe_read>:
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	57                   	push   %edi
  801ec4:	56                   	push   %esi
  801ec5:	53                   	push   %ebx
  801ec6:	83 ec 18             	sub    $0x18,%esp
  801ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ecc:	57                   	push   %edi
  801ecd:	e8 0c f2 ff ff       	call   8010de <fd2data>
  801ed2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	be 00 00 00 00       	mov    $0x0,%esi
  801edc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801edf:	75 14                	jne    801ef5 <devpipe_read+0x35>
	return i;
  801ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee4:	eb 02                	jmp    801ee8 <devpipe_read+0x28>
				return i;
  801ee6:	89 f0                	mov    %esi,%eax
}
  801ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
			sys_yield();
  801ef0:	e8 e5 ee ff ff       	call   800dda <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ef5:	8b 03                	mov    (%ebx),%eax
  801ef7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801efa:	75 18                	jne    801f14 <devpipe_read+0x54>
			if (i > 0)
  801efc:	85 f6                	test   %esi,%esi
  801efe:	75 e6                	jne    801ee6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f00:	89 da                	mov    %ebx,%edx
  801f02:	89 f8                	mov    %edi,%eax
  801f04:	e8 d0 fe ff ff       	call   801dd9 <_pipeisclosed>
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	74 e3                	je     801ef0 <devpipe_read+0x30>
				return 0;
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f12:	eb d4                	jmp    801ee8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f14:	99                   	cltd   
  801f15:	c1 ea 1b             	shr    $0x1b,%edx
  801f18:	01 d0                	add    %edx,%eax
  801f1a:	83 e0 1f             	and    $0x1f,%eax
  801f1d:	29 d0                	sub    %edx,%eax
  801f1f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f27:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f2a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f2d:	83 c6 01             	add    $0x1,%esi
  801f30:	eb aa                	jmp    801edc <devpipe_read+0x1c>

00801f32 <pipe>:
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3d:	50                   	push   %eax
  801f3e:	e8 b2 f1 ff ff       	call   8010f5 <fd_alloc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	0f 88 23 01 00 00    	js     802073 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	68 07 04 00 00       	push   $0x407
  801f58:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 97 ee ff ff       	call   800df9 <sys_page_alloc>
  801f62:	89 c3                	mov    %eax,%ebx
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	0f 88 04 01 00 00    	js     802073 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 7a f1 ff ff       	call   8010f5 <fd_alloc>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	0f 88 db 00 00 00    	js     802063 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	68 07 04 00 00       	push   $0x407
  801f90:	ff 75 f0             	pushl  -0x10(%ebp)
  801f93:	6a 00                	push   $0x0
  801f95:	e8 5f ee ff ff       	call   800df9 <sys_page_alloc>
  801f9a:	89 c3                	mov    %eax,%ebx
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	0f 88 bc 00 00 00    	js     802063 <pipe+0x131>
	va = fd2data(fd0);
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	e8 2c f1 ff ff       	call   8010de <fd2data>
  801fb2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb4:	83 c4 0c             	add    $0xc,%esp
  801fb7:	68 07 04 00 00       	push   $0x407
  801fbc:	50                   	push   %eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 35 ee ff ff       	call   800df9 <sys_page_alloc>
  801fc4:	89 c3                	mov    %eax,%ebx
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	0f 88 82 00 00 00    	js     802053 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd7:	e8 02 f1 ff ff       	call   8010de <fd2data>
  801fdc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fe3:	50                   	push   %eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	56                   	push   %esi
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 4e ee ff ff       	call   800e3c <sys_page_map>
  801fee:	89 c3                	mov    %eax,%ebx
  801ff0:	83 c4 20             	add    $0x20,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 4e                	js     802045 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ff7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802004:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80200b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 f4             	pushl  -0xc(%ebp)
  802020:	e8 a9 f0 ff ff       	call   8010ce <fd2num>
  802025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802028:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80202a:	83 c4 04             	add    $0x4,%esp
  80202d:	ff 75 f0             	pushl  -0x10(%ebp)
  802030:	e8 99 f0 ff ff       	call   8010ce <fd2num>
  802035:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802038:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802043:	eb 2e                	jmp    802073 <pipe+0x141>
	sys_page_unmap(0, va);
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	56                   	push   %esi
  802049:	6a 00                	push   $0x0
  80204b:	e8 2e ee ff ff       	call   800e7e <sys_page_unmap>
  802050:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802053:	83 ec 08             	sub    $0x8,%esp
  802056:	ff 75 f0             	pushl  -0x10(%ebp)
  802059:	6a 00                	push   $0x0
  80205b:	e8 1e ee ff ff       	call   800e7e <sys_page_unmap>
  802060:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	ff 75 f4             	pushl  -0xc(%ebp)
  802069:	6a 00                	push   $0x0
  80206b:	e8 0e ee ff ff       	call   800e7e <sys_page_unmap>
  802070:	83 c4 10             	add    $0x10,%esp
}
  802073:	89 d8                	mov    %ebx,%eax
  802075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802078:	5b                   	pop    %ebx
  802079:	5e                   	pop    %esi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <pipeisclosed>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802082:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802085:	50                   	push   %eax
  802086:	ff 75 08             	pushl  0x8(%ebp)
  802089:	e8 b9 f0 ff ff       	call   801147 <fd_lookup>
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	85 c0                	test   %eax,%eax
  802093:	78 18                	js     8020ad <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	ff 75 f4             	pushl  -0xc(%ebp)
  80209b:	e8 3e f0 ff ff       	call   8010de <fd2data>
	return _pipeisclosed(fd, p);
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	e8 2f fd ff ff       	call   801dd9 <_pipeisclosed>
  8020aa:	83 c4 10             	add    $0x10,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	c3                   	ret    

008020b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020bb:	68 2f 2b 80 00       	push   $0x802b2f
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	e8 3f e9 ff ff       	call   800a07 <strcpy>
	return 0;
}
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <devcons_write>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	57                   	push   %edi
  8020d3:	56                   	push   %esi
  8020d4:	53                   	push   %ebx
  8020d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e9:	73 31                	jae    80211c <devcons_write+0x4d>
		m = n - tot;
  8020eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020ee:	29 f3                	sub    %esi,%ebx
  8020f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8020f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	53                   	push   %ebx
  8020ff:	89 f0                	mov    %esi,%eax
  802101:	03 45 0c             	add    0xc(%ebp),%eax
  802104:	50                   	push   %eax
  802105:	57                   	push   %edi
  802106:	e8 8a ea ff ff       	call   800b95 <memmove>
		sys_cputs(buf, m);
  80210b:	83 c4 08             	add    $0x8,%esp
  80210e:	53                   	push   %ebx
  80210f:	57                   	push   %edi
  802110:	e8 28 ec ff ff       	call   800d3d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802115:	01 de                	add    %ebx,%esi
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	eb ca                	jmp    8020e6 <devcons_write+0x17>
}
  80211c:	89 f0                	mov    %esi,%eax
  80211e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <devcons_read>:
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802135:	74 21                	je     802158 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802137:	e8 1f ec ff ff       	call   800d5b <sys_cgetc>
  80213c:	85 c0                	test   %eax,%eax
  80213e:	75 07                	jne    802147 <devcons_read+0x21>
		sys_yield();
  802140:	e8 95 ec ff ff       	call   800dda <sys_yield>
  802145:	eb f0                	jmp    802137 <devcons_read+0x11>
	if (c < 0)
  802147:	78 0f                	js     802158 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802149:	83 f8 04             	cmp    $0x4,%eax
  80214c:	74 0c                	je     80215a <devcons_read+0x34>
	*(char*)vbuf = c;
  80214e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802151:	88 02                	mov    %al,(%edx)
	return 1;
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    
		return 0;
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	eb f7                	jmp    802158 <devcons_read+0x32>

00802161 <cputchar>:
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80216d:	6a 01                	push   $0x1
  80216f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802172:	50                   	push   %eax
  802173:	e8 c5 eb ff ff       	call   800d3d <sys_cputs>
}
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <getchar>:
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802183:	6a 01                	push   $0x1
  802185:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802188:	50                   	push   %eax
  802189:	6a 00                	push   $0x0
  80218b:	e8 27 f2 ff ff       	call   8013b7 <read>
	if (r < 0)
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	85 c0                	test   %eax,%eax
  802195:	78 06                	js     80219d <getchar+0x20>
	if (r < 1)
  802197:	74 06                	je     80219f <getchar+0x22>
	return c;
  802199:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    
		return -E_EOF;
  80219f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021a4:	eb f7                	jmp    80219d <getchar+0x20>

008021a6 <iscons>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021af:	50                   	push   %eax
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	e8 8f ef ff ff       	call   801147 <fd_lookup>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 11                	js     8021d0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021c8:	39 10                	cmp    %edx,(%eax)
  8021ca:	0f 94 c0             	sete   %al
  8021cd:	0f b6 c0             	movzbl %al,%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <opencons>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	e8 14 ef ff ff       	call   8010f5 <fd_alloc>
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 3a                	js     802222 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 07 04 00 00       	push   $0x407
  8021f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f3:	6a 00                	push   $0x0
  8021f5:	e8 ff eb ff ff       	call   800df9 <sys_page_alloc>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	78 21                	js     802222 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80220a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	50                   	push   %eax
  80221a:	e8 af ee ff ff       	call   8010ce <fd2num>
  80221f:	83 c4 10             	add    $0x10,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	8b 75 08             	mov    0x8(%ebp),%esi
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802232:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802234:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802239:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	50                   	push   %eax
  802240:	e8 64 ed ff ff       	call   800fa9 <sys_ipc_recv>
	if(ret < 0){
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 2b                	js     802277 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80224c:	85 f6                	test   %esi,%esi
  80224e:	74 0a                	je     80225a <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802250:	a1 08 40 80 00       	mov    0x804008,%eax
  802255:	8b 40 74             	mov    0x74(%eax),%eax
  802258:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	74 0a                	je     802268 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80225e:	a1 08 40 80 00       	mov    0x804008,%eax
  802263:	8b 40 78             	mov    0x78(%eax),%eax
  802266:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802268:	a1 08 40 80 00       	mov    0x804008,%eax
  80226d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    
		if(from_env_store)
  802277:	85 f6                	test   %esi,%esi
  802279:	74 06                	je     802281 <ipc_recv+0x5d>
			*from_env_store = 0;
  80227b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802281:	85 db                	test   %ebx,%ebx
  802283:	74 eb                	je     802270 <ipc_recv+0x4c>
			*perm_store = 0;
  802285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80228b:	eb e3                	jmp    802270 <ipc_recv+0x4c>

0080228d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	57                   	push   %edi
  802291:	56                   	push   %esi
  802292:	53                   	push   %ebx
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	8b 7d 08             	mov    0x8(%ebp),%edi
  802299:	8b 75 0c             	mov    0xc(%ebp),%esi
  80229c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80229f:	85 db                	test   %ebx,%ebx
  8022a1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022a6:	0f 44 d8             	cmove  %eax,%ebx
  8022a9:	eb 05                	jmp    8022b0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022ab:	e8 2a eb ff ff       	call   800dda <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022b0:	ff 75 14             	pushl  0x14(%ebp)
  8022b3:	53                   	push   %ebx
  8022b4:	56                   	push   %esi
  8022b5:	57                   	push   %edi
  8022b6:	e8 cb ec ff ff       	call   800f86 <sys_ipc_try_send>
  8022bb:	83 c4 10             	add    $0x10,%esp
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 1b                	je     8022dd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022c2:	79 e7                	jns    8022ab <ipc_send+0x1e>
  8022c4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022c7:	74 e2                	je     8022ab <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 3b 2b 80 00       	push   $0x802b3b
  8022d1:	6a 48                	push   $0x48
  8022d3:	68 50 2b 80 00       	push   $0x802b50
  8022d8:	e8 d5 de ff ff       	call   8001b2 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    

008022e5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022f0:	89 c2                	mov    %eax,%edx
  8022f2:	c1 e2 07             	shl    $0x7,%edx
  8022f5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022fb:	8b 52 50             	mov    0x50(%edx),%edx
  8022fe:	39 ca                	cmp    %ecx,%edx
  802300:	74 11                	je     802313 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802302:	83 c0 01             	add    $0x1,%eax
  802305:	3d 00 04 00 00       	cmp    $0x400,%eax
  80230a:	75 e4                	jne    8022f0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80230c:	b8 00 00 00 00       	mov    $0x0,%eax
  802311:	eb 0b                	jmp    80231e <ipc_find_env+0x39>
			return envs[i].env_id;
  802313:	c1 e0 07             	shl    $0x7,%eax
  802316:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80231b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    

00802320 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802326:	89 d0                	mov    %edx,%eax
  802328:	c1 e8 16             	shr    $0x16,%eax
  80232b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802332:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802337:	f6 c1 01             	test   $0x1,%cl
  80233a:	74 1d                	je     802359 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80233c:	c1 ea 0c             	shr    $0xc,%edx
  80233f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802346:	f6 c2 01             	test   $0x1,%dl
  802349:	74 0e                	je     802359 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80234b:	c1 ea 0c             	shr    $0xc,%edx
  80234e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802355:	ef 
  802356:	0f b7 c0             	movzwl %ax,%eax
}
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    
  80235b:	66 90                	xchg   %ax,%ax
  80235d:	66 90                	xchg   %ax,%ax
  80235f:	90                   	nop

00802360 <__udivdi3>:
  802360:	55                   	push   %ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 1c             	sub    $0x1c,%esp
  802367:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80236b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80236f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802373:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802377:	85 d2                	test   %edx,%edx
  802379:	75 4d                	jne    8023c8 <__udivdi3+0x68>
  80237b:	39 f3                	cmp    %esi,%ebx
  80237d:	76 19                	jbe    802398 <__udivdi3+0x38>
  80237f:	31 ff                	xor    %edi,%edi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f2                	mov    %esi,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	89 d9                	mov    %ebx,%ecx
  80239a:	85 db                	test   %ebx,%ebx
  80239c:	75 0b                	jne    8023a9 <__udivdi3+0x49>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f3                	div    %ebx
  8023a7:	89 c1                	mov    %eax,%ecx
  8023a9:	31 d2                	xor    %edx,%edx
  8023ab:	89 f0                	mov    %esi,%eax
  8023ad:	f7 f1                	div    %ecx
  8023af:	89 c6                	mov    %eax,%esi
  8023b1:	89 e8                	mov    %ebp,%eax
  8023b3:	89 f7                	mov    %esi,%edi
  8023b5:	f7 f1                	div    %ecx
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	39 f2                	cmp    %esi,%edx
  8023ca:	77 1c                	ja     8023e8 <__udivdi3+0x88>
  8023cc:	0f bd fa             	bsr    %edx,%edi
  8023cf:	83 f7 1f             	xor    $0x1f,%edi
  8023d2:	75 2c                	jne    802400 <__udivdi3+0xa0>
  8023d4:	39 f2                	cmp    %esi,%edx
  8023d6:	72 06                	jb     8023de <__udivdi3+0x7e>
  8023d8:	31 c0                	xor    %eax,%eax
  8023da:	39 eb                	cmp    %ebp,%ebx
  8023dc:	77 a9                	ja     802387 <__udivdi3+0x27>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	eb a2                	jmp    802387 <__udivdi3+0x27>
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	31 ff                	xor    %edi,%edi
  8023ea:	31 c0                	xor    %eax,%eax
  8023ec:	89 fa                	mov    %edi,%edx
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	89 f9                	mov    %edi,%ecx
  802402:	b8 20 00 00 00       	mov    $0x20,%eax
  802407:	29 f8                	sub    %edi,%eax
  802409:	d3 e2                	shl    %cl,%edx
  80240b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	89 da                	mov    %ebx,%edx
  802413:	d3 ea                	shr    %cl,%edx
  802415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802419:	09 d1                	or     %edx,%ecx
  80241b:	89 f2                	mov    %esi,%edx
  80241d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802421:	89 f9                	mov    %edi,%ecx
  802423:	d3 e3                	shl    %cl,%ebx
  802425:	89 c1                	mov    %eax,%ecx
  802427:	d3 ea                	shr    %cl,%edx
  802429:	89 f9                	mov    %edi,%ecx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	89 eb                	mov    %ebp,%ebx
  802431:	d3 e6                	shl    %cl,%esi
  802433:	89 c1                	mov    %eax,%ecx
  802435:	d3 eb                	shr    %cl,%ebx
  802437:	09 de                	or     %ebx,%esi
  802439:	89 f0                	mov    %esi,%eax
  80243b:	f7 74 24 08          	divl   0x8(%esp)
  80243f:	89 d6                	mov    %edx,%esi
  802441:	89 c3                	mov    %eax,%ebx
  802443:	f7 64 24 0c          	mull   0xc(%esp)
  802447:	39 d6                	cmp    %edx,%esi
  802449:	72 15                	jb     802460 <__udivdi3+0x100>
  80244b:	89 f9                	mov    %edi,%ecx
  80244d:	d3 e5                	shl    %cl,%ebp
  80244f:	39 c5                	cmp    %eax,%ebp
  802451:	73 04                	jae    802457 <__udivdi3+0xf7>
  802453:	39 d6                	cmp    %edx,%esi
  802455:	74 09                	je     802460 <__udivdi3+0x100>
  802457:	89 d8                	mov    %ebx,%eax
  802459:	31 ff                	xor    %edi,%edi
  80245b:	e9 27 ff ff ff       	jmp    802387 <__udivdi3+0x27>
  802460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802463:	31 ff                	xor    %edi,%edi
  802465:	e9 1d ff ff ff       	jmp    802387 <__udivdi3+0x27>
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__umoddi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 1c             	sub    $0x1c,%esp
  802477:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80247b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80247f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802487:	89 da                	mov    %ebx,%edx
  802489:	85 c0                	test   %eax,%eax
  80248b:	75 43                	jne    8024d0 <__umoddi3+0x60>
  80248d:	39 df                	cmp    %ebx,%edi
  80248f:	76 17                	jbe    8024a8 <__umoddi3+0x38>
  802491:	89 f0                	mov    %esi,%eax
  802493:	f7 f7                	div    %edi
  802495:	89 d0                	mov    %edx,%eax
  802497:	31 d2                	xor    %edx,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 fd                	mov    %edi,%ebp
  8024aa:	85 ff                	test   %edi,%edi
  8024ac:	75 0b                	jne    8024b9 <__umoddi3+0x49>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f7                	div    %edi
  8024b7:	89 c5                	mov    %eax,%ebp
  8024b9:	89 d8                	mov    %ebx,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	f7 f5                	div    %ebp
  8024bf:	89 f0                	mov    %esi,%eax
  8024c1:	f7 f5                	div    %ebp
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	eb d0                	jmp    802497 <__umoddi3+0x27>
  8024c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	89 f1                	mov    %esi,%ecx
  8024d2:	39 d8                	cmp    %ebx,%eax
  8024d4:	76 0a                	jbe    8024e0 <__umoddi3+0x70>
  8024d6:	89 f0                	mov    %esi,%eax
  8024d8:	83 c4 1c             	add    $0x1c,%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    
  8024e0:	0f bd e8             	bsr    %eax,%ebp
  8024e3:	83 f5 1f             	xor    $0x1f,%ebp
  8024e6:	75 20                	jne    802508 <__umoddi3+0x98>
  8024e8:	39 d8                	cmp    %ebx,%eax
  8024ea:	0f 82 b0 00 00 00    	jb     8025a0 <__umoddi3+0x130>
  8024f0:	39 f7                	cmp    %esi,%edi
  8024f2:	0f 86 a8 00 00 00    	jbe    8025a0 <__umoddi3+0x130>
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	83 c4 1c             	add    $0x1c,%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5e                   	pop    %esi
  8024ff:	5f                   	pop    %edi
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	ba 20 00 00 00       	mov    $0x20,%edx
  80250f:	29 ea                	sub    %ebp,%edx
  802511:	d3 e0                	shl    %cl,%eax
  802513:	89 44 24 08          	mov    %eax,0x8(%esp)
  802517:	89 d1                	mov    %edx,%ecx
  802519:	89 f8                	mov    %edi,%eax
  80251b:	d3 e8                	shr    %cl,%eax
  80251d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802521:	89 54 24 04          	mov    %edx,0x4(%esp)
  802525:	8b 54 24 04          	mov    0x4(%esp),%edx
  802529:	09 c1                	or     %eax,%ecx
  80252b:	89 d8                	mov    %ebx,%eax
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 e9                	mov    %ebp,%ecx
  802533:	d3 e7                	shl    %cl,%edi
  802535:	89 d1                	mov    %edx,%ecx
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80253f:	d3 e3                	shl    %cl,%ebx
  802541:	89 c7                	mov    %eax,%edi
  802543:	89 d1                	mov    %edx,%ecx
  802545:	89 f0                	mov    %esi,%eax
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 fa                	mov    %edi,%edx
  80254d:	d3 e6                	shl    %cl,%esi
  80254f:	09 d8                	or     %ebx,%eax
  802551:	f7 74 24 08          	divl   0x8(%esp)
  802555:	89 d1                	mov    %edx,%ecx
  802557:	89 f3                	mov    %esi,%ebx
  802559:	f7 64 24 0c          	mull   0xc(%esp)
  80255d:	89 c6                	mov    %eax,%esi
  80255f:	89 d7                	mov    %edx,%edi
  802561:	39 d1                	cmp    %edx,%ecx
  802563:	72 06                	jb     80256b <__umoddi3+0xfb>
  802565:	75 10                	jne    802577 <__umoddi3+0x107>
  802567:	39 c3                	cmp    %eax,%ebx
  802569:	73 0c                	jae    802577 <__umoddi3+0x107>
  80256b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80256f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802573:	89 d7                	mov    %edx,%edi
  802575:	89 c6                	mov    %eax,%esi
  802577:	89 ca                	mov    %ecx,%edx
  802579:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80257e:	29 f3                	sub    %esi,%ebx
  802580:	19 fa                	sbb    %edi,%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	d3 e0                	shl    %cl,%eax
  802586:	89 e9                	mov    %ebp,%ecx
  802588:	d3 eb                	shr    %cl,%ebx
  80258a:	d3 ea                	shr    %cl,%edx
  80258c:	09 d8                	or     %ebx,%eax
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 da                	mov    %ebx,%edx
  8025a2:	29 fe                	sub    %edi,%esi
  8025a4:	19 c2                	sbb    %eax,%edx
  8025a6:	89 f1                	mov    %esi,%ecx
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	e9 4b ff ff ff       	jmp    8024fa <__umoddi3+0x8a>
