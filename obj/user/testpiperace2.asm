
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
  80004c:	e8 b6 24 00 00       	call   802507 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5b                	js     8000b3 <umain+0x80>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 b4 13 00 00       	call   801411 <fork>
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
  800088:	e8 c4 25 00 00       	call   802651 <pipeisclosed>
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
  8000dd:	e8 6c 17 00 00       	call   80184e <close>
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
  800107:	e8 94 17 00 00       	call   8018a0 <dup>
			sys_yield();
  80010c:	e8 a3 0d 00 00       	call   800eb4 <sys_yield>
			close(10);
  800111:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800118:	e8 31 17 00 00       	call   80184e <close>
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
  800166:	e8 e6 24 00 00       	call   802651 <pipeisclosed>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	85 c0                	test   %eax,%eax
  800170:	75 38                	jne    8001aa <umain+0x177>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	ff 75 e0             	pushl  -0x20(%ebp)
  80017c:	e8 9b 15 00 00       	call   80171c <fd_lookup>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 36                	js     8001be <umain+0x18b>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 dc             	pushl  -0x24(%ebp)
  80018e:	e8 20 15 00 00       	call   8016b3 <fd2data>
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

	cprintf("call umain!\n");
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
  800278:	e8 fe 15 00 00       	call   80187b <close_all>
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
  80029c:	68 40 2d 80 00       	push   $0x802d40
  8002a1:	50                   	push   %eax
  8002a2:	68 0e 2d 80 00       	push   $0x802d0e
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
  8002c5:	68 1c 2d 80 00       	push   $0x802d1c
  8002ca:	e8 b3 00 00 00       	call   800382 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cf:	83 c4 18             	add    $0x18,%esp
  8002d2:	53                   	push   %ebx
  8002d3:	ff 75 10             	pushl  0x10(%ebp)
  8002d6:	e8 56 00 00 00       	call   800331 <vcprintf>
	cprintf("\n");
  8002db:	c7 04 24 02 2d 80 00 	movl   $0x802d02,(%esp)
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
  80042f:	e8 9c 25 00 00       	call   8029d0 <__udivdi3>
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
  800458:	e8 83 26 00 00       	call   802ae0 <__umoddi3>
  80045d:	83 c4 14             	add    $0x14,%esp
  800460:	0f be 80 47 2d 80 00 	movsbl 0x802d47(%eax),%eax
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
  800509:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
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
  8005d4:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  8005db:	85 d2                	test   %edx,%edx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005df:	52                   	push   %edx
  8005e0:	68 91 32 80 00       	push   $0x803291
  8005e5:	53                   	push   %ebx
  8005e6:	56                   	push   %esi
  8005e7:	e8 a6 fe ff ff       	call   800492 <printfmt>
  8005ec:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005ef:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005f2:	e9 fe 02 00 00       	jmp    8008f5 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005f7:	50                   	push   %eax
  8005f8:	68 5f 2d 80 00       	push   $0x802d5f
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
  80061f:	b8 58 2d 80 00       	mov    $0x802d58,%eax
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
  8009b7:	bf 7d 2e 80 00       	mov    $0x802e7d,%edi
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
  8009e3:	bf b5 2e 80 00       	mov    $0x802eb5,%edi
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
  800e84:	68 c4 30 80 00       	push   $0x8030c4
  800e89:	6a 43                	push   $0x43
  800e8b:	68 e1 30 80 00       	push   $0x8030e1
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
  800f05:	68 c4 30 80 00       	push   $0x8030c4
  800f0a:	6a 43                	push   $0x43
  800f0c:	68 e1 30 80 00       	push   $0x8030e1
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
  800f47:	68 c4 30 80 00       	push   $0x8030c4
  800f4c:	6a 43                	push   $0x43
  800f4e:	68 e1 30 80 00       	push   $0x8030e1
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
  800f89:	68 c4 30 80 00       	push   $0x8030c4
  800f8e:	6a 43                	push   $0x43
  800f90:	68 e1 30 80 00       	push   $0x8030e1
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
  800fcb:	68 c4 30 80 00       	push   $0x8030c4
  800fd0:	6a 43                	push   $0x43
  800fd2:	68 e1 30 80 00       	push   $0x8030e1
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
  80100d:	68 c4 30 80 00       	push   $0x8030c4
  801012:	6a 43                	push   $0x43
  801014:	68 e1 30 80 00       	push   $0x8030e1
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
  80104f:	68 c4 30 80 00       	push   $0x8030c4
  801054:	6a 43                	push   $0x43
  801056:	68 e1 30 80 00       	push   $0x8030e1
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
  8010b3:	68 c4 30 80 00       	push   $0x8030c4
  8010b8:	6a 43                	push   $0x43
  8010ba:	68 e1 30 80 00       	push   $0x8030e1
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
  801197:	68 c4 30 80 00       	push   $0x8030c4
  80119c:	6a 43                	push   $0x43
  80119e:	68 e1 30 80 00       	push   $0x8030e1
  8011a3:	e8 e4 f0 ff ff       	call   80028c <_panic>

008011a8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011b2:	8b 02                	mov    (%edx),%eax
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).
	// LAB 4: Your code here.
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011b4:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011b8:	0f 84 99 00 00 00    	je     801257 <pgfault+0xaf>
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	c1 ea 16             	shr    $0x16,%edx
  8011c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ca:	f6 c2 01             	test   $0x1,%dl
  8011cd:	0f 84 84 00 00 00    	je     801257 <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  8011d3:	89 c2                	mov    %eax,%edx
  8011d5:	c1 ea 0c             	shr    $0xc,%edx
  8011d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011df:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011e5:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  8011eb:	75 6a                	jne    801257 <pgfault+0xaf>
	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	addr = ROUNDDOWN(addr, PGSIZE);
  8011ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f2:	89 c3                	mov    %eax,%ebx
	int ret;
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	6a 07                	push   $0x7
  8011f9:	68 00 f0 7f 00       	push   $0x7ff000
  8011fe:	6a 00                	push   $0x0
  801200:	e8 ce fc ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	85 c0                	test   %eax,%eax
  80120a:	78 5f                	js     80126b <pgfault+0xc3>
		panic("panic in sys_page_alloc()\n");
	
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80120c:	83 ec 04             	sub    $0x4,%esp
  80120f:	68 00 10 00 00       	push   $0x1000
  801214:	53                   	push   %ebx
  801215:	68 00 f0 7f 00       	push   $0x7ff000
  80121a:	e8 b2 fa ff ff       	call   800cd1 <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  80121f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801226:	53                   	push   %ebx
  801227:	6a 00                	push   $0x0
  801229:	68 00 f0 7f 00       	push   $0x7ff000
  80122e:	6a 00                	push   $0x0
  801230:	e8 e1 fc ff ff       	call   800f16 <sys_page_map>
	if(ret < 0)
  801235:	83 c4 20             	add    $0x20,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 43                	js     80127f <pgfault+0xd7>
		panic("panic in sys_page_map()\n");
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	68 00 f0 7f 00       	push   $0x7ff000
  801244:	6a 00                	push   $0x0
  801246:	e8 0d fd ff ff       	call   800f58 <sys_page_unmap>
	if(ret < 0)
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 41                	js     801293 <pgfault+0xeb>
		panic("panic in sys_page_unmap()\n");
	// LAB 4: Your code here.

	// panic("pgfault not implemented");

}
  801252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801255:	c9                   	leave  
  801256:	c3                   	ret    
		panic("panic at pgfault()\n");
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 ef 30 80 00       	push   $0x8030ef
  80125f:	6a 26                	push   $0x26
  801261:	68 03 31 80 00       	push   $0x803103
  801266:	e8 21 f0 ff ff       	call   80028c <_panic>
		panic("panic in sys_page_alloc()\n");
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	68 0e 31 80 00       	push   $0x80310e
  801273:	6a 31                	push   $0x31
  801275:	68 03 31 80 00       	push   $0x803103
  80127a:	e8 0d f0 ff ff       	call   80028c <_panic>
		panic("panic in sys_page_map()\n");
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	68 29 31 80 00       	push   $0x803129
  801287:	6a 36                	push   $0x36
  801289:	68 03 31 80 00       	push   $0x803103
  80128e:	e8 f9 ef ff ff       	call   80028c <_panic>
		panic("panic in sys_page_unmap()\n");
  801293:	83 ec 04             	sub    $0x4,%esp
  801296:	68 42 31 80 00       	push   $0x803142
  80129b:	6a 39                	push   $0x39
  80129d:	68 03 31 80 00       	push   $0x803103
  8012a2:	e8 e5 ef ff ff       	call   80028c <_panic>

008012a7 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	89 c6                	mov    %eax,%esi
  8012ae:	89 d3                	mov    %edx,%ebx
	cprintf("in %s\n", __FUNCTION__);
  8012b0:	83 ec 08             	sub    $0x8,%esp
  8012b3:	68 e0 31 80 00       	push   $0x8031e0
  8012b8:	68 12 2d 80 00       	push   $0x802d12
  8012bd:	e8 c0 f0 ff ff       	call   800382 <cprintf>
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  8012c2:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	f6 c4 04             	test   $0x4,%ah
  8012cf:	75 45                	jne    801316 <duppage+0x6f>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8012d1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012d8:	83 e0 07             	and    $0x7,%eax
  8012db:	83 f8 07             	cmp    $0x7,%eax
  8012de:	74 6e                	je     80134e <duppage+0xa7>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8012e0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012e7:	25 05 08 00 00       	and    $0x805,%eax
  8012ec:	3d 05 08 00 00       	cmp    $0x805,%eax
  8012f1:	0f 84 b5 00 00 00    	je     8013ac <duppage+0x105>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8012f7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012fe:	83 e0 05             	and    $0x5,%eax
  801301:	83 f8 05             	cmp    $0x5,%eax
  801304:	0f 84 d6 00 00 00    	je     8013e0 <duppage+0x139>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
  80130f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  801316:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80131d:	c1 e3 0c             	shl    $0xc,%ebx
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	25 07 0e 00 00       	and    $0xe07,%eax
  801328:	50                   	push   %eax
  801329:	53                   	push   %ebx
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
  80132c:	6a 00                	push   $0x0
  80132e:	e8 e3 fb ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  801333:	83 c4 20             	add    $0x20,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	79 d0                	jns    80130a <duppage+0x63>
			panic("sys_page_map() panic\n");
  80133a:	83 ec 04             	sub    $0x4,%esp
  80133d:	68 5d 31 80 00       	push   $0x80315d
  801342:	6a 55                	push   $0x55
  801344:	68 03 31 80 00       	push   $0x803103
  801349:	e8 3e ef ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  80134e:	c1 e3 0c             	shl    $0xc,%ebx
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	68 05 08 00 00       	push   $0x805
  801359:	53                   	push   %ebx
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
  80135c:	6a 00                	push   $0x0
  80135e:	e8 b3 fb ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  801363:	83 c4 20             	add    $0x20,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	78 2e                	js     801398 <duppage+0xf1>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  80136a:	83 ec 0c             	sub    $0xc,%esp
  80136d:	68 05 08 00 00       	push   $0x805
  801372:	53                   	push   %ebx
  801373:	6a 00                	push   $0x0
  801375:	53                   	push   %ebx
  801376:	6a 00                	push   $0x0
  801378:	e8 99 fb ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  80137d:	83 c4 20             	add    $0x20,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	79 86                	jns    80130a <duppage+0x63>
			panic("sys_page_map() panic\n");
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	68 5d 31 80 00       	push   $0x80315d
  80138c:	6a 60                	push   $0x60
  80138e:	68 03 31 80 00       	push   $0x803103
  801393:	e8 f4 ee ff ff       	call   80028c <_panic>
			panic("sys_page_map() panic\n");
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	68 5d 31 80 00       	push   $0x80315d
  8013a0:	6a 5c                	push   $0x5c
  8013a2:	68 03 31 80 00       	push   $0x803103
  8013a7:	e8 e0 ee ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013ac:	c1 e3 0c             	shl    $0xc,%ebx
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	68 05 08 00 00       	push   $0x805
  8013b7:	53                   	push   %ebx
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 55 fb ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  8013c1:	83 c4 20             	add    $0x20,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	0f 89 3e ff ff ff    	jns    80130a <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013cc:	83 ec 04             	sub    $0x4,%esp
  8013cf:	68 5d 31 80 00       	push   $0x80315d
  8013d4:	6a 67                	push   $0x67
  8013d6:	68 03 31 80 00       	push   $0x803103
  8013db:	e8 ac ee ff ff       	call   80028c <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8013e0:	c1 e3 0c             	shl    $0xc,%ebx
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	6a 05                	push   $0x5
  8013e8:	53                   	push   %ebx
  8013e9:	56                   	push   %esi
  8013ea:	53                   	push   %ebx
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 24 fb ff ff       	call   800f16 <sys_page_map>
		if(r < 0)
  8013f2:	83 c4 20             	add    $0x20,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	0f 89 0d ff ff ff    	jns    80130a <duppage+0x63>
			panic("sys_page_map() panic\n");
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	68 5d 31 80 00       	push   $0x80315d
  801405:	6a 6e                	push   $0x6e
  801407:	68 03 31 80 00       	push   $0x803103
  80140c:	e8 7b ee ff ff       	call   80028c <_panic>

