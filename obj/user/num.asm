
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
  800054:	68 60 27 80 00       	push   $0x802760
  800059:	e8 25 1a 00 00       	call   801a83 <printf>
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
  800073:	e8 96 14 00 00       	call   80150e <write>
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
  80008d:	e8 b0 13 00 00       	call   801442 <read>
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
  8000ab:	68 65 27 80 00       	push   $0x802765
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 80 27 80 00       	push   $0x802780
  8000b7:	e8 81 01 00 00       	call   80023d <_panic>
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
  8000d8:	68 8b 27 80 00       	push   $0x80278b
  8000dd:	6a 18                	push   $0x18
  8000df:	68 80 27 80 00       	push   $0x802780
  8000e4:	e8 54 01 00 00       	call   80023d <_panic>

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
  8000f2:	c7 05 04 30 80 00 a0 	movl   $0x8027a0,0x803004
  8000f9:	27 80 00 
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
  80011c:	e8 bf 17 00 00       	call   8018e0 <open>
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
  800138:	e8 c7 11 00 00       	call   801304 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 a4 27 80 00       	push   $0x8027a4
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 c4 00 00 00       	call   800223 <exit>
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
  800170:	68 ac 27 80 00       	push   $0x8027ac
  800175:	6a 27                	push   $0x27
  800177:	68 80 27 80 00       	push   $0x802780
  80017c:	e8 bc 00 00 00       	call   80023d <_panic>

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
  80018a:	c7 05 0c 40 80 00 00 	movl   $0x0,0x80400c
  800191:	00 00 00 
	envid_t find = sys_getenvid();
  800194:	e8 ad 0c 00 00       	call   800e46 <sys_getenvid>
  800199:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
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
  8001e2:	89 1d 0c 40 80 00    	mov    %ebx,0x80400c
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

	cprintf("call umain!\n");
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	68 be 27 80 00       	push   $0x8027be
  800200:	e8 2e 01 00 00       	call   800333 <cprintf>
	// call user main routine
	umain(argc, argv);
  800205:	83 c4 08             	add    $0x8,%esp
  800208:	ff 75 0c             	pushl  0xc(%ebp)
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	e8 d6 fe ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  800213:	e8 0b 00 00 00       	call   800223 <exit>
}
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021e:	5b                   	pop    %ebx
  80021f:	5e                   	pop    %esi
  800220:	5f                   	pop    %edi
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800229:	e8 03 11 00 00       	call   801331 <close_all>
	sys_env_destroy(0);
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	6a 00                	push   $0x0
  800233:	e8 cd 0b 00 00       	call   800e05 <sys_env_destroy>
}
  800238:	83 c4 10             	add    $0x10,%esp
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800242:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800247:	8b 40 48             	mov    0x48(%eax),%eax
  80024a:	83 ec 04             	sub    $0x4,%esp
  80024d:	68 04 28 80 00       	push   $0x802804
  800252:	50                   	push   %eax
  800253:	68 d5 27 80 00       	push   $0x8027d5
  800258:	e8 d6 00 00 00       	call   800333 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80025d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800260:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800266:	e8 db 0b 00 00       	call   800e46 <sys_getenvid>
  80026b:	83 c4 04             	add    $0x4,%esp
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	56                   	push   %esi
  800275:	50                   	push   %eax
  800276:	68 e0 27 80 00       	push   $0x8027e0
  80027b:	e8 b3 00 00 00       	call   800333 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800280:	83 c4 18             	add    $0x18,%esp
  800283:	53                   	push   %ebx
  800284:	ff 75 10             	pushl  0x10(%ebp)
  800287:	e8 56 00 00 00       	call   8002e2 <vcprintf>
	cprintf("\n");
  80028c:	c7 04 24 c9 27 80 00 	movl   $0x8027c9,(%esp)
  800293:	e8 9b 00 00 00       	call   800333 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029b:	cc                   	int3   
  80029c:	eb fd                	jmp    80029b <_panic+0x5e>

0080029e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a8:	8b 13                	mov    (%ebx),%edx
  8002aa:	8d 42 01             	lea    0x1(%edx),%eax
  8002ad:	89 03                	mov    %eax,(%ebx)
  8002af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002bb:	74 09                	je     8002c6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002bd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002c6:	83 ec 08             	sub    $0x8,%esp
  8002c9:	68 ff 00 00 00       	push   $0xff
  8002ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d1:	50                   	push   %eax
  8002d2:	e8 f1 0a 00 00       	call   800dc8 <sys_cputs>
		b->idx = 0;
  8002d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	eb db                	jmp    8002bd <putch+0x1f>

008002e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f2:	00 00 00 
	b.cnt = 0;
  8002f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80030b:	50                   	push   %eax
  80030c:	68 9e 02 80 00       	push   $0x80029e
  800311:	e8 4a 01 00 00       	call   800460 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800316:	83 c4 08             	add    $0x8,%esp
  800319:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80031f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800325:	50                   	push   %eax
  800326:	e8 9d 0a 00 00       	call   800dc8 <sys_cputs>

	return b.cnt;
}
  80032b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800339:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033c:	50                   	push   %eax
  80033d:	ff 75 08             	pushl  0x8(%ebp)
  800340:	e8 9d ff ff ff       	call   8002e2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800345:	c9                   	leave  
  800346:	c3                   	ret    

00800347 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	57                   	push   %edi
  80034b:	56                   	push   %esi
  80034c:	53                   	push   %ebx
  80034d:	83 ec 1c             	sub    $0x1c,%esp
  800350:	89 c6                	mov    %eax,%esi
  800352:	89 d7                	mov    %edx,%edi
  800354:	8b 45 08             	mov    0x8(%ebp),%eax
  800357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800360:	8b 45 10             	mov    0x10(%ebp),%eax
  800363:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800366:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80036a:	74 2c                	je     800398 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800376:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800379:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80037c:	39 c2                	cmp    %eax,%edx
  80037e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800381:	73 43                	jae    8003c6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800383:	83 eb 01             	sub    $0x1,%ebx
  800386:	85 db                	test   %ebx,%ebx
  800388:	7e 6c                	jle    8003f6 <printnum+0xaf>
				putch(padc, putdat);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	57                   	push   %edi
  80038e:	ff 75 18             	pushl  0x18(%ebp)
  800391:	ff d6                	call   *%esi
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	eb eb                	jmp    800383 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	6a 20                	push   $0x20
  80039d:	6a 00                	push   $0x0
  80039f:	50                   	push   %eax
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a6:	89 fa                	mov    %edi,%edx
  8003a8:	89 f0                	mov    %esi,%eax
  8003aa:	e8 98 ff ff ff       	call   800347 <printnum>
		while (--width > 0)
  8003af:	83 c4 20             	add    $0x20,%esp
  8003b2:	83 eb 01             	sub    $0x1,%ebx
  8003b5:	85 db                	test   %ebx,%ebx
  8003b7:	7e 65                	jle    80041e <printnum+0xd7>
			putch(padc, putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	57                   	push   %edi
  8003bd:	6a 20                	push   $0x20
  8003bf:	ff d6                	call   *%esi
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	eb ec                	jmp    8003b2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	ff 75 18             	pushl  0x18(%ebp)
  8003cc:	83 eb 01             	sub    $0x1,%ebx
  8003cf:	53                   	push   %ebx
  8003d0:	50                   	push   %eax
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8003da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e0:	e8 1b 21 00 00       	call   802500 <__udivdi3>
  8003e5:	83 c4 18             	add    $0x18,%esp
  8003e8:	52                   	push   %edx
  8003e9:	50                   	push   %eax
  8003ea:	89 fa                	mov    %edi,%edx
  8003ec:	89 f0                	mov    %esi,%eax
  8003ee:	e8 54 ff ff ff       	call   800347 <printnum>
  8003f3:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	57                   	push   %edi
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	ff 75 dc             	pushl  -0x24(%ebp)
  800400:	ff 75 d8             	pushl  -0x28(%ebp)
  800403:	ff 75 e4             	pushl  -0x1c(%ebp)
  800406:	ff 75 e0             	pushl  -0x20(%ebp)
  800409:	e8 02 22 00 00       	call   802610 <__umoddi3>
  80040e:	83 c4 14             	add    $0x14,%esp
  800411:	0f be 80 0b 28 80 00 	movsbl 0x80280b(%eax),%eax
  800418:	50                   	push   %eax
  800419:	ff d6                	call   *%esi
  80041b:	83 c4 10             	add    $0x10,%esp
	}
}
  80041e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80042c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800430:	8b 10                	mov    (%eax),%edx
  800432:	3b 50 04             	cmp    0x4(%eax),%edx
  800435:	73 0a                	jae    800441 <sprintputch+0x1b>
		*b->buf++ = ch;
  800437:	8d 4a 01             	lea    0x1(%edx),%ecx
  80043a:	89 08                	mov    %ecx,(%eax)
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	88 02                	mov    %al,(%edx)
}
  800441:	5d                   	pop    %ebp
  800442:	c3                   	ret    

