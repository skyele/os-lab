
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
  800044:	e8 5c 0a 00 00       	call   800aa5 <strcpy>
	exit();
  800049:	e8 e8 01 00 00       	call   800236 <exit>
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
  800073:	e8 1f 0e 00 00       	call   800e97 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bb 00 00 00    	js     80013e <umain+0xeb>
	if ((r = fork()) < 0)
  800083:	e8 4d 13 00 00       	call   8013d5 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 c3 2b 00 00       	call   802c64 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 9c 0a 00 00       	call   800b50 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 60 32 80 00       	mov    $0x803260,%eax
  8000be:	ba 66 32 80 00       	mov    $0x803266,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 9c 32 80 00       	push   $0x80329c
  8000cc:	e8 75 02 00 00       	call   800346 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 b7 32 80 00       	push   $0x8032b7
  8000d8:	68 bc 32 80 00       	push   $0x8032bc
  8000dd:	68 bb 32 80 00       	push   $0x8032bb
  8000e2:	e8 39 23 00 00       	call   802420 <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 69 2b 00 00       	call   802c64 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 42 0a 00 00       	call   800b50 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 60 32 80 00       	mov    $0x803260,%eax
  800118:	ba 66 32 80 00       	mov    $0x803266,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 d3 32 80 00       	push   $0x8032d3
  800126:	e8 1b 02 00 00       	call   800346 <cprintf>
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
  80013f:	68 6c 32 80 00       	push   $0x80326c
  800144:	6a 13                	push   $0x13
  800146:	68 7f 32 80 00       	push   $0x80327f
  80014b:	e8 00 01 00 00       	call   800250 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 93 32 80 00       	push   $0x803293
  800156:	6a 17                	push   $0x17
  800158:	68 7f 32 80 00       	push   $0x80327f
  80015d:	e8 ee 00 00 00       	call   800250 <_panic>
		strcpy(VA, msg);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 35 04 40 80 00    	pushl  0x804004
  80016b:	68 00 00 00 a0       	push   $0xa0000000
  800170:	e8 30 09 00 00       	call   800aa5 <strcpy>
		exit();
  800175:	e8 bc 00 00 00       	call   800236 <exit>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	e9 16 ff ff ff       	jmp    800098 <umain+0x45>
		panic("spawn: %e", r);
  800182:	50                   	push   %eax
  800183:	68 c9 32 80 00       	push   $0x8032c9
  800188:	6a 21                	push   $0x21
  80018a:	68 7f 32 80 00       	push   $0x80327f
  80018f:	e8 bc 00 00 00       	call   800250 <_panic>

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
  80019d:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001a4:	00 00 00 
	envid_t find = sys_getenvid();
  8001a7:	e8 ad 0c 00 00       	call   800e59 <sys_getenvid>
  8001ac:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
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
  8001f5:	89 1d 08 50 80 00    	mov    %ebx,0x805008
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

	cprintf("call umain!\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 0d 33 80 00       	push   $0x80330d
  800213:	e8 2e 01 00 00       	call   800346 <cprintf>
	// call user main routine
	umain(argc, argv);
  800218:	83 c4 08             	add    $0x8,%esp
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	e8 2d fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  800226:	e8 0b 00 00 00       	call   800236 <exit>
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023c:	e8 fe 15 00 00       	call   80183f <close_all>
	sys_env_destroy(0);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 00                	push   $0x0
  800246:	e8 cd 0b 00 00       	call   800e18 <sys_env_destroy>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800255:	a1 08 50 80 00       	mov    0x805008,%eax
  80025a:	8b 40 48             	mov    0x48(%eax),%eax
  80025d:	83 ec 04             	sub    $0x4,%esp
  800260:	68 54 33 80 00       	push   $0x803354
  800265:	50                   	push   %eax
  800266:	68 24 33 80 00       	push   $0x803324
  80026b:	e8 d6 00 00 00       	call   800346 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800270:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800273:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800279:	e8 db 0b 00 00       	call   800e59 <sys_getenvid>
  80027e:	83 c4 04             	add    $0x4,%esp
  800281:	ff 75 0c             	pushl  0xc(%ebp)
  800284:	ff 75 08             	pushl  0x8(%ebp)
  800287:	56                   	push   %esi
  800288:	50                   	push   %eax
  800289:	68 30 33 80 00       	push   $0x803330
  80028e:	e8 b3 00 00 00       	call   800346 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	53                   	push   %ebx
  800297:	ff 75 10             	pushl  0x10(%ebp)
  80029a:	e8 56 00 00 00       	call   8002f5 <vcprintf>
	cprintf("\n");
  80029f:	c7 04 24 18 33 80 00 	movl   $0x803318,(%esp)
  8002a6:	e8 9b 00 00 00       	call   800346 <cprintf>
  8002ab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ae:	cc                   	int3   
  8002af:	eb fd                	jmp    8002ae <_panic+0x5e>

008002b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bb:	8b 13                	mov    (%ebx),%edx
  8002bd:	8d 42 01             	lea    0x1(%edx),%eax
  8002c0:	89 03                	mov    %eax,(%ebx)
  8002c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ce:	74 09                	je     8002d9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	68 ff 00 00 00       	push   $0xff
  8002e1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e4:	50                   	push   %eax
  8002e5:	e8 f1 0a 00 00       	call   800ddb <sys_cputs>
		b->idx = 0;
  8002ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	eb db                	jmp    8002d0 <putch+0x1f>

008002f5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002fe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800305:	00 00 00 
	b.cnt = 0;
  800308:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800312:	ff 75 0c             	pushl  0xc(%ebp)
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031e:	50                   	push   %eax
  80031f:	68 b1 02 80 00       	push   $0x8002b1
  800324:	e8 4a 01 00 00       	call   800473 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800329:	83 c4 08             	add    $0x8,%esp
  80032c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800332:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800338:	50                   	push   %eax
  800339:	e8 9d 0a 00 00       	call   800ddb <sys_cputs>

	return b.cnt;
}
  80033e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034f:	50                   	push   %eax
  800350:	ff 75 08             	pushl  0x8(%ebp)
  800353:	e8 9d ff ff ff       	call   8002f5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 1c             	sub    $0x1c,%esp
  800363:	89 c6                	mov    %eax,%esi
  800365:	89 d7                	mov    %edx,%edi
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800370:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800379:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80037d:	74 2c                	je     8003ab <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80037f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800382:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800389:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800394:	73 43                	jae    8003d9 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800396:	83 eb 01             	sub    $0x1,%ebx
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7e 6c                	jle    800409 <printnum+0xaf>
				putch(padc, putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	57                   	push   %edi
  8003a1:	ff 75 18             	pushl  0x18(%ebp)
  8003a4:	ff d6                	call   *%esi
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	eb eb                	jmp    800396 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003ab:	83 ec 0c             	sub    $0xc,%esp
  8003ae:	6a 20                	push   $0x20
  8003b0:	6a 00                	push   $0x0
  8003b2:	50                   	push   %eax
  8003b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b9:	89 fa                	mov    %edi,%edx
  8003bb:	89 f0                	mov    %esi,%eax
  8003bd:	e8 98 ff ff ff       	call   80035a <printnum>
		while (--width > 0)
  8003c2:	83 c4 20             	add    $0x20,%esp
  8003c5:	83 eb 01             	sub    $0x1,%ebx
  8003c8:	85 db                	test   %ebx,%ebx
  8003ca:	7e 65                	jle    800431 <printnum+0xd7>
			putch(padc, putdat);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	57                   	push   %edi
  8003d0:	6a 20                	push   $0x20
  8003d2:	ff d6                	call   *%esi
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	eb ec                	jmp    8003c5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	ff 75 18             	pushl  0x18(%ebp)
  8003df:	83 eb 01             	sub    $0x1,%ebx
  8003e2:	53                   	push   %ebx
  8003e3:	50                   	push   %eax
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f3:	e8 08 2c 00 00       	call   803000 <__udivdi3>
  8003f8:	83 c4 18             	add    $0x18,%esp
  8003fb:	52                   	push   %edx
  8003fc:	50                   	push   %eax
  8003fd:	89 fa                	mov    %edi,%edx
  8003ff:	89 f0                	mov    %esi,%eax
  800401:	e8 54 ff ff ff       	call   80035a <printnum>
  800406:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	57                   	push   %edi
  80040d:	83 ec 04             	sub    $0x4,%esp
  800410:	ff 75 dc             	pushl  -0x24(%ebp)
  800413:	ff 75 d8             	pushl  -0x28(%ebp)
  800416:	ff 75 e4             	pushl  -0x1c(%ebp)
  800419:	ff 75 e0             	pushl  -0x20(%ebp)
  80041c:	e8 ef 2c 00 00       	call   803110 <__umoddi3>
  800421:	83 c4 14             	add    $0x14,%esp
  800424:	0f be 80 5b 33 80 00 	movsbl 0x80335b(%eax),%eax
  80042b:	50                   	push   %eax
  80042c:	ff d6                	call   *%esi
  80042e:	83 c4 10             	add    $0x10,%esp
	}
}
  800431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800434:	5b                   	pop    %ebx
  800435:	5e                   	pop    %esi
  800436:	5f                   	pop    %edi
  800437:	5d                   	pop    %ebp
  800438:	c3                   	ret    

