
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 11 0d 00 00       	call   800d58 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 4d 0e 00 00       	call   800ea3 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	57                   	push   %edi
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80006e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800075:	00 00 00 
	envid_t find = sys_getenvid();
  800078:	e8 9d 0c 00 00       	call   800d1a <sys_getenvid>
  80007d:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800083:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800088:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80008d:	bf 01 00 00 00       	mov    $0x1,%edi
  800092:	eb 0b                	jmp    80009f <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800094:	83 c2 01             	add    $0x1,%edx
  800097:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80009d:	74 21                	je     8000c0 <libmain+0x5b>
		if(envs[i].env_id == find)
  80009f:	89 d1                	mov    %edx,%ecx
  8000a1:	c1 e1 07             	shl    $0x7,%ecx
  8000a4:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000aa:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000ad:	39 c1                	cmp    %eax,%ecx
  8000af:	75 e3                	jne    800094 <libmain+0x2f>
  8000b1:	89 d3                	mov    %edx,%ebx
  8000b3:	c1 e3 07             	shl    $0x7,%ebx
  8000b6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000bc:	89 fe                	mov    %edi,%esi
  8000be:	eb d4                	jmp    800094 <libmain+0x2f>
  8000c0:	89 f0                	mov    %esi,%eax
  8000c2:	84 c0                	test   %al,%al
  8000c4:	74 06                	je     8000cc <libmain+0x67>
  8000c6:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d0:	7e 0a                	jle    8000dc <libmain+0x77>
		binaryname = argv[0];
  8000d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d5:	8b 00                	mov    (%eax),%eax
  8000d7:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8000e1:	8b 40 48             	mov    0x48(%eax),%eax
  8000e4:	83 ec 08             	sub    $0x8,%esp
  8000e7:	50                   	push   %eax
  8000e8:	68 a0 25 80 00       	push   $0x8025a0
  8000ed:	e8 15 01 00 00       	call   800207 <cprintf>
	cprintf("before umain\n");
  8000f2:	c7 04 24 be 25 80 00 	movl   $0x8025be,(%esp)
  8000f9:	e8 09 01 00 00       	call   800207 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000fe:	83 c4 08             	add    $0x8,%esp
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	ff 75 08             	pushl  0x8(%ebp)
  800107:	e8 27 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80010c:	c7 04 24 cc 25 80 00 	movl   $0x8025cc,(%esp)
  800113:	e8 ef 00 00 00       	call   800207 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800118:	a1 08 40 80 00       	mov    0x804008,%eax
  80011d:	8b 40 48             	mov    0x48(%eax),%eax
  800120:	83 c4 08             	add    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 d9 25 80 00       	push   $0x8025d9
  800129:	e8 d9 00 00 00       	call   800207 <cprintf>
	// exit gracefully
	exit();
  80012e:	e8 0b 00 00 00       	call   80013e <exit>
}
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800139:	5b                   	pop    %ebx
  80013a:	5e                   	pop    %esi
  80013b:	5f                   	pop    %edi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800144:	a1 08 40 80 00       	mov    0x804008,%eax
  800149:	8b 40 48             	mov    0x48(%eax),%eax
  80014c:	68 04 26 80 00       	push   $0x802604
  800151:	50                   	push   %eax
  800152:	68 f8 25 80 00       	push   $0x8025f8
  800157:	e8 ab 00 00 00       	call   800207 <cprintf>
	close_all();
  80015c:	e8 c4 10 00 00       	call   801225 <close_all>
	sys_env_destroy(0);
  800161:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800168:	e8 6c 0b 00 00       	call   800cd9 <sys_env_destroy>
}
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	53                   	push   %ebx
  800176:	83 ec 04             	sub    $0x4,%esp
  800179:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017c:	8b 13                	mov    (%ebx),%edx
  80017e:	8d 42 01             	lea    0x1(%edx),%eax
  800181:	89 03                	mov    %eax,(%ebx)
  800183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800186:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018f:	74 09                	je     80019a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800191:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800198:	c9                   	leave  
  800199:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	68 ff 00 00 00       	push   $0xff
  8001a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a5:	50                   	push   %eax
  8001a6:	e8 f1 0a 00 00       	call   800c9c <sys_cputs>
		b->idx = 0;
  8001ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b1:	83 c4 10             	add    $0x10,%esp
  8001b4:	eb db                	jmp    800191 <putch+0x1f>

008001b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c6:	00 00 00 
	b.cnt = 0;
  8001c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d3:	ff 75 0c             	pushl  0xc(%ebp)
  8001d6:	ff 75 08             	pushl  0x8(%ebp)
  8001d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001df:	50                   	push   %eax
  8001e0:	68 72 01 80 00       	push   $0x800172
  8001e5:	e8 4a 01 00 00       	call   800334 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ea:	83 c4 08             	add    $0x8,%esp
  8001ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 9d 0a 00 00       	call   800c9c <sys_cputs>

	return b.cnt;
}
  8001ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800210:	50                   	push   %eax
  800211:	ff 75 08             	pushl  0x8(%ebp)
  800214:	e8 9d ff ff ff       	call   8001b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800219:	c9                   	leave  
  80021a:	c3                   	ret    

0080021b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	57                   	push   %edi
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 1c             	sub    $0x1c,%esp
  800224:	89 c6                	mov    %eax,%esi
  800226:	89 d7                	mov    %edx,%edi
  800228:	8b 45 08             	mov    0x8(%ebp),%eax
  80022b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800231:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800234:	8b 45 10             	mov    0x10(%ebp),%eax
  800237:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80023a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80023e:	74 2c                	je     80026c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800240:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800243:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80024a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80024d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800250:	39 c2                	cmp    %eax,%edx
  800252:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800255:	73 43                	jae    80029a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800257:	83 eb 01             	sub    $0x1,%ebx
  80025a:	85 db                	test   %ebx,%ebx
  80025c:	7e 6c                	jle    8002ca <printnum+0xaf>
				putch(padc, putdat);
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	57                   	push   %edi
  800262:	ff 75 18             	pushl  0x18(%ebp)
  800265:	ff d6                	call   *%esi
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	eb eb                	jmp    800257 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	6a 20                	push   $0x20
  800271:	6a 00                	push   $0x0
  800273:	50                   	push   %eax
  800274:	ff 75 e4             	pushl  -0x1c(%ebp)
  800277:	ff 75 e0             	pushl  -0x20(%ebp)
  80027a:	89 fa                	mov    %edi,%edx
  80027c:	89 f0                	mov    %esi,%eax
  80027e:	e8 98 ff ff ff       	call   80021b <printnum>
		while (--width > 0)
  800283:	83 c4 20             	add    $0x20,%esp
  800286:	83 eb 01             	sub    $0x1,%ebx
  800289:	85 db                	test   %ebx,%ebx
  80028b:	7e 65                	jle    8002f2 <printnum+0xd7>
			putch(padc, putdat);
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	57                   	push   %edi
  800291:	6a 20                	push   $0x20
  800293:	ff d6                	call   *%esi
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	eb ec                	jmp    800286 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 18             	pushl  0x18(%ebp)
  8002a0:	83 eb 01             	sub    $0x1,%ebx
  8002a3:	53                   	push   %ebx
  8002a4:	50                   	push   %eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b4:	e8 87 20 00 00       	call   802340 <__udivdi3>
  8002b9:	83 c4 18             	add    $0x18,%esp
  8002bc:	52                   	push   %edx
  8002bd:	50                   	push   %eax
  8002be:	89 fa                	mov    %edi,%edx
  8002c0:	89 f0                	mov    %esi,%eax
  8002c2:	e8 54 ff ff ff       	call   80021b <printnum>
  8002c7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	57                   	push   %edi
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002da:	ff 75 e0             	pushl  -0x20(%ebp)
  8002dd:	e8 6e 21 00 00       	call   802450 <__umoddi3>
  8002e2:	83 c4 14             	add    $0x14,%esp
  8002e5:	0f be 80 09 26 80 00 	movsbl 0x802609(%eax),%eax
  8002ec:	50                   	push   %eax
  8002ed:	ff d6                	call   *%esi
  8002ef:	83 c4 10             	add    $0x10,%esp
	}
}
  8002f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f5:	5b                   	pop    %ebx
  8002f6:	5e                   	pop    %esi
  8002f7:	5f                   	pop    %edi
  8002f8:	5d                   	pop    %ebp
  8002f9:	c3                   	ret    

008002fa <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800300:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800304:	8b 10                	mov    (%eax),%edx
  800306:	3b 50 04             	cmp    0x4(%eax),%edx
  800309:	73 0a                	jae    800315 <sprintputch+0x1b>
		*b->buf++ = ch;
  80030b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030e:	89 08                	mov    %ecx,(%eax)
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	88 02                	mov    %al,(%edx)
}
  800315:	5d                   	pop    %ebp
  800316:	c3                   	ret    

00800317 <printfmt>:
{
  800317:	55                   	push   %ebp
  800318:	89 e5                	mov    %esp,%ebp
  80031a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800320:	50                   	push   %eax
  800321:	ff 75 10             	pushl  0x10(%ebp)
  800324:	ff 75 0c             	pushl  0xc(%ebp)
  800327:	ff 75 08             	pushl  0x8(%ebp)
  80032a:	e8 05 00 00 00       	call   800334 <vprintfmt>
}
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	c9                   	leave  
  800333:	c3                   	ret    

