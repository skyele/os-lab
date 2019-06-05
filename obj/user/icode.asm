
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 20 	movl   $0x802c20,0x804000
  800045:	2c 80 00 

	cprintf("icode startup\n");
  800048:	68 26 2c 80 00       	push   $0x802c26
  80004d:	e8 94 02 00 00       	call   8002e6 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 35 2c 80 00 	movl   $0x802c35,(%esp)
  800059:	e8 88 02 00 00       	call   8002e6 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 48 2c 80 00       	push   $0x802c48
  800068:	e8 26 18 00 00       	call   801893 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 71 2c 80 00       	push   $0x802c71
  80007e:	e8 63 02 00 00       	call   8002e6 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 5a 13 00 00       	call   8013f5 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 cf 0c 00 00       	call   800d7b <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 4e 2c 80 00       	push   $0x802c4e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 64 2c 80 00       	push   $0x802c64
  8000be:	e8 2d 01 00 00       	call   8001f0 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 84 2c 80 00       	push   $0x802c84
  8000cb:	e8 16 02 00 00       	call   8002e6 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 df 11 00 00       	call   8012b7 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 98 2c 80 00 	movl   $0x802c98,(%esp)
  8000df:	e8 02 02 00 00       	call   8002e6 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ac 2c 80 00       	push   $0x802cac
  8000f0:	68 b5 2c 80 00       	push   $0x802cb5
  8000f5:	68 bf 2c 80 00       	push   $0x802cbf
  8000fa:	68 be 2c 80 00       	push   $0x802cbe
  8000ff:	e8 c1 1d 00 00       	call   801ec5 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 db 2c 80 00       	push   $0x802cdb
  800113:	e8 ce 01 00 00       	call   8002e6 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 c4 2c 80 00       	push   $0x802cc4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 64 2c 80 00       	push   $0x802c64
  80012f:	e8 bc 00 00 00       	call   8001f0 <_panic>

00800134 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	57                   	push   %edi
  800138:	56                   	push   %esi
  800139:	53                   	push   %ebx
  80013a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80013d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800144:	00 00 00 
	envid_t find = sys_getenvid();
  800147:	e8 ad 0c 00 00       	call   800df9 <sys_getenvid>
  80014c:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800152:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800157:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80015c:	bf 01 00 00 00       	mov    $0x1,%edi
  800161:	eb 0b                	jmp    80016e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800163:	83 c2 01             	add    $0x1,%edx
  800166:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80016c:	74 21                	je     80018f <libmain+0x5b>
		if(envs[i].env_id == find)
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	c1 e1 07             	shl    $0x7,%ecx
  800173:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800179:	8b 49 48             	mov    0x48(%ecx),%ecx
  80017c:	39 c1                	cmp    %eax,%ecx
  80017e:	75 e3                	jne    800163 <libmain+0x2f>
  800180:	89 d3                	mov    %edx,%ebx
  800182:	c1 e3 07             	shl    $0x7,%ebx
  800185:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80018b:	89 fe                	mov    %edi,%esi
  80018d:	eb d4                	jmp    800163 <libmain+0x2f>
  80018f:	89 f0                	mov    %esi,%eax
  800191:	84 c0                	test   %al,%al
  800193:	74 06                	je     80019b <libmain+0x67>
  800195:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019f:	7e 0a                	jle    8001ab <libmain+0x77>
		binaryname = argv[0];
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	8b 00                	mov    (%eax),%eax
  8001a6:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 eb 2c 80 00       	push   $0x802ceb
  8001b3:	e8 2e 01 00 00       	call   8002e6 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001b8:	83 c4 08             	add    $0x8,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	e8 6d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001c6:	e8 0b 00 00 00       	call   8001d6 <exit>
}
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    

008001d6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001dc:	e8 03 11 00 00       	call   8012e4 <close_all>
	sys_env_destroy(0);
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	6a 00                	push   $0x0
  8001e6:	e8 cd 0b 00 00       	call   800db8 <sys_env_destroy>
}
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8001fa:	8b 40 48             	mov    0x48(%eax),%eax
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	68 40 2d 80 00       	push   $0x802d40
  800205:	50                   	push   %eax
  800206:	68 0f 2d 80 00       	push   $0x802d0f
  80020b:	e8 d6 00 00 00       	call   8002e6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800210:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800213:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800219:	e8 db 0b 00 00       	call   800df9 <sys_getenvid>
  80021e:	83 c4 04             	add    $0x4,%esp
  800221:	ff 75 0c             	pushl  0xc(%ebp)
  800224:	ff 75 08             	pushl  0x8(%ebp)
  800227:	56                   	push   %esi
  800228:	50                   	push   %eax
  800229:	68 1c 2d 80 00       	push   $0x802d1c
  80022e:	e8 b3 00 00 00       	call   8002e6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800233:	83 c4 18             	add    $0x18,%esp
  800236:	53                   	push   %ebx
  800237:	ff 75 10             	pushl  0x10(%ebp)
  80023a:	e8 56 00 00 00       	call   800295 <vcprintf>
	cprintf("\n");
  80023f:	c7 04 24 03 2d 80 00 	movl   $0x802d03,(%esp)
  800246:	e8 9b 00 00 00       	call   8002e6 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024e:	cc                   	int3   
  80024f:	eb fd                	jmp    80024e <_panic+0x5e>

00800251 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	53                   	push   %ebx
  800255:	83 ec 04             	sub    $0x4,%esp
  800258:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025b:	8b 13                	mov    (%ebx),%edx
  80025d:	8d 42 01             	lea    0x1(%edx),%eax
  800260:	89 03                	mov    %eax,(%ebx)
  800262:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800265:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800269:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026e:	74 09                	je     800279 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800270:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800277:	c9                   	leave  
  800278:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	68 ff 00 00 00       	push   $0xff
  800281:	8d 43 08             	lea    0x8(%ebx),%eax
  800284:	50                   	push   %eax
  800285:	e8 f1 0a 00 00       	call   800d7b <sys_cputs>
		b->idx = 0;
  80028a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800290:	83 c4 10             	add    $0x10,%esp
  800293:	eb db                	jmp    800270 <putch+0x1f>

00800295 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80029e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a5:	00 00 00 
	b.cnt = 0;
  8002a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002af:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	68 51 02 80 00       	push   $0x800251
  8002c4:	e8 4a 01 00 00       	call   800413 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c9:	83 c4 08             	add    $0x8,%esp
  8002cc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 9d 0a 00 00       	call   800d7b <sys_cputs>

	return b.cnt;
}
  8002de:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ef:	50                   	push   %eax
  8002f0:	ff 75 08             	pushl  0x8(%ebp)
  8002f3:	e8 9d ff ff ff       	call   800295 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 1c             	sub    $0x1c,%esp
  800303:	89 c6                	mov    %eax,%esi
  800305:	89 d7                	mov    %edx,%edi
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800310:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800313:	8b 45 10             	mov    0x10(%ebp),%eax
  800316:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800319:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80031d:	74 2c                	je     80034b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80031f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800322:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800329:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032f:	39 c2                	cmp    %eax,%edx
  800331:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800334:	73 43                	jae    800379 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800336:	83 eb 01             	sub    $0x1,%ebx
  800339:	85 db                	test   %ebx,%ebx
  80033b:	7e 6c                	jle    8003a9 <printnum+0xaf>
				putch(padc, putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	57                   	push   %edi
  800341:	ff 75 18             	pushl  0x18(%ebp)
  800344:	ff d6                	call   *%esi
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	eb eb                	jmp    800336 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	6a 20                	push   $0x20
  800350:	6a 00                	push   $0x0
  800352:	50                   	push   %eax
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	ff 75 e0             	pushl  -0x20(%ebp)
  800359:	89 fa                	mov    %edi,%edx
  80035b:	89 f0                	mov    %esi,%eax
  80035d:	e8 98 ff ff ff       	call   8002fa <printnum>
		while (--width > 0)
  800362:	83 c4 20             	add    $0x20,%esp
  800365:	83 eb 01             	sub    $0x1,%ebx
  800368:	85 db                	test   %ebx,%ebx
  80036a:	7e 65                	jle    8003d1 <printnum+0xd7>
			putch(padc, putdat);
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	57                   	push   %edi
  800370:	6a 20                	push   $0x20
  800372:	ff d6                	call   *%esi
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	eb ec                	jmp    800365 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	53                   	push   %ebx
  800383:	50                   	push   %eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 dc             	pushl  -0x24(%ebp)
  80038a:	ff 75 d8             	pushl  -0x28(%ebp)
  80038d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800390:	ff 75 e0             	pushl  -0x20(%ebp)
  800393:	e8 28 26 00 00       	call   8029c0 <__udivdi3>
  800398:	83 c4 18             	add    $0x18,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	89 fa                	mov    %edi,%edx
  80039f:	89 f0                	mov    %esi,%eax
  8003a1:	e8 54 ff ff ff       	call   8002fa <printnum>
  8003a6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003a9:	83 ec 08             	sub    $0x8,%esp
  8003ac:	57                   	push   %edi
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8003b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bc:	e8 0f 27 00 00       	call   802ad0 <__umoddi3>
  8003c1:	83 c4 14             	add    $0x14,%esp
  8003c4:	0f be 80 47 2d 80 00 	movsbl 0x802d47(%eax),%eax
  8003cb:	50                   	push   %eax
  8003cc:	ff d6                	call   *%esi
  8003ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8003d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d4:	5b                   	pop    %ebx
  8003d5:	5e                   	pop    %esi
  8003d6:	5f                   	pop    %edi
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    

008003d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003e3:	8b 10                	mov    (%eax),%edx
  8003e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e8:	73 0a                	jae    8003f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ed:	89 08                	mov    %ecx,(%eax)
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	88 02                	mov    %al,(%edx)
}
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <printfmt>:
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ff:	50                   	push   %eax
  800400:	ff 75 10             	pushl  0x10(%ebp)
  800403:	ff 75 0c             	pushl  0xc(%ebp)
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	e8 05 00 00 00       	call   800413 <vprintfmt>
}
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	c9                   	leave  
  800412:	c3                   	ret    

