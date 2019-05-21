
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
  80003e:	c7 05 00 30 80 00 c0 	movl   $0x8025c0,0x803000
  800045:	25 80 00 

	cprintf("icode startup\n");
  800048:	68 c6 25 80 00       	push   $0x8025c6
  80004d:	e8 7f 02 00 00       	call   8002d1 <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 d5 25 80 00 	movl   $0x8025d5,(%esp)
  800059:	e8 73 02 00 00       	call   8002d1 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 e8 25 80 00       	push   $0x8025e8
  800068:	e8 02 17 00 00       	call   80176f <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 3b                	js     8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 11 26 80 00       	push   $0x802611
  80007e:	e8 4e 02 00 00       	call   8002d1 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	83 ec 04             	sub    $0x4,%esp
  80008f:	68 00 02 00 00       	push   $0x200
  800094:	53                   	push   %ebx
  800095:	56                   	push   %esi
  800096:	e8 9d 12 00 00       	call   801338 <read>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	7e 21                	jle    8000c3 <umain+0x90>
		sys_cputs(buf, n);
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	53                   	push   %ebx
  8000a7:	e8 ba 0c 00 00       	call   800d66 <sys_cputs>
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	eb db                	jmp    80008c <umain+0x59>
		panic("icode: open /motd: %e", fd);
  8000b1:	50                   	push   %eax
  8000b2:	68 ee 25 80 00       	push   $0x8025ee
  8000b7:	6a 0f                	push   $0xf
  8000b9:	68 04 26 80 00       	push   $0x802604
  8000be:	e8 18 01 00 00       	call   8001db <_panic>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 24 26 80 00       	push   $0x802624
  8000cb:	e8 01 02 00 00       	call   8002d1 <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 22 11 00 00       	call   8011fa <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 38 26 80 00 	movl   $0x802638,(%esp)
  8000df:	e8 ed 01 00 00       	call   8002d1 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 4c 26 80 00       	push   $0x80264c
  8000f0:	68 55 26 80 00       	push   $0x802655
  8000f5:	68 5f 26 80 00       	push   $0x80265f
  8000fa:	68 5e 26 80 00       	push   $0x80265e
  8000ff:	e8 f2 1b 00 00       	call   801cf6 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 7b 26 80 00       	push   $0x80267b
  800113:	e8 b9 01 00 00       	call   8002d1 <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 64 26 80 00       	push   $0x802664
  800128:	6a 1a                	push   $0x1a
  80012a:	68 04 26 80 00       	push   $0x802604
  80012f:	e8 a7 00 00 00       	call   8001db <_panic>

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
  80013d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800144:	00 00 00 
	envid_t find = sys_getenvid();
  800147:	e8 98 0c 00 00       	call   800de4 <sys_getenvid>
  80014c:	8b 1d 04 40 80 00    	mov    0x804004,%ebx
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
  800195:	89 1d 04 40 80 00    	mov    %ebx,0x804004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019f:	7e 0a                	jle    8001ab <libmain+0x77>
		binaryname = argv[0];
  8001a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a4:	8b 00                	mov    (%eax),%eax
  8001a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ab:	83 ec 08             	sub    $0x8,%esp
  8001ae:	ff 75 0c             	pushl  0xc(%ebp)
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 7a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001b9:	e8 0b 00 00 00       	call   8001c9 <exit>
}
  8001be:	83 c4 10             	add    $0x10,%esp
  8001c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c4:	5b                   	pop    %ebx
  8001c5:	5e                   	pop    %esi
  8001c6:	5f                   	pop    %edi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  8001cf:	6a 00                	push   $0x0
  8001d1:	e8 cd 0b 00 00       	call   800da3 <sys_env_destroy>
}
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	c9                   	leave  
  8001da:	c3                   	ret    

008001db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	56                   	push   %esi
  8001df:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001e0:	a1 04 40 80 00       	mov    0x804004,%eax
  8001e5:	8b 40 48             	mov    0x48(%eax),%eax
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	68 c4 26 80 00       	push   $0x8026c4
  8001f0:	50                   	push   %eax
  8001f1:	68 95 26 80 00       	push   $0x802695
  8001f6:	e8 d6 00 00 00       	call   8002d1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fe:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800204:	e8 db 0b 00 00       	call   800de4 <sys_getenvid>
  800209:	83 c4 04             	add    $0x4,%esp
  80020c:	ff 75 0c             	pushl  0xc(%ebp)
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	56                   	push   %esi
  800213:	50                   	push   %eax
  800214:	68 a0 26 80 00       	push   $0x8026a0
  800219:	e8 b3 00 00 00       	call   8002d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	53                   	push   %ebx
  800222:	ff 75 10             	pushl  0x10(%ebp)
  800225:	e8 56 00 00 00       	call   800280 <vcprintf>
	cprintf("\n");
  80022a:	c7 04 24 26 2c 80 00 	movl   $0x802c26,(%esp)
  800231:	e8 9b 00 00 00       	call   8002d1 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800239:	cc                   	int3   
  80023a:	eb fd                	jmp    800239 <_panic+0x5e>

0080023c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800246:	8b 13                	mov    (%ebx),%edx
  800248:	8d 42 01             	lea    0x1(%edx),%eax
  80024b:	89 03                	mov    %eax,(%ebx)
  80024d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800250:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	74 09                	je     800264 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800262:	c9                   	leave  
  800263:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	68 ff 00 00 00       	push   $0xff
  80026c:	8d 43 08             	lea    0x8(%ebx),%eax
  80026f:	50                   	push   %eax
  800270:	e8 f1 0a 00 00       	call   800d66 <sys_cputs>
		b->idx = 0;
  800275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	eb db                	jmp    80025b <putch+0x1f>

00800280 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800289:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800290:	00 00 00 
	b.cnt = 0;
  800293:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	68 3c 02 80 00       	push   $0x80023c
  8002af:	e8 4a 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b4:	83 c4 08             	add    $0x8,%esp
  8002b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 9d 0a 00 00       	call   800d66 <sys_cputs>

	return b.cnt;
}
  8002c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002da:	50                   	push   %eax
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	e8 9d ff ff ff       	call   800280 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 1c             	sub    $0x1c,%esp
  8002ee:	89 c6                	mov    %eax,%esi
  8002f0:	89 d7                	mov    %edx,%edi
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800304:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800308:	74 2c                	je     800336 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80030a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800314:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800317:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031a:	39 c2                	cmp    %eax,%edx
  80031c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80031f:	73 43                	jae    800364 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800321:	83 eb 01             	sub    $0x1,%ebx
  800324:	85 db                	test   %ebx,%ebx
  800326:	7e 6c                	jle    800394 <printnum+0xaf>
				putch(padc, putdat);
  800328:	83 ec 08             	sub    $0x8,%esp
  80032b:	57                   	push   %edi
  80032c:	ff 75 18             	pushl  0x18(%ebp)
  80032f:	ff d6                	call   *%esi
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	eb eb                	jmp    800321 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	6a 20                	push   $0x20
  80033b:	6a 00                	push   $0x0
  80033d:	50                   	push   %eax
  80033e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800341:	ff 75 e0             	pushl  -0x20(%ebp)
  800344:	89 fa                	mov    %edi,%edx
  800346:	89 f0                	mov    %esi,%eax
  800348:	e8 98 ff ff ff       	call   8002e5 <printnum>
		while (--width > 0)
  80034d:	83 c4 20             	add    $0x20,%esp
  800350:	83 eb 01             	sub    $0x1,%ebx
  800353:	85 db                	test   %ebx,%ebx
  800355:	7e 65                	jle    8003bc <printnum+0xd7>
			putch(padc, putdat);
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	57                   	push   %edi
  80035b:	6a 20                	push   $0x20
  80035d:	ff d6                	call   *%esi
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	eb ec                	jmp    800350 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	ff 75 18             	pushl  0x18(%ebp)
  80036a:	83 eb 01             	sub    $0x1,%ebx
  80036d:	53                   	push   %ebx
  80036e:	50                   	push   %eax
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	ff 75 dc             	pushl  -0x24(%ebp)
  800375:	ff 75 d8             	pushl  -0x28(%ebp)
  800378:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037b:	ff 75 e0             	pushl  -0x20(%ebp)
  80037e:	e8 ed 1f 00 00       	call   802370 <__udivdi3>
  800383:	83 c4 18             	add    $0x18,%esp
  800386:	52                   	push   %edx
  800387:	50                   	push   %eax
  800388:	89 fa                	mov    %edi,%edx
  80038a:	89 f0                	mov    %esi,%eax
  80038c:	e8 54 ff ff ff       	call   8002e5 <printnum>
  800391:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	57                   	push   %edi
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	ff 75 dc             	pushl  -0x24(%ebp)
  80039e:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a7:	e8 d4 20 00 00       	call   802480 <__umoddi3>
  8003ac:	83 c4 14             	add    $0x14,%esp
  8003af:	0f be 80 cb 26 80 00 	movsbl 0x8026cb(%eax),%eax
  8003b6:	50                   	push   %eax
  8003b7:	ff d6                	call   *%esi
  8003b9:	83 c4 10             	add    $0x10,%esp
	}
}
  8003bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bf:	5b                   	pop    %ebx
  8003c0:	5e                   	pop    %esi
  8003c1:	5f                   	pop    %edi
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ca:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ce:	8b 10                	mov    (%eax),%edx
  8003d0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d3:	73 0a                	jae    8003df <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d8:	89 08                	mov    %ecx,(%eax)
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	88 02                	mov    %al,(%edx)
}
  8003df:	5d                   	pop    %ebp
  8003e0:	c3                   	ret    

