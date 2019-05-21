
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
  800044:	e8 47 0a 00 00       	call   800a90 <strcpy>
	exit();
  800049:	e8 db 01 00 00       	call   800229 <exit>
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
  800073:	e8 0a 0e 00 00       	call   800e82 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 38 12 00 00       	call   8012c0 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 2a 1a 00 00       	call   801acb <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 87 0a 00 00       	call   800b3b <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  8000be:	ba c6 2b 80 00       	mov    $0x802bc6,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 fc 2b 80 00       	push   $0x802bfc
  8000cc:	e8 60 02 00 00       	call   800331 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 17 2c 80 00       	push   $0x802c17
  8000d8:	68 1c 2c 80 00       	push   $0x802c1c
  8000dd:	68 1b 2c 80 00       	push   $0x802c1b
  8000e2:	e8 67 19 00 00       	call   801a4e <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 d0 19 00 00       	call   801acb <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 2d 0a 00 00       	call   800b3b <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  800118:	ba c6 2b 80 00       	mov    $0x802bc6,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 33 2c 80 00       	push   $0x802c33
  800126:	e8 06 02 00 00       	call   800331 <cprintf>
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
  80013f:	68 cc 2b 80 00       	push   $0x802bcc
  800144:	6a 13                	push   $0x13
  800146:	68 df 2b 80 00       	push   $0x802bdf
  80014b:	e8 eb 00 00 00       	call   80023b <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 f3 2b 80 00       	push   $0x802bf3
  800156:	6a 17                	push   $0x17
  800158:	68 df 2b 80 00       	push   $0x802bdf
  80015d:	e8 d9 00 00 00       	call   80023b <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 1b 09 00 00       	call   800a90 <strcpy>
		exit();
  800175:	e8 af 00 00 00       	call   800229 <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 29 2c 80 00       	push   $0x802c29
  800188:	6a 21                	push   $0x21
  80018a:	68 df 2b 80 00       	push   $0x802bdf
  80018f:	e8 a7 00 00 00       	call   80023b <_panic>

00800194 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80019d:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8001a4:	00 00 00 
	envid_t find = sys_getenvid();
  8001a7:	e8 98 0c 00 00       	call   800e44 <sys_getenvid>
  8001ac:	8b 1d 04 50 80 00    	mov    0x805004,%ebx
  8001b2:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001bc:	bf 01 00 00 00       	mov    $0x1,%edi
  8001c1:	eb 0b                	jmp    8001ce <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001c3:	83 c2 01             	add    $0x1,%edx
  8001c6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001cc:	74 21                	je     8001ef <libmain+0x5b>
		if(envs[i].env_id == find)
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	c1 e1 07             	shl    $0x7,%ecx
  8001d3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001d9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001dc:	39 c1                	cmp    %eax,%ecx
  8001de:	75 e3                	jne    8001c3 <libmain+0x2f>
  8001e0:	89 d3                	mov    %edx,%ebx
  8001e2:	c1 e3 07             	shl    $0x7,%ebx
  8001e5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001eb:	89 fe                	mov    %edi,%esi
  8001ed:	eb d4                	jmp    8001c3 <libmain+0x2f>
  8001ef:	89 f0                	mov    %esi,%eax
  8001f1:	84 c0                	test   %al,%al
  8001f3:	74 06                	je     8001fb <libmain+0x67>
  8001f5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ff:	7e 0a                	jle    80020b <libmain+0x77>
		binaryname = argv[0];
  800201:	8b 45 0c             	mov    0xc(%ebp),%eax
  800204:	8b 00                	mov    (%eax),%eax
  800206:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	ff 75 0c             	pushl  0xc(%ebp)
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	e8 3a fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  800219:	e8 0b 00 00 00       	call   800229 <exit>
}
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    

00800229 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80022f:	6a 00                	push   $0x0
  800231:	e8 cd 0b 00 00       	call   800e03 <sys_env_destroy>
}
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	56                   	push   %esi
  80023f:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800240:	a1 04 50 80 00       	mov    0x805004,%eax
  800245:	8b 40 48             	mov    0x48(%eax),%eax
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	68 a8 2c 80 00       	push   $0x802ca8
  800250:	50                   	push   %eax
  800251:	68 77 2c 80 00       	push   $0x802c77
  800256:	e8 d6 00 00 00       	call   800331 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80025b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80025e:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800264:	e8 db 0b 00 00       	call   800e44 <sys_getenvid>
  800269:	83 c4 04             	add    $0x4,%esp
  80026c:	ff 75 0c             	pushl  0xc(%ebp)
  80026f:	ff 75 08             	pushl  0x8(%ebp)
  800272:	56                   	push   %esi
  800273:	50                   	push   %eax
  800274:	68 84 2c 80 00       	push   $0x802c84
  800279:	e8 b3 00 00 00       	call   800331 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80027e:	83 c4 18             	add    $0x18,%esp
  800281:	53                   	push   %ebx
  800282:	ff 75 10             	pushl  0x10(%ebp)
  800285:	e8 56 00 00 00       	call   8002e0 <vcprintf>
	cprintf("\n");
  80028a:	c7 04 24 99 30 80 00 	movl   $0x803099,(%esp)
  800291:	e8 9b 00 00 00       	call   800331 <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800299:	cc                   	int3   
  80029a:	eb fd                	jmp    800299 <_panic+0x5e>

0080029c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	53                   	push   %ebx
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a6:	8b 13                	mov    (%ebx),%edx
  8002a8:	8d 42 01             	lea    0x1(%edx),%eax
  8002ab:	89 03                	mov    %eax,(%ebx)
  8002ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b9:	74 09                	je     8002c4 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002bb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	68 ff 00 00 00       	push   $0xff
  8002cc:	8d 43 08             	lea    0x8(%ebx),%eax
  8002cf:	50                   	push   %eax
  8002d0:	e8 f1 0a 00 00       	call   800dc6 <sys_cputs>
		b->idx = 0;
  8002d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	eb db                	jmp    8002bb <putch+0x1f>

008002e0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f0:	00 00 00 
	b.cnt = 0;
  8002f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002fd:	ff 75 0c             	pushl  0xc(%ebp)
  800300:	ff 75 08             	pushl  0x8(%ebp)
  800303:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800309:	50                   	push   %eax
  80030a:	68 9c 02 80 00       	push   $0x80029c
  80030f:	e8 4a 01 00 00       	call   80045e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800314:	83 c4 08             	add    $0x8,%esp
  800317:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80031d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800323:	50                   	push   %eax
  800324:	e8 9d 0a 00 00       	call   800dc6 <sys_cputs>

	return b.cnt;
}
  800329:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800337:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033a:	50                   	push   %eax
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	e8 9d ff ff ff       	call   8002e0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	83 ec 1c             	sub    $0x1c,%esp
  80034e:	89 c6                	mov    %eax,%esi
  800350:	89 d7                	mov    %edx,%edi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	8b 55 0c             	mov    0xc(%ebp),%edx
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80035e:	8b 45 10             	mov    0x10(%ebp),%eax
  800361:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800364:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800368:	74 2c                	je     800396 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80036a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800374:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800377:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80037f:	73 43                	jae    8003c4 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800381:	83 eb 01             	sub    $0x1,%ebx
  800384:	85 db                	test   %ebx,%ebx
  800386:	7e 6c                	jle    8003f4 <printnum+0xaf>
				putch(padc, putdat);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	57                   	push   %edi
  80038c:	ff 75 18             	pushl  0x18(%ebp)
  80038f:	ff d6                	call   *%esi
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	eb eb                	jmp    800381 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	6a 20                	push   $0x20
  80039b:	6a 00                	push   $0x0
  80039d:	50                   	push   %eax
  80039e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a4:	89 fa                	mov    %edi,%edx
  8003a6:	89 f0                	mov    %esi,%eax
  8003a8:	e8 98 ff ff ff       	call   800345 <printnum>
		while (--width > 0)
  8003ad:	83 c4 20             	add    $0x20,%esp
  8003b0:	83 eb 01             	sub    $0x1,%ebx
  8003b3:	85 db                	test   %ebx,%ebx
  8003b5:	7e 65                	jle    80041c <printnum+0xd7>
			putch(padc, putdat);
  8003b7:	83 ec 08             	sub    $0x8,%esp
  8003ba:	57                   	push   %edi
  8003bb:	6a 20                	push   $0x20
  8003bd:	ff d6                	call   *%esi
  8003bf:	83 c4 10             	add    $0x10,%esp
  8003c2:	eb ec                	jmp    8003b0 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c4:	83 ec 0c             	sub    $0xc,%esp
  8003c7:	ff 75 18             	pushl  0x18(%ebp)
  8003ca:	83 eb 01             	sub    $0x1,%ebx
  8003cd:	53                   	push   %ebx
  8003ce:	50                   	push   %eax
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	ff 75 e0             	pushl  -0x20(%ebp)
  8003de:	e8 8d 25 00 00       	call   802970 <__udivdi3>
  8003e3:	83 c4 18             	add    $0x18,%esp
  8003e6:	52                   	push   %edx
  8003e7:	50                   	push   %eax
  8003e8:	89 fa                	mov    %edi,%edx
  8003ea:	89 f0                	mov    %esi,%eax
  8003ec:	e8 54 ff ff ff       	call   800345 <printnum>
  8003f1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	57                   	push   %edi
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003fe:	ff 75 d8             	pushl  -0x28(%ebp)
  800401:	ff 75 e4             	pushl  -0x1c(%ebp)
  800404:	ff 75 e0             	pushl  -0x20(%ebp)
  800407:	e8 74 26 00 00       	call   802a80 <__umoddi3>
  80040c:	83 c4 14             	add    $0x14,%esp
  80040f:	0f be 80 af 2c 80 00 	movsbl 0x802caf(%eax),%eax
  800416:	50                   	push   %eax
  800417:	ff d6                	call   *%esi
  800419:	83 c4 10             	add    $0x10,%esp
	}
}
  80041c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80041f:	5b                   	pop    %ebx
  800420:	5e                   	pop    %esi
  800421:	5f                   	pop    %edi
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80042a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042e:	8b 10                	mov    (%eax),%edx
  800430:	3b 50 04             	cmp    0x4(%eax),%edx
  800433:	73 0a                	jae    80043f <sprintputch+0x1b>
		*b->buf++ = ch;
  800435:	8d 4a 01             	lea    0x1(%edx),%ecx
  800438:	89 08                	mov    %ecx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	88 02                	mov    %al,(%edx)
}
  80043f:	5d                   	pop    %ebp
  800440:	c3                   	ret    