00800413 <vprintfmt>:
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	57                   	push   %edi
  800417:	56                   	push   %esi
  800418:	53                   	push   %ebx
  800419:	83 ec 3c             	sub    $0x3c,%esp
  80041c:	8b 75 08             	mov    0x8(%ebp),%esi
  80041f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800422:	8b 7d 10             	mov    0x10(%ebp),%edi
  800425:	e9 32 04 00 00       	jmp    80085c <vprintfmt+0x449>
		padc = ' ';
  80042a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80042e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800435:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80043c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800443:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80044a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800451:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8d 47 01             	lea    0x1(%edi),%eax
  800459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045c:	0f b6 17             	movzbl (%edi),%edx
  80045f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800462:	3c 55                	cmp    $0x55,%al
  800464:	0f 87 12 05 00 00    	ja     80097c <vprintfmt+0x569>
  80046a:	0f b6 c0             	movzbl %al,%eax
  80046d:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800477:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80047b:	eb d9                	jmp    800456 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800480:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800484:	eb d0                	jmp    800456 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800486:	0f b6 d2             	movzbl %dl,%edx
  800489:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
  800491:	89 75 08             	mov    %esi,0x8(%ebp)
  800494:	eb 03                	jmp    800499 <vprintfmt+0x86>
  800496:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800499:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004a6:	83 fe 09             	cmp    $0x9,%esi
  8004a9:	76 eb                	jbe    800496 <vprintfmt+0x83>
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b1:	eb 14                	jmp    8004c7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 40 04             	lea    0x4(%eax),%eax
  8004c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cb:	79 89                	jns    800456 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004da:	e9 77 ff ff ff       	jmp    800456 <vprintfmt+0x43>
  8004df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e2:	85 c0                	test   %eax,%eax
  8004e4:	0f 48 c1             	cmovs  %ecx,%eax
  8004e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ed:	e9 64 ff ff ff       	jmp    800456 <vprintfmt+0x43>
  8004f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004fc:	e9 55 ff ff ff       	jmp    800456 <vprintfmt+0x43>
			lflag++;
  800501:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800505:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800508:	e9 49 ff ff ff       	jmp    800456 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 78 04             	lea    0x4(%eax),%edi
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	53                   	push   %ebx
  800517:	ff 30                	pushl  (%eax)
  800519:	ff d6                	call   *%esi
			break;
  80051b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80051e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800521:	e9 33 03 00 00       	jmp    800859 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8d 78 04             	lea    0x4(%eax),%edi
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	99                   	cltd   
  80052f:	31 d0                	xor    %edx,%eax
  800531:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800533:	83 f8 10             	cmp    $0x10,%eax
  800536:	7f 23                	jg     80055b <vprintfmt+0x148>
  800538:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  80053f:	85 d2                	test   %edx,%edx
  800541:	74 18                	je     80055b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800543:	52                   	push   %edx
  800544:	68 99 31 80 00       	push   $0x803199
  800549:	53                   	push   %ebx
  80054a:	56                   	push   %esi
  80054b:	e8 a6 fe ff ff       	call   8003f6 <printfmt>
  800550:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800553:	89 7d 14             	mov    %edi,0x14(%ebp)
  800556:	e9 fe 02 00 00       	jmp    800859 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80055b:	50                   	push   %eax
  80055c:	68 5f 2d 80 00       	push   $0x802d5f
  800561:	53                   	push   %ebx
  800562:	56                   	push   %esi
  800563:	e8 8e fe ff ff       	call   8003f6 <printfmt>
  800568:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80056e:	e9 e6 02 00 00       	jmp    800859 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 c0 04             	add    $0x4,%eax
  800579:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800581:	85 c9                	test   %ecx,%ecx
  800583:	b8 58 2d 80 00       	mov    $0x802d58,%eax
  800588:	0f 45 c1             	cmovne %ecx,%eax
  80058b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80058e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800592:	7e 06                	jle    80059a <vprintfmt+0x187>
  800594:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800598:	75 0d                	jne    8005a7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a5:	eb 53                	jmp    8005fa <vprintfmt+0x1e7>
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 71 04 00 00       	call   800a24 <strnlen>
  8005b3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b6:	29 c1                	sub    %eax,%ecx
  8005b8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005c0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c7:	eb 0f                	jmp    8005d8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	53                   	push   %ebx
  8005cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d2:	83 ef 01             	sub    $0x1,%edi
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	85 ff                	test   %edi,%edi
  8005da:	7f ed                	jg     8005c9 <vprintfmt+0x1b6>
  8005dc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005df:	85 c9                	test   %ecx,%ecx
  8005e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e6:	0f 49 c1             	cmovns %ecx,%eax
  8005e9:	29 c1                	sub    %eax,%ecx
  8005eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005ee:	eb aa                	jmp    80059a <vprintfmt+0x187>
					putch(ch, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	52                   	push   %edx
  8005f5:	ff d6                	call   *%esi
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005fd:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	83 c7 01             	add    $0x1,%edi
  800602:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800606:	0f be d0             	movsbl %al,%edx
  800609:	85 d2                	test   %edx,%edx
  80060b:	74 4b                	je     800658 <vprintfmt+0x245>
  80060d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800611:	78 06                	js     800619 <vprintfmt+0x206>
  800613:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800617:	78 1e                	js     800637 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800619:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80061d:	74 d1                	je     8005f0 <vprintfmt+0x1dd>
  80061f:	0f be c0             	movsbl %al,%eax
  800622:	83 e8 20             	sub    $0x20,%eax
  800625:	83 f8 5e             	cmp    $0x5e,%eax
  800628:	76 c6                	jbe    8005f0 <vprintfmt+0x1dd>
					putch('?', putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	53                   	push   %ebx
  80062e:	6a 3f                	push   $0x3f
  800630:	ff d6                	call   *%esi
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb c3                	jmp    8005fa <vprintfmt+0x1e7>
  800637:	89 cf                	mov    %ecx,%edi
  800639:	eb 0e                	jmp    800649 <vprintfmt+0x236>
				putch(' ', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 20                	push   $0x20
  800641:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800643:	83 ef 01             	sub    $0x1,%edi
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	85 ff                	test   %edi,%edi
  80064b:	7f ee                	jg     80063b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80064d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
  800653:	e9 01 02 00 00       	jmp    800859 <vprintfmt+0x446>
  800658:	89 cf                	mov    %ecx,%edi
  80065a:	eb ed                	jmp    800649 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80065c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80065f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800666:	e9 eb fd ff ff       	jmp    800456 <vprintfmt+0x43>
	if (lflag >= 2)
  80066b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066f:	7f 21                	jg     800692 <vprintfmt+0x27f>
	else if (lflag)
  800671:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800675:	74 68                	je     8006df <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067f:	89 c1                	mov    %eax,%ecx
  800681:	c1 f9 1f             	sar    $0x1f,%ecx
  800684:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
  800690:	eb 17                	jmp    8006a9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 50 04             	mov    0x4(%eax),%edx
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80069d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 08             	lea    0x8(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b9:	78 3f                	js     8006fa <vprintfmt+0x2e7>
			base = 10;
  8006bb:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006c0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006c4:	0f 84 71 01 00 00    	je     80083b <vprintfmt+0x428>
				putch('+', putdat);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	53                   	push   %ebx
  8006ce:	6a 2b                	push   $0x2b
  8006d0:	ff d6                	call   *%esi
  8006d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006da:	e9 5c 01 00 00       	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e7:	89 c1                	mov    %eax,%ecx
  8006e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	eb af                	jmp    8006a9 <vprintfmt+0x296>
				putch('-', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 2d                	push   $0x2d
  800700:	ff d6                	call   *%esi
				num = -(long long) num;
  800702:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800705:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800708:	f7 d8                	neg    %eax
  80070a:	83 d2 00             	adc    $0x0,%edx
  80070d:	f7 da                	neg    %edx
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800715:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800718:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071d:	e9 19 01 00 00       	jmp    80083b <vprintfmt+0x428>
	if (lflag >= 2)
  800722:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800726:	7f 29                	jg     800751 <vprintfmt+0x33e>
	else if (lflag)
  800728:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072c:	74 44                	je     800772 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	ba 00 00 00 00       	mov    $0x0,%edx
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800747:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074c:	e9 ea 00 00 00       	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 08             	lea    0x8(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800768:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076d:	e9 c9 00 00 00       	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800790:	e9 a6 00 00 00       	jmp    80083b <vprintfmt+0x428>
			putch('0', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	6a 30                	push   $0x30
  80079b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a4:	7f 26                	jg     8007cc <vprintfmt+0x3b9>
	else if (lflag)
  8007a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007aa:	74 3e                	je     8007ea <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
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
  8007ca:	eb 6f                	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 50 04             	mov    0x4(%eax),%edx
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 08             	lea    0x8(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e8:	eb 51                	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 40 04             	lea    0x4(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800803:	b8 08 00 00 00       	mov    $0x8,%eax
  800808:	eb 31                	jmp    80083b <vprintfmt+0x428>
			putch('0', putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	6a 30                	push   $0x30
  800810:	ff d6                	call   *%esi
			putch('x', putdat);
  800812:	83 c4 08             	add    $0x8,%esp
  800815:	53                   	push   %ebx
  800816:	6a 78                	push   $0x78
  800818:	ff d6                	call   *%esi
			num = (unsigned long long)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	ba 00 00 00 00       	mov    $0x0,%edx
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800827:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80082a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 04             	lea    0x4(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800836:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800842:	52                   	push   %edx
  800843:	ff 75 e0             	pushl  -0x20(%ebp)
  800846:	50                   	push   %eax
  800847:	ff 75 dc             	pushl  -0x24(%ebp)
  80084a:	ff 75 d8             	pushl  -0x28(%ebp)
  80084d:	89 da                	mov    %ebx,%edx
  80084f:	89 f0                	mov    %esi,%eax
  800851:	e8 a4 fa ff ff       	call   8002fa <printnum>
			break;
  800856:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800859:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085c:	83 c7 01             	add    $0x1,%edi
  80085f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800863:	83 f8 25             	cmp    $0x25,%eax
  800866:	0f 84 be fb ff ff    	je     80042a <vprintfmt+0x17>
			if (ch == '\0')
  80086c:	85 c0                	test   %eax,%eax
  80086e:	0f 84 28 01 00 00    	je     80099c <vprintfmt+0x589>
			putch(ch, putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	50                   	push   %eax
  800879:	ff d6                	call   *%esi
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	eb dc                	jmp    80085c <vprintfmt+0x449>
	if (lflag >= 2)
  800880:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800884:	7f 26                	jg     8008ac <vprintfmt+0x499>
	else if (lflag)
  800886:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80088a:	74 41                	je     8008cd <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	ba 00 00 00 00       	mov    $0x0,%edx
  800896:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800899:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8d 40 04             	lea    0x4(%eax),%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008aa:	eb 8f                	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8b 50 04             	mov    0x4(%eax),%edx
  8008b2:	8b 00                	mov    (%eax),%eax
  8008b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8d 40 08             	lea    0x8(%eax),%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c8:	e9 6e ff ff ff       	jmp    80083b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8d 40 04             	lea    0x4(%eax),%eax
  8008e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008eb:	e9 4b ff ff ff       	jmp    80083b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 c0 04             	add    $0x4,%eax
  8008f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	85 c0                	test   %eax,%eax
  800900:	74 14                	je     800916 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800902:	8b 13                	mov    (%ebx),%edx
  800904:	83 fa 7f             	cmp    $0x7f,%edx
  800907:	7f 37                	jg     800940 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800909:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80090b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80090e:	89 45 14             	mov    %eax,0x14(%ebp)
  800911:	e9 43 ff ff ff       	jmp    800859 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800916:	b8 0a 00 00 00       	mov    $0xa,%eax
  80091b:	bf 7d 2e 80 00       	mov    $0x802e7d,%edi
							putch(ch, putdat);
  800920:	83 ec 08             	sub    $0x8,%esp
  800923:	53                   	push   %ebx
  800924:	50                   	push   %eax
  800925:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800927:	83 c7 01             	add    $0x1,%edi
  80092a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	85 c0                	test   %eax,%eax
  800933:	75 eb                	jne    800920 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800935:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800938:	89 45 14             	mov    %eax,0x14(%ebp)
  80093b:	e9 19 ff ff ff       	jmp    800859 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800940:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800942:	b8 0a 00 00 00       	mov    $0xa,%eax
  800947:	bf b5 2e 80 00       	mov    $0x802eb5,%edi
							putch(ch, putdat);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	53                   	push   %ebx
  800950:	50                   	push   %eax
  800951:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800953:	83 c7 01             	add    $0x1,%edi
  800956:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80095a:	83 c4 10             	add    $0x10,%esp
  80095d:	85 c0                	test   %eax,%eax
  80095f:	75 eb                	jne    80094c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800961:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	e9 ed fe ff ff       	jmp    800859 <vprintfmt+0x446>
			putch(ch, putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	6a 25                	push   $0x25
  800972:	ff d6                	call   *%esi
			break;
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	e9 dd fe ff ff       	jmp    800859 <vprintfmt+0x446>
			putch('%', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	53                   	push   %ebx
  800980:	6a 25                	push   $0x25
  800982:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 f8                	mov    %edi,%eax
  800989:	eb 03                	jmp    80098e <vprintfmt+0x57b>
  80098b:	83 e8 01             	sub    $0x1,%eax
  80098e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800992:	75 f7                	jne    80098b <vprintfmt+0x578>
  800994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800997:	e9 bd fe ff ff       	jmp    800859 <vprintfmt+0x446>
}
  80099c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5f                   	pop    %edi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 18             	sub    $0x18,%esp
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c1:	85 c0                	test   %eax,%eax
  8009c3:	74 26                	je     8009eb <vsnprintf+0x47>
  8009c5:	85 d2                	test   %edx,%edx
  8009c7:	7e 22                	jle    8009eb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c9:	ff 75 14             	pushl  0x14(%ebp)
  8009cc:	ff 75 10             	pushl  0x10(%ebp)
  8009cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009d2:	50                   	push   %eax
  8009d3:	68 d9 03 80 00       	push   $0x8003d9
  8009d8:	e8 36 fa ff ff       	call   800413 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
}
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    
		return -E_INVAL;
  8009eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f0:	eb f7                	jmp    8009e9 <vsnprintf+0x45>

008009f2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009fb:	50                   	push   %eax
  8009fc:	ff 75 10             	pushl  0x10(%ebp)
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	ff 75 08             	pushl  0x8(%ebp)
  800a05:	e8 9a ff ff ff       	call   8009a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
  800a17:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a1b:	74 05                	je     800a22 <strlen+0x16>
		n++;
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	eb f5                	jmp    800a17 <strlen+0xb>
	return n;
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a32:	39 c2                	cmp    %eax,%edx
  800a34:	74 0d                	je     800a43 <strnlen+0x1f>
  800a36:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a3a:	74 05                	je     800a41 <strnlen+0x1d>
		n++;
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	eb f1                	jmp    800a32 <strnlen+0xe>
  800a41:	89 d0                	mov    %edx,%eax
	return n;
}
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	53                   	push   %ebx
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a54:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a58:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a5b:	83 c2 01             	add    $0x1,%edx
  800a5e:	84 c9                	test   %cl,%cl
  800a60:	75 f2                	jne    800a54 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a62:	5b                   	pop    %ebx
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	53                   	push   %ebx
  800a69:	83 ec 10             	sub    $0x10,%esp
  800a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6f:	53                   	push   %ebx
  800a70:	e8 97 ff ff ff       	call   800a0c <strlen>
  800a75:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a78:	ff 75 0c             	pushl  0xc(%ebp)
  800a7b:	01 d8                	add    %ebx,%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 c2 ff ff ff       	call   800a45 <strcpy>
	return dst;
}
  800a83:	89 d8                	mov    %ebx,%eax
  800a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a95:	89 c6                	mov    %eax,%esi
  800a97:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9a:	89 c2                	mov    %eax,%edx
  800a9c:	39 f2                	cmp    %esi,%edx
  800a9e:	74 11                	je     800ab1 <strncpy+0x27>
		*dst++ = *src;
  800aa0:	83 c2 01             	add    $0x1,%edx
  800aa3:	0f b6 19             	movzbl (%ecx),%ebx
  800aa6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa9:	80 fb 01             	cmp    $0x1,%bl
  800aac:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aaf:	eb eb                	jmp    800a9c <strncpy+0x12>
	}
	return ret;
}
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	56                   	push   %esi
  800ab9:	53                   	push   %ebx
  800aba:	8b 75 08             	mov    0x8(%ebp),%esi
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac0:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac5:	85 d2                	test   %edx,%edx
  800ac7:	74 21                	je     800aea <strlcpy+0x35>
  800ac9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800acf:	39 c2                	cmp    %eax,%edx
  800ad1:	74 14                	je     800ae7 <strlcpy+0x32>
  800ad3:	0f b6 19             	movzbl (%ecx),%ebx
  800ad6:	84 db                	test   %bl,%bl
  800ad8:	74 0b                	je     800ae5 <strlcpy+0x30>
			*dst++ = *src++;
  800ada:	83 c1 01             	add    $0x1,%ecx
  800add:	83 c2 01             	add    $0x1,%edx
  800ae0:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae3:	eb ea                	jmp    800acf <strlcpy+0x1a>
  800ae5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aea:	29 f0                	sub    %esi,%eax
}
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	84 c0                	test   %al,%al
  800afe:	74 0c                	je     800b0c <strcmp+0x1c>
  800b00:	3a 02                	cmp    (%edx),%al
  800b02:	75 08                	jne    800b0c <strcmp+0x1c>
		p++, q++;
  800b04:	83 c1 01             	add    $0x1,%ecx
  800b07:	83 c2 01             	add    $0x1,%edx
  800b0a:	eb ed                	jmp    800af9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0c:	0f b6 c0             	movzbl %al,%eax
  800b0f:	0f b6 12             	movzbl (%edx),%edx
  800b12:	29 d0                	sub    %edx,%eax
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	53                   	push   %ebx
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	89 c3                	mov    %eax,%ebx
  800b22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b25:	eb 06                	jmp    800b2d <strncmp+0x17>
		n--, p++, q++;
  800b27:	83 c0 01             	add    $0x1,%eax
  800b2a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b2d:	39 d8                	cmp    %ebx,%eax
  800b2f:	74 16                	je     800b47 <strncmp+0x31>
  800b31:	0f b6 08             	movzbl (%eax),%ecx
  800b34:	84 c9                	test   %cl,%cl
  800b36:	74 04                	je     800b3c <strncmp+0x26>
  800b38:	3a 0a                	cmp    (%edx),%cl
  800b3a:	74 eb                	je     800b27 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b3c:	0f b6 00             	movzbl (%eax),%eax
  800b3f:	0f b6 12             	movzbl (%edx),%edx
  800b42:	29 d0                	sub    %edx,%eax
}
  800b44:	5b                   	pop    %ebx
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    
		return 0;
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4c:	eb f6                	jmp    800b44 <strncmp+0x2e>

00800b4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b58:	0f b6 10             	movzbl (%eax),%edx
  800b5b:	84 d2                	test   %dl,%dl
  800b5d:	74 09                	je     800b68 <strchr+0x1a>
		if (*s == c)
  800b5f:	38 ca                	cmp    %cl,%dl
  800b61:	74 0a                	je     800b6d <strchr+0x1f>
	for (; *s; s++)
  800b63:	83 c0 01             	add    $0x1,%eax
  800b66:	eb f0                	jmp    800b58 <strchr+0xa>
			return (char *) s;
	return 0;
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b79:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b7c:	38 ca                	cmp    %cl,%dl
  800b7e:	74 09                	je     800b89 <strfind+0x1a>
  800b80:	84 d2                	test   %dl,%dl
  800b82:	74 05                	je     800b89 <strfind+0x1a>
	for (; *s; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	eb f0                	jmp    800b79 <strfind+0xa>
			break;
	return (char *) s;
}
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
  800b91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b97:	85 c9                	test   %ecx,%ecx
  800b99:	74 31                	je     800bcc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9b:	89 f8                	mov    %edi,%eax
  800b9d:	09 c8                	or     %ecx,%eax
  800b9f:	a8 03                	test   $0x3,%al
  800ba1:	75 23                	jne    800bc6 <memset+0x3b>
		c &= 0xFF;
  800ba3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	c1 e3 08             	shl    $0x8,%ebx
  800bac:	89 d0                	mov    %edx,%eax
  800bae:	c1 e0 18             	shl    $0x18,%eax
  800bb1:	89 d6                	mov    %edx,%esi
  800bb3:	c1 e6 10             	shl    $0x10,%esi
  800bb6:	09 f0                	or     %esi,%eax
  800bb8:	09 c2                	or     %eax,%edx
  800bba:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bbc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bbf:	89 d0                	mov    %edx,%eax
  800bc1:	fc                   	cld    
  800bc2:	f3 ab                	rep stos %eax,%es:(%edi)
  800bc4:	eb 06                	jmp    800bcc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	fc                   	cld    
  800bca:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bcc:	89 f8                	mov    %edi,%eax
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be1:	39 c6                	cmp    %eax,%esi
  800be3:	73 32                	jae    800c17 <memmove+0x44>
  800be5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be8:	39 c2                	cmp    %eax,%edx
  800bea:	76 2b                	jbe    800c17 <memmove+0x44>
		s += n;
		d += n;
  800bec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bef:	89 fe                	mov    %edi,%esi
  800bf1:	09 ce                	or     %ecx,%esi
  800bf3:	09 d6                	or     %edx,%esi
  800bf5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bfb:	75 0e                	jne    800c0b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bfd:	83 ef 04             	sub    $0x4,%edi
  800c00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c06:	fd                   	std    
  800c07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c09:	eb 09                	jmp    800c14 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c0b:	83 ef 01             	sub    $0x1,%edi
  800c0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c11:	fd                   	std    
  800c12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c14:	fc                   	cld    
  800c15:	eb 1a                	jmp    800c31 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c17:	89 c2                	mov    %eax,%edx
  800c19:	09 ca                	or     %ecx,%edx
  800c1b:	09 f2                	or     %esi,%edx
  800c1d:	f6 c2 03             	test   $0x3,%dl
  800c20:	75 0a                	jne    800c2c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	fc                   	cld    
  800c28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2a:	eb 05                	jmp    800c31 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c2c:	89 c7                	mov    %eax,%edi
  800c2e:	fc                   	cld    
  800c2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c3b:	ff 75 10             	pushl  0x10(%ebp)
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	ff 75 08             	pushl  0x8(%ebp)
  800c44:	e8 8a ff ff ff       	call   800bd3 <memmove>
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	89 c6                	mov    %eax,%esi
  800c58:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5b:	39 f0                	cmp    %esi,%eax
  800c5d:	74 1c                	je     800c7b <memcmp+0x30>
		if (*s1 != *s2)
  800c5f:	0f b6 08             	movzbl (%eax),%ecx
  800c62:	0f b6 1a             	movzbl (%edx),%ebx
  800c65:	38 d9                	cmp    %bl,%cl
  800c67:	75 08                	jne    800c71 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c69:	83 c0 01             	add    $0x1,%eax
  800c6c:	83 c2 01             	add    $0x1,%edx
  800c6f:	eb ea                	jmp    800c5b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c71:	0f b6 c1             	movzbl %cl,%eax
  800c74:	0f b6 db             	movzbl %bl,%ebx
  800c77:	29 d8                	sub    %ebx,%eax
  800c79:	eb 05                	jmp    800c80 <memcmp+0x35>
	}

	return 0;
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c8d:	89 c2                	mov    %eax,%edx
  800c8f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c92:	39 d0                	cmp    %edx,%eax
  800c94:	73 09                	jae    800c9f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c96:	38 08                	cmp    %cl,(%eax)
  800c98:	74 05                	je     800c9f <memfind+0x1b>
	for (; s < ends; s++)
  800c9a:	83 c0 01             	add    $0x1,%eax
  800c9d:	eb f3                	jmp    800c92 <memfind+0xe>
			break;
	return (void *) s;
}
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cad:	eb 03                	jmp    800cb2 <strtol+0x11>
		s++;
  800caf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cb2:	0f b6 01             	movzbl (%ecx),%eax
  800cb5:	3c 20                	cmp    $0x20,%al
  800cb7:	74 f6                	je     800caf <strtol+0xe>
  800cb9:	3c 09                	cmp    $0x9,%al
  800cbb:	74 f2                	je     800caf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cbd:	3c 2b                	cmp    $0x2b,%al
  800cbf:	74 2a                	je     800ceb <strtol+0x4a>
	int neg = 0;
  800cc1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc6:	3c 2d                	cmp    $0x2d,%al
  800cc8:	74 2b                	je     800cf5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cca:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cd0:	75 0f                	jne    800ce1 <strtol+0x40>
  800cd2:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd5:	74 28                	je     800cff <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd7:	85 db                	test   %ebx,%ebx
  800cd9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cde:	0f 44 d8             	cmove  %eax,%ebx
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce9:	eb 50                	jmp    800d3b <strtol+0x9a>
		s++;
  800ceb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cee:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf3:	eb d5                	jmp    800cca <strtol+0x29>
		s++, neg = 1;
  800cf5:	83 c1 01             	add    $0x1,%ecx
  800cf8:	bf 01 00 00 00       	mov    $0x1,%edi
  800cfd:	eb cb                	jmp    800cca <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cff:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d03:	74 0e                	je     800d13 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d05:	85 db                	test   %ebx,%ebx
  800d07:	75 d8                	jne    800ce1 <strtol+0x40>
		s++, base = 8;
  800d09:	83 c1 01             	add    $0x1,%ecx
  800d0c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d11:	eb ce                	jmp    800ce1 <strtol+0x40>
		s += 2, base = 16;
  800d13:	83 c1 02             	add    $0x2,%ecx
  800d16:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d1b:	eb c4                	jmp    800ce1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d1d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d20:	89 f3                	mov    %esi,%ebx
  800d22:	80 fb 19             	cmp    $0x19,%bl
  800d25:	77 29                	ja     800d50 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d27:	0f be d2             	movsbl %dl,%edx
  800d2a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d2d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d30:	7d 30                	jge    800d62 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d32:	83 c1 01             	add    $0x1,%ecx
  800d35:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d39:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d3b:	0f b6 11             	movzbl (%ecx),%edx
  800d3e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d41:	89 f3                	mov    %esi,%ebx
  800d43:	80 fb 09             	cmp    $0x9,%bl
  800d46:	77 d5                	ja     800d1d <strtol+0x7c>
			dig = *s - '0';
  800d48:	0f be d2             	movsbl %dl,%edx
  800d4b:	83 ea 30             	sub    $0x30,%edx
  800d4e:	eb dd                	jmp    800d2d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d50:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d53:	89 f3                	mov    %esi,%ebx
  800d55:	80 fb 19             	cmp    $0x19,%bl
  800d58:	77 08                	ja     800d62 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d5a:	0f be d2             	movsbl %dl,%edx
  800d5d:	83 ea 37             	sub    $0x37,%edx
  800d60:	eb cb                	jmp    800d2d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d66:	74 05                	je     800d6d <strtol+0xcc>
		*endptr = (char *) s;
  800d68:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d6b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	f7 da                	neg    %edx
  800d71:	85 ff                	test   %edi,%edi
  800d73:	0f 45 c2             	cmovne %edx,%eax
}
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	89 c3                	mov    %eax,%ebx
  800d8e:	89 c7                	mov    %eax,%edi
  800d90:	89 c6                	mov    %eax,%esi
  800d92:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800da4:	b8 01 00 00 00       	mov    $0x1,%eax
  800da9:	89 d1                	mov    %edx,%ecx
  800dab:	89 d3                	mov    %edx,%ebx
  800dad:	89 d7                	mov    %edx,%edi
  800daf:	89 d6                	mov    %edx,%esi
  800db1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dce:	89 cb                	mov    %ecx,%ebx
  800dd0:	89 cf                	mov    %ecx,%edi
  800dd2:	89 ce                	mov    %ecx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 03                	push   $0x3
  800de8:	68 c4 30 80 00       	push   $0x8030c4
  800ded:	6a 43                	push   $0x43
  800def:	68 e1 30 80 00       	push   $0x8030e1
  800df4:	e8 f7 f3 ff ff       	call   8001f0 <_panic>

00800df9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	b8 02 00 00 00       	mov    $0x2,%eax
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 d3                	mov    %edx,%ebx
  800e0d:	89 d7                	mov    %edx,%edi
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_yield>:

void
sys_yield(void)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e28:	89 d1                	mov    %edx,%ecx
  800e2a:	89 d3                	mov    %edx,%ebx
  800e2c:	89 d7                	mov    %edx,%edi
  800e2e:	89 d6                	mov    %edx,%esi
  800e30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	be 00 00 00 00       	mov    $0x0,%esi
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e53:	89 f7                	mov    %esi,%edi
  800e55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e57:	85 c0                	test   %eax,%eax
  800e59:	7f 08                	jg     800e63 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	50                   	push   %eax
  800e67:	6a 04                	push   $0x4
  800e69:	68 c4 30 80 00       	push   $0x8030c4
  800e6e:	6a 43                	push   $0x43
  800e70:	68 e1 30 80 00       	push   $0x8030e1
  800e75:	e8 76 f3 ff ff       	call   8001f0 <_panic>

00800e7a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 05 00 00 00       	mov    $0x5,%eax
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e94:	8b 75 18             	mov    0x18(%ebp),%esi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 05                	push   $0x5
  800eab:	68 c4 30 80 00       	push   $0x8030c4
  800eb0:	6a 43                	push   $0x43
  800eb2:	68 e1 30 80 00       	push   $0x8030e1
  800eb7:	e8 34 f3 ff ff       	call   8001f0 <_panic>

00800ebc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ed5:	89 df                	mov    %ebx,%edi
  800ed7:	89 de                	mov    %ebx,%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 06                	push   $0x6
  800eed:	68 c4 30 80 00       	push   $0x8030c4
  800ef2:	6a 43                	push   $0x43
  800ef4:	68 e1 30 80 00       	push   $0x8030e1
  800ef9:	e8 f2 f2 ff ff       	call   8001f0 <_panic>

00800efe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	57                   	push   %edi
  800f02:	56                   	push   %esi
  800f03:	53                   	push   %ebx
  800f04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	b8 08 00 00 00       	mov    $0x8,%eax
  800f17:	89 df                	mov    %ebx,%edi
  800f19:	89 de                	mov    %ebx,%esi
  800f1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1d:	85 c0                	test   %eax,%eax
  800f1f:	7f 08                	jg     800f29 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f29:	83 ec 0c             	sub    $0xc,%esp
  800f2c:	50                   	push   %eax
  800f2d:	6a 08                	push   $0x8
  800f2f:	68 c4 30 80 00       	push   $0x8030c4
  800f34:	6a 43                	push   $0x43
  800f36:	68 e1 30 80 00       	push   $0x8030e1
  800f3b:	e8 b0 f2 ff ff       	call   8001f0 <_panic>

00800f40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f54:	b8 09 00 00 00       	mov    $0x9,%eax
  800f59:	89 df                	mov    %ebx,%edi
  800f5b:	89 de                	mov    %ebx,%esi
  800f5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7f 08                	jg     800f6b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	50                   	push   %eax
  800f6f:	6a 09                	push   $0x9
  800f71:	68 c4 30 80 00       	push   $0x8030c4
  800f76:	6a 43                	push   $0x43
  800f78:	68 e1 30 80 00       	push   $0x8030e1
  800f7d:	e8 6e f2 ff ff       	call   8001f0 <_panic>

00800f82 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	57                   	push   %edi
  800f86:	56                   	push   %esi
  800f87:	53                   	push   %ebx
  800f88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f96:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9b:	89 df                	mov    %ebx,%edi
  800f9d:	89 de                	mov    %ebx,%esi
  800f9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	7f 08                	jg     800fad <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	83 ec 0c             	sub    $0xc,%esp
  800fb0:	50                   	push   %eax
  800fb1:	6a 0a                	push   $0xa
  800fb3:	68 c4 30 80 00       	push   $0x8030c4
  800fb8:	6a 43                	push   $0x43
  800fba:	68 e1 30 80 00       	push   $0x8030e1
  800fbf:	e8 2c f2 ff ff       	call   8001f0 <_panic>

00800fc4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fd5:	be 00 00 00 00       	mov    $0x0,%esi
  800fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fdd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fe0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ffd:	89 cb                	mov    %ecx,%ebx
  800fff:	89 cf                	mov    %ecx,%edi
  801001:	89 ce                	mov    %ecx,%esi
  801003:	cd 30                	int    $0x30
	if(check && ret > 0)
  801005:	85 c0                	test   %eax,%eax
  801007:	7f 08                	jg     801011 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801009:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	50                   	push   %eax
  801015:	6a 0d                	push   $0xd
  801017:	68 c4 30 80 00       	push   $0x8030c4
  80101c:	6a 43                	push   $0x43
  80101e:	68 e1 30 80 00       	push   $0x8030e1
  801023:	e8 c8 f1 ff ff       	call   8001f0 <_panic>

00801028 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801039:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103e:	89 df                	mov    %ebx,%edi
  801040:	89 de                	mov    %ebx,%esi
  801042:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105c:	89 cb                	mov    %ecx,%ebx
  80105e:	89 cf                	mov    %ecx,%edi
  801060:	89 ce                	mov    %ecx,%esi
  801062:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106f:	ba 00 00 00 00       	mov    $0x0,%edx
  801074:	b8 10 00 00 00       	mov    $0x10,%eax
  801079:	89 d1                	mov    %edx,%ecx
  80107b:	89 d3                	mov    %edx,%ebx
  80107d:	89 d7                	mov    %edx,%edi
  80107f:	89 d6                	mov    %edx,%esi
  801081:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	57                   	push   %edi
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	b8 11 00 00 00       	mov    $0x11,%eax
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ba:	b8 12 00 00 00       	mov    $0x12,%eax
  8010bf:	89 df                	mov    %ebx,%edi
  8010c1:	89 de                	mov    %ebx,%esi
  8010c3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010de:	b8 13 00 00 00       	mov    $0x13,%eax
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	7f 08                	jg     8010f5 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	50                   	push   %eax
  8010f9:	6a 13                	push   $0x13
  8010fb:	68 c4 30 80 00       	push   $0x8030c4
  801100:	6a 43                	push   $0x43
  801102:	68 e1 30 80 00       	push   $0x8030e1
  801107:	e8 e4 f0 ff ff       	call   8001f0 <_panic>

0080110c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	05 00 00 00 30       	add    $0x30000000,%eax
  801117:	c1 e8 0c             	shr    $0xc,%eax
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80113b:	89 c2                	mov    %eax,%edx
  80113d:	c1 ea 16             	shr    $0x16,%edx
  801140:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801147:	f6 c2 01             	test   $0x1,%dl
  80114a:	74 2d                	je     801179 <fd_alloc+0x46>
  80114c:	89 c2                	mov    %eax,%edx
  80114e:	c1 ea 0c             	shr    $0xc,%edx
  801151:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801158:	f6 c2 01             	test   $0x1,%dl
  80115b:	74 1c                	je     801179 <fd_alloc+0x46>
  80115d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801162:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801167:	75 d2                	jne    80113b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801172:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801177:	eb 0a                	jmp    801183 <fd_alloc+0x50>
			*fd_store = fd;
  801179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80118b:	83 f8 1f             	cmp    $0x1f,%eax
  80118e:	77 30                	ja     8011c0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801190:	c1 e0 0c             	shl    $0xc,%eax
  801193:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801198:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80119e:	f6 c2 01             	test   $0x1,%dl
  8011a1:	74 24                	je     8011c7 <fd_lookup+0x42>
  8011a3:	89 c2                	mov    %eax,%edx
  8011a5:	c1 ea 0c             	shr    $0xc,%edx
  8011a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011af:	f6 c2 01             	test   $0x1,%dl
  8011b2:	74 1a                	je     8011ce <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b7:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    
		return -E_INVAL;
  8011c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c5:	eb f7                	jmp    8011be <fd_lookup+0x39>
		return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb f0                	jmp    8011be <fd_lookup+0x39>
  8011ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d3:	eb e9                	jmp    8011be <fd_lookup+0x39>

008011d5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011de:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e3:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e8:	39 08                	cmp    %ecx,(%eax)
  8011ea:	74 38                	je     801224 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ec:	83 c2 01             	add    $0x1,%edx
  8011ef:	8b 04 95 6c 31 80 00 	mov    0x80316c(,%edx,4),%eax
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	75 ee                	jne    8011e8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8011ff:	8b 40 48             	mov    0x48(%eax),%eax
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	51                   	push   %ecx
  801206:	50                   	push   %eax
  801207:	68 f0 30 80 00       	push   $0x8030f0
  80120c:	e8 d5 f0 ff ff       	call   8002e6 <cprintf>
	*dev = 0;
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    
			*dev = devtab[i];
  801224:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801227:	89 01                	mov    %eax,(%ecx)
			return 0;
  801229:	b8 00 00 00 00       	mov    $0x0,%eax
  80122e:	eb f2                	jmp    801222 <dev_lookup+0x4d>

00801230 <fd_close>:
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 24             	sub    $0x24,%esp
  801239:	8b 75 08             	mov    0x8(%ebp),%esi
  80123c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80123f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801242:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801243:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801249:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80124c:	50                   	push   %eax
  80124d:	e8 33 ff ff ff       	call   801185 <fd_lookup>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 05                	js     801260 <fd_close+0x30>
	    || fd != fd2)
  80125b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80125e:	74 16                	je     801276 <fd_close+0x46>
		return (must_exist ? r : 0);
  801260:	89 f8                	mov    %edi,%eax
  801262:	84 c0                	test   %al,%al
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	0f 44 d8             	cmove  %eax,%ebx
}
  80126c:	89 d8                	mov    %ebx,%eax
  80126e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801271:	5b                   	pop    %ebx
  801272:	5e                   	pop    %esi
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80127c:	50                   	push   %eax
  80127d:	ff 36                	pushl  (%esi)
  80127f:	e8 51 ff ff ff       	call   8011d5 <dev_lookup>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 1a                	js     8012a7 <fd_close+0x77>
		if (dev->dev_close)
  80128d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801290:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801293:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 0b                	je     8012a7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	56                   	push   %esi
  8012a0:	ff d0                	call   *%eax
  8012a2:	89 c3                	mov    %eax,%ebx
  8012a4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	56                   	push   %esi
  8012ab:	6a 00                	push   $0x0
  8012ad:	e8 0a fc ff ff       	call   800ebc <sys_page_unmap>
	return r;
  8012b2:	83 c4 10             	add    $0x10,%esp
  8012b5:	eb b5                	jmp    80126c <fd_close+0x3c>

008012b7 <close>:

int
close(int fdnum)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 08             	pushl  0x8(%ebp)
  8012c4:	e8 bc fe ff ff       	call   801185 <fd_lookup>
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	79 02                	jns    8012d2 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    
		return fd_close(fd, 1);
  8012d2:	83 ec 08             	sub    $0x8,%esp
  8012d5:	6a 01                	push   $0x1
  8012d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012da:	e8 51 ff ff ff       	call   801230 <fd_close>
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	eb ec                	jmp    8012d0 <close+0x19>

008012e4 <close_all>:

void
close_all(void)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f0:	83 ec 0c             	sub    $0xc,%esp
  8012f3:	53                   	push   %ebx
  8012f4:	e8 be ff ff ff       	call   8012b7 <close>
	for (i = 0; i < MAXFD; i++)
  8012f9:	83 c3 01             	add    $0x1,%ebx
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	83 fb 20             	cmp    $0x20,%ebx
  801302:	75 ec                	jne    8012f0 <close_all+0xc>
}
  801304:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	57                   	push   %edi
  80130d:	56                   	push   %esi
  80130e:	53                   	push   %ebx
  80130f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801312:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801315:	50                   	push   %eax
  801316:	ff 75 08             	pushl  0x8(%ebp)
  801319:	e8 67 fe ff ff       	call   801185 <fd_lookup>
  80131e:	89 c3                	mov    %eax,%ebx
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	85 c0                	test   %eax,%eax
  801325:	0f 88 81 00 00 00    	js     8013ac <dup+0xa3>
		return r;
	close(newfdnum);
  80132b:	83 ec 0c             	sub    $0xc,%esp
  80132e:	ff 75 0c             	pushl  0xc(%ebp)
  801331:	e8 81 ff ff ff       	call   8012b7 <close>

	newfd = INDEX2FD(newfdnum);
  801336:	8b 75 0c             	mov    0xc(%ebp),%esi
  801339:	c1 e6 0c             	shl    $0xc,%esi
  80133c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801342:	83 c4 04             	add    $0x4,%esp
  801345:	ff 75 e4             	pushl  -0x1c(%ebp)
  801348:	e8 cf fd ff ff       	call   80111c <fd2data>
  80134d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80134f:	89 34 24             	mov    %esi,(%esp)
  801352:	e8 c5 fd ff ff       	call   80111c <fd2data>
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135c:	89 d8                	mov    %ebx,%eax
  80135e:	c1 e8 16             	shr    $0x16,%eax
  801361:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801368:	a8 01                	test   $0x1,%al
  80136a:	74 11                	je     80137d <dup+0x74>
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	c1 e8 0c             	shr    $0xc,%eax
  801371:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801378:	f6 c2 01             	test   $0x1,%dl
  80137b:	75 39                	jne    8013b6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80137d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801380:	89 d0                	mov    %edx,%eax
  801382:	c1 e8 0c             	shr    $0xc,%eax
  801385:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	25 07 0e 00 00       	and    $0xe07,%eax
  801394:	50                   	push   %eax
  801395:	56                   	push   %esi
  801396:	6a 00                	push   $0x0
  801398:	52                   	push   %edx
  801399:	6a 00                	push   $0x0
  80139b:	e8 da fa ff ff       	call   800e7a <sys_page_map>
  8013a0:	89 c3                	mov    %eax,%ebx
  8013a2:	83 c4 20             	add    $0x20,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 31                	js     8013da <dup+0xd1>
		goto err;

	return newfdnum;
  8013a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013ac:	89 d8                	mov    %ebx,%eax
  8013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c5:	50                   	push   %eax
  8013c6:	57                   	push   %edi
  8013c7:	6a 00                	push   $0x0
  8013c9:	53                   	push   %ebx
  8013ca:	6a 00                	push   $0x0
  8013cc:	e8 a9 fa ff ff       	call   800e7a <sys_page_map>
  8013d1:	89 c3                	mov    %eax,%ebx
  8013d3:	83 c4 20             	add    $0x20,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	79 a3                	jns    80137d <dup+0x74>
	sys_page_unmap(0, newfd);
  8013da:	83 ec 08             	sub    $0x8,%esp
  8013dd:	56                   	push   %esi
  8013de:	6a 00                	push   $0x0
  8013e0:	e8 d7 fa ff ff       	call   800ebc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013e5:	83 c4 08             	add    $0x8,%esp
  8013e8:	57                   	push   %edi
  8013e9:	6a 00                	push   $0x0
  8013eb:	e8 cc fa ff ff       	call   800ebc <sys_page_unmap>
	return r;
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	eb b7                	jmp    8013ac <dup+0xa3>