00800439 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80043f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800443:	8b 10                	mov    (%eax),%edx
  800445:	3b 50 04             	cmp    0x4(%eax),%edx
  800448:	73 0a                	jae    800454 <sprintputch+0x1b>
		*b->buf++ = ch;
  80044a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80044d:	89 08                	mov    %ecx,(%eax)
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	88 02                	mov    %al,(%edx)
}
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <printfmt>:
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80045c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80045f:	50                   	push   %eax
  800460:	ff 75 10             	pushl  0x10(%ebp)
  800463:	ff 75 0c             	pushl  0xc(%ebp)
  800466:	ff 75 08             	pushl  0x8(%ebp)
  800469:	e8 05 00 00 00       	call   800473 <vprintfmt>
}
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <vprintfmt>:
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	57                   	push   %edi
  800477:	56                   	push   %esi
  800478:	53                   	push   %ebx
  800479:	83 ec 3c             	sub    $0x3c,%esp
  80047c:	8b 75 08             	mov    0x8(%ebp),%esi
  80047f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800482:	8b 7d 10             	mov    0x10(%ebp),%edi
  800485:	e9 32 04 00 00       	jmp    8008bc <vprintfmt+0x449>
		padc = ' ';
  80048a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80048e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800495:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80049c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004aa:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8d 47 01             	lea    0x1(%edi),%eax
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	0f b6 17             	movzbl (%edi),%edx
  8004bf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c2:	3c 55                	cmp    $0x55,%al
  8004c4:	0f 87 12 05 00 00    	ja     8009dc <vprintfmt+0x569>
  8004ca:	0f b6 c0             	movzbl %al,%eax
  8004cd:	ff 24 85 40 35 80 00 	jmp    *0x803540(,%eax,4)
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004d7:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004db:	eb d9                	jmp    8004b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004e4:	eb d0                	jmp    8004b6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	0f b6 d2             	movzbl %dl,%edx
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f4:	eb 03                	jmp    8004f9 <vprintfmt+0x86>
  8004f6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004f9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800500:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800503:	8d 72 d0             	lea    -0x30(%edx),%esi
  800506:	83 fe 09             	cmp    $0x9,%esi
  800509:	76 eb                	jbe    8004f6 <vprintfmt+0x83>
  80050b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050e:	8b 75 08             	mov    0x8(%ebp),%esi
  800511:	eb 14                	jmp    800527 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8d 40 04             	lea    0x4(%eax),%eax
  800521:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800524:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800527:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052b:	79 89                	jns    8004b6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80052d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800533:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80053a:	e9 77 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
  80053f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800542:	85 c0                	test   %eax,%eax
  800544:	0f 48 c1             	cmovs  %ecx,%eax
  800547:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80054d:	e9 64 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800555:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80055c:	e9 55 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
			lflag++;
  800561:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800568:	e9 49 ff ff ff       	jmp    8004b6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8d 78 04             	lea    0x4(%eax),%edi
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	53                   	push   %ebx
  800577:	ff 30                	pushl  (%eax)
  800579:	ff d6                	call   *%esi
			break;
  80057b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80057e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800581:	e9 33 03 00 00       	jmp    8008b9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8d 78 04             	lea    0x4(%eax),%edi
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	99                   	cltd   
  80058f:	31 d0                	xor    %edx,%eax
  800591:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800593:	83 f8 10             	cmp    $0x10,%eax
  800596:	7f 23                	jg     8005bb <vprintfmt+0x148>
  800598:	8b 14 85 a0 36 80 00 	mov    0x8036a0(,%eax,4),%edx
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	74 18                	je     8005bb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a3:	52                   	push   %edx
  8005a4:	68 b1 38 80 00       	push   $0x8038b1
  8005a9:	53                   	push   %ebx
  8005aa:	56                   	push   %esi
  8005ab:	e8 a6 fe ff ff       	call   800456 <printfmt>
  8005b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b6:	e9 fe 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bb:	50                   	push   %eax
  8005bc:	68 73 33 80 00       	push   $0x803373
  8005c1:	53                   	push   %ebx
  8005c2:	56                   	push   %esi
  8005c3:	e8 8e fe ff ff       	call   800456 <printfmt>
  8005c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005cb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005ce:	e9 e6 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005e1:	85 c9                	test   %ecx,%ecx
  8005e3:	b8 6c 33 80 00       	mov    $0x80336c,%eax
  8005e8:	0f 45 c1             	cmovne %ecx,%eax
  8005eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f2:	7e 06                	jle    8005fa <vprintfmt+0x187>
  8005f4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005f8:	75 0d                	jne    800607 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005fd:	89 c7                	mov    %eax,%edi
  8005ff:	03 45 e0             	add    -0x20(%ebp),%eax
  800602:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800605:	eb 53                	jmp    80065a <vprintfmt+0x1e7>
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	ff 75 d8             	pushl  -0x28(%ebp)
  80060d:	50                   	push   %eax
  80060e:	e8 71 04 00 00       	call   800a84 <strnlen>
  800613:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800616:	29 c1                	sub    %eax,%ecx
  800618:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800620:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800627:	eb 0f                	jmp    800638 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	ff 75 e0             	pushl  -0x20(%ebp)
  800630:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800632:	83 ef 01             	sub    $0x1,%edi
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	85 ff                	test   %edi,%edi
  80063a:	7f ed                	jg     800629 <vprintfmt+0x1b6>
  80063c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80063f:	85 c9                	test   %ecx,%ecx
  800641:	b8 00 00 00 00       	mov    $0x0,%eax
  800646:	0f 49 c1             	cmovns %ecx,%eax
  800649:	29 c1                	sub    %eax,%ecx
  80064b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80064e:	eb aa                	jmp    8005fa <vprintfmt+0x187>
					putch(ch, putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	52                   	push   %edx
  800655:	ff d6                	call   *%esi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80065d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065f:	83 c7 01             	add    $0x1,%edi
  800662:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800666:	0f be d0             	movsbl %al,%edx
  800669:	85 d2                	test   %edx,%edx
  80066b:	74 4b                	je     8006b8 <vprintfmt+0x245>
  80066d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800671:	78 06                	js     800679 <vprintfmt+0x206>
  800673:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800677:	78 1e                	js     800697 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800679:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80067d:	74 d1                	je     800650 <vprintfmt+0x1dd>
  80067f:	0f be c0             	movsbl %al,%eax
  800682:	83 e8 20             	sub    $0x20,%eax
  800685:	83 f8 5e             	cmp    $0x5e,%eax
  800688:	76 c6                	jbe    800650 <vprintfmt+0x1dd>
					putch('?', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 3f                	push   $0x3f
  800690:	ff d6                	call   *%esi
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	eb c3                	jmp    80065a <vprintfmt+0x1e7>
  800697:	89 cf                	mov    %ecx,%edi
  800699:	eb 0e                	jmp    8006a9 <vprintfmt+0x236>
				putch(' ', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 20                	push   $0x20
  8006a1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006a3:	83 ef 01             	sub    $0x1,%edi
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	85 ff                	test   %edi,%edi
  8006ab:	7f ee                	jg     80069b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b3:	e9 01 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
  8006b8:	89 cf                	mov    %ecx,%edi
  8006ba:	eb ed                	jmp    8006a9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006bf:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006c6:	e9 eb fd ff ff       	jmp    8004b6 <vprintfmt+0x43>
	if (lflag >= 2)
  8006cb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006cf:	7f 21                	jg     8006f2 <vprintfmt+0x27f>
	else if (lflag)
  8006d1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d5:	74 68                	je     80073f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006df:	89 c1                	mov    %eax,%ecx
  8006e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb 17                	jmp    800709 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 50 04             	mov    0x4(%eax),%edx
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 08             	lea    0x8(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80070c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800715:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800719:	78 3f                	js     80075a <vprintfmt+0x2e7>
			base = 10;
  80071b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800720:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800724:	0f 84 71 01 00 00    	je     80089b <vprintfmt+0x428>
				putch('+', putdat);
  80072a:	83 ec 08             	sub    $0x8,%esp
  80072d:	53                   	push   %ebx
  80072e:	6a 2b                	push   $0x2b
  800730:	ff d6                	call   *%esi
  800732:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	e9 5c 01 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, int);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800747:	89 c1                	mov    %eax,%ecx
  800749:	c1 f9 1f             	sar    $0x1f,%ecx
  80074c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
  800758:	eb af                	jmp    800709 <vprintfmt+0x296>
				putch('-', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 2d                	push   $0x2d
  800760:	ff d6                	call   *%esi
				num = -(long long) num;
  800762:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800768:	f7 d8                	neg    %eax
  80076a:	83 d2 00             	adc    $0x0,%edx
  80076d:	f7 da                	neg    %edx
  80076f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800772:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800775:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800778:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077d:	e9 19 01 00 00       	jmp    80089b <vprintfmt+0x428>
	if (lflag >= 2)
  800782:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800786:	7f 29                	jg     8007b1 <vprintfmt+0x33e>
	else if (lflag)
  800788:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078c:	74 44                	je     8007d2 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 00                	mov    (%eax),%eax
  800793:	ba 00 00 00 00       	mov    $0x0,%edx
  800798:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ac:	e9 ea 00 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 08             	lea    0x8(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	e9 c9 00 00 00       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e5:	8d 40 04             	lea    0x4(%eax),%eax
  8007e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f0:	e9 a6 00 00 00       	jmp    80089b <vprintfmt+0x428>
			putch('0', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 30                	push   $0x30
  8007fb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800804:	7f 26                	jg     80082c <vprintfmt+0x3b9>
	else if (lflag)
  800806:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080a:	74 3e                	je     80084a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800825:	b8 08 00 00 00       	mov    $0x8,%eax
  80082a:	eb 6f                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 50 04             	mov    0x4(%eax),%edx
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800837:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8d 40 08             	lea    0x8(%eax),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800843:	b8 08 00 00 00       	mov    $0x8,%eax
  800848:	eb 51                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	ba 00 00 00 00       	mov    $0x0,%edx
  800854:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800857:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8d 40 04             	lea    0x4(%eax),%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800863:	b8 08 00 00 00       	mov    $0x8,%eax
  800868:	eb 31                	jmp    80089b <vprintfmt+0x428>
			putch('0', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	53                   	push   %ebx
  80086e:	6a 30                	push   $0x30
  800870:	ff d6                	call   *%esi
			putch('x', putdat);
  800872:	83 c4 08             	add    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 78                	push   $0x78
  800878:	ff d6                	call   *%esi
			num = (unsigned long long)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	ba 00 00 00 00       	mov    $0x0,%edx
  800884:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800887:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80088a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8d 40 04             	lea    0x4(%eax),%eax
  800893:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800896:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80089b:	83 ec 0c             	sub    $0xc,%esp
  80089e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008a2:	52                   	push   %edx
  8008a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8008aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8008ad:	89 da                	mov    %ebx,%edx
  8008af:	89 f0                	mov    %esi,%eax
  8008b1:	e8 a4 fa ff ff       	call   80035a <printnum>
			break;
  8008b6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008bc:	83 c7 01             	add    $0x1,%edi
  8008bf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008c3:	83 f8 25             	cmp    $0x25,%eax
  8008c6:	0f 84 be fb ff ff    	je     80048a <vprintfmt+0x17>
			if (ch == '\0')
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	0f 84 28 01 00 00    	je     8009fc <vprintfmt+0x589>
			putch(ch, putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	50                   	push   %eax
  8008d9:	ff d6                	call   *%esi
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	eb dc                	jmp    8008bc <vprintfmt+0x449>
	if (lflag >= 2)
  8008e0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008e4:	7f 26                	jg     80090c <vprintfmt+0x499>
	else if (lflag)
  8008e6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ea:	74 41                	je     80092d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ff:	8d 40 04             	lea    0x4(%eax),%eax
  800902:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800905:	b8 10 00 00 00       	mov    $0x10,%eax
  80090a:	eb 8f                	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	8b 50 04             	mov    0x4(%eax),%edx
  800912:	8b 00                	mov    (%eax),%eax
  800914:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800917:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
  800928:	e9 6e ff ff ff       	jmp    80089b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	ba 00 00 00 00       	mov    $0x0,%edx
  800937:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	8d 40 04             	lea    0x4(%eax),%eax
  800943:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800946:	b8 10 00 00 00       	mov    $0x10,%eax
  80094b:	e9 4b ff ff ff       	jmp    80089b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	83 c0 04             	add    $0x4,%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	85 c0                	test   %eax,%eax
  800960:	74 14                	je     800976 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800962:	8b 13                	mov    (%ebx),%edx
  800964:	83 fa 7f             	cmp    $0x7f,%edx
  800967:	7f 37                	jg     8009a0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800969:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80096b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80096e:	89 45 14             	mov    %eax,0x14(%ebp)
  800971:	e9 43 ff ff ff       	jmp    8008b9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800976:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097b:	bf 91 34 80 00       	mov    $0x803491,%edi
							putch(ch, putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	53                   	push   %ebx
  800984:	50                   	push   %eax
  800985:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800987:	83 c7 01             	add    $0x1,%edi
  80098a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80098e:	83 c4 10             	add    $0x10,%esp
  800991:	85 c0                	test   %eax,%eax
  800993:	75 eb                	jne    800980 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800995:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800998:	89 45 14             	mov    %eax,0x14(%ebp)
  80099b:	e9 19 ff ff ff       	jmp    8008b9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009a0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a7:	bf c9 34 80 00       	mov    $0x8034c9,%edi
							putch(ch, putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	53                   	push   %ebx
  8009b0:	50                   	push   %eax
  8009b1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009b3:	83 c7 01             	add    $0x1,%edi
  8009b6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	75 eb                	jne    8009ac <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c7:	e9 ed fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
			putch(ch, putdat);
  8009cc:	83 ec 08             	sub    $0x8,%esp
  8009cf:	53                   	push   %ebx
  8009d0:	6a 25                	push   $0x25
  8009d2:	ff d6                	call   *%esi
			break;
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	e9 dd fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
			putch('%', putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	53                   	push   %ebx
  8009e0:	6a 25                	push   $0x25
  8009e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e4:	83 c4 10             	add    $0x10,%esp
  8009e7:	89 f8                	mov    %edi,%eax
  8009e9:	eb 03                	jmp    8009ee <vprintfmt+0x57b>
  8009eb:	83 e8 01             	sub    $0x1,%eax
  8009ee:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009f2:	75 f7                	jne    8009eb <vprintfmt+0x578>
  8009f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f7:	e9 bd fe ff ff       	jmp    8008b9 <vprintfmt+0x446>
}
  8009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	83 ec 18             	sub    $0x18,%esp
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a13:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a17:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a21:	85 c0                	test   %eax,%eax
  800a23:	74 26                	je     800a4b <vsnprintf+0x47>
  800a25:	85 d2                	test   %edx,%edx
  800a27:	7e 22                	jle    800a4b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a29:	ff 75 14             	pushl  0x14(%ebp)
  800a2c:	ff 75 10             	pushl  0x10(%ebp)
  800a2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a32:	50                   	push   %eax
  800a33:	68 39 04 80 00       	push   $0x800439
  800a38:	e8 36 fa ff ff       	call   800473 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a40:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a46:	83 c4 10             	add    $0x10,%esp
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    
		return -E_INVAL;
  800a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a50:	eb f7                	jmp    800a49 <vsnprintf+0x45>

00800a52 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a5b:	50                   	push   %eax
  800a5c:	ff 75 10             	pushl  0x10(%ebp)
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	ff 75 08             	pushl  0x8(%ebp)
  800a65:	e8 9a ff ff ff       	call   800a04 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
  800a77:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a7b:	74 05                	je     800a82 <strlen+0x16>
		n++;
  800a7d:	83 c0 01             	add    $0x1,%eax
  800a80:	eb f5                	jmp    800a77 <strlen+0xb>
	return n;
}
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a92:	39 c2                	cmp    %eax,%edx
  800a94:	74 0d                	je     800aa3 <strnlen+0x1f>
  800a96:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a9a:	74 05                	je     800aa1 <strnlen+0x1d>
		n++;
  800a9c:	83 c2 01             	add    $0x1,%edx
  800a9f:	eb f1                	jmp    800a92 <strnlen+0xe>
  800aa1:	89 d0                	mov    %edx,%eax
	return n;
}
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	53                   	push   %ebx
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aaf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800ab8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800abb:	83 c2 01             	add    $0x1,%edx
  800abe:	84 c9                	test   %cl,%cl
  800ac0:	75 f2                	jne    800ab4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	53                   	push   %ebx
  800ac9:	83 ec 10             	sub    $0x10,%esp
  800acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800acf:	53                   	push   %ebx
  800ad0:	e8 97 ff ff ff       	call   800a6c <strlen>
  800ad5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	01 d8                	add    %ebx,%eax
  800add:	50                   	push   %eax
  800ade:	e8 c2 ff ff ff       	call   800aa5 <strcpy>
	return dst;
}
  800ae3:	89 d8                	mov    %ebx,%eax
  800ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae8:	c9                   	leave  
  800ae9:	c3                   	ret    

00800aea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af5:	89 c6                	mov    %eax,%esi
  800af7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afa:	89 c2                	mov    %eax,%edx
  800afc:	39 f2                	cmp    %esi,%edx
  800afe:	74 11                	je     800b11 <strncpy+0x27>
		*dst++ = *src;
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	0f b6 19             	movzbl (%ecx),%ebx
  800b06:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b09:	80 fb 01             	cmp    $0x1,%bl
  800b0c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b0f:	eb eb                	jmp    800afc <strncpy+0x12>
	}
	return ret;
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b20:	8b 55 10             	mov    0x10(%ebp),%edx
  800b23:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b25:	85 d2                	test   %edx,%edx
  800b27:	74 21                	je     800b4a <strlcpy+0x35>
  800b29:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b2d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b2f:	39 c2                	cmp    %eax,%edx
  800b31:	74 14                	je     800b47 <strlcpy+0x32>
  800b33:	0f b6 19             	movzbl (%ecx),%ebx
  800b36:	84 db                	test   %bl,%bl
  800b38:	74 0b                	je     800b45 <strlcpy+0x30>
			*dst++ = *src++;
  800b3a:	83 c1 01             	add    $0x1,%ecx
  800b3d:	83 c2 01             	add    $0x1,%edx
  800b40:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b43:	eb ea                	jmp    800b2f <strlcpy+0x1a>
  800b45:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b47:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b4a:	29 f0                	sub    %esi,%eax
}
  800b4c:	5b                   	pop    %ebx
  800b4d:	5e                   	pop    %esi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	84 c0                	test   %al,%al
  800b5e:	74 0c                	je     800b6c <strcmp+0x1c>
  800b60:	3a 02                	cmp    (%edx),%al
  800b62:	75 08                	jne    800b6c <strcmp+0x1c>
		p++, q++;
  800b64:	83 c1 01             	add    $0x1,%ecx
  800b67:	83 c2 01             	add    $0x1,%edx
  800b6a:	eb ed                	jmp    800b59 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b6c:	0f b6 c0             	movzbl %al,%eax
  800b6f:	0f b6 12             	movzbl (%edx),%edx
  800b72:	29 d0                	sub    %edx,%eax
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	53                   	push   %ebx
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	89 c3                	mov    %eax,%ebx
  800b82:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b85:	eb 06                	jmp    800b8d <strncmp+0x17>
		n--, p++, q++;
  800b87:	83 c0 01             	add    $0x1,%eax
  800b8a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b8d:	39 d8                	cmp    %ebx,%eax
  800b8f:	74 16                	je     800ba7 <strncmp+0x31>
  800b91:	0f b6 08             	movzbl (%eax),%ecx
  800b94:	84 c9                	test   %cl,%cl
  800b96:	74 04                	je     800b9c <strncmp+0x26>
  800b98:	3a 0a                	cmp    (%edx),%cl
  800b9a:	74 eb                	je     800b87 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b9c:	0f b6 00             	movzbl (%eax),%eax
  800b9f:	0f b6 12             	movzbl (%edx),%edx
  800ba2:	29 d0                	sub    %edx,%eax
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    
		return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	eb f6                	jmp    800ba4 <strncmp+0x2e>

00800bae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb8:	0f b6 10             	movzbl (%eax),%edx
  800bbb:	84 d2                	test   %dl,%dl
  800bbd:	74 09                	je     800bc8 <strchr+0x1a>
		if (*s == c)
  800bbf:	38 ca                	cmp    %cl,%dl
  800bc1:	74 0a                	je     800bcd <strchr+0x1f>
	for (; *s; s++)
  800bc3:	83 c0 01             	add    $0x1,%eax
  800bc6:	eb f0                	jmp    800bb8 <strchr+0xa>
			return (char *) s;
	return 0;
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    

00800bcf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bdc:	38 ca                	cmp    %cl,%dl
  800bde:	74 09                	je     800be9 <strfind+0x1a>
  800be0:	84 d2                	test   %dl,%dl
  800be2:	74 05                	je     800be9 <strfind+0x1a>
	for (; *s; s++)
  800be4:	83 c0 01             	add    $0x1,%eax
  800be7:	eb f0                	jmp    800bd9 <strfind+0xa>
			break;
	return (char *) s;
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf7:	85 c9                	test   %ecx,%ecx
  800bf9:	74 31                	je     800c2c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bfb:	89 f8                	mov    %edi,%eax
  800bfd:	09 c8                	or     %ecx,%eax
  800bff:	a8 03                	test   $0x3,%al
  800c01:	75 23                	jne    800c26 <memset+0x3b>
		c &= 0xFF;
  800c03:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c07:	89 d3                	mov    %edx,%ebx
  800c09:	c1 e3 08             	shl    $0x8,%ebx
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	c1 e0 18             	shl    $0x18,%eax
  800c11:	89 d6                	mov    %edx,%esi
  800c13:	c1 e6 10             	shl    $0x10,%esi
  800c16:	09 f0                	or     %esi,%eax
  800c18:	09 c2                	or     %eax,%edx
  800c1a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c1f:	89 d0                	mov    %edx,%eax
  800c21:	fc                   	cld    
  800c22:	f3 ab                	rep stos %eax,%es:(%edi)
  800c24:	eb 06                	jmp    800c2c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	fc                   	cld    
  800c2a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2c:	89 f8                	mov    %edi,%eax
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c41:	39 c6                	cmp    %eax,%esi
  800c43:	73 32                	jae    800c77 <memmove+0x44>
  800c45:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c48:	39 c2                	cmp    %eax,%edx
  800c4a:	76 2b                	jbe    800c77 <memmove+0x44>
		s += n;
		d += n;
  800c4c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4f:	89 fe                	mov    %edi,%esi
  800c51:	09 ce                	or     %ecx,%esi
  800c53:	09 d6                	or     %edx,%esi
  800c55:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5b:	75 0e                	jne    800c6b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c5d:	83 ef 04             	sub    $0x4,%edi
  800c60:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c63:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c66:	fd                   	std    
  800c67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c69:	eb 09                	jmp    800c74 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6b:	83 ef 01             	sub    $0x1,%edi
  800c6e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c71:	fd                   	std    
  800c72:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c74:	fc                   	cld    
  800c75:	eb 1a                	jmp    800c91 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c77:	89 c2                	mov    %eax,%edx
  800c79:	09 ca                	or     %ecx,%edx
  800c7b:	09 f2                	or     %esi,%edx
  800c7d:	f6 c2 03             	test   $0x3,%dl
  800c80:	75 0a                	jne    800c8c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c82:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c85:	89 c7                	mov    %eax,%edi
  800c87:	fc                   	cld    
  800c88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c8a:	eb 05                	jmp    800c91 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c9b:	ff 75 10             	pushl  0x10(%ebp)
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 8a ff ff ff       	call   800c33 <memmove>
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb6:	89 c6                	mov    %eax,%esi
  800cb8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbb:	39 f0                	cmp    %esi,%eax
  800cbd:	74 1c                	je     800cdb <memcmp+0x30>
		if (*s1 != *s2)
  800cbf:	0f b6 08             	movzbl (%eax),%ecx
  800cc2:	0f b6 1a             	movzbl (%edx),%ebx
  800cc5:	38 d9                	cmp    %bl,%cl
  800cc7:	75 08                	jne    800cd1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cc9:	83 c0 01             	add    $0x1,%eax
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	eb ea                	jmp    800cbb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cd1:	0f b6 c1             	movzbl %cl,%eax
  800cd4:	0f b6 db             	movzbl %bl,%ebx
  800cd7:	29 d8                	sub    %ebx,%eax
  800cd9:	eb 05                	jmp    800ce0 <memcmp+0x35>
	}

	return 0;
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ced:	89 c2                	mov    %eax,%edx
  800cef:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf2:	39 d0                	cmp    %edx,%eax
  800cf4:	73 09                	jae    800cff <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf6:	38 08                	cmp    %cl,(%eax)
  800cf8:	74 05                	je     800cff <memfind+0x1b>
	for (; s < ends; s++)
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	eb f3                	jmp    800cf2 <memfind+0xe>
			break;
	return (void *) s;
}
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
  800d07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0d:	eb 03                	jmp    800d12 <strtol+0x11>
		s++;
  800d0f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d12:	0f b6 01             	movzbl (%ecx),%eax
  800d15:	3c 20                	cmp    $0x20,%al
  800d17:	74 f6                	je     800d0f <strtol+0xe>
  800d19:	3c 09                	cmp    $0x9,%al
  800d1b:	74 f2                	je     800d0f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d1d:	3c 2b                	cmp    $0x2b,%al
  800d1f:	74 2a                	je     800d4b <strtol+0x4a>
	int neg = 0;
  800d21:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d26:	3c 2d                	cmp    $0x2d,%al
  800d28:	74 2b                	je     800d55 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d2a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d30:	75 0f                	jne    800d41 <strtol+0x40>
  800d32:	80 39 30             	cmpb   $0x30,(%ecx)
  800d35:	74 28                	je     800d5f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d37:	85 db                	test   %ebx,%ebx
  800d39:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d3e:	0f 44 d8             	cmove  %eax,%ebx
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
  800d46:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d49:	eb 50                	jmp    800d9b <strtol+0x9a>
		s++;
  800d4b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d53:	eb d5                	jmp    800d2a <strtol+0x29>
		s++, neg = 1;
  800d55:	83 c1 01             	add    $0x1,%ecx
  800d58:	bf 01 00 00 00       	mov    $0x1,%edi
  800d5d:	eb cb                	jmp    800d2a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d5f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d63:	74 0e                	je     800d73 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d65:	85 db                	test   %ebx,%ebx
  800d67:	75 d8                	jne    800d41 <strtol+0x40>
		s++, base = 8;
  800d69:	83 c1 01             	add    $0x1,%ecx
  800d6c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d71:	eb ce                	jmp    800d41 <strtol+0x40>
		s += 2, base = 16;
  800d73:	83 c1 02             	add    $0x2,%ecx
  800d76:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d7b:	eb c4                	jmp    800d41 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d7d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d80:	89 f3                	mov    %esi,%ebx
  800d82:	80 fb 19             	cmp    $0x19,%bl
  800d85:	77 29                	ja     800db0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d87:	0f be d2             	movsbl %dl,%edx
  800d8a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d90:	7d 30                	jge    800dc2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d92:	83 c1 01             	add    $0x1,%ecx
  800d95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d99:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d9b:	0f b6 11             	movzbl (%ecx),%edx
  800d9e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800da1:	89 f3                	mov    %esi,%ebx
  800da3:	80 fb 09             	cmp    $0x9,%bl
  800da6:	77 d5                	ja     800d7d <strtol+0x7c>
			dig = *s - '0';
  800da8:	0f be d2             	movsbl %dl,%edx
  800dab:	83 ea 30             	sub    $0x30,%edx
  800dae:	eb dd                	jmp    800d8d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800db0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800db3:	89 f3                	mov    %esi,%ebx
  800db5:	80 fb 19             	cmp    $0x19,%bl
  800db8:	77 08                	ja     800dc2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dba:	0f be d2             	movsbl %dl,%edx
  800dbd:	83 ea 37             	sub    $0x37,%edx
  800dc0:	eb cb                	jmp    800d8d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc6:	74 05                	je     800dcd <strtol+0xcc>
		*endptr = (char *) s;
  800dc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	f7 da                	neg    %edx
  800dd1:	85 ff                	test   %edi,%edi
  800dd3:	0f 45 c2             	cmovne %edx,%eax
}
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	89 c3                	mov    %eax,%ebx
  800dee:	89 c7                	mov    %eax,%edi
  800df0:	89 c6                	mov    %eax,%esi
  800df2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	b8 01 00 00 00       	mov    $0x1,%eax
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 d3                	mov    %edx,%ebx
  800e0d:	89 d7                	mov    %edx,%edi
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	57                   	push   %edi
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e21:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	b8 03 00 00 00       	mov    $0x3,%eax
  800e2e:	89 cb                	mov    %ecx,%ebx
  800e30:	89 cf                	mov    %ecx,%edi
  800e32:	89 ce                	mov    %ecx,%esi
  800e34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7f 08                	jg     800e42 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e42:	83 ec 0c             	sub    $0xc,%esp
  800e45:	50                   	push   %eax
  800e46:	6a 03                	push   $0x3
  800e48:	68 e4 36 80 00       	push   $0x8036e4
  800e4d:	6a 43                	push   $0x43
  800e4f:	68 01 37 80 00       	push   $0x803701
  800e54:	e8 f7 f3 ff ff       	call   800250 <_panic>

00800e59 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e64:	b8 02 00 00 00       	mov    $0x2,%eax
  800e69:	89 d1                	mov    %edx,%ecx
  800e6b:	89 d3                	mov    %edx,%ebx
  800e6d:	89 d7                	mov    %edx,%edi
  800e6f:	89 d6                	mov    %edx,%esi
  800e71:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_yield>:

void
sys_yield(void)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e88:	89 d1                	mov    %edx,%ecx
  800e8a:	89 d3                	mov    %edx,%ebx
  800e8c:	89 d7                	mov    %edx,%edi
  800e8e:	89 d6                	mov    %edx,%esi
  800e90:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea0:	be 00 00 00 00       	mov    $0x0,%esi
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 04 00 00 00       	mov    $0x4,%eax
  800eb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb3:	89 f7                	mov    %esi,%edi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 04                	push   $0x4
  800ec9:	68 e4 36 80 00       	push   $0x8036e4
  800ece:	6a 43                	push   $0x43
  800ed0:	68 01 37 80 00       	push   $0x803701
  800ed5:	e8 76 f3 ff ff       	call   800250 <_panic>

00800eda <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	b8 05 00 00 00       	mov    $0x5,%eax
  800eee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 05                	push   $0x5
  800f0b:	68 e4 36 80 00       	push   $0x8036e4
  800f10:	6a 43                	push   $0x43
  800f12:	68 01 37 80 00       	push   $0x803701
  800f17:	e8 34 f3 ff ff       	call   800250 <_panic>

00800f1c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 06 00 00 00       	mov    $0x6,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	7f 08                	jg     800f47 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	50                   	push   %eax
  800f4b:	6a 06                	push   $0x6
  800f4d:	68 e4 36 80 00       	push   $0x8036e4
  800f52:	6a 43                	push   $0x43
  800f54:	68 01 37 80 00       	push   $0x803701
  800f59:	e8 f2 f2 ff ff       	call   800250 <_panic>

00800f5e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	57                   	push   %edi
  800f62:	56                   	push   %esi
  800f63:	53                   	push   %ebx
  800f64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 08 00 00 00       	mov    $0x8,%eax
  800f77:	89 df                	mov    %ebx,%edi
  800f79:	89 de                	mov    %ebx,%esi
  800f7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	7f 08                	jg     800f89 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	50                   	push   %eax
  800f8d:	6a 08                	push   $0x8
  800f8f:	68 e4 36 80 00       	push   $0x8036e4
  800f94:	6a 43                	push   $0x43
  800f96:	68 01 37 80 00       	push   $0x803701
  800f9b:	e8 b0 f2 ff ff       	call   800250 <_panic>

00800fa0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	b8 09 00 00 00       	mov    $0x9,%eax
  800fb9:	89 df                	mov    %ebx,%edi
  800fbb:	89 de                	mov    %ebx,%esi
  800fbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	7f 08                	jg     800fcb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	50                   	push   %eax
  800fcf:	6a 09                	push   $0x9
  800fd1:	68 e4 36 80 00       	push   $0x8036e4
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 01 37 80 00       	push   $0x803701
  800fdd:	e8 6e f2 ff ff       	call   800250 <_panic>

00800fe2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800feb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ffb:	89 df                	mov    %ebx,%edi
  800ffd:	89 de                	mov    %ebx,%esi
  800fff:	cd 30                	int    $0x30
	if(check && ret > 0)
  801001:	85 c0                	test   %eax,%eax
  801003:	7f 08                	jg     80100d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801005:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	50                   	push   %eax
  801011:	6a 0a                	push   $0xa
  801013:	68 e4 36 80 00       	push   $0x8036e4
  801018:	6a 43                	push   $0x43
  80101a:	68 01 37 80 00       	push   $0x803701
  80101f:	e8 2c f2 ff ff       	call   800250 <_panic>

00801024 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	57                   	push   %edi
  801028:	56                   	push   %esi
  801029:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	b8 0c 00 00 00       	mov    $0xc,%eax
  801035:	be 00 00 00 00       	mov    $0x0,%esi
  80103a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801040:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801042:	5b                   	pop    %ebx
  801043:	5e                   	pop    %esi
  801044:	5f                   	pop    %edi
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801050:	b9 00 00 00 00       	mov    $0x0,%ecx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105d:	89 cb                	mov    %ecx,%ebx
  80105f:	89 cf                	mov    %ecx,%edi
  801061:	89 ce                	mov    %ecx,%esi
  801063:	cd 30                	int    $0x30
	if(check && ret > 0)
  801065:	85 c0                	test   %eax,%eax
  801067:	7f 08                	jg     801071 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801069:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	50                   	push   %eax
  801075:	6a 0d                	push   $0xd
  801077:	68 e4 36 80 00       	push   $0x8036e4
  80107c:	6a 43                	push   $0x43
  80107e:	68 01 37 80 00       	push   $0x803701
  801083:	e8 c8 f1 ff ff       	call   800250 <_panic>

00801088 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
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
  801099:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	57                   	push   %edi
  8010ad:	56                   	push   %esi
  8010ae:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010bc:	89 cb                	mov    %ecx,%ebx
  8010be:	89 cf                	mov    %ecx,%edi
  8010c0:	89 ce                	mov    %ecx,%esi
  8010c2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8010d9:	89 d1                	mov    %edx,%ecx
  8010db:	89 d3                	mov    %edx,%ebx
  8010dd:	89 d7                	mov    %edx,%edi
  8010df:	89 d6                	mov    %edx,%esi
  8010e1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e3:	5b                   	pop    %ebx
  8010e4:	5e                   	pop    %esi
  8010e5:	5f                   	pop    %edi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	57                   	push   %edi
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f9:	b8 11 00 00 00       	mov    $0x11,%eax
  8010fe:	89 df                	mov    %ebx,%edi
  801100:	89 de                	mov    %ebx,%esi
  801102:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	57                   	push   %edi
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801114:	8b 55 08             	mov    0x8(%ebp),%edx
  801117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111a:	b8 12 00 00 00       	mov    $0x12,%eax
  80111f:	89 df                	mov    %ebx,%edi
  801121:	89 de                	mov    %ebx,%esi
  801123:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113e:	b8 13 00 00 00       	mov    $0x13,%eax
  801143:	89 df                	mov    %ebx,%edi
  801145:	89 de                	mov    %ebx,%esi
  801147:	cd 30                	int    $0x30
	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7f 08                	jg     801155 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	50                   	push   %eax
  801159:	6a 13                	push   $0x13
  80115b:	68 e4 36 80 00       	push   $0x8036e4
  801160:	6a 43                	push   $0x43
  801162:	68 01 37 80 00       	push   $0x803701
  801167:	e8 e4 f0 ff ff       	call   800250 <_panic>

0080116c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	53                   	push   %ebx
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801176:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801178:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80117c:	0f 84 99 00 00 00    	je     80121b <pgfault+0xaf>
  801182:	89 c2                	mov    %eax,%edx
  801184:	c1 ea 16             	shr    $0x16,%edx
  801187:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80118e:	f6 c2 01             	test   $0x1,%dl
  801191:	0f 84 84 00 00 00    	je     80121b <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801197:	89 c2                	mov    %eax,%edx
  801199:	c1 ea 0c             	shr    $0xc,%edx
  80119c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a3:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011a9:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011af:	75 6a                	jne    80121b <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8011b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b6:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	6a 07                	push   $0x7
  8011bd:	68 00 f0 7f 00       	push   $0x7ff000
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 ce fc ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 5f                	js     80122f <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	68 00 10 00 00       	push   $0x1000
  8011d8:	53                   	push   %ebx
  8011d9:	68 00 f0 7f 00       	push   $0x7ff000
  8011de:	e8 b2 fa ff ff       	call   800c95 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  8011e3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8011ea:	53                   	push   %ebx
  8011eb:	6a 00                	push   $0x0
  8011ed:	68 00 f0 7f 00       	push   $0x7ff000
  8011f2:	6a 00                	push   $0x0
  8011f4:	e8 e1 fc ff ff       	call   800eda <sys_page_map>
	if(ret < 0)
  8011f9:	83 c4 20             	add    $0x20,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 43                	js     801243 <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801200:	83 ec 08             	sub    $0x8,%esp
  801203:	68 00 f0 7f 00       	push   $0x7ff000
  801208:	6a 00                	push   $0x0
  80120a:	e8 0d fd ff ff       	call   800f1c <sys_page_unmap>
	if(ret < 0)
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 41                	js     801257 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801219:	c9                   	leave  
  80121a:	c3                   	ret    
		panic("panic at pgfault()\n");
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	68 0f 37 80 00       	push   $0x80370f
  801223:	6a 26                	push   $0x26
  801225:	68 23 37 80 00       	push   $0x803723
  80122a:	e8 21 f0 ff ff       	call   800250 <_panic>
		panic("panic in sys_page_alloc()\n");
  80122f:	83 ec 04             	sub    $0x4,%esp
  801232:	68 2e 37 80 00       	push   $0x80372e
  801237:	6a 31                	push   $0x31
  801239:	68 23 37 80 00       	push   $0x803723
  80123e:	e8 0d f0 ff ff       	call   800250 <_panic>
		panic("panic in sys_page_map()\n");
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	68 49 37 80 00       	push   $0x803749
  80124b:	6a 36                	push   $0x36
  80124d:	68 23 37 80 00       	push   $0x803723
  801252:	e8 f9 ef ff ff       	call   800250 <_panic>
		panic("panic in sys_page_unmap()\n");
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 62 37 80 00       	push   $0x803762
  80125f:	6a 39                	push   $0x39
  801261:	68 23 37 80 00       	push   $0x803723
  801266:	e8 e5 ef ff ff       	call   800250 <_panic>

0080126b <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	56                   	push   %esi
  80126f:	53                   	push   %ebx
  801270:	89 c6                	mov    %eax,%esi
  801272:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	68 00 38 80 00       	push   $0x803800
  80127c:	68 28 33 80 00       	push   $0x803328
  801281:	e8 c0 f0 ff ff       	call   800346 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801286:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	f6 c4 04             	test   $0x4,%ah
  801293:	75 45                	jne    8012da <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801295:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80129c:	83 e0 07             	and    $0x7,%eax
  80129f:	83 f8 07             	cmp    $0x7,%eax
  8012a2:	74 6e                	je     801312 <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012a4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012ab:	25 05 08 00 00       	and    $0x805,%eax
  8012b0:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012b5:	0f 84 b5 00 00 00    	je     801370 <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012bb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c2:	83 e0 05             	and    $0x5,%eax
  8012c5:	83 f8 05             	cmp    $0x5,%eax
  8012c8:	0f 84 d6 00 00 00    	je     8013a4 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8012ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8012da:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012e1:	c1 e3 0c             	shl    $0xc,%ebx
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ec:	50                   	push   %eax
  8012ed:	53                   	push   %ebx
  8012ee:	56                   	push   %esi
  8012ef:	53                   	push   %ebx
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 e3 fb ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8012f7:	83 c4 20             	add    $0x20,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	79 d0                	jns    8012ce <duppage+0x63>
			panic("sys_page_map() panic\n");
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	68 7d 37 80 00       	push   $0x80377d
  801306:	6a 55                	push   $0x55
  801308:	68 23 37 80 00       	push   $0x803723
  80130d:	e8 3e ef ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801312:	c1 e3 0c             	shl    $0xc,%ebx
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	68 05 08 00 00       	push   $0x805
  80131d:	53                   	push   %ebx
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
  801320:	6a 00                	push   $0x0
  801322:	e8 b3 fb ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801327:	83 c4 20             	add    $0x20,%esp
  80132a:	85 c0                	test   %eax,%eax
  80132c:	78 2e                	js     80135c <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	68 05 08 00 00       	push   $0x805
  801336:	53                   	push   %ebx
  801337:	6a 00                	push   $0x0
  801339:	53                   	push   %ebx
  80133a:	6a 00                	push   $0x0
  80133c:	e8 99 fb ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801341:	83 c4 20             	add    $0x20,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	79 86                	jns    8012ce <duppage+0x63>
			panic("sys_page_map() panic\n");
  801348:	83 ec 04             	sub    $0x4,%esp
  80134b:	68 7d 37 80 00       	push   $0x80377d
  801350:	6a 60                	push   $0x60
  801352:	68 23 37 80 00       	push   $0x803723
  801357:	e8 f4 ee ff ff       	call   800250 <_panic>
			panic("sys_page_map() panic\n");
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	68 7d 37 80 00       	push   $0x80377d
  801364:	6a 5c                	push   $0x5c
  801366:	68 23 37 80 00       	push   $0x803723
  80136b:	e8 e0 ee ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801370:	c1 e3 0c             	shl    $0xc,%ebx
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	68 05 08 00 00       	push   $0x805
  80137b:	53                   	push   %ebx
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	6a 00                	push   $0x0
  801380:	e8 55 fb ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801385:	83 c4 20             	add    $0x20,%esp
  801388:	85 c0                	test   %eax,%eax
  80138a:	0f 89 3e ff ff ff    	jns    8012ce <duppage+0x63>
			panic("sys_page_map() panic\n");
  801390:	83 ec 04             	sub    $0x4,%esp
  801393:	68 7d 37 80 00       	push   $0x80377d
  801398:	6a 67                	push   $0x67
  80139a:	68 23 37 80 00       	push   $0x803723
  80139f:	e8 ac ee ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013a4:	c1 e3 0c             	shl    $0xc,%ebx
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	6a 05                	push   $0x5
  8013ac:	53                   	push   %ebx
  8013ad:	56                   	push   %esi
  8013ae:	53                   	push   %ebx
  8013af:	6a 00                	push   $0x0
  8013b1:	e8 24 fb ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8013b6:	83 c4 20             	add    $0x20,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	0f 89 0d ff ff ff    	jns    8012ce <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013c1:	83 ec 04             	sub    $0x4,%esp
  8013c4:	68 7d 37 80 00       	push   $0x80377d
  8013c9:	6a 6e                	push   $0x6e
  8013cb:	68 23 37 80 00       	push   $0x803723
  8013d0:	e8 7b ee ff ff       	call   800250 <_panic>

008013d5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	57                   	push   %edi
  8013d9:	56                   	push   %esi
  8013da:	53                   	push   %ebx
  8013db:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013de:	68 6c 11 80 00       	push   $0x80116c
  8013e3:	e8 40 1a 00 00       	call   802e28 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013e8:	b8 07 00 00 00       	mov    $0x7,%eax
  8013ed:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 27                	js     80141d <fork+0x48>
  8013f6:	89 c6                	mov    %eax,%esi
  8013f8:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013fa:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013ff:	75 48                	jne    801449 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801401:	e8 53 fa ff ff       	call   800e59 <sys_getenvid>
  801406:	25 ff 03 00 00       	and    $0x3ff,%eax
  80140b:	c1 e0 07             	shl    $0x7,%eax
  80140e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801413:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801418:	e9 90 00 00 00       	jmp    8014ad <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	68 94 37 80 00       	push   $0x803794
  801425:	68 8d 00 00 00       	push   $0x8d
  80142a:	68 23 37 80 00       	push   $0x803723
  80142f:	e8 1c ee ff ff       	call   800250 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801434:	89 f8                	mov    %edi,%eax
  801436:	e8 30 fe ff ff       	call   80126b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80143b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801441:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801447:	74 26                	je     80146f <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	c1 e8 16             	shr    $0x16,%eax
  80144e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801455:	a8 01                	test   $0x1,%al
  801457:	74 e2                	je     80143b <fork+0x66>
  801459:	89 da                	mov    %ebx,%edx
  80145b:	c1 ea 0c             	shr    $0xc,%edx
  80145e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801465:	83 e0 05             	and    $0x5,%eax
  801468:	83 f8 05             	cmp    $0x5,%eax
  80146b:	75 ce                	jne    80143b <fork+0x66>
  80146d:	eb c5                	jmp    801434 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	6a 07                	push   $0x7
  801474:	68 00 f0 bf ee       	push   $0xeebff000
  801479:	56                   	push   %esi
  80147a:	e8 18 fa ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	85 c0                	test   %eax,%eax
  801484:	78 31                	js     8014b7 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	68 97 2e 80 00       	push   $0x802e97
  80148e:	56                   	push   %esi
  80148f:	e8 4e fb ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 33                	js     8014ce <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80149b:	83 ec 08             	sub    $0x8,%esp
  80149e:	6a 02                	push   $0x2
  8014a0:	56                   	push   %esi
  8014a1:	e8 b8 fa ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 38                	js     8014e5 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014ad:	89 f0                	mov    %esi,%eax
  8014af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 2e 37 80 00       	push   $0x80372e
  8014bf:	68 99 00 00 00       	push   $0x99
  8014c4:	68 23 37 80 00       	push   $0x803723
  8014c9:	e8 82 ed ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 b8 37 80 00       	push   $0x8037b8
  8014d6:	68 9c 00 00 00       	push   $0x9c
  8014db:	68 23 37 80 00       	push   $0x803723
  8014e0:	e8 6b ed ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	68 e0 37 80 00       	push   $0x8037e0
  8014ed:	68 9f 00 00 00       	push   $0x9f
  8014f2:	68 23 37 80 00       	push   $0x803723
  8014f7:	e8 54 ed ff ff       	call   800250 <_panic>

008014fc <sfork>:

// Challenge!
int
sfork(void)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801505:	68 6c 11 80 00       	push   $0x80116c
  80150a:	e8 19 19 00 00       	call   802e28 <set_pgfault_handler>
  80150f:	b8 07 00 00 00       	mov    $0x7,%eax
  801514:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 27                	js     801544 <sfork+0x48>
  80151d:	89 c7                	mov    %eax,%edi
  80151f:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801521:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801526:	75 55                	jne    80157d <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801528:	e8 2c f9 ff ff       	call   800e59 <sys_getenvid>
  80152d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801532:	c1 e0 07             	shl    $0x7,%eax
  801535:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80153a:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80153f:	e9 d4 00 00 00       	jmp    801618 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	68 94 37 80 00       	push   $0x803794
  80154c:	68 b0 00 00 00       	push   $0xb0
  801551:	68 23 37 80 00       	push   $0x803723
  801556:	e8 f5 ec ff ff       	call   800250 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80155b:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801560:	89 f0                	mov    %esi,%eax
  801562:	e8 04 fd ff ff       	call   80126b <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801567:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80156d:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  801573:	77 65                	ja     8015da <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801575:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80157b:	74 de                	je     80155b <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  80157d:	89 d8                	mov    %ebx,%eax
  80157f:	c1 e8 16             	shr    $0x16,%eax
  801582:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801589:	a8 01                	test   $0x1,%al
  80158b:	74 da                	je     801567 <sfork+0x6b>
  80158d:	89 da                	mov    %ebx,%edx
  80158f:	c1 ea 0c             	shr    $0xc,%edx
  801592:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801599:	83 e0 05             	and    $0x5,%eax
  80159c:	83 f8 05             	cmp    $0x5,%eax
  80159f:	75 c6                	jne    801567 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015a1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015a8:	c1 e2 0c             	shl    $0xc,%edx
  8015ab:	83 ec 0c             	sub    $0xc,%esp
  8015ae:	83 e0 07             	and    $0x7,%eax
  8015b1:	50                   	push   %eax
  8015b2:	52                   	push   %edx
  8015b3:	56                   	push   %esi
  8015b4:	52                   	push   %edx
  8015b5:	6a 00                	push   $0x0
  8015b7:	e8 1e f9 ff ff       	call   800eda <sys_page_map>
  8015bc:	83 c4 20             	add    $0x20,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	74 a4                	je     801567 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	68 7d 37 80 00       	push   $0x80377d
  8015cb:	68 bb 00 00 00       	push   $0xbb
  8015d0:	68 23 37 80 00       	push   $0x803723
  8015d5:	e8 76 ec ff ff       	call   800250 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	6a 07                	push   $0x7
  8015df:	68 00 f0 bf ee       	push   $0xeebff000
  8015e4:	57                   	push   %edi
  8015e5:	e8 ad f8 ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	85 c0                	test   %eax,%eax
  8015ef:	78 31                	js     801622 <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015f1:	83 ec 08             	sub    $0x8,%esp
  8015f4:	68 97 2e 80 00       	push   $0x802e97
  8015f9:	57                   	push   %edi
  8015fa:	e8 e3 f9 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 33                	js     801639 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	6a 02                	push   $0x2
  80160b:	57                   	push   %edi
  80160c:	e8 4d f9 ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 38                	js     801650 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801618:	89 f8                	mov    %edi,%eax
  80161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5e                   	pop    %esi
  80161f:	5f                   	pop    %edi
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801622:	83 ec 04             	sub    $0x4,%esp
  801625:	68 2e 37 80 00       	push   $0x80372e
  80162a:	68 c1 00 00 00       	push   $0xc1
  80162f:	68 23 37 80 00       	push   $0x803723
  801634:	e8 17 ec ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	68 b8 37 80 00       	push   $0x8037b8
  801641:	68 c4 00 00 00       	push   $0xc4
  801646:	68 23 37 80 00       	push   $0x803723
  80164b:	e8 00 ec ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_status()\n");
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 e0 37 80 00       	push   $0x8037e0
  801658:	68 c7 00 00 00       	push   $0xc7
  80165d:	68 23 37 80 00       	push   $0x803723
  801662:	e8 e9 eb ff ff       	call   800250 <_panic>

00801667 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	05 00 00 00 30       	add    $0x30000000,%eax
  801672:	c1 e8 0c             	shr    $0xc,%eax
}
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801687:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801696:	89 c2                	mov    %eax,%edx
  801698:	c1 ea 16             	shr    $0x16,%edx
  80169b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a2:	f6 c2 01             	test   $0x1,%dl
  8016a5:	74 2d                	je     8016d4 <fd_alloc+0x46>
  8016a7:	89 c2                	mov    %eax,%edx
  8016a9:	c1 ea 0c             	shr    $0xc,%edx
  8016ac:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b3:	f6 c2 01             	test   $0x1,%dl
  8016b6:	74 1c                	je     8016d4 <fd_alloc+0x46>
  8016b8:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016bd:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016c2:	75 d2                	jne    801696 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016cd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016d2:	eb 0a                	jmp    8016de <fd_alloc+0x50>
			*fd_store = fd;
  8016d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016e6:	83 f8 1f             	cmp    $0x1f,%eax
  8016e9:	77 30                	ja     80171b <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016eb:	c1 e0 0c             	shl    $0xc,%eax
  8016ee:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016f3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016f9:	f6 c2 01             	test   $0x1,%dl
  8016fc:	74 24                	je     801722 <fd_lookup+0x42>
  8016fe:	89 c2                	mov    %eax,%edx
  801700:	c1 ea 0c             	shr    $0xc,%edx
  801703:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80170a:	f6 c2 01             	test   $0x1,%dl
  80170d:	74 1a                	je     801729 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80170f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801712:	89 02                	mov    %eax,(%edx)
	return 0;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    
		return -E_INVAL;
  80171b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801720:	eb f7                	jmp    801719 <fd_lookup+0x39>
		return -E_INVAL;
  801722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801727:	eb f0                	jmp    801719 <fd_lookup+0x39>
  801729:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172e:	eb e9                	jmp    801719 <fd_lookup+0x39>

00801730 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 08             	sub    $0x8,%esp
  801736:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801739:	ba 00 00 00 00       	mov    $0x0,%edx
  80173e:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801743:	39 08                	cmp    %ecx,(%eax)
  801745:	74 38                	je     80177f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801747:	83 c2 01             	add    $0x1,%edx
  80174a:	8b 04 95 84 38 80 00 	mov    0x803884(,%edx,4),%eax
  801751:	85 c0                	test   %eax,%eax
  801753:	75 ee                	jne    801743 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801755:	a1 08 50 80 00       	mov    0x805008,%eax
  80175a:	8b 40 48             	mov    0x48(%eax),%eax
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	51                   	push   %ecx
  801761:	50                   	push   %eax
  801762:	68 08 38 80 00       	push   $0x803808
  801767:	e8 da eb ff ff       	call   800346 <cprintf>
	*dev = 0;
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    
			*dev = devtab[i];
  80177f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801782:	89 01                	mov    %eax,(%ecx)
			return 0;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
  801789:	eb f2                	jmp    80177d <dev_lookup+0x4d>

0080178b <fd_close>:
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	57                   	push   %edi
  80178f:	56                   	push   %esi
  801790:	53                   	push   %ebx
  801791:	83 ec 24             	sub    $0x24,%esp
  801794:	8b 75 08             	mov    0x8(%ebp),%esi
  801797:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80179a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80179d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80179e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017a4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a7:	50                   	push   %eax
  8017a8:	e8 33 ff ff ff       	call   8016e0 <fd_lookup>
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 05                	js     8017bb <fd_close+0x30>
	    || fd != fd2)
  8017b6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017b9:	74 16                	je     8017d1 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017bb:	89 f8                	mov    %edi,%eax
  8017bd:	84 c0                	test   %al,%al
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	0f 44 d8             	cmove  %eax,%ebx
}
  8017c7:	89 d8                	mov    %ebx,%eax
  8017c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cc:	5b                   	pop    %ebx
  8017cd:	5e                   	pop    %esi
  8017ce:	5f                   	pop    %edi
  8017cf:	5d                   	pop    %ebp
  8017d0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	ff 36                	pushl  (%esi)
  8017da:	e8 51 ff ff ff       	call   801730 <dev_lookup>
  8017df:	89 c3                	mov    %eax,%ebx
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 1a                	js     801802 <fd_close+0x77>
		if (dev->dev_close)
  8017e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017ee:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 0b                	je     801802 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	56                   	push   %esi
  8017fb:	ff d0                	call   *%eax
  8017fd:	89 c3                	mov    %eax,%ebx
  8017ff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	56                   	push   %esi
  801806:	6a 00                	push   $0x0
  801808:	e8 0f f7 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb b5                	jmp    8017c7 <fd_close+0x3c>

