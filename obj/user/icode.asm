
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
  80004d:	e8 e7 02 00 00       	call   800339 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 95 2c 80 00 	movl   $0x802c95,(%esp)
  800059:	e8 db 02 00 00       	call   800339 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 a8 2c 80 00       	push   $0x802ca8
  800068:	e8 99 18 00 00       	call   801906 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 d1 2c 80 00       	push   $0x802cd1
  80007e:	e8 b6 02 00 00       	call   800339 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 cd 13 00 00       	call   801468 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 22 0d 00 00       	call   800dce <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 ae 2c 80 00       	push   $0x802cae
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 c4 2c 80 00       	push   $0x802cc4
  8000be:	e8 80 01 00 00       	call   800243 <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 e4 2c 80 00       	push   $0x802ce4
  8000cb:	e8 69 02 00 00       	call   800339 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 52 12 00 00       	call   80132a <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  8000df:	e8 55 02 00 00       	call   800339 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 0c 2d 80 00       	push   $0x802d0c
  8000f0:	68 15 2d 80 00       	push   $0x802d15
  8000f5:	68 1f 2d 80 00       	push   $0x802d1f
  8000fa:	68 1e 2d 80 00       	push   $0x802d1e
  8000ff:	e8 35 1e 00 00       	call   801f39 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 3b 2d 80 00       	push   $0x802d3b
  800113:	e8 21 02 00 00       	call   800339 <cprintf>
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
  80012f:	e8 0f 01 00 00       	call   800243 <_panic>

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
  800147:	e8 00 0d 00 00       	call   800e4c <sys_getenvid>
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
  80016c:	74 23                	je     800191 <libmain+0x5d>
		if(envs[i].env_id == find)
  80016e:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800174:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80017a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80017d:	39 c1                	cmp    %eax,%ecx
  80017f:	75 e2                	jne    800163 <libmain+0x2f>
  800181:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800187:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80018d:	89 fe                	mov    %edi,%esi
  80018f:	eb d2                	jmp    800163 <libmain+0x2f>
  800191:	89 f0                	mov    %esi,%eax
  800193:	84 c0                	test   %al,%al
  800195:	74 06                	je     80019d <libmain+0x69>
  800197:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a1:	7e 0a                	jle    8001ad <libmain+0x79>
		binaryname = argv[0];
  8001a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a6:	8b 00                	mov    (%eax),%eax
  8001a8:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8001ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8001b2:	8b 40 48             	mov    0x48(%eax),%eax
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	50                   	push   %eax
  8001b9:	68 4b 2d 80 00       	push   $0x802d4b
  8001be:	e8 76 01 00 00       	call   800339 <cprintf>
	cprintf("before umain\n");
  8001c3:	c7 04 24 69 2d 80 00 	movl   $0x802d69,(%esp)
  8001ca:	e8 6a 01 00 00       	call   800339 <cprintf>
	// call user main routine
	umain(argc, argv);
  8001cf:	83 c4 08             	add    $0x8,%esp
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	e8 56 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8001dd:	c7 04 24 77 2d 80 00 	movl   $0x802d77,(%esp)
  8001e4:	e8 50 01 00 00       	call   800339 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001e9:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ee:	8b 40 48             	mov    0x48(%eax),%eax
  8001f1:	83 c4 08             	add    $0x8,%esp
  8001f4:	50                   	push   %eax
  8001f5:	68 84 2d 80 00       	push   $0x802d84
  8001fa:	e8 3a 01 00 00       	call   800339 <cprintf>
	// exit gracefully
	exit();
  8001ff:	e8 0b 00 00 00       	call   80020f <exit>
}
  800204:	83 c4 10             	add    $0x10,%esp
  800207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5e                   	pop    %esi
  80020c:	5f                   	pop    %edi
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800215:	a1 08 50 80 00       	mov    0x805008,%eax
  80021a:	8b 40 48             	mov    0x48(%eax),%eax
  80021d:	68 b0 2d 80 00       	push   $0x802db0
  800222:	50                   	push   %eax
  800223:	68 a3 2d 80 00       	push   $0x802da3
  800228:	e8 0c 01 00 00       	call   800339 <cprintf>
	close_all();
  80022d:	e8 25 11 00 00       	call   801357 <close_all>
	sys_env_destroy(0);
  800232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800239:	e8 cd 0b 00 00       	call   800e0b <sys_env_destroy>
}
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	56                   	push   %esi
  800247:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800248:	a1 08 50 80 00       	mov    0x805008,%eax
  80024d:	8b 40 48             	mov    0x48(%eax),%eax
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	68 dc 2d 80 00       	push   $0x802ddc
  800258:	50                   	push   %eax
  800259:	68 a3 2d 80 00       	push   $0x802da3
  80025e:	e8 d6 00 00 00       	call   800339 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800263:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80026c:	e8 db 0b 00 00       	call   800e4c <sys_getenvid>
  800271:	83 c4 04             	add    $0x4,%esp
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	56                   	push   %esi
  80027b:	50                   	push   %eax
  80027c:	68 b8 2d 80 00       	push   $0x802db8
  800281:	e8 b3 00 00 00       	call   800339 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	53                   	push   %ebx
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	e8 56 00 00 00       	call   8002e8 <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  800299:	e8 9b 00 00 00       	call   800339 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a1:	cc                   	int3   
  8002a2:	eb fd                	jmp    8002a1 <_panic+0x5e>

008002a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	53                   	push   %ebx
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ae:	8b 13                	mov    (%ebx),%edx
  8002b0:	8d 42 01             	lea    0x1(%edx),%eax
  8002b3:	89 03                	mov    %eax,(%ebx)
  8002b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002bc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c1:	74 09                	je     8002cc <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	68 ff 00 00 00       	push   $0xff
  8002d4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 f1 0a 00 00       	call   800dce <sys_cputs>
		b->idx = 0;
  8002dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e3:	83 c4 10             	add    $0x10,%esp
  8002e6:	eb db                	jmp    8002c3 <putch+0x1f>

008002e8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e8:	55                   	push   %ebp
  8002e9:	89 e5                	mov    %esp,%ebp
  8002eb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f8:	00 00 00 
	b.cnt = 0;
  8002fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800302:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800305:	ff 75 0c             	pushl  0xc(%ebp)
  800308:	ff 75 08             	pushl  0x8(%ebp)
  80030b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800311:	50                   	push   %eax
  800312:	68 a4 02 80 00       	push   $0x8002a4
  800317:	e8 4a 01 00 00       	call   800466 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80031c:	83 c4 08             	add    $0x8,%esp
  80031f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800325:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80032b:	50                   	push   %eax
  80032c:	e8 9d 0a 00 00       	call   800dce <sys_cputs>

	return b.cnt;
}
  800331:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80033f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800342:	50                   	push   %eax
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 9d ff ff ff       	call   8002e8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80034b:	c9                   	leave  
  80034c:	c3                   	ret    