008003e1 <printfmt>:
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ea:	50                   	push   %eax
  8003eb:	ff 75 10             	pushl  0x10(%ebp)
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	ff 75 08             	pushl  0x8(%ebp)
  8003f4:	e8 05 00 00 00       	call   8003fe <vprintfmt>
}
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 3c             	sub    $0x3c,%esp
  800407:	8b 75 08             	mov    0x8(%ebp),%esi
  80040a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80040d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800410:	e9 32 04 00 00       	jmp    800847 <vprintfmt+0x449>
		padc = ' ';
  800415:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800419:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800420:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800427:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80042e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800435:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80043c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8d 47 01             	lea    0x1(%edi),%eax
  800444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800447:	0f b6 17             	movzbl (%edi),%edx
  80044a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044d:	3c 55                	cmp    $0x55,%al
  80044f:	0f 87 12 05 00 00    	ja     800967 <vprintfmt+0x569>
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
  80045f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800462:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800466:	eb d9                	jmp    800441 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80046f:	eb d0                	jmp    800441 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800471:	0f b6 d2             	movzbl %dl,%edx
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	89 75 08             	mov    %esi,0x8(%ebp)
  80047f:	eb 03                	jmp    800484 <vprintfmt+0x86>
  800481:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800484:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800487:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80048b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800491:	83 fe 09             	cmp    $0x9,%esi
  800494:	76 eb                	jbe    800481 <vprintfmt+0x83>
  800496:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800499:	8b 75 08             	mov    0x8(%ebp),%esi
  80049c:	eb 14                	jmp    8004b2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8d 40 04             	lea    0x4(%eax),%eax
  8004ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b6:	79 89                	jns    800441 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004c5:	e9 77 ff ff ff       	jmp    800441 <vprintfmt+0x43>
  8004ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cd:	85 c0                	test   %eax,%eax
  8004cf:	0f 48 c1             	cmovs  %ecx,%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d8:	e9 64 ff ff ff       	jmp    800441 <vprintfmt+0x43>
  8004dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004e0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004e7:	e9 55 ff ff ff       	jmp    800441 <vprintfmt+0x43>
			lflag++;
  8004ec:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f3:	e9 49 ff ff ff       	jmp    800441 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8d 78 04             	lea    0x4(%eax),%edi
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	53                   	push   %ebx
  800502:	ff 30                	pushl  (%eax)
  800504:	ff d6                	call   *%esi
			break;
  800506:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800509:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050c:	e9 33 03 00 00       	jmp    800844 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 78 04             	lea    0x4(%eax),%edi
  800517:	8b 00                	mov    (%eax),%eax
  800519:	99                   	cltd   
  80051a:	31 d0                	xor    %edx,%eax
  80051c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051e:	83 f8 0f             	cmp    $0xf,%eax
  800521:	7f 23                	jg     800546 <vprintfmt+0x148>
  800523:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  80052a:	85 d2                	test   %edx,%edx
  80052c:	74 18                	je     800546 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80052e:	52                   	push   %edx
  80052f:	68 3a 2b 80 00       	push   $0x802b3a
  800534:	53                   	push   %ebx
  800535:	56                   	push   %esi
  800536:	e8 a6 fe ff ff       	call   8003e1 <printfmt>
  80053b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800541:	e9 fe 02 00 00       	jmp    800844 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800546:	50                   	push   %eax
  800547:	68 e3 26 80 00       	push   $0x8026e3
  80054c:	53                   	push   %ebx
  80054d:	56                   	push   %esi
  80054e:	e8 8e fe ff ff       	call   8003e1 <printfmt>
  800553:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800556:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800559:	e9 e6 02 00 00       	jmp    800844 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	83 c0 04             	add    $0x4,%eax
  800564:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	b8 dc 26 80 00       	mov    $0x8026dc,%eax
  800573:	0f 45 c1             	cmovne %ecx,%eax
  800576:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800579:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057d:	7e 06                	jle    800585 <vprintfmt+0x187>
  80057f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800583:	75 0d                	jne    800592 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800588:	89 c7                	mov    %eax,%edi
  80058a:	03 45 e0             	add    -0x20(%ebp),%eax
  80058d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800590:	eb 53                	jmp    8005e5 <vprintfmt+0x1e7>
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	ff 75 d8             	pushl  -0x28(%ebp)
  800598:	50                   	push   %eax
  800599:	e8 71 04 00 00       	call   800a0f <strnlen>
  80059e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a1:	29 c1                	sub    %eax,%ecx
  8005a3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005ab:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005af:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b2:	eb 0f                	jmp    8005c3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	53                   	push   %ebx
  8005b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bd:	83 ef 01             	sub    $0x1,%edi
  8005c0:	83 c4 10             	add    $0x10,%esp
  8005c3:	85 ff                	test   %edi,%edi
  8005c5:	7f ed                	jg     8005b4 <vprintfmt+0x1b6>
  8005c7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d1:	0f 49 c1             	cmovns %ecx,%eax
  8005d4:	29 c1                	sub    %eax,%ecx
  8005d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005d9:	eb aa                	jmp    800585 <vprintfmt+0x187>
					putch(ch, putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	52                   	push   %edx
  8005e0:	ff d6                	call   *%esi
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ea:	83 c7 01             	add    $0x1,%edi
  8005ed:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005f1:	0f be d0             	movsbl %al,%edx
  8005f4:	85 d2                	test   %edx,%edx
  8005f6:	74 4b                	je     800643 <vprintfmt+0x245>
  8005f8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fc:	78 06                	js     800604 <vprintfmt+0x206>
  8005fe:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800602:	78 1e                	js     800622 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800604:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800608:	74 d1                	je     8005db <vprintfmt+0x1dd>
  80060a:	0f be c0             	movsbl %al,%eax
  80060d:	83 e8 20             	sub    $0x20,%eax
  800610:	83 f8 5e             	cmp    $0x5e,%eax
  800613:	76 c6                	jbe    8005db <vprintfmt+0x1dd>
					putch('?', putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	53                   	push   %ebx
  800619:	6a 3f                	push   $0x3f
  80061b:	ff d6                	call   *%esi
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	eb c3                	jmp    8005e5 <vprintfmt+0x1e7>
  800622:	89 cf                	mov    %ecx,%edi
  800624:	eb 0e                	jmp    800634 <vprintfmt+0x236>
				putch(' ', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 20                	push   $0x20
  80062c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062e:	83 ef 01             	sub    $0x1,%edi
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	85 ff                	test   %edi,%edi
  800636:	7f ee                	jg     800626 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800638:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
  80063e:	e9 01 02 00 00       	jmp    800844 <vprintfmt+0x446>
  800643:	89 cf                	mov    %ecx,%edi
  800645:	eb ed                	jmp    800634 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80064a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800651:	e9 eb fd ff ff       	jmp    800441 <vprintfmt+0x43>
	if (lflag >= 2)
  800656:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80065a:	7f 21                	jg     80067d <vprintfmt+0x27f>
	else if (lflag)
  80065c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800660:	74 68                	je     8006ca <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066a:	89 c1                	mov    %eax,%ecx
  80066c:	c1 f9 1f             	sar    $0x1f,%ecx
  80066f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
  80067b:	eb 17                	jmp    800694 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 50 04             	mov    0x4(%eax),%edx
  800683:	8b 00                	mov    (%eax),%eax
  800685:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800688:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8d 40 08             	lea    0x8(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800694:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a4:	78 3f                	js     8006e5 <vprintfmt+0x2e7>
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006ab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006af:	0f 84 71 01 00 00    	je     800826 <vprintfmt+0x428>
				putch('+', putdat);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	53                   	push   %ebx
  8006b9:	6a 2b                	push   $0x2b
  8006bb:	ff d6                	call   *%esi
  8006bd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c5:	e9 5c 01 00 00       	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d2:	89 c1                	mov    %eax,%ecx
  8006d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e3:	eb af                	jmp    800694 <vprintfmt+0x296>
				putch('-', putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	6a 2d                	push   $0x2d
  8006eb:	ff d6                	call   *%esi
				num = -(long long) num;
  8006ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006f3:	f7 d8                	neg    %eax
  8006f5:	83 d2 00             	adc    $0x0,%edx
  8006f8:	f7 da                	neg    %edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800703:	b8 0a 00 00 00       	mov    $0xa,%eax
  800708:	e9 19 01 00 00       	jmp    800826 <vprintfmt+0x428>
	if (lflag >= 2)
  80070d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800711:	7f 29                	jg     80073c <vprintfmt+0x33e>
	else if (lflag)
  800713:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800717:	74 44                	je     80075d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	ba 00 00 00 00       	mov    $0x0,%edx
  800723:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800726:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800732:	b8 0a 00 00 00       	mov    $0xa,%eax
  800737:	e9 ea 00 00 00       	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 50 04             	mov    0x4(%eax),%edx
  800742:	8b 00                	mov    (%eax),%eax
  800744:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800747:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8d 40 08             	lea    0x8(%eax),%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800753:	b8 0a 00 00 00       	mov    $0xa,%eax
  800758:	e9 c9 00 00 00       	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 04             	lea    0x4(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800776:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077b:	e9 a6 00 00 00       	jmp    800826 <vprintfmt+0x428>
			putch('0', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	6a 30                	push   $0x30
  800786:	ff d6                	call   *%esi
	if (lflag >= 2)
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078f:	7f 26                	jg     8007b7 <vprintfmt+0x3b9>
	else if (lflag)
  800791:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800795:	74 3e                	je     8007d5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 40 04             	lea    0x4(%eax),%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b5:	eb 6f                	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8b 50 04             	mov    0x4(%eax),%edx
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 08             	lea    0x8(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d3:	eb 51                	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f3:	eb 31                	jmp    800826 <vprintfmt+0x428>
			putch('0', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	6a 30                	push   $0x30
  8007fb:	ff d6                	call   *%esi
			putch('x', putdat);
  8007fd:	83 c4 08             	add    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 78                	push   $0x78
  800803:	ff d6                	call   *%esi
			num = (unsigned long long)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800812:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800815:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800818:	8b 45 14             	mov    0x14(%ebp),%eax
  80081b:	8d 40 04             	lea    0x4(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800826:	83 ec 0c             	sub    $0xc,%esp
  800829:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80082d:	52                   	push   %edx
  80082e:	ff 75 e0             	pushl  -0x20(%ebp)
  800831:	50                   	push   %eax
  800832:	ff 75 dc             	pushl  -0x24(%ebp)
  800835:	ff 75 d8             	pushl  -0x28(%ebp)
  800838:	89 da                	mov    %ebx,%edx
  80083a:	89 f0                	mov    %esi,%eax
  80083c:	e8 a4 fa ff ff       	call   8002e5 <printnum>
			break;
  800841:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800844:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800847:	83 c7 01             	add    $0x1,%edi
  80084a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084e:	83 f8 25             	cmp    $0x25,%eax
  800851:	0f 84 be fb ff ff    	je     800415 <vprintfmt+0x17>
			if (ch == '\0')
  800857:	85 c0                	test   %eax,%eax
  800859:	0f 84 28 01 00 00    	je     800987 <vprintfmt+0x589>
			putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	50                   	push   %eax
  800864:	ff d6                	call   *%esi
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	eb dc                	jmp    800847 <vprintfmt+0x449>
	if (lflag >= 2)
  80086b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80086f:	7f 26                	jg     800897 <vprintfmt+0x499>
	else if (lflag)
  800871:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800875:	74 41                	je     8008b8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	ba 00 00 00 00       	mov    $0x0,%edx
  800881:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800884:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 40 04             	lea    0x4(%eax),%eax
  80088d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800890:	b8 10 00 00 00       	mov    $0x10,%eax
  800895:	eb 8f                	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8b 50 04             	mov    0x4(%eax),%edx
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 40 08             	lea    0x8(%eax),%eax
  8008ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ae:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b3:	e9 6e ff ff ff       	jmp    800826 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d6:	e9 4b ff ff ff       	jmp    800826 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	85 c0                	test   %eax,%eax
  8008eb:	74 14                	je     800901 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008ed:	8b 13                	mov    (%ebx),%edx
  8008ef:	83 fa 7f             	cmp    $0x7f,%edx
  8008f2:	7f 37                	jg     80092b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008f4:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fc:	e9 43 ff ff ff       	jmp    800844 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800901:	b8 0a 00 00 00       	mov    $0xa,%eax
  800906:	bf 01 28 80 00       	mov    $0x802801,%edi
							putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	53                   	push   %ebx
  80090f:	50                   	push   %eax
  800910:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800912:	83 c7 01             	add    $0x1,%edi
  800915:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	85 c0                	test   %eax,%eax
  80091e:	75 eb                	jne    80090b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800920:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	e9 19 ff ff ff       	jmp    800844 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80092b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80092d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800932:	bf 39 28 80 00       	mov    $0x802839,%edi
							putch(ch, putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	53                   	push   %ebx
  80093b:	50                   	push   %eax
  80093c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80093e:	83 c7 01             	add    $0x1,%edi
  800941:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	85 c0                	test   %eax,%eax
  80094a:	75 eb                	jne    800937 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80094c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80094f:	89 45 14             	mov    %eax,0x14(%ebp)
  800952:	e9 ed fe ff ff       	jmp    800844 <vprintfmt+0x446>
			putch(ch, putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	53                   	push   %ebx
  80095b:	6a 25                	push   $0x25
  80095d:	ff d6                	call   *%esi
			break;
  80095f:	83 c4 10             	add    $0x10,%esp
  800962:	e9 dd fe ff ff       	jmp    800844 <vprintfmt+0x446>
			putch('%', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 25                	push   $0x25
  80096d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	89 f8                	mov    %edi,%eax
  800974:	eb 03                	jmp    800979 <vprintfmt+0x57b>
  800976:	83 e8 01             	sub    $0x1,%eax
  800979:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80097d:	75 f7                	jne    800976 <vprintfmt+0x578>
  80097f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800982:	e9 bd fe ff ff       	jmp    800844 <vprintfmt+0x446>
}
  800987:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 18             	sub    $0x18,%esp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ac:	85 c0                	test   %eax,%eax
  8009ae:	74 26                	je     8009d6 <vsnprintf+0x47>
  8009b0:	85 d2                	test   %edx,%edx
  8009b2:	7e 22                	jle    8009d6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b4:	ff 75 14             	pushl  0x14(%ebp)
  8009b7:	ff 75 10             	pushl  0x10(%ebp)
  8009ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	68 c4 03 80 00       	push   $0x8003c4
  8009c3:	e8 36 fa ff ff       	call   8003fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
}
  8009d4:	c9                   	leave  
  8009d5:	c3                   	ret    
		return -E_INVAL;
  8009d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009db:	eb f7                	jmp    8009d4 <vsnprintf+0x45>

008009dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 10             	pushl  0x10(%ebp)
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 9a ff ff ff       	call   80098f <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800a02:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a06:	74 05                	je     800a0d <strlen+0x16>
		n++;
  800a08:	83 c0 01             	add    $0x1,%eax
  800a0b:	eb f5                	jmp    800a02 <strlen+0xb>
	return n;
}
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a15:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	39 c2                	cmp    %eax,%edx
  800a1f:	74 0d                	je     800a2e <strnlen+0x1f>
  800a21:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a25:	74 05                	je     800a2c <strnlen+0x1d>
		n++;
  800a27:	83 c2 01             	add    $0x1,%edx
  800a2a:	eb f1                	jmp    800a1d <strnlen+0xe>
  800a2c:	89 d0                	mov    %edx,%eax
	return n;
}
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	53                   	push   %ebx
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a43:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	84 c9                	test   %cl,%cl
  800a4b:	75 f2                	jne    800a3f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	53                   	push   %ebx
  800a54:	83 ec 10             	sub    $0x10,%esp
  800a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a5a:	53                   	push   %ebx
  800a5b:	e8 97 ff ff ff       	call   8009f7 <strlen>
  800a60:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	01 d8                	add    %ebx,%eax
  800a68:	50                   	push   %eax
  800a69:	e8 c2 ff ff ff       	call   800a30 <strcpy>
	return dst;
}
  800a6e:	89 d8                	mov    %ebx,%eax
  800a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a73:	c9                   	leave  
  800a74:	c3                   	ret    

00800a75 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	56                   	push   %esi
  800a79:	53                   	push   %ebx
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a80:	89 c6                	mov    %eax,%esi
  800a82:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a85:	89 c2                	mov    %eax,%edx
  800a87:	39 f2                	cmp    %esi,%edx
  800a89:	74 11                	je     800a9c <strncpy+0x27>
		*dst++ = *src;
  800a8b:	83 c2 01             	add    $0x1,%edx
  800a8e:	0f b6 19             	movzbl (%ecx),%ebx
  800a91:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a94:	80 fb 01             	cmp    $0x1,%bl
  800a97:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a9a:	eb eb                	jmp    800a87 <strncpy+0x12>
	}
	return ret;
}
  800a9c:	5b                   	pop    %ebx
  800a9d:	5e                   	pop    %esi
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	56                   	push   %esi
  800aa4:	53                   	push   %ebx
  800aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aab:	8b 55 10             	mov    0x10(%ebp),%edx
  800aae:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ab0:	85 d2                	test   %edx,%edx
  800ab2:	74 21                	je     800ad5 <strlcpy+0x35>
  800ab4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ab8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aba:	39 c2                	cmp    %eax,%edx
  800abc:	74 14                	je     800ad2 <strlcpy+0x32>
  800abe:	0f b6 19             	movzbl (%ecx),%ebx
  800ac1:	84 db                	test   %bl,%bl
  800ac3:	74 0b                	je     800ad0 <strlcpy+0x30>
			*dst++ = *src++;
  800ac5:	83 c1 01             	add    $0x1,%ecx
  800ac8:	83 c2 01             	add    $0x1,%edx
  800acb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ace:	eb ea                	jmp    800aba <strlcpy+0x1a>
  800ad0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ad2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad5:	29 f0                	sub    %esi,%eax
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae4:	0f b6 01             	movzbl (%ecx),%eax
  800ae7:	84 c0                	test   %al,%al
  800ae9:	74 0c                	je     800af7 <strcmp+0x1c>
  800aeb:	3a 02                	cmp    (%edx),%al
  800aed:	75 08                	jne    800af7 <strcmp+0x1c>
		p++, q++;
  800aef:	83 c1 01             	add    $0x1,%ecx
  800af2:	83 c2 01             	add    $0x1,%edx
  800af5:	eb ed                	jmp    800ae4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af7:	0f b6 c0             	movzbl %al,%eax
  800afa:	0f b6 12             	movzbl (%edx),%edx
  800afd:	29 d0                	sub    %edx,%eax
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	53                   	push   %ebx
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0b:	89 c3                	mov    %eax,%ebx
  800b0d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b10:	eb 06                	jmp    800b18 <strncmp+0x17>
		n--, p++, q++;
  800b12:	83 c0 01             	add    $0x1,%eax
  800b15:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b18:	39 d8                	cmp    %ebx,%eax
  800b1a:	74 16                	je     800b32 <strncmp+0x31>
  800b1c:	0f b6 08             	movzbl (%eax),%ecx
  800b1f:	84 c9                	test   %cl,%cl
  800b21:	74 04                	je     800b27 <strncmp+0x26>
  800b23:	3a 0a                	cmp    (%edx),%cl
  800b25:	74 eb                	je     800b12 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b27:	0f b6 00             	movzbl (%eax),%eax
  800b2a:	0f b6 12             	movzbl (%edx),%edx
  800b2d:	29 d0                	sub    %edx,%eax
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    
		return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	eb f6                	jmp    800b2f <strncmp+0x2e>

00800b39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b43:	0f b6 10             	movzbl (%eax),%edx
  800b46:	84 d2                	test   %dl,%dl
  800b48:	74 09                	je     800b53 <strchr+0x1a>
		if (*s == c)
  800b4a:	38 ca                	cmp    %cl,%dl
  800b4c:	74 0a                	je     800b58 <strchr+0x1f>
	for (; *s; s++)
  800b4e:	83 c0 01             	add    $0x1,%eax
  800b51:	eb f0                	jmp    800b43 <strchr+0xa>
			return (char *) s;
	return 0;
  800b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b64:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b67:	38 ca                	cmp    %cl,%dl
  800b69:	74 09                	je     800b74 <strfind+0x1a>
  800b6b:	84 d2                	test   %dl,%dl
  800b6d:	74 05                	je     800b74 <strfind+0x1a>
	for (; *s; s++)
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	eb f0                	jmp    800b64 <strfind+0xa>
			break;
	return (char *) s;
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
  800b7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b82:	85 c9                	test   %ecx,%ecx
  800b84:	74 31                	je     800bb7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b86:	89 f8                	mov    %edi,%eax
  800b88:	09 c8                	or     %ecx,%eax
  800b8a:	a8 03                	test   $0x3,%al
  800b8c:	75 23                	jne    800bb1 <memset+0x3b>
		c &= 0xFF;
  800b8e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b92:	89 d3                	mov    %edx,%ebx
  800b94:	c1 e3 08             	shl    $0x8,%ebx
  800b97:	89 d0                	mov    %edx,%eax
  800b99:	c1 e0 18             	shl    $0x18,%eax
  800b9c:	89 d6                	mov    %edx,%esi
  800b9e:	c1 e6 10             	shl    $0x10,%esi
  800ba1:	09 f0                	or     %esi,%eax
  800ba3:	09 c2                	or     %eax,%edx
  800ba5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ba7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800baa:	89 d0                	mov    %edx,%eax
  800bac:	fc                   	cld    
  800bad:	f3 ab                	rep stos %eax,%es:(%edi)
  800baf:	eb 06                	jmp    800bb7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	fc                   	cld    
  800bb5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb7:	89 f8                	mov    %edi,%eax
  800bb9:	5b                   	pop    %ebx
  800bba:	5e                   	pop    %esi
  800bbb:	5f                   	pop    %edi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	57                   	push   %edi
  800bc2:	56                   	push   %esi
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bcc:	39 c6                	cmp    %eax,%esi
  800bce:	73 32                	jae    800c02 <memmove+0x44>
  800bd0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd3:	39 c2                	cmp    %eax,%edx
  800bd5:	76 2b                	jbe    800c02 <memmove+0x44>
		s += n;
		d += n;
  800bd7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bda:	89 fe                	mov    %edi,%esi
  800bdc:	09 ce                	or     %ecx,%esi
  800bde:	09 d6                	or     %edx,%esi
  800be0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be6:	75 0e                	jne    800bf6 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be8:	83 ef 04             	sub    $0x4,%edi
  800beb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bee:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bf1:	fd                   	std    
  800bf2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf4:	eb 09                	jmp    800bff <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf6:	83 ef 01             	sub    $0x1,%edi
  800bf9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bfc:	fd                   	std    
  800bfd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bff:	fc                   	cld    
  800c00:	eb 1a                	jmp    800c1c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c02:	89 c2                	mov    %eax,%edx
  800c04:	09 ca                	or     %ecx,%edx
  800c06:	09 f2                	or     %esi,%edx
  800c08:	f6 c2 03             	test   $0x3,%dl
  800c0b:	75 0a                	jne    800c17 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c10:	89 c7                	mov    %eax,%edi
  800c12:	fc                   	cld    
  800c13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c15:	eb 05                	jmp    800c1c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	fc                   	cld    
  800c1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c1c:	5e                   	pop    %esi
  800c1d:	5f                   	pop    %edi
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c26:	ff 75 10             	pushl  0x10(%ebp)
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	ff 75 08             	pushl  0x8(%ebp)
  800c2f:	e8 8a ff ff ff       	call   800bbe <memmove>
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	89 c6                	mov    %eax,%esi
  800c43:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c46:	39 f0                	cmp    %esi,%eax
  800c48:	74 1c                	je     800c66 <memcmp+0x30>
		if (*s1 != *s2)
  800c4a:	0f b6 08             	movzbl (%eax),%ecx
  800c4d:	0f b6 1a             	movzbl (%edx),%ebx
  800c50:	38 d9                	cmp    %bl,%cl
  800c52:	75 08                	jne    800c5c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c54:	83 c0 01             	add    $0x1,%eax
  800c57:	83 c2 01             	add    $0x1,%edx
  800c5a:	eb ea                	jmp    800c46 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c5c:	0f b6 c1             	movzbl %cl,%eax
  800c5f:	0f b6 db             	movzbl %bl,%ebx
  800c62:	29 d8                	sub    %ebx,%eax
  800c64:	eb 05                	jmp    800c6b <memcmp+0x35>
	}

	return 0;
  800c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c7d:	39 d0                	cmp    %edx,%eax
  800c7f:	73 09                	jae    800c8a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c81:	38 08                	cmp    %cl,(%eax)
  800c83:	74 05                	je     800c8a <memfind+0x1b>
	for (; s < ends; s++)
  800c85:	83 c0 01             	add    $0x1,%eax
  800c88:	eb f3                	jmp    800c7d <memfind+0xe>
			break;
	return (void *) s;
}
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    

00800c8c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c98:	eb 03                	jmp    800c9d <strtol+0x11>
		s++;
  800c9a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c9d:	0f b6 01             	movzbl (%ecx),%eax
  800ca0:	3c 20                	cmp    $0x20,%al
  800ca2:	74 f6                	je     800c9a <strtol+0xe>
  800ca4:	3c 09                	cmp    $0x9,%al
  800ca6:	74 f2                	je     800c9a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca8:	3c 2b                	cmp    $0x2b,%al
  800caa:	74 2a                	je     800cd6 <strtol+0x4a>
	int neg = 0;
  800cac:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cb1:	3c 2d                	cmp    $0x2d,%al
  800cb3:	74 2b                	je     800ce0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cbb:	75 0f                	jne    800ccc <strtol+0x40>
  800cbd:	80 39 30             	cmpb   $0x30,(%ecx)
  800cc0:	74 28                	je     800cea <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc9:	0f 44 d8             	cmove  %eax,%ebx
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd4:	eb 50                	jmp    800d26 <strtol+0x9a>
		s++;
  800cd6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cde:	eb d5                	jmp    800cb5 <strtol+0x29>
		s++, neg = 1;
  800ce0:	83 c1 01             	add    $0x1,%ecx
  800ce3:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce8:	eb cb                	jmp    800cb5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cea:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cee:	74 0e                	je     800cfe <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	75 d8                	jne    800ccc <strtol+0x40>
		s++, base = 8;
  800cf4:	83 c1 01             	add    $0x1,%ecx
  800cf7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cfc:	eb ce                	jmp    800ccc <strtol+0x40>
		s += 2, base = 16;
  800cfe:	83 c1 02             	add    $0x2,%ecx
  800d01:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d06:	eb c4                	jmp    800ccc <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d0b:	89 f3                	mov    %esi,%ebx
  800d0d:	80 fb 19             	cmp    $0x19,%bl
  800d10:	77 29                	ja     800d3b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d12:	0f be d2             	movsbl %dl,%edx
  800d15:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d1b:	7d 30                	jge    800d4d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d1d:	83 c1 01             	add    $0x1,%ecx
  800d20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d26:	0f b6 11             	movzbl (%ecx),%edx
  800d29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2c:	89 f3                	mov    %esi,%ebx
  800d2e:	80 fb 09             	cmp    $0x9,%bl
  800d31:	77 d5                	ja     800d08 <strtol+0x7c>
			dig = *s - '0';
  800d33:	0f be d2             	movsbl %dl,%edx
  800d36:	83 ea 30             	sub    $0x30,%edx
  800d39:	eb dd                	jmp    800d18 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d3b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3e:	89 f3                	mov    %esi,%ebx
  800d40:	80 fb 19             	cmp    $0x19,%bl
  800d43:	77 08                	ja     800d4d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d45:	0f be d2             	movsbl %dl,%edx
  800d48:	83 ea 37             	sub    $0x37,%edx
  800d4b:	eb cb                	jmp    800d18 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d51:	74 05                	je     800d58 <strtol+0xcc>
		*endptr = (char *) s;
  800d53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d56:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d58:	89 c2                	mov    %eax,%edx
  800d5a:	f7 da                	neg    %edx
  800d5c:	85 ff                	test   %edi,%edi
  800d5e:	0f 45 c2             	cmovne %edx,%eax
}
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	89 c3                	mov    %eax,%ebx
  800d79:	89 c7                	mov    %eax,%edi
  800d7b:	89 c6                	mov    %eax,%esi
  800d7d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d94:	89 d1                	mov    %edx,%ecx
  800d96:	89 d3                	mov    %edx,%ebx
  800d98:	89 d7                	mov    %edx,%edi
  800d9a:	89 d6                	mov    %edx,%esi
  800d9c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	b8 03 00 00 00       	mov    $0x3,%eax
  800db9:	89 cb                	mov    %ecx,%ebx
  800dbb:	89 cf                	mov    %ecx,%edi
  800dbd:	89 ce                	mov    %ecx,%esi
  800dbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	7f 08                	jg     800dcd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	83 ec 0c             	sub    $0xc,%esp
  800dd0:	50                   	push   %eax
  800dd1:	6a 03                	push   $0x3
  800dd3:	68 40 2a 80 00       	push   $0x802a40
  800dd8:	6a 43                	push   $0x43
  800dda:	68 5d 2a 80 00       	push   $0x802a5d
  800ddf:	e8 f7 f3 ff ff       	call   8001db <_panic>

00800de4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dea:	ba 00 00 00 00       	mov    $0x0,%edx
  800def:	b8 02 00 00 00       	mov    $0x2,%eax
  800df4:	89 d1                	mov    %edx,%ecx
  800df6:	89 d3                	mov    %edx,%ebx
  800df8:	89 d7                	mov    %edx,%edi
  800dfa:	89 d6                	mov    %edx,%esi
  800dfc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <sys_yield>:

void
sys_yield(void)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e09:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e13:	89 d1                	mov    %edx,%ecx
  800e15:	89 d3                	mov    %edx,%ebx
  800e17:	89 d7                	mov    %edx,%edi
  800e19:	89 d6                	mov    %edx,%esi
  800e1b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    

00800e22 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	be 00 00 00 00       	mov    $0x0,%esi
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e36:	b8 04 00 00 00       	mov    $0x4,%eax
  800e3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3e:	89 f7                	mov    %esi,%edi
  800e40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7f 08                	jg     800e4e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4e:	83 ec 0c             	sub    $0xc,%esp
  800e51:	50                   	push   %eax
  800e52:	6a 04                	push   $0x4
  800e54:	68 40 2a 80 00       	push   $0x802a40
  800e59:	6a 43                	push   $0x43
  800e5b:	68 5d 2a 80 00       	push   $0x802a5d
  800e60:	e8 76 f3 ff ff       	call   8001db <_panic>

00800e65 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e74:	b8 05 00 00 00       	mov    $0x5,%eax
  800e79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7f 08                	jg     800e90 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	50                   	push   %eax
  800e94:	6a 05                	push   $0x5
  800e96:	68 40 2a 80 00       	push   $0x802a40
  800e9b:	6a 43                	push   $0x43
  800e9d:	68 5d 2a 80 00       	push   $0x802a5d
  800ea2:	e8 34 f3 ff ff       	call   8001db <_panic>

00800ea7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	57                   	push   %edi
  800eab:	56                   	push   %esi
  800eac:	53                   	push   %ebx
  800ead:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebb:	b8 06 00 00 00       	mov    $0x6,%eax
  800ec0:	89 df                	mov    %ebx,%edi
  800ec2:	89 de                	mov    %ebx,%esi
  800ec4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	7f 08                	jg     800ed2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecd:	5b                   	pop    %ebx
  800ece:	5e                   	pop    %esi
  800ecf:	5f                   	pop    %edi
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed2:	83 ec 0c             	sub    $0xc,%esp
  800ed5:	50                   	push   %eax
  800ed6:	6a 06                	push   $0x6
  800ed8:	68 40 2a 80 00       	push   $0x802a40
  800edd:	6a 43                	push   $0x43
  800edf:	68 5d 2a 80 00       	push   $0x802a5d
  800ee4:	e8 f2 f2 ff ff       	call   8001db <_panic>

00800ee9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	57                   	push   %edi
  800eed:	56                   	push   %esi
  800eee:	53                   	push   %ebx
  800eef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  800efa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efd:	b8 08 00 00 00       	mov    $0x8,%eax
  800f02:	89 df                	mov    %ebx,%edi
  800f04:	89 de                	mov    %ebx,%esi
  800f06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7f 08                	jg     800f14 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	50                   	push   %eax
  800f18:	6a 08                	push   $0x8
  800f1a:	68 40 2a 80 00       	push   $0x802a40
  800f1f:	6a 43                	push   $0x43
  800f21:	68 5d 2a 80 00       	push   $0x802a5d
  800f26:	e8 b0 f2 ff ff       	call   8001db <_panic>

00800f2b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 09 00 00 00       	mov    $0x9,%eax
  800f44:	89 df                	mov    %ebx,%edi
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	7f 08                	jg     800f56 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	50                   	push   %eax
  800f5a:	6a 09                	push   $0x9
  800f5c:	68 40 2a 80 00       	push   $0x802a40
  800f61:	6a 43                	push   $0x43
  800f63:	68 5d 2a 80 00       	push   $0x802a5d
  800f68:	e8 6e f2 ff ff       	call   8001db <_panic>

00800f6d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	57                   	push   %edi
  800f71:	56                   	push   %esi
  800f72:	53                   	push   %ebx
  800f73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f86:	89 df                	mov    %ebx,%edi
  800f88:	89 de                	mov    %ebx,%esi
  800f8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	7f 08                	jg     800f98 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	6a 0a                	push   $0xa
  800f9e:	68 40 2a 80 00       	push   $0x802a40
  800fa3:	6a 43                	push   $0x43
  800fa5:	68 5d 2a 80 00       	push   $0x802a5d
  800faa:	e8 2c f2 ff ff       	call   8001db <_panic>

00800faf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc0:	be 00 00 00 00       	mov    $0x0,%esi
  800fc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fcb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe8:	89 cb                	mov    %ecx,%ebx
  800fea:	89 cf                	mov    %ecx,%edi
  800fec:	89 ce                	mov    %ecx,%esi
  800fee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	7f 08                	jg     800ffc <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	50                   	push   %eax
  801000:	6a 0d                	push   $0xd
  801002:	68 40 2a 80 00       	push   $0x802a40
  801007:	6a 43                	push   $0x43
  801009:	68 5d 2a 80 00       	push   $0x802a5d
  80100e:	e8 c8 f1 ff ff       	call   8001db <_panic>

00801013 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	53                   	push   %ebx
	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	b8 0e 00 00 00       	mov    $0xe,%eax
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	b8 0f 00 00 00       	mov    $0xf,%eax
  801047:	89 cb                	mov    %ecx,%ebx
  801049:	89 cf                	mov    %ecx,%edi
  80104b:	89 ce                	mov    %ecx,%esi
  80104d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	05 00 00 00 30       	add    $0x30000000,%eax
  80105f:	c1 e8 0c             	shr    $0xc,%eax
}
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80106f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801074:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 16             	shr    $0x16,%edx
  801088:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	74 2d                	je     8010c1 <fd_alloc+0x46>
  801094:	89 c2                	mov    %eax,%edx
  801096:	c1 ea 0c             	shr    $0xc,%edx
  801099:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a0:	f6 c2 01             	test   $0x1,%dl
  8010a3:	74 1c                	je     8010c1 <fd_alloc+0x46>
  8010a5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010aa:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010af:	75 d2                	jne    801083 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010ba:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010bf:	eb 0a                	jmp    8010cb <fd_alloc+0x50>
			*fd_store = fd;
  8010c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010d3:	83 f8 1f             	cmp    $0x1f,%eax
  8010d6:	77 30                	ja     801108 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d8:	c1 e0 0c             	shl    $0xc,%eax
  8010db:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010e0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010e6:	f6 c2 01             	test   $0x1,%dl
  8010e9:	74 24                	je     80110f <fd_lookup+0x42>
  8010eb:	89 c2                	mov    %eax,%edx
  8010ed:	c1 ea 0c             	shr    $0xc,%edx
  8010f0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f7:	f6 c2 01             	test   $0x1,%dl
  8010fa:	74 1a                	je     801116 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ff:	89 02                	mov    %eax,(%edx)
	return 0;
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    
		return -E_INVAL;
  801108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110d:	eb f7                	jmp    801106 <fd_lookup+0x39>
		return -E_INVAL;
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801114:	eb f0                	jmp    801106 <fd_lookup+0x39>
  801116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111b:	eb e9                	jmp    801106 <fd_lookup+0x39>

0080111d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801126:	ba e8 2a 80 00       	mov    $0x802ae8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80112b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801130:	39 08                	cmp    %ecx,(%eax)
  801132:	74 33                	je     801167 <dev_lookup+0x4a>
  801134:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801137:	8b 02                	mov    (%edx),%eax
  801139:	85 c0                	test   %eax,%eax
  80113b:	75 f3                	jne    801130 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113d:	a1 04 40 80 00       	mov    0x804004,%eax
  801142:	8b 40 48             	mov    0x48(%eax),%eax
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	51                   	push   %ecx
  801149:	50                   	push   %eax
  80114a:	68 6c 2a 80 00       	push   $0x802a6c
  80114f:	e8 7d f1 ff ff       	call   8002d1 <cprintf>
	*dev = 0;
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    
			*dev = devtab[i];
  801167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80116c:	b8 00 00 00 00       	mov    $0x0,%eax
  801171:	eb f2                	jmp    801165 <dev_lookup+0x48>

00801173 <fd_close>:
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 24             	sub    $0x24,%esp
  80117c:	8b 75 08             	mov    0x8(%ebp),%esi
  80117f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801182:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801185:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801186:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80118c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80118f:	50                   	push   %eax
  801190:	e8 38 ff ff ff       	call   8010cd <fd_lookup>
  801195:	89 c3                	mov    %eax,%ebx
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	85 c0                	test   %eax,%eax
  80119c:	78 05                	js     8011a3 <fd_close+0x30>
	    || fd != fd2)
  80119e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011a1:	74 16                	je     8011b9 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011a3:	89 f8                	mov    %edi,%eax
  8011a5:	84 c0                	test   %al,%al
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ac:	0f 44 d8             	cmove  %eax,%ebx
}
  8011af:	89 d8                	mov    %ebx,%eax
  8011b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b9:	83 ec 08             	sub    $0x8,%esp
  8011bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011bf:	50                   	push   %eax
  8011c0:	ff 36                	pushl  (%esi)
  8011c2:	e8 56 ff ff ff       	call   80111d <dev_lookup>
  8011c7:	89 c3                	mov    %eax,%ebx
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 1a                	js     8011ea <fd_close+0x77>
		if (dev->dev_close)
  8011d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	74 0b                	je     8011ea <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	56                   	push   %esi
  8011e3:	ff d0                	call   *%eax
  8011e5:	89 c3                	mov    %eax,%ebx
  8011e7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	56                   	push   %esi
  8011ee:	6a 00                	push   $0x0
  8011f0:	e8 b2 fc ff ff       	call   800ea7 <sys_page_unmap>
	return r;
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	eb b5                	jmp    8011af <fd_close+0x3c>

