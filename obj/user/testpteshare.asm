
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
  800083:	e8 39 13 00 00       	call   8013c1 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 be 00 00 00    	js     800150 <umain+0xfd>
	if (r == 0) {
  800092:	0f 84 ca 00 00 00    	je     800162 <umain+0x10f>
	wait(r);
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	53                   	push   %ebx
  80009c:	e8 af 2b 00 00       	call   802c50 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	ff 35 04 40 80 00    	pushl  0x804004
  8000aa:	68 00 00 00 a0       	push   $0xa0000000
  8000af:	e8 9c 0a 00 00       	call   800b50 <strcmp>
  8000b4:	83 c4 08             	add    $0x8,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	b8 40 32 80 00       	mov    $0x803240,%eax
  8000be:	ba 46 32 80 00       	mov    $0x803246,%edx
  8000c3:	0f 45 c2             	cmovne %edx,%eax
  8000c6:	50                   	push   %eax
  8000c7:	68 7c 32 80 00       	push   $0x80327c
  8000cc:	e8 75 02 00 00       	call   800346 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d1:	6a 00                	push   $0x0
  8000d3:	68 97 32 80 00       	push   $0x803297
  8000d8:	68 9c 32 80 00       	push   $0x80329c
  8000dd:	68 9b 32 80 00       	push   $0x80329b
  8000e2:	e8 25 23 00 00       	call   80240c <spawnl>
  8000e7:	83 c4 20             	add    $0x20,%esp
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	0f 88 90 00 00 00    	js     800182 <umain+0x12f>
	wait(r);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	50                   	push   %eax
  8000f6:	e8 55 2b 00 00       	call   802c50 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fb:	83 c4 08             	add    $0x8,%esp
  8000fe:	ff 35 00 40 80 00    	pushl  0x804000
  800104:	68 00 00 00 a0       	push   $0xa0000000
  800109:	e8 42 0a 00 00       	call   800b50 <strcmp>
  80010e:	83 c4 08             	add    $0x8,%esp
  800111:	85 c0                	test   %eax,%eax
  800113:	b8 40 32 80 00       	mov    $0x803240,%eax
  800118:	ba 46 32 80 00       	mov    $0x803246,%edx
  80011d:	0f 45 c2             	cmovne %edx,%eax
  800120:	50                   	push   %eax
  800121:	68 b3 32 80 00       	push   $0x8032b3
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
  80013f:	68 4c 32 80 00       	push   $0x80324c
  800144:	6a 13                	push   $0x13
  800146:	68 5f 32 80 00       	push   $0x80325f
  80014b:	e8 00 01 00 00       	call   800250 <_panic>
		panic("fork: %e", r);
  800150:	50                   	push   %eax
  800151:	68 73 32 80 00       	push   $0x803273
  800156:	6a 17                	push   $0x17
  800158:	68 5f 32 80 00       	push   $0x80325f
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
  800183:	68 a9 32 80 00       	push   $0x8032a9
  800188:	6a 21                	push   $0x21
  80018a:	68 5f 32 80 00       	push   $0x80325f
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

	cprintf("in libmain.c call umain!\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 ed 32 80 00       	push   $0x8032ed
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
  80023c:	e8 ea 15 00 00       	call   80182b <close_all>
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
  800260:	68 40 33 80 00       	push   $0x803340
  800265:	50                   	push   %eax
  800266:	68 11 33 80 00       	push   $0x803311
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
  800289:	68 1c 33 80 00       	push   $0x80331c
  80028e:	e8 b3 00 00 00       	call   800346 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	53                   	push   %ebx
  800297:	ff 75 10             	pushl  0x10(%ebp)
  80029a:	e8 56 00 00 00       	call   8002f5 <vcprintf>
	cprintf("\n");
  80029f:	c7 04 24 05 33 80 00 	movl   $0x803305,(%esp)
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
  8003f3:	e8 e8 2b 00 00       	call   802fe0 <__udivdi3>
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
  80041c:	e8 cf 2c 00 00       	call   8030f0 <__umoddi3>
  800421:	83 c4 14             	add    $0x14,%esp
  800424:	0f be 80 47 33 80 00 	movsbl 0x803347(%eax),%eax
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
  8004cd:	ff 24 85 20 35 80 00 	jmp    *0x803520(,%eax,4)
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
  800598:	8b 14 85 80 36 80 00 	mov    0x803680(,%eax,4),%edx
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	74 18                	je     8005bb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005a3:	52                   	push   %edx
  8005a4:	68 89 38 80 00       	push   $0x803889
  8005a9:	53                   	push   %ebx
  8005aa:	56                   	push   %esi
  8005ab:	e8 a6 fe ff ff       	call   800456 <printfmt>
  8005b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b6:	e9 fe 02 00 00       	jmp    8008b9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005bb:	50                   	push   %eax
  8005bc:	68 5f 33 80 00       	push   $0x80335f
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
  8005e3:	b8 58 33 80 00       	mov    $0x803358,%eax
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
  80097b:	bf 7d 34 80 00       	mov    $0x80347d,%edi
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
  8009a7:	bf b5 34 80 00       	mov    $0x8034b5,%edi
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
  800e48:	68 c4 36 80 00       	push   $0x8036c4
  800e4d:	6a 43                	push   $0x43
  800e4f:	68 e1 36 80 00       	push   $0x8036e1
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
  800ec9:	68 c4 36 80 00       	push   $0x8036c4
  800ece:	6a 43                	push   $0x43
  800ed0:	68 e1 36 80 00       	push   $0x8036e1
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
  800f0b:	68 c4 36 80 00       	push   $0x8036c4
  800f10:	6a 43                	push   $0x43
  800f12:	68 e1 36 80 00       	push   $0x8036e1
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
  800f4d:	68 c4 36 80 00       	push   $0x8036c4
  800f52:	6a 43                	push   $0x43
  800f54:	68 e1 36 80 00       	push   $0x8036e1
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
  800f8f:	68 c4 36 80 00       	push   $0x8036c4
  800f94:	6a 43                	push   $0x43
  800f96:	68 e1 36 80 00       	push   $0x8036e1
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
  800fd1:	68 c4 36 80 00       	push   $0x8036c4
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 e1 36 80 00       	push   $0x8036e1
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
  801013:	68 c4 36 80 00       	push   $0x8036c4
  801018:	6a 43                	push   $0x43
  80101a:	68 e1 36 80 00       	push   $0x8036e1
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
  801077:	68 c4 36 80 00       	push   $0x8036c4
  80107c:	6a 43                	push   $0x43
  80107e:	68 e1 36 80 00       	push   $0x8036e1
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
  80115b:	68 c4 36 80 00       	push   $0x8036c4
  801160:	6a 43                	push   $0x43
  801162:	68 e1 36 80 00       	push   $0x8036e1
  801167:	e8 e4 f0 ff ff       	call   800250 <_panic>

0080116c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	53                   	push   %ebx
  801170:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  801173:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80117a:	f6 c5 04             	test   $0x4,%ch
  80117d:	75 45                	jne    8011c4 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  80117f:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801186:	83 e1 07             	and    $0x7,%ecx
  801189:	83 f9 07             	cmp    $0x7,%ecx
  80118c:	74 6f                	je     8011fd <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  80118e:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801195:	81 e1 05 08 00 00    	and    $0x805,%ecx
  80119b:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011a1:	0f 84 b6 00 00 00    	je     80125d <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011a7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ae:	83 e1 05             	and    $0x5,%ecx
  8011b1:	83 f9 05             	cmp    $0x5,%ecx
  8011b4:	0f 84 d7 00 00 00    	je     801291 <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8011c4:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cb:	c1 e2 0c             	shl    $0xc,%edx
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8011d7:	51                   	push   %ecx
  8011d8:	52                   	push   %edx
  8011d9:	50                   	push   %eax
  8011da:	52                   	push   %edx
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 f8 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8011e2:	83 c4 20             	add    $0x20,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 d1                	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	68 ef 36 80 00       	push   $0x8036ef
  8011f1:	6a 54                	push   $0x54
  8011f3:	68 05 37 80 00       	push   $0x803705
  8011f8:	e8 53 f0 ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011fd:	89 d3                	mov    %edx,%ebx
  8011ff:	c1 e3 0c             	shl    $0xc,%ebx
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	68 05 08 00 00       	push   $0x805
  80120a:	53                   	push   %ebx
  80120b:	50                   	push   %eax
  80120c:	53                   	push   %ebx
  80120d:	6a 00                	push   $0x0
  80120f:	e8 c6 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801214:	83 c4 20             	add    $0x20,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 2e                	js     801249 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	68 05 08 00 00       	push   $0x805
  801223:	53                   	push   %ebx
  801224:	6a 00                	push   $0x0
  801226:	53                   	push   %ebx
  801227:	6a 00                	push   $0x0
  801229:	e8 ac fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  80122e:	83 c4 20             	add    $0x20,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	79 85                	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	68 ef 36 80 00       	push   $0x8036ef
  80123d:	6a 5f                	push   $0x5f
  80123f:	68 05 37 80 00       	push   $0x803705
  801244:	e8 07 f0 ff ff       	call   800250 <_panic>
			panic("sys_page_map() panic\n");
  801249:	83 ec 04             	sub    $0x4,%esp
  80124c:	68 ef 36 80 00       	push   $0x8036ef
  801251:	6a 5b                	push   $0x5b
  801253:	68 05 37 80 00       	push   $0x803705
  801258:	e8 f3 ef ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80125d:	c1 e2 0c             	shl    $0xc,%edx
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	68 05 08 00 00       	push   $0x805
  801268:	52                   	push   %edx
  801269:	50                   	push   %eax
  80126a:	52                   	push   %edx
  80126b:	6a 00                	push   $0x0
  80126d:	e8 68 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  801272:	83 c4 20             	add    $0x20,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	0f 89 3d ff ff ff    	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80127d:	83 ec 04             	sub    $0x4,%esp
  801280:	68 ef 36 80 00       	push   $0x8036ef
  801285:	6a 66                	push   $0x66
  801287:	68 05 37 80 00       	push   $0x803705
  80128c:	e8 bf ef ff ff       	call   800250 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801291:	c1 e2 0c             	shl    $0xc,%edx
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	6a 05                	push   $0x5
  801299:	52                   	push   %edx
  80129a:	50                   	push   %eax
  80129b:	52                   	push   %edx
  80129c:	6a 00                	push   $0x0
  80129e:	e8 37 fc ff ff       	call   800eda <sys_page_map>
		if(r < 0)
  8012a3:	83 c4 20             	add    $0x20,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	0f 89 0c ff ff ff    	jns    8011ba <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	68 ef 36 80 00       	push   $0x8036ef
  8012b6:	6a 6d                	push   $0x6d
  8012b8:	68 05 37 80 00       	push   $0x803705
  8012bd:	e8 8e ef ff ff       	call   800250 <_panic>

008012c2 <pgfault>:
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8012cc:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ce:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8012d2:	0f 84 99 00 00 00    	je     801371 <pgfault+0xaf>
  8012d8:	89 c2                	mov    %eax,%edx
  8012da:	c1 ea 16             	shr    $0x16,%edx
  8012dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e4:	f6 c2 01             	test   $0x1,%dl
  8012e7:	0f 84 84 00 00 00    	je     801371 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8012ed:	89 c2                	mov    %eax,%edx
  8012ef:	c1 ea 0c             	shr    $0xc,%edx
  8012f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f9:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8012ff:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801305:	75 6a                	jne    801371 <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801307:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80130c:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	6a 07                	push   $0x7
  801313:	68 00 f0 7f 00       	push   $0x7ff000
  801318:	6a 00                	push   $0x0
  80131a:	e8 78 fb ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	78 5f                	js     801385 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801326:	83 ec 04             	sub    $0x4,%esp
  801329:	68 00 10 00 00       	push   $0x1000
  80132e:	53                   	push   %ebx
  80132f:	68 00 f0 7f 00       	push   $0x7ff000
  801334:	e8 5c f9 ff ff       	call   800c95 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801339:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801340:	53                   	push   %ebx
  801341:	6a 00                	push   $0x0
  801343:	68 00 f0 7f 00       	push   $0x7ff000
  801348:	6a 00                	push   $0x0
  80134a:	e8 8b fb ff ff       	call   800eda <sys_page_map>
	if(ret < 0)
  80134f:	83 c4 20             	add    $0x20,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 43                	js     801399 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801356:	83 ec 08             	sub    $0x8,%esp
  801359:	68 00 f0 7f 00       	push   $0x7ff000
  80135e:	6a 00                	push   $0x0
  801360:	e8 b7 fb ff ff       	call   800f1c <sys_page_unmap>
	if(ret < 0)
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	78 41                	js     8013ad <pgfault+0xeb>
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
		panic("panic at pgfault()\n");
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	68 10 37 80 00       	push   $0x803710
  801379:	6a 26                	push   $0x26
  80137b:	68 05 37 80 00       	push   $0x803705
  801380:	e8 cb ee ff ff       	call   800250 <_panic>
		panic("panic in sys_page_alloc()\n");
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 24 37 80 00       	push   $0x803724
  80138d:	6a 31                	push   $0x31
  80138f:	68 05 37 80 00       	push   $0x803705
  801394:	e8 b7 ee ff ff       	call   800250 <_panic>
		panic("panic in sys_page_map()\n");
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	68 3f 37 80 00       	push   $0x80373f
  8013a1:	6a 36                	push   $0x36
  8013a3:	68 05 37 80 00       	push   $0x803705
  8013a8:	e8 a3 ee ff ff       	call   800250 <_panic>
		panic("panic in sys_page_unmap()\n");
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 58 37 80 00       	push   $0x803758
  8013b5:	6a 39                	push   $0x39
  8013b7:	68 05 37 80 00       	push   $0x803705
  8013bc:	e8 8f ee ff ff       	call   800250 <_panic>

008013c1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	57                   	push   %edi
  8013c5:	56                   	push   %esi
  8013c6:	53                   	push   %ebx
  8013c7:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8013ca:	68 c2 12 80 00       	push   $0x8012c2
  8013cf:	e8 40 1a 00 00       	call   802e14 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8013d4:	b8 07 00 00 00       	mov    $0x7,%eax
  8013d9:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 27                	js     801409 <fork+0x48>
  8013e2:	89 c6                	mov    %eax,%esi
  8013e4:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8013e6:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  8013eb:	75 48                	jne    801435 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  8013ed:	e8 67 fa ff ff       	call   800e59 <sys_getenvid>
  8013f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013f7:	c1 e0 07             	shl    $0x7,%eax
  8013fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ff:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801404:	e9 90 00 00 00       	jmp    801499 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	68 74 37 80 00       	push   $0x803774
  801411:	68 8c 00 00 00       	push   $0x8c
  801416:	68 05 37 80 00       	push   $0x803705
  80141b:	e8 30 ee ff ff       	call   800250 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801420:	89 f8                	mov    %edi,%eax
  801422:	e8 45 fd ff ff       	call   80116c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80142d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801433:	74 26                	je     80145b <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801435:	89 d8                	mov    %ebx,%eax
  801437:	c1 e8 16             	shr    $0x16,%eax
  80143a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801441:	a8 01                	test   $0x1,%al
  801443:	74 e2                	je     801427 <fork+0x66>
  801445:	89 da                	mov    %ebx,%edx
  801447:	c1 ea 0c             	shr    $0xc,%edx
  80144a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801451:	83 e0 05             	and    $0x5,%eax
  801454:	83 f8 05             	cmp    $0x5,%eax
  801457:	75 ce                	jne    801427 <fork+0x66>
  801459:	eb c5                	jmp    801420 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	6a 07                	push   $0x7
  801460:	68 00 f0 bf ee       	push   $0xeebff000
  801465:	56                   	push   %esi
  801466:	e8 2c fa ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  80146b:	83 c4 10             	add    $0x10,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 31                	js     8014a3 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	68 83 2e 80 00       	push   $0x802e83
  80147a:	56                   	push   %esi
  80147b:	e8 62 fb ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	85 c0                	test   %eax,%eax
  801485:	78 33                	js     8014ba <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801487:	83 ec 08             	sub    $0x8,%esp
  80148a:	6a 02                	push   $0x2
  80148c:	56                   	push   %esi
  80148d:	e8 cc fa ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 38                	js     8014d1 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  801499:	89 f0                	mov    %esi,%eax
  80149b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5f                   	pop    %edi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 24 37 80 00       	push   $0x803724
  8014ab:	68 98 00 00 00       	push   $0x98
  8014b0:	68 05 37 80 00       	push   $0x803705
  8014b5:	e8 96 ed ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	68 98 37 80 00       	push   $0x803798
  8014c2:	68 9b 00 00 00       	push   $0x9b
  8014c7:	68 05 37 80 00       	push   $0x803705
  8014cc:	e8 7f ed ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_status()\n");
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 c0 37 80 00       	push   $0x8037c0
  8014d9:	68 9e 00 00 00       	push   $0x9e
  8014de:	68 05 37 80 00       	push   $0x803705
  8014e3:	e8 68 ed ff ff       	call   800250 <_panic>

008014e8 <sfork>:

// Challenge!
int
sfork(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	57                   	push   %edi
  8014ec:	56                   	push   %esi
  8014ed:	53                   	push   %ebx
  8014ee:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  8014f1:	68 c2 12 80 00       	push   $0x8012c2
  8014f6:	e8 19 19 00 00       	call   802e14 <set_pgfault_handler>
  8014fb:	b8 07 00 00 00       	mov    $0x7,%eax
  801500:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	85 c0                	test   %eax,%eax
  801507:	78 27                	js     801530 <sfork+0x48>
  801509:	89 c7                	mov    %eax,%edi
  80150b:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80150d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801512:	75 55                	jne    801569 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801514:	e8 40 f9 ff ff       	call   800e59 <sys_getenvid>
  801519:	25 ff 03 00 00       	and    $0x3ff,%eax
  80151e:	c1 e0 07             	shl    $0x7,%eax
  801521:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801526:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80152b:	e9 d4 00 00 00       	jmp    801604 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	68 74 37 80 00       	push   $0x803774
  801538:	68 af 00 00 00       	push   $0xaf
  80153d:	68 05 37 80 00       	push   $0x803705
  801542:	e8 09 ed ff ff       	call   800250 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801547:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80154c:	89 f0                	mov    %esi,%eax
  80154e:	e8 19 fc ff ff       	call   80116c <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801553:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801559:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80155f:	77 65                	ja     8015c6 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  801561:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801567:	74 de                	je     801547 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801569:	89 d8                	mov    %ebx,%eax
  80156b:	c1 e8 16             	shr    $0x16,%eax
  80156e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801575:	a8 01                	test   $0x1,%al
  801577:	74 da                	je     801553 <sfork+0x6b>
  801579:	89 da                	mov    %ebx,%edx
  80157b:	c1 ea 0c             	shr    $0xc,%edx
  80157e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801585:	83 e0 05             	and    $0x5,%eax
  801588:	83 f8 05             	cmp    $0x5,%eax
  80158b:	75 c6                	jne    801553 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  80158d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  801594:	c1 e2 0c             	shl    $0xc,%edx
  801597:	83 ec 0c             	sub    $0xc,%esp
  80159a:	83 e0 07             	and    $0x7,%eax
  80159d:	50                   	push   %eax
  80159e:	52                   	push   %edx
  80159f:	56                   	push   %esi
  8015a0:	52                   	push   %edx
  8015a1:	6a 00                	push   $0x0
  8015a3:	e8 32 f9 ff ff       	call   800eda <sys_page_map>
  8015a8:	83 c4 20             	add    $0x20,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	74 a4                	je     801553 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	68 ef 36 80 00       	push   $0x8036ef
  8015b7:	68 ba 00 00 00       	push   $0xba
  8015bc:	68 05 37 80 00       	push   $0x803705
  8015c1:	e8 8a ec ff ff       	call   800250 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	6a 07                	push   $0x7
  8015cb:	68 00 f0 bf ee       	push   $0xeebff000
  8015d0:	57                   	push   %edi
  8015d1:	e8 c1 f8 ff ff       	call   800e97 <sys_page_alloc>
	if(ret < 0)
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	78 31                	js     80160e <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	68 83 2e 80 00       	push   $0x802e83
  8015e5:	57                   	push   %edi
  8015e6:	e8 f7 f9 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 33                	js     801625 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	6a 02                	push   $0x2
  8015f7:	57                   	push   %edi
  8015f8:	e8 61 f9 ff ff       	call   800f5e <sys_env_set_status>
	if(ret < 0)
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	85 c0                	test   %eax,%eax
  801602:	78 38                	js     80163c <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801604:	89 f8                	mov    %edi,%eax
  801606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5f                   	pop    %edi
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	68 24 37 80 00       	push   $0x803724
  801616:	68 c0 00 00 00       	push   $0xc0
  80161b:	68 05 37 80 00       	push   $0x803705
  801620:	e8 2b ec ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	68 98 37 80 00       	push   $0x803798
  80162d:	68 c3 00 00 00       	push   $0xc3
  801632:	68 05 37 80 00       	push   $0x803705
  801637:	e8 14 ec ff ff       	call   800250 <_panic>
		panic("panic in sys_env_set_status()\n");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 c0 37 80 00       	push   $0x8037c0
  801644:	68 c6 00 00 00       	push   $0xc6
  801649:	68 05 37 80 00       	push   $0x803705
  80164e:	e8 fd eb ff ff       	call   800250 <_panic>

00801653 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	05 00 00 00 30       	add    $0x30000000,%eax
  80165e:	c1 e8 0c             	shr    $0xc,%eax
}
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    

00801663 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80166e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801673:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801682:	89 c2                	mov    %eax,%edx
  801684:	c1 ea 16             	shr    $0x16,%edx
  801687:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80168e:	f6 c2 01             	test   $0x1,%dl
  801691:	74 2d                	je     8016c0 <fd_alloc+0x46>
  801693:	89 c2                	mov    %eax,%edx
  801695:	c1 ea 0c             	shr    $0xc,%edx
  801698:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80169f:	f6 c2 01             	test   $0x1,%dl
  8016a2:	74 1c                	je     8016c0 <fd_alloc+0x46>
  8016a4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016a9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016ae:	75 d2                	jne    801682 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016b9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016be:	eb 0a                	jmp    8016ca <fd_alloc+0x50>
			*fd_store = fd;
  8016c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016d2:	83 f8 1f             	cmp    $0x1f,%eax
  8016d5:	77 30                	ja     801707 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016d7:	c1 e0 0c             	shl    $0xc,%eax
  8016da:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016df:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8016e5:	f6 c2 01             	test   $0x1,%dl
  8016e8:	74 24                	je     80170e <fd_lookup+0x42>
  8016ea:	89 c2                	mov    %eax,%edx
  8016ec:	c1 ea 0c             	shr    $0xc,%edx
  8016ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f6:	f6 c2 01             	test   $0x1,%dl
  8016f9:	74 1a                	je     801715 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801700:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    
		return -E_INVAL;
  801707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170c:	eb f7                	jmp    801705 <fd_lookup+0x39>
		return -E_INVAL;
  80170e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801713:	eb f0                	jmp    801705 <fd_lookup+0x39>
  801715:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171a:	eb e9                	jmp    801705 <fd_lookup+0x39>

0080171c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801725:	ba 00 00 00 00       	mov    $0x0,%edx
  80172a:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80172f:	39 08                	cmp    %ecx,(%eax)
  801731:	74 38                	je     80176b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801733:	83 c2 01             	add    $0x1,%edx
  801736:	8b 04 95 5c 38 80 00 	mov    0x80385c(,%edx,4),%eax
  80173d:	85 c0                	test   %eax,%eax
  80173f:	75 ee                	jne    80172f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801741:	a1 08 50 80 00       	mov    0x805008,%eax
  801746:	8b 40 48             	mov    0x48(%eax),%eax
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	51                   	push   %ecx
  80174d:	50                   	push   %eax
  80174e:	68 e0 37 80 00       	push   $0x8037e0
  801753:	e8 ee eb ff ff       	call   800346 <cprintf>
	*dev = 0;
  801758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    
			*dev = devtab[i];
  80176b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80176e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
  801775:	eb f2                	jmp    801769 <dev_lookup+0x4d>

00801777 <fd_close>:
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	57                   	push   %edi
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
  80177d:	83 ec 24             	sub    $0x24,%esp
  801780:	8b 75 08             	mov    0x8(%ebp),%esi
  801783:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801786:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801789:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80178a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801790:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801793:	50                   	push   %eax
  801794:	e8 33 ff ff ff       	call   8016cc <fd_lookup>
  801799:	89 c3                	mov    %eax,%ebx
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 05                	js     8017a7 <fd_close+0x30>
	    || fd != fd2)
  8017a2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017a5:	74 16                	je     8017bd <fd_close+0x46>
		return (must_exist ? r : 0);
  8017a7:	89 f8                	mov    %edi,%eax
  8017a9:	84 c0                	test   %al,%al
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b0:	0f 44 d8             	cmove  %eax,%ebx
}
  8017b3:	89 d8                	mov    %ebx,%eax
  8017b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b8:	5b                   	pop    %ebx
  8017b9:	5e                   	pop    %esi
  8017ba:	5f                   	pop    %edi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017bd:	83 ec 08             	sub    $0x8,%esp
  8017c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017c3:	50                   	push   %eax
  8017c4:	ff 36                	pushl  (%esi)
  8017c6:	e8 51 ff ff ff       	call   80171c <dev_lookup>
  8017cb:	89 c3                	mov    %eax,%ebx
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 1a                	js     8017ee <fd_close+0x77>
		if (dev->dev_close)
  8017d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017da:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	74 0b                	je     8017ee <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	56                   	push   %esi
  8017e7:	ff d0                	call   *%eax
  8017e9:	89 c3                	mov    %eax,%ebx
  8017eb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	56                   	push   %esi
  8017f2:	6a 00                	push   $0x0
  8017f4:	e8 23 f7 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	eb b5                	jmp    8017b3 <fd_close+0x3c>