00801411 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	57                   	push   %edi
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
  801417:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  80141a:	68 a8 11 80 00       	push   $0x8011a8
  80141f:	e8 d5 13 00 00       	call   8027f9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801424:	b8 07 00 00 00       	mov    $0x7,%eax
  801429:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 27                	js     801459 <fork+0x48>
  801432:	89 c6                	mov    %eax,%esi
  801434:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801436:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80143b:	75 48                	jne    801485 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  80143d:	e8 53 fa ff ff       	call   800e95 <sys_getenvid>
  801442:	25 ff 03 00 00       	and    $0x3ff,%eax
  801447:	c1 e0 07             	shl    $0x7,%eax
  80144a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80144f:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801454:	e9 90 00 00 00       	jmp    8014e9 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	68 74 31 80 00       	push   $0x803174
  801461:	68 8d 00 00 00       	push   $0x8d
  801466:	68 03 31 80 00       	push   $0x803103
  80146b:	e8 1c ee ff ff       	call   80028c <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  801470:	89 f8                	mov    %edi,%eax
  801472:	e8 30 fe ff ff       	call   8012a7 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80147d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801483:	74 26                	je     8014ab <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801485:	89 d8                	mov    %ebx,%eax
  801487:	c1 e8 16             	shr    $0x16,%eax
  80148a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801491:	a8 01                	test   $0x1,%al
  801493:	74 e2                	je     801477 <fork+0x66>
  801495:	89 da                	mov    %ebx,%edx
  801497:	c1 ea 0c             	shr    $0xc,%edx
  80149a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014a1:	83 e0 05             	and    $0x5,%eax
  8014a4:	83 f8 05             	cmp    $0x5,%eax
  8014a7:	75 ce                	jne    801477 <fork+0x66>
  8014a9:	eb c5                	jmp    801470 <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	6a 07                	push   $0x7
  8014b0:	68 00 f0 bf ee       	push   $0xeebff000
  8014b5:	56                   	push   %esi
  8014b6:	e8 18 fa ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 31                	js     8014f3 <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014c2:	83 ec 08             	sub    $0x8,%esp
  8014c5:	68 68 28 80 00       	push   $0x802868
  8014ca:	56                   	push   %esi
  8014cb:	e8 4e fb ff ff       	call   80101e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 33                	js     80150a <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	6a 02                	push   $0x2
  8014dc:	56                   	push   %esi
  8014dd:	e8 b8 fa ff ff       	call   800f9a <sys_env_set_status>
	if(ret < 0)
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 38                	js     801521 <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8014e9:	89 f0                	mov    %esi,%eax
  8014eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014ee:	5b                   	pop    %ebx
  8014ef:	5e                   	pop    %esi
  8014f0:	5f                   	pop    %edi
  8014f1:	5d                   	pop    %ebp
  8014f2:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 0e 31 80 00       	push   $0x80310e
  8014fb:	68 99 00 00 00       	push   $0x99
  801500:	68 03 31 80 00       	push   $0x803103
  801505:	e8 82 ed ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	68 98 31 80 00       	push   $0x803198
  801512:	68 9c 00 00 00       	push   $0x9c
  801517:	68 03 31 80 00       	push   $0x803103
  80151c:	e8 6b ed ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_status()\n");
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	68 c0 31 80 00       	push   $0x8031c0
  801529:	68 9f 00 00 00       	push   $0x9f
  80152e:	68 03 31 80 00       	push   $0x803103
  801533:	e8 54 ed ff ff       	call   80028c <_panic>

00801538 <sfork>:

// Challenge!
int
sfork(void)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	57                   	push   %edi
  80153c:	56                   	push   %esi
  80153d:	53                   	push   %ebx
  80153e:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801541:	68 a8 11 80 00       	push   $0x8011a8
  801546:	e8 ae 12 00 00       	call   8027f9 <set_pgfault_handler>
  80154b:	b8 07 00 00 00       	mov    $0x7,%eax
  801550:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 27                	js     801580 <sfork+0x48>
  801559:	89 c7                	mov    %eax,%edi
  80155b:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  80155d:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801562:	75 55                	jne    8015b9 <sfork+0x81>
		thisenv = &envs[ENVX(sys_getenvid())];
  801564:	e8 2c f9 ff ff       	call   800e95 <sys_getenvid>
  801569:	25 ff 03 00 00       	and    $0x3ff,%eax
  80156e:	c1 e0 07             	shl    $0x7,%eax
  801571:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801576:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80157b:	e9 d4 00 00 00       	jmp    801654 <sfork+0x11c>
		panic("the fork panic! at sys_exofork()\n");
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 74 31 80 00       	push   $0x803174
  801588:	68 b0 00 00 00       	push   $0xb0
  80158d:	68 03 31 80 00       	push   $0x803103
  801592:	e8 f5 ec ff ff       	call   80028c <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801597:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80159c:	89 f0                	mov    %esi,%eax
  80159e:	e8 04 fd ff ff       	call   8012a7 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8015a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015a9:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8015af:	77 65                	ja     801616 <sfork+0xde>
		if(i == (USTACKTOP - PGSIZE))
  8015b1:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8015b7:	74 de                	je     801597 <sfork+0x5f>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8015b9:	89 d8                	mov    %ebx,%eax
  8015bb:	c1 e8 16             	shr    $0x16,%eax
  8015be:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c5:	a8 01                	test   $0x1,%al
  8015c7:	74 da                	je     8015a3 <sfork+0x6b>
  8015c9:	89 da                	mov    %ebx,%edx
  8015cb:	c1 ea 0c             	shr    $0xc,%edx
  8015ce:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8015d5:	83 e0 05             	and    $0x5,%eax
  8015d8:	83 f8 05             	cmp    $0x5,%eax
  8015db:	75 c6                	jne    8015a3 <sfork+0x6b>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8015dd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8015e4:	c1 e2 0c             	shl    $0xc,%edx
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	83 e0 07             	and    $0x7,%eax
  8015ed:	50                   	push   %eax
  8015ee:	52                   	push   %edx
  8015ef:	56                   	push   %esi
  8015f0:	52                   	push   %edx
  8015f1:	6a 00                	push   $0x0
  8015f3:	e8 1e f9 ff ff       	call   800f16 <sys_page_map>
  8015f8:	83 c4 20             	add    $0x20,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	74 a4                	je     8015a3 <sfork+0x6b>
				panic("sys_page_map() panic\n");
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	68 5d 31 80 00       	push   $0x80315d
  801607:	68 bb 00 00 00       	push   $0xbb
  80160c:	68 03 31 80 00       	push   $0x803103
  801611:	e8 76 ec ff ff       	call   80028c <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	6a 07                	push   $0x7
  80161b:	68 00 f0 bf ee       	push   $0xeebff000
  801620:	57                   	push   %edi
  801621:	e8 ad f8 ff ff       	call   800ed3 <sys_page_alloc>
	if(ret < 0)
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 31                	js     80165e <sfork+0x126>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	68 68 28 80 00       	push   $0x802868
  801635:	57                   	push   %edi
  801636:	e8 e3 f9 ff ff       	call   80101e <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	85 c0                	test   %eax,%eax
  801640:	78 33                	js     801675 <sfork+0x13d>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801642:	83 ec 08             	sub    $0x8,%esp
  801645:	6a 02                	push   $0x2
  801647:	57                   	push   %edi
  801648:	e8 4d f9 ff ff       	call   800f9a <sys_env_set_status>
	if(ret < 0)
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 38                	js     80168c <sfork+0x154>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801654:	89 f8                	mov    %edi,%eax
  801656:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5f                   	pop    %edi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 0e 31 80 00       	push   $0x80310e
  801666:	68 c1 00 00 00       	push   $0xc1
  80166b:	68 03 31 80 00       	push   $0x803103
  801670:	e8 17 ec ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	68 98 31 80 00       	push   $0x803198
  80167d:	68 c4 00 00 00       	push   $0xc4
  801682:	68 03 31 80 00       	push   $0x803103
  801687:	e8 00 ec ff ff       	call   80028c <_panic>
		panic("panic in sys_env_set_status()\n");
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	68 c0 31 80 00       	push   $0x8031c0
  801694:	68 c7 00 00 00       	push   $0xc7
  801699:	68 03 31 80 00       	push   $0x803103
  80169e:	e8 e9 eb ff ff       	call   80028c <_panic>

008016a3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	05 00 00 00 30       	add    $0x30000000,%eax
  8016ae:	c1 e8 0c             	shr    $0xc,%eax
}
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8016be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    

008016ca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016d2:	89 c2                	mov    %eax,%edx
  8016d4:	c1 ea 16             	shr    $0x16,%edx
  8016d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016de:	f6 c2 01             	test   $0x1,%dl
  8016e1:	74 2d                	je     801710 <fd_alloc+0x46>
  8016e3:	89 c2                	mov    %eax,%edx
  8016e5:	c1 ea 0c             	shr    $0xc,%edx
  8016e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ef:	f6 c2 01             	test   $0x1,%dl
  8016f2:	74 1c                	je     801710 <fd_alloc+0x46>
  8016f4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016f9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016fe:	75 d2                	jne    8016d2 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801709:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80170e:	eb 0a                	jmp    80171a <fd_alloc+0x50>
			*fd_store = fd;
  801710:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801713:	89 01                	mov    %eax,(%ecx)
			return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801722:	83 f8 1f             	cmp    $0x1f,%eax
  801725:	77 30                	ja     801757 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801727:	c1 e0 0c             	shl    $0xc,%eax
  80172a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80172f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801735:	f6 c2 01             	test   $0x1,%dl
  801738:	74 24                	je     80175e <fd_lookup+0x42>
  80173a:	89 c2                	mov    %eax,%edx
  80173c:	c1 ea 0c             	shr    $0xc,%edx
  80173f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801746:	f6 c2 01             	test   $0x1,%dl
  801749:	74 1a                	je     801765 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	89 02                	mov    %eax,(%edx)
	return 0;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    
		return -E_INVAL;
  801757:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175c:	eb f7                	jmp    801755 <fd_lookup+0x39>
		return -E_INVAL;
  80175e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801763:	eb f0                	jmp    801755 <fd_lookup+0x39>
  801765:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80176a:	eb e9                	jmp    801755 <fd_lookup+0x39>

