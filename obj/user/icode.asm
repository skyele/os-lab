
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
  80003e:	c7 05 00 40 80 00 80 	movl   $0x802c80,0x804000
  800045:	2c 80 00 

	cprintf("icode startup\n");
  800048:	68 86 2c 80 00       	push   $0x802c86
  80004d:	e8 e5 02 00 00       	call   800337 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 95 2c 80 00 	movl   $0x802c95,(%esp)
  800059:	e8 d9 02 00 00       	call   800337 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 a8 2c 80 00       	push   $0x802ca8
  800068:	e8 97 18 00 00       	call   801904 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 d1 2c 80 00       	push   $0x802cd1
  80007e:	e8 b4 02 00 00       	call   800337 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 cb 13 00 00       	call   801466 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 20 0d 00 00       	call   800dcc <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 ae 2c 80 00       	push   $0x802cae
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 c4 2c 80 00       	push   $0x802cc4
  8000be:	e8 7e 01 00 00       	call   800241 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 e4 2c 80 00       	push   $0x802ce4
  8000cb:	e8 67 02 00 00       	call   800337 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 50 12 00 00       	call   801328 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  8000df:	e8 53 02 00 00       	call   800337 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 0c 2d 80 00       	push   $0x802d0c
  8000f0:	68 15 2d 80 00       	push   $0x802d15
  8000f5:	68 1f 2d 80 00       	push   $0x802d1f
  8000fa:	68 1e 2d 80 00       	push   $0x802d1e
  8000ff:	e8 32 1e 00 00       	call   801f36 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 3b 2d 80 00       	push   $0x802d3b
  800113:	e8 1f 02 00 00       	call   800337 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 24 2d 80 00       	push   $0x802d24
  800128:	6a 1a                	push   $0x1a
  80012a:	68 c4 2c 80 00       	push   $0x802cc4
  80012f:	e8 0d 01 00 00       	call   800241 <_panic>

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
  800147:	e8 fe 0c 00 00       	call   800e4a <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001ab:	a1 08 50 80 00       	mov    0x805008,%eax
  8001b0:	8b 40 48             	mov    0x48(%eax),%eax
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	50                   	push   %eax
  8001b7:	68 4b 2d 80 00       	push   $0x802d4b
  8001bc:	e8 76 01 00 00       	call   800337 <cprintf>
	cprintf("before umain\n");
  8001c1:	c7 04 24 69 2d 80 00 	movl   $0x802d69,(%esp)
  8001c8:	e8 6a 01 00 00       	call   800337 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001cd:	83 c4 08             	add    $0x8,%esp
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	e8 58 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8001db:	c7 04 24 77 2d 80 00 	movl   $0x802d77,(%esp)
  8001e2:	e8 50 01 00 00       	call   800337 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e7:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ec:	8b 40 48             	mov    0x48(%eax),%eax
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	68 84 2d 80 00       	push   $0x802d84
  8001f8:	e8 3a 01 00 00       	call   800337 <cprintf>
	// exit gracefully
	exit();
  8001fd:	e8 0b 00 00 00       	call   80020d <exit>
}
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800208:	5b                   	pop    %ebx
  800209:	5e                   	pop    %esi
  80020a:	5f                   	pop    %edi
  80020b:	5d                   	pop    %ebp
  80020c:	c3                   	ret    

0080020d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020d:	55                   	push   %ebp
  80020e:	89 e5                	mov    %esp,%ebp
  800210:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800213:	a1 08 50 80 00       	mov    0x805008,%eax
  800218:	8b 40 48             	mov    0x48(%eax),%eax
  80021b:	68 b0 2d 80 00       	push   $0x802db0
  800220:	50                   	push   %eax
  800221:	68 a3 2d 80 00       	push   $0x802da3
  800226:	e8 0c 01 00 00       	call   800337 <cprintf>
	close_all();
  80022b:	e8 25 11 00 00       	call   801355 <close_all>
	sys_env_destroy(0);
  800230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800237:	e8 cd 0b 00 00       	call   800e09 <sys_env_destroy>
}
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800246:	a1 08 50 80 00       	mov    0x805008,%eax
  80024b:	8b 40 48             	mov    0x48(%eax),%eax
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 dc 2d 80 00       	push   $0x802ddc
  800256:	50                   	push   %eax
  800257:	68 a3 2d 80 00       	push   $0x802da3
  80025c:	e8 d6 00 00 00       	call   800337 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800261:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800264:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80026a:	e8 db 0b 00 00       	call   800e4a <sys_getenvid>
  80026f:	83 c4 04             	add    $0x4,%esp
  800272:	ff 75 0c             	pushl  0xc(%ebp)
  800275:	ff 75 08             	pushl  0x8(%ebp)
  800278:	56                   	push   %esi
  800279:	50                   	push   %eax
  80027a:	68 b8 2d 80 00       	push   $0x802db8
  80027f:	e8 b3 00 00 00       	call   800337 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800284:	83 c4 18             	add    $0x18,%esp
  800287:	53                   	push   %ebx
  800288:	ff 75 10             	pushl  0x10(%ebp)
  80028b:	e8 56 00 00 00       	call   8002e6 <vcprintf>
	cprintf("\n");
  800290:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  800297:	e8 9b 00 00 00       	call   800337 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029f:	cc                   	int3   
  8002a0:	eb fd                	jmp    80029f <_panic+0x5e>

008002a2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ac:	8b 13                	mov    (%ebx),%edx
  8002ae:	8d 42 01             	lea    0x1(%edx),%eax
  8002b1:	89 03                	mov    %eax,(%ebx)
  8002b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bf:	74 09                	je     8002ca <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	68 ff 00 00 00       	push   $0xff
  8002d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d5:	50                   	push   %eax
  8002d6:	e8 f1 0a 00 00       	call   800dcc <sys_cputs>
		b->idx = 0;
  8002db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	eb db                	jmp    8002c1 <putch+0x1f>

