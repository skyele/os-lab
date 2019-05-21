
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 50 01 00 00       	call   800181 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 43                	jmp    800086 <num+0x53>
		if (bol) {
			printf("%5d ", ++line);
  800043:	a1 00 40 80 00       	mov    0x804000,%eax
  800048:	83 c0 01             	add    $0x1,%eax
  80004b:	a3 00 40 80 00       	mov    %eax,0x804000
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	50                   	push   %eax
  800054:	68 c0 21 80 00       	push   $0x8021c0
  800059:	e8 01 19 00 00       	call   80195f <printf>
			bol = 0;
  80005e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800065:	00 00 00 
  800068:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	6a 01                	push   $0x1
  800070:	53                   	push   %ebx
  800071:	6a 01                	push   $0x1
  800073:	e8 d9 13 00 00       	call   801451 <write>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 f8 01             	cmp    $0x1,%eax
  80007e:	75 24                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800080:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800084:	74 36                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	53                   	push   %ebx
  80008c:	56                   	push   %esi
  80008d:	e8 f3 12 00 00       	call   801385 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7e 2f                	jle    8000c8 <num+0x95>
		if (bol) {
  800099:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a0:	74 c9                	je     80006b <num+0x38>
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 c5 21 80 00       	push   $0x8021c5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 e0 21 80 00       	push   $0x8021e0
  8000b7:	e8 6c 01 00 00       	call   800228 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb be                	jmp    800086 <num+0x53>
	}
	if (n < 0)
  8000c8:	78 07                	js     8000d1 <num+0x9e>
		panic("error reading %s: %e", s, n);
}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 75 0c             	pushl  0xc(%ebp)
  8000d8:	68 eb 21 80 00       	push   $0x8021eb
  8000dd:	6a 18                	push   $0x18
  8000df:	68 e0 21 80 00       	push   $0x8021e0
  8000e4:	e8 3f 01 00 00       	call   800228 <_panic>

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f2:	c7 05 04 30 80 00 00 	movl   $0x802200,0x803004
  8000f9:	22 80 00 
	if (argc == 1)
  8000fc:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800100:	74 46                	je     800148 <umain+0x5f>
  800102:	8b 45 0c             	mov    0xc(%ebp),%eax
  800105:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800108:	bf 01 00 00 00       	mov    $0x1,%edi
  80010d:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800110:	7d 48                	jge    80015a <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	6a 00                	push   $0x0
  80011a:	ff 33                	pushl  (%ebx)
  80011c:	e8 9b 16 00 00       	call   8017bc <open>
  800121:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	85 c0                	test   %eax,%eax
  800128:	78 3d                	js     800167 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	ff 33                	pushl  (%ebx)
  80012f:	50                   	push   %eax
  800130:	e8 fe fe ff ff       	call   800033 <num>
				close(f);
  800135:	89 34 24             	mov    %esi,(%esp)
  800138:	e8 0a 11 00 00       	call   801247 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 22 80 00       	push   $0x802204
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 b7 00 00 00       	call   800216 <exit>
}
  80015f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016e:	ff 30                	pushl  (%eax)
  800170:	68 0c 22 80 00       	push   $0x80220c
  800175:	6a 27                	push   $0x27
  800177:	68 e0 21 80 00       	push   $0x8021e0
  80017c:	e8 a7 00 00 00       	call   800228 <_panic>

00800181 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80018a:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800191:	00 00 00 
	envid_t find = sys_getenvid();
  800194:	e8 98 0c 00 00       	call   800e31 <sys_getenvid>
  800199:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80019f:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001a4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8001ae:	eb 0b                	jmp    8001bb <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001b0:	83 c2 01             	add    $0x1,%edx
  8001b3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8001b9:	74 21                	je     8001dc <libmain+0x5b>
		if(envs[i].env_id == find)
  8001bb:	89 d1                	mov    %edx,%ecx
  8001bd:	c1 e1 07             	shl    $0x7,%ecx
  8001c0:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8001c6:	8b 49 48             	mov    0x48(%ecx),%ecx
  8001c9:	39 c1                	cmp    %eax,%ecx
  8001cb:	75 e3                	jne    8001b0 <libmain+0x2f>
  8001cd:	89 d3                	mov    %edx,%ebx
  8001cf:	c1 e3 07             	shl    $0x7,%ebx
  8001d2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8001d8:	89 fe                	mov    %edi,%esi
  8001da:	eb d4                	jmp    8001b0 <libmain+0x2f>
  8001dc:	89 f0                	mov    %esi,%eax
  8001de:	84 c0                	test   %al,%al
  8001e0:	74 06                	je     8001e8 <libmain+0x67>
  8001e2:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ec:	7e 0a                	jle    8001f8 <libmain+0x77>
		binaryname = argv[0];
  8001ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f1:	8b 00                	mov    (%eax),%eax
  8001f3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	e8 e3 fe ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  800206:	e8 0b 00 00 00       	call   800216 <exit>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    

00800216 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80021c:	6a 00                	push   $0x0
  80021e:	e8 cd 0b 00 00       	call   800df0 <sys_env_destroy>
}
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80022d:	a1 08 40 80 00       	mov    0x804008,%eax
  800232:	8b 40 48             	mov    0x48(%eax),%eax
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 58 22 80 00       	push   $0x802258
  80023d:	50                   	push   %eax
  80023e:	68 28 22 80 00       	push   $0x802228
  800243:	e8 d6 00 00 00       	call   80031e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800248:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80024b:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800251:	e8 db 0b 00 00       	call   800e31 <sys_getenvid>
  800256:	83 c4 04             	add    $0x4,%esp
  800259:	ff 75 0c             	pushl  0xc(%ebp)
  80025c:	ff 75 08             	pushl  0x8(%ebp)
  80025f:	56                   	push   %esi
  800260:	50                   	push   %eax
  800261:	68 34 22 80 00       	push   $0x802234
  800266:	e8 b3 00 00 00       	call   80031e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026b:	83 c4 18             	add    $0x18,%esp
  80026e:	53                   	push   %ebx
  80026f:	ff 75 10             	pushl  0x10(%ebp)
  800272:	e8 56 00 00 00       	call   8002cd <vcprintf>
	cprintf("\n");
  800277:	c7 04 24 2b 27 80 00 	movl   $0x80272b,(%esp)
  80027e:	e8 9b 00 00 00       	call   80031e <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800286:	cc                   	int3   
  800287:	eb fd                	jmp    800286 <_panic+0x5e>

00800289 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	53                   	push   %ebx
  80028d:	83 ec 04             	sub    $0x4,%esp
  800290:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800293:	8b 13                	mov    (%ebx),%edx
  800295:	8d 42 01             	lea    0x1(%edx),%eax
  800298:	89 03                	mov    %eax,(%ebx)
  80029a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a6:	74 09                	je     8002b1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	68 ff 00 00 00       	push   $0xff
  8002b9:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bc:	50                   	push   %eax
  8002bd:	e8 f1 0a 00 00       	call   800db3 <sys_cputs>
		b->idx = 0;
  8002c2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	eb db                	jmp    8002a8 <putch+0x1f>

008002cd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002dd:	00 00 00 
	b.cnt = 0;
  8002e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ea:	ff 75 0c             	pushl  0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f6:	50                   	push   %eax
  8002f7:	68 89 02 80 00       	push   $0x800289
  8002fc:	e8 4a 01 00 00       	call   80044b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800301:	83 c4 08             	add    $0x8,%esp
  800304:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 9d 0a 00 00       	call   800db3 <sys_cputs>

	return b.cnt;
}
  800316:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800324:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800327:	50                   	push   %eax
  800328:	ff 75 08             	pushl  0x8(%ebp)
  80032b:	e8 9d ff ff ff       	call   8002cd <vcprintf>
	va_end(ap);

	return cnt;
}
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	57                   	push   %edi
  800336:	56                   	push   %esi
  800337:	53                   	push   %ebx
  800338:	83 ec 1c             	sub    $0x1c,%esp
  80033b:	89 c6                	mov    %eax,%esi
  80033d:	89 d7                	mov    %edx,%edi
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	8b 55 0c             	mov    0xc(%ebp),%edx
  800345:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800348:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80034b:	8b 45 10             	mov    0x10(%ebp),%eax
  80034e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800351:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800355:	74 2c                	je     800383 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800361:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800364:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800367:	39 c2                	cmp    %eax,%edx
  800369:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80036c:	73 43                	jae    8003b1 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80036e:	83 eb 01             	sub    $0x1,%ebx
  800371:	85 db                	test   %ebx,%ebx
  800373:	7e 6c                	jle    8003e1 <printnum+0xaf>
				putch(padc, putdat);
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	57                   	push   %edi
  800379:	ff 75 18             	pushl  0x18(%ebp)
  80037c:	ff d6                	call   *%esi
  80037e:	83 c4 10             	add    $0x10,%esp
  800381:	eb eb                	jmp    80036e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	6a 20                	push   $0x20
  800388:	6a 00                	push   $0x0
  80038a:	50                   	push   %eax
  80038b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038e:	ff 75 e0             	pushl  -0x20(%ebp)
  800391:	89 fa                	mov    %edi,%edx
  800393:	89 f0                	mov    %esi,%eax
  800395:	e8 98 ff ff ff       	call   800332 <printnum>
		while (--width > 0)
  80039a:	83 c4 20             	add    $0x20,%esp
  80039d:	83 eb 01             	sub    $0x1,%ebx
  8003a0:	85 db                	test   %ebx,%ebx
  8003a2:	7e 65                	jle    800409 <printnum+0xd7>
			putch(padc, putdat);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	57                   	push   %edi
  8003a8:	6a 20                	push   $0x20
  8003aa:	ff d6                	call   *%esi
  8003ac:	83 c4 10             	add    $0x10,%esp
  8003af:	eb ec                	jmp    80039d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 18             	pushl  0x18(%ebp)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	53                   	push   %ebx
  8003bb:	50                   	push   %eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cb:	e8 a0 1b 00 00       	call   801f70 <__udivdi3>
  8003d0:	83 c4 18             	add    $0x18,%esp
  8003d3:	52                   	push   %edx
  8003d4:	50                   	push   %eax
  8003d5:	89 fa                	mov    %edi,%edx
  8003d7:	89 f0                	mov    %esi,%eax
  8003d9:	e8 54 ff ff ff       	call   800332 <printnum>
  8003de:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	57                   	push   %edi
  8003e5:	83 ec 04             	sub    $0x4,%esp
  8003e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f4:	e8 87 1c 00 00       	call   802080 <__umoddi3>
  8003f9:	83 c4 14             	add    $0x14,%esp
  8003fc:	0f be 80 5f 22 80 00 	movsbl 0x80225f(%eax),%eax
  800403:	50                   	push   %eax
  800404:	ff d6                	call   *%esi
  800406:	83 c4 10             	add    $0x10,%esp
	}
}
  800409:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040c:	5b                   	pop    %ebx
  80040d:	5e                   	pop    %esi
  80040e:	5f                   	pop    %edi
  80040f:	5d                   	pop    %ebp
  800410:	c3                   	ret    

00800411 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800417:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80041b:	8b 10                	mov    (%eax),%edx
  80041d:	3b 50 04             	cmp    0x4(%eax),%edx
  800420:	73 0a                	jae    80042c <sprintputch+0x1b>
		*b->buf++ = ch;
  800422:	8d 4a 01             	lea    0x1(%edx),%ecx
  800425:	89 08                	mov    %ecx,(%eax)
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	88 02                	mov    %al,(%edx)
}
  80042c:	5d                   	pop    %ebp
  80042d:	c3                   	ret    