008011fa <close>:

int
close(int fdnum)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801200:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801203:	50                   	push   %eax
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	e8 c1 fe ff ff       	call   8010cd <fd_lookup>
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	79 02                	jns    801215 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801213:	c9                   	leave  
  801214:	c3                   	ret    
		return fd_close(fd, 1);
  801215:	83 ec 08             	sub    $0x8,%esp
  801218:	6a 01                	push   $0x1
  80121a:	ff 75 f4             	pushl  -0xc(%ebp)
  80121d:	e8 51 ff ff ff       	call   801173 <fd_close>
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	eb ec                	jmp    801213 <close+0x19>

00801227 <close_all>:

void
close_all(void)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	53                   	push   %ebx
  80122b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	53                   	push   %ebx
  801237:	e8 be ff ff ff       	call   8011fa <close>
	for (i = 0; i < MAXFD; i++)
  80123c:	83 c3 01             	add    $0x1,%ebx
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	83 fb 20             	cmp    $0x20,%ebx
  801245:	75 ec                	jne    801233 <close_all+0xc>
}
  801247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801255:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	ff 75 08             	pushl  0x8(%ebp)
  80125c:	e8 6c fe ff ff       	call   8010cd <fd_lookup>
  801261:	89 c3                	mov    %eax,%ebx
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	0f 88 81 00 00 00    	js     8012ef <dup+0xa3>
		return r;
	close(newfdnum);
  80126e:	83 ec 0c             	sub    $0xc,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	e8 81 ff ff ff       	call   8011fa <close>

	newfd = INDEX2FD(newfdnum);
  801279:	8b 75 0c             	mov    0xc(%ebp),%esi
  80127c:	c1 e6 0c             	shl    $0xc,%esi
  80127f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801285:	83 c4 04             	add    $0x4,%esp
  801288:	ff 75 e4             	pushl  -0x1c(%ebp)
  80128b:	e8 d4 fd ff ff       	call   801064 <fd2data>
  801290:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801292:	89 34 24             	mov    %esi,(%esp)
  801295:	e8 ca fd ff ff       	call   801064 <fd2data>
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	c1 e8 16             	shr    $0x16,%eax
  8012a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ab:	a8 01                	test   $0x1,%al
  8012ad:	74 11                	je     8012c0 <dup+0x74>
  8012af:	89 d8                	mov    %ebx,%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
  8012b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	75 39                	jne    8012f9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c3:	89 d0                	mov    %edx,%eax
  8012c5:	c1 e8 0c             	shr    $0xc,%eax
  8012c8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d7:	50                   	push   %eax
  8012d8:	56                   	push   %esi
  8012d9:	6a 00                	push   $0x0
  8012db:	52                   	push   %edx
  8012dc:	6a 00                	push   $0x0
  8012de:	e8 82 fb ff ff       	call   800e65 <sys_page_map>
  8012e3:	89 c3                	mov    %eax,%ebx
  8012e5:	83 c4 20             	add    $0x20,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	78 31                	js     80131d <dup+0xd1>
		goto err;

	return newfdnum;
  8012ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012ef:	89 d8                	mov    %ebx,%eax
  8012f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5f                   	pop    %edi
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801300:	83 ec 0c             	sub    $0xc,%esp
  801303:	25 07 0e 00 00       	and    $0xe07,%eax
  801308:	50                   	push   %eax
  801309:	57                   	push   %edi
  80130a:	6a 00                	push   $0x0
  80130c:	53                   	push   %ebx
  80130d:	6a 00                	push   $0x0
  80130f:	e8 51 fb ff ff       	call   800e65 <sys_page_map>
  801314:	89 c3                	mov    %eax,%ebx
  801316:	83 c4 20             	add    $0x20,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	79 a3                	jns    8012c0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	56                   	push   %esi
  801321:	6a 00                	push   $0x0
  801323:	e8 7f fb ff ff       	call   800ea7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	57                   	push   %edi
  80132c:	6a 00                	push   $0x0
  80132e:	e8 74 fb ff ff       	call   800ea7 <sys_page_unmap>
	return r;
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	eb b7                	jmp    8012ef <dup+0xa3>