00800441 <printfmt>:
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800447:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80044a:	50                   	push   %eax
  80044b:	ff 75 10             	pushl  0x10(%ebp)
  80044e:	ff 75 0c             	pushl  0xc(%ebp)
  800451:	ff 75 08             	pushl  0x8(%ebp)
  800454:	e8 05 00 00 00       	call   80045e <vprintfmt>
}
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <vprintfmt>:
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	57                   	push   %edi
  800462:	56                   	push   %esi
  800463:	53                   	push   %ebx
  800464:	83 ec 3c             	sub    $0x3c,%esp
  800467:	8b 75 08             	mov    0x8(%ebp),%esi
  80046a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800470:	e9 32 04 00 00       	jmp    8008a7 <vprintfmt+0x449>
		padc = ' ';
  800475:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800479:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800480:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800487:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80048e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800495:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80049c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a1:	8d 47 01             	lea    0x1(%edi),%eax
  8004a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a7:	0f b6 17             	movzbl (%edi),%edx
  8004aa:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004ad:	3c 55                	cmp    $0x55,%al
  8004af:	0f 87 12 05 00 00    	ja     8009c7 <vprintfmt+0x569>
  8004b5:	0f b6 c0             	movzbl %al,%eax
  8004b8:	ff 24 85 80 2e 80 00 	jmp    *0x802e80(,%eax,4)
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c2:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004c6:	eb d9                	jmp    8004a1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cb:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004cf:	eb d0                	jmp    8004a1 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d1:	0f b6 d2             	movzbl %dl,%edx
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8004df:	eb 03                	jmp    8004e4 <vprintfmt+0x86>
  8004e1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004eb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004ee:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f1:	83 fe 09             	cmp    $0x9,%esi
  8004f4:	76 eb                	jbe    8004e1 <vprintfmt+0x83>
  8004f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fc:	eb 14                	jmp    800512 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 40 04             	lea    0x4(%eax),%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800512:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800516:	79 89                	jns    8004a1 <vprintfmt+0x43>
				width = precision, precision = -1;
  800518:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800525:	e9 77 ff ff ff       	jmp    8004a1 <vprintfmt+0x43>
  80052a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052d:	85 c0                	test   %eax,%eax
  80052f:	0f 48 c1             	cmovs  %ecx,%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800535:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800538:	e9 64 ff ff ff       	jmp    8004a1 <vprintfmt+0x43>
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800540:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800547:	e9 55 ff ff ff       	jmp    8004a1 <vprintfmt+0x43>
			lflag++;
  80054c:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800553:	e9 49 ff ff ff       	jmp    8004a1 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 78 04             	lea    0x4(%eax),%edi
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	ff 30                	pushl  (%eax)
  800564:	ff d6                	call   *%esi
			break;
  800566:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800569:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056c:	e9 33 03 00 00       	jmp    8008a4 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 78 04             	lea    0x4(%eax),%edi
  800577:	8b 00                	mov    (%eax),%eax
  800579:	99                   	cltd   
  80057a:	31 d0                	xor    %edx,%eax
  80057c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057e:	83 f8 0f             	cmp    $0xf,%eax
  800581:	7f 23                	jg     8005a6 <vprintfmt+0x148>
  800583:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  80058a:	85 d2                	test   %edx,%edx
  80058c:	74 18                	je     8005a6 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80058e:	52                   	push   %edx
  80058f:	68 6e 31 80 00       	push   $0x80316e
  800594:	53                   	push   %ebx
  800595:	56                   	push   %esi
  800596:	e8 a6 fe ff ff       	call   800441 <printfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80059e:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a1:	e9 fe 02 00 00       	jmp    8008a4 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005a6:	50                   	push   %eax
  8005a7:	68 c7 2c 80 00       	push   $0x802cc7
  8005ac:	53                   	push   %ebx
  8005ad:	56                   	push   %esi
  8005ae:	e8 8e fe ff ff       	call   800441 <printfmt>
  8005b3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005b9:	e9 e6 02 00 00       	jmp    8008a4 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 c0 04             	add    $0x4,%eax
  8005c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005cc:	85 c9                	test   %ecx,%ecx
  8005ce:	b8 c0 2c 80 00       	mov    $0x802cc0,%eax
  8005d3:	0f 45 c1             	cmovne %ecx,%eax
  8005d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005dd:	7e 06                	jle    8005e5 <vprintfmt+0x187>
  8005df:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005e3:	75 0d                	jne    8005f2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e8:	89 c7                	mov    %eax,%edi
  8005ea:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f0:	eb 53                	jmp    800645 <vprintfmt+0x1e7>
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	e8 71 04 00 00       	call   800a6f <strnlen>
  8005fe:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800601:	29 c1                	sub    %eax,%ecx
  800603:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80060b:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80060f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800612:	eb 0f                	jmp    800623 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	ff 75 e0             	pushl  -0x20(%ebp)
  80061b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061d:	83 ef 01             	sub    $0x1,%edi
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	85 ff                	test   %edi,%edi
  800625:	7f ed                	jg     800614 <vprintfmt+0x1b6>
  800627:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80062a:	85 c9                	test   %ecx,%ecx
  80062c:	b8 00 00 00 00       	mov    $0x0,%eax
  800631:	0f 49 c1             	cmovns %ecx,%eax
  800634:	29 c1                	sub    %eax,%ecx
  800636:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800639:	eb aa                	jmp    8005e5 <vprintfmt+0x187>
					putch(ch, putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	52                   	push   %edx
  800640:	ff d6                	call   *%esi
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800648:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064a:	83 c7 01             	add    $0x1,%edi
  80064d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800651:	0f be d0             	movsbl %al,%edx
  800654:	85 d2                	test   %edx,%edx
  800656:	74 4b                	je     8006a3 <vprintfmt+0x245>
  800658:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065c:	78 06                	js     800664 <vprintfmt+0x206>
  80065e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800662:	78 1e                	js     800682 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800664:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800668:	74 d1                	je     80063b <vprintfmt+0x1dd>
  80066a:	0f be c0             	movsbl %al,%eax
  80066d:	83 e8 20             	sub    $0x20,%eax
  800670:	83 f8 5e             	cmp    $0x5e,%eax
  800673:	76 c6                	jbe    80063b <vprintfmt+0x1dd>
					putch('?', putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	53                   	push   %ebx
  800679:	6a 3f                	push   $0x3f
  80067b:	ff d6                	call   *%esi
  80067d:	83 c4 10             	add    $0x10,%esp
  800680:	eb c3                	jmp    800645 <vprintfmt+0x1e7>
  800682:	89 cf                	mov    %ecx,%edi
  800684:	eb 0e                	jmp    800694 <vprintfmt+0x236>
				putch(' ', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 20                	push   $0x20
  80068c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80068e:	83 ef 01             	sub    $0x1,%edi
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	85 ff                	test   %edi,%edi
  800696:	7f ee                	jg     800686 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800698:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	e9 01 02 00 00       	jmp    8008a4 <vprintfmt+0x446>
  8006a3:	89 cf                	mov    %ecx,%edi
  8006a5:	eb ed                	jmp    800694 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006aa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b1:	e9 eb fd ff ff       	jmp    8004a1 <vprintfmt+0x43>
	if (lflag >= 2)
  8006b6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ba:	7f 21                	jg     8006dd <vprintfmt+0x27f>
	else if (lflag)
  8006bc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c0:	74 68                	je     80072a <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8d 40 04             	lea    0x4(%eax),%eax
  8006d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006db:	eb 17                	jmp    8006f4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 50 04             	mov    0x4(%eax),%edx
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 08             	lea    0x8(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800700:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800704:	78 3f                	js     800745 <vprintfmt+0x2e7>
			base = 10;
  800706:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80070b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80070f:	0f 84 71 01 00 00    	je     800886 <vprintfmt+0x428>
				putch('+', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 2b                	push   $0x2b
  80071b:	ff d6                	call   *%esi
  80071d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
  800725:	e9 5c 01 00 00       	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800732:	89 c1                	mov    %eax,%ecx
  800734:	c1 f9 1f             	sar    $0x1f,%ecx
  800737:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	eb af                	jmp    8006f4 <vprintfmt+0x296>
				putch('-', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	6a 2d                	push   $0x2d
  80074b:	ff d6                	call   *%esi
				num = -(long long) num;
  80074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800750:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800753:	f7 d8                	neg    %eax
  800755:	83 d2 00             	adc    $0x0,%edx
  800758:	f7 da                	neg    %edx
  80075a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800760:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800763:	b8 0a 00 00 00       	mov    $0xa,%eax
  800768:	e9 19 01 00 00       	jmp    800886 <vprintfmt+0x428>
	if (lflag >= 2)
  80076d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800771:	7f 29                	jg     80079c <vprintfmt+0x33e>
	else if (lflag)
  800773:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800777:	74 44                	je     8007bd <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8d 40 04             	lea    0x4(%eax),%eax
  80078f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800792:	b8 0a 00 00 00       	mov    $0xa,%eax
  800797:	e9 ea 00 00 00       	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 50 04             	mov    0x4(%eax),%edx
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 08             	lea    0x8(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b8:	e9 c9 00 00 00       	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007db:	e9 a6 00 00 00       	jmp    800886 <vprintfmt+0x428>
			putch('0', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	53                   	push   %ebx
  8007e4:	6a 30                	push   $0x30
  8007e6:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ef:	7f 26                	jg     800817 <vprintfmt+0x3b9>
	else if (lflag)
  8007f1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f5:	74 3e                	je     800835 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800804:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 40 04             	lea    0x4(%eax),%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800810:	b8 08 00 00 00       	mov    $0x8,%eax
  800815:	eb 6f                	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8b 50 04             	mov    0x4(%eax),%edx
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800822:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8d 40 08             	lea    0x8(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082e:	b8 08 00 00 00       	mov    $0x8,%eax
  800833:	eb 51                	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8b 00                	mov    (%eax),%eax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800842:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 40 04             	lea    0x4(%eax),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084e:	b8 08 00 00 00       	mov    $0x8,%eax
  800853:	eb 31                	jmp    800886 <vprintfmt+0x428>
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	53                   	push   %ebx
  800859:	6a 30                	push   $0x30
  80085b:	ff d6                	call   *%esi
			putch('x', putdat);
  80085d:	83 c4 08             	add    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 78                	push   $0x78
  800863:	ff d6                	call   *%esi
			num = (unsigned long long)
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	ba 00 00 00 00       	mov    $0x0,%edx
  80086f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800872:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800875:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 04             	lea    0x4(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800881:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80088d:	52                   	push   %edx
  80088e:	ff 75 e0             	pushl  -0x20(%ebp)
  800891:	50                   	push   %eax
  800892:	ff 75 dc             	pushl  -0x24(%ebp)
  800895:	ff 75 d8             	pushl  -0x28(%ebp)
  800898:	89 da                	mov    %ebx,%edx
  80089a:	89 f0                	mov    %esi,%eax
  80089c:	e8 a4 fa ff ff       	call   800345 <printnum>
			break;
  8008a1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a7:	83 c7 01             	add    $0x1,%edi
  8008aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ae:	83 f8 25             	cmp    $0x25,%eax
  8008b1:	0f 84 be fb ff ff    	je     800475 <vprintfmt+0x17>
			if (ch == '\0')
  8008b7:	85 c0                	test   %eax,%eax
  8008b9:	0f 84 28 01 00 00    	je     8009e7 <vprintfmt+0x589>
			putch(ch, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	53                   	push   %ebx
  8008c3:	50                   	push   %eax
  8008c4:	ff d6                	call   *%esi
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	eb dc                	jmp    8008a7 <vprintfmt+0x449>
	if (lflag >= 2)
  8008cb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008cf:	7f 26                	jg     8008f7 <vprintfmt+0x499>
	else if (lflag)
  8008d1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d5:	74 41                	je     800918 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8b 00                	mov    (%eax),%eax
  8008dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 40 04             	lea    0x4(%eax),%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f0:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f5:	eb 8f                	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8b 50 04             	mov    0x4(%eax),%edx
  8008fd:	8b 00                	mov    (%eax),%eax
  8008ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800902:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8d 40 08             	lea    0x8(%eax),%eax
  80090b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090e:	b8 10 00 00 00       	mov    $0x10,%eax
  800913:	e9 6e ff ff ff       	jmp    800886 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800918:	8b 45 14             	mov    0x14(%ebp),%eax
  80091b:	8b 00                	mov    (%eax),%eax
  80091d:	ba 00 00 00 00       	mov    $0x0,%edx
  800922:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800925:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 40 04             	lea    0x4(%eax),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800931:	b8 10 00 00 00       	mov    $0x10,%eax
  800936:	e9 4b ff ff ff       	jmp    800886 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 c0 04             	add    $0x4,%eax
  800941:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	85 c0                	test   %eax,%eax
  80094b:	74 14                	je     800961 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80094d:	8b 13                	mov    (%ebx),%edx
  80094f:	83 fa 7f             	cmp    $0x7f,%edx
  800952:	7f 37                	jg     80098b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800954:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800956:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800959:	89 45 14             	mov    %eax,0x14(%ebp)
  80095c:	e9 43 ff ff ff       	jmp    8008a4 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800961:	b8 0a 00 00 00       	mov    $0xa,%eax
  800966:	bf e5 2d 80 00       	mov    $0x802de5,%edi
							putch(ch, putdat);
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	53                   	push   %ebx
  80096f:	50                   	push   %eax
  800970:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800972:	83 c7 01             	add    $0x1,%edi
  800975:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	85 c0                	test   %eax,%eax
  80097e:	75 eb                	jne    80096b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800980:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800983:	89 45 14             	mov    %eax,0x14(%ebp)
  800986:	e9 19 ff ff ff       	jmp    8008a4 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80098b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80098d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800992:	bf 1d 2e 80 00       	mov    $0x802e1d,%edi
							putch(ch, putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	53                   	push   %ebx
  80099b:	50                   	push   %eax
  80099c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80099e:	83 c7 01             	add    $0x1,%edi
  8009a1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	85 c0                	test   %eax,%eax
  8009aa:	75 eb                	jne    800997 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009af:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b2:	e9 ed fe ff ff       	jmp    8008a4 <vprintfmt+0x446>
			putch(ch, putdat);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	53                   	push   %ebx
  8009bb:	6a 25                	push   $0x25
  8009bd:	ff d6                	call   *%esi
			break;
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	e9 dd fe ff ff       	jmp    8008a4 <vprintfmt+0x446>
			putch('%', putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	53                   	push   %ebx
  8009cb:	6a 25                	push   $0x25
  8009cd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	89 f8                	mov    %edi,%eax
  8009d4:	eb 03                	jmp    8009d9 <vprintfmt+0x57b>
  8009d6:	83 e8 01             	sub    $0x1,%eax
  8009d9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009dd:	75 f7                	jne    8009d6 <vprintfmt+0x578>
  8009df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e2:	e9 bd fe ff ff       	jmp    8008a4 <vprintfmt+0x446>
}
  8009e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	83 ec 18             	sub    $0x18,%esp
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009fe:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a02:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0c:	85 c0                	test   %eax,%eax
  800a0e:	74 26                	je     800a36 <vsnprintf+0x47>
  800a10:	85 d2                	test   %edx,%edx
  800a12:	7e 22                	jle    800a36 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a14:	ff 75 14             	pushl  0x14(%ebp)
  800a17:	ff 75 10             	pushl  0x10(%ebp)
  800a1a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1d:	50                   	push   %eax
  800a1e:	68 24 04 80 00       	push   $0x800424
  800a23:	e8 36 fa ff ff       	call   80045e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a31:	83 c4 10             	add    $0x10,%esp
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    
		return -E_INVAL;
  800a36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a3b:	eb f7                	jmp    800a34 <vsnprintf+0x45>

00800a3d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a43:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a46:	50                   	push   %eax
  800a47:	ff 75 10             	pushl  0x10(%ebp)
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	ff 75 08             	pushl  0x8(%ebp)
  800a50:	e8 9a ff ff ff       	call   8009ef <vsnprintf>
	va_end(ap);

	return rc;
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a66:	74 05                	je     800a6d <strlen+0x16>
		n++;
  800a68:	83 c0 01             	add    $0x1,%eax
  800a6b:	eb f5                	jmp    800a62 <strlen+0xb>
	return n;
}
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a78:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7d:	39 c2                	cmp    %eax,%edx
  800a7f:	74 0d                	je     800a8e <strnlen+0x1f>
  800a81:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a85:	74 05                	je     800a8c <strnlen+0x1d>
		n++;
  800a87:	83 c2 01             	add    $0x1,%edx
  800a8a:	eb f1                	jmp    800a7d <strnlen+0xe>
  800a8c:	89 d0                	mov    %edx,%eax
	return n;
}
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	84 c9                	test   %cl,%cl
  800aab:	75 f2                	jne    800a9f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	53                   	push   %ebx
  800ab4:	83 ec 10             	sub    $0x10,%esp
  800ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aba:	53                   	push   %ebx
  800abb:	e8 97 ff ff ff       	call   800a57 <strlen>
  800ac0:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	01 d8                	add    %ebx,%eax
  800ac8:	50                   	push   %eax
  800ac9:	e8 c2 ff ff ff       	call   800a90 <strcpy>
	return dst;
}
  800ace:	89 d8                	mov    %ebx,%eax
  800ad0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae0:	89 c6                	mov    %eax,%esi
  800ae2:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae5:	89 c2                	mov    %eax,%edx
  800ae7:	39 f2                	cmp    %esi,%edx
  800ae9:	74 11                	je     800afc <strncpy+0x27>
		*dst++ = *src;
  800aeb:	83 c2 01             	add    $0x1,%edx
  800aee:	0f b6 19             	movzbl (%ecx),%ebx
  800af1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af4:	80 fb 01             	cmp    $0x1,%bl
  800af7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800afa:	eb eb                	jmp    800ae7 <strncpy+0x12>
	}
	return ret;
}
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	8b 75 08             	mov    0x8(%ebp),%esi
  800b08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0b:	8b 55 10             	mov    0x10(%ebp),%edx
  800b0e:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b10:	85 d2                	test   %edx,%edx
  800b12:	74 21                	je     800b35 <strlcpy+0x35>
  800b14:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b18:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	74 14                	je     800b32 <strlcpy+0x32>
  800b1e:	0f b6 19             	movzbl (%ecx),%ebx
  800b21:	84 db                	test   %bl,%bl
  800b23:	74 0b                	je     800b30 <strlcpy+0x30>
			*dst++ = *src++;
  800b25:	83 c1 01             	add    $0x1,%ecx
  800b28:	83 c2 01             	add    $0x1,%edx
  800b2b:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b2e:	eb ea                	jmp    800b1a <strlcpy+0x1a>
  800b30:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b32:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b35:	29 f0                	sub    %esi,%eax
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b44:	0f b6 01             	movzbl (%ecx),%eax
  800b47:	84 c0                	test   %al,%al
  800b49:	74 0c                	je     800b57 <strcmp+0x1c>
  800b4b:	3a 02                	cmp    (%edx),%al
  800b4d:	75 08                	jne    800b57 <strcmp+0x1c>
		p++, q++;
  800b4f:	83 c1 01             	add    $0x1,%ecx
  800b52:	83 c2 01             	add    $0x1,%edx
  800b55:	eb ed                	jmp    800b44 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b57:	0f b6 c0             	movzbl %al,%eax
  800b5a:	0f b6 12             	movzbl (%edx),%edx
  800b5d:	29 d0                	sub    %edx,%eax
}
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	53                   	push   %ebx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6b:	89 c3                	mov    %eax,%ebx
  800b6d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b70:	eb 06                	jmp    800b78 <strncmp+0x17>
		n--, p++, q++;
  800b72:	83 c0 01             	add    $0x1,%eax
  800b75:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b78:	39 d8                	cmp    %ebx,%eax
  800b7a:	74 16                	je     800b92 <strncmp+0x31>
  800b7c:	0f b6 08             	movzbl (%eax),%ecx
  800b7f:	84 c9                	test   %cl,%cl
  800b81:	74 04                	je     800b87 <strncmp+0x26>
  800b83:	3a 0a                	cmp    (%edx),%cl
  800b85:	74 eb                	je     800b72 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b87:	0f b6 00             	movzbl (%eax),%eax
  800b8a:	0f b6 12             	movzbl (%edx),%edx
  800b8d:	29 d0                	sub    %edx,%eax
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    
		return 0;
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	eb f6                	jmp    800b8f <strncmp+0x2e>

00800b99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba3:	0f b6 10             	movzbl (%eax),%edx
  800ba6:	84 d2                	test   %dl,%dl
  800ba8:	74 09                	je     800bb3 <strchr+0x1a>
		if (*s == c)
  800baa:	38 ca                	cmp    %cl,%dl
  800bac:	74 0a                	je     800bb8 <strchr+0x1f>
	for (; *s; s++)
  800bae:	83 c0 01             	add    $0x1,%eax
  800bb1:	eb f0                	jmp    800ba3 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc7:	38 ca                	cmp    %cl,%dl
  800bc9:	74 09                	je     800bd4 <strfind+0x1a>
  800bcb:	84 d2                	test   %dl,%dl
  800bcd:	74 05                	je     800bd4 <strfind+0x1a>
	for (; *s; s++)
  800bcf:	83 c0 01             	add    $0x1,%eax
  800bd2:	eb f0                	jmp    800bc4 <strfind+0xa>
			break;
	return (char *) s;
}
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	57                   	push   %edi
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
  800bdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be2:	85 c9                	test   %ecx,%ecx
  800be4:	74 31                	je     800c17 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be6:	89 f8                	mov    %edi,%eax
  800be8:	09 c8                	or     %ecx,%eax
  800bea:	a8 03                	test   $0x3,%al
  800bec:	75 23                	jne    800c11 <memset+0x3b>
		c &= 0xFF;
  800bee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf2:	89 d3                	mov    %edx,%ebx
  800bf4:	c1 e3 08             	shl    $0x8,%ebx
  800bf7:	89 d0                	mov    %edx,%eax
  800bf9:	c1 e0 18             	shl    $0x18,%eax
  800bfc:	89 d6                	mov    %edx,%esi
  800bfe:	c1 e6 10             	shl    $0x10,%esi
  800c01:	09 f0                	or     %esi,%eax
  800c03:	09 c2                	or     %eax,%edx
  800c05:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c07:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c0a:	89 d0                	mov    %edx,%eax
  800c0c:	fc                   	cld    
  800c0d:	f3 ab                	rep stos %eax,%es:(%edi)
  800c0f:	eb 06                	jmp    800c17 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	fc                   	cld    
  800c15:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c17:	89 f8                	mov    %edi,%eax
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c29:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c2c:	39 c6                	cmp    %eax,%esi
  800c2e:	73 32                	jae    800c62 <memmove+0x44>
  800c30:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c33:	39 c2                	cmp    %eax,%edx
  800c35:	76 2b                	jbe    800c62 <memmove+0x44>
		s += n;
		d += n;
  800c37:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3a:	89 fe                	mov    %edi,%esi
  800c3c:	09 ce                	or     %ecx,%esi
  800c3e:	09 d6                	or     %edx,%esi
  800c40:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c46:	75 0e                	jne    800c56 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c48:	83 ef 04             	sub    $0x4,%edi
  800c4b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c4e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c51:	fd                   	std    
  800c52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c54:	eb 09                	jmp    800c5f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c56:	83 ef 01             	sub    $0x1,%edi
  800c59:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c5c:	fd                   	std    
  800c5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c5f:	fc                   	cld    
  800c60:	eb 1a                	jmp    800c7c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c62:	89 c2                	mov    %eax,%edx
  800c64:	09 ca                	or     %ecx,%edx
  800c66:	09 f2                	or     %esi,%edx
  800c68:	f6 c2 03             	test   $0x3,%dl
  800c6b:	75 0a                	jne    800c77 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c6d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c70:	89 c7                	mov    %eax,%edi
  800c72:	fc                   	cld    
  800c73:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c75:	eb 05                	jmp    800c7c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c77:	89 c7                	mov    %eax,%edi
  800c79:	fc                   	cld    
  800c7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c86:	ff 75 10             	pushl  0x10(%ebp)
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	ff 75 08             	pushl  0x8(%ebp)
  800c8f:	e8 8a ff ff ff       	call   800c1e <memmove>
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca1:	89 c6                	mov    %eax,%esi
  800ca3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca6:	39 f0                	cmp    %esi,%eax
  800ca8:	74 1c                	je     800cc6 <memcmp+0x30>
		if (*s1 != *s2)
  800caa:	0f b6 08             	movzbl (%eax),%ecx
  800cad:	0f b6 1a             	movzbl (%edx),%ebx
  800cb0:	38 d9                	cmp    %bl,%cl
  800cb2:	75 08                	jne    800cbc <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cb4:	83 c0 01             	add    $0x1,%eax
  800cb7:	83 c2 01             	add    $0x1,%edx
  800cba:	eb ea                	jmp    800ca6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cbc:	0f b6 c1             	movzbl %cl,%eax
  800cbf:	0f b6 db             	movzbl %bl,%ebx
  800cc2:	29 d8                	sub    %ebx,%eax
  800cc4:	eb 05                	jmp    800ccb <memcmp+0x35>
	}

	return 0;
  800cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cd8:	89 c2                	mov    %eax,%edx
  800cda:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cdd:	39 d0                	cmp    %edx,%eax
  800cdf:	73 09                	jae    800cea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce1:	38 08                	cmp    %cl,(%eax)
  800ce3:	74 05                	je     800cea <memfind+0x1b>
	for (; s < ends; s++)
  800ce5:	83 c0 01             	add    $0x1,%eax
  800ce8:	eb f3                	jmp    800cdd <memfind+0xe>
			break;
	return (void *) s;
}
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf8:	eb 03                	jmp    800cfd <strtol+0x11>
		s++;
  800cfa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cfd:	0f b6 01             	movzbl (%ecx),%eax
  800d00:	3c 20                	cmp    $0x20,%al
  800d02:	74 f6                	je     800cfa <strtol+0xe>
  800d04:	3c 09                	cmp    $0x9,%al
  800d06:	74 f2                	je     800cfa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d08:	3c 2b                	cmp    $0x2b,%al
  800d0a:	74 2a                	je     800d36 <strtol+0x4a>
	int neg = 0;
  800d0c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d11:	3c 2d                	cmp    $0x2d,%al
  800d13:	74 2b                	je     800d40 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d15:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d1b:	75 0f                	jne    800d2c <strtol+0x40>
  800d1d:	80 39 30             	cmpb   $0x30,(%ecx)
  800d20:	74 28                	je     800d4a <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d22:	85 db                	test   %ebx,%ebx
  800d24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d29:	0f 44 d8             	cmove  %eax,%ebx
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d34:	eb 50                	jmp    800d86 <strtol+0x9a>
		s++;
  800d36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d39:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3e:	eb d5                	jmp    800d15 <strtol+0x29>
		s++, neg = 1;
  800d40:	83 c1 01             	add    $0x1,%ecx
  800d43:	bf 01 00 00 00       	mov    $0x1,%edi
  800d48:	eb cb                	jmp    800d15 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d4e:	74 0e                	je     800d5e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d50:	85 db                	test   %ebx,%ebx
  800d52:	75 d8                	jne    800d2c <strtol+0x40>
		s++, base = 8;
  800d54:	83 c1 01             	add    $0x1,%ecx
  800d57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d5c:	eb ce                	jmp    800d2c <strtol+0x40>
		s += 2, base = 16;
  800d5e:	83 c1 02             	add    $0x2,%ecx
  800d61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d66:	eb c4                	jmp    800d2c <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6b:	89 f3                	mov    %esi,%ebx
  800d6d:	80 fb 19             	cmp    $0x19,%bl
  800d70:	77 29                	ja     800d9b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d72:	0f be d2             	movsbl %dl,%edx
  800d75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d7b:	7d 30                	jge    800dad <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d7d:	83 c1 01             	add    $0x1,%ecx
  800d80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d86:	0f b6 11             	movzbl (%ecx),%edx
  800d89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d8c:	89 f3                	mov    %esi,%ebx
  800d8e:	80 fb 09             	cmp    $0x9,%bl
  800d91:	77 d5                	ja     800d68 <strtol+0x7c>
			dig = *s - '0';
  800d93:	0f be d2             	movsbl %dl,%edx
  800d96:	83 ea 30             	sub    $0x30,%edx
  800d99:	eb dd                	jmp    800d78 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d9e:	89 f3                	mov    %esi,%ebx
  800da0:	80 fb 19             	cmp    $0x19,%bl
  800da3:	77 08                	ja     800dad <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da5:	0f be d2             	movsbl %dl,%edx
  800da8:	83 ea 37             	sub    $0x37,%edx
  800dab:	eb cb                	jmp    800d78 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db1:	74 05                	je     800db8 <strtol+0xcc>
		*endptr = (char *) s;
  800db3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800db8:	89 c2                	mov    %eax,%edx
  800dba:	f7 da                	neg    %edx
  800dbc:	85 ff                	test   %edi,%edi
  800dbe:	0f 45 c2             	cmovne %edx,%eax
}
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd7:	89 c3                	mov    %eax,%ebx
  800dd9:	89 c7                	mov    %eax,%edi
  800ddb:	89 c6                	mov    %eax,%esi
  800ddd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dea:	ba 00 00 00 00       	mov    $0x0,%edx
  800def:	b8 01 00 00 00       	mov    $0x1,%eax
  800df4:	89 d1                	mov    %edx,%ecx
  800df6:	89 d3                	mov    %edx,%ebx
  800df8:	89 d7                	mov    %edx,%edi
  800dfa:	89 d6                	mov    %edx,%esi
  800dfc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	b8 03 00 00 00       	mov    $0x3,%eax
  800e19:	89 cb                	mov    %ecx,%ebx
  800e1b:	89 cf                	mov    %ecx,%edi
  800e1d:	89 ce                	mov    %ecx,%esi
  800e1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	7f 08                	jg     800e2d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	83 ec 0c             	sub    $0xc,%esp
  800e30:	50                   	push   %eax
  800e31:	6a 03                	push   $0x3
  800e33:	68 20 30 80 00       	push   $0x803020
  800e38:	6a 43                	push   $0x43
  800e3a:	68 3d 30 80 00       	push   $0x80303d
  800e3f:	e8 f7 f3 ff ff       	call   80023b <_panic>

00800e44 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800e54:	89 d1                	mov    %edx,%ecx
  800e56:	89 d3                	mov    %edx,%ebx
  800e58:	89 d7                	mov    %edx,%edi
  800e5a:	89 d6                	mov    %edx,%esi
  800e5c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_yield>:

void
sys_yield(void)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e69:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e73:	89 d1                	mov    %edx,%ecx
  800e75:	89 d3                	mov    %edx,%ebx
  800e77:	89 d7                	mov    %edx,%edi
  800e79:	89 d6                	mov    %edx,%esi
  800e7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
  800e88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8b:	be 00 00 00 00       	mov    $0x0,%esi
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	b8 04 00 00 00       	mov    $0x4,%eax
  800e9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9e:	89 f7                	mov    %esi,%edi
  800ea0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7f 08                	jg     800eae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea9:	5b                   	pop    %ebx
  800eaa:	5e                   	pop    %esi
  800eab:	5f                   	pop    %edi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eae:	83 ec 0c             	sub    $0xc,%esp
  800eb1:	50                   	push   %eax
  800eb2:	6a 04                	push   $0x4
  800eb4:	68 20 30 80 00       	push   $0x803020
  800eb9:	6a 43                	push   $0x43
  800ebb:	68 3d 30 80 00       	push   $0x80303d
  800ec0:	e8 76 f3 ff ff       	call   80023b <_panic>

00800ec5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
  800ecb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ece:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7f 08                	jg     800ef0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	50                   	push   %eax
  800ef4:	6a 05                	push   $0x5
  800ef6:	68 20 30 80 00       	push   $0x803020
  800efb:	6a 43                	push   $0x43
  800efd:	68 3d 30 80 00       	push   $0x80303d
  800f02:	e8 34 f3 ff ff       	call   80023b <_panic>

00800f07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7f 08                	jg     800f32 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	83 ec 0c             	sub    $0xc,%esp
  800f35:	50                   	push   %eax
  800f36:	6a 06                	push   $0x6
  800f38:	68 20 30 80 00       	push   $0x803020
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 3d 30 80 00       	push   $0x80303d
  800f44:	e8 f2 f2 ff ff       	call   80023b <_panic>

00800f49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f62:	89 df                	mov    %ebx,%edi
  800f64:	89 de                	mov    %ebx,%esi
  800f66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	7f 08                	jg     800f74 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6f:	5b                   	pop    %ebx
  800f70:	5e                   	pop    %esi
  800f71:	5f                   	pop    %edi
  800f72:	5d                   	pop    %ebp
  800f73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	50                   	push   %eax
  800f78:	6a 08                	push   $0x8
  800f7a:	68 20 30 80 00       	push   $0x803020
  800f7f:	6a 43                	push   $0x43
  800f81:	68 3d 30 80 00       	push   $0x80303d
  800f86:	e8 b0 f2 ff ff       	call   80023b <_panic>

00800f8b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
  800f91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	7f 08                	jg     800fb6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb6:	83 ec 0c             	sub    $0xc,%esp
  800fb9:	50                   	push   %eax
  800fba:	6a 09                	push   $0x9
  800fbc:	68 20 30 80 00       	push   $0x803020
  800fc1:	6a 43                	push   $0x43
  800fc3:	68 3d 30 80 00       	push   $0x80303d
  800fc8:	e8 6e f2 ff ff       	call   80023b <_panic>

00800fcd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	6a 0a                	push   $0xa
  800ffe:	68 20 30 80 00       	push   $0x803020
  801003:	6a 43                	push   $0x43
  801005:	68 3d 30 80 00       	push   $0x80303d
  80100a:	e8 2c f2 ff ff       	call   80023b <_panic>

0080100f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
	asm volatile("int %1\n"
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801020:	be 00 00 00 00       	mov    $0x0,%esi
  801025:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801028:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	b8 0d 00 00 00       	mov    $0xd,%eax
  801048:	89 cb                	mov    %ecx,%ebx
  80104a:	89 cf                	mov    %ecx,%edi
  80104c:	89 ce                	mov    %ecx,%esi
  80104e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801050:	85 c0                	test   %eax,%eax
  801052:	7f 08                	jg     80105c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801054:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801057:	5b                   	pop    %ebx
  801058:	5e                   	pop    %esi
  801059:	5f                   	pop    %edi
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	50                   	push   %eax
  801060:	6a 0d                	push   $0xd
  801062:	68 20 30 80 00       	push   $0x803020
  801067:	6a 43                	push   $0x43
  801069:	68 3d 30 80 00       	push   $0x80303d
  80106e:	e8 c8 f1 ff ff       	call   80023b <_panic>

00801073 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	b8 0e 00 00 00       	mov    $0xe,%eax
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80108f:	5b                   	pop    %ebx
  801090:	5e                   	pop    %esi
  801091:	5f                   	pop    %edi
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010a7:	89 cb                	mov    %ecx,%ebx
  8010a9:	89 cf                	mov    %ecx,%edi
  8010ab:	89 ce                	mov    %ecx,%esi
  8010ad:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	53                   	push   %ebx
  8010b8:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010bb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c2:	83 e1 07             	and    $0x7,%ecx
  8010c5:	83 f9 07             	cmp    $0x7,%ecx
  8010c8:	74 32                	je     8010fc <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010ca:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010d1:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010d7:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010dd:	74 7d                	je     80115c <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010df:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010e6:	83 e1 05             	and    $0x5,%ecx
  8010e9:	83 f9 05             	cmp    $0x5,%ecx
  8010ec:	0f 84 9e 00 00 00    	je     801190 <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010fc:	89 d3                	mov    %edx,%ebx
  8010fe:	c1 e3 0c             	shl    $0xc,%ebx
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	68 05 08 00 00       	push   $0x805
  801109:	53                   	push   %ebx
  80110a:	50                   	push   %eax
  80110b:	53                   	push   %ebx
  80110c:	6a 00                	push   $0x0
  80110e:	e8 b2 fd ff ff       	call   800ec5 <sys_page_map>
		if(r < 0)
  801113:	83 c4 20             	add    $0x20,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 2e                	js     801148 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 05 08 00 00       	push   $0x805
  801122:	53                   	push   %ebx
  801123:	6a 00                	push   $0x0
  801125:	53                   	push   %ebx
  801126:	6a 00                	push   $0x0
  801128:	e8 98 fd ff ff       	call   800ec5 <sys_page_map>
		if(r < 0)
  80112d:	83 c4 20             	add    $0x20,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	79 be                	jns    8010f2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801134:	83 ec 04             	sub    $0x4,%esp
  801137:	68 4b 30 80 00       	push   $0x80304b
  80113c:	6a 57                	push   $0x57
  80113e:	68 61 30 80 00       	push   $0x803061
  801143:	e8 f3 f0 ff ff       	call   80023b <_panic>
			panic("sys_page_map() panic\n");
  801148:	83 ec 04             	sub    $0x4,%esp
  80114b:	68 4b 30 80 00       	push   $0x80304b
  801150:	6a 53                	push   $0x53
  801152:	68 61 30 80 00       	push   $0x803061
  801157:	e8 df f0 ff ff       	call   80023b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80115c:	c1 e2 0c             	shl    $0xc,%edx
  80115f:	83 ec 0c             	sub    $0xc,%esp
  801162:	68 05 08 00 00       	push   $0x805
  801167:	52                   	push   %edx
  801168:	50                   	push   %eax
  801169:	52                   	push   %edx
  80116a:	6a 00                	push   $0x0
  80116c:	e8 54 fd ff ff       	call   800ec5 <sys_page_map>
		if(r < 0)
  801171:	83 c4 20             	add    $0x20,%esp
  801174:	85 c0                	test   %eax,%eax
  801176:	0f 89 76 ff ff ff    	jns    8010f2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	68 4b 30 80 00       	push   $0x80304b
  801184:	6a 5e                	push   $0x5e
  801186:	68 61 30 80 00       	push   $0x803061
  80118b:	e8 ab f0 ff ff       	call   80023b <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801190:	c1 e2 0c             	shl    $0xc,%edx
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	6a 05                	push   $0x5
  801198:	52                   	push   %edx
  801199:	50                   	push   %eax
  80119a:	52                   	push   %edx
  80119b:	6a 00                	push   $0x0
  80119d:	e8 23 fd ff ff       	call   800ec5 <sys_page_map>
		if(r < 0)
  8011a2:	83 c4 20             	add    $0x20,%esp
  8011a5:	85 c0                	test   %eax,%eax
  8011a7:	0f 89 45 ff ff ff    	jns    8010f2 <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	68 4b 30 80 00       	push   $0x80304b
  8011b5:	6a 65                	push   $0x65
  8011b7:	68 61 30 80 00       	push   $0x803061
  8011bc:	e8 7a f0 ff ff       	call   80023b <_panic>

008011c1 <pgfault>:
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011cb:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011cd:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011d1:	0f 84 99 00 00 00    	je     801270 <pgfault+0xaf>
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	c1 ea 16             	shr    $0x16,%edx
  8011dc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e3:	f6 c2 01             	test   $0x1,%dl
  8011e6:	0f 84 84 00 00 00    	je     801270 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011ec:	89 c2                	mov    %eax,%edx
  8011ee:	c1 ea 0c             	shr    $0xc,%edx
  8011f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f8:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011fe:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801204:	75 6a                	jne    801270 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801206:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120b:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80120d:	83 ec 04             	sub    $0x4,%esp
  801210:	6a 07                	push   $0x7
  801212:	68 00 f0 7f 00       	push   $0x7ff000
  801217:	6a 00                	push   $0x0
  801219:	e8 64 fc ff ff       	call   800e82 <sys_page_alloc>
	if(ret < 0)
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 5f                	js     801284 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	68 00 10 00 00       	push   $0x1000
  80122d:	53                   	push   %ebx
  80122e:	68 00 f0 7f 00       	push   $0x7ff000
  801233:	e8 48 fa ff ff       	call   800c80 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801238:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80123f:	53                   	push   %ebx
  801240:	6a 00                	push   $0x0
  801242:	68 00 f0 7f 00       	push   $0x7ff000
  801247:	6a 00                	push   $0x0
  801249:	e8 77 fc ff ff       	call   800ec5 <sys_page_map>
	if(ret < 0)
  80124e:	83 c4 20             	add    $0x20,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	78 43                	js     801298 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801255:	83 ec 08             	sub    $0x8,%esp
  801258:	68 00 f0 7f 00       	push   $0x7ff000
  80125d:	6a 00                	push   $0x0
  80125f:	e8 a3 fc ff ff       	call   800f07 <sys_page_unmap>
	if(ret < 0)
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	78 41                	js     8012ac <pgfault+0xeb>
}
  80126b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    
		panic("panic at pgfault()\n");
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	68 6c 30 80 00       	push   $0x80306c
  801278:	6a 26                	push   $0x26
  80127a:	68 61 30 80 00       	push   $0x803061
  80127f:	e8 b7 ef ff ff       	call   80023b <_panic>
		panic("panic in sys_page_alloc()\n");
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	68 80 30 80 00       	push   $0x803080
  80128c:	6a 31                	push   $0x31
  80128e:	68 61 30 80 00       	push   $0x803061
  801293:	e8 a3 ef ff ff       	call   80023b <_panic>
		panic("panic in sys_page_map()\n");
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	68 9b 30 80 00       	push   $0x80309b
  8012a0:	6a 36                	push   $0x36
  8012a2:	68 61 30 80 00       	push   $0x803061
  8012a7:	e8 8f ef ff ff       	call   80023b <_panic>
		panic("panic in sys_page_unmap()\n");
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 b4 30 80 00       	push   $0x8030b4
  8012b4:	6a 39                	push   $0x39
  8012b6:	68 61 30 80 00       	push   $0x803061
  8012bb:	e8 7b ef ff ff       	call   80023b <_panic>

008012c0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  8012c9:	68 c1 11 80 00       	push   $0x8011c1
  8012ce:	e8 47 08 00 00       	call   801b1a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012d3:	b8 07 00 00 00       	mov    $0x7,%eax
  8012d8:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012da:	83 c4 10             	add    $0x10,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	78 27                	js     801308 <fork+0x48>
  8012e1:	89 c6                	mov    %eax,%esi
  8012e3:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012e5:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8012ea:	75 48                	jne    801334 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ec:	e8 53 fb ff ff       	call   800e44 <sys_getenvid>
  8012f1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f6:	c1 e0 07             	shl    $0x7,%eax
  8012f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012fe:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801303:	e9 90 00 00 00       	jmp    801398 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	68 d0 30 80 00       	push   $0x8030d0
  801310:	68 85 00 00 00       	push   $0x85
  801315:	68 61 30 80 00       	push   $0x803061
  80131a:	e8 1c ef ff ff       	call   80023b <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80131f:	89 f8                	mov    %edi,%eax
  801321:	e8 8e fd ff ff       	call   8010b4 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801326:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80132c:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801332:	74 26                	je     80135a <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801334:	89 d8                	mov    %ebx,%eax
  801336:	c1 e8 16             	shr    $0x16,%eax
  801339:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801340:	a8 01                	test   $0x1,%al
  801342:	74 e2                	je     801326 <fork+0x66>
  801344:	89 da                	mov    %ebx,%edx
  801346:	c1 ea 0c             	shr    $0xc,%edx
  801349:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801350:	83 e0 05             	and    $0x5,%eax
  801353:	83 f8 05             	cmp    $0x5,%eax
  801356:	75 ce                	jne    801326 <fork+0x66>
  801358:	eb c5                	jmp    80131f <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	6a 07                	push   $0x7
  80135f:	68 00 f0 bf ee       	push   $0xeebff000
  801364:	56                   	push   %esi
  801365:	e8 18 fb ff ff       	call   800e82 <sys_page_alloc>
	if(ret < 0)
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 31                	js     8013a2 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	68 89 1b 80 00       	push   $0x801b89
  801379:	56                   	push   %esi
  80137a:	e8 4e fc ff ff       	call   800fcd <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80137f:	83 c4 10             	add    $0x10,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 33                	js     8013b9 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	6a 02                	push   $0x2
  80138b:	56                   	push   %esi
  80138c:	e8 b8 fb ff ff       	call   800f49 <sys_env_set_status>
	if(ret < 0)
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 38                	js     8013d0 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801398:	89 f0                	mov    %esi,%eax
  80139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139d:	5b                   	pop    %ebx
  80139e:	5e                   	pop    %esi
  80139f:	5f                   	pop    %edi
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	68 80 30 80 00       	push   $0x803080
  8013aa:	68 91 00 00 00       	push   $0x91
  8013af:	68 61 30 80 00       	push   $0x803061
  8013b4:	e8 82 ee ff ff       	call   80023b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	68 f4 30 80 00       	push   $0x8030f4
  8013c1:	68 94 00 00 00       	push   $0x94
  8013c6:	68 61 30 80 00       	push   $0x803061
  8013cb:	e8 6b ee ff ff       	call   80023b <_panic>
		panic("panic in sys_env_set_status()\n");
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	68 1c 31 80 00       	push   $0x80311c
  8013d8:	68 97 00 00 00       	push   $0x97
  8013dd:	68 61 30 80 00       	push   $0x803061
  8013e2:	e8 54 ee ff ff       	call   80023b <_panic>

008013e7 <sfork>:

// Challenge!
int
sfork(void)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	57                   	push   %edi
  8013eb:	56                   	push   %esi
  8013ec:	53                   	push   %ebx
  8013ed:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8013f0:	a1 04 50 80 00       	mov    0x805004,%eax
  8013f5:	8b 40 48             	mov    0x48(%eax),%eax
  8013f8:	68 3c 31 80 00       	push   $0x80313c
  8013fd:	50                   	push   %eax
  8013fe:	68 77 2c 80 00       	push   $0x802c77
  801403:	e8 29 ef ff ff       	call   800331 <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801408:	c7 04 24 c1 11 80 00 	movl   $0x8011c1,(%esp)
  80140f:	e8 06 07 00 00       	call   801b1a <set_pgfault_handler>
  801414:	b8 07 00 00 00       	mov    $0x7,%eax
  801419:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 27                	js     801449 <sfork+0x62>
  801422:	89 c7                	mov    %eax,%edi
  801424:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801426:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80142b:	75 55                	jne    801482 <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  80142d:	e8 12 fa ff ff       	call   800e44 <sys_getenvid>
  801432:	25 ff 03 00 00       	and    $0x3ff,%eax
  801437:	c1 e0 07             	shl    $0x7,%eax
  80143a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80143f:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  801444:	e9 d4 00 00 00       	jmp    80151d <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801449:	83 ec 04             	sub    $0x4,%esp
  80144c:	68 d0 30 80 00       	push   $0x8030d0
  801451:	68 a9 00 00 00       	push   $0xa9
  801456:	68 61 30 80 00       	push   $0x803061
  80145b:	e8 db ed ff ff       	call   80023b <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801460:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801465:	89 f0                	mov    %esi,%eax
  801467:	e8 48 fc ff ff       	call   8010b4 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80146c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801472:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801478:	77 65                	ja     8014df <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  80147a:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801480:	74 de                	je     801460 <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801482:	89 d8                	mov    %ebx,%eax
  801484:	c1 e8 16             	shr    $0x16,%eax
  801487:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148e:	a8 01                	test   $0x1,%al
  801490:	74 da                	je     80146c <sfork+0x85>
  801492:	89 da                	mov    %ebx,%edx
  801494:	c1 ea 0c             	shr    $0xc,%edx
  801497:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80149e:	83 e0 05             	and    $0x5,%eax
  8014a1:	83 f8 05             	cmp    $0x5,%eax
  8014a4:	75 c6                	jne    80146c <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014a6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014ad:	c1 e2 0c             	shl    $0xc,%edx
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	83 e0 07             	and    $0x7,%eax
  8014b6:	50                   	push   %eax
  8014b7:	52                   	push   %edx
  8014b8:	56                   	push   %esi
  8014b9:	52                   	push   %edx
  8014ba:	6a 00                	push   $0x0
  8014bc:	e8 04 fa ff ff       	call   800ec5 <sys_page_map>
  8014c1:	83 c4 20             	add    $0x20,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	74 a4                	je     80146c <sfork+0x85>
				panic("sys_page_map() panic\n");
  8014c8:	83 ec 04             	sub    $0x4,%esp
  8014cb:	68 4b 30 80 00       	push   $0x80304b
  8014d0:	68 b4 00 00 00       	push   $0xb4
  8014d5:	68 61 30 80 00       	push   $0x803061
  8014da:	e8 5c ed ff ff       	call   80023b <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	6a 07                	push   $0x7
  8014e4:	68 00 f0 bf ee       	push   $0xeebff000
  8014e9:	57                   	push   %edi
  8014ea:	e8 93 f9 ff ff       	call   800e82 <sys_page_alloc>
	if(ret < 0)
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 31                	js     801527 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	68 89 1b 80 00       	push   $0x801b89
  8014fe:	57                   	push   %edi
  8014ff:	e8 c9 fa ff ff       	call   800fcd <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	85 c0                	test   %eax,%eax
  801509:	78 33                	js     80153e <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	6a 02                	push   $0x2
  801510:	57                   	push   %edi
  801511:	e8 33 fa ff ff       	call   800f49 <sys_env_set_status>
	if(ret < 0)
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 38                	js     801555 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  80151d:	89 f8                	mov    %edi,%eax
  80151f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5f                   	pop    %edi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 80 30 80 00       	push   $0x803080
  80152f:	68 ba 00 00 00       	push   $0xba
  801534:	68 61 30 80 00       	push   $0x803061
  801539:	e8 fd ec ff ff       	call   80023b <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 f4 30 80 00       	push   $0x8030f4
  801546:	68 bd 00 00 00       	push   $0xbd
  80154b:	68 61 30 80 00       	push   $0x803061
  801550:	e8 e6 ec ff ff       	call   80023b <_panic>
		panic("panic in sys_env_set_status()\n");
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	68 1c 31 80 00       	push   $0x80311c
  80155d:	68 c0 00 00 00       	push   $0xc0
  801562:	68 61 30 80 00       	push   $0x803061
  801567:	e8 cf ec ff ff       	call   80023b <_panic>

0080156c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	57                   	push   %edi
  801570:	56                   	push   %esi
  801571:	53                   	push   %ebx
  801572:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	e8 48 0d 00 00       	call   8022ca <open>
  801582:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	0f 88 71 04 00 00    	js     801a04 <spawn+0x498>
  801593:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	68 00 02 00 00       	push   $0x200
  80159d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	52                   	push   %edx
  8015a5:	e8 70 09 00 00       	call   801f1a <readn>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	3d 00 02 00 00       	cmp    $0x200,%eax
  8015b2:	75 5f                	jne    801613 <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  8015b4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8015bb:	45 4c 46 
  8015be:	75 53                	jne    801613 <spawn+0xa7>
  8015c0:	b8 07 00 00 00       	mov    $0x7,%eax
  8015c5:	cd 30                	int    $0x30
  8015c7:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8015cd:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	0f 88 1d 04 00 00    	js     8019f8 <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8015db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015e0:	89 c6                	mov    %eax,%esi
  8015e2:	c1 e6 07             	shl    $0x7,%esi
  8015e5:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8015eb:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8015f1:	b9 11 00 00 00       	mov    $0x11,%ecx
  8015f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8015f8:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8015fe:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801604:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801609:	be 00 00 00 00       	mov    $0x0,%esi
  80160e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801611:	eb 4b                	jmp    80165e <spawn+0xf2>
		close(fd);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80161c:	e8 34 07 00 00       	call   801d55 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801621:	83 c4 0c             	add    $0xc,%esp
  801624:	68 7f 45 4c 46       	push   $0x464c457f
  801629:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80162f:	68 42 31 80 00       	push   $0x803142
  801634:	e8 f8 ec ff ff       	call   800331 <cprintf>
		return -E_NOT_EXEC;
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801643:	ff ff ff 
  801646:	e9 b9 03 00 00       	jmp    801a04 <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	50                   	push   %eax
  80164f:	e8 03 f4 ff ff       	call   800a57 <strlen>
  801654:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801658:	83 c3 01             	add    $0x1,%ebx
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801665:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801668:	85 c0                	test   %eax,%eax
  80166a:	75 df                	jne    80164b <spawn+0xdf>
  80166c:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801672:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801678:	bf 00 10 40 00       	mov    $0x401000,%edi
  80167d:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80167f:	89 fa                	mov    %edi,%edx
  801681:	83 e2 fc             	and    $0xfffffffc,%edx
  801684:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80168b:	29 c2                	sub    %eax,%edx
  80168d:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801693:	8d 42 f8             	lea    -0x8(%edx),%eax
  801696:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80169b:	0f 86 86 03 00 00    	jbe    801a27 <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	6a 07                	push   $0x7
  8016a6:	68 00 00 40 00       	push   $0x400000
  8016ab:	6a 00                	push   $0x0
  8016ad:	e8 d0 f7 ff ff       	call   800e82 <sys_page_alloc>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	0f 88 6f 03 00 00    	js     801a2c <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8016bd:	be 00 00 00 00       	mov    $0x0,%esi
  8016c2:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8016c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016cb:	eb 30                	jmp    8016fd <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  8016cd:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8016d3:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8016d9:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8016dc:	83 ec 08             	sub    $0x8,%esp
  8016df:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016e2:	57                   	push   %edi
  8016e3:	e8 a8 f3 ff ff       	call   800a90 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8016e8:	83 c4 04             	add    $0x4,%esp
  8016eb:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8016ee:	e8 64 f3 ff ff       	call   800a57 <strlen>
  8016f3:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8016f7:	83 c6 01             	add    $0x1,%esi
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801703:	7f c8                	jg     8016cd <spawn+0x161>
	}
	argv_store[argc] = 0;
  801705:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80170b:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801711:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801718:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80171e:	0f 85 86 00 00 00    	jne    8017aa <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801724:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80172a:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801730:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801733:	89 c8                	mov    %ecx,%eax
  801735:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80173b:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80173e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801743:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	6a 07                	push   $0x7
  80174e:	68 00 d0 bf ee       	push   $0xeebfd000
  801753:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801759:	68 00 00 40 00       	push   $0x400000
  80175e:	6a 00                	push   $0x0
  801760:	e8 60 f7 ff ff       	call   800ec5 <sys_page_map>
  801765:	89 c3                	mov    %eax,%ebx
  801767:	83 c4 20             	add    $0x20,%esp
  80176a:	85 c0                	test   %eax,%eax
  80176c:	0f 88 c2 02 00 00    	js     801a34 <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	68 00 00 40 00       	push   $0x400000
  80177a:	6a 00                	push   $0x0
  80177c:	e8 86 f7 ff ff       	call   800f07 <sys_page_unmap>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	0f 88 a6 02 00 00    	js     801a34 <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80178e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801794:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80179b:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8017a2:	00 00 00 
  8017a5:	e9 4f 01 00 00       	jmp    8018f9 <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8017aa:	68 cc 31 80 00       	push   $0x8031cc
  8017af:	68 5c 31 80 00       	push   $0x80315c
  8017b4:	68 f2 00 00 00       	push   $0xf2
  8017b9:	68 71 31 80 00       	push   $0x803171
  8017be:	e8 78 ea ff ff       	call   80023b <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	6a 07                	push   $0x7
  8017c8:	68 00 00 40 00       	push   $0x400000
  8017cd:	6a 00                	push   $0x0
  8017cf:	e8 ae f6 ff ff       	call   800e82 <sys_page_alloc>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	0f 88 33 02 00 00    	js     801a12 <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8017df:	83 ec 08             	sub    $0x8,%esp
  8017e2:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8017e8:	01 f0                	add    %esi,%eax
  8017ea:	50                   	push   %eax
  8017eb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8017f1:	e8 eb 07 00 00       	call   801fe1 <seek>
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	0f 88 18 02 00 00    	js     801a19 <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80180a:	29 f0                	sub    %esi,%eax
  80180c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801811:	ba 00 10 00 00       	mov    $0x1000,%edx
  801816:	0f 47 c2             	cmova  %edx,%eax
  801819:	50                   	push   %eax
  80181a:	68 00 00 40 00       	push   $0x400000
  80181f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801825:	e8 f0 06 00 00       	call   801f1a <readn>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	85 c0                	test   %eax,%eax
  80182f:	0f 88 eb 01 00 00    	js     801a20 <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80183e:	53                   	push   %ebx
  80183f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801845:	68 00 00 40 00       	push   $0x400000
  80184a:	6a 00                	push   $0x0
  80184c:	e8 74 f6 ff ff       	call   800ec5 <sys_page_map>
  801851:	83 c4 20             	add    $0x20,%esp
  801854:	85 c0                	test   %eax,%eax
  801856:	78 7c                	js     8018d4 <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	68 00 00 40 00       	push   $0x400000
  801860:	6a 00                	push   $0x0
  801862:	e8 a0 f6 ff ff       	call   800f07 <sys_page_unmap>
  801867:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80186a:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801870:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801876:	89 fe                	mov    %edi,%esi
  801878:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  80187e:	76 69                	jbe    8018e9 <spawn+0x37d>
		if (i >= filesz) {
  801880:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801886:	0f 87 37 ff ff ff    	ja     8017c3 <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801895:	53                   	push   %ebx
  801896:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80189c:	e8 e1 f5 ff ff       	call   800e82 <sys_page_alloc>
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	79 c2                	jns    80186a <spawn+0x2fe>
  8018a8:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8018aa:	83 ec 0c             	sub    $0xc,%esp
  8018ad:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8018b3:	e8 4b f5 ff ff       	call   800e03 <sys_env_destroy>
	close(fd);
  8018b8:	83 c4 04             	add    $0x4,%esp
  8018bb:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8018c1:	e8 8f 04 00 00       	call   801d55 <close>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  8018cf:	e9 30 01 00 00       	jmp    801a04 <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  8018d4:	50                   	push   %eax
  8018d5:	68 7d 31 80 00       	push   $0x80317d
  8018da:	68 25 01 00 00       	push   $0x125
  8018df:	68 71 31 80 00       	push   $0x803171
  8018e4:	e8 52 e9 ff ff       	call   80023b <_panic>
  8018e9:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018ef:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8018f6:	83 c6 20             	add    $0x20,%esi
  8018f9:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801900:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801906:	7e 6d                	jle    801975 <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  801908:	83 3e 01             	cmpl   $0x1,(%esi)
  80190b:	75 e2                	jne    8018ef <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80190d:	8b 46 18             	mov    0x18(%esi),%eax
  801910:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801913:	83 f8 01             	cmp    $0x1,%eax
  801916:	19 c0                	sbb    %eax,%eax
  801918:	83 e0 fe             	and    $0xfffffffe,%eax
  80191b:	83 c0 07             	add    $0x7,%eax
  80191e:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801924:	8b 4e 04             	mov    0x4(%esi),%ecx
  801927:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80192d:	8b 56 10             	mov    0x10(%esi),%edx
  801930:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801936:	8b 7e 14             	mov    0x14(%esi),%edi
  801939:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  80193f:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801942:	89 d8                	mov    %ebx,%eax
  801944:	25 ff 0f 00 00       	and    $0xfff,%eax
  801949:	74 1a                	je     801965 <spawn+0x3f9>
		va -= i;
  80194b:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80194d:	01 c7                	add    %eax,%edi
  80194f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801955:	01 c2                	add    %eax,%edx
  801957:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  80195d:	29 c1                	sub    %eax,%ecx
  80195f:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801965:	bf 00 00 00 00       	mov    $0x0,%edi
  80196a:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801970:	e9 01 ff ff ff       	jmp    801876 <spawn+0x30a>
	close(fd);
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80197e:	e8 d2 03 00 00       	call   801d55 <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801983:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80198a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80198d:	83 c4 08             	add    $0x8,%esp
  801990:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801996:	50                   	push   %eax
  801997:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80199d:	e8 e9 f5 ff ff       	call   800f8b <sys_env_set_trapframe>
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 25                	js     8019ce <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8019a9:	83 ec 08             	sub    $0x8,%esp
  8019ac:	6a 02                	push   $0x2
  8019ae:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019b4:	e8 90 f5 ff ff       	call   800f49 <sys_env_set_status>
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 23                	js     8019e3 <spawn+0x477>
	return child;
  8019c0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8019c6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019cc:	eb 36                	jmp    801a04 <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  8019ce:	50                   	push   %eax
  8019cf:	68 9a 31 80 00       	push   $0x80319a
  8019d4:	68 86 00 00 00       	push   $0x86
  8019d9:	68 71 31 80 00       	push   $0x803171
  8019de:	e8 58 e8 ff ff       	call   80023b <_panic>
		panic("sys_env_set_status: %e", r);
  8019e3:	50                   	push   %eax
  8019e4:	68 b4 31 80 00       	push   $0x8031b4
  8019e9:	68 89 00 00 00       	push   $0x89
  8019ee:	68 71 31 80 00       	push   $0x803171
  8019f3:	e8 43 e8 ff ff       	call   80023b <_panic>
		return r;
  8019f8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8019fe:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801a04:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5e                   	pop    %esi
  801a0f:	5f                   	pop    %edi
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    
  801a12:	89 c7                	mov    %eax,%edi
  801a14:	e9 91 fe ff ff       	jmp    8018aa <spawn+0x33e>
  801a19:	89 c7                	mov    %eax,%edi
  801a1b:	e9 8a fe ff ff       	jmp    8018aa <spawn+0x33e>
  801a20:	89 c7                	mov    %eax,%edi
  801a22:	e9 83 fe ff ff       	jmp    8018aa <spawn+0x33e>
		return -E_NO_MEM;
  801a27:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a2c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801a32:	eb d0                	jmp    801a04 <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  801a34:	83 ec 08             	sub    $0x8,%esp
  801a37:	68 00 00 40 00       	push   $0x400000
  801a3c:	6a 00                	push   $0x0
  801a3e:	e8 c4 f4 ff ff       	call   800f07 <sys_page_unmap>
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801a4c:	eb b6                	jmp    801a04 <spawn+0x498>

00801a4e <spawnl>:
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	57                   	push   %edi
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801a57:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801a5f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a62:	83 3a 00             	cmpl   $0x0,(%edx)
  801a65:	74 07                	je     801a6e <spawnl+0x20>
		argc++;
  801a67:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801a6a:	89 ca                	mov    %ecx,%edx
  801a6c:	eb f1                	jmp    801a5f <spawnl+0x11>
	const char *argv[argc+2];
  801a6e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801a75:	83 e2 f0             	and    $0xfffffff0,%edx
  801a78:	29 d4                	sub    %edx,%esp
  801a7a:	8d 54 24 03          	lea    0x3(%esp),%edx
  801a7e:	c1 ea 02             	shr    $0x2,%edx
  801a81:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801a88:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801a94:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801a9b:	00 
	va_start(vl, arg0);
  801a9c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801a9f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa6:	eb 0b                	jmp    801ab3 <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801aa8:	83 c0 01             	add    $0x1,%eax
  801aab:	8b 39                	mov    (%ecx),%edi
  801aad:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ab0:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ab3:	39 d0                	cmp    %edx,%eax
  801ab5:	75 f1                	jne    801aa8 <spawnl+0x5a>
	return spawn(prog, argv);
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	56                   	push   %esi
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	e8 a9 fa ff ff       	call   80156c <spawn>
}
  801ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5e                   	pop    %esi
  801ac8:	5f                   	pop    %edi
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    

00801acb <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801ad3:	85 f6                	test   %esi,%esi
  801ad5:	74 13                	je     801aea <wait+0x1f>
	e = &envs[ENVX(envid)];
  801ad7:	89 f3                	mov    %esi,%ebx
  801ad9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801adf:	c1 e3 07             	shl    $0x7,%ebx
  801ae2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  801ae8:	eb 1b                	jmp    801b05 <wait+0x3a>
	assert(envid != 0);
  801aea:	68 f2 31 80 00       	push   $0x8031f2
  801aef:	68 5c 31 80 00       	push   $0x80315c
  801af4:	6a 09                	push   $0x9
  801af6:	68 fd 31 80 00       	push   $0x8031fd
  801afb:	e8 3b e7 ff ff       	call   80023b <_panic>
		sys_yield();
  801b00:	e8 5e f3 ff ff       	call   800e63 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801b05:	8b 43 48             	mov    0x48(%ebx),%eax
  801b08:	39 f0                	cmp    %esi,%eax
  801b0a:	75 07                	jne    801b13 <wait+0x48>
  801b0c:	8b 43 54             	mov    0x54(%ebx),%eax
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	75 ed                	jne    801b00 <wait+0x35>
}
  801b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b16:	5b                   	pop    %ebx
  801b17:	5e                   	pop    %esi
  801b18:	5d                   	pop    %ebp
  801b19:	c3                   	ret    

