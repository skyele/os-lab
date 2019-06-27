
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
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 e0 25 80 00       	push   $0x8025e0
  800048:	e8 f1 01 00 00       	call   80023e <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 16 0d 00 00       	call   800d70 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 00 26 80 00       	push   $0x802600
  80006c:	e8 cd 01 00 00       	call   80023e <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 2c 26 80 00       	push   $0x80262c
  80008d:	e8 ac 01 00 00       	call   80023e <cprintf>
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
  8000a3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000aa:	00 00 00 
	envid_t find = sys_getenvid();
  8000ad:	e8 9f 0c 00 00       	call   800d51 <sys_getenvid>
  8000b2:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000b8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000bd:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8000c7:	eb 0b                	jmp    8000d4 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000c9:	83 c2 01             	add    $0x1,%edx
  8000cc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d2:	74 23                	je     8000f7 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000d4:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000da:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e3:	39 c1                	cmp    %eax,%ecx
  8000e5:	75 e2                	jne    8000c9 <libmain+0x2f>
  8000e7:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000ed:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f3:	89 fe                	mov    %edi,%esi
  8000f5:	eb d2                	jmp    8000c9 <libmain+0x2f>
  8000f7:	89 f0                	mov    %esi,%eax
  8000f9:	84 c0                	test   %al,%al
  8000fb:	74 06                	je     800103 <libmain+0x69>
  8000fd:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800107:	7e 0a                	jle    800113 <libmain+0x79>
		binaryname = argv[0];
  800109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010c:	8b 00                	mov    (%eax),%eax
  80010e:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800113:	a1 08 40 80 00       	mov    0x804008,%eax
  800118:	8b 40 48             	mov    0x48(%eax),%eax
  80011b:	83 ec 08             	sub    $0x8,%esp
  80011e:	50                   	push   %eax
  80011f:	68 4b 26 80 00       	push   $0x80264b
  800124:	e8 15 01 00 00       	call   80023e <cprintf>
	cprintf("before umain\n");
  800129:	c7 04 24 69 26 80 00 	movl   $0x802669,(%esp)
  800130:	e8 09 01 00 00       	call   80023e <cprintf>
	// call user main routine
	umain(argc, argv);
  800135:	83 c4 08             	add    $0x8,%esp
  800138:	ff 75 0c             	pushl  0xc(%ebp)
  80013b:	ff 75 08             	pushl  0x8(%ebp)
  80013e:	e8 f0 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800143:	c7 04 24 77 26 80 00 	movl   $0x802677,(%esp)
  80014a:	e8 ef 00 00 00       	call   80023e <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80014f:	a1 08 40 80 00       	mov    0x804008,%eax
  800154:	8b 40 48             	mov    0x48(%eax),%eax
  800157:	83 c4 08             	add    $0x8,%esp
  80015a:	50                   	push   %eax
  80015b:	68 84 26 80 00       	push   $0x802684
  800160:	e8 d9 00 00 00       	call   80023e <cprintf>
	// exit gracefully
	exit();
  800165:	e8 0b 00 00 00       	call   800175 <exit>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800170:	5b                   	pop    %ebx
  800171:	5e                   	pop    %esi
  800172:	5f                   	pop    %edi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    

00800175 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80017b:	a1 08 40 80 00       	mov    0x804008,%eax
  800180:	8b 40 48             	mov    0x48(%eax),%eax
  800183:	68 b0 26 80 00       	push   $0x8026b0
  800188:	50                   	push   %eax
  800189:	68 a3 26 80 00       	push   $0x8026a3
  80018e:	e8 ab 00 00 00       	call   80023e <cprintf>
	close_all();
  800193:	e8 c4 10 00 00       	call   80125c <close_all>
	sys_env_destroy(0);
  800198:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80019f:	e8 6c 0b 00 00       	call   800d10 <sys_env_destroy>
}
  8001a4:	83 c4 10             	add    $0x10,%esp
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	53                   	push   %ebx
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b3:	8b 13                	mov    (%ebx),%edx
  8001b5:	8d 42 01             	lea    0x1(%edx),%eax
  8001b8:	89 03                	mov    %eax,(%ebx)
  8001ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c6:	74 09                	je     8001d1 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001cf:	c9                   	leave  
  8001d0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	68 ff 00 00 00       	push   $0xff
  8001d9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 f1 0a 00 00       	call   800cd3 <sys_cputs>
		b->idx = 0;
  8001e2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	eb db                	jmp    8001c8 <putch+0x1f>

008001ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fd:	00 00 00 
	b.cnt = 0;
  800200:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800207:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020a:	ff 75 0c             	pushl  0xc(%ebp)
  80020d:	ff 75 08             	pushl  0x8(%ebp)
  800210:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800216:	50                   	push   %eax
  800217:	68 a9 01 80 00       	push   $0x8001a9
  80021c:	e8 4a 01 00 00       	call   80036b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800221:	83 c4 08             	add    $0x8,%esp
  800224:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80022a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800230:	50                   	push   %eax
  800231:	e8 9d 0a 00 00       	call   800cd3 <sys_cputs>

	return b.cnt;
}
  800236:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023c:	c9                   	leave  
  80023d:	c3                   	ret    

0080023e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023e:	55                   	push   %ebp
  80023f:	89 e5                	mov    %esp,%ebp
  800241:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800244:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800247:	50                   	push   %eax
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	e8 9d ff ff ff       	call   8001ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 1c             	sub    $0x1c,%esp
  80025b:	89 c6                	mov    %eax,%esi
  80025d:	89 d7                	mov    %edx,%edi
  80025f:	8b 45 08             	mov    0x8(%ebp),%eax
  800262:	8b 55 0c             	mov    0xc(%ebp),%edx
  800265:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800268:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026b:	8b 45 10             	mov    0x10(%ebp),%eax
  80026e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800271:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800275:	74 2c                	je     8002a3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800277:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800284:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800287:	39 c2                	cmp    %eax,%edx
  800289:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028c:	73 43                	jae    8002d1 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80028e:	83 eb 01             	sub    $0x1,%ebx
  800291:	85 db                	test   %ebx,%ebx
  800293:	7e 6c                	jle    800301 <printnum+0xaf>
				putch(padc, putdat);
  800295:	83 ec 08             	sub    $0x8,%esp
  800298:	57                   	push   %edi
  800299:	ff 75 18             	pushl  0x18(%ebp)
  80029c:	ff d6                	call   *%esi
  80029e:	83 c4 10             	add    $0x10,%esp
  8002a1:	eb eb                	jmp    80028e <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	6a 20                	push   $0x20
  8002a8:	6a 00                	push   $0x0
  8002aa:	50                   	push   %eax
  8002ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b1:	89 fa                	mov    %edi,%edx
  8002b3:	89 f0                	mov    %esi,%eax
  8002b5:	e8 98 ff ff ff       	call   800252 <printnum>
		while (--width > 0)
  8002ba:	83 c4 20             	add    $0x20,%esp
  8002bd:	83 eb 01             	sub    $0x1,%ebx
  8002c0:	85 db                	test   %ebx,%ebx
  8002c2:	7e 65                	jle    800329 <printnum+0xd7>
			putch(padc, putdat);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	57                   	push   %edi
  8002c8:	6a 20                	push   $0x20
  8002ca:	ff d6                	call   *%esi
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	eb ec                	jmp    8002bd <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d1:	83 ec 0c             	sub    $0xc,%esp
  8002d4:	ff 75 18             	pushl  0x18(%ebp)
  8002d7:	83 eb 01             	sub    $0x1,%ebx
  8002da:	53                   	push   %ebx
  8002db:	50                   	push   %eax
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002eb:	e8 90 20 00 00       	call   802380 <__udivdi3>
  8002f0:	83 c4 18             	add    $0x18,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	89 f0                	mov    %esi,%eax
  8002f9:	e8 54 ff ff ff       	call   800252 <printnum>
  8002fe:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	57                   	push   %edi
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 dc             	pushl  -0x24(%ebp)
  80030b:	ff 75 d8             	pushl  -0x28(%ebp)
  80030e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800311:	ff 75 e0             	pushl  -0x20(%ebp)
  800314:	e8 77 21 00 00       	call   802490 <__umoddi3>
  800319:	83 c4 14             	add    $0x14,%esp
  80031c:	0f be 80 b5 26 80 00 	movsbl 0x8026b5(%eax),%eax
  800323:	50                   	push   %eax
  800324:	ff d6                	call   *%esi
  800326:	83 c4 10             	add    $0x10,%esp
	}
}
  800329:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800337:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033b:	8b 10                	mov    (%eax),%edx
  80033d:	3b 50 04             	cmp    0x4(%eax),%edx
  800340:	73 0a                	jae    80034c <sprintputch+0x1b>
		*b->buf++ = ch;
  800342:	8d 4a 01             	lea    0x1(%edx),%ecx
  800345:	89 08                	mov    %ecx,(%eax)
  800347:	8b 45 08             	mov    0x8(%ebp),%eax
  80034a:	88 02                	mov    %al,(%edx)
}
  80034c:	5d                   	pop    %ebp
  80034d:	c3                   	ret    