0080034d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 1c             	sub    $0x1c,%esp
  800356:	89 c6                	mov    %eax,%esi
  800358:	89 d7                	mov    %edx,%edi
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800363:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800366:	8b 45 10             	mov    0x10(%ebp),%eax
  800369:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80036c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800370:	74 2c                	je     80039e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80037c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80037f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800382:	39 c2                	cmp    %eax,%edx
  800384:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800387:	73 43                	jae    8003cc <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800389:	83 eb 01             	sub    $0x1,%ebx
  80038c:	85 db                	test   %ebx,%ebx
  80038e:	7e 6c                	jle    8003fc <printnum+0xaf>
				putch(padc, putdat);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	57                   	push   %edi
  800394:	ff 75 18             	pushl  0x18(%ebp)
  800397:	ff d6                	call   *%esi
  800399:	83 c4 10             	add    $0x10,%esp
  80039c:	eb eb                	jmp    800389 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	6a 20                	push   $0x20
  8003a3:	6a 00                	push   $0x0
  8003a5:	50                   	push   %eax
  8003a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ac:	89 fa                	mov    %edi,%edx
  8003ae:	89 f0                	mov    %esi,%eax
  8003b0:	e8 98 ff ff ff       	call   80034d <printnum>
		while (--width > 0)
  8003b5:	83 c4 20             	add    $0x20,%esp
  8003b8:	83 eb 01             	sub    $0x1,%ebx
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	7e 65                	jle    800424 <printnum+0xd7>
			putch(padc, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	57                   	push   %edi
  8003c3:	6a 20                	push   $0x20
  8003c5:	ff d6                	call   *%esi
  8003c7:	83 c4 10             	add    $0x10,%esp
  8003ca:	eb ec                	jmp    8003b8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	ff 75 18             	pushl  0x18(%ebp)
  8003d2:	83 eb 01             	sub    $0x1,%ebx
  8003d5:	53                   	push   %ebx
  8003d6:	50                   	push   %eax
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	ff 75 dc             	pushl  -0x24(%ebp)
  8003dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e6:	e8 45 26 00 00       	call   802a30 <__udivdi3>
  8003eb:	83 c4 18             	add    $0x18,%esp
  8003ee:	52                   	push   %edx
  8003ef:	50                   	push   %eax
  8003f0:	89 fa                	mov    %edi,%edx
  8003f2:	89 f0                	mov    %esi,%eax
  8003f4:	e8 54 ff ff ff       	call   80034d <printnum>
  8003f9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	57                   	push   %edi
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	ff 75 dc             	pushl  -0x24(%ebp)
  800406:	ff 75 d8             	pushl  -0x28(%ebp)
  800409:	ff 75 e4             	pushl  -0x1c(%ebp)
  80040c:	ff 75 e0             	pushl  -0x20(%ebp)
  80040f:	e8 2c 27 00 00       	call   802b40 <__umoddi3>
  800414:	83 c4 14             	add    $0x14,%esp
  800417:	0f be 80 e3 2d 80 00 	movsbl 0x802de3(%eax),%eax
  80041e:	50                   	push   %eax
  80041f:	ff d6                	call   *%esi
  800421:	83 c4 10             	add    $0x10,%esp
	}
}
  800424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800427:	5b                   	pop    %ebx
  800428:	5e                   	pop    %esi
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800432:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800436:	8b 10                	mov    (%eax),%edx
  800438:	3b 50 04             	cmp    0x4(%eax),%edx
  80043b:	73 0a                	jae    800447 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800440:	89 08                	mov    %ecx,(%eax)
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	88 02                	mov    %al,(%edx)
}
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <printfmt>:
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80044f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800452:	50                   	push   %eax
  800453:	ff 75 10             	pushl  0x10(%ebp)
  800456:	ff 75 0c             	pushl  0xc(%ebp)
  800459:	ff 75 08             	pushl  0x8(%ebp)
  80045c:	e8 05 00 00 00       	call   800466 <vprintfmt>
}
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <vprintfmt>:
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	57                   	push   %edi
  80046a:	56                   	push   %esi
  80046b:	53                   	push   %ebx
  80046c:	83 ec 3c             	sub    $0x3c,%esp
  80046f:	8b 75 08             	mov    0x8(%ebp),%esi
  800472:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800475:	8b 7d 10             	mov    0x10(%ebp),%edi
  800478:	e9 32 04 00 00       	jmp    8008af <vprintfmt+0x449>
		padc = ' ';
  80047d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800481:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800488:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80048f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800496:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80049d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8004a4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a9:	8d 47 01             	lea    0x1(%edi),%eax
  8004ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004af:	0f b6 17             	movzbl (%edi),%edx
  8004b2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004b5:	3c 55                	cmp    $0x55,%al
  8004b7:	0f 87 12 05 00 00    	ja     8009cf <vprintfmt+0x569>
  8004bd:	0f b6 c0             	movzbl %al,%eax
  8004c0:	ff 24 85 c0 2f 80 00 	jmp    *0x802fc0(,%eax,4)
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004ca:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8004ce:	eb d9                	jmp    8004a9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004d3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004d7:	eb d0                	jmp    8004a9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004d9:	0f b6 d2             	movzbl %dl,%edx
  8004dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004df:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e7:	eb 03                	jmp    8004ec <vprintfmt+0x86>
  8004e9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ec:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ef:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004f3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004f6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004f9:	83 fe 09             	cmp    $0x9,%esi
  8004fc:	76 eb                	jbe    8004e9 <vprintfmt+0x83>
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	8b 75 08             	mov    0x8(%ebp),%esi
  800504:	eb 14                	jmp    80051a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	8d 40 04             	lea    0x4(%eax),%eax
  800514:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80051a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80051e:	79 89                	jns    8004a9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800523:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800526:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80052d:	e9 77 ff ff ff       	jmp    8004a9 <vprintfmt+0x43>
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	85 c0                	test   %eax,%eax
  800537:	0f 48 c1             	cmovs  %ecx,%eax
  80053a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800540:	e9 64 ff ff ff       	jmp    8004a9 <vprintfmt+0x43>
  800545:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800548:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80054f:	e9 55 ff ff ff       	jmp    8004a9 <vprintfmt+0x43>
			lflag++;
  800554:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800558:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80055b:	e9 49 ff ff ff       	jmp    8004a9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8d 78 04             	lea    0x4(%eax),%edi
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	53                   	push   %ebx
  80056a:	ff 30                	pushl  (%eax)
  80056c:	ff d6                	call   *%esi
			break;
  80056e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800571:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800574:	e9 33 03 00 00       	jmp    8008ac <vprintfmt+0x446>
			err = va_arg(ap, int);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 78 04             	lea    0x4(%eax),%edi
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	99                   	cltd   
  800582:	31 d0                	xor    %edx,%eax
  800584:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800586:	83 f8 11             	cmp    $0x11,%eax
  800589:	7f 23                	jg     8005ae <vprintfmt+0x148>
  80058b:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  800592:	85 d2                	test   %edx,%edx
  800594:	74 18                	je     8005ae <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800596:	52                   	push   %edx
  800597:	68 3d 32 80 00       	push   $0x80323d
  80059c:	53                   	push   %ebx
  80059d:	56                   	push   %esi
  80059e:	e8 a6 fe ff ff       	call   800449 <printfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005a6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005a9:	e9 fe 02 00 00       	jmp    8008ac <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8005ae:	50                   	push   %eax
  8005af:	68 fb 2d 80 00       	push   $0x802dfb
  8005b4:	53                   	push   %ebx
  8005b5:	56                   	push   %esi
  8005b6:	e8 8e fe ff ff       	call   800449 <printfmt>
  8005bb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005be:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005c1:	e9 e6 02 00 00       	jmp    8008ac <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	83 c0 04             	add    $0x4,%eax
  8005cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	b8 f4 2d 80 00       	mov    $0x802df4,%eax
  8005db:	0f 45 c1             	cmovne %ecx,%eax
  8005de:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e5:	7e 06                	jle    8005ed <vprintfmt+0x187>
  8005e7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005eb:	75 0d                	jne    8005fa <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005f0:	89 c7                	mov    %eax,%edi
  8005f2:	03 45 e0             	add    -0x20(%ebp),%eax
  8005f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f8:	eb 53                	jmp    80064d <vprintfmt+0x1e7>
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	ff 75 d8             	pushl  -0x28(%ebp)
  800600:	50                   	push   %eax
  800601:	e8 71 04 00 00       	call   800a77 <strnlen>
  800606:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800609:	29 c1                	sub    %eax,%ecx
  80060b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800613:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800617:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80061a:	eb 0f                	jmp    80062b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	53                   	push   %ebx
  800620:	ff 75 e0             	pushl  -0x20(%ebp)
  800623:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	85 ff                	test   %edi,%edi
  80062d:	7f ed                	jg     80061c <vprintfmt+0x1b6>
  80062f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800632:	85 c9                	test   %ecx,%ecx
  800634:	b8 00 00 00 00       	mov    $0x0,%eax
  800639:	0f 49 c1             	cmovns %ecx,%eax
  80063c:	29 c1                	sub    %eax,%ecx
  80063e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800641:	eb aa                	jmp    8005ed <vprintfmt+0x187>
					putch(ch, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	52                   	push   %edx
  800648:	ff d6                	call   *%esi
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800650:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800652:	83 c7 01             	add    $0x1,%edi
  800655:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800659:	0f be d0             	movsbl %al,%edx
  80065c:	85 d2                	test   %edx,%edx
  80065e:	74 4b                	je     8006ab <vprintfmt+0x245>
  800660:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800664:	78 06                	js     80066c <vprintfmt+0x206>
  800666:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80066a:	78 1e                	js     80068a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80066c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800670:	74 d1                	je     800643 <vprintfmt+0x1dd>
  800672:	0f be c0             	movsbl %al,%eax
  800675:	83 e8 20             	sub    $0x20,%eax
  800678:	83 f8 5e             	cmp    $0x5e,%eax
  80067b:	76 c6                	jbe    800643 <vprintfmt+0x1dd>
					putch('?', putdat);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	53                   	push   %ebx
  800681:	6a 3f                	push   $0x3f
  800683:	ff d6                	call   *%esi
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	eb c3                	jmp    80064d <vprintfmt+0x1e7>
  80068a:	89 cf                	mov    %ecx,%edi
  80068c:	eb 0e                	jmp    80069c <vprintfmt+0x236>
				putch(' ', putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	53                   	push   %ebx
  800692:	6a 20                	push   $0x20
  800694:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800696:	83 ef 01             	sub    $0x1,%edi
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	85 ff                	test   %edi,%edi
  80069e:	7f ee                	jg     80068e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8006a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a6:	e9 01 02 00 00       	jmp    8008ac <vprintfmt+0x446>
  8006ab:	89 cf                	mov    %ecx,%edi
  8006ad:	eb ed                	jmp    80069c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8006af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8006b2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8006b9:	e9 eb fd ff ff       	jmp    8004a9 <vprintfmt+0x43>
	if (lflag >= 2)
  8006be:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c2:	7f 21                	jg     8006e5 <vprintfmt+0x27f>
	else if (lflag)
  8006c4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c8:	74 68                	je     800732 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d2:	89 c1                	mov    %eax,%ecx
  8006d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e3:	eb 17                	jmp    8006fc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 50 04             	mov    0x4(%eax),%edx
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8d 40 08             	lea    0x8(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800702:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800705:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800708:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80070c:	78 3f                	js     80074d <vprintfmt+0x2e7>
			base = 10;
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800713:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800717:	0f 84 71 01 00 00    	je     80088e <vprintfmt+0x428>
				putch('+', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 2b                	push   $0x2b
  800723:	ff d6                	call   *%esi
  800725:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800728:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072d:	e9 5c 01 00 00       	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, int);
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073a:	89 c1                	mov    %eax,%ecx
  80073c:	c1 f9 1f             	sar    $0x1f,%ecx
  80073f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	eb af                	jmp    8006fc <vprintfmt+0x296>
				putch('-', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 2d                	push   $0x2d
  800753:	ff d6                	call   *%esi
				num = -(long long) num;
  800755:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800758:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80075b:	f7 d8                	neg    %eax
  80075d:	83 d2 00             	adc    $0x0,%edx
  800760:	f7 da                	neg    %edx
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800768:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80076b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800770:	e9 19 01 00 00       	jmp    80088e <vprintfmt+0x428>
	if (lflag >= 2)
  800775:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800779:	7f 29                	jg     8007a4 <vprintfmt+0x33e>
	else if (lflag)
  80077b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077f:	74 44                	je     8007c5 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	ba 00 00 00 00       	mov    $0x0,%edx
  80078b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8d 40 04             	lea    0x4(%eax),%eax
  800797:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079f:	e9 ea 00 00 00       	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 50 04             	mov    0x4(%eax),%edx
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8d 40 08             	lea    0x8(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007c0:	e9 c9 00 00 00       	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e3:	e9 a6 00 00 00       	jmp    80088e <vprintfmt+0x428>
			putch('0', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	53                   	push   %ebx
  8007ec:	6a 30                	push   $0x30
  8007ee:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007f7:	7f 26                	jg     80081f <vprintfmt+0x3b9>
	else if (lflag)
  8007f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007fd:	74 3e                	je     80083d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80080f:	8b 45 14             	mov    0x14(%ebp),%eax
  800812:	8d 40 04             	lea    0x4(%eax),%eax
  800815:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800818:	b8 08 00 00 00       	mov    $0x8,%eax
  80081d:	eb 6f                	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 50 04             	mov    0x4(%eax),%edx
  800825:	8b 00                	mov    (%eax),%eax
  800827:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8d 40 08             	lea    0x8(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800836:	b8 08 00 00 00       	mov    $0x8,%eax
  80083b:	eb 51                	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800856:	b8 08 00 00 00       	mov    $0x8,%eax
  80085b:	eb 31                	jmp    80088e <vprintfmt+0x428>
			putch('0', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	6a 30                	push   $0x30
  800863:	ff d6                	call   *%esi
			putch('x', putdat);
  800865:	83 c4 08             	add    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 78                	push   $0x78
  80086b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80087d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800889:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80088e:	83 ec 0c             	sub    $0xc,%esp
  800891:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800895:	52                   	push   %edx
  800896:	ff 75 e0             	pushl  -0x20(%ebp)
  800899:	50                   	push   %eax
  80089a:	ff 75 dc             	pushl  -0x24(%ebp)
  80089d:	ff 75 d8             	pushl  -0x28(%ebp)
  8008a0:	89 da                	mov    %ebx,%edx
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	e8 a4 fa ff ff       	call   80034d <printnum>
			break;
  8008a9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008af:	83 c7 01             	add    $0x1,%edi
  8008b2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008b6:	83 f8 25             	cmp    $0x25,%eax
  8008b9:	0f 84 be fb ff ff    	je     80047d <vprintfmt+0x17>
			if (ch == '\0')
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	0f 84 28 01 00 00    	je     8009ef <vprintfmt+0x589>
			putch(ch, putdat);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	53                   	push   %ebx
  8008cb:	50                   	push   %eax
  8008cc:	ff d6                	call   *%esi
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	eb dc                	jmp    8008af <vprintfmt+0x449>
	if (lflag >= 2)
  8008d3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008d7:	7f 26                	jg     8008ff <vprintfmt+0x499>
	else if (lflag)
  8008d9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008dd:	74 41                	je     800920 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8d 40 04             	lea    0x4(%eax),%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8008fd:	eb 8f                	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8b 50 04             	mov    0x4(%eax),%edx
  800905:	8b 00                	mov    (%eax),%eax
  800907:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80090a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	8d 40 08             	lea    0x8(%eax),%eax
  800913:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800916:	b8 10 00 00 00       	mov    $0x10,%eax
  80091b:	e9 6e ff ff ff       	jmp    80088e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800920:	8b 45 14             	mov    0x14(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	ba 00 00 00 00       	mov    $0x0,%edx
  80092a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 40 04             	lea    0x4(%eax),%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800939:	b8 10 00 00 00       	mov    $0x10,%eax
  80093e:	e9 4b ff ff ff       	jmp    80088e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	85 c0                	test   %eax,%eax
  800953:	74 14                	je     800969 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800955:	8b 13                	mov    (%ebx),%edx
  800957:	83 fa 7f             	cmp    $0x7f,%edx
  80095a:	7f 37                	jg     800993 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80095c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80095e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800961:	89 45 14             	mov    %eax,0x14(%ebp)
  800964:	e9 43 ff ff ff       	jmp    8008ac <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800969:	b8 0a 00 00 00       	mov    $0xa,%eax
  80096e:	bf 19 2f 80 00       	mov    $0x802f19,%edi
							putch(ch, putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	53                   	push   %ebx
  800977:	50                   	push   %eax
  800978:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80097a:	83 c7 01             	add    $0x1,%edi
  80097d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	85 c0                	test   %eax,%eax
  800986:	75 eb                	jne    800973 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800988:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
  80098e:	e9 19 ff ff ff       	jmp    8008ac <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800993:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800995:	b8 0a 00 00 00       	mov    $0xa,%eax
  80099a:	bf 51 2f 80 00       	mov    $0x802f51,%edi
							putch(ch, putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	53                   	push   %ebx
  8009a3:	50                   	push   %eax
  8009a4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8009a6:	83 c7 01             	add    $0x1,%edi
  8009a9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
  8009b0:	85 c0                	test   %eax,%eax
  8009b2:	75 eb                	jne    80099f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8009b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ba:	e9 ed fe ff ff       	jmp    8008ac <vprintfmt+0x446>
			putch(ch, putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	53                   	push   %ebx
  8009c3:	6a 25                	push   $0x25
  8009c5:	ff d6                	call   *%esi
			break;
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	e9 dd fe ff ff       	jmp    8008ac <vprintfmt+0x446>
			putch('%', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	53                   	push   %ebx
  8009d3:	6a 25                	push   $0x25
  8009d5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009d7:	83 c4 10             	add    $0x10,%esp
  8009da:	89 f8                	mov    %edi,%eax
  8009dc:	eb 03                	jmp    8009e1 <vprintfmt+0x57b>
  8009de:	83 e8 01             	sub    $0x1,%eax
  8009e1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009e5:	75 f7                	jne    8009de <vprintfmt+0x578>
  8009e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009ea:	e9 bd fe ff ff       	jmp    8008ac <vprintfmt+0x446>
}
  8009ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5f                   	pop    %edi
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a06:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a0a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a14:	85 c0                	test   %eax,%eax
  800a16:	74 26                	je     800a3e <vsnprintf+0x47>
  800a18:	85 d2                	test   %edx,%edx
  800a1a:	7e 22                	jle    800a3e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a1c:	ff 75 14             	pushl  0x14(%ebp)
  800a1f:	ff 75 10             	pushl  0x10(%ebp)
  800a22:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a25:	50                   	push   %eax
  800a26:	68 2c 04 80 00       	push   $0x80042c
  800a2b:	e8 36 fa ff ff       	call   800466 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a33:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a39:	83 c4 10             	add    $0x10,%esp
}
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    
		return -E_INVAL;
  800a3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a43:	eb f7                	jmp    800a3c <vsnprintf+0x45>

00800a45 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a4b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a4e:	50                   	push   %eax
  800a4f:	ff 75 10             	pushl  0x10(%ebp)
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	ff 75 08             	pushl  0x8(%ebp)
  800a58:	e8 9a ff ff ff       	call   8009f7 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a65:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a6e:	74 05                	je     800a75 <strlen+0x16>
		n++;
  800a70:	83 c0 01             	add    $0x1,%eax
  800a73:	eb f5                	jmp    800a6a <strlen+0xb>
	return n;
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	39 c2                	cmp    %eax,%edx
  800a87:	74 0d                	je     800a96 <strnlen+0x1f>
  800a89:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a8d:	74 05                	je     800a94 <strnlen+0x1d>
		n++;
  800a8f:	83 c2 01             	add    $0x1,%edx
  800a92:	eb f1                	jmp    800a85 <strnlen+0xe>
  800a94:	89 d0                	mov    %edx,%eax
	return n;
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	84 c9                	test   %cl,%cl
  800ab3:	75 f2                	jne    800aa7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	53                   	push   %ebx
  800abc:	83 ec 10             	sub    $0x10,%esp
  800abf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac2:	53                   	push   %ebx
  800ac3:	e8 97 ff ff ff       	call   800a5f <strlen>
  800ac8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	01 d8                	add    %ebx,%eax
  800ad0:	50                   	push   %eax
  800ad1:	e8 c2 ff ff ff       	call   800a98 <strcpy>
	return dst;
}
  800ad6:	89 d8                	mov    %ebx,%eax
  800ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800adb:	c9                   	leave  
  800adc:	c3                   	ret    

00800add <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae8:	89 c6                	mov    %eax,%esi
  800aea:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aed:	89 c2                	mov    %eax,%edx
  800aef:	39 f2                	cmp    %esi,%edx
  800af1:	74 11                	je     800b04 <strncpy+0x27>
		*dst++ = *src;
  800af3:	83 c2 01             	add    $0x1,%edx
  800af6:	0f b6 19             	movzbl (%ecx),%ebx
  800af9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800afc:	80 fb 01             	cmp    $0x1,%bl
  800aff:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800b02:	eb eb                	jmp    800aef <strncpy+0x12>
	}
	return ret;
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b13:	8b 55 10             	mov    0x10(%ebp),%edx
  800b16:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b18:	85 d2                	test   %edx,%edx
  800b1a:	74 21                	je     800b3d <strlcpy+0x35>
  800b1c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b20:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b22:	39 c2                	cmp    %eax,%edx
  800b24:	74 14                	je     800b3a <strlcpy+0x32>
  800b26:	0f b6 19             	movzbl (%ecx),%ebx
  800b29:	84 db                	test   %bl,%bl
  800b2b:	74 0b                	je     800b38 <strlcpy+0x30>
			*dst++ = *src++;
  800b2d:	83 c1 01             	add    $0x1,%ecx
  800b30:	83 c2 01             	add    $0x1,%edx
  800b33:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b36:	eb ea                	jmp    800b22 <strlcpy+0x1a>
  800b38:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b3a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b3d:	29 f0                	sub    %esi,%eax
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b49:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b4c:	0f b6 01             	movzbl (%ecx),%eax
  800b4f:	84 c0                	test   %al,%al
  800b51:	74 0c                	je     800b5f <strcmp+0x1c>
  800b53:	3a 02                	cmp    (%edx),%al
  800b55:	75 08                	jne    800b5f <strcmp+0x1c>
		p++, q++;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	83 c2 01             	add    $0x1,%edx
  800b5d:	eb ed                	jmp    800b4c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5f:	0f b6 c0             	movzbl %al,%eax
  800b62:	0f b6 12             	movzbl (%edx),%edx
  800b65:	29 d0                	sub    %edx,%eax
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	53                   	push   %ebx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b73:	89 c3                	mov    %eax,%ebx
  800b75:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b78:	eb 06                	jmp    800b80 <strncmp+0x17>
		n--, p++, q++;
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b80:	39 d8                	cmp    %ebx,%eax
  800b82:	74 16                	je     800b9a <strncmp+0x31>
  800b84:	0f b6 08             	movzbl (%eax),%ecx
  800b87:	84 c9                	test   %cl,%cl
  800b89:	74 04                	je     800b8f <strncmp+0x26>
  800b8b:	3a 0a                	cmp    (%edx),%cl
  800b8d:	74 eb                	je     800b7a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b8f:	0f b6 00             	movzbl (%eax),%eax
  800b92:	0f b6 12             	movzbl (%edx),%edx
  800b95:	29 d0                	sub    %edx,%eax
}
  800b97:	5b                   	pop    %ebx
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    
		return 0;
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9f:	eb f6                	jmp    800b97 <strncmp+0x2e>

00800ba1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bab:	0f b6 10             	movzbl (%eax),%edx
  800bae:	84 d2                	test   %dl,%dl
  800bb0:	74 09                	je     800bbb <strchr+0x1a>
		if (*s == c)
  800bb2:	38 ca                	cmp    %cl,%dl
  800bb4:	74 0a                	je     800bc0 <strchr+0x1f>
	for (; *s; s++)
  800bb6:	83 c0 01             	add    $0x1,%eax
  800bb9:	eb f0                	jmp    800bab <strchr+0xa>
			return (char *) s;
	return 0;
  800bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bcc:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800bcf:	38 ca                	cmp    %cl,%dl
  800bd1:	74 09                	je     800bdc <strfind+0x1a>
  800bd3:	84 d2                	test   %dl,%dl
  800bd5:	74 05                	je     800bdc <strfind+0x1a>
	for (; *s; s++)
  800bd7:	83 c0 01             	add    $0x1,%eax
  800bda:	eb f0                	jmp    800bcc <strfind+0xa>
			break;
	return (char *) s;
}
  800bdc:	5d                   	pop    %ebp
  800bdd:	c3                   	ret    

00800bde <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800be7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bea:	85 c9                	test   %ecx,%ecx
  800bec:	74 31                	je     800c1f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bee:	89 f8                	mov    %edi,%eax
  800bf0:	09 c8                	or     %ecx,%eax
  800bf2:	a8 03                	test   $0x3,%al
  800bf4:	75 23                	jne    800c19 <memset+0x3b>
		c &= 0xFF;
  800bf6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bfa:	89 d3                	mov    %edx,%ebx
  800bfc:	c1 e3 08             	shl    $0x8,%ebx
  800bff:	89 d0                	mov    %edx,%eax
  800c01:	c1 e0 18             	shl    $0x18,%eax
  800c04:	89 d6                	mov    %edx,%esi
  800c06:	c1 e6 10             	shl    $0x10,%esi
  800c09:	09 f0                	or     %esi,%eax
  800c0b:	09 c2                	or     %eax,%edx
  800c0d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c0f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c12:	89 d0                	mov    %edx,%eax
  800c14:	fc                   	cld    
  800c15:	f3 ab                	rep stos %eax,%es:(%edi)
  800c17:	eb 06                	jmp    800c1f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	fc                   	cld    
  800c1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c1f:	89 f8                	mov    %edi,%eax
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c34:	39 c6                	cmp    %eax,%esi
  800c36:	73 32                	jae    800c6a <memmove+0x44>
  800c38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c3b:	39 c2                	cmp    %eax,%edx
  800c3d:	76 2b                	jbe    800c6a <memmove+0x44>
		s += n;
		d += n;
  800c3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c42:	89 fe                	mov    %edi,%esi
  800c44:	09 ce                	or     %ecx,%esi
  800c46:	09 d6                	or     %edx,%esi
  800c48:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c4e:	75 0e                	jne    800c5e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c50:	83 ef 04             	sub    $0x4,%edi
  800c53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c59:	fd                   	std    
  800c5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c5c:	eb 09                	jmp    800c67 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c5e:	83 ef 01             	sub    $0x1,%edi
  800c61:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c64:	fd                   	std    
  800c65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c67:	fc                   	cld    
  800c68:	eb 1a                	jmp    800c84 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c6a:	89 c2                	mov    %eax,%edx
  800c6c:	09 ca                	or     %ecx,%edx
  800c6e:	09 f2                	or     %esi,%edx
  800c70:	f6 c2 03             	test   $0x3,%dl
  800c73:	75 0a                	jne    800c7f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c78:	89 c7                	mov    %eax,%edi
  800c7a:	fc                   	cld    
  800c7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7d:	eb 05                	jmp    800c84 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c7f:	89 c7                	mov    %eax,%edi
  800c81:	fc                   	cld    
  800c82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c8e:	ff 75 10             	pushl  0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	ff 75 08             	pushl  0x8(%ebp)
  800c97:	e8 8a ff ff ff       	call   800c26 <memmove>
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca9:	89 c6                	mov    %eax,%esi
  800cab:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cae:	39 f0                	cmp    %esi,%eax
  800cb0:	74 1c                	je     800cce <memcmp+0x30>
		if (*s1 != *s2)
  800cb2:	0f b6 08             	movzbl (%eax),%ecx
  800cb5:	0f b6 1a             	movzbl (%edx),%ebx
  800cb8:	38 d9                	cmp    %bl,%cl
  800cba:	75 08                	jne    800cc4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	83 c2 01             	add    $0x1,%edx
  800cc2:	eb ea                	jmp    800cae <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800cc4:	0f b6 c1             	movzbl %cl,%eax
  800cc7:	0f b6 db             	movzbl %bl,%ebx
  800cca:	29 d8                	sub    %ebx,%eax
  800ccc:	eb 05                	jmp    800cd3 <memcmp+0x35>
	}

	return 0;
  800cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ce0:	89 c2                	mov    %eax,%edx
  800ce2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ce5:	39 d0                	cmp    %edx,%eax
  800ce7:	73 09                	jae    800cf2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce9:	38 08                	cmp    %cl,(%eax)
  800ceb:	74 05                	je     800cf2 <memfind+0x1b>
	for (; s < ends; s++)
  800ced:	83 c0 01             	add    $0x1,%eax
  800cf0:	eb f3                	jmp    800ce5 <memfind+0xe>
			break;
	return (void *) s;
}
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
  800cfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d00:	eb 03                	jmp    800d05 <strtol+0x11>
		s++;
  800d02:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d05:	0f b6 01             	movzbl (%ecx),%eax
  800d08:	3c 20                	cmp    $0x20,%al
  800d0a:	74 f6                	je     800d02 <strtol+0xe>
  800d0c:	3c 09                	cmp    $0x9,%al
  800d0e:	74 f2                	je     800d02 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800d10:	3c 2b                	cmp    $0x2b,%al
  800d12:	74 2a                	je     800d3e <strtol+0x4a>
	int neg = 0;
  800d14:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d19:	3c 2d                	cmp    $0x2d,%al
  800d1b:	74 2b                	je     800d48 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d23:	75 0f                	jne    800d34 <strtol+0x40>
  800d25:	80 39 30             	cmpb   $0x30,(%ecx)
  800d28:	74 28                	je     800d52 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d2a:	85 db                	test   %ebx,%ebx
  800d2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d31:	0f 44 d8             	cmove  %eax,%ebx
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
  800d39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d3c:	eb 50                	jmp    800d8e <strtol+0x9a>
		s++;
  800d3e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d41:	bf 00 00 00 00       	mov    $0x0,%edi
  800d46:	eb d5                	jmp    800d1d <strtol+0x29>
		s++, neg = 1;
  800d48:	83 c1 01             	add    $0x1,%ecx
  800d4b:	bf 01 00 00 00       	mov    $0x1,%edi
  800d50:	eb cb                	jmp    800d1d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d52:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d56:	74 0e                	je     800d66 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d58:	85 db                	test   %ebx,%ebx
  800d5a:	75 d8                	jne    800d34 <strtol+0x40>
		s++, base = 8;
  800d5c:	83 c1 01             	add    $0x1,%ecx
  800d5f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d64:	eb ce                	jmp    800d34 <strtol+0x40>
		s += 2, base = 16;
  800d66:	83 c1 02             	add    $0x2,%ecx
  800d69:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d6e:	eb c4                	jmp    800d34 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d70:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d73:	89 f3                	mov    %esi,%ebx
  800d75:	80 fb 19             	cmp    $0x19,%bl
  800d78:	77 29                	ja     800da3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d7a:	0f be d2             	movsbl %dl,%edx
  800d7d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d80:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d83:	7d 30                	jge    800db5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d85:	83 c1 01             	add    $0x1,%ecx
  800d88:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d8c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d8e:	0f b6 11             	movzbl (%ecx),%edx
  800d91:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d94:	89 f3                	mov    %esi,%ebx
  800d96:	80 fb 09             	cmp    $0x9,%bl
  800d99:	77 d5                	ja     800d70 <strtol+0x7c>
			dig = *s - '0';
  800d9b:	0f be d2             	movsbl %dl,%edx
  800d9e:	83 ea 30             	sub    $0x30,%edx
  800da1:	eb dd                	jmp    800d80 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800da3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800da6:	89 f3                	mov    %esi,%ebx
  800da8:	80 fb 19             	cmp    $0x19,%bl
  800dab:	77 08                	ja     800db5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800dad:	0f be d2             	movsbl %dl,%edx
  800db0:	83 ea 37             	sub    $0x37,%edx
  800db3:	eb cb                	jmp    800d80 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800db5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db9:	74 05                	je     800dc0 <strtol+0xcc>
		*endptr = (char *) s;
  800dbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dbe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800dc0:	89 c2                	mov    %eax,%edx
  800dc2:	f7 da                	neg    %edx
  800dc4:	85 ff                	test   %edi,%edi
  800dc6:	0f 45 c2             	cmovne %edx,%eax
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddf:	89 c3                	mov    %eax,%ebx
  800de1:	89 c7                	mov    %eax,%edi
  800de3:	89 c6                	mov    %eax,%esi
  800de5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <sys_cgetc>:

int
sys_cgetc(void)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df2:	ba 00 00 00 00       	mov    $0x0,%edx
  800df7:	b8 01 00 00 00       	mov    $0x1,%eax
  800dfc:	89 d1                	mov    %edx,%ecx
  800dfe:	89 d3                	mov    %edx,%ebx
  800e00:	89 d7                	mov    %edx,%edi
  800e02:	89 d6                	mov    %edx,%esi
  800e04:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800e21:	89 cb                	mov    %ecx,%ebx
  800e23:	89 cf                	mov    %ecx,%edi
  800e25:	89 ce                	mov    %ecx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 03                	push   $0x3
  800e3b:	68 68 31 80 00       	push   $0x803168
  800e40:	6a 43                	push   $0x43
  800e42:	68 85 31 80 00       	push   $0x803185
  800e47:	e8 f7 f3 ff ff       	call   800243 <_panic>

00800e4c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e52:	ba 00 00 00 00       	mov    $0x0,%edx
  800e57:	b8 02 00 00 00       	mov    $0x2,%eax
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	89 d3                	mov    %edx,%ebx
  800e60:	89 d7                	mov    %edx,%edi
  800e62:	89 d6                	mov    %edx,%esi
  800e64:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <sys_yield>:

void
sys_yield(void)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e71:	ba 00 00 00 00       	mov    $0x0,%edx
  800e76:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e7b:	89 d1                	mov    %edx,%ecx
  800e7d:	89 d3                	mov    %edx,%ebx
  800e7f:	89 d7                	mov    %edx,%edi
  800e81:	89 d6                	mov    %edx,%esi
  800e83:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e93:	be 00 00 00 00       	mov    $0x0,%esi
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 04 00 00 00       	mov    $0x4,%eax
  800ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea6:	89 f7                	mov    %esi,%edi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 04                	push   $0x4
  800ebc:	68 68 31 80 00       	push   $0x803168
  800ec1:	6a 43                	push   $0x43
  800ec3:	68 85 31 80 00       	push   $0x803185
  800ec8:	e8 76 f3 ff ff       	call   800243 <_panic>

00800ecd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ee1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee7:	8b 75 18             	mov    0x18(%ebp),%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 05                	push   $0x5
  800efe:	68 68 31 80 00       	push   $0x803168
  800f03:	6a 43                	push   $0x43
  800f05:	68 85 31 80 00       	push   $0x803185
  800f0a:	e8 34 f3 ff ff       	call   800243 <_panic>

00800f0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 06 00 00 00       	mov    $0x6,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 06                	push   $0x6
  800f40:	68 68 31 80 00       	push   $0x803168
  800f45:	6a 43                	push   $0x43
  800f47:	68 85 31 80 00       	push   $0x803185
  800f4c:	e8 f2 f2 ff ff       	call   800243 <_panic>

00800f51 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 08 00 00 00       	mov    $0x8,%eax
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	89 de                	mov    %ebx,%esi
  800f6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7f 08                	jg     800f7c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	6a 08                	push   $0x8
  800f82:	68 68 31 80 00       	push   $0x803168
  800f87:	6a 43                	push   $0x43
  800f89:	68 85 31 80 00       	push   $0x803185
  800f8e:	e8 b0 f2 ff ff       	call   800243 <_panic>

00800f93 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa7:	b8 09 00 00 00       	mov    $0x9,%eax
  800fac:	89 df                	mov    %ebx,%edi
  800fae:	89 de                	mov    %ebx,%esi
  800fb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	7f 08                	jg     800fbe <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbe:	83 ec 0c             	sub    $0xc,%esp
  800fc1:	50                   	push   %eax
  800fc2:	6a 09                	push   $0x9
  800fc4:	68 68 31 80 00       	push   $0x803168
  800fc9:	6a 43                	push   $0x43
  800fcb:	68 85 31 80 00       	push   $0x803185
  800fd0:	e8 6e f2 ff ff       	call   800243 <_panic>

00800fd5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	57                   	push   %edi
  800fd9:	56                   	push   %esi
  800fda:	53                   	push   %ebx
  800fdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fee:	89 df                	mov    %ebx,%edi
  800ff0:	89 de                	mov    %ebx,%esi
  800ff2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff4:	85 c0                	test   %eax,%eax
  800ff6:	7f 08                	jg     801000 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	6a 0a                	push   $0xa
  801006:	68 68 31 80 00       	push   $0x803168
  80100b:	6a 43                	push   $0x43
  80100d:	68 85 31 80 00       	push   $0x803185
  801012:	e8 2c f2 ff ff       	call   800243 <_panic>

00801017 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	57                   	push   %edi
  80101b:	56                   	push   %esi
  80101c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	b8 0c 00 00 00       	mov    $0xc,%eax
  801028:	be 00 00 00 00       	mov    $0x0,%esi
  80102d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801030:	8b 7d 14             	mov    0x14(%ebp),%edi
  801033:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
  801040:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801043:	b9 00 00 00 00       	mov    $0x0,%ecx
  801048:	8b 55 08             	mov    0x8(%ebp),%edx
  80104b:	b8 0d 00 00 00       	mov    $0xd,%eax
  801050:	89 cb                	mov    %ecx,%ebx
  801052:	89 cf                	mov    %ecx,%edi
  801054:	89 ce                	mov    %ecx,%esi
  801056:	cd 30                	int    $0x30
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7f 08                	jg     801064 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	50                   	push   %eax
  801068:	6a 0d                	push   $0xd
  80106a:	68 68 31 80 00       	push   $0x803168
  80106f:	6a 43                	push   $0x43
  801071:	68 85 31 80 00       	push   $0x803185
  801076:	e8 c8 f1 ff ff       	call   800243 <_panic>

0080107b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
	asm volatile("int %1\n"
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801091:	89 df                	mov    %ebx,%edi
  801093:	89 de                	mov    %ebx,%esi
  801095:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010af:	89 cb                	mov    %ecx,%ebx
  8010b1:	89 cf                	mov    %ecx,%edi
  8010b3:	89 ce                	mov    %ecx,%esi
  8010b5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8010cc:	89 d1                	mov    %edx,%ecx
  8010ce:	89 d3                	mov    %edx,%ebx
  8010d0:	89 d7                	mov    %edx,%edi
  8010d2:	89 d6                	mov    %edx,%esi
  8010d4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010d6:	5b                   	pop    %ebx
  8010d7:	5e                   	pop    %esi
  8010d8:	5f                   	pop    %edi
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	57                   	push   %edi
  8010df:	56                   	push   %esi
  8010e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ec:	b8 11 00 00 00       	mov    $0x11,%eax
  8010f1:	89 df                	mov    %ebx,%edi
  8010f3:	89 de                	mov    %ebx,%esi
  8010f5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
	asm volatile("int %1\n"
  801102:	bb 00 00 00 00       	mov    $0x0,%ebx
  801107:	8b 55 08             	mov    0x8(%ebp),%edx
  80110a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110d:	b8 12 00 00 00       	mov    $0x12,%eax
  801112:	89 df                	mov    %ebx,%edi
  801114:	89 de                	mov    %ebx,%esi
  801116:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801118:	5b                   	pop    %ebx
  801119:	5e                   	pop    %esi
  80111a:	5f                   	pop    %edi
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	57                   	push   %edi
  801121:	56                   	push   %esi
  801122:	53                   	push   %ebx
  801123:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801126:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	b8 13 00 00 00       	mov    $0x13,%eax
  801136:	89 df                	mov    %ebx,%edi
  801138:	89 de                	mov    %ebx,%esi
  80113a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	7f 08                	jg     801148 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5f                   	pop    %edi
  801146:	5d                   	pop    %ebp
  801147:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	50                   	push   %eax
  80114c:	6a 13                	push   $0x13
  80114e:	68 68 31 80 00       	push   $0x803168
  801153:	6a 43                	push   $0x43
  801155:	68 85 31 80 00       	push   $0x803185
  80115a:	e8 e4 f0 ff ff       	call   800243 <_panic>

0080115f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	57                   	push   %edi
  801163:	56                   	push   %esi
  801164:	53                   	push   %ebx
	asm volatile("int %1\n"
  801165:	b9 00 00 00 00       	mov    $0x0,%ecx
  80116a:	8b 55 08             	mov    0x8(%ebp),%edx
  80116d:	b8 14 00 00 00       	mov    $0x14,%eax
  801172:	89 cb                	mov    %ecx,%ebx
  801174:	89 cf                	mov    %ecx,%edi
  801176:	89 ce                	mov    %ecx,%esi
  801178:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80117a:	5b                   	pop    %ebx
  80117b:	5e                   	pop    %esi
  80117c:	5f                   	pop    %edi
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    

0080117f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	05 00 00 00 30       	add    $0x30000000,%eax
  80118a:	c1 e8 0c             	shr    $0xc,%eax
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80119a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	c1 ea 16             	shr    $0x16,%edx
  8011b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ba:	f6 c2 01             	test   $0x1,%dl
  8011bd:	74 2d                	je     8011ec <fd_alloc+0x46>
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	c1 ea 0c             	shr    $0xc,%edx
  8011c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cb:	f6 c2 01             	test   $0x1,%dl
  8011ce:	74 1c                	je     8011ec <fd_alloc+0x46>
  8011d0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011d5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011da:	75 d2                	jne    8011ae <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011e5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011ea:	eb 0a                	jmp    8011f6 <fd_alloc+0x50>
			*fd_store = fd;
  8011ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011ef:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f6:	5d                   	pop    %ebp
  8011f7:	c3                   	ret    

008011f8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011fe:	83 f8 1f             	cmp    $0x1f,%eax
  801201:	77 30                	ja     801233 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801203:	c1 e0 0c             	shl    $0xc,%eax
  801206:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80120b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801211:	f6 c2 01             	test   $0x1,%dl
  801214:	74 24                	je     80123a <fd_lookup+0x42>
  801216:	89 c2                	mov    %eax,%edx
  801218:	c1 ea 0c             	shr    $0xc,%edx
  80121b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	74 1a                	je     801241 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122a:	89 02                	mov    %eax,(%edx)
	return 0;
  80122c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801231:	5d                   	pop    %ebp
  801232:	c3                   	ret    
		return -E_INVAL;
  801233:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801238:	eb f7                	jmp    801231 <fd_lookup+0x39>
		return -E_INVAL;
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123f:	eb f0                	jmp    801231 <fd_lookup+0x39>
  801241:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801246:	eb e9                	jmp    801231 <fd_lookup+0x39>

00801248 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801251:	ba 00 00 00 00       	mov    $0x0,%edx
  801256:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80125b:	39 08                	cmp    %ecx,(%eax)
  80125d:	74 38                	je     801297 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80125f:	83 c2 01             	add    $0x1,%edx
  801262:	8b 04 95 10 32 80 00 	mov    0x803210(,%edx,4),%eax
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 ee                	jne    80125b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80126d:	a1 08 50 80 00       	mov    0x805008,%eax
  801272:	8b 40 48             	mov    0x48(%eax),%eax
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	51                   	push   %ecx
  801279:	50                   	push   %eax
  80127a:	68 94 31 80 00       	push   $0x803194
  80127f:	e8 b5 f0 ff ff       	call   800339 <cprintf>
	*dev = 0;
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    
			*dev = devtab[i];
  801297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80129c:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a1:	eb f2                	jmp    801295 <dev_lookup+0x4d>

008012a3 <fd_close>:
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 24             	sub    $0x24,%esp
  8012ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8012af:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012bc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bf:	50                   	push   %eax
  8012c0:	e8 33 ff ff ff       	call   8011f8 <fd_lookup>
  8012c5:	89 c3                	mov    %eax,%ebx
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 05                	js     8012d3 <fd_close+0x30>
	    || fd != fd2)
  8012ce:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d1:	74 16                	je     8012e9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012d3:	89 f8                	mov    %edi,%eax
  8012d5:	84 c0                	test   %al,%al
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	0f 44 d8             	cmove  %eax,%ebx
}
  8012df:	89 d8                	mov    %ebx,%eax
  8012e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 36                	pushl  (%esi)
  8012f2:	e8 51 ff ff ff       	call   801248 <dev_lookup>
  8012f7:	89 c3                	mov    %eax,%ebx
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 1a                	js     80131a <fd_close+0x77>
		if (dev->dev_close)
  801300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801303:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80130b:	85 c0                	test   %eax,%eax
  80130d:	74 0b                	je     80131a <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	56                   	push   %esi
  801313:	ff d0                	call   *%eax
  801315:	89 c3                	mov    %eax,%ebx
  801317:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	56                   	push   %esi
  80131e:	6a 00                	push   $0x0
  801320:	e8 ea fb ff ff       	call   800f0f <sys_page_unmap>
	return r;
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	eb b5                	jmp    8012df <fd_close+0x3c>

0080132a <close>:

int
close(int fdnum)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801333:	50                   	push   %eax
  801334:	ff 75 08             	pushl  0x8(%ebp)
  801337:	e8 bc fe ff ff       	call   8011f8 <fd_lookup>
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	85 c0                	test   %eax,%eax
  801341:	79 02                	jns    801345 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    
		return fd_close(fd, 1);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	6a 01                	push   $0x1
  80134a:	ff 75 f4             	pushl  -0xc(%ebp)
  80134d:	e8 51 ff ff ff       	call   8012a3 <fd_close>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	eb ec                	jmp    801343 <close+0x19>

00801357 <close_all>:

void
close_all(void)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80135e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	53                   	push   %ebx
  801367:	e8 be ff ff ff       	call   80132a <close>
	for (i = 0; i < MAXFD; i++)
  80136c:	83 c3 01             	add    $0x1,%ebx
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	83 fb 20             	cmp    $0x20,%ebx
  801375:	75 ec                	jne    801363 <close_all+0xc>
}
  801377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	57                   	push   %edi
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
  801382:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801385:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801388:	50                   	push   %eax
  801389:	ff 75 08             	pushl  0x8(%ebp)
  80138c:	e8 67 fe ff ff       	call   8011f8 <fd_lookup>
  801391:	89 c3                	mov    %eax,%ebx
  801393:	83 c4 10             	add    $0x10,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	0f 88 81 00 00 00    	js     80141f <dup+0xa3>
		return r;
	close(newfdnum);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 81 ff ff ff       	call   80132a <close>

	newfd = INDEX2FD(newfdnum);
  8013a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ac:	c1 e6 0c             	shl    $0xc,%esi
  8013af:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013b5:	83 c4 04             	add    $0x4,%esp
  8013b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013bb:	e8 cf fd ff ff       	call   80118f <fd2data>
  8013c0:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c2:	89 34 24             	mov    %esi,(%esp)
  8013c5:	e8 c5 fd ff ff       	call   80118f <fd2data>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013cf:	89 d8                	mov    %ebx,%eax
  8013d1:	c1 e8 16             	shr    $0x16,%eax
  8013d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013db:	a8 01                	test   $0x1,%al
  8013dd:	74 11                	je     8013f0 <dup+0x74>
  8013df:	89 d8                	mov    %ebx,%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
  8013e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013eb:	f6 c2 01             	test   $0x1,%dl
  8013ee:	75 39                	jne    801429 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f3:	89 d0                	mov    %edx,%eax
  8013f5:	c1 e8 0c             	shr    $0xc,%eax
  8013f8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	25 07 0e 00 00       	and    $0xe07,%eax
  801407:	50                   	push   %eax
  801408:	56                   	push   %esi
  801409:	6a 00                	push   $0x0
  80140b:	52                   	push   %edx
  80140c:	6a 00                	push   $0x0
  80140e:	e8 ba fa ff ff       	call   800ecd <sys_page_map>
  801413:	89 c3                	mov    %eax,%ebx
  801415:	83 c4 20             	add    $0x20,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 31                	js     80144d <dup+0xd1>
		goto err;

	return newfdnum;
  80141c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80141f:	89 d8                	mov    %ebx,%eax
  801421:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	5f                   	pop    %edi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801429:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	25 07 0e 00 00       	and    $0xe07,%eax
  801438:	50                   	push   %eax
  801439:	57                   	push   %edi
  80143a:	6a 00                	push   $0x0
  80143c:	53                   	push   %ebx
  80143d:	6a 00                	push   $0x0
  80143f:	e8 89 fa ff ff       	call   800ecd <sys_page_map>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 20             	add    $0x20,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	79 a3                	jns    8013f0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	56                   	push   %esi
  801451:	6a 00                	push   $0x0
  801453:	e8 b7 fa ff ff       	call   800f0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801458:	83 c4 08             	add    $0x8,%esp
  80145b:	57                   	push   %edi
  80145c:	6a 00                	push   $0x0
  80145e:	e8 ac fa ff ff       	call   800f0f <sys_page_unmap>
	return r;
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	eb b7                	jmp    80141f <dup+0xa3>

00801468 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	53                   	push   %ebx
  80146c:	83 ec 1c             	sub    $0x1c,%esp
  80146f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801472:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801475:	50                   	push   %eax
  801476:	53                   	push   %ebx
  801477:	e8 7c fd ff ff       	call   8011f8 <fd_lookup>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 3f                	js     8014c2 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801489:	50                   	push   %eax
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	ff 30                	pushl  (%eax)
  80148f:	e8 b4 fd ff ff       	call   801248 <dev_lookup>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 27                	js     8014c2 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80149b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149e:	8b 42 08             	mov    0x8(%edx),%eax
  8014a1:	83 e0 03             	and    $0x3,%eax
  8014a4:	83 f8 01             	cmp    $0x1,%eax
  8014a7:	74 1e                	je     8014c7 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	8b 40 08             	mov    0x8(%eax),%eax
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 35                	je     8014e8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	ff 75 10             	pushl  0x10(%ebp)
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	52                   	push   %edx
  8014bd:	ff d0                	call   *%eax
  8014bf:	83 c4 10             	add    $0x10,%esp
}
  8014c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8014cc:	8b 40 48             	mov    0x48(%eax),%eax
  8014cf:	83 ec 04             	sub    $0x4,%esp
  8014d2:	53                   	push   %ebx
  8014d3:	50                   	push   %eax
  8014d4:	68 d5 31 80 00       	push   $0x8031d5
  8014d9:	e8 5b ee ff ff       	call   800339 <cprintf>
		return -E_INVAL;
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e6:	eb da                	jmp    8014c2 <read+0x5a>
		return -E_NOT_SUPP;
  8014e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ed:	eb d3                	jmp    8014c2 <read+0x5a>

008014ef <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	57                   	push   %edi
  8014f3:	56                   	push   %esi
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014fb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801503:	39 f3                	cmp    %esi,%ebx
  801505:	73 23                	jae    80152a <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	89 f0                	mov    %esi,%eax
  80150c:	29 d8                	sub    %ebx,%eax
  80150e:	50                   	push   %eax
  80150f:	89 d8                	mov    %ebx,%eax
  801511:	03 45 0c             	add    0xc(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	57                   	push   %edi
  801516:	e8 4d ff ff ff       	call   801468 <read>
		if (m < 0)
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 06                	js     801528 <readn+0x39>
			return m;
		if (m == 0)
  801522:	74 06                	je     80152a <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801524:	01 c3                	add    %eax,%ebx
  801526:	eb db                	jmp    801503 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801528:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80152a:	89 d8                	mov    %ebx,%eax
  80152c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5f                   	pop    %edi
  801532:	5d                   	pop    %ebp
  801533:	c3                   	ret    

00801534 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	53                   	push   %ebx
  801538:	83 ec 1c             	sub    $0x1c,%esp
  80153b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	53                   	push   %ebx
  801543:	e8 b0 fc ff ff       	call   8011f8 <fd_lookup>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 3a                	js     801589 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	50                   	push   %eax
  801556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801559:	ff 30                	pushl  (%eax)
  80155b:	e8 e8 fc ff ff       	call   801248 <dev_lookup>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 22                	js     801589 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156e:	74 1e                	je     80158e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801573:	8b 52 0c             	mov    0xc(%edx),%edx
  801576:	85 d2                	test   %edx,%edx
  801578:	74 35                	je     8015af <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	ff 75 10             	pushl  0x10(%ebp)
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	50                   	push   %eax
  801584:	ff d2                	call   *%edx
  801586:	83 c4 10             	add    $0x10,%esp
}
  801589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80158e:	a1 08 50 80 00       	mov    0x805008,%eax
  801593:	8b 40 48             	mov    0x48(%eax),%eax
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	53                   	push   %ebx
  80159a:	50                   	push   %eax
  80159b:	68 f1 31 80 00       	push   $0x8031f1
  8015a0:	e8 94 ed ff ff       	call   800339 <cprintf>
		return -E_INVAL;
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ad:	eb da                	jmp    801589 <write+0x55>
		return -E_NOT_SUPP;
  8015af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b4:	eb d3                	jmp    801589 <write+0x55>

008015b6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 30 fc ff ff       	call   8011f8 <fd_lookup>
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	78 0e                	js     8015dd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 1c             	sub    $0x1c,%esp
  8015e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ec:	50                   	push   %eax
  8015ed:	53                   	push   %ebx
  8015ee:	e8 05 fc ff ff       	call   8011f8 <fd_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 37                	js     801631 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801604:	ff 30                	pushl  (%eax)
  801606:	e8 3d fc ff ff       	call   801248 <dev_lookup>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 1f                	js     801631 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801619:	74 1b                	je     801636 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80161b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161e:	8b 52 18             	mov    0x18(%edx),%edx
  801621:	85 d2                	test   %edx,%edx
  801623:	74 32                	je     801657 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	ff 75 0c             	pushl  0xc(%ebp)
  80162b:	50                   	push   %eax
  80162c:	ff d2                	call   *%edx
  80162e:	83 c4 10             	add    $0x10,%esp
}
  801631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801634:	c9                   	leave  
  801635:	c3                   	ret    
			thisenv->env_id, fdnum);
  801636:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80163b:	8b 40 48             	mov    0x48(%eax),%eax
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	53                   	push   %ebx
  801642:	50                   	push   %eax
  801643:	68 b4 31 80 00       	push   $0x8031b4
  801648:	e8 ec ec ff ff       	call   800339 <cprintf>
		return -E_INVAL;
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801655:	eb da                	jmp    801631 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801657:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165c:	eb d3                	jmp    801631 <ftruncate+0x52>

0080165e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	53                   	push   %ebx
  801662:	83 ec 1c             	sub    $0x1c,%esp
  801665:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801668:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 84 fb ff ff       	call   8011f8 <fd_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 4b                	js     8016c6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	ff 30                	pushl  (%eax)
  801687:	e8 bc fb ff ff       	call   801248 <dev_lookup>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 33                	js     8016c6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169a:	74 2f                	je     8016cb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a6:	00 00 00 
	stat->st_isdir = 0;
  8016a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b0:	00 00 00 
	stat->st_dev = dev;
  8016b3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	53                   	push   %ebx
  8016bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c0:	ff 50 14             	call   *0x14(%eax)
  8016c3:	83 c4 10             	add    $0x10,%esp
}
  8016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d0:	eb f4                	jmp    8016c6 <fstat+0x68>

008016d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	6a 00                	push   $0x0
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	e8 22 02 00 00       	call   801906 <open>
  8016e4:	89 c3                	mov    %eax,%ebx
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 1b                	js     801708 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	e8 65 ff ff ff       	call   80165e <fstat>
  8016f9:	89 c6                	mov    %eax,%esi
	close(fd);
  8016fb:	89 1c 24             	mov    %ebx,(%esp)
  8016fe:	e8 27 fc ff ff       	call   80132a <close>
	return r;
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	89 f3                	mov    %esi,%ebx
}
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	89 c6                	mov    %eax,%esi
  801718:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171a:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801721:	74 27                	je     80174a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801723:	6a 07                	push   $0x7
  801725:	68 00 60 80 00       	push   $0x806000
  80172a:	56                   	push   %esi
  80172b:	ff 35 00 50 80 00    	pushl  0x805000
  801731:	e8 25 12 00 00       	call   80295b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801736:	83 c4 0c             	add    $0xc,%esp
  801739:	6a 00                	push   $0x0
  80173b:	53                   	push   %ebx
  80173c:	6a 00                	push   $0x0
  80173e:	e8 af 11 00 00       	call   8028f2 <ipc_recv>
}
  801743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	6a 01                	push   $0x1
  80174f:	e8 5f 12 00 00       	call   8029b3 <ipc_find_env>
  801754:	a3 00 50 80 00       	mov    %eax,0x805000
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	eb c5                	jmp    801723 <fsipc+0x12>