00801338 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	53                   	push   %ebx
  80133c:	83 ec 1c             	sub    $0x1c,%esp
  80133f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801342:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801345:	50                   	push   %eax
  801346:	53                   	push   %ebx
  801347:	e8 81 fd ff ff       	call   8010cd <fd_lookup>
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 3f                	js     801392 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	ff 30                	pushl  (%eax)
  80135f:	e8 b9 fd ff ff       	call   80111d <dev_lookup>
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 27                	js     801392 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80136b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136e:	8b 42 08             	mov    0x8(%edx),%eax
  801371:	83 e0 03             	and    $0x3,%eax
  801374:	83 f8 01             	cmp    $0x1,%eax
  801377:	74 1e                	je     801397 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	8b 40 08             	mov    0x8(%eax),%eax
  80137f:	85 c0                	test   %eax,%eax
  801381:	74 35                	je     8013b8 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	ff 75 10             	pushl  0x10(%ebp)
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	52                   	push   %edx
  80138d:	ff d0                	call   *%eax
  80138f:	83 c4 10             	add    $0x10,%esp
}
  801392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801395:	c9                   	leave  
  801396:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801397:	a1 04 40 80 00       	mov    0x804004,%eax
  80139c:	8b 40 48             	mov    0x48(%eax),%eax
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	53                   	push   %ebx
  8013a3:	50                   	push   %eax
  8013a4:	68 ad 2a 80 00       	push   $0x802aad
  8013a9:	e8 23 ef ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b6:	eb da                	jmp    801392 <read+0x5a>
		return -E_NOT_SUPP;
  8013b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bd:	eb d3                	jmp    801392 <read+0x5a>