00800334 <vprintfmt>:
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	57                   	push   %edi
  800338:	56                   	push   %esi
  800339:	53                   	push   %ebx
  80033a:	83 ec 3c             	sub    $0x3c,%esp
  80033d:	8b 75 08             	mov    0x8(%ebp),%esi
  800340:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800343:	8b 7d 10             	mov    0x10(%ebp),%edi
  800346:	e9 32 04 00 00       	jmp    80077d <vprintfmt+0x449>
		padc = ' ';
  80034b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80034f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800356:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80035d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800364:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800372:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800377:	8d 47 01             	lea    0x1(%edi),%eax
  80037a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037d:	0f b6 17             	movzbl (%edi),%edx
  800380:	8d 42 dd             	lea    -0x23(%edx),%eax
  800383:	3c 55                	cmp    $0x55,%al
  800385:	0f 87 12 05 00 00    	ja     80089d <vprintfmt+0x569>
  80038b:	0f b6 c0             	movzbl %al,%eax
  80038e:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800398:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80039c:	eb d9                	jmp    800377 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a5:	eb d0                	jmp    800377 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a7:	0f b6 d2             	movzbl %dl,%edx
  8003aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b2:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b5:	eb 03                	jmp    8003ba <vprintfmt+0x86>
  8003b7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ba:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003bd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c7:	83 fe 09             	cmp    $0x9,%esi
  8003ca:	76 eb                	jbe    8003b7 <vprintfmt+0x83>
  8003cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d2:	eb 14                	jmp    8003e8 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 40 04             	lea    0x4(%eax),%eax
  8003e2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ec:	79 89                	jns    800377 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fb:	e9 77 ff ff ff       	jmp    800377 <vprintfmt+0x43>
  800400:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	0f 48 c1             	cmovs  %ecx,%eax
  800408:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80040e:	e9 64 ff ff ff       	jmp    800377 <vprintfmt+0x43>
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800416:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80041d:	e9 55 ff ff ff       	jmp    800377 <vprintfmt+0x43>
			lflag++;
  800422:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800429:	e9 49 ff ff ff       	jmp    800377 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8d 78 04             	lea    0x4(%eax),%edi
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	53                   	push   %ebx
  800438:	ff 30                	pushl  (%eax)
  80043a:	ff d6                	call   *%esi
			break;
  80043c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800442:	e9 33 03 00 00       	jmp    80077a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 78 04             	lea    0x4(%eax),%edi
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	99                   	cltd   
  800450:	31 d0                	xor    %edx,%eax
  800452:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800454:	83 f8 11             	cmp    $0x11,%eax
  800457:	7f 23                	jg     80047c <vprintfmt+0x148>
  800459:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  800460:	85 d2                	test   %edx,%edx
  800462:	74 18                	je     80047c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800464:	52                   	push   %edx
  800465:	68 5d 2a 80 00       	push   $0x802a5d
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 a6 fe ff ff       	call   800317 <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
  800477:	e9 fe 02 00 00       	jmp    80077a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80047c:	50                   	push   %eax
  80047d:	68 21 26 80 00       	push   $0x802621
  800482:	53                   	push   %ebx
  800483:	56                   	push   %esi
  800484:	e8 8e fe ff ff       	call   800317 <printfmt>
  800489:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048f:	e9 e6 02 00 00       	jmp    80077a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	83 c0 04             	add    $0x4,%eax
  80049a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004a2:	85 c9                	test   %ecx,%ecx
  8004a4:	b8 1a 26 80 00       	mov    $0x80261a,%eax
  8004a9:	0f 45 c1             	cmovne %ecx,%eax
  8004ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b3:	7e 06                	jle    8004bb <vprintfmt+0x187>
  8004b5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004b9:	75 0d                	jne    8004c8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004be:	89 c7                	mov    %eax,%edi
  8004c0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c6:	eb 53                	jmp    80051b <vprintfmt+0x1e7>
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ce:	50                   	push   %eax
  8004cf:	e8 71 04 00 00       	call   800945 <strnlen>
  8004d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d7:	29 c1                	sub    %eax,%ecx
  8004d9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e1:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e8:	eb 0f                	jmp    8004f9 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	83 ef 01             	sub    $0x1,%edi
  8004f6:	83 c4 10             	add    $0x10,%esp
  8004f9:	85 ff                	test   %edi,%edi
  8004fb:	7f ed                	jg     8004ea <vprintfmt+0x1b6>
  8004fd:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800500:	85 c9                	test   %ecx,%ecx
  800502:	b8 00 00 00 00       	mov    $0x0,%eax
  800507:	0f 49 c1             	cmovns %ecx,%eax
  80050a:	29 c1                	sub    %eax,%ecx
  80050c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80050f:	eb aa                	jmp    8004bb <vprintfmt+0x187>
					putch(ch, putdat);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	53                   	push   %ebx
  800515:	52                   	push   %edx
  800516:	ff d6                	call   *%esi
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800520:	83 c7 01             	add    $0x1,%edi
  800523:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800527:	0f be d0             	movsbl %al,%edx
  80052a:	85 d2                	test   %edx,%edx
  80052c:	74 4b                	je     800579 <vprintfmt+0x245>
  80052e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800532:	78 06                	js     80053a <vprintfmt+0x206>
  800534:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800538:	78 1e                	js     800558 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80053a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80053e:	74 d1                	je     800511 <vprintfmt+0x1dd>
  800540:	0f be c0             	movsbl %al,%eax
  800543:	83 e8 20             	sub    $0x20,%eax
  800546:	83 f8 5e             	cmp    $0x5e,%eax
  800549:	76 c6                	jbe    800511 <vprintfmt+0x1dd>
					putch('?', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	6a 3f                	push   $0x3f
  800551:	ff d6                	call   *%esi
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	eb c3                	jmp    80051b <vprintfmt+0x1e7>
  800558:	89 cf                	mov    %ecx,%edi
  80055a:	eb 0e                	jmp    80056a <vprintfmt+0x236>
				putch(' ', putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	6a 20                	push   $0x20
  800562:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800564:	83 ef 01             	sub    $0x1,%edi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	85 ff                	test   %edi,%edi
  80056c:	7f ee                	jg     80055c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
  800574:	e9 01 02 00 00       	jmp    80077a <vprintfmt+0x446>
  800579:	89 cf                	mov    %ecx,%edi
  80057b:	eb ed                	jmp    80056a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80057d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800580:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800587:	e9 eb fd ff ff       	jmp    800377 <vprintfmt+0x43>
	if (lflag >= 2)
  80058c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800590:	7f 21                	jg     8005b3 <vprintfmt+0x27f>
	else if (lflag)
  800592:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800596:	74 68                	je     800600 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	89 c1                	mov    %eax,%ecx
  8005a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b1:	eb 17                	jmp    8005ca <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 50 04             	mov    0x4(%eax),%edx
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005be:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 08             	lea    0x8(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005da:	78 3f                	js     80061b <vprintfmt+0x2e7>
			base = 10;
  8005dc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005e1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e5:	0f 84 71 01 00 00    	je     80075c <vprintfmt+0x428>
				putch('+', putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 2b                	push   $0x2b
  8005f1:	ff d6                	call   *%esi
  8005f3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fb:	e9 5c 01 00 00       	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800608:	89 c1                	mov    %eax,%ecx
  80060a:	c1 f9 1f             	sar    $0x1f,%ecx
  80060d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8d 40 04             	lea    0x4(%eax),%eax
  800616:	89 45 14             	mov    %eax,0x14(%ebp)
  800619:	eb af                	jmp    8005ca <vprintfmt+0x296>
				putch('-', putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	6a 2d                	push   $0x2d
  800621:	ff d6                	call   *%esi
				num = -(long long) num;
  800623:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800626:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800629:	f7 d8                	neg    %eax
  80062b:	83 d2 00             	adc    $0x0,%edx
  80062e:	f7 da                	neg    %edx
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800633:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800636:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800639:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063e:	e9 19 01 00 00       	jmp    80075c <vprintfmt+0x428>
	if (lflag >= 2)
  800643:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800647:	7f 29                	jg     800672 <vprintfmt+0x33e>
	else if (lflag)
  800649:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064d:	74 44                	je     800693 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066d:	e9 ea 00 00 00       	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 50 04             	mov    0x4(%eax),%edx
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800689:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068e:	e9 c9 00 00 00       	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b1:	e9 a6 00 00 00       	jmp    80075c <vprintfmt+0x428>
			putch('0', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 30                	push   $0x30
  8006bc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c5:	7f 26                	jg     8006ed <vprintfmt+0x3b9>
	else if (lflag)
  8006c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cb:	74 3e                	je     80070b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006eb:	eb 6f                	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 50 04             	mov    0x4(%eax),%edx
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800704:	b8 08 00 00 00       	mov    $0x8,%eax
  800709:	eb 51                	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800724:	b8 08 00 00 00       	mov    $0x8,%eax
  800729:	eb 31                	jmp    80075c <vprintfmt+0x428>
			putch('0', putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 30                	push   $0x30
  800731:	ff d6                	call   *%esi
			putch('x', putdat);
  800733:	83 c4 08             	add    $0x8,%esp
  800736:	53                   	push   %ebx
  800737:	6a 78                	push   $0x78
  800739:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80074b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800757:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80075c:	83 ec 0c             	sub    $0xc,%esp
  80075f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800763:	52                   	push   %edx
  800764:	ff 75 e0             	pushl  -0x20(%ebp)
  800767:	50                   	push   %eax
  800768:	ff 75 dc             	pushl  -0x24(%ebp)
  80076b:	ff 75 d8             	pushl  -0x28(%ebp)
  80076e:	89 da                	mov    %ebx,%edx
  800770:	89 f0                	mov    %esi,%eax
  800772:	e8 a4 fa ff ff       	call   80021b <printnum>
			break;
  800777:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80077a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	83 c7 01             	add    $0x1,%edi
  800780:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800784:	83 f8 25             	cmp    $0x25,%eax
  800787:	0f 84 be fb ff ff    	je     80034b <vprintfmt+0x17>
			if (ch == '\0')
  80078d:	85 c0                	test   %eax,%eax
  80078f:	0f 84 28 01 00 00    	je     8008bd <vprintfmt+0x589>
			putch(ch, putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	53                   	push   %ebx
  800799:	50                   	push   %eax
  80079a:	ff d6                	call   *%esi
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	eb dc                	jmp    80077d <vprintfmt+0x449>
	if (lflag >= 2)
  8007a1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a5:	7f 26                	jg     8007cd <vprintfmt+0x499>
	else if (lflag)
  8007a7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ab:	74 41                	je     8007ee <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cb:	eb 8f                	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 50 04             	mov    0x4(%eax),%edx
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8d 40 08             	lea    0x8(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e9:	e9 6e ff ff ff       	jmp    80075c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800807:	b8 10 00 00 00       	mov    $0x10,%eax
  80080c:	e9 4b ff ff ff       	jmp    80075c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	85 c0                	test   %eax,%eax
  800821:	74 14                	je     800837 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800823:	8b 13                	mov    (%ebx),%edx
  800825:	83 fa 7f             	cmp    $0x7f,%edx
  800828:	7f 37                	jg     800861 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80082a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80082c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	e9 43 ff ff ff       	jmp    80077a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800837:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083c:	bf 3d 27 80 00       	mov    $0x80273d,%edi
							putch(ch, putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	50                   	push   %eax
  800846:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800848:	83 c7 01             	add    $0x1,%edi
  80084b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80084f:	83 c4 10             	add    $0x10,%esp
  800852:	85 c0                	test   %eax,%eax
  800854:	75 eb                	jne    800841 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800856:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
  80085c:	e9 19 ff ff ff       	jmp    80077a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800861:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800863:	b8 0a 00 00 00       	mov    $0xa,%eax
  800868:	bf 75 27 80 00       	mov    $0x802775,%edi
							putch(ch, putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	50                   	push   %eax
  800872:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800874:	83 c7 01             	add    $0x1,%edi
  800877:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	85 c0                	test   %eax,%eax
  800880:	75 eb                	jne    80086d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800882:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
  800888:	e9 ed fe ff ff       	jmp    80077a <vprintfmt+0x446>
			putch(ch, putdat);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	53                   	push   %ebx
  800891:	6a 25                	push   $0x25
  800893:	ff d6                	call   *%esi
			break;
  800895:	83 c4 10             	add    $0x10,%esp
  800898:	e9 dd fe ff ff       	jmp    80077a <vprintfmt+0x446>
			putch('%', putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	6a 25                	push   $0x25
  8008a3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	89 f8                	mov    %edi,%eax
  8008aa:	eb 03                	jmp    8008af <vprintfmt+0x57b>
  8008ac:	83 e8 01             	sub    $0x1,%eax
  8008af:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b3:	75 f7                	jne    8008ac <vprintfmt+0x578>
  8008b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b8:	e9 bd fe ff ff       	jmp    80077a <vprintfmt+0x446>
}
  8008bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008c0:	5b                   	pop    %ebx
  8008c1:	5e                   	pop    %esi
  8008c2:	5f                   	pop    %edi
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 18             	sub    $0x18,%esp
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008d8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e2:	85 c0                	test   %eax,%eax
  8008e4:	74 26                	je     80090c <vsnprintf+0x47>
  8008e6:	85 d2                	test   %edx,%edx
  8008e8:	7e 22                	jle    80090c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ea:	ff 75 14             	pushl  0x14(%ebp)
  8008ed:	ff 75 10             	pushl  0x10(%ebp)
  8008f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f3:	50                   	push   %eax
  8008f4:	68 fa 02 80 00       	push   $0x8002fa
  8008f9:	e8 36 fa ff ff       	call   800334 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800901:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800907:	83 c4 10             	add    $0x10,%esp
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    
		return -E_INVAL;
  80090c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800911:	eb f7                	jmp    80090a <vsnprintf+0x45>

00800913 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800919:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80091c:	50                   	push   %eax
  80091d:	ff 75 10             	pushl  0x10(%ebp)
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	ff 75 08             	pushl  0x8(%ebp)
  800926:	e8 9a ff ff ff       	call   8008c5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80092b:	c9                   	leave  
  80092c:	c3                   	ret    

0080092d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80093c:	74 05                	je     800943 <strlen+0x16>
		n++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	eb f5                	jmp    800938 <strlen+0xb>
	return n;
}
  800943:	5d                   	pop    %ebp
  800944:	c3                   	ret    

00800945 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094e:	ba 00 00 00 00       	mov    $0x0,%edx
  800953:	39 c2                	cmp    %eax,%edx
  800955:	74 0d                	je     800964 <strnlen+0x1f>
  800957:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80095b:	74 05                	je     800962 <strnlen+0x1d>
		n++;
  80095d:	83 c2 01             	add    $0x1,%edx
  800960:	eb f1                	jmp    800953 <strnlen+0xe>
  800962:	89 d0                	mov    %edx,%eax
	return n;
}
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800970:	ba 00 00 00 00       	mov    $0x0,%edx
  800975:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800979:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	84 c9                	test   %cl,%cl
  800981:	75 f2                	jne    800975 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800983:	5b                   	pop    %ebx
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	53                   	push   %ebx
  80098a:	83 ec 10             	sub    $0x10,%esp
  80098d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800990:	53                   	push   %ebx
  800991:	e8 97 ff ff ff       	call   80092d <strlen>
  800996:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	01 d8                	add    %ebx,%eax
  80099e:	50                   	push   %eax
  80099f:	e8 c2 ff ff ff       	call   800966 <strcpy>
	return dst;
}
  8009a4:	89 d8                	mov    %ebx,%eax
  8009a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b6:	89 c6                	mov    %eax,%esi
  8009b8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bb:	89 c2                	mov    %eax,%edx
  8009bd:	39 f2                	cmp    %esi,%edx
  8009bf:	74 11                	je     8009d2 <strncpy+0x27>
		*dst++ = *src;
  8009c1:	83 c2 01             	add    $0x1,%edx
  8009c4:	0f b6 19             	movzbl (%ecx),%ebx
  8009c7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ca:	80 fb 01             	cmp    $0x1,%bl
  8009cd:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009d0:	eb eb                	jmp    8009bd <strncpy+0x12>
	}
	return ret;
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	56                   	push   %esi
  8009da:	53                   	push   %ebx
  8009db:	8b 75 08             	mov    0x8(%ebp),%esi
  8009de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e1:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e6:	85 d2                	test   %edx,%edx
  8009e8:	74 21                	je     800a0b <strlcpy+0x35>
  8009ea:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009ee:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009f0:	39 c2                	cmp    %eax,%edx
  8009f2:	74 14                	je     800a08 <strlcpy+0x32>
  8009f4:	0f b6 19             	movzbl (%ecx),%ebx
  8009f7:	84 db                	test   %bl,%bl
  8009f9:	74 0b                	je     800a06 <strlcpy+0x30>
			*dst++ = *src++;
  8009fb:	83 c1 01             	add    $0x1,%ecx
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a04:	eb ea                	jmp    8009f0 <strlcpy+0x1a>
  800a06:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a08:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0b:	29 f0                	sub    %esi,%eax
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1a:	0f b6 01             	movzbl (%ecx),%eax
  800a1d:	84 c0                	test   %al,%al
  800a1f:	74 0c                	je     800a2d <strcmp+0x1c>
  800a21:	3a 02                	cmp    (%edx),%al
  800a23:	75 08                	jne    800a2d <strcmp+0x1c>
		p++, q++;
  800a25:	83 c1 01             	add    $0x1,%ecx
  800a28:	83 c2 01             	add    $0x1,%edx
  800a2b:	eb ed                	jmp    800a1a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2d:	0f b6 c0             	movzbl %al,%eax
  800a30:	0f b6 12             	movzbl (%edx),%edx
  800a33:	29 d0                	sub    %edx,%eax
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a41:	89 c3                	mov    %eax,%ebx
  800a43:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a46:	eb 06                	jmp    800a4e <strncmp+0x17>
		n--, p++, q++;
  800a48:	83 c0 01             	add    $0x1,%eax
  800a4b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4e:	39 d8                	cmp    %ebx,%eax
  800a50:	74 16                	je     800a68 <strncmp+0x31>
  800a52:	0f b6 08             	movzbl (%eax),%ecx
  800a55:	84 c9                	test   %cl,%cl
  800a57:	74 04                	je     800a5d <strncmp+0x26>
  800a59:	3a 0a                	cmp    (%edx),%cl
  800a5b:	74 eb                	je     800a48 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5d:	0f b6 00             	movzbl (%eax),%eax
  800a60:	0f b6 12             	movzbl (%edx),%edx
  800a63:	29 d0                	sub    %edx,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    
		return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6d:	eb f6                	jmp    800a65 <strncmp+0x2e>

00800a6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a79:	0f b6 10             	movzbl (%eax),%edx
  800a7c:	84 d2                	test   %dl,%dl
  800a7e:	74 09                	je     800a89 <strchr+0x1a>
		if (*s == c)
  800a80:	38 ca                	cmp    %cl,%dl
  800a82:	74 0a                	je     800a8e <strchr+0x1f>
	for (; *s; s++)
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	eb f0                	jmp    800a79 <strchr+0xa>
			return (char *) s;
	return 0;
  800a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9d:	38 ca                	cmp    %cl,%dl
  800a9f:	74 09                	je     800aaa <strfind+0x1a>
  800aa1:	84 d2                	test   %dl,%dl
  800aa3:	74 05                	je     800aaa <strfind+0x1a>
	for (; *s; s++)
  800aa5:	83 c0 01             	add    $0x1,%eax
  800aa8:	eb f0                	jmp    800a9a <strfind+0xa>
			break;
	return (char *) s;
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	57                   	push   %edi
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab8:	85 c9                	test   %ecx,%ecx
  800aba:	74 31                	je     800aed <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800abc:	89 f8                	mov    %edi,%eax
  800abe:	09 c8                	or     %ecx,%eax
  800ac0:	a8 03                	test   $0x3,%al
  800ac2:	75 23                	jne    800ae7 <memset+0x3b>
		c &= 0xFF;
  800ac4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac8:	89 d3                	mov    %edx,%ebx
  800aca:	c1 e3 08             	shl    $0x8,%ebx
  800acd:	89 d0                	mov    %edx,%eax
  800acf:	c1 e0 18             	shl    $0x18,%eax
  800ad2:	89 d6                	mov    %edx,%esi
  800ad4:	c1 e6 10             	shl    $0x10,%esi
  800ad7:	09 f0                	or     %esi,%eax
  800ad9:	09 c2                	or     %eax,%edx
  800adb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800add:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae0:	89 d0                	mov    %edx,%eax
  800ae2:	fc                   	cld    
  800ae3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae5:	eb 06                	jmp    800aed <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	fc                   	cld    
  800aeb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aed:	89 f8                	mov    %edi,%eax
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b02:	39 c6                	cmp    %eax,%esi
  800b04:	73 32                	jae    800b38 <memmove+0x44>
  800b06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b09:	39 c2                	cmp    %eax,%edx
  800b0b:	76 2b                	jbe    800b38 <memmove+0x44>
		s += n;
		d += n;
  800b0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b10:	89 fe                	mov    %edi,%esi
  800b12:	09 ce                	or     %ecx,%esi
  800b14:	09 d6                	or     %edx,%esi
  800b16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1c:	75 0e                	jne    800b2c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1e:	83 ef 04             	sub    $0x4,%edi
  800b21:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b24:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b27:	fd                   	std    
  800b28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2a:	eb 09                	jmp    800b35 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2c:	83 ef 01             	sub    $0x1,%edi
  800b2f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b32:	fd                   	std    
  800b33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b35:	fc                   	cld    
  800b36:	eb 1a                	jmp    800b52 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	09 ca                	or     %ecx,%edx
  800b3c:	09 f2                	or     %esi,%edx
  800b3e:	f6 c2 03             	test   $0x3,%dl
  800b41:	75 0a                	jne    800b4d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b46:	89 c7                	mov    %eax,%edi
  800b48:	fc                   	cld    
  800b49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4b:	eb 05                	jmp    800b52 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b4d:	89 c7                	mov    %eax,%edi
  800b4f:	fc                   	cld    
  800b50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	ff 75 08             	pushl  0x8(%ebp)
  800b65:	e8 8a ff ff ff       	call   800af4 <memmove>
}
  800b6a:	c9                   	leave  
  800b6b:	c3                   	ret    

00800b6c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	89 c6                	mov    %eax,%esi
  800b79:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7c:	39 f0                	cmp    %esi,%eax
  800b7e:	74 1c                	je     800b9c <memcmp+0x30>
		if (*s1 != *s2)
  800b80:	0f b6 08             	movzbl (%eax),%ecx
  800b83:	0f b6 1a             	movzbl (%edx),%ebx
  800b86:	38 d9                	cmp    %bl,%cl
  800b88:	75 08                	jne    800b92 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	83 c2 01             	add    $0x1,%edx
  800b90:	eb ea                	jmp    800b7c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b92:	0f b6 c1             	movzbl %cl,%eax
  800b95:	0f b6 db             	movzbl %bl,%ebx
  800b98:	29 d8                	sub    %ebx,%eax
  800b9a:	eb 05                	jmp    800ba1 <memcmp+0x35>
	}

	return 0;
  800b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bae:	89 c2                	mov    %eax,%edx
  800bb0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb3:	39 d0                	cmp    %edx,%eax
  800bb5:	73 09                	jae    800bc0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb7:	38 08                	cmp    %cl,(%eax)
  800bb9:	74 05                	je     800bc0 <memfind+0x1b>
	for (; s < ends; s++)
  800bbb:	83 c0 01             	add    $0x1,%eax
  800bbe:	eb f3                	jmp    800bb3 <memfind+0xe>
			break;
	return (void *) s;
}
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	57                   	push   %edi
  800bc6:	56                   	push   %esi
  800bc7:	53                   	push   %ebx
  800bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bce:	eb 03                	jmp    800bd3 <strtol+0x11>
		s++;
  800bd0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd3:	0f b6 01             	movzbl (%ecx),%eax
  800bd6:	3c 20                	cmp    $0x20,%al
  800bd8:	74 f6                	je     800bd0 <strtol+0xe>
  800bda:	3c 09                	cmp    $0x9,%al
  800bdc:	74 f2                	je     800bd0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bde:	3c 2b                	cmp    $0x2b,%al
  800be0:	74 2a                	je     800c0c <strtol+0x4a>
	int neg = 0;
  800be2:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be7:	3c 2d                	cmp    $0x2d,%al
  800be9:	74 2b                	je     800c16 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800beb:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf1:	75 0f                	jne    800c02 <strtol+0x40>
  800bf3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf6:	74 28                	je     800c20 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bff:	0f 44 d8             	cmove  %eax,%ebx
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
  800c07:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0a:	eb 50                	jmp    800c5c <strtol+0x9a>
		s++;
  800c0c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c14:	eb d5                	jmp    800beb <strtol+0x29>
		s++, neg = 1;
  800c16:	83 c1 01             	add    $0x1,%ecx
  800c19:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1e:	eb cb                	jmp    800beb <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c20:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c24:	74 0e                	je     800c34 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	75 d8                	jne    800c02 <strtol+0x40>
		s++, base = 8;
  800c2a:	83 c1 01             	add    $0x1,%ecx
  800c2d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c32:	eb ce                	jmp    800c02 <strtol+0x40>
		s += 2, base = 16;
  800c34:	83 c1 02             	add    $0x2,%ecx
  800c37:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3c:	eb c4                	jmp    800c02 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c3e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c41:	89 f3                	mov    %esi,%ebx
  800c43:	80 fb 19             	cmp    $0x19,%bl
  800c46:	77 29                	ja     800c71 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c48:	0f be d2             	movsbl %dl,%edx
  800c4b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c51:	7d 30                	jge    800c83 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c53:	83 c1 01             	add    $0x1,%ecx
  800c56:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5c:	0f b6 11             	movzbl (%ecx),%edx
  800c5f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c62:	89 f3                	mov    %esi,%ebx
  800c64:	80 fb 09             	cmp    $0x9,%bl
  800c67:	77 d5                	ja     800c3e <strtol+0x7c>
			dig = *s - '0';
  800c69:	0f be d2             	movsbl %dl,%edx
  800c6c:	83 ea 30             	sub    $0x30,%edx
  800c6f:	eb dd                	jmp    800c4e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c71:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c74:	89 f3                	mov    %esi,%ebx
  800c76:	80 fb 19             	cmp    $0x19,%bl
  800c79:	77 08                	ja     800c83 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c7b:	0f be d2             	movsbl %dl,%edx
  800c7e:	83 ea 37             	sub    $0x37,%edx
  800c81:	eb cb                	jmp    800c4e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c87:	74 05                	je     800c8e <strtol+0xcc>
		*endptr = (char *) s;
  800c89:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8e:	89 c2                	mov    %eax,%edx
  800c90:	f7 da                	neg    %edx
  800c92:	85 ff                	test   %edi,%edi
  800c94:	0f 45 c2             	cmovne %edx,%eax
}
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	89 c3                	mov    %eax,%ebx
  800caf:	89 c7                	mov    %eax,%edi
  800cb1:	89 c6                	mov    %eax,%esi
  800cb3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_cgetc>:

int
sys_cgetc(void)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cca:	89 d1                	mov    %edx,%ecx
  800ccc:	89 d3                	mov    %edx,%ebx
  800cce:	89 d7                	mov    %edx,%edi
  800cd0:	89 d6                	mov    %edx,%esi
  800cd2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cea:	b8 03 00 00 00       	mov    $0x3,%eax
  800cef:	89 cb                	mov    %ecx,%ebx
  800cf1:	89 cf                	mov    %ecx,%edi
  800cf3:	89 ce                	mov    %ecx,%esi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 03                	push   $0x3
  800d09:	68 88 29 80 00       	push   $0x802988
  800d0e:	6a 43                	push   $0x43
  800d10:	68 a5 29 80 00       	push   $0x8029a5
  800d15:	e8 89 14 00 00       	call   8021a3 <_panic>

00800d1a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d20:	ba 00 00 00 00       	mov    $0x0,%edx
  800d25:	b8 02 00 00 00       	mov    $0x2,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_yield>:

void
sys_yield(void)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d49:	89 d1                	mov    %edx,%ecx
  800d4b:	89 d3                	mov    %edx,%ebx
  800d4d:	89 d7                	mov    %edx,%edi
  800d4f:	89 d6                	mov    %edx,%esi
  800d51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	be 00 00 00 00       	mov    $0x0,%esi
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d74:	89 f7                	mov    %esi,%edi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 04                	push   $0x4
  800d8a:	68 88 29 80 00       	push   $0x802988
  800d8f:	6a 43                	push   $0x43
  800d91:	68 a5 29 80 00       	push   $0x8029a5
  800d96:	e8 08 14 00 00       	call   8021a3 <_panic>

00800d9b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
  800da1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	b8 05 00 00 00       	mov    $0x5,%eax
  800daf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db5:	8b 75 18             	mov    0x18(%ebp),%esi
  800db8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7f 08                	jg     800dc6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	50                   	push   %eax
  800dca:	6a 05                	push   $0x5
  800dcc:	68 88 29 80 00       	push   $0x802988
  800dd1:	6a 43                	push   $0x43
  800dd3:	68 a5 29 80 00       	push   $0x8029a5
  800dd8:	e8 c6 13 00 00       	call   8021a3 <_panic>

00800ddd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df1:	b8 06 00 00 00       	mov    $0x6,%eax
  800df6:	89 df                	mov    %ebx,%edi
  800df8:	89 de                	mov    %ebx,%esi
  800dfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7f 08                	jg     800e08 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e03:	5b                   	pop    %ebx
  800e04:	5e                   	pop    %esi
  800e05:	5f                   	pop    %edi
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e08:	83 ec 0c             	sub    $0xc,%esp
  800e0b:	50                   	push   %eax
  800e0c:	6a 06                	push   $0x6
  800e0e:	68 88 29 80 00       	push   $0x802988
  800e13:	6a 43                	push   $0x43
  800e15:	68 a5 29 80 00       	push   $0x8029a5
  800e1a:	e8 84 13 00 00       	call   8021a3 <_panic>

00800e1f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e33:	b8 08 00 00 00       	mov    $0x8,%eax
  800e38:	89 df                	mov    %ebx,%edi
  800e3a:	89 de                	mov    %ebx,%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 08                	push   $0x8
  800e50:	68 88 29 80 00       	push   $0x802988
  800e55:	6a 43                	push   $0x43
  800e57:	68 a5 29 80 00       	push   $0x8029a5
  800e5c:	e8 42 13 00 00       	call   8021a3 <_panic>

00800e61 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7a:	89 df                	mov    %ebx,%edi
  800e7c:	89 de                	mov    %ebx,%esi
  800e7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e80:	85 c0                	test   %eax,%eax
  800e82:	7f 08                	jg     800e8c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	50                   	push   %eax
  800e90:	6a 09                	push   $0x9
  800e92:	68 88 29 80 00       	push   $0x802988
  800e97:	6a 43                	push   $0x43
  800e99:	68 a5 29 80 00       	push   $0x8029a5
  800e9e:	e8 00 13 00 00       	call   8021a3 <_panic>

00800ea3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7f 08                	jg     800ece <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ece:	83 ec 0c             	sub    $0xc,%esp
  800ed1:	50                   	push   %eax
  800ed2:	6a 0a                	push   $0xa
  800ed4:	68 88 29 80 00       	push   $0x802988
  800ed9:	6a 43                	push   $0x43
  800edb:	68 a5 29 80 00       	push   $0x8029a5
  800ee0:	e8 be 12 00 00       	call   8021a3 <_panic>

00800ee5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef6:	be 00 00 00 00       	mov    $0x0,%esi
  800efb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f01:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	57                   	push   %edi
  800f0c:	56                   	push   %esi
  800f0d:	53                   	push   %ebx
  800f0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1e:	89 cb                	mov    %ecx,%ebx
  800f20:	89 cf                	mov    %ecx,%edi
  800f22:	89 ce                	mov    %ecx,%esi
  800f24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7f 08                	jg     800f32 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f32:	83 ec 0c             	sub    $0xc,%esp
  800f35:	50                   	push   %eax
  800f36:	6a 0d                	push   $0xd
  800f38:	68 88 29 80 00       	push   $0x802988
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 a5 29 80 00       	push   $0x8029a5
  800f44:	e8 5a 12 00 00       	call   8021a3 <_panic>

00800f49 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5f:	89 df                	mov    %ebx,%edi
  800f61:	89 de                	mov    %ebx,%esi
  800f63:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7d:	89 cb                	mov    %ecx,%ebx
  800f7f:	89 cf                	mov    %ecx,%edi
  800f81:	89 ce                	mov    %ecx,%esi
  800f83:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9a:	89 d1                	mov    %edx,%ecx
  800f9c:	89 d3                	mov    %edx,%ebx
  800f9e:	89 d7                	mov    %edx,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	b8 11 00 00 00       	mov    $0x11,%eax
  800fbf:	89 df                	mov    %ebx,%edi
  800fc1:	89 de                	mov    %ebx,%esi
  800fc3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc5:	5b                   	pop    %ebx
  800fc6:	5e                   	pop    %esi
  800fc7:	5f                   	pop    %edi
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	b8 12 00 00 00       	mov    $0x12,%eax
  800fe0:	89 df                	mov    %ebx,%edi
  800fe2:	89 de                	mov    %ebx,%esi
  800fe4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	b8 13 00 00 00       	mov    $0x13,%eax
  801004:	89 df                	mov    %ebx,%edi
  801006:	89 de                	mov    %ebx,%esi
  801008:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100a:	85 c0                	test   %eax,%eax
  80100c:	7f 08                	jg     801016 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	50                   	push   %eax
  80101a:	6a 13                	push   $0x13
  80101c:	68 88 29 80 00       	push   $0x802988
  801021:	6a 43                	push   $0x43
  801023:	68 a5 29 80 00       	push   $0x8029a5
  801028:	e8 76 11 00 00       	call   8021a3 <_panic>

0080102d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	57                   	push   %edi
  801031:	56                   	push   %esi
  801032:	53                   	push   %ebx
	asm volatile("int %1\n"
  801033:	b9 00 00 00 00       	mov    $0x0,%ecx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	b8 14 00 00 00       	mov    $0x14,%eax
  801040:	89 cb                	mov    %ecx,%ebx
  801042:	89 cf                	mov    %ecx,%edi
  801044:	89 ce                	mov    %ecx,%esi
  801046:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	05 00 00 00 30       	add    $0x30000000,%eax
  801058:	c1 e8 0c             	shr    $0xc,%eax
}
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801068:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80106d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801072:	5d                   	pop    %ebp
  801073:	c3                   	ret    

00801074 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	c1 ea 16             	shr    $0x16,%edx
  801081:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	74 2d                	je     8010ba <fd_alloc+0x46>
  80108d:	89 c2                	mov    %eax,%edx
  80108f:	c1 ea 0c             	shr    $0xc,%edx
  801092:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801099:	f6 c2 01             	test   $0x1,%dl
  80109c:	74 1c                	je     8010ba <fd_alloc+0x46>
  80109e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a8:	75 d2                	jne    80107c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010b8:	eb 0a                	jmp    8010c4 <fd_alloc+0x50>
			*fd_store = fd;
  8010ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010cc:	83 f8 1f             	cmp    $0x1f,%eax
  8010cf:	77 30                	ja     801101 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d1:	c1 e0 0c             	shl    $0xc,%eax
  8010d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	74 24                	je     801108 <fd_lookup+0x42>
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 ea 0c             	shr    $0xc,%edx
  8010e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f0:	f6 c2 01             	test   $0x1,%dl
  8010f3:	74 1a                	je     80110f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    
		return -E_INVAL;
  801101:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801106:	eb f7                	jmp    8010ff <fd_lookup+0x39>
		return -E_INVAL;
  801108:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110d:	eb f0                	jmp    8010ff <fd_lookup+0x39>
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801114:	eb e9                	jmp    8010ff <fd_lookup+0x39>

00801116 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80111f:	ba 00 00 00 00       	mov    $0x0,%edx
  801124:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801129:	39 08                	cmp    %ecx,(%eax)
  80112b:	74 38                	je     801165 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80112d:	83 c2 01             	add    $0x1,%edx
  801130:	8b 04 95 30 2a 80 00 	mov    0x802a30(,%edx,4),%eax
  801137:	85 c0                	test   %eax,%eax
  801139:	75 ee                	jne    801129 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113b:	a1 08 40 80 00       	mov    0x804008,%eax
  801140:	8b 40 48             	mov    0x48(%eax),%eax
  801143:	83 ec 04             	sub    $0x4,%esp
  801146:	51                   	push   %ecx
  801147:	50                   	push   %eax
  801148:	68 b4 29 80 00       	push   $0x8029b4
  80114d:	e8 b5 f0 ff ff       	call   800207 <cprintf>
	*dev = 0;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    
			*dev = devtab[i];
  801165:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801168:	89 01                	mov    %eax,(%ecx)
			return 0;
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	eb f2                	jmp    801163 <dev_lookup+0x4d>

00801171 <fd_close>:
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
  801177:	83 ec 24             	sub    $0x24,%esp
  80117a:	8b 75 08             	mov    0x8(%ebp),%esi
  80117d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801180:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801183:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801184:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80118a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80118d:	50                   	push   %eax
  80118e:	e8 33 ff ff ff       	call   8010c6 <fd_lookup>
  801193:	89 c3                	mov    %eax,%ebx
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 05                	js     8011a1 <fd_close+0x30>
	    || fd != fd2)
  80119c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80119f:	74 16                	je     8011b7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011a1:	89 f8                	mov    %edi,%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	0f 44 d8             	cmove  %eax,%ebx
}
  8011ad:	89 d8                	mov    %ebx,%eax
  8011af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b2:	5b                   	pop    %ebx
  8011b3:	5e                   	pop    %esi
  8011b4:	5f                   	pop    %edi
  8011b5:	5d                   	pop    %ebp
  8011b6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	ff 36                	pushl  (%esi)
  8011c0:	e8 51 ff ff ff       	call   801116 <dev_lookup>
  8011c5:	89 c3                	mov    %eax,%ebx
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	78 1a                	js     8011e8 <fd_close+0x77>
		if (dev->dev_close)
  8011ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	74 0b                	je     8011e8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	56                   	push   %esi
  8011e1:	ff d0                	call   *%eax
  8011e3:	89 c3                	mov    %eax,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	56                   	push   %esi
  8011ec:	6a 00                	push   $0x0
  8011ee:	e8 ea fb ff ff       	call   800ddd <sys_page_unmap>
	return r;
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	eb b5                	jmp    8011ad <fd_close+0x3c>

008011f8 <close>:

int
close(int fdnum)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801201:	50                   	push   %eax
  801202:	ff 75 08             	pushl  0x8(%ebp)
  801205:	e8 bc fe ff ff       	call   8010c6 <fd_lookup>
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	79 02                	jns    801213 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801211:	c9                   	leave  
  801212:	c3                   	ret    
		return fd_close(fd, 1);
  801213:	83 ec 08             	sub    $0x8,%esp
  801216:	6a 01                	push   $0x1
  801218:	ff 75 f4             	pushl  -0xc(%ebp)
  80121b:	e8 51 ff ff ff       	call   801171 <fd_close>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	eb ec                	jmp    801211 <close+0x19>

00801225 <close_all>:

void
close_all(void)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	53                   	push   %ebx
  801229:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	53                   	push   %ebx
  801235:	e8 be ff ff ff       	call   8011f8 <close>
	for (i = 0; i < MAXFD; i++)
  80123a:	83 c3 01             	add    $0x1,%ebx
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	83 fb 20             	cmp    $0x20,%ebx
  801243:	75 ec                	jne    801231 <close_all+0xc>
}
  801245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	57                   	push   %edi
  80124e:	56                   	push   %esi
  80124f:	53                   	push   %ebx
  801250:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801253:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	ff 75 08             	pushl  0x8(%ebp)
  80125a:	e8 67 fe ff ff       	call   8010c6 <fd_lookup>
  80125f:	89 c3                	mov    %eax,%ebx
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	0f 88 81 00 00 00    	js     8012ed <dup+0xa3>
		return r;
	close(newfdnum);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	e8 81 ff ff ff       	call   8011f8 <close>

	newfd = INDEX2FD(newfdnum);
  801277:	8b 75 0c             	mov    0xc(%ebp),%esi
  80127a:	c1 e6 0c             	shl    $0xc,%esi
  80127d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801283:	83 c4 04             	add    $0x4,%esp
  801286:	ff 75 e4             	pushl  -0x1c(%ebp)
  801289:	e8 cf fd ff ff       	call   80105d <fd2data>
  80128e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801290:	89 34 24             	mov    %esi,(%esp)
  801293:	e8 c5 fd ff ff       	call   80105d <fd2data>
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129d:	89 d8                	mov    %ebx,%eax
  80129f:	c1 e8 16             	shr    $0x16,%eax
  8012a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012a9:	a8 01                	test   $0x1,%al
  8012ab:	74 11                	je     8012be <dup+0x74>
  8012ad:	89 d8                	mov    %ebx,%eax
  8012af:	c1 e8 0c             	shr    $0xc,%eax
  8012b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012b9:	f6 c2 01             	test   $0x1,%dl
  8012bc:	75 39                	jne    8012f7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012c1:	89 d0                	mov    %edx,%eax
  8012c3:	c1 e8 0c             	shr    $0xc,%eax
  8012c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012cd:	83 ec 0c             	sub    $0xc,%esp
  8012d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d5:	50                   	push   %eax
  8012d6:	56                   	push   %esi
  8012d7:	6a 00                	push   $0x0
  8012d9:	52                   	push   %edx
  8012da:	6a 00                	push   $0x0
  8012dc:	e8 ba fa ff ff       	call   800d9b <sys_page_map>
  8012e1:	89 c3                	mov    %eax,%ebx
  8012e3:	83 c4 20             	add    $0x20,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 31                	js     80131b <dup+0xd1>
		goto err;

	return newfdnum;
  8012ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012ed:	89 d8                	mov    %ebx,%eax
  8012ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f2:	5b                   	pop    %ebx
  8012f3:	5e                   	pop    %esi
  8012f4:	5f                   	pop    %edi
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	25 07 0e 00 00       	and    $0xe07,%eax
  801306:	50                   	push   %eax
  801307:	57                   	push   %edi
  801308:	6a 00                	push   $0x0
  80130a:	53                   	push   %ebx
  80130b:	6a 00                	push   $0x0
  80130d:	e8 89 fa ff ff       	call   800d9b <sys_page_map>
  801312:	89 c3                	mov    %eax,%ebx
  801314:	83 c4 20             	add    $0x20,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	79 a3                	jns    8012be <dup+0x74>
	sys_page_unmap(0, newfd);
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	56                   	push   %esi
  80131f:	6a 00                	push   $0x0
  801321:	e8 b7 fa ff ff       	call   800ddd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801326:	83 c4 08             	add    $0x8,%esp
  801329:	57                   	push   %edi
  80132a:	6a 00                	push   $0x0
  80132c:	e8 ac fa ff ff       	call   800ddd <sys_page_unmap>
	return r;
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	eb b7                	jmp    8012ed <dup+0xa3>