008017fe <close>:

int
close(int fdnum)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801804:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801807:	50                   	push   %eax
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	e8 bc fe ff ff       	call   8016cc <fd_lookup>
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	85 c0                	test   %eax,%eax
  801815:	79 02                	jns    801819 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    
		return fd_close(fd, 1);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	6a 01                	push   $0x1
  80181e:	ff 75 f4             	pushl  -0xc(%ebp)
  801821:	e8 51 ff ff ff       	call   801777 <fd_close>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	eb ec                	jmp    801817 <close+0x19>

0080182b <close_all>:

void
close_all(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	53                   	push   %ebx
  80182f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801832:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	53                   	push   %ebx
  80183b:	e8 be ff ff ff       	call   8017fe <close>
	for (i = 0; i < MAXFD; i++)
  801840:	83 c3 01             	add    $0x1,%ebx
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	83 fb 20             	cmp    $0x20,%ebx
  801849:	75 ec                	jne    801837 <close_all+0xc>
}
  80184b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	57                   	push   %edi
  801854:	56                   	push   %esi
  801855:	53                   	push   %ebx
  801856:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801859:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	e8 67 fe ff ff       	call   8016cc <fd_lookup>
  801865:	89 c3                	mov    %eax,%ebx
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	0f 88 81 00 00 00    	js     8018f3 <dup+0xa3>
		return r;
	close(newfdnum);
  801872:	83 ec 0c             	sub    $0xc,%esp
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	e8 81 ff ff ff       	call   8017fe <close>

	newfd = INDEX2FD(newfdnum);
  80187d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801880:	c1 e6 0c             	shl    $0xc,%esi
  801883:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801889:	83 c4 04             	add    $0x4,%esp
  80188c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80188f:	e8 cf fd ff ff       	call   801663 <fd2data>
  801894:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801896:	89 34 24             	mov    %esi,(%esp)
  801899:	e8 c5 fd ff ff       	call   801663 <fd2data>
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	c1 e8 16             	shr    $0x16,%eax
  8018a8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018af:	a8 01                	test   $0x1,%al
  8018b1:	74 11                	je     8018c4 <dup+0x74>
  8018b3:	89 d8                	mov    %ebx,%eax
  8018b5:	c1 e8 0c             	shr    $0xc,%eax
  8018b8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018bf:	f6 c2 01             	test   $0x1,%dl
  8018c2:	75 39                	jne    8018fd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	c1 e8 0c             	shr    $0xc,%eax
  8018cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018d3:	83 ec 0c             	sub    $0xc,%esp
  8018d6:	25 07 0e 00 00       	and    $0xe07,%eax
  8018db:	50                   	push   %eax
  8018dc:	56                   	push   %esi
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 f3 f5 ff ff       	call   800eda <sys_page_map>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 20             	add    $0x20,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 31                	js     801921 <dup+0xd1>
		goto err;

	return newfdnum;
  8018f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8018f3:	89 d8                	mov    %ebx,%eax
  8018f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5f                   	pop    %edi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801904:	83 ec 0c             	sub    $0xc,%esp
  801907:	25 07 0e 00 00       	and    $0xe07,%eax
  80190c:	50                   	push   %eax
  80190d:	57                   	push   %edi
  80190e:	6a 00                	push   $0x0
  801910:	53                   	push   %ebx
  801911:	6a 00                	push   $0x0
  801913:	e8 c2 f5 ff ff       	call   800eda <sys_page_map>
  801918:	89 c3                	mov    %eax,%ebx
  80191a:	83 c4 20             	add    $0x20,%esp
  80191d:	85 c0                	test   %eax,%eax
  80191f:	79 a3                	jns    8018c4 <dup+0x74>
	sys_page_unmap(0, newfd);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	56                   	push   %esi
  801925:	6a 00                	push   $0x0
  801927:	e8 f0 f5 ff ff       	call   800f1c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80192c:	83 c4 08             	add    $0x8,%esp
  80192f:	57                   	push   %edi
  801930:	6a 00                	push   $0x0
  801932:	e8 e5 f5 ff ff       	call   800f1c <sys_page_unmap>
	return r;
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	eb b7                	jmp    8018f3 <dup+0xa3>