008013f5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	53                   	push   %ebx
  8013f9:	83 ec 1c             	sub    $0x1c,%esp
  8013fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801402:	50                   	push   %eax
  801403:	53                   	push   %ebx
  801404:	e8 7c fd ff ff       	call   801185 <fd_lookup>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 3f                	js     80144f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801410:	83 ec 08             	sub    $0x8,%esp
  801413:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801416:	50                   	push   %eax
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	ff 30                	pushl  (%eax)
  80141c:	e8 b4 fd ff ff       	call   8011d5 <dev_lookup>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 27                	js     80144f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801428:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80142b:	8b 42 08             	mov    0x8(%edx),%eax
  80142e:	83 e0 03             	and    $0x3,%eax
  801431:	83 f8 01             	cmp    $0x1,%eax
  801434:	74 1e                	je     801454 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801439:	8b 40 08             	mov    0x8(%eax),%eax
  80143c:	85 c0                	test   %eax,%eax
  80143e:	74 35                	je     801475 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	ff 75 10             	pushl  0x10(%ebp)
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	52                   	push   %edx
  80144a:	ff d0                	call   *%eax
  80144c:	83 c4 10             	add    $0x10,%esp
}
  80144f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801452:	c9                   	leave  
  801453:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801454:	a1 08 50 80 00       	mov    0x805008,%eax
  801459:	8b 40 48             	mov    0x48(%eax),%eax
  80145c:	83 ec 04             	sub    $0x4,%esp
  80145f:	53                   	push   %ebx
  801460:	50                   	push   %eax
  801461:	68 31 31 80 00       	push   $0x803131
  801466:	e8 7b ee ff ff       	call   8002e6 <cprintf>
		return -E_INVAL;
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801473:	eb da                	jmp    80144f <read+0x5a>
		return -E_NOT_SUPP;
  801475:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80147a:	eb d3                	jmp    80144f <read+0x5a>