0080176c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 08             	sub    $0x8,%esp
  801772:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801775:	ba 00 00 00 00       	mov    $0x0,%edx
  80177a:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80177f:	39 08                	cmp    %ecx,(%eax)
  801781:	74 38                	je     8017bb <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801783:	83 c2 01             	add    $0x1,%edx
  801786:	8b 04 95 64 32 80 00 	mov    0x803264(,%edx,4),%eax
  80178d:	85 c0                	test   %eax,%eax
  80178f:	75 ee                	jne    80177f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801791:	a1 08 50 80 00       	mov    0x805008,%eax
  801796:	8b 40 48             	mov    0x48(%eax),%eax
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	51                   	push   %ecx
  80179d:	50                   	push   %eax
  80179e:	68 e8 31 80 00       	push   $0x8031e8
  8017a3:	e8 da eb ff ff       	call   800382 <cprintf>
	*dev = 0;
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
			*dev = devtab[i];
  8017bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c5:	eb f2                	jmp    8017b9 <dev_lookup+0x4d>

008017c7 <fd_close>:
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	57                   	push   %edi
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	83 ec 24             	sub    $0x24,%esp
  8017d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8017d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017da:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017e0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017e3:	50                   	push   %eax
  8017e4:	e8 33 ff ff ff       	call   80171c <fd_lookup>
  8017e9:	89 c3                	mov    %eax,%ebx
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 05                	js     8017f7 <fd_close+0x30>
	    || fd != fd2)
  8017f2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017f5:	74 16                	je     80180d <fd_close+0x46>
		return (must_exist ? r : 0);
  8017f7:	89 f8                	mov    %edi,%eax
  8017f9:	84 c0                	test   %al,%al
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	0f 44 d8             	cmove  %eax,%ebx
}
  801803:	89 d8                	mov    %ebx,%eax
  801805:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	ff 36                	pushl  (%esi)
  801816:	e8 51 ff ff ff       	call   80176c <dev_lookup>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	78 1a                	js     80183e <fd_close+0x77>
		if (dev->dev_close)
  801824:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801827:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80182a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80182f:	85 c0                	test   %eax,%eax
  801831:	74 0b                	je     80183e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801833:	83 ec 0c             	sub    $0xc,%esp
  801836:	56                   	push   %esi
  801837:	ff d0                	call   *%eax
  801839:	89 c3                	mov    %eax,%ebx
  80183b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	56                   	push   %esi
  801842:	6a 00                	push   $0x0
  801844:	e8 0f f7 ff ff       	call   800f58 <sys_page_unmap>
	return r;
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	eb b5                	jmp    801803 <fd_close+0x3c>

0080184e <close>:

int
close(int fdnum)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801854:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801857:	50                   	push   %eax
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	e8 bc fe ff ff       	call   80171c <fd_lookup>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	79 02                	jns    801869 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    
		return fd_close(fd, 1);
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	6a 01                	push   $0x1
  80186e:	ff 75 f4             	pushl  -0xc(%ebp)
  801871:	e8 51 ff ff ff       	call   8017c7 <fd_close>
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	eb ec                	jmp    801867 <close+0x19>

0080187b <close_all>:

void
close_all(void)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	53                   	push   %ebx
  80187f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801882:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	53                   	push   %ebx
  80188b:	e8 be ff ff ff       	call   80184e <close>
	for (i = 0; i < MAXFD; i++)
  801890:	83 c3 01             	add    $0x1,%ebx
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	83 fb 20             	cmp    $0x20,%ebx
  801899:	75 ec                	jne    801887 <close_all+0xc>
}
  80189b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	57                   	push   %edi
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	e8 67 fe ff ff       	call   80171c <fd_lookup>
  8018b5:	89 c3                	mov    %eax,%ebx
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	0f 88 81 00 00 00    	js     801943 <dup+0xa3>
		return r;
	close(newfdnum);
  8018c2:	83 ec 0c             	sub    $0xc,%esp
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	e8 81 ff ff ff       	call   80184e <close>

	newfd = INDEX2FD(newfdnum);
  8018cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018d0:	c1 e6 0c             	shl    $0xc,%esi
  8018d3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018d9:	83 c4 04             	add    $0x4,%esp
  8018dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018df:	e8 cf fd ff ff       	call   8016b3 <fd2data>
  8018e4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018e6:	89 34 24             	mov    %esi,(%esp)
  8018e9:	e8 c5 fd ff ff       	call   8016b3 <fd2data>
  8018ee:	83 c4 10             	add    $0x10,%esp
  8018f1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018f3:	89 d8                	mov    %ebx,%eax
  8018f5:	c1 e8 16             	shr    $0x16,%eax
  8018f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018ff:	a8 01                	test   $0x1,%al
  801901:	74 11                	je     801914 <dup+0x74>
  801903:	89 d8                	mov    %ebx,%eax
  801905:	c1 e8 0c             	shr    $0xc,%eax
  801908:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80190f:	f6 c2 01             	test   $0x1,%dl
  801912:	75 39                	jne    80194d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801917:	89 d0                	mov    %edx,%eax
  801919:	c1 e8 0c             	shr    $0xc,%eax
  80191c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	25 07 0e 00 00       	and    $0xe07,%eax
  80192b:	50                   	push   %eax
  80192c:	56                   	push   %esi
  80192d:	6a 00                	push   $0x0
  80192f:	52                   	push   %edx
  801930:	6a 00                	push   $0x0
  801932:	e8 df f5 ff ff       	call   800f16 <sys_page_map>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	83 c4 20             	add    $0x20,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 31                	js     801971 <dup+0xd1>
		goto err;

	return newfdnum;
  801940:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801943:	89 d8                	mov    %ebx,%eax
  801945:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801948:	5b                   	pop    %ebx
  801949:	5e                   	pop    %esi
  80194a:	5f                   	pop    %edi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80194d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	25 07 0e 00 00       	and    $0xe07,%eax
  80195c:	50                   	push   %eax
  80195d:	57                   	push   %edi
  80195e:	6a 00                	push   $0x0
  801960:	53                   	push   %ebx
  801961:	6a 00                	push   $0x0
  801963:	e8 ae f5 ff ff       	call   800f16 <sys_page_map>
  801968:	89 c3                	mov    %eax,%ebx
  80196a:	83 c4 20             	add    $0x20,%esp
  80196d:	85 c0                	test   %eax,%eax
  80196f:	79 a3                	jns    801914 <dup+0x74>
	sys_page_unmap(0, newfd);
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	56                   	push   %esi
  801975:	6a 00                	push   $0x0
  801977:	e8 dc f5 ff ff       	call   800f58 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80197c:	83 c4 08             	add    $0x8,%esp
  80197f:	57                   	push   %edi
  801980:	6a 00                	push   $0x0
  801982:	e8 d1 f5 ff ff       	call   800f58 <sys_page_unmap>
	return r;
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	eb b7                	jmp    801943 <dup+0xa3>

0080198c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 1c             	sub    $0x1c,%esp
  801993:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801996:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801999:	50                   	push   %eax
  80199a:	53                   	push   %ebx
  80199b:	e8 7c fd ff ff       	call   80171c <fd_lookup>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 3f                	js     8019e6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a7:	83 ec 08             	sub    $0x8,%esp
  8019aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ad:	50                   	push   %eax
  8019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b1:	ff 30                	pushl  (%eax)
  8019b3:	e8 b4 fd ff ff       	call   80176c <dev_lookup>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 27                	js     8019e6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c2:	8b 42 08             	mov    0x8(%edx),%eax
  8019c5:	83 e0 03             	and    $0x3,%eax
  8019c8:	83 f8 01             	cmp    $0x1,%eax
  8019cb:	74 1e                	je     8019eb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d0:	8b 40 08             	mov    0x8(%eax),%eax
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	74 35                	je     801a0c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	ff 75 10             	pushl  0x10(%ebp)
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	52                   	push   %edx
  8019e1:	ff d0                	call   *%eax
  8019e3:	83 c4 10             	add    $0x10,%esp
}
  8019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019eb:	a1 08 50 80 00       	mov    0x805008,%eax
  8019f0:	8b 40 48             	mov    0x48(%eax),%eax
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	53                   	push   %ebx
  8019f7:	50                   	push   %eax
  8019f8:	68 29 32 80 00       	push   $0x803229
  8019fd:	e8 80 e9 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a0a:	eb da                	jmp    8019e6 <read+0x5a>
		return -E_NOT_SUPP;
  801a0c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a11:	eb d3                	jmp    8019e6 <read+0x5a>

00801a13 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	57                   	push   %edi
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	83 ec 0c             	sub    $0xc,%esp
  801a1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a1f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a22:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a27:	39 f3                	cmp    %esi,%ebx
  801a29:	73 23                	jae    801a4e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	89 f0                	mov    %esi,%eax
  801a30:	29 d8                	sub    %ebx,%eax
  801a32:	50                   	push   %eax
  801a33:	89 d8                	mov    %ebx,%eax
  801a35:	03 45 0c             	add    0xc(%ebp),%eax
  801a38:	50                   	push   %eax
  801a39:	57                   	push   %edi
  801a3a:	e8 4d ff ff ff       	call   80198c <read>
		if (m < 0)
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 06                	js     801a4c <readn+0x39>
			return m;
		if (m == 0)
  801a46:	74 06                	je     801a4e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a48:	01 c3                	add    %eax,%ebx
  801a4a:	eb db                	jmp    801a27 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a4c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5f                   	pop    %edi
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 1c             	sub    $0x1c,%esp
  801a5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a62:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a65:	50                   	push   %eax
  801a66:	53                   	push   %ebx
  801a67:	e8 b0 fc ff ff       	call   80171c <fd_lookup>
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 3a                	js     801aad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a79:	50                   	push   %eax
  801a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7d:	ff 30                	pushl  (%eax)
  801a7f:	e8 e8 fc ff ff       	call   80176c <dev_lookup>
  801a84:	83 c4 10             	add    $0x10,%esp
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 22                	js     801aad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a92:	74 1e                	je     801ab2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a97:	8b 52 0c             	mov    0xc(%edx),%edx
  801a9a:	85 d2                	test   %edx,%edx
  801a9c:	74 35                	je     801ad3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a9e:	83 ec 04             	sub    $0x4,%esp
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	50                   	push   %eax
  801aa8:	ff d2                	call   *%edx
  801aaa:	83 c4 10             	add    $0x10,%esp
}
  801aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ab2:	a1 08 50 80 00       	mov    0x805008,%eax
  801ab7:	8b 40 48             	mov    0x48(%eax),%eax
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	53                   	push   %ebx
  801abe:	50                   	push   %eax
  801abf:	68 45 32 80 00       	push   $0x803245
  801ac4:	e8 b9 e8 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801ac9:	83 c4 10             	add    $0x10,%esp
  801acc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ad1:	eb da                	jmp    801aad <write+0x55>
		return -E_NOT_SUPP;
  801ad3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad8:	eb d3                	jmp    801aad <write+0x55>

