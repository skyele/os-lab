
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
  80003c:	68 60 26 80 00       	push   $0x802660
  800041:	e8 27 03 00 00       	call   80036d <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 e8 1e 00 00       	call   801f39 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5b                	js     8000b3 <umain+0x80>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 9f 12 00 00       	call   8012fc <fork>
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
  800088:	e8 f6 1f 00 00       	call   802083 <pipeisclosed>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	74 e2                	je     800076 <umain+0x43>
			cprintf("\nRACE: pipe appears closed\n");
  800094:	83 ec 0c             	sub    $0xc,%esp
  800097:	68 d9 26 80 00       	push   $0x8026d9
  80009c:	e8 cc 02 00 00       	call   80036d <cprintf>
			sys_env_destroy(r);
  8000a1:	89 3c 24             	mov    %edi,(%esp)
  8000a4:	e8 96 0d 00 00       	call   800e3f <sys_env_destroy>
			exit();
  8000a9:	e8 b7 01 00 00       	call   800265 <exit>
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	eb c3                	jmp    800076 <umain+0x43>
		panic("pipe: %e", r);
  8000b3:	50                   	push   %eax
  8000b4:	68 ae 26 80 00       	push   $0x8026ae
  8000b9:	6a 0d                	push   $0xd
  8000bb:	68 b7 26 80 00       	push   $0x8026b7
  8000c0:	e8 b2 01 00 00       	call   800277 <_panic>
		panic("fork: %e", r);
  8000c5:	50                   	push   %eax
  8000c6:	68 cc 26 80 00       	push   $0x8026cc
  8000cb:	6a 0f                	push   $0xf
  8000cd:	68 b7 26 80 00       	push   $0x8026b7
  8000d2:	e8 a0 01 00 00       	call   800277 <_panic>
		close(p[1]);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000dd:	e8 6c 16 00 00       	call   80174e <close>
  8000e2:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e5:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ec:	eb 42                	jmp    800130 <umain+0xfd>
				cprintf("%d.", i);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	53                   	push   %ebx
  8000f2:	68 d5 26 80 00       	push   $0x8026d5
  8000f7:	e8 71 02 00 00       	call   80036d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	6a 0a                	push   $0xa
  800104:	ff 75 e0             	pushl  -0x20(%ebp)
  800107:	e8 94 16 00 00       	call   8017a0 <dup>
			sys_yield();
  80010c:	e8 8e 0d 00 00       	call   800e9f <sys_yield>
			close(10);
  800111:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800118:	e8 31 16 00 00       	call   80174e <close>
			sys_yield();
  80011d:	e8 7d 0d 00 00       	call   800e9f <sys_yield>
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
  800149:	e8 17 01 00 00       	call   800265 <exit>
  80014e:	e9 12 ff ff ff       	jmp    800065 <umain+0x32>
		}
	cprintf("child done with loop\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 f5 26 80 00       	push   $0x8026f5
  80015b:	e8 0d 02 00 00       	call   80036d <cprintf>
	if (pipeisclosed(p[0]))
  800160:	83 c4 04             	add    $0x4,%esp
  800163:	ff 75 e0             	pushl  -0x20(%ebp)
  800166:	e8 18 1f 00 00       	call   802083 <pipeisclosed>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	85 c0                	test   %eax,%eax
  800170:	75 38                	jne    8001aa <umain+0x177>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	ff 75 e0             	pushl  -0x20(%ebp)
  80017c:	e8 a0 14 00 00       	call   801621 <fd_lookup>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	85 c0                	test   %eax,%eax
  800186:	78 36                	js     8001be <umain+0x18b>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff 75 dc             	pushl  -0x24(%ebp)
  80018e:	e8 25 14 00 00       	call   8015b8 <fd2data>
	cprintf("race didn't happen\n");
  800193:	c7 04 24 23 27 80 00 	movl   $0x802723,(%esp)
  80019a:	e8 ce 01 00 00       	call   80036d <cprintf>
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
  8001ad:	68 84 26 80 00       	push   $0x802684
  8001b2:	6a 40                	push   $0x40
  8001b4:	68 b7 26 80 00       	push   $0x8026b7
  8001b9:	e8 b9 00 00 00       	call   800277 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001be:	50                   	push   %eax
  8001bf:	68 0b 27 80 00       	push   $0x80270b
  8001c4:	6a 42                	push   $0x42
  8001c6:	68 b7 26 80 00       	push   $0x8026b7
  8001cb:	e8 a7 00 00 00       	call   800277 <_panic>

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
  8001d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8001e0:	00 00 00 
	envid_t find = sys_getenvid();
  8001e3:	e8 98 0c 00 00       	call   800e80 <sys_getenvid>
  8001e8:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
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
  800231:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023b:	7e 0a                	jle    800247 <libmain+0x77>
		binaryname = argv[0];
  80023d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800240:	8b 00                	mov    (%eax),%eax
  800242:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 de fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800255:	e8 0b 00 00 00       	call   800265 <exit>
}
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800260:	5b                   	pop    %ebx
  800261:	5e                   	pop    %esi
  800262:	5f                   	pop    %edi
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    

00800265 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80026b:	6a 00                	push   $0x0
  80026d:	e8 cd 0b 00 00       	call   800e3f <sys_env_destroy>
}
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	56                   	push   %esi
  80027b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80027c:	a1 04 40 80 00       	mov    0x804004,%eax
  800281:	8b 40 48             	mov    0x48(%eax),%eax
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 70 27 80 00       	push   $0x802770
  80028c:	50                   	push   %eax
  80028d:	68 41 27 80 00       	push   $0x802741
  800292:	e8 d6 00 00 00       	call   80036d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800297:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80029a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002a0:	e8 db 0b 00 00       	call   800e80 <sys_getenvid>
  8002a5:	83 c4 04             	add    $0x4,%esp
  8002a8:	ff 75 0c             	pushl  0xc(%ebp)
  8002ab:	ff 75 08             	pushl  0x8(%ebp)
  8002ae:	56                   	push   %esi
  8002af:	50                   	push   %eax
  8002b0:	68 4c 27 80 00       	push   $0x80274c
  8002b5:	e8 b3 00 00 00       	call   80036d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002ba:	83 c4 18             	add    $0x18,%esp
  8002bd:	53                   	push   %ebx
  8002be:	ff 75 10             	pushl  0x10(%ebp)
  8002c1:	e8 56 00 00 00       	call   80031c <vcprintf>
	cprintf("\n");
  8002c6:	c7 04 24 79 2b 80 00 	movl   $0x802b79,(%esp)
  8002cd:	e8 9b 00 00 00       	call   80036d <cprintf>
  8002d2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d5:	cc                   	int3   
  8002d6:	eb fd                	jmp    8002d5 <_panic+0x5e>

008002d8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	53                   	push   %ebx
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e2:	8b 13                	mov    (%ebx),%edx
  8002e4:	8d 42 01             	lea    0x1(%edx),%eax
  8002e7:	89 03                	mov    %eax,(%ebx)
  8002e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ec:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f5:	74 09                	je     800300 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002f7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	68 ff 00 00 00       	push   $0xff
  800308:	8d 43 08             	lea    0x8(%ebx),%eax
  80030b:	50                   	push   %eax
  80030c:	e8 f1 0a 00 00       	call   800e02 <sys_cputs>
		b->idx = 0;
  800311:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800317:	83 c4 10             	add    $0x10,%esp
  80031a:	eb db                	jmp    8002f7 <putch+0x1f>

0080031c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800325:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032c:	00 00 00 
	b.cnt = 0;
  80032f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800336:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800345:	50                   	push   %eax
  800346:	68 d8 02 80 00       	push   $0x8002d8
  80034b:	e8 4a 01 00 00       	call   80049a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800350:	83 c4 08             	add    $0x8,%esp
  800353:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800359:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80035f:	50                   	push   %eax
  800360:	e8 9d 0a 00 00       	call   800e02 <sys_cputs>

	return b.cnt;
}
  800365:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80036b:	c9                   	leave  
  80036c:	c3                   	ret    

0080036d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800373:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800376:	50                   	push   %eax
  800377:	ff 75 08             	pushl  0x8(%ebp)
  80037a:	e8 9d ff ff ff       	call   80031c <vcprintf>
	va_end(ap);

	return cnt;
}
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	57                   	push   %edi
  800385:	56                   	push   %esi
  800386:	53                   	push   %ebx
  800387:	83 ec 1c             	sub    $0x1c,%esp
  80038a:	89 c6                	mov    %eax,%esi
  80038c:	89 d7                	mov    %edx,%edi
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	8b 55 0c             	mov    0xc(%ebp),%edx
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80039a:	8b 45 10             	mov    0x10(%ebp),%eax
  80039d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8003a0:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8003a4:	74 2c                	je     8003d2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8003a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8003b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8003bb:	73 43                	jae    800400 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8003bd:	83 eb 01             	sub    $0x1,%ebx
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	7e 6c                	jle    800430 <printnum+0xaf>
				putch(padc, putdat);
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	57                   	push   %edi
  8003c8:	ff 75 18             	pushl  0x18(%ebp)
  8003cb:	ff d6                	call   *%esi
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	eb eb                	jmp    8003bd <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8003d2:	83 ec 0c             	sub    $0xc,%esp
  8003d5:	6a 20                	push   $0x20
  8003d7:	6a 00                	push   $0x0
  8003d9:	50                   	push   %eax
  8003da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e0:	89 fa                	mov    %edi,%edx
  8003e2:	89 f0                	mov    %esi,%eax
  8003e4:	e8 98 ff ff ff       	call   800381 <printnum>
		while (--width > 0)
  8003e9:	83 c4 20             	add    $0x20,%esp
  8003ec:	83 eb 01             	sub    $0x1,%ebx
  8003ef:	85 db                	test   %ebx,%ebx
  8003f1:	7e 65                	jle    800458 <printnum+0xd7>
			putch(padc, putdat);
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	57                   	push   %edi
  8003f7:	6a 20                	push   $0x20
  8003f9:	ff d6                	call   *%esi
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	eb ec                	jmp    8003ec <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800400:	83 ec 0c             	sub    $0xc,%esp
  800403:	ff 75 18             	pushl  0x18(%ebp)
  800406:	83 eb 01             	sub    $0x1,%ebx
  800409:	53                   	push   %ebx
  80040a:	50                   	push   %eax
  80040b:	83 ec 08             	sub    $0x8,%esp
  80040e:	ff 75 dc             	pushl  -0x24(%ebp)
  800411:	ff 75 d8             	pushl  -0x28(%ebp)
  800414:	ff 75 e4             	pushl  -0x1c(%ebp)
  800417:	ff 75 e0             	pushl  -0x20(%ebp)
  80041a:	e8 e1 1f 00 00       	call   802400 <__udivdi3>
  80041f:	83 c4 18             	add    $0x18,%esp
  800422:	52                   	push   %edx
  800423:	50                   	push   %eax
  800424:	89 fa                	mov    %edi,%edx
  800426:	89 f0                	mov    %esi,%eax
  800428:	e8 54 ff ff ff       	call   800381 <printnum>
  80042d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	57                   	push   %edi
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	ff 75 dc             	pushl  -0x24(%ebp)
  80043a:	ff 75 d8             	pushl  -0x28(%ebp)
  80043d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800440:	ff 75 e0             	pushl  -0x20(%ebp)
  800443:	e8 c8 20 00 00       	call   802510 <__umoddi3>
  800448:	83 c4 14             	add    $0x14,%esp
  80044b:	0f be 80 77 27 80 00 	movsbl 0x802777(%eax),%eax
  800452:	50                   	push   %eax
  800453:	ff d6                	call   *%esi
  800455:	83 c4 10             	add    $0x10,%esp
	}
}
  800458:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045b:	5b                   	pop    %ebx
  80045c:	5e                   	pop    %esi
  80045d:	5f                   	pop    %edi
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800466:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046a:	8b 10                	mov    (%eax),%edx
  80046c:	3b 50 04             	cmp    0x4(%eax),%edx
  80046f:	73 0a                	jae    80047b <sprintputch+0x1b>
		*b->buf++ = ch;
  800471:	8d 4a 01             	lea    0x1(%edx),%ecx
  800474:	89 08                	mov    %ecx,(%eax)
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	88 02                	mov    %al,(%edx)
}
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <printfmt>:
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800483:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800486:	50                   	push   %eax
  800487:	ff 75 10             	pushl  0x10(%ebp)
  80048a:	ff 75 0c             	pushl  0xc(%ebp)
  80048d:	ff 75 08             	pushl  0x8(%ebp)
  800490:	e8 05 00 00 00       	call   80049a <vprintfmt>
}
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	c9                   	leave  
  800499:	c3                   	ret    