0080034e <printfmt>:
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800354:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800357:	50                   	push   %eax
  800358:	ff 75 10             	pushl  0x10(%ebp)
  80035b:	ff 75 0c             	pushl  0xc(%ebp)
  80035e:	ff 75 08             	pushl  0x8(%ebp)
  800361:	e8 05 00 00 00       	call   80036b <vprintfmt>
}
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <vprintfmt>:
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	57                   	push   %edi
  80036f:	56                   	push   %esi
  800370:	53                   	push   %ebx
  800371:	83 ec 3c             	sub    $0x3c,%esp
  800374:	8b 75 08             	mov    0x8(%ebp),%esi
  800377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037d:	e9 32 04 00 00       	jmp    8007b4 <vprintfmt+0x449>
		padc = ' ';
  800382:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800386:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80038d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800394:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003a9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	8d 47 01             	lea    0x1(%edi),%eax
  8003b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b4:	0f b6 17             	movzbl (%edi),%edx
  8003b7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ba:	3c 55                	cmp    $0x55,%al
  8003bc:	0f 87 12 05 00 00    	ja     8008d4 <vprintfmt+0x569>
  8003c2:	0f b6 c0             	movzbl %al,%eax
  8003c5:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003cf:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d3:	eb d9                	jmp    8003ae <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d8:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003dc:	eb d0                	jmp    8003ae <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	0f b6 d2             	movzbl %dl,%edx
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e9:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ec:	eb 03                	jmp    8003f1 <vprintfmt+0x86>
  8003ee:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003fb:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003fe:	83 fe 09             	cmp    $0x9,%esi
  800401:	76 eb                	jbe    8003ee <vprintfmt+0x83>
  800403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800406:	8b 75 08             	mov    0x8(%ebp),%esi
  800409:	eb 14                	jmp    80041f <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8d 40 04             	lea    0x4(%eax),%eax
  800419:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80041f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800423:	79 89                	jns    8003ae <vprintfmt+0x43>
				width = precision, precision = -1;
  800425:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800428:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800432:	e9 77 ff ff ff       	jmp    8003ae <vprintfmt+0x43>
  800437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043a:	85 c0                	test   %eax,%eax
  80043c:	0f 48 c1             	cmovs  %ecx,%eax
  80043f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800442:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800445:	e9 64 ff ff ff       	jmp    8003ae <vprintfmt+0x43>
  80044a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800454:	e9 55 ff ff ff       	jmp    8003ae <vprintfmt+0x43>
			lflag++;
  800459:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800460:	e9 49 ff ff ff       	jmp    8003ae <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8d 78 04             	lea    0x4(%eax),%edi
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	53                   	push   %ebx
  80046f:	ff 30                	pushl  (%eax)
  800471:	ff d6                	call   *%esi
			break;
  800473:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800476:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800479:	e9 33 03 00 00       	jmp    8007b1 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 78 04             	lea    0x4(%eax),%edi
  800484:	8b 00                	mov    (%eax),%eax
  800486:	99                   	cltd   
  800487:	31 d0                	xor    %edx,%eax
  800489:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048b:	83 f8 11             	cmp    $0x11,%eax
  80048e:	7f 23                	jg     8004b3 <vprintfmt+0x148>
  800490:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	74 18                	je     8004b3 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80049b:	52                   	push   %edx
  80049c:	68 1d 2b 80 00       	push   $0x802b1d
  8004a1:	53                   	push   %ebx
  8004a2:	56                   	push   %esi
  8004a3:	e8 a6 fe ff ff       	call   80034e <printfmt>
  8004a8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ab:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ae:	e9 fe 02 00 00       	jmp    8007b1 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b3:	50                   	push   %eax
  8004b4:	68 cd 26 80 00       	push   $0x8026cd
  8004b9:	53                   	push   %ebx
  8004ba:	56                   	push   %esi
  8004bb:	e8 8e fe ff ff       	call   80034e <printfmt>
  8004c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c6:	e9 e6 02 00 00       	jmp    8007b1 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	83 c0 04             	add    $0x4,%eax
  8004d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d9:	85 c9                	test   %ecx,%ecx
  8004db:	b8 c6 26 80 00       	mov    $0x8026c6,%eax
  8004e0:	0f 45 c1             	cmovne %ecx,%eax
  8004e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ea:	7e 06                	jle    8004f2 <vprintfmt+0x187>
  8004ec:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004f0:	75 0d                	jne    8004ff <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f5:	89 c7                	mov    %eax,%edi
  8004f7:	03 45 e0             	add    -0x20(%ebp),%eax
  8004fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fd:	eb 53                	jmp    800552 <vprintfmt+0x1e7>
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	ff 75 d8             	pushl  -0x28(%ebp)
  800505:	50                   	push   %eax
  800506:	e8 71 04 00 00       	call   80097c <strnlen>
  80050b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050e:	29 c1                	sub    %eax,%ecx
  800510:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800513:	83 c4 10             	add    $0x10,%esp
  800516:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800518:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051f:	eb 0f                	jmp    800530 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	53                   	push   %ebx
  800525:	ff 75 e0             	pushl  -0x20(%ebp)
  800528:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	83 ef 01             	sub    $0x1,%edi
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	85 ff                	test   %edi,%edi
  800532:	7f ed                	jg     800521 <vprintfmt+0x1b6>
  800534:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800537:	85 c9                	test   %ecx,%ecx
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	0f 49 c1             	cmovns %ecx,%eax
  800541:	29 c1                	sub    %eax,%ecx
  800543:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800546:	eb aa                	jmp    8004f2 <vprintfmt+0x187>
					putch(ch, putdat);
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	53                   	push   %ebx
  80054c:	52                   	push   %edx
  80054d:	ff d6                	call   *%esi
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800555:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800557:	83 c7 01             	add    $0x1,%edi
  80055a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055e:	0f be d0             	movsbl %al,%edx
  800561:	85 d2                	test   %edx,%edx
  800563:	74 4b                	je     8005b0 <vprintfmt+0x245>
  800565:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800569:	78 06                	js     800571 <vprintfmt+0x206>
  80056b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056f:	78 1e                	js     80058f <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800571:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800575:	74 d1                	je     800548 <vprintfmt+0x1dd>
  800577:	0f be c0             	movsbl %al,%eax
  80057a:	83 e8 20             	sub    $0x20,%eax
  80057d:	83 f8 5e             	cmp    $0x5e,%eax
  800580:	76 c6                	jbe    800548 <vprintfmt+0x1dd>
					putch('?', putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	53                   	push   %ebx
  800586:	6a 3f                	push   $0x3f
  800588:	ff d6                	call   *%esi
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	eb c3                	jmp    800552 <vprintfmt+0x1e7>
  80058f:	89 cf                	mov    %ecx,%edi
  800591:	eb 0e                	jmp    8005a1 <vprintfmt+0x236>
				putch(' ', putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	6a 20                	push   $0x20
  800599:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80059b:	83 ef 01             	sub    $0x1,%edi
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	85 ff                	test   %edi,%edi
  8005a3:	7f ee                	jg     800593 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ab:	e9 01 02 00 00       	jmp    8007b1 <vprintfmt+0x446>
  8005b0:	89 cf                	mov    %ecx,%edi
  8005b2:	eb ed                	jmp    8005a1 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005b7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005be:	e9 eb fd ff ff       	jmp    8003ae <vprintfmt+0x43>
	if (lflag >= 2)
  8005c3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c7:	7f 21                	jg     8005ea <vprintfmt+0x27f>
	else if (lflag)
  8005c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cd:	74 68                	je     800637 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb 17                	jmp    800601 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800601:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800607:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80060d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800611:	78 3f                	js     800652 <vprintfmt+0x2e7>
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800618:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80061c:	0f 84 71 01 00 00    	je     800793 <vprintfmt+0x428>
				putch('+', putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	53                   	push   %ebx
  800626:	6a 2b                	push   $0x2b
  800628:	ff d6                	call   *%esi
  80062a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	e9 5c 01 00 00       	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063f:	89 c1                	mov    %eax,%ecx
  800641:	c1 f9 1f             	sar    $0x1f,%ecx
  800644:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
  800650:	eb af                	jmp    800601 <vprintfmt+0x296>
				putch('-', putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	6a 2d                	push   $0x2d
  800658:	ff d6                	call   *%esi
				num = -(long long) num;
  80065a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800660:	f7 d8                	neg    %eax
  800662:	83 d2 00             	adc    $0x0,%edx
  800665:	f7 da                	neg    %edx
  800667:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800670:	b8 0a 00 00 00       	mov    $0xa,%eax
  800675:	e9 19 01 00 00       	jmp    800793 <vprintfmt+0x428>
	if (lflag >= 2)
  80067a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067e:	7f 29                	jg     8006a9 <vprintfmt+0x33e>
	else if (lflag)
  800680:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800684:	74 44                	je     8006ca <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	ba 00 00 00 00       	mov    $0x0,%edx
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a4:	e9 ea 00 00 00       	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8b 50 04             	mov    0x4(%eax),%edx
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 08             	lea    0x8(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c5:	e9 c9 00 00 00       	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e8:	e9 a6 00 00 00       	jmp    800793 <vprintfmt+0x428>
			putch('0', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 30                	push   $0x30
  8006f3:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fc:	7f 26                	jg     800724 <vprintfmt+0x3b9>
	else if (lflag)
  8006fe:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800702:	74 3e                	je     800742 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	ba 00 00 00 00       	mov    $0x0,%edx
  80070e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800711:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071d:	b8 08 00 00 00       	mov    $0x8,%eax
  800722:	eb 6f                	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 50 04             	mov    0x4(%eax),%edx
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800732:	8b 45 14             	mov    0x14(%ebp),%eax
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073b:	b8 08 00 00 00       	mov    $0x8,%eax
  800740:	eb 51                	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075b:	b8 08 00 00 00       	mov    $0x8,%eax
  800760:	eb 31                	jmp    800793 <vprintfmt+0x428>
			putch('0', putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	6a 30                	push   $0x30
  800768:	ff d6                	call   *%esi
			putch('x', putdat);
  80076a:	83 c4 08             	add    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 78                	push   $0x78
  800770:	ff d6                	call   *%esi
			num = (unsigned long long)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	ba 00 00 00 00       	mov    $0x0,%edx
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800782:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 40 04             	lea    0x4(%eax),%eax
  80078b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800793:	83 ec 0c             	sub    $0xc,%esp
  800796:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80079a:	52                   	push   %edx
  80079b:	ff 75 e0             	pushl  -0x20(%ebp)
  80079e:	50                   	push   %eax
  80079f:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a5:	89 da                	mov    %ebx,%edx
  8007a7:	89 f0                	mov    %esi,%eax
  8007a9:	e8 a4 fa ff ff       	call   800252 <printnum>
			break;
  8007ae:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b4:	83 c7 01             	add    $0x1,%edi
  8007b7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007bb:	83 f8 25             	cmp    $0x25,%eax
  8007be:	0f 84 be fb ff ff    	je     800382 <vprintfmt+0x17>
			if (ch == '\0')
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	0f 84 28 01 00 00    	je     8008f4 <vprintfmt+0x589>
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	50                   	push   %eax
  8007d1:	ff d6                	call   *%esi
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	eb dc                	jmp    8007b4 <vprintfmt+0x449>
	if (lflag >= 2)
  8007d8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007dc:	7f 26                	jg     800804 <vprintfmt+0x499>
	else if (lflag)
  8007de:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e2:	74 41                	je     800825 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	8d 40 04             	lea    0x4(%eax),%eax
  8007fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fd:	b8 10 00 00 00       	mov    $0x10,%eax
  800802:	eb 8f                	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	8b 50 04             	mov    0x4(%eax),%edx
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
  800820:	e9 6e ff ff ff       	jmp    800793 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	ba 00 00 00 00       	mov    $0x0,%edx
  80082f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800832:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8d 40 04             	lea    0x4(%eax),%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083e:	b8 10 00 00 00       	mov    $0x10,%eax
  800843:	e9 4b ff ff ff       	jmp    800793 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 c0 04             	add    $0x4,%eax
  80084e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 14                	je     80086e <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80085a:	8b 13                	mov    (%ebx),%edx
  80085c:	83 fa 7f             	cmp    $0x7f,%edx
  80085f:	7f 37                	jg     800898 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800861:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800863:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
  800869:	e9 43 ff ff ff       	jmp    8007b1 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80086e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800873:	bf e9 27 80 00       	mov    $0x8027e9,%edi
							putch(ch, putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	50                   	push   %eax
  80087d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80087f:	83 c7 01             	add    $0x1,%edi
  800882:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	85 c0                	test   %eax,%eax
  80088b:	75 eb                	jne    800878 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80088d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800890:	89 45 14             	mov    %eax,0x14(%ebp)
  800893:	e9 19 ff ff ff       	jmp    8007b1 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800898:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80089a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089f:	bf 21 28 80 00       	mov    $0x802821,%edi
							putch(ch, putdat);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	53                   	push   %ebx
  8008a8:	50                   	push   %eax
  8008a9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ab:	83 c7 01             	add    $0x1,%edi
  8008ae:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	75 eb                	jne    8008a4 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bf:	e9 ed fe ff ff       	jmp    8007b1 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c4:	83 ec 08             	sub    $0x8,%esp
  8008c7:	53                   	push   %ebx
  8008c8:	6a 25                	push   $0x25
  8008ca:	ff d6                	call   *%esi
			break;
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	e9 dd fe ff ff       	jmp    8007b1 <vprintfmt+0x446>
			putch('%', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 25                	push   $0x25
  8008da:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 f8                	mov    %edi,%eax
  8008e1:	eb 03                	jmp    8008e6 <vprintfmt+0x57b>
  8008e3:	83 e8 01             	sub    $0x1,%eax
  8008e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008ea:	75 f7                	jne    8008e3 <vprintfmt+0x578>
  8008ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ef:	e9 bd fe ff ff       	jmp    8007b1 <vprintfmt+0x446>
}
  8008f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5e                   	pop    %esi
  8008f9:	5f                   	pop    %edi
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 18             	sub    $0x18,%esp
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800908:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80090f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800919:	85 c0                	test   %eax,%eax
  80091b:	74 26                	je     800943 <vsnprintf+0x47>
  80091d:	85 d2                	test   %edx,%edx
  80091f:	7e 22                	jle    800943 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800921:	ff 75 14             	pushl  0x14(%ebp)
  800924:	ff 75 10             	pushl  0x10(%ebp)
  800927:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092a:	50                   	push   %eax
  80092b:	68 31 03 80 00       	push   $0x800331
  800930:	e8 36 fa ff ff       	call   80036b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800935:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800938:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093e:	83 c4 10             	add    $0x10,%esp
}
  800941:	c9                   	leave  
  800942:	c3                   	ret    
		return -E_INVAL;
  800943:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800948:	eb f7                	jmp    800941 <vsnprintf+0x45>

0080094a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800950:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800953:	50                   	push   %eax
  800954:	ff 75 10             	pushl  0x10(%ebp)
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 9a ff ff ff       	call   8008fc <vsnprintf>
	va_end(ap);

	return rc;
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80096a:	b8 00 00 00 00       	mov    $0x0,%eax
  80096f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800973:	74 05                	je     80097a <strlen+0x16>
		n++;
  800975:	83 c0 01             	add    $0x1,%eax
  800978:	eb f5                	jmp    80096f <strlen+0xb>
	return n;
}
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	ba 00 00 00 00       	mov    $0x0,%edx
  80098a:	39 c2                	cmp    %eax,%edx
  80098c:	74 0d                	je     80099b <strnlen+0x1f>
  80098e:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800992:	74 05                	je     800999 <strnlen+0x1d>
		n++;
  800994:	83 c2 01             	add    $0x1,%edx
  800997:	eb f1                	jmp    80098a <strnlen+0xe>
  800999:	89 d0                	mov    %edx,%eax
	return n;
}
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	53                   	push   %ebx
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ac:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009b0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	84 c9                	test   %cl,%cl
  8009b8:	75 f2                	jne    8009ac <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009ba:	5b                   	pop    %ebx
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    

008009bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	53                   	push   %ebx
  8009c1:	83 ec 10             	sub    $0x10,%esp
  8009c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c7:	53                   	push   %ebx
  8009c8:	e8 97 ff ff ff       	call   800964 <strlen>
  8009cd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	01 d8                	add    %ebx,%eax
  8009d5:	50                   	push   %eax
  8009d6:	e8 c2 ff ff ff       	call   80099d <strcpy>
	return dst;
}
  8009db:	89 d8                	mov    %ebx,%eax
  8009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e0:	c9                   	leave  
  8009e1:	c3                   	ret    

008009e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	56                   	push   %esi
  8009e6:	53                   	push   %ebx
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	89 c6                	mov    %eax,%esi
  8009ef:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f2:	89 c2                	mov    %eax,%edx
  8009f4:	39 f2                	cmp    %esi,%edx
  8009f6:	74 11                	je     800a09 <strncpy+0x27>
		*dst++ = *src;
  8009f8:	83 c2 01             	add    $0x1,%edx
  8009fb:	0f b6 19             	movzbl (%ecx),%ebx
  8009fe:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a01:	80 fb 01             	cmp    $0x1,%bl
  800a04:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a07:	eb eb                	jmp    8009f4 <strncpy+0x12>
	}
	return ret;
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5e                   	pop    %esi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 75 08             	mov    0x8(%ebp),%esi
  800a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a18:	8b 55 10             	mov    0x10(%ebp),%edx
  800a1b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1d:	85 d2                	test   %edx,%edx
  800a1f:	74 21                	je     800a42 <strlcpy+0x35>
  800a21:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a25:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	74 14                	je     800a3f <strlcpy+0x32>
  800a2b:	0f b6 19             	movzbl (%ecx),%ebx
  800a2e:	84 db                	test   %bl,%bl
  800a30:	74 0b                	je     800a3d <strlcpy+0x30>
			*dst++ = *src++;
  800a32:	83 c1 01             	add    $0x1,%ecx
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3b:	eb ea                	jmp    800a27 <strlcpy+0x1a>
  800a3d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a3f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a42:	29 f0                	sub    %esi,%eax
}
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a51:	0f b6 01             	movzbl (%ecx),%eax
  800a54:	84 c0                	test   %al,%al
  800a56:	74 0c                	je     800a64 <strcmp+0x1c>
  800a58:	3a 02                	cmp    (%edx),%al
  800a5a:	75 08                	jne    800a64 <strcmp+0x1c>
		p++, q++;
  800a5c:	83 c1 01             	add    $0x1,%ecx
  800a5f:	83 c2 01             	add    $0x1,%edx
  800a62:	eb ed                	jmp    800a51 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a64:	0f b6 c0             	movzbl %al,%eax
  800a67:	0f b6 12             	movzbl (%edx),%edx
  800a6a:	29 d0                	sub    %edx,%eax
}
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	53                   	push   %ebx
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a78:	89 c3                	mov    %eax,%ebx
  800a7a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7d:	eb 06                	jmp    800a85 <strncmp+0x17>
		n--, p++, q++;
  800a7f:	83 c0 01             	add    $0x1,%eax
  800a82:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a85:	39 d8                	cmp    %ebx,%eax
  800a87:	74 16                	je     800a9f <strncmp+0x31>
  800a89:	0f b6 08             	movzbl (%eax),%ecx
  800a8c:	84 c9                	test   %cl,%cl
  800a8e:	74 04                	je     800a94 <strncmp+0x26>
  800a90:	3a 0a                	cmp    (%edx),%cl
  800a92:	74 eb                	je     800a7f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a94:	0f b6 00             	movzbl (%eax),%eax
  800a97:	0f b6 12             	movzbl (%edx),%edx
  800a9a:	29 d0                	sub    %edx,%eax
}
  800a9c:	5b                   	pop    %ebx
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    
		return 0;
  800a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa4:	eb f6                	jmp    800a9c <strncmp+0x2e>

