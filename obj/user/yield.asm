
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 04 20 80 00       	mov    0x802004,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 20 12 80 00       	push   $0x801220
  800048:	e8 89 01 00 00       	call   8001d6 <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 ae 0c 00 00       	call   800d08 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 04 20 80 00       	mov    0x802004,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 40 12 80 00       	push   $0x801240
  80006c:	e8 65 01 00 00       	call   8001d6 <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 04 20 80 00       	mov    0x802004,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 6c 12 80 00       	push   $0x80126c
  80008d:	e8 44 01 00 00       	call   8001d6 <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	57                   	push   %edi
  80009e:	56                   	push   %esi
  80009f:	53                   	push   %ebx
  8000a0:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a3:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000aa:	00 00 00 
	envid_t find = sys_getenvid();
  8000ad:	e8 37 0c 00 00       	call   800ce9 <sys_getenvid>
  8000b2:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8000b8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c7:	eb 0b                	jmp    8000d4 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000c9:	83 c2 01             	add    $0x1,%edx
  8000cc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d2:	74 21                	je     8000f5 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000d4:	89 d1                	mov    %edx,%ecx
  8000d6:	c1 e1 07             	shl    $0x7,%ecx
  8000d9:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000df:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e2:	39 c1                	cmp    %eax,%ecx
  8000e4:	75 e3                	jne    8000c9 <libmain+0x2f>
  8000e6:	89 d3                	mov    %edx,%ebx
  8000e8:	c1 e3 07             	shl    $0x7,%ebx
  8000eb:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f1:	89 fe                	mov    %edi,%esi
  8000f3:	eb d4                	jmp    8000c9 <libmain+0x2f>
  8000f5:	89 f0                	mov    %esi,%eax
  8000f7:	84 c0                	test   %al,%al
  8000f9:	74 06                	je     800101 <libmain+0x67>
  8000fb:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800105:	7e 0a                	jle    800111 <libmain+0x77>
		binaryname = argv[0];
  800107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010a:	8b 00                	mov    (%eax),%eax
  80010c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	ff 75 0c             	pushl  0xc(%ebp)
  800117:	ff 75 08             	pushl  0x8(%ebp)
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0b 00 00 00       	call   80012f <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5f                   	pop    %edi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800135:	6a 00                	push   $0x0
  800137:	e8 6c 0b 00 00       	call   800ca8 <sys_env_destroy>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	53                   	push   %ebx
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014b:	8b 13                	mov    (%ebx),%edx
  80014d:	8d 42 01             	lea    0x1(%edx),%eax
  800150:	89 03                	mov    %eax,(%ebx)
  800152:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800155:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800159:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015e:	74 09                	je     800169 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800160:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800167:	c9                   	leave  
  800168:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	68 ff 00 00 00       	push   $0xff
  800171:	8d 43 08             	lea    0x8(%ebx),%eax
  800174:	50                   	push   %eax
  800175:	e8 f1 0a 00 00       	call   800c6b <sys_cputs>
		b->idx = 0;
  80017a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800180:	83 c4 10             	add    $0x10,%esp
  800183:	eb db                	jmp    800160 <putch+0x1f>

00800185 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800195:	00 00 00 
	b.cnt = 0;
  800198:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a2:	ff 75 0c             	pushl  0xc(%ebp)
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ae:	50                   	push   %eax
  8001af:	68 41 01 80 00       	push   $0x800141
  8001b4:	e8 4a 01 00 00       	call   800303 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b9:	83 c4 08             	add    $0x8,%esp
  8001bc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 9d 0a 00 00       	call   800c6b <sys_cputs>

	return b.cnt;
}
  8001ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    

008001d6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001dc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001df:	50                   	push   %eax
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 9d ff ff ff       	call   800185 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	57                   	push   %edi
  8001ee:	56                   	push   %esi
  8001ef:	53                   	push   %ebx
  8001f0:	83 ec 1c             	sub    $0x1c,%esp
  8001f3:	89 c6                	mov    %eax,%esi
  8001f5:	89 d7                	mov    %edx,%edi
  8001f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800200:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800203:	8b 45 10             	mov    0x10(%ebp),%eax
  800206:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800209:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020d:	74 2c                	je     80023b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80020f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800212:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800219:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80021c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80021f:	39 c2                	cmp    %eax,%edx
  800221:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800224:	73 43                	jae    800269 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800226:	83 eb 01             	sub    $0x1,%ebx
  800229:	85 db                	test   %ebx,%ebx
  80022b:	7e 6c                	jle    800299 <printnum+0xaf>
				putch(padc, putdat);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	57                   	push   %edi
  800231:	ff 75 18             	pushl  0x18(%ebp)
  800234:	ff d6                	call   *%esi
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	eb eb                	jmp    800226 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	6a 20                	push   $0x20
  800240:	6a 00                	push   $0x0
  800242:	50                   	push   %eax
  800243:	ff 75 e4             	pushl  -0x1c(%ebp)
  800246:	ff 75 e0             	pushl  -0x20(%ebp)
  800249:	89 fa                	mov    %edi,%edx
  80024b:	89 f0                	mov    %esi,%eax
  80024d:	e8 98 ff ff ff       	call   8001ea <printnum>
		while (--width > 0)
  800252:	83 c4 20             	add    $0x20,%esp
  800255:	83 eb 01             	sub    $0x1,%ebx
  800258:	85 db                	test   %ebx,%ebx
  80025a:	7e 65                	jle    8002c1 <printnum+0xd7>
			putch(padc, putdat);
  80025c:	83 ec 08             	sub    $0x8,%esp
  80025f:	57                   	push   %edi
  800260:	6a 20                	push   $0x20
  800262:	ff d6                	call   *%esi
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	eb ec                	jmp    800255 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	ff 75 18             	pushl  0x18(%ebp)
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	53                   	push   %ebx
  800273:	50                   	push   %eax
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 d8             	pushl  -0x28(%ebp)
  80027d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800280:	ff 75 e0             	pushl  -0x20(%ebp)
  800283:	e8 38 0d 00 00       	call   800fc0 <__udivdi3>
  800288:	83 c4 18             	add    $0x18,%esp
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	89 fa                	mov    %edi,%edx
  80028f:	89 f0                	mov    %esi,%eax
  800291:	e8 54 ff ff ff       	call   8001ea <printnum>
  800296:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	57                   	push   %edi
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ac:	e8 1f 0e 00 00       	call   8010d0 <__umoddi3>
  8002b1:	83 c4 14             	add    $0x14,%esp
  8002b4:	0f be 80 95 12 80 00 	movsbl 0x801295(%eax),%eax
  8002bb:	50                   	push   %eax
  8002bc:	ff d6                	call   *%esi
  8002be:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5f                   	pop    %edi
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    