00800443 <printfmt>:
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800449:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80044c:	50                   	push   %eax
  80044d:	ff 75 10             	pushl  0x10(%ebp)
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	ff 75 08             	pushl  0x8(%ebp)
  800456:	e8 05 00 00 00       	call   800460 <vprintfmt>
}
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <vprintfmt>:
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 3c             	sub    $0x3c,%esp
  800469:	8b 75 08             	mov    0x8(%ebp),%esi
  80046c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80046f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800472:	e9 32 04 00 00       	jmp    8008a9 <vprintfmt+0x449>
		padc = ' ';
  800477:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80047b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800482:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800489:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800490:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800497:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80049e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	8d 47 01             	lea    0x1(%edi),%eax
  8004a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004a9:	0f b6 17             	movzbl (%edi),%edx
  8004ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004af:	3c 55                	cmp    $0x55,%al
  8004b1:	0f 87 12 05 00 00    	ja     8009c9 <vprintfmt+0x569>
  8004b7:	0f b6 c0             	movzbl %al,%eax
  8004ba:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004c4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004c8:	eb d9                	jmp    8004a3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004cd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004d1:	eb d0                	jmp    8004a3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	0f b6 d2             	movzbl %dl,%edx
  8004d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004de:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e1:	eb 03                	jmp    8004e6 <vprintfmt+0x86>
  8004e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004e9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ed:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004f0:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f3:	83 fe 09             	cmp    $0x9,%esi
  8004f6:	76 eb                	jbe    8004e3 <vprintfmt+0x83>
  8004f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fe:	eb 14                	jmp    800514 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800500:	8b 45 14             	mov    0x14(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8d 40 04             	lea    0x4(%eax),%eax
  80050e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800511:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800514:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800518:	79 89                	jns    8004a3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80051a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80051d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800520:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800527:	e9 77 ff ff ff       	jmp    8004a3 <vprintfmt+0x43>
  80052c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80052f:	85 c0                	test   %eax,%eax
  800531:	0f 48 c1             	cmovs  %ecx,%eax
  800534:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80053a:	e9 64 ff ff ff       	jmp    8004a3 <vprintfmt+0x43>
  80053f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800542:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800549:	e9 55 ff ff ff       	jmp    8004a3 <vprintfmt+0x43>
			lflag++;
  80054e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800555:	e9 49 ff ff ff       	jmp    8004a3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8d 78 04             	lea    0x4(%eax),%edi
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	ff 30                	pushl  (%eax)
  800566:	ff d6                	call   *%esi
			break;
  800568:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80056b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80056e:	e9 33 03 00 00       	jmp    8008a6 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	8d 78 04             	lea    0x4(%eax),%edi
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	99                   	cltd   
  80057c:	31 d0                	xor    %edx,%eax
  80057e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800580:	83 f8 10             	cmp    $0x10,%eax
  800583:	7f 23                	jg     8005a8 <vprintfmt+0x148>
  800585:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  80058c:	85 d2                	test   %edx,%edx
  80058e:	74 18                	je     8005a8 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800590:	52                   	push   %edx
  800591:	68 5d 2c 80 00       	push   $0x802c5d
  800596:	53                   	push   %ebx
  800597:	56                   	push   %esi
  800598:	e8 a6 fe ff ff       	call   800443 <printfmt>
  80059d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a3:	e9 fe 02 00 00       	jmp    8008a6 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005a8:	50                   	push   %eax
  8005a9:	68 23 28 80 00       	push   $0x802823
  8005ae:	53                   	push   %ebx
  8005af:	56                   	push   %esi
  8005b0:	e8 8e fe ff ff       	call   800443 <printfmt>
  8005b5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005bb:	e9 e6 02 00 00       	jmp    8008a6 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c3:	83 c0 04             	add    $0x4,%eax
  8005c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005ce:	85 c9                	test   %ecx,%ecx
  8005d0:	b8 1c 28 80 00       	mov    $0x80281c,%eax
  8005d5:	0f 45 c1             	cmovne %ecx,%eax
  8005d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005df:	7e 06                	jle    8005e7 <vprintfmt+0x187>
  8005e1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005e5:	75 0d                	jne    8005f4 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005ea:	89 c7                	mov    %eax,%edi
  8005ec:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f2:	eb 53                	jmp    800647 <vprintfmt+0x1e7>
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8005fa:	50                   	push   %eax
  8005fb:	e8 71 04 00 00       	call   800a71 <strnlen>
  800600:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800603:	29 c1                	sub    %eax,%ecx
  800605:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80060d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800611:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800614:	eb 0f                	jmp    800625 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	53                   	push   %ebx
  80061a:	ff 75 e0             	pushl  -0x20(%ebp)
  80061d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80061f:	83 ef 01             	sub    $0x1,%edi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	85 ff                	test   %edi,%edi
  800627:	7f ed                	jg     800616 <vprintfmt+0x1b6>
  800629:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	b8 00 00 00 00       	mov    $0x0,%eax
  800633:	0f 49 c1             	cmovns %ecx,%eax
  800636:	29 c1                	sub    %eax,%ecx
  800638:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80063b:	eb aa                	jmp    8005e7 <vprintfmt+0x187>
					putch(ch, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	52                   	push   %edx
  800642:	ff d6                	call   *%esi
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80064a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80064c:	83 c7 01             	add    $0x1,%edi
  80064f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800653:	0f be d0             	movsbl %al,%edx
  800656:	85 d2                	test   %edx,%edx
  800658:	74 4b                	je     8006a5 <vprintfmt+0x245>
  80065a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065e:	78 06                	js     800666 <vprintfmt+0x206>
  800660:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800664:	78 1e                	js     800684 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800666:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80066a:	74 d1                	je     80063d <vprintfmt+0x1dd>
  80066c:	0f be c0             	movsbl %al,%eax
  80066f:	83 e8 20             	sub    $0x20,%eax
  800672:	83 f8 5e             	cmp    $0x5e,%eax
  800675:	76 c6                	jbe    80063d <vprintfmt+0x1dd>
					putch('?', putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	6a 3f                	push   $0x3f
  80067d:	ff d6                	call   *%esi
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	eb c3                	jmp    800647 <vprintfmt+0x1e7>
  800684:	89 cf                	mov    %ecx,%edi
  800686:	eb 0e                	jmp    800696 <vprintfmt+0x236>
				putch(' ', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 20                	push   $0x20
  80068e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800690:	83 ef 01             	sub    $0x1,%edi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	85 ff                	test   %edi,%edi
  800698:	7f ee                	jg     800688 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80069a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a0:	e9 01 02 00 00       	jmp    8008a6 <vprintfmt+0x446>
  8006a5:	89 cf                	mov    %ecx,%edi
  8006a7:	eb ed                	jmp    800696 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006ac:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b3:	e9 eb fd ff ff       	jmp    8004a3 <vprintfmt+0x43>
	if (lflag >= 2)
  8006b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006bc:	7f 21                	jg     8006df <vprintfmt+0x27f>
	else if (lflag)
  8006be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c2:	74 68                	je     80072c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006cc:	89 c1                	mov    %eax,%ecx
  8006ce:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
  8006dd:	eb 17                	jmp    8006f6 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 50 04             	mov    0x4(%eax),%edx
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800702:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800706:	78 3f                	js     800747 <vprintfmt+0x2e7>
			base = 10;
  800708:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80070d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800711:	0f 84 71 01 00 00    	je     800888 <vprintfmt+0x428>
				putch('+', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 2b                	push   $0x2b
  80071d:	ff d6                	call   *%esi
  80071f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800722:	b8 0a 00 00 00       	mov    $0xa,%eax
  800727:	e9 5c 01 00 00       	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800734:	89 c1                	mov    %eax,%ecx
  800736:	c1 f9 1f             	sar    $0x1f,%ecx
  800739:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
  800745:	eb af                	jmp    8006f6 <vprintfmt+0x296>
				putch('-', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	6a 2d                	push   $0x2d
  80074d:	ff d6                	call   *%esi
				num = -(long long) num;
  80074f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800752:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800755:	f7 d8                	neg    %eax
  800757:	83 d2 00             	adc    $0x0,%edx
  80075a:	f7 da                	neg    %edx
  80075c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800762:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800765:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076a:	e9 19 01 00 00       	jmp    800888 <vprintfmt+0x428>
	if (lflag >= 2)
  80076f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800773:	7f 29                	jg     80079e <vprintfmt+0x33e>
	else if (lflag)
  800775:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800779:	74 44                	je     8007bf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800794:	b8 0a 00 00 00       	mov    $0xa,%eax
  800799:	e9 ea 00 00 00       	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8b 50 04             	mov    0x4(%eax),%edx
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8d 40 08             	lea    0x8(%eax),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ba:	e9 c9 00 00 00       	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 04             	lea    0x4(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007dd:	e9 a6 00 00 00       	jmp    800888 <vprintfmt+0x428>
			putch('0', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	53                   	push   %ebx
  8007e6:	6a 30                	push   $0x30
  8007e8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007ea:	83 c4 10             	add    $0x10,%esp
  8007ed:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f1:	7f 26                	jg     800819 <vprintfmt+0x3b9>
	else if (lflag)
  8007f3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f7:	74 3e                	je     800837 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800812:	b8 08 00 00 00       	mov    $0x8,%eax
  800817:	eb 6f                	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800824:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	8d 40 08             	lea    0x8(%eax),%eax
  80082d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800830:	b8 08 00 00 00       	mov    $0x8,%eax
  800835:	eb 51                	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	ba 00 00 00 00       	mov    $0x0,%edx
  800841:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800844:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	8d 40 04             	lea    0x4(%eax),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800850:	b8 08 00 00 00       	mov    $0x8,%eax
  800855:	eb 31                	jmp    800888 <vprintfmt+0x428>
			putch('0', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 30                	push   $0x30
  80085d:	ff d6                	call   *%esi
			putch('x', putdat);
  80085f:	83 c4 08             	add    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 78                	push   $0x78
  800865:	ff d6                	call   *%esi
			num = (unsigned long long)
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	ba 00 00 00 00       	mov    $0x0,%edx
  800871:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800874:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800877:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8d 40 04             	lea    0x4(%eax),%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800883:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800888:	83 ec 0c             	sub    $0xc,%esp
  80088b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80088f:	52                   	push   %edx
  800890:	ff 75 e0             	pushl  -0x20(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 dc             	pushl  -0x24(%ebp)
  800897:	ff 75 d8             	pushl  -0x28(%ebp)
  80089a:	89 da                	mov    %ebx,%edx
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	e8 a4 fa ff ff       	call   800347 <printnum>
			break;
  8008a3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	83 c7 01             	add    $0x1,%edi
  8008ac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b0:	83 f8 25             	cmp    $0x25,%eax
  8008b3:	0f 84 be fb ff ff    	je     800477 <vprintfmt+0x17>
			if (ch == '\0')
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	0f 84 28 01 00 00    	je     8009e9 <vprintfmt+0x589>
			putch(ch, putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	53                   	push   %ebx
  8008c5:	50                   	push   %eax
  8008c6:	ff d6                	call   *%esi
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	eb dc                	jmp    8008a9 <vprintfmt+0x449>
	if (lflag >= 2)
  8008cd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008d1:	7f 26                	jg     8008f9 <vprintfmt+0x499>
	else if (lflag)
  8008d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008d7:	74 41                	je     80091a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	8d 40 04             	lea    0x4(%eax),%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f2:	b8 10 00 00 00       	mov    $0x10,%eax
  8008f7:	eb 8f                	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	8b 50 04             	mov    0x4(%eax),%edx
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800904:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	8d 40 08             	lea    0x8(%eax),%eax
  80090d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800910:	b8 10 00 00 00       	mov    $0x10,%eax
  800915:	e9 6e ff ff ff       	jmp    800888 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
  800924:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800927:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8d 40 04             	lea    0x4(%eax),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800933:	b8 10 00 00 00       	mov    $0x10,%eax
  800938:	e9 4b ff ff ff       	jmp    800888 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80093d:	8b 45 14             	mov    0x14(%ebp),%eax
  800940:	83 c0 04             	add    $0x4,%eax
  800943:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	85 c0                	test   %eax,%eax
  80094d:	74 14                	je     800963 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80094f:	8b 13                	mov    (%ebx),%edx
  800951:	83 fa 7f             	cmp    $0x7f,%edx
  800954:	7f 37                	jg     80098d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800956:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800958:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095b:	89 45 14             	mov    %eax,0x14(%ebp)
  80095e:	e9 43 ff ff ff       	jmp    8008a6 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800963:	b8 0a 00 00 00       	mov    $0xa,%eax
  800968:	bf 41 29 80 00       	mov    $0x802941,%edi
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
  800980:	75 eb                	jne    80096d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800982:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	e9 19 ff ff ff       	jmp    8008a6 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80098d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80098f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800994:	bf 79 29 80 00       	mov    $0x802979,%edi
							putch(ch, putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	53                   	push   %ebx
  80099d:	50                   	push   %eax
  80099e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009a0:	83 c7 01             	add    $0x1,%edi
  8009a3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	85 c0                	test   %eax,%eax
  8009ac:	75 eb                	jne    800999 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b4:	e9 ed fe ff ff       	jmp    8008a6 <vprintfmt+0x446>
			putch(ch, putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	53                   	push   %ebx
  8009bd:	6a 25                	push   $0x25
  8009bf:	ff d6                	call   *%esi
			break;
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	e9 dd fe ff ff       	jmp    8008a6 <vprintfmt+0x446>
			putch('%', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	53                   	push   %ebx
  8009cd:	6a 25                	push   $0x25
  8009cf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	89 f8                	mov    %edi,%eax
  8009d6:	eb 03                	jmp    8009db <vprintfmt+0x57b>
  8009d8:	83 e8 01             	sub    $0x1,%eax
  8009db:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009df:	75 f7                	jne    8009d8 <vprintfmt+0x578>
  8009e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009e4:	e9 bd fe ff ff       	jmp    8008a6 <vprintfmt+0x446>
}
  8009e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009ec:	5b                   	pop    %ebx
  8009ed:	5e                   	pop    %esi
  8009ee:	5f                   	pop    %edi
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	83 ec 18             	sub    $0x18,%esp
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a00:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a04:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a0e:	85 c0                	test   %eax,%eax
  800a10:	74 26                	je     800a38 <vsnprintf+0x47>
  800a12:	85 d2                	test   %edx,%edx
  800a14:	7e 22                	jle    800a38 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a16:	ff 75 14             	pushl  0x14(%ebp)
  800a19:	ff 75 10             	pushl  0x10(%ebp)
  800a1c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1f:	50                   	push   %eax
  800a20:	68 26 04 80 00       	push   $0x800426
  800a25:	e8 36 fa ff ff       	call   800460 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a33:	83 c4 10             	add    $0x10,%esp
}
  800a36:	c9                   	leave  
  800a37:	c3                   	ret    
		return -E_INVAL;
  800a38:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a3d:	eb f7                	jmp    800a36 <vsnprintf+0x45>

00800a3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a45:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a48:	50                   	push   %eax
  800a49:	ff 75 10             	pushl  0x10(%ebp)
  800a4c:	ff 75 0c             	pushl  0xc(%ebp)
  800a4f:	ff 75 08             	pushl  0x8(%ebp)
  800a52:	e8 9a ff ff ff       	call   8009f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a64:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a68:	74 05                	je     800a6f <strlen+0x16>
		n++;
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	eb f5                	jmp    800a64 <strlen+0xb>
	return n;
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7f:	39 c2                	cmp    %eax,%edx
  800a81:	74 0d                	je     800a90 <strnlen+0x1f>
  800a83:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a87:	74 05                	je     800a8e <strnlen+0x1d>
		n++;
  800a89:	83 c2 01             	add    $0x1,%edx
  800a8c:	eb f1                	jmp    800a7f <strnlen+0xe>
  800a8e:	89 d0                	mov    %edx,%eax
	return n;
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aa5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	84 c9                	test   %cl,%cl
  800aad:	75 f2                	jne    800aa1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 10             	sub    $0x10,%esp
  800ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800abc:	53                   	push   %ebx
  800abd:	e8 97 ff ff ff       	call   800a59 <strlen>
  800ac2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	01 d8                	add    %ebx,%eax
  800aca:	50                   	push   %eax
  800acb:	e8 c2 ff ff ff       	call   800a92 <strcpy>
	return dst;
}
  800ad0:	89 d8                	mov    %ebx,%eax
  800ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae2:	89 c6                	mov    %eax,%esi
  800ae4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae7:	89 c2                	mov    %eax,%edx
  800ae9:	39 f2                	cmp    %esi,%edx
  800aeb:	74 11                	je     800afe <strncpy+0x27>
		*dst++ = *src;
  800aed:	83 c2 01             	add    $0x1,%edx
  800af0:	0f b6 19             	movzbl (%ecx),%ebx
  800af3:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af6:	80 fb 01             	cmp    $0x1,%bl
  800af9:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800afc:	eb eb                	jmp    800ae9 <strncpy+0x12>
	}
	return ret;
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	56                   	push   %esi
  800b06:	53                   	push   %ebx
  800b07:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0d:	8b 55 10             	mov    0x10(%ebp),%edx
  800b10:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b12:	85 d2                	test   %edx,%edx
  800b14:	74 21                	je     800b37 <strlcpy+0x35>
  800b16:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b1a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b1c:	39 c2                	cmp    %eax,%edx
  800b1e:	74 14                	je     800b34 <strlcpy+0x32>
  800b20:	0f b6 19             	movzbl (%ecx),%ebx
  800b23:	84 db                	test   %bl,%bl
  800b25:	74 0b                	je     800b32 <strlcpy+0x30>
			*dst++ = *src++;
  800b27:	83 c1 01             	add    $0x1,%ecx
  800b2a:	83 c2 01             	add    $0x1,%edx
  800b2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b30:	eb ea                	jmp    800b1c <strlcpy+0x1a>
  800b32:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b37:	29 f0                	sub    %esi,%eax
}
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b43:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b46:	0f b6 01             	movzbl (%ecx),%eax
  800b49:	84 c0                	test   %al,%al
  800b4b:	74 0c                	je     800b59 <strcmp+0x1c>
  800b4d:	3a 02                	cmp    (%edx),%al
  800b4f:	75 08                	jne    800b59 <strcmp+0x1c>
		p++, q++;
  800b51:	83 c1 01             	add    $0x1,%ecx
  800b54:	83 c2 01             	add    $0x1,%edx
  800b57:	eb ed                	jmp    800b46 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b59:	0f b6 c0             	movzbl %al,%eax
  800b5c:	0f b6 12             	movzbl (%edx),%edx
  800b5f:	29 d0                	sub    %edx,%eax
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	53                   	push   %ebx
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6d:	89 c3                	mov    %eax,%ebx
  800b6f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b72:	eb 06                	jmp    800b7a <strncmp+0x17>
		n--, p++, q++;
  800b74:	83 c0 01             	add    $0x1,%eax
  800b77:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b7a:	39 d8                	cmp    %ebx,%eax
  800b7c:	74 16                	je     800b94 <strncmp+0x31>
  800b7e:	0f b6 08             	movzbl (%eax),%ecx
  800b81:	84 c9                	test   %cl,%cl
  800b83:	74 04                	je     800b89 <strncmp+0x26>
  800b85:	3a 0a                	cmp    (%edx),%cl
  800b87:	74 eb                	je     800b74 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b89:	0f b6 00             	movzbl (%eax),%eax
  800b8c:	0f b6 12             	movzbl (%edx),%edx
  800b8f:	29 d0                	sub    %edx,%eax
}
  800b91:	5b                   	pop    %ebx
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    
		return 0;
  800b94:	b8 00 00 00 00       	mov    $0x0,%eax
  800b99:	eb f6                	jmp    800b91 <strncmp+0x2e>

00800b9b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ba5:	0f b6 10             	movzbl (%eax),%edx
  800ba8:	84 d2                	test   %dl,%dl
  800baa:	74 09                	je     800bb5 <strchr+0x1a>
		if (*s == c)
  800bac:	38 ca                	cmp    %cl,%dl
  800bae:	74 0a                	je     800bba <strchr+0x1f>
	for (; *s; s++)
  800bb0:	83 c0 01             	add    $0x1,%eax
  800bb3:	eb f0                	jmp    800ba5 <strchr+0xa>
			return (char *) s;
	return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bc9:	38 ca                	cmp    %cl,%dl
  800bcb:	74 09                	je     800bd6 <strfind+0x1a>
  800bcd:	84 d2                	test   %dl,%dl
  800bcf:	74 05                	je     800bd6 <strfind+0x1a>
	for (; *s; s++)
  800bd1:	83 c0 01             	add    $0x1,%eax
  800bd4:	eb f0                	jmp    800bc6 <strfind+0xa>
			break;
	return (char *) s;
}
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
  800bde:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800be4:	85 c9                	test   %ecx,%ecx
  800be6:	74 31                	je     800c19 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800be8:	89 f8                	mov    %edi,%eax
  800bea:	09 c8                	or     %ecx,%eax
  800bec:	a8 03                	test   $0x3,%al
  800bee:	75 23                	jne    800c13 <memset+0x3b>
		c &= 0xFF;
  800bf0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bf4:	89 d3                	mov    %edx,%ebx
  800bf6:	c1 e3 08             	shl    $0x8,%ebx
  800bf9:	89 d0                	mov    %edx,%eax
  800bfb:	c1 e0 18             	shl    $0x18,%eax
  800bfe:	89 d6                	mov    %edx,%esi
  800c00:	c1 e6 10             	shl    $0x10,%esi
  800c03:	09 f0                	or     %esi,%eax
  800c05:	09 c2                	or     %eax,%edx
  800c07:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c09:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	fc                   	cld    
  800c0f:	f3 ab                	rep stos %eax,%es:(%edi)
  800c11:	eb 06                	jmp    800c19 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	fc                   	cld    
  800c17:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c19:	89 f8                	mov    %edi,%eax
  800c1b:	5b                   	pop    %ebx
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c2e:	39 c6                	cmp    %eax,%esi
  800c30:	73 32                	jae    800c64 <memmove+0x44>
  800c32:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c35:	39 c2                	cmp    %eax,%edx
  800c37:	76 2b                	jbe    800c64 <memmove+0x44>
		s += n;
		d += n;
  800c39:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c3c:	89 fe                	mov    %edi,%esi
  800c3e:	09 ce                	or     %ecx,%esi
  800c40:	09 d6                	or     %edx,%esi
  800c42:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c48:	75 0e                	jne    800c58 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c4a:	83 ef 04             	sub    $0x4,%edi
  800c4d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c50:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c53:	fd                   	std    
  800c54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c56:	eb 09                	jmp    800c61 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c58:	83 ef 01             	sub    $0x1,%edi
  800c5b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c5e:	fd                   	std    
  800c5f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c61:	fc                   	cld    
  800c62:	eb 1a                	jmp    800c7e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	09 ca                	or     %ecx,%edx
  800c68:	09 f2                	or     %esi,%edx
  800c6a:	f6 c2 03             	test   $0x3,%dl
  800c6d:	75 0a                	jne    800c79 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c6f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c72:	89 c7                	mov    %eax,%edi
  800c74:	fc                   	cld    
  800c75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c77:	eb 05                	jmp    800c7e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c79:	89 c7                	mov    %eax,%edi
  800c7b:	fc                   	cld    
  800c7c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	ff 75 08             	pushl  0x8(%ebp)
  800c91:	e8 8a ff ff ff       	call   800c20 <memmove>
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca3:	89 c6                	mov    %eax,%esi
  800ca5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca8:	39 f0                	cmp    %esi,%eax
  800caa:	74 1c                	je     800cc8 <memcmp+0x30>
		if (*s1 != *s2)
  800cac:	0f b6 08             	movzbl (%eax),%ecx
  800caf:	0f b6 1a             	movzbl (%edx),%ebx
  800cb2:	38 d9                	cmp    %bl,%cl
  800cb4:	75 08                	jne    800cbe <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cb6:	83 c0 01             	add    $0x1,%eax
  800cb9:	83 c2 01             	add    $0x1,%edx
  800cbc:	eb ea                	jmp    800ca8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cbe:	0f b6 c1             	movzbl %cl,%eax
  800cc1:	0f b6 db             	movzbl %bl,%ebx
  800cc4:	29 d8                	sub    %ebx,%eax
  800cc6:	eb 05                	jmp    800ccd <memcmp+0x35>
	}

	return 0;
  800cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cda:	89 c2                	mov    %eax,%edx
  800cdc:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cdf:	39 d0                	cmp    %edx,%eax
  800ce1:	73 09                	jae    800cec <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce3:	38 08                	cmp    %cl,(%eax)
  800ce5:	74 05                	je     800cec <memfind+0x1b>
	for (; s < ends; s++)
  800ce7:	83 c0 01             	add    $0x1,%eax
  800cea:	eb f3                	jmp    800cdf <memfind+0xe>
			break;
	return (void *) s;
}
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cfa:	eb 03                	jmp    800cff <strtol+0x11>
		s++;
  800cfc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cff:	0f b6 01             	movzbl (%ecx),%eax
  800d02:	3c 20                	cmp    $0x20,%al
  800d04:	74 f6                	je     800cfc <strtol+0xe>
  800d06:	3c 09                	cmp    $0x9,%al
  800d08:	74 f2                	je     800cfc <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d0a:	3c 2b                	cmp    $0x2b,%al
  800d0c:	74 2a                	je     800d38 <strtol+0x4a>
	int neg = 0;
  800d0e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d13:	3c 2d                	cmp    $0x2d,%al
  800d15:	74 2b                	je     800d42 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d17:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d1d:	75 0f                	jne    800d2e <strtol+0x40>
  800d1f:	80 39 30             	cmpb   $0x30,(%ecx)
  800d22:	74 28                	je     800d4c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d24:	85 db                	test   %ebx,%ebx
  800d26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2b:	0f 44 d8             	cmove  %eax,%ebx
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d36:	eb 50                	jmp    800d88 <strtol+0x9a>
		s++;
  800d38:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d40:	eb d5                	jmp    800d17 <strtol+0x29>
		s++, neg = 1;
  800d42:	83 c1 01             	add    $0x1,%ecx
  800d45:	bf 01 00 00 00       	mov    $0x1,%edi
  800d4a:	eb cb                	jmp    800d17 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d50:	74 0e                	je     800d60 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	75 d8                	jne    800d2e <strtol+0x40>
		s++, base = 8;
  800d56:	83 c1 01             	add    $0x1,%ecx
  800d59:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d5e:	eb ce                	jmp    800d2e <strtol+0x40>
		s += 2, base = 16;
  800d60:	83 c1 02             	add    $0x2,%ecx
  800d63:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d68:	eb c4                	jmp    800d2e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d6a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6d:	89 f3                	mov    %esi,%ebx
  800d6f:	80 fb 19             	cmp    $0x19,%bl
  800d72:	77 29                	ja     800d9d <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d74:	0f be d2             	movsbl %dl,%edx
  800d77:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d7a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d7d:	7d 30                	jge    800daf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d7f:	83 c1 01             	add    $0x1,%ecx
  800d82:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d86:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d88:	0f b6 11             	movzbl (%ecx),%edx
  800d8b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d8e:	89 f3                	mov    %esi,%ebx
  800d90:	80 fb 09             	cmp    $0x9,%bl
  800d93:	77 d5                	ja     800d6a <strtol+0x7c>
			dig = *s - '0';
  800d95:	0f be d2             	movsbl %dl,%edx
  800d98:	83 ea 30             	sub    $0x30,%edx
  800d9b:	eb dd                	jmp    800d7a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d9d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800da0:	89 f3                	mov    %esi,%ebx
  800da2:	80 fb 19             	cmp    $0x19,%bl
  800da5:	77 08                	ja     800daf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800da7:	0f be d2             	movsbl %dl,%edx
  800daa:	83 ea 37             	sub    $0x37,%edx
  800dad:	eb cb                	jmp    800d7a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db3:	74 05                	je     800dba <strtol+0xcc>
		*endptr = (char *) s;
  800db5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dba:	89 c2                	mov    %eax,%edx
  800dbc:	f7 da                	neg    %edx
  800dbe:	85 ff                	test   %edi,%edi
  800dc0:	0f 45 c2             	cmovne %edx,%eax
}
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    

00800dc8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	89 c3                	mov    %eax,%ebx
  800ddb:	89 c7                	mov    %eax,%edi
  800ddd:	89 c6                	mov    %eax,%esi
  800ddf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dec:	ba 00 00 00 00       	mov    $0x0,%edx
  800df1:	b8 01 00 00 00       	mov    $0x1,%eax
  800df6:	89 d1                	mov    %edx,%ecx
  800df8:	89 d3                	mov    %edx,%ebx
  800dfa:	89 d7                	mov    %edx,%edi
  800dfc:	89 d6                	mov    %edx,%esi
  800dfe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	b8 03 00 00 00       	mov    $0x3,%eax
  800e1b:	89 cb                	mov    %ecx,%ebx
  800e1d:	89 cf                	mov    %ecx,%edi
  800e1f:	89 ce                	mov    %ecx,%esi
  800e21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7f 08                	jg     800e2f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	50                   	push   %eax
  800e33:	6a 03                	push   $0x3
  800e35:	68 84 2b 80 00       	push   $0x802b84
  800e3a:	6a 43                	push   $0x43
  800e3c:	68 a1 2b 80 00       	push   $0x802ba1
  800e41:	e8 f7 f3 ff ff       	call   80023d <_panic>

00800e46 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e51:	b8 02 00 00 00       	mov    $0x2,%eax
  800e56:	89 d1                	mov    %edx,%ecx
  800e58:	89 d3                	mov    %edx,%ebx
  800e5a:	89 d7                	mov    %edx,%edi
  800e5c:	89 d6                	mov    %edx,%esi
  800e5e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_yield>:

void
sys_yield(void)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e70:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e75:	89 d1                	mov    %edx,%ecx
  800e77:	89 d3                	mov    %edx,%ebx
  800e79:	89 d7                	mov    %edx,%edi
  800e7b:	89 d6                	mov    %edx,%esi
  800e7d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5f                   	pop    %edi
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    

00800e84 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	57                   	push   %edi
  800e88:	56                   	push   %esi
  800e89:	53                   	push   %ebx
  800e8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	b8 04 00 00 00       	mov    $0x4,%eax
  800e9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea0:	89 f7                	mov    %esi,%edi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 04                	push   $0x4
  800eb6:	68 84 2b 80 00       	push   $0x802b84
  800ebb:	6a 43                	push   $0x43
  800ebd:	68 a1 2b 80 00       	push   $0x802ba1
  800ec2:	e8 76 f3 ff ff       	call   80023d <_panic>

00800ec7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
  800ecd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed6:	b8 05 00 00 00       	mov    $0x5,%eax
  800edb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ede:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ee4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7f 08                	jg     800ef2 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eed:	5b                   	pop    %ebx
  800eee:	5e                   	pop    %esi
  800eef:	5f                   	pop    %edi
  800ef0:	5d                   	pop    %ebp
  800ef1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef2:	83 ec 0c             	sub    $0xc,%esp
  800ef5:	50                   	push   %eax
  800ef6:	6a 05                	push   $0x5
  800ef8:	68 84 2b 80 00       	push   $0x802b84
  800efd:	6a 43                	push   $0x43
  800eff:	68 a1 2b 80 00       	push   $0x802ba1
  800f04:	e8 34 f3 ff ff       	call   80023d <_panic>

00800f09 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	b8 06 00 00 00       	mov    $0x6,%eax
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 06                	push   $0x6
  800f3a:	68 84 2b 80 00       	push   $0x802b84
  800f3f:	6a 43                	push   $0x43
  800f41:	68 a1 2b 80 00       	push   $0x802ba1
  800f46:	e8 f2 f2 ff ff       	call   80023d <_panic>

00800f4b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
  800f51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5f:	b8 08 00 00 00       	mov    $0x8,%eax
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	7f 08                	jg     800f76 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	50                   	push   %eax
  800f7a:	6a 08                	push   $0x8
  800f7c:	68 84 2b 80 00       	push   $0x802b84
  800f81:	6a 43                	push   $0x43
  800f83:	68 a1 2b 80 00       	push   $0x802ba1
  800f88:	e8 b0 f2 ff ff       	call   80023d <_panic>

00800f8d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7f 08                	jg     800fb8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	50                   	push   %eax
  800fbc:	6a 09                	push   $0x9
  800fbe:	68 84 2b 80 00       	push   $0x802b84
  800fc3:	6a 43                	push   $0x43
  800fc5:	68 a1 2b 80 00       	push   $0x802ba1
  800fca:	e8 6e f2 ff ff       	call   80023d <_panic>

00800fcf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fe8:	89 df                	mov    %ebx,%edi
  800fea:	89 de                	mov    %ebx,%esi
  800fec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	7f 08                	jg     800ffa <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	50                   	push   %eax
  800ffe:	6a 0a                	push   $0xa
  801000:	68 84 2b 80 00       	push   $0x802b84
  801005:	6a 43                	push   $0x43
  801007:	68 a1 2b 80 00       	push   $0x802ba1
  80100c:	e8 2c f2 ff ff       	call   80023d <_panic>

00801011 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
	asm volatile("int %1\n"
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801022:	be 00 00 00 00       	mov    $0x0,%esi
  801027:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80102a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
  80103a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801042:	8b 55 08             	mov    0x8(%ebp),%edx
  801045:	b8 0d 00 00 00       	mov    $0xd,%eax
  80104a:	89 cb                	mov    %ecx,%ebx
  80104c:	89 cf                	mov    %ecx,%edi
  80104e:	89 ce                	mov    %ecx,%esi
  801050:	cd 30                	int    $0x30
	if(check && ret > 0)
  801052:	85 c0                	test   %eax,%eax
  801054:	7f 08                	jg     80105e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	50                   	push   %eax
  801062:	6a 0d                	push   $0xd
  801064:	68 84 2b 80 00       	push   $0x802b84
  801069:	6a 43                	push   $0x43
  80106b:	68 a1 2b 80 00       	push   $0x802ba1
  801070:	e8 c8 f1 ff ff       	call   80023d <_panic>

00801075 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801086:	b8 0e 00 00 00       	mov    $0xe,%eax
  80108b:	89 df                	mov    %ebx,%edi
  80108d:	89 de                	mov    %ebx,%esi
  80108f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    

00801096 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	57                   	push   %edi
  80109a:	56                   	push   %esi
  80109b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80109c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010a9:	89 cb                	mov    %ecx,%ebx
  8010ab:	89 cf                	mov    %ecx,%edi
  8010ad:	89 ce                	mov    %ecx,%esi
  8010af:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c1:	b8 10 00 00 00       	mov    $0x10,%eax
  8010c6:	89 d1                	mov    %edx,%ecx
  8010c8:	89 d3                	mov    %edx,%ebx
  8010ca:	89 d7                	mov    %edx,%edi
  8010cc:	89 d6                	mov    %edx,%esi
  8010ce:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	57                   	push   %edi
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e6:	b8 11 00 00 00       	mov    $0x11,%eax
  8010eb:	89 df                	mov    %ebx,%edi
  8010ed:	89 de                	mov    %ebx,%esi
  8010ef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801107:	b8 12 00 00 00       	mov    $0x12,%eax
  80110c:	89 df                	mov    %ebx,%edi
  80110e:	89 de                	mov    %ebx,%esi
  801110:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
  80111d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801120:	bb 00 00 00 00       	mov    $0x0,%ebx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	b8 13 00 00 00       	mov    $0x13,%eax
  801130:	89 df                	mov    %ebx,%edi
  801132:	89 de                	mov    %ebx,%esi
  801134:	cd 30                	int    $0x30
	if(check && ret > 0)
  801136:	85 c0                	test   %eax,%eax
  801138:	7f 08                	jg     801142 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80113a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5f                   	pop    %edi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	50                   	push   %eax
  801146:	6a 13                	push   $0x13
  801148:	68 84 2b 80 00       	push   $0x802b84
  80114d:	6a 43                	push   $0x43
  80114f:	68 a1 2b 80 00       	push   $0x802ba1
  801154:	e8 e4 f0 ff ff       	call   80023d <_panic>

00801159 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	05 00 00 00 30       	add    $0x30000000,%eax
  801164:	c1 e8 0c             	shr    $0xc,%eax
}
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801174:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801179:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801188:	89 c2                	mov    %eax,%edx
  80118a:	c1 ea 16             	shr    $0x16,%edx
  80118d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801194:	f6 c2 01             	test   $0x1,%dl
  801197:	74 2d                	je     8011c6 <fd_alloc+0x46>
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 0c             	shr    $0xc,%edx
  80119e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a5:	f6 c2 01             	test   $0x1,%dl
  8011a8:	74 1c                	je     8011c6 <fd_alloc+0x46>
  8011aa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011af:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011b4:	75 d2                	jne    801188 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011c4:	eb 0a                	jmp    8011d0 <fd_alloc+0x50>
			*fd_store = fd;
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    

008011d2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d8:	83 f8 1f             	cmp    $0x1f,%eax
  8011db:	77 30                	ja     80120d <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011dd:	c1 e0 0c             	shl    $0xc,%eax
  8011e0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011e5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011eb:	f6 c2 01             	test   $0x1,%dl
  8011ee:	74 24                	je     801214 <fd_lookup+0x42>
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	c1 ea 0c             	shr    $0xc,%edx
  8011f5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011fc:	f6 c2 01             	test   $0x1,%dl
  8011ff:	74 1a                	je     80121b <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801201:	8b 55 0c             	mov    0xc(%ebp),%edx
  801204:	89 02                	mov    %eax,(%edx)
	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    
		return -E_INVAL;
  80120d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801212:	eb f7                	jmp    80120b <fd_lookup+0x39>
		return -E_INVAL;
  801214:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801219:	eb f0                	jmp    80120b <fd_lookup+0x39>
  80121b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801220:	eb e9                	jmp    80120b <fd_lookup+0x39>

00801222 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80122b:	ba 00 00 00 00       	mov    $0x0,%edx
  801230:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801235:	39 08                	cmp    %ecx,(%eax)
  801237:	74 38                	je     801271 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801239:	83 c2 01             	add    $0x1,%edx
  80123c:	8b 04 95 30 2c 80 00 	mov    0x802c30(,%edx,4),%eax
  801243:	85 c0                	test   %eax,%eax
  801245:	75 ee                	jne    801235 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801247:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80124c:	8b 40 48             	mov    0x48(%eax),%eax
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	51                   	push   %ecx
  801253:	50                   	push   %eax
  801254:	68 b0 2b 80 00       	push   $0x802bb0
  801259:	e8 d5 f0 ff ff       	call   800333 <cprintf>
	*dev = 0;
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    
			*dev = devtab[i];
  801271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801274:	89 01                	mov    %eax,(%ecx)
			return 0;
  801276:	b8 00 00 00 00       	mov    $0x0,%eax
  80127b:	eb f2                	jmp    80126f <dev_lookup+0x4d>

0080127d <fd_close>:
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 24             	sub    $0x24,%esp
  801286:	8b 75 08             	mov    0x8(%ebp),%esi
  801289:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80128c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801290:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801296:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801299:	50                   	push   %eax
  80129a:	e8 33 ff ff ff       	call   8011d2 <fd_lookup>
  80129f:	89 c3                	mov    %eax,%ebx
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 05                	js     8012ad <fd_close+0x30>
	    || fd != fd2)
  8012a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012ab:	74 16                	je     8012c3 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012ad:	89 f8                	mov    %edi,%eax
  8012af:	84 c0                	test   %al,%al
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b6:	0f 44 d8             	cmove  %eax,%ebx
}
  8012b9:	89 d8                	mov    %ebx,%eax
  8012bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012be:	5b                   	pop    %ebx
  8012bf:	5e                   	pop    %esi
  8012c0:	5f                   	pop    %edi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 36                	pushl  (%esi)
  8012cc:	e8 51 ff ff ff       	call   801222 <dev_lookup>
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 1a                	js     8012f4 <fd_close+0x77>
		if (dev->dev_close)
  8012da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012dd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	74 0b                	je     8012f4 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	56                   	push   %esi
  8012ed:	ff d0                	call   *%eax
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	56                   	push   %esi
  8012f8:	6a 00                	push   $0x0
  8012fa:	e8 0a fc ff ff       	call   800f09 <sys_page_unmap>
	return r;
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	eb b5                	jmp    8012b9 <fd_close+0x3c>

00801304 <close>:

int
close(int fdnum)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	ff 75 08             	pushl  0x8(%ebp)
  801311:	e8 bc fe ff ff       	call   8011d2 <fd_lookup>
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	79 02                	jns    80131f <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    
		return fd_close(fd, 1);
  80131f:	83 ec 08             	sub    $0x8,%esp
  801322:	6a 01                	push   $0x1
  801324:	ff 75 f4             	pushl  -0xc(%ebp)
  801327:	e8 51 ff ff ff       	call   80127d <fd_close>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	eb ec                	jmp    80131d <close+0x19>

00801331 <close_all>:

void
close_all(void)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	53                   	push   %ebx
  801335:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801338:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80133d:	83 ec 0c             	sub    $0xc,%esp
  801340:	53                   	push   %ebx
  801341:	e8 be ff ff ff       	call   801304 <close>
	for (i = 0; i < MAXFD; i++)
  801346:	83 c3 01             	add    $0x1,%ebx
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	83 fb 20             	cmp    $0x20,%ebx
  80134f:	75 ec                	jne    80133d <close_all+0xc>
}
  801351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	57                   	push   %edi
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80135f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801362:	50                   	push   %eax
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 67 fe ff ff       	call   8011d2 <fd_lookup>
  80136b:	89 c3                	mov    %eax,%ebx
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	0f 88 81 00 00 00    	js     8013f9 <dup+0xa3>
		return r;
	close(newfdnum);
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	ff 75 0c             	pushl  0xc(%ebp)
  80137e:	e8 81 ff ff ff       	call   801304 <close>

	newfd = INDEX2FD(newfdnum);
  801383:	8b 75 0c             	mov    0xc(%ebp),%esi
  801386:	c1 e6 0c             	shl    $0xc,%esi
  801389:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80138f:	83 c4 04             	add    $0x4,%esp
  801392:	ff 75 e4             	pushl  -0x1c(%ebp)
  801395:	e8 cf fd ff ff       	call   801169 <fd2data>
  80139a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80139c:	89 34 24             	mov    %esi,(%esp)
  80139f:	e8 c5 fd ff ff       	call   801169 <fd2data>
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a9:	89 d8                	mov    %ebx,%eax
  8013ab:	c1 e8 16             	shr    $0x16,%eax
  8013ae:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013b5:	a8 01                	test   $0x1,%al
  8013b7:	74 11                	je     8013ca <dup+0x74>
  8013b9:	89 d8                	mov    %ebx,%eax
  8013bb:	c1 e8 0c             	shr    $0xc,%eax
  8013be:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013c5:	f6 c2 01             	test   $0x1,%dl
  8013c8:	75 39                	jne    801403 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	c1 e8 0c             	shr    $0xc,%eax
  8013d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e1:	50                   	push   %eax
  8013e2:	56                   	push   %esi
  8013e3:	6a 00                	push   $0x0
  8013e5:	52                   	push   %edx
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 da fa ff ff       	call   800ec7 <sys_page_map>
  8013ed:	89 c3                	mov    %eax,%ebx
  8013ef:	83 c4 20             	add    $0x20,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 31                	js     801427 <dup+0xd1>
		goto err;

	return newfdnum;
  8013f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013f9:	89 d8                	mov    %ebx,%eax
  8013fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fe:	5b                   	pop    %ebx
  8013ff:	5e                   	pop    %esi
  801400:	5f                   	pop    %edi
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801403:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	25 07 0e 00 00       	and    $0xe07,%eax
  801412:	50                   	push   %eax
  801413:	57                   	push   %edi
  801414:	6a 00                	push   $0x0
  801416:	53                   	push   %ebx
  801417:	6a 00                	push   $0x0
  801419:	e8 a9 fa ff ff       	call   800ec7 <sys_page_map>
  80141e:	89 c3                	mov    %eax,%ebx
  801420:	83 c4 20             	add    $0x20,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	79 a3                	jns    8013ca <dup+0x74>
	sys_page_unmap(0, newfd);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	56                   	push   %esi
  80142b:	6a 00                	push   $0x0
  80142d:	e8 d7 fa ff ff       	call   800f09 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801432:	83 c4 08             	add    $0x8,%esp
  801435:	57                   	push   %edi
  801436:	6a 00                	push   $0x0
  801438:	e8 cc fa ff ff       	call   800f09 <sys_page_unmap>
	return r;
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	eb b7                	jmp    8013f9 <dup+0xa3>

00801442 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	53                   	push   %ebx
  801446:	83 ec 1c             	sub    $0x1c,%esp
  801449:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144f:	50                   	push   %eax
  801450:	53                   	push   %ebx
  801451:	e8 7c fd ff ff       	call   8011d2 <fd_lookup>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 3f                	js     80149c <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801467:	ff 30                	pushl  (%eax)
  801469:	e8 b4 fd ff ff       	call   801222 <dev_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 27                	js     80149c <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801478:	8b 42 08             	mov    0x8(%edx),%eax
  80147b:	83 e0 03             	and    $0x3,%eax
  80147e:	83 f8 01             	cmp    $0x1,%eax
  801481:	74 1e                	je     8014a1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801486:	8b 40 08             	mov    0x8(%eax),%eax
  801489:	85 c0                	test   %eax,%eax
  80148b:	74 35                	je     8014c2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	ff 75 10             	pushl  0x10(%ebp)
  801493:	ff 75 0c             	pushl  0xc(%ebp)
  801496:	52                   	push   %edx
  801497:	ff d0                	call   *%eax
  801499:	83 c4 10             	add    $0x10,%esp
}
  80149c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014a6:	8b 40 48             	mov    0x48(%eax),%eax
  8014a9:	83 ec 04             	sub    $0x4,%esp
  8014ac:	53                   	push   %ebx
  8014ad:	50                   	push   %eax
  8014ae:	68 f4 2b 80 00       	push   $0x802bf4
  8014b3:	e8 7b ee ff ff       	call   800333 <cprintf>
		return -E_INVAL;
  8014b8:	83 c4 10             	add    $0x10,%esp
  8014bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c0:	eb da                	jmp    80149c <read+0x5a>
		return -E_NOT_SUPP;
  8014c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c7:	eb d3                	jmp    80149c <read+0x5a>