00801ada <seek>:

int
seek(int fdnum, off_t offset)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae3:	50                   	push   %eax
  801ae4:	ff 75 08             	pushl  0x8(%ebp)
  801ae7:	e8 30 fc ff ff       	call   80171c <fd_lookup>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 0e                	js     801b01 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801afc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	53                   	push   %ebx
  801b07:	83 ec 1c             	sub    $0x1c,%esp
  801b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	53                   	push   %ebx
  801b12:	e8 05 fc ff ff       	call   80171c <fd_lookup>
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 37                	js     801b55 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b24:	50                   	push   %eax
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	ff 30                	pushl  (%eax)
  801b2a:	e8 3d fc ff ff       	call   80176c <dev_lookup>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	85 c0                	test   %eax,%eax
  801b34:	78 1f                	js     801b55 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b39:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b3d:	74 1b                	je     801b5a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b42:	8b 52 18             	mov    0x18(%edx),%edx
  801b45:	85 d2                	test   %edx,%edx
  801b47:	74 32                	je     801b7b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	50                   	push   %eax
  801b50:	ff d2                	call   *%edx
  801b52:	83 c4 10             	add    $0x10,%esp
}
  801b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b5a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b5f:	8b 40 48             	mov    0x48(%eax),%eax
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	53                   	push   %ebx
  801b66:	50                   	push   %eax
  801b67:	68 08 32 80 00       	push   $0x803208
  801b6c:	e8 11 e8 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b79:	eb da                	jmp    801b55 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b80:	eb d3                	jmp    801b55 <ftruncate+0x52>

00801b82 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
  801b89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b8f:	50                   	push   %eax
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	e8 84 fb ff ff       	call   80171c <fd_lookup>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	78 4b                	js     801bea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b9f:	83 ec 08             	sub    $0x8,%esp
  801ba2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba9:	ff 30                	pushl  (%eax)
  801bab:	e8 bc fb ff ff       	call   80176c <dev_lookup>
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 33                	js     801bea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bbe:	74 2f                	je     801bef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bc0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bc3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bca:	00 00 00 
	stat->st_isdir = 0;
  801bcd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bd4:	00 00 00 
	stat->st_dev = dev;
  801bd7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	53                   	push   %ebx
  801be1:	ff 75 f0             	pushl  -0x10(%ebp)
  801be4:	ff 50 14             	call   *0x14(%eax)
  801be7:	83 c4 10             	add    $0x10,%esp
}
  801bea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    
		return -E_NOT_SUPP;
  801bef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf4:	eb f4                	jmp    801bea <fstat+0x68>

00801bf6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	56                   	push   %esi
  801bfa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	6a 00                	push   $0x0
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	e8 22 02 00 00       	call   801e2a <open>
  801c08:	89 c3                	mov    %eax,%ebx
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	78 1b                	js     801c2c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	50                   	push   %eax
  801c18:	e8 65 ff ff ff       	call   801b82 <fstat>
  801c1d:	89 c6                	mov    %eax,%esi
	close(fd);
  801c1f:	89 1c 24             	mov    %ebx,(%esp)
  801c22:	e8 27 fc ff ff       	call   80184e <close>
	return r;
  801c27:	83 c4 10             	add    $0x10,%esp
  801c2a:	89 f3                	mov    %esi,%ebx
}
  801c2c:	89 d8                	mov    %ebx,%eax
  801c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c31:	5b                   	pop    %ebx
  801c32:	5e                   	pop    %esi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    

00801c35 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	56                   	push   %esi
  801c39:	53                   	push   %ebx
  801c3a:	89 c6                	mov    %eax,%esi
  801c3c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c3e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c45:	74 27                	je     801c6e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c47:	6a 07                	push   $0x7
  801c49:	68 00 60 80 00       	push   $0x806000
  801c4e:	56                   	push   %esi
  801c4f:	ff 35 00 50 80 00    	pushl  0x805000
  801c55:	e8 9d 0c 00 00       	call   8028f7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c5a:	83 c4 0c             	add    $0xc,%esp
  801c5d:	6a 00                	push   $0x0
  801c5f:	53                   	push   %ebx
  801c60:	6a 00                	push   $0x0
  801c62:	e8 27 0c 00 00       	call   80288e <ipc_recv>
}
  801c67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c6e:	83 ec 0c             	sub    $0xc,%esp
  801c71:	6a 01                	push   $0x1
  801c73:	e8 d7 0c 00 00       	call   80294f <ipc_find_env>
  801c78:	a3 00 50 80 00       	mov    %eax,0x805000
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	eb c5                	jmp    801c47 <fsipc+0x12>

00801c82 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c96:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca0:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca5:	e8 8b ff ff ff       	call   801c35 <fsipc>
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <devfile_flush>:
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb8:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc2:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc7:	e8 69 ff ff ff       	call   801c35 <fsipc>
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <devfile_stat>:
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801cde:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce8:	b8 05 00 00 00       	mov    $0x5,%eax
  801ced:	e8 43 ff ff ff       	call   801c35 <fsipc>
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	78 2c                	js     801d22 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	68 00 60 80 00       	push   $0x806000
  801cfe:	53                   	push   %ebx
  801cff:	e8 dd ed ff ff       	call   800ae1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d04:	a1 80 60 80 00       	mov    0x806080,%eax
  801d09:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d0f:	a1 84 60 80 00       	mov    0x806084,%eax
  801d14:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d1a:	83 c4 10             	add    $0x10,%esp
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <devfile_write>:
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	53                   	push   %ebx
  801d2b:	83 ec 08             	sub    $0x8,%esp
  801d2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	8b 40 0c             	mov    0xc(%eax),%eax
  801d37:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d3c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d42:	53                   	push   %ebx
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	68 08 60 80 00       	push   $0x806008
  801d4b:	e8 81 ef ff ff       	call   800cd1 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d50:	ba 00 00 00 00       	mov    $0x0,%edx
  801d55:	b8 04 00 00 00       	mov    $0x4,%eax
  801d5a:	e8 d6 fe ff ff       	call   801c35 <fsipc>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	85 c0                	test   %eax,%eax
  801d64:	78 0b                	js     801d71 <devfile_write+0x4a>
	assert(r <= n);
  801d66:	39 d8                	cmp    %ebx,%eax
  801d68:	77 0c                	ja     801d76 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6f:	7f 1e                	jg     801d8f <devfile_write+0x68>
}
  801d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    
	assert(r <= n);
  801d76:	68 78 32 80 00       	push   $0x803278
  801d7b:	68 7f 32 80 00       	push   $0x80327f
  801d80:	68 98 00 00 00       	push   $0x98
  801d85:	68 94 32 80 00       	push   $0x803294
  801d8a:	e8 fd e4 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801d8f:	68 9f 32 80 00       	push   $0x80329f
  801d94:	68 7f 32 80 00       	push   $0x80327f
  801d99:	68 99 00 00 00       	push   $0x99
  801d9e:	68 94 32 80 00       	push   $0x803294
  801da3:	e8 e4 e4 ff ff       	call   80028c <_panic>

00801da8 <devfile_read>:
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8b 40 0c             	mov    0xc(%eax),%eax
  801db6:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801dbb:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc6:	b8 03 00 00 00       	mov    $0x3,%eax
  801dcb:	e8 65 fe ff ff       	call   801c35 <fsipc>
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	78 1f                	js     801df5 <devfile_read+0x4d>
	assert(r <= n);
  801dd6:	39 f0                	cmp    %esi,%eax
  801dd8:	77 24                	ja     801dfe <devfile_read+0x56>
	assert(r <= PGSIZE);
  801dda:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ddf:	7f 33                	jg     801e14 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	50                   	push   %eax
  801de5:	68 00 60 80 00       	push   $0x806000
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	e8 7d ee ff ff       	call   800c6f <memmove>
	return r;
  801df2:	83 c4 10             	add    $0x10,%esp
}
  801df5:	89 d8                	mov    %ebx,%eax
  801df7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfa:	5b                   	pop    %ebx
  801dfb:	5e                   	pop    %esi
  801dfc:	5d                   	pop    %ebp
  801dfd:	c3                   	ret    
	assert(r <= n);
  801dfe:	68 78 32 80 00       	push   $0x803278
  801e03:	68 7f 32 80 00       	push   $0x80327f
  801e08:	6a 7c                	push   $0x7c
  801e0a:	68 94 32 80 00       	push   $0x803294
  801e0f:	e8 78 e4 ff ff       	call   80028c <_panic>
	assert(r <= PGSIZE);
  801e14:	68 9f 32 80 00       	push   $0x80329f
  801e19:	68 7f 32 80 00       	push   $0x80327f
  801e1e:	6a 7d                	push   $0x7d
  801e20:	68 94 32 80 00       	push   $0x803294
  801e25:	e8 62 e4 ff ff       	call   80028c <_panic>

00801e2a <open>:
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	56                   	push   %esi
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 1c             	sub    $0x1c,%esp
  801e32:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e35:	56                   	push   %esi
  801e36:	e8 6d ec ff ff       	call   800aa8 <strlen>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e43:	7f 6c                	jg     801eb1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4b:	50                   	push   %eax
  801e4c:	e8 79 f8 ff ff       	call   8016ca <fd_alloc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 3c                	js     801e96 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e5a:	83 ec 08             	sub    $0x8,%esp
  801e5d:	56                   	push   %esi
  801e5e:	68 00 60 80 00       	push   $0x806000
  801e63:	e8 79 ec ff ff       	call   800ae1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6b:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e73:	b8 01 00 00 00       	mov    $0x1,%eax
  801e78:	e8 b8 fd ff ff       	call   801c35 <fsipc>
  801e7d:	89 c3                	mov    %eax,%ebx
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	85 c0                	test   %eax,%eax
  801e84:	78 19                	js     801e9f <open+0x75>
	return fd2num(fd);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8c:	e8 12 f8 ff ff       	call   8016a3 <fd2num>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	83 c4 10             	add    $0x10,%esp
}
  801e96:	89 d8                	mov    %ebx,%eax
  801e98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    
		fd_close(fd, 0);
  801e9f:	83 ec 08             	sub    $0x8,%esp
  801ea2:	6a 00                	push   $0x0
  801ea4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea7:	e8 1b f9 ff ff       	call   8017c7 <fd_close>
		return r;
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	eb e5                	jmp    801e96 <open+0x6c>
		return -E_BAD_PATH;
  801eb1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eb6:	eb de                	jmp    801e96 <open+0x6c>

00801eb8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec8:	e8 68 fd ff ff       	call   801c35 <fsipc>
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ed5:	68 ab 32 80 00       	push   $0x8032ab
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	e8 ff eb ff ff       	call   800ae1 <strcpy>
	return 0;
}
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <devsock_close>:
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	53                   	push   %ebx
  801eed:	83 ec 10             	sub    $0x10,%esp
  801ef0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ef3:	53                   	push   %ebx
  801ef4:	e8 91 0a 00 00       	call   80298a <pageref>
  801ef9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801efc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f01:	83 f8 01             	cmp    $0x1,%eax
  801f04:	74 07                	je     801f0d <devsock_close+0x24>
}
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	ff 73 0c             	pushl  0xc(%ebx)
  801f13:	e8 b9 02 00 00       	call   8021d1 <nsipc_close>
  801f18:	89 c2                	mov    %eax,%edx
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	eb e7                	jmp    801f06 <devsock_close+0x1d>

