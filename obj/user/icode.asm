
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
  80003e:	c7 05 00 40 80 00 60 	movl   $0x802c60,0x804000
  800045:	2c 80 00 

	cprintf("icode startup\n");
  800048:	68 66 2c 80 00       	push   $0x802c66
  80004d:	e8 e5 02 00 00       	call   800337 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  800059:	e8 d9 02 00 00       	call   800337 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 88 2c 80 00       	push   $0x802c88
  800068:	e8 77 18 00 00       	call   8018e4 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 b1 2c 80 00       	push   $0x802cb1
  80007e:	e8 b4 02 00 00       	call   800337 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 ab 13 00 00       	call   801446 <read>
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
  8000b2:	68 8e 2c 80 00       	push   $0x802c8e
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 a4 2c 80 00       	push   $0x802ca4
  8000be:	e8 7e 01 00 00       	call   800241 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 c4 2c 80 00       	push   $0x802cc4
  8000cb:	e8 67 02 00 00       	call   800337 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 30 12 00 00       	call   801308 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 d8 2c 80 00 	movl   $0x802cd8,(%esp)
  8000df:	e8 53 02 00 00       	call   800337 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ec 2c 80 00       	push   $0x802cec
  8000f0:	68 f5 2c 80 00       	push   $0x802cf5
  8000f5:	68 ff 2c 80 00       	push   $0x802cff
  8000fa:	68 fe 2c 80 00       	push   $0x802cfe
  8000ff:	e8 12 1e 00 00       	call   801f16 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 1b 2d 80 00       	push   $0x802d1b
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
  800123:	68 04 2d 80 00       	push   $0x802d04
  800128:	6a 1a                	push   $0x1a
  80012a:	68 a4 2c 80 00       	push   $0x802ca4
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
  8001b7:	68 2b 2d 80 00       	push   $0x802d2b
  8001bc:	e8 76 01 00 00       	call   800337 <cprintf>
	cprintf("before umain\n");
  8001c1:	c7 04 24 49 2d 80 00 	movl   $0x802d49,(%esp)
  8001c8:	e8 6a 01 00 00       	call   800337 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001cd:	83 c4 08             	add    $0x8,%esp
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	ff 75 08             	pushl  0x8(%ebp)
  8001d6:	e8 58 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8001db:	c7 04 24 57 2d 80 00 	movl   $0x802d57,(%esp)
  8001e2:	e8 50 01 00 00       	call   800337 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e7:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ec:	8b 40 48             	mov    0x48(%eax),%eax
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	50                   	push   %eax
  8001f3:	68 64 2d 80 00       	push   $0x802d64
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
  80021b:	68 90 2d 80 00       	push   $0x802d90
  800220:	50                   	push   %eax
  800221:	68 83 2d 80 00       	push   $0x802d83
  800226:	e8 0c 01 00 00       	call   800337 <cprintf>
	close_all();
  80022b:	e8 05 11 00 00       	call   801335 <close_all>
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
  800251:	68 bc 2d 80 00       	push   $0x802dbc
  800256:	50                   	push   %eax
  800257:	68 83 2d 80 00       	push   $0x802d83
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
  80027a:	68 98 2d 80 00       	push   $0x802d98
  80027f:	e8 b3 00 00 00       	call   800337 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800284:	83 c4 18             	add    $0x18,%esp
  800287:	53                   	push   %ebx
  800288:	ff 75 10             	pushl  0x10(%ebp)
  80028b:	e8 56 00 00 00       	call   8002e6 <vcprintf>
	cprintf("\n");
  800290:	c7 04 24 47 2d 80 00 	movl   $0x802d47,(%esp)
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
  8003e4:	e8 27 26 00 00       	call   802a10 <__udivdi3>
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
  80040d:	e8 0e 27 00 00       	call   802b20 <__umoddi3>
  800412:	83 c4 14             	add    $0x14,%esp
  800415:	0f be 80 c3 2d 80 00 	movsbl 0x802dc3(%eax),%eax
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
  8004be:	ff 24 85 a0 2f 80 00 	jmp    *0x802fa0(,%eax,4)
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
  800589:	8b 14 85 00 31 80 00 	mov    0x803100(,%eax,4),%edx
  800590:	85 d2                	test   %edx,%edx
  800592:	74 18                	je     8005ac <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800594:	52                   	push   %edx
  800595:	68 1d 32 80 00       	push   $0x80321d
  80059a:	53                   	push   %ebx
  80059b:	56                   	push   %esi
  80059c:	e8 a6 fe ff ff       	call   800447 <printfmt>
  8005a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a7:	e9 fe 02 00 00       	jmp    8008aa <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005ac:	50                   	push   %eax
  8005ad:	68 db 2d 80 00       	push   $0x802ddb
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
  8005d4:	b8 d4 2d 80 00       	mov    $0x802dd4,%eax
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
  80096c:	bf f9 2e 80 00       	mov    $0x802ef9,%edi
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
  800998:	bf 31 2f 80 00       	mov    $0x802f31,%edi
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
  800e39:	68 48 31 80 00       	push   $0x803148
  800e3e:	6a 43                	push   $0x43
  800e40:	68 65 31 80 00       	push   $0x803165
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
  800eba:	68 48 31 80 00       	push   $0x803148
  800ebf:	6a 43                	push   $0x43
  800ec1:	68 65 31 80 00       	push   $0x803165
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
  800efc:	68 48 31 80 00       	push   $0x803148
  800f01:	6a 43                	push   $0x43
  800f03:	68 65 31 80 00       	push   $0x803165
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
  800f3e:	68 48 31 80 00       	push   $0x803148
  800f43:	6a 43                	push   $0x43
  800f45:	68 65 31 80 00       	push   $0x803165
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
  800f80:	68 48 31 80 00       	push   $0x803148
  800f85:	6a 43                	push   $0x43
  800f87:	68 65 31 80 00       	push   $0x803165
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
  800fc2:	68 48 31 80 00       	push   $0x803148
  800fc7:	6a 43                	push   $0x43
  800fc9:	68 65 31 80 00       	push   $0x803165
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
  801004:	68 48 31 80 00       	push   $0x803148
  801009:	6a 43                	push   $0x43
  80100b:	68 65 31 80 00       	push   $0x803165
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
  801068:	68 48 31 80 00       	push   $0x803148
  80106d:	6a 43                	push   $0x43
  80106f:	68 65 31 80 00       	push   $0x803165
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
  80114c:	68 48 31 80 00       	push   $0x803148
  801151:	6a 43                	push   $0x43
  801153:	68 65 31 80 00       	push   $0x803165
  801158:	e8 e4 f0 ff ff       	call   800241 <_panic>

0080115d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	05 00 00 00 30       	add    $0x30000000,%eax
  801168:	c1 e8 0c             	shr    $0xc,%eax
}
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80118c:	89 c2                	mov    %eax,%edx
  80118e:	c1 ea 16             	shr    $0x16,%edx
  801191:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801198:	f6 c2 01             	test   $0x1,%dl
  80119b:	74 2d                	je     8011ca <fd_alloc+0x46>
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	c1 ea 0c             	shr    $0xc,%edx
  8011a2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a9:	f6 c2 01             	test   $0x1,%dl
  8011ac:	74 1c                	je     8011ca <fd_alloc+0x46>
  8011ae:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011b3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b8:	75 d2                	jne    80118c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011c3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c8:	eb 0a                	jmp    8011d4 <fd_alloc+0x50>
			*fd_store = fd;
  8011ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d4:	5d                   	pop    %ebp
  8011d5:	c3                   	ret    

008011d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011dc:	83 f8 1f             	cmp    $0x1f,%eax
  8011df:	77 30                	ja     801211 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011e1:	c1 e0 0c             	shl    $0xc,%eax
  8011e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011ef:	f6 c2 01             	test   $0x1,%dl
  8011f2:	74 24                	je     801218 <fd_lookup+0x42>
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	c1 ea 0c             	shr    $0xc,%edx
  8011f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801200:	f6 c2 01             	test   $0x1,%dl
  801203:	74 1a                	je     80121f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801205:	8b 55 0c             	mov    0xc(%ebp),%edx
  801208:	89 02                	mov    %eax,(%edx)
	return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    
		return -E_INVAL;
  801211:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801216:	eb f7                	jmp    80120f <fd_lookup+0x39>
		return -E_INVAL;
  801218:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121d:	eb f0                	jmp    80120f <fd_lookup+0x39>
  80121f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801224:	eb e9                	jmp    80120f <fd_lookup+0x39>

00801226 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	83 ec 08             	sub    $0x8,%esp
  80122c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80122f:	ba 00 00 00 00       	mov    $0x0,%edx
  801234:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801239:	39 08                	cmp    %ecx,(%eax)
  80123b:	74 38                	je     801275 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80123d:	83 c2 01             	add    $0x1,%edx
  801240:	8b 04 95 f0 31 80 00 	mov    0x8031f0(,%edx,4),%eax
  801247:	85 c0                	test   %eax,%eax
  801249:	75 ee                	jne    801239 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80124b:	a1 08 50 80 00       	mov    0x805008,%eax
  801250:	8b 40 48             	mov    0x48(%eax),%eax
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	51                   	push   %ecx
  801257:	50                   	push   %eax
  801258:	68 74 31 80 00       	push   $0x803174
  80125d:	e8 d5 f0 ff ff       	call   800337 <cprintf>
	*dev = 0;
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    
			*dev = devtab[i];
  801275:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801278:	89 01                	mov    %eax,(%ecx)
			return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
  80127f:	eb f2                	jmp    801273 <dev_lookup+0x4d>

00801281 <fd_close>:
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 24             	sub    $0x24,%esp
  80128a:	8b 75 08             	mov    0x8(%ebp),%esi
  80128d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801290:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801293:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801294:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80129a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80129d:	50                   	push   %eax
  80129e:	e8 33 ff ff ff       	call   8011d6 <fd_lookup>
  8012a3:	89 c3                	mov    %eax,%ebx
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	78 05                	js     8012b1 <fd_close+0x30>
	    || fd != fd2)
  8012ac:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012af:	74 16                	je     8012c7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012b1:	89 f8                	mov    %edi,%eax
  8012b3:	84 c0                	test   %al,%al
  8012b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ba:	0f 44 d8             	cmove  %eax,%ebx
}
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 36                	pushl  (%esi)
  8012d0:	e8 51 ff ff ff       	call   801226 <dev_lookup>
  8012d5:	89 c3                	mov    %eax,%ebx
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 1a                	js     8012f8 <fd_close+0x77>
		if (dev->dev_close)
  8012de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	74 0b                	je     8012f8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	56                   	push   %esi
  8012f1:	ff d0                	call   *%eax
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f8:	83 ec 08             	sub    $0x8,%esp
  8012fb:	56                   	push   %esi
  8012fc:	6a 00                	push   $0x0
  8012fe:	e8 0a fc ff ff       	call   800f0d <sys_page_unmap>
	return r;
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	eb b5                	jmp    8012bd <fd_close+0x3c>

00801308 <close>:

int
close(int fdnum)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	ff 75 08             	pushl  0x8(%ebp)
  801315:	e8 bc fe ff ff       	call   8011d6 <fd_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	79 02                	jns    801323 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    
		return fd_close(fd, 1);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	6a 01                	push   $0x1
  801328:	ff 75 f4             	pushl  -0xc(%ebp)
  80132b:	e8 51 ff ff ff       	call   801281 <fd_close>
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	eb ec                	jmp    801321 <close+0x19>

