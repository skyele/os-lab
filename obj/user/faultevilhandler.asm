
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  800042:	e8 13 0d 00 00       	call   800d5a <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 4f 0e 00 00       	call   800ea5 <sys_env_set_pgfault_upcall>
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
  800078:	e8 9f 0c 00 00       	call   800d1c <sys_getenvid>
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
  80009d:	74 23                	je     8000c2 <libmain+0x5d>
		if(envs[i].env_id == find)
  80009f:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000a5:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000ab:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000ae:	39 c1                	cmp    %eax,%ecx
  8000b0:	75 e2                	jne    800094 <libmain+0x2f>
  8000b2:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000b8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000be:	89 fe                	mov    %edi,%esi
  8000c0:	eb d2                	jmp    800094 <libmain+0x2f>
  8000c2:	89 f0                	mov    %esi,%eax
  8000c4:	84 c0                	test   %al,%al
  8000c6:	74 06                	je     8000ce <libmain+0x69>
  8000c8:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000d2:	7e 0a                	jle    8000de <libmain+0x79>
		binaryname = argv[0];
  8000d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d7:	8b 00                	mov    (%eax),%eax
  8000d9:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000de:	a1 08 40 80 00       	mov    0x804008,%eax
  8000e3:	8b 40 48             	mov    0x48(%eax),%eax
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	50                   	push   %eax
  8000ea:	68 a0 25 80 00       	push   $0x8025a0
  8000ef:	e8 15 01 00 00       	call   800209 <cprintf>
	cprintf("before umain\n");
  8000f4:	c7 04 24 be 25 80 00 	movl   $0x8025be,(%esp)
  8000fb:	e8 09 01 00 00       	call   800209 <cprintf>
	// call user main routine
	umain(argc, argv);
  800100:	83 c4 08             	add    $0x8,%esp
  800103:	ff 75 0c             	pushl  0xc(%ebp)
  800106:	ff 75 08             	pushl  0x8(%ebp)
  800109:	e8 25 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80010e:	c7 04 24 cc 25 80 00 	movl   $0x8025cc,(%esp)
  800115:	e8 ef 00 00 00       	call   800209 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80011a:	a1 08 40 80 00       	mov    0x804008,%eax
  80011f:	8b 40 48             	mov    0x48(%eax),%eax
  800122:	83 c4 08             	add    $0x8,%esp
  800125:	50                   	push   %eax
  800126:	68 d9 25 80 00       	push   $0x8025d9
  80012b:	e8 d9 00 00 00       	call   800209 <cprintf>
	// exit gracefully
	exit();
  800130:	e8 0b 00 00 00       	call   800140 <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5f                   	pop    %edi
  80013e:	5d                   	pop    %ebp
  80013f:	c3                   	ret    

00800140 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800146:	a1 08 40 80 00       	mov    0x804008,%eax
  80014b:	8b 40 48             	mov    0x48(%eax),%eax
  80014e:	68 04 26 80 00       	push   $0x802604
  800153:	50                   	push   %eax
  800154:	68 f8 25 80 00       	push   $0x8025f8
  800159:	e8 ab 00 00 00       	call   800209 <cprintf>
	close_all();
  80015e:	e8 c4 10 00 00       	call   801227 <close_all>
	sys_env_destroy(0);
  800163:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016a:	e8 6c 0b 00 00       	call   800cdb <sys_env_destroy>
}
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	53                   	push   %ebx
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017e:	8b 13                	mov    (%ebx),%edx
  800180:	8d 42 01             	lea    0x1(%edx),%eax
  800183:	89 03                	mov    %eax,(%ebx)
  800185:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800188:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800191:	74 09                	je     80019c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800193:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80019a:	c9                   	leave  
  80019b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	68 ff 00 00 00       	push   $0xff
  8001a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 f1 0a 00 00       	call   800c9e <sys_cputs>
		b->idx = 0;
  8001ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb db                	jmp    800193 <putch+0x1f>

008001b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c8:	00 00 00 
	b.cnt = 0;
  8001cb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e1:	50                   	push   %eax
  8001e2:	68 74 01 80 00       	push   $0x800174
  8001e7:	e8 4a 01 00 00       	call   800336 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ec:	83 c4 08             	add    $0x8,%esp
  8001ef:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	e8 9d 0a 00 00       	call   800c9e <sys_cputs>

	return b.cnt;
}
  800201:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800212:	50                   	push   %eax
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 9d ff ff ff       	call   8001b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	57                   	push   %edi
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 1c             	sub    $0x1c,%esp
  800226:	89 c6                	mov    %eax,%esi
  800228:	89 d7                	mov    %edx,%edi
  80022a:	8b 45 08             	mov    0x8(%ebp),%eax
  80022d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800230:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800233:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800236:	8b 45 10             	mov    0x10(%ebp),%eax
  800239:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80023c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800240:	74 2c                	je     80026e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800242:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800245:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80024c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80024f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800252:	39 c2                	cmp    %eax,%edx
  800254:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800257:	73 43                	jae    80029c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800259:	83 eb 01             	sub    $0x1,%ebx
  80025c:	85 db                	test   %ebx,%ebx
  80025e:	7e 6c                	jle    8002cc <printnum+0xaf>
				putch(padc, putdat);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	57                   	push   %edi
  800264:	ff 75 18             	pushl  0x18(%ebp)
  800267:	ff d6                	call   *%esi
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	eb eb                	jmp    800259 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	6a 20                	push   $0x20
  800273:	6a 00                	push   $0x0
  800275:	50                   	push   %eax
  800276:	ff 75 e4             	pushl  -0x1c(%ebp)
  800279:	ff 75 e0             	pushl  -0x20(%ebp)
  80027c:	89 fa                	mov    %edi,%edx
  80027e:	89 f0                	mov    %esi,%eax
  800280:	e8 98 ff ff ff       	call   80021d <printnum>
		while (--width > 0)
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	83 eb 01             	sub    $0x1,%ebx
  80028b:	85 db                	test   %ebx,%ebx
  80028d:	7e 65                	jle    8002f4 <printnum+0xd7>
			putch(padc, putdat);
  80028f:	83 ec 08             	sub    $0x8,%esp
  800292:	57                   	push   %edi
  800293:	6a 20                	push   $0x20
  800295:	ff d6                	call   *%esi
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	eb ec                	jmp    800288 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	ff 75 18             	pushl  0x18(%ebp)
  8002a2:	83 eb 01             	sub    $0x1,%ebx
  8002a5:	53                   	push   %ebx
  8002a6:	50                   	push   %eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	e8 95 20 00 00       	call   802350 <__udivdi3>
  8002bb:	83 c4 18             	add    $0x18,%esp
  8002be:	52                   	push   %edx
  8002bf:	50                   	push   %eax
  8002c0:	89 fa                	mov    %edi,%edx
  8002c2:	89 f0                	mov    %esi,%eax
  8002c4:	e8 54 ff ff ff       	call   80021d <printnum>
  8002c9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	57                   	push   %edi
  8002d0:	83 ec 04             	sub    $0x4,%esp
  8002d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002df:	e8 7c 21 00 00       	call   802460 <__umoddi3>
  8002e4:	83 c4 14             	add    $0x14,%esp
  8002e7:	0f be 80 09 26 80 00 	movsbl 0x802609(%eax),%eax
  8002ee:	50                   	push   %eax
  8002ef:	ff d6                	call   *%esi
  8002f1:	83 c4 10             	add    $0x10,%esp
	}
}
  8002f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f7:	5b                   	pop    %ebx
  8002f8:	5e                   	pop    %esi
  8002f9:	5f                   	pop    %edi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800302:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800306:	8b 10                	mov    (%eax),%edx
  800308:	3b 50 04             	cmp    0x4(%eax),%edx
  80030b:	73 0a                	jae    800317 <sprintputch+0x1b>
		*b->buf++ = ch;
  80030d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800310:	89 08                	mov    %ecx,(%eax)
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	88 02                	mov    %al,(%edx)
}
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <printfmt>:
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800322:	50                   	push   %eax
  800323:	ff 75 10             	pushl  0x10(%ebp)
  800326:	ff 75 0c             	pushl  0xc(%ebp)
  800329:	ff 75 08             	pushl  0x8(%ebp)
  80032c:	e8 05 00 00 00       	call   800336 <vprintfmt>
}
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	c9                   	leave  
  800335:	c3                   	ret    

