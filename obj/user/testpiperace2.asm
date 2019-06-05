
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 9f 01 00 00       	call   8001d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 20 2c 80 00       	push   $0x802c20
  800041:	e8 3c 03 00 00       	call   800382 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 a2 24 00 00       	call   8024f3 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5b                	js     8000b3 <umain+0x80>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 a0 13 00 00       	call   8013fd <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 62                	js     8000c5 <umain+0x92>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	74 72                	je     8000d7 <umain+0xa4>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800065:	89 fb                	mov    %edi,%ebx
  800067:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006d:	c1 e3 07             	shl    $0x7,%ebx
  800070:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800076:	8b 43 54             	mov    0x54(%ebx),%eax
  800079:	83 f8 02             	cmp    $0x2,%eax
  80007c:	0f 85 d1 00 00 00    	jne    800153 <umain+0x120>
		if (pipeisclosed(p[0]) != 0) {
  800082:	83 ec 0c             	sub    $0xc,%esp
  800085:	ff 75 e0             	pushl  -0x20(%ebp)
  800088:	e8 b0 25 00 00       	call   80263d <pipeisclosed>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	74 e2                	je     800076 <umain+0x43>
			cprintf("\nRACE: pipe appears closed\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 99 2c 80 00       	push   $0x802c99
  80009c:	e8 e1 02 00 00       	call   800382 <cprintf>
			sys_env_destroy(r);
  8000a1:	89 3c 24             	mov    %edi,(%esp)
  8000a4:	e8 ab 0d 00 00       	call   800e54 <sys_env_destroy>
			exit();
  8000a9:	e8 c4 01 00 00       	call   800272 <exit>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	eb c3                	jmp    800076 <umain+0x43>
		panic("pipe: %e", r);
  8000b3:	50                   	push   %eax
  8000b4:	68 6e 2c 80 00       	push   $0x802c6e
  8000b9:	6a 0d                	push   $0xd
  8000bb:	68 77 2c 80 00       	push   $0x802c77
  8000c0:	e8 c7 01 00 00       	call   80028c <_panic>
		panic("fork: %e", r);
  8000c5:	50                   	push   %eax
  8000c6:	68 8c 2c 80 00       	push   $0x802c8c
  8000cb:	6a 0f                	push   $0xf
  8000cd:	68 77 2c 80 00       	push   $0x802c77
  8000d2:	e8 b5 01 00 00       	call   80028c <_panic>
		close(p[1]);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000dd:	e8 58 17 00 00       	call   80183a <close>
  8000e2:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e5:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ec:	eb 42                	jmp    800130 <umain+0xfd>
				cprintf("%d.", i);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	53                   	push   %ebx
  8000f2:	68 95 2c 80 00       	push   $0x802c95
  8000f7:	e8 86 02 00 00       	call   800382 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	6a 0a                	push   $0xa
  800104:	ff 75 e0             	pushl  -0x20(%ebp)
  800107:	e8 80 17 00 00       	call   80188c <dup>
			sys_yield();
  80010c:	e8 a3 0d 00 00       	call   800eb4 <sys_yield>
			close(10);
  800111:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800118:	e8 1d 17 00 00       	call   80183a <close>
			sys_yield();
  80011d:	e8 92 0d 00 00       	call   800eb4 <sys_yield>
		for (i = 0; i < 200; i++) {
  800122:	83 c3 01             	add    $0x1,%ebx
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80012e:	74 19                	je     800149 <umain+0x116>
			if (i % 10 == 0)
  800130:	89 d8                	mov    %ebx,%eax
  800132:	f7 ee                	imul   %esi
  800134:	c1 fa 02             	sar    $0x2,%edx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	c1 f8 1f             	sar    $0x1f,%eax
  80013c:	29 c2                	sub    %eax,%edx
  80013e:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800141:	01 c0                	add    %eax,%eax
  800143:	39 c3                	cmp    %eax,%ebx
  800145:	75 b8                	jne    8000ff <umain+0xcc>
  800147:	eb a5                	jmp    8000ee <umain+0xbb>
		exit();
  800149:	e8 24 01 00 00       	call   800272 <exit>
  80014e:	e9 12 ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 b5 2c 80 00       	push   $0x802cb5
  80015b:	e8 22 02 00 00       	call   800382 <cprintf>
	if (pipeisclosed(p[0]))
  800160:	83 c4 04             	add    $0x4,%esp
  800163:	ff 75 e0             	pushl  -0x20(%ebp)
  800166:	e8 d2 24 00 00       	call   80263d <pipeisclosed>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	85 c0                	test   %eax,%eax
  800170:	75 38                	jne    8001aa <umain+0x177>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	ff 75 e0             	pushl  -0x20(%ebp)
  80017c:	e8 87 15 00 00       	call   801708 <fd_lookup>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 36                	js     8001be <umain+0x18b>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 dc             	pushl  -0x24(%ebp)
  80018e:	e8 0c 15 00 00       	call   80169f <fd2data>
	cprintf("race didn't happen\n");
  800193:	c7 04 24 e3 2c 80 00 	movl   $0x802ce3,(%esp)
  80019a:	e8 e3 01 00 00       	call   800382 <cprintf>
}
  80019f:	83 c4 10             	add    $0x10,%esp
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 44 2c 80 00       	push   $0x802c44
  8001b2:	6a 40                	push   $0x40
  8001b4:	68 77 2c 80 00       	push   $0x802c77
  8001b9:	e8 ce 00 00 00       	call   80028c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001be:	50                   	push   %eax
  8001bf:	68 cb 2c 80 00       	push   $0x802ccb
  8001c4:	6a 42                	push   $0x42
  8001c6:	68 77 2c 80 00       	push   $0x802c77
  8001cb:	e8 bc 00 00 00       	call   80028c <_panic>

008001d0 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8001d9:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001e0:	00 00 00 
	envid_t find = sys_getenvid();
  8001e3:	e8 ad 0c 00 00       	call   800e95 <sys_getenvid>
  8001e8:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  8001ee:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8001f3:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8001f8:	bf 01 00 00 00       	mov    $0x1,%edi
  8001fd:	eb 0b                	jmp    80020a <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8001ff:	83 c2 01             	add    $0x1,%edx
  800202:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800208:	74 21                	je     80022b <libmain+0x5b>
		if(envs[i].env_id == find)
  80020a:	89 d1                	mov    %edx,%ecx
  80020c:	c1 e1 07             	shl    $0x7,%ecx
  80020f:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800215:	8b 49 48             	mov    0x48(%ecx),%ecx
  800218:	39 c1                	cmp    %eax,%ecx
  80021a:	75 e3                	jne    8001ff <libmain+0x2f>
  80021c:	89 d3                	mov    %edx,%ebx
  80021e:	c1 e3 07             	shl    $0x7,%ebx
  800221:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800227:	89 fe                	mov    %edi,%esi
  800229:	eb d4                	jmp    8001ff <libmain+0x2f>
  80022b:	89 f0                	mov    %esi,%eax
  80022d:	84 c0                	test   %al,%al
  80022f:	74 06                	je     800237 <libmain+0x67>
  800231:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023b:	7e 0a                	jle    800247 <libmain+0x77>
		binaryname = argv[0];
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	8b 00                	mov    (%eax),%eax
  800242:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("in libmain.c call umain!\n");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 f7 2c 80 00       	push   $0x802cf7
  80024f:	e8 2e 01 00 00       	call   800382 <cprintf>
	// call user main routine
	umain(argc, argv);
  800254:	83 c4 08             	add    $0x8,%esp
  800257:	ff 75 0c             	pushl  0xc(%ebp)
  80025a:	ff 75 08             	pushl  0x8(%ebp)
  80025d:	e8 d1 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800262:	e8 0b 00 00 00       	call   800272 <exit>
}
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026d:	5b                   	pop    %ebx
  80026e:	5e                   	pop    %esi
  80026f:	5f                   	pop    %edi
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800278:	e8 ea 15 00 00       	call   801867 <close_all>
	sys_env_destroy(0);
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	6a 00                	push   $0x0
  800282:	e8 cd 0b 00 00       	call   800e54 <sys_env_destroy>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800291:	a1 08 50 80 00       	mov    0x805008,%eax
  800296:	8b 40 48             	mov    0x48(%eax),%eax
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 4c 2d 80 00       	push   $0x802d4c
  8002a1:	50                   	push   %eax
  8002a2:	68 1b 2d 80 00       	push   $0x802d1b
  8002a7:	e8 d6 00 00 00       	call   800382 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8002ac:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002af:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002b5:	e8 db 0b 00 00       	call   800e95 <sys_getenvid>
  8002ba:	83 c4 04             	add    $0x4,%esp
  8002bd:	ff 75 0c             	pushl  0xc(%ebp)
  8002c0:	ff 75 08             	pushl  0x8(%ebp)
  8002c3:	56                   	push   %esi
  8002c4:	50                   	push   %eax
  8002c5:	68 28 2d 80 00       	push   $0x802d28
  8002ca:	e8 b3 00 00 00       	call   800382 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cf:	83 c4 18             	add    $0x18,%esp
  8002d2:	53                   	push   %ebx
  8002d3:	ff 75 10             	pushl  0x10(%ebp)
  8002d6:	e8 56 00 00 00       	call   800331 <vcprintf>
	cprintf("\n");
  8002db:	c7 04 24 0f 2d 80 00 	movl   $0x802d0f,(%esp)
  8002e2:	e8 9b 00 00 00       	call   800382 <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ea:	cc                   	int3   
  8002eb:	eb fd                	jmp    8002ea <_panic+0x5e>

008002ed <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	53                   	push   %ebx
  8002f1:	83 ec 04             	sub    $0x4,%esp
  8002f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f7:	8b 13                	mov    (%ebx),%edx
  8002f9:	8d 42 01             	lea    0x1(%edx),%eax
  8002fc:	89 03                	mov    %eax,(%ebx)
  8002fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800301:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800305:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030a:	74 09                	je     800315 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800313:	c9                   	leave  
  800314:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	68 ff 00 00 00       	push   $0xff
  80031d:	8d 43 08             	lea    0x8(%ebx),%eax
  800320:	50                   	push   %eax
  800321:	e8 f1 0a 00 00       	call   800e17 <sys_cputs>
		b->idx = 0;
  800326:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032c:	83 c4 10             	add    $0x10,%esp
  80032f:	eb db                	jmp    80030c <putch+0x1f>

00800331 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800341:	00 00 00 
	b.cnt = 0;
  800344:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 08             	pushl  0x8(%ebp)
  800354:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035a:	50                   	push   %eax
  80035b:	68 ed 02 80 00       	push   $0x8002ed
  800360:	e8 4a 01 00 00       	call   8004af <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800365:	83 c4 08             	add    $0x8,%esp
  800368:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80036e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800374:	50                   	push   %eax
  800375:	e8 9d 0a 00 00       	call   800e17 <sys_cputs>

	return b.cnt;
}
  80037a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038b:	50                   	push   %eax
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 9d ff ff ff       	call   800331 <vcprintf>
	va_end(ap);

	return cnt;
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
  80039c:	83 ec 1c             	sub    $0x1c,%esp
  80039f:	89 c6                	mov    %eax,%esi
  8003a1:	89 d7                	mov    %edx,%edi
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003b5:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003b9:	74 2c                	je     8003e7 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003be:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003cb:	39 c2                	cmp    %eax,%edx
  8003cd:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003d0:	73 43                	jae    800415 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003d2:	83 eb 01             	sub    $0x1,%ebx
  8003d5:	85 db                	test   %ebx,%ebx
  8003d7:	7e 6c                	jle    800445 <printnum+0xaf>
				putch(padc, putdat);
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	57                   	push   %edi
  8003dd:	ff 75 18             	pushl  0x18(%ebp)
  8003e0:	ff d6                	call   *%esi
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	eb eb                	jmp    8003d2 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003e7:	83 ec 0c             	sub    $0xc,%esp
  8003ea:	6a 20                	push   $0x20
  8003ec:	6a 00                	push   $0x0
  8003ee:	50                   	push   %eax
  8003ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	89 fa                	mov    %edi,%edx
  8003f7:	89 f0                	mov    %esi,%eax
  8003f9:	e8 98 ff ff ff       	call   800396 <printnum>
		while (--width > 0)
  8003fe:	83 c4 20             	add    $0x20,%esp
  800401:	83 eb 01             	sub    $0x1,%ebx
  800404:	85 db                	test   %ebx,%ebx
  800406:	7e 65                	jle    80046d <printnum+0xd7>
			putch(padc, putdat);
  800408:	83 ec 08             	sub    $0x8,%esp
  80040b:	57                   	push   %edi
  80040c:	6a 20                	push   $0x20
  80040e:	ff d6                	call   *%esi
  800410:	83 c4 10             	add    $0x10,%esp
  800413:	eb ec                	jmp    800401 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 18             	pushl  0x18(%ebp)
  80041b:	83 eb 01             	sub    $0x1,%ebx
  80041e:	53                   	push   %ebx
  80041f:	50                   	push   %eax
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	ff 75 dc             	pushl  -0x24(%ebp)
  800426:	ff 75 d8             	pushl  -0x28(%ebp)
  800429:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042c:	ff 75 e0             	pushl  -0x20(%ebp)
  80042f:	e8 8c 25 00 00       	call   8029c0 <__udivdi3>
  800434:	83 c4 18             	add    $0x18,%esp
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	89 fa                	mov    %edi,%edx
  80043b:	89 f0                	mov    %esi,%eax
  80043d:	e8 54 ff ff ff       	call   800396 <printnum>
  800442:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	57                   	push   %edi
  800449:	83 ec 04             	sub    $0x4,%esp
  80044c:	ff 75 dc             	pushl  -0x24(%ebp)
  80044f:	ff 75 d8             	pushl  -0x28(%ebp)
  800452:	ff 75 e4             	pushl  -0x1c(%ebp)
  800455:	ff 75 e0             	pushl  -0x20(%ebp)
  800458:	e8 73 26 00 00       	call   802ad0 <__umoddi3>
  80045d:	83 c4 14             	add    $0x14,%esp
  800460:	0f be 80 53 2d 80 00 	movsbl 0x802d53(%eax),%eax
  800467:	50                   	push   %eax
  800468:	ff d6                	call   *%esi
  80046a:	83 c4 10             	add    $0x10,%esp
	}
}
  80046d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800470:	5b                   	pop    %ebx
  800471:	5e                   	pop    %esi
  800472:	5f                   	pop    %edi
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80047b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80047f:	8b 10                	mov    (%eax),%edx
  800481:	3b 50 04             	cmp    0x4(%eax),%edx
  800484:	73 0a                	jae    800490 <sprintputch+0x1b>
		*b->buf++ = ch;
  800486:	8d 4a 01             	lea    0x1(%edx),%ecx
  800489:	89 08                	mov    %ecx,(%eax)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	88 02                	mov    %al,(%edx)
}
  800490:	5d                   	pop    %ebp
  800491:	c3                   	ret    

00800492 <printfmt>:
{
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800498:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80049b:	50                   	push   %eax
  80049c:	ff 75 10             	pushl  0x10(%ebp)
  80049f:	ff 75 0c             	pushl  0xc(%ebp)
  8004a2:	ff 75 08             	pushl  0x8(%ebp)
  8004a5:	e8 05 00 00 00       	call   8004af <vprintfmt>
}
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	c9                   	leave  
  8004ae:	c3                   	ret    