00801336 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	53                   	push   %ebx
  80133a:	83 ec 1c             	sub    $0x1c,%esp
  80133d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801340:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801343:	50                   	push   %eax
  801344:	53                   	push   %ebx
  801345:	e8 7c fd ff ff       	call   8010c6 <fd_lookup>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 3f                	js     801390 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801357:	50                   	push   %eax
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	ff 30                	pushl  (%eax)
  80135d:	e8 b4 fd ff ff       	call   801116 <dev_lookup>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	78 27                	js     801390 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801369:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136c:	8b 42 08             	mov    0x8(%edx),%eax
  80136f:	83 e0 03             	and    $0x3,%eax
  801372:	83 f8 01             	cmp    $0x1,%eax
  801375:	74 1e                	je     801395 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137a:	8b 40 08             	mov    0x8(%eax),%eax
  80137d:	85 c0                	test   %eax,%eax
  80137f:	74 35                	je     8013b6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801381:	83 ec 04             	sub    $0x4,%esp
  801384:	ff 75 10             	pushl  0x10(%ebp)
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	52                   	push   %edx
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
}
  801390:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801393:	c9                   	leave  
  801394:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801395:	a1 08 40 80 00       	mov    0x804008,%eax
  80139a:	8b 40 48             	mov    0x48(%eax),%eax
  80139d:	83 ec 04             	sub    $0x4,%esp
  8013a0:	53                   	push   %ebx
  8013a1:	50                   	push   %eax
  8013a2:	68 f5 29 80 00       	push   $0x8029f5
  8013a7:	e8 5b ee ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b4:	eb da                	jmp    801390 <read+0x5a>
		return -E_NOT_SUPP;
  8013b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bb:	eb d3                	jmp    801390 <read+0x5a>