0080193c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	53                   	push   %ebx
  801940:	83 ec 1c             	sub    $0x1c,%esp
  801943:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801946:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801949:	50                   	push   %eax
  80194a:	53                   	push   %ebx
  80194b:	e8 7c fd ff ff       	call   8016cc <fd_lookup>
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	85 c0                	test   %eax,%eax
  801955:	78 3f                	js     801996 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801957:	83 ec 08             	sub    $0x8,%esp
  80195a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195d:	50                   	push   %eax
  80195e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801961:	ff 30                	pushl  (%eax)
  801963:	e8 b4 fd ff ff       	call   80171c <dev_lookup>
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 27                	js     801996 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80196f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801972:	8b 42 08             	mov    0x8(%edx),%eax
  801975:	83 e0 03             	and    $0x3,%eax
  801978:	83 f8 01             	cmp    $0x1,%eax
  80197b:	74 1e                	je     80199b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 40 08             	mov    0x8(%eax),%eax
  801983:	85 c0                	test   %eax,%eax
  801985:	74 35                	je     8019bc <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801987:	83 ec 04             	sub    $0x4,%esp
  80198a:	ff 75 10             	pushl  0x10(%ebp)
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	52                   	push   %edx
  801991:	ff d0                	call   *%eax
  801993:	83 c4 10             	add    $0x10,%esp
}
  801996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801999:	c9                   	leave  
  80199a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80199b:	a1 08 50 80 00       	mov    0x805008,%eax
  8019a0:	8b 40 48             	mov    0x48(%eax),%eax
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	53                   	push   %ebx
  8019a7:	50                   	push   %eax
  8019a8:	68 21 38 80 00       	push   $0x803821
  8019ad:	e8 94 e9 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ba:	eb da                	jmp    801996 <read+0x5a>
		return -E_NOT_SUPP;
  8019bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c1:	eb d3                	jmp    801996 <read+0x5a>

008019c3 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	57                   	push   %edi
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019cf:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d7:	39 f3                	cmp    %esi,%ebx
  8019d9:	73 23                	jae    8019fe <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019db:	83 ec 04             	sub    $0x4,%esp
  8019de:	89 f0                	mov    %esi,%eax
  8019e0:	29 d8                	sub    %ebx,%eax
  8019e2:	50                   	push   %eax
  8019e3:	89 d8                	mov    %ebx,%eax
  8019e5:	03 45 0c             	add    0xc(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	57                   	push   %edi
  8019ea:	e8 4d ff ff ff       	call   80193c <read>
		if (m < 0)
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 06                	js     8019fc <readn+0x39>
			return m;
		if (m == 0)
  8019f6:	74 06                	je     8019fe <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8019f8:	01 c3                	add    %eax,%ebx
  8019fa:	eb db                	jmp    8019d7 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019fc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8019fe:	89 d8                	mov    %ebx,%eax
  801a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    

00801a08 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 1c             	sub    $0x1c,%esp
  801a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a15:	50                   	push   %eax
  801a16:	53                   	push   %ebx
  801a17:	e8 b0 fc ff ff       	call   8016cc <fd_lookup>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 3a                	js     801a5d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a29:	50                   	push   %eax
  801a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2d:	ff 30                	pushl  (%eax)
  801a2f:	e8 e8 fc ff ff       	call   80171c <dev_lookup>
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 22                	js     801a5d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a42:	74 1e                	je     801a62 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a47:	8b 52 0c             	mov    0xc(%edx),%edx
  801a4a:	85 d2                	test   %edx,%edx
  801a4c:	74 35                	je     801a83 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	ff d2                	call   *%edx
  801a5a:	83 c4 10             	add    $0x10,%esp
}
  801a5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a62:	a1 08 50 80 00       	mov    0x805008,%eax
  801a67:	8b 40 48             	mov    0x48(%eax),%eax
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	53                   	push   %ebx
  801a6e:	50                   	push   %eax
  801a6f:	68 3d 38 80 00       	push   $0x80383d
  801a74:	e8 cd e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a81:	eb da                	jmp    801a5d <write+0x55>
		return -E_NOT_SUPP;
  801a83:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a88:	eb d3                	jmp    801a5d <write+0x55>

00801a8a <seek>:

int
seek(int fdnum, off_t offset)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a90:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a93:	50                   	push   %eax
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	e8 30 fc ff ff       	call   8016cc <fd_lookup>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 0e                	js     801ab1 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 1c             	sub    $0x1c,%esp
  801aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac0:	50                   	push   %eax
  801ac1:	53                   	push   %ebx
  801ac2:	e8 05 fc ff ff       	call   8016cc <fd_lookup>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 37                	js     801b05 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad8:	ff 30                	pushl  (%eax)
  801ada:	e8 3d fc ff ff       	call   80171c <dev_lookup>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 1f                	js     801b05 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801aed:	74 1b                	je     801b0a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	8b 52 18             	mov    0x18(%edx),%edx
  801af5:	85 d2                	test   %edx,%edx
  801af7:	74 32                	je     801b2b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	50                   	push   %eax
  801b00:	ff d2                	call   *%edx
  801b02:	83 c4 10             	add    $0x10,%esp
}
  801b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b0a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b0f:	8b 40 48             	mov    0x48(%eax),%eax
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	53                   	push   %ebx
  801b16:	50                   	push   %eax
  801b17:	68 00 38 80 00       	push   $0x803800
  801b1c:	e8 25 e8 ff ff       	call   800346 <cprintf>
		return -E_INVAL;
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b29:	eb da                	jmp    801b05 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b30:	eb d3                	jmp    801b05 <ftruncate+0x52>

00801b32 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
  801b36:	83 ec 1c             	sub    $0x1c,%esp
  801b39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b3c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b3f:	50                   	push   %eax
  801b40:	ff 75 08             	pushl  0x8(%ebp)
  801b43:	e8 84 fb ff ff       	call   8016cc <fd_lookup>
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 4b                	js     801b9a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b55:	50                   	push   %eax
  801b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b59:	ff 30                	pushl  (%eax)
  801b5b:	e8 bc fb ff ff       	call   80171c <dev_lookup>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 33                	js     801b9a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b6e:	74 2f                	je     801b9f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b70:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b73:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b7a:	00 00 00 
	stat->st_isdir = 0;
  801b7d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b84:	00 00 00 
	stat->st_dev = dev;
  801b87:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b8d:	83 ec 08             	sub    $0x8,%esp
  801b90:	53                   	push   %ebx
  801b91:	ff 75 f0             	pushl  -0x10(%ebp)
  801b94:	ff 50 14             	call   *0x14(%eax)
  801b97:	83 c4 10             	add    $0x10,%esp
}
  801b9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    
		return -E_NOT_SUPP;
  801b9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba4:	eb f4                	jmp    801b9a <fstat+0x68>

00801ba6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	56                   	push   %esi
  801baa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bab:	83 ec 08             	sub    $0x8,%esp
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	e8 22 02 00 00       	call   801dda <open>
  801bb8:	89 c3                	mov    %eax,%ebx
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 1b                	js     801bdc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bc1:	83 ec 08             	sub    $0x8,%esp
  801bc4:	ff 75 0c             	pushl  0xc(%ebp)
  801bc7:	50                   	push   %eax
  801bc8:	e8 65 ff ff ff       	call   801b32 <fstat>
  801bcd:	89 c6                	mov    %eax,%esi
	close(fd);
  801bcf:	89 1c 24             	mov    %ebx,(%esp)
  801bd2:	e8 27 fc ff ff       	call   8017fe <close>
	return r;
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	89 f3                	mov    %esi,%ebx
}
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	89 c6                	mov    %eax,%esi
  801bec:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bee:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bf5:	74 27                	je     801c1e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bf7:	6a 07                	push   $0x7
  801bf9:	68 00 60 80 00       	push   $0x806000
  801bfe:	56                   	push   %esi
  801bff:	ff 35 00 50 80 00    	pushl  0x805000
  801c05:	e8 08 13 00 00       	call   802f12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c0a:	83 c4 0c             	add    $0xc,%esp
  801c0d:	6a 00                	push   $0x0
  801c0f:	53                   	push   %ebx
  801c10:	6a 00                	push   $0x0
  801c12:	e8 92 12 00 00       	call   802ea9 <ipc_recv>
}
  801c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	6a 01                	push   $0x1
  801c23:	e8 42 13 00 00       	call   802f6a <ipc_find_env>
  801c28:	a3 00 50 80 00       	mov    %eax,0x805000
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	eb c5                	jmp    801bf7 <fsipc+0x12>

00801c32 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c46:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c50:	b8 02 00 00 00       	mov    $0x2,%eax
  801c55:	e8 8b ff ff ff       	call   801be5 <fsipc>
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <devfile_flush>:
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	8b 40 0c             	mov    0xc(%eax),%eax
  801c68:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c72:	b8 06 00 00 00       	mov    $0x6,%eax
  801c77:	e8 69 ff ff ff       	call   801be5 <fsipc>
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <devfile_stat>:
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	53                   	push   %ebx
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c93:	ba 00 00 00 00       	mov    $0x0,%edx
  801c98:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9d:	e8 43 ff ff ff       	call   801be5 <fsipc>
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	78 2c                	js     801cd2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ca6:	83 ec 08             	sub    $0x8,%esp
  801ca9:	68 00 60 80 00       	push   $0x806000
  801cae:	53                   	push   %ebx
  801caf:	e8 f1 ed ff ff       	call   800aa5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cb4:	a1 80 60 80 00       	mov    0x806080,%eax
  801cb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cbf:	a1 84 60 80 00       	mov    0x806084,%eax
  801cc4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <devfile_write>:
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801cec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801cf2:	53                   	push   %ebx
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	68 08 60 80 00       	push   $0x806008
  801cfb:	e8 95 ef ff ff       	call   800c95 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d00:	ba 00 00 00 00       	mov    $0x0,%edx
  801d05:	b8 04 00 00 00       	mov    $0x4,%eax
  801d0a:	e8 d6 fe ff ff       	call   801be5 <fsipc>
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 0b                	js     801d21 <devfile_write+0x4a>
	assert(r <= n);
  801d16:	39 d8                	cmp    %ebx,%eax
  801d18:	77 0c                	ja     801d26 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d1f:	7f 1e                	jg     801d3f <devfile_write+0x68>
}
  801d21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    
	assert(r <= n);
  801d26:	68 70 38 80 00       	push   $0x803870
  801d2b:	68 77 38 80 00       	push   $0x803877
  801d30:	68 98 00 00 00       	push   $0x98
  801d35:	68 8c 38 80 00       	push   $0x80388c
  801d3a:	e8 11 e5 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801d3f:	68 97 38 80 00       	push   $0x803897
  801d44:	68 77 38 80 00       	push   $0x803877
  801d49:	68 99 00 00 00       	push   $0x99
  801d4e:	68 8c 38 80 00       	push   $0x80388c
  801d53:	e8 f8 e4 ff ff       	call   800250 <_panic>

00801d58 <devfile_read>:
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	8b 40 0c             	mov    0xc(%eax),%eax
  801d66:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d6b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d71:	ba 00 00 00 00       	mov    $0x0,%edx
  801d76:	b8 03 00 00 00       	mov    $0x3,%eax
  801d7b:	e8 65 fe ff ff       	call   801be5 <fsipc>
  801d80:	89 c3                	mov    %eax,%ebx
  801d82:	85 c0                	test   %eax,%eax
  801d84:	78 1f                	js     801da5 <devfile_read+0x4d>
	assert(r <= n);
  801d86:	39 f0                	cmp    %esi,%eax
  801d88:	77 24                	ja     801dae <devfile_read+0x56>
	assert(r <= PGSIZE);
  801d8a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d8f:	7f 33                	jg     801dc4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	50                   	push   %eax
  801d95:	68 00 60 80 00       	push   $0x806000
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	e8 91 ee ff ff       	call   800c33 <memmove>
	return r;
  801da2:	83 c4 10             	add    $0x10,%esp
}
  801da5:	89 d8                	mov    %ebx,%eax
  801da7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    
	assert(r <= n);
  801dae:	68 70 38 80 00       	push   $0x803870
  801db3:	68 77 38 80 00       	push   $0x803877
  801db8:	6a 7c                	push   $0x7c
  801dba:	68 8c 38 80 00       	push   $0x80388c
  801dbf:	e8 8c e4 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801dc4:	68 97 38 80 00       	push   $0x803897
  801dc9:	68 77 38 80 00       	push   $0x803877
  801dce:	6a 7d                	push   $0x7d
  801dd0:	68 8c 38 80 00       	push   $0x80388c
  801dd5:	e8 76 e4 ff ff       	call   800250 <_panic>