00801b1a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801b20:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  801b27:	74 0a                	je     801b33 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	a3 08 50 80 00       	mov    %eax,0x805008
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	6a 07                	push   $0x7
  801b38:	68 00 f0 bf ee       	push   $0xeebff000
  801b3d:	6a 00                	push   $0x0
  801b3f:	e8 3e f3 ff ff       	call   800e82 <sys_page_alloc>
		if(r < 0)
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 2a                	js     801b75 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	68 89 1b 80 00       	push   $0x801b89
  801b53:	6a 00                	push   $0x0
  801b55:	e8 73 f4 ff ff       	call   800fcd <sys_env_set_pgfault_upcall>
		if(r < 0)
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	79 c8                	jns    801b29 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	68 38 32 80 00       	push   $0x803238
  801b69:	6a 25                	push   $0x25
  801b6b:	68 71 32 80 00       	push   $0x803271
  801b70:	e8 c6 e6 ff ff       	call   80023b <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 08 32 80 00       	push   $0x803208
  801b7d:	6a 22                	push   $0x22
  801b7f:	68 71 32 80 00       	push   $0x803271
  801b84:	e8 b2 e6 ff ff       	call   80023b <_panic>

00801b89 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801b89:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801b8a:	a1 08 50 80 00       	mov    0x805008,%eax
	call *%eax
  801b8f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801b91:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801b94:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801b98:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801b9c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801b9f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801ba1:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801ba5:	83 c4 08             	add    $0x8,%esp
	popal
  801ba8:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801ba9:	83 c4 04             	add    $0x4,%esp
	popfl
  801bac:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801bad:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801bae:	c3                   	ret    