008013bd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	57                   	push   %edi
  8013c1:	56                   	push   %esi
  8013c2:	53                   	push   %ebx
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d1:	39 f3                	cmp    %esi,%ebx
  8013d3:	73 23                	jae    8013f8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	89 f0                	mov    %esi,%eax
  8013da:	29 d8                	sub    %ebx,%eax
  8013dc:	50                   	push   %eax
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	03 45 0c             	add    0xc(%ebp),%eax
  8013e2:	50                   	push   %eax
  8013e3:	57                   	push   %edi
  8013e4:	e8 4d ff ff ff       	call   801336 <read>
		if (m < 0)
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 06                	js     8013f6 <readn+0x39>
			return m;
		if (m == 0)
  8013f0:	74 06                	je     8013f8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013f2:	01 c3                	add    %eax,%ebx
  8013f4:	eb db                	jmp    8013d1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013f8:	89 d8                	mov    %ebx,%eax
  8013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fd:	5b                   	pop    %ebx
  8013fe:	5e                   	pop    %esi
  8013ff:	5f                   	pop    %edi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	53                   	push   %ebx
  801406:	83 ec 1c             	sub    $0x1c,%esp
  801409:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140f:	50                   	push   %eax
  801410:	53                   	push   %ebx
  801411:	e8 b0 fc ff ff       	call   8010c6 <fd_lookup>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 3a                	js     801457 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141d:	83 ec 08             	sub    $0x8,%esp
  801420:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	ff 30                	pushl  (%eax)
  801429:	e8 e8 fc ff ff       	call   801116 <dev_lookup>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	85 c0                	test   %eax,%eax
  801433:	78 22                	js     801457 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801438:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80143c:	74 1e                	je     80145c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80143e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801441:	8b 52 0c             	mov    0xc(%edx),%edx
  801444:	85 d2                	test   %edx,%edx
  801446:	74 35                	je     80147d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	ff 75 10             	pushl  0x10(%ebp)
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	50                   	push   %eax
  801452:	ff d2                	call   *%edx
  801454:	83 c4 10             	add    $0x10,%esp
}
  801457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80145c:	a1 08 40 80 00       	mov    0x804008,%eax
  801461:	8b 40 48             	mov    0x48(%eax),%eax
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	53                   	push   %ebx
  801468:	50                   	push   %eax
  801469:	68 11 2a 80 00       	push   $0x802a11
  80146e:	e8 94 ed ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147b:	eb da                	jmp    801457 <write+0x55>
		return -E_NOT_SUPP;
  80147d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801482:	eb d3                	jmp    801457 <write+0x55>