00801335 <close_all>:

void
close_all(void)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80133c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	53                   	push   %ebx
  801345:	e8 be ff ff ff       	call   801308 <close>
	for (i = 0; i < MAXFD; i++)
  80134a:	83 c3 01             	add    $0x1,%ebx
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	83 fb 20             	cmp    $0x20,%ebx
  801353:	75 ec                	jne    801341 <close_all+0xc>
}
  801355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	57                   	push   %edi
  80135e:	56                   	push   %esi
  80135f:	53                   	push   %ebx
  801360:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801363:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801366:	50                   	push   %eax
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 67 fe ff ff       	call   8011d6 <fd_lookup>
  80136f:	89 c3                	mov    %eax,%ebx
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	85 c0                	test   %eax,%eax
  801376:	0f 88 81 00 00 00    	js     8013fd <dup+0xa3>
		return r;
	close(newfdnum);
  80137c:	83 ec 0c             	sub    $0xc,%esp
  80137f:	ff 75 0c             	pushl  0xc(%ebp)
  801382:	e8 81 ff ff ff       	call   801308 <close>

	newfd = INDEX2FD(newfdnum);
  801387:	8b 75 0c             	mov    0xc(%ebp),%esi
  80138a:	c1 e6 0c             	shl    $0xc,%esi
  80138d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801393:	83 c4 04             	add    $0x4,%esp
  801396:	ff 75 e4             	pushl  -0x1c(%ebp)
  801399:	e8 cf fd ff ff       	call   80116d <fd2data>
  80139e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013a0:	89 34 24             	mov    %esi,(%esp)
  8013a3:	e8 c5 fd ff ff       	call   80116d <fd2data>
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013ad:	89 d8                	mov    %ebx,%eax
  8013af:	c1 e8 16             	shr    $0x16,%eax
  8013b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b9:	a8 01                	test   $0x1,%al
  8013bb:	74 11                	je     8013ce <dup+0x74>
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	c1 e8 0c             	shr    $0xc,%eax
  8013c2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c9:	f6 c2 01             	test   $0x1,%dl
  8013cc:	75 39                	jne    801407 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013d1:	89 d0                	mov    %edx,%eax
  8013d3:	c1 e8 0c             	shr    $0xc,%eax
  8013d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e5:	50                   	push   %eax
  8013e6:	56                   	push   %esi
  8013e7:	6a 00                	push   $0x0
  8013e9:	52                   	push   %edx
  8013ea:	6a 00                	push   $0x0
  8013ec:	e8 da fa ff ff       	call   800ecb <sys_page_map>
  8013f1:	89 c3                	mov    %eax,%ebx
  8013f3:	83 c4 20             	add    $0x20,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 31                	js     80142b <dup+0xd1>
		goto err;

	return newfdnum;
  8013fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013fd:	89 d8                	mov    %ebx,%eax
  8013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801402:	5b                   	pop    %ebx
  801403:	5e                   	pop    %esi
  801404:	5f                   	pop    %edi
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801407:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	25 07 0e 00 00       	and    $0xe07,%eax
  801416:	50                   	push   %eax
  801417:	57                   	push   %edi
  801418:	6a 00                	push   $0x0
  80141a:	53                   	push   %ebx
  80141b:	6a 00                	push   $0x0
  80141d:	e8 a9 fa ff ff       	call   800ecb <sys_page_map>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 20             	add    $0x20,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	79 a3                	jns    8013ce <dup+0x74>
	sys_page_unmap(0, newfd);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	56                   	push   %esi
  80142f:	6a 00                	push   $0x0
  801431:	e8 d7 fa ff ff       	call   800f0d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801436:	83 c4 08             	add    $0x8,%esp
  801439:	57                   	push   %edi
  80143a:	6a 00                	push   $0x0
  80143c:	e8 cc fa ff ff       	call   800f0d <sys_page_unmap>
	return r;
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	eb b7                	jmp    8013fd <dup+0xa3>

00801446 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	53                   	push   %ebx
  80144a:	83 ec 1c             	sub    $0x1c,%esp
  80144d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801450:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801453:	50                   	push   %eax
  801454:	53                   	push   %ebx
  801455:	e8 7c fd ff ff       	call   8011d6 <fd_lookup>
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 3f                	js     8014a0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801461:	83 ec 08             	sub    $0x8,%esp
  801464:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146b:	ff 30                	pushl  (%eax)
  80146d:	e8 b4 fd ff ff       	call   801226 <dev_lookup>
  801472:	83 c4 10             	add    $0x10,%esp
  801475:	85 c0                	test   %eax,%eax
  801477:	78 27                	js     8014a0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147c:	8b 42 08             	mov    0x8(%edx),%eax
  80147f:	83 e0 03             	and    $0x3,%eax
  801482:	83 f8 01             	cmp    $0x1,%eax
  801485:	74 1e                	je     8014a5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	8b 40 08             	mov    0x8(%eax),%eax
  80148d:	85 c0                	test   %eax,%eax
  80148f:	74 35                	je     8014c6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	ff 75 10             	pushl  0x10(%ebp)
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	52                   	push   %edx
  80149b:	ff d0                	call   *%eax
  80149d:	83 c4 10             	add    $0x10,%esp
}
  8014a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a5:	a1 08 50 80 00       	mov    0x805008,%eax
  8014aa:	8b 40 48             	mov    0x48(%eax),%eax
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	53                   	push   %ebx
  8014b1:	50                   	push   %eax
  8014b2:	68 b5 31 80 00       	push   $0x8031b5
  8014b7:	e8 7b ee ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c4:	eb da                	jmp    8014a0 <read+0x5a>
		return -E_NOT_SUPP;
  8014c6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014cb:	eb d3                	jmp    8014a0 <read+0x5a>

008014cd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	57                   	push   %edi
  8014d1:	56                   	push   %esi
  8014d2:	53                   	push   %ebx
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e1:	39 f3                	cmp    %esi,%ebx
  8014e3:	73 23                	jae    801508 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	89 f0                	mov    %esi,%eax
  8014ea:	29 d8                	sub    %ebx,%eax
  8014ec:	50                   	push   %eax
  8014ed:	89 d8                	mov    %ebx,%eax
  8014ef:	03 45 0c             	add    0xc(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	57                   	push   %edi
  8014f4:	e8 4d ff ff ff       	call   801446 <read>
		if (m < 0)
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 06                	js     801506 <readn+0x39>
			return m;
		if (m == 0)
  801500:	74 06                	je     801508 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801502:	01 c3                	add    %eax,%ebx
  801504:	eb db                	jmp    8014e1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801506:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801508:	89 d8                	mov    %ebx,%eax
  80150a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150d:	5b                   	pop    %ebx
  80150e:	5e                   	pop    %esi
  80150f:	5f                   	pop    %edi
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	53                   	push   %ebx
  801516:	83 ec 1c             	sub    $0x1c,%esp
  801519:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151f:	50                   	push   %eax
  801520:	53                   	push   %ebx
  801521:	e8 b0 fc ff ff       	call   8011d6 <fd_lookup>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	85 c0                	test   %eax,%eax
  80152b:	78 3a                	js     801567 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801533:	50                   	push   %eax
  801534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801537:	ff 30                	pushl  (%eax)
  801539:	e8 e8 fc ff ff       	call   801226 <dev_lookup>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 22                	js     801567 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801548:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154c:	74 1e                	je     80156c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80154e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801551:	8b 52 0c             	mov    0xc(%edx),%edx
  801554:	85 d2                	test   %edx,%edx
  801556:	74 35                	je     80158d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	ff 75 10             	pushl  0x10(%ebp)
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	50                   	push   %eax
  801562:	ff d2                	call   *%edx
  801564:	83 c4 10             	add    $0x10,%esp
}
  801567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80156c:	a1 08 50 80 00       	mov    0x805008,%eax
  801571:	8b 40 48             	mov    0x48(%eax),%eax
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	53                   	push   %ebx
  801578:	50                   	push   %eax
  801579:	68 d1 31 80 00       	push   $0x8031d1
  80157e:	e8 b4 ed ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158b:	eb da                	jmp    801567 <write+0x55>
		return -E_NOT_SUPP;
  80158d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801592:	eb d3                	jmp    801567 <write+0x55>

00801594 <seek>:

int
seek(int fdnum, off_t offset)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159d:	50                   	push   %eax
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	e8 30 fc ff ff       	call   8011d6 <fd_lookup>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 0e                	js     8015bb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	53                   	push   %ebx
  8015c1:	83 ec 1c             	sub    $0x1c,%esp
  8015c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ca:	50                   	push   %eax
  8015cb:	53                   	push   %ebx
  8015cc:	e8 05 fc ff ff       	call   8011d6 <fd_lookup>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 37                	js     80160f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015de:	50                   	push   %eax
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	ff 30                	pushl  (%eax)
  8015e4:	e8 3d fc ff ff       	call   801226 <dev_lookup>
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 1f                	js     80160f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f7:	74 1b                	je     801614 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fc:	8b 52 18             	mov    0x18(%edx),%edx
  8015ff:	85 d2                	test   %edx,%edx
  801601:	74 32                	je     801635 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	50                   	push   %eax
  80160a:	ff d2                	call   *%edx
  80160c:	83 c4 10             	add    $0x10,%esp
}
  80160f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801612:	c9                   	leave  
  801613:	c3                   	ret    
			thisenv->env_id, fdnum);
  801614:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801619:	8b 40 48             	mov    0x48(%eax),%eax
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	53                   	push   %ebx
  801620:	50                   	push   %eax
  801621:	68 94 31 80 00       	push   $0x803194
  801626:	e8 0c ed ff ff       	call   800337 <cprintf>
		return -E_INVAL;
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801633:	eb da                	jmp    80160f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163a:	eb d3                	jmp    80160f <ftruncate+0x52>

0080163c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	53                   	push   %ebx
  801640:	83 ec 1c             	sub    $0x1c,%esp
  801643:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801646:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801649:	50                   	push   %eax
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	e8 84 fb ff ff       	call   8011d6 <fd_lookup>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 4b                	js     8016a4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165f:	50                   	push   %eax
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	ff 30                	pushl  (%eax)
  801665:	e8 bc fb ff ff       	call   801226 <dev_lookup>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	78 33                	js     8016a4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801678:	74 2f                	je     8016a9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80167a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801684:	00 00 00 
	stat->st_isdir = 0;
  801687:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168e:	00 00 00 
	stat->st_dev = dev;
  801691:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801697:	83 ec 08             	sub    $0x8,%esp
  80169a:	53                   	push   %ebx
  80169b:	ff 75 f0             	pushl  -0x10(%ebp)
  80169e:	ff 50 14             	call   *0x14(%eax)
  8016a1:	83 c4 10             	add    $0x10,%esp
}
  8016a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ae:	eb f4                	jmp    8016a4 <fstat+0x68>