0080042e <printfmt>:
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800434:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800437:	50                   	push   %eax
  800438:	ff 75 10             	pushl  0x10(%ebp)
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	ff 75 08             	pushl  0x8(%ebp)
  800441:	e8 05 00 00 00       	call   80044b <vprintfmt>
}
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <vprintfmt>:
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	57                   	push   %edi
  80044f:	56                   	push   %esi
  800450:	53                   	push   %ebx
  800451:	83 ec 3c             	sub    $0x3c,%esp
  800454:	8b 75 08             	mov    0x8(%ebp),%esi
  800457:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80045a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80045d:	e9 32 04 00 00       	jmp    800894 <vprintfmt+0x449>
		padc = ' ';
  800462:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800466:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80046d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800474:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80047b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800482:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800489:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	8d 47 01             	lea    0x1(%edi),%eax
  800491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800494:	0f b6 17             	movzbl (%edi),%edx
  800497:	8d 42 dd             	lea    -0x23(%edx),%eax
  80049a:	3c 55                	cmp    $0x55,%al
  80049c:	0f 87 12 05 00 00    	ja     8009b4 <vprintfmt+0x569>
  8004a2:	0f b6 c0             	movzbl %al,%eax
  8004a5:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  8004ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004af:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004b3:	eb d9                	jmp    80048e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004b8:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004bc:	eb d0                	jmp    80048e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	0f b6 d2             	movzbl %dl,%edx
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cc:	eb 03                	jmp    8004d1 <vprintfmt+0x86>
  8004ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004d8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004db:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004de:	83 fe 09             	cmp    $0x9,%esi
  8004e1:	76 eb                	jbe    8004ce <vprintfmt+0x83>
  8004e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e9:	eb 14                	jmp    8004ff <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8d 40 04             	lea    0x4(%eax),%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800503:	79 89                	jns    80048e <vprintfmt+0x43>
				width = precision, precision = -1;
  800505:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800508:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800512:	e9 77 ff ff ff       	jmp    80048e <vprintfmt+0x43>
  800517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051a:	85 c0                	test   %eax,%eax
  80051c:	0f 48 c1             	cmovs  %ecx,%eax
  80051f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800525:	e9 64 ff ff ff       	jmp    80048e <vprintfmt+0x43>
  80052a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80052d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800534:	e9 55 ff ff ff       	jmp    80048e <vprintfmt+0x43>
			lflag++;
  800539:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800540:	e9 49 ff ff ff       	jmp    80048e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8d 78 04             	lea    0x4(%eax),%edi
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	ff 30                	pushl  (%eax)
  800551:	ff d6                	call   *%esi
			break;
  800553:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800556:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800559:	e9 33 03 00 00       	jmp    800891 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 78 04             	lea    0x4(%eax),%edi
  800564:	8b 00                	mov    (%eax),%eax
  800566:	99                   	cltd   
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 0f             	cmp    $0xf,%eax
  80056e:	7f 23                	jg     800593 <vprintfmt+0x148>
  800570:	8b 14 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	74 18                	je     800593 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80057b:	52                   	push   %edx
  80057c:	68 de 26 80 00       	push   $0x8026de
  800581:	53                   	push   %ebx
  800582:	56                   	push   %esi
  800583:	e8 a6 fe ff ff       	call   80042e <printfmt>
  800588:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80058b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80058e:	e9 fe 02 00 00       	jmp    800891 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800593:	50                   	push   %eax
  800594:	68 77 22 80 00       	push   $0x802277
  800599:	53                   	push   %ebx
  80059a:	56                   	push   %esi
  80059b:	e8 8e fe ff ff       	call   80042e <printfmt>
  8005a0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005a6:	e9 e6 02 00 00       	jmp    800891 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	83 c0 04             	add    $0x4,%eax
  8005b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005b9:	85 c9                	test   %ecx,%ecx
  8005bb:	b8 70 22 80 00       	mov    $0x802270,%eax
  8005c0:	0f 45 c1             	cmovne %ecx,%eax
  8005c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ca:	7e 06                	jle    8005d2 <vprintfmt+0x187>
  8005cc:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005d0:	75 0d                	jne    8005df <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005d5:	89 c7                	mov    %eax,%edi
  8005d7:	03 45 e0             	add    -0x20(%ebp),%eax
  8005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005dd:	eb 53                	jmp    800632 <vprintfmt+0x1e7>
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 71 04 00 00       	call   800a5c <strnlen>
  8005eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005ee:	29 c1                	sub    %eax,%ecx
  8005f0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005f3:	83 c4 10             	add    $0x10,%esp
  8005f6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005f8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ff:	eb 0f                	jmp    800610 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800601:	83 ec 08             	sub    $0x8,%esp
  800604:	53                   	push   %ebx
  800605:	ff 75 e0             	pushl  -0x20(%ebp)
  800608:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	83 ef 01             	sub    $0x1,%edi
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	85 ff                	test   %edi,%edi
  800612:	7f ed                	jg     800601 <vprintfmt+0x1b6>
  800614:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800617:	85 c9                	test   %ecx,%ecx
  800619:	b8 00 00 00 00       	mov    $0x0,%eax
  80061e:	0f 49 c1             	cmovns %ecx,%eax
  800621:	29 c1                	sub    %eax,%ecx
  800623:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800626:	eb aa                	jmp    8005d2 <vprintfmt+0x187>
					putch(ch, putdat);
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	53                   	push   %ebx
  80062c:	52                   	push   %edx
  80062d:	ff d6                	call   *%esi
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800635:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800637:	83 c7 01             	add    $0x1,%edi
  80063a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063e:	0f be d0             	movsbl %al,%edx
  800641:	85 d2                	test   %edx,%edx
  800643:	74 4b                	je     800690 <vprintfmt+0x245>
  800645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800649:	78 06                	js     800651 <vprintfmt+0x206>
  80064b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80064f:	78 1e                	js     80066f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800651:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800655:	74 d1                	je     800628 <vprintfmt+0x1dd>
  800657:	0f be c0             	movsbl %al,%eax
  80065a:	83 e8 20             	sub    $0x20,%eax
  80065d:	83 f8 5e             	cmp    $0x5e,%eax
  800660:	76 c6                	jbe    800628 <vprintfmt+0x1dd>
					putch('?', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 3f                	push   $0x3f
  800668:	ff d6                	call   *%esi
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb c3                	jmp    800632 <vprintfmt+0x1e7>
  80066f:	89 cf                	mov    %ecx,%edi
  800671:	eb 0e                	jmp    800681 <vprintfmt+0x236>
				putch(' ', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 20                	push   $0x20
  800679:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80067b:	83 ef 01             	sub    $0x1,%edi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	85 ff                	test   %edi,%edi
  800683:	7f ee                	jg     800673 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800685:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
  80068b:	e9 01 02 00 00       	jmp    800891 <vprintfmt+0x446>
  800690:	89 cf                	mov    %ecx,%edi
  800692:	eb ed                	jmp    800681 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800694:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800697:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80069e:	e9 eb fd ff ff       	jmp    80048e <vprintfmt+0x43>
	if (lflag >= 2)
  8006a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a7:	7f 21                	jg     8006ca <vprintfmt+0x27f>
	else if (lflag)
  8006a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ad:	74 68                	je     800717 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b7:	89 c1                	mov    %eax,%ecx
  8006b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c8:	eb 17                	jmp    8006e1 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 50 04             	mov    0x4(%eax),%edx
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 08             	lea    0x8(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006f1:	78 3f                	js     800732 <vprintfmt+0x2e7>
			base = 10;
  8006f3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006f8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006fc:	0f 84 71 01 00 00    	je     800873 <vprintfmt+0x428>
				putch('+', putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 2b                	push   $0x2b
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80070d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800712:	e9 5c 01 00 00       	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071f:	89 c1                	mov    %eax,%ecx
  800721:	c1 f9 1f             	sar    $0x1f,%ecx
  800724:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
  800730:	eb af                	jmp    8006e1 <vprintfmt+0x296>
				putch('-', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	53                   	push   %ebx
  800736:	6a 2d                	push   $0x2d
  800738:	ff d6                	call   *%esi
				num = -(long long) num;
  80073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80073d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800740:	f7 d8                	neg    %eax
  800742:	83 d2 00             	adc    $0x0,%edx
  800745:	f7 da                	neg    %edx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800750:	b8 0a 00 00 00       	mov    $0xa,%eax
  800755:	e9 19 01 00 00       	jmp    800873 <vprintfmt+0x428>
	if (lflag >= 2)
  80075a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80075e:	7f 29                	jg     800789 <vprintfmt+0x33e>
	else if (lflag)
  800760:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800764:	74 44                	je     8007aa <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80077f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800784:	e9 ea 00 00 00       	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 50 04             	mov    0x4(%eax),%edx
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800794:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 08             	lea    0x8(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a5:	e9 c9 00 00 00       	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8d 40 04             	lea    0x4(%eax),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c8:	e9 a6 00 00 00       	jmp    800873 <vprintfmt+0x428>
			putch('0', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	6a 30                	push   $0x30
  8007d3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007dc:	7f 26                	jg     800804 <vprintfmt+0x3b9>
	else if (lflag)
  8007de:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e2:	74 3e                	je     800822 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8d 40 04             	lea    0x4(%eax),%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007fd:	b8 08 00 00 00       	mov    $0x8,%eax
  800802:	eb 6f                	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 50 04             	mov    0x4(%eax),%edx
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80081b:	b8 08 00 00 00       	mov    $0x8,%eax
  800820:	eb 51                	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80083b:	b8 08 00 00 00       	mov    $0x8,%eax
  800840:	eb 31                	jmp    800873 <vprintfmt+0x428>
			putch('0', putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 30                	push   $0x30
  800848:	ff d6                	call   *%esi
			putch('x', putdat);
  80084a:	83 c4 08             	add    $0x8,%esp
  80084d:	53                   	push   %ebx
  80084e:	6a 78                	push   $0x78
  800850:	ff d6                	call   *%esi
			num = (unsigned long long)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	ba 00 00 00 00       	mov    $0x0,%edx
  80085c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800862:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 40 04             	lea    0x4(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800873:	83 ec 0c             	sub    $0xc,%esp
  800876:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80087a:	52                   	push   %edx
  80087b:	ff 75 e0             	pushl  -0x20(%ebp)
  80087e:	50                   	push   %eax
  80087f:	ff 75 dc             	pushl  -0x24(%ebp)
  800882:	ff 75 d8             	pushl  -0x28(%ebp)
  800885:	89 da                	mov    %ebx,%edx
  800887:	89 f0                	mov    %esi,%eax
  800889:	e8 a4 fa ff ff       	call   800332 <printnum>
			break;
  80088e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800894:	83 c7 01             	add    $0x1,%edi
  800897:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80089b:	83 f8 25             	cmp    $0x25,%eax
  80089e:	0f 84 be fb ff ff    	je     800462 <vprintfmt+0x17>
			if (ch == '\0')
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	0f 84 28 01 00 00    	je     8009d4 <vprintfmt+0x589>
			putch(ch, putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	53                   	push   %ebx
  8008b0:	50                   	push   %eax
  8008b1:	ff d6                	call   *%esi
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	eb dc                	jmp    800894 <vprintfmt+0x449>
	if (lflag >= 2)
  8008b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008bc:	7f 26                	jg     8008e4 <vprintfmt+0x499>
	else if (lflag)
  8008be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008c2:	74 41                	je     800905 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d7:	8d 40 04             	lea    0x4(%eax),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e2:	eb 8f                	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	8b 50 04             	mov    0x4(%eax),%edx
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8d 40 08             	lea    0x8(%eax),%eax
  8008f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008fb:	b8 10 00 00 00       	mov    $0x10,%eax
  800900:	e9 6e ff ff ff       	jmp    800873 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800905:	8b 45 14             	mov    0x14(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	ba 00 00 00 00       	mov    $0x0,%edx
  80090f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800912:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8d 40 04             	lea    0x4(%eax),%eax
  80091b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80091e:	b8 10 00 00 00       	mov    $0x10,%eax
  800923:	e9 4b ff ff ff       	jmp    800873 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 c0 04             	add    $0x4,%eax
  80092e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	85 c0                	test   %eax,%eax
  800938:	74 14                	je     80094e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80093a:	8b 13                	mov    (%ebx),%edx
  80093c:	83 fa 7f             	cmp    $0x7f,%edx
  80093f:	7f 37                	jg     800978 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800941:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800943:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	e9 43 ff ff ff       	jmp    800891 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80094e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800953:	bf 95 23 80 00       	mov    $0x802395,%edi
							putch(ch, putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	50                   	push   %eax
  80095d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80095f:	83 c7 01             	add    $0x1,%edi
  800962:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800966:	83 c4 10             	add    $0x10,%esp
  800969:	85 c0                	test   %eax,%eax
  80096b:	75 eb                	jne    800958 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80096d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800970:	89 45 14             	mov    %eax,0x14(%ebp)
  800973:	e9 19 ff ff ff       	jmp    800891 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800978:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80097a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80097f:	bf cd 23 80 00       	mov    $0x8023cd,%edi
							putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	53                   	push   %ebx
  800988:	50                   	push   %eax
  800989:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80098b:	83 c7 01             	add    $0x1,%edi
  80098e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	85 c0                	test   %eax,%eax
  800997:	75 eb                	jne    800984 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800999:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80099c:	89 45 14             	mov    %eax,0x14(%ebp)
  80099f:	e9 ed fe ff ff       	jmp    800891 <vprintfmt+0x446>
			putch(ch, putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	53                   	push   %ebx
  8009a8:	6a 25                	push   $0x25
  8009aa:	ff d6                	call   *%esi
			break;
  8009ac:	83 c4 10             	add    $0x10,%esp
  8009af:	e9 dd fe ff ff       	jmp    800891 <vprintfmt+0x446>
			putch('%', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	53                   	push   %ebx
  8009b8:	6a 25                	push   $0x25
  8009ba:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 f8                	mov    %edi,%eax
  8009c1:	eb 03                	jmp    8009c6 <vprintfmt+0x57b>
  8009c3:	83 e8 01             	sub    $0x1,%eax
  8009c6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009ca:	75 f7                	jne    8009c3 <vprintfmt+0x578>
  8009cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009cf:	e9 bd fe ff ff       	jmp    800891 <vprintfmt+0x446>
}
  8009d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 18             	sub    $0x18,%esp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009eb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009ef:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f9:	85 c0                	test   %eax,%eax
  8009fb:	74 26                	je     800a23 <vsnprintf+0x47>
  8009fd:	85 d2                	test   %edx,%edx
  8009ff:	7e 22                	jle    800a23 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a01:	ff 75 14             	pushl  0x14(%ebp)
  800a04:	ff 75 10             	pushl  0x10(%ebp)
  800a07:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a0a:	50                   	push   %eax
  800a0b:	68 11 04 80 00       	push   $0x800411
  800a10:	e8 36 fa ff ff       	call   80044b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a18:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1e:	83 c4 10             	add    $0x10,%esp
}
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    
		return -E_INVAL;
  800a23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a28:	eb f7                	jmp    800a21 <vsnprintf+0x45>

00800a2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a30:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a33:	50                   	push   %eax
  800a34:	ff 75 10             	pushl  0x10(%ebp)
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	ff 75 08             	pushl  0x8(%ebp)
  800a3d:	e8 9a ff ff ff       	call   8009dc <vsnprintf>
	va_end(ap);

	return rc;
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a53:	74 05                	je     800a5a <strlen+0x16>
		n++;
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	eb f5                	jmp    800a4f <strlen+0xb>
	return n;
}
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a65:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 0d                	je     800a7b <strnlen+0x1f>
  800a6e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a72:	74 05                	je     800a79 <strnlen+0x1d>
		n++;
  800a74:	83 c2 01             	add    $0x1,%edx
  800a77:	eb f1                	jmp    800a6a <strnlen+0xe>
  800a79:	89 d0                	mov    %edx,%eax
	return n;
}
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	53                   	push   %ebx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a87:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a90:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a93:	83 c2 01             	add    $0x1,%edx
  800a96:	84 c9                	test   %cl,%cl
  800a98:	75 f2                	jne    800a8c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	53                   	push   %ebx
  800aa1:	83 ec 10             	sub    $0x10,%esp
  800aa4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aa7:	53                   	push   %ebx
  800aa8:	e8 97 ff ff ff       	call   800a44 <strlen>
  800aad:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	01 d8                	add    %ebx,%eax
  800ab5:	50                   	push   %eax
  800ab6:	e8 c2 ff ff ff       	call   800a7d <strcpy>
	return dst;
}
  800abb:	89 d8                	mov    %ebx,%eax
  800abd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	56                   	push   %esi
  800ac6:	53                   	push   %ebx
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800acd:	89 c6                	mov    %eax,%esi
  800acf:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	39 f2                	cmp    %esi,%edx
  800ad6:	74 11                	je     800ae9 <strncpy+0x27>
		*dst++ = *src;
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	0f b6 19             	movzbl (%ecx),%ebx
  800ade:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ae1:	80 fb 01             	cmp    $0x1,%bl
  800ae4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ae7:	eb eb                	jmp    800ad4 <strncpy+0x12>
	}
	return ret;
}
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 75 08             	mov    0x8(%ebp),%esi
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	8b 55 10             	mov    0x10(%ebp),%edx
  800afb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800afd:	85 d2                	test   %edx,%edx
  800aff:	74 21                	je     800b22 <strlcpy+0x35>
  800b01:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b05:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 14                	je     800b1f <strlcpy+0x32>
  800b0b:	0f b6 19             	movzbl (%ecx),%ebx
  800b0e:	84 db                	test   %bl,%bl
  800b10:	74 0b                	je     800b1d <strlcpy+0x30>
			*dst++ = *src++;
  800b12:	83 c1 01             	add    $0x1,%ecx
  800b15:	83 c2 01             	add    $0x1,%edx
  800b18:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b1b:	eb ea                	jmp    800b07 <strlcpy+0x1a>
  800b1d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b1f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b22:	29 f0                	sub    %esi,%eax
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b31:	0f b6 01             	movzbl (%ecx),%eax
  800b34:	84 c0                	test   %al,%al
  800b36:	74 0c                	je     800b44 <strcmp+0x1c>
  800b38:	3a 02                	cmp    (%edx),%al
  800b3a:	75 08                	jne    800b44 <strcmp+0x1c>
		p++, q++;
  800b3c:	83 c1 01             	add    $0x1,%ecx
  800b3f:	83 c2 01             	add    $0x1,%edx
  800b42:	eb ed                	jmp    800b31 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b44:	0f b6 c0             	movzbl %al,%eax
  800b47:	0f b6 12             	movzbl (%edx),%edx
  800b4a:	29 d0                	sub    %edx,%eax
}
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b58:	89 c3                	mov    %eax,%ebx
  800b5a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b5d:	eb 06                	jmp    800b65 <strncmp+0x17>
		n--, p++, q++;
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b65:	39 d8                	cmp    %ebx,%eax
  800b67:	74 16                	je     800b7f <strncmp+0x31>
  800b69:	0f b6 08             	movzbl (%eax),%ecx
  800b6c:	84 c9                	test   %cl,%cl
  800b6e:	74 04                	je     800b74 <strncmp+0x26>
  800b70:	3a 0a                	cmp    (%edx),%cl
  800b72:	74 eb                	je     800b5f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b74:	0f b6 00             	movzbl (%eax),%eax
  800b77:	0f b6 12             	movzbl (%edx),%edx
  800b7a:	29 d0                	sub    %edx,%eax
}
  800b7c:	5b                   	pop    %ebx
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    
		return 0;
  800b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b84:	eb f6                	jmp    800b7c <strncmp+0x2e>

00800b86 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b90:	0f b6 10             	movzbl (%eax),%edx
  800b93:	84 d2                	test   %dl,%dl
  800b95:	74 09                	je     800ba0 <strchr+0x1a>
		if (*s == c)
  800b97:	38 ca                	cmp    %cl,%dl
  800b99:	74 0a                	je     800ba5 <strchr+0x1f>
	for (; *s; s++)
  800b9b:	83 c0 01             	add    $0x1,%eax
  800b9e:	eb f0                	jmp    800b90 <strchr+0xa>
			return (char *) s;
	return 0;
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bb4:	38 ca                	cmp    %cl,%dl
  800bb6:	74 09                	je     800bc1 <strfind+0x1a>
  800bb8:	84 d2                	test   %dl,%dl
  800bba:	74 05                	je     800bc1 <strfind+0x1a>
	for (; *s; s++)
  800bbc:	83 c0 01             	add    $0x1,%eax
  800bbf:	eb f0                	jmp    800bb1 <strfind+0xa>
			break;
	return (char *) s;
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bcf:	85 c9                	test   %ecx,%ecx
  800bd1:	74 31                	je     800c04 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bd3:	89 f8                	mov    %edi,%eax
  800bd5:	09 c8                	or     %ecx,%eax
  800bd7:	a8 03                	test   $0x3,%al
  800bd9:	75 23                	jne    800bfe <memset+0x3b>
		c &= 0xFF;
  800bdb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bdf:	89 d3                	mov    %edx,%ebx
  800be1:	c1 e3 08             	shl    $0x8,%ebx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	c1 e0 18             	shl    $0x18,%eax
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	c1 e6 10             	shl    $0x10,%esi
  800bee:	09 f0                	or     %esi,%eax
  800bf0:	09 c2                	or     %eax,%edx
  800bf2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bf4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bf7:	89 d0                	mov    %edx,%eax
  800bf9:	fc                   	cld    
  800bfa:	f3 ab                	rep stos %eax,%es:(%edi)
  800bfc:	eb 06                	jmp    800c04 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	fc                   	cld    
  800c02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c04:	89 f8                	mov    %edi,%eax
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c16:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c19:	39 c6                	cmp    %eax,%esi
  800c1b:	73 32                	jae    800c4f <memmove+0x44>
  800c1d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c20:	39 c2                	cmp    %eax,%edx
  800c22:	76 2b                	jbe    800c4f <memmove+0x44>
		s += n;
		d += n;
  800c24:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c27:	89 fe                	mov    %edi,%esi
  800c29:	09 ce                	or     %ecx,%esi
  800c2b:	09 d6                	or     %edx,%esi
  800c2d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c33:	75 0e                	jne    800c43 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c35:	83 ef 04             	sub    $0x4,%edi
  800c38:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c3b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c3e:	fd                   	std    
  800c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c41:	eb 09                	jmp    800c4c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c43:	83 ef 01             	sub    $0x1,%edi
  800c46:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c49:	fd                   	std    
  800c4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c4c:	fc                   	cld    
  800c4d:	eb 1a                	jmp    800c69 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	09 ca                	or     %ecx,%edx
  800c53:	09 f2                	or     %esi,%edx
  800c55:	f6 c2 03             	test   $0x3,%dl
  800c58:	75 0a                	jne    800c64 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c5d:	89 c7                	mov    %eax,%edi
  800c5f:	fc                   	cld    
  800c60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c62:	eb 05                	jmp    800c69 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c64:	89 c7                	mov    %eax,%edi
  800c66:	fc                   	cld    
  800c67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c73:	ff 75 10             	pushl  0x10(%ebp)
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	ff 75 08             	pushl  0x8(%ebp)
  800c7c:	e8 8a ff ff ff       	call   800c0b <memmove>
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8e:	89 c6                	mov    %eax,%esi
  800c90:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c93:	39 f0                	cmp    %esi,%eax
  800c95:	74 1c                	je     800cb3 <memcmp+0x30>
		if (*s1 != *s2)
  800c97:	0f b6 08             	movzbl (%eax),%ecx
  800c9a:	0f b6 1a             	movzbl (%edx),%ebx
  800c9d:	38 d9                	cmp    %bl,%cl
  800c9f:	75 08                	jne    800ca9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ca1:	83 c0 01             	add    $0x1,%eax
  800ca4:	83 c2 01             	add    $0x1,%edx
  800ca7:	eb ea                	jmp    800c93 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ca9:	0f b6 c1             	movzbl %cl,%eax
  800cac:	0f b6 db             	movzbl %bl,%ebx
  800caf:	29 d8                	sub    %ebx,%eax
  800cb1:	eb 05                	jmp    800cb8 <memcmp+0x35>
	}

	return 0;
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cc5:	89 c2                	mov    %eax,%edx
  800cc7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cca:	39 d0                	cmp    %edx,%eax
  800ccc:	73 09                	jae    800cd7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cce:	38 08                	cmp    %cl,(%eax)
  800cd0:	74 05                	je     800cd7 <memfind+0x1b>
	for (; s < ends; s++)
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	eb f3                	jmp    800cca <memfind+0xe>
			break;
	return (void *) s;
}
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce5:	eb 03                	jmp    800cea <strtol+0x11>
		s++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cea:	0f b6 01             	movzbl (%ecx),%eax
  800ced:	3c 20                	cmp    $0x20,%al
  800cef:	74 f6                	je     800ce7 <strtol+0xe>
  800cf1:	3c 09                	cmp    $0x9,%al
  800cf3:	74 f2                	je     800ce7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cf5:	3c 2b                	cmp    $0x2b,%al
  800cf7:	74 2a                	je     800d23 <strtol+0x4a>
	int neg = 0;
  800cf9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cfe:	3c 2d                	cmp    $0x2d,%al
  800d00:	74 2b                	je     800d2d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d02:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d08:	75 0f                	jne    800d19 <strtol+0x40>
  800d0a:	80 39 30             	cmpb   $0x30,(%ecx)
  800d0d:	74 28                	je     800d37 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d0f:	85 db                	test   %ebx,%ebx
  800d11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d16:	0f 44 d8             	cmove  %eax,%ebx
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d21:	eb 50                	jmp    800d73 <strtol+0x9a>
		s++;
  800d23:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d26:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2b:	eb d5                	jmp    800d02 <strtol+0x29>
		s++, neg = 1;
  800d2d:	83 c1 01             	add    $0x1,%ecx
  800d30:	bf 01 00 00 00       	mov    $0x1,%edi
  800d35:	eb cb                	jmp    800d02 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d37:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d3b:	74 0e                	je     800d4b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d3d:	85 db                	test   %ebx,%ebx
  800d3f:	75 d8                	jne    800d19 <strtol+0x40>
		s++, base = 8;
  800d41:	83 c1 01             	add    $0x1,%ecx
  800d44:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d49:	eb ce                	jmp    800d19 <strtol+0x40>
		s += 2, base = 16;
  800d4b:	83 c1 02             	add    $0x2,%ecx
  800d4e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d53:	eb c4                	jmp    800d19 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d55:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d58:	89 f3                	mov    %esi,%ebx
  800d5a:	80 fb 19             	cmp    $0x19,%bl
  800d5d:	77 29                	ja     800d88 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d5f:	0f be d2             	movsbl %dl,%edx
  800d62:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d68:	7d 30                	jge    800d9a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d6a:	83 c1 01             	add    $0x1,%ecx
  800d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d71:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d73:	0f b6 11             	movzbl (%ecx),%edx
  800d76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 09             	cmp    $0x9,%bl
  800d7e:	77 d5                	ja     800d55 <strtol+0x7c>
			dig = *s - '0';
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 30             	sub    $0x30,%edx
  800d86:	eb dd                	jmp    800d65 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d88:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d8b:	89 f3                	mov    %esi,%ebx
  800d8d:	80 fb 19             	cmp    $0x19,%bl
  800d90:	77 08                	ja     800d9a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d92:	0f be d2             	movsbl %dl,%edx
  800d95:	83 ea 37             	sub    $0x37,%edx
  800d98:	eb cb                	jmp    800d65 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 05                	je     800da5 <strtol+0xcc>
		*endptr = (char *) s;
  800da0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800da3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	f7 da                	neg    %edx
  800da9:	85 ff                	test   %edi,%edi
  800dab:	0f 45 c2             	cmovne %edx,%eax
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	89 c3                	mov    %eax,%ebx
  800dc6:	89 c7                	mov    %eax,%edi
  800dc8:	89 c6                	mov    %eax,%esi
  800dca:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dcc:	5b                   	pop    %ebx
  800dcd:	5e                   	pop    %esi
  800dce:	5f                   	pop    %edi
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  800de1:	89 d1                	mov    %edx,%ecx
  800de3:	89 d3                	mov    %edx,%ebx
  800de5:	89 d7                	mov    %edx,%edi
  800de7:	89 d6                	mov    %edx,%esi
  800de9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	b8 03 00 00 00       	mov    $0x3,%eax
  800e06:	89 cb                	mov    %ecx,%ebx
  800e08:	89 cf                	mov    %ecx,%edi
  800e0a:	89 ce                	mov    %ecx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 03                	push   $0x3
  800e20:	68 e0 25 80 00       	push   $0x8025e0
  800e25:	6a 43                	push   $0x43
  800e27:	68 fd 25 80 00       	push   $0x8025fd
  800e2c:	e8 f7 f3 ff ff       	call   800228 <_panic>

00800e31 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e37:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e41:	89 d1                	mov    %edx,%ecx
  800e43:	89 d3                	mov    %edx,%ebx
  800e45:	89 d7                	mov    %edx,%edi
  800e47:	89 d6                	mov    %edx,%esi
  800e49:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_yield>:

void
sys_yield(void)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e60:	89 d1                	mov    %edx,%ecx
  800e62:	89 d3                	mov    %edx,%ebx
  800e64:	89 d7                	mov    %edx,%edi
  800e66:	89 d6                	mov    %edx,%esi
  800e68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e78:	be 00 00 00 00       	mov    $0x0,%esi
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	b8 04 00 00 00       	mov    $0x4,%eax
  800e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8b:	89 f7                	mov    %esi,%edi
  800e8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7f 08                	jg     800e9b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	50                   	push   %eax
  800e9f:	6a 04                	push   $0x4
  800ea1:	68 e0 25 80 00       	push   $0x8025e0
  800ea6:	6a 43                	push   $0x43
  800ea8:	68 fd 25 80 00       	push   $0x8025fd
  800ead:	e8 76 f3 ff ff       	call   800228 <_panic>

00800eb2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
  800eb8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ecc:	8b 75 18             	mov    0x18(%ebp),%esi
  800ecf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	7f 08                	jg     800edd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edd:	83 ec 0c             	sub    $0xc,%esp
  800ee0:	50                   	push   %eax
  800ee1:	6a 05                	push   $0x5
  800ee3:	68 e0 25 80 00       	push   $0x8025e0
  800ee8:	6a 43                	push   $0x43
  800eea:	68 fd 25 80 00       	push   $0x8025fd
  800eef:	e8 34 f3 ff ff       	call   800228 <_panic>

00800ef4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f08:	b8 06 00 00 00       	mov    $0x6,%eax
  800f0d:	89 df                	mov    %ebx,%edi
  800f0f:	89 de                	mov    %ebx,%esi
  800f11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	7f 08                	jg     800f1f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1f:	83 ec 0c             	sub    $0xc,%esp
  800f22:	50                   	push   %eax
  800f23:	6a 06                	push   $0x6
  800f25:	68 e0 25 80 00       	push   $0x8025e0
  800f2a:	6a 43                	push   $0x43
  800f2c:	68 fd 25 80 00       	push   $0x8025fd
  800f31:	e8 f2 f2 ff ff       	call   800228 <_panic>

00800f36 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
  800f3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4a:	b8 08 00 00 00       	mov    $0x8,%eax
  800f4f:	89 df                	mov    %ebx,%edi
  800f51:	89 de                	mov    %ebx,%esi
  800f53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7f 08                	jg     800f61 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5c:	5b                   	pop    %ebx
  800f5d:	5e                   	pop    %esi
  800f5e:	5f                   	pop    %edi
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f61:	83 ec 0c             	sub    $0xc,%esp
  800f64:	50                   	push   %eax
  800f65:	6a 08                	push   $0x8
  800f67:	68 e0 25 80 00       	push   $0x8025e0
  800f6c:	6a 43                	push   $0x43
  800f6e:	68 fd 25 80 00       	push   $0x8025fd
  800f73:	e8 b0 f2 ff ff       	call   800228 <_panic>

00800f78 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
  800f7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8c:	b8 09 00 00 00       	mov    $0x9,%eax
  800f91:	89 df                	mov    %ebx,%edi
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7f 08                	jg     800fa3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	50                   	push   %eax
  800fa7:	6a 09                	push   $0x9
  800fa9:	68 e0 25 80 00       	push   $0x8025e0
  800fae:	6a 43                	push   $0x43
  800fb0:	68 fd 25 80 00       	push   $0x8025fd
  800fb5:	e8 6e f2 ff ff       	call   800228 <_panic>

00800fba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fce:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fd3:	89 df                	mov    %ebx,%edi
  800fd5:	89 de                	mov    %ebx,%esi
  800fd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7f 08                	jg     800fe5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	50                   	push   %eax
  800fe9:	6a 0a                	push   $0xa
  800feb:	68 e0 25 80 00       	push   $0x8025e0
  800ff0:	6a 43                	push   $0x43
  800ff2:	68 fd 25 80 00       	push   $0x8025fd
  800ff7:	e8 2c f2 ff ff       	call   800228 <_panic>

00800ffc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	57                   	push   %edi
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
	asm volatile("int %1\n"
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	b8 0c 00 00 00       	mov    $0xc,%eax
  80100d:	be 00 00 00 00       	mov    $0x0,%esi
  801012:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801015:	8b 7d 14             	mov    0x14(%ebp),%edi
  801018:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80101a:	5b                   	pop    %ebx
  80101b:	5e                   	pop    %esi
  80101c:	5f                   	pop    %edi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	57                   	push   %edi
  801023:	56                   	push   %esi
  801024:	53                   	push   %ebx
  801025:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801028:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	b8 0d 00 00 00       	mov    $0xd,%eax
  801035:	89 cb                	mov    %ecx,%ebx
  801037:	89 cf                	mov    %ecx,%edi
  801039:	89 ce                	mov    %ecx,%esi
  80103b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	7f 08                	jg     801049 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801049:	83 ec 0c             	sub    $0xc,%esp
  80104c:	50                   	push   %eax
  80104d:	6a 0d                	push   $0xd
  80104f:	68 e0 25 80 00       	push   $0x8025e0
  801054:	6a 43                	push   $0x43
  801056:	68 fd 25 80 00       	push   $0x8025fd
  80105b:	e8 c8 f1 ff ff       	call   800228 <_panic>

00801060 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
	asm volatile("int %1\n"
  801066:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106b:	8b 55 08             	mov    0x8(%ebp),%edx
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	b8 0e 00 00 00       	mov    $0xe,%eax
  801076:	89 df                	mov    %ebx,%edi
  801078:	89 de                	mov    %ebx,%esi
  80107a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
	asm volatile("int %1\n"
  801087:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	b8 0f 00 00 00       	mov    $0xf,%eax
  801094:	89 cb                	mov    %ecx,%ebx
  801096:	89 cf                	mov    %ecx,%edi
  801098:	89 ce                	mov    %ecx,%esi
  80109a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ac:	c1 e8 0c             	shr    $0xc,%eax
}
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d0:	89 c2                	mov    %eax,%edx
  8010d2:	c1 ea 16             	shr    $0x16,%edx
  8010d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010dc:	f6 c2 01             	test   $0x1,%dl
  8010df:	74 2d                	je     80110e <fd_alloc+0x46>
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	c1 ea 0c             	shr    $0xc,%edx
  8010e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ed:	f6 c2 01             	test   $0x1,%dl
  8010f0:	74 1c                	je     80110e <fd_alloc+0x46>
  8010f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010fc:	75 d2                	jne    8010d0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801107:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80110c:	eb 0a                	jmp    801118 <fd_alloc+0x50>
			*fd_store = fd;
  80110e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801111:	89 01                	mov    %eax,(%ecx)
			return 0;
  801113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801120:	83 f8 1f             	cmp    $0x1f,%eax
  801123:	77 30                	ja     801155 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801125:	c1 e0 0c             	shl    $0xc,%eax
  801128:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80112d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801133:	f6 c2 01             	test   $0x1,%dl
  801136:	74 24                	je     80115c <fd_lookup+0x42>
  801138:	89 c2                	mov    %eax,%edx
  80113a:	c1 ea 0c             	shr    $0xc,%edx
  80113d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801144:	f6 c2 01             	test   $0x1,%dl
  801147:	74 1a                	je     801163 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114c:	89 02                	mov    %eax,(%edx)
	return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		return -E_INVAL;
  801155:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115a:	eb f7                	jmp    801153 <fd_lookup+0x39>
		return -E_INVAL;
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801161:	eb f0                	jmp    801153 <fd_lookup+0x39>
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb e9                	jmp    801153 <fd_lookup+0x39>

0080116a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801173:	ba 8c 26 80 00       	mov    $0x80268c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801178:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80117d:	39 08                	cmp    %ecx,(%eax)
  80117f:	74 33                	je     8011b4 <dev_lookup+0x4a>
  801181:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801184:	8b 02                	mov    (%edx),%eax
  801186:	85 c0                	test   %eax,%eax
  801188:	75 f3                	jne    80117d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80118a:	a1 08 40 80 00       	mov    0x804008,%eax
  80118f:	8b 40 48             	mov    0x48(%eax),%eax
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	51                   	push   %ecx
  801196:	50                   	push   %eax
  801197:	68 0c 26 80 00       	push   $0x80260c
  80119c:	e8 7d f1 ff ff       	call   80031e <cprintf>
	*dev = 0;
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    
			*dev = devtab[i];
  8011b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011be:	eb f2                	jmp    8011b2 <dev_lookup+0x48>

008011c0 <fd_close>:
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 24             	sub    $0x24,%esp
  8011c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011d9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011dc:	50                   	push   %eax
  8011dd:	e8 38 ff ff ff       	call   80111a <fd_lookup>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	78 05                	js     8011f0 <fd_close+0x30>
	    || fd != fd2)
  8011eb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ee:	74 16                	je     801206 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f0:	89 f8                	mov    %edi,%eax
  8011f2:	84 c0                	test   %al,%al
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f9:	0f 44 d8             	cmove  %eax,%ebx
}
  8011fc:	89 d8                	mov    %ebx,%eax
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80120c:	50                   	push   %eax
  80120d:	ff 36                	pushl  (%esi)
  80120f:	e8 56 ff ff ff       	call   80116a <dev_lookup>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 1a                	js     801237 <fd_close+0x77>
		if (dev->dev_close)
  80121d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801220:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801223:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801228:	85 c0                	test   %eax,%eax
  80122a:	74 0b                	je     801237 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	56                   	push   %esi
  801230:	ff d0                	call   *%eax
  801232:	89 c3                	mov    %eax,%ebx
  801234:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	56                   	push   %esi
  80123b:	6a 00                	push   $0x0
  80123d:	e8 b2 fc ff ff       	call   800ef4 <sys_page_unmap>
	return r;
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	eb b5                	jmp    8011fc <fd_close+0x3c>

00801247 <close>:

int
close(int fdnum)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801250:	50                   	push   %eax
  801251:	ff 75 08             	pushl  0x8(%ebp)
  801254:	e8 c1 fe ff ff       	call   80111a <fd_lookup>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	85 c0                	test   %eax,%eax
  80125e:	79 02                	jns    801262 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    
		return fd_close(fd, 1);
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	6a 01                	push   $0x1
  801267:	ff 75 f4             	pushl  -0xc(%ebp)
  80126a:	e8 51 ff ff ff       	call   8011c0 <fd_close>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	eb ec                	jmp    801260 <close+0x19>

00801274 <close_all>:

void
close_all(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	53                   	push   %ebx
  801278:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	53                   	push   %ebx
  801284:	e8 be ff ff ff       	call   801247 <close>
	for (i = 0; i < MAXFD; i++)
  801289:	83 c3 01             	add    $0x1,%ebx
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	83 fb 20             	cmp    $0x20,%ebx
  801292:	75 ec                	jne    801280 <close_all+0xc>
}
  801294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	ff 75 08             	pushl  0x8(%ebp)
  8012a9:	e8 6c fe ff ff       	call   80111a <fd_lookup>
  8012ae:	89 c3                	mov    %eax,%ebx
  8012b0:	83 c4 10             	add    $0x10,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	0f 88 81 00 00 00    	js     80133c <dup+0xa3>
		return r;
	close(newfdnum);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	e8 81 ff ff ff       	call   801247 <close>

	newfd = INDEX2FD(newfdnum);
  8012c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c9:	c1 e6 0c             	shl    $0xc,%esi
  8012cc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012d2:	83 c4 04             	add    $0x4,%esp
  8012d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d8:	e8 d4 fd ff ff       	call   8010b1 <fd2data>
  8012dd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012df:	89 34 24             	mov    %esi,(%esp)
  8012e2:	e8 ca fd ff ff       	call   8010b1 <fd2data>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ec:	89 d8                	mov    %ebx,%eax
  8012ee:	c1 e8 16             	shr    $0x16,%eax
  8012f1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f8:	a8 01                	test   $0x1,%al
  8012fa:	74 11                	je     80130d <dup+0x74>
  8012fc:	89 d8                	mov    %ebx,%eax
  8012fe:	c1 e8 0c             	shr    $0xc,%eax
  801301:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801308:	f6 c2 01             	test   $0x1,%dl
  80130b:	75 39                	jne    801346 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80130d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801310:	89 d0                	mov    %edx,%eax
  801312:	c1 e8 0c             	shr    $0xc,%eax
  801315:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	25 07 0e 00 00       	and    $0xe07,%eax
  801324:	50                   	push   %eax
  801325:	56                   	push   %esi
  801326:	6a 00                	push   $0x0
  801328:	52                   	push   %edx
  801329:	6a 00                	push   $0x0
  80132b:	e8 82 fb ff ff       	call   800eb2 <sys_page_map>
  801330:	89 c3                	mov    %eax,%ebx
  801332:	83 c4 20             	add    $0x20,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 31                	js     80136a <dup+0xd1>
		goto err;

	return newfdnum;
  801339:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80133c:	89 d8                	mov    %ebx,%eax
  80133e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801346:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	25 07 0e 00 00       	and    $0xe07,%eax
  801355:	50                   	push   %eax
  801356:	57                   	push   %edi
  801357:	6a 00                	push   $0x0
  801359:	53                   	push   %ebx
  80135a:	6a 00                	push   $0x0
  80135c:	e8 51 fb ff ff       	call   800eb2 <sys_page_map>
  801361:	89 c3                	mov    %eax,%ebx
  801363:	83 c4 20             	add    $0x20,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	79 a3                	jns    80130d <dup+0x74>
	sys_page_unmap(0, newfd);
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	56                   	push   %esi
  80136e:	6a 00                	push   $0x0
  801370:	e8 7f fb ff ff       	call   800ef4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801375:	83 c4 08             	add    $0x8,%esp
  801378:	57                   	push   %edi
  801379:	6a 00                	push   $0x0
  80137b:	e8 74 fb ff ff       	call   800ef4 <sys_page_unmap>
	return r;
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	eb b7                	jmp    80133c <dup+0xa3>

00801385 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	53                   	push   %ebx
  801389:	83 ec 1c             	sub    $0x1c,%esp
  80138c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	53                   	push   %ebx
  801394:	e8 81 fd ff ff       	call   80111a <fd_lookup>
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 3f                	js     8013df <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013aa:	ff 30                	pushl  (%eax)
  8013ac:	e8 b9 fd ff ff       	call   80116a <dev_lookup>
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 27                	js     8013df <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bb:	8b 42 08             	mov    0x8(%edx),%eax
  8013be:	83 e0 03             	and    $0x3,%eax
  8013c1:	83 f8 01             	cmp    $0x1,%eax
  8013c4:	74 1e                	je     8013e4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c9:	8b 40 08             	mov    0x8(%eax),%eax
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 35                	je     801405 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	ff 75 10             	pushl  0x10(%ebp)
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	52                   	push   %edx
  8013da:	ff d0                	call   *%eax
  8013dc:	83 c4 10             	add    $0x10,%esp
}
  8013df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013e9:	8b 40 48             	mov    0x48(%eax),%eax
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	50                   	push   %eax
  8013f1:	68 50 26 80 00       	push   $0x802650
  8013f6:	e8 23 ef ff ff       	call   80031e <cprintf>
		return -E_INVAL;
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb da                	jmp    8013df <read+0x5a>
		return -E_NOT_SUPP;
  801405:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140a:	eb d3                	jmp    8013df <read+0x5a>

0080140c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	8b 7d 08             	mov    0x8(%ebp),%edi
  801418:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801420:	39 f3                	cmp    %esi,%ebx
  801422:	73 23                	jae    801447 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	89 f0                	mov    %esi,%eax
  801429:	29 d8                	sub    %ebx,%eax
  80142b:	50                   	push   %eax
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	03 45 0c             	add    0xc(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	57                   	push   %edi
  801433:	e8 4d ff ff ff       	call   801385 <read>
		if (m < 0)
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 06                	js     801445 <readn+0x39>
			return m;
		if (m == 0)
  80143f:	74 06                	je     801447 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801441:	01 c3                	add    %eax,%ebx
  801443:	eb db                	jmp    801420 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801445:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801447:	89 d8                	mov    %ebx,%eax
  801449:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144c:	5b                   	pop    %ebx
  80144d:	5e                   	pop    %esi
  80144e:	5f                   	pop    %edi
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    

00801451 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	53                   	push   %ebx
  801455:	83 ec 1c             	sub    $0x1c,%esp
  801458:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145e:	50                   	push   %eax
  80145f:	53                   	push   %ebx
  801460:	e8 b5 fc ff ff       	call   80111a <fd_lookup>
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 3a                	js     8014a6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	50                   	push   %eax
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	ff 30                	pushl  (%eax)
  801478:	e8 ed fc ff ff       	call   80116a <dev_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 22                	js     8014a6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801487:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148b:	74 1e                	je     8014ab <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801490:	8b 52 0c             	mov    0xc(%edx),%edx
  801493:	85 d2                	test   %edx,%edx
  801495:	74 35                	je     8014cc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	ff 75 10             	pushl  0x10(%ebp)
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	50                   	push   %eax
  8014a1:	ff d2                	call   *%edx
  8014a3:	83 c4 10             	add    $0x10,%esp
}
  8014a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b0:	8b 40 48             	mov    0x48(%eax),%eax
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	53                   	push   %ebx
  8014b7:	50                   	push   %eax
  8014b8:	68 6c 26 80 00       	push   $0x80266c
  8014bd:	e8 5c ee ff ff       	call   80031e <cprintf>
		return -E_INVAL;
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ca:	eb da                	jmp    8014a6 <write+0x55>
		return -E_NOT_SUPP;
  8014cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d1:	eb d3                	jmp    8014a6 <write+0x55>

008014d3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	e8 35 fc ff ff       	call   80111a <fd_lookup>
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	78 0e                	js     8014fa <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	53                   	push   %ebx
  801500:	83 ec 1c             	sub    $0x1c,%esp
  801503:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801506:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801509:	50                   	push   %eax
  80150a:	53                   	push   %ebx
  80150b:	e8 0a fc ff ff       	call   80111a <fd_lookup>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 37                	js     80154e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801521:	ff 30                	pushl  (%eax)
  801523:	e8 42 fc ff ff       	call   80116a <dev_lookup>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 1f                	js     80154e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801536:	74 1b                	je     801553 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801538:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153b:	8b 52 18             	mov    0x18(%edx),%edx
  80153e:	85 d2                	test   %edx,%edx
  801540:	74 32                	je     801574 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	50                   	push   %eax
  801549:	ff d2                	call   *%edx
  80154b:	83 c4 10             	add    $0x10,%esp
}
  80154e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801551:	c9                   	leave  
  801552:	c3                   	ret    
			thisenv->env_id, fdnum);
  801553:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801558:	8b 40 48             	mov    0x48(%eax),%eax
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	53                   	push   %ebx
  80155f:	50                   	push   %eax
  801560:	68 2c 26 80 00       	push   $0x80262c
  801565:	e8 b4 ed ff ff       	call   80031e <cprintf>
		return -E_INVAL;
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801572:	eb da                	jmp    80154e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801574:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801579:	eb d3                	jmp    80154e <ftruncate+0x52>