00801484 <seek>:

int
seek(int fdnum, off_t offset)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148d:	50                   	push   %eax
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	e8 30 fc ff ff       	call   8010c6 <fd_lookup>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 0e                	js     8014ab <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 1c             	sub    $0x1c,%esp
  8014b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	53                   	push   %ebx
  8014bc:	e8 05 fc ff ff       	call   8010c6 <fd_lookup>
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 37                	js     8014ff <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c8:	83 ec 08             	sub    $0x8,%esp
  8014cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ce:	50                   	push   %eax
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	ff 30                	pushl  (%eax)
  8014d4:	e8 3d fc ff ff       	call   801116 <dev_lookup>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 1f                	js     8014ff <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e7:	74 1b                	je     801504 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ec:	8b 52 18             	mov    0x18(%edx),%edx
  8014ef:	85 d2                	test   %edx,%edx
  8014f1:	74 32                	je     801525 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	50                   	push   %eax
  8014fa:	ff d2                	call   *%edx
  8014fc:	83 c4 10             	add    $0x10,%esp
}
  8014ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801502:	c9                   	leave  
  801503:	c3                   	ret    
			thisenv->env_id, fdnum);
  801504:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801509:	8b 40 48             	mov    0x48(%eax),%eax
  80150c:	83 ec 04             	sub    $0x4,%esp
  80150f:	53                   	push   %ebx
  801510:	50                   	push   %eax
  801511:	68 d4 29 80 00       	push   $0x8029d4
  801516:	e8 ec ec ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801523:	eb da                	jmp    8014ff <ftruncate+0x52>
		return -E_NOT_SUPP;
  801525:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152a:	eb d3                	jmp    8014ff <ftruncate+0x52>

0080152c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	53                   	push   %ebx
  801530:	83 ec 1c             	sub    $0x1c,%esp
  801533:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	ff 75 08             	pushl  0x8(%ebp)
  80153d:	e8 84 fb ff ff       	call   8010c6 <fd_lookup>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 4b                	js     801594 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801553:	ff 30                	pushl  (%eax)
  801555:	e8 bc fb ff ff       	call   801116 <dev_lookup>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 33                	js     801594 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801564:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801568:	74 2f                	je     801599 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80156a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80156d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801574:	00 00 00 
	stat->st_isdir = 0;
  801577:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80157e:	00 00 00 
	stat->st_dev = dev;
  801581:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	53                   	push   %ebx
  80158b:	ff 75 f0             	pushl  -0x10(%ebp)
  80158e:	ff 50 14             	call   *0x14(%eax)
  801591:	83 c4 10             	add    $0x10,%esp
}
  801594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801597:	c9                   	leave  
  801598:	c3                   	ret    
		return -E_NOT_SUPP;
  801599:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159e:	eb f4                	jmp    801594 <fstat+0x68>

008015a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	6a 00                	push   $0x0
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 22 02 00 00       	call   8017d4 <open>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 1b                	js     8015d6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	50                   	push   %eax
  8015c2:	e8 65 ff ff ff       	call   80152c <fstat>
  8015c7:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c9:	89 1c 24             	mov    %ebx,(%esp)
  8015cc:	e8 27 fc ff ff       	call   8011f8 <close>
	return r;
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	89 f3                	mov    %esi,%ebx
}
  8015d6:	89 d8                	mov    %ebx,%eax
  8015d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015db:	5b                   	pop    %ebx
  8015dc:	5e                   	pop    %esi
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    

008015df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	89 c6                	mov    %eax,%esi
  8015e6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015e8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ef:	74 27                	je     801618 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015f1:	6a 07                	push   $0x7
  8015f3:	68 00 50 80 00       	push   $0x805000
  8015f8:	56                   	push   %esi
  8015f9:	ff 35 00 40 80 00    	pushl  0x804000
  8015ff:	e8 69 0c 00 00       	call   80226d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801604:	83 c4 0c             	add    $0xc,%esp
  801607:	6a 00                	push   $0x0
  801609:	53                   	push   %ebx
  80160a:	6a 00                	push   $0x0
  80160c:	e8 f3 0b 00 00       	call   802204 <ipc_recv>
}
  801611:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801614:	5b                   	pop    %ebx
  801615:	5e                   	pop    %esi
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	6a 01                	push   $0x1
  80161d:	e8 a3 0c 00 00       	call   8022c5 <ipc_find_env>
  801622:	a3 00 40 80 00       	mov    %eax,0x804000
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	eb c5                	jmp    8015f1 <fsipc+0x12>

0080162c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8b 40 0c             	mov    0xc(%eax),%eax
  801638:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801645:	ba 00 00 00 00       	mov    $0x0,%edx
  80164a:	b8 02 00 00 00       	mov    $0x2,%eax
  80164f:	e8 8b ff ff ff       	call   8015df <fsipc>
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <devfile_flush>:
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8b 40 0c             	mov    0xc(%eax),%eax
  801662:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801667:	ba 00 00 00 00       	mov    $0x0,%edx
  80166c:	b8 06 00 00 00       	mov    $0x6,%eax
  801671:	e8 69 ff ff ff       	call   8015df <fsipc>
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <devfile_stat>:
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	53                   	push   %ebx
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8b 40 0c             	mov    0xc(%eax),%eax
  801688:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168d:	ba 00 00 00 00       	mov    $0x0,%edx
  801692:	b8 05 00 00 00       	mov    $0x5,%eax
  801697:	e8 43 ff ff ff       	call   8015df <fsipc>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 2c                	js     8016cc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016a0:	83 ec 08             	sub    $0x8,%esp
  8016a3:	68 00 50 80 00       	push   $0x805000
  8016a8:	53                   	push   %ebx
  8016a9:	e8 b8 f2 ff ff       	call   800966 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ae:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b9:	a1 84 50 80 00       	mov    0x805084,%eax
  8016be:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <devfile_write>:
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016e6:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016ec:	53                   	push   %ebx
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	68 08 50 80 00       	push   $0x805008
  8016f5:	e8 5c f4 ff ff       	call   800b56 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	b8 04 00 00 00       	mov    $0x4,%eax
  801704:	e8 d6 fe ff ff       	call   8015df <fsipc>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 0b                	js     80171b <devfile_write+0x4a>
	assert(r <= n);
  801710:	39 d8                	cmp    %ebx,%eax
  801712:	77 0c                	ja     801720 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801714:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801719:	7f 1e                	jg     801739 <devfile_write+0x68>
}
  80171b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    
	assert(r <= n);
  801720:	68 44 2a 80 00       	push   $0x802a44
  801725:	68 4b 2a 80 00       	push   $0x802a4b
  80172a:	68 98 00 00 00       	push   $0x98
  80172f:	68 60 2a 80 00       	push   $0x802a60
  801734:	e8 6a 0a 00 00       	call   8021a3 <_panic>
	assert(r <= PGSIZE);
  801739:	68 6b 2a 80 00       	push   $0x802a6b
  80173e:	68 4b 2a 80 00       	push   $0x802a4b
  801743:	68 99 00 00 00       	push   $0x99
  801748:	68 60 2a 80 00       	push   $0x802a60
  80174d:	e8 51 0a 00 00       	call   8021a3 <_panic>

