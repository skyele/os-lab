
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
  800054:	68 c0 27 80 00       	push   $0x8027c0
  800059:	e8 96 1a 00 00       	call   801af4 <printf>
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
  800073:	e8 07 15 00 00       	call   80157f <write>
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
  80008d:	e8 21 14 00 00       	call   8014b3 <read>
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
  8000ab:	68 c5 27 80 00       	push   $0x8027c5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 e0 27 80 00       	push   $0x8027e0
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
  8000d8:	68 eb 27 80 00       	push   $0x8027eb
  8000dd:	6a 18                	push   $0x18
  8000df:	68 e0 27 80 00       	push   $0x8027e0
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
  8000f2:	c7 05 04 30 80 00 00 	movl   $0x802800,0x803004
  8000f9:	28 80 00 
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
  80011c:	e8 30 18 00 00       	call   801951 <open>
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
  800138:	e8 38 12 00 00       	call   801375 <close>
		for (i = 1; i < argc; i++) {
  80013d:	83 c7 01             	add    $0x1,%edi
  800140:	83 c3 04             	add    $0x4,%ebx
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb c5                	jmp    80010d <umain+0x24>
		num(0, "<stdin>");
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 28 80 00       	push   $0x802804
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
  800170:	68 0c 28 80 00       	push   $0x80280c
  800175:	6a 27                	push   $0x27
  800177:	68 e0 27 80 00       	push   $0x8027e0
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
  800204:	68 1e 28 80 00       	push   $0x80281e
  800209:	e8 76 01 00 00       	call   800384 <cprintf>
	cprintf("before umain\n");
  80020e:	c7 04 24 3c 28 80 00 	movl   $0x80283c,(%esp)
  800215:	e8 6a 01 00 00       	call   800384 <cprintf>
	// call user main routine
	umain(argc, argv);
  80021a:	83 c4 08             	add    $0x8,%esp
  80021d:	ff 75 0c             	pushl  0xc(%ebp)
  800220:	ff 75 08             	pushl  0x8(%ebp)
  800223:	e8 c1 fe ff ff       	call   8000e9 <umain>
	cprintf("after umain\n");
  800228:	c7 04 24 4a 28 80 00 	movl   $0x80284a,(%esp)
  80022f:	e8 50 01 00 00       	call   800384 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800234:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800239:	8b 40 48             	mov    0x48(%eax),%eax
  80023c:	83 c4 08             	add    $0x8,%esp
  80023f:	50                   	push   %eax
  800240:	68 57 28 80 00       	push   $0x802857
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
  800268:	68 84 28 80 00       	push   $0x802884
  80026d:	50                   	push   %eax
  80026e:	68 76 28 80 00       	push   $0x802876
  800273:	e8 0c 01 00 00       	call   800384 <cprintf>
	close_all();
  800278:	e8 25 11 00 00       	call   8013a2 <close_all>
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
  80029e:	68 b0 28 80 00       	push   $0x8028b0
  8002a3:	50                   	push   %eax
  8002a4:	68 76 28 80 00       	push   $0x802876
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
  8002c7:	68 8c 28 80 00       	push   $0x80288c
  8002cc:	e8 b3 00 00 00       	call   800384 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002d1:	83 c4 18             	add    $0x18,%esp
  8002d4:	53                   	push   %ebx
  8002d5:	ff 75 10             	pushl  0x10(%ebp)
  8002d8:	e8 56 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002dd:	c7 04 24 3a 28 80 00 	movl   $0x80283a,(%esp)
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
  800431:	e8 3a 21 00 00       	call   802570 <__udivdi3>
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
  80045a:	e8 21 22 00 00       	call   802680 <__umoddi3>
  80045f:	83 c4 14             	add    $0x14,%esp
  800462:	0f be 80 b7 28 80 00 	movsbl 0x8028b7(%eax),%eax
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
  80050b:	ff 24 85 a0 2a 80 00 	jmp    *0x802aa0(,%eax,4)
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
  8005d6:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  8005dd:	85 d2                	test   %edx,%edx
  8005df:	74 18                	je     8005f9 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005e1:	52                   	push   %edx
  8005e2:	68 21 2d 80 00       	push   $0x802d21
  8005e7:	53                   	push   %ebx
  8005e8:	56                   	push   %esi
  8005e9:	e8 a6 fe ff ff       	call   800494 <printfmt>
  8005ee:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f1:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f4:	e9 fe 02 00 00       	jmp    8008f7 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f9:	50                   	push   %eax
  8005fa:	68 cf 28 80 00       	push   $0x8028cf
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
  800621:	b8 c8 28 80 00       	mov    $0x8028c8,%eax
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
  8009b9:	bf ed 29 80 00       	mov    $0x8029ed,%edi
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
  8009e5:	bf 25 2a 80 00       	mov    $0x802a25,%edi
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
  800e86:	68 48 2c 80 00       	push   $0x802c48
  800e8b:	6a 43                	push   $0x43
  800e8d:	68 65 2c 80 00       	push   $0x802c65
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
  800f07:	68 48 2c 80 00       	push   $0x802c48
  800f0c:	6a 43                	push   $0x43
  800f0e:	68 65 2c 80 00       	push   $0x802c65
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
  800f49:	68 48 2c 80 00       	push   $0x802c48
  800f4e:	6a 43                	push   $0x43
  800f50:	68 65 2c 80 00       	push   $0x802c65
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
  800f8b:	68 48 2c 80 00       	push   $0x802c48
  800f90:	6a 43                	push   $0x43
  800f92:	68 65 2c 80 00       	push   $0x802c65
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
  800fcd:	68 48 2c 80 00       	push   $0x802c48
  800fd2:	6a 43                	push   $0x43
  800fd4:	68 65 2c 80 00       	push   $0x802c65
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
  80100f:	68 48 2c 80 00       	push   $0x802c48
  801014:	6a 43                	push   $0x43
  801016:	68 65 2c 80 00       	push   $0x802c65
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
  801051:	68 48 2c 80 00       	push   $0x802c48
  801056:	6a 43                	push   $0x43
  801058:	68 65 2c 80 00       	push   $0x802c65
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
  8010b5:	68 48 2c 80 00       	push   $0x802c48
  8010ba:	6a 43                	push   $0x43
  8010bc:	68 65 2c 80 00       	push   $0x802c65
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
  801199:	68 48 2c 80 00       	push   $0x802c48
  80119e:	6a 43                	push   $0x43
  8011a0:	68 65 2c 80 00       	push   $0x802c65
  8011a5:	e8 e4 f0 ff ff       	call   80028e <_panic>

008011aa <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	57                   	push   %edi
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b8:	b8 14 00 00 00       	mov    $0x14,%eax
  8011bd:	89 cb                	mov    %ecx,%ebx
  8011bf:	89 cf                	mov    %ecx,%edi
  8011c1:	89 ce                	mov    %ecx,%esi
  8011c3:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	c1 ea 16             	shr    $0x16,%edx
  8011fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801205:	f6 c2 01             	test   $0x1,%dl
  801208:	74 2d                	je     801237 <fd_alloc+0x46>
  80120a:	89 c2                	mov    %eax,%edx
  80120c:	c1 ea 0c             	shr    $0xc,%edx
  80120f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801216:	f6 c2 01             	test   $0x1,%dl
  801219:	74 1c                	je     801237 <fd_alloc+0x46>
  80121b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801220:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801225:	75 d2                	jne    8011f9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801230:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801235:	eb 0a                	jmp    801241 <fd_alloc+0x50>
			*fd_store = fd;
  801237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801249:	83 f8 1f             	cmp    $0x1f,%eax
  80124c:	77 30                	ja     80127e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80124e:	c1 e0 0c             	shl    $0xc,%eax
  801251:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801256:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	74 24                	je     801285 <fd_lookup+0x42>
  801261:	89 c2                	mov    %eax,%edx
  801263:	c1 ea 0c             	shr    $0xc,%edx
  801266:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80126d:	f6 c2 01             	test   $0x1,%dl
  801270:	74 1a                	je     80128c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801272:	8b 55 0c             	mov    0xc(%ebp),%edx
  801275:	89 02                	mov    %eax,(%edx)
	return 0;
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
		return -E_INVAL;
  80127e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801283:	eb f7                	jmp    80127c <fd_lookup+0x39>
		return -E_INVAL;
  801285:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128a:	eb f0                	jmp    80127c <fd_lookup+0x39>
  80128c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801291:	eb e9                	jmp    80127c <fd_lookup+0x39>

00801293 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80129c:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a1:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a6:	39 08                	cmp    %ecx,(%eax)
  8012a8:	74 38                	je     8012e2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012aa:	83 c2 01             	add    $0x1,%edx
  8012ad:	8b 04 95 f4 2c 80 00 	mov    0x802cf4(,%edx,4),%eax
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	75 ee                	jne    8012a6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012bd:	8b 40 48             	mov    0x48(%eax),%eax
  8012c0:	83 ec 04             	sub    $0x4,%esp
  8012c3:	51                   	push   %ecx
  8012c4:	50                   	push   %eax
  8012c5:	68 74 2c 80 00       	push   $0x802c74
  8012ca:	e8 b5 f0 ff ff       	call   800384 <cprintf>
	*dev = 0;
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    
			*dev = devtab[i];
  8012e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ec:	eb f2                	jmp    8012e0 <dev_lookup+0x4d>

008012ee <fd_close>:
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 24             	sub    $0x24,%esp
  8012f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801300:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801301:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801307:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130a:	50                   	push   %eax
  80130b:	e8 33 ff ff ff       	call   801243 <fd_lookup>
  801310:	89 c3                	mov    %eax,%ebx
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 05                	js     80131e <fd_close+0x30>
	    || fd != fd2)
  801319:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80131c:	74 16                	je     801334 <fd_close+0x46>
		return (must_exist ? r : 0);
  80131e:	89 f8                	mov    %edi,%eax
  801320:	84 c0                	test   %al,%al
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
  801327:	0f 44 d8             	cmove  %eax,%ebx
}
  80132a:	89 d8                	mov    %ebx,%eax
  80132c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132f:	5b                   	pop    %ebx
  801330:	5e                   	pop    %esi
  801331:	5f                   	pop    %edi
  801332:	5d                   	pop    %ebp
  801333:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	ff 36                	pushl  (%esi)
  80133d:	e8 51 ff ff ff       	call   801293 <dev_lookup>
  801342:	89 c3                	mov    %eax,%ebx
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 1a                	js     801365 <fd_close+0x77>
		if (dev->dev_close)
  80134b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801351:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801356:	85 c0                	test   %eax,%eax
  801358:	74 0b                	je     801365 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	56                   	push   %esi
  80135e:	ff d0                	call   *%eax
  801360:	89 c3                	mov    %eax,%ebx
  801362:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	56                   	push   %esi
  801369:	6a 00                	push   $0x0
  80136b:	e8 ea fb ff ff       	call   800f5a <sys_page_unmap>
	return r;
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	eb b5                	jmp    80132a <fd_close+0x3c>