0080157b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	53                   	push   %ebx
  80157f:	83 ec 1c             	sub    $0x1c,%esp
  801582:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801585:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	e8 89 fb ff ff       	call   80111a <fd_lookup>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	85 c0                	test   %eax,%eax
  801596:	78 4b                	js     8015e3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159e:	50                   	push   %eax
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	ff 30                	pushl  (%eax)
  8015a4:	e8 c1 fb ff ff       	call   80116a <dev_lookup>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 33                	js     8015e3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b7:	74 2f                	je     8015e8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c3:	00 00 00 
	stat->st_isdir = 0;
  8015c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cd:	00 00 00 
	stat->st_dev = dev;
  8015d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	53                   	push   %ebx
  8015da:	ff 75 f0             	pushl  -0x10(%ebp)
  8015dd:	ff 50 14             	call   *0x14(%eax)
  8015e0:	83 c4 10             	add    $0x10,%esp
}
  8015e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    
		return -E_NOT_SUPP;
  8015e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ed:	eb f4                	jmp    8015e3 <fstat+0x68>

008015ef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	56                   	push   %esi
  8015f3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f4:	83 ec 08             	sub    $0x8,%esp
  8015f7:	6a 00                	push   $0x0
  8015f9:	ff 75 08             	pushl  0x8(%ebp)
  8015fc:	e8 bb 01 00 00       	call   8017bc <open>
  801601:	89 c3                	mov    %eax,%ebx
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 1b                	js     801625 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	50                   	push   %eax
  801611:	e8 65 ff ff ff       	call   80157b <fstat>
  801616:	89 c6                	mov    %eax,%esi
	close(fd);
  801618:	89 1c 24             	mov    %ebx,(%esp)
  80161b:	e8 27 fc ff ff       	call   801247 <close>
	return r;
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	89 f3                	mov    %esi,%ebx
}
  801625:	89 d8                	mov    %ebx,%eax
  801627:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5d                   	pop    %ebp
  80162d:	c3                   	ret    