00801f1f <devsock_write>:
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	ff 75 10             	pushl  0x10(%ebp)
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	ff 70 0c             	pushl  0xc(%eax)
  801f33:	e8 76 03 00 00       	call   8022ae <nsipc_send>
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <devsock_read>:
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	ff 75 10             	pushl  0x10(%ebp)
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	ff 70 0c             	pushl  0xc(%eax)
  801f4e:	e8 ef 02 00 00       	call   802242 <nsipc_recv>
}
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <fd2sockid>:
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f5b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	e8 b7 f7 ff ff       	call   80171c <fd_lookup>
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 10                	js     801f7c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f75:	39 08                	cmp    %ecx,(%eax)
  801f77:	75 05                	jne    801f7e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f79:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    
		return -E_NOT_SUPP;
  801f7e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f83:	eb f7                	jmp    801f7c <fd2sockid+0x27>

00801f85 <alloc_sockfd>:
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
  801f8a:	83 ec 1c             	sub    $0x1c,%esp
  801f8d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f92:	50                   	push   %eax
  801f93:	e8 32 f7 ff ff       	call   8016ca <fd_alloc>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	78 43                	js     801fe4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	68 07 04 00 00       	push   $0x407
  801fa9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fac:	6a 00                	push   $0x0
  801fae:	e8 20 ef ff ff       	call   800ed3 <sys_page_alloc>
  801fb3:	89 c3                	mov    %eax,%ebx
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 28                	js     801fe4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fc5:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fd1:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	50                   	push   %eax
  801fd8:	e8 c6 f6 ff ff       	call   8016a3 <fd2num>
  801fdd:	89 c3                	mov    %eax,%ebx
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	eb 0c                	jmp    801ff0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	56                   	push   %esi
  801fe8:	e8 e4 01 00 00       	call   8021d1 <nsipc_close>
		return r;
  801fed:	83 c4 10             	add    $0x10,%esp
}
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <accept>:
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	e8 4e ff ff ff       	call   801f55 <fd2sockid>
  802007:	85 c0                	test   %eax,%eax
  802009:	78 1b                	js     802026 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	ff 75 10             	pushl  0x10(%ebp)
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	50                   	push   %eax
  802015:	e8 0e 01 00 00       	call   802128 <nsipc_accept>
  80201a:	83 c4 10             	add    $0x10,%esp
  80201d:	85 c0                	test   %eax,%eax
  80201f:	78 05                	js     802026 <accept+0x2d>
	return alloc_sockfd(r);
  802021:	e8 5f ff ff ff       	call   801f85 <alloc_sockfd>
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <bind>:
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	e8 1f ff ff ff       	call   801f55 <fd2sockid>
  802036:	85 c0                	test   %eax,%eax
  802038:	78 12                	js     80204c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	ff 75 10             	pushl  0x10(%ebp)
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	50                   	push   %eax
  802044:	e8 31 01 00 00       	call   80217a <nsipc_bind>
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <shutdown>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	e8 f9 fe ff ff       	call   801f55 <fd2sockid>
  80205c:	85 c0                	test   %eax,%eax
  80205e:	78 0f                	js     80206f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802060:	83 ec 08             	sub    $0x8,%esp
  802063:	ff 75 0c             	pushl  0xc(%ebp)
  802066:	50                   	push   %eax
  802067:	e8 43 01 00 00       	call   8021af <nsipc_shutdown>
  80206c:	83 c4 10             	add    $0x10,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <connect>:
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	e8 d6 fe ff ff       	call   801f55 <fd2sockid>
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 12                	js     802095 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	ff 75 10             	pushl  0x10(%ebp)
  802089:	ff 75 0c             	pushl  0xc(%ebp)
  80208c:	50                   	push   %eax
  80208d:	e8 59 01 00 00       	call   8021eb <nsipc_connect>
  802092:	83 c4 10             	add    $0x10,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <listen>:
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	e8 b0 fe ff ff       	call   801f55 <fd2sockid>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 0f                	js     8020b8 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020a9:	83 ec 08             	sub    $0x8,%esp
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	50                   	push   %eax
  8020b0:	e8 6b 01 00 00       	call   802220 <nsipc_listen>
  8020b5:	83 c4 10             	add    $0x10,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <socket>:

int
socket(int domain, int type, int protocol)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020c0:	ff 75 10             	pushl  0x10(%ebp)
  8020c3:	ff 75 0c             	pushl  0xc(%ebp)
  8020c6:	ff 75 08             	pushl  0x8(%ebp)
  8020c9:	e8 3e 02 00 00       	call   80230c <nsipc_socket>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 05                	js     8020da <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020d5:	e8 ab fe ff ff       	call   801f85 <alloc_sockfd>
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020e5:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020ec:	74 26                	je     802114 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020ee:	6a 07                	push   $0x7
  8020f0:	68 00 70 80 00       	push   $0x807000
  8020f5:	53                   	push   %ebx
  8020f6:	ff 35 04 50 80 00    	pushl  0x805004
  8020fc:	e8 f6 07 00 00       	call   8028f7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802101:	83 c4 0c             	add    $0xc,%esp
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	e8 7f 07 00 00       	call   80288e <ipc_recv>
}
  80210f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802112:	c9                   	leave  
  802113:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	6a 02                	push   $0x2
  802119:	e8 31 08 00 00       	call   80294f <ipc_find_env>
  80211e:	a3 04 50 80 00       	mov    %eax,0x805004
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	eb c6                	jmp    8020ee <nsipc+0x12>

00802128 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	56                   	push   %esi
  80212c:	53                   	push   %ebx
  80212d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802138:	8b 06                	mov    (%esi),%eax
  80213a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80213f:	b8 01 00 00 00       	mov    $0x1,%eax
  802144:	e8 93 ff ff ff       	call   8020dc <nsipc>
  802149:	89 c3                	mov    %eax,%ebx
  80214b:	85 c0                	test   %eax,%eax
  80214d:	79 09                	jns    802158 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80214f:	89 d8                	mov    %ebx,%eax
  802151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	ff 35 10 70 80 00    	pushl  0x807010
  802161:	68 00 70 80 00       	push   $0x807000
  802166:	ff 75 0c             	pushl  0xc(%ebp)
  802169:	e8 01 eb ff ff       	call   800c6f <memmove>
		*addrlen = ret->ret_addrlen;
  80216e:	a1 10 70 80 00       	mov    0x807010,%eax
  802173:	89 06                	mov    %eax,(%esi)
  802175:	83 c4 10             	add    $0x10,%esp
	return r;
  802178:	eb d5                	jmp    80214f <nsipc_accept+0x27>

0080217a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80218c:	53                   	push   %ebx
  80218d:	ff 75 0c             	pushl  0xc(%ebp)
  802190:	68 04 70 80 00       	push   $0x807004
  802195:	e8 d5 ea ff ff       	call   800c6f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80219a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8021a5:	e8 32 ff ff ff       	call   8020dc <nsipc>
}
  8021aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8021ca:	e8 0d ff ff ff       	call   8020dc <nsipc>
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <nsipc_close>:

int
nsipc_close(int s)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021df:	b8 04 00 00 00       	mov    $0x4,%eax
  8021e4:	e8 f3 fe ff ff       	call   8020dc <nsipc>
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 08             	sub    $0x8,%esp
  8021f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021fd:	53                   	push   %ebx
  8021fe:	ff 75 0c             	pushl  0xc(%ebp)
  802201:	68 04 70 80 00       	push   $0x807004
  802206:	e8 64 ea ff ff       	call   800c6f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80220b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802211:	b8 05 00 00 00       	mov    $0x5,%eax
  802216:	e8 c1 fe ff ff       	call   8020dc <nsipc>
}
  80221b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802236:	b8 06 00 00 00       	mov    $0x6,%eax
  80223b:	e8 9c fe ff ff       	call   8020dc <nsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	56                   	push   %esi
  802246:	53                   	push   %ebx
  802247:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802252:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802258:	8b 45 14             	mov    0x14(%ebp),%eax
  80225b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802260:	b8 07 00 00 00       	mov    $0x7,%eax
  802265:	e8 72 fe ff ff       	call   8020dc <nsipc>
  80226a:	89 c3                	mov    %eax,%ebx
  80226c:	85 c0                	test   %eax,%eax
  80226e:	78 1f                	js     80228f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802270:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802275:	7f 21                	jg     802298 <nsipc_recv+0x56>
  802277:	39 c6                	cmp    %eax,%esi
  802279:	7c 1d                	jl     802298 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	50                   	push   %eax
  80227f:	68 00 70 80 00       	push   $0x807000
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	e8 e3 e9 ff ff       	call   800c6f <memmove>
  80228c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80228f:	89 d8                	mov    %ebx,%eax
  802291:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5d                   	pop    %ebp
  802297:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802298:	68 b7 32 80 00       	push   $0x8032b7
  80229d:	68 7f 32 80 00       	push   $0x80327f
  8022a2:	6a 62                	push   $0x62
  8022a4:	68 cc 32 80 00       	push   $0x8032cc
  8022a9:	e8 de df ff ff       	call   80028c <_panic>

008022ae <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	53                   	push   %ebx
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022c0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022c6:	7f 2e                	jg     8022f6 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	53                   	push   %ebx
  8022cc:	ff 75 0c             	pushl  0xc(%ebp)
  8022cf:	68 0c 70 80 00       	push   $0x80700c
  8022d4:	e8 96 e9 ff ff       	call   800c6f <memmove>
	nsipcbuf.send.req_size = size;
  8022d9:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022df:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e2:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8022ec:	e8 eb fd ff ff       	call   8020dc <nsipc>
}
  8022f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    
	assert(size < 1600);
  8022f6:	68 d8 32 80 00       	push   $0x8032d8
  8022fb:	68 7f 32 80 00       	push   $0x80327f
  802300:	6a 6d                	push   $0x6d
  802302:	68 cc 32 80 00       	push   $0x8032cc
  802307:	e8 80 df ff ff       	call   80028c <_panic>