00801812 <close>:

int
close(int fdnum)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801818:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181b:	50                   	push   %eax
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	e8 bc fe ff ff       	call   8016e0 <fd_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	79 02                	jns    80182d <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    
		return fd_close(fd, 1);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	6a 01                	push   $0x1
  801832:	ff 75 f4             	pushl  -0xc(%ebp)
  801835:	e8 51 ff ff ff       	call   80178b <fd_close>
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	eb ec                	jmp    80182b <close+0x19>

0080183f <close_all>:

void
close_all(void)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801846:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80184b:	83 ec 0c             	sub    $0xc,%esp
  80184e:	53                   	push   %ebx
  80184f:	e8 be ff ff ff       	call   801812 <close>
	for (i = 0; i < MAXFD; i++)
  801854:	83 c3 01             	add    $0x1,%ebx
  801857:	83 c4 10             	add    $0x10,%esp
  80185a:	83 fb 20             	cmp    $0x20,%ebx
  80185d:	75 ec                	jne    80184b <close_all+0xc>
}
  80185f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	57                   	push   %edi
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80186d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801870:	50                   	push   %eax
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 67 fe ff ff       	call   8016e0 <fd_lookup>
  801879:	89 c3                	mov    %eax,%ebx
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	85 c0                	test   %eax,%eax
  801880:	0f 88 81 00 00 00    	js     801907 <dup+0xa3>
		return r;
	close(newfdnum);
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	e8 81 ff ff ff       	call   801812 <close>

	newfd = INDEX2FD(newfdnum);
  801891:	8b 75 0c             	mov    0xc(%ebp),%esi
  801894:	c1 e6 0c             	shl    $0xc,%esi
  801897:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80189d:	83 c4 04             	add    $0x4,%esp
  8018a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a3:	e8 cf fd ff ff       	call   801677 <fd2data>
  8018a8:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018aa:	89 34 24             	mov    %esi,(%esp)
  8018ad:	e8 c5 fd ff ff       	call   801677 <fd2data>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	c1 e8 16             	shr    $0x16,%eax
  8018bc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018c3:	a8 01                	test   $0x1,%al
  8018c5:	74 11                	je     8018d8 <dup+0x74>
  8018c7:	89 d8                	mov    %ebx,%eax
  8018c9:	c1 e8 0c             	shr    $0xc,%eax
  8018cc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018d3:	f6 c2 01             	test   $0x1,%dl
  8018d6:	75 39                	jne    801911 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018db:	89 d0                	mov    %edx,%eax
  8018dd:	c1 e8 0c             	shr    $0xc,%eax
  8018e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018e7:	83 ec 0c             	sub    $0xc,%esp
  8018ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ef:	50                   	push   %eax
  8018f0:	56                   	push   %esi
  8018f1:	6a 00                	push   $0x0
  8018f3:	52                   	push   %edx
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 df f5 ff ff       	call   800eda <sys_page_map>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	83 c4 20             	add    $0x20,%esp
  801900:	85 c0                	test   %eax,%eax
  801902:	78 31                	js     801935 <dup+0xd1>
		goto err;

	return newfdnum;
  801904:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801907:	89 d8                	mov    %ebx,%eax
  801909:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5f                   	pop    %edi
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801911:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	25 07 0e 00 00       	and    $0xe07,%eax
  801920:	50                   	push   %eax
  801921:	57                   	push   %edi
  801922:	6a 00                	push   $0x0
  801924:	53                   	push   %ebx
  801925:	6a 00                	push   $0x0
  801927:	e8 ae f5 ff ff       	call   800eda <sys_page_map>
  80192c:	89 c3                	mov    %eax,%ebx
  80192e:	83 c4 20             	add    $0x20,%esp
  801931:	85 c0                	test   %eax,%eax
  801933:	79 a3                	jns    8018d8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	56                   	push   %esi
  801939:	6a 00                	push   $0x0
  80193b:	e8 dc f5 ff ff       	call   800f1c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801940:	83 c4 08             	add    $0x8,%esp
  801943:	57                   	push   %edi
  801944:	6a 00                	push   $0x0
  801946:	e8 d1 f5 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	eb b7                	jmp    801907 <dup+0xa3>

