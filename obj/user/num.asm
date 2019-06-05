
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
  800054:	68 a0 27 80 00       	push   $0x8027a0
  800059:	e8 76 1a 00 00       	call   801ad4 <printf>
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
  800073:	e8 e7 14 00 00       	call   80155f <write>
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
  80008d:	e8 01 14 00 00       	call   801493 <read>
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
  8000ab:	68 a5 27 80 00       	push   $0x8027a5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 c0 27 80 00       	push   $0x8027c0
  8000b7:	e8 d2 01 00 00       	call   80028e <_panic>
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
  8000d8:	68 cb 27 80 00       	push   $0x8027cb
  8000dd:	6a 18                	push   $0x18
  8000df:	68 c0 27 80 00       	push   $0x8027c0
  8000e4:	e8 a5 01 00 00       	call   80028e <_panic>

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
  8000f2:	c7 05 04 30 80 00 e0 	movl   $0x8027e0,0x803004
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
  80011c:	e8 10 18 00 00       	call   801931 <open>
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
  800138:	e8 18 12 00 00       	call   801355 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 e4 27 80 00       	push   $0x8027e4
  800150:	6a 00                	push   $0x0
  800152:	e8 dc fe ff ff       	call   800033 <num>
  800157:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015a:	e8 fb 00 00 00       	call   80025a <exit>
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
  800170:	68 ec 27 80 00       	push   $0x8027ec
  800175:	6a 27                	push   $0x27
  800177:	68 c0 27 80 00       	push   $0x8027c0
  80017c:	e8 0d 01 00 00       	call   80028e <_panic>

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
  800194:	e8 fe 0c 00 00       	call   800e97 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001f8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8001fd:	8b 40 48             	mov    0x48(%eax),%eax
  800200:	83 ec 08             	sub    $0x8,%esp
  800203:	50                   	push   %eax
  800204:	68 fe 27 80 00       	push   $0x8027fe
  800209:	e8 76 01 00 00       	call   800384 <cprintf>
	cprintf("before umain\n");
  80020e:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  800215:	e8 6a 01 00 00       	call   800384 <cprintf>
	// call user main routine
	umain(argc, argv);
  80021a:	83 c4 08             	add    $0x8,%esp
  80021d:	ff 75 0c             	pushl  0xc(%ebp)
  800220:	ff 75 08             	pushl  0x8(%ebp)
  800223:	e8 c1 fe ff ff       	call   8000e9 <umain>
	cprintf("after umain\n");
  800228:	c7 04 24 2a 28 80 00 	movl   $0x80282a,(%esp)
  80022f:	e8 50 01 00 00       	call   800384 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800234:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800239:	8b 40 48             	mov    0x48(%eax),%eax
  80023c:	83 c4 08             	add    $0x8,%esp
  80023f:	50                   	push   %eax
  800240:	68 37 28 80 00       	push   $0x802837
  800245:	e8 3a 01 00 00       	call   800384 <cprintf>
	// exit gracefully
	exit();
  80024a:	e8 0b 00 00 00       	call   80025a <exit>
}
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    

0080025a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800260:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800265:	8b 40 48             	mov    0x48(%eax),%eax
  800268:	68 64 28 80 00       	push   $0x802864
  80026d:	50                   	push   %eax
  80026e:	68 56 28 80 00       	push   $0x802856
  800273:	e8 0c 01 00 00       	call   800384 <cprintf>
	close_all();
  800278:	e8 05 11 00 00       	call   801382 <close_all>
	sys_env_destroy(0);
  80027d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800284:	e8 cd 0b 00 00       	call   800e56 <sys_env_destroy>
}
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800293:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800298:	8b 40 48             	mov    0x48(%eax),%eax
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 90 28 80 00       	push   $0x802890
  8002a3:	50                   	push   %eax
  8002a4:	68 56 28 80 00       	push   $0x802856
  8002a9:	e8 d6 00 00 00       	call   800384 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002b1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8002b7:	e8 db 0b 00 00       	call   800e97 <sys_getenvid>
  8002bc:	83 c4 04             	add    $0x4,%esp
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	56                   	push   %esi
  8002c6:	50                   	push   %eax
  8002c7:	68 6c 28 80 00       	push   $0x80286c
  8002cc:	e8 b3 00 00 00       	call   800384 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d1:	83 c4 18             	add    $0x18,%esp
  8002d4:	53                   	push   %ebx
  8002d5:	ff 75 10             	pushl  0x10(%ebp)
  8002d8:	e8 56 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002dd:	c7 04 24 1a 28 80 00 	movl   $0x80281a,(%esp)
  8002e4:	e8 9b 00 00 00       	call   800384 <cprintf>
  8002e9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ec:	cc                   	int3   
  8002ed:	eb fd                	jmp    8002ec <_panic+0x5e>

008002ef <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f9:	8b 13                	mov    (%ebx),%edx
  8002fb:	8d 42 01             	lea    0x1(%edx),%eax
  8002fe:	89 03                	mov    %eax,(%ebx)
  800300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800303:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800307:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030c:	74 09                	je     800317 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800315:	c9                   	leave  
  800316:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	68 ff 00 00 00       	push   $0xff
  80031f:	8d 43 08             	lea    0x8(%ebx),%eax
  800322:	50                   	push   %eax
  800323:	e8 f1 0a 00 00       	call   800e19 <sys_cputs>
		b->idx = 0;
  800328:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb db                	jmp    80030e <putch+0x1f>

00800333 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800343:	00 00 00 
	b.cnt = 0;
  800346:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800350:	ff 75 0c             	pushl  0xc(%ebp)
  800353:	ff 75 08             	pushl  0x8(%ebp)
  800356:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035c:	50                   	push   %eax
  80035d:	68 ef 02 80 00       	push   $0x8002ef
  800362:	e8 4a 01 00 00       	call   8004b1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800367:	83 c4 08             	add    $0x8,%esp
  80036a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800370:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800376:	50                   	push   %eax
  800377:	e8 9d 0a 00 00       	call   800e19 <sys_cputs>

	return b.cnt;
}
  80037c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80038a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038d:	50                   	push   %eax
  80038e:	ff 75 08             	pushl  0x8(%ebp)
  800391:	e8 9d ff ff ff       	call   800333 <vcprintf>
	va_end(ap);

	return cnt;
}
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	57                   	push   %edi
  80039c:	56                   	push   %esi
  80039d:	53                   	push   %ebx
  80039e:	83 ec 1c             	sub    $0x1c,%esp
  8003a1:	89 c6                	mov    %eax,%esi
  8003a3:	89 d7                	mov    %edx,%edi
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003b7:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003bb:	74 2c                	je     8003e9 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003d2:	73 43                	jae    800417 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003d4:	83 eb 01             	sub    $0x1,%ebx
  8003d7:	85 db                	test   %ebx,%ebx
  8003d9:	7e 6c                	jle    800447 <printnum+0xaf>
				putch(padc, putdat);
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	57                   	push   %edi
  8003df:	ff 75 18             	pushl  0x18(%ebp)
  8003e2:	ff d6                	call   *%esi
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	eb eb                	jmp    8003d4 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 20                	push   $0x20
  8003ee:	6a 00                	push   $0x0
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f7:	89 fa                	mov    %edi,%edx
  8003f9:	89 f0                	mov    %esi,%eax
  8003fb:	e8 98 ff ff ff       	call   800398 <printnum>
		while (--width > 0)
  800400:	83 c4 20             	add    $0x20,%esp
  800403:	83 eb 01             	sub    $0x1,%ebx
  800406:	85 db                	test   %ebx,%ebx
  800408:	7e 65                	jle    80046f <printnum+0xd7>
			putch(padc, putdat);
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	57                   	push   %edi
  80040e:	6a 20                	push   $0x20
  800410:	ff d6                	call   *%esi
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	eb ec                	jmp    800403 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800417:	83 ec 0c             	sub    $0xc,%esp
  80041a:	ff 75 18             	pushl  0x18(%ebp)
  80041d:	83 eb 01             	sub    $0x1,%ebx
  800420:	53                   	push   %ebx
  800421:	50                   	push   %eax
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	ff 75 dc             	pushl  -0x24(%ebp)
  800428:	ff 75 d8             	pushl  -0x28(%ebp)
  80042b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042e:	ff 75 e0             	pushl  -0x20(%ebp)
  800431:	e8 1a 21 00 00       	call   802550 <__udivdi3>
  800436:	83 c4 18             	add    $0x18,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	89 fa                	mov    %edi,%edx
  80043d:	89 f0                	mov    %esi,%eax
  80043f:	e8 54 ff ff ff       	call   800398 <printnum>
  800444:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	57                   	push   %edi
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	ff 75 dc             	pushl  -0x24(%ebp)
  800451:	ff 75 d8             	pushl  -0x28(%ebp)
  800454:	ff 75 e4             	pushl  -0x1c(%ebp)
  800457:	ff 75 e0             	pushl  -0x20(%ebp)
  80045a:	e8 01 22 00 00       	call   802660 <__umoddi3>
  80045f:	83 c4 14             	add    $0x14,%esp
  800462:	0f be 80 97 28 80 00 	movsbl 0x802897(%eax),%eax
  800469:	50                   	push   %eax
  80046a:	ff d6                	call   *%esi
  80046c:	83 c4 10             	add    $0x10,%esp
	}
}
  80046f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800472:	5b                   	pop    %ebx
  800473:	5e                   	pop    %esi
  800474:	5f                   	pop    %edi
  800475:	5d                   	pop    %ebp
  800476:	c3                   	ret    

00800477 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800477:	55                   	push   %ebp
  800478:	89 e5                	mov    %esp,%ebp
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80047d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800481:	8b 10                	mov    (%eax),%edx
  800483:	3b 50 04             	cmp    0x4(%eax),%edx
  800486:	73 0a                	jae    800492 <sprintputch+0x1b>
		*b->buf++ = ch;
  800488:	8d 4a 01             	lea    0x1(%edx),%ecx
  80048b:	89 08                	mov    %ecx,(%eax)
  80048d:	8b 45 08             	mov    0x8(%ebp),%eax
  800490:	88 02                	mov    %al,(%edx)
}
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    