00800aa6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab0:	0f b6 10             	movzbl (%eax),%edx
  800ab3:	84 d2                	test   %dl,%dl
  800ab5:	74 09                	je     800ac0 <strchr+0x1a>
		if (*s == c)
  800ab7:	38 ca                	cmp    %cl,%dl
  800ab9:	74 0a                	je     800ac5 <strchr+0x1f>
	for (; *s; s++)
  800abb:	83 c0 01             	add    $0x1,%eax
  800abe:	eb f0                	jmp    800ab0 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad4:	38 ca                	cmp    %cl,%dl
  800ad6:	74 09                	je     800ae1 <strfind+0x1a>
  800ad8:	84 d2                	test   %dl,%dl
  800ada:	74 05                	je     800ae1 <strfind+0x1a>
	for (; *s; s++)
  800adc:	83 c0 01             	add    $0x1,%eax
  800adf:	eb f0                	jmp    800ad1 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aef:	85 c9                	test   %ecx,%ecx
  800af1:	74 31                	je     800b24 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af3:	89 f8                	mov    %edi,%eax
  800af5:	09 c8                	or     %ecx,%eax
  800af7:	a8 03                	test   $0x3,%al
  800af9:	75 23                	jne    800b1e <memset+0x3b>
		c &= 0xFF;
  800afb:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aff:	89 d3                	mov    %edx,%ebx
  800b01:	c1 e3 08             	shl    $0x8,%ebx
  800b04:	89 d0                	mov    %edx,%eax
  800b06:	c1 e0 18             	shl    $0x18,%eax
  800b09:	89 d6                	mov    %edx,%esi
  800b0b:	c1 e6 10             	shl    $0x10,%esi
  800b0e:	09 f0                	or     %esi,%eax
  800b10:	09 c2                	or     %eax,%edx
  800b12:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b14:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b17:	89 d0                	mov    %edx,%eax
  800b19:	fc                   	cld    
  800b1a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1c:	eb 06                	jmp    800b24 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	fc                   	cld    
  800b22:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b24:	89 f8                	mov    %edi,%eax
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b39:	39 c6                	cmp    %eax,%esi
  800b3b:	73 32                	jae    800b6f <memmove+0x44>
  800b3d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b40:	39 c2                	cmp    %eax,%edx
  800b42:	76 2b                	jbe    800b6f <memmove+0x44>
		s += n;
		d += n;
  800b44:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b47:	89 fe                	mov    %edi,%esi
  800b49:	09 ce                	or     %ecx,%esi
  800b4b:	09 d6                	or     %edx,%esi
  800b4d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b53:	75 0e                	jne    800b63 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b55:	83 ef 04             	sub    $0x4,%edi
  800b58:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5e:	fd                   	std    
  800b5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b61:	eb 09                	jmp    800b6c <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b63:	83 ef 01             	sub    $0x1,%edi
  800b66:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b69:	fd                   	std    
  800b6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6c:	fc                   	cld    
  800b6d:	eb 1a                	jmp    800b89 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	09 ca                	or     %ecx,%edx
  800b73:	09 f2                	or     %esi,%edx
  800b75:	f6 c2 03             	test   $0x3,%dl
  800b78:	75 0a                	jne    800b84 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7d:	89 c7                	mov    %eax,%edi
  800b7f:	fc                   	cld    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b82:	eb 05                	jmp    800b89 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b84:	89 c7                	mov    %eax,%edi
  800b86:	fc                   	cld    
  800b87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b93:	ff 75 10             	pushl  0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 8a ff ff ff       	call   800b2b <memmove>
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bae:	89 c6                	mov    %eax,%esi
  800bb0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb3:	39 f0                	cmp    %esi,%eax
  800bb5:	74 1c                	je     800bd3 <memcmp+0x30>
		if (*s1 != *s2)
  800bb7:	0f b6 08             	movzbl (%eax),%ecx
  800bba:	0f b6 1a             	movzbl (%edx),%ebx
  800bbd:	38 d9                	cmp    %bl,%cl
  800bbf:	75 08                	jne    800bc9 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc1:	83 c0 01             	add    $0x1,%eax
  800bc4:	83 c2 01             	add    $0x1,%edx
  800bc7:	eb ea                	jmp    800bb3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc9:	0f b6 c1             	movzbl %cl,%eax
  800bcc:	0f b6 db             	movzbl %bl,%ebx
  800bcf:	29 d8                	sub    %ebx,%eax
  800bd1:	eb 05                	jmp    800bd8 <memcmp+0x35>
	}

	return 0;
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd8:	5b                   	pop    %ebx
  800bd9:	5e                   	pop    %esi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be5:	89 c2                	mov    %eax,%edx
  800be7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bea:	39 d0                	cmp    %edx,%eax
  800bec:	73 09                	jae    800bf7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bee:	38 08                	cmp    %cl,(%eax)
  800bf0:	74 05                	je     800bf7 <memfind+0x1b>
	for (; s < ends; s++)
  800bf2:	83 c0 01             	add    $0x1,%eax
  800bf5:	eb f3                	jmp    800bea <memfind+0xe>
			break;
	return (void *) s;
}
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    

00800bf9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c05:	eb 03                	jmp    800c0a <strtol+0x11>
		s++;
  800c07:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c0a:	0f b6 01             	movzbl (%ecx),%eax
  800c0d:	3c 20                	cmp    $0x20,%al
  800c0f:	74 f6                	je     800c07 <strtol+0xe>
  800c11:	3c 09                	cmp    $0x9,%al
  800c13:	74 f2                	je     800c07 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c15:	3c 2b                	cmp    $0x2b,%al
  800c17:	74 2a                	je     800c43 <strtol+0x4a>
	int neg = 0;
  800c19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1e:	3c 2d                	cmp    $0x2d,%al
  800c20:	74 2b                	je     800c4d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c28:	75 0f                	jne    800c39 <strtol+0x40>
  800c2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2d:	74 28                	je     800c57 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2f:	85 db                	test   %ebx,%ebx
  800c31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c36:	0f 44 d8             	cmove  %eax,%ebx
  800c39:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c41:	eb 50                	jmp    800c93 <strtol+0x9a>
		s++;
  800c43:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c46:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4b:	eb d5                	jmp    800c22 <strtol+0x29>
		s++, neg = 1;
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	bf 01 00 00 00       	mov    $0x1,%edi
  800c55:	eb cb                	jmp    800c22 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c57:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c5b:	74 0e                	je     800c6b <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c5d:	85 db                	test   %ebx,%ebx
  800c5f:	75 d8                	jne    800c39 <strtol+0x40>
		s++, base = 8;
  800c61:	83 c1 01             	add    $0x1,%ecx
  800c64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c69:	eb ce                	jmp    800c39 <strtol+0x40>
		s += 2, base = 16;
  800c6b:	83 c1 02             	add    $0x2,%ecx
  800c6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c73:	eb c4                	jmp    800c39 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c78:	89 f3                	mov    %esi,%ebx
  800c7a:	80 fb 19             	cmp    $0x19,%bl
  800c7d:	77 29                	ja     800ca8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c7f:	0f be d2             	movsbl %dl,%edx
  800c82:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c85:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c88:	7d 30                	jge    800cba <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c8a:	83 c1 01             	add    $0x1,%ecx
  800c8d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c91:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c93:	0f b6 11             	movzbl (%ecx),%edx
  800c96:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c99:	89 f3                	mov    %esi,%ebx
  800c9b:	80 fb 09             	cmp    $0x9,%bl
  800c9e:	77 d5                	ja     800c75 <strtol+0x7c>
			dig = *s - '0';
  800ca0:	0f be d2             	movsbl %dl,%edx
  800ca3:	83 ea 30             	sub    $0x30,%edx
  800ca6:	eb dd                	jmp    800c85 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ca8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cab:	89 f3                	mov    %esi,%ebx
  800cad:	80 fb 19             	cmp    $0x19,%bl
  800cb0:	77 08                	ja     800cba <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb2:	0f be d2             	movsbl %dl,%edx
  800cb5:	83 ea 37             	sub    $0x37,%edx
  800cb8:	eb cb                	jmp    800c85 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbe:	74 05                	je     800cc5 <strtol+0xcc>
		*endptr = (char *) s;
  800cc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc5:	89 c2                	mov    %eax,%edx
  800cc7:	f7 da                	neg    %edx
  800cc9:	85 ff                	test   %edi,%edi
  800ccb:	0f 45 c2             	cmovne %edx,%eax
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	89 c3                	mov    %eax,%ebx
  800ce6:	89 c7                	mov    %eax,%edi
  800ce8:	89 c6                	mov    %eax,%esi
  800cea:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  800d01:	89 d1                	mov    %edx,%ecx
  800d03:	89 d3                	mov    %edx,%ebx
  800d05:	89 d7                	mov    %edx,%edi
  800d07:	89 d6                	mov    %edx,%esi
  800d09:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    

00800d10 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	b8 03 00 00 00       	mov    $0x3,%eax
  800d26:	89 cb                	mov    %ecx,%ebx
  800d28:	89 cf                	mov    %ecx,%edi
  800d2a:	89 ce                	mov    %ecx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 03                	push   $0x3
  800d40:	68 48 2a 80 00       	push   $0x802a48
  800d45:	6a 43                	push   $0x43
  800d47:	68 65 2a 80 00       	push   $0x802a65
  800d4c:	e8 89 14 00 00       	call   8021da <_panic>

00800d51 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d57:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5c:	b8 02 00 00 00       	mov    $0x2,%eax
  800d61:	89 d1                	mov    %edx,%ecx
  800d63:	89 d3                	mov    %edx,%ebx
  800d65:	89 d7                	mov    %edx,%edi
  800d67:	89 d6                	mov    %edx,%esi
  800d69:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <sys_yield>:

void
sys_yield(void)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d76:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d80:	89 d1                	mov    %edx,%ecx
  800d82:	89 d3                	mov    %edx,%ebx
  800d84:	89 d7                	mov    %edx,%edi
  800d86:	89 d6                	mov    %edx,%esi
  800d88:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d98:	be 00 00 00 00       	mov    $0x0,%esi
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	b8 04 00 00 00       	mov    $0x4,%eax
  800da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dab:	89 f7                	mov    %esi,%edi
  800dad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 04                	push   $0x4
  800dc1:	68 48 2a 80 00       	push   $0x802a48
  800dc6:	6a 43                	push   $0x43
  800dc8:	68 65 2a 80 00       	push   $0x802a65
  800dcd:	e8 08 14 00 00       	call   8021da <_panic>

00800dd2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 05 00 00 00       	mov    $0x5,%eax
  800de6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dec:	8b 75 18             	mov    0x18(%ebp),%esi
  800def:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 05                	push   $0x5
  800e03:	68 48 2a 80 00       	push   $0x802a48
  800e08:	6a 43                	push   $0x43
  800e0a:	68 65 2a 80 00       	push   $0x802a65
  800e0f:	e8 c6 13 00 00       	call   8021da <_panic>

