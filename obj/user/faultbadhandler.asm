
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
  8000e8:	68 80 25 80 00       	push   $0x802580
  8000ed:	e8 15 01 00 00       	call   800207 <cprintf>
	cprintf("before umain\n");
  8000f2:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000f9:	e8 09 01 00 00       	call   800207 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000fe:	83 c4 08             	add    $0x8,%esp
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	ff 75 08             	pushl  0x8(%ebp)
  800107:	e8 27 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80010c:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  800113:	e8 ef 00 00 00       	call   800207 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800118:	a1 08 40 80 00       	mov    0x804008,%eax
  80011d:	8b 40 48             	mov    0x48(%eax),%eax
  800120:	83 c4 08             	add    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 b9 25 80 00       	push   $0x8025b9
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
  80014c:	68 e4 25 80 00       	push   $0x8025e4
  800151:	50                   	push   %eax
  800152:	68 d8 25 80 00       	push   $0x8025d8
  800157:	e8 ab 00 00 00       	call   800207 <cprintf>
	close_all();
  80015c:	e8 a4 10 00 00       	call   801205 <close_all>
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
  8002b4:	e8 67 20 00 00       	call   802320 <__udivdi3>
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
  8002dd:	e8 4e 21 00 00       	call   802430 <__umoddi3>
  8002e2:	83 c4 14             	add    $0x14,%esp
  8002e5:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
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
  80038e:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
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
  800459:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800460:	85 d2                	test   %edx,%edx
  800462:	74 18                	je     80047c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800464:	52                   	push   %edx
  800465:	68 3d 2a 80 00       	push   $0x802a3d
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 a6 fe ff ff       	call   800317 <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
  800477:	e9 fe 02 00 00       	jmp    80077a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80047c:	50                   	push   %eax
  80047d:	68 01 26 80 00       	push   $0x802601
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
  8004a4:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
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
  80083c:	bf 1d 27 80 00       	mov    $0x80271d,%edi
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
  800868:	bf 55 27 80 00       	mov    $0x802755,%edi
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
  800d09:	68 68 29 80 00       	push   $0x802968
  800d0e:	6a 43                	push   $0x43
  800d10:	68 85 29 80 00       	push   $0x802985
  800d15:	e8 69 14 00 00       	call   802183 <_panic>

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
  800d8a:	68 68 29 80 00       	push   $0x802968
  800d8f:	6a 43                	push   $0x43
  800d91:	68 85 29 80 00       	push   $0x802985
  800d96:	e8 e8 13 00 00       	call   802183 <_panic>

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
  800dcc:	68 68 29 80 00       	push   $0x802968
  800dd1:	6a 43                	push   $0x43
  800dd3:	68 85 29 80 00       	push   $0x802985
  800dd8:	e8 a6 13 00 00       	call   802183 <_panic>

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
  800e0e:	68 68 29 80 00       	push   $0x802968
  800e13:	6a 43                	push   $0x43
  800e15:	68 85 29 80 00       	push   $0x802985
  800e1a:	e8 64 13 00 00       	call   802183 <_panic>

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
  800e50:	68 68 29 80 00       	push   $0x802968
  800e55:	6a 43                	push   $0x43
  800e57:	68 85 29 80 00       	push   $0x802985
  800e5c:	e8 22 13 00 00       	call   802183 <_panic>

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
  800e92:	68 68 29 80 00       	push   $0x802968
  800e97:	6a 43                	push   $0x43
  800e99:	68 85 29 80 00       	push   $0x802985
  800e9e:	e8 e0 12 00 00       	call   802183 <_panic>

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
  800ed4:	68 68 29 80 00       	push   $0x802968
  800ed9:	6a 43                	push   $0x43
  800edb:	68 85 29 80 00       	push   $0x802985
  800ee0:	e8 9e 12 00 00       	call   802183 <_panic>

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
  800f38:	68 68 29 80 00       	push   $0x802968
  800f3d:	6a 43                	push   $0x43
  800f3f:	68 85 29 80 00       	push   $0x802985
  800f44:	e8 3a 12 00 00       	call   802183 <_panic>

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
  80101c:	68 68 29 80 00       	push   $0x802968
  801021:	6a 43                	push   $0x43
  801023:	68 85 29 80 00       	push   $0x802985
  801028:	e8 56 11 00 00       	call   802183 <_panic>

0080102d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	05 00 00 00 30       	add    $0x30000000,%eax
  801038:	c1 e8 0c             	shr    $0xc,%eax
}
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801048:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80105c:	89 c2                	mov    %eax,%edx
  80105e:	c1 ea 16             	shr    $0x16,%edx
  801061:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801068:	f6 c2 01             	test   $0x1,%dl
  80106b:	74 2d                	je     80109a <fd_alloc+0x46>
  80106d:	89 c2                	mov    %eax,%edx
  80106f:	c1 ea 0c             	shr    $0xc,%edx
  801072:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801079:	f6 c2 01             	test   $0x1,%dl
  80107c:	74 1c                	je     80109a <fd_alloc+0x46>
  80107e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801083:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801088:	75 d2                	jne    80105c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801093:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801098:	eb 0a                	jmp    8010a4 <fd_alloc+0x50>
			*fd_store = fd;
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ac:	83 f8 1f             	cmp    $0x1f,%eax
  8010af:	77 30                	ja     8010e1 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b1:	c1 e0 0c             	shl    $0xc,%eax
  8010b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	74 24                	je     8010e8 <fd_lookup+0x42>
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	c1 ea 0c             	shr    $0xc,%edx
  8010c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d0:	f6 c2 01             	test   $0x1,%dl
  8010d3:	74 1a                	je     8010ef <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
		return -E_INVAL;
  8010e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e6:	eb f7                	jmp    8010df <fd_lookup+0x39>
		return -E_INVAL;
  8010e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ed:	eb f0                	jmp    8010df <fd_lookup+0x39>
  8010ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f4:	eb e9                	jmp    8010df <fd_lookup+0x39>

008010f6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801104:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801109:	39 08                	cmp    %ecx,(%eax)
  80110b:	74 38                	je     801145 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80110d:	83 c2 01             	add    $0x1,%edx
  801110:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801117:	85 c0                	test   %eax,%eax
  801119:	75 ee                	jne    801109 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80111b:	a1 08 40 80 00       	mov    0x804008,%eax
  801120:	8b 40 48             	mov    0x48(%eax),%eax
  801123:	83 ec 04             	sub    $0x4,%esp
  801126:	51                   	push   %ecx
  801127:	50                   	push   %eax
  801128:	68 94 29 80 00       	push   $0x802994
  80112d:	e8 d5 f0 ff ff       	call   800207 <cprintf>
	*dev = 0;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    
			*dev = devtab[i];
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114a:	b8 00 00 00 00       	mov    $0x0,%eax
  80114f:	eb f2                	jmp    801143 <dev_lookup+0x4d>

00801151 <fd_close>:
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 24             	sub    $0x24,%esp
  80115a:	8b 75 08             	mov    0x8(%ebp),%esi
  80115d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801160:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801163:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801164:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80116a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80116d:	50                   	push   %eax
  80116e:	e8 33 ff ff ff       	call   8010a6 <fd_lookup>
  801173:	89 c3                	mov    %eax,%ebx
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	78 05                	js     801181 <fd_close+0x30>
	    || fd != fd2)
  80117c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80117f:	74 16                	je     801197 <fd_close+0x46>
		return (must_exist ? r : 0);
  801181:	89 f8                	mov    %edi,%eax
  801183:	84 c0                	test   %al,%al
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	0f 44 d8             	cmove  %eax,%ebx
}
  80118d:	89 d8                	mov    %ebx,%eax
  80118f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801197:	83 ec 08             	sub    $0x8,%esp
  80119a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80119d:	50                   	push   %eax
  80119e:	ff 36                	pushl  (%esi)
  8011a0:	e8 51 ff ff ff       	call   8010f6 <dev_lookup>
  8011a5:	89 c3                	mov    %eax,%ebx
  8011a7:	83 c4 10             	add    $0x10,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	78 1a                	js     8011c8 <fd_close+0x77>
		if (dev->dev_close)
  8011ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011b4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	74 0b                	je     8011c8 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	56                   	push   %esi
  8011c1:	ff d0                	call   *%eax
  8011c3:	89 c3                	mov    %eax,%ebx
  8011c5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	56                   	push   %esi
  8011cc:	6a 00                	push   $0x0
  8011ce:	e8 0a fc ff ff       	call   800ddd <sys_page_unmap>
	return r;
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	eb b5                	jmp    80118d <fd_close+0x3c>