008016b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	6a 00                	push   $0x0
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	e8 22 02 00 00       	call   8018e4 <open>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 1b                	js     8016e6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	50                   	push   %eax
  8016d2:	e8 65 ff ff ff       	call   80163c <fstat>
  8016d7:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d9:	89 1c 24             	mov    %ebx,(%esp)
  8016dc:	e8 27 fc ff ff       	call   801308 <close>
	return r;
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	89 f3                	mov    %esi,%ebx
}
  8016e6:	89 d8                	mov    %ebx,%eax
  8016e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016eb:	5b                   	pop    %ebx
  8016ec:	5e                   	pop    %esi
  8016ed:	5d                   	pop    %ebp
  8016ee:	c3                   	ret    

008016ef <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	89 c6                	mov    %eax,%esi
  8016f6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8016ff:	74 27                	je     801728 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801701:	6a 07                	push   $0x7
  801703:	68 00 60 80 00       	push   $0x806000
  801708:	56                   	push   %esi
  801709:	ff 35 00 50 80 00    	pushl  0x805000
  80170f:	e8 24 12 00 00       	call   802938 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801714:	83 c4 0c             	add    $0xc,%esp
  801717:	6a 00                	push   $0x0
  801719:	53                   	push   %ebx
  80171a:	6a 00                	push   $0x0
  80171c:	e8 ae 11 00 00       	call   8028cf <ipc_recv>
}
  801721:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5d                   	pop    %ebp
  801727:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	6a 01                	push   $0x1
  80172d:	e8 5e 12 00 00       	call   802990 <ipc_find_env>
  801732:	a3 00 50 80 00       	mov    %eax,0x805000
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	eb c5                	jmp    801701 <fsipc+0x12>

0080173c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 40 0c             	mov    0xc(%eax),%eax
  801748:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80174d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801750:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	b8 02 00 00 00       	mov    $0x2,%eax
  80175f:	e8 8b ff ff ff       	call   8016ef <fsipc>
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <devfile_flush>:
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8b 40 0c             	mov    0xc(%eax),%eax
  801772:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 06 00 00 00       	mov    $0x6,%eax
  801781:	e8 69 ff ff ff       	call   8016ef <fsipc>
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <devfile_stat>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	53                   	push   %ebx
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8b 40 0c             	mov    0xc(%eax),%eax
  801798:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80179d:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a7:	e8 43 ff ff ff       	call   8016ef <fsipc>
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 2c                	js     8017dc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017b0:	83 ec 08             	sub    $0x8,%esp
  8017b3:	68 00 60 80 00       	push   $0x806000
  8017b8:	53                   	push   %ebx
  8017b9:	e8 d8 f2 ff ff       	call   800a96 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017be:	a1 80 60 80 00       	mov    0x806080,%eax
  8017c3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c9:	a1 84 60 80 00       	mov    0x806084,%eax
  8017ce:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <devfile_write>:
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 08             	sub    $0x8,%esp
  8017e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  8017f6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017fc:	53                   	push   %ebx
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	68 08 60 80 00       	push   $0x806008
  801805:	e8 7c f4 ff ff       	call   800c86 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	b8 04 00 00 00       	mov    $0x4,%eax
  801814:	e8 d6 fe ff ff       	call   8016ef <fsipc>
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 0b                	js     80182b <devfile_write+0x4a>
	assert(r <= n);
  801820:	39 d8                	cmp    %ebx,%eax
  801822:	77 0c                	ja     801830 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801824:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801829:	7f 1e                	jg     801849 <devfile_write+0x68>
}
  80182b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    
	assert(r <= n);
  801830:	68 04 32 80 00       	push   $0x803204
  801835:	68 0b 32 80 00       	push   $0x80320b
  80183a:	68 98 00 00 00       	push   $0x98
  80183f:	68 20 32 80 00       	push   $0x803220
  801844:	e8 f8 e9 ff ff       	call   800241 <_panic>
	assert(r <= PGSIZE);
  801849:	68 2b 32 80 00       	push   $0x80322b
  80184e:	68 0b 32 80 00       	push   $0x80320b
  801853:	68 99 00 00 00       	push   $0x99
  801858:	68 20 32 80 00       	push   $0x803220
  80185d:	e8 df e9 ff ff       	call   800241 <_panic>

00801862 <devfile_read>:
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	56                   	push   %esi
  801866:	53                   	push   %ebx
  801867:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	8b 40 0c             	mov    0xc(%eax),%eax
  801870:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801875:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	b8 03 00 00 00       	mov    $0x3,%eax
  801885:	e8 65 fe ff ff       	call   8016ef <fsipc>
  80188a:	89 c3                	mov    %eax,%ebx
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 1f                	js     8018af <devfile_read+0x4d>
	assert(r <= n);
  801890:	39 f0                	cmp    %esi,%eax
  801892:	77 24                	ja     8018b8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801894:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801899:	7f 33                	jg     8018ce <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	50                   	push   %eax
  80189f:	68 00 60 80 00       	push   $0x806000
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	e8 78 f3 ff ff       	call   800c24 <memmove>
	return r;
  8018ac:	83 c4 10             	add    $0x10,%esp
}
  8018af:	89 d8                	mov    %ebx,%eax
  8018b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    
	assert(r <= n);
  8018b8:	68 04 32 80 00       	push   $0x803204
  8018bd:	68 0b 32 80 00       	push   $0x80320b
  8018c2:	6a 7c                	push   $0x7c
  8018c4:	68 20 32 80 00       	push   $0x803220
  8018c9:	e8 73 e9 ff ff       	call   800241 <_panic>
	assert(r <= PGSIZE);
  8018ce:	68 2b 32 80 00       	push   $0x80322b
  8018d3:	68 0b 32 80 00       	push   $0x80320b
  8018d8:	6a 7d                	push   $0x7d
  8018da:	68 20 32 80 00       	push   $0x803220
  8018df:	e8 5d e9 ff ff       	call   800241 <_panic>

008018e4 <open>:
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 1c             	sub    $0x1c,%esp
  8018ec:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018ef:	56                   	push   %esi
  8018f0:	e8 68 f1 ff ff       	call   800a5d <strlen>
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018fd:	7f 6c                	jg     80196b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801905:	50                   	push   %eax
  801906:	e8 79 f8 ff ff       	call   801184 <fd_alloc>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 3c                	js     801950 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	56                   	push   %esi
  801918:	68 00 60 80 00       	push   $0x806000
  80191d:	e8 74 f1 ff ff       	call   800a96 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80192a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192d:	b8 01 00 00 00       	mov    $0x1,%eax
  801932:	e8 b8 fd ff ff       	call   8016ef <fsipc>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 19                	js     801959 <open+0x75>
	return fd2num(fd);
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	ff 75 f4             	pushl  -0xc(%ebp)
  801946:	e8 12 f8 ff ff       	call   80115d <fd2num>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	83 c4 10             	add    $0x10,%esp
}
  801950:	89 d8                	mov    %ebx,%eax
  801952:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    
		fd_close(fd, 0);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 f4             	pushl  -0xc(%ebp)
  801961:	e8 1b f9 ff ff       	call   801281 <fd_close>
		return r;
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	eb e5                	jmp    801950 <open+0x6c>
		return -E_BAD_PATH;
  80196b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801970:	eb de                	jmp    801950 <open+0x6c>