0080049a <vprintfmt>:
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	57                   	push   %edi
  80049e:	56                   	push   %esi
  80049f:	53                   	push   %ebx
  8004a0:	83 ec 3c             	sub    $0x3c,%esp
  8004a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004ac:	e9 32 04 00 00       	jmp    8008e3 <vprintfmt+0x449>
		padc = ' ';
  8004b1:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8004b5:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8004bc:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8004c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004ca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004d8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004dd:	8d 47 01             	lea    0x1(%edi),%eax
  8004e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004e3:	0f b6 17             	movzbl (%edi),%edx
  8004e6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004e9:	3c 55                	cmp    $0x55,%al
  8004eb:	0f 87 12 05 00 00    	ja     800a03 <vprintfmt+0x569>
  8004f1:	0f b6 c0             	movzbl %al,%eax
  8004f4:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  8004fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004fe:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800502:	eb d9                	jmp    8004dd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800504:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800507:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80050b:	eb d0                	jmp    8004dd <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	0f b6 d2             	movzbl %dl,%edx
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800513:	b8 00 00 00 00       	mov    $0x0,%eax
  800518:	89 75 08             	mov    %esi,0x8(%ebp)
  80051b:	eb 03                	jmp    800520 <vprintfmt+0x86>
  80051d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800520:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800523:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800527:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80052a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80052d:	83 fe 09             	cmp    $0x9,%esi
  800530:	76 eb                	jbe    80051d <vprintfmt+0x83>
  800532:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800535:	8b 75 08             	mov    0x8(%ebp),%esi
  800538:	eb 14                	jmp    80054e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8d 40 04             	lea    0x4(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80054e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800552:	79 89                	jns    8004dd <vprintfmt+0x43>
				width = precision, precision = -1;
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800561:	e9 77 ff ff ff       	jmp    8004dd <vprintfmt+0x43>
  800566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	0f 48 c1             	cmovs  %ecx,%eax
  80056e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800574:	e9 64 ff ff ff       	jmp    8004dd <vprintfmt+0x43>
  800579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80057c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800583:	e9 55 ff ff ff       	jmp    8004dd <vprintfmt+0x43>
			lflag++;
  800588:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80058c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80058f:	e9 49 ff ff ff       	jmp    8004dd <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 78 04             	lea    0x4(%eax),%edi
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	ff 30                	pushl  (%eax)
  8005a0:	ff d6                	call   *%esi
			break;
  8005a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005a8:	e9 33 03 00 00       	jmp    8008e0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 78 04             	lea    0x4(%eax),%edi
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	99                   	cltd   
  8005b6:	31 d0                	xor    %edx,%eax
  8005b8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ba:	83 f8 0f             	cmp    $0xf,%eax
  8005bd:	7f 23                	jg     8005e2 <vprintfmt+0x148>
  8005bf:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	74 18                	je     8005e2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8005ca:	52                   	push   %edx
  8005cb:	68 f2 2c 80 00       	push   $0x802cf2
  8005d0:	53                   	push   %ebx
  8005d1:	56                   	push   %esi
  8005d2:	e8 a6 fe ff ff       	call   80047d <printfmt>
  8005d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005da:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005dd:	e9 fe 02 00 00       	jmp    8008e0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005e2:	50                   	push   %eax
  8005e3:	68 8f 27 80 00       	push   $0x80278f
  8005e8:	53                   	push   %ebx
  8005e9:	56                   	push   %esi
  8005ea:	e8 8e fe ff ff       	call   80047d <printfmt>
  8005ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005f2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005f5:	e9 e6 02 00 00       	jmp    8008e0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	83 c0 04             	add    $0x4,%eax
  800600:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800608:	85 c9                	test   %ecx,%ecx
  80060a:	b8 88 27 80 00       	mov    $0x802788,%eax
  80060f:	0f 45 c1             	cmovne %ecx,%eax
  800612:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800615:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800619:	7e 06                	jle    800621 <vprintfmt+0x187>
  80061b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80061f:	75 0d                	jne    80062e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800624:	89 c7                	mov    %eax,%edi
  800626:	03 45 e0             	add    -0x20(%ebp),%eax
  800629:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80062c:	eb 53                	jmp    800681 <vprintfmt+0x1e7>
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 d8             	pushl  -0x28(%ebp)
  800634:	50                   	push   %eax
  800635:	e8 71 04 00 00       	call   800aab <strnlen>
  80063a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80063d:	29 c1                	sub    %eax,%ecx
  80063f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800647:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80064e:	eb 0f                	jmp    80065f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800650:	83 ec 08             	sub    $0x8,%esp
  800653:	53                   	push   %ebx
  800654:	ff 75 e0             	pushl  -0x20(%ebp)
  800657:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800659:	83 ef 01             	sub    $0x1,%edi
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	85 ff                	test   %edi,%edi
  800661:	7f ed                	jg     800650 <vprintfmt+0x1b6>
  800663:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800666:	85 c9                	test   %ecx,%ecx
  800668:	b8 00 00 00 00       	mov    $0x0,%eax
  80066d:	0f 49 c1             	cmovns %ecx,%eax
  800670:	29 c1                	sub    %eax,%ecx
  800672:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800675:	eb aa                	jmp    800621 <vprintfmt+0x187>
					putch(ch, putdat);
  800677:	83 ec 08             	sub    $0x8,%esp
  80067a:	53                   	push   %ebx
  80067b:	52                   	push   %edx
  80067c:	ff d6                	call   *%esi
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800684:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800686:	83 c7 01             	add    $0x1,%edi
  800689:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80068d:	0f be d0             	movsbl %al,%edx
  800690:	85 d2                	test   %edx,%edx
  800692:	74 4b                	je     8006df <vprintfmt+0x245>
  800694:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800698:	78 06                	js     8006a0 <vprintfmt+0x206>
  80069a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80069e:	78 1e                	js     8006be <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8006a0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a4:	74 d1                	je     800677 <vprintfmt+0x1dd>
  8006a6:	0f be c0             	movsbl %al,%eax
  8006a9:	83 e8 20             	sub    $0x20,%eax
  8006ac:	83 f8 5e             	cmp    $0x5e,%eax
  8006af:	76 c6                	jbe    800677 <vprintfmt+0x1dd>
					putch('?', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 3f                	push   $0x3f
  8006b7:	ff d6                	call   *%esi
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	eb c3                	jmp    800681 <vprintfmt+0x1e7>
  8006be:	89 cf                	mov    %ecx,%edi
  8006c0:	eb 0e                	jmp    8006d0 <vprintfmt+0x236>
				putch(' ', putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 20                	push   $0x20
  8006c8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006ca:	83 ef 01             	sub    $0x1,%edi
  8006cd:	83 c4 10             	add    $0x10,%esp
  8006d0:	85 ff                	test   %edi,%edi
  8006d2:	7f ee                	jg     8006c2 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006da:	e9 01 02 00 00       	jmp    8008e0 <vprintfmt+0x446>
  8006df:	89 cf                	mov    %ecx,%edi
  8006e1:	eb ed                	jmp    8006d0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006e6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006ed:	e9 eb fd ff ff       	jmp    8004dd <vprintfmt+0x43>
	if (lflag >= 2)
  8006f2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f6:	7f 21                	jg     800719 <vprintfmt+0x27f>
	else if (lflag)
  8006f8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fc:	74 68                	je     800766 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800706:	89 c1                	mov    %eax,%ecx
  800708:	c1 f9 1f             	sar    $0x1f,%ecx
  80070b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
  800717:	eb 17                	jmp    800730 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 50 04             	mov    0x4(%eax),%edx
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800724:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 08             	lea    0x8(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800730:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80073c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800740:	78 3f                	js     800781 <vprintfmt+0x2e7>
			base = 10;
  800742:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800747:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80074b:	0f 84 71 01 00 00    	je     8008c2 <vprintfmt+0x428>
				putch('+', putdat);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	6a 2b                	push   $0x2b
  800757:	ff d6                	call   *%esi
  800759:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80075c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800761:	e9 5c 01 00 00       	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80076e:	89 c1                	mov    %eax,%ecx
  800770:	c1 f9 1f             	sar    $0x1f,%ecx
  800773:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
  80077f:	eb af                	jmp    800730 <vprintfmt+0x296>
				putch('-', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	6a 2d                	push   $0x2d
  800787:	ff d6                	call   *%esi
				num = -(long long) num;
  800789:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80078c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80078f:	f7 d8                	neg    %eax
  800791:	83 d2 00             	adc    $0x0,%edx
  800794:	f7 da                	neg    %edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80079f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007a4:	e9 19 01 00 00       	jmp    8008c2 <vprintfmt+0x428>
	if (lflag >= 2)
  8007a9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ad:	7f 29                	jg     8007d8 <vprintfmt+0x33e>
	else if (lflag)
  8007af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007b3:	74 44                	je     8007f9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 04             	lea    0x4(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d3:	e9 ea 00 00 00       	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 50 04             	mov    0x4(%eax),%edx
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	8d 40 08             	lea    0x8(%eax),%eax
  8007ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f4:	e9 c9 00 00 00       	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800812:	b8 0a 00 00 00       	mov    $0xa,%eax
  800817:	e9 a6 00 00 00       	jmp    8008c2 <vprintfmt+0x428>
			putch('0', putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	6a 30                	push   $0x30
  800822:	ff d6                	call   *%esi
	if (lflag >= 2)
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80082b:	7f 26                	jg     800853 <vprintfmt+0x3b9>
	else if (lflag)
  80082d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800831:	74 3e                	je     800871 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8b 00                	mov    (%eax),%eax
  800838:	ba 00 00 00 00       	mov    $0x0,%edx
  80083d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800840:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	8d 40 04             	lea    0x4(%eax),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80084c:	b8 08 00 00 00       	mov    $0x8,%eax
  800851:	eb 6f                	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	8b 50 04             	mov    0x4(%eax),%edx
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8d 40 08             	lea    0x8(%eax),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086a:	b8 08 00 00 00       	mov    $0x8,%eax
  80086f:	eb 51                	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	ba 00 00 00 00       	mov    $0x0,%edx
  80087b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80088a:	b8 08 00 00 00       	mov    $0x8,%eax
  80088f:	eb 31                	jmp    8008c2 <vprintfmt+0x428>
			putch('0', putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	53                   	push   %ebx
  800895:	6a 30                	push   $0x30
  800897:	ff d6                	call   *%esi
			putch('x', putdat);
  800899:	83 c4 08             	add    $0x8,%esp
  80089c:	53                   	push   %ebx
  80089d:	6a 78                	push   $0x78
  80089f:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8008b1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8008c9:	52                   	push   %edx
  8008ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8008cd:	50                   	push   %eax
  8008ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8008d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8008d4:	89 da                	mov    %ebx,%edx
  8008d6:	89 f0                	mov    %esi,%eax
  8008d8:	e8 a4 fa ff ff       	call   800381 <printnum>
			break;
  8008dd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e3:	83 c7 01             	add    $0x1,%edi
  8008e6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ea:	83 f8 25             	cmp    $0x25,%eax
  8008ed:	0f 84 be fb ff ff    	je     8004b1 <vprintfmt+0x17>
			if (ch == '\0')
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	0f 84 28 01 00 00    	je     800a23 <vprintfmt+0x589>
			putch(ch, putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	53                   	push   %ebx
  8008ff:	50                   	push   %eax
  800900:	ff d6                	call   *%esi
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	eb dc                	jmp    8008e3 <vprintfmt+0x449>
	if (lflag >= 2)
  800907:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80090b:	7f 26                	jg     800933 <vprintfmt+0x499>
	else if (lflag)
  80090d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800911:	74 41                	je     800954 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	ba 00 00 00 00       	mov    $0x0,%edx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	8d 40 04             	lea    0x4(%eax),%eax
  800929:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80092c:	b8 10 00 00 00       	mov    $0x10,%eax
  800931:	eb 8f                	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 50 04             	mov    0x4(%eax),%edx
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	8d 40 08             	lea    0x8(%eax),%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80094a:	b8 10 00 00 00       	mov    $0x10,%eax
  80094f:	e9 6e ff ff ff       	jmp    8008c2 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800961:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8d 40 04             	lea    0x4(%eax),%eax
  80096a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80096d:	b8 10 00 00 00       	mov    $0x10,%eax
  800972:	e9 4b ff ff ff       	jmp    8008c2 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800977:	8b 45 14             	mov    0x14(%ebp),%eax
  80097a:	83 c0 04             	add    $0x4,%eax
  80097d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	85 c0                	test   %eax,%eax
  800987:	74 14                	je     80099d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800989:	8b 13                	mov    (%ebx),%edx
  80098b:	83 fa 7f             	cmp    $0x7f,%edx
  80098e:	7f 37                	jg     8009c7 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800990:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800992:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800995:	89 45 14             	mov    %eax,0x14(%ebp)
  800998:	e9 43 ff ff ff       	jmp    8008e0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80099d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009a2:	bf ad 28 80 00       	mov    $0x8028ad,%edi
							putch(ch, putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	53                   	push   %ebx
  8009ab:	50                   	push   %eax
  8009ac:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009ae:	83 c7 01             	add    $0x1,%edi
  8009b1:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	75 eb                	jne    8009a7 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8009bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c2:	e9 19 ff ff ff       	jmp    8008e0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8009c7:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8009c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009ce:	bf e5 28 80 00       	mov    $0x8028e5,%edi
							putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009da:	83 c7 01             	add    $0x1,%edi
  8009dd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
  8009e4:	85 c0                	test   %eax,%eax
  8009e6:	75 eb                	jne    8009d3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ee:	e9 ed fe ff ff       	jmp    8008e0 <vprintfmt+0x446>
			putch(ch, putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	53                   	push   %ebx
  8009f7:	6a 25                	push   $0x25
  8009f9:	ff d6                	call   *%esi
			break;
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	e9 dd fe ff ff       	jmp    8008e0 <vprintfmt+0x446>
			putch('%', putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	53                   	push   %ebx
  800a07:	6a 25                	push   $0x25
  800a09:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a0b:	83 c4 10             	add    $0x10,%esp
  800a0e:	89 f8                	mov    %edi,%eax
  800a10:	eb 03                	jmp    800a15 <vprintfmt+0x57b>
  800a12:	83 e8 01             	sub    $0x1,%eax
  800a15:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a19:	75 f7                	jne    800a12 <vprintfmt+0x578>
  800a1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a1e:	e9 bd fe ff ff       	jmp    8008e0 <vprintfmt+0x446>
}
  800a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a26:	5b                   	pop    %ebx
  800a27:	5e                   	pop    %esi
  800a28:	5f                   	pop    %edi
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 18             	sub    $0x18,%esp
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a3a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a3e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a48:	85 c0                	test   %eax,%eax
  800a4a:	74 26                	je     800a72 <vsnprintf+0x47>
  800a4c:	85 d2                	test   %edx,%edx
  800a4e:	7e 22                	jle    800a72 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a50:	ff 75 14             	pushl  0x14(%ebp)
  800a53:	ff 75 10             	pushl  0x10(%ebp)
  800a56:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a59:	50                   	push   %eax
  800a5a:	68 60 04 80 00       	push   $0x800460
  800a5f:	e8 36 fa ff ff       	call   80049a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a67:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a6d:	83 c4 10             	add    $0x10,%esp
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    
		return -E_INVAL;
  800a72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a77:	eb f7                	jmp    800a70 <vsnprintf+0x45>

00800a79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a82:	50                   	push   %eax
  800a83:	ff 75 10             	pushl  0x10(%ebp)
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	ff 75 08             	pushl  0x8(%ebp)
  800a8c:	e8 9a ff ff ff       	call   800a2b <vsnprintf>
	va_end(ap);

	return rc;
}
  800a91:	c9                   	leave  
  800a92:	c3                   	ret    

00800a93 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a99:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa2:	74 05                	je     800aa9 <strlen+0x16>
		n++;
  800aa4:	83 c0 01             	add    $0x1,%eax
  800aa7:	eb f5                	jmp    800a9e <strlen+0xb>
	return n;
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab9:	39 c2                	cmp    %eax,%edx
  800abb:	74 0d                	je     800aca <strnlen+0x1f>
  800abd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800ac1:	74 05                	je     800ac8 <strnlen+0x1d>
		n++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	eb f1                	jmp    800ab9 <strnlen+0xe>
  800ac8:	89 d0                	mov    %edx,%eax
	return n;
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad6:	ba 00 00 00 00       	mov    $0x0,%edx
  800adb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800adf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ae2:	83 c2 01             	add    $0x1,%edx
  800ae5:	84 c9                	test   %cl,%cl
  800ae7:	75 f2                	jne    800adb <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ae9:	5b                   	pop    %ebx
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <strcat>:

char *
strcat(char *dst, const char *src)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	53                   	push   %ebx
  800af0:	83 ec 10             	sub    $0x10,%esp
  800af3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800af6:	53                   	push   %ebx
  800af7:	e8 97 ff ff ff       	call   800a93 <strlen>
  800afc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	01 d8                	add    %ebx,%eax
  800b04:	50                   	push   %eax
  800b05:	e8 c2 ff ff ff       	call   800acc <strcpy>
	return dst;
}
  800b0a:	89 d8                	mov    %ebx,%eax
  800b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    

00800b11 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1c:	89 c6                	mov    %eax,%esi
  800b1e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b21:	89 c2                	mov    %eax,%edx
  800b23:	39 f2                	cmp    %esi,%edx
  800b25:	74 11                	je     800b38 <strncpy+0x27>
		*dst++ = *src;
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	0f b6 19             	movzbl (%ecx),%ebx
  800b2d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b30:	80 fb 01             	cmp    $0x1,%bl
  800b33:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b36:	eb eb                	jmp    800b23 <strncpy+0x12>
	}
	return ret;
}
  800b38:	5b                   	pop    %ebx
  800b39:	5e                   	pop    %esi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	8b 75 08             	mov    0x8(%ebp),%esi
  800b44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b47:	8b 55 10             	mov    0x10(%ebp),%edx
  800b4a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b4c:	85 d2                	test   %edx,%edx
  800b4e:	74 21                	je     800b71 <strlcpy+0x35>
  800b50:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b54:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b56:	39 c2                	cmp    %eax,%edx
  800b58:	74 14                	je     800b6e <strlcpy+0x32>
  800b5a:	0f b6 19             	movzbl (%ecx),%ebx
  800b5d:	84 db                	test   %bl,%bl
  800b5f:	74 0b                	je     800b6c <strlcpy+0x30>
			*dst++ = *src++;
  800b61:	83 c1 01             	add    $0x1,%ecx
  800b64:	83 c2 01             	add    $0x1,%edx
  800b67:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b6a:	eb ea                	jmp    800b56 <strlcpy+0x1a>
  800b6c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b6e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b71:	29 f0                	sub    %esi,%eax
}
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5d                   	pop    %ebp
  800b76:	c3                   	ret    

00800b77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
  800b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b80:	0f b6 01             	movzbl (%ecx),%eax
  800b83:	84 c0                	test   %al,%al
  800b85:	74 0c                	je     800b93 <strcmp+0x1c>
  800b87:	3a 02                	cmp    (%edx),%al
  800b89:	75 08                	jne    800b93 <strcmp+0x1c>
		p++, q++;
  800b8b:	83 c1 01             	add    $0x1,%ecx
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	eb ed                	jmp    800b80 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b93:	0f b6 c0             	movzbl %al,%eax
  800b96:	0f b6 12             	movzbl (%edx),%edx
  800b99:	29 d0                	sub    %edx,%eax
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	53                   	push   %ebx
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba7:	89 c3                	mov    %eax,%ebx
  800ba9:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bac:	eb 06                	jmp    800bb4 <strncmp+0x17>
		n--, p++, q++;
  800bae:	83 c0 01             	add    $0x1,%eax
  800bb1:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bb4:	39 d8                	cmp    %ebx,%eax
  800bb6:	74 16                	je     800bce <strncmp+0x31>
  800bb8:	0f b6 08             	movzbl (%eax),%ecx
  800bbb:	84 c9                	test   %cl,%cl
  800bbd:	74 04                	je     800bc3 <strncmp+0x26>
  800bbf:	3a 0a                	cmp    (%edx),%cl
  800bc1:	74 eb                	je     800bae <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc3:	0f b6 00             	movzbl (%eax),%eax
  800bc6:	0f b6 12             	movzbl (%edx),%edx
  800bc9:	29 d0                	sub    %edx,%eax
}
  800bcb:	5b                   	pop    %ebx
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    
		return 0;
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd3:	eb f6                	jmp    800bcb <strncmp+0x2e>

00800bd5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bdf:	0f b6 10             	movzbl (%eax),%edx
  800be2:	84 d2                	test   %dl,%dl
  800be4:	74 09                	je     800bef <strchr+0x1a>
		if (*s == c)
  800be6:	38 ca                	cmp    %cl,%dl
  800be8:	74 0a                	je     800bf4 <strchr+0x1f>
	for (; *s; s++)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	eb f0                	jmp    800bdf <strchr+0xa>
			return (char *) s;
	return 0;
  800bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c00:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c03:	38 ca                	cmp    %cl,%dl
  800c05:	74 09                	je     800c10 <strfind+0x1a>
  800c07:	84 d2                	test   %dl,%dl
  800c09:	74 05                	je     800c10 <strfind+0x1a>
	for (; *s; s++)
  800c0b:	83 c0 01             	add    $0x1,%eax
  800c0e:	eb f0                	jmp    800c00 <strfind+0xa>
			break;
	return (char *) s;
}
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c1e:	85 c9                	test   %ecx,%ecx
  800c20:	74 31                	je     800c53 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c22:	89 f8                	mov    %edi,%eax
  800c24:	09 c8                	or     %ecx,%eax
  800c26:	a8 03                	test   $0x3,%al
  800c28:	75 23                	jne    800c4d <memset+0x3b>
		c &= 0xFF;
  800c2a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c2e:	89 d3                	mov    %edx,%ebx
  800c30:	c1 e3 08             	shl    $0x8,%ebx
  800c33:	89 d0                	mov    %edx,%eax
  800c35:	c1 e0 18             	shl    $0x18,%eax
  800c38:	89 d6                	mov    %edx,%esi
  800c3a:	c1 e6 10             	shl    $0x10,%esi
  800c3d:	09 f0                	or     %esi,%eax
  800c3f:	09 c2                	or     %eax,%edx
  800c41:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c43:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c46:	89 d0                	mov    %edx,%eax
  800c48:	fc                   	cld    
  800c49:	f3 ab                	rep stos %eax,%es:(%edi)
  800c4b:	eb 06                	jmp    800c53 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	fc                   	cld    
  800c51:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c53:	89 f8                	mov    %edi,%eax
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c65:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c68:	39 c6                	cmp    %eax,%esi
  800c6a:	73 32                	jae    800c9e <memmove+0x44>
  800c6c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c6f:	39 c2                	cmp    %eax,%edx
  800c71:	76 2b                	jbe    800c9e <memmove+0x44>
		s += n;
		d += n;
  800c73:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c76:	89 fe                	mov    %edi,%esi
  800c78:	09 ce                	or     %ecx,%esi
  800c7a:	09 d6                	or     %edx,%esi
  800c7c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c82:	75 0e                	jne    800c92 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c84:	83 ef 04             	sub    $0x4,%edi
  800c87:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c8a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c8d:	fd                   	std    
  800c8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c90:	eb 09                	jmp    800c9b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c92:	83 ef 01             	sub    $0x1,%edi
  800c95:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c98:	fd                   	std    
  800c99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c9b:	fc                   	cld    
  800c9c:	eb 1a                	jmp    800cb8 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9e:	89 c2                	mov    %eax,%edx
  800ca0:	09 ca                	or     %ecx,%edx
  800ca2:	09 f2                	or     %esi,%edx
  800ca4:	f6 c2 03             	test   $0x3,%dl
  800ca7:	75 0a                	jne    800cb3 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	fc                   	cld    
  800caf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cb1:	eb 05                	jmp    800cb8 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800cb3:	89 c7                	mov    %eax,%edi
  800cb5:	fc                   	cld    
  800cb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cc2:	ff 75 10             	pushl  0x10(%ebp)
  800cc5:	ff 75 0c             	pushl  0xc(%ebp)
  800cc8:	ff 75 08             	pushl  0x8(%ebp)
  800ccb:	e8 8a ff ff ff       	call   800c5a <memmove>
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cdd:	89 c6                	mov    %eax,%esi
  800cdf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce2:	39 f0                	cmp    %esi,%eax
  800ce4:	74 1c                	je     800d02 <memcmp+0x30>
		if (*s1 != *s2)
  800ce6:	0f b6 08             	movzbl (%eax),%ecx
  800ce9:	0f b6 1a             	movzbl (%edx),%ebx
  800cec:	38 d9                	cmp    %bl,%cl
  800cee:	75 08                	jne    800cf8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cf0:	83 c0 01             	add    $0x1,%eax
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	eb ea                	jmp    800ce2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cf8:	0f b6 c1             	movzbl %cl,%eax
  800cfb:	0f b6 db             	movzbl %bl,%ebx
  800cfe:	29 d8                	sub    %ebx,%eax
  800d00:	eb 05                	jmp    800d07 <memcmp+0x35>
	}

	return 0;
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d14:	89 c2                	mov    %eax,%edx
  800d16:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d19:	39 d0                	cmp    %edx,%eax
  800d1b:	73 09                	jae    800d26 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d1d:	38 08                	cmp    %cl,(%eax)
  800d1f:	74 05                	je     800d26 <memfind+0x1b>
	for (; s < ends; s++)
  800d21:	83 c0 01             	add    $0x1,%eax
  800d24:	eb f3                	jmp    800d19 <memfind+0xe>
			break;
	return (void *) s;
}
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d34:	eb 03                	jmp    800d39 <strtol+0x11>
		s++;
  800d36:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d39:	0f b6 01             	movzbl (%ecx),%eax
  800d3c:	3c 20                	cmp    $0x20,%al
  800d3e:	74 f6                	je     800d36 <strtol+0xe>
  800d40:	3c 09                	cmp    $0x9,%al
  800d42:	74 f2                	je     800d36 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d44:	3c 2b                	cmp    $0x2b,%al
  800d46:	74 2a                	je     800d72 <strtol+0x4a>
	int neg = 0;
  800d48:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d4d:	3c 2d                	cmp    $0x2d,%al
  800d4f:	74 2b                	je     800d7c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d51:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d57:	75 0f                	jne    800d68 <strtol+0x40>
  800d59:	80 39 30             	cmpb   $0x30,(%ecx)
  800d5c:	74 28                	je     800d86 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d5e:	85 db                	test   %ebx,%ebx
  800d60:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d65:	0f 44 d8             	cmove  %eax,%ebx
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d70:	eb 50                	jmp    800dc2 <strtol+0x9a>
		s++;
  800d72:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d75:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7a:	eb d5                	jmp    800d51 <strtol+0x29>
		s++, neg = 1;
  800d7c:	83 c1 01             	add    $0x1,%ecx
  800d7f:	bf 01 00 00 00       	mov    $0x1,%edi
  800d84:	eb cb                	jmp    800d51 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d86:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d8a:	74 0e                	je     800d9a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d8c:	85 db                	test   %ebx,%ebx
  800d8e:	75 d8                	jne    800d68 <strtol+0x40>
		s++, base = 8;
  800d90:	83 c1 01             	add    $0x1,%ecx
  800d93:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d98:	eb ce                	jmp    800d68 <strtol+0x40>
		s += 2, base = 16;
  800d9a:	83 c1 02             	add    $0x2,%ecx
  800d9d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800da2:	eb c4                	jmp    800d68 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800da4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800da7:	89 f3                	mov    %esi,%ebx
  800da9:	80 fb 19             	cmp    $0x19,%bl
  800dac:	77 29                	ja     800dd7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800dae:	0f be d2             	movsbl %dl,%edx
  800db1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800db4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800db7:	7d 30                	jge    800de9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800db9:	83 c1 01             	add    $0x1,%ecx
  800dbc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800dc2:	0f b6 11             	movzbl (%ecx),%edx
  800dc5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800dc8:	89 f3                	mov    %esi,%ebx
  800dca:	80 fb 09             	cmp    $0x9,%bl
  800dcd:	77 d5                	ja     800da4 <strtol+0x7c>
			dig = *s - '0';
  800dcf:	0f be d2             	movsbl %dl,%edx
  800dd2:	83 ea 30             	sub    $0x30,%edx
  800dd5:	eb dd                	jmp    800db4 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800dd7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800dda:	89 f3                	mov    %esi,%ebx
  800ddc:	80 fb 19             	cmp    $0x19,%bl
  800ddf:	77 08                	ja     800de9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800de1:	0f be d2             	movsbl %dl,%edx
  800de4:	83 ea 37             	sub    $0x37,%edx
  800de7:	eb cb                	jmp    800db4 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800de9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ded:	74 05                	je     800df4 <strtol+0xcc>
		*endptr = (char *) s;
  800def:	8b 75 0c             	mov    0xc(%ebp),%esi
  800df2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800df4:	89 c2                	mov    %eax,%edx
  800df6:	f7 da                	neg    %edx
  800df8:	85 ff                	test   %edi,%edi
  800dfa:	0f 45 c2             	cmovne %edx,%eax
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
  800e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	89 c3                	mov    %eax,%ebx
  800e15:	89 c7                	mov    %eax,%edi
  800e17:	89 c6                	mov    %eax,%esi
  800e19:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  800e30:	89 d1                	mov    %edx,%ecx
  800e32:	89 d3                	mov    %edx,%ebx
  800e34:	89 d7                	mov    %edx,%edi
  800e36:	89 d6                	mov    %edx,%esi
  800e38:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	b8 03 00 00 00       	mov    $0x3,%eax
  800e55:	89 cb                	mov    %ecx,%ebx
  800e57:	89 cf                	mov    %ecx,%edi
  800e59:	89 ce                	mov    %ecx,%esi
  800e5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	7f 08                	jg     800e69 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	50                   	push   %eax
  800e6d:	6a 03                	push   $0x3
  800e6f:	68 00 2b 80 00       	push   $0x802b00
  800e74:	6a 43                	push   $0x43
  800e76:	68 1d 2b 80 00       	push   $0x802b1d
  800e7b:	e8 f7 f3 ff ff       	call   800277 <_panic>

00800e80 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	57                   	push   %edi
  800e84:	56                   	push   %esi
  800e85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e86:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8b:	b8 02 00 00 00       	mov    $0x2,%eax
  800e90:	89 d1                	mov    %edx,%ecx
  800e92:	89 d3                	mov    %edx,%ebx
  800e94:	89 d7                	mov    %edx,%edi
  800e96:	89 d6                	mov    %edx,%esi
  800e98:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_yield>:

void
sys_yield(void)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea5:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaa:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eaf:	89 d1                	mov    %edx,%ecx
  800eb1:	89 d3                	mov    %edx,%ebx
  800eb3:	89 d7                	mov    %edx,%edi
  800eb5:	89 d6                	mov    %edx,%esi
  800eb7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	57                   	push   %edi
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec7:	be 00 00 00 00       	mov    $0x0,%esi
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eda:	89 f7                	mov    %esi,%edi
  800edc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ede:	85 c0                	test   %eax,%eax
  800ee0:	7f 08                	jg     800eea <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	50                   	push   %eax
  800eee:	6a 04                	push   $0x4
  800ef0:	68 00 2b 80 00       	push   $0x802b00
  800ef5:	6a 43                	push   $0x43
  800ef7:	68 1d 2b 80 00       	push   $0x802b1d
  800efc:	e8 76 f3 ff ff       	call   800277 <_panic>

00800f01 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	57                   	push   %edi
  800f05:	56                   	push   %esi
  800f06:	53                   	push   %ebx
  800f07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f10:	b8 05 00 00 00       	mov    $0x5,%eax
  800f15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1b:	8b 75 18             	mov    0x18(%ebp),%esi
  800f1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f20:	85 c0                	test   %eax,%eax
  800f22:	7f 08                	jg     800f2c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	83 ec 0c             	sub    $0xc,%esp
  800f2f:	50                   	push   %eax
  800f30:	6a 05                	push   $0x5
  800f32:	68 00 2b 80 00       	push   $0x802b00
  800f37:	6a 43                	push   $0x43
  800f39:	68 1d 2b 80 00       	push   $0x802b1d
  800f3e:	e8 34 f3 ff ff       	call   800277 <_panic>

00800f43 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f57:	b8 06 00 00 00       	mov    $0x6,%eax
  800f5c:	89 df                	mov    %ebx,%edi
  800f5e:	89 de                	mov    %ebx,%esi
  800f60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7f 08                	jg     800f6e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	50                   	push   %eax
  800f72:	6a 06                	push   $0x6
  800f74:	68 00 2b 80 00       	push   $0x802b00
  800f79:	6a 43                	push   $0x43
  800f7b:	68 1d 2b 80 00       	push   $0x802b1d
  800f80:	e8 f2 f2 ff ff       	call   800277 <_panic>

00800f85 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	b8 08 00 00 00       	mov    $0x8,%eax
  800f9e:	89 df                	mov    %ebx,%edi
  800fa0:	89 de                	mov    %ebx,%esi
  800fa2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	7f 08                	jg     800fb0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	83 ec 0c             	sub    $0xc,%esp
  800fb3:	50                   	push   %eax
  800fb4:	6a 08                	push   $0x8
  800fb6:	68 00 2b 80 00       	push   $0x802b00
  800fbb:	6a 43                	push   $0x43
  800fbd:	68 1d 2b 80 00       	push   $0x802b1d
  800fc2:	e8 b0 f2 ff ff       	call   800277 <_panic>

00800fc7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	b8 09 00 00 00       	mov    $0x9,%eax
  800fe0:	89 df                	mov    %ebx,%edi
  800fe2:	89 de                	mov    %ebx,%esi
  800fe4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	7f 08                	jg     800ff2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fed:	5b                   	pop    %ebx
  800fee:	5e                   	pop    %esi
  800fef:	5f                   	pop    %edi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff2:	83 ec 0c             	sub    $0xc,%esp
  800ff5:	50                   	push   %eax
  800ff6:	6a 09                	push   $0x9
  800ff8:	68 00 2b 80 00       	push   $0x802b00
  800ffd:	6a 43                	push   $0x43
  800fff:	68 1d 2b 80 00       	push   $0x802b1d
  801004:	e8 6e f2 ff ff       	call   800277 <_panic>

00801009 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801022:	89 df                	mov    %ebx,%edi
  801024:	89 de                	mov    %ebx,%esi
  801026:	cd 30                	int    $0x30
	if(check && ret > 0)
  801028:	85 c0                	test   %eax,%eax
  80102a:	7f 08                	jg     801034 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	50                   	push   %eax
  801038:	6a 0a                	push   $0xa
  80103a:	68 00 2b 80 00       	push   $0x802b00
  80103f:	6a 43                	push   $0x43
  801041:	68 1d 2b 80 00       	push   $0x802b1d
  801046:	e8 2c f2 ff ff       	call   800277 <_panic>

0080104b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
	asm volatile("int %1\n"
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801057:	b8 0c 00 00 00       	mov    $0xc,%eax
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801064:	8b 7d 14             	mov    0x14(%ebp),%edi
  801067:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801077:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801084:	89 cb                	mov    %ecx,%ebx
  801086:	89 cf                	mov    %ecx,%edi
  801088:	89 ce                	mov    %ecx,%esi
  80108a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	7f 08                	jg     801098 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801098:	83 ec 0c             	sub    $0xc,%esp
  80109b:	50                   	push   %eax
  80109c:	6a 0d                	push   $0xd
  80109e:	68 00 2b 80 00       	push   $0x802b00
  8010a3:	6a 43                	push   $0x43
  8010a5:	68 1d 2b 80 00       	push   $0x802b1d
  8010aa:	e8 c8 f1 ff ff       	call   800277 <_panic>

008010af <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010c5:	89 df                	mov    %ebx,%edi
  8010c7:	89 de                	mov    %ebx,%esi
  8010c9:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010e3:	89 cb                	mov    %ecx,%ebx
  8010e5:	89 cf                	mov    %ecx,%edi
  8010e7:	89 ce                	mov    %ecx,%esi
  8010e9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 04             	sub    $0x4,%esp
	int r;
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  8010f7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010fe:	83 e1 07             	and    $0x7,%ecx
  801101:	83 f9 07             	cmp    $0x7,%ecx
  801104:	74 32                	je     801138 <duppage+0x48>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  801106:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80110d:	81 e1 05 08 00 00    	and    $0x805,%ecx
  801113:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  801119:	74 7d                	je     801198 <duppage+0xa8>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  80111b:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801122:	83 e1 05             	and    $0x5,%ecx
  801125:	83 f9 05             	cmp    $0x5,%ecx
  801128:	0f 84 9e 00 00 00    	je     8011cc <duppage+0xdc>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
  801133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801136:	c9                   	leave  
  801137:	c3                   	ret    
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801138:	89 d3                	mov    %edx,%ebx
  80113a:	c1 e3 0c             	shl    $0xc,%ebx
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	68 05 08 00 00       	push   $0x805
  801145:	53                   	push   %ebx
  801146:	50                   	push   %eax
  801147:	53                   	push   %ebx
  801148:	6a 00                	push   $0x0
  80114a:	e8 b2 fd ff ff       	call   800f01 <sys_page_map>
		if(r < 0)
  80114f:	83 c4 20             	add    $0x20,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	78 2e                	js     801184 <duppage+0x94>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 05 08 00 00       	push   $0x805
  80115e:	53                   	push   %ebx
  80115f:	6a 00                	push   $0x0
  801161:	53                   	push   %ebx
  801162:	6a 00                	push   $0x0
  801164:	e8 98 fd ff ff       	call   800f01 <sys_page_map>
		if(r < 0)
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 be                	jns    80112e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	68 2b 2b 80 00       	push   $0x802b2b
  801178:	6a 57                	push   $0x57
  80117a:	68 41 2b 80 00       	push   $0x802b41
  80117f:	e8 f3 f0 ff ff       	call   800277 <_panic>
			panic("sys_page_map() panic\n");
  801184:	83 ec 04             	sub    $0x4,%esp
  801187:	68 2b 2b 80 00       	push   $0x802b2b
  80118c:	6a 53                	push   $0x53
  80118e:	68 41 2b 80 00       	push   $0x802b41
  801193:	e8 df f0 ff ff       	call   800277 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801198:	c1 e2 0c             	shl    $0xc,%edx
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	68 05 08 00 00       	push   $0x805
  8011a3:	52                   	push   %edx
  8011a4:	50                   	push   %eax
  8011a5:	52                   	push   %edx
  8011a6:	6a 00                	push   $0x0
  8011a8:	e8 54 fd ff ff       	call   800f01 <sys_page_map>
		if(r < 0)
  8011ad:	83 c4 20             	add    $0x20,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	0f 89 76 ff ff ff    	jns    80112e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011b8:	83 ec 04             	sub    $0x4,%esp
  8011bb:	68 2b 2b 80 00       	push   $0x802b2b
  8011c0:	6a 5e                	push   $0x5e
  8011c2:	68 41 2b 80 00       	push   $0x802b41
  8011c7:	e8 ab f0 ff ff       	call   800277 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011cc:	c1 e2 0c             	shl    $0xc,%edx
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	6a 05                	push   $0x5
  8011d4:	52                   	push   %edx
  8011d5:	50                   	push   %eax
  8011d6:	52                   	push   %edx
  8011d7:	6a 00                	push   $0x0
  8011d9:	e8 23 fd ff ff       	call   800f01 <sys_page_map>
		if(r < 0)
  8011de:	83 c4 20             	add    $0x20,%esp
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	0f 89 45 ff ff ff    	jns    80112e <duppage+0x3e>
			panic("sys_page_map() panic\n");
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	68 2b 2b 80 00       	push   $0x802b2b
  8011f1:	6a 65                	push   $0x65
  8011f3:	68 41 2b 80 00       	push   $0x802b41
  8011f8:	e8 7a f0 ff ff       	call   800277 <_panic>

008011fd <pgfault>:
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	53                   	push   %ebx
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  801207:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801209:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  80120d:	0f 84 99 00 00 00    	je     8012ac <pgfault+0xaf>
  801213:	89 c2                	mov    %eax,%edx
  801215:	c1 ea 16             	shr    $0x16,%edx
  801218:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80121f:	f6 c2 01             	test   $0x1,%dl
  801222:	0f 84 84 00 00 00    	je     8012ac <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801228:	89 c2                	mov    %eax,%edx
  80122a:	c1 ea 0c             	shr    $0xc,%edx
  80122d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801234:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  80123a:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  801240:	75 6a                	jne    8012ac <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801247:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801249:	83 ec 04             	sub    $0x4,%esp
  80124c:	6a 07                	push   $0x7
  80124e:	68 00 f0 7f 00       	push   $0x7ff000
  801253:	6a 00                	push   $0x0
  801255:	e8 64 fc ff ff       	call   800ebe <sys_page_alloc>
	if(ret < 0)
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	85 c0                	test   %eax,%eax
  80125f:	78 5f                	js     8012c0 <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  801261:	83 ec 04             	sub    $0x4,%esp
  801264:	68 00 10 00 00       	push   $0x1000
  801269:	53                   	push   %ebx
  80126a:	68 00 f0 7f 00       	push   $0x7ff000
  80126f:	e8 48 fa ff ff       	call   800cbc <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801274:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80127b:	53                   	push   %ebx
  80127c:	6a 00                	push   $0x0
  80127e:	68 00 f0 7f 00       	push   $0x7ff000
  801283:	6a 00                	push   $0x0
  801285:	e8 77 fc ff ff       	call   800f01 <sys_page_map>
	if(ret < 0)
  80128a:	83 c4 20             	add    $0x20,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	78 43                	js     8012d4 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	68 00 f0 7f 00       	push   $0x7ff000
  801299:	6a 00                	push   $0x0
  80129b:	e8 a3 fc ff ff       	call   800f43 <sys_page_unmap>
	if(ret < 0)
  8012a0:	83 c4 10             	add    $0x10,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	78 41                	js     8012e8 <pgfault+0xeb>
}
  8012a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    
		panic("panic at pgfault()\n");
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 4c 2b 80 00       	push   $0x802b4c
  8012b4:	6a 26                	push   $0x26
  8012b6:	68 41 2b 80 00       	push   $0x802b41
  8012bb:	e8 b7 ef ff ff       	call   800277 <_panic>
		panic("panic in sys_page_alloc()\n");
  8012c0:	83 ec 04             	sub    $0x4,%esp
  8012c3:	68 60 2b 80 00       	push   $0x802b60
  8012c8:	6a 31                	push   $0x31
  8012ca:	68 41 2b 80 00       	push   $0x802b41
  8012cf:	e8 a3 ef ff ff       	call   800277 <_panic>
		panic("panic in sys_page_map()\n");
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	68 7b 2b 80 00       	push   $0x802b7b
  8012dc:	6a 36                	push   $0x36
  8012de:	68 41 2b 80 00       	push   $0x802b41
  8012e3:	e8 8f ef ff ff       	call   800277 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 94 2b 80 00       	push   $0x802b94
  8012f0:	6a 39                	push   $0x39
  8012f2:	68 41 2b 80 00       	push   $0x802b41
  8012f7:	e8 7b ef ff ff       	call   800277 <_panic>

008012fc <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	57                   	push   %edi
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	83 ec 18             	sub    $0x18,%esp
	// cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
	int ret;
	set_pgfault_handler(pgfault);
  801305:	68 fd 11 80 00       	push   $0x8011fd
  80130a:	e8 1c 0f 00 00       	call   80222b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80130f:	b8 07 00 00 00       	mov    $0x7,%eax
  801314:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	78 27                	js     801344 <fork+0x48>
  80131d:	89 c6                	mov    %eax,%esi
  80131f:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801321:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801326:	75 48                	jne    801370 <fork+0x74>
		thisenv = &envs[ENVX(sys_getenvid())];
  801328:	e8 53 fb ff ff       	call   800e80 <sys_getenvid>
  80132d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801332:	c1 e0 07             	shl    $0x7,%eax
  801335:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80133a:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80133f:	e9 90 00 00 00       	jmp    8013d4 <fork+0xd8>
		panic("the fork panic! at sys_exofork()\n");
  801344:	83 ec 04             	sub    $0x4,%esp
  801347:	68 b0 2b 80 00       	push   $0x802bb0
  80134c:	68 85 00 00 00       	push   $0x85
  801351:	68 41 2b 80 00       	push   $0x802b41
  801356:	e8 1c ef ff ff       	call   800277 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80135b:	89 f8                	mov    %edi,%eax
  80135d:	e8 8e fd ff ff       	call   8010f0 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801362:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801368:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80136e:	74 26                	je     801396 <fork+0x9a>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801370:	89 d8                	mov    %ebx,%eax
  801372:	c1 e8 16             	shr    $0x16,%eax
  801375:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80137c:	a8 01                	test   $0x1,%al
  80137e:	74 e2                	je     801362 <fork+0x66>
  801380:	89 da                	mov    %ebx,%edx
  801382:	c1 ea 0c             	shr    $0xc,%edx
  801385:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80138c:	83 e0 05             	and    $0x5,%eax
  80138f:	83 f8 05             	cmp    $0x5,%eax
  801392:	75 ce                	jne    801362 <fork+0x66>
  801394:	eb c5                	jmp    80135b <fork+0x5f>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	6a 07                	push   $0x7
  80139b:	68 00 f0 bf ee       	push   $0xeebff000
  8013a0:	56                   	push   %esi
  8013a1:	e8 18 fb ff ff       	call   800ebe <sys_page_alloc>
	if(ret < 0)
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 31                	js     8013de <fork+0xe2>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	68 9a 22 80 00       	push   $0x80229a
  8013b5:	56                   	push   %esi
  8013b6:	e8 4e fc ff ff       	call   801009 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 33                	js     8013f5 <fork+0xf9>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	6a 02                	push   $0x2
  8013c7:	56                   	push   %esi
  8013c8:	e8 b8 fb ff ff       	call   800f85 <sys_env_set_status>
	if(ret < 0)
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 38                	js     80140c <fork+0x110>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013d4:	89 f0                	mov    %esi,%eax
  8013d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5e                   	pop    %esi
  8013db:	5f                   	pop    %edi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013de:	83 ec 04             	sub    $0x4,%esp
  8013e1:	68 60 2b 80 00       	push   $0x802b60
  8013e6:	68 91 00 00 00       	push   $0x91
  8013eb:	68 41 2b 80 00       	push   $0x802b41
  8013f0:	e8 82 ee ff ff       	call   800277 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	68 d4 2b 80 00       	push   $0x802bd4
  8013fd:	68 94 00 00 00       	push   $0x94
  801402:	68 41 2b 80 00       	push   $0x802b41
  801407:	e8 6b ee ff ff       	call   800277 <_panic>
		panic("panic in sys_env_set_status()\n");
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 fc 2b 80 00       	push   $0x802bfc
  801414:	68 97 00 00 00       	push   $0x97
  801419:	68 41 2b 80 00       	push   $0x802b41
  80141e:	e8 54 ee ff ff       	call   800277 <_panic>

00801423 <sfork>:

// Challenge!
int
sfork(void)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	57                   	push   %edi
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 10             	sub    $0x10,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80142c:	a1 04 40 80 00       	mov    0x804004,%eax
  801431:	8b 40 48             	mov    0x48(%eax),%eax
  801434:	68 1c 2c 80 00       	push   $0x802c1c
  801439:	50                   	push   %eax
  80143a:	68 41 27 80 00       	push   $0x802741
  80143f:	e8 29 ef ff ff       	call   80036d <cprintf>
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  801444:	c7 04 24 fd 11 80 00 	movl   $0x8011fd,(%esp)
  80144b:	e8 db 0d 00 00       	call   80222b <set_pgfault_handler>
  801450:	b8 07 00 00 00       	mov    $0x7,%eax
  801455:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 27                	js     801485 <sfork+0x62>
  80145e:	89 c7                	mov    %eax,%edi
  801460:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801462:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801467:	75 55                	jne    8014be <sfork+0x9b>
		thisenv = &envs[ENVX(sys_getenvid())];
  801469:	e8 12 fa ff ff       	call   800e80 <sys_getenvid>
  80146e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801473:	c1 e0 07             	shl    $0x7,%eax
  801476:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80147b:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801480:	e9 d4 00 00 00       	jmp    801559 <sfork+0x136>
		panic("the fork panic! at sys_exofork()\n");
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	68 b0 2b 80 00       	push   $0x802bb0
  80148d:	68 a9 00 00 00       	push   $0xa9
  801492:	68 41 2b 80 00       	push   $0x802b41
  801497:	e8 db ed ff ff       	call   800277 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  80149c:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8014a1:	89 f0                	mov    %esi,%eax
  8014a3:	e8 48 fc ff ff       	call   8010f0 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8014a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014ae:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  8014b4:	77 65                	ja     80151b <sfork+0xf8>
		if(i == (USTACKTOP - PGSIZE))
  8014b6:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8014bc:	74 de                	je     80149c <sfork+0x79>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  8014be:	89 d8                	mov    %ebx,%eax
  8014c0:	c1 e8 16             	shr    $0x16,%eax
  8014c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014ca:	a8 01                	test   $0x1,%al
  8014cc:	74 da                	je     8014a8 <sfork+0x85>
  8014ce:	89 da                	mov    %ebx,%edx
  8014d0:	c1 ea 0c             	shr    $0xc,%edx
  8014d3:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014da:	83 e0 05             	and    $0x5,%eax
  8014dd:	83 f8 05             	cmp    $0x5,%eax
  8014e0:	75 c6                	jne    8014a8 <sfork+0x85>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014e2:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014e9:	c1 e2 0c             	shl    $0xc,%edx
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	83 e0 07             	and    $0x7,%eax
  8014f2:	50                   	push   %eax
  8014f3:	52                   	push   %edx
  8014f4:	56                   	push   %esi
  8014f5:	52                   	push   %edx
  8014f6:	6a 00                	push   $0x0
  8014f8:	e8 04 fa ff ff       	call   800f01 <sys_page_map>
  8014fd:	83 c4 20             	add    $0x20,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	74 a4                	je     8014a8 <sfork+0x85>
				panic("sys_page_map() panic\n");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 2b 2b 80 00       	push   $0x802b2b
  80150c:	68 b4 00 00 00       	push   $0xb4
  801511:	68 41 2b 80 00       	push   $0x802b41
  801516:	e8 5c ed ff ff       	call   800277 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	6a 07                	push   $0x7
  801520:	68 00 f0 bf ee       	push   $0xeebff000
  801525:	57                   	push   %edi
  801526:	e8 93 f9 ff ff       	call   800ebe <sys_page_alloc>
	if(ret < 0)
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 31                	js     801563 <sfork+0x140>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	68 9a 22 80 00       	push   $0x80229a
  80153a:	57                   	push   %edi
  80153b:	e8 c9 fa ff ff       	call   801009 <sys_env_set_pgfault_upcall>
	if(ret < 0)
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 33                	js     80157a <sfork+0x157>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	6a 02                	push   $0x2
  80154c:	57                   	push   %edi
  80154d:	e8 33 fa ff ff       	call   800f85 <sys_env_set_status>
	if(ret < 0)
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	78 38                	js     801591 <sfork+0x16e>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801559:	89 f8                	mov    %edi,%eax
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	68 60 2b 80 00       	push   $0x802b60
  80156b:	68 ba 00 00 00       	push   $0xba
  801570:	68 41 2b 80 00       	push   $0x802b41
  801575:	e8 fd ec ff ff       	call   800277 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 d4 2b 80 00       	push   $0x802bd4
  801582:	68 bd 00 00 00       	push   $0xbd
  801587:	68 41 2b 80 00       	push   $0x802b41
  80158c:	e8 e6 ec ff ff       	call   800277 <_panic>
		panic("panic in sys_env_set_status()\n");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 fc 2b 80 00       	push   $0x802bfc
  801599:	68 c0 00 00 00       	push   $0xc0
  80159e:	68 41 2b 80 00       	push   $0x802b41
  8015a3:	e8 cf ec ff ff       	call   800277 <_panic>

008015a8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	05 00 00 00 30       	add    $0x30000000,%eax
  8015b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d7:	89 c2                	mov    %eax,%edx
  8015d9:	c1 ea 16             	shr    $0x16,%edx
  8015dc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015e3:	f6 c2 01             	test   $0x1,%dl
  8015e6:	74 2d                	je     801615 <fd_alloc+0x46>
  8015e8:	89 c2                	mov    %eax,%edx
  8015ea:	c1 ea 0c             	shr    $0xc,%edx
  8015ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f4:	f6 c2 01             	test   $0x1,%dl
  8015f7:	74 1c                	je     801615 <fd_alloc+0x46>
  8015f9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015fe:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801603:	75 d2                	jne    8015d7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80160e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801613:	eb 0a                	jmp    80161f <fd_alloc+0x50>
			*fd_store = fd;
  801615:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801618:	89 01                	mov    %eax,(%ecx)
			return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	5d                   	pop    %ebp
  801620:	c3                   	ret    

00801621 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801627:	83 f8 1f             	cmp    $0x1f,%eax
  80162a:	77 30                	ja     80165c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80162c:	c1 e0 0c             	shl    $0xc,%eax
  80162f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801634:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80163a:	f6 c2 01             	test   $0x1,%dl
  80163d:	74 24                	je     801663 <fd_lookup+0x42>
  80163f:	89 c2                	mov    %eax,%edx
  801641:	c1 ea 0c             	shr    $0xc,%edx
  801644:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80164b:	f6 c2 01             	test   $0x1,%dl
  80164e:	74 1a                	je     80166a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801650:	8b 55 0c             	mov    0xc(%ebp),%edx
  801653:	89 02                	mov    %eax,(%edx)
	return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	5d                   	pop    %ebp
  80165b:	c3                   	ret    
		return -E_INVAL;
  80165c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801661:	eb f7                	jmp    80165a <fd_lookup+0x39>
		return -E_INVAL;
  801663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801668:	eb f0                	jmp    80165a <fd_lookup+0x39>
  80166a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166f:	eb e9                	jmp    80165a <fd_lookup+0x39>

00801671 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
  801677:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80167a:	ba a0 2c 80 00       	mov    $0x802ca0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80167f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801684:	39 08                	cmp    %ecx,(%eax)
  801686:	74 33                	je     8016bb <dev_lookup+0x4a>
  801688:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80168b:	8b 02                	mov    (%edx),%eax
  80168d:	85 c0                	test   %eax,%eax
  80168f:	75 f3                	jne    801684 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801691:	a1 04 40 80 00       	mov    0x804004,%eax
  801696:	8b 40 48             	mov    0x48(%eax),%eax
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	51                   	push   %ecx
  80169d:	50                   	push   %eax
  80169e:	68 24 2c 80 00       	push   $0x802c24
  8016a3:	e8 c5 ec ff ff       	call   80036d <cprintf>
	*dev = 0;
  8016a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
			*dev = devtab[i];
  8016bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c5:	eb f2                	jmp    8016b9 <dev_lookup+0x48>

008016c7 <fd_close>:
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	57                   	push   %edi
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 24             	sub    $0x24,%esp
  8016d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d9:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016da:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016e0:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e3:	50                   	push   %eax
  8016e4:	e8 38 ff ff ff       	call   801621 <fd_lookup>
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 05                	js     8016f7 <fd_close+0x30>
	    || fd != fd2)
  8016f2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016f5:	74 16                	je     80170d <fd_close+0x46>
		return (must_exist ? r : 0);
  8016f7:	89 f8                	mov    %edi,%eax
  8016f9:	84 c0                	test   %al,%al
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	0f 44 d8             	cmove  %eax,%ebx
}
  801703:	89 d8                	mov    %ebx,%eax
  801705:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801713:	50                   	push   %eax
  801714:	ff 36                	pushl  (%esi)
  801716:	e8 56 ff ff ff       	call   801671 <dev_lookup>
  80171b:	89 c3                	mov    %eax,%ebx
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	78 1a                	js     80173e <fd_close+0x77>
		if (dev->dev_close)
  801724:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801727:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80172a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 0b                	je     80173e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	56                   	push   %esi
  801737:	ff d0                	call   *%eax
  801739:	89 c3                	mov    %eax,%ebx
  80173b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	56                   	push   %esi
  801742:	6a 00                	push   $0x0
  801744:	e8 fa f7 ff ff       	call   800f43 <sys_page_unmap>
	return r;
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	eb b5                	jmp    801703 <fd_close+0x3c>