00801752 <devfile_read>:
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	56                   	push   %esi
  801756:	53                   	push   %ebx
  801757:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8b 40 0c             	mov    0xc(%eax),%eax
  801760:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801765:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80176b:	ba 00 00 00 00       	mov    $0x0,%edx
  801770:	b8 03 00 00 00       	mov    $0x3,%eax
  801775:	e8 65 fe ff ff       	call   8015df <fsipc>
  80177a:	89 c3                	mov    %eax,%ebx
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 1f                	js     80179f <devfile_read+0x4d>
	assert(r <= n);
  801780:	39 f0                	cmp    %esi,%eax
  801782:	77 24                	ja     8017a8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801784:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801789:	7f 33                	jg     8017be <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	50                   	push   %eax
  80178f:	68 00 50 80 00       	push   $0x805000
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	e8 58 f3 ff ff       	call   800af4 <memmove>
	return r;
  80179c:	83 c4 10             	add    $0x10,%esp
}
  80179f:	89 d8                	mov    %ebx,%eax
  8017a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a4:	5b                   	pop    %ebx
  8017a5:	5e                   	pop    %esi
  8017a6:	5d                   	pop    %ebp
  8017a7:	c3                   	ret    
	assert(r <= n);
  8017a8:	68 44 2a 80 00       	push   $0x802a44
  8017ad:	68 4b 2a 80 00       	push   $0x802a4b
  8017b2:	6a 7c                	push   $0x7c
  8017b4:	68 60 2a 80 00       	push   $0x802a60
  8017b9:	e8 e5 09 00 00       	call   8021a3 <_panic>
	assert(r <= PGSIZE);
  8017be:	68 6b 2a 80 00       	push   $0x802a6b
  8017c3:	68 4b 2a 80 00       	push   $0x802a4b
  8017c8:	6a 7d                	push   $0x7d
  8017ca:	68 60 2a 80 00       	push   $0x802a60
  8017cf:	e8 cf 09 00 00       	call   8021a3 <_panic>

008017d4 <open>:
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 1c             	sub    $0x1c,%esp
  8017dc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017df:	56                   	push   %esi
  8017e0:	e8 48 f1 ff ff       	call   80092d <strlen>
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ed:	7f 6c                	jg     80185b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ef:	83 ec 0c             	sub    $0xc,%esp
  8017f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f5:	50                   	push   %eax
  8017f6:	e8 79 f8 ff ff       	call   801074 <fd_alloc>
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	85 c0                	test   %eax,%eax
  801802:	78 3c                	js     801840 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801804:	83 ec 08             	sub    $0x8,%esp
  801807:	56                   	push   %esi
  801808:	68 00 50 80 00       	push   $0x805000
  80180d:	e8 54 f1 ff ff       	call   800966 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801812:	8b 45 0c             	mov    0xc(%ebp),%eax
  801815:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80181a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181d:	b8 01 00 00 00       	mov    $0x1,%eax
  801822:	e8 b8 fd ff ff       	call   8015df <fsipc>
  801827:	89 c3                	mov    %eax,%ebx
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 19                	js     801849 <open+0x75>
	return fd2num(fd);
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	ff 75 f4             	pushl  -0xc(%ebp)
  801836:	e8 12 f8 ff ff       	call   80104d <fd2num>
  80183b:	89 c3                	mov    %eax,%ebx
  80183d:	83 c4 10             	add    $0x10,%esp
}
  801840:	89 d8                	mov    %ebx,%eax
  801842:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5d                   	pop    %ebp
  801848:	c3                   	ret    
		fd_close(fd, 0);
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 f4             	pushl  -0xc(%ebp)
  801851:	e8 1b f9 ff ff       	call   801171 <fd_close>
		return r;
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	eb e5                	jmp    801840 <open+0x6c>
		return -E_BAD_PATH;
  80185b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801860:	eb de                	jmp    801840 <open+0x6c>

00801862 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801868:	ba 00 00 00 00       	mov    $0x0,%edx
  80186d:	b8 08 00 00 00       	mov    $0x8,%eax
  801872:	e8 68 fd ff ff       	call   8015df <fsipc>
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80187f:	68 77 2a 80 00       	push   $0x802a77
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	e8 da f0 ff ff       	call   800966 <strcpy>
	return 0;
}
  80188c:	b8 00 00 00 00       	mov    $0x0,%eax
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <devsock_close>:
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	53                   	push   %ebx
  801897:	83 ec 10             	sub    $0x10,%esp
  80189a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189d:	53                   	push   %ebx
  80189e:	e8 5d 0a 00 00       	call   802300 <pageref>
  8018a3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018a6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018ab:	83 f8 01             	cmp    $0x1,%eax
  8018ae:	74 07                	je     8018b7 <devsock_close+0x24>
}
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 73 0c             	pushl  0xc(%ebx)
  8018bd:	e8 b9 02 00 00       	call   801b7b <nsipc_close>
  8018c2:	89 c2                	mov    %eax,%edx
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	eb e7                	jmp    8018b0 <devsock_close+0x1d>

008018c9 <devsock_write>:
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	ff 75 10             	pushl  0x10(%ebp)
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	ff 70 0c             	pushl  0xc(%eax)
  8018dd:	e8 76 03 00 00       	call   801c58 <nsipc_send>
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <devsock_read>:
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	ff 75 10             	pushl  0x10(%ebp)
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	ff 70 0c             	pushl  0xc(%eax)
  8018f8:	e8 ef 02 00 00       	call   801bec <nsipc_recv>
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <fd2sockid>:
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801905:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	e8 b7 f7 ff ff       	call   8010c6 <fd_lookup>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	85 c0                	test   %eax,%eax
  801914:	78 10                	js     801926 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80191f:	39 08                	cmp    %ecx,(%eax)
  801921:	75 05                	jne    801928 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801923:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    
		return -E_NOT_SUPP;
  801928:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192d:	eb f7                	jmp    801926 <fd2sockid+0x27>

0080192f <alloc_sockfd>:
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	83 ec 1c             	sub    $0x1c,%esp
  801937:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801939:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193c:	50                   	push   %eax
  80193d:	e8 32 f7 ff ff       	call   801074 <fd_alloc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	83 c4 10             	add    $0x10,%esp
  801947:	85 c0                	test   %eax,%eax
  801949:	78 43                	js     80198e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 07 04 00 00       	push   $0x407
  801953:	ff 75 f4             	pushl  -0xc(%ebp)
  801956:	6a 00                	push   $0x0
  801958:	e8 fb f3 ff ff       	call   800d58 <sys_page_alloc>
  80195d:	89 c3                	mov    %eax,%ebx
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	85 c0                	test   %eax,%eax
  801964:	78 28                	js     80198e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80196f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801974:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80197b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	50                   	push   %eax
  801982:	e8 c6 f6 ff ff       	call   80104d <fd2num>
  801987:	89 c3                	mov    %eax,%ebx
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	eb 0c                	jmp    80199a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	56                   	push   %esi
  801992:	e8 e4 01 00 00       	call   801b7b <nsipc_close>
		return r;
  801997:	83 c4 10             	add    $0x10,%esp
}
  80199a:	89 d8                	mov    %ebx,%eax
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <accept>:
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	e8 4e ff ff ff       	call   8018ff <fd2sockid>
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 1b                	js     8019d0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	e8 0e 01 00 00       	call   801ad2 <nsipc_accept>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 05                	js     8019d0 <accept+0x2d>
	return alloc_sockfd(r);
  8019cb:	e8 5f ff ff ff       	call   80192f <alloc_sockfd>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <bind>:
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	e8 1f ff ff ff       	call   8018ff <fd2sockid>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 12                	js     8019f6 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	50                   	push   %eax
  8019ee:	e8 31 01 00 00       	call   801b24 <nsipc_bind>
  8019f3:	83 c4 10             	add    $0x10,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <shutdown>:
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	e8 f9 fe ff ff       	call   8018ff <fd2sockid>
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 0f                	js     801a19 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a0a:	83 ec 08             	sub    $0x8,%esp
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	50                   	push   %eax
  801a11:	e8 43 01 00 00       	call   801b59 <nsipc_shutdown>
  801a16:	83 c4 10             	add    $0x10,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <connect>:
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	e8 d6 fe ff ff       	call   8018ff <fd2sockid>
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 12                	js     801a3f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	ff 75 10             	pushl  0x10(%ebp)
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	50                   	push   %eax
  801a37:	e8 59 01 00 00       	call   801b95 <nsipc_connect>
  801a3c:	83 c4 10             	add    $0x10,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <listen>:
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	e8 b0 fe ff ff       	call   8018ff <fd2sockid>
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	78 0f                	js     801a62 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a53:	83 ec 08             	sub    $0x8,%esp
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	50                   	push   %eax
  801a5a:	e8 6b 01 00 00       	call   801bca <nsipc_listen>
  801a5f:	83 c4 10             	add    $0x10,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a6a:	ff 75 10             	pushl  0x10(%ebp)
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 3e 02 00 00       	call   801cb6 <nsipc_socket>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 05                	js     801a84 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a7f:	e8 ab fe ff ff       	call   80192f <alloc_sockfd>
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a8f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a96:	74 26                	je     801abe <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a98:	6a 07                	push   $0x7
  801a9a:	68 00 60 80 00       	push   $0x806000
  801a9f:	53                   	push   %ebx
  801aa0:	ff 35 04 40 80 00    	pushl  0x804004
  801aa6:	e8 c2 07 00 00       	call   80226d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aab:	83 c4 0c             	add    $0xc,%esp
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	e8 4b 07 00 00       	call   802204 <ipc_recv>
}
  801ab9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801abe:	83 ec 0c             	sub    $0xc,%esp
  801ac1:	6a 02                	push   $0x2
  801ac3:	e8 fd 07 00 00       	call   8022c5 <ipc_find_env>
  801ac8:	a3 04 40 80 00       	mov    %eax,0x804004
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	eb c6                	jmp    801a98 <nsipc+0x12>

00801ad2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	56                   	push   %esi
  801ad6:	53                   	push   %ebx
  801ad7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ae2:	8b 06                	mov    (%esi),%eax
  801ae4:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aee:	e8 93 ff ff ff       	call   801a86 <nsipc>
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	85 c0                	test   %eax,%eax
  801af7:	79 09                	jns    801b02 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801af9:	89 d8                	mov    %ebx,%eax
  801afb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5d                   	pop    %ebp
  801b01:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	ff 35 10 60 80 00    	pushl  0x806010
  801b0b:	68 00 60 80 00       	push   $0x806000
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	e8 dc ef ff ff       	call   800af4 <memmove>
		*addrlen = ret->ret_addrlen;
  801b18:	a1 10 60 80 00       	mov    0x806010,%eax
  801b1d:	89 06                	mov    %eax,(%esi)
  801b1f:	83 c4 10             	add    $0x10,%esp
	return r;
  801b22:	eb d5                	jmp    801af9 <nsipc_accept+0x27>

00801b24 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	53                   	push   %ebx
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b36:	53                   	push   %ebx
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	68 04 60 80 00       	push   $0x806004
  801b3f:	e8 b0 ef ff ff       	call   800af4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b44:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b4a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b4f:	e8 32 ff ff ff       	call   801a86 <nsipc>
}
  801b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b6f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b74:	e8 0d ff ff ff       	call   801a86 <nsipc>
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <nsipc_close>:

int
nsipc_close(int s)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b89:	b8 04 00 00 00       	mov    $0x4,%eax
  801b8e:	e8 f3 fe ff ff       	call   801a86 <nsipc>
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	53                   	push   %ebx
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ba7:	53                   	push   %ebx
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	68 04 60 80 00       	push   $0x806004
  801bb0:	e8 3f ef ff ff       	call   800af4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bb5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bbb:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc0:	e8 c1 fe ff ff       	call   801a86 <nsipc>
}
  801bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801be0:	b8 06 00 00 00       	mov    $0x6,%eax
  801be5:	e8 9c fe ff ff       	call   801a86 <nsipc>
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bfc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c02:	8b 45 14             	mov    0x14(%ebp),%eax
  801c05:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c0a:	b8 07 00 00 00       	mov    $0x7,%eax
  801c0f:	e8 72 fe ff ff       	call   801a86 <nsipc>
  801c14:	89 c3                	mov    %eax,%ebx
  801c16:	85 c0                	test   %eax,%eax
  801c18:	78 1f                	js     801c39 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c1a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c1f:	7f 21                	jg     801c42 <nsipc_recv+0x56>
  801c21:	39 c6                	cmp    %eax,%esi
  801c23:	7c 1d                	jl     801c42 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	50                   	push   %eax
  801c29:	68 00 60 80 00       	push   $0x806000
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	e8 be ee ff ff       	call   800af4 <memmove>
  801c36:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c39:	89 d8                	mov    %ebx,%eax
  801c3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5e                   	pop    %esi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c42:	68 83 2a 80 00       	push   $0x802a83
  801c47:	68 4b 2a 80 00       	push   $0x802a4b
  801c4c:	6a 62                	push   $0x62
  801c4e:	68 98 2a 80 00       	push   $0x802a98
  801c53:	e8 4b 05 00 00       	call   8021a3 <_panic>

