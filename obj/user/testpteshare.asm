
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 63 01 00 00       	call   800194 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 1d 0a 00 00       	call   800a66 <strcpy>
	exit();
  800049:	e8 8f 01 00 00       	call   8001dd <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d0 00 00 00    	jne    800134 <umain+0xe1>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 e0 0d 00 00       	call   800e58 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 1a 13 00 00       	call   8013a2 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 97 2b 00 00       	call   802c38 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 5d 0a 00 00       	call   800b11 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 20 32 80 00       	mov    $0x803220,%eax
  8000be:	ba 26 32 80 00       	mov    $0x803226,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 5c 32 80 00       	push   $0x80325c
  8000cc:	e8 36 02 00 00       	call   800307 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 77 32 80 00       	push   $0x803277
  8000d8:	68 7c 32 80 00       	push   $0x80327c
  8000dd:	68 7b 32 80 00       	push   $0x80327b
  8000e2:	e8 0d 23 00 00       	call   8023f4 <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 3d 2b 00 00       	call   802c38 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 03 0a 00 00       	call   800b11 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 20 32 80 00       	mov    $0x803220,%eax
  800118:	ba 26 32 80 00       	mov    $0x803226,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 93 32 80 00       	push   $0x803293
  800126:	e8 dc 01 00 00       	call   800307 <cprintf>
  : "c" (msr), "a" (val1), "d" (val2))

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012b:	cc                   	int3   
}
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800132:	c9                   	leave  
  800133:	c3                   	ret    
		childofspawn();
  800134:	e8 fa fe ff ff       	call   800033 <childofspawn>
  800139:	e9 26 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  80013e:	50                   	push   %eax
  80013f:	68 2c 32 80 00       	push   $0x80322c
  800144:	6a 13                	push   $0x13
  800146:	68 3f 32 80 00       	push   $0x80323f
  80014b:	e8 c1 00 00 00       	call   800211 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 53 32 80 00       	push   $0x803253
  800156:	6a 17                	push   $0x17
  800158:	68 3f 32 80 00       	push   $0x80323f
  80015d:	e8 af 00 00 00       	call   800211 <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 f1 08 00 00       	call   800a66 <strcpy>
		exit();
  800175:	e8 63 00 00 00       	call   8001dd <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 89 32 80 00       	push   $0x803289
  800188:	6a 21                	push   $0x21
  80018a:	68 3f 32 80 00       	push   $0x80323f
  80018f:	e8 7d 00 00 00       	call   800211 <_panic>

00800194 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80019f:	e8 76 0c 00 00       	call   800e1a <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8001a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8001af:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b4:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b9:	85 db                	test   %ebx,%ebx
  8001bb:	7e 07                	jle    8001c4 <libmain+0x30>
		binaryname = argv[0];
  8001bd:	8b 06                	mov    (%esi),%eax
  8001bf:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	e8 85 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001ce:	e8 0a 00 00 00       	call   8001dd <exit>
}
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    

008001dd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001e3:	a1 08 50 80 00       	mov    0x805008,%eax
  8001e8:	8b 40 48             	mov    0x48(%eax),%eax
  8001eb:	68 e4 32 80 00       	push   $0x8032e4
  8001f0:	50                   	push   %eax
  8001f1:	68 d7 32 80 00       	push   $0x8032d7
  8001f6:	e8 0c 01 00 00       	call   800307 <cprintf>
	close_all();
  8001fb:	e8 12 16 00 00       	call   801812 <close_all>
	sys_env_destroy(0);
  800200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800207:	e8 cd 0b 00 00       	call   800dd9 <sys_env_destroy>
}
  80020c:	83 c4 10             	add    $0x10,%esp
  80020f:	c9                   	leave  
  800210:	c3                   	ret    

00800211 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800211:	55                   	push   %ebp
  800212:	89 e5                	mov    %esp,%ebp
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800216:	a1 08 50 80 00       	mov    0x805008,%eax
  80021b:	8b 40 48             	mov    0x48(%eax),%eax
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 10 33 80 00       	push   $0x803310
  800226:	50                   	push   %eax
  800227:	68 d7 32 80 00       	push   $0x8032d7
  80022c:	e8 d6 00 00 00       	call   800307 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800231:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800234:	8b 35 08 40 80 00    	mov    0x804008,%esi
  80023a:	e8 db 0b 00 00       	call   800e1a <sys_getenvid>
  80023f:	83 c4 04             	add    $0x4,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	56                   	push   %esi
  800249:	50                   	push   %eax
  80024a:	68 ec 32 80 00       	push   $0x8032ec
  80024f:	e8 b3 00 00 00       	call   800307 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800254:	83 c4 18             	add    $0x18,%esp
  800257:	53                   	push   %ebx
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	e8 56 00 00 00       	call   8002b6 <vcprintf>
	cprintf("\n");
  800260:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  800267:	e8 9b 00 00 00       	call   800307 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026f:	cc                   	int3   
  800270:	eb fd                	jmp    80026f <_panic+0x5e>

00800272 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027c:	8b 13                	mov    (%ebx),%edx
  80027e:	8d 42 01             	lea    0x1(%edx),%eax
  800281:	89 03                	mov    %eax,(%ebx)
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	74 09                	je     80029a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800291:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800298:	c9                   	leave  
  800299:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	68 ff 00 00 00       	push   $0xff
  8002a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a5:	50                   	push   %eax
  8002a6:	e8 f1 0a 00 00       	call   800d9c <sys_cputs>
		b->idx = 0;
  8002ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	eb db                	jmp    800291 <putch+0x1f>

008002b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c6:	00 00 00 
	b.cnt = 0;
  8002c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	68 72 02 80 00       	push   $0x800272
  8002e5:	e8 4a 01 00 00       	call   800434 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ea:	83 c4 08             	add    $0x8,%esp
  8002ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	e8 9d 0a 00 00       	call   800d9c <sys_cputs>

	return b.cnt;
}
  8002ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 9d ff ff ff       	call   8002b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 1c             	sub    $0x1c,%esp
  800324:	89 c6                	mov    %eax,%esi
  800326:	89 d7                	mov    %edx,%edi
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800331:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80033a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80033e:	74 2c                	je     80036c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800340:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800343:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80034a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800350:	39 c2                	cmp    %eax,%edx
  800352:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800355:	73 43                	jae    80039a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800357:	83 eb 01             	sub    $0x1,%ebx
  80035a:	85 db                	test   %ebx,%ebx
  80035c:	7e 6c                	jle    8003ca <printnum+0xaf>
				putch(padc, putdat);
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	57                   	push   %edi
  800362:	ff 75 18             	pushl  0x18(%ebp)
  800365:	ff d6                	call   *%esi
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	eb eb                	jmp    800357 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	6a 20                	push   $0x20
  800371:	6a 00                	push   $0x0
  800373:	50                   	push   %eax
  800374:	ff 75 e4             	pushl  -0x1c(%ebp)
  800377:	ff 75 e0             	pushl  -0x20(%ebp)
  80037a:	89 fa                	mov    %edi,%edx
  80037c:	89 f0                	mov    %esi,%eax
  80037e:	e8 98 ff ff ff       	call   80031b <printnum>
		while (--width > 0)
  800383:	83 c4 20             	add    $0x20,%esp
  800386:	83 eb 01             	sub    $0x1,%ebx
  800389:	85 db                	test   %ebx,%ebx
  80038b:	7e 65                	jle    8003f2 <printnum+0xd7>
			putch(padc, putdat);
  80038d:	83 ec 08             	sub    $0x8,%esp
  800390:	57                   	push   %edi
  800391:	6a 20                	push   $0x20
  800393:	ff d6                	call   *%esi
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	eb ec                	jmp    800386 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	ff 75 18             	pushl  0x18(%ebp)
  8003a0:	83 eb 01             	sub    $0x1,%ebx
  8003a3:	53                   	push   %ebx
  8003a4:	50                   	push   %eax
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b4:	e8 17 2c 00 00       	call   802fd0 <__udivdi3>
  8003b9:	83 c4 18             	add    $0x18,%esp
  8003bc:	52                   	push   %edx
  8003bd:	50                   	push   %eax
  8003be:	89 fa                	mov    %edi,%edx
  8003c0:	89 f0                	mov    %esi,%eax
  8003c2:	e8 54 ff ff ff       	call   80031b <printnum>
  8003c7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003ca:	83 ec 08             	sub    $0x8,%esp
  8003cd:	57                   	push   %edi
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003da:	ff 75 e0             	pushl  -0x20(%ebp)
  8003dd:	e8 fe 2c 00 00       	call   8030e0 <__umoddi3>
  8003e2:	83 c4 14             	add    $0x14,%esp
  8003e5:	0f be 80 17 33 80 00 	movsbl 0x803317(%eax),%eax
  8003ec:	50                   	push   %eax
  8003ed:	ff d6                	call   *%esi
  8003ef:	83 c4 10             	add    $0x10,%esp
	}
}
  8003f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f5:	5b                   	pop    %ebx
  8003f6:	5e                   	pop    %esi
  8003f7:	5f                   	pop    %edi
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800400:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800404:	8b 10                	mov    (%eax),%edx
  800406:	3b 50 04             	cmp    0x4(%eax),%edx
  800409:	73 0a                	jae    800415 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040e:	89 08                	mov    %ecx,(%eax)
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	88 02                	mov    %al,(%edx)
}
  800415:	5d                   	pop    %ebp
  800416:	c3                   	ret    

