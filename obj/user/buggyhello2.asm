
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  800039:	68 00 00 10 00       	push   $0x100000
  80003e:	ff 35 00 30 80 00    	pushl  0x803000
  800044:	e8 3e 0c 00 00       	call   800c87 <sys_cputs>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800057:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80005e:	00 00 00 
	envid_t find = sys_getenvid();
  800061:	e8 9f 0c 00 00       	call   800d05 <sys_getenvid>
  800066:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80006c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800071:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800076:	bf 01 00 00 00       	mov    $0x1,%edi
  80007b:	eb 0b                	jmp    800088 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80007d:	83 c2 01             	add    $0x1,%edx
  800080:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800086:	74 23                	je     8000ab <libmain+0x5d>
		if(envs[i].env_id == find)
  800088:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80008e:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800094:	8b 49 48             	mov    0x48(%ecx),%ecx
  800097:	39 c1                	cmp    %eax,%ecx
  800099:	75 e2                	jne    80007d <libmain+0x2f>
  80009b:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000a1:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a7:	89 fe                	mov    %edi,%esi
  8000a9:	eb d2                	jmp    80007d <libmain+0x2f>
  8000ab:	89 f0                	mov    %esi,%eax
  8000ad:	84 c0                	test   %al,%al
  8000af:	74 06                	je     8000b7 <libmain+0x69>
  8000b1:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bb:	7e 0a                	jle    8000c7 <libmain+0x79>
		binaryname = argv[0];
  8000bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c0:	8b 00                	mov    (%eax),%eax
  8000c2:	a3 04 30 80 00       	mov    %eax,0x803004

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8000cc:	8b 40 48             	mov    0x48(%eax),%eax
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	50                   	push   %eax
  8000d3:	68 8e 25 80 00       	push   $0x80258e
  8000d8:	e8 15 01 00 00       	call   8001f2 <cprintf>
	cprintf("before umain\n");
  8000dd:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000e4:	e8 09 01 00 00       	call   8001f2 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e9:	83 c4 08             	add    $0x8,%esp
  8000ec:	ff 75 0c             	pushl  0xc(%ebp)
  8000ef:	ff 75 08             	pushl  0x8(%ebp)
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f7:	c7 04 24 ba 25 80 00 	movl   $0x8025ba,(%esp)
  8000fe:	e8 ef 00 00 00       	call   8001f2 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800103:	a1 08 40 80 00       	mov    0x804008,%eax
  800108:	8b 40 48             	mov    0x48(%eax),%eax
  80010b:	83 c4 08             	add    $0x8,%esp
  80010e:	50                   	push   %eax
  80010f:	68 c7 25 80 00       	push   $0x8025c7
  800114:	e8 d9 00 00 00       	call   8001f2 <cprintf>
	// exit gracefully
	exit();
  800119:	e8 0b 00 00 00       	call   800129 <exit>
}
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5f                   	pop    %edi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80012f:	a1 08 40 80 00       	mov    0x804008,%eax
  800134:	8b 40 48             	mov    0x48(%eax),%eax
  800137:	68 f4 25 80 00       	push   $0x8025f4
  80013c:	50                   	push   %eax
  80013d:	68 e6 25 80 00       	push   $0x8025e6
  800142:	e8 ab 00 00 00       	call   8001f2 <cprintf>
	close_all();
  800147:	e8 c4 10 00 00       	call   801210 <close_all>
	sys_env_destroy(0);
  80014c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800153:	e8 6c 0b 00 00       	call   800cc4 <sys_env_destroy>
}
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	53                   	push   %ebx
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800167:	8b 13                	mov    (%ebx),%edx
  800169:	8d 42 01             	lea    0x1(%edx),%eax
  80016c:	89 03                	mov    %eax,(%ebx)
  80016e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800171:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800175:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017a:	74 09                	je     800185 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800183:	c9                   	leave  
  800184:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	68 ff 00 00 00       	push   $0xff
  80018d:	8d 43 08             	lea    0x8(%ebx),%eax
  800190:	50                   	push   %eax
  800191:	e8 f1 0a 00 00       	call   800c87 <sys_cputs>
		b->idx = 0;
  800196:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	eb db                	jmp    80017c <putch+0x1f>