00801972 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801978:	ba 00 00 00 00       	mov    $0x0,%edx
  80197d:	b8 08 00 00 00       	mov    $0x8,%eax
  801982:	e8 68 fd ff ff       	call   8016ef <fsipc>
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	57                   	push   %edi
  80198d:	56                   	push   %esi
  80198e:	53                   	push   %ebx
  80198f:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  801995:	68 10 33 80 00       	push   $0x803310
  80199a:	68 87 2d 80 00       	push   $0x802d87
  80199f:	e8 93 e9 ff ff       	call   800337 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019a4:	83 c4 08             	add    $0x8,%esp
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	e8 33 ff ff ff       	call   8018e4 <open>
  8019b1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	0f 88 0a 05 00 00    	js     801ecc <spawn+0x543>
  8019c2:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	68 00 02 00 00       	push   $0x200
  8019cc:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019d2:	50                   	push   %eax
  8019d3:	51                   	push   %ecx
  8019d4:	e8 f4 fa ff ff       	call   8014cd <readn>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019e1:	75 74                	jne    801a57 <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  8019e3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8019ea:	45 4c 46 
  8019ed:	75 68                	jne    801a57 <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019ef:	b8 07 00 00 00       	mov    $0x7,%eax
  8019f4:	cd 30                	int    $0x30
  8019f6:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8019fc:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a02:	85 c0                	test   %eax,%eax
  801a04:	0f 88 b6 04 00 00    	js     801ec0 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a0a:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a0f:	89 c6                	mov    %eax,%esi
  801a11:	c1 e6 07             	shl    $0x7,%esi
  801a14:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a1a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a20:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a27:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a2d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	68 04 33 80 00       	push   $0x803304
  801a3b:	68 87 2d 80 00       	push   $0x802d87
  801a40:	e8 f2 e8 ff ff       	call   800337 <cprintf>
  801a45:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a48:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a4d:	be 00 00 00 00       	mov    $0x0,%esi
  801a52:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a55:	eb 4b                	jmp    801aa2 <spawn+0x119>
		close(fd);
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a60:	e8 a3 f8 ff ff       	call   801308 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a65:	83 c4 0c             	add    $0xc,%esp
  801a68:	68 7f 45 4c 46       	push   $0x464c457f
  801a6d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a73:	68 37 32 80 00       	push   $0x803237
  801a78:	e8 ba e8 ff ff       	call   800337 <cprintf>
		return -E_NOT_EXEC;
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801a87:	ff ff ff 
  801a8a:	e9 3d 04 00 00       	jmp    801ecc <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  801a8f:	83 ec 0c             	sub    $0xc,%esp
  801a92:	50                   	push   %eax
  801a93:	e8 c5 ef ff ff       	call   800a5d <strlen>
  801a98:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a9c:	83 c3 01             	add    $0x1,%ebx
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801aa9:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	75 df                	jne    801a8f <spawn+0x106>
  801ab0:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ab6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801abc:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ac1:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ac3:	89 fa                	mov    %edi,%edx
  801ac5:	83 e2 fc             	and    $0xfffffffc,%edx
  801ac8:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801acf:	29 c2                	sub    %eax,%edx
  801ad1:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ad7:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ada:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801adf:	0f 86 0a 04 00 00    	jbe    801eef <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	6a 07                	push   $0x7
  801aea:	68 00 00 40 00       	push   $0x400000
  801aef:	6a 00                	push   $0x0
  801af1:	e8 92 f3 ff ff       	call   800e88 <sys_page_alloc>
  801af6:	83 c4 10             	add    $0x10,%esp
  801af9:	85 c0                	test   %eax,%eax
  801afb:	0f 88 f3 03 00 00    	js     801ef4 <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b01:	be 00 00 00 00       	mov    $0x0,%esi
  801b06:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b0f:	eb 30                	jmp    801b41 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b11:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b17:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b1d:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b20:	83 ec 08             	sub    $0x8,%esp
  801b23:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b26:	57                   	push   %edi
  801b27:	e8 6a ef ff ff       	call   800a96 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b2c:	83 c4 04             	add    $0x4,%esp
  801b2f:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b32:	e8 26 ef ff ff       	call   800a5d <strlen>
  801b37:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b3b:	83 c6 01             	add    $0x1,%esi
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b47:	7f c8                	jg     801b11 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801b49:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b4f:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b55:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b5c:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b62:	0f 85 86 00 00 00    	jne    801bee <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b68:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801b6e:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801b74:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801b7f:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b82:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b87:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b8d:	83 ec 0c             	sub    $0xc,%esp
  801b90:	6a 07                	push   $0x7
  801b92:	68 00 d0 bf ee       	push   $0xeebfd000
  801b97:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b9d:	68 00 00 40 00       	push   $0x400000
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 22 f3 ff ff       	call   800ecb <sys_page_map>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 20             	add    $0x20,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	0f 88 46 03 00 00    	js     801efc <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bb6:	83 ec 08             	sub    $0x8,%esp
  801bb9:	68 00 00 40 00       	push   $0x400000
  801bbe:	6a 00                	push   $0x0
  801bc0:	e8 48 f3 ff ff       	call   800f0d <sys_page_unmap>
  801bc5:	89 c3                	mov    %eax,%ebx
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	0f 88 2a 03 00 00    	js     801efc <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bd2:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bd8:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801bdf:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801be6:	00 00 00 
  801be9:	e9 4f 01 00 00       	jmp    801d3d <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801bee:	68 c0 32 80 00       	push   $0x8032c0
  801bf3:	68 0b 32 80 00       	push   $0x80320b
  801bf8:	68 f8 00 00 00       	push   $0xf8
  801bfd:	68 51 32 80 00       	push   $0x803251
  801c02:	e8 3a e6 ff ff       	call   800241 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	6a 07                	push   $0x7
  801c0c:	68 00 00 40 00       	push   $0x400000
  801c11:	6a 00                	push   $0x0
  801c13:	e8 70 f2 ff ff       	call   800e88 <sys_page_alloc>
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	0f 88 b7 02 00 00    	js     801eda <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c2c:	01 f0                	add    %esi,%eax
  801c2e:	50                   	push   %eax
  801c2f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c35:	e8 5a f9 ff ff       	call   801594 <seek>
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	85 c0                	test   %eax,%eax
  801c3f:	0f 88 9c 02 00 00    	js     801ee1 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c4e:	29 f0                	sub    %esi,%eax
  801c50:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c55:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c5a:	0f 47 c1             	cmova  %ecx,%eax
  801c5d:	50                   	push   %eax
  801c5e:	68 00 00 40 00       	push   $0x400000
  801c63:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c69:	e8 5f f8 ff ff       	call   8014cd <readn>
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	0f 88 6f 02 00 00    	js     801ee8 <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c79:	83 ec 0c             	sub    $0xc,%esp
  801c7c:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c82:	53                   	push   %ebx
  801c83:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c89:	68 00 00 40 00       	push   $0x400000
  801c8e:	6a 00                	push   $0x0
  801c90:	e8 36 f2 ff ff       	call   800ecb <sys_page_map>
  801c95:	83 c4 20             	add    $0x20,%esp
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 7c                	js     801d18 <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	68 00 00 40 00       	push   $0x400000
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 62 f2 ff ff       	call   800f0d <sys_page_unmap>
  801cab:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cae:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cb4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cba:	89 fe                	mov    %edi,%esi
  801cbc:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801cc2:	76 69                	jbe    801d2d <spawn+0x3a4>
		if (i >= filesz) {
  801cc4:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801cca:	0f 87 37 ff ff ff    	ja     801c07 <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cd9:	53                   	push   %ebx
  801cda:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801ce0:	e8 a3 f1 ff ff       	call   800e88 <sys_page_alloc>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	79 c2                	jns    801cae <spawn+0x325>
  801cec:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cee:	83 ec 0c             	sub    $0xc,%esp
  801cf1:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cf7:	e8 0d f1 ff ff       	call   800e09 <sys_env_destroy>
	close(fd);
  801cfc:	83 c4 04             	add    $0x4,%esp
  801cff:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d05:	e8 fe f5 ff ff       	call   801308 <close>
	return r;
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d13:	e9 b4 01 00 00       	jmp    801ecc <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801d18:	50                   	push   %eax
  801d19:	68 5d 32 80 00       	push   $0x80325d
  801d1e:	68 2b 01 00 00       	push   $0x12b
  801d23:	68 51 32 80 00       	push   $0x803251
  801d28:	e8 14 e5 ff ff       	call   800241 <_panic>
  801d2d:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d33:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d3a:	83 c6 20             	add    $0x20,%esi
  801d3d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d44:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d4a:	7e 6d                	jle    801db9 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801d4c:	83 3e 01             	cmpl   $0x1,(%esi)
  801d4f:	75 e2                	jne    801d33 <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d51:	8b 46 18             	mov    0x18(%esi),%eax
  801d54:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d57:	83 f8 01             	cmp    $0x1,%eax
  801d5a:	19 c0                	sbb    %eax,%eax
  801d5c:	83 e0 fe             	and    $0xfffffffe,%eax
  801d5f:	83 c0 07             	add    $0x7,%eax
  801d62:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d68:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d6b:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d71:	8b 56 10             	mov    0x10(%esi),%edx
  801d74:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d7a:	8b 7e 14             	mov    0x14(%esi),%edi
  801d7d:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801d83:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801d86:	89 d8                	mov    %ebx,%eax
  801d88:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d8d:	74 1a                	je     801da9 <spawn+0x420>
		va -= i;
  801d8f:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801d91:	01 c7                	add    %eax,%edi
  801d93:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d99:	01 c2                	add    %eax,%edx
  801d9b:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801da1:	29 c1                	sub    %eax,%ecx
  801da3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801da9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dae:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801db4:	e9 01 ff ff ff       	jmp    801cba <spawn+0x331>
	close(fd);
  801db9:	83 ec 0c             	sub    $0xc,%esp
  801dbc:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dc2:	e8 41 f5 ff ff       	call   801308 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	68 f0 32 80 00       	push   $0x8032f0
  801dcf:	68 87 2d 80 00       	push   $0x802d87
  801dd4:	e8 5e e5 ff ff       	call   800337 <cprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801ddc:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801de1:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801de7:	eb 0e                	jmp    801df7 <spawn+0x46e>
  801de9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801def:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801df5:	74 5e                	je     801e55 <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801df7:	89 d8                	mov    %ebx,%eax
  801df9:	c1 e8 16             	shr    $0x16,%eax
  801dfc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e03:	a8 01                	test   $0x1,%al
  801e05:	74 e2                	je     801de9 <spawn+0x460>
  801e07:	89 da                	mov    %ebx,%edx
  801e09:	c1 ea 0c             	shr    $0xc,%edx
  801e0c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e13:	25 05 04 00 00       	and    $0x405,%eax
  801e18:	3d 05 04 00 00       	cmp    $0x405,%eax
  801e1d:	75 ca                	jne    801de9 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801e1f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	25 07 0e 00 00       	and    $0xe07,%eax
  801e2e:	50                   	push   %eax
  801e2f:	53                   	push   %ebx
  801e30:	56                   	push   %esi
  801e31:	53                   	push   %ebx
  801e32:	6a 00                	push   $0x0
  801e34:	e8 92 f0 ff ff       	call   800ecb <sys_page_map>
  801e39:	83 c4 20             	add    $0x20,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	79 a9                	jns    801de9 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801e40:	50                   	push   %eax
  801e41:	68 7a 32 80 00       	push   $0x80327a
  801e46:	68 3b 01 00 00       	push   $0x13b
  801e4b:	68 51 32 80 00       	push   $0x803251
  801e50:	e8 ec e3 ff ff       	call   800241 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e55:	83 ec 08             	sub    $0x8,%esp
  801e58:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e5e:	50                   	push   %eax
  801e5f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e65:	e8 27 f1 ff ff       	call   800f91 <sys_env_set_trapframe>
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	78 25                	js     801e96 <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e71:	83 ec 08             	sub    $0x8,%esp
  801e74:	6a 02                	push   $0x2
  801e76:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e7c:	e8 ce f0 ff ff       	call   800f4f <sys_env_set_status>
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	85 c0                	test   %eax,%eax
  801e86:	78 23                	js     801eab <spawn+0x522>
	return child;
  801e88:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e8e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e94:	eb 36                	jmp    801ecc <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801e96:	50                   	push   %eax
  801e97:	68 8c 32 80 00       	push   $0x80328c
  801e9c:	68 8a 00 00 00       	push   $0x8a
  801ea1:	68 51 32 80 00       	push   $0x803251
  801ea6:	e8 96 e3 ff ff       	call   800241 <_panic>
		panic("sys_env_set_status: %e", r);
  801eab:	50                   	push   %eax
  801eac:	68 a6 32 80 00       	push   $0x8032a6
  801eb1:	68 8d 00 00 00       	push   $0x8d
  801eb6:	68 51 32 80 00       	push   $0x803251
  801ebb:	e8 81 e3 ff ff       	call   800241 <_panic>
		return r;
  801ec0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ec6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801ecc:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5f                   	pop    %edi
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    
  801eda:	89 c7                	mov    %eax,%edi
  801edc:	e9 0d fe ff ff       	jmp    801cee <spawn+0x365>
  801ee1:	89 c7                	mov    %eax,%edi
  801ee3:	e9 06 fe ff ff       	jmp    801cee <spawn+0x365>
  801ee8:	89 c7                	mov    %eax,%edi
  801eea:	e9 ff fd ff ff       	jmp    801cee <spawn+0x365>
		return -E_NO_MEM;
  801eef:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801ef4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801efa:	eb d0                	jmp    801ecc <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801efc:	83 ec 08             	sub    $0x8,%esp
  801eff:	68 00 00 40 00       	push   $0x400000
  801f04:	6a 00                	push   $0x0
  801f06:	e8 02 f0 ff ff       	call   800f0d <sys_page_unmap>
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f14:	eb b6                	jmp    801ecc <spawn+0x543>

00801f16 <spawnl>:
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	57                   	push   %edi
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
  801f1c:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801f1f:	68 e8 32 80 00       	push   $0x8032e8
  801f24:	68 87 2d 80 00       	push   $0x802d87
  801f29:	e8 09 e4 ff ff       	call   800337 <cprintf>
	va_start(vl, arg0);
  801f2e:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801f31:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f39:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f3c:	83 3a 00             	cmpl   $0x0,(%edx)
  801f3f:	74 07                	je     801f48 <spawnl+0x32>
		argc++;
  801f41:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f44:	89 ca                	mov    %ecx,%edx
  801f46:	eb f1                	jmp    801f39 <spawnl+0x23>
	const char *argv[argc+2];
  801f48:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f4f:	83 e2 f0             	and    $0xfffffff0,%edx
  801f52:	29 d4                	sub    %edx,%esp
  801f54:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f58:	c1 ea 02             	shr    $0x2,%edx
  801f5b:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f62:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f67:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f6e:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f75:	00 
	va_start(vl, arg0);
  801f76:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f79:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	eb 0b                	jmp    801f8d <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801f82:	83 c0 01             	add    $0x1,%eax
  801f85:	8b 39                	mov    (%ecx),%edi
  801f87:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f8a:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f8d:	39 d0                	cmp    %edx,%eax
  801f8f:	75 f1                	jne    801f82 <spawnl+0x6c>
	return spawn(prog, argv);
  801f91:	83 ec 08             	sub    $0x8,%esp
  801f94:	56                   	push   %esi
  801f95:	ff 75 08             	pushl  0x8(%ebp)
  801f98:	e8 ec f9 ff ff       	call   801989 <spawn>
}
  801f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa0:	5b                   	pop    %ebx
  801fa1:	5e                   	pop    %esi
  801fa2:	5f                   	pop    %edi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    