00801dda <open>:
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 1c             	sub    $0x1c,%esp
  801de2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801de5:	56                   	push   %esi
  801de6:	e8 81 ec ff ff       	call   800a6c <strlen>
  801deb:	83 c4 10             	add    $0x10,%esp
  801dee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801df3:	7f 6c                	jg     801e61 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfb:	50                   	push   %eax
  801dfc:	e8 79 f8 ff ff       	call   80167a <fd_alloc>
  801e01:	89 c3                	mov    %eax,%ebx
  801e03:	83 c4 10             	add    $0x10,%esp
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 3c                	js     801e46 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e0a:	83 ec 08             	sub    $0x8,%esp
  801e0d:	56                   	push   %esi
  801e0e:	68 00 60 80 00       	push   $0x806000
  801e13:	e8 8d ec ff ff       	call   800aa5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e23:	b8 01 00 00 00       	mov    $0x1,%eax
  801e28:	e8 b8 fd ff ff       	call   801be5 <fsipc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 19                	js     801e4f <open+0x75>
	return fd2num(fd);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3c:	e8 12 f8 ff ff       	call   801653 <fd2num>
  801e41:	89 c3                	mov    %eax,%ebx
  801e43:	83 c4 10             	add    $0x10,%esp
}
  801e46:	89 d8                	mov    %ebx,%eax
  801e48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
		fd_close(fd, 0);
  801e4f:	83 ec 08             	sub    $0x8,%esp
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 f4             	pushl  -0xc(%ebp)
  801e57:	e8 1b f9 ff ff       	call   801777 <fd_close>
		return r;
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	eb e5                	jmp    801e46 <open+0x6c>
		return -E_BAD_PATH;
  801e61:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e66:	eb de                	jmp    801e46 <open+0x6c>

00801e68 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e73:	b8 08 00 00 00       	mov    $0x8,%eax
  801e78:	e8 68 fd ff ff       	call   801be5 <fsipc>
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	57                   	push   %edi
  801e83:	56                   	push   %esi
  801e84:	53                   	push   %ebx
  801e85:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e8b:	68 7c 39 80 00       	push   $0x80397c
  801e90:	68 15 33 80 00       	push   $0x803315
  801e95:	e8 ac e4 ff ff       	call   800346 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e9a:	83 c4 08             	add    $0x8,%esp
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	e8 33 ff ff ff       	call   801dda <open>
  801ea7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	0f 88 0a 05 00 00    	js     8023c2 <spawn+0x543>
  801eb8:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	68 00 02 00 00       	push   $0x200
  801ec2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801ec8:	50                   	push   %eax
  801ec9:	51                   	push   %ecx
  801eca:	e8 f4 fa ff ff       	call   8019c3 <readn>
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ed7:	75 74                	jne    801f4d <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801ed9:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ee0:	45 4c 46 
  801ee3:	75 68                	jne    801f4d <spawn+0xce>
  801ee5:	b8 07 00 00 00       	mov    $0x7,%eax
  801eea:	cd 30                	int    $0x30
  801eec:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801ef2:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 b6 04 00 00    	js     8023b6 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f00:	25 ff 03 00 00       	and    $0x3ff,%eax
  801f05:	89 c6                	mov    %eax,%esi
  801f07:	c1 e6 07             	shl    $0x7,%esi
  801f0a:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f10:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f16:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f1d:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f23:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801f29:	83 ec 08             	sub    $0x8,%esp
  801f2c:	68 70 39 80 00       	push   $0x803970
  801f31:	68 15 33 80 00       	push   $0x803315
  801f36:	e8 0b e4 ff ff       	call   800346 <cprintf>
  801f3b:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f3e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801f43:	be 00 00 00 00       	mov    $0x0,%esi
  801f48:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801f4b:	eb 4b                	jmp    801f98 <spawn+0x119>
		close(fd);
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f56:	e8 a3 f8 ff ff       	call   8017fe <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f5b:	83 c4 0c             	add    $0xc,%esp
  801f5e:	68 7f 45 4c 46       	push   $0x464c457f
  801f63:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f69:	68 a3 38 80 00       	push   $0x8038a3
  801f6e:	e8 d3 e3 ff ff       	call   800346 <cprintf>
		return -E_NOT_EXEC;
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f7d:	ff ff ff 
  801f80:	e9 3d 04 00 00       	jmp    8023c2 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	50                   	push   %eax
  801f89:	e8 de ea ff ff       	call   800a6c <strlen>
  801f8e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801f92:	83 c3 01             	add    $0x1,%ebx
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801f9f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	75 df                	jne    801f85 <spawn+0x106>
  801fa6:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801fac:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801fb2:	bf 00 10 40 00       	mov    $0x401000,%edi
  801fb7:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801fb9:	89 fa                	mov    %edi,%edx
  801fbb:	83 e2 fc             	and    $0xfffffffc,%edx
  801fbe:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801fc5:	29 c2                	sub    %eax,%edx
  801fc7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801fcd:	8d 42 f8             	lea    -0x8(%edx),%eax
  801fd0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801fd5:	0f 86 0a 04 00 00    	jbe    8023e5 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	6a 07                	push   $0x7
  801fe0:	68 00 00 40 00       	push   $0x400000
  801fe5:	6a 00                	push   $0x0
  801fe7:	e8 ab ee ff ff       	call   800e97 <sys_page_alloc>
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	0f 88 f3 03 00 00    	js     8023ea <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ff7:	be 00 00 00 00       	mov    $0x0,%esi
  801ffc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802002:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802005:	eb 30                	jmp    802037 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  802007:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80200d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  802013:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802016:	83 ec 08             	sub    $0x8,%esp
  802019:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80201c:	57                   	push   %edi
  80201d:	e8 83 ea ff ff       	call   800aa5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802022:	83 c4 04             	add    $0x4,%esp
  802025:	ff 34 b3             	pushl  (%ebx,%esi,4)
  802028:	e8 3f ea ff ff       	call   800a6c <strlen>
  80202d:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  802031:	83 c6 01             	add    $0x1,%esi
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80203d:	7f c8                	jg     802007 <spawn+0x188>
	}
	argv_store[argc] = 0;
  80203f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802045:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80204b:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802052:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802058:	0f 85 86 00 00 00    	jne    8020e4 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80205e:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  802064:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  80206a:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  80206d:	89 d0                	mov    %edx,%eax
  80206f:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802075:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802078:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80207d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	6a 07                	push   $0x7
  802088:	68 00 d0 bf ee       	push   $0xeebfd000
  80208d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802093:	68 00 00 40 00       	push   $0x400000
  802098:	6a 00                	push   $0x0
  80209a:	e8 3b ee ff ff       	call   800eda <sys_page_map>
  80209f:	89 c3                	mov    %eax,%ebx
  8020a1:	83 c4 20             	add    $0x20,%esp
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	0f 88 46 03 00 00    	js     8023f2 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	68 00 00 40 00       	push   $0x400000
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 61 ee ff ff       	call   800f1c <sys_page_unmap>
  8020bb:	89 c3                	mov    %eax,%ebx
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	0f 88 2a 03 00 00    	js     8023f2 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8020c8:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8020ce:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020d5:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8020dc:	00 00 00 
  8020df:	e9 4f 01 00 00       	jmp    802233 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020e4:	68 2c 39 80 00       	push   $0x80392c
  8020e9:	68 77 38 80 00       	push   $0x803877
  8020ee:	68 f8 00 00 00       	push   $0xf8
  8020f3:	68 bd 38 80 00       	push   $0x8038bd
  8020f8:	e8 53 e1 ff ff       	call   800250 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	6a 07                	push   $0x7
  802102:	68 00 00 40 00       	push   $0x400000
  802107:	6a 00                	push   $0x0
  802109:	e8 89 ed ff ff       	call   800e97 <sys_page_alloc>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	0f 88 b7 02 00 00    	js     8023d0 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802119:	83 ec 08             	sub    $0x8,%esp
  80211c:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802122:	01 f0                	add    %esi,%eax
  802124:	50                   	push   %eax
  802125:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80212b:	e8 5a f9 ff ff       	call   801a8a <seek>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	0f 88 9c 02 00 00    	js     8023d7 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802144:	29 f0                	sub    %esi,%eax
  802146:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80214b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802150:	0f 47 c1             	cmova  %ecx,%eax
  802153:	50                   	push   %eax
  802154:	68 00 00 40 00       	push   $0x400000
  802159:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80215f:	e8 5f f8 ff ff       	call   8019c3 <readn>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	0f 88 6f 02 00 00    	js     8023de <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802178:	53                   	push   %ebx
  802179:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80217f:	68 00 00 40 00       	push   $0x400000
  802184:	6a 00                	push   $0x0
  802186:	e8 4f ed ff ff       	call   800eda <sys_page_map>
  80218b:	83 c4 20             	add    $0x20,%esp
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 7c                	js     80220e <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	68 00 00 40 00       	push   $0x400000
  80219a:	6a 00                	push   $0x0
  80219c:	e8 7b ed ff ff       	call   800f1c <sys_page_unmap>
  8021a1:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8021a4:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8021aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8021b0:	89 fe                	mov    %edi,%esi
  8021b2:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8021b8:	76 69                	jbe    802223 <spawn+0x3a4>
		if (i >= filesz) {
  8021ba:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8021c0:	0f 87 37 ff ff ff    	ja     8020fd <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8021cf:	53                   	push   %ebx
  8021d0:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8021d6:	e8 bc ec ff ff       	call   800e97 <sys_page_alloc>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	79 c2                	jns    8021a4 <spawn+0x325>
  8021e2:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8021ed:	e8 26 ec ff ff       	call   800e18 <sys_env_destroy>
	close(fd);
  8021f2:	83 c4 04             	add    $0x4,%esp
  8021f5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8021fb:	e8 fe f5 ff ff       	call   8017fe <close>
	return r;
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802209:	e9 b4 01 00 00       	jmp    8023c2 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  80220e:	50                   	push   %eax
  80220f:	68 c9 38 80 00       	push   $0x8038c9
  802214:	68 2b 01 00 00       	push   $0x12b
  802219:	68 bd 38 80 00       	push   $0x8038bd
  80221e:	e8 2d e0 ff ff       	call   800250 <_panic>
  802223:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802229:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802230:	83 c6 20             	add    $0x20,%esi
  802233:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80223a:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802240:	7e 6d                	jle    8022af <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  802242:	83 3e 01             	cmpl   $0x1,(%esi)
  802245:	75 e2                	jne    802229 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802247:	8b 46 18             	mov    0x18(%esi),%eax
  80224a:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80224d:	83 f8 01             	cmp    $0x1,%eax
  802250:	19 c0                	sbb    %eax,%eax
  802252:	83 e0 fe             	and    $0xfffffffe,%eax
  802255:	83 c0 07             	add    $0x7,%eax
  802258:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80225e:	8b 4e 04             	mov    0x4(%esi),%ecx
  802261:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802267:	8b 56 10             	mov    0x10(%esi),%edx
  80226a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802270:	8b 7e 14             	mov    0x14(%esi),%edi
  802273:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802279:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802283:	74 1a                	je     80229f <spawn+0x420>
		va -= i;
  802285:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802287:	01 c7                	add    %eax,%edi
  802289:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  80228f:	01 c2                	add    %eax,%edx
  802291:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802297:	29 c1                	sub    %eax,%ecx
  802299:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  80229f:	bf 00 00 00 00       	mov    $0x0,%edi
  8022a4:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  8022aa:	e9 01 ff ff ff       	jmp    8021b0 <spawn+0x331>
	close(fd);
  8022af:	83 ec 0c             	sub    $0xc,%esp
  8022b2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8022b8:	e8 41 f5 ff ff       	call   8017fe <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	68 5c 39 80 00       	push   $0x80395c
  8022c5:	68 15 33 80 00       	push   $0x803315
  8022ca:	e8 77 e0 ff ff       	call   800346 <cprintf>
  8022cf:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8022d2:	bb 00 00 80 00       	mov    $0x800000,%ebx
  8022d7:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  8022dd:	eb 0e                	jmp    8022ed <spawn+0x46e>
  8022df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022e5:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8022eb:	74 5e                	je     80234b <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  8022ed:	89 d8                	mov    %ebx,%eax
  8022ef:	c1 e8 16             	shr    $0x16,%eax
  8022f2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8022f9:	a8 01                	test   $0x1,%al
  8022fb:	74 e2                	je     8022df <spawn+0x460>
  8022fd:	89 da                	mov    %ebx,%edx
  8022ff:	c1 ea 0c             	shr    $0xc,%edx
  802302:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802309:	25 05 04 00 00       	and    $0x405,%eax
  80230e:	3d 05 04 00 00       	cmp    $0x405,%eax
  802313:	75 ca                	jne    8022df <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  802315:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	25 07 0e 00 00       	and    $0xe07,%eax
  802324:	50                   	push   %eax
  802325:	53                   	push   %ebx
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	6a 00                	push   $0x0
  80232a:	e8 ab eb ff ff       	call   800eda <sys_page_map>
  80232f:	83 c4 20             	add    $0x20,%esp
  802332:	85 c0                	test   %eax,%eax
  802334:	79 a9                	jns    8022df <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  802336:	50                   	push   %eax
  802337:	68 e6 38 80 00       	push   $0x8038e6
  80233c:	68 3b 01 00 00       	push   $0x13b
  802341:	68 bd 38 80 00       	push   $0x8038bd
  802346:	e8 05 df ff ff       	call   800250 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80234b:	83 ec 08             	sub    $0x8,%esp
  80234e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802354:	50                   	push   %eax
  802355:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80235b:	e8 40 ec ff ff       	call   800fa0 <sys_env_set_trapframe>
  802360:	83 c4 10             	add    $0x10,%esp
  802363:	85 c0                	test   %eax,%eax
  802365:	78 25                	js     80238c <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802367:	83 ec 08             	sub    $0x8,%esp
  80236a:	6a 02                	push   $0x2
  80236c:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802372:	e8 e7 eb ff ff       	call   800f5e <sys_env_set_status>
  802377:	83 c4 10             	add    $0x10,%esp
  80237a:	85 c0                	test   %eax,%eax
  80237c:	78 23                	js     8023a1 <spawn+0x522>
	return child;
  80237e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802384:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80238a:	eb 36                	jmp    8023c2 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  80238c:	50                   	push   %eax
  80238d:	68 f8 38 80 00       	push   $0x8038f8
  802392:	68 8a 00 00 00       	push   $0x8a
  802397:	68 bd 38 80 00       	push   $0x8038bd
  80239c:	e8 af de ff ff       	call   800250 <_panic>
		panic("sys_env_set_status: %e", r);
  8023a1:	50                   	push   %eax
  8023a2:	68 12 39 80 00       	push   $0x803912
  8023a7:	68 8d 00 00 00       	push   $0x8d
  8023ac:	68 bd 38 80 00       	push   $0x8038bd
  8023b1:	e8 9a de ff ff       	call   800250 <_panic>
		return r;
  8023b6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8023bc:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  8023c2:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8023c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5e                   	pop    %esi
  8023cd:	5f                   	pop    %edi
  8023ce:	5d                   	pop    %ebp
  8023cf:	c3                   	ret    
  8023d0:	89 c7                	mov    %eax,%edi
  8023d2:	e9 0d fe ff ff       	jmp    8021e4 <spawn+0x365>
  8023d7:	89 c7                	mov    %eax,%edi
  8023d9:	e9 06 fe ff ff       	jmp    8021e4 <spawn+0x365>
  8023de:	89 c7                	mov    %eax,%edi
  8023e0:	e9 ff fd ff ff       	jmp    8021e4 <spawn+0x365>
		return -E_NO_MEM;
  8023e5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  8023ea:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8023f0:	eb d0                	jmp    8023c2 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  8023f2:	83 ec 08             	sub    $0x8,%esp
  8023f5:	68 00 00 40 00       	push   $0x400000
  8023fa:	6a 00                	push   $0x0
  8023fc:	e8 1b eb ff ff       	call   800f1c <sys_page_unmap>
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  80240a:	eb b6                	jmp    8023c2 <spawn+0x543>

0080240c <spawnl>:
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  802415:	68 54 39 80 00       	push   $0x803954
  80241a:	68 15 33 80 00       	push   $0x803315
  80241f:	e8 22 df ff ff       	call   800346 <cprintf>
	va_start(vl, arg0);
  802424:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  802427:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80242f:	8d 4a 04             	lea    0x4(%edx),%ecx
  802432:	83 3a 00             	cmpl   $0x0,(%edx)
  802435:	74 07                	je     80243e <spawnl+0x32>
		argc++;
  802437:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  80243a:	89 ca                	mov    %ecx,%edx
  80243c:	eb f1                	jmp    80242f <spawnl+0x23>
	const char *argv[argc+2];
  80243e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802445:	83 e2 f0             	and    $0xfffffff0,%edx
  802448:	29 d4                	sub    %edx,%esp
  80244a:	8d 54 24 03          	lea    0x3(%esp),%edx
  80244e:	c1 ea 02             	shr    $0x2,%edx
  802451:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802458:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80245a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80245d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802464:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  80246b:	00 
	va_start(vl, arg0);
  80246c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80246f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	eb 0b                	jmp    802483 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  802478:	83 c0 01             	add    $0x1,%eax
  80247b:	8b 39                	mov    (%ecx),%edi
  80247d:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802480:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802483:	39 d0                	cmp    %edx,%eax
  802485:	75 f1                	jne    802478 <spawnl+0x6c>
	return spawn(prog, argv);
  802487:	83 ec 08             	sub    $0x8,%esp
  80248a:	56                   	push   %esi
  80248b:	ff 75 08             	pushl  0x8(%ebp)
  80248e:	e8 ec f9 ff ff       	call   801e7f <spawn>
}
  802493:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802496:	5b                   	pop    %ebx
  802497:	5e                   	pop    %esi
  802498:	5f                   	pop    %edi
  802499:	5d                   	pop    %ebp
  80249a:	c3                   	ret    