008002e6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f6:	00 00 00 
	b.cnt = 0;
  8002f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800300:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800303:	ff 75 0c             	pushl  0xc(%ebp)
  800306:	ff 75 08             	pushl  0x8(%ebp)
  800309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	68 a2 02 80 00       	push   $0x8002a2
  800315:	e8 4a 01 00 00       	call   800464 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80031a:	83 c4 08             	add    $0x8,%esp
  80031d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800323:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800329:	50                   	push   %eax
  80032a:	e8 9d 0a 00 00       	call   800dcc <sys_cputs>

	return b.cnt;
}
  80032f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80033d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800340:	50                   	push   %eax
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	e8 9d ff ff ff       	call   8002e6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	57                   	push   %edi
  80034f:	56                   	push   %esi
  800350:	53                   	push   %ebx
  800351:	83 ec 1c             	sub    $0x1c,%esp
  800354:	89 c6                	mov    %eax,%esi
  800356:	89 d7                	mov    %edx,%edi
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80036a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80036e:	74 2c                	je     80039c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80037a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80037d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800380:	39 c2                	cmp    %eax,%edx
  800382:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800385:	73 43                	jae    8003ca <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800387:	83 eb 01             	sub    $0x1,%ebx
  80038a:	85 db                	test   %ebx,%ebx
  80038c:	7e 6c                	jle    8003fa <printnum+0xaf>
				putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	57                   	push   %edi
  800392:	ff 75 18             	pushl  0x18(%ebp)
  800395:	ff d6                	call   *%esi
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	eb eb                	jmp    800387 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	6a 20                	push   $0x20
  8003a1:	6a 00                	push   $0x0
  8003a3:	50                   	push   %eax
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	89 fa                	mov    %edi,%edx
  8003ac:	89 f0                	mov    %esi,%eax
  8003ae:	e8 98 ff ff ff       	call   80034b <printnum>
		while (--width > 0)
  8003b3:	83 c4 20             	add    $0x20,%esp
  8003b6:	83 eb 01             	sub    $0x1,%ebx
  8003b9:	85 db                	test   %ebx,%ebx
  8003bb:	7e 65                	jle    800422 <printnum+0xd7>
			putch(padc, putdat);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	57                   	push   %edi
  8003c1:	6a 20                	push   $0x20
  8003c3:	ff d6                	call   *%esi
  8003c5:	83 c4 10             	add    $0x10,%esp
  8003c8:	eb ec                	jmp    8003b6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	ff 75 18             	pushl  0x18(%ebp)
  8003d0:	83 eb 01             	sub    $0x1,%ebx
  8003d3:	53                   	push   %ebx
  8003d4:	50                   	push   %eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003db:	ff 75 d8             	pushl  -0x28(%ebp)
  8003de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e4:	e8 47 26 00 00       	call   802a30 <__udivdi3>
  8003e9:	83 c4 18             	add    $0x18,%esp
  8003ec:	52                   	push   %edx
  8003ed:	50                   	push   %eax
  8003ee:	89 fa                	mov    %edi,%edx
  8003f0:	89 f0                	mov    %esi,%eax
  8003f2:	e8 54 ff ff ff       	call   80034b <printnum>
  8003f7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	57                   	push   %edi
  8003fe:	83 ec 04             	sub    $0x4,%esp
  800401:	ff 75 dc             	pushl  -0x24(%ebp)
  800404:	ff 75 d8             	pushl  -0x28(%ebp)
  800407:	ff 75 e4             	pushl  -0x1c(%ebp)
  80040a:	ff 75 e0             	pushl  -0x20(%ebp)
  80040d:	e8 2e 27 00 00       	call   802b40 <__umoddi3>
  800412:	83 c4 14             	add    $0x14,%esp
  800415:	0f be 80 e3 2d 80 00 	movsbl 0x802de3(%eax),%eax
  80041c:	50                   	push   %eax
  80041d:	ff d6                	call   *%esi
  80041f:	83 c4 10             	add    $0x10,%esp
	}
}
  800422:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800425:	5b                   	pop    %ebx
  800426:	5e                   	pop    %esi
  800427:	5f                   	pop    %edi
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800430:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800434:	8b 10                	mov    (%eax),%edx
  800436:	3b 50 04             	cmp    0x4(%eax),%edx
  800439:	73 0a                	jae    800445 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80043e:	89 08                	mov    %ecx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	88 02                	mov    %al,(%edx)
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <printfmt>:
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80044d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800450:	50                   	push   %eax
  800451:	ff 75 10             	pushl  0x10(%ebp)
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 08             	pushl  0x8(%ebp)
  80045a:	e8 05 00 00 00       	call   800464 <vprintfmt>
}
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <vprintfmt>:
{
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	57                   	push   %edi
  800468:	56                   	push   %esi
  800469:	53                   	push   %ebx
  80046a:	83 ec 3c             	sub    $0x3c,%esp
  80046d:	8b 75 08             	mov    0x8(%ebp),%esi
  800470:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800473:	8b 7d 10             	mov    0x10(%ebp),%edi
  800476:	e9 32 04 00 00       	jmp    8008ad <vprintfmt+0x449>
		padc = ' ';
  80047b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80047f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800486:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80048d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800494:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8d 47 01             	lea    0x1(%edi),%eax
  8004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ad:	0f b6 17             	movzbl (%edi),%edx
  8004b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004b3:	3c 55                	cmp    $0x55,%al
  8004b5:	0f 87 12 05 00 00    	ja     8009cd <vprintfmt+0x569>
  8004bb:	0f b6 c0             	movzbl %al,%eax
  8004be:	ff 24 85 c0 2f 80 00 	jmp    *0x802fc0(,%eax,4)
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004cc:	eb d9                	jmp    8004a7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004d1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004d5:	eb d0                	jmp    8004a7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d7:	0f b6 d2             	movzbl %dl,%edx
  8004da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e5:	eb 03                	jmp    8004ea <vprintfmt+0x86>
  8004e7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ea:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ed:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004f1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004f4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f7:	83 fe 09             	cmp    $0x9,%esi
  8004fa:	76 eb                	jbe    8004e7 <vprintfmt+0x83>
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800502:	eb 14                	jmp    800518 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8d 40 04             	lea    0x4(%eax),%eax
  800512:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800515:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800518:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051c:	79 89                	jns    8004a7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80051e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800521:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800524:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80052b:	e9 77 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
  800530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800533:	85 c0                	test   %eax,%eax
  800535:	0f 48 c1             	cmovs  %ecx,%eax
  800538:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80053e:	e9 64 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800546:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80054d:	e9 55 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
			lflag++;
  800552:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800556:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800559:	e9 49 ff ff ff       	jmp    8004a7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 78 04             	lea    0x4(%eax),%edi
  800564:	83 ec 08             	sub    $0x8,%esp
  800567:	53                   	push   %ebx
  800568:	ff 30                	pushl  (%eax)
  80056a:	ff d6                	call   *%esi
			break;
  80056c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800572:	e9 33 03 00 00       	jmp    8008aa <vprintfmt+0x446>
			err = va_arg(ap, int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 78 04             	lea    0x4(%eax),%edi
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	99                   	cltd   
  800580:	31 d0                	xor    %edx,%eax
  800582:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800584:	83 f8 11             	cmp    $0x11,%eax
  800587:	7f 23                	jg     8005ac <vprintfmt+0x148>
  800589:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  800590:	85 d2                	test   %edx,%edx
  800592:	74 18                	je     8005ac <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800594:	52                   	push   %edx
  800595:	68 3d 32 80 00       	push   $0x80323d
  80059a:	53                   	push   %ebx
  80059b:	56                   	push   %esi
  80059c:	e8 a6 fe ff ff       	call   800447 <printfmt>
  8005a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a7:	e9 fe 02 00 00       	jmp    8008aa <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005ac:	50                   	push   %eax
  8005ad:	68 fb 2d 80 00       	push   $0x802dfb
  8005b2:	53                   	push   %ebx
  8005b3:	56                   	push   %esi
  8005b4:	e8 8e fe ff ff       	call   800447 <printfmt>
  8005b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005bc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005bf:	e9 e6 02 00 00       	jmp    8008aa <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	83 c0 04             	add    $0x4,%eax
  8005ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	b8 f4 2d 80 00       	mov    $0x802df4,%eax
  8005d9:	0f 45 c1             	cmovne %ecx,%eax
  8005dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e3:	7e 06                	jle    8005eb <vprintfmt+0x187>
  8005e5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005e9:	75 0d                	jne    8005f8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ee:	89 c7                	mov    %eax,%edi
  8005f0:	03 45 e0             	add    -0x20(%ebp),%eax
  8005f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f6:	eb 53                	jmp    80064b <vprintfmt+0x1e7>
  8005f8:	83 ec 08             	sub    $0x8,%esp
  8005fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8005fe:	50                   	push   %eax
  8005ff:	e8 71 04 00 00       	call   800a75 <strnlen>
  800604:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800607:	29 c1                	sub    %eax,%ecx
  800609:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800611:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800615:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800618:	eb 0f                	jmp    800629 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	ff 75 e0             	pushl  -0x20(%ebp)
  800621:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800623:	83 ef 01             	sub    $0x1,%edi
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	85 ff                	test   %edi,%edi
  80062b:	7f ed                	jg     80061a <vprintfmt+0x1b6>
  80062d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800630:	85 c9                	test   %ecx,%ecx
  800632:	b8 00 00 00 00       	mov    $0x0,%eax
  800637:	0f 49 c1             	cmovns %ecx,%eax
  80063a:	29 c1                	sub    %eax,%ecx
  80063c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80063f:	eb aa                	jmp    8005eb <vprintfmt+0x187>
					putch(ch, putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	52                   	push   %edx
  800646:	ff d6                	call   *%esi
  800648:	83 c4 10             	add    $0x10,%esp
  80064b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800650:	83 c7 01             	add    $0x1,%edi
  800653:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800657:	0f be d0             	movsbl %al,%edx
  80065a:	85 d2                	test   %edx,%edx
  80065c:	74 4b                	je     8006a9 <vprintfmt+0x245>
  80065e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800662:	78 06                	js     80066a <vprintfmt+0x206>
  800664:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800668:	78 1e                	js     800688 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80066a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80066e:	74 d1                	je     800641 <vprintfmt+0x1dd>
  800670:	0f be c0             	movsbl %al,%eax
  800673:	83 e8 20             	sub    $0x20,%eax
  800676:	83 f8 5e             	cmp    $0x5e,%eax
  800679:	76 c6                	jbe    800641 <vprintfmt+0x1dd>
					putch('?', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 3f                	push   $0x3f
  800681:	ff d6                	call   *%esi
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	eb c3                	jmp    80064b <vprintfmt+0x1e7>
  800688:	89 cf                	mov    %ecx,%edi
  80068a:	eb 0e                	jmp    80069a <vprintfmt+0x236>
				putch(' ', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 20                	push   $0x20
  800692:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800694:	83 ef 01             	sub    $0x1,%edi
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	85 ff                	test   %edi,%edi
  80069c:	7f ee                	jg     80068c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80069e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a4:	e9 01 02 00 00       	jmp    8008aa <vprintfmt+0x446>
  8006a9:	89 cf                	mov    %ecx,%edi
  8006ab:	eb ed                	jmp    80069a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006b0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b7:	e9 eb fd ff ff       	jmp    8004a7 <vprintfmt+0x43>
	if (lflag >= 2)
  8006bc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c0:	7f 21                	jg     8006e3 <vprintfmt+0x27f>
	else if (lflag)
  8006c2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c6:	74 68                	je     800730 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d0:	89 c1                	mov    %eax,%ecx
  8006d2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e1:	eb 17                	jmp    8006fa <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 50 04             	mov    0x4(%eax),%edx
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ee:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8d 40 08             	lea    0x8(%eax),%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800703:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800706:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80070a:	78 3f                	js     80074b <vprintfmt+0x2e7>
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800711:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800715:	0f 84 71 01 00 00    	je     80088c <vprintfmt+0x428>
				putch('+', putdat);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	53                   	push   %ebx
  80071f:	6a 2b                	push   $0x2b
  800721:	ff d6                	call   *%esi
  800723:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800726:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072b:	e9 5c 01 00 00       	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800738:	89 c1                	mov    %eax,%ecx
  80073a:	c1 f9 1f             	sar    $0x1f,%ecx
  80073d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800740:	8b 45 14             	mov    0x14(%ebp),%eax
  800743:	8d 40 04             	lea    0x4(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
  800749:	eb af                	jmp    8006fa <vprintfmt+0x296>
				putch('-', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 2d                	push   $0x2d
  800751:	ff d6                	call   *%esi
				num = -(long long) num;
  800753:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800756:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800759:	f7 d8                	neg    %eax
  80075b:	83 d2 00             	adc    $0x0,%edx
  80075e:	f7 da                	neg    %edx
  800760:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800763:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800766:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800769:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076e:	e9 19 01 00 00       	jmp    80088c <vprintfmt+0x428>
	if (lflag >= 2)
  800773:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800777:	7f 29                	jg     8007a2 <vprintfmt+0x33e>
	else if (lflag)
  800779:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077d:	74 44                	je     8007c3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800798:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079d:	e9 ea 00 00 00       	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 50 04             	mov    0x4(%eax),%edx
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 40 08             	lea    0x8(%eax),%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007be:	e9 c9 00 00 00       	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 40 04             	lea    0x4(%eax),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e1:	e9 a6 00 00 00       	jmp    80088c <vprintfmt+0x428>
			putch('0', putdat);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	6a 30                	push   $0x30
  8007ec:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f5:	7f 26                	jg     80081d <vprintfmt+0x3b9>
	else if (lflag)
  8007f7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fb:	74 3e                	je     80083b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
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
  80081b:	eb 6f                	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 50 04             	mov    0x4(%eax),%edx
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800828:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 40 08             	lea    0x8(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800834:	b8 08 00 00 00       	mov    $0x8,%eax
  800839:	eb 51                	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	ba 00 00 00 00       	mov    $0x0,%edx
  800845:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800848:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	8d 40 04             	lea    0x4(%eax),%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800854:	b8 08 00 00 00       	mov    $0x8,%eax
  800859:	eb 31                	jmp    80088c <vprintfmt+0x428>
			putch('0', putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	53                   	push   %ebx
  80085f:	6a 30                	push   $0x30
  800861:	ff d6                	call   *%esi
			putch('x', putdat);
  800863:	83 c4 08             	add    $0x8,%esp
  800866:	53                   	push   %ebx
  800867:	6a 78                	push   $0x78
  800869:	ff d6                	call   *%esi
			num = (unsigned long long)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	ba 00 00 00 00       	mov    $0x0,%edx
  800875:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800878:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80087b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8d 40 04             	lea    0x4(%eax),%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800887:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80088c:	83 ec 0c             	sub    $0xc,%esp
  80088f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800893:	52                   	push   %edx
  800894:	ff 75 e0             	pushl  -0x20(%ebp)
  800897:	50                   	push   %eax
  800898:	ff 75 dc             	pushl  -0x24(%ebp)
  80089b:	ff 75 d8             	pushl  -0x28(%ebp)
  80089e:	89 da                	mov    %ebx,%edx
  8008a0:	89 f0                	mov    %esi,%eax
  8008a2:	e8 a4 fa ff ff       	call   80034b <printnum>
			break;
  8008a7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ad:	83 c7 01             	add    $0x1,%edi
  8008b0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b4:	83 f8 25             	cmp    $0x25,%eax
  8008b7:	0f 84 be fb ff ff    	je     80047b <vprintfmt+0x17>
			if (ch == '\0')
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	0f 84 28 01 00 00    	je     8009ed <vprintfmt+0x589>
			putch(ch, putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	50                   	push   %eax
  8008ca:	ff d6                	call   *%esi
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	eb dc                	jmp    8008ad <vprintfmt+0x449>
	if (lflag >= 2)
  8008d1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008d5:	7f 26                	jg     8008fd <vprintfmt+0x499>
	else if (lflag)
  8008d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008db:	74 41                	je     80091e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8d 40 04             	lea    0x4(%eax),%eax
  8008f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8008fb:	eb 8f                	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8b 50 04             	mov    0x4(%eax),%edx
  800903:	8b 00                	mov    (%eax),%eax
  800905:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800908:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	8d 40 08             	lea    0x8(%eax),%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800914:	b8 10 00 00 00       	mov    $0x10,%eax
  800919:	e9 6e ff ff ff       	jmp    80088c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80091e:	8b 45 14             	mov    0x14(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
  800928:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8d 40 04             	lea    0x4(%eax),%eax
  800934:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800937:	b8 10 00 00 00       	mov    $0x10,%eax
  80093c:	e9 4b ff ff ff       	jmp    80088c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 c0 04             	add    $0x4,%eax
  800947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	85 c0                	test   %eax,%eax
  800951:	74 14                	je     800967 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800953:	8b 13                	mov    (%ebx),%edx
  800955:	83 fa 7f             	cmp    $0x7f,%edx
  800958:	7f 37                	jg     800991 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80095a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
  800962:	e9 43 ff ff ff       	jmp    8008aa <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800967:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096c:	bf 19 2f 80 00       	mov    $0x802f19,%edi
							putch(ch, putdat);
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	53                   	push   %ebx
  800975:	50                   	push   %eax
  800976:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800978:	83 c7 01             	add    $0x1,%edi
  80097b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	85 c0                	test   %eax,%eax
  800984:	75 eb                	jne    800971 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800986:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800989:	89 45 14             	mov    %eax,0x14(%ebp)
  80098c:	e9 19 ff ff ff       	jmp    8008aa <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800991:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800993:	b8 0a 00 00 00       	mov    $0xa,%eax
  800998:	bf 51 2f 80 00       	mov    $0x802f51,%edi
							putch(ch, putdat);
  80099d:	83 ec 08             	sub    $0x8,%esp
  8009a0:	53                   	push   %ebx
  8009a1:	50                   	push   %eax
  8009a2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009a4:	83 c7 01             	add    $0x1,%edi
  8009a7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ab:	83 c4 10             	add    $0x10,%esp
  8009ae:	85 c0                	test   %eax,%eax
  8009b0:	75 eb                	jne    80099d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b8:	e9 ed fe ff ff       	jmp    8008aa <vprintfmt+0x446>
			putch(ch, putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	53                   	push   %ebx
  8009c1:	6a 25                	push   $0x25
  8009c3:	ff d6                	call   *%esi
			break;
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	e9 dd fe ff ff       	jmp    8008aa <vprintfmt+0x446>
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	53                   	push   %ebx
  8009d1:	6a 25                	push   $0x25
  8009d3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	89 f8                	mov    %edi,%eax
  8009da:	eb 03                	jmp    8009df <vprintfmt+0x57b>
  8009dc:	83 e8 01             	sub    $0x1,%eax
  8009df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009e3:	75 f7                	jne    8009dc <vprintfmt+0x578>
  8009e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e8:	e9 bd fe ff ff       	jmp    8008aa <vprintfmt+0x446>
}
  8009ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009f0:	5b                   	pop    %ebx
  8009f1:	5e                   	pop    %esi
  8009f2:	5f                   	pop    %edi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 18             	sub    $0x18,%esp
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a04:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a08:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a12:	85 c0                	test   %eax,%eax
  800a14:	74 26                	je     800a3c <vsnprintf+0x47>
  800a16:	85 d2                	test   %edx,%edx
  800a18:	7e 22                	jle    800a3c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a1a:	ff 75 14             	pushl  0x14(%ebp)
  800a1d:	ff 75 10             	pushl  0x10(%ebp)
  800a20:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a23:	50                   	push   %eax
  800a24:	68 2a 04 80 00       	push   $0x80042a
  800a29:	e8 36 fa ff ff       	call   800464 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a37:	83 c4 10             	add    $0x10,%esp
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    
		return -E_INVAL;
  800a3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a41:	eb f7                	jmp    800a3a <vsnprintf+0x45>

00800a43 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a4c:	50                   	push   %eax
  800a4d:	ff 75 10             	pushl  0x10(%ebp)
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	ff 75 08             	pushl  0x8(%ebp)
  800a56:	e8 9a ff ff ff       	call   8009f5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a63:	b8 00 00 00 00       	mov    $0x0,%eax
  800a68:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a6c:	74 05                	je     800a73 <strlen+0x16>
		n++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	eb f5                	jmp    800a68 <strlen+0xb>
	return n;
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a83:	39 c2                	cmp    %eax,%edx
  800a85:	74 0d                	je     800a94 <strnlen+0x1f>
  800a87:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a8b:	74 05                	je     800a92 <strnlen+0x1d>
		n++;
  800a8d:	83 c2 01             	add    $0x1,%edx
  800a90:	eb f1                	jmp    800a83 <strnlen+0xe>
  800a92:	89 d0                	mov    %edx,%eax
	return n;
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aac:	83 c2 01             	add    $0x1,%edx
  800aaf:	84 c9                	test   %cl,%cl
  800ab1:	75 f2                	jne    800aa5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ab3:	5b                   	pop    %ebx
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	53                   	push   %ebx
  800aba:	83 ec 10             	sub    $0x10,%esp
  800abd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac0:	53                   	push   %ebx
  800ac1:	e8 97 ff ff ff       	call   800a5d <strlen>
  800ac6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	01 d8                	add    %ebx,%eax
  800ace:	50                   	push   %eax
  800acf:	e8 c2 ff ff ff       	call   800a96 <strcpy>
	return dst;
}
  800ad4:	89 d8                	mov    %ebx,%eax
  800ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    

00800adb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	56                   	push   %esi
  800adf:	53                   	push   %ebx
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae6:	89 c6                	mov    %eax,%esi
  800ae8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	39 f2                	cmp    %esi,%edx
  800aef:	74 11                	je     800b02 <strncpy+0x27>
		*dst++ = *src;
  800af1:	83 c2 01             	add    $0x1,%edx
  800af4:	0f b6 19             	movzbl (%ecx),%ebx
  800af7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800afa:	80 fb 01             	cmp    $0x1,%bl
  800afd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b00:	eb eb                	jmp    800aed <strncpy+0x12>
	}
	return ret;
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b11:	8b 55 10             	mov    0x10(%ebp),%edx
  800b14:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b16:	85 d2                	test   %edx,%edx
  800b18:	74 21                	je     800b3b <strlcpy+0x35>
  800b1a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b1e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	74 14                	je     800b38 <strlcpy+0x32>
  800b24:	0f b6 19             	movzbl (%ecx),%ebx
  800b27:	84 db                	test   %bl,%bl
  800b29:	74 0b                	je     800b36 <strlcpy+0x30>
			*dst++ = *src++;
  800b2b:	83 c1 01             	add    $0x1,%ecx
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b34:	eb ea                	jmp    800b20 <strlcpy+0x1a>
  800b36:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b38:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b3b:	29 f0                	sub    %esi,%eax
}
  800b3d:	5b                   	pop    %ebx
  800b3e:	5e                   	pop    %esi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b4a:	0f b6 01             	movzbl (%ecx),%eax
  800b4d:	84 c0                	test   %al,%al
  800b4f:	74 0c                	je     800b5d <strcmp+0x1c>
  800b51:	3a 02                	cmp    (%edx),%al
  800b53:	75 08                	jne    800b5d <strcmp+0x1c>
		p++, q++;
  800b55:	83 c1 01             	add    $0x1,%ecx
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	eb ed                	jmp    800b4a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5d:	0f b6 c0             	movzbl %al,%eax
  800b60:	0f b6 12             	movzbl (%edx),%edx
  800b63:	29 d0                	sub    %edx,%eax
}
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	53                   	push   %ebx
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b71:	89 c3                	mov    %eax,%ebx
  800b73:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b76:	eb 06                	jmp    800b7e <strncmp+0x17>
		n--, p++, q++;
  800b78:	83 c0 01             	add    $0x1,%eax
  800b7b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b7e:	39 d8                	cmp    %ebx,%eax
  800b80:	74 16                	je     800b98 <strncmp+0x31>
  800b82:	0f b6 08             	movzbl (%eax),%ecx
  800b85:	84 c9                	test   %cl,%cl
  800b87:	74 04                	je     800b8d <strncmp+0x26>
  800b89:	3a 0a                	cmp    (%edx),%cl
  800b8b:	74 eb                	je     800b78 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b8d:	0f b6 00             	movzbl (%eax),%eax
  800b90:	0f b6 12             	movzbl (%edx),%edx
  800b93:	29 d0                	sub    %edx,%eax
}
  800b95:	5b                   	pop    %ebx
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    
		return 0;
  800b98:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9d:	eb f6                	jmp    800b95 <strncmp+0x2e>

00800b9f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba9:	0f b6 10             	movzbl (%eax),%edx
  800bac:	84 d2                	test   %dl,%dl
  800bae:	74 09                	je     800bb9 <strchr+0x1a>
		if (*s == c)
  800bb0:	38 ca                	cmp    %cl,%dl
  800bb2:	74 0a                	je     800bbe <strchr+0x1f>
	for (; *s; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	eb f0                	jmp    800ba9 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bca:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bcd:	38 ca                	cmp    %cl,%dl
  800bcf:	74 09                	je     800bda <strfind+0x1a>
  800bd1:	84 d2                	test   %dl,%dl
  800bd3:	74 05                	je     800bda <strfind+0x1a>
	for (; *s; s++)
  800bd5:	83 c0 01             	add    $0x1,%eax
  800bd8:	eb f0                	jmp    800bca <strfind+0xa>
			break;
	return (char *) s;
}
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be8:	85 c9                	test   %ecx,%ecx
  800bea:	74 31                	je     800c1d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bec:	89 f8                	mov    %edi,%eax
  800bee:	09 c8                	or     %ecx,%eax
  800bf0:	a8 03                	test   $0x3,%al
  800bf2:	75 23                	jne    800c17 <memset+0x3b>
		c &= 0xFF;
  800bf4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf8:	89 d3                	mov    %edx,%ebx
  800bfa:	c1 e3 08             	shl    $0x8,%ebx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 18             	shl    $0x18,%eax
  800c02:	89 d6                	mov    %edx,%esi
  800c04:	c1 e6 10             	shl    $0x10,%esi
  800c07:	09 f0                	or     %esi,%eax
  800c09:	09 c2                	or     %eax,%edx
  800c0b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c0d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c10:	89 d0                	mov    %edx,%eax
  800c12:	fc                   	cld    
  800c13:	f3 ab                	rep stos %eax,%es:(%edi)
  800c15:	eb 06                	jmp    800c1d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1a:	fc                   	cld    
  800c1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c1d:	89 f8                	mov    %edi,%eax
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c32:	39 c6                	cmp    %eax,%esi
  800c34:	73 32                	jae    800c68 <memmove+0x44>
  800c36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c39:	39 c2                	cmp    %eax,%edx
  800c3b:	76 2b                	jbe    800c68 <memmove+0x44>
		s += n;
		d += n;
  800c3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c40:	89 fe                	mov    %edi,%esi
  800c42:	09 ce                	or     %ecx,%esi
  800c44:	09 d6                	or     %edx,%esi
  800c46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c4c:	75 0e                	jne    800c5c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c4e:	83 ef 04             	sub    $0x4,%edi
  800c51:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c57:	fd                   	std    
  800c58:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c5a:	eb 09                	jmp    800c65 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c5c:	83 ef 01             	sub    $0x1,%edi
  800c5f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c62:	fd                   	std    
  800c63:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c65:	fc                   	cld    
  800c66:	eb 1a                	jmp    800c82 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c68:	89 c2                	mov    %eax,%edx
  800c6a:	09 ca                	or     %ecx,%edx
  800c6c:	09 f2                	or     %esi,%edx
  800c6e:	f6 c2 03             	test   $0x3,%dl
  800c71:	75 0a                	jne    800c7d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c73:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	fc                   	cld    
  800c79:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7b:	eb 05                	jmp    800c82 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c7d:	89 c7                	mov    %eax,%edi
  800c7f:	fc                   	cld    
  800c80:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c8c:	ff 75 10             	pushl  0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 8a ff ff ff       	call   800c24 <memmove>
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca7:	89 c6                	mov    %eax,%esi
  800ca9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cac:	39 f0                	cmp    %esi,%eax
  800cae:	74 1c                	je     800ccc <memcmp+0x30>
		if (*s1 != *s2)
  800cb0:	0f b6 08             	movzbl (%eax),%ecx
  800cb3:	0f b6 1a             	movzbl (%edx),%ebx
  800cb6:	38 d9                	cmp    %bl,%cl
  800cb8:	75 08                	jne    800cc2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	83 c2 01             	add    $0x1,%edx
  800cc0:	eb ea                	jmp    800cac <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cc2:	0f b6 c1             	movzbl %cl,%eax
  800cc5:	0f b6 db             	movzbl %bl,%ebx
  800cc8:	29 d8                	sub    %ebx,%eax
  800cca:	eb 05                	jmp    800cd1 <memcmp+0x35>
	}

	return 0;
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cde:	89 c2                	mov    %eax,%edx
  800ce0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ce3:	39 d0                	cmp    %edx,%eax
  800ce5:	73 09                	jae    800cf0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce7:	38 08                	cmp    %cl,(%eax)
  800ce9:	74 05                	je     800cf0 <memfind+0x1b>
	for (; s < ends; s++)
  800ceb:	83 c0 01             	add    $0x1,%eax
  800cee:	eb f3                	jmp    800ce3 <memfind+0xe>
			break;
	return (void *) s;
}
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfe:	eb 03                	jmp    800d03 <strtol+0x11>
		s++;
  800d00:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d03:	0f b6 01             	movzbl (%ecx),%eax
  800d06:	3c 20                	cmp    $0x20,%al
  800d08:	74 f6                	je     800d00 <strtol+0xe>
  800d0a:	3c 09                	cmp    $0x9,%al
  800d0c:	74 f2                	je     800d00 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d0e:	3c 2b                	cmp    $0x2b,%al
  800d10:	74 2a                	je     800d3c <strtol+0x4a>
	int neg = 0;
  800d12:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d17:	3c 2d                	cmp    $0x2d,%al
  800d19:	74 2b                	je     800d46 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d21:	75 0f                	jne    800d32 <strtol+0x40>
  800d23:	80 39 30             	cmpb   $0x30,(%ecx)
  800d26:	74 28                	je     800d50 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d28:	85 db                	test   %ebx,%ebx
  800d2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2f:	0f 44 d8             	cmove  %eax,%ebx
  800d32:	b8 00 00 00 00       	mov    $0x0,%eax
  800d37:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d3a:	eb 50                	jmp    800d8c <strtol+0x9a>
		s++;
  800d3c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d44:	eb d5                	jmp    800d1b <strtol+0x29>
		s++, neg = 1;
  800d46:	83 c1 01             	add    $0x1,%ecx
  800d49:	bf 01 00 00 00       	mov    $0x1,%edi
  800d4e:	eb cb                	jmp    800d1b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d50:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d54:	74 0e                	je     800d64 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d56:	85 db                	test   %ebx,%ebx
  800d58:	75 d8                	jne    800d32 <strtol+0x40>
		s++, base = 8;
  800d5a:	83 c1 01             	add    $0x1,%ecx
  800d5d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d62:	eb ce                	jmp    800d32 <strtol+0x40>
		s += 2, base = 16;
  800d64:	83 c1 02             	add    $0x2,%ecx
  800d67:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d6c:	eb c4                	jmp    800d32 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d71:	89 f3                	mov    %esi,%ebx
  800d73:	80 fb 19             	cmp    $0x19,%bl
  800d76:	77 29                	ja     800da1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d78:	0f be d2             	movsbl %dl,%edx
  800d7b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d7e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d81:	7d 30                	jge    800db3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d83:	83 c1 01             	add    $0x1,%ecx
  800d86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d8a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d8c:	0f b6 11             	movzbl (%ecx),%edx
  800d8f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d92:	89 f3                	mov    %esi,%ebx
  800d94:	80 fb 09             	cmp    $0x9,%bl
  800d97:	77 d5                	ja     800d6e <strtol+0x7c>
			dig = *s - '0';
  800d99:	0f be d2             	movsbl %dl,%edx
  800d9c:	83 ea 30             	sub    $0x30,%edx
  800d9f:	eb dd                	jmp    800d7e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800da1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800da4:	89 f3                	mov    %esi,%ebx
  800da6:	80 fb 19             	cmp    $0x19,%bl
  800da9:	77 08                	ja     800db3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dab:	0f be d2             	movsbl %dl,%edx
  800dae:	83 ea 37             	sub    $0x37,%edx
  800db1:	eb cb                	jmp    800d7e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800db3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db7:	74 05                	je     800dbe <strtol+0xcc>
		*endptr = (char *) s;
  800db9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dbc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dbe:	89 c2                	mov    %eax,%edx
  800dc0:	f7 da                	neg    %edx
  800dc2:	85 ff                	test   %edi,%edi
  800dc4:	0f 45 c2             	cmovne %edx,%eax
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd2:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddd:	89 c3                	mov    %eax,%ebx
  800ddf:	89 c7                	mov    %eax,%edi
  800de1:	89 c6                	mov    %eax,%esi
  800de3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <sys_cgetc>:

int
sys_cgetc(void)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df0:	ba 00 00 00 00       	mov    $0x0,%edx
  800df5:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfa:	89 d1                	mov    %edx,%ecx
  800dfc:	89 d3                	mov    %edx,%ebx
  800dfe:	89 d7                	mov    %edx,%edi
  800e00:	89 d6                	mov    %edx,%esi
  800e02:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e17:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800e1f:	89 cb                	mov    %ecx,%ebx
  800e21:	89 cf                	mov    %ecx,%edi
  800e23:	89 ce                	mov    %ecx,%esi
  800e25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7f 08                	jg     800e33 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	50                   	push   %eax
  800e37:	6a 03                	push   $0x3
  800e39:	68 68 31 80 00       	push   $0x803168
  800e3e:	6a 43                	push   $0x43
  800e40:	68 85 31 80 00       	push   $0x803185
  800e45:	e8 f7 f3 ff ff       	call   800241 <_panic>

00800e4a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e50:	ba 00 00 00 00       	mov    $0x0,%edx
  800e55:	b8 02 00 00 00       	mov    $0x2,%eax
  800e5a:	89 d1                	mov    %edx,%ecx
  800e5c:	89 d3                	mov    %edx,%ebx
  800e5e:	89 d7                	mov    %edx,%edi
  800e60:	89 d6                	mov    %edx,%esi
  800e62:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_yield>:

void
sys_yield(void)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e74:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e79:	89 d1                	mov    %edx,%ecx
  800e7b:	89 d3                	mov    %edx,%ebx
  800e7d:	89 d7                	mov    %edx,%edi
  800e7f:	89 d6                	mov    %edx,%esi
  800e81:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	be 00 00 00 00       	mov    $0x0,%esi
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 04 00 00 00       	mov    $0x4,%eax
  800ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea4:	89 f7                	mov    %esi,%edi
  800ea6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	7f 08                	jg     800eb4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 04                	push   $0x4
  800eba:	68 68 31 80 00       	push   $0x803168
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 85 31 80 00       	push   $0x803185
  800ec6:	e8 76 f3 ff ff       	call   800241 <_panic>

00800ecb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 05 00 00 00       	mov    $0x5,%eax
  800edf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	7f 08                	jg     800ef6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 05                	push   $0x5
  800efc:	68 68 31 80 00       	push   $0x803168
  800f01:	6a 43                	push   $0x43
  800f03:	68 85 31 80 00       	push   $0x803185
  800f08:	e8 34 f3 ff ff       	call   800241 <_panic>

00800f0d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	b8 06 00 00 00       	mov    $0x6,%eax
  800f26:	89 df                	mov    %ebx,%edi
  800f28:	89 de                	mov    %ebx,%esi
  800f2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	7f 08                	jg     800f38 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	50                   	push   %eax
  800f3c:	6a 06                	push   $0x6
  800f3e:	68 68 31 80 00       	push   $0x803168
  800f43:	6a 43                	push   $0x43
  800f45:	68 85 31 80 00       	push   $0x803185
  800f4a:	e8 f2 f2 ff ff       	call   800241 <_panic>

00800f4f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	b8 08 00 00 00       	mov    $0x8,%eax
  800f68:	89 df                	mov    %ebx,%edi
  800f6a:	89 de                	mov    %ebx,%esi
  800f6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	7f 08                	jg     800f7a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	50                   	push   %eax
  800f7e:	6a 08                	push   $0x8
  800f80:	68 68 31 80 00       	push   $0x803168
  800f85:	6a 43                	push   $0x43
  800f87:	68 85 31 80 00       	push   $0x803185
  800f8c:	e8 b0 f2 ff ff       	call   800241 <_panic>

00800f91 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
  800f97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	b8 09 00 00 00       	mov    $0x9,%eax
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	7f 08                	jg     800fbc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	6a 09                	push   $0x9
  800fc2:	68 68 31 80 00       	push   $0x803168
  800fc7:	6a 43                	push   $0x43
  800fc9:	68 85 31 80 00       	push   $0x803185
  800fce:	e8 6e f2 ff ff       	call   800241 <_panic>

00800fd3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	57                   	push   %edi
  800fd7:	56                   	push   %esi
  800fd8:	53                   	push   %ebx
  800fd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fec:	89 df                	mov    %ebx,%edi
  800fee:	89 de                	mov    %ebx,%esi
  800ff0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	7f 08                	jg     800ffe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff9:	5b                   	pop    %ebx
  800ffa:	5e                   	pop    %esi
  800ffb:	5f                   	pop    %edi
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	50                   	push   %eax
  801002:	6a 0a                	push   $0xa
  801004:	68 68 31 80 00       	push   $0x803168
  801009:	6a 43                	push   $0x43
  80100b:	68 85 31 80 00       	push   $0x803185
  801010:	e8 2c f2 ff ff       	call   800241 <_panic>

00801015 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101b:	8b 55 08             	mov    0x8(%ebp),%edx
  80101e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801021:	b8 0c 00 00 00       	mov    $0xc,%eax
  801026:	be 00 00 00 00       	mov    $0x0,%esi
  80102b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80102e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801031:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801041:	b9 00 00 00 00       	mov    $0x0,%ecx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	b8 0d 00 00 00       	mov    $0xd,%eax
  80104e:	89 cb                	mov    %ecx,%ebx
  801050:	89 cf                	mov    %ecx,%edi
  801052:	89 ce                	mov    %ecx,%esi
  801054:	cd 30                	int    $0x30
	if(check && ret > 0)
  801056:	85 c0                	test   %eax,%eax
  801058:	7f 08                	jg     801062 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801062:	83 ec 0c             	sub    $0xc,%esp
  801065:	50                   	push   %eax
  801066:	6a 0d                	push   $0xd
  801068:	68 68 31 80 00       	push   $0x803168
  80106d:	6a 43                	push   $0x43
  80106f:	68 85 31 80 00       	push   $0x803185
  801074:	e8 c8 f1 ff ff       	call   800241 <_panic>

00801079 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80108f:	89 df                	mov    %ebx,%edi
  801091:	89 de                	mov    %ebx,%esi
  801093:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5f                   	pop    %edi
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	57                   	push   %edi
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010ad:	89 cb                	mov    %ecx,%ebx
  8010af:	89 cf                	mov    %ecx,%edi
  8010b1:	89 ce                	mov    %ecx,%esi
  8010b3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    

008010ba <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8010ca:	89 d1                	mov    %edx,%ecx
  8010cc:	89 d3                	mov    %edx,%ebx
  8010ce:	89 d7                	mov    %edx,%edi
  8010d0:	89 d6                	mov    %edx,%esi
  8010d2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ea:	b8 11 00 00 00       	mov    $0x11,%eax
  8010ef:	89 df                	mov    %ebx,%edi
  8010f1:	89 de                	mov    %ebx,%esi
  8010f3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    

008010fa <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
	asm volatile("int %1\n"
  801100:	bb 00 00 00 00       	mov    $0x0,%ebx
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110b:	b8 12 00 00 00       	mov    $0x12,%eax
  801110:	89 df                	mov    %ebx,%edi
  801112:	89 de                	mov    %ebx,%esi
  801114:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801116:	5b                   	pop    %ebx
  801117:	5e                   	pop    %esi
  801118:	5f                   	pop    %edi
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801124:	bb 00 00 00 00       	mov    $0x0,%ebx
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112f:	b8 13 00 00 00       	mov    $0x13,%eax
  801134:	89 df                	mov    %ebx,%edi
  801136:	89 de                	mov    %ebx,%esi
  801138:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	7f 08                	jg     801146 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80113e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	50                   	push   %eax
  80114a:	6a 13                	push   $0x13
  80114c:	68 68 31 80 00       	push   $0x803168
  801151:	6a 43                	push   $0x43
  801153:	68 85 31 80 00       	push   $0x803185
  801158:	e8 e4 f0 ff ff       	call   800241 <_panic>

0080115d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
	asm volatile("int %1\n"
  801163:	b9 00 00 00 00       	mov    $0x0,%ecx
  801168:	8b 55 08             	mov    0x8(%ebp),%edx
  80116b:	b8 14 00 00 00       	mov    $0x14,%eax
  801170:	89 cb                	mov    %ecx,%ebx
  801172:	89 cf                	mov    %ecx,%edi
  801174:	89 ce                	mov    %ecx,%esi
  801176:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	05 00 00 00 30       	add    $0x30000000,%eax
  801188:	c1 e8 0c             	shr    $0xc,%eax
}
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	c1 ea 16             	shr    $0x16,%edx
  8011b1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011b8:	f6 c2 01             	test   $0x1,%dl
  8011bb:	74 2d                	je     8011ea <fd_alloc+0x46>
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	c1 ea 0c             	shr    $0xc,%edx
  8011c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c9:	f6 c2 01             	test   $0x1,%dl
  8011cc:	74 1c                	je     8011ea <fd_alloc+0x46>
  8011ce:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011d8:	75 d2                	jne    8011ac <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011e8:	eb 0a                	jmp    8011f4 <fd_alloc+0x50>
			*fd_store = fd;
  8011ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ed:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fc:	83 f8 1f             	cmp    $0x1f,%eax
  8011ff:	77 30                	ja     801231 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801201:	c1 e0 0c             	shl    $0xc,%eax
  801204:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801209:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80120f:	f6 c2 01             	test   $0x1,%dl
  801212:	74 24                	je     801238 <fd_lookup+0x42>
  801214:	89 c2                	mov    %eax,%edx
  801216:	c1 ea 0c             	shr    $0xc,%edx
  801219:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801220:	f6 c2 01             	test   $0x1,%dl
  801223:	74 1a                	je     80123f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801225:	8b 55 0c             	mov    0xc(%ebp),%edx
  801228:	89 02                	mov    %eax,(%edx)
	return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    
		return -E_INVAL;
  801231:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801236:	eb f7                	jmp    80122f <fd_lookup+0x39>
		return -E_INVAL;
  801238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123d:	eb f0                	jmp    80122f <fd_lookup+0x39>
  80123f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801244:	eb e9                	jmp    80122f <fd_lookup+0x39>

00801246 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	83 ec 08             	sub    $0x8,%esp
  80124c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801259:	39 08                	cmp    %ecx,(%eax)
  80125b:	74 38                	je     801295 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80125d:	83 c2 01             	add    $0x1,%edx
  801260:	8b 04 95 10 32 80 00 	mov    0x803210(,%edx,4),%eax
  801267:	85 c0                	test   %eax,%eax
  801269:	75 ee                	jne    801259 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126b:	a1 08 50 80 00       	mov    0x805008,%eax
  801270:	8b 40 48             	mov    0x48(%eax),%eax
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	51                   	push   %ecx
  801277:	50                   	push   %eax
  801278:	68 94 31 80 00       	push   $0x803194
  80127d:	e8 b5 f0 ff ff       	call   800337 <cprintf>
	*dev = 0;
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    
			*dev = devtab[i];
  801295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801298:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129a:	b8 00 00 00 00       	mov    $0x0,%eax
  80129f:	eb f2                	jmp    801293 <dev_lookup+0x4d>

008012a1 <fd_close>:
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 24             	sub    $0x24,%esp
  8012aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ba:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bd:	50                   	push   %eax
  8012be:	e8 33 ff ff ff       	call   8011f6 <fd_lookup>
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 05                	js     8012d1 <fd_close+0x30>
	    || fd != fd2)
  8012cc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012cf:	74 16                	je     8012e7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012d1:	89 f8                	mov    %edi,%eax
  8012d3:	84 c0                	test   %al,%al
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012da:	0f 44 d8             	cmove  %eax,%ebx
}
  8012dd:	89 d8                	mov    %ebx,%eax
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	ff 36                	pushl  (%esi)
  8012f0:	e8 51 ff ff ff       	call   801246 <dev_lookup>
  8012f5:	89 c3                	mov    %eax,%ebx
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 1a                	js     801318 <fd_close+0x77>
		if (dev->dev_close)
  8012fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801301:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801309:	85 c0                	test   %eax,%eax
  80130b:	74 0b                	je     801318 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	56                   	push   %esi
  801311:	ff d0                	call   *%eax
  801313:	89 c3                	mov    %eax,%ebx
  801315:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	56                   	push   %esi
  80131c:	6a 00                	push   $0x0
  80131e:	e8 ea fb ff ff       	call   800f0d <sys_page_unmap>
	return r;
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	eb b5                	jmp    8012dd <fd_close+0x3c>

00801328 <close>:

int
close(int fdnum)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
  80132b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80132e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 bc fe ff ff       	call   8011f6 <fd_lookup>
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	79 02                	jns    801343 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801341:	c9                   	leave  
  801342:	c3                   	ret    
		return fd_close(fd, 1);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	6a 01                	push   $0x1
  801348:	ff 75 f4             	pushl  -0xc(%ebp)
  80134b:	e8 51 ff ff ff       	call   8012a1 <fd_close>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	eb ec                	jmp    801341 <close+0x19>

00801355 <close_all>:

void
close_all(void)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	53                   	push   %ebx
  801359:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80135c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	53                   	push   %ebx
  801365:	e8 be ff ff ff       	call   801328 <close>
	for (i = 0; i < MAXFD; i++)
  80136a:	83 c3 01             	add    $0x1,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	83 fb 20             	cmp    $0x20,%ebx
  801373:	75 ec                	jne    801361 <close_all+0xc>
}
  801375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801383:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	ff 75 08             	pushl  0x8(%ebp)
  80138a:	e8 67 fe ff ff       	call   8011f6 <fd_lookup>
  80138f:	89 c3                	mov    %eax,%ebx
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	0f 88 81 00 00 00    	js     80141d <dup+0xa3>
		return r;
	close(newfdnum);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	e8 81 ff ff ff       	call   801328 <close>

	newfd = INDEX2FD(newfdnum);
  8013a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013aa:	c1 e6 0c             	shl    $0xc,%esi
  8013ad:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b3:	83 c4 04             	add    $0x4,%esp
  8013b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013b9:	e8 cf fd ff ff       	call   80118d <fd2data>
  8013be:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c0:	89 34 24             	mov    %esi,(%esp)
  8013c3:	e8 c5 fd ff ff       	call   80118d <fd2data>
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cd:	89 d8                	mov    %ebx,%eax
  8013cf:	c1 e8 16             	shr    $0x16,%eax
  8013d2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013d9:	a8 01                	test   $0x1,%al
  8013db:	74 11                	je     8013ee <dup+0x74>
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	c1 e8 0c             	shr    $0xc,%eax
  8013e2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013e9:	f6 c2 01             	test   $0x1,%dl
  8013ec:	75 39                	jne    801427 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f1:	89 d0                	mov    %edx,%eax
  8013f3:	c1 e8 0c             	shr    $0xc,%eax
  8013f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	25 07 0e 00 00       	and    $0xe07,%eax
  801405:	50                   	push   %eax
  801406:	56                   	push   %esi
  801407:	6a 00                	push   $0x0
  801409:	52                   	push   %edx
  80140a:	6a 00                	push   $0x0
  80140c:	e8 ba fa ff ff       	call   800ecb <sys_page_map>
  801411:	89 c3                	mov    %eax,%ebx
  801413:	83 c4 20             	add    $0x20,%esp
  801416:	85 c0                	test   %eax,%eax
  801418:	78 31                	js     80144b <dup+0xd1>
		goto err;

	return newfdnum;
  80141a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141d:	89 d8                	mov    %ebx,%eax
  80141f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801427:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	25 07 0e 00 00       	and    $0xe07,%eax
  801436:	50                   	push   %eax
  801437:	57                   	push   %edi
  801438:	6a 00                	push   $0x0
  80143a:	53                   	push   %ebx
  80143b:	6a 00                	push   $0x0
  80143d:	e8 89 fa ff ff       	call   800ecb <sys_page_map>
  801442:	89 c3                	mov    %eax,%ebx
  801444:	83 c4 20             	add    $0x20,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	79 a3                	jns    8013ee <dup+0x74>
	sys_page_unmap(0, newfd);
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	56                   	push   %esi
  80144f:	6a 00                	push   $0x0
  801451:	e8 b7 fa ff ff       	call   800f0d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801456:	83 c4 08             	add    $0x8,%esp
  801459:	57                   	push   %edi
  80145a:	6a 00                	push   $0x0
  80145c:	e8 ac fa ff ff       	call   800f0d <sys_page_unmap>
	return r;
  801461:	83 c4 10             	add    $0x10,%esp
  801464:	eb b7                	jmp    80141d <dup+0xa3>

00801466 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	53                   	push   %ebx
  80146a:	83 ec 1c             	sub    $0x1c,%esp
  80146d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	53                   	push   %ebx
  801475:	e8 7c fd ff ff       	call   8011f6 <fd_lookup>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 3f                	js     8014c0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801487:	50                   	push   %eax
  801488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148b:	ff 30                	pushl  (%eax)
  80148d:	e8 b4 fd ff ff       	call   801246 <dev_lookup>
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 27                	js     8014c0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149c:	8b 42 08             	mov    0x8(%edx),%eax
  80149f:	83 e0 03             	and    $0x3,%eax
  8014a2:	83 f8 01             	cmp    $0x1,%eax
  8014a5:	74 1e                	je     8014c5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	8b 40 08             	mov    0x8(%eax),%eax
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	74 35                	je     8014e6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	ff 75 10             	pushl  0x10(%ebp)
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	52                   	push   %edx
  8014bb:	ff d0                	call   *%eax
  8014bd:	83 c4 10             	add    $0x10,%esp
}
  8014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c5:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ca:	8b 40 48             	mov    0x48(%eax),%eax
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	53                   	push   %ebx
  8014d1:	50                   	push   %eax
  8014d2:	68 d5 31 80 00       	push   $0x8031d5
  8014d7:	e8 5b ee ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e4:	eb da                	jmp    8014c0 <read+0x5a>
		return -E_NOT_SUPP;
  8014e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014eb:	eb d3                	jmp    8014c0 <read+0x5a>

008014ed <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801501:	39 f3                	cmp    %esi,%ebx
  801503:	73 23                	jae    801528 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	89 f0                	mov    %esi,%eax
  80150a:	29 d8                	sub    %ebx,%eax
  80150c:	50                   	push   %eax
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	03 45 0c             	add    0xc(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	57                   	push   %edi
  801514:	e8 4d ff ff ff       	call   801466 <read>
		if (m < 0)
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 06                	js     801526 <readn+0x39>
			return m;
		if (m == 0)
  801520:	74 06                	je     801528 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801522:	01 c3                	add    %eax,%ebx
  801524:	eb db                	jmp    801501 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801526:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801528:	89 d8                	mov    %ebx,%eax
  80152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5e                   	pop    %esi
  80152f:	5f                   	pop    %edi
  801530:	5d                   	pop    %ebp
  801531:	c3                   	ret    

00801532 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	53                   	push   %ebx
  801536:	83 ec 1c             	sub    $0x1c,%esp
  801539:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	53                   	push   %ebx
  801541:	e8 b0 fc ff ff       	call   8011f6 <fd_lookup>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 3a                	js     801587 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	ff 30                	pushl  (%eax)
  801559:	e8 e8 fc ff ff       	call   801246 <dev_lookup>
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	85 c0                	test   %eax,%eax
  801563:	78 22                	js     801587 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156c:	74 1e                	je     80158c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80156e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801571:	8b 52 0c             	mov    0xc(%edx),%edx
  801574:	85 d2                	test   %edx,%edx
  801576:	74 35                	je     8015ad <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	ff 75 10             	pushl  0x10(%ebp)
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	50                   	push   %eax
  801582:	ff d2                	call   *%edx
  801584:	83 c4 10             	add    $0x10,%esp
}
  801587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80158c:	a1 08 50 80 00       	mov    0x805008,%eax
  801591:	8b 40 48             	mov    0x48(%eax),%eax
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	53                   	push   %ebx
  801598:	50                   	push   %eax
  801599:	68 f1 31 80 00       	push   $0x8031f1
  80159e:	e8 94 ed ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ab:	eb da                	jmp    801587 <write+0x55>
		return -E_NOT_SUPP;
  8015ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b2:	eb d3                	jmp    801587 <write+0x55>

008015b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bd:	50                   	push   %eax
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	e8 30 fc ff ff       	call   8011f6 <fd_lookup>
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	78 0e                	js     8015db <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	53                   	push   %ebx
  8015e1:	83 ec 1c             	sub    $0x1c,%esp
  8015e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	53                   	push   %ebx
  8015ec:	e8 05 fc ff ff       	call   8011f6 <fd_lookup>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 37                	js     80162f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	50                   	push   %eax
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	ff 30                	pushl  (%eax)
  801604:	e8 3d fc ff ff       	call   801246 <dev_lookup>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 1f                	js     80162f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801617:	74 1b                	je     801634 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161c:	8b 52 18             	mov    0x18(%edx),%edx
  80161f:	85 d2                	test   %edx,%edx
  801621:	74 32                	je     801655 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	50                   	push   %eax
  80162a:	ff d2                	call   *%edx
  80162c:	83 c4 10             	add    $0x10,%esp
}
  80162f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801632:	c9                   	leave  
  801633:	c3                   	ret    
			thisenv->env_id, fdnum);
  801634:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801639:	8b 40 48             	mov    0x48(%eax),%eax
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	53                   	push   %ebx
  801640:	50                   	push   %eax
  801641:	68 b4 31 80 00       	push   $0x8031b4
  801646:	e8 ec ec ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801653:	eb da                	jmp    80162f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801655:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165a:	eb d3                	jmp    80162f <ftruncate+0x52>