00800336 <vprintfmt>:
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	57                   	push   %edi
  80033a:	56                   	push   %esi
  80033b:	53                   	push   %ebx
  80033c:	83 ec 3c             	sub    $0x3c,%esp
  80033f:	8b 75 08             	mov    0x8(%ebp),%esi
  800342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800345:	8b 7d 10             	mov    0x10(%ebp),%edi
  800348:	e9 32 04 00 00       	jmp    80077f <vprintfmt+0x449>
		padc = ' ';
  80034d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800351:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800358:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80035f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800366:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800374:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800379:	8d 47 01             	lea    0x1(%edi),%eax
  80037c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037f:	0f b6 17             	movzbl (%edi),%edx
  800382:	8d 42 dd             	lea    -0x23(%edx),%eax
  800385:	3c 55                	cmp    $0x55,%al
  800387:	0f 87 12 05 00 00    	ja     80089f <vprintfmt+0x569>
  80038d:	0f b6 c0             	movzbl %al,%eax
  800390:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80039a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80039e:	eb d9                	jmp    800379 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a3:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003a7:	eb d0                	jmp    800379 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003a9:	0f b6 d2             	movzbl %dl,%edx
  8003ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003af:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b4:	89 75 08             	mov    %esi,0x8(%ebp)
  8003b7:	eb 03                	jmp    8003bc <vprintfmt+0x86>
  8003b9:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003c9:	83 fe 09             	cmp    $0x9,%esi
  8003cc:	76 eb                	jbe    8003b9 <vprintfmt+0x83>
  8003ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d4:	eb 14                	jmp    8003ea <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003de:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e1:	8d 40 04             	lea    0x4(%eax),%eax
  8003e4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ee:	79 89                	jns    800379 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003fd:	e9 77 ff ff ff       	jmp    800379 <vprintfmt+0x43>
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	85 c0                	test   %eax,%eax
  800407:	0f 48 c1             	cmovs  %ecx,%eax
  80040a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800410:	e9 64 ff ff ff       	jmp    800379 <vprintfmt+0x43>
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800418:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80041f:	e9 55 ff ff ff       	jmp    800379 <vprintfmt+0x43>
			lflag++;
  800424:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80042b:	e9 49 ff ff ff       	jmp    800379 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8d 78 04             	lea    0x4(%eax),%edi
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	53                   	push   %ebx
  80043a:	ff 30                	pushl  (%eax)
  80043c:	ff d6                	call   *%esi
			break;
  80043e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800441:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800444:	e9 33 03 00 00       	jmp    80077c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8d 78 04             	lea    0x4(%eax),%edi
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	99                   	cltd   
  800452:	31 d0                	xor    %edx,%eax
  800454:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800456:	83 f8 11             	cmp    $0x11,%eax
  800459:	7f 23                	jg     80047e <vprintfmt+0x148>
  80045b:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  800462:	85 d2                	test   %edx,%edx
  800464:	74 18                	je     80047e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800466:	52                   	push   %edx
  800467:	68 5d 2a 80 00       	push   $0x802a5d
  80046c:	53                   	push   %ebx
  80046d:	56                   	push   %esi
  80046e:	e8 a6 fe ff ff       	call   800319 <printfmt>
  800473:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800476:	89 7d 14             	mov    %edi,0x14(%ebp)
  800479:	e9 fe 02 00 00       	jmp    80077c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80047e:	50                   	push   %eax
  80047f:	68 21 26 80 00       	push   $0x802621
  800484:	53                   	push   %ebx
  800485:	56                   	push   %esi
  800486:	e8 8e fe ff ff       	call   800319 <printfmt>
  80048b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80048e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800491:	e9 e6 02 00 00       	jmp    80077c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	83 c0 04             	add    $0x4,%eax
  80049c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004a4:	85 c9                	test   %ecx,%ecx
  8004a6:	b8 1a 26 80 00       	mov    $0x80261a,%eax
  8004ab:	0f 45 c1             	cmovne %ecx,%eax
  8004ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b5:	7e 06                	jle    8004bd <vprintfmt+0x187>
  8004b7:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004bb:	75 0d                	jne    8004ca <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c0:	89 c7                	mov    %eax,%edi
  8004c2:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c8:	eb 53                	jmp    80051d <vprintfmt+0x1e7>
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8004d0:	50                   	push   %eax
  8004d1:	e8 71 04 00 00       	call   800947 <strnlen>
  8004d6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d9:	29 c1                	sub    %eax,%ecx
  8004db:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004e3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ea:	eb 0f                	jmp    8004fb <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004ec:	83 ec 08             	sub    $0x8,%esp
  8004ef:	53                   	push   %ebx
  8004f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f5:	83 ef 01             	sub    $0x1,%edi
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	85 ff                	test   %edi,%edi
  8004fd:	7f ed                	jg     8004ec <vprintfmt+0x1b6>
  8004ff:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800502:	85 c9                	test   %ecx,%ecx
  800504:	b8 00 00 00 00       	mov    $0x0,%eax
  800509:	0f 49 c1             	cmovns %ecx,%eax
  80050c:	29 c1                	sub    %eax,%ecx
  80050e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800511:	eb aa                	jmp    8004bd <vprintfmt+0x187>
					putch(ch, putdat);
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	53                   	push   %ebx
  800517:	52                   	push   %edx
  800518:	ff d6                	call   *%esi
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800520:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800522:	83 c7 01             	add    $0x1,%edi
  800525:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800529:	0f be d0             	movsbl %al,%edx
  80052c:	85 d2                	test   %edx,%edx
  80052e:	74 4b                	je     80057b <vprintfmt+0x245>
  800530:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800534:	78 06                	js     80053c <vprintfmt+0x206>
  800536:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80053a:	78 1e                	js     80055a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80053c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800540:	74 d1                	je     800513 <vprintfmt+0x1dd>
  800542:	0f be c0             	movsbl %al,%eax
  800545:	83 e8 20             	sub    $0x20,%eax
  800548:	83 f8 5e             	cmp    $0x5e,%eax
  80054b:	76 c6                	jbe    800513 <vprintfmt+0x1dd>
					putch('?', putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	53                   	push   %ebx
  800551:	6a 3f                	push   $0x3f
  800553:	ff d6                	call   *%esi
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	eb c3                	jmp    80051d <vprintfmt+0x1e7>
  80055a:	89 cf                	mov    %ecx,%edi
  80055c:	eb 0e                	jmp    80056c <vprintfmt+0x236>
				putch(' ', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 20                	push   $0x20
  800564:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800566:	83 ef 01             	sub    $0x1,%edi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	85 ff                	test   %edi,%edi
  80056e:	7f ee                	jg     80055e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800570:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800573:	89 45 14             	mov    %eax,0x14(%ebp)
  800576:	e9 01 02 00 00       	jmp    80077c <vprintfmt+0x446>
  80057b:	89 cf                	mov    %ecx,%edi
  80057d:	eb ed                	jmp    80056c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80057f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800582:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800589:	e9 eb fd ff ff       	jmp    800379 <vprintfmt+0x43>
	if (lflag >= 2)
  80058e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800592:	7f 21                	jg     8005b5 <vprintfmt+0x27f>
	else if (lflag)
  800594:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800598:	74 68                	je     800602 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a2:	89 c1                	mov    %eax,%ecx
  8005a4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 04             	lea    0x4(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b3:	eb 17                	jmp    8005cc <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 50 04             	mov    0x4(%eax),%edx
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 08             	lea    0x8(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005dc:	78 3f                	js     80061d <vprintfmt+0x2e7>
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005e3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e7:	0f 84 71 01 00 00    	je     80075e <vprintfmt+0x428>
				putch('+', putdat);
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	6a 2b                	push   $0x2b
  8005f3:	ff d6                	call   *%esi
  8005f5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fd:	e9 5c 01 00 00       	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, int);
  800602:	8b 45 14             	mov    0x14(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80060a:	89 c1                	mov    %eax,%ecx
  80060c:	c1 f9 1f             	sar    $0x1f,%ecx
  80060f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8d 40 04             	lea    0x4(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
  80061b:	eb af                	jmp    8005cc <vprintfmt+0x296>
				putch('-', putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	53                   	push   %ebx
  800621:	6a 2d                	push   $0x2d
  800623:	ff d6                	call   *%esi
				num = -(long long) num;
  800625:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800628:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80062b:	f7 d8                	neg    %eax
  80062d:	83 d2 00             	adc    $0x0,%edx
  800630:	f7 da                	neg    %edx
  800632:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800635:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800638:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80063b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800640:	e9 19 01 00 00       	jmp    80075e <vprintfmt+0x428>
	if (lflag >= 2)
  800645:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800649:	7f 29                	jg     800674 <vprintfmt+0x33e>
	else if (lflag)
  80064b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064f:	74 44                	je     800695 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 00                	mov    (%eax),%eax
  800656:	ba 00 00 00 00       	mov    $0x0,%edx
  80065b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066f:	e9 ea 00 00 00       	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8b 50 04             	mov    0x4(%eax),%edx
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 08             	lea    0x8(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800690:	e9 c9 00 00 00       	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 04             	lea    0x4(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b3:	e9 a6 00 00 00       	jmp    80075e <vprintfmt+0x428>
			putch('0', putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	6a 30                	push   $0x30
  8006be:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c7:	7f 26                	jg     8006ef <vprintfmt+0x3b9>
	else if (lflag)
  8006c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cd:	74 3e                	je     80070d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ed:	eb 6f                	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 50 04             	mov    0x4(%eax),%edx
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 08             	lea    0x8(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800706:	b8 08 00 00 00       	mov    $0x8,%eax
  80070b:	eb 51                	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	ba 00 00 00 00       	mov    $0x0,%edx
  800717:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 40 04             	lea    0x4(%eax),%eax
  800723:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800726:	b8 08 00 00 00       	mov    $0x8,%eax
  80072b:	eb 31                	jmp    80075e <vprintfmt+0x428>
			putch('0', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	6a 30                	push   $0x30
  800733:	ff d6                	call   *%esi
			putch('x', putdat);
  800735:	83 c4 08             	add    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 78                	push   $0x78
  80073b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80074d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 40 04             	lea    0x4(%eax),%eax
  800756:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800759:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800765:	52                   	push   %edx
  800766:	ff 75 e0             	pushl  -0x20(%ebp)
  800769:	50                   	push   %eax
  80076a:	ff 75 dc             	pushl  -0x24(%ebp)
  80076d:	ff 75 d8             	pushl  -0x28(%ebp)
  800770:	89 da                	mov    %ebx,%edx
  800772:	89 f0                	mov    %esi,%eax
  800774:	e8 a4 fa ff ff       	call   80021d <printnum>
			break;
  800779:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80077c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	83 c7 01             	add    $0x1,%edi
  800782:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800786:	83 f8 25             	cmp    $0x25,%eax
  800789:	0f 84 be fb ff ff    	je     80034d <vprintfmt+0x17>
			if (ch == '\0')
  80078f:	85 c0                	test   %eax,%eax
  800791:	0f 84 28 01 00 00    	je     8008bf <vprintfmt+0x589>
			putch(ch, putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	50                   	push   %eax
  80079c:	ff d6                	call   *%esi
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	eb dc                	jmp    80077f <vprintfmt+0x449>
	if (lflag >= 2)
  8007a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007a7:	7f 26                	jg     8007cf <vprintfmt+0x499>
	else if (lflag)
  8007a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ad:	74 41                	je     8007f0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 40 04             	lea    0x4(%eax),%eax
  8007c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cd:	eb 8f                	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 50 04             	mov    0x4(%eax),%edx
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 40 08             	lea    0x8(%eax),%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007eb:	e9 6e ff ff ff       	jmp    80075e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 40 04             	lea    0x4(%eax),%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800809:	b8 10 00 00 00       	mov    $0x10,%eax
  80080e:	e9 4b ff ff ff       	jmp    80075e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	85 c0                	test   %eax,%eax
  800823:	74 14                	je     800839 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800825:	8b 13                	mov    (%ebx),%edx
  800827:	83 fa 7f             	cmp    $0x7f,%edx
  80082a:	7f 37                	jg     800863 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80082c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
  800834:	e9 43 ff ff ff       	jmp    80077c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083e:	bf 3d 27 80 00       	mov    $0x80273d,%edi
							putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	50                   	push   %eax
  800848:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084a:	83 c7 01             	add    $0x1,%edi
  80084d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	85 c0                	test   %eax,%eax
  800856:	75 eb                	jne    800843 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800858:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
  80085e:	e9 19 ff ff ff       	jmp    80077c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800863:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800865:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086a:	bf 75 27 80 00       	mov    $0x802775,%edi
							putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	50                   	push   %eax
  800874:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800876:	83 c7 01             	add    $0x1,%edi
  800879:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	85 c0                	test   %eax,%eax
  800882:	75 eb                	jne    80086f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800884:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	e9 ed fe ff ff       	jmp    80077c <vprintfmt+0x446>
			putch(ch, putdat);
  80088f:	83 ec 08             	sub    $0x8,%esp
  800892:	53                   	push   %ebx
  800893:	6a 25                	push   $0x25
  800895:	ff d6                	call   *%esi
			break;
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	e9 dd fe ff ff       	jmp    80077c <vprintfmt+0x446>
			putch('%', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 25                	push   $0x25
  8008a5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	89 f8                	mov    %edi,%eax
  8008ac:	eb 03                	jmp    8008b1 <vprintfmt+0x57b>
  8008ae:	83 e8 01             	sub    $0x1,%eax
  8008b1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008b5:	75 f7                	jne    8008ae <vprintfmt+0x578>
  8008b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ba:	e9 bd fe ff ff       	jmp    80077c <vprintfmt+0x446>
}
  8008bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008c2:	5b                   	pop    %ebx
  8008c3:	5e                   	pop    %esi
  8008c4:	5f                   	pop    %edi
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	83 ec 18             	sub    $0x18,%esp
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	74 26                	je     80090e <vsnprintf+0x47>
  8008e8:	85 d2                	test   %edx,%edx
  8008ea:	7e 22                	jle    80090e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ec:	ff 75 14             	pushl  0x14(%ebp)
  8008ef:	ff 75 10             	pushl  0x10(%ebp)
  8008f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f5:	50                   	push   %eax
  8008f6:	68 fc 02 80 00       	push   $0x8002fc
  8008fb:	e8 36 fa ff ff       	call   800336 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800903:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	c9                   	leave  
  80090d:	c3                   	ret    
		return -E_INVAL;
  80090e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800913:	eb f7                	jmp    80090c <vsnprintf+0x45>

00800915 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80091b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80091e:	50                   	push   %eax
  80091f:	ff 75 10             	pushl  0x10(%ebp)
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	ff 75 08             	pushl  0x8(%ebp)
  800928:	e8 9a ff ff ff       	call   8008c7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    

0080092f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
  80093a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80093e:	74 05                	je     800945 <strlen+0x16>
		n++;
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	eb f5                	jmp    80093a <strlen+0xb>
	return n;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800950:	ba 00 00 00 00       	mov    $0x0,%edx
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 0d                	je     800966 <strnlen+0x1f>
  800959:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80095d:	74 05                	je     800964 <strnlen+0x1d>
		n++;
  80095f:	83 c2 01             	add    $0x1,%edx
  800962:	eb f1                	jmp    800955 <strnlen+0xe>
  800964:	89 d0                	mov    %edx,%eax
	return n;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
  800977:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80097e:	83 c2 01             	add    $0x1,%edx
  800981:	84 c9                	test   %cl,%cl
  800983:	75 f2                	jne    800977 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800985:	5b                   	pop    %ebx
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	53                   	push   %ebx
  80098c:	83 ec 10             	sub    $0x10,%esp
  80098f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800992:	53                   	push   %ebx
  800993:	e8 97 ff ff ff       	call   80092f <strlen>
  800998:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	01 d8                	add    %ebx,%eax
  8009a0:	50                   	push   %eax
  8009a1:	e8 c2 ff ff ff       	call   800968 <strcpy>
	return dst;
}
  8009a6:	89 d8                	mov    %ebx,%eax
  8009a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b8:	89 c6                	mov    %eax,%esi
  8009ba:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	39 f2                	cmp    %esi,%edx
  8009c1:	74 11                	je     8009d4 <strncpy+0x27>
		*dst++ = *src;
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	0f b6 19             	movzbl (%ecx),%ebx
  8009c9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009cc:	80 fb 01             	cmp    $0x1,%bl
  8009cf:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009d2:	eb eb                	jmp    8009bf <strncpy+0x12>
	}
	return ret;
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009e6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e8:	85 d2                	test   %edx,%edx
  8009ea:	74 21                	je     800a0d <strlcpy+0x35>
  8009ec:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009f0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009f2:	39 c2                	cmp    %eax,%edx
  8009f4:	74 14                	je     800a0a <strlcpy+0x32>
  8009f6:	0f b6 19             	movzbl (%ecx),%ebx
  8009f9:	84 db                	test   %bl,%bl
  8009fb:	74 0b                	je     800a08 <strlcpy+0x30>
			*dst++ = *src++;
  8009fd:	83 c1 01             	add    $0x1,%ecx
  800a00:	83 c2 01             	add    $0x1,%edx
  800a03:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a06:	eb ea                	jmp    8009f2 <strlcpy+0x1a>
  800a08:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a0a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0d:	29 f0                	sub    %esi,%eax
}
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a1c:	0f b6 01             	movzbl (%ecx),%eax
  800a1f:	84 c0                	test   %al,%al
  800a21:	74 0c                	je     800a2f <strcmp+0x1c>
  800a23:	3a 02                	cmp    (%edx),%al
  800a25:	75 08                	jne    800a2f <strcmp+0x1c>
		p++, q++;
  800a27:	83 c1 01             	add    $0x1,%ecx
  800a2a:	83 c2 01             	add    $0x1,%edx
  800a2d:	eb ed                	jmp    800a1c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2f:	0f b6 c0             	movzbl %al,%eax
  800a32:	0f b6 12             	movzbl (%edx),%edx
  800a35:	29 d0                	sub    %edx,%eax
}
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	89 c3                	mov    %eax,%ebx
  800a45:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a48:	eb 06                	jmp    800a50 <strncmp+0x17>
		n--, p++, q++;
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a50:	39 d8                	cmp    %ebx,%eax
  800a52:	74 16                	je     800a6a <strncmp+0x31>
  800a54:	0f b6 08             	movzbl (%eax),%ecx
  800a57:	84 c9                	test   %cl,%cl
  800a59:	74 04                	je     800a5f <strncmp+0x26>
  800a5b:	3a 0a                	cmp    (%edx),%cl
  800a5d:	74 eb                	je     800a4a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5f:	0f b6 00             	movzbl (%eax),%eax
  800a62:	0f b6 12             	movzbl (%edx),%edx
  800a65:	29 d0                	sub    %edx,%eax
}
  800a67:	5b                   	pop    %ebx
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    
		return 0;
  800a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6f:	eb f6                	jmp    800a67 <strncmp+0x2e>

00800a71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7b:	0f b6 10             	movzbl (%eax),%edx
  800a7e:	84 d2                	test   %dl,%dl
  800a80:	74 09                	je     800a8b <strchr+0x1a>
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 0a                	je     800a90 <strchr+0x1f>
	for (; *s; s++)
  800a86:	83 c0 01             	add    $0x1,%eax
  800a89:	eb f0                	jmp    800a7b <strchr+0xa>
			return (char *) s;
	return 0;
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a9c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a9f:	38 ca                	cmp    %cl,%dl
  800aa1:	74 09                	je     800aac <strfind+0x1a>
  800aa3:	84 d2                	test   %dl,%dl
  800aa5:	74 05                	je     800aac <strfind+0x1a>
	for (; *s; s++)
  800aa7:	83 c0 01             	add    $0x1,%eax
  800aaa:	eb f0                	jmp    800a9c <strfind+0xa>
			break;
	return (char *) s;
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aba:	85 c9                	test   %ecx,%ecx
  800abc:	74 31                	je     800aef <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800abe:	89 f8                	mov    %edi,%eax
  800ac0:	09 c8                	or     %ecx,%eax
  800ac2:	a8 03                	test   $0x3,%al
  800ac4:	75 23                	jne    800ae9 <memset+0x3b>
		c &= 0xFF;
  800ac6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aca:	89 d3                	mov    %edx,%ebx
  800acc:	c1 e3 08             	shl    $0x8,%ebx
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	c1 e0 18             	shl    $0x18,%eax
  800ad4:	89 d6                	mov    %edx,%esi
  800ad6:	c1 e6 10             	shl    $0x10,%esi
  800ad9:	09 f0                	or     %esi,%eax
  800adb:	09 c2                	or     %eax,%edx
  800add:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800adf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	fc                   	cld    
  800ae5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae7:	eb 06                	jmp    800aef <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	fc                   	cld    
  800aed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aef:	89 f8                	mov    %edi,%eax
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5f                   	pop    %edi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b04:	39 c6                	cmp    %eax,%esi
  800b06:	73 32                	jae    800b3a <memmove+0x44>
  800b08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	76 2b                	jbe    800b3a <memmove+0x44>
		s += n;
		d += n;
  800b0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b12:	89 fe                	mov    %edi,%esi
  800b14:	09 ce                	or     %ecx,%esi
  800b16:	09 d6                	or     %edx,%esi
  800b18:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1e:	75 0e                	jne    800b2e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b20:	83 ef 04             	sub    $0x4,%edi
  800b23:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b29:	fd                   	std    
  800b2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2c:	eb 09                	jmp    800b37 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2e:	83 ef 01             	sub    $0x1,%edi
  800b31:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b34:	fd                   	std    
  800b35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b37:	fc                   	cld    
  800b38:	eb 1a                	jmp    800b54 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3a:	89 c2                	mov    %eax,%edx
  800b3c:	09 ca                	or     %ecx,%edx
  800b3e:	09 f2                	or     %esi,%edx
  800b40:	f6 c2 03             	test   $0x3,%dl
  800b43:	75 0a                	jne    800b4f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b45:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b48:	89 c7                	mov    %eax,%edi
  800b4a:	fc                   	cld    
  800b4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4d:	eb 05                	jmp    800b54 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b4f:	89 c7                	mov    %eax,%edi
  800b51:	fc                   	cld    
  800b52:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5e:	ff 75 10             	pushl  0x10(%ebp)
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	ff 75 08             	pushl  0x8(%ebp)
  800b67:	e8 8a ff ff ff       	call   800af6 <memmove>
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b79:	89 c6                	mov    %eax,%esi
  800b7b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7e:	39 f0                	cmp    %esi,%eax
  800b80:	74 1c                	je     800b9e <memcmp+0x30>
		if (*s1 != *s2)
  800b82:	0f b6 08             	movzbl (%eax),%ecx
  800b85:	0f b6 1a             	movzbl (%edx),%ebx
  800b88:	38 d9                	cmp    %bl,%cl
  800b8a:	75 08                	jne    800b94 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8c:	83 c0 01             	add    $0x1,%eax
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	eb ea                	jmp    800b7e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b94:	0f b6 c1             	movzbl %cl,%eax
  800b97:	0f b6 db             	movzbl %bl,%ebx
  800b9a:	29 d8                	sub    %ebx,%eax
  800b9c:	eb 05                	jmp    800ba3 <memcmp+0x35>
	}

	return 0;
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb0:	89 c2                	mov    %eax,%edx
  800bb2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb5:	39 d0                	cmp    %edx,%eax
  800bb7:	73 09                	jae    800bc2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb9:	38 08                	cmp    %cl,(%eax)
  800bbb:	74 05                	je     800bc2 <memfind+0x1b>
	for (; s < ends; s++)
  800bbd:	83 c0 01             	add    $0x1,%eax
  800bc0:	eb f3                	jmp    800bb5 <memfind+0xe>
			break;
	return (void *) s;
}
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd0:	eb 03                	jmp    800bd5 <strtol+0x11>
		s++;
  800bd2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd5:	0f b6 01             	movzbl (%ecx),%eax
  800bd8:	3c 20                	cmp    $0x20,%al
  800bda:	74 f6                	je     800bd2 <strtol+0xe>
  800bdc:	3c 09                	cmp    $0x9,%al
  800bde:	74 f2                	je     800bd2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800be0:	3c 2b                	cmp    $0x2b,%al
  800be2:	74 2a                	je     800c0e <strtol+0x4a>
	int neg = 0;
  800be4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be9:	3c 2d                	cmp    $0x2d,%al
  800beb:	74 2b                	je     800c18 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bed:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf3:	75 0f                	jne    800c04 <strtol+0x40>
  800bf5:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf8:	74 28                	je     800c22 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bfa:	85 db                	test   %ebx,%ebx
  800bfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c01:	0f 44 d8             	cmove  %eax,%ebx
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
  800c09:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0c:	eb 50                	jmp    800c5e <strtol+0x9a>
		s++;
  800c0e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c11:	bf 00 00 00 00       	mov    $0x0,%edi
  800c16:	eb d5                	jmp    800bed <strtol+0x29>
		s++, neg = 1;
  800c18:	83 c1 01             	add    $0x1,%ecx
  800c1b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c20:	eb cb                	jmp    800bed <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c22:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c26:	74 0e                	je     800c36 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c28:	85 db                	test   %ebx,%ebx
  800c2a:	75 d8                	jne    800c04 <strtol+0x40>
		s++, base = 8;
  800c2c:	83 c1 01             	add    $0x1,%ecx
  800c2f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c34:	eb ce                	jmp    800c04 <strtol+0x40>
		s += 2, base = 16;
  800c36:	83 c1 02             	add    $0x2,%ecx
  800c39:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3e:	eb c4                	jmp    800c04 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c40:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c43:	89 f3                	mov    %esi,%ebx
  800c45:	80 fb 19             	cmp    $0x19,%bl
  800c48:	77 29                	ja     800c73 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c4a:	0f be d2             	movsbl %dl,%edx
  800c4d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c50:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c53:	7d 30                	jge    800c85 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c55:	83 c1 01             	add    $0x1,%ecx
  800c58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5e:	0f b6 11             	movzbl (%ecx),%edx
  800c61:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c64:	89 f3                	mov    %esi,%ebx
  800c66:	80 fb 09             	cmp    $0x9,%bl
  800c69:	77 d5                	ja     800c40 <strtol+0x7c>
			dig = *s - '0';
  800c6b:	0f be d2             	movsbl %dl,%edx
  800c6e:	83 ea 30             	sub    $0x30,%edx
  800c71:	eb dd                	jmp    800c50 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c73:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c76:	89 f3                	mov    %esi,%ebx
  800c78:	80 fb 19             	cmp    $0x19,%bl
  800c7b:	77 08                	ja     800c85 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c7d:	0f be d2             	movsbl %dl,%edx
  800c80:	83 ea 37             	sub    $0x37,%edx
  800c83:	eb cb                	jmp    800c50 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c89:	74 05                	je     800c90 <strtol+0xcc>
		*endptr = (char *) s;
  800c8b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c90:	89 c2                	mov    %eax,%edx
  800c92:	f7 da                	neg    %edx
  800c94:	85 ff                	test   %edi,%edi
  800c96:	0f 45 c2             	cmovne %edx,%eax
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	5d                   	pop    %ebp
  800c9d:	c3                   	ret    

00800c9e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	89 c3                	mov    %eax,%ebx
  800cb1:	89 c7                	mov    %eax,%edi
  800cb3:	89 c6                	mov    %eax,%esi
  800cb5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccc:	89 d1                	mov    %edx,%ecx
  800cce:	89 d3                	mov    %edx,%ebx
  800cd0:	89 d7                	mov    %edx,%edi
  800cd2:	89 d6                	mov    %edx,%esi
  800cd4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf1:	89 cb                	mov    %ecx,%ebx
  800cf3:	89 cf                	mov    %ecx,%edi
  800cf5:	89 ce                	mov    %ecx,%esi
  800cf7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	7f 08                	jg     800d05 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d05:	83 ec 0c             	sub    $0xc,%esp
  800d08:	50                   	push   %eax
  800d09:	6a 03                	push   $0x3
  800d0b:	68 88 29 80 00       	push   $0x802988
  800d10:	6a 43                	push   $0x43
  800d12:	68 a5 29 80 00       	push   $0x8029a5
  800d17:	e8 89 14 00 00       	call   8021a5 <_panic>

00800d1c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	57                   	push   %edi
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d22:	ba 00 00 00 00       	mov    $0x0,%edx
  800d27:	b8 02 00 00 00       	mov    $0x2,%eax
  800d2c:	89 d1                	mov    %edx,%ecx
  800d2e:	89 d3                	mov    %edx,%ebx
  800d30:	89 d7                	mov    %edx,%edi
  800d32:	89 d6                	mov    %edx,%esi
  800d34:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <sys_yield>:

void
sys_yield(void)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d41:	ba 00 00 00 00       	mov    $0x0,%edx
  800d46:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d4b:	89 d1                	mov    %edx,%ecx
  800d4d:	89 d3                	mov    %edx,%ebx
  800d4f:	89 d7                	mov    %edx,%edi
  800d51:	89 d6                	mov    %edx,%esi
  800d53:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d63:	be 00 00 00 00       	mov    $0x0,%esi
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d76:	89 f7                	mov    %esi,%edi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 04                	push   $0x4
  800d8c:	68 88 29 80 00       	push   $0x802988
  800d91:	6a 43                	push   $0x43
  800d93:	68 a5 29 80 00       	push   $0x8029a5
  800d98:	e8 08 14 00 00       	call   8021a5 <_panic>

00800d9d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	b8 05 00 00 00       	mov    $0x5,%eax
  800db1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db7:	8b 75 18             	mov    0x18(%ebp),%esi
  800dba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7f 08                	jg     800dc8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 05                	push   $0x5
  800dce:	68 88 29 80 00       	push   $0x802988
  800dd3:	6a 43                	push   $0x43
  800dd5:	68 a5 29 80 00       	push   $0x8029a5
  800dda:	e8 c6 13 00 00       	call   8021a5 <_panic>

00800ddf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	b8 06 00 00 00       	mov    $0x6,%eax
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	89 de                	mov    %ebx,%esi
  800dfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7f 08                	jg     800e0a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 06                	push   $0x6
  800e10:	68 88 29 80 00       	push   $0x802988
  800e15:	6a 43                	push   $0x43
  800e17:	68 a5 29 80 00       	push   $0x8029a5
  800e1c:	e8 84 13 00 00       	call   8021a5 <_panic>

00800e21 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	89 de                	mov    %ebx,%esi
  800e3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 08                	push   $0x8
  800e52:	68 88 29 80 00       	push   $0x802988
  800e57:	6a 43                	push   $0x43
  800e59:	68 a5 29 80 00       	push   $0x8029a5
  800e5e:	e8 42 13 00 00       	call   8021a5 <_panic>

00800e63 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e77:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7c:	89 df                	mov    %ebx,%edi
  800e7e:	89 de                	mov    %ebx,%esi
  800e80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7f 08                	jg     800e8e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 09                	push   $0x9
  800e94:	68 88 29 80 00       	push   $0x802988
  800e99:	6a 43                	push   $0x43
  800e9b:	68 a5 29 80 00       	push   $0x8029a5
  800ea0:	e8 00 13 00 00       	call   8021a5 <_panic>

00800ea5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7f 08                	jg     800ed0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 0a                	push   $0xa
  800ed6:	68 88 29 80 00       	push   $0x802988
  800edb:	6a 43                	push   $0x43
  800edd:	68 a5 29 80 00       	push   $0x8029a5
  800ee2:	e8 be 12 00 00       	call   8021a5 <_panic>

00800ee7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef8:	be 00 00 00 00       	mov    $0x0,%esi
  800efd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f00:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f03:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f13:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f20:	89 cb                	mov    %ecx,%ebx
  800f22:	89 cf                	mov    %ecx,%edi
  800f24:	89 ce                	mov    %ecx,%esi
  800f26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7f 08                	jg     800f34 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 0d                	push   $0xd
  800f3a:	68 88 29 80 00       	push   $0x802988
  800f3f:	6a 43                	push   $0x43
  800f41:	68 a5 29 80 00       	push   $0x8029a5
  800f46:	e8 5a 12 00 00       	call   8021a5 <_panic>

00800f4b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f61:	89 df                	mov    %ebx,%edi
  800f63:	89 de                	mov    %ebx,%esi
  800f65:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7f:	89 cb                	mov    %ecx,%ebx
  800f81:	89 cf                	mov    %ecx,%edi
  800f83:	89 ce                	mov    %ecx,%esi
  800f85:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f87:	5b                   	pop    %ebx
  800f88:	5e                   	pop    %esi
  800f89:	5f                   	pop    %edi
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	57                   	push   %edi
  800f90:	56                   	push   %esi
  800f91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f92:	ba 00 00 00 00       	mov    $0x0,%edx
  800f97:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9c:	89 d1                	mov    %edx,%ecx
  800f9e:	89 d3                	mov    %edx,%ebx
  800fa0:	89 d7                	mov    %edx,%edi
  800fa2:	89 d6                	mov    %edx,%esi
  800fa4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	b8 11 00 00 00       	mov    $0x11,%eax
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	b8 12 00 00 00       	mov    $0x12,%eax
  800fe2:	89 df                	mov    %ebx,%edi
  800fe4:	89 de                	mov    %ebx,%esi
  800fe6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801001:	b8 13 00 00 00       	mov    $0x13,%eax
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	7f 08                	jg     801018 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	50                   	push   %eax
  80101c:	6a 13                	push   $0x13
  80101e:	68 88 29 80 00       	push   $0x802988
  801023:	6a 43                	push   $0x43
  801025:	68 a5 29 80 00       	push   $0x8029a5
  80102a:	e8 76 11 00 00       	call   8021a5 <_panic>

0080102f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	57                   	push   %edi
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
	asm volatile("int %1\n"
  801035:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103a:	8b 55 08             	mov    0x8(%ebp),%edx
  80103d:	b8 14 00 00 00       	mov    $0x14,%eax
  801042:	89 cb                	mov    %ecx,%ebx
  801044:	89 cf                	mov    %ecx,%edi
  801046:	89 ce                	mov    %ecx,%esi
  801048:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80104a:	5b                   	pop    %ebx
  80104b:	5e                   	pop    %esi
  80104c:	5f                   	pop    %edi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	05 00 00 00 30       	add    $0x30000000,%eax
  80105a:	c1 e8 0c             	shr    $0xc,%eax
}
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    

0080105f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80106a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80106f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80107e:	89 c2                	mov    %eax,%edx
  801080:	c1 ea 16             	shr    $0x16,%edx
  801083:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108a:	f6 c2 01             	test   $0x1,%dl
  80108d:	74 2d                	je     8010bc <fd_alloc+0x46>
  80108f:	89 c2                	mov    %eax,%edx
  801091:	c1 ea 0c             	shr    $0xc,%edx
  801094:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109b:	f6 c2 01             	test   $0x1,%dl
  80109e:	74 1c                	je     8010bc <fd_alloc+0x46>
  8010a0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010aa:	75 d2                	jne    80107e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ba:	eb 0a                	jmp    8010c6 <fd_alloc+0x50>
			*fd_store = fd;
  8010bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ce:	83 f8 1f             	cmp    $0x1f,%eax
  8010d1:	77 30                	ja     801103 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d3:	c1 e0 0c             	shl    $0xc,%eax
  8010d6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010db:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010e1:	f6 c2 01             	test   $0x1,%dl
  8010e4:	74 24                	je     80110a <fd_lookup+0x42>
  8010e6:	89 c2                	mov    %eax,%edx
  8010e8:	c1 ea 0c             	shr    $0xc,%edx
  8010eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f2:	f6 c2 01             	test   $0x1,%dl
  8010f5:	74 1a                	je     801111 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fa:	89 02                	mov    %eax,(%edx)
	return 0;
  8010fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    
		return -E_INVAL;
  801103:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801108:	eb f7                	jmp    801101 <fd_lookup+0x39>
		return -E_INVAL;
  80110a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110f:	eb f0                	jmp    801101 <fd_lookup+0x39>
  801111:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801116:	eb e9                	jmp    801101 <fd_lookup+0x39>

00801118 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80112b:	39 08                	cmp    %ecx,(%eax)
  80112d:	74 38                	je     801167 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80112f:	83 c2 01             	add    $0x1,%edx
  801132:	8b 04 95 30 2a 80 00 	mov    0x802a30(,%edx,4),%eax
  801139:	85 c0                	test   %eax,%eax
  80113b:	75 ee                	jne    80112b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113d:	a1 08 40 80 00       	mov    0x804008,%eax
  801142:	8b 40 48             	mov    0x48(%eax),%eax
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	51                   	push   %ecx
  801149:	50                   	push   %eax
  80114a:	68 b4 29 80 00       	push   $0x8029b4
  80114f:	e8 b5 f0 ff ff       	call   800209 <cprintf>
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
  801171:	eb f2                	jmp    801165 <dev_lookup+0x4d>

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
  801190:	e8 33 ff ff ff       	call   8010c8 <fd_lookup>
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
  8011c2:	e8 51 ff ff ff       	call   801118 <dev_lookup>
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
  8011f0:	e8 ea fb ff ff       	call   800ddf <sys_page_unmap>
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
  801207:	e8 bc fe ff ff       	call   8010c8 <fd_lookup>
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
  80125c:	e8 67 fe ff ff       	call   8010c8 <fd_lookup>
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
  80128b:	e8 cf fd ff ff       	call   80105f <fd2data>
  801290:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801292:	89 34 24             	mov    %esi,(%esp)
  801295:	e8 c5 fd ff ff       	call   80105f <fd2data>
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
  8012de:	e8 ba fa ff ff       	call   800d9d <sys_page_map>
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
  80130f:	e8 89 fa ff ff       	call   800d9d <sys_page_map>
  801314:	89 c3                	mov    %eax,%ebx
  801316:	83 c4 20             	add    $0x20,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	79 a3                	jns    8012c0 <dup+0x74>
	sys_page_unmap(0, newfd);
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	56                   	push   %esi
  801321:	6a 00                	push   $0x0
  801323:	e8 b7 fa ff ff       	call   800ddf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	57                   	push   %edi
  80132c:	6a 00                	push   $0x0
  80132e:	e8 ac fa ff ff       	call   800ddf <sys_page_unmap>
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
  801347:	e8 7c fd ff ff       	call   8010c8 <fd_lookup>
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 3f                	js     801392 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	ff 30                	pushl  (%eax)
  80135f:	e8 b4 fd ff ff       	call   801118 <dev_lookup>
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
  801397:	a1 08 40 80 00       	mov    0x804008,%eax
  80139c:	8b 40 48             	mov    0x48(%eax),%eax
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	53                   	push   %ebx
  8013a3:	50                   	push   %eax
  8013a4:	68 f5 29 80 00       	push   $0x8029f5
  8013a9:	e8 5b ee ff ff       	call   800209 <cprintf>
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
  801413:	e8 b0 fc ff ff       	call   8010c8 <fd_lookup>
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 3a                	js     801459 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801425:	50                   	push   %eax
  801426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801429:	ff 30                	pushl  (%eax)
  80142b:	e8 e8 fc ff ff       	call   801118 <dev_lookup>
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
  80145e:	a1 08 40 80 00       	mov    0x804008,%eax
  801463:	8b 40 48             	mov    0x48(%eax),%eax
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	53                   	push   %ebx
  80146a:	50                   	push   %eax
  80146b:	68 11 2a 80 00       	push   $0x802a11
  801470:	e8 94 ed ff ff       	call   800209 <cprintf>
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
  801493:	e8 30 fc ff ff       	call   8010c8 <fd_lookup>
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
  8014be:	e8 05 fc ff ff       	call   8010c8 <fd_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 37                	js     801501 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d4:	ff 30                	pushl  (%eax)
  8014d6:	e8 3d fc ff ff       	call   801118 <dev_lookup>
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
  801506:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80150b:	8b 40 48             	mov    0x48(%eax),%eax
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	53                   	push   %ebx
  801512:	50                   	push   %eax
  801513:	68 d4 29 80 00       	push   $0x8029d4
  801518:	e8 ec ec ff ff       	call   800209 <cprintf>
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
  80153f:	e8 84 fb ff ff       	call   8010c8 <fd_lookup>
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 4b                	js     801596 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	ff 30                	pushl  (%eax)
  801557:	e8 bc fb ff ff       	call   801118 <dev_lookup>
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
  8015af:	e8 22 02 00 00       	call   8017d6 <open>
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
  801601:	e8 69 0c 00 00       	call   80226f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801606:	83 c4 0c             	add    $0xc,%esp
  801609:	6a 00                	push   $0x0
  80160b:	53                   	push   %ebx
  80160c:	6a 00                	push   $0x0
  80160e:	e8 f3 0b 00 00       	call   802206 <ipc_recv>
}
  801613:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801616:	5b                   	pop    %ebx
  801617:	5e                   	pop    %esi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80161a:	83 ec 0c             	sub    $0xc,%esp
  80161d:	6a 01                	push   $0x1
  80161f:	e8 a3 0c 00 00       	call   8022c7 <ipc_find_env>
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
  8016ab:	e8 b8 f2 ff ff       	call   800968 <strcpy>
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
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016e8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016ee:	53                   	push   %ebx
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	68 08 50 80 00       	push   $0x805008
  8016f7:	e8 5c f4 ff ff       	call   800b58 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801701:	b8 04 00 00 00       	mov    $0x4,%eax
  801706:	e8 d6 fe ff ff       	call   8015e1 <fsipc>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	85 c0                	test   %eax,%eax
  801710:	78 0b                	js     80171d <devfile_write+0x4a>
	assert(r <= n);
  801712:	39 d8                	cmp    %ebx,%eax
  801714:	77 0c                	ja     801722 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801716:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80171b:	7f 1e                	jg     80173b <devfile_write+0x68>
}
  80171d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801720:	c9                   	leave  
  801721:	c3                   	ret    
	assert(r <= n);
  801722:	68 44 2a 80 00       	push   $0x802a44
  801727:	68 4b 2a 80 00       	push   $0x802a4b
  80172c:	68 98 00 00 00       	push   $0x98
  801731:	68 60 2a 80 00       	push   $0x802a60
  801736:	e8 6a 0a 00 00       	call   8021a5 <_panic>
	assert(r <= PGSIZE);
  80173b:	68 6b 2a 80 00       	push   $0x802a6b
  801740:	68 4b 2a 80 00       	push   $0x802a4b
  801745:	68 99 00 00 00       	push   $0x99
  80174a:	68 60 2a 80 00       	push   $0x802a60
  80174f:	e8 51 0a 00 00       	call   8021a5 <_panic>

00801754 <devfile_read>:
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	56                   	push   %esi
  801758:	53                   	push   %ebx
  801759:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8b 40 0c             	mov    0xc(%eax),%eax
  801762:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801767:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	b8 03 00 00 00       	mov    $0x3,%eax
  801777:	e8 65 fe ff ff       	call   8015e1 <fsipc>
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 1f                	js     8017a1 <devfile_read+0x4d>
	assert(r <= n);
  801782:	39 f0                	cmp    %esi,%eax
  801784:	77 24                	ja     8017aa <devfile_read+0x56>
	assert(r <= PGSIZE);
  801786:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80178b:	7f 33                	jg     8017c0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	50                   	push   %eax
  801791:	68 00 50 80 00       	push   $0x805000
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	e8 58 f3 ff ff       	call   800af6 <memmove>
	return r;
  80179e:	83 c4 10             	add    $0x10,%esp
}
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    
	assert(r <= n);
  8017aa:	68 44 2a 80 00       	push   $0x802a44
  8017af:	68 4b 2a 80 00       	push   $0x802a4b
  8017b4:	6a 7c                	push   $0x7c
  8017b6:	68 60 2a 80 00       	push   $0x802a60
  8017bb:	e8 e5 09 00 00       	call   8021a5 <_panic>
	assert(r <= PGSIZE);
  8017c0:	68 6b 2a 80 00       	push   $0x802a6b
  8017c5:	68 4b 2a 80 00       	push   $0x802a4b
  8017ca:	6a 7d                	push   $0x7d
  8017cc:	68 60 2a 80 00       	push   $0x802a60
  8017d1:	e8 cf 09 00 00       	call   8021a5 <_panic>

008017d6 <open>:
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 1c             	sub    $0x1c,%esp
  8017de:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017e1:	56                   	push   %esi
  8017e2:	e8 48 f1 ff ff       	call   80092f <strlen>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ef:	7f 6c                	jg     80185d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017f1:	83 ec 0c             	sub    $0xc,%esp
  8017f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f7:	50                   	push   %eax
  8017f8:	e8 79 f8 ff ff       	call   801076 <fd_alloc>
  8017fd:	89 c3                	mov    %eax,%ebx
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	85 c0                	test   %eax,%eax
  801804:	78 3c                	js     801842 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801806:	83 ec 08             	sub    $0x8,%esp
  801809:	56                   	push   %esi
  80180a:	68 00 50 80 00       	push   $0x805000
  80180f:	e8 54 f1 ff ff       	call   800968 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801814:	8b 45 0c             	mov    0xc(%ebp),%eax
  801817:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80181c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181f:	b8 01 00 00 00       	mov    $0x1,%eax
  801824:	e8 b8 fd ff ff       	call   8015e1 <fsipc>
  801829:	89 c3                	mov    %eax,%ebx
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 19                	js     80184b <open+0x75>
	return fd2num(fd);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	ff 75 f4             	pushl  -0xc(%ebp)
  801838:	e8 12 f8 ff ff       	call   80104f <fd2num>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
}
  801842:	89 d8                	mov    %ebx,%eax
  801844:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    
		fd_close(fd, 0);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	6a 00                	push   $0x0
  801850:	ff 75 f4             	pushl  -0xc(%ebp)
  801853:	e8 1b f9 ff ff       	call   801173 <fd_close>
		return r;
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	eb e5                	jmp    801842 <open+0x6c>
		return -E_BAD_PATH;
  80185d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801862:	eb de                	jmp    801842 <open+0x6c>

00801864 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80186a:	ba 00 00 00 00       	mov    $0x0,%edx
  80186f:	b8 08 00 00 00       	mov    $0x8,%eax
  801874:	e8 68 fd ff ff       	call   8015e1 <fsipc>
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801881:	68 77 2a 80 00       	push   $0x802a77
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	e8 da f0 ff ff       	call   800968 <strcpy>
	return 0;
}
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <devsock_close>:
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	53                   	push   %ebx
  801899:	83 ec 10             	sub    $0x10,%esp
  80189c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189f:	53                   	push   %ebx
  8018a0:	e8 61 0a 00 00       	call   802306 <pageref>
  8018a5:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018a8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018ad:	83 f8 01             	cmp    $0x1,%eax
  8018b0:	74 07                	je     8018b9 <devsock_close+0x24>
}
  8018b2:	89 d0                	mov    %edx,%eax
  8018b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018b9:	83 ec 0c             	sub    $0xc,%esp
  8018bc:	ff 73 0c             	pushl  0xc(%ebx)
  8018bf:	e8 b9 02 00 00       	call   801b7d <nsipc_close>
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	eb e7                	jmp    8018b2 <devsock_close+0x1d>