0080249b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8024a1:	68 82 39 80 00       	push   $0x803982
  8024a6:	ff 75 0c             	pushl  0xc(%ebp)
  8024a9:	e8 f7 e5 ff ff       	call   800aa5 <strcpy>
	return 0;
}
  8024ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <devsock_close>:
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	53                   	push   %ebx
  8024b9:	83 ec 10             	sub    $0x10,%esp
  8024bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8024bf:	53                   	push   %ebx
  8024c0:	e8 e0 0a 00 00       	call   802fa5 <pageref>
  8024c5:	83 c4 10             	add    $0x10,%esp
		return 0;
  8024c8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8024cd:	83 f8 01             	cmp    $0x1,%eax
  8024d0:	74 07                	je     8024d9 <devsock_close+0x24>
}
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8024d9:	83 ec 0c             	sub    $0xc,%esp
  8024dc:	ff 73 0c             	pushl  0xc(%ebx)
  8024df:	e8 b9 02 00 00       	call   80279d <nsipc_close>
  8024e4:	89 c2                	mov    %eax,%edx
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	eb e7                	jmp    8024d2 <devsock_close+0x1d>

008024eb <devsock_write>:
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	ff 75 10             	pushl  0x10(%ebp)
  8024f6:	ff 75 0c             	pushl  0xc(%ebp)
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	ff 70 0c             	pushl  0xc(%eax)
  8024ff:	e8 76 03 00 00       	call   80287a <nsipc_send>
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <devsock_read>:
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	ff 75 10             	pushl  0x10(%ebp)
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	ff 70 0c             	pushl  0xc(%eax)
  80251a:	e8 ef 02 00 00       	call   80280e <nsipc_recv>
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <fd2sockid>:
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802527:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	e8 9b f1 ff ff       	call   8016cc <fd_lookup>
  802531:	83 c4 10             	add    $0x10,%esp
  802534:	85 c0                	test   %eax,%eax
  802536:	78 10                	js     802548 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802541:	39 08                	cmp    %ecx,(%eax)
  802543:	75 05                	jne    80254a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    
		return -E_NOT_SUPP;
  80254a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80254f:	eb f7                	jmp    802548 <fd2sockid+0x27>

00802551 <alloc_sockfd>:
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	56                   	push   %esi
  802555:	53                   	push   %ebx
  802556:	83 ec 1c             	sub    $0x1c,%esp
  802559:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80255b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255e:	50                   	push   %eax
  80255f:	e8 16 f1 ff ff       	call   80167a <fd_alloc>
  802564:	89 c3                	mov    %eax,%ebx
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	85 c0                	test   %eax,%eax
  80256b:	78 43                	js     8025b0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 07 04 00 00       	push   $0x407
  802575:	ff 75 f4             	pushl  -0xc(%ebp)
  802578:	6a 00                	push   $0x0
  80257a:	e8 18 e9 ff ff       	call   800e97 <sys_page_alloc>
  80257f:	89 c3                	mov    %eax,%ebx
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	85 c0                	test   %eax,%eax
  802586:	78 28                	js     8025b0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802591:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80259d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	50                   	push   %eax
  8025a4:	e8 aa f0 ff ff       	call   801653 <fd2num>
  8025a9:	89 c3                	mov    %eax,%ebx
  8025ab:	83 c4 10             	add    $0x10,%esp
  8025ae:	eb 0c                	jmp    8025bc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	56                   	push   %esi
  8025b4:	e8 e4 01 00 00       	call   80279d <nsipc_close>
		return r;
  8025b9:	83 c4 10             	add    $0x10,%esp
}
  8025bc:	89 d8                	mov    %ebx,%eax
  8025be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    

008025c5 <accept>:
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	e8 4e ff ff ff       	call   802521 <fd2sockid>
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	78 1b                	js     8025f2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	ff 75 10             	pushl  0x10(%ebp)
  8025dd:	ff 75 0c             	pushl  0xc(%ebp)
  8025e0:	50                   	push   %eax
  8025e1:	e8 0e 01 00 00       	call   8026f4 <nsipc_accept>
  8025e6:	83 c4 10             	add    $0x10,%esp
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	78 05                	js     8025f2 <accept+0x2d>
	return alloc_sockfd(r);
  8025ed:	e8 5f ff ff ff       	call   802551 <alloc_sockfd>
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <bind>:
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	e8 1f ff ff ff       	call   802521 <fd2sockid>
  802602:	85 c0                	test   %eax,%eax
  802604:	78 12                	js     802618 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	ff 75 10             	pushl  0x10(%ebp)
  80260c:	ff 75 0c             	pushl  0xc(%ebp)
  80260f:	50                   	push   %eax
  802610:	e8 31 01 00 00       	call   802746 <nsipc_bind>
  802615:	83 c4 10             	add    $0x10,%esp
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <shutdown>:
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	e8 f9 fe ff ff       	call   802521 <fd2sockid>
  802628:	85 c0                	test   %eax,%eax
  80262a:	78 0f                	js     80263b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80262c:	83 ec 08             	sub    $0x8,%esp
  80262f:	ff 75 0c             	pushl  0xc(%ebp)
  802632:	50                   	push   %eax
  802633:	e8 43 01 00 00       	call   80277b <nsipc_shutdown>
  802638:	83 c4 10             	add    $0x10,%esp
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <connect>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	e8 d6 fe ff ff       	call   802521 <fd2sockid>
  80264b:	85 c0                	test   %eax,%eax
  80264d:	78 12                	js     802661 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80264f:	83 ec 04             	sub    $0x4,%esp
  802652:	ff 75 10             	pushl  0x10(%ebp)
  802655:	ff 75 0c             	pushl  0xc(%ebp)
  802658:	50                   	push   %eax
  802659:	e8 59 01 00 00       	call   8027b7 <nsipc_connect>
  80265e:	83 c4 10             	add    $0x10,%esp
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <listen>:
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	e8 b0 fe ff ff       	call   802521 <fd2sockid>
  802671:	85 c0                	test   %eax,%eax
  802673:	78 0f                	js     802684 <listen+0x21>
	return nsipc_listen(r, backlog);
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	ff 75 0c             	pushl  0xc(%ebp)
  80267b:	50                   	push   %eax
  80267c:	e8 6b 01 00 00       	call   8027ec <nsipc_listen>
  802681:	83 c4 10             	add    $0x10,%esp
}
  802684:	c9                   	leave  
  802685:	c3                   	ret    

00802686 <socket>:

int
socket(int domain, int type, int protocol)
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
  802689:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80268c:	ff 75 10             	pushl  0x10(%ebp)
  80268f:	ff 75 0c             	pushl  0xc(%ebp)
  802692:	ff 75 08             	pushl  0x8(%ebp)
  802695:	e8 3e 02 00 00       	call   8028d8 <nsipc_socket>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	85 c0                	test   %eax,%eax
  80269f:	78 05                	js     8026a6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8026a1:	e8 ab fe ff ff       	call   802551 <alloc_sockfd>
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	53                   	push   %ebx
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8026b1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8026b8:	74 26                	je     8026e0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026ba:	6a 07                	push   $0x7
  8026bc:	68 00 70 80 00       	push   $0x807000
  8026c1:	53                   	push   %ebx
  8026c2:	ff 35 04 50 80 00    	pushl  0x805004
  8026c8:	e8 45 08 00 00       	call   802f12 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026cd:	83 c4 0c             	add    $0xc,%esp
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	e8 ce 07 00 00       	call   802ea9 <ipc_recv>
}
  8026db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	6a 02                	push   $0x2
  8026e5:	e8 80 08 00 00       	call   802f6a <ipc_find_env>
  8026ea:	a3 04 50 80 00       	mov    %eax,0x805004
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	eb c6                	jmp    8026ba <nsipc+0x12>

008026f4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	56                   	push   %esi
  8026f8:	53                   	push   %ebx
  8026f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802704:	8b 06                	mov    (%esi),%eax
  802706:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80270b:	b8 01 00 00 00       	mov    $0x1,%eax
  802710:	e8 93 ff ff ff       	call   8026a8 <nsipc>
  802715:	89 c3                	mov    %eax,%ebx
  802717:	85 c0                	test   %eax,%eax
  802719:	79 09                	jns    802724 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80271b:	89 d8                	mov    %ebx,%eax
  80271d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802720:	5b                   	pop    %ebx
  802721:	5e                   	pop    %esi
  802722:	5d                   	pop    %ebp
  802723:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802724:	83 ec 04             	sub    $0x4,%esp
  802727:	ff 35 10 70 80 00    	pushl  0x807010
  80272d:	68 00 70 80 00       	push   $0x807000
  802732:	ff 75 0c             	pushl  0xc(%ebp)
  802735:	e8 f9 e4 ff ff       	call   800c33 <memmove>
		*addrlen = ret->ret_addrlen;
  80273a:	a1 10 70 80 00       	mov    0x807010,%eax
  80273f:	89 06                	mov    %eax,(%esi)
  802741:	83 c4 10             	add    $0x10,%esp
	return r;
  802744:	eb d5                	jmp    80271b <nsipc_accept+0x27>

00802746 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	53                   	push   %ebx
  80274a:	83 ec 08             	sub    $0x8,%esp
  80274d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802758:	53                   	push   %ebx
  802759:	ff 75 0c             	pushl  0xc(%ebp)
  80275c:	68 04 70 80 00       	push   $0x807004
  802761:	e8 cd e4 ff ff       	call   800c33 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802766:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80276c:	b8 02 00 00 00       	mov    $0x2,%eax
  802771:	e8 32 ff ff ff       	call   8026a8 <nsipc>
}
  802776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802791:	b8 03 00 00 00       	mov    $0x3,%eax
  802796:	e8 0d ff ff ff       	call   8026a8 <nsipc>
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <nsipc_close>:

