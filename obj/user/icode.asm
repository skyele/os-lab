
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
  80003e:	c7 05 00 40 80 00 00 	movl   $0x802c00,0x804000
  800045:	2c 80 00 

	cprintf("icode startup\n");
  800048:	68 06 2c 80 00       	push   $0x802c06
  80004d:	e8 55 02 00 00       	call   8002a7 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  800059:	e8 49 02 00 00       	call   8002a7 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 28 2c 80 00       	push   $0x802c28
  800068:	e8 07 18 00 00       	call   801874 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 51 2c 80 00       	push   $0x802c51
  80007e:	e8 24 02 00 00       	call   8002a7 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 3b 13 00 00       	call   8013d6 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 90 0c 00 00       	call   800d3c <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 2e 2c 80 00       	push   $0x802c2e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 44 2c 80 00       	push   $0x802c44
  8000be:	e8 ee 00 00 00       	call   8001b1 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 64 2c 80 00       	push   $0x802c64
  8000cb:	e8 d7 01 00 00       	call   8002a7 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 c0 11 00 00       	call   801298 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 78 2c 80 00 	movl   $0x802c78,(%esp)
  8000df:	e8 c3 01 00 00       	call   8002a7 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 8c 2c 80 00       	push   $0x802c8c
  8000f0:	68 95 2c 80 00       	push   $0x802c95
  8000f5:	68 9f 2c 80 00       	push   $0x802c9f
  8000fa:	68 9e 2c 80 00       	push   $0x802c9e
  8000ff:	e8 a3 1d 00 00       	call   801ea7 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 bb 2c 80 00       	push   $0x802cbb
  800113:	e8 8f 01 00 00       	call   8002a7 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 a4 2c 80 00       	push   $0x802ca4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 44 2c 80 00       	push   $0x802c44
  80012f:	e8 7d 00 00 00       	call   8001b1 <_panic>

00800134 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80013f:	e8 76 0c 00 00       	call   800dba <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80014f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800154:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800159:	85 db                	test   %ebx,%ebx
  80015b:	7e 07                	jle    800164 <libmain+0x30>
		binaryname = argv[0];
  80015d:	8b 06                	mov    (%esi),%eax
  80015f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	e8 c5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016e:	e8 0a 00 00 00       	call   80017d <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800183:	a1 08 50 80 00       	mov    0x805008,%eax
  800188:	8b 40 48             	mov    0x48(%eax),%eax
  80018b:	68 e0 2c 80 00       	push   $0x802ce0
  800190:	50                   	push   %eax
  800191:	68 d5 2c 80 00       	push   $0x802cd5
  800196:	e8 0c 01 00 00       	call   8002a7 <cprintf>
	close_all();
  80019b:	e8 25 11 00 00       	call   8012c5 <close_all>
	sys_env_destroy(0);
  8001a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a7:	e8 cd 0b 00 00       	call   800d79 <sys_env_destroy>
}
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	c9                   	leave  
  8001b0:	c3                   	ret    

008001b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b1:	55                   	push   %ebp
  8001b2:	89 e5                	mov    %esp,%ebp
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001b6:	a1 08 50 80 00       	mov    0x805008,%eax
  8001bb:	8b 40 48             	mov    0x48(%eax),%eax
  8001be:	83 ec 04             	sub    $0x4,%esp
  8001c1:	68 0c 2d 80 00       	push   $0x802d0c
  8001c6:	50                   	push   %eax
  8001c7:	68 d5 2c 80 00       	push   $0x802cd5
  8001cc:	e8 d6 00 00 00       	call   8002a7 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001d1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001da:	e8 db 0b 00 00       	call   800dba <sys_getenvid>
  8001df:	83 c4 04             	add    $0x4,%esp
  8001e2:	ff 75 0c             	pushl  0xc(%ebp)
  8001e5:	ff 75 08             	pushl  0x8(%ebp)
  8001e8:	56                   	push   %esi
  8001e9:	50                   	push   %eax
  8001ea:	68 e8 2c 80 00       	push   $0x802ce8
  8001ef:	e8 b3 00 00 00       	call   8002a7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f4:	83 c4 18             	add    $0x18,%esp
  8001f7:	53                   	push   %ebx
  8001f8:	ff 75 10             	pushl  0x10(%ebp)
  8001fb:	e8 56 00 00 00       	call   800256 <vcprintf>
	cprintf("\n");
  800200:	c7 04 24 ed 32 80 00 	movl   $0x8032ed,(%esp)
  800207:	e8 9b 00 00 00       	call   8002a7 <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020f:	cc                   	int3   
  800210:	eb fd                	jmp    80020f <_panic+0x5e>

00800212 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	53                   	push   %ebx
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021c:	8b 13                	mov    (%ebx),%edx
  80021e:	8d 42 01             	lea    0x1(%edx),%eax
  800221:	89 03                	mov    %eax,(%ebx)
  800223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800226:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022f:	74 09                	je     80023a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800231:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800238:	c9                   	leave  
  800239:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	68 ff 00 00 00       	push   $0xff
  800242:	8d 43 08             	lea    0x8(%ebx),%eax
  800245:	50                   	push   %eax
  800246:	e8 f1 0a 00 00       	call   800d3c <sys_cputs>
		b->idx = 0;
  80024b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	eb db                	jmp    800231 <putch+0x1f>

00800256 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80025f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800266:	00 00 00 
	b.cnt = 0;
  800269:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800270:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800273:	ff 75 0c             	pushl  0xc(%ebp)
  800276:	ff 75 08             	pushl  0x8(%ebp)
  800279:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027f:	50                   	push   %eax
  800280:	68 12 02 80 00       	push   $0x800212
  800285:	e8 4a 01 00 00       	call   8003d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028a:	83 c4 08             	add    $0x8,%esp
  80028d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800293:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800299:	50                   	push   %eax
  80029a:	e8 9d 0a 00 00       	call   800d3c <sys_cputs>

	return b.cnt;
}
  80029f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b0:	50                   	push   %eax
  8002b1:	ff 75 08             	pushl  0x8(%ebp)
  8002b4:	e8 9d ff ff ff       	call   800256 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002b9:	c9                   	leave  
  8002ba:	c3                   	ret    

008002bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	57                   	push   %edi
  8002bf:	56                   	push   %esi
  8002c0:	53                   	push   %ebx
  8002c1:	83 ec 1c             	sub    $0x1c,%esp
  8002c4:	89 c6                	mov    %eax,%esi
  8002c6:	89 d7                	mov    %edx,%edi
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002da:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002de:	74 2c                	je     80030c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002f0:	39 c2                	cmp    %eax,%edx
  8002f2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002f5:	73 43                	jae    80033a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002f7:	83 eb 01             	sub    $0x1,%ebx
  8002fa:	85 db                	test   %ebx,%ebx
  8002fc:	7e 6c                	jle    80036a <printnum+0xaf>
				putch(padc, putdat);
  8002fe:	83 ec 08             	sub    $0x8,%esp
  800301:	57                   	push   %edi
  800302:	ff 75 18             	pushl  0x18(%ebp)
  800305:	ff d6                	call   *%esi
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	eb eb                	jmp    8002f7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	6a 20                	push   $0x20
  800311:	6a 00                	push   $0x0
  800313:	50                   	push   %eax
  800314:	ff 75 e4             	pushl  -0x1c(%ebp)
  800317:	ff 75 e0             	pushl  -0x20(%ebp)
  80031a:	89 fa                	mov    %edi,%edx
  80031c:	89 f0                	mov    %esi,%eax
  80031e:	e8 98 ff ff ff       	call   8002bb <printnum>
		while (--width > 0)
  800323:	83 c4 20             	add    $0x20,%esp
  800326:	83 eb 01             	sub    $0x1,%ebx
  800329:	85 db                	test   %ebx,%ebx
  80032b:	7e 65                	jle    800392 <printnum+0xd7>
			putch(padc, putdat);
  80032d:	83 ec 08             	sub    $0x8,%esp
  800330:	57                   	push   %edi
  800331:	6a 20                	push   $0x20
  800333:	ff d6                	call   *%esi
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	eb ec                	jmp    800326 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	ff 75 18             	pushl  0x18(%ebp)
  800340:	83 eb 01             	sub    $0x1,%ebx
  800343:	53                   	push   %ebx
  800344:	50                   	push   %eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	ff 75 dc             	pushl  -0x24(%ebp)
  80034b:	ff 75 d8             	pushl  -0x28(%ebp)
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	ff 75 e0             	pushl  -0x20(%ebp)
  800354:	e8 47 26 00 00       	call   8029a0 <__udivdi3>
  800359:	83 c4 18             	add    $0x18,%esp
  80035c:	52                   	push   %edx
  80035d:	50                   	push   %eax
  80035e:	89 fa                	mov    %edi,%edx
  800360:	89 f0                	mov    %esi,%eax
  800362:	e8 54 ff ff ff       	call   8002bb <printnum>
  800367:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80036a:	83 ec 08             	sub    $0x8,%esp
  80036d:	57                   	push   %edi
  80036e:	83 ec 04             	sub    $0x4,%esp
  800371:	ff 75 dc             	pushl  -0x24(%ebp)
  800374:	ff 75 d8             	pushl  -0x28(%ebp)
  800377:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037a:	ff 75 e0             	pushl  -0x20(%ebp)
  80037d:	e8 2e 27 00 00       	call   802ab0 <__umoddi3>
  800382:	83 c4 14             	add    $0x14,%esp
  800385:	0f be 80 13 2d 80 00 	movsbl 0x802d13(%eax),%eax
  80038c:	50                   	push   %eax
  80038d:	ff d6                	call   *%esi
  80038f:	83 c4 10             	add    $0x10,%esp
	}
}
  800392:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    