00800494 <printfmt>:
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80049a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80049d:	50                   	push   %eax
  80049e:	ff 75 10             	pushl  0x10(%ebp)
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	e8 05 00 00 00       	call   8004b1 <vprintfmt>
}
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <vprintfmt>:
{
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	57                   	push   %edi
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
  8004b7:	83 ec 3c             	sub    $0x3c,%esp
  8004ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004c3:	e9 32 04 00 00       	jmp    8008fa <vprintfmt+0x449>
		padc = ' ';
  8004c8:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004cc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004da:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e8:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004ef:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f4:	8d 47 01             	lea    0x1(%edi),%eax
  8004f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fa:	0f b6 17             	movzbl (%edi),%edx
  8004fd:	8d 42 dd             	lea    -0x23(%edx),%eax
  800500:	3c 55                	cmp    $0x55,%al
  800502:	0f 87 12 05 00 00    	ja     800a1a <vprintfmt+0x569>
  800508:	0f b6 c0             	movzbl %al,%eax
  80050b:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800515:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800519:	eb d9                	jmp    8004f4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80051e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800522:	eb d0                	jmp    8004f4 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800524:	0f b6 d2             	movzbl %dl,%edx
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	89 75 08             	mov    %esi,0x8(%ebp)
  800532:	eb 03                	jmp    800537 <vprintfmt+0x86>
  800534:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800537:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80053a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80053e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800541:	8d 72 d0             	lea    -0x30(%edx),%esi
  800544:	83 fe 09             	cmp    $0x9,%esi
  800547:	76 eb                	jbe    800534 <vprintfmt+0x83>
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	eb 14                	jmp    800565 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8d 40 04             	lea    0x4(%eax),%eax
  80055f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800565:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800569:	79 89                	jns    8004f4 <vprintfmt+0x43>
				width = precision, precision = -1;
  80056b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800571:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800578:	e9 77 ff ff ff       	jmp    8004f4 <vprintfmt+0x43>
  80057d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800580:	85 c0                	test   %eax,%eax
  800582:	0f 48 c1             	cmovs  %ecx,%eax
  800585:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800588:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058b:	e9 64 ff ff ff       	jmp    8004f4 <vprintfmt+0x43>
  800590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800593:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80059a:	e9 55 ff ff ff       	jmp    8004f4 <vprintfmt+0x43>
			lflag++;
  80059f:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005a6:	e9 49 ff ff ff       	jmp    8004f4 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8d 78 04             	lea    0x4(%eax),%edi
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	ff 30                	pushl  (%eax)
  8005b7:	ff d6                	call   *%esi
			break;
  8005b9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005bc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005bf:	e9 33 03 00 00       	jmp    8008f7 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 78 04             	lea    0x4(%eax),%edi
  8005ca:	8b 00                	mov    (%eax),%eax
  8005cc:	99                   	cltd   
  8005cd:	31 d0                	xor    %edx,%eax
  8005cf:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005d1:	83 f8 11             	cmp    $0x11,%eax
  8005d4:	7f 23                	jg     8005f9 <vprintfmt+0x148>
  8005d6:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  8005dd:	85 d2                	test   %edx,%edx
  8005df:	74 18                	je     8005f9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005e1:	52                   	push   %edx
  8005e2:	68 01 2d 80 00       	push   $0x802d01
  8005e7:	53                   	push   %ebx
  8005e8:	56                   	push   %esi
  8005e9:	e8 a6 fe ff ff       	call   800494 <printfmt>
  8005ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f4:	e9 fe 02 00 00       	jmp    8008f7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f9:	50                   	push   %eax
  8005fa:	68 af 28 80 00       	push   $0x8028af
  8005ff:	53                   	push   %ebx
  800600:	56                   	push   %esi
  800601:	e8 8e fe ff ff       	call   800494 <printfmt>
  800606:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800609:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80060c:	e9 e6 02 00 00       	jmp    8008f7 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 c0 04             	add    $0x4,%eax
  800617:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80061f:	85 c9                	test   %ecx,%ecx
  800621:	b8 a8 28 80 00       	mov    $0x8028a8,%eax
  800626:	0f 45 c1             	cmovne %ecx,%eax
  800629:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80062c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800630:	7e 06                	jle    800638 <vprintfmt+0x187>
  800632:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800636:	75 0d                	jne    800645 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800638:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80063b:	89 c7                	mov    %eax,%edi
  80063d:	03 45 e0             	add    -0x20(%ebp),%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	eb 53                	jmp    800698 <vprintfmt+0x1e7>
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 d8             	pushl  -0x28(%ebp)
  80064b:	50                   	push   %eax
  80064c:	e8 71 04 00 00       	call   800ac2 <strnlen>
  800651:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800654:	29 c1                	sub    %eax,%ecx
  800656:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800659:	83 c4 10             	add    $0x10,%esp
  80065c:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80065e:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800662:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800665:	eb 0f                	jmp    800676 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	ff 75 e0             	pushl  -0x20(%ebp)
  80066e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800670:	83 ef 01             	sub    $0x1,%edi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	85 ff                	test   %edi,%edi
  800678:	7f ed                	jg     800667 <vprintfmt+0x1b6>
  80067a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80067d:	85 c9                	test   %ecx,%ecx
  80067f:	b8 00 00 00 00       	mov    $0x0,%eax
  800684:	0f 49 c1             	cmovns %ecx,%eax
  800687:	29 c1                	sub    %eax,%ecx
  800689:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80068c:	eb aa                	jmp    800638 <vprintfmt+0x187>
					putch(ch, putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	52                   	push   %edx
  800693:	ff d6                	call   *%esi
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80069b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069d:	83 c7 01             	add    $0x1,%edi
  8006a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a4:	0f be d0             	movsbl %al,%edx
  8006a7:	85 d2                	test   %edx,%edx
  8006a9:	74 4b                	je     8006f6 <vprintfmt+0x245>
  8006ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006af:	78 06                	js     8006b7 <vprintfmt+0x206>
  8006b1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006b5:	78 1e                	js     8006d5 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006bb:	74 d1                	je     80068e <vprintfmt+0x1dd>
  8006bd:	0f be c0             	movsbl %al,%eax
  8006c0:	83 e8 20             	sub    $0x20,%eax
  8006c3:	83 f8 5e             	cmp    $0x5e,%eax
  8006c6:	76 c6                	jbe    80068e <vprintfmt+0x1dd>
					putch('?', putdat);
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	53                   	push   %ebx
  8006cc:	6a 3f                	push   $0x3f
  8006ce:	ff d6                	call   *%esi
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb c3                	jmp    800698 <vprintfmt+0x1e7>
  8006d5:	89 cf                	mov    %ecx,%edi
  8006d7:	eb 0e                	jmp    8006e7 <vprintfmt+0x236>
				putch(' ', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 20                	push   $0x20
  8006df:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006e1:	83 ef 01             	sub    $0x1,%edi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	85 ff                	test   %edi,%edi
  8006e9:	7f ee                	jg     8006d9 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f1:	e9 01 02 00 00       	jmp    8008f7 <vprintfmt+0x446>
  8006f6:	89 cf                	mov    %ecx,%edi
  8006f8:	eb ed                	jmp    8006e7 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006fd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800704:	e9 eb fd ff ff       	jmp    8004f4 <vprintfmt+0x43>
	if (lflag >= 2)
  800709:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070d:	7f 21                	jg     800730 <vprintfmt+0x27f>
	else if (lflag)
  80070f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800713:	74 68                	je     80077d <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071d:	89 c1                	mov    %eax,%ecx
  80071f:	c1 f9 1f             	sar    $0x1f,%ecx
  800722:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
  80072e:	eb 17                	jmp    800747 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8b 50 04             	mov    0x4(%eax),%edx
  800736:	8b 00                	mov    (%eax),%eax
  800738:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 40 08             	lea    0x8(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800747:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800753:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800757:	78 3f                	js     800798 <vprintfmt+0x2e7>
			base = 10;
  800759:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80075e:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800762:	0f 84 71 01 00 00    	je     8008d9 <vprintfmt+0x428>
				putch('+', putdat);
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	53                   	push   %ebx
  80076c:	6a 2b                	push   $0x2b
  80076e:	ff d6                	call   *%esi
  800770:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800773:	b8 0a 00 00 00       	mov    $0xa,%eax
  800778:	e9 5c 01 00 00       	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800785:	89 c1                	mov    %eax,%ecx
  800787:	c1 f9 1f             	sar    $0x1f,%ecx
  80078a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
  800796:	eb af                	jmp    800747 <vprintfmt+0x296>
				putch('-', putdat);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	53                   	push   %ebx
  80079c:	6a 2d                	push   $0x2d
  80079e:	ff d6                	call   *%esi
				num = -(long long) num;
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a6:	f7 d8                	neg    %eax
  8007a8:	83 d2 00             	adc    $0x0,%edx
  8007ab:	f7 da                	neg    %edx
  8007ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bb:	e9 19 01 00 00       	jmp    8008d9 <vprintfmt+0x428>
	if (lflag >= 2)
  8007c0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c4:	7f 29                	jg     8007ef <vprintfmt+0x33e>
	else if (lflag)
  8007c6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ca:	74 44                	je     800810 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8d 40 04             	lea    0x4(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ea:	e9 ea 00 00 00       	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 50 04             	mov    0x4(%eax),%edx
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 40 08             	lea    0x8(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800806:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080b:	e9 c9 00 00 00       	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	8b 00                	mov    (%eax),%eax
  800815:	ba 00 00 00 00       	mov    $0x0,%edx
  80081a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8d 40 04             	lea    0x4(%eax),%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800829:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082e:	e9 a6 00 00 00       	jmp    8008d9 <vprintfmt+0x428>
			putch('0', putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	6a 30                	push   $0x30
  800839:	ff d6                	call   *%esi
	if (lflag >= 2)
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800842:	7f 26                	jg     80086a <vprintfmt+0x3b9>
	else if (lflag)
  800844:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800848:	74 3e                	je     800888 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
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
  800868:	eb 6f                	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 50 04             	mov    0x4(%eax),%edx
  800870:	8b 00                	mov    (%eax),%eax
  800872:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800875:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 40 08             	lea    0x8(%eax),%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800881:	b8 08 00 00 00       	mov    $0x8,%eax
  800886:	eb 51                	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	ba 00 00 00 00       	mov    $0x0,%edx
  800892:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800895:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	8d 40 04             	lea    0x4(%eax),%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8008a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a6:	eb 31                	jmp    8008d9 <vprintfmt+0x428>
			putch('0', putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	53                   	push   %ebx
  8008ac:	6a 30                	push   $0x30
  8008ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8008b0:	83 c4 08             	add    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	6a 78                	push   $0x78
  8008b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8d 40 04             	lea    0x4(%eax),%eax
  8008d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008e0:	52                   	push   %edx
  8008e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e4:	50                   	push   %eax
  8008e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8008eb:	89 da                	mov    %ebx,%edx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	e8 a4 fa ff ff       	call   800398 <printnum>
			break;
  8008f4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fa:	83 c7 01             	add    $0x1,%edi
  8008fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800901:	83 f8 25             	cmp    $0x25,%eax
  800904:	0f 84 be fb ff ff    	je     8004c8 <vprintfmt+0x17>
			if (ch == '\0')
  80090a:	85 c0                	test   %eax,%eax
  80090c:	0f 84 28 01 00 00    	je     800a3a <vprintfmt+0x589>
			putch(ch, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	50                   	push   %eax
  800917:	ff d6                	call   *%esi
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb dc                	jmp    8008fa <vprintfmt+0x449>
	if (lflag >= 2)
  80091e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800922:	7f 26                	jg     80094a <vprintfmt+0x499>
	else if (lflag)
  800924:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800928:	74 41                	je     80096b <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	ba 00 00 00 00       	mov    $0x0,%edx
  800934:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800937:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80093a:	8b 45 14             	mov    0x14(%ebp),%eax
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800943:	b8 10 00 00 00       	mov    $0x10,%eax
  800948:	eb 8f                	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 50 04             	mov    0x4(%eax),%edx
  800950:	8b 00                	mov    (%eax),%eax
  800952:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800955:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 08             	lea    0x8(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800961:	b8 10 00 00 00       	mov    $0x10,%eax
  800966:	e9 6e ff ff ff       	jmp    8008d9 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	ba 00 00 00 00       	mov    $0x0,%edx
  800975:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800978:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097b:	8b 45 14             	mov    0x14(%ebp),%eax
  80097e:	8d 40 04             	lea    0x4(%eax),%eax
  800981:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800984:	b8 10 00 00 00       	mov    $0x10,%eax
  800989:	e9 4b ff ff ff       	jmp    8008d9 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	83 c0 04             	add    $0x4,%eax
  800994:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800997:	8b 45 14             	mov    0x14(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	85 c0                	test   %eax,%eax
  80099e:	74 14                	je     8009b4 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8009a0:	8b 13                	mov    (%ebx),%edx
  8009a2:	83 fa 7f             	cmp    $0x7f,%edx
  8009a5:	7f 37                	jg     8009de <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009a7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8009af:	e9 43 ff ff ff       	jmp    8008f7 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b9:	bf cd 29 80 00       	mov    $0x8029cd,%edi
							putch(ch, putdat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	53                   	push   %ebx
  8009c2:	50                   	push   %eax
  8009c3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009c5:	83 c7 01             	add    $0x1,%edi
  8009c8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	85 c0                	test   %eax,%eax
  8009d1:	75 eb                	jne    8009be <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d9:	e9 19 ff ff ff       	jmp    8008f7 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009de:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009e5:	bf 05 2a 80 00       	mov    $0x802a05,%edi
							putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	53                   	push   %ebx
  8009ee:	50                   	push   %eax
  8009ef:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009f1:	83 c7 01             	add    $0x1,%edi
  8009f4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	85 c0                	test   %eax,%eax
  8009fd:	75 eb                	jne    8009ea <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a02:	89 45 14             	mov    %eax,0x14(%ebp)
  800a05:	e9 ed fe ff ff       	jmp    8008f7 <vprintfmt+0x446>
			putch(ch, putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	53                   	push   %ebx
  800a0e:	6a 25                	push   $0x25
  800a10:	ff d6                	call   *%esi
			break;
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	e9 dd fe ff ff       	jmp    8008f7 <vprintfmt+0x446>
			putch('%', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	53                   	push   %ebx
  800a1e:	6a 25                	push   $0x25
  800a20:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a22:	83 c4 10             	add    $0x10,%esp
  800a25:	89 f8                	mov    %edi,%eax
  800a27:	eb 03                	jmp    800a2c <vprintfmt+0x57b>
  800a29:	83 e8 01             	sub    $0x1,%eax
  800a2c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a30:	75 f7                	jne    800a29 <vprintfmt+0x578>
  800a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a35:	e9 bd fe ff ff       	jmp    8008f7 <vprintfmt+0x446>
}
  800a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a3d:	5b                   	pop    %ebx
  800a3e:	5e                   	pop    %esi
  800a3f:	5f                   	pop    %edi
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	83 ec 18             	sub    $0x18,%esp
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5f:	85 c0                	test   %eax,%eax
  800a61:	74 26                	je     800a89 <vsnprintf+0x47>
  800a63:	85 d2                	test   %edx,%edx
  800a65:	7e 22                	jle    800a89 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a67:	ff 75 14             	pushl  0x14(%ebp)
  800a6a:	ff 75 10             	pushl  0x10(%ebp)
  800a6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a70:	50                   	push   %eax
  800a71:	68 77 04 80 00       	push   $0x800477
  800a76:	e8 36 fa ff ff       	call   8004b1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a84:	83 c4 10             	add    $0x10,%esp
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    
		return -E_INVAL;
  800a89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a8e:	eb f7                	jmp    800a87 <vsnprintf+0x45>

00800a90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a96:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a99:	50                   	push   %eax
  800a9a:	ff 75 10             	pushl  0x10(%ebp)
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	ff 75 08             	pushl  0x8(%ebp)
  800aa3:	e8 9a ff ff ff       	call   800a42 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab9:	74 05                	je     800ac0 <strlen+0x16>
		n++;
  800abb:	83 c0 01             	add    $0x1,%eax
  800abe:	eb f5                	jmp    800ab5 <strlen+0xb>
	return n;
}
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad0:	39 c2                	cmp    %eax,%edx
  800ad2:	74 0d                	je     800ae1 <strnlen+0x1f>
  800ad4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ad8:	74 05                	je     800adf <strnlen+0x1d>
		n++;
  800ada:	83 c2 01             	add    $0x1,%edx
  800add:	eb f1                	jmp    800ad0 <strnlen+0xe>
  800adf:	89 d0                	mov    %edx,%eax
	return n;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	53                   	push   %ebx
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800af6:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af9:	83 c2 01             	add    $0x1,%edx
  800afc:	84 c9                	test   %cl,%cl
  800afe:	75 f2                	jne    800af2 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b00:	5b                   	pop    %ebx
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	53                   	push   %ebx
  800b07:	83 ec 10             	sub    $0x10,%esp
  800b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b0d:	53                   	push   %ebx
  800b0e:	e8 97 ff ff ff       	call   800aaa <strlen>
  800b13:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b16:	ff 75 0c             	pushl  0xc(%ebp)
  800b19:	01 d8                	add    %ebx,%eax
  800b1b:	50                   	push   %eax
  800b1c:	e8 c2 ff ff ff       	call   800ae3 <strcpy>
	return dst;
}
  800b21:	89 d8                	mov    %ebx,%eax
  800b23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b26:	c9                   	leave  
  800b27:	c3                   	ret    

00800b28 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b33:	89 c6                	mov    %eax,%esi
  800b35:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	39 f2                	cmp    %esi,%edx
  800b3c:	74 11                	je     800b4f <strncpy+0x27>
		*dst++ = *src;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	0f b6 19             	movzbl (%ecx),%ebx
  800b44:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b47:	80 fb 01             	cmp    $0x1,%bl
  800b4a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b4d:	eb eb                	jmp    800b3a <strncpy+0x12>
	}
	return ret;
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	8b 75 08             	mov    0x8(%ebp),%esi
  800b5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5e:	8b 55 10             	mov    0x10(%ebp),%edx
  800b61:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b63:	85 d2                	test   %edx,%edx
  800b65:	74 21                	je     800b88 <strlcpy+0x35>
  800b67:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b6b:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b6d:	39 c2                	cmp    %eax,%edx
  800b6f:	74 14                	je     800b85 <strlcpy+0x32>
  800b71:	0f b6 19             	movzbl (%ecx),%ebx
  800b74:	84 db                	test   %bl,%bl
  800b76:	74 0b                	je     800b83 <strlcpy+0x30>
			*dst++ = *src++;
  800b78:	83 c1 01             	add    $0x1,%ecx
  800b7b:	83 c2 01             	add    $0x1,%edx
  800b7e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b81:	eb ea                	jmp    800b6d <strlcpy+0x1a>
  800b83:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b85:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b88:	29 f0                	sub    %esi,%eax
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b97:	0f b6 01             	movzbl (%ecx),%eax
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0c                	je     800baa <strcmp+0x1c>
  800b9e:	3a 02                	cmp    (%edx),%al
  800ba0:	75 08                	jne    800baa <strcmp+0x1c>
		p++, q++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
  800ba5:	83 c2 01             	add    $0x1,%edx
  800ba8:	eb ed                	jmp    800b97 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800baa:	0f b6 c0             	movzbl %al,%eax
  800bad:	0f b6 12             	movzbl (%edx),%edx
  800bb0:	29 d0                	sub    %edx,%eax
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	53                   	push   %ebx
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbe:	89 c3                	mov    %eax,%ebx
  800bc0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc3:	eb 06                	jmp    800bcb <strncmp+0x17>
		n--, p++, q++;
  800bc5:	83 c0 01             	add    $0x1,%eax
  800bc8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bcb:	39 d8                	cmp    %ebx,%eax
  800bcd:	74 16                	je     800be5 <strncmp+0x31>
  800bcf:	0f b6 08             	movzbl (%eax),%ecx
  800bd2:	84 c9                	test   %cl,%cl
  800bd4:	74 04                	je     800bda <strncmp+0x26>
  800bd6:	3a 0a                	cmp    (%edx),%cl
  800bd8:	74 eb                	je     800bc5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bda:	0f b6 00             	movzbl (%eax),%eax
  800bdd:	0f b6 12             	movzbl (%edx),%edx
  800be0:	29 d0                	sub    %edx,%eax
}
  800be2:	5b                   	pop    %ebx
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    
		return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bea:	eb f6                	jmp    800be2 <strncmp+0x2e>

00800bec <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf6:	0f b6 10             	movzbl (%eax),%edx
  800bf9:	84 d2                	test   %dl,%dl
  800bfb:	74 09                	je     800c06 <strchr+0x1a>
		if (*s == c)
  800bfd:	38 ca                	cmp    %cl,%dl
  800bff:	74 0a                	je     800c0b <strchr+0x1f>
	for (; *s; s++)
  800c01:	83 c0 01             	add    $0x1,%eax
  800c04:	eb f0                	jmp    800bf6 <strchr+0xa>
			return (char *) s;
	return 0;
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    

00800c0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c17:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c1a:	38 ca                	cmp    %cl,%dl
  800c1c:	74 09                	je     800c27 <strfind+0x1a>
  800c1e:	84 d2                	test   %dl,%dl
  800c20:	74 05                	je     800c27 <strfind+0x1a>
	for (; *s; s++)
  800c22:	83 c0 01             	add    $0x1,%eax
  800c25:	eb f0                	jmp    800c17 <strfind+0xa>
			break;
	return (char *) s;
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
  800c2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c35:	85 c9                	test   %ecx,%ecx
  800c37:	74 31                	je     800c6a <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c39:	89 f8                	mov    %edi,%eax
  800c3b:	09 c8                	or     %ecx,%eax
  800c3d:	a8 03                	test   $0x3,%al
  800c3f:	75 23                	jne    800c64 <memset+0x3b>
		c &= 0xFF;
  800c41:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c45:	89 d3                	mov    %edx,%ebx
  800c47:	c1 e3 08             	shl    $0x8,%ebx
  800c4a:	89 d0                	mov    %edx,%eax
  800c4c:	c1 e0 18             	shl    $0x18,%eax
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	c1 e6 10             	shl    $0x10,%esi
  800c54:	09 f0                	or     %esi,%eax
  800c56:	09 c2                	or     %eax,%edx
  800c58:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c5a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c5d:	89 d0                	mov    %edx,%eax
  800c5f:	fc                   	cld    
  800c60:	f3 ab                	rep stos %eax,%es:(%edi)
  800c62:	eb 06                	jmp    800c6a <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	fc                   	cld    
  800c68:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c6a:	89 f8                	mov    %edi,%eax
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7f:	39 c6                	cmp    %eax,%esi
  800c81:	73 32                	jae    800cb5 <memmove+0x44>
  800c83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c86:	39 c2                	cmp    %eax,%edx
  800c88:	76 2b                	jbe    800cb5 <memmove+0x44>
		s += n;
		d += n;
  800c8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8d:	89 fe                	mov    %edi,%esi
  800c8f:	09 ce                	or     %ecx,%esi
  800c91:	09 d6                	or     %edx,%esi
  800c93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c99:	75 0e                	jne    800ca9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c9b:	83 ef 04             	sub    $0x4,%edi
  800c9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ca1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca4:	fd                   	std    
  800ca5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca7:	eb 09                	jmp    800cb2 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca9:	83 ef 01             	sub    $0x1,%edi
  800cac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800caf:	fd                   	std    
  800cb0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb2:	fc                   	cld    
  800cb3:	eb 1a                	jmp    800ccf <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb5:	89 c2                	mov    %eax,%edx
  800cb7:	09 ca                	or     %ecx,%edx
  800cb9:	09 f2                	or     %esi,%edx
  800cbb:	f6 c2 03             	test   $0x3,%dl
  800cbe:	75 0a                	jne    800cca <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cc0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc3:	89 c7                	mov    %eax,%edi
  800cc5:	fc                   	cld    
  800cc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc8:	eb 05                	jmp    800ccf <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cca:	89 c7                	mov    %eax,%edi
  800ccc:	fc                   	cld    
  800ccd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd9:	ff 75 10             	pushl  0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 8a ff ff ff       	call   800c71 <memmove>
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf4:	89 c6                	mov    %eax,%esi
  800cf6:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf9:	39 f0                	cmp    %esi,%eax
  800cfb:	74 1c                	je     800d19 <memcmp+0x30>
		if (*s1 != *s2)
  800cfd:	0f b6 08             	movzbl (%eax),%ecx
  800d00:	0f b6 1a             	movzbl (%edx),%ebx
  800d03:	38 d9                	cmp    %bl,%cl
  800d05:	75 08                	jne    800d0f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d07:	83 c0 01             	add    $0x1,%eax
  800d0a:	83 c2 01             	add    $0x1,%edx
  800d0d:	eb ea                	jmp    800cf9 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d0f:	0f b6 c1             	movzbl %cl,%eax
  800d12:	0f b6 db             	movzbl %bl,%ebx
  800d15:	29 d8                	sub    %ebx,%eax
  800d17:	eb 05                	jmp    800d1e <memcmp+0x35>
	}

	return 0;
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2b:	89 c2                	mov    %eax,%edx
  800d2d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d30:	39 d0                	cmp    %edx,%eax
  800d32:	73 09                	jae    800d3d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d34:	38 08                	cmp    %cl,(%eax)
  800d36:	74 05                	je     800d3d <memfind+0x1b>
	for (; s < ends; s++)
  800d38:	83 c0 01             	add    $0x1,%eax
  800d3b:	eb f3                	jmp    800d30 <memfind+0xe>
			break;
	return (void *) s;
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4b:	eb 03                	jmp    800d50 <strtol+0x11>
		s++;
  800d4d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d50:	0f b6 01             	movzbl (%ecx),%eax
  800d53:	3c 20                	cmp    $0x20,%al
  800d55:	74 f6                	je     800d4d <strtol+0xe>
  800d57:	3c 09                	cmp    $0x9,%al
  800d59:	74 f2                	je     800d4d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d5b:	3c 2b                	cmp    $0x2b,%al
  800d5d:	74 2a                	je     800d89 <strtol+0x4a>
	int neg = 0;
  800d5f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d64:	3c 2d                	cmp    $0x2d,%al
  800d66:	74 2b                	je     800d93 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d68:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d6e:	75 0f                	jne    800d7f <strtol+0x40>
  800d70:	80 39 30             	cmpb   $0x30,(%ecx)
  800d73:	74 28                	je     800d9d <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d75:	85 db                	test   %ebx,%ebx
  800d77:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7c:	0f 44 d8             	cmove  %eax,%ebx
  800d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d84:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d87:	eb 50                	jmp    800dd9 <strtol+0x9a>
		s++;
  800d89:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800d91:	eb d5                	jmp    800d68 <strtol+0x29>
		s++, neg = 1;
  800d93:	83 c1 01             	add    $0x1,%ecx
  800d96:	bf 01 00 00 00       	mov    $0x1,%edi
  800d9b:	eb cb                	jmp    800d68 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800da1:	74 0e                	je     800db1 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	75 d8                	jne    800d7f <strtol+0x40>
		s++, base = 8;
  800da7:	83 c1 01             	add    $0x1,%ecx
  800daa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800daf:	eb ce                	jmp    800d7f <strtol+0x40>
		s += 2, base = 16;
  800db1:	83 c1 02             	add    $0x2,%ecx
  800db4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db9:	eb c4                	jmp    800d7f <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dbb:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dbe:	89 f3                	mov    %esi,%ebx
  800dc0:	80 fb 19             	cmp    $0x19,%bl
  800dc3:	77 29                	ja     800dee <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dc5:	0f be d2             	movsbl %dl,%edx
  800dc8:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dcb:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dce:	7d 30                	jge    800e00 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dd0:	83 c1 01             	add    $0x1,%ecx
  800dd3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dd9:	0f b6 11             	movzbl (%ecx),%edx
  800ddc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ddf:	89 f3                	mov    %esi,%ebx
  800de1:	80 fb 09             	cmp    $0x9,%bl
  800de4:	77 d5                	ja     800dbb <strtol+0x7c>
			dig = *s - '0';
  800de6:	0f be d2             	movsbl %dl,%edx
  800de9:	83 ea 30             	sub    $0x30,%edx
  800dec:	eb dd                	jmp    800dcb <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dee:	8d 72 bf             	lea    -0x41(%edx),%esi
  800df1:	89 f3                	mov    %esi,%ebx
  800df3:	80 fb 19             	cmp    $0x19,%bl
  800df6:	77 08                	ja     800e00 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df8:	0f be d2             	movsbl %dl,%edx
  800dfb:	83 ea 37             	sub    $0x37,%edx
  800dfe:	eb cb                	jmp    800dcb <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e04:	74 05                	je     800e0b <strtol+0xcc>
		*endptr = (char *) s;
  800e06:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e09:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e0b:	89 c2                	mov    %eax,%edx
  800e0d:	f7 da                	neg    %edx
  800e0f:	85 ff                	test   %edi,%edi
  800e11:	0f 45 c2             	cmovne %edx,%eax
}
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	89 c3                	mov    %eax,%ebx
  800e2c:	89 c7                	mov    %eax,%edi
  800e2e:	89 c6                	mov    %eax,%esi
  800e30:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e42:	b8 01 00 00 00       	mov    $0x1,%eax
  800e47:	89 d1                	mov    %edx,%ecx
  800e49:	89 d3                	mov    %edx,%ebx
  800e4b:	89 d7                	mov    %edx,%edi
  800e4d:	89 d6                	mov    %edx,%esi
  800e4f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e51:	5b                   	pop    %ebx
  800e52:	5e                   	pop    %esi
  800e53:	5f                   	pop    %edi
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	b8 03 00 00 00       	mov    $0x3,%eax
  800e6c:	89 cb                	mov    %ecx,%ebx
  800e6e:	89 cf                	mov    %ecx,%edi
  800e70:	89 ce                	mov    %ecx,%esi
  800e72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	7f 08                	jg     800e80 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	50                   	push   %eax
  800e84:	6a 03                	push   $0x3
  800e86:	68 28 2c 80 00       	push   $0x802c28
  800e8b:	6a 43                	push   $0x43
  800e8d:	68 45 2c 80 00       	push   $0x802c45
  800e92:	e8 f7 f3 ff ff       	call   80028e <_panic>

00800e97 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea7:	89 d1                	mov    %edx,%ecx
  800ea9:	89 d3                	mov    %edx,%ebx
  800eab:	89 d7                	mov    %edx,%edi
  800ead:	89 d6                	mov    %edx,%esi
  800eaf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <sys_yield>:

void
sys_yield(void)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec6:	89 d1                	mov    %edx,%ecx
  800ec8:	89 d3                	mov    %edx,%ebx
  800eca:	89 d7                	mov    %edx,%edi
  800ecc:	89 d6                	mov    %edx,%esi
  800ece:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
  800edb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ede:	be 00 00 00 00       	mov    $0x0,%esi
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	b8 04 00 00 00       	mov    $0x4,%eax
  800eee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef1:	89 f7                	mov    %esi,%edi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	6a 04                	push   $0x4
  800f07:	68 28 2c 80 00       	push   $0x802c28
  800f0c:	6a 43                	push   $0x43
  800f0e:	68 45 2c 80 00       	push   $0x802c45
  800f13:	e8 76 f3 ff ff       	call   80028e <_panic>

00800f18 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
  800f1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 05 00 00 00       	mov    $0x5,%eax
  800f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f32:	8b 75 18             	mov    0x18(%ebp),%esi
  800f35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7f 08                	jg     800f43 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	50                   	push   %eax
  800f47:	6a 05                	push   $0x5
  800f49:	68 28 2c 80 00       	push   $0x802c28
  800f4e:	6a 43                	push   $0x43
  800f50:	68 45 2c 80 00       	push   $0x802c45
  800f55:	e8 34 f3 ff ff       	call   80028e <_panic>

00800f5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f73:	89 df                	mov    %ebx,%edi
  800f75:	89 de                	mov    %ebx,%esi
  800f77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7f 08                	jg     800f85 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f80:	5b                   	pop    %ebx
  800f81:	5e                   	pop    %esi
  800f82:	5f                   	pop    %edi
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f85:	83 ec 0c             	sub    $0xc,%esp
  800f88:	50                   	push   %eax
  800f89:	6a 06                	push   $0x6
  800f8b:	68 28 2c 80 00       	push   $0x802c28
  800f90:	6a 43                	push   $0x43
  800f92:	68 45 2c 80 00       	push   $0x802c45
  800f97:	e8 f2 f2 ff ff       	call   80028e <_panic>

00800f9c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb5:	89 df                	mov    %ebx,%edi
  800fb7:	89 de                	mov    %ebx,%esi
  800fb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbb:	85 c0                	test   %eax,%eax
  800fbd:	7f 08                	jg     800fc7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc7:	83 ec 0c             	sub    $0xc,%esp
  800fca:	50                   	push   %eax
  800fcb:	6a 08                	push   $0x8
  800fcd:	68 28 2c 80 00       	push   $0x802c28
  800fd2:	6a 43                	push   $0x43
  800fd4:	68 45 2c 80 00       	push   $0x802c45
  800fd9:	e8 b0 f2 ff ff       	call   80028e <_panic>

00800fde <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	57                   	push   %edi
  800fe2:	56                   	push   %esi
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff7:	89 df                	mov    %ebx,%edi
  800ff9:	89 de                	mov    %ebx,%esi
  800ffb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	7f 08                	jg     801009 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801001:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801009:	83 ec 0c             	sub    $0xc,%esp
  80100c:	50                   	push   %eax
  80100d:	6a 09                	push   $0x9
  80100f:	68 28 2c 80 00       	push   $0x802c28
  801014:	6a 43                	push   $0x43
  801016:	68 45 2c 80 00       	push   $0x802c45
  80101b:	e8 6e f2 ff ff       	call   80028e <_panic>

00801020 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	b8 0a 00 00 00       	mov    $0xa,%eax
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7f 08                	jg     80104b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801043:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	6a 0a                	push   $0xa
  801051:	68 28 2c 80 00       	push   $0x802c28
  801056:	6a 43                	push   $0x43
  801058:	68 45 2c 80 00       	push   $0x802c45
  80105d:	e8 2c f2 ff ff       	call   80028e <_panic>

00801062 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
	asm volatile("int %1\n"
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801073:	be 00 00 00 00       	mov    $0x0,%esi
  801078:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80107b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80107e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	b8 0d 00 00 00       	mov    $0xd,%eax
  80109b:	89 cb                	mov    %ecx,%ebx
  80109d:	89 cf                	mov    %ecx,%edi
  80109f:	89 ce                	mov    %ecx,%esi
  8010a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	7f 08                	jg     8010af <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	50                   	push   %eax
  8010b3:	6a 0d                	push   $0xd
  8010b5:	68 28 2c 80 00       	push   $0x802c28
  8010ba:	6a 43                	push   $0x43
  8010bc:	68 45 2c 80 00       	push   $0x802c45
  8010c1:	e8 c8 f1 ff ff       	call   80028e <_panic>

008010c6 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010dc:	89 df                	mov    %ebx,%edi
  8010de:	89 de                	mov    %ebx,%esi
  8010e0:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fa:	89 cb                	mov    %ecx,%ebx
  8010fc:	89 cf                	mov    %ecx,%edi
  8010fe:	89 ce                	mov    %ecx,%esi
  801100:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110d:	ba 00 00 00 00       	mov    $0x0,%edx
  801112:	b8 10 00 00 00       	mov    $0x10,%eax
  801117:	89 d1                	mov    %edx,%ecx
  801119:	89 d3                	mov    %edx,%ebx
  80111b:	89 d7                	mov    %edx,%edi
  80111d:	89 d6                	mov    %edx,%esi
  80111f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5f                   	pop    %edi
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801131:	8b 55 08             	mov    0x8(%ebp),%edx
  801134:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801137:	b8 11 00 00 00       	mov    $0x11,%eax
  80113c:	89 df                	mov    %ebx,%edi
  80113e:	89 de                	mov    %ebx,%esi
  801140:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	5f                   	pop    %edi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	57                   	push   %edi
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801152:	8b 55 08             	mov    0x8(%ebp),%edx
  801155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801158:	b8 12 00 00 00       	mov    $0x12,%eax
  80115d:	89 df                	mov    %ebx,%edi
  80115f:	89 de                	mov    %ebx,%esi
  801161:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    

00801168 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	57                   	push   %edi
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
  80116e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801171:	bb 00 00 00 00       	mov    $0x0,%ebx
  801176:	8b 55 08             	mov    0x8(%ebp),%edx
  801179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117c:	b8 13 00 00 00       	mov    $0x13,%eax
  801181:	89 df                	mov    %ebx,%edi
  801183:	89 de                	mov    %ebx,%esi
  801185:	cd 30                	int    $0x30
	if(check && ret > 0)
  801187:	85 c0                	test   %eax,%eax
  801189:	7f 08                	jg     801193 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80118b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118e:	5b                   	pop    %ebx
  80118f:	5e                   	pop    %esi
  801190:	5f                   	pop    %edi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801193:	83 ec 0c             	sub    $0xc,%esp
  801196:	50                   	push   %eax
  801197:	6a 13                	push   $0x13
  801199:	68 28 2c 80 00       	push   $0x802c28
  80119e:	6a 43                	push   $0x43
  8011a0:	68 45 2c 80 00       	push   $0x802c45
  8011a5:	e8 e4 f0 ff ff       	call   80028e <_panic>

008011aa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ca:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d9:	89 c2                	mov    %eax,%edx
  8011db:	c1 ea 16             	shr    $0x16,%edx
  8011de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e5:	f6 c2 01             	test   $0x1,%dl
  8011e8:	74 2d                	je     801217 <fd_alloc+0x46>
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	c1 ea 0c             	shr    $0xc,%edx
  8011ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f6:	f6 c2 01             	test   $0x1,%dl
  8011f9:	74 1c                	je     801217 <fd_alloc+0x46>
  8011fb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801200:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801205:	75 d2                	jne    8011d9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801210:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801215:	eb 0a                	jmp    801221 <fd_alloc+0x50>
			*fd_store = fd;
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801229:	83 f8 1f             	cmp    $0x1f,%eax
  80122c:	77 30                	ja     80125e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80122e:	c1 e0 0c             	shl    $0xc,%eax
  801231:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801236:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80123c:	f6 c2 01             	test   $0x1,%dl
  80123f:	74 24                	je     801265 <fd_lookup+0x42>
  801241:	89 c2                	mov    %eax,%edx
  801243:	c1 ea 0c             	shr    $0xc,%edx
  801246:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124d:	f6 c2 01             	test   $0x1,%dl
  801250:	74 1a                	je     80126c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801252:	8b 55 0c             	mov    0xc(%ebp),%edx
  801255:	89 02                	mov    %eax,(%edx)
	return 0;
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    
		return -E_INVAL;
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb f7                	jmp    80125c <fd_lookup+0x39>
		return -E_INVAL;
  801265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126a:	eb f0                	jmp    80125c <fd_lookup+0x39>
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801271:	eb e9                	jmp    80125c <fd_lookup+0x39>

00801273 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80127c:	ba 00 00 00 00       	mov    $0x0,%edx
  801281:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801286:	39 08                	cmp    %ecx,(%eax)
  801288:	74 38                	je     8012c2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80128a:	83 c2 01             	add    $0x1,%edx
  80128d:	8b 04 95 d4 2c 80 00 	mov    0x802cd4(,%edx,4),%eax
  801294:	85 c0                	test   %eax,%eax
  801296:	75 ee                	jne    801286 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801298:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80129d:	8b 40 48             	mov    0x48(%eax),%eax
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	51                   	push   %ecx
  8012a4:	50                   	push   %eax
  8012a5:	68 54 2c 80 00       	push   $0x802c54
  8012aa:	e8 d5 f0 ff ff       	call   800384 <cprintf>
	*dev = 0;
  8012af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    
			*dev = devtab[i];
  8012c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cc:	eb f2                	jmp    8012c0 <dev_lookup+0x4d>

008012ce <fd_close>:
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	57                   	push   %edi
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 24             	sub    $0x24,%esp
  8012d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012da:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ea:	50                   	push   %eax
  8012eb:	e8 33 ff ff ff       	call   801223 <fd_lookup>
  8012f0:	89 c3                	mov    %eax,%ebx
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 05                	js     8012fe <fd_close+0x30>
	    || fd != fd2)
  8012f9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012fc:	74 16                	je     801314 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012fe:	89 f8                	mov    %edi,%eax
  801300:	84 c0                	test   %al,%al
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
  801307:	0f 44 d8             	cmove  %eax,%ebx
}
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	ff 36                	pushl  (%esi)
  80131d:	e8 51 ff ff ff       	call   801273 <dev_lookup>
  801322:	89 c3                	mov    %eax,%ebx
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 1a                	js     801345 <fd_close+0x77>
		if (dev->dev_close)
  80132b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801331:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801336:	85 c0                	test   %eax,%eax
  801338:	74 0b                	je     801345 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	56                   	push   %esi
  80133e:	ff d0                	call   *%eax
  801340:	89 c3                	mov    %eax,%ebx
  801342:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	56                   	push   %esi
  801349:	6a 00                	push   $0x0
  80134b:	e8 0a fc ff ff       	call   800f5a <sys_page_unmap>
	return r;
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	eb b5                	jmp    80130a <fd_close+0x3c>

00801355 <close>:

int
close(int fdnum)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	ff 75 08             	pushl  0x8(%ebp)
  801362:	e8 bc fe ff ff       	call   801223 <fd_lookup>
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	79 02                	jns    801370 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    
		return fd_close(fd, 1);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	6a 01                	push   $0x1
  801375:	ff 75 f4             	pushl  -0xc(%ebp)
  801378:	e8 51 ff ff ff       	call   8012ce <fd_close>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	eb ec                	jmp    80136e <close+0x19>

00801382 <close_all>:

void
close_all(void)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801389:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138e:	83 ec 0c             	sub    $0xc,%esp
  801391:	53                   	push   %ebx
  801392:	e8 be ff ff ff       	call   801355 <close>
	for (i = 0; i < MAXFD; i++)
  801397:	83 c3 01             	add    $0x1,%ebx
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	83 fb 20             	cmp    $0x20,%ebx
  8013a0:	75 ec                	jne    80138e <close_all+0xc>
}
  8013a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	57                   	push   %edi
  8013ab:	56                   	push   %esi
  8013ac:	53                   	push   %ebx
  8013ad:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	ff 75 08             	pushl  0x8(%ebp)
  8013b7:	e8 67 fe ff ff       	call   801223 <fd_lookup>
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	0f 88 81 00 00 00    	js     80144a <dup+0xa3>
		return r;
	close(newfdnum);
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	ff 75 0c             	pushl  0xc(%ebp)
  8013cf:	e8 81 ff ff ff       	call   801355 <close>

	newfd = INDEX2FD(newfdnum);
  8013d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d7:	c1 e6 0c             	shl    $0xc,%esi
  8013da:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013e0:	83 c4 04             	add    $0x4,%esp
  8013e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e6:	e8 cf fd ff ff       	call   8011ba <fd2data>
  8013eb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ed:	89 34 24             	mov    %esi,(%esp)
  8013f0:	e8 c5 fd ff ff       	call   8011ba <fd2data>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	c1 e8 16             	shr    $0x16,%eax
  8013ff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801406:	a8 01                	test   $0x1,%al
  801408:	74 11                	je     80141b <dup+0x74>
  80140a:	89 d8                	mov    %ebx,%eax
  80140c:	c1 e8 0c             	shr    $0xc,%eax
  80140f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801416:	f6 c2 01             	test   $0x1,%dl
  801419:	75 39                	jne    801454 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141e:	89 d0                	mov    %edx,%eax
  801420:	c1 e8 0c             	shr    $0xc,%eax
  801423:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	25 07 0e 00 00       	and    $0xe07,%eax
  801432:	50                   	push   %eax
  801433:	56                   	push   %esi
  801434:	6a 00                	push   $0x0
  801436:	52                   	push   %edx
  801437:	6a 00                	push   $0x0
  801439:	e8 da fa ff ff       	call   800f18 <sys_page_map>
  80143e:	89 c3                	mov    %eax,%ebx
  801440:	83 c4 20             	add    $0x20,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 31                	js     801478 <dup+0xd1>
		goto err;

	return newfdnum;
  801447:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80144a:	89 d8                	mov    %ebx,%eax
  80144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801454:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	25 07 0e 00 00       	and    $0xe07,%eax
  801463:	50                   	push   %eax
  801464:	57                   	push   %edi
  801465:	6a 00                	push   $0x0
  801467:	53                   	push   %ebx
  801468:	6a 00                	push   $0x0
  80146a:	e8 a9 fa ff ff       	call   800f18 <sys_page_map>
  80146f:	89 c3                	mov    %eax,%ebx
  801471:	83 c4 20             	add    $0x20,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	79 a3                	jns    80141b <dup+0x74>
	sys_page_unmap(0, newfd);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	56                   	push   %esi
  80147c:	6a 00                	push   $0x0
  80147e:	e8 d7 fa ff ff       	call   800f5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801483:	83 c4 08             	add    $0x8,%esp
  801486:	57                   	push   %edi
  801487:	6a 00                	push   $0x0
  801489:	e8 cc fa ff ff       	call   800f5a <sys_page_unmap>
	return r;
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	eb b7                	jmp    80144a <dup+0xa3>

00801493 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 1c             	sub    $0x1c,%esp
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	53                   	push   %ebx
  8014a2:	e8 7c fd ff ff       	call   801223 <fd_lookup>
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 3f                	js     8014ed <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b4:	50                   	push   %eax
  8014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b8:	ff 30                	pushl  (%eax)
  8014ba:	e8 b4 fd ff ff       	call   801273 <dev_lookup>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 27                	js     8014ed <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c9:	8b 42 08             	mov    0x8(%edx),%eax
  8014cc:	83 e0 03             	and    $0x3,%eax
  8014cf:	83 f8 01             	cmp    $0x1,%eax
  8014d2:	74 1e                	je     8014f2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d7:	8b 40 08             	mov    0x8(%eax),%eax
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 35                	je     801513 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	ff 75 10             	pushl  0x10(%ebp)
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	52                   	push   %edx
  8014e8:	ff d0                	call   *%eax
  8014ea:	83 c4 10             	add    $0x10,%esp
}
  8014ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014f7:	8b 40 48             	mov    0x48(%eax),%eax
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	50                   	push   %eax
  8014ff:	68 98 2c 80 00       	push   $0x802c98
  801504:	e8 7b ee ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb da                	jmp    8014ed <read+0x5a>
		return -E_NOT_SUPP;
  801513:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801518:	eb d3                	jmp    8014ed <read+0x5a>

0080151a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 0c             	sub    $0xc,%esp
  801523:	8b 7d 08             	mov    0x8(%ebp),%edi
  801526:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801529:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152e:	39 f3                	cmp    %esi,%ebx
  801530:	73 23                	jae    801555 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	89 f0                	mov    %esi,%eax
  801537:	29 d8                	sub    %ebx,%eax
  801539:	50                   	push   %eax
  80153a:	89 d8                	mov    %ebx,%eax
  80153c:	03 45 0c             	add    0xc(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	57                   	push   %edi
  801541:	e8 4d ff ff ff       	call   801493 <read>
		if (m < 0)
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 06                	js     801553 <readn+0x39>
			return m;
		if (m == 0)
  80154d:	74 06                	je     801555 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80154f:	01 c3                	add    %eax,%ebx
  801551:	eb db                	jmp    80152e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801553:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	53                   	push   %ebx
  801563:	83 ec 1c             	sub    $0x1c,%esp
  801566:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801569:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156c:	50                   	push   %eax
  80156d:	53                   	push   %ebx
  80156e:	e8 b0 fc ff ff       	call   801223 <fd_lookup>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 3a                	js     8015b4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	ff 30                	pushl  (%eax)
  801586:	e8 e8 fc ff ff       	call   801273 <dev_lookup>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 22                	js     8015b4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801599:	74 1e                	je     8015b9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	8b 52 0c             	mov    0xc(%edx),%edx
  8015a1:	85 d2                	test   %edx,%edx
  8015a3:	74 35                	je     8015da <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	ff 75 10             	pushl  0x10(%ebp)
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	50                   	push   %eax
  8015af:	ff d2                	call   *%edx
  8015b1:	83 c4 10             	add    $0x10,%esp
}
  8015b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015be:	8b 40 48             	mov    0x48(%eax),%eax
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	53                   	push   %ebx
  8015c5:	50                   	push   %eax
  8015c6:	68 b4 2c 80 00       	push   $0x802cb4
  8015cb:	e8 b4 ed ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb da                	jmp    8015b4 <write+0x55>
		return -E_NOT_SUPP;
  8015da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015df:	eb d3                	jmp    8015b4 <write+0x55>

008015e1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 30 fc ff ff       	call   801223 <fd_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 0e                	js     801608 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 1c             	sub    $0x1c,%esp
  801611:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801614:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	53                   	push   %ebx
  801619:	e8 05 fc ff ff       	call   801223 <fd_lookup>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 37                	js     80165c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	ff 30                	pushl  (%eax)
  801631:	e8 3d fc ff ff       	call   801273 <dev_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 1f                	js     80165c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801644:	74 1b                	je     801661 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 52 18             	mov    0x18(%edx),%edx
  80164c:	85 d2                	test   %edx,%edx
  80164e:	74 32                	je     801682 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	50                   	push   %eax
  801657:	ff d2                	call   *%edx
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
			thisenv->env_id, fdnum);
  801661:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801666:	8b 40 48             	mov    0x48(%eax),%eax
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	53                   	push   %ebx
  80166d:	50                   	push   %eax
  80166e:	68 74 2c 80 00       	push   $0x802c74
  801673:	e8 0c ed ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801680:	eb da                	jmp    80165c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801682:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801687:	eb d3                	jmp    80165c <ftruncate+0x52>

00801689 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 1c             	sub    $0x1c,%esp
  801690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801693:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 84 fb ff ff       	call   801223 <fd_lookup>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 4b                	js     8016f1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	ff 30                	pushl  (%eax)
  8016b2:	e8 bc fb ff ff       	call   801273 <dev_lookup>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 33                	js     8016f1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c5:	74 2f                	je     8016f6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d1:	00 00 00 
	stat->st_isdir = 0;
  8016d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016db:	00 00 00 
	stat->st_dev = dev;
  8016de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016eb:	ff 50 14             	call   *0x14(%eax)
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb f4                	jmp    8016f1 <fstat+0x68>

008016fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	6a 00                	push   $0x0
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	e8 22 02 00 00       	call   801931 <open>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 1b                	js     801733 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	e8 65 ff ff ff       	call   801689 <fstat>
  801724:	89 c6                	mov    %eax,%esi
	close(fd);
  801726:	89 1c 24             	mov    %ebx,(%esp)
  801729:	e8 27 fc ff ff       	call   801355 <close>
	return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 f3                	mov    %esi,%ebx
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	89 c6                	mov    %eax,%esi
  801743:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801745:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80174c:	74 27                	je     801775 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174e:	6a 07                	push   $0x7
  801750:	68 00 50 80 00       	push   $0x805000
  801755:	56                   	push   %esi
  801756:	ff 35 04 40 80 00    	pushl  0x804004
  80175c:	e8 1c 0d 00 00       	call   80247d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801761:	83 c4 0c             	add    $0xc,%esp
  801764:	6a 00                	push   $0x0
  801766:	53                   	push   %ebx
  801767:	6a 00                	push   $0x0
  801769:	e8 a6 0c 00 00       	call   802414 <ipc_recv>
}
  80176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	6a 01                	push   $0x1
  80177a:	e8 56 0d 00 00       	call   8024d5 <ipc_find_env>
  80177f:	a3 04 40 80 00       	mov    %eax,0x804004
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	eb c5                	jmp    80174e <fsipc+0x12>

00801789 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ac:	e8 8b ff ff ff       	call   80173c <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_flush>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	e8 69 ff ff ff       	call   80173c <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_stat>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f4:	e8 43 ff ff ff       	call   80173c <fsipc>
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 2c                	js     801829 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	68 00 50 80 00       	push   $0x805000
  801805:	53                   	push   %ebx
  801806:	e8 d8 f2 ff ff       	call   800ae3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80180b:	a1 80 50 80 00       	mov    0x805080,%eax
  801810:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801816:	a1 84 50 80 00       	mov    0x805084,%eax
  80181b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <devfile_write>:
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	53                   	push   %ebx
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8b 40 0c             	mov    0xc(%eax),%eax
  80183e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801843:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801849:	53                   	push   %ebx
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	68 08 50 80 00       	push   $0x805008
  801852:	e8 7c f4 ff ff       	call   800cd3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	b8 04 00 00 00       	mov    $0x4,%eax
  801861:	e8 d6 fe ff ff       	call   80173c <fsipc>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 0b                	js     801878 <devfile_write+0x4a>
	assert(r <= n);
  80186d:	39 d8                	cmp    %ebx,%eax
  80186f:	77 0c                	ja     80187d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801871:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801876:	7f 1e                	jg     801896 <devfile_write+0x68>
}
  801878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    
	assert(r <= n);
  80187d:	68 e8 2c 80 00       	push   $0x802ce8
  801882:	68 ef 2c 80 00       	push   $0x802cef
  801887:	68 98 00 00 00       	push   $0x98
  80188c:	68 04 2d 80 00       	push   $0x802d04
  801891:	e8 f8 e9 ff ff       	call   80028e <_panic>
	assert(r <= PGSIZE);
  801896:	68 0f 2d 80 00       	push   $0x802d0f
  80189b:	68 ef 2c 80 00       	push   $0x802cef
  8018a0:	68 99 00 00 00       	push   $0x99
  8018a5:	68 04 2d 80 00       	push   $0x802d04
  8018aa:	e8 df e9 ff ff       	call   80028e <_panic>

008018af <devfile_read>:
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d2:	e8 65 fe ff ff       	call   80173c <fsipc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1f                	js     8018fc <devfile_read+0x4d>
	assert(r <= n);
  8018dd:	39 f0                	cmp    %esi,%eax
  8018df:	77 24                	ja     801905 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e6:	7f 33                	jg     80191b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	50                   	push   %eax
  8018ec:	68 00 50 80 00       	push   $0x805000
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	e8 78 f3 ff ff       	call   800c71 <memmove>
	return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
}
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
	assert(r <= n);
  801905:	68 e8 2c 80 00       	push   $0x802ce8
  80190a:	68 ef 2c 80 00       	push   $0x802cef
  80190f:	6a 7c                	push   $0x7c
  801911:	68 04 2d 80 00       	push   $0x802d04
  801916:	e8 73 e9 ff ff       	call   80028e <_panic>
	assert(r <= PGSIZE);
  80191b:	68 0f 2d 80 00       	push   $0x802d0f
  801920:	68 ef 2c 80 00       	push   $0x802cef
  801925:	6a 7d                	push   $0x7d
  801927:	68 04 2d 80 00       	push   $0x802d04
  80192c:	e8 5d e9 ff ff       	call   80028e <_panic>