00801fa5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fab:	68 16 33 80 00       	push   $0x803316
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	e8 de ea ff ff       	call   800a96 <strcpy>
	return 0;
}
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <devsock_close>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	53                   	push   %ebx
  801fc3:	83 ec 10             	sub    $0x10,%esp
  801fc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fc9:	53                   	push   %ebx
  801fca:	e8 fc 09 00 00       	call   8029cb <pageref>
  801fcf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fd2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fd7:	83 f8 01             	cmp    $0x1,%eax
  801fda:	74 07                	je     801fe3 <devsock_close+0x24>
}
  801fdc:	89 d0                	mov    %edx,%eax
  801fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	ff 73 0c             	pushl  0xc(%ebx)
  801fe9:	e8 b9 02 00 00       	call   8022a7 <nsipc_close>
  801fee:	89 c2                	mov    %eax,%edx
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	eb e7                	jmp    801fdc <devsock_close+0x1d>

00801ff5 <devsock_write>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	ff 75 10             	pushl  0x10(%ebp)
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	ff 70 0c             	pushl  0xc(%eax)
  802009:	e8 76 03 00 00       	call   802384 <nsipc_send>
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <devsock_read>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802016:	6a 00                	push   $0x0
  802018:	ff 75 10             	pushl  0x10(%ebp)
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	ff 70 0c             	pushl  0xc(%eax)
  802024:	e8 ef 02 00 00       	call   802318 <nsipc_recv>
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <fd2sockid>:
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802031:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	e8 9b f1 ff ff       	call   8011d6 <fd_lookup>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	85 c0                	test   %eax,%eax
  802040:	78 10                	js     802052 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80204b:	39 08                	cmp    %ecx,(%eax)
  80204d:	75 05                	jne    802054 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80204f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    
		return -E_NOT_SUPP;
  802054:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802059:	eb f7                	jmp    802052 <fd2sockid+0x27>

0080205b <alloc_sockfd>:
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	83 ec 1c             	sub    $0x1c,%esp
  802063:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802065:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 16 f1 ff ff       	call   801184 <fd_alloc>
  80206e:	89 c3                	mov    %eax,%ebx
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	85 c0                	test   %eax,%eax
  802075:	78 43                	js     8020ba <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	68 07 04 00 00       	push   $0x407
  80207f:	ff 75 f4             	pushl  -0xc(%ebp)
  802082:	6a 00                	push   $0x0
  802084:	e8 ff ed ff ff       	call   800e88 <sys_page_alloc>
  802089:	89 c3                	mov    %eax,%ebx
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 28                	js     8020ba <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 15 20 40 80 00    	mov    0x804020,%edx
  80209b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020a7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	50                   	push   %eax
  8020ae:	e8 aa f0 ff ff       	call   80115d <fd2num>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	eb 0c                	jmp    8020c6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	56                   	push   %esi
  8020be:	e8 e4 01 00 00       	call   8022a7 <nsipc_close>
		return r;
  8020c3:	83 c4 10             	add    $0x10,%esp
}
  8020c6:	89 d8                	mov    %ebx,%eax
  8020c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <accept>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	e8 4e ff ff ff       	call   80202b <fd2sockid>
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	78 1b                	js     8020fc <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	ff 75 10             	pushl  0x10(%ebp)
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	50                   	push   %eax
  8020eb:	e8 0e 01 00 00       	call   8021fe <nsipc_accept>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 05                	js     8020fc <accept+0x2d>
	return alloc_sockfd(r);
  8020f7:	e8 5f ff ff ff       	call   80205b <alloc_sockfd>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <bind>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	e8 1f ff ff ff       	call   80202b <fd2sockid>
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 12                	js     802122 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	ff 75 10             	pushl  0x10(%ebp)
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	50                   	push   %eax
  80211a:	e8 31 01 00 00       	call   802250 <nsipc_bind>
  80211f:	83 c4 10             	add    $0x10,%esp
}
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <shutdown>:
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	e8 f9 fe ff ff       	call   80202b <fd2sockid>
  802132:	85 c0                	test   %eax,%eax
  802134:	78 0f                	js     802145 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802136:	83 ec 08             	sub    $0x8,%esp
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	50                   	push   %eax
  80213d:	e8 43 01 00 00       	call   802285 <nsipc_shutdown>
  802142:	83 c4 10             	add    $0x10,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <connect>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	e8 d6 fe ff ff       	call   80202b <fd2sockid>
  802155:	85 c0                	test   %eax,%eax
  802157:	78 12                	js     80216b <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802159:	83 ec 04             	sub    $0x4,%esp
  80215c:	ff 75 10             	pushl  0x10(%ebp)
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	50                   	push   %eax
  802163:	e8 59 01 00 00       	call   8022c1 <nsipc_connect>
  802168:	83 c4 10             	add    $0x10,%esp
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <listen>:
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	e8 b0 fe ff ff       	call   80202b <fd2sockid>
  80217b:	85 c0                	test   %eax,%eax
  80217d:	78 0f                	js     80218e <listen+0x21>
	return nsipc_listen(r, backlog);
  80217f:	83 ec 08             	sub    $0x8,%esp
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	50                   	push   %eax
  802186:	e8 6b 01 00 00       	call   8022f6 <nsipc_listen>
  80218b:	83 c4 10             	add    $0x10,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <socket>:

int
socket(int domain, int type, int protocol)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802196:	ff 75 10             	pushl  0x10(%ebp)
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	e8 3e 02 00 00       	call   8023e2 <nsipc_socket>
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 05                	js     8021b0 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021ab:	e8 ab fe ff ff       	call   80205b <alloc_sockfd>
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	53                   	push   %ebx
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021bb:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021c2:	74 26                	je     8021ea <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021c4:	6a 07                	push   $0x7
  8021c6:	68 00 70 80 00       	push   $0x807000
  8021cb:	53                   	push   %ebx
  8021cc:	ff 35 04 50 80 00    	pushl  0x805004
  8021d2:	e8 61 07 00 00       	call   802938 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d7:	83 c4 0c             	add    $0xc,%esp
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	e8 ea 06 00 00       	call   8028cf <ipc_recv>
}
  8021e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	6a 02                	push   $0x2
  8021ef:	e8 9c 07 00 00       	call   802990 <ipc_find_env>
  8021f4:	a3 04 50 80 00       	mov    %eax,0x805004
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	eb c6                	jmp    8021c4 <nsipc+0x12>

008021fe <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	56                   	push   %esi
  802202:	53                   	push   %ebx
  802203:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80220e:	8b 06                	mov    (%esi),%eax
  802210:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802215:	b8 01 00 00 00       	mov    $0x1,%eax
  80221a:	e8 93 ff ff ff       	call   8021b2 <nsipc>
  80221f:	89 c3                	mov    %eax,%ebx
  802221:	85 c0                	test   %eax,%eax
  802223:	79 09                	jns    80222e <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802225:	89 d8                	mov    %ebx,%eax
  802227:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222a:	5b                   	pop    %ebx
  80222b:	5e                   	pop    %esi
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	ff 35 10 70 80 00    	pushl  0x807010
  802237:	68 00 70 80 00       	push   $0x807000
  80223c:	ff 75 0c             	pushl  0xc(%ebp)
  80223f:	e8 e0 e9 ff ff       	call   800c24 <memmove>
		*addrlen = ret->ret_addrlen;
  802244:	a1 10 70 80 00       	mov    0x807010,%eax
  802249:	89 06                	mov    %eax,(%esi)
  80224b:	83 c4 10             	add    $0x10,%esp
	return r;
  80224e:	eb d5                	jmp    802225 <nsipc_accept+0x27>

00802250 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	53                   	push   %ebx
  802254:	83 ec 08             	sub    $0x8,%esp
  802257:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802262:	53                   	push   %ebx
  802263:	ff 75 0c             	pushl  0xc(%ebp)
  802266:	68 04 70 80 00       	push   $0x807004
  80226b:	e8 b4 e9 ff ff       	call   800c24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802270:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802276:	b8 02 00 00 00       	mov    $0x2,%eax
  80227b:	e8 32 ff ff ff       	call   8021b2 <nsipc>
}
  802280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802293:	8b 45 0c             	mov    0xc(%ebp),%eax
  802296:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80229b:	b8 03 00 00 00       	mov    $0x3,%eax
  8022a0:	e8 0d ff ff ff       	call   8021b2 <nsipc>
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <nsipc_close>:

int
nsipc_close(int s)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022b5:	b8 04 00 00 00       	mov    $0x4,%eax
  8022ba:	e8 f3 fe ff ff       	call   8021b2 <nsipc>
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 08             	sub    $0x8,%esp
  8022c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022d3:	53                   	push   %ebx
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	68 04 70 80 00       	push   $0x807004
  8022dc:	e8 43 e9 ff ff       	call   800c24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022e1:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ec:	e8 c1 fe ff ff       	call   8021b2 <nsipc>
}
  8022f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80230c:	b8 06 00 00 00       	mov    $0x6,%eax
  802311:	e8 9c fe ff ff       	call   8021b2 <nsipc>
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
  80231d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802328:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80232e:	8b 45 14             	mov    0x14(%ebp),%eax
  802331:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802336:	b8 07 00 00 00       	mov    $0x7,%eax
  80233b:	e8 72 fe ff ff       	call   8021b2 <nsipc>
  802340:	89 c3                	mov    %eax,%ebx
  802342:	85 c0                	test   %eax,%eax
  802344:	78 1f                	js     802365 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802346:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80234b:	7f 21                	jg     80236e <nsipc_recv+0x56>
  80234d:	39 c6                	cmp    %eax,%esi
  80234f:	7c 1d                	jl     80236e <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	50                   	push   %eax
  802355:	68 00 70 80 00       	push   $0x807000
  80235a:	ff 75 0c             	pushl  0xc(%ebp)
  80235d:	e8 c2 e8 ff ff       	call   800c24 <memmove>
  802362:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802365:	89 d8                	mov    %ebx,%eax
  802367:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236a:	5b                   	pop    %ebx
  80236b:	5e                   	pop    %esi
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80236e:	68 22 33 80 00       	push   $0x803322
  802373:	68 0b 32 80 00       	push   $0x80320b
  802378:	6a 62                	push   $0x62
  80237a:	68 37 33 80 00       	push   $0x803337
  80237f:	e8 bd de ff ff       	call   800241 <_panic>

00802384 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	53                   	push   %ebx
  802388:	83 ec 04             	sub    $0x4,%esp
  80238b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802396:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80239c:	7f 2e                	jg     8023cc <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	53                   	push   %ebx
  8023a2:	ff 75 0c             	pushl  0xc(%ebp)
  8023a5:	68 0c 70 80 00       	push   $0x80700c
  8023aa:	e8 75 e8 ff ff       	call   800c24 <memmove>
	nsipcbuf.send.req_size = size;
  8023af:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b8:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8023c2:	e8 eb fd ff ff       	call   8021b2 <nsipc>
}
  8023c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    
	assert(size < 1600);
  8023cc:	68 43 33 80 00       	push   $0x803343
  8023d1:	68 0b 32 80 00       	push   $0x80320b
  8023d6:	6a 6d                	push   $0x6d
  8023d8:	68 37 33 80 00       	push   $0x803337
  8023dd:	e8 5f de ff ff       	call   800241 <_panic>