008011d8 <close>:

int
close(int fdnum)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	e8 bc fe ff ff       	call   8010a6 <fd_lookup>
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	79 02                	jns    8011f3 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    
		return fd_close(fd, 1);
  8011f3:	83 ec 08             	sub    $0x8,%esp
  8011f6:	6a 01                	push   $0x1
  8011f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fb:	e8 51 ff ff ff       	call   801151 <fd_close>
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	eb ec                	jmp    8011f1 <close+0x19>

00801205 <close_all>:

void
close_all(void)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	53                   	push   %ebx
  801209:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80120c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	53                   	push   %ebx
  801215:	e8 be ff ff ff       	call   8011d8 <close>
	for (i = 0; i < MAXFD; i++)
  80121a:	83 c3 01             	add    $0x1,%ebx
  80121d:	83 c4 10             	add    $0x10,%esp
  801220:	83 fb 20             	cmp    $0x20,%ebx
  801223:	75 ec                	jne    801211 <close_all+0xc>
}
  801225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
  801230:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801233:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	ff 75 08             	pushl  0x8(%ebp)
  80123a:	e8 67 fe ff ff       	call   8010a6 <fd_lookup>
  80123f:	89 c3                	mov    %eax,%ebx
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	0f 88 81 00 00 00    	js     8012cd <dup+0xa3>
		return r;
	close(newfdnum);
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	ff 75 0c             	pushl  0xc(%ebp)
  801252:	e8 81 ff ff ff       	call   8011d8 <close>

	newfd = INDEX2FD(newfdnum);
  801257:	8b 75 0c             	mov    0xc(%ebp),%esi
  80125a:	c1 e6 0c             	shl    $0xc,%esi
  80125d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801263:	83 c4 04             	add    $0x4,%esp
  801266:	ff 75 e4             	pushl  -0x1c(%ebp)
  801269:	e8 cf fd ff ff       	call   80103d <fd2data>
  80126e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801270:	89 34 24             	mov    %esi,(%esp)
  801273:	e8 c5 fd ff ff       	call   80103d <fd2data>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80127d:	89 d8                	mov    %ebx,%eax
  80127f:	c1 e8 16             	shr    $0x16,%eax
  801282:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801289:	a8 01                	test   $0x1,%al
  80128b:	74 11                	je     80129e <dup+0x74>
  80128d:	89 d8                	mov    %ebx,%eax
  80128f:	c1 e8 0c             	shr    $0xc,%eax
  801292:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801299:	f6 c2 01             	test   $0x1,%dl
  80129c:	75 39                	jne    8012d7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80129e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a1:	89 d0                	mov    %edx,%eax
  8012a3:	c1 e8 0c             	shr    $0xc,%eax
  8012a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b5:	50                   	push   %eax
  8012b6:	56                   	push   %esi
  8012b7:	6a 00                	push   $0x0
  8012b9:	52                   	push   %edx
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 da fa ff ff       	call   800d9b <sys_page_map>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 20             	add    $0x20,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	78 31                	js     8012fb <dup+0xd1>
		goto err;

	return newfdnum;
  8012ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012cd:	89 d8                	mov    %ebx,%eax
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e6:	50                   	push   %eax
  8012e7:	57                   	push   %edi
  8012e8:	6a 00                	push   $0x0
  8012ea:	53                   	push   %ebx
  8012eb:	6a 00                	push   $0x0
  8012ed:	e8 a9 fa ff ff       	call   800d9b <sys_page_map>
  8012f2:	89 c3                	mov    %eax,%ebx
  8012f4:	83 c4 20             	add    $0x20,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	79 a3                	jns    80129e <dup+0x74>
	sys_page_unmap(0, newfd);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	56                   	push   %esi
  8012ff:	6a 00                	push   $0x0
  801301:	e8 d7 fa ff ff       	call   800ddd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	57                   	push   %edi
  80130a:	6a 00                	push   $0x0
  80130c:	e8 cc fa ff ff       	call   800ddd <sys_page_unmap>
	return r;
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	eb b7                	jmp    8012cd <dup+0xa3>

00801316 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	53                   	push   %ebx
  80131a:	83 ec 1c             	sub    $0x1c,%esp
  80131d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801320:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801323:	50                   	push   %eax
  801324:	53                   	push   %ebx
  801325:	e8 7c fd ff ff       	call   8010a6 <fd_lookup>
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 3f                	js     801370 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801331:	83 ec 08             	sub    $0x8,%esp
  801334:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801337:	50                   	push   %eax
  801338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133b:	ff 30                	pushl  (%eax)
  80133d:	e8 b4 fd ff ff       	call   8010f6 <dev_lookup>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 27                	js     801370 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134c:	8b 42 08             	mov    0x8(%edx),%eax
  80134f:	83 e0 03             	and    $0x3,%eax
  801352:	83 f8 01             	cmp    $0x1,%eax
  801355:	74 1e                	je     801375 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	8b 40 08             	mov    0x8(%eax),%eax
  80135d:	85 c0                	test   %eax,%eax
  80135f:	74 35                	je     801396 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	ff 75 10             	pushl  0x10(%ebp)
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	52                   	push   %edx
  80136b:	ff d0                	call   *%eax
  80136d:	83 c4 10             	add    $0x10,%esp
}
  801370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801373:	c9                   	leave  
  801374:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801375:	a1 08 40 80 00       	mov    0x804008,%eax
  80137a:	8b 40 48             	mov    0x48(%eax),%eax
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	53                   	push   %ebx
  801381:	50                   	push   %eax
  801382:	68 d5 29 80 00       	push   $0x8029d5
  801387:	e8 7b ee ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801394:	eb da                	jmp    801370 <read+0x5a>
		return -E_NOT_SUPP;
  801396:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139b:	eb d3                	jmp    801370 <read+0x5a>

0080139d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b1:	39 f3                	cmp    %esi,%ebx
  8013b3:	73 23                	jae    8013d8 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	89 f0                	mov    %esi,%eax
  8013ba:	29 d8                	sub    %ebx,%eax
  8013bc:	50                   	push   %eax
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	03 45 0c             	add    0xc(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	57                   	push   %edi
  8013c4:	e8 4d ff ff ff       	call   801316 <read>
		if (m < 0)
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 06                	js     8013d6 <readn+0x39>
			return m;
		if (m == 0)
  8013d0:	74 06                	je     8013d8 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013d2:	01 c3                	add    %eax,%ebx
  8013d4:	eb db                	jmp    8013b1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d6:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d8:	89 d8                	mov    %ebx,%eax
  8013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dd:	5b                   	pop    %ebx
  8013de:	5e                   	pop    %esi
  8013df:	5f                   	pop    %edi
  8013e0:	5d                   	pop    %ebp
  8013e1:	c3                   	ret    

008013e2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 1c             	sub    $0x1c,%esp
  8013e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	53                   	push   %ebx
  8013f1:	e8 b0 fc ff ff       	call   8010a6 <fd_lookup>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 3a                	js     801437 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	ff 30                	pushl  (%eax)
  801409:	e8 e8 fc ff ff       	call   8010f6 <dev_lookup>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 22                	js     801437 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801418:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141c:	74 1e                	je     80143c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 52 0c             	mov    0xc(%edx),%edx
  801424:	85 d2                	test   %edx,%edx
  801426:	74 35                	je     80145d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	ff 75 10             	pushl  0x10(%ebp)
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	50                   	push   %eax
  801432:	ff d2                	call   *%edx
  801434:	83 c4 10             	add    $0x10,%esp
}
  801437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80143c:	a1 08 40 80 00       	mov    0x804008,%eax
  801441:	8b 40 48             	mov    0x48(%eax),%eax
  801444:	83 ec 04             	sub    $0x4,%esp
  801447:	53                   	push   %ebx
  801448:	50                   	push   %eax
  801449:	68 f1 29 80 00       	push   $0x8029f1
  80144e:	e8 b4 ed ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145b:	eb da                	jmp    801437 <write+0x55>
		return -E_NOT_SUPP;
  80145d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801462:	eb d3                	jmp    801437 <write+0x55>

