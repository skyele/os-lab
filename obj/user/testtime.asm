
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
  80003a:	e8 3f 10 00 00       	call   80107e <sys_time_msec>
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
  800055:	e8 24 10 00 00       	call   80107e <sys_time_msec>
  80005a:	39 d8                	cmp    %ebx,%eax
  80005c:	73 2d                	jae    80008b <sleep+0x58>
		sys_yield();
  80005e:	e8 ca 0d 00 00       	call   800e2d <sys_yield>
  800063:	eb f0                	jmp    800055 <sleep+0x22>
		panic("sys_time_msec: %e", (int)now);
  800065:	50                   	push   %eax
  800066:	68 40 26 80 00       	push   $0x802640
  80006b:	6a 0b                	push   $0xb
  80006d:	68 52 26 80 00       	push   $0x802652
  800072:	e8 8e 01 00 00       	call   800205 <_panic>
		panic("sleep: wrap");
  800077:	83 ec 04             	sub    $0x4,%esp
  80007a:	68 62 26 80 00       	push   $0x802662
  80007f:	6a 0d                	push   $0xd
  800081:	68 52 26 80 00       	push   $0x802652
  800086:	e8 7a 01 00 00       	call   800205 <_panic>
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
  80009c:	e8 8c 0d 00 00       	call   800e2d <sys_yield>
	for (i = 0; i < 50; i++)
  8000a1:	83 eb 01             	sub    $0x1,%ebx
  8000a4:	75 f6                	jne    80009c <umain+0xc>

	cprintf("starting count down: ");
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	68 6e 26 80 00       	push   $0x80266e
  8000ae:	e8 48 02 00 00       	call   8002fb <cprintf>
  8000b3:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b6:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	53                   	push   %ebx
  8000bf:	68 84 26 80 00       	push   $0x802684
  8000c4:	e8 32 02 00 00       	call   8002fb <cprintf>
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
  8000e3:	68 a4 26 80 00       	push   $0x8026a4
  8000e8:	e8 0e 02 00 00       	call   8002fb <cprintf>
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
  800109:	e8 00 0d 00 00       	call   800e0e <sys_getenvid>
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
  80012e:	74 23                	je     800153 <libmain+0x5d>
		if(envs[i].env_id == find)
  800130:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800136:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80013c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80013f:	39 c1                	cmp    %eax,%ecx
  800141:	75 e2                	jne    800125 <libmain+0x2f>
  800143:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800149:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80014f:	89 fe                	mov    %edi,%esi
  800151:	eb d2                	jmp    800125 <libmain+0x2f>
  800153:	89 f0                	mov    %esi,%eax
  800155:	84 c0                	test   %al,%al
  800157:	74 06                	je     80015f <libmain+0x69>
  800159:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800163:	7e 0a                	jle    80016f <libmain+0x79>
		binaryname = argv[0];
  800165:	8b 45 0c             	mov    0xc(%ebp),%eax
  800168:	8b 00                	mov    (%eax),%eax
  80016a:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80016f:	a1 08 40 80 00       	mov    0x804008,%eax
  800174:	8b 40 48             	mov    0x48(%eax),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	68 88 26 80 00       	push   $0x802688
  800180:	e8 76 01 00 00       	call   8002fb <cprintf>
	cprintf("before umain\n");
  800185:	c7 04 24 a6 26 80 00 	movl   $0x8026a6,(%esp)
  80018c:	e8 6a 01 00 00       	call   8002fb <cprintf>
	// call user main routine
	umain(argc, argv);
  800191:	83 c4 08             	add    $0x8,%esp
  800194:	ff 75 0c             	pushl  0xc(%ebp)
  800197:	ff 75 08             	pushl  0x8(%ebp)
  80019a:	e8 f1 fe ff ff       	call   800090 <umain>
	cprintf("after umain\n");
  80019f:	c7 04 24 b4 26 80 00 	movl   $0x8026b4,(%esp)
  8001a6:	e8 50 01 00 00       	call   8002fb <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8001b0:	8b 40 48             	mov    0x48(%eax),%eax
  8001b3:	83 c4 08             	add    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	68 c1 26 80 00       	push   $0x8026c1
  8001bc:	e8 3a 01 00 00       	call   8002fb <cprintf>
	// exit gracefully
	exit();
  8001c1:	e8 0b 00 00 00       	call   8001d1 <exit>
}
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    

008001d1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8001dc:	8b 40 48             	mov    0x48(%eax),%eax
  8001df:	68 ec 26 80 00       	push   $0x8026ec
  8001e4:	50                   	push   %eax
  8001e5:	68 e0 26 80 00       	push   $0x8026e0
  8001ea:	e8 0c 01 00 00       	call   8002fb <cprintf>
	close_all();
  8001ef:	e8 25 11 00 00       	call   801319 <close_all>
	sys_env_destroy(0);
  8001f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001fb:	e8 cd 0b 00 00       	call   800dcd <sys_env_destroy>
}
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80020a:	a1 08 40 80 00       	mov    0x804008,%eax
  80020f:	8b 40 48             	mov    0x48(%eax),%eax
  800212:	83 ec 04             	sub    $0x4,%esp
  800215:	68 18 27 80 00       	push   $0x802718
  80021a:	50                   	push   %eax
  80021b:	68 e0 26 80 00       	push   $0x8026e0
  800220:	e8 d6 00 00 00       	call   8002fb <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800225:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800228:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80022e:	e8 db 0b 00 00       	call   800e0e <sys_getenvid>
  800233:	83 c4 04             	add    $0x4,%esp
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	56                   	push   %esi
  80023d:	50                   	push   %eax
  80023e:	68 f4 26 80 00       	push   $0x8026f4
  800243:	e8 b3 00 00 00       	call   8002fb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800248:	83 c4 18             	add    $0x18,%esp
  80024b:	53                   	push   %ebx
  80024c:	ff 75 10             	pushl  0x10(%ebp)
  80024f:	e8 56 00 00 00       	call   8002aa <vcprintf>
	cprintf("\n");
  800254:	c7 04 24 a4 26 80 00 	movl   $0x8026a4,(%esp)
  80025b:	e8 9b 00 00 00       	call   8002fb <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800263:	cc                   	int3   
  800264:	eb fd                	jmp    800263 <_panic+0x5e>

00800266 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	53                   	push   %ebx
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800270:	8b 13                	mov    (%ebx),%edx
  800272:	8d 42 01             	lea    0x1(%edx),%eax
  800275:	89 03                	mov    %eax,(%ebx)
  800277:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80027a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80027e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800283:	74 09                	je     80028e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800285:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	68 ff 00 00 00       	push   $0xff
  800296:	8d 43 08             	lea    0x8(%ebx),%eax
  800299:	50                   	push   %eax
  80029a:	e8 f1 0a 00 00       	call   800d90 <sys_cputs>
		b->idx = 0;
  80029f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	eb db                	jmp    800285 <putch+0x1f>