0080165c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	53                   	push   %ebx
  801660:	83 ec 1c             	sub    $0x1c,%esp
  801663:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801666:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801669:	50                   	push   %eax
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	e8 84 fb ff ff       	call   8011f6 <fd_lookup>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	85 c0                	test   %eax,%eax
  801677:	78 4b                	js     8016c4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167f:	50                   	push   %eax
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	ff 30                	pushl  (%eax)
  801685:	e8 bc fb ff ff       	call   801246 <dev_lookup>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 33                	js     8016c4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801698:	74 2f                	je     8016c9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a4:	00 00 00 
	stat->st_isdir = 0;
  8016a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ae:	00 00 00 
	stat->st_dev = dev;
  8016b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	53                   	push   %ebx
  8016bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8016be:	ff 50 14             	call   *0x14(%eax)
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ce:	eb f4                	jmp    8016c4 <fstat+0x68>

008016d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 22 02 00 00       	call   801904 <open>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 1b                	js     801706 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	ff 75 0c             	pushl  0xc(%ebp)
  8016f1:	50                   	push   %eax
  8016f2:	e8 65 ff ff ff       	call   80165c <fstat>
  8016f7:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f9:	89 1c 24             	mov    %ebx,(%esp)
  8016fc:	e8 27 fc ff ff       	call   801328 <close>
	return r;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 f3                	mov    %esi,%ebx
}
  801706:	89 d8                	mov    %ebx,%eax
  801708:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170b:	5b                   	pop    %ebx
  80170c:	5e                   	pop    %esi
  80170d:	5d                   	pop    %ebp
  80170e:	c3                   	ret    