00801464 <seek>:

int
seek(int fdnum, off_t offset)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 30 fc ff ff       	call   8010a6 <fd_lookup>
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 0e                	js     80148b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80147d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	53                   	push   %ebx
  801491:	83 ec 1c             	sub    $0x1c,%esp
  801494:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801497:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	53                   	push   %ebx
  80149c:	e8 05 fc ff ff       	call   8010a6 <fd_lookup>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 37                	js     8014df <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	50                   	push   %eax
  8014af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b2:	ff 30                	pushl  (%eax)
  8014b4:	e8 3d fc ff ff       	call   8010f6 <dev_lookup>
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 1f                	js     8014df <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c7:	74 1b                	je     8014e4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	8b 52 18             	mov    0x18(%edx),%edx
  8014cf:	85 d2                	test   %edx,%edx
  8014d1:	74 32                	je     801505 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	50                   	push   %eax
  8014da:	ff d2                	call   *%edx
  8014dc:	83 c4 10             	add    $0x10,%esp
}
  8014df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e9:	8b 40 48             	mov    0x48(%eax),%eax
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	50                   	push   %eax
  8014f1:	68 b4 29 80 00       	push   $0x8029b4
  8014f6:	e8 0c ed ff ff       	call   800207 <cprintf>
		return -E_INVAL;
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801503:	eb da                	jmp    8014df <ftruncate+0x52>
		return -E_NOT_SUPP;
  801505:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150a:	eb d3                	jmp    8014df <ftruncate+0x52>

0080150c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 1c             	sub    $0x1c,%esp
  801513:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801519:	50                   	push   %eax
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 84 fb ff ff       	call   8010a6 <fd_lookup>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 4b                	js     801574 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801533:	ff 30                	pushl  (%eax)
  801535:	e8 bc fb ff ff       	call   8010f6 <dev_lookup>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 33                	js     801574 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801548:	74 2f                	je     801579 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80154a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80154d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801554:	00 00 00 
	stat->st_isdir = 0;
  801557:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80155e:	00 00 00 
	stat->st_dev = dev;
  801561:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	53                   	push   %ebx
  80156b:	ff 75 f0             	pushl  -0x10(%ebp)
  80156e:	ff 50 14             	call   *0x14(%eax)
  801571:	83 c4 10             	add    $0x10,%esp
}
  801574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801577:	c9                   	leave  
  801578:	c3                   	ret    
		return -E_NOT_SUPP;
  801579:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157e:	eb f4                	jmp    801574 <fstat+0x68>

00801580 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	56                   	push   %esi
  801584:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	6a 00                	push   $0x0
  80158a:	ff 75 08             	pushl  0x8(%ebp)
  80158d:	e8 22 02 00 00       	call   8017b4 <open>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	78 1b                	js     8015b6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	50                   	push   %eax
  8015a2:	e8 65 ff ff ff       	call   80150c <fstat>
  8015a7:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a9:	89 1c 24             	mov    %ebx,(%esp)
  8015ac:	e8 27 fc ff ff       	call   8011d8 <close>
	return r;
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 f3                	mov    %esi,%ebx
}
  8015b6:	89 d8                	mov    %ebx,%eax
  8015b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5e                   	pop    %esi
  8015bd:	5d                   	pop    %ebp
  8015be:	c3                   	ret    

008015bf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	56                   	push   %esi
  8015c3:	53                   	push   %ebx
  8015c4:	89 c6                	mov    %eax,%esi
  8015c6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015cf:	74 27                	je     8015f8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d1:	6a 07                	push   $0x7
  8015d3:	68 00 50 80 00       	push   $0x805000
  8015d8:	56                   	push   %esi
  8015d9:	ff 35 00 40 80 00    	pushl  0x804000
  8015df:	e8 69 0c 00 00       	call   80224d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e4:	83 c4 0c             	add    $0xc,%esp
  8015e7:	6a 00                	push   $0x0
  8015e9:	53                   	push   %ebx
  8015ea:	6a 00                	push   $0x0
  8015ec:	e8 f3 0b 00 00       	call   8021e4 <ipc_recv>
}
  8015f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	6a 01                	push   $0x1
  8015fd:	e8 a3 0c 00 00       	call   8022a5 <ipc_find_env>
  801602:	a3 00 40 80 00       	mov    %eax,0x804000
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	eb c5                	jmp    8015d1 <fsipc+0x12>

0080160c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	8b 40 0c             	mov    0xc(%eax),%eax
  801618:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80161d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801620:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	b8 02 00 00 00       	mov    $0x2,%eax
  80162f:	e8 8b ff ff ff       	call   8015bf <fsipc>
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <devfile_flush>:
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8b 40 0c             	mov    0xc(%eax),%eax
  801642:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	b8 06 00 00 00       	mov    $0x6,%eax
  801651:	e8 69 ff ff ff       	call   8015bf <fsipc>
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <devfile_stat>:
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
  80165c:	83 ec 04             	sub    $0x4,%esp
  80165f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8b 40 0c             	mov    0xc(%eax),%eax
  801668:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80166d:	ba 00 00 00 00       	mov    $0x0,%edx
  801672:	b8 05 00 00 00       	mov    $0x5,%eax
  801677:	e8 43 ff ff ff       	call   8015bf <fsipc>
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 2c                	js     8016ac <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801680:	83 ec 08             	sub    $0x8,%esp
  801683:	68 00 50 80 00       	push   $0x805000
  801688:	53                   	push   %ebx
  801689:	e8 d8 f2 ff ff       	call   800966 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80168e:	a1 80 50 80 00       	mov    0x805080,%eax
  801693:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801699:	a1 84 50 80 00       	mov    0x805084,%eax
  80169e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <devfile_write>:
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016c6:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016cc:	53                   	push   %ebx
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	68 08 50 80 00       	push   $0x805008
  8016d5:	e8 7c f4 ff ff       	call   800b56 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e4:	e8 d6 fe ff ff       	call   8015bf <fsipc>
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 0b                	js     8016fb <devfile_write+0x4a>
	assert(r <= n);
  8016f0:	39 d8                	cmp    %ebx,%eax
  8016f2:	77 0c                	ja     801700 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f9:	7f 1e                	jg     801719 <devfile_write+0x68>
}
  8016fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    
	assert(r <= n);
  801700:	68 24 2a 80 00       	push   $0x802a24
  801705:	68 2b 2a 80 00       	push   $0x802a2b
  80170a:	68 98 00 00 00       	push   $0x98
  80170f:	68 40 2a 80 00       	push   $0x802a40
  801714:	e8 6a 0a 00 00       	call   802183 <_panic>
	assert(r <= PGSIZE);
  801719:	68 4b 2a 80 00       	push   $0x802a4b
  80171e:	68 2b 2a 80 00       	push   $0x802a2b
  801723:	68 99 00 00 00       	push   $0x99
  801728:	68 40 2a 80 00       	push   $0x802a40
  80172d:	e8 51 0a 00 00       	call   802183 <_panic>

00801732 <devfile_read>:
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	56                   	push   %esi
  801736:	53                   	push   %ebx
  801737:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801745:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	b8 03 00 00 00       	mov    $0x3,%eax
  801755:	e8 65 fe ff ff       	call   8015bf <fsipc>
  80175a:	89 c3                	mov    %eax,%ebx
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 1f                	js     80177f <devfile_read+0x4d>
	assert(r <= n);
  801760:	39 f0                	cmp    %esi,%eax
  801762:	77 24                	ja     801788 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801764:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801769:	7f 33                	jg     80179e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80176b:	83 ec 04             	sub    $0x4,%esp
  80176e:	50                   	push   %eax
  80176f:	68 00 50 80 00       	push   $0x805000
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	e8 78 f3 ff ff       	call   800af4 <memmove>
	return r;
  80177c:	83 c4 10             	add    $0x10,%esp
}
  80177f:	89 d8                	mov    %ebx,%eax
  801781:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    
	assert(r <= n);
  801788:	68 24 2a 80 00       	push   $0x802a24
  80178d:	68 2b 2a 80 00       	push   $0x802a2b
  801792:	6a 7c                	push   $0x7c
  801794:	68 40 2a 80 00       	push   $0x802a40
  801799:	e8 e5 09 00 00       	call   802183 <_panic>
	assert(r <= PGSIZE);
  80179e:	68 4b 2a 80 00       	push   $0x802a4b
  8017a3:	68 2b 2a 80 00       	push   $0x802a2b
  8017a8:	6a 7d                	push   $0x7d
  8017aa:	68 40 2a 80 00       	push   $0x802a40
  8017af:	e8 cf 09 00 00       	call   802183 <_panic>