00801931 <open>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 1c             	sub    $0x1c,%esp
  801939:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80193c:	56                   	push   %esi
  80193d:	e8 68 f1 ff ff       	call   800aaa <strlen>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194a:	7f 6c                	jg     8019b8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	e8 79 f8 ff ff       	call   8011d1 <fd_alloc>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 3c                	js     80199d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	56                   	push   %esi
  801965:	68 00 50 80 00       	push   $0x805000
  80196a:	e8 74 f1 ff ff       	call   800ae3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
  80197f:	e8 b8 fd ff ff       	call   80173c <fsipc>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 19                	js     8019a6 <open+0x75>
	return fd2num(fd);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	ff 75 f4             	pushl  -0xc(%ebp)
  801993:	e8 12 f8 ff ff       	call   8011aa <fd2num>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
}
  80199d:	89 d8                	mov    %ebx,%eax
  80199f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    
		fd_close(fd, 0);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ae:	e8 1b f9 ff ff       	call   8012ce <fd_close>
		return r;
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	eb e5                	jmp    80199d <open+0x6c>
		return -E_BAD_PATH;
  8019b8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019bd:	eb de                	jmp    80199d <open+0x6c>

008019bf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cf:	e8 68 fd ff ff       	call   80173c <fsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019d6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019da:	7f 01                	jg     8019dd <writebuf+0x7>
  8019dc:	c3                   	ret    
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	53                   	push   %ebx
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019e6:	ff 70 04             	pushl  0x4(%eax)
  8019e9:	8d 40 10             	lea    0x10(%eax),%eax
  8019ec:	50                   	push   %eax
  8019ed:	ff 33                	pushl  (%ebx)
  8019ef:	e8 6b fb ff ff       	call   80155f <write>
		if (result > 0)
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	7e 03                	jle    8019fe <writebuf+0x28>
			b->result += result;
  8019fb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019fe:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a01:	74 0d                	je     801a10 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a03:	85 c0                	test   %eax,%eax
  801a05:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0a:	0f 4f c2             	cmovg  %edx,%eax
  801a0d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <putch>:

static void
putch(int ch, void *thunk)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	53                   	push   %ebx
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a1f:	8b 53 04             	mov    0x4(%ebx),%edx
  801a22:	8d 42 01             	lea    0x1(%edx),%eax
  801a25:	89 43 04             	mov    %eax,0x4(%ebx)
  801a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2b:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a2f:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a34:	74 06                	je     801a3c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a36:	83 c4 04             	add    $0x4,%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
		writebuf(b);
  801a3c:	89 d8                	mov    %ebx,%eax
  801a3e:	e8 93 ff ff ff       	call   8019d6 <writebuf>
		b->idx = 0;
  801a43:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a4a:	eb ea                	jmp    801a36 <putch+0x21>

00801a4c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a5e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a65:	00 00 00 
	b.result = 0;
  801a68:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a6f:	00 00 00 
	b.error = 1;
  801a72:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a79:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a7c:	ff 75 10             	pushl  0x10(%ebp)
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a88:	50                   	push   %eax
  801a89:	68 15 1a 80 00       	push   $0x801a15
  801a8e:	e8 1e ea ff ff       	call   8004b1 <vprintfmt>
	if (b.idx > 0)
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a9d:	7f 11                	jg     801ab0 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a9f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    
		writebuf(&b);
  801ab0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ab6:	e8 1b ff ff ff       	call   8019d6 <writebuf>
  801abb:	eb e2                	jmp    801a9f <vfprintf+0x53>