0080170f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
  801714:	89 c6                	mov    %eax,%esi
  801716:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801718:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80171f:	74 27                	je     801748 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801721:	6a 07                	push   $0x7
  801723:	68 00 60 80 00       	push   $0x806000
  801728:	56                   	push   %esi
  801729:	ff 35 00 50 80 00    	pushl  0x805000
  80172f:	e8 24 12 00 00       	call   802958 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801734:	83 c4 0c             	add    $0xc,%esp
  801737:	6a 00                	push   $0x0
  801739:	53                   	push   %ebx
  80173a:	6a 00                	push   $0x0
  80173c:	e8 ae 11 00 00       	call   8028ef <ipc_recv>
}
  801741:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801744:	5b                   	pop    %ebx
  801745:	5e                   	pop    %esi
  801746:	5d                   	pop    %ebp
  801747:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	6a 01                	push   $0x1
  80174d:	e8 5e 12 00 00       	call   8029b0 <ipc_find_env>
  801752:	a3 00 50 80 00       	mov    %eax,0x805000
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	eb c5                	jmp    801721 <fsipc+0x12>

0080175c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801762:	8b 45 08             	mov    0x8(%ebp),%eax
  801765:	8b 40 0c             	mov    0xc(%eax),%eax
  801768:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 02 00 00 00       	mov    $0x2,%eax
  80177f:	e8 8b ff ff ff       	call   80170f <fsipc>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <devfile_flush>:
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8b 40 0c             	mov    0xc(%eax),%eax
  801792:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a1:	e8 69 ff ff ff       	call   80170f <fsipc>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <devfile_stat>:
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	53                   	push   %ebx
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b8:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c7:	e8 43 ff ff ff       	call   80170f <fsipc>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	78 2c                	js     8017fc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	68 00 60 80 00       	push   $0x806000
  8017d8:	53                   	push   %ebx
  8017d9:	e8 b8 f2 ff ff       	call   800a96 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017de:	a1 80 60 80 00       	mov    0x806080,%eax
  8017e3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017e9:	a1 84 60 80 00       	mov    0x806084,%eax
  8017ee:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <devfile_write>:
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	53                   	push   %ebx
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801816:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80181c:	53                   	push   %ebx
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	68 08 60 80 00       	push   $0x806008
  801825:	e8 5c f4 ff ff       	call   800c86 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80182a:	ba 00 00 00 00       	mov    $0x0,%edx
  80182f:	b8 04 00 00 00       	mov    $0x4,%eax
  801834:	e8 d6 fe ff ff       	call   80170f <fsipc>
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 0b                	js     80184b <devfile_write+0x4a>
	assert(r <= n);
  801840:	39 d8                	cmp    %ebx,%eax
  801842:	77 0c                	ja     801850 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801844:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801849:	7f 1e                	jg     801869 <devfile_write+0x68>
}
  80184b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    
	assert(r <= n);
  801850:	68 24 32 80 00       	push   $0x803224
  801855:	68 2b 32 80 00       	push   $0x80322b
  80185a:	68 98 00 00 00       	push   $0x98
  80185f:	68 40 32 80 00       	push   $0x803240
  801864:	e8 d8 e9 ff ff       	call   800241 <_panic>
	assert(r <= PGSIZE);
  801869:	68 4b 32 80 00       	push   $0x80324b
  80186e:	68 2b 32 80 00       	push   $0x80322b
  801873:	68 99 00 00 00       	push   $0x99
  801878:	68 40 32 80 00       	push   $0x803240
  80187d:	e8 bf e9 ff ff       	call   800241 <_panic>