008001a1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001aa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b1:	00 00 00 
	b.cnt = 0;
  8001b4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001be:	ff 75 0c             	pushl  0xc(%ebp)
  8001c1:	ff 75 08             	pushl  0x8(%ebp)
  8001c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	68 5d 01 80 00       	push   $0x80015d
  8001d0:	e8 4a 01 00 00       	call   80031f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d5:	83 c4 08             	add    $0x8,%esp
  8001d8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001de:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	e8 9d 0a 00 00       	call   800c87 <sys_cputs>

	return b.cnt;
}
  8001ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fb:	50                   	push   %eax
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	e8 9d ff ff ff       	call   8001a1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 1c             	sub    $0x1c,%esp
  80020f:	89 c6                	mov    %eax,%esi
  800211:	89 d7                	mov    %edx,%edi
  800213:	8b 45 08             	mov    0x8(%ebp),%eax
  800216:	8b 55 0c             	mov    0xc(%ebp),%edx
  800219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021f:	8b 45 10             	mov    0x10(%ebp),%eax
  800222:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800225:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800229:	74 2c                	je     800257 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80022b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800235:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800238:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023b:	39 c2                	cmp    %eax,%edx
  80023d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800240:	73 43                	jae    800285 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800242:	83 eb 01             	sub    $0x1,%ebx
  800245:	85 db                	test   %ebx,%ebx
  800247:	7e 6c                	jle    8002b5 <printnum+0xaf>
				putch(padc, putdat);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	57                   	push   %edi
  80024d:	ff 75 18             	pushl  0x18(%ebp)
  800250:	ff d6                	call   *%esi
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	eb eb                	jmp    800242 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	6a 20                	push   $0x20
  80025c:	6a 00                	push   $0x0
  80025e:	50                   	push   %eax
  80025f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800262:	ff 75 e0             	pushl  -0x20(%ebp)
  800265:	89 fa                	mov    %edi,%edx
  800267:	89 f0                	mov    %esi,%eax
  800269:	e8 98 ff ff ff       	call   800206 <printnum>
		while (--width > 0)
  80026e:	83 c4 20             	add    $0x20,%esp
  800271:	83 eb 01             	sub    $0x1,%ebx
  800274:	85 db                	test   %ebx,%ebx
  800276:	7e 65                	jle    8002dd <printnum+0xd7>
			putch(padc, putdat);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	57                   	push   %edi
  80027c:	6a 20                	push   $0x20
  80027e:	ff d6                	call   *%esi
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	eb ec                	jmp    800271 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	ff 75 18             	pushl  0x18(%ebp)
  80028b:	83 eb 01             	sub    $0x1,%ebx
  80028e:	53                   	push   %ebx
  80028f:	50                   	push   %eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029c:	ff 75 e0             	pushl  -0x20(%ebp)
  80029f:	e8 8c 20 00 00       	call   802330 <__udivdi3>
  8002a4:	83 c4 18             	add    $0x18,%esp
  8002a7:	52                   	push   %edx
  8002a8:	50                   	push   %eax
  8002a9:	89 fa                	mov    %edi,%edx
  8002ab:	89 f0                	mov    %esi,%eax
  8002ad:	e8 54 ff ff ff       	call   800206 <printnum>
  8002b2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	57                   	push   %edi
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c8:	e8 73 21 00 00       	call   802440 <__umoddi3>
  8002cd:	83 c4 14             	add    $0x14,%esp
  8002d0:	0f be 80 f9 25 80 00 	movsbl 0x8025f9(%eax),%eax
  8002d7:	50                   	push   %eax
  8002d8:	ff d6                	call   *%esi
  8002da:	83 c4 10             	add    $0x10,%esp
	}
}
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ef:	8b 10                	mov    (%eax),%edx
  8002f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f4:	73 0a                	jae    800300 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f9:	89 08                	mov    %ecx,(%eax)
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	88 02                	mov    %al,(%edx)
}
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <printfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800308:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030b:	50                   	push   %eax
  80030c:	ff 75 10             	pushl  0x10(%ebp)
  80030f:	ff 75 0c             	pushl  0xc(%ebp)
  800312:	ff 75 08             	pushl  0x8(%ebp)
  800315:	e8 05 00 00 00       	call   80031f <vprintfmt>
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <vprintfmt>:
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
  800325:	83 ec 3c             	sub    $0x3c,%esp
  800328:	8b 75 08             	mov    0x8(%ebp),%esi
  80032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800331:	e9 32 04 00 00       	jmp    800768 <vprintfmt+0x449>
		padc = ' ';
  800336:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80033a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800341:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800348:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800356:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80035d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8d 47 01             	lea    0x1(%edi),%eax
  800365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800368:	0f b6 17             	movzbl (%edi),%edx
  80036b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036e:	3c 55                	cmp    $0x55,%al
  800370:	0f 87 12 05 00 00    	ja     800888 <vprintfmt+0x569>
  800376:	0f b6 c0             	movzbl %al,%eax
  800379:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800383:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800387:	eb d9                	jmp    800362 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800390:	eb d0                	jmp    800362 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800392:	0f b6 d2             	movzbl %dl,%edx
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800398:	b8 00 00 00 00       	mov    $0x0,%eax
  80039d:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a0:	eb 03                	jmp    8003a5 <vprintfmt+0x86>
  8003a2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ac:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003af:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b2:	83 fe 09             	cmp    $0x9,%esi
  8003b5:	76 eb                	jbe    8003a2 <vprintfmt+0x83>
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bd:	eb 14                	jmp    8003d3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	8d 40 04             	lea    0x4(%eax),%eax
  8003cd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d7:	79 89                	jns    800362 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e6:	e9 77 ff ff ff       	jmp    800362 <vprintfmt+0x43>
  8003eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	0f 48 c1             	cmovs  %ecx,%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f9:	e9 64 ff ff ff       	jmp    800362 <vprintfmt+0x43>
  8003fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800401:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800408:	e9 55 ff ff ff       	jmp    800362 <vprintfmt+0x43>
			lflag++;
  80040d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800414:	e9 49 ff ff ff       	jmp    800362 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 30                	pushl  (%eax)
  800425:	ff d6                	call   *%esi
			break;
  800427:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042d:	e9 33 03 00 00       	jmp    800765 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	99                   	cltd   
  80043b:	31 d0                	xor    %edx,%eax
  80043d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043f:	83 f8 11             	cmp    $0x11,%eax
  800442:	7f 23                	jg     800467 <vprintfmt+0x148>
  800444:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  80044b:	85 d2                	test   %edx,%edx
  80044d:	74 18                	je     800467 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044f:	52                   	push   %edx
  800450:	68 5d 2a 80 00       	push   $0x802a5d
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 a6 fe ff ff       	call   800302 <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800462:	e9 fe 02 00 00       	jmp    800765 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800467:	50                   	push   %eax
  800468:	68 11 26 80 00       	push   $0x802611
  80046d:	53                   	push   %ebx
  80046e:	56                   	push   %esi
  80046f:	e8 8e fe ff ff       	call   800302 <printfmt>
  800474:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047a:	e9 e6 02 00 00       	jmp    800765 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	83 c0 04             	add    $0x4,%eax
  800485:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 0a 26 80 00       	mov    $0x80260a,%eax
  800494:	0f 45 c1             	cmovne %ecx,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80049a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049e:	7e 06                	jle    8004a6 <vprintfmt+0x187>
  8004a0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a4:	75 0d                	jne    8004b3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a9:	89 c7                	mov    %eax,%edi
  8004ab:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b1:	eb 53                	jmp    800506 <vprintfmt+0x1e7>
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b9:	50                   	push   %eax
  8004ba:	e8 71 04 00 00       	call   800930 <strnlen>
  8004bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c2:	29 c1                	sub    %eax,%ecx
  8004c4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004cc:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	eb 0f                	jmp    8004e4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004de:	83 ef 01             	sub    $0x1,%edi
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 ff                	test   %edi,%edi
  8004e6:	7f ed                	jg     8004d5 <vprintfmt+0x1b6>
  8004e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004eb:	85 c9                	test   %ecx,%ecx
  8004ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f2:	0f 49 c1             	cmovns %ecx,%eax
  8004f5:	29 c1                	sub    %eax,%ecx
  8004f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004fa:	eb aa                	jmp    8004a6 <vprintfmt+0x187>
					putch(ch, putdat);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	53                   	push   %ebx
  800500:	52                   	push   %edx
  800501:	ff d6                	call   *%esi
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800509:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050b:	83 c7 01             	add    $0x1,%edi
  80050e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800512:	0f be d0             	movsbl %al,%edx
  800515:	85 d2                	test   %edx,%edx
  800517:	74 4b                	je     800564 <vprintfmt+0x245>
  800519:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051d:	78 06                	js     800525 <vprintfmt+0x206>
  80051f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800523:	78 1e                	js     800543 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800525:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800529:	74 d1                	je     8004fc <vprintfmt+0x1dd>
  80052b:	0f be c0             	movsbl %al,%eax
  80052e:	83 e8 20             	sub    $0x20,%eax
  800531:	83 f8 5e             	cmp    $0x5e,%eax
  800534:	76 c6                	jbe    8004fc <vprintfmt+0x1dd>
					putch('?', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	53                   	push   %ebx
  80053a:	6a 3f                	push   $0x3f
  80053c:	ff d6                	call   *%esi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	eb c3                	jmp    800506 <vprintfmt+0x1e7>
  800543:	89 cf                	mov    %ecx,%edi
  800545:	eb 0e                	jmp    800555 <vprintfmt+0x236>
				putch(' ', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	6a 20                	push   $0x20
  80054d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054f:	83 ef 01             	sub    $0x1,%edi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	85 ff                	test   %edi,%edi
  800557:	7f ee                	jg     800547 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800559:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80055c:	89 45 14             	mov    %eax,0x14(%ebp)
  80055f:	e9 01 02 00 00       	jmp    800765 <vprintfmt+0x446>
  800564:	89 cf                	mov    %ecx,%edi
  800566:	eb ed                	jmp    800555 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80056b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800572:	e9 eb fd ff ff       	jmp    800362 <vprintfmt+0x43>
	if (lflag >= 2)
  800577:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80057b:	7f 21                	jg     80059e <vprintfmt+0x27f>
	else if (lflag)
  80057d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800581:	74 68                	je     8005eb <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058b:	89 c1                	mov    %eax,%ecx
  80058d:	c1 f9 1f             	sar    $0x1f,%ecx
  800590:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 04             	lea    0x4(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	eb 17                	jmp    8005b5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 50 04             	mov    0x4(%eax),%edx
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 08             	lea    0x8(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c5:	78 3f                	js     800606 <vprintfmt+0x2e7>
			base = 10;
  8005c7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005cc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d0:	0f 84 71 01 00 00    	je     800747 <vprintfmt+0x428>
				putch('+', putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 2b                	push   $0x2b
  8005dc:	ff d6                	call   *%esi
  8005de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	e9 5c 01 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f3:	89 c1                	mov    %eax,%ecx
  8005f5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 04             	lea    0x4(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
  800604:	eb af                	jmp    8005b5 <vprintfmt+0x296>
				putch('-', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	53                   	push   %ebx
  80060a:	6a 2d                	push   $0x2d
  80060c:	ff d6                	call   *%esi
				num = -(long long) num;
  80060e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800611:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800614:	f7 d8                	neg    %eax
  800616:	83 d2 00             	adc    $0x0,%edx
  800619:	f7 da                	neg    %edx
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
  800629:	e9 19 01 00 00       	jmp    800747 <vprintfmt+0x428>
	if (lflag >= 2)
  80062e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800632:	7f 29                	jg     80065d <vprintfmt+0x33e>
	else if (lflag)
  800634:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800638:	74 44                	je     80067e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
  800658:	e9 ea 00 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 50 04             	mov    0x4(%eax),%edx
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	e9 c9 00 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800697:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069c:	e9 a6 00 00 00       	jmp    800747 <vprintfmt+0x428>
			putch('0', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 30                	push   $0x30
  8006a7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b0:	7f 26                	jg     8006d8 <vprintfmt+0x3b9>
	else if (lflag)
  8006b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b6:	74 3e                	je     8006f6 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d6:	eb 6f                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 50 04             	mov    0x4(%eax),%edx
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f4:	eb 51                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800703:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070f:	b8 08 00 00 00       	mov    $0x8,%eax
  800714:	eb 31                	jmp    800747 <vprintfmt+0x428>
			putch('0', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 30                	push   $0x30
  80071c:	ff d6                	call   *%esi
			putch('x', putdat);
  80071e:	83 c4 08             	add    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 78                	push   $0x78
  800724:	ff d6                	call   *%esi
			num = (unsigned long long)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800736:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800742:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800747:	83 ec 0c             	sub    $0xc,%esp
  80074a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074e:	52                   	push   %edx
  80074f:	ff 75 e0             	pushl  -0x20(%ebp)
  800752:	50                   	push   %eax
  800753:	ff 75 dc             	pushl  -0x24(%ebp)
  800756:	ff 75 d8             	pushl  -0x28(%ebp)
  800759:	89 da                	mov    %ebx,%edx
  80075b:	89 f0                	mov    %esi,%eax
  80075d:	e8 a4 fa ff ff       	call   800206 <printnum>
			break;
  800762:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800768:	83 c7 01             	add    $0x1,%edi
  80076b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076f:	83 f8 25             	cmp    $0x25,%eax
  800772:	0f 84 be fb ff ff    	je     800336 <vprintfmt+0x17>
			if (ch == '\0')
  800778:	85 c0                	test   %eax,%eax
  80077a:	0f 84 28 01 00 00    	je     8008a8 <vprintfmt+0x589>
			putch(ch, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	50                   	push   %eax
  800785:	ff d6                	call   *%esi
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	eb dc                	jmp    800768 <vprintfmt+0x449>
	if (lflag >= 2)
  80078c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800790:	7f 26                	jg     8007b8 <vprintfmt+0x499>
	else if (lflag)
  800792:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800796:	74 41                	je     8007d9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 04             	lea    0x4(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b6:	eb 8f                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 40 08             	lea    0x8(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d4:	e9 6e ff ff ff       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8d 40 04             	lea    0x4(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f7:	e9 4b ff ff ff       	jmp    800747 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	83 c0 04             	add    $0x4,%eax
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	85 c0                	test   %eax,%eax
  80080c:	74 14                	je     800822 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080e:	8b 13                	mov    (%ebx),%edx
  800810:	83 fa 7f             	cmp    $0x7f,%edx
  800813:	7f 37                	jg     80084c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800815:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800817:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	e9 43 ff ff ff       	jmp    800765 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800822:	b8 0a 00 00 00       	mov    $0xa,%eax
  800827:	bf 2d 27 80 00       	mov    $0x80272d,%edi
							putch(ch, putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	50                   	push   %eax
  800831:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800833:	83 c7 01             	add    $0x1,%edi
  800836:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	85 c0                	test   %eax,%eax
  80083f:	75 eb                	jne    80082c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800841:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	e9 19 ff ff ff       	jmp    800765 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80084c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800853:	bf 65 27 80 00       	mov    $0x802765,%edi
							putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	50                   	push   %eax
  80085d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085f:	83 c7 01             	add    $0x1,%edi
  800862:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	85 c0                	test   %eax,%eax
  80086b:	75 eb                	jne    800858 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80086d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	e9 ed fe ff ff       	jmp    800765 <vprintfmt+0x446>
			putch(ch, putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	6a 25                	push   $0x25
  80087e:	ff d6                	call   *%esi
			break;
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	e9 dd fe ff ff       	jmp    800765 <vprintfmt+0x446>
			putch('%', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 25                	push   $0x25
  80088e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	89 f8                	mov    %edi,%eax
  800895:	eb 03                	jmp    80089a <vprintfmt+0x57b>
  800897:	83 e8 01             	sub    $0x1,%eax
  80089a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089e:	75 f7                	jne    800897 <vprintfmt+0x578>
  8008a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a3:	e9 bd fe ff ff       	jmp    800765 <vprintfmt+0x446>
}
  8008a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 18             	sub    $0x18,%esp
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	74 26                	je     8008f7 <vsnprintf+0x47>
  8008d1:	85 d2                	test   %edx,%edx
  8008d3:	7e 22                	jle    8008f7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d5:	ff 75 14             	pushl  0x14(%ebp)
  8008d8:	ff 75 10             	pushl  0x10(%ebp)
  8008db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	68 e5 02 80 00       	push   $0x8002e5
  8008e4:	e8 36 fa ff ff       	call   80031f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    
		return -E_INVAL;
  8008f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fc:	eb f7                	jmp    8008f5 <vsnprintf+0x45>

008008fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800904:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800907:	50                   	push   %eax
  800908:	ff 75 10             	pushl  0x10(%ebp)
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 9a ff ff ff       	call   8008b0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	74 05                	je     80092e <strlen+0x16>
		n++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	eb f5                	jmp    800923 <strlen+0xb>
	return n;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800939:	ba 00 00 00 00       	mov    $0x0,%edx
  80093e:	39 c2                	cmp    %eax,%edx
  800940:	74 0d                	je     80094f <strnlen+0x1f>
  800942:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800946:	74 05                	je     80094d <strnlen+0x1d>
		n++;
  800948:	83 c2 01             	add    $0x1,%edx
  80094b:	eb f1                	jmp    80093e <strnlen+0xe>
  80094d:	89 d0                	mov    %edx,%eax
	return n;
}
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800964:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	84 c9                	test   %cl,%cl
  80096c:	75 f2                	jne    800960 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096e:	5b                   	pop    %ebx
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	53                   	push   %ebx
  800975:	83 ec 10             	sub    $0x10,%esp
  800978:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097b:	53                   	push   %ebx
  80097c:	e8 97 ff ff ff       	call   800918 <strlen>
  800981:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	01 d8                	add    %ebx,%eax
  800989:	50                   	push   %eax
  80098a:	e8 c2 ff ff ff       	call   800951 <strcpy>
	return dst;
}
  80098f:	89 d8                	mov    %ebx,%eax
  800991:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800994:	c9                   	leave  
  800995:	c3                   	ret    

00800996 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a1:	89 c6                	mov    %eax,%esi
  8009a3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a6:	89 c2                	mov    %eax,%edx
  8009a8:	39 f2                	cmp    %esi,%edx
  8009aa:	74 11                	je     8009bd <strncpy+0x27>
		*dst++ = *src;
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	0f b6 19             	movzbl (%ecx),%ebx
  8009b2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b5:	80 fb 01             	cmp    $0x1,%bl
  8009b8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009bb:	eb eb                	jmp    8009a8 <strncpy+0x12>
	}
	return ret;
}
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	56                   	push   %esi
  8009c5:	53                   	push   %ebx
  8009c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d1:	85 d2                	test   %edx,%edx
  8009d3:	74 21                	je     8009f6 <strlcpy+0x35>
  8009d5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009db:	39 c2                	cmp    %eax,%edx
  8009dd:	74 14                	je     8009f3 <strlcpy+0x32>
  8009df:	0f b6 19             	movzbl (%ecx),%ebx
  8009e2:	84 db                	test   %bl,%bl
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x30>
			*dst++ = *src++;
  8009e6:	83 c1 01             	add    $0x1,%ecx
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ef:	eb ea                	jmp    8009db <strlcpy+0x1a>
  8009f1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f6:	29 f0                	sub    %esi,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a05:	0f b6 01             	movzbl (%ecx),%eax
  800a08:	84 c0                	test   %al,%al
  800a0a:	74 0c                	je     800a18 <strcmp+0x1c>
  800a0c:	3a 02                	cmp    (%edx),%al
  800a0e:	75 08                	jne    800a18 <strcmp+0x1c>
		p++, q++;
  800a10:	83 c1 01             	add    $0x1,%ecx
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	eb ed                	jmp    800a05 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 c3                	mov    %eax,%ebx
  800a2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a31:	eb 06                	jmp    800a39 <strncmp+0x17>
		n--, p++, q++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a39:	39 d8                	cmp    %ebx,%eax
  800a3b:	74 16                	je     800a53 <strncmp+0x31>
  800a3d:	0f b6 08             	movzbl (%eax),%ecx
  800a40:	84 c9                	test   %cl,%cl
  800a42:	74 04                	je     800a48 <strncmp+0x26>
  800a44:	3a 0a                	cmp    (%edx),%cl
  800a46:	74 eb                	je     800a33 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
}
  800a50:	5b                   	pop    %ebx
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    
		return 0;
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
  800a58:	eb f6                	jmp    800a50 <strncmp+0x2e>

00800a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	0f b6 10             	movzbl (%eax),%edx
  800a67:	84 d2                	test   %dl,%dl
  800a69:	74 09                	je     800a74 <strchr+0x1a>
		if (*s == c)
  800a6b:	38 ca                	cmp    %cl,%dl
  800a6d:	74 0a                	je     800a79 <strchr+0x1f>
	for (; *s; s++)
  800a6f:	83 c0 01             	add    $0x1,%eax
  800a72:	eb f0                	jmp    800a64 <strchr+0xa>
			return (char *) s;
	return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a88:	38 ca                	cmp    %cl,%dl
  800a8a:	74 09                	je     800a95 <strfind+0x1a>
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	74 05                	je     800a95 <strfind+0x1a>
	for (; *s; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	eb f0                	jmp    800a85 <strfind+0xa>
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa3:	85 c9                	test   %ecx,%ecx
  800aa5:	74 31                	je     800ad8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa7:	89 f8                	mov    %edi,%eax
  800aa9:	09 c8                	or     %ecx,%eax
  800aab:	a8 03                	test   $0x3,%al
  800aad:	75 23                	jne    800ad2 <memset+0x3b>
		c &= 0xFF;
  800aaf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab3:	89 d3                	mov    %edx,%ebx
  800ab5:	c1 e3 08             	shl    $0x8,%ebx
  800ab8:	89 d0                	mov    %edx,%eax
  800aba:	c1 e0 18             	shl    $0x18,%eax
  800abd:	89 d6                	mov    %edx,%esi
  800abf:	c1 e6 10             	shl    $0x10,%esi
  800ac2:	09 f0                	or     %esi,%eax
  800ac4:	09 c2                	or     %eax,%edx
  800ac6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	fc                   	cld    
  800ace:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad0:	eb 06                	jmp    800ad8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad5:	fc                   	cld    
  800ad6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad8:	89 f8                	mov    %edi,%eax
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5f                   	pop    %edi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	57                   	push   %edi
  800ae3:	56                   	push   %esi
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aed:	39 c6                	cmp    %eax,%esi
  800aef:	73 32                	jae    800b23 <memmove+0x44>
  800af1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af4:	39 c2                	cmp    %eax,%edx
  800af6:	76 2b                	jbe    800b23 <memmove+0x44>
		s += n;
		d += n;
  800af8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afb:	89 fe                	mov    %edi,%esi
  800afd:	09 ce                	or     %ecx,%esi
  800aff:	09 d6                	or     %edx,%esi
  800b01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b07:	75 0e                	jne    800b17 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b09:	83 ef 04             	sub    $0x4,%edi
  800b0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b12:	fd                   	std    
  800b13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b15:	eb 09                	jmp    800b20 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b17:	83 ef 01             	sub    $0x1,%edi
  800b1a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1d:	fd                   	std    
  800b1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b20:	fc                   	cld    
  800b21:	eb 1a                	jmp    800b3d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b23:	89 c2                	mov    %eax,%edx
  800b25:	09 ca                	or     %ecx,%edx
  800b27:	09 f2                	or     %esi,%edx
  800b29:	f6 c2 03             	test   $0x3,%dl
  800b2c:	75 0a                	jne    800b38 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b31:	89 c7                	mov    %eax,%edi
  800b33:	fc                   	cld    
  800b34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b36:	eb 05                	jmp    800b3d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b38:	89 c7                	mov    %eax,%edi
  800b3a:	fc                   	cld    
  800b3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b47:	ff 75 10             	pushl  0x10(%ebp)
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	ff 75 08             	pushl  0x8(%ebp)
  800b50:	e8 8a ff ff ff       	call   800adf <memmove>
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b62:	89 c6                	mov    %eax,%esi
  800b64:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b67:	39 f0                	cmp    %esi,%eax
  800b69:	74 1c                	je     800b87 <memcmp+0x30>
		if (*s1 != *s2)
  800b6b:	0f b6 08             	movzbl (%eax),%ecx
  800b6e:	0f b6 1a             	movzbl (%edx),%ebx
  800b71:	38 d9                	cmp    %bl,%cl
  800b73:	75 08                	jne    800b7d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	eb ea                	jmp    800b67 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b7d:	0f b6 c1             	movzbl %cl,%eax
  800b80:	0f b6 db             	movzbl %bl,%ebx
  800b83:	29 d8                	sub    %ebx,%eax
  800b85:	eb 05                	jmp    800b8c <memcmp+0x35>
	}

	return 0;
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b99:	89 c2                	mov    %eax,%edx
  800b9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9e:	39 d0                	cmp    %edx,%eax
  800ba0:	73 09                	jae    800bab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba2:	38 08                	cmp    %cl,(%eax)
  800ba4:	74 05                	je     800bab <memfind+0x1b>
	for (; s < ends; s++)
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	eb f3                	jmp    800b9e <memfind+0xe>
			break;
	return (void *) s;
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
  800bb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb9:	eb 03                	jmp    800bbe <strtol+0x11>
		s++;
  800bbb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bbe:	0f b6 01             	movzbl (%ecx),%eax
  800bc1:	3c 20                	cmp    $0x20,%al
  800bc3:	74 f6                	je     800bbb <strtol+0xe>
  800bc5:	3c 09                	cmp    $0x9,%al
  800bc7:	74 f2                	je     800bbb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc9:	3c 2b                	cmp    $0x2b,%al
  800bcb:	74 2a                	je     800bf7 <strtol+0x4a>
	int neg = 0;
  800bcd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd2:	3c 2d                	cmp    $0x2d,%al
  800bd4:	74 2b                	je     800c01 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bdc:	75 0f                	jne    800bed <strtol+0x40>
  800bde:	80 39 30             	cmpb   $0x30,(%ecx)
  800be1:	74 28                	je     800c0b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be3:	85 db                	test   %ebx,%ebx
  800be5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bea:	0f 44 d8             	cmove  %eax,%ebx
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf5:	eb 50                	jmp    800c47 <strtol+0x9a>
		s++;
  800bf7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfa:	bf 00 00 00 00       	mov    $0x0,%edi
  800bff:	eb d5                	jmp    800bd6 <strtol+0x29>
		s++, neg = 1;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	bf 01 00 00 00       	mov    $0x1,%edi
  800c09:	eb cb                	jmp    800bd6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0f:	74 0e                	je     800c1f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c11:	85 db                	test   %ebx,%ebx
  800c13:	75 d8                	jne    800bed <strtol+0x40>
		s++, base = 8;
  800c15:	83 c1 01             	add    $0x1,%ecx
  800c18:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1d:	eb ce                	jmp    800bed <strtol+0x40>
		s += 2, base = 16;
  800c1f:	83 c1 02             	add    $0x2,%ecx
  800c22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c27:	eb c4                	jmp    800bed <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2c:	89 f3                	mov    %esi,%ebx
  800c2e:	80 fb 19             	cmp    $0x19,%bl
  800c31:	77 29                	ja     800c5c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c33:	0f be d2             	movsbl %dl,%edx
  800c36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c39:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3c:	7d 30                	jge    800c6e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c47:	0f b6 11             	movzbl (%ecx),%edx
  800c4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4d:	89 f3                	mov    %esi,%ebx
  800c4f:	80 fb 09             	cmp    $0x9,%bl
  800c52:	77 d5                	ja     800c29 <strtol+0x7c>
			dig = *s - '0';
  800c54:	0f be d2             	movsbl %dl,%edx
  800c57:	83 ea 30             	sub    $0x30,%edx
  800c5a:	eb dd                	jmp    800c39 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 37             	sub    $0x37,%edx
  800c6c:	eb cb                	jmp    800c39 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c72:	74 05                	je     800c79 <strtol+0xcc>
		*endptr = (char *) s;
  800c74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	f7 da                	neg    %edx
  800c7d:	85 ff                	test   %edi,%edi
  800c7f:	0f 45 c2             	cmovne %edx,%eax
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	89 c3                	mov    %eax,%ebx
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	89 c6                	mov    %eax,%esi
  800c9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	89 cb                	mov    %ecx,%ebx
  800cdc:	89 cf                	mov    %ecx,%edi
  800cde:	89 ce                	mov    %ecx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 03                	push   $0x3
  800cf4:	68 88 29 80 00       	push   $0x802988
  800cf9:	6a 43                	push   $0x43
  800cfb:	68 a5 29 80 00       	push   $0x8029a5
  800d00:	e8 89 14 00 00       	call   80218e <_panic>

00800d05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 02 00 00 00       	mov    $0x2,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_yield>:

void
sys_yield(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	be 00 00 00 00       	mov    $0x0,%esi
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5f:	89 f7                	mov    %esi,%edi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 04                	push   $0x4
  800d75:	68 88 29 80 00       	push   $0x802988
  800d7a:	6a 43                	push   $0x43
  800d7c:	68 a5 29 80 00       	push   $0x8029a5
  800d81:	e8 08 14 00 00       	call   80218e <_panic>

00800d86 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da0:	8b 75 18             	mov    0x18(%ebp),%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 05                	push   $0x5
  800db7:	68 88 29 80 00       	push   $0x802988
  800dbc:	6a 43                	push   $0x43
  800dbe:	68 a5 29 80 00       	push   $0x8029a5
  800dc3:	e8 c6 13 00 00       	call   80218e <_panic>

00800dc8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 88 29 80 00       	push   $0x802988
  800dfe:	6a 43                	push   $0x43
  800e00:	68 a5 29 80 00       	push   $0x8029a5
  800e05:	e8 84 13 00 00       	call   80218e <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800e39:	6a 08                	push   $0x8
  800e3b:	68 88 29 80 00       	push   $0x802988
  800e40:	6a 43                	push   $0x43
  800e42:	68 a5 29 80 00       	push   $0x8029a5
  800e47:	e8 42 13 00 00       	call   80218e <_panic>

00800e4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 09 00 00 00       	mov    $0x9,%eax
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 09                	push   $0x9
  800e7d:	68 88 29 80 00       	push   $0x802988
  800e82:	6a 43                	push   $0x43
  800e84:	68 a5 29 80 00       	push   $0x8029a5
  800e89:	e8 00 13 00 00       	call   80218e <_panic>

00800e8e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7f 08                	jg     800eb9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 0a                	push   $0xa
  800ebf:	68 88 29 80 00       	push   $0x802988
  800ec4:	6a 43                	push   $0x43
  800ec6:	68 a5 29 80 00       	push   $0x8029a5
  800ecb:	e8 be 12 00 00       	call   80218e <_panic>

00800ed0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee1:	be 00 00 00 00       	mov    $0x0,%esi
  800ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eec:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f09:	89 cb                	mov    %ecx,%ebx
  800f0b:	89 cf                	mov    %ecx,%edi
  800f0d:	89 ce                	mov    %ecx,%esi
  800f0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7f 08                	jg     800f1d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	50                   	push   %eax
  800f21:	6a 0d                	push   $0xd
  800f23:	68 88 29 80 00       	push   $0x802988
  800f28:	6a 43                	push   $0x43
  800f2a:	68 a5 29 80 00       	push   $0x8029a5
  800f2f:	e8 5a 12 00 00       	call   80218e <_panic>

00800f34 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f68:	89 cb                	mov    %ecx,%ebx
  800f6a:	89 cf                	mov    %ecx,%edi
  800f6c:	89 ce                	mov    %ecx,%esi
  800f6e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	b8 10 00 00 00       	mov    $0x10,%eax
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	89 d3                	mov    %edx,%ebx
  800f89:	89 d7                	mov    %edx,%edi
  800f8b:	89 d6                	mov    %edx,%esi
  800f8d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	b8 11 00 00 00       	mov    $0x11,%eax
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	b8 12 00 00 00       	mov    $0x12,%eax
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	89 de                	mov    %ebx,%esi
  800fcf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
  800fdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	b8 13 00 00 00       	mov    $0x13,%eax
  800fef:	89 df                	mov    %ebx,%edi
  800ff1:	89 de                	mov    %ebx,%esi
  800ff3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	7f 08                	jg     801001 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	50                   	push   %eax
  801005:	6a 13                	push   $0x13
  801007:	68 88 29 80 00       	push   $0x802988
  80100c:	6a 43                	push   $0x43
  80100e:	68 a5 29 80 00       	push   $0x8029a5
  801013:	e8 76 11 00 00       	call   80218e <_panic>

00801018 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	b8 14 00 00 00       	mov    $0x14,%eax
  80102b:	89 cb                	mov    %ecx,%ebx
  80102d:	89 cf                	mov    %ecx,%edi
  80102f:	89 ce                	mov    %ecx,%esi
  801031:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	05 00 00 00 30       	add    $0x30000000,%eax
  801043:	c1 e8 0c             	shr    $0xc,%eax
}
  801046:	5d                   	pop    %ebp
  801047:	c3                   	ret    

00801048 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801053:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801058:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801067:	89 c2                	mov    %eax,%edx
  801069:	c1 ea 16             	shr    $0x16,%edx
  80106c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801073:	f6 c2 01             	test   $0x1,%dl
  801076:	74 2d                	je     8010a5 <fd_alloc+0x46>
  801078:	89 c2                	mov    %eax,%edx
  80107a:	c1 ea 0c             	shr    $0xc,%edx
  80107d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801084:	f6 c2 01             	test   $0x1,%dl
  801087:	74 1c                	je     8010a5 <fd_alloc+0x46>
  801089:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80108e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801093:	75 d2                	jne    801067 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80109e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010a3:	eb 0a                	jmp    8010af <fd_alloc+0x50>
			*fd_store = fd;
  8010a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010b7:	83 f8 1f             	cmp    $0x1f,%eax
  8010ba:	77 30                	ja     8010ec <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010bc:	c1 e0 0c             	shl    $0xc,%eax
  8010bf:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ca:	f6 c2 01             	test   $0x1,%dl
  8010cd:	74 24                	je     8010f3 <fd_lookup+0x42>
  8010cf:	89 c2                	mov    %eax,%edx
  8010d1:	c1 ea 0c             	shr    $0xc,%edx
  8010d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010db:	f6 c2 01             	test   $0x1,%dl
  8010de:	74 1a                	je     8010fa <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    
		return -E_INVAL;
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb f7                	jmp    8010ea <fd_lookup+0x39>
		return -E_INVAL;
  8010f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f8:	eb f0                	jmp    8010ea <fd_lookup+0x39>
  8010fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ff:	eb e9                	jmp    8010ea <fd_lookup+0x39>

00801101 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80110a:	ba 00 00 00 00       	mov    $0x0,%edx
  80110f:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801114:	39 08                	cmp    %ecx,(%eax)
  801116:	74 38                	je     801150 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801118:	83 c2 01             	add    $0x1,%edx
  80111b:	8b 04 95 30 2a 80 00 	mov    0x802a30(,%edx,4),%eax
  801122:	85 c0                	test   %eax,%eax
  801124:	75 ee                	jne    801114 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801126:	a1 08 40 80 00       	mov    0x804008,%eax
  80112b:	8b 40 48             	mov    0x48(%eax),%eax
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	51                   	push   %ecx
  801132:	50                   	push   %eax
  801133:	68 b4 29 80 00       	push   $0x8029b4
  801138:	e8 b5 f0 ff ff       	call   8001f2 <cprintf>
	*dev = 0;
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801146:	83 c4 10             	add    $0x10,%esp
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    
			*dev = devtab[i];
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	89 01                	mov    %eax,(%ecx)
			return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
  80115a:	eb f2                	jmp    80114e <dev_lookup+0x4d>

0080115c <fd_close>:
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
  801162:	83 ec 24             	sub    $0x24,%esp
  801165:	8b 75 08             	mov    0x8(%ebp),%esi
  801168:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80116b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80116e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801175:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801178:	50                   	push   %eax
  801179:	e8 33 ff ff ff       	call   8010b1 <fd_lookup>
  80117e:	89 c3                	mov    %eax,%ebx
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 05                	js     80118c <fd_close+0x30>
	    || fd != fd2)
  801187:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80118a:	74 16                	je     8011a2 <fd_close+0x46>
		return (must_exist ? r : 0);
  80118c:	89 f8                	mov    %edi,%eax
  80118e:	84 c0                	test   %al,%al
  801190:	b8 00 00 00 00       	mov    $0x0,%eax
  801195:	0f 44 d8             	cmove  %eax,%ebx
}
  801198:	89 d8                	mov    %ebx,%eax
  80119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 36                	pushl  (%esi)
  8011ab:	e8 51 ff ff ff       	call   801101 <dev_lookup>
  8011b0:	89 c3                	mov    %eax,%ebx
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	78 1a                	js     8011d3 <fd_close+0x77>
		if (dev->dev_close)
  8011b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011bc:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011bf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	74 0b                	je     8011d3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	56                   	push   %esi
  8011cc:	ff d0                	call   *%eax
  8011ce:	89 c3                	mov    %eax,%ebx
  8011d0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	56                   	push   %esi
  8011d7:	6a 00                	push   $0x0
  8011d9:	e8 ea fb ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	eb b5                	jmp    801198 <fd_close+0x3c>

008011e3 <close>:

int
close(int fdnum)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	ff 75 08             	pushl  0x8(%ebp)
  8011f0:	e8 bc fe ff ff       	call   8010b1 <fd_lookup>
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	79 02                	jns    8011fe <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    
		return fd_close(fd, 1);
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	6a 01                	push   $0x1
  801203:	ff 75 f4             	pushl  -0xc(%ebp)
  801206:	e8 51 ff ff ff       	call   80115c <fd_close>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	eb ec                	jmp    8011fc <close+0x19>

00801210 <close_all>:

void
close_all(void)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	53                   	push   %ebx
  801214:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	53                   	push   %ebx
  801220:	e8 be ff ff ff       	call   8011e3 <close>
	for (i = 0; i < MAXFD; i++)
  801225:	83 c3 01             	add    $0x1,%ebx
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	83 fb 20             	cmp    $0x20,%ebx
  80122e:	75 ec                	jne    80121c <close_all+0xc>
}
  801230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	57                   	push   %edi
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80123e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801241:	50                   	push   %eax
  801242:	ff 75 08             	pushl  0x8(%ebp)
  801245:	e8 67 fe ff ff       	call   8010b1 <fd_lookup>
  80124a:	89 c3                	mov    %eax,%ebx
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	0f 88 81 00 00 00    	js     8012d8 <dup+0xa3>
		return r;
	close(newfdnum);
  801257:	83 ec 0c             	sub    $0xc,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	e8 81 ff ff ff       	call   8011e3 <close>

	newfd = INDEX2FD(newfdnum);
  801262:	8b 75 0c             	mov    0xc(%ebp),%esi
  801265:	c1 e6 0c             	shl    $0xc,%esi
  801268:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	ff 75 e4             	pushl  -0x1c(%ebp)
  801274:	e8 cf fd ff ff       	call   801048 <fd2data>
  801279:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80127b:	89 34 24             	mov    %esi,(%esp)
  80127e:	e8 c5 fd ff ff       	call   801048 <fd2data>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	c1 e8 16             	shr    $0x16,%eax
  80128d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801294:	a8 01                	test   $0x1,%al
  801296:	74 11                	je     8012a9 <dup+0x74>
  801298:	89 d8                	mov    %ebx,%eax
  80129a:	c1 e8 0c             	shr    $0xc,%eax
  80129d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a4:	f6 c2 01             	test   $0x1,%dl
  8012a7:	75 39                	jne    8012e2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012ac:	89 d0                	mov    %edx,%eax
  8012ae:	c1 e8 0c             	shr    $0xc,%eax
  8012b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b8:	83 ec 0c             	sub    $0xc,%esp
  8012bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8012c0:	50                   	push   %eax
  8012c1:	56                   	push   %esi
  8012c2:	6a 00                	push   $0x0
  8012c4:	52                   	push   %edx
  8012c5:	6a 00                	push   $0x0
  8012c7:	e8 ba fa ff ff       	call   800d86 <sys_page_map>
  8012cc:	89 c3                	mov    %eax,%ebx
  8012ce:	83 c4 20             	add    $0x20,%esp
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	78 31                	js     801306 <dup+0xd1>
		goto err;

	return newfdnum;
  8012d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012d8:	89 d8                	mov    %ebx,%eax
  8012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5f                   	pop    %edi
  8012e0:	5d                   	pop    %ebp
  8012e1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f1:	50                   	push   %eax
  8012f2:	57                   	push   %edi
  8012f3:	6a 00                	push   $0x0
  8012f5:	53                   	push   %ebx
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 89 fa ff ff       	call   800d86 <sys_page_map>
  8012fd:	89 c3                	mov    %eax,%ebx
  8012ff:	83 c4 20             	add    $0x20,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	79 a3                	jns    8012a9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	56                   	push   %esi
  80130a:	6a 00                	push   $0x0
  80130c:	e8 b7 fa ff ff       	call   800dc8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801311:	83 c4 08             	add    $0x8,%esp
  801314:	57                   	push   %edi
  801315:	6a 00                	push   $0x0
  801317:	e8 ac fa ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	eb b7                	jmp    8012d8 <dup+0xa3>

00801321 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	53                   	push   %ebx
  801325:	83 ec 1c             	sub    $0x1c,%esp
  801328:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132e:	50                   	push   %eax
  80132f:	53                   	push   %ebx
  801330:	e8 7c fd ff ff       	call   8010b1 <fd_lookup>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 3f                	js     80137b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801346:	ff 30                	pushl  (%eax)
  801348:	e8 b4 fd ff ff       	call   801101 <dev_lookup>
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	78 27                	js     80137b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801354:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801357:	8b 42 08             	mov    0x8(%edx),%eax
  80135a:	83 e0 03             	and    $0x3,%eax
  80135d:	83 f8 01             	cmp    $0x1,%eax
  801360:	74 1e                	je     801380 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801365:	8b 40 08             	mov    0x8(%eax),%eax
  801368:	85 c0                	test   %eax,%eax
  80136a:	74 35                	je     8013a1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	ff 75 10             	pushl  0x10(%ebp)
  801372:	ff 75 0c             	pushl  0xc(%ebp)
  801375:	52                   	push   %edx
  801376:	ff d0                	call   *%eax
  801378:	83 c4 10             	add    $0x10,%esp
}
  80137b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801380:	a1 08 40 80 00       	mov    0x804008,%eax
  801385:	8b 40 48             	mov    0x48(%eax),%eax
  801388:	83 ec 04             	sub    $0x4,%esp
  80138b:	53                   	push   %ebx
  80138c:	50                   	push   %eax
  80138d:	68 f5 29 80 00       	push   $0x8029f5
  801392:	e8 5b ee ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139f:	eb da                	jmp    80137b <read+0x5a>
		return -E_NOT_SUPP;
  8013a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a6:	eb d3                	jmp    80137b <read+0x5a>

008013a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	57                   	push   %edi
  8013ac:	56                   	push   %esi
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 0c             	sub    $0xc,%esp
  8013b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bc:	39 f3                	cmp    %esi,%ebx
  8013be:	73 23                	jae    8013e3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	89 f0                	mov    %esi,%eax
  8013c5:	29 d8                	sub    %ebx,%eax
  8013c7:	50                   	push   %eax
  8013c8:	89 d8                	mov    %ebx,%eax
  8013ca:	03 45 0c             	add    0xc(%ebp),%eax
  8013cd:	50                   	push   %eax
  8013ce:	57                   	push   %edi
  8013cf:	e8 4d ff ff ff       	call   801321 <read>
		if (m < 0)
  8013d4:	83 c4 10             	add    $0x10,%esp
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 06                	js     8013e1 <readn+0x39>
			return m;
		if (m == 0)
  8013db:	74 06                	je     8013e3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013dd:	01 c3                	add    %eax,%ebx
  8013df:	eb db                	jmp    8013bc <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013e3:	89 d8                	mov    %ebx,%eax
  8013e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e8:	5b                   	pop    %ebx
  8013e9:	5e                   	pop    %esi
  8013ea:	5f                   	pop    %edi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	53                   	push   %ebx
  8013f1:	83 ec 1c             	sub    $0x1c,%esp
  8013f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	53                   	push   %ebx
  8013fc:	e8 b0 fc ff ff       	call   8010b1 <fd_lookup>
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	85 c0                	test   %eax,%eax
  801406:	78 3a                	js     801442 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801412:	ff 30                	pushl  (%eax)
  801414:	e8 e8 fc ff ff       	call   801101 <dev_lookup>
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 22                	js     801442 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801423:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801427:	74 1e                	je     801447 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142c:	8b 52 0c             	mov    0xc(%edx),%edx
  80142f:	85 d2                	test   %edx,%edx
  801431:	74 35                	je     801468 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	ff 75 10             	pushl  0x10(%ebp)
  801439:	ff 75 0c             	pushl  0xc(%ebp)
  80143c:	50                   	push   %eax
  80143d:	ff d2                	call   *%edx
  80143f:	83 c4 10             	add    $0x10,%esp
}
  801442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801445:	c9                   	leave  
  801446:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801447:	a1 08 40 80 00       	mov    0x804008,%eax
  80144c:	8b 40 48             	mov    0x48(%eax),%eax
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	53                   	push   %ebx
  801453:	50                   	push   %eax
  801454:	68 11 2a 80 00       	push   $0x802a11
  801459:	e8 94 ed ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801466:	eb da                	jmp    801442 <write+0x55>
		return -E_NOT_SUPP;
  801468:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146d:	eb d3                	jmp    801442 <write+0x55>

0080146f <seek>:

int
seek(int fdnum, off_t offset)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801475:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	e8 30 fc ff ff       	call   8010b1 <fd_lookup>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	78 0e                	js     801496 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801491:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	53                   	push   %ebx
  80149c:	83 ec 1c             	sub    $0x1c,%esp
  80149f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a5:	50                   	push   %eax
  8014a6:	53                   	push   %ebx
  8014a7:	e8 05 fc ff ff       	call   8010b1 <fd_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 37                	js     8014ea <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	50                   	push   %eax
  8014ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bd:	ff 30                	pushl  (%eax)
  8014bf:	e8 3d fc ff ff       	call   801101 <dev_lookup>
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 1f                	js     8014ea <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d2:	74 1b                	je     8014ef <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d7:	8b 52 18             	mov    0x18(%edx),%edx
  8014da:	85 d2                	test   %edx,%edx
  8014dc:	74 32                	je     801510 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	ff d2                	call   *%edx
  8014e7:	83 c4 10             	add    $0x10,%esp
}
  8014ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014ef:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f4:	8b 40 48             	mov    0x48(%eax),%eax
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	53                   	push   %ebx
  8014fb:	50                   	push   %eax
  8014fc:	68 d4 29 80 00       	push   $0x8029d4
  801501:	e8 ec ec ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150e:	eb da                	jmp    8014ea <ftruncate+0x52>
		return -E_NOT_SUPP;
  801510:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801515:	eb d3                	jmp    8014ea <ftruncate+0x52>

00801517 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	53                   	push   %ebx
  80151b:	83 ec 1c             	sub    $0x1c,%esp
  80151e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	ff 75 08             	pushl  0x8(%ebp)
  801528:	e8 84 fb ff ff       	call   8010b1 <fd_lookup>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	78 4b                	js     80157f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	ff 30                	pushl  (%eax)
  801540:	e8 bc fb ff ff       	call   801101 <dev_lookup>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 33                	js     80157f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801553:	74 2f                	je     801584 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801555:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801558:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80155f:	00 00 00 
	stat->st_isdir = 0;
  801562:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801569:	00 00 00 
	stat->st_dev = dev;
  80156c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	53                   	push   %ebx
  801576:	ff 75 f0             	pushl  -0x10(%ebp)
  801579:	ff 50 14             	call   *0x14(%eax)
  80157c:	83 c4 10             	add    $0x10,%esp
}
  80157f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801582:	c9                   	leave  
  801583:	c3                   	ret    
		return -E_NOT_SUPP;
  801584:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801589:	eb f4                	jmp    80157f <fstat+0x68>

0080158b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801590:	83 ec 08             	sub    $0x8,%esp
  801593:	6a 00                	push   $0x0
  801595:	ff 75 08             	pushl  0x8(%ebp)
  801598:	e8 22 02 00 00       	call   8017bf <open>
  80159d:	89 c3                	mov    %eax,%ebx
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	78 1b                	js     8015c1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	50                   	push   %eax
  8015ad:	e8 65 ff ff ff       	call   801517 <fstat>
  8015b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b4:	89 1c 24             	mov    %ebx,(%esp)
  8015b7:	e8 27 fc ff ff       	call   8011e3 <close>
	return r;
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	89 f3                	mov    %esi,%ebx
}
  8015c1:	89 d8                	mov    %ebx,%eax
  8015c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	56                   	push   %esi
  8015ce:	53                   	push   %ebx
  8015cf:	89 c6                	mov    %eax,%esi
  8015d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015da:	74 27                	je     801603 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015dc:	6a 07                	push   $0x7
  8015de:	68 00 50 80 00       	push   $0x805000
  8015e3:	56                   	push   %esi
  8015e4:	ff 35 00 40 80 00    	pushl  0x804000
  8015ea:	e8 69 0c 00 00       	call   802258 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ef:	83 c4 0c             	add    $0xc,%esp
  8015f2:	6a 00                	push   $0x0
  8015f4:	53                   	push   %ebx
  8015f5:	6a 00                	push   $0x0
  8015f7:	e8 f3 0b 00 00       	call   8021ef <ipc_recv>
}
  8015fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ff:	5b                   	pop    %ebx
  801600:	5e                   	pop    %esi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801603:	83 ec 0c             	sub    $0xc,%esp
  801606:	6a 01                	push   $0x1
  801608:	e8 a3 0c 00 00       	call   8022b0 <ipc_find_env>
  80160d:	a3 00 40 80 00       	mov    %eax,0x804000
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	eb c5                	jmp    8015dc <fsipc+0x12>

00801617 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	8b 40 0c             	mov    0xc(%eax),%eax
  801623:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801630:	ba 00 00 00 00       	mov    $0x0,%edx
  801635:	b8 02 00 00 00       	mov    $0x2,%eax
  80163a:	e8 8b ff ff ff       	call   8015ca <fsipc>
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <devfile_flush>:
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 40 0c             	mov    0xc(%eax),%eax
  80164d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801652:	ba 00 00 00 00       	mov    $0x0,%edx
  801657:	b8 06 00 00 00       	mov    $0x6,%eax
  80165c:	e8 69 ff ff ff       	call   8015ca <fsipc>
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <devfile_stat>:
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	53                   	push   %ebx
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8b 40 0c             	mov    0xc(%eax),%eax
  801673:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801678:	ba 00 00 00 00       	mov    $0x0,%edx
  80167d:	b8 05 00 00 00       	mov    $0x5,%eax
  801682:	e8 43 ff ff ff       	call   8015ca <fsipc>
  801687:	85 c0                	test   %eax,%eax
  801689:	78 2c                	js     8016b7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	68 00 50 80 00       	push   $0x805000
  801693:	53                   	push   %ebx
  801694:	e8 b8 f2 ff ff       	call   800951 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801699:	a1 80 50 80 00       	mov    0x805080,%eax
  80169e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016a4:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <devfile_write>:
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	53                   	push   %ebx
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016d1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016d7:	53                   	push   %ebx
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	68 08 50 80 00       	push   $0x805008
  8016e0:	e8 5c f4 ff ff       	call   800b41 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ef:	e8 d6 fe ff ff       	call   8015ca <fsipc>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 0b                	js     801706 <devfile_write+0x4a>
	assert(r <= n);
  8016fb:	39 d8                	cmp    %ebx,%eax
  8016fd:	77 0c                	ja     80170b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801704:	7f 1e                	jg     801724 <devfile_write+0x68>
}
  801706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801709:	c9                   	leave  
  80170a:	c3                   	ret    
	assert(r <= n);
  80170b:	68 44 2a 80 00       	push   $0x802a44
  801710:	68 4b 2a 80 00       	push   $0x802a4b
  801715:	68 98 00 00 00       	push   $0x98
  80171a:	68 60 2a 80 00       	push   $0x802a60
  80171f:	e8 6a 0a 00 00       	call   80218e <_panic>
	assert(r <= PGSIZE);
  801724:	68 6b 2a 80 00       	push   $0x802a6b
  801729:	68 4b 2a 80 00       	push   $0x802a4b
  80172e:	68 99 00 00 00       	push   $0x99
  801733:	68 60 2a 80 00       	push   $0x802a60
  801738:	e8 51 0a 00 00       	call   80218e <_panic>