00800e14 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	8b 55 08             	mov    0x8(%ebp),%edx
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2d:	89 df                	mov    %ebx,%edi
  800e2f:	89 de                	mov    %ebx,%esi
  800e31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e33:	85 c0                	test   %eax,%eax
  800e35:	7f 08                	jg     800e3f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	50                   	push   %eax
  800e43:	6a 06                	push   $0x6
  800e45:	68 48 2a 80 00       	push   $0x802a48
  800e4a:	6a 43                	push   $0x43
  800e4c:	68 65 2a 80 00       	push   $0x802a65
  800e51:	e8 84 13 00 00       	call   8021da <_panic>

00800e56 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
  800e5c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e6f:	89 df                	mov    %ebx,%edi
  800e71:	89 de                	mov    %ebx,%esi
  800e73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	7f 08                	jg     800e81 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7c:	5b                   	pop    %ebx
  800e7d:	5e                   	pop    %esi
  800e7e:	5f                   	pop    %edi
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	6a 08                	push   $0x8
  800e87:	68 48 2a 80 00       	push   $0x802a48
  800e8c:	6a 43                	push   $0x43
  800e8e:	68 65 2a 80 00       	push   $0x802a65
  800e93:	e8 42 13 00 00       	call   8021da <_panic>

00800e98 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	57                   	push   %edi
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eac:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb1:	89 df                	mov    %ebx,%edi
  800eb3:	89 de                	mov    %ebx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 09                	push   $0x9
  800ec9:	68 48 2a 80 00       	push   $0x802a48
  800ece:	6a 43                	push   $0x43
  800ed0:	68 65 2a 80 00       	push   $0x802a65
  800ed5:	e8 00 13 00 00       	call   8021da <_panic>

00800eda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7f 08                	jg     800f05 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f00:	5b                   	pop    %ebx
  800f01:	5e                   	pop    %esi
  800f02:	5f                   	pop    %edi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f05:	83 ec 0c             	sub    $0xc,%esp
  800f08:	50                   	push   %eax
  800f09:	6a 0a                	push   $0xa
  800f0b:	68 48 2a 80 00       	push   $0x802a48
  800f10:	6a 43                	push   $0x43
  800f12:	68 65 2a 80 00       	push   $0x802a65
  800f17:	e8 be 12 00 00       	call   8021da <_panic>

00800f1c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f22:	8b 55 08             	mov    0x8(%ebp),%edx
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2d:	be 00 00 00 00       	mov    $0x0,%esi
  800f32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f38:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f55:	89 cb                	mov    %ecx,%ebx
  800f57:	89 cf                	mov    %ecx,%edi
  800f59:	89 ce                	mov    %ecx,%esi
  800f5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7f 08                	jg     800f69 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 0d                	push   $0xd
  800f6f:	68 48 2a 80 00       	push   $0x802a48
  800f74:	6a 43                	push   $0x43
  800f76:	68 65 2a 80 00       	push   $0x802a65
  800f7b:	e8 5a 12 00 00       	call   8021da <_panic>

00800f80 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	57                   	push   %edi
  800f84:	56                   	push   %esi
  800f85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f96:	89 df                	mov    %ebx,%edi
  800f98:	89 de                	mov    %ebx,%esi
  800f9a:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb4:	89 cb                	mov    %ecx,%ebx
  800fb6:	89 cf                	mov    %ecx,%edi
  800fb8:	89 ce                	mov    %ecx,%esi
  800fba:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcc:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd1:	89 d1                	mov    %edx,%ecx
  800fd3:	89 d3                	mov    %edx,%ebx
  800fd5:	89 d7                	mov    %edx,%edi
  800fd7:	89 d6                	mov    %edx,%esi
  800fd9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
	asm volatile("int %1\n"
  801007:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100c:	8b 55 08             	mov    0x8(%ebp),%edx
  80100f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801012:	b8 12 00 00 00       	mov    $0x12,%eax
  801017:	89 df                	mov    %ebx,%edi
  801019:	89 de                	mov    %ebx,%esi
  80101b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
  801028:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	b8 13 00 00 00       	mov    $0x13,%eax
  80103b:	89 df                	mov    %ebx,%edi
  80103d:	89 de                	mov    %ebx,%esi
  80103f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801041:	85 c0                	test   %eax,%eax
  801043:	7f 08                	jg     80104d <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801045:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	50                   	push   %eax
  801051:	6a 13                	push   $0x13
  801053:	68 48 2a 80 00       	push   $0x802a48
  801058:	6a 43                	push   $0x43
  80105a:	68 65 2a 80 00       	push   $0x802a65
  80105f:	e8 76 11 00 00       	call   8021da <_panic>

00801064 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	b8 14 00 00 00       	mov    $0x14,%eax
  801077:	89 cb                	mov    %ecx,%ebx
  801079:	89 cf                	mov    %ecx,%edi
  80107b:	89 ce                	mov    %ecx,%esi
  80107d:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	05 00 00 00 30       	add    $0x30000000,%eax
  80108f:	c1 e8 0c             	shr    $0xc,%eax
}
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80109f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	c1 ea 16             	shr    $0x16,%edx
  8010b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	74 2d                	je     8010f1 <fd_alloc+0x46>
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	c1 ea 0c             	shr    $0xc,%edx
  8010c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d0:	f6 c2 01             	test   $0x1,%dl
  8010d3:	74 1c                	je     8010f1 <fd_alloc+0x46>
  8010d5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010da:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010df:	75 d2                	jne    8010b3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010ea:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ef:	eb 0a                	jmp    8010fb <fd_alloc+0x50>
			*fd_store = fd;
  8010f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801103:	83 f8 1f             	cmp    $0x1f,%eax
  801106:	77 30                	ja     801138 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801108:	c1 e0 0c             	shl    $0xc,%eax
  80110b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801110:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801116:	f6 c2 01             	test   $0x1,%dl
  801119:	74 24                	je     80113f <fd_lookup+0x42>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	c1 ea 0c             	shr    $0xc,%edx
  801120:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	74 1a                	je     801146 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80112c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112f:	89 02                	mov    %eax,(%edx)
	return 0;
  801131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    
		return -E_INVAL;
  801138:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113d:	eb f7                	jmp    801136 <fd_lookup+0x39>
		return -E_INVAL;
  80113f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801144:	eb f0                	jmp    801136 <fd_lookup+0x39>
  801146:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114b:	eb e9                	jmp    801136 <fd_lookup+0x39>

0080114d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801156:	ba 00 00 00 00       	mov    $0x0,%edx
  80115b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801160:	39 08                	cmp    %ecx,(%eax)
  801162:	74 38                	je     80119c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801164:	83 c2 01             	add    $0x1,%edx
  801167:	8b 04 95 f0 2a 80 00 	mov    0x802af0(,%edx,4),%eax
  80116e:	85 c0                	test   %eax,%eax
  801170:	75 ee                	jne    801160 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801172:	a1 08 40 80 00       	mov    0x804008,%eax
  801177:	8b 40 48             	mov    0x48(%eax),%eax
  80117a:	83 ec 04             	sub    $0x4,%esp
  80117d:	51                   	push   %ecx
  80117e:	50                   	push   %eax
  80117f:	68 74 2a 80 00       	push   $0x802a74
  801184:	e8 b5 f0 ff ff       	call   80023e <cprintf>
	*dev = 0;
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801192:	83 c4 10             	add    $0x10,%esp
  801195:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    
			*dev = devtab[i];
  80119c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119f:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	eb f2                	jmp    80119a <dev_lookup+0x4d>

008011a8 <fd_close>:
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 24             	sub    $0x24,%esp
  8011b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011b4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ba:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c4:	50                   	push   %eax
  8011c5:	e8 33 ff ff ff       	call   8010fd <fd_lookup>
  8011ca:	89 c3                	mov    %eax,%ebx
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 05                	js     8011d8 <fd_close+0x30>
	    || fd != fd2)
  8011d3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011d6:	74 16                	je     8011ee <fd_close+0x46>
		return (must_exist ? r : 0);
  8011d8:	89 f8                	mov    %edi,%eax
  8011da:	84 c0                	test   %al,%al
  8011dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e1:	0f 44 d8             	cmove  %eax,%ebx
}
  8011e4:	89 d8                	mov    %ebx,%eax
  8011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e9:	5b                   	pop    %ebx
  8011ea:	5e                   	pop    %esi
  8011eb:	5f                   	pop    %edi
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011f4:	50                   	push   %eax
  8011f5:	ff 36                	pushl  (%esi)
  8011f7:	e8 51 ff ff ff       	call   80114d <dev_lookup>
  8011fc:	89 c3                	mov    %eax,%ebx
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	78 1a                	js     80121f <fd_close+0x77>
		if (dev->dev_close)
  801205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801208:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80120b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801210:	85 c0                	test   %eax,%eax
  801212:	74 0b                	je     80121f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801214:	83 ec 0c             	sub    $0xc,%esp
  801217:	56                   	push   %esi
  801218:	ff d0                	call   *%eax
  80121a:	89 c3                	mov    %eax,%ebx
  80121c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80121f:	83 ec 08             	sub    $0x8,%esp
  801222:	56                   	push   %esi
  801223:	6a 00                	push   $0x0
  801225:	e8 ea fb ff ff       	call   800e14 <sys_page_unmap>
	return r;
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	eb b5                	jmp    8011e4 <fd_close+0x3c>

0080122f <close>:

int
close(int fdnum)
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
  801232:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	ff 75 08             	pushl  0x8(%ebp)
  80123c:	e8 bc fe ff ff       	call   8010fd <fd_lookup>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	79 02                	jns    80124a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    
		return fd_close(fd, 1);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	6a 01                	push   $0x1
  80124f:	ff 75 f4             	pushl  -0xc(%ebp)
  801252:	e8 51 ff ff ff       	call   8011a8 <fd_close>
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	eb ec                	jmp    801248 <close+0x19>

0080125c <close_all>:

void
close_all(void)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	53                   	push   %ebx
  801260:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801263:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801268:	83 ec 0c             	sub    $0xc,%esp
  80126b:	53                   	push   %ebx
  80126c:	e8 be ff ff ff       	call   80122f <close>
	for (i = 0; i < MAXFD; i++)
  801271:	83 c3 01             	add    $0x1,%ebx
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	83 fb 20             	cmp    $0x20,%ebx
  80127a:	75 ec                	jne    801268 <close_all+0xc>
}
  80127c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80128a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128d:	50                   	push   %eax
  80128e:	ff 75 08             	pushl  0x8(%ebp)
  801291:	e8 67 fe ff ff       	call   8010fd <fd_lookup>
  801296:	89 c3                	mov    %eax,%ebx
  801298:	83 c4 10             	add    $0x10,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	0f 88 81 00 00 00    	js     801324 <dup+0xa3>
		return r;
	close(newfdnum);
  8012a3:	83 ec 0c             	sub    $0xc,%esp
  8012a6:	ff 75 0c             	pushl  0xc(%ebp)
  8012a9:	e8 81 ff ff ff       	call   80122f <close>

	newfd = INDEX2FD(newfdnum);
  8012ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012b1:	c1 e6 0c             	shl    $0xc,%esi
  8012b4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012ba:	83 c4 04             	add    $0x4,%esp
  8012bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012c0:	e8 cf fd ff ff       	call   801094 <fd2data>
  8012c5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012c7:	89 34 24             	mov    %esi,(%esp)
  8012ca:	e8 c5 fd ff ff       	call   801094 <fd2data>
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012d4:	89 d8                	mov    %ebx,%eax
  8012d6:	c1 e8 16             	shr    $0x16,%eax
  8012d9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012e0:	a8 01                	test   $0x1,%al
  8012e2:	74 11                	je     8012f5 <dup+0x74>
  8012e4:	89 d8                	mov    %ebx,%eax
  8012e6:	c1 e8 0c             	shr    $0xc,%eax
  8012e9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012f0:	f6 c2 01             	test   $0x1,%dl
  8012f3:	75 39                	jne    80132e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012f8:	89 d0                	mov    %edx,%eax
  8012fa:	c1 e8 0c             	shr    $0xc,%eax
  8012fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	25 07 0e 00 00       	and    $0xe07,%eax
  80130c:	50                   	push   %eax
  80130d:	56                   	push   %esi
  80130e:	6a 00                	push   $0x0
  801310:	52                   	push   %edx
  801311:	6a 00                	push   $0x0
  801313:	e8 ba fa ff ff       	call   800dd2 <sys_page_map>
  801318:	89 c3                	mov    %eax,%ebx
  80131a:	83 c4 20             	add    $0x20,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 31                	js     801352 <dup+0xd1>
		goto err;

	return newfdnum;
  801321:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801324:	89 d8                	mov    %ebx,%eax
  801326:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5f                   	pop    %edi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80132e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	25 07 0e 00 00       	and    $0xe07,%eax
  80133d:	50                   	push   %eax
  80133e:	57                   	push   %edi
  80133f:	6a 00                	push   $0x0
  801341:	53                   	push   %ebx
  801342:	6a 00                	push   $0x0
  801344:	e8 89 fa ff ff       	call   800dd2 <sys_page_map>
  801349:	89 c3                	mov    %eax,%ebx
  80134b:	83 c4 20             	add    $0x20,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	79 a3                	jns    8012f5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	56                   	push   %esi
  801356:	6a 00                	push   $0x0
  801358:	e8 b7 fa ff ff       	call   800e14 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80135d:	83 c4 08             	add    $0x8,%esp
  801360:	57                   	push   %edi
  801361:	6a 00                	push   $0x0
  801363:	e8 ac fa ff ff       	call   800e14 <sys_page_unmap>
	return r;
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	eb b7                	jmp    801324 <dup+0xa3>