008004af <vprintfmt>:
{
  8004af:	55                   	push   %ebp
  8004b0:	89 e5                	mov    %esp,%ebp
  8004b2:	57                   	push   %edi
  8004b3:	56                   	push   %esi
  8004b4:	53                   	push   %ebx
  8004b5:	83 ec 3c             	sub    $0x3c,%esp
  8004b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004c1:	e9 32 04 00 00       	jmp    8008f8 <vprintfmt+0x449>
		padc = ' ';
  8004c6:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004ca:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004d1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004df:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004ed:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8d 47 01             	lea    0x1(%edi),%eax
  8004f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004f8:	0f b6 17             	movzbl (%edi),%edx
  8004fb:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004fe:	3c 55                	cmp    $0x55,%al
  800500:	0f 87 12 05 00 00    	ja     800a18 <vprintfmt+0x569>
  800506:	0f b6 c0             	movzbl %al,%eax
  800509:	ff 24 85 40 2f 80 00 	jmp    *0x802f40(,%eax,4)
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800513:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800517:	eb d9                	jmp    8004f2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800519:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80051c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800520:	eb d0                	jmp    8004f2 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800522:	0f b6 d2             	movzbl %dl,%edx
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800528:	b8 00 00 00 00       	mov    $0x0,%eax
  80052d:	89 75 08             	mov    %esi,0x8(%ebp)
  800530:	eb 03                	jmp    800535 <vprintfmt+0x86>
  800532:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800535:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800538:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80053c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80053f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800542:	83 fe 09             	cmp    $0x9,%esi
  800545:	76 eb                	jbe    800532 <vprintfmt+0x83>
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	8b 75 08             	mov    0x8(%ebp),%esi
  80054d:	eb 14                	jmp    800563 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 40 04             	lea    0x4(%eax),%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800560:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800563:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800567:	79 89                	jns    8004f2 <vprintfmt+0x43>
				width = precision, precision = -1;
  800569:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80056c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80056f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800576:	e9 77 ff ff ff       	jmp    8004f2 <vprintfmt+0x43>
  80057b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	0f 48 c1             	cmovs  %ecx,%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800586:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800589:	e9 64 ff ff ff       	jmp    8004f2 <vprintfmt+0x43>
  80058e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800591:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800598:	e9 55 ff ff ff       	jmp    8004f2 <vprintfmt+0x43>
			lflag++;
  80059d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005a4:	e9 49 ff ff ff       	jmp    8004f2 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8d 78 04             	lea    0x4(%eax),%edi
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	53                   	push   %ebx
  8005b3:	ff 30                	pushl  (%eax)
  8005b5:	ff d6                	call   *%esi
			break;
  8005b7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005ba:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005bd:	e9 33 03 00 00       	jmp    8008f5 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 78 04             	lea    0x4(%eax),%edi
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	99                   	cltd   
  8005cb:	31 d0                	xor    %edx,%eax
  8005cd:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005cf:	83 f8 10             	cmp    $0x10,%eax
  8005d2:	7f 23                	jg     8005f7 <vprintfmt+0x148>
  8005d4:	8b 14 85 a0 30 80 00 	mov    0x8030a0(,%eax,4),%edx
  8005db:	85 d2                	test   %edx,%edx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005df:	52                   	push   %edx
  8005e0:	68 a9 32 80 00       	push   $0x8032a9
  8005e5:	53                   	push   %ebx
  8005e6:	56                   	push   %esi
  8005e7:	e8 a6 fe ff ff       	call   800492 <printfmt>
  8005ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ef:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f2:	e9 fe 02 00 00       	jmp    8008f5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f7:	50                   	push   %eax
  8005f8:	68 6b 2d 80 00       	push   $0x802d6b
  8005fd:	53                   	push   %ebx
  8005fe:	56                   	push   %esi
  8005ff:	e8 8e fe ff ff       	call   800492 <printfmt>
  800604:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800607:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80060a:	e9 e6 02 00 00       	jmp    8008f5 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	83 c0 04             	add    $0x4,%eax
  800615:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80061d:	85 c9                	test   %ecx,%ecx
  80061f:	b8 64 2d 80 00       	mov    $0x802d64,%eax
  800624:	0f 45 c1             	cmovne %ecx,%eax
  800627:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80062a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80062e:	7e 06                	jle    800636 <vprintfmt+0x187>
  800630:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800634:	75 0d                	jne    800643 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800636:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800639:	89 c7                	mov    %eax,%edi
  80063b:	03 45 e0             	add    -0x20(%ebp),%eax
  80063e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800641:	eb 53                	jmp    800696 <vprintfmt+0x1e7>
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 d8             	pushl  -0x28(%ebp)
  800649:	50                   	push   %eax
  80064a:	e8 71 04 00 00       	call   800ac0 <strnlen>
  80064f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800652:	29 c1                	sub    %eax,%ecx
  800654:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80065c:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800663:	eb 0f                	jmp    800674 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	53                   	push   %ebx
  800669:	ff 75 e0             	pushl  -0x20(%ebp)
  80066c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80066e:	83 ef 01             	sub    $0x1,%edi
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	85 ff                	test   %edi,%edi
  800676:	7f ed                	jg     800665 <vprintfmt+0x1b6>
  800678:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	b8 00 00 00 00       	mov    $0x0,%eax
  800682:	0f 49 c1             	cmovns %ecx,%eax
  800685:	29 c1                	sub    %eax,%ecx
  800687:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80068a:	eb aa                	jmp    800636 <vprintfmt+0x187>
					putch(ch, putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	52                   	push   %edx
  800691:	ff d6                	call   *%esi
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800699:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069b:	83 c7 01             	add    $0x1,%edi
  80069e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a2:	0f be d0             	movsbl %al,%edx
  8006a5:	85 d2                	test   %edx,%edx
  8006a7:	74 4b                	je     8006f4 <vprintfmt+0x245>
  8006a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006ad:	78 06                	js     8006b5 <vprintfmt+0x206>
  8006af:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006b3:	78 1e                	js     8006d3 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b5:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006b9:	74 d1                	je     80068c <vprintfmt+0x1dd>
  8006bb:	0f be c0             	movsbl %al,%eax
  8006be:	83 e8 20             	sub    $0x20,%eax
  8006c1:	83 f8 5e             	cmp    $0x5e,%eax
  8006c4:	76 c6                	jbe    80068c <vprintfmt+0x1dd>
					putch('?', putdat);
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	53                   	push   %ebx
  8006ca:	6a 3f                	push   $0x3f
  8006cc:	ff d6                	call   *%esi
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	eb c3                	jmp    800696 <vprintfmt+0x1e7>
  8006d3:	89 cf                	mov    %ecx,%edi
  8006d5:	eb 0e                	jmp    8006e5 <vprintfmt+0x236>
				putch(' ', putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	6a 20                	push   $0x20
  8006dd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006df:	83 ef 01             	sub    $0x1,%edi
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	85 ff                	test   %edi,%edi
  8006e7:	7f ee                	jg     8006d7 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ef:	e9 01 02 00 00       	jmp    8008f5 <vprintfmt+0x446>
  8006f4:	89 cf                	mov    %ecx,%edi
  8006f6:	eb ed                	jmp    8006e5 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006fb:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800702:	e9 eb fd ff ff       	jmp    8004f2 <vprintfmt+0x43>
	if (lflag >= 2)
  800707:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070b:	7f 21                	jg     80072e <vprintfmt+0x27f>
	else if (lflag)
  80070d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800711:	74 68                	je     80077b <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071b:	89 c1                	mov    %eax,%ecx
  80071d:	c1 f9 1f             	sar    $0x1f,%ecx
  800720:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
  80072c:	eb 17                	jmp    800745 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 50 04             	mov    0x4(%eax),%edx
  800734:	8b 00                	mov    (%eax),%eax
  800736:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800739:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 08             	lea    0x8(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800745:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800748:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800751:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800755:	78 3f                	js     800796 <vprintfmt+0x2e7>
			base = 10;
  800757:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80075c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800760:	0f 84 71 01 00 00    	je     8008d7 <vprintfmt+0x428>
				putch('+', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	53                   	push   %ebx
  80076a:	6a 2b                	push   $0x2b
  80076c:	ff d6                	call   *%esi
  80076e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800771:	b8 0a 00 00 00       	mov    $0xa,%eax
  800776:	e9 5c 01 00 00       	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800783:	89 c1                	mov    %eax,%ecx
  800785:	c1 f9 1f             	sar    $0x1f,%ecx
  800788:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
  800794:	eb af                	jmp    800745 <vprintfmt+0x296>
				putch('-', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	53                   	push   %ebx
  80079a:	6a 2d                	push   $0x2d
  80079c:	ff d6                	call   *%esi
				num = -(long long) num;
  80079e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8007a4:	f7 d8                	neg    %eax
  8007a6:	83 d2 00             	adc    $0x0,%edx
  8007a9:	f7 da                	neg    %edx
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b9:	e9 19 01 00 00       	jmp    8008d7 <vprintfmt+0x428>
	if (lflag >= 2)
  8007be:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c2:	7f 29                	jg     8007ed <vprintfmt+0x33e>
	else if (lflag)
  8007c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c8:	74 44                	je     80080e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8d 40 04             	lea    0x4(%eax),%eax
  8007e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	e9 ea 00 00 00       	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 08             	lea    0x8(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800804:	b8 0a 00 00 00       	mov    $0xa,%eax
  800809:	e9 c9 00 00 00       	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
  800818:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800827:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082c:	e9 a6 00 00 00       	jmp    8008d7 <vprintfmt+0x428>
			putch('0', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 30                	push   $0x30
  800837:	ff d6                	call   *%esi
	if (lflag >= 2)
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800840:	7f 26                	jg     800868 <vprintfmt+0x3b9>
	else if (lflag)
  800842:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800846:	74 3e                	je     800886 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	ba 00 00 00 00       	mov    $0x0,%edx
  800852:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800855:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8d 40 04             	lea    0x4(%eax),%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800861:	b8 08 00 00 00       	mov    $0x8,%eax
  800866:	eb 6f                	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8b 50 04             	mov    0x4(%eax),%edx
  80086e:	8b 00                	mov    (%eax),%eax
  800870:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800873:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 40 08             	lea    0x8(%eax),%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80087f:	b8 08 00 00 00       	mov    $0x8,%eax
  800884:	eb 51                	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	ba 00 00 00 00       	mov    $0x0,%edx
  800890:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800893:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800896:	8b 45 14             	mov    0x14(%ebp),%eax
  800899:	8d 40 04             	lea    0x4(%eax),%eax
  80089c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80089f:	b8 08 00 00 00       	mov    $0x8,%eax
  8008a4:	eb 31                	jmp    8008d7 <vprintfmt+0x428>
			putch('0', putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	53                   	push   %ebx
  8008aa:	6a 30                	push   $0x30
  8008ac:	ff d6                	call   *%esi
			putch('x', putdat);
  8008ae:	83 c4 08             	add    $0x8,%esp
  8008b1:	53                   	push   %ebx
  8008b2:	6a 78                	push   $0x78
  8008b4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008c6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008d7:	83 ec 0c             	sub    $0xc,%esp
  8008da:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008de:	52                   	push   %edx
  8008df:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e6:	ff 75 d8             	pushl  -0x28(%ebp)
  8008e9:	89 da                	mov    %ebx,%edx
  8008eb:	89 f0                	mov    %esi,%eax
  8008ed:	e8 a4 fa ff ff       	call   800396 <printnum>
			break;
  8008f2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008f8:	83 c7 01             	add    $0x1,%edi
  8008fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ff:	83 f8 25             	cmp    $0x25,%eax
  800902:	0f 84 be fb ff ff    	je     8004c6 <vprintfmt+0x17>
			if (ch == '\0')
  800908:	85 c0                	test   %eax,%eax
  80090a:	0f 84 28 01 00 00    	je     800a38 <vprintfmt+0x589>
			putch(ch, putdat);
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	53                   	push   %ebx
  800914:	50                   	push   %eax
  800915:	ff d6                	call   *%esi
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	eb dc                	jmp    8008f8 <vprintfmt+0x449>
	if (lflag >= 2)
  80091c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800920:	7f 26                	jg     800948 <vprintfmt+0x499>
	else if (lflag)
  800922:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800926:	74 41                	je     800969 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	ba 00 00 00 00       	mov    $0x0,%edx
  800932:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800935:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	8d 40 04             	lea    0x4(%eax),%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800941:	b8 10 00 00 00       	mov    $0x10,%eax
  800946:	eb 8f                	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	8b 50 04             	mov    0x4(%eax),%edx
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800953:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800956:	8b 45 14             	mov    0x14(%ebp),%eax
  800959:	8d 40 08             	lea    0x8(%eax),%eax
  80095c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80095f:	b8 10 00 00 00       	mov    $0x10,%eax
  800964:	e9 6e ff ff ff       	jmp    8008d7 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800969:	8b 45 14             	mov    0x14(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800976:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800979:	8b 45 14             	mov    0x14(%ebp),%eax
  80097c:	8d 40 04             	lea    0x4(%eax),%eax
  80097f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800982:	b8 10 00 00 00       	mov    $0x10,%eax
  800987:	e9 4b ff ff ff       	jmp    8008d7 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80098c:	8b 45 14             	mov    0x14(%ebp),%eax
  80098f:	83 c0 04             	add    $0x4,%eax
  800992:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	85 c0                	test   %eax,%eax
  80099c:	74 14                	je     8009b2 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80099e:	8b 13                	mov    (%ebx),%edx
  8009a0:	83 fa 7f             	cmp    $0x7f,%edx
  8009a3:	7f 37                	jg     8009dc <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8009a5:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ad:	e9 43 ff ff ff       	jmp    8008f5 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8009b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b7:	bf 89 2e 80 00       	mov    $0x802e89,%edi
							putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	53                   	push   %ebx
  8009c0:	50                   	push   %eax
  8009c1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009c3:	83 c7 01             	add    $0x1,%edi
  8009c6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	85 c0                	test   %eax,%eax
  8009cf:	75 eb                	jne    8009bc <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d7:	e9 19 ff ff ff       	jmp    8008f5 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009dc:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009e3:	bf c1 2e 80 00       	mov    $0x802ec1,%edi
							putch(ch, putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	53                   	push   %ebx
  8009ec:	50                   	push   %eax
  8009ed:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009ef:	83 c7 01             	add    $0x1,%edi
  8009f2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	85 c0                	test   %eax,%eax
  8009fb:	75 eb                	jne    8009e8 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	e9 ed fe ff ff       	jmp    8008f5 <vprintfmt+0x446>
			putch(ch, putdat);
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	53                   	push   %ebx
  800a0c:	6a 25                	push   $0x25
  800a0e:	ff d6                	call   *%esi
			break;
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	e9 dd fe ff ff       	jmp    8008f5 <vprintfmt+0x446>
			putch('%', putdat);
  800a18:	83 ec 08             	sub    $0x8,%esp
  800a1b:	53                   	push   %ebx
  800a1c:	6a 25                	push   $0x25
  800a1e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	89 f8                	mov    %edi,%eax
  800a25:	eb 03                	jmp    800a2a <vprintfmt+0x57b>
  800a27:	83 e8 01             	sub    $0x1,%eax
  800a2a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a2e:	75 f7                	jne    800a27 <vprintfmt+0x578>
  800a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a33:	e9 bd fe ff ff       	jmp    8008f5 <vprintfmt+0x446>
}
  800a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5f                   	pop    %edi
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	83 ec 18             	sub    $0x18,%esp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a53:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	74 26                	je     800a87 <vsnprintf+0x47>
  800a61:	85 d2                	test   %edx,%edx
  800a63:	7e 22                	jle    800a87 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a65:	ff 75 14             	pushl  0x14(%ebp)
  800a68:	ff 75 10             	pushl  0x10(%ebp)
  800a6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6e:	50                   	push   %eax
  800a6f:	68 75 04 80 00       	push   $0x800475
  800a74:	e8 36 fa ff ff       	call   8004af <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a82:	83 c4 10             	add    $0x10,%esp
}
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    
		return -E_INVAL;
  800a87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a8c:	eb f7                	jmp    800a85 <vsnprintf+0x45>

00800a8e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a94:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a97:	50                   	push   %eax
  800a98:	ff 75 10             	pushl  0x10(%ebp)
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	ff 75 08             	pushl  0x8(%ebp)
  800aa1:	e8 9a ff ff ff       	call   800a40 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ab7:	74 05                	je     800abe <strlen+0x16>
		n++;
  800ab9:	83 c0 01             	add    $0x1,%eax
  800abc:	eb f5                	jmp    800ab3 <strlen+0xb>
	return n;
}
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ace:	39 c2                	cmp    %eax,%edx
  800ad0:	74 0d                	je     800adf <strnlen+0x1f>
  800ad2:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ad6:	74 05                	je     800add <strnlen+0x1d>
		n++;
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	eb f1                	jmp    800ace <strnlen+0xe>
  800add:	89 d0                	mov    %edx,%eax
	return n;
}
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	53                   	push   %ebx
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800af4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af7:	83 c2 01             	add    $0x1,%edx
  800afa:	84 c9                	test   %cl,%cl
  800afc:	75 f2                	jne    800af0 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800afe:	5b                   	pop    %ebx
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	53                   	push   %ebx
  800b05:	83 ec 10             	sub    $0x10,%esp
  800b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b0b:	53                   	push   %ebx
  800b0c:	e8 97 ff ff ff       	call   800aa8 <strlen>
  800b11:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	01 d8                	add    %ebx,%eax
  800b19:	50                   	push   %eax
  800b1a:	e8 c2 ff ff ff       	call   800ae1 <strcpy>
	return dst;
}
  800b1f:	89 d8                	mov    %ebx,%eax
  800b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	56                   	push   %esi
  800b2a:	53                   	push   %ebx
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b31:	89 c6                	mov    %eax,%esi
  800b33:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b36:	89 c2                	mov    %eax,%edx
  800b38:	39 f2                	cmp    %esi,%edx
  800b3a:	74 11                	je     800b4d <strncpy+0x27>
		*dst++ = *src;
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	0f b6 19             	movzbl (%ecx),%ebx
  800b42:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b45:	80 fb 01             	cmp    $0x1,%bl
  800b48:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b4b:	eb eb                	jmp    800b38 <strncpy+0x12>
	}
	return ret;
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    

00800b51 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 75 08             	mov    0x8(%ebp),%esi
  800b59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5c:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b61:	85 d2                	test   %edx,%edx
  800b63:	74 21                	je     800b86 <strlcpy+0x35>
  800b65:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b69:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b6b:	39 c2                	cmp    %eax,%edx
  800b6d:	74 14                	je     800b83 <strlcpy+0x32>
  800b6f:	0f b6 19             	movzbl (%ecx),%ebx
  800b72:	84 db                	test   %bl,%bl
  800b74:	74 0b                	je     800b81 <strlcpy+0x30>
			*dst++ = *src++;
  800b76:	83 c1 01             	add    $0x1,%ecx
  800b79:	83 c2 01             	add    $0x1,%edx
  800b7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b7f:	eb ea                	jmp    800b6b <strlcpy+0x1a>
  800b81:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b86:	29 f0                	sub    %esi,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b95:	0f b6 01             	movzbl (%ecx),%eax
  800b98:	84 c0                	test   %al,%al
  800b9a:	74 0c                	je     800ba8 <strcmp+0x1c>
  800b9c:	3a 02                	cmp    (%edx),%al
  800b9e:	75 08                	jne    800ba8 <strcmp+0x1c>
		p++, q++;
  800ba0:	83 c1 01             	add    $0x1,%ecx
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	eb ed                	jmp    800b95 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba8:	0f b6 c0             	movzbl %al,%eax
  800bab:	0f b6 12             	movzbl (%edx),%edx
  800bae:	29 d0                	sub    %edx,%eax
}
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	53                   	push   %ebx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 c3                	mov    %eax,%ebx
  800bbe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc1:	eb 06                	jmp    800bc9 <strncmp+0x17>
		n--, p++, q++;
  800bc3:	83 c0 01             	add    $0x1,%eax
  800bc6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bc9:	39 d8                	cmp    %ebx,%eax
  800bcb:	74 16                	je     800be3 <strncmp+0x31>
  800bcd:	0f b6 08             	movzbl (%eax),%ecx
  800bd0:	84 c9                	test   %cl,%cl
  800bd2:	74 04                	je     800bd8 <strncmp+0x26>
  800bd4:	3a 0a                	cmp    (%edx),%cl
  800bd6:	74 eb                	je     800bc3 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd8:	0f b6 00             	movzbl (%eax),%eax
  800bdb:	0f b6 12             	movzbl (%edx),%edx
  800bde:	29 d0                	sub    %edx,%eax
}
  800be0:	5b                   	pop    %ebx
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		return 0;
  800be3:	b8 00 00 00 00       	mov    $0x0,%eax
  800be8:	eb f6                	jmp    800be0 <strncmp+0x2e>

00800bea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf4:	0f b6 10             	movzbl (%eax),%edx
  800bf7:	84 d2                	test   %dl,%dl
  800bf9:	74 09                	je     800c04 <strchr+0x1a>
		if (*s == c)
  800bfb:	38 ca                	cmp    %cl,%dl
  800bfd:	74 0a                	je     800c09 <strchr+0x1f>
	for (; *s; s++)
  800bff:	83 c0 01             	add    $0x1,%eax
  800c02:	eb f0                	jmp    800bf4 <strchr+0xa>
			return (char *) s;
	return 0;
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c15:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c18:	38 ca                	cmp    %cl,%dl
  800c1a:	74 09                	je     800c25 <strfind+0x1a>
  800c1c:	84 d2                	test   %dl,%dl
  800c1e:	74 05                	je     800c25 <strfind+0x1a>
	for (; *s; s++)
  800c20:	83 c0 01             	add    $0x1,%eax
  800c23:	eb f0                	jmp    800c15 <strfind+0xa>
			break;
	return (char *) s;
}
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c33:	85 c9                	test   %ecx,%ecx
  800c35:	74 31                	je     800c68 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c37:	89 f8                	mov    %edi,%eax
  800c39:	09 c8                	or     %ecx,%eax
  800c3b:	a8 03                	test   $0x3,%al
  800c3d:	75 23                	jne    800c62 <memset+0x3b>
		c &= 0xFF;
  800c3f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	c1 e3 08             	shl    $0x8,%ebx
  800c48:	89 d0                	mov    %edx,%eax
  800c4a:	c1 e0 18             	shl    $0x18,%eax
  800c4d:	89 d6                	mov    %edx,%esi
  800c4f:	c1 e6 10             	shl    $0x10,%esi
  800c52:	09 f0                	or     %esi,%eax
  800c54:	09 c2                	or     %eax,%edx
  800c56:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c58:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	fc                   	cld    
  800c5e:	f3 ab                	rep stos %eax,%es:(%edi)
  800c60:	eb 06                	jmp    800c68 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c65:	fc                   	cld    
  800c66:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c68:	89 f8                	mov    %edi,%eax
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	57                   	push   %edi
  800c73:	56                   	push   %esi
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7d:	39 c6                	cmp    %eax,%esi
  800c7f:	73 32                	jae    800cb3 <memmove+0x44>
  800c81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c84:	39 c2                	cmp    %eax,%edx
  800c86:	76 2b                	jbe    800cb3 <memmove+0x44>
		s += n;
		d += n;
  800c88:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8b:	89 fe                	mov    %edi,%esi
  800c8d:	09 ce                	or     %ecx,%esi
  800c8f:	09 d6                	or     %edx,%esi
  800c91:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c97:	75 0e                	jne    800ca7 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c99:	83 ef 04             	sub    $0x4,%edi
  800c9c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ca2:	fd                   	std    
  800ca3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca5:	eb 09                	jmp    800cb0 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ca7:	83 ef 01             	sub    $0x1,%edi
  800caa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cad:	fd                   	std    
  800cae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cb0:	fc                   	cld    
  800cb1:	eb 1a                	jmp    800ccd <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb3:	89 c2                	mov    %eax,%edx
  800cb5:	09 ca                	or     %ecx,%edx
  800cb7:	09 f2                	or     %esi,%edx
  800cb9:	f6 c2 03             	test   $0x3,%dl
  800cbc:	75 0a                	jne    800cc8 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cbe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cc1:	89 c7                	mov    %eax,%edi
  800cc3:	fc                   	cld    
  800cc4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc6:	eb 05                	jmp    800ccd <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cc8:	89 c7                	mov    %eax,%edi
  800cca:	fc                   	cld    
  800ccb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    

00800cd1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd7:	ff 75 10             	pushl  0x10(%ebp)
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	ff 75 08             	pushl  0x8(%ebp)
  800ce0:	e8 8a ff ff ff       	call   800c6f <memmove>
}
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf2:	89 c6                	mov    %eax,%esi
  800cf4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf7:	39 f0                	cmp    %esi,%eax
  800cf9:	74 1c                	je     800d17 <memcmp+0x30>
		if (*s1 != *s2)
  800cfb:	0f b6 08             	movzbl (%eax),%ecx
  800cfe:	0f b6 1a             	movzbl (%edx),%ebx
  800d01:	38 d9                	cmp    %bl,%cl
  800d03:	75 08                	jne    800d0d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d05:	83 c0 01             	add    $0x1,%eax
  800d08:	83 c2 01             	add    $0x1,%edx
  800d0b:	eb ea                	jmp    800cf7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d0d:	0f b6 c1             	movzbl %cl,%eax
  800d10:	0f b6 db             	movzbl %bl,%ebx
  800d13:	29 d8                	sub    %ebx,%eax
  800d15:	eb 05                	jmp    800d1c <memcmp+0x35>
	}

	return 0;
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d29:	89 c2                	mov    %eax,%edx
  800d2b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d2e:	39 d0                	cmp    %edx,%eax
  800d30:	73 09                	jae    800d3b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d32:	38 08                	cmp    %cl,(%eax)
  800d34:	74 05                	je     800d3b <memfind+0x1b>
	for (; s < ends; s++)
  800d36:	83 c0 01             	add    $0x1,%eax
  800d39:	eb f3                	jmp    800d2e <memfind+0xe>
			break;
	return (void *) s;
}
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d49:	eb 03                	jmp    800d4e <strtol+0x11>
		s++;
  800d4b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d4e:	0f b6 01             	movzbl (%ecx),%eax
  800d51:	3c 20                	cmp    $0x20,%al
  800d53:	74 f6                	je     800d4b <strtol+0xe>
  800d55:	3c 09                	cmp    $0x9,%al
  800d57:	74 f2                	je     800d4b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d59:	3c 2b                	cmp    $0x2b,%al
  800d5b:	74 2a                	je     800d87 <strtol+0x4a>
	int neg = 0;
  800d5d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d62:	3c 2d                	cmp    $0x2d,%al
  800d64:	74 2b                	je     800d91 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d66:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d6c:	75 0f                	jne    800d7d <strtol+0x40>
  800d6e:	80 39 30             	cmpb   $0x30,(%ecx)
  800d71:	74 28                	je     800d9b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d73:	85 db                	test   %ebx,%ebx
  800d75:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d7a:	0f 44 d8             	cmove  %eax,%ebx
  800d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d82:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d85:	eb 50                	jmp    800dd7 <strtol+0x9a>
		s++;
  800d87:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800d8f:	eb d5                	jmp    800d66 <strtol+0x29>
		s++, neg = 1;
  800d91:	83 c1 01             	add    $0x1,%ecx
  800d94:	bf 01 00 00 00       	mov    $0x1,%edi
  800d99:	eb cb                	jmp    800d66 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d9b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d9f:	74 0e                	je     800daf <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800da1:	85 db                	test   %ebx,%ebx
  800da3:	75 d8                	jne    800d7d <strtol+0x40>
		s++, base = 8;
  800da5:	83 c1 01             	add    $0x1,%ecx
  800da8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dad:	eb ce                	jmp    800d7d <strtol+0x40>
		s += 2, base = 16;
  800daf:	83 c1 02             	add    $0x2,%ecx
  800db2:	bb 10 00 00 00       	mov    $0x10,%ebx
  800db7:	eb c4                	jmp    800d7d <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800db9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dbc:	89 f3                	mov    %esi,%ebx
  800dbe:	80 fb 19             	cmp    $0x19,%bl
  800dc1:	77 29                	ja     800dec <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dc3:	0f be d2             	movsbl %dl,%edx
  800dc6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800dc9:	3b 55 10             	cmp    0x10(%ebp),%edx
  800dcc:	7d 30                	jge    800dfe <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800dce:	83 c1 01             	add    $0x1,%ecx
  800dd1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd5:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dd7:	0f b6 11             	movzbl (%ecx),%edx
  800dda:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ddd:	89 f3                	mov    %esi,%ebx
  800ddf:	80 fb 09             	cmp    $0x9,%bl
  800de2:	77 d5                	ja     800db9 <strtol+0x7c>
			dig = *s - '0';
  800de4:	0f be d2             	movsbl %dl,%edx
  800de7:	83 ea 30             	sub    $0x30,%edx
  800dea:	eb dd                	jmp    800dc9 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dec:	8d 72 bf             	lea    -0x41(%edx),%esi
  800def:	89 f3                	mov    %esi,%ebx
  800df1:	80 fb 19             	cmp    $0x19,%bl
  800df4:	77 08                	ja     800dfe <strtol+0xc1>
			dig = *s - 'A' + 10;
  800df6:	0f be d2             	movsbl %dl,%edx
  800df9:	83 ea 37             	sub    $0x37,%edx
  800dfc:	eb cb                	jmp    800dc9 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800dfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e02:	74 05                	je     800e09 <strtol+0xcc>
		*endptr = (char *) s;
  800e04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e07:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e09:	89 c2                	mov    %eax,%edx
  800e0b:	f7 da                	neg    %edx
  800e0d:	85 ff                	test   %edi,%edi
  800e0f:	0f 45 c2             	cmovne %edx,%eax
}
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	89 c3                	mov    %eax,%ebx
  800e2a:	89 c7                	mov    %eax,%edi
  800e2c:	89 c6                	mov    %eax,%esi
  800e2e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e40:	b8 01 00 00 00       	mov    $0x1,%eax
  800e45:	89 d1                	mov    %edx,%ecx
  800e47:	89 d3                	mov    %edx,%ebx
  800e49:	89 d7                	mov    %edx,%edi
  800e4b:	89 d6                	mov    %edx,%esi
  800e4d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	b8 03 00 00 00       	mov    $0x3,%eax
  800e6a:	89 cb                	mov    %ecx,%ebx
  800e6c:	89 cf                	mov    %ecx,%edi
  800e6e:	89 ce                	mov    %ecx,%esi
  800e70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7f 08                	jg     800e7e <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e79:	5b                   	pop    %ebx
  800e7a:	5e                   	pop    %esi
  800e7b:	5f                   	pop    %edi
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	50                   	push   %eax
  800e82:	6a 03                	push   $0x3
  800e84:	68 e4 30 80 00       	push   $0x8030e4
  800e89:	6a 43                	push   $0x43
  800e8b:	68 01 31 80 00       	push   $0x803101
  800e90:	e8 f7 f3 ff ff       	call   80028c <_panic>