008023e2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f3:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fb:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802400:	b8 09 00 00 00       	mov    $0x9,%eax
  802405:	e8 a8 fd ff ff       	call   8021b2 <nsipc>
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	56                   	push   %esi
  802410:	53                   	push   %ebx
  802411:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802414:	83 ec 0c             	sub    $0xc,%esp
  802417:	ff 75 08             	pushl  0x8(%ebp)
  80241a:	e8 4e ed ff ff       	call   80116d <fd2data>
  80241f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802421:	83 c4 08             	add    $0x8,%esp
  802424:	68 4f 33 80 00       	push   $0x80334f
  802429:	53                   	push   %ebx
  80242a:	e8 67 e6 ff ff       	call   800a96 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80242f:	8b 46 04             	mov    0x4(%esi),%eax
  802432:	2b 06                	sub    (%esi),%eax
  802434:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80243a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802441:	00 00 00 
	stat->st_dev = &devpipe;
  802444:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80244b:	40 80 00 
	return 0;
}
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802456:	5b                   	pop    %ebx
  802457:	5e                   	pop    %esi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	53                   	push   %ebx
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802464:	53                   	push   %ebx
  802465:	6a 00                	push   $0x0
  802467:	e8 a1 ea ff ff       	call   800f0d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80246c:	89 1c 24             	mov    %ebx,(%esp)
  80246f:	e8 f9 ec ff ff       	call   80116d <fd2data>
  802474:	83 c4 08             	add    $0x8,%esp
  802477:	50                   	push   %eax
  802478:	6a 00                	push   $0x0
  80247a:	e8 8e ea ff ff       	call   800f0d <sys_page_unmap>
}
  80247f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <_pipeisclosed>:
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	57                   	push   %edi
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
  80248a:	83 ec 1c             	sub    $0x1c,%esp
  80248d:	89 c7                	mov    %eax,%edi
  80248f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802491:	a1 08 50 80 00       	mov    0x805008,%eax
  802496:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802499:	83 ec 0c             	sub    $0xc,%esp
  80249c:	57                   	push   %edi
  80249d:	e8 29 05 00 00       	call   8029cb <pageref>
  8024a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024a5:	89 34 24             	mov    %esi,(%esp)
  8024a8:	e8 1e 05 00 00       	call   8029cb <pageref>
		nn = thisenv->env_runs;
  8024ad:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024b3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024b6:	83 c4 10             	add    $0x10,%esp
  8024b9:	39 cb                	cmp    %ecx,%ebx
  8024bb:	74 1b                	je     8024d8 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024bd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024c0:	75 cf                	jne    802491 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024c2:	8b 42 58             	mov    0x58(%edx),%eax
  8024c5:	6a 01                	push   $0x1
  8024c7:	50                   	push   %eax
  8024c8:	53                   	push   %ebx
  8024c9:	68 56 33 80 00       	push   $0x803356
  8024ce:	e8 64 de ff ff       	call   800337 <cprintf>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	eb b9                	jmp    802491 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024d8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024db:	0f 94 c0             	sete   %al
  8024de:	0f b6 c0             	movzbl %al,%eax
}
  8024e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024e4:	5b                   	pop    %ebx
  8024e5:	5e                   	pop    %esi
  8024e6:	5f                   	pop    %edi
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <devpipe_write>:
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	57                   	push   %edi
  8024ed:	56                   	push   %esi
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 28             	sub    $0x28,%esp
  8024f2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024f5:	56                   	push   %esi
  8024f6:	e8 72 ec ff ff       	call   80116d <fd2data>
  8024fb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024fd:	83 c4 10             	add    $0x10,%esp
  802500:	bf 00 00 00 00       	mov    $0x0,%edi
  802505:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802508:	74 4f                	je     802559 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250a:	8b 43 04             	mov    0x4(%ebx),%eax
  80250d:	8b 0b                	mov    (%ebx),%ecx
  80250f:	8d 51 20             	lea    0x20(%ecx),%edx
  802512:	39 d0                	cmp    %edx,%eax
  802514:	72 14                	jb     80252a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802516:	89 da                	mov    %ebx,%edx
  802518:	89 f0                	mov    %esi,%eax
  80251a:	e8 65 ff ff ff       	call   802484 <_pipeisclosed>
  80251f:	85 c0                	test   %eax,%eax
  802521:	75 3b                	jne    80255e <devpipe_write+0x75>
			sys_yield();
  802523:	e8 41 e9 ff ff       	call   800e69 <sys_yield>
  802528:	eb e0                	jmp    80250a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80252a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802531:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802534:	89 c2                	mov    %eax,%edx
  802536:	c1 fa 1f             	sar    $0x1f,%edx
  802539:	89 d1                	mov    %edx,%ecx
  80253b:	c1 e9 1b             	shr    $0x1b,%ecx
  80253e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802541:	83 e2 1f             	and    $0x1f,%edx
  802544:	29 ca                	sub    %ecx,%edx
  802546:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80254a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80254e:	83 c0 01             	add    $0x1,%eax
  802551:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802554:	83 c7 01             	add    $0x1,%edi
  802557:	eb ac                	jmp    802505 <devpipe_write+0x1c>
	return i;
  802559:	8b 45 10             	mov    0x10(%ebp),%eax
  80255c:	eb 05                	jmp    802563 <devpipe_write+0x7a>
				return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802563:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802566:	5b                   	pop    %ebx
  802567:	5e                   	pop    %esi
  802568:	5f                   	pop    %edi
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    

0080256b <devpipe_read>:
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	57                   	push   %edi
  80256f:	56                   	push   %esi
  802570:	53                   	push   %ebx
  802571:	83 ec 18             	sub    $0x18,%esp
  802574:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802577:	57                   	push   %edi
  802578:	e8 f0 eb ff ff       	call   80116d <fd2data>
  80257d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	be 00 00 00 00       	mov    $0x0,%esi
  802587:	3b 75 10             	cmp    0x10(%ebp),%esi
  80258a:	75 14                	jne    8025a0 <devpipe_read+0x35>
	return i;
  80258c:	8b 45 10             	mov    0x10(%ebp),%eax
  80258f:	eb 02                	jmp    802593 <devpipe_read+0x28>
				return i;
  802591:	89 f0                	mov    %esi,%eax
}
  802593:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802596:	5b                   	pop    %ebx
  802597:	5e                   	pop    %esi
  802598:	5f                   	pop    %edi
  802599:	5d                   	pop    %ebp
  80259a:	c3                   	ret    
			sys_yield();
  80259b:	e8 c9 e8 ff ff       	call   800e69 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025a0:	8b 03                	mov    (%ebx),%eax
  8025a2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a5:	75 18                	jne    8025bf <devpipe_read+0x54>
			if (i > 0)
  8025a7:	85 f6                	test   %esi,%esi
  8025a9:	75 e6                	jne    802591 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025ab:	89 da                	mov    %ebx,%edx
  8025ad:	89 f8                	mov    %edi,%eax
  8025af:	e8 d0 fe ff ff       	call   802484 <_pipeisclosed>
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 e3                	je     80259b <devpipe_read+0x30>
				return 0;
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bd:	eb d4                	jmp    802593 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025bf:	99                   	cltd   
  8025c0:	c1 ea 1b             	shr    $0x1b,%edx
  8025c3:	01 d0                	add    %edx,%eax
  8025c5:	83 e0 1f             	and    $0x1f,%eax
  8025c8:	29 d0                	sub    %edx,%eax
  8025ca:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025d2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025d5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025d8:	83 c6 01             	add    $0x1,%esi
  8025db:	eb aa                	jmp    802587 <devpipe_read+0x1c>

008025dd <pipe>:
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
  8025e0:	56                   	push   %esi
  8025e1:	53                   	push   %ebx
  8025e2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e8:	50                   	push   %eax
  8025e9:	e8 96 eb ff ff       	call   801184 <fd_alloc>
  8025ee:	89 c3                	mov    %eax,%ebx
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 88 23 01 00 00    	js     80271e <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 07 04 00 00       	push   $0x407
  802603:	ff 75 f4             	pushl  -0xc(%ebp)
  802606:	6a 00                	push   $0x0
  802608:	e8 7b e8 ff ff       	call   800e88 <sys_page_alloc>
  80260d:	89 c3                	mov    %eax,%ebx
  80260f:	83 c4 10             	add    $0x10,%esp
  802612:	85 c0                	test   %eax,%eax
  802614:	0f 88 04 01 00 00    	js     80271e <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802620:	50                   	push   %eax
  802621:	e8 5e eb ff ff       	call   801184 <fd_alloc>
  802626:	89 c3                	mov    %eax,%ebx
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	85 c0                	test   %eax,%eax
  80262d:	0f 88 db 00 00 00    	js     80270e <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 07 04 00 00       	push   $0x407
  80263b:	ff 75 f0             	pushl  -0x10(%ebp)
  80263e:	6a 00                	push   $0x0
  802640:	e8 43 e8 ff ff       	call   800e88 <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	85 c0                	test   %eax,%eax
  80264c:	0f 88 bc 00 00 00    	js     80270e <pipe+0x131>
	va = fd2data(fd0);
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	ff 75 f4             	pushl  -0xc(%ebp)
  802658:	e8 10 eb ff ff       	call   80116d <fd2data>
  80265d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265f:	83 c4 0c             	add    $0xc,%esp
  802662:	68 07 04 00 00       	push   $0x407
  802667:	50                   	push   %eax
  802668:	6a 00                	push   $0x0
  80266a:	e8 19 e8 ff ff       	call   800e88 <sys_page_alloc>
  80266f:	89 c3                	mov    %eax,%ebx
  802671:	83 c4 10             	add    $0x10,%esp
  802674:	85 c0                	test   %eax,%eax
  802676:	0f 88 82 00 00 00    	js     8026fe <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267c:	83 ec 0c             	sub    $0xc,%esp
  80267f:	ff 75 f0             	pushl  -0x10(%ebp)
  802682:	e8 e6 ea ff ff       	call   80116d <fd2data>
  802687:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80268e:	50                   	push   %eax
  80268f:	6a 00                	push   $0x0
  802691:	56                   	push   %esi
  802692:	6a 00                	push   $0x0
  802694:	e8 32 e8 ff ff       	call   800ecb <sys_page_map>
  802699:	89 c3                	mov    %eax,%ebx
  80269b:	83 c4 20             	add    $0x20,%esp
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	78 4e                	js     8026f0 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026a2:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026af:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026c5:	83 ec 0c             	sub    $0xc,%esp
  8026c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8026cb:	e8 8d ea ff ff       	call   80115d <fd2num>
  8026d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026d3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026d5:	83 c4 04             	add    $0x4,%esp
  8026d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8026db:	e8 7d ea ff ff       	call   80115d <fd2num>
  8026e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026e6:	83 c4 10             	add    $0x10,%esp
  8026e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026ee:	eb 2e                	jmp    80271e <pipe+0x141>
	sys_page_unmap(0, va);
  8026f0:	83 ec 08             	sub    $0x8,%esp
  8026f3:	56                   	push   %esi
  8026f4:	6a 00                	push   $0x0
  8026f6:	e8 12 e8 ff ff       	call   800f0d <sys_page_unmap>
  8026fb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026fe:	83 ec 08             	sub    $0x8,%esp
  802701:	ff 75 f0             	pushl  -0x10(%ebp)
  802704:	6a 00                	push   $0x0
  802706:	e8 02 e8 ff ff       	call   800f0d <sys_page_unmap>
  80270b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80270e:	83 ec 08             	sub    $0x8,%esp
  802711:	ff 75 f4             	pushl  -0xc(%ebp)
  802714:	6a 00                	push   $0x0
  802716:	e8 f2 e7 ff ff       	call   800f0d <sys_page_unmap>
  80271b:	83 c4 10             	add    $0x10,%esp
}
  80271e:	89 d8                	mov    %ebx,%eax
  802720:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802723:	5b                   	pop    %ebx
  802724:	5e                   	pop    %esi
  802725:	5d                   	pop    %ebp
  802726:	c3                   	ret    