00801abd <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ac3:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ac6:	50                   	push   %eax
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	e8 7a ff ff ff       	call   801a4c <vfprintf>
	va_end(ap);

	return cnt;
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <printf>:

int
printf(const char *fmt, ...)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ada:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801add:	50                   	push   %eax
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 01                	push   $0x1
  801ae3:	e8 64 ff ff ff       	call   801a4c <vfprintf>
	va_end(ap);

	return cnt;
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801af0:	68 1b 2d 80 00       	push   $0x802d1b
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	e8 e6 ef ff ff       	call   800ae3 <strcpy>
	return 0;
}
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <devsock_close>:
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	53                   	push   %ebx
  801b08:	83 ec 10             	sub    $0x10,%esp
  801b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b0e:	53                   	push   %ebx
  801b0f:	e8 fc 09 00 00       	call   802510 <pageref>
  801b14:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b1c:	83 f8 01             	cmp    $0x1,%eax
  801b1f:	74 07                	je     801b28 <devsock_close+0x24>
}
  801b21:	89 d0                	mov    %edx,%eax
  801b23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	ff 73 0c             	pushl  0xc(%ebx)
  801b2e:	e8 b9 02 00 00       	call   801dec <nsipc_close>
  801b33:	89 c2                	mov    %eax,%edx
  801b35:	83 c4 10             	add    $0x10,%esp
  801b38:	eb e7                	jmp    801b21 <devsock_close+0x1d>