00801baf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	05 00 00 00 30       	add    $0x30000000,%eax
  801bba:	c1 e8 0c             	shr    $0xc,%eax
}
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801bca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bcf:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801bde:	89 c2                	mov    %eax,%edx
  801be0:	c1 ea 16             	shr    $0x16,%edx
  801be3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801bea:	f6 c2 01             	test   $0x1,%dl
  801bed:	74 2d                	je     801c1c <fd_alloc+0x46>
  801bef:	89 c2                	mov    %eax,%edx
  801bf1:	c1 ea 0c             	shr    $0xc,%edx
  801bf4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801bfb:	f6 c2 01             	test   $0x1,%dl
  801bfe:	74 1c                	je     801c1c <fd_alloc+0x46>
  801c00:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801c05:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801c0a:	75 d2                	jne    801bde <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801c15:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801c1a:	eb 0a                	jmp    801c26 <fd_alloc+0x50>
			*fd_store = fd;
  801c1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c2e:	83 f8 1f             	cmp    $0x1f,%eax
  801c31:	77 30                	ja     801c63 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801c33:	c1 e0 0c             	shl    $0xc,%eax
  801c36:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801c3b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801c41:	f6 c2 01             	test   $0x1,%dl
  801c44:	74 24                	je     801c6a <fd_lookup+0x42>
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	c1 ea 0c             	shr    $0xc,%edx
  801c4b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c52:	f6 c2 01             	test   $0x1,%dl
  801c55:	74 1a                	je     801c71 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801c57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5a:	89 02                	mov    %eax,(%edx)
	return 0;
  801c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    
		return -E_INVAL;
  801c63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c68:	eb f7                	jmp    801c61 <fd_lookup+0x39>
		return -E_INVAL;
  801c6a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c6f:	eb f0                	jmp    801c61 <fd_lookup+0x39>
  801c71:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c76:	eb e9                	jmp    801c61 <fd_lookup+0x39>