008017b4 <open>:
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	56                   	push   %esi
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 1c             	sub    $0x1c,%esp
  8017bc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017bf:	56                   	push   %esi
  8017c0:	e8 68 f1 ff ff       	call   80092d <strlen>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017cd:	7f 6c                	jg     80183b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017cf:	83 ec 0c             	sub    $0xc,%esp
  8017d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d5:	50                   	push   %eax
  8017d6:	e8 79 f8 ff ff       	call   801054 <fd_alloc>
  8017db:	89 c3                	mov    %eax,%ebx
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 3c                	js     801820 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	56                   	push   %esi
  8017e8:	68 00 50 80 00       	push   $0x805000
  8017ed:	e8 74 f1 ff ff       	call   800966 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801802:	e8 b8 fd ff ff       	call   8015bf <fsipc>
  801807:	89 c3                	mov    %eax,%ebx
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 19                	js     801829 <open+0x75>
	return fd2num(fd);
  801810:	83 ec 0c             	sub    $0xc,%esp
  801813:	ff 75 f4             	pushl  -0xc(%ebp)
  801816:	e8 12 f8 ff ff       	call   80102d <fd2num>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	89 d8                	mov    %ebx,%eax
  801822:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    
		fd_close(fd, 0);
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	6a 00                	push   $0x0
  80182e:	ff 75 f4             	pushl  -0xc(%ebp)
  801831:	e8 1b f9 ff ff       	call   801151 <fd_close>
		return r;
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	eb e5                	jmp    801820 <open+0x6c>
		return -E_BAD_PATH;
  80183b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801840:	eb de                	jmp    801820 <open+0x6c>

00801842 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801848:	ba 00 00 00 00       	mov    $0x0,%edx
  80184d:	b8 08 00 00 00       	mov    $0x8,%eax
  801852:	e8 68 fd ff ff       	call   8015bf <fsipc>
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80185f:	68 57 2a 80 00       	push   $0x802a57
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	e8 fa f0 ff ff       	call   800966 <strcpy>
	return 0;
}
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <devsock_close>:
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	83 ec 10             	sub    $0x10,%esp
  80187a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80187d:	53                   	push   %ebx
  80187e:	e8 5d 0a 00 00       	call   8022e0 <pageref>
  801883:	83 c4 10             	add    $0x10,%esp
		return 0;
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80188b:	83 f8 01             	cmp    $0x1,%eax
  80188e:	74 07                	je     801897 <devsock_close+0x24>
}
  801890:	89 d0                	mov    %edx,%eax
  801892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801895:	c9                   	leave  
  801896:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 73 0c             	pushl  0xc(%ebx)
  80189d:	e8 b9 02 00 00       	call   801b5b <nsipc_close>
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	eb e7                	jmp    801890 <devsock_close+0x1d>

008018a9 <devsock_write>:
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 10             	pushl  0x10(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	ff 70 0c             	pushl  0xc(%eax)
  8018bd:	e8 76 03 00 00       	call   801c38 <nsipc_send>
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <devsock_read>:
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 10             	pushl  0x10(%ebp)
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	ff 70 0c             	pushl  0xc(%eax)
  8018d8:	e8 ef 02 00 00       	call   801bcc <nsipc_recv>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <fd2sockid>:
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018e5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	e8 b7 f7 ff ff       	call   8010a6 <fd_lookup>
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 10                	js     801906 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f9:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018ff:	39 08                	cmp    %ecx,(%eax)
  801901:	75 05                	jne    801908 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801903:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    
		return -E_NOT_SUPP;
  801908:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190d:	eb f7                	jmp    801906 <fd2sockid+0x27>

0080190f <alloc_sockfd>:
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	56                   	push   %esi
  801913:	53                   	push   %ebx
  801914:	83 ec 1c             	sub    $0x1c,%esp
  801917:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191c:	50                   	push   %eax
  80191d:	e8 32 f7 ff ff       	call   801054 <fd_alloc>
  801922:	89 c3                	mov    %eax,%ebx
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 43                	js     80196e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 07 04 00 00       	push   $0x407
  801933:	ff 75 f4             	pushl  -0xc(%ebp)
  801936:	6a 00                	push   $0x0
  801938:	e8 1b f4 ff ff       	call   800d58 <sys_page_alloc>
  80193d:	89 c3                	mov    %eax,%ebx
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 28                	js     80196e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801949:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80194f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801954:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80195b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	50                   	push   %eax
  801962:	e8 c6 f6 ff ff       	call   80102d <fd2num>
  801967:	89 c3                	mov    %eax,%ebx
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	eb 0c                	jmp    80197a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	56                   	push   %esi
  801972:	e8 e4 01 00 00       	call   801b5b <nsipc_close>
		return r;
  801977:	83 c4 10             	add    $0x10,%esp
}
  80197a:	89 d8                	mov    %ebx,%eax
  80197c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <accept>:
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	e8 4e ff ff ff       	call   8018df <fd2sockid>
  801991:	85 c0                	test   %eax,%eax
  801993:	78 1b                	js     8019b0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	e8 0e 01 00 00       	call   801ab2 <nsipc_accept>
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 05                	js     8019b0 <accept+0x2d>
	return alloc_sockfd(r);
  8019ab:	e8 5f ff ff ff       	call   80190f <alloc_sockfd>
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <bind>:
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	e8 1f ff ff ff       	call   8018df <fd2sockid>
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 12                	js     8019d6 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	ff 75 10             	pushl  0x10(%ebp)
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	50                   	push   %eax
  8019ce:	e8 31 01 00 00       	call   801b04 <nsipc_bind>
  8019d3:	83 c4 10             	add    $0x10,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <shutdown>:
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	e8 f9 fe ff ff       	call   8018df <fd2sockid>
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 0f                	js     8019f9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ea:	83 ec 08             	sub    $0x8,%esp
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	e8 43 01 00 00       	call   801b39 <nsipc_shutdown>
  8019f6:	83 c4 10             	add    $0x10,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <connect>:
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	e8 d6 fe ff ff       	call   8018df <fd2sockid>
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 12                	js     801a1f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	ff 75 10             	pushl  0x10(%ebp)
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	50                   	push   %eax
  801a17:	e8 59 01 00 00       	call   801b75 <nsipc_connect>
  801a1c:	83 c4 10             	add    $0x10,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <listen>:
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	e8 b0 fe ff ff       	call   8018df <fd2sockid>
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 0f                	js     801a42 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	e8 6b 01 00 00       	call   801baa <nsipc_listen>
  801a3f:	83 c4 10             	add    $0x10,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a4a:	ff 75 10             	pushl  0x10(%ebp)
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	e8 3e 02 00 00       	call   801c96 <nsipc_socket>
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 05                	js     801a64 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a5f:	e8 ab fe ff ff       	call   80190f <alloc_sockfd>
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	53                   	push   %ebx
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a6f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a76:	74 26                	je     801a9e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a78:	6a 07                	push   $0x7
  801a7a:	68 00 60 80 00       	push   $0x806000
  801a7f:	53                   	push   %ebx
  801a80:	ff 35 04 40 80 00    	pushl  0x804004
  801a86:	e8 c2 07 00 00       	call   80224d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a8b:	83 c4 0c             	add    $0xc,%esp
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	e8 4b 07 00 00       	call   8021e4 <ipc_recv>
}
  801a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a9e:	83 ec 0c             	sub    $0xc,%esp
  801aa1:	6a 02                	push   $0x2
  801aa3:	e8 fd 07 00 00       	call   8022a5 <ipc_find_env>
  801aa8:	a3 04 40 80 00       	mov    %eax,0x804004
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	eb c6                	jmp    801a78 <nsipc+0x12>