00800417 <printfmt>:
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80041d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800420:	50                   	push   %eax
  800421:	ff 75 10             	pushl  0x10(%ebp)
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	e8 05 00 00 00       	call   800434 <vprintfmt>
}
  80042f:	83 c4 10             	add    $0x10,%esp
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <vprintfmt>:
{
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	57                   	push   %edi
  800438:	56                   	push   %esi
  800439:	53                   	push   %ebx
  80043a:	83 ec 3c             	sub    $0x3c,%esp
  80043d:	8b 75 08             	mov    0x8(%ebp),%esi
  800440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800443:	8b 7d 10             	mov    0x10(%ebp),%edi
  800446:	e9 32 04 00 00       	jmp    80087d <vprintfmt+0x449>
		padc = ' ';
  80044b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80044f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800456:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80045d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800464:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800472:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800477:	8d 47 01             	lea    0x1(%edi),%eax
  80047a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047d:	0f b6 17             	movzbl (%edi),%edx
  800480:	8d 42 dd             	lea    -0x23(%edx),%eax
  800483:	3c 55                	cmp    $0x55,%al
  800485:	0f 87 12 05 00 00    	ja     80099d <vprintfmt+0x569>
  80048b:	0f b6 c0             	movzbl %al,%eax
  80048e:	ff 24 85 00 35 80 00 	jmp    *0x803500(,%eax,4)
  800495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800498:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80049c:	eb d9                	jmp    800477 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004a1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004a5:	eb d0                	jmp    800477 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	0f b6 d2             	movzbl %dl,%edx
  8004aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b5:	eb 03                	jmp    8004ba <vprintfmt+0x86>
  8004b7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ba:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c7:	83 fe 09             	cmp    $0x9,%esi
  8004ca:	76 eb                	jbe    8004b7 <vprintfmt+0x83>
  8004cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d2:	eb 14                	jmp    8004e8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8d 40 04             	lea    0x4(%eax),%eax
  8004e2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ec:	79 89                	jns    800477 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fb:	e9 77 ff ff ff       	jmp    800477 <vprintfmt+0x43>
  800500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800503:	85 c0                	test   %eax,%eax
  800505:	0f 48 c1             	cmovs  %ecx,%eax
  800508:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050e:	e9 64 ff ff ff       	jmp    800477 <vprintfmt+0x43>
  800513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800516:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80051d:	e9 55 ff ff ff       	jmp    800477 <vprintfmt+0x43>
			lflag++;
  800522:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800529:	e9 49 ff ff ff       	jmp    800477 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 78 04             	lea    0x4(%eax),%edi
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	ff 30                	pushl  (%eax)
  80053a:	ff d6                	call   *%esi
			break;
  80053c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80053f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800542:	e9 33 03 00 00       	jmp    80087a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8d 78 04             	lea    0x4(%eax),%edi
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	99                   	cltd   
  800550:	31 d0                	xor    %edx,%eax
  800552:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800554:	83 f8 11             	cmp    $0x11,%eax
  800557:	7f 23                	jg     80057c <vprintfmt+0x148>
  800559:	8b 14 85 60 36 80 00 	mov    0x803660(,%eax,4),%edx
  800560:	85 d2                	test   %edx,%edx
  800562:	74 18                	je     80057c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800564:	52                   	push   %edx
  800565:	68 6d 38 80 00       	push   $0x80386d
  80056a:	53                   	push   %ebx
  80056b:	56                   	push   %esi
  80056c:	e8 a6 fe ff ff       	call   800417 <printfmt>
  800571:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800574:	89 7d 14             	mov    %edi,0x14(%ebp)
  800577:	e9 fe 02 00 00       	jmp    80087a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80057c:	50                   	push   %eax
  80057d:	68 2f 33 80 00       	push   $0x80332f
  800582:	53                   	push   %ebx
  800583:	56                   	push   %esi
  800584:	e8 8e fe ff ff       	call   800417 <printfmt>
  800589:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80058c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80058f:	e9 e6 02 00 00       	jmp    80087a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	83 c0 04             	add    $0x4,%eax
  80059a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005a2:	85 c9                	test   %ecx,%ecx
  8005a4:	b8 28 33 80 00       	mov    $0x803328,%eax
  8005a9:	0f 45 c1             	cmovne %ecx,%eax
  8005ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b3:	7e 06                	jle    8005bb <vprintfmt+0x187>
  8005b5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005b9:	75 0d                	jne    8005c8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005be:	89 c7                	mov    %eax,%edi
  8005c0:	03 45 e0             	add    -0x20(%ebp),%eax
  8005c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c6:	eb 53                	jmp    80061b <vprintfmt+0x1e7>
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8005ce:	50                   	push   %eax
  8005cf:	e8 71 04 00 00       	call   800a45 <strnlen>
  8005d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d7:	29 c1                	sub    %eax,%ecx
  8005d9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005e1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e8:	eb 0f                	jmp    8005f9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	53                   	push   %ebx
  8005ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f3:	83 ef 01             	sub    $0x1,%edi
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	85 ff                	test   %edi,%edi
  8005fb:	7f ed                	jg     8005ea <vprintfmt+0x1b6>
  8005fd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800600:	85 c9                	test   %ecx,%ecx
  800602:	b8 00 00 00 00       	mov    $0x0,%eax
  800607:	0f 49 c1             	cmovns %ecx,%eax
  80060a:	29 c1                	sub    %eax,%ecx
  80060c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80060f:	eb aa                	jmp    8005bb <vprintfmt+0x187>
					putch(ch, putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	52                   	push   %edx
  800616:	ff d6                	call   *%esi
  800618:	83 c4 10             	add    $0x10,%esp
  80061b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800620:	83 c7 01             	add    $0x1,%edi
  800623:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800627:	0f be d0             	movsbl %al,%edx
  80062a:	85 d2                	test   %edx,%edx
  80062c:	74 4b                	je     800679 <vprintfmt+0x245>
  80062e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800632:	78 06                	js     80063a <vprintfmt+0x206>
  800634:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800638:	78 1e                	js     800658 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80063a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80063e:	74 d1                	je     800611 <vprintfmt+0x1dd>
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 e8 20             	sub    $0x20,%eax
  800646:	83 f8 5e             	cmp    $0x5e,%eax
  800649:	76 c6                	jbe    800611 <vprintfmt+0x1dd>
					putch('?', putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	53                   	push   %ebx
  80064f:	6a 3f                	push   $0x3f
  800651:	ff d6                	call   *%esi
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	eb c3                	jmp    80061b <vprintfmt+0x1e7>
  800658:	89 cf                	mov    %ecx,%edi
  80065a:	eb 0e                	jmp    80066a <vprintfmt+0x236>
				putch(' ', putdat);
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	53                   	push   %ebx
  800660:	6a 20                	push   $0x20
  800662:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800664:	83 ef 01             	sub    $0x1,%edi
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	85 ff                	test   %edi,%edi
  80066c:	7f ee                	jg     80065c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80066e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	e9 01 02 00 00       	jmp    80087a <vprintfmt+0x446>
  800679:	89 cf                	mov    %ecx,%edi
  80067b:	eb ed                	jmp    80066a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80067d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800680:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800687:	e9 eb fd ff ff       	jmp    800477 <vprintfmt+0x43>
	if (lflag >= 2)
  80068c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800690:	7f 21                	jg     8006b3 <vprintfmt+0x27f>
	else if (lflag)
  800692:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800696:	74 68                	je     800700 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a0:	89 c1                	mov    %eax,%ecx
  8006a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b1:	eb 17                	jmp    8006ca <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 50 04             	mov    0x4(%eax),%edx
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 08             	lea    0x8(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006da:	78 3f                	js     80071b <vprintfmt+0x2e7>
			base = 10;
  8006dc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006e1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006e5:	0f 84 71 01 00 00    	je     80085c <vprintfmt+0x428>
				putch('+', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 2b                	push   $0x2b
  8006f1:	ff d6                	call   *%esi
  8006f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fb:	e9 5c 01 00 00       	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800708:	89 c1                	mov    %eax,%ecx
  80070a:	c1 f9 1f             	sar    $0x1f,%ecx
  80070d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8d 40 04             	lea    0x4(%eax),%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
  800719:	eb af                	jmp    8006ca <vprintfmt+0x296>
				putch('-', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 2d                	push   $0x2d
  800721:	ff d6                	call   *%esi
				num = -(long long) num;
  800723:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800726:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800729:	f7 d8                	neg    %eax
  80072b:	83 d2 00             	adc    $0x0,%edx
  80072e:	f7 da                	neg    %edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800736:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800739:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073e:	e9 19 01 00 00       	jmp    80085c <vprintfmt+0x428>
	if (lflag >= 2)
  800743:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800747:	7f 29                	jg     800772 <vprintfmt+0x33e>
	else if (lflag)
  800749:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074d:	74 44                	je     800793 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	ba 00 00 00 00       	mov    $0x0,%edx
  800759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800768:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076d:	e9 ea 00 00 00       	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 50 04             	mov    0x4(%eax),%edx
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 08             	lea    0x8(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800789:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078e:	e9 c9 00 00 00       	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b1:	e9 a6 00 00 00       	jmp    80085c <vprintfmt+0x428>
			putch('0', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 30                	push   $0x30
  8007bc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c5:	7f 26                	jg     8007ed <vprintfmt+0x3b9>
	else if (lflag)
  8007c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007cb:	74 3e                	je     80080b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 40 04             	lea    0x4(%eax),%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8007eb:	eb 6f                	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 08             	lea    0x8(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800804:	b8 08 00 00 00       	mov    $0x8,%eax
  800809:	eb 51                	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	ba 00 00 00 00       	mov    $0x0,%edx
  800815:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800818:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	8d 40 04             	lea    0x4(%eax),%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800824:	b8 08 00 00 00       	mov    $0x8,%eax
  800829:	eb 31                	jmp    80085c <vprintfmt+0x428>
			putch('0', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 30                	push   $0x30
  800831:	ff d6                	call   *%esi
			putch('x', putdat);
  800833:	83 c4 08             	add    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 78                	push   $0x78
  800839:	ff d6                	call   *%esi
			num = (unsigned long long)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800848:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80084b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800857:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800863:	52                   	push   %edx
  800864:	ff 75 e0             	pushl  -0x20(%ebp)
  800867:	50                   	push   %eax
  800868:	ff 75 dc             	pushl  -0x24(%ebp)
  80086b:	ff 75 d8             	pushl  -0x28(%ebp)
  80086e:	89 da                	mov    %ebx,%edx
  800870:	89 f0                	mov    %esi,%eax
  800872:	e8 a4 fa ff ff       	call   80031b <printnum>
			break;
  800877:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80087a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087d:	83 c7 01             	add    $0x1,%edi
  800880:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800884:	83 f8 25             	cmp    $0x25,%eax
  800887:	0f 84 be fb ff ff    	je     80044b <vprintfmt+0x17>
			if (ch == '\0')
  80088d:	85 c0                	test   %eax,%eax
  80088f:	0f 84 28 01 00 00    	je     8009bd <vprintfmt+0x589>
			putch(ch, putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	53                   	push   %ebx
  800899:	50                   	push   %eax
  80089a:	ff d6                	call   *%esi
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	eb dc                	jmp    80087d <vprintfmt+0x449>
	if (lflag >= 2)
  8008a1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a5:	7f 26                	jg     8008cd <vprintfmt+0x499>
	else if (lflag)
  8008a7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ab:	74 41                	je     8008ee <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8d 40 04             	lea    0x4(%eax),%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008cb:	eb 8f                	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8b 50 04             	mov    0x4(%eax),%edx
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8d 40 08             	lea    0x8(%eax),%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e9:	e9 6e ff ff ff       	jmp    80085c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 40 04             	lea    0x4(%eax),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800907:	b8 10 00 00 00       	mov    $0x10,%eax
  80090c:	e9 4b ff ff ff       	jmp    80085c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800911:	8b 45 14             	mov    0x14(%ebp),%eax
  800914:	83 c0 04             	add    $0x4,%eax
  800917:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	85 c0                	test   %eax,%eax
  800921:	74 14                	je     800937 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800923:	8b 13                	mov    (%ebx),%edx
  800925:	83 fa 7f             	cmp    $0x7f,%edx
  800928:	7f 37                	jg     800961 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80092a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
  800932:	e9 43 ff ff ff       	jmp    80087a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800937:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093c:	bf 4d 34 80 00       	mov    $0x80344d,%edi
							putch(ch, putdat);
  800941:	83 ec 08             	sub    $0x8,%esp
  800944:	53                   	push   %ebx
  800945:	50                   	push   %eax
  800946:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800948:	83 c7 01             	add    $0x1,%edi
  80094b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80094f:	83 c4 10             	add    $0x10,%esp
  800952:	85 c0                	test   %eax,%eax
  800954:	75 eb                	jne    800941 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800956:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
  80095c:	e9 19 ff ff ff       	jmp    80087a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800961:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800963:	b8 0a 00 00 00       	mov    $0xa,%eax
  800968:	bf 85 34 80 00       	mov    $0x803485,%edi
							putch(ch, putdat);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	53                   	push   %ebx
  800971:	50                   	push   %eax
  800972:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800974:	83 c7 01             	add    $0x1,%edi
  800977:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	85 c0                	test   %eax,%eax
  800980:	75 eb                	jne    80096d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800982:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	e9 ed fe ff ff       	jmp    80087a <vprintfmt+0x446>
			putch(ch, putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 25                	push   $0x25
  800993:	ff d6                	call   *%esi
			break;
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	e9 dd fe ff ff       	jmp    80087a <vprintfmt+0x446>
			putch('%', putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	53                   	push   %ebx
  8009a1:	6a 25                	push   $0x25
  8009a3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 f8                	mov    %edi,%eax
  8009aa:	eb 03                	jmp    8009af <vprintfmt+0x57b>
  8009ac:	83 e8 01             	sub    $0x1,%eax
  8009af:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b3:	75 f7                	jne    8009ac <vprintfmt+0x578>
  8009b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b8:	e9 bd fe ff ff       	jmp    80087a <vprintfmt+0x446>
}
  8009bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5f                   	pop    %edi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	83 ec 18             	sub    $0x18,%esp
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e2:	85 c0                	test   %eax,%eax
  8009e4:	74 26                	je     800a0c <vsnprintf+0x47>
  8009e6:	85 d2                	test   %edx,%edx
  8009e8:	7e 22                	jle    800a0c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009ea:	ff 75 14             	pushl  0x14(%ebp)
  8009ed:	ff 75 10             	pushl  0x10(%ebp)
  8009f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f3:	50                   	push   %eax
  8009f4:	68 fa 03 80 00       	push   $0x8003fa
  8009f9:	e8 36 fa ff ff       	call   800434 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a01:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a07:	83 c4 10             	add    $0x10,%esp
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    
		return -E_INVAL;
  800a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a11:	eb f7                	jmp    800a0a <vsnprintf+0x45>

00800a13 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a19:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a1c:	50                   	push   %eax
  800a1d:	ff 75 10             	pushl  0x10(%ebp)
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	ff 75 08             	pushl  0x8(%ebp)
  800a26:	e8 9a ff ff ff       	call   8009c5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a3c:	74 05                	je     800a43 <strlen+0x16>
		n++;
  800a3e:	83 c0 01             	add    $0x1,%eax
  800a41:	eb f5                	jmp    800a38 <strlen+0xb>
	return n;
}
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a53:	39 c2                	cmp    %eax,%edx
  800a55:	74 0d                	je     800a64 <strnlen+0x1f>
  800a57:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a5b:	74 05                	je     800a62 <strnlen+0x1d>
		n++;
  800a5d:	83 c2 01             	add    $0x1,%edx
  800a60:	eb f1                	jmp    800a53 <strnlen+0xe>
  800a62:	89 d0                	mov    %edx,%eax
	return n;
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	53                   	push   %ebx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a70:	ba 00 00 00 00       	mov    $0x0,%edx
  800a75:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a79:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	84 c9                	test   %cl,%cl
  800a81:	75 f2                	jne    800a75 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a83:	5b                   	pop    %ebx
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	53                   	push   %ebx
  800a8a:	83 ec 10             	sub    $0x10,%esp
  800a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a90:	53                   	push   %ebx
  800a91:	e8 97 ff ff ff       	call   800a2d <strlen>
  800a96:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	01 d8                	add    %ebx,%eax
  800a9e:	50                   	push   %eax
  800a9f:	e8 c2 ff ff ff       	call   800a66 <strcpy>
	return dst;
}
  800aa4:	89 d8                	mov    %ebx,%eax
  800aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	56                   	push   %esi
  800aaf:	53                   	push   %ebx
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab6:	89 c6                	mov    %eax,%esi
  800ab8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800abb:	89 c2                	mov    %eax,%edx
  800abd:	39 f2                	cmp    %esi,%edx
  800abf:	74 11                	je     800ad2 <strncpy+0x27>
		*dst++ = *src;
  800ac1:	83 c2 01             	add    $0x1,%edx
  800ac4:	0f b6 19             	movzbl (%ecx),%ebx
  800ac7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aca:	80 fb 01             	cmp    $0x1,%bl
  800acd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ad0:	eb eb                	jmp    800abd <strncpy+0x12>
	}
	return ret;
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	56                   	push   %esi
  800ada:	53                   	push   %ebx
  800adb:	8b 75 08             	mov    0x8(%ebp),%esi
  800ade:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae1:	8b 55 10             	mov    0x10(%ebp),%edx
  800ae4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae6:	85 d2                	test   %edx,%edx
  800ae8:	74 21                	je     800b0b <strlcpy+0x35>
  800aea:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aee:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800af0:	39 c2                	cmp    %eax,%edx
  800af2:	74 14                	je     800b08 <strlcpy+0x32>
  800af4:	0f b6 19             	movzbl (%ecx),%ebx
  800af7:	84 db                	test   %bl,%bl
  800af9:	74 0b                	je     800b06 <strlcpy+0x30>
			*dst++ = *src++;
  800afb:	83 c1 01             	add    $0x1,%ecx
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b04:	eb ea                	jmp    800af0 <strlcpy+0x1a>
  800b06:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b08:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b0b:	29 f0                	sub    %esi,%eax
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b1a:	0f b6 01             	movzbl (%ecx),%eax
  800b1d:	84 c0                	test   %al,%al
  800b1f:	74 0c                	je     800b2d <strcmp+0x1c>
  800b21:	3a 02                	cmp    (%edx),%al
  800b23:	75 08                	jne    800b2d <strcmp+0x1c>
		p++, q++;
  800b25:	83 c1 01             	add    $0x1,%ecx
  800b28:	83 c2 01             	add    $0x1,%edx
  800b2b:	eb ed                	jmp    800b1a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2d:	0f b6 c0             	movzbl %al,%eax
  800b30:	0f b6 12             	movzbl (%edx),%edx
  800b33:	29 d0                	sub    %edx,%eax
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b41:	89 c3                	mov    %eax,%ebx
  800b43:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b46:	eb 06                	jmp    800b4e <strncmp+0x17>
		n--, p++, q++;
  800b48:	83 c0 01             	add    $0x1,%eax
  800b4b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b4e:	39 d8                	cmp    %ebx,%eax
  800b50:	74 16                	je     800b68 <strncmp+0x31>
  800b52:	0f b6 08             	movzbl (%eax),%ecx
  800b55:	84 c9                	test   %cl,%cl
  800b57:	74 04                	je     800b5d <strncmp+0x26>
  800b59:	3a 0a                	cmp    (%edx),%cl
  800b5b:	74 eb                	je     800b48 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5d:	0f b6 00             	movzbl (%eax),%eax
  800b60:	0f b6 12             	movzbl (%edx),%edx
  800b63:	29 d0                	sub    %edx,%eax
}
  800b65:	5b                   	pop    %ebx
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    
		return 0;
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6d:	eb f6                	jmp    800b65 <strncmp+0x2e>

00800b6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b79:	0f b6 10             	movzbl (%eax),%edx
  800b7c:	84 d2                	test   %dl,%dl
  800b7e:	74 09                	je     800b89 <strchr+0x1a>
		if (*s == c)
  800b80:	38 ca                	cmp    %cl,%dl
  800b82:	74 0a                	je     800b8e <strchr+0x1f>
	for (; *s; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	eb f0                	jmp    800b79 <strchr+0xa>
			return (char *) s;
	return 0;
  800b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b9a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b9d:	38 ca                	cmp    %cl,%dl
  800b9f:	74 09                	je     800baa <strfind+0x1a>
  800ba1:	84 d2                	test   %dl,%dl
  800ba3:	74 05                	je     800baa <strfind+0x1a>
	for (; *s; s++)
  800ba5:	83 c0 01             	add    $0x1,%eax
  800ba8:	eb f0                	jmp    800b9a <strfind+0xa>
			break;
	return (char *) s;
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb8:	85 c9                	test   %ecx,%ecx
  800bba:	74 31                	je     800bed <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bbc:	89 f8                	mov    %edi,%eax
  800bbe:	09 c8                	or     %ecx,%eax
  800bc0:	a8 03                	test   $0x3,%al
  800bc2:	75 23                	jne    800be7 <memset+0x3b>
		c &= 0xFF;
  800bc4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc8:	89 d3                	mov    %edx,%ebx
  800bca:	c1 e3 08             	shl    $0x8,%ebx
  800bcd:	89 d0                	mov    %edx,%eax
  800bcf:	c1 e0 18             	shl    $0x18,%eax
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	c1 e6 10             	shl    $0x10,%esi
  800bd7:	09 f0                	or     %esi,%eax
  800bd9:	09 c2                	or     %eax,%edx
  800bdb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bdd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be0:	89 d0                	mov    %edx,%eax
  800be2:	fc                   	cld    
  800be3:	f3 ab                	rep stos %eax,%es:(%edi)
  800be5:	eb 06                	jmp    800bed <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bea:	fc                   	cld    
  800beb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bed:	89 f8                	mov    %edi,%eax
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c02:	39 c6                	cmp    %eax,%esi
  800c04:	73 32                	jae    800c38 <memmove+0x44>
  800c06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	76 2b                	jbe    800c38 <memmove+0x44>
		s += n;
		d += n;
  800c0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c10:	89 fe                	mov    %edi,%esi
  800c12:	09 ce                	or     %ecx,%esi
  800c14:	09 d6                	or     %edx,%esi
  800c16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1c:	75 0e                	jne    800c2c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c1e:	83 ef 04             	sub    $0x4,%edi
  800c21:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c24:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c27:	fd                   	std    
  800c28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2a:	eb 09                	jmp    800c35 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2c:	83 ef 01             	sub    $0x1,%edi
  800c2f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c32:	fd                   	std    
  800c33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c35:	fc                   	cld    
  800c36:	eb 1a                	jmp    800c52 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	09 ca                	or     %ecx,%edx
  800c3c:	09 f2                	or     %esi,%edx
  800c3e:	f6 c2 03             	test   $0x3,%dl
  800c41:	75 0a                	jne    800c4d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c46:	89 c7                	mov    %eax,%edi
  800c48:	fc                   	cld    
  800c49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4b:	eb 05                	jmp    800c52 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c4d:	89 c7                	mov    %eax,%edi
  800c4f:	fc                   	cld    
  800c50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c5c:	ff 75 10             	pushl  0x10(%ebp)
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	ff 75 08             	pushl  0x8(%ebp)
  800c65:	e8 8a ff ff ff       	call   800bf4 <memmove>
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c77:	89 c6                	mov    %eax,%esi
  800c79:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7c:	39 f0                	cmp    %esi,%eax
  800c7e:	74 1c                	je     800c9c <memcmp+0x30>
		if (*s1 != *s2)
  800c80:	0f b6 08             	movzbl (%eax),%ecx
  800c83:	0f b6 1a             	movzbl (%edx),%ebx
  800c86:	38 d9                	cmp    %bl,%cl
  800c88:	75 08                	jne    800c92 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8a:	83 c0 01             	add    $0x1,%eax
  800c8d:	83 c2 01             	add    $0x1,%edx
  800c90:	eb ea                	jmp    800c7c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c92:	0f b6 c1             	movzbl %cl,%eax
  800c95:	0f b6 db             	movzbl %bl,%ebx
  800c98:	29 d8                	sub    %ebx,%eax
  800c9a:	eb 05                	jmp    800ca1 <memcmp+0x35>
	}

	return 0;
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cae:	89 c2                	mov    %eax,%edx
  800cb0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb3:	39 d0                	cmp    %edx,%eax
  800cb5:	73 09                	jae    800cc0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb7:	38 08                	cmp    %cl,(%eax)
  800cb9:	74 05                	je     800cc0 <memfind+0x1b>
	for (; s < ends; s++)
  800cbb:	83 c0 01             	add    $0x1,%eax
  800cbe:	eb f3                	jmp    800cb3 <memfind+0xe>
			break;
	return (void *) s;
}
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cce:	eb 03                	jmp    800cd3 <strtol+0x11>
		s++;
  800cd0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	3c 20                	cmp    $0x20,%al
  800cd8:	74 f6                	je     800cd0 <strtol+0xe>
  800cda:	3c 09                	cmp    $0x9,%al
  800cdc:	74 f2                	je     800cd0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cde:	3c 2b                	cmp    $0x2b,%al
  800ce0:	74 2a                	je     800d0c <strtol+0x4a>
	int neg = 0;
  800ce2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce7:	3c 2d                	cmp    $0x2d,%al
  800ce9:	74 2b                	je     800d16 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ceb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf1:	75 0f                	jne    800d02 <strtol+0x40>
  800cf3:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf6:	74 28                	je     800d20 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cff:	0f 44 d8             	cmove  %eax,%ebx
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0a:	eb 50                	jmp    800d5c <strtol+0x9a>
		s++;
  800d0c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d14:	eb d5                	jmp    800ceb <strtol+0x29>
		s++, neg = 1;
  800d16:	83 c1 01             	add    $0x1,%ecx
  800d19:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1e:	eb cb                	jmp    800ceb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d20:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d24:	74 0e                	je     800d34 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d26:	85 db                	test   %ebx,%ebx
  800d28:	75 d8                	jne    800d02 <strtol+0x40>
		s++, base = 8;
  800d2a:	83 c1 01             	add    $0x1,%ecx
  800d2d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d32:	eb ce                	jmp    800d02 <strtol+0x40>
		s += 2, base = 16;
  800d34:	83 c1 02             	add    $0x2,%ecx
  800d37:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3c:	eb c4                	jmp    800d02 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d3e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d41:	89 f3                	mov    %esi,%ebx
  800d43:	80 fb 19             	cmp    $0x19,%bl
  800d46:	77 29                	ja     800d71 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d48:	0f be d2             	movsbl %dl,%edx
  800d4b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d51:	7d 30                	jge    800d83 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d53:	83 c1 01             	add    $0x1,%ecx
  800d56:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5c:	0f b6 11             	movzbl (%ecx),%edx
  800d5f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d62:	89 f3                	mov    %esi,%ebx
  800d64:	80 fb 09             	cmp    $0x9,%bl
  800d67:	77 d5                	ja     800d3e <strtol+0x7c>
			dig = *s - '0';
  800d69:	0f be d2             	movsbl %dl,%edx
  800d6c:	83 ea 30             	sub    $0x30,%edx
  800d6f:	eb dd                	jmp    800d4e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d71:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d74:	89 f3                	mov    %esi,%ebx
  800d76:	80 fb 19             	cmp    $0x19,%bl
  800d79:	77 08                	ja     800d83 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d7b:	0f be d2             	movsbl %dl,%edx
  800d7e:	83 ea 37             	sub    $0x37,%edx
  800d81:	eb cb                	jmp    800d4e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 05                	je     800d8e <strtol+0xcc>
		*endptr = (char *) s;
  800d89:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8e:	89 c2                	mov    %eax,%edx
  800d90:	f7 da                	neg    %edx
  800d92:	85 ff                	test   %edi,%edi
  800d94:	0f 45 c2             	cmovne %edx,%eax
}
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	57                   	push   %edi
  800da0:	56                   	push   %esi
  800da1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
  800da7:	8b 55 08             	mov    0x8(%ebp),%edx
  800daa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dad:	89 c3                	mov    %eax,%ebx
  800daf:	89 c7                	mov    %eax,%edi
  800db1:	89 c6                	mov    %eax,%esi
  800db3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_cgetc>:

int
sys_cgetc(void)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  800dca:	89 d1                	mov    %edx,%ecx
  800dcc:	89 d3                	mov    %edx,%ebx
  800dce:	89 d7                	mov    %edx,%edi
  800dd0:	89 d6                	mov    %edx,%esi
  800dd2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	b8 03 00 00 00       	mov    $0x3,%eax
  800def:	89 cb                	mov    %ecx,%ebx
  800df1:	89 cf                	mov    %ecx,%edi
  800df3:	89 ce                	mov    %ecx,%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 03                	push   $0x3
  800e09:	68 a8 36 80 00       	push   $0x8036a8
  800e0e:	6a 43                	push   $0x43
  800e10:	68 c5 36 80 00       	push   $0x8036c5
  800e15:	e8 f7 f3 ff ff       	call   800211 <_panic>

00800e1a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e20:	ba 00 00 00 00       	mov    $0x0,%edx
  800e25:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2a:	89 d1                	mov    %edx,%ecx
  800e2c:	89 d3                	mov    %edx,%ebx
  800e2e:	89 d7                	mov    %edx,%edi
  800e30:	89 d6                	mov    %edx,%esi
  800e32:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_yield>:

void
sys_yield(void)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e49:	89 d1                	mov    %edx,%ecx
  800e4b:	89 d3                	mov    %edx,%ebx
  800e4d:	89 d7                	mov    %edx,%edi
  800e4f:	89 d6                	mov    %edx,%esi
  800e51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
  800e5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e61:	be 00 00 00 00       	mov    $0x0,%esi
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6c:	b8 04 00 00 00       	mov    $0x4,%eax
  800e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e74:	89 f7                	mov    %esi,%edi
  800e76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7f 08                	jg     800e84 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5f                   	pop    %edi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e84:	83 ec 0c             	sub    $0xc,%esp
  800e87:	50                   	push   %eax
  800e88:	6a 04                	push   $0x4
  800e8a:	68 a8 36 80 00       	push   $0x8036a8
  800e8f:	6a 43                	push   $0x43
  800e91:	68 c5 36 80 00       	push   $0x8036c5
  800e96:	e8 76 f3 ff ff       	call   800211 <_panic>

00800e9b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
  800ea1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 05 00 00 00       	mov    $0x5,%eax
  800eaf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb5:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	7f 08                	jg     800ec6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec1:	5b                   	pop    %ebx
  800ec2:	5e                   	pop    %esi
  800ec3:	5f                   	pop    %edi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	83 ec 0c             	sub    $0xc,%esp
  800ec9:	50                   	push   %eax
  800eca:	6a 05                	push   $0x5
  800ecc:	68 a8 36 80 00       	push   $0x8036a8
  800ed1:	6a 43                	push   $0x43
  800ed3:	68 c5 36 80 00       	push   $0x8036c5
  800ed8:	e8 34 f3 ff ff       	call   800211 <_panic>

00800edd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef6:	89 df                	mov    %ebx,%edi
  800ef8:	89 de                	mov    %ebx,%esi
  800efa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	7f 08                	jg     800f08 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	50                   	push   %eax
  800f0c:	6a 06                	push   $0x6
  800f0e:	68 a8 36 80 00       	push   $0x8036a8
  800f13:	6a 43                	push   $0x43
  800f15:	68 c5 36 80 00       	push   $0x8036c5
  800f1a:	e8 f2 f2 ff ff       	call   800211 <_panic>

00800f1f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	b8 08 00 00 00       	mov    $0x8,%eax
  800f38:	89 df                	mov    %ebx,%edi
  800f3a:	89 de                	mov    %ebx,%esi
  800f3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	7f 08                	jg     800f4a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	50                   	push   %eax
  800f4e:	6a 08                	push   $0x8
  800f50:	68 a8 36 80 00       	push   $0x8036a8
  800f55:	6a 43                	push   $0x43
  800f57:	68 c5 36 80 00       	push   $0x8036c5
  800f5c:	e8 b0 f2 ff ff       	call   800211 <_panic>

00800f61 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
  800f67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f75:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7a:	89 df                	mov    %ebx,%edi
  800f7c:	89 de                	mov    %ebx,%esi
  800f7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f80:	85 c0                	test   %eax,%eax
  800f82:	7f 08                	jg     800f8c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8c:	83 ec 0c             	sub    $0xc,%esp
  800f8f:	50                   	push   %eax
  800f90:	6a 09                	push   $0x9
  800f92:	68 a8 36 80 00       	push   $0x8036a8
  800f97:	6a 43                	push   $0x43
  800f99:	68 c5 36 80 00       	push   $0x8036c5
  800f9e:	e8 6e f2 ff ff       	call   800211 <_panic>

00800fa3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 0a                	push   $0xa
  800fd4:	68 a8 36 80 00       	push   $0x8036a8
  800fd9:	6a 43                	push   $0x43
  800fdb:	68 c5 36 80 00       	push   $0x8036c5
  800fe0:	e8 2c f2 ff ff       	call   800211 <_panic>

00800fe5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ff6:	be 00 00 00 00       	mov    $0x0,%esi
  800ffb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801001:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
  80100e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801011:	b9 00 00 00 00       	mov    $0x0,%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	b8 0d 00 00 00       	mov    $0xd,%eax
  80101e:	89 cb                	mov    %ecx,%ebx
  801020:	89 cf                	mov    %ecx,%edi
  801022:	89 ce                	mov    %ecx,%esi
  801024:	cd 30                	int    $0x30
	if(check && ret > 0)
  801026:	85 c0                	test   %eax,%eax
  801028:	7f 08                	jg     801032 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80102a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	50                   	push   %eax
  801036:	6a 0d                	push   $0xd
  801038:	68 a8 36 80 00       	push   $0x8036a8
  80103d:	6a 43                	push   $0x43
  80103f:	68 c5 36 80 00       	push   $0x8036c5
  801044:	e8 c8 f1 ff ff       	call   800211 <_panic>

00801049 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
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
  80105a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801070:	b9 00 00 00 00       	mov    $0x0,%ecx
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	b8 0f 00 00 00       	mov    $0xf,%eax
  80107d:	89 cb                	mov    %ecx,%ebx
  80107f:	89 cf                	mov    %ecx,%edi
  801081:	89 ce                	mov    %ecx,%esi
  801083:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	ba 00 00 00 00       	mov    $0x0,%edx
  801095:	b8 10 00 00 00       	mov    $0x10,%eax
  80109a:	89 d1                	mov    %edx,%ecx
  80109c:	89 d3                	mov    %edx,%ebx
  80109e:	89 d7                	mov    %edx,%edi
  8010a0:	89 d6                	mov    %edx,%esi
  8010a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
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
  8010ba:	b8 11 00 00 00       	mov    $0x11,%eax
  8010bf:	89 df                	mov    %ebx,%edi
  8010c1:	89 de                	mov    %ebx,%esi
  8010c3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c5:	5b                   	pop    %ebx
  8010c6:	5e                   	pop    %esi
  8010c7:	5f                   	pop    %edi
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010db:	b8 12 00 00 00       	mov    $0x12,%eax
  8010e0:	89 df                	mov    %ebx,%edi
  8010e2:	89 de                	mov    %ebx,%esi
  8010e4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010e6:	5b                   	pop    %ebx
  8010e7:	5e                   	pop    %esi
  8010e8:	5f                   	pop    %edi
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	57                   	push   %edi
  8010ef:	56                   	push   %esi
  8010f0:	53                   	push   %ebx
  8010f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ff:	b8 13 00 00 00       	mov    $0x13,%eax
  801104:	89 df                	mov    %ebx,%edi
  801106:	89 de                	mov    %ebx,%esi
  801108:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110a:	85 c0                	test   %eax,%eax
  80110c:	7f 08                	jg     801116 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80110e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801116:	83 ec 0c             	sub    $0xc,%esp
  801119:	50                   	push   %eax
  80111a:	6a 13                	push   $0x13
  80111c:	68 a8 36 80 00       	push   $0x8036a8
  801121:	6a 43                	push   $0x43
  801123:	68 c5 36 80 00       	push   $0x8036c5
  801128:	e8 e4 f0 ff ff       	call   800211 <_panic>

0080112d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
	asm volatile("int %1\n"
  801133:	b9 00 00 00 00       	mov    $0x0,%ecx
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	b8 14 00 00 00       	mov    $0x14,%eax
  801140:	89 cb                	mov    %ecx,%ebx
  801142:	89 cf                	mov    %ecx,%edi
  801144:	89 ce                	mov    %ecx,%esi
  801146:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801148:	5b                   	pop    %ebx
  801149:	5e                   	pop    %esi
  80114a:	5f                   	pop    %edi
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	53                   	push   %ebx
  801151:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801154:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80115b:	f6 c5 04             	test   $0x4,%ch
  80115e:	75 45                	jne    8011a5 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801160:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801167:	83 e1 07             	and    $0x7,%ecx
  80116a:	83 f9 07             	cmp    $0x7,%ecx
  80116d:	74 6f                	je     8011de <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80116f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801176:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80117c:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801182:	0f 84 b6 00 00 00    	je     80123e <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  801188:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80118f:	83 e1 05             	and    $0x5,%ecx
  801192:	83 f9 05             	cmp    $0x5,%ecx
  801195:	0f 84 d7 00 00 00    	je     801272 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80119b:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011a5:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011ac:	c1 e2 0c             	shl    $0xc,%edx
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011b8:	51                   	push   %ecx
  8011b9:	52                   	push   %edx
  8011ba:	50                   	push   %eax
  8011bb:	52                   	push   %edx
  8011bc:	6a 00                	push   $0x0
  8011be:	e8 d8 fc ff ff       	call   800e9b <sys_page_map>
		if(r < 0)
  8011c3:	83 c4 20             	add    $0x20,%esp
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	79 d1                	jns    80119b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	68 d3 36 80 00       	push   $0x8036d3
  8011d2:	6a 54                	push   $0x54
  8011d4:	68 e9 36 80 00       	push   $0x8036e9
  8011d9:	e8 33 f0 ff ff       	call   800211 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011de:	89 d3                	mov    %edx,%ebx
  8011e0:	c1 e3 0c             	shl    $0xc,%ebx
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	68 05 08 00 00       	push   $0x805
  8011eb:	53                   	push   %ebx
  8011ec:	50                   	push   %eax
  8011ed:	53                   	push   %ebx
  8011ee:	6a 00                	push   $0x0
  8011f0:	e8 a6 fc ff ff       	call   800e9b <sys_page_map>
		if(r < 0)
  8011f5:	83 c4 20             	add    $0x20,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	78 2e                	js     80122a <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  8011fc:	83 ec 0c             	sub    $0xc,%esp
  8011ff:	68 05 08 00 00       	push   $0x805
  801204:	53                   	push   %ebx
  801205:	6a 00                	push   $0x0
  801207:	53                   	push   %ebx
  801208:	6a 00                	push   $0x0
  80120a:	e8 8c fc ff ff       	call   800e9b <sys_page_map>
		if(r < 0)
  80120f:	83 c4 20             	add    $0x20,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	79 85                	jns    80119b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801216:	83 ec 04             	sub    $0x4,%esp
  801219:	68 d3 36 80 00       	push   $0x8036d3
  80121e:	6a 5f                	push   $0x5f
  801220:	68 e9 36 80 00       	push   $0x8036e9
  801225:	e8 e7 ef ff ff       	call   800211 <_panic>
			panic("sys_page_map() panic\n");
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	68 d3 36 80 00       	push   $0x8036d3
  801232:	6a 5b                	push   $0x5b
  801234:	68 e9 36 80 00       	push   $0x8036e9
  801239:	e8 d3 ef ff ff       	call   800211 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80123e:	c1 e2 0c             	shl    $0xc,%edx
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	68 05 08 00 00       	push   $0x805
  801249:	52                   	push   %edx
  80124a:	50                   	push   %eax
  80124b:	52                   	push   %edx
  80124c:	6a 00                	push   $0x0
  80124e:	e8 48 fc ff ff       	call   800e9b <sys_page_map>
		if(r < 0)
  801253:	83 c4 20             	add    $0x20,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	0f 89 3d ff ff ff    	jns    80119b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80125e:	83 ec 04             	sub    $0x4,%esp
  801261:	68 d3 36 80 00       	push   $0x8036d3
  801266:	6a 66                	push   $0x66
  801268:	68 e9 36 80 00       	push   $0x8036e9
  80126d:	e8 9f ef ff ff       	call   800211 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801272:	c1 e2 0c             	shl    $0xc,%edx
  801275:	83 ec 0c             	sub    $0xc,%esp
  801278:	6a 05                	push   $0x5
  80127a:	52                   	push   %edx
  80127b:	50                   	push   %eax
  80127c:	52                   	push   %edx
  80127d:	6a 00                	push   $0x0
  80127f:	e8 17 fc ff ff       	call   800e9b <sys_page_map>
		if(r < 0)
  801284:	83 c4 20             	add    $0x20,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	0f 89 0c ff ff ff    	jns    80119b <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80128f:	83 ec 04             	sub    $0x4,%esp
  801292:	68 d3 36 80 00       	push   $0x8036d3
  801297:	6a 6d                	push   $0x6d
  801299:	68 e9 36 80 00       	push   $0x8036e9
  80129e:	e8 6e ef ff ff       	call   800211 <_panic>

008012a3 <pgfault>:
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012ad:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012af:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012b3:	0f 84 99 00 00 00    	je     801352 <pgfault+0xaf>
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	c1 ea 16             	shr    $0x16,%edx
  8012be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012c5:	f6 c2 01             	test   $0x1,%dl
  8012c8:	0f 84 84 00 00 00    	je     801352 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	c1 ea 0c             	shr    $0xc,%edx
  8012d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012da:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012e0:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8012e6:	75 6a                	jne    801352 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ed:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8012ef:	83 ec 04             	sub    $0x4,%esp
  8012f2:	6a 07                	push   $0x7
  8012f4:	68 00 f0 7f 00       	push   $0x7ff000
  8012f9:	6a 00                	push   $0x0
  8012fb:	e8 58 fb ff ff       	call   800e58 <sys_page_alloc>
	if(ret < 0)
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 5f                	js     801366 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801307:	83 ec 04             	sub    $0x4,%esp
  80130a:	68 00 10 00 00       	push   $0x1000
  80130f:	53                   	push   %ebx
  801310:	68 00 f0 7f 00       	push   $0x7ff000
  801315:	e8 3c f9 ff ff       	call   800c56 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80131a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801321:	53                   	push   %ebx
  801322:	6a 00                	push   $0x0
  801324:	68 00 f0 7f 00       	push   $0x7ff000
  801329:	6a 00                	push   $0x0
  80132b:	e8 6b fb ff ff       	call   800e9b <sys_page_map>
	if(ret < 0)
  801330:	83 c4 20             	add    $0x20,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 43                	js     80137a <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	68 00 f0 7f 00       	push   $0x7ff000
  80133f:	6a 00                	push   $0x0
  801341:	e8 97 fb ff ff       	call   800edd <sys_page_unmap>
	if(ret < 0)
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 41                	js     80138e <pgfault+0xeb>
}
  80134d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801350:	c9                   	leave  
  801351:	c3                   	ret    
		panic("panic at pgfault()\n");
  801352:	83 ec 04             	sub    $0x4,%esp
  801355:	68 f4 36 80 00       	push   $0x8036f4
  80135a:	6a 26                	push   $0x26
  80135c:	68 e9 36 80 00       	push   $0x8036e9
  801361:	e8 ab ee ff ff       	call   800211 <_panic>
		panic("panic in sys_page_alloc()\n");
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	68 08 37 80 00       	push   $0x803708
  80136e:	6a 31                	push   $0x31
  801370:	68 e9 36 80 00       	push   $0x8036e9
  801375:	e8 97 ee ff ff       	call   800211 <_panic>
		panic("panic in sys_page_map()\n");
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	68 23 37 80 00       	push   $0x803723
  801382:	6a 36                	push   $0x36
  801384:	68 e9 36 80 00       	push   $0x8036e9
  801389:	e8 83 ee ff ff       	call   800211 <_panic>
		panic("panic in sys_page_unmap()\n");
  80138e:	83 ec 04             	sub    $0x4,%esp
  801391:	68 3c 37 80 00       	push   $0x80373c
  801396:	6a 39                	push   $0x39
  801398:	68 e9 36 80 00       	push   $0x8036e9
  80139d:	e8 6f ee ff ff       	call   800211 <_panic>

008013a2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	57                   	push   %edi
  8013a6:	56                   	push   %esi
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013ab:	68 a3 12 80 00       	push   $0x8012a3
  8013b0:	e8 4a 1a 00 00       	call   802dff <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013b5:	b8 07 00 00 00       	mov    $0x7,%eax
  8013ba:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 2a                	js     8013ed <fork+0x4b>
  8013c3:	89 c6                	mov    %eax,%esi
  8013c5:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013c7:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013cc:	75 4b                	jne    801419 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013ce:	e8 47 fa ff ff       	call   800e1a <sys_getenvid>
  8013d3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013d8:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8013de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013e3:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8013e8:	e9 90 00 00 00       	jmp    80147d <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	68 58 37 80 00       	push   $0x803758
  8013f5:	68 8c 00 00 00       	push   $0x8c
  8013fa:	68 e9 36 80 00       	push   $0x8036e9
  8013ff:	e8 0d ee ff ff       	call   800211 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801404:	89 f8                	mov    %edi,%eax
  801406:	e8 42 fd ff ff       	call   80114d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80140b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801411:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801417:	74 26                	je     80143f <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	c1 e8 16             	shr    $0x16,%eax
  80141e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801425:	a8 01                	test   $0x1,%al
  801427:	74 e2                	je     80140b <fork+0x69>
  801429:	89 da                	mov    %ebx,%edx
  80142b:	c1 ea 0c             	shr    $0xc,%edx
  80142e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801435:	83 e0 05             	and    $0x5,%eax
  801438:	83 f8 05             	cmp    $0x5,%eax
  80143b:	75 ce                	jne    80140b <fork+0x69>
  80143d:	eb c5                	jmp    801404 <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	6a 07                	push   $0x7
  801444:	68 00 f0 bf ee       	push   $0xeebff000
  801449:	56                   	push   %esi
  80144a:	e8 09 fa ff ff       	call   800e58 <sys_page_alloc>
	if(ret < 0)
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 31                	js     801487 <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	68 6e 2e 80 00       	push   $0x802e6e
  80145e:	56                   	push   %esi
  80145f:	e8 3f fb ff ff       	call   800fa3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 33                	js     80149e <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	6a 02                	push   $0x2
  801470:	56                   	push   %esi
  801471:	e8 a9 fa ff ff       	call   800f1f <sys_env_set_status>
	if(ret < 0)
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 38                	js     8014b5 <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  80147d:	89 f0                	mov    %esi,%eax
  80147f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5f                   	pop    %edi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	68 08 37 80 00       	push   $0x803708
  80148f:	68 98 00 00 00       	push   $0x98
  801494:	68 e9 36 80 00       	push   $0x8036e9
  801499:	e8 73 ed ff ff       	call   800211 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	68 7c 37 80 00       	push   $0x80377c
  8014a6:	68 9b 00 00 00       	push   $0x9b
  8014ab:	68 e9 36 80 00       	push   $0x8036e9
  8014b0:	e8 5c ed ff ff       	call   800211 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	68 a4 37 80 00       	push   $0x8037a4
  8014bd:	68 9e 00 00 00       	push   $0x9e
  8014c2:	68 e9 36 80 00       	push   $0x8036e9
  8014c7:	e8 45 ed ff ff       	call   800211 <_panic>

008014cc <sfork>:

// Challenge!
int
sfork(void)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014d5:	68 a3 12 80 00       	push   $0x8012a3
  8014da:	e8 20 19 00 00       	call   802dff <set_pgfault_handler>
  8014df:	b8 07 00 00 00       	mov    $0x7,%eax
  8014e4:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 2a                	js     801517 <sfork+0x4b>
  8014ed:	89 c7                	mov    %eax,%edi
  8014ef:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014f1:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8014f6:	75 58                	jne    801550 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014f8:	e8 1d f9 ff ff       	call   800e1a <sys_getenvid>
  8014fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  801502:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801508:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80150d:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801512:	e9 d4 00 00 00       	jmp    8015eb <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 58 37 80 00       	push   $0x803758
  80151f:	68 af 00 00 00       	push   $0xaf
  801524:	68 e9 36 80 00       	push   $0x8036e9
  801529:	e8 e3 ec ff ff       	call   800211 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80152e:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801533:	89 f0                	mov    %esi,%eax
  801535:	e8 13 fc ff ff       	call   80114d <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80153a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801540:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801546:	77 65                	ja     8015ad <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801548:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80154e:	74 de                	je     80152e <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801550:	89 d8                	mov    %ebx,%eax
  801552:	c1 e8 16             	shr    $0x16,%eax
  801555:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80155c:	a8 01                	test   $0x1,%al
  80155e:	74 da                	je     80153a <sfork+0x6e>
  801560:	89 da                	mov    %ebx,%edx
  801562:	c1 ea 0c             	shr    $0xc,%edx
  801565:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80156c:	83 e0 05             	and    $0x5,%eax
  80156f:	83 f8 05             	cmp    $0x5,%eax
  801572:	75 c6                	jne    80153a <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  801574:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  80157b:	c1 e2 0c             	shl    $0xc,%edx
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	83 e0 07             	and    $0x7,%eax
  801584:	50                   	push   %eax
  801585:	52                   	push   %edx
  801586:	56                   	push   %esi
  801587:	52                   	push   %edx
  801588:	6a 00                	push   $0x0
  80158a:	e8 0c f9 ff ff       	call   800e9b <sys_page_map>
  80158f:	83 c4 20             	add    $0x20,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	74 a4                	je     80153a <sfork+0x6e>
				panic("sys_page_map() panic\n");
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	68 d3 36 80 00       	push   $0x8036d3
  80159e:	68 ba 00 00 00       	push   $0xba
  8015a3:	68 e9 36 80 00       	push   $0x8036e9
  8015a8:	e8 64 ec ff ff       	call   800211 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	6a 07                	push   $0x7
  8015b2:	68 00 f0 bf ee       	push   $0xeebff000
  8015b7:	57                   	push   %edi
  8015b8:	e8 9b f8 ff ff       	call   800e58 <sys_page_alloc>
	if(ret < 0)
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 31                	js     8015f5 <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	68 6e 2e 80 00       	push   $0x802e6e
  8015cc:	57                   	push   %edi
  8015cd:	e8 d1 f9 ff ff       	call   800fa3 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 33                	js     80160c <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	6a 02                	push   $0x2
  8015de:	57                   	push   %edi
  8015df:	e8 3b f9 ff ff       	call   800f1f <sys_env_set_status>
	if(ret < 0)
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 38                	js     801623 <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  8015eb:	89 f8                	mov    %edi,%eax
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 08 37 80 00       	push   $0x803708
  8015fd:	68 c0 00 00 00       	push   $0xc0
  801602:	68 e9 36 80 00       	push   $0x8036e9
  801607:	e8 05 ec ff ff       	call   800211 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 7c 37 80 00       	push   $0x80377c
  801614:	68 c3 00 00 00       	push   $0xc3
  801619:	68 e9 36 80 00       	push   $0x8036e9
  80161e:	e8 ee eb ff ff       	call   800211 <_panic>
		panic("panic in sys_env_set_status()\n");
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 a4 37 80 00       	push   $0x8037a4
  80162b:	68 c6 00 00 00       	push   $0xc6
  801630:	68 e9 36 80 00       	push   $0x8036e9
  801635:	e8 d7 eb ff ff       	call   800211 <_panic>

0080163a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	05 00 00 00 30       	add    $0x30000000,%eax
  801645:	c1 e8 0c             	shr    $0xc,%eax
}
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801655:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80165a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    

00801661 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801669:	89 c2                	mov    %eax,%edx
  80166b:	c1 ea 16             	shr    $0x16,%edx
  80166e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801675:	f6 c2 01             	test   $0x1,%dl
  801678:	74 2d                	je     8016a7 <fd_alloc+0x46>
  80167a:	89 c2                	mov    %eax,%edx
  80167c:	c1 ea 0c             	shr    $0xc,%edx
  80167f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801686:	f6 c2 01             	test   $0x1,%dl
  801689:	74 1c                	je     8016a7 <fd_alloc+0x46>
  80168b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801690:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801695:	75 d2                	jne    801669 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016a0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016a5:	eb 0a                	jmp    8016b1 <fd_alloc+0x50>
			*fd_store = fd;
  8016a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016b9:	83 f8 1f             	cmp    $0x1f,%eax
  8016bc:	77 30                	ja     8016ee <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016be:	c1 e0 0c             	shl    $0xc,%eax
  8016c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016c6:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016cc:	f6 c2 01             	test   $0x1,%dl
  8016cf:	74 24                	je     8016f5 <fd_lookup+0x42>
  8016d1:	89 c2                	mov    %eax,%edx
  8016d3:	c1 ea 0c             	shr    $0xc,%edx
  8016d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016dd:	f6 c2 01             	test   $0x1,%dl
  8016e0:	74 1a                	je     8016fc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e5:	89 02                	mov    %eax,(%edx)
	return 0;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	5d                   	pop    %ebp
  8016ed:	c3                   	ret    
		return -E_INVAL;
  8016ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f3:	eb f7                	jmp    8016ec <fd_lookup+0x39>
		return -E_INVAL;
  8016f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016fa:	eb f0                	jmp    8016ec <fd_lookup+0x39>
  8016fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801701:	eb e9                	jmp    8016ec <fd_lookup+0x39>

00801703 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801716:	39 08                	cmp    %ecx,(%eax)
  801718:	74 38                	je     801752 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80171a:	83 c2 01             	add    $0x1,%edx
  80171d:	8b 04 95 40 38 80 00 	mov    0x803840(,%edx,4),%eax
  801724:	85 c0                	test   %eax,%eax
  801726:	75 ee                	jne    801716 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801728:	a1 08 50 80 00       	mov    0x805008,%eax
  80172d:	8b 40 48             	mov    0x48(%eax),%eax
  801730:	83 ec 04             	sub    $0x4,%esp
  801733:	51                   	push   %ecx
  801734:	50                   	push   %eax
  801735:	68 c4 37 80 00       	push   $0x8037c4
  80173a:	e8 c8 eb ff ff       	call   800307 <cprintf>
	*dev = 0;
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    
			*dev = devtab[i];
  801752:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801755:	89 01                	mov    %eax,(%ecx)
			return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	eb f2                	jmp    801750 <dev_lookup+0x4d>

0080175e <fd_close>:
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	57                   	push   %edi
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 24             	sub    $0x24,%esp
  801767:	8b 75 08             	mov    0x8(%ebp),%esi
  80176a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80176d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801770:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801771:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801777:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80177a:	50                   	push   %eax
  80177b:	e8 33 ff ff ff       	call   8016b3 <fd_lookup>
  801780:	89 c3                	mov    %eax,%ebx
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 05                	js     80178e <fd_close+0x30>
	    || fd != fd2)
  801789:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80178c:	74 16                	je     8017a4 <fd_close+0x46>
		return (must_exist ? r : 0);
  80178e:	89 f8                	mov    %edi,%eax
  801790:	84 c0                	test   %al,%al
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	0f 44 d8             	cmove  %eax,%ebx
}
  80179a:	89 d8                	mov    %ebx,%eax
  80179c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017aa:	50                   	push   %eax
  8017ab:	ff 36                	pushl  (%esi)
  8017ad:	e8 51 ff ff ff       	call   801703 <dev_lookup>
  8017b2:	89 c3                	mov    %eax,%ebx
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 1a                	js     8017d5 <fd_close+0x77>
		if (dev->dev_close)
  8017bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017be:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	74 0b                	je     8017d5 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017ca:	83 ec 0c             	sub    $0xc,%esp
  8017cd:	56                   	push   %esi
  8017ce:	ff d0                	call   *%eax
  8017d0:	89 c3                	mov    %eax,%ebx
  8017d2:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	56                   	push   %esi
  8017d9:	6a 00                	push   $0x0
  8017db:	e8 fd f6 ff ff       	call   800edd <sys_page_unmap>
	return r;
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	eb b5                	jmp    80179a <fd_close+0x3c>

008017e5 <close>:

int
close(int fdnum)
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	e8 bc fe ff ff       	call   8016b3 <fd_lookup>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	79 02                	jns    801800 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    
		return fd_close(fd, 1);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	6a 01                	push   $0x1
  801805:	ff 75 f4             	pushl  -0xc(%ebp)
  801808:	e8 51 ff ff ff       	call   80175e <fd_close>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb ec                	jmp    8017fe <close+0x19>

00801812 <close_all>:

void
close_all(void)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	53                   	push   %ebx
  801816:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801819:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80181e:	83 ec 0c             	sub    $0xc,%esp
  801821:	53                   	push   %ebx
  801822:	e8 be ff ff ff       	call   8017e5 <close>
	for (i = 0; i < MAXFD; i++)
  801827:	83 c3 01             	add    $0x1,%ebx
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	83 fb 20             	cmp    $0x20,%ebx
  801830:	75 ec                	jne    80181e <close_all+0xc>
}
  801832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	57                   	push   %edi
  80183b:	56                   	push   %esi
  80183c:	53                   	push   %ebx
  80183d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801840:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801843:	50                   	push   %eax
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	e8 67 fe ff ff       	call   8016b3 <fd_lookup>
  80184c:	89 c3                	mov    %eax,%ebx
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	85 c0                	test   %eax,%eax
  801853:	0f 88 81 00 00 00    	js     8018da <dup+0xa3>
		return r;
	close(newfdnum);
  801859:	83 ec 0c             	sub    $0xc,%esp
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	e8 81 ff ff ff       	call   8017e5 <close>

	newfd = INDEX2FD(newfdnum);
  801864:	8b 75 0c             	mov    0xc(%ebp),%esi
  801867:	c1 e6 0c             	shl    $0xc,%esi
  80186a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801870:	83 c4 04             	add    $0x4,%esp
  801873:	ff 75 e4             	pushl  -0x1c(%ebp)
  801876:	e8 cf fd ff ff       	call   80164a <fd2data>
  80187b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80187d:	89 34 24             	mov    %esi,(%esp)
  801880:	e8 c5 fd ff ff       	call   80164a <fd2data>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80188a:	89 d8                	mov    %ebx,%eax
  80188c:	c1 e8 16             	shr    $0x16,%eax
  80188f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801896:	a8 01                	test   $0x1,%al
  801898:	74 11                	je     8018ab <dup+0x74>
  80189a:	89 d8                	mov    %ebx,%eax
  80189c:	c1 e8 0c             	shr    $0xc,%eax
  80189f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018a6:	f6 c2 01             	test   $0x1,%dl
  8018a9:	75 39                	jne    8018e4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	c1 e8 0c             	shr    $0xc,%eax
  8018b3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	25 07 0e 00 00       	and    $0xe07,%eax
  8018c2:	50                   	push   %eax
  8018c3:	56                   	push   %esi
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 cd f5 ff ff       	call   800e9b <sys_page_map>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	83 c4 20             	add    $0x20,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 31                	js     801908 <dup+0xd1>
		goto err;

	return newfdnum;
  8018d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018da:	89 d8                	mov    %ebx,%eax
  8018dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5f                   	pop    %edi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8018f3:	50                   	push   %eax
  8018f4:	57                   	push   %edi
  8018f5:	6a 00                	push   $0x0
  8018f7:	53                   	push   %ebx
  8018f8:	6a 00                	push   $0x0
  8018fa:	e8 9c f5 ff ff       	call   800e9b <sys_page_map>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 20             	add    $0x20,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	79 a3                	jns    8018ab <dup+0x74>
	sys_page_unmap(0, newfd);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	56                   	push   %esi
  80190c:	6a 00                	push   $0x0
  80190e:	e8 ca f5 ff ff       	call   800edd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801913:	83 c4 08             	add    $0x8,%esp
  801916:	57                   	push   %edi
  801917:	6a 00                	push   $0x0
  801919:	e8 bf f5 ff ff       	call   800edd <sys_page_unmap>
	return r;
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	eb b7                	jmp    8018da <dup+0xa3>

00801923 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	53                   	push   %ebx
  801927:	83 ec 1c             	sub    $0x1c,%esp
  80192a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80192d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	53                   	push   %ebx
  801932:	e8 7c fd ff ff       	call   8016b3 <fd_lookup>
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 3f                	js     80197d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193e:	83 ec 08             	sub    $0x8,%esp
  801941:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801944:	50                   	push   %eax
  801945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801948:	ff 30                	pushl  (%eax)
  80194a:	e8 b4 fd ff ff       	call   801703 <dev_lookup>
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	85 c0                	test   %eax,%eax
  801954:	78 27                	js     80197d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801959:	8b 42 08             	mov    0x8(%edx),%eax
  80195c:	83 e0 03             	and    $0x3,%eax
  80195f:	83 f8 01             	cmp    $0x1,%eax
  801962:	74 1e                	je     801982 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801967:	8b 40 08             	mov    0x8(%eax),%eax
  80196a:	85 c0                	test   %eax,%eax
  80196c:	74 35                	je     8019a3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	ff 75 10             	pushl  0x10(%ebp)
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	52                   	push   %edx
  801978:	ff d0                	call   *%eax
  80197a:	83 c4 10             	add    $0x10,%esp
}
  80197d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801980:	c9                   	leave  
  801981:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801982:	a1 08 50 80 00       	mov    0x805008,%eax
  801987:	8b 40 48             	mov    0x48(%eax),%eax
  80198a:	83 ec 04             	sub    $0x4,%esp
  80198d:	53                   	push   %ebx
  80198e:	50                   	push   %eax
  80198f:	68 05 38 80 00       	push   $0x803805
  801994:	e8 6e e9 ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a1:	eb da                	jmp    80197d <read+0x5a>
		return -E_NOT_SUPP;
  8019a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a8:	eb d3                	jmp    80197d <read+0x5a>

008019aa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	57                   	push   %edi
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019b6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019be:	39 f3                	cmp    %esi,%ebx
  8019c0:	73 23                	jae    8019e5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	89 f0                	mov    %esi,%eax
  8019c7:	29 d8                	sub    %ebx,%eax
  8019c9:	50                   	push   %eax
  8019ca:	89 d8                	mov    %ebx,%eax
  8019cc:	03 45 0c             	add    0xc(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	57                   	push   %edi
  8019d1:	e8 4d ff ff ff       	call   801923 <read>
		if (m < 0)
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 06                	js     8019e3 <readn+0x39>
			return m;
		if (m == 0)
  8019dd:	74 06                	je     8019e5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019df:	01 c3                	add    %eax,%ebx
  8019e1:	eb db                	jmp    8019be <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019e3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019e5:	89 d8                	mov    %ebx,%eax
  8019e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5f                   	pop    %edi
  8019ed:	5d                   	pop    %ebp
  8019ee:	c3                   	ret    

008019ef <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 1c             	sub    $0x1c,%esp
  8019f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fc:	50                   	push   %eax
  8019fd:	53                   	push   %ebx
  8019fe:	e8 b0 fc ff ff       	call   8016b3 <fd_lookup>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 3a                	js     801a44 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a14:	ff 30                	pushl  (%eax)
  801a16:	e8 e8 fc ff ff       	call   801703 <dev_lookup>
  801a1b:	83 c4 10             	add    $0x10,%esp
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 22                	js     801a44 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a25:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a29:	74 1e                	je     801a49 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a31:	85 d2                	test   %edx,%edx
  801a33:	74 35                	je     801a6a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	ff 75 10             	pushl  0x10(%ebp)
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	50                   	push   %eax
  801a3f:	ff d2                	call   *%edx
  801a41:	83 c4 10             	add    $0x10,%esp
}
  801a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a49:	a1 08 50 80 00       	mov    0x805008,%eax
  801a4e:	8b 40 48             	mov    0x48(%eax),%eax
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	53                   	push   %ebx
  801a55:	50                   	push   %eax
  801a56:	68 21 38 80 00       	push   $0x803821
  801a5b:	e8 a7 e8 ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a68:	eb da                	jmp    801a44 <write+0x55>
		return -E_NOT_SUPP;
  801a6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6f:	eb d3                	jmp    801a44 <write+0x55>

00801a71 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7a:	50                   	push   %eax
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 30 fc ff ff       	call   8016b3 <fd_lookup>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 0e                	js     801a98 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a90:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 1c             	sub    $0x1c,%esp
  801aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	53                   	push   %ebx
  801aa9:	e8 05 fc ff ff       	call   8016b3 <fd_lookup>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 37                	js     801aec <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abb:	50                   	push   %eax
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	ff 30                	pushl  (%eax)
  801ac1:	e8 3d fc ff ff       	call   801703 <dev_lookup>
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	85 c0                	test   %eax,%eax
  801acb:	78 1f                	js     801aec <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ad4:	74 1b                	je     801af1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad9:	8b 52 18             	mov    0x18(%edx),%edx
  801adc:	85 d2                	test   %edx,%edx
  801ade:	74 32                	je     801b12 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	50                   	push   %eax
  801ae7:	ff d2                	call   *%edx
  801ae9:	83 c4 10             	add    $0x10,%esp
}
  801aec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    
			thisenv->env_id, fdnum);
  801af1:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af6:	8b 40 48             	mov    0x48(%eax),%eax
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	53                   	push   %ebx
  801afd:	50                   	push   %eax
  801afe:	68 e4 37 80 00       	push   $0x8037e4
  801b03:	e8 ff e7 ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b10:	eb da                	jmp    801aec <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b17:	eb d3                	jmp    801aec <ftruncate+0x52>