00801375 <close>:

int
close(int fdnum)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 bc fe ff ff       	call   801243 <fd_lookup>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	79 02                	jns    801390 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    
		return fd_close(fd, 1);
  801390:	83 ec 08             	sub    $0x8,%esp
  801393:	6a 01                	push   $0x1
  801395:	ff 75 f4             	pushl  -0xc(%ebp)
  801398:	e8 51 ff ff ff       	call   8012ee <fd_close>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	eb ec                	jmp    80138e <close+0x19>

008013a2 <close_all>:

void
close_all(void)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	53                   	push   %ebx
  8013a6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	53                   	push   %ebx
  8013b2:	e8 be ff ff ff       	call   801375 <close>
	for (i = 0; i < MAXFD; i++)
  8013b7:	83 c3 01             	add    $0x1,%ebx
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	83 fb 20             	cmp    $0x20,%ebx
  8013c0:	75 ec                	jne    8013ae <close_all+0xc>
}
  8013c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	53                   	push   %ebx
  8013cd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d3:	50                   	push   %eax
  8013d4:	ff 75 08             	pushl  0x8(%ebp)
  8013d7:	e8 67 fe ff ff       	call   801243 <fd_lookup>
  8013dc:	89 c3                	mov    %eax,%ebx
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	0f 88 81 00 00 00    	js     80146a <dup+0xa3>
		return r;
	close(newfdnum);
  8013e9:	83 ec 0c             	sub    $0xc,%esp
  8013ec:	ff 75 0c             	pushl  0xc(%ebp)
  8013ef:	e8 81 ff ff ff       	call   801375 <close>

	newfd = INDEX2FD(newfdnum);
  8013f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f7:	c1 e6 0c             	shl    $0xc,%esi
  8013fa:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801400:	83 c4 04             	add    $0x4,%esp
  801403:	ff 75 e4             	pushl  -0x1c(%ebp)
  801406:	e8 cf fd ff ff       	call   8011da <fd2data>
  80140b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80140d:	89 34 24             	mov    %esi,(%esp)
  801410:	e8 c5 fd ff ff       	call   8011da <fd2data>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80141a:	89 d8                	mov    %ebx,%eax
  80141c:	c1 e8 16             	shr    $0x16,%eax
  80141f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801426:	a8 01                	test   $0x1,%al
  801428:	74 11                	je     80143b <dup+0x74>
  80142a:	89 d8                	mov    %ebx,%eax
  80142c:	c1 e8 0c             	shr    $0xc,%eax
  80142f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	75 39                	jne    801474 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80143b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80143e:	89 d0                	mov    %edx,%eax
  801440:	c1 e8 0c             	shr    $0xc,%eax
  801443:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	25 07 0e 00 00       	and    $0xe07,%eax
  801452:	50                   	push   %eax
  801453:	56                   	push   %esi
  801454:	6a 00                	push   $0x0
  801456:	52                   	push   %edx
  801457:	6a 00                	push   $0x0
  801459:	e8 ba fa ff ff       	call   800f18 <sys_page_map>
  80145e:	89 c3                	mov    %eax,%ebx
  801460:	83 c4 20             	add    $0x20,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 31                	js     801498 <dup+0xd1>
		goto err;

	return newfdnum;
  801467:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80146a:	89 d8                	mov    %ebx,%eax
  80146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801474:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	25 07 0e 00 00       	and    $0xe07,%eax
  801483:	50                   	push   %eax
  801484:	57                   	push   %edi
  801485:	6a 00                	push   $0x0
  801487:	53                   	push   %ebx
  801488:	6a 00                	push   $0x0
  80148a:	e8 89 fa ff ff       	call   800f18 <sys_page_map>
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	83 c4 20             	add    $0x20,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	79 a3                	jns    80143b <dup+0x74>
	sys_page_unmap(0, newfd);
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	56                   	push   %esi
  80149c:	6a 00                	push   $0x0
  80149e:	e8 b7 fa ff ff       	call   800f5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a3:	83 c4 08             	add    $0x8,%esp
  8014a6:	57                   	push   %edi
  8014a7:	6a 00                	push   $0x0
  8014a9:	e8 ac fa ff ff       	call   800f5a <sys_page_unmap>
	return r;
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	eb b7                	jmp    80146a <dup+0xa3>

008014b3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 1c             	sub    $0x1c,%esp
  8014ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	53                   	push   %ebx
  8014c2:	e8 7c fd ff ff       	call   801243 <fd_lookup>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 3f                	js     80150d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ce:	83 ec 08             	sub    $0x8,%esp
  8014d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d4:	50                   	push   %eax
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	ff 30                	pushl  (%eax)
  8014da:	e8 b4 fd ff ff       	call   801293 <dev_lookup>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 27                	js     80150d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e9:	8b 42 08             	mov    0x8(%edx),%eax
  8014ec:	83 e0 03             	and    $0x3,%eax
  8014ef:	83 f8 01             	cmp    $0x1,%eax
  8014f2:	74 1e                	je     801512 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f7:	8b 40 08             	mov    0x8(%eax),%eax
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 35                	je     801533 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014fe:	83 ec 04             	sub    $0x4,%esp
  801501:	ff 75 10             	pushl  0x10(%ebp)
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	52                   	push   %edx
  801508:	ff d0                	call   *%eax
  80150a:	83 c4 10             	add    $0x10,%esp
}
  80150d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801510:	c9                   	leave  
  801511:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801512:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801517:	8b 40 48             	mov    0x48(%eax),%eax
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	53                   	push   %ebx
  80151e:	50                   	push   %eax
  80151f:	68 b8 2c 80 00       	push   $0x802cb8
  801524:	e8 5b ee ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801531:	eb da                	jmp    80150d <read+0x5a>
		return -E_NOT_SUPP;
  801533:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801538:	eb d3                	jmp    80150d <read+0x5a>

0080153a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	57                   	push   %edi
  80153e:	56                   	push   %esi
  80153f:	53                   	push   %ebx
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	8b 7d 08             	mov    0x8(%ebp),%edi
  801546:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801549:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154e:	39 f3                	cmp    %esi,%ebx
  801550:	73 23                	jae    801575 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	89 f0                	mov    %esi,%eax
  801557:	29 d8                	sub    %ebx,%eax
  801559:	50                   	push   %eax
  80155a:	89 d8                	mov    %ebx,%eax
  80155c:	03 45 0c             	add    0xc(%ebp),%eax
  80155f:	50                   	push   %eax
  801560:	57                   	push   %edi
  801561:	e8 4d ff ff ff       	call   8014b3 <read>
		if (m < 0)
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	78 06                	js     801573 <readn+0x39>
			return m;
		if (m == 0)
  80156d:	74 06                	je     801575 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80156f:	01 c3                	add    %eax,%ebx
  801571:	eb db                	jmp    80154e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801573:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801575:	89 d8                	mov    %ebx,%eax
  801577:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157a:	5b                   	pop    %ebx
  80157b:	5e                   	pop    %esi
  80157c:	5f                   	pop    %edi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	53                   	push   %ebx
  801583:	83 ec 1c             	sub    $0x1c,%esp
  801586:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801589:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158c:	50                   	push   %eax
  80158d:	53                   	push   %ebx
  80158e:	e8 b0 fc ff ff       	call   801243 <fd_lookup>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 3a                	js     8015d4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	ff 30                	pushl  (%eax)
  8015a6:	e8 e8 fc ff ff       	call   801293 <dev_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 22                	js     8015d4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b9:	74 1e                	je     8015d9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015be:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c1:	85 d2                	test   %edx,%edx
  8015c3:	74 35                	je     8015fa <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	ff 75 10             	pushl  0x10(%ebp)
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	50                   	push   %eax
  8015cf:	ff d2                	call   *%edx
  8015d1:	83 c4 10             	add    $0x10,%esp
}
  8015d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d9:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015de:	8b 40 48             	mov    0x48(%eax),%eax
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	53                   	push   %ebx
  8015e5:	50                   	push   %eax
  8015e6:	68 d4 2c 80 00       	push   $0x802cd4
  8015eb:	e8 94 ed ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f8:	eb da                	jmp    8015d4 <write+0x55>
		return -E_NOT_SUPP;
  8015fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ff:	eb d3                	jmp    8015d4 <write+0x55>