008002aa <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002b3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ba:	00 00 00 
	b.cnt = 0;
  8002bd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002c4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ca:	ff 75 08             	pushl  0x8(%ebp)
  8002cd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	68 66 02 80 00       	push   $0x800266
  8002d9:	e8 4a 01 00 00       	call   800428 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002de:	83 c4 08             	add    $0x8,%esp
  8002e1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002e7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ed:	50                   	push   %eax
  8002ee:	e8 9d 0a 00 00       	call   800d90 <sys_cputs>

	return b.cnt;
}
  8002f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800301:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800304:	50                   	push   %eax
  800305:	ff 75 08             	pushl  0x8(%ebp)
  800308:	e8 9d ff ff ff       	call   8002aa <vcprintf>
	va_end(ap);

	return cnt;
}
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	57                   	push   %edi
  800313:	56                   	push   %esi
  800314:	53                   	push   %ebx
  800315:	83 ec 1c             	sub    $0x1c,%esp
  800318:	89 c6                	mov    %eax,%esi
  80031a:	89 d7                	mov    %edx,%edi
  80031c:	8b 45 08             	mov    0x8(%ebp),%eax
  80031f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800322:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800325:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800328:	8b 45 10             	mov    0x10(%ebp),%eax
  80032b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80032e:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800332:	74 2c                	je     800360 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80033e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800344:	39 c2                	cmp    %eax,%edx
  800346:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800349:	73 43                	jae    80038e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80034b:	83 eb 01             	sub    $0x1,%ebx
  80034e:	85 db                	test   %ebx,%ebx
  800350:	7e 6c                	jle    8003be <printnum+0xaf>
				putch(padc, putdat);
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	57                   	push   %edi
  800356:	ff 75 18             	pushl  0x18(%ebp)
  800359:	ff d6                	call   *%esi
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	eb eb                	jmp    80034b <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 20                	push   $0x20
  800365:	6a 00                	push   $0x0
  800367:	50                   	push   %eax
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	ff 75 e0             	pushl  -0x20(%ebp)
  80036e:	89 fa                	mov    %edi,%edx
  800370:	89 f0                	mov    %esi,%eax
  800372:	e8 98 ff ff ff       	call   80030f <printnum>
		while (--width > 0)
  800377:	83 c4 20             	add    $0x20,%esp
  80037a:	83 eb 01             	sub    $0x1,%ebx
  80037d:	85 db                	test   %ebx,%ebx
  80037f:	7e 65                	jle    8003e6 <printnum+0xd7>
			putch(padc, putdat);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	57                   	push   %edi
  800385:	6a 20                	push   $0x20
  800387:	ff d6                	call   *%esi
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	eb ec                	jmp    80037a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	ff 75 18             	pushl  0x18(%ebp)
  800394:	83 eb 01             	sub    $0x1,%ebx
  800397:	53                   	push   %ebx
  800398:	50                   	push   %eax
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	ff 75 dc             	pushl  -0x24(%ebp)
  80039f:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a8:	e8 33 20 00 00       	call   8023e0 <__udivdi3>
  8003ad:	83 c4 18             	add    $0x18,%esp
  8003b0:	52                   	push   %edx
  8003b1:	50                   	push   %eax
  8003b2:	89 fa                	mov    %edi,%edx
  8003b4:	89 f0                	mov    %esi,%eax
  8003b6:	e8 54 ff ff ff       	call   80030f <printnum>
  8003bb:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	57                   	push   %edi
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d1:	e8 1a 21 00 00       	call   8024f0 <__umoddi3>
  8003d6:	83 c4 14             	add    $0x14,%esp
  8003d9:	0f be 80 1f 27 80 00 	movsbl 0x80271f(%eax),%eax
  8003e0:	50                   	push   %eax
  8003e1:	ff d6                	call   *%esi
  8003e3:	83 c4 10             	add    $0x10,%esp
	}
}
  8003e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5f                   	pop    %edi
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	88 02                	mov    %al,(%edx)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <printfmt>:
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800411:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800414:	50                   	push   %eax
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 05 00 00 00       	call   800428 <vprintfmt>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <vprintfmt>:
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	57                   	push   %edi
  80042c:	56                   	push   %esi
  80042d:	53                   	push   %ebx
  80042e:	83 ec 3c             	sub    $0x3c,%esp
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800437:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043a:	e9 32 04 00 00       	jmp    800871 <vprintfmt+0x449>
		padc = ' ';
  80043f:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800443:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80044a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800451:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800458:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80045f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800466:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8d 47 01             	lea    0x1(%edi),%eax
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800471:	0f b6 17             	movzbl (%edi),%edx
  800474:	8d 42 dd             	lea    -0x23(%edx),%eax
  800477:	3c 55                	cmp    $0x55,%al
  800479:	0f 87 12 05 00 00    	ja     800991 <vprintfmt+0x569>
  80047f:	0f b6 c0             	movzbl %al,%eax
  800482:	ff 24 85 00 29 80 00 	jmp    *0x802900(,%eax,4)
  800489:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80048c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800490:	eb d9                	jmp    80046b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800495:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800499:	eb d0                	jmp    80046b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	0f b6 d2             	movzbl %dl,%edx
  80049e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a9:	eb 03                	jmp    8004ae <vprintfmt+0x86>
  8004ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004b1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004b5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b8:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004bb:	83 fe 09             	cmp    $0x9,%esi
  8004be:	76 eb                	jbe    8004ab <vprintfmt+0x83>
  8004c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c6:	eb 14                	jmp    8004dc <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 40 04             	lea    0x4(%eax),%eax
  8004d6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e0:	79 89                	jns    80046b <vprintfmt+0x43>
				width = precision, precision = -1;
  8004e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004ef:	e9 77 ff ff ff       	jmp    80046b <vprintfmt+0x43>
  8004f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f7:	85 c0                	test   %eax,%eax
  8004f9:	0f 48 c1             	cmovs  %ecx,%eax
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800502:	e9 64 ff ff ff       	jmp    80046b <vprintfmt+0x43>
  800507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80050a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800511:	e9 55 ff ff ff       	jmp    80046b <vprintfmt+0x43>
			lflag++;
  800516:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051d:	e9 49 ff ff ff       	jmp    80046b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 78 04             	lea    0x4(%eax),%edi
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	ff 30                	pushl  (%eax)
  80052e:	ff d6                	call   *%esi
			break;
  800530:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800533:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800536:	e9 33 03 00 00       	jmp    80086e <vprintfmt+0x446>
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 78 04             	lea    0x4(%eax),%edi
  800541:	8b 00                	mov    (%eax),%eax
  800543:	99                   	cltd   
  800544:	31 d0                	xor    %edx,%eax
  800546:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800548:	83 f8 11             	cmp    $0x11,%eax
  80054b:	7f 23                	jg     800570 <vprintfmt+0x148>
  80054d:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  800554:	85 d2                	test   %edx,%edx
  800556:	74 18                	je     800570 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800558:	52                   	push   %edx
  800559:	68 81 2b 80 00       	push   $0x802b81
  80055e:	53                   	push   %ebx
  80055f:	56                   	push   %esi
  800560:	e8 a6 fe ff ff       	call   80040b <printfmt>
  800565:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800568:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056b:	e9 fe 02 00 00       	jmp    80086e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800570:	50                   	push   %eax
  800571:	68 37 27 80 00       	push   $0x802737
  800576:	53                   	push   %ebx
  800577:	56                   	push   %esi
  800578:	e8 8e fe ff ff       	call   80040b <printfmt>
  80057d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800580:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800583:	e9 e6 02 00 00       	jmp    80086e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	83 c0 04             	add    $0x4,%eax
  80058e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800596:	85 c9                	test   %ecx,%ecx
  800598:	b8 30 27 80 00       	mov    $0x802730,%eax
  80059d:	0f 45 c1             	cmovne %ecx,%eax
  8005a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a7:	7e 06                	jle    8005af <vprintfmt+0x187>
  8005a9:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005ad:	75 0d                	jne    8005bc <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005b2:	89 c7                	mov    %eax,%edi
  8005b4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	eb 53                	jmp    80060f <vprintfmt+0x1e7>
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c2:	50                   	push   %eax
  8005c3:	e8 71 04 00 00       	call   800a39 <strnlen>
  8005c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005cb:	29 c1                	sub    %eax,%ecx
  8005cd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005d5:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dc:	eb 0f                	jmp    8005ed <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e7:	83 ef 01             	sub    $0x1,%edi
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	85 ff                	test   %edi,%edi
  8005ef:	7f ed                	jg     8005de <vprintfmt+0x1b6>
  8005f1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005f4:	85 c9                	test   %ecx,%ecx
  8005f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fb:	0f 49 c1             	cmovns %ecx,%eax
  8005fe:	29 c1                	sub    %eax,%ecx
  800600:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800603:	eb aa                	jmp    8005af <vprintfmt+0x187>
					putch(ch, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	52                   	push   %edx
  80060a:	ff d6                	call   *%esi
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800612:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800614:	83 c7 01             	add    $0x1,%edi
  800617:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061b:	0f be d0             	movsbl %al,%edx
  80061e:	85 d2                	test   %edx,%edx
  800620:	74 4b                	je     80066d <vprintfmt+0x245>
  800622:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800626:	78 06                	js     80062e <vprintfmt+0x206>
  800628:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062c:	78 1e                	js     80064c <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80062e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800632:	74 d1                	je     800605 <vprintfmt+0x1dd>
  800634:	0f be c0             	movsbl %al,%eax
  800637:	83 e8 20             	sub    $0x20,%eax
  80063a:	83 f8 5e             	cmp    $0x5e,%eax
  80063d:	76 c6                	jbe    800605 <vprintfmt+0x1dd>
					putch('?', putdat);
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	53                   	push   %ebx
  800643:	6a 3f                	push   $0x3f
  800645:	ff d6                	call   *%esi
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	eb c3                	jmp    80060f <vprintfmt+0x1e7>
  80064c:	89 cf                	mov    %ecx,%edi
  80064e:	eb 0e                	jmp    80065e <vprintfmt+0x236>
				putch(' ', putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	6a 20                	push   $0x20
  800656:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800658:	83 ef 01             	sub    $0x1,%edi
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	85 ff                	test   %edi,%edi
  800660:	7f ee                	jg     800650 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800662:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
  800668:	e9 01 02 00 00       	jmp    80086e <vprintfmt+0x446>
  80066d:	89 cf                	mov    %ecx,%edi
  80066f:	eb ed                	jmp    80065e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800671:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800674:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80067b:	e9 eb fd ff ff       	jmp    80046b <vprintfmt+0x43>
	if (lflag >= 2)
  800680:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800684:	7f 21                	jg     8006a7 <vprintfmt+0x27f>
	else if (lflag)
  800686:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80068a:	74 68                	je     8006f4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800694:	89 c1                	mov    %eax,%ecx
  800696:	c1 f9 1f             	sar    $0x1f,%ecx
  800699:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb 17                	jmp    8006be <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006ce:	78 3f                	js     80070f <vprintfmt+0x2e7>
			base = 10;
  8006d0:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006d5:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006d9:	0f 84 71 01 00 00    	je     800850 <vprintfmt+0x428>
				putch('+', putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 2b                	push   $0x2b
  8006e5:	ff d6                	call   *%esi
  8006e7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ef:	e9 5c 01 00 00       	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006fc:	89 c1                	mov    %eax,%ecx
  8006fe:	c1 f9 1f             	sar    $0x1f,%ecx
  800701:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
  80070d:	eb af                	jmp    8006be <vprintfmt+0x296>
				putch('-', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	6a 2d                	push   $0x2d
  800715:	ff d6                	call   *%esi
				num = -(long long) num;
  800717:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80071a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80071d:	f7 d8                	neg    %eax
  80071f:	83 d2 00             	adc    $0x0,%edx
  800722:	f7 da                	neg    %edx
  800724:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800727:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80072d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800732:	e9 19 01 00 00       	jmp    800850 <vprintfmt+0x428>
	if (lflag >= 2)
  800737:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073b:	7f 29                	jg     800766 <vprintfmt+0x33e>
	else if (lflag)
  80073d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800741:	74 44                	je     800787 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800761:	e9 ea 00 00 00       	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 50 04             	mov    0x4(%eax),%edx
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800771:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 40 08             	lea    0x8(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800782:	e9 c9 00 00 00       	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	ba 00 00 00 00       	mov    $0x0,%edx
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a5:	e9 a6 00 00 00       	jmp    800850 <vprintfmt+0x428>
			putch('0', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	6a 30                	push   $0x30
  8007b0:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007b9:	7f 26                	jg     8007e1 <vprintfmt+0x3b9>
	else if (lflag)
  8007bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007bf:	74 3e                	je     8007ff <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8d 40 04             	lea    0x4(%eax),%eax
  8007d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007da:	b8 08 00 00 00       	mov    $0x8,%eax
  8007df:	eb 6f                	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8b 50 04             	mov    0x4(%eax),%edx
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 40 08             	lea    0x8(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007fd:	eb 51                	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800818:	b8 08 00 00 00       	mov    $0x8,%eax
  80081d:	eb 31                	jmp    800850 <vprintfmt+0x428>
			putch('0', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	53                   	push   %ebx
  800823:	6a 30                	push   $0x30
  800825:	ff d6                	call   *%esi
			putch('x', putdat);
  800827:	83 c4 08             	add    $0x8,%esp
  80082a:	53                   	push   %ebx
  80082b:	6a 78                	push   $0x78
  80082d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80083f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8d 40 04             	lea    0x4(%eax),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800850:	83 ec 0c             	sub    $0xc,%esp
  800853:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800857:	52                   	push   %edx
  800858:	ff 75 e0             	pushl  -0x20(%ebp)
  80085b:	50                   	push   %eax
  80085c:	ff 75 dc             	pushl  -0x24(%ebp)
  80085f:	ff 75 d8             	pushl  -0x28(%ebp)
  800862:	89 da                	mov    %ebx,%edx
  800864:	89 f0                	mov    %esi,%eax
  800866:	e8 a4 fa ff ff       	call   80030f <printnum>
			break;
  80086b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80086e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800871:	83 c7 01             	add    $0x1,%edi
  800874:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800878:	83 f8 25             	cmp    $0x25,%eax
  80087b:	0f 84 be fb ff ff    	je     80043f <vprintfmt+0x17>
			if (ch == '\0')
  800881:	85 c0                	test   %eax,%eax
  800883:	0f 84 28 01 00 00    	je     8009b1 <vprintfmt+0x589>
			putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	50                   	push   %eax
  80088e:	ff d6                	call   *%esi
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	eb dc                	jmp    800871 <vprintfmt+0x449>
	if (lflag >= 2)
  800895:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800899:	7f 26                	jg     8008c1 <vprintfmt+0x499>
	else if (lflag)
  80089b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80089f:	74 41                	je     8008e2 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8d 40 04             	lea    0x4(%eax),%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8008bf:	eb 8f                	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 50 04             	mov    0x4(%eax),%edx
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 40 08             	lea    0x8(%eax),%eax
  8008d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008dd:	e9 6e ff ff ff       	jmp    800850 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8d 40 04             	lea    0x4(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008fb:	b8 10 00 00 00       	mov    $0x10,%eax
  800900:	e9 4b ff ff ff       	jmp    800850 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	83 c0 04             	add    $0x4,%eax
  80090b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	85 c0                	test   %eax,%eax
  800915:	74 14                	je     80092b <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800917:	8b 13                	mov    (%ebx),%edx
  800919:	83 fa 7f             	cmp    $0x7f,%edx
  80091c:	7f 37                	jg     800955 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80091e:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800920:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	e9 43 ff ff ff       	jmp    80086e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80092b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800930:	bf 55 28 80 00       	mov    $0x802855,%edi
							putch(ch, putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	53                   	push   %ebx
  800939:	50                   	push   %eax
  80093a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80093c:	83 c7 01             	add    $0x1,%edi
  80093f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	85 c0                	test   %eax,%eax
  800948:	75 eb                	jne    800935 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80094a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
  800950:	e9 19 ff ff ff       	jmp    80086e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800955:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800957:	b8 0a 00 00 00       	mov    $0xa,%eax
  80095c:	bf 8d 28 80 00       	mov    $0x80288d,%edi
							putch(ch, putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	53                   	push   %ebx
  800965:	50                   	push   %eax
  800966:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800968:	83 c7 01             	add    $0x1,%edi
  80096b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	85 c0                	test   %eax,%eax
  800974:	75 eb                	jne    800961 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800976:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800979:	89 45 14             	mov    %eax,0x14(%ebp)
  80097c:	e9 ed fe ff ff       	jmp    80086e <vprintfmt+0x446>
			putch(ch, putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	53                   	push   %ebx
  800985:	6a 25                	push   $0x25
  800987:	ff d6                	call   *%esi
			break;
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	e9 dd fe ff ff       	jmp    80086e <vprintfmt+0x446>
			putch('%', putdat);
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	53                   	push   %ebx
  800995:	6a 25                	push   $0x25
  800997:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800999:	83 c4 10             	add    $0x10,%esp
  80099c:	89 f8                	mov    %edi,%eax
  80099e:	eb 03                	jmp    8009a3 <vprintfmt+0x57b>
  8009a0:	83 e8 01             	sub    $0x1,%eax
  8009a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009a7:	75 f7                	jne    8009a0 <vprintfmt+0x578>
  8009a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ac:	e9 bd fe ff ff       	jmp    80086e <vprintfmt+0x446>
}
  8009b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5f                   	pop    %edi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 18             	sub    $0x18,%esp
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009cc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d6:	85 c0                	test   %eax,%eax
  8009d8:	74 26                	je     800a00 <vsnprintf+0x47>
  8009da:	85 d2                	test   %edx,%edx
  8009dc:	7e 22                	jle    800a00 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009de:	ff 75 14             	pushl  0x14(%ebp)
  8009e1:	ff 75 10             	pushl  0x10(%ebp)
  8009e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e7:	50                   	push   %eax
  8009e8:	68 ee 03 80 00       	push   $0x8003ee
  8009ed:	e8 36 fa ff ff       	call   800428 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    
		return -E_INVAL;
  800a00:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a05:	eb f7                	jmp    8009fe <vsnprintf+0x45>

00800a07 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a0d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a10:	50                   	push   %eax
  800a11:	ff 75 10             	pushl  0x10(%ebp)
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	e8 9a ff ff ff       	call   8009b9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a27:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a30:	74 05                	je     800a37 <strlen+0x16>
		n++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	eb f5                	jmp    800a2c <strlen+0xb>
	return n;
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a42:	ba 00 00 00 00       	mov    $0x0,%edx
  800a47:	39 c2                	cmp    %eax,%edx
  800a49:	74 0d                	je     800a58 <strnlen+0x1f>
  800a4b:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a4f:	74 05                	je     800a56 <strnlen+0x1d>
		n++;
  800a51:	83 c2 01             	add    $0x1,%edx
  800a54:	eb f1                	jmp    800a47 <strnlen+0xe>
  800a56:	89 d0                	mov    %edx,%eax
	return n;
}
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	53                   	push   %ebx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a64:	ba 00 00 00 00       	mov    $0x0,%edx
  800a69:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a6d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	84 c9                	test   %cl,%cl
  800a75:	75 f2                	jne    800a69 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a77:	5b                   	pop    %ebx
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	53                   	push   %ebx
  800a7e:	83 ec 10             	sub    $0x10,%esp
  800a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a84:	53                   	push   %ebx
  800a85:	e8 97 ff ff ff       	call   800a21 <strlen>
  800a8a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	01 d8                	add    %ebx,%eax
  800a92:	50                   	push   %eax
  800a93:	e8 c2 ff ff ff       	call   800a5a <strcpy>
	return dst;
}
  800a98:	89 d8                	mov    %ebx,%eax
  800a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aaa:	89 c6                	mov    %eax,%esi
  800aac:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aaf:	89 c2                	mov    %eax,%edx
  800ab1:	39 f2                	cmp    %esi,%edx
  800ab3:	74 11                	je     800ac6 <strncpy+0x27>
		*dst++ = *src;
  800ab5:	83 c2 01             	add    $0x1,%edx
  800ab8:	0f b6 19             	movzbl (%ecx),%ebx
  800abb:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800abe:	80 fb 01             	cmp    $0x1,%bl
  800ac1:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ac4:	eb eb                	jmp    800ab1 <strncpy+0x12>
	}
	return ret;
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad5:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ada:	85 d2                	test   %edx,%edx
  800adc:	74 21                	je     800aff <strlcpy+0x35>
  800ade:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ae2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ae4:	39 c2                	cmp    %eax,%edx
  800ae6:	74 14                	je     800afc <strlcpy+0x32>
  800ae8:	0f b6 19             	movzbl (%ecx),%ebx
  800aeb:	84 db                	test   %bl,%bl
  800aed:	74 0b                	je     800afa <strlcpy+0x30>
			*dst++ = *src++;
  800aef:	83 c1 01             	add    $0x1,%ecx
  800af2:	83 c2 01             	add    $0x1,%edx
  800af5:	88 5a ff             	mov    %bl,-0x1(%edx)
  800af8:	eb ea                	jmp    800ae4 <strlcpy+0x1a>
  800afa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800afc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aff:	29 f0                	sub    %esi,%eax
}
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b0e:	0f b6 01             	movzbl (%ecx),%eax
  800b11:	84 c0                	test   %al,%al
  800b13:	74 0c                	je     800b21 <strcmp+0x1c>
  800b15:	3a 02                	cmp    (%edx),%al
  800b17:	75 08                	jne    800b21 <strcmp+0x1c>
		p++, q++;
  800b19:	83 c1 01             	add    $0x1,%ecx
  800b1c:	83 c2 01             	add    $0x1,%edx
  800b1f:	eb ed                	jmp    800b0e <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b21:	0f b6 c0             	movzbl %al,%eax
  800b24:	0f b6 12             	movzbl (%edx),%edx
  800b27:	29 d0                	sub    %edx,%eax
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	89 c3                	mov    %eax,%ebx
  800b37:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b3a:	eb 06                	jmp    800b42 <strncmp+0x17>
		n--, p++, q++;
  800b3c:	83 c0 01             	add    $0x1,%eax
  800b3f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b42:	39 d8                	cmp    %ebx,%eax
  800b44:	74 16                	je     800b5c <strncmp+0x31>
  800b46:	0f b6 08             	movzbl (%eax),%ecx
  800b49:	84 c9                	test   %cl,%cl
  800b4b:	74 04                	je     800b51 <strncmp+0x26>
  800b4d:	3a 0a                	cmp    (%edx),%cl
  800b4f:	74 eb                	je     800b3c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b51:	0f b6 00             	movzbl (%eax),%eax
  800b54:	0f b6 12             	movzbl (%edx),%edx
  800b57:	29 d0                	sub    %edx,%eax
}
  800b59:	5b                   	pop    %ebx
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    
		return 0;
  800b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b61:	eb f6                	jmp    800b59 <strncmp+0x2e>

00800b63 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	74 09                	je     800b7d <strchr+0x1a>
		if (*s == c)
  800b74:	38 ca                	cmp    %cl,%dl
  800b76:	74 0a                	je     800b82 <strchr+0x1f>
	for (; *s; s++)
  800b78:	83 c0 01             	add    $0x1,%eax
  800b7b:	eb f0                	jmp    800b6d <strchr+0xa>
			return (char *) s;
	return 0;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b91:	38 ca                	cmp    %cl,%dl
  800b93:	74 09                	je     800b9e <strfind+0x1a>
  800b95:	84 d2                	test   %dl,%dl
  800b97:	74 05                	je     800b9e <strfind+0x1a>
	for (; *s; s++)
  800b99:	83 c0 01             	add    $0x1,%eax
  800b9c:	eb f0                	jmp    800b8e <strfind+0xa>
			break;
	return (char *) s;
}
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bac:	85 c9                	test   %ecx,%ecx
  800bae:	74 31                	je     800be1 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb0:	89 f8                	mov    %edi,%eax
  800bb2:	09 c8                	or     %ecx,%eax
  800bb4:	a8 03                	test   $0x3,%al
  800bb6:	75 23                	jne    800bdb <memset+0x3b>
		c &= 0xFF;
  800bb8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbc:	89 d3                	mov    %edx,%ebx
  800bbe:	c1 e3 08             	shl    $0x8,%ebx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	c1 e0 18             	shl    $0x18,%eax
  800bc6:	89 d6                	mov    %edx,%esi
  800bc8:	c1 e6 10             	shl    $0x10,%esi
  800bcb:	09 f0                	or     %esi,%eax
  800bcd:	09 c2                	or     %eax,%edx
  800bcf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd4:	89 d0                	mov    %edx,%eax
  800bd6:	fc                   	cld    
  800bd7:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd9:	eb 06                	jmp    800be1 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	fc                   	cld    
  800bdf:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be1:	89 f8                	mov    %edi,%eax
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf6:	39 c6                	cmp    %eax,%esi
  800bf8:	73 32                	jae    800c2c <memmove+0x44>
  800bfa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfd:	39 c2                	cmp    %eax,%edx
  800bff:	76 2b                	jbe    800c2c <memmove+0x44>
		s += n;
		d += n;
  800c01:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c04:	89 fe                	mov    %edi,%esi
  800c06:	09 ce                	or     %ecx,%esi
  800c08:	09 d6                	or     %edx,%esi
  800c0a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c10:	75 0e                	jne    800c20 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c12:	83 ef 04             	sub    $0x4,%edi
  800c15:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1b:	fd                   	std    
  800c1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1e:	eb 09                	jmp    800c29 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c20:	83 ef 01             	sub    $0x1,%edi
  800c23:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c26:	fd                   	std    
  800c27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c29:	fc                   	cld    
  800c2a:	eb 1a                	jmp    800c46 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2c:	89 c2                	mov    %eax,%edx
  800c2e:	09 ca                	or     %ecx,%edx
  800c30:	09 f2                	or     %esi,%edx
  800c32:	f6 c2 03             	test   $0x3,%dl
  800c35:	75 0a                	jne    800c41 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c37:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3a:	89 c7                	mov    %eax,%edi
  800c3c:	fc                   	cld    
  800c3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c3f:	eb 05                	jmp    800c46 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c41:	89 c7                	mov    %eax,%edi
  800c43:	fc                   	cld    
  800c44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c50:	ff 75 10             	pushl  0x10(%ebp)
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 8a ff ff ff       	call   800be8 <memmove>
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6b:	89 c6                	mov    %eax,%esi
  800c6d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c70:	39 f0                	cmp    %esi,%eax
  800c72:	74 1c                	je     800c90 <memcmp+0x30>
		if (*s1 != *s2)
  800c74:	0f b6 08             	movzbl (%eax),%ecx
  800c77:	0f b6 1a             	movzbl (%edx),%ebx
  800c7a:	38 d9                	cmp    %bl,%cl
  800c7c:	75 08                	jne    800c86 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c7e:	83 c0 01             	add    $0x1,%eax
  800c81:	83 c2 01             	add    $0x1,%edx
  800c84:	eb ea                	jmp    800c70 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c86:	0f b6 c1             	movzbl %cl,%eax
  800c89:	0f b6 db             	movzbl %bl,%ebx
  800c8c:	29 d8                	sub    %ebx,%eax
  800c8e:	eb 05                	jmp    800c95 <memcmp+0x35>
	}

	return 0;
  800c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ca2:	89 c2                	mov    %eax,%edx
  800ca4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ca7:	39 d0                	cmp    %edx,%eax
  800ca9:	73 09                	jae    800cb4 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cab:	38 08                	cmp    %cl,(%eax)
  800cad:	74 05                	je     800cb4 <memfind+0x1b>
	for (; s < ends; s++)
  800caf:	83 c0 01             	add    $0x1,%eax
  800cb2:	eb f3                	jmp    800ca7 <memfind+0xe>
			break;
	return (void *) s;
}
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
  800cbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc2:	eb 03                	jmp    800cc7 <strtol+0x11>
		s++;
  800cc4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cc7:	0f b6 01             	movzbl (%ecx),%eax
  800cca:	3c 20                	cmp    $0x20,%al
  800ccc:	74 f6                	je     800cc4 <strtol+0xe>
  800cce:	3c 09                	cmp    $0x9,%al
  800cd0:	74 f2                	je     800cc4 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cd2:	3c 2b                	cmp    $0x2b,%al
  800cd4:	74 2a                	je     800d00 <strtol+0x4a>
	int neg = 0;
  800cd6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cdb:	3c 2d                	cmp    $0x2d,%al
  800cdd:	74 2b                	je     800d0a <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cdf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ce5:	75 0f                	jne    800cf6 <strtol+0x40>
  800ce7:	80 39 30             	cmpb   $0x30,(%ecx)
  800cea:	74 28                	je     800d14 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cec:	85 db                	test   %ebx,%ebx
  800cee:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf3:	0f 44 d8             	cmove  %eax,%ebx
  800cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cfe:	eb 50                	jmp    800d50 <strtol+0x9a>
		s++;
  800d00:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d03:	bf 00 00 00 00       	mov    $0x0,%edi
  800d08:	eb d5                	jmp    800cdf <strtol+0x29>
		s++, neg = 1;
  800d0a:	83 c1 01             	add    $0x1,%ecx
  800d0d:	bf 01 00 00 00       	mov    $0x1,%edi
  800d12:	eb cb                	jmp    800cdf <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d14:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d18:	74 0e                	je     800d28 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d1a:	85 db                	test   %ebx,%ebx
  800d1c:	75 d8                	jne    800cf6 <strtol+0x40>
		s++, base = 8;
  800d1e:	83 c1 01             	add    $0x1,%ecx
  800d21:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d26:	eb ce                	jmp    800cf6 <strtol+0x40>
		s += 2, base = 16;
  800d28:	83 c1 02             	add    $0x2,%ecx
  800d2b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d30:	eb c4                	jmp    800cf6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d32:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d35:	89 f3                	mov    %esi,%ebx
  800d37:	80 fb 19             	cmp    $0x19,%bl
  800d3a:	77 29                	ja     800d65 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d3c:	0f be d2             	movsbl %dl,%edx
  800d3f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d42:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d45:	7d 30                	jge    800d77 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d47:	83 c1 01             	add    $0x1,%ecx
  800d4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d4e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d50:	0f b6 11             	movzbl (%ecx),%edx
  800d53:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d56:	89 f3                	mov    %esi,%ebx
  800d58:	80 fb 09             	cmp    $0x9,%bl
  800d5b:	77 d5                	ja     800d32 <strtol+0x7c>
			dig = *s - '0';
  800d5d:	0f be d2             	movsbl %dl,%edx
  800d60:	83 ea 30             	sub    $0x30,%edx
  800d63:	eb dd                	jmp    800d42 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d65:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d68:	89 f3                	mov    %esi,%ebx
  800d6a:	80 fb 19             	cmp    $0x19,%bl
  800d6d:	77 08                	ja     800d77 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d6f:	0f be d2             	movsbl %dl,%edx
  800d72:	83 ea 37             	sub    $0x37,%edx
  800d75:	eb cb                	jmp    800d42 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d7b:	74 05                	je     800d82 <strtol+0xcc>
		*endptr = (char *) s;
  800d7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d80:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d82:	89 c2                	mov    %eax,%edx
  800d84:	f7 da                	neg    %edx
  800d86:	85 ff                	test   %edi,%edi
  800d88:	0f 45 c2             	cmovne %edx,%eax
}
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	89 c3                	mov    %eax,%ebx
  800da3:	89 c7                	mov    %eax,%edi
  800da5:	89 c6                	mov    %eax,%esi
  800da7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <sys_cgetc>:

int
sys_cgetc(void)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db4:	ba 00 00 00 00       	mov    $0x0,%edx
  800db9:	b8 01 00 00 00       	mov    $0x1,%eax
  800dbe:	89 d1                	mov    %edx,%ecx
  800dc0:	89 d3                	mov    %edx,%ebx
  800dc2:	89 d7                	mov    %edx,%edi
  800dc4:	89 d6                	mov    %edx,%esi
  800dc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	b8 03 00 00 00       	mov    $0x3,%eax
  800de3:	89 cb                	mov    %ecx,%ebx
  800de5:	89 cf                	mov    %ecx,%edi
  800de7:	89 ce                	mov    %ecx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 03                	push   $0x3
  800dfd:	68 a8 2a 80 00       	push   $0x802aa8
  800e02:	6a 43                	push   $0x43
  800e04:	68 c5 2a 80 00       	push   $0x802ac5
  800e09:	e8 f7 f3 ff ff       	call   800205 <_panic>

00800e0e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e14:	ba 00 00 00 00       	mov    $0x0,%edx
  800e19:	b8 02 00 00 00       	mov    $0x2,%eax
  800e1e:	89 d1                	mov    %edx,%ecx
  800e20:	89 d3                	mov    %edx,%ebx
  800e22:	89 d7                	mov    %edx,%edi
  800e24:	89 d6                	mov    %edx,%esi
  800e26:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <sys_yield>:

void
sys_yield(void)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e33:	ba 00 00 00 00       	mov    $0x0,%edx
  800e38:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e3d:	89 d1                	mov    %edx,%ecx
  800e3f:	89 d3                	mov    %edx,%ebx
  800e41:	89 d7                	mov    %edx,%edi
  800e43:	89 d6                	mov    %edx,%esi
  800e45:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	be 00 00 00 00       	mov    $0x0,%esi
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 04 00 00 00       	mov    $0x4,%eax
  800e65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e68:	89 f7                	mov    %esi,%edi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 04                	push   $0x4
  800e7e:	68 a8 2a 80 00       	push   $0x802aa8
  800e83:	6a 43                	push   $0x43
  800e85:	68 c5 2a 80 00       	push   $0x802ac5
  800e8a:	e8 76 f3 ff ff       	call   800205 <_panic>

00800e8f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea9:	8b 75 18             	mov    0x18(%ebp),%esi
  800eac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7f 08                	jg     800eba <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	50                   	push   %eax
  800ebe:	6a 05                	push   $0x5
  800ec0:	68 a8 2a 80 00       	push   $0x802aa8
  800ec5:	6a 43                	push   $0x43
  800ec7:	68 c5 2a 80 00       	push   $0x802ac5
  800ecc:	e8 34 f3 ff ff       	call   800205 <_panic>

00800ed1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee5:	b8 06 00 00 00       	mov    $0x6,%eax
  800eea:	89 df                	mov    %ebx,%edi
  800eec:	89 de                	mov    %ebx,%esi
  800eee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7f 08                	jg     800efc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	50                   	push   %eax
  800f00:	6a 06                	push   $0x6
  800f02:	68 a8 2a 80 00       	push   $0x802aa8
  800f07:	6a 43                	push   $0x43
  800f09:	68 c5 2a 80 00       	push   $0x802ac5
  800f0e:	e8 f2 f2 ff ff       	call   800205 <_panic>

00800f13 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 08 00 00 00       	mov    $0x8,%eax
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	89 de                	mov    %ebx,%esi
  800f30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	7f 08                	jg     800f3e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3e:	83 ec 0c             	sub    $0xc,%esp
  800f41:	50                   	push   %eax
  800f42:	6a 08                	push   $0x8
  800f44:	68 a8 2a 80 00       	push   $0x802aa8
  800f49:	6a 43                	push   $0x43
  800f4b:	68 c5 2a 80 00       	push   $0x802ac5
  800f50:	e8 b0 f2 ff ff       	call   800205 <_panic>

00800f55 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
  800f5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7f 08                	jg     800f80 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	83 ec 0c             	sub    $0xc,%esp
  800f83:	50                   	push   %eax
  800f84:	6a 09                	push   $0x9
  800f86:	68 a8 2a 80 00       	push   $0x802aa8
  800f8b:	6a 43                	push   $0x43
  800f8d:	68 c5 2a 80 00       	push   $0x802ac5
  800f92:	e8 6e f2 ff ff       	call   800205 <_panic>

00800f97 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb0:	89 df                	mov    %ebx,%edi
  800fb2:	89 de                	mov    %ebx,%esi
  800fb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	7f 08                	jg     800fc2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc2:	83 ec 0c             	sub    $0xc,%esp
  800fc5:	50                   	push   %eax
  800fc6:	6a 0a                	push   $0xa
  800fc8:	68 a8 2a 80 00       	push   $0x802aa8
  800fcd:	6a 43                	push   $0x43
  800fcf:	68 c5 2a 80 00       	push   $0x802ac5
  800fd4:	e8 2c f2 ff ff       	call   800205 <_panic>

00800fd9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ff5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801005:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801012:	89 cb                	mov    %ecx,%ebx
  801014:	89 cf                	mov    %ecx,%edi
  801016:	89 ce                	mov    %ecx,%esi
  801018:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7f 08                	jg     801026 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80101e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	83 ec 0c             	sub    $0xc,%esp
  801029:	50                   	push   %eax
  80102a:	6a 0d                	push   $0xd
  80102c:	68 a8 2a 80 00       	push   $0x802aa8
  801031:	6a 43                	push   $0x43
  801033:	68 c5 2a 80 00       	push   $0x802ac5
  801038:	e8 c8 f1 ff ff       	call   800205 <_panic>

0080103d <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
	asm volatile("int %1\n"
  801043:	bb 00 00 00 00       	mov    $0x0,%ebx
  801048:	8b 55 08             	mov    0x8(%ebp),%edx
  80104b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801053:	89 df                	mov    %ebx,%edi
  801055:	89 de                	mov    %ebx,%esi
  801057:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    

0080105e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	57                   	push   %edi
  801062:	56                   	push   %esi
  801063:	53                   	push   %ebx
	asm volatile("int %1\n"
  801064:	b9 00 00 00 00       	mov    $0x0,%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	b8 0f 00 00 00       	mov    $0xf,%eax
  801071:	89 cb                	mov    %ecx,%ebx
  801073:	89 cf                	mov    %ecx,%edi
  801075:	89 ce                	mov    %ecx,%esi
  801077:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5f                   	pop    %edi
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
	asm volatile("int %1\n"
  801084:	ba 00 00 00 00       	mov    $0x0,%edx
  801089:	b8 10 00 00 00       	mov    $0x10,%eax
  80108e:	89 d1                	mov    %edx,%ecx
  801090:	89 d3                	mov    %edx,%ebx
  801092:	89 d7                	mov    %edx,%edi
  801094:	89 d6                	mov    %edx,%esi
  801096:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	b8 11 00 00 00       	mov    $0x11,%eax
  8010b3:	89 df                	mov    %ebx,%edi
  8010b5:	89 de                	mov    %ebx,%esi
  8010b7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010b9:	5b                   	pop    %ebx
  8010ba:	5e                   	pop    %esi
  8010bb:	5f                   	pop    %edi
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cf:	b8 12 00 00 00       	mov    $0x12,%eax
  8010d4:	89 df                	mov    %ebx,%edi
  8010d6:	89 de                	mov    %ebx,%esi
  8010d8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5f                   	pop    %edi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	57                   	push   %edi
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	b8 13 00 00 00       	mov    $0x13,%eax
  8010f8:	89 df                	mov    %ebx,%edi
  8010fa:	89 de                	mov    %ebx,%esi
  8010fc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fe:	85 c0                	test   %eax,%eax
  801100:	7f 08                	jg     80110a <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801102:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	50                   	push   %eax
  80110e:	6a 13                	push   $0x13
  801110:	68 a8 2a 80 00       	push   $0x802aa8
  801115:	6a 43                	push   $0x43
  801117:	68 c5 2a 80 00       	push   $0x802ac5
  80111c:	e8 e4 f0 ff ff       	call   800205 <_panic>

00801121 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	57                   	push   %edi
  801125:	56                   	push   %esi
  801126:	53                   	push   %ebx
	asm volatile("int %1\n"
  801127:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112c:	8b 55 08             	mov    0x8(%ebp),%edx
  80112f:	b8 14 00 00 00       	mov    $0x14,%eax
  801134:	89 cb                	mov    %ecx,%ebx
  801136:	89 cf                	mov    %ecx,%edi
  801138:	89 ce                	mov    %ecx,%esi
  80113a:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	05 00 00 00 30       	add    $0x30000000,%eax
  80114c:	c1 e8 0c             	shr    $0xc,%eax
}
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80115c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801161:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801170:	89 c2                	mov    %eax,%edx
  801172:	c1 ea 16             	shr    $0x16,%edx
  801175:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117c:	f6 c2 01             	test   $0x1,%dl
  80117f:	74 2d                	je     8011ae <fd_alloc+0x46>
  801181:	89 c2                	mov    %eax,%edx
  801183:	c1 ea 0c             	shr    $0xc,%edx
  801186:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118d:	f6 c2 01             	test   $0x1,%dl
  801190:	74 1c                	je     8011ae <fd_alloc+0x46>
  801192:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801197:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80119c:	75 d2                	jne    801170 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011a7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011ac:	eb 0a                	jmp    8011b8 <fd_alloc+0x50>
			*fd_store = fd;
  8011ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011c0:	83 f8 1f             	cmp    $0x1f,%eax
  8011c3:	77 30                	ja     8011f5 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011c5:	c1 e0 0c             	shl    $0xc,%eax
  8011c8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011cd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011d3:	f6 c2 01             	test   $0x1,%dl
  8011d6:	74 24                	je     8011fc <fd_lookup+0x42>
  8011d8:	89 c2                	mov    %eax,%edx
  8011da:	c1 ea 0c             	shr    $0xc,%edx
  8011dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e4:	f6 c2 01             	test   $0x1,%dl
  8011e7:	74 1a                	je     801203 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ec:	89 02                	mov    %eax,(%edx)
	return 0;
  8011ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    
		return -E_INVAL;
  8011f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fa:	eb f7                	jmp    8011f3 <fd_lookup+0x39>
		return -E_INVAL;
  8011fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801201:	eb f0                	jmp    8011f3 <fd_lookup+0x39>
  801203:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801208:	eb e9                	jmp    8011f3 <fd_lookup+0x39>

0080120a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801213:	ba 00 00 00 00       	mov    $0x0,%edx
  801218:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80121d:	39 08                	cmp    %ecx,(%eax)
  80121f:	74 38                	je     801259 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801221:	83 c2 01             	add    $0x1,%edx
  801224:	8b 04 95 54 2b 80 00 	mov    0x802b54(,%edx,4),%eax
  80122b:	85 c0                	test   %eax,%eax
  80122d:	75 ee                	jne    80121d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80122f:	a1 08 40 80 00       	mov    0x804008,%eax
  801234:	8b 40 48             	mov    0x48(%eax),%eax
  801237:	83 ec 04             	sub    $0x4,%esp
  80123a:	51                   	push   %ecx
  80123b:	50                   	push   %eax
  80123c:	68 d4 2a 80 00       	push   $0x802ad4
  801241:	e8 b5 f0 ff ff       	call   8002fb <cprintf>
	*dev = 0;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80124f:	83 c4 10             	add    $0x10,%esp
  801252:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801257:	c9                   	leave  
  801258:	c3                   	ret    
			*dev = devtab[i];
  801259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80125e:	b8 00 00 00 00       	mov    $0x0,%eax
  801263:	eb f2                	jmp    801257 <dev_lookup+0x4d>

00801265 <fd_close>:
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	57                   	push   %edi
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	83 ec 24             	sub    $0x24,%esp
  80126e:	8b 75 08             	mov    0x8(%ebp),%esi
  801271:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801274:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801277:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801278:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80127e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801281:	50                   	push   %eax
  801282:	e8 33 ff ff ff       	call   8011ba <fd_lookup>
  801287:	89 c3                	mov    %eax,%ebx
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 05                	js     801295 <fd_close+0x30>
	    || fd != fd2)
  801290:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801293:	74 16                	je     8012ab <fd_close+0x46>
		return (must_exist ? r : 0);
  801295:	89 f8                	mov    %edi,%eax
  801297:	84 c0                	test   %al,%al
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	0f 44 d8             	cmove  %eax,%ebx
}
  8012a1:	89 d8                	mov    %ebx,%eax
  8012a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a6:	5b                   	pop    %ebx
  8012a7:	5e                   	pop    %esi
  8012a8:	5f                   	pop    %edi
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	ff 36                	pushl  (%esi)
  8012b4:	e8 51 ff ff ff       	call   80120a <dev_lookup>
  8012b9:	89 c3                	mov    %eax,%ebx
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 1a                	js     8012dc <fd_close+0x77>
		if (dev->dev_close)
  8012c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012c8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	74 0b                	je     8012dc <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	56                   	push   %esi
  8012d5:	ff d0                	call   *%eax
  8012d7:	89 c3                	mov    %eax,%ebx
  8012d9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	56                   	push   %esi
  8012e0:	6a 00                	push   $0x0
  8012e2:	e8 ea fb ff ff       	call   800ed1 <sys_page_unmap>
	return r;
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	eb b5                	jmp    8012a1 <fd_close+0x3c>

008012ec <close>:

int
close(int fdnum)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f5:	50                   	push   %eax
  8012f6:	ff 75 08             	pushl  0x8(%ebp)
  8012f9:	e8 bc fe ff ff       	call   8011ba <fd_lookup>
  8012fe:	83 c4 10             	add    $0x10,%esp
  801301:	85 c0                	test   %eax,%eax
  801303:	79 02                	jns    801307 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801305:	c9                   	leave  
  801306:	c3                   	ret    
		return fd_close(fd, 1);
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	6a 01                	push   $0x1
  80130c:	ff 75 f4             	pushl  -0xc(%ebp)
  80130f:	e8 51 ff ff ff       	call   801265 <fd_close>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	eb ec                	jmp    801305 <close+0x19>

00801319 <close_all>:

void
close_all(void)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	53                   	push   %ebx
  80131d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801320:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	53                   	push   %ebx
  801329:	e8 be ff ff ff       	call   8012ec <close>
	for (i = 0; i < MAXFD; i++)
  80132e:	83 c3 01             	add    $0x1,%ebx
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	83 fb 20             	cmp    $0x20,%ebx
  801337:	75 ec                	jne    801325 <close_all+0xc>
}
  801339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	57                   	push   %edi
  801342:	56                   	push   %esi
  801343:	53                   	push   %ebx
  801344:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801347:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80134a:	50                   	push   %eax
  80134b:	ff 75 08             	pushl  0x8(%ebp)
  80134e:	e8 67 fe ff ff       	call   8011ba <fd_lookup>
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	0f 88 81 00 00 00    	js     8013e1 <dup+0xa3>
		return r;
	close(newfdnum);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	ff 75 0c             	pushl  0xc(%ebp)
  801366:	e8 81 ff ff ff       	call   8012ec <close>

	newfd = INDEX2FD(newfdnum);
  80136b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80136e:	c1 e6 0c             	shl    $0xc,%esi
  801371:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801377:	83 c4 04             	add    $0x4,%esp
  80137a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80137d:	e8 cf fd ff ff       	call   801151 <fd2data>
  801382:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801384:	89 34 24             	mov    %esi,(%esp)
  801387:	e8 c5 fd ff ff       	call   801151 <fd2data>
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801391:	89 d8                	mov    %ebx,%eax
  801393:	c1 e8 16             	shr    $0x16,%eax
  801396:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80139d:	a8 01                	test   $0x1,%al
  80139f:	74 11                	je     8013b2 <dup+0x74>
  8013a1:	89 d8                	mov    %ebx,%eax
  8013a3:	c1 e8 0c             	shr    $0xc,%eax
  8013a6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ad:	f6 c2 01             	test   $0x1,%dl
  8013b0:	75 39                	jne    8013eb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b5:	89 d0                	mov    %edx,%eax
  8013b7:	c1 e8 0c             	shr    $0xc,%eax
  8013ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c9:	50                   	push   %eax
  8013ca:	56                   	push   %esi
  8013cb:	6a 00                	push   $0x0
  8013cd:	52                   	push   %edx
  8013ce:	6a 00                	push   $0x0
  8013d0:	e8 ba fa ff ff       	call   800e8f <sys_page_map>
  8013d5:	89 c3                	mov    %eax,%ebx
  8013d7:	83 c4 20             	add    $0x20,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 31                	js     80140f <dup+0xd1>
		goto err;

	return newfdnum;
  8013de:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013e1:	89 d8                	mov    %ebx,%eax
  8013e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e6:	5b                   	pop    %ebx
  8013e7:	5e                   	pop    %esi
  8013e8:	5f                   	pop    %edi
  8013e9:	5d                   	pop    %ebp
  8013ea:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f2:	83 ec 0c             	sub    $0xc,%esp
  8013f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8013fa:	50                   	push   %eax
  8013fb:	57                   	push   %edi
  8013fc:	6a 00                	push   $0x0
  8013fe:	53                   	push   %ebx
  8013ff:	6a 00                	push   $0x0
  801401:	e8 89 fa ff ff       	call   800e8f <sys_page_map>
  801406:	89 c3                	mov    %eax,%ebx
  801408:	83 c4 20             	add    $0x20,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	79 a3                	jns    8013b2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80140f:	83 ec 08             	sub    $0x8,%esp
  801412:	56                   	push   %esi
  801413:	6a 00                	push   $0x0
  801415:	e8 b7 fa ff ff       	call   800ed1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80141a:	83 c4 08             	add    $0x8,%esp
  80141d:	57                   	push   %edi
  80141e:	6a 00                	push   $0x0
  801420:	e8 ac fa ff ff       	call   800ed1 <sys_page_unmap>
	return r;
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	eb b7                	jmp    8013e1 <dup+0xa3>

0080142a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 1c             	sub    $0x1c,%esp
  801431:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801437:	50                   	push   %eax
  801438:	53                   	push   %ebx
  801439:	e8 7c fd ff ff       	call   8011ba <fd_lookup>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 3f                	js     801484 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	50                   	push   %eax
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	ff 30                	pushl  (%eax)
  801451:	e8 b4 fd ff ff       	call   80120a <dev_lookup>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 27                	js     801484 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80145d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801460:	8b 42 08             	mov    0x8(%edx),%eax
  801463:	83 e0 03             	and    $0x3,%eax
  801466:	83 f8 01             	cmp    $0x1,%eax
  801469:	74 1e                	je     801489 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	8b 40 08             	mov    0x8(%eax),%eax
  801471:	85 c0                	test   %eax,%eax
  801473:	74 35                	je     8014aa <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	ff 75 10             	pushl  0x10(%ebp)
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	52                   	push   %edx
  80147f:	ff d0                	call   *%eax
  801481:	83 c4 10             	add    $0x10,%esp
}
  801484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801487:	c9                   	leave  
  801488:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801489:	a1 08 40 80 00       	mov    0x804008,%eax
  80148e:	8b 40 48             	mov    0x48(%eax),%eax
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	53                   	push   %ebx
  801495:	50                   	push   %eax
  801496:	68 18 2b 80 00       	push   $0x802b18
  80149b:	e8 5b ee ff ff       	call   8002fb <cprintf>
		return -E_INVAL;
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a8:	eb da                	jmp    801484 <read+0x5a>
		return -E_NOT_SUPP;
  8014aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014af:	eb d3                	jmp    801484 <read+0x5a>

008014b1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	57                   	push   %edi
  8014b5:	56                   	push   %esi
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014bd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c5:	39 f3                	cmp    %esi,%ebx
  8014c7:	73 23                	jae    8014ec <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	89 f0                	mov    %esi,%eax
  8014ce:	29 d8                	sub    %ebx,%eax
  8014d0:	50                   	push   %eax
  8014d1:	89 d8                	mov    %ebx,%eax
  8014d3:	03 45 0c             	add    0xc(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	57                   	push   %edi
  8014d8:	e8 4d ff ff ff       	call   80142a <read>
		if (m < 0)
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 06                	js     8014ea <readn+0x39>
			return m;
		if (m == 0)
  8014e4:	74 06                	je     8014ec <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014e6:	01 c3                	add    %eax,%ebx
  8014e8:	eb db                	jmp    8014c5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ea:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	53                   	push   %ebx
  8014fa:	83 ec 1c             	sub    $0x1c,%esp
  8014fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801500:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	53                   	push   %ebx
  801505:	e8 b0 fc ff ff       	call   8011ba <fd_lookup>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 3a                	js     80154b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801517:	50                   	push   %eax
  801518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151b:	ff 30                	pushl  (%eax)
  80151d:	e8 e8 fc ff ff       	call   80120a <dev_lookup>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 22                	js     80154b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801530:	74 1e                	je     801550 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801535:	8b 52 0c             	mov    0xc(%edx),%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	74 35                	je     801571 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	ff 75 10             	pushl  0x10(%ebp)
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	50                   	push   %eax
  801546:	ff d2                	call   *%edx
  801548:	83 c4 10             	add    $0x10,%esp
}
  80154b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801550:	a1 08 40 80 00       	mov    0x804008,%eax
  801555:	8b 40 48             	mov    0x48(%eax),%eax
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	53                   	push   %ebx
  80155c:	50                   	push   %eax
  80155d:	68 34 2b 80 00       	push   $0x802b34
  801562:	e8 94 ed ff ff       	call   8002fb <cprintf>
		return -E_INVAL;
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156f:	eb da                	jmp    80154b <write+0x55>
		return -E_NOT_SUPP;
  801571:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801576:	eb d3                	jmp    80154b <write+0x55>

00801578 <seek>:

int
seek(int fdnum, off_t offset)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80157e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 30 fc ff ff       	call   8011ba <fd_lookup>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 0e                	js     80159f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801591:	8b 55 0c             	mov    0xc(%ebp),%edx
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80159a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 1c             	sub    $0x1c,%esp
  8015a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	53                   	push   %ebx
  8015b0:	e8 05 fc ff ff       	call   8011ba <fd_lookup>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 37                	js     8015f3 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c2:	50                   	push   %eax
  8015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c6:	ff 30                	pushl  (%eax)
  8015c8:	e8 3d fc ff ff       	call   80120a <dev_lookup>
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 1f                	js     8015f3 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015db:	74 1b                	je     8015f8 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e0:	8b 52 18             	mov    0x18(%edx),%edx
  8015e3:	85 d2                	test   %edx,%edx
  8015e5:	74 32                	je     801619 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015e7:	83 ec 08             	sub    $0x8,%esp
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	50                   	push   %eax
  8015ee:	ff d2                	call   *%edx
  8015f0:	83 c4 10             	add    $0x10,%esp
}
  8015f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015f8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015fd:	8b 40 48             	mov    0x48(%eax),%eax
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	53                   	push   %ebx
  801604:	50                   	push   %eax
  801605:	68 f4 2a 80 00       	push   $0x802af4
  80160a:	e8 ec ec ff ff       	call   8002fb <cprintf>
		return -E_INVAL;
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801617:	eb da                	jmp    8015f3 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801619:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161e:	eb d3                	jmp    8015f3 <ftruncate+0x52>