0080162e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	89 c6                	mov    %eax,%esi
  801635:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801637:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80163e:	74 27                	je     801667 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801640:	6a 07                	push   $0x7
  801642:	68 00 50 80 00       	push   $0x805000
  801647:	56                   	push   %esi
  801648:	ff 35 04 40 80 00    	pushl  0x804004
  80164e:	e8 4e 08 00 00       	call   801ea1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801653:	83 c4 0c             	add    $0xc,%esp
  801656:	6a 00                	push   $0x0
  801658:	53                   	push   %ebx
  801659:	6a 00                	push   $0x0
  80165b:	e8 d8 07 00 00       	call   801e38 <ipc_recv>
}
  801660:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801663:	5b                   	pop    %ebx
  801664:	5e                   	pop    %esi
  801665:	5d                   	pop    %ebp
  801666:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801667:	83 ec 0c             	sub    $0xc,%esp
  80166a:	6a 01                	push   $0x1
  80166c:	e8 88 08 00 00       	call   801ef9 <ipc_find_env>
  801671:	a3 04 40 80 00       	mov    %eax,0x804004
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	eb c5                	jmp    801640 <fsipc+0x12>

0080167b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	8b 40 0c             	mov    0xc(%eax),%eax
  801687:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	b8 02 00 00 00       	mov    $0x2,%eax
  80169e:	e8 8b ff ff ff       	call   80162e <fsipc>
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <devfile_flush>:
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bb:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c0:	e8 69 ff ff ff       	call   80162e <fsipc>
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <devfile_stat>:
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e6:	e8 43 ff ff ff       	call   80162e <fsipc>
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 2c                	js     80171b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	68 00 50 80 00       	push   $0x805000
  8016f7:	53                   	push   %ebx
  8016f8:	e8 80 f3 ff ff       	call   800a7d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016fd:	a1 80 50 80 00       	mov    0x805080,%eax
  801702:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801708:	a1 84 50 80 00       	mov    0x805084,%eax
  80170d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <devfile_write>:
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801726:	68 9c 26 80 00       	push   $0x80269c
  80172b:	68 90 00 00 00       	push   $0x90
  801730:	68 ba 26 80 00       	push   $0x8026ba
  801735:	e8 ee ea ff ff       	call   800228 <_panic>