00801601 <seek>:

int
seek(int fdnum, off_t offset)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160a:	50                   	push   %eax
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	e8 30 fc ff ff       	call   801243 <fd_lookup>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 0e                	js     801628 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80161a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 1c             	sub    $0x1c,%esp
  801631:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801634:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	53                   	push   %ebx
  801639:	e8 05 fc ff ff       	call   801243 <fd_lookup>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 37                	js     80167c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164b:	50                   	push   %eax
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	ff 30                	pushl  (%eax)
  801651:	e8 3d fc ff ff       	call   801293 <dev_lookup>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	85 c0                	test   %eax,%eax
  80165b:	78 1f                	js     80167c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801660:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801664:	74 1b                	je     801681 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801669:	8b 52 18             	mov    0x18(%edx),%edx
  80166c:	85 d2                	test   %edx,%edx
  80166e:	74 32                	je     8016a2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	50                   	push   %eax
  801677:	ff d2                	call   *%edx
  801679:	83 c4 10             	add    $0x10,%esp
}
  80167c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167f:	c9                   	leave  
  801680:	c3                   	ret    
			thisenv->env_id, fdnum);
  801681:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801686:	8b 40 48             	mov    0x48(%eax),%eax
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	53                   	push   %ebx
  80168d:	50                   	push   %eax
  80168e:	68 94 2c 80 00       	push   $0x802c94
  801693:	e8 ec ec ff ff       	call   800384 <cprintf>
		return -E_INVAL;
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a0:	eb da                	jmp    80167c <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a7:	eb d3                	jmp    80167c <ftruncate+0x52>

008016a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	53                   	push   %ebx
  8016ad:	83 ec 1c             	sub    $0x1c,%esp
  8016b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b6:	50                   	push   %eax
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 84 fb ff ff       	call   801243 <fd_lookup>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 4b                	js     801711 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cc:	50                   	push   %eax
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	ff 30                	pushl  (%eax)
  8016d2:	e8 bc fb ff ff       	call   801293 <dev_lookup>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 33                	js     801711 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e5:	74 2f                	je     801716 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016e7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ea:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f1:	00 00 00 
	stat->st_isdir = 0;
  8016f4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fb:	00 00 00 
	stat->st_dev = dev;
  8016fe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	53                   	push   %ebx
  801708:	ff 75 f0             	pushl  -0x10(%ebp)
  80170b:	ff 50 14             	call   *0x14(%eax)
  80170e:	83 c4 10             	add    $0x10,%esp
}
  801711:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801714:	c9                   	leave  
  801715:	c3                   	ret    
		return -E_NOT_SUPP;
  801716:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171b:	eb f4                	jmp    801711 <fstat+0x68>

0080171d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	6a 00                	push   $0x0
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	e8 22 02 00 00       	call   801951 <open>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	83 c4 10             	add    $0x10,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	78 1b                	js     801753 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	ff 75 0c             	pushl  0xc(%ebp)
  80173e:	50                   	push   %eax
  80173f:	e8 65 ff ff ff       	call   8016a9 <fstat>
  801744:	89 c6                	mov    %eax,%esi
	close(fd);
  801746:	89 1c 24             	mov    %ebx,(%esp)
  801749:	e8 27 fc ff ff       	call   801375 <close>
	return r;
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	89 f3                	mov    %esi,%ebx
}
  801753:	89 d8                	mov    %ebx,%eax
  801755:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801758:	5b                   	pop    %ebx
  801759:	5e                   	pop    %esi
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	56                   	push   %esi
  801760:	53                   	push   %ebx
  801761:	89 c6                	mov    %eax,%esi
  801763:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801765:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80176c:	74 27                	je     801795 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80176e:	6a 07                	push   $0x7
  801770:	68 00 50 80 00       	push   $0x805000
  801775:	56                   	push   %esi
  801776:	ff 35 04 40 80 00    	pushl  0x804004
  80177c:	e8 1c 0d 00 00       	call   80249d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801781:	83 c4 0c             	add    $0xc,%esp
  801784:	6a 00                	push   $0x0
  801786:	53                   	push   %ebx
  801787:	6a 00                	push   $0x0
  801789:	e8 a6 0c 00 00       	call   802434 <ipc_recv>
}
  80178e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	6a 01                	push   $0x1
  80179a:	e8 56 0d 00 00       	call   8024f5 <ipc_find_env>
  80179f:	a3 04 40 80 00       	mov    %eax,0x804004
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	eb c5                	jmp    80176e <fsipc+0x12>

008017a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017cc:	e8 8b ff ff ff       	call   80175c <fsipc>
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <devfile_flush>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017df:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ee:	e8 69 ff ff ff       	call   80175c <fsipc>
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <devfile_stat>:
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 40 0c             	mov    0xc(%eax),%eax
  801805:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	b8 05 00 00 00       	mov    $0x5,%eax
  801814:	e8 43 ff ff ff       	call   80175c <fsipc>
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 2c                	js     801849 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	68 00 50 80 00       	push   $0x805000
  801825:	53                   	push   %ebx
  801826:	e8 b8 f2 ff ff       	call   800ae3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182b:	a1 80 50 80 00       	mov    0x805080,%eax
  801830:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801836:	a1 84 50 80 00       	mov    0x805084,%eax
  80183b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <devfile_write>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	53                   	push   %ebx
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	8b 40 0c             	mov    0xc(%eax),%eax
  80185e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801863:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801869:	53                   	push   %ebx
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	68 08 50 80 00       	push   $0x805008
  801872:	e8 5c f4 ff ff       	call   800cd3 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
  80187c:	b8 04 00 00 00       	mov    $0x4,%eax
  801881:	e8 d6 fe ff ff       	call   80175c <fsipc>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 0b                	js     801898 <devfile_write+0x4a>
	assert(r <= n);
  80188d:	39 d8                	cmp    %ebx,%eax
  80188f:	77 0c                	ja     80189d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801891:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801896:	7f 1e                	jg     8018b6 <devfile_write+0x68>
}
  801898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    
	assert(r <= n);
  80189d:	68 08 2d 80 00       	push   $0x802d08
  8018a2:	68 0f 2d 80 00       	push   $0x802d0f
  8018a7:	68 98 00 00 00       	push   $0x98
  8018ac:	68 24 2d 80 00       	push   $0x802d24
  8018b1:	e8 d8 e9 ff ff       	call   80028e <_panic>
	assert(r <= PGSIZE);
  8018b6:	68 2f 2d 80 00       	push   $0x802d2f
  8018bb:	68 0f 2d 80 00       	push   $0x802d0f
  8018c0:	68 99 00 00 00       	push   $0x99
  8018c5:	68 24 2d 80 00       	push   $0x802d24
  8018ca:	e8 bf e9 ff ff       	call   80028e <_panic>

008018cf <devfile_read>:
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	56                   	push   %esi
  8018d3:	53                   	push   %ebx
  8018d4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	8b 40 0c             	mov    0xc(%eax),%eax
  8018dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018e2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8018f2:	e8 65 fe ff ff       	call   80175c <fsipc>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 1f                	js     80191c <devfile_read+0x4d>
	assert(r <= n);
  8018fd:	39 f0                	cmp    %esi,%eax
  8018ff:	77 24                	ja     801925 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801901:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801906:	7f 33                	jg     80193b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	50                   	push   %eax
  80190c:	68 00 50 80 00       	push   $0x805000
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	e8 58 f3 ff ff       	call   800c71 <memmove>
	return r;
  801919:	83 c4 10             	add    $0x10,%esp
}
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    
	assert(r <= n);
  801925:	68 08 2d 80 00       	push   $0x802d08
  80192a:	68 0f 2d 80 00       	push   $0x802d0f
  80192f:	6a 7c                	push   $0x7c
  801931:	68 24 2d 80 00       	push   $0x802d24
  801936:	e8 53 e9 ff ff       	call   80028e <_panic>
	assert(r <= PGSIZE);
  80193b:	68 2f 2d 80 00       	push   $0x802d2f
  801940:	68 0f 2d 80 00       	push   $0x802d0f
  801945:	6a 7d                	push   $0x7d
  801947:	68 24 2d 80 00       	push   $0x802d24
  80194c:	e8 3d e9 ff ff       	call   80028e <_panic>