00801620 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 1c             	sub    $0x1c,%esp
  801627:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	e8 84 fb ff ff       	call   8011ba <fd_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 4b                	js     801688 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801643:	50                   	push   %eax
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	ff 30                	pushl  (%eax)
  801649:	e8 bc fb ff ff       	call   80120a <dev_lookup>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 33                	js     801688 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801658:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80165c:	74 2f                	je     80168d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80165e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801661:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801668:	00 00 00 
	stat->st_isdir = 0;
  80166b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801672:	00 00 00 
	stat->st_dev = dev;
  801675:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	53                   	push   %ebx
  80167f:	ff 75 f0             	pushl  -0x10(%ebp)
  801682:	ff 50 14             	call   *0x14(%eax)
  801685:	83 c4 10             	add    $0x10,%esp
}
  801688:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    
		return -E_NOT_SUPP;
  80168d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801692:	eb f4                	jmp    801688 <fstat+0x68>

00801694 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	6a 00                	push   $0x0
  80169e:	ff 75 08             	pushl  0x8(%ebp)
  8016a1:	e8 22 02 00 00       	call   8018c8 <open>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 1b                	js     8016ca <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016af:	83 ec 08             	sub    $0x8,%esp
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	50                   	push   %eax
  8016b6:	e8 65 ff ff ff       	call   801620 <fstat>
  8016bb:	89 c6                	mov    %eax,%esi
	close(fd);
  8016bd:	89 1c 24             	mov    %ebx,(%esp)
  8016c0:	e8 27 fc ff ff       	call   8012ec <close>
	return r;
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 f3                	mov    %esi,%ebx
}
  8016ca:	89 d8                	mov    %ebx,%eax
  8016cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	56                   	push   %esi
  8016d7:	53                   	push   %ebx
  8016d8:	89 c6                	mov    %eax,%esi
  8016da:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016dc:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016e3:	74 27                	je     80170c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016e5:	6a 07                	push   $0x7
  8016e7:	68 00 50 80 00       	push   $0x805000
  8016ec:	56                   	push   %esi
  8016ed:	ff 35 00 40 80 00    	pushl  0x804000
  8016f3:	e8 08 0c 00 00       	call   802300 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016f8:	83 c4 0c             	add    $0xc,%esp
  8016fb:	6a 00                	push   $0x0
  8016fd:	53                   	push   %ebx
  8016fe:	6a 00                	push   $0x0
  801700:	e8 92 0b 00 00       	call   802297 <ipc_recv>
}
  801705:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	6a 01                	push   $0x1
  801711:	e8 42 0c 00 00       	call   802358 <ipc_find_env>
  801716:	a3 00 40 80 00       	mov    %eax,0x804000
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	eb c5                	jmp    8016e5 <fsipc+0x12>