0080174e <close>:

int
close(int fdnum)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 c1 fe ff ff       	call   801621 <fd_lookup>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	79 02                	jns    801769 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    
		return fd_close(fd, 1);
  801769:	83 ec 08             	sub    $0x8,%esp
  80176c:	6a 01                	push   $0x1
  80176e:	ff 75 f4             	pushl  -0xc(%ebp)
  801771:	e8 51 ff ff ff       	call   8016c7 <fd_close>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	eb ec                	jmp    801767 <close+0x19>

0080177b <close_all>:

void
close_all(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801782:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	53                   	push   %ebx
  80178b:	e8 be ff ff ff       	call   80174e <close>
	for (i = 0; i < MAXFD; i++)
  801790:	83 c3 01             	add    $0x1,%ebx
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	83 fb 20             	cmp    $0x20,%ebx
  801799:	75 ec                	jne    801787 <close_all+0xc>
}
  80179b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	57                   	push   %edi
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	ff 75 08             	pushl  0x8(%ebp)
  8017b0:	e8 6c fe ff ff       	call   801621 <fd_lookup>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	0f 88 81 00 00 00    	js     801843 <dup+0xa3>
		return r;
	close(newfdnum);
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	e8 81 ff ff ff       	call   80174e <close>

	newfd = INDEX2FD(newfdnum);
  8017cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017d0:	c1 e6 0c             	shl    $0xc,%esi
  8017d3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017d9:	83 c4 04             	add    $0x4,%esp
  8017dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017df:	e8 d4 fd ff ff       	call   8015b8 <fd2data>
  8017e4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017e6:	89 34 24             	mov    %esi,(%esp)
  8017e9:	e8 ca fd ff ff       	call   8015b8 <fd2data>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017f3:	89 d8                	mov    %ebx,%eax
  8017f5:	c1 e8 16             	shr    $0x16,%eax
  8017f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ff:	a8 01                	test   $0x1,%al
  801801:	74 11                	je     801814 <dup+0x74>
  801803:	89 d8                	mov    %ebx,%eax
  801805:	c1 e8 0c             	shr    $0xc,%eax
  801808:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80180f:	f6 c2 01             	test   $0x1,%dl
  801812:	75 39                	jne    80184d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801814:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801817:	89 d0                	mov    %edx,%eax
  801819:	c1 e8 0c             	shr    $0xc,%eax
  80181c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801823:	83 ec 0c             	sub    $0xc,%esp
  801826:	25 07 0e 00 00       	and    $0xe07,%eax
  80182b:	50                   	push   %eax
  80182c:	56                   	push   %esi
  80182d:	6a 00                	push   $0x0
  80182f:	52                   	push   %edx
  801830:	6a 00                	push   $0x0
  801832:	e8 ca f6 ff ff       	call   800f01 <sys_page_map>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	83 c4 20             	add    $0x20,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 31                	js     801871 <dup+0xd1>
		goto err;

	return newfdnum;
  801840:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801843:	89 d8                	mov    %ebx,%eax
  801845:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5f                   	pop    %edi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80184d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	25 07 0e 00 00       	and    $0xe07,%eax
  80185c:	50                   	push   %eax
  80185d:	57                   	push   %edi
  80185e:	6a 00                	push   $0x0
  801860:	53                   	push   %ebx
  801861:	6a 00                	push   $0x0
  801863:	e8 99 f6 ff ff       	call   800f01 <sys_page_map>
  801868:	89 c3                	mov    %eax,%ebx
  80186a:	83 c4 20             	add    $0x20,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	79 a3                	jns    801814 <dup+0x74>
	sys_page_unmap(0, newfd);
  801871:	83 ec 08             	sub    $0x8,%esp
  801874:	56                   	push   %esi
  801875:	6a 00                	push   $0x0
  801877:	e8 c7 f6 ff ff       	call   800f43 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80187c:	83 c4 08             	add    $0x8,%esp
  80187f:	57                   	push   %edi
  801880:	6a 00                	push   $0x0
  801882:	e8 bc f6 ff ff       	call   800f43 <sys_page_unmap>
	return r;
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	eb b7                	jmp    801843 <dup+0xa3>