008002c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d8:	73 0a                	jae    8002e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	88 02                	mov    %al,(%edx)
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <printfmt>:
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ef:	50                   	push   %eax
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	e8 05 00 00 00       	call   800303 <vprintfmt>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vprintfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 3c             	sub    $0x3c,%esp
  80030c:	8b 75 08             	mov    0x8(%ebp),%esi
  80030f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800312:	8b 7d 10             	mov    0x10(%ebp),%edi
  800315:	e9 32 04 00 00       	jmp    80074c <vprintfmt+0x449>
		padc = ' ';
  80031a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80031e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800325:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80032c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800333:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80033a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800341:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8d 47 01             	lea    0x1(%edi),%eax
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	0f b6 17             	movzbl (%edi),%edx
  80034f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800352:	3c 55                	cmp    $0x55,%al
  800354:	0f 87 12 05 00 00    	ja     80086c <vprintfmt+0x569>
  80035a:	0f b6 c0             	movzbl %al,%eax
  80035d:	ff 24 85 80 14 80 00 	jmp    *0x801480(,%eax,4)
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800367:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80036b:	eb d9                	jmp    800346 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800370:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800374:	eb d0                	jmp    800346 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800376:	0f b6 d2             	movzbl %dl,%edx
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037c:	b8 00 00 00 00       	mov    $0x0,%eax
  800381:	89 75 08             	mov    %esi,0x8(%ebp)
  800384:	eb 03                	jmp    800389 <vprintfmt+0x86>
  800386:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800389:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800390:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800393:	8d 72 d0             	lea    -0x30(%edx),%esi
  800396:	83 fe 09             	cmp    $0x9,%esi
  800399:	76 eb                	jbe    800386 <vprintfmt+0x83>
  80039b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039e:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a1:	eb 14                	jmp    8003b7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8d 40 04             	lea    0x4(%eax),%eax
  8003b1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bb:	79 89                	jns    800346 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ca:	e9 77 ff ff ff       	jmp    800346 <vprintfmt+0x43>
  8003cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d2:	85 c0                	test   %eax,%eax
  8003d4:	0f 48 c1             	cmovs  %ecx,%eax
  8003d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003dd:	e9 64 ff ff ff       	jmp    800346 <vprintfmt+0x43>
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ec:	e9 55 ff ff ff       	jmp    800346 <vprintfmt+0x43>
			lflag++;
  8003f1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f8:	e9 49 ff ff ff       	jmp    800346 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	8d 78 04             	lea    0x4(%eax),%edi
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	53                   	push   %ebx
  800407:	ff 30                	pushl  (%eax)
  800409:	ff d6                	call   *%esi
			break;
  80040b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800411:	e9 33 03 00 00       	jmp    800749 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8d 78 04             	lea    0x4(%eax),%edi
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	99                   	cltd   
  80041f:	31 d0                	xor    %edx,%eax
  800421:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800423:	83 f8 0f             	cmp    $0xf,%eax
  800426:	7f 23                	jg     80044b <vprintfmt+0x148>
  800428:	8b 14 85 e0 15 80 00 	mov    0x8015e0(,%eax,4),%edx
  80042f:	85 d2                	test   %edx,%edx
  800431:	74 18                	je     80044b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800433:	52                   	push   %edx
  800434:	68 b6 12 80 00       	push   $0x8012b6
  800439:	53                   	push   %ebx
  80043a:	56                   	push   %esi
  80043b:	e8 a6 fe ff ff       	call   8002e6 <printfmt>
  800440:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800443:	89 7d 14             	mov    %edi,0x14(%ebp)
  800446:	e9 fe 02 00 00       	jmp    800749 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80044b:	50                   	push   %eax
  80044c:	68 ad 12 80 00       	push   $0x8012ad
  800451:	53                   	push   %ebx
  800452:	56                   	push   %esi
  800453:	e8 8e fe ff ff       	call   8002e6 <printfmt>
  800458:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045e:	e9 e6 02 00 00       	jmp    800749 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	83 c0 04             	add    $0x4,%eax
  800469:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800471:	85 c9                	test   %ecx,%ecx
  800473:	b8 a6 12 80 00       	mov    $0x8012a6,%eax
  800478:	0f 45 c1             	cmovne %ecx,%eax
  80047b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800482:	7e 06                	jle    80048a <vprintfmt+0x187>
  800484:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800488:	75 0d                	jne    800497 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048d:	89 c7                	mov    %eax,%edi
  80048f:	03 45 e0             	add    -0x20(%ebp),%eax
  800492:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800495:	eb 53                	jmp    8004ea <vprintfmt+0x1e7>
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	ff 75 d8             	pushl  -0x28(%ebp)
  80049d:	50                   	push   %eax
  80049e:	e8 71 04 00 00       	call   800914 <strnlen>
  8004a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a6:	29 c1                	sub    %eax,%ecx
  8004a8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004ab:	83 c4 10             	add    $0x10,%esp
  8004ae:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b7:	eb 0f                	jmp    8004c8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	53                   	push   %ebx
  8004bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c2:	83 ef 01             	sub    $0x1,%edi
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	7f ed                	jg     8004b9 <vprintfmt+0x1b6>
  8004cc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004cf:	85 c9                	test   %ecx,%ecx
  8004d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d6:	0f 49 c1             	cmovns %ecx,%eax
  8004d9:	29 c1                	sub    %eax,%ecx
  8004db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004de:	eb aa                	jmp    80048a <vprintfmt+0x187>
					putch(ch, putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	53                   	push   %ebx
  8004e4:	52                   	push   %edx
  8004e5:	ff d6                	call   *%esi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ed:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ef:	83 c7 01             	add    $0x1,%edi
  8004f2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f6:	0f be d0             	movsbl %al,%edx
  8004f9:	85 d2                	test   %edx,%edx
  8004fb:	74 4b                	je     800548 <vprintfmt+0x245>
  8004fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800501:	78 06                	js     800509 <vprintfmt+0x206>
  800503:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800507:	78 1e                	js     800527 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800509:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80050d:	74 d1                	je     8004e0 <vprintfmt+0x1dd>
  80050f:	0f be c0             	movsbl %al,%eax
  800512:	83 e8 20             	sub    $0x20,%eax
  800515:	83 f8 5e             	cmp    $0x5e,%eax
  800518:	76 c6                	jbe    8004e0 <vprintfmt+0x1dd>
					putch('?', putdat);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	6a 3f                	push   $0x3f
  800520:	ff d6                	call   *%esi
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	eb c3                	jmp    8004ea <vprintfmt+0x1e7>
  800527:	89 cf                	mov    %ecx,%edi
  800529:	eb 0e                	jmp    800539 <vprintfmt+0x236>
				putch(' ', putdat);
  80052b:	83 ec 08             	sub    $0x8,%esp
  80052e:	53                   	push   %ebx
  80052f:	6a 20                	push   $0x20
  800531:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800533:	83 ef 01             	sub    $0x1,%edi
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	85 ff                	test   %edi,%edi
  80053b:	7f ee                	jg     80052b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80053d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800540:	89 45 14             	mov    %eax,0x14(%ebp)
  800543:	e9 01 02 00 00       	jmp    800749 <vprintfmt+0x446>
  800548:	89 cf                	mov    %ecx,%edi
  80054a:	eb ed                	jmp    800539 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80054c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80054f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800556:	e9 eb fd ff ff       	jmp    800346 <vprintfmt+0x43>
	if (lflag >= 2)
  80055b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80055f:	7f 21                	jg     800582 <vprintfmt+0x27f>
	else if (lflag)
  800561:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800565:	74 68                	je     8005cf <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056f:	89 c1                	mov    %eax,%ecx
  800571:	c1 f9 1f             	sar    $0x1f,%ecx
  800574:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8d 40 04             	lea    0x4(%eax),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	eb 17                	jmp    800599 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 50 04             	mov    0x4(%eax),%edx
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 40 08             	lea    0x8(%eax),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a9:	78 3f                	js     8005ea <vprintfmt+0x2e7>
			base = 10;
  8005ab:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b4:	0f 84 71 01 00 00    	je     80072b <vprintfmt+0x428>
				putch('+', putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	6a 2b                	push   $0x2b
  8005c0:	ff d6                	call   *%esi
  8005c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ca:	e9 5c 01 00 00       	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb af                	jmp    800599 <vprintfmt+0x296>
				putch('-', putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	53                   	push   %ebx
  8005ee:	6a 2d                	push   $0x2d
  8005f0:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f8:	f7 d8                	neg    %eax
  8005fa:	83 d2 00             	adc    $0x0,%edx
  8005fd:	f7 da                	neg    %edx
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800605:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060d:	e9 19 01 00 00       	jmp    80072b <vprintfmt+0x428>
	if (lflag >= 2)
  800612:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800616:	7f 29                	jg     800641 <vprintfmt+0x33e>
	else if (lflag)
  800618:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061c:	74 44                	je     800662 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	ba 00 00 00 00       	mov    $0x0,%edx
  800628:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800637:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063c:	e9 ea 00 00 00       	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 50 04             	mov    0x4(%eax),%edx
  800647:	8b 00                	mov    (%eax),%eax
  800649:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 40 08             	lea    0x8(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800658:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065d:	e9 c9 00 00 00       	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	ba 00 00 00 00       	mov    $0x0,%edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800680:	e9 a6 00 00 00       	jmp    80072b <vprintfmt+0x428>
			putch('0', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 30                	push   $0x30
  80068b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800694:	7f 26                	jg     8006bc <vprintfmt+0x3b9>
	else if (lflag)
  800696:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80069a:	74 3e                	je     8006da <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ba:	eb 6f                	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 50 04             	mov    0x4(%eax),%edx
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8d 40 08             	lea    0x8(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d8:	eb 51                	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f8:	eb 31                	jmp    80072b <vprintfmt+0x428>
			putch('0', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 30                	push   $0x30
  800700:	ff d6                	call   *%esi
			putch('x', putdat);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 78                	push   $0x78
  800708:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80071a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800726:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800732:	52                   	push   %edx
  800733:	ff 75 e0             	pushl  -0x20(%ebp)
  800736:	50                   	push   %eax
  800737:	ff 75 dc             	pushl  -0x24(%ebp)
  80073a:	ff 75 d8             	pushl  -0x28(%ebp)
  80073d:	89 da                	mov    %ebx,%edx
  80073f:	89 f0                	mov    %esi,%eax
  800741:	e8 a4 fa ff ff       	call   8001ea <printnum>
			break;
  800746:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	83 c7 01             	add    $0x1,%edi
  80074f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800753:	83 f8 25             	cmp    $0x25,%eax
  800756:	0f 84 be fb ff ff    	je     80031a <vprintfmt+0x17>
			if (ch == '\0')
  80075c:	85 c0                	test   %eax,%eax
  80075e:	0f 84 28 01 00 00    	je     80088c <vprintfmt+0x589>
			putch(ch, putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	50                   	push   %eax
  800769:	ff d6                	call   *%esi
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	eb dc                	jmp    80074c <vprintfmt+0x449>
	if (lflag >= 2)
  800770:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800774:	7f 26                	jg     80079c <vprintfmt+0x499>
	else if (lflag)
  800776:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80077a:	74 41                	je     8007bd <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	ba 00 00 00 00       	mov    $0x0,%edx
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
  80079a:	eb 8f                	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 50 04             	mov    0x4(%eax),%edx
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8d 40 08             	lea    0x8(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b8:	e9 6e ff ff ff       	jmp    80072b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007db:	e9 4b ff ff ff       	jmp    80072b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	83 c0 04             	add    $0x4,%eax
  8007e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	85 c0                	test   %eax,%eax
  8007f0:	74 14                	je     800806 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f2:	8b 13                	mov    (%ebx),%edx
  8007f4:	83 fa 7f             	cmp    $0x7f,%edx
  8007f7:	7f 37                	jg     800830 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007f9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800801:	e9 43 ff ff ff       	jmp    800749 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800806:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080b:	bf cd 13 80 00       	mov    $0x8013cd,%edi
							putch(ch, putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	53                   	push   %ebx
  800814:	50                   	push   %eax
  800815:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800817:	83 c7 01             	add    $0x1,%edi
  80081a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	85 c0                	test   %eax,%eax
  800823:	75 eb                	jne    800810 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800825:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	e9 19 ff ff ff       	jmp    800749 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800830:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800832:	b8 0a 00 00 00       	mov    $0xa,%eax
  800837:	bf 05 14 80 00       	mov    $0x801405,%edi
							putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	50                   	push   %eax
  800841:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800843:	83 c7 01             	add    $0x1,%edi
  800846:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	85 c0                	test   %eax,%eax
  80084f:	75 eb                	jne    80083c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800851:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	e9 ed fe ff ff       	jmp    800749 <vprintfmt+0x446>
			putch(ch, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 25                	push   $0x25
  800862:	ff d6                	call   *%esi
			break;
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	e9 dd fe ff ff       	jmp    800749 <vprintfmt+0x446>
			putch('%', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	53                   	push   %ebx
  800870:	6a 25                	push   $0x25
  800872:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 f8                	mov    %edi,%eax
  800879:	eb 03                	jmp    80087e <vprintfmt+0x57b>
  80087b:	83 e8 01             	sub    $0x1,%eax
  80087e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800882:	75 f7                	jne    80087b <vprintfmt+0x578>
  800884:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800887:	e9 bd fe ff ff       	jmp    800749 <vprintfmt+0x446>
}
  80088c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088f:	5b                   	pop    %ebx
  800890:	5e                   	pop    %esi
  800891:	5f                   	pop    %edi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 18             	sub    $0x18,%esp
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 26                	je     8008db <vsnprintf+0x47>
  8008b5:	85 d2                	test   %edx,%edx
  8008b7:	7e 22                	jle    8008db <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b9:	ff 75 14             	pushl  0x14(%ebp)
  8008bc:	ff 75 10             	pushl  0x10(%ebp)
  8008bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c2:	50                   	push   %eax
  8008c3:	68 c9 02 80 00       	push   $0x8002c9
  8008c8:	e8 36 fa ff ff       	call   800303 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
}
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    
		return -E_INVAL;
  8008db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e0:	eb f7                	jmp    8008d9 <vsnprintf+0x45>

008008e2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008eb:	50                   	push   %eax
  8008ec:	ff 75 10             	pushl  0x10(%ebp)
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	ff 75 08             	pushl  0x8(%ebp)
  8008f5:	e8 9a ff ff ff       	call   800894 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800902:	b8 00 00 00 00       	mov    $0x0,%eax
  800907:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090b:	74 05                	je     800912 <strlen+0x16>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
  800910:	eb f5                	jmp    800907 <strlen+0xb>
	return n;
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091d:	ba 00 00 00 00       	mov    $0x0,%edx
  800922:	39 c2                	cmp    %eax,%edx
  800924:	74 0d                	je     800933 <strnlen+0x1f>
  800926:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80092a:	74 05                	je     800931 <strnlen+0x1d>
		n++;
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	eb f1                	jmp    800922 <strnlen+0xe>
  800931:	89 d0                	mov    %edx,%eax
	return n;
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	53                   	push   %ebx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093f:	ba 00 00 00 00       	mov    $0x0,%edx
  800944:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800948:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80094b:	83 c2 01             	add    $0x1,%edx
  80094e:	84 c9                	test   %cl,%cl
  800950:	75 f2                	jne    800944 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800952:	5b                   	pop    %ebx
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	83 ec 10             	sub    $0x10,%esp
  80095c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095f:	53                   	push   %ebx
  800960:	e8 97 ff ff ff       	call   8008fc <strlen>
  800965:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	01 d8                	add    %ebx,%eax
  80096d:	50                   	push   %eax
  80096e:	e8 c2 ff ff ff       	call   800935 <strcpy>
	return dst;
}
  800973:	89 d8                	mov    %ebx,%eax
  800975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800985:	89 c6                	mov    %eax,%esi
  800987:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098a:	89 c2                	mov    %eax,%edx
  80098c:	39 f2                	cmp    %esi,%edx
  80098e:	74 11                	je     8009a1 <strncpy+0x27>
		*dst++ = *src;
  800990:	83 c2 01             	add    $0x1,%edx
  800993:	0f b6 19             	movzbl (%ecx),%ebx
  800996:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800999:	80 fb 01             	cmp    $0x1,%bl
  80099c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80099f:	eb eb                	jmp    80098c <strncpy+0x12>
	}
	return ret;
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5e                   	pop    %esi
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	56                   	push   %esi
  8009a9:	53                   	push   %ebx
  8009aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b0:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b5:	85 d2                	test   %edx,%edx
  8009b7:	74 21                	je     8009da <strlcpy+0x35>
  8009b9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009bd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009bf:	39 c2                	cmp    %eax,%edx
  8009c1:	74 14                	je     8009d7 <strlcpy+0x32>
  8009c3:	0f b6 19             	movzbl (%ecx),%ebx
  8009c6:	84 db                	test   %bl,%bl
  8009c8:	74 0b                	je     8009d5 <strlcpy+0x30>
			*dst++ = *src++;
  8009ca:	83 c1 01             	add    $0x1,%ecx
  8009cd:	83 c2 01             	add    $0x1,%edx
  8009d0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d3:	eb ea                	jmp    8009bf <strlcpy+0x1a>
  8009d5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009da:	29 f0                	sub    %esi,%eax
}
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5d                   	pop    %ebp
  8009df:	c3                   	ret    

008009e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e9:	0f b6 01             	movzbl (%ecx),%eax
  8009ec:	84 c0                	test   %al,%al
  8009ee:	74 0c                	je     8009fc <strcmp+0x1c>
  8009f0:	3a 02                	cmp    (%edx),%al
  8009f2:	75 08                	jne    8009fc <strcmp+0x1c>
		p++, q++;
  8009f4:	83 c1 01             	add    $0x1,%ecx
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	eb ed                	jmp    8009e9 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fc:	0f b6 c0             	movzbl %al,%eax
  8009ff:	0f b6 12             	movzbl (%edx),%edx
  800a02:	29 d0                	sub    %edx,%eax
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a10:	89 c3                	mov    %eax,%ebx
  800a12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a15:	eb 06                	jmp    800a1d <strncmp+0x17>
		n--, p++, q++;
  800a17:	83 c0 01             	add    $0x1,%eax
  800a1a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a1d:	39 d8                	cmp    %ebx,%eax
  800a1f:	74 16                	je     800a37 <strncmp+0x31>
  800a21:	0f b6 08             	movzbl (%eax),%ecx
  800a24:	84 c9                	test   %cl,%cl
  800a26:	74 04                	je     800a2c <strncmp+0x26>
  800a28:	3a 0a                	cmp    (%edx),%cl
  800a2a:	74 eb                	je     800a17 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2c:	0f b6 00             	movzbl (%eax),%eax
  800a2f:	0f b6 12             	movzbl (%edx),%edx
  800a32:	29 d0                	sub    %edx,%eax
}
  800a34:	5b                   	pop    %ebx
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    
		return 0;
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	eb f6                	jmp    800a34 <strncmp+0x2e>

00800a3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a48:	0f b6 10             	movzbl (%eax),%edx
  800a4b:	84 d2                	test   %dl,%dl
  800a4d:	74 09                	je     800a58 <strchr+0x1a>
		if (*s == c)
  800a4f:	38 ca                	cmp    %cl,%dl
  800a51:	74 0a                	je     800a5d <strchr+0x1f>
	for (; *s; s++)
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	eb f0                	jmp    800a48 <strchr+0xa>
			return (char *) s;
	return 0;
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a69:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6c:	38 ca                	cmp    %cl,%dl
  800a6e:	74 09                	je     800a79 <strfind+0x1a>
  800a70:	84 d2                	test   %dl,%dl
  800a72:	74 05                	je     800a79 <strfind+0x1a>
	for (; *s; s++)
  800a74:	83 c0 01             	add    $0x1,%eax
  800a77:	eb f0                	jmp    800a69 <strfind+0xa>
			break;
	return (char *) s;
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	57                   	push   %edi
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a84:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a87:	85 c9                	test   %ecx,%ecx
  800a89:	74 31                	je     800abc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8b:	89 f8                	mov    %edi,%eax
  800a8d:	09 c8                	or     %ecx,%eax
  800a8f:	a8 03                	test   $0x3,%al
  800a91:	75 23                	jne    800ab6 <memset+0x3b>
		c &= 0xFF;
  800a93:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a97:	89 d3                	mov    %edx,%ebx
  800a99:	c1 e3 08             	shl    $0x8,%ebx
  800a9c:	89 d0                	mov    %edx,%eax
  800a9e:	c1 e0 18             	shl    $0x18,%eax
  800aa1:	89 d6                	mov    %edx,%esi
  800aa3:	c1 e6 10             	shl    $0x10,%esi
  800aa6:	09 f0                	or     %esi,%eax
  800aa8:	09 c2                	or     %eax,%edx
  800aaa:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aac:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	fc                   	cld    
  800ab2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab4:	eb 06                	jmp    800abc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	fc                   	cld    
  800aba:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abc:	89 f8                	mov    %edi,%eax
  800abe:	5b                   	pop    %ebx
  800abf:	5e                   	pop    %esi
  800ac0:	5f                   	pop    %edi
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	57                   	push   %edi
  800ac7:	56                   	push   %esi
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad1:	39 c6                	cmp    %eax,%esi
  800ad3:	73 32                	jae    800b07 <memmove+0x44>
  800ad5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad8:	39 c2                	cmp    %eax,%edx
  800ada:	76 2b                	jbe    800b07 <memmove+0x44>
		s += n;
		d += n;
  800adc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adf:	89 fe                	mov    %edi,%esi
  800ae1:	09 ce                	or     %ecx,%esi
  800ae3:	09 d6                	or     %edx,%esi
  800ae5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aeb:	75 0e                	jne    800afb <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aed:	83 ef 04             	sub    $0x4,%edi
  800af0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af6:	fd                   	std    
  800af7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af9:	eb 09                	jmp    800b04 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afb:	83 ef 01             	sub    $0x1,%edi
  800afe:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b01:	fd                   	std    
  800b02:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b04:	fc                   	cld    
  800b05:	eb 1a                	jmp    800b21 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	09 ca                	or     %ecx,%edx
  800b0b:	09 f2                	or     %esi,%edx
  800b0d:	f6 c2 03             	test   $0x3,%dl
  800b10:	75 0a                	jne    800b1c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b15:	89 c7                	mov    %eax,%edi
  800b17:	fc                   	cld    
  800b18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1a:	eb 05                	jmp    800b21 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1c:	89 c7                	mov    %eax,%edi
  800b1e:	fc                   	cld    
  800b1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b21:	5e                   	pop    %esi
  800b22:	5f                   	pop    %edi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b2b:	ff 75 10             	pushl  0x10(%ebp)
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	e8 8a ff ff ff       	call   800ac3 <memmove>
}
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	56                   	push   %esi
  800b3f:	53                   	push   %ebx
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b46:	89 c6                	mov    %eax,%esi
  800b48:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b4b:	39 f0                	cmp    %esi,%eax
  800b4d:	74 1c                	je     800b6b <memcmp+0x30>
		if (*s1 != *s2)
  800b4f:	0f b6 08             	movzbl (%eax),%ecx
  800b52:	0f b6 1a             	movzbl (%edx),%ebx
  800b55:	38 d9                	cmp    %bl,%cl
  800b57:	75 08                	jne    800b61 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b59:	83 c0 01             	add    $0x1,%eax
  800b5c:	83 c2 01             	add    $0x1,%edx
  800b5f:	eb ea                	jmp    800b4b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b61:	0f b6 c1             	movzbl %cl,%eax
  800b64:	0f b6 db             	movzbl %bl,%ebx
  800b67:	29 d8                	sub    %ebx,%eax
  800b69:	eb 05                	jmp    800b70 <memcmp+0x35>
	}

	return 0;
  800b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7d:	89 c2                	mov    %eax,%edx
  800b7f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b82:	39 d0                	cmp    %edx,%eax
  800b84:	73 09                	jae    800b8f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b86:	38 08                	cmp    %cl,(%eax)
  800b88:	74 05                	je     800b8f <memfind+0x1b>
	for (; s < ends; s++)
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	eb f3                	jmp    800b82 <memfind+0xe>
			break;
	return (void *) s;
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	57                   	push   %edi
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9d:	eb 03                	jmp    800ba2 <strtol+0x11>
		s++;
  800b9f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba2:	0f b6 01             	movzbl (%ecx),%eax
  800ba5:	3c 20                	cmp    $0x20,%al
  800ba7:	74 f6                	je     800b9f <strtol+0xe>
  800ba9:	3c 09                	cmp    $0x9,%al
  800bab:	74 f2                	je     800b9f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bad:	3c 2b                	cmp    $0x2b,%al
  800baf:	74 2a                	je     800bdb <strtol+0x4a>
	int neg = 0;
  800bb1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb6:	3c 2d                	cmp    $0x2d,%al
  800bb8:	74 2b                	je     800be5 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bba:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc0:	75 0f                	jne    800bd1 <strtol+0x40>
  800bc2:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc5:	74 28                	je     800bef <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc7:	85 db                	test   %ebx,%ebx
  800bc9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bce:	0f 44 d8             	cmove  %eax,%ebx
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd9:	eb 50                	jmp    800c2b <strtol+0x9a>
		s++;
  800bdb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bde:	bf 00 00 00 00       	mov    $0x0,%edi
  800be3:	eb d5                	jmp    800bba <strtol+0x29>
		s++, neg = 1;
  800be5:	83 c1 01             	add    $0x1,%ecx
  800be8:	bf 01 00 00 00       	mov    $0x1,%edi
  800bed:	eb cb                	jmp    800bba <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bef:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf3:	74 0e                	je     800c03 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	75 d8                	jne    800bd1 <strtol+0x40>
		s++, base = 8;
  800bf9:	83 c1 01             	add    $0x1,%ecx
  800bfc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c01:	eb ce                	jmp    800bd1 <strtol+0x40>
		s += 2, base = 16;
  800c03:	83 c1 02             	add    $0x2,%ecx
  800c06:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0b:	eb c4                	jmp    800bd1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c10:	89 f3                	mov    %esi,%ebx
  800c12:	80 fb 19             	cmp    $0x19,%bl
  800c15:	77 29                	ja     800c40 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c17:	0f be d2             	movsbl %dl,%edx
  800c1a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c20:	7d 30                	jge    800c52 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c22:	83 c1 01             	add    $0x1,%ecx
  800c25:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2b:	0f b6 11             	movzbl (%ecx),%edx
  800c2e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c31:	89 f3                	mov    %esi,%ebx
  800c33:	80 fb 09             	cmp    $0x9,%bl
  800c36:	77 d5                	ja     800c0d <strtol+0x7c>
			dig = *s - '0';
  800c38:	0f be d2             	movsbl %dl,%edx
  800c3b:	83 ea 30             	sub    $0x30,%edx
  800c3e:	eb dd                	jmp    800c1d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c40:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c43:	89 f3                	mov    %esi,%ebx
  800c45:	80 fb 19             	cmp    $0x19,%bl
  800c48:	77 08                	ja     800c52 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c4a:	0f be d2             	movsbl %dl,%edx
  800c4d:	83 ea 37             	sub    $0x37,%edx
  800c50:	eb cb                	jmp    800c1d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c56:	74 05                	je     800c5d <strtol+0xcc>
		*endptr = (char *) s;
  800c58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5d:	89 c2                	mov    %eax,%edx
  800c5f:	f7 da                	neg    %edx
  800c61:	85 ff                	test   %edi,%edi
  800c63:	0f 45 c2             	cmovne %edx,%eax
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	b8 01 00 00 00       	mov    $0x1,%eax
  800c99:	89 d1                	mov    %edx,%ecx
  800c9b:	89 d3                	mov    %edx,%ebx
  800c9d:	89 d7                	mov    %edx,%edi
  800c9f:	89 d6                	mov    %edx,%esi
  800ca1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbe:	89 cb                	mov    %ecx,%ebx
  800cc0:	89 cf                	mov    %ecx,%edi
  800cc2:	89 ce                	mov    %ecx,%esi
  800cc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	7f 08                	jg     800cd2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd2:	83 ec 0c             	sub    $0xc,%esp
  800cd5:	50                   	push   %eax
  800cd6:	6a 03                	push   $0x3
  800cd8:	68 20 16 80 00       	push   $0x801620
  800cdd:	6a 43                	push   $0x43
  800cdf:	68 3d 16 80 00       	push   $0x80163d
  800ce4:	e8 70 02 00 00       	call   800f59 <_panic>

00800ce9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cef:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf4:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf9:	89 d1                	mov    %edx,%ecx
  800cfb:	89 d3                	mov    %edx,%ebx
  800cfd:	89 d7                	mov    %edx,%edi
  800cff:	89 d6                	mov    %edx,%esi
  800d01:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_yield>:

void
sys_yield(void)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d13:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d18:	89 d1                	mov    %edx,%ecx
  800d1a:	89 d3                	mov    %edx,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 d6                	mov    %edx,%esi
  800d20:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	be 00 00 00 00       	mov    $0x0,%esi
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d43:	89 f7                	mov    %esi,%edi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 04                	push   $0x4
  800d59:	68 20 16 80 00       	push   $0x801620
  800d5e:	6a 43                	push   $0x43
  800d60:	68 3d 16 80 00       	push   $0x80163d
  800d65:	e8 ef 01 00 00       	call   800f59 <_panic>

00800d6a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d84:	8b 75 18             	mov    0x18(%ebp),%esi
  800d87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7f 08                	jg     800d95 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	83 ec 0c             	sub    $0xc,%esp
  800d98:	50                   	push   %eax
  800d99:	6a 05                	push   $0x5
  800d9b:	68 20 16 80 00       	push   $0x801620
  800da0:	6a 43                	push   $0x43
  800da2:	68 3d 16 80 00       	push   $0x80163d
  800da7:	e8 ad 01 00 00       	call   800f59 <_panic>

00800dac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc5:	89 df                	mov    %ebx,%edi
  800dc7:	89 de                	mov    %ebx,%esi
  800dc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	7f 08                	jg     800dd7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	83 ec 0c             	sub    $0xc,%esp
  800dda:	50                   	push   %eax
  800ddb:	6a 06                	push   $0x6
  800ddd:	68 20 16 80 00       	push   $0x801620
  800de2:	6a 43                	push   $0x43
  800de4:	68 3d 16 80 00       	push   $0x80163d
  800de9:	e8 6b 01 00 00       	call   800f59 <_panic>

00800dee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	b8 08 00 00 00       	mov    $0x8,%eax
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	89 de                	mov    %ebx,%esi
  800e0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	7f 08                	jg     800e19 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e19:	83 ec 0c             	sub    $0xc,%esp
  800e1c:	50                   	push   %eax
  800e1d:	6a 08                	push   $0x8
  800e1f:	68 20 16 80 00       	push   $0x801620
  800e24:	6a 43                	push   $0x43
  800e26:	68 3d 16 80 00       	push   $0x80163d
  800e2b:	e8 29 01 00 00       	call   800f59 <_panic>

00800e30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	b8 09 00 00 00       	mov    $0x9,%eax
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7f 08                	jg     800e5b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	50                   	push   %eax
  800e5f:	6a 09                	push   $0x9
  800e61:	68 20 16 80 00       	push   $0x801620
  800e66:	6a 43                	push   $0x43
  800e68:	68 3d 16 80 00       	push   $0x80163d
  800e6d:	e8 e7 00 00 00       	call   800f59 <_panic>

00800e72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8b:	89 df                	mov    %ebx,%edi
  800e8d:	89 de                	mov    %ebx,%esi
  800e8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 0a                	push   $0xa
  800ea3:	68 20 16 80 00       	push   $0x801620
  800ea8:	6a 43                	push   $0x43
  800eaa:	68 3d 16 80 00       	push   $0x80163d
  800eaf:	e8 a5 00 00 00       	call   800f59 <_panic>

00800eb4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec5:	be 00 00 00 00       	mov    $0x0,%esi
  800eca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eed:	89 cb                	mov    %ecx,%ebx
  800eef:	89 cf                	mov    %ecx,%edi
  800ef1:	89 ce                	mov    %ecx,%esi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800f05:	6a 0d                	push   $0xd
  800f07:	68 20 16 80 00       	push   $0x801620
  800f0c:	6a 43                	push   $0x43
  800f0e:	68 3d 16 80 00       	push   $0x80163d
  800f13:	e8 41 00 00 00       	call   800f59 <_panic>

00800f18 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4c:	89 cb                	mov    %ecx,%ebx
  800f4e:	89 cf                	mov    %ecx,%edi
  800f50:	89 ce                	mov    %ecx,%esi
  800f52:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f5e:	a1 04 20 80 00       	mov    0x802004,%eax
  800f63:	8b 40 48             	mov    0x48(%eax),%eax
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	68 7c 16 80 00       	push   $0x80167c
  800f6e:	50                   	push   %eax
  800f6f:	68 4b 16 80 00       	push   $0x80164b
  800f74:	e8 5d f2 ff ff       	call   8001d6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f79:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f7c:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f82:	e8 62 fd ff ff       	call   800ce9 <sys_getenvid>
  800f87:	83 c4 04             	add    $0x4,%esp
  800f8a:	ff 75 0c             	pushl  0xc(%ebp)
  800f8d:	ff 75 08             	pushl  0x8(%ebp)
  800f90:	56                   	push   %esi
  800f91:	50                   	push   %eax
  800f92:	68 58 16 80 00       	push   $0x801658
  800f97:	e8 3a f2 ff ff       	call   8001d6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f9c:	83 c4 18             	add    $0x18,%esp
  800f9f:	53                   	push   %ebx
  800fa0:	ff 75 10             	pushl  0x10(%ebp)
  800fa3:	e8 dd f1 ff ff       	call   800185 <vcprintf>
	cprintf("\n");
  800fa8:	c7 04 24 54 16 80 00 	movl   $0x801654,(%esp)
  800faf:	e8 22 f2 ff ff       	call   8001d6 <cprintf>
  800fb4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800fb7:	cc                   	int3   
  800fb8:	eb fd                	jmp    800fb7 <_panic+0x5e>
  800fba:	66 90                	xchg   %ax,%ax
  800fbc:	66 90                	xchg   %ax,%ax
  800fbe:	66 90                	xchg   %ax,%ax

00800fc0 <__udivdi3>:
  800fc0:	55                   	push   %ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
  800fc4:	83 ec 1c             	sub    $0x1c,%esp
  800fc7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800fcb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800fcf:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fd3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fd7:	85 d2                	test   %edx,%edx
  800fd9:	75 4d                	jne    801028 <__udivdi3+0x68>
  800fdb:	39 f3                	cmp    %esi,%ebx
  800fdd:	76 19                	jbe    800ff8 <__udivdi3+0x38>
  800fdf:	31 ff                	xor    %edi,%edi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f2                	mov    %esi,%edx
  800fe5:	f7 f3                	div    %ebx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	89 d9                	mov    %ebx,%ecx
  800ffa:	85 db                	test   %ebx,%ebx
  800ffc:	75 0b                	jne    801009 <__udivdi3+0x49>
  800ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  801003:	31 d2                	xor    %edx,%edx
  801005:	f7 f3                	div    %ebx
  801007:	89 c1                	mov    %eax,%ecx
  801009:	31 d2                	xor    %edx,%edx
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	f7 f1                	div    %ecx
  80100f:	89 c6                	mov    %eax,%esi
  801011:	89 e8                	mov    %ebp,%eax
  801013:	89 f7                	mov    %esi,%edi
  801015:	f7 f1                	div    %ecx
  801017:	89 fa                	mov    %edi,%edx
  801019:	83 c4 1c             	add    $0x1c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    
  801021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801028:	39 f2                	cmp    %esi,%edx
  80102a:	77 1c                	ja     801048 <__udivdi3+0x88>
  80102c:	0f bd fa             	bsr    %edx,%edi
  80102f:	83 f7 1f             	xor    $0x1f,%edi
  801032:	75 2c                	jne    801060 <__udivdi3+0xa0>
  801034:	39 f2                	cmp    %esi,%edx
  801036:	72 06                	jb     80103e <__udivdi3+0x7e>
  801038:	31 c0                	xor    %eax,%eax
  80103a:	39 eb                	cmp    %ebp,%ebx
  80103c:	77 a9                	ja     800fe7 <__udivdi3+0x27>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	eb a2                	jmp    800fe7 <__udivdi3+0x27>
  801045:	8d 76 00             	lea    0x0(%esi),%esi
  801048:	31 ff                	xor    %edi,%edi
  80104a:	31 c0                	xor    %eax,%eax
  80104c:	89 fa                	mov    %edi,%edx
  80104e:	83 c4 1c             	add    $0x1c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    
  801056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80105d:	8d 76 00             	lea    0x0(%esi),%esi
  801060:	89 f9                	mov    %edi,%ecx
  801062:	b8 20 00 00 00       	mov    $0x20,%eax
  801067:	29 f8                	sub    %edi,%eax
  801069:	d3 e2                	shl    %cl,%edx
  80106b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80106f:	89 c1                	mov    %eax,%ecx
  801071:	89 da                	mov    %ebx,%edx
  801073:	d3 ea                	shr    %cl,%edx
  801075:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801079:	09 d1                	or     %edx,%ecx
  80107b:	89 f2                	mov    %esi,%edx
  80107d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801081:	89 f9                	mov    %edi,%ecx
  801083:	d3 e3                	shl    %cl,%ebx
  801085:	89 c1                	mov    %eax,%ecx
  801087:	d3 ea                	shr    %cl,%edx
  801089:	89 f9                	mov    %edi,%ecx
  80108b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80108f:	89 eb                	mov    %ebp,%ebx
  801091:	d3 e6                	shl    %cl,%esi
  801093:	89 c1                	mov    %eax,%ecx
  801095:	d3 eb                	shr    %cl,%ebx
  801097:	09 de                	or     %ebx,%esi
  801099:	89 f0                	mov    %esi,%eax
  80109b:	f7 74 24 08          	divl   0x8(%esp)
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	89 c3                	mov    %eax,%ebx
  8010a3:	f7 64 24 0c          	mull   0xc(%esp)
  8010a7:	39 d6                	cmp    %edx,%esi
  8010a9:	72 15                	jb     8010c0 <__udivdi3+0x100>
  8010ab:	89 f9                	mov    %edi,%ecx
  8010ad:	d3 e5                	shl    %cl,%ebp
  8010af:	39 c5                	cmp    %eax,%ebp
  8010b1:	73 04                	jae    8010b7 <__udivdi3+0xf7>
  8010b3:	39 d6                	cmp    %edx,%esi
  8010b5:	74 09                	je     8010c0 <__udivdi3+0x100>
  8010b7:	89 d8                	mov    %ebx,%eax
  8010b9:	31 ff                	xor    %edi,%edi
  8010bb:	e9 27 ff ff ff       	jmp    800fe7 <__udivdi3+0x27>
  8010c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8010c3:	31 ff                	xor    %edi,%edi
  8010c5:	e9 1d ff ff ff       	jmp    800fe7 <__udivdi3+0x27>
  8010ca:	66 90                	xchg   %ax,%ax
  8010cc:	66 90                	xchg   %ax,%ax
  8010ce:	66 90                	xchg   %ax,%ax

008010d0 <__umoddi3>:
  8010d0:	55                   	push   %ebp
  8010d1:	57                   	push   %edi
  8010d2:	56                   	push   %esi
  8010d3:	53                   	push   %ebx
  8010d4:	83 ec 1c             	sub    $0x1c,%esp
  8010d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010e7:	89 da                	mov    %ebx,%edx
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	75 43                	jne    801130 <__umoddi3+0x60>
  8010ed:	39 df                	cmp    %ebx,%edi
  8010ef:	76 17                	jbe    801108 <__umoddi3+0x38>
  8010f1:	89 f0                	mov    %esi,%eax
  8010f3:	f7 f7                	div    %edi
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	31 d2                	xor    %edx,%edx
  8010f9:	83 c4 1c             	add    $0x1c,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
  801101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801108:	89 fd                	mov    %edi,%ebp
  80110a:	85 ff                	test   %edi,%edi
  80110c:	75 0b                	jne    801119 <__umoddi3+0x49>
  80110e:	b8 01 00 00 00       	mov    $0x1,%eax
  801113:	31 d2                	xor    %edx,%edx
  801115:	f7 f7                	div    %edi
  801117:	89 c5                	mov    %eax,%ebp
  801119:	89 d8                	mov    %ebx,%eax
  80111b:	31 d2                	xor    %edx,%edx
  80111d:	f7 f5                	div    %ebp
  80111f:	89 f0                	mov    %esi,%eax
  801121:	f7 f5                	div    %ebp
  801123:	89 d0                	mov    %edx,%eax
  801125:	eb d0                	jmp    8010f7 <__umoddi3+0x27>
  801127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80112e:	66 90                	xchg   %ax,%ax
  801130:	89 f1                	mov    %esi,%ecx
  801132:	39 d8                	cmp    %ebx,%eax
  801134:	76 0a                	jbe    801140 <__umoddi3+0x70>
  801136:	89 f0                	mov    %esi,%eax
  801138:	83 c4 1c             	add    $0x1c,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5f                   	pop    %edi
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    
  801140:	0f bd e8             	bsr    %eax,%ebp
  801143:	83 f5 1f             	xor    $0x1f,%ebp
  801146:	75 20                	jne    801168 <__umoddi3+0x98>
  801148:	39 d8                	cmp    %ebx,%eax
  80114a:	0f 82 b0 00 00 00    	jb     801200 <__umoddi3+0x130>
  801150:	39 f7                	cmp    %esi,%edi
  801152:	0f 86 a8 00 00 00    	jbe    801200 <__umoddi3+0x130>
  801158:	89 c8                	mov    %ecx,%eax
  80115a:	83 c4 1c             	add    $0x1c,%esp
  80115d:	5b                   	pop    %ebx
  80115e:	5e                   	pop    %esi
  80115f:	5f                   	pop    %edi
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    
  801162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801168:	89 e9                	mov    %ebp,%ecx
  80116a:	ba 20 00 00 00       	mov    $0x20,%edx
  80116f:	29 ea                	sub    %ebp,%edx
  801171:	d3 e0                	shl    %cl,%eax
  801173:	89 44 24 08          	mov    %eax,0x8(%esp)
  801177:	89 d1                	mov    %edx,%ecx
  801179:	89 f8                	mov    %edi,%eax
  80117b:	d3 e8                	shr    %cl,%eax
  80117d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801181:	89 54 24 04          	mov    %edx,0x4(%esp)
  801185:	8b 54 24 04          	mov    0x4(%esp),%edx
  801189:	09 c1                	or     %eax,%ecx
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801191:	89 e9                	mov    %ebp,%ecx
  801193:	d3 e7                	shl    %cl,%edi
  801195:	89 d1                	mov    %edx,%ecx
  801197:	d3 e8                	shr    %cl,%eax
  801199:	89 e9                	mov    %ebp,%ecx
  80119b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80119f:	d3 e3                	shl    %cl,%ebx
  8011a1:	89 c7                	mov    %eax,%edi
  8011a3:	89 d1                	mov    %edx,%ecx
  8011a5:	89 f0                	mov    %esi,%eax
  8011a7:	d3 e8                	shr    %cl,%eax
  8011a9:	89 e9                	mov    %ebp,%ecx
  8011ab:	89 fa                	mov    %edi,%edx
  8011ad:	d3 e6                	shl    %cl,%esi
  8011af:	09 d8                	or     %ebx,%eax
  8011b1:	f7 74 24 08          	divl   0x8(%esp)
  8011b5:	89 d1                	mov    %edx,%ecx
  8011b7:	89 f3                	mov    %esi,%ebx
  8011b9:	f7 64 24 0c          	mull   0xc(%esp)
  8011bd:	89 c6                	mov    %eax,%esi
  8011bf:	89 d7                	mov    %edx,%edi
  8011c1:	39 d1                	cmp    %edx,%ecx
  8011c3:	72 06                	jb     8011cb <__umoddi3+0xfb>
  8011c5:	75 10                	jne    8011d7 <__umoddi3+0x107>
  8011c7:	39 c3                	cmp    %eax,%ebx
  8011c9:	73 0c                	jae    8011d7 <__umoddi3+0x107>
  8011cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8011cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011d3:	89 d7                	mov    %edx,%edi
  8011d5:	89 c6                	mov    %eax,%esi
  8011d7:	89 ca                	mov    %ecx,%edx
  8011d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011de:	29 f3                	sub    %esi,%ebx
  8011e0:	19 fa                	sbb    %edi,%edx
  8011e2:	89 d0                	mov    %edx,%eax
  8011e4:	d3 e0                	shl    %cl,%eax
  8011e6:	89 e9                	mov    %ebp,%ecx
  8011e8:	d3 eb                	shr    %cl,%ebx
  8011ea:	d3 ea                	shr    %cl,%edx
  8011ec:	09 d8                	or     %ebx,%eax
  8011ee:	83 c4 1c             	add    $0x1c,%esp
  8011f1:	5b                   	pop    %ebx
  8011f2:	5e                   	pop    %esi
  8011f3:	5f                   	pop    %edi
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    
  8011f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011fd:	8d 76 00             	lea    0x0(%esi),%esi
  801200:	89 da                	mov    %ebx,%edx
  801202:	29 fe                	sub    %edi,%esi
  801204:	19 c2                	sbb    %eax,%edx
  801206:	89 f1                	mov    %esi,%ecx
  801208:	89 c8                	mov    %ecx,%eax
  80120a:	e9 4b ff ff ff       	jmp    80115a <__umoddi3+0x8a>