0080147c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	8b 7d 08             	mov    0x8(%ebp),%edi
  801488:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80148b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801490:	39 f3                	cmp    %esi,%ebx
  801492:	73 23                	jae    8014b7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801494:	83 ec 04             	sub    $0x4,%esp
  801497:	89 f0                	mov    %esi,%eax
  801499:	29 d8                	sub    %ebx,%eax
  80149b:	50                   	push   %eax
  80149c:	89 d8                	mov    %ebx,%eax
  80149e:	03 45 0c             	add    0xc(%ebp),%eax
  8014a1:	50                   	push   %eax
  8014a2:	57                   	push   %edi
  8014a3:	e8 4d ff ff ff       	call   8013f5 <read>
		if (m < 0)
  8014a8:	83 c4 10             	add    $0x10,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 06                	js     8014b5 <readn+0x39>
			return m;
		if (m == 0)
  8014af:	74 06                	je     8014b7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014b1:	01 c3                	add    %eax,%ebx
  8014b3:	eb db                	jmp    801490 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014b5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014b7:	89 d8                	mov    %ebx,%eax
  8014b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bc:	5b                   	pop    %ebx
  8014bd:	5e                   	pop    %esi
  8014be:	5f                   	pop    %edi
  8014bf:	5d                   	pop    %ebp
  8014c0:	c3                   	ret    

008014c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	53                   	push   %ebx
  8014c5:	83 ec 1c             	sub    $0x1c,%esp
  8014c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ce:	50                   	push   %eax
  8014cf:	53                   	push   %ebx
  8014d0:	e8 b0 fc ff ff       	call   801185 <fd_lookup>
  8014d5:	83 c4 10             	add    $0x10,%esp
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	78 3a                	js     801516 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e6:	ff 30                	pushl  (%eax)
  8014e8:	e8 e8 fc ff ff       	call   8011d5 <dev_lookup>
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 22                	js     801516 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fb:	74 1e                	je     80151b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801500:	8b 52 0c             	mov    0xc(%edx),%edx
  801503:	85 d2                	test   %edx,%edx
  801505:	74 35                	je     80153c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	ff 75 10             	pushl  0x10(%ebp)
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	50                   	push   %eax
  801511:	ff d2                	call   *%edx
  801513:	83 c4 10             	add    $0x10,%esp
}
  801516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801519:	c9                   	leave  
  80151a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80151b:	a1 08 50 80 00       	mov    0x805008,%eax
  801520:	8b 40 48             	mov    0x48(%eax),%eax
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	53                   	push   %ebx
  801527:	50                   	push   %eax
  801528:	68 4d 31 80 00       	push   $0x80314d
  80152d:	e8 b4 ed ff ff       	call   8002e6 <cprintf>
		return -E_INVAL;
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80153a:	eb da                	jmp    801516 <write+0x55>
		return -E_NOT_SUPP;
  80153c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801541:	eb d3                	jmp    801516 <write+0x55>

00801543 <seek>:

int
seek(int fdnum, off_t offset)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801549:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154c:	50                   	push   %eax
  80154d:	ff 75 08             	pushl  0x8(%ebp)
  801550:	e8 30 fc ff ff       	call   801185 <fd_lookup>
  801555:	83 c4 10             	add    $0x10,%esp
  801558:	85 c0                	test   %eax,%eax
  80155a:	78 0e                	js     80156a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	53                   	push   %ebx
  801570:	83 ec 1c             	sub    $0x1c,%esp
  801573:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801576:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801579:	50                   	push   %eax
  80157a:	53                   	push   %ebx
  80157b:	e8 05 fc ff ff       	call   801185 <fd_lookup>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 37                	js     8015be <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158d:	50                   	push   %eax
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	ff 30                	pushl  (%eax)
  801593:	e8 3d fc ff ff       	call   8011d5 <dev_lookup>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 1f                	js     8015be <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a6:	74 1b                	je     8015c3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 52 18             	mov    0x18(%edx),%edx
  8015ae:	85 d2                	test   %edx,%edx
  8015b0:	74 32                	je     8015e4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	ff 75 0c             	pushl  0xc(%ebp)
  8015b8:	50                   	push   %eax
  8015b9:	ff d2                	call   *%edx
  8015bb:	83 c4 10             	add    $0x10,%esp
}
  8015be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015c3:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c8:	8b 40 48             	mov    0x48(%eax),%eax
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	53                   	push   %ebx
  8015cf:	50                   	push   %eax
  8015d0:	68 10 31 80 00       	push   $0x803110
  8015d5:	e8 0c ed ff ff       	call   8002e6 <cprintf>
		return -E_INVAL;
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e2:	eb da                	jmp    8015be <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e9:	eb d3                	jmp    8015be <ftruncate+0x52>

008015eb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 1c             	sub    $0x1c,%esp
  8015f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f8:	50                   	push   %eax
  8015f9:	ff 75 08             	pushl  0x8(%ebp)
  8015fc:	e8 84 fb ff ff       	call   801185 <fd_lookup>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	78 4b                	js     801653 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	ff 30                	pushl  (%eax)
  801614:	e8 bc fb ff ff       	call   8011d5 <dev_lookup>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 33                	js     801653 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801627:	74 2f                	je     801658 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801629:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80162c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801633:	00 00 00 
	stat->st_isdir = 0;
  801636:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80163d:	00 00 00 
	stat->st_dev = dev;
  801640:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	53                   	push   %ebx
  80164a:	ff 75 f0             	pushl  -0x10(%ebp)
  80164d:	ff 50 14             	call   *0x14(%eax)
  801650:	83 c4 10             	add    $0x10,%esp
}
  801653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801656:	c9                   	leave  
  801657:	c3                   	ret    
		return -E_NOT_SUPP;
  801658:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165d:	eb f4                	jmp    801653 <fstat+0x68>

0080165f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	6a 00                	push   $0x0
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	e8 22 02 00 00       	call   801893 <open>
  801671:	89 c3                	mov    %eax,%ebx
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	78 1b                	js     801695 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	50                   	push   %eax
  801681:	e8 65 ff ff ff       	call   8015eb <fstat>
  801686:	89 c6                	mov    %eax,%esi
	close(fd);
  801688:	89 1c 24             	mov    %ebx,(%esp)
  80168b:	e8 27 fc ff ff       	call   8012b7 <close>
	return r;
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 f3                	mov    %esi,%ebx
}
  801695:	89 d8                	mov    %ebx,%eax
  801697:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5d                   	pop    %ebp
  80169d:	c3                   	ret    

0080169e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	89 c6                	mov    %eax,%esi
  8016a5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016a7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8016ae:	74 27                	je     8016d7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b0:	6a 07                	push   $0x7
  8016b2:	68 00 60 80 00       	push   $0x806000
  8016b7:	56                   	push   %esi
  8016b8:	ff 35 00 50 80 00    	pushl  0x805000
  8016be:	e8 24 12 00 00       	call   8028e7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016c3:	83 c4 0c             	add    $0xc,%esp
  8016c6:	6a 00                	push   $0x0
  8016c8:	53                   	push   %ebx
  8016c9:	6a 00                	push   $0x0
  8016cb:	e8 ae 11 00 00       	call   80287e <ipc_recv>
}
  8016d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d3:	5b                   	pop    %ebx
  8016d4:	5e                   	pop    %esi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d7:	83 ec 0c             	sub    $0xc,%esp
  8016da:	6a 01                	push   $0x1
  8016dc:	e8 5e 12 00 00       	call   80293f <ipc_find_env>
  8016e1:	a3 00 50 80 00       	mov    %eax,0x805000
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	eb c5                	jmp    8016b0 <fsipc+0x12>