00801b3a <devsock_write>:
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	ff 70 0c             	pushl  0xc(%eax)
  801b4e:	e8 76 03 00 00       	call   801ec9 <nsipc_send>
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <devsock_read>:
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 10             	pushl  0x10(%ebp)
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	ff 70 0c             	pushl  0xc(%eax)
  801b69:	e8 ef 02 00 00       	call   801e5d <nsipc_recv>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <fd2sockid>:
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b76:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	e8 a3 f6 ff ff       	call   801223 <fd_lookup>
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 10                	js     801b97 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8a:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b90:	39 08                	cmp    %ecx,(%eax)
  801b92:	75 05                	jne    801b99 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b94:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    
		return -E_NOT_SUPP;
  801b99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b9e:	eb f7                	jmp    801b97 <fd2sockid+0x27>

00801ba0 <alloc_sockfd>:
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 1c             	sub    $0x1c,%esp
  801ba8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801baa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	e8 1e f6 ff ff       	call   8011d1 <fd_alloc>
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 43                	js     801bff <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	68 07 04 00 00       	push   $0x407
  801bc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc7:	6a 00                	push   $0x0
  801bc9:	e8 07 f3 ff ff       	call   800ed5 <sys_page_alloc>
  801bce:	89 c3                	mov    %eax,%ebx
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 28                	js     801bff <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801be0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bef:	83 ec 0c             	sub    $0xc,%esp
  801bf2:	50                   	push   %eax
  801bf3:	e8 b2 f5 ff ff       	call   8011aa <fd2num>
  801bf8:	89 c3                	mov    %eax,%ebx
  801bfa:	83 c4 10             	add    $0x10,%esp
  801bfd:	eb 0c                	jmp    801c0b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bff:	83 ec 0c             	sub    $0xc,%esp
  801c02:	56                   	push   %esi
  801c03:	e8 e4 01 00 00       	call   801dec <nsipc_close>
		return r;
  801c08:	83 c4 10             	add    $0x10,%esp
}
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    

00801c14 <accept>:
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	e8 4e ff ff ff       	call   801b70 <fd2sockid>
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 1b                	js     801c41 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	ff 75 10             	pushl  0x10(%ebp)
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	50                   	push   %eax
  801c30:	e8 0e 01 00 00       	call   801d43 <nsipc_accept>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	78 05                	js     801c41 <accept+0x2d>
	return alloc_sockfd(r);
  801c3c:	e8 5f ff ff ff       	call   801ba0 <alloc_sockfd>
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <bind>:
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	e8 1f ff ff ff       	call   801b70 <fd2sockid>
  801c51:	85 c0                	test   %eax,%eax
  801c53:	78 12                	js     801c67 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c55:	83 ec 04             	sub    $0x4,%esp
  801c58:	ff 75 10             	pushl  0x10(%ebp)
  801c5b:	ff 75 0c             	pushl  0xc(%ebp)
  801c5e:	50                   	push   %eax
  801c5f:	e8 31 01 00 00       	call   801d95 <nsipc_bind>
  801c64:	83 c4 10             	add    $0x10,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <shutdown>:
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	e8 f9 fe ff ff       	call   801b70 <fd2sockid>
  801c77:	85 c0                	test   %eax,%eax
  801c79:	78 0f                	js     801c8a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c7b:	83 ec 08             	sub    $0x8,%esp
  801c7e:	ff 75 0c             	pushl  0xc(%ebp)
  801c81:	50                   	push   %eax
  801c82:	e8 43 01 00 00       	call   801dca <nsipc_shutdown>
  801c87:	83 c4 10             	add    $0x10,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <connect>:
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	e8 d6 fe ff ff       	call   801b70 <fd2sockid>
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	78 12                	js     801cb0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	ff 75 10             	pushl  0x10(%ebp)
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	50                   	push   %eax
  801ca8:	e8 59 01 00 00       	call   801e06 <nsipc_connect>
  801cad:	83 c4 10             	add    $0x10,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <listen>:
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	e8 b0 fe ff ff       	call   801b70 <fd2sockid>
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 0f                	js     801cd3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	ff 75 0c             	pushl  0xc(%ebp)
  801cca:	50                   	push   %eax
  801ccb:	e8 6b 01 00 00       	call   801e3b <nsipc_listen>
  801cd0:	83 c4 10             	add    $0x10,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cdb:	ff 75 10             	pushl  0x10(%ebp)
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	e8 3e 02 00 00       	call   801f27 <nsipc_socket>
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 05                	js     801cf5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801cf0:	e8 ab fe ff ff       	call   801ba0 <alloc_sockfd>
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d00:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801d07:	74 26                	je     801d2f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d09:	6a 07                	push   $0x7
  801d0b:	68 00 60 80 00       	push   $0x806000
  801d10:	53                   	push   %ebx
  801d11:	ff 35 08 40 80 00    	pushl  0x804008
  801d17:	e8 61 07 00 00       	call   80247d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d1c:	83 c4 0c             	add    $0xc,%esp
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	e8 ea 06 00 00       	call   802414 <ipc_recv>
}
  801d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	6a 02                	push   $0x2
  801d34:	e8 9c 07 00 00       	call   8024d5 <ipc_find_env>
  801d39:	a3 08 40 80 00       	mov    %eax,0x804008
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	eb c6                	jmp    801d09 <nsipc+0x12>

00801d43 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d53:	8b 06                	mov    (%esi),%eax
  801d55:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	e8 93 ff ff ff       	call   801cf7 <nsipc>
  801d64:	89 c3                	mov    %eax,%ebx
  801d66:	85 c0                	test   %eax,%eax
  801d68:	79 09                	jns    801d73 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d6a:	89 d8                	mov    %ebx,%eax
  801d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	ff 35 10 60 80 00    	pushl  0x806010
  801d7c:	68 00 60 80 00       	push   $0x806000
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	e8 e8 ee ff ff       	call   800c71 <memmove>
		*addrlen = ret->ret_addrlen;
  801d89:	a1 10 60 80 00       	mov    0x806010,%eax
  801d8e:	89 06                	mov    %eax,(%esi)
  801d90:	83 c4 10             	add    $0x10,%esp
	return r;
  801d93:	eb d5                	jmp    801d6a <nsipc_accept+0x27>

00801d95 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801da7:	53                   	push   %ebx
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	68 04 60 80 00       	push   $0x806004
  801db0:	e8 bc ee ff ff       	call   800c71 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801db5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801dbb:	b8 02 00 00 00       	mov    $0x2,%eax
  801dc0:	e8 32 ff ff ff       	call   801cf7 <nsipc>
}
  801dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801de0:	b8 03 00 00 00       	mov    $0x3,%eax
  801de5:	e8 0d ff ff ff       	call   801cf7 <nsipc>
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <nsipc_close>:

int
nsipc_close(int s)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dfa:	b8 04 00 00 00       	mov    $0x4,%eax
  801dff:	e8 f3 fe ff ff       	call   801cf7 <nsipc>
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 08             	sub    $0x8,%esp
  801e0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e18:	53                   	push   %ebx
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	68 04 60 80 00       	push   $0x806004
  801e21:	e8 4b ee ff ff       	call   800c71 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e26:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e2c:	b8 05 00 00 00       	mov    $0x5,%eax
  801e31:	e8 c1 fe ff ff       	call   801cf7 <nsipc>
}
  801e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e51:	b8 06 00 00 00       	mov    $0x6,%eax
  801e56:	e8 9c fe ff ff       	call   801cf7 <nsipc>
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e6d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e73:	8b 45 14             	mov    0x14(%ebp),%eax
  801e76:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e7b:	b8 07 00 00 00       	mov    $0x7,%eax
  801e80:	e8 72 fe ff ff       	call   801cf7 <nsipc>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	85 c0                	test   %eax,%eax
  801e89:	78 1f                	js     801eaa <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801e8b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e90:	7f 21                	jg     801eb3 <nsipc_recv+0x56>
  801e92:	39 c6                	cmp    %eax,%esi
  801e94:	7c 1d                	jl     801eb3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	50                   	push   %eax
  801e9a:	68 00 60 80 00       	push   $0x806000
  801e9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ea2:	e8 ca ed ff ff       	call   800c71 <memmove>
  801ea7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801eaa:	89 d8                	mov    %ebx,%eax
  801eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801eb3:	68 27 2d 80 00       	push   $0x802d27
  801eb8:	68 ef 2c 80 00       	push   $0x802cef
  801ebd:	6a 62                	push   $0x62
  801ebf:	68 3c 2d 80 00       	push   $0x802d3c
  801ec4:	e8 c5 e3 ff ff       	call   80028e <_panic>

00801ec9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801edb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ee1:	7f 2e                	jg     801f11 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	53                   	push   %ebx
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	68 0c 60 80 00       	push   $0x80600c
  801eef:	e8 7d ed ff ff       	call   800c71 <memmove>
	nsipcbuf.send.req_size = size;
  801ef4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801efa:	8b 45 14             	mov    0x14(%ebp),%eax
  801efd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f02:	b8 08 00 00 00       	mov    $0x8,%eax
  801f07:	e8 eb fd ff ff       	call   801cf7 <nsipc>
}
  801f0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    
	assert(size < 1600);
  801f11:	68 48 2d 80 00       	push   $0x802d48
  801f16:	68 ef 2c 80 00       	push   $0x802cef
  801f1b:	6a 6d                	push   $0x6d
  801f1d:	68 3c 2d 80 00       	push   $0x802d3c
  801f22:	e8 67 e3 ff ff       	call   80028e <_panic>

00801f27 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f40:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f45:	b8 09 00 00 00       	mov    $0x9,%eax
  801f4a:	e8 a8 fd ff ff       	call   801cf7 <nsipc>
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	ff 75 08             	pushl  0x8(%ebp)
  801f5f:	e8 56 f2 ff ff       	call   8011ba <fd2data>
  801f64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f66:	83 c4 08             	add    $0x8,%esp
  801f69:	68 54 2d 80 00       	push   $0x802d54
  801f6e:	53                   	push   %ebx
  801f6f:	e8 6f eb ff ff       	call   800ae3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f74:	8b 46 04             	mov    0x4(%esi),%eax
  801f77:	2b 06                	sub    (%esi),%eax
  801f79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f86:	00 00 00 
	stat->st_dev = &devpipe;
  801f89:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801f90:	30 80 00 
	return 0;
}
  801f93:	b8 00 00 00 00       	mov    $0x0,%eax
  801f98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5e                   	pop    %esi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	53                   	push   %ebx
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fa9:	53                   	push   %ebx
  801faa:	6a 00                	push   $0x0
  801fac:	e8 a9 ef ff ff       	call   800f5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fb1:	89 1c 24             	mov    %ebx,(%esp)
  801fb4:	e8 01 f2 ff ff       	call   8011ba <fd2data>
  801fb9:	83 c4 08             	add    $0x8,%esp
  801fbc:	50                   	push   %eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 96 ef ff ff       	call   800f5a <sys_page_unmap>
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <_pipeisclosed>:
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	57                   	push   %edi
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 1c             	sub    $0x1c,%esp
  801fd2:	89 c7                	mov    %eax,%edi
  801fd4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801fd6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801fdb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	57                   	push   %edi
  801fe2:	e8 29 05 00 00       	call   802510 <pageref>
  801fe7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fea:	89 34 24             	mov    %esi,(%esp)
  801fed:	e8 1e 05 00 00       	call   802510 <pageref>
		nn = thisenv->env_runs;
  801ff2:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801ff8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	39 cb                	cmp    %ecx,%ebx
  802000:	74 1b                	je     80201d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802002:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802005:	75 cf                	jne    801fd6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802007:	8b 42 58             	mov    0x58(%edx),%eax
  80200a:	6a 01                	push   $0x1
  80200c:	50                   	push   %eax
  80200d:	53                   	push   %ebx
  80200e:	68 5b 2d 80 00       	push   $0x802d5b
  802013:	e8 6c e3 ff ff       	call   800384 <cprintf>
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	eb b9                	jmp    801fd6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80201d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802020:	0f 94 c0             	sete   %al
  802023:	0f b6 c0             	movzbl %al,%eax
}
  802026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5f                   	pop    %edi
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <devpipe_write>:
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 28             	sub    $0x28,%esp
  802037:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80203a:	56                   	push   %esi
  80203b:	e8 7a f1 ff ff       	call   8011ba <fd2data>
  802040:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	bf 00 00 00 00       	mov    $0x0,%edi
  80204a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80204d:	74 4f                	je     80209e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80204f:	8b 43 04             	mov    0x4(%ebx),%eax
  802052:	8b 0b                	mov    (%ebx),%ecx
  802054:	8d 51 20             	lea    0x20(%ecx),%edx
  802057:	39 d0                	cmp    %edx,%eax
  802059:	72 14                	jb     80206f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80205b:	89 da                	mov    %ebx,%edx
  80205d:	89 f0                	mov    %esi,%eax
  80205f:	e8 65 ff ff ff       	call   801fc9 <_pipeisclosed>
  802064:	85 c0                	test   %eax,%eax
  802066:	75 3b                	jne    8020a3 <devpipe_write+0x75>
			sys_yield();
  802068:	e8 49 ee ff ff       	call   800eb6 <sys_yield>
  80206d:	eb e0                	jmp    80204f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80206f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802072:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802076:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802079:	89 c2                	mov    %eax,%edx
  80207b:	c1 fa 1f             	sar    $0x1f,%edx
  80207e:	89 d1                	mov    %edx,%ecx
  802080:	c1 e9 1b             	shr    $0x1b,%ecx
  802083:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802086:	83 e2 1f             	and    $0x1f,%edx
  802089:	29 ca                	sub    %ecx,%edx
  80208b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80208f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802093:	83 c0 01             	add    $0x1,%eax
  802096:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802099:	83 c7 01             	add    $0x1,%edi
  80209c:	eb ac                	jmp    80204a <devpipe_write+0x1c>
	return i;
  80209e:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a1:	eb 05                	jmp    8020a8 <devpipe_write+0x7a>
				return 0;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