00801882 <devfile_read>:
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
  801887:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8b 40 0c             	mov    0xc(%eax),%eax
  801890:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801895:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a5:	e8 65 fe ff ff       	call   80170f <fsipc>
  8018aa:	89 c3                	mov    %eax,%ebx
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1f                	js     8018cf <devfile_read+0x4d>
	assert(r <= n);
  8018b0:	39 f0                	cmp    %esi,%eax
  8018b2:	77 24                	ja     8018d8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018b4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b9:	7f 33                	jg     8018ee <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	50                   	push   %eax
  8018bf:	68 00 60 80 00       	push   $0x806000
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	e8 58 f3 ff ff       	call   800c24 <memmove>
	return r;
  8018cc:	83 c4 10             	add    $0x10,%esp
}
  8018cf:	89 d8                	mov    %ebx,%eax
  8018d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    
	assert(r <= n);
  8018d8:	68 24 32 80 00       	push   $0x803224
  8018dd:	68 2b 32 80 00       	push   $0x80322b
  8018e2:	6a 7c                	push   $0x7c
  8018e4:	68 40 32 80 00       	push   $0x803240
  8018e9:	e8 53 e9 ff ff       	call   800241 <_panic>
	assert(r <= PGSIZE);
  8018ee:	68 4b 32 80 00       	push   $0x80324b
  8018f3:	68 2b 32 80 00       	push   $0x80322b
  8018f8:	6a 7d                	push   $0x7d
  8018fa:	68 40 32 80 00       	push   $0x803240
  8018ff:	e8 3d e9 ff ff       	call   800241 <_panic>

00801904 <open>:
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	56                   	push   %esi
  801908:	53                   	push   %ebx
  801909:	83 ec 1c             	sub    $0x1c,%esp
  80190c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80190f:	56                   	push   %esi
  801910:	e8 48 f1 ff ff       	call   800a5d <strlen>
  801915:	83 c4 10             	add    $0x10,%esp
  801918:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80191d:	7f 6c                	jg     80198b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801925:	50                   	push   %eax
  801926:	e8 79 f8 ff ff       	call   8011a4 <fd_alloc>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 3c                	js     801970 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801934:	83 ec 08             	sub    $0x8,%esp
  801937:	56                   	push   %esi
  801938:	68 00 60 80 00       	push   $0x806000
  80193d:	e8 54 f1 ff ff       	call   800a96 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80194a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194d:	b8 01 00 00 00       	mov    $0x1,%eax
  801952:	e8 b8 fd ff ff       	call   80170f <fsipc>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 19                	js     801979 <open+0x75>
	return fd2num(fd);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	ff 75 f4             	pushl  -0xc(%ebp)
  801966:	e8 12 f8 ff ff       	call   80117d <fd2num>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	83 c4 10             	add    $0x10,%esp
}
  801970:	89 d8                	mov    %ebx,%eax
  801972:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5d                   	pop    %ebp
  801978:	c3                   	ret    
		fd_close(fd, 0);
  801979:	83 ec 08             	sub    $0x8,%esp
  80197c:	6a 00                	push   $0x0
  80197e:	ff 75 f4             	pushl  -0xc(%ebp)
  801981:	e8 1b f9 ff ff       	call   8012a1 <fd_close>
		return r;
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	eb e5                	jmp    801970 <open+0x6c>
		return -E_BAD_PATH;
  80198b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801990:	eb de                	jmp    801970 <open+0x6c>

00801992 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801998:	ba 00 00 00 00       	mov    $0x0,%edx
  80199d:	b8 08 00 00 00       	mov    $0x8,%eax
  8019a2:	e8 68 fd ff ff       	call   80170f <fsipc>
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	57                   	push   %edi
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8019b5:	68 30 33 80 00       	push   $0x803330
  8019ba:	68 a7 2d 80 00       	push   $0x802da7
  8019bf:	e8 73 e9 ff ff       	call   800337 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019c4:	83 c4 08             	add    $0x8,%esp
  8019c7:	6a 00                	push   $0x0
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	e8 33 ff ff ff       	call   801904 <open>
  8019d1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	0f 88 0a 05 00 00    	js     801eec <spawn+0x543>
  8019e2:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	68 00 02 00 00       	push   $0x200
  8019ec:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	51                   	push   %ecx
  8019f4:	e8 f4 fa ff ff       	call   8014ed <readn>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a01:	75 74                	jne    801a77 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  801a03:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a0a:	45 4c 46 
  801a0d:	75 68                	jne    801a77 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a0f:	b8 07 00 00 00       	mov    $0x7,%eax
  801a14:	cd 30                	int    $0x30
  801a16:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a1c:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a22:	85 c0                	test   %eax,%eax
  801a24:	0f 88 b6 04 00 00    	js     801ee0 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a2a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a2f:	89 c6                	mov    %eax,%esi
  801a31:	c1 e6 07             	shl    $0x7,%esi
  801a34:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a3a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a40:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a47:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a4d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801a53:	83 ec 08             	sub    $0x8,%esp
  801a56:	68 24 33 80 00       	push   $0x803324
  801a5b:	68 a7 2d 80 00       	push   $0x802da7
  801a60:	e8 d2 e8 ff ff       	call   800337 <cprintf>
  801a65:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a68:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a6d:	be 00 00 00 00       	mov    $0x0,%esi
  801a72:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a75:	eb 4b                	jmp    801ac2 <spawn+0x119>
		close(fd);
  801a77:	83 ec 0c             	sub    $0xc,%esp
  801a7a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a80:	e8 a3 f8 ff ff       	call   801328 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a85:	83 c4 0c             	add    $0xc,%esp
  801a88:	68 7f 45 4c 46       	push   $0x464c457f
  801a8d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a93:	68 57 32 80 00       	push   $0x803257
  801a98:	e8 9a e8 ff ff       	call   800337 <cprintf>
		return -E_NOT_EXEC;
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801aa7:	ff ff ff 
  801aaa:	e9 3d 04 00 00       	jmp    801eec <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801aaf:	83 ec 0c             	sub    $0xc,%esp
  801ab2:	50                   	push   %eax
  801ab3:	e8 a5 ef ff ff       	call   800a5d <strlen>
  801ab8:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801abc:	83 c3 01             	add    $0x1,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801ac9:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801acc:	85 c0                	test   %eax,%eax
  801ace:	75 df                	jne    801aaf <spawn+0x106>
  801ad0:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ad6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801adc:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ae1:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ae3:	89 fa                	mov    %edi,%edx
  801ae5:	83 e2 fc             	and    $0xfffffffc,%edx
  801ae8:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801aef:	29 c2                	sub    %eax,%edx
  801af1:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801af7:	8d 42 f8             	lea    -0x8(%edx),%eax
  801afa:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801aff:	0f 86 0a 04 00 00    	jbe    801f0f <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	6a 07                	push   $0x7
  801b0a:	68 00 00 40 00       	push   $0x400000
  801b0f:	6a 00                	push   $0x0
  801b11:	e8 72 f3 ff ff       	call   800e88 <sys_page_alloc>
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	0f 88 f3 03 00 00    	js     801f14 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b21:	be 00 00 00 00       	mov    $0x0,%esi
  801b26:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b2f:	eb 30                	jmp    801b61 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b31:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b37:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b3d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b40:	83 ec 08             	sub    $0x8,%esp
  801b43:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b46:	57                   	push   %edi
  801b47:	e8 4a ef ff ff       	call   800a96 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b4c:	83 c4 04             	add    $0x4,%esp
  801b4f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b52:	e8 06 ef ff ff       	call   800a5d <strlen>
  801b57:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b5b:	83 c6 01             	add    $0x1,%esi
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b67:	7f c8                	jg     801b31 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801b69:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b6f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b75:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b7c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b82:	0f 85 86 00 00 00    	jne    801c0e <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b88:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801b8e:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801b94:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b97:	89 d0                	mov    %edx,%eax
  801b99:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801b9f:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ba2:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801ba7:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	6a 07                	push   $0x7
  801bb2:	68 00 d0 bf ee       	push   $0xeebfd000
  801bb7:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bbd:	68 00 00 40 00       	push   $0x400000
  801bc2:	6a 00                	push   $0x0
  801bc4:	e8 02 f3 ff ff       	call   800ecb <sys_page_map>
  801bc9:	89 c3                	mov    %eax,%ebx
  801bcb:	83 c4 20             	add    $0x20,%esp
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	0f 88 46 03 00 00    	js     801f1c <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	68 00 00 40 00       	push   $0x400000
  801bde:	6a 00                	push   $0x0
  801be0:	e8 28 f3 ff ff       	call   800f0d <sys_page_unmap>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	0f 88 2a 03 00 00    	js     801f1c <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bf2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bf8:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801bff:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801c06:	00 00 00 
  801c09:	e9 4f 01 00 00       	jmp    801d5d <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c0e:	68 e0 32 80 00       	push   $0x8032e0
  801c13:	68 2b 32 80 00       	push   $0x80322b
  801c18:	68 f8 00 00 00       	push   $0xf8
  801c1d:	68 71 32 80 00       	push   $0x803271
  801c22:	e8 1a e6 ff ff       	call   800241 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	6a 07                	push   $0x7
  801c2c:	68 00 00 40 00       	push   $0x400000
  801c31:	6a 00                	push   $0x0
  801c33:	e8 50 f2 ff ff       	call   800e88 <sys_page_alloc>
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	0f 88 b7 02 00 00    	js     801efa <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c4c:	01 f0                	add    %esi,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c55:	e8 5a f9 ff ff       	call   8015b4 <seek>
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	0f 88 9c 02 00 00    	js     801f01 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c6e:	29 f0                	sub    %esi,%eax
  801c70:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c75:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c7a:	0f 47 c1             	cmova  %ecx,%eax
  801c7d:	50                   	push   %eax
  801c7e:	68 00 00 40 00       	push   $0x400000
  801c83:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c89:	e8 5f f8 ff ff       	call   8014ed <readn>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	85 c0                	test   %eax,%eax
  801c93:	0f 88 6f 02 00 00    	js     801f08 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ca2:	53                   	push   %ebx
  801ca3:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ca9:	68 00 00 40 00       	push   $0x400000
  801cae:	6a 00                	push   $0x0
  801cb0:	e8 16 f2 ff ff       	call   800ecb <sys_page_map>
  801cb5:	83 c4 20             	add    $0x20,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 7c                	js     801d38 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	68 00 00 40 00       	push   $0x400000
  801cc4:	6a 00                	push   $0x0
  801cc6:	e8 42 f2 ff ff       	call   800f0d <sys_page_unmap>
  801ccb:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cce:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cd4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cda:	89 fe                	mov    %edi,%esi
  801cdc:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801ce2:	76 69                	jbe    801d4d <spawn+0x3a4>
		if (i >= filesz) {
  801ce4:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801cea:	0f 87 37 ff ff ff    	ja     801c27 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cf9:	53                   	push   %ebx
  801cfa:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d00:	e8 83 f1 ff ff       	call   800e88 <sys_page_alloc>
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	79 c2                	jns    801cce <spawn+0x325>
  801d0c:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d17:	e8 ed f0 ff ff       	call   800e09 <sys_env_destroy>
	close(fd);
  801d1c:	83 c4 04             	add    $0x4,%esp
  801d1f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d25:	e8 fe f5 ff ff       	call   801328 <close>
	return r;
  801d2a:	83 c4 10             	add    $0x10,%esp
  801d2d:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d33:	e9 b4 01 00 00       	jmp    801eec <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801d38:	50                   	push   %eax
  801d39:	68 7d 32 80 00       	push   $0x80327d
  801d3e:	68 2b 01 00 00       	push   $0x12b
  801d43:	68 71 32 80 00       	push   $0x803271
  801d48:	e8 f4 e4 ff ff       	call   800241 <_panic>
  801d4d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d53:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d5a:	83 c6 20             	add    $0x20,%esi
  801d5d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d64:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d6a:	7e 6d                	jle    801dd9 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801d6c:	83 3e 01             	cmpl   $0x1,(%esi)
  801d6f:	75 e2                	jne    801d53 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d71:	8b 46 18             	mov    0x18(%esi),%eax
  801d74:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d77:	83 f8 01             	cmp    $0x1,%eax
  801d7a:	19 c0                	sbb    %eax,%eax
  801d7c:	83 e0 fe             	and    $0xfffffffe,%eax
  801d7f:	83 c0 07             	add    $0x7,%eax
  801d82:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d88:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d8b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d91:	8b 56 10             	mov    0x10(%esi),%edx
  801d94:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d9a:	8b 7e 14             	mov    0x14(%esi),%edi
  801d9d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801da3:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801da6:	89 d8                	mov    %ebx,%eax
  801da8:	25 ff 0f 00 00       	and    $0xfff,%eax
  801dad:	74 1a                	je     801dc9 <spawn+0x420>
		va -= i;
  801daf:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801db1:	01 c7                	add    %eax,%edi
  801db3:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801db9:	01 c2                	add    %eax,%edx
  801dbb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801dc1:	29 c1                	sub    %eax,%ecx
  801dc3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dce:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801dd4:	e9 01 ff ff ff       	jmp    801cda <spawn+0x331>
	close(fd);
  801dd9:	83 ec 0c             	sub    $0xc,%esp
  801ddc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801de2:	e8 41 f5 ff ff       	call   801328 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801de7:	83 c4 08             	add    $0x8,%esp
  801dea:	68 10 33 80 00       	push   $0x803310
  801def:	68 a7 2d 80 00       	push   $0x802da7
  801df4:	e8 3e e5 ff ff       	call   800337 <cprintf>
  801df9:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801dfc:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801e01:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801e07:	eb 0e                	jmp    801e17 <spawn+0x46e>
  801e09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e0f:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e15:	74 5e                	je     801e75 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801e17:	89 d8                	mov    %ebx,%eax
  801e19:	c1 e8 16             	shr    $0x16,%eax
  801e1c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e23:	a8 01                	test   $0x1,%al
  801e25:	74 e2                	je     801e09 <spawn+0x460>
  801e27:	89 da                	mov    %ebx,%edx
  801e29:	c1 ea 0c             	shr    $0xc,%edx
  801e2c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e33:	25 05 04 00 00       	and    $0x405,%eax
  801e38:	3d 05 04 00 00       	cmp    $0x405,%eax
  801e3d:	75 ca                	jne    801e09 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801e3f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e46:	83 ec 0c             	sub    $0xc,%esp
  801e49:	25 07 0e 00 00       	and    $0xe07,%eax
  801e4e:	50                   	push   %eax
  801e4f:	53                   	push   %ebx
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	6a 00                	push   $0x0
  801e54:	e8 72 f0 ff ff       	call   800ecb <sys_page_map>
  801e59:	83 c4 20             	add    $0x20,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	79 a9                	jns    801e09 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801e60:	50                   	push   %eax
  801e61:	68 9a 32 80 00       	push   $0x80329a
  801e66:	68 3b 01 00 00       	push   $0x13b
  801e6b:	68 71 32 80 00       	push   $0x803271
  801e70:	e8 cc e3 ff ff       	call   800241 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e75:	83 ec 08             	sub    $0x8,%esp
  801e78:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e7e:	50                   	push   %eax
  801e7f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e85:	e8 07 f1 ff ff       	call   800f91 <sys_env_set_trapframe>
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	78 25                	js     801eb6 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e91:	83 ec 08             	sub    $0x8,%esp
  801e94:	6a 02                	push   $0x2
  801e96:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e9c:	e8 ae f0 ff ff       	call   800f4f <sys_env_set_status>
  801ea1:	83 c4 10             	add    $0x10,%esp
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	78 23                	js     801ecb <spawn+0x522>
	return child;
  801ea8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801eae:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801eb4:	eb 36                	jmp    801eec <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801eb6:	50                   	push   %eax
  801eb7:	68 ac 32 80 00       	push   $0x8032ac
  801ebc:	68 8a 00 00 00       	push   $0x8a
  801ec1:	68 71 32 80 00       	push   $0x803271
  801ec6:	e8 76 e3 ff ff       	call   800241 <_panic>
		panic("sys_env_set_status: %e", r);
  801ecb:	50                   	push   %eax
  801ecc:	68 c6 32 80 00       	push   $0x8032c6
  801ed1:	68 8d 00 00 00       	push   $0x8d
  801ed6:	68 71 32 80 00       	push   $0x803271
  801edb:	e8 61 e3 ff ff       	call   800241 <_panic>
		return r;
  801ee0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ee6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801eec:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    
  801efa:	89 c7                	mov    %eax,%edi
  801efc:	e9 0d fe ff ff       	jmp    801d0e <spawn+0x365>
  801f01:	89 c7                	mov    %eax,%edi
  801f03:	e9 06 fe ff ff       	jmp    801d0e <spawn+0x365>
  801f08:	89 c7                	mov    %eax,%edi
  801f0a:	e9 ff fd ff ff       	jmp    801d0e <spawn+0x365>
		return -E_NO_MEM;
  801f0f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801f14:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f1a:	eb d0                	jmp    801eec <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801f1c:	83 ec 08             	sub    $0x8,%esp
  801f1f:	68 00 00 40 00       	push   $0x400000
  801f24:	6a 00                	push   $0x0
  801f26:	e8 e2 ef ff ff       	call   800f0d <sys_page_unmap>
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f34:	eb b6                	jmp    801eec <spawn+0x543>

00801f36 <spawnl>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	57                   	push   %edi
  801f3a:	56                   	push   %esi
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801f3f:	68 08 33 80 00       	push   $0x803308
  801f44:	68 a7 2d 80 00       	push   $0x802da7
  801f49:	e8 e9 e3 ff ff       	call   800337 <cprintf>
	va_start(vl, arg0);
  801f4e:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801f51:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f59:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f5c:	83 3a 00             	cmpl   $0x0,(%edx)
  801f5f:	74 07                	je     801f68 <spawnl+0x32>
		argc++;
  801f61:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f64:	89 ca                	mov    %ecx,%edx
  801f66:	eb f1                	jmp    801f59 <spawnl+0x23>
	const char *argv[argc+2];
  801f68:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f6f:	83 e2 f0             	and    $0xfffffff0,%edx
  801f72:	29 d4                	sub    %edx,%esp
  801f74:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f78:	c1 ea 02             	shr    $0x2,%edx
  801f7b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f82:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f87:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f8e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f95:	00 
	va_start(vl, arg0);
  801f96:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f99:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	eb 0b                	jmp    801fad <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801fa2:	83 c0 01             	add    $0x1,%eax
  801fa5:	8b 39                	mov    (%ecx),%edi
  801fa7:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801faa:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801fad:	39 d0                	cmp    %edx,%eax
  801faf:	75 f1                	jne    801fa2 <spawnl+0x6c>
	return spawn(prog, argv);
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	56                   	push   %esi
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	e8 ec f9 ff ff       	call   8019a9 <spawn>
}
  801fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5f                   	pop    %edi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fcb:	68 36 33 80 00       	push   $0x803336
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	e8 be ea ff ff       	call   800a96 <strcpy>
	return 0;
}
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <devsock_close>:
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	53                   	push   %ebx
  801fe3:	83 ec 10             	sub    $0x10,%esp
  801fe6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fe9:	53                   	push   %ebx
  801fea:	e8 fc 09 00 00       	call   8029eb <pageref>
  801fef:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ff2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ff7:	83 f8 01             	cmp    $0x1,%eax
  801ffa:	74 07                	je     802003 <devsock_close+0x24>
}
  801ffc:	89 d0                	mov    %edx,%eax
  801ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802001:	c9                   	leave  
  802002:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	ff 73 0c             	pushl  0xc(%ebx)
  802009:	e8 b9 02 00 00       	call   8022c7 <nsipc_close>
  80200e:	89 c2                	mov    %eax,%edx
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	eb e7                	jmp    801ffc <devsock_close+0x1d>