00801ab2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	56                   	push   %esi
  801ab6:	53                   	push   %ebx
  801ab7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ac2:	8b 06                	mov    (%esi),%eax
  801ac4:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ace:	e8 93 ff ff ff       	call   801a66 <nsipc>
  801ad3:	89 c3                	mov    %eax,%ebx
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	79 09                	jns    801ae2 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ade:	5b                   	pop    %ebx
  801adf:	5e                   	pop    %esi
  801ae0:	5d                   	pop    %ebp
  801ae1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	ff 35 10 60 80 00    	pushl  0x806010
  801aeb:	68 00 60 80 00       	push   $0x806000
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	e8 fc ef ff ff       	call   800af4 <memmove>
		*addrlen = ret->ret_addrlen;
  801af8:	a1 10 60 80 00       	mov    0x806010,%eax
  801afd:	89 06                	mov    %eax,(%esi)
  801aff:	83 c4 10             	add    $0x10,%esp
	return r;
  801b02:	eb d5                	jmp    801ad9 <nsipc_accept+0x27>

00801b04 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	53                   	push   %ebx
  801b08:	83 ec 08             	sub    $0x8,%esp
  801b0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b16:	53                   	push   %ebx
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	68 04 60 80 00       	push   $0x806004
  801b1f:	e8 d0 ef ff ff       	call   800af4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b24:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b2a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b2f:	e8 32 ff ff ff       	call   801a66 <nsipc>
}
  801b34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b4f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b54:	e8 0d ff ff ff       	call   801a66 <nsipc>
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <nsipc_close>:

int
nsipc_close(int s)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b69:	b8 04 00 00 00       	mov    $0x4,%eax
  801b6e:	e8 f3 fe ff ff       	call   801a66 <nsipc>
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	53                   	push   %ebx
  801b79:	83 ec 08             	sub    $0x8,%esp
  801b7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b87:	53                   	push   %ebx
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	68 04 60 80 00       	push   $0x806004
  801b90:	e8 5f ef ff ff       	call   800af4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b95:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b9b:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba0:	e8 c1 fe ff ff       	call   801a66 <nsipc>
}
  801ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc0:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc5:	e8 9c fe ff ff       	call   801a66 <nsipc>
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	56                   	push   %esi
  801bd0:	53                   	push   %ebx
  801bd1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bdc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be2:	8b 45 14             	mov    0x14(%ebp),%eax
  801be5:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bea:	b8 07 00 00 00       	mov    $0x7,%eax
  801bef:	e8 72 fe ff ff       	call   801a66 <nsipc>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 1f                	js     801c19 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bfa:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bff:	7f 21                	jg     801c22 <nsipc_recv+0x56>
  801c01:	39 c6                	cmp    %eax,%esi
  801c03:	7c 1d                	jl     801c22 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	50                   	push   %eax
  801c09:	68 00 60 80 00       	push   $0x806000
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	e8 de ee ff ff       	call   800af4 <memmove>
  801c16:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c19:	89 d8                	mov    %ebx,%eax
  801c1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1e:	5b                   	pop    %ebx
  801c1f:	5e                   	pop    %esi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c22:	68 63 2a 80 00       	push   $0x802a63
  801c27:	68 2b 2a 80 00       	push   $0x802a2b
  801c2c:	6a 62                	push   $0x62
  801c2e:	68 78 2a 80 00       	push   $0x802a78
  801c33:	e8 4b 05 00 00       	call   802183 <_panic>

00801c38 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	53                   	push   %ebx
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c4a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c50:	7f 2e                	jg     801c80 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	53                   	push   %ebx
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	68 0c 60 80 00       	push   $0x80600c
  801c5e:	e8 91 ee ff ff       	call   800af4 <memmove>
	nsipcbuf.send.req_size = size;
  801c63:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c69:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c71:	b8 08 00 00 00       	mov    $0x8,%eax
  801c76:	e8 eb fd ff ff       	call   801a66 <nsipc>
}
  801c7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    
	assert(size < 1600);
  801c80:	68 84 2a 80 00       	push   $0x802a84
  801c85:	68 2b 2a 80 00       	push   $0x802a2b
  801c8a:	6a 6d                	push   $0x6d
  801c8c:	68 78 2a 80 00       	push   $0x802a78
  801c91:	e8 ed 04 00 00       	call   802183 <_panic>

00801c96 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cac:	8b 45 10             	mov    0x10(%ebp),%eax
  801caf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cb4:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb9:	e8 a8 fd ff ff       	call   801a66 <nsipc>
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	56                   	push   %esi
  801cc4:	53                   	push   %ebx
  801cc5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	e8 6a f3 ff ff       	call   80103d <fd2data>
  801cd3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd5:	83 c4 08             	add    $0x8,%esp
  801cd8:	68 90 2a 80 00       	push   $0x802a90
  801cdd:	53                   	push   %ebx
  801cde:	e8 83 ec ff ff       	call   800966 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ce3:	8b 46 04             	mov    0x4(%esi),%eax
  801ce6:	2b 06                	sub    (%esi),%eax
  801ce8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf5:	00 00 00 
	stat->st_dev = &devpipe;
  801cf8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cff:	30 80 00 
	return 0;
}
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0a:	5b                   	pop    %ebx
  801d0b:	5e                   	pop    %esi
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d18:	53                   	push   %ebx
  801d19:	6a 00                	push   $0x0
  801d1b:	e8 bd f0 ff ff       	call   800ddd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d20:	89 1c 24             	mov    %ebx,(%esp)
  801d23:	e8 15 f3 ff ff       	call   80103d <fd2data>
  801d28:	83 c4 08             	add    $0x8,%esp
  801d2b:	50                   	push   %eax
  801d2c:	6a 00                	push   $0x0
  801d2e:	e8 aa f0 ff ff       	call   800ddd <sys_page_unmap>
}
  801d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <_pipeisclosed>:
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	57                   	push   %edi
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 1c             	sub    $0x1c,%esp
  801d41:	89 c7                	mov    %eax,%edi
  801d43:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d45:	a1 08 40 80 00       	mov    0x804008,%eax
  801d4a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d4d:	83 ec 0c             	sub    $0xc,%esp
  801d50:	57                   	push   %edi
  801d51:	e8 8a 05 00 00       	call   8022e0 <pageref>
  801d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d59:	89 34 24             	mov    %esi,(%esp)
  801d5c:	e8 7f 05 00 00       	call   8022e0 <pageref>
		nn = thisenv->env_runs;
  801d61:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d67:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	39 cb                	cmp    %ecx,%ebx
  801d6f:	74 1b                	je     801d8c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d71:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d74:	75 cf                	jne    801d45 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d76:	8b 42 58             	mov    0x58(%edx),%eax
  801d79:	6a 01                	push   $0x1
  801d7b:	50                   	push   %eax
  801d7c:	53                   	push   %ebx
  801d7d:	68 97 2a 80 00       	push   $0x802a97
  801d82:	e8 80 e4 ff ff       	call   800207 <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	eb b9                	jmp    801d45 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d8c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8f:	0f 94 c0             	sete   %al
  801d92:	0f b6 c0             	movzbl %al,%eax
}
  801d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5e                   	pop    %esi
  801d9a:	5f                   	pop    %edi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    