00801951 <open>:
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	83 ec 1c             	sub    $0x1c,%esp
  801959:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80195c:	56                   	push   %esi
  80195d:	e8 48 f1 ff ff       	call   800aaa <strlen>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80196a:	7f 6c                	jg     8019d8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80196c:	83 ec 0c             	sub    $0xc,%esp
  80196f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801972:	50                   	push   %eax
  801973:	e8 79 f8 ff ff       	call   8011f1 <fd_alloc>
  801978:	89 c3                	mov    %eax,%ebx
  80197a:	83 c4 10             	add    $0x10,%esp
  80197d:	85 c0                	test   %eax,%eax
  80197f:	78 3c                	js     8019bd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	56                   	push   %esi
  801985:	68 00 50 80 00       	push   $0x805000
  80198a:	e8 54 f1 ff ff       	call   800ae3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199a:	b8 01 00 00 00       	mov    $0x1,%eax
  80199f:	e8 b8 fd ff ff       	call   80175c <fsipc>
  8019a4:	89 c3                	mov    %eax,%ebx
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 19                	js     8019c6 <open+0x75>
	return fd2num(fd);
  8019ad:	83 ec 0c             	sub    $0xc,%esp
  8019b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b3:	e8 12 f8 ff ff       	call   8011ca <fd2num>
  8019b8:	89 c3                	mov    %eax,%ebx
  8019ba:	83 c4 10             	add    $0x10,%esp
}
  8019bd:	89 d8                	mov    %ebx,%eax
  8019bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c2:	5b                   	pop    %ebx
  8019c3:	5e                   	pop    %esi
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    
		fd_close(fd, 0);
  8019c6:	83 ec 08             	sub    $0x8,%esp
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ce:	e8 1b f9 ff ff       	call   8012ee <fd_close>
		return r;
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	eb e5                	jmp    8019bd <open+0x6c>
		return -E_BAD_PATH;
  8019d8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019dd:	eb de                	jmp    8019bd <open+0x6c>

008019df <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ef:	e8 68 fd ff ff       	call   80175c <fsipc>
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8019f6:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019fa:	7f 01                	jg     8019fd <writebuf+0x7>
  8019fc:	c3                   	ret    
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	53                   	push   %ebx
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a06:	ff 70 04             	pushl  0x4(%eax)
  801a09:	8d 40 10             	lea    0x10(%eax),%eax
  801a0c:	50                   	push   %eax
  801a0d:	ff 33                	pushl  (%ebx)
  801a0f:	e8 6b fb ff ff       	call   80157f <write>
		if (result > 0)
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	7e 03                	jle    801a1e <writebuf+0x28>
			b->result += result;
  801a1b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a1e:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a21:	74 0d                	je     801a30 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a23:	85 c0                	test   %eax,%eax
  801a25:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2a:	0f 4f c2             	cmovg  %edx,%eax
  801a2d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <putch>:

static void
putch(int ch, void *thunk)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	53                   	push   %ebx
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a3f:	8b 53 04             	mov    0x4(%ebx),%edx
  801a42:	8d 42 01             	lea    0x1(%edx),%eax
  801a45:	89 43 04             	mov    %eax,0x4(%ebx)
  801a48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a4b:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a4f:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a54:	74 06                	je     801a5c <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801a56:	83 c4 04             	add    $0x4,%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    
		writebuf(b);
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	e8 93 ff ff ff       	call   8019f6 <writebuf>
		b->idx = 0;
  801a63:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a6a:	eb ea                	jmp    801a56 <putch+0x21>

00801a6c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a7e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a85:	00 00 00 
	b.result = 0;
  801a88:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a8f:	00 00 00 
	b.error = 1;
  801a92:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a99:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a9c:	ff 75 10             	pushl  0x10(%ebp)
  801a9f:	ff 75 0c             	pushl  0xc(%ebp)
  801aa2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801aa8:	50                   	push   %eax
  801aa9:	68 35 1a 80 00       	push   $0x801a35
  801aae:	e8 fe e9 ff ff       	call   8004b1 <vprintfmt>
	if (b.idx > 0)
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801abd:	7f 11                	jg     801ad0 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    
		writebuf(&b);
  801ad0:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ad6:	e8 1b ff ff ff       	call   8019f6 <writebuf>
  801adb:	eb e2                	jmp    801abf <vfprintf+0x53>

00801add <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ae3:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ae6:	50                   	push   %eax
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	e8 7a ff ff ff       	call   801a6c <vfprintf>
	va_end(ap);

	return cnt;
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <printf>:

int
printf(const char *fmt, ...)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801afa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801afd:	50                   	push   %eax
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 01                	push   $0x1
  801b03:	e8 64 ff ff ff       	call   801a6c <vfprintf>
	va_end(ap);

	return cnt;
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b10:	68 3b 2d 80 00       	push   $0x802d3b
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	e8 c6 ef ff ff       	call   800ae3 <strcpy>
	return 0;
}
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <devsock_close>:
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	53                   	push   %ebx
  801b28:	83 ec 10             	sub    $0x10,%esp
  801b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b2e:	53                   	push   %ebx
  801b2f:	e8 fc 09 00 00       	call   802530 <pageref>
  801b34:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b37:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b3c:	83 f8 01             	cmp    $0x1,%eax
  801b3f:	74 07                	je     801b48 <devsock_close+0x24>
}
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	ff 73 0c             	pushl  0xc(%ebx)
  801b4e:	e8 b9 02 00 00       	call   801e0c <nsipc_close>
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	83 c4 10             	add    $0x10,%esp
  801b58:	eb e7                	jmp    801b41 <devsock_close+0x1d>

00801b5a <devsock_write>:
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	ff 70 0c             	pushl  0xc(%eax)
  801b6e:	e8 76 03 00 00       	call   801ee9 <nsipc_send>
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <devsock_read>:
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	ff 70 0c             	pushl  0xc(%eax)
  801b89:	e8 ef 02 00 00       	call   801e7d <nsipc_recv>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <fd2sockid>:
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b96:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	e8 a3 f6 ff ff       	call   801243 <fd_lookup>
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 10                	js     801bb7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801bb0:	39 08                	cmp    %ecx,(%eax)
  801bb2:	75 05                	jne    801bb9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bb4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    
		return -E_NOT_SUPP;
  801bb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bbe:	eb f7                	jmp    801bb7 <fd2sockid+0x27>

00801bc0 <alloc_sockfd>:
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 1c             	sub    $0x1c,%esp
  801bc8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcd:	50                   	push   %eax
  801bce:	e8 1e f6 ff ff       	call   8011f1 <fd_alloc>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 43                	js     801c1f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	68 07 04 00 00       	push   $0x407
  801be4:	ff 75 f4             	pushl  -0xc(%ebp)
  801be7:	6a 00                	push   $0x0
  801be9:	e8 e7 f2 ff ff       	call   800ed5 <sys_page_alloc>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 28                	js     801c1f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801c00:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c05:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c0c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	50                   	push   %eax
  801c13:	e8 b2 f5 ff ff       	call   8011ca <fd2num>
  801c18:	89 c3                	mov    %eax,%ebx
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	eb 0c                	jmp    801c2b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	56                   	push   %esi
  801c23:	e8 e4 01 00 00       	call   801e0c <nsipc_close>
		return r;
  801c28:	83 c4 10             	add    $0x10,%esp
}
  801c2b:	89 d8                	mov    %ebx,%eax
  801c2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    

00801c34 <accept>:
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	e8 4e ff ff ff       	call   801b90 <fd2sockid>
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 1b                	js     801c61 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	50                   	push   %eax
  801c50:	e8 0e 01 00 00       	call   801d63 <nsipc_accept>
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 05                	js     801c61 <accept+0x2d>
	return alloc_sockfd(r);
  801c5c:	e8 5f ff ff ff       	call   801bc0 <alloc_sockfd>
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <bind>:
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	e8 1f ff ff ff       	call   801b90 <fd2sockid>
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 12                	js     801c87 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	ff 75 10             	pushl  0x10(%ebp)
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	50                   	push   %eax
  801c7f:	e8 31 01 00 00       	call   801db5 <nsipc_bind>
  801c84:	83 c4 10             	add    $0x10,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <shutdown>:
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	e8 f9 fe ff ff       	call   801b90 <fd2sockid>
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 0f                	js     801caa <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801c9b:	83 ec 08             	sub    $0x8,%esp
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	50                   	push   %eax
  801ca2:	e8 43 01 00 00       	call   801dea <nsipc_shutdown>
  801ca7:	83 c4 10             	add    $0x10,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <connect>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	e8 d6 fe ff ff       	call   801b90 <fd2sockid>
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 12                	js     801cd0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	50                   	push   %eax
  801cc8:	e8 59 01 00 00       	call   801e26 <nsipc_connect>
  801ccd:	83 c4 10             	add    $0x10,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <listen>:
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	e8 b0 fe ff ff       	call   801b90 <fd2sockid>
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 0f                	js     801cf3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ce4:	83 ec 08             	sub    $0x8,%esp
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	50                   	push   %eax
  801ceb:	e8 6b 01 00 00       	call   801e5b <nsipc_listen>
  801cf0:	83 c4 10             	add    $0x10,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cfb:	ff 75 10             	pushl  0x10(%ebp)
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	e8 3e 02 00 00       	call   801f47 <nsipc_socket>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 05                	js     801d15 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d10:	e8 ab fe ff ff       	call   801bc0 <alloc_sockfd>
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	53                   	push   %ebx
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d20:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801d27:	74 26                	je     801d4f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d29:	6a 07                	push   $0x7
  801d2b:	68 00 60 80 00       	push   $0x806000
  801d30:	53                   	push   %ebx
  801d31:	ff 35 08 40 80 00    	pushl  0x804008
  801d37:	e8 61 07 00 00       	call   80249d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d3c:	83 c4 0c             	add    $0xc,%esp
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	e8 ea 06 00 00       	call   802434 <ipc_recv>
}
  801d4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	6a 02                	push   $0x2
  801d54:	e8 9c 07 00 00       	call   8024f5 <ipc_find_env>
  801d59:	a3 08 40 80 00       	mov    %eax,0x804008
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	eb c6                	jmp    801d29 <nsipc+0x12>