00801950 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	53                   	push   %ebx
  801954:	83 ec 1c             	sub    $0x1c,%esp
  801957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80195d:	50                   	push   %eax
  80195e:	53                   	push   %ebx
  80195f:	e8 7c fd ff ff       	call   8016e0 <fd_lookup>
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 3f                	js     8019aa <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80196b:	83 ec 08             	sub    $0x8,%esp
  80196e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801971:	50                   	push   %eax
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	ff 30                	pushl  (%eax)
  801977:	e8 b4 fd ff ff       	call   801730 <dev_lookup>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	78 27                	js     8019aa <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801983:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801986:	8b 42 08             	mov    0x8(%edx),%eax
  801989:	83 e0 03             	and    $0x3,%eax
  80198c:	83 f8 01             	cmp    $0x1,%eax
  80198f:	74 1e                	je     8019af <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 40 08             	mov    0x8(%eax),%eax
  801997:	85 c0                	test   %eax,%eax
  801999:	74 35                	je     8019d0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	ff 75 10             	pushl  0x10(%ebp)
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	52                   	push   %edx
  8019a5:	ff d0                	call   *%eax
  8019a7:	83 c4 10             	add    $0x10,%esp
}
  8019aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019af:	a1 08 50 80 00       	mov    0x805008,%eax
  8019b4:	8b 40 48             	mov    0x48(%eax),%eax
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	53                   	push   %ebx
  8019bb:	50                   	push   %eax
  8019bc:	68 49 38 80 00       	push   $0x803849
  8019c1:	e8 80 e9 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ce:	eb da                	jmp    8019aa <read+0x5a>
		return -E_NOT_SUPP;
  8019d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d5:	eb d3                	jmp    8019aa <read+0x5a>

008019d7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	57                   	push   %edi
  8019db:	56                   	push   %esi
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019eb:	39 f3                	cmp    %esi,%ebx
  8019ed:	73 23                	jae    801a12 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	89 f0                	mov    %esi,%eax
  8019f4:	29 d8                	sub    %ebx,%eax
  8019f6:	50                   	push   %eax
  8019f7:	89 d8                	mov    %ebx,%eax
  8019f9:	03 45 0c             	add    0xc(%ebp),%eax
  8019fc:	50                   	push   %eax
  8019fd:	57                   	push   %edi
  8019fe:	e8 4d ff ff ff       	call   801950 <read>
		if (m < 0)
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 06                	js     801a10 <readn+0x39>
			return m;
		if (m == 0)
  801a0a:	74 06                	je     801a12 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a0c:	01 c3                	add    %eax,%ebx
  801a0e:	eb db                	jmp    8019eb <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a10:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a12:	89 d8                	mov    %ebx,%eax
  801a14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    

00801a1c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	53                   	push   %ebx
  801a20:	83 ec 1c             	sub    $0x1c,%esp
  801a23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a26:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a29:	50                   	push   %eax
  801a2a:	53                   	push   %ebx
  801a2b:	e8 b0 fc ff ff       	call   8016e0 <fd_lookup>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 3a                	js     801a71 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3d:	50                   	push   %eax
  801a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a41:	ff 30                	pushl  (%eax)
  801a43:	e8 e8 fc ff ff       	call   801730 <dev_lookup>
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 22                	js     801a71 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a56:	74 1e                	je     801a76 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a5b:	8b 52 0c             	mov    0xc(%edx),%edx
  801a5e:	85 d2                	test   %edx,%edx
  801a60:	74 35                	je     801a97 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	50                   	push   %eax
  801a6c:	ff d2                	call   *%edx
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a76:	a1 08 50 80 00       	mov    0x805008,%eax
  801a7b:	8b 40 48             	mov    0x48(%eax),%eax
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	53                   	push   %ebx
  801a82:	50                   	push   %eax
  801a83:	68 65 38 80 00       	push   $0x803865
  801a88:	e8 b9 e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a95:	eb da                	jmp    801a71 <write+0x55>
		return -E_NOT_SUPP;
  801a97:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a9c:	eb d3                	jmp    801a71 <write+0x55>

00801a9e <seek>:

int
seek(int fdnum, off_t offset)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	e8 30 fc ff ff       	call   8016e0 <fd_lookup>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 0e                	js     801ac5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	53                   	push   %ebx
  801acb:	83 ec 1c             	sub    $0x1c,%esp
  801ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	53                   	push   %ebx
  801ad6:	e8 05 fc ff ff       	call   8016e0 <fd_lookup>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 37                	js     801b19 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae8:	50                   	push   %eax
  801ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aec:	ff 30                	pushl  (%eax)
  801aee:	e8 3d fc ff ff       	call   801730 <dev_lookup>
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1f                	js     801b19 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b01:	74 1b                	je     801b1e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b06:	8b 52 18             	mov    0x18(%edx),%edx
  801b09:	85 d2                	test   %edx,%edx
  801b0b:	74 32                	je     801b3f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	ff d2                	call   *%edx
  801b16:	83 c4 10             	add    $0x10,%esp
}
  801b19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b1e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b23:	8b 40 48             	mov    0x48(%eax),%eax
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	53                   	push   %ebx
  801b2a:	50                   	push   %eax
  801b2b:	68 28 38 80 00       	push   $0x803828
  801b30:	e8 11 e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b3d:	eb da                	jmp    801b19 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b44:	eb d3                	jmp    801b19 <ftruncate+0x52>

00801b46 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 1c             	sub    $0x1c,%esp
  801b4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b53:	50                   	push   %eax
  801b54:	ff 75 08             	pushl  0x8(%ebp)
  801b57:	e8 84 fb ff ff       	call   8016e0 <fd_lookup>
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 4b                	js     801bae <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b69:	50                   	push   %eax
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	ff 30                	pushl  (%eax)
  801b6f:	e8 bc fb ff ff       	call   801730 <dev_lookup>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 33                	js     801bae <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b82:	74 2f                	je     801bb3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b84:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b87:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b8e:	00 00 00 
	stat->st_isdir = 0;
  801b91:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b98:	00 00 00 
	stat->st_dev = dev;
  801b9b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	53                   	push   %ebx
  801ba5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba8:	ff 50 14             	call   *0x14(%eax)
  801bab:	83 c4 10             	add    $0x10,%esp
}
  801bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    
		return -E_NOT_SUPP;
  801bb3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bb8:	eb f4                	jmp    801bae <fstat+0x68>

00801bba <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	6a 00                	push   $0x0
  801bc4:	ff 75 08             	pushl  0x8(%ebp)
  801bc7:	e8 22 02 00 00       	call   801dee <open>
  801bcc:	89 c3                	mov    %eax,%ebx
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 1b                	js     801bf0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bd5:	83 ec 08             	sub    $0x8,%esp
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	50                   	push   %eax
  801bdc:	e8 65 ff ff ff       	call   801b46 <fstat>
  801be1:	89 c6                	mov    %eax,%esi
	close(fd);
  801be3:	89 1c 24             	mov    %ebx,(%esp)
  801be6:	e8 27 fc ff ff       	call   801812 <close>
	return r;
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	89 f3                	mov    %esi,%ebx
}
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	89 c6                	mov    %eax,%esi
  801c00:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c02:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c09:	74 27                	je     801c32 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c0b:	6a 07                	push   $0x7
  801c0d:	68 00 60 80 00       	push   $0x806000
  801c12:	56                   	push   %esi
  801c13:	ff 35 00 50 80 00    	pushl  0x805000
  801c19:	e8 08 13 00 00       	call   802f26 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c1e:	83 c4 0c             	add    $0xc,%esp
  801c21:	6a 00                	push   $0x0
  801c23:	53                   	push   %ebx
  801c24:	6a 00                	push   $0x0
  801c26:	e8 92 12 00 00       	call   802ebd <ipc_recv>
}
  801c2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	6a 01                	push   $0x1
  801c37:	e8 42 13 00 00       	call   802f7e <ipc_find_env>
  801c3c:	a3 00 50 80 00       	mov    %eax,0x805000
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	eb c5                	jmp    801c0b <fsipc+0x12>