0080173d <devfile_read>:
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8b 40 0c             	mov    0xc(%eax),%eax
  80174b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801750:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801756:	ba 00 00 00 00       	mov    $0x0,%edx
  80175b:	b8 03 00 00 00       	mov    $0x3,%eax
  801760:	e8 65 fe ff ff       	call   8015ca <fsipc>
  801765:	89 c3                	mov    %eax,%ebx
  801767:	85 c0                	test   %eax,%eax
  801769:	78 1f                	js     80178a <devfile_read+0x4d>
	assert(r <= n);
  80176b:	39 f0                	cmp    %esi,%eax
  80176d:	77 24                	ja     801793 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801774:	7f 33                	jg     8017a9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	50                   	push   %eax
  80177a:	68 00 50 80 00       	push   $0x805000
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	e8 58 f3 ff ff       	call   800adf <memmove>
	return r;
  801787:	83 c4 10             	add    $0x10,%esp
}
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    
	assert(r <= n);
  801793:	68 44 2a 80 00       	push   $0x802a44
  801798:	68 4b 2a 80 00       	push   $0x802a4b
  80179d:	6a 7c                	push   $0x7c
  80179f:	68 60 2a 80 00       	push   $0x802a60
  8017a4:	e8 e5 09 00 00       	call   80218e <_panic>
	assert(r <= PGSIZE);
  8017a9:	68 6b 2a 80 00       	push   $0x802a6b
  8017ae:	68 4b 2a 80 00       	push   $0x802a4b
  8017b3:	6a 7d                	push   $0x7d
  8017b5:	68 60 2a 80 00       	push   $0x802a60
  8017ba:	e8 cf 09 00 00       	call   80218e <_panic>