00801d63 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d73:	8b 06                	mov    (%esi),%eax
  801d75:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	e8 93 ff ff ff       	call   801d17 <nsipc>
  801d84:	89 c3                	mov    %eax,%ebx
  801d86:	85 c0                	test   %eax,%eax
  801d88:	79 09                	jns    801d93 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d8a:	89 d8                	mov    %ebx,%eax
  801d8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	ff 35 10 60 80 00    	pushl  0x806010
  801d9c:	68 00 60 80 00       	push   $0x806000
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	e8 c8 ee ff ff       	call   800c71 <memmove>
		*addrlen = ret->ret_addrlen;
  801da9:	a1 10 60 80 00       	mov    0x806010,%eax
  801dae:	89 06                	mov    %eax,(%esi)
  801db0:	83 c4 10             	add    $0x10,%esp
	return r;
  801db3:	eb d5                	jmp    801d8a <nsipc_accept+0x27>

00801db5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	83 ec 08             	sub    $0x8,%esp
  801dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dc7:	53                   	push   %ebx
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	68 04 60 80 00       	push   $0x806004
  801dd0:	e8 9c ee ff ff       	call   800c71 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dd5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ddb:	b8 02 00 00 00       	mov    $0x2,%eax
  801de0:	e8 32 ff ff ff       	call   801d17 <nsipc>
}
  801de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e00:	b8 03 00 00 00       	mov    $0x3,%eax
  801e05:	e8 0d ff ff ff       	call   801d17 <nsipc>
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <nsipc_close>:

int
nsipc_close(int s)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e1a:	b8 04 00 00 00       	mov    $0x4,%eax
  801e1f:	e8 f3 fe ff ff       	call   801d17 <nsipc>
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e38:	53                   	push   %ebx
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	68 04 60 80 00       	push   $0x806004
  801e41:	e8 2b ee ff ff       	call   800c71 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e46:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e4c:	b8 05 00 00 00       	mov    $0x5,%eax
  801e51:	e8 c1 fe ff ff       	call   801d17 <nsipc>
}
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e71:	b8 06 00 00 00       	mov    $0x6,%eax
  801e76:	e8 9c fe ff ff       	call   801d17 <nsipc>
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	56                   	push   %esi
  801e81:	53                   	push   %ebx
  801e82:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e8d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e93:	8b 45 14             	mov    0x14(%ebp),%eax
  801e96:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e9b:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea0:	e8 72 fe ff ff       	call   801d17 <nsipc>
  801ea5:	89 c3                	mov    %eax,%ebx
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 1f                	js     801eca <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801eab:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801eb0:	7f 21                	jg     801ed3 <nsipc_recv+0x56>
  801eb2:	39 c6                	cmp    %eax,%esi
  801eb4:	7c 1d                	jl     801ed3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	50                   	push   %eax
  801eba:	68 00 60 80 00       	push   $0x806000
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	e8 aa ed ff ff       	call   800c71 <memmove>
  801ec7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801eca:	89 d8                	mov    %ebx,%eax
  801ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecf:	5b                   	pop    %ebx
  801ed0:	5e                   	pop    %esi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ed3:	68 47 2d 80 00       	push   $0x802d47
  801ed8:	68 0f 2d 80 00       	push   $0x802d0f
  801edd:	6a 62                	push   $0x62
  801edf:	68 5c 2d 80 00       	push   $0x802d5c
  801ee4:	e8 a5 e3 ff ff       	call   80028e <_panic>

00801ee9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	53                   	push   %ebx
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801efb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f01:	7f 2e                	jg     801f31 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	53                   	push   %ebx
  801f07:	ff 75 0c             	pushl  0xc(%ebp)
  801f0a:	68 0c 60 80 00       	push   $0x80600c
  801f0f:	e8 5d ed ff ff       	call   800c71 <memmove>
	nsipcbuf.send.req_size = size;
  801f14:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f22:	b8 08 00 00 00       	mov    $0x8,%eax
  801f27:	e8 eb fd ff ff       	call   801d17 <nsipc>
}
  801f2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    
	assert(size < 1600);
  801f31:	68 68 2d 80 00       	push   $0x802d68
  801f36:	68 0f 2d 80 00       	push   $0x802d0f
  801f3b:	6a 6d                	push   $0x6d
  801f3d:	68 5c 2d 80 00       	push   $0x802d5c
  801f42:	e8 47 e3 ff ff       	call   80028e <_panic>

00801f47 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f60:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f65:	b8 09 00 00 00       	mov    $0x9,%eax
  801f6a:	e8 a8 fd ff ff       	call   801d17 <nsipc>
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	ff 75 08             	pushl  0x8(%ebp)
  801f7f:	e8 56 f2 ff ff       	call   8011da <fd2data>
  801f84:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f86:	83 c4 08             	add    $0x8,%esp
  801f89:	68 74 2d 80 00       	push   $0x802d74
  801f8e:	53                   	push   %ebx
  801f8f:	e8 4f eb ff ff       	call   800ae3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f94:	8b 46 04             	mov    0x4(%esi),%eax
  801f97:	2b 06                	sub    (%esi),%eax
  801f99:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f9f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fa6:	00 00 00 
	stat->st_dev = &devpipe;
  801fa9:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801fb0:	30 80 00 
	return 0;
}
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	53                   	push   %ebx
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fc9:	53                   	push   %ebx
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 89 ef ff ff       	call   800f5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd1:	89 1c 24             	mov    %ebx,(%esp)
  801fd4:	e8 01 f2 ff ff       	call   8011da <fd2data>
  801fd9:	83 c4 08             	add    $0x8,%esp
  801fdc:	50                   	push   %eax
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 76 ef ff ff       	call   800f5a <sys_page_unmap>
}
  801fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <_pipeisclosed>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	57                   	push   %edi
  801fed:	56                   	push   %esi
  801fee:	53                   	push   %ebx
  801fef:	83 ec 1c             	sub    $0x1c,%esp
  801ff2:	89 c7                	mov    %eax,%edi
  801ff4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ff6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801ffb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	57                   	push   %edi
  802002:	e8 29 05 00 00       	call   802530 <pageref>
  802007:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80200a:	89 34 24             	mov    %esi,(%esp)
  80200d:	e8 1e 05 00 00       	call   802530 <pageref>
		nn = thisenv->env_runs;
  802012:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802018:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	39 cb                	cmp    %ecx,%ebx
  802020:	74 1b                	je     80203d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802022:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802025:	75 cf                	jne    801ff6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802027:	8b 42 58             	mov    0x58(%edx),%eax
  80202a:	6a 01                	push   $0x1
  80202c:	50                   	push   %eax
  80202d:	53                   	push   %ebx
  80202e:	68 7b 2d 80 00       	push   $0x802d7b
  802033:	e8 4c e3 ff ff       	call   800384 <cprintf>
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	eb b9                	jmp    801ff6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80203d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802040:	0f 94 c0             	sete   %al
  802043:	0f b6 c0             	movzbl %al,%eax
}
  802046:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802049:	5b                   	pop    %ebx
  80204a:	5e                   	pop    %esi
  80204b:	5f                   	pop    %edi
  80204c:	5d                   	pop    %ebp
  80204d:	c3                   	ret    