00801c78 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
  801c7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c81:	ba 00 33 80 00       	mov    $0x803300,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801c86:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801c8b:	39 08                	cmp    %ecx,(%eax)
  801c8d:	74 33                	je     801cc2 <dev_lookup+0x4a>
  801c8f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801c92:	8b 02                	mov    (%edx),%eax
  801c94:	85 c0                	test   %eax,%eax
  801c96:	75 f3                	jne    801c8b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801c98:	a1 04 50 80 00       	mov    0x805004,%eax
  801c9d:	8b 40 48             	mov    0x48(%eax),%eax
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	51                   	push   %ecx
  801ca4:	50                   	push   %eax
  801ca5:	68 80 32 80 00       	push   $0x803280
  801caa:	e8 82 e6 ff ff       	call   800331 <cprintf>
	*dev = 0;
  801caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    
			*dev = devtab[i];
  801cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc5:	89 01                	mov    %eax,(%ecx)
			return 0;
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	eb f2                	jmp    801cc0 <dev_lookup+0x48>

00801cce <fd_close>:
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	57                   	push   %edi
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 24             	sub    $0x24,%esp
  801cd7:	8b 75 08             	mov    0x8(%ebp),%esi
  801cda:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cdd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ce0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ce1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ce7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cea:	50                   	push   %eax
  801ceb:	e8 38 ff ff ff       	call   801c28 <fd_lookup>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 05                	js     801cfe <fd_close+0x30>
	    || fd != fd2)
  801cf9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801cfc:	74 16                	je     801d14 <fd_close+0x46>
		return (must_exist ? r : 0);
  801cfe:	89 f8                	mov    %edi,%eax
  801d00:	84 c0                	test   %al,%al
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	0f 44 d8             	cmove  %eax,%ebx
}
  801d0a:	89 d8                	mov    %ebx,%eax
  801d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	ff 36                	pushl  (%esi)
  801d1d:	e8 56 ff ff ff       	call   801c78 <dev_lookup>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	85 c0                	test   %eax,%eax
  801d29:	78 1a                	js     801d45 <fd_close+0x77>
		if (dev->dev_close)
  801d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801d31:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801d36:	85 c0                	test   %eax,%eax
  801d38:	74 0b                	je     801d45 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801d3a:	83 ec 0c             	sub    $0xc,%esp
  801d3d:	56                   	push   %esi
  801d3e:	ff d0                	call   *%eax
  801d40:	89 c3                	mov    %eax,%ebx
  801d42:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	56                   	push   %esi
  801d49:	6a 00                	push   $0x0
  801d4b:	e8 b7 f1 ff ff       	call   800f07 <sys_page_unmap>
	return r;
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	eb b5                	jmp    801d0a <fd_close+0x3c>

