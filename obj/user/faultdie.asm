
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 81 00 00 00       	call   8000b2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("in faultdie %s\n", __FUNCTION__);
  80003b:	83 ec 08             	sub    $0x8,%esp
  80003e:	68 f8 12 80 00       	push   $0x8012f8
  800043:	68 c0 12 80 00       	push   $0x8012c0
  800048:	e8 a1 01 00 00       	call   8001ee <cprintf>
	void *addr = (void*)utf->utf_fault_va;
  80004d:	8b 33                	mov    (%ebx),%esi
	cprintf("1ha?\n");
  80004f:	c7 04 24 d0 12 80 00 	movl   $0x8012d0,(%esp)
  800056:	e8 93 01 00 00       	call   8001ee <cprintf>
	uint32_t err = utf->utf_err;
  80005b:	8b 5b 04             	mov    0x4(%ebx),%ebx
	cprintf("2ha?\n");
  80005e:	c7 04 24 d6 12 80 00 	movl   $0x8012d6,(%esp)
  800065:	e8 84 01 00 00       	call   8001ee <cprintf>
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80006a:	83 c4 0c             	add    $0xc,%esp
  80006d:	83 e3 07             	and    $0x7,%ebx
  800070:	53                   	push   %ebx
  800071:	56                   	push   %esi
  800072:	68 dc 12 80 00       	push   $0x8012dc
  800077:	e8 72 01 00 00       	call   8001ee <cprintf>
	sys_env_destroy(sys_getenvid());
  80007c:	e8 80 0c 00 00       	call   800d01 <sys_getenvid>
  800081:	89 04 24             	mov    %eax,(%esp)
  800084:	e8 37 0c 00 00       	call   800cc0 <sys_env_destroy>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    

00800093 <umain>:

void
umain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800099:	68 33 00 80 00       	push   $0x800033
  80009e:	e8 ce 0e 00 00       	call   800f71 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  8000a3:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  8000aa:	00 00 00 
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	c9                   	leave  
  8000b1:	c3                   	ret    

008000b2 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	57                   	push   %edi
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
  8000b8:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000bb:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000c2:	00 00 00 
	envid_t find = sys_getenvid();
  8000c5:	e8 37 0c 00 00       	call   800d01 <sys_getenvid>
  8000ca:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8000d0:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000d5:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000da:	bf 01 00 00 00       	mov    $0x1,%edi
  8000df:	eb 0b                	jmp    8000ec <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000e1:	83 c2 01             	add    $0x1,%edx
  8000e4:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000ea:	74 21                	je     80010d <libmain+0x5b>
		if(envs[i].env_id == find)
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	c1 e1 07             	shl    $0x7,%ecx
  8000f1:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000f7:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000fa:	39 c1                	cmp    %eax,%ecx
  8000fc:	75 e3                	jne    8000e1 <libmain+0x2f>
  8000fe:	89 d3                	mov    %edx,%ebx
  800100:	c1 e3 07             	shl    $0x7,%ebx
  800103:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800109:	89 fe                	mov    %edi,%esi
  80010b:	eb d4                	jmp    8000e1 <libmain+0x2f>
  80010d:	89 f0                	mov    %esi,%eax
  80010f:	84 c0                	test   %al,%al
  800111:	74 06                	je     800119 <libmain+0x67>
  800113:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011d:	7e 0a                	jle    800129 <libmain+0x77>
		binaryname = argv[0];
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	ff 75 0c             	pushl  0xc(%ebp)
  80012f:	ff 75 08             	pushl  0x8(%ebp)
  800132:	e8 5c ff ff ff       	call   800093 <umain>

	// exit gracefully
	exit();
  800137:	e8 0b 00 00 00       	call   800147 <exit>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80014d:	6a 00                	push   $0x0
  80014f:	e8 6c 0b 00 00       	call   800cc0 <sys_env_destroy>
}
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	53                   	push   %ebx
  80015d:	83 ec 04             	sub    $0x4,%esp
  800160:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800163:	8b 13                	mov    (%ebx),%edx
  800165:	8d 42 01             	lea    0x1(%edx),%eax
  800168:	89 03                	mov    %eax,(%ebx)
  80016a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800171:	3d ff 00 00 00       	cmp    $0xff,%eax
  800176:	74 09                	je     800181 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800178:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017f:	c9                   	leave  
  800180:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	68 ff 00 00 00       	push   $0xff
  800189:	8d 43 08             	lea    0x8(%ebx),%eax
  80018c:	50                   	push   %eax
  80018d:	e8 f1 0a 00 00       	call   800c83 <sys_cputs>
		b->idx = 0;
  800192:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	eb db                	jmp    800178 <putch+0x1f>

0080019d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ad:	00 00 00 
	b.cnt = 0;
  8001b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	68 59 01 80 00       	push   $0x800159
  8001cc:	e8 4a 01 00 00       	call   80031b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d1:	83 c4 08             	add    $0x8,%esp
  8001d4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001da:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e0:	50                   	push   %eax
  8001e1:	e8 9d 0a 00 00       	call   800c83 <sys_cputs>

	return b.cnt;
}
  8001e6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f7:	50                   	push   %eax
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 9d ff ff ff       	call   80019d <vcprintf>
	va_end(ap);

	return cnt;
}
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	57                   	push   %edi
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
  800208:	83 ec 1c             	sub    $0x1c,%esp
  80020b:	89 c6                	mov    %eax,%esi
  80020d:	89 d7                	mov    %edx,%edi
  80020f:	8b 45 08             	mov    0x8(%ebp),%eax
  800212:	8b 55 0c             	mov    0xc(%ebp),%edx
  800215:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800218:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021b:	8b 45 10             	mov    0x10(%ebp),%eax
  80021e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800221:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800225:	74 2c                	je     800253 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800227:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800231:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800234:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800237:	39 c2                	cmp    %eax,%edx
  800239:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023c:	73 43                	jae    800281 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80023e:	83 eb 01             	sub    $0x1,%ebx
  800241:	85 db                	test   %ebx,%ebx
  800243:	7e 6c                	jle    8002b1 <printnum+0xaf>
				putch(padc, putdat);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	57                   	push   %edi
  800249:	ff 75 18             	pushl  0x18(%ebp)
  80024c:	ff d6                	call   *%esi
  80024e:	83 c4 10             	add    $0x10,%esp
  800251:	eb eb                	jmp    80023e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 20                	push   $0x20
  800258:	6a 00                	push   $0x0
  80025a:	50                   	push   %eax
  80025b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025e:	ff 75 e0             	pushl  -0x20(%ebp)
  800261:	89 fa                	mov    %edi,%edx
  800263:	89 f0                	mov    %esi,%eax
  800265:	e8 98 ff ff ff       	call   800202 <printnum>
		while (--width > 0)
  80026a:	83 c4 20             	add    $0x20,%esp
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	85 db                	test   %ebx,%ebx
  800272:	7e 65                	jle    8002d9 <printnum+0xd7>
			putch(padc, putdat);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	57                   	push   %edi
  800278:	6a 20                	push   $0x20
  80027a:	ff d6                	call   *%esi
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	eb ec                	jmp    80026d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	83 eb 01             	sub    $0x1,%ebx
  80028a:	53                   	push   %ebx
  80028b:	50                   	push   %eax
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 dc             	pushl  -0x24(%ebp)
  800292:	ff 75 d8             	pushl  -0x28(%ebp)
  800295:	ff 75 e4             	pushl  -0x1c(%ebp)
  800298:	ff 75 e0             	pushl  -0x20(%ebp)
  80029b:	e8 d0 0d 00 00       	call   801070 <__udivdi3>
  8002a0:	83 c4 18             	add    $0x18,%esp
  8002a3:	52                   	push   %edx
  8002a4:	50                   	push   %eax
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	89 f0                	mov    %esi,%eax
  8002a9:	e8 54 ff ff ff       	call   800202 <printnum>
  8002ae:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	57                   	push   %edi
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c4:	e8 b7 0e 00 00       	call   801180 <__umoddi3>
  8002c9:	83 c4 14             	add    $0x14,%esp
  8002cc:	0f be 80 0a 13 80 00 	movsbl 0x80130a(%eax),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff d6                	call   *%esi
  8002d6:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    