00802727 <pipeisclosed>:
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802730:	50                   	push   %eax
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	e8 9d ea ff ff       	call   8011d6 <fd_lookup>
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	85 c0                	test   %eax,%eax
  80273e:	78 18                	js     802758 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	ff 75 f4             	pushl  -0xc(%ebp)
  802746:	e8 22 ea ff ff       	call   80116d <fd2data>
	return _pipeisclosed(fd, p);
  80274b:	89 c2                	mov    %eax,%edx
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	e8 2f fd ff ff       	call   802484 <_pipeisclosed>
  802755:	83 c4 10             	add    $0x10,%esp
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	c3                   	ret    

00802760 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802766:	68 6e 33 80 00       	push   $0x80336e
  80276b:	ff 75 0c             	pushl  0xc(%ebp)
  80276e:	e8 23 e3 ff ff       	call   800a96 <strcpy>
	return 0;
}
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <devcons_write>:
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	57                   	push   %edi
  80277e:	56                   	push   %esi
  80277f:	53                   	push   %ebx
  802780:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802786:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80278b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802791:	3b 75 10             	cmp    0x10(%ebp),%esi
  802794:	73 31                	jae    8027c7 <devcons_write+0x4d>
		m = n - tot;
  802796:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802799:	29 f3                	sub    %esi,%ebx
  80279b:	83 fb 7f             	cmp    $0x7f,%ebx
  80279e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027a3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027a6:	83 ec 04             	sub    $0x4,%esp
  8027a9:	53                   	push   %ebx
  8027aa:	89 f0                	mov    %esi,%eax
  8027ac:	03 45 0c             	add    0xc(%ebp),%eax
  8027af:	50                   	push   %eax
  8027b0:	57                   	push   %edi
  8027b1:	e8 6e e4 ff ff       	call   800c24 <memmove>
		sys_cputs(buf, m);
  8027b6:	83 c4 08             	add    $0x8,%esp
  8027b9:	53                   	push   %ebx
  8027ba:	57                   	push   %edi
  8027bb:	e8 0c e6 ff ff       	call   800dcc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027c0:	01 de                	add    %ebx,%esi
  8027c2:	83 c4 10             	add    $0x10,%esp
  8027c5:	eb ca                	jmp    802791 <devcons_write+0x17>
}
  8027c7:	89 f0                	mov    %esi,%eax
  8027c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027cc:	5b                   	pop    %ebx
  8027cd:	5e                   	pop    %esi
  8027ce:	5f                   	pop    %edi
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    

008027d1 <devcons_read>:
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 08             	sub    $0x8,%esp
  8027d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e0:	74 21                	je     802803 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8027e2:	e8 03 e6 ff ff       	call   800dea <sys_cgetc>
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	75 07                	jne    8027f2 <devcons_read+0x21>
		sys_yield();
  8027eb:	e8 79 e6 ff ff       	call   800e69 <sys_yield>
  8027f0:	eb f0                	jmp    8027e2 <devcons_read+0x11>
	if (c < 0)
  8027f2:	78 0f                	js     802803 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8027f4:	83 f8 04             	cmp    $0x4,%eax
  8027f7:	74 0c                	je     802805 <devcons_read+0x34>
	*(char*)vbuf = c;
  8027f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fc:	88 02                	mov    %al,(%edx)
	return 1;
  8027fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802803:	c9                   	leave  
  802804:	c3                   	ret    
		return 0;
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	eb f7                	jmp    802803 <devcons_read+0x32>

0080280c <cputchar>:
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
  80280f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802818:	6a 01                	push   $0x1
  80281a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80281d:	50                   	push   %eax
  80281e:	e8 a9 e5 ff ff       	call   800dcc <sys_cputs>
}
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <getchar>:
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80282e:	6a 01                	push   $0x1
  802830:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802833:	50                   	push   %eax
  802834:	6a 00                	push   $0x0
  802836:	e8 0b ec ff ff       	call   801446 <read>
	if (r < 0)
  80283b:	83 c4 10             	add    $0x10,%esp
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 06                	js     802848 <getchar+0x20>
	if (r < 1)
  802842:	74 06                	je     80284a <getchar+0x22>
	return c;
  802844:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    
		return -E_EOF;
  80284a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80284f:	eb f7                	jmp    802848 <getchar+0x20>

00802851 <iscons>:
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802857:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285a:	50                   	push   %eax
  80285b:	ff 75 08             	pushl  0x8(%ebp)
  80285e:	e8 73 e9 ff ff       	call   8011d6 <fd_lookup>
  802863:	83 c4 10             	add    $0x10,%esp
  802866:	85 c0                	test   %eax,%eax
  802868:	78 11                	js     80287b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802873:	39 10                	cmp    %edx,(%eax)
  802875:	0f 94 c0             	sete   %al
  802878:	0f b6 c0             	movzbl %al,%eax
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <opencons>:
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802883:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802886:	50                   	push   %eax
  802887:	e8 f8 e8 ff ff       	call   801184 <fd_alloc>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 3a                	js     8028cd <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 07 04 00 00       	push   $0x407
  80289b:	ff 75 f4             	pushl  -0xc(%ebp)
  80289e:	6a 00                	push   $0x0
  8028a0:	e8 e3 e5 ff ff       	call   800e88 <sys_page_alloc>
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	78 21                	js     8028cd <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028b5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028c1:	83 ec 0c             	sub    $0xc,%esp
  8028c4:	50                   	push   %eax
  8028c5:	e8 93 e8 ff ff       	call   80115d <fd2num>
  8028ca:	83 c4 10             	add    $0x10,%esp
}
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
  8028d2:	56                   	push   %esi
  8028d3:	53                   	push   %ebx
  8028d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8028d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8028dd:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028df:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028e4:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	50                   	push   %eax
  8028eb:	e8 48 e7 ff ff       	call   801038 <sys_ipc_recv>
	if(ret < 0){
  8028f0:	83 c4 10             	add    $0x10,%esp
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	78 2b                	js     802922 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028f7:	85 f6                	test   %esi,%esi
  8028f9:	74 0a                	je     802905 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8028fb:	a1 08 50 80 00       	mov    0x805008,%eax
  802900:	8b 40 74             	mov    0x74(%eax),%eax
  802903:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802905:	85 db                	test   %ebx,%ebx
  802907:	74 0a                	je     802913 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802909:	a1 08 50 80 00       	mov    0x805008,%eax
  80290e:	8b 40 78             	mov    0x78(%eax),%eax
  802911:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802913:	a1 08 50 80 00       	mov    0x805008,%eax
  802918:	8b 40 70             	mov    0x70(%eax),%eax
}
  80291b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80291e:	5b                   	pop    %ebx
  80291f:	5e                   	pop    %esi
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    
		if(from_env_store)
  802922:	85 f6                	test   %esi,%esi
  802924:	74 06                	je     80292c <ipc_recv+0x5d>
			*from_env_store = 0;
  802926:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80292c:	85 db                	test   %ebx,%ebx
  80292e:	74 eb                	je     80291b <ipc_recv+0x4c>
			*perm_store = 0;
  802930:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802936:	eb e3                	jmp    80291b <ipc_recv+0x4c>

00802938 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	57                   	push   %edi
  80293c:	56                   	push   %esi
  80293d:	53                   	push   %ebx
  80293e:	83 ec 0c             	sub    $0xc,%esp
  802941:	8b 7d 08             	mov    0x8(%ebp),%edi
  802944:	8b 75 0c             	mov    0xc(%ebp),%esi
  802947:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80294a:	85 db                	test   %ebx,%ebx
  80294c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802951:	0f 44 d8             	cmove  %eax,%ebx
  802954:	eb 05                	jmp    80295b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802956:	e8 0e e5 ff ff       	call   800e69 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80295b:	ff 75 14             	pushl  0x14(%ebp)
  80295e:	53                   	push   %ebx
  80295f:	56                   	push   %esi
  802960:	57                   	push   %edi
  802961:	e8 af e6 ff ff       	call   801015 <sys_ipc_try_send>
  802966:	83 c4 10             	add    $0x10,%esp
  802969:	85 c0                	test   %eax,%eax
  80296b:	74 1b                	je     802988 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80296d:	79 e7                	jns    802956 <ipc_send+0x1e>
  80296f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802972:	74 e2                	je     802956 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	68 7a 33 80 00       	push   $0x80337a
  80297c:	6a 4a                	push   $0x4a
  80297e:	68 8f 33 80 00       	push   $0x80338f
  802983:	e8 b9 d8 ff ff       	call   800241 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802988:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80298b:	5b                   	pop    %ebx
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    

00802990 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802996:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80299b:	89 c2                	mov    %eax,%edx
  80299d:	c1 e2 07             	shl    $0x7,%edx
  8029a0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029a6:	8b 52 50             	mov    0x50(%edx),%edx
  8029a9:	39 ca                	cmp    %ecx,%edx
  8029ab:	74 11                	je     8029be <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8029ad:	83 c0 01             	add    $0x1,%eax
  8029b0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029b5:	75 e4                	jne    80299b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	eb 0b                	jmp    8029c9 <ipc_find_env+0x39>
			return envs[i].env_id;
  8029be:	c1 e0 07             	shl    $0x7,%eax
  8029c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029c6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029c9:	5d                   	pop    %ebp
  8029ca:	c3                   	ret    