008013bf <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	57                   	push   %edi
  8013c3:	56                   	push   %esi
  8013c4:	53                   	push   %ebx
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d3:	39 f3                	cmp    %esi,%ebx
  8013d5:	73 23                	jae    8013fa <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	89 f0                	mov    %esi,%eax
  8013dc:	29 d8                	sub    %ebx,%eax
  8013de:	50                   	push   %eax
  8013df:	89 d8                	mov    %ebx,%eax
  8013e1:	03 45 0c             	add    0xc(%ebp),%eax
  8013e4:	50                   	push   %eax
  8013e5:	57                   	push   %edi
  8013e6:	e8 4d ff ff ff       	call   801338 <read>
		if (m < 0)
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	78 06                	js     8013f8 <readn+0x39>
			return m;
		if (m == 0)
  8013f2:	74 06                	je     8013fa <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013f4:	01 c3                	add    %eax,%ebx
  8013f6:	eb db                	jmp    8013d3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	53                   	push   %ebx
  801408:	83 ec 1c             	sub    $0x1c,%esp
  80140b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801411:	50                   	push   %eax
  801412:	53                   	push   %ebx
  801413:	e8 b5 fc ff ff       	call   8010cd <fd_lookup>
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 3a                	js     801459 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801429:	ff 30                	pushl  (%eax)
  80142b:	e8 ed fc ff ff       	call   80111d <dev_lookup>
  801430:	83 c4 10             	add    $0x10,%esp
  801433:	85 c0                	test   %eax,%eax
  801435:	78 22                	js     801459 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80143e:	74 1e                	je     80145e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801443:	8b 52 0c             	mov    0xc(%edx),%edx
  801446:	85 d2                	test   %edx,%edx
  801448:	74 35                	je     80147f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	ff 75 10             	pushl  0x10(%ebp)
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	50                   	push   %eax
  801454:	ff d2                	call   *%edx
  801456:	83 c4 10             	add    $0x10,%esp
}
  801459:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80145e:	a1 04 40 80 00       	mov    0x804004,%eax
  801463:	8b 40 48             	mov    0x48(%eax),%eax
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	53                   	push   %ebx
  80146a:	50                   	push   %eax
  80146b:	68 c9 2a 80 00       	push   $0x802ac9
  801470:	e8 5c ee ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147d:	eb da                	jmp    801459 <write+0x55>
		return -E_NOT_SUPP;
  80147f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801484:	eb d3                	jmp    801459 <write+0x55>

00801486 <seek>:

int
seek(int fdnum, off_t offset)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148f:	50                   	push   %eax
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 35 fc ff ff       	call   8010cd <fd_lookup>
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 0e                	js     8014ad <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	53                   	push   %ebx
  8014b3:	83 ec 1c             	sub    $0x1c,%esp
  8014b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014bc:	50                   	push   %eax
  8014bd:	53                   	push   %ebx
  8014be:	e8 0a fc ff ff       	call   8010cd <fd_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 37                	js     801501 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d4:	ff 30                	pushl  (%eax)
  8014d6:	e8 42 fc ff ff       	call   80111d <dev_lookup>
  8014db:	83 c4 10             	add    $0x10,%esp
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 1f                	js     801501 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e9:	74 1b                	je     801506 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ee:	8b 52 18             	mov    0x18(%edx),%edx
  8014f1:	85 d2                	test   %edx,%edx
  8014f3:	74 32                	je     801527 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	ff 75 0c             	pushl  0xc(%ebp)
  8014fb:	50                   	push   %eax
  8014fc:	ff d2                	call   *%edx
  8014fe:	83 c4 10             	add    $0x10,%esp
}
  801501:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801504:	c9                   	leave  
  801505:	c3                   	ret    
			thisenv->env_id, fdnum);
  801506:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80150b:	8b 40 48             	mov    0x48(%eax),%eax
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	53                   	push   %ebx
  801512:	50                   	push   %eax
  801513:	68 8c 2a 80 00       	push   $0x802a8c
  801518:	e8 b4 ed ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801525:	eb da                	jmp    801501 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801527:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152c:	eb d3                	jmp    801501 <ftruncate+0x52>

0080152e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	53                   	push   %ebx
  801532:	83 ec 1c             	sub    $0x1c,%esp
  801535:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801538:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	e8 89 fb ff ff       	call   8010cd <fd_lookup>
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 4b                	js     801596 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	ff 30                	pushl  (%eax)
  801557:	e8 c1 fb ff ff       	call   80111d <dev_lookup>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 33                	js     801596 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801566:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80156a:	74 2f                	je     80159b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80156c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80156f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801576:	00 00 00 
	stat->st_isdir = 0;
  801579:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801580:	00 00 00 
	stat->st_dev = dev;
  801583:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	53                   	push   %ebx
  80158d:	ff 75 f0             	pushl  -0x10(%ebp)
  801590:	ff 50 14             	call   *0x14(%eax)
  801593:	83 c4 10             	add    $0x10,%esp
}
  801596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801599:	c9                   	leave  
  80159a:	c3                   	ret    
		return -E_NOT_SUPP;
  80159b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a0:	eb f4                	jmp    801596 <fstat+0x68>

008015a2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	56                   	push   %esi
  8015a6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	6a 00                	push   $0x0
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	e8 bb 01 00 00       	call   80176f <open>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 1b                	js     8015d8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	ff 75 0c             	pushl  0xc(%ebp)
  8015c3:	50                   	push   %eax
  8015c4:	e8 65 ff ff ff       	call   80152e <fstat>
  8015c9:	89 c6                	mov    %eax,%esi
	close(fd);
  8015cb:	89 1c 24             	mov    %ebx,(%esp)
  8015ce:	e8 27 fc ff ff       	call   8011fa <close>
	return r;
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	89 f3                	mov    %esi,%ebx
}
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    

008015e1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	56                   	push   %esi
  8015e5:	53                   	push   %ebx
  8015e6:	89 c6                	mov    %eax,%esi
  8015e8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ea:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015f1:	74 27                	je     80161a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015f3:	6a 07                	push   $0x7
  8015f5:	68 00 50 80 00       	push   $0x805000
  8015fa:	56                   	push   %esi
  8015fb:	ff 35 00 40 80 00    	pushl  0x804000
  801601:	e8 99 0c 00 00       	call   80229f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801606:	83 c4 0c             	add    $0xc,%esp
  801609:	6a 00                	push   $0x0
  80160b:	53                   	push   %ebx
  80160c:	6a 00                	push   $0x0
  80160e:	e8 23 0c 00 00       	call   802236 <ipc_recv>
}
  801613:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801616:	5b                   	pop    %ebx
  801617:	5e                   	pop    %esi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	6a 01                	push   $0x1
  80161f:	e8 d3 0c 00 00       	call   8022f7 <ipc_find_env>
  801624:	a3 00 40 80 00       	mov    %eax,0x804000
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	eb c5                	jmp    8015f3 <fsipc+0x12>

0080162e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8b 40 0c             	mov    0xc(%eax),%eax
  80163a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	b8 02 00 00 00       	mov    $0x2,%eax
  801651:	e8 8b ff ff ff       	call   8015e1 <fsipc>
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <devfile_flush>:
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8b 40 0c             	mov    0xc(%eax),%eax
  801664:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801669:	ba 00 00 00 00       	mov    $0x0,%edx
  80166e:	b8 06 00 00 00       	mov    $0x6,%eax
  801673:	e8 69 ff ff ff       	call   8015e1 <fsipc>
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <devfile_stat>:
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8b 40 0c             	mov    0xc(%eax),%eax
  80168a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168f:	ba 00 00 00 00       	mov    $0x0,%edx
  801694:	b8 05 00 00 00       	mov    $0x5,%eax
  801699:	e8 43 ff ff ff       	call   8015e1 <fsipc>
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 2c                	js     8016ce <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	68 00 50 80 00       	push   $0x805000
  8016aa:	53                   	push   %ebx
  8016ab:	e8 80 f3 ff ff       	call   800a30 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016b0:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016bb:	a1 84 50 80 00       	mov    0x805084,%eax
  8016c0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <devfile_write>:
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 0c             	sub    $0xc,%esp
	panic("devfile_write not implemented");
  8016d9:	68 f8 2a 80 00       	push   $0x802af8
  8016de:	68 90 00 00 00       	push   $0x90
  8016e3:	68 16 2b 80 00       	push   $0x802b16
  8016e8:	e8 ee ea ff ff       	call   8001db <_panic>

008016ed <devfile_read>:
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801700:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801706:	ba 00 00 00 00       	mov    $0x0,%edx
  80170b:	b8 03 00 00 00       	mov    $0x3,%eax
  801710:	e8 cc fe ff ff       	call   8015e1 <fsipc>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	85 c0                	test   %eax,%eax
  801719:	78 1f                	js     80173a <devfile_read+0x4d>
	assert(r <= n);
  80171b:	39 f0                	cmp    %esi,%eax
  80171d:	77 24                	ja     801743 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80171f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801724:	7f 33                	jg     801759 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	50                   	push   %eax
  80172a:	68 00 50 80 00       	push   $0x805000
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	e8 87 f4 ff ff       	call   800bbe <memmove>
	return r;
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	89 d8                	mov    %ebx,%eax
  80173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
	assert(r <= n);
  801743:	68 21 2b 80 00       	push   $0x802b21
  801748:	68 28 2b 80 00       	push   $0x802b28
  80174d:	6a 7c                	push   $0x7c
  80174f:	68 16 2b 80 00       	push   $0x802b16
  801754:	e8 82 ea ff ff       	call   8001db <_panic>
	assert(r <= PGSIZE);
  801759:	68 3d 2b 80 00       	push   $0x802b3d
  80175e:	68 28 2b 80 00       	push   $0x802b28
  801763:	6a 7d                	push   $0x7d
  801765:	68 16 2b 80 00       	push   $0x802b16
  80176a:	e8 6c ea ff ff       	call   8001db <_panic>

0080176f <open>:
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
  801774:	83 ec 1c             	sub    $0x1c,%esp
  801777:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80177a:	56                   	push   %esi
  80177b:	e8 77 f2 ff ff       	call   8009f7 <strlen>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801788:	7f 6c                	jg     8017f6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801790:	50                   	push   %eax
  801791:	e8 e5 f8 ff ff       	call   80107b <fd_alloc>
  801796:	89 c3                	mov    %eax,%ebx
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	85 c0                	test   %eax,%eax
  80179d:	78 3c                	js     8017db <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80179f:	83 ec 08             	sub    $0x8,%esp
  8017a2:	56                   	push   %esi
  8017a3:	68 00 50 80 00       	push   $0x805000
  8017a8:	e8 83 f2 ff ff       	call   800a30 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bd:	e8 1f fe ff ff       	call   8015e1 <fsipc>
  8017c2:	89 c3                	mov    %eax,%ebx
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 19                	js     8017e4 <open+0x75>
	return fd2num(fd);
  8017cb:	83 ec 0c             	sub    $0xc,%esp
  8017ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d1:	e8 7e f8 ff ff       	call   801054 <fd2num>
  8017d6:	89 c3                	mov    %eax,%ebx
  8017d8:	83 c4 10             	add    $0x10,%esp
}
  8017db:	89 d8                	mov    %ebx,%eax
  8017dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5d                   	pop    %ebp
  8017e3:	c3                   	ret    
		fd_close(fd, 0);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	6a 00                	push   $0x0
  8017e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ec:	e8 82 f9 ff ff       	call   801173 <fd_close>
		return r;
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	eb e5                	jmp    8017db <open+0x6c>
		return -E_BAD_PATH;
  8017f6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017fb:	eb de                	jmp    8017db <open+0x6c>