008017bf <open>:
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	56                   	push   %esi
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 1c             	sub    $0x1c,%esp
  8017c7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ca:	56                   	push   %esi
  8017cb:	e8 48 f1 ff ff       	call   800918 <strlen>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d8:	7f 6c                	jg     801846 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017da:	83 ec 0c             	sub    $0xc,%esp
  8017dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e0:	50                   	push   %eax
  8017e1:	e8 79 f8 ff ff       	call   80105f <fd_alloc>
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 3c                	js     80182b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ef:	83 ec 08             	sub    $0x8,%esp
  8017f2:	56                   	push   %esi
  8017f3:	68 00 50 80 00       	push   $0x805000
  8017f8:	e8 54 f1 ff ff       	call   800951 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801808:	b8 01 00 00 00       	mov    $0x1,%eax
  80180d:	e8 b8 fd ff ff       	call   8015ca <fsipc>
  801812:	89 c3                	mov    %eax,%ebx
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 19                	js     801834 <open+0x75>
	return fd2num(fd);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	ff 75 f4             	pushl  -0xc(%ebp)
  801821:	e8 12 f8 ff ff       	call   801038 <fd2num>
  801826:	89 c3                	mov    %eax,%ebx
  801828:	83 c4 10             	add    $0x10,%esp
}
  80182b:	89 d8                	mov    %ebx,%eax
  80182d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801830:	5b                   	pop    %ebx
  801831:	5e                   	pop    %esi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    
		fd_close(fd, 0);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	6a 00                	push   $0x0
  801839:	ff 75 f4             	pushl  -0xc(%ebp)
  80183c:	e8 1b f9 ff ff       	call   80115c <fd_close>
		return r;
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	eb e5                	jmp    80182b <open+0x6c>
		return -E_BAD_PATH;
  801846:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80184b:	eb de                	jmp    80182b <open+0x6c>