00801d55 <close>:

int
close(int fdnum)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5e:	50                   	push   %eax
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	e8 c1 fe ff ff       	call   801c28 <fd_lookup>
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	79 02                	jns    801d70 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    
		return fd_close(fd, 1);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	6a 01                	push   $0x1
  801d75:	ff 75 f4             	pushl  -0xc(%ebp)
  801d78:	e8 51 ff ff ff       	call   801cce <fd_close>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	eb ec                	jmp    801d6e <close+0x19>

00801d82 <close_all>:

void
close_all(void)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	53                   	push   %ebx
  801d86:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801d89:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801d8e:	83 ec 0c             	sub    $0xc,%esp
  801d91:	53                   	push   %ebx
  801d92:	e8 be ff ff ff       	call   801d55 <close>
	for (i = 0; i < MAXFD; i++)
  801d97:	83 c3 01             	add    $0x1,%ebx
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	83 fb 20             	cmp    $0x20,%ebx
  801da0:	75 ec                	jne    801d8e <close_all+0xc>
}
  801da2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	57                   	push   %edi
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801db0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801db3:	50                   	push   %eax
  801db4:	ff 75 08             	pushl  0x8(%ebp)
  801db7:	e8 6c fe ff ff       	call   801c28 <fd_lookup>
  801dbc:	89 c3                	mov    %eax,%ebx
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	85 c0                	test   %eax,%eax
  801dc3:	0f 88 81 00 00 00    	js     801e4a <dup+0xa3>
		return r;
	close(newfdnum);
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	e8 81 ff ff ff       	call   801d55 <close>

	newfd = INDEX2FD(newfdnum);
  801dd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd7:	c1 e6 0c             	shl    $0xc,%esi
  801dda:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801de0:	83 c4 04             	add    $0x4,%esp
  801de3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801de6:	e8 d4 fd ff ff       	call   801bbf <fd2data>
  801deb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ded:	89 34 24             	mov    %esi,(%esp)
  801df0:	e8 ca fd ff ff       	call   801bbf <fd2data>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801dfa:	89 d8                	mov    %ebx,%eax
  801dfc:	c1 e8 16             	shr    $0x16,%eax
  801dff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e06:	a8 01                	test   $0x1,%al
  801e08:	74 11                	je     801e1b <dup+0x74>
  801e0a:	89 d8                	mov    %ebx,%eax
  801e0c:	c1 e8 0c             	shr    $0xc,%eax
  801e0f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e16:	f6 c2 01             	test   $0x1,%dl
  801e19:	75 39                	jne    801e54 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801e1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e1e:	89 d0                	mov    %edx,%eax
  801e20:	c1 e8 0c             	shr    $0xc,%eax
  801e23:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	25 07 0e 00 00       	and    $0xe07,%eax
  801e32:	50                   	push   %eax
  801e33:	56                   	push   %esi
  801e34:	6a 00                	push   $0x0
  801e36:	52                   	push   %edx
  801e37:	6a 00                	push   $0x0
  801e39:	e8 87 f0 ff ff       	call   800ec5 <sys_page_map>
  801e3e:	89 c3                	mov    %eax,%ebx
  801e40:	83 c4 20             	add    $0x20,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 31                	js     801e78 <dup+0xd1>
		goto err;

	return newfdnum;
  801e47:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801e4a:	89 d8                	mov    %ebx,%eax
  801e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801e54:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	25 07 0e 00 00       	and    $0xe07,%eax
  801e63:	50                   	push   %eax
  801e64:	57                   	push   %edi
  801e65:	6a 00                	push   $0x0
  801e67:	53                   	push   %ebx
  801e68:	6a 00                	push   $0x0
  801e6a:	e8 56 f0 ff ff       	call   800ec5 <sys_page_map>
  801e6f:	89 c3                	mov    %eax,%ebx
  801e71:	83 c4 20             	add    $0x20,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	79 a3                	jns    801e1b <dup+0x74>
	sys_page_unmap(0, newfd);
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	56                   	push   %esi
  801e7c:	6a 00                	push   $0x0
  801e7e:	e8 84 f0 ff ff       	call   800f07 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801e83:	83 c4 08             	add    $0x8,%esp
  801e86:	57                   	push   %edi
  801e87:	6a 00                	push   $0x0
  801e89:	e8 79 f0 ff ff       	call   800f07 <sys_page_unmap>
	return r;
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	eb b7                	jmp    801e4a <dup+0xa3>

00801e93 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	53                   	push   %ebx
  801e97:	83 ec 1c             	sub    $0x1c,%esp
  801e9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea0:	50                   	push   %eax
  801ea1:	53                   	push   %ebx
  801ea2:	e8 81 fd ff ff       	call   801c28 <fd_lookup>
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 3f                	js     801eed <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eae:	83 ec 08             	sub    $0x8,%esp
  801eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb4:	50                   	push   %eax
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	ff 30                	pushl  (%eax)
  801eba:	e8 b9 fd ff ff       	call   801c78 <dev_lookup>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 27                	js     801eed <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ec9:	8b 42 08             	mov    0x8(%edx),%eax
  801ecc:	83 e0 03             	and    $0x3,%eax
  801ecf:	83 f8 01             	cmp    $0x1,%eax
  801ed2:	74 1e                	je     801ef2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 40 08             	mov    0x8(%eax),%eax
  801eda:	85 c0                	test   %eax,%eax
  801edc:	74 35                	je     801f13 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	ff 75 10             	pushl  0x10(%ebp)
  801ee4:	ff 75 0c             	pushl  0xc(%ebp)
  801ee7:	52                   	push   %edx
  801ee8:	ff d0                	call   *%eax
  801eea:	83 c4 10             	add    $0x10,%esp
}
  801eed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801ef2:	a1 04 50 80 00       	mov    0x805004,%eax
  801ef7:	8b 40 48             	mov    0x48(%eax),%eax
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	53                   	push   %ebx
  801efe:	50                   	push   %eax
  801eff:	68 c4 32 80 00       	push   $0x8032c4
  801f04:	e8 28 e4 ff ff       	call   800331 <cprintf>
		return -E_INVAL;
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f11:	eb da                	jmp    801eed <read+0x5a>
		return -E_NOT_SUPP;
  801f13:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f18:	eb d3                	jmp    801eed <read+0x5a>

00801f1a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	57                   	push   %edi
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 0c             	sub    $0xc,%esp
  801f23:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f26:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2e:	39 f3                	cmp    %esi,%ebx
  801f30:	73 23                	jae    801f55 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	29 d8                	sub    %ebx,%eax
  801f39:	50                   	push   %eax
  801f3a:	89 d8                	mov    %ebx,%eax
  801f3c:	03 45 0c             	add    0xc(%ebp),%eax
  801f3f:	50                   	push   %eax
  801f40:	57                   	push   %edi
  801f41:	e8 4d ff ff ff       	call   801e93 <read>
		if (m < 0)
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	78 06                	js     801f53 <readn+0x39>
			return m;
		if (m == 0)
  801f4d:	74 06                	je     801f55 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801f4f:	01 c3                	add    %eax,%ebx
  801f51:	eb db                	jmp    801f2e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f53:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801f55:	89 d8                	mov    %ebx,%eax
  801f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5a:	5b                   	pop    %ebx
  801f5b:	5e                   	pop    %esi
  801f5c:	5f                   	pop    %edi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 1c             	sub    $0x1c,%esp
  801f66:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f69:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f6c:	50                   	push   %eax
  801f6d:	53                   	push   %ebx
  801f6e:	e8 b5 fc ff ff       	call   801c28 <fd_lookup>
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 3a                	js     801fb4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f7a:	83 ec 08             	sub    $0x8,%esp
  801f7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f80:	50                   	push   %eax
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	ff 30                	pushl  (%eax)
  801f86:	e8 ed fc ff ff       	call   801c78 <dev_lookup>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 22                	js     801fb4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f95:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801f99:	74 1e                	je     801fb9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9e:	8b 52 0c             	mov    0xc(%edx),%edx
  801fa1:	85 d2                	test   %edx,%edx
  801fa3:	74 35                	je     801fda <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	ff 75 10             	pushl  0x10(%ebp)
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	50                   	push   %eax
  801faf:	ff d2                	call   *%edx
  801fb1:	83 c4 10             	add    $0x10,%esp
}
  801fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801fb9:	a1 04 50 80 00       	mov    0x805004,%eax
  801fbe:	8b 40 48             	mov    0x48(%eax),%eax
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	53                   	push   %ebx
  801fc5:	50                   	push   %eax
  801fc6:	68 e0 32 80 00       	push   $0x8032e0
  801fcb:	e8 61 e3 ff ff       	call   800331 <cprintf>
		return -E_INVAL;
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fd8:	eb da                	jmp    801fb4 <write+0x55>
		return -E_NOT_SUPP;
  801fda:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fdf:	eb d3                	jmp    801fb4 <write+0x55>

00801fe1 <seek>:

int
seek(int fdnum, off_t offset)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fea:	50                   	push   %eax
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	e8 35 fc ff ff       	call   801c28 <fd_lookup>
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 0e                	js     802008 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	53                   	push   %ebx
  80200e:	83 ec 1c             	sub    $0x1c,%esp
  802011:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802014:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	53                   	push   %ebx
  802019:	e8 0a fc ff ff       	call   801c28 <fd_lookup>
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	85 c0                	test   %eax,%eax
  802023:	78 37                	js     80205c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802025:	83 ec 08             	sub    $0x8,%esp
  802028:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202b:	50                   	push   %eax
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	ff 30                	pushl  (%eax)
  802031:	e8 42 fc ff ff       	call   801c78 <dev_lookup>
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	78 1f                	js     80205c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80203d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802040:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802044:	74 1b                	je     802061 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802049:	8b 52 18             	mov    0x18(%edx),%edx
  80204c:	85 d2                	test   %edx,%edx
  80204e:	74 32                	je     802082 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	50                   	push   %eax
  802057:	ff d2                	call   *%edx
  802059:	83 c4 10             	add    $0x10,%esp
}
  80205c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80205f:	c9                   	leave  
  802060:	c3                   	ret    
			thisenv->env_id, fdnum);
  802061:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802066:	8b 40 48             	mov    0x48(%eax),%eax
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	53                   	push   %ebx
  80206d:	50                   	push   %eax
  80206e:	68 a0 32 80 00       	push   $0x8032a0
  802073:	e8 b9 e2 ff ff       	call   800331 <cprintf>
		return -E_INVAL;
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802080:	eb da                	jmp    80205c <ftruncate+0x52>
		return -E_NOT_SUPP;
  802082:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802087:	eb d3                	jmp    80205c <ftruncate+0x52>