008018cb <devsock_write>:
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
  8018ce:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	ff 70 0c             	pushl  0xc(%eax)
  8018df:	e8 76 03 00 00       	call   801c5a <nsipc_send>
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <devsock_read>:
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 10             	pushl  0x10(%ebp)
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	ff 70 0c             	pushl  0xc(%eax)
  8018fa:	e8 ef 02 00 00       	call   801bee <nsipc_recv>
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <fd2sockid>:
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801907:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	e8 b7 f7 ff ff       	call   8010c8 <fd_lookup>
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	85 c0                	test   %eax,%eax
  801916:	78 10                	js     801928 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801921:	39 08                	cmp    %ecx,(%eax)
  801923:	75 05                	jne    80192a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801925:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    
		return -E_NOT_SUPP;
  80192a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192f:	eb f7                	jmp    801928 <fd2sockid+0x27>

00801931 <alloc_sockfd>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 1c             	sub    $0x1c,%esp
  801939:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80193b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193e:	50                   	push   %eax
  80193f:	e8 32 f7 ff ff       	call   801076 <fd_alloc>
  801944:	89 c3                	mov    %eax,%ebx
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 43                	js     801990 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	68 07 04 00 00       	push   $0x407
  801955:	ff 75 f4             	pushl  -0xc(%ebp)
  801958:	6a 00                	push   $0x0
  80195a:	e8 fb f3 ff ff       	call   800d5a <sys_page_alloc>
  80195f:	89 c3                	mov    %eax,%ebx
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 28                	js     801990 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801971:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80197d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	50                   	push   %eax
  801984:	e8 c6 f6 ff ff       	call   80104f <fd2num>
  801989:	89 c3                	mov    %eax,%ebx
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	eb 0c                	jmp    80199c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801990:	83 ec 0c             	sub    $0xc,%esp
  801993:	56                   	push   %esi
  801994:	e8 e4 01 00 00       	call   801b7d <nsipc_close>
		return r;
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <accept>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	e8 4e ff ff ff       	call   801901 <fd2sockid>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 1b                	js     8019d2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	ff 75 10             	pushl  0x10(%ebp)
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	50                   	push   %eax
  8019c1:	e8 0e 01 00 00       	call   801ad4 <nsipc_accept>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 05                	js     8019d2 <accept+0x2d>
	return alloc_sockfd(r);
  8019cd:	e8 5f ff ff ff       	call   801931 <alloc_sockfd>
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <bind>:
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	e8 1f ff ff ff       	call   801901 <fd2sockid>
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 12                	js     8019f8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019e6:	83 ec 04             	sub    $0x4,%esp
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	e8 31 01 00 00       	call   801b26 <nsipc_bind>
  8019f5:	83 c4 10             	add    $0x10,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <shutdown>:
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	e8 f9 fe ff ff       	call   801901 <fd2sockid>
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	78 0f                	js     801a1b <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a0c:	83 ec 08             	sub    $0x8,%esp
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	50                   	push   %eax
  801a13:	e8 43 01 00 00       	call   801b5b <nsipc_shutdown>
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <connect>:
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	e8 d6 fe ff ff       	call   801901 <fd2sockid>
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 12                	js     801a41 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	ff 75 10             	pushl  0x10(%ebp)
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	50                   	push   %eax
  801a39:	e8 59 01 00 00       	call   801b97 <nsipc_connect>
  801a3e:	83 c4 10             	add    $0x10,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <listen>:
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	e8 b0 fe ff ff       	call   801901 <fd2sockid>
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 0f                	js     801a64 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a55:	83 ec 08             	sub    $0x8,%esp
  801a58:	ff 75 0c             	pushl  0xc(%ebp)
  801a5b:	50                   	push   %eax
  801a5c:	e8 6b 01 00 00       	call   801bcc <nsipc_listen>
  801a61:	83 c4 10             	add    $0x10,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a6c:	ff 75 10             	pushl  0x10(%ebp)
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	e8 3e 02 00 00       	call   801cb8 <nsipc_socket>
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	85 c0                	test   %eax,%eax
  801a7f:	78 05                	js     801a86 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a81:	e8 ab fe ff ff       	call   801931 <alloc_sockfd>
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a91:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a98:	74 26                	je     801ac0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a9a:	6a 07                	push   $0x7
  801a9c:	68 00 60 80 00       	push   $0x806000
  801aa1:	53                   	push   %ebx
  801aa2:	ff 35 04 40 80 00    	pushl  0x804004
  801aa8:	e8 c2 07 00 00       	call   80226f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aad:	83 c4 0c             	add    $0xc,%esp
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	e8 4b 07 00 00       	call   802206 <ipc_recv>
}
  801abb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	6a 02                	push   $0x2
  801ac5:	e8 fd 07 00 00       	call   8022c7 <ipc_find_env>
  801aca:	a3 04 40 80 00       	mov    %eax,0x804004
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	eb c6                	jmp    801a9a <nsipc+0x12>