008017fd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801803:	ba 00 00 00 00       	mov    $0x0,%edx
  801808:	b8 08 00 00 00       	mov    $0x8,%eax
  80180d:	e8 cf fd ff ff       	call   8015e1 <fsipc>
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	57                   	push   %edi
  801818:	56                   	push   %esi
  801819:	53                   	push   %ebx
  80181a:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801820:	6a 00                	push   $0x0
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 45 ff ff ff       	call   80176f <open>
  80182a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	85 c0                	test   %eax,%eax
  801835:	0f 88 71 04 00 00    	js     801cac <spawn+0x498>
  80183b:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 00 02 00 00       	push   $0x200
  801845:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80184b:	50                   	push   %eax
  80184c:	52                   	push   %edx
  80184d:	e8 6d fb ff ff       	call   8013bf <readn>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	3d 00 02 00 00       	cmp    $0x200,%eax
  80185a:	75 5f                	jne    8018bb <spawn+0xa7>
	    || elf->e_magic != ELF_MAGIC) {
  80185c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801863:	45 4c 46 
  801866:	75 53                	jne    8018bb <spawn+0xa7>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801868:	b8 07 00 00 00       	mov    $0x7,%eax
  80186d:	cd 30                	int    $0x30
  80186f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801875:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  80187b:	85 c0                	test   %eax,%eax
  80187d:	0f 88 1d 04 00 00    	js     801ca0 <spawn+0x48c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801883:	25 ff 03 00 00       	and    $0x3ff,%eax
  801888:	89 c6                	mov    %eax,%esi
  80188a:	c1 e6 07             	shl    $0x7,%esi
  80188d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801893:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801899:	b9 11 00 00 00       	mov    $0x11,%ecx
  80189e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018a0:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8018a6:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018ac:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8018b1:	be 00 00 00 00       	mov    $0x0,%esi
  8018b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8018b9:	eb 4b                	jmp    801906 <spawn+0xf2>
		close(fd);
  8018bb:	83 ec 0c             	sub    $0xc,%esp
  8018be:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8018c4:	e8 31 f9 ff ff       	call   8011fa <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8018c9:	83 c4 0c             	add    $0xc,%esp
  8018cc:	68 7f 45 4c 46       	push   $0x464c457f
  8018d1:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8018d7:	68 49 2b 80 00       	push   $0x802b49
  8018dc:	e8 f0 e9 ff ff       	call   8002d1 <cprintf>
		return -E_NOT_EXEC;
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8018eb:	ff ff ff 
  8018ee:	e9 b9 03 00 00       	jmp    801cac <spawn+0x498>
		string_size += strlen(argv[argc]) + 1;
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	50                   	push   %eax
  8018f7:	e8 fb f0 ff ff       	call   8009f7 <strlen>
  8018fc:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801900:	83 c3 01             	add    $0x1,%ebx
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80190d:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801910:	85 c0                	test   %eax,%eax
  801912:	75 df                	jne    8018f3 <spawn+0xdf>
  801914:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80191a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801920:	bf 00 10 40 00       	mov    $0x401000,%edi
  801925:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801927:	89 fa                	mov    %edi,%edx
  801929:	83 e2 fc             	and    $0xfffffffc,%edx
  80192c:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801933:	29 c2                	sub    %eax,%edx
  801935:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80193b:	8d 42 f8             	lea    -0x8(%edx),%eax
  80193e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801943:	0f 86 86 03 00 00    	jbe    801ccf <spawn+0x4bb>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	6a 07                	push   $0x7
  80194e:	68 00 00 40 00       	push   $0x400000
  801953:	6a 00                	push   $0x0
  801955:	e8 c8 f4 ff ff       	call   800e22 <sys_page_alloc>
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	0f 88 6f 03 00 00    	js     801cd4 <spawn+0x4c0>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801965:	be 00 00 00 00       	mov    $0x0,%esi
  80196a:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801970:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801973:	eb 30                	jmp    8019a5 <spawn+0x191>
		argv_store[i] = UTEMP2USTACK(string_store);
  801975:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80197b:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801981:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80198a:	57                   	push   %edi
  80198b:	e8 a0 f0 ff ff       	call   800a30 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801990:	83 c4 04             	add    $0x4,%esp
  801993:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801996:	e8 5c f0 ff ff       	call   8009f7 <strlen>
  80199b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80199f:	83 c6 01             	add    $0x1,%esi
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8019ab:	7f c8                	jg     801975 <spawn+0x161>
	}
	argv_store[argc] = 0;
  8019ad:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019b3:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8019b9:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019c0:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8019c6:	0f 85 86 00 00 00    	jne    801a52 <spawn+0x23e>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8019cc:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8019d2:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8019d8:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8019db:	89 c8                	mov    %ecx,%eax
  8019dd:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  8019e3:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8019e6:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8019eb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8019f1:	83 ec 0c             	sub    $0xc,%esp
  8019f4:	6a 07                	push   $0x7
  8019f6:	68 00 d0 bf ee       	push   $0xeebfd000
  8019fb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a01:	68 00 00 40 00       	push   $0x400000
  801a06:	6a 00                	push   $0x0
  801a08:	e8 58 f4 ff ff       	call   800e65 <sys_page_map>
  801a0d:	89 c3                	mov    %eax,%ebx
  801a0f:	83 c4 20             	add    $0x20,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	0f 88 c2 02 00 00    	js     801cdc <spawn+0x4c8>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801a1a:	83 ec 08             	sub    $0x8,%esp
  801a1d:	68 00 00 40 00       	push   $0x400000
  801a22:	6a 00                	push   $0x0
  801a24:	e8 7e f4 ff ff       	call   800ea7 <sys_page_unmap>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	0f 88 a6 02 00 00    	js     801cdc <spawn+0x4c8>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801a36:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801a3c:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a43:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801a4a:	00 00 00 
  801a4d:	e9 4f 01 00 00       	jmp    801ba1 <spawn+0x38d>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a52:	68 c0 2b 80 00       	push   $0x802bc0
  801a57:	68 28 2b 80 00       	push   $0x802b28
  801a5c:	68 f2 00 00 00       	push   $0xf2
  801a61:	68 63 2b 80 00       	push   $0x802b63
  801a66:	e8 70 e7 ff ff       	call   8001db <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a6b:	83 ec 04             	sub    $0x4,%esp
  801a6e:	6a 07                	push   $0x7
  801a70:	68 00 00 40 00       	push   $0x400000
  801a75:	6a 00                	push   $0x0
  801a77:	e8 a6 f3 ff ff       	call   800e22 <sys_page_alloc>
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	0f 88 33 02 00 00    	js     801cba <spawn+0x4a6>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801a87:	83 ec 08             	sub    $0x8,%esp
  801a8a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801a90:	01 f0                	add    %esi,%eax
  801a92:	50                   	push   %eax
  801a93:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a99:	e8 e8 f9 ff ff       	call   801486 <seek>
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	0f 88 18 02 00 00    	js     801cc1 <spawn+0x4ad>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ab2:	29 f0                	sub    %esi,%eax
  801ab4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ab9:	ba 00 10 00 00       	mov    $0x1000,%edx
  801abe:	0f 47 c2             	cmova  %edx,%eax
  801ac1:	50                   	push   %eax
  801ac2:	68 00 00 40 00       	push   $0x400000
  801ac7:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801acd:	e8 ed f8 ff ff       	call   8013bf <readn>
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	0f 88 eb 01 00 00    	js     801cc8 <spawn+0x4b4>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ae6:	53                   	push   %ebx
  801ae7:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801aed:	68 00 00 40 00       	push   $0x400000
  801af2:	6a 00                	push   $0x0
  801af4:	e8 6c f3 ff ff       	call   800e65 <sys_page_map>
  801af9:	83 c4 20             	add    $0x20,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 7c                	js     801b7c <spawn+0x368>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	68 00 00 40 00       	push   $0x400000
  801b08:	6a 00                	push   $0x0
  801b0a:	e8 98 f3 ff ff       	call   800ea7 <sys_page_unmap>
  801b0f:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801b12:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801b18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b1e:	89 fe                	mov    %edi,%esi
  801b20:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801b26:	76 69                	jbe    801b91 <spawn+0x37d>
		if (i >= filesz) {
  801b28:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801b2e:	0f 87 37 ff ff ff    	ja     801a6b <spawn+0x257>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801b3d:	53                   	push   %ebx
  801b3e:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801b44:	e8 d9 f2 ff ff       	call   800e22 <sys_page_alloc>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	79 c2                	jns    801b12 <spawn+0x2fe>
  801b50:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b5b:	e8 43 f2 ff ff       	call   800da3 <sys_env_destroy>
	close(fd);
  801b60:	83 c4 04             	add    $0x4,%esp
  801b63:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b69:	e8 8c f6 ff ff       	call   8011fa <close>
	return r;
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801b77:	e9 30 01 00 00       	jmp    801cac <spawn+0x498>
				panic("spawn: sys_page_map data: %e", r);
  801b7c:	50                   	push   %eax
  801b7d:	68 6f 2b 80 00       	push   $0x802b6f
  801b82:	68 25 01 00 00       	push   $0x125
  801b87:	68 63 2b 80 00       	push   $0x802b63
  801b8c:	e8 4a e6 ff ff       	call   8001db <_panic>
  801b91:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b97:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801b9e:	83 c6 20             	add    $0x20,%esi
  801ba1:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ba8:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801bae:	7e 6d                	jle    801c1d <spawn+0x409>
		if (ph->p_type != ELF_PROG_LOAD)
  801bb0:	83 3e 01             	cmpl   $0x1,(%esi)
  801bb3:	75 e2                	jne    801b97 <spawn+0x383>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801bb5:	8b 46 18             	mov    0x18(%esi),%eax
  801bb8:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801bbb:	83 f8 01             	cmp    $0x1,%eax
  801bbe:	19 c0                	sbb    %eax,%eax
  801bc0:	83 e0 fe             	and    $0xfffffffe,%eax
  801bc3:	83 c0 07             	add    $0x7,%eax
  801bc6:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801bcc:	8b 4e 04             	mov    0x4(%esi),%ecx
  801bcf:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801bd5:	8b 56 10             	mov    0x10(%esi),%edx
  801bd8:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801bde:	8b 7e 14             	mov    0x14(%esi),%edi
  801be1:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801be7:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801bea:	89 d8                	mov    %ebx,%eax
  801bec:	25 ff 0f 00 00       	and    $0xfff,%eax
  801bf1:	74 1a                	je     801c0d <spawn+0x3f9>
		va -= i;
  801bf3:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801bf5:	01 c7                	add    %eax,%edi
  801bf7:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801bfd:	01 c2                	add    %eax,%edx
  801bff:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801c05:	29 c1                	sub    %eax,%ecx
  801c07:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801c0d:	bf 00 00 00 00       	mov    $0x0,%edi
  801c12:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801c18:	e9 01 ff ff ff       	jmp    801b1e <spawn+0x30a>
	close(fd);
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c26:	e8 cf f5 ff ff       	call   8011fa <close>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801c2b:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801c32:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c35:	83 c4 08             	add    $0x8,%esp
  801c38:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c3e:	50                   	push   %eax
  801c3f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c45:	e8 e1 f2 ff ff       	call   800f2b <sys_env_set_trapframe>
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 25                	js     801c76 <spawn+0x462>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	6a 02                	push   $0x2
  801c56:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c5c:	e8 88 f2 ff ff       	call   800ee9 <sys_env_set_status>
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 23                	js     801c8b <spawn+0x477>
	return child;
  801c68:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c6e:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c74:	eb 36                	jmp    801cac <spawn+0x498>
		panic("sys_env_set_trapframe: %e", r);
  801c76:	50                   	push   %eax
  801c77:	68 8c 2b 80 00       	push   $0x802b8c
  801c7c:	68 86 00 00 00       	push   $0x86
  801c81:	68 63 2b 80 00       	push   $0x802b63
  801c86:	e8 50 e5 ff ff       	call   8001db <_panic>
		panic("sys_env_set_status: %e", r);
  801c8b:	50                   	push   %eax
  801c8c:	68 a6 2b 80 00       	push   $0x802ba6
  801c91:	68 89 00 00 00       	push   $0x89
  801c96:	68 63 2b 80 00       	push   $0x802b63
  801c9b:	e8 3b e5 ff ff       	call   8001db <_panic>
		return r;
  801ca0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ca6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801cac:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5f                   	pop    %edi
  801cb8:	5d                   	pop    %ebp
  801cb9:	c3                   	ret    
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	e9 91 fe ff ff       	jmp    801b52 <spawn+0x33e>
  801cc1:	89 c7                	mov    %eax,%edi
  801cc3:	e9 8a fe ff ff       	jmp    801b52 <spawn+0x33e>
  801cc8:	89 c7                	mov    %eax,%edi
  801cca:	e9 83 fe ff ff       	jmp    801b52 <spawn+0x33e>
		return -E_NO_MEM;
  801ccf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cd4:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801cda:	eb d0                	jmp    801cac <spawn+0x498>
	sys_page_unmap(0, UTEMP);
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	68 00 00 40 00       	push   $0x400000
  801ce4:	6a 00                	push   $0x0
  801ce6:	e8 bc f1 ff ff       	call   800ea7 <sys_page_unmap>
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801cf4:	eb b6                	jmp    801cac <spawn+0x498>

00801cf6 <spawnl>:
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	57                   	push   %edi
  801cfa:	56                   	push   %esi
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801cff:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801d07:	8d 4a 04             	lea    0x4(%edx),%ecx
  801d0a:	83 3a 00             	cmpl   $0x0,(%edx)
  801d0d:	74 07                	je     801d16 <spawnl+0x20>
		argc++;
  801d0f:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801d12:	89 ca                	mov    %ecx,%edx
  801d14:	eb f1                	jmp    801d07 <spawnl+0x11>
	const char *argv[argc+2];
  801d16:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801d1d:	83 e2 f0             	and    $0xfffffff0,%edx
  801d20:	29 d4                	sub    %edx,%esp
  801d22:	8d 54 24 03          	lea    0x3(%esp),%edx
  801d26:	c1 ea 02             	shr    $0x2,%edx
  801d29:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801d30:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d35:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d3c:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d43:	00 
	va_start(vl, arg0);
  801d44:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d47:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	eb 0b                	jmp    801d5b <spawnl+0x65>
		argv[i+1] = va_arg(vl, const char *);
  801d50:	83 c0 01             	add    $0x1,%eax
  801d53:	8b 39                	mov    (%ecx),%edi
  801d55:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d58:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d5b:	39 d0                	cmp    %edx,%eax
  801d5d:	75 f1                	jne    801d50 <spawnl+0x5a>
	return spawn(prog, argv);
  801d5f:	83 ec 08             	sub    $0x8,%esp
  801d62:	56                   	push   %esi
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	e8 a9 fa ff ff       	call   801814 <spawn>
}
  801d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5e                   	pop    %esi
  801d70:	5f                   	pop    %edi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	e8 de f2 ff ff       	call   801064 <fd2data>
  801d86:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d88:	83 c4 08             	add    $0x8,%esp
  801d8b:	68 e8 2b 80 00       	push   $0x802be8
  801d90:	53                   	push   %ebx
  801d91:	e8 9a ec ff ff       	call   800a30 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d96:	8b 46 04             	mov    0x4(%esi),%eax
  801d99:	2b 06                	sub    (%esi),%eax
  801d9b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801da1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801da8:	00 00 00 
	stat->st_dev = &devpipe;
  801dab:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801db2:	30 80 00 
	return 0;
}
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    