00800e95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ea5:	89 d1                	mov    %edx,%ecx
  800ea7:	89 d3                	mov    %edx,%ebx
  800ea9:	89 d7                	mov    %edx,%edi
  800eab:	89 d6                	mov    %edx,%esi
  800ead:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_yield>:

void
sys_yield(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ec4:	89 d1                	mov    %edx,%ecx
  800ec6:	89 d3                	mov    %edx,%ebx
  800ec8:	89 d7                	mov    %edx,%edi
  800eca:	89 d6                	mov    %edx,%esi
  800ecc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edc:	be 00 00 00 00       	mov    $0x0,%esi
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee7:	b8 04 00 00 00       	mov    $0x4,%eax
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	89 f7                	mov    %esi,%edi
  800ef1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7f 08                	jg     800eff <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	50                   	push   %eax
  800f03:	6a 04                	push   $0x4
  800f05:	68 e4 30 80 00       	push   $0x8030e4
  800f0a:	6a 43                	push   $0x43
  800f0c:	68 01 31 80 00       	push   $0x803101
  800f11:	e8 76 f3 ff ff       	call   80028c <_panic>

00800f16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
  800f1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 05 00 00 00       	mov    $0x5,%eax
  800f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f30:	8b 75 18             	mov    0x18(%ebp),%esi
  800f33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7f 08                	jg     800f41 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 05                	push   $0x5
  800f47:	68 e4 30 80 00       	push   $0x8030e4
  800f4c:	6a 43                	push   $0x43
  800f4e:	68 01 31 80 00       	push   $0x803101
  800f53:	e8 34 f3 ff ff       	call   80028c <_panic>

00800f58 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	b8 06 00 00 00       	mov    $0x6,%eax
  800f71:	89 df                	mov    %ebx,%edi
  800f73:	89 de                	mov    %ebx,%esi
  800f75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7f 08                	jg     800f83 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 06                	push   $0x6
  800f89:	68 e4 30 80 00       	push   $0x8030e4
  800f8e:	6a 43                	push   $0x43
  800f90:	68 01 31 80 00       	push   $0x803101
  800f95:	e8 f2 f2 ff ff       	call   80028c <_panic>

00800f9a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
  800fa0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7f 08                	jg     800fc5 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5f                   	pop    %edi
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	83 ec 0c             	sub    $0xc,%esp
  800fc8:	50                   	push   %eax
  800fc9:	6a 08                	push   $0x8
  800fcb:	68 e4 30 80 00       	push   $0x8030e4
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 01 31 80 00       	push   $0x803101
  800fd7:	e8 b0 f2 ff ff       	call   80028c <_panic>

00800fdc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff5:	89 df                	mov    %ebx,%edi
  800ff7:	89 de                	mov    %ebx,%esi
  800ff9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	7f 08                	jg     801007 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	83 ec 0c             	sub    $0xc,%esp
  80100a:	50                   	push   %eax
  80100b:	6a 09                	push   $0x9
  80100d:	68 e4 30 80 00       	push   $0x8030e4
  801012:	6a 43                	push   $0x43
  801014:	68 01 31 80 00       	push   $0x803101
  801019:	e8 6e f2 ff ff       	call   80028c <_panic>

0080101e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
  801024:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801027:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 0a 00 00 00       	mov    $0xa,%eax
  801037:	89 df                	mov    %ebx,%edi
  801039:	89 de                	mov    %ebx,%esi
  80103b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80103d:	85 c0                	test   %eax,%eax
  80103f:	7f 08                	jg     801049 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  80104d:	6a 0a                	push   $0xa
  80104f:	68 e4 30 80 00       	push   $0x8030e4
  801054:	6a 43                	push   $0x43
  801056:	68 01 31 80 00       	push   $0x803101
  80105b:	e8 2c f2 ff ff       	call   80028c <_panic>

00801060 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
	asm volatile("int %1\n"
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801071:	be 00 00 00 00       	mov    $0x0,%esi
  801076:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801079:	8b 7d 14             	mov    0x14(%ebp),%edi
  80107c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801091:	8b 55 08             	mov    0x8(%ebp),%edx
  801094:	b8 0d 00 00 00       	mov    $0xd,%eax
  801099:	89 cb                	mov    %ecx,%ebx
  80109b:	89 cf                	mov    %ecx,%edi
  80109d:	89 ce                	mov    %ecx,%esi
  80109f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7f 08                	jg     8010ad <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	50                   	push   %eax
  8010b1:	6a 0d                	push   $0xd
  8010b3:	68 e4 30 80 00       	push   $0x8030e4
  8010b8:	6a 43                	push   $0x43
  8010ba:	68 01 31 80 00       	push   $0x803101
  8010bf:	e8 c8 f1 ff ff       	call   80028c <_panic>

008010c4 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010da:	89 df                	mov    %ebx,%edi
  8010dc:	89 de                	mov    %ebx,%esi
  8010de:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010e0:	5b                   	pop    %ebx
  8010e1:	5e                   	pop    %esi
  8010e2:	5f                   	pop    %edi
  8010e3:	5d                   	pop    %ebp
  8010e4:	c3                   	ret    

008010e5 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	57                   	push   %edi
  8010e9:	56                   	push   %esi
  8010ea:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010f8:	89 cb                	mov    %ecx,%ebx
  8010fa:	89 cf                	mov    %ecx,%edi
  8010fc:	89 ce                	mov    %ecx,%esi
  8010fe:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    

00801105 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110b:	ba 00 00 00 00       	mov    $0x0,%edx
  801110:	b8 10 00 00 00       	mov    $0x10,%eax
  801115:	89 d1                	mov    %edx,%ecx
  801117:	89 d3                	mov    %edx,%ebx
  801119:	89 d7                	mov    %edx,%edi
  80111b:	89 d6                	mov    %edx,%esi
  80111d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80111f:	5b                   	pop    %ebx
  801120:	5e                   	pop    %esi
  801121:	5f                   	pop    %edi
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801135:	b8 11 00 00 00       	mov    $0x11,%eax
  80113a:	89 df                	mov    %ebx,%edi
  80113c:	89 de                	mov    %ebx,%esi
  80113e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5f                   	pop    %edi
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80114b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801156:	b8 12 00 00 00       	mov    $0x12,%eax
  80115b:	89 df                	mov    %ebx,%edi
  80115d:	89 de                	mov    %ebx,%esi
  80115f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	b8 13 00 00 00       	mov    $0x13,%eax
  80117f:	89 df                	mov    %ebx,%edi
  801181:	89 de                	mov    %ebx,%esi
  801183:	cd 30                	int    $0x30
	if(check && ret > 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	7f 08                	jg     801191 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	50                   	push   %eax
  801195:	6a 13                	push   $0x13
  801197:	68 e4 30 80 00       	push   $0x8030e4
  80119c:	6a 43                	push   $0x43
  80119e:	68 01 31 80 00       	push   $0x803101
  8011a3:	e8 e4 f0 ff ff       	call   80028c <_panic>

008011a8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8011af:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011b6:	f6 c5 04             	test   $0x4,%ch
  8011b9:	75 45                	jne    801200 <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8011bb:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011c2:	83 e1 07             	and    $0x7,%ecx
  8011c5:	83 f9 07             	cmp    $0x7,%ecx
  8011c8:	74 6f                	je     801239 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8011ca:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011d1:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8011d7:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8011dd:	0f 84 b6 00 00 00    	je     801299 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8011e3:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8011ea:	83 e1 05             	and    $0x5,%ecx
  8011ed:	83 f9 05             	cmp    $0x5,%ecx
  8011f0:	0f 84 d7 00 00 00    	je     8012cd <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801200:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801207:	c1 e2 0c             	shl    $0xc,%edx
  80120a:	83 ec 0c             	sub    $0xc,%esp
  80120d:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  801213:	51                   	push   %ecx
  801214:	52                   	push   %edx
  801215:	50                   	push   %eax
  801216:	52                   	push   %edx
  801217:	6a 00                	push   $0x0
  801219:	e8 f8 fc ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  80121e:	83 c4 20             	add    $0x20,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	79 d1                	jns    8011f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	68 0f 31 80 00       	push   $0x80310f
  80122d:	6a 54                	push   $0x54
  80122f:	68 25 31 80 00       	push   $0x803125
  801234:	e8 53 f0 ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801239:	89 d3                	mov    %edx,%ebx
  80123b:	c1 e3 0c             	shl    $0xc,%ebx
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	68 05 08 00 00       	push   $0x805
  801246:	53                   	push   %ebx
  801247:	50                   	push   %eax
  801248:	53                   	push   %ebx
  801249:	6a 00                	push   $0x0
  80124b:	e8 c6 fc ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	78 2e                	js     801285 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	68 05 08 00 00       	push   $0x805
  80125f:	53                   	push   %ebx
  801260:	6a 00                	push   $0x0
  801262:	53                   	push   %ebx
  801263:	6a 00                	push   $0x0
  801265:	e8 ac fc ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  80126a:	83 c4 20             	add    $0x20,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	79 85                	jns    8011f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	68 0f 31 80 00       	push   $0x80310f
  801279:	6a 5f                	push   $0x5f
  80127b:	68 25 31 80 00       	push   $0x803125
  801280:	e8 07 f0 ff ff       	call   80028c <_panic>
			panic("sys_page_map() panic\n");
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	68 0f 31 80 00       	push   $0x80310f
  80128d:	6a 5b                	push   $0x5b
  80128f:	68 25 31 80 00       	push   $0x803125
  801294:	e8 f3 ef ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801299:	c1 e2 0c             	shl    $0xc,%edx
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	68 05 08 00 00       	push   $0x805
  8012a4:	52                   	push   %edx
  8012a5:	50                   	push   %eax
  8012a6:	52                   	push   %edx
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 68 fc ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  8012ae:	83 c4 20             	add    $0x20,%esp
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	0f 89 3d ff ff ff    	jns    8011f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012b9:	83 ec 04             	sub    $0x4,%esp
  8012bc:	68 0f 31 80 00       	push   $0x80310f
  8012c1:	6a 66                	push   $0x66
  8012c3:	68 25 31 80 00       	push   $0x803125
  8012c8:	e8 bf ef ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8012cd:	c1 e2 0c             	shl    $0xc,%edx
  8012d0:	83 ec 0c             	sub    $0xc,%esp
  8012d3:	6a 05                	push   $0x5
  8012d5:	52                   	push   %edx
  8012d6:	50                   	push   %eax
  8012d7:	52                   	push   %edx
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 37 fc ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  8012df:	83 c4 20             	add    $0x20,%esp
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	0f 89 0c ff ff ff    	jns    8011f6 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	68 0f 31 80 00       	push   $0x80310f
  8012f2:	6a 6d                	push   $0x6d
  8012f4:	68 25 31 80 00       	push   $0x803125
  8012f9:	e8 8e ef ff ff       	call   80028c <_panic>

008012fe <pgfault>:
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	53                   	push   %ebx
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801308:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80130a:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80130e:	0f 84 99 00 00 00    	je     8013ad <pgfault+0xaf>
  801314:	89 c2                	mov    %eax,%edx
  801316:	c1 ea 16             	shr    $0x16,%edx
  801319:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801320:	f6 c2 01             	test   $0x1,%dl
  801323:	0f 84 84 00 00 00    	je     8013ad <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801329:	89 c2                	mov    %eax,%edx
  80132b:	c1 ea 0c             	shr    $0xc,%edx
  80132e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801335:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80133b:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801341:	75 6a                	jne    8013ad <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801343:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801348:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	6a 07                	push   $0x7
  80134f:	68 00 f0 7f 00       	push   $0x7ff000
  801354:	6a 00                	push   $0x0
  801356:	e8 78 fb ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 5f                	js     8013c1 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	68 00 10 00 00       	push   $0x1000
  80136a:	53                   	push   %ebx
  80136b:	68 00 f0 7f 00       	push   $0x7ff000
  801370:	e8 5c f9 ff ff       	call   800cd1 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801375:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80137c:	53                   	push   %ebx
  80137d:	6a 00                	push   $0x0
  80137f:	68 00 f0 7f 00       	push   $0x7ff000
  801384:	6a 00                	push   $0x0
  801386:	e8 8b fb ff ff       	call   800f16 <sys_page_map>
	if(ret < 0)
  80138b:	83 c4 20             	add    $0x20,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 43                	js     8013d5 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 00 f0 7f 00       	push   $0x7ff000
  80139a:	6a 00                	push   $0x0
  80139c:	e8 b7 fb ff ff       	call   800f58 <sys_page_unmap>
	if(ret < 0)
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 41                	js     8013e9 <pgfault+0xeb>
}
  8013a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    
		panic("panic at pgfault()\n");
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 30 31 80 00       	push   $0x803130
  8013b5:	6a 26                	push   $0x26
  8013b7:	68 25 31 80 00       	push   $0x803125
  8013bc:	e8 cb ee ff ff       	call   80028c <_panic>
		panic("panic in sys_page_alloc()\n");
  8013c1:	83 ec 04             	sub    $0x4,%esp
  8013c4:	68 44 31 80 00       	push   $0x803144
  8013c9:	6a 31                	push   $0x31
  8013cb:	68 25 31 80 00       	push   $0x803125
  8013d0:	e8 b7 ee ff ff       	call   80028c <_panic>
		panic("panic in sys_page_map()\n");
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 5f 31 80 00       	push   $0x80315f
  8013dd:	6a 36                	push   $0x36
  8013df:	68 25 31 80 00       	push   $0x803125
  8013e4:	e8 a3 ee ff ff       	call   80028c <_panic>
		panic("panic in sys_page_unmap()\n");
  8013e9:	83 ec 04             	sub    $0x4,%esp
  8013ec:	68 78 31 80 00       	push   $0x803178
  8013f1:	6a 39                	push   $0x39
  8013f3:	68 25 31 80 00       	push   $0x803125
  8013f8:	e8 8f ee ff ff       	call   80028c <_panic>

008013fd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	57                   	push   %edi
  801401:	56                   	push   %esi
  801402:	53                   	push   %ebx
  801403:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  801406:	68 fe 12 80 00       	push   $0x8012fe
  80140b:	e8 d5 13 00 00       	call   8027e5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801410:	b8 07 00 00 00       	mov    $0x7,%eax
  801415:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	78 27                	js     801445 <fork+0x48>
  80141e:	89 c6                	mov    %eax,%esi
  801420:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801422:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801427:	75 48                	jne    801471 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801429:	e8 67 fa ff ff       	call   800e95 <sys_getenvid>
  80142e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801433:	c1 e0 07             	shl    $0x7,%eax
  801436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80143b:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801440:	e9 90 00 00 00       	jmp    8014d5 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801445:	83 ec 04             	sub    $0x4,%esp
  801448:	68 94 31 80 00       	push   $0x803194
  80144d:	68 8c 00 00 00       	push   $0x8c
  801452:	68 25 31 80 00       	push   $0x803125
  801457:	e8 30 ee ff ff       	call   80028c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80145c:	89 f8                	mov    %edi,%eax
  80145e:	e8 45 fd ff ff       	call   8011a8 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801463:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801469:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80146f:	74 26                	je     801497 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801471:	89 d8                	mov    %ebx,%eax
  801473:	c1 e8 16             	shr    $0x16,%eax
  801476:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80147d:	a8 01                	test   $0x1,%al
  80147f:	74 e2                	je     801463 <fork+0x66>
  801481:	89 da                	mov    %ebx,%edx
  801483:	c1 ea 0c             	shr    $0xc,%edx
  801486:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80148d:	83 e0 05             	and    $0x5,%eax
  801490:	83 f8 05             	cmp    $0x5,%eax
  801493:	75 ce                	jne    801463 <fork+0x66>
  801495:	eb c5                	jmp    80145c <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	6a 07                	push   $0x7
  80149c:	68 00 f0 bf ee       	push   $0xeebff000
  8014a1:	56                   	push   %esi
  8014a2:	e8 2c fa ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 31                	js     8014df <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	68 54 28 80 00       	push   $0x802854
  8014b6:	56                   	push   %esi
  8014b7:	e8 62 fb ff ff       	call   80101e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 33                	js     8014f6 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	6a 02                	push   $0x2
  8014c8:	56                   	push   %esi
  8014c9:	e8 cc fa ff ff       	call   800f9a <sys_env_set_status>
	if(ret < 0)
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 38                	js     80150d <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014d5:	89 f0                	mov    %esi,%eax
  8014d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5f                   	pop    %edi
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 44 31 80 00       	push   $0x803144
  8014e7:	68 98 00 00 00       	push   $0x98
  8014ec:	68 25 31 80 00       	push   $0x803125
  8014f1:	e8 96 ed ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 b8 31 80 00       	push   $0x8031b8
  8014fe:	68 9b 00 00 00       	push   $0x9b
  801503:	68 25 31 80 00       	push   $0x803125
  801508:	e8 7f ed ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_status()\n");
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	68 e0 31 80 00       	push   $0x8031e0
  801515:	68 9e 00 00 00       	push   $0x9e
  80151a:	68 25 31 80 00       	push   $0x803125
  80151f:	e8 68 ed ff ff       	call   80028c <_panic>

00801524 <sfork>:

// Challenge!
int
sfork(void)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	57                   	push   %edi
  801528:	56                   	push   %esi
  801529:	53                   	push   %ebx
  80152a:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80152d:	68 fe 12 80 00       	push   $0x8012fe
  801532:	e8 ae 12 00 00       	call   8027e5 <set_pgfault_handler>
  801537:	b8 07 00 00 00       	mov    $0x7,%eax
  80153c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	85 c0                	test   %eax,%eax
  801543:	78 27                	js     80156c <sfork+0x48>
  801545:	89 c7                	mov    %eax,%edi
  801547:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801549:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80154e:	75 55                	jne    8015a5 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801550:	e8 40 f9 ff ff       	call   800e95 <sys_getenvid>
  801555:	25 ff 03 00 00       	and    $0x3ff,%eax
  80155a:	c1 e0 07             	shl    $0x7,%eax
  80155d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801562:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801567:	e9 d4 00 00 00       	jmp    801640 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 94 31 80 00       	push   $0x803194
  801574:	68 af 00 00 00       	push   $0xaf
  801579:	68 25 31 80 00       	push   $0x803125
  80157e:	e8 09 ed ff ff       	call   80028c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801583:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801588:	89 f0                	mov    %esi,%eax
  80158a:	e8 19 fc ff ff       	call   8011a8 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80158f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801595:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80159b:	77 65                	ja     801602 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  80159d:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015a3:	74 de                	je     801583 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	c1 e8 16             	shr    $0x16,%eax
  8015aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015b1:	a8 01                	test   $0x1,%al
  8015b3:	74 da                	je     80158f <sfork+0x6b>
  8015b5:	89 da                	mov    %ebx,%edx
  8015b7:	c1 ea 0c             	shr    $0xc,%edx
  8015ba:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015c1:	83 e0 05             	and    $0x5,%eax
  8015c4:	83 f8 05             	cmp    $0x5,%eax
  8015c7:	75 c6                	jne    80158f <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015d0:	c1 e2 0c             	shl    $0xc,%edx
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	83 e0 07             	and    $0x7,%eax
  8015d9:	50                   	push   %eax
  8015da:	52                   	push   %edx
  8015db:	56                   	push   %esi
  8015dc:	52                   	push   %edx
  8015dd:	6a 00                	push   $0x0
  8015df:	e8 32 f9 ff ff       	call   800f16 <sys_page_map>
  8015e4:	83 c4 20             	add    $0x20,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 a4                	je     80158f <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 0f 31 80 00       	push   $0x80310f
  8015f3:	68 ba 00 00 00       	push   $0xba
  8015f8:	68 25 31 80 00       	push   $0x803125
  8015fd:	e8 8a ec ff ff       	call   80028c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	6a 07                	push   $0x7
  801607:	68 00 f0 bf ee       	push   $0xeebff000
  80160c:	57                   	push   %edi
  80160d:	e8 c1 f8 ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	85 c0                	test   %eax,%eax
  801617:	78 31                	js     80164a <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801619:	83 ec 08             	sub    $0x8,%esp
  80161c:	68 54 28 80 00       	push   $0x802854
  801621:	57                   	push   %edi
  801622:	e8 f7 f9 ff ff       	call   80101e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 33                	js     801661 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	6a 02                	push   $0x2
  801633:	57                   	push   %edi
  801634:	e8 61 f9 ff ff       	call   800f9a <sys_env_set_status>
	if(ret < 0)
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 38                	js     801678 <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801640:	89 f8                	mov    %edi,%eax
  801642:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	68 44 31 80 00       	push   $0x803144
  801652:	68 c0 00 00 00       	push   $0xc0
  801657:	68 25 31 80 00       	push   $0x803125
  80165c:	e8 2b ec ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	68 b8 31 80 00       	push   $0x8031b8
  801669:	68 c3 00 00 00       	push   $0xc3
  80166e:	68 25 31 80 00       	push   $0x803125
  801673:	e8 14 ec ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_status()\n");
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	68 e0 31 80 00       	push   $0x8031e0
  801680:	68 c6 00 00 00       	push   $0xc6
  801685:	68 25 31 80 00       	push   $0x803125
  80168a:	e8 fd eb ff ff       	call   80028c <_panic>

0080168f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	05 00 00 00 30       	add    $0x30000000,%eax
  80169a:	c1 e8 0c             	shr    $0xc,%eax
}
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016af:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016be:	89 c2                	mov    %eax,%edx
  8016c0:	c1 ea 16             	shr    $0x16,%edx
  8016c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ca:	f6 c2 01             	test   $0x1,%dl
  8016cd:	74 2d                	je     8016fc <fd_alloc+0x46>
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	c1 ea 0c             	shr    $0xc,%edx
  8016d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016db:	f6 c2 01             	test   $0x1,%dl
  8016de:	74 1c                	je     8016fc <fd_alloc+0x46>
  8016e0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016e5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016ea:	75 d2                	jne    8016be <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016f5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016fa:	eb 0a                	jmp    801706 <fd_alloc+0x50>
			*fd_store = fd;
  8016fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ff:	89 01                	mov    %eax,(%ecx)
			return 0;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    

00801708 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80170e:	83 f8 1f             	cmp    $0x1f,%eax
  801711:	77 30                	ja     801743 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801713:	c1 e0 0c             	shl    $0xc,%eax
  801716:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80171b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801721:	f6 c2 01             	test   $0x1,%dl
  801724:	74 24                	je     80174a <fd_lookup+0x42>
  801726:	89 c2                	mov    %eax,%edx
  801728:	c1 ea 0c             	shr    $0xc,%edx
  80172b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801732:	f6 c2 01             	test   $0x1,%dl
  801735:	74 1a                	je     801751 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	89 02                	mov    %eax,(%edx)
	return 0;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		return -E_INVAL;
  801743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801748:	eb f7                	jmp    801741 <fd_lookup+0x39>
		return -E_INVAL;
  80174a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174f:	eb f0                	jmp    801741 <fd_lookup+0x39>
  801751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801756:	eb e9                	jmp    801741 <fd_lookup+0x39>

00801758 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80176b:	39 08                	cmp    %ecx,(%eax)
  80176d:	74 38                	je     8017a7 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80176f:	83 c2 01             	add    $0x1,%edx
  801772:	8b 04 95 7c 32 80 00 	mov    0x80327c(,%edx,4),%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	75 ee                	jne    80176b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80177d:	a1 08 50 80 00       	mov    0x805008,%eax
  801782:	8b 40 48             	mov    0x48(%eax),%eax
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	51                   	push   %ecx
  801789:	50                   	push   %eax
  80178a:	68 00 32 80 00       	push   $0x803200
  80178f:	e8 ee eb ff ff       	call   800382 <cprintf>
	*dev = 0;
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    
			*dev = devtab[i];
  8017a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017aa:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	eb f2                	jmp    8017a5 <dev_lookup+0x4d>

008017b3 <fd_close>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	57                   	push   %edi
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 24             	sub    $0x24,%esp
  8017bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8017bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017c6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017cc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017cf:	50                   	push   %eax
  8017d0:	e8 33 ff ff ff       	call   801708 <fd_lookup>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 05                	js     8017e3 <fd_close+0x30>
	    || fd != fd2)
  8017de:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017e1:	74 16                	je     8017f9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8017e3:	89 f8                	mov    %edi,%eax
  8017e5:	84 c0                	test   %al,%al
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ec:	0f 44 d8             	cmove  %eax,%ebx
}
  8017ef:	89 d8                	mov    %ebx,%eax
  8017f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017f4:	5b                   	pop    %ebx
  8017f5:	5e                   	pop    %esi
  8017f6:	5f                   	pop    %edi
  8017f7:	5d                   	pop    %ebp
  8017f8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017ff:	50                   	push   %eax
  801800:	ff 36                	pushl  (%esi)
  801802:	e8 51 ff ff ff       	call   801758 <dev_lookup>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 1a                	js     80182a <fd_close+0x77>
		if (dev->dev_close)
  801810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801813:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801816:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80181b:	85 c0                	test   %eax,%eax
  80181d:	74 0b                	je     80182a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	56                   	push   %esi
  801823:	ff d0                	call   *%eax
  801825:	89 c3                	mov    %eax,%ebx
  801827:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	56                   	push   %esi
  80182e:	6a 00                	push   $0x0
  801830:	e8 23 f7 ff ff       	call   800f58 <sys_page_unmap>
	return r;
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	eb b5                	jmp    8017ef <fd_close+0x3c>