00801720 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8b 40 0c             	mov    0xc(%eax),%eax
  80172c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	b8 02 00 00 00       	mov    $0x2,%eax
  801743:	e8 8b ff ff ff       	call   8016d3 <fsipc>
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <devfile_flush>:
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8b 40 0c             	mov    0xc(%eax),%eax
  801756:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80175b:	ba 00 00 00 00       	mov    $0x0,%edx
  801760:	b8 06 00 00 00       	mov    $0x6,%eax
  801765:	e8 69 ff ff ff       	call   8016d3 <fsipc>
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <devfile_stat>:
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	53                   	push   %ebx
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8b 40 0c             	mov    0xc(%eax),%eax
  80177c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801781:	ba 00 00 00 00       	mov    $0x0,%edx
  801786:	b8 05 00 00 00       	mov    $0x5,%eax
  80178b:	e8 43 ff ff ff       	call   8016d3 <fsipc>
  801790:	85 c0                	test   %eax,%eax
  801792:	78 2c                	js     8017c0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	68 00 50 80 00       	push   $0x805000
  80179c:	53                   	push   %ebx
  80179d:	e8 b8 f2 ff ff       	call   800a5a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017a2:	a1 80 50 80 00       	mov    0x805080,%eax
  8017a7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ad:	a1 84 50 80 00       	mov    0x805084,%eax
  8017b2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <devfile_write>:
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017da:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017e0:	53                   	push   %ebx
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	68 08 50 80 00       	push   $0x805008
  8017e9:	e8 5c f4 ff ff       	call   800c4a <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8017f8:	e8 d6 fe ff ff       	call   8016d3 <fsipc>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 0b                	js     80180f <devfile_write+0x4a>
	assert(r <= n);
  801804:	39 d8                	cmp    %ebx,%eax
  801806:	77 0c                	ja     801814 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801808:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180d:	7f 1e                	jg     80182d <devfile_write+0x68>
}
  80180f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801812:	c9                   	leave  
  801813:	c3                   	ret    
	assert(r <= n);
  801814:	68 68 2b 80 00       	push   $0x802b68
  801819:	68 6f 2b 80 00       	push   $0x802b6f
  80181e:	68 98 00 00 00       	push   $0x98
  801823:	68 84 2b 80 00       	push   $0x802b84
  801828:	e8 d8 e9 ff ff       	call   800205 <_panic>
	assert(r <= PGSIZE);
  80182d:	68 8f 2b 80 00       	push   $0x802b8f
  801832:	68 6f 2b 80 00       	push   $0x802b6f
  801837:	68 99 00 00 00       	push   $0x99
  80183c:	68 84 2b 80 00       	push   $0x802b84
  801841:	e8 bf e9 ff ff       	call   800205 <_panic>