0080173a <devfile_read>:
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 40 0c             	mov    0xc(%eax),%eax
  801748:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801753:	ba 00 00 00 00       	mov    $0x0,%edx
  801758:	b8 03 00 00 00       	mov    $0x3,%eax
  80175d:	e8 cc fe ff ff       	call   80162e <fsipc>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	85 c0                	test   %eax,%eax
  801766:	78 1f                	js     801787 <devfile_read+0x4d>
	assert(r <= n);
  801768:	39 f0                	cmp    %esi,%eax
  80176a:	77 24                	ja     801790 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801771:	7f 33                	jg     8017a6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	50                   	push   %eax
  801777:	68 00 50 80 00       	push   $0x805000
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	e8 87 f4 ff ff       	call   800c0b <memmove>
	return r;
  801784:	83 c4 10             	add    $0x10,%esp
}
  801787:	89 d8                	mov    %ebx,%eax
  801789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    
	assert(r <= n);
  801790:	68 c5 26 80 00       	push   $0x8026c5
  801795:	68 cc 26 80 00       	push   $0x8026cc
  80179a:	6a 7c                	push   $0x7c
  80179c:	68 ba 26 80 00       	push   $0x8026ba
  8017a1:	e8 82 ea ff ff       	call   800228 <_panic>
	assert(r <= PGSIZE);
  8017a6:	68 e1 26 80 00       	push   $0x8026e1
  8017ab:	68 cc 26 80 00       	push   $0x8026cc
  8017b0:	6a 7d                	push   $0x7d
  8017b2:	68 ba 26 80 00       	push   $0x8026ba
  8017b7:	e8 6c ea ff ff       	call   800228 <_panic>