0080136d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	53                   	push   %ebx
  801371:	83 ec 1c             	sub    $0x1c,%esp
  801374:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801377:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137a:	50                   	push   %eax
  80137b:	53                   	push   %ebx
  80137c:	e8 7c fd ff ff       	call   8010fd <fd_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 3f                	js     8013c7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801392:	ff 30                	pushl  (%eax)
  801394:	e8 b4 fd ff ff       	call   80114d <dev_lookup>
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 27                	js     8013c7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a3:	8b 42 08             	mov    0x8(%edx),%eax
  8013a6:	83 e0 03             	and    $0x3,%eax
  8013a9:	83 f8 01             	cmp    $0x1,%eax
  8013ac:	74 1e                	je     8013cc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b1:	8b 40 08             	mov    0x8(%eax),%eax
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	74 35                	je     8013ed <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	ff 75 10             	pushl  0x10(%ebp)
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	52                   	push   %edx
  8013c2:	ff d0                	call   *%eax
  8013c4:	83 c4 10             	add    $0x10,%esp
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d1:	8b 40 48             	mov    0x48(%eax),%eax
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	50                   	push   %eax
  8013d9:	68 b5 2a 80 00       	push   $0x802ab5
  8013de:	e8 5b ee ff ff       	call   80023e <cprintf>
		return -E_INVAL;
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb da                	jmp    8013c7 <read+0x5a>
		return -E_NOT_SUPP;
  8013ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f2:	eb d3                	jmp    8013c7 <read+0x5a>

008013f4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801400:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801403:	bb 00 00 00 00       	mov    $0x0,%ebx
  801408:	39 f3                	cmp    %esi,%ebx
  80140a:	73 23                	jae    80142f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	89 f0                	mov    %esi,%eax
  801411:	29 d8                	sub    %ebx,%eax
  801413:	50                   	push   %eax
  801414:	89 d8                	mov    %ebx,%eax
  801416:	03 45 0c             	add    0xc(%ebp),%eax
  801419:	50                   	push   %eax
  80141a:	57                   	push   %edi
  80141b:	e8 4d ff ff ff       	call   80136d <read>
		if (m < 0)
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	85 c0                	test   %eax,%eax
  801425:	78 06                	js     80142d <readn+0x39>
			return m;
		if (m == 0)
  801427:	74 06                	je     80142f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801429:	01 c3                	add    %eax,%ebx
  80142b:	eb db                	jmp    801408 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80142f:	89 d8                	mov    %ebx,%eax
  801431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801434:	5b                   	pop    %ebx
  801435:	5e                   	pop    %esi
  801436:	5f                   	pop    %edi
  801437:	5d                   	pop    %ebp
  801438:	c3                   	ret    

00801439 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	53                   	push   %ebx
  80143d:	83 ec 1c             	sub    $0x1c,%esp
  801440:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801443:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	53                   	push   %ebx
  801448:	e8 b0 fc ff ff       	call   8010fd <fd_lookup>
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 3a                	js     80148e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145a:	50                   	push   %eax
  80145b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145e:	ff 30                	pushl  (%eax)
  801460:	e8 e8 fc ff ff       	call   80114d <dev_lookup>
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 22                	js     80148e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801473:	74 1e                	je     801493 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801478:	8b 52 0c             	mov    0xc(%edx),%edx
  80147b:	85 d2                	test   %edx,%edx
  80147d:	74 35                	je     8014b4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	ff 75 10             	pushl  0x10(%ebp)
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	50                   	push   %eax
  801489:	ff d2                	call   *%edx
  80148b:	83 c4 10             	add    $0x10,%esp
}
  80148e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801491:	c9                   	leave  
  801492:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801493:	a1 08 40 80 00       	mov    0x804008,%eax
  801498:	8b 40 48             	mov    0x48(%eax),%eax
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	53                   	push   %ebx
  80149f:	50                   	push   %eax
  8014a0:	68 d1 2a 80 00       	push   $0x802ad1
  8014a5:	e8 94 ed ff ff       	call   80023e <cprintf>
		return -E_INVAL;
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b2:	eb da                	jmp    80148e <write+0x55>
		return -E_NOT_SUPP;
  8014b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b9:	eb d3                	jmp    80148e <write+0x55>

008014bb <seek>:

int
seek(int fdnum, off_t offset)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c4:	50                   	push   %eax
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	e8 30 fc ff ff       	call   8010fd <fd_lookup>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	78 0e                	js     8014e2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014da:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 1c             	sub    $0x1c,%esp
  8014eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	53                   	push   %ebx
  8014f3:	e8 05 fc ff ff       	call   8010fd <fd_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 37                	js     801536 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	ff 30                	pushl  (%eax)
  80150b:	e8 3d fc ff ff       	call   80114d <dev_lookup>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 1f                	js     801536 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151e:	74 1b                	je     80153b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801523:	8b 52 18             	mov    0x18(%edx),%edx
  801526:	85 d2                	test   %edx,%edx
  801528:	74 32                	je     80155c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80152a:	83 ec 08             	sub    $0x8,%esp
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	50                   	push   %eax
  801531:	ff d2                	call   *%edx
  801533:	83 c4 10             	add    $0x10,%esp
}
  801536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801539:	c9                   	leave  
  80153a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80153b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801540:	8b 40 48             	mov    0x48(%eax),%eax
  801543:	83 ec 04             	sub    $0x4,%esp
  801546:	53                   	push   %ebx
  801547:	50                   	push   %eax
  801548:	68 94 2a 80 00       	push   $0x802a94
  80154d:	e8 ec ec ff ff       	call   80023e <cprintf>
		return -E_INVAL;
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155a:	eb da                	jmp    801536 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80155c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801561:	eb d3                	jmp    801536 <ftruncate+0x52>

00801563 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	53                   	push   %ebx
  801567:	83 ec 1c             	sub    $0x1c,%esp
  80156a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801570:	50                   	push   %eax
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	e8 84 fb ff ff       	call   8010fd <fd_lookup>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 4b                	js     8015cb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	ff 30                	pushl  (%eax)
  80158c:	e8 bc fb ff ff       	call   80114d <dev_lookup>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	85 c0                	test   %eax,%eax
  801596:	78 33                	js     8015cb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80159f:	74 2f                	je     8015d0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015a1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015ab:	00 00 00 
	stat->st_isdir = 0;
  8015ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015b5:	00 00 00 
	stat->st_dev = dev;
  8015b8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	53                   	push   %ebx
  8015c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c5:	ff 50 14             	call   *0x14(%eax)
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    
		return -E_NOT_SUPP;
  8015d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015d5:	eb f4                	jmp    8015cb <fstat+0x68>

008015d7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	56                   	push   %esi
  8015db:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	e8 22 02 00 00       	call   80180b <open>
  8015e9:	89 c3                	mov    %eax,%ebx
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 1b                	js     80160d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	ff 75 0c             	pushl  0xc(%ebp)
  8015f8:	50                   	push   %eax
  8015f9:	e8 65 ff ff ff       	call   801563 <fstat>
  8015fe:	89 c6                	mov    %eax,%esi
	close(fd);
  801600:	89 1c 24             	mov    %ebx,(%esp)
  801603:	e8 27 fc ff ff       	call   80122f <close>
	return r;
  801608:	83 c4 10             	add    $0x10,%esp
  80160b:	89 f3                	mov    %esi,%ebx
}
  80160d:	89 d8                	mov    %ebx,%eax
  80160f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801612:	5b                   	pop    %ebx
  801613:	5e                   	pop    %esi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	89 c6                	mov    %eax,%esi
  80161d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80161f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801626:	74 27                	je     80164f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801628:	6a 07                	push   $0x7
  80162a:	68 00 50 80 00       	push   $0x805000
  80162f:	56                   	push   %esi
  801630:	ff 35 00 40 80 00    	pushl  0x804000
  801636:	e8 69 0c 00 00       	call   8022a4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80163b:	83 c4 0c             	add    $0xc,%esp
  80163e:	6a 00                	push   $0x0
  801640:	53                   	push   %ebx
  801641:	6a 00                	push   $0x0
  801643:	e8 f3 0b 00 00       	call   80223b <ipc_recv>
}
  801648:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	5d                   	pop    %ebp
  80164e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	6a 01                	push   $0x1
  801654:	e8 a3 0c 00 00       	call   8022fc <ipc_find_env>
  801659:	a3 00 40 80 00       	mov    %eax,0x804000
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	eb c5                	jmp    801628 <fsipc+0x12>

00801663 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8b 40 0c             	mov    0xc(%eax),%eax
  80166f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b8 02 00 00 00       	mov    $0x2,%eax
  801686:	e8 8b ff ff ff       	call   801616 <fsipc>
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <devfile_flush>:
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	8b 40 0c             	mov    0xc(%eax),%eax
  801699:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	b8 06 00 00 00       	mov    $0x6,%eax
  8016a8:	e8 69 ff ff ff       	call   801616 <fsipc>
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <devfile_stat>:
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	53                   	push   %ebx
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ce:	e8 43 ff ff ff       	call   801616 <fsipc>
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 2c                	js     801703 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016d7:	83 ec 08             	sub    $0x8,%esp
  8016da:	68 00 50 80 00       	push   $0x805000
  8016df:	53                   	push   %ebx
  8016e0:	e8 b8 f2 ff ff       	call   80099d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016e5:	a1 80 50 80 00       	mov    0x805080,%eax
  8016ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016f0:	a1 84 50 80 00       	mov    0x805084,%eax
  8016f5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <devfile_write>:
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	53                   	push   %ebx
  80170c:	83 ec 08             	sub    $0x8,%esp
  80170f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8b 40 0c             	mov    0xc(%eax),%eax
  801718:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80171d:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801723:	53                   	push   %ebx
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	68 08 50 80 00       	push   $0x805008
  80172c:	e8 5c f4 ff ff       	call   800b8d <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	b8 04 00 00 00       	mov    $0x4,%eax
  80173b:	e8 d6 fe ff ff       	call   801616 <fsipc>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 0b                	js     801752 <devfile_write+0x4a>
	assert(r <= n);
  801747:	39 d8                	cmp    %ebx,%eax
  801749:	77 0c                	ja     801757 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80174b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801750:	7f 1e                	jg     801770 <devfile_write+0x68>
}
  801752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801755:	c9                   	leave  
  801756:	c3                   	ret    
	assert(r <= n);
  801757:	68 04 2b 80 00       	push   $0x802b04
  80175c:	68 0b 2b 80 00       	push   $0x802b0b
  801761:	68 98 00 00 00       	push   $0x98
  801766:	68 20 2b 80 00       	push   $0x802b20
  80176b:	e8 6a 0a 00 00       	call   8021da <_panic>
	assert(r <= PGSIZE);
  801770:	68 2b 2b 80 00       	push   $0x802b2b
  801775:	68 0b 2b 80 00       	push   $0x802b0b
  80177a:	68 99 00 00 00       	push   $0x99
  80177f:	68 20 2b 80 00       	push   $0x802b20
  801784:	e8 51 0a 00 00       	call   8021da <_panic>

00801789 <devfile_read>:
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8b 40 0c             	mov    0xc(%eax),%eax
  801797:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80179c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ac:	e8 65 fe ff ff       	call   801616 <fsipc>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 1f                	js     8017d6 <devfile_read+0x4d>
	assert(r <= n);
  8017b7:	39 f0                	cmp    %esi,%eax
  8017b9:	77 24                	ja     8017df <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017bb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017c0:	7f 33                	jg     8017f5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	50                   	push   %eax
  8017c6:	68 00 50 80 00       	push   $0x805000
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	e8 58 f3 ff ff       	call   800b2b <memmove>
	return r;
  8017d3:	83 c4 10             	add    $0x10,%esp
}
  8017d6:	89 d8                	mov    %ebx,%eax
  8017d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5d                   	pop    %ebp
  8017de:	c3                   	ret    
	assert(r <= n);
  8017df:	68 04 2b 80 00       	push   $0x802b04
  8017e4:	68 0b 2b 80 00       	push   $0x802b0b
  8017e9:	6a 7c                	push   $0x7c
  8017eb:	68 20 2b 80 00       	push   $0x802b20
  8017f0:	e8 e5 09 00 00       	call   8021da <_panic>
	assert(r <= PGSIZE);
  8017f5:	68 2b 2b 80 00       	push   $0x802b2b
  8017fa:	68 0b 2b 80 00       	push   $0x802b0b
  8017ff:	6a 7d                	push   $0x7d
  801801:	68 20 2b 80 00       	push   $0x802b20
  801806:	e8 cf 09 00 00       	call   8021da <_panic>

0080180b <open>:
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	83 ec 1c             	sub    $0x1c,%esp
  801813:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801816:	56                   	push   %esi
  801817:	e8 48 f1 ff ff       	call   800964 <strlen>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801824:	7f 6c                	jg     801892 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	e8 79 f8 ff ff       	call   8010ab <fd_alloc>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	85 c0                	test   %eax,%eax
  801839:	78 3c                	js     801877 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	56                   	push   %esi
  80183f:	68 00 50 80 00       	push   $0x805000
  801844:	e8 54 f1 ff ff       	call   80099d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801854:	b8 01 00 00 00       	mov    $0x1,%eax
  801859:	e8 b8 fd ff ff       	call   801616 <fsipc>
  80185e:	89 c3                	mov    %eax,%ebx
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	78 19                	js     801880 <open+0x75>
	return fd2num(fd);
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	ff 75 f4             	pushl  -0xc(%ebp)
  80186d:	e8 12 f8 ff ff       	call   801084 <fd2num>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 10             	add    $0x10,%esp
}
  801877:	89 d8                	mov    %ebx,%eax
  801879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    
		fd_close(fd, 0);
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	6a 00                	push   $0x0
  801885:	ff 75 f4             	pushl  -0xc(%ebp)
  801888:	e8 1b f9 ff ff       	call   8011a8 <fd_close>
		return r;
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	eb e5                	jmp    801877 <open+0x6c>
		return -E_BAD_PATH;
  801892:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801897:	eb de                	jmp    801877 <open+0x6c>