00801d9d <devpipe_write>:
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	57                   	push   %edi
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 28             	sub    $0x28,%esp
  801da6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da9:	56                   	push   %esi
  801daa:	e8 8e f2 ff ff       	call   80103d <fd2data>
  801daf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	bf 00 00 00 00       	mov    $0x0,%edi
  801db9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dbc:	74 4f                	je     801e0d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dbe:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc1:	8b 0b                	mov    (%ebx),%ecx
  801dc3:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc6:	39 d0                	cmp    %edx,%eax
  801dc8:	72 14                	jb     801dde <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dca:	89 da                	mov    %ebx,%edx
  801dcc:	89 f0                	mov    %esi,%eax
  801dce:	e8 65 ff ff ff       	call   801d38 <_pipeisclosed>
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	75 3b                	jne    801e12 <devpipe_write+0x75>
			sys_yield();
  801dd7:	e8 5d ef ff ff       	call   800d39 <sys_yield>
  801ddc:	eb e0                	jmp    801dbe <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	c1 fa 1f             	sar    $0x1f,%edx
  801ded:	89 d1                	mov    %edx,%ecx
  801def:	c1 e9 1b             	shr    $0x1b,%ecx
  801df2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df5:	83 e2 1f             	and    $0x1f,%edx
  801df8:	29 ca                	sub    %ecx,%edx
  801dfa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dfe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e02:	83 c0 01             	add    $0x1,%eax
  801e05:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e08:	83 c7 01             	add    $0x1,%edi
  801e0b:	eb ac                	jmp    801db9 <devpipe_write+0x1c>
	return i;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	eb 05                	jmp    801e17 <devpipe_write+0x7a>
				return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devpipe_read>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	83 ec 18             	sub    $0x18,%esp
  801e28:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e2b:	57                   	push   %edi
  801e2c:	e8 0c f2 ff ff       	call   80103d <fd2data>
  801e31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	be 00 00 00 00       	mov    $0x0,%esi
  801e3b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e3e:	75 14                	jne    801e54 <devpipe_read+0x35>
	return i;
  801e40:	8b 45 10             	mov    0x10(%ebp),%eax
  801e43:	eb 02                	jmp    801e47 <devpipe_read+0x28>
				return i;
  801e45:	89 f0                	mov    %esi,%eax
}
  801e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    
			sys_yield();
  801e4f:	e8 e5 ee ff ff       	call   800d39 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e54:	8b 03                	mov    (%ebx),%eax
  801e56:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e59:	75 18                	jne    801e73 <devpipe_read+0x54>
			if (i > 0)
  801e5b:	85 f6                	test   %esi,%esi
  801e5d:	75 e6                	jne    801e45 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e5f:	89 da                	mov    %ebx,%edx
  801e61:	89 f8                	mov    %edi,%eax
  801e63:	e8 d0 fe ff ff       	call   801d38 <_pipeisclosed>
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	74 e3                	je     801e4f <devpipe_read+0x30>
				return 0;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e71:	eb d4                	jmp    801e47 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e73:	99                   	cltd   
  801e74:	c1 ea 1b             	shr    $0x1b,%edx
  801e77:	01 d0                	add    %edx,%eax
  801e79:	83 e0 1f             	and    $0x1f,%eax
  801e7c:	29 d0                	sub    %edx,%eax
  801e7e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e86:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e89:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e8c:	83 c6 01             	add    $0x1,%esi
  801e8f:	eb aa                	jmp    801e3b <devpipe_read+0x1c>

00801e91 <pipe>:
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	56                   	push   %esi
  801e95:	53                   	push   %ebx
  801e96:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9c:	50                   	push   %eax
  801e9d:	e8 b2 f1 ff ff       	call   801054 <fd_alloc>
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	0f 88 23 01 00 00    	js     801fd2 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	68 07 04 00 00       	push   $0x407
  801eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eba:	6a 00                	push   $0x0
  801ebc:	e8 97 ee ff ff       	call   800d58 <sys_page_alloc>
  801ec1:	89 c3                	mov    %eax,%ebx
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	0f 88 04 01 00 00    	js     801fd2 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ece:	83 ec 0c             	sub    $0xc,%esp
  801ed1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ed4:	50                   	push   %eax
  801ed5:	e8 7a f1 ff ff       	call   801054 <fd_alloc>
  801eda:	89 c3                	mov    %eax,%ebx
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	0f 88 db 00 00 00    	js     801fc2 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	68 07 04 00 00       	push   $0x407
  801eef:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef2:	6a 00                	push   $0x0
  801ef4:	e8 5f ee ff ff       	call   800d58 <sys_page_alloc>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	0f 88 bc 00 00 00    	js     801fc2 <pipe+0x131>
	va = fd2data(fd0);
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0c:	e8 2c f1 ff ff       	call   80103d <fd2data>
  801f11:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f13:	83 c4 0c             	add    $0xc,%esp
  801f16:	68 07 04 00 00       	push   $0x407
  801f1b:	50                   	push   %eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	e8 35 ee ff ff       	call   800d58 <sys_page_alloc>
  801f23:	89 c3                	mov    %eax,%ebx
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	0f 88 82 00 00 00    	js     801fb2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	ff 75 f0             	pushl  -0x10(%ebp)
  801f36:	e8 02 f1 ff ff       	call   80103d <fd2data>
  801f3b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f42:	50                   	push   %eax
  801f43:	6a 00                	push   $0x0
  801f45:	56                   	push   %esi
  801f46:	6a 00                	push   $0x0
  801f48:	e8 4e ee ff ff       	call   800d9b <sys_page_map>
  801f4d:	89 c3                	mov    %eax,%ebx
  801f4f:	83 c4 20             	add    $0x20,%esp
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 4e                	js     801fa4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f56:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f72:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7f:	e8 a9 f0 ff ff       	call   80102d <fd2num>
  801f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f87:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f89:	83 c4 04             	add    $0x4,%esp
  801f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8f:	e8 99 f0 ff ff       	call   80102d <fd2num>
  801f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f97:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa2:	eb 2e                	jmp    801fd2 <pipe+0x141>
	sys_page_unmap(0, va);
  801fa4:	83 ec 08             	sub    $0x8,%esp
  801fa7:	56                   	push   %esi
  801fa8:	6a 00                	push   $0x0
  801faa:	e8 2e ee ff ff       	call   800ddd <sys_page_unmap>
  801faf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb8:	6a 00                	push   $0x0
  801fba:	e8 1e ee ff ff       	call   800ddd <sys_page_unmap>
  801fbf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc8:	6a 00                	push   $0x0
  801fca:	e8 0e ee ff ff       	call   800ddd <sys_page_unmap>
  801fcf:	83 c4 10             	add    $0x10,%esp
}
  801fd2:	89 d8                	mov    %ebx,%eax
  801fd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd7:	5b                   	pop    %ebx
  801fd8:	5e                   	pop    %esi
  801fd9:	5d                   	pop    %ebp
  801fda:	c3                   	ret    

00801fdb <pipeisclosed>:
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe4:	50                   	push   %eax
  801fe5:	ff 75 08             	pushl  0x8(%ebp)
  801fe8:	e8 b9 f0 ff ff       	call   8010a6 <fd_lookup>
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 18                	js     80200c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffa:	e8 3e f0 ff ff       	call   80103d <fd2data>
	return _pipeisclosed(fd, p);
  801fff:	89 c2                	mov    %eax,%edx
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	e8 2f fd ff ff       	call   801d38 <_pipeisclosed>
  802009:	83 c4 10             	add    $0x10,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
  802013:	c3                   	ret    

00802014 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80201a:	68 af 2a 80 00       	push   $0x802aaf
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	e8 3f e9 ff ff       	call   800966 <strcpy>
	return 0;
}
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <devcons_write>:
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80203a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80203f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802045:	3b 75 10             	cmp    0x10(%ebp),%esi
  802048:	73 31                	jae    80207b <devcons_write+0x4d>
		m = n - tot;
  80204a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80204d:	29 f3                	sub    %esi,%ebx
  80204f:	83 fb 7f             	cmp    $0x7f,%ebx
  802052:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802057:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	53                   	push   %ebx
  80205e:	89 f0                	mov    %esi,%eax
  802060:	03 45 0c             	add    0xc(%ebp),%eax
  802063:	50                   	push   %eax
  802064:	57                   	push   %edi
  802065:	e8 8a ea ff ff       	call   800af4 <memmove>
		sys_cputs(buf, m);
  80206a:	83 c4 08             	add    $0x8,%esp
  80206d:	53                   	push   %ebx
  80206e:	57                   	push   %edi
  80206f:	e8 28 ec ff ff       	call   800c9c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802074:	01 de                	add    %ebx,%esi
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	eb ca                	jmp    802045 <devcons_write+0x17>
}
  80207b:	89 f0                	mov    %esi,%eax
  80207d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	5f                   	pop    %edi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <devcons_read>:
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 08             	sub    $0x8,%esp
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802090:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802094:	74 21                	je     8020b7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802096:	e8 1f ec ff ff       	call   800cba <sys_cgetc>
  80209b:	85 c0                	test   %eax,%eax
  80209d:	75 07                	jne    8020a6 <devcons_read+0x21>
		sys_yield();
  80209f:	e8 95 ec ff ff       	call   800d39 <sys_yield>
  8020a4:	eb f0                	jmp    802096 <devcons_read+0x11>
	if (c < 0)
  8020a6:	78 0f                	js     8020b7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020a8:	83 f8 04             	cmp    $0x4,%eax
  8020ab:	74 0c                	je     8020b9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b0:	88 02                	mov    %al,(%edx)
	return 1;
  8020b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    
		return 0;
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020be:	eb f7                	jmp    8020b7 <devcons_read+0x32>

