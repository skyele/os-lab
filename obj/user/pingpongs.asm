
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 6a 00 00 00       	call   80009b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003a:	e8 c5 13 00 00       	call   801404 <sfork>
  80003f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800042:	85 c0                	test   %eax,%eax
  800044:	75 44                	jne    80008a <umain+0x57>
		// cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800046:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	6a 00                	push   $0x0
  800050:	53                   	push   %ebx
  800051:	e8 1c 15 00 00       	call   801572 <ipc_recv>
		// cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, getthisenv(), getthisenv()->env_id);
		if (val == 10)
  800056:	a1 08 50 80 00       	mov    0x805008,%eax
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	83 f8 0a             	cmp    $0xa,%eax
  800061:	74 22                	je     800085 <umain+0x52>
			return;
		++val;
  800063:	83 c0 01             	add    $0x1,%eax
  800066:	a3 08 50 80 00       	mov    %eax,0x805008
		ipc_send(who, 0, 0, 0);
  80006b:	6a 00                	push   $0x0
  80006d:	6a 00                	push   $0x0
  80006f:	6a 00                	push   $0x0
  800071:	ff 75 f4             	pushl  -0xc(%ebp)
  800074:	e8 62 15 00 00       	call   8015db <ipc_send>
		if (val == 10)
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	83 3d 08 50 80 00 0a 	cmpl   $0xa,0x805008
  800083:	75 c4                	jne    800049 <umain+0x16>
			return;
	}

}
  800085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800088:	c9                   	leave  
  800089:	c3                   	ret    
		ipc_send(who, 0, 0, 0);
  80008a:	6a 00                	push   $0x0
  80008c:	6a 00                	push   $0x0
  80008e:	6a 00                	push   $0x0
  800090:	50                   	push   %eax
  800091:	e8 45 15 00 00       	call   8015db <ipc_send>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	eb ab                	jmp    800046 <umain+0x13>

0080009b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80009b:	55                   	push   %ebp
  80009c:	89 e5                	mov    %esp,%ebp
  80009e:	57                   	push   %edi
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000a4:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  8000ab:	00 00 00 
	envid_t find = sys_getenvid();
  8000ae:	e8 9f 0c 00 00       	call   800d52 <sys_getenvid>
  8000b3:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8000b9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000be:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c8:	eb 0b                	jmp    8000d5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ca:	83 c2 01             	add    $0x1,%edx
  8000cd:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d3:	74 23                	je     8000f8 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000d5:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000db:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e1:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e4:	39 c1                	cmp    %eax,%ecx
  8000e6:	75 e2                	jne    8000ca <libmain+0x2f>
  8000e8:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000ee:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f4:	89 fe                	mov    %edi,%esi
  8000f6:	eb d2                	jmp    8000ca <libmain+0x2f>
  8000f8:	89 f0                	mov    %esi,%eax
  8000fa:	84 c0                	test   %al,%al
  8000fc:	74 06                	je     800104 <libmain+0x69>
  8000fe:	89 1d 0c 50 80 00    	mov    %ebx,0x80500c
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800108:	7e 0a                	jle    800114 <libmain+0x79>
		binaryname = argv[0];
  80010a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010d:	8b 00                	mov    (%eax),%eax
  80010f:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800114:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800119:	8b 40 48             	mov    0x48(%eax),%eax
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	50                   	push   %eax
  800120:	68 60 2b 80 00       	push   $0x802b60
  800125:	e8 15 01 00 00       	call   80023f <cprintf>
	cprintf("before umain\n");
  80012a:	c7 04 24 7e 2b 80 00 	movl   $0x802b7e,(%esp)
  800131:	e8 09 01 00 00       	call   80023f <cprintf>
	// call user main routine
	umain(argc, argv);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff 75 0c             	pushl  0xc(%ebp)
  80013c:	ff 75 08             	pushl  0x8(%ebp)
  80013f:	e8 ef fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800144:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  80014b:	e8 ef 00 00 00       	call   80023f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800150:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800155:	8b 40 48             	mov    0x48(%eax),%eax
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	50                   	push   %eax
  80015c:	68 99 2b 80 00       	push   $0x802b99
  800161:	e8 d9 00 00 00       	call   80023f <cprintf>
	// exit gracefully
	exit();
  800166:	e8 0b 00 00 00       	call   800176 <exit>
}
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5f                   	pop    %edi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80017c:	a1 0c 50 80 00       	mov    0x80500c,%eax
  800181:	8b 40 48             	mov    0x48(%eax),%eax
  800184:	68 c4 2b 80 00       	push   $0x802bc4
  800189:	50                   	push   %eax
  80018a:	68 b8 2b 80 00       	push   $0x802bb8
  80018f:	e8 ab 00 00 00       	call   80023f <cprintf>
	close_all();
  800194:	e8 b1 16 00 00       	call   80184a <close_all>
	sys_env_destroy(0);
  800199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a0:	e8 6c 0b 00 00       	call   800d11 <sys_env_destroy>
}
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	53                   	push   %ebx
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b4:	8b 13                	mov    (%ebx),%edx
  8001b6:	8d 42 01             	lea    0x1(%edx),%eax
  8001b9:	89 03                	mov    %eax,(%ebx)
  8001bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001be:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c7:	74 09                	je     8001d2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d0:	c9                   	leave  
  8001d1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	68 ff 00 00 00       	push   $0xff
  8001da:	8d 43 08             	lea    0x8(%ebx),%eax
  8001dd:	50                   	push   %eax
  8001de:	e8 f1 0a 00 00       	call   800cd4 <sys_cputs>
		b->idx = 0;
  8001e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	eb db                	jmp    8001c9 <putch+0x1f>