00801899 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80189f:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a9:	e8 68 fd ff ff       	call   801616 <fsipc>
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018b6:	68 37 2b 80 00       	push   $0x802b37
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	e8 da f0 ff ff       	call   80099d <strcpy>
	return 0;
}
  8018c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <devsock_close>:
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	53                   	push   %ebx
  8018ce:	83 ec 10             	sub    $0x10,%esp
  8018d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018d4:	53                   	push   %ebx
  8018d5:	e8 61 0a 00 00       	call   80233b <pageref>
  8018da:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018dd:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018e2:	83 f8 01             	cmp    $0x1,%eax
  8018e5:	74 07                	je     8018ee <devsock_close+0x24>
}
  8018e7:	89 d0                	mov    %edx,%eax
  8018e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	ff 73 0c             	pushl  0xc(%ebx)
  8018f4:	e8 b9 02 00 00       	call   801bb2 <nsipc_close>
  8018f9:	89 c2                	mov    %eax,%edx
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	eb e7                	jmp    8018e7 <devsock_close+0x1d>

00801900 <devsock_write>:
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801906:	6a 00                	push   $0x0
  801908:	ff 75 10             	pushl  0x10(%ebp)
  80190b:	ff 75 0c             	pushl  0xc(%ebp)
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	ff 70 0c             	pushl  0xc(%eax)
  801914:	e8 76 03 00 00       	call   801c8f <nsipc_send>
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <devsock_read>:
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801921:	6a 00                	push   $0x0
  801923:	ff 75 10             	pushl  0x10(%ebp)
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	ff 70 0c             	pushl  0xc(%eax)
  80192f:	e8 ef 02 00 00       	call   801c23 <nsipc_recv>
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <fd2sockid>:
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80193c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80193f:	52                   	push   %edx
  801940:	50                   	push   %eax
  801941:	e8 b7 f7 ff ff       	call   8010fd <fd_lookup>
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	85 c0                	test   %eax,%eax
  80194b:	78 10                	js     80195d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801956:	39 08                	cmp    %ecx,(%eax)
  801958:	75 05                	jne    80195f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80195a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    
		return -E_NOT_SUPP;
  80195f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801964:	eb f7                	jmp    80195d <fd2sockid+0x27>

00801966 <alloc_sockfd>:
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	83 ec 1c             	sub    $0x1c,%esp
  80196e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801970:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801973:	50                   	push   %eax
  801974:	e8 32 f7 ff ff       	call   8010ab <fd_alloc>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 43                	js     8019c5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	68 07 04 00 00       	push   $0x407
  80198a:	ff 75 f4             	pushl  -0xc(%ebp)
  80198d:	6a 00                	push   $0x0
  80198f:	e8 fb f3 ff ff       	call   800d8f <sys_page_alloc>
  801994:	89 c3                	mov    %eax,%ebx
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 28                	js     8019c5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019a6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019b2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	50                   	push   %eax
  8019b9:	e8 c6 f6 ff ff       	call   801084 <fd2num>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	eb 0c                	jmp    8019d1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	56                   	push   %esi
  8019c9:	e8 e4 01 00 00       	call   801bb2 <nsipc_close>
		return r;
  8019ce:	83 c4 10             	add    $0x10,%esp
}
  8019d1:	89 d8                	mov    %ebx,%eax
  8019d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5e                   	pop    %esi
  8019d8:	5d                   	pop    %ebp
  8019d9:	c3                   	ret    

008019da <accept>:
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	e8 4e ff ff ff       	call   801936 <fd2sockid>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 1b                	js     801a07 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ec:	83 ec 04             	sub    $0x4,%esp
  8019ef:	ff 75 10             	pushl  0x10(%ebp)
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	50                   	push   %eax
  8019f6:	e8 0e 01 00 00       	call   801b09 <nsipc_accept>
  8019fb:	83 c4 10             	add    $0x10,%esp
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 05                	js     801a07 <accept+0x2d>
	return alloc_sockfd(r);
  801a02:	e8 5f ff ff ff       	call   801966 <alloc_sockfd>
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <bind>:
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	e8 1f ff ff ff       	call   801936 <fd2sockid>
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 12                	js     801a2d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	ff 75 10             	pushl  0x10(%ebp)
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	50                   	push   %eax
  801a25:	e8 31 01 00 00       	call   801b5b <nsipc_bind>
  801a2a:	83 c4 10             	add    $0x10,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <shutdown>:
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	e8 f9 fe ff ff       	call   801936 <fd2sockid>
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	78 0f                	js     801a50 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	e8 43 01 00 00       	call   801b90 <nsipc_shutdown>
  801a4d:	83 c4 10             	add    $0x10,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <connect>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	e8 d6 fe ff ff       	call   801936 <fd2sockid>
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 12                	js     801a76 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	50                   	push   %eax
  801a6e:	e8 59 01 00 00       	call   801bcc <nsipc_connect>
  801a73:	83 c4 10             	add    $0x10,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <listen>:
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	e8 b0 fe ff ff       	call   801936 <fd2sockid>
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 0f                	js     801a99 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	50                   	push   %eax
  801a91:	e8 6b 01 00 00       	call   801c01 <nsipc_listen>
  801a96:	83 c4 10             	add    $0x10,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <socket>:

int
socket(int domain, int type, int protocol)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	e8 3e 02 00 00       	call   801ced <nsipc_socket>
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	78 05                	js     801abb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ab6:	e8 ab fe ff ff       	call   801966 <alloc_sockfd>
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	53                   	push   %ebx
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ac6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801acd:	74 26                	je     801af5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801acf:	6a 07                	push   $0x7
  801ad1:	68 00 60 80 00       	push   $0x806000
  801ad6:	53                   	push   %ebx
  801ad7:	ff 35 04 40 80 00    	pushl  0x804004
  801add:	e8 c2 07 00 00       	call   8022a4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ae2:	83 c4 0c             	add    $0xc,%esp
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 4b 07 00 00       	call   80223b <ipc_recv>
}
  801af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	6a 02                	push   $0x2
  801afa:	e8 fd 07 00 00       	call   8022fc <ipc_find_env>
  801aff:	a3 04 40 80 00       	mov    %eax,0x804004
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	eb c6                	jmp    801acf <nsipc+0x12>

00801b09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b19:	8b 06                	mov    (%esi),%eax
  801b1b:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b20:	b8 01 00 00 00       	mov    $0x1,%eax
  801b25:	e8 93 ff ff ff       	call   801abd <nsipc>
  801b2a:	89 c3                	mov    %eax,%ebx
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	79 09                	jns    801b39 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b39:	83 ec 04             	sub    $0x4,%esp
  801b3c:	ff 35 10 60 80 00    	pushl  0x806010
  801b42:	68 00 60 80 00       	push   $0x806000
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	e8 dc ef ff ff       	call   800b2b <memmove>
		*addrlen = ret->ret_addrlen;
  801b4f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b54:	89 06                	mov    %eax,(%esi)
  801b56:	83 c4 10             	add    $0x10,%esp
	return r;
  801b59:	eb d5                	jmp    801b30 <nsipc_accept+0x27>

00801b5b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	53                   	push   %ebx
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b6d:	53                   	push   %ebx
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	68 04 60 80 00       	push   $0x806004
  801b76:	e8 b0 ef ff ff       	call   800b2b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b7b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b81:	b8 02 00 00 00       	mov    $0x2,%eax
  801b86:	e8 32 ff ff ff       	call   801abd <nsipc>
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ba6:	b8 03 00 00 00       	mov    $0x3,%eax
  801bab:	e8 0d ff ff ff       	call   801abd <nsipc>
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <nsipc_close>:

int
nsipc_close(int s)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bc0:	b8 04 00 00 00       	mov    $0x4,%eax
  801bc5:	e8 f3 fe ff ff       	call   801abd <nsipc>
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 08             	sub    $0x8,%esp
  801bd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bde:	53                   	push   %ebx
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	68 04 60 80 00       	push   $0x806004
  801be7:	e8 3f ef ff ff       	call   800b2b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bec:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bf2:	b8 05 00 00 00       	mov    $0x5,%eax
  801bf7:	e8 c1 fe ff ff       	call   801abd <nsipc>
}
  801bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c17:	b8 06 00 00 00       	mov    $0x6,%eax
  801c1c:	e8 9c fe ff ff       	call   801abd <nsipc>
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c33:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c39:	8b 45 14             	mov    0x14(%ebp),%eax
  801c3c:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c41:	b8 07 00 00 00       	mov    $0x7,%eax
  801c46:	e8 72 fe ff ff       	call   801abd <nsipc>
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 1f                	js     801c70 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c51:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c56:	7f 21                	jg     801c79 <nsipc_recv+0x56>
  801c58:	39 c6                	cmp    %eax,%esi
  801c5a:	7c 1d                	jl     801c79 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	50                   	push   %eax
  801c60:	68 00 60 80 00       	push   $0x806000
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	e8 be ee ff ff       	call   800b2b <memmove>
  801c6d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c79:	68 43 2b 80 00       	push   $0x802b43
  801c7e:	68 0b 2b 80 00       	push   $0x802b0b
  801c83:	6a 62                	push   $0x62
  801c85:	68 58 2b 80 00       	push   $0x802b58
  801c8a:	e8 4b 05 00 00       	call   8021da <_panic>

00801c8f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	53                   	push   %ebx
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ca1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ca7:	7f 2e                	jg     801cd7 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ca9:	83 ec 04             	sub    $0x4,%esp
  801cac:	53                   	push   %ebx
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	68 0c 60 80 00       	push   $0x80600c
  801cb5:	e8 71 ee ff ff       	call   800b2b <memmove>
	nsipcbuf.send.req_size = size;
  801cba:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cc8:	b8 08 00 00 00       	mov    $0x8,%eax
  801ccd:	e8 eb fd ff ff       	call   801abd <nsipc>
}
  801cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    
	assert(size < 1600);
  801cd7:	68 64 2b 80 00       	push   $0x802b64
  801cdc:	68 0b 2b 80 00       	push   $0x802b0b
  801ce1:	6a 6d                	push   $0x6d
  801ce3:	68 58 2b 80 00       	push   $0x802b58
  801ce8:	e8 ed 04 00 00       	call   8021da <_panic>

00801ced <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d03:	8b 45 10             	mov    0x10(%ebp),%eax
  801d06:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d0b:	b8 09 00 00 00       	mov    $0x9,%eax
  801d10:	e8 a8 fd ff ff       	call   801abd <nsipc>
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	56                   	push   %esi
  801d1b:	53                   	push   %ebx
  801d1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	e8 6a f3 ff ff       	call   801094 <fd2data>
  801d2a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d2c:	83 c4 08             	add    $0x8,%esp
  801d2f:	68 70 2b 80 00       	push   $0x802b70
  801d34:	53                   	push   %ebx
  801d35:	e8 63 ec ff ff       	call   80099d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d3a:	8b 46 04             	mov    0x4(%esi),%eax
  801d3d:	2b 06                	sub    (%esi),%eax
  801d3f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d45:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d4c:	00 00 00 
	stat->st_dev = &devpipe;
  801d4f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d56:	30 80 00 
	return 0;
}
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    