0080175e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8b 40 0c             	mov    0xc(%eax),%eax
  80176a:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801772:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 02 00 00 00       	mov    $0x2,%eax
  801781:	e8 8b ff ff ff       	call   801711 <fsipc>
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <devfile_flush>:
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8b 40 0c             	mov    0xc(%eax),%eax
  801794:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801799:	ba 00 00 00 00       	mov    $0x0,%edx
  80179e:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a3:	e8 69 ff ff ff       	call   801711 <fsipc>
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <devfile_stat>:
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ba:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c4:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c9:	e8 43 ff ff ff       	call   801711 <fsipc>
  8017ce:	85 c0                	test   %eax,%eax
  8017d0:	78 2c                	js     8017fe <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d2:	83 ec 08             	sub    $0x8,%esp
  8017d5:	68 00 60 80 00       	push   $0x806000
  8017da:	53                   	push   %ebx
  8017db:	e8 b8 f2 ff ff       	call   800a98 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e0:	a1 80 60 80 00       	mov    0x806080,%eax
  8017e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017eb:	a1 84 60 80 00       	mov    0x806084,%eax
  8017f0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devfile_write>:
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	53                   	push   %ebx
  801807:	83 ec 08             	sub    $0x8,%esp
  80180a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 40 0c             	mov    0xc(%eax),%eax
  801813:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801818:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80181e:	53                   	push   %ebx
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	68 08 60 80 00       	push   $0x806008
  801827:	e8 5c f4 ff ff       	call   800c88 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80182c:	ba 00 00 00 00       	mov    $0x0,%edx
  801831:	b8 04 00 00 00       	mov    $0x4,%eax
  801836:	e8 d6 fe ff ff       	call   801711 <fsipc>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 0b                	js     80184d <devfile_write+0x4a>
	assert(r <= n);
  801842:	39 d8                	cmp    %ebx,%eax
  801844:	77 0c                	ja     801852 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801846:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80184b:	7f 1e                	jg     80186b <devfile_write+0x68>
}
  80184d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801850:	c9                   	leave  
  801851:	c3                   	ret    
	assert(r <= n);
  801852:	68 24 32 80 00       	push   $0x803224
  801857:	68 2b 32 80 00       	push   $0x80322b
  80185c:	68 98 00 00 00       	push   $0x98
  801861:	68 40 32 80 00       	push   $0x803240
  801866:	e8 d8 e9 ff ff       	call   800243 <_panic>
	assert(r <= PGSIZE);
  80186b:	68 4b 32 80 00       	push   $0x80324b
  801870:	68 2b 32 80 00       	push   $0x80322b
  801875:	68 99 00 00 00       	push   $0x99
  80187a:	68 40 32 80 00       	push   $0x803240
  80187f:	e8 bf e9 ff ff       	call   800243 <_panic>