008001ee <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fe:	00 00 00 
	b.cnt = 0;
  800201:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800208:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020b:	ff 75 0c             	pushl  0xc(%ebp)
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	68 aa 01 80 00       	push   $0x8001aa
  80021d:	e8 4a 01 00 00       	call   80036c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800222:	83 c4 08             	add    $0x8,%esp
  800225:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80022b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800231:	50                   	push   %eax
  800232:	e8 9d 0a 00 00       	call   800cd4 <sys_cputs>

	return b.cnt;
}
  800237:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800245:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800248:	50                   	push   %eax
  800249:	ff 75 08             	pushl  0x8(%ebp)
  80024c:	e8 9d ff ff ff       	call   8001ee <vcprintf>
	va_end(ap);

	return cnt;
}
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	57                   	push   %edi
  800257:	56                   	push   %esi
  800258:	53                   	push   %ebx
  800259:	83 ec 1c             	sub    $0x1c,%esp
  80025c:	89 c6                	mov    %eax,%esi
  80025e:	89 d7                	mov    %edx,%edi
  800260:	8b 45 08             	mov    0x8(%ebp),%eax
  800263:	8b 55 0c             	mov    0xc(%ebp),%edx
  800266:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800269:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026c:	8b 45 10             	mov    0x10(%ebp),%eax
  80026f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800272:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800276:	74 2c                	je     8002a4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800278:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800282:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800285:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028d:	73 43                	jae    8002d2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80028f:	83 eb 01             	sub    $0x1,%ebx
  800292:	85 db                	test   %ebx,%ebx
  800294:	7e 6c                	jle    800302 <printnum+0xaf>
				putch(padc, putdat);
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	57                   	push   %edi
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	ff d6                	call   *%esi
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb eb                	jmp    80028f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	6a 20                	push   $0x20
  8002a9:	6a 00                	push   $0x0
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b2:	89 fa                	mov    %edi,%edx
  8002b4:	89 f0                	mov    %esi,%eax
  8002b6:	e8 98 ff ff ff       	call   800253 <printnum>
		while (--width > 0)
  8002bb:	83 c4 20             	add    $0x20,%esp
  8002be:	83 eb 01             	sub    $0x1,%ebx
  8002c1:	85 db                	test   %ebx,%ebx
  8002c3:	7e 65                	jle    80032a <printnum+0xd7>
			putch(padc, putdat);
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	57                   	push   %edi
  8002c9:	6a 20                	push   $0x20
  8002cb:	ff d6                	call   *%esi
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	eb ec                	jmp    8002be <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	ff 75 18             	pushl  0x18(%ebp)
  8002d8:	83 eb 01             	sub    $0x1,%ebx
  8002db:	53                   	push   %ebx
  8002dc:	50                   	push   %eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ec:	e8 0f 26 00 00       	call   802900 <__udivdi3>
  8002f1:	83 c4 18             	add    $0x18,%esp
  8002f4:	52                   	push   %edx
  8002f5:	50                   	push   %eax
  8002f6:	89 fa                	mov    %edi,%edx
  8002f8:	89 f0                	mov    %esi,%eax
  8002fa:	e8 54 ff ff ff       	call   800253 <printnum>
  8002ff:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	57                   	push   %edi
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	ff 75 dc             	pushl  -0x24(%ebp)
  80030c:	ff 75 d8             	pushl  -0x28(%ebp)
  80030f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800312:	ff 75 e0             	pushl  -0x20(%ebp)
  800315:	e8 f6 26 00 00       	call   802a10 <__umoddi3>
  80031a:	83 c4 14             	add    $0x14,%esp
  80031d:	0f be 80 c9 2b 80 00 	movsbl 0x802bc9(%eax),%eax
  800324:	50                   	push   %eax
  800325:	ff d6                	call   *%esi
  800327:	83 c4 10             	add    $0x10,%esp
	}
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800338:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	3b 50 04             	cmp    0x4(%eax),%edx
  800341:	73 0a                	jae    80034d <sprintputch+0x1b>
		*b->buf++ = ch;
  800343:	8d 4a 01             	lea    0x1(%edx),%ecx
  800346:	89 08                	mov    %ecx,(%eax)
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	88 02                	mov    %al,(%edx)
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <printfmt>:
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800355:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800358:	50                   	push   %eax
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	e8 05 00 00 00       	call   80036c <vprintfmt>
}
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <vprintfmt>:
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	57                   	push   %edi
  800370:	56                   	push   %esi
  800371:	53                   	push   %ebx
  800372:	83 ec 3c             	sub    $0x3c,%esp
  800375:	8b 75 08             	mov    0x8(%ebp),%esi
  800378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037e:	e9 32 04 00 00       	jmp    8007b5 <vprintfmt+0x449>
		padc = ' ';
  800383:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800387:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80038e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800395:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003aa:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8d 47 01             	lea    0x1(%edi),%eax
  8003b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b5:	0f b6 17             	movzbl (%edi),%edx
  8003b8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003bb:	3c 55                	cmp    $0x55,%al
  8003bd:	0f 87 12 05 00 00    	ja     8008d5 <vprintfmt+0x569>
  8003c3:	0f b6 c0             	movzbl %al,%eax
  8003c6:	ff 24 85 a0 2d 80 00 	jmp    *0x802da0(,%eax,4)
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003d0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d4:	eb d9                	jmp    8003af <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003dd:	eb d0                	jmp    8003af <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	0f b6 d2             	movzbl %dl,%edx
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ea:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ed:	eb 03                	jmp    8003f2 <vprintfmt+0x86>
  8003ef:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003fc:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ff:	83 fe 09             	cmp    $0x9,%esi
  800402:	76 eb                	jbe    8003ef <vprintfmt+0x83>
  800404:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800407:	8b 75 08             	mov    0x8(%ebp),%esi
  80040a:	eb 14                	jmp    800420 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80040c:	8b 45 14             	mov    0x14(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8d 40 04             	lea    0x4(%eax),%eax
  80041a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800424:	79 89                	jns    8003af <vprintfmt+0x43>
				width = precision, precision = -1;
  800426:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800429:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800433:	e9 77 ff ff ff       	jmp    8003af <vprintfmt+0x43>
  800438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043b:	85 c0                	test   %eax,%eax
  80043d:	0f 48 c1             	cmovs  %ecx,%eax
  800440:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800446:	e9 64 ff ff ff       	jmp    8003af <vprintfmt+0x43>
  80044b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800455:	e9 55 ff ff ff       	jmp    8003af <vprintfmt+0x43>
			lflag++;
  80045a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800461:	e9 49 ff ff ff       	jmp    8003af <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800466:	8b 45 14             	mov    0x14(%ebp),%eax
  800469:	8d 78 04             	lea    0x4(%eax),%edi
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	53                   	push   %ebx
  800470:	ff 30                	pushl  (%eax)
  800472:	ff d6                	call   *%esi
			break;
  800474:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80047a:	e9 33 03 00 00       	jmp    8007b2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	8d 78 04             	lea    0x4(%eax),%edi
  800485:	8b 00                	mov    (%eax),%eax
  800487:	99                   	cltd   
  800488:	31 d0                	xor    %edx,%eax
  80048a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048c:	83 f8 11             	cmp    $0x11,%eax
  80048f:	7f 23                	jg     8004b4 <vprintfmt+0x148>
  800491:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  800498:	85 d2                	test   %edx,%edx
  80049a:	74 18                	je     8004b4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80049c:	52                   	push   %edx
  80049d:	68 2d 31 80 00       	push   $0x80312d
  8004a2:	53                   	push   %ebx
  8004a3:	56                   	push   %esi
  8004a4:	e8 a6 fe ff ff       	call   80034f <printfmt>
  8004a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ac:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004af:	e9 fe 02 00 00       	jmp    8007b2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b4:	50                   	push   %eax
  8004b5:	68 e1 2b 80 00       	push   $0x802be1
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 8e fe ff ff       	call   80034f <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c7:	e9 e6 02 00 00       	jmp    8007b2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	83 c0 04             	add    $0x4,%eax
  8004d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004da:	85 c9                	test   %ecx,%ecx
  8004dc:	b8 da 2b 80 00       	mov    $0x802bda,%eax
  8004e1:	0f 45 c1             	cmovne %ecx,%eax
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	7e 06                	jle    8004f3 <vprintfmt+0x187>
  8004ed:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004f1:	75 0d                	jne    800500 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f6:	89 c7                	mov    %eax,%edi
  8004f8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fe:	eb 53                	jmp    800553 <vprintfmt+0x1e7>
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	ff 75 d8             	pushl  -0x28(%ebp)
  800506:	50                   	push   %eax
  800507:	e8 71 04 00 00       	call   80097d <strnlen>
  80050c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050f:	29 c1                	sub    %eax,%ecx
  800511:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800519:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80051d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800520:	eb 0f                	jmp    800531 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	ff 75 e0             	pushl  -0x20(%ebp)
  800529:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80052b:	83 ef 01             	sub    $0x1,%edi
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	85 ff                	test   %edi,%edi
  800533:	7f ed                	jg     800522 <vprintfmt+0x1b6>
  800535:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800538:	85 c9                	test   %ecx,%ecx
  80053a:	b8 00 00 00 00       	mov    $0x0,%eax
  80053f:	0f 49 c1             	cmovns %ecx,%eax
  800542:	29 c1                	sub    %eax,%ecx
  800544:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800547:	eb aa                	jmp    8004f3 <vprintfmt+0x187>
					putch(ch, putdat);
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	53                   	push   %ebx
  80054d:	52                   	push   %edx
  80054e:	ff d6                	call   *%esi
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800556:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800558:	83 c7 01             	add    $0x1,%edi
  80055b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055f:	0f be d0             	movsbl %al,%edx
  800562:	85 d2                	test   %edx,%edx
  800564:	74 4b                	je     8005b1 <vprintfmt+0x245>
  800566:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056a:	78 06                	js     800572 <vprintfmt+0x206>
  80056c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800570:	78 1e                	js     800590 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800572:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800576:	74 d1                	je     800549 <vprintfmt+0x1dd>
  800578:	0f be c0             	movsbl %al,%eax
  80057b:	83 e8 20             	sub    $0x20,%eax
  80057e:	83 f8 5e             	cmp    $0x5e,%eax
  800581:	76 c6                	jbe    800549 <vprintfmt+0x1dd>
					putch('?', putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	6a 3f                	push   $0x3f
  800589:	ff d6                	call   *%esi
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	eb c3                	jmp    800553 <vprintfmt+0x1e7>
  800590:	89 cf                	mov    %ecx,%edi
  800592:	eb 0e                	jmp    8005a2 <vprintfmt+0x236>
				putch(' ', putdat);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	53                   	push   %ebx
  800598:	6a 20                	push   $0x20
  80059a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80059c:	83 ef 01             	sub    $0x1,%edi
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	85 ff                	test   %edi,%edi
  8005a4:	7f ee                	jg     800594 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ac:	e9 01 02 00 00       	jmp    8007b2 <vprintfmt+0x446>
  8005b1:	89 cf                	mov    %ecx,%edi
  8005b3:	eb ed                	jmp    8005a2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005b8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005bf:	e9 eb fd ff ff       	jmp    8003af <vprintfmt+0x43>
	if (lflag >= 2)
  8005c4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c8:	7f 21                	jg     8005eb <vprintfmt+0x27f>
	else if (lflag)
  8005ca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005ce:	74 68                	je     800638 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d8:	89 c1                	mov    %eax,%ecx
  8005da:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8d 40 04             	lea    0x4(%eax),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	eb 17                	jmp    800602 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 50 04             	mov    0x4(%eax),%edx
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 08             	lea    0x8(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80060e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800612:	78 3f                	js     800653 <vprintfmt+0x2e7>
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800619:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80061d:	0f 84 71 01 00 00    	je     800794 <vprintfmt+0x428>
				putch('+', putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	6a 2b                	push   $0x2b
  800629:	ff d6                	call   *%esi
  80062b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	e9 5c 01 00 00       	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800640:	89 c1                	mov    %eax,%ecx
  800642:	c1 f9 1f             	sar    $0x1f,%ecx
  800645:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
  800651:	eb af                	jmp    800602 <vprintfmt+0x296>
				putch('-', putdat);
  800653:	83 ec 08             	sub    $0x8,%esp
  800656:	53                   	push   %ebx
  800657:	6a 2d                	push   $0x2d
  800659:	ff d6                	call   *%esi
				num = -(long long) num;
  80065b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800661:	f7 d8                	neg    %eax
  800663:	83 d2 00             	adc    $0x0,%edx
  800666:	f7 da                	neg    %edx
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800671:	b8 0a 00 00 00       	mov    $0xa,%eax
  800676:	e9 19 01 00 00       	jmp    800794 <vprintfmt+0x428>
	if (lflag >= 2)
  80067b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067f:	7f 29                	jg     8006aa <vprintfmt+0x33e>
	else if (lflag)
  800681:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800685:	74 44                	je     8006cb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a5:	e9 ea 00 00 00       	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 50 04             	mov    0x4(%eax),%edx
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 40 08             	lea    0x8(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c6:	e9 c9 00 00 00       	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e9:	e9 a6 00 00 00       	jmp    800794 <vprintfmt+0x428>
			putch('0', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 30                	push   $0x30
  8006f4:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fd:	7f 26                	jg     800725 <vprintfmt+0x3b9>
	else if (lflag)
  8006ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800703:	74 3e                	je     800743 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	ba 00 00 00 00       	mov    $0x0,%edx
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071e:	b8 08 00 00 00       	mov    $0x8,%eax
  800723:	eb 6f                	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 50 04             	mov    0x4(%eax),%edx
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800730:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 08             	lea    0x8(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073c:	b8 08 00 00 00       	mov    $0x8,%eax
  800741:	eb 51                	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 04             	lea    0x4(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075c:	b8 08 00 00 00       	mov    $0x8,%eax
  800761:	eb 31                	jmp    800794 <vprintfmt+0x428>
			putch('0', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	53                   	push   %ebx
  800767:	6a 30                	push   $0x30
  800769:	ff d6                	call   *%esi
			putch('x', putdat);
  80076b:	83 c4 08             	add    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 78                	push   $0x78
  800771:	ff d6                	call   *%esi
			num = (unsigned long long)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800783:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8d 40 04             	lea    0x4(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800794:	83 ec 0c             	sub    $0xc,%esp
  800797:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80079b:	52                   	push   %edx
  80079c:	ff 75 e0             	pushl  -0x20(%ebp)
  80079f:	50                   	push   %eax
  8007a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a6:	89 da                	mov    %ebx,%edx
  8007a8:	89 f0                	mov    %esi,%eax
  8007aa:	e8 a4 fa ff ff       	call   800253 <printnum>
			break;
  8007af:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b5:	83 c7 01             	add    $0x1,%edi
  8007b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007bc:	83 f8 25             	cmp    $0x25,%eax
  8007bf:	0f 84 be fb ff ff    	je     800383 <vprintfmt+0x17>
			if (ch == '\0')
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	0f 84 28 01 00 00    	je     8008f5 <vprintfmt+0x589>
			putch(ch, putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	53                   	push   %ebx
  8007d1:	50                   	push   %eax
  8007d2:	ff d6                	call   *%esi
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	eb dc                	jmp    8007b5 <vprintfmt+0x449>
	if (lflag >= 2)
  8007d9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007dd:	7f 26                	jg     800805 <vprintfmt+0x499>
	else if (lflag)
  8007df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e3:	74 41                	je     800826 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fe:	b8 10 00 00 00       	mov    $0x10,%eax
  800803:	eb 8f                	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 50 04             	mov    0x4(%eax),%edx
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800810:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8d 40 08             	lea    0x8(%eax),%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081c:	b8 10 00 00 00       	mov    $0x10,%eax
  800821:	e9 6e ff ff ff       	jmp    800794 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	ba 00 00 00 00       	mov    $0x0,%edx
  800830:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800833:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
  800844:	e9 4b ff ff ff       	jmp    800794 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 c0 04             	add    $0x4,%eax
  80084f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8b 00                	mov    (%eax),%eax
  800857:	85 c0                	test   %eax,%eax
  800859:	74 14                	je     80086f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80085b:	8b 13                	mov    (%ebx),%edx
  80085d:	83 fa 7f             	cmp    $0x7f,%edx
  800860:	7f 37                	jg     800899 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800862:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800864:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
  80086a:	e9 43 ff ff ff       	jmp    8007b2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80086f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800874:	bf fd 2c 80 00       	mov    $0x802cfd,%edi
							putch(ch, putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	53                   	push   %ebx
  80087d:	50                   	push   %eax
  80087e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800880:	83 c7 01             	add    $0x1,%edi
  800883:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	85 c0                	test   %eax,%eax
  80088c:	75 eb                	jne    800879 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80088e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	e9 19 ff ff ff       	jmp    8007b2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800899:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80089b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a0:	bf 35 2d 80 00       	mov    $0x802d35,%edi
							putch(ch, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	53                   	push   %ebx
  8008a9:	50                   	push   %eax
  8008aa:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ac:	83 c7 01             	add    $0x1,%edi
  8008af:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	75 eb                	jne    8008a5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c0:	e9 ed fe ff ff       	jmp    8007b2 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	6a 25                	push   $0x25
  8008cb:	ff d6                	call   *%esi
			break;
  8008cd:	83 c4 10             	add    $0x10,%esp
  8008d0:	e9 dd fe ff ff       	jmp    8007b2 <vprintfmt+0x446>
			putch('%', putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	6a 25                	push   $0x25
  8008db:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	89 f8                	mov    %edi,%eax
  8008e2:	eb 03                	jmp    8008e7 <vprintfmt+0x57b>
  8008e4:	83 e8 01             	sub    $0x1,%eax
  8008e7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008eb:	75 f7                	jne    8008e4 <vprintfmt+0x578>
  8008ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f0:	e9 bd fe ff ff       	jmp    8007b2 <vprintfmt+0x446>
}
  8008f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f8:	5b                   	pop    %ebx
  8008f9:	5e                   	pop    %esi
  8008fa:	5f                   	pop    %edi
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	83 ec 18             	sub    $0x18,%esp
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800909:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800910:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800913:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091a:	85 c0                	test   %eax,%eax
  80091c:	74 26                	je     800944 <vsnprintf+0x47>
  80091e:	85 d2                	test   %edx,%edx
  800920:	7e 22                	jle    800944 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800922:	ff 75 14             	pushl  0x14(%ebp)
  800925:	ff 75 10             	pushl  0x10(%ebp)
  800928:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	68 32 03 80 00       	push   $0x800332
  800931:	e8 36 fa ff ff       	call   80036c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800939:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093f:	83 c4 10             	add    $0x10,%esp
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    
		return -E_INVAL;
  800944:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800949:	eb f7                	jmp    800942 <vsnprintf+0x45>

0080094b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800951:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800954:	50                   	push   %eax
  800955:	ff 75 10             	pushl  0x10(%ebp)
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 9a ff ff ff       	call   8008fd <vsnprintf>
	va_end(ap);

	return rc;
}
  800963:	c9                   	leave  
  800964:	c3                   	ret    

00800965 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
  800970:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800974:	74 05                	je     80097b <strlen+0x16>
		n++;
  800976:	83 c0 01             	add    $0x1,%eax
  800979:	eb f5                	jmp    800970 <strlen+0xb>
	return n;
}
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800986:	ba 00 00 00 00       	mov    $0x0,%edx
  80098b:	39 c2                	cmp    %eax,%edx
  80098d:	74 0d                	je     80099c <strnlen+0x1f>
  80098f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800993:	74 05                	je     80099a <strnlen+0x1d>
		n++;
  800995:	83 c2 01             	add    $0x1,%edx
  800998:	eb f1                	jmp    80098b <strnlen+0xe>
  80099a:	89 d0                	mov    %edx,%eax
	return n;
}
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ad:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009b1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b4:	83 c2 01             	add    $0x1,%edx
  8009b7:	84 c9                	test   %cl,%cl
  8009b9:	75 f2                	jne    8009ad <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009bb:	5b                   	pop    %ebx
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	53                   	push   %ebx
  8009c2:	83 ec 10             	sub    $0x10,%esp
  8009c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c8:	53                   	push   %ebx
  8009c9:	e8 97 ff ff ff       	call   800965 <strlen>
  8009ce:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	01 d8                	add    %ebx,%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 c2 ff ff ff       	call   80099e <strcpy>
	return dst;
}
  8009dc:	89 d8                	mov    %ebx,%eax
  8009de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ee:	89 c6                	mov    %eax,%esi
  8009f0:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f3:	89 c2                	mov    %eax,%edx
  8009f5:	39 f2                	cmp    %esi,%edx
  8009f7:	74 11                	je     800a0a <strncpy+0x27>
		*dst++ = *src;
  8009f9:	83 c2 01             	add    $0x1,%edx
  8009fc:	0f b6 19             	movzbl (%ecx),%ebx
  8009ff:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a02:	80 fb 01             	cmp    $0x1,%bl
  800a05:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a08:	eb eb                	jmp    8009f5 <strncpy+0x12>
	}
	return ret;
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5e                   	pop    %esi
  800a0c:	5d                   	pop    %ebp
  800a0d:	c3                   	ret    

00800a0e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	8b 75 08             	mov    0x8(%ebp),%esi
  800a16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a19:	8b 55 10             	mov    0x10(%ebp),%edx
  800a1c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1e:	85 d2                	test   %edx,%edx
  800a20:	74 21                	je     800a43 <strlcpy+0x35>
  800a22:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a26:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 14                	je     800a40 <strlcpy+0x32>
  800a2c:	0f b6 19             	movzbl (%ecx),%ebx
  800a2f:	84 db                	test   %bl,%bl
  800a31:	74 0b                	je     800a3e <strlcpy+0x30>
			*dst++ = *src++;
  800a33:	83 c1 01             	add    $0x1,%ecx
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3c:	eb ea                	jmp    800a28 <strlcpy+0x1a>
  800a3e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a40:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a43:	29 f0                	sub    %esi,%eax
}
  800a45:	5b                   	pop    %ebx
  800a46:	5e                   	pop    %esi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a52:	0f b6 01             	movzbl (%ecx),%eax
  800a55:	84 c0                	test   %al,%al
  800a57:	74 0c                	je     800a65 <strcmp+0x1c>
  800a59:	3a 02                	cmp    (%edx),%al
  800a5b:	75 08                	jne    800a65 <strcmp+0x1c>
		p++, q++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	83 c2 01             	add    $0x1,%edx
  800a63:	eb ed                	jmp    800a52 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a65:	0f b6 c0             	movzbl %al,%eax
  800a68:	0f b6 12             	movzbl (%edx),%edx
  800a6b:	29 d0                	sub    %edx,%eax
}
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	53                   	push   %ebx
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a79:	89 c3                	mov    %eax,%ebx
  800a7b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7e:	eb 06                	jmp    800a86 <strncmp+0x17>
		n--, p++, q++;
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a86:	39 d8                	cmp    %ebx,%eax
  800a88:	74 16                	je     800aa0 <strncmp+0x31>
  800a8a:	0f b6 08             	movzbl (%eax),%ecx
  800a8d:	84 c9                	test   %cl,%cl
  800a8f:	74 04                	je     800a95 <strncmp+0x26>
  800a91:	3a 0a                	cmp    (%edx),%cl
  800a93:	74 eb                	je     800a80 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a95:	0f b6 00             	movzbl (%eax),%eax
  800a98:	0f b6 12             	movzbl (%edx),%edx
  800a9b:	29 d0                	sub    %edx,%eax
}
  800a9d:	5b                   	pop    %ebx
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    
		return 0;
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	eb f6                	jmp    800a9d <strncmp+0x2e>

00800aa7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab1:	0f b6 10             	movzbl (%eax),%edx
  800ab4:	84 d2                	test   %dl,%dl
  800ab6:	74 09                	je     800ac1 <strchr+0x1a>
		if (*s == c)
  800ab8:	38 ca                	cmp    %cl,%dl
  800aba:	74 0a                	je     800ac6 <strchr+0x1f>
	for (; *s; s++)
  800abc:	83 c0 01             	add    $0x1,%eax
  800abf:	eb f0                	jmp    800ab1 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad5:	38 ca                	cmp    %cl,%dl
  800ad7:	74 09                	je     800ae2 <strfind+0x1a>
  800ad9:	84 d2                	test   %dl,%dl
  800adb:	74 05                	je     800ae2 <strfind+0x1a>
	for (; *s; s++)
  800add:	83 c0 01             	add    $0x1,%eax
  800ae0:	eb f0                	jmp    800ad2 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
  800aea:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af0:	85 c9                	test   %ecx,%ecx
  800af2:	74 31                	je     800b25 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af4:	89 f8                	mov    %edi,%eax
  800af6:	09 c8                	or     %ecx,%eax
  800af8:	a8 03                	test   $0x3,%al
  800afa:	75 23                	jne    800b1f <memset+0x3b>
		c &= 0xFF;
  800afc:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b00:	89 d3                	mov    %edx,%ebx
  800b02:	c1 e3 08             	shl    $0x8,%ebx
  800b05:	89 d0                	mov    %edx,%eax
  800b07:	c1 e0 18             	shl    $0x18,%eax
  800b0a:	89 d6                	mov    %edx,%esi
  800b0c:	c1 e6 10             	shl    $0x10,%esi
  800b0f:	09 f0                	or     %esi,%eax
  800b11:	09 c2                	or     %eax,%edx
  800b13:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b15:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b18:	89 d0                	mov    %edx,%eax
  800b1a:	fc                   	cld    
  800b1b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1d:	eb 06                	jmp    800b25 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	fc                   	cld    
  800b23:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b25:	89 f8                	mov    %edi,%eax
  800b27:	5b                   	pop    %ebx
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b37:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b3a:	39 c6                	cmp    %eax,%esi
  800b3c:	73 32                	jae    800b70 <memmove+0x44>
  800b3e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b41:	39 c2                	cmp    %eax,%edx
  800b43:	76 2b                	jbe    800b70 <memmove+0x44>
		s += n;
		d += n;
  800b45:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b48:	89 fe                	mov    %edi,%esi
  800b4a:	09 ce                	or     %ecx,%esi
  800b4c:	09 d6                	or     %edx,%esi
  800b4e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b54:	75 0e                	jne    800b64 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b56:	83 ef 04             	sub    $0x4,%edi
  800b59:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5f:	fd                   	std    
  800b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b62:	eb 09                	jmp    800b6d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b64:	83 ef 01             	sub    $0x1,%edi
  800b67:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b6a:	fd                   	std    
  800b6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6d:	fc                   	cld    
  800b6e:	eb 1a                	jmp    800b8a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b70:	89 c2                	mov    %eax,%edx
  800b72:	09 ca                	or     %ecx,%edx
  800b74:	09 f2                	or     %esi,%edx
  800b76:	f6 c2 03             	test   $0x3,%dl
  800b79:	75 0a                	jne    800b85 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7e:	89 c7                	mov    %eax,%edi
  800b80:	fc                   	cld    
  800b81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b83:	eb 05                	jmp    800b8a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b85:	89 c7                	mov    %eax,%edi
  800b87:	fc                   	cld    
  800b88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8a:	5e                   	pop    %esi
  800b8b:	5f                   	pop    %edi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b94:	ff 75 10             	pushl  0x10(%ebp)
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 8a ff ff ff       	call   800b2c <memmove>
}
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baf:	89 c6                	mov    %eax,%esi
  800bb1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb4:	39 f0                	cmp    %esi,%eax
  800bb6:	74 1c                	je     800bd4 <memcmp+0x30>
		if (*s1 != *s2)
  800bb8:	0f b6 08             	movzbl (%eax),%ecx
  800bbb:	0f b6 1a             	movzbl (%edx),%ebx
  800bbe:	38 d9                	cmp    %bl,%cl
  800bc0:	75 08                	jne    800bca <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc2:	83 c0 01             	add    $0x1,%eax
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	eb ea                	jmp    800bb4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bca:	0f b6 c1             	movzbl %cl,%eax
  800bcd:	0f b6 db             	movzbl %bl,%ebx
  800bd0:	29 d8                	sub    %ebx,%eax
  800bd2:	eb 05                	jmp    800bd9 <memcmp+0x35>
	}

	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd9:	5b                   	pop    %ebx
  800bda:	5e                   	pop    %esi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800beb:	39 d0                	cmp    %edx,%eax
  800bed:	73 09                	jae    800bf8 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bef:	38 08                	cmp    %cl,(%eax)
  800bf1:	74 05                	je     800bf8 <memfind+0x1b>
	for (; s < ends; s++)
  800bf3:	83 c0 01             	add    $0x1,%eax
  800bf6:	eb f3                	jmp    800beb <memfind+0xe>
			break;
	return (void *) s;
}
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    

00800bfa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c06:	eb 03                	jmp    800c0b <strtol+0x11>
		s++;
  800c08:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c0b:	0f b6 01             	movzbl (%ecx),%eax
  800c0e:	3c 20                	cmp    $0x20,%al
  800c10:	74 f6                	je     800c08 <strtol+0xe>
  800c12:	3c 09                	cmp    $0x9,%al
  800c14:	74 f2                	je     800c08 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c16:	3c 2b                	cmp    $0x2b,%al
  800c18:	74 2a                	je     800c44 <strtol+0x4a>
	int neg = 0;
  800c1a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1f:	3c 2d                	cmp    $0x2d,%al
  800c21:	74 2b                	je     800c4e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c23:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c29:	75 0f                	jne    800c3a <strtol+0x40>
  800c2b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2e:	74 28                	je     800c58 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c30:	85 db                	test   %ebx,%ebx
  800c32:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c37:	0f 44 d8             	cmove  %eax,%ebx
  800c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c42:	eb 50                	jmp    800c94 <strtol+0x9a>
		s++;
  800c44:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c47:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4c:	eb d5                	jmp    800c23 <strtol+0x29>
		s++, neg = 1;
  800c4e:	83 c1 01             	add    $0x1,%ecx
  800c51:	bf 01 00 00 00       	mov    $0x1,%edi
  800c56:	eb cb                	jmp    800c23 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c58:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c5c:	74 0e                	je     800c6c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c5e:	85 db                	test   %ebx,%ebx
  800c60:	75 d8                	jne    800c3a <strtol+0x40>
		s++, base = 8;
  800c62:	83 c1 01             	add    $0x1,%ecx
  800c65:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c6a:	eb ce                	jmp    800c3a <strtol+0x40>
		s += 2, base = 16;
  800c6c:	83 c1 02             	add    $0x2,%ecx
  800c6f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c74:	eb c4                	jmp    800c3a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c76:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c79:	89 f3                	mov    %esi,%ebx
  800c7b:	80 fb 19             	cmp    $0x19,%bl
  800c7e:	77 29                	ja     800ca9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c80:	0f be d2             	movsbl %dl,%edx
  800c83:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c86:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c89:	7d 30                	jge    800cbb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c8b:	83 c1 01             	add    $0x1,%ecx
  800c8e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c92:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c94:	0f b6 11             	movzbl (%ecx),%edx
  800c97:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c9a:	89 f3                	mov    %esi,%ebx
  800c9c:	80 fb 09             	cmp    $0x9,%bl
  800c9f:	77 d5                	ja     800c76 <strtol+0x7c>
			dig = *s - '0';
  800ca1:	0f be d2             	movsbl %dl,%edx
  800ca4:	83 ea 30             	sub    $0x30,%edx
  800ca7:	eb dd                	jmp    800c86 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ca9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cac:	89 f3                	mov    %esi,%ebx
  800cae:	80 fb 19             	cmp    $0x19,%bl
  800cb1:	77 08                	ja     800cbb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb3:	0f be d2             	movsbl %dl,%edx
  800cb6:	83 ea 37             	sub    $0x37,%edx
  800cb9:	eb cb                	jmp    800c86 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbf:	74 05                	je     800cc6 <strtol+0xcc>
		*endptr = (char *) s;
  800cc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc6:	89 c2                	mov    %eax,%edx
  800cc8:	f7 da                	neg    %edx
  800cca:	85 ff                	test   %edi,%edi
  800ccc:	0f 45 c2             	cmovne %edx,%eax
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	89 c3                	mov    %eax,%ebx
  800ce7:	89 c7                	mov    %eax,%edi
  800ce9:	89 c6                	mov    %eax,%esi
  800ceb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  800d02:	89 d1                	mov    %edx,%ecx
  800d04:	89 d3                	mov    %edx,%ebx
  800d06:	89 d7                	mov    %edx,%edi
  800d08:	89 d6                	mov    %edx,%esi
  800d0a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0c:	5b                   	pop    %ebx
  800d0d:	5e                   	pop    %esi
  800d0e:	5f                   	pop    %edi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	b8 03 00 00 00       	mov    $0x3,%eax
  800d27:	89 cb                	mov    %ecx,%ebx
  800d29:	89 cf                	mov    %ecx,%edi
  800d2b:	89 ce                	mov    %ecx,%esi
  800d2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2f:	85 c0                	test   %eax,%eax
  800d31:	7f 08                	jg     800d3b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3b:	83 ec 0c             	sub    $0xc,%esp
  800d3e:	50                   	push   %eax
  800d3f:	6a 03                	push   $0x3
  800d41:	68 48 2f 80 00       	push   $0x802f48
  800d46:	6a 43                	push   $0x43
  800d48:	68 65 2f 80 00       	push   $0x802f65
  800d4d:	e8 76 1a 00 00       	call   8027c8 <_panic>

00800d52 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d58:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d62:	89 d1                	mov    %edx,%ecx
  800d64:	89 d3                	mov    %edx,%ebx
  800d66:	89 d7                	mov    %edx,%edi
  800d68:	89 d6                	mov    %edx,%esi
  800d6a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <sys_yield>:

void
sys_yield(void)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d77:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d81:	89 d1                	mov    %edx,%ecx
  800d83:	89 d3                	mov    %edx,%ebx
  800d85:	89 d7                	mov    %edx,%edi
  800d87:	89 d6                	mov    %edx,%esi
  800d89:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	be 00 00 00 00       	mov    $0x0,%esi
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 04 00 00 00       	mov    $0x4,%eax
  800da9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dac:	89 f7                	mov    %esi,%edi
  800dae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db0:	85 c0                	test   %eax,%eax
  800db2:	7f 08                	jg     800dbc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbc:	83 ec 0c             	sub    $0xc,%esp
  800dbf:	50                   	push   %eax
  800dc0:	6a 04                	push   $0x4
  800dc2:	68 48 2f 80 00       	push   $0x802f48
  800dc7:	6a 43                	push   $0x43
  800dc9:	68 65 2f 80 00       	push   $0x802f65
  800dce:	e8 f5 19 00 00       	call   8027c8 <_panic>

00800dd3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de2:	b8 05 00 00 00       	mov    $0x5,%eax
  800de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dea:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ded:	8b 75 18             	mov    0x18(%ebp),%esi
  800df0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7f 08                	jg     800dfe <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df9:	5b                   	pop    %ebx
  800dfa:	5e                   	pop    %esi
  800dfb:	5f                   	pop    %edi
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	83 ec 0c             	sub    $0xc,%esp
  800e01:	50                   	push   %eax
  800e02:	6a 05                	push   $0x5
  800e04:	68 48 2f 80 00       	push   $0x802f48
  800e09:	6a 43                	push   $0x43
  800e0b:	68 65 2f 80 00       	push   $0x802f65
  800e10:	e8 b3 19 00 00       	call   8027c8 <_panic>

00800e15 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
  800e1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e29:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2e:	89 df                	mov    %ebx,%edi
  800e30:	89 de                	mov    %ebx,%esi
  800e32:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	7f 08                	jg     800e40 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	50                   	push   %eax
  800e44:	6a 06                	push   $0x6
  800e46:	68 48 2f 80 00       	push   $0x802f48
  800e4b:	6a 43                	push   $0x43
  800e4d:	68 65 2f 80 00       	push   $0x802f65
  800e52:	e8 71 19 00 00       	call   8027c8 <_panic>

00800e57 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e70:	89 df                	mov    %ebx,%edi
  800e72:	89 de                	mov    %ebx,%esi
  800e74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	7f 08                	jg     800e82 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	83 ec 0c             	sub    $0xc,%esp
  800e85:	50                   	push   %eax
  800e86:	6a 08                	push   $0x8
  800e88:	68 48 2f 80 00       	push   $0x802f48
  800e8d:	6a 43                	push   $0x43
  800e8f:	68 65 2f 80 00       	push   $0x802f65
  800e94:	e8 2f 19 00 00       	call   8027c8 <_panic>

00800e99 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ead:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb2:	89 df                	mov    %ebx,%edi
  800eb4:	89 de                	mov    %ebx,%esi
  800eb6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7f 08                	jg     800ec4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec4:	83 ec 0c             	sub    $0xc,%esp
  800ec7:	50                   	push   %eax
  800ec8:	6a 09                	push   $0x9
  800eca:	68 48 2f 80 00       	push   $0x802f48
  800ecf:	6a 43                	push   $0x43
  800ed1:	68 65 2f 80 00       	push   $0x802f65
  800ed6:	e8 ed 18 00 00       	call   8027c8 <_panic>

00800edb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
  800ee1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef4:	89 df                	mov    %ebx,%edi
  800ef6:	89 de                	mov    %ebx,%esi
  800ef8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efa:	85 c0                	test   %eax,%eax
  800efc:	7f 08                	jg     800f06 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	50                   	push   %eax
  800f0a:	6a 0a                	push   $0xa
  800f0c:	68 48 2f 80 00       	push   $0x802f48
  800f11:	6a 43                	push   $0x43
  800f13:	68 65 2f 80 00       	push   $0x802f65
  800f18:	e8 ab 18 00 00       	call   8027c8 <_panic>

00800f1d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2e:	be 00 00 00 00       	mov    $0x0,%esi
  800f33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f39:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f56:	89 cb                	mov    %ecx,%ebx
  800f58:	89 cf                	mov    %ecx,%edi
  800f5a:	89 ce                	mov    %ecx,%esi
  800f5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7f 08                	jg     800f6a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6a:	83 ec 0c             	sub    $0xc,%esp
  800f6d:	50                   	push   %eax
  800f6e:	6a 0d                	push   $0xd
  800f70:	68 48 2f 80 00       	push   $0x802f48
  800f75:	6a 43                	push   $0x43
  800f77:	68 65 2f 80 00       	push   $0x802f65
  800f7c:	e8 47 18 00 00       	call   8027c8 <_panic>

00800f81 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	57                   	push   %edi
  800f85:	56                   	push   %esi
  800f86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f92:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f97:	89 df                	mov    %ebx,%edi
  800f99:	89 de                	mov    %ebx,%esi
  800f9b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	5d                   	pop    %ebp
  800fa1:	c3                   	ret    

00800fa2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fad:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb0:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb5:	89 cb                	mov    %ecx,%ebx
  800fb7:	89 cf                	mov    %ecx,%edi
  800fb9:	89 ce                	mov    %ecx,%esi
  800fbb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcd:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd2:	89 d1                	mov    %edx,%ecx
  800fd4:	89 d3                	mov    %edx,%ebx
  800fd6:	89 d7                	mov    %edx,%edi
  800fd8:	89 d6                	mov    %edx,%esi
  800fda:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff7:	89 df                	mov    %ebx,%edi
  800ff9:	89 de                	mov    %ebx,%esi
  800ffb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	57                   	push   %edi
  801006:	56                   	push   %esi
  801007:	53                   	push   %ebx
	asm volatile("int %1\n"
  801008:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100d:	8b 55 08             	mov    0x8(%ebp),%edx
  801010:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801013:	b8 12 00 00 00       	mov    $0x12,%eax
  801018:	89 df                	mov    %ebx,%edi
  80101a:	89 de                	mov    %ebx,%esi
  80101c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801037:	b8 13 00 00 00       	mov    $0x13,%eax
  80103c:	89 df                	mov    %ebx,%edi
  80103e:	89 de                	mov    %ebx,%esi
  801040:	cd 30                	int    $0x30
	if(check && ret > 0)
  801042:	85 c0                	test   %eax,%eax
  801044:	7f 08                	jg     80104e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801046:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	50                   	push   %eax
  801052:	6a 13                	push   $0x13
  801054:	68 48 2f 80 00       	push   $0x802f48
  801059:	6a 43                	push   $0x43
  80105b:	68 65 2f 80 00       	push   $0x802f65
  801060:	e8 63 17 00 00       	call   8027c8 <_panic>

00801065 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	57                   	push   %edi
  801069:	56                   	push   %esi
  80106a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	b8 14 00 00 00       	mov    $0x14,%eax
  801078:	89 cb                	mov    %ecx,%ebx
  80107a:	89 cf                	mov    %ecx,%edi
  80107c:	89 ce                	mov    %ecx,%esi
  80107e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	53                   	push   %ebx
  801089:	83 ec 04             	sub    $0x4,%esp
	int r;
	//lab5 bug?
	if((uvpt[pn]) & PTE_SHARE){
  80108c:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  801093:	f6 c5 04             	test   $0x4,%ch
  801096:	75 45                	jne    8010dd <duppage+0x58>
							uvpt[pn] & PTE_SYSCALL);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_W)) == (PTE_P | PTE_U | PTE_W)){
  801098:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  80109f:	83 e1 07             	and    $0x7,%ecx
  8010a2:	83 f9 07             	cmp    $0x7,%ecx
  8010a5:	74 6f                	je     801116 <duppage+0x91>
						 PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U | PTE_COW)) == (PTE_P | PTE_U | PTE_COW)){
  8010a7:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010ae:	81 e1 05 08 00 00    	and    $0x805,%ecx
  8010b4:	81 f9 05 08 00 00    	cmp    $0x805,%ecx
  8010ba:	0f 84 b6 00 00 00    	je     801176 <duppage+0xf1>
						PTE_P | PTE_U | PTE_COW);
		if(r < 0)
			panic("sys_page_map() panic\n");
		return 0;
	}
	if(((uvpt[pn]) & (PTE_P | PTE_U)) == (PTE_P | PTE_U)){
  8010c0:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
  8010c7:	83 e1 05             	and    $0x5,%ecx
  8010ca:	83 f9 05             	cmp    $0x5,%ecx
  8010cd:	0f 84 d7 00 00 00    	je     8011aa <duppage+0x125>
	}

	// LAB 4: Your code here.
	// panic("duppage not implemented");
	return 0;
}
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    
							uvpt[pn] & PTE_SYSCALL);
  8010dd:	8b 0c 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%ecx
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8010e4:	c1 e2 0c             	shl    $0xc,%edx
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	81 e1 07 0e 00 00    	and    $0xe07,%ecx
  8010f0:	51                   	push   %ecx
  8010f1:	52                   	push   %edx
  8010f2:	50                   	push   %eax
  8010f3:	52                   	push   %edx
  8010f4:	6a 00                	push   $0x0
  8010f6:	e8 d8 fc ff ff       	call   800dd3 <sys_page_map>
		if(r < 0)
  8010fb:	83 c4 20             	add    $0x20,%esp
  8010fe:	85 c0                	test   %eax,%eax
  801100:	79 d1                	jns    8010d3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801102:	83 ec 04             	sub    $0x4,%esp
  801105:	68 73 2f 80 00       	push   $0x802f73
  80110a:	6a 54                	push   $0x54
  80110c:	68 89 2f 80 00       	push   $0x802f89
  801111:	e8 b2 16 00 00       	call   8027c8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801116:	89 d3                	mov    %edx,%ebx
  801118:	c1 e3 0c             	shl    $0xc,%ebx
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	68 05 08 00 00       	push   $0x805
  801123:	53                   	push   %ebx
  801124:	50                   	push   %eax
  801125:	53                   	push   %ebx
  801126:	6a 00                	push   $0x0
  801128:	e8 a6 fc ff ff       	call   800dd3 <sys_page_map>
		if(r < 0)
  80112d:	83 c4 20             	add    $0x20,%esp
  801130:	85 c0                	test   %eax,%eax
  801132:	78 2e                	js     801162 <duppage+0xdd>
		r = sys_page_map(0, (void *)(pn * PGSIZE), 0, (void *)(pn * PGSIZE),
  801134:	83 ec 0c             	sub    $0xc,%esp
  801137:	68 05 08 00 00       	push   $0x805
  80113c:	53                   	push   %ebx
  80113d:	6a 00                	push   $0x0
  80113f:	53                   	push   %ebx
  801140:	6a 00                	push   $0x0
  801142:	e8 8c fc ff ff       	call   800dd3 <sys_page_map>
		if(r < 0)
  801147:	83 c4 20             	add    $0x20,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	79 85                	jns    8010d3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	68 73 2f 80 00       	push   $0x802f73
  801156:	6a 5f                	push   $0x5f
  801158:	68 89 2f 80 00       	push   $0x802f89
  80115d:	e8 66 16 00 00       	call   8027c8 <_panic>
			panic("sys_page_map() panic\n");
  801162:	83 ec 04             	sub    $0x4,%esp
  801165:	68 73 2f 80 00       	push   $0x802f73
  80116a:	6a 5b                	push   $0x5b
  80116c:	68 89 2f 80 00       	push   $0x802f89
  801171:	e8 52 16 00 00       	call   8027c8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  801176:	c1 e2 0c             	shl    $0xc,%edx
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	68 05 08 00 00       	push   $0x805
  801181:	52                   	push   %edx
  801182:	50                   	push   %eax
  801183:	52                   	push   %edx
  801184:	6a 00                	push   $0x0
  801186:	e8 48 fc ff ff       	call   800dd3 <sys_page_map>
		if(r < 0)
  80118b:	83 c4 20             	add    $0x20,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	0f 89 3d ff ff ff    	jns    8010d3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  801196:	83 ec 04             	sub    $0x4,%esp
  801199:	68 73 2f 80 00       	push   $0x802f73
  80119e:	6a 66                	push   $0x66
  8011a0:	68 89 2f 80 00       	push   $0x802f89
  8011a5:	e8 1e 16 00 00       	call   8027c8 <_panic>
		r = sys_page_map(0, (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), 
  8011aa:	c1 e2 0c             	shl    $0xc,%edx
  8011ad:	83 ec 0c             	sub    $0xc,%esp
  8011b0:	6a 05                	push   $0x5
  8011b2:	52                   	push   %edx
  8011b3:	50                   	push   %eax
  8011b4:	52                   	push   %edx
  8011b5:	6a 00                	push   $0x0
  8011b7:	e8 17 fc ff ff       	call   800dd3 <sys_page_map>
		if(r < 0)
  8011bc:	83 c4 20             	add    $0x20,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	0f 89 0c ff ff ff    	jns    8010d3 <duppage+0x4e>
			panic("sys_page_map() panic\n");
  8011c7:	83 ec 04             	sub    $0x4,%esp
  8011ca:	68 73 2f 80 00       	push   $0x802f73
  8011cf:	6a 6d                	push   $0x6d
  8011d1:	68 89 2f 80 00       	push   $0x802f89
  8011d6:	e8 ed 15 00 00       	call   8027c8 <_panic>

008011db <pgfault>:
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	53                   	push   %ebx
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  8011e5:	8b 02                	mov    (%edx),%eax
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  8011e7:	f6 42 04 02          	testb  $0x2,0x4(%edx)
  8011eb:	0f 84 99 00 00 00    	je     80128a <pgfault+0xaf>
  8011f1:	89 c2                	mov    %eax,%edx
  8011f3:	c1 ea 16             	shr    $0x16,%edx
  8011f6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fd:	f6 c2 01             	test   $0x1,%dl
  801200:	0f 84 84 00 00 00    	je     80128a <pgfault+0xaf>
		((uvpt[PGNUM(addr)] & (PTE_P | PTE_COW)) 
  801206:	89 c2                	mov    %eax,%edx
  801208:	c1 ea 0c             	shr    $0xc,%edx
  80120b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801212:	81 e2 01 08 00 00    	and    $0x801,%edx
	if((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) &&
  801218:	81 fa 01 08 00 00    	cmp    $0x801,%edx
  80121e:	75 6a                	jne    80128a <pgfault+0xaf>
	addr = ROUNDDOWN(addr, PGSIZE);
  801220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801225:	89 c3                	mov    %eax,%ebx
	ret = sys_page_alloc(0, (void *)PFTEMP, PTE_P | PTE_U | PTE_W);
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	6a 07                	push   $0x7
  80122c:	68 00 f0 7f 00       	push   $0x7ff000
  801231:	6a 00                	push   $0x0
  801233:	e8 58 fb ff ff       	call   800d90 <sys_page_alloc>
	if(ret < 0)
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	78 5f                	js     80129e <pgfault+0xc3>
	memcpy((void *)PFTEMP, (void *)addr, PGSIZE);
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	68 00 10 00 00       	push   $0x1000
  801247:	53                   	push   %ebx
  801248:	68 00 f0 7f 00       	push   $0x7ff000
  80124d:	e8 3c f9 ff ff       	call   800b8e <memcpy>
	ret = sys_page_map(0, PFTEMP, 0, addr,  PTE_P | PTE_U | PTE_W);
  801252:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801259:	53                   	push   %ebx
  80125a:	6a 00                	push   $0x0
  80125c:	68 00 f0 7f 00       	push   $0x7ff000
  801261:	6a 00                	push   $0x0
  801263:	e8 6b fb ff ff       	call   800dd3 <sys_page_map>
	if(ret < 0)
  801268:	83 c4 20             	add    $0x20,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	78 43                	js     8012b2 <pgfault+0xd7>
	ret = sys_page_unmap(0, (void *)PFTEMP);
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	68 00 f0 7f 00       	push   $0x7ff000
  801277:	6a 00                	push   $0x0
  801279:	e8 97 fb ff ff       	call   800e15 <sys_page_unmap>
	if(ret < 0)
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 41                	js     8012c6 <pgfault+0xeb>
}
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    
		panic("panic at pgfault()\n");
  80128a:	83 ec 04             	sub    $0x4,%esp
  80128d:	68 94 2f 80 00       	push   $0x802f94
  801292:	6a 26                	push   $0x26
  801294:	68 89 2f 80 00       	push   $0x802f89
  801299:	e8 2a 15 00 00       	call   8027c8 <_panic>
		panic("panic in sys_page_alloc()\n");
  80129e:	83 ec 04             	sub    $0x4,%esp
  8012a1:	68 a8 2f 80 00       	push   $0x802fa8
  8012a6:	6a 31                	push   $0x31
  8012a8:	68 89 2f 80 00       	push   $0x802f89
  8012ad:	e8 16 15 00 00       	call   8027c8 <_panic>
		panic("panic in sys_page_map()\n");
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	68 c3 2f 80 00       	push   $0x802fc3
  8012ba:	6a 36                	push   $0x36
  8012bc:	68 89 2f 80 00       	push   $0x802f89
  8012c1:	e8 02 15 00 00       	call   8027c8 <_panic>
		panic("panic in sys_page_unmap()\n");
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	68 dc 2f 80 00       	push   $0x802fdc
  8012ce:	6a 39                	push   $0x39
  8012d0:	68 89 2f 80 00       	push   $0x802f89
  8012d5:	e8 ee 14 00 00       	call   8027c8 <_panic>

008012da <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	57                   	push   %edi
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
  8012e0:	83 ec 18             	sub    $0x18,%esp
	int ret;
	set_pgfault_handler(pgfault);
  8012e3:	68 db 11 80 00       	push   $0x8011db
  8012e8:	e8 3c 15 00 00       	call   802829 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012ed:	b8 07 00 00 00       	mov    $0x7,%eax
  8012f2:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	78 2a                	js     801325 <fork+0x4b>
  8012fb:	89 c6                	mov    %eax,%esi
  8012fd:	89 c7                	mov    %eax,%edi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  8012ff:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  801304:	75 4b                	jne    801351 <fork+0x77>
		thisenv = &envs[ENVX(sys_getenvid())];
  801306:	e8 47 fa ff ff       	call   800d52 <sys_getenvid>
  80130b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801310:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801316:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131b:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801320:	e9 90 00 00 00       	jmp    8013b5 <fork+0xdb>
		panic("the fork panic! at sys_exofork()\n");
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	68 f8 2f 80 00       	push   $0x802ff8
  80132d:	68 8c 00 00 00       	push   $0x8c
  801332:	68 89 2f 80 00       	push   $0x802f89
  801337:	e8 8c 14 00 00       	call   8027c8 <_panic>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
			duppage(child_envid, PGNUM(i));
  80133c:	89 f8                	mov    %edi,%eax
  80133e:	e8 42 fd ff ff       	call   801085 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801343:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801349:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80134f:	74 26                	je     801377 <fork+0x9d>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U)))
  801351:	89 d8                	mov    %ebx,%eax
  801353:	c1 e8 16             	shr    $0x16,%eax
  801356:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80135d:	a8 01                	test   $0x1,%al
  80135f:	74 e2                	je     801343 <fork+0x69>
  801361:	89 da                	mov    %ebx,%edx
  801363:	c1 ea 0c             	shr    $0xc,%edx
  801366:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80136d:	83 e0 05             	and    $0x5,%eax
  801370:	83 f8 05             	cmp    $0x5,%eax
  801373:	75 ce                	jne    801343 <fork+0x69>
  801375:	eb c5                	jmp    80133c <fork+0x62>
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	6a 07                	push   $0x7
  80137c:	68 00 f0 bf ee       	push   $0xeebff000
  801381:	56                   	push   %esi
  801382:	e8 09 fa ff ff       	call   800d90 <sys_page_alloc>
	if(ret < 0)
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 31                	js     8013bf <fork+0xe5>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	68 98 28 80 00       	push   $0x802898
  801396:	56                   	push   %esi
  801397:	e8 3f fb ff ff       	call   800edb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	78 33                	js     8013d6 <fork+0xfc>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  8013a3:	83 ec 08             	sub    $0x8,%esp
  8013a6:	6a 02                	push   $0x2
  8013a8:	56                   	push   %esi
  8013a9:	e8 a9 fa ff ff       	call   800e57 <sys_env_set_status>
	if(ret < 0)
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 38                	js     8013ed <fork+0x113>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
	// LAB 4: Your code here.
	// panic("fork not implemented");
}
  8013b5:	89 f0                	mov    %esi,%eax
  8013b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ba:	5b                   	pop    %ebx
  8013bb:	5e                   	pop    %esi
  8013bc:	5f                   	pop    %edi
  8013bd:	5d                   	pop    %ebp
  8013be:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 a8 2f 80 00       	push   $0x802fa8
  8013c7:	68 98 00 00 00       	push   $0x98
  8013cc:	68 89 2f 80 00       	push   $0x802f89
  8013d1:	e8 f2 13 00 00       	call   8027c8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	68 1c 30 80 00       	push   $0x80301c
  8013de:	68 9b 00 00 00       	push   $0x9b
  8013e3:	68 89 2f 80 00       	push   $0x802f89
  8013e8:	e8 db 13 00 00       	call   8027c8 <_panic>
		panic("panic in sys_env_set_status()\n");
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	68 44 30 80 00       	push   $0x803044
  8013f5:	68 9e 00 00 00       	push   $0x9e
  8013fa:	68 89 2f 80 00       	push   $0x802f89
  8013ff:	e8 c4 13 00 00       	call   8027c8 <_panic>