0080230c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802322:	8b 45 10             	mov    0x10(%ebp),%eax
  802325:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80232a:	b8 09 00 00 00       	mov    $0x9,%eax
  80232f:	e8 a8 fd ff ff       	call   8020dc <nsipc>
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	56                   	push   %esi
  80233a:	53                   	push   %ebx
  80233b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80233e:	83 ec 0c             	sub    $0xc,%esp
  802341:	ff 75 08             	pushl  0x8(%ebp)
  802344:	e8 6a f3 ff ff       	call   8016b3 <fd2data>
  802349:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80234b:	83 c4 08             	add    $0x8,%esp
  80234e:	68 e4 32 80 00       	push   $0x8032e4
  802353:	53                   	push   %ebx
  802354:	e8 88 e7 ff ff       	call   800ae1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802359:	8b 46 04             	mov    0x4(%esi),%eax
  80235c:	2b 06                	sub    (%esi),%eax
  80235e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802364:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80236b:	00 00 00 
	stat->st_dev = &devpipe;
  80236e:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802375:	40 80 00 
	return 0;
}
  802378:	b8 00 00 00 00       	mov    $0x0,%eax
  80237d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	53                   	push   %ebx
  802388:	83 ec 0c             	sub    $0xc,%esp
  80238b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80238e:	53                   	push   %ebx
  80238f:	6a 00                	push   $0x0
  802391:	e8 c2 eb ff ff       	call   800f58 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802396:	89 1c 24             	mov    %ebx,(%esp)
  802399:	e8 15 f3 ff ff       	call   8016b3 <fd2data>
  80239e:	83 c4 08             	add    $0x8,%esp
  8023a1:	50                   	push   %eax
  8023a2:	6a 00                	push   $0x0
  8023a4:	e8 af eb ff ff       	call   800f58 <sys_page_unmap>
}
  8023a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <_pipeisclosed>:
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	89 c7                	mov    %eax,%edi
  8023b9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023bb:	a1 08 50 80 00       	mov    0x805008,%eax
  8023c0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	57                   	push   %edi
  8023c7:	e8 be 05 00 00       	call   80298a <pageref>
  8023cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023cf:	89 34 24             	mov    %esi,(%esp)
  8023d2:	e8 b3 05 00 00       	call   80298a <pageref>
		nn = thisenv->env_runs;
  8023d7:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023dd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023e0:	83 c4 10             	add    $0x10,%esp
  8023e3:	39 cb                	cmp    %ecx,%ebx
  8023e5:	74 1b                	je     802402 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023e7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023ea:	75 cf                	jne    8023bb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023ec:	8b 42 58             	mov    0x58(%edx),%eax
  8023ef:	6a 01                	push   $0x1
  8023f1:	50                   	push   %eax
  8023f2:	53                   	push   %ebx
  8023f3:	68 eb 32 80 00       	push   $0x8032eb
  8023f8:	e8 85 df ff ff       	call   800382 <cprintf>
  8023fd:	83 c4 10             	add    $0x10,%esp
  802400:	eb b9                	jmp    8023bb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802402:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802405:	0f 94 c0             	sete   %al
  802408:	0f b6 c0             	movzbl %al,%eax
}
  80240b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240e:	5b                   	pop    %ebx
  80240f:	5e                   	pop    %esi
  802410:	5f                   	pop    %edi
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    

00802413 <devpipe_write>:
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	57                   	push   %edi
  802417:	56                   	push   %esi
  802418:	53                   	push   %ebx
  802419:	83 ec 28             	sub    $0x28,%esp
  80241c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80241f:	56                   	push   %esi
  802420:	e8 8e f2 ff ff       	call   8016b3 <fd2data>
  802425:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	bf 00 00 00 00       	mov    $0x0,%edi
  80242f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802432:	74 4f                	je     802483 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802434:	8b 43 04             	mov    0x4(%ebx),%eax
  802437:	8b 0b                	mov    (%ebx),%ecx
  802439:	8d 51 20             	lea    0x20(%ecx),%edx
  80243c:	39 d0                	cmp    %edx,%eax
  80243e:	72 14                	jb     802454 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802440:	89 da                	mov    %ebx,%edx
  802442:	89 f0                	mov    %esi,%eax
  802444:	e8 65 ff ff ff       	call   8023ae <_pipeisclosed>
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 3b                	jne    802488 <devpipe_write+0x75>
			sys_yield();
  80244d:	e8 62 ea ff ff       	call   800eb4 <sys_yield>
  802452:	eb e0                	jmp    802434 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802454:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802457:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80245b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80245e:	89 c2                	mov    %eax,%edx
  802460:	c1 fa 1f             	sar    $0x1f,%edx
  802463:	89 d1                	mov    %edx,%ecx
  802465:	c1 e9 1b             	shr    $0x1b,%ecx
  802468:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80246b:	83 e2 1f             	and    $0x1f,%edx
  80246e:	29 ca                	sub    %ecx,%edx
  802470:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802474:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802478:	83 c0 01             	add    $0x1,%eax
  80247b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80247e:	83 c7 01             	add    $0x1,%edi
  802481:	eb ac                	jmp    80242f <devpipe_write+0x1c>
	return i;
  802483:	8b 45 10             	mov    0x10(%ebp),%eax
  802486:	eb 05                	jmp    80248d <devpipe_write+0x7a>
				return 0;
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802490:	5b                   	pop    %ebx
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    

00802495 <devpipe_read>:
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	57                   	push   %edi
  802499:	56                   	push   %esi
  80249a:	53                   	push   %ebx
  80249b:	83 ec 18             	sub    $0x18,%esp
  80249e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024a1:	57                   	push   %edi
  8024a2:	e8 0c f2 ff ff       	call   8016b3 <fd2data>
  8024a7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	be 00 00 00 00       	mov    $0x0,%esi
  8024b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b4:	75 14                	jne    8024ca <devpipe_read+0x35>
	return i;
  8024b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b9:	eb 02                	jmp    8024bd <devpipe_read+0x28>
				return i;
  8024bb:	89 f0                	mov    %esi,%eax
}
  8024bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
			sys_yield();
  8024c5:	e8 ea e9 ff ff       	call   800eb4 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024ca:	8b 03                	mov    (%ebx),%eax
  8024cc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024cf:	75 18                	jne    8024e9 <devpipe_read+0x54>
			if (i > 0)
  8024d1:	85 f6                	test   %esi,%esi
  8024d3:	75 e6                	jne    8024bb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024d5:	89 da                	mov    %ebx,%edx
  8024d7:	89 f8                	mov    %edi,%eax
  8024d9:	e8 d0 fe ff ff       	call   8023ae <_pipeisclosed>
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	74 e3                	je     8024c5 <devpipe_read+0x30>
				return 0;
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	eb d4                	jmp    8024bd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024e9:	99                   	cltd   
  8024ea:	c1 ea 1b             	shr    $0x1b,%edx
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	83 e0 1f             	and    $0x1f,%eax
  8024f2:	29 d0                	sub    %edx,%eax
  8024f4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024fc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024ff:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802502:	83 c6 01             	add    $0x1,%esi
  802505:	eb aa                	jmp    8024b1 <devpipe_read+0x1c>

00802507 <pipe>:
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	56                   	push   %esi
  80250b:	53                   	push   %ebx
  80250c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80250f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802512:	50                   	push   %eax
  802513:	e8 b2 f1 ff ff       	call   8016ca <fd_alloc>
  802518:	89 c3                	mov    %eax,%ebx
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	85 c0                	test   %eax,%eax
  80251f:	0f 88 23 01 00 00    	js     802648 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	68 07 04 00 00       	push   $0x407
  80252d:	ff 75 f4             	pushl  -0xc(%ebp)
  802530:	6a 00                	push   $0x0
  802532:	e8 9c e9 ff ff       	call   800ed3 <sys_page_alloc>
  802537:	89 c3                	mov    %eax,%ebx
  802539:	83 c4 10             	add    $0x10,%esp
  80253c:	85 c0                	test   %eax,%eax
  80253e:	0f 88 04 01 00 00    	js     802648 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802544:	83 ec 0c             	sub    $0xc,%esp
  802547:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80254a:	50                   	push   %eax
  80254b:	e8 7a f1 ff ff       	call   8016ca <fd_alloc>
  802550:	89 c3                	mov    %eax,%ebx
  802552:	83 c4 10             	add    $0x10,%esp
  802555:	85 c0                	test   %eax,%eax
  802557:	0f 88 db 00 00 00    	js     802638 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 07 04 00 00       	push   $0x407
  802565:	ff 75 f0             	pushl  -0x10(%ebp)
  802568:	6a 00                	push   $0x0
  80256a:	e8 64 e9 ff ff       	call   800ed3 <sys_page_alloc>
  80256f:	89 c3                	mov    %eax,%ebx
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	85 c0                	test   %eax,%eax
  802576:	0f 88 bc 00 00 00    	js     802638 <pipe+0x131>
	va = fd2data(fd0);
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	ff 75 f4             	pushl  -0xc(%ebp)
  802582:	e8 2c f1 ff ff       	call   8016b3 <fd2data>
  802587:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802589:	83 c4 0c             	add    $0xc,%esp
  80258c:	68 07 04 00 00       	push   $0x407
  802591:	50                   	push   %eax
  802592:	6a 00                	push   $0x0
  802594:	e8 3a e9 ff ff       	call   800ed3 <sys_page_alloc>
  802599:	89 c3                	mov    %eax,%ebx
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	0f 88 82 00 00 00    	js     802628 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a6:	83 ec 0c             	sub    $0xc,%esp
  8025a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8025ac:	e8 02 f1 ff ff       	call   8016b3 <fd2data>
  8025b1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025b8:	50                   	push   %eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	56                   	push   %esi
  8025bc:	6a 00                	push   $0x0
  8025be:	e8 53 e9 ff ff       	call   800f16 <sys_page_map>
  8025c3:	89 c3                	mov    %eax,%ebx
  8025c5:	83 c4 20             	add    $0x20,%esp
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	78 4e                	js     80261a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025cc:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d4:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d9:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025ef:	83 ec 0c             	sub    $0xc,%esp
  8025f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f5:	e8 a9 f0 ff ff       	call   8016a3 <fd2num>
  8025fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ff:	83 c4 04             	add    $0x4,%esp
  802602:	ff 75 f0             	pushl  -0x10(%ebp)
  802605:	e8 99 f0 ff ff       	call   8016a3 <fd2num>
  80260a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	bb 00 00 00 00       	mov    $0x0,%ebx
  802618:	eb 2e                	jmp    802648 <pipe+0x141>
	sys_page_unmap(0, va);
  80261a:	83 ec 08             	sub    $0x8,%esp
  80261d:	56                   	push   %esi
  80261e:	6a 00                	push   $0x0
  802620:	e8 33 e9 ff ff       	call   800f58 <sys_page_unmap>
  802625:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802628:	83 ec 08             	sub    $0x8,%esp
  80262b:	ff 75 f0             	pushl  -0x10(%ebp)
  80262e:	6a 00                	push   $0x0
  802630:	e8 23 e9 ff ff       	call   800f58 <sys_page_unmap>
  802635:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802638:	83 ec 08             	sub    $0x8,%esp
  80263b:	ff 75 f4             	pushl  -0xc(%ebp)
  80263e:	6a 00                	push   $0x0
  802640:	e8 13 e9 ff ff       	call   800f58 <sys_page_unmap>
  802645:	83 c4 10             	add    $0x10,%esp
}
  802648:	89 d8                	mov    %ebx,%eax
  80264a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80264d:	5b                   	pop    %ebx
  80264e:	5e                   	pop    %esi
  80264f:	5d                   	pop    %ebp
  802650:	c3                   	ret    

00802651 <pipeisclosed>:
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802657:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265a:	50                   	push   %eax
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	e8 b9 f0 ff ff       	call   80171c <fd_lookup>
  802663:	83 c4 10             	add    $0x10,%esp
  802666:	85 c0                	test   %eax,%eax
  802668:	78 18                	js     802682 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	ff 75 f4             	pushl  -0xc(%ebp)
  802670:	e8 3e f0 ff ff       	call   8016b3 <fd2data>
	return _pipeisclosed(fd, p);
  802675:	89 c2                	mov    %eax,%edx
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	e8 2f fd ff ff       	call   8023ae <_pipeisclosed>
  80267f:	83 c4 10             	add    $0x10,%esp
}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802684:	b8 00 00 00 00       	mov    $0x0,%eax
  802689:	c3                   	ret    