008020b0 <devpipe_read>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	57                   	push   %edi
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
  8020b6:	83 ec 18             	sub    $0x18,%esp
  8020b9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020bc:	57                   	push   %edi
  8020bd:	e8 f8 f0 ff ff       	call   8011ba <fd2data>
  8020c2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	be 00 00 00 00       	mov    $0x0,%esi
  8020cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020cf:	75 14                	jne    8020e5 <devpipe_read+0x35>
	return i;
  8020d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d4:	eb 02                	jmp    8020d8 <devpipe_read+0x28>
				return i;
  8020d6:	89 f0                	mov    %esi,%eax
}
  8020d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5e                   	pop    %esi
  8020dd:	5f                   	pop    %edi
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    
			sys_yield();
  8020e0:	e8 d1 ed ff ff       	call   800eb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8020e5:	8b 03                	mov    (%ebx),%eax
  8020e7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020ea:	75 18                	jne    802104 <devpipe_read+0x54>
			if (i > 0)
  8020ec:	85 f6                	test   %esi,%esi
  8020ee:	75 e6                	jne    8020d6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8020f0:	89 da                	mov    %ebx,%edx
  8020f2:	89 f8                	mov    %edi,%eax
  8020f4:	e8 d0 fe ff ff       	call   801fc9 <_pipeisclosed>
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	74 e3                	je     8020e0 <devpipe_read+0x30>
				return 0;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	eb d4                	jmp    8020d8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802104:	99                   	cltd   
  802105:	c1 ea 1b             	shr    $0x1b,%edx
  802108:	01 d0                	add    %edx,%eax
  80210a:	83 e0 1f             	and    $0x1f,%eax
  80210d:	29 d0                	sub    %edx,%eax
  80210f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802114:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802117:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80211a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80211d:	83 c6 01             	add    $0x1,%esi
  802120:	eb aa                	jmp    8020cc <devpipe_read+0x1c>

00802122 <pipe>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	56                   	push   %esi
  802126:	53                   	push   %ebx
  802127:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80212a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212d:	50                   	push   %eax
  80212e:	e8 9e f0 ff ff       	call   8011d1 <fd_alloc>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	0f 88 23 01 00 00    	js     802263 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 07 04 00 00       	push   $0x407
  802148:	ff 75 f4             	pushl  -0xc(%ebp)
  80214b:	6a 00                	push   $0x0
  80214d:	e8 83 ed ff ff       	call   800ed5 <sys_page_alloc>
  802152:	89 c3                	mov    %eax,%ebx
  802154:	83 c4 10             	add    $0x10,%esp
  802157:	85 c0                	test   %eax,%eax
  802159:	0f 88 04 01 00 00    	js     802263 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802165:	50                   	push   %eax
  802166:	e8 66 f0 ff ff       	call   8011d1 <fd_alloc>
  80216b:	89 c3                	mov    %eax,%ebx
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	0f 88 db 00 00 00    	js     802253 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 07 04 00 00       	push   $0x407
  802180:	ff 75 f0             	pushl  -0x10(%ebp)
  802183:	6a 00                	push   $0x0
  802185:	e8 4b ed ff ff       	call   800ed5 <sys_page_alloc>
  80218a:	89 c3                	mov    %eax,%ebx
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	85 c0                	test   %eax,%eax
  802191:	0f 88 bc 00 00 00    	js     802253 <pipe+0x131>
	va = fd2data(fd0);
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	ff 75 f4             	pushl  -0xc(%ebp)
  80219d:	e8 18 f0 ff ff       	call   8011ba <fd2data>
  8021a2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a4:	83 c4 0c             	add    $0xc,%esp
  8021a7:	68 07 04 00 00       	push   $0x407
  8021ac:	50                   	push   %eax
  8021ad:	6a 00                	push   $0x0
  8021af:	e8 21 ed ff ff       	call   800ed5 <sys_page_alloc>
  8021b4:	89 c3                	mov    %eax,%ebx
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	0f 88 82 00 00 00    	js     802243 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c7:	e8 ee ef ff ff       	call   8011ba <fd2data>
  8021cc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021d3:	50                   	push   %eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	56                   	push   %esi
  8021d7:	6a 00                	push   $0x0
  8021d9:	e8 3a ed ff ff       	call   800f18 <sys_page_map>
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	83 c4 20             	add    $0x20,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 4e                	js     802235 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8021e7:	a1 40 30 80 00       	mov    0x803040,%eax
  8021ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ef:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021fe:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80220a:	83 ec 0c             	sub    $0xc,%esp
  80220d:	ff 75 f4             	pushl  -0xc(%ebp)
  802210:	e8 95 ef ff ff       	call   8011aa <fd2num>
  802215:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802218:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80221a:	83 c4 04             	add    $0x4,%esp
  80221d:	ff 75 f0             	pushl  -0x10(%ebp)
  802220:	e8 85 ef ff ff       	call   8011aa <fd2num>
  802225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802228:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802233:	eb 2e                	jmp    802263 <pipe+0x141>
	sys_page_unmap(0, va);
  802235:	83 ec 08             	sub    $0x8,%esp
  802238:	56                   	push   %esi
  802239:	6a 00                	push   $0x0
  80223b:	e8 1a ed ff ff       	call   800f5a <sys_page_unmap>
  802240:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802243:	83 ec 08             	sub    $0x8,%esp
  802246:	ff 75 f0             	pushl  -0x10(%ebp)
  802249:	6a 00                	push   $0x0
  80224b:	e8 0a ed ff ff       	call   800f5a <sys_page_unmap>
  802250:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802253:	83 ec 08             	sub    $0x8,%esp
  802256:	ff 75 f4             	pushl  -0xc(%ebp)
  802259:	6a 00                	push   $0x0
  80225b:	e8 fa ec ff ff       	call   800f5a <sys_page_unmap>
  802260:	83 c4 10             	add    $0x10,%esp
}
  802263:	89 d8                	mov    %ebx,%eax
  802265:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802268:	5b                   	pop    %ebx
  802269:	5e                   	pop    %esi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    

0080226c <pipeisclosed>:
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802272:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802275:	50                   	push   %eax
  802276:	ff 75 08             	pushl  0x8(%ebp)
  802279:	e8 a5 ef ff ff       	call   801223 <fd_lookup>
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	85 c0                	test   %eax,%eax
  802283:	78 18                	js     80229d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	ff 75 f4             	pushl  -0xc(%ebp)
  80228b:	e8 2a ef ff ff       	call   8011ba <fd2data>
	return _pipeisclosed(fd, p);
  802290:	89 c2                	mov    %eax,%edx
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	e8 2f fd ff ff       	call   801fc9 <_pipeisclosed>
  80229a:	83 c4 10             	add    $0x10,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	c3                   	ret    

008022a5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022ab:	68 73 2d 80 00       	push   $0x802d73
  8022b0:	ff 75 0c             	pushl  0xc(%ebp)
  8022b3:	e8 2b e8 ff ff       	call   800ae3 <strcpy>
	return 0;
}
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <devcons_write>:
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	57                   	push   %edi
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022cb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022d0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022d6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022d9:	73 31                	jae    80230c <devcons_write+0x4d>
		m = n - tot;
  8022db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022de:	29 f3                	sub    %esi,%ebx
  8022e0:	83 fb 7f             	cmp    $0x7f,%ebx
  8022e3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022e8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	53                   	push   %ebx
  8022ef:	89 f0                	mov    %esi,%eax
  8022f1:	03 45 0c             	add    0xc(%ebp),%eax
  8022f4:	50                   	push   %eax
  8022f5:	57                   	push   %edi
  8022f6:	e8 76 e9 ff ff       	call   800c71 <memmove>
		sys_cputs(buf, m);
  8022fb:	83 c4 08             	add    $0x8,%esp
  8022fe:	53                   	push   %ebx
  8022ff:	57                   	push   %edi
  802300:	e8 14 eb ff ff       	call   800e19 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802305:	01 de                	add    %ebx,%esi
  802307:	83 c4 10             	add    $0x10,%esp
  80230a:	eb ca                	jmp    8022d6 <devcons_write+0x17>
}
  80230c:	89 f0                	mov    %esi,%eax
  80230e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    

00802316 <devcons_read>:
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802325:	74 21                	je     802348 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802327:	e8 0b eb ff ff       	call   800e37 <sys_cgetc>
  80232c:	85 c0                	test   %eax,%eax
  80232e:	75 07                	jne    802337 <devcons_read+0x21>
		sys_yield();
  802330:	e8 81 eb ff ff       	call   800eb6 <sys_yield>
  802335:	eb f0                	jmp    802327 <devcons_read+0x11>
	if (c < 0)
  802337:	78 0f                	js     802348 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802339:	83 f8 04             	cmp    $0x4,%eax
  80233c:	74 0c                	je     80234a <devcons_read+0x34>
	*(char*)vbuf = c;
  80233e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802341:	88 02                	mov    %al,(%edx)
	return 1;
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    
		return 0;
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
  80234f:	eb f7                	jmp    802348 <devcons_read+0x32>

00802351 <cputchar>:
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80235d:	6a 01                	push   $0x1
  80235f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802362:	50                   	push   %eax
  802363:	e8 b1 ea ff ff       	call   800e19 <sys_cputs>
}
  802368:	83 c4 10             	add    $0x10,%esp
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <getchar>:
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802373:	6a 01                	push   $0x1
  802375:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802378:	50                   	push   %eax
  802379:	6a 00                	push   $0x0
  80237b:	e8 13 f1 ff ff       	call   801493 <read>
	if (r < 0)
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	85 c0                	test   %eax,%eax
  802385:	78 06                	js     80238d <getchar+0x20>
	if (r < 1)
  802387:	74 06                	je     80238f <getchar+0x22>
	return c;
  802389:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    
		return -E_EOF;
  80238f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802394:	eb f7                	jmp    80238d <getchar+0x20>