00801d65 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	53                   	push   %ebx
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d6f:	53                   	push   %ebx
  801d70:	6a 00                	push   $0x0
  801d72:	e8 9d f0 ff ff       	call   800e14 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d77:	89 1c 24             	mov    %ebx,(%esp)
  801d7a:	e8 15 f3 ff ff       	call   801094 <fd2data>
  801d7f:	83 c4 08             	add    $0x8,%esp
  801d82:	50                   	push   %eax
  801d83:	6a 00                	push   $0x0
  801d85:	e8 8a f0 ff ff       	call   800e14 <sys_page_unmap>
}
  801d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <_pipeisclosed>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	57                   	push   %edi
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 1c             	sub    $0x1c,%esp
  801d98:	89 c7                	mov    %eax,%edi
  801d9a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d9c:	a1 08 40 80 00       	mov    0x804008,%eax
  801da1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	57                   	push   %edi
  801da8:	e8 8e 05 00 00       	call   80233b <pageref>
  801dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801db0:	89 34 24             	mov    %esi,(%esp)
  801db3:	e8 83 05 00 00       	call   80233b <pageref>
		nn = thisenv->env_runs;
  801db8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801dbe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	39 cb                	cmp    %ecx,%ebx
  801dc6:	74 1b                	je     801de3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dc8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dcb:	75 cf                	jne    801d9c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dcd:	8b 42 58             	mov    0x58(%edx),%eax
  801dd0:	6a 01                	push   $0x1
  801dd2:	50                   	push   %eax
  801dd3:	53                   	push   %ebx
  801dd4:	68 77 2b 80 00       	push   $0x802b77
  801dd9:	e8 60 e4 ff ff       	call   80023e <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	eb b9                	jmp    801d9c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801de3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de6:	0f 94 c0             	sete   %al
  801de9:	0f b6 c0             	movzbl %al,%eax
}
  801dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <devpipe_write>:
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	57                   	push   %edi
  801df8:	56                   	push   %esi
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 28             	sub    $0x28,%esp
  801dfd:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e00:	56                   	push   %esi
  801e01:	e8 8e f2 ff ff       	call   801094 <fd2data>
  801e06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e10:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e13:	74 4f                	je     801e64 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e15:	8b 43 04             	mov    0x4(%ebx),%eax
  801e18:	8b 0b                	mov    (%ebx),%ecx
  801e1a:	8d 51 20             	lea    0x20(%ecx),%edx
  801e1d:	39 d0                	cmp    %edx,%eax
  801e1f:	72 14                	jb     801e35 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e21:	89 da                	mov    %ebx,%edx
  801e23:	89 f0                	mov    %esi,%eax
  801e25:	e8 65 ff ff ff       	call   801d8f <_pipeisclosed>
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	75 3b                	jne    801e69 <devpipe_write+0x75>
			sys_yield();
  801e2e:	e8 3d ef ff ff       	call   800d70 <sys_yield>
  801e33:	eb e0                	jmp    801e15 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e38:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e3c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e3f:	89 c2                	mov    %eax,%edx
  801e41:	c1 fa 1f             	sar    $0x1f,%edx
  801e44:	89 d1                	mov    %edx,%ecx
  801e46:	c1 e9 1b             	shr    $0x1b,%ecx
  801e49:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e4c:	83 e2 1f             	and    $0x1f,%edx
  801e4f:	29 ca                	sub    %ecx,%edx
  801e51:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e55:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e59:	83 c0 01             	add    $0x1,%eax
  801e5c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e5f:	83 c7 01             	add    $0x1,%edi
  801e62:	eb ac                	jmp    801e10 <devpipe_write+0x1c>
	return i;
  801e64:	8b 45 10             	mov    0x10(%ebp),%eax
  801e67:	eb 05                	jmp    801e6e <devpipe_write+0x7a>
				return 0;
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <devpipe_read>:
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	57                   	push   %edi
  801e7a:	56                   	push   %esi
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 18             	sub    $0x18,%esp
  801e7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e82:	57                   	push   %edi
  801e83:	e8 0c f2 ff ff       	call   801094 <fd2data>
  801e88:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	be 00 00 00 00       	mov    $0x0,%esi
  801e92:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e95:	75 14                	jne    801eab <devpipe_read+0x35>
	return i;
  801e97:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9a:	eb 02                	jmp    801e9e <devpipe_read+0x28>
				return i;
  801e9c:	89 f0                	mov    %esi,%eax
}
  801e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea1:	5b                   	pop    %ebx
  801ea2:	5e                   	pop    %esi
  801ea3:	5f                   	pop    %edi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    
			sys_yield();
  801ea6:	e8 c5 ee ff ff       	call   800d70 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801eab:	8b 03                	mov    (%ebx),%eax
  801ead:	3b 43 04             	cmp    0x4(%ebx),%eax
  801eb0:	75 18                	jne    801eca <devpipe_read+0x54>
			if (i > 0)
  801eb2:	85 f6                	test   %esi,%esi
  801eb4:	75 e6                	jne    801e9c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801eb6:	89 da                	mov    %ebx,%edx
  801eb8:	89 f8                	mov    %edi,%eax
  801eba:	e8 d0 fe ff ff       	call   801d8f <_pipeisclosed>
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	74 e3                	je     801ea6 <devpipe_read+0x30>
				return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec8:	eb d4                	jmp    801e9e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eca:	99                   	cltd   
  801ecb:	c1 ea 1b             	shr    $0x1b,%edx
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	83 e0 1f             	and    $0x1f,%eax
  801ed3:	29 d0                	sub    %edx,%eax
  801ed5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ee0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ee3:	83 c6 01             	add    $0x1,%esi
  801ee6:	eb aa                	jmp    801e92 <devpipe_read+0x1c>

00801ee8 <pipe>:
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ef0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef3:	50                   	push   %eax
  801ef4:	e8 b2 f1 ff ff       	call   8010ab <fd_alloc>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	0f 88 23 01 00 00    	js     802029 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	68 07 04 00 00       	push   $0x407
  801f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f11:	6a 00                	push   $0x0
  801f13:	e8 77 ee ff ff       	call   800d8f <sys_page_alloc>
  801f18:	89 c3                	mov    %eax,%ebx
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 04 01 00 00    	js     802029 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f2b:	50                   	push   %eax
  801f2c:	e8 7a f1 ff ff       	call   8010ab <fd_alloc>
  801f31:	89 c3                	mov    %eax,%ebx
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	85 c0                	test   %eax,%eax
  801f38:	0f 88 db 00 00 00    	js     802019 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	68 07 04 00 00       	push   $0x407
  801f46:	ff 75 f0             	pushl  -0x10(%ebp)
  801f49:	6a 00                	push   $0x0
  801f4b:	e8 3f ee ff ff       	call   800d8f <sys_page_alloc>
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	0f 88 bc 00 00 00    	js     802019 <pipe+0x131>
	va = fd2data(fd0);
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	ff 75 f4             	pushl  -0xc(%ebp)
  801f63:	e8 2c f1 ff ff       	call   801094 <fd2data>
  801f68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6a:	83 c4 0c             	add    $0xc,%esp
  801f6d:	68 07 04 00 00       	push   $0x407
  801f72:	50                   	push   %eax
  801f73:	6a 00                	push   $0x0
  801f75:	e8 15 ee ff ff       	call   800d8f <sys_page_alloc>
  801f7a:	89 c3                	mov    %eax,%ebx
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	0f 88 82 00 00 00    	js     802009 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8d:	e8 02 f1 ff ff       	call   801094 <fd2data>
  801f92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f99:	50                   	push   %eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	56                   	push   %esi
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 2e ee ff ff       	call   800dd2 <sys_page_map>
  801fa4:	89 c3                	mov    %eax,%ebx
  801fa6:	83 c4 20             	add    $0x20,%esp
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 4e                	js     801ffb <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fad:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd6:	e8 a9 f0 ff ff       	call   801084 <fd2num>
  801fdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fde:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fe0:	83 c4 04             	add    $0x4,%esp
  801fe3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe6:	e8 99 f0 ff ff       	call   801084 <fd2num>
  801feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fee:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff9:	eb 2e                	jmp    802029 <pipe+0x141>
	sys_page_unmap(0, va);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	56                   	push   %esi
  801fff:	6a 00                	push   $0x0
  802001:	e8 0e ee ff ff       	call   800e14 <sys_page_unmap>
  802006:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802009:	83 ec 08             	sub    $0x8,%esp
  80200c:	ff 75 f0             	pushl  -0x10(%ebp)
  80200f:	6a 00                	push   $0x0
  802011:	e8 fe ed ff ff       	call   800e14 <sys_page_unmap>
  802016:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802019:	83 ec 08             	sub    $0x8,%esp
  80201c:	ff 75 f4             	pushl  -0xc(%ebp)
  80201f:	6a 00                	push   $0x0
  802021:	e8 ee ed ff ff       	call   800e14 <sys_page_unmap>
  802026:	83 c4 10             	add    $0x10,%esp
}
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <pipeisclosed>:
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802038:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203b:	50                   	push   %eax
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	e8 b9 f0 ff ff       	call   8010fd <fd_lookup>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	85 c0                	test   %eax,%eax
  802049:	78 18                	js     802063 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	ff 75 f4             	pushl  -0xc(%ebp)
  802051:	e8 3e f0 ff ff       	call   801094 <fd2data>
	return _pipeisclosed(fd, p);
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	e8 2f fd ff ff       	call   801d8f <_pipeisclosed>
  802060:	83 c4 10             	add    $0x10,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	c3                   	ret    

0080206b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802071:	68 8f 2b 80 00       	push   $0x802b8f
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	e8 1f e9 ff ff       	call   80099d <strcpy>
	return 0;
}
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <devcons_write>:
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	57                   	push   %edi
  802089:	56                   	push   %esi
  80208a:	53                   	push   %ebx
  80208b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802091:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802096:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80209c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80209f:	73 31                	jae    8020d2 <devcons_write+0x4d>
		m = n - tot;
  8020a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020a4:	29 f3                	sub    %esi,%ebx
  8020a6:	83 fb 7f             	cmp    $0x7f,%ebx
  8020a9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ae:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	53                   	push   %ebx
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	03 45 0c             	add    0xc(%ebp),%eax
  8020ba:	50                   	push   %eax
  8020bb:	57                   	push   %edi
  8020bc:	e8 6a ea ff ff       	call   800b2b <memmove>
		sys_cputs(buf, m);
  8020c1:	83 c4 08             	add    $0x8,%esp
  8020c4:	53                   	push   %ebx
  8020c5:	57                   	push   %edi
  8020c6:	e8 08 ec ff ff       	call   800cd3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020cb:	01 de                	add    %ebx,%esi
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	eb ca                	jmp    80209c <devcons_write+0x17>
}
  8020d2:	89 f0                	mov    %esi,%eax
  8020d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <devcons_read>:
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 08             	sub    $0x8,%esp
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020eb:	74 21                	je     80210e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020ed:	e8 ff eb ff ff       	call   800cf1 <sys_cgetc>
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 07                	jne    8020fd <devcons_read+0x21>
		sys_yield();
  8020f6:	e8 75 ec ff ff       	call   800d70 <sys_yield>
  8020fb:	eb f0                	jmp    8020ed <devcons_read+0x11>
	if (c < 0)
  8020fd:	78 0f                	js     80210e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020ff:	83 f8 04             	cmp    $0x4,%eax
  802102:	74 0c                	je     802110 <devcons_read+0x34>
	*(char*)vbuf = c;
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	88 02                	mov    %al,(%edx)
	return 1;
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    
		return 0;
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	eb f7                	jmp    80210e <devcons_read+0x32>

00802117 <cputchar>:
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802123:	6a 01                	push   $0x1
  802125:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802128:	50                   	push   %eax
  802129:	e8 a5 eb ff ff       	call   800cd3 <sys_cputs>
}
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <getchar>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802139:	6a 01                	push   $0x1
  80213b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213e:	50                   	push   %eax
  80213f:	6a 00                	push   $0x0
  802141:	e8 27 f2 ff ff       	call   80136d <read>
	if (r < 0)
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 06                	js     802153 <getchar+0x20>
	if (r < 1)
  80214d:	74 06                	je     802155 <getchar+0x22>
	return c;
  80214f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    
		return -E_EOF;
  802155:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80215a:	eb f7                	jmp    802153 <getchar+0x20>

0080215c <iscons>:
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802162:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802165:	50                   	push   %eax
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	e8 8f ef ff ff       	call   8010fd <fd_lookup>
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 11                	js     802186 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80217e:	39 10                	cmp    %edx,(%eax)
  802180:	0f 94 c0             	sete   %al
  802183:	0f b6 c0             	movzbl %al,%eax
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <opencons>:
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80218e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802191:	50                   	push   %eax
  802192:	e8 14 ef ff ff       	call   8010ab <fd_alloc>
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 3a                	js     8021d8 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	68 07 04 00 00       	push   $0x407
  8021a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a9:	6a 00                	push   $0x0
  8021ab:	e8 df eb ff ff       	call   800d8f <sys_page_alloc>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 21                	js     8021d8 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021c0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021cc:	83 ec 0c             	sub    $0xc,%esp
  8021cf:	50                   	push   %eax
  8021d0:	e8 af ee ff ff       	call   801084 <fd2num>
  8021d5:	83 c4 10             	add    $0x10,%esp
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	56                   	push   %esi
  8021de:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021df:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e4:	8b 40 48             	mov    0x48(%eax),%eax
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	68 c0 2b 80 00       	push   $0x802bc0
  8021ef:	50                   	push   %eax
  8021f0:	68 a3 26 80 00       	push   $0x8026a3
  8021f5:	e8 44 e0 ff ff       	call   80023e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021fd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802203:	e8 49 eb ff ff       	call   800d51 <sys_getenvid>
  802208:	83 c4 04             	add    $0x4,%esp
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	56                   	push   %esi
  802212:	50                   	push   %eax
  802213:	68 9c 2b 80 00       	push   $0x802b9c
  802218:	e8 21 e0 ff ff       	call   80023e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80221d:	83 c4 18             	add    $0x18,%esp
  802220:	53                   	push   %ebx
  802221:	ff 75 10             	pushl  0x10(%ebp)
  802224:	e8 c4 df ff ff       	call   8001ed <vcprintf>
	cprintf("\n");
  802229:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  802230:	e8 09 e0 ff ff       	call   80023e <cprintf>
  802235:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802238:	cc                   	int3   
  802239:	eb fd                	jmp    802238 <_panic+0x5e>