00801c46 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c52:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c64:	b8 02 00 00 00       	mov    $0x2,%eax
  801c69:	e8 8b ff ff ff       	call   801bf9 <fsipc>
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <devfile_flush>:
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c81:	ba 00 00 00 00       	mov    $0x0,%edx
  801c86:	b8 06 00 00 00       	mov    $0x6,%eax
  801c8b:	e8 69 ff ff ff       	call   801bf9 <fsipc>
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <devfile_stat>:
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	53                   	push   %ebx
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cac:	b8 05 00 00 00       	mov    $0x5,%eax
  801cb1:	e8 43 ff ff ff       	call   801bf9 <fsipc>
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	78 2c                	js     801ce6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	68 00 60 80 00       	push   $0x806000
  801cc2:	53                   	push   %ebx
  801cc3:	e8 dd ed ff ff       	call   800aa5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cc8:	a1 80 60 80 00       	mov    0x806080,%eax
  801ccd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cd3:	a1 84 60 80 00       	mov    0x806084,%eax
  801cd8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <devfile_write>:
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	53                   	push   %ebx
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d00:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d06:	53                   	push   %ebx
  801d07:	ff 75 0c             	pushl  0xc(%ebp)
  801d0a:	68 08 60 80 00       	push   $0x806008
  801d0f:	e8 81 ef ff ff       	call   800c95 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d14:	ba 00 00 00 00       	mov    $0x0,%edx
  801d19:	b8 04 00 00 00       	mov    $0x4,%eax
  801d1e:	e8 d6 fe ff ff       	call   801bf9 <fsipc>
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 0b                	js     801d35 <devfile_write+0x4a>
	assert(r <= n);
  801d2a:	39 d8                	cmp    %ebx,%eax
  801d2c:	77 0c                	ja     801d3a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d2e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d33:	7f 1e                	jg     801d53 <devfile_write+0x68>
}
  801d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    
	assert(r <= n);
  801d3a:	68 98 38 80 00       	push   $0x803898
  801d3f:	68 9f 38 80 00       	push   $0x80389f
  801d44:	68 98 00 00 00       	push   $0x98
  801d49:	68 b4 38 80 00       	push   $0x8038b4
  801d4e:	e8 fd e4 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801d53:	68 bf 38 80 00       	push   $0x8038bf
  801d58:	68 9f 38 80 00       	push   $0x80389f
  801d5d:	68 99 00 00 00       	push   $0x99
  801d62:	68 b4 38 80 00       	push   $0x8038b4
  801d67:	e8 e4 e4 ff ff       	call   800250 <_panic>

00801d6c <devfile_read>:
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	56                   	push   %esi
  801d70:	53                   	push   %ebx
  801d71:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d7f:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d85:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d8f:	e8 65 fe ff ff       	call   801bf9 <fsipc>
  801d94:	89 c3                	mov    %eax,%ebx
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 1f                	js     801db9 <devfile_read+0x4d>
	assert(r <= n);
  801d9a:	39 f0                	cmp    %esi,%eax
  801d9c:	77 24                	ja     801dc2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d9e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da3:	7f 33                	jg     801dd8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	50                   	push   %eax
  801da9:	68 00 60 80 00       	push   $0x806000
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	e8 7d ee ff ff       	call   800c33 <memmove>
	return r;
  801db6:	83 c4 10             	add    $0x10,%esp
}
  801db9:	89 d8                	mov    %ebx,%eax
  801dbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dbe:	5b                   	pop    %ebx
  801dbf:	5e                   	pop    %esi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    
	assert(r <= n);
  801dc2:	68 98 38 80 00       	push   $0x803898
  801dc7:	68 9f 38 80 00       	push   $0x80389f
  801dcc:	6a 7c                	push   $0x7c
  801dce:	68 b4 38 80 00       	push   $0x8038b4
  801dd3:	e8 78 e4 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801dd8:	68 bf 38 80 00       	push   $0x8038bf
  801ddd:	68 9f 38 80 00       	push   $0x80389f
  801de2:	6a 7d                	push   $0x7d
  801de4:	68 b4 38 80 00       	push   $0x8038b4
  801de9:	e8 62 e4 ff ff       	call   800250 <_panic>

00801dee <open>:
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 1c             	sub    $0x1c,%esp
  801df6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801df9:	56                   	push   %esi
  801dfa:	e8 6d ec ff ff       	call   800a6c <strlen>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e07:	7f 6c                	jg     801e75 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0f:	50                   	push   %eax
  801e10:	e8 79 f8 ff ff       	call   80168e <fd_alloc>
  801e15:	89 c3                	mov    %eax,%ebx
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 3c                	js     801e5a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	56                   	push   %esi
  801e22:	68 00 60 80 00       	push   $0x806000
  801e27:	e8 79 ec ff ff       	call   800aa5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e37:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3c:	e8 b8 fd ff ff       	call   801bf9 <fsipc>
  801e41:	89 c3                	mov    %eax,%ebx
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	85 c0                	test   %eax,%eax
  801e48:	78 19                	js     801e63 <open+0x75>
	return fd2num(fd);
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e50:	e8 12 f8 ff ff       	call   801667 <fd2num>
  801e55:	89 c3                	mov    %eax,%ebx
  801e57:	83 c4 10             	add    $0x10,%esp
}
  801e5a:	89 d8                	mov    %ebx,%eax
  801e5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    
		fd_close(fd, 0);
  801e63:	83 ec 08             	sub    $0x8,%esp
  801e66:	6a 00                	push   $0x0
  801e68:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6b:	e8 1b f9 ff ff       	call   80178b <fd_close>
		return r;
  801e70:	83 c4 10             	add    $0x10,%esp
  801e73:	eb e5                	jmp    801e5a <open+0x6c>
		return -E_BAD_PATH;
  801e75:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e7a:	eb de                	jmp    801e5a <open+0x6c>

00801e7c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e82:	ba 00 00 00 00       	mov    $0x0,%edx
  801e87:	b8 08 00 00 00       	mov    $0x8,%eax
  801e8c:	e8 68 fd ff ff       	call   801bf9 <fsipc>
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e9f:	68 a4 39 80 00       	push   $0x8039a4
  801ea4:	68 28 33 80 00       	push   $0x803328
  801ea9:	e8 98 e4 ff ff       	call   800346 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801eae:	83 c4 08             	add    $0x8,%esp
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	e8 33 ff ff ff       	call   801dee <open>
  801ebb:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	0f 88 0a 05 00 00    	js     8023d6 <spawn+0x543>
  801ecc:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	68 00 02 00 00       	push   $0x200
  801ed6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801edc:	50                   	push   %eax
  801edd:	51                   	push   %ecx
  801ede:	e8 f4 fa ff ff       	call   8019d7 <readn>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	3d 00 02 00 00       	cmp    $0x200,%eax
  801eeb:	75 74                	jne    801f61 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801eed:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ef4:	45 4c 46 
  801ef7:	75 68                	jne    801f61 <spawn+0xce>
  801ef9:	b8 07 00 00 00       	mov    $0x7,%eax
  801efe:	cd 30                	int    $0x30
  801f00:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801f06:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	0f 88 b6 04 00 00    	js     8023ca <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f14:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f19:	89 c6                	mov    %eax,%esi
  801f1b:	c1 e6 07             	shl    $0x7,%esi
  801f1e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f24:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f2a:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f31:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f37:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	68 98 39 80 00       	push   $0x803998
  801f45:	68 28 33 80 00       	push   $0x803328
  801f4a:	e8 f7 e3 ff ff       	call   800346 <cprintf>
  801f4f:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f52:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801f57:	be 00 00 00 00       	mov    $0x0,%esi
  801f5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f5f:	eb 4b                	jmp    801fac <spawn+0x119>
		close(fd);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f6a:	e8 a3 f8 ff ff       	call   801812 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f6f:	83 c4 0c             	add    $0xc,%esp
  801f72:	68 7f 45 4c 46       	push   $0x464c457f
  801f77:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f7d:	68 cb 38 80 00       	push   $0x8038cb
  801f82:	e8 bf e3 ff ff       	call   800346 <cprintf>
		return -E_NOT_EXEC;
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f91:	ff ff ff 
  801f94:	e9 3d 04 00 00       	jmp    8023d6 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	50                   	push   %eax
  801f9d:	e8 ca ea ff ff       	call   800a6c <strlen>
  801fa2:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801fa6:	83 c3 01             	add    $0x1,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801fb3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 df                	jne    801f99 <spawn+0x106>
  801fba:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801fc0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801fc6:	bf 00 10 40 00       	mov    $0x401000,%edi
  801fcb:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801fcd:	89 fa                	mov    %edi,%edx
  801fcf:	83 e2 fc             	and    $0xfffffffc,%edx
  801fd2:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801fd9:	29 c2                	sub    %eax,%edx
  801fdb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801fe1:	8d 42 f8             	lea    -0x8(%edx),%eax
  801fe4:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801fe9:	0f 86 0a 04 00 00    	jbe    8023f9 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	6a 07                	push   $0x7
  801ff4:	68 00 00 40 00       	push   $0x400000
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 97 ee ff ff       	call   800e97 <sys_page_alloc>
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	0f 88 f3 03 00 00    	js     8023fe <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80200b:	be 00 00 00 00       	mov    $0x0,%esi
  802010:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802016:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802019:	eb 30                	jmp    80204b <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  80201b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802021:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802027:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80202a:	83 ec 08             	sub    $0x8,%esp
  80202d:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802030:	57                   	push   %edi
  802031:	e8 6f ea ff ff       	call   800aa5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802036:	83 c4 04             	add    $0x4,%esp
  802039:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80203c:	e8 2b ea ff ff       	call   800a6c <strlen>
  802041:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802045:	83 c6 01             	add    $0x1,%esi
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802051:	7f c8                	jg     80201b <spawn+0x188>
	}
	argv_store[argc] = 0;
  802053:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802059:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80205f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802066:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80206c:	0f 85 86 00 00 00    	jne    8020f8 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802072:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802078:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  80207e:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802081:	89 d0                	mov    %edx,%eax
  802083:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802089:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80208c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802091:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	6a 07                	push   $0x7
  80209c:	68 00 d0 bf ee       	push   $0xeebfd000
  8020a1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020a7:	68 00 00 40 00       	push   $0x400000
  8020ac:	6a 00                	push   $0x0
  8020ae:	e8 27 ee ff ff       	call   800eda <sys_page_map>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	83 c4 20             	add    $0x20,%esp
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 46 03 00 00    	js     802406 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8020c0:	83 ec 08             	sub    $0x8,%esp
  8020c3:	68 00 00 40 00       	push   $0x400000
  8020c8:	6a 00                	push   $0x0
  8020ca:	e8 4d ee ff ff       	call   800f1c <sys_page_unmap>
  8020cf:	89 c3                	mov    %eax,%ebx
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	0f 88 2a 03 00 00    	js     802406 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8020dc:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8020e2:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020e9:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8020f0:	00 00 00 
  8020f3:	e9 4f 01 00 00       	jmp    802247 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020f8:	68 54 39 80 00       	push   $0x803954
  8020fd:	68 9f 38 80 00       	push   $0x80389f
  802102:	68 f8 00 00 00       	push   $0xf8
  802107:	68 e5 38 80 00       	push   $0x8038e5
  80210c:	e8 3f e1 ff ff       	call   800250 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	6a 07                	push   $0x7
  802116:	68 00 00 40 00       	push   $0x400000
  80211b:	6a 00                	push   $0x0
  80211d:	e8 75 ed ff ff       	call   800e97 <sys_page_alloc>
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 88 b7 02 00 00    	js     8023e4 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  80212d:	83 ec 08             	sub    $0x8,%esp
  802130:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802136:	01 f0                	add    %esi,%eax
  802138:	50                   	push   %eax
  802139:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80213f:	e8 5a f9 ff ff       	call   801a9e <seek>
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	85 c0                	test   %eax,%eax
  802149:	0f 88 9c 02 00 00    	js     8023eb <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802158:	29 f0                	sub    %esi,%eax
  80215a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80215f:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802164:	0f 47 c1             	cmova  %ecx,%eax
  802167:	50                   	push   %eax
  802168:	68 00 00 40 00       	push   $0x400000
  80216d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802173:	e8 5f f8 ff ff       	call   8019d7 <readn>
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	85 c0                	test   %eax,%eax
  80217d:	0f 88 6f 02 00 00    	js     8023f2 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80218c:	53                   	push   %ebx
  80218d:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802193:	68 00 00 40 00       	push   $0x400000
  802198:	6a 00                	push   $0x0
  80219a:	e8 3b ed ff ff       	call   800eda <sys_page_map>
  80219f:	83 c4 20             	add    $0x20,%esp
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	78 7c                	js     802222 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8021a6:	83 ec 08             	sub    $0x8,%esp
  8021a9:	68 00 00 40 00       	push   $0x400000
  8021ae:	6a 00                	push   $0x0
  8021b0:	e8 67 ed ff ff       	call   800f1c <sys_page_unmap>
  8021b5:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8021b8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8021be:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8021c4:	89 fe                	mov    %edi,%esi
  8021c6:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8021cc:	76 69                	jbe    802237 <spawn+0x3a4>
		if (i >= filesz) {
  8021ce:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8021d4:	0f 87 37 ff ff ff    	ja     802111 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8021da:	83 ec 04             	sub    $0x4,%esp
  8021dd:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021e3:	53                   	push   %ebx
  8021e4:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021ea:	e8 a8 ec ff ff       	call   800e97 <sys_page_alloc>
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	79 c2                	jns    8021b8 <spawn+0x325>
  8021f6:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8021f8:	83 ec 0c             	sub    $0xc,%esp
  8021fb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802201:	e8 12 ec ff ff       	call   800e18 <sys_env_destroy>
	close(fd);
  802206:	83 c4 04             	add    $0x4,%esp
  802209:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80220f:	e8 fe f5 ff ff       	call   801812 <close>
	return r;
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  80221d:	e9 b4 01 00 00       	jmp    8023d6 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  802222:	50                   	push   %eax
  802223:	68 f1 38 80 00       	push   $0x8038f1
  802228:	68 2b 01 00 00       	push   $0x12b
  80222d:	68 e5 38 80 00       	push   $0x8038e5
  802232:	e8 19 e0 ff ff       	call   800250 <_panic>
  802237:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80223d:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802244:	83 c6 20             	add    $0x20,%esi
  802247:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80224e:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802254:	7e 6d                	jle    8022c3 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802256:	83 3e 01             	cmpl   $0x1,(%esi)
  802259:	75 e2                	jne    80223d <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80225b:	8b 46 18             	mov    0x18(%esi),%eax
  80225e:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802261:	83 f8 01             	cmp    $0x1,%eax
  802264:	19 c0                	sbb    %eax,%eax
  802266:	83 e0 fe             	and    $0xfffffffe,%eax
  802269:	83 c0 07             	add    $0x7,%eax
  80226c:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802272:	8b 4e 04             	mov    0x4(%esi),%ecx
  802275:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80227b:	8b 56 10             	mov    0x10(%esi),%edx
  80227e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802284:	8b 7e 14             	mov    0x14(%esi),%edi
  802287:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  80228d:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802290:	89 d8                	mov    %ebx,%eax
  802292:	25 ff 0f 00 00       	and    $0xfff,%eax
  802297:	74 1a                	je     8022b3 <spawn+0x420>
		va -= i;
  802299:	29 c3                	sub    %eax,%ebx
		memsz += i;
  80229b:	01 c7                	add    %eax,%edi
  80229d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  8022a3:	01 c2                	add    %eax,%edx
  8022a5:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  8022ab:	29 c1                	sub    %eax,%ecx
  8022ad:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  8022b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b8:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8022be:	e9 01 ff ff ff       	jmp    8021c4 <spawn+0x331>
	close(fd);
  8022c3:	83 ec 0c             	sub    $0xc,%esp
  8022c6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022cc:	e8 41 f5 ff ff       	call   801812 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  8022d1:	83 c4 08             	add    $0x8,%esp
  8022d4:	68 84 39 80 00       	push   $0x803984
  8022d9:	68 28 33 80 00       	push   $0x803328
  8022de:	e8 63 e0 ff ff       	call   800346 <cprintf>
  8022e3:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8022e6:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8022eb:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8022f1:	eb 0e                	jmp    802301 <spawn+0x46e>
  8022f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022f9:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8022ff:	74 5e                	je     80235f <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  802301:	89 d8                	mov    %ebx,%eax
  802303:	c1 e8 16             	shr    $0x16,%eax
  802306:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80230d:	a8 01                	test   $0x1,%al
  80230f:	74 e2                	je     8022f3 <spawn+0x460>
  802311:	89 da                	mov    %ebx,%edx
  802313:	c1 ea 0c             	shr    $0xc,%edx
  802316:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80231d:	25 05 04 00 00       	and    $0x405,%eax
  802322:	3d 05 04 00 00       	cmp    $0x405,%eax
  802327:	75 ca                	jne    8022f3 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802329:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	25 07 0e 00 00       	and    $0xe07,%eax
  802338:	50                   	push   %eax
  802339:	53                   	push   %ebx
  80233a:	56                   	push   %esi
  80233b:	53                   	push   %ebx
  80233c:	6a 00                	push   $0x0
  80233e:	e8 97 eb ff ff       	call   800eda <sys_page_map>
  802343:	83 c4 20             	add    $0x20,%esp
  802346:	85 c0                	test   %eax,%eax
  802348:	79 a9                	jns    8022f3 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  80234a:	50                   	push   %eax
  80234b:	68 0e 39 80 00       	push   $0x80390e
  802350:	68 3b 01 00 00       	push   $0x13b
  802355:	68 e5 38 80 00       	push   $0x8038e5
  80235a:	e8 f1 de ff ff       	call   800250 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80235f:	83 ec 08             	sub    $0x8,%esp
  802362:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802368:	50                   	push   %eax
  802369:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80236f:	e8 2c ec ff ff       	call   800fa0 <sys_env_set_trapframe>
  802374:	83 c4 10             	add    $0x10,%esp
  802377:	85 c0                	test   %eax,%eax
  802379:	78 25                	js     8023a0 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80237b:	83 ec 08             	sub    $0x8,%esp
  80237e:	6a 02                	push   $0x2
  802380:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802386:	e8 d3 eb ff ff       	call   800f5e <sys_env_set_status>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 23                	js     8023b5 <spawn+0x522>
	return child;
  802392:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802398:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80239e:	eb 36                	jmp    8023d6 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  8023a0:	50                   	push   %eax
  8023a1:	68 20 39 80 00       	push   $0x803920
  8023a6:	68 8a 00 00 00       	push   $0x8a
  8023ab:	68 e5 38 80 00       	push   $0x8038e5
  8023b0:	e8 9b de ff ff       	call   800250 <_panic>
		panic("sys_env_set_status: %e", r);
  8023b5:	50                   	push   %eax
  8023b6:	68 3a 39 80 00       	push   $0x80393a
  8023bb:	68 8d 00 00 00       	push   $0x8d
  8023c0:	68 e5 38 80 00       	push   $0x8038e5
  8023c5:	e8 86 de ff ff       	call   800250 <_panic>
		return r;
  8023ca:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023d0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8023d6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    
  8023e4:	89 c7                	mov    %eax,%edi
  8023e6:	e9 0d fe ff ff       	jmp    8021f8 <spawn+0x365>
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	e9 06 fe ff ff       	jmp    8021f8 <spawn+0x365>
  8023f2:	89 c7                	mov    %eax,%edi
  8023f4:	e9 ff fd ff ff       	jmp    8021f8 <spawn+0x365>
		return -E_NO_MEM;
  8023f9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8023fe:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802404:	eb d0                	jmp    8023d6 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  802406:	83 ec 08             	sub    $0x8,%esp
  802409:	68 00 00 40 00       	push   $0x400000
  80240e:	6a 00                	push   $0x0
  802410:	e8 07 eb ff ff       	call   800f1c <sys_page_unmap>
  802415:	83 c4 10             	add    $0x10,%esp
  802418:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80241e:	eb b6                	jmp    8023d6 <spawn+0x543>

00802420 <spawnl>:
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	57                   	push   %edi
  802424:	56                   	push   %esi
  802425:	53                   	push   %ebx
  802426:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802429:	68 7c 39 80 00       	push   $0x80397c
  80242e:	68 28 33 80 00       	push   $0x803328
  802433:	e8 0e df ff ff       	call   800346 <cprintf>
	va_start(vl, arg0);
  802438:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  80243b:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802443:	8d 4a 04             	lea    0x4(%edx),%ecx
  802446:	83 3a 00             	cmpl   $0x0,(%edx)
  802449:	74 07                	je     802452 <spawnl+0x32>
		argc++;
  80244b:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80244e:	89 ca                	mov    %ecx,%edx
  802450:	eb f1                	jmp    802443 <spawnl+0x23>
	const char *argv[argc+2];
  802452:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802459:	83 e2 f0             	and    $0xfffffff0,%edx
  80245c:	29 d4                	sub    %edx,%esp
  80245e:	8d 54 24 03          	lea    0x3(%esp),%edx
  802462:	c1 ea 02             	shr    $0x2,%edx
  802465:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  80246c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80246e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802471:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802478:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80247f:	00 
	va_start(vl, arg0);
  802480:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802483:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802485:	b8 00 00 00 00       	mov    $0x0,%eax
  80248a:	eb 0b                	jmp    802497 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  80248c:	83 c0 01             	add    $0x1,%eax
  80248f:	8b 39                	mov    (%ecx),%edi
  802491:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802494:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802497:	39 d0                	cmp    %edx,%eax
  802499:	75 f1                	jne    80248c <spawnl+0x6c>
	return spawn(prog, argv);
  80249b:	83 ec 08             	sub    $0x8,%esp
  80249e:	56                   	push   %esi
  80249f:	ff 75 08             	pushl  0x8(%ebp)
  8024a2:	e8 ec f9 ff ff       	call   801e93 <spawn>
}
  8024a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024aa:	5b                   	pop    %ebx
  8024ab:	5e                   	pop    %esi
  8024ac:	5f                   	pop    %edi
  8024ad:	5d                   	pop    %ebp
  8024ae:	c3                   	ret    