00802015 <devsock_write>:
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	ff 75 10             	pushl  0x10(%ebp)
  802020:	ff 75 0c             	pushl  0xc(%ebp)
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	ff 70 0c             	pushl  0xc(%eax)
  802029:	e8 76 03 00 00       	call   8023a4 <nsipc_send>
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <devsock_read>:
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802036:	6a 00                	push   $0x0
  802038:	ff 75 10             	pushl  0x10(%ebp)
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	ff 70 0c             	pushl  0xc(%eax)
  802044:	e8 ef 02 00 00       	call   802338 <nsipc_recv>
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <fd2sockid>:
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802051:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802054:	52                   	push   %edx
  802055:	50                   	push   %eax
  802056:	e8 9b f1 ff ff       	call   8011f6 <fd_lookup>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 10                	js     802072 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80206b:	39 08                	cmp    %ecx,(%eax)
  80206d:	75 05                	jne    802074 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80206f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    
		return -E_NOT_SUPP;
  802074:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802079:	eb f7                	jmp    802072 <fd2sockid+0x27>

0080207b <alloc_sockfd>:
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	83 ec 1c             	sub    $0x1c,%esp
  802083:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802085:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802088:	50                   	push   %eax
  802089:	e8 16 f1 ff ff       	call   8011a4 <fd_alloc>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	78 43                	js     8020da <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	68 07 04 00 00       	push   $0x407
  80209f:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a2:	6a 00                	push   $0x0
  8020a4:	e8 df ed ff ff       	call   800e88 <sys_page_alloc>
  8020a9:	89 c3                	mov    %eax,%ebx
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 28                	js     8020da <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020bb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020c7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	50                   	push   %eax
  8020ce:	e8 aa f0 ff ff       	call   80117d <fd2num>
  8020d3:	89 c3                	mov    %eax,%ebx
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	eb 0c                	jmp    8020e6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	56                   	push   %esi
  8020de:	e8 e4 01 00 00       	call   8022c7 <nsipc_close>
		return r;
  8020e3:	83 c4 10             	add    $0x10,%esp
}
  8020e6:	89 d8                	mov    %ebx,%eax
  8020e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <accept>:
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	e8 4e ff ff ff       	call   80204b <fd2sockid>
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 1b                	js     80211c <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802101:	83 ec 04             	sub    $0x4,%esp
  802104:	ff 75 10             	pushl  0x10(%ebp)
  802107:	ff 75 0c             	pushl  0xc(%ebp)
  80210a:	50                   	push   %eax
  80210b:	e8 0e 01 00 00       	call   80221e <nsipc_accept>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	85 c0                	test   %eax,%eax
  802115:	78 05                	js     80211c <accept+0x2d>
	return alloc_sockfd(r);
  802117:	e8 5f ff ff ff       	call   80207b <alloc_sockfd>
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <bind>:
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	e8 1f ff ff ff       	call   80204b <fd2sockid>
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 12                	js     802142 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	ff 75 10             	pushl  0x10(%ebp)
  802136:	ff 75 0c             	pushl  0xc(%ebp)
  802139:	50                   	push   %eax
  80213a:	e8 31 01 00 00       	call   802270 <nsipc_bind>
  80213f:	83 c4 10             	add    $0x10,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <shutdown>:
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	e8 f9 fe ff ff       	call   80204b <fd2sockid>
  802152:	85 c0                	test   %eax,%eax
  802154:	78 0f                	js     802165 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	50                   	push   %eax
  80215d:	e8 43 01 00 00       	call   8022a5 <nsipc_shutdown>
  802162:	83 c4 10             	add    $0x10,%esp
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <connect>:
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	e8 d6 fe ff ff       	call   80204b <fd2sockid>
  802175:	85 c0                	test   %eax,%eax
  802177:	78 12                	js     80218b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	ff 75 10             	pushl  0x10(%ebp)
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	50                   	push   %eax
  802183:	e8 59 01 00 00       	call   8022e1 <nsipc_connect>
  802188:	83 c4 10             	add    $0x10,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <listen>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	e8 b0 fe ff ff       	call   80204b <fd2sockid>
  80219b:	85 c0                	test   %eax,%eax
  80219d:	78 0f                	js     8021ae <listen+0x21>
	return nsipc_listen(r, backlog);
  80219f:	83 ec 08             	sub    $0x8,%esp
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	50                   	push   %eax
  8021a6:	e8 6b 01 00 00       	call   802316 <nsipc_listen>
  8021ab:	83 c4 10             	add    $0x10,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021b6:	ff 75 10             	pushl  0x10(%ebp)
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	ff 75 08             	pushl  0x8(%ebp)
  8021bf:	e8 3e 02 00 00       	call   802402 <nsipc_socket>
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	78 05                	js     8021d0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021cb:	e8 ab fe ff ff       	call   80207b <alloc_sockfd>
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	53                   	push   %ebx
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021db:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021e2:	74 26                	je     80220a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021e4:	6a 07                	push   $0x7
  8021e6:	68 00 70 80 00       	push   $0x807000
  8021eb:	53                   	push   %ebx
  8021ec:	ff 35 04 50 80 00    	pushl  0x805004
  8021f2:	e8 61 07 00 00       	call   802958 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021f7:	83 c4 0c             	add    $0xc,%esp
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	e8 ea 06 00 00       	call   8028ef <ipc_recv>
}
  802205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802208:	c9                   	leave  
  802209:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80220a:	83 ec 0c             	sub    $0xc,%esp
  80220d:	6a 02                	push   $0x2
  80220f:	e8 9c 07 00 00       	call   8029b0 <ipc_find_env>
  802214:	a3 04 50 80 00       	mov    %eax,0x805004
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	eb c6                	jmp    8021e4 <nsipc+0x12>

0080221e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	56                   	push   %esi
  802222:	53                   	push   %ebx
  802223:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80222e:	8b 06                	mov    (%esi),%eax
  802230:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802235:	b8 01 00 00 00       	mov    $0x1,%eax
  80223a:	e8 93 ff ff ff       	call   8021d2 <nsipc>
  80223f:	89 c3                	mov    %eax,%ebx
  802241:	85 c0                	test   %eax,%eax
  802243:	79 09                	jns    80224e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802245:	89 d8                	mov    %ebx,%eax
  802247:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224a:	5b                   	pop    %ebx
  80224b:	5e                   	pop    %esi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	ff 35 10 70 80 00    	pushl  0x807010
  802257:	68 00 70 80 00       	push   $0x807000
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	e8 c0 e9 ff ff       	call   800c24 <memmove>
		*addrlen = ret->ret_addrlen;
  802264:	a1 10 70 80 00       	mov    0x807010,%eax
  802269:	89 06                	mov    %eax,(%esi)
  80226b:	83 c4 10             	add    $0x10,%esp
	return r;
  80226e:	eb d5                	jmp    802245 <nsipc_accept+0x27>

00802270 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	53                   	push   %ebx
  802274:	83 ec 08             	sub    $0x8,%esp
  802277:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802282:	53                   	push   %ebx
  802283:	ff 75 0c             	pushl  0xc(%ebp)
  802286:	68 04 70 80 00       	push   $0x807004
  80228b:	e8 94 e9 ff ff       	call   800c24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802290:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802296:	b8 02 00 00 00       	mov    $0x2,%eax
  80229b:	e8 32 ff ff ff       	call   8021d2 <nsipc>
}
  8022a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022bb:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c0:	e8 0d ff ff ff       	call   8021d2 <nsipc>
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <nsipc_close>:

int
nsipc_close(int s)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022d5:	b8 04 00 00 00       	mov    $0x4,%eax
  8022da:	e8 f3 fe ff ff       	call   8021d2 <nsipc>
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 08             	sub    $0x8,%esp
  8022e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022f3:	53                   	push   %ebx
  8022f4:	ff 75 0c             	pushl  0xc(%ebp)
  8022f7:	68 04 70 80 00       	push   $0x807004
  8022fc:	e8 23 e9 ff ff       	call   800c24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802301:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802307:	b8 05 00 00 00       	mov    $0x5,%eax
  80230c:	e8 c1 fe ff ff       	call   8021d2 <nsipc>
}
  802311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80232c:	b8 06 00 00 00       	mov    $0x6,%eax
  802331:	e8 9c fe ff ff       	call   8021d2 <nsipc>
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	56                   	push   %esi
  80233c:	53                   	push   %ebx
  80233d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802348:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80234e:	8b 45 14             	mov    0x14(%ebp),%eax
  802351:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802356:	b8 07 00 00 00       	mov    $0x7,%eax
  80235b:	e8 72 fe ff ff       	call   8021d2 <nsipc>
  802360:	89 c3                	mov    %eax,%ebx
  802362:	85 c0                	test   %eax,%eax
  802364:	78 1f                	js     802385 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802366:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80236b:	7f 21                	jg     80238e <nsipc_recv+0x56>
  80236d:	39 c6                	cmp    %eax,%esi
  80236f:	7c 1d                	jl     80238e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	50                   	push   %eax
  802375:	68 00 70 80 00       	push   $0x807000
  80237a:	ff 75 0c             	pushl  0xc(%ebp)
  80237d:	e8 a2 e8 ff ff       	call   800c24 <memmove>
  802382:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802385:	89 d8                	mov    %ebx,%eax
  802387:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80238a:	5b                   	pop    %ebx
  80238b:	5e                   	pop    %esi
  80238c:	5d                   	pop    %ebp
  80238d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80238e:	68 42 33 80 00       	push   $0x803342
  802393:	68 2b 32 80 00       	push   $0x80322b
  802398:	6a 62                	push   $0x62
  80239a:	68 57 33 80 00       	push   $0x803357
  80239f:	e8 9d de ff ff       	call   800241 <_panic>

008023a4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023b6:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023bc:	7f 2e                	jg     8023ec <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	53                   	push   %ebx
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	68 0c 70 80 00       	push   $0x80700c
  8023ca:	e8 55 e8 ff ff       	call   800c24 <memmove>
	nsipcbuf.send.req_size = size;
  8023cf:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e2:	e8 eb fd ff ff       	call   8021d2 <nsipc>
}
  8023e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    
	assert(size < 1600);
  8023ec:	68 63 33 80 00       	push   $0x803363
  8023f1:	68 2b 32 80 00       	push   $0x80322b
  8023f6:	6a 6d                	push   $0x6d
  8023f8:	68 57 33 80 00       	push   $0x803357
  8023fd:	e8 3f de ff ff       	call   800241 <_panic>

00802402 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802410:	8b 45 0c             	mov    0xc(%ebp),%eax
  802413:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802418:	8b 45 10             	mov    0x10(%ebp),%eax
  80241b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802420:	b8 09 00 00 00       	mov    $0x9,%eax
  802425:	e8 a8 fd ff ff       	call   8021d2 <nsipc>
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	56                   	push   %esi
  802430:	53                   	push   %ebx
  802431:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	ff 75 08             	pushl  0x8(%ebp)
  80243a:	e8 4e ed ff ff       	call   80118d <fd2data>
  80243f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802441:	83 c4 08             	add    $0x8,%esp
  802444:	68 6f 33 80 00       	push   $0x80336f
  802449:	53                   	push   %ebx
  80244a:	e8 47 e6 ff ff       	call   800a96 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80244f:	8b 46 04             	mov    0x4(%esi),%eax
  802452:	2b 06                	sub    (%esi),%eax
  802454:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80245a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802461:	00 00 00 
	stat->st_dev = &devpipe;
  802464:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80246b:	40 80 00 
	return 0;
}
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802476:	5b                   	pop    %ebx
  802477:	5e                   	pop    %esi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	53                   	push   %ebx
  80247e:	83 ec 0c             	sub    $0xc,%esp
  802481:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802484:	53                   	push   %ebx
  802485:	6a 00                	push   $0x0
  802487:	e8 81 ea ff ff       	call   800f0d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80248c:	89 1c 24             	mov    %ebx,(%esp)
  80248f:	e8 f9 ec ff ff       	call   80118d <fd2data>
  802494:	83 c4 08             	add    $0x8,%esp
  802497:	50                   	push   %eax
  802498:	6a 00                	push   $0x0
  80249a:	e8 6e ea ff ff       	call   800f0d <sys_page_unmap>
}
  80249f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <_pipeisclosed>:
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
  8024a7:	57                   	push   %edi
  8024a8:	56                   	push   %esi
  8024a9:	53                   	push   %ebx
  8024aa:	83 ec 1c             	sub    $0x1c,%esp
  8024ad:	89 c7                	mov    %eax,%edi
  8024af:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024b9:	83 ec 0c             	sub    $0xc,%esp
  8024bc:	57                   	push   %edi
  8024bd:	e8 29 05 00 00       	call   8029eb <pageref>
  8024c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024c5:	89 34 24             	mov    %esi,(%esp)
  8024c8:	e8 1e 05 00 00       	call   8029eb <pageref>
		nn = thisenv->env_runs;
  8024cd:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024d3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024d6:	83 c4 10             	add    $0x10,%esp
  8024d9:	39 cb                	cmp    %ecx,%ebx
  8024db:	74 1b                	je     8024f8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024dd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024e0:	75 cf                	jne    8024b1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024e2:	8b 42 58             	mov    0x58(%edx),%eax
  8024e5:	6a 01                	push   $0x1
  8024e7:	50                   	push   %eax
  8024e8:	53                   	push   %ebx
  8024e9:	68 76 33 80 00       	push   $0x803376
  8024ee:	e8 44 de ff ff       	call   800337 <cprintf>
  8024f3:	83 c4 10             	add    $0x10,%esp
  8024f6:	eb b9                	jmp    8024b1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024f8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024fb:	0f 94 c0             	sete   %al
  8024fe:	0f b6 c0             	movzbl %al,%eax
}
  802501:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802504:	5b                   	pop    %ebx
  802505:	5e                   	pop    %esi
  802506:	5f                   	pop    %edi
  802507:	5d                   	pop    %ebp
  802508:	c3                   	ret    