0080223b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	56                   	push   %esi
  80223f:	53                   	push   %ebx
  802240:	8b 75 08             	mov    0x8(%ebp),%esi
  802243:	8b 45 0c             	mov    0xc(%ebp),%eax
  802246:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802249:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80224b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802250:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802253:	83 ec 0c             	sub    $0xc,%esp
  802256:	50                   	push   %eax
  802257:	e8 e3 ec ff ff       	call   800f3f <sys_ipc_recv>
	if(ret < 0){
  80225c:	83 c4 10             	add    $0x10,%esp
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 2b                	js     80228e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802263:	85 f6                	test   %esi,%esi
  802265:	74 0a                	je     802271 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802267:	a1 08 40 80 00       	mov    0x804008,%eax
  80226c:	8b 40 78             	mov    0x78(%eax),%eax
  80226f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802271:	85 db                	test   %ebx,%ebx
  802273:	74 0a                	je     80227f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802275:	a1 08 40 80 00       	mov    0x804008,%eax
  80227a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80227d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80227f:	a1 08 40 80 00       	mov    0x804008,%eax
  802284:	8b 40 74             	mov    0x74(%eax),%eax
}
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    
		if(from_env_store)
  80228e:	85 f6                	test   %esi,%esi
  802290:	74 06                	je     802298 <ipc_recv+0x5d>
			*from_env_store = 0;
  802292:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802298:	85 db                	test   %ebx,%ebx
  80229a:	74 eb                	je     802287 <ipc_recv+0x4c>
			*perm_store = 0;
  80229c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022a2:	eb e3                	jmp    802287 <ipc_recv+0x4c>

008022a4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	57                   	push   %edi
  8022a8:	56                   	push   %esi
  8022a9:	53                   	push   %ebx
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022b6:	85 db                	test   %ebx,%ebx
  8022b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022bd:	0f 44 d8             	cmove  %eax,%ebx
  8022c0:	eb 05                	jmp    8022c7 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022c2:	e8 a9 ea ff ff       	call   800d70 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022c7:	ff 75 14             	pushl  0x14(%ebp)
  8022ca:	53                   	push   %ebx
  8022cb:	56                   	push   %esi
  8022cc:	57                   	push   %edi
  8022cd:	e8 4a ec ff ff       	call   800f1c <sys_ipc_try_send>
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 1b                	je     8022f4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022d9:	79 e7                	jns    8022c2 <ipc_send+0x1e>
  8022db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022de:	74 e2                	je     8022c2 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	68 c7 2b 80 00       	push   $0x802bc7
  8022e8:	6a 46                	push   $0x46
  8022ea:	68 dc 2b 80 00       	push   $0x802bdc
  8022ef:	e8 e6 fe ff ff       	call   8021da <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    

008022fc <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802307:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80230d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802313:	8b 52 50             	mov    0x50(%edx),%edx
  802316:	39 ca                	cmp    %ecx,%edx
  802318:	74 11                	je     80232b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80231a:	83 c0 01             	add    $0x1,%eax
  80231d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802322:	75 e3                	jne    802307 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
  802329:	eb 0e                	jmp    802339 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80232b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802331:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802336:	8b 40 48             	mov    0x48(%eax),%eax
}
  802339:	5d                   	pop    %ebp
  80233a:	c3                   	ret    

0080233b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802341:	89 d0                	mov    %edx,%eax
  802343:	c1 e8 16             	shr    $0x16,%eax
  802346:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80234d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802352:	f6 c1 01             	test   $0x1,%cl
  802355:	74 1d                	je     802374 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802357:	c1 ea 0c             	shr    $0xc,%edx
  80235a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802361:	f6 c2 01             	test   $0x1,%dl
  802364:	74 0e                	je     802374 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802366:	c1 ea 0c             	shr    $0xc,%edx
  802369:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802370:	ef 
  802371:	0f b7 c0             	movzwl %ax,%eax
}
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    
  802376:	66 90                	xchg   %ax,%ax
  802378:	66 90                	xchg   %ax,%ax
  80237a:	66 90                	xchg   %ax,%ax
  80237c:	66 90                	xchg   %ax,%ax
  80237e:	66 90                	xchg   %ax,%ax

00802380 <__udivdi3>:
  802380:	55                   	push   %ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 1c             	sub    $0x1c,%esp
  802387:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80238b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80238f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802393:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802397:	85 d2                	test   %edx,%edx
  802399:	75 4d                	jne    8023e8 <__udivdi3+0x68>
  80239b:	39 f3                	cmp    %esi,%ebx
  80239d:	76 19                	jbe    8023b8 <__udivdi3+0x38>
  80239f:	31 ff                	xor    %edi,%edi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f2                	mov    %esi,%edx
  8023a5:	f7 f3                	div    %ebx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 d9                	mov    %ebx,%ecx
  8023ba:	85 db                	test   %ebx,%ebx
  8023bc:	75 0b                	jne    8023c9 <__udivdi3+0x49>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f3                	div    %ebx
  8023c7:	89 c1                	mov    %eax,%ecx
  8023c9:	31 d2                	xor    %edx,%edx
  8023cb:	89 f0                	mov    %esi,%eax
  8023cd:	f7 f1                	div    %ecx
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f7                	mov    %esi,%edi
  8023d5:	f7 f1                	div    %ecx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	39 f2                	cmp    %esi,%edx
  8023ea:	77 1c                	ja     802408 <__udivdi3+0x88>
  8023ec:	0f bd fa             	bsr    %edx,%edi
  8023ef:	83 f7 1f             	xor    $0x1f,%edi
  8023f2:	75 2c                	jne    802420 <__udivdi3+0xa0>
  8023f4:	39 f2                	cmp    %esi,%edx
  8023f6:	72 06                	jb     8023fe <__udivdi3+0x7e>
  8023f8:	31 c0                	xor    %eax,%eax
  8023fa:	39 eb                	cmp    %ebp,%ebx
  8023fc:	77 a9                	ja     8023a7 <__udivdi3+0x27>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	eb a2                	jmp    8023a7 <__udivdi3+0x27>
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	31 ff                	xor    %edi,%edi
  80240a:	31 c0                	xor    %eax,%eax
  80240c:	89 fa                	mov    %edi,%edx
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	89 f9                	mov    %edi,%ecx
  802422:	b8 20 00 00 00       	mov    $0x20,%eax
  802427:	29 f8                	sub    %edi,%eax
  802429:	d3 e2                	shl    %cl,%edx
  80242b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	89 da                	mov    %ebx,%edx
  802433:	d3 ea                	shr    %cl,%edx
  802435:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802439:	09 d1                	or     %edx,%ecx
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 f9                	mov    %edi,%ecx
  802443:	d3 e3                	shl    %cl,%ebx
  802445:	89 c1                	mov    %eax,%ecx
  802447:	d3 ea                	shr    %cl,%edx
  802449:	89 f9                	mov    %edi,%ecx
  80244b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80244f:	89 eb                	mov    %ebp,%ebx
  802451:	d3 e6                	shl    %cl,%esi
  802453:	89 c1                	mov    %eax,%ecx
  802455:	d3 eb                	shr    %cl,%ebx
  802457:	09 de                	or     %ebx,%esi
  802459:	89 f0                	mov    %esi,%eax
  80245b:	f7 74 24 08          	divl   0x8(%esp)
  80245f:	89 d6                	mov    %edx,%esi
  802461:	89 c3                	mov    %eax,%ebx
  802463:	f7 64 24 0c          	mull   0xc(%esp)
  802467:	39 d6                	cmp    %edx,%esi
  802469:	72 15                	jb     802480 <__udivdi3+0x100>
  80246b:	89 f9                	mov    %edi,%ecx
  80246d:	d3 e5                	shl    %cl,%ebp
  80246f:	39 c5                	cmp    %eax,%ebp
  802471:	73 04                	jae    802477 <__udivdi3+0xf7>
  802473:	39 d6                	cmp    %edx,%esi
  802475:	74 09                	je     802480 <__udivdi3+0x100>
  802477:	89 d8                	mov    %ebx,%eax
  802479:	31 ff                	xor    %edi,%edi
  80247b:	e9 27 ff ff ff       	jmp    8023a7 <__udivdi3+0x27>
  802480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802483:	31 ff                	xor    %edi,%edi
  802485:	e9 1d ff ff ff       	jmp    8023a7 <__udivdi3+0x27>
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__umoddi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80249b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80249f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024a7:	89 da                	mov    %ebx,%edx
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	75 43                	jne    8024f0 <__umoddi3+0x60>
  8024ad:	39 df                	cmp    %ebx,%edi
  8024af:	76 17                	jbe    8024c8 <__umoddi3+0x38>
  8024b1:	89 f0                	mov    %esi,%eax
  8024b3:	f7 f7                	div    %edi
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	31 d2                	xor    %edx,%edx
  8024b9:	83 c4 1c             	add    $0x1c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 fd                	mov    %edi,%ebp
  8024ca:	85 ff                	test   %edi,%edi
  8024cc:	75 0b                	jne    8024d9 <__umoddi3+0x49>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f7                	div    %edi
  8024d7:	89 c5                	mov    %eax,%ebp
  8024d9:	89 d8                	mov    %ebx,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	f7 f5                	div    %ebp
  8024df:	89 f0                	mov    %esi,%eax
  8024e1:	f7 f5                	div    %ebp
  8024e3:	89 d0                	mov    %edx,%eax
  8024e5:	eb d0                	jmp    8024b7 <__umoddi3+0x27>
  8024e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ee:	66 90                	xchg   %ax,%ax
  8024f0:	89 f1                	mov    %esi,%ecx
  8024f2:	39 d8                	cmp    %ebx,%eax
  8024f4:	76 0a                	jbe    802500 <__umoddi3+0x70>
  8024f6:	89 f0                	mov    %esi,%eax
  8024f8:	83 c4 1c             	add    $0x1c,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5e                   	pop    %esi
  8024fd:	5f                   	pop    %edi
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    
  802500:	0f bd e8             	bsr    %eax,%ebp
  802503:	83 f5 1f             	xor    $0x1f,%ebp
  802506:	75 20                	jne    802528 <__umoddi3+0x98>
  802508:	39 d8                	cmp    %ebx,%eax
  80250a:	0f 82 b0 00 00 00    	jb     8025c0 <__umoddi3+0x130>
  802510:	39 f7                	cmp    %esi,%edi
  802512:	0f 86 a8 00 00 00    	jbe    8025c0 <__umoddi3+0x130>
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	83 c4 1c             	add    $0x1c,%esp
  80251d:	5b                   	pop    %ebx
  80251e:	5e                   	pop    %esi
  80251f:	5f                   	pop    %edi
  802520:	5d                   	pop    %ebp
  802521:	c3                   	ret    
  802522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	ba 20 00 00 00       	mov    $0x20,%edx
  80252f:	29 ea                	sub    %ebp,%edx
  802531:	d3 e0                	shl    %cl,%eax
  802533:	89 44 24 08          	mov    %eax,0x8(%esp)
  802537:	89 d1                	mov    %edx,%ecx
  802539:	89 f8                	mov    %edi,%eax
  80253b:	d3 e8                	shr    %cl,%eax
  80253d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802541:	89 54 24 04          	mov    %edx,0x4(%esp)
  802545:	8b 54 24 04          	mov    0x4(%esp),%edx
  802549:	09 c1                	or     %eax,%ecx
  80254b:	89 d8                	mov    %ebx,%eax
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 e9                	mov    %ebp,%ecx
  802553:	d3 e7                	shl    %cl,%edi
  802555:	89 d1                	mov    %edx,%ecx
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255f:	d3 e3                	shl    %cl,%ebx
  802561:	89 c7                	mov    %eax,%edi
  802563:	89 d1                	mov    %edx,%ecx
  802565:	89 f0                	mov    %esi,%eax
  802567:	d3 e8                	shr    %cl,%eax
  802569:	89 e9                	mov    %ebp,%ecx
  80256b:	89 fa                	mov    %edi,%edx
  80256d:	d3 e6                	shl    %cl,%esi
  80256f:	09 d8                	or     %ebx,%eax
  802571:	f7 74 24 08          	divl   0x8(%esp)
  802575:	89 d1                	mov    %edx,%ecx
  802577:	89 f3                	mov    %esi,%ebx
  802579:	f7 64 24 0c          	mull   0xc(%esp)
  80257d:	89 c6                	mov    %eax,%esi
  80257f:	89 d7                	mov    %edx,%edi
  802581:	39 d1                	cmp    %edx,%ecx
  802583:	72 06                	jb     80258b <__umoddi3+0xfb>
  802585:	75 10                	jne    802597 <__umoddi3+0x107>
  802587:	39 c3                	cmp    %eax,%ebx
  802589:	73 0c                	jae    802597 <__umoddi3+0x107>
  80258b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80258f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802593:	89 d7                	mov    %edx,%edi
  802595:	89 c6                	mov    %eax,%esi
  802597:	89 ca                	mov    %ecx,%edx
  802599:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80259e:	29 f3                	sub    %esi,%ebx
  8025a0:	19 fa                	sbb    %edi,%edx
  8025a2:	89 d0                	mov    %edx,%eax
  8025a4:	d3 e0                	shl    %cl,%eax
  8025a6:	89 e9                	mov    %ebp,%ecx
  8025a8:	d3 eb                	shr    %cl,%ebx
  8025aa:	d3 ea                	shr    %cl,%edx
  8025ac:	09 d8                	or     %ebx,%eax
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	89 da                	mov    %ebx,%edx
  8025c2:	29 fe                	sub    %edi,%esi
  8025c4:	19 c2                	sbb    %eax,%edx
  8025c6:	89 f1                	mov    %esi,%ecx
  8025c8:	89 c8                	mov    %ecx,%eax
  8025ca:	e9 4b ff ff ff       	jmp    80251a <__umoddi3+0x8a>