008014c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014dd:	39 f3                	cmp    %esi,%ebx
  8014df:	73 23                	jae    801504 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	89 f0                	mov    %esi,%eax
  8014e6:	29 d8                	sub    %ebx,%eax
  8014e8:	50                   	push   %eax
  8014e9:	89 d8                	mov    %ebx,%eax
  8014eb:	03 45 0c             	add    0xc(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	57                   	push   %edi
  8014f0:	e8 4d ff ff ff       	call   801442 <read>
		if (m < 0)
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 06                	js     801502 <readn+0x39>
			return m;
		if (m == 0)
  8014fc:	74 06                	je     801504 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014fe:	01 c3                	add    %eax,%ebx
  801500:	eb db                	jmp    8014dd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801502:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801504:	89 d8                	mov    %ebx,%eax
  801506:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 1c             	sub    $0x1c,%esp
  801515:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	53                   	push   %ebx
  80151d:	e8 b0 fc ff ff       	call   8011d2 <fd_lookup>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 3a                	js     801563 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801533:	ff 30                	pushl  (%eax)
  801535:	e8 e8 fc ff ff       	call   801222 <dev_lookup>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 22                	js     801563 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801548:	74 1e                	je     801568 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 52 0c             	mov    0xc(%edx),%edx
  801550:	85 d2                	test   %edx,%edx
  801552:	74 35                	je     801589 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	ff 75 10             	pushl  0x10(%ebp)
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	50                   	push   %eax
  80155e:	ff d2                	call   *%edx
  801560:	83 c4 10             	add    $0x10,%esp
}
  801563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801566:	c9                   	leave  
  801567:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801568:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80156d:	8b 40 48             	mov    0x48(%eax),%eax
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	53                   	push   %ebx
  801574:	50                   	push   %eax
  801575:	68 10 2c 80 00       	push   $0x802c10
  80157a:	e8 b4 ed ff ff       	call   800333 <cprintf>
		return -E_INVAL;
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801587:	eb da                	jmp    801563 <write+0x55>
		return -E_NOT_SUPP;
  801589:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158e:	eb d3                	jmp    801563 <write+0x55>