int
nsipc_close(int s)
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8027ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8027b0:	e8 f3 fe ff ff       	call   8026a8 <nsipc>
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	53                   	push   %ebx
  8027bb:	83 ec 08             	sub    $0x8,%esp
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027c9:	53                   	push   %ebx
  8027ca:	ff 75 0c             	pushl  0xc(%ebp)
  8027cd:	68 04 70 80 00       	push   $0x807004
  8027d2:	e8 5c e4 ff ff       	call   800c33 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8027e2:	e8 c1 fe ff ff       	call   8026a8 <nsipc>
}
  8027e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8027fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802802:	b8 06 00 00 00       	mov    $0x6,%eax
  802807:	e8 9c fe ff ff       	call   8026a8 <nsipc>
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	56                   	push   %esi
  802812:	53                   	push   %ebx
  802813:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80281e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802824:	8b 45 14             	mov    0x14(%ebp),%eax
  802827:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80282c:	b8 07 00 00 00       	mov    $0x7,%eax
  802831:	e8 72 fe ff ff       	call   8026a8 <nsipc>
  802836:	89 c3                	mov    %eax,%ebx
  802838:	85 c0                	test   %eax,%eax
  80283a:	78 1f                	js     80285b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80283c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802841:	7f 21                	jg     802864 <nsipc_recv+0x56>
  802843:	39 c6                	cmp    %eax,%esi
  802845:	7c 1d                	jl     802864 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	50                   	push   %eax
  80284b:	68 00 70 80 00       	push   $0x807000
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	e8 db e3 ff ff       	call   800c33 <memmove>
  802858:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80285b:	89 d8                	mov    %ebx,%eax
  80285d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802864:	68 8e 39 80 00       	push   $0x80398e
  802869:	68 77 38 80 00       	push   $0x803877
  80286e:	6a 62                	push   $0x62
  802870:	68 a3 39 80 00       	push   $0x8039a3
  802875:	e8 d6 d9 ff ff       	call   800250 <_panic>

0080287a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	53                   	push   %ebx
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80288c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802892:	7f 2e                	jg     8028c2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	53                   	push   %ebx
  802898:	ff 75 0c             	pushl  0xc(%ebp)
  80289b:	68 0c 70 80 00       	push   $0x80700c
  8028a0:	e8 8e e3 ff ff       	call   800c33 <memmove>
	nsipcbuf.send.req_size = size;
  8028a5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8028ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8028ae:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8028b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8028b8:	e8 eb fd ff ff       	call   8026a8 <nsipc>
}
  8028bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028c0:	c9                   	leave  
  8028c1:	c3                   	ret    
	assert(size < 1600);
  8028c2:	68 af 39 80 00       	push   $0x8039af
  8028c7:	68 77 38 80 00       	push   $0x803877
  8028cc:	6a 6d                	push   $0x6d
  8028ce:	68 a3 39 80 00       	push   $0x8039a3
  8028d3:	e8 78 d9 ff ff       	call   800250 <_panic>

008028d8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028d8:	55                   	push   %ebp
  8028d9:	89 e5                	mov    %esp,%ebp
  8028db:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8028ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8028f6:	b8 09 00 00 00       	mov    $0x9,%eax
  8028fb:	e8 a8 fd ff ff       	call   8026a8 <nsipc>
}
  802900:	c9                   	leave  
  802901:	c3                   	ret    

00802902 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802902:	55                   	push   %ebp
  802903:	89 e5                	mov    %esp,%ebp
  802905:	56                   	push   %esi
  802906:	53                   	push   %ebx
  802907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80290a:	83 ec 0c             	sub    $0xc,%esp
  80290d:	ff 75 08             	pushl  0x8(%ebp)
  802910:	e8 4e ed ff ff       	call   801663 <fd2data>
  802915:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802917:	83 c4 08             	add    $0x8,%esp
  80291a:	68 bb 39 80 00       	push   $0x8039bb
  80291f:	53                   	push   %ebx
  802920:	e8 80 e1 ff ff       	call   800aa5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802925:	8b 46 04             	mov    0x4(%esi),%eax
  802928:	2b 06                	sub    (%esi),%eax
  80292a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802930:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802937:	00 00 00 
	stat->st_dev = &devpipe;
  80293a:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802941:	40 80 00 
	return 0;
}
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
  802949:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    

00802950 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	53                   	push   %ebx
  802954:	83 ec 0c             	sub    $0xc,%esp
  802957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80295a:	53                   	push   %ebx
  80295b:	6a 00                	push   $0x0
  80295d:	e8 ba e5 ff ff       	call   800f1c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802962:	89 1c 24             	mov    %ebx,(%esp)
  802965:	e8 f9 ec ff ff       	call   801663 <fd2data>
  80296a:	83 c4 08             	add    $0x8,%esp
  80296d:	50                   	push   %eax
  80296e:	6a 00                	push   $0x0
  802970:	e8 a7 e5 ff ff       	call   800f1c <sys_page_unmap>
}
  802975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <_pipeisclosed>:
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	57                   	push   %edi
  80297e:	56                   	push   %esi
  80297f:	53                   	push   %ebx
  802980:	83 ec 1c             	sub    $0x1c,%esp
  802983:	89 c7                	mov    %eax,%edi
  802985:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802987:	a1 08 50 80 00       	mov    0x805008,%eax
  80298c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80298f:	83 ec 0c             	sub    $0xc,%esp
  802992:	57                   	push   %edi
  802993:	e8 0d 06 00 00       	call   802fa5 <pageref>
  802998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80299b:	89 34 24             	mov    %esi,(%esp)
  80299e:	e8 02 06 00 00       	call   802fa5 <pageref>
		nn = thisenv->env_runs;
  8029a3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029a9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029ac:	83 c4 10             	add    $0x10,%esp
  8029af:	39 cb                	cmp    %ecx,%ebx
  8029b1:	74 1b                	je     8029ce <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8029b3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029b6:	75 cf                	jne    802987 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029b8:	8b 42 58             	mov    0x58(%edx),%eax
  8029bb:	6a 01                	push   $0x1
  8029bd:	50                   	push   %eax
  8029be:	53                   	push   %ebx
  8029bf:	68 c2 39 80 00       	push   $0x8039c2
  8029c4:	e8 7d d9 ff ff       	call   800346 <cprintf>
  8029c9:	83 c4 10             	add    $0x10,%esp
  8029cc:	eb b9                	jmp    802987 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8029ce:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029d1:	0f 94 c0             	sete   %al
  8029d4:	0f b6 c0             	movzbl %al,%eax
}
  8029d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029da:	5b                   	pop    %ebx
  8029db:	5e                   	pop    %esi
  8029dc:	5f                   	pop    %edi
  8029dd:	5d                   	pop    %ebp
  8029de:	c3                   	ret    

008029df <devpipe_write>:
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	57                   	push   %edi
  8029e3:	56                   	push   %esi
  8029e4:	53                   	push   %ebx
  8029e5:	83 ec 28             	sub    $0x28,%esp
  8029e8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8029eb:	56                   	push   %esi
  8029ec:	e8 72 ec ff ff       	call   801663 <fd2data>
  8029f1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8029f3:	83 c4 10             	add    $0x10,%esp
  8029f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8029fb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8029fe:	74 4f                	je     802a4f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a00:	8b 43 04             	mov    0x4(%ebx),%eax
  802a03:	8b 0b                	mov    (%ebx),%ecx
  802a05:	8d 51 20             	lea    0x20(%ecx),%edx
  802a08:	39 d0                	cmp    %edx,%eax
  802a0a:	72 14                	jb     802a20 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802a0c:	89 da                	mov    %ebx,%edx
  802a0e:	89 f0                	mov    %esi,%eax
  802a10:	e8 65 ff ff ff       	call   80297a <_pipeisclosed>
  802a15:	85 c0                	test   %eax,%eax
  802a17:	75 3b                	jne    802a54 <devpipe_write+0x75>
			sys_yield();
  802a19:	e8 5a e4 ff ff       	call   800e78 <sys_yield>
  802a1e:	eb e0                	jmp    802a00 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a23:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a27:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a2a:	89 c2                	mov    %eax,%edx
  802a2c:	c1 fa 1f             	sar    $0x1f,%edx
  802a2f:	89 d1                	mov    %edx,%ecx
  802a31:	c1 e9 1b             	shr    $0x1b,%ecx
  802a34:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a37:	83 e2 1f             	and    $0x1f,%edx
  802a3a:	29 ca                	sub    %ecx,%edx
  802a3c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a40:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a44:	83 c0 01             	add    $0x1,%eax
  802a47:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a4a:	83 c7 01             	add    $0x1,%edi
  802a4d:	eb ac                	jmp    8029fb <devpipe_write+0x1c>
	return i;
  802a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  802a52:	eb 05                	jmp    802a59 <devpipe_write+0x7a>
				return 0;
  802a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    

00802a61 <devpipe_read>:
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
  802a64:	57                   	push   %edi
  802a65:	56                   	push   %esi
  802a66:	53                   	push   %ebx
  802a67:	83 ec 18             	sub    $0x18,%esp
  802a6a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802a6d:	57                   	push   %edi
  802a6e:	e8 f0 eb ff ff       	call   801663 <fd2data>
  802a73:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a75:	83 c4 10             	add    $0x10,%esp
  802a78:	be 00 00 00 00       	mov    $0x0,%esi
  802a7d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a80:	75 14                	jne    802a96 <devpipe_read+0x35>
	return i;
  802a82:	8b 45 10             	mov    0x10(%ebp),%eax
  802a85:	eb 02                	jmp    802a89 <devpipe_read+0x28>
				return i;
  802a87:	89 f0                	mov    %esi,%eax
}
  802a89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
			sys_yield();
  802a91:	e8 e2 e3 ff ff       	call   800e78 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802a96:	8b 03                	mov    (%ebx),%eax
  802a98:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a9b:	75 18                	jne    802ab5 <devpipe_read+0x54>
			if (i > 0)
  802a9d:	85 f6                	test   %esi,%esi
  802a9f:	75 e6                	jne    802a87 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802aa1:	89 da                	mov    %ebx,%edx
  802aa3:	89 f8                	mov    %edi,%eax
  802aa5:	e8 d0 fe ff ff       	call   80297a <_pipeisclosed>
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 e3                	je     802a91 <devpipe_read+0x30>
				return 0;
  802aae:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab3:	eb d4                	jmp    802a89 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ab5:	99                   	cltd   
  802ab6:	c1 ea 1b             	shr    $0x1b,%edx
  802ab9:	01 d0                	add    %edx,%eax
  802abb:	83 e0 1f             	and    $0x1f,%eax
  802abe:	29 d0                	sub    %edx,%eax
  802ac0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ac8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802acb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802ace:	83 c6 01             	add    $0x1,%esi
  802ad1:	eb aa                	jmp    802a7d <devpipe_read+0x1c>

00802ad3 <pipe>:
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	56                   	push   %esi
  802ad7:	53                   	push   %ebx
  802ad8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802adb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ade:	50                   	push   %eax
  802adf:	e8 96 eb ff ff       	call   80167a <fd_alloc>
  802ae4:	89 c3                	mov    %eax,%ebx
  802ae6:	83 c4 10             	add    $0x10,%esp
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	0f 88 23 01 00 00    	js     802c14 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	68 07 04 00 00       	push   $0x407
  802af9:	ff 75 f4             	pushl  -0xc(%ebp)
  802afc:	6a 00                	push   $0x0
  802afe:	e8 94 e3 ff ff       	call   800e97 <sys_page_alloc>
  802b03:	89 c3                	mov    %eax,%ebx
  802b05:	83 c4 10             	add    $0x10,%esp
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	0f 88 04 01 00 00    	js     802c14 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802b10:	83 ec 0c             	sub    $0xc,%esp
  802b13:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b16:	50                   	push   %eax
  802b17:	e8 5e eb ff ff       	call   80167a <fd_alloc>
  802b1c:	89 c3                	mov    %eax,%ebx
  802b1e:	83 c4 10             	add    $0x10,%esp
  802b21:	85 c0                	test   %eax,%eax
  802b23:	0f 88 db 00 00 00    	js     802c04 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	68 07 04 00 00       	push   $0x407
  802b31:	ff 75 f0             	pushl  -0x10(%ebp)
  802b34:	6a 00                	push   $0x0
  802b36:	e8 5c e3 ff ff       	call   800e97 <sys_page_alloc>
  802b3b:	89 c3                	mov    %eax,%ebx
  802b3d:	83 c4 10             	add    $0x10,%esp
  802b40:	85 c0                	test   %eax,%eax
  802b42:	0f 88 bc 00 00 00    	js     802c04 <pipe+0x131>
	va = fd2data(fd0);
  802b48:	83 ec 0c             	sub    $0xc,%esp
  802b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  802b4e:	e8 10 eb ff ff       	call   801663 <fd2data>
  802b53:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b55:	83 c4 0c             	add    $0xc,%esp
  802b58:	68 07 04 00 00       	push   $0x407
  802b5d:	50                   	push   %eax
  802b5e:	6a 00                	push   $0x0
  802b60:	e8 32 e3 ff ff       	call   800e97 <sys_page_alloc>
  802b65:	89 c3                	mov    %eax,%ebx
  802b67:	83 c4 10             	add    $0x10,%esp
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	0f 88 82 00 00 00    	js     802bf4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b72:	83 ec 0c             	sub    $0xc,%esp
  802b75:	ff 75 f0             	pushl  -0x10(%ebp)
  802b78:	e8 e6 ea ff ff       	call   801663 <fd2data>
  802b7d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802b84:	50                   	push   %eax
  802b85:	6a 00                	push   $0x0
  802b87:	56                   	push   %esi
  802b88:	6a 00                	push   $0x0
  802b8a:	e8 4b e3 ff ff       	call   800eda <sys_page_map>
  802b8f:	89 c3                	mov    %eax,%ebx
  802b91:	83 c4 20             	add    $0x20,%esp
  802b94:	85 c0                	test   %eax,%eax
  802b96:	78 4e                	js     802be6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802b98:	a1 44 40 80 00       	mov    0x804044,%eax
  802b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802bac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802baf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802bbb:	83 ec 0c             	sub    $0xc,%esp
  802bbe:	ff 75 f4             	pushl  -0xc(%ebp)
  802bc1:	e8 8d ea ff ff       	call   801653 <fd2num>
  802bc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bc9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bcb:	83 c4 04             	add    $0x4,%esp
  802bce:	ff 75 f0             	pushl  -0x10(%ebp)
  802bd1:	e8 7d ea ff ff       	call   801653 <fd2num>
  802bd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bd9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bdc:	83 c4 10             	add    $0x10,%esp
  802bdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be4:	eb 2e                	jmp    802c14 <pipe+0x141>
	sys_page_unmap(0, va);
  802be6:	83 ec 08             	sub    $0x8,%esp
  802be9:	56                   	push   %esi
  802bea:	6a 00                	push   $0x0
  802bec:	e8 2b e3 ff ff       	call   800f1c <sys_page_unmap>
  802bf1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802bf4:	83 ec 08             	sub    $0x8,%esp
  802bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfa:	6a 00                	push   $0x0
  802bfc:	e8 1b e3 ff ff       	call   800f1c <sys_page_unmap>
  802c01:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c04:	83 ec 08             	sub    $0x8,%esp
  802c07:	ff 75 f4             	pushl  -0xc(%ebp)
  802c0a:	6a 00                	push   $0x0
  802c0c:	e8 0b e3 ff ff       	call   800f1c <sys_page_unmap>
  802c11:	83 c4 10             	add    $0x10,%esp
}
  802c14:	89 d8                	mov    %ebx,%eax
  802c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c19:	5b                   	pop    %ebx
  802c1a:	5e                   	pop    %esi
  802c1b:	5d                   	pop    %ebp
  802c1c:	c3                   	ret    