00801884 <devfile_read>:
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	56                   	push   %esi
  801888:	53                   	push   %ebx
  801889:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	8b 40 0c             	mov    0xc(%eax),%eax
  801892:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801897:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a7:	e8 65 fe ff ff       	call   801711 <fsipc>
  8018ac:	89 c3                	mov    %eax,%ebx
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 1f                	js     8018d1 <devfile_read+0x4d>
	assert(r <= n);
  8018b2:	39 f0                	cmp    %esi,%eax
  8018b4:	77 24                	ja     8018da <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018b6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018bb:	7f 33                	jg     8018f0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	50                   	push   %eax
  8018c1:	68 00 60 80 00       	push   $0x806000
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	e8 58 f3 ff ff       	call   800c26 <memmove>
	return r;
  8018ce:	83 c4 10             	add    $0x10,%esp
}
  8018d1:	89 d8                	mov    %ebx,%eax
  8018d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d6:	5b                   	pop    %ebx
  8018d7:	5e                   	pop    %esi
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    
	assert(r <= n);
  8018da:	68 24 32 80 00       	push   $0x803224
  8018df:	68 2b 32 80 00       	push   $0x80322b
  8018e4:	6a 7c                	push   $0x7c
  8018e6:	68 40 32 80 00       	push   $0x803240
  8018eb:	e8 53 e9 ff ff       	call   800243 <_panic>
	assert(r <= PGSIZE);
  8018f0:	68 4b 32 80 00       	push   $0x80324b
  8018f5:	68 2b 32 80 00       	push   $0x80322b
  8018fa:	6a 7d                	push   $0x7d
  8018fc:	68 40 32 80 00       	push   $0x803240
  801901:	e8 3d e9 ff ff       	call   800243 <_panic>