0080188c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	53                   	push   %ebx
  801890:	83 ec 1c             	sub    $0x1c,%esp
  801893:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801896:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801899:	50                   	push   %eax
  80189a:	53                   	push   %ebx
  80189b:	e8 81 fd ff ff       	call   801621 <fd_lookup>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 3f                	js     8018e6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ad:	50                   	push   %eax
  8018ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b1:	ff 30                	pushl  (%eax)
  8018b3:	e8 b9 fd ff ff       	call   801671 <dev_lookup>
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 27                	js     8018e6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c2:	8b 42 08             	mov    0x8(%edx),%eax
  8018c5:	83 e0 03             	and    $0x3,%eax
  8018c8:	83 f8 01             	cmp    $0x1,%eax
  8018cb:	74 1e                	je     8018eb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	8b 40 08             	mov    0x8(%eax),%eax
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	74 35                	je     80190c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	ff 75 10             	pushl  0x10(%ebp)
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	52                   	push   %edx
  8018e1:	ff d0                	call   *%eax
  8018e3:	83 c4 10             	add    $0x10,%esp
}
  8018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8018f0:	8b 40 48             	mov    0x48(%eax),%eax
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	53                   	push   %ebx
  8018f7:	50                   	push   %eax
  8018f8:	68 65 2c 80 00       	push   $0x802c65
  8018fd:	e8 6b ea ff ff       	call   80036d <cprintf>
		return -E_INVAL;
  801902:	83 c4 10             	add    $0x10,%esp
  801905:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80190a:	eb da                	jmp    8018e6 <read+0x5a>
		return -E_NOT_SUPP;
  80190c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801911:	eb d3                	jmp    8018e6 <read+0x5a>