0080183a <close>:

int
close(int fdnum)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801840:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801843:	50                   	push   %eax
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	e8 bc fe ff ff       	call   801708 <fd_lookup>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	79 02                	jns    801855 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    
		return fd_close(fd, 1);
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	6a 01                	push   $0x1
  80185a:	ff 75 f4             	pushl  -0xc(%ebp)
  80185d:	e8 51 ff ff ff       	call   8017b3 <fd_close>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	eb ec                	jmp    801853 <close+0x19>

00801867 <close_all>:

void
close_all(void)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80186e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	53                   	push   %ebx
  801877:	e8 be ff ff ff       	call   80183a <close>
	for (i = 0; i < MAXFD; i++)
  80187c:	83 c3 01             	add    $0x1,%ebx
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	83 fb 20             	cmp    $0x20,%ebx
  801885:	75 ec                	jne    801873 <close_all+0xc>
}
  801887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801895:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	e8 67 fe ff ff       	call   801708 <fd_lookup>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	83 c4 10             	add    $0x10,%esp
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	0f 88 81 00 00 00    	js     80192f <dup+0xa3>
		return r;
	close(newfdnum);
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	e8 81 ff ff ff       	call   80183a <close>

	newfd = INDEX2FD(newfdnum);
  8018b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018bc:	c1 e6 0c             	shl    $0xc,%esi
  8018bf:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018c5:	83 c4 04             	add    $0x4,%esp
  8018c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018cb:	e8 cf fd ff ff       	call   80169f <fd2data>
  8018d0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018d2:	89 34 24             	mov    %esi,(%esp)
  8018d5:	e8 c5 fd ff ff       	call   80169f <fd2data>
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	c1 e8 16             	shr    $0x16,%eax
  8018e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018eb:	a8 01                	test   $0x1,%al
  8018ed:	74 11                	je     801900 <dup+0x74>
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	c1 e8 0c             	shr    $0xc,%eax
  8018f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018fb:	f6 c2 01             	test   $0x1,%dl
  8018fe:	75 39                	jne    801939 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801903:	89 d0                	mov    %edx,%eax
  801905:	c1 e8 0c             	shr    $0xc,%eax
  801908:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	25 07 0e 00 00       	and    $0xe07,%eax
  801917:	50                   	push   %eax
  801918:	56                   	push   %esi
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	6a 00                	push   $0x0
  80191e:	e8 f3 f5 ff ff       	call   800f16 <sys_page_map>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	83 c4 20             	add    $0x20,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 31                	js     80195d <dup+0xd1>
		goto err;

	return newfdnum;
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5f                   	pop    %edi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801939:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801940:	83 ec 0c             	sub    $0xc,%esp
  801943:	25 07 0e 00 00       	and    $0xe07,%eax
  801948:	50                   	push   %eax
  801949:	57                   	push   %edi
  80194a:	6a 00                	push   $0x0
  80194c:	53                   	push   %ebx
  80194d:	6a 00                	push   $0x0
  80194f:	e8 c2 f5 ff ff       	call   800f16 <sys_page_map>
  801954:	89 c3                	mov    %eax,%ebx
  801956:	83 c4 20             	add    $0x20,%esp
  801959:	85 c0                	test   %eax,%eax
  80195b:	79 a3                	jns    801900 <dup+0x74>
	sys_page_unmap(0, newfd);
  80195d:	83 ec 08             	sub    $0x8,%esp
  801960:	56                   	push   %esi
  801961:	6a 00                	push   $0x0
  801963:	e8 f0 f5 ff ff       	call   800f58 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801968:	83 c4 08             	add    $0x8,%esp
  80196b:	57                   	push   %edi
  80196c:	6a 00                	push   $0x0
  80196e:	e8 e5 f5 ff ff       	call   800f58 <sys_page_unmap>
	return r;
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	eb b7                	jmp    80192f <dup+0xa3>