008016eb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ff:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	b8 02 00 00 00       	mov    $0x2,%eax
  80170e:	e8 8b ff ff ff       	call   80169e <fsipc>
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <devfile_flush>:
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 40 0c             	mov    0xc(%eax),%eax
  801721:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	b8 06 00 00 00       	mov    $0x6,%eax
  801730:	e8 69 ff ff ff       	call   80169e <fsipc>
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <devfile_stat>:
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8b 40 0c             	mov    0xc(%eax),%eax
  801747:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80174c:	ba 00 00 00 00       	mov    $0x0,%edx
  801751:	b8 05 00 00 00       	mov    $0x5,%eax
  801756:	e8 43 ff ff ff       	call   80169e <fsipc>
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 2c                	js     80178b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175f:	83 ec 08             	sub    $0x8,%esp
  801762:	68 00 60 80 00       	push   $0x806000
  801767:	53                   	push   %ebx
  801768:	e8 d8 f2 ff ff       	call   800a45 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80176d:	a1 80 60 80 00       	mov    0x806080,%eax
  801772:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801778:	a1 84 60 80 00       	mov    0x806084,%eax
  80177d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <devfile_write>:
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 08             	sub    $0x8,%esp
  801797:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8017a5:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017ab:	53                   	push   %ebx
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	68 08 60 80 00       	push   $0x806008
  8017b4:	e8 7c f4 ff ff       	call   800c35 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	b8 04 00 00 00       	mov    $0x4,%eax
  8017c3:	e8 d6 fe ff ff       	call   80169e <fsipc>
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 0b                	js     8017da <devfile_write+0x4a>
	assert(r <= n);
  8017cf:	39 d8                	cmp    %ebx,%eax
  8017d1:	77 0c                	ja     8017df <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017d3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d8:	7f 1e                	jg     8017f8 <devfile_write+0x68>
}
  8017da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    
	assert(r <= n);
  8017df:	68 80 31 80 00       	push   $0x803180
  8017e4:	68 87 31 80 00       	push   $0x803187
  8017e9:	68 98 00 00 00       	push   $0x98
  8017ee:	68 9c 31 80 00       	push   $0x80319c
  8017f3:	e8 f8 e9 ff ff       	call   8001f0 <_panic>
	assert(r <= PGSIZE);
  8017f8:	68 a7 31 80 00       	push   $0x8031a7
  8017fd:	68 87 31 80 00       	push   $0x803187
  801802:	68 99 00 00 00       	push   $0x99
  801807:	68 9c 31 80 00       	push   $0x80319c
  80180c:	e8 df e9 ff ff       	call   8001f0 <_panic>

00801811 <devfile_read>:
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	56                   	push   %esi
  801815:	53                   	push   %ebx
  801816:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8b 40 0c             	mov    0xc(%eax),%eax
  80181f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801824:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80182a:	ba 00 00 00 00       	mov    $0x0,%edx
  80182f:	b8 03 00 00 00       	mov    $0x3,%eax
  801834:	e8 65 fe ff ff       	call   80169e <fsipc>
  801839:	89 c3                	mov    %eax,%ebx
  80183b:	85 c0                	test   %eax,%eax
  80183d:	78 1f                	js     80185e <devfile_read+0x4d>
	assert(r <= n);
  80183f:	39 f0                	cmp    %esi,%eax
  801841:	77 24                	ja     801867 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801843:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801848:	7f 33                	jg     80187d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	50                   	push   %eax
  80184e:	68 00 60 80 00       	push   $0x806000
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	e8 78 f3 ff ff       	call   800bd3 <memmove>
	return r;
  80185b:	83 c4 10             	add    $0x10,%esp
}
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    
	assert(r <= n);
  801867:	68 80 31 80 00       	push   $0x803180
  80186c:	68 87 31 80 00       	push   $0x803187
  801871:	6a 7c                	push   $0x7c
  801873:	68 9c 31 80 00       	push   $0x80319c
  801878:	e8 73 e9 ff ff       	call   8001f0 <_panic>
	assert(r <= PGSIZE);
  80187d:	68 a7 31 80 00       	push   $0x8031a7
  801882:	68 87 31 80 00       	push   $0x803187
  801887:	6a 7d                	push   $0x7d
  801889:	68 9c 31 80 00       	push   $0x80319c
  80188e:	e8 5d e9 ff ff       	call   8001f0 <_panic>

00801893 <open>:
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
  801898:	83 ec 1c             	sub    $0x1c,%esp
  80189b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80189e:	56                   	push   %esi
  80189f:	e8 68 f1 ff ff       	call   800a0c <strlen>
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018ac:	7f 6c                	jg     80191a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b4:	50                   	push   %eax
  8018b5:	e8 79 f8 ff ff       	call   801133 <fd_alloc>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 3c                	js     8018ff <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	56                   	push   %esi
  8018c7:	68 00 60 80 00       	push   $0x806000
  8018cc:	e8 74 f1 ff ff       	call   800a45 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e1:	e8 b8 fd ff ff       	call   80169e <fsipc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 19                	js     801908 <open+0x75>
	return fd2num(fd);
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f5:	e8 12 f8 ff ff       	call   80110c <fd2num>
  8018fa:	89 c3                	mov    %eax,%ebx
  8018fc:	83 c4 10             	add    $0x10,%esp
}
  8018ff:	89 d8                	mov    %ebx,%eax
  801901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801904:	5b                   	pop    %ebx
  801905:	5e                   	pop    %esi
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    
		fd_close(fd, 0);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 f4             	pushl  -0xc(%ebp)
  801910:	e8 1b f9 ff ff       	call   801230 <fd_close>
		return r;
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	eb e5                	jmp    8018ff <open+0x6c>
		return -E_BAD_PATH;
  80191a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80191f:	eb de                	jmp    8018ff <open+0x6c>

00801921 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801927:	ba 00 00 00 00       	mov    $0x0,%edx
  80192c:	b8 08 00 00 00       	mov    $0x8,%eax
  801931:	e8 68 fd ff ff       	call   80169e <fsipc>
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	57                   	push   %edi
  80193c:	56                   	push   %esi
  80193d:	53                   	push   %ebx
  80193e:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801944:	68 8c 32 80 00       	push   $0x80328c
  801949:	68 13 2d 80 00       	push   $0x802d13
  80194e:	e8 93 e9 ff ff       	call   8002e6 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801953:	83 c4 08             	add    $0x8,%esp
  801956:	6a 00                	push   $0x0
  801958:	ff 75 08             	pushl  0x8(%ebp)
  80195b:	e8 33 ff ff ff       	call   801893 <open>
  801960:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 c0                	test   %eax,%eax
  80196b:	0f 88 0a 05 00 00    	js     801e7b <spawn+0x543>
  801971:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	68 00 02 00 00       	push   $0x200
  80197b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801981:	50                   	push   %eax
  801982:	51                   	push   %ecx
  801983:	e8 f4 fa ff ff       	call   80147c <readn>
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	3d 00 02 00 00       	cmp    $0x200,%eax
  801990:	75 74                	jne    801a06 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801992:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801999:	45 4c 46 
  80199c:	75 68                	jne    801a06 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80199e:	b8 07 00 00 00       	mov    $0x7,%eax
  8019a3:	cd 30                	int    $0x30
  8019a5:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8019ab:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	0f 88 b6 04 00 00    	js     801e6f <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019be:	89 c6                	mov    %eax,%esi
  8019c0:	c1 e6 07             	shl    $0x7,%esi
  8019c3:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8019c9:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019cf:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019d4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019d6:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019dc:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  8019e2:	83 ec 08             	sub    $0x8,%esp
  8019e5:	68 80 32 80 00       	push   $0x803280
  8019ea:	68 13 2d 80 00       	push   $0x802d13
  8019ef:	e8 f2 e8 ff ff       	call   8002e6 <cprintf>
  8019f4:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019f7:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019fc:	be 00 00 00 00       	mov    $0x0,%esi
  801a01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a04:	eb 4b                	jmp    801a51 <spawn+0x119>
		close(fd);
  801a06:	83 ec 0c             	sub    $0xc,%esp
  801a09:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a0f:	e8 a3 f8 ff ff       	call   8012b7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a14:	83 c4 0c             	add    $0xc,%esp
  801a17:	68 7f 45 4c 46       	push   $0x464c457f
  801a1c:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a22:	68 b3 31 80 00       	push   $0x8031b3
  801a27:	e8 ba e8 ff ff       	call   8002e6 <cprintf>
		return -E_NOT_EXEC;
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801a36:	ff ff ff 
  801a39:	e9 3d 04 00 00       	jmp    801e7b <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801a3e:	83 ec 0c             	sub    $0xc,%esp
  801a41:	50                   	push   %eax
  801a42:	e8 c5 ef ff ff       	call   800a0c <strlen>
  801a47:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a4b:	83 c3 01             	add    $0x1,%ebx
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a58:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 df                	jne    801a3e <spawn+0x106>
  801a5f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a65:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a6b:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a70:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a72:	89 fa                	mov    %edi,%edx
  801a74:	83 e2 fc             	and    $0xfffffffc,%edx
  801a77:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a7e:	29 c2                	sub    %eax,%edx
  801a80:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a86:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a89:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a8e:	0f 86 0a 04 00 00    	jbe    801e9e <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	6a 07                	push   $0x7
  801a99:	68 00 00 40 00       	push   $0x400000
  801a9e:	6a 00                	push   $0x0
  801aa0:	e8 92 f3 ff ff       	call   800e37 <sys_page_alloc>
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	0f 88 f3 03 00 00    	js     801ea3 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ab0:	be 00 00 00 00       	mov    $0x0,%esi
  801ab5:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801abb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801abe:	eb 30                	jmp    801af0 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801ac0:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ac6:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801acc:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801acf:	83 ec 08             	sub    $0x8,%esp
  801ad2:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ad5:	57                   	push   %edi
  801ad6:	e8 6a ef ff ff       	call   800a45 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801adb:	83 c4 04             	add    $0x4,%esp
  801ade:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ae1:	e8 26 ef ff ff       	call   800a0c <strlen>
  801ae6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801aea:	83 c6 01             	add    $0x1,%esi
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801af6:	7f c8                	jg     801ac0 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801af8:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801afe:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b04:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b0b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b11:	0f 85 86 00 00 00    	jne    801b9d <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b17:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801b1d:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801b23:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b26:	89 d0                	mov    %edx,%eax
  801b28:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801b2e:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b31:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b36:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b3c:	83 ec 0c             	sub    $0xc,%esp
  801b3f:	6a 07                	push   $0x7
  801b41:	68 00 d0 bf ee       	push   $0xeebfd000
  801b46:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b4c:	68 00 00 40 00       	push   $0x400000
  801b51:	6a 00                	push   $0x0
  801b53:	e8 22 f3 ff ff       	call   800e7a <sys_page_map>
  801b58:	89 c3                	mov    %eax,%ebx
  801b5a:	83 c4 20             	add    $0x20,%esp
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	0f 88 46 03 00 00    	js     801eab <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	68 00 00 40 00       	push   $0x400000
  801b6d:	6a 00                	push   $0x0
  801b6f:	e8 48 f3 ff ff       	call   800ebc <sys_page_unmap>
  801b74:	89 c3                	mov    %eax,%ebx
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	0f 88 2a 03 00 00    	js     801eab <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b81:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b87:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b8e:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b95:	00 00 00 
  801b98:	e9 4f 01 00 00       	jmp    801cec <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b9d:	68 3c 32 80 00       	push   $0x80323c
  801ba2:	68 87 31 80 00       	push   $0x803187
  801ba7:	68 f8 00 00 00       	push   $0xf8
  801bac:	68 cd 31 80 00       	push   $0x8031cd
  801bb1:	e8 3a e6 ff ff       	call   8001f0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	6a 07                	push   $0x7
  801bbb:	68 00 00 40 00       	push   $0x400000
  801bc0:	6a 00                	push   $0x0
  801bc2:	e8 70 f2 ff ff       	call   800e37 <sys_page_alloc>
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	0f 88 b7 02 00 00    	js     801e89 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801bdb:	01 f0                	add    %esi,%eax
  801bdd:	50                   	push   %eax
  801bde:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801be4:	e8 5a f9 ff ff       	call   801543 <seek>
  801be9:	83 c4 10             	add    $0x10,%esp
  801bec:	85 c0                	test   %eax,%eax
  801bee:	0f 88 9c 02 00 00    	js     801e90 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801bf4:	83 ec 04             	sub    $0x4,%esp
  801bf7:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bfd:	29 f0                	sub    %esi,%eax
  801bff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c04:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c09:	0f 47 c1             	cmova  %ecx,%eax
  801c0c:	50                   	push   %eax
  801c0d:	68 00 00 40 00       	push   $0x400000
  801c12:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c18:	e8 5f f8 ff ff       	call   80147c <readn>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	85 c0                	test   %eax,%eax
  801c22:	0f 88 6f 02 00 00    	js     801e97 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c28:	83 ec 0c             	sub    $0xc,%esp
  801c2b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c31:	53                   	push   %ebx
  801c32:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c38:	68 00 00 40 00       	push   $0x400000
  801c3d:	6a 00                	push   $0x0
  801c3f:	e8 36 f2 ff ff       	call   800e7a <sys_page_map>
  801c44:	83 c4 20             	add    $0x20,%esp
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 7c                	js     801cc7 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	68 00 00 40 00       	push   $0x400000
  801c53:	6a 00                	push   $0x0
  801c55:	e8 62 f2 ff ff       	call   800ebc <sys_page_unmap>
  801c5a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c5d:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c69:	89 fe                	mov    %edi,%esi
  801c6b:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c71:	76 69                	jbe    801cdc <spawn+0x3a4>
		if (i >= filesz) {
  801c73:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c79:	0f 87 37 ff ff ff    	ja     801bb6 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c7f:	83 ec 04             	sub    $0x4,%esp
  801c82:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c88:	53                   	push   %ebx
  801c89:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c8f:	e8 a3 f1 ff ff       	call   800e37 <sys_page_alloc>
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	79 c2                	jns    801c5d <spawn+0x325>
  801c9b:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ca6:	e8 0d f1 ff ff       	call   800db8 <sys_env_destroy>
	close(fd);
  801cab:	83 c4 04             	add    $0x4,%esp
  801cae:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cb4:	e8 fe f5 ff ff       	call   8012b7 <close>
	return r;
  801cb9:	83 c4 10             	add    $0x10,%esp
  801cbc:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801cc2:	e9 b4 01 00 00       	jmp    801e7b <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801cc7:	50                   	push   %eax
  801cc8:	68 d9 31 80 00       	push   $0x8031d9
  801ccd:	68 2b 01 00 00       	push   $0x12b
  801cd2:	68 cd 31 80 00       	push   $0x8031cd
  801cd7:	e8 14 e5 ff ff       	call   8001f0 <_panic>
  801cdc:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ce2:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ce9:	83 c6 20             	add    $0x20,%esi
  801cec:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cf3:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801cf9:	7e 6d                	jle    801d68 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801cfb:	83 3e 01             	cmpl   $0x1,(%esi)
  801cfe:	75 e2                	jne    801ce2 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d00:	8b 46 18             	mov    0x18(%esi),%eax
  801d03:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d06:	83 f8 01             	cmp    $0x1,%eax
  801d09:	19 c0                	sbb    %eax,%eax
  801d0b:	83 e0 fe             	and    $0xfffffffe,%eax
  801d0e:	83 c0 07             	add    $0x7,%eax
  801d11:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d17:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d1a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d20:	8b 56 10             	mov    0x10(%esi),%edx
  801d23:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d29:	8b 7e 14             	mov    0x14(%esi),%edi
  801d2c:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801d32:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801d35:	89 d8                	mov    %ebx,%eax
  801d37:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d3c:	74 1a                	je     801d58 <spawn+0x420>
		va -= i;
  801d3e:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d40:	01 c7                	add    %eax,%edi
  801d42:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d48:	01 c2                	add    %eax,%edx
  801d4a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801d50:	29 c1                	sub    %eax,%ecx
  801d52:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d58:	bf 00 00 00 00       	mov    $0x0,%edi
  801d5d:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801d63:	e9 01 ff ff ff       	jmp    801c69 <spawn+0x331>
	close(fd);
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d71:	e8 41 f5 ff ff       	call   8012b7 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801d76:	83 c4 08             	add    $0x8,%esp
  801d79:	68 6c 32 80 00       	push   $0x80326c
  801d7e:	68 13 2d 80 00       	push   $0x802d13
  801d83:	e8 5e e5 ff ff       	call   8002e6 <cprintf>
  801d88:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801d8b:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801d90:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d96:	eb 0e                	jmp    801da6 <spawn+0x46e>
  801d98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d9e:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801da4:	74 5e                	je     801e04 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801da6:	89 d8                	mov    %ebx,%eax
  801da8:	c1 e8 16             	shr    $0x16,%eax
  801dab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801db2:	a8 01                	test   $0x1,%al
  801db4:	74 e2                	je     801d98 <spawn+0x460>
  801db6:	89 da                	mov    %ebx,%edx
  801db8:	c1 ea 0c             	shr    $0xc,%edx
  801dbb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801dc2:	25 05 04 00 00       	and    $0x405,%eax
  801dc7:	3d 05 04 00 00       	cmp    $0x405,%eax
  801dcc:	75 ca                	jne    801d98 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801dce:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	25 07 0e 00 00       	and    $0xe07,%eax
  801ddd:	50                   	push   %eax
  801dde:	53                   	push   %ebx
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	6a 00                	push   $0x0
  801de3:	e8 92 f0 ff ff       	call   800e7a <sys_page_map>
  801de8:	83 c4 20             	add    $0x20,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	79 a9                	jns    801d98 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801def:	50                   	push   %eax
  801df0:	68 f6 31 80 00       	push   $0x8031f6
  801df5:	68 3b 01 00 00       	push   $0x13b
  801dfa:	68 cd 31 80 00       	push   $0x8031cd
  801dff:	e8 ec e3 ff ff       	call   8001f0 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e0d:	50                   	push   %eax
  801e0e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e14:	e8 27 f1 ff ff       	call   800f40 <sys_env_set_trapframe>
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	78 25                	js     801e45 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e20:	83 ec 08             	sub    $0x8,%esp
  801e23:	6a 02                	push   $0x2
  801e25:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e2b:	e8 ce f0 ff ff       	call   800efe <sys_env_set_status>
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 23                	js     801e5a <spawn+0x522>
	return child;
  801e37:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e3d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e43:	eb 36                	jmp    801e7b <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801e45:	50                   	push   %eax
  801e46:	68 08 32 80 00       	push   $0x803208
  801e4b:	68 8a 00 00 00       	push   $0x8a
  801e50:	68 cd 31 80 00       	push   $0x8031cd
  801e55:	e8 96 e3 ff ff       	call   8001f0 <_panic>
		panic("sys_env_set_status: %e", r);
  801e5a:	50                   	push   %eax
  801e5b:	68 22 32 80 00       	push   $0x803222
  801e60:	68 8d 00 00 00       	push   $0x8d
  801e65:	68 cd 31 80 00       	push   $0x8031cd
  801e6a:	e8 81 e3 ff ff       	call   8001f0 <_panic>
		return r;
  801e6f:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e75:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e7b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    
  801e89:	89 c7                	mov    %eax,%edi
  801e8b:	e9 0d fe ff ff       	jmp    801c9d <spawn+0x365>
  801e90:	89 c7                	mov    %eax,%edi
  801e92:	e9 06 fe ff ff       	jmp    801c9d <spawn+0x365>
  801e97:	89 c7                	mov    %eax,%edi
  801e99:	e9 ff fd ff ff       	jmp    801c9d <spawn+0x365>
		return -E_NO_MEM;
  801e9e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801ea3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ea9:	eb d0                	jmp    801e7b <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801eab:	83 ec 08             	sub    $0x8,%esp
  801eae:	68 00 00 40 00       	push   $0x400000
  801eb3:	6a 00                	push   $0x0
  801eb5:	e8 02 f0 ff ff       	call   800ebc <sys_page_unmap>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801ec3:	eb b6                	jmp    801e7b <spawn+0x543>

00801ec5 <spawnl>:
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	57                   	push   %edi
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801ece:	68 64 32 80 00       	push   $0x803264
  801ed3:	68 13 2d 80 00       	push   $0x802d13
  801ed8:	e8 09 e4 ff ff       	call   8002e6 <cprintf>
	va_start(vl, arg0);
  801edd:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801ee0:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ee8:	8d 4a 04             	lea    0x4(%edx),%ecx
  801eeb:	83 3a 00             	cmpl   $0x0,(%edx)
  801eee:	74 07                	je     801ef7 <spawnl+0x32>
		argc++;
  801ef0:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801ef3:	89 ca                	mov    %ecx,%edx
  801ef5:	eb f1                	jmp    801ee8 <spawnl+0x23>
	const char *argv[argc+2];
  801ef7:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801efe:	83 e2 f0             	and    $0xfffffff0,%edx
  801f01:	29 d4                	sub    %edx,%esp
  801f03:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f07:	c1 ea 02             	shr    $0x2,%edx
  801f0a:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f11:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f16:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f1d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f24:	00 
	va_start(vl, arg0);
  801f25:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f28:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2f:	eb 0b                	jmp    801f3c <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801f31:	83 c0 01             	add    $0x1,%eax
  801f34:	8b 39                	mov    (%ecx),%edi
  801f36:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f39:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f3c:	39 d0                	cmp    %edx,%eax
  801f3e:	75 f1                	jne    801f31 <spawnl+0x6c>
	return spawn(prog, argv);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	56                   	push   %esi
  801f44:	ff 75 08             	pushl  0x8(%ebp)
  801f47:	e8 ec f9 ff ff       	call   801938 <spawn>
}
  801f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f5a:	68 92 32 80 00       	push   $0x803292
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	e8 de ea ff ff       	call   800a45 <strcpy>
	return 0;
}
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <devsock_close>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	53                   	push   %ebx
  801f72:	83 ec 10             	sub    $0x10,%esp
  801f75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f78:	53                   	push   %ebx
  801f79:	e8 fc 09 00 00       	call   80297a <pageref>
  801f7e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f81:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f86:	83 f8 01             	cmp    $0x1,%eax
  801f89:	74 07                	je     801f92 <devsock_close+0x24>
}
  801f8b:	89 d0                	mov    %edx,%eax
  801f8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	ff 73 0c             	pushl  0xc(%ebx)
  801f98:	e8 b9 02 00 00       	call   802256 <nsipc_close>
  801f9d:	89 c2                	mov    %eax,%edx
  801f9f:	83 c4 10             	add    $0x10,%esp
  801fa2:	eb e7                	jmp    801f8b <devsock_close+0x1d>