0080039a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a4:	8b 10                	mov    (%eax),%edx
  8003a6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a9:	73 0a                	jae    8003b5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	88 02                	mov    %al,(%edx)
}
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <printfmt>:
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003bd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c0:	50                   	push   %eax
  8003c1:	ff 75 10             	pushl  0x10(%ebp)
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	ff 75 08             	pushl  0x8(%ebp)
  8003ca:	e8 05 00 00 00       	call   8003d4 <vprintfmt>
}
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <vprintfmt>:
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	57                   	push   %edi
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
  8003da:	83 ec 3c             	sub    $0x3c,%esp
  8003dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003e6:	e9 32 04 00 00       	jmp    80081d <vprintfmt+0x449>
		padc = ' ';
  8003eb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003ef:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003f6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800404:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80040b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800412:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8d 47 01             	lea    0x1(%edi),%eax
  80041a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041d:	0f b6 17             	movzbl (%edi),%edx
  800420:	8d 42 dd             	lea    -0x23(%edx),%eax
  800423:	3c 55                	cmp    $0x55,%al
  800425:	0f 87 12 05 00 00    	ja     80093d <vprintfmt+0x569>
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	ff 24 85 00 2f 80 00 	jmp    *0x802f00(,%eax,4)
  800435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800438:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80043c:	eb d9                	jmp    800417 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800441:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800445:	eb d0                	jmp    800417 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800447:	0f b6 d2             	movzbl %dl,%edx
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80044d:	b8 00 00 00 00       	mov    $0x0,%eax
  800452:	89 75 08             	mov    %esi,0x8(%ebp)
  800455:	eb 03                	jmp    80045a <vprintfmt+0x86>
  800457:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80045a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80045d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800461:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800464:	8d 72 d0             	lea    -0x30(%edx),%esi
  800467:	83 fe 09             	cmp    $0x9,%esi
  80046a:	76 eb                	jbe    800457 <vprintfmt+0x83>
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	8b 75 08             	mov    0x8(%ebp),%esi
  800472:	eb 14                	jmp    800488 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 40 04             	lea    0x4(%eax),%eax
  800482:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800485:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800488:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048c:	79 89                	jns    800417 <vprintfmt+0x43>
				width = precision, precision = -1;
  80048e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80049b:	e9 77 ff ff ff       	jmp    800417 <vprintfmt+0x43>
  8004a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	0f 48 c1             	cmovs  %ecx,%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ae:	e9 64 ff ff ff       	jmp    800417 <vprintfmt+0x43>
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004b6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004bd:	e9 55 ff ff ff       	jmp    800417 <vprintfmt+0x43>
			lflag++;
  8004c2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c9:	e9 49 ff ff ff       	jmp    800417 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8d 78 04             	lea    0x4(%eax),%edi
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	53                   	push   %ebx
  8004d8:	ff 30                	pushl  (%eax)
  8004da:	ff d6                	call   *%esi
			break;
  8004dc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004df:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004e2:	e9 33 03 00 00       	jmp    80081a <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8d 78 04             	lea    0x4(%eax),%edi
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	99                   	cltd   
  8004f0:	31 d0                	xor    %edx,%eax
  8004f2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f4:	83 f8 11             	cmp    $0x11,%eax
  8004f7:	7f 23                	jg     80051c <vprintfmt+0x148>
  8004f9:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  800500:	85 d2                	test   %edx,%edx
  800502:	74 18                	je     80051c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800504:	52                   	push   %edx
  800505:	68 7d 31 80 00       	push   $0x80317d
  80050a:	53                   	push   %ebx
  80050b:	56                   	push   %esi
  80050c:	e8 a6 fe ff ff       	call   8003b7 <printfmt>
  800511:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800514:	89 7d 14             	mov    %edi,0x14(%ebp)
  800517:	e9 fe 02 00 00       	jmp    80081a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80051c:	50                   	push   %eax
  80051d:	68 2b 2d 80 00       	push   $0x802d2b
  800522:	53                   	push   %ebx
  800523:	56                   	push   %esi
  800524:	e8 8e fe ff ff       	call   8003b7 <printfmt>
  800529:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052f:	e9 e6 02 00 00       	jmp    80081a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	83 c0 04             	add    $0x4,%eax
  80053a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800542:	85 c9                	test   %ecx,%ecx
  800544:	b8 24 2d 80 00       	mov    $0x802d24,%eax
  800549:	0f 45 c1             	cmovne %ecx,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80054f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800553:	7e 06                	jle    80055b <vprintfmt+0x187>
  800555:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800559:	75 0d                	jne    800568 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055e:	89 c7                	mov    %eax,%edi
  800560:	03 45 e0             	add    -0x20(%ebp),%eax
  800563:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800566:	eb 53                	jmp    8005bb <vprintfmt+0x1e7>
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 d8             	pushl  -0x28(%ebp)
  80056e:	50                   	push   %eax
  80056f:	e8 71 04 00 00       	call   8009e5 <strnlen>
  800574:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800577:	29 c1                	sub    %eax,%ecx
  800579:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800581:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800585:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800588:	eb 0f                	jmp    800599 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	53                   	push   %ebx
  80058e:	ff 75 e0             	pushl  -0x20(%ebp)
  800591:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 ef 01             	sub    $0x1,%edi
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	85 ff                	test   %edi,%edi
  80059b:	7f ed                	jg     80058a <vprintfmt+0x1b6>
  80059d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005a0:	85 c9                	test   %ecx,%ecx
  8005a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a7:	0f 49 c1             	cmovns %ecx,%eax
  8005aa:	29 c1                	sub    %eax,%ecx
  8005ac:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005af:	eb aa                	jmp    80055b <vprintfmt+0x187>
					putch(ch, putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	52                   	push   %edx
  8005b6:	ff d6                	call   *%esi
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005be:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c0:	83 c7 01             	add    $0x1,%edi
  8005c3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c7:	0f be d0             	movsbl %al,%edx
  8005ca:	85 d2                	test   %edx,%edx
  8005cc:	74 4b                	je     800619 <vprintfmt+0x245>
  8005ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d2:	78 06                	js     8005da <vprintfmt+0x206>
  8005d4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d8:	78 1e                	js     8005f8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005da:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005de:	74 d1                	je     8005b1 <vprintfmt+0x1dd>
  8005e0:	0f be c0             	movsbl %al,%eax
  8005e3:	83 e8 20             	sub    $0x20,%eax
  8005e6:	83 f8 5e             	cmp    $0x5e,%eax
  8005e9:	76 c6                	jbe    8005b1 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 3f                	push   $0x3f
  8005f1:	ff d6                	call   *%esi
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	eb c3                	jmp    8005bb <vprintfmt+0x1e7>
  8005f8:	89 cf                	mov    %ecx,%edi
  8005fa:	eb 0e                	jmp    80060a <vprintfmt+0x236>
				putch(' ', putdat);
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 20                	push   $0x20
  800602:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800604:	83 ef 01             	sub    $0x1,%edi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	85 ff                	test   %edi,%edi
  80060c:	7f ee                	jg     8005fc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80060e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	e9 01 02 00 00       	jmp    80081a <vprintfmt+0x446>
  800619:	89 cf                	mov    %ecx,%edi
  80061b:	eb ed                	jmp    80060a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80061d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800620:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800627:	e9 eb fd ff ff       	jmp    800417 <vprintfmt+0x43>
	if (lflag >= 2)
  80062c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800630:	7f 21                	jg     800653 <vprintfmt+0x27f>
	else if (lflag)
  800632:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800636:	74 68                	je     8006a0 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800640:	89 c1                	mov    %eax,%ecx
  800642:	c1 f9 1f             	sar    $0x1f,%ecx
  800645:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	eb 17                	jmp    80066a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 50 04             	mov    0x4(%eax),%edx
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80065e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 08             	lea    0x8(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80066a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800670:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800673:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800676:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80067a:	78 3f                	js     8006bb <vprintfmt+0x2e7>
			base = 10;
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800681:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800685:	0f 84 71 01 00 00    	je     8007fc <vprintfmt+0x428>
				putch('+', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 2b                	push   $0x2b
  800691:	ff d6                	call   *%esi
  800693:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800696:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069b:	e9 5c 01 00 00       	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a8:	89 c1                	mov    %eax,%ecx
  8006aa:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ad:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b9:	eb af                	jmp    80066a <vprintfmt+0x296>
				putch('-', putdat);
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 2d                	push   $0x2d
  8006c1:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c9:	f7 d8                	neg    %eax
  8006cb:	83 d2 00             	adc    $0x0,%edx
  8006ce:	f7 da                	neg    %edx
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006de:	e9 19 01 00 00       	jmp    8007fc <vprintfmt+0x428>
	if (lflag >= 2)
  8006e3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e7:	7f 29                	jg     800712 <vprintfmt+0x33e>
	else if (lflag)
  8006e9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ed:	74 44                	je     800733 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800708:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070d:	e9 ea 00 00 00       	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 50 04             	mov    0x4(%eax),%edx
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8d 40 08             	lea    0x8(%eax),%eax
  800726:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800729:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072e:	e9 c9 00 00 00       	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	e9 a6 00 00 00       	jmp    8007fc <vprintfmt+0x428>
			putch('0', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 30                	push   $0x30
  80075c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800765:	7f 26                	jg     80078d <vprintfmt+0x3b9>
	else if (lflag)
  800767:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80076b:	74 3e                	je     8007ab <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800786:	b8 08 00 00 00       	mov    $0x8,%eax
  80078b:	eb 6f                	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 50 04             	mov    0x4(%eax),%edx
  800793:	8b 00                	mov    (%eax),%eax
  800795:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800798:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a9:	eb 51                	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8d 40 04             	lea    0x4(%eax),%eax
  8007c1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c9:	eb 31                	jmp    8007fc <vprintfmt+0x428>
			putch('0', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	6a 30                	push   $0x30
  8007d1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007d3:	83 c4 08             	add    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	6a 78                	push   $0x78
  8007d9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007eb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 40 04             	lea    0x4(%eax),%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800803:	52                   	push   %edx
  800804:	ff 75 e0             	pushl  -0x20(%ebp)
  800807:	50                   	push   %eax
  800808:	ff 75 dc             	pushl  -0x24(%ebp)
  80080b:	ff 75 d8             	pushl  -0x28(%ebp)
  80080e:	89 da                	mov    %ebx,%edx
  800810:	89 f0                	mov    %esi,%eax
  800812:	e8 a4 fa ff ff       	call   8002bb <printnum>
			break;
  800817:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80081a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	83 c7 01             	add    $0x1,%edi
  800820:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800824:	83 f8 25             	cmp    $0x25,%eax
  800827:	0f 84 be fb ff ff    	je     8003eb <vprintfmt+0x17>
			if (ch == '\0')
  80082d:	85 c0                	test   %eax,%eax
  80082f:	0f 84 28 01 00 00    	je     80095d <vprintfmt+0x589>
			putch(ch, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	53                   	push   %ebx
  800839:	50                   	push   %eax
  80083a:	ff d6                	call   *%esi
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	eb dc                	jmp    80081d <vprintfmt+0x449>
	if (lflag >= 2)
  800841:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800845:	7f 26                	jg     80086d <vprintfmt+0x499>
	else if (lflag)
  800847:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80084b:	74 41                	je     80088e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 00                	mov    (%eax),%eax
  800852:	ba 00 00 00 00       	mov    $0x0,%edx
  800857:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8d 40 04             	lea    0x4(%eax),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800866:	b8 10 00 00 00       	mov    $0x10,%eax
  80086b:	eb 8f                	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8b 50 04             	mov    0x4(%eax),%edx
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800878:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8d 40 08             	lea    0x8(%eax),%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800884:	b8 10 00 00 00       	mov    $0x10,%eax
  800889:	e9 6e ff ff ff       	jmp    8007fc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 40 04             	lea    0x4(%eax),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ac:	e9 4b ff ff ff       	jmp    8007fc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	74 14                	je     8008d7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008c3:	8b 13                	mov    (%ebx),%edx
  8008c5:	83 fa 7f             	cmp    $0x7f,%edx
  8008c8:	7f 37                	jg     800901 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008ca:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d2:	e9 43 ff ff ff       	jmp    80081a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008dc:	bf 49 2e 80 00       	mov    $0x802e49,%edi
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
  8008f4:	75 eb                	jne    8008e1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	e9 19 ff ff ff       	jmp    80081a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800901:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800903:	b8 0a 00 00 00       	mov    $0xa,%eax
  800908:	bf 81 2e 80 00       	mov    $0x802e81,%edi
							putch(ch, putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	50                   	push   %eax
  800912:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800914:	83 c7 01             	add    $0x1,%edi
  800917:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	85 c0                	test   %eax,%eax
  800920:	75 eb                	jne    80090d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800922:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
  800928:	e9 ed fe ff ff       	jmp    80081a <vprintfmt+0x446>
			putch(ch, putdat);
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	53                   	push   %ebx
  800931:	6a 25                	push   $0x25
  800933:	ff d6                	call   *%esi
			break;
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	e9 dd fe ff ff       	jmp    80081a <vprintfmt+0x446>
			putch('%', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	53                   	push   %ebx
  800941:	6a 25                	push   $0x25
  800943:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	89 f8                	mov    %edi,%eax
  80094a:	eb 03                	jmp    80094f <vprintfmt+0x57b>
  80094c:	83 e8 01             	sub    $0x1,%eax
  80094f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800953:	75 f7                	jne    80094c <vprintfmt+0x578>
  800955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800958:	e9 bd fe ff ff       	jmp    80081a <vprintfmt+0x446>
}
  80095d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800960:	5b                   	pop    %ebx
  800961:	5e                   	pop    %esi
  800962:	5f                   	pop    %edi
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 18             	sub    $0x18,%esp
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800971:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800974:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800978:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80097b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800982:	85 c0                	test   %eax,%eax
  800984:	74 26                	je     8009ac <vsnprintf+0x47>
  800986:	85 d2                	test   %edx,%edx
  800988:	7e 22                	jle    8009ac <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098a:	ff 75 14             	pushl  0x14(%ebp)
  80098d:	ff 75 10             	pushl  0x10(%ebp)
  800990:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800993:	50                   	push   %eax
  800994:	68 9a 03 80 00       	push   $0x80039a
  800999:	e8 36 fa ff ff       	call   8003d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80099e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    
		return -E_INVAL;
  8009ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009b1:	eb f7                	jmp    8009aa <vsnprintf+0x45>

008009b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009bc:	50                   	push   %eax
  8009bd:	ff 75 10             	pushl  0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 9a ff ff ff       	call   800965 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009dc:	74 05                	je     8009e3 <strlen+0x16>
		n++;
  8009de:	83 c0 01             	add    $0x1,%eax
  8009e1:	eb f5                	jmp    8009d8 <strlen+0xb>
	return n;
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	39 c2                	cmp    %eax,%edx
  8009f5:	74 0d                	je     800a04 <strnlen+0x1f>
  8009f7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009fb:	74 05                	je     800a02 <strnlen+0x1d>
		n++;
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	eb f1                	jmp    8009f3 <strnlen+0xe>
  800a02:	89 d0                	mov    %edx,%eax
	return n;
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
  800a15:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a19:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	84 c9                	test   %cl,%cl
  800a21:	75 f2                	jne    800a15 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a23:	5b                   	pop    %ebx
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	83 ec 10             	sub    $0x10,%esp
  800a2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a30:	53                   	push   %ebx
  800a31:	e8 97 ff ff ff       	call   8009cd <strlen>
  800a36:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	01 d8                	add    %ebx,%eax
  800a3e:	50                   	push   %eax
  800a3f:	e8 c2 ff ff ff       	call   800a06 <strcpy>
	return dst;
}
  800a44:	89 d8                	mov    %ebx,%eax
  800a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	56                   	push   %esi
  800a4f:	53                   	push   %ebx
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a56:	89 c6                	mov    %eax,%esi
  800a58:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	39 f2                	cmp    %esi,%edx
  800a5f:	74 11                	je     800a72 <strncpy+0x27>
		*dst++ = *src;
  800a61:	83 c2 01             	add    $0x1,%edx
  800a64:	0f b6 19             	movzbl (%ecx),%ebx
  800a67:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a6a:	80 fb 01             	cmp    $0x1,%bl
  800a6d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a70:	eb eb                	jmp    800a5d <strncpy+0x12>
	}
	return ret;
}
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	56                   	push   %esi
  800a7a:	53                   	push   %ebx
  800a7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a81:	8b 55 10             	mov    0x10(%ebp),%edx
  800a84:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a86:	85 d2                	test   %edx,%edx
  800a88:	74 21                	je     800aab <strlcpy+0x35>
  800a8a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a8e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a90:	39 c2                	cmp    %eax,%edx
  800a92:	74 14                	je     800aa8 <strlcpy+0x32>
  800a94:	0f b6 19             	movzbl (%ecx),%ebx
  800a97:	84 db                	test   %bl,%bl
  800a99:	74 0b                	je     800aa6 <strlcpy+0x30>
			*dst++ = *src++;
  800a9b:	83 c1 01             	add    $0x1,%ecx
  800a9e:	83 c2 01             	add    $0x1,%edx
  800aa1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aa4:	eb ea                	jmp    800a90 <strlcpy+0x1a>
  800aa6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aa8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aab:	29 f0                	sub    %esi,%eax
}
  800aad:	5b                   	pop    %ebx
  800aae:	5e                   	pop    %esi
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aba:	0f b6 01             	movzbl (%ecx),%eax
  800abd:	84 c0                	test   %al,%al
  800abf:	74 0c                	je     800acd <strcmp+0x1c>
  800ac1:	3a 02                	cmp    (%edx),%al
  800ac3:	75 08                	jne    800acd <strcmp+0x1c>
		p++, q++;
  800ac5:	83 c1 01             	add    $0x1,%ecx
  800ac8:	83 c2 01             	add    $0x1,%edx
  800acb:	eb ed                	jmp    800aba <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800acd:	0f b6 c0             	movzbl %al,%eax
  800ad0:	0f b6 12             	movzbl (%edx),%edx
  800ad3:	29 d0                	sub    %edx,%eax
}
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	53                   	push   %ebx
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae1:	89 c3                	mov    %eax,%ebx
  800ae3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ae6:	eb 06                	jmp    800aee <strncmp+0x17>
		n--, p++, q++;
  800ae8:	83 c0 01             	add    $0x1,%eax
  800aeb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aee:	39 d8                	cmp    %ebx,%eax
  800af0:	74 16                	je     800b08 <strncmp+0x31>
  800af2:	0f b6 08             	movzbl (%eax),%ecx
  800af5:	84 c9                	test   %cl,%cl
  800af7:	74 04                	je     800afd <strncmp+0x26>
  800af9:	3a 0a                	cmp    (%edx),%cl
  800afb:	74 eb                	je     800ae8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800afd:	0f b6 00             	movzbl (%eax),%eax
  800b00:	0f b6 12             	movzbl (%edx),%edx
  800b03:	29 d0                	sub    %edx,%eax
}
  800b05:	5b                   	pop    %ebx
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    
		return 0;
  800b08:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0d:	eb f6                	jmp    800b05 <strncmp+0x2e>

00800b0f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b19:	0f b6 10             	movzbl (%eax),%edx
  800b1c:	84 d2                	test   %dl,%dl
  800b1e:	74 09                	je     800b29 <strchr+0x1a>
		if (*s == c)
  800b20:	38 ca                	cmp    %cl,%dl
  800b22:	74 0a                	je     800b2e <strchr+0x1f>
	for (; *s; s++)
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	eb f0                	jmp    800b19 <strchr+0xa>
			return (char *) s;
	return 0;
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b3d:	38 ca                	cmp    %cl,%dl
  800b3f:	74 09                	je     800b4a <strfind+0x1a>
  800b41:	84 d2                	test   %dl,%dl
  800b43:	74 05                	je     800b4a <strfind+0x1a>
	for (; *s; s++)
  800b45:	83 c0 01             	add    $0x1,%eax
  800b48:	eb f0                	jmp    800b3a <strfind+0xa>
			break;
	return (char *) s;
}
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b58:	85 c9                	test   %ecx,%ecx
  800b5a:	74 31                	je     800b8d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b5c:	89 f8                	mov    %edi,%eax
  800b5e:	09 c8                	or     %ecx,%eax
  800b60:	a8 03                	test   $0x3,%al
  800b62:	75 23                	jne    800b87 <memset+0x3b>
		c &= 0xFF;
  800b64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b68:	89 d3                	mov    %edx,%ebx
  800b6a:	c1 e3 08             	shl    $0x8,%ebx
  800b6d:	89 d0                	mov    %edx,%eax
  800b6f:	c1 e0 18             	shl    $0x18,%eax
  800b72:	89 d6                	mov    %edx,%esi
  800b74:	c1 e6 10             	shl    $0x10,%esi
  800b77:	09 f0                	or     %esi,%eax
  800b79:	09 c2                	or     %eax,%edx
  800b7b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b7d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b80:	89 d0                	mov    %edx,%eax
  800b82:	fc                   	cld    
  800b83:	f3 ab                	rep stos %eax,%es:(%edi)
  800b85:	eb 06                	jmp    800b8d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8a:	fc                   	cld    
  800b8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b8d:	89 f8                	mov    %edi,%eax
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ba2:	39 c6                	cmp    %eax,%esi
  800ba4:	73 32                	jae    800bd8 <memmove+0x44>
  800ba6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	76 2b                	jbe    800bd8 <memmove+0x44>
		s += n;
		d += n;
  800bad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb0:	89 fe                	mov    %edi,%esi
  800bb2:	09 ce                	or     %ecx,%esi
  800bb4:	09 d6                	or     %edx,%esi
  800bb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bbc:	75 0e                	jne    800bcc <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bbe:	83 ef 04             	sub    $0x4,%edi
  800bc1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bc7:	fd                   	std    
  800bc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bca:	eb 09                	jmp    800bd5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bcc:	83 ef 01             	sub    $0x1,%edi
  800bcf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bd2:	fd                   	std    
  800bd3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd5:	fc                   	cld    
  800bd6:	eb 1a                	jmp    800bf2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd8:	89 c2                	mov    %eax,%edx
  800bda:	09 ca                	or     %ecx,%edx
  800bdc:	09 f2                	or     %esi,%edx
  800bde:	f6 c2 03             	test   $0x3,%dl
  800be1:	75 0a                	jne    800bed <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800be3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800be6:	89 c7                	mov    %eax,%edi
  800be8:	fc                   	cld    
  800be9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800beb:	eb 05                	jmp    800bf2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bed:	89 c7                	mov    %eax,%edi
  800bef:	fc                   	cld    
  800bf0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bfc:	ff 75 10             	pushl  0x10(%ebp)
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	ff 75 08             	pushl  0x8(%ebp)
  800c05:	e8 8a ff ff ff       	call   800b94 <memmove>
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c17:	89 c6                	mov    %eax,%esi
  800c19:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1c:	39 f0                	cmp    %esi,%eax
  800c1e:	74 1c                	je     800c3c <memcmp+0x30>
		if (*s1 != *s2)
  800c20:	0f b6 08             	movzbl (%eax),%ecx
  800c23:	0f b6 1a             	movzbl (%edx),%ebx
  800c26:	38 d9                	cmp    %bl,%cl
  800c28:	75 08                	jne    800c32 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	83 c2 01             	add    $0x1,%edx
  800c30:	eb ea                	jmp    800c1c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c32:	0f b6 c1             	movzbl %cl,%eax
  800c35:	0f b6 db             	movzbl %bl,%ebx
  800c38:	29 d8                	sub    %ebx,%eax
  800c3a:	eb 05                	jmp    800c41 <memcmp+0x35>
	}

	return 0;
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c4e:	89 c2                	mov    %eax,%edx
  800c50:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c53:	39 d0                	cmp    %edx,%eax
  800c55:	73 09                	jae    800c60 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c57:	38 08                	cmp    %cl,(%eax)
  800c59:	74 05                	je     800c60 <memfind+0x1b>
	for (; s < ends; s++)
  800c5b:	83 c0 01             	add    $0x1,%eax
  800c5e:	eb f3                	jmp    800c53 <memfind+0xe>
			break;
	return (void *) s;
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6e:	eb 03                	jmp    800c73 <strtol+0x11>
		s++;
  800c70:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c73:	0f b6 01             	movzbl (%ecx),%eax
  800c76:	3c 20                	cmp    $0x20,%al
  800c78:	74 f6                	je     800c70 <strtol+0xe>
  800c7a:	3c 09                	cmp    $0x9,%al
  800c7c:	74 f2                	je     800c70 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c7e:	3c 2b                	cmp    $0x2b,%al
  800c80:	74 2a                	je     800cac <strtol+0x4a>
	int neg = 0;
  800c82:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c87:	3c 2d                	cmp    $0x2d,%al
  800c89:	74 2b                	je     800cb6 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c91:	75 0f                	jne    800ca2 <strtol+0x40>
  800c93:	80 39 30             	cmpb   $0x30,(%ecx)
  800c96:	74 28                	je     800cc0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c98:	85 db                	test   %ebx,%ebx
  800c9a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9f:	0f 44 d8             	cmove  %eax,%ebx
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800caa:	eb 50                	jmp    800cfc <strtol+0x9a>
		s++;
  800cac:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800caf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb4:	eb d5                	jmp    800c8b <strtol+0x29>
		s++, neg = 1;
  800cb6:	83 c1 01             	add    $0x1,%ecx
  800cb9:	bf 01 00 00 00       	mov    $0x1,%edi
  800cbe:	eb cb                	jmp    800c8b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cc4:	74 0e                	je     800cd4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cc6:	85 db                	test   %ebx,%ebx
  800cc8:	75 d8                	jne    800ca2 <strtol+0x40>
		s++, base = 8;
  800cca:	83 c1 01             	add    $0x1,%ecx
  800ccd:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cd2:	eb ce                	jmp    800ca2 <strtol+0x40>
		s += 2, base = 16;
  800cd4:	83 c1 02             	add    $0x2,%ecx
  800cd7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cdc:	eb c4                	jmp    800ca2 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cde:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ce1:	89 f3                	mov    %esi,%ebx
  800ce3:	80 fb 19             	cmp    $0x19,%bl
  800ce6:	77 29                	ja     800d11 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ce8:	0f be d2             	movsbl %dl,%edx
  800ceb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cee:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cf1:	7d 30                	jge    800d23 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cf3:	83 c1 01             	add    $0x1,%ecx
  800cf6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cfa:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cfc:	0f b6 11             	movzbl (%ecx),%edx
  800cff:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d02:	89 f3                	mov    %esi,%ebx
  800d04:	80 fb 09             	cmp    $0x9,%bl
  800d07:	77 d5                	ja     800cde <strtol+0x7c>
			dig = *s - '0';
  800d09:	0f be d2             	movsbl %dl,%edx
  800d0c:	83 ea 30             	sub    $0x30,%edx
  800d0f:	eb dd                	jmp    800cee <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d11:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d14:	89 f3                	mov    %esi,%ebx
  800d16:	80 fb 19             	cmp    $0x19,%bl
  800d19:	77 08                	ja     800d23 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d1b:	0f be d2             	movsbl %dl,%edx
  800d1e:	83 ea 37             	sub    $0x37,%edx
  800d21:	eb cb                	jmp    800cee <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d27:	74 05                	je     800d2e <strtol+0xcc>
		*endptr = (char *) s;
  800d29:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d2e:	89 c2                	mov    %eax,%edx
  800d30:	f7 da                	neg    %edx
  800d32:	85 ff                	test   %edi,%edi
  800d34:	0f 45 c2             	cmovne %edx,%eax
}
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4d:	89 c3                	mov    %eax,%ebx
  800d4f:	89 c7                	mov    %eax,%edi
  800d51:	89 c6                	mov    %eax,%esi
  800d53:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	b8 01 00 00 00       	mov    $0x1,%eax
  800d6a:	89 d1                	mov    %edx,%ecx
  800d6c:	89 d3                	mov    %edx,%ebx
  800d6e:	89 d7                	mov    %edx,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	57                   	push   %edi
  800d7d:	56                   	push   %esi
  800d7e:	53                   	push   %ebx
  800d7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8f:	89 cb                	mov    %ecx,%ebx
  800d91:	89 cf                	mov    %ecx,%edi
  800d93:	89 ce                	mov    %ecx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 03                	push   $0x3
  800da9:	68 a8 30 80 00       	push   $0x8030a8
  800dae:	6a 43                	push   $0x43
  800db0:	68 c5 30 80 00       	push   $0x8030c5
  800db5:	e8 f7 f3 ff ff       	call   8001b1 <_panic>