00801978 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801982:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801985:	50                   	push   %eax
  801986:	53                   	push   %ebx
  801987:	e8 7c fd ff ff       	call   801708 <fd_lookup>
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 3f                	js     8019d2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801999:	50                   	push   %eax
  80199a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80199d:	ff 30                	pushl  (%eax)
  80199f:	e8 b4 fd ff ff       	call   801758 <dev_lookup>
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 27                	js     8019d2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ae:	8b 42 08             	mov    0x8(%edx),%eax
  8019b1:	83 e0 03             	and    $0x3,%eax
  8019b4:	83 f8 01             	cmp    $0x1,%eax
  8019b7:	74 1e                	je     8019d7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	8b 40 08             	mov    0x8(%eax),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 35                	je     8019f8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	52                   	push   %edx
  8019cd:	ff d0                	call   *%eax
  8019cf:	83 c4 10             	add    $0x10,%esp
}
  8019d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019dc:	8b 40 48             	mov    0x48(%eax),%eax
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	53                   	push   %ebx
  8019e3:	50                   	push   %eax
  8019e4:	68 41 32 80 00       	push   $0x803241
  8019e9:	e8 94 e9 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f6:	eb da                	jmp    8019d2 <read+0x5a>
		return -E_NOT_SUPP;
  8019f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019fd:	eb d3                	jmp    8019d2 <read+0x5a>

008019ff <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 0c             	sub    $0xc,%esp
  801a08:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a0b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a13:	39 f3                	cmp    %esi,%ebx
  801a15:	73 23                	jae    801a3a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a17:	83 ec 04             	sub    $0x4,%esp
  801a1a:	89 f0                	mov    %esi,%eax
  801a1c:	29 d8                	sub    %ebx,%eax
  801a1e:	50                   	push   %eax
  801a1f:	89 d8                	mov    %ebx,%eax
  801a21:	03 45 0c             	add    0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	57                   	push   %edi
  801a26:	e8 4d ff ff ff       	call   801978 <read>
		if (m < 0)
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 06                	js     801a38 <readn+0x39>
			return m;
		if (m == 0)
  801a32:	74 06                	je     801a3a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a34:	01 c3                	add    %eax,%ebx
  801a36:	eb db                	jmp    801a13 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a38:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a3a:	89 d8                	mov    %ebx,%eax
  801a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	53                   	push   %ebx
  801a48:	83 ec 1c             	sub    $0x1c,%esp
  801a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a51:	50                   	push   %eax
  801a52:	53                   	push   %ebx
  801a53:	e8 b0 fc ff ff       	call   801708 <fd_lookup>
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 3a                	js     801a99 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a65:	50                   	push   %eax
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	ff 30                	pushl  (%eax)
  801a6b:	e8 e8 fc ff ff       	call   801758 <dev_lookup>
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 22                	js     801a99 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7e:	74 1e                	je     801a9e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a83:	8b 52 0c             	mov    0xc(%edx),%edx
  801a86:	85 d2                	test   %edx,%edx
  801a88:	74 35                	je     801abf <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	50                   	push   %eax
  801a94:	ff d2                	call   *%edx
  801a96:	83 c4 10             	add    $0x10,%esp
}
  801a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9e:	a1 08 50 80 00       	mov    0x805008,%eax
  801aa3:	8b 40 48             	mov    0x48(%eax),%eax
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	53                   	push   %ebx
  801aaa:	50                   	push   %eax
  801aab:	68 5d 32 80 00       	push   $0x80325d
  801ab0:	e8 cd e8 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801abd:	eb da                	jmp    801a99 <write+0x55>
		return -E_NOT_SUPP;
  801abf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac4:	eb d3                	jmp    801a99 <write+0x55>

00801ac6 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acf:	50                   	push   %eax
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	e8 30 fc ff ff       	call   801708 <fd_lookup>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 0e                	js     801aed <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	53                   	push   %ebx
  801af3:	83 ec 1c             	sub    $0x1c,%esp
  801af6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801afc:	50                   	push   %eax
  801afd:	53                   	push   %ebx
  801afe:	e8 05 fc ff ff       	call   801708 <fd_lookup>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	85 c0                	test   %eax,%eax
  801b08:	78 37                	js     801b41 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	ff 30                	pushl  (%eax)
  801b16:	e8 3d fc ff ff       	call   801758 <dev_lookup>
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 1f                	js     801b41 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b25:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b29:	74 1b                	je     801b46 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2e:	8b 52 18             	mov    0x18(%edx),%edx
  801b31:	85 d2                	test   %edx,%edx
  801b33:	74 32                	je     801b67 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	ff d2                	call   *%edx
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b46:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b4b:	8b 40 48             	mov    0x48(%eax),%eax
  801b4e:	83 ec 04             	sub    $0x4,%esp
  801b51:	53                   	push   %ebx
  801b52:	50                   	push   %eax
  801b53:	68 20 32 80 00       	push   $0x803220
  801b58:	e8 25 e8 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801b5d:	83 c4 10             	add    $0x10,%esp
  801b60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b65:	eb da                	jmp    801b41 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b6c:	eb d3                	jmp    801b41 <ftruncate+0x52>

00801b6e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 1c             	sub    $0x1c,%esp
  801b75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b7b:	50                   	push   %eax
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	e8 84 fb ff ff       	call   801708 <fd_lookup>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 4b                	js     801bd6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b8b:	83 ec 08             	sub    $0x8,%esp
  801b8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b91:	50                   	push   %eax
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	ff 30                	pushl  (%eax)
  801b97:	e8 bc fb ff ff       	call   801758 <dev_lookup>
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 33                	js     801bd6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801baa:	74 2f                	je     801bdb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bac:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801baf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bb6:	00 00 00 
	stat->st_isdir = 0;
  801bb9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc0:	00 00 00 
	stat->st_dev = dev;
  801bc3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	53                   	push   %ebx
  801bcd:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd0:	ff 50 14             	call   *0x14(%eax)
  801bd3:	83 c4 10             	add    $0x10,%esp
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
		return -E_NOT_SUPP;
  801bdb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be0:	eb f4                	jmp    801bd6 <fstat+0x68>

00801be2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	6a 00                	push   $0x0
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	e8 22 02 00 00       	call   801e16 <open>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 1b                	js     801c18 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	50                   	push   %eax
  801c04:	e8 65 ff ff ff       	call   801b6e <fstat>
  801c09:	89 c6                	mov    %eax,%esi
	close(fd);
  801c0b:	89 1c 24             	mov    %ebx,(%esp)
  801c0e:	e8 27 fc ff ff       	call   80183a <close>
	return r;
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	89 f3                	mov    %esi,%ebx
}
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	89 c6                	mov    %eax,%esi
  801c28:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c2a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c31:	74 27                	je     801c5a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c33:	6a 07                	push   $0x7
  801c35:	68 00 60 80 00       	push   $0x806000
  801c3a:	56                   	push   %esi
  801c3b:	ff 35 00 50 80 00    	pushl  0x805000
  801c41:	e8 9d 0c 00 00       	call   8028e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c46:	83 c4 0c             	add    $0xc,%esp
  801c49:	6a 00                	push   $0x0
  801c4b:	53                   	push   %ebx
  801c4c:	6a 00                	push   $0x0
  801c4e:	e8 27 0c 00 00       	call   80287a <ipc_recv>
}
  801c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c5a:	83 ec 0c             	sub    $0xc,%esp
  801c5d:	6a 01                	push   $0x1
  801c5f:	e8 d7 0c 00 00       	call   80293b <ipc_find_env>
  801c64:	a3 00 50 80 00       	mov    %eax,0x805000
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	eb c5                	jmp    801c33 <fsipc+0x12>