008017bc <open>:
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 1c             	sub    $0x1c,%esp
  8017c4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c7:	56                   	push   %esi
  8017c8:	e8 77 f2 ff ff       	call   800a44 <strlen>
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d5:	7f 6c                	jg     801843 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dd:	50                   	push   %eax
  8017de:	e8 e5 f8 ff ff       	call   8010c8 <fd_alloc>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 3c                	js     801828 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	56                   	push   %esi
  8017f0:	68 00 50 80 00       	push   $0x805000
  8017f5:	e8 83 f2 ff ff       	call   800a7d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	b8 01 00 00 00       	mov    $0x1,%eax
  80180a:	e8 1f fe ff ff       	call   80162e <fsipc>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	78 19                	js     801831 <open+0x75>
	return fd2num(fd);
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	e8 7e f8 ff ff       	call   8010a1 <fd2num>
  801823:	89 c3                	mov    %eax,%ebx
  801825:	83 c4 10             	add    $0x10,%esp
}
  801828:	89 d8                	mov    %ebx,%eax
  80182a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    
		fd_close(fd, 0);
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	6a 00                	push   $0x0
  801836:	ff 75 f4             	pushl  -0xc(%ebp)
  801839:	e8 82 f9 ff ff       	call   8011c0 <fd_close>
		return r;
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	eb e5                	jmp    801828 <open+0x6c>
		return -E_BAD_PATH;
  801843:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801848:	eb de                	jmp    801828 <open+0x6c>

0080184a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 08 00 00 00       	mov    $0x8,%eax
  80185a:	e8 cf fd ff ff       	call   80162e <fsipc>
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801861:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801865:	7f 01                	jg     801868 <writebuf+0x7>
  801867:	c3                   	ret    
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	53                   	push   %ebx
  80186c:	83 ec 08             	sub    $0x8,%esp
  80186f:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801871:	ff 70 04             	pushl  0x4(%eax)
  801874:	8d 40 10             	lea    0x10(%eax),%eax
  801877:	50                   	push   %eax
  801878:	ff 33                	pushl  (%ebx)
  80187a:	e8 d2 fb ff ff       	call   801451 <write>
		if (result > 0)
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	7e 03                	jle    801889 <writebuf+0x28>
			b->result += result;
  801886:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801889:	39 43 04             	cmp    %eax,0x4(%ebx)
  80188c:	74 0d                	je     80189b <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80188e:	85 c0                	test   %eax,%eax
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	0f 4f c2             	cmovg  %edx,%eax
  801898:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80189b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <putch>:

static void
putch(int ch, void *thunk)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8018aa:	8b 53 04             	mov    0x4(%ebx),%edx
  8018ad:	8d 42 01             	lea    0x1(%edx),%eax
  8018b0:	89 43 04             	mov    %eax,0x4(%ebx)
  8018b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018ba:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018bf:	74 06                	je     8018c7 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8018c1:	83 c4 04             	add    $0x4,%esp
  8018c4:	5b                   	pop    %ebx
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    
		writebuf(b);
  8018c7:	89 d8                	mov    %ebx,%eax
  8018c9:	e8 93 ff ff ff       	call   801861 <writebuf>
		b->idx = 0;
  8018ce:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018d5:	eb ea                	jmp    8018c1 <putch+0x21>

008018d7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018e9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018f0:	00 00 00 
	b.result = 0;
  8018f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018fa:	00 00 00 
	b.error = 1;
  8018fd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801904:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801907:	ff 75 10             	pushl  0x10(%ebp)
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801913:	50                   	push   %eax
  801914:	68 a0 18 80 00       	push   $0x8018a0
  801919:	e8 2d eb ff ff       	call   80044b <vprintfmt>
	if (b.idx > 0)
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801928:	7f 11                	jg     80193b <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80192a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801930:	85 c0                	test   %eax,%eax
  801932:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    
		writebuf(&b);
  80193b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801941:	e8 1b ff ff ff       	call   801861 <writebuf>
  801946:	eb e2                	jmp    80192a <vfprintf+0x53>

00801948 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80194e:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801951:	50                   	push   %eax
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	ff 75 08             	pushl  0x8(%ebp)
  801958:	e8 7a ff ff ff       	call   8018d7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <printf>:

int
printf(const char *fmt, ...)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801965:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801968:	50                   	push   %eax
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 01                	push   $0x1
  80196e:	e8 64 ff ff ff       	call   8018d7 <vfprintf>
	va_end(ap);

	return cnt;
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	e8 29 f7 ff ff       	call   8010b1 <fd2data>
  801988:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80198a:	83 c4 08             	add    $0x8,%esp
  80198d:	68 ed 26 80 00       	push   $0x8026ed
  801992:	53                   	push   %ebx
  801993:	e8 e5 f0 ff ff       	call   800a7d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801998:	8b 46 04             	mov    0x4(%esi),%eax
  80199b:	2b 06                	sub    (%esi),%eax
  80199d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019a3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019aa:	00 00 00 
	stat->st_dev = &devpipe;
  8019ad:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  8019b4:	30 80 00 
	return 0;
}
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8019cd:	53                   	push   %ebx
  8019ce:	6a 00                	push   $0x0
  8019d0:	e8 1f f5 ff ff       	call   800ef4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019d5:	89 1c 24             	mov    %ebx,(%esp)
  8019d8:	e8 d4 f6 ff ff       	call   8010b1 <fd2data>
  8019dd:	83 c4 08             	add    $0x8,%esp
  8019e0:	50                   	push   %eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	e8 0c f5 ff ff       	call   800ef4 <sys_page_unmap>
}
  8019e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <_pipeisclosed>:
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	57                   	push   %edi
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 1c             	sub    $0x1c,%esp
  8019f6:	89 c7                	mov    %eax,%edi
  8019f8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8019ff:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	57                   	push   %edi
  801a06:	e8 29 05 00 00       	call   801f34 <pageref>
  801a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a0e:	89 34 24             	mov    %esi,(%esp)
  801a11:	e8 1e 05 00 00       	call   801f34 <pageref>
		nn = thisenv->env_runs;
  801a16:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a1c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	39 cb                	cmp    %ecx,%ebx
  801a24:	74 1b                	je     801a41 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a26:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a29:	75 cf                	jne    8019fa <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a2b:	8b 42 58             	mov    0x58(%edx),%eax
  801a2e:	6a 01                	push   $0x1
  801a30:	50                   	push   %eax
  801a31:	53                   	push   %ebx
  801a32:	68 f4 26 80 00       	push   $0x8026f4
  801a37:	e8 e2 e8 ff ff       	call   80031e <cprintf>
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	eb b9                	jmp    8019fa <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a41:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a44:	0f 94 c0             	sete   %al
  801a47:	0f b6 c0             	movzbl %al,%eax
}
  801a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5f                   	pop    %edi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <devpipe_write>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	57                   	push   %edi
  801a56:	56                   	push   %esi
  801a57:	53                   	push   %ebx
  801a58:	83 ec 28             	sub    $0x28,%esp
  801a5b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a5e:	56                   	push   %esi
  801a5f:	e8 4d f6 ff ff       	call   8010b1 <fd2data>
  801a64:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	bf 00 00 00 00       	mov    $0x0,%edi
  801a6e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a71:	74 4f                	je     801ac2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a73:	8b 43 04             	mov    0x4(%ebx),%eax
  801a76:	8b 0b                	mov    (%ebx),%ecx
  801a78:	8d 51 20             	lea    0x20(%ecx),%edx
  801a7b:	39 d0                	cmp    %edx,%eax
  801a7d:	72 14                	jb     801a93 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a7f:	89 da                	mov    %ebx,%edx
  801a81:	89 f0                	mov    %esi,%eax
  801a83:	e8 65 ff ff ff       	call   8019ed <_pipeisclosed>
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	75 3b                	jne    801ac7 <devpipe_write+0x75>
			sys_yield();
  801a8c:	e8 bf f3 ff ff       	call   800e50 <sys_yield>
  801a91:	eb e0                	jmp    801a73 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a96:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801a9a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801a9d:	89 c2                	mov    %eax,%edx
  801a9f:	c1 fa 1f             	sar    $0x1f,%edx
  801aa2:	89 d1                	mov    %edx,%ecx
  801aa4:	c1 e9 1b             	shr    $0x1b,%ecx
  801aa7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801aaa:	83 e2 1f             	and    $0x1f,%edx
  801aad:	29 ca                	sub    %ecx,%edx
  801aaf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ab3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ab7:	83 c0 01             	add    $0x1,%eax
  801aba:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801abd:	83 c7 01             	add    $0x1,%edi
  801ac0:	eb ac                	jmp    801a6e <devpipe_write+0x1c>
	return i;
  801ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac5:	eb 05                	jmp    801acc <devpipe_write+0x7a>
				return 0;
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5f                   	pop    %edi
  801ad2:	5d                   	pop    %ebp
  801ad3:	c3                   	ret    