00802509 <devpipe_write>:
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	57                   	push   %edi
  80250d:	56                   	push   %esi
  80250e:	53                   	push   %ebx
  80250f:	83 ec 28             	sub    $0x28,%esp
  802512:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802515:	56                   	push   %esi
  802516:	e8 72 ec ff ff       	call   80118d <fd2data>
  80251b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80251d:	83 c4 10             	add    $0x10,%esp
  802520:	bf 00 00 00 00       	mov    $0x0,%edi
  802525:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802528:	74 4f                	je     802579 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80252a:	8b 43 04             	mov    0x4(%ebx),%eax
  80252d:	8b 0b                	mov    (%ebx),%ecx
  80252f:	8d 51 20             	lea    0x20(%ecx),%edx
  802532:	39 d0                	cmp    %edx,%eax
  802534:	72 14                	jb     80254a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802536:	89 da                	mov    %ebx,%edx
  802538:	89 f0                	mov    %esi,%eax
  80253a:	e8 65 ff ff ff       	call   8024a4 <_pipeisclosed>
  80253f:	85 c0                	test   %eax,%eax
  802541:	75 3b                	jne    80257e <devpipe_write+0x75>
			sys_yield();
  802543:	e8 21 e9 ff ff       	call   800e69 <sys_yield>
  802548:	eb e0                	jmp    80252a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80254a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80254d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802551:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802554:	89 c2                	mov    %eax,%edx
  802556:	c1 fa 1f             	sar    $0x1f,%edx
  802559:	89 d1                	mov    %edx,%ecx
  80255b:	c1 e9 1b             	shr    $0x1b,%ecx
  80255e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802561:	83 e2 1f             	and    $0x1f,%edx
  802564:	29 ca                	sub    %ecx,%edx
  802566:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80256a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80256e:	83 c0 01             	add    $0x1,%eax
  802571:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802574:	83 c7 01             	add    $0x1,%edi
  802577:	eb ac                	jmp    802525 <devpipe_write+0x1c>
	return i;
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	eb 05                	jmp    802583 <devpipe_write+0x7a>
				return 0;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802583:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802586:	5b                   	pop    %ebx
  802587:	5e                   	pop    %esi
  802588:	5f                   	pop    %edi
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    

0080258b <devpipe_read>:
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	57                   	push   %edi
  80258f:	56                   	push   %esi
  802590:	53                   	push   %ebx
  802591:	83 ec 18             	sub    $0x18,%esp
  802594:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802597:	57                   	push   %edi
  802598:	e8 f0 eb ff ff       	call   80118d <fd2data>
  80259d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	be 00 00 00 00       	mov    $0x0,%esi
  8025a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025aa:	75 14                	jne    8025c0 <devpipe_read+0x35>
	return i;
  8025ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8025af:	eb 02                	jmp    8025b3 <devpipe_read+0x28>
				return i;
  8025b1:	89 f0                	mov    %esi,%eax
}
  8025b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b6:	5b                   	pop    %ebx
  8025b7:	5e                   	pop    %esi
  8025b8:	5f                   	pop    %edi
  8025b9:	5d                   	pop    %ebp
  8025ba:	c3                   	ret    
			sys_yield();
  8025bb:	e8 a9 e8 ff ff       	call   800e69 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025c0:	8b 03                	mov    (%ebx),%eax
  8025c2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c5:	75 18                	jne    8025df <devpipe_read+0x54>
			if (i > 0)
  8025c7:	85 f6                	test   %esi,%esi
  8025c9:	75 e6                	jne    8025b1 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025cb:	89 da                	mov    %ebx,%edx
  8025cd:	89 f8                	mov    %edi,%eax
  8025cf:	e8 d0 fe ff ff       	call   8024a4 <_pipeisclosed>
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 e3                	je     8025bb <devpipe_read+0x30>
				return 0;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	eb d4                	jmp    8025b3 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025df:	99                   	cltd   
  8025e0:	c1 ea 1b             	shr    $0x1b,%edx
  8025e3:	01 d0                	add    %edx,%eax
  8025e5:	83 e0 1f             	and    $0x1f,%eax
  8025e8:	29 d0                	sub    %edx,%eax
  8025ea:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025f5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025f8:	83 c6 01             	add    $0x1,%esi
  8025fb:	eb aa                	jmp    8025a7 <devpipe_read+0x1c>

008025fd <pipe>:
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802605:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802608:	50                   	push   %eax
  802609:	e8 96 eb ff ff       	call   8011a4 <fd_alloc>
  80260e:	89 c3                	mov    %eax,%ebx
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 88 23 01 00 00    	js     80273e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261b:	83 ec 04             	sub    $0x4,%esp
  80261e:	68 07 04 00 00       	push   $0x407
  802623:	ff 75 f4             	pushl  -0xc(%ebp)
  802626:	6a 00                	push   $0x0
  802628:	e8 5b e8 ff ff       	call   800e88 <sys_page_alloc>
  80262d:	89 c3                	mov    %eax,%ebx
  80262f:	83 c4 10             	add    $0x10,%esp
  802632:	85 c0                	test   %eax,%eax
  802634:	0f 88 04 01 00 00    	js     80273e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80263a:	83 ec 0c             	sub    $0xc,%esp
  80263d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802640:	50                   	push   %eax
  802641:	e8 5e eb ff ff       	call   8011a4 <fd_alloc>
  802646:	89 c3                	mov    %eax,%ebx
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	85 c0                	test   %eax,%eax
  80264d:	0f 88 db 00 00 00    	js     80272e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802653:	83 ec 04             	sub    $0x4,%esp
  802656:	68 07 04 00 00       	push   $0x407
  80265b:	ff 75 f0             	pushl  -0x10(%ebp)
  80265e:	6a 00                	push   $0x0
  802660:	e8 23 e8 ff ff       	call   800e88 <sys_page_alloc>
  802665:	89 c3                	mov    %eax,%ebx
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	85 c0                	test   %eax,%eax
  80266c:	0f 88 bc 00 00 00    	js     80272e <pipe+0x131>
	va = fd2data(fd0);
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	ff 75 f4             	pushl  -0xc(%ebp)
  802678:	e8 10 eb ff ff       	call   80118d <fd2data>
  80267d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267f:	83 c4 0c             	add    $0xc,%esp
  802682:	68 07 04 00 00       	push   $0x407
  802687:	50                   	push   %eax
  802688:	6a 00                	push   $0x0
  80268a:	e8 f9 e7 ff ff       	call   800e88 <sys_page_alloc>
  80268f:	89 c3                	mov    %eax,%ebx
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	85 c0                	test   %eax,%eax
  802696:	0f 88 82 00 00 00    	js     80271e <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269c:	83 ec 0c             	sub    $0xc,%esp
  80269f:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a2:	e8 e6 ea ff ff       	call   80118d <fd2data>
  8026a7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026ae:	50                   	push   %eax
  8026af:	6a 00                	push   $0x0
  8026b1:	56                   	push   %esi
  8026b2:	6a 00                	push   $0x0
  8026b4:	e8 12 e8 ff ff       	call   800ecb <sys_page_map>
  8026b9:	89 c3                	mov    %eax,%ebx
  8026bb:	83 c4 20             	add    $0x20,%esp
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	78 4e                	js     802710 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026c2:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026de:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026eb:	e8 8d ea ff ff       	call   80117d <fd2num>
  8026f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026f5:	83 c4 04             	add    $0x4,%esp
  8026f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fb:	e8 7d ea ff ff       	call   80117d <fd2num>
  802700:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802703:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802706:	83 c4 10             	add    $0x10,%esp
  802709:	bb 00 00 00 00       	mov    $0x0,%ebx
  80270e:	eb 2e                	jmp    80273e <pipe+0x141>
	sys_page_unmap(0, va);
  802710:	83 ec 08             	sub    $0x8,%esp
  802713:	56                   	push   %esi
  802714:	6a 00                	push   $0x0
  802716:	e8 f2 e7 ff ff       	call   800f0d <sys_page_unmap>
  80271b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80271e:	83 ec 08             	sub    $0x8,%esp
  802721:	ff 75 f0             	pushl  -0x10(%ebp)
  802724:	6a 00                	push   $0x0
  802726:	e8 e2 e7 ff ff       	call   800f0d <sys_page_unmap>
  80272b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80272e:	83 ec 08             	sub    $0x8,%esp
  802731:	ff 75 f4             	pushl  -0xc(%ebp)
  802734:	6a 00                	push   $0x0
  802736:	e8 d2 e7 ff ff       	call   800f0d <sys_page_unmap>
  80273b:	83 c4 10             	add    $0x10,%esp
}
  80273e:	89 d8                	mov    %ebx,%eax
  802740:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802743:	5b                   	pop    %ebx
  802744:	5e                   	pop    %esi
  802745:	5d                   	pop    %ebp
  802746:	c3                   	ret    

00802747 <pipeisclosed>:
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80274d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802750:	50                   	push   %eax
  802751:	ff 75 08             	pushl  0x8(%ebp)
  802754:	e8 9d ea ff ff       	call   8011f6 <fd_lookup>
  802759:	83 c4 10             	add    $0x10,%esp
  80275c:	85 c0                	test   %eax,%eax
  80275e:	78 18                	js     802778 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802760:	83 ec 0c             	sub    $0xc,%esp
  802763:	ff 75 f4             	pushl  -0xc(%ebp)
  802766:	e8 22 ea ff ff       	call   80118d <fd2data>
	return _pipeisclosed(fd, p);
  80276b:	89 c2                	mov    %eax,%edx
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	e8 2f fd ff ff       	call   8024a4 <_pipeisclosed>
  802775:	83 c4 10             	add    $0x10,%esp
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
  80277f:	c3                   	ret    

00802780 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802786:	68 8e 33 80 00       	push   $0x80338e
  80278b:	ff 75 0c             	pushl  0xc(%ebp)
  80278e:	e8 03 e3 ff ff       	call   800a96 <strcpy>
	return 0;
}
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <devcons_write>:
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	57                   	push   %edi
  80279e:	56                   	push   %esi
  80279f:	53                   	push   %ebx
  8027a0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027a6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027b4:	73 31                	jae    8027e7 <devcons_write+0x4d>
		m = n - tot;
  8027b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027b9:	29 f3                	sub    %esi,%ebx
  8027bb:	83 fb 7f             	cmp    $0x7f,%ebx
  8027be:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027c3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027c6:	83 ec 04             	sub    $0x4,%esp
  8027c9:	53                   	push   %ebx
  8027ca:	89 f0                	mov    %esi,%eax
  8027cc:	03 45 0c             	add    0xc(%ebp),%eax
  8027cf:	50                   	push   %eax
  8027d0:	57                   	push   %edi
  8027d1:	e8 4e e4 ff ff       	call   800c24 <memmove>
		sys_cputs(buf, m);
  8027d6:	83 c4 08             	add    $0x8,%esp
  8027d9:	53                   	push   %ebx
  8027da:	57                   	push   %edi
  8027db:	e8 ec e5 ff ff       	call   800dcc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027e0:	01 de                	add    %ebx,%esi
  8027e2:	83 c4 10             	add    $0x10,%esp
  8027e5:	eb ca                	jmp    8027b1 <devcons_write+0x17>
}
  8027e7:	89 f0                	mov    %esi,%eax
  8027e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027ec:	5b                   	pop    %ebx
  8027ed:	5e                   	pop    %esi
  8027ee:	5f                   	pop    %edi
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    

008027f1 <devcons_read>:
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 08             	sub    $0x8,%esp
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802800:	74 21                	je     802823 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802802:	e8 e3 e5 ff ff       	call   800dea <sys_cgetc>
  802807:	85 c0                	test   %eax,%eax
  802809:	75 07                	jne    802812 <devcons_read+0x21>
		sys_yield();
  80280b:	e8 59 e6 ff ff       	call   800e69 <sys_yield>
  802810:	eb f0                	jmp    802802 <devcons_read+0x11>
	if (c < 0)
  802812:	78 0f                	js     802823 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802814:	83 f8 04             	cmp    $0x4,%eax
  802817:	74 0c                	je     802825 <devcons_read+0x34>
	*(char*)vbuf = c;
  802819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281c:	88 02                	mov    %al,(%edx)
	return 1;
  80281e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    
		return 0;
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	eb f7                	jmp    802823 <devcons_read+0x32>

0080282c <cputchar>:
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802838:	6a 01                	push   $0x1
  80283a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80283d:	50                   	push   %eax
  80283e:	e8 89 e5 ff ff       	call   800dcc <sys_cputs>
}
  802843:	83 c4 10             	add    $0x10,%esp
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <getchar>:
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
  80284b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80284e:	6a 01                	push   $0x1
  802850:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802853:	50                   	push   %eax
  802854:	6a 00                	push   $0x0
  802856:	e8 0b ec ff ff       	call   801466 <read>
	if (r < 0)
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	85 c0                	test   %eax,%eax
  802860:	78 06                	js     802868 <getchar+0x20>
	if (r < 1)
  802862:	74 06                	je     80286a <getchar+0x22>
	return c;
  802864:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    
		return -E_EOF;
  80286a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80286f:	eb f7                	jmp    802868 <getchar+0x20>

00802871 <iscons>:
{
  802871:	55                   	push   %ebp
  802872:	89 e5                	mov    %esp,%ebp
  802874:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287a:	50                   	push   %eax
  80287b:	ff 75 08             	pushl  0x8(%ebp)
  80287e:	e8 73 e9 ff ff       	call   8011f6 <fd_lookup>
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	85 c0                	test   %eax,%eax
  802888:	78 11                	js     80289b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802893:	39 10                	cmp    %edx,(%eax)
  802895:	0f 94 c0             	sete   %al
  802898:	0f b6 c0             	movzbl %al,%eax
}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <opencons>:
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
  8028a0:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a6:	50                   	push   %eax
  8028a7:	e8 f8 e8 ff ff       	call   8011a4 <fd_alloc>
  8028ac:	83 c4 10             	add    $0x10,%esp
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	78 3a                	js     8028ed <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028b3:	83 ec 04             	sub    $0x4,%esp
  8028b6:	68 07 04 00 00       	push   $0x407
  8028bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8028be:	6a 00                	push   $0x0
  8028c0:	e8 c3 e5 ff ff       	call   800e88 <sys_page_alloc>
  8028c5:	83 c4 10             	add    $0x10,%esp
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	78 21                	js     8028ed <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e1:	83 ec 0c             	sub    $0xc,%esp
  8028e4:	50                   	push   %eax
  8028e5:	e8 93 e8 ff ff       	call   80117d <fd2num>
  8028ea:	83 c4 10             	add    $0x10,%esp
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    