00801c6e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c82:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 02 00 00 00       	mov    $0x2,%eax
  801c91:	e8 8b ff ff ff       	call   801c21 <fsipc>
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <devfile_flush>:
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca4:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cae:	b8 06 00 00 00       	mov    $0x6,%eax
  801cb3:	e8 69 ff ff ff       	call   801c21 <fsipc>
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <devfile_stat>:
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cca:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd9:	e8 43 ff ff ff       	call   801c21 <fsipc>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 2c                	js     801d0e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	68 00 60 80 00       	push   $0x806000
  801cea:	53                   	push   %ebx
  801ceb:	e8 f1 ed ff ff       	call   800ae1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cf0:	a1 80 60 80 00       	mov    0x806080,%eax
  801cf5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cfb:	a1 84 60 80 00       	mov    0x806084,%eax
  801d00:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d06:	83 c4 10             	add    $0x10,%esp
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <devfile_write>:
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 40 0c             	mov    0xc(%eax),%eax
  801d23:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d28:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d2e:	53                   	push   %ebx
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	68 08 60 80 00       	push   $0x806008
  801d37:	e8 95 ef ff ff       	call   800cd1 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	b8 04 00 00 00       	mov    $0x4,%eax
  801d46:	e8 d6 fe ff ff       	call   801c21 <fsipc>
  801d4b:	83 c4 10             	add    $0x10,%esp
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	78 0b                	js     801d5d <devfile_write+0x4a>
	assert(r <= n);
  801d52:	39 d8                	cmp    %ebx,%eax
  801d54:	77 0c                	ja     801d62 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d56:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d5b:	7f 1e                	jg     801d7b <devfile_write+0x68>
}
  801d5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    
	assert(r <= n);
  801d62:	68 90 32 80 00       	push   $0x803290
  801d67:	68 97 32 80 00       	push   $0x803297
  801d6c:	68 98 00 00 00       	push   $0x98
  801d71:	68 ac 32 80 00       	push   $0x8032ac
  801d76:	e8 11 e5 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801d7b:	68 b7 32 80 00       	push   $0x8032b7
  801d80:	68 97 32 80 00       	push   $0x803297
  801d85:	68 99 00 00 00       	push   $0x99
  801d8a:	68 ac 32 80 00       	push   $0x8032ac
  801d8f:	e8 f8 e4 ff ff       	call   80028c <_panic>

00801d94 <devfile_read>:
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801da2:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801da7:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dad:	ba 00 00 00 00       	mov    $0x0,%edx
  801db2:	b8 03 00 00 00       	mov    $0x3,%eax
  801db7:	e8 65 fe ff ff       	call   801c21 <fsipc>
  801dbc:	89 c3                	mov    %eax,%ebx
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 1f                	js     801de1 <devfile_read+0x4d>
	assert(r <= n);
  801dc2:	39 f0                	cmp    %esi,%eax
  801dc4:	77 24                	ja     801dea <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dc6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dcb:	7f 33                	jg     801e00 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	50                   	push   %eax
  801dd1:	68 00 60 80 00       	push   $0x806000
  801dd6:	ff 75 0c             	pushl  0xc(%ebp)
  801dd9:	e8 91 ee ff ff       	call   800c6f <memmove>
	return r;
  801dde:	83 c4 10             	add    $0x10,%esp
}
  801de1:	89 d8                	mov    %ebx,%eax
  801de3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    
	assert(r <= n);
  801dea:	68 90 32 80 00       	push   $0x803290
  801def:	68 97 32 80 00       	push   $0x803297
  801df4:	6a 7c                	push   $0x7c
  801df6:	68 ac 32 80 00       	push   $0x8032ac
  801dfb:	e8 8c e4 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801e00:	68 b7 32 80 00       	push   $0x8032b7
  801e05:	68 97 32 80 00       	push   $0x803297
  801e0a:	6a 7d                	push   $0x7d
  801e0c:	68 ac 32 80 00       	push   $0x8032ac
  801e11:	e8 76 e4 ff ff       	call   80028c <_panic>

00801e16 <open>:
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 1c             	sub    $0x1c,%esp
  801e1e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e21:	56                   	push   %esi
  801e22:	e8 81 ec ff ff       	call   800aa8 <strlen>
  801e27:	83 c4 10             	add    $0x10,%esp
  801e2a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e2f:	7f 6c                	jg     801e9d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e37:	50                   	push   %eax
  801e38:	e8 79 f8 ff ff       	call   8016b6 <fd_alloc>
  801e3d:	89 c3                	mov    %eax,%ebx
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 3c                	js     801e82 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e46:	83 ec 08             	sub    $0x8,%esp
  801e49:	56                   	push   %esi
  801e4a:	68 00 60 80 00       	push   $0x806000
  801e4f:	e8 8d ec ff ff       	call   800ae1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e64:	e8 b8 fd ff ff       	call   801c21 <fsipc>
  801e69:	89 c3                	mov    %eax,%ebx
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 19                	js     801e8b <open+0x75>
	return fd2num(fd);
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	ff 75 f4             	pushl  -0xc(%ebp)
  801e78:	e8 12 f8 ff ff       	call   80168f <fd2num>
  801e7d:	89 c3                	mov    %eax,%ebx
  801e7f:	83 c4 10             	add    $0x10,%esp
}
  801e82:	89 d8                	mov    %ebx,%eax
  801e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    
		fd_close(fd, 0);
  801e8b:	83 ec 08             	sub    $0x8,%esp
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 f4             	pushl  -0xc(%ebp)
  801e93:	e8 1b f9 ff ff       	call   8017b3 <fd_close>
		return r;
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	eb e5                	jmp    801e82 <open+0x6c>
		return -E_BAD_PATH;
  801e9d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ea2:	eb de                	jmp    801e82 <open+0x6c>

00801ea4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eaf:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb4:	e8 68 fd ff ff       	call   801c21 <fsipc>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ec1:	68 c3 32 80 00       	push   $0x8032c3
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	e8 13 ec ff ff       	call   800ae1 <strcpy>
	return 0;
}
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <devsock_close>:
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	53                   	push   %ebx
  801ed9:	83 ec 10             	sub    $0x10,%esp
  801edc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801edf:	53                   	push   %ebx
  801ee0:	e8 91 0a 00 00       	call   802976 <pageref>
  801ee5:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801eed:	83 f8 01             	cmp    $0x1,%eax
  801ef0:	74 07                	je     801ef9 <devsock_close+0x24>
}
  801ef2:	89 d0                	mov    %edx,%eax
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 73 0c             	pushl  0xc(%ebx)
  801eff:	e8 b9 02 00 00       	call   8021bd <nsipc_close>
  801f04:	89 c2                	mov    %eax,%edx
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	eb e7                	jmp    801ef2 <devsock_close+0x1d>

00801f0b <devsock_write>:
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 10             	pushl  0x10(%ebp)
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	ff 70 0c             	pushl  0xc(%eax)
  801f1f:	e8 76 03 00 00       	call   80229a <nsipc_send>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <devsock_read>:
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	ff 70 0c             	pushl  0xc(%eax)
  801f3a:	e8 ef 02 00 00       	call   80222e <nsipc_recv>
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <fd2sockid>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	e8 b7 f7 ff ff       	call   801708 <fd_lookup>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 10                	js     801f68 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f61:	39 08                	cmp    %ecx,(%eax)
  801f63:	75 05                	jne    801f6a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f65:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    
		return -E_NOT_SUPP;
  801f6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f6f:	eb f7                	jmp    801f68 <fd2sockid+0x27>

00801f71 <alloc_sockfd>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	83 ec 1c             	sub    $0x1c,%esp
  801f79:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	e8 32 f7 ff ff       	call   8016b6 <fd_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 43                	js     801fd0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 07 04 00 00       	push   $0x407
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 34 ef ff ff       	call   800ed3 <sys_page_alloc>
  801f9f:	89 c3                	mov    %eax,%ebx
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 28                	js     801fd0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fbd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	50                   	push   %eax
  801fc4:	e8 c6 f6 ff ff       	call   80168f <fd2num>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	eb 0c                	jmp    801fdc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	56                   	push   %esi
  801fd4:	e8 e4 01 00 00       	call   8021bd <nsipc_close>
		return r;
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <accept>:
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	e8 4e ff ff ff       	call   801f41 <fd2sockid>
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 1b                	js     802012 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	ff 75 10             	pushl  0x10(%ebp)
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	50                   	push   %eax
  802001:	e8 0e 01 00 00       	call   802114 <nsipc_accept>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	78 05                	js     802012 <accept+0x2d>
	return alloc_sockfd(r);
  80200d:	e8 5f ff ff ff       	call   801f71 <alloc_sockfd>
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <bind>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 1f ff ff ff       	call   801f41 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 12                	js     802038 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	e8 31 01 00 00       	call   802166 <nsipc_bind>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <shutdown>:
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	e8 f9 fe ff ff       	call   801f41 <fd2sockid>
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 0f                	js     80205b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	50                   	push   %eax
  802053:	e8 43 01 00 00       	call   80219b <nsipc_shutdown>
  802058:	83 c4 10             	add    $0x10,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <connect>:
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	e8 d6 fe ff ff       	call   801f41 <fd2sockid>
  80206b:	85 c0                	test   %eax,%eax
  80206d:	78 12                	js     802081 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	ff 75 10             	pushl  0x10(%ebp)
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	50                   	push   %eax
  802079:	e8 59 01 00 00       	call   8021d7 <nsipc_connect>
  80207e:	83 c4 10             	add    $0x10,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <listen>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	e8 b0 fe ff ff       	call   801f41 <fd2sockid>
  802091:	85 c0                	test   %eax,%eax
  802093:	78 0f                	js     8020a4 <listen+0x21>
	return nsipc_listen(r, backlog);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	50                   	push   %eax
  80209c:	e8 6b 01 00 00       	call   80220c <nsipc_listen>
  8020a1:	83 c4 10             	add    $0x10,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ac:	ff 75 10             	pushl  0x10(%ebp)
  8020af:	ff 75 0c             	pushl  0xc(%ebp)
  8020b2:	ff 75 08             	pushl  0x8(%ebp)
  8020b5:	e8 3e 02 00 00       	call   8022f8 <nsipc_socket>
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	78 05                	js     8020c6 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020c1:	e8 ab fe ff ff       	call   801f71 <alloc_sockfd>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	53                   	push   %ebx
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020d1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020d8:	74 26                	je     802100 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020da:	6a 07                	push   $0x7
  8020dc:	68 00 70 80 00       	push   $0x807000
  8020e1:	53                   	push   %ebx
  8020e2:	ff 35 04 50 80 00    	pushl  0x805004
  8020e8:	e8 f6 07 00 00       	call   8028e3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020ed:	83 c4 0c             	add    $0xc,%esp
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	e8 7f 07 00 00       	call   80287a <ipc_recv>
}
  8020fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	6a 02                	push   $0x2
  802105:	e8 31 08 00 00       	call   80293b <ipc_find_env>
  80210a:	a3 04 50 80 00       	mov    %eax,0x805004
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	eb c6                	jmp    8020da <nsipc+0x12>

00802114 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
  802119:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802124:	8b 06                	mov    (%esi),%eax
  802126:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80212b:	b8 01 00 00 00       	mov    $0x1,%eax
  802130:	e8 93 ff ff ff       	call   8020c8 <nsipc>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	85 c0                	test   %eax,%eax
  802139:	79 09                	jns    802144 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	ff 35 10 70 80 00    	pushl  0x807010
  80214d:	68 00 70 80 00       	push   $0x807000
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	e8 15 eb ff ff       	call   800c6f <memmove>
		*addrlen = ret->ret_addrlen;
  80215a:	a1 10 70 80 00       	mov    0x807010,%eax
  80215f:	89 06                	mov    %eax,(%esi)
  802161:	83 c4 10             	add    $0x10,%esp
	return r;
  802164:	eb d5                	jmp    80213b <nsipc_accept+0x27>

00802166 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	53                   	push   %ebx
  80216a:	83 ec 08             	sub    $0x8,%esp
  80216d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802178:	53                   	push   %ebx
  802179:	ff 75 0c             	pushl  0xc(%ebp)
  80217c:	68 04 70 80 00       	push   $0x807004
  802181:	e8 e9 ea ff ff       	call   800c6f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802186:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80218c:	b8 02 00 00 00       	mov    $0x2,%eax
  802191:	e8 32 ff ff ff       	call   8020c8 <nsipc>
}
  802196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ac:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b6:	e8 0d ff ff ff       	call   8020c8 <nsipc>
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <nsipc_close>:

int
nsipc_close(int s)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8021d0:	e8 f3 fe ff ff       	call   8020c8 <nsipc>
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	53                   	push   %ebx
  8021db:	83 ec 08             	sub    $0x8,%esp
  8021de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021e9:	53                   	push   %ebx
  8021ea:	ff 75 0c             	pushl  0xc(%ebp)
  8021ed:	68 04 70 80 00       	push   $0x807004
  8021f2:	e8 78 ea ff ff       	call   800c6f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021fd:	b8 05 00 00 00       	mov    $0x5,%eax
  802202:	e8 c1 fe ff ff       	call   8020c8 <nsipc>
}
  802207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80221a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802222:	b8 06 00 00 00       	mov    $0x6,%eax
  802227:	e8 9c fe ff ff       	call   8020c8 <nsipc>
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80223e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224c:	b8 07 00 00 00       	mov    $0x7,%eax
  802251:	e8 72 fe ff ff       	call   8020c8 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 1f                	js     80227b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80225c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802261:	7f 21                	jg     802284 <nsipc_recv+0x56>
  802263:	39 c6                	cmp    %eax,%esi
  802265:	7c 1d                	jl     802284 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	50                   	push   %eax
  80226b:	68 00 70 80 00       	push   $0x807000
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	e8 f7 e9 ff ff       	call   800c6f <memmove>
  802278:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80227b:	89 d8                	mov    %ebx,%eax
  80227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802284:	68 cf 32 80 00       	push   $0x8032cf
  802289:	68 97 32 80 00       	push   $0x803297
  80228e:	6a 62                	push   $0x62
  802290:	68 e4 32 80 00       	push   $0x8032e4
  802295:	e8 f2 df ff ff       	call   80028c <_panic>

0080229a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	53                   	push   %ebx
  80229e:	83 ec 04             	sub    $0x4,%esp
  8022a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022ac:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022b2:	7f 2e                	jg     8022e2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	53                   	push   %ebx
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	68 0c 70 80 00       	push   $0x80700c
  8022c0:	e8 aa e9 ff ff       	call   800c6f <memmove>
	nsipcbuf.send.req_size = size;
  8022c5:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ce:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d8:	e8 eb fd ff ff       	call   8020c8 <nsipc>
}
  8022dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    
	assert(size < 1600);
  8022e2:	68 f0 32 80 00       	push   $0x8032f0
  8022e7:	68 97 32 80 00       	push   $0x803297
  8022ec:	6a 6d                	push   $0x6d
  8022ee:	68 e4 32 80 00       	push   $0x8032e4
  8022f3:	e8 94 df ff ff       	call   80028c <_panic>