00800dba <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	b8 02 00 00 00       	mov    $0x2,%eax
  800dca:	89 d1                	mov    %edx,%ecx
  800dcc:	89 d3                	mov    %edx,%ebx
  800dce:	89 d7                	mov    %edx,%edi
  800dd0:	89 d6                	mov    %edx,%esi
  800dd2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_yield>:

void
sys_yield(void)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  800de4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de9:	89 d1                	mov    %edx,%ecx
  800deb:	89 d3                	mov    %edx,%ebx
  800ded:	89 d7                	mov    %edx,%edi
  800def:	89 d6                	mov    %edx,%esi
  800df1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	be 00 00 00 00       	mov    $0x0,%esi
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	b8 04 00 00 00       	mov    $0x4,%eax
  800e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e14:	89 f7                	mov    %esi,%edi
  800e16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7f 08                	jg     800e24 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e24:	83 ec 0c             	sub    $0xc,%esp
  800e27:	50                   	push   %eax
  800e28:	6a 04                	push   $0x4
  800e2a:	68 a8 30 80 00       	push   $0x8030a8
  800e2f:	6a 43                	push   $0x43
  800e31:	68 c5 30 80 00       	push   $0x8030c5
  800e36:	e8 76 f3 ff ff       	call   8001b1 <_panic>

00800e3b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e55:	8b 75 18             	mov    0x18(%ebp),%esi
  800e58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7f 08                	jg     800e66 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	50                   	push   %eax
  800e6a:	6a 05                	push   $0x5
  800e6c:	68 a8 30 80 00       	push   $0x8030a8
  800e71:	6a 43                	push   $0x43
  800e73:	68 c5 30 80 00       	push   $0x8030c5
  800e78:	e8 34 f3 ff ff       	call   8001b1 <_panic>

00800e7d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	b8 06 00 00 00       	mov    $0x6,%eax
  800e96:	89 df                	mov    %ebx,%edi
  800e98:	89 de                	mov    %ebx,%esi
  800e9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7f 08                	jg     800ea8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5f                   	pop    %edi
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	50                   	push   %eax
  800eac:	6a 06                	push   $0x6
  800eae:	68 a8 30 80 00       	push   $0x8030a8
  800eb3:	6a 43                	push   $0x43
  800eb5:	68 c5 30 80 00       	push   $0x8030c5
  800eba:	e8 f2 f2 ff ff       	call   8001b1 <_panic>

00800ebf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
  800ec5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed8:	89 df                	mov    %ebx,%edi
  800eda:	89 de                	mov    %ebx,%esi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 08                	push   $0x8
  800ef0:	68 a8 30 80 00       	push   $0x8030a8
  800ef5:	6a 43                	push   $0x43
  800ef7:	68 c5 30 80 00       	push   $0x8030c5
  800efc:	e8 b0 f2 ff ff       	call   8001b1 <_panic>

00800f01 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
  800f07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f15:	b8 09 00 00 00       	mov    $0x9,%eax
  800f1a:	89 df                	mov    %ebx,%edi
  800f1c:	89 de                	mov    %ebx,%esi
  800f1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7f 08                	jg     800f2c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	50                   	push   %eax
  800f30:	6a 09                	push   $0x9
  800f32:	68 a8 30 80 00       	push   $0x8030a8
  800f37:	6a 43                	push   $0x43
  800f39:	68 c5 30 80 00       	push   $0x8030c5
  800f3e:	e8 6e f2 ff ff       	call   8001b1 <_panic>

00800f43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7f 08                	jg     800f6e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	50                   	push   %eax
  800f72:	6a 0a                	push   $0xa
  800f74:	68 a8 30 80 00       	push   $0x8030a8
  800f79:	6a 43                	push   $0x43
  800f7b:	68 c5 30 80 00       	push   $0x8030c5
  800f80:	e8 2c f2 ff ff       	call   8001b1 <_panic>

00800f85 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f96:	be 00 00 00 00       	mov    $0x0,%esi
  800f9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fbe:	89 cb                	mov    %ecx,%ebx
  800fc0:	89 cf                	mov    %ecx,%edi
  800fc2:	89 ce                	mov    %ecx,%esi
  800fc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7f 08                	jg     800fd2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd2:	83 ec 0c             	sub    $0xc,%esp
  800fd5:	50                   	push   %eax
  800fd6:	6a 0d                	push   $0xd
  800fd8:	68 a8 30 80 00       	push   $0x8030a8
  800fdd:	6a 43                	push   $0x43
  800fdf:	68 c5 30 80 00       	push   $0x8030c5
  800fe4:	e8 c8 f1 ff ff       	call   8001b1 <_panic>

00800fe9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fff:	89 df                	mov    %ebx,%edi
  801001:	89 de                	mov    %ebx,%esi
  801003:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801010:	b9 00 00 00 00       	mov    $0x0,%ecx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	b8 0f 00 00 00       	mov    $0xf,%eax
  80101d:	89 cb                	mov    %ecx,%ebx
  80101f:	89 cf                	mov    %ecx,%edi
  801021:	89 ce                	mov    %ecx,%esi
  801023:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	ba 00 00 00 00       	mov    $0x0,%edx
  801035:	b8 10 00 00 00       	mov    $0x10,%eax
  80103a:	89 d1                	mov    %edx,%ecx
  80103c:	89 d3                	mov    %edx,%ebx
  80103e:	89 d7                	mov    %edx,%edi
  801040:	89 d6                	mov    %edx,%esi
  801042:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 11 00 00 00       	mov    $0x11,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801070:	bb 00 00 00 00       	mov    $0x0,%ebx
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107b:	b8 12 00 00 00       	mov    $0x12,%eax
  801080:	89 df                	mov    %ebx,%edi
  801082:	89 de                	mov    %ebx,%esi
  801084:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801094:	bb 00 00 00 00       	mov    $0x0,%ebx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	b8 13 00 00 00       	mov    $0x13,%eax
  8010a4:	89 df                	mov    %ebx,%edi
  8010a6:	89 de                	mov    %ebx,%esi
  8010a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	7f 08                	jg     8010b6 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	50                   	push   %eax
  8010ba:	6a 13                	push   $0x13
  8010bc:	68 a8 30 80 00       	push   $0x8030a8
  8010c1:	6a 43                	push   $0x43
  8010c3:	68 c5 30 80 00       	push   $0x8030c5
  8010c8:	e8 e4 f0 ff ff       	call   8001b1 <_panic>

008010cd <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	57                   	push   %edi
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	b8 14 00 00 00       	mov    $0x14,%eax
  8010e0:	89 cb                	mov    %ecx,%ebx
  8010e2:	89 cf                	mov    %ecx,%edi
  8010e4:	89 ce                	mov    %ecx,%esi
  8010e6:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5f                   	pop    %edi
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	05 00 00 00 30       	add    $0x30000000,%eax
  8010f8:	c1 e8 0c             	shr    $0xc,%eax
}
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80110d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80111c:	89 c2                	mov    %eax,%edx
  80111e:	c1 ea 16             	shr    $0x16,%edx
  801121:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801128:	f6 c2 01             	test   $0x1,%dl
  80112b:	74 2d                	je     80115a <fd_alloc+0x46>
  80112d:	89 c2                	mov    %eax,%edx
  80112f:	c1 ea 0c             	shr    $0xc,%edx
  801132:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801139:	f6 c2 01             	test   $0x1,%dl
  80113c:	74 1c                	je     80115a <fd_alloc+0x46>
  80113e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801143:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801148:	75 d2                	jne    80111c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801153:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801158:	eb 0a                	jmp    801164 <fd_alloc+0x50>
			*fd_store = fd;
  80115a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80116c:	83 f8 1f             	cmp    $0x1f,%eax
  80116f:	77 30                	ja     8011a1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801171:	c1 e0 0c             	shl    $0xc,%eax
  801174:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801179:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	74 24                	je     8011a8 <fd_lookup+0x42>
  801184:	89 c2                	mov    %eax,%edx
  801186:	c1 ea 0c             	shr    $0xc,%edx
  801189:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801190:	f6 c2 01             	test   $0x1,%dl
  801193:	74 1a                	je     8011af <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801195:	8b 55 0c             	mov    0xc(%ebp),%edx
  801198:	89 02                	mov    %eax,(%edx)
	return 0;
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    
		return -E_INVAL;
  8011a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a6:	eb f7                	jmp    80119f <fd_lookup+0x39>
		return -E_INVAL;
  8011a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ad:	eb f0                	jmp    80119f <fd_lookup+0x39>
  8011af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b4:	eb e9                	jmp    80119f <fd_lookup+0x39>

008011b6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c4:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011c9:	39 08                	cmp    %ecx,(%eax)
  8011cb:	74 38                	je     801205 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011cd:	83 c2 01             	add    $0x1,%edx
  8011d0:	8b 04 95 50 31 80 00 	mov    0x803150(,%edx,4),%eax
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	75 ee                	jne    8011c9 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011db:	a1 08 50 80 00       	mov    0x805008,%eax
  8011e0:	8b 40 48             	mov    0x48(%eax),%eax
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	51                   	push   %ecx
  8011e7:	50                   	push   %eax
  8011e8:	68 d4 30 80 00       	push   $0x8030d4
  8011ed:	e8 b5 f0 ff ff       	call   8002a7 <cprintf>
	*dev = 0;
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011fb:	83 c4 10             	add    $0x10,%esp
  8011fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    
			*dev = devtab[i];
  801205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801208:	89 01                	mov    %eax,(%ecx)
			return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
  80120f:	eb f2                	jmp    801203 <dev_lookup+0x4d>