00801404 <sfork>:

// Challenge!
int
sfork(void)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
  80140a:	83 ec 18             	sub    $0x18,%esp
	// panic("sfork not implemented");
	// envid_t child_envid = sys_exofork();
	// return -E_INVAL;
	int ret;
	set_pgfault_handler(pgfault);
  80140d:	68 db 11 80 00       	push   $0x8011db
  801412:	e8 12 14 00 00       	call   802829 <set_pgfault_handler>
  801417:	b8 07 00 00 00       	mov    $0x7,%eax
  80141c:	cd 30                	int    $0x30
	envid_t child_envid = sys_exofork();
	if(child_envid < 0)
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 2a                	js     80144f <sfork+0x4b>
  801425:	89 c7                	mov    %eax,%edi
  801427:	89 c6                	mov    %eax,%esi
		panic("the fork panic! at sys_exofork()\n");
	if(child_envid == 0){
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801429:	bb 00 00 80 00       	mov    $0x800000,%ebx
	if(child_envid == 0){
  80142e:	75 58                	jne    801488 <sfork+0x84>
		thisenv = &envs[ENVX(sys_getenvid())];
  801430:	e8 1d f9 ff ff       	call   800d52 <sys_getenvid>
  801435:	25 ff 03 00 00       	and    $0x3ff,%eax
  80143a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801440:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801445:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80144a:	e9 d4 00 00 00       	jmp    801523 <sfork+0x11f>
		panic("the fork panic! at sys_exofork()\n");
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 f8 2f 80 00       	push   $0x802ff8
  801457:	68 af 00 00 00       	push   $0xaf
  80145c:	68 89 2f 80 00       	push   $0x802f89
  801461:	e8 62 13 00 00       	call   8027c8 <_panic>
		if(i == (USTACKTOP - PGSIZE))
			duppage(child_envid, PGNUM(i));
  801466:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80146b:	89 f0                	mov    %esi,%eax
  80146d:	e8 13 fc ff ff       	call   801085 <duppage>
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){	//lab4 bug not TXSTACKTOP
  801472:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801478:	81 fb ff df bf ee    	cmp    $0xeebfdfff,%ebx
  80147e:	77 65                	ja     8014e5 <sfork+0xe1>
		if(i == (USTACKTOP - PGSIZE))
  801480:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801486:	74 de                	je     801466 <sfork+0x62>
		else if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U)) == (PTE_P | PTE_U))){
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	c1 e8 16             	shr    $0x16,%eax
  80148d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801494:	a8 01                	test   $0x1,%al
  801496:	74 da                	je     801472 <sfork+0x6e>
  801498:	89 da                	mov    %ebx,%edx
  80149a:	c1 ea 0c             	shr    $0xc,%edx
  80149d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014a4:	83 e0 05             	and    $0x5,%eax
  8014a7:	83 f8 05             	cmp    $0x5,%eax
  8014aa:	75 c6                	jne    801472 <sfork+0x6e>
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
						((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_W)))))
  8014ac:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
			if(sys_page_map(0, (void *)(PGNUM(i) * PGSIZE), child_envid, (void *)(PGNUM(i) * PGSIZE), 
  8014b3:	c1 e2 0c             	shl    $0xc,%edx
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	83 e0 07             	and    $0x7,%eax
  8014bc:	50                   	push   %eax
  8014bd:	52                   	push   %edx
  8014be:	56                   	push   %esi
  8014bf:	52                   	push   %edx
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 0c f9 ff ff       	call   800dd3 <sys_page_map>
  8014c7:	83 c4 20             	add    $0x20,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	74 a4                	je     801472 <sfork+0x6e>
				panic("sys_page_map() panic\n");
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	68 73 2f 80 00       	push   $0x802f73
  8014d6:	68 ba 00 00 00       	push   $0xba
  8014db:	68 89 2f 80 00       	push   $0x802f89
  8014e0:	e8 e3 12 00 00       	call   8027c8 <_panic>
		}
	}
	
	ret = sys_page_alloc(child_envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W);
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	6a 07                	push   $0x7
  8014ea:	68 00 f0 bf ee       	push   $0xeebff000
  8014ef:	57                   	push   %edi
  8014f0:	e8 9b f8 ff ff       	call   800d90 <sys_page_alloc>
	if(ret < 0)
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 31                	js     80152d <sfork+0x129>
		panic("panic in sys_page_alloc()\n");
	ret = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall);
  8014fc:	83 ec 08             	sub    $0x8,%esp
  8014ff:	68 98 28 80 00       	push   $0x802898
  801504:	57                   	push   %edi
  801505:	e8 d1 f9 ff ff       	call   800edb <sys_env_set_pgfault_upcall>
	if(ret < 0)
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	85 c0                	test   %eax,%eax
  80150f:	78 33                	js     801544 <sfork+0x140>
		panic("panic in sys_env_set_pgfault_upcall()\n");
	ret = sys_env_set_status(child_envid, ENV_RUNNABLE);
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	6a 02                	push   $0x2
  801516:	57                   	push   %edi
  801517:	e8 3b f9 ff ff       	call   800e57 <sys_env_set_status>
	if(ret < 0)
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 38                	js     80155b <sfork+0x157>
		panic("panic in sys_env_set_status()\n");
	return child_envid;
  801523:	89 f8                	mov    %edi,%eax
  801525:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801528:	5b                   	pop    %ebx
  801529:	5e                   	pop    %esi
  80152a:	5f                   	pop    %edi
  80152b:	5d                   	pop    %ebp
  80152c:	c3                   	ret    
		panic("panic in sys_page_alloc()\n");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 a8 2f 80 00       	push   $0x802fa8
  801535:	68 c0 00 00 00       	push   $0xc0
  80153a:	68 89 2f 80 00       	push   $0x802f89
  80153f:	e8 84 12 00 00       	call   8027c8 <_panic>
		panic("panic in sys_env_set_pgfault_upcall()\n");
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	68 1c 30 80 00       	push   $0x80301c
  80154c:	68 c3 00 00 00       	push   $0xc3
  801551:	68 89 2f 80 00       	push   $0x802f89
  801556:	e8 6d 12 00 00       	call   8027c8 <_panic>
		panic("panic in sys_env_set_status()\n");
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	68 44 30 80 00       	push   $0x803044
  801563:	68 c6 00 00 00       	push   $0xc6
  801568:	68 89 2f 80 00       	push   $0x802f89
  80156d:	e8 56 12 00 00       	call   8027c8 <_panic>