00801fa4 <devsock_write>:
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	ff 75 10             	pushl  0x10(%ebp)
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	ff 70 0c             	pushl  0xc(%eax)
  801fb8:	e8 76 03 00 00       	call   802333 <nsipc_send>
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <devsock_read>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fc5:	6a 00                	push   $0x0
  801fc7:	ff 75 10             	pushl  0x10(%ebp)
  801fca:	ff 75 0c             	pushl  0xc(%ebp)
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	ff 70 0c             	pushl  0xc(%eax)
  801fd3:	e8 ef 02 00 00       	call   8022c7 <nsipc_recv>
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <fd2sockid>:
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fe0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fe3:	52                   	push   %edx
  801fe4:	50                   	push   %eax
  801fe5:	e8 9b f1 ff ff       	call   801185 <fd_lookup>
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	85 c0                	test   %eax,%eax
  801fef:	78 10                	js     802001 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ffa:	39 08                	cmp    %ecx,(%eax)
  801ffc:	75 05                	jne    802003 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    
		return -E_NOT_SUPP;
  802003:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802008:	eb f7                	jmp    802001 <fd2sockid+0x27>

0080200a <alloc_sockfd>:
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	56                   	push   %esi
  80200e:	53                   	push   %ebx
  80200f:	83 ec 1c             	sub    $0x1c,%esp
  802012:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 16 f1 ff ff       	call   801133 <fd_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	78 43                	js     802069 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 07 04 00 00       	push   $0x407
  80202e:	ff 75 f4             	pushl  -0xc(%ebp)
  802031:	6a 00                	push   $0x0
  802033:	e8 ff ed ff ff       	call   800e37 <sys_page_alloc>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 28                	js     802069 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80204a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802056:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802059:	83 ec 0c             	sub    $0xc,%esp
  80205c:	50                   	push   %eax
  80205d:	e8 aa f0 ff ff       	call   80110c <fd2num>
  802062:	89 c3                	mov    %eax,%ebx
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	eb 0c                	jmp    802075 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	56                   	push   %esi
  80206d:	e8 e4 01 00 00       	call   802256 <nsipc_close>
		return r;
  802072:	83 c4 10             	add    $0x10,%esp
}
  802075:	89 d8                	mov    %ebx,%eax
  802077:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207a:	5b                   	pop    %ebx
  80207b:	5e                   	pop    %esi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <accept>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	e8 4e ff ff ff       	call   801fda <fd2sockid>
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 1b                	js     8020ab <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	ff 75 10             	pushl  0x10(%ebp)
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	50                   	push   %eax
  80209a:	e8 0e 01 00 00       	call   8021ad <nsipc_accept>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	78 05                	js     8020ab <accept+0x2d>
	return alloc_sockfd(r);
  8020a6:	e8 5f ff ff ff       	call   80200a <alloc_sockfd>
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <bind>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	e8 1f ff ff ff       	call   801fda <fd2sockid>
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 12                	js     8020d1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	ff 75 10             	pushl  0x10(%ebp)
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	50                   	push   %eax
  8020c9:	e8 31 01 00 00       	call   8021ff <nsipc_bind>
  8020ce:	83 c4 10             	add    $0x10,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <shutdown>:
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	e8 f9 fe ff ff       	call   801fda <fd2sockid>
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	78 0f                	js     8020f4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020e5:	83 ec 08             	sub    $0x8,%esp
  8020e8:	ff 75 0c             	pushl  0xc(%ebp)
  8020eb:	50                   	push   %eax
  8020ec:	e8 43 01 00 00       	call   802234 <nsipc_shutdown>
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <connect>:
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	e8 d6 fe ff ff       	call   801fda <fd2sockid>
  802104:	85 c0                	test   %eax,%eax
  802106:	78 12                	js     80211a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	ff 75 10             	pushl  0x10(%ebp)
  80210e:	ff 75 0c             	pushl  0xc(%ebp)
  802111:	50                   	push   %eax
  802112:	e8 59 01 00 00       	call   802270 <nsipc_connect>
  802117:	83 c4 10             	add    $0x10,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <listen>:
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	e8 b0 fe ff ff       	call   801fda <fd2sockid>
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 0f                	js     80213d <listen+0x21>
	return nsipc_listen(r, backlog);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	ff 75 0c             	pushl  0xc(%ebp)
  802134:	50                   	push   %eax
  802135:	e8 6b 01 00 00       	call   8022a5 <nsipc_listen>
  80213a:	83 c4 10             	add    $0x10,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <socket>:

int
socket(int domain, int type, int protocol)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802145:	ff 75 10             	pushl  0x10(%ebp)
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	e8 3e 02 00 00       	call   802391 <nsipc_socket>
  802153:	83 c4 10             	add    $0x10,%esp
  802156:	85 c0                	test   %eax,%eax
  802158:	78 05                	js     80215f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80215a:	e8 ab fe ff ff       	call   80200a <alloc_sockfd>
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	53                   	push   %ebx
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80216a:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802171:	74 26                	je     802199 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802173:	6a 07                	push   $0x7
  802175:	68 00 70 80 00       	push   $0x807000
  80217a:	53                   	push   %ebx
  80217b:	ff 35 04 50 80 00    	pushl  0x805004
  802181:	e8 61 07 00 00       	call   8028e7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802186:	83 c4 0c             	add    $0xc,%esp
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	e8 ea 06 00 00       	call   80287e <ipc_recv>
}
  802194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802197:	c9                   	leave  
  802198:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802199:	83 ec 0c             	sub    $0xc,%esp
  80219c:	6a 02                	push   $0x2
  80219e:	e8 9c 07 00 00       	call   80293f <ipc_find_env>
  8021a3:	a3 04 50 80 00       	mov    %eax,0x805004
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	eb c6                	jmp    802173 <nsipc+0x12>

008021ad <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	56                   	push   %esi
  8021b1:	53                   	push   %ebx
  8021b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021bd:	8b 06                	mov    (%esi),%eax
  8021bf:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c9:	e8 93 ff ff ff       	call   802161 <nsipc>
  8021ce:	89 c3                	mov    %eax,%ebx
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	79 09                	jns    8021dd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021d4:	89 d8                	mov    %ebx,%eax
  8021d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	ff 35 10 70 80 00    	pushl  0x807010
  8021e6:	68 00 70 80 00       	push   $0x807000
  8021eb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ee:	e8 e0 e9 ff ff       	call   800bd3 <memmove>
		*addrlen = ret->ret_addrlen;
  8021f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021f8:	89 06                	mov    %eax,(%esi)
  8021fa:	83 c4 10             	add    $0x10,%esp
	return r;
  8021fd:	eb d5                	jmp    8021d4 <nsipc_accept+0x27>

008021ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	53                   	push   %ebx
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802211:	53                   	push   %ebx
  802212:	ff 75 0c             	pushl  0xc(%ebp)
  802215:	68 04 70 80 00       	push   $0x807004
  80221a:	e8 b4 e9 ff ff       	call   800bd3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80221f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802225:	b8 02 00 00 00       	mov    $0x2,%eax
  80222a:	e8 32 ff ff ff       	call   802161 <nsipc>
}
  80222f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80224a:	b8 03 00 00 00       	mov    $0x3,%eax
  80224f:	e8 0d ff ff ff       	call   802161 <nsipc>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <nsipc_close>:

int
nsipc_close(int s)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802264:	b8 04 00 00 00       	mov    $0x4,%eax
  802269:	e8 f3 fe ff ff       	call   802161 <nsipc>
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	53                   	push   %ebx
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802282:	53                   	push   %ebx
  802283:	ff 75 0c             	pushl  0xc(%ebp)
  802286:	68 04 70 80 00       	push   $0x807004
  80228b:	e8 43 e9 ff ff       	call   800bd3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802290:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802296:	b8 05 00 00 00       	mov    $0x5,%eax
  80229b:	e8 c1 fe ff ff       	call   802161 <nsipc>
}
  8022a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022bb:	b8 06 00 00 00       	mov    $0x6,%eax
  8022c0:	e8 9c fe ff ff       	call   802161 <nsipc>
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	56                   	push   %esi
  8022cb:	53                   	push   %ebx
  8022cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022d7:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e0:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8022ea:	e8 72 fe ff ff       	call   802161 <nsipc>
  8022ef:	89 c3                	mov    %eax,%ebx
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	78 1f                	js     802314 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022f5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022fa:	7f 21                	jg     80231d <nsipc_recv+0x56>
  8022fc:	39 c6                	cmp    %eax,%esi
  8022fe:	7c 1d                	jl     80231d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	50                   	push   %eax
  802304:	68 00 70 80 00       	push   $0x807000
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	e8 c2 e8 ff ff       	call   800bd3 <memmove>
  802311:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802314:	89 d8                	mov    %ebx,%eax
  802316:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802319:	5b                   	pop    %ebx
  80231a:	5e                   	pop    %esi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80231d:	68 9e 32 80 00       	push   $0x80329e
  802322:	68 87 31 80 00       	push   $0x803187
  802327:	6a 62                	push   $0x62
  802329:	68 b3 32 80 00       	push   $0x8032b3
  80232e:	e8 bd de ff ff       	call   8001f0 <_panic>

00802333 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	53                   	push   %ebx
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802345:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80234b:	7f 2e                	jg     80237b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80234d:	83 ec 04             	sub    $0x4,%esp
  802350:	53                   	push   %ebx
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	68 0c 70 80 00       	push   $0x80700c
  802359:	e8 75 e8 ff ff       	call   800bd3 <memmove>
	nsipcbuf.send.req_size = size;
  80235e:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802364:	8b 45 14             	mov    0x14(%ebp),%eax
  802367:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80236c:	b8 08 00 00 00       	mov    $0x8,%eax
  802371:	e8 eb fd ff ff       	call   802161 <nsipc>
}
  802376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802379:	c9                   	leave  
  80237a:	c3                   	ret    
	assert(size < 1600);
  80237b:	68 bf 32 80 00       	push   $0x8032bf
  802380:	68 87 31 80 00       	push   $0x803187
  802385:	6a 6d                	push   $0x6d
  802387:	68 b3 32 80 00       	push   $0x8032b3
  80238c:	e8 5f de ff ff       	call   8001f0 <_panic>