00801b19 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	53                   	push   %ebx
  801b1d:	83 ec 1c             	sub    $0x1c,%esp
  801b20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b23:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b26:	50                   	push   %eax
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	e8 84 fb ff ff       	call   8016b3 <fd_lookup>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	78 4b                	js     801b81 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b36:	83 ec 08             	sub    $0x8,%esp
  801b39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3c:	50                   	push   %eax
  801b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b40:	ff 30                	pushl  (%eax)
  801b42:	e8 bc fb ff ff       	call   801703 <dev_lookup>
  801b47:	83 c4 10             	add    $0x10,%esp
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	78 33                	js     801b81 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b51:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b55:	74 2f                	je     801b86 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b57:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b5a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b61:	00 00 00 
	stat->st_isdir = 0;
  801b64:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b6b:	00 00 00 
	stat->st_dev = dev;
  801b6e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	53                   	push   %ebx
  801b78:	ff 75 f0             	pushl  -0x10(%ebp)
  801b7b:	ff 50 14             	call   *0x14(%eax)
  801b7e:	83 c4 10             	add    $0x10,%esp
}
  801b81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    
		return -E_NOT_SUPP;
  801b86:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8b:	eb f4                	jmp    801b81 <fstat+0x68>

00801b8d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	56                   	push   %esi
  801b91:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	6a 00                	push   $0x0
  801b97:	ff 75 08             	pushl  0x8(%ebp)
  801b9a:	e8 22 02 00 00       	call   801dc1 <open>
  801b9f:	89 c3                	mov    %eax,%ebx
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 1b                	js     801bc3 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	50                   	push   %eax
  801baf:	e8 65 ff ff ff       	call   801b19 <fstat>
  801bb4:	89 c6                	mov    %eax,%esi
	close(fd);
  801bb6:	89 1c 24             	mov    %ebx,(%esp)
  801bb9:	e8 27 fc ff ff       	call   8017e5 <close>
	return r;
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	89 f3                	mov    %esi,%ebx
}
  801bc3:	89 d8                	mov    %ebx,%eax
  801bc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
  801bd1:	89 c6                	mov    %eax,%esi
  801bd3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bd5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bdc:	74 27                	je     801c05 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bde:	6a 07                	push   $0x7
  801be0:	68 00 60 80 00       	push   $0x806000
  801be5:	56                   	push   %esi
  801be6:	ff 35 00 50 80 00    	pushl  0x805000
  801bec:	e8 0c 13 00 00       	call   802efd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bf1:	83 c4 0c             	add    $0xc,%esp
  801bf4:	6a 00                	push   $0x0
  801bf6:	53                   	push   %ebx
  801bf7:	6a 00                	push   $0x0
  801bf9:	e8 96 12 00 00       	call   802e94 <ipc_recv>
}
  801bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5e                   	pop    %esi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	6a 01                	push   $0x1
  801c0a:	e8 46 13 00 00       	call   802f55 <ipc_find_env>
  801c0f:	a3 00 50 80 00       	mov    %eax,0x805000
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	eb c5                	jmp    801bde <fsipc+0x12>