0080204e <devpipe_write>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 28             	sub    $0x28,%esp
  802057:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80205a:	56                   	push   %esi
  80205b:	e8 7a f1 ff ff       	call   8011da <fd2data>
  802060:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	bf 00 00 00 00       	mov    $0x0,%edi
  80206a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80206d:	74 4f                	je     8020be <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80206f:	8b 43 04             	mov    0x4(%ebx),%eax
  802072:	8b 0b                	mov    (%ebx),%ecx
  802074:	8d 51 20             	lea    0x20(%ecx),%edx
  802077:	39 d0                	cmp    %edx,%eax
  802079:	72 14                	jb     80208f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80207b:	89 da                	mov    %ebx,%edx
  80207d:	89 f0                	mov    %esi,%eax
  80207f:	e8 65 ff ff ff       	call   801fe9 <_pipeisclosed>
  802084:	85 c0                	test   %eax,%eax
  802086:	75 3b                	jne    8020c3 <devpipe_write+0x75>
			sys_yield();
  802088:	e8 29 ee ff ff       	call   800eb6 <sys_yield>
  80208d:	eb e0                	jmp    80206f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80208f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802092:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802096:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802099:	89 c2                	mov    %eax,%edx
  80209b:	c1 fa 1f             	sar    $0x1f,%edx
  80209e:	89 d1                	mov    %edx,%ecx
  8020a0:	c1 e9 1b             	shr    $0x1b,%ecx
  8020a3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020a6:	83 e2 1f             	and    $0x1f,%edx
  8020a9:	29 ca                	sub    %ecx,%edx
  8020ab:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020af:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020b3:	83 c0 01             	add    $0x1,%eax
  8020b6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020b9:	83 c7 01             	add    $0x1,%edi
  8020bc:	eb ac                	jmp    80206a <devpipe_write+0x1c>
	return i;
  8020be:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c1:	eb 05                	jmp    8020c8 <devpipe_write+0x7a>
				return 0;
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5f                   	pop    %edi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <devpipe_read>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	57                   	push   %edi
  8020d4:	56                   	push   %esi
  8020d5:	53                   	push   %ebx
  8020d6:	83 ec 18             	sub    $0x18,%esp
  8020d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020dc:	57                   	push   %edi
  8020dd:	e8 f8 f0 ff ff       	call   8011da <fd2data>
  8020e2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	be 00 00 00 00       	mov    $0x0,%esi
  8020ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020ef:	75 14                	jne    802105 <devpipe_read+0x35>
	return i;
  8020f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f4:	eb 02                	jmp    8020f8 <devpipe_read+0x28>
				return i;
  8020f6:	89 f0                	mov    %esi,%eax
}
  8020f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5f                   	pop    %edi
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    
			sys_yield();
  802100:	e8 b1 ed ff ff       	call   800eb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802105:	8b 03                	mov    (%ebx),%eax
  802107:	3b 43 04             	cmp    0x4(%ebx),%eax
  80210a:	75 18                	jne    802124 <devpipe_read+0x54>
			if (i > 0)
  80210c:	85 f6                	test   %esi,%esi
  80210e:	75 e6                	jne    8020f6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802110:	89 da                	mov    %ebx,%edx
  802112:	89 f8                	mov    %edi,%eax
  802114:	e8 d0 fe ff ff       	call   801fe9 <_pipeisclosed>
  802119:	85 c0                	test   %eax,%eax
  80211b:	74 e3                	je     802100 <devpipe_read+0x30>
				return 0;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
  802122:	eb d4                	jmp    8020f8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802124:	99                   	cltd   
  802125:	c1 ea 1b             	shr    $0x1b,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	83 e0 1f             	and    $0x1f,%eax
  80212d:	29 d0                	sub    %edx,%eax
  80212f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802134:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802137:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80213a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80213d:	83 c6 01             	add    $0x1,%esi
  802140:	eb aa                	jmp    8020ec <devpipe_read+0x1c>

00802142 <pipe>:
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80214a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214d:	50                   	push   %eax
  80214e:	e8 9e f0 ff ff       	call   8011f1 <fd_alloc>
  802153:	89 c3                	mov    %eax,%ebx
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	0f 88 23 01 00 00    	js     802283 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 07 04 00 00       	push   $0x407
  802168:	ff 75 f4             	pushl  -0xc(%ebp)
  80216b:	6a 00                	push   $0x0
  80216d:	e8 63 ed ff ff       	call   800ed5 <sys_page_alloc>
  802172:	89 c3                	mov    %eax,%ebx
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	85 c0                	test   %eax,%eax
  802179:	0f 88 04 01 00 00    	js     802283 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802185:	50                   	push   %eax
  802186:	e8 66 f0 ff ff       	call   8011f1 <fd_alloc>
  80218b:	89 c3                	mov    %eax,%ebx
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	85 c0                	test   %eax,%eax
  802192:	0f 88 db 00 00 00    	js     802273 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802198:	83 ec 04             	sub    $0x4,%esp
  80219b:	68 07 04 00 00       	push   $0x407
  8021a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a3:	6a 00                	push   $0x0
  8021a5:	e8 2b ed ff ff       	call   800ed5 <sys_page_alloc>
  8021aa:	89 c3                	mov    %eax,%ebx
  8021ac:	83 c4 10             	add    $0x10,%esp
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	0f 88 bc 00 00 00    	js     802273 <pipe+0x131>
	va = fd2data(fd0);
  8021b7:	83 ec 0c             	sub    $0xc,%esp
  8021ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bd:	e8 18 f0 ff ff       	call   8011da <fd2data>
  8021c2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c4:	83 c4 0c             	add    $0xc,%esp
  8021c7:	68 07 04 00 00       	push   $0x407
  8021cc:	50                   	push   %eax
  8021cd:	6a 00                	push   $0x0
  8021cf:	e8 01 ed ff ff       	call   800ed5 <sys_page_alloc>
  8021d4:	89 c3                	mov    %eax,%ebx
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	0f 88 82 00 00 00    	js     802263 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e7:	e8 ee ef ff ff       	call   8011da <fd2data>
  8021ec:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8021f3:	50                   	push   %eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	56                   	push   %esi
  8021f7:	6a 00                	push   $0x0
  8021f9:	e8 1a ed ff ff       	call   800f18 <sys_page_map>
  8021fe:	89 c3                	mov    %eax,%ebx
  802200:	83 c4 20             	add    $0x20,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	78 4e                	js     802255 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802207:	a1 40 30 80 00       	mov    0x803040,%eax
  80220c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802214:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80221b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802223:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80222a:	83 ec 0c             	sub    $0xc,%esp
  80222d:	ff 75 f4             	pushl  -0xc(%ebp)
  802230:	e8 95 ef ff ff       	call   8011ca <fd2num>
  802235:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802238:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80223a:	83 c4 04             	add    $0x4,%esp
  80223d:	ff 75 f0             	pushl  -0x10(%ebp)
  802240:	e8 85 ef ff ff       	call   8011ca <fd2num>
  802245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802248:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802253:	eb 2e                	jmp    802283 <pipe+0x141>
	sys_page_unmap(0, va);
  802255:	83 ec 08             	sub    $0x8,%esp
  802258:	56                   	push   %esi
  802259:	6a 00                	push   $0x0
  80225b:	e8 fa ec ff ff       	call   800f5a <sys_page_unmap>
  802260:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802263:	83 ec 08             	sub    $0x8,%esp
  802266:	ff 75 f0             	pushl  -0x10(%ebp)
  802269:	6a 00                	push   $0x0
  80226b:	e8 ea ec ff ff       	call   800f5a <sys_page_unmap>
  802270:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802273:	83 ec 08             	sub    $0x8,%esp
  802276:	ff 75 f4             	pushl  -0xc(%ebp)
  802279:	6a 00                	push   $0x0
  80227b:	e8 da ec ff ff       	call   800f5a <sys_page_unmap>
  802280:	83 c4 10             	add    $0x10,%esp
}
  802283:	89 d8                	mov    %ebx,%eax
  802285:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802288:	5b                   	pop    %ebx
  802289:	5e                   	pop    %esi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    

0080228c <pipeisclosed>:
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802292:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802295:	50                   	push   %eax
  802296:	ff 75 08             	pushl  0x8(%ebp)
  802299:	e8 a5 ef ff ff       	call   801243 <fd_lookup>
  80229e:	83 c4 10             	add    $0x10,%esp
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 18                	js     8022bd <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ab:	e8 2a ef ff ff       	call   8011da <fd2data>
	return _pipeisclosed(fd, p);
  8022b0:	89 c2                	mov    %eax,%edx
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	e8 2f fd ff ff       	call   801fe9 <_pipeisclosed>
  8022ba:	83 c4 10             	add    $0x10,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	c3                   	ret    

008022c5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022cb:	68 93 2d 80 00       	push   $0x802d93
  8022d0:	ff 75 0c             	pushl  0xc(%ebp)
  8022d3:	e8 0b e8 ff ff       	call   800ae3 <strcpy>
	return 0;
}
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <devcons_write>:
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	57                   	push   %edi
  8022e3:	56                   	push   %esi
  8022e4:	53                   	push   %ebx
  8022e5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022eb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022f0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022f6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f9:	73 31                	jae    80232c <devcons_write+0x4d>
		m = n - tot;
  8022fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022fe:	29 f3                	sub    %esi,%ebx
  802300:	83 fb 7f             	cmp    $0x7f,%ebx
  802303:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802308:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	53                   	push   %ebx
  80230f:	89 f0                	mov    %esi,%eax
  802311:	03 45 0c             	add    0xc(%ebp),%eax
  802314:	50                   	push   %eax
  802315:	57                   	push   %edi
  802316:	e8 56 e9 ff ff       	call   800c71 <memmove>
		sys_cputs(buf, m);
  80231b:	83 c4 08             	add    $0x8,%esp
  80231e:	53                   	push   %ebx
  80231f:	57                   	push   %edi
  802320:	e8 f4 ea ff ff       	call   800e19 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802325:	01 de                	add    %ebx,%esi
  802327:	83 c4 10             	add    $0x10,%esp
  80232a:	eb ca                	jmp    8022f6 <devcons_write+0x17>
}
  80232c:	89 f0                	mov    %esi,%eax
  80232e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <devcons_read>:
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 08             	sub    $0x8,%esp
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802341:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802345:	74 21                	je     802368 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802347:	e8 eb ea ff ff       	call   800e37 <sys_cgetc>
  80234c:	85 c0                	test   %eax,%eax
  80234e:	75 07                	jne    802357 <devcons_read+0x21>
		sys_yield();
  802350:	e8 61 eb ff ff       	call   800eb6 <sys_yield>
  802355:	eb f0                	jmp    802347 <devcons_read+0x11>
	if (c < 0)
  802357:	78 0f                	js     802368 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802359:	83 f8 04             	cmp    $0x4,%eax
  80235c:	74 0c                	je     80236a <devcons_read+0x34>
	*(char*)vbuf = c;
  80235e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802361:	88 02                	mov    %al,(%edx)
	return 1;
  802363:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    
		return 0;
  80236a:	b8 00 00 00 00       	mov    $0x0,%eax
  80236f:	eb f7                	jmp    802368 <devcons_read+0x32>