00801572 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	56                   	push   %esi
  801576:	53                   	push   %ebx
  801577:	8b 75 08             	mov    0x8(%ebp),%esi
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801580:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801582:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801587:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80158a:	83 ec 0c             	sub    $0xc,%esp
  80158d:	50                   	push   %eax
  80158e:	e8 ad f9 ff ff       	call   800f40 <sys_ipc_recv>
	if(ret < 0){
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 2b                	js     8015c5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80159a:	85 f6                	test   %esi,%esi
  80159c:	74 0a                	je     8015a8 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80159e:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015a3:	8b 40 78             	mov    0x78(%eax),%eax
  8015a6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8015a8:	85 db                	test   %ebx,%ebx
  8015aa:	74 0a                	je     8015b6 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8015ac:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015b1:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015b4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8015b6:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8015bb:	8b 40 74             	mov    0x74(%eax),%eax
}
  8015be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    
		if(from_env_store)
  8015c5:	85 f6                	test   %esi,%esi
  8015c7:	74 06                	je     8015cf <ipc_recv+0x5d>
			*from_env_store = 0;
  8015c9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8015cf:	85 db                	test   %ebx,%ebx
  8015d1:	74 eb                	je     8015be <ipc_recv+0x4c>
			*perm_store = 0;
  8015d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015d9:	eb e3                	jmp    8015be <ipc_recv+0x4c>