00801913 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	57                   	push   %edi
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80191f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801922:	bb 00 00 00 00       	mov    $0x0,%ebx
  801927:	39 f3                	cmp    %esi,%ebx
  801929:	73 23                	jae    80194e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	89 f0                	mov    %esi,%eax
  801930:	29 d8                	sub    %ebx,%eax
  801932:	50                   	push   %eax
  801933:	89 d8                	mov    %ebx,%eax
  801935:	03 45 0c             	add    0xc(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	57                   	push   %edi
  80193a:	e8 4d ff ff ff       	call   80188c <read>
		if (m < 0)
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 06                	js     80194c <readn+0x39>
			return m;
		if (m == 0)
  801946:	74 06                	je     80194e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801948:	01 c3                	add    %eax,%ebx
  80194a:	eb db                	jmp    801927 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80194c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801953:	5b                   	pop    %ebx
  801954:	5e                   	pop    %esi
  801955:	5f                   	pop    %edi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    

00801958 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	53                   	push   %ebx
  80195c:	83 ec 1c             	sub    $0x1c,%esp
  80195f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801962:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801965:	50                   	push   %eax
  801966:	53                   	push   %ebx
  801967:	e8 b5 fc ff ff       	call   801621 <fd_lookup>
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 3a                	js     8019ad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801979:	50                   	push   %eax
  80197a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197d:	ff 30                	pushl  (%eax)
  80197f:	e8 ed fc ff ff       	call   801671 <dev_lookup>
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	78 22                	js     8019ad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801992:	74 1e                	je     8019b2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801997:	8b 52 0c             	mov    0xc(%edx),%edx
  80199a:	85 d2                	test   %edx,%edx
  80199c:	74 35                	je     8019d3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	ff 75 10             	pushl  0x10(%ebp)
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	ff d2                	call   *%edx
  8019aa:	83 c4 10             	add    $0x10,%esp
}
  8019ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8019b7:	8b 40 48             	mov    0x48(%eax),%eax
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	53                   	push   %ebx
  8019be:	50                   	push   %eax
  8019bf:	68 81 2c 80 00       	push   $0x802c81
  8019c4:	e8 a4 e9 ff ff       	call   80036d <cprintf>
		return -E_INVAL;
  8019c9:	83 c4 10             	add    $0x10,%esp
  8019cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d1:	eb da                	jmp    8019ad <write+0x55>
		return -E_NOT_SUPP;
  8019d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d8:	eb d3                	jmp    8019ad <write+0x55>