00801590 <seek>:

int
seek(int fdnum, off_t offset)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	ff 75 08             	pushl  0x8(%ebp)
  80159d:	e8 30 fc ff ff       	call   8011d2 <fd_lookup>
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 0e                	js     8015b7 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	53                   	push   %ebx
  8015bd:	83 ec 1c             	sub    $0x1c,%esp
  8015c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	53                   	push   %ebx
  8015c8:	e8 05 fc ff ff       	call   8011d2 <fd_lookup>
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 37                	js     80160b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d4:	83 ec 08             	sub    $0x8,%esp
  8015d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015da:	50                   	push   %eax
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015de:	ff 30                	pushl  (%eax)
  8015e0:	e8 3d fc ff ff       	call   801222 <dev_lookup>
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	78 1f                	js     80160b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015f3:	74 1b                	je     801610 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f8:	8b 52 18             	mov    0x18(%edx),%edx
  8015fb:	85 d2                	test   %edx,%edx
  8015fd:	74 32                	je     801631 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	ff 75 0c             	pushl  0xc(%ebp)
  801605:	50                   	push   %eax
  801606:	ff d2                	call   *%edx
  801608:	83 c4 10             	add    $0x10,%esp
}
  80160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801610:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801615:	8b 40 48             	mov    0x48(%eax),%eax
  801618:	83 ec 04             	sub    $0x4,%esp
  80161b:	53                   	push   %ebx
  80161c:	50                   	push   %eax
  80161d:	68 d0 2b 80 00       	push   $0x802bd0
  801622:	e8 0c ed ff ff       	call   800333 <cprintf>
		return -E_INVAL;
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162f:	eb da                	jmp    80160b <ftruncate+0x52>
		return -E_NOT_SUPP;
  801631:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801636:	eb d3                	jmp    80160b <ftruncate+0x52>