00801906 <open>:
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
  80190b:	83 ec 1c             	sub    $0x1c,%esp
  80190e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801911:	56                   	push   %esi
  801912:	e8 48 f1 ff ff       	call   800a5f <strlen>
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80191f:	7f 6c                	jg     80198d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801927:	50                   	push   %eax
  801928:	e8 79 f8 ff ff       	call   8011a6 <fd_alloc>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 3c                	js     801972 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	56                   	push   %esi
  80193a:	68 00 60 80 00       	push   $0x806000
  80193f:	e8 54 f1 ff ff       	call   800a98 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801944:	8b 45 0c             	mov    0xc(%ebp),%eax
  801947:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	b8 01 00 00 00       	mov    $0x1,%eax
  801954:	e8 b8 fd ff ff       	call   801711 <fsipc>
  801959:	89 c3                	mov    %eax,%ebx
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 19                	js     80197b <open+0x75>
	return fd2num(fd);
  801962:	83 ec 0c             	sub    $0xc,%esp
  801965:	ff 75 f4             	pushl  -0xc(%ebp)
  801968:	e8 12 f8 ff ff       	call   80117f <fd2num>
  80196d:	89 c3                	mov    %eax,%ebx
  80196f:	83 c4 10             	add    $0x10,%esp
}
  801972:	89 d8                	mov    %ebx,%eax
  801974:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    
		fd_close(fd, 0);
  80197b:	83 ec 08             	sub    $0x8,%esp
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 f4             	pushl  -0xc(%ebp)
  801983:	e8 1b f9 ff ff       	call   8012a3 <fd_close>
		return r;
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	eb e5                	jmp    801972 <open+0x6c>
		return -E_BAD_PATH;
  80198d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801992:	eb de                	jmp    801972 <open+0x6c>