0080184d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	b8 08 00 00 00       	mov    $0x8,%eax
  80185d:	e8 68 fd ff ff       	call   8015ca <fsipc>
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80186a:	68 77 2a 80 00       	push   $0x802a77
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	e8 da f0 ff ff       	call   800951 <strcpy>
	return 0;
}
  801877:	b8 00 00 00 00       	mov    $0x0,%eax
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <devsock_close>:
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	53                   	push   %ebx
  801882:	83 ec 10             	sub    $0x10,%esp
  801885:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801888:	53                   	push   %ebx
  801889:	e8 61 0a 00 00       	call   8022ef <pageref>
  80188e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801896:	83 f8 01             	cmp    $0x1,%eax
  801899:	74 07                	je     8018a2 <devsock_close+0x24>
}
  80189b:	89 d0                	mov    %edx,%eax
  80189d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018a2:	83 ec 0c             	sub    $0xc,%esp
  8018a5:	ff 73 0c             	pushl  0xc(%ebx)
  8018a8:	e8 b9 02 00 00       	call   801b66 <nsipc_close>
  8018ad:	89 c2                	mov    %eax,%edx
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	eb e7                	jmp    80189b <devsock_close+0x1d>

008018b4 <devsock_write>:
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	ff 75 10             	pushl  0x10(%ebp)
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	ff 70 0c             	pushl  0xc(%eax)
  8018c8:	e8 76 03 00 00       	call   801c43 <nsipc_send>
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <devsock_read>:
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	ff 70 0c             	pushl  0xc(%eax)
  8018e3:	e8 ef 02 00 00       	call   801bd7 <nsipc_recv>
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <fd2sockid>:
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018f0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	e8 b7 f7 ff ff       	call   8010b1 <fd_lookup>
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	78 10                	js     801911 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801904:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  80190a:	39 08                	cmp    %ecx,(%eax)
  80190c:	75 05                	jne    801913 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80190e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    
		return -E_NOT_SUPP;
  801913:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801918:	eb f7                	jmp    801911 <fd2sockid+0x27>