00801638 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	53                   	push   %ebx
  80163c:	83 ec 1c             	sub    $0x1c,%esp
  80163f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801642:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801645:	50                   	push   %eax
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 84 fb ff ff       	call   8011d2 <fd_lookup>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	85 c0                	test   %eax,%eax
  801653:	78 4b                	js     8016a0 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	ff 30                	pushl  (%eax)
  801661:	e8 bc fb ff ff       	call   801222 <dev_lookup>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	85 c0                	test   %eax,%eax
  80166b:	78 33                	js     8016a0 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801674:	74 2f                	je     8016a5 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801676:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801679:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801680:	00 00 00 
	stat->st_isdir = 0;
  801683:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168a:	00 00 00 
	stat->st_dev = dev;
  80168d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	53                   	push   %ebx
  801697:	ff 75 f0             	pushl  -0x10(%ebp)
  80169a:	ff 50 14             	call   *0x14(%eax)
  80169d:	83 c4 10             	add    $0x10,%esp
}
  8016a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016aa:	eb f4                	jmp    8016a0 <fstat+0x68>

008016ac <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	6a 00                	push   $0x0
  8016b6:	ff 75 08             	pushl  0x8(%ebp)
  8016b9:	e8 22 02 00 00       	call   8018e0 <open>
  8016be:	89 c3                	mov    %eax,%ebx
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 1b                	js     8016e2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	ff 75 0c             	pushl  0xc(%ebp)
  8016cd:	50                   	push   %eax
  8016ce:	e8 65 ff ff ff       	call   801638 <fstat>
  8016d3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d5:	89 1c 24             	mov    %ebx,(%esp)
  8016d8:	e8 27 fc ff ff       	call   801304 <close>
	return r;
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	89 f3                	mov    %esi,%ebx
}
  8016e2:	89 d8                	mov    %ebx,%eax
  8016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5e                   	pop    %esi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	89 c6                	mov    %eax,%esi
  8016f2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016f4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8016fb:	74 27                	je     801724 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016fd:	6a 07                	push   $0x7
  8016ff:	68 00 50 80 00       	push   $0x805000
  801704:	56                   	push   %esi
  801705:	ff 35 04 40 80 00    	pushl  0x804004
  80170b:	e8 1c 0d 00 00       	call   80242c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801710:	83 c4 0c             	add    $0xc,%esp
  801713:	6a 00                	push   $0x0
  801715:	53                   	push   %ebx
  801716:	6a 00                	push   $0x0
  801718:	e8 a6 0c 00 00       	call   8023c3 <ipc_recv>
}
  80171d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801720:	5b                   	pop    %ebx
  801721:	5e                   	pop    %esi
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801724:	83 ec 0c             	sub    $0xc,%esp
  801727:	6a 01                	push   $0x1
  801729:	e8 56 0d 00 00       	call   802484 <ipc_find_env>
  80172e:	a3 04 40 80 00       	mov    %eax,0x804004
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	eb c5                	jmp    8016fd <fsipc+0x12>

00801738 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8b 40 0c             	mov    0xc(%eax),%eax
  801744:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 02 00 00 00       	mov    $0x2,%eax
  80175b:	e8 8b ff ff ff       	call   8016eb <fsipc>
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <devfile_flush>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 40 0c             	mov    0xc(%eax),%eax
  80176e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	b8 06 00 00 00       	mov    $0x6,%eax
  80177d:	e8 69 ff ff ff       	call   8016eb <fsipc>
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <devfile_stat>:
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	53                   	push   %ebx
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8b 40 0c             	mov    0xc(%eax),%eax
  801794:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801799:	ba 00 00 00 00       	mov    $0x0,%edx
  80179e:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a3:	e8 43 ff ff ff       	call   8016eb <fsipc>
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	78 2c                	js     8017d8 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ac:	83 ec 08             	sub    $0x8,%esp
  8017af:	68 00 50 80 00       	push   $0x805000
  8017b4:	53                   	push   %ebx
  8017b5:	e8 d8 f2 ff ff       	call   800a92 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ba:	a1 80 50 80 00       	mov    0x805080,%eax
  8017bf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017c5:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ca:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <devfile_write>:
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017f2:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017f8:	53                   	push   %ebx
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	68 08 50 80 00       	push   $0x805008
  801801:	e8 7c f4 ff ff       	call   800c82 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801806:	ba 00 00 00 00       	mov    $0x0,%edx
  80180b:	b8 04 00 00 00       	mov    $0x4,%eax
  801810:	e8 d6 fe ff ff       	call   8016eb <fsipc>
  801815:	83 c4 10             	add    $0x10,%esp
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 0b                	js     801827 <devfile_write+0x4a>
	assert(r <= n);
  80181c:	39 d8                	cmp    %ebx,%eax
  80181e:	77 0c                	ja     80182c <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801820:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801825:	7f 1e                	jg     801845 <devfile_write+0x68>
}
  801827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    
	assert(r <= n);
  80182c:	68 44 2c 80 00       	push   $0x802c44
  801831:	68 4b 2c 80 00       	push   $0x802c4b
  801836:	68 98 00 00 00       	push   $0x98
  80183b:	68 60 2c 80 00       	push   $0x802c60
  801840:	e8 f8 e9 ff ff       	call   80023d <_panic>
	assert(r <= PGSIZE);
  801845:	68 6b 2c 80 00       	push   $0x802c6b
  80184a:	68 4b 2c 80 00       	push   $0x802c4b
  80184f:	68 99 00 00 00       	push   $0x99
  801854:	68 60 2c 80 00       	push   $0x802c60
  801859:	e8 df e9 ff ff       	call   80023d <_panic>

0080185e <devfile_read>:
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	56                   	push   %esi
  801862:	53                   	push   %ebx
  801863:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 40 0c             	mov    0xc(%eax),%eax
  80186c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801871:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	b8 03 00 00 00       	mov    $0x3,%eax
  801881:	e8 65 fe ff ff       	call   8016eb <fsipc>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 1f                	js     8018ab <devfile_read+0x4d>
	assert(r <= n);
  80188c:	39 f0                	cmp    %esi,%eax
  80188e:	77 24                	ja     8018b4 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801890:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801895:	7f 33                	jg     8018ca <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	50                   	push   %eax
  80189b:	68 00 50 80 00       	push   $0x805000
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 78 f3 ff ff       	call   800c20 <memmove>
	return r;
  8018a8:	83 c4 10             	add    $0x10,%esp
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
	assert(r <= n);
  8018b4:	68 44 2c 80 00       	push   $0x802c44
  8018b9:	68 4b 2c 80 00       	push   $0x802c4b
  8018be:	6a 7c                	push   $0x7c
  8018c0:	68 60 2c 80 00       	push   $0x802c60
  8018c5:	e8 73 e9 ff ff       	call   80023d <_panic>
	assert(r <= PGSIZE);
  8018ca:	68 6b 2c 80 00       	push   $0x802c6b
  8018cf:	68 4b 2c 80 00       	push   $0x802c4b
  8018d4:	6a 7d                	push   $0x7d
  8018d6:	68 60 2c 80 00       	push   $0x802c60
  8018db:	e8 5d e9 ff ff       	call   80023d <_panic>

008018e0 <open>:
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
  8018e5:	83 ec 1c             	sub    $0x1c,%esp
  8018e8:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018eb:	56                   	push   %esi
  8018ec:	e8 68 f1 ff ff       	call   800a59 <strlen>
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018f9:	7f 6c                	jg     801967 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801901:	50                   	push   %eax
  801902:	e8 79 f8 ff ff       	call   801180 <fd_alloc>
  801907:	89 c3                	mov    %eax,%ebx
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 3c                	js     80194c <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	56                   	push   %esi
  801914:	68 00 50 80 00       	push   $0x805000
  801919:	e8 74 f1 ff ff       	call   800a92 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80191e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801921:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801929:	b8 01 00 00 00       	mov    $0x1,%eax
  80192e:	e8 b8 fd ff ff       	call   8016eb <fsipc>
  801933:	89 c3                	mov    %eax,%ebx
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 19                	js     801955 <open+0x75>
	return fd2num(fd);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 f4             	pushl  -0xc(%ebp)
  801942:	e8 12 f8 ff ff       	call   801159 <fd2num>
  801947:	89 c3                	mov    %eax,%ebx
  801949:	83 c4 10             	add    $0x10,%esp
}
  80194c:	89 d8                	mov    %ebx,%eax
  80194e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801951:	5b                   	pop    %ebx
  801952:	5e                   	pop    %esi
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    
		fd_close(fd, 0);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 f4             	pushl  -0xc(%ebp)
  80195d:	e8 1b f9 ff ff       	call   80127d <fd_close>
		return r;
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	eb e5                	jmp    80194c <open+0x6c>
		return -E_BAD_PATH;
  801967:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80196c:	eb de                	jmp    80194c <open+0x6c>

0080196e <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	b8 08 00 00 00       	mov    $0x8,%eax
  80197e:	e8 68 fd ff ff       	call   8016eb <fsipc>
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801985:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801989:	7f 01                	jg     80198c <writebuf+0x7>
  80198b:	c3                   	ret    
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 08             	sub    $0x8,%esp
  801993:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801995:	ff 70 04             	pushl  0x4(%eax)
  801998:	8d 40 10             	lea    0x10(%eax),%eax
  80199b:	50                   	push   %eax
  80199c:	ff 33                	pushl  (%ebx)
  80199e:	e8 6b fb ff ff       	call   80150e <write>
		if (result > 0)
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	7e 03                	jle    8019ad <writebuf+0x28>
			b->result += result;
  8019aa:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019ad:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019b0:	74 0d                	je     8019bf <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	0f 4f c2             	cmovg  %edx,%eax
  8019bc:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <putch>:

static void
putch(int ch, void *thunk)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019ce:	8b 53 04             	mov    0x4(%ebx),%edx
  8019d1:	8d 42 01             	lea    0x1(%edx),%eax
  8019d4:	89 43 04             	mov    %eax,0x4(%ebx)
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019de:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019e3:	74 06                	je     8019eb <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8019e5:	83 c4 04             	add    $0x4,%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    
		writebuf(b);
  8019eb:	89 d8                	mov    %ebx,%eax
  8019ed:	e8 93 ff ff ff       	call   801985 <writebuf>
		b->idx = 0;
  8019f2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8019f9:	eb ea                	jmp    8019e5 <putch+0x21>

008019fb <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a0d:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a14:	00 00 00 
	b.result = 0;
  801a17:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a1e:	00 00 00 
	b.error = 1;
  801a21:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a28:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a2b:	ff 75 10             	pushl  0x10(%ebp)
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a37:	50                   	push   %eax
  801a38:	68 c4 19 80 00       	push   $0x8019c4
  801a3d:	e8 1e ea ff ff       	call   800460 <vprintfmt>
	if (b.idx > 0)
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a4c:	7f 11                	jg     801a5f <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a4e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a54:	85 c0                	test   %eax,%eax
  801a56:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    
		writebuf(&b);
  801a5f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a65:	e8 1b ff ff ff       	call   801985 <writebuf>
  801a6a:	eb e2                	jmp    801a4e <vfprintf+0x53>

00801a6c <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a72:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a75:	50                   	push   %eax
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 7a ff ff ff       	call   8019fb <vfprintf>
	va_end(ap);

	return cnt;
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <printf>:

int
printf(const char *fmt, ...)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a89:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a8c:	50                   	push   %eax
  801a8d:	ff 75 08             	pushl  0x8(%ebp)
  801a90:	6a 01                	push   $0x1
  801a92:	e8 64 ff ff ff       	call   8019fb <vfprintf>
	va_end(ap);

	return cnt;
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a9f:	68 77 2c 80 00       	push   $0x802c77
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	e8 e6 ef ff ff       	call   800a92 <strcpy>
	return 0;
}
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <devsock_close>:
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 10             	sub    $0x10,%esp
  801aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801abd:	53                   	push   %ebx
  801abe:	e8 fc 09 00 00       	call   8024bf <pageref>
  801ac3:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ac6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801acb:	83 f8 01             	cmp    $0x1,%eax
  801ace:	74 07                	je     801ad7 <devsock_close+0x24>
}
  801ad0:	89 d0                	mov    %edx,%eax
  801ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	ff 73 0c             	pushl  0xc(%ebx)
  801add:	e8 b9 02 00 00       	call   801d9b <nsipc_close>
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	eb e7                	jmp    801ad0 <devsock_close+0x1d>

00801ae9 <devsock_write>:
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 10             	pushl  0x10(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff 70 0c             	pushl  0xc(%eax)
  801afd:	e8 76 03 00 00       	call   801e78 <nsipc_send>
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <devsock_read>:
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	ff 70 0c             	pushl  0xc(%eax)
  801b18:	e8 ef 02 00 00       	call   801e0c <nsipc_recv>
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <fd2sockid>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b25:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	e8 a3 f6 ff ff       	call   8011d2 <fd_lookup>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	78 10                	js     801b46 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b39:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b3f:	39 08                	cmp    %ecx,(%eax)
  801b41:	75 05                	jne    801b48 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b43:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    
		return -E_NOT_SUPP;
  801b48:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4d:	eb f7                	jmp    801b46 <fd2sockid+0x27>

00801b4f <alloc_sockfd>:
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5c:	50                   	push   %eax
  801b5d:	e8 1e f6 ff ff       	call   801180 <fd_alloc>
  801b62:	89 c3                	mov    %eax,%ebx
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 43                	js     801bae <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	68 07 04 00 00       	push   $0x407
  801b73:	ff 75 f4             	pushl  -0xc(%ebp)
  801b76:	6a 00                	push   $0x0
  801b78:	e8 07 f3 ff ff       	call   800e84 <sys_page_alloc>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 28                	js     801bae <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801b8f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b94:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b9b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	50                   	push   %eax
  801ba2:	e8 b2 f5 ff ff       	call   801159 <fd2num>
  801ba7:	89 c3                	mov    %eax,%ebx
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	eb 0c                	jmp    801bba <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bae:	83 ec 0c             	sub    $0xc,%esp
  801bb1:	56                   	push   %esi
  801bb2:	e8 e4 01 00 00       	call   801d9b <nsipc_close>
		return r;
  801bb7:	83 c4 10             	add    $0x10,%esp
}
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    

00801bc3 <accept>:
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	e8 4e ff ff ff       	call   801b1f <fd2sockid>
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 1b                	js     801bf0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	ff 75 10             	pushl  0x10(%ebp)
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	50                   	push   %eax
  801bdf:	e8 0e 01 00 00       	call   801cf2 <nsipc_accept>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	85 c0                	test   %eax,%eax
  801be9:	78 05                	js     801bf0 <accept+0x2d>
	return alloc_sockfd(r);
  801beb:	e8 5f ff ff ff       	call   801b4f <alloc_sockfd>
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <bind>:
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	e8 1f ff ff ff       	call   801b1f <fd2sockid>
  801c00:	85 c0                	test   %eax,%eax
  801c02:	78 12                	js     801c16 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c04:	83 ec 04             	sub    $0x4,%esp
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	50                   	push   %eax
  801c0e:	e8 31 01 00 00       	call   801d44 <nsipc_bind>
  801c13:	83 c4 10             	add    $0x10,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <shutdown>:
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	e8 f9 fe ff ff       	call   801b1f <fd2sockid>
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 0f                	js     801c39 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c2a:	83 ec 08             	sub    $0x8,%esp
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	50                   	push   %eax
  801c31:	e8 43 01 00 00       	call   801d79 <nsipc_shutdown>
  801c36:	83 c4 10             	add    $0x10,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <connect>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	e8 d6 fe ff ff       	call   801b1f <fd2sockid>
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 12                	js     801c5f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	ff 75 10             	pushl  0x10(%ebp)
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	50                   	push   %eax
  801c57:	e8 59 01 00 00       	call   801db5 <nsipc_connect>
  801c5c:	83 c4 10             	add    $0x10,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <listen>:
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	e8 b0 fe ff ff       	call   801b1f <fd2sockid>
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	78 0f                	js     801c82 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	e8 6b 01 00 00       	call   801dea <nsipc_listen>
  801c7f:	83 c4 10             	add    $0x10,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 3e 02 00 00       	call   801ed6 <nsipc_socket>
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	78 05                	js     801ca4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c9f:	e8 ab fe ff ff       	call   801b4f <alloc_sockfd>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801caf:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801cb6:	74 26                	je     801cde <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cb8:	6a 07                	push   $0x7
  801cba:	68 00 60 80 00       	push   $0x806000
  801cbf:	53                   	push   %ebx
  801cc0:	ff 35 08 40 80 00    	pushl  0x804008
  801cc6:	e8 61 07 00 00       	call   80242c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ccb:	83 c4 0c             	add    $0xc,%esp
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	e8 ea 06 00 00       	call   8023c3 <ipc_recv>
}
  801cd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	6a 02                	push   $0x2
  801ce3:	e8 9c 07 00 00       	call   802484 <ipc_find_env>
  801ce8:	a3 08 40 80 00       	mov    %eax,0x804008
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	eb c6                	jmp    801cb8 <nsipc+0x12>

00801cf2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	56                   	push   %esi
  801cf6:	53                   	push   %ebx
  801cf7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d02:	8b 06                	mov    (%esi),%eax
  801d04:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d09:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0e:	e8 93 ff ff ff       	call   801ca6 <nsipc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	85 c0                	test   %eax,%eax
  801d17:	79 09                	jns    801d22 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d19:	89 d8                	mov    %ebx,%eax
  801d1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5d                   	pop    %ebp
  801d21:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	ff 35 10 60 80 00    	pushl  0x806010
  801d2b:	68 00 60 80 00       	push   $0x806000
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	e8 e8 ee ff ff       	call   800c20 <memmove>
		*addrlen = ret->ret_addrlen;
  801d38:	a1 10 60 80 00       	mov    0x806010,%eax
  801d3d:	89 06                	mov    %eax,(%esi)
  801d3f:	83 c4 10             	add    $0x10,%esp
	return r;
  801d42:	eb d5                	jmp    801d19 <nsipc_accept+0x27>

00801d44 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	53                   	push   %ebx
  801d48:	83 ec 08             	sub    $0x8,%esp
  801d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d56:	53                   	push   %ebx
  801d57:	ff 75 0c             	pushl  0xc(%ebp)
  801d5a:	68 04 60 80 00       	push   $0x806004
  801d5f:	e8 bc ee ff ff       	call   800c20 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d64:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d6a:	b8 02 00 00 00       	mov    $0x2,%eax
  801d6f:	e8 32 ff ff ff       	call   801ca6 <nsipc>
}
  801d74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d8f:	b8 03 00 00 00       	mov    $0x3,%eax
  801d94:	e8 0d ff ff ff       	call   801ca6 <nsipc>
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <nsipc_close>:

int
nsipc_close(int s)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801da9:	b8 04 00 00 00       	mov    $0x4,%eax
  801dae:	e8 f3 fe ff ff       	call   801ca6 <nsipc>
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dc7:	53                   	push   %ebx
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	68 04 60 80 00       	push   $0x806004
  801dd0:	e8 4b ee ff ff       	call   800c20 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dd5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ddb:	b8 05 00 00 00       	mov    $0x5,%eax
  801de0:	e8 c1 fe ff ff       	call   801ca6 <nsipc>
}
  801de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e00:	b8 06 00 00 00       	mov    $0x6,%eax
  801e05:	e8 9c fe ff ff       	call   801ca6 <nsipc>
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	56                   	push   %esi
  801e10:	53                   	push   %ebx
  801e11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e1c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e22:	8b 45 14             	mov    0x14(%ebp),%eax
  801e25:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e2a:	b8 07 00 00 00       	mov    $0x7,%eax
  801e2f:	e8 72 fe ff ff       	call   801ca6 <nsipc>
  801e34:	89 c3                	mov    %eax,%ebx
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 1f                	js     801e59 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e3a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e3f:	7f 21                	jg     801e62 <nsipc_recv+0x56>
  801e41:	39 c6                	cmp    %eax,%esi
  801e43:	7c 1d                	jl     801e62 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e45:	83 ec 04             	sub    $0x4,%esp
  801e48:	50                   	push   %eax
  801e49:	68 00 60 80 00       	push   $0x806000
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	e8 ca ed ff ff       	call   800c20 <memmove>
  801e56:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e59:	89 d8                	mov    %ebx,%eax
  801e5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e62:	68 83 2c 80 00       	push   $0x802c83
  801e67:	68 4b 2c 80 00       	push   $0x802c4b
  801e6c:	6a 62                	push   $0x62
  801e6e:	68 98 2c 80 00       	push   $0x802c98
  801e73:	e8 c5 e3 ff ff       	call   80023d <_panic>

00801e78 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e8a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e90:	7f 2e                	jg     801ec0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	53                   	push   %ebx
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	68 0c 60 80 00       	push   $0x80600c
  801e9e:	e8 7d ed ff ff       	call   800c20 <memmove>
	nsipcbuf.send.req_size = size;
  801ea3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  801eac:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eb1:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb6:	e8 eb fd ff ff       	call   801ca6 <nsipc>
}
  801ebb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    
	assert(size < 1600);
  801ec0:	68 a4 2c 80 00       	push   $0x802ca4
  801ec5:	68 4b 2c 80 00       	push   $0x802c4b
  801eca:	6a 6d                	push   $0x6d
  801ecc:	68 98 2c 80 00       	push   $0x802c98
  801ed1:	e8 67 e3 ff ff       	call   80023d <_panic>

00801ed6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801eec:	8b 45 10             	mov    0x10(%ebp),%eax
  801eef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ef4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef9:	e8 a8 fd ff ff       	call   801ca6 <nsipc>
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	56                   	push   %esi
  801f04:	53                   	push   %ebx
  801f05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	e8 56 f2 ff ff       	call   801169 <fd2data>
  801f13:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f15:	83 c4 08             	add    $0x8,%esp
  801f18:	68 b0 2c 80 00       	push   $0x802cb0
  801f1d:	53                   	push   %ebx
  801f1e:	e8 6f eb ff ff       	call   800a92 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f23:	8b 46 04             	mov    0x4(%esi),%eax
  801f26:	2b 06                	sub    (%esi),%eax
  801f28:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f35:	00 00 00 
	stat->st_dev = &devpipe;
  801f38:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801f3f:	30 80 00 
	return 0;
}
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f4a:	5b                   	pop    %ebx
  801f4b:	5e                   	pop    %esi
  801f4c:	5d                   	pop    %ebp
  801f4d:	c3                   	ret    

00801f4e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	53                   	push   %ebx
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f58:	53                   	push   %ebx
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 a9 ef ff ff       	call   800f09 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f60:	89 1c 24             	mov    %ebx,(%esp)
  801f63:	e8 01 f2 ff ff       	call   801169 <fd2data>
  801f68:	83 c4 08             	add    $0x8,%esp
  801f6b:	50                   	push   %eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	e8 96 ef ff ff       	call   800f09 <sys_page_unmap>
}
  801f73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <_pipeisclosed>:
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	57                   	push   %edi
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 1c             	sub    $0x1c,%esp
  801f81:	89 c7                	mov    %eax,%edi
  801f83:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f85:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801f8a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	57                   	push   %edi
  801f91:	e8 29 05 00 00       	call   8024bf <pageref>
  801f96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f99:	89 34 24             	mov    %esi,(%esp)
  801f9c:	e8 1e 05 00 00       	call   8024bf <pageref>
		nn = thisenv->env_runs;
  801fa1:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801fa7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	39 cb                	cmp    %ecx,%ebx
  801faf:	74 1b                	je     801fcc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fb1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb4:	75 cf                	jne    801f85 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fb6:	8b 42 58             	mov    0x58(%edx),%eax
  801fb9:	6a 01                	push   $0x1
  801fbb:	50                   	push   %eax
  801fbc:	53                   	push   %ebx
  801fbd:	68 b7 2c 80 00       	push   $0x802cb7
  801fc2:	e8 6c e3 ff ff       	call   800333 <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	eb b9                	jmp    801f85 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fcc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fcf:	0f 94 c0             	sete   %al
  801fd2:	0f b6 c0             	movzbl %al,%eax
}
  801fd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd8:	5b                   	pop    %ebx
  801fd9:	5e                   	pop    %esi
  801fda:	5f                   	pop    %edi
  801fdb:	5d                   	pop    %ebp
  801fdc:	c3                   	ret    