00802391 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
  802394:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80239f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a2:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023aa:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023af:	b8 09 00 00 00       	mov    $0x9,%eax
  8023b4:	e8 a8 fd ff ff       	call   802161 <nsipc>
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	e8 4e ed ff ff       	call   80111c <fd2data>
  8023ce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023d0:	83 c4 08             	add    $0x8,%esp
  8023d3:	68 cb 32 80 00       	push   $0x8032cb
  8023d8:	53                   	push   %ebx
  8023d9:	e8 67 e6 ff ff       	call   800a45 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023de:	8b 46 04             	mov    0x4(%esi),%eax
  8023e1:	2b 06                	sub    (%esi),%eax
  8023e3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023e9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023f0:	00 00 00 
	stat->st_dev = &devpipe;
  8023f3:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023fa:	40 80 00 
	return 0;
}
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802405:	5b                   	pop    %ebx
  802406:	5e                   	pop    %esi
  802407:	5d                   	pop    %ebp
  802408:	c3                   	ret    

00802409 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	53                   	push   %ebx
  80240d:	83 ec 0c             	sub    $0xc,%esp
  802410:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802413:	53                   	push   %ebx
  802414:	6a 00                	push   $0x0
  802416:	e8 a1 ea ff ff       	call   800ebc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80241b:	89 1c 24             	mov    %ebx,(%esp)
  80241e:	e8 f9 ec ff ff       	call   80111c <fd2data>
  802423:	83 c4 08             	add    $0x8,%esp
  802426:	50                   	push   %eax
  802427:	6a 00                	push   $0x0
  802429:	e8 8e ea ff ff       	call   800ebc <sys_page_unmap>
}
  80242e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <_pipeisclosed>:
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	57                   	push   %edi
  802437:	56                   	push   %esi
  802438:	53                   	push   %ebx
  802439:	83 ec 1c             	sub    $0x1c,%esp
  80243c:	89 c7                	mov    %eax,%edi
  80243e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802440:	a1 08 50 80 00       	mov    0x805008,%eax
  802445:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802448:	83 ec 0c             	sub    $0xc,%esp
  80244b:	57                   	push   %edi
  80244c:	e8 29 05 00 00       	call   80297a <pageref>
  802451:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802454:	89 34 24             	mov    %esi,(%esp)
  802457:	e8 1e 05 00 00       	call   80297a <pageref>
		nn = thisenv->env_runs;
  80245c:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802462:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802465:	83 c4 10             	add    $0x10,%esp
  802468:	39 cb                	cmp    %ecx,%ebx
  80246a:	74 1b                	je     802487 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80246c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80246f:	75 cf                	jne    802440 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802471:	8b 42 58             	mov    0x58(%edx),%eax
  802474:	6a 01                	push   $0x1
  802476:	50                   	push   %eax
  802477:	53                   	push   %ebx
  802478:	68 d2 32 80 00       	push   $0x8032d2
  80247d:	e8 64 de ff ff       	call   8002e6 <cprintf>
  802482:	83 c4 10             	add    $0x10,%esp
  802485:	eb b9                	jmp    802440 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802487:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80248a:	0f 94 c0             	sete   %al
  80248d:	0f b6 c0             	movzbl %al,%eax
}
  802490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802493:	5b                   	pop    %ebx
  802494:	5e                   	pop    %esi
  802495:	5f                   	pop    %edi
  802496:	5d                   	pop    %ebp
  802497:	c3                   	ret    

00802498 <devpipe_write>:
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	57                   	push   %edi
  80249c:	56                   	push   %esi
  80249d:	53                   	push   %ebx
  80249e:	83 ec 28             	sub    $0x28,%esp
  8024a1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024a4:	56                   	push   %esi
  8024a5:	e8 72 ec ff ff       	call   80111c <fd2data>
  8024aa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024b7:	74 4f                	je     802508 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024b9:	8b 43 04             	mov    0x4(%ebx),%eax
  8024bc:	8b 0b                	mov    (%ebx),%ecx
  8024be:	8d 51 20             	lea    0x20(%ecx),%edx
  8024c1:	39 d0                	cmp    %edx,%eax
  8024c3:	72 14                	jb     8024d9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024c5:	89 da                	mov    %ebx,%edx
  8024c7:	89 f0                	mov    %esi,%eax
  8024c9:	e8 65 ff ff ff       	call   802433 <_pipeisclosed>
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	75 3b                	jne    80250d <devpipe_write+0x75>
			sys_yield();
  8024d2:	e8 41 e9 ff ff       	call   800e18 <sys_yield>
  8024d7:	eb e0                	jmp    8024b9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024dc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024e0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024e3:	89 c2                	mov    %eax,%edx
  8024e5:	c1 fa 1f             	sar    $0x1f,%edx
  8024e8:	89 d1                	mov    %edx,%ecx
  8024ea:	c1 e9 1b             	shr    $0x1b,%ecx
  8024ed:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024f0:	83 e2 1f             	and    $0x1f,%edx
  8024f3:	29 ca                	sub    %ecx,%edx
  8024f5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024f9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024fd:	83 c0 01             	add    $0x1,%eax
  802500:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802503:	83 c7 01             	add    $0x1,%edi
  802506:	eb ac                	jmp    8024b4 <devpipe_write+0x1c>
	return i;
  802508:	8b 45 10             	mov    0x10(%ebp),%eax
  80250b:	eb 05                	jmp    802512 <devpipe_write+0x7a>
				return 0;
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802512:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802515:	5b                   	pop    %ebx
  802516:	5e                   	pop    %esi
  802517:	5f                   	pop    %edi
  802518:	5d                   	pop    %ebp
  802519:	c3                   	ret    

0080251a <devpipe_read>:
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	57                   	push   %edi
  80251e:	56                   	push   %esi
  80251f:	53                   	push   %ebx
  802520:	83 ec 18             	sub    $0x18,%esp
  802523:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802526:	57                   	push   %edi
  802527:	e8 f0 eb ff ff       	call   80111c <fd2data>
  80252c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	be 00 00 00 00       	mov    $0x0,%esi
  802536:	3b 75 10             	cmp    0x10(%ebp),%esi
  802539:	75 14                	jne    80254f <devpipe_read+0x35>
	return i;
  80253b:	8b 45 10             	mov    0x10(%ebp),%eax
  80253e:	eb 02                	jmp    802542 <devpipe_read+0x28>
				return i;
  802540:	89 f0                	mov    %esi,%eax
}
  802542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802545:	5b                   	pop    %ebx
  802546:	5e                   	pop    %esi
  802547:	5f                   	pop    %edi
  802548:	5d                   	pop    %ebp
  802549:	c3                   	ret    
			sys_yield();
  80254a:	e8 c9 e8 ff ff       	call   800e18 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80254f:	8b 03                	mov    (%ebx),%eax
  802551:	3b 43 04             	cmp    0x4(%ebx),%eax
  802554:	75 18                	jne    80256e <devpipe_read+0x54>
			if (i > 0)
  802556:	85 f6                	test   %esi,%esi
  802558:	75 e6                	jne    802540 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80255a:	89 da                	mov    %ebx,%edx
  80255c:	89 f8                	mov    %edi,%eax
  80255e:	e8 d0 fe ff ff       	call   802433 <_pipeisclosed>
  802563:	85 c0                	test   %eax,%eax
  802565:	74 e3                	je     80254a <devpipe_read+0x30>
				return 0;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	eb d4                	jmp    802542 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80256e:	99                   	cltd   
  80256f:	c1 ea 1b             	shr    $0x1b,%edx
  802572:	01 d0                	add    %edx,%eax
  802574:	83 e0 1f             	and    $0x1f,%eax
  802577:	29 d0                	sub    %edx,%eax
  802579:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80257e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802581:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802584:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802587:	83 c6 01             	add    $0x1,%esi
  80258a:	eb aa                	jmp    802536 <devpipe_read+0x1c>

0080258c <pipe>:
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	56                   	push   %esi
  802590:	53                   	push   %ebx
  802591:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802597:	50                   	push   %eax
  802598:	e8 96 eb ff ff       	call   801133 <fd_alloc>
  80259d:	89 c3                	mov    %eax,%ebx
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	0f 88 23 01 00 00    	js     8026cd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	68 07 04 00 00       	push   $0x407
  8025b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b5:	6a 00                	push   $0x0
  8025b7:	e8 7b e8 ff ff       	call   800e37 <sys_page_alloc>
  8025bc:	89 c3                	mov    %eax,%ebx
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 88 04 01 00 00    	js     8026cd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025c9:	83 ec 0c             	sub    $0xc,%esp
  8025cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025cf:	50                   	push   %eax
  8025d0:	e8 5e eb ff ff       	call   801133 <fd_alloc>
  8025d5:	89 c3                	mov    %eax,%ebx
  8025d7:	83 c4 10             	add    $0x10,%esp
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	0f 88 db 00 00 00    	js     8026bd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	68 07 04 00 00       	push   $0x407
  8025ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ed:	6a 00                	push   $0x0
  8025ef:	e8 43 e8 ff ff       	call   800e37 <sys_page_alloc>
  8025f4:	89 c3                	mov    %eax,%ebx
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	0f 88 bc 00 00 00    	js     8026bd <pipe+0x131>
	va = fd2data(fd0);
  802601:	83 ec 0c             	sub    $0xc,%esp
  802604:	ff 75 f4             	pushl  -0xc(%ebp)
  802607:	e8 10 eb ff ff       	call   80111c <fd2data>
  80260c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260e:	83 c4 0c             	add    $0xc,%esp
  802611:	68 07 04 00 00       	push   $0x407
  802616:	50                   	push   %eax
  802617:	6a 00                	push   $0x0
  802619:	e8 19 e8 ff ff       	call   800e37 <sys_page_alloc>
  80261e:	89 c3                	mov    %eax,%ebx
  802620:	83 c4 10             	add    $0x10,%esp
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 88 82 00 00 00    	js     8026ad <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	ff 75 f0             	pushl  -0x10(%ebp)
  802631:	e8 e6 ea ff ff       	call   80111c <fd2data>
  802636:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80263d:	50                   	push   %eax
  80263e:	6a 00                	push   $0x0
  802640:	56                   	push   %esi
  802641:	6a 00                	push   $0x0
  802643:	e8 32 e8 ff ff       	call   800e7a <sys_page_map>
  802648:	89 c3                	mov    %eax,%ebx
  80264a:	83 c4 20             	add    $0x20,%esp
  80264d:	85 c0                	test   %eax,%eax
  80264f:	78 4e                	js     80269f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802651:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80265b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802668:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802674:	83 ec 0c             	sub    $0xc,%esp
  802677:	ff 75 f4             	pushl  -0xc(%ebp)
  80267a:	e8 8d ea ff ff       	call   80110c <fd2num>
  80267f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802682:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802684:	83 c4 04             	add    $0x4,%esp
  802687:	ff 75 f0             	pushl  -0x10(%ebp)
  80268a:	e8 7d ea ff ff       	call   80110c <fd2num>
  80268f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802692:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802695:	83 c4 10             	add    $0x10,%esp
  802698:	bb 00 00 00 00       	mov    $0x0,%ebx
  80269d:	eb 2e                	jmp    8026cd <pipe+0x141>
	sys_page_unmap(0, va);
  80269f:	83 ec 08             	sub    $0x8,%esp
  8026a2:	56                   	push   %esi
  8026a3:	6a 00                	push   $0x0
  8026a5:	e8 12 e8 ff ff       	call   800ebc <sys_page_unmap>
  8026aa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026ad:	83 ec 08             	sub    $0x8,%esp
  8026b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026b3:	6a 00                	push   $0x0
  8026b5:	e8 02 e8 ff ff       	call   800ebc <sys_page_unmap>
  8026ba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8026bd:	83 ec 08             	sub    $0x8,%esp
  8026c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c3:	6a 00                	push   $0x0
  8026c5:	e8 f2 e7 ff ff       	call   800ebc <sys_page_unmap>
  8026ca:	83 c4 10             	add    $0x10,%esp
}
  8026cd:	89 d8                	mov    %ebx,%eax
  8026cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d2:	5b                   	pop    %ebx
  8026d3:	5e                   	pop    %esi
  8026d4:	5d                   	pop    %ebp
  8026d5:	c3                   	ret    

008026d6 <pipeisclosed>:
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026df:	50                   	push   %eax
  8026e0:	ff 75 08             	pushl  0x8(%ebp)
  8026e3:	e8 9d ea ff ff       	call   801185 <fd_lookup>
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	78 18                	js     802707 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026ef:	83 ec 0c             	sub    $0xc,%esp
  8026f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f5:	e8 22 ea ff ff       	call   80111c <fd2data>
	return _pipeisclosed(fd, p);
  8026fa:	89 c2                	mov    %eax,%edx
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	e8 2f fd ff ff       	call   802433 <_pipeisclosed>
  802704:	83 c4 10             	add    $0x10,%esp
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
  80270e:	c3                   	ret    

0080270f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802715:	68 ea 32 80 00       	push   $0x8032ea
  80271a:	ff 75 0c             	pushl  0xc(%ebp)
  80271d:	e8 23 e3 ff ff       	call   800a45 <strcpy>
	return 0;
}
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <devcons_write>:
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	57                   	push   %edi
  80272d:	56                   	push   %esi
  80272e:	53                   	push   %ebx
  80272f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802735:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80273a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802740:	3b 75 10             	cmp    0x10(%ebp),%esi
  802743:	73 31                	jae    802776 <devcons_write+0x4d>
		m = n - tot;
  802745:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802748:	29 f3                	sub    %esi,%ebx
  80274a:	83 fb 7f             	cmp    $0x7f,%ebx
  80274d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802752:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	53                   	push   %ebx
  802759:	89 f0                	mov    %esi,%eax
  80275b:	03 45 0c             	add    0xc(%ebp),%eax
  80275e:	50                   	push   %eax
  80275f:	57                   	push   %edi
  802760:	e8 6e e4 ff ff       	call   800bd3 <memmove>
		sys_cputs(buf, m);
  802765:	83 c4 08             	add    $0x8,%esp
  802768:	53                   	push   %ebx
  802769:	57                   	push   %edi
  80276a:	e8 0c e6 ff ff       	call   800d7b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80276f:	01 de                	add    %ebx,%esi
  802771:	83 c4 10             	add    $0x10,%esp
  802774:	eb ca                	jmp    802740 <devcons_write+0x17>
}
  802776:	89 f0                	mov    %esi,%eax
  802778:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80277b:	5b                   	pop    %ebx
  80277c:	5e                   	pop    %esi
  80277d:	5f                   	pop    %edi
  80277e:	5d                   	pop    %ebp
  80277f:	c3                   	ret    

00802780 <devcons_read>:
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 08             	sub    $0x8,%esp
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80278b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80278f:	74 21                	je     8027b2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802791:	e8 03 e6 ff ff       	call   800d99 <sys_cgetc>
  802796:	85 c0                	test   %eax,%eax
  802798:	75 07                	jne    8027a1 <devcons_read+0x21>
		sys_yield();
  80279a:	e8 79 e6 ff ff       	call   800e18 <sys_yield>
  80279f:	eb f0                	jmp    802791 <devcons_read+0x11>
	if (c < 0)
  8027a1:	78 0f                	js     8027b2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027a3:	83 f8 04             	cmp    $0x4,%eax
  8027a6:	74 0c                	je     8027b4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ab:	88 02                	mov    %al,(%edx)
	return 1;
  8027ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    
		return 0;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	eb f7                	jmp    8027b2 <devcons_read+0x32>