00802c1d <pipeisclosed>:
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c26:	50                   	push   %eax
  802c27:	ff 75 08             	pushl  0x8(%ebp)
  802c2a:	e8 9d ea ff ff       	call   8016cc <fd_lookup>
  802c2f:	83 c4 10             	add    $0x10,%esp
  802c32:	85 c0                	test   %eax,%eax
  802c34:	78 18                	js     802c4e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802c36:	83 ec 0c             	sub    $0xc,%esp
  802c39:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3c:	e8 22 ea ff ff       	call   801663 <fd2data>
	return _pipeisclosed(fd, p);
  802c41:	89 c2                	mov    %eax,%edx
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	e8 2f fd ff ff       	call   80297a <_pipeisclosed>
  802c4b:	83 c4 10             	add    $0x10,%esp
}
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
  802c53:	56                   	push   %esi
  802c54:	53                   	push   %ebx
  802c55:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802c58:	85 f6                	test   %esi,%esi
  802c5a:	74 13                	je     802c6f <wait+0x1f>
	e = &envs[ENVX(envid)];
  802c5c:	89 f3                	mov    %esi,%ebx
  802c5e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c64:	c1 e3 07             	shl    $0x7,%ebx
  802c67:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802c6d:	eb 1b                	jmp    802c8a <wait+0x3a>
	assert(envid != 0);
  802c6f:	68 da 39 80 00       	push   $0x8039da
  802c74:	68 77 38 80 00       	push   $0x803877
  802c79:	6a 09                	push   $0x9
  802c7b:	68 e5 39 80 00       	push   $0x8039e5
  802c80:	e8 cb d5 ff ff       	call   800250 <_panic>
		sys_yield();
  802c85:	e8 ee e1 ff ff       	call   800e78 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c8a:	8b 43 48             	mov    0x48(%ebx),%eax
  802c8d:	39 f0                	cmp    %esi,%eax
  802c8f:	75 07                	jne    802c98 <wait+0x48>
  802c91:	8b 43 54             	mov    0x54(%ebx),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	75 ed                	jne    802c85 <wait+0x35>
}
  802c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c9b:	5b                   	pop    %ebx
  802c9c:	5e                   	pop    %esi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    

00802c9f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca4:	c3                   	ret    

00802ca5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802ca5:	55                   	push   %ebp
  802ca6:	89 e5                	mov    %esp,%ebp
  802ca8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802cab:	68 f0 39 80 00       	push   $0x8039f0
  802cb0:	ff 75 0c             	pushl  0xc(%ebp)
  802cb3:	e8 ed dd ff ff       	call   800aa5 <strcpy>
	return 0;
}
  802cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbd:	c9                   	leave  
  802cbe:	c3                   	ret    

00802cbf <devcons_write>:
{
  802cbf:	55                   	push   %ebp
  802cc0:	89 e5                	mov    %esp,%ebp
  802cc2:	57                   	push   %edi
  802cc3:	56                   	push   %esi
  802cc4:	53                   	push   %ebx
  802cc5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802ccb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802cd0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802cd6:	3b 75 10             	cmp    0x10(%ebp),%esi
  802cd9:	73 31                	jae    802d0c <devcons_write+0x4d>
		m = n - tot;
  802cdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802cde:	29 f3                	sub    %esi,%ebx
  802ce0:	83 fb 7f             	cmp    $0x7f,%ebx
  802ce3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802ce8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	53                   	push   %ebx
  802cef:	89 f0                	mov    %esi,%eax
  802cf1:	03 45 0c             	add    0xc(%ebp),%eax
  802cf4:	50                   	push   %eax
  802cf5:	57                   	push   %edi
  802cf6:	e8 38 df ff ff       	call   800c33 <memmove>
		sys_cputs(buf, m);
  802cfb:	83 c4 08             	add    $0x8,%esp
  802cfe:	53                   	push   %ebx
  802cff:	57                   	push   %edi
  802d00:	e8 d6 e0 ff ff       	call   800ddb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802d05:	01 de                	add    %ebx,%esi
  802d07:	83 c4 10             	add    $0x10,%esp
  802d0a:	eb ca                	jmp    802cd6 <devcons_write+0x17>
}
  802d0c:	89 f0                	mov    %esi,%eax
  802d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d11:	5b                   	pop    %ebx
  802d12:	5e                   	pop    %esi
  802d13:	5f                   	pop    %edi
  802d14:	5d                   	pop    %ebp
  802d15:	c3                   	ret    

00802d16 <devcons_read>:
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	83 ec 08             	sub    $0x8,%esp
  802d1c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802d21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d25:	74 21                	je     802d48 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802d27:	e8 cd e0 ff ff       	call   800df9 <sys_cgetc>
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	75 07                	jne    802d37 <devcons_read+0x21>
		sys_yield();
  802d30:	e8 43 e1 ff ff       	call   800e78 <sys_yield>
  802d35:	eb f0                	jmp    802d27 <devcons_read+0x11>
	if (c < 0)
  802d37:	78 0f                	js     802d48 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802d39:	83 f8 04             	cmp    $0x4,%eax
  802d3c:	74 0c                	je     802d4a <devcons_read+0x34>
	*(char*)vbuf = c;
  802d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d41:	88 02                	mov    %al,(%edx)
	return 1;
  802d43:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    
		return 0;
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4f:	eb f7                	jmp    802d48 <devcons_read+0x32>

00802d51 <cputchar>:
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
  802d54:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802d5d:	6a 01                	push   $0x1
  802d5f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d62:	50                   	push   %eax
  802d63:	e8 73 e0 ff ff       	call   800ddb <sys_cputs>
}
  802d68:	83 c4 10             	add    $0x10,%esp
  802d6b:	c9                   	leave  
  802d6c:	c3                   	ret    

00802d6d <getchar>:
{
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
  802d70:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802d73:	6a 01                	push   $0x1
  802d75:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d78:	50                   	push   %eax
  802d79:	6a 00                	push   $0x0
  802d7b:	e8 bc eb ff ff       	call   80193c <read>
	if (r < 0)
  802d80:	83 c4 10             	add    $0x10,%esp
  802d83:	85 c0                	test   %eax,%eax
  802d85:	78 06                	js     802d8d <getchar+0x20>
	if (r < 1)
  802d87:	74 06                	je     802d8f <getchar+0x22>
	return c;
  802d89:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802d8d:	c9                   	leave  
  802d8e:	c3                   	ret    
		return -E_EOF;
  802d8f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802d94:	eb f7                	jmp    802d8d <getchar+0x20>

00802d96 <iscons>:
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d9f:	50                   	push   %eax
  802da0:	ff 75 08             	pushl  0x8(%ebp)
  802da3:	e8 24 e9 ff ff       	call   8016cc <fd_lookup>
  802da8:	83 c4 10             	add    $0x10,%esp
  802dab:	85 c0                	test   %eax,%eax
  802dad:	78 11                	js     802dc0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802db8:	39 10                	cmp    %edx,(%eax)
  802dba:	0f 94 c0             	sete   %al
  802dbd:	0f b6 c0             	movzbl %al,%eax
}
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <opencons>:
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802dcb:	50                   	push   %eax
  802dcc:	e8 a9 e8 ff ff       	call   80167a <fd_alloc>
  802dd1:	83 c4 10             	add    $0x10,%esp
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	78 3a                	js     802e12 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 07 04 00 00       	push   $0x407
  802de0:	ff 75 f4             	pushl  -0xc(%ebp)
  802de3:	6a 00                	push   $0x0
  802de5:	e8 ad e0 ff ff       	call   800e97 <sys_page_alloc>
  802dea:	83 c4 10             	add    $0x10,%esp
  802ded:	85 c0                	test   %eax,%eax
  802def:	78 21                	js     802e12 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802dfa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e06:	83 ec 0c             	sub    $0xc,%esp
  802e09:	50                   	push   %eax
  802e0a:	e8 44 e8 ff ff       	call   801653 <fd2num>
  802e0f:	83 c4 10             	add    $0x10,%esp
}
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
  802e17:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802e1a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802e21:	74 0a                	je     802e2d <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802e2b:	c9                   	leave  
  802e2c:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	6a 07                	push   $0x7
  802e32:	68 00 f0 bf ee       	push   $0xeebff000
  802e37:	6a 00                	push   $0x0
  802e39:	e8 59 e0 ff ff       	call   800e97 <sys_page_alloc>
		if(r < 0)
  802e3e:	83 c4 10             	add    $0x10,%esp
  802e41:	85 c0                	test   %eax,%eax
  802e43:	78 2a                	js     802e6f <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802e45:	83 ec 08             	sub    $0x8,%esp
  802e48:	68 83 2e 80 00       	push   $0x802e83
  802e4d:	6a 00                	push   $0x0
  802e4f:	e8 8e e1 ff ff       	call   800fe2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	85 c0                	test   %eax,%eax
  802e59:	79 c8                	jns    802e23 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 2c 3a 80 00       	push   $0x803a2c
  802e63:	6a 25                	push   $0x25
  802e65:	68 68 3a 80 00       	push   $0x803a68
  802e6a:	e8 e1 d3 ff ff       	call   800250 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 fc 39 80 00       	push   $0x8039fc
  802e77:	6a 22                	push   $0x22
  802e79:	68 68 3a 80 00       	push   $0x803a68
  802e7e:	e8 cd d3 ff ff       	call   800250 <_panic>

00802e83 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802e83:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802e84:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802e89:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802e8b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802e8e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802e92:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802e96:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802e99:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802e9b:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802e9f:	83 c4 08             	add    $0x8,%esp
	popal
  802ea2:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802ea3:	83 c4 04             	add    $0x4,%esp
	popfl
  802ea6:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802ea7:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802ea8:	c3                   	ret    

00802ea9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
  802eac:	56                   	push   %esi
  802ead:	53                   	push   %ebx
  802eae:	8b 75 08             	mov    0x8(%ebp),%esi
  802eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802eb7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802eb9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802ebe:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802ec1:	83 ec 0c             	sub    $0xc,%esp
  802ec4:	50                   	push   %eax
  802ec5:	e8 7d e1 ff ff       	call   801047 <sys_ipc_recv>
	if(ret < 0){
  802eca:	83 c4 10             	add    $0x10,%esp
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	78 2b                	js     802efc <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802ed1:	85 f6                	test   %esi,%esi
  802ed3:	74 0a                	je     802edf <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802ed5:	a1 08 50 80 00       	mov    0x805008,%eax
  802eda:	8b 40 74             	mov    0x74(%eax),%eax
  802edd:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802edf:	85 db                	test   %ebx,%ebx
  802ee1:	74 0a                	je     802eed <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802ee3:	a1 08 50 80 00       	mov    0x805008,%eax
  802ee8:	8b 40 78             	mov    0x78(%eax),%eax
  802eeb:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802eed:	a1 08 50 80 00       	mov    0x805008,%eax
  802ef2:	8b 40 70             	mov    0x70(%eax),%eax
}
  802ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ef8:	5b                   	pop    %ebx
  802ef9:	5e                   	pop    %esi
  802efa:	5d                   	pop    %ebp
  802efb:	c3                   	ret    
		if(from_env_store)
  802efc:	85 f6                	test   %esi,%esi
  802efe:	74 06                	je     802f06 <ipc_recv+0x5d>
			*from_env_store = 0;
  802f00:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802f06:	85 db                	test   %ebx,%ebx
  802f08:	74 eb                	je     802ef5 <ipc_recv+0x4c>
			*perm_store = 0;
  802f0a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802f10:	eb e3                	jmp    802ef5 <ipc_recv+0x4c>

00802f12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802f12:	55                   	push   %ebp
  802f13:	89 e5                	mov    %esp,%ebp
  802f15:	57                   	push   %edi
  802f16:	56                   	push   %esi
  802f17:	53                   	push   %ebx
  802f18:	83 ec 0c             	sub    $0xc,%esp
  802f1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  802f1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802f24:	85 db                	test   %ebx,%ebx
  802f26:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802f2b:	0f 44 d8             	cmove  %eax,%ebx
  802f2e:	eb 05                	jmp    802f35 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802f30:	e8 43 df ff ff       	call   800e78 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802f35:	ff 75 14             	pushl  0x14(%ebp)
  802f38:	53                   	push   %ebx
  802f39:	56                   	push   %esi
  802f3a:	57                   	push   %edi
  802f3b:	e8 e4 e0 ff ff       	call   801024 <sys_ipc_try_send>
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 1b                	je     802f62 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802f47:	79 e7                	jns    802f30 <ipc_send+0x1e>
  802f49:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f4c:	74 e2                	je     802f30 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 76 3a 80 00       	push   $0x803a76
  802f56:	6a 48                	push   $0x48
  802f58:	68 8b 3a 80 00       	push   $0x803a8b
  802f5d:	e8 ee d2 ff ff       	call   800250 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f65:	5b                   	pop    %ebx
  802f66:	5e                   	pop    %esi
  802f67:	5f                   	pop    %edi
  802f68:	5d                   	pop    %ebp
  802f69:	c3                   	ret    

00802f6a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802f6a:	55                   	push   %ebp
  802f6b:	89 e5                	mov    %esp,%ebp
  802f6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802f70:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802f75:	89 c2                	mov    %eax,%edx
  802f77:	c1 e2 07             	shl    $0x7,%edx
  802f7a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802f80:	8b 52 50             	mov    0x50(%edx),%edx
  802f83:	39 ca                	cmp    %ecx,%edx
  802f85:	74 11                	je     802f98 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802f87:	83 c0 01             	add    $0x1,%eax
  802f8a:	3d 00 04 00 00       	cmp    $0x400,%eax
  802f8f:	75 e4                	jne    802f75 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802f91:	b8 00 00 00 00       	mov    $0x0,%eax
  802f96:	eb 0b                	jmp    802fa3 <ipc_find_env+0x39>
			return envs[i].env_id;
  802f98:	c1 e0 07             	shl    $0x7,%eax
  802f9b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802fa0:	8b 40 48             	mov    0x48(%eax),%eax
}
  802fa3:	5d                   	pop    %ebp
  802fa4:	c3                   	ret    