00801211 <fd_close>:
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 24             	sub    $0x24,%esp
  80121a:	8b 75 08             	mov    0x8(%ebp),%esi
  80121d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801220:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801223:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801224:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80122a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80122d:	50                   	push   %eax
  80122e:	e8 33 ff ff ff       	call   801166 <fd_lookup>
  801233:	89 c3                	mov    %eax,%ebx
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 05                	js     801241 <fd_close+0x30>
	    || fd != fd2)
  80123c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80123f:	74 16                	je     801257 <fd_close+0x46>
		return (must_exist ? r : 0);
  801241:	89 f8                	mov    %edi,%eax
  801243:	84 c0                	test   %al,%al
  801245:	b8 00 00 00 00       	mov    $0x0,%eax
  80124a:	0f 44 d8             	cmove  %eax,%ebx
}
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801252:	5b                   	pop    %ebx
  801253:	5e                   	pop    %esi
  801254:	5f                   	pop    %edi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80125d:	50                   	push   %eax
  80125e:	ff 36                	pushl  (%esi)
  801260:	e8 51 ff ff ff       	call   8011b6 <dev_lookup>
  801265:	89 c3                	mov    %eax,%ebx
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 1a                	js     801288 <fd_close+0x77>
		if (dev->dev_close)
  80126e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801271:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801274:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801279:	85 c0                	test   %eax,%eax
  80127b:	74 0b                	je     801288 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	56                   	push   %esi
  801281:	ff d0                	call   *%eax
  801283:	89 c3                	mov    %eax,%ebx
  801285:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	56                   	push   %esi
  80128c:	6a 00                	push   $0x0
  80128e:	e8 ea fb ff ff       	call   800e7d <sys_page_unmap>
	return r;
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	eb b5                	jmp    80124d <fd_close+0x3c>

00801298 <close>:

int
close(int fdnum)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80129e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a1:	50                   	push   %eax
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	e8 bc fe ff ff       	call   801166 <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	79 02                	jns    8012b3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    
		return fd_close(fd, 1);
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	6a 01                	push   $0x1
  8012b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8012bb:	e8 51 ff ff ff       	call   801211 <fd_close>
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	eb ec                	jmp    8012b1 <close+0x19>

008012c5 <close_all>:

void
close_all(void)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012cc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	53                   	push   %ebx
  8012d5:	e8 be ff ff ff       	call   801298 <close>
	for (i = 0; i < MAXFD; i++)
  8012da:	83 c3 01             	add    $0x1,%ebx
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	83 fb 20             	cmp    $0x20,%ebx
  8012e3:	75 ec                	jne    8012d1 <close_all+0xc>
}
  8012e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	57                   	push   %edi
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f6:	50                   	push   %eax
  8012f7:	ff 75 08             	pushl  0x8(%ebp)
  8012fa:	e8 67 fe ff ff       	call   801166 <fd_lookup>
  8012ff:	89 c3                	mov    %eax,%ebx
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	0f 88 81 00 00 00    	js     80138d <dup+0xa3>
		return r;
	close(newfdnum);
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	e8 81 ff ff ff       	call   801298 <close>

	newfd = INDEX2FD(newfdnum);
  801317:	8b 75 0c             	mov    0xc(%ebp),%esi
  80131a:	c1 e6 0c             	shl    $0xc,%esi
  80131d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801323:	83 c4 04             	add    $0x4,%esp
  801326:	ff 75 e4             	pushl  -0x1c(%ebp)
  801329:	e8 cf fd ff ff       	call   8010fd <fd2data>
  80132e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801330:	89 34 24             	mov    %esi,(%esp)
  801333:	e8 c5 fd ff ff       	call   8010fd <fd2data>
  801338:	83 c4 10             	add    $0x10,%esp
  80133b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80133d:	89 d8                	mov    %ebx,%eax
  80133f:	c1 e8 16             	shr    $0x16,%eax
  801342:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801349:	a8 01                	test   $0x1,%al
  80134b:	74 11                	je     80135e <dup+0x74>
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	c1 e8 0c             	shr    $0xc,%eax
  801352:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801359:	f6 c2 01             	test   $0x1,%dl
  80135c:	75 39                	jne    801397 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80135e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801361:	89 d0                	mov    %edx,%eax
  801363:	c1 e8 0c             	shr    $0xc,%eax
  801366:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80136d:	83 ec 0c             	sub    $0xc,%esp
  801370:	25 07 0e 00 00       	and    $0xe07,%eax
  801375:	50                   	push   %eax
  801376:	56                   	push   %esi
  801377:	6a 00                	push   $0x0
  801379:	52                   	push   %edx
  80137a:	6a 00                	push   $0x0
  80137c:	e8 ba fa ff ff       	call   800e3b <sys_page_map>
  801381:	89 c3                	mov    %eax,%ebx
  801383:	83 c4 20             	add    $0x20,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 31                	js     8013bb <dup+0xd1>
		goto err;

	return newfdnum;
  80138a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80138d:	89 d8                	mov    %ebx,%eax
  80138f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801397:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a6:	50                   	push   %eax
  8013a7:	57                   	push   %edi
  8013a8:	6a 00                	push   $0x0
  8013aa:	53                   	push   %ebx
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 89 fa ff ff       	call   800e3b <sys_page_map>
  8013b2:	89 c3                	mov    %eax,%ebx
  8013b4:	83 c4 20             	add    $0x20,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	79 a3                	jns    80135e <dup+0x74>
	sys_page_unmap(0, newfd);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	56                   	push   %esi
  8013bf:	6a 00                	push   $0x0
  8013c1:	e8 b7 fa ff ff       	call   800e7d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013c6:	83 c4 08             	add    $0x8,%esp
  8013c9:	57                   	push   %edi
  8013ca:	6a 00                	push   $0x0
  8013cc:	e8 ac fa ff ff       	call   800e7d <sys_page_unmap>
	return r;
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	eb b7                	jmp    80138d <dup+0xa3>

008013d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	53                   	push   %ebx
  8013da:	83 ec 1c             	sub    $0x1c,%esp
  8013dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e3:	50                   	push   %eax
  8013e4:	53                   	push   %ebx
  8013e5:	e8 7c fd ff ff       	call   801166 <fd_lookup>
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	78 3f                	js     801430 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f1:	83 ec 08             	sub    $0x8,%esp
  8013f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fb:	ff 30                	pushl  (%eax)
  8013fd:	e8 b4 fd ff ff       	call   8011b6 <dev_lookup>
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 27                	js     801430 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801409:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80140c:	8b 42 08             	mov    0x8(%edx),%eax
  80140f:	83 e0 03             	and    $0x3,%eax
  801412:	83 f8 01             	cmp    $0x1,%eax
  801415:	74 1e                	je     801435 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141a:	8b 40 08             	mov    0x8(%eax),%eax
  80141d:	85 c0                	test   %eax,%eax
  80141f:	74 35                	je     801456 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	ff 75 10             	pushl  0x10(%ebp)
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	52                   	push   %edx
  80142b:	ff d0                	call   *%eax
  80142d:	83 c4 10             	add    $0x10,%esp
}
  801430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801433:	c9                   	leave  
  801434:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801435:	a1 08 50 80 00       	mov    0x805008,%eax
  80143a:	8b 40 48             	mov    0x48(%eax),%eax
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	53                   	push   %ebx
  801441:	50                   	push   %eax
  801442:	68 15 31 80 00       	push   $0x803115
  801447:	e8 5b ee ff ff       	call   8002a7 <cprintf>
		return -E_INVAL;
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801454:	eb da                	jmp    801430 <read+0x5a>
		return -E_NOT_SUPP;
  801456:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145b:	eb d3                	jmp    801430 <read+0x5a>

0080145d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	57                   	push   %edi
  801461:	56                   	push   %esi
  801462:	53                   	push   %ebx
  801463:	83 ec 0c             	sub    $0xc,%esp
  801466:	8b 7d 08             	mov    0x8(%ebp),%edi
  801469:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80146c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801471:	39 f3                	cmp    %esi,%ebx
  801473:	73 23                	jae    801498 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	89 f0                	mov    %esi,%eax
  80147a:	29 d8                	sub    %ebx,%eax
  80147c:	50                   	push   %eax
  80147d:	89 d8                	mov    %ebx,%eax
  80147f:	03 45 0c             	add    0xc(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	57                   	push   %edi
  801484:	e8 4d ff ff ff       	call   8013d6 <read>
		if (m < 0)
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 06                	js     801496 <readn+0x39>
			return m;
		if (m == 0)
  801490:	74 06                	je     801498 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801492:	01 c3                	add    %eax,%ebx
  801494:	eb db                	jmp    801471 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801496:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801498:	89 d8                	mov    %ebx,%eax
  80149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149d:	5b                   	pop    %ebx
  80149e:	5e                   	pop    %esi
  80149f:	5f                   	pop    %edi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 1c             	sub    $0x1c,%esp
  8014a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014af:	50                   	push   %eax
  8014b0:	53                   	push   %ebx
  8014b1:	e8 b0 fc ff ff       	call   801166 <fd_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 3a                	js     8014f7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	ff 30                	pushl  (%eax)
  8014c9:	e8 e8 fc ff ff       	call   8011b6 <dev_lookup>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 22                	js     8014f7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014dc:	74 1e                	je     8014fc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e1:	8b 52 0c             	mov    0xc(%edx),%edx
  8014e4:	85 d2                	test   %edx,%edx
  8014e6:	74 35                	je     80151d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	ff 75 10             	pushl  0x10(%ebp)
  8014ee:	ff 75 0c             	pushl  0xc(%ebp)
  8014f1:	50                   	push   %eax
  8014f2:	ff d2                	call   *%edx
  8014f4:	83 c4 10             	add    $0x10,%esp
}
  8014f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014fc:	a1 08 50 80 00       	mov    0x805008,%eax
  801501:	8b 40 48             	mov    0x48(%eax),%eax
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	53                   	push   %ebx
  801508:	50                   	push   %eax
  801509:	68 31 31 80 00       	push   $0x803131
  80150e:	e8 94 ed ff ff       	call   8002a7 <cprintf>
		return -E_INVAL;
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151b:	eb da                	jmp    8014f7 <write+0x55>
		return -E_NOT_SUPP;
  80151d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801522:	eb d3                	jmp    8014f7 <write+0x55>

00801524 <seek>:

int
seek(int fdnum, off_t offset)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152d:	50                   	push   %eax
  80152e:	ff 75 08             	pushl  0x8(%ebp)
  801531:	e8 30 fc ff ff       	call   801166 <fd_lookup>
  801536:	83 c4 10             	add    $0x10,%esp
  801539:	85 c0                	test   %eax,%eax
  80153b:	78 0e                	js     80154b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80153d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	53                   	push   %ebx
  801551:	83 ec 1c             	sub    $0x1c,%esp
  801554:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801557:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155a:	50                   	push   %eax
  80155b:	53                   	push   %ebx
  80155c:	e8 05 fc ff ff       	call   801166 <fd_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 37                	js     80159f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156e:	50                   	push   %eax
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	ff 30                	pushl  (%eax)
  801574:	e8 3d fc ff ff       	call   8011b6 <dev_lookup>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 1f                	js     80159f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801583:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801587:	74 1b                	je     8015a4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158c:	8b 52 18             	mov    0x18(%edx),%edx
  80158f:	85 d2                	test   %edx,%edx
  801591:	74 32                	je     8015c5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	ff 75 0c             	pushl  0xc(%ebp)
  801599:	50                   	push   %eax
  80159a:	ff d2                	call   *%edx
  80159c:	83 c4 10             	add    $0x10,%esp
}
  80159f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015a4:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a9:	8b 40 48             	mov    0x48(%eax),%eax
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	53                   	push   %ebx
  8015b0:	50                   	push   %eax
  8015b1:	68 f4 30 80 00       	push   $0x8030f4
  8015b6:	e8 ec ec ff ff       	call   8002a7 <cprintf>
		return -E_INVAL;
  8015bb:	83 c4 10             	add    $0x10,%esp
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c3:	eb da                	jmp    80159f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ca:	eb d3                	jmp    80159f <ftruncate+0x52>

008015cc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 1c             	sub    $0x1c,%esp
  8015d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	e8 84 fb ff ff       	call   801166 <fd_lookup>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 4b                	js     801634 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ef:	50                   	push   %eax
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	ff 30                	pushl  (%eax)
  8015f5:	e8 bc fb ff ff       	call   8011b6 <dev_lookup>
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	78 33                	js     801634 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801604:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801608:	74 2f                	je     801639 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80160a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80160d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801614:	00 00 00 
	stat->st_isdir = 0;
  801617:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80161e:	00 00 00 
	stat->st_dev = dev;
  801621:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	53                   	push   %ebx
  80162b:	ff 75 f0             	pushl  -0x10(%ebp)
  80162e:	ff 50 14             	call   *0x14(%eax)
  801631:	83 c4 10             	add    $0x10,%esp
}
  801634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801637:	c9                   	leave  
  801638:	c3                   	ret    
		return -E_NOT_SUPP;
  801639:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163e:	eb f4                	jmp    801634 <fstat+0x68>

00801640 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	6a 00                	push   $0x0
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	e8 22 02 00 00       	call   801874 <open>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 1b                	js     801676 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	50                   	push   %eax
  801662:	e8 65 ff ff ff       	call   8015cc <fstat>
  801667:	89 c6                	mov    %eax,%esi
	close(fd);
  801669:	89 1c 24             	mov    %ebx,(%esp)
  80166c:	e8 27 fc ff ff       	call   801298 <close>
	return r;
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	89 f3                	mov    %esi,%ebx
}
  801676:	89 d8                	mov    %ebx,%eax
  801678:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	89 c6                	mov    %eax,%esi
  801686:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801688:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80168f:	74 27                	je     8016b8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801691:	6a 07                	push   $0x7
  801693:	68 00 60 80 00       	push   $0x806000
  801698:	56                   	push   %esi
  801699:	ff 35 00 50 80 00    	pushl  0x805000
  80169f:	e8 25 12 00 00       	call   8028c9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016a4:	83 c4 0c             	add    $0xc,%esp
  8016a7:	6a 00                	push   $0x0
  8016a9:	53                   	push   %ebx
  8016aa:	6a 00                	push   $0x0
  8016ac:	e8 af 11 00 00       	call   802860 <ipc_recv>
}
  8016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5d                   	pop    %ebp
  8016b7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	6a 01                	push   $0x1
  8016bd:	e8 5f 12 00 00       	call   802921 <ipc_find_env>
  8016c2:	a3 00 50 80 00       	mov    %eax,0x805000
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	eb c5                	jmp    801691 <fsipc+0x12>