00801dc1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dcb:	53                   	push   %ebx
  801dcc:	6a 00                	push   $0x0
  801dce:	e8 d4 f0 ff ff       	call   800ea7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dd3:	89 1c 24             	mov    %ebx,(%esp)
  801dd6:	e8 89 f2 ff ff       	call   801064 <fd2data>
  801ddb:	83 c4 08             	add    $0x8,%esp
  801dde:	50                   	push   %eax
  801ddf:	6a 00                	push   $0x0
  801de1:	e8 c1 f0 ff ff       	call   800ea7 <sys_page_unmap>
}
  801de6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <_pipeisclosed>:
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	57                   	push   %edi
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	83 ec 1c             	sub    $0x1c,%esp
  801df4:	89 c7                	mov    %eax,%edi
  801df6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801df8:	a1 04 40 80 00       	mov    0x804004,%eax
  801dfd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	57                   	push   %edi
  801e04:	e8 29 05 00 00       	call   802332 <pageref>
  801e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e0c:	89 34 24             	mov    %esi,(%esp)
  801e0f:	e8 1e 05 00 00       	call   802332 <pageref>
		nn = thisenv->env_runs;
  801e14:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e1a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	39 cb                	cmp    %ecx,%ebx
  801e22:	74 1b                	je     801e3f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e24:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e27:	75 cf                	jne    801df8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e29:	8b 42 58             	mov    0x58(%edx),%eax
  801e2c:	6a 01                	push   $0x1
  801e2e:	50                   	push   %eax
  801e2f:	53                   	push   %ebx
  801e30:	68 ef 2b 80 00       	push   $0x802bef
  801e35:	e8 97 e4 ff ff       	call   8002d1 <cprintf>
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	eb b9                	jmp    801df8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e3f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e42:	0f 94 c0             	sete   %al
  801e45:	0f b6 c0             	movzbl %al,%eax
}
  801e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5f                   	pop    %edi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <devpipe_write>:
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	57                   	push   %edi
  801e54:	56                   	push   %esi
  801e55:	53                   	push   %ebx
  801e56:	83 ec 28             	sub    $0x28,%esp
  801e59:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e5c:	56                   	push   %esi
  801e5d:	e8 02 f2 ff ff       	call   801064 <fd2data>
  801e62:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	bf 00 00 00 00       	mov    $0x0,%edi
  801e6c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e6f:	74 4f                	je     801ec0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e71:	8b 43 04             	mov    0x4(%ebx),%eax
  801e74:	8b 0b                	mov    (%ebx),%ecx
  801e76:	8d 51 20             	lea    0x20(%ecx),%edx
  801e79:	39 d0                	cmp    %edx,%eax
  801e7b:	72 14                	jb     801e91 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e7d:	89 da                	mov    %ebx,%edx
  801e7f:	89 f0                	mov    %esi,%eax
  801e81:	e8 65 ff ff ff       	call   801deb <_pipeisclosed>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 3b                	jne    801ec5 <devpipe_write+0x75>
			sys_yield();
  801e8a:	e8 74 ef ff ff       	call   800e03 <sys_yield>
  801e8f:	eb e0                	jmp    801e71 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e94:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e98:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e9b:	89 c2                	mov    %eax,%edx
  801e9d:	c1 fa 1f             	sar    $0x1f,%edx
  801ea0:	89 d1                	mov    %edx,%ecx
  801ea2:	c1 e9 1b             	shr    $0x1b,%ecx
  801ea5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ea8:	83 e2 1f             	and    $0x1f,%edx
  801eab:	29 ca                	sub    %ecx,%edx
  801ead:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801eb1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eb5:	83 c0 01             	add    $0x1,%eax
  801eb8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ebb:	83 c7 01             	add    $0x1,%edi
  801ebe:	eb ac                	jmp    801e6c <devpipe_write+0x1c>
	return i;
  801ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec3:	eb 05                	jmp    801eca <devpipe_write+0x7a>
				return 0;
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecd:	5b                   	pop    %ebx
  801ece:	5e                   	pop    %esi
  801ecf:	5f                   	pop    %edi
  801ed0:	5d                   	pop    %ebp
  801ed1:	c3                   	ret    

00801ed2 <devpipe_read>:
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	57                   	push   %edi
  801ed6:	56                   	push   %esi
  801ed7:	53                   	push   %ebx
  801ed8:	83 ec 18             	sub    $0x18,%esp
  801edb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ede:	57                   	push   %edi
  801edf:	e8 80 f1 ff ff       	call   801064 <fd2data>
  801ee4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	be 00 00 00 00       	mov    $0x0,%esi
  801eee:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ef1:	75 14                	jne    801f07 <devpipe_read+0x35>
	return i;
  801ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef6:	eb 02                	jmp    801efa <devpipe_read+0x28>
				return i;
  801ef8:	89 f0                	mov    %esi,%eax
}
  801efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5f                   	pop    %edi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    
			sys_yield();
  801f02:	e8 fc ee ff ff       	call   800e03 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f07:	8b 03                	mov    (%ebx),%eax
  801f09:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f0c:	75 18                	jne    801f26 <devpipe_read+0x54>
			if (i > 0)
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 e6                	jne    801ef8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f12:	89 da                	mov    %ebx,%edx
  801f14:	89 f8                	mov    %edi,%eax
  801f16:	e8 d0 fe ff ff       	call   801deb <_pipeisclosed>
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	74 e3                	je     801f02 <devpipe_read+0x30>
				return 0;
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	eb d4                	jmp    801efa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f26:	99                   	cltd   
  801f27:	c1 ea 1b             	shr    $0x1b,%edx
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	83 e0 1f             	and    $0x1f,%eax
  801f2f:	29 d0                	sub    %edx,%eax
  801f31:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f39:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f3c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f3f:	83 c6 01             	add    $0x1,%esi
  801f42:	eb aa                	jmp    801eee <devpipe_read+0x1c>

00801f44 <pipe>:
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	50                   	push   %eax
  801f50:	e8 26 f1 ff ff       	call   80107b <fd_alloc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	0f 88 23 01 00 00    	js     802085 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	68 07 04 00 00       	push   $0x407
  801f6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 ae ee ff ff       	call   800e22 <sys_page_alloc>
  801f74:	89 c3                	mov    %eax,%ebx
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	0f 88 04 01 00 00    	js     802085 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f87:	50                   	push   %eax
  801f88:	e8 ee f0 ff ff       	call   80107b <fd_alloc>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 88 db 00 00 00    	js     802075 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	68 07 04 00 00       	push   $0x407
  801fa2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa5:	6a 00                	push   $0x0
  801fa7:	e8 76 ee ff ff       	call   800e22 <sys_page_alloc>
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	0f 88 bc 00 00 00    	js     802075 <pipe+0x131>
	va = fd2data(fd0);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	e8 a0 f0 ff ff       	call   801064 <fd2data>
  801fc4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fc6:	83 c4 0c             	add    $0xc,%esp
  801fc9:	68 07 04 00 00       	push   $0x407
  801fce:	50                   	push   %eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	e8 4c ee ff ff       	call   800e22 <sys_page_alloc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	0f 88 82 00 00 00    	js     802065 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe3:	83 ec 0c             	sub    $0xc,%esp
  801fe6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe9:	e8 76 f0 ff ff       	call   801064 <fd2data>
  801fee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ff5:	50                   	push   %eax
  801ff6:	6a 00                	push   $0x0
  801ff8:	56                   	push   %esi
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 65 ee ff ff       	call   800e65 <sys_page_map>
  802000:	89 c3                	mov    %eax,%ebx
  802002:	83 c4 20             	add    $0x20,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 4e                	js     802057 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802009:	a1 20 30 80 00       	mov    0x803020,%eax
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802016:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80201d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802020:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802025:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	ff 75 f4             	pushl  -0xc(%ebp)
  802032:	e8 1d f0 ff ff       	call   801054 <fd2num>
  802037:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80203c:	83 c4 04             	add    $0x4,%esp
  80203f:	ff 75 f0             	pushl  -0x10(%ebp)
  802042:	e8 0d f0 ff ff       	call   801054 <fd2num>
  802047:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80204a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	bb 00 00 00 00       	mov    $0x0,%ebx
  802055:	eb 2e                	jmp    802085 <pipe+0x141>
	sys_page_unmap(0, va);
  802057:	83 ec 08             	sub    $0x8,%esp
  80205a:	56                   	push   %esi
  80205b:	6a 00                	push   $0x0
  80205d:	e8 45 ee ff ff       	call   800ea7 <sys_page_unmap>
  802062:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802065:	83 ec 08             	sub    $0x8,%esp
  802068:	ff 75 f0             	pushl  -0x10(%ebp)
  80206b:	6a 00                	push   $0x0
  80206d:	e8 35 ee ff ff       	call   800ea7 <sys_page_unmap>
  802072:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802075:	83 ec 08             	sub    $0x8,%esp
  802078:	ff 75 f4             	pushl  -0xc(%ebp)
  80207b:	6a 00                	push   $0x0
  80207d:	e8 25 ee ff ff       	call   800ea7 <sys_page_unmap>
  802082:	83 c4 10             	add    $0x10,%esp
}
  802085:	89 d8                	mov    %ebx,%eax
  802087:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208a:	5b                   	pop    %ebx
  80208b:	5e                   	pop    %esi
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <pipeisclosed>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802094:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802097:	50                   	push   %eax
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	e8 2d f0 ff ff       	call   8010cd <fd_lookup>
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 18                	js     8020bf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ad:	e8 b2 ef ff ff       	call   801064 <fd2data>
	return _pipeisclosed(fd, p);
  8020b2:	89 c2                	mov    %eax,%edx
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	e8 2f fd ff ff       	call   801deb <_pipeisclosed>
  8020bc:	83 c4 10             	add    $0x10,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	c3                   	ret    

008020c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020cd:	68 07 2c 80 00       	push   $0x802c07
  8020d2:	ff 75 0c             	pushl  0xc(%ebp)
  8020d5:	e8 56 e9 ff ff       	call   800a30 <strcpy>
	return 0;
}
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <devcons_write>:
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	57                   	push   %edi
  8020e5:	56                   	push   %esi
  8020e6:	53                   	push   %ebx
  8020e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020fb:	73 31                	jae    80212e <devcons_write+0x4d>
		m = n - tot;
  8020fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802100:	29 f3                	sub    %esi,%ebx
  802102:	83 fb 7f             	cmp    $0x7f,%ebx
  802105:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80210a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	53                   	push   %ebx
  802111:	89 f0                	mov    %esi,%eax
  802113:	03 45 0c             	add    0xc(%ebp),%eax
  802116:	50                   	push   %eax
  802117:	57                   	push   %edi
  802118:	e8 a1 ea ff ff       	call   800bbe <memmove>
		sys_cputs(buf, m);
  80211d:	83 c4 08             	add    $0x8,%esp
  802120:	53                   	push   %ebx
  802121:	57                   	push   %edi
  802122:	e8 3f ec ff ff       	call   800d66 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802127:	01 de                	add    %ebx,%esi
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	eb ca                	jmp    8020f8 <devcons_write+0x17>
}
  80212e:	89 f0                	mov    %esi,%eax
  802130:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <devcons_read>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 08             	sub    $0x8,%esp
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802147:	74 21                	je     80216a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802149:	e8 36 ec ff ff       	call   800d84 <sys_cgetc>
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 07                	jne    802159 <devcons_read+0x21>
		sys_yield();
  802152:	e8 ac ec ff ff       	call   800e03 <sys_yield>
  802157:	eb f0                	jmp    802149 <devcons_read+0x11>
	if (c < 0)
  802159:	78 0f                	js     80216a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80215b:	83 f8 04             	cmp    $0x4,%eax
  80215e:	74 0c                	je     80216c <devcons_read+0x34>
	*(char*)vbuf = c;
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	88 02                	mov    %al,(%edx)
	return 1;
  802165:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    
		return 0;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	eb f7                	jmp    80216a <devcons_read+0x32>

00802173 <cputchar>:
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80217f:	6a 01                	push   $0x1
  802181:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802184:	50                   	push   %eax
  802185:	e8 dc eb ff ff       	call   800d66 <sys_cputs>
}
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <getchar>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802195:	6a 01                	push   $0x1
  802197:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80219a:	50                   	push   %eax
  80219b:	6a 00                	push   $0x0
  80219d:	e8 96 f1 ff ff       	call   801338 <read>
	if (r < 0)
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	78 06                	js     8021af <getchar+0x20>
	if (r < 1)
  8021a9:	74 06                	je     8021b1 <getchar+0x22>
	return c;
  8021ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    
		return -E_EOF;
  8021b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021b6:	eb f7                	jmp    8021af <getchar+0x20>