00801fdd <devpipe_write>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	57                   	push   %edi
  801fe1:	56                   	push   %esi
  801fe2:	53                   	push   %ebx
  801fe3:	83 ec 28             	sub    $0x28,%esp
  801fe6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fe9:	56                   	push   %esi
  801fea:	e8 7a f1 ff ff       	call   801169 <fd2data>
  801fef:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ffc:	74 4f                	je     80204d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ffe:	8b 43 04             	mov    0x4(%ebx),%eax
  802001:	8b 0b                	mov    (%ebx),%ecx
  802003:	8d 51 20             	lea    0x20(%ecx),%edx
  802006:	39 d0                	cmp    %edx,%eax
  802008:	72 14                	jb     80201e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80200a:	89 da                	mov    %ebx,%edx
  80200c:	89 f0                	mov    %esi,%eax
  80200e:	e8 65 ff ff ff       	call   801f78 <_pipeisclosed>
  802013:	85 c0                	test   %eax,%eax
  802015:	75 3b                	jne    802052 <devpipe_write+0x75>
			sys_yield();
  802017:	e8 49 ee ff ff       	call   800e65 <sys_yield>
  80201c:	eb e0                	jmp    801ffe <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80201e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802021:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802025:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802028:	89 c2                	mov    %eax,%edx
  80202a:	c1 fa 1f             	sar    $0x1f,%edx
  80202d:	89 d1                	mov    %edx,%ecx
  80202f:	c1 e9 1b             	shr    $0x1b,%ecx
  802032:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802035:	83 e2 1f             	and    $0x1f,%edx
  802038:	29 ca                	sub    %ecx,%edx
  80203a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80203e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802042:	83 c0 01             	add    $0x1,%eax
  802045:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802048:	83 c7 01             	add    $0x1,%edi
  80204b:	eb ac                	jmp    801ff9 <devpipe_write+0x1c>
	return i;
  80204d:	8b 45 10             	mov    0x10(%ebp),%eax
  802050:	eb 05                	jmp    802057 <devpipe_write+0x7a>
				return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80205a:	5b                   	pop    %ebx
  80205b:	5e                   	pop    %esi
  80205c:	5f                   	pop    %edi
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    

0080205f <devpipe_read>:
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	57                   	push   %edi
  802063:	56                   	push   %esi
  802064:	53                   	push   %ebx
  802065:	83 ec 18             	sub    $0x18,%esp
  802068:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80206b:	57                   	push   %edi
  80206c:	e8 f8 f0 ff ff       	call   801169 <fd2data>
  802071:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	be 00 00 00 00       	mov    $0x0,%esi
  80207b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80207e:	75 14                	jne    802094 <devpipe_read+0x35>
	return i;
  802080:	8b 45 10             	mov    0x10(%ebp),%eax
  802083:	eb 02                	jmp    802087 <devpipe_read+0x28>
				return i;
  802085:	89 f0                	mov    %esi,%eax
}
  802087:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208a:	5b                   	pop    %ebx
  80208b:	5e                   	pop    %esi
  80208c:	5f                   	pop    %edi
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    
			sys_yield();
  80208f:	e8 d1 ed ff ff       	call   800e65 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802094:	8b 03                	mov    (%ebx),%eax
  802096:	3b 43 04             	cmp    0x4(%ebx),%eax
  802099:	75 18                	jne    8020b3 <devpipe_read+0x54>
			if (i > 0)
  80209b:	85 f6                	test   %esi,%esi
  80209d:	75 e6                	jne    802085 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80209f:	89 da                	mov    %ebx,%edx
  8020a1:	89 f8                	mov    %edi,%eax
  8020a3:	e8 d0 fe ff ff       	call   801f78 <_pipeisclosed>
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	74 e3                	je     80208f <devpipe_read+0x30>
				return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b1:	eb d4                	jmp    802087 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020b3:	99                   	cltd   
  8020b4:	c1 ea 1b             	shr    $0x1b,%edx
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	83 e0 1f             	and    $0x1f,%eax
  8020bc:	29 d0                	sub    %edx,%eax
  8020be:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020c9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020cc:	83 c6 01             	add    $0x1,%esi
  8020cf:	eb aa                	jmp    80207b <devpipe_read+0x1c>

008020d1 <pipe>:
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	56                   	push   %esi
  8020d5:	53                   	push   %ebx
  8020d6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 9e f0 ff ff       	call   801180 <fd_alloc>
  8020e2:	89 c3                	mov    %eax,%ebx
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 23 01 00 00    	js     802212 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ef:	83 ec 04             	sub    $0x4,%esp
  8020f2:	68 07 04 00 00       	push   $0x407
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	6a 00                	push   $0x0
  8020fc:	e8 83 ed ff ff       	call   800e84 <sys_page_alloc>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	0f 88 04 01 00 00    	js     802212 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802114:	50                   	push   %eax
  802115:	e8 66 f0 ff ff       	call   801180 <fd_alloc>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	0f 88 db 00 00 00    	js     802202 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	68 07 04 00 00       	push   $0x407
  80212f:	ff 75 f0             	pushl  -0x10(%ebp)
  802132:	6a 00                	push   $0x0
  802134:	e8 4b ed ff ff       	call   800e84 <sys_page_alloc>
  802139:	89 c3                	mov    %eax,%ebx
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	85 c0                	test   %eax,%eax
  802140:	0f 88 bc 00 00 00    	js     802202 <pipe+0x131>
	va = fd2data(fd0);
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	ff 75 f4             	pushl  -0xc(%ebp)
  80214c:	e8 18 f0 ff ff       	call   801169 <fd2data>
  802151:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802153:	83 c4 0c             	add    $0xc,%esp
  802156:	68 07 04 00 00       	push   $0x407
  80215b:	50                   	push   %eax
  80215c:	6a 00                	push   $0x0
  80215e:	e8 21 ed ff ff       	call   800e84 <sys_page_alloc>
  802163:	89 c3                	mov    %eax,%ebx
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	85 c0                	test   %eax,%eax
  80216a:	0f 88 82 00 00 00    	js     8021f2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 f0             	pushl  -0x10(%ebp)
  802176:	e8 ee ef ff ff       	call   801169 <fd2data>
  80217b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802182:	50                   	push   %eax
  802183:	6a 00                	push   $0x0
  802185:	56                   	push   %esi
  802186:	6a 00                	push   $0x0
  802188:	e8 3a ed ff ff       	call   800ec7 <sys_page_map>
  80218d:	89 c3                	mov    %eax,%ebx
  80218f:	83 c4 20             	add    $0x20,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	78 4e                	js     8021e4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802196:	a1 40 30 80 00       	mov    0x803040,%eax
  80219b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ad:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bf:	e8 95 ef ff ff       	call   801159 <fd2num>
  8021c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021c7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021c9:	83 c4 04             	add    $0x4,%esp
  8021cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8021cf:	e8 85 ef ff ff       	call   801159 <fd2num>
  8021d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021e2:	eb 2e                	jmp    802212 <pipe+0x141>
	sys_page_unmap(0, va);
  8021e4:	83 ec 08             	sub    $0x8,%esp
  8021e7:	56                   	push   %esi
  8021e8:	6a 00                	push   $0x0
  8021ea:	e8 1a ed ff ff       	call   800f09 <sys_page_unmap>
  8021ef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021f2:	83 ec 08             	sub    $0x8,%esp
  8021f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f8:	6a 00                	push   $0x0
  8021fa:	e8 0a ed ff ff       	call   800f09 <sys_page_unmap>
  8021ff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802202:	83 ec 08             	sub    $0x8,%esp
  802205:	ff 75 f4             	pushl  -0xc(%ebp)
  802208:	6a 00                	push   $0x0
  80220a:	e8 fa ec ff ff       	call   800f09 <sys_page_unmap>
  80220f:	83 c4 10             	add    $0x10,%esp
}
  802212:	89 d8                	mov    %ebx,%eax
  802214:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    

0080221b <pipeisclosed>:
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802221:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802224:	50                   	push   %eax
  802225:	ff 75 08             	pushl  0x8(%ebp)
  802228:	e8 a5 ef ff ff       	call   8011d2 <fd_lookup>
  80222d:	83 c4 10             	add    $0x10,%esp
  802230:	85 c0                	test   %eax,%eax
  802232:	78 18                	js     80224c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	ff 75 f4             	pushl  -0xc(%ebp)
  80223a:	e8 2a ef ff ff       	call   801169 <fd2data>
	return _pipeisclosed(fd, p);
  80223f:	89 c2                	mov    %eax,%edx
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	e8 2f fd ff ff       	call   801f78 <_pipeisclosed>
  802249:	83 c4 10             	add    $0x10,%esp
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
  802253:	c3                   	ret    

00802254 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80225a:	68 cf 2c 80 00       	push   $0x802ccf
  80225f:	ff 75 0c             	pushl  0xc(%ebp)
  802262:	e8 2b e8 ff ff       	call   800a92 <strcpy>
	return 0;
}
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <devcons_write>:
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	57                   	push   %edi
  802272:	56                   	push   %esi
  802273:	53                   	push   %ebx
  802274:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80227a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80227f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802285:	3b 75 10             	cmp    0x10(%ebp),%esi
  802288:	73 31                	jae    8022bb <devcons_write+0x4d>
		m = n - tot;
  80228a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80228d:	29 f3                	sub    %esi,%ebx
  80228f:	83 fb 7f             	cmp    $0x7f,%ebx
  802292:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802297:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	53                   	push   %ebx
  80229e:	89 f0                	mov    %esi,%eax
  8022a0:	03 45 0c             	add    0xc(%ebp),%eax
  8022a3:	50                   	push   %eax
  8022a4:	57                   	push   %edi
  8022a5:	e8 76 e9 ff ff       	call   800c20 <memmove>
		sys_cputs(buf, m);
  8022aa:	83 c4 08             	add    $0x8,%esp
  8022ad:	53                   	push   %ebx
  8022ae:	57                   	push   %edi
  8022af:	e8 14 eb ff ff       	call   800dc8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022b4:	01 de                	add    %ebx,%esi
  8022b6:	83 c4 10             	add    $0x10,%esp
  8022b9:	eb ca                	jmp    802285 <devcons_write+0x17>
}
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <devcons_read>:
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 08             	sub    $0x8,%esp
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d4:	74 21                	je     8022f7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8022d6:	e8 0b eb ff ff       	call   800de6 <sys_cgetc>
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	75 07                	jne    8022e6 <devcons_read+0x21>
		sys_yield();
  8022df:	e8 81 eb ff ff       	call   800e65 <sys_yield>
  8022e4:	eb f0                	jmp    8022d6 <devcons_read+0x11>
	if (c < 0)
  8022e6:	78 0f                	js     8022f7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8022e8:	83 f8 04             	cmp    $0x4,%eax
  8022eb:	74 0c                	je     8022f9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	88 02                	mov    %al,(%edx)
	return 1;
  8022f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    
		return 0;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	eb f7                	jmp    8022f7 <devcons_read+0x32>

00802300 <cputchar>:
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80230c:	6a 01                	push   $0x1
  80230e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802311:	50                   	push   %eax
  802312:	e8 b1 ea ff ff       	call   800dc8 <sys_cputs>
}
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <getchar>:
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802322:	6a 01                	push   $0x1
  802324:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802327:	50                   	push   %eax
  802328:	6a 00                	push   $0x0
  80232a:	e8 13 f1 ff ff       	call   801442 <read>
	if (r < 0)
  80232f:	83 c4 10             	add    $0x10,%esp
  802332:	85 c0                	test   %eax,%eax
  802334:	78 06                	js     80233c <getchar+0x20>
	if (r < 1)
  802336:	74 06                	je     80233e <getchar+0x22>
	return c;
  802338:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    
		return -E_EOF;
  80233e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802343:	eb f7                	jmp    80233c <getchar+0x20>

00802345 <iscons>:
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80234b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234e:	50                   	push   %eax
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	e8 7b ee ff ff       	call   8011d2 <fd_lookup>
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 11                	js     80236f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802367:	39 10                	cmp    %edx,(%eax)
  802369:	0f 94 c0             	sete   %al
  80236c:	0f b6 c0             	movzbl %al,%eax
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <opencons>:
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802377:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237a:	50                   	push   %eax
  80237b:	e8 00 ee ff ff       	call   801180 <fd_alloc>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	78 3a                	js     8023c1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	68 07 04 00 00       	push   $0x407
  80238f:	ff 75 f4             	pushl  -0xc(%ebp)
  802392:	6a 00                	push   $0x0
  802394:	e8 eb ea ff ff       	call   800e84 <sys_page_alloc>
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	85 c0                	test   %eax,%eax
  80239e:	78 21                	js     8023c1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023a9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023b5:	83 ec 0c             	sub    $0xc,%esp
  8023b8:	50                   	push   %eax
  8023b9:	e8 9b ed ff ff       	call   801159 <fd2num>
  8023be:	83 c4 10             	add    $0x10,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	56                   	push   %esi
  8023c7:	53                   	push   %ebx
  8023c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8023d1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023d3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023d8:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8023db:	83 ec 0c             	sub    $0xc,%esp
  8023de:	50                   	push   %eax
  8023df:	e8 50 ec ff ff       	call   801034 <sys_ipc_recv>
	if(ret < 0){
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	78 2b                	js     802416 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8023eb:	85 f6                	test   %esi,%esi
  8023ed:	74 0a                	je     8023f9 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8023ef:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8023f4:	8b 40 74             	mov    0x74(%eax),%eax
  8023f7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8023f9:	85 db                	test   %ebx,%ebx
  8023fb:	74 0a                	je     802407 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8023fd:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802402:	8b 40 78             	mov    0x78(%eax),%eax
  802405:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802407:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80240c:	8b 40 70             	mov    0x70(%eax),%eax
}
  80240f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802412:	5b                   	pop    %ebx
  802413:	5e                   	pop    %esi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
		if(from_env_store)
  802416:	85 f6                	test   %esi,%esi
  802418:	74 06                	je     802420 <ipc_recv+0x5d>
			*from_env_store = 0;
  80241a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802420:	85 db                	test   %ebx,%ebx
  802422:	74 eb                	je     80240f <ipc_recv+0x4c>
			*perm_store = 0;
  802424:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80242a:	eb e3                	jmp    80240f <ipc_recv+0x4c>