008016cc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ef:	e8 8b ff ff ff       	call   80167f <fsipc>
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <devfile_flush>:
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801702:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801707:	ba 00 00 00 00       	mov    $0x0,%edx
  80170c:	b8 06 00 00 00       	mov    $0x6,%eax
  801711:	e8 69 ff ff ff       	call   80167f <fsipc>
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <devfile_stat>:
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	53                   	push   %ebx
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8b 40 0c             	mov    0xc(%eax),%eax
  801728:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80172d:	ba 00 00 00 00       	mov    $0x0,%edx
  801732:	b8 05 00 00 00       	mov    $0x5,%eax
  801737:	e8 43 ff ff ff       	call   80167f <fsipc>
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 2c                	js     80176c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	68 00 60 80 00       	push   $0x806000
  801748:	53                   	push   %ebx
  801749:	e8 b8 f2 ff ff       	call   800a06 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80174e:	a1 80 60 80 00       	mov    0x806080,%eax
  801753:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801759:	a1 84 60 80 00       	mov    0x806084,%eax
  80175e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <devfile_write>:
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	53                   	push   %ebx
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	8b 40 0c             	mov    0xc(%eax),%eax
  801781:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801786:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80178c:	53                   	push   %ebx
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	68 08 60 80 00       	push   $0x806008
  801795:	e8 5c f4 ff ff       	call   800bf6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80179a:	ba 00 00 00 00       	mov    $0x0,%edx
  80179f:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a4:	e8 d6 fe ff ff       	call   80167f <fsipc>
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 0b                	js     8017bb <devfile_write+0x4a>
	assert(r <= n);
  8017b0:	39 d8                	cmp    %ebx,%eax
  8017b2:	77 0c                	ja     8017c0 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017b4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b9:	7f 1e                	jg     8017d9 <devfile_write+0x68>
}
  8017bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    
	assert(r <= n);
  8017c0:	68 64 31 80 00       	push   $0x803164
  8017c5:	68 6b 31 80 00       	push   $0x80316b
  8017ca:	68 98 00 00 00       	push   $0x98
  8017cf:	68 80 31 80 00       	push   $0x803180
  8017d4:	e8 d8 e9 ff ff       	call   8001b1 <_panic>
	assert(r <= PGSIZE);
  8017d9:	68 8b 31 80 00       	push   $0x80318b
  8017de:	68 6b 31 80 00       	push   $0x80316b
  8017e3:	68 99 00 00 00       	push   $0x99
  8017e8:	68 80 31 80 00       	push   $0x803180
  8017ed:	e8 bf e9 ff ff       	call   8001b1 <_panic>

008017f2 <devfile_read>:
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801800:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801805:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80180b:	ba 00 00 00 00       	mov    $0x0,%edx
  801810:	b8 03 00 00 00       	mov    $0x3,%eax
  801815:	e8 65 fe ff ff       	call   80167f <fsipc>
  80181a:	89 c3                	mov    %eax,%ebx
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 1f                	js     80183f <devfile_read+0x4d>
	assert(r <= n);
  801820:	39 f0                	cmp    %esi,%eax
  801822:	77 24                	ja     801848 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801824:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801829:	7f 33                	jg     80185e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	50                   	push   %eax
  80182f:	68 00 60 80 00       	push   $0x806000
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	e8 58 f3 ff ff       	call   800b94 <memmove>
	return r;
  80183c:	83 c4 10             	add    $0x10,%esp
}
  80183f:	89 d8                	mov    %ebx,%eax
  801841:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801844:	5b                   	pop    %ebx
  801845:	5e                   	pop    %esi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    
	assert(r <= n);
  801848:	68 64 31 80 00       	push   $0x803164
  80184d:	68 6b 31 80 00       	push   $0x80316b
  801852:	6a 7c                	push   $0x7c
  801854:	68 80 31 80 00       	push   $0x803180
  801859:	e8 53 e9 ff ff       	call   8001b1 <_panic>
	assert(r <= PGSIZE);
  80185e:	68 8b 31 80 00       	push   $0x80318b
  801863:	68 6b 31 80 00       	push   $0x80316b
  801868:	6a 7d                	push   $0x7d
  80186a:	68 80 31 80 00       	push   $0x803180
  80186f:	e8 3d e9 ff ff       	call   8001b1 <_panic>

00801874 <open>:
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	56                   	push   %esi
  801878:	53                   	push   %ebx
  801879:	83 ec 1c             	sub    $0x1c,%esp
  80187c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80187f:	56                   	push   %esi
  801880:	e8 48 f1 ff ff       	call   8009cd <strlen>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80188d:	7f 6c                	jg     8018fb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80188f:	83 ec 0c             	sub    $0xc,%esp
  801892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801895:	50                   	push   %eax
  801896:	e8 79 f8 ff ff       	call   801114 <fd_alloc>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 3c                	js     8018e0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018a4:	83 ec 08             	sub    $0x8,%esp
  8018a7:	56                   	push   %esi
  8018a8:	68 00 60 80 00       	push   $0x806000
  8018ad:	e8 54 f1 ff ff       	call   800a06 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c2:	e8 b8 fd ff ff       	call   80167f <fsipc>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 19                	js     8018e9 <open+0x75>
	return fd2num(fd);
  8018d0:	83 ec 0c             	sub    $0xc,%esp
  8018d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d6:	e8 12 f8 ff ff       	call   8010ed <fd2num>
  8018db:	89 c3                	mov    %eax,%ebx
  8018dd:	83 c4 10             	add    $0x10,%esp
}
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    
		fd_close(fd, 0);
  8018e9:	83 ec 08             	sub    $0x8,%esp
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f1:	e8 1b f9 ff ff       	call   801211 <fd_close>
		return r;
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	eb e5                	jmp    8018e0 <open+0x6c>
		return -E_BAD_PATH;
  8018fb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801900:	eb de                	jmp    8018e0 <open+0x6c>

00801902 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
  80190d:	b8 08 00 00 00       	mov    $0x8,%eax
  801912:	e8 68 fd ff ff       	call   80167f <fsipc>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	57                   	push   %edi
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801925:	68 70 32 80 00       	push   $0x803270
  80192a:	68 d9 2c 80 00       	push   $0x802cd9
  80192f:	e8 73 e9 ff ff       	call   8002a7 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801934:	83 c4 08             	add    $0x8,%esp
  801937:	6a 00                	push   $0x0
  801939:	ff 75 08             	pushl  0x8(%ebp)
  80193c:	e8 33 ff ff ff       	call   801874 <open>
  801941:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	85 c0                	test   %eax,%eax
  80194c:	0f 88 0b 05 00 00    	js     801e5d <spawn+0x544>
  801952:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	68 00 02 00 00       	push   $0x200
  80195c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801962:	50                   	push   %eax
  801963:	51                   	push   %ecx
  801964:	e8 f4 fa ff ff       	call   80145d <readn>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	3d 00 02 00 00       	cmp    $0x200,%eax
  801971:	75 75                	jne    8019e8 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801973:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80197a:	45 4c 46 
  80197d:	75 69                	jne    8019e8 <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80197f:	b8 07 00 00 00       	mov    $0x7,%eax
  801984:	cd 30                	int    $0x30
  801986:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80198c:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801992:	85 c0                	test   %eax,%eax
  801994:	0f 88 b7 04 00 00    	js     801e51 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80199a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80199f:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  8019a5:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8019ab:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8019b1:	b9 11 00 00 00       	mov    $0x11,%ecx
  8019b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8019b8:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8019be:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	68 64 32 80 00       	push   $0x803264
  8019cc:	68 d9 2c 80 00       	push   $0x802cd9
  8019d1:	e8 d1 e8 ff ff       	call   8002a7 <cprintf>
  8019d6:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019d9:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019de:	be 00 00 00 00       	mov    $0x0,%esi
  8019e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019e6:	eb 4b                	jmp    801a33 <spawn+0x11a>
		close(fd);
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019f1:	e8 a2 f8 ff ff       	call   801298 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019f6:	83 c4 0c             	add    $0xc,%esp
  8019f9:	68 7f 45 4c 46       	push   $0x464c457f
  8019fe:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a04:	68 97 31 80 00       	push   $0x803197
  801a09:	e8 99 e8 ff ff       	call   8002a7 <cprintf>
		return -E_NOT_EXEC;
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801a18:	ff ff ff 
  801a1b:	e9 3d 04 00 00       	jmp    801e5d <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801a20:	83 ec 0c             	sub    $0xc,%esp
  801a23:	50                   	push   %eax
  801a24:	e8 a4 ef ff ff       	call   8009cd <strlen>
  801a29:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a2d:	83 c3 01             	add    $0x1,%ebx
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a3a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	75 df                	jne    801a20 <spawn+0x107>
  801a41:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a47:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a4d:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a52:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a54:	89 fa                	mov    %edi,%edx
  801a56:	83 e2 fc             	and    $0xfffffffc,%edx
  801a59:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a60:	29 c2                	sub    %eax,%edx
  801a62:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a68:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a6b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a70:	0f 86 0a 04 00 00    	jbe    801e80 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	6a 07                	push   $0x7
  801a7b:	68 00 00 40 00       	push   $0x400000
  801a80:	6a 00                	push   $0x0
  801a82:	e8 71 f3 ff ff       	call   800df8 <sys_page_alloc>
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	0f 88 f3 03 00 00    	js     801e85 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a92:	be 00 00 00 00       	mov    $0x0,%esi
  801a97:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801aa0:	eb 30                	jmp    801ad2 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801aa2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801aa8:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801aae:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ab7:	57                   	push   %edi
  801ab8:	e8 49 ef ff ff       	call   800a06 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801abd:	83 c4 04             	add    $0x4,%esp
  801ac0:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801ac3:	e8 05 ef ff ff       	call   8009cd <strlen>
  801ac8:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801acc:	83 c6 01             	add    $0x1,%esi
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801ad8:	7f c8                	jg     801aa2 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801ada:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ae0:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ae6:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801aed:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801af3:	0f 85 86 00 00 00    	jne    801b7f <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801af9:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801aff:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801b05:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b08:	89 d0                	mov    %edx,%eax
  801b0a:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801b10:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b13:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b18:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b1e:	83 ec 0c             	sub    $0xc,%esp
  801b21:	6a 07                	push   $0x7
  801b23:	68 00 d0 bf ee       	push   $0xeebfd000
  801b28:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b2e:	68 00 00 40 00       	push   $0x400000
  801b33:	6a 00                	push   $0x0
  801b35:	e8 01 f3 ff ff       	call   800e3b <sys_page_map>
  801b3a:	89 c3                	mov    %eax,%ebx
  801b3c:	83 c4 20             	add    $0x20,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	0f 88 46 03 00 00    	js     801e8d <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b47:	83 ec 08             	sub    $0x8,%esp
  801b4a:	68 00 00 40 00       	push   $0x400000
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 27 f3 ff ff       	call   800e7d <sys_page_unmap>
  801b56:	89 c3                	mov    %eax,%ebx
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	0f 88 2a 03 00 00    	js     801e8d <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b63:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b69:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b70:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b77:	00 00 00 
  801b7a:	e9 4f 01 00 00       	jmp    801cce <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b7f:	68 20 32 80 00       	push   $0x803220
  801b84:	68 6b 31 80 00       	push   $0x80316b
  801b89:	68 f8 00 00 00       	push   $0xf8
  801b8e:	68 b1 31 80 00       	push   $0x8031b1
  801b93:	e8 19 e6 ff ff       	call   8001b1 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	6a 07                	push   $0x7
  801b9d:	68 00 00 40 00       	push   $0x400000
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 4f f2 ff ff       	call   800df8 <sys_page_alloc>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	0f 88 b7 02 00 00    	js     801e6b <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801bb4:	83 ec 08             	sub    $0x8,%esp
  801bb7:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801bbd:	01 f0                	add    %esi,%eax
  801bbf:	50                   	push   %eax
  801bc0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bc6:	e8 59 f9 ff ff       	call   801524 <seek>
  801bcb:	83 c4 10             	add    $0x10,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	0f 88 9c 02 00 00    	js     801e72 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bdf:	29 f0                	sub    %esi,%eax
  801be1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801be6:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801beb:	0f 47 c1             	cmova  %ecx,%eax
  801bee:	50                   	push   %eax
  801bef:	68 00 00 40 00       	push   $0x400000
  801bf4:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bfa:	e8 5e f8 ff ff       	call   80145d <readn>
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	85 c0                	test   %eax,%eax
  801c04:	0f 88 6f 02 00 00    	js     801e79 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c13:	53                   	push   %ebx
  801c14:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c1a:	68 00 00 40 00       	push   $0x400000
  801c1f:	6a 00                	push   $0x0
  801c21:	e8 15 f2 ff ff       	call   800e3b <sys_page_map>
  801c26:	83 c4 20             	add    $0x20,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 7c                	js     801ca9 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	68 00 00 40 00       	push   $0x400000
  801c35:	6a 00                	push   $0x0
  801c37:	e8 41 f2 ff ff       	call   800e7d <sys_page_unmap>
  801c3c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c3f:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c4b:	89 fe                	mov    %edi,%esi
  801c4d:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c53:	76 69                	jbe    801cbe <spawn+0x3a5>
		if (i >= filesz) {
  801c55:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c5b:	0f 87 37 ff ff ff    	ja     801b98 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c6a:	53                   	push   %ebx
  801c6b:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c71:	e8 82 f1 ff ff       	call   800df8 <sys_page_alloc>
  801c76:	83 c4 10             	add    $0x10,%esp
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	79 c2                	jns    801c3f <spawn+0x326>
  801c7d:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c7f:	83 ec 0c             	sub    $0xc,%esp
  801c82:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c88:	e8 ec f0 ff ff       	call   800d79 <sys_env_destroy>
	close(fd);
  801c8d:	83 c4 04             	add    $0x4,%esp
  801c90:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c96:	e8 fd f5 ff ff       	call   801298 <close>
	return r;
  801c9b:	83 c4 10             	add    $0x10,%esp
  801c9e:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801ca4:	e9 b4 01 00 00       	jmp    801e5d <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  801ca9:	50                   	push   %eax
  801caa:	68 bd 31 80 00       	push   $0x8031bd
  801caf:	68 2b 01 00 00       	push   $0x12b
  801cb4:	68 b1 31 80 00       	push   $0x8031b1
  801cb9:	e8 f3 e4 ff ff       	call   8001b1 <_panic>
  801cbe:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cc4:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ccb:	83 c6 20             	add    $0x20,%esi
  801cce:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cd5:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801cdb:	7e 6d                	jle    801d4a <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801cdd:	83 3e 01             	cmpl   $0x1,(%esi)
  801ce0:	75 e2                	jne    801cc4 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ce2:	8b 46 18             	mov    0x18(%esi),%eax
  801ce5:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ce8:	83 f8 01             	cmp    $0x1,%eax
  801ceb:	19 c0                	sbb    %eax,%eax
  801ced:	83 e0 fe             	and    $0xfffffffe,%eax
  801cf0:	83 c0 07             	add    $0x7,%eax
  801cf3:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cf9:	8b 4e 04             	mov    0x4(%esi),%ecx
  801cfc:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d02:	8b 56 10             	mov    0x10(%esi),%edx
  801d05:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d0b:	8b 7e 14             	mov    0x14(%esi),%edi
  801d0e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801d14:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801d17:	89 d8                	mov    %ebx,%eax
  801d19:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d1e:	74 1a                	je     801d3a <spawn+0x421>
		va -= i;
  801d20:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d22:	01 c7                	add    %eax,%edi
  801d24:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d2a:	01 c2                	add    %eax,%edx
  801d2c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801d32:	29 c1                	sub    %eax,%ecx
  801d34:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3f:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801d45:	e9 01 ff ff ff       	jmp    801c4b <spawn+0x332>
	close(fd);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d53:	e8 40 f5 ff ff       	call   801298 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801d58:	83 c4 08             	add    $0x8,%esp
  801d5b:	68 50 32 80 00       	push   $0x803250
  801d60:	68 d9 2c 80 00       	push   $0x802cd9
  801d65:	e8 3d e5 ff ff       	call   8002a7 <cprintf>
  801d6a:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801d6d:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801d72:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d78:	eb 0e                	jmp    801d88 <spawn+0x46f>
  801d7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d80:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d86:	74 5e                	je     801de6 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801d88:	89 d8                	mov    %ebx,%eax
  801d8a:	c1 e8 16             	shr    $0x16,%eax
  801d8d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d94:	a8 01                	test   $0x1,%al
  801d96:	74 e2                	je     801d7a <spawn+0x461>
  801d98:	89 da                	mov    %ebx,%edx
  801d9a:	c1 ea 0c             	shr    $0xc,%edx
  801d9d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801da4:	25 05 04 00 00       	and    $0x405,%eax
  801da9:	3d 05 04 00 00       	cmp    $0x405,%eax
  801dae:	75 ca                	jne    801d7a <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801db0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	25 07 0e 00 00       	and    $0xe07,%eax
  801dbf:	50                   	push   %eax
  801dc0:	53                   	push   %ebx
  801dc1:	56                   	push   %esi
  801dc2:	53                   	push   %ebx
  801dc3:	6a 00                	push   $0x0
  801dc5:	e8 71 f0 ff ff       	call   800e3b <sys_page_map>
  801dca:	83 c4 20             	add    $0x20,%esp
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	79 a9                	jns    801d7a <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  801dd1:	50                   	push   %eax
  801dd2:	68 da 31 80 00       	push   $0x8031da
  801dd7:	68 3b 01 00 00       	push   $0x13b
  801ddc:	68 b1 31 80 00       	push   $0x8031b1
  801de1:	e8 cb e3 ff ff       	call   8001b1 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801de6:	83 ec 08             	sub    $0x8,%esp
  801de9:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801def:	50                   	push   %eax
  801df0:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801df6:	e8 06 f1 ff ff       	call   800f01 <sys_env_set_trapframe>
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 25                	js     801e27 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e02:	83 ec 08             	sub    $0x8,%esp
  801e05:	6a 02                	push   $0x2
  801e07:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e0d:	e8 ad f0 ff ff       	call   800ebf <sys_env_set_status>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 23                	js     801e3c <spawn+0x523>
	return child;
  801e19:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e1f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e25:	eb 36                	jmp    801e5d <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  801e27:	50                   	push   %eax
  801e28:	68 ec 31 80 00       	push   $0x8031ec
  801e2d:	68 8a 00 00 00       	push   $0x8a
  801e32:	68 b1 31 80 00       	push   $0x8031b1
  801e37:	e8 75 e3 ff ff       	call   8001b1 <_panic>
		panic("sys_env_set_status: %e", r);
  801e3c:	50                   	push   %eax
  801e3d:	68 06 32 80 00       	push   $0x803206
  801e42:	68 8d 00 00 00       	push   $0x8d
  801e47:	68 b1 31 80 00       	push   $0x8031b1
  801e4c:	e8 60 e3 ff ff       	call   8001b1 <_panic>
		return r;
  801e51:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e57:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e5d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e66:	5b                   	pop    %ebx
  801e67:	5e                   	pop    %esi
  801e68:	5f                   	pop    %edi
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    
  801e6b:	89 c7                	mov    %eax,%edi
  801e6d:	e9 0d fe ff ff       	jmp    801c7f <spawn+0x366>
  801e72:	89 c7                	mov    %eax,%edi
  801e74:	e9 06 fe ff ff       	jmp    801c7f <spawn+0x366>
  801e79:	89 c7                	mov    %eax,%edi
  801e7b:	e9 ff fd ff ff       	jmp    801c7f <spawn+0x366>
		return -E_NO_MEM;
  801e80:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801e85:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e8b:	eb d0                	jmp    801e5d <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  801e8d:	83 ec 08             	sub    $0x8,%esp
  801e90:	68 00 00 40 00       	push   $0x400000
  801e95:	6a 00                	push   $0x0
  801e97:	e8 e1 ef ff ff       	call   800e7d <sys_page_unmap>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801ea5:	eb b6                	jmp    801e5d <spawn+0x544>

00801ea7 <spawnl>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	57                   	push   %edi
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801eb0:	68 48 32 80 00       	push   $0x803248
  801eb5:	68 d9 2c 80 00       	push   $0x802cd9
  801eba:	e8 e8 e3 ff ff       	call   8002a7 <cprintf>
	va_start(vl, arg0);
  801ebf:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801ec2:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801eca:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ecd:	83 3a 00             	cmpl   $0x0,(%edx)
  801ed0:	74 07                	je     801ed9 <spawnl+0x32>
		argc++;
  801ed2:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801ed5:	89 ca                	mov    %ecx,%edx
  801ed7:	eb f1                	jmp    801eca <spawnl+0x23>
	const char *argv[argc+2];
  801ed9:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801ee0:	83 e2 f0             	and    $0xfffffff0,%edx
  801ee3:	29 d4                	sub    %edx,%esp
  801ee5:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ee9:	c1 ea 02             	shr    $0x2,%edx
  801eec:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ef3:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef8:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801eff:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f06:	00 
	va_start(vl, arg0);
  801f07:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f0a:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb 0b                	jmp    801f1e <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801f13:	83 c0 01             	add    $0x1,%eax
  801f16:	8b 39                	mov    (%ecx),%edi
  801f18:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f1b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f1e:	39 d0                	cmp    %edx,%eax
  801f20:	75 f1                	jne    801f13 <spawnl+0x6c>
	return spawn(prog, argv);
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	56                   	push   %esi
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	e8 eb f9 ff ff       	call   801919 <spawn>
}
  801f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    