00801c58 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	53                   	push   %ebx
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c6a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c70:	7f 2e                	jg     801ca0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	53                   	push   %ebx
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	68 0c 60 80 00       	push   $0x80600c
  801c7e:	e8 71 ee ff ff       	call   800af4 <memmove>
	nsipcbuf.send.req_size = size;
  801c83:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c89:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c91:	b8 08 00 00 00       	mov    $0x8,%eax
  801c96:	e8 eb fd ff ff       	call   801a86 <nsipc>
}
  801c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    
	assert(size < 1600);
  801ca0:	68 a4 2a 80 00       	push   $0x802aa4
  801ca5:	68 4b 2a 80 00       	push   $0x802a4b
  801caa:	6a 6d                	push   $0x6d
  801cac:	68 98 2a 80 00       	push   $0x802a98
  801cb1:	e8 ed 04 00 00       	call   8021a3 <_panic>

00801cb6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cd4:	b8 09 00 00 00       	mov    $0x9,%eax
  801cd9:	e8 a8 fd ff ff       	call   801a86 <nsipc>
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	56                   	push   %esi
  801ce4:	53                   	push   %ebx
  801ce5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	ff 75 08             	pushl  0x8(%ebp)
  801cee:	e8 6a f3 ff ff       	call   80105d <fd2data>
  801cf3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf5:	83 c4 08             	add    $0x8,%esp
  801cf8:	68 b0 2a 80 00       	push   $0x802ab0
  801cfd:	53                   	push   %ebx
  801cfe:	e8 63 ec ff ff       	call   800966 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d03:	8b 46 04             	mov    0x4(%esi),%eax
  801d06:	2b 06                	sub    (%esi),%eax
  801d08:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d0e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d15:	00 00 00 
	stat->st_dev = &devpipe;
  801d18:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d1f:	30 80 00 
	return 0;
}
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
  801d27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2a:	5b                   	pop    %ebx
  801d2b:	5e                   	pop    %esi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	53                   	push   %ebx
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d38:	53                   	push   %ebx
  801d39:	6a 00                	push   $0x0
  801d3b:	e8 9d f0 ff ff       	call   800ddd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d40:	89 1c 24             	mov    %ebx,(%esp)
  801d43:	e8 15 f3 ff ff       	call   80105d <fd2data>
  801d48:	83 c4 08             	add    $0x8,%esp
  801d4b:	50                   	push   %eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	e8 8a f0 ff ff       	call   800ddd <sys_page_unmap>
}
  801d53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <_pipeisclosed>:
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	57                   	push   %edi
  801d5c:	56                   	push   %esi
  801d5d:	53                   	push   %ebx
  801d5e:	83 ec 1c             	sub    $0x1c,%esp
  801d61:	89 c7                	mov    %eax,%edi
  801d63:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d65:	a1 08 40 80 00       	mov    0x804008,%eax
  801d6a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d6d:	83 ec 0c             	sub    $0xc,%esp
  801d70:	57                   	push   %edi
  801d71:	e8 8a 05 00 00       	call   802300 <pageref>
  801d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d79:	89 34 24             	mov    %esi,(%esp)
  801d7c:	e8 7f 05 00 00       	call   802300 <pageref>
		nn = thisenv->env_runs;
  801d81:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d87:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	39 cb                	cmp    %ecx,%ebx
  801d8f:	74 1b                	je     801dac <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d94:	75 cf                	jne    801d65 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d96:	8b 42 58             	mov    0x58(%edx),%eax
  801d99:	6a 01                	push   $0x1
  801d9b:	50                   	push   %eax
  801d9c:	53                   	push   %ebx
  801d9d:	68 b7 2a 80 00       	push   $0x802ab7
  801da2:	e8 60 e4 ff ff       	call   800207 <cprintf>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	eb b9                	jmp    801d65 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dac:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801daf:	0f 94 c0             	sete   %al
  801db2:	0f b6 c0             	movzbl %al,%eax
}
  801db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <devpipe_write>:
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	57                   	push   %edi
  801dc1:	56                   	push   %esi
  801dc2:	53                   	push   %ebx
  801dc3:	83 ec 28             	sub    $0x28,%esp
  801dc6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dc9:	56                   	push   %esi
  801dca:	e8 8e f2 ff ff       	call   80105d <fd2data>
  801dcf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ddc:	74 4f                	je     801e2d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dde:	8b 43 04             	mov    0x4(%ebx),%eax
  801de1:	8b 0b                	mov    (%ebx),%ecx
  801de3:	8d 51 20             	lea    0x20(%ecx),%edx
  801de6:	39 d0                	cmp    %edx,%eax
  801de8:	72 14                	jb     801dfe <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dea:	89 da                	mov    %ebx,%edx
  801dec:	89 f0                	mov    %esi,%eax
  801dee:	e8 65 ff ff ff       	call   801d58 <_pipeisclosed>
  801df3:	85 c0                	test   %eax,%eax
  801df5:	75 3b                	jne    801e32 <devpipe_write+0x75>
			sys_yield();
  801df7:	e8 3d ef ff ff       	call   800d39 <sys_yield>
  801dfc:	eb e0                	jmp    801dde <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e01:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e05:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e08:	89 c2                	mov    %eax,%edx
  801e0a:	c1 fa 1f             	sar    $0x1f,%edx
  801e0d:	89 d1                	mov    %edx,%ecx
  801e0f:	c1 e9 1b             	shr    $0x1b,%ecx
  801e12:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e15:	83 e2 1f             	and    $0x1f,%edx
  801e18:	29 ca                	sub    %ecx,%edx
  801e1a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e1e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e22:	83 c0 01             	add    $0x1,%eax
  801e25:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e28:	83 c7 01             	add    $0x1,%edi
  801e2b:	eb ac                	jmp    801dd9 <devpipe_write+0x1c>
	return i;
  801e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e30:	eb 05                	jmp    801e37 <devpipe_write+0x7a>
				return 0;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <devpipe_read>:
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	57                   	push   %edi
  801e43:	56                   	push   %esi
  801e44:	53                   	push   %ebx
  801e45:	83 ec 18             	sub    $0x18,%esp
  801e48:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e4b:	57                   	push   %edi
  801e4c:	e8 0c f2 ff ff       	call   80105d <fd2data>
  801e51:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	be 00 00 00 00       	mov    $0x0,%esi
  801e5b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e5e:	75 14                	jne    801e74 <devpipe_read+0x35>
	return i;
  801e60:	8b 45 10             	mov    0x10(%ebp),%eax
  801e63:	eb 02                	jmp    801e67 <devpipe_read+0x28>
				return i;
  801e65:	89 f0                	mov    %esi,%eax
}
  801e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5f                   	pop    %edi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    
			sys_yield();
  801e6f:	e8 c5 ee ff ff       	call   800d39 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e74:	8b 03                	mov    (%ebx),%eax
  801e76:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e79:	75 18                	jne    801e93 <devpipe_read+0x54>
			if (i > 0)
  801e7b:	85 f6                	test   %esi,%esi
  801e7d:	75 e6                	jne    801e65 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e7f:	89 da                	mov    %ebx,%edx
  801e81:	89 f8                	mov    %edi,%eax
  801e83:	e8 d0 fe ff ff       	call   801d58 <_pipeisclosed>
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	74 e3                	je     801e6f <devpipe_read+0x30>
				return 0;
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e91:	eb d4                	jmp    801e67 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e93:	99                   	cltd   
  801e94:	c1 ea 1b             	shr    $0x1b,%edx
  801e97:	01 d0                	add    %edx,%eax
  801e99:	83 e0 1f             	and    $0x1f,%eax
  801e9c:	29 d0                	sub    %edx,%eax
  801e9e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ea9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eac:	83 c6 01             	add    $0x1,%esi
  801eaf:	eb aa                	jmp    801e5b <devpipe_read+0x1c>

00801eb1 <pipe>:
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	56                   	push   %esi
  801eb5:	53                   	push   %ebx
  801eb6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebc:	50                   	push   %eax
  801ebd:	e8 b2 f1 ff ff       	call   801074 <fd_alloc>
  801ec2:	89 c3                	mov    %eax,%ebx
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	0f 88 23 01 00 00    	js     801ff2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	68 07 04 00 00       	push   $0x407
  801ed7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eda:	6a 00                	push   $0x0
  801edc:	e8 77 ee ff ff       	call   800d58 <sys_page_alloc>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	0f 88 04 01 00 00    	js     801ff2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef4:	50                   	push   %eax
  801ef5:	e8 7a f1 ff ff       	call   801074 <fd_alloc>
  801efa:	89 c3                	mov    %eax,%ebx
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	85 c0                	test   %eax,%eax
  801f01:	0f 88 db 00 00 00    	js     801fe2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	68 07 04 00 00       	push   $0x407
  801f0f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f12:	6a 00                	push   $0x0
  801f14:	e8 3f ee ff ff       	call   800d58 <sys_page_alloc>
  801f19:	89 c3                	mov    %eax,%ebx
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	85 c0                	test   %eax,%eax
  801f20:	0f 88 bc 00 00 00    	js     801fe2 <pipe+0x131>
	va = fd2data(fd0);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2c:	e8 2c f1 ff ff       	call   80105d <fd2data>
  801f31:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f33:	83 c4 0c             	add    $0xc,%esp
  801f36:	68 07 04 00 00       	push   $0x407
  801f3b:	50                   	push   %eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	e8 15 ee ff ff       	call   800d58 <sys_page_alloc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	0f 88 82 00 00 00    	js     801fd2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 f0             	pushl  -0x10(%ebp)
  801f56:	e8 02 f1 ff ff       	call   80105d <fd2data>
  801f5b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f62:	50                   	push   %eax
  801f63:	6a 00                	push   $0x0
  801f65:	56                   	push   %esi
  801f66:	6a 00                	push   $0x0
  801f68:	e8 2e ee ff ff       	call   800d9b <sys_page_map>
  801f6d:	89 c3                	mov    %eax,%ebx
  801f6f:	83 c4 20             	add    $0x20,%esp
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 4e                	js     801fc4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f76:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f83:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9f:	e8 a9 f0 ff ff       	call   80104d <fd2num>
  801fa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa9:	83 c4 04             	add    $0x4,%esp
  801fac:	ff 75 f0             	pushl  -0x10(%ebp)
  801faf:	e8 99 f0 ff ff       	call   80104d <fd2num>
  801fb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc2:	eb 2e                	jmp    801ff2 <pipe+0x141>
	sys_page_unmap(0, va);
  801fc4:	83 ec 08             	sub    $0x8,%esp
  801fc7:	56                   	push   %esi
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 0e ee ff ff       	call   800ddd <sys_page_unmap>
  801fcf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd8:	6a 00                	push   $0x0
  801fda:	e8 fe ed ff ff       	call   800ddd <sys_page_unmap>
  801fdf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 ee ed ff ff       	call   800ddd <sys_page_unmap>
  801fef:	83 c4 10             	add    $0x10,%esp
}
  801ff2:	89 d8                	mov    %ebx,%eax
  801ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5d                   	pop    %ebp
  801ffa:	c3                   	ret    

00801ffb <pipeisclosed>:
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802001:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802004:	50                   	push   %eax
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	e8 b9 f0 ff ff       	call   8010c6 <fd_lookup>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	85 c0                	test   %eax,%eax
  802012:	78 18                	js     80202c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	ff 75 f4             	pushl  -0xc(%ebp)
  80201a:	e8 3e f0 ff ff       	call   80105d <fd2data>
	return _pipeisclosed(fd, p);
  80201f:	89 c2                	mov    %eax,%edx
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	e8 2f fd ff ff       	call   801d58 <_pipeisclosed>
  802029:	83 c4 10             	add    $0x10,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	c3                   	ret    

00802034 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80203a:	68 cf 2a 80 00       	push   $0x802acf
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	e8 1f e9 ff ff       	call   800966 <strcpy>
	return 0;
}
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <devcons_write>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80205a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80205f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802065:	3b 75 10             	cmp    0x10(%ebp),%esi
  802068:	73 31                	jae    80209b <devcons_write+0x4d>
		m = n - tot;
  80206a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80206d:	29 f3                	sub    %esi,%ebx
  80206f:	83 fb 7f             	cmp    $0x7f,%ebx
  802072:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802077:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	53                   	push   %ebx
  80207e:	89 f0                	mov    %esi,%eax
  802080:	03 45 0c             	add    0xc(%ebp),%eax
  802083:	50                   	push   %eax
  802084:	57                   	push   %edi
  802085:	e8 6a ea ff ff       	call   800af4 <memmove>
		sys_cputs(buf, m);
  80208a:	83 c4 08             	add    $0x8,%esp
  80208d:	53                   	push   %ebx
  80208e:	57                   	push   %edi
  80208f:	e8 08 ec ff ff       	call   800c9c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802094:	01 de                	add    %ebx,%esi
  802096:	83 c4 10             	add    $0x10,%esp
  802099:	eb ca                	jmp    802065 <devcons_write+0x17>
}
  80209b:	89 f0                	mov    %esi,%eax
  80209d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5f                   	pop    %edi
  8020a3:	5d                   	pop    %ebp
  8020a4:	c3                   	ret    