008028ef <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8028f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8028fd:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028ff:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802904:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	50                   	push   %eax
  80290b:	e8 28 e7 ff ff       	call   801038 <sys_ipc_recv>
	if(ret < 0){
  802910:	83 c4 10             	add    $0x10,%esp
  802913:	85 c0                	test   %eax,%eax
  802915:	78 2b                	js     802942 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802917:	85 f6                	test   %esi,%esi
  802919:	74 0a                	je     802925 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80291b:	a1 08 50 80 00       	mov    0x805008,%eax
  802920:	8b 40 74             	mov    0x74(%eax),%eax
  802923:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802925:	85 db                	test   %ebx,%ebx
  802927:	74 0a                	je     802933 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802929:	a1 08 50 80 00       	mov    0x805008,%eax
  80292e:	8b 40 78             	mov    0x78(%eax),%eax
  802931:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802933:	a1 08 50 80 00       	mov    0x805008,%eax
  802938:	8b 40 70             	mov    0x70(%eax),%eax
}
  80293b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80293e:	5b                   	pop    %ebx
  80293f:	5e                   	pop    %esi
  802940:	5d                   	pop    %ebp
  802941:	c3                   	ret    
		if(from_env_store)
  802942:	85 f6                	test   %esi,%esi
  802944:	74 06                	je     80294c <ipc_recv+0x5d>
			*from_env_store = 0;
  802946:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80294c:	85 db                	test   %ebx,%ebx
  80294e:	74 eb                	je     80293b <ipc_recv+0x4c>
			*perm_store = 0;
  802950:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802956:	eb e3                	jmp    80293b <ipc_recv+0x4c>

00802958 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
  80295b:	57                   	push   %edi
  80295c:	56                   	push   %esi
  80295d:	53                   	push   %ebx
  80295e:	83 ec 0c             	sub    $0xc,%esp
  802961:	8b 7d 08             	mov    0x8(%ebp),%edi
  802964:	8b 75 0c             	mov    0xc(%ebp),%esi
  802967:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80296a:	85 db                	test   %ebx,%ebx
  80296c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802971:	0f 44 d8             	cmove  %eax,%ebx
  802974:	eb 05                	jmp    80297b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802976:	e8 ee e4 ff ff       	call   800e69 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80297b:	ff 75 14             	pushl  0x14(%ebp)
  80297e:	53                   	push   %ebx
  80297f:	56                   	push   %esi
  802980:	57                   	push   %edi
  802981:	e8 8f e6 ff ff       	call   801015 <sys_ipc_try_send>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 1b                	je     8029a8 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80298d:	79 e7                	jns    802976 <ipc_send+0x1e>
  80298f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802992:	74 e2                	je     802976 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 9a 33 80 00       	push   $0x80339a
  80299c:	6a 46                	push   $0x46
  80299e:	68 af 33 80 00       	push   $0x8033af
  8029a3:	e8 99 d8 ff ff       	call   800241 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ab:	5b                   	pop    %ebx
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    

008029b0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
  8029b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029bb:	89 c2                	mov    %eax,%edx
  8029bd:	c1 e2 07             	shl    $0x7,%edx
  8029c0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029c6:	8b 52 50             	mov    0x50(%edx),%edx
  8029c9:	39 ca                	cmp    %ecx,%edx
  8029cb:	74 11                	je     8029de <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029cd:	83 c0 01             	add    $0x1,%eax
  8029d0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029d5:	75 e4                	jne    8029bb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029dc:	eb 0b                	jmp    8029e9 <ipc_find_env+0x39>
			return envs[i].env_id;
  8029de:	c1 e0 07             	shl    $0x7,%eax
  8029e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029e6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029e9:	5d                   	pop    %ebp
  8029ea:	c3                   	ret    

008029eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029f1:	89 d0                	mov    %edx,%eax
  8029f3:	c1 e8 16             	shr    $0x16,%eax
  8029f6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a02:	f6 c1 01             	test   $0x1,%cl
  802a05:	74 1d                	je     802a24 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a07:	c1 ea 0c             	shr    $0xc,%edx
  802a0a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a11:	f6 c2 01             	test   $0x1,%dl
  802a14:	74 0e                	je     802a24 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a16:	c1 ea 0c             	shr    $0xc,%edx
  802a19:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a20:	ef 
  802a21:	0f b7 c0             	movzwl %ax,%eax
}
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	66 90                	xchg   %ax,%ax
  802a2a:	66 90                	xchg   %ax,%ax
  802a2c:	66 90                	xchg   %ax,%ax
  802a2e:	66 90                	xchg   %ax,%ax

00802a30 <__udivdi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 1c             	sub    $0x1c,%esp
  802a37:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a3b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a43:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a47:	85 d2                	test   %edx,%edx
  802a49:	75 4d                	jne    802a98 <__udivdi3+0x68>
  802a4b:	39 f3                	cmp    %esi,%ebx
  802a4d:	76 19                	jbe    802a68 <__udivdi3+0x38>
  802a4f:	31 ff                	xor    %edi,%edi
  802a51:	89 e8                	mov    %ebp,%eax
  802a53:	89 f2                	mov    %esi,%edx
  802a55:	f7 f3                	div    %ebx
  802a57:	89 fa                	mov    %edi,%edx
  802a59:	83 c4 1c             	add    $0x1c,%esp
  802a5c:	5b                   	pop    %ebx
  802a5d:	5e                   	pop    %esi
  802a5e:	5f                   	pop    %edi
  802a5f:	5d                   	pop    %ebp
  802a60:	c3                   	ret    
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	89 d9                	mov    %ebx,%ecx
  802a6a:	85 db                	test   %ebx,%ebx
  802a6c:	75 0b                	jne    802a79 <__udivdi3+0x49>
  802a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a73:	31 d2                	xor    %edx,%edx
  802a75:	f7 f3                	div    %ebx
  802a77:	89 c1                	mov    %eax,%ecx
  802a79:	31 d2                	xor    %edx,%edx
  802a7b:	89 f0                	mov    %esi,%eax
  802a7d:	f7 f1                	div    %ecx
  802a7f:	89 c6                	mov    %eax,%esi
  802a81:	89 e8                	mov    %ebp,%eax
  802a83:	89 f7                	mov    %esi,%edi
  802a85:	f7 f1                	div    %ecx
  802a87:	89 fa                	mov    %edi,%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	39 f2                	cmp    %esi,%edx
  802a9a:	77 1c                	ja     802ab8 <__udivdi3+0x88>
  802a9c:	0f bd fa             	bsr    %edx,%edi
  802a9f:	83 f7 1f             	xor    $0x1f,%edi
  802aa2:	75 2c                	jne    802ad0 <__udivdi3+0xa0>
  802aa4:	39 f2                	cmp    %esi,%edx
  802aa6:	72 06                	jb     802aae <__udivdi3+0x7e>
  802aa8:	31 c0                	xor    %eax,%eax
  802aaa:	39 eb                	cmp    %ebp,%ebx
  802aac:	77 a9                	ja     802a57 <__udivdi3+0x27>
  802aae:	b8 01 00 00 00       	mov    $0x1,%eax
  802ab3:	eb a2                	jmp    802a57 <__udivdi3+0x27>
  802ab5:	8d 76 00             	lea    0x0(%esi),%esi
  802ab8:	31 ff                	xor    %edi,%edi
  802aba:	31 c0                	xor    %eax,%eax
  802abc:	89 fa                	mov    %edi,%edx
  802abe:	83 c4 1c             	add    $0x1c,%esp
  802ac1:	5b                   	pop    %ebx
  802ac2:	5e                   	pop    %esi
  802ac3:	5f                   	pop    %edi
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    
  802ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802acd:	8d 76 00             	lea    0x0(%esi),%esi
  802ad0:	89 f9                	mov    %edi,%ecx
  802ad2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ad7:	29 f8                	sub    %edi,%eax
  802ad9:	d3 e2                	shl    %cl,%edx
  802adb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802adf:	89 c1                	mov    %eax,%ecx
  802ae1:	89 da                	mov    %ebx,%edx
  802ae3:	d3 ea                	shr    %cl,%edx
  802ae5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ae9:	09 d1                	or     %edx,%ecx
  802aeb:	89 f2                	mov    %esi,%edx
  802aed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802af1:	89 f9                	mov    %edi,%ecx
  802af3:	d3 e3                	shl    %cl,%ebx
  802af5:	89 c1                	mov    %eax,%ecx
  802af7:	d3 ea                	shr    %cl,%edx
  802af9:	89 f9                	mov    %edi,%ecx
  802afb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802aff:	89 eb                	mov    %ebp,%ebx
  802b01:	d3 e6                	shl    %cl,%esi
  802b03:	89 c1                	mov    %eax,%ecx
  802b05:	d3 eb                	shr    %cl,%ebx
  802b07:	09 de                	or     %ebx,%esi
  802b09:	89 f0                	mov    %esi,%eax
  802b0b:	f7 74 24 08          	divl   0x8(%esp)
  802b0f:	89 d6                	mov    %edx,%esi
  802b11:	89 c3                	mov    %eax,%ebx
  802b13:	f7 64 24 0c          	mull   0xc(%esp)
  802b17:	39 d6                	cmp    %edx,%esi
  802b19:	72 15                	jb     802b30 <__udivdi3+0x100>
  802b1b:	89 f9                	mov    %edi,%ecx
  802b1d:	d3 e5                	shl    %cl,%ebp
  802b1f:	39 c5                	cmp    %eax,%ebp
  802b21:	73 04                	jae    802b27 <__udivdi3+0xf7>
  802b23:	39 d6                	cmp    %edx,%esi
  802b25:	74 09                	je     802b30 <__udivdi3+0x100>
  802b27:	89 d8                	mov    %ebx,%eax
  802b29:	31 ff                	xor    %edi,%edi
  802b2b:	e9 27 ff ff ff       	jmp    802a57 <__udivdi3+0x27>
  802b30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b33:	31 ff                	xor    %edi,%edi
  802b35:	e9 1d ff ff ff       	jmp    802a57 <__udivdi3+0x27>
  802b3a:	66 90                	xchg   %ax,%ax
  802b3c:	66 90                	xchg   %ax,%ax
  802b3e:	66 90                	xchg   %ax,%ax

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	57                   	push   %edi
  802b42:	56                   	push   %esi
  802b43:	53                   	push   %ebx
  802b44:	83 ec 1c             	sub    $0x1c,%esp
  802b47:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b4f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b57:	89 da                	mov    %ebx,%edx
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	75 43                	jne    802ba0 <__umoddi3+0x60>
  802b5d:	39 df                	cmp    %ebx,%edi
  802b5f:	76 17                	jbe    802b78 <__umoddi3+0x38>
  802b61:	89 f0                	mov    %esi,%eax
  802b63:	f7 f7                	div    %edi
  802b65:	89 d0                	mov    %edx,%eax
  802b67:	31 d2                	xor    %edx,%edx
  802b69:	83 c4 1c             	add    $0x1c,%esp
  802b6c:	5b                   	pop    %ebx
  802b6d:	5e                   	pop    %esi
  802b6e:	5f                   	pop    %edi
  802b6f:	5d                   	pop    %ebp
  802b70:	c3                   	ret    
  802b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b78:	89 fd                	mov    %edi,%ebp
  802b7a:	85 ff                	test   %edi,%edi
  802b7c:	75 0b                	jne    802b89 <__umoddi3+0x49>
  802b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b83:	31 d2                	xor    %edx,%edx
  802b85:	f7 f7                	div    %edi
  802b87:	89 c5                	mov    %eax,%ebp
  802b89:	89 d8                	mov    %ebx,%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	f7 f5                	div    %ebp
  802b8f:	89 f0                	mov    %esi,%eax
  802b91:	f7 f5                	div    %ebp
  802b93:	89 d0                	mov    %edx,%eax
  802b95:	eb d0                	jmp    802b67 <__umoddi3+0x27>
  802b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	89 f1                	mov    %esi,%ecx
  802ba2:	39 d8                	cmp    %ebx,%eax
  802ba4:	76 0a                	jbe    802bb0 <__umoddi3+0x70>
  802ba6:	89 f0                	mov    %esi,%eax
  802ba8:	83 c4 1c             	add    $0x1c,%esp
  802bab:	5b                   	pop    %ebx
  802bac:	5e                   	pop    %esi
  802bad:	5f                   	pop    %edi
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    
  802bb0:	0f bd e8             	bsr    %eax,%ebp
  802bb3:	83 f5 1f             	xor    $0x1f,%ebp
  802bb6:	75 20                	jne    802bd8 <__umoddi3+0x98>
  802bb8:	39 d8                	cmp    %ebx,%eax
  802bba:	0f 82 b0 00 00 00    	jb     802c70 <__umoddi3+0x130>
  802bc0:	39 f7                	cmp    %esi,%edi
  802bc2:	0f 86 a8 00 00 00    	jbe    802c70 <__umoddi3+0x130>
  802bc8:	89 c8                	mov    %ecx,%eax
  802bca:	83 c4 1c             	add    $0x1c,%esp
  802bcd:	5b                   	pop    %ebx
  802bce:	5e                   	pop    %esi
  802bcf:	5f                   	pop    %edi
  802bd0:	5d                   	pop    %ebp
  802bd1:	c3                   	ret    
  802bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bd8:	89 e9                	mov    %ebp,%ecx
  802bda:	ba 20 00 00 00       	mov    $0x20,%edx
  802bdf:	29 ea                	sub    %ebp,%edx
  802be1:	d3 e0                	shl    %cl,%eax
  802be3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802be7:	89 d1                	mov    %edx,%ecx
  802be9:	89 f8                	mov    %edi,%eax
  802beb:	d3 e8                	shr    %cl,%eax
  802bed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bf5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bf9:	09 c1                	or     %eax,%ecx
  802bfb:	89 d8                	mov    %ebx,%eax
  802bfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c01:	89 e9                	mov    %ebp,%ecx
  802c03:	d3 e7                	shl    %cl,%edi
  802c05:	89 d1                	mov    %edx,%ecx
  802c07:	d3 e8                	shr    %cl,%eax
  802c09:	89 e9                	mov    %ebp,%ecx
  802c0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c0f:	d3 e3                	shl    %cl,%ebx
  802c11:	89 c7                	mov    %eax,%edi
  802c13:	89 d1                	mov    %edx,%ecx
  802c15:	89 f0                	mov    %esi,%eax
  802c17:	d3 e8                	shr    %cl,%eax
  802c19:	89 e9                	mov    %ebp,%ecx
  802c1b:	89 fa                	mov    %edi,%edx
  802c1d:	d3 e6                	shl    %cl,%esi
  802c1f:	09 d8                	or     %ebx,%eax
  802c21:	f7 74 24 08          	divl   0x8(%esp)
  802c25:	89 d1                	mov    %edx,%ecx
  802c27:	89 f3                	mov    %esi,%ebx
  802c29:	f7 64 24 0c          	mull   0xc(%esp)
  802c2d:	89 c6                	mov    %eax,%esi
  802c2f:	89 d7                	mov    %edx,%edi
  802c31:	39 d1                	cmp    %edx,%ecx
  802c33:	72 06                	jb     802c3b <__umoddi3+0xfb>
  802c35:	75 10                	jne    802c47 <__umoddi3+0x107>
  802c37:	39 c3                	cmp    %eax,%ebx
  802c39:	73 0c                	jae    802c47 <__umoddi3+0x107>
  802c3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c43:	89 d7                	mov    %edx,%edi
  802c45:	89 c6                	mov    %eax,%esi
  802c47:	89 ca                	mov    %ecx,%edx
  802c49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c4e:	29 f3                	sub    %esi,%ebx
  802c50:	19 fa                	sbb    %edi,%edx
  802c52:	89 d0                	mov    %edx,%eax
  802c54:	d3 e0                	shl    %cl,%eax
  802c56:	89 e9                	mov    %ebp,%ecx
  802c58:	d3 eb                	shr    %cl,%ebx
  802c5a:	d3 ea                	shr    %cl,%edx
  802c5c:	09 d8                	or     %ebx,%eax
  802c5e:	83 c4 1c             	add    $0x1c,%esp
  802c61:	5b                   	pop    %ebx
  802c62:	5e                   	pop    %esi
  802c63:	5f                   	pop    %edi
  802c64:	5d                   	pop    %ebp
  802c65:	c3                   	ret    
  802c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c6d:	8d 76 00             	lea    0x0(%esi),%esi
  802c70:	89 da                	mov    %ebx,%edx
  802c72:	29 fe                	sub    %edi,%esi
  802c74:	19 c2                	sbb    %eax,%edx
  802c76:	89 f1                	mov    %esi,%ecx
  802c78:	89 c8                	mov    %ecx,%eax
  802c7a:	e9 4b ff ff ff       	jmp    802bca <__umoddi3+0x8a>