00801994 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80199a:	ba 00 00 00 00       	mov    $0x0,%edx
  80199f:	b8 08 00 00 00       	mov    $0x8,%eax
  8019a4:	e8 68 fd ff ff       	call   801711 <fsipc>
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	57                   	push   %edi
  8019af:	56                   	push   %esi
  8019b0:	53                   	push   %ebx
  8019b1:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8019b7:	68 30 33 80 00       	push   $0x803330
  8019bc:	68 a7 2d 80 00       	push   $0x802da7
  8019c1:	e8 73 e9 ff ff       	call   800339 <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019c6:	83 c4 08             	add    $0x8,%esp
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	e8 33 ff ff ff       	call   801906 <open>
  8019d3:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	0f 88 0b 05 00 00    	js     801eef <spawn+0x544>
  8019e4:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	68 00 02 00 00       	push   $0x200
  8019ee:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019f4:	50                   	push   %eax
  8019f5:	51                   	push   %ecx
  8019f6:	e8 f4 fa ff ff       	call   8014ef <readn>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a03:	75 75                	jne    801a7a <spawn+0xcf>
	    || elf->e_magic != ELF_MAGIC) {
  801a05:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a0c:	45 4c 46 
  801a0f:	75 69                	jne    801a7a <spawn+0xcf>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a11:	b8 07 00 00 00       	mov    $0x7,%eax
  801a16:	cd 30                	int    $0x30
  801a18:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a1e:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a24:	85 c0                	test   %eax,%eax
  801a26:	0f 88 b7 04 00 00    	js     801ee3 <spawn+0x538>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a2c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a31:	69 f0 84 00 00 00    	imul   $0x84,%eax,%esi
  801a37:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a3d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a43:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a4a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a50:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  801a56:	83 ec 08             	sub    $0x8,%esp
  801a59:	68 24 33 80 00       	push   $0x803324
  801a5e:	68 a7 2d 80 00       	push   $0x802da7
  801a63:	e8 d1 e8 ff ff       	call   800339 <cprintf>
  801a68:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a6b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a70:	be 00 00 00 00       	mov    $0x0,%esi
  801a75:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a78:	eb 4b                	jmp    801ac5 <spawn+0x11a>
		close(fd);
  801a7a:	83 ec 0c             	sub    $0xc,%esp
  801a7d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a83:	e8 a2 f8 ff ff       	call   80132a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a88:	83 c4 0c             	add    $0xc,%esp
  801a8b:	68 7f 45 4c 46       	push   $0x464c457f
  801a90:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a96:	68 57 32 80 00       	push   $0x803257
  801a9b:	e8 99 e8 ff ff       	call   800339 <cprintf>
		return -E_NOT_EXEC;
  801aa0:	83 c4 10             	add    $0x10,%esp
  801aa3:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801aaa:	ff ff ff 
  801aad:	e9 3d 04 00 00       	jmp    801eef <spawn+0x544>
		string_size += strlen(argv[argc]) + 1;
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	50                   	push   %eax
  801ab6:	e8 a4 ef ff ff       	call   800a5f <strlen>
  801abb:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801abf:	83 c3 01             	add    $0x1,%ebx
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801acc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	75 df                	jne    801ab2 <spawn+0x107>
  801ad3:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801ad9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801adf:	bf 00 10 40 00       	mov    $0x401000,%edi
  801ae4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ae6:	89 fa                	mov    %edi,%edx
  801ae8:	83 e2 fc             	and    $0xfffffffc,%edx
  801aeb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801af2:	29 c2                	sub    %eax,%edx
  801af4:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801afa:	8d 42 f8             	lea    -0x8(%edx),%eax
  801afd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b02:	0f 86 0a 04 00 00    	jbe    801f12 <spawn+0x567>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	6a 07                	push   $0x7
  801b0d:	68 00 00 40 00       	push   $0x400000
  801b12:	6a 00                	push   $0x0
  801b14:	e8 71 f3 ff ff       	call   800e8a <sys_page_alloc>
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	0f 88 f3 03 00 00    	js     801f17 <spawn+0x56c>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b24:	be 00 00 00 00       	mov    $0x0,%esi
  801b29:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b32:	eb 30                	jmp    801b64 <spawn+0x1b9>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b34:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b3a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b40:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b43:	83 ec 08             	sub    $0x8,%esp
  801b46:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b49:	57                   	push   %edi
  801b4a:	e8 49 ef ff ff       	call   800a98 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b4f:	83 c4 04             	add    $0x4,%esp
  801b52:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b55:	e8 05 ef ff ff       	call   800a5f <strlen>
  801b5a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b5e:	83 c6 01             	add    $0x1,%esi
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b6a:	7f c8                	jg     801b34 <spawn+0x189>
	}
	argv_store[argc] = 0;
  801b6c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b72:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b78:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b7f:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b85:	0f 85 86 00 00 00    	jne    801c11 <spawn+0x266>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b8b:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801b91:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801b97:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801b9a:	89 d0                	mov    %edx,%eax
  801b9c:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ba2:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ba5:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801baa:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bb0:	83 ec 0c             	sub    $0xc,%esp
  801bb3:	6a 07                	push   $0x7
  801bb5:	68 00 d0 bf ee       	push   $0xeebfd000
  801bba:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bc0:	68 00 00 40 00       	push   $0x400000
  801bc5:	6a 00                	push   $0x0
  801bc7:	e8 01 f3 ff ff       	call   800ecd <sys_page_map>
  801bcc:	89 c3                	mov    %eax,%ebx
  801bce:	83 c4 20             	add    $0x20,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 88 46 03 00 00    	js     801f1f <spawn+0x574>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801bd9:	83 ec 08             	sub    $0x8,%esp
  801bdc:	68 00 00 40 00       	push   $0x400000
  801be1:	6a 00                	push   $0x0
  801be3:	e8 27 f3 ff ff       	call   800f0f <sys_page_unmap>
  801be8:	89 c3                	mov    %eax,%ebx
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	85 c0                	test   %eax,%eax
  801bef:	0f 88 2a 03 00 00    	js     801f1f <spawn+0x574>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bf5:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bfb:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c02:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801c09:	00 00 00 
  801c0c:	e9 4f 01 00 00       	jmp    801d60 <spawn+0x3b5>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c11:	68 e0 32 80 00       	push   $0x8032e0
  801c16:	68 2b 32 80 00       	push   $0x80322b
  801c1b:	68 f8 00 00 00       	push   $0xf8
  801c20:	68 71 32 80 00       	push   $0x803271
  801c25:	e8 19 e6 ff ff       	call   800243 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	6a 07                	push   $0x7
  801c2f:	68 00 00 40 00       	push   $0x400000
  801c34:	6a 00                	push   $0x0
  801c36:	e8 4f f2 ff ff       	call   800e8a <sys_page_alloc>
  801c3b:	83 c4 10             	add    $0x10,%esp
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	0f 88 b7 02 00 00    	js     801efd <spawn+0x552>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c46:	83 ec 08             	sub    $0x8,%esp
  801c49:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c4f:	01 f0                	add    %esi,%eax
  801c51:	50                   	push   %eax
  801c52:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c58:	e8 59 f9 ff ff       	call   8015b6 <seek>
  801c5d:	83 c4 10             	add    $0x10,%esp
  801c60:	85 c0                	test   %eax,%eax
  801c62:	0f 88 9c 02 00 00    	js     801f04 <spawn+0x559>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c71:	29 f0                	sub    %esi,%eax
  801c73:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c78:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c7d:	0f 47 c1             	cmova  %ecx,%eax
  801c80:	50                   	push   %eax
  801c81:	68 00 00 40 00       	push   $0x400000
  801c86:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c8c:	e8 5e f8 ff ff       	call   8014ef <readn>
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	0f 88 6f 02 00 00    	js     801f0b <spawn+0x560>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ca5:	53                   	push   %ebx
  801ca6:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801cac:	68 00 00 40 00       	push   $0x400000
  801cb1:	6a 00                	push   $0x0
  801cb3:	e8 15 f2 ff ff       	call   800ecd <sys_page_map>
  801cb8:	83 c4 20             	add    $0x20,%esp
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 7c                	js     801d3b <spawn+0x390>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	68 00 00 40 00       	push   $0x400000
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 41 f2 ff ff       	call   800f0f <sys_page_unmap>
  801cce:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cd1:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cd7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cdd:	89 fe                	mov    %edi,%esi
  801cdf:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801ce5:	76 69                	jbe    801d50 <spawn+0x3a5>
		if (i >= filesz) {
  801ce7:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801ced:	0f 87 37 ff ff ff    	ja     801c2a <spawn+0x27f>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cfc:	53                   	push   %ebx
  801cfd:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d03:	e8 82 f1 ff ff       	call   800e8a <sys_page_alloc>
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	79 c2                	jns    801cd1 <spawn+0x326>
  801d0f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d1a:	e8 ec f0 ff ff       	call   800e0b <sys_env_destroy>
	close(fd);
  801d1f:	83 c4 04             	add    $0x4,%esp
  801d22:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d28:	e8 fd f5 ff ff       	call   80132a <close>
	return r;
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d36:	e9 b4 01 00 00       	jmp    801eef <spawn+0x544>
				panic("spawn: sys_page_map data: %e", r);
  801d3b:	50                   	push   %eax
  801d3c:	68 7d 32 80 00       	push   $0x80327d
  801d41:	68 2b 01 00 00       	push   $0x12b
  801d46:	68 71 32 80 00       	push   $0x803271
  801d4b:	e8 f3 e4 ff ff       	call   800243 <_panic>
  801d50:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d56:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d5d:	83 c6 20             	add    $0x20,%esi
  801d60:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d67:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d6d:	7e 6d                	jle    801ddc <spawn+0x431>
		if (ph->p_type != ELF_PROG_LOAD)
  801d6f:	83 3e 01             	cmpl   $0x1,(%esi)
  801d72:	75 e2                	jne    801d56 <spawn+0x3ab>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d74:	8b 46 18             	mov    0x18(%esi),%eax
  801d77:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d7a:	83 f8 01             	cmp    $0x1,%eax
  801d7d:	19 c0                	sbb    %eax,%eax
  801d7f:	83 e0 fe             	and    $0xfffffffe,%eax
  801d82:	83 c0 07             	add    $0x7,%eax
  801d85:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d8b:	8b 4e 04             	mov    0x4(%esi),%ecx
  801d8e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801d94:	8b 56 10             	mov    0x10(%esi),%edx
  801d97:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801d9d:	8b 7e 14             	mov    0x14(%esi),%edi
  801da0:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801da6:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801da9:	89 d8                	mov    %ebx,%eax
  801dab:	25 ff 0f 00 00       	and    $0xfff,%eax
  801db0:	74 1a                	je     801dcc <spawn+0x421>
		va -= i;
  801db2:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801db4:	01 c7                	add    %eax,%edi
  801db6:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801dbc:	01 c2                	add    %eax,%edx
  801dbe:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801dc4:	29 c1                	sub    %eax,%ecx
  801dc6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dcc:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd1:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801dd7:	e9 01 ff ff ff       	jmp    801cdd <spawn+0x332>
	close(fd);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801de5:	e8 40 f5 ff ff       	call   80132a <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801dea:	83 c4 08             	add    $0x8,%esp
  801ded:	68 10 33 80 00       	push   $0x803310
  801df2:	68 a7 2d 80 00       	push   $0x802da7
  801df7:	e8 3d e5 ff ff       	call   800339 <cprintf>
  801dfc:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801dff:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801e04:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801e0a:	eb 0e                	jmp    801e1a <spawn+0x46f>
  801e0c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e12:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e18:	74 5e                	je     801e78 <spawn+0x4cd>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801e1a:	89 d8                	mov    %ebx,%eax
  801e1c:	c1 e8 16             	shr    $0x16,%eax
  801e1f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e26:	a8 01                	test   $0x1,%al
  801e28:	74 e2                	je     801e0c <spawn+0x461>
  801e2a:	89 da                	mov    %ebx,%edx
  801e2c:	c1 ea 0c             	shr    $0xc,%edx
  801e2f:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e36:	25 05 04 00 00       	and    $0x405,%eax
  801e3b:	3d 05 04 00 00       	cmp    $0x405,%eax
  801e40:	75 ca                	jne    801e0c <spawn+0x461>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801e42:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e49:	83 ec 0c             	sub    $0xc,%esp
  801e4c:	25 07 0e 00 00       	and    $0xe07,%eax
  801e51:	50                   	push   %eax
  801e52:	53                   	push   %ebx
  801e53:	56                   	push   %esi
  801e54:	53                   	push   %ebx
  801e55:	6a 00                	push   $0x0
  801e57:	e8 71 f0 ff ff       	call   800ecd <sys_page_map>
  801e5c:	83 c4 20             	add    $0x20,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	79 a9                	jns    801e0c <spawn+0x461>
        		panic("sys_page_map: %e\n", r);
  801e63:	50                   	push   %eax
  801e64:	68 9a 32 80 00       	push   $0x80329a
  801e69:	68 3b 01 00 00       	push   $0x13b
  801e6e:	68 71 32 80 00       	push   $0x803271
  801e73:	e8 cb e3 ff ff       	call   800243 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e81:	50                   	push   %eax
  801e82:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e88:	e8 06 f1 ff ff       	call   800f93 <sys_env_set_trapframe>
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	85 c0                	test   %eax,%eax
  801e92:	78 25                	js     801eb9 <spawn+0x50e>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801e94:	83 ec 08             	sub    $0x8,%esp
  801e97:	6a 02                	push   $0x2
  801e99:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e9f:	e8 ad f0 ff ff       	call   800f51 <sys_env_set_status>
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 23                	js     801ece <spawn+0x523>
	return child;
  801eab:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801eb1:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801eb7:	eb 36                	jmp    801eef <spawn+0x544>
		panic("sys_env_set_trapframe: %e", r);
  801eb9:	50                   	push   %eax
  801eba:	68 ac 32 80 00       	push   $0x8032ac
  801ebf:	68 8a 00 00 00       	push   $0x8a
  801ec4:	68 71 32 80 00       	push   $0x803271
  801ec9:	e8 75 e3 ff ff       	call   800243 <_panic>
		panic("sys_env_set_status: %e", r);
  801ece:	50                   	push   %eax
  801ecf:	68 c6 32 80 00       	push   $0x8032c6
  801ed4:	68 8d 00 00 00       	push   $0x8d
  801ed9:	68 71 32 80 00       	push   $0x803271
  801ede:	e8 60 e3 ff ff       	call   800243 <_panic>
		return r;
  801ee3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ee9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801eef:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef8:	5b                   	pop    %ebx
  801ef9:	5e                   	pop    %esi
  801efa:	5f                   	pop    %edi
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    
  801efd:	89 c7                	mov    %eax,%edi
  801eff:	e9 0d fe ff ff       	jmp    801d11 <spawn+0x366>
  801f04:	89 c7                	mov    %eax,%edi
  801f06:	e9 06 fe ff ff       	jmp    801d11 <spawn+0x366>
  801f0b:	89 c7                	mov    %eax,%edi
  801f0d:	e9 ff fd ff ff       	jmp    801d11 <spawn+0x366>
		return -E_NO_MEM;
  801f12:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801f17:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f1d:	eb d0                	jmp    801eef <spawn+0x544>
	sys_page_unmap(0, UTEMP);
  801f1f:	83 ec 08             	sub    $0x8,%esp
  801f22:	68 00 00 40 00       	push   $0x400000
  801f27:	6a 00                	push   $0x0
  801f29:	e8 e1 ef ff ff       	call   800f0f <sys_page_unmap>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f37:	eb b6                	jmp    801eef <spawn+0x544>

00801f39 <spawnl>:
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	57                   	push   %edi
  801f3d:	56                   	push   %esi
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801f42:	68 08 33 80 00       	push   $0x803308
  801f47:	68 a7 2d 80 00       	push   $0x802da7
  801f4c:	e8 e8 e3 ff ff       	call   800339 <cprintf>
	va_start(vl, arg0);
  801f51:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801f54:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f5c:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f5f:	83 3a 00             	cmpl   $0x0,(%edx)
  801f62:	74 07                	je     801f6b <spawnl+0x32>
		argc++;
  801f64:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f67:	89 ca                	mov    %ecx,%edx
  801f69:	eb f1                	jmp    801f5c <spawnl+0x23>
	const char *argv[argc+2];
  801f6b:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f72:	83 e2 f0             	and    $0xfffffff0,%edx
  801f75:	29 d4                	sub    %edx,%esp
  801f77:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f7b:	c1 ea 02             	shr    $0x2,%edx
  801f7e:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f85:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8a:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f91:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f98:	00 
	va_start(vl, arg0);
  801f99:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f9c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	eb 0b                	jmp    801fb0 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801fa5:	83 c0 01             	add    $0x1,%eax
  801fa8:	8b 39                	mov    (%ecx),%edi
  801faa:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801fad:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801fb0:	39 d0                	cmp    %edx,%eax
  801fb2:	75 f1                	jne    801fa5 <spawnl+0x6c>
	return spawn(prog, argv);
  801fb4:	83 ec 08             	sub    $0x8,%esp
  801fb7:	56                   	push   %esi
  801fb8:	ff 75 08             	pushl  0x8(%ebp)
  801fbb:	e8 eb f9 ff ff       	call   8019ab <spawn>
}
  801fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc3:	5b                   	pop    %ebx
  801fc4:	5e                   	pop    %esi
  801fc5:	5f                   	pop    %edi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801fce:	68 36 33 80 00       	push   $0x803336
  801fd3:	ff 75 0c             	pushl  0xc(%ebp)
  801fd6:	e8 bd ea ff ff       	call   800a98 <strcpy>
	return 0;
}
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <devsock_close>:
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	53                   	push   %ebx
  801fe6:	83 ec 10             	sub    $0x10,%esp
  801fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fec:	53                   	push   %ebx
  801fed:	e8 00 0a 00 00       	call   8029f2 <pageref>
  801ff2:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ff5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ffa:	83 f8 01             	cmp    $0x1,%eax
  801ffd:	74 07                	je     802006 <devsock_close+0x24>
}
  801fff:	89 d0                	mov    %edx,%eax
  802001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802004:	c9                   	leave  
  802005:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	ff 73 0c             	pushl  0xc(%ebx)
  80200c:	e8 b9 02 00 00       	call   8022ca <nsipc_close>
  802011:	89 c2                	mov    %eax,%edx
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	eb e7                	jmp    801fff <devsock_close+0x1d>

00802018 <devsock_write>:
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 10             	pushl  0x10(%ebp)
  802023:	ff 75 0c             	pushl  0xc(%ebp)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	ff 70 0c             	pushl  0xc(%eax)
  80202c:	e8 76 03 00 00       	call   8023a7 <nsipc_send>
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <devsock_read>:
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 10             	pushl  0x10(%ebp)
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	ff 70 0c             	pushl  0xc(%eax)
  802047:	e8 ef 02 00 00       	call   80233b <nsipc_recv>
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <fd2sockid>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802054:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	e8 9a f1 ff ff       	call   8011f8 <fd_lookup>
  80205e:	83 c4 10             	add    $0x10,%esp
  802061:	85 c0                	test   %eax,%eax
  802063:	78 10                	js     802075 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80206e:	39 08                	cmp    %ecx,(%eax)
  802070:	75 05                	jne    802077 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802072:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    
		return -E_NOT_SUPP;
  802077:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80207c:	eb f7                	jmp    802075 <fd2sockid+0x27>

0080207e <alloc_sockfd>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	56                   	push   %esi
  802082:	53                   	push   %ebx
  802083:	83 ec 1c             	sub    $0x1c,%esp
  802086:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802088:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208b:	50                   	push   %eax
  80208c:	e8 15 f1 ff ff       	call   8011a6 <fd_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	83 c4 10             	add    $0x10,%esp
  802096:	85 c0                	test   %eax,%eax
  802098:	78 43                	js     8020dd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 07 04 00 00       	push   $0x407
  8020a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a5:	6a 00                	push   $0x0
  8020a7:	e8 de ed ff ff       	call   800e8a <sys_page_alloc>
  8020ac:	89 c3                	mov    %eax,%ebx
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	78 28                	js     8020dd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8020be:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8020ca:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	50                   	push   %eax
  8020d1:	e8 a9 f0 ff ff       	call   80117f <fd2num>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	eb 0c                	jmp    8020e9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	56                   	push   %esi
  8020e1:	e8 e4 01 00 00       	call   8022ca <nsipc_close>
		return r;
  8020e6:	83 c4 10             	add    $0x10,%esp
}
  8020e9:	89 d8                	mov    %ebx,%eax
  8020eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ee:	5b                   	pop    %ebx
  8020ef:	5e                   	pop    %esi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    