00801f36 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f3c:	68 76 32 80 00       	push   $0x803276
  801f41:	ff 75 0c             	pushl  0xc(%ebp)
  801f44:	e8 bd ea ff ff       	call   800a06 <strcpy>
	return 0;
}
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <devsock_close>:
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	53                   	push   %ebx
  801f54:	83 ec 10             	sub    $0x10,%esp
  801f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f5a:	53                   	push   %ebx
  801f5b:	e8 00 0a 00 00       	call   802960 <pageref>
  801f60:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f63:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f68:	83 f8 01             	cmp    $0x1,%eax
  801f6b:	74 07                	je     801f74 <devsock_close+0x24>
}
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 73 0c             	pushl  0xc(%ebx)
  801f7a:	e8 b9 02 00 00       	call   802238 <nsipc_close>
  801f7f:	89 c2                	mov    %eax,%edx
  801f81:	83 c4 10             	add    $0x10,%esp
  801f84:	eb e7                	jmp    801f6d <devsock_close+0x1d>

00801f86 <devsock_write>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	ff 75 10             	pushl  0x10(%ebp)
  801f91:	ff 75 0c             	pushl  0xc(%ebp)
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	ff 70 0c             	pushl  0xc(%eax)
  801f9a:	e8 76 03 00 00       	call   802315 <nsipc_send>
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <devsock_read>:
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	ff 75 10             	pushl  0x10(%ebp)
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	ff 70 0c             	pushl  0xc(%eax)
  801fb5:	e8 ef 02 00 00       	call   8022a9 <nsipc_recv>
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <fd2sockid>:
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fc2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	e8 9a f1 ff ff       	call   801166 <fd_lookup>
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	78 10                	js     801fe3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fdc:	39 08                	cmp    %ecx,(%eax)
  801fde:	75 05                	jne    801fe5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fe0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    
		return -E_NOT_SUPP;
  801fe5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fea:	eb f7                	jmp    801fe3 <fd2sockid+0x27>

00801fec <alloc_sockfd>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 1c             	sub    $0x1c,%esp
  801ff4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ff6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff9:	50                   	push   %eax
  801ffa:	e8 15 f1 ff ff       	call   801114 <fd_alloc>
  801fff:	89 c3                	mov    %eax,%ebx
  802001:	83 c4 10             	add    $0x10,%esp
  802004:	85 c0                	test   %eax,%eax
  802006:	78 43                	js     80204b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	68 07 04 00 00       	push   $0x407
  802010:	ff 75 f4             	pushl  -0xc(%ebp)
  802013:	6a 00                	push   $0x0
  802015:	e8 de ed ff ff       	call   800df8 <sys_page_alloc>
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 28                	js     80204b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80202c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802038:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80203b:	83 ec 0c             	sub    $0xc,%esp
  80203e:	50                   	push   %eax
  80203f:	e8 a9 f0 ff ff       	call   8010ed <fd2num>
  802044:	89 c3                	mov    %eax,%ebx
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	eb 0c                	jmp    802057 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	56                   	push   %esi
  80204f:	e8 e4 01 00 00       	call   802238 <nsipc_close>
		return r;
  802054:	83 c4 10             	add    $0x10,%esp
}
  802057:	89 d8                	mov    %ebx,%eax
  802059:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5e                   	pop    %esi
  80205e:	5d                   	pop    %ebp
  80205f:	c3                   	ret    

00802060 <accept>:
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	e8 4e ff ff ff       	call   801fbc <fd2sockid>
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 1b                	js     80208d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	ff 75 10             	pushl  0x10(%ebp)
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	50                   	push   %eax
  80207c:	e8 0e 01 00 00       	call   80218f <nsipc_accept>
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	85 c0                	test   %eax,%eax
  802086:	78 05                	js     80208d <accept+0x2d>
	return alloc_sockfd(r);
  802088:	e8 5f ff ff ff       	call   801fec <alloc_sockfd>
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <bind>:
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	e8 1f ff ff ff       	call   801fbc <fd2sockid>
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 12                	js     8020b3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	ff 75 10             	pushl  0x10(%ebp)
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	50                   	push   %eax
  8020ab:	e8 31 01 00 00       	call   8021e1 <nsipc_bind>
  8020b0:	83 c4 10             	add    $0x10,%esp
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <shutdown>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	e8 f9 fe ff ff       	call   801fbc <fd2sockid>
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 0f                	js     8020d6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8020c7:	83 ec 08             	sub    $0x8,%esp
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	e8 43 01 00 00       	call   802216 <nsipc_shutdown>
  8020d3:	83 c4 10             	add    $0x10,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <connect>:
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	e8 d6 fe ff ff       	call   801fbc <fd2sockid>
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 12                	js     8020fc <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	ff 75 10             	pushl  0x10(%ebp)
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	50                   	push   %eax
  8020f4:	e8 59 01 00 00       	call   802252 <nsipc_connect>
  8020f9:	83 c4 10             	add    $0x10,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <listen>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	e8 b0 fe ff ff       	call   801fbc <fd2sockid>
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 0f                	js     80211f <listen+0x21>
	return nsipc_listen(r, backlog);
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	50                   	push   %eax
  802117:	e8 6b 01 00 00       	call   802287 <nsipc_listen>
  80211c:	83 c4 10             	add    $0x10,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <socket>:

int
socket(int domain, int type, int protocol)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802127:	ff 75 10             	pushl  0x10(%ebp)
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	e8 3e 02 00 00       	call   802373 <nsipc_socket>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 05                	js     802141 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80213c:	e8 ab fe ff ff       	call   801fec <alloc_sockfd>
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	53                   	push   %ebx
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80214c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802153:	74 26                	je     80217b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802155:	6a 07                	push   $0x7
  802157:	68 00 70 80 00       	push   $0x807000
  80215c:	53                   	push   %ebx
  80215d:	ff 35 04 50 80 00    	pushl  0x805004
  802163:	e8 61 07 00 00       	call   8028c9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802168:	83 c4 0c             	add    $0xc,%esp
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	e8 ea 06 00 00       	call   802860 <ipc_recv>
}
  802176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802179:	c9                   	leave  
  80217a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80217b:	83 ec 0c             	sub    $0xc,%esp
  80217e:	6a 02                	push   $0x2
  802180:	e8 9c 07 00 00       	call   802921 <ipc_find_env>
  802185:	a3 04 50 80 00       	mov    %eax,0x805004
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	eb c6                	jmp    802155 <nsipc+0x12>

0080218f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80219f:	8b 06                	mov    (%esi),%eax
  8021a1:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ab:	e8 93 ff ff ff       	call   802143 <nsipc>
  8021b0:	89 c3                	mov    %eax,%ebx
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	79 09                	jns    8021bf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8021b6:	89 d8                	mov    %ebx,%eax
  8021b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	ff 35 10 70 80 00    	pushl  0x807010
  8021c8:	68 00 70 80 00       	push   $0x807000
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	e8 bf e9 ff ff       	call   800b94 <memmove>
		*addrlen = ret->ret_addrlen;
  8021d5:	a1 10 70 80 00       	mov    0x807010,%eax
  8021da:	89 06                	mov    %eax,(%esi)
  8021dc:	83 c4 10             	add    $0x10,%esp
	return r;
  8021df:	eb d5                	jmp    8021b6 <nsipc_accept+0x27>

008021e1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	53                   	push   %ebx
  8021e5:	83 ec 08             	sub    $0x8,%esp
  8021e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021f3:	53                   	push   %ebx
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	68 04 70 80 00       	push   $0x807004
  8021fc:	e8 93 e9 ff ff       	call   800b94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802201:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802207:	b8 02 00 00 00       	mov    $0x2,%eax
  80220c:	e8 32 ff ff ff       	call   802143 <nsipc>
}
  802211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802224:	8b 45 0c             	mov    0xc(%ebp),%eax
  802227:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80222c:	b8 03 00 00 00       	mov    $0x3,%eax
  802231:	e8 0d ff ff ff       	call   802143 <nsipc>
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <nsipc_close>:

int
nsipc_close(int s)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802246:	b8 04 00 00 00       	mov    $0x4,%eax
  80224b:	e8 f3 fe ff ff       	call   802143 <nsipc>
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	53                   	push   %ebx
  802256:	83 ec 08             	sub    $0x8,%esp
  802259:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802264:	53                   	push   %ebx
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	68 04 70 80 00       	push   $0x807004
  80226d:	e8 22 e9 ff ff       	call   800b94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802272:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802278:	b8 05 00 00 00       	mov    $0x5,%eax
  80227d:	e8 c1 fe ff ff       	call   802143 <nsipc>
}
  802282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80229d:	b8 06 00 00 00       	mov    $0x6,%eax
  8022a2:	e8 9c fe ff ff       	call   802143 <nsipc>
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022b9:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c2:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022c7:	b8 07 00 00 00       	mov    $0x7,%eax
  8022cc:	e8 72 fe ff ff       	call   802143 <nsipc>
  8022d1:	89 c3                	mov    %eax,%ebx
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	78 1f                	js     8022f6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022d7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022dc:	7f 21                	jg     8022ff <nsipc_recv+0x56>
  8022de:	39 c6                	cmp    %eax,%esi
  8022e0:	7c 1d                	jl     8022ff <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	50                   	push   %eax
  8022e6:	68 00 70 80 00       	push   $0x807000
  8022eb:	ff 75 0c             	pushl  0xc(%ebp)
  8022ee:	e8 a1 e8 ff ff       	call   800b94 <memmove>
  8022f3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5d                   	pop    %ebp
  8022fe:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022ff:	68 82 32 80 00       	push   $0x803282
  802304:	68 6b 31 80 00       	push   $0x80316b
  802309:	6a 62                	push   $0x62
  80230b:	68 97 32 80 00       	push   $0x803297
  802310:	e8 9c de ff ff       	call   8001b1 <_panic>

00802315 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	53                   	push   %ebx
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802327:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80232d:	7f 2e                	jg     80235d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	53                   	push   %ebx
  802333:	ff 75 0c             	pushl  0xc(%ebp)
  802336:	68 0c 70 80 00       	push   $0x80700c
  80233b:	e8 54 e8 ff ff       	call   800b94 <memmove>
	nsipcbuf.send.req_size = size;
  802340:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802346:	8b 45 14             	mov    0x14(%ebp),%eax
  802349:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80234e:	b8 08 00 00 00       	mov    $0x8,%eax
  802353:	e8 eb fd ff ff       	call   802143 <nsipc>
}
  802358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    
	assert(size < 1600);
  80235d:	68 a3 32 80 00       	push   $0x8032a3
  802362:	68 6b 31 80 00       	push   $0x80316b
  802367:	6a 6d                	push   $0x6d
  802369:	68 97 32 80 00       	push   $0x803297
  80236e:	e8 3e de ff ff       	call   8001b1 <_panic>