00802fa5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
  802fa8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802fab:	89 d0                	mov    %edx,%eax
  802fad:	c1 e8 16             	shr    $0x16,%eax
  802fb0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802fb7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802fbc:	f6 c1 01             	test   $0x1,%cl
  802fbf:	74 1d                	je     802fde <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802fc1:	c1 ea 0c             	shr    $0xc,%edx
  802fc4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802fcb:	f6 c2 01             	test   $0x1,%dl
  802fce:	74 0e                	je     802fde <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fd0:	c1 ea 0c             	shr    $0xc,%edx
  802fd3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802fda:	ef 
  802fdb:	0f b7 c0             	movzwl %ax,%eax
}
  802fde:	5d                   	pop    %ebp
  802fdf:	c3                   	ret    

00802fe0 <__udivdi3>:
  802fe0:	55                   	push   %ebp
  802fe1:	57                   	push   %edi
  802fe2:	56                   	push   %esi
  802fe3:	53                   	push   %ebx
  802fe4:	83 ec 1c             	sub    $0x1c,%esp
  802fe7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802feb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802fef:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ff3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ff7:	85 d2                	test   %edx,%edx
  802ff9:	75 4d                	jne    803048 <__udivdi3+0x68>
  802ffb:	39 f3                	cmp    %esi,%ebx
  802ffd:	76 19                	jbe    803018 <__udivdi3+0x38>
  802fff:	31 ff                	xor    %edi,%edi
  803001:	89 e8                	mov    %ebp,%eax
  803003:	89 f2                	mov    %esi,%edx
  803005:	f7 f3                	div    %ebx
  803007:	89 fa                	mov    %edi,%edx
  803009:	83 c4 1c             	add    $0x1c,%esp
  80300c:	5b                   	pop    %ebx
  80300d:	5e                   	pop    %esi
  80300e:	5f                   	pop    %edi
  80300f:	5d                   	pop    %ebp
  803010:	c3                   	ret    
  803011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803018:	89 d9                	mov    %ebx,%ecx
  80301a:	85 db                	test   %ebx,%ebx
  80301c:	75 0b                	jne    803029 <__udivdi3+0x49>
  80301e:	b8 01 00 00 00       	mov    $0x1,%eax
  803023:	31 d2                	xor    %edx,%edx
  803025:	f7 f3                	div    %ebx
  803027:	89 c1                	mov    %eax,%ecx
  803029:	31 d2                	xor    %edx,%edx
  80302b:	89 f0                	mov    %esi,%eax
  80302d:	f7 f1                	div    %ecx
  80302f:	89 c6                	mov    %eax,%esi
  803031:	89 e8                	mov    %ebp,%eax
  803033:	89 f7                	mov    %esi,%edi
  803035:	f7 f1                	div    %ecx
  803037:	89 fa                	mov    %edi,%edx
  803039:	83 c4 1c             	add    $0x1c,%esp
  80303c:	5b                   	pop    %ebx
  80303d:	5e                   	pop    %esi
  80303e:	5f                   	pop    %edi
  80303f:	5d                   	pop    %ebp
  803040:	c3                   	ret    
  803041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803048:	39 f2                	cmp    %esi,%edx
  80304a:	77 1c                	ja     803068 <__udivdi3+0x88>
  80304c:	0f bd fa             	bsr    %edx,%edi
  80304f:	83 f7 1f             	xor    $0x1f,%edi
  803052:	75 2c                	jne    803080 <__udivdi3+0xa0>
  803054:	39 f2                	cmp    %esi,%edx
  803056:	72 06                	jb     80305e <__udivdi3+0x7e>
  803058:	31 c0                	xor    %eax,%eax
  80305a:	39 eb                	cmp    %ebp,%ebx
  80305c:	77 a9                	ja     803007 <__udivdi3+0x27>
  80305e:	b8 01 00 00 00       	mov    $0x1,%eax
  803063:	eb a2                	jmp    803007 <__udivdi3+0x27>
  803065:	8d 76 00             	lea    0x0(%esi),%esi
  803068:	31 ff                	xor    %edi,%edi
  80306a:	31 c0                	xor    %eax,%eax
  80306c:	89 fa                	mov    %edi,%edx
  80306e:	83 c4 1c             	add    $0x1c,%esp
  803071:	5b                   	pop    %ebx
  803072:	5e                   	pop    %esi
  803073:	5f                   	pop    %edi
  803074:	5d                   	pop    %ebp
  803075:	c3                   	ret    
  803076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80307d:	8d 76 00             	lea    0x0(%esi),%esi
  803080:	89 f9                	mov    %edi,%ecx
  803082:	b8 20 00 00 00       	mov    $0x20,%eax
  803087:	29 f8                	sub    %edi,%eax
  803089:	d3 e2                	shl    %cl,%edx
  80308b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80308f:	89 c1                	mov    %eax,%ecx
  803091:	89 da                	mov    %ebx,%edx
  803093:	d3 ea                	shr    %cl,%edx
  803095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803099:	09 d1                	or     %edx,%ecx
  80309b:	89 f2                	mov    %esi,%edx
  80309d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030a1:	89 f9                	mov    %edi,%ecx
  8030a3:	d3 e3                	shl    %cl,%ebx
  8030a5:	89 c1                	mov    %eax,%ecx
  8030a7:	d3 ea                	shr    %cl,%edx
  8030a9:	89 f9                	mov    %edi,%ecx
  8030ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030af:	89 eb                	mov    %ebp,%ebx
  8030b1:	d3 e6                	shl    %cl,%esi
  8030b3:	89 c1                	mov    %eax,%ecx
  8030b5:	d3 eb                	shr    %cl,%ebx
  8030b7:	09 de                	or     %ebx,%esi
  8030b9:	89 f0                	mov    %esi,%eax
  8030bb:	f7 74 24 08          	divl   0x8(%esp)
  8030bf:	89 d6                	mov    %edx,%esi
  8030c1:	89 c3                	mov    %eax,%ebx
  8030c3:	f7 64 24 0c          	mull   0xc(%esp)
  8030c7:	39 d6                	cmp    %edx,%esi
  8030c9:	72 15                	jb     8030e0 <__udivdi3+0x100>
  8030cb:	89 f9                	mov    %edi,%ecx
  8030cd:	d3 e5                	shl    %cl,%ebp
  8030cf:	39 c5                	cmp    %eax,%ebp
  8030d1:	73 04                	jae    8030d7 <__udivdi3+0xf7>
  8030d3:	39 d6                	cmp    %edx,%esi
  8030d5:	74 09                	je     8030e0 <__udivdi3+0x100>
  8030d7:	89 d8                	mov    %ebx,%eax
  8030d9:	31 ff                	xor    %edi,%edi
  8030db:	e9 27 ff ff ff       	jmp    803007 <__udivdi3+0x27>
  8030e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030e3:	31 ff                	xor    %edi,%edi
  8030e5:	e9 1d ff ff ff       	jmp    803007 <__udivdi3+0x27>
  8030ea:	66 90                	xchg   %ax,%ax
  8030ec:	66 90                	xchg   %ax,%ax
  8030ee:	66 90                	xchg   %ax,%ax

008030f0 <__umoddi3>:
  8030f0:	55                   	push   %ebp
  8030f1:	57                   	push   %edi
  8030f2:	56                   	push   %esi
  8030f3:	53                   	push   %ebx
  8030f4:	83 ec 1c             	sub    $0x1c,%esp
  8030f7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8030fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  803103:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803107:	89 da                	mov    %ebx,%edx
  803109:	85 c0                	test   %eax,%eax
  80310b:	75 43                	jne    803150 <__umoddi3+0x60>
  80310d:	39 df                	cmp    %ebx,%edi
  80310f:	76 17                	jbe    803128 <__umoddi3+0x38>
  803111:	89 f0                	mov    %esi,%eax
  803113:	f7 f7                	div    %edi
  803115:	89 d0                	mov    %edx,%eax
  803117:	31 d2                	xor    %edx,%edx
  803119:	83 c4 1c             	add    $0x1c,%esp
  80311c:	5b                   	pop    %ebx
  80311d:	5e                   	pop    %esi
  80311e:	5f                   	pop    %edi
  80311f:	5d                   	pop    %ebp
  803120:	c3                   	ret    
  803121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803128:	89 fd                	mov    %edi,%ebp
  80312a:	85 ff                	test   %edi,%edi
  80312c:	75 0b                	jne    803139 <__umoddi3+0x49>
  80312e:	b8 01 00 00 00       	mov    $0x1,%eax
  803133:	31 d2                	xor    %edx,%edx
  803135:	f7 f7                	div    %edi
  803137:	89 c5                	mov    %eax,%ebp
  803139:	89 d8                	mov    %ebx,%eax
  80313b:	31 d2                	xor    %edx,%edx
  80313d:	f7 f5                	div    %ebp
  80313f:	89 f0                	mov    %esi,%eax
  803141:	f7 f5                	div    %ebp
  803143:	89 d0                	mov    %edx,%eax
  803145:	eb d0                	jmp    803117 <__umoddi3+0x27>
  803147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80314e:	66 90                	xchg   %ax,%ax
  803150:	89 f1                	mov    %esi,%ecx
  803152:	39 d8                	cmp    %ebx,%eax
  803154:	76 0a                	jbe    803160 <__umoddi3+0x70>
  803156:	89 f0                	mov    %esi,%eax
  803158:	83 c4 1c             	add    $0x1c,%esp
  80315b:	5b                   	pop    %ebx
  80315c:	5e                   	pop    %esi
  80315d:	5f                   	pop    %edi
  80315e:	5d                   	pop    %ebp
  80315f:	c3                   	ret    
  803160:	0f bd e8             	bsr    %eax,%ebp
  803163:	83 f5 1f             	xor    $0x1f,%ebp
  803166:	75 20                	jne    803188 <__umoddi3+0x98>
  803168:	39 d8                	cmp    %ebx,%eax
  80316a:	0f 82 b0 00 00 00    	jb     803220 <__umoddi3+0x130>
  803170:	39 f7                	cmp    %esi,%edi
  803172:	0f 86 a8 00 00 00    	jbe    803220 <__umoddi3+0x130>
  803178:	89 c8                	mov    %ecx,%eax
  80317a:	83 c4 1c             	add    $0x1c,%esp
  80317d:	5b                   	pop    %ebx
  80317e:	5e                   	pop    %esi
  80317f:	5f                   	pop    %edi
  803180:	5d                   	pop    %ebp
  803181:	c3                   	ret    
  803182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803188:	89 e9                	mov    %ebp,%ecx
  80318a:	ba 20 00 00 00       	mov    $0x20,%edx
  80318f:	29 ea                	sub    %ebp,%edx
  803191:	d3 e0                	shl    %cl,%eax
  803193:	89 44 24 08          	mov    %eax,0x8(%esp)
  803197:	89 d1                	mov    %edx,%ecx
  803199:	89 f8                	mov    %edi,%eax
  80319b:	d3 e8                	shr    %cl,%eax
  80319d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8031a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031a9:	09 c1                	or     %eax,%ecx
  8031ab:	89 d8                	mov    %ebx,%eax
  8031ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e7                	shl    %cl,%edi
  8031b5:	89 d1                	mov    %edx,%ecx
  8031b7:	d3 e8                	shr    %cl,%eax
  8031b9:	89 e9                	mov    %ebp,%ecx
  8031bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031bf:	d3 e3                	shl    %cl,%ebx
  8031c1:	89 c7                	mov    %eax,%edi
  8031c3:	89 d1                	mov    %edx,%ecx
  8031c5:	89 f0                	mov    %esi,%eax
  8031c7:	d3 e8                	shr    %cl,%eax
  8031c9:	89 e9                	mov    %ebp,%ecx
  8031cb:	89 fa                	mov    %edi,%edx
  8031cd:	d3 e6                	shl    %cl,%esi
  8031cf:	09 d8                	or     %ebx,%eax
  8031d1:	f7 74 24 08          	divl   0x8(%esp)
  8031d5:	89 d1                	mov    %edx,%ecx
  8031d7:	89 f3                	mov    %esi,%ebx
  8031d9:	f7 64 24 0c          	mull   0xc(%esp)
  8031dd:	89 c6                	mov    %eax,%esi
  8031df:	89 d7                	mov    %edx,%edi
  8031e1:	39 d1                	cmp    %edx,%ecx
  8031e3:	72 06                	jb     8031eb <__umoddi3+0xfb>
  8031e5:	75 10                	jne    8031f7 <__umoddi3+0x107>
  8031e7:	39 c3                	cmp    %eax,%ebx
  8031e9:	73 0c                	jae    8031f7 <__umoddi3+0x107>
  8031eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8031ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8031f3:	89 d7                	mov    %edx,%edi
  8031f5:	89 c6                	mov    %eax,%esi
  8031f7:	89 ca                	mov    %ecx,%edx
  8031f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8031fe:	29 f3                	sub    %esi,%ebx
  803200:	19 fa                	sbb    %edi,%edx
  803202:	89 d0                	mov    %edx,%eax
  803204:	d3 e0                	shl    %cl,%eax
  803206:	89 e9                	mov    %ebp,%ecx
  803208:	d3 eb                	shr    %cl,%ebx
  80320a:	d3 ea                	shr    %cl,%edx
  80320c:	09 d8                	or     %ebx,%eax
  80320e:	83 c4 1c             	add    $0x1c,%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5f                   	pop    %edi
  803214:	5d                   	pop    %ebp
  803215:	c3                   	ret    
  803216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80321d:	8d 76 00             	lea    0x0(%esi),%esi
  803220:	89 da                	mov    %ebx,%edx
  803222:	29 fe                	sub    %edi,%esi
  803224:	19 c2                	sbb    %eax,%edx
  803226:	89 f1                	mov    %esi,%ecx
  803228:	89 c8                	mov    %ecx,%eax
  80322a:	e9 4b ff ff ff       	jmp    80317a <__umoddi3+0x8a>