0080191a <alloc_sockfd>:
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	83 ec 1c             	sub    $0x1c,%esp
  801922:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801927:	50                   	push   %eax
  801928:	e8 32 f7 ff ff       	call   80105f <fd_alloc>
  80192d:	89 c3                	mov    %eax,%ebx
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 43                	js     801979 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	68 07 04 00 00       	push   $0x407
  80193e:	ff 75 f4             	pushl  -0xc(%ebp)
  801941:	6a 00                	push   $0x0
  801943:	e8 fb f3 ff ff       	call   800d43 <sys_page_alloc>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 28                	js     801979 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	8b 15 24 30 80 00    	mov    0x803024,%edx
  80195a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801966:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	50                   	push   %eax
  80196d:	e8 c6 f6 ff ff       	call   801038 <fd2num>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	eb 0c                	jmp    801985 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801979:	83 ec 0c             	sub    $0xc,%esp
  80197c:	56                   	push   %esi
  80197d:	e8 e4 01 00 00       	call   801b66 <nsipc_close>
		return r;
  801982:	83 c4 10             	add    $0x10,%esp
}
  801985:	89 d8                	mov    %ebx,%eax
  801987:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198a:	5b                   	pop    %ebx
  80198b:	5e                   	pop    %esi
  80198c:	5d                   	pop    %ebp
  80198d:	c3                   	ret    

0080198e <accept>:
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	e8 4e ff ff ff       	call   8018ea <fd2sockid>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 1b                	js     8019bb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	50                   	push   %eax
  8019aa:	e8 0e 01 00 00       	call   801abd <nsipc_accept>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 05                	js     8019bb <accept+0x2d>
	return alloc_sockfd(r);
  8019b6:	e8 5f ff ff ff       	call   80191a <alloc_sockfd>
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <bind>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	e8 1f ff ff ff       	call   8018ea <fd2sockid>
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 12                	js     8019e1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	ff 75 10             	pushl  0x10(%ebp)
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	50                   	push   %eax
  8019d9:	e8 31 01 00 00       	call   801b0f <nsipc_bind>
  8019de:	83 c4 10             	add    $0x10,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <shutdown>:
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	e8 f9 fe ff ff       	call   8018ea <fd2sockid>
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	78 0f                	js     801a04 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	50                   	push   %eax
  8019fc:	e8 43 01 00 00       	call   801b44 <nsipc_shutdown>
  801a01:	83 c4 10             	add    $0x10,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <connect>:
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	e8 d6 fe ff ff       	call   8018ea <fd2sockid>
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 12                	js     801a2a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	ff 75 10             	pushl  0x10(%ebp)
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	50                   	push   %eax
  801a22:	e8 59 01 00 00       	call   801b80 <nsipc_connect>
  801a27:	83 c4 10             	add    $0x10,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <listen>:
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	e8 b0 fe ff ff       	call   8018ea <fd2sockid>
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 0f                	js     801a4d <listen+0x21>
	return nsipc_listen(r, backlog);
  801a3e:	83 ec 08             	sub    $0x8,%esp
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	50                   	push   %eax
  801a45:	e8 6b 01 00 00       	call   801bb5 <nsipc_listen>
  801a4a:	83 c4 10             	add    $0x10,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <socket>:

int
socket(int domain, int type, int protocol)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a55:	ff 75 10             	pushl  0x10(%ebp)
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	ff 75 08             	pushl  0x8(%ebp)
  801a5e:	e8 3e 02 00 00       	call   801ca1 <nsipc_socket>
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 05                	js     801a6f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a6a:	e8 ab fe ff ff       	call   80191a <alloc_sockfd>
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	53                   	push   %ebx
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a7a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a81:	74 26                	je     801aa9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a83:	6a 07                	push   $0x7
  801a85:	68 00 60 80 00       	push   $0x806000
  801a8a:	53                   	push   %ebx
  801a8b:	ff 35 04 40 80 00    	pushl  0x804004
  801a91:	e8 c2 07 00 00       	call   802258 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a96:	83 c4 0c             	add    $0xc,%esp
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 4b 07 00 00       	call   8021ef <ipc_recv>
}
  801aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	6a 02                	push   $0x2
  801aae:	e8 fd 07 00 00       	call   8022b0 <ipc_find_env>
  801ab3:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	eb c6                	jmp    801a83 <nsipc+0x12>

00801abd <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	56                   	push   %esi
  801ac1:	53                   	push   %ebx
  801ac2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801acd:	8b 06                	mov    (%esi),%eax
  801acf:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ad4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad9:	e8 93 ff ff ff       	call   801a71 <nsipc>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	79 09                	jns    801aed <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5e                   	pop    %esi
  801aeb:	5d                   	pop    %ebp
  801aec:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	ff 35 10 60 80 00    	pushl  0x806010
  801af6:	68 00 60 80 00       	push   $0x806000
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	e8 dc ef ff ff       	call   800adf <memmove>
		*addrlen = ret->ret_addrlen;
  801b03:	a1 10 60 80 00       	mov    0x806010,%eax
  801b08:	89 06                	mov    %eax,(%esi)
  801b0a:	83 c4 10             	add    $0x10,%esp
	return r;
  801b0d:	eb d5                	jmp    801ae4 <nsipc_accept+0x27>

00801b0f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	53                   	push   %ebx
  801b13:	83 ec 08             	sub    $0x8,%esp
  801b16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b21:	53                   	push   %ebx
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	68 04 60 80 00       	push   $0x806004
  801b2a:	e8 b0 ef ff ff       	call   800adf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b2f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b35:	b8 02 00 00 00       	mov    $0x2,%eax
  801b3a:	e8 32 ff ff ff       	call   801a71 <nsipc>
}
  801b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b55:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b5a:	b8 03 00 00 00       	mov    $0x3,%eax
  801b5f:	e8 0d ff ff ff       	call   801a71 <nsipc>
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <nsipc_close>:

int
nsipc_close(int s)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b74:	b8 04 00 00 00       	mov    $0x4,%eax
  801b79:	e8 f3 fe ff ff       	call   801a71 <nsipc>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 08             	sub    $0x8,%esp
  801b87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b92:	53                   	push   %ebx
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	68 04 60 80 00       	push   $0x806004
  801b9b:	e8 3f ef ff ff       	call   800adf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ba0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ba6:	b8 05 00 00 00       	mov    $0x5,%eax
  801bab:	e8 c1 fe ff ff       	call   801a71 <nsipc>
}
  801bb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bcb:	b8 06 00 00 00       	mov    $0x6,%eax
  801bd0:	e8 9c fe ff ff       	call   801a71 <nsipc>
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	56                   	push   %esi
  801bdb:	53                   	push   %ebx
  801bdc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf5:	b8 07 00 00 00       	mov    $0x7,%eax
  801bfa:	e8 72 fe ff ff       	call   801a71 <nsipc>
  801bff:	89 c3                	mov    %eax,%ebx
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 1f                	js     801c24 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c05:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c0a:	7f 21                	jg     801c2d <nsipc_recv+0x56>
  801c0c:	39 c6                	cmp    %eax,%esi
  801c0e:	7c 1d                	jl     801c2d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	50                   	push   %eax
  801c14:	68 00 60 80 00       	push   $0x806000
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	e8 be ee ff ff       	call   800adf <memmove>
  801c21:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c24:	89 d8                	mov    %ebx,%eax
  801c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c29:	5b                   	pop    %ebx
  801c2a:	5e                   	pop    %esi
  801c2b:	5d                   	pop    %ebp
  801c2c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c2d:	68 83 2a 80 00       	push   $0x802a83
  801c32:	68 4b 2a 80 00       	push   $0x802a4b
  801c37:	6a 62                	push   $0x62
  801c39:	68 98 2a 80 00       	push   $0x802a98
  801c3e:	e8 4b 05 00 00       	call   80218e <_panic>