00802373 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802381:	8b 45 0c             	mov    0xc(%ebp),%eax
  802384:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802389:	8b 45 10             	mov    0x10(%ebp),%eax
  80238c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802391:	b8 09 00 00 00       	mov    $0x9,%eax
  802396:	e8 a8 fd ff ff       	call   802143 <nsipc>
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	56                   	push   %esi
  8023a1:	53                   	push   %ebx
  8023a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023a5:	83 ec 0c             	sub    $0xc,%esp
  8023a8:	ff 75 08             	pushl  0x8(%ebp)
  8023ab:	e8 4d ed ff ff       	call   8010fd <fd2data>
  8023b0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023b2:	83 c4 08             	add    $0x8,%esp
  8023b5:	68 af 32 80 00       	push   $0x8032af
  8023ba:	53                   	push   %ebx
  8023bb:	e8 46 e6 ff ff       	call   800a06 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c0:	8b 46 04             	mov    0x4(%esi),%eax
  8023c3:	2b 06                	sub    (%esi),%eax
  8023c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023d2:	00 00 00 
	stat->st_dev = &devpipe;
  8023d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023dc:	40 80 00 
	return 0;
}
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	53                   	push   %ebx
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023f5:	53                   	push   %ebx
  8023f6:	6a 00                	push   $0x0
  8023f8:	e8 80 ea ff ff       	call   800e7d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023fd:	89 1c 24             	mov    %ebx,(%esp)
  802400:	e8 f8 ec ff ff       	call   8010fd <fd2data>
  802405:	83 c4 08             	add    $0x8,%esp
  802408:	50                   	push   %eax
  802409:	6a 00                	push   $0x0
  80240b:	e8 6d ea ff ff       	call   800e7d <sys_page_unmap>
}
  802410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <_pipeisclosed>:
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	57                   	push   %edi
  802419:	56                   	push   %esi
  80241a:	53                   	push   %ebx
  80241b:	83 ec 1c             	sub    $0x1c,%esp
  80241e:	89 c7                	mov    %eax,%edi
  802420:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802422:	a1 08 50 80 00       	mov    0x805008,%eax
  802427:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80242a:	83 ec 0c             	sub    $0xc,%esp
  80242d:	57                   	push   %edi
  80242e:	e8 2d 05 00 00       	call   802960 <pageref>
  802433:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802436:	89 34 24             	mov    %esi,(%esp)
  802439:	e8 22 05 00 00       	call   802960 <pageref>
		nn = thisenv->env_runs;
  80243e:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802444:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	39 cb                	cmp    %ecx,%ebx
  80244c:	74 1b                	je     802469 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80244e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802451:	75 cf                	jne    802422 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802453:	8b 42 58             	mov    0x58(%edx),%eax
  802456:	6a 01                	push   $0x1
  802458:	50                   	push   %eax
  802459:	53                   	push   %ebx
  80245a:	68 b6 32 80 00       	push   $0x8032b6
  80245f:	e8 43 de ff ff       	call   8002a7 <cprintf>
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	eb b9                	jmp    802422 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802469:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80246c:	0f 94 c0             	sete   %al
  80246f:	0f b6 c0             	movzbl %al,%eax
}
  802472:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <devpipe_write>:
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	83 ec 28             	sub    $0x28,%esp
  802483:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802486:	56                   	push   %esi
  802487:	e8 71 ec ff ff       	call   8010fd <fd2data>
  80248c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	bf 00 00 00 00       	mov    $0x0,%edi
  802496:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802499:	74 4f                	je     8024ea <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80249b:	8b 43 04             	mov    0x4(%ebx),%eax
  80249e:	8b 0b                	mov    (%ebx),%ecx
  8024a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024a3:	39 d0                	cmp    %edx,%eax
  8024a5:	72 14                	jb     8024bb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024a7:	89 da                	mov    %ebx,%edx
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	e8 65 ff ff ff       	call   802415 <_pipeisclosed>
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	75 3b                	jne    8024ef <devpipe_write+0x75>
			sys_yield();
  8024b4:	e8 20 e9 ff ff       	call   800dd9 <sys_yield>
  8024b9:	eb e0                	jmp    80249b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024be:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024c2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024c5:	89 c2                	mov    %eax,%edx
  8024c7:	c1 fa 1f             	sar    $0x1f,%edx
  8024ca:	89 d1                	mov    %edx,%ecx
  8024cc:	c1 e9 1b             	shr    $0x1b,%ecx
  8024cf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024d2:	83 e2 1f             	and    $0x1f,%edx
  8024d5:	29 ca                	sub    %ecx,%edx
  8024d7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024df:	83 c0 01             	add    $0x1,%eax
  8024e2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024e5:	83 c7 01             	add    $0x1,%edi
  8024e8:	eb ac                	jmp    802496 <devpipe_write+0x1c>
	return i;
  8024ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ed:	eb 05                	jmp    8024f4 <devpipe_write+0x7a>
				return 0;
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5f                   	pop    %edi
  8024fa:	5d                   	pop    %ebp
  8024fb:	c3                   	ret    

008024fc <devpipe_read>:
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	57                   	push   %edi
  802500:	56                   	push   %esi
  802501:	53                   	push   %ebx
  802502:	83 ec 18             	sub    $0x18,%esp
  802505:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802508:	57                   	push   %edi
  802509:	e8 ef eb ff ff       	call   8010fd <fd2data>
  80250e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802510:	83 c4 10             	add    $0x10,%esp
  802513:	be 00 00 00 00       	mov    $0x0,%esi
  802518:	3b 75 10             	cmp    0x10(%ebp),%esi
  80251b:	75 14                	jne    802531 <devpipe_read+0x35>
	return i;
  80251d:	8b 45 10             	mov    0x10(%ebp),%eax
  802520:	eb 02                	jmp    802524 <devpipe_read+0x28>
				return i;
  802522:	89 f0                	mov    %esi,%eax
}
  802524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802527:	5b                   	pop    %ebx
  802528:	5e                   	pop    %esi
  802529:	5f                   	pop    %edi
  80252a:	5d                   	pop    %ebp
  80252b:	c3                   	ret    
			sys_yield();
  80252c:	e8 a8 e8 ff ff       	call   800dd9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802531:	8b 03                	mov    (%ebx),%eax
  802533:	3b 43 04             	cmp    0x4(%ebx),%eax
  802536:	75 18                	jne    802550 <devpipe_read+0x54>
			if (i > 0)
  802538:	85 f6                	test   %esi,%esi
  80253a:	75 e6                	jne    802522 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80253c:	89 da                	mov    %ebx,%edx
  80253e:	89 f8                	mov    %edi,%eax
  802540:	e8 d0 fe ff ff       	call   802415 <_pipeisclosed>
  802545:	85 c0                	test   %eax,%eax
  802547:	74 e3                	je     80252c <devpipe_read+0x30>
				return 0;
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	eb d4                	jmp    802524 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802550:	99                   	cltd   
  802551:	c1 ea 1b             	shr    $0x1b,%edx
  802554:	01 d0                	add    %edx,%eax
  802556:	83 e0 1f             	and    $0x1f,%eax
  802559:	29 d0                	sub    %edx,%eax
  80255b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802560:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802563:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802566:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802569:	83 c6 01             	add    $0x1,%esi
  80256c:	eb aa                	jmp    802518 <devpipe_read+0x1c>

0080256e <pipe>:
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	56                   	push   %esi
  802572:	53                   	push   %ebx
  802573:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802576:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802579:	50                   	push   %eax
  80257a:	e8 95 eb ff ff       	call   801114 <fd_alloc>
  80257f:	89 c3                	mov    %eax,%ebx
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	85 c0                	test   %eax,%eax
  802586:	0f 88 23 01 00 00    	js     8026af <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 07 04 00 00       	push   $0x407
  802594:	ff 75 f4             	pushl  -0xc(%ebp)
  802597:	6a 00                	push   $0x0
  802599:	e8 5a e8 ff ff       	call   800df8 <sys_page_alloc>
  80259e:	89 c3                	mov    %eax,%ebx
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	0f 88 04 01 00 00    	js     8026af <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b1:	50                   	push   %eax
  8025b2:	e8 5d eb ff ff       	call   801114 <fd_alloc>
  8025b7:	89 c3                	mov    %eax,%ebx
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	0f 88 db 00 00 00    	js     80269f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c4:	83 ec 04             	sub    $0x4,%esp
  8025c7:	68 07 04 00 00       	push   $0x407
  8025cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8025cf:	6a 00                	push   $0x0
  8025d1:	e8 22 e8 ff ff       	call   800df8 <sys_page_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 88 bc 00 00 00    	js     80269f <pipe+0x131>
	va = fd2data(fd0);
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e9:	e8 0f eb ff ff       	call   8010fd <fd2data>
  8025ee:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f0:	83 c4 0c             	add    $0xc,%esp
  8025f3:	68 07 04 00 00       	push   $0x407
  8025f8:	50                   	push   %eax
  8025f9:	6a 00                	push   $0x0
  8025fb:	e8 f8 e7 ff ff       	call   800df8 <sys_page_alloc>
  802600:	89 c3                	mov    %eax,%ebx
  802602:	83 c4 10             	add    $0x10,%esp
  802605:	85 c0                	test   %eax,%eax
  802607:	0f 88 82 00 00 00    	js     80268f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	ff 75 f0             	pushl  -0x10(%ebp)
  802613:	e8 e5 ea ff ff       	call   8010fd <fd2data>
  802618:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80261f:	50                   	push   %eax
  802620:	6a 00                	push   $0x0
  802622:	56                   	push   %esi
  802623:	6a 00                	push   $0x0
  802625:	e8 11 e8 ff ff       	call   800e3b <sys_page_map>
  80262a:	89 c3                	mov    %eax,%ebx
  80262c:	83 c4 20             	add    $0x20,%esp
  80262f:	85 c0                	test   %eax,%eax
  802631:	78 4e                	js     802681 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802633:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802647:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80264a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	ff 75 f4             	pushl  -0xc(%ebp)
  80265c:	e8 8c ea ff ff       	call   8010ed <fd2num>
  802661:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802664:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802666:	83 c4 04             	add    $0x4,%esp
  802669:	ff 75 f0             	pushl  -0x10(%ebp)
  80266c:	e8 7c ea ff ff       	call   8010ed <fd2num>
  802671:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802674:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802677:	83 c4 10             	add    $0x10,%esp
  80267a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80267f:	eb 2e                	jmp    8026af <pipe+0x141>
	sys_page_unmap(0, va);
  802681:	83 ec 08             	sub    $0x8,%esp
  802684:	56                   	push   %esi
  802685:	6a 00                	push   $0x0
  802687:	e8 f1 e7 ff ff       	call   800e7d <sys_page_unmap>
  80268c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80268f:	83 ec 08             	sub    $0x8,%esp
  802692:	ff 75 f0             	pushl  -0x10(%ebp)
  802695:	6a 00                	push   $0x0
  802697:	e8 e1 e7 ff ff       	call   800e7d <sys_page_unmap>
  80269c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80269f:	83 ec 08             	sub    $0x8,%esp
  8026a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a5:	6a 00                	push   $0x0
  8026a7:	e8 d1 e7 ff ff       	call   800e7d <sys_page_unmap>
  8026ac:	83 c4 10             	add    $0x10,%esp
}
  8026af:	89 d8                	mov    %ebx,%eax
  8026b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    

008026b8 <pipeisclosed>:
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c1:	50                   	push   %eax
  8026c2:	ff 75 08             	pushl  0x8(%ebp)
  8026c5:	e8 9c ea ff ff       	call   801166 <fd_lookup>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	78 18                	js     8026e9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d7:	e8 21 ea ff ff       	call   8010fd <fd2data>
	return _pipeisclosed(fd, p);
  8026dc:	89 c2                	mov    %eax,%edx
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	e8 2f fd ff ff       	call   802415 <_pipeisclosed>
  8026e6:	83 c4 10             	add    $0x10,%esp
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f0:	c3                   	ret    

008026f1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026f7:	68 ce 32 80 00       	push   $0x8032ce
  8026fc:	ff 75 0c             	pushl  0xc(%ebp)
  8026ff:	e8 02 e3 ff ff       	call   800a06 <strcpy>
	return 0;
}
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <devcons_write>:
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	57                   	push   %edi
  80270f:	56                   	push   %esi
  802710:	53                   	push   %ebx
  802711:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802717:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80271c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802722:	3b 75 10             	cmp    0x10(%ebp),%esi
  802725:	73 31                	jae    802758 <devcons_write+0x4d>
		m = n - tot;
  802727:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80272a:	29 f3                	sub    %esi,%ebx
  80272c:	83 fb 7f             	cmp    $0x7f,%ebx
  80272f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802734:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802737:	83 ec 04             	sub    $0x4,%esp
  80273a:	53                   	push   %ebx
  80273b:	89 f0                	mov    %esi,%eax
  80273d:	03 45 0c             	add    0xc(%ebp),%eax
  802740:	50                   	push   %eax
  802741:	57                   	push   %edi
  802742:	e8 4d e4 ff ff       	call   800b94 <memmove>
		sys_cputs(buf, m);
  802747:	83 c4 08             	add    $0x8,%esp
  80274a:	53                   	push   %ebx
  80274b:	57                   	push   %edi
  80274c:	e8 eb e5 ff ff       	call   800d3c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802751:	01 de                	add    %ebx,%esi
  802753:	83 c4 10             	add    $0x10,%esp
  802756:	eb ca                	jmp    802722 <devcons_write+0x17>
}
  802758:	89 f0                	mov    %esi,%eax
  80275a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    

00802762 <devcons_read>:
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 08             	sub    $0x8,%esp
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80276d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802771:	74 21                	je     802794 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802773:	e8 e2 e5 ff ff       	call   800d5a <sys_cgetc>
  802778:	85 c0                	test   %eax,%eax
  80277a:	75 07                	jne    802783 <devcons_read+0x21>
		sys_yield();
  80277c:	e8 58 e6 ff ff       	call   800dd9 <sys_yield>
  802781:	eb f0                	jmp    802773 <devcons_read+0x11>
	if (c < 0)
  802783:	78 0f                	js     802794 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802785:	83 f8 04             	cmp    $0x4,%eax
  802788:	74 0c                	je     802796 <devcons_read+0x34>
	*(char*)vbuf = c;
  80278a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278d:	88 02                	mov    %al,(%edx)
	return 1;
  80278f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    
		return 0;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	eb f7                	jmp    802794 <devcons_read+0x32>

0080279d <cputchar>:
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8027a9:	6a 01                	push   $0x1
  8027ab:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ae:	50                   	push   %eax
  8027af:	e8 88 e5 ff ff       	call   800d3c <sys_cputs>
}
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <getchar>:
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
  8027bc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8027bf:	6a 01                	push   $0x1
  8027c1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c4:	50                   	push   %eax
  8027c5:	6a 00                	push   $0x0
  8027c7:	e8 0a ec ff ff       	call   8013d6 <read>
	if (r < 0)
  8027cc:	83 c4 10             	add    $0x10,%esp
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	78 06                	js     8027d9 <getchar+0x20>
	if (r < 1)
  8027d3:	74 06                	je     8027db <getchar+0x22>
	return c;
  8027d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    
		return -E_EOF;
  8027db:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027e0:	eb f7                	jmp    8027d9 <getchar+0x20>