008024af <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8024b5:	68 aa 39 80 00       	push   $0x8039aa
  8024ba:	ff 75 0c             	pushl  0xc(%ebp)
  8024bd:	e8 e3 e5 ff ff       	call   800aa5 <strcpy>
	return 0;
}
  8024c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <devsock_close>:
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	53                   	push   %ebx
  8024cd:	83 ec 10             	sub    $0x10,%esp
  8024d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8024d3:	53                   	push   %ebx
  8024d4:	e8 e0 0a 00 00       	call   802fb9 <pageref>
  8024d9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8024dc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8024e1:	83 f8 01             	cmp    $0x1,%eax
  8024e4:	74 07                	je     8024ed <devsock_close+0x24>
}
  8024e6:	89 d0                	mov    %edx,%eax
  8024e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	ff 73 0c             	pushl  0xc(%ebx)
  8024f3:	e8 b9 02 00 00       	call   8027b1 <nsipc_close>
  8024f8:	89 c2                	mov    %eax,%edx
  8024fa:	83 c4 10             	add    $0x10,%esp
  8024fd:	eb e7                	jmp    8024e6 <devsock_close+0x1d>

008024ff <devsock_write>:
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802505:	6a 00                	push   $0x0
  802507:	ff 75 10             	pushl  0x10(%ebp)
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	ff 70 0c             	pushl  0xc(%eax)
  802513:	e8 76 03 00 00       	call   80288e <nsipc_send>
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <devsock_read>:
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802520:	6a 00                	push   $0x0
  802522:	ff 75 10             	pushl  0x10(%ebp)
  802525:	ff 75 0c             	pushl  0xc(%ebp)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	ff 70 0c             	pushl  0xc(%eax)
  80252e:	e8 ef 02 00 00       	call   802822 <nsipc_recv>
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <fd2sockid>:
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80253b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80253e:	52                   	push   %edx
  80253f:	50                   	push   %eax
  802540:	e8 9b f1 ff ff       	call   8016e0 <fd_lookup>
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	85 c0                	test   %eax,%eax
  80254a:	78 10                	js     80255c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802555:	39 08                	cmp    %ecx,(%eax)
  802557:	75 05                	jne    80255e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    
		return -E_NOT_SUPP;
  80255e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802563:	eb f7                	jmp    80255c <fd2sockid+0x27>

00802565 <alloc_sockfd>:
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	56                   	push   %esi
  802569:	53                   	push   %ebx
  80256a:	83 ec 1c             	sub    $0x1c,%esp
  80256d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80256f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802572:	50                   	push   %eax
  802573:	e8 16 f1 ff ff       	call   80168e <fd_alloc>
  802578:	89 c3                	mov    %eax,%ebx
  80257a:	83 c4 10             	add    $0x10,%esp
  80257d:	85 c0                	test   %eax,%eax
  80257f:	78 43                	js     8025c4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	68 07 04 00 00       	push   $0x407
  802589:	ff 75 f4             	pushl  -0xc(%ebp)
  80258c:	6a 00                	push   $0x0
  80258e:	e8 04 e9 ff ff       	call   800e97 <sys_page_alloc>
  802593:	89 c3                	mov    %eax,%ebx
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	85 c0                	test   %eax,%eax
  80259a:	78 28                	js     8025c4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8025a5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8025b1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	50                   	push   %eax
  8025b8:	e8 aa f0 ff ff       	call   801667 <fd2num>
  8025bd:	89 c3                	mov    %eax,%ebx
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	eb 0c                	jmp    8025d0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	56                   	push   %esi
  8025c8:	e8 e4 01 00 00       	call   8027b1 <nsipc_close>
		return r;
  8025cd:	83 c4 10             	add    $0x10,%esp
}
  8025d0:	89 d8                	mov    %ebx,%eax
  8025d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025d5:	5b                   	pop    %ebx
  8025d6:	5e                   	pop    %esi
  8025d7:	5d                   	pop    %ebp
  8025d8:	c3                   	ret    

008025d9 <accept>:
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	e8 4e ff ff ff       	call   802535 <fd2sockid>
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	78 1b                	js     802606 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	ff 75 10             	pushl  0x10(%ebp)
  8025f1:	ff 75 0c             	pushl  0xc(%ebp)
  8025f4:	50                   	push   %eax
  8025f5:	e8 0e 01 00 00       	call   802708 <nsipc_accept>
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	78 05                	js     802606 <accept+0x2d>
	return alloc_sockfd(r);
  802601:	e8 5f ff ff ff       	call   802565 <alloc_sockfd>
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <bind>:
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	e8 1f ff ff ff       	call   802535 <fd2sockid>
  802616:	85 c0                	test   %eax,%eax
  802618:	78 12                	js     80262c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	ff 75 10             	pushl  0x10(%ebp)
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	50                   	push   %eax
  802624:	e8 31 01 00 00       	call   80275a <nsipc_bind>
  802629:	83 c4 10             	add    $0x10,%esp
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <shutdown>:
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	e8 f9 fe ff ff       	call   802535 <fd2sockid>
  80263c:	85 c0                	test   %eax,%eax
  80263e:	78 0f                	js     80264f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802640:	83 ec 08             	sub    $0x8,%esp
  802643:	ff 75 0c             	pushl  0xc(%ebp)
  802646:	50                   	push   %eax
  802647:	e8 43 01 00 00       	call   80278f <nsipc_shutdown>
  80264c:	83 c4 10             	add    $0x10,%esp
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <connect>:
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	e8 d6 fe ff ff       	call   802535 <fd2sockid>
  80265f:	85 c0                	test   %eax,%eax
  802661:	78 12                	js     802675 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	ff 75 10             	pushl  0x10(%ebp)
  802669:	ff 75 0c             	pushl  0xc(%ebp)
  80266c:	50                   	push   %eax
  80266d:	e8 59 01 00 00       	call   8027cb <nsipc_connect>
  802672:	83 c4 10             	add    $0x10,%esp
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <listen>:
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	e8 b0 fe ff ff       	call   802535 <fd2sockid>
  802685:	85 c0                	test   %eax,%eax
  802687:	78 0f                	js     802698 <listen+0x21>
	return nsipc_listen(r, backlog);
  802689:	83 ec 08             	sub    $0x8,%esp
  80268c:	ff 75 0c             	pushl  0xc(%ebp)
  80268f:	50                   	push   %eax
  802690:	e8 6b 01 00 00       	call   802800 <nsipc_listen>
  802695:	83 c4 10             	add    $0x10,%esp
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <socket>:

int
socket(int domain, int type, int protocol)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8026a0:	ff 75 10             	pushl  0x10(%ebp)
  8026a3:	ff 75 0c             	pushl  0xc(%ebp)
  8026a6:	ff 75 08             	pushl  0x8(%ebp)
  8026a9:	e8 3e 02 00 00       	call   8028ec <nsipc_socket>
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	78 05                	js     8026ba <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8026b5:	e8 ab fe ff ff       	call   802565 <alloc_sockfd>
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	53                   	push   %ebx
  8026c0:	83 ec 04             	sub    $0x4,%esp
  8026c3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8026c5:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8026cc:	74 26                	je     8026f4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026ce:	6a 07                	push   $0x7
  8026d0:	68 00 70 80 00       	push   $0x807000
  8026d5:	53                   	push   %ebx
  8026d6:	ff 35 04 50 80 00    	pushl  0x805004
  8026dc:	e8 45 08 00 00       	call   802f26 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026e1:	83 c4 0c             	add    $0xc,%esp
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	e8 ce 07 00 00       	call   802ebd <ipc_recv>
}
  8026ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f2:	c9                   	leave  
  8026f3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026f4:	83 ec 0c             	sub    $0xc,%esp
  8026f7:	6a 02                	push   $0x2
  8026f9:	e8 80 08 00 00       	call   802f7e <ipc_find_env>
  8026fe:	a3 04 50 80 00       	mov    %eax,0x805004
  802703:	83 c4 10             	add    $0x10,%esp
  802706:	eb c6                	jmp    8026ce <nsipc+0x12>

00802708 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	56                   	push   %esi
  80270c:	53                   	push   %ebx
  80270d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802718:	8b 06                	mov    (%esi),%eax
  80271a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80271f:	b8 01 00 00 00       	mov    $0x1,%eax
  802724:	e8 93 ff ff ff       	call   8026bc <nsipc>
  802729:	89 c3                	mov    %eax,%ebx
  80272b:	85 c0                	test   %eax,%eax
  80272d:	79 09                	jns    802738 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80272f:	89 d8                	mov    %ebx,%eax
  802731:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802734:	5b                   	pop    %ebx
  802735:	5e                   	pop    %esi
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	ff 35 10 70 80 00    	pushl  0x807010
  802741:	68 00 70 80 00       	push   $0x807000
  802746:	ff 75 0c             	pushl  0xc(%ebp)
  802749:	e8 e5 e4 ff ff       	call   800c33 <memmove>
		*addrlen = ret->ret_addrlen;
  80274e:	a1 10 70 80 00       	mov    0x807010,%eax
  802753:	89 06                	mov    %eax,(%esi)
  802755:	83 c4 10             	add    $0x10,%esp
	return r;
  802758:	eb d5                	jmp    80272f <nsipc_accept+0x27>

0080275a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	53                   	push   %ebx
  80275e:	83 ec 08             	sub    $0x8,%esp
  802761:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80276c:	53                   	push   %ebx
  80276d:	ff 75 0c             	pushl  0xc(%ebp)
  802770:	68 04 70 80 00       	push   $0x807004
  802775:	e8 b9 e4 ff ff       	call   800c33 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80277a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802780:	b8 02 00 00 00       	mov    $0x2,%eax
  802785:	e8 32 ff ff ff       	call   8026bc <nsipc>
}
  80278a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80279d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8027a5:	b8 03 00 00 00       	mov    $0x3,%eax
  8027aa:	e8 0d ff ff ff       	call   8026bc <nsipc>
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <nsipc_close>:

int
nsipc_close(int s)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8027c4:	e8 f3 fe ff ff       	call   8026bc <nsipc>
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	53                   	push   %ebx
  8027cf:	83 ec 08             	sub    $0x8,%esp
  8027d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027dd:	53                   	push   %ebx
  8027de:	ff 75 0c             	pushl  0xc(%ebp)
  8027e1:	68 04 70 80 00       	push   $0x807004
  8027e6:	e8 48 e4 ff ff       	call   800c33 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027eb:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027f1:	b8 05 00 00 00       	mov    $0x5,%eax
  8027f6:	e8 c1 fe ff ff       	call   8026bc <nsipc>
}
  8027fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80280e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802811:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802816:	b8 06 00 00 00       	mov    $0x6,%eax
  80281b:	e8 9c fe ff ff       	call   8026bc <nsipc>
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	56                   	push   %esi
  802826:	53                   	push   %ebx
  802827:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802832:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802838:	8b 45 14             	mov    0x14(%ebp),%eax
  80283b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802840:	b8 07 00 00 00       	mov    $0x7,%eax
  802845:	e8 72 fe ff ff       	call   8026bc <nsipc>
  80284a:	89 c3                	mov    %eax,%ebx
  80284c:	85 c0                	test   %eax,%eax
  80284e:	78 1f                	js     80286f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802850:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802855:	7f 21                	jg     802878 <nsipc_recv+0x56>
  802857:	39 c6                	cmp    %eax,%esi
  802859:	7c 1d                	jl     802878 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	50                   	push   %eax
  80285f:	68 00 70 80 00       	push   $0x807000
  802864:	ff 75 0c             	pushl  0xc(%ebp)
  802867:	e8 c7 e3 ff ff       	call   800c33 <memmove>
  80286c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80286f:	89 d8                	mov    %ebx,%eax
  802871:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802874:	5b                   	pop    %ebx
  802875:	5e                   	pop    %esi
  802876:	5d                   	pop    %ebp
  802877:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802878:	68 b6 39 80 00       	push   $0x8039b6
  80287d:	68 9f 38 80 00       	push   $0x80389f
  802882:	6a 62                	push   $0x62
  802884:	68 cb 39 80 00       	push   $0x8039cb
  802889:	e8 c2 d9 ff ff       	call   800250 <_panic>

0080288e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	53                   	push   %ebx
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8028a0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8028a6:	7f 2e                	jg     8028d6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8028a8:	83 ec 04             	sub    $0x4,%esp
  8028ab:	53                   	push   %ebx
  8028ac:	ff 75 0c             	pushl  0xc(%ebp)
  8028af:	68 0c 70 80 00       	push   $0x80700c
  8028b4:	e8 7a e3 ff ff       	call   800c33 <memmove>
	nsipcbuf.send.req_size = size;
  8028b9:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8028c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8028cc:	e8 eb fd ff ff       	call   8026bc <nsipc>
}
  8028d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    
	assert(size < 1600);
  8028d6:	68 d7 39 80 00       	push   $0x8039d7
  8028db:	68 9f 38 80 00       	push   $0x80389f
  8028e0:	6a 6d                	push   $0x6d
  8028e2:	68 cb 39 80 00       	push   $0x8039cb
  8028e7:	e8 64 d9 ff ff       	call   800250 <_panic>

008028ec <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fd:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802902:	8b 45 10             	mov    0x10(%ebp),%eax
  802905:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80290a:	b8 09 00 00 00       	mov    $0x9,%eax
  80290f:	e8 a8 fd ff ff       	call   8026bc <nsipc>
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	56                   	push   %esi
  80291a:	53                   	push   %ebx
  80291b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80291e:	83 ec 0c             	sub    $0xc,%esp
  802921:	ff 75 08             	pushl  0x8(%ebp)
  802924:	e8 4e ed ff ff       	call   801677 <fd2data>
  802929:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80292b:	83 c4 08             	add    $0x8,%esp
  80292e:	68 e3 39 80 00       	push   $0x8039e3
  802933:	53                   	push   %ebx
  802934:	e8 6c e1 ff ff       	call   800aa5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802939:	8b 46 04             	mov    0x4(%esi),%eax
  80293c:	2b 06                	sub    (%esi),%eax
  80293e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802944:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80294b:	00 00 00 
	stat->st_dev = &devpipe;
  80294e:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802955:	40 80 00 
	return 0;
}
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
  80295d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802960:	5b                   	pop    %ebx
  802961:	5e                   	pop    %esi
  802962:	5d                   	pop    %ebp
  802963:	c3                   	ret    

00802964 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	53                   	push   %ebx
  802968:	83 ec 0c             	sub    $0xc,%esp
  80296b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80296e:	53                   	push   %ebx
  80296f:	6a 00                	push   $0x0
  802971:	e8 a6 e5 ff ff       	call   800f1c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802976:	89 1c 24             	mov    %ebx,(%esp)
  802979:	e8 f9 ec ff ff       	call   801677 <fd2data>
  80297e:	83 c4 08             	add    $0x8,%esp
  802981:	50                   	push   %eax
  802982:	6a 00                	push   $0x0
  802984:	e8 93 e5 ff ff       	call   800f1c <sys_page_unmap>
}
  802989:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80298c:	c9                   	leave  
  80298d:	c3                   	ret    

0080298e <_pipeisclosed>:
{
  80298e:	55                   	push   %ebp
  80298f:	89 e5                	mov    %esp,%ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	53                   	push   %ebx
  802994:	83 ec 1c             	sub    $0x1c,%esp
  802997:	89 c7                	mov    %eax,%edi
  802999:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80299b:	a1 08 50 80 00       	mov    0x805008,%eax
  8029a0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029a3:	83 ec 0c             	sub    $0xc,%esp
  8029a6:	57                   	push   %edi
  8029a7:	e8 0d 06 00 00       	call   802fb9 <pageref>
  8029ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8029af:	89 34 24             	mov    %esi,(%esp)
  8029b2:	e8 02 06 00 00       	call   802fb9 <pageref>
		nn = thisenv->env_runs;
  8029b7:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029bd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	39 cb                	cmp    %ecx,%ebx
  8029c5:	74 1b                	je     8029e2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8029c7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029ca:	75 cf                	jne    80299b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029cc:	8b 42 58             	mov    0x58(%edx),%eax
  8029cf:	6a 01                	push   $0x1
  8029d1:	50                   	push   %eax
  8029d2:	53                   	push   %ebx
  8029d3:	68 ea 39 80 00       	push   $0x8039ea
  8029d8:	e8 69 d9 ff ff       	call   800346 <cprintf>
  8029dd:	83 c4 10             	add    $0x10,%esp
  8029e0:	eb b9                	jmp    80299b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8029e2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029e5:	0f 94 c0             	sete   %al
  8029e8:	0f b6 c0             	movzbl %al,%eax
}
  8029eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ee:	5b                   	pop    %ebx
  8029ef:	5e                   	pop    %esi
  8029f0:	5f                   	pop    %edi
  8029f1:	5d                   	pop    %ebp
  8029f2:	c3                   	ret    