008022f8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80230e:	8b 45 10             	mov    0x10(%ebp),%eax
  802311:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802316:	b8 09 00 00 00       	mov    $0x9,%eax
  80231b:	e8 a8 fd ff ff       	call   8020c8 <nsipc>
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	56                   	push   %esi
  802326:	53                   	push   %ebx
  802327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80232a:	83 ec 0c             	sub    $0xc,%esp
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	e8 6a f3 ff ff       	call   80169f <fd2data>
  802335:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802337:	83 c4 08             	add    $0x8,%esp
  80233a:	68 fc 32 80 00       	push   $0x8032fc
  80233f:	53                   	push   %ebx
  802340:	e8 9c e7 ff ff       	call   800ae1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802345:	8b 46 04             	mov    0x4(%esi),%eax
  802348:	2b 06                	sub    (%esi),%eax
  80234a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802350:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802357:	00 00 00 
	stat->st_dev = &devpipe;
  80235a:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802361:	40 80 00 
	return 0;
}
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	53                   	push   %ebx
  802374:	83 ec 0c             	sub    $0xc,%esp
  802377:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80237a:	53                   	push   %ebx
  80237b:	6a 00                	push   $0x0
  80237d:	e8 d6 eb ff ff       	call   800f58 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802382:	89 1c 24             	mov    %ebx,(%esp)
  802385:	e8 15 f3 ff ff       	call   80169f <fd2data>
  80238a:	83 c4 08             	add    $0x8,%esp
  80238d:	50                   	push   %eax
  80238e:	6a 00                	push   $0x0
  802390:	e8 c3 eb ff ff       	call   800f58 <sys_page_unmap>
}
  802395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <_pipeisclosed>:
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	57                   	push   %edi
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
  8023a0:	83 ec 1c             	sub    $0x1c,%esp
  8023a3:	89 c7                	mov    %eax,%edi
  8023a5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8023ac:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023af:	83 ec 0c             	sub    $0xc,%esp
  8023b2:	57                   	push   %edi
  8023b3:	e8 be 05 00 00       	call   802976 <pageref>
  8023b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023bb:	89 34 24             	mov    %esi,(%esp)
  8023be:	e8 b3 05 00 00       	call   802976 <pageref>
		nn = thisenv->env_runs;
  8023c3:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023c9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	39 cb                	cmp    %ecx,%ebx
  8023d1:	74 1b                	je     8023ee <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d6:	75 cf                	jne    8023a7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023d8:	8b 42 58             	mov    0x58(%edx),%eax
  8023db:	6a 01                	push   $0x1
  8023dd:	50                   	push   %eax
  8023de:	53                   	push   %ebx
  8023df:	68 03 33 80 00       	push   $0x803303
  8023e4:	e8 99 df ff ff       	call   800382 <cprintf>
  8023e9:	83 c4 10             	add    $0x10,%esp
  8023ec:	eb b9                	jmp    8023a7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f1:	0f 94 c0             	sete   %al
  8023f4:	0f b6 c0             	movzbl %al,%eax
}
  8023f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023fa:	5b                   	pop    %ebx
  8023fb:	5e                   	pop    %esi
  8023fc:	5f                   	pop    %edi
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    

008023ff <devpipe_write>:
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	57                   	push   %edi
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	83 ec 28             	sub    $0x28,%esp
  802408:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80240b:	56                   	push   %esi
  80240c:	e8 8e f2 ff ff       	call   80169f <fd2data>
  802411:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802413:	83 c4 10             	add    $0x10,%esp
  802416:	bf 00 00 00 00       	mov    $0x0,%edi
  80241b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80241e:	74 4f                	je     80246f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802420:	8b 43 04             	mov    0x4(%ebx),%eax
  802423:	8b 0b                	mov    (%ebx),%ecx
  802425:	8d 51 20             	lea    0x20(%ecx),%edx
  802428:	39 d0                	cmp    %edx,%eax
  80242a:	72 14                	jb     802440 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80242c:	89 da                	mov    %ebx,%edx
  80242e:	89 f0                	mov    %esi,%eax
  802430:	e8 65 ff ff ff       	call   80239a <_pipeisclosed>
  802435:	85 c0                	test   %eax,%eax
  802437:	75 3b                	jne    802474 <devpipe_write+0x75>
			sys_yield();
  802439:	e8 76 ea ff ff       	call   800eb4 <sys_yield>
  80243e:	eb e0                	jmp    802420 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802443:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802447:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80244a:	89 c2                	mov    %eax,%edx
  80244c:	c1 fa 1f             	sar    $0x1f,%edx
  80244f:	89 d1                	mov    %edx,%ecx
  802451:	c1 e9 1b             	shr    $0x1b,%ecx
  802454:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802457:	83 e2 1f             	and    $0x1f,%edx
  80245a:	29 ca                	sub    %ecx,%edx
  80245c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802460:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802464:	83 c0 01             	add    $0x1,%eax
  802467:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80246a:	83 c7 01             	add    $0x1,%edi
  80246d:	eb ac                	jmp    80241b <devpipe_write+0x1c>
	return i;
  80246f:	8b 45 10             	mov    0x10(%ebp),%eax
  802472:	eb 05                	jmp    802479 <devpipe_write+0x7a>
				return 0;
  802474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <devpipe_read>:
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	57                   	push   %edi
  802485:	56                   	push   %esi
  802486:	53                   	push   %ebx
  802487:	83 ec 18             	sub    $0x18,%esp
  80248a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80248d:	57                   	push   %edi
  80248e:	e8 0c f2 ff ff       	call   80169f <fd2data>
  802493:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	be 00 00 00 00       	mov    $0x0,%esi
  80249d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a0:	75 14                	jne    8024b6 <devpipe_read+0x35>
	return i;
  8024a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a5:	eb 02                	jmp    8024a9 <devpipe_read+0x28>
				return i;
  8024a7:	89 f0                	mov    %esi,%eax
}
  8024a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
			sys_yield();
  8024b1:	e8 fe e9 ff ff       	call   800eb4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024b6:	8b 03                	mov    (%ebx),%eax
  8024b8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024bb:	75 18                	jne    8024d5 <devpipe_read+0x54>
			if (i > 0)
  8024bd:	85 f6                	test   %esi,%esi
  8024bf:	75 e6                	jne    8024a7 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024c1:	89 da                	mov    %ebx,%edx
  8024c3:	89 f8                	mov    %edi,%eax
  8024c5:	e8 d0 fe ff ff       	call   80239a <_pipeisclosed>
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 e3                	je     8024b1 <devpipe_read+0x30>
				return 0;
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	eb d4                	jmp    8024a9 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024d5:	99                   	cltd   
  8024d6:	c1 ea 1b             	shr    $0x1b,%edx
  8024d9:	01 d0                	add    %edx,%eax
  8024db:	83 e0 1f             	and    $0x1f,%eax
  8024de:	29 d0                	sub    %edx,%eax
  8024e0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024e8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024eb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024ee:	83 c6 01             	add    $0x1,%esi
  8024f1:	eb aa                	jmp    80249d <devpipe_read+0x1c>

008024f3 <pipe>:
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
  8024f6:	56                   	push   %esi
  8024f7:	53                   	push   %ebx
  8024f8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fe:	50                   	push   %eax
  8024ff:	e8 b2 f1 ff ff       	call   8016b6 <fd_alloc>
  802504:	89 c3                	mov    %eax,%ebx
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	85 c0                	test   %eax,%eax
  80250b:	0f 88 23 01 00 00    	js     802634 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802511:	83 ec 04             	sub    $0x4,%esp
  802514:	68 07 04 00 00       	push   $0x407
  802519:	ff 75 f4             	pushl  -0xc(%ebp)
  80251c:	6a 00                	push   $0x0
  80251e:	e8 b0 e9 ff ff       	call   800ed3 <sys_page_alloc>
  802523:	89 c3                	mov    %eax,%ebx
  802525:	83 c4 10             	add    $0x10,%esp
  802528:	85 c0                	test   %eax,%eax
  80252a:	0f 88 04 01 00 00    	js     802634 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802536:	50                   	push   %eax
  802537:	e8 7a f1 ff ff       	call   8016b6 <fd_alloc>
  80253c:	89 c3                	mov    %eax,%ebx
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	85 c0                	test   %eax,%eax
  802543:	0f 88 db 00 00 00    	js     802624 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 07 04 00 00       	push   $0x407
  802551:	ff 75 f0             	pushl  -0x10(%ebp)
  802554:	6a 00                	push   $0x0
  802556:	e8 78 e9 ff ff       	call   800ed3 <sys_page_alloc>
  80255b:	89 c3                	mov    %eax,%ebx
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	85 c0                	test   %eax,%eax
  802562:	0f 88 bc 00 00 00    	js     802624 <pipe+0x131>
	va = fd2data(fd0);
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	ff 75 f4             	pushl  -0xc(%ebp)
  80256e:	e8 2c f1 ff ff       	call   80169f <fd2data>
  802573:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802575:	83 c4 0c             	add    $0xc,%esp
  802578:	68 07 04 00 00       	push   $0x407
  80257d:	50                   	push   %eax
  80257e:	6a 00                	push   $0x0
  802580:	e8 4e e9 ff ff       	call   800ed3 <sys_page_alloc>
  802585:	89 c3                	mov    %eax,%ebx
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 88 82 00 00 00    	js     802614 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 f0             	pushl  -0x10(%ebp)
  802598:	e8 02 f1 ff ff       	call   80169f <fd2data>
  80259d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025a4:	50                   	push   %eax
  8025a5:	6a 00                	push   $0x0
  8025a7:	56                   	push   %esi
  8025a8:	6a 00                	push   $0x0
  8025aa:	e8 67 e9 ff ff       	call   800f16 <sys_page_map>
  8025af:	89 c3                	mov    %eax,%ebx
  8025b1:	83 c4 20             	add    $0x20,%esp
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	78 4e                	js     802606 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025b8:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025cf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e1:	e8 a9 f0 ff ff       	call   80168f <fd2num>
  8025e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025eb:	83 c4 04             	add    $0x4,%esp
  8025ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8025f1:	e8 99 f0 ff ff       	call   80168f <fd2num>
  8025f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025fc:	83 c4 10             	add    $0x10,%esp
  8025ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  802604:	eb 2e                	jmp    802634 <pipe+0x141>
	sys_page_unmap(0, va);
  802606:	83 ec 08             	sub    $0x8,%esp
  802609:	56                   	push   %esi
  80260a:	6a 00                	push   $0x0
  80260c:	e8 47 e9 ff ff       	call   800f58 <sys_page_unmap>
  802611:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802614:	83 ec 08             	sub    $0x8,%esp
  802617:	ff 75 f0             	pushl  -0x10(%ebp)
  80261a:	6a 00                	push   $0x0
  80261c:	e8 37 e9 ff ff       	call   800f58 <sys_page_unmap>
  802621:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802624:	83 ec 08             	sub    $0x8,%esp
  802627:	ff 75 f4             	pushl  -0xc(%ebp)
  80262a:	6a 00                	push   $0x0
  80262c:	e8 27 e9 ff ff       	call   800f58 <sys_page_unmap>
  802631:	83 c4 10             	add    $0x10,%esp
}
  802634:	89 d8                	mov    %ebx,%eax
  802636:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802639:	5b                   	pop    %ebx
  80263a:	5e                   	pop    %esi
  80263b:	5d                   	pop    %ebp
  80263c:	c3                   	ret    

0080263d <pipeisclosed>:
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802643:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802646:	50                   	push   %eax
  802647:	ff 75 08             	pushl  0x8(%ebp)
  80264a:	e8 b9 f0 ff ff       	call   801708 <fd_lookup>
  80264f:	83 c4 10             	add    $0x10,%esp
  802652:	85 c0                	test   %eax,%eax
  802654:	78 18                	js     80266e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	ff 75 f4             	pushl  -0xc(%ebp)
  80265c:	e8 3e f0 ff ff       	call   80169f <fd2data>
	return _pipeisclosed(fd, p);
  802661:	89 c2                	mov    %eax,%edx
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	e8 2f fd ff ff       	call   80239a <_pipeisclosed>
  80266b:	83 c4 10             	add    $0x10,%esp
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
  802675:	c3                   	ret    

00802676 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80267c:	68 1b 33 80 00       	push   $0x80331b
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	e8 58 e4 ff ff       	call   800ae1 <strcpy>
	return 0;
}
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <devcons_write>:
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	57                   	push   %edi
  802694:	56                   	push   %esi
  802695:	53                   	push   %ebx
  802696:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80269c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026a1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026a7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026aa:	73 31                	jae    8026dd <devcons_write+0x4d>
		m = n - tot;
  8026ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026af:	29 f3                	sub    %esi,%ebx
  8026b1:	83 fb 7f             	cmp    $0x7f,%ebx
  8026b4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026b9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	53                   	push   %ebx
  8026c0:	89 f0                	mov    %esi,%eax
  8026c2:	03 45 0c             	add    0xc(%ebp),%eax
  8026c5:	50                   	push   %eax
  8026c6:	57                   	push   %edi
  8026c7:	e8 a3 e5 ff ff       	call   800c6f <memmove>
		sys_cputs(buf, m);
  8026cc:	83 c4 08             	add    $0x8,%esp
  8026cf:	53                   	push   %ebx
  8026d0:	57                   	push   %edi
  8026d1:	e8 41 e7 ff ff       	call   800e17 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026d6:	01 de                	add    %ebx,%esi
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	eb ca                	jmp    8026a7 <devcons_write+0x17>
}
  8026dd:	89 f0                	mov    %esi,%eax
  8026df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026e2:	5b                   	pop    %ebx
  8026e3:	5e                   	pop    %esi
  8026e4:	5f                   	pop    %edi
  8026e5:	5d                   	pop    %ebp
  8026e6:	c3                   	ret    

008026e7 <devcons_read>:
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	83 ec 08             	sub    $0x8,%esp
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026f6:	74 21                	je     802719 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026f8:	e8 38 e7 ff ff       	call   800e35 <sys_cgetc>
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	75 07                	jne    802708 <devcons_read+0x21>
		sys_yield();
  802701:	e8 ae e7 ff ff       	call   800eb4 <sys_yield>
  802706:	eb f0                	jmp    8026f8 <devcons_read+0x11>
	if (c < 0)
  802708:	78 0f                	js     802719 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80270a:	83 f8 04             	cmp    $0x4,%eax
  80270d:	74 0c                	je     80271b <devcons_read+0x34>
	*(char*)vbuf = c;
  80270f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802712:	88 02                	mov    %al,(%edx)
	return 1;
  802714:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    
		return 0;
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
  802720:	eb f7                	jmp    802719 <devcons_read+0x32>

00802722 <cputchar>:
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80272e:	6a 01                	push   $0x1
  802730:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802733:	50                   	push   %eax
  802734:	e8 de e6 ff ff       	call   800e17 <sys_cputs>
}
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <getchar>:
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802744:	6a 01                	push   $0x1
  802746:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802749:	50                   	push   %eax
  80274a:	6a 00                	push   $0x0
  80274c:	e8 27 f2 ff ff       	call   801978 <read>
	if (r < 0)
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	85 c0                	test   %eax,%eax
  802756:	78 06                	js     80275e <getchar+0x20>
	if (r < 1)
  802758:	74 06                	je     802760 <getchar+0x22>
	return c;
  80275a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    
		return -E_EOF;
  802760:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802765:	eb f7                	jmp    80275e <getchar+0x20>

00802767 <iscons>:
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802770:	50                   	push   %eax
  802771:	ff 75 08             	pushl  0x8(%ebp)
  802774:	e8 8f ef ff ff       	call   801708 <fd_lookup>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	85 c0                	test   %eax,%eax
  80277e:	78 11                	js     802791 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802789:	39 10                	cmp    %edx,(%eax)
  80278b:	0f 94 c0             	sete   %al
  80278e:	0f b6 c0             	movzbl %al,%eax
}
  802791:	c9                   	leave  
  802792:	c3                   	ret    