008020c0 <cputchar>:
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020cc:	6a 01                	push   $0x1
  8020ce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d1:	50                   	push   %eax
  8020d2:	e8 c5 eb ff ff       	call   800c9c <sys_cputs>
}
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <getchar>:
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e2:	6a 01                	push   $0x1
  8020e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e7:	50                   	push   %eax
  8020e8:	6a 00                	push   $0x0
  8020ea:	e8 27 f2 ff ff       	call   801316 <read>
	if (r < 0)
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	78 06                	js     8020fc <getchar+0x20>
	if (r < 1)
  8020f6:	74 06                	je     8020fe <getchar+0x22>
	return c;
  8020f8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    
		return -E_EOF;
  8020fe:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802103:	eb f7                	jmp    8020fc <getchar+0x20>

00802105 <iscons>:
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210e:	50                   	push   %eax
  80210f:	ff 75 08             	pushl  0x8(%ebp)
  802112:	e8 8f ef ff ff       	call   8010a6 <fd_lookup>
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	85 c0                	test   %eax,%eax
  80211c:	78 11                	js     80212f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80211e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802121:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802127:	39 10                	cmp    %edx,(%eax)
  802129:	0f 94 c0             	sete   %al
  80212c:	0f b6 c0             	movzbl %al,%eax
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <opencons>:
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802137:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213a:	50                   	push   %eax
  80213b:	e8 14 ef ff ff       	call   801054 <fd_alloc>
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	85 c0                	test   %eax,%eax
  802145:	78 3a                	js     802181 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 07 04 00 00       	push   $0x407
  80214f:	ff 75 f4             	pushl  -0xc(%ebp)
  802152:	6a 00                	push   $0x0
  802154:	e8 ff eb ff ff       	call   800d58 <sys_page_alloc>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 21                	js     802181 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802169:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	50                   	push   %eax
  802179:	e8 af ee ff ff       	call   80102d <fd2num>
  80217e:	83 c4 10             	add    $0x10,%esp
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802188:	a1 08 40 80 00       	mov    0x804008,%eax
  80218d:	8b 40 48             	mov    0x48(%eax),%eax
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 e0 2a 80 00       	push   $0x802ae0
  802198:	50                   	push   %eax
  802199:	68 d8 25 80 00       	push   $0x8025d8
  80219e:	e8 64 e0 ff ff       	call   800207 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021a3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021a6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ac:	e8 69 eb ff ff       	call   800d1a <sys_getenvid>
  8021b1:	83 c4 04             	add    $0x4,%esp
  8021b4:	ff 75 0c             	pushl  0xc(%ebp)
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	56                   	push   %esi
  8021bb:	50                   	push   %eax
  8021bc:	68 bc 2a 80 00       	push   $0x802abc
  8021c1:	e8 41 e0 ff ff       	call   800207 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021c6:	83 c4 18             	add    $0x18,%esp
  8021c9:	53                   	push   %ebx
  8021ca:	ff 75 10             	pushl  0x10(%ebp)
  8021cd:	e8 e4 df ff ff       	call   8001b6 <vcprintf>
	cprintf("\n");
  8021d2:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021d9:	e8 29 e0 ff ff       	call   800207 <cprintf>
  8021de:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e1:	cc                   	int3   
  8021e2:	eb fd                	jmp    8021e1 <_panic+0x5e>

008021e4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021f4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f9:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	50                   	push   %eax
  802200:	e8 03 ed ff ff       	call   800f08 <sys_ipc_recv>
	if(ret < 0){
  802205:	83 c4 10             	add    $0x10,%esp
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 2b                	js     802237 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80220c:	85 f6                	test   %esi,%esi
  80220e:	74 0a                	je     80221a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802210:	a1 08 40 80 00       	mov    0x804008,%eax
  802215:	8b 40 74             	mov    0x74(%eax),%eax
  802218:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80221a:	85 db                	test   %ebx,%ebx
  80221c:	74 0a                	je     802228 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80221e:	a1 08 40 80 00       	mov    0x804008,%eax
  802223:	8b 40 78             	mov    0x78(%eax),%eax
  802226:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802228:	a1 08 40 80 00       	mov    0x804008,%eax
  80222d:	8b 40 70             	mov    0x70(%eax),%eax
}
  802230:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5d                   	pop    %ebp
  802236:	c3                   	ret    
		if(from_env_store)
  802237:	85 f6                	test   %esi,%esi
  802239:	74 06                	je     802241 <ipc_recv+0x5d>
			*from_env_store = 0;
  80223b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802241:	85 db                	test   %ebx,%ebx
  802243:	74 eb                	je     802230 <ipc_recv+0x4c>
			*perm_store = 0;
  802245:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80224b:	eb e3                	jmp    802230 <ipc_recv+0x4c>

0080224d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	57                   	push   %edi
  802251:	56                   	push   %esi
  802252:	53                   	push   %ebx
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	8b 7d 08             	mov    0x8(%ebp),%edi
  802259:	8b 75 0c             	mov    0xc(%ebp),%esi
  80225c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80225f:	85 db                	test   %ebx,%ebx
  802261:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802266:	0f 44 d8             	cmove  %eax,%ebx
  802269:	eb 05                	jmp    802270 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80226b:	e8 c9 ea ff ff       	call   800d39 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802270:	ff 75 14             	pushl  0x14(%ebp)
  802273:	53                   	push   %ebx
  802274:	56                   	push   %esi
  802275:	57                   	push   %edi
  802276:	e8 6a ec ff ff       	call   800ee5 <sys_ipc_try_send>
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 1b                	je     80229d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802282:	79 e7                	jns    80226b <ipc_send+0x1e>
  802284:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802287:	74 e2                	je     80226b <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802289:	83 ec 04             	sub    $0x4,%esp
  80228c:	68 e7 2a 80 00       	push   $0x802ae7
  802291:	6a 46                	push   $0x46
  802293:	68 fc 2a 80 00       	push   $0x802afc
  802298:	e8 e6 fe ff ff       	call   802183 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80229d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5f                   	pop    %edi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    

008022a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b0:	89 c2                	mov    %eax,%edx
  8022b2:	c1 e2 07             	shl    $0x7,%edx
  8022b5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022bb:	8b 52 50             	mov    0x50(%edx),%edx
  8022be:	39 ca                	cmp    %ecx,%edx
  8022c0:	74 11                	je     8022d3 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022c2:	83 c0 01             	add    $0x1,%eax
  8022c5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ca:	75 e4                	jne    8022b0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	eb 0b                	jmp    8022de <ipc_find_env+0x39>
			return envs[i].env_id;
  8022d3:	c1 e0 07             	shl    $0x7,%eax
  8022d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022db:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    

008022e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022e6:	89 d0                	mov    %edx,%eax
  8022e8:	c1 e8 16             	shr    $0x16,%eax
  8022eb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f7:	f6 c1 01             	test   $0x1,%cl
  8022fa:	74 1d                	je     802319 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022fc:	c1 ea 0c             	shr    $0xc,%edx
  8022ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802306:	f6 c2 01             	test   $0x1,%dl
  802309:	74 0e                	je     802319 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80230b:	c1 ea 0c             	shr    $0xc,%edx
  80230e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802315:	ef 
  802316:	0f b7 c0             	movzwl %ax,%eax
}
  802319:	5d                   	pop    %ebp
  80231a:	c3                   	ret    
  80231b:	66 90                	xchg   %ax,%ax
  80231d:	66 90                	xchg   %ax,%ax
  80231f:	90                   	nop