00801c43 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	53                   	push   %ebx
  801c47:	83 ec 04             	sub    $0x4,%esp
  801c4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c55:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c5b:	7f 2e                	jg     801c8b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	53                   	push   %ebx
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	68 0c 60 80 00       	push   $0x80600c
  801c69:	e8 71 ee ff ff       	call   800adf <memmove>
	nsipcbuf.send.req_size = size;
  801c6e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c74:	8b 45 14             	mov    0x14(%ebp),%eax
  801c77:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801c81:	e8 eb fd ff ff       	call   801a71 <nsipc>
}
  801c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    
	assert(size < 1600);
  801c8b:	68 a4 2a 80 00       	push   $0x802aa4
  801c90:	68 4b 2a 80 00       	push   $0x802a4b
  801c95:	6a 6d                	push   $0x6d
  801c97:	68 98 2a 80 00       	push   $0x802a98
  801c9c:	e8 ed 04 00 00       	call   80218e <_panic>

00801ca1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cba:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cbf:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc4:	e8 a8 fd ff ff       	call   801a71 <nsipc>
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	e8 6a f3 ff ff       	call   801048 <fd2data>
  801cde:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ce0:	83 c4 08             	add    $0x8,%esp
  801ce3:	68 b0 2a 80 00       	push   $0x802ab0
  801ce8:	53                   	push   %ebx
  801ce9:	e8 63 ec ff ff       	call   800951 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cee:	8b 46 04             	mov    0x4(%esi),%eax
  801cf1:	2b 06                	sub    (%esi),%eax
  801cf3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d00:	00 00 00 
	stat->st_dev = &devpipe;
  801d03:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801d0a:	30 80 00 
	return 0;
}
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d23:	53                   	push   %ebx
  801d24:	6a 00                	push   $0x0
  801d26:	e8 9d f0 ff ff       	call   800dc8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d2b:	89 1c 24             	mov    %ebx,(%esp)
  801d2e:	e8 15 f3 ff ff       	call   801048 <fd2data>
  801d33:	83 c4 08             	add    $0x8,%esp
  801d36:	50                   	push   %eax
  801d37:	6a 00                	push   $0x0
  801d39:	e8 8a f0 ff ff       	call   800dc8 <sys_page_unmap>
}
  801d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <_pipeisclosed>:
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	57                   	push   %edi
  801d47:	56                   	push   %esi
  801d48:	53                   	push   %ebx
  801d49:	83 ec 1c             	sub    $0x1c,%esp
  801d4c:	89 c7                	mov    %eax,%edi
  801d4e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d50:	a1 08 40 80 00       	mov    0x804008,%eax
  801d55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	57                   	push   %edi
  801d5c:	e8 8e 05 00 00       	call   8022ef <pageref>
  801d61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d64:	89 34 24             	mov    %esi,(%esp)
  801d67:	e8 83 05 00 00       	call   8022ef <pageref>
		nn = thisenv->env_runs;
  801d6c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d72:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	39 cb                	cmp    %ecx,%ebx
  801d7a:	74 1b                	je     801d97 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d7c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d7f:	75 cf                	jne    801d50 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d81:	8b 42 58             	mov    0x58(%edx),%eax
  801d84:	6a 01                	push   $0x1
  801d86:	50                   	push   %eax
  801d87:	53                   	push   %ebx
  801d88:	68 b7 2a 80 00       	push   $0x802ab7
  801d8d:	e8 60 e4 ff ff       	call   8001f2 <cprintf>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	eb b9                	jmp    801d50 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d9a:	0f 94 c0             	sete   %al
  801d9d:	0f b6 c0             	movzbl %al,%eax
}
  801da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    

00801da8 <devpipe_write>:
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	57                   	push   %edi
  801dac:	56                   	push   %esi
  801dad:	53                   	push   %ebx
  801dae:	83 ec 28             	sub    $0x28,%esp
  801db1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801db4:	56                   	push   %esi
  801db5:	e8 8e f2 ff ff       	call   801048 <fd2data>
  801dba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc7:	74 4f                	je     801e18 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc9:	8b 43 04             	mov    0x4(%ebx),%eax
  801dcc:	8b 0b                	mov    (%ebx),%ecx
  801dce:	8d 51 20             	lea    0x20(%ecx),%edx
  801dd1:	39 d0                	cmp    %edx,%eax
  801dd3:	72 14                	jb     801de9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dd5:	89 da                	mov    %ebx,%edx
  801dd7:	89 f0                	mov    %esi,%eax
  801dd9:	e8 65 ff ff ff       	call   801d43 <_pipeisclosed>
  801dde:	85 c0                	test   %eax,%eax
  801de0:	75 3b                	jne    801e1d <devpipe_write+0x75>
			sys_yield();
  801de2:	e8 3d ef ff ff       	call   800d24 <sys_yield>
  801de7:	eb e0                	jmp    801dc9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dec:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801df0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	c1 fa 1f             	sar    $0x1f,%edx
  801df8:	89 d1                	mov    %edx,%ecx
  801dfa:	c1 e9 1b             	shr    $0x1b,%ecx
  801dfd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e00:	83 e2 1f             	and    $0x1f,%edx
  801e03:	29 ca                	sub    %ecx,%edx
  801e05:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e09:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e0d:	83 c0 01             	add    $0x1,%eax
  801e10:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e13:	83 c7 01             	add    $0x1,%edi
  801e16:	eb ac                	jmp    801dc4 <devpipe_write+0x1c>
	return i;
  801e18:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1b:	eb 05                	jmp    801e22 <devpipe_write+0x7a>
				return 0;
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <devpipe_read>:
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	57                   	push   %edi
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 18             	sub    $0x18,%esp
  801e33:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e36:	57                   	push   %edi
  801e37:	e8 0c f2 ff ff       	call   801048 <fd2data>
  801e3c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	be 00 00 00 00       	mov    $0x0,%esi
  801e46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e49:	75 14                	jne    801e5f <devpipe_read+0x35>
	return i;
  801e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4e:	eb 02                	jmp    801e52 <devpipe_read+0x28>
				return i;
  801e50:	89 f0                	mov    %esi,%eax
}
  801e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5f                   	pop    %edi
  801e58:	5d                   	pop    %ebp
  801e59:	c3                   	ret    
			sys_yield();
  801e5a:	e8 c5 ee ff ff       	call   800d24 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e5f:	8b 03                	mov    (%ebx),%eax
  801e61:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e64:	75 18                	jne    801e7e <devpipe_read+0x54>
			if (i > 0)
  801e66:	85 f6                	test   %esi,%esi
  801e68:	75 e6                	jne    801e50 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e6a:	89 da                	mov    %ebx,%edx
  801e6c:	89 f8                	mov    %edi,%eax
  801e6e:	e8 d0 fe ff ff       	call   801d43 <_pipeisclosed>
  801e73:	85 c0                	test   %eax,%eax
  801e75:	74 e3                	je     801e5a <devpipe_read+0x30>
				return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	eb d4                	jmp    801e52 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e7e:	99                   	cltd   
  801e7f:	c1 ea 1b             	shr    $0x1b,%edx
  801e82:	01 d0                	add    %edx,%eax
  801e84:	83 e0 1f             	and    $0x1f,%eax
  801e87:	29 d0                	sub    %edx,%eax
  801e89:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e91:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e94:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e97:	83 c6 01             	add    $0x1,%esi
  801e9a:	eb aa                	jmp    801e46 <devpipe_read+0x1c>

00801e9c <pipe>:
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea7:	50                   	push   %eax
  801ea8:	e8 b2 f1 ff ff       	call   80105f <fd_alloc>
  801ead:	89 c3                	mov    %eax,%ebx
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	0f 88 23 01 00 00    	js     801fdd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	68 07 04 00 00       	push   $0x407
  801ec2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec5:	6a 00                	push   $0x0
  801ec7:	e8 77 ee ff ff       	call   800d43 <sys_page_alloc>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	0f 88 04 01 00 00    	js     801fdd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed9:	83 ec 0c             	sub    $0xc,%esp
  801edc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edf:	50                   	push   %eax
  801ee0:	e8 7a f1 ff ff       	call   80105f <fd_alloc>
  801ee5:	89 c3                	mov    %eax,%ebx
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	85 c0                	test   %eax,%eax
  801eec:	0f 88 db 00 00 00    	js     801fcd <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	68 07 04 00 00       	push   $0x407
  801efa:	ff 75 f0             	pushl  -0x10(%ebp)
  801efd:	6a 00                	push   $0x0
  801eff:	e8 3f ee ff ff       	call   800d43 <sys_page_alloc>
  801f04:	89 c3                	mov    %eax,%ebx
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	0f 88 bc 00 00 00    	js     801fcd <pipe+0x131>
	va = fd2data(fd0);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	e8 2c f1 ff ff       	call   801048 <fd2data>
  801f1c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1e:	83 c4 0c             	add    $0xc,%esp
  801f21:	68 07 04 00 00       	push   $0x407
  801f26:	50                   	push   %eax
  801f27:	6a 00                	push   $0x0
  801f29:	e8 15 ee ff ff       	call   800d43 <sys_page_alloc>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	0f 88 82 00 00 00    	js     801fbd <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f41:	e8 02 f1 ff ff       	call   801048 <fd2data>
  801f46:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f4d:	50                   	push   %eax
  801f4e:	6a 00                	push   $0x0
  801f50:	56                   	push   %esi
  801f51:	6a 00                	push   $0x0
  801f53:	e8 2e ee ff ff       	call   800d86 <sys_page_map>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 20             	add    $0x20,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	78 4e                	js     801faf <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f61:	a1 40 30 80 00       	mov    0x803040,%eax
  801f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f69:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f78:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 a9 f0 ff ff       	call   801038 <fd2num>
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f92:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f94:	83 c4 04             	add    $0x4,%esp
  801f97:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9a:	e8 99 f0 ff ff       	call   801038 <fd2num>
  801f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa5:	83 c4 10             	add    $0x10,%esp
  801fa8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fad:	eb 2e                	jmp    801fdd <pipe+0x141>
	sys_page_unmap(0, va);
  801faf:	83 ec 08             	sub    $0x8,%esp
  801fb2:	56                   	push   %esi
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 0e ee ff ff       	call   800dc8 <sys_page_unmap>
  801fba:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc3:	6a 00                	push   $0x0
  801fc5:	e8 fe ed ff ff       	call   800dc8 <sys_page_unmap>
  801fca:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fcd:	83 ec 08             	sub    $0x8,%esp
  801fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd3:	6a 00                	push   $0x0
  801fd5:	e8 ee ed ff ff       	call   800dc8 <sys_page_unmap>
  801fda:	83 c4 10             	add    $0x10,%esp
}
  801fdd:	89 d8                	mov    %ebx,%eax
  801fdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe2:	5b                   	pop    %ebx
  801fe3:	5e                   	pop    %esi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    

00801fe6 <pipeisclosed>:
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fef:	50                   	push   %eax
  801ff0:	ff 75 08             	pushl  0x8(%ebp)
  801ff3:	e8 b9 f0 ff ff       	call   8010b1 <fd_lookup>
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 18                	js     802017 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	ff 75 f4             	pushl  -0xc(%ebp)
  802005:	e8 3e f0 ff ff       	call   801048 <fd2data>
	return _pipeisclosed(fd, p);
  80200a:	89 c2                	mov    %eax,%edx
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	e8 2f fd ff ff       	call   801d43 <_pipeisclosed>
  802014:	83 c4 10             	add    $0x10,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
  80201e:	c3                   	ret    

0080201f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802025:	68 cf 2a 80 00       	push   $0x802acf
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	e8 1f e9 ff ff       	call   800951 <strcpy>
	return 0;
}
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <devcons_write>:
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	57                   	push   %edi
  80203d:	56                   	push   %esi
  80203e:	53                   	push   %ebx
  80203f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802045:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80204a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802050:	3b 75 10             	cmp    0x10(%ebp),%esi
  802053:	73 31                	jae    802086 <devcons_write+0x4d>
		m = n - tot;
  802055:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802058:	29 f3                	sub    %esi,%ebx
  80205a:	83 fb 7f             	cmp    $0x7f,%ebx
  80205d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802062:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	53                   	push   %ebx
  802069:	89 f0                	mov    %esi,%eax
  80206b:	03 45 0c             	add    0xc(%ebp),%eax
  80206e:	50                   	push   %eax
  80206f:	57                   	push   %edi
  802070:	e8 6a ea ff ff       	call   800adf <memmove>
		sys_cputs(buf, m);
  802075:	83 c4 08             	add    $0x8,%esp
  802078:	53                   	push   %ebx
  802079:	57                   	push   %edi
  80207a:	e8 08 ec ff ff       	call   800c87 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80207f:	01 de                	add    %ebx,%esi
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	eb ca                	jmp    802050 <devcons_write+0x17>
}
  802086:	89 f0                	mov    %esi,%eax
  802088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208b:	5b                   	pop    %ebx
  80208c:	5e                   	pop    %esi
  80208d:	5f                   	pop    %edi
  80208e:	5d                   	pop    %ebp
  80208f:	c3                   	ret    