008029f3 <devpipe_write>:
{
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
  8029f6:	57                   	push   %edi
  8029f7:	56                   	push   %esi
  8029f8:	53                   	push   %ebx
  8029f9:	83 ec 28             	sub    $0x28,%esp
  8029fc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8029ff:	56                   	push   %esi
  802a00:	e8 72 ec ff ff       	call   801677 <fd2data>
  802a05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a07:	83 c4 10             	add    $0x10,%esp
  802a0a:	bf 00 00 00 00       	mov    $0x0,%edi
  802a0f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802a12:	74 4f                	je     802a63 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a14:	8b 43 04             	mov    0x4(%ebx),%eax
  802a17:	8b 0b                	mov    (%ebx),%ecx
  802a19:	8d 51 20             	lea    0x20(%ecx),%edx
  802a1c:	39 d0                	cmp    %edx,%eax
  802a1e:	72 14                	jb     802a34 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802a20:	89 da                	mov    %ebx,%edx
  802a22:	89 f0                	mov    %esi,%eax
  802a24:	e8 65 ff ff ff       	call   80298e <_pipeisclosed>
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 3b                	jne    802a68 <devpipe_write+0x75>
			sys_yield();
  802a2d:	e8 46 e4 ff ff       	call   800e78 <sys_yield>
  802a32:	eb e0                	jmp    802a14 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a37:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a3b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a3e:	89 c2                	mov    %eax,%edx
  802a40:	c1 fa 1f             	sar    $0x1f,%edx
  802a43:	89 d1                	mov    %edx,%ecx
  802a45:	c1 e9 1b             	shr    $0x1b,%ecx
  802a48:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a4b:	83 e2 1f             	and    $0x1f,%edx
  802a4e:	29 ca                	sub    %ecx,%edx
  802a50:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a54:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a58:	83 c0 01             	add    $0x1,%eax
  802a5b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a5e:	83 c7 01             	add    $0x1,%edi
  802a61:	eb ac                	jmp    802a0f <devpipe_write+0x1c>
	return i;
  802a63:	8b 45 10             	mov    0x10(%ebp),%eax
  802a66:	eb 05                	jmp    802a6d <devpipe_write+0x7a>
				return 0;
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a70:	5b                   	pop    %ebx
  802a71:	5e                   	pop    %esi
  802a72:	5f                   	pop    %edi
  802a73:	5d                   	pop    %ebp
  802a74:	c3                   	ret    

00802a75 <devpipe_read>:
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	57                   	push   %edi
  802a79:	56                   	push   %esi
  802a7a:	53                   	push   %ebx
  802a7b:	83 ec 18             	sub    $0x18,%esp
  802a7e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802a81:	57                   	push   %edi
  802a82:	e8 f0 eb ff ff       	call   801677 <fd2data>
  802a87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a89:	83 c4 10             	add    $0x10,%esp
  802a8c:	be 00 00 00 00       	mov    $0x0,%esi
  802a91:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a94:	75 14                	jne    802aaa <devpipe_read+0x35>
	return i;
  802a96:	8b 45 10             	mov    0x10(%ebp),%eax
  802a99:	eb 02                	jmp    802a9d <devpipe_read+0x28>
				return i;
  802a9b:	89 f0                	mov    %esi,%eax
}
  802a9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802aa0:	5b                   	pop    %ebx
  802aa1:	5e                   	pop    %esi
  802aa2:	5f                   	pop    %edi
  802aa3:	5d                   	pop    %ebp
  802aa4:	c3                   	ret    
			sys_yield();
  802aa5:	e8 ce e3 ff ff       	call   800e78 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802aaa:	8b 03                	mov    (%ebx),%eax
  802aac:	3b 43 04             	cmp    0x4(%ebx),%eax
  802aaf:	75 18                	jne    802ac9 <devpipe_read+0x54>
			if (i > 0)
  802ab1:	85 f6                	test   %esi,%esi
  802ab3:	75 e6                	jne    802a9b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802ab5:	89 da                	mov    %ebx,%edx
  802ab7:	89 f8                	mov    %edi,%eax
  802ab9:	e8 d0 fe ff ff       	call   80298e <_pipeisclosed>
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 e3                	je     802aa5 <devpipe_read+0x30>
				return 0;
  802ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac7:	eb d4                	jmp    802a9d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ac9:	99                   	cltd   
  802aca:	c1 ea 1b             	shr    $0x1b,%edx
  802acd:	01 d0                	add    %edx,%eax
  802acf:	83 e0 1f             	and    $0x1f,%eax
  802ad2:	29 d0                	sub    %edx,%eax
  802ad4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802adc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802adf:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ae2:	83 c6 01             	add    $0x1,%esi
  802ae5:	eb aa                	jmp    802a91 <devpipe_read+0x1c>

00802ae7 <pipe>:
{
  802ae7:	55                   	push   %ebp
  802ae8:	89 e5                	mov    %esp,%ebp
  802aea:	56                   	push   %esi
  802aeb:	53                   	push   %ebx
  802aec:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802af2:	50                   	push   %eax
  802af3:	e8 96 eb ff ff       	call   80168e <fd_alloc>
  802af8:	89 c3                	mov    %eax,%ebx
  802afa:	83 c4 10             	add    $0x10,%esp
  802afd:	85 c0                	test   %eax,%eax
  802aff:	0f 88 23 01 00 00    	js     802c28 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 07 04 00 00       	push   $0x407
  802b0d:	ff 75 f4             	pushl  -0xc(%ebp)
  802b10:	6a 00                	push   $0x0
  802b12:	e8 80 e3 ff ff       	call   800e97 <sys_page_alloc>
  802b17:	89 c3                	mov    %eax,%ebx
  802b19:	83 c4 10             	add    $0x10,%esp
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	0f 88 04 01 00 00    	js     802c28 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802b24:	83 ec 0c             	sub    $0xc,%esp
  802b27:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b2a:	50                   	push   %eax
  802b2b:	e8 5e eb ff ff       	call   80168e <fd_alloc>
  802b30:	89 c3                	mov    %eax,%ebx
  802b32:	83 c4 10             	add    $0x10,%esp
  802b35:	85 c0                	test   %eax,%eax
  802b37:	0f 88 db 00 00 00    	js     802c18 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b3d:	83 ec 04             	sub    $0x4,%esp
  802b40:	68 07 04 00 00       	push   $0x407
  802b45:	ff 75 f0             	pushl  -0x10(%ebp)
  802b48:	6a 00                	push   $0x0
  802b4a:	e8 48 e3 ff ff       	call   800e97 <sys_page_alloc>
  802b4f:	89 c3                	mov    %eax,%ebx
  802b51:	83 c4 10             	add    $0x10,%esp
  802b54:	85 c0                	test   %eax,%eax
  802b56:	0f 88 bc 00 00 00    	js     802c18 <pipe+0x131>
	va = fd2data(fd0);
  802b5c:	83 ec 0c             	sub    $0xc,%esp
  802b5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802b62:	e8 10 eb ff ff       	call   801677 <fd2data>
  802b67:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b69:	83 c4 0c             	add    $0xc,%esp
  802b6c:	68 07 04 00 00       	push   $0x407
  802b71:	50                   	push   %eax
  802b72:	6a 00                	push   $0x0
  802b74:	e8 1e e3 ff ff       	call   800e97 <sys_page_alloc>
  802b79:	89 c3                	mov    %eax,%ebx
  802b7b:	83 c4 10             	add    $0x10,%esp
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	0f 88 82 00 00 00    	js     802c08 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b86:	83 ec 0c             	sub    $0xc,%esp
  802b89:	ff 75 f0             	pushl  -0x10(%ebp)
  802b8c:	e8 e6 ea ff ff       	call   801677 <fd2data>
  802b91:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802b98:	50                   	push   %eax
  802b99:	6a 00                	push   $0x0
  802b9b:	56                   	push   %esi
  802b9c:	6a 00                	push   $0x0
  802b9e:	e8 37 e3 ff ff       	call   800eda <sys_page_map>
  802ba3:	89 c3                	mov    %eax,%ebx
  802ba5:	83 c4 20             	add    $0x20,%esp
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	78 4e                	js     802bfa <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802bac:	a1 44 40 80 00       	mov    0x804044,%eax
  802bb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802bb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802bc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802bcf:	83 ec 0c             	sub    $0xc,%esp
  802bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  802bd5:	e8 8d ea ff ff       	call   801667 <fd2num>
  802bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bdd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bdf:	83 c4 04             	add    $0x4,%esp
  802be2:	ff 75 f0             	pushl  -0x10(%ebp)
  802be5:	e8 7d ea ff ff       	call   801667 <fd2num>
  802bea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bed:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bf0:	83 c4 10             	add    $0x10,%esp
  802bf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  802bf8:	eb 2e                	jmp    802c28 <pipe+0x141>
	sys_page_unmap(0, va);
  802bfa:	83 ec 08             	sub    $0x8,%esp
  802bfd:	56                   	push   %esi
  802bfe:	6a 00                	push   $0x0
  802c00:	e8 17 e3 ff ff       	call   800f1c <sys_page_unmap>
  802c05:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802c08:	83 ec 08             	sub    $0x8,%esp
  802c0b:	ff 75 f0             	pushl  -0x10(%ebp)
  802c0e:	6a 00                	push   $0x0
  802c10:	e8 07 e3 ff ff       	call   800f1c <sys_page_unmap>
  802c15:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c18:	83 ec 08             	sub    $0x8,%esp
  802c1b:	ff 75 f4             	pushl  -0xc(%ebp)
  802c1e:	6a 00                	push   $0x0
  802c20:	e8 f7 e2 ff ff       	call   800f1c <sys_page_unmap>
  802c25:	83 c4 10             	add    $0x10,%esp
}
  802c28:	89 d8                	mov    %ebx,%eax
  802c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c2d:	5b                   	pop    %ebx
  802c2e:	5e                   	pop    %esi
  802c2f:	5d                   	pop    %ebp
  802c30:	c3                   	ret    

00802c31 <pipeisclosed>:
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
  802c34:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c3a:	50                   	push   %eax
  802c3b:	ff 75 08             	pushl  0x8(%ebp)
  802c3e:	e8 9d ea ff ff       	call   8016e0 <fd_lookup>
  802c43:	83 c4 10             	add    $0x10,%esp
  802c46:	85 c0                	test   %eax,%eax
  802c48:	78 18                	js     802c62 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802c4a:	83 ec 0c             	sub    $0xc,%esp
  802c4d:	ff 75 f4             	pushl  -0xc(%ebp)
  802c50:	e8 22 ea ff ff       	call   801677 <fd2data>
	return _pipeisclosed(fd, p);
  802c55:	89 c2                	mov    %eax,%edx
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	e8 2f fd ff ff       	call   80298e <_pipeisclosed>
  802c5f:	83 c4 10             	add    $0x10,%esp
}
  802c62:	c9                   	leave  
  802c63:	c3                   	ret    

00802c64 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	56                   	push   %esi
  802c68:	53                   	push   %ebx
  802c69:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802c6c:	85 f6                	test   %esi,%esi
  802c6e:	74 13                	je     802c83 <wait+0x1f>
	e = &envs[ENVX(envid)];
  802c70:	89 f3                	mov    %esi,%ebx
  802c72:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c78:	c1 e3 07             	shl    $0x7,%ebx
  802c7b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802c81:	eb 1b                	jmp    802c9e <wait+0x3a>
	assert(envid != 0);
  802c83:	68 02 3a 80 00       	push   $0x803a02
  802c88:	68 9f 38 80 00       	push   $0x80389f
  802c8d:	6a 09                	push   $0x9
  802c8f:	68 0d 3a 80 00       	push   $0x803a0d
  802c94:	e8 b7 d5 ff ff       	call   800250 <_panic>
		sys_yield();
  802c99:	e8 da e1 ff ff       	call   800e78 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c9e:	8b 43 48             	mov    0x48(%ebx),%eax
  802ca1:	39 f0                	cmp    %esi,%eax
  802ca3:	75 07                	jne    802cac <wait+0x48>
  802ca5:	8b 43 54             	mov    0x54(%ebx),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	75 ed                	jne    802c99 <wait+0x35>
}
  802cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802caf:	5b                   	pop    %ebx
  802cb0:	5e                   	pop    %esi
  802cb1:	5d                   	pop    %ebp
  802cb2:	c3                   	ret    

00802cb3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb8:	c3                   	ret    

00802cb9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cb9:	55                   	push   %ebp
  802cba:	89 e5                	mov    %esp,%ebp
  802cbc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802cbf:	68 18 3a 80 00       	push   $0x803a18
  802cc4:	ff 75 0c             	pushl  0xc(%ebp)
  802cc7:	e8 d9 dd ff ff       	call   800aa5 <strcpy>
	return 0;
}
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd1:	c9                   	leave  
  802cd2:	c3                   	ret    

00802cd3 <devcons_write>:
{
  802cd3:	55                   	push   %ebp
  802cd4:	89 e5                	mov    %esp,%ebp
  802cd6:	57                   	push   %edi
  802cd7:	56                   	push   %esi
  802cd8:	53                   	push   %ebx
  802cd9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802cdf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802ce4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802cea:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ced:	73 31                	jae    802d20 <devcons_write+0x4d>
		m = n - tot;
  802cef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802cf2:	29 f3                	sub    %esi,%ebx
  802cf4:	83 fb 7f             	cmp    $0x7f,%ebx
  802cf7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802cfc:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	53                   	push   %ebx
  802d03:	89 f0                	mov    %esi,%eax
  802d05:	03 45 0c             	add    0xc(%ebp),%eax
  802d08:	50                   	push   %eax
  802d09:	57                   	push   %edi
  802d0a:	e8 24 df ff ff       	call   800c33 <memmove>
		sys_cputs(buf, m);
  802d0f:	83 c4 08             	add    $0x8,%esp
  802d12:	53                   	push   %ebx
  802d13:	57                   	push   %edi
  802d14:	e8 c2 e0 ff ff       	call   800ddb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d19:	01 de                	add    %ebx,%esi
  802d1b:	83 c4 10             	add    $0x10,%esp
  802d1e:	eb ca                	jmp    802cea <devcons_write+0x17>
}
  802d20:	89 f0                	mov    %esi,%eax
  802d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d25:	5b                   	pop    %ebx
  802d26:	5e                   	pop    %esi
  802d27:	5f                   	pop    %edi
  802d28:	5d                   	pop    %ebp
  802d29:	c3                   	ret    