00801c19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	8b 40 0c             	mov    0xc(%eax),%eax
  801c25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c32:	ba 00 00 00 00       	mov    $0x0,%edx
  801c37:	b8 02 00 00 00       	mov    $0x2,%eax
  801c3c:	e8 8b ff ff ff       	call   801bcc <fsipc>
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <devfile_flush>:
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c54:	ba 00 00 00 00       	mov    $0x0,%edx
  801c59:	b8 06 00 00 00       	mov    $0x6,%eax
  801c5e:	e8 69 ff ff ff       	call   801bcc <fsipc>
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <devfile_stat>:
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	8b 40 0c             	mov    0xc(%eax),%eax
  801c75:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c84:	e8 43 ff ff ff       	call   801bcc <fsipc>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	78 2c                	js     801cb9 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	68 00 60 80 00       	push   $0x806000
  801c95:	53                   	push   %ebx
  801c96:	e8 cb ed ff ff       	call   800a66 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c9b:	a1 80 60 80 00       	mov    0x806080,%eax
  801ca0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ca6:	a1 84 60 80 00       	mov    0x806084,%eax
  801cab:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <devfile_write>:
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  801cce:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cd3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cd9:	53                   	push   %ebx
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	68 08 60 80 00       	push   $0x806008
  801ce2:	e8 6f ef ff ff       	call   800c56 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cec:	b8 04 00 00 00       	mov    $0x4,%eax
  801cf1:	e8 d6 fe ff ff       	call   801bcc <fsipc>
  801cf6:	83 c4 10             	add    $0x10,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 0b                	js     801d08 <devfile_write+0x4a>
	assert(r <= n);
  801cfd:	39 d8                	cmp    %ebx,%eax
  801cff:	77 0c                	ja     801d0d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d01:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d06:	7f 1e                	jg     801d26 <devfile_write+0x68>
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    
	assert(r <= n);
  801d0d:	68 54 38 80 00       	push   $0x803854
  801d12:	68 5b 38 80 00       	push   $0x80385b
  801d17:	68 98 00 00 00       	push   $0x98
  801d1c:	68 70 38 80 00       	push   $0x803870
  801d21:	e8 eb e4 ff ff       	call   800211 <_panic>
	assert(r <= PGSIZE);
  801d26:	68 7b 38 80 00       	push   $0x80387b
  801d2b:	68 5b 38 80 00       	push   $0x80385b
  801d30:	68 99 00 00 00       	push   $0x99
  801d35:	68 70 38 80 00       	push   $0x803870
  801d3a:	e8 d2 e4 ff ff       	call   800211 <_panic>