008020f2 <accept>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	e8 4e ff ff ff       	call   80204e <fd2sockid>
  802100:	85 c0                	test   %eax,%eax
  802102:	78 1b                	js     80211f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	ff 75 10             	pushl  0x10(%ebp)
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	50                   	push   %eax
  80210e:	e8 0e 01 00 00       	call   802221 <nsipc_accept>
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	85 c0                	test   %eax,%eax
  802118:	78 05                	js     80211f <accept+0x2d>
	return alloc_sockfd(r);
  80211a:	e8 5f ff ff ff       	call   80207e <alloc_sockfd>
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <bind>:
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	e8 1f ff ff ff       	call   80204e <fd2sockid>
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 12                	js     802145 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	ff 75 10             	pushl  0x10(%ebp)
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	50                   	push   %eax
  80213d:	e8 31 01 00 00       	call   802273 <nsipc_bind>
  802142:	83 c4 10             	add    $0x10,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <shutdown>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	e8 f9 fe ff ff       	call   80204e <fd2sockid>
  802155:	85 c0                	test   %eax,%eax
  802157:	78 0f                	js     802168 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802159:	83 ec 08             	sub    $0x8,%esp
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	50                   	push   %eax
  802160:	e8 43 01 00 00       	call   8022a8 <nsipc_shutdown>
  802165:	83 c4 10             	add    $0x10,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <connect>:
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	e8 d6 fe ff ff       	call   80204e <fd2sockid>
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 12                	js     80218e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	ff 75 10             	pushl  0x10(%ebp)
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	50                   	push   %eax
  802186:	e8 59 01 00 00       	call   8022e4 <nsipc_connect>
  80218b:	83 c4 10             	add    $0x10,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <listen>:
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	e8 b0 fe ff ff       	call   80204e <fd2sockid>
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 0f                	js     8021b1 <listen+0x21>
	return nsipc_listen(r, backlog);
  8021a2:	83 ec 08             	sub    $0x8,%esp
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	50                   	push   %eax
  8021a9:	e8 6b 01 00 00       	call   802319 <nsipc_listen>
  8021ae:	83 c4 10             	add    $0x10,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021b9:	ff 75 10             	pushl  0x10(%ebp)
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	e8 3e 02 00 00       	call   802405 <nsipc_socket>
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 05                	js     8021d3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8021ce:	e8 ab fe ff ff       	call   80207e <alloc_sockfd>
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
  8021d9:	83 ec 04             	sub    $0x4,%esp
  8021dc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021de:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021e5:	74 26                	je     80220d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021e7:	6a 07                	push   $0x7
  8021e9:	68 00 70 80 00       	push   $0x807000
  8021ee:	53                   	push   %ebx
  8021ef:	ff 35 04 50 80 00    	pushl  0x805004
  8021f5:	e8 61 07 00 00       	call   80295b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021fa:	83 c4 0c             	add    $0xc,%esp
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	e8 ea 06 00 00       	call   8028f2 <ipc_recv>
}
  802208:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	6a 02                	push   $0x2
  802212:	e8 9c 07 00 00       	call   8029b3 <ipc_find_env>
  802217:	a3 04 50 80 00       	mov    %eax,0x805004
  80221c:	83 c4 10             	add    $0x10,%esp
  80221f:	eb c6                	jmp    8021e7 <nsipc+0x12>

00802221 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	56                   	push   %esi
  802225:	53                   	push   %ebx
  802226:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802231:	8b 06                	mov    (%esi),%eax
  802233:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802238:	b8 01 00 00 00       	mov    $0x1,%eax
  80223d:	e8 93 ff ff ff       	call   8021d5 <nsipc>
  802242:	89 c3                	mov    %eax,%ebx
  802244:	85 c0                	test   %eax,%eax
  802246:	79 09                	jns    802251 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802248:	89 d8                	mov    %ebx,%eax
  80224a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	ff 35 10 70 80 00    	pushl  0x807010
  80225a:	68 00 70 80 00       	push   $0x807000
  80225f:	ff 75 0c             	pushl  0xc(%ebp)
  802262:	e8 bf e9 ff ff       	call   800c26 <memmove>
		*addrlen = ret->ret_addrlen;
  802267:	a1 10 70 80 00       	mov    0x807010,%eax
  80226c:	89 06                	mov    %eax,(%esi)
  80226e:	83 c4 10             	add    $0x10,%esp
	return r;
  802271:	eb d5                	jmp    802248 <nsipc_accept+0x27>

00802273 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	53                   	push   %ebx
  802277:	83 ec 08             	sub    $0x8,%esp
  80227a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802285:	53                   	push   %ebx
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	68 04 70 80 00       	push   $0x807004
  80228e:	e8 93 e9 ff ff       	call   800c26 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802293:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802299:	b8 02 00 00 00       	mov    $0x2,%eax
  80229e:	e8 32 ff ff ff       	call   8021d5 <nsipc>
}
  8022a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022be:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c3:	e8 0d ff ff ff       	call   8021d5 <nsipc>
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <nsipc_close>:

int
nsipc_close(int s)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8022dd:	e8 f3 fe ff ff       	call   8021d5 <nsipc>
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	53                   	push   %ebx
  8022e8:	83 ec 08             	sub    $0x8,%esp
  8022eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022f6:	53                   	push   %ebx
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	68 04 70 80 00       	push   $0x807004
  8022ff:	e8 22 e9 ff ff       	call   800c26 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802304:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80230a:	b8 05 00 00 00       	mov    $0x5,%eax
  80230f:	e8 c1 fe ff ff       	call   8021d5 <nsipc>
}
  802314:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80232f:	b8 06 00 00 00       	mov    $0x6,%eax
  802334:	e8 9c fe ff ff       	call   8021d5 <nsipc>
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	56                   	push   %esi
  80233f:	53                   	push   %ebx
  802340:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80234b:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802351:	8b 45 14             	mov    0x14(%ebp),%eax
  802354:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802359:	b8 07 00 00 00       	mov    $0x7,%eax
  80235e:	e8 72 fe ff ff       	call   8021d5 <nsipc>
  802363:	89 c3                	mov    %eax,%ebx
  802365:	85 c0                	test   %eax,%eax
  802367:	78 1f                	js     802388 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  802369:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80236e:	7f 21                	jg     802391 <nsipc_recv+0x56>
  802370:	39 c6                	cmp    %eax,%esi
  802372:	7c 1d                	jl     802391 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802374:	83 ec 04             	sub    $0x4,%esp
  802377:	50                   	push   %eax
  802378:	68 00 70 80 00       	push   $0x807000
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	e8 a1 e8 ff ff       	call   800c26 <memmove>
  802385:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80238d:	5b                   	pop    %ebx
  80238e:	5e                   	pop    %esi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802391:	68 42 33 80 00       	push   $0x803342
  802396:	68 2b 32 80 00       	push   $0x80322b
  80239b:	6a 62                	push   $0x62
  80239d:	68 57 33 80 00       	push   $0x803357
  8023a2:	e8 9c de ff ff       	call   800243 <_panic>

008023a7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	53                   	push   %ebx
  8023ab:	83 ec 04             	sub    $0x4,%esp
  8023ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023b9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023bf:	7f 2e                	jg     8023ef <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	53                   	push   %ebx
  8023c5:	ff 75 0c             	pushl  0xc(%ebp)
  8023c8:	68 0c 70 80 00       	push   $0x80700c
  8023cd:	e8 54 e8 ff ff       	call   800c26 <memmove>
	nsipcbuf.send.req_size = size;
  8023d2:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023db:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e5:	e8 eb fd ff ff       	call   8021d5 <nsipc>
}
  8023ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    
	assert(size < 1600);
  8023ef:	68 63 33 80 00       	push   $0x803363
  8023f4:	68 2b 32 80 00       	push   $0x80322b
  8023f9:	6a 6d                	push   $0x6d
  8023fb:	68 57 33 80 00       	push   $0x803357
  802400:	e8 3e de ff ff       	call   800243 <_panic>

00802405 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802413:	8b 45 0c             	mov    0xc(%ebp),%eax
  802416:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80241b:	8b 45 10             	mov    0x10(%ebp),%eax
  80241e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802423:	b8 09 00 00 00       	mov    $0x9,%eax
  802428:	e8 a8 fd ff ff       	call   8021d5 <nsipc>
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802437:	83 ec 0c             	sub    $0xc,%esp
  80243a:	ff 75 08             	pushl  0x8(%ebp)
  80243d:	e8 4d ed ff ff       	call   80118f <fd2data>
  802442:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802444:	83 c4 08             	add    $0x8,%esp
  802447:	68 6f 33 80 00       	push   $0x80336f
  80244c:	53                   	push   %ebx
  80244d:	e8 46 e6 ff ff       	call   800a98 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802452:	8b 46 04             	mov    0x4(%esi),%eax
  802455:	2b 06                	sub    (%esi),%eax
  802457:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80245d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802464:	00 00 00 
	stat->st_dev = &devpipe;
  802467:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80246e:	40 80 00 
	return 0;
}
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802479:	5b                   	pop    %ebx
  80247a:	5e                   	pop    %esi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    

0080247d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	53                   	push   %ebx
  802481:	83 ec 0c             	sub    $0xc,%esp
  802484:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802487:	53                   	push   %ebx
  802488:	6a 00                	push   $0x0
  80248a:	e8 80 ea ff ff       	call   800f0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80248f:	89 1c 24             	mov    %ebx,(%esp)
  802492:	e8 f8 ec ff ff       	call   80118f <fd2data>
  802497:	83 c4 08             	add    $0x8,%esp
  80249a:	50                   	push   %eax
  80249b:	6a 00                	push   $0x0
  80249d:	e8 6d ea ff ff       	call   800f0f <sys_page_unmap>
}
  8024a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <_pipeisclosed>:
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	57                   	push   %edi
  8024ab:	56                   	push   %esi
  8024ac:	53                   	push   %ebx
  8024ad:	83 ec 1c             	sub    $0x1c,%esp
  8024b0:	89 c7                	mov    %eax,%edi
  8024b2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8024b4:	a1 08 50 80 00       	mov    0x805008,%eax
  8024b9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	57                   	push   %edi
  8024c0:	e8 2d 05 00 00       	call   8029f2 <pageref>
  8024c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8024c8:	89 34 24             	mov    %esi,(%esp)
  8024cb:	e8 22 05 00 00       	call   8029f2 <pageref>
		nn = thisenv->env_runs;
  8024d0:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8024d6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024d9:	83 c4 10             	add    $0x10,%esp
  8024dc:	39 cb                	cmp    %ecx,%ebx
  8024de:	74 1b                	je     8024fb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8024e0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024e3:	75 cf                	jne    8024b4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024e5:	8b 42 58             	mov    0x58(%edx),%eax
  8024e8:	6a 01                	push   $0x1
  8024ea:	50                   	push   %eax
  8024eb:	53                   	push   %ebx
  8024ec:	68 76 33 80 00       	push   $0x803376
  8024f1:	e8 43 de ff ff       	call   800339 <cprintf>
  8024f6:	83 c4 10             	add    $0x10,%esp
  8024f9:	eb b9                	jmp    8024b4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024fb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024fe:	0f 94 c0             	sete   %al
  802501:	0f b6 c0             	movzbl %al,%eax
}
  802504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802507:	5b                   	pop    %ebx
  802508:	5e                   	pop    %esi
  802509:	5f                   	pop    %edi
  80250a:	5d                   	pop    %ebp
  80250b:	c3                   	ret    

0080250c <devpipe_write>:
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	57                   	push   %edi
  802510:	56                   	push   %esi
  802511:	53                   	push   %ebx
  802512:	83 ec 28             	sub    $0x28,%esp
  802515:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802518:	56                   	push   %esi
  802519:	e8 71 ec ff ff       	call   80118f <fd2data>
  80251e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802520:	83 c4 10             	add    $0x10,%esp
  802523:	bf 00 00 00 00       	mov    $0x0,%edi
  802528:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80252b:	74 4f                	je     80257c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80252d:	8b 43 04             	mov    0x4(%ebx),%eax
  802530:	8b 0b                	mov    (%ebx),%ecx
  802532:	8d 51 20             	lea    0x20(%ecx),%edx
  802535:	39 d0                	cmp    %edx,%eax
  802537:	72 14                	jb     80254d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802539:	89 da                	mov    %ebx,%edx
  80253b:	89 f0                	mov    %esi,%eax
  80253d:	e8 65 ff ff ff       	call   8024a7 <_pipeisclosed>
  802542:	85 c0                	test   %eax,%eax
  802544:	75 3b                	jne    802581 <devpipe_write+0x75>
			sys_yield();
  802546:	e8 20 e9 ff ff       	call   800e6b <sys_yield>
  80254b:	eb e0                	jmp    80252d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80254d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802550:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802554:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802557:	89 c2                	mov    %eax,%edx
  802559:	c1 fa 1f             	sar    $0x1f,%edx
  80255c:	89 d1                	mov    %edx,%ecx
  80255e:	c1 e9 1b             	shr    $0x1b,%ecx
  802561:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802564:	83 e2 1f             	and    $0x1f,%edx
  802567:	29 ca                	sub    %ecx,%edx
  802569:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80256d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802571:	83 c0 01             	add    $0x1,%eax
  802574:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802577:	83 c7 01             	add    $0x1,%edi
  80257a:	eb ac                	jmp    802528 <devpipe_write+0x1c>
	return i;
  80257c:	8b 45 10             	mov    0x10(%ebp),%eax
  80257f:	eb 05                	jmp    802586 <devpipe_write+0x7a>
				return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802589:	5b                   	pop    %ebx
  80258a:	5e                   	pop    %esi
  80258b:	5f                   	pop    %edi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    

0080258e <devpipe_read>:
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	53                   	push   %ebx
  802594:	83 ec 18             	sub    $0x18,%esp
  802597:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80259a:	57                   	push   %edi
  80259b:	e8 ef eb ff ff       	call   80118f <fd2data>
  8025a0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	be 00 00 00 00       	mov    $0x0,%esi
  8025aa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025ad:	75 14                	jne    8025c3 <devpipe_read+0x35>
	return i;
  8025af:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b2:	eb 02                	jmp    8025b6 <devpipe_read+0x28>
				return i;
  8025b4:	89 f0                	mov    %esi,%eax
}
  8025b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025b9:	5b                   	pop    %ebx
  8025ba:	5e                   	pop    %esi
  8025bb:	5f                   	pop    %edi
  8025bc:	5d                   	pop    %ebp
  8025bd:	c3                   	ret    
			sys_yield();
  8025be:	e8 a8 e8 ff ff       	call   800e6b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8025c3:	8b 03                	mov    (%ebx),%eax
  8025c5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025c8:	75 18                	jne    8025e2 <devpipe_read+0x54>
			if (i > 0)
  8025ca:	85 f6                	test   %esi,%esi
  8025cc:	75 e6                	jne    8025b4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8025ce:	89 da                	mov    %ebx,%edx
  8025d0:	89 f8                	mov    %edi,%eax
  8025d2:	e8 d0 fe ff ff       	call   8024a7 <_pipeisclosed>
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	74 e3                	je     8025be <devpipe_read+0x30>
				return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	eb d4                	jmp    8025b6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025e2:	99                   	cltd   
  8025e3:	c1 ea 1b             	shr    $0x1b,%edx
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	83 e0 1f             	and    $0x1f,%eax
  8025eb:	29 d0                	sub    %edx,%eax
  8025ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025f8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025fb:	83 c6 01             	add    $0x1,%esi
  8025fe:	eb aa                	jmp    8025aa <devpipe_read+0x1c>