00802089 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	53                   	push   %ebx
  80208d:	83 ec 1c             	sub    $0x1c,%esp
  802090:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802093:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802096:	50                   	push   %eax
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	e8 89 fb ff ff       	call   801c28 <fd_lookup>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	78 4b                	js     8020f1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020a6:	83 ec 08             	sub    $0x8,%esp
  8020a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ac:	50                   	push   %eax
  8020ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b0:	ff 30                	pushl  (%eax)
  8020b2:	e8 c1 fb ff ff       	call   801c78 <dev_lookup>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	78 33                	js     8020f1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8020c5:	74 2f                	je     8020f6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8020c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8020ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8020d1:	00 00 00 
	stat->st_isdir = 0;
  8020d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020db:	00 00 00 
	stat->st_dev = dev;
  8020de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8020e4:	83 ec 08             	sub    $0x8,%esp
  8020e7:	53                   	push   %ebx
  8020e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020eb:	ff 50 14             	call   *0x14(%eax)
  8020ee:	83 c4 10             	add    $0x10,%esp
}
  8020f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8020f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020fb:	eb f4                	jmp    8020f1 <fstat+0x68>

008020fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	56                   	push   %esi
  802101:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	6a 00                	push   $0x0
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	e8 bb 01 00 00       	call   8022ca <open>
  80210f:	89 c3                	mov    %eax,%ebx
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 1b                	js     802133 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802118:	83 ec 08             	sub    $0x8,%esp
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	50                   	push   %eax
  80211f:	e8 65 ff ff ff       	call   802089 <fstat>
  802124:	89 c6                	mov    %eax,%esi
	close(fd);
  802126:	89 1c 24             	mov    %ebx,(%esp)
  802129:	e8 27 fc ff ff       	call   801d55 <close>
	return r;
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	89 f3                	mov    %esi,%ebx
}
  802133:	89 d8                	mov    %ebx,%eax
  802135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802138:	5b                   	pop    %ebx
  802139:	5e                   	pop    %esi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	56                   	push   %esi
  802140:	53                   	push   %ebx
  802141:	89 c6                	mov    %eax,%esi
  802143:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802145:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80214c:	74 27                	je     802175 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80214e:	6a 07                	push   $0x7
  802150:	68 00 60 80 00       	push   $0x806000
  802155:	56                   	push   %esi
  802156:	ff 35 00 50 80 00    	pushl  0x805000
  80215c:	e8 3a 07 00 00       	call   80289b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802161:	83 c4 0c             	add    $0xc,%esp
  802164:	6a 00                	push   $0x0
  802166:	53                   	push   %ebx
  802167:	6a 00                	push   $0x0
  802169:	e8 c4 06 00 00       	call   802832 <ipc_recv>
}
  80216e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	6a 01                	push   $0x1
  80217a:	e8 74 07 00 00       	call   8028f3 <ipc_find_env>
  80217f:	a3 00 50 80 00       	mov    %eax,0x805000
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	eb c5                	jmp    80214e <fsipc+0x12>

00802189 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	8b 40 0c             	mov    0xc(%eax),%eax
  802195:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80219a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8021a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8021ac:	e8 8b ff ff ff       	call   80213c <fsipc>
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <devfile_flush>:
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8021c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8021ce:	e8 69 ff ff ff       	call   80213c <fsipc>
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <devfile_stat>:
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8021ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8021f4:	e8 43 ff ff ff       	call   80213c <fsipc>
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	78 2c                	js     802229 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8021fd:	83 ec 08             	sub    $0x8,%esp
  802200:	68 00 60 80 00       	push   $0x806000
  802205:	53                   	push   %ebx
  802206:	e8 85 e8 ff ff       	call   800a90 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80220b:	a1 80 60 80 00       	mov    0x806080,%eax
  802210:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802216:	a1 84 60 80 00       	mov    0x806084,%eax
  80221b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802229:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <devfile_write>:
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  802234:	68 10 33 80 00       	push   $0x803310
  802239:	68 90 00 00 00       	push   $0x90
  80223e:	68 2e 33 80 00       	push   $0x80332e
  802243:	e8 f3 df ff ff       	call   80023b <_panic>

00802248 <devfile_read>:
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	56                   	push   %esi
  80224c:	53                   	push   %ebx
  80224d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 40 0c             	mov    0xc(%eax),%eax
  802256:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80225b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802261:	ba 00 00 00 00       	mov    $0x0,%edx
  802266:	b8 03 00 00 00       	mov    $0x3,%eax
  80226b:	e8 cc fe ff ff       	call   80213c <fsipc>
  802270:	89 c3                	mov    %eax,%ebx
  802272:	85 c0                	test   %eax,%eax
  802274:	78 1f                	js     802295 <devfile_read+0x4d>
	assert(r <= n);
  802276:	39 f0                	cmp    %esi,%eax
  802278:	77 24                	ja     80229e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80227a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80227f:	7f 33                	jg     8022b4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	50                   	push   %eax
  802285:	68 00 60 80 00       	push   $0x806000
  80228a:	ff 75 0c             	pushl  0xc(%ebp)
  80228d:	e8 8c e9 ff ff       	call   800c1e <memmove>
	return r;
  802292:	83 c4 10             	add    $0x10,%esp
}
  802295:	89 d8                	mov    %ebx,%eax
  802297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229a:	5b                   	pop    %ebx
  80229b:	5e                   	pop    %esi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    
	assert(r <= n);
  80229e:	68 39 33 80 00       	push   $0x803339
  8022a3:	68 5c 31 80 00       	push   $0x80315c
  8022a8:	6a 7c                	push   $0x7c
  8022aa:	68 2e 33 80 00       	push   $0x80332e
  8022af:	e8 87 df ff ff       	call   80023b <_panic>
	assert(r <= PGSIZE);
  8022b4:	68 40 33 80 00       	push   $0x803340
  8022b9:	68 5c 31 80 00       	push   $0x80315c
  8022be:	6a 7d                	push   $0x7d
  8022c0:	68 2e 33 80 00       	push   $0x80332e
  8022c5:	e8 71 df ff ff       	call   80023b <_panic>

008022ca <open>:
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	56                   	push   %esi
  8022ce:	53                   	push   %ebx
  8022cf:	83 ec 1c             	sub    $0x1c,%esp
  8022d2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8022d5:	56                   	push   %esi
  8022d6:	e8 7c e7 ff ff       	call   800a57 <strlen>
  8022db:	83 c4 10             	add    $0x10,%esp
  8022de:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8022e3:	7f 6c                	jg     802351 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022eb:	50                   	push   %eax
  8022ec:	e8 e5 f8 ff ff       	call   801bd6 <fd_alloc>
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 3c                	js     802336 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8022fa:	83 ec 08             	sub    $0x8,%esp
  8022fd:	56                   	push   %esi
  8022fe:	68 00 60 80 00       	push   $0x806000
  802303:	e8 88 e7 ff ff       	call   800a90 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	b8 01 00 00 00       	mov    $0x1,%eax
  802318:	e8 1f fe ff ff       	call   80213c <fsipc>
  80231d:	89 c3                	mov    %eax,%ebx
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	85 c0                	test   %eax,%eax
  802324:	78 19                	js     80233f <open+0x75>
	return fd2num(fd);
  802326:	83 ec 0c             	sub    $0xc,%esp
  802329:	ff 75 f4             	pushl  -0xc(%ebp)
  80232c:	e8 7e f8 ff ff       	call   801baf <fd2num>
  802331:	89 c3                	mov    %eax,%ebx
  802333:	83 c4 10             	add    $0x10,%esp
}
  802336:	89 d8                	mov    %ebx,%eax
  802338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    
		fd_close(fd, 0);
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	6a 00                	push   $0x0
  802344:	ff 75 f4             	pushl  -0xc(%ebp)
  802347:	e8 82 f9 ff ff       	call   801cce <fd_close>
		return r;
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	eb e5                	jmp    802336 <open+0x6c>
		return -E_BAD_PATH;
  802351:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802356:	eb de                	jmp    802336 <open+0x6c>

00802358 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80235e:	ba 00 00 00 00       	mov    $0x0,%edx
  802363:	b8 08 00 00 00       	mov    $0x8,%eax
  802368:	e8 cf fd ff ff       	call   80213c <fsipc>
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802377:	83 ec 0c             	sub    $0xc,%esp
  80237a:	ff 75 08             	pushl  0x8(%ebp)
  80237d:	e8 3d f8 ff ff       	call   801bbf <fd2data>
  802382:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802384:	83 c4 08             	add    $0x8,%esp
  802387:	68 4c 33 80 00       	push   $0x80334c
  80238c:	53                   	push   %ebx
  80238d:	e8 fe e6 ff ff       	call   800a90 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802392:	8b 46 04             	mov    0x4(%esi),%eax
  802395:	2b 06                	sub    (%esi),%eax
  802397:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80239d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023a4:	00 00 00 
	stat->st_dev = &devpipe;
  8023a7:	c7 83 88 00 00 00 28 	movl   $0x804028,0x88(%ebx)
  8023ae:	40 80 00 
	return 0;
}
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023b9:	5b                   	pop    %ebx
  8023ba:	5e                   	pop    %esi
  8023bb:	5d                   	pop    %ebp
  8023bc:	c3                   	ret    

008023bd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
  8023c0:	53                   	push   %ebx
  8023c1:	83 ec 0c             	sub    $0xc,%esp
  8023c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023c7:	53                   	push   %ebx
  8023c8:	6a 00                	push   $0x0
  8023ca:	e8 38 eb ff ff       	call   800f07 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023cf:	89 1c 24             	mov    %ebx,(%esp)
  8023d2:	e8 e8 f7 ff ff       	call   801bbf <fd2data>
  8023d7:	83 c4 08             	add    $0x8,%esp
  8023da:	50                   	push   %eax
  8023db:	6a 00                	push   $0x0
  8023dd:	e8 25 eb ff ff       	call   800f07 <sys_page_unmap>
}
  8023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <_pipeisclosed>:
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	57                   	push   %edi
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 1c             	sub    $0x1c,%esp
  8023f0:	89 c7                	mov    %eax,%edi
  8023f2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023f4:	a1 04 50 80 00       	mov    0x805004,%eax
  8023f9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023fc:	83 ec 0c             	sub    $0xc,%esp
  8023ff:	57                   	push   %edi
  802400:	e8 29 05 00 00       	call   80292e <pageref>
  802405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802408:	89 34 24             	mov    %esi,(%esp)
  80240b:	e8 1e 05 00 00       	call   80292e <pageref>
		nn = thisenv->env_runs;
  802410:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802416:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802419:	83 c4 10             	add    $0x10,%esp
  80241c:	39 cb                	cmp    %ecx,%ebx
  80241e:	74 1b                	je     80243b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802420:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802423:	75 cf                	jne    8023f4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802425:	8b 42 58             	mov    0x58(%edx),%eax
  802428:	6a 01                	push   $0x1
  80242a:	50                   	push   %eax
  80242b:	53                   	push   %ebx
  80242c:	68 53 33 80 00       	push   $0x803353
  802431:	e8 fb de ff ff       	call   800331 <cprintf>
  802436:	83 c4 10             	add    $0x10,%esp
  802439:	eb b9                	jmp    8023f4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80243b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80243e:	0f 94 c0             	sete   %al
  802441:	0f b6 c0             	movzbl %al,%eax
}
  802444:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5f                   	pop    %edi
  80244a:	5d                   	pop    %ebp
  80244b:	c3                   	ret    

0080244c <devpipe_write>:
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	57                   	push   %edi
  802450:	56                   	push   %esi
  802451:	53                   	push   %ebx
  802452:	83 ec 28             	sub    $0x28,%esp
  802455:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802458:	56                   	push   %esi
  802459:	e8 61 f7 ff ff       	call   801bbf <fd2data>
  80245e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	bf 00 00 00 00       	mov    $0x0,%edi
  802468:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80246b:	74 4f                	je     8024bc <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80246d:	8b 43 04             	mov    0x4(%ebx),%eax
  802470:	8b 0b                	mov    (%ebx),%ecx
  802472:	8d 51 20             	lea    0x20(%ecx),%edx
  802475:	39 d0                	cmp    %edx,%eax
  802477:	72 14                	jb     80248d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802479:	89 da                	mov    %ebx,%edx
  80247b:	89 f0                	mov    %esi,%eax
  80247d:	e8 65 ff ff ff       	call   8023e7 <_pipeisclosed>
  802482:	85 c0                	test   %eax,%eax
  802484:	75 3b                	jne    8024c1 <devpipe_write+0x75>
			sys_yield();
  802486:	e8 d8 e9 ff ff       	call   800e63 <sys_yield>
  80248b:	eb e0                	jmp    80246d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80248d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802490:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802494:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802497:	89 c2                	mov    %eax,%edx
  802499:	c1 fa 1f             	sar    $0x1f,%edx
  80249c:	89 d1                	mov    %edx,%ecx
  80249e:	c1 e9 1b             	shr    $0x1b,%ecx
  8024a1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024a4:	83 e2 1f             	and    $0x1f,%edx
  8024a7:	29 ca                	sub    %ecx,%edx
  8024a9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024ad:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024b1:	83 c0 01             	add    $0x1,%eax
  8024b4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024b7:	83 c7 01             	add    $0x1,%edi
  8024ba:	eb ac                	jmp    802468 <devpipe_write+0x1c>
	return i;
  8024bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bf:	eb 05                	jmp    8024c6 <devpipe_write+0x7a>
				return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024c9:	5b                   	pop    %ebx
  8024ca:	5e                   	pop    %esi
  8024cb:	5f                   	pop    %edi
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <devpipe_read>:
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 18             	sub    $0x18,%esp
  8024d7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024da:	57                   	push   %edi
  8024db:	e8 df f6 ff ff       	call   801bbf <fd2data>
  8024e0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024e2:	83 c4 10             	add    $0x10,%esp
  8024e5:	be 00 00 00 00       	mov    $0x0,%esi
  8024ea:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024ed:	75 14                	jne    802503 <devpipe_read+0x35>
	return i;
  8024ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f2:	eb 02                	jmp    8024f6 <devpipe_read+0x28>
				return i;
  8024f4:	89 f0                	mov    %esi,%eax
}
  8024f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f9:	5b                   	pop    %ebx
  8024fa:	5e                   	pop    %esi
  8024fb:	5f                   	pop    %edi
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    
			sys_yield();
  8024fe:	e8 60 e9 ff ff       	call   800e63 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802503:	8b 03                	mov    (%ebx),%eax
  802505:	3b 43 04             	cmp    0x4(%ebx),%eax
  802508:	75 18                	jne    802522 <devpipe_read+0x54>
			if (i > 0)
  80250a:	85 f6                	test   %esi,%esi
  80250c:	75 e6                	jne    8024f4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80250e:	89 da                	mov    %ebx,%edx
  802510:	89 f8                	mov    %edi,%eax
  802512:	e8 d0 fe ff ff       	call   8023e7 <_pipeisclosed>
  802517:	85 c0                	test   %eax,%eax
  802519:	74 e3                	je     8024fe <devpipe_read+0x30>
				return 0;
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
  802520:	eb d4                	jmp    8024f6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802522:	99                   	cltd   
  802523:	c1 ea 1b             	shr    $0x1b,%edx
  802526:	01 d0                	add    %edx,%eax
  802528:	83 e0 1f             	and    $0x1f,%eax
  80252b:	29 d0                	sub    %edx,%eax
  80252d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802535:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802538:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80253b:	83 c6 01             	add    $0x1,%esi
  80253e:	eb aa                	jmp    8024ea <devpipe_read+0x1c>