008019da <seek>:

int
seek(int fdnum, off_t offset)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	e8 35 fc ff ff       	call   801621 <fd_lookup>
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 0e                	js     801a01 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	53                   	push   %ebx
  801a07:	83 ec 1c             	sub    $0x1c,%esp
  801a0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a10:	50                   	push   %eax
  801a11:	53                   	push   %ebx
  801a12:	e8 0a fc ff ff       	call   801621 <fd_lookup>
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 37                	js     801a55 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a24:	50                   	push   %eax
  801a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a28:	ff 30                	pushl  (%eax)
  801a2a:	e8 42 fc ff ff       	call   801671 <dev_lookup>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1f                	js     801a55 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3d:	74 1b                	je     801a5a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 52 18             	mov    0x18(%edx),%edx
  801a45:	85 d2                	test   %edx,%edx
  801a47:	74 32                	je     801a7b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a49:	83 ec 08             	sub    $0x8,%esp
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	ff d2                	call   *%edx
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a5a:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a5f:	8b 40 48             	mov    0x48(%eax),%eax
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	53                   	push   %ebx
  801a66:	50                   	push   %eax
  801a67:	68 44 2c 80 00       	push   $0x802c44
  801a6c:	e8 fc e8 ff ff       	call   80036d <cprintf>
		return -E_INVAL;
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a79:	eb da                	jmp    801a55 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a80:	eb d3                	jmp    801a55 <ftruncate+0x52>

00801a82 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	53                   	push   %ebx
  801a86:	83 ec 1c             	sub    $0x1c,%esp
  801a89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8f:	50                   	push   %eax
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	e8 89 fb ff ff       	call   801621 <fd_lookup>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 4b                	js     801aea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa5:	50                   	push   %eax
  801aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa9:	ff 30                	pushl  (%eax)
  801aab:	e8 c1 fb ff ff       	call   801671 <dev_lookup>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 33                	js     801aea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801abe:	74 2f                	je     801aef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ac0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ac3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aca:	00 00 00 
	stat->st_isdir = 0;
  801acd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad4:	00 00 00 
	stat->st_dev = dev;
  801ad7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	53                   	push   %ebx
  801ae1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae4:	ff 50 14             	call   *0x14(%eax)
  801ae7:	83 c4 10             	add    $0x10,%esp
}
  801aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
		return -E_NOT_SUPP;
  801aef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af4:	eb f4                	jmp    801aea <fstat+0x68>

00801af6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	56                   	push   %esi
  801afa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801afb:	83 ec 08             	sub    $0x8,%esp
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	e8 bb 01 00 00       	call   801cc3 <open>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 1b                	js     801b2c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	e8 65 ff ff ff       	call   801a82 <fstat>
  801b1d:	89 c6                	mov    %eax,%esi
	close(fd);
  801b1f:	89 1c 24             	mov    %ebx,(%esp)
  801b22:	e8 27 fc ff ff       	call   80174e <close>
	return r;
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	89 f3                	mov    %esi,%ebx
}
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	89 c6                	mov    %eax,%esi
  801b3c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b3e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b45:	74 27                	je     801b6e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b47:	6a 07                	push   $0x7
  801b49:	68 00 50 80 00       	push   $0x805000
  801b4e:	56                   	push   %esi
  801b4f:	ff 35 00 40 80 00    	pushl  0x804000
  801b55:	e8 cf 07 00 00       	call   802329 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b5a:	83 c4 0c             	add    $0xc,%esp
  801b5d:	6a 00                	push   $0x0
  801b5f:	53                   	push   %ebx
  801b60:	6a 00                	push   $0x0
  801b62:	e8 59 07 00 00       	call   8022c0 <ipc_recv>
}
  801b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	6a 01                	push   $0x1
  801b73:	e8 09 08 00 00       	call   802381 <ipc_find_env>
  801b78:	a3 00 40 80 00       	mov    %eax,0x804000
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	eb c5                	jmp    801b47 <fsipc+0x12>

00801b82 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b96:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba0:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba5:	e8 8b ff ff ff       	call   801b35 <fsipc>
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <devfile_flush>:
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc2:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc7:	e8 69 ff ff ff       	call   801b35 <fsipc>
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <devfile_stat>:
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801bde:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801be3:	ba 00 00 00 00       	mov    $0x0,%edx
  801be8:	b8 05 00 00 00       	mov    $0x5,%eax
  801bed:	e8 43 ff ff ff       	call   801b35 <fsipc>
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	78 2c                	js     801c22 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bf6:	83 ec 08             	sub    $0x8,%esp
  801bf9:	68 00 50 80 00       	push   $0x805000
  801bfe:	53                   	push   %ebx
  801bff:	e8 c8 ee ff ff       	call   800acc <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c04:	a1 80 50 80 00       	mov    0x805080,%eax
  801c09:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c0f:	a1 84 50 80 00       	mov    0x805084,%eax
  801c14:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <devfile_write>:
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  801c2d:	68 b0 2c 80 00       	push   $0x802cb0
  801c32:	68 90 00 00 00       	push   $0x90
  801c37:	68 ce 2c 80 00       	push   $0x802cce
  801c3c:	e8 36 e6 ff ff       	call   800277 <_panic>

00801c41 <devfile_read>:
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	56                   	push   %esi
  801c45:	53                   	push   %ebx
  801c46:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c54:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  801c64:	e8 cc fe ff ff       	call   801b35 <fsipc>
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 1f                	js     801c8e <devfile_read+0x4d>
	assert(r <= n);
  801c6f:	39 f0                	cmp    %esi,%eax
  801c71:	77 24                	ja     801c97 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c73:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c78:	7f 33                	jg     801cad <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	50                   	push   %eax
  801c7e:	68 00 50 80 00       	push   $0x805000
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	e8 cf ef ff ff       	call   800c5a <memmove>
	return r;
  801c8b:	83 c4 10             	add    $0x10,%esp
}
  801c8e:	89 d8                	mov    %ebx,%eax
  801c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    
	assert(r <= n);
  801c97:	68 d9 2c 80 00       	push   $0x802cd9
  801c9c:	68 e0 2c 80 00       	push   $0x802ce0
  801ca1:	6a 7c                	push   $0x7c
  801ca3:	68 ce 2c 80 00       	push   $0x802cce
  801ca8:	e8 ca e5 ff ff       	call   800277 <_panic>
	assert(r <= PGSIZE);
  801cad:	68 f5 2c 80 00       	push   $0x802cf5
  801cb2:	68 e0 2c 80 00       	push   $0x802ce0
  801cb7:	6a 7d                	push   $0x7d
  801cb9:	68 ce 2c 80 00       	push   $0x802cce
  801cbe:	e8 b4 e5 ff ff       	call   800277 <_panic>

00801cc3 <open>:
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
  801ccb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cce:	56                   	push   %esi
  801ccf:	e8 bf ed ff ff       	call   800a93 <strlen>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cdc:	7f 6c                	jg     801d4a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	e8 e5 f8 ff ff       	call   8015cf <fd_alloc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 3c                	js     801d2f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cf3:	83 ec 08             	sub    $0x8,%esp
  801cf6:	56                   	push   %esi
  801cf7:	68 00 50 80 00       	push   $0x805000
  801cfc:	e8 cb ed ff ff       	call   800acc <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d04:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d11:	e8 1f fe ff ff       	call   801b35 <fsipc>
  801d16:	89 c3                	mov    %eax,%ebx
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 19                	js     801d38 <open+0x75>
	return fd2num(fd);
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	ff 75 f4             	pushl  -0xc(%ebp)
  801d25:	e8 7e f8 ff ff       	call   8015a8 <fd2num>
  801d2a:	89 c3                	mov    %eax,%ebx
  801d2c:	83 c4 10             	add    $0x10,%esp
}
  801d2f:	89 d8                	mov    %ebx,%eax
  801d31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
		fd_close(fd, 0);
  801d38:	83 ec 08             	sub    $0x8,%esp
  801d3b:	6a 00                	push   $0x0
  801d3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d40:	e8 82 f9 ff ff       	call   8016c7 <fd_close>
		return r;
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	eb e5                	jmp    801d2f <open+0x6c>
		return -E_BAD_PATH;
  801d4a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d4f:	eb de                	jmp    801d2f <open+0x6c>