008020a5 <devcons_read>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 08             	sub    $0x8,%esp
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b4:	74 21                	je     8020d7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020b6:	e8 ff eb ff ff       	call   800cba <sys_cgetc>
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	75 07                	jne    8020c6 <devcons_read+0x21>
		sys_yield();
  8020bf:	e8 75 ec ff ff       	call   800d39 <sys_yield>
  8020c4:	eb f0                	jmp    8020b6 <devcons_read+0x11>
	if (c < 0)
  8020c6:	78 0f                	js     8020d7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020c8:	83 f8 04             	cmp    $0x4,%eax
  8020cb:	74 0c                	je     8020d9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	88 02                	mov    %al,(%edx)
	return 1;
  8020d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    
		return 0;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	eb f7                	jmp    8020d7 <devcons_read+0x32>

008020e0 <cputchar>:
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ec:	6a 01                	push   $0x1
  8020ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f1:	50                   	push   %eax
  8020f2:	e8 a5 eb ff ff       	call   800c9c <sys_cputs>
}
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <getchar>:
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802102:	6a 01                	push   $0x1
  802104:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	6a 00                	push   $0x0
  80210a:	e8 27 f2 ff ff       	call   801336 <read>
	if (r < 0)
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	85 c0                	test   %eax,%eax
  802114:	78 06                	js     80211c <getchar+0x20>
	if (r < 1)
  802116:	74 06                	je     80211e <getchar+0x22>
	return c;
  802118:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    
		return -E_EOF;
  80211e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802123:	eb f7                	jmp    80211c <getchar+0x20>

00802125 <iscons>:
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212e:	50                   	push   %eax
  80212f:	ff 75 08             	pushl  0x8(%ebp)
  802132:	e8 8f ef ff ff       	call   8010c6 <fd_lookup>
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	85 c0                	test   %eax,%eax
  80213c:	78 11                	js     80214f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802147:	39 10                	cmp    %edx,(%eax)
  802149:	0f 94 c0             	sete   %al
  80214c:	0f b6 c0             	movzbl %al,%eax
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <opencons>:
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802157:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215a:	50                   	push   %eax
  80215b:	e8 14 ef ff ff       	call   801074 <fd_alloc>
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	85 c0                	test   %eax,%eax
  802165:	78 3a                	js     8021a1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 07 04 00 00       	push   $0x407
  80216f:	ff 75 f4             	pushl  -0xc(%ebp)
  802172:	6a 00                	push   $0x0
  802174:	e8 df eb ff ff       	call   800d58 <sys_page_alloc>
  802179:	83 c4 10             	add    $0x10,%esp
  80217c:	85 c0                	test   %eax,%eax
  80217e:	78 21                	js     8021a1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802189:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	50                   	push   %eax
  802199:	e8 af ee ff ff       	call   80104d <fd2num>
  80219e:	83 c4 10             	add    $0x10,%esp
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ad:	8b 40 48             	mov    0x48(%eax),%eax
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	68 00 2b 80 00       	push   $0x802b00
  8021b8:	50                   	push   %eax
  8021b9:	68 f8 25 80 00       	push   $0x8025f8
  8021be:	e8 44 e0 ff ff       	call   800207 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021c3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021c6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021cc:	e8 49 eb ff ff       	call   800d1a <sys_getenvid>
  8021d1:	83 c4 04             	add    $0x4,%esp
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	56                   	push   %esi
  8021db:	50                   	push   %eax
  8021dc:	68 dc 2a 80 00       	push   $0x802adc
  8021e1:	e8 21 e0 ff ff       	call   800207 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021e6:	83 c4 18             	add    $0x18,%esp
  8021e9:	53                   	push   %ebx
  8021ea:	ff 75 10             	pushl  0x10(%ebp)
  8021ed:	e8 c4 df ff ff       	call   8001b6 <vcprintf>
	cprintf("\n");
  8021f2:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  8021f9:	e8 09 e0 ff ff       	call   800207 <cprintf>
  8021fe:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802201:	cc                   	int3   
  802202:	eb fd                	jmp    802201 <_panic+0x5e>

00802204 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	8b 75 08             	mov    0x8(%ebp),%esi
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802212:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802214:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802219:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	50                   	push   %eax
  802220:	e8 e3 ec ff ff       	call   800f08 <sys_ipc_recv>
	if(ret < 0){
  802225:	83 c4 10             	add    $0x10,%esp
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 2b                	js     802257 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80222c:	85 f6                	test   %esi,%esi
  80222e:	74 0a                	je     80223a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802230:	a1 08 40 80 00       	mov    0x804008,%eax
  802235:	8b 40 74             	mov    0x74(%eax),%eax
  802238:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80223a:	85 db                	test   %ebx,%ebx
  80223c:	74 0a                	je     802248 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80223e:	a1 08 40 80 00       	mov    0x804008,%eax
  802243:	8b 40 78             	mov    0x78(%eax),%eax
  802246:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802248:	a1 08 40 80 00       	mov    0x804008,%eax
  80224d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802250:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802253:	5b                   	pop    %ebx
  802254:	5e                   	pop    %esi
  802255:	5d                   	pop    %ebp
  802256:	c3                   	ret    
		if(from_env_store)
  802257:	85 f6                	test   %esi,%esi
  802259:	74 06                	je     802261 <ipc_recv+0x5d>
			*from_env_store = 0;
  80225b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802261:	85 db                	test   %ebx,%ebx
  802263:	74 eb                	je     802250 <ipc_recv+0x4c>
			*perm_store = 0;
  802265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80226b:	eb e3                	jmp    802250 <ipc_recv+0x4c>

0080226d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	57                   	push   %edi
  802271:	56                   	push   %esi
  802272:	53                   	push   %ebx
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	8b 7d 08             	mov    0x8(%ebp),%edi
  802279:	8b 75 0c             	mov    0xc(%ebp),%esi
  80227c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80227f:	85 db                	test   %ebx,%ebx
  802281:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802286:	0f 44 d8             	cmove  %eax,%ebx
  802289:	eb 05                	jmp    802290 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80228b:	e8 a9 ea ff ff       	call   800d39 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802290:	ff 75 14             	pushl  0x14(%ebp)
  802293:	53                   	push   %ebx
  802294:	56                   	push   %esi
  802295:	57                   	push   %edi
  802296:	e8 4a ec ff ff       	call   800ee5 <sys_ipc_try_send>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 1b                	je     8022bd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022a2:	79 e7                	jns    80228b <ipc_send+0x1e>
  8022a4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a7:	74 e2                	je     80228b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 07 2b 80 00       	push   $0x802b07
  8022b1:	6a 46                	push   $0x46
  8022b3:	68 1c 2b 80 00       	push   $0x802b1c
  8022b8:	e8 e6 fe ff ff       	call   8021a3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022d0:	89 c2                	mov    %eax,%edx
  8022d2:	c1 e2 07             	shl    $0x7,%edx
  8022d5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022db:	8b 52 50             	mov    0x50(%edx),%edx
  8022de:	39 ca                	cmp    %ecx,%edx
  8022e0:	74 11                	je     8022f3 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022e2:	83 c0 01             	add    $0x1,%eax
  8022e5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ea:	75 e4                	jne    8022d0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f1:	eb 0b                	jmp    8022fe <ipc_find_env+0x39>
			return envs[i].env_id;
  8022f3:	c1 e0 07             	shl    $0x7,%eax
  8022f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802306:	89 d0                	mov    %edx,%eax
  802308:	c1 e8 16             	shr    $0x16,%eax
  80230b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802317:	f6 c1 01             	test   $0x1,%cl
  80231a:	74 1d                	je     802339 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80231c:	c1 ea 0c             	shr    $0xc,%edx
  80231f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802326:	f6 c2 01             	test   $0x1,%dl
  802329:	74 0e                	je     802339 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80232b:	c1 ea 0c             	shr    $0xc,%edx
  80232e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802335:	ef 
  802336:	0f b7 c0             	movzwl %ax,%eax
}
  802339:	5d                   	pop    %ebp
  80233a:	c3                   	ret    
  80233b:	66 90                	xchg   %ax,%ax
  80233d:	66 90                	xchg   %ax,%ax
  80233f:	90                   	nop

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80234b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802357:	85 d2                	test   %edx,%edx
  802359:	75 4d                	jne    8023a8 <__udivdi3+0x68>
  80235b:	39 f3                	cmp    %esi,%ebx
  80235d:	76 19                	jbe    802378 <__udivdi3+0x38>
  80235f:	31 ff                	xor    %edi,%edi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f2                	mov    %esi,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 d9                	mov    %ebx,%ecx
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	75 0b                	jne    802389 <__udivdi3+0x49>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 c1                	mov    %eax,%ecx
  802389:	31 d2                	xor    %edx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	f7 f1                	div    %ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f7                	mov    %esi,%edi
  802395:	f7 f1                	div    %ecx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 f2                	cmp    %esi,%edx
  8023aa:	77 1c                	ja     8023c8 <__udivdi3+0x88>
  8023ac:	0f bd fa             	bsr    %edx,%edi
  8023af:	83 f7 1f             	xor    $0x1f,%edi
  8023b2:	75 2c                	jne    8023e0 <__udivdi3+0xa0>
  8023b4:	39 f2                	cmp    %esi,%edx
  8023b6:	72 06                	jb     8023be <__udivdi3+0x7e>
  8023b8:	31 c0                	xor    %eax,%eax
  8023ba:	39 eb                	cmp    %ebp,%ebx
  8023bc:	77 a9                	ja     802367 <__udivdi3+0x27>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	eb a2                	jmp    802367 <__udivdi3+0x27>
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	31 c0                	xor    %eax,%eax
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 f9                	mov    %edi,%ecx
  8023e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e7:	29 f8                	sub    %edi,%eax
  8023e9:	d3 e2                	shl    %cl,%edx
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	d3 ea                	shr    %cl,%edx
  8023f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f9:	09 d1                	or     %edx,%ecx
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e3                	shl    %cl,%ebx
  802405:	89 c1                	mov    %eax,%ecx
  802407:	d3 ea                	shr    %cl,%edx
  802409:	89 f9                	mov    %edi,%ecx
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	89 eb                	mov    %ebp,%ebx
  802411:	d3 e6                	shl    %cl,%esi
  802413:	89 c1                	mov    %eax,%ecx
  802415:	d3 eb                	shr    %cl,%ebx
  802417:	09 de                	or     %ebx,%esi
  802419:	89 f0                	mov    %esi,%eax
  80241b:	f7 74 24 08          	divl   0x8(%esp)
  80241f:	89 d6                	mov    %edx,%esi
  802421:	89 c3                	mov    %eax,%ebx
  802423:	f7 64 24 0c          	mull   0xc(%esp)
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 15                	jb     802440 <__udivdi3+0x100>
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e5                	shl    %cl,%ebp
  80242f:	39 c5                	cmp    %eax,%ebp
  802431:	73 04                	jae    802437 <__udivdi3+0xf7>
  802433:	39 d6                	cmp    %edx,%esi
  802435:	74 09                	je     802440 <__udivdi3+0x100>
  802437:	89 d8                	mov    %ebx,%eax
  802439:	31 ff                	xor    %edi,%edi
  80243b:	e9 27 ff ff ff       	jmp    802367 <__udivdi3+0x27>
  802440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 1d ff ff ff       	jmp    802367 <__udivdi3+0x27>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	89 da                	mov    %ebx,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 43                	jne    8024b0 <__umoddi3+0x60>
  80246d:	39 df                	cmp    %ebx,%edi
  80246f:	76 17                	jbe    802488 <__umoddi3+0x38>
  802471:	89 f0                	mov    %esi,%eax
  802473:	f7 f7                	div    %edi
  802475:	89 d0                	mov    %edx,%eax
  802477:	31 d2                	xor    %edx,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 f0                	mov    %esi,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	eb d0                	jmp    802477 <__umoddi3+0x27>
  8024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	89 f1                	mov    %esi,%ecx
  8024b2:	39 d8                	cmp    %ebx,%eax
  8024b4:	76 0a                	jbe    8024c0 <__umoddi3+0x70>
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	0f bd e8             	bsr    %eax,%ebp
  8024c3:	83 f5 1f             	xor    $0x1f,%ebp
  8024c6:	75 20                	jne    8024e8 <__umoddi3+0x98>
  8024c8:	39 d8                	cmp    %ebx,%eax
  8024ca:	0f 82 b0 00 00 00    	jb     802580 <__umoddi3+0x130>
  8024d0:	39 f7                	cmp    %esi,%edi
  8024d2:	0f 86 a8 00 00 00    	jbe    802580 <__umoddi3+0x130>
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0xfb>
  802545:	75 10                	jne    802557 <__umoddi3+0x107>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x107>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 da                	mov    %ebx,%edx
  802582:	29 fe                	sub    %edi,%esi
  802584:	19 c2                	sbb    %eax,%edx
  802586:	89 f1                	mov    %esi,%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	e9 4b ff ff ff       	jmp    8024da <__umoddi3+0x8a>