00801d3f <devfile_read>:
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d52:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d58:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5d:	b8 03 00 00 00       	mov    $0x3,%eax
  801d62:	e8 65 fe ff ff       	call   801bcc <fsipc>
  801d67:	89 c3                	mov    %eax,%ebx
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	78 1f                	js     801d8c <devfile_read+0x4d>
	assert(r <= n);
  801d6d:	39 f0                	cmp    %esi,%eax
  801d6f:	77 24                	ja     801d95 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d71:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d76:	7f 33                	jg     801dab <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	50                   	push   %eax
  801d7c:	68 00 60 80 00       	push   $0x806000
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	e8 6b ee ff ff       	call   800bf4 <memmove>
	return r;
  801d89:	83 c4 10             	add    $0x10,%esp
}
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    
	assert(r <= n);
  801d95:	68 54 38 80 00       	push   $0x803854
  801d9a:	68 5b 38 80 00       	push   $0x80385b
  801d9f:	6a 7c                	push   $0x7c
  801da1:	68 70 38 80 00       	push   $0x803870
  801da6:	e8 66 e4 ff ff       	call   800211 <_panic>
	assert(r <= PGSIZE);
  801dab:	68 7b 38 80 00       	push   $0x80387b
  801db0:	68 5b 38 80 00       	push   $0x80385b
  801db5:	6a 7d                	push   $0x7d
  801db7:	68 70 38 80 00       	push   $0x803870
  801dbc:	e8 50 e4 ff ff       	call   800211 <_panic>

00801dc1 <open>:
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	56                   	push   %esi
  801dc5:	53                   	push   %ebx
  801dc6:	83 ec 1c             	sub    $0x1c,%esp
  801dc9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801dcc:	56                   	push   %esi
  801dcd:	e8 5b ec ff ff       	call   800a2d <strlen>
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801dda:	7f 6c                	jg     801e48 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de2:	50                   	push   %eax
  801de3:	e8 79 f8 ff ff       	call   801661 <fd_alloc>
  801de8:	89 c3                	mov    %eax,%ebx
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 3c                	js     801e2d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801df1:	83 ec 08             	sub    $0x8,%esp
  801df4:	56                   	push   %esi
  801df5:	68 00 60 80 00       	push   $0x806000
  801dfa:	e8 67 ec ff ff       	call   800a66 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	e8 b8 fd ff ff       	call   801bcc <fsipc>
  801e14:	89 c3                	mov    %eax,%ebx
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 19                	js     801e36 <open+0x75>
	return fd2num(fd);
  801e1d:	83 ec 0c             	sub    $0xc,%esp
  801e20:	ff 75 f4             	pushl  -0xc(%ebp)
  801e23:	e8 12 f8 ff ff       	call   80163a <fd2num>
  801e28:	89 c3                	mov    %eax,%ebx
  801e2a:	83 c4 10             	add    $0x10,%esp
}
  801e2d:	89 d8                	mov    %ebx,%eax
  801e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5d                   	pop    %ebp
  801e35:	c3                   	ret    
		fd_close(fd, 0);
  801e36:	83 ec 08             	sub    $0x8,%esp
  801e39:	6a 00                	push   $0x0
  801e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3e:	e8 1b f9 ff ff       	call   80175e <fd_close>
		return r;
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	eb e5                	jmp    801e2d <open+0x6c>
		return -E_BAD_PATH;
  801e48:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e4d:	eb de                	jmp    801e2d <open+0x6c>

00801e4f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e55:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e5f:	e8 68 fd ff ff       	call   801bcc <fsipc>
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	57                   	push   %edi
  801e6a:	56                   	push   %esi
  801e6b:	53                   	push   %ebx
  801e6c:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e72:	68 60 39 80 00       	push   $0x803960
  801e77:	68 db 32 80 00       	push   $0x8032db
  801e7c:	e8 86 e4 ff ff       	call   800307 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e81:	83 c4 08             	add    $0x8,%esp
  801e84:	6a 00                	push   $0x0
  801e86:	ff 75 08             	pushl  0x8(%ebp)
  801e89:	e8 33 ff ff ff       	call   801dc1 <open>
  801e8e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	0f 88 0b 05 00 00    	js     8023aa <spawn+0x544>
  801e9f:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	68 00 02 00 00       	push   $0x200
  801ea9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801eaf:	50                   	push   %eax
  801eb0:	51                   	push   %ecx
  801eb1:	e8 f4 fa ff ff       	call   8019aa <readn>
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ebe:	75 75                	jne    801f35 <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801ec0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ec7:	45 4c 46 
  801eca:	75 69                	jne    801f35 <spawn+0xcf>
  801ecc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ed1:	cd 30                	int    $0x30
  801ed3:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ed9:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	0f 88 b7 04 00 00    	js     80239e <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801ee7:	25 ff 03 00 00       	and    $0x3ff,%eax
  801eec:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801ef2:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801ef8:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801efe:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f05:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f0b:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801f11:	83 ec 08             	sub    $0x8,%esp
  801f14:	68 54 39 80 00       	push   $0x803954
  801f19:	68 db 32 80 00       	push   $0x8032db
  801f1e:	e8 e4 e3 ff ff       	call   800307 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f26:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801f2b:	be 00 00 00 00       	mov    $0x0,%esi
  801f30:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f33:	eb 4b                	jmp    801f80 <spawn+0x11a>
		close(fd);
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f3e:	e8 a2 f8 ff ff       	call   8017e5 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f43:	83 c4 0c             	add    $0xc,%esp
  801f46:	68 7f 45 4c 46       	push   $0x464c457f
  801f4b:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f51:	68 87 38 80 00       	push   $0x803887
  801f56:	e8 ac e3 ff ff       	call   800307 <cprintf>
		return -E_NOT_EXEC;
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f65:	ff ff ff 
  801f68:	e9 3d 04 00 00       	jmp    8023aa <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	50                   	push   %eax
  801f71:	e8 b7 ea ff ff       	call   800a2d <strlen>
  801f76:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801f7a:	83 c3 01             	add    $0x1,%ebx
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801f87:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	75 df                	jne    801f6d <spawn+0x107>
  801f8e:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801f94:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801f9a:	bf 00 10 40 00       	mov    $0x401000,%edi
  801f9f:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801fa1:	89 fa                	mov    %edi,%edx
  801fa3:	83 e2 fc             	and    $0xfffffffc,%edx
  801fa6:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801fad:	29 c2                	sub    %eax,%edx
  801faf:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801fb5:	8d 42 f8             	lea    -0x8(%edx),%eax
  801fb8:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801fbd:	0f 86 0a 04 00 00    	jbe    8023cd <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	6a 07                	push   $0x7
  801fc8:	68 00 00 40 00       	push   $0x400000
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 84 ee ff ff       	call   800e58 <sys_page_alloc>
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	0f 88 f3 03 00 00    	js     8023d2 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801fdf:	be 00 00 00 00       	mov    $0x0,%esi
  801fe4:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801fea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801fed:	eb 30                	jmp    80201f <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801fef:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801ff5:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801ffb:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801ffe:	83 ec 08             	sub    $0x8,%esp
  802001:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802004:	57                   	push   %edi
  802005:	e8 5c ea ff ff       	call   800a66 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80200a:	83 c4 04             	add    $0x4,%esp
  80200d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802010:	e8 18 ea ff ff       	call   800a2d <strlen>
  802015:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802019:	83 c6 01             	add    $0x1,%esi
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802025:	7f c8                	jg     801fef <spawn+0x189>
	}
	argv_store[argc] = 0;
  802027:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80202d:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802033:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80203a:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802040:	0f 85 86 00 00 00    	jne    8020cc <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802046:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  80204c:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  802052:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802055:	89 d0                	mov    %edx,%eax
  802057:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80205d:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802060:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802065:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	6a 07                	push   $0x7
  802070:	68 00 d0 bf ee       	push   $0xeebfd000
  802075:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80207b:	68 00 00 40 00       	push   $0x400000
  802080:	6a 00                	push   $0x0
  802082:	e8 14 ee ff ff       	call   800e9b <sys_page_map>
  802087:	89 c3                	mov    %eax,%ebx
  802089:	83 c4 20             	add    $0x20,%esp
  80208c:	85 c0                	test   %eax,%eax
  80208e:	0f 88 46 03 00 00    	js     8023da <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802094:	83 ec 08             	sub    $0x8,%esp
  802097:	68 00 00 40 00       	push   $0x400000
  80209c:	6a 00                	push   $0x0
  80209e:	e8 3a ee ff ff       	call   800edd <sys_page_unmap>
  8020a3:	89 c3                	mov    %eax,%ebx
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	0f 88 2a 03 00 00    	js     8023da <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8020b0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8020b6:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020bd:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8020c4:	00 00 00 
  8020c7:	e9 4f 01 00 00       	jmp    80221b <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020cc:	68 10 39 80 00       	push   $0x803910
  8020d1:	68 5b 38 80 00       	push   $0x80385b
  8020d6:	68 f8 00 00 00       	push   $0xf8
  8020db:	68 a1 38 80 00       	push   $0x8038a1
  8020e0:	e8 2c e1 ff ff       	call   800211 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020e5:	83 ec 04             	sub    $0x4,%esp
  8020e8:	6a 07                	push   $0x7
  8020ea:	68 00 00 40 00       	push   $0x400000
  8020ef:	6a 00                	push   $0x0
  8020f1:	e8 62 ed ff ff       	call   800e58 <sys_page_alloc>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	0f 88 b7 02 00 00    	js     8023b8 <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802101:	83 ec 08             	sub    $0x8,%esp
  802104:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80210a:	01 f0                	add    %esi,%eax
  80210c:	50                   	push   %eax
  80210d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802113:	e8 59 f9 ff ff       	call   801a71 <seek>
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 88 9c 02 00 00    	js     8023bf <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80212c:	29 f0                	sub    %esi,%eax
  80212e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802133:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802138:	0f 47 c1             	cmova  %ecx,%eax
  80213b:	50                   	push   %eax
  80213c:	68 00 00 40 00       	push   $0x400000
  802141:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802147:	e8 5e f8 ff ff       	call   8019aa <readn>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	0f 88 6f 02 00 00    	js     8023c6 <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802157:	83 ec 0c             	sub    $0xc,%esp
  80215a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802160:	53                   	push   %ebx
  802161:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802167:	68 00 00 40 00       	push   $0x400000
  80216c:	6a 00                	push   $0x0
  80216e:	e8 28 ed ff ff       	call   800e9b <sys_page_map>
  802173:	83 c4 20             	add    $0x20,%esp
  802176:	85 c0                	test   %eax,%eax
  802178:	78 7c                	js     8021f6 <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80217a:	83 ec 08             	sub    $0x8,%esp
  80217d:	68 00 00 40 00       	push   $0x400000
  802182:	6a 00                	push   $0x0
  802184:	e8 54 ed ff ff       	call   800edd <sys_page_unmap>
  802189:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80218c:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802192:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802198:	89 fe                	mov    %edi,%esi
  80219a:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8021a0:	76 69                	jbe    80220b <spawn+0x3a5>
		if (i >= filesz) {
  8021a2:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8021a8:	0f 87 37 ff ff ff    	ja     8020e5 <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021b7:	53                   	push   %ebx
  8021b8:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021be:	e8 95 ec ff ff       	call   800e58 <sys_page_alloc>
  8021c3:	83 c4 10             	add    $0x10,%esp
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	79 c2                	jns    80218c <spawn+0x326>
  8021ca:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8021d5:	e8 ff eb ff ff       	call   800dd9 <sys_env_destroy>
	close(fd);
  8021da:	83 c4 04             	add    $0x4,%esp
  8021dd:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021e3:	e8 fd f5 ff ff       	call   8017e5 <close>
	return r;
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8021f1:	e9 b4 01 00 00       	jmp    8023aa <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  8021f6:	50                   	push   %eax
  8021f7:	68 ad 38 80 00       	push   $0x8038ad
  8021fc:	68 2b 01 00 00       	push   $0x12b
  802201:	68 a1 38 80 00       	push   $0x8038a1
  802206:	e8 06 e0 ff ff       	call   800211 <_panic>
  80220b:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802211:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802218:	83 c6 20             	add    $0x20,%esi
  80221b:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802222:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802228:	7e 6d                	jle    802297 <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  80222a:	83 3e 01             	cmpl   $0x1,(%esi)
  80222d:	75 e2                	jne    802211 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80222f:	8b 46 18             	mov    0x18(%esi),%eax
  802232:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802235:	83 f8 01             	cmp    $0x1,%eax
  802238:	19 c0                	sbb    %eax,%eax
  80223a:	83 e0 fe             	and    $0xfffffffe,%eax
  80223d:	83 c0 07             	add    $0x7,%eax
  802240:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802246:	8b 4e 04             	mov    0x4(%esi),%ecx
  802249:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80224f:	8b 56 10             	mov    0x10(%esi),%edx
  802252:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802258:	8b 7e 14             	mov    0x14(%esi),%edi
  80225b:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802261:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802264:	89 d8                	mov    %ebx,%eax
  802266:	25 ff 0f 00 00       	and    $0xfff,%eax
  80226b:	74 1a                	je     802287 <spawn+0x421>
		va -= i;
  80226d:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80226f:	01 c7                	add    %eax,%edi
  802271:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802277:	01 c2                	add    %eax,%edx
  802279:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80227f:	29 c1                	sub    %eax,%ecx
  802281:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802287:	bf 00 00 00 00       	mov    $0x0,%edi
  80228c:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802292:	e9 01 ff ff ff       	jmp    802198 <spawn+0x332>
	close(fd);
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022a0:	e8 40 f5 ff ff       	call   8017e5 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  8022a5:	83 c4 08             	add    $0x8,%esp
  8022a8:	68 40 39 80 00       	push   $0x803940
  8022ad:	68 db 32 80 00       	push   $0x8032db
  8022b2:	e8 50 e0 ff ff       	call   800307 <cprintf>
  8022b7:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8022ba:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8022bf:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8022c5:	eb 0e                	jmp    8022d5 <spawn+0x46f>
  8022c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022cd:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8022d3:	74 5e                	je     802333 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  8022d5:	89 d8                	mov    %ebx,%eax
  8022d7:	c1 e8 16             	shr    $0x16,%eax
  8022da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8022e1:	a8 01                	test   $0x1,%al
  8022e3:	74 e2                	je     8022c7 <spawn+0x461>
  8022e5:	89 da                	mov    %ebx,%edx
  8022e7:	c1 ea 0c             	shr    $0xc,%edx
  8022ea:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8022f1:	25 05 04 00 00       	and    $0x405,%eax
  8022f6:	3d 05 04 00 00       	cmp    $0x405,%eax
  8022fb:	75 ca                	jne    8022c7 <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  8022fd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802304:	83 ec 0c             	sub    $0xc,%esp
  802307:	25 07 0e 00 00       	and    $0xe07,%eax
  80230c:	50                   	push   %eax
  80230d:	53                   	push   %ebx
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	6a 00                	push   $0x0
  802312:	e8 84 eb ff ff       	call   800e9b <sys_page_map>
  802317:	83 c4 20             	add    $0x20,%esp
  80231a:	85 c0                	test   %eax,%eax
  80231c:	79 a9                	jns    8022c7 <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  80231e:	50                   	push   %eax
  80231f:	68 ca 38 80 00       	push   $0x8038ca
  802324:	68 3b 01 00 00       	push   $0x13b
  802329:	68 a1 38 80 00       	push   $0x8038a1
  80232e:	e8 de de ff ff       	call   800211 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802333:	83 ec 08             	sub    $0x8,%esp
  802336:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80233c:	50                   	push   %eax
  80233d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802343:	e8 19 ec ff ff       	call   800f61 <sys_env_set_trapframe>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	85 c0                	test   %eax,%eax
  80234d:	78 25                	js     802374 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80234f:	83 ec 08             	sub    $0x8,%esp
  802352:	6a 02                	push   $0x2
  802354:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80235a:	e8 c0 eb ff ff       	call   800f1f <sys_env_set_status>
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	85 c0                	test   %eax,%eax
  802364:	78 23                	js     802389 <spawn+0x523>
	return child;
  802366:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80236c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802372:	eb 36                	jmp    8023aa <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  802374:	50                   	push   %eax
  802375:	68 dc 38 80 00       	push   $0x8038dc
  80237a:	68 8a 00 00 00       	push   $0x8a
  80237f:	68 a1 38 80 00       	push   $0x8038a1
  802384:	e8 88 de ff ff       	call   800211 <_panic>
		panic("sys_env_set_status: %e", r);
  802389:	50                   	push   %eax
  80238a:	68 f6 38 80 00       	push   $0x8038f6
  80238f:	68 8d 00 00 00       	push   $0x8d
  802394:	68 a1 38 80 00       	push   $0x8038a1
  802399:	e8 73 de ff ff       	call   800211 <_panic>
		return r;
  80239e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023a4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8023aa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023b3:	5b                   	pop    %ebx
  8023b4:	5e                   	pop    %esi
  8023b5:	5f                   	pop    %edi
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    
  8023b8:	89 c7                	mov    %eax,%edi
  8023ba:	e9 0d fe ff ff       	jmp    8021cc <spawn+0x366>
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	e9 06 fe ff ff       	jmp    8021cc <spawn+0x366>
  8023c6:	89 c7                	mov    %eax,%edi
  8023c8:	e9 ff fd ff ff       	jmp    8021cc <spawn+0x366>
		return -E_NO_MEM;
  8023cd:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8023d2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023d8:	eb d0                	jmp    8023aa <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  8023da:	83 ec 08             	sub    $0x8,%esp
  8023dd:	68 00 00 40 00       	push   $0x400000
  8023e2:	6a 00                	push   $0x0
  8023e4:	e8 f4 ea ff ff       	call   800edd <sys_page_unmap>
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8023f2:	eb b6                	jmp    8023aa <spawn+0x544>

008023f4 <spawnl>:
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	57                   	push   %edi
  8023f8:	56                   	push   %esi
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  8023fd:	68 38 39 80 00       	push   $0x803938
  802402:	68 db 32 80 00       	push   $0x8032db
  802407:	e8 fb de ff ff       	call   800307 <cprintf>
	va_start(vl, arg0);
  80240c:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80240f:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802417:	8d 4a 04             	lea    0x4(%edx),%ecx
  80241a:	83 3a 00             	cmpl   $0x0,(%edx)
  80241d:	74 07                	je     802426 <spawnl+0x32>
		argc++;
  80241f:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802422:	89 ca                	mov    %ecx,%edx
  802424:	eb f1                	jmp    802417 <spawnl+0x23>
	const char *argv[argc+2];
  802426:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80242d:	83 e2 f0             	and    $0xfffffff0,%edx
  802430:	29 d4                	sub    %edx,%esp
  802432:	8d 54 24 03          	lea    0x3(%esp),%edx
  802436:	c1 ea 02             	shr    $0x2,%edx
  802439:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802440:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802442:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802445:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  80244c:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802453:	00 
	va_start(vl, arg0);
  802454:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802457:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	eb 0b                	jmp    80246b <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802460:	83 c0 01             	add    $0x1,%eax
  802463:	8b 39                	mov    (%ecx),%edi
  802465:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802468:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80246b:	39 d0                	cmp    %edx,%eax
  80246d:	75 f1                	jne    802460 <spawnl+0x6c>
	return spawn(prog, argv);
  80246f:	83 ec 08             	sub    $0x8,%esp
  802472:	56                   	push   %esi
  802473:	ff 75 08             	pushl  0x8(%ebp)
  802476:	e8 eb f9 ff ff       	call   801e66 <spawn>
}
  80247b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247e:	5b                   	pop    %ebx
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    