00801846 <devfile_read>:
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8b 40 0c             	mov    0xc(%eax),%eax
  801854:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801859:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80185f:	ba 00 00 00 00       	mov    $0x0,%edx
  801864:	b8 03 00 00 00       	mov    $0x3,%eax
  801869:	e8 65 fe ff ff       	call   8016d3 <fsipc>
  80186e:	89 c3                	mov    %eax,%ebx
  801870:	85 c0                	test   %eax,%eax
  801872:	78 1f                	js     801893 <devfile_read+0x4d>
	assert(r <= n);
  801874:	39 f0                	cmp    %esi,%eax
  801876:	77 24                	ja     80189c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801878:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187d:	7f 33                	jg     8018b2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	50                   	push   %eax
  801883:	68 00 50 80 00       	push   $0x805000
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	e8 58 f3 ff ff       	call   800be8 <memmove>
	return r;
  801890:	83 c4 10             	add    $0x10,%esp
}
  801893:	89 d8                	mov    %ebx,%eax
  801895:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801898:	5b                   	pop    %ebx
  801899:	5e                   	pop    %esi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    
	assert(r <= n);
  80189c:	68 68 2b 80 00       	push   $0x802b68
  8018a1:	68 6f 2b 80 00       	push   $0x802b6f
  8018a6:	6a 7c                	push   $0x7c
  8018a8:	68 84 2b 80 00       	push   $0x802b84
  8018ad:	e8 53 e9 ff ff       	call   800205 <_panic>
	assert(r <= PGSIZE);
  8018b2:	68 8f 2b 80 00       	push   $0x802b8f
  8018b7:	68 6f 2b 80 00       	push   $0x802b6f
  8018bc:	6a 7d                	push   $0x7d
  8018be:	68 84 2b 80 00       	push   $0x802b84
  8018c3:	e8 3d e9 ff ff       	call   800205 <_panic>