00802540 <pipe>:
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	56                   	push   %esi
  802544:	53                   	push   %ebx
  802545:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802548:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80254b:	50                   	push   %eax
  80254c:	e8 85 f6 ff ff       	call   801bd6 <fd_alloc>
  802551:	89 c3                	mov    %eax,%ebx
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	85 c0                	test   %eax,%eax
  802558:	0f 88 23 01 00 00    	js     802681 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 07 04 00 00       	push   $0x407
  802566:	ff 75 f4             	pushl  -0xc(%ebp)
  802569:	6a 00                	push   $0x0
  80256b:	e8 12 e9 ff ff       	call   800e82 <sys_page_alloc>
  802570:	89 c3                	mov    %eax,%ebx
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	85 c0                	test   %eax,%eax
  802577:	0f 88 04 01 00 00    	js     802681 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802583:	50                   	push   %eax
  802584:	e8 4d f6 ff ff       	call   801bd6 <fd_alloc>
  802589:	89 c3                	mov    %eax,%ebx
  80258b:	83 c4 10             	add    $0x10,%esp
  80258e:	85 c0                	test   %eax,%eax
  802590:	0f 88 db 00 00 00    	js     802671 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802596:	83 ec 04             	sub    $0x4,%esp
  802599:	68 07 04 00 00       	push   $0x407
  80259e:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a1:	6a 00                	push   $0x0
  8025a3:	e8 da e8 ff ff       	call   800e82 <sys_page_alloc>
  8025a8:	89 c3                	mov    %eax,%ebx
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	0f 88 bc 00 00 00    	js     802671 <pipe+0x131>
	va = fd2data(fd0);
  8025b5:	83 ec 0c             	sub    $0xc,%esp
  8025b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025bb:	e8 ff f5 ff ff       	call   801bbf <fd2data>
  8025c0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c2:	83 c4 0c             	add    $0xc,%esp
  8025c5:	68 07 04 00 00       	push   $0x407
  8025ca:	50                   	push   %eax
  8025cb:	6a 00                	push   $0x0
  8025cd:	e8 b0 e8 ff ff       	call   800e82 <sys_page_alloc>
  8025d2:	89 c3                	mov    %eax,%ebx
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	0f 88 82 00 00 00    	js     802661 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025df:	83 ec 0c             	sub    $0xc,%esp
  8025e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e5:	e8 d5 f5 ff ff       	call   801bbf <fd2data>
  8025ea:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025f1:	50                   	push   %eax
  8025f2:	6a 00                	push   $0x0
  8025f4:	56                   	push   %esi
  8025f5:	6a 00                	push   $0x0
  8025f7:	e8 c9 e8 ff ff       	call   800ec5 <sys_page_map>
  8025fc:	89 c3                	mov    %eax,%ebx
  8025fe:	83 c4 20             	add    $0x20,%esp
  802601:	85 c0                	test   %eax,%eax
  802603:	78 4e                	js     802653 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802605:	a1 28 40 80 00       	mov    0x804028,%eax
  80260a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80260f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802612:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802619:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802628:	83 ec 0c             	sub    $0xc,%esp
  80262b:	ff 75 f4             	pushl  -0xc(%ebp)
  80262e:	e8 7c f5 ff ff       	call   801baf <fd2num>
  802633:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802636:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802638:	83 c4 04             	add    $0x4,%esp
  80263b:	ff 75 f0             	pushl  -0x10(%ebp)
  80263e:	e8 6c f5 ff ff       	call   801baf <fd2num>
  802643:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802646:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802649:	83 c4 10             	add    $0x10,%esp
  80264c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802651:	eb 2e                	jmp    802681 <pipe+0x141>
	sys_page_unmap(0, va);
  802653:	83 ec 08             	sub    $0x8,%esp
  802656:	56                   	push   %esi
  802657:	6a 00                	push   $0x0
  802659:	e8 a9 e8 ff ff       	call   800f07 <sys_page_unmap>
  80265e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802661:	83 ec 08             	sub    $0x8,%esp
  802664:	ff 75 f0             	pushl  -0x10(%ebp)
  802667:	6a 00                	push   $0x0
  802669:	e8 99 e8 ff ff       	call   800f07 <sys_page_unmap>
  80266e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802671:	83 ec 08             	sub    $0x8,%esp
  802674:	ff 75 f4             	pushl  -0xc(%ebp)
  802677:	6a 00                	push   $0x0
  802679:	e8 89 e8 ff ff       	call   800f07 <sys_page_unmap>
  80267e:	83 c4 10             	add    $0x10,%esp
}
  802681:	89 d8                	mov    %ebx,%eax
  802683:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802686:	5b                   	pop    %ebx
  802687:	5e                   	pop    %esi
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <pipeisclosed>:
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802690:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802693:	50                   	push   %eax
  802694:	ff 75 08             	pushl  0x8(%ebp)
  802697:	e8 8c f5 ff ff       	call   801c28 <fd_lookup>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	78 18                	js     8026bb <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a9:	e8 11 f5 ff ff       	call   801bbf <fd2data>
	return _pipeisclosed(fd, p);
  8026ae:	89 c2                	mov    %eax,%edx
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	e8 2f fd ff ff       	call   8023e7 <_pipeisclosed>
  8026b8:	83 c4 10             	add    $0x10,%esp
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c2:	c3                   	ret    

008026c3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026c9:	68 6b 33 80 00       	push   $0x80336b
  8026ce:	ff 75 0c             	pushl  0xc(%ebp)
  8026d1:	e8 ba e3 ff ff       	call   800a90 <strcpy>
	return 0;
}
  8026d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <devcons_write>:
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	57                   	push   %edi
  8026e1:	56                   	push   %esi
  8026e2:	53                   	push   %ebx
  8026e3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026e9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026ee:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026f4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026f7:	73 31                	jae    80272a <devcons_write+0x4d>
		m = n - tot;
  8026f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026fc:	29 f3                	sub    %esi,%ebx
  8026fe:	83 fb 7f             	cmp    $0x7f,%ebx
  802701:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802706:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802709:	83 ec 04             	sub    $0x4,%esp
  80270c:	53                   	push   %ebx
  80270d:	89 f0                	mov    %esi,%eax
  80270f:	03 45 0c             	add    0xc(%ebp),%eax
  802712:	50                   	push   %eax
  802713:	57                   	push   %edi
  802714:	e8 05 e5 ff ff       	call   800c1e <memmove>
		sys_cputs(buf, m);
  802719:	83 c4 08             	add    $0x8,%esp
  80271c:	53                   	push   %ebx
  80271d:	57                   	push   %edi
  80271e:	e8 a3 e6 ff ff       	call   800dc6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802723:	01 de                	add    %ebx,%esi
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	eb ca                	jmp    8026f4 <devcons_write+0x17>
}
  80272a:	89 f0                	mov    %esi,%eax
  80272c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80272f:	5b                   	pop    %ebx
  802730:	5e                   	pop    %esi
  802731:	5f                   	pop    %edi
  802732:	5d                   	pop    %ebp
  802733:	c3                   	ret    

00802734 <devcons_read>:
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	83 ec 08             	sub    $0x8,%esp
  80273a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80273f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802743:	74 21                	je     802766 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802745:	e8 9a e6 ff ff       	call   800de4 <sys_cgetc>
  80274a:	85 c0                	test   %eax,%eax
  80274c:	75 07                	jne    802755 <devcons_read+0x21>
		sys_yield();
  80274e:	e8 10 e7 ff ff       	call   800e63 <sys_yield>
  802753:	eb f0                	jmp    802745 <devcons_read+0x11>
	if (c < 0)
  802755:	78 0f                	js     802766 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802757:	83 f8 04             	cmp    $0x4,%eax
  80275a:	74 0c                	je     802768 <devcons_read+0x34>
	*(char*)vbuf = c;
  80275c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275f:	88 02                	mov    %al,(%edx)
	return 1;
  802761:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    
		return 0;
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
  80276d:	eb f7                	jmp    802766 <devcons_read+0x32>

0080276f <cputchar>:
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802775:	8b 45 08             	mov    0x8(%ebp),%eax
  802778:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80277b:	6a 01                	push   $0x1
  80277d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802780:	50                   	push   %eax
  802781:	e8 40 e6 ff ff       	call   800dc6 <sys_cputs>
}
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <getchar>:
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802791:	6a 01                	push   $0x1
  802793:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802796:	50                   	push   %eax
  802797:	6a 00                	push   $0x0
  802799:	e8 f5 f6 ff ff       	call   801e93 <read>
	if (r < 0)
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	78 06                	js     8027ab <getchar+0x20>
	if (r < 1)
  8027a5:	74 06                	je     8027ad <getchar+0x22>
	return c;
  8027a7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027ab:	c9                   	leave  
  8027ac:	c3                   	ret    
		return -E_EOF;
  8027ad:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027b2:	eb f7                	jmp    8027ab <getchar+0x20>

008027b4 <iscons>:
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027bd:	50                   	push   %eax
  8027be:	ff 75 08             	pushl  0x8(%ebp)
  8027c1:	e8 62 f4 ff ff       	call   801c28 <fd_lookup>
  8027c6:	83 c4 10             	add    $0x10,%esp
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	78 11                	js     8027de <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8027d6:	39 10                	cmp    %edx,(%eax)
  8027d8:	0f 94 c0             	sete   %al
  8027db:	0f b6 c0             	movzbl %al,%eax
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <opencons>:
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e9:	50                   	push   %eax
  8027ea:	e8 e7 f3 ff ff       	call   801bd6 <fd_alloc>
  8027ef:	83 c4 10             	add    $0x10,%esp
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	78 3a                	js     802830 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	68 07 04 00 00       	push   $0x407
  8027fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802801:	6a 00                	push   $0x0
  802803:	e8 7a e6 ff ff       	call   800e82 <sys_page_alloc>
  802808:	83 c4 10             	add    $0x10,%esp
  80280b:	85 c0                	test   %eax,%eax
  80280d:	78 21                	js     802830 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802818:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	50                   	push   %eax
  802828:	e8 82 f3 ff ff       	call   801baf <fd2num>
  80282d:	83 c4 10             	add    $0x10,%esp
}
  802830:	c9                   	leave  
  802831:	c3                   	ret    

00802832 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802832:	55                   	push   %ebp
  802833:	89 e5                	mov    %esp,%ebp
  802835:	56                   	push   %esi
  802836:	53                   	push   %ebx
  802837:	8b 75 08             	mov    0x8(%ebp),%esi
  80283a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80283d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802840:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802842:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802847:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80284a:	83 ec 0c             	sub    $0xc,%esp
  80284d:	50                   	push   %eax
  80284e:	e8 df e7 ff ff       	call   801032 <sys_ipc_recv>
	if(ret < 0){
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	78 2b                	js     802885 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80285a:	85 f6                	test   %esi,%esi
  80285c:	74 0a                	je     802868 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80285e:	a1 04 50 80 00       	mov    0x805004,%eax
  802863:	8b 40 74             	mov    0x74(%eax),%eax
  802866:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802868:	85 db                	test   %ebx,%ebx
  80286a:	74 0a                	je     802876 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80286c:	a1 04 50 80 00       	mov    0x805004,%eax
  802871:	8b 40 78             	mov    0x78(%eax),%eax
  802874:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802876:	a1 04 50 80 00       	mov    0x805004,%eax
  80287b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80287e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802881:	5b                   	pop    %ebx
  802882:	5e                   	pop    %esi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
		if(from_env_store)
  802885:	85 f6                	test   %esi,%esi
  802887:	74 06                	je     80288f <ipc_recv+0x5d>
			*from_env_store = 0;
  802889:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80288f:	85 db                	test   %ebx,%ebx
  802891:	74 eb                	je     80287e <ipc_recv+0x4c>
			*perm_store = 0;
  802893:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802899:	eb e3                	jmp    80287e <ipc_recv+0x4c>

0080289b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80289b:	55                   	push   %ebp
  80289c:	89 e5                	mov    %esp,%ebp
  80289e:	57                   	push   %edi
  80289f:	56                   	push   %esi
  8028a0:	53                   	push   %ebx
  8028a1:	83 ec 0c             	sub    $0xc,%esp
  8028a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028ad:	85 db                	test   %ebx,%ebx
  8028af:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028b4:	0f 44 d8             	cmove  %eax,%ebx
  8028b7:	eb 05                	jmp    8028be <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8028b9:	e8 a5 e5 ff ff       	call   800e63 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028be:	ff 75 14             	pushl  0x14(%ebp)
  8028c1:	53                   	push   %ebx
  8028c2:	56                   	push   %esi
  8028c3:	57                   	push   %edi
  8028c4:	e8 46 e7 ff ff       	call   80100f <sys_ipc_try_send>
  8028c9:	83 c4 10             	add    $0x10,%esp
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 1b                	je     8028eb <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028d0:	79 e7                	jns    8028b9 <ipc_send+0x1e>
  8028d2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028d5:	74 e2                	je     8028b9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	68 77 33 80 00       	push   $0x803377
  8028df:	6a 49                	push   $0x49
  8028e1:	68 8c 33 80 00       	push   $0x80338c
  8028e6:	e8 50 d9 ff ff       	call   80023b <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ee:	5b                   	pop    %ebx
  8028ef:	5e                   	pop    %esi
  8028f0:	5f                   	pop    %edi
  8028f1:	5d                   	pop    %ebp
  8028f2:	c3                   	ret    

008028f3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028fe:	89 c2                	mov    %eax,%edx
  802900:	c1 e2 07             	shl    $0x7,%edx
  802903:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802909:	8b 52 50             	mov    0x50(%edx),%edx
  80290c:	39 ca                	cmp    %ecx,%edx
  80290e:	74 11                	je     802921 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802910:	83 c0 01             	add    $0x1,%eax
  802913:	3d 00 04 00 00       	cmp    $0x400,%eax
  802918:	75 e4                	jne    8028fe <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80291a:	b8 00 00 00 00       	mov    $0x0,%eax
  80291f:	eb 0b                	jmp    80292c <ipc_find_env+0x39>
			return envs[i].env_id;
  802921:	c1 e0 07             	shl    $0x7,%eax
  802924:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802929:	8b 40 48             	mov    0x48(%eax),%eax
}
  80292c:	5d                   	pop    %ebp
  80292d:	c3                   	ret    

0080292e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
  802931:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802934:	89 d0                	mov    %edx,%eax
  802936:	c1 e8 16             	shr    $0x16,%eax
  802939:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802945:	f6 c1 01             	test   $0x1,%cl
  802948:	74 1d                	je     802967 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80294a:	c1 ea 0c             	shr    $0xc,%edx
  80294d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802954:	f6 c2 01             	test   $0x1,%dl
  802957:	74 0e                	je     802967 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802959:	c1 ea 0c             	shr    $0xc,%edx
  80295c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802963:	ef 
  802964:	0f b7 c0             	movzwl %ax,%eax
}
  802967:	5d                   	pop    %ebp
  802968:	c3                   	ret    
  802969:	66 90                	xchg   %ax,%ax
  80296b:	66 90                	xchg   %ax,%ax
  80296d:	66 90                	xchg   %ax,%ax
  80296f:	90                   	nop

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