00802483 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802489:	68 66 39 80 00       	push   $0x803966
  80248e:	ff 75 0c             	pushl  0xc(%ebp)
  802491:	e8 d0 e5 ff ff       	call   800a66 <strcpy>
	return 0;
}
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <devsock_close>:
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	53                   	push   %ebx
  8024a1:	83 ec 10             	sub    $0x10,%esp
  8024a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8024a7:	53                   	push   %ebx
  8024a8:	e8 e7 0a 00 00       	call   802f94 <pageref>
  8024ad:	83 c4 10             	add    $0x10,%esp
		return 0;
  8024b0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8024b5:	83 f8 01             	cmp    $0x1,%eax
  8024b8:	74 07                	je     8024c1 <devsock_close+0x24>
}
  8024ba:	89 d0                	mov    %edx,%eax
  8024bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024c1:	83 ec 0c             	sub    $0xc,%esp
  8024c4:	ff 73 0c             	pushl  0xc(%ebx)
  8024c7:	e8 b9 02 00 00       	call   802785 <nsipc_close>
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	83 c4 10             	add    $0x10,%esp
  8024d1:	eb e7                	jmp    8024ba <devsock_close+0x1d>

008024d3 <devsock_write>:
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	ff 75 10             	pushl  0x10(%ebp)
  8024de:	ff 75 0c             	pushl  0xc(%ebp)
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	ff 70 0c             	pushl  0xc(%eax)
  8024e7:	e8 76 03 00 00       	call   802862 <nsipc_send>
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <devsock_read>:
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	ff 75 10             	pushl  0x10(%ebp)
  8024f9:	ff 75 0c             	pushl  0xc(%ebp)
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	ff 70 0c             	pushl  0xc(%eax)
  802502:	e8 ef 02 00 00       	call   8027f6 <nsipc_recv>
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <fd2sockid>:
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80250f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802512:	52                   	push   %edx
  802513:	50                   	push   %eax
  802514:	e8 9a f1 ff ff       	call   8016b3 <fd_lookup>
  802519:	83 c4 10             	add    $0x10,%esp
  80251c:	85 c0                	test   %eax,%eax
  80251e:	78 10                	js     802530 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802529:	39 08                	cmp    %ecx,(%eax)
  80252b:	75 05                	jne    802532 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    
		return -E_NOT_SUPP;
  802532:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802537:	eb f7                	jmp    802530 <fd2sockid+0x27>

00802539 <alloc_sockfd>:
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
  80253c:	56                   	push   %esi
  80253d:	53                   	push   %ebx
  80253e:	83 ec 1c             	sub    $0x1c,%esp
  802541:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802546:	50                   	push   %eax
  802547:	e8 15 f1 ff ff       	call   801661 <fd_alloc>
  80254c:	89 c3                	mov    %eax,%ebx
  80254e:	83 c4 10             	add    $0x10,%esp
  802551:	85 c0                	test   %eax,%eax
  802553:	78 43                	js     802598 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 07 04 00 00       	push   $0x407
  80255d:	ff 75 f4             	pushl  -0xc(%ebp)
  802560:	6a 00                	push   $0x0
  802562:	e8 f1 e8 ff ff       	call   800e58 <sys_page_alloc>
  802567:	89 c3                	mov    %eax,%ebx
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	85 c0                	test   %eax,%eax
  80256e:	78 28                	js     802598 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802579:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802585:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	50                   	push   %eax
  80258c:	e8 a9 f0 ff ff       	call   80163a <fd2num>
  802591:	89 c3                	mov    %eax,%ebx
  802593:	83 c4 10             	add    $0x10,%esp
  802596:	eb 0c                	jmp    8025a4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802598:	83 ec 0c             	sub    $0xc,%esp
  80259b:	56                   	push   %esi
  80259c:	e8 e4 01 00 00       	call   802785 <nsipc_close>
		return r;
  8025a1:	83 c4 10             	add    $0x10,%esp
}
  8025a4:	89 d8                	mov    %ebx,%eax
  8025a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025a9:	5b                   	pop    %ebx
  8025aa:	5e                   	pop    %esi
  8025ab:	5d                   	pop    %ebp
  8025ac:	c3                   	ret    

008025ad <accept>:
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	e8 4e ff ff ff       	call   802509 <fd2sockid>
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	78 1b                	js     8025da <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	ff 75 10             	pushl  0x10(%ebp)
  8025c5:	ff 75 0c             	pushl  0xc(%ebp)
  8025c8:	50                   	push   %eax
  8025c9:	e8 0e 01 00 00       	call   8026dc <nsipc_accept>
  8025ce:	83 c4 10             	add    $0x10,%esp
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	78 05                	js     8025da <accept+0x2d>
	return alloc_sockfd(r);
  8025d5:	e8 5f ff ff ff       	call   802539 <alloc_sockfd>
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <bind>:
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	e8 1f ff ff ff       	call   802509 <fd2sockid>
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	78 12                	js     802600 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	ff 75 10             	pushl  0x10(%ebp)
  8025f4:	ff 75 0c             	pushl  0xc(%ebp)
  8025f7:	50                   	push   %eax
  8025f8:	e8 31 01 00 00       	call   80272e <nsipc_bind>
  8025fd:	83 c4 10             	add    $0x10,%esp
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <shutdown>:
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	e8 f9 fe ff ff       	call   802509 <fd2sockid>
  802610:	85 c0                	test   %eax,%eax
  802612:	78 0f                	js     802623 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802614:	83 ec 08             	sub    $0x8,%esp
  802617:	ff 75 0c             	pushl  0xc(%ebp)
  80261a:	50                   	push   %eax
  80261b:	e8 43 01 00 00       	call   802763 <nsipc_shutdown>
  802620:	83 c4 10             	add    $0x10,%esp
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <connect>:
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	e8 d6 fe ff ff       	call   802509 <fd2sockid>
  802633:	85 c0                	test   %eax,%eax
  802635:	78 12                	js     802649 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	ff 75 10             	pushl  0x10(%ebp)
  80263d:	ff 75 0c             	pushl  0xc(%ebp)
  802640:	50                   	push   %eax
  802641:	e8 59 01 00 00       	call   80279f <nsipc_connect>
  802646:	83 c4 10             	add    $0x10,%esp
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <listen>:
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	e8 b0 fe ff ff       	call   802509 <fd2sockid>
  802659:	85 c0                	test   %eax,%eax
  80265b:	78 0f                	js     80266c <listen+0x21>
	return nsipc_listen(r, backlog);
  80265d:	83 ec 08             	sub    $0x8,%esp
  802660:	ff 75 0c             	pushl  0xc(%ebp)
  802663:	50                   	push   %eax
  802664:	e8 6b 01 00 00       	call   8027d4 <nsipc_listen>
  802669:	83 c4 10             	add    $0x10,%esp
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <socket>:

int
socket(int domain, int type, int protocol)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802674:	ff 75 10             	pushl  0x10(%ebp)
  802677:	ff 75 0c             	pushl  0xc(%ebp)
  80267a:	ff 75 08             	pushl  0x8(%ebp)
  80267d:	e8 3e 02 00 00       	call   8028c0 <nsipc_socket>
  802682:	83 c4 10             	add    $0x10,%esp
  802685:	85 c0                	test   %eax,%eax
  802687:	78 05                	js     80268e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802689:	e8 ab fe ff ff       	call   802539 <alloc_sockfd>
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	53                   	push   %ebx
  802694:	83 ec 04             	sub    $0x4,%esp
  802697:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802699:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8026a0:	74 26                	je     8026c8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026a2:	6a 07                	push   $0x7
  8026a4:	68 00 70 80 00       	push   $0x807000
  8026a9:	53                   	push   %ebx
  8026aa:	ff 35 04 50 80 00    	pushl  0x805004
  8026b0:	e8 48 08 00 00       	call   802efd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026b5:	83 c4 0c             	add    $0xc,%esp
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	e8 d1 07 00 00       	call   802e94 <ipc_recv>
}
  8026c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026c8:	83 ec 0c             	sub    $0xc,%esp
  8026cb:	6a 02                	push   $0x2
  8026cd:	e8 83 08 00 00       	call   802f55 <ipc_find_env>
  8026d2:	a3 04 50 80 00       	mov    %eax,0x805004
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	eb c6                	jmp    8026a2 <nsipc+0x12>

008026dc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	56                   	push   %esi
  8026e0:	53                   	push   %ebx
  8026e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8026ec:	8b 06                	mov    (%esi),%eax
  8026ee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8026f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f8:	e8 93 ff ff ff       	call   802690 <nsipc>
  8026fd:	89 c3                	mov    %eax,%ebx
  8026ff:	85 c0                	test   %eax,%eax
  802701:	79 09                	jns    80270c <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802703:	89 d8                	mov    %ebx,%eax
  802705:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802708:	5b                   	pop    %ebx
  802709:	5e                   	pop    %esi
  80270a:	5d                   	pop    %ebp
  80270b:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	ff 35 10 70 80 00    	pushl  0x807010
  802715:	68 00 70 80 00       	push   $0x807000
  80271a:	ff 75 0c             	pushl  0xc(%ebp)
  80271d:	e8 d2 e4 ff ff       	call   800bf4 <memmove>
		*addrlen = ret->ret_addrlen;
  802722:	a1 10 70 80 00       	mov    0x807010,%eax
  802727:	89 06                	mov    %eax,(%esi)
  802729:	83 c4 10             	add    $0x10,%esp
	return r;
  80272c:	eb d5                	jmp    802703 <nsipc_accept+0x27>

0080272e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	53                   	push   %ebx
  802732:	83 ec 08             	sub    $0x8,%esp
  802735:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802740:	53                   	push   %ebx
  802741:	ff 75 0c             	pushl  0xc(%ebp)
  802744:	68 04 70 80 00       	push   $0x807004
  802749:	e8 a6 e4 ff ff       	call   800bf4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80274e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802754:	b8 02 00 00 00       	mov    $0x2,%eax
  802759:	e8 32 ff ff ff       	call   802690 <nsipc>
}
  80275e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802771:	8b 45 0c             	mov    0xc(%ebp),%eax
  802774:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802779:	b8 03 00 00 00       	mov    $0x3,%eax
  80277e:	e8 0d ff ff ff       	call   802690 <nsipc>
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <nsipc_close>:

int
nsipc_close(int s)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802793:	b8 04 00 00 00       	mov    $0x4,%eax
  802798:	e8 f3 fe ff ff       	call   802690 <nsipc>
}
  80279d:	c9                   	leave  
  80279e:	c3                   	ret    

0080279f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80279f:	55                   	push   %ebp
  8027a0:	89 e5                	mov    %esp,%ebp
  8027a2:	53                   	push   %ebx
  8027a3:	83 ec 08             	sub    $0x8,%esp
  8027a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027b1:	53                   	push   %ebx
  8027b2:	ff 75 0c             	pushl  0xc(%ebp)
  8027b5:	68 04 70 80 00       	push   $0x807004
  8027ba:	e8 35 e4 ff ff       	call   800bf4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027bf:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027c5:	b8 05 00 00 00       	mov    $0x5,%eax
  8027ca:	e8 c1 fe ff ff       	call   802690 <nsipc>
}
  8027cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027d2:	c9                   	leave  
  8027d3:	c3                   	ret    

008027d4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027d4:	55                   	push   %ebp
  8027d5:	89 e5                	mov    %esp,%ebp
  8027d7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8027e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e5:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8027ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8027ef:	e8 9c fe ff ff       	call   802690 <nsipc>
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	56                   	push   %esi
  8027fa:	53                   	push   %ebx
  8027fb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802806:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80280c:	8b 45 14             	mov    0x14(%ebp),%eax
  80280f:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802814:	b8 07 00 00 00       	mov    $0x7,%eax
  802819:	e8 72 fe ff ff       	call   802690 <nsipc>
  80281e:	89 c3                	mov    %eax,%ebx
  802820:	85 c0                	test   %eax,%eax
  802822:	78 1f                	js     802843 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802824:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802829:	7f 21                	jg     80284c <nsipc_recv+0x56>
  80282b:	39 c6                	cmp    %eax,%esi
  80282d:	7c 1d                	jl     80284c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	50                   	push   %eax
  802833:	68 00 70 80 00       	push   $0x807000
  802838:	ff 75 0c             	pushl  0xc(%ebp)
  80283b:	e8 b4 e3 ff ff       	call   800bf4 <memmove>
  802840:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802843:	89 d8                	mov    %ebx,%eax
  802845:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802848:	5b                   	pop    %ebx
  802849:	5e                   	pop    %esi
  80284a:	5d                   	pop    %ebp
  80284b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80284c:	68 72 39 80 00       	push   $0x803972
  802851:	68 5b 38 80 00       	push   $0x80385b
  802856:	6a 62                	push   $0x62
  802858:	68 87 39 80 00       	push   $0x803987
  80285d:	e8 af d9 ff ff       	call   800211 <_panic>

00802862 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	53                   	push   %ebx
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802874:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80287a:	7f 2e                	jg     8028aa <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	53                   	push   %ebx
  802880:	ff 75 0c             	pushl  0xc(%ebp)
  802883:	68 0c 70 80 00       	push   $0x80700c
  802888:	e8 67 e3 ff ff       	call   800bf4 <memmove>
	nsipcbuf.send.req_size = size;
  80288d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802893:	8b 45 14             	mov    0x14(%ebp),%eax
  802896:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80289b:	b8 08 00 00 00       	mov    $0x8,%eax
  8028a0:	e8 eb fd ff ff       	call   802690 <nsipc>
}
  8028a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    
	assert(size < 1600);
  8028aa:	68 93 39 80 00       	push   $0x803993
  8028af:	68 5b 38 80 00       	push   $0x80385b
  8028b4:	6a 6d                	push   $0x6d
  8028b6:	68 87 39 80 00       	push   $0x803987
  8028bb:	e8 51 d9 ff ff       	call   800211 <_panic>

008028c0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028c0:	55                   	push   %ebp
  8028c1:	89 e5                	mov    %esp,%ebp
  8028c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8028d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8028de:	b8 09 00 00 00       	mov    $0x9,%eax
  8028e3:	e8 a8 fd ff ff       	call   802690 <nsipc>
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	56                   	push   %esi
  8028ee:	53                   	push   %ebx
  8028ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028f2:	83 ec 0c             	sub    $0xc,%esp
  8028f5:	ff 75 08             	pushl  0x8(%ebp)
  8028f8:	e8 4d ed ff ff       	call   80164a <fd2data>
  8028fd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8028ff:	83 c4 08             	add    $0x8,%esp
  802902:	68 9f 39 80 00       	push   $0x80399f
  802907:	53                   	push   %ebx
  802908:	e8 59 e1 ff ff       	call   800a66 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80290d:	8b 46 04             	mov    0x4(%esi),%eax
  802910:	2b 06                	sub    (%esi),%eax
  802912:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802918:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80291f:	00 00 00 
	stat->st_dev = &devpipe;
  802922:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802929:	40 80 00 
	return 0;
}
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802934:	5b                   	pop    %ebx
  802935:	5e                   	pop    %esi
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    

00802938 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	53                   	push   %ebx
  80293c:	83 ec 0c             	sub    $0xc,%esp
  80293f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802942:	53                   	push   %ebx
  802943:	6a 00                	push   $0x0
  802945:	e8 93 e5 ff ff       	call   800edd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80294a:	89 1c 24             	mov    %ebx,(%esp)
  80294d:	e8 f8 ec ff ff       	call   80164a <fd2data>
  802952:	83 c4 08             	add    $0x8,%esp
  802955:	50                   	push   %eax
  802956:	6a 00                	push   $0x0
  802958:	e8 80 e5 ff ff       	call   800edd <sys_page_unmap>
}
  80295d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802960:	c9                   	leave  
  802961:	c3                   	ret    