008002e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002eb:	8b 10                	mov    (%eax),%edx
  8002ed:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f0:	73 0a                	jae    8002fc <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f5:	89 08                	mov    %ecx,(%eax)
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	88 02                	mov    %al,(%edx)
}
  8002fc:	5d                   	pop    %ebp
  8002fd:	c3                   	ret    

008002fe <printfmt>:
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800304:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800307:	50                   	push   %eax
  800308:	ff 75 10             	pushl  0x10(%ebp)
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 05 00 00 00       	call   80031b <vprintfmt>
}
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <vprintfmt>:
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 3c             	sub    $0x3c,%esp
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032d:	e9 32 04 00 00       	jmp    800764 <vprintfmt+0x449>
		padc = ' ';
  800332:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800336:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800344:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800352:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800359:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8d 47 01             	lea    0x1(%edi),%eax
  800361:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800364:	0f b6 17             	movzbl (%edi),%edx
  800367:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036a:	3c 55                	cmp    $0x55,%al
  80036c:	0f 87 12 05 00 00    	ja     800884 <vprintfmt+0x569>
  800372:	0f b6 c0             	movzbl %al,%eax
  800375:	ff 24 85 e0 14 80 00 	jmp    *0x8014e0(,%eax,4)
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800383:	eb d9                	jmp    80035e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800388:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038c:	eb d0                	jmp    80035e <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 75 08             	mov    %esi,0x8(%ebp)
  80039c:	eb 03                	jmp    8003a1 <vprintfmt+0x86>
  80039e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ab:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ae:	83 fe 09             	cmp    $0x9,%esi
  8003b1:	76 eb                	jbe    80039e <vprintfmt+0x83>
  8003b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b9:	eb 14                	jmp    8003cf <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 40 04             	lea    0x4(%eax),%eax
  8003c9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d3:	79 89                	jns    80035e <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e2:	e9 77 ff ff ff       	jmp    80035e <vprintfmt+0x43>
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	0f 48 c1             	cmovs  %ecx,%eax
  8003ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f5:	e9 64 ff ff ff       	jmp    80035e <vprintfmt+0x43>
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800404:	e9 55 ff ff ff       	jmp    80035e <vprintfmt+0x43>
			lflag++;
  800409:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800410:	e9 49 ff ff ff       	jmp    80035e <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800415:	8b 45 14             	mov    0x14(%ebp),%eax
  800418:	8d 78 04             	lea    0x4(%eax),%edi
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	53                   	push   %ebx
  80041f:	ff 30                	pushl  (%eax)
  800421:	ff d6                	call   *%esi
			break;
  800423:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800426:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800429:	e9 33 03 00 00       	jmp    800761 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 78 04             	lea    0x4(%eax),%edi
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	31 d0                	xor    %edx,%eax
  800439:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043b:	83 f8 0f             	cmp    $0xf,%eax
  80043e:	7f 23                	jg     800463 <vprintfmt+0x148>
  800440:	8b 14 85 40 16 80 00 	mov    0x801640(,%eax,4),%edx
  800447:	85 d2                	test   %edx,%edx
  800449:	74 18                	je     800463 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044b:	52                   	push   %edx
  80044c:	68 2b 13 80 00       	push   $0x80132b
  800451:	53                   	push   %ebx
  800452:	56                   	push   %esi
  800453:	e8 a6 fe ff ff       	call   8002fe <printfmt>
  800458:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045e:	e9 fe 02 00 00       	jmp    800761 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800463:	50                   	push   %eax
  800464:	68 22 13 80 00       	push   $0x801322
  800469:	53                   	push   %ebx
  80046a:	56                   	push   %esi
  80046b:	e8 8e fe ff ff       	call   8002fe <printfmt>
  800470:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800473:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800476:	e9 e6 02 00 00       	jmp    800761 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	83 c0 04             	add    $0x4,%eax
  800481:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800484:	8b 45 14             	mov    0x14(%ebp),%eax
  800487:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800489:	85 c9                	test   %ecx,%ecx
  80048b:	b8 1b 13 80 00       	mov    $0x80131b,%eax
  800490:	0f 45 c1             	cmovne %ecx,%eax
  800493:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049a:	7e 06                	jle    8004a2 <vprintfmt+0x187>
  80049c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a0:	75 0d                	jne    8004af <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a5:	89 c7                	mov    %eax,%edi
  8004a7:	03 45 e0             	add    -0x20(%ebp),%eax
  8004aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ad:	eb 53                	jmp    800502 <vprintfmt+0x1e7>
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b5:	50                   	push   %eax
  8004b6:	e8 71 04 00 00       	call   80092c <strnlen>
  8004bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c8:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	eb 0f                	jmp    8004e0 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	53                   	push   %ebx
  8004d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004da:	83 ef 01             	sub    $0x1,%edi
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7f ed                	jg     8004d1 <vprintfmt+0x1b6>
  8004e4:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c1             	cmovns %ecx,%eax
  8004f1:	29 c1                	sub    %eax,%ecx
  8004f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f6:	eb aa                	jmp    8004a2 <vprintfmt+0x187>
					putch(ch, putdat);
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	53                   	push   %ebx
  8004fc:	52                   	push   %edx
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 c7 01             	add    $0x1,%edi
  80050a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050e:	0f be d0             	movsbl %al,%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	74 4b                	je     800560 <vprintfmt+0x245>
  800515:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800519:	78 06                	js     800521 <vprintfmt+0x206>
  80051b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051f:	78 1e                	js     80053f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800521:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800525:	74 d1                	je     8004f8 <vprintfmt+0x1dd>
  800527:	0f be c0             	movsbl %al,%eax
  80052a:	83 e8 20             	sub    $0x20,%eax
  80052d:	83 f8 5e             	cmp    $0x5e,%eax
  800530:	76 c6                	jbe    8004f8 <vprintfmt+0x1dd>
					putch('?', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 3f                	push   $0x3f
  800538:	ff d6                	call   *%esi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb c3                	jmp    800502 <vprintfmt+0x1e7>
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	eb 0e                	jmp    800551 <vprintfmt+0x236>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 01 02 00 00       	jmp    800761 <vprintfmt+0x446>
  800560:	89 cf                	mov    %ecx,%edi
  800562:	eb ed                	jmp    800551 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800564:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800567:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80056e:	e9 eb fd ff ff       	jmp    80035e <vprintfmt+0x43>
	if (lflag >= 2)
  800573:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800577:	7f 21                	jg     80059a <vprintfmt+0x27f>
	else if (lflag)
  800579:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057d:	74 68                	je     8005e7 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800587:	89 c1                	mov    %eax,%ecx
  800589:	c1 f9 1f             	sar    $0x1f,%ecx
  80058c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
  800598:	eb 17                	jmp    8005b1 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 50 04             	mov    0x4(%eax),%edx
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 08             	lea    0x8(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005bd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c1:	78 3f                	js     800602 <vprintfmt+0x2e7>
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c8:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005cc:	0f 84 71 01 00 00    	je     800743 <vprintfmt+0x428>
				putch('+', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 2b                	push   $0x2b
  8005d8:	ff d6                	call   *%esi
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	e9 5c 01 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ef:	89 c1                	mov    %eax,%ecx
  8005f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800600:	eb af                	jmp    8005b1 <vprintfmt+0x296>
				putch('-', putdat);
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	53                   	push   %ebx
  800606:	6a 2d                	push   $0x2d
  800608:	ff d6                	call   *%esi
				num = -(long long) num;
  80060a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800610:	f7 d8                	neg    %eax
  800612:	83 d2 00             	adc    $0x0,%edx
  800615:	f7 da                	neg    %edx
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 19 01 00 00       	jmp    800743 <vprintfmt+0x428>
	if (lflag >= 2)
  80062a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062e:	7f 29                	jg     800659 <vprintfmt+0x33e>
	else if (lflag)
  800630:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800634:	74 44                	je     80067a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	ba 00 00 00 00       	mov    $0x0,%edx
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800654:	e9 ea 00 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 50 04             	mov    0x4(%eax),%edx
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800664:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 40 08             	lea    0x8(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800670:	b8 0a 00 00 00       	mov    $0xa,%eax
  800675:	e9 c9 00 00 00       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	ba 00 00 00 00       	mov    $0x0,%edx
  800684:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800687:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 a6 00 00 00       	jmp    800743 <vprintfmt+0x428>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ac:	7f 26                	jg     8006d4 <vprintfmt+0x3b9>
	else if (lflag)
  8006ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b2:	74 3e                	je     8006f2 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d2:	eb 6f                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 50 04             	mov    0x4(%eax),%edx
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f0:	eb 51                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070b:	b8 08 00 00 00       	mov    $0x8,%eax
  800710:	eb 31                	jmp    800743 <vprintfmt+0x428>
			putch('0', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	53                   	push   %ebx
  800716:	6a 30                	push   $0x30
  800718:	ff d6                	call   *%esi
			putch('x', putdat);
  80071a:	83 c4 08             	add    $0x8,%esp
  80071d:	53                   	push   %ebx
  80071e:	6a 78                	push   $0x78
  800720:	ff d6                	call   *%esi
			num = (unsigned long long)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800732:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800743:	83 ec 0c             	sub    $0xc,%esp
  800746:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074a:	52                   	push   %edx
  80074b:	ff 75 e0             	pushl  -0x20(%ebp)
  80074e:	50                   	push   %eax
  80074f:	ff 75 dc             	pushl  -0x24(%ebp)
  800752:	ff 75 d8             	pushl  -0x28(%ebp)
  800755:	89 da                	mov    %ebx,%edx
  800757:	89 f0                	mov    %esi,%eax
  800759:	e8 a4 fa ff ff       	call   800202 <printnum>
			break;
  80075e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	83 c7 01             	add    $0x1,%edi
  800767:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076b:	83 f8 25             	cmp    $0x25,%eax
  80076e:	0f 84 be fb ff ff    	je     800332 <vprintfmt+0x17>
			if (ch == '\0')
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 84 28 01 00 00    	je     8008a4 <vprintfmt+0x589>
			putch(ch, putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	ff d6                	call   *%esi
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	eb dc                	jmp    800764 <vprintfmt+0x449>
	if (lflag >= 2)
  800788:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078c:	7f 26                	jg     8007b4 <vprintfmt+0x499>
	else if (lflag)
  80078e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800792:	74 41                	je     8007d5 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b2:	eb 8f                	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8d 40 08             	lea    0x8(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d0:	e9 6e ff ff ff       	jmp    800743 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 40 04             	lea    0x4(%eax),%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f3:	e9 4b ff ff ff       	jmp    800743 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fb:	83 c0 04             	add    $0x4,%eax
  8007fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	85 c0                	test   %eax,%eax
  800808:	74 14                	je     80081e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080a:	8b 13                	mov    (%ebx),%edx
  80080c:	83 fa 7f             	cmp    $0x7f,%edx
  80080f:	7f 37                	jg     800848 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800811:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800813:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	e9 43 ff ff ff       	jmp    800761 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80081e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800823:	bf 41 14 80 00       	mov    $0x801441,%edi
							putch(ch, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	53                   	push   %ebx
  80082c:	50                   	push   %eax
  80082d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082f:	83 c7 01             	add    $0x1,%edi
  800832:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	75 eb                	jne    800828 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
  800843:	e9 19 ff ff ff       	jmp    800761 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800848:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084f:	bf 79 14 80 00       	mov    $0x801479,%edi
							putch(ch, putdat);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	53                   	push   %ebx
  800858:	50                   	push   %eax
  800859:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085b:	83 c7 01             	add    $0x1,%edi
  80085e:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	85 c0                	test   %eax,%eax
  800867:	75 eb                	jne    800854 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800869:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086c:	89 45 14             	mov    %eax,0x14(%ebp)
  80086f:	e9 ed fe ff ff       	jmp    800761 <vprintfmt+0x446>
			putch(ch, putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	53                   	push   %ebx
  800878:	6a 25                	push   $0x25
  80087a:	ff d6                	call   *%esi
			break;
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	e9 dd fe ff ff       	jmp    800761 <vprintfmt+0x446>
			putch('%', putdat);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	53                   	push   %ebx
  800888:	6a 25                	push   $0x25
  80088a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	89 f8                	mov    %edi,%eax
  800891:	eb 03                	jmp    800896 <vprintfmt+0x57b>
  800893:	83 e8 01             	sub    $0x1,%eax
  800896:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089a:	75 f7                	jne    800893 <vprintfmt+0x578>
  80089c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089f:	e9 bd fe ff ff       	jmp    800761 <vprintfmt+0x446>
}
  8008a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5f                   	pop    %edi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 18             	sub    $0x18,%esp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bb:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bf:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c9:	85 c0                	test   %eax,%eax
  8008cb:	74 26                	je     8008f3 <vsnprintf+0x47>
  8008cd:	85 d2                	test   %edx,%edx
  8008cf:	7e 22                	jle    8008f3 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d1:	ff 75 14             	pushl  0x14(%ebp)
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008da:	50                   	push   %eax
  8008db:	68 e1 02 80 00       	push   $0x8002e1
  8008e0:	e8 36 fa ff ff       	call   80031b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
}
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    
		return -E_INVAL;
  8008f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f8:	eb f7                	jmp    8008f1 <vsnprintf+0x45>

008008fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800900:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800903:	50                   	push   %eax
  800904:	ff 75 10             	pushl  0x10(%ebp)
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 9a ff ff ff       	call   8008ac <vsnprintf>
	va_end(ap);

	return rc;
}
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800923:	74 05                	je     80092a <strlen+0x16>
		n++;
  800925:	83 c0 01             	add    $0x1,%eax
  800928:	eb f5                	jmp    80091f <strlen+0xb>
	return n;
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
  80093a:	39 c2                	cmp    %eax,%edx
  80093c:	74 0d                	je     80094b <strnlen+0x1f>
  80093e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800942:	74 05                	je     800949 <strnlen+0x1d>
		n++;
  800944:	83 c2 01             	add    $0x1,%edx
  800947:	eb f1                	jmp    80093a <strnlen+0xe>
  800949:	89 d0                	mov    %edx,%eax
	return n;
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800957:	ba 00 00 00 00       	mov    $0x0,%edx
  80095c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800960:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	84 c9                	test   %cl,%cl
  800968:	75 f2                	jne    80095c <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096a:	5b                   	pop    %ebx
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	53                   	push   %ebx
  800971:	83 ec 10             	sub    $0x10,%esp
  800974:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800977:	53                   	push   %ebx
  800978:	e8 97 ff ff ff       	call   800914 <strlen>
  80097d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	01 d8                	add    %ebx,%eax
  800985:	50                   	push   %eax
  800986:	e8 c2 ff ff ff       	call   80094d <strcpy>
	return dst;
}
  80098b:	89 d8                	mov    %ebx,%eax
  80098d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800990:	c9                   	leave  
  800991:	c3                   	ret    

00800992 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099d:	89 c6                	mov    %eax,%esi
  80099f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 c2                	mov    %eax,%edx
  8009a4:	39 f2                	cmp    %esi,%edx
  8009a6:	74 11                	je     8009b9 <strncpy+0x27>
		*dst++ = *src;
  8009a8:	83 c2 01             	add    $0x1,%edx
  8009ab:	0f b6 19             	movzbl (%ecx),%ebx
  8009ae:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b1:	80 fb 01             	cmp    $0x1,%bl
  8009b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b7:	eb eb                	jmp    8009a4 <strncpy+0x12>
	}
	return ret;
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5e                   	pop    %esi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c8:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cd:	85 d2                	test   %edx,%edx
  8009cf:	74 21                	je     8009f2 <strlcpy+0x35>
  8009d1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d7:	39 c2                	cmp    %eax,%edx
  8009d9:	74 14                	je     8009ef <strlcpy+0x32>
  8009db:	0f b6 19             	movzbl (%ecx),%ebx
  8009de:	84 db                	test   %bl,%bl
  8009e0:	74 0b                	je     8009ed <strlcpy+0x30>
			*dst++ = *src++;
  8009e2:	83 c1 01             	add    $0x1,%ecx
  8009e5:	83 c2 01             	add    $0x1,%edx
  8009e8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009eb:	eb ea                	jmp    8009d7 <strlcpy+0x1a>
  8009ed:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f2:	29 f0                	sub    %esi,%eax
}
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a01:	0f b6 01             	movzbl (%ecx),%eax
  800a04:	84 c0                	test   %al,%al
  800a06:	74 0c                	je     800a14 <strcmp+0x1c>
  800a08:	3a 02                	cmp    (%edx),%al
  800a0a:	75 08                	jne    800a14 <strcmp+0x1c>
		p++, q++;
  800a0c:	83 c1 01             	add    $0x1,%ecx
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ed                	jmp    800a01 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a14:	0f b6 c0             	movzbl %al,%eax
  800a17:	0f b6 12             	movzbl (%edx),%edx
  800a1a:	29 d0                	sub    %edx,%eax
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	53                   	push   %ebx
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a28:	89 c3                	mov    %eax,%ebx
  800a2a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2d:	eb 06                	jmp    800a35 <strncmp+0x17>
		n--, p++, q++;
  800a2f:	83 c0 01             	add    $0x1,%eax
  800a32:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a35:	39 d8                	cmp    %ebx,%eax
  800a37:	74 16                	je     800a4f <strncmp+0x31>
  800a39:	0f b6 08             	movzbl (%eax),%ecx
  800a3c:	84 c9                	test   %cl,%cl
  800a3e:	74 04                	je     800a44 <strncmp+0x26>
  800a40:	3a 0a                	cmp    (%edx),%cl
  800a42:	74 eb                	je     800a2f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a44:	0f b6 00             	movzbl (%eax),%eax
  800a47:	0f b6 12             	movzbl (%edx),%edx
  800a4a:	29 d0                	sub    %edx,%eax
}
  800a4c:	5b                   	pop    %ebx
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    
		return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a54:	eb f6                	jmp    800a4c <strncmp+0x2e>

00800a56 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
  800a63:	84 d2                	test   %dl,%dl
  800a65:	74 09                	je     800a70 <strchr+0x1a>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strchr+0x1f>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strchr+0xa>
			return (char *) s;
	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a81:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a84:	38 ca                	cmp    %cl,%dl
  800a86:	74 09                	je     800a91 <strfind+0x1a>
  800a88:	84 d2                	test   %dl,%dl
  800a8a:	74 05                	je     800a91 <strfind+0x1a>
	for (; *s; s++)
  800a8c:	83 c0 01             	add    $0x1,%eax
  800a8f:	eb f0                	jmp    800a81 <strfind+0xa>
			break;
	return (char *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9f:	85 c9                	test   %ecx,%ecx
  800aa1:	74 31                	je     800ad4 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa3:	89 f8                	mov    %edi,%eax
  800aa5:	09 c8                	or     %ecx,%eax
  800aa7:	a8 03                	test   $0x3,%al
  800aa9:	75 23                	jne    800ace <memset+0x3b>
		c &= 0xFF;
  800aab:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaf:	89 d3                	mov    %edx,%ebx
  800ab1:	c1 e3 08             	shl    $0x8,%ebx
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	c1 e0 18             	shl    $0x18,%eax
  800ab9:	89 d6                	mov    %edx,%esi
  800abb:	c1 e6 10             	shl    $0x10,%esi
  800abe:	09 f0                	or     %esi,%eax
  800ac0:	09 c2                	or     %eax,%edx
  800ac2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac7:	89 d0                	mov    %edx,%eax
  800ac9:	fc                   	cld    
  800aca:	f3 ab                	rep stos %eax,%es:(%edi)
  800acc:	eb 06                	jmp    800ad4 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad4:	89 f8                	mov    %edi,%eax
  800ad6:	5b                   	pop    %ebx
  800ad7:	5e                   	pop    %esi
  800ad8:	5f                   	pop    %edi
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	57                   	push   %edi
  800adf:	56                   	push   %esi
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae9:	39 c6                	cmp    %eax,%esi
  800aeb:	73 32                	jae    800b1f <memmove+0x44>
  800aed:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af0:	39 c2                	cmp    %eax,%edx
  800af2:	76 2b                	jbe    800b1f <memmove+0x44>
		s += n;
		d += n;
  800af4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af7:	89 fe                	mov    %edi,%esi
  800af9:	09 ce                	or     %ecx,%esi
  800afb:	09 d6                	or     %edx,%esi
  800afd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b03:	75 0e                	jne    800b13 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b05:	83 ef 04             	sub    $0x4,%edi
  800b08:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0e:	fd                   	std    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b11:	eb 09                	jmp    800b1c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b13:	83 ef 01             	sub    $0x1,%edi
  800b16:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b19:	fd                   	std    
  800b1a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1c:	fc                   	cld    
  800b1d:	eb 1a                	jmp    800b39 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	89 c2                	mov    %eax,%edx
  800b21:	09 ca                	or     %ecx,%edx
  800b23:	09 f2                	or     %esi,%edx
  800b25:	f6 c2 03             	test   $0x3,%dl
  800b28:	75 0a                	jne    800b34 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2d:	89 c7                	mov    %eax,%edi
  800b2f:	fc                   	cld    
  800b30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b32:	eb 05                	jmp    800b39 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b34:	89 c7                	mov    %eax,%edi
  800b36:	fc                   	cld    
  800b37:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b39:	5e                   	pop    %esi
  800b3a:	5f                   	pop    %edi
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	ff 75 08             	pushl  0x8(%ebp)
  800b4c:	e8 8a ff ff ff       	call   800adb <memmove>
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b63:	39 f0                	cmp    %esi,%eax
  800b65:	74 1c                	je     800b83 <memcmp+0x30>
		if (*s1 != *s2)
  800b67:	0f b6 08             	movzbl (%eax),%ecx
  800b6a:	0f b6 1a             	movzbl (%edx),%ebx
  800b6d:	38 d9                	cmp    %bl,%cl
  800b6f:	75 08                	jne    800b79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	83 c2 01             	add    $0x1,%edx
  800b77:	eb ea                	jmp    800b63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c1             	movzbl %cl,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 05                	jmp    800b88 <memcmp+0x35>
	}

	return 0;
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9a:	39 d0                	cmp    %edx,%eax
  800b9c:	73 09                	jae    800ba7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9e:	38 08                	cmp    %cl,(%eax)
  800ba0:	74 05                	je     800ba7 <memfind+0x1b>
	for (; s < ends; s++)
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	eb f3                	jmp    800b9a <memfind+0xe>
			break;
	return (void *) s;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb5:	eb 03                	jmp    800bba <strtol+0x11>
		s++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bba:	0f b6 01             	movzbl (%ecx),%eax
  800bbd:	3c 20                	cmp    $0x20,%al
  800bbf:	74 f6                	je     800bb7 <strtol+0xe>
  800bc1:	3c 09                	cmp    $0x9,%al
  800bc3:	74 f2                	je     800bb7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc5:	3c 2b                	cmp    $0x2b,%al
  800bc7:	74 2a                	je     800bf3 <strtol+0x4a>
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bce:	3c 2d                	cmp    $0x2d,%al
  800bd0:	74 2b                	je     800bfd <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd8:	75 0f                	jne    800be9 <strtol+0x40>
  800bda:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdd:	74 28                	je     800c07 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdf:	85 db                	test   %ebx,%ebx
  800be1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be6:	0f 44 d8             	cmove  %eax,%ebx
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf1:	eb 50                	jmp    800c43 <strtol+0x9a>
		s++;
  800bf3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfb:	eb d5                	jmp    800bd2 <strtol+0x29>
		s++, neg = 1;
  800bfd:	83 c1 01             	add    $0x1,%ecx
  800c00:	bf 01 00 00 00       	mov    $0x1,%edi
  800c05:	eb cb                	jmp    800bd2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c07:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0b:	74 0e                	je     800c1b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0d:	85 db                	test   %ebx,%ebx
  800c0f:	75 d8                	jne    800be9 <strtol+0x40>
		s++, base = 8;
  800c11:	83 c1 01             	add    $0x1,%ecx
  800c14:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c19:	eb ce                	jmp    800be9 <strtol+0x40>
		s += 2, base = 16;
  800c1b:	83 c1 02             	add    $0x2,%ecx
  800c1e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c23:	eb c4                	jmp    800be9 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c25:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c28:	89 f3                	mov    %esi,%ebx
  800c2a:	80 fb 19             	cmp    $0x19,%bl
  800c2d:	77 29                	ja     800c58 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2f:	0f be d2             	movsbl %dl,%edx
  800c32:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c35:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c38:	7d 30                	jge    800c6a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3a:	83 c1 01             	add    $0x1,%ecx
  800c3d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c41:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c43:	0f b6 11             	movzbl (%ecx),%edx
  800c46:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c49:	89 f3                	mov    %esi,%ebx
  800c4b:	80 fb 09             	cmp    $0x9,%bl
  800c4e:	77 d5                	ja     800c25 <strtol+0x7c>
			dig = *s - '0';
  800c50:	0f be d2             	movsbl %dl,%edx
  800c53:	83 ea 30             	sub    $0x30,%edx
  800c56:	eb dd                	jmp    800c35 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c58:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5b:	89 f3                	mov    %esi,%ebx
  800c5d:	80 fb 19             	cmp    $0x19,%bl
  800c60:	77 08                	ja     800c6a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c62:	0f be d2             	movsbl %dl,%edx
  800c65:	83 ea 37             	sub    $0x37,%edx
  800c68:	eb cb                	jmp    800c35 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6e:	74 05                	je     800c75 <strtol+0xcc>
		*endptr = (char *) s;
  800c70:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c73:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c75:	89 c2                	mov    %eax,%edx
  800c77:	f7 da                	neg    %edx
  800c79:	85 ff                	test   %edi,%edi
  800c7b:	0f 45 c2             	cmovne %edx,%eax
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	89 c3                	mov    %eax,%ebx
  800c96:	89 c7                	mov    %eax,%edi
  800c98:	89 c6                	mov    %eax,%esi
  800c9a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb1:	89 d1                	mov    %edx,%ecx
  800cb3:	89 d3                	mov    %edx,%ebx
  800cb5:	89 d7                	mov    %edx,%edi
  800cb7:	89 d6                	mov    %edx,%esi
  800cb9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    

00800cc0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	89 cb                	mov    %ecx,%ebx
  800cd8:	89 cf                	mov    %ecx,%edi
  800cda:	89 ce                	mov    %ecx,%esi
  800cdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	7f 08                	jg     800cea <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cea:	83 ec 0c             	sub    $0xc,%esp
  800ced:	50                   	push   %eax
  800cee:	6a 03                	push   $0x3
  800cf0:	68 80 16 80 00       	push   $0x801680
  800cf5:	6a 43                	push   $0x43
  800cf7:	68 9d 16 80 00       	push   $0x80169d
  800cfc:	e8 05 03 00 00       	call   801006 <_panic>

00800d01 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	57                   	push   %edi
  800d05:	56                   	push   %esi
  800d06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d07:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800d11:	89 d1                	mov    %edx,%ecx
  800d13:	89 d3                	mov    %edx,%ebx
  800d15:	89 d7                	mov    %edx,%edi
  800d17:	89 d6                	mov    %edx,%esi
  800d19:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_yield>:

void
sys_yield(void)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d26:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d30:	89 d1                	mov    %edx,%ecx
  800d32:	89 d3                	mov    %edx,%ebx
  800d34:	89 d7                	mov    %edx,%edi
  800d36:	89 d6                	mov    %edx,%esi
  800d38:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	be 00 00 00 00       	mov    $0x0,%esi
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 04 00 00 00       	mov    $0x4,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	89 f7                	mov    %esi,%edi
  800d5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7f 08                	jg     800d6b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	50                   	push   %eax
  800d6f:	6a 04                	push   $0x4
  800d71:	68 80 16 80 00       	push   $0x801680
  800d76:	6a 43                	push   $0x43
  800d78:	68 9d 16 80 00       	push   $0x80169d
  800d7d:	e8 84 02 00 00       	call   801006 <_panic>

00800d82 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 05 00 00 00       	mov    $0x5,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 05                	push   $0x5
  800db3:	68 80 16 80 00       	push   $0x801680
  800db8:	6a 43                	push   $0x43
  800dba:	68 9d 16 80 00       	push   $0x80169d
  800dbf:	e8 42 02 00 00       	call   801006 <_panic>

00800dc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddd:	89 df                	mov    %ebx,%edi
  800ddf:	89 de                	mov    %ebx,%esi
  800de1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 06                	push   $0x6
  800df5:	68 80 16 80 00       	push   $0x801680
  800dfa:	6a 43                	push   $0x43
  800dfc:	68 9d 16 80 00       	push   $0x80169d
  800e01:	e8 00 02 00 00       	call   801006 <_panic>

00800e06 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1f:	89 df                	mov    %ebx,%edi
  800e21:	89 de                	mov    %ebx,%esi
  800e23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e25:	85 c0                	test   %eax,%eax
  800e27:	7f 08                	jg     800e31 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2c:	5b                   	pop    %ebx
  800e2d:	5e                   	pop    %esi
  800e2e:	5f                   	pop    %edi
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e31:	83 ec 0c             	sub    $0xc,%esp
  800e34:	50                   	push   %eax
  800e35:	6a 08                	push   $0x8
  800e37:	68 80 16 80 00       	push   $0x801680
  800e3c:	6a 43                	push   $0x43
  800e3e:	68 9d 16 80 00       	push   $0x80169d
  800e43:	e8 be 01 00 00       	call   801006 <_panic>

00800e48 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	57                   	push   %edi
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5c:	b8 09 00 00 00       	mov    $0x9,%eax
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7f 08                	jg     800e73 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6e:	5b                   	pop    %ebx
  800e6f:	5e                   	pop    %esi
  800e70:	5f                   	pop    %edi
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	50                   	push   %eax
  800e77:	6a 09                	push   $0x9
  800e79:	68 80 16 80 00       	push   $0x801680
  800e7e:	6a 43                	push   $0x43
  800e80:	68 9d 16 80 00       	push   $0x80169d
  800e85:	e8 7c 01 00 00       	call   801006 <_panic>

00800e8a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea3:	89 df                	mov    %ebx,%edi
  800ea5:	89 de                	mov    %ebx,%esi
  800ea7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	7f 08                	jg     800eb5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb5:	83 ec 0c             	sub    $0xc,%esp
  800eb8:	50                   	push   %eax
  800eb9:	6a 0a                	push   $0xa
  800ebb:	68 80 16 80 00       	push   $0x801680
  800ec0:	6a 43                	push   $0x43
  800ec2:	68 9d 16 80 00       	push   $0x80169d
  800ec7:	e8 3a 01 00 00       	call   801006 <_panic>

00800ecc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edd:	be 00 00 00 00       	mov    $0x0,%esi
  800ee2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	5d                   	pop    %ebp
  800eee:	c3                   	ret    

00800eef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f05:	89 cb                	mov    %ecx,%ebx
  800f07:	89 cf                	mov    %ecx,%edi
  800f09:	89 ce                	mov    %ecx,%esi
  800f0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7f 08                	jg     800f19 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f19:	83 ec 0c             	sub    $0xc,%esp
  800f1c:	50                   	push   %eax
  800f1d:	6a 0d                	push   $0xd
  800f1f:	68 80 16 80 00       	push   $0x801680
  800f24:	6a 43                	push   $0x43
  800f26:	68 9d 16 80 00       	push   $0x80169d
  800f2b:	e8 d6 00 00 00       	call   801006 <_panic>

00800f30 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4c:	5b                   	pop    %ebx
  800f4d:	5e                   	pop    %esi
  800f4e:	5f                   	pop    %edi
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f64:	89 cb                	mov    %ecx,%ebx
  800f66:	89 cf                	mov    %ecx,%edi
  800f68:	89 ce                	mov    %ecx,%esi
  800f6a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    

00800f71 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f77:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800f7e:	74 0a                	je     800f8a <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	a3 08 20 80 00       	mov    %eax,0x802008
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  800f8a:	83 ec 04             	sub    $0x4,%esp
  800f8d:	6a 07                	push   $0x7
  800f8f:	68 00 f0 bf ee       	push   $0xeebff000
  800f94:	6a 00                	push   $0x0
  800f96:	e8 a4 fd ff ff       	call   800d3f <sys_page_alloc>
		if(r < 0)
  800f9b:	83 c4 10             	add    $0x10,%esp
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	78 2a                	js     800fcc <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	68 e0 0f 80 00       	push   $0x800fe0
  800faa:	6a 00                	push   $0x0
  800fac:	e8 d9 fe ff ff       	call   800e8a <sys_env_set_pgfault_upcall>
		if(r < 0)
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	79 c8                	jns    800f80 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  800fb8:	83 ec 04             	sub    $0x4,%esp
  800fbb:	68 dc 16 80 00       	push   $0x8016dc
  800fc0:	6a 25                	push   $0x25
  800fc2:	68 15 17 80 00       	push   $0x801715
  800fc7:	e8 3a 00 00 00       	call   801006 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  800fcc:	83 ec 04             	sub    $0x4,%esp
  800fcf:	68 ac 16 80 00       	push   $0x8016ac
  800fd4:	6a 22                	push   $0x22
  800fd6:	68 15 17 80 00       	push   $0x801715
  800fdb:	e8 26 00 00 00       	call   801006 <_panic>

00800fe0 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800fe0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800fe1:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  800fe6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800fe8:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  800feb:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  800fef:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  800ff3:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800ff6:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  800ff8:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  800ffc:	83 c4 08             	add    $0x8,%esp
	popal
  800fff:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801000:	83 c4 04             	add    $0x4,%esp
	popfl
  801003:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801004:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801005:	c3                   	ret    

00801006 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80100b:	a1 04 20 80 00       	mov    0x802004,%eax
  801010:	8b 40 48             	mov    0x48(%eax),%eax
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	68 54 17 80 00       	push   $0x801754
  80101b:	50                   	push   %eax
  80101c:	68 23 17 80 00       	push   $0x801723
  801021:	e8 c8 f1 ff ff       	call   8001ee <cprintf>
	va_list ap;

	va_start(ap, fmt);
  801026:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801029:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80102f:	e8 cd fc ff ff       	call   800d01 <sys_getenvid>
  801034:	83 c4 04             	add    $0x4,%esp
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	ff 75 08             	pushl  0x8(%ebp)
  80103d:	56                   	push   %esi
  80103e:	50                   	push   %eax
  80103f:	68 30 17 80 00       	push   $0x801730
  801044:	e8 a5 f1 ff ff       	call   8001ee <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801049:	83 c4 18             	add    $0x18,%esp
  80104c:	53                   	push   %ebx
  80104d:	ff 75 10             	pushl  0x10(%ebp)
  801050:	e8 48 f1 ff ff       	call   80019d <vcprintf>
	cprintf("\n");
  801055:	c7 04 24 d4 12 80 00 	movl   $0x8012d4,(%esp)
  80105c:	e8 8d f1 ff ff       	call   8001ee <cprintf>
  801061:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801064:	cc                   	int3   
  801065:	eb fd                	jmp    801064 <_panic+0x5e>
  801067:	66 90                	xchg   %ax,%ax
  801069:	66 90                	xchg   %ax,%ax
  80106b:	66 90                	xchg   %ax,%ax
  80106d:	66 90                	xchg   %ax,%ax
  80106f:	90                   	nop

00801070 <__udivdi3>:
  801070:	55                   	push   %ebp
  801071:	57                   	push   %edi
  801072:	56                   	push   %esi
  801073:	53                   	push   %ebx
  801074:	83 ec 1c             	sub    $0x1c,%esp
  801077:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80107b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80107f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801083:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801087:	85 d2                	test   %edx,%edx
  801089:	75 4d                	jne    8010d8 <__udivdi3+0x68>
  80108b:	39 f3                	cmp    %esi,%ebx
  80108d:	76 19                	jbe    8010a8 <__udivdi3+0x38>
  80108f:	31 ff                	xor    %edi,%edi
  801091:	89 e8                	mov    %ebp,%eax
  801093:	89 f2                	mov    %esi,%edx
  801095:	f7 f3                	div    %ebx
  801097:	89 fa                	mov    %edi,%edx
  801099:	83 c4 1c             	add    $0x1c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010a8:	89 d9                	mov    %ebx,%ecx
  8010aa:	85 db                	test   %ebx,%ebx
  8010ac:	75 0b                	jne    8010b9 <__udivdi3+0x49>
  8010ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8010b3:	31 d2                	xor    %edx,%edx
  8010b5:	f7 f3                	div    %ebx
  8010b7:	89 c1                	mov    %eax,%ecx
  8010b9:	31 d2                	xor    %edx,%edx
  8010bb:	89 f0                	mov    %esi,%eax
  8010bd:	f7 f1                	div    %ecx
  8010bf:	89 c6                	mov    %eax,%esi
  8010c1:	89 e8                	mov    %ebp,%eax
  8010c3:	89 f7                	mov    %esi,%edi
  8010c5:	f7 f1                	div    %ecx
  8010c7:	89 fa                	mov    %edi,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	39 f2                	cmp    %esi,%edx
  8010da:	77 1c                	ja     8010f8 <__udivdi3+0x88>
  8010dc:	0f bd fa             	bsr    %edx,%edi
  8010df:	83 f7 1f             	xor    $0x1f,%edi
  8010e2:	75 2c                	jne    801110 <__udivdi3+0xa0>
  8010e4:	39 f2                	cmp    %esi,%edx
  8010e6:	72 06                	jb     8010ee <__udivdi3+0x7e>
  8010e8:	31 c0                	xor    %eax,%eax
  8010ea:	39 eb                	cmp    %ebp,%ebx
  8010ec:	77 a9                	ja     801097 <__udivdi3+0x27>
  8010ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8010f3:	eb a2                	jmp    801097 <__udivdi3+0x27>
  8010f5:	8d 76 00             	lea    0x0(%esi),%esi
  8010f8:	31 ff                	xor    %edi,%edi
  8010fa:	31 c0                	xor    %eax,%eax
  8010fc:	89 fa                	mov    %edi,%edx
  8010fe:	83 c4 1c             	add    $0x1c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    
  801106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80110d:	8d 76 00             	lea    0x0(%esi),%esi
  801110:	89 f9                	mov    %edi,%ecx
  801112:	b8 20 00 00 00       	mov    $0x20,%eax
  801117:	29 f8                	sub    %edi,%eax
  801119:	d3 e2                	shl    %cl,%edx
  80111b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80111f:	89 c1                	mov    %eax,%ecx
  801121:	89 da                	mov    %ebx,%edx
  801123:	d3 ea                	shr    %cl,%edx
  801125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801129:	09 d1                	or     %edx,%ecx
  80112b:	89 f2                	mov    %esi,%edx
  80112d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801131:	89 f9                	mov    %edi,%ecx
  801133:	d3 e3                	shl    %cl,%ebx
  801135:	89 c1                	mov    %eax,%ecx
  801137:	d3 ea                	shr    %cl,%edx
  801139:	89 f9                	mov    %edi,%ecx
  80113b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80113f:	89 eb                	mov    %ebp,%ebx
  801141:	d3 e6                	shl    %cl,%esi
  801143:	89 c1                	mov    %eax,%ecx
  801145:	d3 eb                	shr    %cl,%ebx
  801147:	09 de                	or     %ebx,%esi
  801149:	89 f0                	mov    %esi,%eax
  80114b:	f7 74 24 08          	divl   0x8(%esp)
  80114f:	89 d6                	mov    %edx,%esi
  801151:	89 c3                	mov    %eax,%ebx
  801153:	f7 64 24 0c          	mull   0xc(%esp)
  801157:	39 d6                	cmp    %edx,%esi
  801159:	72 15                	jb     801170 <__udivdi3+0x100>
  80115b:	89 f9                	mov    %edi,%ecx
  80115d:	d3 e5                	shl    %cl,%ebp
  80115f:	39 c5                	cmp    %eax,%ebp
  801161:	73 04                	jae    801167 <__udivdi3+0xf7>
  801163:	39 d6                	cmp    %edx,%esi
  801165:	74 09                	je     801170 <__udivdi3+0x100>
  801167:	89 d8                	mov    %ebx,%eax
  801169:	31 ff                	xor    %edi,%edi
  80116b:	e9 27 ff ff ff       	jmp    801097 <__udivdi3+0x27>
  801170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801173:	31 ff                	xor    %edi,%edi
  801175:	e9 1d ff ff ff       	jmp    801097 <__udivdi3+0x27>
  80117a:	66 90                	xchg   %ax,%ax
  80117c:	66 90                	xchg   %ax,%ax
  80117e:	66 90                	xchg   %ax,%ax

00801180 <__umoddi3>:
  801180:	55                   	push   %ebp
  801181:	57                   	push   %edi
  801182:	56                   	push   %esi
  801183:	53                   	push   %ebx
  801184:	83 ec 1c             	sub    $0x1c,%esp
  801187:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80118b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80118f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801197:	89 da                	mov    %ebx,%edx
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 43                	jne    8011e0 <__umoddi3+0x60>
  80119d:	39 df                	cmp    %ebx,%edi
  80119f:	76 17                	jbe    8011b8 <__umoddi3+0x38>
  8011a1:	89 f0                	mov    %esi,%eax
  8011a3:	f7 f7                	div    %edi
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	31 d2                	xor    %edx,%edx
  8011a9:	83 c4 1c             	add    $0x1c,%esp
  8011ac:	5b                   	pop    %ebx
  8011ad:	5e                   	pop    %esi
  8011ae:	5f                   	pop    %edi
  8011af:	5d                   	pop    %ebp
  8011b0:	c3                   	ret    
  8011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011b8:	89 fd                	mov    %edi,%ebp
  8011ba:	85 ff                	test   %edi,%edi
  8011bc:	75 0b                	jne    8011c9 <__umoddi3+0x49>
  8011be:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c3:	31 d2                	xor    %edx,%edx
  8011c5:	f7 f7                	div    %edi
  8011c7:	89 c5                	mov    %eax,%ebp
  8011c9:	89 d8                	mov    %ebx,%eax
  8011cb:	31 d2                	xor    %edx,%edx
  8011cd:	f7 f5                	div    %ebp
  8011cf:	89 f0                	mov    %esi,%eax
  8011d1:	f7 f5                	div    %ebp
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	eb d0                	jmp    8011a7 <__umoddi3+0x27>
  8011d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011de:	66 90                	xchg   %ax,%ax
  8011e0:	89 f1                	mov    %esi,%ecx
  8011e2:	39 d8                	cmp    %ebx,%eax
  8011e4:	76 0a                	jbe    8011f0 <__umoddi3+0x70>
  8011e6:	89 f0                	mov    %esi,%eax
  8011e8:	83 c4 1c             	add    $0x1c,%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5f                   	pop    %edi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    
  8011f0:	0f bd e8             	bsr    %eax,%ebp
  8011f3:	83 f5 1f             	xor    $0x1f,%ebp
  8011f6:	75 20                	jne    801218 <__umoddi3+0x98>
  8011f8:	39 d8                	cmp    %ebx,%eax
  8011fa:	0f 82 b0 00 00 00    	jb     8012b0 <__umoddi3+0x130>
  801200:	39 f7                	cmp    %esi,%edi
  801202:	0f 86 a8 00 00 00    	jbe    8012b0 <__umoddi3+0x130>
  801208:	89 c8                	mov    %ecx,%eax
  80120a:	83 c4 1c             	add    $0x1c,%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5f                   	pop    %edi
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    
  801212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801218:	89 e9                	mov    %ebp,%ecx
  80121a:	ba 20 00 00 00       	mov    $0x20,%edx
  80121f:	29 ea                	sub    %ebp,%edx
  801221:	d3 e0                	shl    %cl,%eax
  801223:	89 44 24 08          	mov    %eax,0x8(%esp)
  801227:	89 d1                	mov    %edx,%ecx
  801229:	89 f8                	mov    %edi,%eax
  80122b:	d3 e8                	shr    %cl,%eax
  80122d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801231:	89 54 24 04          	mov    %edx,0x4(%esp)
  801235:	8b 54 24 04          	mov    0x4(%esp),%edx
  801239:	09 c1                	or     %eax,%ecx
  80123b:	89 d8                	mov    %ebx,%eax
  80123d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801241:	89 e9                	mov    %ebp,%ecx
  801243:	d3 e7                	shl    %cl,%edi
  801245:	89 d1                	mov    %edx,%ecx
  801247:	d3 e8                	shr    %cl,%eax
  801249:	89 e9                	mov    %ebp,%ecx
  80124b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80124f:	d3 e3                	shl    %cl,%ebx
  801251:	89 c7                	mov    %eax,%edi
  801253:	89 d1                	mov    %edx,%ecx
  801255:	89 f0                	mov    %esi,%eax
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 fa                	mov    %edi,%edx
  80125d:	d3 e6                	shl    %cl,%esi
  80125f:	09 d8                	or     %ebx,%eax
  801261:	f7 74 24 08          	divl   0x8(%esp)
  801265:	89 d1                	mov    %edx,%ecx
  801267:	89 f3                	mov    %esi,%ebx
  801269:	f7 64 24 0c          	mull   0xc(%esp)
  80126d:	89 c6                	mov    %eax,%esi
  80126f:	89 d7                	mov    %edx,%edi
  801271:	39 d1                	cmp    %edx,%ecx
  801273:	72 06                	jb     80127b <__umoddi3+0xfb>
  801275:	75 10                	jne    801287 <__umoddi3+0x107>
  801277:	39 c3                	cmp    %eax,%ebx
  801279:	73 0c                	jae    801287 <__umoddi3+0x107>
  80127b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80127f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801283:	89 d7                	mov    %edx,%edi
  801285:	89 c6                	mov    %eax,%esi
  801287:	89 ca                	mov    %ecx,%edx
  801289:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80128e:	29 f3                	sub    %esi,%ebx
  801290:	19 fa                	sbb    %edi,%edx
  801292:	89 d0                	mov    %edx,%eax
  801294:	d3 e0                	shl    %cl,%eax
  801296:	89 e9                	mov    %ebp,%ecx
  801298:	d3 eb                	shr    %cl,%ebx
  80129a:	d3 ea                	shr    %cl,%edx
  80129c:	09 d8                	or     %ebx,%eax
  80129e:	83 c4 1c             	add    $0x1c,%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    
  8012a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012ad:	8d 76 00             	lea    0x0(%esi),%esi
  8012b0:	89 da                	mov    %ebx,%edx
  8012b2:	29 fe                	sub    %edi,%esi
  8012b4:	19 c2                	sbb    %eax,%edx
  8012b6:	89 f1                	mov    %esi,%ecx
  8012b8:	89 c8                	mov    %ecx,%eax
  8012ba:	e9 4b ff ff ff       	jmp    80120a <__umoddi3+0x8a>