00801ad4 <devpipe_read>:
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	57                   	push   %edi
  801ad8:	56                   	push   %esi
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 18             	sub    $0x18,%esp
  801add:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ae0:	57                   	push   %edi
  801ae1:	e8 cb f5 ff ff       	call   8010b1 <fd2data>
  801ae6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	be 00 00 00 00       	mov    $0x0,%esi
  801af0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801af3:	75 14                	jne    801b09 <devpipe_read+0x35>
	return i;
  801af5:	8b 45 10             	mov    0x10(%ebp),%eax
  801af8:	eb 02                	jmp    801afc <devpipe_read+0x28>
				return i;
  801afa:	89 f0                	mov    %esi,%eax
}
  801afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
			sys_yield();
  801b04:	e8 47 f3 ff ff       	call   800e50 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801b09:	8b 03                	mov    (%ebx),%eax
  801b0b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b0e:	75 18                	jne    801b28 <devpipe_read+0x54>
			if (i > 0)
  801b10:	85 f6                	test   %esi,%esi
  801b12:	75 e6                	jne    801afa <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801b14:	89 da                	mov    %ebx,%edx
  801b16:	89 f8                	mov    %edi,%eax
  801b18:	e8 d0 fe ff ff       	call   8019ed <_pipeisclosed>
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 e3                	je     801b04 <devpipe_read+0x30>
				return 0;
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax
  801b26:	eb d4                	jmp    801afc <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b28:	99                   	cltd   
  801b29:	c1 ea 1b             	shr    $0x1b,%edx
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	83 e0 1f             	and    $0x1f,%eax
  801b31:	29 d0                	sub    %edx,%eax
  801b33:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b3b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b3e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b41:	83 c6 01             	add    $0x1,%esi
  801b44:	eb aa                	jmp    801af0 <devpipe_read+0x1c>

00801b46 <pipe>:
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	56                   	push   %esi
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b51:	50                   	push   %eax
  801b52:	e8 71 f5 ff ff       	call   8010c8 <fd_alloc>
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	0f 88 23 01 00 00    	js     801c87 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	68 07 04 00 00       	push   $0x407
  801b6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b6f:	6a 00                	push   $0x0
  801b71:	e8 f9 f2 ff ff       	call   800e6f <sys_page_alloc>
  801b76:	89 c3                	mov    %eax,%ebx
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	0f 88 04 01 00 00    	js     801c87 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801b83:	83 ec 0c             	sub    $0xc,%esp
  801b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b89:	50                   	push   %eax
  801b8a:	e8 39 f5 ff ff       	call   8010c8 <fd_alloc>
  801b8f:	89 c3                	mov    %eax,%ebx
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	0f 88 db 00 00 00    	js     801c77 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b9c:	83 ec 04             	sub    $0x4,%esp
  801b9f:	68 07 04 00 00       	push   $0x407
  801ba4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba7:	6a 00                	push   $0x0
  801ba9:	e8 c1 f2 ff ff       	call   800e6f <sys_page_alloc>
  801bae:	89 c3                	mov    %eax,%ebx
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	0f 88 bc 00 00 00    	js     801c77 <pipe+0x131>
	va = fd2data(fd0);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc1:	e8 eb f4 ff ff       	call   8010b1 <fd2data>
  801bc6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bc8:	83 c4 0c             	add    $0xc,%esp
  801bcb:	68 07 04 00 00       	push   $0x407
  801bd0:	50                   	push   %eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	e8 97 f2 ff ff       	call   800e6f <sys_page_alloc>
  801bd8:	89 c3                	mov    %eax,%ebx
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	0f 88 82 00 00 00    	js     801c67 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	ff 75 f0             	pushl  -0x10(%ebp)
  801beb:	e8 c1 f4 ff ff       	call   8010b1 <fd2data>
  801bf0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bf7:	50                   	push   %eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	56                   	push   %esi
  801bfb:	6a 00                	push   $0x0
  801bfd:	e8 b0 f2 ff ff       	call   800eb2 <sys_page_map>
  801c02:	89 c3                	mov    %eax,%ebx
  801c04:	83 c4 20             	add    $0x20,%esp
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 4e                	js     801c59 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801c0b:	a1 24 30 80 00       	mov    0x803024,%eax
  801c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c13:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c18:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801c1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c22:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	ff 75 f4             	pushl  -0xc(%ebp)
  801c34:	e8 68 f4 ff ff       	call   8010a1 <fd2num>
  801c39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c3e:	83 c4 04             	add    $0x4,%esp
  801c41:	ff 75 f0             	pushl  -0x10(%ebp)
  801c44:	e8 58 f4 ff ff       	call   8010a1 <fd2num>
  801c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c4c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c4f:	83 c4 10             	add    $0x10,%esp
  801c52:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c57:	eb 2e                	jmp    801c87 <pipe+0x141>
	sys_page_unmap(0, va);
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	56                   	push   %esi
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 90 f2 ff ff       	call   800ef4 <sys_page_unmap>
  801c64:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c67:	83 ec 08             	sub    $0x8,%esp
  801c6a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c6d:	6a 00                	push   $0x0
  801c6f:	e8 80 f2 ff ff       	call   800ef4 <sys_page_unmap>
  801c74:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c77:	83 ec 08             	sub    $0x8,%esp
  801c7a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7d:	6a 00                	push   $0x0
  801c7f:	e8 70 f2 ff ff       	call   800ef4 <sys_page_unmap>
  801c84:	83 c4 10             	add    $0x10,%esp
}
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5e                   	pop    %esi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <pipeisclosed>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c99:	50                   	push   %eax
  801c9a:	ff 75 08             	pushl  0x8(%ebp)
  801c9d:	e8 78 f4 ff ff       	call   80111a <fd_lookup>
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	78 18                	js     801cc1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	ff 75 f4             	pushl  -0xc(%ebp)
  801caf:	e8 fd f3 ff ff       	call   8010b1 <fd2data>
	return _pipeisclosed(fd, p);
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	e8 2f fd ff ff       	call   8019ed <_pipeisclosed>
  801cbe:	83 c4 10             	add    $0x10,%esp
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	c3                   	ret    

00801cc9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ccf:	68 0c 27 80 00       	push   $0x80270c
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	e8 a1 ed ff ff       	call   800a7d <strcpy>
	return 0;
}
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <devcons_write>:
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	57                   	push   %edi
  801ce7:	56                   	push   %esi
  801ce8:	53                   	push   %ebx
  801ce9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801cef:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801cf4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cfa:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cfd:	73 31                	jae    801d30 <devcons_write+0x4d>
		m = n - tot;
  801cff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d02:	29 f3                	sub    %esi,%ebx
  801d04:	83 fb 7f             	cmp    $0x7f,%ebx
  801d07:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d0c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	53                   	push   %ebx
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	03 45 0c             	add    0xc(%ebp),%eax
  801d18:	50                   	push   %eax
  801d19:	57                   	push   %edi
  801d1a:	e8 ec ee ff ff       	call   800c0b <memmove>
		sys_cputs(buf, m);
  801d1f:	83 c4 08             	add    $0x8,%esp
  801d22:	53                   	push   %ebx
  801d23:	57                   	push   %edi
  801d24:	e8 8a f0 ff ff       	call   800db3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d29:	01 de                	add    %ebx,%esi
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	eb ca                	jmp    801cfa <devcons_write+0x17>
}
  801d30:	89 f0                	mov    %esi,%eax
  801d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    

00801d3a <devcons_read>:
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 08             	sub    $0x8,%esp
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d49:	74 21                	je     801d6c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  801d4b:	e8 81 f0 ff ff       	call   800dd1 <sys_cgetc>
  801d50:	85 c0                	test   %eax,%eax
  801d52:	75 07                	jne    801d5b <devcons_read+0x21>
		sys_yield();
  801d54:	e8 f7 f0 ff ff       	call   800e50 <sys_yield>
  801d59:	eb f0                	jmp    801d4b <devcons_read+0x11>
	if (c < 0)
  801d5b:	78 0f                	js     801d6c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  801d5d:	83 f8 04             	cmp    $0x4,%eax
  801d60:	74 0c                	je     801d6e <devcons_read+0x34>
	*(char*)vbuf = c;
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d65:	88 02                	mov    %al,(%edx)
	return 1;
  801d67:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    
		return 0;
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d73:	eb f7                	jmp    801d6c <devcons_read+0x32>

00801d75 <cputchar>:
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d81:	6a 01                	push   $0x1
  801d83:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d86:	50                   	push   %eax
  801d87:	e8 27 f0 ff ff       	call   800db3 <sys_cputs>
}
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <getchar>:
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d97:	6a 01                	push   $0x1
  801d99:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d9c:	50                   	push   %eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	e8 e1 f5 ff ff       	call   801385 <read>
	if (r < 0)
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	85 c0                	test   %eax,%eax
  801da9:	78 06                	js     801db1 <getchar+0x20>
	if (r < 1)
  801dab:	74 06                	je     801db3 <getchar+0x22>
	return c;
  801dad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    
		return -E_EOF;
  801db3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801db8:	eb f7                	jmp    801db1 <getchar+0x20>

00801dba <iscons>:
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc3:	50                   	push   %eax
  801dc4:	ff 75 08             	pushl  0x8(%ebp)
  801dc7:	e8 4e f3 ff ff       	call   80111a <fd_lookup>
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	85 c0                	test   %eax,%eax
  801dd1:	78 11                	js     801de4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801ddc:	39 10                	cmp    %edx,(%eax)
  801dde:	0f 94 c0             	sete   %al
  801de1:	0f b6 c0             	movzbl %al,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <opencons>:
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801def:	50                   	push   %eax
  801df0:	e8 d3 f2 ff ff       	call   8010c8 <fd_alloc>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 3a                	js     801e36 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	68 07 04 00 00       	push   $0x407
  801e04:	ff 75 f4             	pushl  -0xc(%ebp)
  801e07:	6a 00                	push   $0x0
  801e09:	e8 61 f0 ff ff       	call   800e6f <sys_page_alloc>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	85 c0                	test   %eax,%eax
  801e13:	78 21                	js     801e36 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801e1e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	50                   	push   %eax
  801e2e:	e8 6e f2 ff ff       	call   8010a1 <fd2num>
  801e33:	83 c4 10             	add    $0x10,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	56                   	push   %esi
  801e3c:	53                   	push   %ebx
  801e3d:	8b 75 08             	mov    0x8(%ebp),%esi
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  801e46:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801e48:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801e4d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	50                   	push   %eax
  801e54:	e8 c6 f1 ff ff       	call   80101f <sys_ipc_recv>
	if(ret < 0){
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 2b                	js     801e8b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801e60:	85 f6                	test   %esi,%esi
  801e62:	74 0a                	je     801e6e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801e64:	a1 08 40 80 00       	mov    0x804008,%eax
  801e69:	8b 40 74             	mov    0x74(%eax),%eax
  801e6c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  801e6e:	85 db                	test   %ebx,%ebx
  801e70:	74 0a                	je     801e7c <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801e72:	a1 08 40 80 00       	mov    0x804008,%eax
  801e77:	8b 40 78             	mov    0x78(%eax),%eax
  801e7a:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  801e7c:	a1 08 40 80 00       	mov    0x804008,%eax
  801e81:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    
		if(from_env_store)
  801e8b:	85 f6                	test   %esi,%esi
  801e8d:	74 06                	je     801e95 <ipc_recv+0x5d>
			*from_env_store = 0;
  801e8f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801e95:	85 db                	test   %ebx,%ebx
  801e97:	74 eb                	je     801e84 <ipc_recv+0x4c>
			*perm_store = 0;
  801e99:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e9f:	eb e3                	jmp    801e84 <ipc_recv+0x4c>

00801ea1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	57                   	push   %edi
  801ea5:	56                   	push   %esi
  801ea6:	53                   	push   %ebx
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ead:	8b 75 0c             	mov    0xc(%ebp),%esi
  801eb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801eb3:	85 db                	test   %ebx,%ebx
  801eb5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801eba:	0f 44 d8             	cmove  %eax,%ebx
  801ebd:	eb 05                	jmp    801ec4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801ebf:	e8 8c ef ff ff       	call   800e50 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801ec4:	ff 75 14             	pushl  0x14(%ebp)
  801ec7:	53                   	push   %ebx
  801ec8:	56                   	push   %esi
  801ec9:	57                   	push   %edi
  801eca:	e8 2d f1 ff ff       	call   800ffc <sys_ipc_try_send>
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	74 1b                	je     801ef1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801ed6:	79 e7                	jns    801ebf <ipc_send+0x1e>
  801ed8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801edb:	74 e2                	je     801ebf <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	68 18 27 80 00       	push   $0x802718
  801ee5:	6a 49                	push   $0x49
  801ee7:	68 2d 27 80 00       	push   $0x80272d
  801eec:	e8 37 e3 ff ff       	call   800228 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    

00801ef9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	c1 e2 07             	shl    $0x7,%edx
  801f09:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801f0f:	8b 52 50             	mov    0x50(%edx),%edx
  801f12:	39 ca                	cmp    %ecx,%edx
  801f14:	74 11                	je     801f27 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801f16:	83 c0 01             	add    $0x1,%eax
  801f19:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f1e:	75 e4                	jne    801f04 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	eb 0b                	jmp    801f32 <ipc_find_env+0x39>
			return envs[i].env_id;
  801f27:	c1 e0 07             	shl    $0x7,%eax
  801f2a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801f2f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    

00801f34 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f3a:	89 d0                	mov    %edx,%eax
  801f3c:	c1 e8 16             	shr    $0x16,%eax
  801f3f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801f4b:	f6 c1 01             	test   $0x1,%cl
  801f4e:	74 1d                	je     801f6d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801f50:	c1 ea 0c             	shr    $0xc,%edx
  801f53:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f5a:	f6 c2 01             	test   $0x1,%dl
  801f5d:	74 0e                	je     801f6d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f5f:	c1 ea 0c             	shr    $0xc,%edx
  801f62:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f69:	ef 
  801f6a:	0f b7 c0             	movzwl %ax,%eax
}
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    
  801f6f:	90                   	nop