00802396 <iscons>:
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80239c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80239f:	50                   	push   %eax
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	e8 7b ee ff ff       	call   801223 <fd_lookup>
  8023a8:	83 c4 10             	add    $0x10,%esp
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	78 11                	js     8023c0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023b8:	39 10                	cmp    %edx,(%eax)
  8023ba:	0f 94 c0             	sete   %al
  8023bd:	0f b6 c0             	movzbl %al,%eax
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <opencons>:
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023cb:	50                   	push   %eax
  8023cc:	e8 00 ee ff ff       	call   8011d1 <fd_alloc>
  8023d1:	83 c4 10             	add    $0x10,%esp
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	78 3a                	js     802412 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	68 07 04 00 00       	push   $0x407
  8023e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e3:	6a 00                	push   $0x0
  8023e5:	e8 eb ea ff ff       	call   800ed5 <sys_page_alloc>
  8023ea:	83 c4 10             	add    $0x10,%esp
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	78 21                	js     802412 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	50                   	push   %eax
  80240a:	e8 9b ed ff ff       	call   8011aa <fd2num>
  80240f:	83 c4 10             	add    $0x10,%esp
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	56                   	push   %esi
  802418:	53                   	push   %ebx
  802419:	8b 75 08             	mov    0x8(%ebp),%esi
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802422:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802424:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802429:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	50                   	push   %eax
  802430:	e8 50 ec ff ff       	call   801085 <sys_ipc_recv>
	if(ret < 0){
  802435:	83 c4 10             	add    $0x10,%esp
  802438:	85 c0                	test   %eax,%eax
  80243a:	78 2b                	js     802467 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80243c:	85 f6                	test   %esi,%esi
  80243e:	74 0a                	je     80244a <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802440:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802445:	8b 40 74             	mov    0x74(%eax),%eax
  802448:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80244a:	85 db                	test   %ebx,%ebx
  80244c:	74 0a                	je     802458 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80244e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802453:	8b 40 78             	mov    0x78(%eax),%eax
  802456:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802458:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80245d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802460:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802463:	5b                   	pop    %ebx
  802464:	5e                   	pop    %esi
  802465:	5d                   	pop    %ebp
  802466:	c3                   	ret    
		if(from_env_store)
  802467:	85 f6                	test   %esi,%esi
  802469:	74 06                	je     802471 <ipc_recv+0x5d>
			*from_env_store = 0;
  80246b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802471:	85 db                	test   %ebx,%ebx
  802473:	74 eb                	je     802460 <ipc_recv+0x4c>
			*perm_store = 0;
  802475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80247b:	eb e3                	jmp    802460 <ipc_recv+0x4c>

0080247d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	57                   	push   %edi
  802481:	56                   	push   %esi
  802482:	53                   	push   %ebx
  802483:	83 ec 0c             	sub    $0xc,%esp
  802486:	8b 7d 08             	mov    0x8(%ebp),%edi
  802489:	8b 75 0c             	mov    0xc(%ebp),%esi
  80248c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80248f:	85 db                	test   %ebx,%ebx
  802491:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802496:	0f 44 d8             	cmove  %eax,%ebx
  802499:	eb 05                	jmp    8024a0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80249b:	e8 16 ea ff ff       	call   800eb6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8024a0:	ff 75 14             	pushl  0x14(%ebp)
  8024a3:	53                   	push   %ebx
  8024a4:	56                   	push   %esi
  8024a5:	57                   	push   %edi
  8024a6:	e8 b7 eb ff ff       	call   801062 <sys_ipc_try_send>
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 1b                	je     8024cd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8024b2:	79 e7                	jns    80249b <ipc_send+0x1e>
  8024b4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b7:	74 e2                	je     80249b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	68 7f 2d 80 00       	push   $0x802d7f
  8024c1:	6a 4a                	push   $0x4a
  8024c3:	68 94 2d 80 00       	push   $0x802d94
  8024c8:	e8 c1 dd ff ff       	call   80028e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d0:	5b                   	pop    %ebx
  8024d1:	5e                   	pop    %esi
  8024d2:	5f                   	pop    %edi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024db:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024e0:	89 c2                	mov    %eax,%edx
  8024e2:	c1 e2 07             	shl    $0x7,%edx
  8024e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024eb:	8b 52 50             	mov    0x50(%edx),%edx
  8024ee:	39 ca                	cmp    %ecx,%edx
  8024f0:	74 11                	je     802503 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8024f2:	83 c0 01             	add    $0x1,%eax
  8024f5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024fa:	75 e4                	jne    8024e0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802501:	eb 0b                	jmp    80250e <ipc_find_env+0x39>
			return envs[i].env_id;
  802503:	c1 e0 07             	shl    $0x7,%eax
  802506:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80250b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802516:	89 d0                	mov    %edx,%eax
  802518:	c1 e8 16             	shr    $0x16,%eax
  80251b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802522:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802527:	f6 c1 01             	test   $0x1,%cl
  80252a:	74 1d                	je     802549 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80252c:	c1 ea 0c             	shr    $0xc,%edx
  80252f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802536:	f6 c2 01             	test   $0x1,%dl
  802539:	74 0e                	je     802549 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80253b:	c1 ea 0c             	shr    $0xc,%edx
  80253e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802545:	ef 
  802546:	0f b7 c0             	movzwl %ax,%eax
}
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    
  80254b:	66 90                	xchg   %ax,%ax
  80254d:	66 90                	xchg   %ax,%ax
  80254f:	90                   	nop

00802550 <__udivdi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80255b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80255f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802563:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802567:	85 d2                	test   %edx,%edx
  802569:	75 4d                	jne    8025b8 <__udivdi3+0x68>
  80256b:	39 f3                	cmp    %esi,%ebx
  80256d:	76 19                	jbe    802588 <__udivdi3+0x38>
  80256f:	31 ff                	xor    %edi,%edi
  802571:	89 e8                	mov    %ebp,%eax
  802573:	89 f2                	mov    %esi,%edx
  802575:	f7 f3                	div    %ebx
  802577:	89 fa                	mov    %edi,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 d9                	mov    %ebx,%ecx
  80258a:	85 db                	test   %ebx,%ebx
  80258c:	75 0b                	jne    802599 <__udivdi3+0x49>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f3                	div    %ebx
  802597:	89 c1                	mov    %eax,%ecx
  802599:	31 d2                	xor    %edx,%edx
  80259b:	89 f0                	mov    %esi,%eax
  80259d:	f7 f1                	div    %ecx
  80259f:	89 c6                	mov    %eax,%esi
  8025a1:	89 e8                	mov    %ebp,%eax
  8025a3:	89 f7                	mov    %esi,%edi
  8025a5:	f7 f1                	div    %ecx
  8025a7:	89 fa                	mov    %edi,%edx
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	39 f2                	cmp    %esi,%edx
  8025ba:	77 1c                	ja     8025d8 <__udivdi3+0x88>
  8025bc:	0f bd fa             	bsr    %edx,%edi
  8025bf:	83 f7 1f             	xor    $0x1f,%edi
  8025c2:	75 2c                	jne    8025f0 <__udivdi3+0xa0>
  8025c4:	39 f2                	cmp    %esi,%edx
  8025c6:	72 06                	jb     8025ce <__udivdi3+0x7e>
  8025c8:	31 c0                	xor    %eax,%eax
  8025ca:	39 eb                	cmp    %ebp,%ebx
  8025cc:	77 a9                	ja     802577 <__udivdi3+0x27>
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	eb a2                	jmp    802577 <__udivdi3+0x27>
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	31 ff                	xor    %edi,%edi
  8025da:	31 c0                	xor    %eax,%eax
  8025dc:	89 fa                	mov    %edi,%edx
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 f9                	mov    %edi,%ecx
  8025f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8025f7:	29 f8                	sub    %edi,%eax
  8025f9:	d3 e2                	shl    %cl,%edx
  8025fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ff:	89 c1                	mov    %eax,%ecx
  802601:	89 da                	mov    %ebx,%edx
  802603:	d3 ea                	shr    %cl,%edx
  802605:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802609:	09 d1                	or     %edx,%ecx
  80260b:	89 f2                	mov    %esi,%edx
  80260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802611:	89 f9                	mov    %edi,%ecx
  802613:	d3 e3                	shl    %cl,%ebx
  802615:	89 c1                	mov    %eax,%ecx
  802617:	d3 ea                	shr    %cl,%edx
  802619:	89 f9                	mov    %edi,%ecx
  80261b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80261f:	89 eb                	mov    %ebp,%ebx
  802621:	d3 e6                	shl    %cl,%esi
  802623:	89 c1                	mov    %eax,%ecx
  802625:	d3 eb                	shr    %cl,%ebx
  802627:	09 de                	or     %ebx,%esi
  802629:	89 f0                	mov    %esi,%eax
  80262b:	f7 74 24 08          	divl   0x8(%esp)
  80262f:	89 d6                	mov    %edx,%esi
  802631:	89 c3                	mov    %eax,%ebx
  802633:	f7 64 24 0c          	mull   0xc(%esp)
  802637:	39 d6                	cmp    %edx,%esi
  802639:	72 15                	jb     802650 <__udivdi3+0x100>
  80263b:	89 f9                	mov    %edi,%ecx
  80263d:	d3 e5                	shl    %cl,%ebp
  80263f:	39 c5                	cmp    %eax,%ebp
  802641:	73 04                	jae    802647 <__udivdi3+0xf7>
  802643:	39 d6                	cmp    %edx,%esi
  802645:	74 09                	je     802650 <__udivdi3+0x100>
  802647:	89 d8                	mov    %ebx,%eax
  802649:	31 ff                	xor    %edi,%edi
  80264b:	e9 27 ff ff ff       	jmp    802577 <__udivdi3+0x27>
  802650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802653:	31 ff                	xor    %edi,%edi
  802655:	e9 1d ff ff ff       	jmp    802577 <__udivdi3+0x27>
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80266b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80266f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802677:	89 da                	mov    %ebx,%edx
  802679:	85 c0                	test   %eax,%eax
  80267b:	75 43                	jne    8026c0 <__umoddi3+0x60>
  80267d:	39 df                	cmp    %ebx,%edi
  80267f:	76 17                	jbe    802698 <__umoddi3+0x38>
  802681:	89 f0                	mov    %esi,%eax
  802683:	f7 f7                	div    %edi
  802685:	89 d0                	mov    %edx,%eax
  802687:	31 d2                	xor    %edx,%edx
  802689:	83 c4 1c             	add    $0x1c,%esp
  80268c:	5b                   	pop    %ebx
  80268d:	5e                   	pop    %esi
  80268e:	5f                   	pop    %edi
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	89 fd                	mov    %edi,%ebp
  80269a:	85 ff                	test   %edi,%edi
  80269c:	75 0b                	jne    8026a9 <__umoddi3+0x49>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	31 d2                	xor    %edx,%edx
  8026a5:	f7 f7                	div    %edi
  8026a7:	89 c5                	mov    %eax,%ebp
  8026a9:	89 d8                	mov    %ebx,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f5                	div    %ebp
  8026af:	89 f0                	mov    %esi,%eax
  8026b1:	f7 f5                	div    %ebp
  8026b3:	89 d0                	mov    %edx,%eax
  8026b5:	eb d0                	jmp    802687 <__umoddi3+0x27>
  8026b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026be:	66 90                	xchg   %ax,%ax
  8026c0:	89 f1                	mov    %esi,%ecx
  8026c2:	39 d8                	cmp    %ebx,%eax
  8026c4:	76 0a                	jbe    8026d0 <__umoddi3+0x70>
  8026c6:	89 f0                	mov    %esi,%eax
  8026c8:	83 c4 1c             	add    $0x1c,%esp
  8026cb:	5b                   	pop    %ebx
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	0f bd e8             	bsr    %eax,%ebp
  8026d3:	83 f5 1f             	xor    $0x1f,%ebp
  8026d6:	75 20                	jne    8026f8 <__umoddi3+0x98>
  8026d8:	39 d8                	cmp    %ebx,%eax
  8026da:	0f 82 b0 00 00 00    	jb     802790 <__umoddi3+0x130>
  8026e0:	39 f7                	cmp    %esi,%edi
  8026e2:	0f 86 a8 00 00 00    	jbe    802790 <__umoddi3+0x130>
  8026e8:	89 c8                	mov    %ecx,%eax
  8026ea:	83 c4 1c             	add    $0x1c,%esp
  8026ed:	5b                   	pop    %ebx
  8026ee:	5e                   	pop    %esi
  8026ef:	5f                   	pop    %edi
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    
  8026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8026ff:	29 ea                	sub    %ebp,%edx
  802701:	d3 e0                	shl    %cl,%eax
  802703:	89 44 24 08          	mov    %eax,0x8(%esp)
  802707:	89 d1                	mov    %edx,%ecx
  802709:	89 f8                	mov    %edi,%eax
  80270b:	d3 e8                	shr    %cl,%eax
  80270d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802711:	89 54 24 04          	mov    %edx,0x4(%esp)
  802715:	8b 54 24 04          	mov    0x4(%esp),%edx
  802719:	09 c1                	or     %eax,%ecx
  80271b:	89 d8                	mov    %ebx,%eax
  80271d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802721:	89 e9                	mov    %ebp,%ecx
  802723:	d3 e7                	shl    %cl,%edi
  802725:	89 d1                	mov    %edx,%ecx
  802727:	d3 e8                	shr    %cl,%eax
  802729:	89 e9                	mov    %ebp,%ecx
  80272b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80272f:	d3 e3                	shl    %cl,%ebx
  802731:	89 c7                	mov    %eax,%edi
  802733:	89 d1                	mov    %edx,%ecx
  802735:	89 f0                	mov    %esi,%eax
  802737:	d3 e8                	shr    %cl,%eax
  802739:	89 e9                	mov    %ebp,%ecx
  80273b:	89 fa                	mov    %edi,%edx
  80273d:	d3 e6                	shl    %cl,%esi
  80273f:	09 d8                	or     %ebx,%eax
  802741:	f7 74 24 08          	divl   0x8(%esp)
  802745:	89 d1                	mov    %edx,%ecx
  802747:	89 f3                	mov    %esi,%ebx
  802749:	f7 64 24 0c          	mull   0xc(%esp)
  80274d:	89 c6                	mov    %eax,%esi
  80274f:	89 d7                	mov    %edx,%edi
  802751:	39 d1                	cmp    %edx,%ecx
  802753:	72 06                	jb     80275b <__umoddi3+0xfb>
  802755:	75 10                	jne    802767 <__umoddi3+0x107>
  802757:	39 c3                	cmp    %eax,%ebx
  802759:	73 0c                	jae    802767 <__umoddi3+0x107>
  80275b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80275f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802763:	89 d7                	mov    %edx,%edi
  802765:	89 c6                	mov    %eax,%esi
  802767:	89 ca                	mov    %ecx,%edx
  802769:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80276e:	29 f3                	sub    %esi,%ebx
  802770:	19 fa                	sbb    %edi,%edx
  802772:	89 d0                	mov    %edx,%eax
  802774:	d3 e0                	shl    %cl,%eax
  802776:	89 e9                	mov    %ebp,%ecx
  802778:	d3 eb                	shr    %cl,%ebx
  80277a:	d3 ea                	shr    %cl,%edx
  80277c:	09 d8                	or     %ebx,%eax
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	89 da                	mov    %ebx,%edx
  802792:	29 fe                	sub    %edi,%esi
  802794:	19 c2                	sbb    %eax,%edx
  802796:	89 f1                	mov    %esi,%ecx
  802798:	89 c8                	mov    %ecx,%eax
  80279a:	e9 4b ff ff ff       	jmp    8026ea <__umoddi3+0x8a>