00802793 <opencons>:
{
  802793:	55                   	push   %ebp
  802794:	89 e5                	mov    %esp,%ebp
  802796:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279c:	50                   	push   %eax
  80279d:	e8 14 ef ff ff       	call   8016b6 <fd_alloc>
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 3a                	js     8027e3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	68 07 04 00 00       	push   $0x407
  8027b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8027b4:	6a 00                	push   $0x0
  8027b6:	e8 18 e7 ff ff       	call   800ed3 <sys_page_alloc>
  8027bb:	83 c4 10             	add    $0x10,%esp
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	78 21                	js     8027e3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027cb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027d7:	83 ec 0c             	sub    $0xc,%esp
  8027da:	50                   	push   %eax
  8027db:	e8 af ee ff ff       	call   80168f <fd2num>
  8027e0:	83 c4 10             	add    $0x10,%esp
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027eb:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027f2:	74 0a                	je     8027fe <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	6a 07                	push   $0x7
  802803:	68 00 f0 bf ee       	push   $0xeebff000
  802808:	6a 00                	push   $0x0
  80280a:	e8 c4 e6 ff ff       	call   800ed3 <sys_page_alloc>
		if(r < 0)
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	85 c0                	test   %eax,%eax
  802814:	78 2a                	js     802840 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  802816:	83 ec 08             	sub    $0x8,%esp
  802819:	68 54 28 80 00       	push   $0x802854
  80281e:	6a 00                	push   $0x0
  802820:	e8 f9 e7 ff ff       	call   80101e <sys_env_set_pgfault_upcall>
		if(r < 0)
  802825:	83 c4 10             	add    $0x10,%esp
  802828:	85 c0                	test   %eax,%eax
  80282a:	79 c8                	jns    8027f4 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 58 33 80 00       	push   $0x803358
  802834:	6a 25                	push   $0x25
  802836:	68 94 33 80 00       	push   $0x803394
  80283b:	e8 4c da ff ff       	call   80028c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 28 33 80 00       	push   $0x803328
  802848:	6a 22                	push   $0x22
  80284a:	68 94 33 80 00       	push   $0x803394
  80284f:	e8 38 da ff ff       	call   80028c <_panic>

00802854 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802854:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802855:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80285a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80285c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80285f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802863:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  802867:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80286a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80286c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802870:	83 c4 08             	add    $0x8,%esp
	popal
  802873:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802874:	83 c4 04             	add    $0x4,%esp
	popfl
  802877:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802878:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802879:	c3                   	ret    

0080287a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	56                   	push   %esi
  80287e:	53                   	push   %ebx
  80287f:	8b 75 08             	mov    0x8(%ebp),%esi
  802882:	8b 45 0c             	mov    0xc(%ebp),%eax
  802885:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802888:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80288a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80288f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	50                   	push   %eax
  802896:	e8 e8 e7 ff ff       	call   801083 <sys_ipc_recv>
	if(ret < 0){
  80289b:	83 c4 10             	add    $0x10,%esp
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 2b                	js     8028cd <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028a2:	85 f6                	test   %esi,%esi
  8028a4:	74 0a                	je     8028b0 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8028a6:	a1 08 50 80 00       	mov    0x805008,%eax
  8028ab:	8b 40 74             	mov    0x74(%eax),%eax
  8028ae:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028b0:	85 db                	test   %ebx,%ebx
  8028b2:	74 0a                	je     8028be <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8028b4:	a1 08 50 80 00       	mov    0x805008,%eax
  8028b9:	8b 40 78             	mov    0x78(%eax),%eax
  8028bc:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8028be:	a1 08 50 80 00       	mov    0x805008,%eax
  8028c3:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c9:	5b                   	pop    %ebx
  8028ca:	5e                   	pop    %esi
  8028cb:	5d                   	pop    %ebp
  8028cc:	c3                   	ret    
		if(from_env_store)
  8028cd:	85 f6                	test   %esi,%esi
  8028cf:	74 06                	je     8028d7 <ipc_recv+0x5d>
			*from_env_store = 0;
  8028d1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028d7:	85 db                	test   %ebx,%ebx
  8028d9:	74 eb                	je     8028c6 <ipc_recv+0x4c>
			*perm_store = 0;
  8028db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028e1:	eb e3                	jmp    8028c6 <ipc_recv+0x4c>

008028e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	57                   	push   %edi
  8028e7:	56                   	push   %esi
  8028e8:	53                   	push   %ebx
  8028e9:	83 ec 0c             	sub    $0xc,%esp
  8028ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028f5:	85 db                	test   %ebx,%ebx
  8028f7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028fc:	0f 44 d8             	cmove  %eax,%ebx
  8028ff:	eb 05                	jmp    802906 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802901:	e8 ae e5 ff ff       	call   800eb4 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802906:	ff 75 14             	pushl  0x14(%ebp)
  802909:	53                   	push   %ebx
  80290a:	56                   	push   %esi
  80290b:	57                   	push   %edi
  80290c:	e8 4f e7 ff ff       	call   801060 <sys_ipc_try_send>
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	85 c0                	test   %eax,%eax
  802916:	74 1b                	je     802933 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802918:	79 e7                	jns    802901 <ipc_send+0x1e>
  80291a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80291d:	74 e2                	je     802901 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 a2 33 80 00       	push   $0x8033a2
  802927:	6a 48                	push   $0x48
  802929:	68 b7 33 80 00       	push   $0x8033b7
  80292e:	e8 59 d9 ff ff       	call   80028c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802933:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802936:	5b                   	pop    %ebx
  802937:	5e                   	pop    %esi
  802938:	5f                   	pop    %edi
  802939:	5d                   	pop    %ebp
  80293a:	c3                   	ret    

0080293b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
  80293e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802946:	89 c2                	mov    %eax,%edx
  802948:	c1 e2 07             	shl    $0x7,%edx
  80294b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802951:	8b 52 50             	mov    0x50(%edx),%edx
  802954:	39 ca                	cmp    %ecx,%edx
  802956:	74 11                	je     802969 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802958:	83 c0 01             	add    $0x1,%eax
  80295b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802960:	75 e4                	jne    802946 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	eb 0b                	jmp    802974 <ipc_find_env+0x39>
			return envs[i].env_id;
  802969:	c1 e0 07             	shl    $0x7,%eax
  80296c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802971:	8b 40 48             	mov    0x48(%eax),%eax
}
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    

00802976 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80297c:	89 d0                	mov    %edx,%eax
  80297e:	c1 e8 16             	shr    $0x16,%eax
  802981:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80298d:	f6 c1 01             	test   $0x1,%cl
  802990:	74 1d                	je     8029af <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802992:	c1 ea 0c             	shr    $0xc,%edx
  802995:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80299c:	f6 c2 01             	test   $0x1,%dl
  80299f:	74 0e                	je     8029af <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029a1:	c1 ea 0c             	shr    $0xc,%edx
  8029a4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029ab:	ef 
  8029ac:	0f b7 c0             	movzwl %ax,%eax
}
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	66 90                	xchg   %ax,%ax
  8029b3:	66 90                	xchg   %ax,%ax
  8029b5:	66 90                	xchg   %ax,%ax
  8029b7:	66 90                	xchg   %ax,%ax
  8029b9:	66 90                	xchg   %ax,%ax
  8029bb:	66 90                	xchg   %ax,%ax
  8029bd:	66 90                	xchg   %ax,%ax
  8029bf:	90                   	nop

008029c0 <__udivdi3>:
  8029c0:	55                   	push   %ebp
  8029c1:	57                   	push   %edi
  8029c2:	56                   	push   %esi
  8029c3:	53                   	push   %ebx
  8029c4:	83 ec 1c             	sub    $0x1c,%esp
  8029c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029d7:	85 d2                	test   %edx,%edx
  8029d9:	75 4d                	jne    802a28 <__udivdi3+0x68>
  8029db:	39 f3                	cmp    %esi,%ebx
  8029dd:	76 19                	jbe    8029f8 <__udivdi3+0x38>
  8029df:	31 ff                	xor    %edi,%edi
  8029e1:	89 e8                	mov    %ebp,%eax
  8029e3:	89 f2                	mov    %esi,%edx
  8029e5:	f7 f3                	div    %ebx
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	83 c4 1c             	add    $0x1c,%esp
  8029ec:	5b                   	pop    %ebx
  8029ed:	5e                   	pop    %esi
  8029ee:	5f                   	pop    %edi
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	89 d9                	mov    %ebx,%ecx
  8029fa:	85 db                	test   %ebx,%ebx
  8029fc:	75 0b                	jne    802a09 <__udivdi3+0x49>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f3                	div    %ebx
  802a07:	89 c1                	mov    %eax,%ecx
  802a09:	31 d2                	xor    %edx,%edx
  802a0b:	89 f0                	mov    %esi,%eax
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 c6                	mov    %eax,%esi
  802a11:	89 e8                	mov    %ebp,%eax
  802a13:	89 f7                	mov    %esi,%edi
  802a15:	f7 f1                	div    %ecx
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	83 c4 1c             	add    $0x1c,%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	5d                   	pop    %ebp
  802a20:	c3                   	ret    
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	77 1c                	ja     802a48 <__udivdi3+0x88>
  802a2c:	0f bd fa             	bsr    %edx,%edi
  802a2f:	83 f7 1f             	xor    $0x1f,%edi
  802a32:	75 2c                	jne    802a60 <__udivdi3+0xa0>
  802a34:	39 f2                	cmp    %esi,%edx
  802a36:	72 06                	jb     802a3e <__udivdi3+0x7e>
  802a38:	31 c0                	xor    %eax,%eax
  802a3a:	39 eb                	cmp    %ebp,%ebx
  802a3c:	77 a9                	ja     8029e7 <__udivdi3+0x27>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	eb a2                	jmp    8029e7 <__udivdi3+0x27>
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	31 ff                	xor    %edi,%edi
  802a4a:	31 c0                	xor    %eax,%eax
  802a4c:	89 fa                	mov    %edi,%edx
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a5d:	8d 76 00             	lea    0x0(%esi),%esi
  802a60:	89 f9                	mov    %edi,%ecx
  802a62:	b8 20 00 00 00       	mov    $0x20,%eax
  802a67:	29 f8                	sub    %edi,%eax
  802a69:	d3 e2                	shl    %cl,%edx
  802a6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a6f:	89 c1                	mov    %eax,%ecx
  802a71:	89 da                	mov    %ebx,%edx
  802a73:	d3 ea                	shr    %cl,%edx
  802a75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a79:	09 d1                	or     %edx,%ecx
  802a7b:	89 f2                	mov    %esi,%edx
  802a7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a81:	89 f9                	mov    %edi,%ecx
  802a83:	d3 e3                	shl    %cl,%ebx
  802a85:	89 c1                	mov    %eax,%ecx
  802a87:	d3 ea                	shr    %cl,%edx
  802a89:	89 f9                	mov    %edi,%ecx
  802a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a8f:	89 eb                	mov    %ebp,%ebx
  802a91:	d3 e6                	shl    %cl,%esi
  802a93:	89 c1                	mov    %eax,%ecx
  802a95:	d3 eb                	shr    %cl,%ebx
  802a97:	09 de                	or     %ebx,%esi
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	f7 74 24 08          	divl   0x8(%esp)
  802a9f:	89 d6                	mov    %edx,%esi
  802aa1:	89 c3                	mov    %eax,%ebx
  802aa3:	f7 64 24 0c          	mull   0xc(%esp)
  802aa7:	39 d6                	cmp    %edx,%esi
  802aa9:	72 15                	jb     802ac0 <__udivdi3+0x100>
  802aab:	89 f9                	mov    %edi,%ecx
  802aad:	d3 e5                	shl    %cl,%ebp
  802aaf:	39 c5                	cmp    %eax,%ebp
  802ab1:	73 04                	jae    802ab7 <__udivdi3+0xf7>
  802ab3:	39 d6                	cmp    %edx,%esi
  802ab5:	74 09                	je     802ac0 <__udivdi3+0x100>
  802ab7:	89 d8                	mov    %ebx,%eax
  802ab9:	31 ff                	xor    %edi,%edi
  802abb:	e9 27 ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802ac0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ac3:	31 ff                	xor    %edi,%edi
  802ac5:	e9 1d ff ff ff       	jmp    8029e7 <__udivdi3+0x27>
  802aca:	66 90                	xchg   %ax,%ax
  802acc:	66 90                	xchg   %ax,%ax
  802ace:	66 90                	xchg   %ax,%ax

00802ad0 <__umoddi3>:
  802ad0:	55                   	push   %ebp
  802ad1:	57                   	push   %edi
  802ad2:	56                   	push   %esi
  802ad3:	53                   	push   %ebx
  802ad4:	83 ec 1c             	sub    $0x1c,%esp
  802ad7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802adf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802ae7:	89 da                	mov    %ebx,%edx
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	75 43                	jne    802b30 <__umoddi3+0x60>
  802aed:	39 df                	cmp    %ebx,%edi
  802aef:	76 17                	jbe    802b08 <__umoddi3+0x38>
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	f7 f7                	div    %edi
  802af5:	89 d0                	mov    %edx,%eax
  802af7:	31 d2                	xor    %edx,%edx
  802af9:	83 c4 1c             	add    $0x1c,%esp
  802afc:	5b                   	pop    %ebx
  802afd:	5e                   	pop    %esi
  802afe:	5f                   	pop    %edi
  802aff:	5d                   	pop    %ebp
  802b00:	c3                   	ret    
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	89 fd                	mov    %edi,%ebp
  802b0a:	85 ff                	test   %edi,%edi
  802b0c:	75 0b                	jne    802b19 <__umoddi3+0x49>
  802b0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f7                	div    %edi
  802b17:	89 c5                	mov    %eax,%ebp
  802b19:	89 d8                	mov    %ebx,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f5                	div    %ebp
  802b1f:	89 f0                	mov    %esi,%eax
  802b21:	f7 f5                	div    %ebp
  802b23:	89 d0                	mov    %edx,%eax
  802b25:	eb d0                	jmp    802af7 <__umoddi3+0x27>
  802b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b2e:	66 90                	xchg   %ax,%ax
  802b30:	89 f1                	mov    %esi,%ecx
  802b32:	39 d8                	cmp    %ebx,%eax
  802b34:	76 0a                	jbe    802b40 <__umoddi3+0x70>
  802b36:	89 f0                	mov    %esi,%eax
  802b38:	83 c4 1c             	add    $0x1c,%esp
  802b3b:	5b                   	pop    %ebx
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	0f bd e8             	bsr    %eax,%ebp
  802b43:	83 f5 1f             	xor    $0x1f,%ebp
  802b46:	75 20                	jne    802b68 <__umoddi3+0x98>
  802b48:	39 d8                	cmp    %ebx,%eax
  802b4a:	0f 82 b0 00 00 00    	jb     802c00 <__umoddi3+0x130>
  802b50:	39 f7                	cmp    %esi,%edi
  802b52:	0f 86 a8 00 00 00    	jbe    802c00 <__umoddi3+0x130>
  802b58:	89 c8                	mov    %ecx,%eax
  802b5a:	83 c4 1c             	add    $0x1c,%esp
  802b5d:	5b                   	pop    %ebx
  802b5e:	5e                   	pop    %esi
  802b5f:	5f                   	pop    %edi
  802b60:	5d                   	pop    %ebp
  802b61:	c3                   	ret    
  802b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b6f:	29 ea                	sub    %ebp,%edx
  802b71:	d3 e0                	shl    %cl,%eax
  802b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b77:	89 d1                	mov    %edx,%ecx
  802b79:	89 f8                	mov    %edi,%eax
  802b7b:	d3 e8                	shr    %cl,%eax
  802b7d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b81:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b85:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b89:	09 c1                	or     %eax,%ecx
  802b8b:	89 d8                	mov    %ebx,%eax
  802b8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b91:	89 e9                	mov    %ebp,%ecx
  802b93:	d3 e7                	shl    %cl,%edi
  802b95:	89 d1                	mov    %edx,%ecx
  802b97:	d3 e8                	shr    %cl,%eax
  802b99:	89 e9                	mov    %ebp,%ecx
  802b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b9f:	d3 e3                	shl    %cl,%ebx
  802ba1:	89 c7                	mov    %eax,%edi
  802ba3:	89 d1                	mov    %edx,%ecx
  802ba5:	89 f0                	mov    %esi,%eax
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 fa                	mov    %edi,%edx
  802bad:	d3 e6                	shl    %cl,%esi
  802baf:	09 d8                	or     %ebx,%eax
  802bb1:	f7 74 24 08          	divl   0x8(%esp)
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	89 f3                	mov    %esi,%ebx
  802bb9:	f7 64 24 0c          	mull   0xc(%esp)
  802bbd:	89 c6                	mov    %eax,%esi
  802bbf:	89 d7                	mov    %edx,%edi
  802bc1:	39 d1                	cmp    %edx,%ecx
  802bc3:	72 06                	jb     802bcb <__umoddi3+0xfb>
  802bc5:	75 10                	jne    802bd7 <__umoddi3+0x107>
  802bc7:	39 c3                	cmp    %eax,%ebx
  802bc9:	73 0c                	jae    802bd7 <__umoddi3+0x107>
  802bcb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bcf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bd3:	89 d7                	mov    %edx,%edi
  802bd5:	89 c6                	mov    %eax,%esi
  802bd7:	89 ca                	mov    %ecx,%edx
  802bd9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bde:	29 f3                	sub    %esi,%ebx
  802be0:	19 fa                	sbb    %edi,%edx
  802be2:	89 d0                	mov    %edx,%eax
  802be4:	d3 e0                	shl    %cl,%eax
  802be6:	89 e9                	mov    %ebp,%ecx
  802be8:	d3 eb                	shr    %cl,%ebx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	09 d8                	or     %ebx,%eax
  802bee:	83 c4 1c             	add    $0x1c,%esp
  802bf1:	5b                   	pop    %ebx
  802bf2:	5e                   	pop    %esi
  802bf3:	5f                   	pop    %edi
  802bf4:	5d                   	pop    %ebp
  802bf5:	c3                   	ret    
  802bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	89 da                	mov    %ebx,%edx
  802c02:	29 fe                	sub    %edi,%esi
  802c04:	19 c2                	sbb    %eax,%edx
  802c06:	89 f1                	mov    %esi,%ecx
  802c08:	89 c8                	mov    %ecx,%eax
  802c0a:	e9 4b ff ff ff       	jmp    802b5a <__umoddi3+0x8a>