008021b8 <iscons>:
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c1:	50                   	push   %eax
  8021c2:	ff 75 08             	pushl  0x8(%ebp)
  8021c5:	e8 03 ef ff ff       	call   8010cd <fd_lookup>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 11                	js     8021e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021da:	39 10                	cmp    %edx,(%eax)
  8021dc:	0f 94 c0             	sete   %al
  8021df:	0f b6 c0             	movzbl %al,%eax
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <opencons>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ed:	50                   	push   %eax
  8021ee:	e8 88 ee ff ff       	call   80107b <fd_alloc>
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 3a                	js     802234 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 07 04 00 00       	push   $0x407
  802202:	ff 75 f4             	pushl  -0xc(%ebp)
  802205:	6a 00                	push   $0x0
  802207:	e8 16 ec ff ff       	call   800e22 <sys_page_alloc>
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 21                	js     802234 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80221c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	50                   	push   %eax
  80222c:	e8 23 ee ff ff       	call   801054 <fd2num>
  802231:	83 c4 10             	add    $0x10,%esp
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	56                   	push   %esi
  80223a:	53                   	push   %ebx
  80223b:	8b 75 08             	mov    0x8(%ebp),%esi
  80223e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802241:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802244:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802246:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80224b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80224e:	83 ec 0c             	sub    $0xc,%esp
  802251:	50                   	push   %eax
  802252:	e8 7b ed ff ff       	call   800fd2 <sys_ipc_recv>
	if(ret < 0){
  802257:	83 c4 10             	add    $0x10,%esp
  80225a:	85 c0                	test   %eax,%eax
  80225c:	78 2b                	js     802289 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80225e:	85 f6                	test   %esi,%esi
  802260:	74 0a                	je     80226c <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802262:	a1 04 40 80 00       	mov    0x804004,%eax
  802267:	8b 40 74             	mov    0x74(%eax),%eax
  80226a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80226c:	85 db                	test   %ebx,%ebx
  80226e:	74 0a                	je     80227a <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802270:	a1 04 40 80 00       	mov    0x804004,%eax
  802275:	8b 40 78             	mov    0x78(%eax),%eax
  802278:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80227a:	a1 04 40 80 00       	mov    0x804004,%eax
  80227f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802282:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802285:	5b                   	pop    %ebx
  802286:	5e                   	pop    %esi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    
		if(from_env_store)
  802289:	85 f6                	test   %esi,%esi
  80228b:	74 06                	je     802293 <ipc_recv+0x5d>
			*from_env_store = 0;
  80228d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802293:	85 db                	test   %ebx,%ebx
  802295:	74 eb                	je     802282 <ipc_recv+0x4c>
			*perm_store = 0;
  802297:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80229d:	eb e3                	jmp    802282 <ipc_recv+0x4c>

0080229f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	57                   	push   %edi
  8022a3:	56                   	push   %esi
  8022a4:	53                   	push   %ebx
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022b1:	85 db                	test   %ebx,%ebx
  8022b3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022b8:	0f 44 d8             	cmove  %eax,%ebx
  8022bb:	eb 05                	jmp    8022c2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022bd:	e8 41 eb ff ff       	call   800e03 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022c2:	ff 75 14             	pushl  0x14(%ebp)
  8022c5:	53                   	push   %ebx
  8022c6:	56                   	push   %esi
  8022c7:	57                   	push   %edi
  8022c8:	e8 e2 ec ff ff       	call   800faf <sys_ipc_try_send>
  8022cd:	83 c4 10             	add    $0x10,%esp
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	74 1b                	je     8022ef <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022d4:	79 e7                	jns    8022bd <ipc_send+0x1e>
  8022d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d9:	74 e2                	je     8022bd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 13 2c 80 00       	push   $0x802c13
  8022e3:	6a 49                	push   $0x49
  8022e5:	68 28 2c 80 00       	push   $0x802c28
  8022ea:	e8 ec de ff ff       	call   8001db <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f2:	5b                   	pop    %ebx
  8022f3:	5e                   	pop    %esi
  8022f4:	5f                   	pop    %edi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    

008022f7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802302:	89 c2                	mov    %eax,%edx
  802304:	c1 e2 07             	shl    $0x7,%edx
  802307:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80230d:	8b 52 50             	mov    0x50(%edx),%edx
  802310:	39 ca                	cmp    %ecx,%edx
  802312:	74 11                	je     802325 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802314:	83 c0 01             	add    $0x1,%eax
  802317:	3d 00 04 00 00       	cmp    $0x400,%eax
  80231c:	75 e4                	jne    802302 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	eb 0b                	jmp    802330 <ipc_find_env+0x39>
			return envs[i].env_id;
  802325:	c1 e0 07             	shl    $0x7,%eax
  802328:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80232d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802330:	5d                   	pop    %ebp
  802331:	c3                   	ret    

00802332 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802338:	89 d0                	mov    %edx,%eax
  80233a:	c1 e8 16             	shr    $0x16,%eax
  80233d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802349:	f6 c1 01             	test   $0x1,%cl
  80234c:	74 1d                	je     80236b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80234e:	c1 ea 0c             	shr    $0xc,%edx
  802351:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802358:	f6 c2 01             	test   $0x1,%dl
  80235b:	74 0e                	je     80236b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80235d:	c1 ea 0c             	shr    $0xc,%edx
  802360:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802367:	ef 
  802368:	0f b7 c0             	movzwl %ax,%eax
}
  80236b:	5d                   	pop    %ebp
  80236c:	c3                   	ret    
  80236d:	66 90                	xchg   %ax,%ax
  80236f:	90                   	nop

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80237b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80237f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802383:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802387:	85 d2                	test   %edx,%edx
  802389:	75 4d                	jne    8023d8 <__udivdi3+0x68>
  80238b:	39 f3                	cmp    %esi,%ebx
  80238d:	76 19                	jbe    8023a8 <__udivdi3+0x38>
  80238f:	31 ff                	xor    %edi,%edi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f2                	mov    %esi,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	89 d9                	mov    %ebx,%ecx
  8023aa:	85 db                	test   %ebx,%ebx
  8023ac:	75 0b                	jne    8023b9 <__udivdi3+0x49>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f3                	div    %ebx
  8023b7:	89 c1                	mov    %eax,%ecx
  8023b9:	31 d2                	xor    %edx,%edx
  8023bb:	89 f0                	mov    %esi,%eax
  8023bd:	f7 f1                	div    %ecx
  8023bf:	89 c6                	mov    %eax,%esi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f7                	mov    %esi,%edi
  8023c5:	f7 f1                	div    %ecx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	77 1c                	ja     8023f8 <__udivdi3+0x88>
  8023dc:	0f bd fa             	bsr    %edx,%edi
  8023df:	83 f7 1f             	xor    $0x1f,%edi
  8023e2:	75 2c                	jne    802410 <__udivdi3+0xa0>
  8023e4:	39 f2                	cmp    %esi,%edx
  8023e6:	72 06                	jb     8023ee <__udivdi3+0x7e>
  8023e8:	31 c0                	xor    %eax,%eax
  8023ea:	39 eb                	cmp    %ebp,%ebx
  8023ec:	77 a9                	ja     802397 <__udivdi3+0x27>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	eb a2                	jmp    802397 <__udivdi3+0x27>
  8023f5:	8d 76 00             	lea    0x0(%esi),%esi
  8023f8:	31 ff                	xor    %edi,%edi
  8023fa:	31 c0                	xor    %eax,%eax
  8023fc:	89 fa                	mov    %edi,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 f9                	mov    %edi,%ecx
  802412:	b8 20 00 00 00       	mov    $0x20,%eax
  802417:	29 f8                	sub    %edi,%eax
  802419:	d3 e2                	shl    %cl,%edx
  80241b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80241f:	89 c1                	mov    %eax,%ecx
  802421:	89 da                	mov    %ebx,%edx
  802423:	d3 ea                	shr    %cl,%edx
  802425:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802429:	09 d1                	or     %edx,%ecx
  80242b:	89 f2                	mov    %esi,%edx
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 f9                	mov    %edi,%ecx
  802433:	d3 e3                	shl    %cl,%ebx
  802435:	89 c1                	mov    %eax,%ecx
  802437:	d3 ea                	shr    %cl,%edx
  802439:	89 f9                	mov    %edi,%ecx
  80243b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80243f:	89 eb                	mov    %ebp,%ebx
  802441:	d3 e6                	shl    %cl,%esi
  802443:	89 c1                	mov    %eax,%ecx
  802445:	d3 eb                	shr    %cl,%ebx
  802447:	09 de                	or     %ebx,%esi
  802449:	89 f0                	mov    %esi,%eax
  80244b:	f7 74 24 08          	divl   0x8(%esp)
  80244f:	89 d6                	mov    %edx,%esi
  802451:	89 c3                	mov    %eax,%ebx
  802453:	f7 64 24 0c          	mull   0xc(%esp)
  802457:	39 d6                	cmp    %edx,%esi
  802459:	72 15                	jb     802470 <__udivdi3+0x100>
  80245b:	89 f9                	mov    %edi,%ecx
  80245d:	d3 e5                	shl    %cl,%ebp
  80245f:	39 c5                	cmp    %eax,%ebp
  802461:	73 04                	jae    802467 <__udivdi3+0xf7>
  802463:	39 d6                	cmp    %edx,%esi
  802465:	74 09                	je     802470 <__udivdi3+0x100>
  802467:	89 d8                	mov    %ebx,%eax
  802469:	31 ff                	xor    %edi,%edi
  80246b:	e9 27 ff ff ff       	jmp    802397 <__udivdi3+0x27>
  802470:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802473:	31 ff                	xor    %edi,%edi
  802475:	e9 1d ff ff ff       	jmp    802397 <__udivdi3+0x27>
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80248b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80248f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802493:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802497:	89 da                	mov    %ebx,%edx
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 43                	jne    8024e0 <__umoddi3+0x60>
  80249d:	39 df                	cmp    %ebx,%edi
  80249f:	76 17                	jbe    8024b8 <__umoddi3+0x38>
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	f7 f7                	div    %edi
  8024a5:	89 d0                	mov    %edx,%eax
  8024a7:	31 d2                	xor    %edx,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 fd                	mov    %edi,%ebp
  8024ba:	85 ff                	test   %edi,%edi
  8024bc:	75 0b                	jne    8024c9 <__umoddi3+0x49>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f7                	div    %edi
  8024c7:	89 c5                	mov    %eax,%ebp
  8024c9:	89 d8                	mov    %ebx,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	f7 f5                	div    %ebp
  8024cf:	89 f0                	mov    %esi,%eax
  8024d1:	f7 f5                	div    %ebp
  8024d3:	89 d0                	mov    %edx,%eax
  8024d5:	eb d0                	jmp    8024a7 <__umoddi3+0x27>
  8024d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	89 f1                	mov    %esi,%ecx
  8024e2:	39 d8                	cmp    %ebx,%eax
  8024e4:	76 0a                	jbe    8024f0 <__umoddi3+0x70>
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	83 c4 1c             	add    $0x1c,%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5f                   	pop    %edi
  8024ee:	5d                   	pop    %ebp
  8024ef:	c3                   	ret    
  8024f0:	0f bd e8             	bsr    %eax,%ebp
  8024f3:	83 f5 1f             	xor    $0x1f,%ebp
  8024f6:	75 20                	jne    802518 <__umoddi3+0x98>
  8024f8:	39 d8                	cmp    %ebx,%eax
  8024fa:	0f 82 b0 00 00 00    	jb     8025b0 <__umoddi3+0x130>
  802500:	39 f7                	cmp    %esi,%edi
  802502:	0f 86 a8 00 00 00    	jbe    8025b0 <__umoddi3+0x130>
  802508:	89 c8                	mov    %ecx,%eax
  80250a:	83 c4 1c             	add    $0x1c,%esp
  80250d:	5b                   	pop    %ebx
  80250e:	5e                   	pop    %esi
  80250f:	5f                   	pop    %edi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	ba 20 00 00 00       	mov    $0x20,%edx
  80251f:	29 ea                	sub    %ebp,%edx
  802521:	d3 e0                	shl    %cl,%eax
  802523:	89 44 24 08          	mov    %eax,0x8(%esp)
  802527:	89 d1                	mov    %edx,%ecx
  802529:	89 f8                	mov    %edi,%eax
  80252b:	d3 e8                	shr    %cl,%eax
  80252d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802531:	89 54 24 04          	mov    %edx,0x4(%esp)
  802535:	8b 54 24 04          	mov    0x4(%esp),%edx
  802539:	09 c1                	or     %eax,%ecx
  80253b:	89 d8                	mov    %ebx,%eax
  80253d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802541:	89 e9                	mov    %ebp,%ecx
  802543:	d3 e7                	shl    %cl,%edi
  802545:	89 d1                	mov    %edx,%ecx
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	d3 e3                	shl    %cl,%ebx
  802551:	89 c7                	mov    %eax,%edi
  802553:	89 d1                	mov    %edx,%ecx
  802555:	89 f0                	mov    %esi,%eax
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 fa                	mov    %edi,%edx
  80255d:	d3 e6                	shl    %cl,%esi
  80255f:	09 d8                	or     %ebx,%eax
  802561:	f7 74 24 08          	divl   0x8(%esp)
  802565:	89 d1                	mov    %edx,%ecx
  802567:	89 f3                	mov    %esi,%ebx
  802569:	f7 64 24 0c          	mull   0xc(%esp)
  80256d:	89 c6                	mov    %eax,%esi
  80256f:	89 d7                	mov    %edx,%edi
  802571:	39 d1                	cmp    %edx,%ecx
  802573:	72 06                	jb     80257b <__umoddi3+0xfb>
  802575:	75 10                	jne    802587 <__umoddi3+0x107>
  802577:	39 c3                	cmp    %eax,%ebx
  802579:	73 0c                	jae    802587 <__umoddi3+0x107>
  80257b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80257f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802583:	89 d7                	mov    %edx,%edi
  802585:	89 c6                	mov    %eax,%esi
  802587:	89 ca                	mov    %ecx,%edx
  802589:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258e:	29 f3                	sub    %esi,%ebx
  802590:	19 fa                	sbb    %edi,%edx
  802592:	89 d0                	mov    %edx,%eax
  802594:	d3 e0                	shl    %cl,%eax
  802596:	89 e9                	mov    %ebp,%ecx
  802598:	d3 eb                	shr    %cl,%ebx
  80259a:	d3 ea                	shr    %cl,%edx
  80259c:	09 d8                	or     %ebx,%eax
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 da                	mov    %ebx,%edx
  8025b2:	29 fe                	sub    %edi,%esi
  8025b4:	19 c2                	sbb    %eax,%edx
  8025b6:	89 f1                	mov    %esi,%ecx
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	e9 4b ff ff ff       	jmp    80250a <__umoddi3+0x8a>