008027e2 <iscons>:
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027eb:	50                   	push   %eax
  8027ec:	ff 75 08             	pushl  0x8(%ebp)
  8027ef:	e8 72 e9 ff ff       	call   801166 <fd_lookup>
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	78 11                	js     80280c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802804:	39 10                	cmp    %edx,(%eax)
  802806:	0f 94 c0             	sete   %al
  802809:	0f b6 c0             	movzbl %al,%eax
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <opencons>:
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802814:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802817:	50                   	push   %eax
  802818:	e8 f7 e8 ff ff       	call   801114 <fd_alloc>
  80281d:	83 c4 10             	add    $0x10,%esp
  802820:	85 c0                	test   %eax,%eax
  802822:	78 3a                	js     80285e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	68 07 04 00 00       	push   $0x407
  80282c:	ff 75 f4             	pushl  -0xc(%ebp)
  80282f:	6a 00                	push   $0x0
  802831:	e8 c2 e5 ff ff       	call   800df8 <sys_page_alloc>
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	85 c0                	test   %eax,%eax
  80283b:	78 21                	js     80285e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802846:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802852:	83 ec 0c             	sub    $0xc,%esp
  802855:	50                   	push   %eax
  802856:	e8 92 e8 ff ff       	call   8010ed <fd2num>
  80285b:	83 c4 10             	add    $0x10,%esp
}
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	56                   	push   %esi
  802864:	53                   	push   %ebx
  802865:	8b 75 08             	mov    0x8(%ebp),%esi
  802868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80286e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802870:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802875:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802878:	83 ec 0c             	sub    $0xc,%esp
  80287b:	50                   	push   %eax
  80287c:	e8 27 e7 ff ff       	call   800fa8 <sys_ipc_recv>
	if(ret < 0){
  802881:	83 c4 10             	add    $0x10,%esp
  802884:	85 c0                	test   %eax,%eax
  802886:	78 2b                	js     8028b3 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802888:	85 f6                	test   %esi,%esi
  80288a:	74 0a                	je     802896 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80288c:	a1 08 50 80 00       	mov    0x805008,%eax
  802891:	8b 40 78             	mov    0x78(%eax),%eax
  802894:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802896:	85 db                	test   %ebx,%ebx
  802898:	74 0a                	je     8028a4 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80289a:	a1 08 50 80 00       	mov    0x805008,%eax
  80289f:	8b 40 7c             	mov    0x7c(%eax),%eax
  8028a2:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8028a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8028a9:	8b 40 74             	mov    0x74(%eax),%eax
}
  8028ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028af:	5b                   	pop    %ebx
  8028b0:	5e                   	pop    %esi
  8028b1:	5d                   	pop    %ebp
  8028b2:	c3                   	ret    
		if(from_env_store)
  8028b3:	85 f6                	test   %esi,%esi
  8028b5:	74 06                	je     8028bd <ipc_recv+0x5d>
			*from_env_store = 0;
  8028b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028bd:	85 db                	test   %ebx,%ebx
  8028bf:	74 eb                	je     8028ac <ipc_recv+0x4c>
			*perm_store = 0;
  8028c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028c7:	eb e3                	jmp    8028ac <ipc_recv+0x4c>

008028c9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	57                   	push   %edi
  8028cd:	56                   	push   %esi
  8028ce:	53                   	push   %ebx
  8028cf:	83 ec 0c             	sub    $0xc,%esp
  8028d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028db:	85 db                	test   %ebx,%ebx
  8028dd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028e2:	0f 44 d8             	cmove  %eax,%ebx
  8028e5:	eb 05                	jmp    8028ec <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8028e7:	e8 ed e4 ff ff       	call   800dd9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028ec:	ff 75 14             	pushl  0x14(%ebp)
  8028ef:	53                   	push   %ebx
  8028f0:	56                   	push   %esi
  8028f1:	57                   	push   %edi
  8028f2:	e8 8e e6 ff ff       	call   800f85 <sys_ipc_try_send>
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	74 1b                	je     802919 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028fe:	79 e7                	jns    8028e7 <ipc_send+0x1e>
  802900:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802903:	74 e2                	je     8028e7 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 da 32 80 00       	push   $0x8032da
  80290d:	6a 46                	push   $0x46
  80290f:	68 ef 32 80 00       	push   $0x8032ef
  802914:	e8 98 d8 ff ff       	call   8001b1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802919:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80291c:	5b                   	pop    %ebx
  80291d:	5e                   	pop    %esi
  80291e:	5f                   	pop    %edi
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    

00802921 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802921:	55                   	push   %ebp
  802922:	89 e5                	mov    %esp,%ebp
  802924:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80292c:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802932:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802938:	8b 52 50             	mov    0x50(%edx),%edx
  80293b:	39 ca                	cmp    %ecx,%edx
  80293d:	74 11                	je     802950 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80293f:	83 c0 01             	add    $0x1,%eax
  802942:	3d 00 04 00 00       	cmp    $0x400,%eax
  802947:	75 e3                	jne    80292c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	eb 0e                	jmp    80295e <ipc_find_env+0x3d>
			return envs[i].env_id;
  802950:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802956:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80295b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    

00802960 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802966:	89 d0                	mov    %edx,%eax
  802968:	c1 e8 16             	shr    $0x16,%eax
  80296b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802977:	f6 c1 01             	test   $0x1,%cl
  80297a:	74 1d                	je     802999 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80297c:	c1 ea 0c             	shr    $0xc,%edx
  80297f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802986:	f6 c2 01             	test   $0x1,%dl
  802989:	74 0e                	je     802999 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80298b:	c1 ea 0c             	shr    $0xc,%edx
  80298e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802995:	ef 
  802996:	0f b7 c0             	movzwl %ax,%eax
}
  802999:	5d                   	pop    %ebp
  80299a:	c3                   	ret    
  80299b:	66 90                	xchg   %ax,%ax
  80299d:	66 90                	xchg   %ax,%ax
  80299f:	90                   	nop

008029a0 <__udivdi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	57                   	push   %edi
  8029a2:	56                   	push   %esi
  8029a3:	53                   	push   %ebx
  8029a4:	83 ec 1c             	sub    $0x1c,%esp
  8029a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029b7:	85 d2                	test   %edx,%edx
  8029b9:	75 4d                	jne    802a08 <__udivdi3+0x68>
  8029bb:	39 f3                	cmp    %esi,%ebx
  8029bd:	76 19                	jbe    8029d8 <__udivdi3+0x38>
  8029bf:	31 ff                	xor    %edi,%edi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	f7 f3                	div    %ebx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	89 d9                	mov    %ebx,%ecx
  8029da:	85 db                	test   %ebx,%ebx
  8029dc:	75 0b                	jne    8029e9 <__udivdi3+0x49>
  8029de:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e3:	31 d2                	xor    %edx,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 c1                	mov    %eax,%ecx
  8029e9:	31 d2                	xor    %edx,%edx
  8029eb:	89 f0                	mov    %esi,%eax
  8029ed:	f7 f1                	div    %ecx
  8029ef:	89 c6                	mov    %eax,%esi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f7                	mov    %esi,%edi
  8029f5:	f7 f1                	div    %ecx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	39 f2                	cmp    %esi,%edx
  802a0a:	77 1c                	ja     802a28 <__udivdi3+0x88>
  802a0c:	0f bd fa             	bsr    %edx,%edi
  802a0f:	83 f7 1f             	xor    $0x1f,%edi
  802a12:	75 2c                	jne    802a40 <__udivdi3+0xa0>
  802a14:	39 f2                	cmp    %esi,%edx
  802a16:	72 06                	jb     802a1e <__udivdi3+0x7e>
  802a18:	31 c0                	xor    %eax,%eax
  802a1a:	39 eb                	cmp    %ebp,%ebx
  802a1c:	77 a9                	ja     8029c7 <__udivdi3+0x27>
  802a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a23:	eb a2                	jmp    8029c7 <__udivdi3+0x27>
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	31 ff                	xor    %edi,%edi
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	89 fa                	mov    %edi,%edx
  802a2e:	83 c4 1c             	add    $0x1c,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5f                   	pop    %edi
  802a34:	5d                   	pop    %ebp
  802a35:	c3                   	ret    
  802a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	89 f9                	mov    %edi,%ecx
  802a42:	b8 20 00 00 00       	mov    $0x20,%eax
  802a47:	29 f8                	sub    %edi,%eax
  802a49:	d3 e2                	shl    %cl,%edx
  802a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	89 da                	mov    %ebx,%edx
  802a53:	d3 ea                	shr    %cl,%edx
  802a55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a59:	09 d1                	or     %edx,%ecx
  802a5b:	89 f2                	mov    %esi,%edx
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 f9                	mov    %edi,%ecx
  802a63:	d3 e3                	shl    %cl,%ebx
  802a65:	89 c1                	mov    %eax,%ecx
  802a67:	d3 ea                	shr    %cl,%edx
  802a69:	89 f9                	mov    %edi,%ecx
  802a6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a6f:	89 eb                	mov    %ebp,%ebx
  802a71:	d3 e6                	shl    %cl,%esi
  802a73:	89 c1                	mov    %eax,%ecx
  802a75:	d3 eb                	shr    %cl,%ebx
  802a77:	09 de                	or     %ebx,%esi
  802a79:	89 f0                	mov    %esi,%eax
  802a7b:	f7 74 24 08          	divl   0x8(%esp)
  802a7f:	89 d6                	mov    %edx,%esi
  802a81:	89 c3                	mov    %eax,%ebx
  802a83:	f7 64 24 0c          	mull   0xc(%esp)
  802a87:	39 d6                	cmp    %edx,%esi
  802a89:	72 15                	jb     802aa0 <__udivdi3+0x100>
  802a8b:	89 f9                	mov    %edi,%ecx
  802a8d:	d3 e5                	shl    %cl,%ebp
  802a8f:	39 c5                	cmp    %eax,%ebp
  802a91:	73 04                	jae    802a97 <__udivdi3+0xf7>
  802a93:	39 d6                	cmp    %edx,%esi
  802a95:	74 09                	je     802aa0 <__udivdi3+0x100>
  802a97:	89 d8                	mov    %ebx,%eax
  802a99:	31 ff                	xor    %edi,%edi
  802a9b:	e9 27 ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802aa3:	31 ff                	xor    %edi,%edi
  802aa5:	e9 1d ff ff ff       	jmp    8029c7 <__udivdi3+0x27>
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	66 90                	xchg   %ax,%ax
  802aae:	66 90                	xchg   %ax,%ax

00802ab0 <__umoddi3>:
  802ab0:	55                   	push   %ebp
  802ab1:	57                   	push   %edi
  802ab2:	56                   	push   %esi
  802ab3:	53                   	push   %ebx
  802ab4:	83 ec 1c             	sub    $0x1c,%esp
  802ab7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802abb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802abf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ac3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ac7:	89 da                	mov    %ebx,%edx
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	75 43                	jne    802b10 <__umoddi3+0x60>
  802acd:	39 df                	cmp    %ebx,%edi
  802acf:	76 17                	jbe    802ae8 <__umoddi3+0x38>
  802ad1:	89 f0                	mov    %esi,%eax
  802ad3:	f7 f7                	div    %edi
  802ad5:	89 d0                	mov    %edx,%eax
  802ad7:	31 d2                	xor    %edx,%edx
  802ad9:	83 c4 1c             	add    $0x1c,%esp
  802adc:	5b                   	pop    %ebx
  802add:	5e                   	pop    %esi
  802ade:	5f                   	pop    %edi
  802adf:	5d                   	pop    %ebp
  802ae0:	c3                   	ret    
  802ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ae8:	89 fd                	mov    %edi,%ebp
  802aea:	85 ff                	test   %edi,%edi
  802aec:	75 0b                	jne    802af9 <__umoddi3+0x49>
  802aee:	b8 01 00 00 00       	mov    $0x1,%eax
  802af3:	31 d2                	xor    %edx,%edx
  802af5:	f7 f7                	div    %edi
  802af7:	89 c5                	mov    %eax,%ebp
  802af9:	89 d8                	mov    %ebx,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f5                	div    %ebp
  802aff:	89 f0                	mov    %esi,%eax
  802b01:	f7 f5                	div    %ebp
  802b03:	89 d0                	mov    %edx,%eax
  802b05:	eb d0                	jmp    802ad7 <__umoddi3+0x27>
  802b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0e:	66 90                	xchg   %ax,%ax
  802b10:	89 f1                	mov    %esi,%ecx
  802b12:	39 d8                	cmp    %ebx,%eax
  802b14:	76 0a                	jbe    802b20 <__umoddi3+0x70>
  802b16:	89 f0                	mov    %esi,%eax
  802b18:	83 c4 1c             	add    $0x1c,%esp
  802b1b:	5b                   	pop    %ebx
  802b1c:	5e                   	pop    %esi
  802b1d:	5f                   	pop    %edi
  802b1e:	5d                   	pop    %ebp
  802b1f:	c3                   	ret    
  802b20:	0f bd e8             	bsr    %eax,%ebp
  802b23:	83 f5 1f             	xor    $0x1f,%ebp
  802b26:	75 20                	jne    802b48 <__umoddi3+0x98>
  802b28:	39 d8                	cmp    %ebx,%eax
  802b2a:	0f 82 b0 00 00 00    	jb     802be0 <__umoddi3+0x130>
  802b30:	39 f7                	cmp    %esi,%edi
  802b32:	0f 86 a8 00 00 00    	jbe    802be0 <__umoddi3+0x130>
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	83 c4 1c             	add    $0x1c,%esp
  802b3d:	5b                   	pop    %ebx
  802b3e:	5e                   	pop    %esi
  802b3f:	5f                   	pop    %edi
  802b40:	5d                   	pop    %ebp
  802b41:	c3                   	ret    
  802b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b4f:	29 ea                	sub    %ebp,%edx
  802b51:	d3 e0                	shl    %cl,%eax
  802b53:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b57:	89 d1                	mov    %edx,%ecx
  802b59:	89 f8                	mov    %edi,%eax
  802b5b:	d3 e8                	shr    %cl,%eax
  802b5d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b61:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b65:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b69:	09 c1                	or     %eax,%ecx
  802b6b:	89 d8                	mov    %ebx,%eax
  802b6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b71:	89 e9                	mov    %ebp,%ecx
  802b73:	d3 e7                	shl    %cl,%edi
  802b75:	89 d1                	mov    %edx,%ecx
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b7f:	d3 e3                	shl    %cl,%ebx
  802b81:	89 c7                	mov    %eax,%edi
  802b83:	89 d1                	mov    %edx,%ecx
  802b85:	89 f0                	mov    %esi,%eax
  802b87:	d3 e8                	shr    %cl,%eax
  802b89:	89 e9                	mov    %ebp,%ecx
  802b8b:	89 fa                	mov    %edi,%edx
  802b8d:	d3 e6                	shl    %cl,%esi
  802b8f:	09 d8                	or     %ebx,%eax
  802b91:	f7 74 24 08          	divl   0x8(%esp)
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	89 f3                	mov    %esi,%ebx
  802b99:	f7 64 24 0c          	mull   0xc(%esp)
  802b9d:	89 c6                	mov    %eax,%esi
  802b9f:	89 d7                	mov    %edx,%edi
  802ba1:	39 d1                	cmp    %edx,%ecx
  802ba3:	72 06                	jb     802bab <__umoddi3+0xfb>
  802ba5:	75 10                	jne    802bb7 <__umoddi3+0x107>
  802ba7:	39 c3                	cmp    %eax,%ebx
  802ba9:	73 0c                	jae    802bb7 <__umoddi3+0x107>
  802bab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802baf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bb3:	89 d7                	mov    %edx,%edi
  802bb5:	89 c6                	mov    %eax,%esi
  802bb7:	89 ca                	mov    %ecx,%edx
  802bb9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bbe:	29 f3                	sub    %esi,%ebx
  802bc0:	19 fa                	sbb    %edi,%edx
  802bc2:	89 d0                	mov    %edx,%eax
  802bc4:	d3 e0                	shl    %cl,%eax
  802bc6:	89 e9                	mov    %ebp,%ecx
  802bc8:	d3 eb                	shr    %cl,%ebx
  802bca:	d3 ea                	shr    %cl,%edx
  802bcc:	09 d8                	or     %ebx,%eax
  802bce:	83 c4 1c             	add    $0x1c,%esp
  802bd1:	5b                   	pop    %ebx
  802bd2:	5e                   	pop    %esi
  802bd3:	5f                   	pop    %edi
  802bd4:	5d                   	pop    %ebp
  802bd5:	c3                   	ret    
  802bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	89 da                	mov    %ebx,%edx
  802be2:	29 fe                	sub    %edi,%esi
  802be4:	19 c2                	sbb    %eax,%edx
  802be6:	89 f1                	mov    %esi,%ecx
  802be8:	89 c8                	mov    %ecx,%eax
  802bea:	e9 4b ff ff ff       	jmp    802b3a <__umoddi3+0x8a>