008018c8 <open>:
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
  8018cd:	83 ec 1c             	sub    $0x1c,%esp
  8018d0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018d3:	56                   	push   %esi
  8018d4:	e8 48 f1 ff ff       	call   800a21 <strlen>
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018e1:	7f 6c                	jg     80194f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e9:	50                   	push   %eax
  8018ea:	e8 79 f8 ff ff       	call   801168 <fd_alloc>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 3c                	js     801934 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	56                   	push   %esi
  8018fc:	68 00 50 80 00       	push   $0x805000
  801901:	e8 54 f1 ff ff       	call   800a5a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80190e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801911:	b8 01 00 00 00       	mov    $0x1,%eax
  801916:	e8 b8 fd ff ff       	call   8016d3 <fsipc>
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 19                	js     80193d <open+0x75>
	return fd2num(fd);
  801924:	83 ec 0c             	sub    $0xc,%esp
  801927:	ff 75 f4             	pushl  -0xc(%ebp)
  80192a:	e8 12 f8 ff ff       	call   801141 <fd2num>
  80192f:	89 c3                	mov    %eax,%ebx
  801931:	83 c4 10             	add    $0x10,%esp
}
  801934:	89 d8                	mov    %ebx,%eax
  801936:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801939:	5b                   	pop    %ebx
  80193a:	5e                   	pop    %esi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    
		fd_close(fd, 0);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	6a 00                	push   $0x0
  801942:	ff 75 f4             	pushl  -0xc(%ebp)
  801945:	e8 1b f9 ff ff       	call   801265 <fd_close>
		return r;
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	eb e5                	jmp    801934 <open+0x6c>
		return -E_BAD_PATH;
  80194f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801954:	eb de                	jmp    801934 <open+0x6c>

00801956 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80195c:	ba 00 00 00 00       	mov    $0x0,%edx
  801961:	b8 08 00 00 00       	mov    $0x8,%eax
  801966:	e8 68 fd ff ff       	call   8016d3 <fsipc>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801973:	68 9b 2b 80 00       	push   $0x802b9b
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	e8 da f0 ff ff       	call   800a5a <strcpy>
	return 0;
}
  801980:	b8 00 00 00 00       	mov    $0x0,%eax
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <devsock_close>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 10             	sub    $0x10,%esp
  80198e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801991:	53                   	push   %ebx
  801992:	e8 00 0a 00 00       	call   802397 <pageref>
  801997:	83 c4 10             	add    $0x10,%esp
		return 0;
  80199a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80199f:	83 f8 01             	cmp    $0x1,%eax
  8019a2:	74 07                	je     8019ab <devsock_close+0x24>
}
  8019a4:	89 d0                	mov    %edx,%eax
  8019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019ab:	83 ec 0c             	sub    $0xc,%esp
  8019ae:	ff 73 0c             	pushl  0xc(%ebx)
  8019b1:	e8 b9 02 00 00       	call   801c6f <nsipc_close>
  8019b6:	89 c2                	mov    %eax,%edx
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	eb e7                	jmp    8019a4 <devsock_close+0x1d>

008019bd <devsock_write>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	ff 75 10             	pushl  0x10(%ebp)
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	ff 70 0c             	pushl  0xc(%eax)
  8019d1:	e8 76 03 00 00       	call   801d4c <nsipc_send>
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <devsock_read>:
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	ff 75 10             	pushl  0x10(%ebp)
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	ff 70 0c             	pushl  0xc(%eax)
  8019ec:	e8 ef 02 00 00       	call   801ce0 <nsipc_recv>
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <fd2sockid>:
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019f9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	e8 b7 f7 ff ff       	call   8011ba <fd_lookup>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 10                	js     801a1a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a13:	39 08                	cmp    %ecx,(%eax)
  801a15:	75 05                	jne    801a1c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a17:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    
		return -E_NOT_SUPP;
  801a1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a21:	eb f7                	jmp    801a1a <fd2sockid+0x27>

00801a23 <alloc_sockfd>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	56                   	push   %esi
  801a27:	53                   	push   %ebx
  801a28:	83 ec 1c             	sub    $0x1c,%esp
  801a2b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a30:	50                   	push   %eax
  801a31:	e8 32 f7 ff ff       	call   801168 <fd_alloc>
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 43                	js     801a82 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	68 07 04 00 00       	push   $0x407
  801a47:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4a:	6a 00                	push   $0x0
  801a4c:	e8 fb f3 ff ff       	call   800e4c <sys_page_alloc>
  801a51:	89 c3                	mov    %eax,%ebx
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 28                	js     801a82 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a63:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a68:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a6f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a72:	83 ec 0c             	sub    $0xc,%esp
  801a75:	50                   	push   %eax
  801a76:	e8 c6 f6 ff ff       	call   801141 <fd2num>
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	eb 0c                	jmp    801a8e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	56                   	push   %esi
  801a86:	e8 e4 01 00 00       	call   801c6f <nsipc_close>
		return r;
  801a8b:	83 c4 10             	add    $0x10,%esp
}
  801a8e:	89 d8                	mov    %ebx,%eax
  801a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a93:	5b                   	pop    %ebx
  801a94:	5e                   	pop    %esi
  801a95:	5d                   	pop    %ebp
  801a96:	c3                   	ret    

00801a97 <accept>:
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	e8 4e ff ff ff       	call   8019f3 <fd2sockid>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 1b                	js     801ac4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	ff 75 10             	pushl  0x10(%ebp)
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	e8 0e 01 00 00       	call   801bc6 <nsipc_accept>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 05                	js     801ac4 <accept+0x2d>
	return alloc_sockfd(r);
  801abf:	e8 5f ff ff ff       	call   801a23 <alloc_sockfd>
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <bind>:
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	e8 1f ff ff ff       	call   8019f3 <fd2sockid>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 12                	js     801aea <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	ff 75 10             	pushl  0x10(%ebp)
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	e8 31 01 00 00       	call   801c18 <nsipc_bind>
  801ae7:	83 c4 10             	add    $0x10,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <shutdown>:
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	e8 f9 fe ff ff       	call   8019f3 <fd2sockid>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 0f                	js     801b0d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	50                   	push   %eax
  801b05:	e8 43 01 00 00       	call   801c4d <nsipc_shutdown>
  801b0a:	83 c4 10             	add    $0x10,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <connect>:
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	e8 d6 fe ff ff       	call   8019f3 <fd2sockid>
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	78 12                	js     801b33 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	ff 75 10             	pushl  0x10(%ebp)
  801b27:	ff 75 0c             	pushl  0xc(%ebp)
  801b2a:	50                   	push   %eax
  801b2b:	e8 59 01 00 00       	call   801c89 <nsipc_connect>
  801b30:	83 c4 10             	add    $0x10,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <listen>:
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	e8 b0 fe ff ff       	call   8019f3 <fd2sockid>
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 0f                	js     801b56 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	50                   	push   %eax
  801b4e:	e8 6b 01 00 00       	call   801cbe <nsipc_listen>
  801b53:	83 c4 10             	add    $0x10,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b5e:	ff 75 10             	pushl  0x10(%ebp)
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	e8 3e 02 00 00       	call   801daa <nsipc_socket>
  801b6c:	83 c4 10             	add    $0x10,%esp
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 05                	js     801b78 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b73:	e8 ab fe ff ff       	call   801a23 <alloc_sockfd>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b83:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b8a:	74 26                	je     801bb2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b8c:	6a 07                	push   $0x7
  801b8e:	68 00 60 80 00       	push   $0x806000
  801b93:	53                   	push   %ebx
  801b94:	ff 35 04 40 80 00    	pushl  0x804004
  801b9a:	e8 61 07 00 00       	call   802300 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b9f:	83 c4 0c             	add    $0xc,%esp
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	e8 ea 06 00 00       	call   802297 <ipc_recv>
}
  801bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	6a 02                	push   $0x2
  801bb7:	e8 9c 07 00 00       	call   802358 <ipc_find_env>
  801bbc:	a3 04 40 80 00       	mov    %eax,0x804004
  801bc1:	83 c4 10             	add    $0x10,%esp
  801bc4:	eb c6                	jmp    801b8c <nsipc+0x12>

00801bc6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	56                   	push   %esi
  801bca:	53                   	push   %ebx
  801bcb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bd6:	8b 06                	mov    (%esi),%eax
  801bd8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801be2:	e8 93 ff ff ff       	call   801b7a <nsipc>
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	85 c0                	test   %eax,%eax
  801beb:	79 09                	jns    801bf6 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bed:	89 d8                	mov    %ebx,%eax
  801bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	ff 35 10 60 80 00    	pushl  0x806010
  801bff:	68 00 60 80 00       	push   $0x806000
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	e8 dc ef ff ff       	call   800be8 <memmove>
		*addrlen = ret->ret_addrlen;
  801c0c:	a1 10 60 80 00       	mov    0x806010,%eax
  801c11:	89 06                	mov    %eax,(%esi)
  801c13:	83 c4 10             	add    $0x10,%esp
	return r;
  801c16:	eb d5                	jmp    801bed <nsipc_accept+0x27>

00801c18 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	53                   	push   %ebx
  801c1c:	83 ec 08             	sub    $0x8,%esp
  801c1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c2a:	53                   	push   %ebx
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	68 04 60 80 00       	push   $0x806004
  801c33:	e8 b0 ef ff ff       	call   800be8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c38:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c3e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c43:	e8 32 ff ff ff       	call   801b7a <nsipc>
}
  801c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c63:	b8 03 00 00 00       	mov    $0x3,%eax
  801c68:	e8 0d ff ff ff       	call   801b7a <nsipc>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <nsipc_close>:

int
nsipc_close(int s)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c7d:	b8 04 00 00 00       	mov    $0x4,%eax
  801c82:	e8 f3 fe ff ff       	call   801b7a <nsipc>
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	53                   	push   %ebx
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c9b:	53                   	push   %ebx
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	68 04 60 80 00       	push   $0x806004
  801ca4:	e8 3f ef ff ff       	call   800be8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ca9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801caf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cb4:	e8 c1 fe ff ff       	call   801b7a <nsipc>
}
  801cb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cd4:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd9:	e8 9c fe ff ff       	call   801b7a <nsipc>
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cf0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cfe:	b8 07 00 00 00       	mov    $0x7,%eax
  801d03:	e8 72 fe ff ff       	call   801b7a <nsipc>
  801d08:	89 c3                	mov    %eax,%ebx
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 1f                	js     801d2d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d0e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d13:	7f 21                	jg     801d36 <nsipc_recv+0x56>
  801d15:	39 c6                	cmp    %eax,%esi
  801d17:	7c 1d                	jl     801d36 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	50                   	push   %eax
  801d1d:	68 00 60 80 00       	push   $0x806000
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	e8 be ee ff ff       	call   800be8 <memmove>
  801d2a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d2d:	89 d8                	mov    %ebx,%eax
  801d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d36:	68 a7 2b 80 00       	push   $0x802ba7
  801d3b:	68 6f 2b 80 00       	push   $0x802b6f
  801d40:	6a 62                	push   $0x62
  801d42:	68 bc 2b 80 00       	push   $0x802bbc
  801d47:	e8 b9 e4 ff ff       	call   800205 <_panic>

00801d4c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d5e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d64:	7f 2e                	jg     801d94 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d66:	83 ec 04             	sub    $0x4,%esp
  801d69:	53                   	push   %ebx
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	68 0c 60 80 00       	push   $0x80600c
  801d72:	e8 71 ee ff ff       	call   800be8 <memmove>
	nsipcbuf.send.req_size = size;
  801d77:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d80:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d85:	b8 08 00 00 00       	mov    $0x8,%eax
  801d8a:	e8 eb fd ff ff       	call   801b7a <nsipc>
}
  801d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    
	assert(size < 1600);
  801d94:	68 c8 2b 80 00       	push   $0x802bc8
  801d99:	68 6f 2b 80 00       	push   $0x802b6f
  801d9e:	6a 6d                	push   $0x6d
  801da0:	68 bc 2b 80 00       	push   $0x802bbc
  801da5:	e8 5b e4 ff ff       	call   800205 <_panic>

00801daa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbb:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dc8:	b8 09 00 00 00       	mov    $0x9,%eax
  801dcd:	e8 a8 fd ff ff       	call   801b7a <nsipc>
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	56                   	push   %esi
  801dd8:	53                   	push   %ebx
  801dd9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	ff 75 08             	pushl  0x8(%ebp)
  801de2:	e8 6a f3 ff ff       	call   801151 <fd2data>
  801de7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801de9:	83 c4 08             	add    $0x8,%esp
  801dec:	68 d4 2b 80 00       	push   $0x802bd4
  801df1:	53                   	push   %ebx
  801df2:	e8 63 ec ff ff       	call   800a5a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801df7:	8b 46 04             	mov    0x4(%esi),%eax
  801dfa:	2b 06                	sub    (%esi),%eax
  801dfc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e09:	00 00 00 
	stat->st_dev = &devpipe;
  801e0c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e13:	30 80 00 
	return 0;
}
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5e                   	pop    %esi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	53                   	push   %ebx
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e2c:	53                   	push   %ebx
  801e2d:	6a 00                	push   $0x0
  801e2f:	e8 9d f0 ff ff       	call   800ed1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e34:	89 1c 24             	mov    %ebx,(%esp)
  801e37:	e8 15 f3 ff ff       	call   801151 <fd2data>
  801e3c:	83 c4 08             	add    $0x8,%esp
  801e3f:	50                   	push   %eax
  801e40:	6a 00                	push   $0x0
  801e42:	e8 8a f0 ff ff       	call   800ed1 <sys_page_unmap>
}
  801e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <_pipeisclosed>:
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	57                   	push   %edi
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	83 ec 1c             	sub    $0x1c,%esp
  801e55:	89 c7                	mov    %eax,%edi
  801e57:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e59:	a1 08 40 80 00       	mov    0x804008,%eax
  801e5e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	57                   	push   %edi
  801e65:	e8 2d 05 00 00       	call   802397 <pageref>
  801e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e6d:	89 34 24             	mov    %esi,(%esp)
  801e70:	e8 22 05 00 00       	call   802397 <pageref>
		nn = thisenv->env_runs;
  801e75:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	39 cb                	cmp    %ecx,%ebx
  801e83:	74 1b                	je     801ea0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e88:	75 cf                	jne    801e59 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e8a:	8b 42 58             	mov    0x58(%edx),%eax
  801e8d:	6a 01                	push   $0x1
  801e8f:	50                   	push   %eax
  801e90:	53                   	push   %ebx
  801e91:	68 db 2b 80 00       	push   $0x802bdb
  801e96:	e8 60 e4 ff ff       	call   8002fb <cprintf>
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	eb b9                	jmp    801e59 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ea0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ea3:	0f 94 c0             	sete   %al
  801ea6:	0f b6 c0             	movzbl %al,%eax
}
  801ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5e                   	pop    %esi
  801eae:	5f                   	pop    %edi
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    