00802962 <_pipeisclosed>:
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	89 c7                	mov    %eax,%edi
  80296d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80296f:	a1 08 50 80 00       	mov    0x805008,%eax
  802974:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802977:	83 ec 0c             	sub    $0xc,%esp
  80297a:	57                   	push   %edi
  80297b:	e8 14 06 00 00       	call   802f94 <pageref>
  802980:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802983:	89 34 24             	mov    %esi,(%esp)
  802986:	e8 09 06 00 00       	call   802f94 <pageref>
		nn = thisenv->env_runs;
  80298b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802991:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802994:	83 c4 10             	add    $0x10,%esp
  802997:	39 cb                	cmp    %ecx,%ebx
  802999:	74 1b                	je     8029b6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80299b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80299e:	75 cf                	jne    80296f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029a0:	8b 42 58             	mov    0x58(%edx),%eax
  8029a3:	6a 01                	push   $0x1
  8029a5:	50                   	push   %eax
  8029a6:	53                   	push   %ebx
  8029a7:	68 a6 39 80 00       	push   $0x8039a6
  8029ac:	e8 56 d9 ff ff       	call   800307 <cprintf>
  8029b1:	83 c4 10             	add    $0x10,%esp
  8029b4:	eb b9                	jmp    80296f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8029b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029b9:	0f 94 c0             	sete   %al
  8029bc:	0f b6 c0             	movzbl %al,%eax
}
  8029bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029c2:	5b                   	pop    %ebx
  8029c3:	5e                   	pop    %esi
  8029c4:	5f                   	pop    %edi
  8029c5:	5d                   	pop    %ebp
  8029c6:	c3                   	ret    

008029c7 <devpipe_write>:
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	57                   	push   %edi
  8029cb:	56                   	push   %esi
  8029cc:	53                   	push   %ebx
  8029cd:	83 ec 28             	sub    $0x28,%esp
  8029d0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8029d3:	56                   	push   %esi
  8029d4:	e8 71 ec ff ff       	call   80164a <fd2data>
  8029d9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8029db:	83 c4 10             	add    $0x10,%esp
  8029de:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8029e6:	74 4f                	je     802a37 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029e8:	8b 43 04             	mov    0x4(%ebx),%eax
  8029eb:	8b 0b                	mov    (%ebx),%ecx
  8029ed:	8d 51 20             	lea    0x20(%ecx),%edx
  8029f0:	39 d0                	cmp    %edx,%eax
  8029f2:	72 14                	jb     802a08 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8029f4:	89 da                	mov    %ebx,%edx
  8029f6:	89 f0                	mov    %esi,%eax
  8029f8:	e8 65 ff ff ff       	call   802962 <_pipeisclosed>
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	75 3b                	jne    802a3c <devpipe_write+0x75>
			sys_yield();
  802a01:	e8 33 e4 ff ff       	call   800e39 <sys_yield>
  802a06:	eb e0                	jmp    8029e8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a0b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a0f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a12:	89 c2                	mov    %eax,%edx
  802a14:	c1 fa 1f             	sar    $0x1f,%edx
  802a17:	89 d1                	mov    %edx,%ecx
  802a19:	c1 e9 1b             	shr    $0x1b,%ecx
  802a1c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a1f:	83 e2 1f             	and    $0x1f,%edx
  802a22:	29 ca                	sub    %ecx,%edx
  802a24:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a28:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a2c:	83 c0 01             	add    $0x1,%eax
  802a2f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a32:	83 c7 01             	add    $0x1,%edi
  802a35:	eb ac                	jmp    8029e3 <devpipe_write+0x1c>
	return i;
  802a37:	8b 45 10             	mov    0x10(%ebp),%eax
  802a3a:	eb 05                	jmp    802a41 <devpipe_write+0x7a>
				return 0;
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a44:	5b                   	pop    %ebx
  802a45:	5e                   	pop    %esi
  802a46:	5f                   	pop    %edi
  802a47:	5d                   	pop    %ebp
  802a48:	c3                   	ret    

00802a49 <devpipe_read>:
{
  802a49:	55                   	push   %ebp
  802a4a:	89 e5                	mov    %esp,%ebp
  802a4c:	57                   	push   %edi
  802a4d:	56                   	push   %esi
  802a4e:	53                   	push   %ebx
  802a4f:	83 ec 18             	sub    $0x18,%esp
  802a52:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802a55:	57                   	push   %edi
  802a56:	e8 ef eb ff ff       	call   80164a <fd2data>
  802a5b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a5d:	83 c4 10             	add    $0x10,%esp
  802a60:	be 00 00 00 00       	mov    $0x0,%esi
  802a65:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a68:	75 14                	jne    802a7e <devpipe_read+0x35>
	return i;
  802a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802a6d:	eb 02                	jmp    802a71 <devpipe_read+0x28>
				return i;
  802a6f:	89 f0                	mov    %esi,%eax
}
  802a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a74:	5b                   	pop    %ebx
  802a75:	5e                   	pop    %esi
  802a76:	5f                   	pop    %edi
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    
			sys_yield();
  802a79:	e8 bb e3 ff ff       	call   800e39 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802a7e:	8b 03                	mov    (%ebx),%eax
  802a80:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a83:	75 18                	jne    802a9d <devpipe_read+0x54>
			if (i > 0)
  802a85:	85 f6                	test   %esi,%esi
  802a87:	75 e6                	jne    802a6f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802a89:	89 da                	mov    %ebx,%edx
  802a8b:	89 f8                	mov    %edi,%eax
  802a8d:	e8 d0 fe ff ff       	call   802962 <_pipeisclosed>
  802a92:	85 c0                	test   %eax,%eax
  802a94:	74 e3                	je     802a79 <devpipe_read+0x30>
				return 0;
  802a96:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9b:	eb d4                	jmp    802a71 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a9d:	99                   	cltd   
  802a9e:	c1 ea 1b             	shr    $0x1b,%edx
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	83 e0 1f             	and    $0x1f,%eax
  802aa6:	29 d0                	sub    %edx,%eax
  802aa8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ab0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ab3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ab6:	83 c6 01             	add    $0x1,%esi
  802ab9:	eb aa                	jmp    802a65 <devpipe_read+0x1c>

00802abb <pipe>:
{
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
  802abe:	56                   	push   %esi
  802abf:	53                   	push   %ebx
  802ac0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802ac3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ac6:	50                   	push   %eax
  802ac7:	e8 95 eb ff ff       	call   801661 <fd_alloc>
  802acc:	89 c3                	mov    %eax,%ebx
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	0f 88 23 01 00 00    	js     802bfc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 07 04 00 00       	push   $0x407
  802ae1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae4:	6a 00                	push   $0x0
  802ae6:	e8 6d e3 ff ff       	call   800e58 <sys_page_alloc>
  802aeb:	89 c3                	mov    %eax,%ebx
  802aed:	83 c4 10             	add    $0x10,%esp
  802af0:	85 c0                	test   %eax,%eax
  802af2:	0f 88 04 01 00 00    	js     802bfc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802af8:	83 ec 0c             	sub    $0xc,%esp
  802afb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802afe:	50                   	push   %eax
  802aff:	e8 5d eb ff ff       	call   801661 <fd_alloc>
  802b04:	89 c3                	mov    %eax,%ebx
  802b06:	83 c4 10             	add    $0x10,%esp
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	0f 88 db 00 00 00    	js     802bec <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 07 04 00 00       	push   $0x407
  802b19:	ff 75 f0             	pushl  -0x10(%ebp)
  802b1c:	6a 00                	push   $0x0
  802b1e:	e8 35 e3 ff ff       	call   800e58 <sys_page_alloc>
  802b23:	89 c3                	mov    %eax,%ebx
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	0f 88 bc 00 00 00    	js     802bec <pipe+0x131>
	va = fd2data(fd0);
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	ff 75 f4             	pushl  -0xc(%ebp)
  802b36:	e8 0f eb ff ff       	call   80164a <fd2data>
  802b3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b3d:	83 c4 0c             	add    $0xc,%esp
  802b40:	68 07 04 00 00       	push   $0x407
  802b45:	50                   	push   %eax
  802b46:	6a 00                	push   $0x0
  802b48:	e8 0b e3 ff ff       	call   800e58 <sys_page_alloc>
  802b4d:	89 c3                	mov    %eax,%ebx
  802b4f:	83 c4 10             	add    $0x10,%esp
  802b52:	85 c0                	test   %eax,%eax
  802b54:	0f 88 82 00 00 00    	js     802bdc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b5a:	83 ec 0c             	sub    $0xc,%esp
  802b5d:	ff 75 f0             	pushl  -0x10(%ebp)
  802b60:	e8 e5 ea ff ff       	call   80164a <fd2data>
  802b65:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802b6c:	50                   	push   %eax
  802b6d:	6a 00                	push   $0x0
  802b6f:	56                   	push   %esi
  802b70:	6a 00                	push   $0x0
  802b72:	e8 24 e3 ff ff       	call   800e9b <sys_page_map>
  802b77:	89 c3                	mov    %eax,%ebx
  802b79:	83 c4 20             	add    $0x20,%esp
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	78 4e                	js     802bce <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802b80:	a1 44 40 80 00       	mov    0x804044,%eax
  802b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b88:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802b94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b97:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  802ba9:	e8 8c ea ff ff       	call   80163a <fd2num>
  802bae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bb1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bb3:	83 c4 04             	add    $0x4,%esp
  802bb6:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb9:	e8 7c ea ff ff       	call   80163a <fd2num>
  802bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bc1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bc4:	83 c4 10             	add    $0x10,%esp
  802bc7:	bb 00 00 00 00       	mov    $0x0,%ebx
  802bcc:	eb 2e                	jmp    802bfc <pipe+0x141>
	sys_page_unmap(0, va);
  802bce:	83 ec 08             	sub    $0x8,%esp
  802bd1:	56                   	push   %esi
  802bd2:	6a 00                	push   $0x0
  802bd4:	e8 04 e3 ff ff       	call   800edd <sys_page_unmap>
  802bd9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802bdc:	83 ec 08             	sub    $0x8,%esp
  802bdf:	ff 75 f0             	pushl  -0x10(%ebp)
  802be2:	6a 00                	push   $0x0
  802be4:	e8 f4 e2 ff ff       	call   800edd <sys_page_unmap>
  802be9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802bec:	83 ec 08             	sub    $0x8,%esp
  802bef:	ff 75 f4             	pushl  -0xc(%ebp)
  802bf2:	6a 00                	push   $0x0
  802bf4:	e8 e4 e2 ff ff       	call   800edd <sys_page_unmap>
  802bf9:	83 c4 10             	add    $0x10,%esp
}
  802bfc:	89 d8                	mov    %ebx,%eax
  802bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5d                   	pop    %ebp
  802c04:	c3                   	ret    

00802c05 <pipeisclosed>:
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
  802c08:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c0e:	50                   	push   %eax
  802c0f:	ff 75 08             	pushl  0x8(%ebp)
  802c12:	e8 9c ea ff ff       	call   8016b3 <fd_lookup>
  802c17:	83 c4 10             	add    $0x10,%esp
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	78 18                	js     802c36 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802c1e:	83 ec 0c             	sub    $0xc,%esp
  802c21:	ff 75 f4             	pushl  -0xc(%ebp)
  802c24:	e8 21 ea ff ff       	call   80164a <fd2data>
	return _pipeisclosed(fd, p);
  802c29:	89 c2                	mov    %eax,%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	e8 2f fd ff ff       	call   802962 <_pipeisclosed>
  802c33:	83 c4 10             	add    $0x10,%esp
}
  802c36:	c9                   	leave  
  802c37:	c3                   	ret    

00802c38 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c38:	55                   	push   %ebp
  802c39:	89 e5                	mov    %esp,%ebp
  802c3b:	56                   	push   %esi
  802c3c:	53                   	push   %ebx
  802c3d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802c40:	85 f6                	test   %esi,%esi
  802c42:	74 16                	je     802c5a <wait+0x22>
	e = &envs[ENVX(envid)];
  802c44:	89 f3                	mov    %esi,%ebx
  802c46:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802c4c:	69 db 84 00 00 00    	imul   $0x84,%ebx,%ebx
  802c52:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802c58:	eb 1b                	jmp    802c75 <wait+0x3d>
	assert(envid != 0);
  802c5a:	68 be 39 80 00       	push   $0x8039be
  802c5f:	68 5b 38 80 00       	push   $0x80385b
  802c64:	6a 09                	push   $0x9
  802c66:	68 c9 39 80 00       	push   $0x8039c9
  802c6b:	e8 a1 d5 ff ff       	call   800211 <_panic>
		sys_yield();
  802c70:	e8 c4 e1 ff ff       	call   800e39 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE){
  802c75:	8b 43 48             	mov    0x48(%ebx),%eax
  802c78:	39 f0                	cmp    %esi,%eax
  802c7a:	75 07                	jne    802c83 <wait+0x4b>
  802c7c:	8b 43 54             	mov    0x54(%ebx),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	75 ed                	jne    802c70 <wait+0x38>
	}
}
  802c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c86:	5b                   	pop    %ebx
  802c87:	5e                   	pop    %esi
  802c88:	5d                   	pop    %ebp
  802c89:	c3                   	ret    

00802c8a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802c8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8f:	c3                   	ret    

00802c90 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802c96:	68 d4 39 80 00       	push   $0x8039d4
  802c9b:	ff 75 0c             	pushl  0xc(%ebp)
  802c9e:	e8 c3 dd ff ff       	call   800a66 <strcpy>
	return 0;
}
  802ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca8:	c9                   	leave  
  802ca9:	c3                   	ret    

00802caa <devcons_write>:
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
  802cad:	57                   	push   %edi
  802cae:	56                   	push   %esi
  802caf:	53                   	push   %ebx
  802cb0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802cb6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802cbb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802cc1:	3b 75 10             	cmp    0x10(%ebp),%esi
  802cc4:	73 31                	jae    802cf7 <devcons_write+0x4d>
		m = n - tot;
  802cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802cc9:	29 f3                	sub    %esi,%ebx
  802ccb:	83 fb 7f             	cmp    $0x7f,%ebx
  802cce:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802cd3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	53                   	push   %ebx
  802cda:	89 f0                	mov    %esi,%eax
  802cdc:	03 45 0c             	add    0xc(%ebp),%eax
  802cdf:	50                   	push   %eax
  802ce0:	57                   	push   %edi
  802ce1:	e8 0e df ff ff       	call   800bf4 <memmove>
		sys_cputs(buf, m);
  802ce6:	83 c4 08             	add    $0x8,%esp
  802ce9:	53                   	push   %ebx
  802cea:	57                   	push   %edi
  802ceb:	e8 ac e0 ff ff       	call   800d9c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802cf0:	01 de                	add    %ebx,%esi
  802cf2:	83 c4 10             	add    $0x10,%esp
  802cf5:	eb ca                	jmp    802cc1 <devcons_write+0x17>
}
  802cf7:	89 f0                	mov    %esi,%eax
  802cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cfc:	5b                   	pop    %ebx
  802cfd:	5e                   	pop    %esi
  802cfe:	5f                   	pop    %edi
  802cff:	5d                   	pop    %ebp
  802d00:	c3                   	ret    

00802d01 <devcons_read>:
{
  802d01:	55                   	push   %ebp
  802d02:	89 e5                	mov    %esp,%ebp
  802d04:	83 ec 08             	sub    $0x8,%esp
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d10:	74 21                	je     802d33 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d12:	e8 a3 e0 ff ff       	call   800dba <sys_cgetc>
  802d17:	85 c0                	test   %eax,%eax
  802d19:	75 07                	jne    802d22 <devcons_read+0x21>
		sys_yield();
  802d1b:	e8 19 e1 ff ff       	call   800e39 <sys_yield>
  802d20:	eb f0                	jmp    802d12 <devcons_read+0x11>
	if (c < 0)
  802d22:	78 0f                	js     802d33 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802d24:	83 f8 04             	cmp    $0x4,%eax
  802d27:	74 0c                	je     802d35 <devcons_read+0x34>
	*(char*)vbuf = c;
  802d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2c:	88 02                	mov    %al,(%edx)
	return 1;
  802d2e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d33:	c9                   	leave  
  802d34:	c3                   	ret    
		return 0;
  802d35:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3a:	eb f7                	jmp    802d33 <devcons_read+0x32>

00802d3c <cputchar>:
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
  802d3f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802d48:	6a 01                	push   $0x1
  802d4a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d4d:	50                   	push   %eax
  802d4e:	e8 49 e0 ff ff       	call   800d9c <sys_cputs>
}
  802d53:	83 c4 10             	add    $0x10,%esp
  802d56:	c9                   	leave  
  802d57:	c3                   	ret    

00802d58 <getchar>:
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
  802d5b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802d5e:	6a 01                	push   $0x1
  802d60:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d63:	50                   	push   %eax
  802d64:	6a 00                	push   $0x0
  802d66:	e8 b8 eb ff ff       	call   801923 <read>
	if (r < 0)
  802d6b:	83 c4 10             	add    $0x10,%esp
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	78 06                	js     802d78 <getchar+0x20>
	if (r < 1)
  802d72:	74 06                	je     802d7a <getchar+0x22>
	return c;
  802d74:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    
		return -E_EOF;
  802d7a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802d7f:	eb f7                	jmp    802d78 <getchar+0x20>

00802d81 <iscons>:
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
  802d84:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d8a:	50                   	push   %eax
  802d8b:	ff 75 08             	pushl  0x8(%ebp)
  802d8e:	e8 20 e9 ff ff       	call   8016b3 <fd_lookup>
  802d93:	83 c4 10             	add    $0x10,%esp
  802d96:	85 c0                	test   %eax,%eax
  802d98:	78 11                	js     802dab <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802da3:	39 10                	cmp    %edx,(%eax)
  802da5:	0f 94 c0             	sete   %al
  802da8:	0f b6 c0             	movzbl %al,%eax
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <opencons>:
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
  802db0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802db3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db6:	50                   	push   %eax
  802db7:	e8 a5 e8 ff ff       	call   801661 <fd_alloc>
  802dbc:	83 c4 10             	add    $0x10,%esp
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	78 3a                	js     802dfd <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dc3:	83 ec 04             	sub    $0x4,%esp
  802dc6:	68 07 04 00 00       	push   $0x407
  802dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  802dce:	6a 00                	push   $0x0
  802dd0:	e8 83 e0 ff ff       	call   800e58 <sys_page_alloc>
  802dd5:	83 c4 10             	add    $0x10,%esp
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	78 21                	js     802dfd <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802de5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802df1:	83 ec 0c             	sub    $0xc,%esp
  802df4:	50                   	push   %eax
  802df5:	e8 40 e8 ff ff       	call   80163a <fd2num>
  802dfa:	83 c4 10             	add    $0x10,%esp
}
  802dfd:	c9                   	leave  
  802dfe:	c3                   	ret    