00802600 <pipe>:
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	56                   	push   %esi
  802604:	53                   	push   %ebx
  802605:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260b:	50                   	push   %eax
  80260c:	e8 95 eb ff ff       	call   8011a6 <fd_alloc>
  802611:	89 c3                	mov    %eax,%ebx
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	85 c0                	test   %eax,%eax
  802618:	0f 88 23 01 00 00    	js     802741 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261e:	83 ec 04             	sub    $0x4,%esp
  802621:	68 07 04 00 00       	push   $0x407
  802626:	ff 75 f4             	pushl  -0xc(%ebp)
  802629:	6a 00                	push   $0x0
  80262b:	e8 5a e8 ff ff       	call   800e8a <sys_page_alloc>
  802630:	89 c3                	mov    %eax,%ebx
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	85 c0                	test   %eax,%eax
  802637:	0f 88 04 01 00 00    	js     802741 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80263d:	83 ec 0c             	sub    $0xc,%esp
  802640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802643:	50                   	push   %eax
  802644:	e8 5d eb ff ff       	call   8011a6 <fd_alloc>
  802649:	89 c3                	mov    %eax,%ebx
  80264b:	83 c4 10             	add    $0x10,%esp
  80264e:	85 c0                	test   %eax,%eax
  802650:	0f 88 db 00 00 00    	js     802731 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	68 07 04 00 00       	push   $0x407
  80265e:	ff 75 f0             	pushl  -0x10(%ebp)
  802661:	6a 00                	push   $0x0
  802663:	e8 22 e8 ff ff       	call   800e8a <sys_page_alloc>
  802668:	89 c3                	mov    %eax,%ebx
  80266a:	83 c4 10             	add    $0x10,%esp
  80266d:	85 c0                	test   %eax,%eax
  80266f:	0f 88 bc 00 00 00    	js     802731 <pipe+0x131>
	va = fd2data(fd0);
  802675:	83 ec 0c             	sub    $0xc,%esp
  802678:	ff 75 f4             	pushl  -0xc(%ebp)
  80267b:	e8 0f eb ff ff       	call   80118f <fd2data>
  802680:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802682:	83 c4 0c             	add    $0xc,%esp
  802685:	68 07 04 00 00       	push   $0x407
  80268a:	50                   	push   %eax
  80268b:	6a 00                	push   $0x0
  80268d:	e8 f8 e7 ff ff       	call   800e8a <sys_page_alloc>
  802692:	89 c3                	mov    %eax,%ebx
  802694:	83 c4 10             	add    $0x10,%esp
  802697:	85 c0                	test   %eax,%eax
  802699:	0f 88 82 00 00 00    	js     802721 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8026a5:	e8 e5 ea ff ff       	call   80118f <fd2data>
  8026aa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8026b1:	50                   	push   %eax
  8026b2:	6a 00                	push   $0x0
  8026b4:	56                   	push   %esi
  8026b5:	6a 00                	push   $0x0
  8026b7:	e8 11 e8 ff ff       	call   800ecd <sys_page_map>
  8026bc:	89 c3                	mov    %eax,%ebx
  8026be:	83 c4 20             	add    $0x20,%esp
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	78 4e                	js     802713 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8026c5:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8026d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026dc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ee:	e8 8c ea ff ff       	call   80117f <fd2num>
  8026f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026f6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026f8:	83 c4 04             	add    $0x4,%esp
  8026fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8026fe:	e8 7c ea ff ff       	call   80117f <fd2num>
  802703:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802706:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802711:	eb 2e                	jmp    802741 <pipe+0x141>
	sys_page_unmap(0, va);
  802713:	83 ec 08             	sub    $0x8,%esp
  802716:	56                   	push   %esi
  802717:	6a 00                	push   $0x0
  802719:	e8 f1 e7 ff ff       	call   800f0f <sys_page_unmap>
  80271e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802721:	83 ec 08             	sub    $0x8,%esp
  802724:	ff 75 f0             	pushl  -0x10(%ebp)
  802727:	6a 00                	push   $0x0
  802729:	e8 e1 e7 ff ff       	call   800f0f <sys_page_unmap>
  80272e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802731:	83 ec 08             	sub    $0x8,%esp
  802734:	ff 75 f4             	pushl  -0xc(%ebp)
  802737:	6a 00                	push   $0x0
  802739:	e8 d1 e7 ff ff       	call   800f0f <sys_page_unmap>
  80273e:	83 c4 10             	add    $0x10,%esp
}
  802741:	89 d8                	mov    %ebx,%eax
  802743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802746:	5b                   	pop    %ebx
  802747:	5e                   	pop    %esi
  802748:	5d                   	pop    %ebp
  802749:	c3                   	ret    

0080274a <pipeisclosed>:
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802750:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802753:	50                   	push   %eax
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	e8 9c ea ff ff       	call   8011f8 <fd_lookup>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	85 c0                	test   %eax,%eax
  802761:	78 18                	js     80277b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802763:	83 ec 0c             	sub    $0xc,%esp
  802766:	ff 75 f4             	pushl  -0xc(%ebp)
  802769:	e8 21 ea ff ff       	call   80118f <fd2data>
	return _pipeisclosed(fd, p);
  80276e:	89 c2                	mov    %eax,%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	e8 2f fd ff ff       	call   8024a7 <_pipeisclosed>
  802778:	83 c4 10             	add    $0x10,%esp
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	c3                   	ret    

00802783 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802789:	68 8e 33 80 00       	push   $0x80338e
  80278e:	ff 75 0c             	pushl  0xc(%ebp)
  802791:	e8 02 e3 ff ff       	call   800a98 <strcpy>
	return 0;
}
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <devcons_write>:
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	57                   	push   %edi
  8027a1:	56                   	push   %esi
  8027a2:	53                   	push   %ebx
  8027a3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027a9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027ae:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027b4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027b7:	73 31                	jae    8027ea <devcons_write+0x4d>
		m = n - tot;
  8027b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027bc:	29 f3                	sub    %esi,%ebx
  8027be:	83 fb 7f             	cmp    $0x7f,%ebx
  8027c1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027c6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	53                   	push   %ebx
  8027cd:	89 f0                	mov    %esi,%eax
  8027cf:	03 45 0c             	add    0xc(%ebp),%eax
  8027d2:	50                   	push   %eax
  8027d3:	57                   	push   %edi
  8027d4:	e8 4d e4 ff ff       	call   800c26 <memmove>
		sys_cputs(buf, m);
  8027d9:	83 c4 08             	add    $0x8,%esp
  8027dc:	53                   	push   %ebx
  8027dd:	57                   	push   %edi
  8027de:	e8 eb e5 ff ff       	call   800dce <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027e3:	01 de                	add    %ebx,%esi
  8027e5:	83 c4 10             	add    $0x10,%esp
  8027e8:	eb ca                	jmp    8027b4 <devcons_write+0x17>
}
  8027ea:	89 f0                	mov    %esi,%eax
  8027ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5f                   	pop    %edi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    

008027f4 <devcons_read>:
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 08             	sub    $0x8,%esp
  8027fa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8027ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802803:	74 21                	je     802826 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802805:	e8 e2 e5 ff ff       	call   800dec <sys_cgetc>
  80280a:	85 c0                	test   %eax,%eax
  80280c:	75 07                	jne    802815 <devcons_read+0x21>
		sys_yield();
  80280e:	e8 58 e6 ff ff       	call   800e6b <sys_yield>
  802813:	eb f0                	jmp    802805 <devcons_read+0x11>
	if (c < 0)
  802815:	78 0f                	js     802826 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802817:	83 f8 04             	cmp    $0x4,%eax
  80281a:	74 0c                	je     802828 <devcons_read+0x34>
	*(char*)vbuf = c;
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	88 02                	mov    %al,(%edx)
	return 1;
  802821:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    
		return 0;
  802828:	b8 00 00 00 00       	mov    $0x0,%eax
  80282d:	eb f7                	jmp    802826 <devcons_read+0x32>

0080282f <cputchar>:
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802835:	8b 45 08             	mov    0x8(%ebp),%eax
  802838:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80283b:	6a 01                	push   $0x1
  80283d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802840:	50                   	push   %eax
  802841:	e8 88 e5 ff ff       	call   800dce <sys_cputs>
}
  802846:	83 c4 10             	add    $0x10,%esp
  802849:	c9                   	leave  
  80284a:	c3                   	ret    

0080284b <getchar>:
{
  80284b:	55                   	push   %ebp
  80284c:	89 e5                	mov    %esp,%ebp
  80284e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802851:	6a 01                	push   $0x1
  802853:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802856:	50                   	push   %eax
  802857:	6a 00                	push   $0x0
  802859:	e8 0a ec ff ff       	call   801468 <read>
	if (r < 0)
  80285e:	83 c4 10             	add    $0x10,%esp
  802861:	85 c0                	test   %eax,%eax
  802863:	78 06                	js     80286b <getchar+0x20>
	if (r < 1)
  802865:	74 06                	je     80286d <getchar+0x22>
	return c;
  802867:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80286b:	c9                   	leave  
  80286c:	c3                   	ret    
		return -E_EOF;
  80286d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802872:	eb f7                	jmp    80286b <getchar+0x20>

00802874 <iscons>:
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80287a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287d:	50                   	push   %eax
  80287e:	ff 75 08             	pushl  0x8(%ebp)
  802881:	e8 72 e9 ff ff       	call   8011f8 <fd_lookup>
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	85 c0                	test   %eax,%eax
  80288b:	78 11                	js     80289e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802896:	39 10                	cmp    %edx,(%eax)
  802898:	0f 94 c0             	sete   %al
  80289b:	0f b6 c0             	movzbl %al,%eax
}
  80289e:	c9                   	leave  
  80289f:	c3                   	ret    

008028a0 <opencons>:
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a9:	50                   	push   %eax
  8028aa:	e8 f7 e8 ff ff       	call   8011a6 <fd_alloc>
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	78 3a                	js     8028f0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	68 07 04 00 00       	push   $0x407
  8028be:	ff 75 f4             	pushl  -0xc(%ebp)
  8028c1:	6a 00                	push   $0x0
  8028c3:	e8 c2 e5 ff ff       	call   800e8a <sys_page_alloc>
  8028c8:	83 c4 10             	add    $0x10,%esp
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	78 21                	js     8028f0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028d8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028e4:	83 ec 0c             	sub    $0xc,%esp
  8028e7:	50                   	push   %eax
  8028e8:	e8 92 e8 ff ff       	call   80117f <fd2num>
  8028ed:	83 c4 10             	add    $0x10,%esp
}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

008028f2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
  8028f5:	56                   	push   %esi
  8028f6:	53                   	push   %ebx
  8028f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8028fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802900:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802902:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802907:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80290a:	83 ec 0c             	sub    $0xc,%esp
  80290d:	50                   	push   %eax
  80290e:	e8 27 e7 ff ff       	call   80103a <sys_ipc_recv>
	if(ret < 0){
  802913:	83 c4 10             	add    $0x10,%esp
  802916:	85 c0                	test   %eax,%eax
  802918:	78 2b                	js     802945 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80291a:	85 f6                	test   %esi,%esi
  80291c:	74 0a                	je     802928 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80291e:	a1 08 50 80 00       	mov    0x805008,%eax
  802923:	8b 40 78             	mov    0x78(%eax),%eax
  802926:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802928:	85 db                	test   %ebx,%ebx
  80292a:	74 0a                	je     802936 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80292c:	a1 08 50 80 00       	mov    0x805008,%eax
  802931:	8b 40 7c             	mov    0x7c(%eax),%eax
  802934:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802936:	a1 08 50 80 00       	mov    0x805008,%eax
  80293b:	8b 40 74             	mov    0x74(%eax),%eax
}
  80293e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
		if(from_env_store)
  802945:	85 f6                	test   %esi,%esi
  802947:	74 06                	je     80294f <ipc_recv+0x5d>
			*from_env_store = 0;
  802949:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80294f:	85 db                	test   %ebx,%ebx
  802951:	74 eb                	je     80293e <ipc_recv+0x4c>
			*perm_store = 0;
  802953:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802959:	eb e3                	jmp    80293e <ipc_recv+0x4c>

0080295b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	57                   	push   %edi
  80295f:	56                   	push   %esi
  802960:	53                   	push   %ebx
  802961:	83 ec 0c             	sub    $0xc,%esp
  802964:	8b 7d 08             	mov    0x8(%ebp),%edi
  802967:	8b 75 0c             	mov    0xc(%ebp),%esi
  80296a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80296d:	85 db                	test   %ebx,%ebx
  80296f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802974:	0f 44 d8             	cmove  %eax,%ebx
  802977:	eb 05                	jmp    80297e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802979:	e8 ed e4 ff ff       	call   800e6b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80297e:	ff 75 14             	pushl  0x14(%ebp)
  802981:	53                   	push   %ebx
  802982:	56                   	push   %esi
  802983:	57                   	push   %edi
  802984:	e8 8e e6 ff ff       	call   801017 <sys_ipc_try_send>
  802989:	83 c4 10             	add    $0x10,%esp
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 1b                	je     8029ab <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802990:	79 e7                	jns    802979 <ipc_send+0x1e>
  802992:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802995:	74 e2                	je     802979 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 9a 33 80 00       	push   $0x80339a
  80299f:	6a 46                	push   $0x46
  8029a1:	68 af 33 80 00       	push   $0x8033af
  8029a6:	e8 98 d8 ff ff       	call   800243 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8029ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ae:	5b                   	pop    %ebx
  8029af:	5e                   	pop    %esi
  8029b0:	5f                   	pop    %edi
  8029b1:	5d                   	pop    %ebp
  8029b2:	c3                   	ret    

008029b3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029b3:	55                   	push   %ebp
  8029b4:	89 e5                	mov    %esp,%ebp
  8029b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029be:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8029c4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029ca:	8b 52 50             	mov    0x50(%edx),%edx
  8029cd:	39 ca                	cmp    %ecx,%edx
  8029cf:	74 11                	je     8029e2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8029d1:	83 c0 01             	add    $0x1,%eax
  8029d4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029d9:	75 e3                	jne    8029be <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029db:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e0:	eb 0e                	jmp    8029f0 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8029e2:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8029e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029ed:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029f0:	5d                   	pop    %ebp
  8029f1:	c3                   	ret    

008029f2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029f8:	89 d0                	mov    %edx,%eax
  8029fa:	c1 e8 16             	shr    $0x16,%eax
  8029fd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a09:	f6 c1 01             	test   $0x1,%cl
  802a0c:	74 1d                	je     802a2b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a0e:	c1 ea 0c             	shr    $0xc,%edx
  802a11:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a18:	f6 c2 01             	test   $0x1,%dl
  802a1b:	74 0e                	je     802a2b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a1d:	c1 ea 0c             	shr    $0xc,%edx
  802a20:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a27:	ef 
  802a28:	0f b7 c0             	movzwl %ax,%eax
}
  802a2b:	5d                   	pop    %ebp
  802a2c:	c3                   	ret    
  802a2d:	66 90                	xchg   %ax,%ax
  802a2f:	90                   	nop

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