008027bb <cputchar>:
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027c7:	6a 01                	push   $0x1
  8027c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027cc:	50                   	push   %eax
  8027cd:	e8 a9 e5 ff ff       	call   800d7b <sys_cputs>
}
  8027d2:	83 c4 10             	add    $0x10,%esp
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <getchar>:
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027dd:	6a 01                	push   $0x1
  8027df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027e2:	50                   	push   %eax
  8027e3:	6a 00                	push   $0x0
  8027e5:	e8 0b ec ff ff       	call   8013f5 <read>
	if (r < 0)
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	78 06                	js     8027f7 <getchar+0x20>
	if (r < 1)
  8027f1:	74 06                	je     8027f9 <getchar+0x22>
	return c;
  8027f3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    
		return -E_EOF;
  8027f9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027fe:	eb f7                	jmp    8027f7 <getchar+0x20>

00802800 <iscons>:
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802809:	50                   	push   %eax
  80280a:	ff 75 08             	pushl  0x8(%ebp)
  80280d:	e8 73 e9 ff ff       	call   801185 <fd_lookup>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	85 c0                	test   %eax,%eax
  802817:	78 11                	js     80282a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802822:	39 10                	cmp    %edx,(%eax)
  802824:	0f 94 c0             	sete   %al
  802827:	0f b6 c0             	movzbl %al,%eax
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <opencons>:
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802835:	50                   	push   %eax
  802836:	e8 f8 e8 ff ff       	call   801133 <fd_alloc>
  80283b:	83 c4 10             	add    $0x10,%esp
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 3a                	js     80287c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 07 04 00 00       	push   $0x407
  80284a:	ff 75 f4             	pushl  -0xc(%ebp)
  80284d:	6a 00                	push   $0x0
  80284f:	e8 e3 e5 ff ff       	call   800e37 <sys_page_alloc>
  802854:	83 c4 10             	add    $0x10,%esp
  802857:	85 c0                	test   %eax,%eax
  802859:	78 21                	js     80287c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802864:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802870:	83 ec 0c             	sub    $0xc,%esp
  802873:	50                   	push   %eax
  802874:	e8 93 e8 ff ff       	call   80110c <fd2num>
  802879:	83 c4 10             	add    $0x10,%esp
}
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
  802881:	56                   	push   %esi
  802882:	53                   	push   %ebx
  802883:	8b 75 08             	mov    0x8(%ebp),%esi
  802886:	8b 45 0c             	mov    0xc(%ebp),%eax
  802889:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80288c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80288e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802893:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802896:	83 ec 0c             	sub    $0xc,%esp
  802899:	50                   	push   %eax
  80289a:	e8 48 e7 ff ff       	call   800fe7 <sys_ipc_recv>
	if(ret < 0){
  80289f:	83 c4 10             	add    $0x10,%esp
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	78 2b                	js     8028d1 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028a6:	85 f6                	test   %esi,%esi
  8028a8:	74 0a                	je     8028b4 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8028aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8028af:	8b 40 74             	mov    0x74(%eax),%eax
  8028b2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028b4:	85 db                	test   %ebx,%ebx
  8028b6:	74 0a                	je     8028c2 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8028b8:	a1 08 50 80 00       	mov    0x805008,%eax
  8028bd:	8b 40 78             	mov    0x78(%eax),%eax
  8028c0:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8028c2:	a1 08 50 80 00       	mov    0x805008,%eax
  8028c7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028cd:	5b                   	pop    %ebx
  8028ce:	5e                   	pop    %esi
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
		if(from_env_store)
  8028d1:	85 f6                	test   %esi,%esi
  8028d3:	74 06                	je     8028db <ipc_recv+0x5d>
			*from_env_store = 0;
  8028d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028db:	85 db                	test   %ebx,%ebx
  8028dd:	74 eb                	je     8028ca <ipc_recv+0x4c>
			*perm_store = 0;
  8028df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028e5:	eb e3                	jmp    8028ca <ipc_recv+0x4c>

008028e7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028e7:	55                   	push   %ebp
  8028e8:	89 e5                	mov    %esp,%ebp
  8028ea:	57                   	push   %edi
  8028eb:	56                   	push   %esi
  8028ec:	53                   	push   %ebx
  8028ed:	83 ec 0c             	sub    $0xc,%esp
  8028f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028f9:	85 db                	test   %ebx,%ebx
  8028fb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802900:	0f 44 d8             	cmove  %eax,%ebx
  802903:	eb 05                	jmp    80290a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802905:	e8 0e e5 ff ff       	call   800e18 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80290a:	ff 75 14             	pushl  0x14(%ebp)
  80290d:	53                   	push   %ebx
  80290e:	56                   	push   %esi
  80290f:	57                   	push   %edi
  802910:	e8 af e6 ff ff       	call   800fc4 <sys_ipc_try_send>
  802915:	83 c4 10             	add    $0x10,%esp
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 1b                	je     802937 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80291c:	79 e7                	jns    802905 <ipc_send+0x1e>
  80291e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802921:	74 e2                	je     802905 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802923:	83 ec 04             	sub    $0x4,%esp
  802926:	68 f6 32 80 00       	push   $0x8032f6
  80292b:	6a 48                	push   $0x48
  80292d:	68 0b 33 80 00       	push   $0x80330b
  802932:	e8 b9 d8 ff ff       	call   8001f0 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802937:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80293a:	5b                   	pop    %ebx
  80293b:	5e                   	pop    %esi
  80293c:	5f                   	pop    %edi
  80293d:	5d                   	pop    %ebp
  80293e:	c3                   	ret    

0080293f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80294a:	89 c2                	mov    %eax,%edx
  80294c:	c1 e2 07             	shl    $0x7,%edx
  80294f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802955:	8b 52 50             	mov    0x50(%edx),%edx
  802958:	39 ca                	cmp    %ecx,%edx
  80295a:	74 11                	je     80296d <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80295c:	83 c0 01             	add    $0x1,%eax
  80295f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802964:	75 e4                	jne    80294a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802966:	b8 00 00 00 00       	mov    $0x0,%eax
  80296b:	eb 0b                	jmp    802978 <ipc_find_env+0x39>
			return envs[i].env_id;
  80296d:	c1 e0 07             	shl    $0x7,%eax
  802970:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802975:	8b 40 48             	mov    0x48(%eax),%eax
}
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    

0080297a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802980:	89 d0                	mov    %edx,%eax
  802982:	c1 e8 16             	shr    $0x16,%eax
  802985:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802991:	f6 c1 01             	test   $0x1,%cl
  802994:	74 1d                	je     8029b3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802996:	c1 ea 0c             	shr    $0xc,%edx
  802999:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029a0:	f6 c2 01             	test   $0x1,%dl
  8029a3:	74 0e                	je     8029b3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029a5:	c1 ea 0c             	shr    $0xc,%edx
  8029a8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029af:	ef 
  8029b0:	0f b7 c0             	movzwl %ax,%eax
}
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	66 90                	xchg   %ax,%ax
  8029b7:	66 90                	xchg   %ax,%ax
  8029b9:	66 90                	xchg   %ax,%ax
  8029bb:	66 90                	xchg   %ax,%ax
  8029bd:	66 90                	xchg   %ax,%ax
  8029bf:	90                   	nop

008029c0 <__udivdi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029d7:	85 d2                	test   %edx,%edx
  8029d9:	75 4d                	jne    802a28 <__udivdi3+0x68>
  8029db:	39 f3                	cmp    %esi,%ebx
  8029dd:	76 19                	jbe    8029f8 <__udivdi3+0x38>
  8029df:	31 ff                	xor    %edi,%edi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f2                	mov    %esi,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 d9                	mov    %ebx,%ecx
  8029fa:	85 db                	test   %ebx,%ebx
  8029fc:	75 0b                	jne    802a09 <__udivdi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 c1                	mov    %eax,%ecx
  802a09:	31 d2                	xor    %edx,%edx
  802a0b:	89 f0                	mov    %esi,%eax
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 c6                	mov    %eax,%esi
  802a11:	89 e8                	mov    %ebp,%eax
  802a13:	89 f7                	mov    %esi,%edi
  802a15:	f7 f1                	div    %ecx
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	77 1c                	ja     802a48 <__udivdi3+0x88>
  802a2c:	0f bd fa             	bsr    %edx,%edi
  802a2f:	83 f7 1f             	xor    $0x1f,%edi
  802a32:	75 2c                	jne    802a60 <__udivdi3+0xa0>
  802a34:	39 f2                	cmp    %esi,%edx
  802a36:	72 06                	jb     802a3e <__udivdi3+0x7e>
  802a38:	31 c0                	xor    %eax,%eax
  802a3a:	39 eb                	cmp    %ebp,%ebx
  802a3c:	77 a9                	ja     8029e7 <__udivdi3+0x27>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	eb a2                	jmp    8029e7 <__udivdi3+0x27>
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	31 ff                	xor    %edi,%edi
  802a4a:	31 c0                	xor    %eax,%eax
  802a4c:	89 fa                	mov    %edi,%edx
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	89 f9                	mov    %edi,%ecx
  802a62:	b8 20 00 00 00       	mov    $0x20,%eax
  802a67:	29 f8                	sub    %edi,%eax
  802a69:	d3 e2                	shl    %cl,%edx
  802a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a6f:	89 c1                	mov    %eax,%ecx
  802a71:	89 da                	mov    %ebx,%edx
  802a73:	d3 ea                	shr    %cl,%edx
  802a75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a79:	09 d1                	or     %edx,%ecx
  802a7b:	89 f2                	mov    %esi,%edx
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 f9                	mov    %edi,%ecx
  802a83:	d3 e3                	shl    %cl,%ebx
  802a85:	89 c1                	mov    %eax,%ecx
  802a87:	d3 ea                	shr    %cl,%edx
  802a89:	89 f9                	mov    %edi,%ecx
  802a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a8f:	89 eb                	mov    %ebp,%ebx
  802a91:	d3 e6                	shl    %cl,%esi
  802a93:	89 c1                	mov    %eax,%ecx
  802a95:	d3 eb                	shr    %cl,%ebx
  802a97:	09 de                	or     %ebx,%esi
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	f7 74 24 08          	divl   0x8(%esp)
  802a9f:	89 d6                	mov    %edx,%esi
  802aa1:	89 c3                	mov    %eax,%ebx
  802aa3:	f7 64 24 0c          	mull   0xc(%esp)
  802aa7:	39 d6                	cmp    %edx,%esi
  802aa9:	72 15                	jb     802ac0 <__udivdi3+0x100>
  802aab:	89 f9                	mov    %edi,%ecx
  802aad:	d3 e5                	shl    %cl,%ebp
  802aaf:	39 c5                	cmp    %eax,%ebp
  802ab1:	73 04                	jae    802ab7 <__udivdi3+0xf7>
  802ab3:	39 d6                	cmp    %edx,%esi
  802ab5:	74 09                	je     802ac0 <__udivdi3+0x100>
  802ab7:	89 d8                	mov    %ebx,%eax
  802ab9:	31 ff                	xor    %edi,%edi
  802abb:	e9 27 ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ac3:	31 ff                	xor    %edi,%edi
  802ac5:	e9 1d ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	66 90                	xchg   %ax,%ax
  802ace:	66 90                	xchg   %ax,%ax

00802ad0 <__umoddi3>:
  802ad0:	55                   	push   %ebp
  802ad1:	57                   	push   %edi
  802ad2:	56                   	push   %esi
  802ad3:	53                   	push   %ebx
  802ad4:	83 ec 1c             	sub    $0x1c,%esp
  802ad7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802adf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ae7:	89 da                	mov    %ebx,%edx
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 43                	jne    802b30 <__umoddi3+0x60>
  802aed:	39 df                	cmp    %ebx,%edi
  802aef:	76 17                	jbe    802b08 <__umoddi3+0x38>
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	f7 f7                	div    %edi
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	31 d2                	xor    %edx,%edx
  802af9:	83 c4 1c             	add    $0x1c,%esp
  802afc:	5b                   	pop    %ebx
  802afd:	5e                   	pop    %esi
  802afe:	5f                   	pop    %edi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	89 fd                	mov    %edi,%ebp
  802b0a:	85 ff                	test   %edi,%edi
  802b0c:	75 0b                	jne    802b19 <__umoddi3+0x49>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f7                	div    %edi
  802b17:	89 c5                	mov    %eax,%ebp
  802b19:	89 d8                	mov    %ebx,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 f0                	mov    %esi,%eax
  802b21:	f7 f5                	div    %ebp
  802b23:	89 d0                	mov    %edx,%eax
  802b25:	eb d0                	jmp    802af7 <__umoddi3+0x27>
  802b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2e:	66 90                	xchg   %ax,%ax
  802b30:	89 f1                	mov    %esi,%ecx
  802b32:	39 d8                	cmp    %ebx,%eax
  802b34:	76 0a                	jbe    802b40 <__umoddi3+0x70>
  802b36:	89 f0                	mov    %esi,%eax
  802b38:	83 c4 1c             	add    $0x1c,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	0f bd e8             	bsr    %eax,%ebp
  802b43:	83 f5 1f             	xor    $0x1f,%ebp
  802b46:	75 20                	jne    802b68 <__umoddi3+0x98>
  802b48:	39 d8                	cmp    %ebx,%eax
  802b4a:	0f 82 b0 00 00 00    	jb     802c00 <__umoddi3+0x130>
  802b50:	39 f7                	cmp    %esi,%edi
  802b52:	0f 86 a8 00 00 00    	jbe    802c00 <__umoddi3+0x130>
  802b58:	89 c8                	mov    %ecx,%eax
  802b5a:	83 c4 1c             	add    $0x1c,%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5e                   	pop    %esi
  802b5f:	5f                   	pop    %edi
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b6f:	29 ea                	sub    %ebp,%edx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b77:	89 d1                	mov    %edx,%ecx
  802b79:	89 f8                	mov    %edi,%eax
  802b7b:	d3 e8                	shr    %cl,%eax
  802b7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b89:	09 c1                	or     %eax,%ecx
  802b8b:	89 d8                	mov    %ebx,%eax
  802b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b91:	89 e9                	mov    %ebp,%ecx
  802b93:	d3 e7                	shl    %cl,%edi
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b9f:	d3 e3                	shl    %cl,%ebx
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	89 d1                	mov    %edx,%ecx
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 fa                	mov    %edi,%edx
  802bad:	d3 e6                	shl    %cl,%esi
  802baf:	09 d8                	or     %ebx,%eax
  802bb1:	f7 74 24 08          	divl   0x8(%esp)
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	89 f3                	mov    %esi,%ebx
  802bb9:	f7 64 24 0c          	mull   0xc(%esp)
  802bbd:	89 c6                	mov    %eax,%esi
  802bbf:	89 d7                	mov    %edx,%edi
  802bc1:	39 d1                	cmp    %edx,%ecx
  802bc3:	72 06                	jb     802bcb <__umoddi3+0xfb>
  802bc5:	75 10                	jne    802bd7 <__umoddi3+0x107>
  802bc7:	39 c3                	cmp    %eax,%ebx
  802bc9:	73 0c                	jae    802bd7 <__umoddi3+0x107>
  802bcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bd3:	89 d7                	mov    %edx,%edi
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	89 ca                	mov    %ecx,%edx
  802bd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bde:	29 f3                	sub    %esi,%ebx
  802be0:	19 fa                	sbb    %edi,%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	d3 e0                	shl    %cl,%eax
  802be6:	89 e9                	mov    %ebp,%ecx
  802be8:	d3 eb                	shr    %cl,%ebx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	09 d8                	or     %ebx,%eax
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	29 fe                	sub    %edi,%esi
  802c04:	19 c2                	sbb    %eax,%edx
  802c06:	89 f1                	mov    %esi,%ecx
  802c08:	89 c8                	mov    %ecx,%eax
  802c0a:	e9 4b ff ff ff       	jmp    802b5a <__umoddi3+0x8a>