00802dff <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802dff:	55                   	push   %ebp
  802e00:	89 e5                	mov    %esp,%ebp
  802e02:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e05:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e0c:	74 0a                	je     802e18 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e16:	c9                   	leave  
  802e17:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	6a 07                	push   $0x7
  802e1d:	68 00 f0 bf ee       	push   $0xeebff000
  802e22:	6a 00                	push   $0x0
  802e24:	e8 2f e0 ff ff       	call   800e58 <sys_page_alloc>
		if(r < 0)
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	78 2a                	js     802e5a <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802e30:	83 ec 08             	sub    $0x8,%esp
  802e33:	68 6e 2e 80 00       	push   $0x802e6e
  802e38:	6a 00                	push   $0x0
  802e3a:	e8 64 e1 ff ff       	call   800fa3 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	85 c0                	test   %eax,%eax
  802e44:	79 c8                	jns    802e0e <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 10 3a 80 00       	push   $0x803a10
  802e4e:	6a 25                	push   $0x25
  802e50:	68 4c 3a 80 00       	push   $0x803a4c
  802e55:	e8 b7 d3 ff ff       	call   800211 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 e0 39 80 00       	push   $0x8039e0
  802e62:	6a 22                	push   $0x22
  802e64:	68 4c 3a 80 00       	push   $0x803a4c
  802e69:	e8 a3 d3 ff ff       	call   800211 <_panic>

00802e6e <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802e6e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802e6f:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802e74:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802e76:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802e79:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802e7d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802e81:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802e84:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802e86:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802e8a:	83 c4 08             	add    $0x8,%esp
	popal
  802e8d:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802e8e:	83 c4 04             	add    $0x4,%esp
	popfl
  802e91:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802e92:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802e93:	c3                   	ret    

00802e94 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
  802e97:	56                   	push   %esi
  802e98:	53                   	push   %ebx
  802e99:	8b 75 08             	mov    0x8(%ebp),%esi
  802e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802ea2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802ea4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802ea9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802eac:	83 ec 0c             	sub    $0xc,%esp
  802eaf:	50                   	push   %eax
  802eb0:	e8 53 e1 ff ff       	call   801008 <sys_ipc_recv>
	if(ret < 0){
  802eb5:	83 c4 10             	add    $0x10,%esp
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	78 2b                	js     802ee7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802ebc:	85 f6                	test   %esi,%esi
  802ebe:	74 0a                	je     802eca <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802ec0:	a1 08 50 80 00       	mov    0x805008,%eax
  802ec5:	8b 40 78             	mov    0x78(%eax),%eax
  802ec8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802eca:	85 db                	test   %ebx,%ebx
  802ecc:	74 0a                	je     802ed8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802ece:	a1 08 50 80 00       	mov    0x805008,%eax
  802ed3:	8b 40 7c             	mov    0x7c(%eax),%eax
  802ed6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802ed8:	a1 08 50 80 00       	mov    0x805008,%eax
  802edd:	8b 40 74             	mov    0x74(%eax),%eax
}
  802ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ee3:	5b                   	pop    %ebx
  802ee4:	5e                   	pop    %esi
  802ee5:	5d                   	pop    %ebp
  802ee6:	c3                   	ret    
		if(from_env_store)
  802ee7:	85 f6                	test   %esi,%esi
  802ee9:	74 06                	je     802ef1 <ipc_recv+0x5d>
			*from_env_store = 0;
  802eeb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802ef1:	85 db                	test   %ebx,%ebx
  802ef3:	74 eb                	je     802ee0 <ipc_recv+0x4c>
			*perm_store = 0;
  802ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802efb:	eb e3                	jmp    802ee0 <ipc_recv+0x4c>

00802efd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
  802f00:	57                   	push   %edi
  802f01:	56                   	push   %esi
  802f02:	53                   	push   %ebx
  802f03:	83 ec 0c             	sub    $0xc,%esp
  802f06:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f09:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802f0f:	85 db                	test   %ebx,%ebx
  802f11:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802f16:	0f 44 d8             	cmove  %eax,%ebx
  802f19:	eb 05                	jmp    802f20 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802f1b:	e8 19 df ff ff       	call   800e39 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802f20:	ff 75 14             	pushl  0x14(%ebp)
  802f23:	53                   	push   %ebx
  802f24:	56                   	push   %esi
  802f25:	57                   	push   %edi
  802f26:	e8 ba e0 ff ff       	call   800fe5 <sys_ipc_try_send>
  802f2b:	83 c4 10             	add    $0x10,%esp
  802f2e:	85 c0                	test   %eax,%eax
  802f30:	74 1b                	je     802f4d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802f32:	79 e7                	jns    802f1b <ipc_send+0x1e>
  802f34:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f37:	74 e2                	je     802f1b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802f39:	83 ec 04             	sub    $0x4,%esp
  802f3c:	68 5a 3a 80 00       	push   $0x803a5a
  802f41:	6a 46                	push   $0x46
  802f43:	68 6f 3a 80 00       	push   $0x803a6f
  802f48:	e8 c4 d2 ff ff       	call   800211 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f50:	5b                   	pop    %ebx
  802f51:	5e                   	pop    %esi
  802f52:	5f                   	pop    %edi
  802f53:	5d                   	pop    %ebp
  802f54:	c3                   	ret    

00802f55 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802f55:	55                   	push   %ebp
  802f56:	89 e5                	mov    %esp,%ebp
  802f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802f5b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802f60:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802f66:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802f6c:	8b 52 50             	mov    0x50(%edx),%edx
  802f6f:	39 ca                	cmp    %ecx,%edx
  802f71:	74 11                	je     802f84 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802f73:	83 c0 01             	add    $0x1,%eax
  802f76:	3d 00 04 00 00       	cmp    $0x400,%eax
  802f7b:	75 e3                	jne    802f60 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f82:	eb 0e                	jmp    802f92 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802f84:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802f8a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802f8f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802f92:	5d                   	pop    %ebp
  802f93:	c3                   	ret    

00802f94 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f94:	55                   	push   %ebp
  802f95:	89 e5                	mov    %esp,%ebp
  802f97:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f9a:	89 d0                	mov    %edx,%eax
  802f9c:	c1 e8 16             	shr    $0x16,%eax
  802f9f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802fa6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802fab:	f6 c1 01             	test   $0x1,%cl
  802fae:	74 1d                	je     802fcd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802fb0:	c1 ea 0c             	shr    $0xc,%edx
  802fb3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802fba:	f6 c2 01             	test   $0x1,%dl
  802fbd:	74 0e                	je     802fcd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fbf:	c1 ea 0c             	shr    $0xc,%edx
  802fc2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802fc9:	ef 
  802fca:	0f b7 c0             	movzwl %ax,%eax
}
  802fcd:	5d                   	pop    %ebp
  802fce:	c3                   	ret    
  802fcf:	90                   	nop

00802fd0 <__udivdi3>:
  802fd0:	55                   	push   %ebp
  802fd1:	57                   	push   %edi
  802fd2:	56                   	push   %esi
  802fd3:	53                   	push   %ebx
  802fd4:	83 ec 1c             	sub    $0x1c,%esp
  802fd7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802fdb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802fdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802fe3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802fe7:	85 d2                	test   %edx,%edx
  802fe9:	75 4d                	jne    803038 <__udivdi3+0x68>
  802feb:	39 f3                	cmp    %esi,%ebx
  802fed:	76 19                	jbe    803008 <__udivdi3+0x38>
  802fef:	31 ff                	xor    %edi,%edi
  802ff1:	89 e8                	mov    %ebp,%eax
  802ff3:	89 f2                	mov    %esi,%edx
  802ff5:	f7 f3                	div    %ebx
  802ff7:	89 fa                	mov    %edi,%edx
  802ff9:	83 c4 1c             	add    $0x1c,%esp
  802ffc:	5b                   	pop    %ebx
  802ffd:	5e                   	pop    %esi
  802ffe:	5f                   	pop    %edi
  802fff:	5d                   	pop    %ebp
  803000:	c3                   	ret    
  803001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803008:	89 d9                	mov    %ebx,%ecx
  80300a:	85 db                	test   %ebx,%ebx
  80300c:	75 0b                	jne    803019 <__udivdi3+0x49>
  80300e:	b8 01 00 00 00       	mov    $0x1,%eax
  803013:	31 d2                	xor    %edx,%edx
  803015:	f7 f3                	div    %ebx
  803017:	89 c1                	mov    %eax,%ecx
  803019:	31 d2                	xor    %edx,%edx
  80301b:	89 f0                	mov    %esi,%eax
  80301d:	f7 f1                	div    %ecx
  80301f:	89 c6                	mov    %eax,%esi
  803021:	89 e8                	mov    %ebp,%eax
  803023:	89 f7                	mov    %esi,%edi
  803025:	f7 f1                	div    %ecx
  803027:	89 fa                	mov    %edi,%edx
  803029:	83 c4 1c             	add    $0x1c,%esp
  80302c:	5b                   	pop    %ebx
  80302d:	5e                   	pop    %esi
  80302e:	5f                   	pop    %edi
  80302f:	5d                   	pop    %ebp
  803030:	c3                   	ret    
  803031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803038:	39 f2                	cmp    %esi,%edx
  80303a:	77 1c                	ja     803058 <__udivdi3+0x88>
  80303c:	0f bd fa             	bsr    %edx,%edi
  80303f:	83 f7 1f             	xor    $0x1f,%edi
  803042:	75 2c                	jne    803070 <__udivdi3+0xa0>
  803044:	39 f2                	cmp    %esi,%edx
  803046:	72 06                	jb     80304e <__udivdi3+0x7e>
  803048:	31 c0                	xor    %eax,%eax
  80304a:	39 eb                	cmp    %ebp,%ebx
  80304c:	77 a9                	ja     802ff7 <__udivdi3+0x27>
  80304e:	b8 01 00 00 00       	mov    $0x1,%eax
  803053:	eb a2                	jmp    802ff7 <__udivdi3+0x27>
  803055:	8d 76 00             	lea    0x0(%esi),%esi
  803058:	31 ff                	xor    %edi,%edi
  80305a:	31 c0                	xor    %eax,%eax
  80305c:	89 fa                	mov    %edi,%edx
  80305e:	83 c4 1c             	add    $0x1c,%esp
  803061:	5b                   	pop    %ebx
  803062:	5e                   	pop    %esi
  803063:	5f                   	pop    %edi
  803064:	5d                   	pop    %ebp
  803065:	c3                   	ret    
  803066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80306d:	8d 76 00             	lea    0x0(%esi),%esi
  803070:	89 f9                	mov    %edi,%ecx
  803072:	b8 20 00 00 00       	mov    $0x20,%eax
  803077:	29 f8                	sub    %edi,%eax
  803079:	d3 e2                	shl    %cl,%edx
  80307b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80307f:	89 c1                	mov    %eax,%ecx
  803081:	89 da                	mov    %ebx,%edx
  803083:	d3 ea                	shr    %cl,%edx
  803085:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803089:	09 d1                	or     %edx,%ecx
  80308b:	89 f2                	mov    %esi,%edx
  80308d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803091:	89 f9                	mov    %edi,%ecx
  803093:	d3 e3                	shl    %cl,%ebx
  803095:	89 c1                	mov    %eax,%ecx
  803097:	d3 ea                	shr    %cl,%edx
  803099:	89 f9                	mov    %edi,%ecx
  80309b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80309f:	89 eb                	mov    %ebp,%ebx
  8030a1:	d3 e6                	shl    %cl,%esi
  8030a3:	89 c1                	mov    %eax,%ecx
  8030a5:	d3 eb                	shr    %cl,%ebx
  8030a7:	09 de                	or     %ebx,%esi
  8030a9:	89 f0                	mov    %esi,%eax
  8030ab:	f7 74 24 08          	divl   0x8(%esp)
  8030af:	89 d6                	mov    %edx,%esi
  8030b1:	89 c3                	mov    %eax,%ebx
  8030b3:	f7 64 24 0c          	mull   0xc(%esp)
  8030b7:	39 d6                	cmp    %edx,%esi
  8030b9:	72 15                	jb     8030d0 <__udivdi3+0x100>
  8030bb:	89 f9                	mov    %edi,%ecx
  8030bd:	d3 e5                	shl    %cl,%ebp
  8030bf:	39 c5                	cmp    %eax,%ebp
  8030c1:	73 04                	jae    8030c7 <__udivdi3+0xf7>
  8030c3:	39 d6                	cmp    %edx,%esi
  8030c5:	74 09                	je     8030d0 <__udivdi3+0x100>
  8030c7:	89 d8                	mov    %ebx,%eax
  8030c9:	31 ff                	xor    %edi,%edi
  8030cb:	e9 27 ff ff ff       	jmp    802ff7 <__udivdi3+0x27>
  8030d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030d3:	31 ff                	xor    %edi,%edi
  8030d5:	e9 1d ff ff ff       	jmp    802ff7 <__udivdi3+0x27>
  8030da:	66 90                	xchg   %ax,%ax
  8030dc:	66 90                	xchg   %ax,%ax
  8030de:	66 90                	xchg   %ax,%ax

008030e0 <__umoddi3>:
  8030e0:	55                   	push   %ebp
  8030e1:	57                   	push   %edi
  8030e2:	56                   	push   %esi
  8030e3:	53                   	push   %ebx
  8030e4:	83 ec 1c             	sub    $0x1c,%esp
  8030e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8030eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8030f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030f7:	89 da                	mov    %ebx,%edx
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	75 43                	jne    803140 <__umoddi3+0x60>
  8030fd:	39 df                	cmp    %ebx,%edi
  8030ff:	76 17                	jbe    803118 <__umoddi3+0x38>
  803101:	89 f0                	mov    %esi,%eax
  803103:	f7 f7                	div    %edi
  803105:	89 d0                	mov    %edx,%eax
  803107:	31 d2                	xor    %edx,%edx
  803109:	83 c4 1c             	add    $0x1c,%esp
  80310c:	5b                   	pop    %ebx
  80310d:	5e                   	pop    %esi
  80310e:	5f                   	pop    %edi
  80310f:	5d                   	pop    %ebp
  803110:	c3                   	ret    
  803111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803118:	89 fd                	mov    %edi,%ebp
  80311a:	85 ff                	test   %edi,%edi
  80311c:	75 0b                	jne    803129 <__umoddi3+0x49>
  80311e:	b8 01 00 00 00       	mov    $0x1,%eax
  803123:	31 d2                	xor    %edx,%edx
  803125:	f7 f7                	div    %edi
  803127:	89 c5                	mov    %eax,%ebp
  803129:	89 d8                	mov    %ebx,%eax
  80312b:	31 d2                	xor    %edx,%edx
  80312d:	f7 f5                	div    %ebp
  80312f:	89 f0                	mov    %esi,%eax
  803131:	f7 f5                	div    %ebp
  803133:	89 d0                	mov    %edx,%eax
  803135:	eb d0                	jmp    803107 <__umoddi3+0x27>
  803137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80313e:	66 90                	xchg   %ax,%ax
  803140:	89 f1                	mov    %esi,%ecx
  803142:	39 d8                	cmp    %ebx,%eax
  803144:	76 0a                	jbe    803150 <__umoddi3+0x70>
  803146:	89 f0                	mov    %esi,%eax
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	0f bd e8             	bsr    %eax,%ebp
  803153:	83 f5 1f             	xor    $0x1f,%ebp
  803156:	75 20                	jne    803178 <__umoddi3+0x98>
  803158:	39 d8                	cmp    %ebx,%eax
  80315a:	0f 82 b0 00 00 00    	jb     803210 <__umoddi3+0x130>
  803160:	39 f7                	cmp    %esi,%edi
  803162:	0f 86 a8 00 00 00    	jbe    803210 <__umoddi3+0x130>
  803168:	89 c8                	mov    %ecx,%eax
  80316a:	83 c4 1c             	add    $0x1c,%esp
  80316d:	5b                   	pop    %ebx
  80316e:	5e                   	pop    %esi
  80316f:	5f                   	pop    %edi
  803170:	5d                   	pop    %ebp
  803171:	c3                   	ret    
  803172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803178:	89 e9                	mov    %ebp,%ecx
  80317a:	ba 20 00 00 00       	mov    $0x20,%edx
  80317f:	29 ea                	sub    %ebp,%edx
  803181:	d3 e0                	shl    %cl,%eax
  803183:	89 44 24 08          	mov    %eax,0x8(%esp)
  803187:	89 d1                	mov    %edx,%ecx
  803189:	89 f8                	mov    %edi,%eax
  80318b:	d3 e8                	shr    %cl,%eax
  80318d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803191:	89 54 24 04          	mov    %edx,0x4(%esp)
  803195:	8b 54 24 04          	mov    0x4(%esp),%edx
  803199:	09 c1                	or     %eax,%ecx
  80319b:	89 d8                	mov    %ebx,%eax
  80319d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031a1:	89 e9                	mov    %ebp,%ecx
  8031a3:	d3 e7                	shl    %cl,%edi
  8031a5:	89 d1                	mov    %edx,%ecx
  8031a7:	d3 e8                	shr    %cl,%eax
  8031a9:	89 e9                	mov    %ebp,%ecx
  8031ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031af:	d3 e3                	shl    %cl,%ebx
  8031b1:	89 c7                	mov    %eax,%edi
  8031b3:	89 d1                	mov    %edx,%ecx
  8031b5:	89 f0                	mov    %esi,%eax
  8031b7:	d3 e8                	shr    %cl,%eax
  8031b9:	89 e9                	mov    %ebp,%ecx
  8031bb:	89 fa                	mov    %edi,%edx
  8031bd:	d3 e6                	shl    %cl,%esi
  8031bf:	09 d8                	or     %ebx,%eax
  8031c1:	f7 74 24 08          	divl   0x8(%esp)
  8031c5:	89 d1                	mov    %edx,%ecx
  8031c7:	89 f3                	mov    %esi,%ebx
  8031c9:	f7 64 24 0c          	mull   0xc(%esp)
  8031cd:	89 c6                	mov    %eax,%esi
  8031cf:	89 d7                	mov    %edx,%edi
  8031d1:	39 d1                	cmp    %edx,%ecx
  8031d3:	72 06                	jb     8031db <__umoddi3+0xfb>
  8031d5:	75 10                	jne    8031e7 <__umoddi3+0x107>
  8031d7:	39 c3                	cmp    %eax,%ebx
  8031d9:	73 0c                	jae    8031e7 <__umoddi3+0x107>
  8031db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8031df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8031e3:	89 d7                	mov    %edx,%edi
  8031e5:	89 c6                	mov    %eax,%esi
  8031e7:	89 ca                	mov    %ecx,%edx
  8031e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8031ee:	29 f3                	sub    %esi,%ebx
  8031f0:	19 fa                	sbb    %edi,%edx
  8031f2:	89 d0                	mov    %edx,%eax
  8031f4:	d3 e0                	shl    %cl,%eax
  8031f6:	89 e9                	mov    %ebp,%ecx
  8031f8:	d3 eb                	shr    %cl,%ebx
  8031fa:	d3 ea                	shr    %cl,%edx
  8031fc:	09 d8                	or     %ebx,%eax
  8031fe:	83 c4 1c             	add    $0x1c,%esp
  803201:	5b                   	pop    %ebx
  803202:	5e                   	pop    %esi
  803203:	5f                   	pop    %edi
  803204:	5d                   	pop    %ebp
  803205:	c3                   	ret    
  803206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80320d:	8d 76 00             	lea    0x0(%esi),%esi
  803210:	89 da                	mov    %ebx,%edx
  803212:	29 fe                	sub    %edi,%esi
  803214:	19 c2                	sbb    %eax,%edx
  803216:	89 f1                	mov    %esi,%ecx
  803218:	89 c8                	mov    %ecx,%eax
  80321a:	e9 4b ff ff ff       	jmp    80316a <__umoddi3+0x8a>