008015db <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	57                   	push   %edi
  8015df:	56                   	push   %esi
  8015e0:	53                   	push   %ebx
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8015ed:	85 db                	test   %ebx,%ebx
  8015ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8015f4:	0f 44 d8             	cmove  %eax,%ebx
  8015f7:	eb 05                	jmp    8015fe <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8015f9:	e8 73 f7 ff ff       	call   800d71 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8015fe:	ff 75 14             	pushl  0x14(%ebp)
  801601:	53                   	push   %ebx
  801602:	56                   	push   %esi
  801603:	57                   	push   %edi
  801604:	e8 14 f9 ff ff       	call   800f1d <sys_ipc_try_send>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	74 1b                	je     80162b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801610:	79 e7                	jns    8015f9 <ipc_send+0x1e>
  801612:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801615:	74 e2                	je     8015f9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	68 63 30 80 00       	push   $0x803063
  80161f:	6a 46                	push   $0x46
  801621:	68 78 30 80 00       	push   $0x803078
  801626:	e8 9d 11 00 00       	call   8027c8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80162b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80162e:	5b                   	pop    %ebx
  80162f:	5e                   	pop    %esi
  801630:	5f                   	pop    %edi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80163e:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  801644:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80164a:	8b 52 50             	mov    0x50(%edx),%edx
  80164d:	39 ca                	cmp    %ecx,%edx
  80164f:	74 11                	je     801662 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801651:	83 c0 01             	add    $0x1,%eax
  801654:	3d 00 04 00 00       	cmp    $0x400,%eax
  801659:	75 e3                	jne    80163e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	eb 0e                	jmp    801670 <ipc_find_env+0x3d>
			return envs[i].env_id;
  801662:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801668:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80166d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	05 00 00 00 30       	add    $0x30000000,%eax
  80167d:	c1 e8 0c             	shr    $0xc,%eax
}
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80168d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801692:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016a1:	89 c2                	mov    %eax,%edx
  8016a3:	c1 ea 16             	shr    $0x16,%edx
  8016a6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ad:	f6 c2 01             	test   $0x1,%dl
  8016b0:	74 2d                	je     8016df <fd_alloc+0x46>
  8016b2:	89 c2                	mov    %eax,%edx
  8016b4:	c1 ea 0c             	shr    $0xc,%edx
  8016b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016be:	f6 c2 01             	test   $0x1,%dl
  8016c1:	74 1c                	je     8016df <fd_alloc+0x46>
  8016c3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016c8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016cd:	75 d2                	jne    8016a1 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016d8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016dd:	eb 0a                	jmp    8016e9 <fd_alloc+0x50>
			*fd_store = fd;
  8016df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016e2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016f1:	83 f8 1f             	cmp    $0x1f,%eax
  8016f4:	77 30                	ja     801726 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016f6:	c1 e0 0c             	shl    $0xc,%eax
  8016f9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016fe:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801704:	f6 c2 01             	test   $0x1,%dl
  801707:	74 24                	je     80172d <fd_lookup+0x42>
  801709:	89 c2                	mov    %eax,%edx
  80170b:	c1 ea 0c             	shr    $0xc,%edx
  80170e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801715:	f6 c2 01             	test   $0x1,%dl
  801718:	74 1a                	je     801734 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	89 02                	mov    %eax,(%edx)
	return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    
		return -E_INVAL;
  801726:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172b:	eb f7                	jmp    801724 <fd_lookup+0x39>
		return -E_INVAL;
  80172d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801732:	eb f0                	jmp    801724 <fd_lookup+0x39>
  801734:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801739:	eb e9                	jmp    801724 <fd_lookup+0x39>

0080173b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80174e:	39 08                	cmp    %ecx,(%eax)
  801750:	74 38                	je     80178a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801752:	83 c2 01             	add    $0x1,%edx
  801755:	8b 04 95 00 31 80 00 	mov    0x803100(,%edx,4),%eax
  80175c:	85 c0                	test   %eax,%eax
  80175e:	75 ee                	jne    80174e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801760:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801765:	8b 40 48             	mov    0x48(%eax),%eax
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	51                   	push   %ecx
  80176c:	50                   	push   %eax
  80176d:	68 84 30 80 00       	push   $0x803084
  801772:	e8 c8 ea ff ff       	call   80023f <cprintf>
	*dev = 0;
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    
			*dev = devtab[i];
  80178a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80178d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb f2                	jmp    801788 <dev_lookup+0x4d>

00801796 <fd_close>:
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 24             	sub    $0x24,%esp
  80179f:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017af:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017b2:	50                   	push   %eax
  8017b3:	e8 33 ff ff ff       	call   8016eb <fd_lookup>
  8017b8:	89 c3                	mov    %eax,%ebx
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 05                	js     8017c6 <fd_close+0x30>
	    || fd != fd2)
  8017c1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017c4:	74 16                	je     8017dc <fd_close+0x46>
		return (must_exist ? r : 0);
  8017c6:	89 f8                	mov    %edi,%eax
  8017c8:	84 c0                	test   %al,%al
  8017ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cf:	0f 44 d8             	cmove  %eax,%ebx
}
  8017d2:	89 d8                	mov    %ebx,%eax
  8017d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5e                   	pop    %esi
  8017d9:	5f                   	pop    %edi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017e2:	50                   	push   %eax
  8017e3:	ff 36                	pushl  (%esi)
  8017e5:	e8 51 ff ff ff       	call   80173b <dev_lookup>
  8017ea:	89 c3                	mov    %eax,%ebx
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 1a                	js     80180d <fd_close+0x77>
		if (dev->dev_close)
  8017f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017f9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8017fe:	85 c0                	test   %eax,%eax
  801800:	74 0b                	je     80180d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801802:	83 ec 0c             	sub    $0xc,%esp
  801805:	56                   	push   %esi
  801806:	ff d0                	call   *%eax
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	56                   	push   %esi
  801811:	6a 00                	push   $0x0
  801813:	e8 fd f5 ff ff       	call   800e15 <sys_page_unmap>
	return r;
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	eb b5                	jmp    8017d2 <fd_close+0x3c>

0080181d <close>:

int
close(int fdnum)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801823:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 bc fe ff ff       	call   8016eb <fd_lookup>
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	79 02                	jns    801838 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    
		return fd_close(fd, 1);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	6a 01                	push   $0x1
  80183d:	ff 75 f4             	pushl  -0xc(%ebp)
  801840:	e8 51 ff ff ff       	call   801796 <fd_close>
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	eb ec                	jmp    801836 <close+0x19>

0080184a <close_all>:

void
close_all(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	53                   	push   %ebx
  80184e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801851:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	53                   	push   %ebx
  80185a:	e8 be ff ff ff       	call   80181d <close>
	for (i = 0; i < MAXFD; i++)
  80185f:	83 c3 01             	add    $0x1,%ebx
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	83 fb 20             	cmp    $0x20,%ebx
  801868:	75 ec                	jne    801856 <close_all+0xc>
}
  80186a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	57                   	push   %edi
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801878:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80187b:	50                   	push   %eax
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	e8 67 fe ff ff       	call   8016eb <fd_lookup>
  801884:	89 c3                	mov    %eax,%ebx
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	0f 88 81 00 00 00    	js     801912 <dup+0xa3>
		return r;
	close(newfdnum);
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	e8 81 ff ff ff       	call   80181d <close>

	newfd = INDEX2FD(newfdnum);
  80189c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80189f:	c1 e6 0c             	shl    $0xc,%esi
  8018a2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018a8:	83 c4 04             	add    $0x4,%esp
  8018ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018ae:	e8 cf fd ff ff       	call   801682 <fd2data>
  8018b3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018b5:	89 34 24             	mov    %esi,(%esp)
  8018b8:	e8 c5 fd ff ff       	call   801682 <fd2data>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018c2:	89 d8                	mov    %ebx,%eax
  8018c4:	c1 e8 16             	shr    $0x16,%eax
  8018c7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018ce:	a8 01                	test   $0x1,%al
  8018d0:	74 11                	je     8018e3 <dup+0x74>
  8018d2:	89 d8                	mov    %ebx,%eax
  8018d4:	c1 e8 0c             	shr    $0xc,%eax
  8018d7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018de:	f6 c2 01             	test   $0x1,%dl
  8018e1:	75 39                	jne    80191c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	c1 e8 0c             	shr    $0xc,%eax
  8018eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018f2:	83 ec 0c             	sub    $0xc,%esp
  8018f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8018fa:	50                   	push   %eax
  8018fb:	56                   	push   %esi
  8018fc:	6a 00                	push   $0x0
  8018fe:	52                   	push   %edx
  8018ff:	6a 00                	push   $0x0
  801901:	e8 cd f4 ff ff       	call   800dd3 <sys_page_map>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 20             	add    $0x20,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 31                	js     801940 <dup+0xd1>
		goto err;

	return newfdnum;
  80190f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801912:	89 d8                	mov    %ebx,%eax
  801914:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801917:	5b                   	pop    %ebx
  801918:	5e                   	pop    %esi
  801919:	5f                   	pop    %edi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80191c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801923:	83 ec 0c             	sub    $0xc,%esp
  801926:	25 07 0e 00 00       	and    $0xe07,%eax
  80192b:	50                   	push   %eax
  80192c:	57                   	push   %edi
  80192d:	6a 00                	push   $0x0
  80192f:	53                   	push   %ebx
  801930:	6a 00                	push   $0x0
  801932:	e8 9c f4 ff ff       	call   800dd3 <sys_page_map>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	83 c4 20             	add    $0x20,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	79 a3                	jns    8018e3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	56                   	push   %esi
  801944:	6a 00                	push   $0x0
  801946:	e8 ca f4 ff ff       	call   800e15 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80194b:	83 c4 08             	add    $0x8,%esp
  80194e:	57                   	push   %edi
  80194f:	6a 00                	push   $0x0
  801951:	e8 bf f4 ff ff       	call   800e15 <sys_page_unmap>
	return r;
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	eb b7                	jmp    801912 <dup+0xa3>

0080195b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	53                   	push   %ebx
  80195f:	83 ec 1c             	sub    $0x1c,%esp
  801962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801965:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801968:	50                   	push   %eax
  801969:	53                   	push   %ebx
  80196a:	e8 7c fd ff ff       	call   8016eb <fd_lookup>
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	78 3f                	js     8019b5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197c:	50                   	push   %eax
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801980:	ff 30                	pushl  (%eax)
  801982:	e8 b4 fd ff ff       	call   80173b <dev_lookup>
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 27                	js     8019b5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80198e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801991:	8b 42 08             	mov    0x8(%edx),%eax
  801994:	83 e0 03             	and    $0x3,%eax
  801997:	83 f8 01             	cmp    $0x1,%eax
  80199a:	74 1e                	je     8019ba <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	8b 40 08             	mov    0x8(%eax),%eax
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	74 35                	je     8019db <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	ff 75 10             	pushl  0x10(%ebp)
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	52                   	push   %edx
  8019b0:	ff d0                	call   *%eax
  8019b2:	83 c4 10             	add    $0x10,%esp
}
  8019b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ba:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8019bf:	8b 40 48             	mov    0x48(%eax),%eax
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	53                   	push   %ebx
  8019c6:	50                   	push   %eax
  8019c7:	68 c5 30 80 00       	push   $0x8030c5
  8019cc:	e8 6e e8 ff ff       	call   80023f <cprintf>
		return -E_INVAL;
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d9:	eb da                	jmp    8019b5 <read+0x5a>
		return -E_NOT_SUPP;
  8019db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e0:	eb d3                	jmp    8019b5 <read+0x5a>

008019e2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	57                   	push   %edi
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f6:	39 f3                	cmp    %esi,%ebx
  8019f8:	73 23                	jae    801a1d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	89 f0                	mov    %esi,%eax
  8019ff:	29 d8                	sub    %ebx,%eax
  801a01:	50                   	push   %eax
  801a02:	89 d8                	mov    %ebx,%eax
  801a04:	03 45 0c             	add    0xc(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	57                   	push   %edi
  801a09:	e8 4d ff ff ff       	call   80195b <read>
		if (m < 0)
  801a0e:	83 c4 10             	add    $0x10,%esp
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 06                	js     801a1b <readn+0x39>
			return m;
		if (m == 0)
  801a15:	74 06                	je     801a1d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801a17:	01 c3                	add    %eax,%ebx
  801a19:	eb db                	jmp    8019f6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a1b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a1d:	89 d8                	mov    %ebx,%eax
  801a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5e                   	pop    %esi
  801a24:	5f                   	pop    %edi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    

00801a27 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	53                   	push   %ebx
  801a2b:	83 ec 1c             	sub    $0x1c,%esp
  801a2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a31:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a34:	50                   	push   %eax
  801a35:	53                   	push   %ebx
  801a36:	e8 b0 fc ff ff       	call   8016eb <fd_lookup>
  801a3b:	83 c4 10             	add    $0x10,%esp
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 3a                	js     801a7c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a42:	83 ec 08             	sub    $0x8,%esp
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	50                   	push   %eax
  801a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4c:	ff 30                	pushl  (%eax)
  801a4e:	e8 e8 fc ff ff       	call   80173b <dev_lookup>
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 22                	js     801a7c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a5d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a61:	74 1e                	je     801a81 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	8b 52 0c             	mov    0xc(%edx),%edx
  801a69:	85 d2                	test   %edx,%edx
  801a6b:	74 35                	je     801aa2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	ff 75 10             	pushl  0x10(%ebp)
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	50                   	push   %eax
  801a77:	ff d2                	call   *%edx
  801a79:	83 c4 10             	add    $0x10,%esp
}
  801a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a81:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801a86:	8b 40 48             	mov    0x48(%eax),%eax
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	53                   	push   %ebx
  801a8d:	50                   	push   %eax
  801a8e:	68 e1 30 80 00       	push   $0x8030e1
  801a93:	e8 a7 e7 ff ff       	call   80023f <cprintf>
		return -E_INVAL;
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa0:	eb da                	jmp    801a7c <write+0x55>
		return -E_NOT_SUPP;
  801aa2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa7:	eb d3                	jmp    801a7c <write+0x55>

00801aa9 <seek>:

int
seek(int fdnum, off_t offset)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab2:	50                   	push   %eax
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 30 fc ff ff       	call   8016eb <fd_lookup>
  801abb:	83 c4 10             	add    $0x10,%esp
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 0e                	js     801ad0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 1c             	sub    $0x1c,%esp
  801ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801adc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801adf:	50                   	push   %eax
  801ae0:	53                   	push   %ebx
  801ae1:	e8 05 fc ff ff       	call   8016eb <fd_lookup>
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	78 37                	js     801b24 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af3:	50                   	push   %eax
  801af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af7:	ff 30                	pushl  (%eax)
  801af9:	e8 3d fc ff ff       	call   80173b <dev_lookup>
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 1f                	js     801b24 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b08:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b0c:	74 1b                	je     801b29 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b11:	8b 52 18             	mov    0x18(%edx),%edx
  801b14:	85 d2                	test   %edx,%edx
  801b16:	74 32                	je     801b4a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b18:	83 ec 08             	sub    $0x8,%esp
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	ff d2                	call   *%edx
  801b21:	83 c4 10             	add    $0x10,%esp
}
  801b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b29:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b2e:	8b 40 48             	mov    0x48(%eax),%eax
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	53                   	push   %ebx
  801b35:	50                   	push   %eax
  801b36:	68 a4 30 80 00       	push   $0x8030a4
  801b3b:	e8 ff e6 ff ff       	call   80023f <cprintf>
		return -E_INVAL;
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b48:	eb da                	jmp    801b24 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801b4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4f:	eb d3                	jmp    801b24 <ftruncate+0x52>

00801b51 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	53                   	push   %ebx
  801b55:	83 ec 1c             	sub    $0x1c,%esp
  801b58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5e:	50                   	push   %eax
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	e8 84 fb ff ff       	call   8016eb <fd_lookup>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 4b                	js     801bb9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b74:	50                   	push   %eax
  801b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b78:	ff 30                	pushl  (%eax)
  801b7a:	e8 bc fb ff ff       	call   80173b <dev_lookup>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 33                	js     801bb9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b8d:	74 2f                	je     801bbe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b8f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b92:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b99:	00 00 00 
	stat->st_isdir = 0;
  801b9c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ba3:	00 00 00 
	stat->st_dev = dev;
  801ba6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	53                   	push   %ebx
  801bb0:	ff 75 f0             	pushl  -0x10(%ebp)
  801bb3:	ff 50 14             	call   *0x14(%eax)
  801bb6:	83 c4 10             	add    $0x10,%esp
}
  801bb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    
		return -E_NOT_SUPP;
  801bbe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc3:	eb f4                	jmp    801bb9 <fstat+0x68>