00801ad4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	56                   	push   %esi
  801ad8:	53                   	push   %ebx
  801ad9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ae4:	8b 06                	mov    (%esi),%eax
  801ae6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aeb:	b8 01 00 00 00       	mov    $0x1,%eax
  801af0:	e8 93 ff ff ff       	call   801a88 <nsipc>
  801af5:	89 c3                	mov    %eax,%ebx
  801af7:	85 c0                	test   %eax,%eax
  801af9:	79 09                	jns    801b04 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801afb:	89 d8                	mov    %ebx,%eax
  801afd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b00:	5b                   	pop    %ebx
  801b01:	5e                   	pop    %esi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	ff 35 10 60 80 00    	pushl  0x806010
  801b0d:	68 00 60 80 00       	push   $0x806000
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 dc ef ff ff       	call   800af6 <memmove>
		*addrlen = ret->ret_addrlen;
  801b1a:	a1 10 60 80 00       	mov    0x806010,%eax
  801b1f:	89 06                	mov    %eax,(%esi)
  801b21:	83 c4 10             	add    $0x10,%esp
	return r;
  801b24:	eb d5                	jmp    801afb <nsipc_accept+0x27>

00801b26 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b38:	53                   	push   %ebx
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	68 04 60 80 00       	push   $0x806004
  801b41:	e8 b0 ef ff ff       	call   800af6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b46:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b4c:	b8 02 00 00 00       	mov    $0x2,%eax
  801b51:	e8 32 ff ff ff       	call   801a88 <nsipc>
}
  801b56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b71:	b8 03 00 00 00       	mov    $0x3,%eax
  801b76:	e8 0d ff ff ff       	call   801a88 <nsipc>
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <nsipc_close>:

int
nsipc_close(int s)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b8b:	b8 04 00 00 00       	mov    $0x4,%eax
  801b90:	e8 f3 fe ff ff       	call   801a88 <nsipc>
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	53                   	push   %ebx
  801b9b:	83 ec 08             	sub    $0x8,%esp
  801b9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ba9:	53                   	push   %ebx
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	68 04 60 80 00       	push   $0x806004
  801bb2:	e8 3f ef ff ff       	call   800af6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bb7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bbd:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc2:	e8 c1 fe ff ff       	call   801a88 <nsipc>
}
  801bc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801be2:	b8 06 00 00 00       	mov    $0x6,%eax
  801be7:	e8 9c fe ff ff       	call   801a88 <nsipc>
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	56                   	push   %esi
  801bf2:	53                   	push   %ebx
  801bf3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bfe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c04:	8b 45 14             	mov    0x14(%ebp),%eax
  801c07:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c0c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c11:	e8 72 fe ff ff       	call   801a88 <nsipc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	78 1f                	js     801c3b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c1c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c21:	7f 21                	jg     801c44 <nsipc_recv+0x56>
  801c23:	39 c6                	cmp    %eax,%esi
  801c25:	7c 1d                	jl     801c44 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	50                   	push   %eax
  801c2b:	68 00 60 80 00       	push   $0x806000
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	e8 be ee ff ff       	call   800af6 <memmove>
  801c38:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c44:	68 83 2a 80 00       	push   $0x802a83
  801c49:	68 4b 2a 80 00       	push   $0x802a4b
  801c4e:	6a 62                	push   $0x62
  801c50:	68 98 2a 80 00       	push   $0x802a98
  801c55:	e8 4b 05 00 00       	call   8021a5 <_panic>