00802371 <cputchar>:
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80237d:	6a 01                	push   $0x1
  80237f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802382:	50                   	push   %eax
  802383:	e8 91 ea ff ff       	call   800e19 <sys_cputs>
}
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	c9                   	leave  
  80238c:	c3                   	ret    

0080238d <getchar>:
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802393:	6a 01                	push   $0x1
  802395:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802398:	50                   	push   %eax
  802399:	6a 00                	push   $0x0
  80239b:	e8 13 f1 ff ff       	call   8014b3 <read>
	if (r < 0)
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	78 06                	js     8023ad <getchar+0x20>
	if (r < 1)
  8023a7:	74 06                	je     8023af <getchar+0x22>
	return c;
  8023a9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    
		return -E_EOF;
  8023af:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023b4:	eb f7                	jmp    8023ad <getchar+0x20>

008023b6 <iscons>:
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023bf:	50                   	push   %eax
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	e8 7b ee ff ff       	call   801243 <fd_lookup>
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	78 11                	js     8023e0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8023d8:	39 10                	cmp    %edx,(%eax)
  8023da:	0f 94 c0             	sete   %al
  8023dd:	0f b6 c0             	movzbl %al,%eax
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <opencons>:
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023eb:	50                   	push   %eax
  8023ec:	e8 00 ee ff ff       	call   8011f1 <fd_alloc>
  8023f1:	83 c4 10             	add    $0x10,%esp
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	78 3a                	js     802432 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	68 07 04 00 00       	push   $0x407
  802400:	ff 75 f4             	pushl  -0xc(%ebp)
  802403:	6a 00                	push   $0x0
  802405:	e8 cb ea ff ff       	call   800ed5 <sys_page_alloc>
  80240a:	83 c4 10             	add    $0x10,%esp
  80240d:	85 c0                	test   %eax,%eax
  80240f:	78 21                	js     802432 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80241a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802426:	83 ec 0c             	sub    $0xc,%esp
  802429:	50                   	push   %eax
  80242a:	e8 9b ed ff ff       	call   8011ca <fd2num>
  80242f:	83 c4 10             	add    $0x10,%esp
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	56                   	push   %esi
  802438:	53                   	push   %ebx
  802439:	8b 75 08             	mov    0x8(%ebp),%esi
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802442:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802444:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802449:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80244c:	83 ec 0c             	sub    $0xc,%esp
  80244f:	50                   	push   %eax
  802450:	e8 30 ec ff ff       	call   801085 <sys_ipc_recv>
	if(ret < 0){
  802455:	83 c4 10             	add    $0x10,%esp
  802458:	85 c0                	test   %eax,%eax
  80245a:	78 2b                	js     802487 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80245c:	85 f6                	test   %esi,%esi
  80245e:	74 0a                	je     80246a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802460:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802465:	8b 40 74             	mov    0x74(%eax),%eax
  802468:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80246a:	85 db                	test   %ebx,%ebx
  80246c:	74 0a                	je     802478 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80246e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802473:	8b 40 78             	mov    0x78(%eax),%eax
  802476:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802478:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80247d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802480:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802483:	5b                   	pop    %ebx
  802484:	5e                   	pop    %esi
  802485:	5d                   	pop    %ebp
  802486:	c3                   	ret    
		if(from_env_store)
  802487:	85 f6                	test   %esi,%esi
  802489:	74 06                	je     802491 <ipc_recv+0x5d>
			*from_env_store = 0;
  80248b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802491:	85 db                	test   %ebx,%ebx
  802493:	74 eb                	je     802480 <ipc_recv+0x4c>
			*perm_store = 0;
  802495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80249b:	eb e3                	jmp    802480 <ipc_recv+0x4c>

0080249d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	57                   	push   %edi
  8024a1:	56                   	push   %esi
  8024a2:	53                   	push   %ebx
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8024af:	85 db                	test   %ebx,%ebx
  8024b1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024b6:	0f 44 d8             	cmove  %eax,%ebx
  8024b9:	eb 05                	jmp    8024c0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8024bb:	e8 f6 e9 ff ff       	call   800eb6 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8024c0:	ff 75 14             	pushl  0x14(%ebp)
  8024c3:	53                   	push   %ebx
  8024c4:	56                   	push   %esi
  8024c5:	57                   	push   %edi
  8024c6:	e8 97 eb ff ff       	call   801062 <sys_ipc_try_send>
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 1b                	je     8024ed <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8024d2:	79 e7                	jns    8024bb <ipc_send+0x1e>
  8024d4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024d7:	74 e2                	je     8024bb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	68 9f 2d 80 00       	push   $0x802d9f
  8024e1:	6a 46                	push   $0x46
  8024e3:	68 b4 2d 80 00       	push   $0x802db4
  8024e8:	e8 a1 dd ff ff       	call   80028e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8024ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    

008024f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802500:	89 c2                	mov    %eax,%edx
  802502:	c1 e2 07             	shl    $0x7,%edx
  802505:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80250b:	8b 52 50             	mov    0x50(%edx),%edx
  80250e:	39 ca                	cmp    %ecx,%edx
  802510:	74 11                	je     802523 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802512:	83 c0 01             	add    $0x1,%eax
  802515:	3d 00 04 00 00       	cmp    $0x400,%eax
  80251a:	75 e4                	jne    802500 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
  802521:	eb 0b                	jmp    80252e <ipc_find_env+0x39>
			return envs[i].env_id;
  802523:	c1 e0 07             	shl    $0x7,%eax
  802526:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80252b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    

00802530 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802536:	89 d0                	mov    %edx,%eax
  802538:	c1 e8 16             	shr    $0x16,%eax
  80253b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802542:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802547:	f6 c1 01             	test   $0x1,%cl
  80254a:	74 1d                	je     802569 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80254c:	c1 ea 0c             	shr    $0xc,%edx
  80254f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802556:	f6 c2 01             	test   $0x1,%dl
  802559:	74 0e                	je     802569 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80255b:	c1 ea 0c             	shr    $0xc,%edx
  80255e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802565:	ef 
  802566:	0f b7 c0             	movzwl %ax,%eax
}
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    
  80256b:	66 90                	xchg   %ax,%ax
  80256d:	66 90                	xchg   %ax,%ax
  80256f:	90                   	nop