0080268a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802690:	68 03 33 80 00       	push   $0x803303
  802695:	ff 75 0c             	pushl  0xc(%ebp)
  802698:	e8 44 e4 ff ff       	call   800ae1 <strcpy>
	return 0;
}
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <devcons_write>:
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	57                   	push   %edi
  8026a8:	56                   	push   %esi
  8026a9:	53                   	push   %ebx
  8026aa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026b0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026b5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026bb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026be:	73 31                	jae    8026f1 <devcons_write+0x4d>
		m = n - tot;
  8026c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026c3:	29 f3                	sub    %esi,%ebx
  8026c5:	83 fb 7f             	cmp    $0x7f,%ebx
  8026c8:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026cd:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	53                   	push   %ebx
  8026d4:	89 f0                	mov    %esi,%eax
  8026d6:	03 45 0c             	add    0xc(%ebp),%eax
  8026d9:	50                   	push   %eax
  8026da:	57                   	push   %edi
  8026db:	e8 8f e5 ff ff       	call   800c6f <memmove>
		sys_cputs(buf, m);
  8026e0:	83 c4 08             	add    $0x8,%esp
  8026e3:	53                   	push   %ebx
  8026e4:	57                   	push   %edi
  8026e5:	e8 2d e7 ff ff       	call   800e17 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026ea:	01 de                	add    %ebx,%esi
  8026ec:	83 c4 10             	add    $0x10,%esp
  8026ef:	eb ca                	jmp    8026bb <devcons_write+0x17>
}
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f6:	5b                   	pop    %ebx
  8026f7:	5e                   	pop    %esi
  8026f8:	5f                   	pop    %edi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    

008026fb <devcons_read>:
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 08             	sub    $0x8,%esp
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802706:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80270a:	74 21                	je     80272d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80270c:	e8 24 e7 ff ff       	call   800e35 <sys_cgetc>
  802711:	85 c0                	test   %eax,%eax
  802713:	75 07                	jne    80271c <devcons_read+0x21>
		sys_yield();
  802715:	e8 9a e7 ff ff       	call   800eb4 <sys_yield>
  80271a:	eb f0                	jmp    80270c <devcons_read+0x11>
	if (c < 0)
  80271c:	78 0f                	js     80272d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80271e:	83 f8 04             	cmp    $0x4,%eax
  802721:	74 0c                	je     80272f <devcons_read+0x34>
	*(char*)vbuf = c;
  802723:	8b 55 0c             	mov    0xc(%ebp),%edx
  802726:	88 02                	mov    %al,(%edx)
	return 1;
  802728:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    
		return 0;
  80272f:	b8 00 00 00 00       	mov    $0x0,%eax
  802734:	eb f7                	jmp    80272d <devcons_read+0x32>

00802736 <cputchar>:
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802742:	6a 01                	push   $0x1
  802744:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802747:	50                   	push   %eax
  802748:	e8 ca e6 ff ff       	call   800e17 <sys_cputs>
}
  80274d:	83 c4 10             	add    $0x10,%esp
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <getchar>:
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802758:	6a 01                	push   $0x1
  80275a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80275d:	50                   	push   %eax
  80275e:	6a 00                	push   $0x0
  802760:	e8 27 f2 ff ff       	call   80198c <read>
	if (r < 0)
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	85 c0                	test   %eax,%eax
  80276a:	78 06                	js     802772 <getchar+0x20>
	if (r < 1)
  80276c:	74 06                	je     802774 <getchar+0x22>
	return c;
  80276e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802772:	c9                   	leave  
  802773:	c3                   	ret    
		return -E_EOF;
  802774:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802779:	eb f7                	jmp    802772 <getchar+0x20>

0080277b <iscons>:
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
  80277e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802784:	50                   	push   %eax
  802785:	ff 75 08             	pushl  0x8(%ebp)
  802788:	e8 8f ef ff ff       	call   80171c <fd_lookup>
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	85 c0                	test   %eax,%eax
  802792:	78 11                	js     8027a5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80279d:	39 10                	cmp    %edx,(%eax)
  80279f:	0f 94 c0             	sete   %al
  8027a2:	0f b6 c0             	movzbl %al,%eax
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <opencons>:
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b0:	50                   	push   %eax
  8027b1:	e8 14 ef ff ff       	call   8016ca <fd_alloc>
  8027b6:	83 c4 10             	add    $0x10,%esp
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	78 3a                	js     8027f7 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 07 04 00 00       	push   $0x407
  8027c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8027c8:	6a 00                	push   $0x0
  8027ca:	e8 04 e7 ff ff       	call   800ed3 <sys_page_alloc>
  8027cf:	83 c4 10             	add    $0x10,%esp
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	78 21                	js     8027f7 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027df:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	50                   	push   %eax
  8027ef:	e8 af ee ff ff       	call   8016a3 <fd2num>
  8027f4:	83 c4 10             	add    $0x10,%esp
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027ff:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802806:	74 0a                	je     802812 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802810:	c9                   	leave  
  802811:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802812:	83 ec 04             	sub    $0x4,%esp
  802815:	6a 07                	push   $0x7
  802817:	68 00 f0 bf ee       	push   $0xeebff000
  80281c:	6a 00                	push   $0x0
  80281e:	e8 b0 e6 ff ff       	call   800ed3 <sys_page_alloc>
		if(r < 0)
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	85 c0                	test   %eax,%eax
  802828:	78 2a                	js     802854 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80282a:	83 ec 08             	sub    $0x8,%esp
  80282d:	68 68 28 80 00       	push   $0x802868
  802832:	6a 00                	push   $0x0
  802834:	e8 e5 e7 ff ff       	call   80101e <sys_env_set_pgfault_upcall>
		if(r < 0)
  802839:	83 c4 10             	add    $0x10,%esp
  80283c:	85 c0                	test   %eax,%eax
  80283e:	79 c8                	jns    802808 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 40 33 80 00       	push   $0x803340
  802848:	6a 25                	push   $0x25
  80284a:	68 7c 33 80 00       	push   $0x80337c
  80284f:	e8 38 da ff ff       	call   80028c <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	68 10 33 80 00       	push   $0x803310
  80285c:	6a 22                	push   $0x22
  80285e:	68 7c 33 80 00       	push   $0x80337c
  802863:	e8 24 da ff ff       	call   80028c <_panic>

00802868 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802868:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802869:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80286e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802870:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  802873:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  802877:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80287b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80287e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  802880:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  802884:	83 c4 08             	add    $0x8,%esp
	popal
  802887:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802888:	83 c4 04             	add    $0x4,%esp
	popfl
  80288b:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80288c:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80288d:	c3                   	ret    

0080288e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80288e:	55                   	push   %ebp
  80288f:	89 e5                	mov    %esp,%ebp
  802891:	56                   	push   %esi
  802892:	53                   	push   %ebx
  802893:	8b 75 08             	mov    0x8(%ebp),%esi
  802896:	8b 45 0c             	mov    0xc(%ebp),%eax
  802899:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80289c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80289e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028a3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8028a6:	83 ec 0c             	sub    $0xc,%esp
  8028a9:	50                   	push   %eax
  8028aa:	e8 d4 e7 ff ff       	call   801083 <sys_ipc_recv>
	if(ret < 0){
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 2b                	js     8028e1 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8028b6:	85 f6                	test   %esi,%esi
  8028b8:	74 0a                	je     8028c4 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8028ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8028bf:	8b 40 74             	mov    0x74(%eax),%eax
  8028c2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8028c4:	85 db                	test   %ebx,%ebx
  8028c6:	74 0a                	je     8028d2 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8028c8:	a1 08 50 80 00       	mov    0x805008,%eax
  8028cd:	8b 40 78             	mov    0x78(%eax),%eax
  8028d0:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8028d2:	a1 08 50 80 00       	mov    0x805008,%eax
  8028d7:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028dd:	5b                   	pop    %ebx
  8028de:	5e                   	pop    %esi
  8028df:	5d                   	pop    %ebp
  8028e0:	c3                   	ret    
		if(from_env_store)
  8028e1:	85 f6                	test   %esi,%esi
  8028e3:	74 06                	je     8028eb <ipc_recv+0x5d>
			*from_env_store = 0;
  8028e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8028eb:	85 db                	test   %ebx,%ebx
  8028ed:	74 eb                	je     8028da <ipc_recv+0x4c>
			*perm_store = 0;
  8028ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028f5:	eb e3                	jmp    8028da <ipc_recv+0x4c>

008028f7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	57                   	push   %edi
  8028fb:	56                   	push   %esi
  8028fc:	53                   	push   %ebx
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	8b 7d 08             	mov    0x8(%ebp),%edi
  802903:	8b 75 0c             	mov    0xc(%ebp),%esi
  802906:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802909:	85 db                	test   %ebx,%ebx
  80290b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802910:	0f 44 d8             	cmove  %eax,%ebx
  802913:	eb 05                	jmp    80291a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802915:	e8 9a e5 ff ff       	call   800eb4 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80291a:	ff 75 14             	pushl  0x14(%ebp)
  80291d:	53                   	push   %ebx
  80291e:	56                   	push   %esi
  80291f:	57                   	push   %edi
  802920:	e8 3b e7 ff ff       	call   801060 <sys_ipc_try_send>
  802925:	83 c4 10             	add    $0x10,%esp
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 1b                	je     802947 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80292c:	79 e7                	jns    802915 <ipc_send+0x1e>
  80292e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802931:	74 e2                	je     802915 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	68 8a 33 80 00       	push   $0x80338a
  80293b:	6a 48                	push   $0x48
  80293d:	68 9f 33 80 00       	push   $0x80339f
  802942:	e8 45 d9 ff ff       	call   80028c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802947:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80294a:	5b                   	pop    %ebx
  80294b:	5e                   	pop    %esi
  80294c:	5f                   	pop    %edi
  80294d:	5d                   	pop    %ebp
  80294e:	c3                   	ret    

0080294f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80294f:	55                   	push   %ebp
  802950:	89 e5                	mov    %esp,%ebp
  802952:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802955:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80295a:	89 c2                	mov    %eax,%edx
  80295c:	c1 e2 07             	shl    $0x7,%edx
  80295f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802965:	8b 52 50             	mov    0x50(%edx),%edx
  802968:	39 ca                	cmp    %ecx,%edx
  80296a:	74 11                	je     80297d <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80296c:	83 c0 01             	add    $0x1,%eax
  80296f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802974:	75 e4                	jne    80295a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	eb 0b                	jmp    802988 <ipc_find_env+0x39>
			return envs[i].env_id;
  80297d:	c1 e0 07             	shl    $0x7,%eax
  802980:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802985:	8b 40 48             	mov    0x48(%eax),%eax
}
  802988:	5d                   	pop    %ebp
  802989:	c3                   	ret    

0080298a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802990:	89 d0                	mov    %edx,%eax
  802992:	c1 e8 16             	shr    $0x16,%eax
  802995:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80299c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8029a1:	f6 c1 01             	test   $0x1,%cl
  8029a4:	74 1d                	je     8029c3 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8029a6:	c1 ea 0c             	shr    $0xc,%edx
  8029a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029b0:	f6 c2 01             	test   $0x1,%dl
  8029b3:	74 0e                	je     8029c3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029b5:	c1 ea 0c             	shr    $0xc,%edx
  8029b8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029bf:	ef 
  8029c0:	0f b7 c0             	movzwl %ax,%eax
}
  8029c3:	5d                   	pop    %ebp
  8029c4:	c3                   	ret    
  8029c5:	66 90                	xchg   %ax,%ax
  8029c7:	66 90                	xchg   %ax,%ax
  8029c9:	66 90                	xchg   %ax,%ax
  8029cb:	66 90                	xchg   %ax,%ax
  8029cd:	66 90                	xchg   %ax,%ax
  8029cf:	90                   	nop