00802320 <__udivdi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80232b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80232f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802333:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802337:	85 d2                	test   %edx,%edx
  802339:	75 4d                	jne    802388 <__udivdi3+0x68>
  80233b:	39 f3                	cmp    %esi,%ebx
  80233d:	76 19                	jbe    802358 <__udivdi3+0x38>
  80233f:	31 ff                	xor    %edi,%edi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f2                	mov    %esi,%edx
  802345:	f7 f3                	div    %ebx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	89 d9                	mov    %ebx,%ecx
  80235a:	85 db                	test   %ebx,%ebx
  80235c:	75 0b                	jne    802369 <__udivdi3+0x49>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 c1                	mov    %eax,%ecx
  802369:	31 d2                	xor    %edx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	f7 f1                	div    %ecx
  80236f:	89 c6                	mov    %eax,%esi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f7                	mov    %esi,%edi
  802375:	f7 f1                	div    %ecx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	39 f2                	cmp    %esi,%edx
  80238a:	77 1c                	ja     8023a8 <__udivdi3+0x88>
  80238c:	0f bd fa             	bsr    %edx,%edi
  80238f:	83 f7 1f             	xor    $0x1f,%edi
  802392:	75 2c                	jne    8023c0 <__udivdi3+0xa0>
  802394:	39 f2                	cmp    %esi,%edx
  802396:	72 06                	jb     80239e <__udivdi3+0x7e>
  802398:	31 c0                	xor    %eax,%eax
  80239a:	39 eb                	cmp    %ebp,%ebx
  80239c:	77 a9                	ja     802347 <__udivdi3+0x27>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	eb a2                	jmp    802347 <__udivdi3+0x27>
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	31 ff                	xor    %edi,%edi
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	89 fa                	mov    %edi,%edx
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	89 f9                	mov    %edi,%ecx
  8023c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c7:	29 f8                	sub    %edi,%eax
  8023c9:	d3 e2                	shl    %cl,%edx
  8023cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023cf:	89 c1                	mov    %eax,%ecx
  8023d1:	89 da                	mov    %ebx,%edx
  8023d3:	d3 ea                	shr    %cl,%edx
  8023d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d9:	09 d1                	or     %edx,%ecx
  8023db:	89 f2                	mov    %esi,%edx
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 f9                	mov    %edi,%ecx
  8023e3:	d3 e3                	shl    %cl,%ebx
  8023e5:	89 c1                	mov    %eax,%ecx
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	89 f9                	mov    %edi,%ecx
  8023eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ef:	89 eb                	mov    %ebp,%ebx
  8023f1:	d3 e6                	shl    %cl,%esi
  8023f3:	89 c1                	mov    %eax,%ecx
  8023f5:	d3 eb                	shr    %cl,%ebx
  8023f7:	09 de                	or     %ebx,%esi
  8023f9:	89 f0                	mov    %esi,%eax
  8023fb:	f7 74 24 08          	divl   0x8(%esp)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	89 c3                	mov    %eax,%ebx
  802403:	f7 64 24 0c          	mull   0xc(%esp)
  802407:	39 d6                	cmp    %edx,%esi
  802409:	72 15                	jb     802420 <__udivdi3+0x100>
  80240b:	89 f9                	mov    %edi,%ecx
  80240d:	d3 e5                	shl    %cl,%ebp
  80240f:	39 c5                	cmp    %eax,%ebp
  802411:	73 04                	jae    802417 <__udivdi3+0xf7>
  802413:	39 d6                	cmp    %edx,%esi
  802415:	74 09                	je     802420 <__udivdi3+0x100>
  802417:	89 d8                	mov    %ebx,%eax
  802419:	31 ff                	xor    %edi,%edi
  80241b:	e9 27 ff ff ff       	jmp    802347 <__udivdi3+0x27>
  802420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802423:	31 ff                	xor    %edi,%edi
  802425:	e9 1d ff ff ff       	jmp    802347 <__udivdi3+0x27>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	66 90                	xchg   %ax,%ax
  80242e:	66 90                	xchg   %ax,%ax

00802430 <__umoddi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 1c             	sub    $0x1c,%esp
  802437:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80243b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80243f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802447:	89 da                	mov    %ebx,%edx
  802449:	85 c0                	test   %eax,%eax
  80244b:	75 43                	jne    802490 <__umoddi3+0x60>
  80244d:	39 df                	cmp    %ebx,%edi
  80244f:	76 17                	jbe    802468 <__umoddi3+0x38>
  802451:	89 f0                	mov    %esi,%eax
  802453:	f7 f7                	div    %edi
  802455:	89 d0                	mov    %edx,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 fd                	mov    %edi,%ebp
  80246a:	85 ff                	test   %edi,%edi
  80246c:	75 0b                	jne    802479 <__umoddi3+0x49>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	31 d2                	xor    %edx,%edx
  802475:	f7 f7                	div    %edi
  802477:	89 c5                	mov    %eax,%ebp
  802479:	89 d8                	mov    %ebx,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	f7 f5                	div    %ebp
  80247f:	89 f0                	mov    %esi,%eax
  802481:	f7 f5                	div    %ebp
  802483:	89 d0                	mov    %edx,%eax
  802485:	eb d0                	jmp    802457 <__umoddi3+0x27>
  802487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248e:	66 90                	xchg   %ax,%ax
  802490:	89 f1                	mov    %esi,%ecx
  802492:	39 d8                	cmp    %ebx,%eax
  802494:	76 0a                	jbe    8024a0 <__umoddi3+0x70>
  802496:	89 f0                	mov    %esi,%eax
  802498:	83 c4 1c             	add    $0x1c,%esp
  80249b:	5b                   	pop    %ebx
  80249c:	5e                   	pop    %esi
  80249d:	5f                   	pop    %edi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    
  8024a0:	0f bd e8             	bsr    %eax,%ebp
  8024a3:	83 f5 1f             	xor    $0x1f,%ebp
  8024a6:	75 20                	jne    8024c8 <__umoddi3+0x98>
  8024a8:	39 d8                	cmp    %ebx,%eax
  8024aa:	0f 82 b0 00 00 00    	jb     802560 <__umoddi3+0x130>
  8024b0:	39 f7                	cmp    %esi,%edi
  8024b2:	0f 86 a8 00 00 00    	jbe    802560 <__umoddi3+0x130>
  8024b8:	89 c8                	mov    %ecx,%eax
  8024ba:	83 c4 1c             	add    $0x1c,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5f                   	pop    %edi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8024cf:	29 ea                	sub    %ebp,%edx
  8024d1:	d3 e0                	shl    %cl,%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	89 d1                	mov    %edx,%ecx
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	d3 e8                	shr    %cl,%eax
  8024dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024e9:	09 c1                	or     %eax,%ecx
  8024eb:	89 d8                	mov    %ebx,%eax
  8024ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024f1:	89 e9                	mov    %ebp,%ecx
  8024f3:	d3 e7                	shl    %cl,%edi
  8024f5:	89 d1                	mov    %edx,%ecx
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ff:	d3 e3                	shl    %cl,%ebx
  802501:	89 c7                	mov    %eax,%edi
  802503:	89 d1                	mov    %edx,%ecx
  802505:	89 f0                	mov    %esi,%eax
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 fa                	mov    %edi,%edx
  80250d:	d3 e6                	shl    %cl,%esi
  80250f:	09 d8                	or     %ebx,%eax
  802511:	f7 74 24 08          	divl   0x8(%esp)
  802515:	89 d1                	mov    %edx,%ecx
  802517:	89 f3                	mov    %esi,%ebx
  802519:	f7 64 24 0c          	mull   0xc(%esp)
  80251d:	89 c6                	mov    %eax,%esi
  80251f:	89 d7                	mov    %edx,%edi
  802521:	39 d1                	cmp    %edx,%ecx
  802523:	72 06                	jb     80252b <__umoddi3+0xfb>
  802525:	75 10                	jne    802537 <__umoddi3+0x107>
  802527:	39 c3                	cmp    %eax,%ebx
  802529:	73 0c                	jae    802537 <__umoddi3+0x107>
  80252b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80252f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802533:	89 d7                	mov    %edx,%edi
  802535:	89 c6                	mov    %eax,%esi
  802537:	89 ca                	mov    %ecx,%edx
  802539:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253e:	29 f3                	sub    %esi,%ebx
  802540:	19 fa                	sbb    %edi,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	d3 e0                	shl    %cl,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 eb                	shr    %cl,%ebx
  80254a:	d3 ea                	shr    %cl,%edx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 da                	mov    %ebx,%edx
  802562:	29 fe                	sub    %edi,%esi
  802564:	19 c2                	sbb    %eax,%edx
  802566:	89 f1                	mov    %esi,%ecx
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	e9 4b ff ff ff       	jmp    8024ba <__umoddi3+0x8a>