00802570 <__udivdi3>:
  802570:	55                   	push   %ebp
  802571:	57                   	push   %edi
  802572:	56                   	push   %esi
  802573:	53                   	push   %ebx
  802574:	83 ec 1c             	sub    $0x1c,%esp
  802577:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80257b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80257f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802583:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802587:	85 d2                	test   %edx,%edx
  802589:	75 4d                	jne    8025d8 <__udivdi3+0x68>
  80258b:	39 f3                	cmp    %esi,%ebx
  80258d:	76 19                	jbe    8025a8 <__udivdi3+0x38>
  80258f:	31 ff                	xor    %edi,%edi
  802591:	89 e8                	mov    %ebp,%eax
  802593:	89 f2                	mov    %esi,%edx
  802595:	f7 f3                	div    %ebx
  802597:	89 fa                	mov    %edi,%edx
  802599:	83 c4 1c             	add    $0x1c,%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5e                   	pop    %esi
  80259e:	5f                   	pop    %edi
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    
  8025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	89 d9                	mov    %ebx,%ecx
  8025aa:	85 db                	test   %ebx,%ebx
  8025ac:	75 0b                	jne    8025b9 <__udivdi3+0x49>
  8025ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b3:	31 d2                	xor    %edx,%edx
  8025b5:	f7 f3                	div    %ebx
  8025b7:	89 c1                	mov    %eax,%ecx
  8025b9:	31 d2                	xor    %edx,%edx
  8025bb:	89 f0                	mov    %esi,%eax
  8025bd:	f7 f1                	div    %ecx
  8025bf:	89 c6                	mov    %eax,%esi
  8025c1:	89 e8                	mov    %ebp,%eax
  8025c3:	89 f7                	mov    %esi,%edi
  8025c5:	f7 f1                	div    %ecx
  8025c7:	89 fa                	mov    %edi,%edx
  8025c9:	83 c4 1c             	add    $0x1c,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5f                   	pop    %edi
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	39 f2                	cmp    %esi,%edx
  8025da:	77 1c                	ja     8025f8 <__udivdi3+0x88>
  8025dc:	0f bd fa             	bsr    %edx,%edi
  8025df:	83 f7 1f             	xor    $0x1f,%edi
  8025e2:	75 2c                	jne    802610 <__udivdi3+0xa0>
  8025e4:	39 f2                	cmp    %esi,%edx
  8025e6:	72 06                	jb     8025ee <__udivdi3+0x7e>
  8025e8:	31 c0                	xor    %eax,%eax
  8025ea:	39 eb                	cmp    %ebp,%ebx
  8025ec:	77 a9                	ja     802597 <__udivdi3+0x27>
  8025ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f3:	eb a2                	jmp    802597 <__udivdi3+0x27>
  8025f5:	8d 76 00             	lea    0x0(%esi),%esi
  8025f8:	31 ff                	xor    %edi,%edi
  8025fa:	31 c0                	xor    %eax,%eax
  8025fc:	89 fa                	mov    %edi,%edx
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80260d:	8d 76 00             	lea    0x0(%esi),%esi
  802610:	89 f9                	mov    %edi,%ecx
  802612:	b8 20 00 00 00       	mov    $0x20,%eax
  802617:	29 f8                	sub    %edi,%eax
  802619:	d3 e2                	shl    %cl,%edx
  80261b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80261f:	89 c1                	mov    %eax,%ecx
  802621:	89 da                	mov    %ebx,%edx
  802623:	d3 ea                	shr    %cl,%edx
  802625:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802629:	09 d1                	or     %edx,%ecx
  80262b:	89 f2                	mov    %esi,%edx
  80262d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802631:	89 f9                	mov    %edi,%ecx
  802633:	d3 e3                	shl    %cl,%ebx
  802635:	89 c1                	mov    %eax,%ecx
  802637:	d3 ea                	shr    %cl,%edx
  802639:	89 f9                	mov    %edi,%ecx
  80263b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80263f:	89 eb                	mov    %ebp,%ebx
  802641:	d3 e6                	shl    %cl,%esi
  802643:	89 c1                	mov    %eax,%ecx
  802645:	d3 eb                	shr    %cl,%ebx
  802647:	09 de                	or     %ebx,%esi
  802649:	89 f0                	mov    %esi,%eax
  80264b:	f7 74 24 08          	divl   0x8(%esp)
  80264f:	89 d6                	mov    %edx,%esi
  802651:	89 c3                	mov    %eax,%ebx
  802653:	f7 64 24 0c          	mull   0xc(%esp)
  802657:	39 d6                	cmp    %edx,%esi
  802659:	72 15                	jb     802670 <__udivdi3+0x100>
  80265b:	89 f9                	mov    %edi,%ecx
  80265d:	d3 e5                	shl    %cl,%ebp
  80265f:	39 c5                	cmp    %eax,%ebp
  802661:	73 04                	jae    802667 <__udivdi3+0xf7>
  802663:	39 d6                	cmp    %edx,%esi
  802665:	74 09                	je     802670 <__udivdi3+0x100>
  802667:	89 d8                	mov    %ebx,%eax
  802669:	31 ff                	xor    %edi,%edi
  80266b:	e9 27 ff ff ff       	jmp    802597 <__udivdi3+0x27>
  802670:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802673:	31 ff                	xor    %edi,%edi
  802675:	e9 1d ff ff ff       	jmp    802597 <__udivdi3+0x27>
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	66 90                	xchg   %ax,%ax
  80267e:	66 90                	xchg   %ax,%ax

00802680 <__umoddi3>:
  802680:	55                   	push   %ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
  802684:	83 ec 1c             	sub    $0x1c,%esp
  802687:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80268b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80268f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802697:	89 da                	mov    %ebx,%edx
  802699:	85 c0                	test   %eax,%eax
  80269b:	75 43                	jne    8026e0 <__umoddi3+0x60>
  80269d:	39 df                	cmp    %ebx,%edi
  80269f:	76 17                	jbe    8026b8 <__umoddi3+0x38>
  8026a1:	89 f0                	mov    %esi,%eax
  8026a3:	f7 f7                	div    %edi
  8026a5:	89 d0                	mov    %edx,%eax
  8026a7:	31 d2                	xor    %edx,%edx
  8026a9:	83 c4 1c             	add    $0x1c,%esp
  8026ac:	5b                   	pop    %ebx
  8026ad:	5e                   	pop    %esi
  8026ae:	5f                   	pop    %edi
  8026af:	5d                   	pop    %ebp
  8026b0:	c3                   	ret    
  8026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b8:	89 fd                	mov    %edi,%ebp
  8026ba:	85 ff                	test   %edi,%edi
  8026bc:	75 0b                	jne    8026c9 <__umoddi3+0x49>
  8026be:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c3:	31 d2                	xor    %edx,%edx
  8026c5:	f7 f7                	div    %edi
  8026c7:	89 c5                	mov    %eax,%ebp
  8026c9:	89 d8                	mov    %ebx,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f5                	div    %ebp
  8026cf:	89 f0                	mov    %esi,%eax
  8026d1:	f7 f5                	div    %ebp
  8026d3:	89 d0                	mov    %edx,%eax
  8026d5:	eb d0                	jmp    8026a7 <__umoddi3+0x27>
  8026d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026de:	66 90                	xchg   %ax,%ax
  8026e0:	89 f1                	mov    %esi,%ecx
  8026e2:	39 d8                	cmp    %ebx,%eax
  8026e4:	76 0a                	jbe    8026f0 <__umoddi3+0x70>
  8026e6:	89 f0                	mov    %esi,%eax
  8026e8:	83 c4 1c             	add    $0x1c,%esp
  8026eb:	5b                   	pop    %ebx
  8026ec:	5e                   	pop    %esi
  8026ed:	5f                   	pop    %edi
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    
  8026f0:	0f bd e8             	bsr    %eax,%ebp
  8026f3:	83 f5 1f             	xor    $0x1f,%ebp
  8026f6:	75 20                	jne    802718 <__umoddi3+0x98>
  8026f8:	39 d8                	cmp    %ebx,%eax
  8026fa:	0f 82 b0 00 00 00    	jb     8027b0 <__umoddi3+0x130>
  802700:	39 f7                	cmp    %esi,%edi
  802702:	0f 86 a8 00 00 00    	jbe    8027b0 <__umoddi3+0x130>
  802708:	89 c8                	mov    %ecx,%eax
  80270a:	83 c4 1c             	add    $0x1c,%esp
  80270d:	5b                   	pop    %ebx
  80270e:	5e                   	pop    %esi
  80270f:	5f                   	pop    %edi
  802710:	5d                   	pop    %ebp
  802711:	c3                   	ret    
  802712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802718:	89 e9                	mov    %ebp,%ecx
  80271a:	ba 20 00 00 00       	mov    $0x20,%edx
  80271f:	29 ea                	sub    %ebp,%edx
  802721:	d3 e0                	shl    %cl,%eax
  802723:	89 44 24 08          	mov    %eax,0x8(%esp)
  802727:	89 d1                	mov    %edx,%ecx
  802729:	89 f8                	mov    %edi,%eax
  80272b:	d3 e8                	shr    %cl,%eax
  80272d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802731:	89 54 24 04          	mov    %edx,0x4(%esp)
  802735:	8b 54 24 04          	mov    0x4(%esp),%edx
  802739:	09 c1                	or     %eax,%ecx
  80273b:	89 d8                	mov    %ebx,%eax
  80273d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802741:	89 e9                	mov    %ebp,%ecx
  802743:	d3 e7                	shl    %cl,%edi
  802745:	89 d1                	mov    %edx,%ecx
  802747:	d3 e8                	shr    %cl,%eax
  802749:	89 e9                	mov    %ebp,%ecx
  80274b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80274f:	d3 e3                	shl    %cl,%ebx
  802751:	89 c7                	mov    %eax,%edi
  802753:	89 d1                	mov    %edx,%ecx
  802755:	89 f0                	mov    %esi,%eax
  802757:	d3 e8                	shr    %cl,%eax
  802759:	89 e9                	mov    %ebp,%ecx
  80275b:	89 fa                	mov    %edi,%edx
  80275d:	d3 e6                	shl    %cl,%esi
  80275f:	09 d8                	or     %ebx,%eax
  802761:	f7 74 24 08          	divl   0x8(%esp)
  802765:	89 d1                	mov    %edx,%ecx
  802767:	89 f3                	mov    %esi,%ebx
  802769:	f7 64 24 0c          	mull   0xc(%esp)
  80276d:	89 c6                	mov    %eax,%esi
  80276f:	89 d7                	mov    %edx,%edi
  802771:	39 d1                	cmp    %edx,%ecx
  802773:	72 06                	jb     80277b <__umoddi3+0xfb>
  802775:	75 10                	jne    802787 <__umoddi3+0x107>
  802777:	39 c3                	cmp    %eax,%ebx
  802779:	73 0c                	jae    802787 <__umoddi3+0x107>
  80277b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80277f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802783:	89 d7                	mov    %edx,%edi
  802785:	89 c6                	mov    %eax,%esi
  802787:	89 ca                	mov    %ecx,%edx
  802789:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80278e:	29 f3                	sub    %esi,%ebx
  802790:	19 fa                	sbb    %edi,%edx
  802792:	89 d0                	mov    %edx,%eax
  802794:	d3 e0                	shl    %cl,%eax
  802796:	89 e9                	mov    %ebp,%ecx
  802798:	d3 eb                	shr    %cl,%ebx
  80279a:	d3 ea                	shr    %cl,%edx
  80279c:	09 d8                	or     %ebx,%eax
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	89 da                	mov    %ebx,%edx
  8027b2:	29 fe                	sub    %edi,%esi
  8027b4:	19 c2                	sbb    %eax,%edx
  8027b6:	89 f1                	mov    %esi,%ecx
  8027b8:	89 c8                	mov    %ecx,%eax
  8027ba:	e9 4b ff ff ff       	jmp    80270a <__umoddi3+0x8a>