0080242c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	57                   	push   %edi
  802430:	56                   	push   %esi
  802431:	53                   	push   %ebx
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	8b 7d 08             	mov    0x8(%ebp),%edi
  802438:	8b 75 0c             	mov    0xc(%ebp),%esi
  80243b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80243e:	85 db                	test   %ebx,%ebx
  802440:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802445:	0f 44 d8             	cmove  %eax,%ebx
  802448:	eb 05                	jmp    80244f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80244a:	e8 16 ea ff ff       	call   800e65 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80244f:	ff 75 14             	pushl  0x14(%ebp)
  802452:	53                   	push   %ebx
  802453:	56                   	push   %esi
  802454:	57                   	push   %edi
  802455:	e8 b7 eb ff ff       	call   801011 <sys_ipc_try_send>
  80245a:	83 c4 10             	add    $0x10,%esp
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 1b                	je     80247c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802461:	79 e7                	jns    80244a <ipc_send+0x1e>
  802463:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802466:	74 e2                	je     80244a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	68 db 2c 80 00       	push   $0x802cdb
  802470:	6a 48                	push   $0x48
  802472:	68 f0 2c 80 00       	push   $0x802cf0
  802477:	e8 c1 dd ff ff       	call   80023d <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80247c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248f:	89 c2                	mov    %eax,%edx
  802491:	c1 e2 07             	shl    $0x7,%edx
  802494:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80249a:	8b 52 50             	mov    0x50(%edx),%edx
  80249d:	39 ca                	cmp    %ecx,%edx
  80249f:	74 11                	je     8024b2 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8024a1:	83 c0 01             	add    $0x1,%eax
  8024a4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a9:	75 e4                	jne    80248f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b0:	eb 0b                	jmp    8024bd <ipc_find_env+0x39>
			return envs[i].env_id;
  8024b2:	c1 e0 07             	shl    $0x7,%eax
  8024b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024ba:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024bd:	5d                   	pop    %ebp
  8024be:	c3                   	ret    

008024bf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c5:	89 d0                	mov    %edx,%eax
  8024c7:	c1 e8 16             	shr    $0x16,%eax
  8024ca:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d6:	f6 c1 01             	test   $0x1,%cl
  8024d9:	74 1d                	je     8024f8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024db:	c1 ea 0c             	shr    $0xc,%edx
  8024de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e5:	f6 c2 01             	test   $0x1,%dl
  8024e8:	74 0e                	je     8024f8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024ea:	c1 ea 0c             	shr    $0xc,%edx
  8024ed:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f4:	ef 
  8024f5:	0f b7 c0             	movzwl %ax,%eax
}
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80250f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802517:	85 d2                	test   %edx,%edx
  802519:	75 4d                	jne    802568 <__udivdi3+0x68>
  80251b:	39 f3                	cmp    %esi,%ebx
  80251d:	76 19                	jbe    802538 <__udivdi3+0x38>
  80251f:	31 ff                	xor    %edi,%edi
  802521:	89 e8                	mov    %ebp,%eax
  802523:	89 f2                	mov    %esi,%edx
  802525:	f7 f3                	div    %ebx
  802527:	89 fa                	mov    %edi,%edx
  802529:	83 c4 1c             	add    $0x1c,%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5f                   	pop    %edi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 d9                	mov    %ebx,%ecx
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	75 0b                	jne    802549 <__udivdi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f3                	div    %ebx
  802547:	89 c1                	mov    %eax,%ecx
  802549:	31 d2                	xor    %edx,%edx
  80254b:	89 f0                	mov    %esi,%eax
  80254d:	f7 f1                	div    %ecx
  80254f:	89 c6                	mov    %eax,%esi
  802551:	89 e8                	mov    %ebp,%eax
  802553:	89 f7                	mov    %esi,%edi
  802555:	f7 f1                	div    %ecx
  802557:	89 fa                	mov    %edi,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	39 f2                	cmp    %esi,%edx
  80256a:	77 1c                	ja     802588 <__udivdi3+0x88>
  80256c:	0f bd fa             	bsr    %edx,%edi
  80256f:	83 f7 1f             	xor    $0x1f,%edi
  802572:	75 2c                	jne    8025a0 <__udivdi3+0xa0>
  802574:	39 f2                	cmp    %esi,%edx
  802576:	72 06                	jb     80257e <__udivdi3+0x7e>
  802578:	31 c0                	xor    %eax,%eax
  80257a:	39 eb                	cmp    %ebp,%ebx
  80257c:	77 a9                	ja     802527 <__udivdi3+0x27>
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb a2                	jmp    802527 <__udivdi3+0x27>
  802585:	8d 76 00             	lea    0x0(%esi),%esi
  802588:	31 ff                	xor    %edi,%edi
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 f9                	mov    %edi,%ecx
  8025a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a7:	29 f8                	sub    %edi,%eax
  8025a9:	d3 e2                	shl    %cl,%edx
  8025ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	89 da                	mov    %ebx,%edx
  8025b3:	d3 ea                	shr    %cl,%edx
  8025b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b9:	09 d1                	or     %edx,%ecx
  8025bb:	89 f2                	mov    %esi,%edx
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 f9                	mov    %edi,%ecx
  8025c3:	d3 e3                	shl    %cl,%ebx
  8025c5:	89 c1                	mov    %eax,%ecx
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	89 f9                	mov    %edi,%ecx
  8025cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8025cf:	89 eb                	mov    %ebp,%ebx
  8025d1:	d3 e6                	shl    %cl,%esi
  8025d3:	89 c1                	mov    %eax,%ecx
  8025d5:	d3 eb                	shr    %cl,%ebx
  8025d7:	09 de                	or     %ebx,%esi
  8025d9:	89 f0                	mov    %esi,%eax
  8025db:	f7 74 24 08          	divl   0x8(%esp)
  8025df:	89 d6                	mov    %edx,%esi
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	f7 64 24 0c          	mull   0xc(%esp)
  8025e7:	39 d6                	cmp    %edx,%esi
  8025e9:	72 15                	jb     802600 <__udivdi3+0x100>
  8025eb:	89 f9                	mov    %edi,%ecx
  8025ed:	d3 e5                	shl    %cl,%ebp
  8025ef:	39 c5                	cmp    %eax,%ebp
  8025f1:	73 04                	jae    8025f7 <__udivdi3+0xf7>
  8025f3:	39 d6                	cmp    %edx,%esi
  8025f5:	74 09                	je     802600 <__udivdi3+0x100>
  8025f7:	89 d8                	mov    %ebx,%eax
  8025f9:	31 ff                	xor    %edi,%edi
  8025fb:	e9 27 ff ff ff       	jmp    802527 <__udivdi3+0x27>
  802600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802603:	31 ff                	xor    %edi,%edi
  802605:	e9 1d ff ff ff       	jmp    802527 <__udivdi3+0x27>
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__umoddi3>:
  802610:	55                   	push   %ebp
  802611:	57                   	push   %edi
  802612:	56                   	push   %esi
  802613:	53                   	push   %ebx
  802614:	83 ec 1c             	sub    $0x1c,%esp
  802617:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80261b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80261f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802627:	89 da                	mov    %ebx,%edx
  802629:	85 c0                	test   %eax,%eax
  80262b:	75 43                	jne    802670 <__umoddi3+0x60>
  80262d:	39 df                	cmp    %ebx,%edi
  80262f:	76 17                	jbe    802648 <__umoddi3+0x38>
  802631:	89 f0                	mov    %esi,%eax
  802633:	f7 f7                	div    %edi
  802635:	89 d0                	mov    %edx,%eax
  802637:	31 d2                	xor    %edx,%edx
  802639:	83 c4 1c             	add    $0x1c,%esp
  80263c:	5b                   	pop    %ebx
  80263d:	5e                   	pop    %esi
  80263e:	5f                   	pop    %edi
  80263f:	5d                   	pop    %ebp
  802640:	c3                   	ret    
  802641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802648:	89 fd                	mov    %edi,%ebp
  80264a:	85 ff                	test   %edi,%edi
  80264c:	75 0b                	jne    802659 <__umoddi3+0x49>
  80264e:	b8 01 00 00 00       	mov    $0x1,%eax
  802653:	31 d2                	xor    %edx,%edx
  802655:	f7 f7                	div    %edi
  802657:	89 c5                	mov    %eax,%ebp
  802659:	89 d8                	mov    %ebx,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f5                	div    %ebp
  80265f:	89 f0                	mov    %esi,%eax
  802661:	f7 f5                	div    %ebp
  802663:	89 d0                	mov    %edx,%eax
  802665:	eb d0                	jmp    802637 <__umoddi3+0x27>
  802667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266e:	66 90                	xchg   %ax,%ax
  802670:	89 f1                	mov    %esi,%ecx
  802672:	39 d8                	cmp    %ebx,%eax
  802674:	76 0a                	jbe    802680 <__umoddi3+0x70>
  802676:	89 f0                	mov    %esi,%eax
  802678:	83 c4 1c             	add    $0x1c,%esp
  80267b:	5b                   	pop    %ebx
  80267c:	5e                   	pop    %esi
  80267d:	5f                   	pop    %edi
  80267e:	5d                   	pop    %ebp
  80267f:	c3                   	ret    
  802680:	0f bd e8             	bsr    %eax,%ebp
  802683:	83 f5 1f             	xor    $0x1f,%ebp
  802686:	75 20                	jne    8026a8 <__umoddi3+0x98>
  802688:	39 d8                	cmp    %ebx,%eax
  80268a:	0f 82 b0 00 00 00    	jb     802740 <__umoddi3+0x130>
  802690:	39 f7                	cmp    %esi,%edi
  802692:	0f 86 a8 00 00 00    	jbe    802740 <__umoddi3+0x130>
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	83 c4 1c             	add    $0x1c,%esp
  80269d:	5b                   	pop    %ebx
  80269e:	5e                   	pop    %esi
  80269f:	5f                   	pop    %edi
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    
  8026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026af:	29 ea                	sub    %ebp,%edx
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b7:	89 d1                	mov    %edx,%ecx
  8026b9:	89 f8                	mov    %edi,%eax
  8026bb:	d3 e8                	shr    %cl,%eax
  8026bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026c9:	09 c1                	or     %eax,%ecx
  8026cb:	89 d8                	mov    %ebx,%eax
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 e9                	mov    %ebp,%ecx
  8026d3:	d3 e7                	shl    %cl,%edi
  8026d5:	89 d1                	mov    %edx,%ecx
  8026d7:	d3 e8                	shr    %cl,%eax
  8026d9:	89 e9                	mov    %ebp,%ecx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	d3 e3                	shl    %cl,%ebx
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	89 d1                	mov    %edx,%ecx
  8026e5:	89 f0                	mov    %esi,%eax
  8026e7:	d3 e8                	shr    %cl,%eax
  8026e9:	89 e9                	mov    %ebp,%ecx
  8026eb:	89 fa                	mov    %edi,%edx
  8026ed:	d3 e6                	shl    %cl,%esi
  8026ef:	09 d8                	or     %ebx,%eax
  8026f1:	f7 74 24 08          	divl   0x8(%esp)
  8026f5:	89 d1                	mov    %edx,%ecx
  8026f7:	89 f3                	mov    %esi,%ebx
  8026f9:	f7 64 24 0c          	mull   0xc(%esp)
  8026fd:	89 c6                	mov    %eax,%esi
  8026ff:	89 d7                	mov    %edx,%edi
  802701:	39 d1                	cmp    %edx,%ecx
  802703:	72 06                	jb     80270b <__umoddi3+0xfb>
  802705:	75 10                	jne    802717 <__umoddi3+0x107>
  802707:	39 c3                	cmp    %eax,%ebx
  802709:	73 0c                	jae    802717 <__umoddi3+0x107>
  80270b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80270f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802713:	89 d7                	mov    %edx,%edi
  802715:	89 c6                	mov    %eax,%esi
  802717:	89 ca                	mov    %ecx,%edx
  802719:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80271e:	29 f3                	sub    %esi,%ebx
  802720:	19 fa                	sbb    %edi,%edx
  802722:	89 d0                	mov    %edx,%eax
  802724:	d3 e0                	shl    %cl,%eax
  802726:	89 e9                	mov    %ebp,%ecx
  802728:	d3 eb                	shr    %cl,%ebx
  80272a:	d3 ea                	shr    %cl,%edx
  80272c:	09 d8                	or     %ebx,%eax
  80272e:	83 c4 1c             	add    $0x1c,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5f                   	pop    %edi
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80273d:	8d 76 00             	lea    0x0(%esi),%esi
  802740:	89 da                	mov    %ebx,%edx
  802742:	29 fe                	sub    %edi,%esi
  802744:	19 c2                	sbb    %eax,%edx
  802746:	89 f1                	mov    %esi,%ecx
  802748:	89 c8                	mov    %ecx,%eax
  80274a:	e9 4b ff ff ff       	jmp    80269a <__umoddi3+0x8a>