008029cb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029d1:	89 d0                	mov    %edx,%eax
  8029d3:	c1 e8 16             	shr    $0x16,%eax
  8029d6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029dd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029e2:	f6 c1 01             	test   $0x1,%cl
  8029e5:	74 1d                	je     802a04 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029e7:	c1 ea 0c             	shr    $0xc,%edx
  8029ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029f1:	f6 c2 01             	test   $0x1,%dl
  8029f4:	74 0e                	je     802a04 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029f6:	c1 ea 0c             	shr    $0xc,%edx
  8029f9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a00:	ef 
  802a01:	0f b7 c0             	movzwl %ax,%eax
}
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	66 90                	xchg   %ax,%ax
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802a1b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802a1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a23:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802a27:	85 d2                	test   %edx,%edx
  802a29:	75 4d                	jne    802a78 <__udivdi3+0x68>
  802a2b:	39 f3                	cmp    %esi,%ebx
  802a2d:	76 19                	jbe    802a48 <__udivdi3+0x38>
  802a2f:	31 ff                	xor    %edi,%edi
  802a31:	89 e8                	mov    %ebp,%eax
  802a33:	89 f2                	mov    %esi,%edx
  802a35:	f7 f3                	div    %ebx
  802a37:	89 fa                	mov    %edi,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	89 d9                	mov    %ebx,%ecx
  802a4a:	85 db                	test   %ebx,%ebx
  802a4c:	75 0b                	jne    802a59 <__udivdi3+0x49>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	31 d2                	xor    %edx,%edx
  802a55:	f7 f3                	div    %ebx
  802a57:	89 c1                	mov    %eax,%ecx
  802a59:	31 d2                	xor    %edx,%edx
  802a5b:	89 f0                	mov    %esi,%eax
  802a5d:	f7 f1                	div    %ecx
  802a5f:	89 c6                	mov    %eax,%esi
  802a61:	89 e8                	mov    %ebp,%eax
  802a63:	89 f7                	mov    %esi,%edi
  802a65:	f7 f1                	div    %ecx
  802a67:	89 fa                	mov    %edi,%edx
  802a69:	83 c4 1c             	add    $0x1c,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	39 f2                	cmp    %esi,%edx
  802a7a:	77 1c                	ja     802a98 <__udivdi3+0x88>
  802a7c:	0f bd fa             	bsr    %edx,%edi
  802a7f:	83 f7 1f             	xor    $0x1f,%edi
  802a82:	75 2c                	jne    802ab0 <__udivdi3+0xa0>
  802a84:	39 f2                	cmp    %esi,%edx
  802a86:	72 06                	jb     802a8e <__udivdi3+0x7e>
  802a88:	31 c0                	xor    %eax,%eax
  802a8a:	39 eb                	cmp    %ebp,%ebx
  802a8c:	77 a9                	ja     802a37 <__udivdi3+0x27>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	eb a2                	jmp    802a37 <__udivdi3+0x27>
  802a95:	8d 76 00             	lea    0x0(%esi),%esi
  802a98:	31 ff                	xor    %edi,%edi
  802a9a:	31 c0                	xor    %eax,%eax
  802a9c:	89 fa                	mov    %edi,%edx
  802a9e:	83 c4 1c             	add    $0x1c,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    
  802aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aad:	8d 76 00             	lea    0x0(%esi),%esi
  802ab0:	89 f9                	mov    %edi,%ecx
  802ab2:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab7:	29 f8                	sub    %edi,%eax
  802ab9:	d3 e2                	shl    %cl,%edx
  802abb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802abf:	89 c1                	mov    %eax,%ecx
  802ac1:	89 da                	mov    %ebx,%edx
  802ac3:	d3 ea                	shr    %cl,%edx
  802ac5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ac9:	09 d1                	or     %edx,%ecx
  802acb:	89 f2                	mov    %esi,%edx
  802acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad1:	89 f9                	mov    %edi,%ecx
  802ad3:	d3 e3                	shl    %cl,%ebx
  802ad5:	89 c1                	mov    %eax,%ecx
  802ad7:	d3 ea                	shr    %cl,%edx
  802ad9:	89 f9                	mov    %edi,%ecx
  802adb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802adf:	89 eb                	mov    %ebp,%ebx
  802ae1:	d3 e6                	shl    %cl,%esi
  802ae3:	89 c1                	mov    %eax,%ecx
  802ae5:	d3 eb                	shr    %cl,%ebx
  802ae7:	09 de                	or     %ebx,%esi
  802ae9:	89 f0                	mov    %esi,%eax
  802aeb:	f7 74 24 08          	divl   0x8(%esp)
  802aef:	89 d6                	mov    %edx,%esi
  802af1:	89 c3                	mov    %eax,%ebx
  802af3:	f7 64 24 0c          	mull   0xc(%esp)
  802af7:	39 d6                	cmp    %edx,%esi
  802af9:	72 15                	jb     802b10 <__udivdi3+0x100>
  802afb:	89 f9                	mov    %edi,%ecx
  802afd:	d3 e5                	shl    %cl,%ebp
  802aff:	39 c5                	cmp    %eax,%ebp
  802b01:	73 04                	jae    802b07 <__udivdi3+0xf7>
  802b03:	39 d6                	cmp    %edx,%esi
  802b05:	74 09                	je     802b10 <__udivdi3+0x100>
  802b07:	89 d8                	mov    %ebx,%eax
  802b09:	31 ff                	xor    %edi,%edi
  802b0b:	e9 27 ff ff ff       	jmp    802a37 <__udivdi3+0x27>
  802b10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b13:	31 ff                	xor    %edi,%edi
  802b15:	e9 1d ff ff ff       	jmp    802a37 <__udivdi3+0x27>
  802b1a:	66 90                	xchg   %ax,%ax
  802b1c:	66 90                	xchg   %ax,%ax
  802b1e:	66 90                	xchg   %ax,%ax

00802b20 <__umoddi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	53                   	push   %ebx
  802b24:	83 ec 1c             	sub    $0x1c,%esp
  802b27:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802b2b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b2f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802b33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b37:	89 da                	mov    %ebx,%edx
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	75 43                	jne    802b80 <__umoddi3+0x60>
  802b3d:	39 df                	cmp    %ebx,%edi
  802b3f:	76 17                	jbe    802b58 <__umoddi3+0x38>
  802b41:	89 f0                	mov    %esi,%eax
  802b43:	f7 f7                	div    %edi
  802b45:	89 d0                	mov    %edx,%eax
  802b47:	31 d2                	xor    %edx,%edx
  802b49:	83 c4 1c             	add    $0x1c,%esp
  802b4c:	5b                   	pop    %ebx
  802b4d:	5e                   	pop    %esi
  802b4e:	5f                   	pop    %edi
  802b4f:	5d                   	pop    %ebp
  802b50:	c3                   	ret    
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	89 fd                	mov    %edi,%ebp
  802b5a:	85 ff                	test   %edi,%edi
  802b5c:	75 0b                	jne    802b69 <__umoddi3+0x49>
  802b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b63:	31 d2                	xor    %edx,%edx
  802b65:	f7 f7                	div    %edi
  802b67:	89 c5                	mov    %eax,%ebp
  802b69:	89 d8                	mov    %ebx,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f5                	div    %ebp
  802b6f:	89 f0                	mov    %esi,%eax
  802b71:	f7 f5                	div    %ebp
  802b73:	89 d0                	mov    %edx,%eax
  802b75:	eb d0                	jmp    802b47 <__umoddi3+0x27>
  802b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	89 f1                	mov    %esi,%ecx
  802b82:	39 d8                	cmp    %ebx,%eax
  802b84:	76 0a                	jbe    802b90 <__umoddi3+0x70>
  802b86:	89 f0                	mov    %esi,%eax
  802b88:	83 c4 1c             	add    $0x1c,%esp
  802b8b:	5b                   	pop    %ebx
  802b8c:	5e                   	pop    %esi
  802b8d:	5f                   	pop    %edi
  802b8e:	5d                   	pop    %ebp
  802b8f:	c3                   	ret    
  802b90:	0f bd e8             	bsr    %eax,%ebp
  802b93:	83 f5 1f             	xor    $0x1f,%ebp
  802b96:	75 20                	jne    802bb8 <__umoddi3+0x98>
  802b98:	39 d8                	cmp    %ebx,%eax
  802b9a:	0f 82 b0 00 00 00    	jb     802c50 <__umoddi3+0x130>
  802ba0:	39 f7                	cmp    %esi,%edi
  802ba2:	0f 86 a8 00 00 00    	jbe    802c50 <__umoddi3+0x130>
  802ba8:	89 c8                	mov    %ecx,%eax
  802baa:	83 c4 1c             	add    $0x1c,%esp
  802bad:	5b                   	pop    %ebx
  802bae:	5e                   	pop    %esi
  802baf:	5f                   	pop    %edi
  802bb0:	5d                   	pop    %ebp
  802bb1:	c3                   	ret    
  802bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb8:	89 e9                	mov    %ebp,%ecx
  802bba:	ba 20 00 00 00       	mov    $0x20,%edx
  802bbf:	29 ea                	sub    %ebp,%edx
  802bc1:	d3 e0                	shl    %cl,%eax
  802bc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bc7:	89 d1                	mov    %edx,%ecx
  802bc9:	89 f8                	mov    %edi,%eax
  802bcb:	d3 e8                	shr    %cl,%eax
  802bcd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bd5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bd9:	09 c1                	or     %eax,%ecx
  802bdb:	89 d8                	mov    %ebx,%eax
  802bdd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be1:	89 e9                	mov    %ebp,%ecx
  802be3:	d3 e7                	shl    %cl,%edi
  802be5:	89 d1                	mov    %edx,%ecx
  802be7:	d3 e8                	shr    %cl,%eax
  802be9:	89 e9                	mov    %ebp,%ecx
  802beb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bef:	d3 e3                	shl    %cl,%ebx
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	89 d1                	mov    %edx,%ecx
  802bf5:	89 f0                	mov    %esi,%eax
  802bf7:	d3 e8                	shr    %cl,%eax
  802bf9:	89 e9                	mov    %ebp,%ecx
  802bfb:	89 fa                	mov    %edi,%edx
  802bfd:	d3 e6                	shl    %cl,%esi
  802bff:	09 d8                	or     %ebx,%eax
  802c01:	f7 74 24 08          	divl   0x8(%esp)
  802c05:	89 d1                	mov    %edx,%ecx
  802c07:	89 f3                	mov    %esi,%ebx
  802c09:	f7 64 24 0c          	mull   0xc(%esp)
  802c0d:	89 c6                	mov    %eax,%esi
  802c0f:	89 d7                	mov    %edx,%edi
  802c11:	39 d1                	cmp    %edx,%ecx
  802c13:	72 06                	jb     802c1b <__umoddi3+0xfb>
  802c15:	75 10                	jne    802c27 <__umoddi3+0x107>
  802c17:	39 c3                	cmp    %eax,%ebx
  802c19:	73 0c                	jae    802c27 <__umoddi3+0x107>
  802c1b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802c1f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802c23:	89 d7                	mov    %edx,%edi
  802c25:	89 c6                	mov    %eax,%esi
  802c27:	89 ca                	mov    %ecx,%edx
  802c29:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c2e:	29 f3                	sub    %esi,%ebx
  802c30:	19 fa                	sbb    %edi,%edx
  802c32:	89 d0                	mov    %edx,%eax
  802c34:	d3 e0                	shl    %cl,%eax
  802c36:	89 e9                	mov    %ebp,%ecx
  802c38:	d3 eb                	shr    %cl,%ebx
  802c3a:	d3 ea                	shr    %cl,%edx
  802c3c:	09 d8                	or     %ebx,%eax
  802c3e:	83 c4 1c             	add    $0x1c,%esp
  802c41:	5b                   	pop    %ebx
  802c42:	5e                   	pop    %esi
  802c43:	5f                   	pop    %edi
  802c44:	5d                   	pop    %ebp
  802c45:	c3                   	ret    
  802c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c4d:	8d 76 00             	lea    0x0(%esi),%esi
  802c50:	89 da                	mov    %ebx,%edx
  802c52:	29 fe                	sub    %edi,%esi
  802c54:	19 c2                	sbb    %eax,%edx
  802c56:	89 f1                	mov    %esi,%ecx
  802c58:	89 c8                	mov    %ecx,%eax
  802c5a:	e9 4b ff ff ff       	jmp    802baa <__umoddi3+0x8a>