00801bc5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	56                   	push   %esi
  801bc9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	e8 22 02 00 00       	call   801df9 <open>
  801bd7:	89 c3                	mov    %eax,%ebx
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 1b                	js     801bfb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	50                   	push   %eax
  801be7:	e8 65 ff ff ff       	call   801b51 <fstat>
  801bec:	89 c6                	mov    %eax,%esi
	close(fd);
  801bee:	89 1c 24             	mov    %ebx,(%esp)
  801bf1:	e8 27 fc ff ff       	call   80181d <close>
	return r;
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	89 f3                	mov    %esi,%ebx
}
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	56                   	push   %esi
  801c08:	53                   	push   %ebx
  801c09:	89 c6                	mov    %eax,%esi
  801c0b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c0d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c14:	74 27                	je     801c3d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c16:	6a 07                	push   $0x7
  801c18:	68 00 60 80 00       	push   $0x806000
  801c1d:	56                   	push   %esi
  801c1e:	ff 35 00 50 80 00    	pushl  0x805000
  801c24:	e8 b2 f9 ff ff       	call   8015db <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c29:	83 c4 0c             	add    $0xc,%esp
  801c2c:	6a 00                	push   $0x0
  801c2e:	53                   	push   %ebx
  801c2f:	6a 00                	push   $0x0
  801c31:	e8 3c f9 ff ff       	call   801572 <ipc_recv>
}
  801c36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c39:	5b                   	pop    %ebx
  801c3a:	5e                   	pop    %esi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	6a 01                	push   $0x1
  801c42:	e8 ec f9 ff ff       	call   801633 <ipc_find_env>
  801c47:	a3 00 50 80 00       	mov    %eax,0x805000
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	eb c5                	jmp    801c16 <fsipc+0x12>

00801c51 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5d:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6f:	b8 02 00 00 00       	mov    $0x2,%eax
  801c74:	e8 8b ff ff ff       	call   801c04 <fsipc>
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <devfile_flush>:
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8b 40 0c             	mov    0xc(%eax),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c91:	b8 06 00 00 00       	mov    $0x6,%eax
  801c96:	e8 69 ff ff ff       	call   801c04 <fsipc>
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <devfile_stat>:
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	53                   	push   %ebx
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8b 40 0c             	mov    0xc(%eax),%eax
  801cad:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb7:	b8 05 00 00 00       	mov    $0x5,%eax
  801cbc:	e8 43 ff ff ff       	call   801c04 <fsipc>
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 2c                	js     801cf1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cc5:	83 ec 08             	sub    $0x8,%esp
  801cc8:	68 00 60 80 00       	push   $0x806000
  801ccd:	53                   	push   %ebx
  801cce:	e8 cb ec ff ff       	call   80099e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cd3:	a1 80 60 80 00       	mov    0x806080,%eax
  801cd8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cde:	a1 84 60 80 00       	mov    0x806084,%eax
  801ce3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <devfile_write>:
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	53                   	push   %ebx
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8b 40 0c             	mov    0xc(%eax),%eax
  801d06:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  801d0b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801d11:	53                   	push   %ebx
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	68 08 60 80 00       	push   $0x806008
  801d1a:	e8 6f ee ff ff       	call   800b8e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d24:	b8 04 00 00 00       	mov    $0x4,%eax
  801d29:	e8 d6 fe ff ff       	call   801c04 <fsipc>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 0b                	js     801d40 <devfile_write+0x4a>
	assert(r <= n);
  801d35:	39 d8                	cmp    %ebx,%eax
  801d37:	77 0c                	ja     801d45 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801d39:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d3e:	7f 1e                	jg     801d5e <devfile_write+0x68>
}
  801d40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    
	assert(r <= n);
  801d45:	68 14 31 80 00       	push   $0x803114
  801d4a:	68 1b 31 80 00       	push   $0x80311b
  801d4f:	68 98 00 00 00       	push   $0x98
  801d54:	68 30 31 80 00       	push   $0x803130
  801d59:	e8 6a 0a 00 00       	call   8027c8 <_panic>
	assert(r <= PGSIZE);
  801d5e:	68 3b 31 80 00       	push   $0x80313b
  801d63:	68 1b 31 80 00       	push   $0x80311b
  801d68:	68 99 00 00 00       	push   $0x99
  801d6d:	68 30 31 80 00       	push   $0x803130
  801d72:	e8 51 0a 00 00       	call   8027c8 <_panic>

00801d77 <devfile_read>:
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 40 0c             	mov    0xc(%eax),%eax
  801d85:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d8a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d90:	ba 00 00 00 00       	mov    $0x0,%edx
  801d95:	b8 03 00 00 00       	mov    $0x3,%eax
  801d9a:	e8 65 fe ff ff       	call   801c04 <fsipc>
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	85 c0                	test   %eax,%eax
  801da3:	78 1f                	js     801dc4 <devfile_read+0x4d>
	assert(r <= n);
  801da5:	39 f0                	cmp    %esi,%eax
  801da7:	77 24                	ja     801dcd <devfile_read+0x56>
	assert(r <= PGSIZE);
  801da9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dae:	7f 33                	jg     801de3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	50                   	push   %eax
  801db4:	68 00 60 80 00       	push   $0x806000
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	e8 6b ed ff ff       	call   800b2c <memmove>
	return r;
  801dc1:	83 c4 10             	add    $0x10,%esp
}
  801dc4:	89 d8                	mov    %ebx,%eax
  801dc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    
	assert(r <= n);
  801dcd:	68 14 31 80 00       	push   $0x803114
  801dd2:	68 1b 31 80 00       	push   $0x80311b
  801dd7:	6a 7c                	push   $0x7c
  801dd9:	68 30 31 80 00       	push   $0x803130
  801dde:	e8 e5 09 00 00       	call   8027c8 <_panic>
	assert(r <= PGSIZE);
  801de3:	68 3b 31 80 00       	push   $0x80313b
  801de8:	68 1b 31 80 00       	push   $0x80311b
  801ded:	6a 7d                	push   $0x7d
  801def:	68 30 31 80 00       	push   $0x803130
  801df4:	e8 cf 09 00 00       	call   8027c8 <_panic>

00801df9 <open>:
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	83 ec 1c             	sub    $0x1c,%esp
  801e01:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e04:	56                   	push   %esi
  801e05:	e8 5b eb ff ff       	call   800965 <strlen>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e12:	7f 6c                	jg     801e80 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801e14:	83 ec 0c             	sub    $0xc,%esp
  801e17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1a:	50                   	push   %eax
  801e1b:	e8 79 f8 ff ff       	call   801699 <fd_alloc>
  801e20:	89 c3                	mov    %eax,%ebx
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 3c                	js     801e65 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801e29:	83 ec 08             	sub    $0x8,%esp
  801e2c:	56                   	push   %esi
  801e2d:	68 00 60 80 00       	push   $0x806000
  801e32:	e8 67 eb ff ff       	call   80099e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	e8 b8 fd ff ff       	call   801c04 <fsipc>
  801e4c:	89 c3                	mov    %eax,%ebx
  801e4e:	83 c4 10             	add    $0x10,%esp
  801e51:	85 c0                	test   %eax,%eax
  801e53:	78 19                	js     801e6e <open+0x75>
	return fd2num(fd);
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5b:	e8 12 f8 ff ff       	call   801672 <fd2num>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	83 c4 10             	add    $0x10,%esp
}
  801e65:	89 d8                	mov    %ebx,%eax
  801e67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    
		fd_close(fd, 0);
  801e6e:	83 ec 08             	sub    $0x8,%esp
  801e71:	6a 00                	push   $0x0
  801e73:	ff 75 f4             	pushl  -0xc(%ebp)
  801e76:	e8 1b f9 ff ff       	call   801796 <fd_close>
		return r;
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	eb e5                	jmp    801e65 <open+0x6c>
		return -E_BAD_PATH;
  801e80:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e85:	eb de                	jmp    801e65 <open+0x6c>

00801e87 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e92:	b8 08 00 00 00       	mov    $0x8,%eax
  801e97:	e8 68 fd ff ff       	call   801c04 <fsipc>
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ea4:	68 47 31 80 00       	push   $0x803147
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	e8 ed ea ff ff       	call   80099e <strcpy>
	return 0;
}
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <devsock_close>:
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	53                   	push   %ebx
  801ebc:	83 ec 10             	sub    $0x10,%esp
  801ebf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ec2:	53                   	push   %ebx
  801ec3:	e8 f6 09 00 00       	call   8028be <pageref>
  801ec8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ecb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801ed0:	83 f8 01             	cmp    $0x1,%eax
  801ed3:	74 07                	je     801edc <devsock_close+0x24>
}
  801ed5:	89 d0                	mov    %edx,%eax
  801ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	ff 73 0c             	pushl  0xc(%ebx)
  801ee2:	e8 b9 02 00 00       	call   8021a0 <nsipc_close>
  801ee7:	89 c2                	mov    %eax,%edx
  801ee9:	83 c4 10             	add    $0x10,%esp
  801eec:	eb e7                	jmp    801ed5 <devsock_close+0x1d>

00801eee <devsock_write>:
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	ff 75 10             	pushl  0x10(%ebp)
  801ef9:	ff 75 0c             	pushl  0xc(%ebp)
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	ff 70 0c             	pushl  0xc(%eax)
  801f02:	e8 76 03 00 00       	call   80227d <nsipc_send>
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <devsock_read>:
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f0f:	6a 00                	push   $0x0
  801f11:	ff 75 10             	pushl  0x10(%ebp)
  801f14:	ff 75 0c             	pushl  0xc(%ebp)
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	ff 70 0c             	pushl  0xc(%eax)
  801f1d:	e8 ef 02 00 00       	call   802211 <nsipc_recv>
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <fd2sockid>:
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f2a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	e8 b7 f7 ff ff       	call   8016eb <fd_lookup>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 10                	js     801f4b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f44:	39 08                	cmp    %ecx,(%eax)
  801f46:	75 05                	jne    801f4d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f48:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    
		return -E_NOT_SUPP;
  801f4d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f52:	eb f7                	jmp    801f4b <fd2sockid+0x27>

00801f54 <alloc_sockfd>:
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 1c             	sub    $0x1c,%esp
  801f5c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f61:	50                   	push   %eax
  801f62:	e8 32 f7 ff ff       	call   801699 <fd_alloc>
  801f67:	89 c3                	mov    %eax,%ebx
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	78 43                	js     801fb3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	68 07 04 00 00       	push   $0x407
  801f78:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 0e ee ff ff       	call   800d90 <sys_page_alloc>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	85 c0                	test   %eax,%eax
  801f89:	78 28                	js     801fb3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f94:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fa0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	50                   	push   %eax
  801fa7:	e8 c6 f6 ff ff       	call   801672 <fd2num>
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	eb 0c                	jmp    801fbf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	56                   	push   %esi
  801fb7:	e8 e4 01 00 00       	call   8021a0 <nsipc_close>
		return r;
  801fbc:	83 c4 10             	add    $0x10,%esp
}
  801fbf:	89 d8                	mov    %ebx,%eax
  801fc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <accept>:
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	e8 4e ff ff ff       	call   801f24 <fd2sockid>
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 1b                	js     801ff5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	ff 75 10             	pushl  0x10(%ebp)
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	50                   	push   %eax
  801fe4:	e8 0e 01 00 00       	call   8020f7 <nsipc_accept>
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	85 c0                	test   %eax,%eax
  801fee:	78 05                	js     801ff5 <accept+0x2d>
	return alloc_sockfd(r);
  801ff0:	e8 5f ff ff ff       	call   801f54 <alloc_sockfd>
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <bind>:
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	e8 1f ff ff ff       	call   801f24 <fd2sockid>
  802005:	85 c0                	test   %eax,%eax
  802007:	78 12                	js     80201b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	ff 75 10             	pushl  0x10(%ebp)
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	50                   	push   %eax
  802013:	e8 31 01 00 00       	call   802149 <nsipc_bind>
  802018:	83 c4 10             	add    $0x10,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <shutdown>:
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	e8 f9 fe ff ff       	call   801f24 <fd2sockid>
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 0f                	js     80203e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80202f:	83 ec 08             	sub    $0x8,%esp
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	50                   	push   %eax
  802036:	e8 43 01 00 00       	call   80217e <nsipc_shutdown>
  80203b:	83 c4 10             	add    $0x10,%esp
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <connect>:
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	e8 d6 fe ff ff       	call   801f24 <fd2sockid>
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 12                	js     802064 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	ff 75 10             	pushl  0x10(%ebp)
  802058:	ff 75 0c             	pushl  0xc(%ebp)
  80205b:	50                   	push   %eax
  80205c:	e8 59 01 00 00       	call   8021ba <nsipc_connect>
  802061:	83 c4 10             	add    $0x10,%esp
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <listen>:
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	e8 b0 fe ff ff       	call   801f24 <fd2sockid>
  802074:	85 c0                	test   %eax,%eax
  802076:	78 0f                	js     802087 <listen+0x21>
	return nsipc_listen(r, backlog);
  802078:	83 ec 08             	sub    $0x8,%esp
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	50                   	push   %eax
  80207f:	e8 6b 01 00 00       	call   8021ef <nsipc_listen>
  802084:	83 c4 10             	add    $0x10,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <socket>:

int
socket(int domain, int type, int protocol)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80208f:	ff 75 10             	pushl  0x10(%ebp)
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	ff 75 08             	pushl  0x8(%ebp)
  802098:	e8 3e 02 00 00       	call   8022db <nsipc_socket>
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 05                	js     8020a9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020a4:	e8 ab fe ff ff       	call   801f54 <alloc_sockfd>
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	53                   	push   %ebx
  8020af:	83 ec 04             	sub    $0x4,%esp
  8020b2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020b4:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020bb:	74 26                	je     8020e3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020bd:	6a 07                	push   $0x7
  8020bf:	68 00 70 80 00       	push   $0x807000
  8020c4:	53                   	push   %ebx
  8020c5:	ff 35 04 50 80 00    	pushl  0x805004
  8020cb:	e8 0b f5 ff ff       	call   8015db <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020d0:	83 c4 0c             	add    $0xc,%esp
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	e8 94 f4 ff ff       	call   801572 <ipc_recv>
}
  8020de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	6a 02                	push   $0x2
  8020e8:	e8 46 f5 ff ff       	call   801633 <ipc_find_env>
  8020ed:	a3 04 50 80 00       	mov    %eax,0x805004
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	eb c6                	jmp    8020bd <nsipc+0x12>

008020f7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802107:	8b 06                	mov    (%esi),%eax
  802109:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80210e:	b8 01 00 00 00       	mov    $0x1,%eax
  802113:	e8 93 ff ff ff       	call   8020ab <nsipc>
  802118:	89 c3                	mov    %eax,%ebx
  80211a:	85 c0                	test   %eax,%eax
  80211c:	79 09                	jns    802127 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80211e:	89 d8                	mov    %ebx,%eax
  802120:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802123:	5b                   	pop    %ebx
  802124:	5e                   	pop    %esi
  802125:	5d                   	pop    %ebp
  802126:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	ff 35 10 70 80 00    	pushl  0x807010
  802130:	68 00 70 80 00       	push   $0x807000
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	e8 ef e9 ff ff       	call   800b2c <memmove>
		*addrlen = ret->ret_addrlen;
  80213d:	a1 10 70 80 00       	mov    0x807010,%eax
  802142:	89 06                	mov    %eax,(%esi)
  802144:	83 c4 10             	add    $0x10,%esp
	return r;
  802147:	eb d5                	jmp    80211e <nsipc_accept+0x27>

00802149 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	53                   	push   %ebx
  80214d:	83 ec 08             	sub    $0x8,%esp
  802150:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80215b:	53                   	push   %ebx
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	68 04 70 80 00       	push   $0x807004
  802164:	e8 c3 e9 ff ff       	call   800b2c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802169:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80216f:	b8 02 00 00 00       	mov    $0x2,%eax
  802174:	e8 32 ff ff ff       	call   8020ab <nsipc>
}
  802179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802194:	b8 03 00 00 00       	mov    $0x3,%eax
  802199:	e8 0d ff ff ff       	call   8020ab <nsipc>
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8021b3:	e8 f3 fe ff ff       	call   8020ab <nsipc>
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	53                   	push   %ebx
  8021be:	83 ec 08             	sub    $0x8,%esp
  8021c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021cc:	53                   	push   %ebx
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	68 04 70 80 00       	push   $0x807004
  8021d5:	e8 52 e9 ff ff       	call   800b2c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021da:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8021e5:	e8 c1 fe ff ff       	call   8020ab <nsipc>
}
  8021ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802205:	b8 06 00 00 00       	mov    $0x6,%eax
  80220a:	e8 9c fe ff ff       	call   8020ab <nsipc>
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	56                   	push   %esi
  802215:	53                   	push   %ebx
  802216:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802221:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802227:	8b 45 14             	mov    0x14(%ebp),%eax
  80222a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80222f:	b8 07 00 00 00       	mov    $0x7,%eax
  802234:	e8 72 fe ff ff       	call   8020ab <nsipc>
  802239:	89 c3                	mov    %eax,%ebx
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 1f                	js     80225e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80223f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802244:	7f 21                	jg     802267 <nsipc_recv+0x56>
  802246:	39 c6                	cmp    %eax,%esi
  802248:	7c 1d                	jl     802267 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	50                   	push   %eax
  80224e:	68 00 70 80 00       	push   $0x807000
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	e8 d1 e8 ff ff       	call   800b2c <memmove>
  80225b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80225e:	89 d8                	mov    %ebx,%eax
  802260:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5d                   	pop    %ebp
  802266:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802267:	68 53 31 80 00       	push   $0x803153
  80226c:	68 1b 31 80 00       	push   $0x80311b
  802271:	6a 62                	push   $0x62
  802273:	68 68 31 80 00       	push   $0x803168
  802278:	e8 4b 05 00 00       	call   8027c8 <_panic>