00801d51 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d57:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d61:	e8 cf fd ff ff       	call   801b35 <fsipc>
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	56                   	push   %esi
  801d6c:	53                   	push   %ebx
  801d6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	ff 75 08             	pushl  0x8(%ebp)
  801d76:	e8 3d f8 ff ff       	call   8015b8 <fd2data>
  801d7b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d7d:	83 c4 08             	add    $0x8,%esp
  801d80:	68 01 2d 80 00       	push   $0x802d01
  801d85:	53                   	push   %ebx
  801d86:	e8 41 ed ff ff       	call   800acc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d8b:	8b 46 04             	mov    0x4(%esi),%eax
  801d8e:	2b 06                	sub    (%esi),%eax
  801d90:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d96:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d9d:	00 00 00 
	stat->st_dev = &devpipe;
  801da0:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801da7:	30 80 00 
	return 0;
}
  801daa:	b8 00 00 00 00       	mov    $0x0,%eax
  801daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    

00801db6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	53                   	push   %ebx
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dc0:	53                   	push   %ebx
  801dc1:	6a 00                	push   $0x0
  801dc3:	e8 7b f1 ff ff       	call   800f43 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dc8:	89 1c 24             	mov    %ebx,(%esp)
  801dcb:	e8 e8 f7 ff ff       	call   8015b8 <fd2data>
  801dd0:	83 c4 08             	add    $0x8,%esp
  801dd3:	50                   	push   %eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	e8 68 f1 ff ff       	call   800f43 <sys_page_unmap>
}
  801ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <_pipeisclosed>:
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	57                   	push   %edi
  801de4:	56                   	push   %esi
  801de5:	53                   	push   %ebx
  801de6:	83 ec 1c             	sub    $0x1c,%esp
  801de9:	89 c7                	mov    %eax,%edi
  801deb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ded:	a1 04 40 80 00       	mov    0x804004,%eax
  801df2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	57                   	push   %edi
  801df9:	e8 be 05 00 00       	call   8023bc <pageref>
  801dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e01:	89 34 24             	mov    %esi,(%esp)
  801e04:	e8 b3 05 00 00       	call   8023bc <pageref>
		nn = thisenv->env_runs;
  801e09:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e0f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	39 cb                	cmp    %ecx,%ebx
  801e17:	74 1b                	je     801e34 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e19:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e1c:	75 cf                	jne    801ded <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e1e:	8b 42 58             	mov    0x58(%edx),%eax
  801e21:	6a 01                	push   $0x1
  801e23:	50                   	push   %eax
  801e24:	53                   	push   %ebx
  801e25:	68 08 2d 80 00       	push   $0x802d08
  801e2a:	e8 3e e5 ff ff       	call   80036d <cprintf>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	eb b9                	jmp    801ded <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e34:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e37:	0f 94 c0             	sete   %al
  801e3a:	0f b6 c0             	movzbl %al,%eax
}
  801e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <devpipe_write>:
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	57                   	push   %edi
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	83 ec 28             	sub    $0x28,%esp
  801e4e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e51:	56                   	push   %esi
  801e52:	e8 61 f7 ff ff       	call   8015b8 <fd2data>
  801e57:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e61:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e64:	74 4f                	je     801eb5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e66:	8b 43 04             	mov    0x4(%ebx),%eax
  801e69:	8b 0b                	mov    (%ebx),%ecx
  801e6b:	8d 51 20             	lea    0x20(%ecx),%edx
  801e6e:	39 d0                	cmp    %edx,%eax
  801e70:	72 14                	jb     801e86 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e72:	89 da                	mov    %ebx,%edx
  801e74:	89 f0                	mov    %esi,%eax
  801e76:	e8 65 ff ff ff       	call   801de0 <_pipeisclosed>
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	75 3b                	jne    801eba <devpipe_write+0x75>
			sys_yield();
  801e7f:	e8 1b f0 ff ff       	call   800e9f <sys_yield>
  801e84:	eb e0                	jmp    801e66 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e89:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e8d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e90:	89 c2                	mov    %eax,%edx
  801e92:	c1 fa 1f             	sar    $0x1f,%edx
  801e95:	89 d1                	mov    %edx,%ecx
  801e97:	c1 e9 1b             	shr    $0x1b,%ecx
  801e9a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e9d:	83 e2 1f             	and    $0x1f,%edx
  801ea0:	29 ca                	sub    %ecx,%edx
  801ea2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ea6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eaa:	83 c0 01             	add    $0x1,%eax
  801ead:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801eb0:	83 c7 01             	add    $0x1,%edi
  801eb3:	eb ac                	jmp    801e61 <devpipe_write+0x1c>
	return i;
  801eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb8:	eb 05                	jmp    801ebf <devpipe_write+0x7a>
				return 0;
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5f                   	pop    %edi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    

00801ec7 <devpipe_read>:
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	57                   	push   %edi
  801ecb:	56                   	push   %esi
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 18             	sub    $0x18,%esp
  801ed0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ed3:	57                   	push   %edi
  801ed4:	e8 df f6 ff ff       	call   8015b8 <fd2data>
  801ed9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801edb:	83 c4 10             	add    $0x10,%esp
  801ede:	be 00 00 00 00       	mov    $0x0,%esi
  801ee3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ee6:	75 14                	jne    801efc <devpipe_read+0x35>
	return i;
  801ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eeb:	eb 02                	jmp    801eef <devpipe_read+0x28>
				return i;
  801eed:	89 f0                	mov    %esi,%eax
}
  801eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    
			sys_yield();
  801ef7:	e8 a3 ef ff ff       	call   800e9f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801efc:	8b 03                	mov    (%ebx),%eax
  801efe:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f01:	75 18                	jne    801f1b <devpipe_read+0x54>
			if (i > 0)
  801f03:	85 f6                	test   %esi,%esi
  801f05:	75 e6                	jne    801eed <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f07:	89 da                	mov    %ebx,%edx
  801f09:	89 f8                	mov    %edi,%eax
  801f0b:	e8 d0 fe ff ff       	call   801de0 <_pipeisclosed>
  801f10:	85 c0                	test   %eax,%eax
  801f12:	74 e3                	je     801ef7 <devpipe_read+0x30>
				return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
  801f19:	eb d4                	jmp    801eef <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f1b:	99                   	cltd   
  801f1c:	c1 ea 1b             	shr    $0x1b,%edx
  801f1f:	01 d0                	add    %edx,%eax
  801f21:	83 e0 1f             	and    $0x1f,%eax
  801f24:	29 d0                	sub    %edx,%eax
  801f26:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f2e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f31:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f34:	83 c6 01             	add    $0x1,%esi
  801f37:	eb aa                	jmp    801ee3 <devpipe_read+0x1c>

00801f39 <pipe>:
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f44:	50                   	push   %eax
  801f45:	e8 85 f6 ff ff       	call   8015cf <fd_alloc>
  801f4a:	89 c3                	mov    %eax,%ebx
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	0f 88 23 01 00 00    	js     80207a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 07 04 00 00       	push   $0x407
  801f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f62:	6a 00                	push   $0x0
  801f64:	e8 55 ef ff ff       	call   800ebe <sys_page_alloc>
  801f69:	89 c3                	mov    %eax,%ebx
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	0f 88 04 01 00 00    	js     80207a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f7c:	50                   	push   %eax
  801f7d:	e8 4d f6 ff ff       	call   8015cf <fd_alloc>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	85 c0                	test   %eax,%eax
  801f89:	0f 88 db 00 00 00    	js     80206a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8f:	83 ec 04             	sub    $0x4,%esp
  801f92:	68 07 04 00 00       	push   $0x407
  801f97:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9a:	6a 00                	push   $0x0
  801f9c:	e8 1d ef ff ff       	call   800ebe <sys_page_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	0f 88 bc 00 00 00    	js     80206a <pipe+0x131>
	va = fd2data(fd0);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	e8 ff f5 ff ff       	call   8015b8 <fd2data>
  801fb9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbb:	83 c4 0c             	add    $0xc,%esp
  801fbe:	68 07 04 00 00       	push   $0x407
  801fc3:	50                   	push   %eax
  801fc4:	6a 00                	push   $0x0
  801fc6:	e8 f3 ee ff ff       	call   800ebe <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	0f 88 82 00 00 00    	js     80205a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fde:	e8 d5 f5 ff ff       	call   8015b8 <fd2data>
  801fe3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fea:	50                   	push   %eax
  801feb:	6a 00                	push   $0x0
  801fed:	56                   	push   %esi
  801fee:	6a 00                	push   $0x0
  801ff0:	e8 0c ef ff ff       	call   800f01 <sys_page_map>
  801ff5:	89 c3                	mov    %eax,%ebx
  801ff7:	83 c4 20             	add    $0x20,%esp
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 4e                	js     80204c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ffe:	a1 20 30 80 00       	mov    0x803020,%eax
  802003:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802006:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802012:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802015:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	ff 75 f4             	pushl  -0xc(%ebp)
  802027:	e8 7c f5 ff ff       	call   8015a8 <fd2num>
  80202c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802031:	83 c4 04             	add    $0x4,%esp
  802034:	ff 75 f0             	pushl  -0x10(%ebp)
  802037:	e8 6c f5 ff ff       	call   8015a8 <fd2num>
  80203c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	bb 00 00 00 00       	mov    $0x0,%ebx
  80204a:	eb 2e                	jmp    80207a <pipe+0x141>
	sys_page_unmap(0, va);
  80204c:	83 ec 08             	sub    $0x8,%esp
  80204f:	56                   	push   %esi
  802050:	6a 00                	push   $0x0
  802052:	e8 ec ee ff ff       	call   800f43 <sys_page_unmap>
  802057:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80205a:	83 ec 08             	sub    $0x8,%esp
  80205d:	ff 75 f0             	pushl  -0x10(%ebp)
  802060:	6a 00                	push   $0x0
  802062:	e8 dc ee ff ff       	call   800f43 <sys_page_unmap>
  802067:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80206a:	83 ec 08             	sub    $0x8,%esp
  80206d:	ff 75 f4             	pushl  -0xc(%ebp)
  802070:	6a 00                	push   $0x0
  802072:	e8 cc ee ff ff       	call   800f43 <sys_page_unmap>
  802077:	83 c4 10             	add    $0x10,%esp
}
  80207a:	89 d8                	mov    %ebx,%eax
  80207c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5d                   	pop    %ebp
  802082:	c3                   	ret    

00802083 <pipeisclosed>:
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802089:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208c:	50                   	push   %eax
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	e8 8c f5 ff ff       	call   801621 <fd_lookup>
  802095:	83 c4 10             	add    $0x10,%esp
  802098:	85 c0                	test   %eax,%eax
  80209a:	78 18                	js     8020b4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a2:	e8 11 f5 ff ff       	call   8015b8 <fd2data>
	return _pipeisclosed(fd, p);
  8020a7:	89 c2                	mov    %eax,%edx
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	e8 2f fd ff ff       	call   801de0 <_pipeisclosed>
  8020b1:	83 c4 10             	add    $0x10,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	c3                   	ret    

008020bc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020c2:	68 20 2d 80 00       	push   $0x802d20
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	e8 fd e9 ff ff       	call   800acc <strcpy>
	return 0;
}
  8020cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <devcons_write>:
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020e2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020e7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020ed:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f0:	73 31                	jae    802123 <devcons_write+0x4d>
		m = n - tot;
  8020f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020f5:	29 f3                	sub    %esi,%ebx
  8020f7:	83 fb 7f             	cmp    $0x7f,%ebx
  8020fa:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ff:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	53                   	push   %ebx
  802106:	89 f0                	mov    %esi,%eax
  802108:	03 45 0c             	add    0xc(%ebp),%eax
  80210b:	50                   	push   %eax
  80210c:	57                   	push   %edi
  80210d:	e8 48 eb ff ff       	call   800c5a <memmove>
		sys_cputs(buf, m);
  802112:	83 c4 08             	add    $0x8,%esp
  802115:	53                   	push   %ebx
  802116:	57                   	push   %edi
  802117:	e8 e6 ec ff ff       	call   800e02 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80211c:	01 de                	add    %ebx,%esi
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	eb ca                	jmp    8020ed <devcons_write+0x17>
}
  802123:	89 f0                	mov    %esi,%eax
  802125:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802128:	5b                   	pop    %ebx
  802129:	5e                   	pop    %esi
  80212a:	5f                   	pop    %edi
  80212b:	5d                   	pop    %ebp
  80212c:	c3                   	ret    

0080212d <devcons_read>:
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 08             	sub    $0x8,%esp
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802138:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213c:	74 21                	je     80215f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80213e:	e8 dd ec ff ff       	call   800e20 <sys_cgetc>
  802143:	85 c0                	test   %eax,%eax
  802145:	75 07                	jne    80214e <devcons_read+0x21>
		sys_yield();
  802147:	e8 53 ed ff ff       	call   800e9f <sys_yield>
  80214c:	eb f0                	jmp    80213e <devcons_read+0x11>
	if (c < 0)
  80214e:	78 0f                	js     80215f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802150:	83 f8 04             	cmp    $0x4,%eax
  802153:	74 0c                	je     802161 <devcons_read+0x34>
	*(char*)vbuf = c;
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	88 02                	mov    %al,(%edx)
	return 1;
  80215a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    
		return 0;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
  802166:	eb f7                	jmp    80215f <devcons_read+0x32>

00802168 <cputchar>:
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802174:	6a 01                	push   $0x1
  802176:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802179:	50                   	push   %eax
  80217a:	e8 83 ec ff ff       	call   800e02 <sys_cputs>
}
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <getchar>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80218a:	6a 01                	push   $0x1
  80218c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80218f:	50                   	push   %eax
  802190:	6a 00                	push   $0x0
  802192:	e8 f5 f6 ff ff       	call   80188c <read>
	if (r < 0)
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 06                	js     8021a4 <getchar+0x20>
	if (r < 1)
  80219e:	74 06                	je     8021a6 <getchar+0x22>
	return c;
  8021a0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    
		return -E_EOF;
  8021a6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021ab:	eb f7                	jmp    8021a4 <getchar+0x20>