00801f70 <__udivdi3>:
  801f70:	55                   	push   %ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	83 ec 1c             	sub    $0x1c,%esp
  801f77:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  801f7b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  801f7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f83:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801f87:	85 d2                	test   %edx,%edx
  801f89:	75 4d                	jne    801fd8 <__udivdi3+0x68>
  801f8b:	39 f3                	cmp    %esi,%ebx
  801f8d:	76 19                	jbe    801fa8 <__udivdi3+0x38>
  801f8f:	31 ff                	xor    %edi,%edi
  801f91:	89 e8                	mov    %ebp,%eax
  801f93:	89 f2                	mov    %esi,%edx
  801f95:	f7 f3                	div    %ebx
  801f97:	89 fa                	mov    %edi,%edx
  801f99:	83 c4 1c             	add    $0x1c,%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5f                   	pop    %edi
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    
  801fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fa8:	89 d9                	mov    %ebx,%ecx
  801faa:	85 db                	test   %ebx,%ebx
  801fac:	75 0b                	jne    801fb9 <__udivdi3+0x49>
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	31 d2                	xor    %edx,%edx
  801fb5:	f7 f3                	div    %ebx
  801fb7:	89 c1                	mov    %eax,%ecx
  801fb9:	31 d2                	xor    %edx,%edx
  801fbb:	89 f0                	mov    %esi,%eax
  801fbd:	f7 f1                	div    %ecx
  801fbf:	89 c6                	mov    %eax,%esi
  801fc1:	89 e8                	mov    %ebp,%eax
  801fc3:	89 f7                	mov    %esi,%edi
  801fc5:	f7 f1                	div    %ecx
  801fc7:	89 fa                	mov    %edi,%edx
  801fc9:	83 c4 1c             	add    $0x1c,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
  801fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fd8:	39 f2                	cmp    %esi,%edx
  801fda:	77 1c                	ja     801ff8 <__udivdi3+0x88>
  801fdc:	0f bd fa             	bsr    %edx,%edi
  801fdf:	83 f7 1f             	xor    $0x1f,%edi
  801fe2:	75 2c                	jne    802010 <__udivdi3+0xa0>
  801fe4:	39 f2                	cmp    %esi,%edx
  801fe6:	72 06                	jb     801fee <__udivdi3+0x7e>
  801fe8:	31 c0                	xor    %eax,%eax
  801fea:	39 eb                	cmp    %ebp,%ebx
  801fec:	77 a9                	ja     801f97 <__udivdi3+0x27>
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	eb a2                	jmp    801f97 <__udivdi3+0x27>
  801ff5:	8d 76 00             	lea    0x0(%esi),%esi
  801ff8:	31 ff                	xor    %edi,%edi
  801ffa:	31 c0                	xor    %eax,%eax
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	83 c4 1c             	add    $0x1c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80200d:	8d 76 00             	lea    0x0(%esi),%esi
  802010:	89 f9                	mov    %edi,%ecx
  802012:	b8 20 00 00 00       	mov    $0x20,%eax
  802017:	29 f8                	sub    %edi,%eax
  802019:	d3 e2                	shl    %cl,%edx
  80201b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80201f:	89 c1                	mov    %eax,%ecx
  802021:	89 da                	mov    %ebx,%edx
  802023:	d3 ea                	shr    %cl,%edx
  802025:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802029:	09 d1                	or     %edx,%ecx
  80202b:	89 f2                	mov    %esi,%edx
  80202d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802031:	89 f9                	mov    %edi,%ecx
  802033:	d3 e3                	shl    %cl,%ebx
  802035:	89 c1                	mov    %eax,%ecx
  802037:	d3 ea                	shr    %cl,%edx
  802039:	89 f9                	mov    %edi,%ecx
  80203b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80203f:	89 eb                	mov    %ebp,%ebx
  802041:	d3 e6                	shl    %cl,%esi
  802043:	89 c1                	mov    %eax,%ecx
  802045:	d3 eb                	shr    %cl,%ebx
  802047:	09 de                	or     %ebx,%esi
  802049:	89 f0                	mov    %esi,%eax
  80204b:	f7 74 24 08          	divl   0x8(%esp)
  80204f:	89 d6                	mov    %edx,%esi
  802051:	89 c3                	mov    %eax,%ebx
  802053:	f7 64 24 0c          	mull   0xc(%esp)
  802057:	39 d6                	cmp    %edx,%esi
  802059:	72 15                	jb     802070 <__udivdi3+0x100>
  80205b:	89 f9                	mov    %edi,%ecx
  80205d:	d3 e5                	shl    %cl,%ebp
  80205f:	39 c5                	cmp    %eax,%ebp
  802061:	73 04                	jae    802067 <__udivdi3+0xf7>
  802063:	39 d6                	cmp    %edx,%esi
  802065:	74 09                	je     802070 <__udivdi3+0x100>
  802067:	89 d8                	mov    %ebx,%eax
  802069:	31 ff                	xor    %edi,%edi
  80206b:	e9 27 ff ff ff       	jmp    801f97 <__udivdi3+0x27>
  802070:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802073:	31 ff                	xor    %edi,%edi
  802075:	e9 1d ff ff ff       	jmp    801f97 <__udivdi3+0x27>
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	66 90                	xchg   %ax,%ax
  80207e:	66 90                	xchg   %ax,%ax

00802080 <__umoddi3>:
  802080:	55                   	push   %ebp
  802081:	57                   	push   %edi
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	83 ec 1c             	sub    $0x1c,%esp
  802087:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80208b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80208f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802093:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802097:	89 da                	mov    %ebx,%edx
  802099:	85 c0                	test   %eax,%eax
  80209b:	75 43                	jne    8020e0 <__umoddi3+0x60>
  80209d:	39 df                	cmp    %ebx,%edi
  80209f:	76 17                	jbe    8020b8 <__umoddi3+0x38>
  8020a1:	89 f0                	mov    %esi,%eax
  8020a3:	f7 f7                	div    %edi
  8020a5:	89 d0                	mov    %edx,%eax
  8020a7:	31 d2                	xor    %edx,%edx
  8020a9:	83 c4 1c             	add    $0x1c,%esp
  8020ac:	5b                   	pop    %ebx
  8020ad:	5e                   	pop    %esi
  8020ae:	5f                   	pop    %edi
  8020af:	5d                   	pop    %ebp
  8020b0:	c3                   	ret    
  8020b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	89 fd                	mov    %edi,%ebp
  8020ba:	85 ff                	test   %edi,%edi
  8020bc:	75 0b                	jne    8020c9 <__umoddi3+0x49>
  8020be:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c3:	31 d2                	xor    %edx,%edx
  8020c5:	f7 f7                	div    %edi
  8020c7:	89 c5                	mov    %eax,%ebp
  8020c9:	89 d8                	mov    %ebx,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	f7 f5                	div    %ebp
  8020cf:	89 f0                	mov    %esi,%eax
  8020d1:	f7 f5                	div    %ebp
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	eb d0                	jmp    8020a7 <__umoddi3+0x27>
  8020d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	89 f1                	mov    %esi,%ecx
  8020e2:	39 d8                	cmp    %ebx,%eax
  8020e4:	76 0a                	jbe    8020f0 <__umoddi3+0x70>
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	83 c4 1c             	add    $0x1c,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	0f bd e8             	bsr    %eax,%ebp
  8020f3:	83 f5 1f             	xor    $0x1f,%ebp
  8020f6:	75 20                	jne    802118 <__umoddi3+0x98>
  8020f8:	39 d8                	cmp    %ebx,%eax
  8020fa:	0f 82 b0 00 00 00    	jb     8021b0 <__umoddi3+0x130>
  802100:	39 f7                	cmp    %esi,%edi
  802102:	0f 86 a8 00 00 00    	jbe    8021b0 <__umoddi3+0x130>
  802108:	89 c8                	mov    %ecx,%eax
  80210a:	83 c4 1c             	add    $0x1c,%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
  802112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802118:	89 e9                	mov    %ebp,%ecx
  80211a:	ba 20 00 00 00       	mov    $0x20,%edx
  80211f:	29 ea                	sub    %ebp,%edx
  802121:	d3 e0                	shl    %cl,%eax
  802123:	89 44 24 08          	mov    %eax,0x8(%esp)
  802127:	89 d1                	mov    %edx,%ecx
  802129:	89 f8                	mov    %edi,%eax
  80212b:	d3 e8                	shr    %cl,%eax
  80212d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802131:	89 54 24 04          	mov    %edx,0x4(%esp)
  802135:	8b 54 24 04          	mov    0x4(%esp),%edx
  802139:	09 c1                	or     %eax,%ecx
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802141:	89 e9                	mov    %ebp,%ecx
  802143:	d3 e7                	shl    %cl,%edi
  802145:	89 d1                	mov    %edx,%ecx
  802147:	d3 e8                	shr    %cl,%eax
  802149:	89 e9                	mov    %ebp,%ecx
  80214b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80214f:	d3 e3                	shl    %cl,%ebx
  802151:	89 c7                	mov    %eax,%edi
  802153:	89 d1                	mov    %edx,%ecx
  802155:	89 f0                	mov    %esi,%eax
  802157:	d3 e8                	shr    %cl,%eax
  802159:	89 e9                	mov    %ebp,%ecx
  80215b:	89 fa                	mov    %edi,%edx
  80215d:	d3 e6                	shl    %cl,%esi
  80215f:	09 d8                	or     %ebx,%eax
  802161:	f7 74 24 08          	divl   0x8(%esp)
  802165:	89 d1                	mov    %edx,%ecx
  802167:	89 f3                	mov    %esi,%ebx
  802169:	f7 64 24 0c          	mull   0xc(%esp)
  80216d:	89 c6                	mov    %eax,%esi
  80216f:	89 d7                	mov    %edx,%edi
  802171:	39 d1                	cmp    %edx,%ecx
  802173:	72 06                	jb     80217b <__umoddi3+0xfb>
  802175:	75 10                	jne    802187 <__umoddi3+0x107>
  802177:	39 c3                	cmp    %eax,%ebx
  802179:	73 0c                	jae    802187 <__umoddi3+0x107>
  80217b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80217f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802183:	89 d7                	mov    %edx,%edi
  802185:	89 c6                	mov    %eax,%esi
  802187:	89 ca                	mov    %ecx,%edx
  802189:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80218e:	29 f3                	sub    %esi,%ebx
  802190:	19 fa                	sbb    %edi,%edx
  802192:	89 d0                	mov    %edx,%eax
  802194:	d3 e0                	shl    %cl,%eax
  802196:	89 e9                	mov    %ebp,%ecx
  802198:	d3 eb                	shr    %cl,%ebx
  80219a:	d3 ea                	shr    %cl,%edx
  80219c:	09 d8                	or     %ebx,%eax
  80219e:	83 c4 1c             	add    $0x1c,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5f                   	pop    %edi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
  8021a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021ad:	8d 76 00             	lea    0x0(%esi),%esi
  8021b0:	89 da                	mov    %ebx,%edx
  8021b2:	29 fe                	sub    %edi,%esi
  8021b4:	19 c2                	sbb    %eax,%edx
  8021b6:	89 f1                	mov    %esi,%ecx
  8021b8:	89 c8                	mov    %ecx,%eax
  8021ba:	e9 4b ff ff ff       	jmp    80210a <__umoddi3+0x8a>