0080227d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	53                   	push   %ebx
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802295:	7f 2e                	jg     8022c5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	53                   	push   %ebx
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	68 0c 70 80 00       	push   $0x80700c
  8022a3:	e8 84 e8 ff ff       	call   800b2c <memmove>
	nsipcbuf.send.req_size = size;
  8022a8:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8022bb:	e8 eb fd ff ff       	call   8020ab <nsipc>
}
  8022c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    
	assert(size < 1600);
  8022c5:	68 74 31 80 00       	push   $0x803174
  8022ca:	68 1b 31 80 00       	push   $0x80311b
  8022cf:	6a 6d                	push   $0x6d
  8022d1:	68 68 31 80 00       	push   $0x803168
  8022d6:	e8 ed 04 00 00       	call   8027c8 <_panic>

008022db <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ec:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022f9:	b8 09 00 00 00       	mov    $0x9,%eax
  8022fe:	e8 a8 fd ff ff       	call   8020ab <nsipc>
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	56                   	push   %esi
  802309:	53                   	push   %ebx
  80230a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80230d:	83 ec 0c             	sub    $0xc,%esp
  802310:	ff 75 08             	pushl  0x8(%ebp)
  802313:	e8 6a f3 ff ff       	call   801682 <fd2data>
  802318:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80231a:	83 c4 08             	add    $0x8,%esp
  80231d:	68 80 31 80 00       	push   $0x803180
  802322:	53                   	push   %ebx
  802323:	e8 76 e6 ff ff       	call   80099e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802328:	8b 46 04             	mov    0x4(%esi),%eax
  80232b:	2b 06                	sub    (%esi),%eax
  80232d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802333:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80233a:	00 00 00 
	stat->st_dev = &devpipe;
  80233d:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802344:	40 80 00 
	return 0;
}
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    

00802353 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	53                   	push   %ebx
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80235d:	53                   	push   %ebx
  80235e:	6a 00                	push   $0x0
  802360:	e8 b0 ea ff ff       	call   800e15 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802365:	89 1c 24             	mov    %ebx,(%esp)
  802368:	e8 15 f3 ff ff       	call   801682 <fd2data>
  80236d:	83 c4 08             	add    $0x8,%esp
  802370:	50                   	push   %eax
  802371:	6a 00                	push   $0x0
  802373:	e8 9d ea ff ff       	call   800e15 <sys_page_unmap>
}
  802378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <_pipeisclosed>:
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
  802380:	57                   	push   %edi
  802381:	56                   	push   %esi
  802382:	53                   	push   %ebx
  802383:	83 ec 1c             	sub    $0x1c,%esp
  802386:	89 c7                	mov    %eax,%edi
  802388:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80238a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80238f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802392:	83 ec 0c             	sub    $0xc,%esp
  802395:	57                   	push   %edi
  802396:	e8 23 05 00 00       	call   8028be <pageref>
  80239b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80239e:	89 34 24             	mov    %esi,(%esp)
  8023a1:	e8 18 05 00 00       	call   8028be <pageref>
		nn = thisenv->env_runs;
  8023a6:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8023ac:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	39 cb                	cmp    %ecx,%ebx
  8023b4:	74 1b                	je     8023d1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023b9:	75 cf                	jne    80238a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023bb:	8b 42 58             	mov    0x58(%edx),%eax
  8023be:	6a 01                	push   $0x1
  8023c0:	50                   	push   %eax
  8023c1:	53                   	push   %ebx
  8023c2:	68 87 31 80 00       	push   $0x803187
  8023c7:	e8 73 de ff ff       	call   80023f <cprintf>
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	eb b9                	jmp    80238a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023d1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023d4:	0f 94 c0             	sete   %al
  8023d7:	0f b6 c0             	movzbl %al,%eax
}
  8023da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023dd:	5b                   	pop    %ebx
  8023de:	5e                   	pop    %esi
  8023df:	5f                   	pop    %edi
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    

008023e2 <devpipe_write>:
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	57                   	push   %edi
  8023e6:	56                   	push   %esi
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 28             	sub    $0x28,%esp
  8023eb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8023ee:	56                   	push   %esi
  8023ef:	e8 8e f2 ff ff       	call   801682 <fd2data>
  8023f4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8023fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802401:	74 4f                	je     802452 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802403:	8b 43 04             	mov    0x4(%ebx),%eax
  802406:	8b 0b                	mov    (%ebx),%ecx
  802408:	8d 51 20             	lea    0x20(%ecx),%edx
  80240b:	39 d0                	cmp    %edx,%eax
  80240d:	72 14                	jb     802423 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80240f:	89 da                	mov    %ebx,%edx
  802411:	89 f0                	mov    %esi,%eax
  802413:	e8 65 ff ff ff       	call   80237d <_pipeisclosed>
  802418:	85 c0                	test   %eax,%eax
  80241a:	75 3b                	jne    802457 <devpipe_write+0x75>
			sys_yield();
  80241c:	e8 50 e9 ff ff       	call   800d71 <sys_yield>
  802421:	eb e0                	jmp    802403 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802423:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802426:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80242a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80242d:	89 c2                	mov    %eax,%edx
  80242f:	c1 fa 1f             	sar    $0x1f,%edx
  802432:	89 d1                	mov    %edx,%ecx
  802434:	c1 e9 1b             	shr    $0x1b,%ecx
  802437:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80243a:	83 e2 1f             	and    $0x1f,%edx
  80243d:	29 ca                	sub    %ecx,%edx
  80243f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802443:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802447:	83 c0 01             	add    $0x1,%eax
  80244a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80244d:	83 c7 01             	add    $0x1,%edi
  802450:	eb ac                	jmp    8023fe <devpipe_write+0x1c>
	return i;
  802452:	8b 45 10             	mov    0x10(%ebp),%eax
  802455:	eb 05                	jmp    80245c <devpipe_write+0x7a>
				return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <devpipe_read>:
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	57                   	push   %edi
  802468:	56                   	push   %esi
  802469:	53                   	push   %ebx
  80246a:	83 ec 18             	sub    $0x18,%esp
  80246d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802470:	57                   	push   %edi
  802471:	e8 0c f2 ff ff       	call   801682 <fd2data>
  802476:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802478:	83 c4 10             	add    $0x10,%esp
  80247b:	be 00 00 00 00       	mov    $0x0,%esi
  802480:	3b 75 10             	cmp    0x10(%ebp),%esi
  802483:	75 14                	jne    802499 <devpipe_read+0x35>
	return i;
  802485:	8b 45 10             	mov    0x10(%ebp),%eax
  802488:	eb 02                	jmp    80248c <devpipe_read+0x28>
				return i;
  80248a:	89 f0                	mov    %esi,%eax
}
  80248c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    
			sys_yield();
  802494:	e8 d8 e8 ff ff       	call   800d71 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802499:	8b 03                	mov    (%ebx),%eax
  80249b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80249e:	75 18                	jne    8024b8 <devpipe_read+0x54>
			if (i > 0)
  8024a0:	85 f6                	test   %esi,%esi
  8024a2:	75 e6                	jne    80248a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024a4:	89 da                	mov    %ebx,%edx
  8024a6:	89 f8                	mov    %edi,%eax
  8024a8:	e8 d0 fe ff ff       	call   80237d <_pipeisclosed>
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 e3                	je     802494 <devpipe_read+0x30>
				return 0;
  8024b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b6:	eb d4                	jmp    80248c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024b8:	99                   	cltd   
  8024b9:	c1 ea 1b             	shr    $0x1b,%edx
  8024bc:	01 d0                	add    %edx,%eax
  8024be:	83 e0 1f             	and    $0x1f,%eax
  8024c1:	29 d0                	sub    %edx,%eax
  8024c3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024cb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024ce:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8024d1:	83 c6 01             	add    $0x1,%esi
  8024d4:	eb aa                	jmp    802480 <devpipe_read+0x1c>

008024d6 <pipe>:
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	56                   	push   %esi
  8024da:	53                   	push   %ebx
  8024db:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e1:	50                   	push   %eax
  8024e2:	e8 b2 f1 ff ff       	call   801699 <fd_alloc>
  8024e7:	89 c3                	mov    %eax,%ebx
  8024e9:	83 c4 10             	add    $0x10,%esp
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	0f 88 23 01 00 00    	js     802617 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 07 04 00 00       	push   $0x407
  8024fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ff:	6a 00                	push   $0x0
  802501:	e8 8a e8 ff ff       	call   800d90 <sys_page_alloc>
  802506:	89 c3                	mov    %eax,%ebx
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	85 c0                	test   %eax,%eax
  80250d:	0f 88 04 01 00 00    	js     802617 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802519:	50                   	push   %eax
  80251a:	e8 7a f1 ff ff       	call   801699 <fd_alloc>
  80251f:	89 c3                	mov    %eax,%ebx
  802521:	83 c4 10             	add    $0x10,%esp
  802524:	85 c0                	test   %eax,%eax
  802526:	0f 88 db 00 00 00    	js     802607 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	68 07 04 00 00       	push   $0x407
  802534:	ff 75 f0             	pushl  -0x10(%ebp)
  802537:	6a 00                	push   $0x0
  802539:	e8 52 e8 ff ff       	call   800d90 <sys_page_alloc>
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 88 bc 00 00 00    	js     802607 <pipe+0x131>
	va = fd2data(fd0);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	ff 75 f4             	pushl  -0xc(%ebp)
  802551:	e8 2c f1 ff ff       	call   801682 <fd2data>
  802556:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802558:	83 c4 0c             	add    $0xc,%esp
  80255b:	68 07 04 00 00       	push   $0x407
  802560:	50                   	push   %eax
  802561:	6a 00                	push   $0x0
  802563:	e8 28 e8 ff ff       	call   800d90 <sys_page_alloc>
  802568:	89 c3                	mov    %eax,%ebx
  80256a:	83 c4 10             	add    $0x10,%esp
  80256d:	85 c0                	test   %eax,%eax
  80256f:	0f 88 82 00 00 00    	js     8025f7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	ff 75 f0             	pushl  -0x10(%ebp)
  80257b:	e8 02 f1 ff ff       	call   801682 <fd2data>
  802580:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802587:	50                   	push   %eax
  802588:	6a 00                	push   $0x0
  80258a:	56                   	push   %esi
  80258b:	6a 00                	push   $0x0
  80258d:	e8 41 e8 ff ff       	call   800dd3 <sys_page_map>
  802592:	89 c3                	mov    %eax,%ebx
  802594:	83 c4 20             	add    $0x20,%esp
  802597:	85 c0                	test   %eax,%eax
  802599:	78 4e                	js     8025e9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80259b:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a3:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c4:	e8 a9 f0 ff ff       	call   801672 <fd2num>
  8025c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ce:	83 c4 04             	add    $0x4,%esp
  8025d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8025d4:	e8 99 f0 ff ff       	call   801672 <fd2num>
  8025d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025df:	83 c4 10             	add    $0x10,%esp
  8025e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025e7:	eb 2e                	jmp    802617 <pipe+0x141>
	sys_page_unmap(0, va);
  8025e9:	83 ec 08             	sub    $0x8,%esp
  8025ec:	56                   	push   %esi
  8025ed:	6a 00                	push   $0x0
  8025ef:	e8 21 e8 ff ff       	call   800e15 <sys_page_unmap>
  8025f4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8025f7:	83 ec 08             	sub    $0x8,%esp
  8025fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8025fd:	6a 00                	push   $0x0
  8025ff:	e8 11 e8 ff ff       	call   800e15 <sys_page_unmap>
  802604:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802607:	83 ec 08             	sub    $0x8,%esp
  80260a:	ff 75 f4             	pushl  -0xc(%ebp)
  80260d:	6a 00                	push   $0x0
  80260f:	e8 01 e8 ff ff       	call   800e15 <sys_page_unmap>
  802614:	83 c4 10             	add    $0x10,%esp
}
  802617:	89 d8                	mov    %ebx,%eax
  802619:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80261c:	5b                   	pop    %ebx
  80261d:	5e                   	pop    %esi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    

00802620 <pipeisclosed>:
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802629:	50                   	push   %eax
  80262a:	ff 75 08             	pushl  0x8(%ebp)
  80262d:	e8 b9 f0 ff ff       	call   8016eb <fd_lookup>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	85 c0                	test   %eax,%eax
  802637:	78 18                	js     802651 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802639:	83 ec 0c             	sub    $0xc,%esp
  80263c:	ff 75 f4             	pushl  -0xc(%ebp)
  80263f:	e8 3e f0 ff ff       	call   801682 <fd2data>
	return _pipeisclosed(fd, p);
  802644:	89 c2                	mov    %eax,%edx
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	e8 2f fd ff ff       	call   80237d <_pipeisclosed>
  80264e:	83 c4 10             	add    $0x10,%esp
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802653:	b8 00 00 00 00       	mov    $0x0,%eax
  802658:	c3                   	ret    

00802659 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80265f:	68 9f 31 80 00       	push   $0x80319f
  802664:	ff 75 0c             	pushl  0xc(%ebp)
  802667:	e8 32 e3 ff ff       	call   80099e <strcpy>
	return 0;
}
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <devcons_write>:
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	57                   	push   %edi
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80267f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802684:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80268a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80268d:	73 31                	jae    8026c0 <devcons_write+0x4d>
		m = n - tot;
  80268f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802692:	29 f3                	sub    %esi,%ebx
  802694:	83 fb 7f             	cmp    $0x7f,%ebx
  802697:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80269c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80269f:	83 ec 04             	sub    $0x4,%esp
  8026a2:	53                   	push   %ebx
  8026a3:	89 f0                	mov    %esi,%eax
  8026a5:	03 45 0c             	add    0xc(%ebp),%eax
  8026a8:	50                   	push   %eax
  8026a9:	57                   	push   %edi
  8026aa:	e8 7d e4 ff ff       	call   800b2c <memmove>
		sys_cputs(buf, m);
  8026af:	83 c4 08             	add    $0x8,%esp
  8026b2:	53                   	push   %ebx
  8026b3:	57                   	push   %edi
  8026b4:	e8 1b e6 ff ff       	call   800cd4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8026b9:	01 de                	add    %ebx,%esi
  8026bb:	83 c4 10             	add    $0x10,%esp
  8026be:	eb ca                	jmp    80268a <devcons_write+0x17>
}
  8026c0:	89 f0                	mov    %esi,%eax
  8026c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026c5:	5b                   	pop    %ebx
  8026c6:	5e                   	pop    %esi
  8026c7:	5f                   	pop    %edi
  8026c8:	5d                   	pop    %ebp
  8026c9:	c3                   	ret    

008026ca <devcons_read>:
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	83 ec 08             	sub    $0x8,%esp
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8026d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026d9:	74 21                	je     8026fc <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8026db:	e8 12 e6 ff ff       	call   800cf2 <sys_cgetc>
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	75 07                	jne    8026eb <devcons_read+0x21>
		sys_yield();
  8026e4:	e8 88 e6 ff ff       	call   800d71 <sys_yield>
  8026e9:	eb f0                	jmp    8026db <devcons_read+0x11>
	if (c < 0)
  8026eb:	78 0f                	js     8026fc <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8026ed:	83 f8 04             	cmp    $0x4,%eax
  8026f0:	74 0c                	je     8026fe <devcons_read+0x34>
	*(char*)vbuf = c;
  8026f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f5:	88 02                	mov    %al,(%edx)
	return 1;
  8026f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    
		return 0;
  8026fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802703:	eb f7                	jmp    8026fc <devcons_read+0x32>

00802705 <cputchar>:
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
  802708:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802711:	6a 01                	push   $0x1
  802713:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802716:	50                   	push   %eax
  802717:	e8 b8 e5 ff ff       	call   800cd4 <sys_cputs>
}
  80271c:	83 c4 10             	add    $0x10,%esp
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <getchar>:
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802727:	6a 01                	push   $0x1
  802729:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80272c:	50                   	push   %eax
  80272d:	6a 00                	push   $0x0
  80272f:	e8 27 f2 ff ff       	call   80195b <read>
	if (r < 0)
  802734:	83 c4 10             	add    $0x10,%esp
  802737:	85 c0                	test   %eax,%eax
  802739:	78 06                	js     802741 <getchar+0x20>
	if (r < 1)
  80273b:	74 06                	je     802743 <getchar+0x22>
	return c;
  80273d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802741:	c9                   	leave  
  802742:	c3                   	ret    
		return -E_EOF;
  802743:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802748:	eb f7                	jmp    802741 <getchar+0x20>