00802090 <devcons_read>:
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80209b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80209f:	74 21                	je     8020c2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020a1:	e8 ff eb ff ff       	call   800ca5 <sys_cgetc>
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 07                	jne    8020b1 <devcons_read+0x21>
		sys_yield();
  8020aa:	e8 75 ec ff ff       	call   800d24 <sys_yield>
  8020af:	eb f0                	jmp    8020a1 <devcons_read+0x11>
	if (c < 0)
  8020b1:	78 0f                	js     8020c2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020b3:	83 f8 04             	cmp    $0x4,%eax
  8020b6:	74 0c                	je     8020c4 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	88 02                	mov    %al,(%edx)
	return 1;
  8020bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    
		return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c9:	eb f7                	jmp    8020c2 <devcons_read+0x32>

008020cb <cputchar>:
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d7:	6a 01                	push   $0x1
  8020d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 a5 eb ff ff       	call   800c87 <sys_cputs>
}
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <getchar>:
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020ed:	6a 01                	push   $0x1
  8020ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f2:	50                   	push   %eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 27 f2 ff ff       	call   801321 <read>
	if (r < 0)
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 06                	js     802107 <getchar+0x20>
	if (r < 1)
  802101:	74 06                	je     802109 <getchar+0x22>
	return c;
  802103:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    
		return -E_EOF;
  802109:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80210e:	eb f7                	jmp    802107 <getchar+0x20>

00802110 <iscons>:
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802119:	50                   	push   %eax
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	e8 8f ef ff ff       	call   8010b1 <fd_lookup>
  802122:	83 c4 10             	add    $0x10,%esp
  802125:	85 c0                	test   %eax,%eax
  802127:	78 11                	js     80213a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802132:	39 10                	cmp    %edx,(%eax)
  802134:	0f 94 c0             	sete   %al
  802137:	0f b6 c0             	movzbl %al,%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <opencons>:
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802145:	50                   	push   %eax
  802146:	e8 14 ef ff ff       	call   80105f <fd_alloc>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 3a                	js     80218c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	68 07 04 00 00       	push   $0x407
  80215a:	ff 75 f4             	pushl  -0xc(%ebp)
  80215d:	6a 00                	push   $0x0
  80215f:	e8 df eb ff ff       	call   800d43 <sys_page_alloc>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	78 21                	js     80218c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802174:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	50                   	push   %eax
  802184:	e8 af ee ff ff       	call   801038 <fd2num>
  802189:	83 c4 10             	add    $0x10,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	56                   	push   %esi
  802192:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802193:	a1 08 40 80 00       	mov    0x804008,%eax
  802198:	8b 40 48             	mov    0x48(%eax),%eax
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	68 00 2b 80 00       	push   $0x802b00
  8021a3:	50                   	push   %eax
  8021a4:	68 e6 25 80 00       	push   $0x8025e6
  8021a9:	e8 44 e0 ff ff       	call   8001f2 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021b1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8021b7:	e8 49 eb ff ff       	call   800d05 <sys_getenvid>
  8021bc:	83 c4 04             	add    $0x4,%esp
  8021bf:	ff 75 0c             	pushl  0xc(%ebp)
  8021c2:	ff 75 08             	pushl  0x8(%ebp)
  8021c5:	56                   	push   %esi
  8021c6:	50                   	push   %eax
  8021c7:	68 dc 2a 80 00       	push   $0x802adc
  8021cc:	e8 21 e0 ff ff       	call   8001f2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021d1:	83 c4 18             	add    $0x18,%esp
  8021d4:	53                   	push   %ebx
  8021d5:	ff 75 10             	pushl  0x10(%ebp)
  8021d8:	e8 c4 df ff ff       	call   8001a1 <vcprintf>
	cprintf("\n");
  8021dd:	c7 04 24 aa 25 80 00 	movl   $0x8025aa,(%esp)
  8021e4:	e8 09 e0 ff ff       	call   8001f2 <cprintf>
  8021e9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ec:	cc                   	int3   
  8021ed:	eb fd                	jmp    8021ec <_panic+0x5e>

008021ef <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	56                   	push   %esi
  8021f3:	53                   	push   %ebx
  8021f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021fd:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021ff:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802204:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802207:	83 ec 0c             	sub    $0xc,%esp
  80220a:	50                   	push   %eax
  80220b:	e8 e3 ec ff ff       	call   800ef3 <sys_ipc_recv>
	if(ret < 0){
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	85 c0                	test   %eax,%eax
  802215:	78 2b                	js     802242 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802217:	85 f6                	test   %esi,%esi
  802219:	74 0a                	je     802225 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80221b:	a1 08 40 80 00       	mov    0x804008,%eax
  802220:	8b 40 78             	mov    0x78(%eax),%eax
  802223:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802225:	85 db                	test   %ebx,%ebx
  802227:	74 0a                	je     802233 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802229:	a1 08 40 80 00       	mov    0x804008,%eax
  80222e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802231:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802233:	a1 08 40 80 00       	mov    0x804008,%eax
  802238:	8b 40 74             	mov    0x74(%eax),%eax
}
  80223b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5e                   	pop    %esi
  802240:	5d                   	pop    %ebp
  802241:	c3                   	ret    
		if(from_env_store)
  802242:	85 f6                	test   %esi,%esi
  802244:	74 06                	je     80224c <ipc_recv+0x5d>
			*from_env_store = 0;
  802246:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80224c:	85 db                	test   %ebx,%ebx
  80224e:	74 eb                	je     80223b <ipc_recv+0x4c>
			*perm_store = 0;
  802250:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802256:	eb e3                	jmp    80223b <ipc_recv+0x4c>

00802258 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	57                   	push   %edi
  80225c:	56                   	push   %esi
  80225d:	53                   	push   %ebx
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	8b 7d 08             	mov    0x8(%ebp),%edi
  802264:	8b 75 0c             	mov    0xc(%ebp),%esi
  802267:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80226a:	85 db                	test   %ebx,%ebx
  80226c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802271:	0f 44 d8             	cmove  %eax,%ebx
  802274:	eb 05                	jmp    80227b <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802276:	e8 a9 ea ff ff       	call   800d24 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80227b:	ff 75 14             	pushl  0x14(%ebp)
  80227e:	53                   	push   %ebx
  80227f:	56                   	push   %esi
  802280:	57                   	push   %edi
  802281:	e8 4a ec ff ff       	call   800ed0 <sys_ipc_try_send>
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 1b                	je     8022a8 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80228d:	79 e7                	jns    802276 <ipc_send+0x1e>
  80228f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802292:	74 e2                	je     802276 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	68 07 2b 80 00       	push   $0x802b07
  80229c:	6a 46                	push   $0x46
  80229e:	68 1c 2b 80 00       	push   $0x802b1c
  8022a3:	e8 e6 fe ff ff       	call   80218e <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5f                   	pop    %edi
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    

008022b0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022bb:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022c1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c7:	8b 52 50             	mov    0x50(%edx),%edx
  8022ca:	39 ca                	cmp    %ecx,%edx
  8022cc:	74 11                	je     8022df <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022ce:	83 c0 01             	add    $0x1,%eax
  8022d1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022d6:	75 e3                	jne    8022bb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dd:	eb 0e                	jmp    8022ed <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ea:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ed:	5d                   	pop    %ebp
  8022ee:	c3                   	ret    

008022ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f5:	89 d0                	mov    %edx,%eax
  8022f7:	c1 e8 16             	shr    $0x16,%eax
  8022fa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802306:	f6 c1 01             	test   $0x1,%cl
  802309:	74 1d                	je     802328 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80230b:	c1 ea 0c             	shr    $0xc,%edx
  80230e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802315:	f6 c2 01             	test   $0x1,%dl
  802318:	74 0e                	je     802328 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80231a:	c1 ea 0c             	shr    $0xc,%edx
  80231d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802324:	ef 
  802325:	0f b7 c0             	movzwl %ax,%eax
}
  802328:	5d                   	pop    %ebp
  802329:	c3                   	ret    
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 4d                	jne    802398 <__udivdi3+0x68>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	76 19                	jbe    802368 <__udivdi3+0x38>
  80234f:	31 ff                	xor    %edi,%edi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f2                	mov    %esi,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 d9                	mov    %ebx,%ecx
  80236a:	85 db                	test   %ebx,%ebx
  80236c:	75 0b                	jne    802379 <__udivdi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	31 d2                	xor    %edx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	f7 f1                	div    %ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f7                	mov    %esi,%edi
  802385:	f7 f1                	div    %ecx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f2                	cmp    %esi,%edx
  80239a:	77 1c                	ja     8023b8 <__udivdi3+0x88>
  80239c:	0f bd fa             	bsr    %edx,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 2c                	jne    8023d0 <__udivdi3+0xa0>
  8023a4:	39 f2                	cmp    %esi,%edx
  8023a6:	72 06                	jb     8023ae <__udivdi3+0x7e>
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	39 eb                	cmp    %ebp,%ebx
  8023ac:	77 a9                	ja     802357 <__udivdi3+0x27>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb a2                	jmp    802357 <__udivdi3+0x27>
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 27 ff ff ff       	jmp    802357 <__udivdi3+0x27>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 1d ff ff ff       	jmp    802357 <__udivdi3+0x27>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802457:	89 da                	mov    %ebx,%edx
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 43                	jne    8024a0 <__umoddi3+0x60>
  80245d:	39 df                	cmp    %ebx,%edi
  80245f:	76 17                	jbe    802478 <__umoddi3+0x38>
  802461:	89 f0                	mov    %esi,%eax
  802463:	f7 f7                	div    %edi
  802465:	89 d0                	mov    %edx,%eax
  802467:	31 d2                	xor    %edx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 fd                	mov    %edi,%ebp
  80247a:	85 ff                	test   %edi,%edi
  80247c:	75 0b                	jne    802489 <__umoddi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f7                	div    %edi
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d8                	mov    %ebx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f5                	div    %ebp
  80248f:	89 f0                	mov    %esi,%eax
  802491:	f7 f5                	div    %ebp
  802493:	89 d0                	mov    %edx,%eax
  802495:	eb d0                	jmp    802467 <__umoddi3+0x27>
  802497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 f1                	mov    %esi,%ecx
  8024a2:	39 d8                	cmp    %ebx,%eax
  8024a4:	76 0a                	jbe    8024b0 <__umoddi3+0x70>
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	75 20                	jne    8024d8 <__umoddi3+0x98>
  8024b8:	39 d8                	cmp    %ebx,%eax
  8024ba:	0f 82 b0 00 00 00    	jb     802570 <__umoddi3+0x130>
  8024c0:	39 f7                	cmp    %esi,%edi
  8024c2:	0f 86 a8 00 00 00    	jbe    802570 <__umoddi3+0x130>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0xfb>
  802535:	75 10                	jne    802547 <__umoddi3+0x107>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x107>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 da                	mov    %ebx,%edx
  802572:	29 fe                	sub    %edi,%esi
  802574:	19 c2                	sbb    %eax,%edx
  802576:	89 f1                	mov    %esi,%ecx
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	e9 4b ff ff ff       	jmp    8024ca <__umoddi3+0x8a>