00801c5a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c6c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c72:	7f 2e                	jg     801ca2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	53                   	push   %ebx
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	68 0c 60 80 00       	push   $0x80600c
  801c80:	e8 71 ee ff ff       	call   800af6 <memmove>
	nsipcbuf.send.req_size = size;
  801c85:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c93:	b8 08 00 00 00       	mov    $0x8,%eax
  801c98:	e8 eb fd ff ff       	call   801a88 <nsipc>
}
  801c9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    
	assert(size < 1600);
  801ca2:	68 a4 2a 80 00       	push   $0x802aa4
  801ca7:	68 4b 2a 80 00       	push   $0x802a4b
  801cac:	6a 6d                	push   $0x6d
  801cae:	68 98 2a 80 00       	push   $0x802a98
  801cb3:	e8 ed 04 00 00       	call   8021a5 <_panic>

00801cb8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cce:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cd6:	b8 09 00 00 00       	mov    $0x9,%eax
  801cdb:	e8 a8 fd ff ff       	call   801a88 <nsipc>
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	56                   	push   %esi
  801ce6:	53                   	push   %ebx
  801ce7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	e8 6a f3 ff ff       	call   80105f <fd2data>
  801cf5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf7:	83 c4 08             	add    $0x8,%esp
  801cfa:	68 b0 2a 80 00       	push   $0x802ab0
  801cff:	53                   	push   %ebx
  801d00:	e8 63 ec ff ff       	call   800968 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d05:	8b 46 04             	mov    0x4(%esi),%eax
  801d08:	2b 06                	sub    (%esi),%eax
  801d0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d17:	00 00 00 
	stat->st_dev = &devpipe;
  801d1a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d21:	30 80 00 
	return 0;
}
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	53                   	push   %ebx
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d3a:	53                   	push   %ebx
  801d3b:	6a 00                	push   $0x0
  801d3d:	e8 9d f0 ff ff       	call   800ddf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d42:	89 1c 24             	mov    %ebx,(%esp)
  801d45:	e8 15 f3 ff ff       	call   80105f <fd2data>
  801d4a:	83 c4 08             	add    $0x8,%esp
  801d4d:	50                   	push   %eax
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 8a f0 ff ff       	call   800ddf <sys_page_unmap>
}
  801d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <_pipeisclosed>:
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	57                   	push   %edi
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 1c             	sub    $0x1c,%esp
  801d63:	89 c7                	mov    %eax,%edi
  801d65:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d67:	a1 08 40 80 00       	mov    0x804008,%eax
  801d6c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	57                   	push   %edi
  801d73:	e8 8e 05 00 00       	call   802306 <pageref>
  801d78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d7b:	89 34 24             	mov    %esi,(%esp)
  801d7e:	e8 83 05 00 00       	call   802306 <pageref>
		nn = thisenv->env_runs;
  801d83:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d89:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	39 cb                	cmp    %ecx,%ebx
  801d91:	74 1b                	je     801dae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d96:	75 cf                	jne    801d67 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d98:	8b 42 58             	mov    0x58(%edx),%eax
  801d9b:	6a 01                	push   $0x1
  801d9d:	50                   	push   %eax
  801d9e:	53                   	push   %ebx
  801d9f:	68 b7 2a 80 00       	push   $0x802ab7
  801da4:	e8 60 e4 ff ff       	call   800209 <cprintf>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	eb b9                	jmp    801d67 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801db1:	0f 94 c0             	sete   %al
  801db4:	0f b6 c0             	movzbl %al,%eax
}
  801db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5e                   	pop    %esi
  801dbc:	5f                   	pop    %edi
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    