0080274a <iscons>:
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802750:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802753:	50                   	push   %eax
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	e8 8f ef ff ff       	call   8016eb <fd_lookup>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	85 c0                	test   %eax,%eax
  802761:	78 11                	js     802774 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80276c:	39 10                	cmp    %edx,(%eax)
  80276e:	0f 94 c0             	sete   %al
  802771:	0f b6 c0             	movzbl %al,%eax
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <opencons>:
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80277c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80277f:	50                   	push   %eax
  802780:	e8 14 ef ff ff       	call   801699 <fd_alloc>
  802785:	83 c4 10             	add    $0x10,%esp
  802788:	85 c0                	test   %eax,%eax
  80278a:	78 3a                	js     8027c6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	68 07 04 00 00       	push   $0x407
  802794:	ff 75 f4             	pushl  -0xc(%ebp)
  802797:	6a 00                	push   $0x0
  802799:	e8 f2 e5 ff ff       	call   800d90 <sys_page_alloc>
  80279e:	83 c4 10             	add    $0x10,%esp
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	78 21                	js     8027c6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ae:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	50                   	push   %eax
  8027be:	e8 af ee ff ff       	call   801672 <fd2num>
  8027c3:	83 c4 10             	add    $0x10,%esp
}
  8027c6:	c9                   	leave  
  8027c7:	c3                   	ret    

008027c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
  8027cb:	56                   	push   %esi
  8027cc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8027cd:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8027d2:	8b 40 48             	mov    0x48(%eax),%eax
  8027d5:	83 ec 04             	sub    $0x4,%esp
  8027d8:	68 d0 31 80 00       	push   $0x8031d0
  8027dd:	50                   	push   %eax
  8027de:	68 b8 2b 80 00       	push   $0x802bb8
  8027e3:	e8 57 da ff ff       	call   80023f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8027e8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8027eb:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8027f1:	e8 5c e5 ff ff       	call   800d52 <sys_getenvid>
  8027f6:	83 c4 04             	add    $0x4,%esp
  8027f9:	ff 75 0c             	pushl  0xc(%ebp)
  8027fc:	ff 75 08             	pushl  0x8(%ebp)
  8027ff:	56                   	push   %esi
  802800:	50                   	push   %eax
  802801:	68 ac 31 80 00       	push   $0x8031ac
  802806:	e8 34 da ff ff       	call   80023f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80280b:	83 c4 18             	add    $0x18,%esp
  80280e:	53                   	push   %ebx
  80280f:	ff 75 10             	pushl  0x10(%ebp)
  802812:	e8 d7 d9 ff ff       	call   8001ee <vcprintf>
	cprintf("\n");
  802817:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  80281e:	e8 1c da ff ff       	call   80023f <cprintf>
  802823:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802826:	cc                   	int3   
  802827:	eb fd                	jmp    802826 <_panic+0x5e>

00802829 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80282f:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802836:	74 0a                	je     802842 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802840:	c9                   	leave  
  802841:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	6a 07                	push   $0x7
  802847:	68 00 f0 bf ee       	push   $0xeebff000
  80284c:	6a 00                	push   $0x0
  80284e:	e8 3d e5 ff ff       	call   800d90 <sys_page_alloc>
		if(r < 0)
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	85 c0                	test   %eax,%eax
  802858:	78 2a                	js     802884 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80285a:	83 ec 08             	sub    $0x8,%esp
  80285d:	68 98 28 80 00       	push   $0x802898
  802862:	6a 00                	push   $0x0
  802864:	e8 72 e6 ff ff       	call   800edb <sys_env_set_pgfault_upcall>
		if(r < 0)
  802869:	83 c4 10             	add    $0x10,%esp
  80286c:	85 c0                	test   %eax,%eax
  80286e:	79 c8                	jns    802838 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	68 08 32 80 00       	push   $0x803208
  802878:	6a 25                	push   $0x25
  80287a:	68 44 32 80 00       	push   $0x803244
  80287f:	e8 44 ff ff ff       	call   8027c8 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	68 d8 31 80 00       	push   $0x8031d8
  80288c:	6a 22                	push   $0x22
  80288e:	68 44 32 80 00       	push   $0x803244
  802893:	e8 30 ff ff ff       	call   8027c8 <_panic>

00802898 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802898:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802899:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80289e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028a0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8028a3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8028a7:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8028ab:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8028ae:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8028b0:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8028b4:	83 c4 08             	add    $0x8,%esp
	popal
  8028b7:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8028b8:	83 c4 04             	add    $0x4,%esp
	popfl
  8028bb:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028bc:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028bd:	c3                   	ret    

008028be <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
  8028c1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028c4:	89 d0                	mov    %edx,%eax
  8028c6:	c1 e8 16             	shr    $0x16,%eax
  8028c9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8028d5:	f6 c1 01             	test   $0x1,%cl
  8028d8:	74 1d                	je     8028f7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8028da:	c1 ea 0c             	shr    $0xc,%edx
  8028dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028e4:	f6 c2 01             	test   $0x1,%dl
  8028e7:	74 0e                	je     8028f7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028e9:	c1 ea 0c             	shr    $0xc,%edx
  8028ec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028f3:	ef 
  8028f4:	0f b7 c0             	movzwl %ax,%eax
}
  8028f7:	5d                   	pop    %ebp
  8028f8:	c3                   	ret    
  8028f9:	66 90                	xchg   %ax,%ax
  8028fb:	66 90                	xchg   %ax,%ax
  8028fd:	66 90                	xchg   %ax,%ax
  8028ff:	90                   	nop

00802900 <__udivdi3>:
  802900:	55                   	push   %ebp
  802901:	57                   	push   %edi
  802902:	56                   	push   %esi
  802903:	53                   	push   %ebx
  802904:	83 ec 1c             	sub    $0x1c,%esp
  802907:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80290b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80290f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802917:	85 d2                	test   %edx,%edx
  802919:	75 4d                	jne    802968 <__udivdi3+0x68>
  80291b:	39 f3                	cmp    %esi,%ebx
  80291d:	76 19                	jbe    802938 <__udivdi3+0x38>
  80291f:	31 ff                	xor    %edi,%edi
  802921:	89 e8                	mov    %ebp,%eax
  802923:	89 f2                	mov    %esi,%edx
  802925:	f7 f3                	div    %ebx
  802927:	89 fa                	mov    %edi,%edx
  802929:	83 c4 1c             	add    $0x1c,%esp
  80292c:	5b                   	pop    %ebx
  80292d:	5e                   	pop    %esi
  80292e:	5f                   	pop    %edi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
  802931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802938:	89 d9                	mov    %ebx,%ecx
  80293a:	85 db                	test   %ebx,%ebx
  80293c:	75 0b                	jne    802949 <__udivdi3+0x49>
  80293e:	b8 01 00 00 00       	mov    $0x1,%eax
  802943:	31 d2                	xor    %edx,%edx
  802945:	f7 f3                	div    %ebx
  802947:	89 c1                	mov    %eax,%ecx
  802949:	31 d2                	xor    %edx,%edx
  80294b:	89 f0                	mov    %esi,%eax
  80294d:	f7 f1                	div    %ecx
  80294f:	89 c6                	mov    %eax,%esi
  802951:	89 e8                	mov    %ebp,%eax
  802953:	89 f7                	mov    %esi,%edi
  802955:	f7 f1                	div    %ecx
  802957:	89 fa                	mov    %edi,%edx
  802959:	83 c4 1c             	add    $0x1c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	39 f2                	cmp    %esi,%edx
  80296a:	77 1c                	ja     802988 <__udivdi3+0x88>
  80296c:	0f bd fa             	bsr    %edx,%edi
  80296f:	83 f7 1f             	xor    $0x1f,%edi
  802972:	75 2c                	jne    8029a0 <__udivdi3+0xa0>
  802974:	39 f2                	cmp    %esi,%edx
  802976:	72 06                	jb     80297e <__udivdi3+0x7e>
  802978:	31 c0                	xor    %eax,%eax
  80297a:	39 eb                	cmp    %ebp,%ebx
  80297c:	77 a9                	ja     802927 <__udivdi3+0x27>
  80297e:	b8 01 00 00 00       	mov    $0x1,%eax
  802983:	eb a2                	jmp    802927 <__udivdi3+0x27>
  802985:	8d 76 00             	lea    0x0(%esi),%esi
  802988:	31 ff                	xor    %edi,%edi
  80298a:	31 c0                	xor    %eax,%eax
  80298c:	89 fa                	mov    %edi,%edx
  80298e:	83 c4 1c             	add    $0x1c,%esp
  802991:	5b                   	pop    %ebx
  802992:	5e                   	pop    %esi
  802993:	5f                   	pop    %edi
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    
  802996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80299d:	8d 76 00             	lea    0x0(%esi),%esi
  8029a0:	89 f9                	mov    %edi,%ecx
  8029a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a7:	29 f8                	sub    %edi,%eax
  8029a9:	d3 e2                	shl    %cl,%edx
  8029ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029af:	89 c1                	mov    %eax,%ecx
  8029b1:	89 da                	mov    %ebx,%edx
  8029b3:	d3 ea                	shr    %cl,%edx
  8029b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029b9:	09 d1                	or     %edx,%ecx
  8029bb:	89 f2                	mov    %esi,%edx
  8029bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029c1:	89 f9                	mov    %edi,%ecx
  8029c3:	d3 e3                	shl    %cl,%ebx
  8029c5:	89 c1                	mov    %eax,%ecx
  8029c7:	d3 ea                	shr    %cl,%edx
  8029c9:	89 f9                	mov    %edi,%ecx
  8029cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8029cf:	89 eb                	mov    %ebp,%ebx
  8029d1:	d3 e6                	shl    %cl,%esi
  8029d3:	89 c1                	mov    %eax,%ecx
  8029d5:	d3 eb                	shr    %cl,%ebx
  8029d7:	09 de                	or     %ebx,%esi
  8029d9:	89 f0                	mov    %esi,%eax
  8029db:	f7 74 24 08          	divl   0x8(%esp)
  8029df:	89 d6                	mov    %edx,%esi
  8029e1:	89 c3                	mov    %eax,%ebx
  8029e3:	f7 64 24 0c          	mull   0xc(%esp)
  8029e7:	39 d6                	cmp    %edx,%esi
  8029e9:	72 15                	jb     802a00 <__udivdi3+0x100>
  8029eb:	89 f9                	mov    %edi,%ecx
  8029ed:	d3 e5                	shl    %cl,%ebp
  8029ef:	39 c5                	cmp    %eax,%ebp
  8029f1:	73 04                	jae    8029f7 <__udivdi3+0xf7>
  8029f3:	39 d6                	cmp    %edx,%esi
  8029f5:	74 09                	je     802a00 <__udivdi3+0x100>
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	31 ff                	xor    %edi,%edi
  8029fb:	e9 27 ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a03:	31 ff                	xor    %edi,%edi
  802a05:	e9 1d ff ff ff       	jmp    802927 <__udivdi3+0x27>
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	53                   	push   %ebx
  802a14:	83 ec 1c             	sub    $0x1c,%esp
  802a17:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a1f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a27:	89 da                	mov    %ebx,%edx
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 43                	jne    802a70 <__umoddi3+0x60>
  802a2d:	39 df                	cmp    %ebx,%edi
  802a2f:	76 17                	jbe    802a48 <__umoddi3+0x38>
  802a31:	89 f0                	mov    %esi,%eax
  802a33:	f7 f7                	div    %edi
  802a35:	89 d0                	mov    %edx,%eax
  802a37:	31 d2                	xor    %edx,%edx
  802a39:	83 c4 1c             	add    $0x1c,%esp
  802a3c:	5b                   	pop    %ebx
  802a3d:	5e                   	pop    %esi
  802a3e:	5f                   	pop    %edi
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a48:	89 fd                	mov    %edi,%ebp
  802a4a:	85 ff                	test   %edi,%edi
  802a4c:	75 0b                	jne    802a59 <__umoddi3+0x49>
  802a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a53:	31 d2                	xor    %edx,%edx
  802a55:	f7 f7                	div    %edi
  802a57:	89 c5                	mov    %eax,%ebp
  802a59:	89 d8                	mov    %ebx,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	f7 f5                	div    %ebp
  802a5f:	89 f0                	mov    %esi,%eax
  802a61:	f7 f5                	div    %ebp
  802a63:	89 d0                	mov    %edx,%eax
  802a65:	eb d0                	jmp    802a37 <__umoddi3+0x27>
  802a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a6e:	66 90                	xchg   %ax,%ax
  802a70:	89 f1                	mov    %esi,%ecx
  802a72:	39 d8                	cmp    %ebx,%eax
  802a74:	76 0a                	jbe    802a80 <__umoddi3+0x70>
  802a76:	89 f0                	mov    %esi,%eax
  802a78:	83 c4 1c             	add    $0x1c,%esp
  802a7b:	5b                   	pop    %ebx
  802a7c:	5e                   	pop    %esi
  802a7d:	5f                   	pop    %edi
  802a7e:	5d                   	pop    %ebp
  802a7f:	c3                   	ret    
  802a80:	0f bd e8             	bsr    %eax,%ebp
  802a83:	83 f5 1f             	xor    $0x1f,%ebp
  802a86:	75 20                	jne    802aa8 <__umoddi3+0x98>
  802a88:	39 d8                	cmp    %ebx,%eax
  802a8a:	0f 82 b0 00 00 00    	jb     802b40 <__umoddi3+0x130>
  802a90:	39 f7                	cmp    %esi,%edi
  802a92:	0f 86 a8 00 00 00    	jbe    802b40 <__umoddi3+0x130>
  802a98:	89 c8                	mov    %ecx,%eax
  802a9a:	83 c4 1c             	add    $0x1c,%esp
  802a9d:	5b                   	pop    %ebx
  802a9e:	5e                   	pop    %esi
  802a9f:	5f                   	pop    %edi
  802aa0:	5d                   	pop    %ebp
  802aa1:	c3                   	ret    
  802aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802aa8:	89 e9                	mov    %ebp,%ecx
  802aaa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aaf:	29 ea                	sub    %ebp,%edx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ab7:	89 d1                	mov    %edx,%ecx
  802ab9:	89 f8                	mov    %edi,%eax
  802abb:	d3 e8                	shr    %cl,%eax
  802abd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ac1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ac5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ac9:	09 c1                	or     %eax,%ecx
  802acb:	89 d8                	mov    %ebx,%eax
  802acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad1:	89 e9                	mov    %ebp,%ecx
  802ad3:	d3 e7                	shl    %cl,%edi
  802ad5:	89 d1                	mov    %edx,%ecx
  802ad7:	d3 e8                	shr    %cl,%eax
  802ad9:	89 e9                	mov    %ebp,%ecx
  802adb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802adf:	d3 e3                	shl    %cl,%ebx
  802ae1:	89 c7                	mov    %eax,%edi
  802ae3:	89 d1                	mov    %edx,%ecx
  802ae5:	89 f0                	mov    %esi,%eax
  802ae7:	d3 e8                	shr    %cl,%eax
  802ae9:	89 e9                	mov    %ebp,%ecx
  802aeb:	89 fa                	mov    %edi,%edx
  802aed:	d3 e6                	shl    %cl,%esi
  802aef:	09 d8                	or     %ebx,%eax
  802af1:	f7 74 24 08          	divl   0x8(%esp)
  802af5:	89 d1                	mov    %edx,%ecx
  802af7:	89 f3                	mov    %esi,%ebx
  802af9:	f7 64 24 0c          	mull   0xc(%esp)
  802afd:	89 c6                	mov    %eax,%esi
  802aff:	89 d7                	mov    %edx,%edi
  802b01:	39 d1                	cmp    %edx,%ecx
  802b03:	72 06                	jb     802b0b <__umoddi3+0xfb>
  802b05:	75 10                	jne    802b17 <__umoddi3+0x107>
  802b07:	39 c3                	cmp    %eax,%ebx
  802b09:	73 0c                	jae    802b17 <__umoddi3+0x107>
  802b0b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b0f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b13:	89 d7                	mov    %edx,%edi
  802b15:	89 c6                	mov    %eax,%esi
  802b17:	89 ca                	mov    %ecx,%edx
  802b19:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b1e:	29 f3                	sub    %esi,%ebx
  802b20:	19 fa                	sbb    %edi,%edx
  802b22:	89 d0                	mov    %edx,%eax
  802b24:	d3 e0                	shl    %cl,%eax
  802b26:	89 e9                	mov    %ebp,%ecx
  802b28:	d3 eb                	shr    %cl,%ebx
  802b2a:	d3 ea                	shr    %cl,%edx
  802b2c:	09 d8                	or     %ebx,%eax
  802b2e:	83 c4 1c             	add    $0x1c,%esp
  802b31:	5b                   	pop    %ebx
  802b32:	5e                   	pop    %esi
  802b33:	5f                   	pop    %edi
  802b34:	5d                   	pop    %ebp
  802b35:	c3                   	ret    
  802b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b3d:	8d 76 00             	lea    0x0(%esi),%esi
  802b40:	89 da                	mov    %ebx,%edx
  802b42:	29 fe                	sub    %edi,%esi
  802b44:	19 c2                	sbb    %eax,%edx
  802b46:	89 f1                	mov    %esi,%ecx
  802b48:	89 c8                	mov    %ecx,%eax
  802b4a:	e9 4b ff ff ff       	jmp    802a9a <__umoddi3+0x8a>