008029d0 <__udivdi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	53                   	push   %ebx
  8029d4:	83 ec 1c             	sub    $0x1c,%esp
  8029d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029e7:	85 d2                	test   %edx,%edx
  8029e9:	75 4d                	jne    802a38 <__udivdi3+0x68>
  8029eb:	39 f3                	cmp    %esi,%ebx
  8029ed:	76 19                	jbe    802a08 <__udivdi3+0x38>
  8029ef:	31 ff                	xor    %edi,%edi
  8029f1:	89 e8                	mov    %ebp,%eax
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	f7 f3                	div    %ebx
  8029f7:	89 fa                	mov    %edi,%edx
  8029f9:	83 c4 1c             	add    $0x1c,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5e                   	pop    %esi
  8029fe:	5f                   	pop    %edi
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 d9                	mov    %ebx,%ecx
  802a0a:	85 db                	test   %ebx,%ebx
  802a0c:	75 0b                	jne    802a19 <__udivdi3+0x49>
  802a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a13:	31 d2                	xor    %edx,%edx
  802a15:	f7 f3                	div    %ebx
  802a17:	89 c1                	mov    %eax,%ecx
  802a19:	31 d2                	xor    %edx,%edx
  802a1b:	89 f0                	mov    %esi,%eax
  802a1d:	f7 f1                	div    %ecx
  802a1f:	89 c6                	mov    %eax,%esi
  802a21:	89 e8                	mov    %ebp,%eax
  802a23:	89 f7                	mov    %esi,%edi
  802a25:	f7 f1                	div    %ecx
  802a27:	89 fa                	mov    %edi,%edx
  802a29:	83 c4 1c             	add    $0x1c,%esp
  802a2c:	5b                   	pop    %ebx
  802a2d:	5e                   	pop    %esi
  802a2e:	5f                   	pop    %edi
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	39 f2                	cmp    %esi,%edx
  802a3a:	77 1c                	ja     802a58 <__udivdi3+0x88>
  802a3c:	0f bd fa             	bsr    %edx,%edi
  802a3f:	83 f7 1f             	xor    $0x1f,%edi
  802a42:	75 2c                	jne    802a70 <__udivdi3+0xa0>
  802a44:	39 f2                	cmp    %esi,%edx
  802a46:	72 06                	jb     802a4e <__udivdi3+0x7e>
  802a48:	31 c0                	xor    %eax,%eax
  802a4a:	39 eb                	cmp    %ebp,%ebx
  802a4c:	77 a9                	ja     8029f7 <__udivdi3+0x27>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	eb a2                	jmp    8029f7 <__udivdi3+0x27>
  802a55:	8d 76 00             	lea    0x0(%esi),%esi
  802a58:	31 ff                	xor    %edi,%edi
  802a5a:	31 c0                	xor    %eax,%eax
  802a5c:	89 fa                	mov    %edi,%edx
  802a5e:	83 c4 1c             	add    $0x1c,%esp
  802a61:	5b                   	pop    %ebx
  802a62:	5e                   	pop    %esi
  802a63:	5f                   	pop    %edi
  802a64:	5d                   	pop    %ebp
  802a65:	c3                   	ret    
  802a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	b8 20 00 00 00       	mov    $0x20,%eax
  802a77:	29 f8                	sub    %edi,%eax
  802a79:	d3 e2                	shl    %cl,%edx
  802a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	89 da                	mov    %ebx,%edx
  802a83:	d3 ea                	shr    %cl,%edx
  802a85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a89:	09 d1                	or     %edx,%ecx
  802a8b:	89 f2                	mov    %esi,%edx
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 f9                	mov    %edi,%ecx
  802a93:	d3 e3                	shl    %cl,%ebx
  802a95:	89 c1                	mov    %eax,%ecx
  802a97:	d3 ea                	shr    %cl,%edx
  802a99:	89 f9                	mov    %edi,%ecx
  802a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a9f:	89 eb                	mov    %ebp,%ebx
  802aa1:	d3 e6                	shl    %cl,%esi
  802aa3:	89 c1                	mov    %eax,%ecx
  802aa5:	d3 eb                	shr    %cl,%ebx
  802aa7:	09 de                	or     %ebx,%esi
  802aa9:	89 f0                	mov    %esi,%eax
  802aab:	f7 74 24 08          	divl   0x8(%esp)
  802aaf:	89 d6                	mov    %edx,%esi
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	f7 64 24 0c          	mull   0xc(%esp)
  802ab7:	39 d6                	cmp    %edx,%esi
  802ab9:	72 15                	jb     802ad0 <__udivdi3+0x100>
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e5                	shl    %cl,%ebp
  802abf:	39 c5                	cmp    %eax,%ebp
  802ac1:	73 04                	jae    802ac7 <__udivdi3+0xf7>
  802ac3:	39 d6                	cmp    %edx,%esi
  802ac5:	74 09                	je     802ad0 <__udivdi3+0x100>
  802ac7:	89 d8                	mov    %ebx,%eax
  802ac9:	31 ff                	xor    %edi,%edi
  802acb:	e9 27 ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ad3:	31 ff                	xor    %edi,%edi
  802ad5:	e9 1d ff ff ff       	jmp    8029f7 <__udivdi3+0x27>
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	53                   	push   %ebx
  802ae4:	83 ec 1c             	sub    $0x1c,%esp
  802ae7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802af3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802af7:	89 da                	mov    %ebx,%edx
  802af9:	85 c0                	test   %eax,%eax
  802afb:	75 43                	jne    802b40 <__umoddi3+0x60>
  802afd:	39 df                	cmp    %ebx,%edi
  802aff:	76 17                	jbe    802b18 <__umoddi3+0x38>
  802b01:	89 f0                	mov    %esi,%eax
  802b03:	f7 f7                	div    %edi
  802b05:	89 d0                	mov    %edx,%eax
  802b07:	31 d2                	xor    %edx,%edx
  802b09:	83 c4 1c             	add    $0x1c,%esp
  802b0c:	5b                   	pop    %ebx
  802b0d:	5e                   	pop    %esi
  802b0e:	5f                   	pop    %edi
  802b0f:	5d                   	pop    %ebp
  802b10:	c3                   	ret    
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 fd                	mov    %edi,%ebp
  802b1a:	85 ff                	test   %edi,%edi
  802b1c:	75 0b                	jne    802b29 <__umoddi3+0x49>
  802b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f7                	div    %edi
  802b27:	89 c5                	mov    %eax,%ebp
  802b29:	89 d8                	mov    %ebx,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	f7 f5                	div    %ebp
  802b2f:	89 f0                	mov    %esi,%eax
  802b31:	f7 f5                	div    %ebp
  802b33:	89 d0                	mov    %edx,%eax
  802b35:	eb d0                	jmp    802b07 <__umoddi3+0x27>
  802b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3e:	66 90                	xchg   %ax,%ax
  802b40:	89 f1                	mov    %esi,%ecx
  802b42:	39 d8                	cmp    %ebx,%eax
  802b44:	76 0a                	jbe    802b50 <__umoddi3+0x70>
  802b46:	89 f0                	mov    %esi,%eax
  802b48:	83 c4 1c             	add    $0x1c,%esp
  802b4b:	5b                   	pop    %ebx
  802b4c:	5e                   	pop    %esi
  802b4d:	5f                   	pop    %edi
  802b4e:	5d                   	pop    %ebp
  802b4f:	c3                   	ret    
  802b50:	0f bd e8             	bsr    %eax,%ebp
  802b53:	83 f5 1f             	xor    $0x1f,%ebp
  802b56:	75 20                	jne    802b78 <__umoddi3+0x98>
  802b58:	39 d8                	cmp    %ebx,%eax
  802b5a:	0f 82 b0 00 00 00    	jb     802c10 <__umoddi3+0x130>
  802b60:	39 f7                	cmp    %esi,%edi
  802b62:	0f 86 a8 00 00 00    	jbe    802c10 <__umoddi3+0x130>
  802b68:	89 c8                	mov    %ecx,%eax
  802b6a:	83 c4 1c             	add    $0x1c,%esp
  802b6d:	5b                   	pop    %ebx
  802b6e:	5e                   	pop    %esi
  802b6f:	5f                   	pop    %edi
  802b70:	5d                   	pop    %ebp
  802b71:	c3                   	ret    
  802b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b7f:	29 ea                	sub    %ebp,%edx
  802b81:	d3 e0                	shl    %cl,%eax
  802b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b87:	89 d1                	mov    %edx,%ecx
  802b89:	89 f8                	mov    %edi,%eax
  802b8b:	d3 e8                	shr    %cl,%eax
  802b8d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b95:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b99:	09 c1                	or     %eax,%ecx
  802b9b:	89 d8                	mov    %ebx,%eax
  802b9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba1:	89 e9                	mov    %ebp,%ecx
  802ba3:	d3 e7                	shl    %cl,%edi
  802ba5:	89 d1                	mov    %edx,%ecx
  802ba7:	d3 e8                	shr    %cl,%eax
  802ba9:	89 e9                	mov    %ebp,%ecx
  802bab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802baf:	d3 e3                	shl    %cl,%ebx
  802bb1:	89 c7                	mov    %eax,%edi
  802bb3:	89 d1                	mov    %edx,%ecx
  802bb5:	89 f0                	mov    %esi,%eax
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 fa                	mov    %edi,%edx
  802bbd:	d3 e6                	shl    %cl,%esi
  802bbf:	09 d8                	or     %ebx,%eax
  802bc1:	f7 74 24 08          	divl   0x8(%esp)
  802bc5:	89 d1                	mov    %edx,%ecx
  802bc7:	89 f3                	mov    %esi,%ebx
  802bc9:	f7 64 24 0c          	mull   0xc(%esp)
  802bcd:	89 c6                	mov    %eax,%esi
  802bcf:	89 d7                	mov    %edx,%edi
  802bd1:	39 d1                	cmp    %edx,%ecx
  802bd3:	72 06                	jb     802bdb <__umoddi3+0xfb>
  802bd5:	75 10                	jne    802be7 <__umoddi3+0x107>
  802bd7:	39 c3                	cmp    %eax,%ebx
  802bd9:	73 0c                	jae    802be7 <__umoddi3+0x107>
  802bdb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bdf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802be3:	89 d7                	mov    %edx,%edi
  802be5:	89 c6                	mov    %eax,%esi
  802be7:	89 ca                	mov    %ecx,%edx
  802be9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bee:	29 f3                	sub    %esi,%ebx
  802bf0:	19 fa                	sbb    %edi,%edx
  802bf2:	89 d0                	mov    %edx,%eax
  802bf4:	d3 e0                	shl    %cl,%eax
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	d3 eb                	shr    %cl,%ebx
  802bfa:	d3 ea                	shr    %cl,%edx
  802bfc:	09 d8                	or     %ebx,%eax
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c0d:	8d 76 00             	lea    0x0(%esi),%esi
  802c10:	89 da                	mov    %ebx,%edx
  802c12:	29 fe                	sub    %edi,%esi
  802c14:	19 c2                	sbb    %eax,%edx
  802c16:	89 f1                	mov    %esi,%ecx
  802c18:	89 c8                	mov    %ecx,%eax
  802c1a:	e9 4b ff ff ff       	jmp    802b6a <__umoddi3+0x8a>