00801eb1 <devpipe_write>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	57                   	push   %edi
  801eb5:	56                   	push   %esi
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 28             	sub    $0x28,%esp
  801eba:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ebd:	56                   	push   %esi
  801ebe:	e8 8e f2 ff ff       	call   801151 <fd2data>
  801ec3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ecd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ed0:	74 4f                	je     801f21 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ed2:	8b 43 04             	mov    0x4(%ebx),%eax
  801ed5:	8b 0b                	mov    (%ebx),%ecx
  801ed7:	8d 51 20             	lea    0x20(%ecx),%edx
  801eda:	39 d0                	cmp    %edx,%eax
  801edc:	72 14                	jb     801ef2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ede:	89 da                	mov    %ebx,%edx
  801ee0:	89 f0                	mov    %esi,%eax
  801ee2:	e8 65 ff ff ff       	call   801e4c <_pipeisclosed>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	75 3b                	jne    801f26 <devpipe_write+0x75>
			sys_yield();
  801eeb:	e8 3d ef ff ff       	call   800e2d <sys_yield>
  801ef0:	eb e0                	jmp    801ed2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ef9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801efc:	89 c2                	mov    %eax,%edx
  801efe:	c1 fa 1f             	sar    $0x1f,%edx
  801f01:	89 d1                	mov    %edx,%ecx
  801f03:	c1 e9 1b             	shr    $0x1b,%ecx
  801f06:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f09:	83 e2 1f             	and    $0x1f,%edx
  801f0c:	29 ca                	sub    %ecx,%edx
  801f0e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f12:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f16:	83 c0 01             	add    $0x1,%eax
  801f19:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f1c:	83 c7 01             	add    $0x1,%edi
  801f1f:	eb ac                	jmp    801ecd <devpipe_write+0x1c>
	return i;
  801f21:	8b 45 10             	mov    0x10(%ebp),%eax
  801f24:	eb 05                	jmp    801f2b <devpipe_write+0x7a>
				return 0;
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5e                   	pop    %esi
  801f30:	5f                   	pop    %edi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    

00801f33 <devpipe_read>:
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	57                   	push   %edi
  801f37:	56                   	push   %esi
  801f38:	53                   	push   %ebx
  801f39:	83 ec 18             	sub    $0x18,%esp
  801f3c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f3f:	57                   	push   %edi
  801f40:	e8 0c f2 ff ff       	call   801151 <fd2data>
  801f45:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	be 00 00 00 00       	mov    $0x0,%esi
  801f4f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f52:	75 14                	jne    801f68 <devpipe_read+0x35>
	return i;
  801f54:	8b 45 10             	mov    0x10(%ebp),%eax
  801f57:	eb 02                	jmp    801f5b <devpipe_read+0x28>
				return i;
  801f59:	89 f0                	mov    %esi,%eax
}
  801f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5e                   	pop    %esi
  801f60:	5f                   	pop    %edi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    
			sys_yield();
  801f63:	e8 c5 ee ff ff       	call   800e2d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f68:	8b 03                	mov    (%ebx),%eax
  801f6a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6d:	75 18                	jne    801f87 <devpipe_read+0x54>
			if (i > 0)
  801f6f:	85 f6                	test   %esi,%esi
  801f71:	75 e6                	jne    801f59 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f73:	89 da                	mov    %ebx,%edx
  801f75:	89 f8                	mov    %edi,%eax
  801f77:	e8 d0 fe ff ff       	call   801e4c <_pipeisclosed>
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	74 e3                	je     801f63 <devpipe_read+0x30>
				return 0;
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	eb d4                	jmp    801f5b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f87:	99                   	cltd   
  801f88:	c1 ea 1b             	shr    $0x1b,%edx
  801f8b:	01 d0                	add    %edx,%eax
  801f8d:	83 e0 1f             	and    $0x1f,%eax
  801f90:	29 d0                	sub    %edx,%eax
  801f92:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f9a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f9d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fa0:	83 c6 01             	add    $0x1,%esi
  801fa3:	eb aa                	jmp    801f4f <devpipe_read+0x1c>

00801fa5 <pipe>:
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	56                   	push   %esi
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb0:	50                   	push   %eax
  801fb1:	e8 b2 f1 ff ff       	call   801168 <fd_alloc>
  801fb6:	89 c3                	mov    %eax,%ebx
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	0f 88 23 01 00 00    	js     8020e6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	68 07 04 00 00       	push   $0x407
  801fcb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fce:	6a 00                	push   $0x0
  801fd0:	e8 77 ee ff ff       	call   800e4c <sys_page_alloc>
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	0f 88 04 01 00 00    	js     8020e6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fe8:	50                   	push   %eax
  801fe9:	e8 7a f1 ff ff       	call   801168 <fd_alloc>
  801fee:	89 c3                	mov    %eax,%ebx
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	0f 88 db 00 00 00    	js     8020d6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	68 07 04 00 00       	push   $0x407
  802003:	ff 75 f0             	pushl  -0x10(%ebp)
  802006:	6a 00                	push   $0x0
  802008:	e8 3f ee ff ff       	call   800e4c <sys_page_alloc>
  80200d:	89 c3                	mov    %eax,%ebx
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 bc 00 00 00    	js     8020d6 <pipe+0x131>
	va = fd2data(fd0);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 f4             	pushl  -0xc(%ebp)
  802020:	e8 2c f1 ff ff       	call   801151 <fd2data>
  802025:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802027:	83 c4 0c             	add    $0xc,%esp
  80202a:	68 07 04 00 00       	push   $0x407
  80202f:	50                   	push   %eax
  802030:	6a 00                	push   $0x0
  802032:	e8 15 ee ff ff       	call   800e4c <sys_page_alloc>
  802037:	89 c3                	mov    %eax,%ebx
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	85 c0                	test   %eax,%eax
  80203e:	0f 88 82 00 00 00    	js     8020c6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802044:	83 ec 0c             	sub    $0xc,%esp
  802047:	ff 75 f0             	pushl  -0x10(%ebp)
  80204a:	e8 02 f1 ff ff       	call   801151 <fd2data>
  80204f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802056:	50                   	push   %eax
  802057:	6a 00                	push   $0x0
  802059:	56                   	push   %esi
  80205a:	6a 00                	push   $0x0
  80205c:	e8 2e ee ff ff       	call   800e8f <sys_page_map>
  802061:	89 c3                	mov    %eax,%ebx
  802063:	83 c4 20             	add    $0x20,%esp
  802066:	85 c0                	test   %eax,%eax
  802068:	78 4e                	js     8020b8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80206a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80206f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802072:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802077:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80207e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802081:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	ff 75 f4             	pushl  -0xc(%ebp)
  802093:	e8 a9 f0 ff ff       	call   801141 <fd2num>
  802098:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80209d:	83 c4 04             	add    $0x4,%esp
  8020a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a3:	e8 99 f0 ff ff       	call   801141 <fd2num>
  8020a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ab:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020b6:	eb 2e                	jmp    8020e6 <pipe+0x141>
	sys_page_unmap(0, va);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	56                   	push   %esi
  8020bc:	6a 00                	push   $0x0
  8020be:	e8 0e ee ff ff       	call   800ed1 <sys_page_unmap>
  8020c3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8020cc:	6a 00                	push   $0x0
  8020ce:	e8 fe ed ff ff       	call   800ed1 <sys_page_unmap>
  8020d3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020d6:	83 ec 08             	sub    $0x8,%esp
  8020d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020dc:	6a 00                	push   $0x0
  8020de:	e8 ee ed ff ff       	call   800ed1 <sys_page_unmap>
  8020e3:	83 c4 10             	add    $0x10,%esp
}
  8020e6:	89 d8                	mov    %ebx,%eax
  8020e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <pipeisclosed>:
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f8:	50                   	push   %eax
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	e8 b9 f0 ff ff       	call   8011ba <fd_lookup>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	85 c0                	test   %eax,%eax
  802106:	78 18                	js     802120 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	ff 75 f4             	pushl  -0xc(%ebp)
  80210e:	e8 3e f0 ff ff       	call   801151 <fd2data>
	return _pipeisclosed(fd, p);
  802113:	89 c2                	mov    %eax,%edx
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	e8 2f fd ff ff       	call   801e4c <_pipeisclosed>
  80211d:	83 c4 10             	add    $0x10,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	c3                   	ret    

00802128 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80212e:	68 f3 2b 80 00       	push   $0x802bf3
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	e8 1f e9 ff ff       	call   800a5a <strcpy>
	return 0;
}
  80213b:	b8 00 00 00 00       	mov    $0x0,%eax
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <devcons_write>:
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	57                   	push   %edi
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80214e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802153:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802159:	3b 75 10             	cmp    0x10(%ebp),%esi
  80215c:	73 31                	jae    80218f <devcons_write+0x4d>
		m = n - tot;
  80215e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802161:	29 f3                	sub    %esi,%ebx
  802163:	83 fb 7f             	cmp    $0x7f,%ebx
  802166:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80216b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	53                   	push   %ebx
  802172:	89 f0                	mov    %esi,%eax
  802174:	03 45 0c             	add    0xc(%ebp),%eax
  802177:	50                   	push   %eax
  802178:	57                   	push   %edi
  802179:	e8 6a ea ff ff       	call   800be8 <memmove>
		sys_cputs(buf, m);
  80217e:	83 c4 08             	add    $0x8,%esp
  802181:	53                   	push   %ebx
  802182:	57                   	push   %edi
  802183:	e8 08 ec ff ff       	call   800d90 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802188:	01 de                	add    %ebx,%esi
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	eb ca                	jmp    802159 <devcons_write+0x17>
}
  80218f:	89 f0                	mov    %esi,%eax
  802191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <devcons_read>:
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 08             	sub    $0x8,%esp
  80219f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a8:	74 21                	je     8021cb <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021aa:	e8 ff eb ff ff       	call   800dae <sys_cgetc>
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	75 07                	jne    8021ba <devcons_read+0x21>
		sys_yield();
  8021b3:	e8 75 ec ff ff       	call   800e2d <sys_yield>
  8021b8:	eb f0                	jmp    8021aa <devcons_read+0x11>
	if (c < 0)
  8021ba:	78 0f                	js     8021cb <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021bc:	83 f8 04             	cmp    $0x4,%eax
  8021bf:	74 0c                	je     8021cd <devcons_read+0x34>
	*(char*)vbuf = c;
  8021c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c4:	88 02                	mov    %al,(%edx)
	return 1;
  8021c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	eb f7                	jmp    8021cb <devcons_read+0x32>

008021d4 <cputchar>:
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021e0:	6a 01                	push   $0x1
  8021e2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e5:	50                   	push   %eax
  8021e6:	e8 a5 eb ff ff       	call   800d90 <sys_cputs>
}
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <getchar>:
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021f6:	6a 01                	push   $0x1
  8021f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021fb:	50                   	push   %eax
  8021fc:	6a 00                	push   $0x0
  8021fe:	e8 27 f2 ff ff       	call   80142a <read>
	if (r < 0)
  802203:	83 c4 10             	add    $0x10,%esp
  802206:	85 c0                	test   %eax,%eax
  802208:	78 06                	js     802210 <getchar+0x20>
	if (r < 1)
  80220a:	74 06                	je     802212 <getchar+0x22>
	return c;
  80220c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    
		return -E_EOF;
  802212:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802217:	eb f7                	jmp    802210 <getchar+0x20>