00802d2a <devcons_read>:
{
  802d2a:	55                   	push   %ebp
  802d2b:	89 e5                	mov    %esp,%ebp
  802d2d:	83 ec 08             	sub    $0x8,%esp
  802d30:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d39:	74 21                	je     802d5c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d3b:	e8 b9 e0 ff ff       	call   800df9 <sys_cgetc>
  802d40:	85 c0                	test   %eax,%eax
  802d42:	75 07                	jne    802d4b <devcons_read+0x21>
		sys_yield();
  802d44:	e8 2f e1 ff ff       	call   800e78 <sys_yield>
  802d49:	eb f0                	jmp    802d3b <devcons_read+0x11>
	if (c < 0)
  802d4b:	78 0f                	js     802d5c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802d4d:	83 f8 04             	cmp    $0x4,%eax
  802d50:	74 0c                	je     802d5e <devcons_read+0x34>
	*(char*)vbuf = c;
  802d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d55:	88 02                	mov    %al,(%edx)
	return 1;
  802d57:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d5c:	c9                   	leave  
  802d5d:	c3                   	ret    
		return 0;
  802d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d63:	eb f7                	jmp    802d5c <devcons_read+0x32>

00802d65 <cputchar>:
{
  802d65:	55                   	push   %ebp
  802d66:	89 e5                	mov    %esp,%ebp
  802d68:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802d71:	6a 01                	push   $0x1
  802d73:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d76:	50                   	push   %eax
  802d77:	e8 5f e0 ff ff       	call   800ddb <sys_cputs>
}
  802d7c:	83 c4 10             	add    $0x10,%esp
  802d7f:	c9                   	leave  
  802d80:	c3                   	ret    

00802d81 <getchar>:
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
  802d84:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802d87:	6a 01                	push   $0x1
  802d89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d8c:	50                   	push   %eax
  802d8d:	6a 00                	push   $0x0
  802d8f:	e8 bc eb ff ff       	call   801950 <read>
	if (r < 0)
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	85 c0                	test   %eax,%eax
  802d99:	78 06                	js     802da1 <getchar+0x20>
	if (r < 1)
  802d9b:	74 06                	je     802da3 <getchar+0x22>
	return c;
  802d9d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    
		return -E_EOF;
  802da3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802da8:	eb f7                	jmp    802da1 <getchar+0x20>

00802daa <iscons>:
{
  802daa:	55                   	push   %ebp
  802dab:	89 e5                	mov    %esp,%ebp
  802dad:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802db0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db3:	50                   	push   %eax
  802db4:	ff 75 08             	pushl  0x8(%ebp)
  802db7:	e8 24 e9 ff ff       	call   8016e0 <fd_lookup>
  802dbc:	83 c4 10             	add    $0x10,%esp
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	78 11                	js     802dd4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802dcc:	39 10                	cmp    %edx,(%eax)
  802dce:	0f 94 c0             	sete   %al
  802dd1:	0f b6 c0             	movzbl %al,%eax
}
  802dd4:	c9                   	leave  
  802dd5:	c3                   	ret    

00802dd6 <opencons>:
{
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
  802dd9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802ddc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ddf:	50                   	push   %eax
  802de0:	e8 a9 e8 ff ff       	call   80168e <fd_alloc>
  802de5:	83 c4 10             	add    $0x10,%esp
  802de8:	85 c0                	test   %eax,%eax
  802dea:	78 3a                	js     802e26 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	68 07 04 00 00       	push   $0x407
  802df4:	ff 75 f4             	pushl  -0xc(%ebp)
  802df7:	6a 00                	push   $0x0
  802df9:	e8 99 e0 ff ff       	call   800e97 <sys_page_alloc>
  802dfe:	83 c4 10             	add    $0x10,%esp
  802e01:	85 c0                	test   %eax,%eax
  802e03:	78 21                	js     802e26 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802e0e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e1a:	83 ec 0c             	sub    $0xc,%esp
  802e1d:	50                   	push   %eax
  802e1e:	e8 44 e8 ff ff       	call   801667 <fd2num>
  802e23:	83 c4 10             	add    $0x10,%esp
}
  802e26:	c9                   	leave  
  802e27:	c3                   	ret    

00802e28 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e28:	55                   	push   %ebp
  802e29:	89 e5                	mov    %esp,%ebp
  802e2b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e2e:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e35:	74 0a                	je     802e41 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e3f:	c9                   	leave  
  802e40:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	6a 07                	push   $0x7
  802e46:	68 00 f0 bf ee       	push   $0xeebff000
  802e4b:	6a 00                	push   $0x0
  802e4d:	e8 45 e0 ff ff       	call   800e97 <sys_page_alloc>
		if(r < 0)
  802e52:	83 c4 10             	add    $0x10,%esp
  802e55:	85 c0                	test   %eax,%eax
  802e57:	78 2a                	js     802e83 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802e59:	83 ec 08             	sub    $0x8,%esp
  802e5c:	68 97 2e 80 00       	push   $0x802e97
  802e61:	6a 00                	push   $0x0
  802e63:	e8 7a e1 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	79 c8                	jns    802e37 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 54 3a 80 00       	push   $0x803a54
  802e77:	6a 25                	push   $0x25
  802e79:	68 90 3a 80 00       	push   $0x803a90
  802e7e:	e8 cd d3 ff ff       	call   800250 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 24 3a 80 00       	push   $0x803a24
  802e8b:	6a 22                	push   $0x22
  802e8d:	68 90 3a 80 00       	push   $0x803a90
  802e92:	e8 b9 d3 ff ff       	call   800250 <_panic>

00802e97 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802e97:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802e98:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802e9d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802e9f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802ea2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802ea6:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802eaa:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802ead:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802eaf:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802eb3:	83 c4 08             	add    $0x8,%esp
	popal
  802eb6:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802eb7:	83 c4 04             	add    $0x4,%esp
	popfl
  802eba:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ebb:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ebc:	c3                   	ret    

00802ebd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ebd:	55                   	push   %ebp
  802ebe:	89 e5                	mov    %esp,%ebp
  802ec0:	56                   	push   %esi
  802ec1:	53                   	push   %ebx
  802ec2:	8b 75 08             	mov    0x8(%ebp),%esi
  802ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802ecb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802ecd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802ed2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802ed5:	83 ec 0c             	sub    $0xc,%esp
  802ed8:	50                   	push   %eax
  802ed9:	e8 69 e1 ff ff       	call   801047 <sys_ipc_recv>
	if(ret < 0){
  802ede:	83 c4 10             	add    $0x10,%esp
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	78 2b                	js     802f10 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802ee5:	85 f6                	test   %esi,%esi
  802ee7:	74 0a                	je     802ef3 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802ee9:	a1 08 50 80 00       	mov    0x805008,%eax
  802eee:	8b 40 74             	mov    0x74(%eax),%eax
  802ef1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802ef3:	85 db                	test   %ebx,%ebx
  802ef5:	74 0a                	je     802f01 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802ef7:	a1 08 50 80 00       	mov    0x805008,%eax
  802efc:	8b 40 78             	mov    0x78(%eax),%eax
  802eff:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802f01:	a1 08 50 80 00       	mov    0x805008,%eax
  802f06:	8b 40 70             	mov    0x70(%eax),%eax
}
  802f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f0c:	5b                   	pop    %ebx
  802f0d:	5e                   	pop    %esi
  802f0e:	5d                   	pop    %ebp
  802f0f:	c3                   	ret    
		if(from_env_store)
  802f10:	85 f6                	test   %esi,%esi
  802f12:	74 06                	je     802f1a <ipc_recv+0x5d>
			*from_env_store = 0;
  802f14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802f1a:	85 db                	test   %ebx,%ebx
  802f1c:	74 eb                	je     802f09 <ipc_recv+0x4c>
			*perm_store = 0;
  802f1e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f24:	eb e3                	jmp    802f09 <ipc_recv+0x4c>

00802f26 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
  802f29:	57                   	push   %edi
  802f2a:	56                   	push   %esi
  802f2b:	53                   	push   %ebx
  802f2c:	83 ec 0c             	sub    $0xc,%esp
  802f2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f32:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f35:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802f38:	85 db                	test   %ebx,%ebx
  802f3a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802f3f:	0f 44 d8             	cmove  %eax,%ebx
  802f42:	eb 05                	jmp    802f49 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802f44:	e8 2f df ff ff       	call   800e78 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802f49:	ff 75 14             	pushl  0x14(%ebp)
  802f4c:	53                   	push   %ebx
  802f4d:	56                   	push   %esi
  802f4e:	57                   	push   %edi
  802f4f:	e8 d0 e0 ff ff       	call   801024 <sys_ipc_try_send>
  802f54:	83 c4 10             	add    $0x10,%esp
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 1b                	je     802f76 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802f5b:	79 e7                	jns    802f44 <ipc_send+0x1e>
  802f5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f60:	74 e2                	je     802f44 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802f62:	83 ec 04             	sub    $0x4,%esp
  802f65:	68 9e 3a 80 00       	push   $0x803a9e
  802f6a:	6a 48                	push   $0x48
  802f6c:	68 b3 3a 80 00       	push   $0x803ab3
  802f71:	e8 da d2 ff ff       	call   800250 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f79:	5b                   	pop    %ebx
  802f7a:	5e                   	pop    %esi
  802f7b:	5f                   	pop    %edi
  802f7c:	5d                   	pop    %ebp
  802f7d:	c3                   	ret    

00802f7e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
  802f81:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802f89:	89 c2                	mov    %eax,%edx
  802f8b:	c1 e2 07             	shl    $0x7,%edx
  802f8e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802f94:	8b 52 50             	mov    0x50(%edx),%edx
  802f97:	39 ca                	cmp    %ecx,%edx
  802f99:	74 11                	je     802fac <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802f9b:	83 c0 01             	add    $0x1,%eax
  802f9e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802fa3:	75 e4                	jne    802f89 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	eb 0b                	jmp    802fb7 <ipc_find_env+0x39>
			return envs[i].env_id;
  802fac:	c1 e0 07             	shl    $0x7,%eax
  802faf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802fb4:	8b 40 48             	mov    0x48(%eax),%eax
}
  802fb7:	5d                   	pop    %ebp
  802fb8:	c3                   	ret    

00802fb9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
  802fbc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fbf:	89 d0                	mov    %edx,%eax
  802fc1:	c1 e8 16             	shr    $0x16,%eax
  802fc4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802fcb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802fd0:	f6 c1 01             	test   $0x1,%cl
  802fd3:	74 1d                	je     802ff2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802fd5:	c1 ea 0c             	shr    $0xc,%edx
  802fd8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802fdf:	f6 c2 01             	test   $0x1,%dl
  802fe2:	74 0e                	je     802ff2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fe4:	c1 ea 0c             	shr    $0xc,%edx
  802fe7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802fee:	ef 
  802fef:	0f b7 c0             	movzwl %ax,%eax
}
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    
  802ff4:	66 90                	xchg   %ax,%ax
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	66 90                	xchg   %ax,%ax
  802ffa:	66 90                	xchg   %ax,%ax
  802ffc:	66 90                	xchg   %ax,%ax
  802ffe:	66 90                	xchg   %ax,%ax

00803000 <__udivdi3>:
  803000:	55                   	push   %ebp
  803001:	57                   	push   %edi
  803002:	56                   	push   %esi
  803003:	53                   	push   %ebx
  803004:	83 ec 1c             	sub    $0x1c,%esp
  803007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80300b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80300f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803017:	85 d2                	test   %edx,%edx
  803019:	75 4d                	jne    803068 <__udivdi3+0x68>
  80301b:	39 f3                	cmp    %esi,%ebx
  80301d:	76 19                	jbe    803038 <__udivdi3+0x38>
  80301f:	31 ff                	xor    %edi,%edi
  803021:	89 e8                	mov    %ebp,%eax
  803023:	89 f2                	mov    %esi,%edx
  803025:	f7 f3                	div    %ebx
  803027:	89 fa                	mov    %edi,%edx
  803029:	83 c4 1c             	add    $0x1c,%esp
  80302c:	5b                   	pop    %ebx
  80302d:	5e                   	pop    %esi
  80302e:	5f                   	pop    %edi
  80302f:	5d                   	pop    %ebp
  803030:	c3                   	ret    
  803031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803038:	89 d9                	mov    %ebx,%ecx
  80303a:	85 db                	test   %ebx,%ebx
  80303c:	75 0b                	jne    803049 <__udivdi3+0x49>
  80303e:	b8 01 00 00 00       	mov    $0x1,%eax
  803043:	31 d2                	xor    %edx,%edx
  803045:	f7 f3                	div    %ebx
  803047:	89 c1                	mov    %eax,%ecx
  803049:	31 d2                	xor    %edx,%edx
  80304b:	89 f0                	mov    %esi,%eax
  80304d:	f7 f1                	div    %ecx
  80304f:	89 c6                	mov    %eax,%esi
  803051:	89 e8                	mov    %ebp,%eax
  803053:	89 f7                	mov    %esi,%edi
  803055:	f7 f1                	div    %ecx
  803057:	89 fa                	mov    %edi,%edx
  803059:	83 c4 1c             	add    $0x1c,%esp
  80305c:	5b                   	pop    %ebx
  80305d:	5e                   	pop    %esi
  80305e:	5f                   	pop    %edi
  80305f:	5d                   	pop    %ebp
  803060:	c3                   	ret    
  803061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803068:	39 f2                	cmp    %esi,%edx
  80306a:	77 1c                	ja     803088 <__udivdi3+0x88>
  80306c:	0f bd fa             	bsr    %edx,%edi
  80306f:	83 f7 1f             	xor    $0x1f,%edi
  803072:	75 2c                	jne    8030a0 <__udivdi3+0xa0>
  803074:	39 f2                	cmp    %esi,%edx
  803076:	72 06                	jb     80307e <__udivdi3+0x7e>
  803078:	31 c0                	xor    %eax,%eax
  80307a:	39 eb                	cmp    %ebp,%ebx
  80307c:	77 a9                	ja     803027 <__udivdi3+0x27>
  80307e:	b8 01 00 00 00       	mov    $0x1,%eax
  803083:	eb a2                	jmp    803027 <__udivdi3+0x27>
  803085:	8d 76 00             	lea    0x0(%esi),%esi
  803088:	31 ff                	xor    %edi,%edi
  80308a:	31 c0                	xor    %eax,%eax
  80308c:	89 fa                	mov    %edi,%edx
  80308e:	83 c4 1c             	add    $0x1c,%esp
  803091:	5b                   	pop    %ebx
  803092:	5e                   	pop    %esi
  803093:	5f                   	pop    %edi
  803094:	5d                   	pop    %ebp
  803095:	c3                   	ret    
  803096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80309d:	8d 76 00             	lea    0x0(%esi),%esi
  8030a0:	89 f9                	mov    %edi,%ecx
  8030a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8030a7:	29 f8                	sub    %edi,%eax
  8030a9:	d3 e2                	shl    %cl,%edx
  8030ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030af:	89 c1                	mov    %eax,%ecx
  8030b1:	89 da                	mov    %ebx,%edx
  8030b3:	d3 ea                	shr    %cl,%edx
  8030b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8030b9:	09 d1                	or     %edx,%ecx
  8030bb:	89 f2                	mov    %esi,%edx
  8030bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030c1:	89 f9                	mov    %edi,%ecx
  8030c3:	d3 e3                	shl    %cl,%ebx
  8030c5:	89 c1                	mov    %eax,%ecx
  8030c7:	d3 ea                	shr    %cl,%edx
  8030c9:	89 f9                	mov    %edi,%ecx
  8030cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030cf:	89 eb                	mov    %ebp,%ebx
  8030d1:	d3 e6                	shl    %cl,%esi
  8030d3:	89 c1                	mov    %eax,%ecx
  8030d5:	d3 eb                	shr    %cl,%ebx
  8030d7:	09 de                	or     %ebx,%esi
  8030d9:	89 f0                	mov    %esi,%eax
  8030db:	f7 74 24 08          	divl   0x8(%esp)
  8030df:	89 d6                	mov    %edx,%esi
  8030e1:	89 c3                	mov    %eax,%ebx
  8030e3:	f7 64 24 0c          	mull   0xc(%esp)
  8030e7:	39 d6                	cmp    %edx,%esi
  8030e9:	72 15                	jb     803100 <__udivdi3+0x100>
  8030eb:	89 f9                	mov    %edi,%ecx
  8030ed:	d3 e5                	shl    %cl,%ebp
  8030ef:	39 c5                	cmp    %eax,%ebp
  8030f1:	73 04                	jae    8030f7 <__udivdi3+0xf7>
  8030f3:	39 d6                	cmp    %edx,%esi
  8030f5:	74 09                	je     803100 <__udivdi3+0x100>
  8030f7:	89 d8                	mov    %ebx,%eax
  8030f9:	31 ff                	xor    %edi,%edi
  8030fb:	e9 27 ff ff ff       	jmp    803027 <__udivdi3+0x27>
  803100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803103:	31 ff                	xor    %edi,%edi
  803105:	e9 1d ff ff ff       	jmp    803027 <__udivdi3+0x27>
  80310a:	66 90                	xchg   %ax,%ax
  80310c:	66 90                	xchg   %ax,%ax
  80310e:	66 90                	xchg   %ax,%ax

00803110 <__umoddi3>:
  803110:	55                   	push   %ebp
  803111:	57                   	push   %edi
  803112:	56                   	push   %esi
  803113:	53                   	push   %ebx
  803114:	83 ec 1c             	sub    $0x1c,%esp
  803117:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80311b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80311f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803127:	89 da                	mov    %ebx,%edx
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 43                	jne    803170 <__umoddi3+0x60>
  80312d:	39 df                	cmp    %ebx,%edi
  80312f:	76 17                	jbe    803148 <__umoddi3+0x38>
  803131:	89 f0                	mov    %esi,%eax
  803133:	f7 f7                	div    %edi
  803135:	89 d0                	mov    %edx,%eax
  803137:	31 d2                	xor    %edx,%edx
  803139:	83 c4 1c             	add    $0x1c,%esp
  80313c:	5b                   	pop    %ebx
  80313d:	5e                   	pop    %esi
  80313e:	5f                   	pop    %edi
  80313f:	5d                   	pop    %ebp
  803140:	c3                   	ret    
  803141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803148:	89 fd                	mov    %edi,%ebp
  80314a:	85 ff                	test   %edi,%edi
  80314c:	75 0b                	jne    803159 <__umoddi3+0x49>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	31 d2                	xor    %edx,%edx
  803155:	f7 f7                	div    %edi
  803157:	89 c5                	mov    %eax,%ebp
  803159:	89 d8                	mov    %ebx,%eax
  80315b:	31 d2                	xor    %edx,%edx
  80315d:	f7 f5                	div    %ebp
  80315f:	89 f0                	mov    %esi,%eax
  803161:	f7 f5                	div    %ebp
  803163:	89 d0                	mov    %edx,%eax
  803165:	eb d0                	jmp    803137 <__umoddi3+0x27>
  803167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80316e:	66 90                	xchg   %ax,%ax
  803170:	89 f1                	mov    %esi,%ecx
  803172:	39 d8                	cmp    %ebx,%eax
  803174:	76 0a                	jbe    803180 <__umoddi3+0x70>
  803176:	89 f0                	mov    %esi,%eax
  803178:	83 c4 1c             	add    $0x1c,%esp
  80317b:	5b                   	pop    %ebx
  80317c:	5e                   	pop    %esi
  80317d:	5f                   	pop    %edi
  80317e:	5d                   	pop    %ebp
  80317f:	c3                   	ret    
  803180:	0f bd e8             	bsr    %eax,%ebp
  803183:	83 f5 1f             	xor    $0x1f,%ebp
  803186:	75 20                	jne    8031a8 <__umoddi3+0x98>
  803188:	39 d8                	cmp    %ebx,%eax
  80318a:	0f 82 b0 00 00 00    	jb     803240 <__umoddi3+0x130>
  803190:	39 f7                	cmp    %esi,%edi
  803192:	0f 86 a8 00 00 00    	jbe    803240 <__umoddi3+0x130>
  803198:	89 c8                	mov    %ecx,%eax
  80319a:	83 c4 1c             	add    $0x1c,%esp
  80319d:	5b                   	pop    %ebx
  80319e:	5e                   	pop    %esi
  80319f:	5f                   	pop    %edi
  8031a0:	5d                   	pop    %ebp
  8031a1:	c3                   	ret    
  8031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031a8:	89 e9                	mov    %ebp,%ecx
  8031aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8031af:	29 ea                	sub    %ebp,%edx
  8031b1:	d3 e0                	shl    %cl,%eax
  8031b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031b7:	89 d1                	mov    %edx,%ecx
  8031b9:	89 f8                	mov    %edi,%eax
  8031bb:	d3 e8                	shr    %cl,%eax
  8031bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031c9:	09 c1                	or     %eax,%ecx
  8031cb:	89 d8                	mov    %ebx,%eax
  8031cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e7                	shl    %cl,%edi
  8031d5:	89 d1                	mov    %edx,%ecx
  8031d7:	d3 e8                	shr    %cl,%eax
  8031d9:	89 e9                	mov    %ebp,%ecx
  8031db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031df:	d3 e3                	shl    %cl,%ebx
  8031e1:	89 c7                	mov    %eax,%edi
  8031e3:	89 d1                	mov    %edx,%ecx
  8031e5:	89 f0                	mov    %esi,%eax
  8031e7:	d3 e8                	shr    %cl,%eax
  8031e9:	89 e9                	mov    %ebp,%ecx
  8031eb:	89 fa                	mov    %edi,%edx
  8031ed:	d3 e6                	shl    %cl,%esi
  8031ef:	09 d8                	or     %ebx,%eax
  8031f1:	f7 74 24 08          	divl   0x8(%esp)
  8031f5:	89 d1                	mov    %edx,%ecx
  8031f7:	89 f3                	mov    %esi,%ebx
  8031f9:	f7 64 24 0c          	mull   0xc(%esp)
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	89 d7                	mov    %edx,%edi
  803201:	39 d1                	cmp    %edx,%ecx
  803203:	72 06                	jb     80320b <__umoddi3+0xfb>
  803205:	75 10                	jne    803217 <__umoddi3+0x107>
  803207:	39 c3                	cmp    %eax,%ebx
  803209:	73 0c                	jae    803217 <__umoddi3+0x107>
  80320b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80320f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803213:	89 d7                	mov    %edx,%edi
  803215:	89 c6                	mov    %eax,%esi
  803217:	89 ca                	mov    %ecx,%edx
  803219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80321e:	29 f3                	sub    %esi,%ebx
  803220:	19 fa                	sbb    %edi,%edx
  803222:	89 d0                	mov    %edx,%eax
  803224:	d3 e0                	shl    %cl,%eax
  803226:	89 e9                	mov    %ebp,%ecx
  803228:	d3 eb                	shr    %cl,%ebx
  80322a:	d3 ea                	shr    %cl,%edx
  80322c:	09 d8                	or     %ebx,%eax
  80322e:	83 c4 1c             	add    $0x1c,%esp
  803231:	5b                   	pop    %ebx
  803232:	5e                   	pop    %esi
  803233:	5f                   	pop    %edi
  803234:	5d                   	pop    %ebp
  803235:	c3                   	ret    
  803236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80323d:	8d 76 00             	lea    0x0(%esi),%esi
  803240:	89 da                	mov    %ebx,%edx
  803242:	29 fe                	sub    %edi,%esi
  803244:	19 c2                	sbb    %eax,%edx
  803246:	89 f1                	mov    %esi,%ecx
  803248:	89 c8                	mov    %ecx,%eax
  80324a:	e9 4b ff ff ff       	jmp    80319a <__umoddi3+0x8a>