008021ad <iscons>:
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b6:	50                   	push   %eax
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	e8 62 f4 ff ff       	call   801621 <fd_lookup>
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	78 11                	js     8021d7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021cf:	39 10                	cmp    %edx,(%eax)
  8021d1:	0f 94 c0             	sete   %al
  8021d4:	0f b6 c0             	movzbl %al,%eax
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <opencons>:
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e2:	50                   	push   %eax
  8021e3:	e8 e7 f3 ff ff       	call   8015cf <fd_alloc>
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	78 3a                	js     802229 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 07 04 00 00       	push   $0x407
  8021f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021fa:	6a 00                	push   $0x0
  8021fc:	e8 bd ec ff ff       	call   800ebe <sys_page_alloc>
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	85 c0                	test   %eax,%eax
  802206:	78 21                	js     802229 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802211:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	50                   	push   %eax
  802221:	e8 82 f3 ff ff       	call   8015a8 <fd2num>
  802226:	83 c4 10             	add    $0x10,%esp
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802231:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802238:	74 0a                	je     802244 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	6a 07                	push   $0x7
  802249:	68 00 f0 bf ee       	push   $0xeebff000
  80224e:	6a 00                	push   $0x0
  802250:	e8 69 ec ff ff       	call   800ebe <sys_page_alloc>
		if(r < 0)
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 2a                	js     802286 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80225c:	83 ec 08             	sub    $0x8,%esp
  80225f:	68 9a 22 80 00       	push   $0x80229a
  802264:	6a 00                	push   $0x0
  802266:	e8 9e ed ff ff       	call   801009 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	85 c0                	test   %eax,%eax
  802270:	79 c8                	jns    80223a <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	68 5c 2d 80 00       	push   $0x802d5c
  80227a:	6a 25                	push   $0x25
  80227c:	68 98 2d 80 00       	push   $0x802d98
  802281:	e8 f1 df ff ff       	call   800277 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 2c 2d 80 00       	push   $0x802d2c
  80228e:	6a 22                	push   $0x22
  802290:	68 98 2d 80 00       	push   $0x802d98
  802295:	e8 dd df ff ff       	call   800277 <_panic>

0080229a <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80229a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80229b:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  8022a0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8022a2:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8022a5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8022a9:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8022ad:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8022b0:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8022b2:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8022b6:	83 c4 08             	add    $0x8,%esp
	popal
  8022b9:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8022ba:	83 c4 04             	add    $0x4,%esp
	popfl
  8022bd:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8022be:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8022bf:	c3                   	ret    

008022c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	56                   	push   %esi
  8022c4:	53                   	push   %ebx
  8022c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8022ce:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022d0:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022d5:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	50                   	push   %eax
  8022dc:	e8 8d ed ff ff       	call   80106e <sys_ipc_recv>
	if(ret < 0){
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	78 2b                	js     802313 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022e8:	85 f6                	test   %esi,%esi
  8022ea:	74 0a                	je     8022f6 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022ec:	a1 04 40 80 00       	mov    0x804004,%eax
  8022f1:	8b 40 74             	mov    0x74(%eax),%eax
  8022f4:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022f6:	85 db                	test   %ebx,%ebx
  8022f8:	74 0a                	je     802304 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8022fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8022ff:	8b 40 78             	mov    0x78(%eax),%eax
  802302:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802304:	a1 04 40 80 00       	mov    0x804004,%eax
  802309:	8b 40 70             	mov    0x70(%eax),%eax
}
  80230c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    
		if(from_env_store)
  802313:	85 f6                	test   %esi,%esi
  802315:	74 06                	je     80231d <ipc_recv+0x5d>
			*from_env_store = 0;
  802317:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80231d:	85 db                	test   %ebx,%ebx
  80231f:	74 eb                	je     80230c <ipc_recv+0x4c>
			*perm_store = 0;
  802321:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802327:	eb e3                	jmp    80230c <ipc_recv+0x4c>

00802329 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	57                   	push   %edi
  80232d:	56                   	push   %esi
  80232e:	53                   	push   %ebx
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	8b 7d 08             	mov    0x8(%ebp),%edi
  802335:	8b 75 0c             	mov    0xc(%ebp),%esi
  802338:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80233b:	85 db                	test   %ebx,%ebx
  80233d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802342:	0f 44 d8             	cmove  %eax,%ebx
  802345:	eb 05                	jmp    80234c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802347:	e8 53 eb ff ff       	call   800e9f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80234c:	ff 75 14             	pushl  0x14(%ebp)
  80234f:	53                   	push   %ebx
  802350:	56                   	push   %esi
  802351:	57                   	push   %edi
  802352:	e8 f4 ec ff ff       	call   80104b <sys_ipc_try_send>
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	85 c0                	test   %eax,%eax
  80235c:	74 1b                	je     802379 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80235e:	79 e7                	jns    802347 <ipc_send+0x1e>
  802360:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802363:	74 e2                	je     802347 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 a6 2d 80 00       	push   $0x802da6
  80236d:	6a 49                	push   $0x49
  80236f:	68 bb 2d 80 00       	push   $0x802dbb
  802374:	e8 fe de ff ff       	call   800277 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802379:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    

00802381 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80238c:	89 c2                	mov    %eax,%edx
  80238e:	c1 e2 07             	shl    $0x7,%edx
  802391:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802397:	8b 52 50             	mov    0x50(%edx),%edx
  80239a:	39 ca                	cmp    %ecx,%edx
  80239c:	74 11                	je     8023af <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80239e:	83 c0 01             	add    $0x1,%eax
  8023a1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023a6:	75 e4                	jne    80238c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ad:	eb 0b                	jmp    8023ba <ipc_find_env+0x39>
			return envs[i].env_id;
  8023af:	c1 e0 07             	shl    $0x7,%eax
  8023b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023b7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    

008023bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	c1 e8 16             	shr    $0x16,%eax
  8023c7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023d3:	f6 c1 01             	test   $0x1,%cl
  8023d6:	74 1d                	je     8023f5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023d8:	c1 ea 0c             	shr    $0xc,%edx
  8023db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e2:	f6 c2 01             	test   $0x1,%dl
  8023e5:	74 0e                	je     8023f5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e7:	c1 ea 0c             	shr    $0xc,%edx
  8023ea:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f1:	ef 
  8023f2:	0f b7 c0             	movzwl %ax,%eax
}
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    
  8023f7:	66 90                	xchg   %ax,%ax
  8023f9:	66 90                	xchg   %ax,%ax
  8023fb:	66 90                	xchg   %ax,%ax
  8023fd:	66 90                	xchg   %ax,%ax
  8023ff:	90                   	nop

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80240b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80240f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802413:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802417:	85 d2                	test   %edx,%edx
  802419:	75 4d                	jne    802468 <__udivdi3+0x68>
  80241b:	39 f3                	cmp    %esi,%ebx
  80241d:	76 19                	jbe    802438 <__udivdi3+0x38>
  80241f:	31 ff                	xor    %edi,%edi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f2                	mov    %esi,%edx
  802425:	f7 f3                	div    %ebx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 d9                	mov    %ebx,%ecx
  80243a:	85 db                	test   %ebx,%ebx
  80243c:	75 0b                	jne    802449 <__udivdi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f3                	div    %ebx
  802447:	89 c1                	mov    %eax,%ecx
  802449:	31 d2                	xor    %edx,%edx
  80244b:	89 f0                	mov    %esi,%eax
  80244d:	f7 f1                	div    %ecx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	89 e8                	mov    %ebp,%eax
  802453:	89 f7                	mov    %esi,%edi
  802455:	f7 f1                	div    %ecx
  802457:	89 fa                	mov    %edi,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	39 f2                	cmp    %esi,%edx
  80246a:	77 1c                	ja     802488 <__udivdi3+0x88>
  80246c:	0f bd fa             	bsr    %edx,%edi
  80246f:	83 f7 1f             	xor    $0x1f,%edi
  802472:	75 2c                	jne    8024a0 <__udivdi3+0xa0>
  802474:	39 f2                	cmp    %esi,%edx
  802476:	72 06                	jb     80247e <__udivdi3+0x7e>
  802478:	31 c0                	xor    %eax,%eax
  80247a:	39 eb                	cmp    %ebp,%ebx
  80247c:	77 a9                	ja     802427 <__udivdi3+0x27>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	eb a2                	jmp    802427 <__udivdi3+0x27>
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	31 ff                	xor    %edi,%edi
  80248a:	31 c0                	xor    %eax,%eax
  80248c:	89 fa                	mov    %edi,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 f9                	mov    %edi,%ecx
  8024a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a7:	29 f8                	sub    %edi,%eax
  8024a9:	d3 e2                	shl    %cl,%edx
  8024ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024af:	89 c1                	mov    %eax,%ecx
  8024b1:	89 da                	mov    %ebx,%edx
  8024b3:	d3 ea                	shr    %cl,%edx
  8024b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b9:	09 d1                	or     %edx,%ecx
  8024bb:	89 f2                	mov    %esi,%edx
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 f9                	mov    %edi,%ecx
  8024c3:	d3 e3                	shl    %cl,%ebx
  8024c5:	89 c1                	mov    %eax,%ecx
  8024c7:	d3 ea                	shr    %cl,%edx
  8024c9:	89 f9                	mov    %edi,%ecx
  8024cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024cf:	89 eb                	mov    %ebp,%ebx
  8024d1:	d3 e6                	shl    %cl,%esi
  8024d3:	89 c1                	mov    %eax,%ecx
  8024d5:	d3 eb                	shr    %cl,%ebx
  8024d7:	09 de                	or     %ebx,%esi
  8024d9:	89 f0                	mov    %esi,%eax
  8024db:	f7 74 24 08          	divl   0x8(%esp)
  8024df:	89 d6                	mov    %edx,%esi
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	f7 64 24 0c          	mull   0xc(%esp)
  8024e7:	39 d6                	cmp    %edx,%esi
  8024e9:	72 15                	jb     802500 <__udivdi3+0x100>
  8024eb:	89 f9                	mov    %edi,%ecx
  8024ed:	d3 e5                	shl    %cl,%ebp
  8024ef:	39 c5                	cmp    %eax,%ebp
  8024f1:	73 04                	jae    8024f7 <__udivdi3+0xf7>
  8024f3:	39 d6                	cmp    %edx,%esi
  8024f5:	74 09                	je     802500 <__udivdi3+0x100>
  8024f7:	89 d8                	mov    %ebx,%eax
  8024f9:	31 ff                	xor    %edi,%edi
  8024fb:	e9 27 ff ff ff       	jmp    802427 <__udivdi3+0x27>
  802500:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802503:	31 ff                	xor    %edi,%edi
  802505:	e9 1d ff ff ff       	jmp    802427 <__udivdi3+0x27>
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__umoddi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80251b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80251f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	89 da                	mov    %ebx,%edx
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 43                	jne    802570 <__umoddi3+0x60>
  80252d:	39 df                	cmp    %ebx,%edi
  80252f:	76 17                	jbe    802548 <__umoddi3+0x38>
  802531:	89 f0                	mov    %esi,%eax
  802533:	f7 f7                	div    %edi
  802535:	89 d0                	mov    %edx,%eax
  802537:	31 d2                	xor    %edx,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	89 fd                	mov    %edi,%ebp
  80254a:	85 ff                	test   %edi,%edi
  80254c:	75 0b                	jne    802559 <__umoddi3+0x49>
  80254e:	b8 01 00 00 00       	mov    $0x1,%eax
  802553:	31 d2                	xor    %edx,%edx
  802555:	f7 f7                	div    %edi
  802557:	89 c5                	mov    %eax,%ebp
  802559:	89 d8                	mov    %ebx,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	f7 f5                	div    %ebp
  80255f:	89 f0                	mov    %esi,%eax
  802561:	f7 f5                	div    %ebp
  802563:	89 d0                	mov    %edx,%eax
  802565:	eb d0                	jmp    802537 <__umoddi3+0x27>
  802567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256e:	66 90                	xchg   %ax,%ax
  802570:	89 f1                	mov    %esi,%ecx
  802572:	39 d8                	cmp    %ebx,%eax
  802574:	76 0a                	jbe    802580 <__umoddi3+0x70>
  802576:	89 f0                	mov    %esi,%eax
  802578:	83 c4 1c             	add    $0x1c,%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	0f bd e8             	bsr    %eax,%ebp
  802583:	83 f5 1f             	xor    $0x1f,%ebp
  802586:	75 20                	jne    8025a8 <__umoddi3+0x98>
  802588:	39 d8                	cmp    %ebx,%eax
  80258a:	0f 82 b0 00 00 00    	jb     802640 <__umoddi3+0x130>
  802590:	39 f7                	cmp    %esi,%edi
  802592:	0f 86 a8 00 00 00    	jbe    802640 <__umoddi3+0x130>
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8025af:	29 ea                	sub    %ebp,%edx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b7:	89 d1                	mov    %edx,%ecx
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	d3 e8                	shr    %cl,%eax
  8025bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025c9:	09 c1                	or     %eax,%ecx
  8025cb:	89 d8                	mov    %ebx,%eax
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 e9                	mov    %ebp,%ecx
  8025d3:	d3 e7                	shl    %cl,%edi
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	d3 e8                	shr    %cl,%eax
  8025d9:	89 e9                	mov    %ebp,%ecx
  8025db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025df:	d3 e3                	shl    %cl,%ebx
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	89 d1                	mov    %edx,%ecx
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	d3 e6                	shl    %cl,%esi
  8025ef:	09 d8                	or     %ebx,%eax
  8025f1:	f7 74 24 08          	divl   0x8(%esp)
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	89 f3                	mov    %esi,%ebx
  8025f9:	f7 64 24 0c          	mull   0xc(%esp)
  8025fd:	89 c6                	mov    %eax,%esi
  8025ff:	89 d7                	mov    %edx,%edi
  802601:	39 d1                	cmp    %edx,%ecx
  802603:	72 06                	jb     80260b <__umoddi3+0xfb>
  802605:	75 10                	jne    802617 <__umoddi3+0x107>
  802607:	39 c3                	cmp    %eax,%ebx
  802609:	73 0c                	jae    802617 <__umoddi3+0x107>
  80260b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80260f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802613:	89 d7                	mov    %edx,%edi
  802615:	89 c6                	mov    %eax,%esi
  802617:	89 ca                	mov    %ecx,%edx
  802619:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261e:	29 f3                	sub    %esi,%ebx
  802620:	19 fa                	sbb    %edi,%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	d3 e0                	shl    %cl,%eax
  802626:	89 e9                	mov    %ebp,%ecx
  802628:	d3 eb                	shr    %cl,%ebx
  80262a:	d3 ea                	shr    %cl,%edx
  80262c:	09 d8                	or     %ebx,%eax
  80262e:	83 c4 1c             	add    $0x1c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263d:	8d 76 00             	lea    0x0(%esi),%esi
  802640:	89 da                	mov    %ebx,%edx
  802642:	29 fe                	sub    %edi,%esi
  802644:	19 c2                	sbb    %eax,%edx
  802646:	89 f1                	mov    %esi,%ecx
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	e9 4b ff ff ff       	jmp    80259a <__umoddi3+0x8a>