00802219 <iscons>:
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80221f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802222:	50                   	push   %eax
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	e8 8f ef ff ff       	call   8011ba <fd_lookup>
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 11                	js     802243 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80223b:	39 10                	cmp    %edx,(%eax)
  80223d:	0f 94 c0             	sete   %al
  802240:	0f b6 c0             	movzbl %al,%eax
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <opencons>:
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80224b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224e:	50                   	push   %eax
  80224f:	e8 14 ef ff ff       	call   801168 <fd_alloc>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	85 c0                	test   %eax,%eax
  802259:	78 3a                	js     802295 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80225b:	83 ec 04             	sub    $0x4,%esp
  80225e:	68 07 04 00 00       	push   $0x407
  802263:	ff 75 f4             	pushl  -0xc(%ebp)
  802266:	6a 00                	push   $0x0
  802268:	e8 df eb ff ff       	call   800e4c <sys_page_alloc>
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	85 c0                	test   %eax,%eax
  802272:	78 21                	js     802295 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80227d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	50                   	push   %eax
  80228d:	e8 af ee ff ff       	call   801141 <fd2num>
  802292:	83 c4 10             	add    $0x10,%esp
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	56                   	push   %esi
  80229b:	53                   	push   %ebx
  80229c:	8b 75 08             	mov    0x8(%ebp),%esi
  80229f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022a5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022a7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022ac:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022af:	83 ec 0c             	sub    $0xc,%esp
  8022b2:	50                   	push   %eax
  8022b3:	e8 44 ed ff ff       	call   800ffc <sys_ipc_recv>
	if(ret < 0){
  8022b8:	83 c4 10             	add    $0x10,%esp
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	78 2b                	js     8022ea <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022bf:	85 f6                	test   %esi,%esi
  8022c1:	74 0a                	je     8022cd <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c8:	8b 40 78             	mov    0x78(%eax),%eax
  8022cb:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022cd:	85 db                	test   %ebx,%ebx
  8022cf:	74 0a                	je     8022db <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022d9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022db:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022e6:	5b                   	pop    %ebx
  8022e7:	5e                   	pop    %esi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
		if(from_env_store)
  8022ea:	85 f6                	test   %esi,%esi
  8022ec:	74 06                	je     8022f4 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022ee:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022f4:	85 db                	test   %ebx,%ebx
  8022f6:	74 eb                	je     8022e3 <ipc_recv+0x4c>
			*perm_store = 0;
  8022f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022fe:	eb e3                	jmp    8022e3 <ipc_recv+0x4c>

00802300 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	57                   	push   %edi
  802304:	56                   	push   %esi
  802305:	53                   	push   %ebx
  802306:	83 ec 0c             	sub    $0xc,%esp
  802309:	8b 7d 08             	mov    0x8(%ebp),%edi
  80230c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80230f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802312:	85 db                	test   %ebx,%ebx
  802314:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802319:	0f 44 d8             	cmove  %eax,%ebx
  80231c:	eb 05                	jmp    802323 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80231e:	e8 0a eb ff ff       	call   800e2d <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802323:	ff 75 14             	pushl  0x14(%ebp)
  802326:	53                   	push   %ebx
  802327:	56                   	push   %esi
  802328:	57                   	push   %edi
  802329:	e8 ab ec ff ff       	call   800fd9 <sys_ipc_try_send>
  80232e:	83 c4 10             	add    $0x10,%esp
  802331:	85 c0                	test   %eax,%eax
  802333:	74 1b                	je     802350 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802335:	79 e7                	jns    80231e <ipc_send+0x1e>
  802337:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80233a:	74 e2                	je     80231e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80233c:	83 ec 04             	sub    $0x4,%esp
  80233f:	68 ff 2b 80 00       	push   $0x802bff
  802344:	6a 46                	push   $0x46
  802346:	68 14 2c 80 00       	push   $0x802c14
  80234b:	e8 b5 de ff ff       	call   800205 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5f                   	pop    %edi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802363:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802369:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80236f:	8b 52 50             	mov    0x50(%edx),%edx
  802372:	39 ca                	cmp    %ecx,%edx
  802374:	74 11                	je     802387 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802376:	83 c0 01             	add    $0x1,%eax
  802379:	3d 00 04 00 00       	cmp    $0x400,%eax
  80237e:	75 e3                	jne    802363 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
  802385:	eb 0e                	jmp    802395 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802387:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80238d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802392:	8b 40 48             	mov    0x48(%eax),%eax
}
  802395:	5d                   	pop    %ebp
  802396:	c3                   	ret    

00802397 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80239d:	89 d0                	mov    %edx,%eax
  80239f:	c1 e8 16             	shr    $0x16,%eax
  8023a2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023ae:	f6 c1 01             	test   $0x1,%cl
  8023b1:	74 1d                	je     8023d0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023b3:	c1 ea 0c             	shr    $0xc,%edx
  8023b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023bd:	f6 c2 01             	test   $0x1,%dl
  8023c0:	74 0e                	je     8023d0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023c2:	c1 ea 0c             	shr    $0xc,%edx
  8023c5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023cc:	ef 
  8023cd:	0f b7 c0             	movzwl %ax,%eax
}
  8023d0:	5d                   	pop    %ebp
  8023d1:	c3                   	ret    
  8023d2:	66 90                	xchg   %ax,%ax
  8023d4:	66 90                	xchg   %ax,%ax
  8023d6:	66 90                	xchg   %ax,%ax
  8023d8:	66 90                	xchg   %ax,%ax
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__udivdi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023f7:	85 d2                	test   %edx,%edx
  8023f9:	75 4d                	jne    802448 <__udivdi3+0x68>
  8023fb:	39 f3                	cmp    %esi,%ebx
  8023fd:	76 19                	jbe    802418 <__udivdi3+0x38>
  8023ff:	31 ff                	xor    %edi,%edi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f2                	mov    %esi,%edx
  802405:	f7 f3                	div    %ebx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 d9                	mov    %ebx,%ecx
  80241a:	85 db                	test   %ebx,%ebx
  80241c:	75 0b                	jne    802429 <__udivdi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f3                	div    %ebx
  802427:	89 c1                	mov    %eax,%ecx
  802429:	31 d2                	xor    %edx,%edx
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	f7 f1                	div    %ecx
  80242f:	89 c6                	mov    %eax,%esi
  802431:	89 e8                	mov    %ebp,%eax
  802433:	89 f7                	mov    %esi,%edi
  802435:	f7 f1                	div    %ecx
  802437:	89 fa                	mov    %edi,%edx
  802439:	83 c4 1c             	add    $0x1c,%esp
  80243c:	5b                   	pop    %ebx
  80243d:	5e                   	pop    %esi
  80243e:	5f                   	pop    %edi
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	39 f2                	cmp    %esi,%edx
  80244a:	77 1c                	ja     802468 <__udivdi3+0x88>
  80244c:	0f bd fa             	bsr    %edx,%edi
  80244f:	83 f7 1f             	xor    $0x1f,%edi
  802452:	75 2c                	jne    802480 <__udivdi3+0xa0>
  802454:	39 f2                	cmp    %esi,%edx
  802456:	72 06                	jb     80245e <__udivdi3+0x7e>
  802458:	31 c0                	xor    %eax,%eax
  80245a:	39 eb                	cmp    %ebp,%ebx
  80245c:	77 a9                	ja     802407 <__udivdi3+0x27>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	eb a2                	jmp    802407 <__udivdi3+0x27>
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	31 ff                	xor    %edi,%edi
  80246a:	31 c0                	xor    %eax,%eax
  80246c:	89 fa                	mov    %edi,%edx
  80246e:	83 c4 1c             	add    $0x1c,%esp
  802471:	5b                   	pop    %ebx
  802472:	5e                   	pop    %esi
  802473:	5f                   	pop    %edi
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    
  802476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	89 f9                	mov    %edi,%ecx
  802482:	b8 20 00 00 00       	mov    $0x20,%eax
  802487:	29 f8                	sub    %edi,%eax
  802489:	d3 e2                	shl    %cl,%edx
  80248b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80248f:	89 c1                	mov    %eax,%ecx
  802491:	89 da                	mov    %ebx,%edx
  802493:	d3 ea                	shr    %cl,%edx
  802495:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802499:	09 d1                	or     %edx,%ecx
  80249b:	89 f2                	mov    %esi,%edx
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 f9                	mov    %edi,%ecx
  8024a3:	d3 e3                	shl    %cl,%ebx
  8024a5:	89 c1                	mov    %eax,%ecx
  8024a7:	d3 ea                	shr    %cl,%edx
  8024a9:	89 f9                	mov    %edi,%ecx
  8024ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024af:	89 eb                	mov    %ebp,%ebx
  8024b1:	d3 e6                	shl    %cl,%esi
  8024b3:	89 c1                	mov    %eax,%ecx
  8024b5:	d3 eb                	shr    %cl,%ebx
  8024b7:	09 de                	or     %ebx,%esi
  8024b9:	89 f0                	mov    %esi,%eax
  8024bb:	f7 74 24 08          	divl   0x8(%esp)
  8024bf:	89 d6                	mov    %edx,%esi
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	f7 64 24 0c          	mull   0xc(%esp)
  8024c7:	39 d6                	cmp    %edx,%esi
  8024c9:	72 15                	jb     8024e0 <__udivdi3+0x100>
  8024cb:	89 f9                	mov    %edi,%ecx
  8024cd:	d3 e5                	shl    %cl,%ebp
  8024cf:	39 c5                	cmp    %eax,%ebp
  8024d1:	73 04                	jae    8024d7 <__udivdi3+0xf7>
  8024d3:	39 d6                	cmp    %edx,%esi
  8024d5:	74 09                	je     8024e0 <__udivdi3+0x100>
  8024d7:	89 d8                	mov    %ebx,%eax
  8024d9:	31 ff                	xor    %edi,%edi
  8024db:	e9 27 ff ff ff       	jmp    802407 <__udivdi3+0x27>
  8024e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024e3:	31 ff                	xor    %edi,%edi
  8024e5:	e9 1d ff ff ff       	jmp    802407 <__udivdi3+0x27>
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__umoddi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802507:	89 da                	mov    %ebx,%edx
  802509:	85 c0                	test   %eax,%eax
  80250b:	75 43                	jne    802550 <__umoddi3+0x60>
  80250d:	39 df                	cmp    %ebx,%edi
  80250f:	76 17                	jbe    802528 <__umoddi3+0x38>
  802511:	89 f0                	mov    %esi,%eax
  802513:	f7 f7                	div    %edi
  802515:	89 d0                	mov    %edx,%eax
  802517:	31 d2                	xor    %edx,%edx
  802519:	83 c4 1c             	add    $0x1c,%esp
  80251c:	5b                   	pop    %ebx
  80251d:	5e                   	pop    %esi
  80251e:	5f                   	pop    %edi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
  802521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802528:	89 fd                	mov    %edi,%ebp
  80252a:	85 ff                	test   %edi,%edi
  80252c:	75 0b                	jne    802539 <__umoddi3+0x49>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f7                	div    %edi
  802537:	89 c5                	mov    %eax,%ebp
  802539:	89 d8                	mov    %ebx,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f5                	div    %ebp
  80253f:	89 f0                	mov    %esi,%eax
  802541:	f7 f5                	div    %ebp
  802543:	89 d0                	mov    %edx,%eax
  802545:	eb d0                	jmp    802517 <__umoddi3+0x27>
  802547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254e:	66 90                	xchg   %ax,%ax
  802550:	89 f1                	mov    %esi,%ecx
  802552:	39 d8                	cmp    %ebx,%eax
  802554:	76 0a                	jbe    802560 <__umoddi3+0x70>
  802556:	89 f0                	mov    %esi,%eax
  802558:	83 c4 1c             	add    $0x1c,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	0f bd e8             	bsr    %eax,%ebp
  802563:	83 f5 1f             	xor    $0x1f,%ebp
  802566:	75 20                	jne    802588 <__umoddi3+0x98>
  802568:	39 d8                	cmp    %ebx,%eax
  80256a:	0f 82 b0 00 00 00    	jb     802620 <__umoddi3+0x130>
  802570:	39 f7                	cmp    %esi,%edi
  802572:	0f 86 a8 00 00 00    	jbe    802620 <__umoddi3+0x130>
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	83 c4 1c             	add    $0x1c,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5f                   	pop    %edi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    
  802582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802588:	89 e9                	mov    %ebp,%ecx
  80258a:	ba 20 00 00 00       	mov    $0x20,%edx
  80258f:	29 ea                	sub    %ebp,%edx
  802591:	d3 e0                	shl    %cl,%eax
  802593:	89 44 24 08          	mov    %eax,0x8(%esp)
  802597:	89 d1                	mov    %edx,%ecx
  802599:	89 f8                	mov    %edi,%eax
  80259b:	d3 e8                	shr    %cl,%eax
  80259d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025a9:	09 c1                	or     %eax,%ecx
  8025ab:	89 d8                	mov    %ebx,%eax
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 e9                	mov    %ebp,%ecx
  8025b3:	d3 e7                	shl    %cl,%edi
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025bf:	d3 e3                	shl    %cl,%ebx
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	89 d1                	mov    %edx,%ecx
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	d3 e8                	shr    %cl,%eax
  8025c9:	89 e9                	mov    %ebp,%ecx
  8025cb:	89 fa                	mov    %edi,%edx
  8025cd:	d3 e6                	shl    %cl,%esi
  8025cf:	09 d8                	or     %ebx,%eax
  8025d1:	f7 74 24 08          	divl   0x8(%esp)
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	89 f3                	mov    %esi,%ebx
  8025d9:	f7 64 24 0c          	mull   0xc(%esp)
  8025dd:	89 c6                	mov    %eax,%esi
  8025df:	89 d7                	mov    %edx,%edi
  8025e1:	39 d1                	cmp    %edx,%ecx
  8025e3:	72 06                	jb     8025eb <__umoddi3+0xfb>
  8025e5:	75 10                	jne    8025f7 <__umoddi3+0x107>
  8025e7:	39 c3                	cmp    %eax,%ebx
  8025e9:	73 0c                	jae    8025f7 <__umoddi3+0x107>
  8025eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025f3:	89 d7                	mov    %edx,%edi
  8025f5:	89 c6                	mov    %eax,%esi
  8025f7:	89 ca                	mov    %ecx,%edx
  8025f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025fe:	29 f3                	sub    %esi,%ebx
  802600:	19 fa                	sbb    %edi,%edx
  802602:	89 d0                	mov    %edx,%eax
  802604:	d3 e0                	shl    %cl,%eax
  802606:	89 e9                	mov    %ebp,%ecx
  802608:	d3 eb                	shr    %cl,%ebx
  80260a:	d3 ea                	shr    %cl,%edx
  80260c:	09 d8                	or     %ebx,%eax
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	89 da                	mov    %ebx,%edx
  802622:	29 fe                	sub    %edi,%esi
  802624:	19 c2                	sbb    %eax,%edx
  802626:	89 f1                	mov    %esi,%ecx
  802628:	89 c8                	mov    %ecx,%eax
  80262a:	e9 4b ff ff ff       	jmp    80257a <__umoddi3+0x8a>