00801dbf <devpipe_write>:
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	57                   	push   %edi
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 28             	sub    $0x28,%esp
  801dc8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dcb:	56                   	push   %esi
  801dcc:	e8 8e f2 ff ff       	call   80105f <fd2data>
  801dd1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	bf 00 00 00 00       	mov    $0x0,%edi
  801ddb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dde:	74 4f                	je     801e2f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801de0:	8b 43 04             	mov    0x4(%ebx),%eax
  801de3:	8b 0b                	mov    (%ebx),%ecx
  801de5:	8d 51 20             	lea    0x20(%ecx),%edx
  801de8:	39 d0                	cmp    %edx,%eax
  801dea:	72 14                	jb     801e00 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dec:	89 da                	mov    %ebx,%edx
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	e8 65 ff ff ff       	call   801d5a <_pipeisclosed>
  801df5:	85 c0                	test   %eax,%eax
  801df7:	75 3b                	jne    801e34 <devpipe_write+0x75>
			sys_yield();
  801df9:	e8 3d ef ff ff       	call   800d3b <sys_yield>
  801dfe:	eb e0                	jmp    801de0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e03:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e07:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e0a:	89 c2                	mov    %eax,%edx
  801e0c:	c1 fa 1f             	sar    $0x1f,%edx
  801e0f:	89 d1                	mov    %edx,%ecx
  801e11:	c1 e9 1b             	shr    $0x1b,%ecx
  801e14:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e17:	83 e2 1f             	and    $0x1f,%edx
  801e1a:	29 ca                	sub    %ecx,%edx
  801e1c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e20:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e24:	83 c0 01             	add    $0x1,%eax
  801e27:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e2a:	83 c7 01             	add    $0x1,%edi
  801e2d:	eb ac                	jmp    801ddb <devpipe_write+0x1c>
	return i;
  801e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e32:	eb 05                	jmp    801e39 <devpipe_write+0x7a>
				return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    

00801e41 <devpipe_read>:
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	57                   	push   %edi
  801e45:	56                   	push   %esi
  801e46:	53                   	push   %ebx
  801e47:	83 ec 18             	sub    $0x18,%esp
  801e4a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e4d:	57                   	push   %edi
  801e4e:	e8 0c f2 ff ff       	call   80105f <fd2data>
  801e53:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	be 00 00 00 00       	mov    $0x0,%esi
  801e5d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e60:	75 14                	jne    801e76 <devpipe_read+0x35>
	return i;
  801e62:	8b 45 10             	mov    0x10(%ebp),%eax
  801e65:	eb 02                	jmp    801e69 <devpipe_read+0x28>
				return i;
  801e67:	89 f0                	mov    %esi,%eax
}
  801e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    
			sys_yield();
  801e71:	e8 c5 ee ff ff       	call   800d3b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e76:	8b 03                	mov    (%ebx),%eax
  801e78:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e7b:	75 18                	jne    801e95 <devpipe_read+0x54>
			if (i > 0)
  801e7d:	85 f6                	test   %esi,%esi
  801e7f:	75 e6                	jne    801e67 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e81:	89 da                	mov    %ebx,%edx
  801e83:	89 f8                	mov    %edi,%eax
  801e85:	e8 d0 fe ff ff       	call   801d5a <_pipeisclosed>
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	74 e3                	je     801e71 <devpipe_read+0x30>
				return 0;
  801e8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e93:	eb d4                	jmp    801e69 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e95:	99                   	cltd   
  801e96:	c1 ea 1b             	shr    $0x1b,%edx
  801e99:	01 d0                	add    %edx,%eax
  801e9b:	83 e0 1f             	and    $0x1f,%eax
  801e9e:	29 d0                	sub    %edx,%eax
  801ea0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eae:	83 c6 01             	add    $0x1,%esi
  801eb1:	eb aa                	jmp    801e5d <devpipe_read+0x1c>

00801eb3 <pipe>:
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebe:	50                   	push   %eax
  801ebf:	e8 b2 f1 ff ff       	call   801076 <fd_alloc>
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	0f 88 23 01 00 00    	js     801ff4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed1:	83 ec 04             	sub    $0x4,%esp
  801ed4:	68 07 04 00 00       	push   $0x407
  801ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  801edc:	6a 00                	push   $0x0
  801ede:	e8 77 ee ff ff       	call   800d5a <sys_page_alloc>
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	0f 88 04 01 00 00    	js     801ff4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef6:	50                   	push   %eax
  801ef7:	e8 7a f1 ff ff       	call   801076 <fd_alloc>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	0f 88 db 00 00 00    	js     801fe4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	68 07 04 00 00       	push   $0x407
  801f11:	ff 75 f0             	pushl  -0x10(%ebp)
  801f14:	6a 00                	push   $0x0
  801f16:	e8 3f ee ff ff       	call   800d5a <sys_page_alloc>
  801f1b:	89 c3                	mov    %eax,%ebx
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	0f 88 bc 00 00 00    	js     801fe4 <pipe+0x131>
	va = fd2data(fd0);
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2e:	e8 2c f1 ff ff       	call   80105f <fd2data>
  801f33:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f35:	83 c4 0c             	add    $0xc,%esp
  801f38:	68 07 04 00 00       	push   $0x407
  801f3d:	50                   	push   %eax
  801f3e:	6a 00                	push   $0x0
  801f40:	e8 15 ee ff ff       	call   800d5a <sys_page_alloc>
  801f45:	89 c3                	mov    %eax,%ebx
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	0f 88 82 00 00 00    	js     801fd4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 f0             	pushl  -0x10(%ebp)
  801f58:	e8 02 f1 ff ff       	call   80105f <fd2data>
  801f5d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f64:	50                   	push   %eax
  801f65:	6a 00                	push   $0x0
  801f67:	56                   	push   %esi
  801f68:	6a 00                	push   $0x0
  801f6a:	e8 2e ee ff ff       	call   800d9d <sys_page_map>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	83 c4 20             	add    $0x20,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 4e                	js     801fc6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f78:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f80:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f85:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	e8 a9 f0 ff ff       	call   80104f <fd2num>
  801fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fab:	83 c4 04             	add    $0x4,%esp
  801fae:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb1:	e8 99 f0 ff ff       	call   80104f <fd2num>
  801fb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc4:	eb 2e                	jmp    801ff4 <pipe+0x141>
	sys_page_unmap(0, va);
  801fc6:	83 ec 08             	sub    $0x8,%esp
  801fc9:	56                   	push   %esi
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 0e ee ff ff       	call   800ddf <sys_page_unmap>
  801fd1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fd4:	83 ec 08             	sub    $0x8,%esp
  801fd7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fda:	6a 00                	push   $0x0
  801fdc:	e8 fe ed ff ff       	call   800ddf <sys_page_unmap>
  801fe1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fe4:	83 ec 08             	sub    $0x8,%esp
  801fe7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fea:	6a 00                	push   $0x0
  801fec:	e8 ee ed ff ff       	call   800ddf <sys_page_unmap>
  801ff1:	83 c4 10             	add    $0x10,%esp
}
  801ff4:	89 d8                	mov    %ebx,%eax
  801ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <pipeisclosed>:
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802003:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802006:	50                   	push   %eax
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	e8 b9 f0 ff ff       	call   8010c8 <fd_lookup>
  80200f:	83 c4 10             	add    $0x10,%esp
  802012:	85 c0                	test   %eax,%eax
  802014:	78 18                	js     80202e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	ff 75 f4             	pushl  -0xc(%ebp)
  80201c:	e8 3e f0 ff ff       	call   80105f <fd2data>
	return _pipeisclosed(fd, p);
  802021:	89 c2                	mov    %eax,%edx
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802026:	e8 2f fd ff ff       	call   801d5a <_pipeisclosed>
  80202b:	83 c4 10             	add    $0x10,%esp
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	c3                   	ret    

00802036 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80203c:	68 cf 2a 80 00       	push   $0x802acf
  802041:	ff 75 0c             	pushl  0xc(%ebp)
  802044:	e8 1f e9 ff ff       	call   800968 <strcpy>
	return 0;
}
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <devcons_write>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	57                   	push   %edi
  802054:	56                   	push   %esi
  802055:	53                   	push   %ebx
  802056:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80205c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802061:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802067:	3b 75 10             	cmp    0x10(%ebp),%esi
  80206a:	73 31                	jae    80209d <devcons_write+0x4d>
		m = n - tot;
  80206c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80206f:	29 f3                	sub    %esi,%ebx
  802071:	83 fb 7f             	cmp    $0x7f,%ebx
  802074:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802079:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	53                   	push   %ebx
  802080:	89 f0                	mov    %esi,%eax
  802082:	03 45 0c             	add    0xc(%ebp),%eax
  802085:	50                   	push   %eax
  802086:	57                   	push   %edi
  802087:	e8 6a ea ff ff       	call   800af6 <memmove>
		sys_cputs(buf, m);
  80208c:	83 c4 08             	add    $0x8,%esp
  80208f:	53                   	push   %ebx
  802090:	57                   	push   %edi
  802091:	e8 08 ec ff ff       	call   800c9e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802096:	01 de                	add    %ebx,%esi
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	eb ca                	jmp    802067 <devcons_write+0x17>
}
  80209d:	89 f0                	mov    %esi,%eax
  80209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020a2:	5b                   	pop    %ebx
  8020a3:	5e                   	pop    %esi
  8020a4:	5f                   	pop    %edi
  8020a5:	5d                   	pop    %ebp
  8020a6:	c3                   	ret    

008020a7 <devcons_read>:
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 08             	sub    $0x8,%esp
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b6:	74 21                	je     8020d9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020b8:	e8 ff eb ff ff       	call   800cbc <sys_cgetc>
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	75 07                	jne    8020c8 <devcons_read+0x21>
		sys_yield();
  8020c1:	e8 75 ec ff ff       	call   800d3b <sys_yield>
  8020c6:	eb f0                	jmp    8020b8 <devcons_read+0x11>
	if (c < 0)
  8020c8:	78 0f                	js     8020d9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020ca:	83 f8 04             	cmp    $0x4,%eax
  8020cd:	74 0c                	je     8020db <devcons_read+0x34>
	*(char*)vbuf = c;
  8020cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d2:	88 02                	mov    %al,(%edx)
	return 1;
  8020d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    
		return 0;
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	eb f7                	jmp    8020d9 <devcons_read+0x32>

008020e2 <cputchar>:
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ee:	6a 01                	push   $0x1
  8020f0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f3:	50                   	push   %eax
  8020f4:	e8 a5 eb ff ff       	call   800c9e <sys_cputs>
}
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <getchar>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802104:	6a 01                	push   $0x1
  802106:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802109:	50                   	push   %eax
  80210a:	6a 00                	push   $0x0
  80210c:	e8 27 f2 ff ff       	call   801338 <read>
	if (r < 0)
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 06                	js     80211e <getchar+0x20>
	if (r < 1)
  802118:	74 06                	je     802120 <getchar+0x22>
	return c;
  80211a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    
		return -E_EOF;
  802120:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802125:	eb f7                	jmp    80211e <getchar+0x20>

00802127 <iscons>:
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802130:	50                   	push   %eax
  802131:	ff 75 08             	pushl  0x8(%ebp)
  802134:	e8 8f ef ff ff       	call   8010c8 <fd_lookup>
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	85 c0                	test   %eax,%eax
  80213e:	78 11                	js     802151 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802149:	39 10                	cmp    %edx,(%eax)
  80214b:	0f 94 c0             	sete   %al
  80214e:	0f b6 c0             	movzbl %al,%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <opencons>:
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802159:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215c:	50                   	push   %eax
  80215d:	e8 14 ef ff ff       	call   801076 <fd_alloc>
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	78 3a                	js     8021a3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 07 04 00 00       	push   $0x407
  802171:	ff 75 f4             	pushl  -0xc(%ebp)
  802174:	6a 00                	push   $0x0
  802176:	e8 df eb ff ff       	call   800d5a <sys_page_alloc>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	85 c0                	test   %eax,%eax
  802180:	78 21                	js     8021a3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80218b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	50                   	push   %eax
  80219b:	e8 af ee ff ff       	call   80104f <fd2num>
  8021a0:	83 c4 10             	add    $0x10,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	56                   	push   %esi
  8021a9:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8021af:	8b 40 48             	mov    0x48(%eax),%eax
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	68 00 2b 80 00       	push   $0x802b00
  8021ba:	50                   	push   %eax
  8021bb:	68 f8 25 80 00       	push   $0x8025f8
  8021c0:	e8 44 e0 ff ff       	call   800209 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021c8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ce:	e8 49 eb ff ff       	call   800d1c <sys_getenvid>
  8021d3:	83 c4 04             	add    $0x4,%esp
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	ff 75 08             	pushl  0x8(%ebp)
  8021dc:	56                   	push   %esi
  8021dd:	50                   	push   %eax
  8021de:	68 dc 2a 80 00       	push   $0x802adc
  8021e3:	e8 21 e0 ff ff       	call   800209 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021e8:	83 c4 18             	add    $0x18,%esp
  8021eb:	53                   	push   %ebx
  8021ec:	ff 75 10             	pushl  0x10(%ebp)
  8021ef:	e8 c4 df ff ff       	call   8001b8 <vcprintf>
	cprintf("\n");
  8021f4:	c7 04 24 bc 25 80 00 	movl   $0x8025bc,(%esp)
  8021fb:	e8 09 e0 ff ff       	call   800209 <cprintf>
  802200:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802203:	cc                   	int3   
  802204:	eb fd                	jmp    802203 <_panic+0x5e>

00802206 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	56                   	push   %esi
  80220a:	53                   	push   %ebx
  80220b:	8b 75 08             	mov    0x8(%ebp),%esi
  80220e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802211:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802214:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802216:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80221b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80221e:	83 ec 0c             	sub    $0xc,%esp
  802221:	50                   	push   %eax
  802222:	e8 e3 ec ff ff       	call   800f0a <sys_ipc_recv>
	if(ret < 0){
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 2b                	js     802259 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80222e:	85 f6                	test   %esi,%esi
  802230:	74 0a                	je     80223c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802232:	a1 08 40 80 00       	mov    0x804008,%eax
  802237:	8b 40 78             	mov    0x78(%eax),%eax
  80223a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80223c:	85 db                	test   %ebx,%ebx
  80223e:	74 0a                	je     80224a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802240:	a1 08 40 80 00       	mov    0x804008,%eax
  802245:	8b 40 7c             	mov    0x7c(%eax),%eax
  802248:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80224a:	a1 08 40 80 00       	mov    0x804008,%eax
  80224f:	8b 40 74             	mov    0x74(%eax),%eax
}
  802252:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
		if(from_env_store)
  802259:	85 f6                	test   %esi,%esi
  80225b:	74 06                	je     802263 <ipc_recv+0x5d>
			*from_env_store = 0;
  80225d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802263:	85 db                	test   %ebx,%ebx
  802265:	74 eb                	je     802252 <ipc_recv+0x4c>
			*perm_store = 0;
  802267:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80226d:	eb e3                	jmp    802252 <ipc_recv+0x4c>

0080226f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	57                   	push   %edi
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	8b 7d 08             	mov    0x8(%ebp),%edi
  80227b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80227e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802281:	85 db                	test   %ebx,%ebx
  802283:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802288:	0f 44 d8             	cmove  %eax,%ebx
  80228b:	eb 05                	jmp    802292 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80228d:	e8 a9 ea ff ff       	call   800d3b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802292:	ff 75 14             	pushl  0x14(%ebp)
  802295:	53                   	push   %ebx
  802296:	56                   	push   %esi
  802297:	57                   	push   %edi
  802298:	e8 4a ec ff ff       	call   800ee7 <sys_ipc_try_send>
  80229d:	83 c4 10             	add    $0x10,%esp
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 1b                	je     8022bf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022a4:	79 e7                	jns    80228d <ipc_send+0x1e>
  8022a6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a9:	74 e2                	je     80228d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022ab:	83 ec 04             	sub    $0x4,%esp
  8022ae:	68 07 2b 80 00       	push   $0x802b07
  8022b3:	6a 46                	push   $0x46
  8022b5:	68 1c 2b 80 00       	push   $0x802b1c
  8022ba:	e8 e6 fe ff ff       	call   8021a5 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c2:	5b                   	pop    %ebx
  8022c3:	5e                   	pop    %esi
  8022c4:	5f                   	pop    %edi
  8022c5:	5d                   	pop    %ebp
  8022c6:	c3                   	ret    

008022c7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022cd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022d2:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022d8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022de:	8b 52 50             	mov    0x50(%edx),%edx
  8022e1:	39 ca                	cmp    %ecx,%edx
  8022e3:	74 11                	je     8022f6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022e5:	83 c0 01             	add    $0x1,%eax
  8022e8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022ed:	75 e3                	jne    8022d2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	eb 0e                	jmp    802304 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022f6:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802301:	8b 40 48             	mov    0x48(%eax),%eax
}
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80230c:	89 d0                	mov    %edx,%eax
  80230e:	c1 e8 16             	shr    $0x16,%eax
  802311:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80231d:	f6 c1 01             	test   $0x1,%cl
  802320:	74 1d                	je     80233f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802322:	c1 ea 0c             	shr    $0xc,%edx
  802325:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80232c:	f6 c2 01             	test   $0x1,%dl
  80232f:	74 0e                	je     80233f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802331:	c1 ea 0c             	shr    $0xc,%edx
  802334:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80233b:	ef 
  80233c:	0f b7 c0             	movzwl %ax,%eax
}
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	66 90                	xchg   %ax,%ax
  802343:	66 90                	xchg   %ax,%ax
  802345:	66 90                	xchg   %ax,%ax
  802347:	66 90                	xchg   %ax,%ax
  802349:	66 90                	xchg   %ax,%ax
  80234b:	66 90                	xchg   %ax,%ax
  80234d:	66 90                	xchg   %ax,%ax
  80234f:	90                   	nop

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80235f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802367:	85 d2                	test   %edx,%edx
  802369:	75 4d                	jne    8023b8 <__udivdi3+0x68>
  80236b:	39 f3                	cmp    %esi,%ebx
  80236d:	76 19                	jbe    802388 <__udivdi3+0x38>
  80236f:	31 ff                	xor    %edi,%edi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 a9                	ja     802377 <__udivdi3+0x27>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a2                	jmp    802377 <__udivdi3+0x27>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 27 ff ff ff       	jmp    802377 <__udivdi3+0x27>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 1d ff ff ff       	jmp    802377 <__udivdi3+0x27>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802477:	89 da                	mov    %ebx,%edx
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 43                	jne    8024c0 <__umoddi3+0x60>
  80247d:	39 df                	cmp    %ebx,%edi
  80247f:	76 17                	jbe    802498 <__umoddi3+0x38>
  802481:	89 f0                	mov    %esi,%eax
  802483:	f7 f7                	div    %edi
  802485:	89 d0                	mov    %edx,%eax
  802487:	31 d2                	xor    %edx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d0                	jmp    802487 <__umoddi3+0x27>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
