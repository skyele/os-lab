
obj/user/sbrktest.debug:     file format elf32-i386


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
  80002c:	e8 8a 00 00 00       	call   8000bb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define ALLOCATE_SIZE 4096
#define STRING_SIZE	  64

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 18             	sub    $0x18,%esp
	int i;
	uint32_t start, end;
	char *s;

	start = sys_sbrk(0);
  80003c:	6a 00                	push   $0x0
  80003e:	e8 7f 0f 00 00       	call   800fc2 <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 6f 0f 00 00       	call   800fc2 <sys_sbrk>

	if (end - start < ALLOCATE_SIZE) {
  800053:	29 f0                	sub    %esi,%eax
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80005d:	76 4a                	jbe    8000a9 <umain+0x76>
		cprintf("sbrk not correctly implemented\n");
	}

	s = (char *) start;
	for ( i = 0; i < STRING_SIZE; i++) {
  80005f:	b9 00 00 00 00       	mov    $0x0,%ecx
		s[i] = 'A' + (i % 26);
  800064:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
  800069:	89 c8                	mov    %ecx,%eax
  80006b:	f7 ef                	imul   %edi
  80006d:	c1 fa 03             	sar    $0x3,%edx
  800070:	89 c8                	mov    %ecx,%eax
  800072:	c1 f8 1f             	sar    $0x1f,%eax
  800075:	29 c2                	sub    %eax,%edx
  800077:	6b d2 1a             	imul   $0x1a,%edx,%edx
  80007a:	89 c8                	mov    %ecx,%eax
  80007c:	29 d0                	sub    %edx,%eax
  80007e:	83 c0 41             	add    $0x41,%eax
  800081:	88 04 19             	mov    %al,(%ecx,%ebx,1)
	for ( i = 0; i < STRING_SIZE; i++) {
  800084:	83 c1 01             	add    $0x1,%ecx
  800087:	83 f9 40             	cmp    $0x40,%ecx
  80008a:	75 dd                	jne    800069 <umain+0x36>
	}
	s[STRING_SIZE] = '\0';
  80008c:	c6 46 40 00          	movb   $0x0,0x40(%esi)

	cprintf("SBRK_TEST(%s)\n", s);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	68 20 26 80 00       	push   $0x802620
  800099:	e8 c1 01 00 00       	call   80025f <cprintf>
}
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a4:	5b                   	pop    %ebx
  8000a5:	5e                   	pop    %esi
  8000a6:	5f                   	pop    %edi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    
		cprintf("sbrk not correctly implemented\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 00 26 80 00       	push   $0x802600
  8000b1:	e8 a9 01 00 00       	call   80025f <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	eb a4                	jmp    80005f <umain+0x2c>

008000bb <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	57                   	push   %edi
  8000bf:	56                   	push   %esi
  8000c0:	53                   	push   %ebx
  8000c1:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000c4:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000cb:	00 00 00 
	envid_t find = sys_getenvid();
  8000ce:	e8 9f 0c 00 00       	call   800d72 <sys_getenvid>
  8000d3:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000d9:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000de:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000e3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000e8:	eb 0b                	jmp    8000f5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000ea:	83 c2 01             	add    $0x1,%edx
  8000ed:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000f3:	74 23                	je     800118 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000f5:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000fb:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800101:	8b 49 48             	mov    0x48(%ecx),%ecx
  800104:	39 c1                	cmp    %eax,%ecx
  800106:	75 e2                	jne    8000ea <libmain+0x2f>
  800108:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80010e:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800114:	89 fe                	mov    %edi,%esi
  800116:	eb d2                	jmp    8000ea <libmain+0x2f>
  800118:	89 f0                	mov    %esi,%eax
  80011a:	84 c0                	test   %al,%al
  80011c:	74 06                	je     800124 <libmain+0x69>
  80011e:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800128:	7e 0a                	jle    800134 <libmain+0x79>
		binaryname = argv[0];
  80012a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012d:	8b 00                	mov    (%eax),%eax
  80012f:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800134:	a1 08 40 80 00       	mov    0x804008,%eax
  800139:	8b 40 48             	mov    0x48(%eax),%eax
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	50                   	push   %eax
  800140:	68 2f 26 80 00       	push   $0x80262f
  800145:	e8 15 01 00 00       	call   80025f <cprintf>
	cprintf("before umain\n");
  80014a:	c7 04 24 4d 26 80 00 	movl   $0x80264d,(%esp)
  800151:	e8 09 01 00 00       	call   80025f <cprintf>
	// call user main routine
	umain(argc, argv);
  800156:	83 c4 08             	add    $0x8,%esp
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	e8 cf fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800164:	c7 04 24 5b 26 80 00 	movl   $0x80265b,(%esp)
  80016b:	e8 ef 00 00 00       	call   80025f <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800170:	a1 08 40 80 00       	mov    0x804008,%eax
  800175:	8b 40 48             	mov    0x48(%eax),%eax
  800178:	83 c4 08             	add    $0x8,%esp
  80017b:	50                   	push   %eax
  80017c:	68 68 26 80 00       	push   $0x802668
  800181:	e8 d9 00 00 00       	call   80025f <cprintf>
	// exit gracefully
	exit();
  800186:	e8 0b 00 00 00       	call   800196 <exit>
}
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80019c:	a1 08 40 80 00       	mov    0x804008,%eax
  8001a1:	8b 40 48             	mov    0x48(%eax),%eax
  8001a4:	68 94 26 80 00       	push   $0x802694
  8001a9:	50                   	push   %eax
  8001aa:	68 87 26 80 00       	push   $0x802687
  8001af:	e8 ab 00 00 00       	call   80025f <cprintf>
	close_all();
  8001b4:	e8 c4 10 00 00       	call   80127d <close_all>
	sys_env_destroy(0);
  8001b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c0:	e8 6c 0b 00 00       	call   800d31 <sys_env_destroy>
}
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	53                   	push   %ebx
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d4:	8b 13                	mov    (%ebx),%edx
  8001d6:	8d 42 01             	lea    0x1(%edx),%eax
  8001d9:	89 03                	mov    %eax,(%ebx)
  8001db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001de:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e7:	74 09                	je     8001f2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	68 ff 00 00 00       	push   $0xff
  8001fa:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fd:	50                   	push   %eax
  8001fe:	e8 f1 0a 00 00       	call   800cf4 <sys_cputs>
		b->idx = 0;
  800203:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	eb db                	jmp    8001e9 <putch+0x1f>

0080020e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800217:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021e:	00 00 00 
	b.cnt = 0;
  800221:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800228:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022b:	ff 75 0c             	pushl  0xc(%ebp)
  80022e:	ff 75 08             	pushl  0x8(%ebp)
  800231:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800237:	50                   	push   %eax
  800238:	68 ca 01 80 00       	push   $0x8001ca
  80023d:	e8 4a 01 00 00       	call   80038c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800242:	83 c4 08             	add    $0x8,%esp
  800245:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80024b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	e8 9d 0a 00 00       	call   800cf4 <sys_cputs>

	return b.cnt;
}
  800257:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80025d:	c9                   	leave  
  80025e:	c3                   	ret    

0080025f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
  800262:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800265:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800268:	50                   	push   %eax
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	e8 9d ff ff ff       	call   80020e <vcprintf>
	va_end(ap);

	return cnt;
}
  800271:	c9                   	leave  
  800272:	c3                   	ret    

00800273 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	57                   	push   %edi
  800277:	56                   	push   %esi
  800278:	53                   	push   %ebx
  800279:	83 ec 1c             	sub    $0x1c,%esp
  80027c:	89 c6                	mov    %eax,%esi
  80027e:	89 d7                	mov    %edx,%edi
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	8b 55 0c             	mov    0xc(%ebp),%edx
  800286:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800289:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800292:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800296:	74 2c                	je     8002c4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800298:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002a8:	39 c2                	cmp    %eax,%edx
  8002aa:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ad:	73 43                	jae    8002f2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002af:	83 eb 01             	sub    $0x1,%ebx
  8002b2:	85 db                	test   %ebx,%ebx
  8002b4:	7e 6c                	jle    800322 <printnum+0xaf>
				putch(padc, putdat);
  8002b6:	83 ec 08             	sub    $0x8,%esp
  8002b9:	57                   	push   %edi
  8002ba:	ff 75 18             	pushl  0x18(%ebp)
  8002bd:	ff d6                	call   *%esi
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	eb eb                	jmp    8002af <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	6a 20                	push   $0x20
  8002c9:	6a 00                	push   $0x0
  8002cb:	50                   	push   %eax
  8002cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d2:	89 fa                	mov    %edi,%edx
  8002d4:	89 f0                	mov    %esi,%eax
  8002d6:	e8 98 ff ff ff       	call   800273 <printnum>
		while (--width > 0)
  8002db:	83 c4 20             	add    $0x20,%esp
  8002de:	83 eb 01             	sub    $0x1,%ebx
  8002e1:	85 db                	test   %ebx,%ebx
  8002e3:	7e 65                	jle    80034a <printnum+0xd7>
			putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	57                   	push   %edi
  8002e9:	6a 20                	push   $0x20
  8002eb:	ff d6                	call   *%esi
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	eb ec                	jmp    8002de <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f2:	83 ec 0c             	sub    $0xc,%esp
  8002f5:	ff 75 18             	pushl  0x18(%ebp)
  8002f8:	83 eb 01             	sub    $0x1,%ebx
  8002fb:	53                   	push   %ebx
  8002fc:	50                   	push   %eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	ff 75 dc             	pushl  -0x24(%ebp)
  800303:	ff 75 d8             	pushl  -0x28(%ebp)
  800306:	ff 75 e4             	pushl  -0x1c(%ebp)
  800309:	ff 75 e0             	pushl  -0x20(%ebp)
  80030c:	e8 8f 20 00 00       	call   8023a0 <__udivdi3>
  800311:	83 c4 18             	add    $0x18,%esp
  800314:	52                   	push   %edx
  800315:	50                   	push   %eax
  800316:	89 fa                	mov    %edi,%edx
  800318:	89 f0                	mov    %esi,%eax
  80031a:	e8 54 ff ff ff       	call   800273 <printnum>
  80031f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	57                   	push   %edi
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	ff 75 dc             	pushl  -0x24(%ebp)
  80032c:	ff 75 d8             	pushl  -0x28(%ebp)
  80032f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800332:	ff 75 e0             	pushl  -0x20(%ebp)
  800335:	e8 76 21 00 00       	call   8024b0 <__umoddi3>
  80033a:	83 c4 14             	add    $0x14,%esp
  80033d:	0f be 80 99 26 80 00 	movsbl 0x802699(%eax),%eax
  800344:	50                   	push   %eax
  800345:	ff d6                	call   *%esi
  800347:	83 c4 10             	add    $0x10,%esp
	}
}
  80034a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800358:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80035c:	8b 10                	mov    (%eax),%edx
  80035e:	3b 50 04             	cmp    0x4(%eax),%edx
  800361:	73 0a                	jae    80036d <sprintputch+0x1b>
		*b->buf++ = ch;
  800363:	8d 4a 01             	lea    0x1(%edx),%ecx
  800366:	89 08                	mov    %ecx,(%eax)
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	88 02                	mov    %al,(%edx)
}
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <printfmt>:
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800375:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800378:	50                   	push   %eax
  800379:	ff 75 10             	pushl  0x10(%ebp)
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	e8 05 00 00 00       	call   80038c <vprintfmt>
}
  800387:	83 c4 10             	add    $0x10,%esp
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <vprintfmt>:
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 3c             	sub    $0x3c,%esp
  800395:	8b 75 08             	mov    0x8(%ebp),%esi
  800398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039e:	e9 32 04 00 00       	jmp    8007d5 <vprintfmt+0x449>
		padc = ' ';
  8003a3:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003a7:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003ae:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003b5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003cf:	8d 47 01             	lea    0x1(%edi),%eax
  8003d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003d5:	0f b6 17             	movzbl (%edi),%edx
  8003d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003db:	3c 55                	cmp    $0x55,%al
  8003dd:	0f 87 12 05 00 00    	ja     8008f5 <vprintfmt+0x569>
  8003e3:	0f b6 c0             	movzbl %al,%eax
  8003e6:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003f4:	eb d9                	jmp    8003cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003fd:	eb d0                	jmp    8003cf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ff:	0f b6 d2             	movzbl %dl,%edx
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800405:	b8 00 00 00 00       	mov    $0x0,%eax
  80040a:	89 75 08             	mov    %esi,0x8(%ebp)
  80040d:	eb 03                	jmp    800412 <vprintfmt+0x86>
  80040f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800412:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800415:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800419:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80041c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80041f:	83 fe 09             	cmp    $0x9,%esi
  800422:	76 eb                	jbe    80040f <vprintfmt+0x83>
  800424:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800427:	8b 75 08             	mov    0x8(%ebp),%esi
  80042a:	eb 14                	jmp    800440 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8d 40 04             	lea    0x4(%eax),%eax
  80043a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80043d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	79 89                	jns    8003cf <vprintfmt+0x43>
				width = precision, precision = -1;
  800446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800449:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800453:	e9 77 ff ff ff       	jmp    8003cf <vprintfmt+0x43>
  800458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045b:	85 c0                	test   %eax,%eax
  80045d:	0f 48 c1             	cmovs  %ecx,%eax
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800466:	e9 64 ff ff ff       	jmp    8003cf <vprintfmt+0x43>
  80046b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80046e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800475:	e9 55 ff ff ff       	jmp    8003cf <vprintfmt+0x43>
			lflag++;
  80047a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800481:	e9 49 ff ff ff       	jmp    8003cf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800486:	8b 45 14             	mov    0x14(%ebp),%eax
  800489:	8d 78 04             	lea    0x4(%eax),%edi
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	ff 30                	pushl  (%eax)
  800492:	ff d6                	call   *%esi
			break;
  800494:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800497:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80049a:	e9 33 03 00 00       	jmp    8007d2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8d 78 04             	lea    0x4(%eax),%edi
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	99                   	cltd   
  8004a8:	31 d0                	xor    %edx,%eax
  8004aa:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ac:	83 f8 11             	cmp    $0x11,%eax
  8004af:	7f 23                	jg     8004d4 <vprintfmt+0x148>
  8004b1:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  8004b8:	85 d2                	test   %edx,%edx
  8004ba:	74 18                	je     8004d4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004bc:	52                   	push   %edx
  8004bd:	68 fd 2a 80 00       	push   $0x802afd
  8004c2:	53                   	push   %ebx
  8004c3:	56                   	push   %esi
  8004c4:	e8 a6 fe ff ff       	call   80036f <printfmt>
  8004c9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004cc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004cf:	e9 fe 02 00 00       	jmp    8007d2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004d4:	50                   	push   %eax
  8004d5:	68 b1 26 80 00       	push   $0x8026b1
  8004da:	53                   	push   %ebx
  8004db:	56                   	push   %esi
  8004dc:	e8 8e fe ff ff       	call   80036f <printfmt>
  8004e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004e7:	e9 e6 02 00 00       	jmp    8007d2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	83 c0 04             	add    $0x4,%eax
  8004f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004fa:	85 c9                	test   %ecx,%ecx
  8004fc:	b8 aa 26 80 00       	mov    $0x8026aa,%eax
  800501:	0f 45 c1             	cmovne %ecx,%eax
  800504:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800507:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80050b:	7e 06                	jle    800513 <vprintfmt+0x187>
  80050d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800511:	75 0d                	jne    800520 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800516:	89 c7                	mov    %eax,%edi
  800518:	03 45 e0             	add    -0x20(%ebp),%eax
  80051b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80051e:	eb 53                	jmp    800573 <vprintfmt+0x1e7>
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 d8             	pushl  -0x28(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 71 04 00 00       	call   80099d <strnlen>
  80052c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80052f:	29 c1                	sub    %eax,%ecx
  800531:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800539:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80053d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800540:	eb 0f                	jmp    800551 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 e0             	pushl  -0x20(%ebp)
  800549:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ed                	jg     800542 <vprintfmt+0x1b6>
  800555:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800558:	85 c9                	test   %ecx,%ecx
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	0f 49 c1             	cmovns %ecx,%eax
  800562:	29 c1                	sub    %eax,%ecx
  800564:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800567:	eb aa                	jmp    800513 <vprintfmt+0x187>
					putch(ch, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	52                   	push   %edx
  80056e:	ff d6                	call   *%esi
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800576:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800578:	83 c7 01             	add    $0x1,%edi
  80057b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80057f:	0f be d0             	movsbl %al,%edx
  800582:	85 d2                	test   %edx,%edx
  800584:	74 4b                	je     8005d1 <vprintfmt+0x245>
  800586:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058a:	78 06                	js     800592 <vprintfmt+0x206>
  80058c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800590:	78 1e                	js     8005b0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800592:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800596:	74 d1                	je     800569 <vprintfmt+0x1dd>
  800598:	0f be c0             	movsbl %al,%eax
  80059b:	83 e8 20             	sub    $0x20,%eax
  80059e:	83 f8 5e             	cmp    $0x5e,%eax
  8005a1:	76 c6                	jbe    800569 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	53                   	push   %ebx
  8005a7:	6a 3f                	push   $0x3f
  8005a9:	ff d6                	call   *%esi
  8005ab:	83 c4 10             	add    $0x10,%esp
  8005ae:	eb c3                	jmp    800573 <vprintfmt+0x1e7>
  8005b0:	89 cf                	mov    %ecx,%edi
  8005b2:	eb 0e                	jmp    8005c2 <vprintfmt+0x236>
				putch(' ', putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	53                   	push   %ebx
  8005b8:	6a 20                	push   $0x20
  8005ba:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005bc:	83 ef 01             	sub    $0x1,%edi
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	85 ff                	test   %edi,%edi
  8005c4:	7f ee                	jg     8005b4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cc:	e9 01 02 00 00       	jmp    8007d2 <vprintfmt+0x446>
  8005d1:	89 cf                	mov    %ecx,%edi
  8005d3:	eb ed                	jmp    8005c2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005df:	e9 eb fd ff ff       	jmp    8003cf <vprintfmt+0x43>
	if (lflag >= 2)
  8005e4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005e8:	7f 21                	jg     80060b <vprintfmt+0x27f>
	else if (lflag)
  8005ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005ee:	74 68                	je     800658 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f8:	89 c1                	mov    %eax,%ecx
  8005fa:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 04             	lea    0x4(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
  800609:	eb 17                	jmp    800622 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 50 04             	mov    0x4(%eax),%edx
  800611:	8b 00                	mov    (%eax),%eax
  800613:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800616:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 40 08             	lea    0x8(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800625:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800628:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80062e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800632:	78 3f                	js     800673 <vprintfmt+0x2e7>
			base = 10;
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800639:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80063d:	0f 84 71 01 00 00    	je     8007b4 <vprintfmt+0x428>
				putch('+', putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	53                   	push   %ebx
  800647:	6a 2b                	push   $0x2b
  800649:	ff d6                	call   *%esi
  80064b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800653:	e9 5c 01 00 00       	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8b 00                	mov    (%eax),%eax
  80065d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800660:	89 c1                	mov    %eax,%ecx
  800662:	c1 f9 1f             	sar    $0x1f,%ecx
  800665:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8d 40 04             	lea    0x4(%eax),%eax
  80066e:	89 45 14             	mov    %eax,0x14(%ebp)
  800671:	eb af                	jmp    800622 <vprintfmt+0x296>
				putch('-', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 2d                	push   $0x2d
  800679:	ff d6                	call   *%esi
				num = -(long long) num;
  80067b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800681:	f7 d8                	neg    %eax
  800683:	83 d2 00             	adc    $0x0,%edx
  800686:	f7 da                	neg    %edx
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
  800696:	e9 19 01 00 00       	jmp    8007b4 <vprintfmt+0x428>
	if (lflag >= 2)
  80069b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069f:	7f 29                	jg     8006ca <vprintfmt+0x33e>
	else if (lflag)
  8006a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a5:	74 44                	je     8006eb <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c5:	e9 ea 00 00 00       	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cd:	8b 50 04             	mov    0x4(%eax),%edx
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 08             	lea    0x8(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e6:	e9 c9 00 00 00       	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800704:	b8 0a 00 00 00       	mov    $0xa,%eax
  800709:	e9 a6 00 00 00       	jmp    8007b4 <vprintfmt+0x428>
			putch('0', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 30                	push   $0x30
  800714:	ff d6                	call   *%esi
	if (lflag >= 2)
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80071d:	7f 26                	jg     800745 <vprintfmt+0x3b9>
	else if (lflag)
  80071f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800723:	74 3e                	je     800763 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	ba 00 00 00 00       	mov    $0x0,%edx
  80072f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800732:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073e:	b8 08 00 00 00       	mov    $0x8,%eax
  800743:	eb 6f                	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 50 04             	mov    0x4(%eax),%edx
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800750:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8d 40 08             	lea    0x8(%eax),%eax
  800759:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075c:	b8 08 00 00 00       	mov    $0x8,%eax
  800761:	eb 51                	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	ba 00 00 00 00       	mov    $0x0,%edx
  80076d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800770:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8d 40 04             	lea    0x4(%eax),%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077c:	b8 08 00 00 00       	mov    $0x8,%eax
  800781:	eb 31                	jmp    8007b4 <vprintfmt+0x428>
			putch('0', putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	53                   	push   %ebx
  800787:	6a 30                	push   $0x30
  800789:	ff d6                	call   *%esi
			putch('x', putdat);
  80078b:	83 c4 08             	add    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 78                	push   $0x78
  800791:	ff d6                	call   *%esi
			num = (unsigned long long)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007a3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007bb:	52                   	push   %edx
  8007bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bf:	50                   	push   %eax
  8007c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8007c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8007c6:	89 da                	mov    %ebx,%edx
  8007c8:	89 f0                	mov    %esi,%eax
  8007ca:	e8 a4 fa ff ff       	call   800273 <printnum>
			break;
  8007cf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	83 c7 01             	add    $0x1,%edi
  8007d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007dc:	83 f8 25             	cmp    $0x25,%eax
  8007df:	0f 84 be fb ff ff    	je     8003a3 <vprintfmt+0x17>
			if (ch == '\0')
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	0f 84 28 01 00 00    	je     800915 <vprintfmt+0x589>
			putch(ch, putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	50                   	push   %eax
  8007f2:	ff d6                	call   *%esi
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	eb dc                	jmp    8007d5 <vprintfmt+0x449>
	if (lflag >= 2)
  8007f9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007fd:	7f 26                	jg     800825 <vprintfmt+0x499>
	else if (lflag)
  8007ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800803:	74 41                	je     800846 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800812:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 40 04             	lea    0x4(%eax),%eax
  80081b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081e:	b8 10 00 00 00       	mov    $0x10,%eax
  800823:	eb 8f                	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	8b 50 04             	mov    0x4(%eax),%edx
  80082b:	8b 00                	mov    (%eax),%eax
  80082d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800830:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800833:	8b 45 14             	mov    0x14(%ebp),%eax
  800836:	8d 40 08             	lea    0x8(%eax),%eax
  800839:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083c:	b8 10 00 00 00       	mov    $0x10,%eax
  800841:	e9 6e ff ff ff       	jmp    8007b4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 40 04             	lea    0x4(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085f:	b8 10 00 00 00       	mov    $0x10,%eax
  800864:	e9 4b ff ff ff       	jmp    8007b4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	8b 00                	mov    (%eax),%eax
  800877:	85 c0                	test   %eax,%eax
  800879:	74 14                	je     80088f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80087b:	8b 13                	mov    (%ebx),%edx
  80087d:	83 fa 7f             	cmp    $0x7f,%edx
  800880:	7f 37                	jg     8008b9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800882:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800884:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	e9 43 ff ff ff       	jmp    8007d2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80088f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800894:	bf cd 27 80 00       	mov    $0x8027cd,%edi
							putch(ch, putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	53                   	push   %ebx
  80089d:	50                   	push   %eax
  80089e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a0:	83 c7 01             	add    $0x1,%edi
  8008a3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	85 c0                	test   %eax,%eax
  8008ac:	75 eb                	jne    800899 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b4:	e9 19 ff ff ff       	jmp    8007d2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008b9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c0:	bf 05 28 80 00       	mov    $0x802805,%edi
							putch(ch, putdat);
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	53                   	push   %ebx
  8008c9:	50                   	push   %eax
  8008ca:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008cc:	83 c7 01             	add    $0x1,%edi
  8008cf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	75 eb                	jne    8008c5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	e9 ed fe ff ff       	jmp    8007d2 <vprintfmt+0x446>
			putch(ch, putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 25                	push   $0x25
  8008eb:	ff d6                	call   *%esi
			break;
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	e9 dd fe ff ff       	jmp    8007d2 <vprintfmt+0x446>
			putch('%', putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	53                   	push   %ebx
  8008f9:	6a 25                	push   $0x25
  8008fb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	89 f8                	mov    %edi,%eax
  800902:	eb 03                	jmp    800907 <vprintfmt+0x57b>
  800904:	83 e8 01             	sub    $0x1,%eax
  800907:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80090b:	75 f7                	jne    800904 <vprintfmt+0x578>
  80090d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800910:	e9 bd fe ff ff       	jmp    8007d2 <vprintfmt+0x446>
}
  800915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5f                   	pop    %edi
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	83 ec 18             	sub    $0x18,%esp
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800929:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800930:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093a:	85 c0                	test   %eax,%eax
  80093c:	74 26                	je     800964 <vsnprintf+0x47>
  80093e:	85 d2                	test   %edx,%edx
  800940:	7e 22                	jle    800964 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800942:	ff 75 14             	pushl  0x14(%ebp)
  800945:	ff 75 10             	pushl  0x10(%ebp)
  800948:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80094b:	50                   	push   %eax
  80094c:	68 52 03 80 00       	push   $0x800352
  800951:	e8 36 fa ff ff       	call   80038c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800959:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	83 c4 10             	add    $0x10,%esp
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    
		return -E_INVAL;
  800964:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800969:	eb f7                	jmp    800962 <vsnprintf+0x45>

0080096b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800971:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800974:	50                   	push   %eax
  800975:	ff 75 10             	pushl  0x10(%ebp)
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	ff 75 08             	pushl  0x8(%ebp)
  80097e:	e8 9a ff ff ff       	call   80091d <vsnprintf>
	va_end(ap);

	return rc;
}
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800994:	74 05                	je     80099b <strlen+0x16>
		n++;
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	eb f5                	jmp    800990 <strlen+0xb>
	return n;
}
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	39 c2                	cmp    %eax,%edx
  8009ad:	74 0d                	je     8009bc <strnlen+0x1f>
  8009af:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009b3:	74 05                	je     8009ba <strnlen+0x1d>
		n++;
  8009b5:	83 c2 01             	add    $0x1,%edx
  8009b8:	eb f1                	jmp    8009ab <strnlen+0xe>
  8009ba:	89 d0                	mov    %edx,%eax
	return n;
}
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	84 c9                	test   %cl,%cl
  8009d9:	75 f2                	jne    8009cd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009db:	5b                   	pop    %ebx
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	53                   	push   %ebx
  8009e2:	83 ec 10             	sub    $0x10,%esp
  8009e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009e8:	53                   	push   %ebx
  8009e9:	e8 97 ff ff ff       	call   800985 <strlen>
  8009ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	01 d8                	add    %ebx,%eax
  8009f6:	50                   	push   %eax
  8009f7:	e8 c2 ff ff ff       	call   8009be <strcpy>
	return dst;
}
  8009fc:	89 d8                	mov    %ebx,%eax
  8009fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	56                   	push   %esi
  800a07:	53                   	push   %ebx
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0e:	89 c6                	mov    %eax,%esi
  800a10:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a13:	89 c2                	mov    %eax,%edx
  800a15:	39 f2                	cmp    %esi,%edx
  800a17:	74 11                	je     800a2a <strncpy+0x27>
		*dst++ = *src;
  800a19:	83 c2 01             	add    $0x1,%edx
  800a1c:	0f b6 19             	movzbl (%ecx),%ebx
  800a1f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a22:	80 fb 01             	cmp    $0x1,%bl
  800a25:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a28:	eb eb                	jmp    800a15 <strncpy+0x12>
	}
	return ret;
}
  800a2a:	5b                   	pop    %ebx
  800a2b:	5e                   	pop    %esi
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	8b 75 08             	mov    0x8(%ebp),%esi
  800a36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a39:	8b 55 10             	mov    0x10(%ebp),%edx
  800a3c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a3e:	85 d2                	test   %edx,%edx
  800a40:	74 21                	je     800a63 <strlcpy+0x35>
  800a42:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a46:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a48:	39 c2                	cmp    %eax,%edx
  800a4a:	74 14                	je     800a60 <strlcpy+0x32>
  800a4c:	0f b6 19             	movzbl (%ecx),%ebx
  800a4f:	84 db                	test   %bl,%bl
  800a51:	74 0b                	je     800a5e <strlcpy+0x30>
			*dst++ = *src++;
  800a53:	83 c1 01             	add    $0x1,%ecx
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a5c:	eb ea                	jmp    800a48 <strlcpy+0x1a>
  800a5e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a60:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a63:	29 f0                	sub    %esi,%eax
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a72:	0f b6 01             	movzbl (%ecx),%eax
  800a75:	84 c0                	test   %al,%al
  800a77:	74 0c                	je     800a85 <strcmp+0x1c>
  800a79:	3a 02                	cmp    (%edx),%al
  800a7b:	75 08                	jne    800a85 <strcmp+0x1c>
		p++, q++;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	83 c2 01             	add    $0x1,%edx
  800a83:	eb ed                	jmp    800a72 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a85:	0f b6 c0             	movzbl %al,%eax
  800a88:	0f b6 12             	movzbl (%edx),%edx
  800a8b:	29 d0                	sub    %edx,%eax
}
  800a8d:	5d                   	pop    %ebp
  800a8e:	c3                   	ret    

00800a8f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a99:	89 c3                	mov    %eax,%ebx
  800a9b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a9e:	eb 06                	jmp    800aa6 <strncmp+0x17>
		n--, p++, q++;
  800aa0:	83 c0 01             	add    $0x1,%eax
  800aa3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aa6:	39 d8                	cmp    %ebx,%eax
  800aa8:	74 16                	je     800ac0 <strncmp+0x31>
  800aaa:	0f b6 08             	movzbl (%eax),%ecx
  800aad:	84 c9                	test   %cl,%cl
  800aaf:	74 04                	je     800ab5 <strncmp+0x26>
  800ab1:	3a 0a                	cmp    (%edx),%cl
  800ab3:	74 eb                	je     800aa0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab5:	0f b6 00             	movzbl (%eax),%eax
  800ab8:	0f b6 12             	movzbl (%edx),%edx
  800abb:	29 d0                	sub    %edx,%eax
}
  800abd:	5b                   	pop    %ebx
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    
		return 0;
  800ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac5:	eb f6                	jmp    800abd <strncmp+0x2e>

00800ac7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad1:	0f b6 10             	movzbl (%eax),%edx
  800ad4:	84 d2                	test   %dl,%dl
  800ad6:	74 09                	je     800ae1 <strchr+0x1a>
		if (*s == c)
  800ad8:	38 ca                	cmp    %cl,%dl
  800ada:	74 0a                	je     800ae6 <strchr+0x1f>
	for (; *s; s++)
  800adc:	83 c0 01             	add    $0x1,%eax
  800adf:	eb f0                	jmp    800ad1 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800af5:	38 ca                	cmp    %cl,%dl
  800af7:	74 09                	je     800b02 <strfind+0x1a>
  800af9:	84 d2                	test   %dl,%dl
  800afb:	74 05                	je     800b02 <strfind+0x1a>
	for (; *s; s++)
  800afd:	83 c0 01             	add    $0x1,%eax
  800b00:	eb f0                	jmp    800af2 <strfind+0xa>
			break;
	return (char *) s;
}
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b10:	85 c9                	test   %ecx,%ecx
  800b12:	74 31                	je     800b45 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b14:	89 f8                	mov    %edi,%eax
  800b16:	09 c8                	or     %ecx,%eax
  800b18:	a8 03                	test   $0x3,%al
  800b1a:	75 23                	jne    800b3f <memset+0x3b>
		c &= 0xFF;
  800b1c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b20:	89 d3                	mov    %edx,%ebx
  800b22:	c1 e3 08             	shl    $0x8,%ebx
  800b25:	89 d0                	mov    %edx,%eax
  800b27:	c1 e0 18             	shl    $0x18,%eax
  800b2a:	89 d6                	mov    %edx,%esi
  800b2c:	c1 e6 10             	shl    $0x10,%esi
  800b2f:	09 f0                	or     %esi,%eax
  800b31:	09 c2                	or     %eax,%edx
  800b33:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b35:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b38:	89 d0                	mov    %edx,%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b3d:	eb 06                	jmp    800b45 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	fc                   	cld    
  800b43:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b45:	89 f8                	mov    %edi,%eax
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5a:	39 c6                	cmp    %eax,%esi
  800b5c:	73 32                	jae    800b90 <memmove+0x44>
  800b5e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	76 2b                	jbe    800b90 <memmove+0x44>
		s += n;
		d += n;
  800b65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	89 fe                	mov    %edi,%esi
  800b6a:	09 ce                	or     %ecx,%esi
  800b6c:	09 d6                	or     %edx,%esi
  800b6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b74:	75 0e                	jne    800b84 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b76:	83 ef 04             	sub    $0x4,%edi
  800b79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7f:	fd                   	std    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b82:	eb 09                	jmp    800b8d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8a:	fd                   	std    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8d:	fc                   	cld    
  800b8e:	eb 1a                	jmp    800baa <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	09 ca                	or     %ecx,%edx
  800b94:	09 f2                	or     %esi,%edx
  800b96:	f6 c2 03             	test   $0x3,%dl
  800b99:	75 0a                	jne    800ba5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	fc                   	cld    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 05                	jmp    800baa <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb4:	ff 75 10             	pushl  0x10(%ebp)
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 8a ff ff ff       	call   800b4c <memmove>
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcf:	89 c6                	mov    %eax,%esi
  800bd1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd4:	39 f0                	cmp    %esi,%eax
  800bd6:	74 1c                	je     800bf4 <memcmp+0x30>
		if (*s1 != *s2)
  800bd8:	0f b6 08             	movzbl (%eax),%ecx
  800bdb:	0f b6 1a             	movzbl (%edx),%ebx
  800bde:	38 d9                	cmp    %bl,%cl
  800be0:	75 08                	jne    800bea <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800be2:	83 c0 01             	add    $0x1,%eax
  800be5:	83 c2 01             	add    $0x1,%edx
  800be8:	eb ea                	jmp    800bd4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bea:	0f b6 c1             	movzbl %cl,%eax
  800bed:	0f b6 db             	movzbl %bl,%ebx
  800bf0:	29 d8                	sub    %ebx,%eax
  800bf2:	eb 05                	jmp    800bf9 <memcmp+0x35>
	}

	return 0;
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf9:	5b                   	pop    %ebx
  800bfa:	5e                   	pop    %esi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c06:	89 c2                	mov    %eax,%edx
  800c08:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c0b:	39 d0                	cmp    %edx,%eax
  800c0d:	73 09                	jae    800c18 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c0f:	38 08                	cmp    %cl,(%eax)
  800c11:	74 05                	je     800c18 <memfind+0x1b>
	for (; s < ends; s++)
  800c13:	83 c0 01             	add    $0x1,%eax
  800c16:	eb f3                	jmp    800c0b <memfind+0xe>
			break;
	return (void *) s;
}
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	57                   	push   %edi
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
  800c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c26:	eb 03                	jmp    800c2b <strtol+0x11>
		s++;
  800c28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c2b:	0f b6 01             	movzbl (%ecx),%eax
  800c2e:	3c 20                	cmp    $0x20,%al
  800c30:	74 f6                	je     800c28 <strtol+0xe>
  800c32:	3c 09                	cmp    $0x9,%al
  800c34:	74 f2                	je     800c28 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c36:	3c 2b                	cmp    $0x2b,%al
  800c38:	74 2a                	je     800c64 <strtol+0x4a>
	int neg = 0;
  800c3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c3f:	3c 2d                	cmp    $0x2d,%al
  800c41:	74 2b                	je     800c6e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c49:	75 0f                	jne    800c5a <strtol+0x40>
  800c4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c4e:	74 28                	je     800c78 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c50:	85 db                	test   %ebx,%ebx
  800c52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c57:	0f 44 d8             	cmove  %eax,%ebx
  800c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c62:	eb 50                	jmp    800cb4 <strtol+0x9a>
		s++;
  800c64:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c67:	bf 00 00 00 00       	mov    $0x0,%edi
  800c6c:	eb d5                	jmp    800c43 <strtol+0x29>
		s++, neg = 1;
  800c6e:	83 c1 01             	add    $0x1,%ecx
  800c71:	bf 01 00 00 00       	mov    $0x1,%edi
  800c76:	eb cb                	jmp    800c43 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c78:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c7c:	74 0e                	je     800c8c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c7e:	85 db                	test   %ebx,%ebx
  800c80:	75 d8                	jne    800c5a <strtol+0x40>
		s++, base = 8;
  800c82:	83 c1 01             	add    $0x1,%ecx
  800c85:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c8a:	eb ce                	jmp    800c5a <strtol+0x40>
		s += 2, base = 16;
  800c8c:	83 c1 02             	add    $0x2,%ecx
  800c8f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c94:	eb c4                	jmp    800c5a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c99:	89 f3                	mov    %esi,%ebx
  800c9b:	80 fb 19             	cmp    $0x19,%bl
  800c9e:	77 29                	ja     800cc9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca0:	0f be d2             	movsbl %dl,%edx
  800ca3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ca6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ca9:	7d 30                	jge    800cdb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cab:	83 c1 01             	add    $0x1,%ecx
  800cae:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cb4:	0f b6 11             	movzbl (%ecx),%edx
  800cb7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cba:	89 f3                	mov    %esi,%ebx
  800cbc:	80 fb 09             	cmp    $0x9,%bl
  800cbf:	77 d5                	ja     800c96 <strtol+0x7c>
			dig = *s - '0';
  800cc1:	0f be d2             	movsbl %dl,%edx
  800cc4:	83 ea 30             	sub    $0x30,%edx
  800cc7:	eb dd                	jmp    800ca6 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cc9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ccc:	89 f3                	mov    %esi,%ebx
  800cce:	80 fb 19             	cmp    $0x19,%bl
  800cd1:	77 08                	ja     800cdb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cd3:	0f be d2             	movsbl %dl,%edx
  800cd6:	83 ea 37             	sub    $0x37,%edx
  800cd9:	eb cb                	jmp    800ca6 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 05                	je     800ce6 <strtol+0xcc>
		*endptr = (char *) s;
  800ce1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ce6:	89 c2                	mov    %eax,%edx
  800ce8:	f7 da                	neg    %edx
  800cea:	85 ff                	test   %edi,%edi
  800cec:	0f 45 c2             	cmovne %edx,%eax
}
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	89 c3                	mov    %eax,%ebx
  800d07:	89 c7                	mov    %eax,%edi
  800d09:	89 c6                	mov    %eax,%esi
  800d0b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d18:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d22:	89 d1                	mov    %edx,%ecx
  800d24:	89 d3                	mov    %edx,%ebx
  800d26:	89 d7                	mov    %edx,%edi
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
  800d37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	b8 03 00 00 00       	mov    $0x3,%eax
  800d47:	89 cb                	mov    %ecx,%ebx
  800d49:	89 cf                	mov    %ecx,%edi
  800d4b:	89 ce                	mov    %ecx,%esi
  800d4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7f 08                	jg     800d5b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d56:	5b                   	pop    %ebx
  800d57:	5e                   	pop    %esi
  800d58:	5f                   	pop    %edi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	50                   	push   %eax
  800d5f:	6a 03                	push   $0x3
  800d61:	68 28 2a 80 00       	push   $0x802a28
  800d66:	6a 43                	push   $0x43
  800d68:	68 45 2a 80 00       	push   $0x802a45
  800d6d:	e8 89 14 00 00       	call   8021fb <_panic>

00800d72 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d78:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d82:	89 d1                	mov    %edx,%ecx
  800d84:	89 d3                	mov    %edx,%ebx
  800d86:	89 d7                	mov    %edx,%edi
  800d88:	89 d6                	mov    %edx,%esi
  800d8a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    

00800d91 <sys_yield>:

void
sys_yield(void)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da1:	89 d1                	mov    %edx,%ecx
  800da3:	89 d3                	mov    %edx,%ebx
  800da5:	89 d7                	mov    %edx,%edi
  800da7:	89 d6                	mov    %edx,%esi
  800da9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db9:	be 00 00 00 00       	mov    $0x0,%esi
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	89 f7                	mov    %esi,%edi
  800dce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7f 08                	jg     800ddc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd7:	5b                   	pop    %ebx
  800dd8:	5e                   	pop    %esi
  800dd9:	5f                   	pop    %edi
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 04                	push   $0x4
  800de2:	68 28 2a 80 00       	push   $0x802a28
  800de7:	6a 43                	push   $0x43
  800de9:	68 45 2a 80 00       	push   $0x802a45
  800dee:	e8 08 14 00 00       	call   8021fb <_panic>

00800df3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	b8 05 00 00 00       	mov    $0x5,%eax
  800e07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e0d:	8b 75 18             	mov    0x18(%ebp),%esi
  800e10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7f 08                	jg     800e1e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	83 ec 0c             	sub    $0xc,%esp
  800e21:	50                   	push   %eax
  800e22:	6a 05                	push   $0x5
  800e24:	68 28 2a 80 00       	push   $0x802a28
  800e29:	6a 43                	push   $0x43
  800e2b:	68 45 2a 80 00       	push   $0x802a45
  800e30:	e8 c6 13 00 00       	call   8021fb <_panic>

00800e35 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e43:	8b 55 08             	mov    0x8(%ebp),%edx
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4e:	89 df                	mov    %ebx,%edi
  800e50:	89 de                	mov    %ebx,%esi
  800e52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7f 08                	jg     800e60 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	50                   	push   %eax
  800e64:	6a 06                	push   $0x6
  800e66:	68 28 2a 80 00       	push   $0x802a28
  800e6b:	6a 43                	push   $0x43
  800e6d:	68 45 2a 80 00       	push   $0x802a45
  800e72:	e8 84 13 00 00       	call   8021fb <_panic>

00800e77 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e90:	89 df                	mov    %ebx,%edi
  800e92:	89 de                	mov    %ebx,%esi
  800e94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	7f 08                	jg     800ea2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	50                   	push   %eax
  800ea6:	6a 08                	push   $0x8
  800ea8:	68 28 2a 80 00       	push   $0x802a28
  800ead:	6a 43                	push   $0x43
  800eaf:	68 45 2a 80 00       	push   $0x802a45
  800eb4:	e8 42 13 00 00       	call   8021fb <_panic>

00800eb9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed2:	89 df                	mov    %ebx,%edi
  800ed4:	89 de                	mov    %ebx,%esi
  800ed6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	7f 08                	jg     800ee4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5f                   	pop    %edi
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	50                   	push   %eax
  800ee8:	6a 09                	push   $0x9
  800eea:	68 28 2a 80 00       	push   $0x802a28
  800eef:	6a 43                	push   $0x43
  800ef1:	68 45 2a 80 00       	push   $0x802a45
  800ef6:	e8 00 13 00 00       	call   8021fb <_panic>

00800efb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f14:	89 df                	mov    %ebx,%edi
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	7f 08                	jg     800f26 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	50                   	push   %eax
  800f2a:	6a 0a                	push   $0xa
  800f2c:	68 28 2a 80 00       	push   $0x802a28
  800f31:	6a 43                	push   $0x43
  800f33:	68 45 2a 80 00       	push   $0x802a45
  800f38:	e8 be 12 00 00       	call   8021fb <_panic>

00800f3d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	57                   	push   %edi
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f4e:	be 00 00 00 00       	mov    $0x0,%esi
  800f53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f59:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f76:	89 cb                	mov    %ecx,%ebx
  800f78:	89 cf                	mov    %ecx,%edi
  800f7a:	89 ce                	mov    %ecx,%esi
  800f7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	7f 08                	jg     800f8a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8a:	83 ec 0c             	sub    $0xc,%esp
  800f8d:	50                   	push   %eax
  800f8e:	6a 0d                	push   $0xd
  800f90:	68 28 2a 80 00       	push   $0x802a28
  800f95:	6a 43                	push   $0x43
  800f97:	68 45 2a 80 00       	push   $0x802a45
  800f9c:	e8 5a 12 00 00       	call   8021fb <_panic>

00800fa1 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fbd:	5b                   	pop    %ebx
  800fbe:	5e                   	pop    %esi
  800fbf:	5f                   	pop    %edi
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fd5:	89 cb                	mov    %ecx,%ebx
  800fd7:	89 cf                	mov    %ecx,%edi
  800fd9:	89 ce                	mov    %ecx,%esi
  800fdb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fdd:	5b                   	pop    %ebx
  800fde:	5e                   	pop    %esi
  800fdf:	5f                   	pop    %edi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fed:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff2:	89 d1                	mov    %edx,%ecx
  800ff4:	89 d3                	mov    %edx,%ebx
  800ff6:	89 d7                	mov    %edx,%edi
  800ff8:	89 d6                	mov    %edx,%esi
  800ffa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
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
  801012:	b8 11 00 00 00       	mov    $0x11,%eax
  801017:	89 df                	mov    %ebx,%edi
  801019:	89 de                	mov    %ebx,%esi
  80101b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101d:	5b                   	pop    %ebx
  80101e:	5e                   	pop    %esi
  80101f:	5f                   	pop    %edi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	57                   	push   %edi
  801026:	56                   	push   %esi
  801027:	53                   	push   %ebx
	asm volatile("int %1\n"
  801028:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	b8 12 00 00 00       	mov    $0x12,%eax
  801038:	89 df                	mov    %ebx,%edi
  80103a:	89 de                	mov    %ebx,%esi
  80103c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80103e:	5b                   	pop    %ebx
  80103f:	5e                   	pop    %esi
  801040:	5f                   	pop    %edi
  801041:	5d                   	pop    %ebp
  801042:	c3                   	ret    

00801043 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801057:	b8 13 00 00 00       	mov    $0x13,%eax
  80105c:	89 df                	mov    %ebx,%edi
  80105e:	89 de                	mov    %ebx,%esi
  801060:	cd 30                	int    $0x30
	if(check && ret > 0)
  801062:	85 c0                	test   %eax,%eax
  801064:	7f 08                	jg     80106e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801066:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	6a 13                	push   $0x13
  801074:	68 28 2a 80 00       	push   $0x802a28
  801079:	6a 43                	push   $0x43
  80107b:	68 45 2a 80 00       	push   $0x802a45
  801080:	e8 76 11 00 00       	call   8021fb <_panic>

00801085 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	57                   	push   %edi
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801090:	8b 55 08             	mov    0x8(%ebp),%edx
  801093:	b8 14 00 00 00       	mov    $0x14,%eax
  801098:	89 cb                	mov    %ecx,%ebx
  80109a:	89 cf                	mov    %ecx,%edi
  80109c:	89 ce                	mov    %ecx,%esi
  80109e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	05 00 00 00 30       	add    $0x30000000,%eax
  8010b0:	c1 e8 0c             	shr    $0xc,%eax
}
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d4:	89 c2                	mov    %eax,%edx
  8010d6:	c1 ea 16             	shr    $0x16,%edx
  8010d9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e0:	f6 c2 01             	test   $0x1,%dl
  8010e3:	74 2d                	je     801112 <fd_alloc+0x46>
  8010e5:	89 c2                	mov    %eax,%edx
  8010e7:	c1 ea 0c             	shr    $0xc,%edx
  8010ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f1:	f6 c2 01             	test   $0x1,%dl
  8010f4:	74 1c                	je     801112 <fd_alloc+0x46>
  8010f6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010fb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801100:	75 d2                	jne    8010d4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80110b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801110:	eb 0a                	jmp    80111c <fd_alloc+0x50>
			*fd_store = fd;
  801112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801115:	89 01                	mov    %eax,(%ecx)
			return 0;
  801117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801124:	83 f8 1f             	cmp    $0x1f,%eax
  801127:	77 30                	ja     801159 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801129:	c1 e0 0c             	shl    $0xc,%eax
  80112c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801131:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801137:	f6 c2 01             	test   $0x1,%dl
  80113a:	74 24                	je     801160 <fd_lookup+0x42>
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	c1 ea 0c             	shr    $0xc,%edx
  801141:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801148:	f6 c2 01             	test   $0x1,%dl
  80114b:	74 1a                	je     801167 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80114d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801150:	89 02                	mov    %eax,(%edx)
	return 0;
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    
		return -E_INVAL;
  801159:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115e:	eb f7                	jmp    801157 <fd_lookup+0x39>
		return -E_INVAL;
  801160:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801165:	eb f0                	jmp    801157 <fd_lookup+0x39>
  801167:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116c:	eb e9                	jmp    801157 <fd_lookup+0x39>

0080116e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801177:	ba 00 00 00 00       	mov    $0x0,%edx
  80117c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801181:	39 08                	cmp    %ecx,(%eax)
  801183:	74 38                	je     8011bd <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801185:	83 c2 01             	add    $0x1,%edx
  801188:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 ee                	jne    801181 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801193:	a1 08 40 80 00       	mov    0x804008,%eax
  801198:	8b 40 48             	mov    0x48(%eax),%eax
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	51                   	push   %ecx
  80119f:	50                   	push   %eax
  8011a0:	68 54 2a 80 00       	push   $0x802a54
  8011a5:	e8 b5 f0 ff ff       	call   80025f <cprintf>
	*dev = 0;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    
			*dev = devtab[i];
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c7:	eb f2                	jmp    8011bb <dev_lookup+0x4d>

008011c9 <fd_close>:
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 24             	sub    $0x24,%esp
  8011d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e5:	50                   	push   %eax
  8011e6:	e8 33 ff ff ff       	call   80111e <fd_lookup>
  8011eb:	89 c3                	mov    %eax,%ebx
  8011ed:	83 c4 10             	add    $0x10,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 05                	js     8011f9 <fd_close+0x30>
	    || fd != fd2)
  8011f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011f7:	74 16                	je     80120f <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f9:	89 f8                	mov    %edi,%eax
  8011fb:	84 c0                	test   %al,%al
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801202:	0f 44 d8             	cmove  %eax,%ebx
}
  801205:	89 d8                	mov    %ebx,%eax
  801207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	ff 36                	pushl  (%esi)
  801218:	e8 51 ff ff ff       	call   80116e <dev_lookup>
  80121d:	89 c3                	mov    %eax,%ebx
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	78 1a                	js     801240 <fd_close+0x77>
		if (dev->dev_close)
  801226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801229:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801231:	85 c0                	test   %eax,%eax
  801233:	74 0b                	je     801240 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	56                   	push   %esi
  801239:	ff d0                	call   *%eax
  80123b:	89 c3                	mov    %eax,%ebx
  80123d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801240:	83 ec 08             	sub    $0x8,%esp
  801243:	56                   	push   %esi
  801244:	6a 00                	push   $0x0
  801246:	e8 ea fb ff ff       	call   800e35 <sys_page_unmap>
	return r;
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	eb b5                	jmp    801205 <fd_close+0x3c>

00801250 <close>:

int
close(int fdnum)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	ff 75 08             	pushl  0x8(%ebp)
  80125d:	e8 bc fe ff ff       	call   80111e <fd_lookup>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	85 c0                	test   %eax,%eax
  801267:	79 02                	jns    80126b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    
		return fd_close(fd, 1);
  80126b:	83 ec 08             	sub    $0x8,%esp
  80126e:	6a 01                	push   $0x1
  801270:	ff 75 f4             	pushl  -0xc(%ebp)
  801273:	e8 51 ff ff ff       	call   8011c9 <fd_close>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	eb ec                	jmp    801269 <close+0x19>

0080127d <close_all>:

void
close_all(void)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	53                   	push   %ebx
  801281:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801284:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	53                   	push   %ebx
  80128d:	e8 be ff ff ff       	call   801250 <close>
	for (i = 0; i < MAXFD; i++)
  801292:	83 c3 01             	add    $0x1,%ebx
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	83 fb 20             	cmp    $0x20,%ebx
  80129b:	75 ec                	jne    801289 <close_all+0xc>
}
  80129d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a0:	c9                   	leave  
  8012a1:	c3                   	ret    

008012a2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	57                   	push   %edi
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	ff 75 08             	pushl  0x8(%ebp)
  8012b2:	e8 67 fe ff ff       	call   80111e <fd_lookup>
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	0f 88 81 00 00 00    	js     801345 <dup+0xa3>
		return r;
	close(newfdnum);
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	e8 81 ff ff ff       	call   801250 <close>

	newfd = INDEX2FD(newfdnum);
  8012cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d2:	c1 e6 0c             	shl    $0xc,%esi
  8012d5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012db:	83 c4 04             	add    $0x4,%esp
  8012de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e1:	e8 cf fd ff ff       	call   8010b5 <fd2data>
  8012e6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e8:	89 34 24             	mov    %esi,(%esp)
  8012eb:	e8 c5 fd ff ff       	call   8010b5 <fd2data>
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	c1 e8 16             	shr    $0x16,%eax
  8012fa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801301:	a8 01                	test   $0x1,%al
  801303:	74 11                	je     801316 <dup+0x74>
  801305:	89 d8                	mov    %ebx,%eax
  801307:	c1 e8 0c             	shr    $0xc,%eax
  80130a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801311:	f6 c2 01             	test   $0x1,%dl
  801314:	75 39                	jne    80134f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801316:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	c1 e8 0c             	shr    $0xc,%eax
  80131e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801325:	83 ec 0c             	sub    $0xc,%esp
  801328:	25 07 0e 00 00       	and    $0xe07,%eax
  80132d:	50                   	push   %eax
  80132e:	56                   	push   %esi
  80132f:	6a 00                	push   $0x0
  801331:	52                   	push   %edx
  801332:	6a 00                	push   $0x0
  801334:	e8 ba fa ff ff       	call   800df3 <sys_page_map>
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 20             	add    $0x20,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 31                	js     801373 <dup+0xd1>
		goto err;

	return newfdnum;
  801342:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801345:	89 d8                	mov    %ebx,%eax
  801347:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134a:	5b                   	pop    %ebx
  80134b:	5e                   	pop    %esi
  80134c:	5f                   	pop    %edi
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	25 07 0e 00 00       	and    $0xe07,%eax
  80135e:	50                   	push   %eax
  80135f:	57                   	push   %edi
  801360:	6a 00                	push   $0x0
  801362:	53                   	push   %ebx
  801363:	6a 00                	push   $0x0
  801365:	e8 89 fa ff ff       	call   800df3 <sys_page_map>
  80136a:	89 c3                	mov    %eax,%ebx
  80136c:	83 c4 20             	add    $0x20,%esp
  80136f:	85 c0                	test   %eax,%eax
  801371:	79 a3                	jns    801316 <dup+0x74>
	sys_page_unmap(0, newfd);
  801373:	83 ec 08             	sub    $0x8,%esp
  801376:	56                   	push   %esi
  801377:	6a 00                	push   $0x0
  801379:	e8 b7 fa ff ff       	call   800e35 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	57                   	push   %edi
  801382:	6a 00                	push   $0x0
  801384:	e8 ac fa ff ff       	call   800e35 <sys_page_unmap>
	return r;
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	eb b7                	jmp    801345 <dup+0xa3>

0080138e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	53                   	push   %ebx
  801392:	83 ec 1c             	sub    $0x1c,%esp
  801395:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801398:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139b:	50                   	push   %eax
  80139c:	53                   	push   %ebx
  80139d:	e8 7c fd ff ff       	call   80111e <fd_lookup>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 3f                	js     8013e8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013af:	50                   	push   %eax
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	ff 30                	pushl  (%eax)
  8013b5:	e8 b4 fd ff ff       	call   80116e <dev_lookup>
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 27                	js     8013e8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c4:	8b 42 08             	mov    0x8(%edx),%eax
  8013c7:	83 e0 03             	and    $0x3,%eax
  8013ca:	83 f8 01             	cmp    $0x1,%eax
  8013cd:	74 1e                	je     8013ed <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d2:	8b 40 08             	mov    0x8(%eax),%eax
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 35                	je     80140e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	ff 75 10             	pushl  0x10(%ebp)
  8013df:	ff 75 0c             	pushl  0xc(%ebp)
  8013e2:	52                   	push   %edx
  8013e3:	ff d0                	call   *%eax
  8013e5:	83 c4 10             	add    $0x10,%esp
}
  8013e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f2:	8b 40 48             	mov    0x48(%eax),%eax
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	53                   	push   %ebx
  8013f9:	50                   	push   %eax
  8013fa:	68 95 2a 80 00       	push   $0x802a95
  8013ff:	e8 5b ee ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb da                	jmp    8013e8 <read+0x5a>
		return -E_NOT_SUPP;
  80140e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801413:	eb d3                	jmp    8013e8 <read+0x5a>

00801415 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801421:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801424:	bb 00 00 00 00       	mov    $0x0,%ebx
  801429:	39 f3                	cmp    %esi,%ebx
  80142b:	73 23                	jae    801450 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	89 f0                	mov    %esi,%eax
  801432:	29 d8                	sub    %ebx,%eax
  801434:	50                   	push   %eax
  801435:	89 d8                	mov    %ebx,%eax
  801437:	03 45 0c             	add    0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	57                   	push   %edi
  80143c:	e8 4d ff ff ff       	call   80138e <read>
		if (m < 0)
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 06                	js     80144e <readn+0x39>
			return m;
		if (m == 0)
  801448:	74 06                	je     801450 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80144a:	01 c3                	add    %eax,%ebx
  80144c:	eb db                	jmp    801429 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801450:	89 d8                	mov    %ebx,%eax
  801452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	53                   	push   %ebx
  80145e:	83 ec 1c             	sub    $0x1c,%esp
  801461:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801464:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	53                   	push   %ebx
  801469:	e8 b0 fc ff ff       	call   80111e <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 3a                	js     8014af <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	ff 30                	pushl  (%eax)
  801481:	e8 e8 fc ff ff       	call   80116e <dev_lookup>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 22                	js     8014af <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801494:	74 1e                	je     8014b4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801499:	8b 52 0c             	mov    0xc(%edx),%edx
  80149c:	85 d2                	test   %edx,%edx
  80149e:	74 35                	je     8014d5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	ff 75 10             	pushl  0x10(%ebp)
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff d2                	call   *%edx
  8014ac:	83 c4 10             	add    $0x10,%esp
}
  8014af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b9:	8b 40 48             	mov    0x48(%eax),%eax
  8014bc:	83 ec 04             	sub    $0x4,%esp
  8014bf:	53                   	push   %ebx
  8014c0:	50                   	push   %eax
  8014c1:	68 b1 2a 80 00       	push   $0x802ab1
  8014c6:	e8 94 ed ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d3:	eb da                	jmp    8014af <write+0x55>
		return -E_NOT_SUPP;
  8014d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014da:	eb d3                	jmp    8014af <write+0x55>

008014dc <seek>:

int
seek(int fdnum, off_t offset)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e5:	50                   	push   %eax
  8014e6:	ff 75 08             	pushl  0x8(%ebp)
  8014e9:	e8 30 fc ff ff       	call   80111e <fd_lookup>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 0e                	js     801503 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	53                   	push   %ebx
  801509:	83 ec 1c             	sub    $0x1c,%esp
  80150c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	53                   	push   %ebx
  801514:	e8 05 fc ff ff       	call   80111e <fd_lookup>
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 37                	js     801557 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	ff 30                	pushl  (%eax)
  80152c:	e8 3d fc ff ff       	call   80116e <dev_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 1f                	js     801557 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153f:	74 1b                	je     80155c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801544:	8b 52 18             	mov    0x18(%edx),%edx
  801547:	85 d2                	test   %edx,%edx
  801549:	74 32                	je     80157d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	ff 75 0c             	pushl  0xc(%ebp)
  801551:	50                   	push   %eax
  801552:	ff d2                	call   *%edx
  801554:	83 c4 10             	add    $0x10,%esp
}
  801557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80155c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801561:	8b 40 48             	mov    0x48(%eax),%eax
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	53                   	push   %ebx
  801568:	50                   	push   %eax
  801569:	68 74 2a 80 00       	push   $0x802a74
  80156e:	e8 ec ec ff ff       	call   80025f <cprintf>
		return -E_INVAL;
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157b:	eb da                	jmp    801557 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80157d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801582:	eb d3                	jmp    801557 <ftruncate+0x52>

00801584 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	53                   	push   %ebx
  801588:	83 ec 1c             	sub    $0x1c,%esp
  80158b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	e8 84 fb ff ff       	call   80111e <fd_lookup>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 4b                	js     8015ec <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a7:	50                   	push   %eax
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	ff 30                	pushl  (%eax)
  8015ad:	e8 bc fb ff ff       	call   80116e <dev_lookup>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 33                	js     8015ec <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c0:	74 2f                	je     8015f1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015cc:	00 00 00 
	stat->st_isdir = 0;
  8015cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d6:	00 00 00 
	stat->st_dev = dev;
  8015d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	53                   	push   %ebx
  8015e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e6:	ff 50 14             	call   *0x14(%eax)
  8015e9:	83 c4 10             	add    $0x10,%esp
}
  8015ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8015f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f6:	eb f4                	jmp    8015ec <fstat+0x68>

008015f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	56                   	push   %esi
  8015fc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	6a 00                	push   $0x0
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	e8 22 02 00 00       	call   80182c <open>
  80160a:	89 c3                	mov    %eax,%ebx
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 1b                	js     80162e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	50                   	push   %eax
  80161a:	e8 65 ff ff ff       	call   801584 <fstat>
  80161f:	89 c6                	mov    %eax,%esi
	close(fd);
  801621:	89 1c 24             	mov    %ebx,(%esp)
  801624:	e8 27 fc ff ff       	call   801250 <close>
	return r;
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	89 f3                	mov    %esi,%ebx
}
  80162e:	89 d8                	mov    %ebx,%eax
  801630:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801633:	5b                   	pop    %ebx
  801634:	5e                   	pop    %esi
  801635:	5d                   	pop    %ebp
  801636:	c3                   	ret    

00801637 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	56                   	push   %esi
  80163b:	53                   	push   %ebx
  80163c:	89 c6                	mov    %eax,%esi
  80163e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801640:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801647:	74 27                	je     801670 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801649:	6a 07                	push   $0x7
  80164b:	68 00 50 80 00       	push   $0x805000
  801650:	56                   	push   %esi
  801651:	ff 35 00 40 80 00    	pushl  0x804000
  801657:	e8 69 0c 00 00       	call   8022c5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165c:	83 c4 0c             	add    $0xc,%esp
  80165f:	6a 00                	push   $0x0
  801661:	53                   	push   %ebx
  801662:	6a 00                	push   $0x0
  801664:	e8 f3 0b 00 00       	call   80225c <ipc_recv>
}
  801669:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166c:	5b                   	pop    %ebx
  80166d:	5e                   	pop    %esi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	6a 01                	push   $0x1
  801675:	e8 a3 0c 00 00       	call   80231d <ipc_find_env>
  80167a:	a3 00 40 80 00       	mov    %eax,0x804000
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	eb c5                	jmp    801649 <fsipc+0x12>

00801684 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	8b 40 0c             	mov    0xc(%eax),%eax
  801690:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801695:	8b 45 0c             	mov    0xc(%ebp),%eax
  801698:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80169d:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a7:	e8 8b ff ff ff       	call   801637 <fsipc>
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <devfile_flush>:
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ba:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c4:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c9:	e8 69 ff ff ff       	call   801637 <fsipc>
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <devfile_stat>:
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ef:	e8 43 ff ff ff       	call   801637 <fsipc>
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 2c                	js     801724 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	68 00 50 80 00       	push   $0x805000
  801700:	53                   	push   %ebx
  801701:	e8 b8 f2 ff ff       	call   8009be <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801706:	a1 80 50 80 00       	mov    0x805080,%eax
  80170b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801711:	a1 84 50 80 00       	mov    0x805084,%eax
  801716:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <devfile_write>:
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	53                   	push   %ebx
  80172d:	83 ec 08             	sub    $0x8,%esp
  801730:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8b 40 0c             	mov    0xc(%eax),%eax
  801739:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80173e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801744:	53                   	push   %ebx
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	68 08 50 80 00       	push   $0x805008
  80174d:	e8 5c f4 ff ff       	call   800bae <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	b8 04 00 00 00       	mov    $0x4,%eax
  80175c:	e8 d6 fe ff ff       	call   801637 <fsipc>
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	78 0b                	js     801773 <devfile_write+0x4a>
	assert(r <= n);
  801768:	39 d8                	cmp    %ebx,%eax
  80176a:	77 0c                	ja     801778 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80176c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801771:	7f 1e                	jg     801791 <devfile_write+0x68>
}
  801773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801776:	c9                   	leave  
  801777:	c3                   	ret    
	assert(r <= n);
  801778:	68 e4 2a 80 00       	push   $0x802ae4
  80177d:	68 eb 2a 80 00       	push   $0x802aeb
  801782:	68 98 00 00 00       	push   $0x98
  801787:	68 00 2b 80 00       	push   $0x802b00
  80178c:	e8 6a 0a 00 00       	call   8021fb <_panic>
	assert(r <= PGSIZE);
  801791:	68 0b 2b 80 00       	push   $0x802b0b
  801796:	68 eb 2a 80 00       	push   $0x802aeb
  80179b:	68 99 00 00 00       	push   $0x99
  8017a0:	68 00 2b 80 00       	push   $0x802b00
  8017a5:	e8 51 0a 00 00       	call   8021fb <_panic>

008017aa <devfile_read>:
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	56                   	push   %esi
  8017ae:	53                   	push   %ebx
  8017af:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017bd:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c8:	b8 03 00 00 00       	mov    $0x3,%eax
  8017cd:	e8 65 fe ff ff       	call   801637 <fsipc>
  8017d2:	89 c3                	mov    %eax,%ebx
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 1f                	js     8017f7 <devfile_read+0x4d>
	assert(r <= n);
  8017d8:	39 f0                	cmp    %esi,%eax
  8017da:	77 24                	ja     801800 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017dc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e1:	7f 33                	jg     801816 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	50                   	push   %eax
  8017e7:	68 00 50 80 00       	push   $0x805000
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	e8 58 f3 ff ff       	call   800b4c <memmove>
	return r;
  8017f4:	83 c4 10             	add    $0x10,%esp
}
  8017f7:	89 d8                	mov    %ebx,%eax
  8017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    
	assert(r <= n);
  801800:	68 e4 2a 80 00       	push   $0x802ae4
  801805:	68 eb 2a 80 00       	push   $0x802aeb
  80180a:	6a 7c                	push   $0x7c
  80180c:	68 00 2b 80 00       	push   $0x802b00
  801811:	e8 e5 09 00 00       	call   8021fb <_panic>
	assert(r <= PGSIZE);
  801816:	68 0b 2b 80 00       	push   $0x802b0b
  80181b:	68 eb 2a 80 00       	push   $0x802aeb
  801820:	6a 7d                	push   $0x7d
  801822:	68 00 2b 80 00       	push   $0x802b00
  801827:	e8 cf 09 00 00       	call   8021fb <_panic>

0080182c <open>:
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	83 ec 1c             	sub    $0x1c,%esp
  801834:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801837:	56                   	push   %esi
  801838:	e8 48 f1 ff ff       	call   800985 <strlen>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801845:	7f 6c                	jg     8018b3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801847:	83 ec 0c             	sub    $0xc,%esp
  80184a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184d:	50                   	push   %eax
  80184e:	e8 79 f8 ff ff       	call   8010cc <fd_alloc>
  801853:	89 c3                	mov    %eax,%ebx
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 3c                	js     801898 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80185c:	83 ec 08             	sub    $0x8,%esp
  80185f:	56                   	push   %esi
  801860:	68 00 50 80 00       	push   $0x805000
  801865:	e8 54 f1 ff ff       	call   8009be <strcpy>
	fsipcbuf.open.req_omode = mode;
  80186a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801875:	b8 01 00 00 00       	mov    $0x1,%eax
  80187a:	e8 b8 fd ff ff       	call   801637 <fsipc>
  80187f:	89 c3                	mov    %eax,%ebx
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	78 19                	js     8018a1 <open+0x75>
	return fd2num(fd);
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	ff 75 f4             	pushl  -0xc(%ebp)
  80188e:	e8 12 f8 ff ff       	call   8010a5 <fd2num>
  801893:	89 c3                	mov    %eax,%ebx
  801895:	83 c4 10             	add    $0x10,%esp
}
  801898:	89 d8                	mov    %ebx,%eax
  80189a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189d:	5b                   	pop    %ebx
  80189e:	5e                   	pop    %esi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    
		fd_close(fd, 0);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a9:	e8 1b f9 ff ff       	call   8011c9 <fd_close>
		return r;
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	eb e5                	jmp    801898 <open+0x6c>
		return -E_BAD_PATH;
  8018b3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018b8:	eb de                	jmp    801898 <open+0x6c>

008018ba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8018ca:	e8 68 fd ff ff       	call   801637 <fsipc>
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018d7:	68 17 2b 80 00       	push   $0x802b17
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	e8 da f0 ff ff       	call   8009be <strcpy>
	return 0;
}
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <devsock_close>:
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	53                   	push   %ebx
  8018ef:	83 ec 10             	sub    $0x10,%esp
  8018f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018f5:	53                   	push   %ebx
  8018f6:	e8 61 0a 00 00       	call   80235c <pageref>
  8018fb:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018fe:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801903:	83 f8 01             	cmp    $0x1,%eax
  801906:	74 07                	je     80190f <devsock_close+0x24>
}
  801908:	89 d0                	mov    %edx,%eax
  80190a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	ff 73 0c             	pushl  0xc(%ebx)
  801915:	e8 b9 02 00 00       	call   801bd3 <nsipc_close>
  80191a:	89 c2                	mov    %eax,%edx
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb e7                	jmp    801908 <devsock_close+0x1d>

00801921 <devsock_write>:
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801927:	6a 00                	push   $0x0
  801929:	ff 75 10             	pushl  0x10(%ebp)
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	ff 70 0c             	pushl  0xc(%eax)
  801935:	e8 76 03 00 00       	call   801cb0 <nsipc_send>
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <devsock_read>:
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801942:	6a 00                	push   $0x0
  801944:	ff 75 10             	pushl  0x10(%ebp)
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	ff 70 0c             	pushl  0xc(%eax)
  801950:	e8 ef 02 00 00       	call   801c44 <nsipc_recv>
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <fd2sockid>:
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80195d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801960:	52                   	push   %edx
  801961:	50                   	push   %eax
  801962:	e8 b7 f7 ff ff       	call   80111e <fd_lookup>
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 10                	js     80197e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801977:	39 08                	cmp    %ecx,(%eax)
  801979:	75 05                	jne    801980 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80197b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    
		return -E_NOT_SUPP;
  801980:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801985:	eb f7                	jmp    80197e <fd2sockid+0x27>

00801987 <alloc_sockfd>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	83 ec 1c             	sub    $0x1c,%esp
  80198f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801991:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801994:	50                   	push   %eax
  801995:	e8 32 f7 ff ff       	call   8010cc <fd_alloc>
  80199a:	89 c3                	mov    %eax,%ebx
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 43                	js     8019e6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	68 07 04 00 00       	push   $0x407
  8019ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ae:	6a 00                	push   $0x0
  8019b0:	e8 fb f3 ff ff       	call   800db0 <sys_page_alloc>
  8019b5:	89 c3                	mov    %eax,%ebx
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 28                	js     8019e6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019c7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019d3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	50                   	push   %eax
  8019da:	e8 c6 f6 ff ff       	call   8010a5 <fd2num>
  8019df:	89 c3                	mov    %eax,%ebx
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	eb 0c                	jmp    8019f2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	56                   	push   %esi
  8019ea:	e8 e4 01 00 00       	call   801bd3 <nsipc_close>
		return r;
  8019ef:	83 c4 10             	add    $0x10,%esp
}
  8019f2:	89 d8                	mov    %ebx,%eax
  8019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5d                   	pop    %ebp
  8019fa:	c3                   	ret    

008019fb <accept>:
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	e8 4e ff ff ff       	call   801957 <fd2sockid>
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 1b                	js     801a28 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a0d:	83 ec 04             	sub    $0x4,%esp
  801a10:	ff 75 10             	pushl  0x10(%ebp)
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	50                   	push   %eax
  801a17:	e8 0e 01 00 00       	call   801b2a <nsipc_accept>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 05                	js     801a28 <accept+0x2d>
	return alloc_sockfd(r);
  801a23:	e8 5f ff ff ff       	call   801987 <alloc_sockfd>
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <bind>:
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	e8 1f ff ff ff       	call   801957 <fd2sockid>
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 12                	js     801a4e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	ff 75 10             	pushl  0x10(%ebp)
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	50                   	push   %eax
  801a46:	e8 31 01 00 00       	call   801b7c <nsipc_bind>
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <shutdown>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	e8 f9 fe ff ff       	call   801957 <fd2sockid>
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 0f                	js     801a71 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	50                   	push   %eax
  801a69:	e8 43 01 00 00       	call   801bb1 <nsipc_shutdown>
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <connect>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	e8 d6 fe ff ff       	call   801957 <fd2sockid>
  801a81:	85 c0                	test   %eax,%eax
  801a83:	78 12                	js     801a97 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	ff 75 10             	pushl  0x10(%ebp)
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	e8 59 01 00 00       	call   801bed <nsipc_connect>
  801a94:	83 c4 10             	add    $0x10,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <listen>:
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	e8 b0 fe ff ff       	call   801957 <fd2sockid>
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 0f                	js     801aba <listen+0x21>
	return nsipc_listen(r, backlog);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	e8 6b 01 00 00       	call   801c22 <nsipc_listen>
  801ab7:	83 c4 10             	add    $0x10,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <socket>:

int
socket(int domain, int type, int protocol)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ac2:	ff 75 10             	pushl  0x10(%ebp)
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	ff 75 08             	pushl  0x8(%ebp)
  801acb:	e8 3e 02 00 00       	call   801d0e <nsipc_socket>
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 05                	js     801adc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ad7:	e8 ab fe ff ff       	call   801987 <alloc_sockfd>
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ae7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aee:	74 26                	je     801b16 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801af0:	6a 07                	push   $0x7
  801af2:	68 00 60 80 00       	push   $0x806000
  801af7:	53                   	push   %ebx
  801af8:	ff 35 04 40 80 00    	pushl  0x804004
  801afe:	e8 c2 07 00 00       	call   8022c5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b03:	83 c4 0c             	add    $0xc,%esp
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	e8 4b 07 00 00       	call   80225c <ipc_recv>
}
  801b11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	6a 02                	push   $0x2
  801b1b:	e8 fd 07 00 00       	call   80231d <ipc_find_env>
  801b20:	a3 04 40 80 00       	mov    %eax,0x804004
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	eb c6                	jmp    801af0 <nsipc+0x12>

00801b2a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	56                   	push   %esi
  801b2e:	53                   	push   %ebx
  801b2f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b3a:	8b 06                	mov    (%esi),%eax
  801b3c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b41:	b8 01 00 00 00       	mov    $0x1,%eax
  801b46:	e8 93 ff ff ff       	call   801ade <nsipc>
  801b4b:	89 c3                	mov    %eax,%ebx
  801b4d:	85 c0                	test   %eax,%eax
  801b4f:	79 09                	jns    801b5a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b51:	89 d8                	mov    %ebx,%eax
  801b53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	ff 35 10 60 80 00    	pushl  0x806010
  801b63:	68 00 60 80 00       	push   $0x806000
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	e8 dc ef ff ff       	call   800b4c <memmove>
		*addrlen = ret->ret_addrlen;
  801b70:	a1 10 60 80 00       	mov    0x806010,%eax
  801b75:	89 06                	mov    %eax,(%esi)
  801b77:	83 c4 10             	add    $0x10,%esp
	return r;
  801b7a:	eb d5                	jmp    801b51 <nsipc_accept+0x27>

00801b7c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 08             	sub    $0x8,%esp
  801b83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b8e:	53                   	push   %ebx
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	68 04 60 80 00       	push   $0x806004
  801b97:	e8 b0 ef ff ff       	call   800b4c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b9c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ba2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba7:	e8 32 ff ff ff       	call   801ade <nsipc>
}
  801bac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bc7:	b8 03 00 00 00       	mov    $0x3,%eax
  801bcc:	e8 0d ff ff ff       	call   801ade <nsipc>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <nsipc_close>:

int
nsipc_close(int s)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801be1:	b8 04 00 00 00       	mov    $0x4,%eax
  801be6:	e8 f3 fe ff ff       	call   801ade <nsipc>
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 08             	sub    $0x8,%esp
  801bf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bff:	53                   	push   %ebx
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	68 04 60 80 00       	push   $0x806004
  801c08:	e8 3f ef ff ff       	call   800b4c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c0d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c13:	b8 05 00 00 00       	mov    $0x5,%eax
  801c18:	e8 c1 fe ff ff       	call   801ade <nsipc>
}
  801c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c33:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c38:	b8 06 00 00 00       	mov    $0x6,%eax
  801c3d:	e8 9c fe ff ff       	call   801ade <nsipc>
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	56                   	push   %esi
  801c48:	53                   	push   %ebx
  801c49:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c54:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c62:	b8 07 00 00 00       	mov    $0x7,%eax
  801c67:	e8 72 fe ff ff       	call   801ade <nsipc>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 1f                	js     801c91 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c72:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c77:	7f 21                	jg     801c9a <nsipc_recv+0x56>
  801c79:	39 c6                	cmp    %eax,%esi
  801c7b:	7c 1d                	jl     801c9a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	50                   	push   %eax
  801c81:	68 00 60 80 00       	push   $0x806000
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	e8 be ee ff ff       	call   800b4c <memmove>
  801c8e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c91:	89 d8                	mov    %ebx,%eax
  801c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c9a:	68 23 2b 80 00       	push   $0x802b23
  801c9f:	68 eb 2a 80 00       	push   $0x802aeb
  801ca4:	6a 62                	push   $0x62
  801ca6:	68 38 2b 80 00       	push   $0x802b38
  801cab:	e8 4b 05 00 00       	call   8021fb <_panic>

00801cb0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cc2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cc8:	7f 2e                	jg     801cf8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	53                   	push   %ebx
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	68 0c 60 80 00       	push   $0x80600c
  801cd6:	e8 71 ee ff ff       	call   800b4c <memmove>
	nsipcbuf.send.req_size = size;
  801cdb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ce1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ce9:	b8 08 00 00 00       	mov    $0x8,%eax
  801cee:	e8 eb fd ff ff       	call   801ade <nsipc>
}
  801cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    
	assert(size < 1600);
  801cf8:	68 44 2b 80 00       	push   $0x802b44
  801cfd:	68 eb 2a 80 00       	push   $0x802aeb
  801d02:	6a 6d                	push   $0x6d
  801d04:	68 38 2b 80 00       	push   $0x802b38
  801d09:	e8 ed 04 00 00       	call   8021fb <_panic>

00801d0e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d24:	8b 45 10             	mov    0x10(%ebp),%eax
  801d27:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d2c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d31:	e8 a8 fd ff ff       	call   801ade <nsipc>
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	ff 75 08             	pushl  0x8(%ebp)
  801d46:	e8 6a f3 ff ff       	call   8010b5 <fd2data>
  801d4b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d4d:	83 c4 08             	add    $0x8,%esp
  801d50:	68 50 2b 80 00       	push   $0x802b50
  801d55:	53                   	push   %ebx
  801d56:	e8 63 ec ff ff       	call   8009be <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d5b:	8b 46 04             	mov    0x4(%esi),%eax
  801d5e:	2b 06                	sub    (%esi),%eax
  801d60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d6d:	00 00 00 
	stat->st_dev = &devpipe;
  801d70:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d77:	30 80 00 
	return 0;
}
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	53                   	push   %ebx
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d90:	53                   	push   %ebx
  801d91:	6a 00                	push   $0x0
  801d93:	e8 9d f0 ff ff       	call   800e35 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d98:	89 1c 24             	mov    %ebx,(%esp)
  801d9b:	e8 15 f3 ff ff       	call   8010b5 <fd2data>
  801da0:	83 c4 08             	add    $0x8,%esp
  801da3:	50                   	push   %eax
  801da4:	6a 00                	push   $0x0
  801da6:	e8 8a f0 ff ff       	call   800e35 <sys_page_unmap>
}
  801dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <_pipeisclosed>:
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	57                   	push   %edi
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	83 ec 1c             	sub    $0x1c,%esp
  801db9:	89 c7                	mov    %eax,%edi
  801dbb:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dbd:	a1 08 40 80 00       	mov    0x804008,%eax
  801dc2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	57                   	push   %edi
  801dc9:	e8 8e 05 00 00       	call   80235c <pageref>
  801dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd1:	89 34 24             	mov    %esi,(%esp)
  801dd4:	e8 83 05 00 00       	call   80235c <pageref>
		nn = thisenv->env_runs;
  801dd9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ddf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	39 cb                	cmp    %ecx,%ebx
  801de7:	74 1b                	je     801e04 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801de9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dec:	75 cf                	jne    801dbd <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dee:	8b 42 58             	mov    0x58(%edx),%eax
  801df1:	6a 01                	push   $0x1
  801df3:	50                   	push   %eax
  801df4:	53                   	push   %ebx
  801df5:	68 57 2b 80 00       	push   $0x802b57
  801dfa:	e8 60 e4 ff ff       	call   80025f <cprintf>
  801dff:	83 c4 10             	add    $0x10,%esp
  801e02:	eb b9                	jmp    801dbd <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e04:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e07:	0f 94 c0             	sete   %al
  801e0a:	0f b6 c0             	movzbl %al,%eax
}
  801e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e10:	5b                   	pop    %ebx
  801e11:	5e                   	pop    %esi
  801e12:	5f                   	pop    %edi
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    

00801e15 <devpipe_write>:
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	57                   	push   %edi
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 28             	sub    $0x28,%esp
  801e1e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e21:	56                   	push   %esi
  801e22:	e8 8e f2 ff ff       	call   8010b5 <fd2data>
  801e27:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e31:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e34:	74 4f                	je     801e85 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e36:	8b 43 04             	mov    0x4(%ebx),%eax
  801e39:	8b 0b                	mov    (%ebx),%ecx
  801e3b:	8d 51 20             	lea    0x20(%ecx),%edx
  801e3e:	39 d0                	cmp    %edx,%eax
  801e40:	72 14                	jb     801e56 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e42:	89 da                	mov    %ebx,%edx
  801e44:	89 f0                	mov    %esi,%eax
  801e46:	e8 65 ff ff ff       	call   801db0 <_pipeisclosed>
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	75 3b                	jne    801e8a <devpipe_write+0x75>
			sys_yield();
  801e4f:	e8 3d ef ff ff       	call   800d91 <sys_yield>
  801e54:	eb e0                	jmp    801e36 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e59:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e5d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e60:	89 c2                	mov    %eax,%edx
  801e62:	c1 fa 1f             	sar    $0x1f,%edx
  801e65:	89 d1                	mov    %edx,%ecx
  801e67:	c1 e9 1b             	shr    $0x1b,%ecx
  801e6a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e6d:	83 e2 1f             	and    $0x1f,%edx
  801e70:	29 ca                	sub    %ecx,%edx
  801e72:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e76:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e7a:	83 c0 01             	add    $0x1,%eax
  801e7d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e80:	83 c7 01             	add    $0x1,%edi
  801e83:	eb ac                	jmp    801e31 <devpipe_write+0x1c>
	return i;
  801e85:	8b 45 10             	mov    0x10(%ebp),%eax
  801e88:	eb 05                	jmp    801e8f <devpipe_write+0x7a>
				return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e92:	5b                   	pop    %ebx
  801e93:	5e                   	pop    %esi
  801e94:	5f                   	pop    %edi
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <devpipe_read>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	57                   	push   %edi
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
  801e9d:	83 ec 18             	sub    $0x18,%esp
  801ea0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ea3:	57                   	push   %edi
  801ea4:	e8 0c f2 ff ff       	call   8010b5 <fd2data>
  801ea9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	be 00 00 00 00       	mov    $0x0,%esi
  801eb3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb6:	75 14                	jne    801ecc <devpipe_read+0x35>
	return i;
  801eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebb:	eb 02                	jmp    801ebf <devpipe_read+0x28>
				return i;
  801ebd:	89 f0                	mov    %esi,%eax
}
  801ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5f                   	pop    %edi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    
			sys_yield();
  801ec7:	e8 c5 ee ff ff       	call   800d91 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ecc:	8b 03                	mov    (%ebx),%eax
  801ece:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ed1:	75 18                	jne    801eeb <devpipe_read+0x54>
			if (i > 0)
  801ed3:	85 f6                	test   %esi,%esi
  801ed5:	75 e6                	jne    801ebd <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ed7:	89 da                	mov    %ebx,%edx
  801ed9:	89 f8                	mov    %edi,%eax
  801edb:	e8 d0 fe ff ff       	call   801db0 <_pipeisclosed>
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 e3                	je     801ec7 <devpipe_read+0x30>
				return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee9:	eb d4                	jmp    801ebf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eeb:	99                   	cltd   
  801eec:	c1 ea 1b             	shr    $0x1b,%edx
  801eef:	01 d0                	add    %edx,%eax
  801ef1:	83 e0 1f             	and    $0x1f,%eax
  801ef4:	29 d0                	sub    %edx,%eax
  801ef6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801efe:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f01:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f04:	83 c6 01             	add    $0x1,%esi
  801f07:	eb aa                	jmp    801eb3 <devpipe_read+0x1c>

00801f09 <pipe>:
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f14:	50                   	push   %eax
  801f15:	e8 b2 f1 ff ff       	call   8010cc <fd_alloc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	0f 88 23 01 00 00    	js     80204a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	68 07 04 00 00       	push   $0x407
  801f2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f32:	6a 00                	push   $0x0
  801f34:	e8 77 ee ff ff       	call   800db0 <sys_page_alloc>
  801f39:	89 c3                	mov    %eax,%ebx
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	0f 88 04 01 00 00    	js     80204a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f4c:	50                   	push   %eax
  801f4d:	e8 7a f1 ff ff       	call   8010cc <fd_alloc>
  801f52:	89 c3                	mov    %eax,%ebx
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	85 c0                	test   %eax,%eax
  801f59:	0f 88 db 00 00 00    	js     80203a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 07 04 00 00       	push   $0x407
  801f67:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6a:	6a 00                	push   $0x0
  801f6c:	e8 3f ee ff ff       	call   800db0 <sys_page_alloc>
  801f71:	89 c3                	mov    %eax,%ebx
  801f73:	83 c4 10             	add    $0x10,%esp
  801f76:	85 c0                	test   %eax,%eax
  801f78:	0f 88 bc 00 00 00    	js     80203a <pipe+0x131>
	va = fd2data(fd0);
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	ff 75 f4             	pushl  -0xc(%ebp)
  801f84:	e8 2c f1 ff ff       	call   8010b5 <fd2data>
  801f89:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f8b:	83 c4 0c             	add    $0xc,%esp
  801f8e:	68 07 04 00 00       	push   $0x407
  801f93:	50                   	push   %eax
  801f94:	6a 00                	push   $0x0
  801f96:	e8 15 ee ff ff       	call   800db0 <sys_page_alloc>
  801f9b:	89 c3                	mov    %eax,%ebx
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	0f 88 82 00 00 00    	js     80202a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	ff 75 f0             	pushl  -0x10(%ebp)
  801fae:	e8 02 f1 ff ff       	call   8010b5 <fd2data>
  801fb3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fba:	50                   	push   %eax
  801fbb:	6a 00                	push   $0x0
  801fbd:	56                   	push   %esi
  801fbe:	6a 00                	push   $0x0
  801fc0:	e8 2e ee ff ff       	call   800df3 <sys_page_map>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 20             	add    $0x20,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	78 4e                	js     80201c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fce:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fe2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fea:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff7:	e8 a9 f0 ff ff       	call   8010a5 <fd2num>
  801ffc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fff:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802001:	83 c4 04             	add    $0x4,%esp
  802004:	ff 75 f0             	pushl  -0x10(%ebp)
  802007:	e8 99 f0 ff ff       	call   8010a5 <fd2num>
  80200c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80201a:	eb 2e                	jmp    80204a <pipe+0x141>
	sys_page_unmap(0, va);
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	56                   	push   %esi
  802020:	6a 00                	push   $0x0
  802022:	e8 0e ee ff ff       	call   800e35 <sys_page_unmap>
  802027:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80202a:	83 ec 08             	sub    $0x8,%esp
  80202d:	ff 75 f0             	pushl  -0x10(%ebp)
  802030:	6a 00                	push   $0x0
  802032:	e8 fe ed ff ff       	call   800e35 <sys_page_unmap>
  802037:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80203a:	83 ec 08             	sub    $0x8,%esp
  80203d:	ff 75 f4             	pushl  -0xc(%ebp)
  802040:	6a 00                	push   $0x0
  802042:	e8 ee ed ff ff       	call   800e35 <sys_page_unmap>
  802047:	83 c4 10             	add    $0x10,%esp
}
  80204a:	89 d8                	mov    %ebx,%eax
  80204c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <pipeisclosed>:
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	e8 b9 f0 ff ff       	call   80111e <fd_lookup>
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 18                	js     802084 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	ff 75 f4             	pushl  -0xc(%ebp)
  802072:	e8 3e f0 ff ff       	call   8010b5 <fd2data>
	return _pipeisclosed(fd, p);
  802077:	89 c2                	mov    %eax,%edx
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	e8 2f fd ff ff       	call   801db0 <_pipeisclosed>
  802081:	83 c4 10             	add    $0x10,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	c3                   	ret    

0080208c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802092:	68 6f 2b 80 00       	push   $0x802b6f
  802097:	ff 75 0c             	pushl  0xc(%ebp)
  80209a:	e8 1f e9 ff ff       	call   8009be <strcpy>
	return 0;
}
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <devcons_write>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	57                   	push   %edi
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020b2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020b7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020bd:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020c0:	73 31                	jae    8020f3 <devcons_write+0x4d>
		m = n - tot;
  8020c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020c5:	29 f3                	sub    %esi,%ebx
  8020c7:	83 fb 7f             	cmp    $0x7f,%ebx
  8020ca:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020cf:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	53                   	push   %ebx
  8020d6:	89 f0                	mov    %esi,%eax
  8020d8:	03 45 0c             	add    0xc(%ebp),%eax
  8020db:	50                   	push   %eax
  8020dc:	57                   	push   %edi
  8020dd:	e8 6a ea ff ff       	call   800b4c <memmove>
		sys_cputs(buf, m);
  8020e2:	83 c4 08             	add    $0x8,%esp
  8020e5:	53                   	push   %ebx
  8020e6:	57                   	push   %edi
  8020e7:	e8 08 ec ff ff       	call   800cf4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020ec:	01 de                	add    %ebx,%esi
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	eb ca                	jmp    8020bd <devcons_write+0x17>
}
  8020f3:	89 f0                	mov    %esi,%eax
  8020f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f8:	5b                   	pop    %ebx
  8020f9:	5e                   	pop    %esi
  8020fa:	5f                   	pop    %edi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    

008020fd <devcons_read>:
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 08             	sub    $0x8,%esp
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802108:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210c:	74 21                	je     80212f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80210e:	e8 ff eb ff ff       	call   800d12 <sys_cgetc>
  802113:	85 c0                	test   %eax,%eax
  802115:	75 07                	jne    80211e <devcons_read+0x21>
		sys_yield();
  802117:	e8 75 ec ff ff       	call   800d91 <sys_yield>
  80211c:	eb f0                	jmp    80210e <devcons_read+0x11>
	if (c < 0)
  80211e:	78 0f                	js     80212f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802120:	83 f8 04             	cmp    $0x4,%eax
  802123:	74 0c                	je     802131 <devcons_read+0x34>
	*(char*)vbuf = c;
  802125:	8b 55 0c             	mov    0xc(%ebp),%edx
  802128:	88 02                	mov    %al,(%edx)
	return 1;
  80212a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    
		return 0;
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
  802136:	eb f7                	jmp    80212f <devcons_read+0x32>

00802138 <cputchar>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802144:	6a 01                	push   $0x1
  802146:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802149:	50                   	push   %eax
  80214a:	e8 a5 eb ff ff       	call   800cf4 <sys_cputs>
}
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <getchar>:
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80215a:	6a 01                	push   $0x1
  80215c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	6a 00                	push   $0x0
  802162:	e8 27 f2 ff ff       	call   80138e <read>
	if (r < 0)
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	85 c0                	test   %eax,%eax
  80216c:	78 06                	js     802174 <getchar+0x20>
	if (r < 1)
  80216e:	74 06                	je     802176 <getchar+0x22>
	return c;
  802170:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    
		return -E_EOF;
  802176:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80217b:	eb f7                	jmp    802174 <getchar+0x20>

0080217d <iscons>:
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802183:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802186:	50                   	push   %eax
  802187:	ff 75 08             	pushl  0x8(%ebp)
  80218a:	e8 8f ef ff ff       	call   80111e <fd_lookup>
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	78 11                	js     8021a7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80219f:	39 10                	cmp    %edx,(%eax)
  8021a1:	0f 94 c0             	sete   %al
  8021a4:	0f b6 c0             	movzbl %al,%eax
}
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <opencons>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b2:	50                   	push   %eax
  8021b3:	e8 14 ef ff ff       	call   8010cc <fd_alloc>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 3a                	js     8021f9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 07 04 00 00       	push   $0x407
  8021c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ca:	6a 00                	push   $0x0
  8021cc:	e8 df eb ff ff       	call   800db0 <sys_page_alloc>
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	78 21                	js     8021f9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021e1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021ed:	83 ec 0c             	sub    $0xc,%esp
  8021f0:	50                   	push   %eax
  8021f1:	e8 af ee ff ff       	call   8010a5 <fd2num>
  8021f6:	83 c4 10             	add    $0x10,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802200:	a1 08 40 80 00       	mov    0x804008,%eax
  802205:	8b 40 48             	mov    0x48(%eax),%eax
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 a0 2b 80 00       	push   $0x802ba0
  802210:	50                   	push   %eax
  802211:	68 87 26 80 00       	push   $0x802687
  802216:	e8 44 e0 ff ff       	call   80025f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80221b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80221e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802224:	e8 49 eb ff ff       	call   800d72 <sys_getenvid>
  802229:	83 c4 04             	add    $0x4,%esp
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	ff 75 08             	pushl  0x8(%ebp)
  802232:	56                   	push   %esi
  802233:	50                   	push   %eax
  802234:	68 7c 2b 80 00       	push   $0x802b7c
  802239:	e8 21 e0 ff ff       	call   80025f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80223e:	83 c4 18             	add    $0x18,%esp
  802241:	53                   	push   %ebx
  802242:	ff 75 10             	pushl  0x10(%ebp)
  802245:	e8 c4 df ff ff       	call   80020e <vcprintf>
	cprintf("\n");
  80224a:	c7 04 24 4b 26 80 00 	movl   $0x80264b,(%esp)
  802251:	e8 09 e0 ff ff       	call   80025f <cprintf>
  802256:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802259:	cc                   	int3   
  80225a:	eb fd                	jmp    802259 <_panic+0x5e>

0080225c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	56                   	push   %esi
  802260:	53                   	push   %ebx
  802261:	8b 75 08             	mov    0x8(%ebp),%esi
  802264:	8b 45 0c             	mov    0xc(%ebp),%eax
  802267:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80226a:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80226c:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802271:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	50                   	push   %eax
  802278:	e8 e3 ec ff ff       	call   800f60 <sys_ipc_recv>
	if(ret < 0){
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	78 2b                	js     8022af <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802284:	85 f6                	test   %esi,%esi
  802286:	74 0a                	je     802292 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802288:	a1 08 40 80 00       	mov    0x804008,%eax
  80228d:	8b 40 78             	mov    0x78(%eax),%eax
  802290:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802292:	85 db                	test   %ebx,%ebx
  802294:	74 0a                	je     8022a0 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802296:	a1 08 40 80 00       	mov    0x804008,%eax
  80229b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80229e:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a5:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5e                   	pop    %esi
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    
		if(from_env_store)
  8022af:	85 f6                	test   %esi,%esi
  8022b1:	74 06                	je     8022b9 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022b3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022b9:	85 db                	test   %ebx,%ebx
  8022bb:	74 eb                	je     8022a8 <ipc_recv+0x4c>
			*perm_store = 0;
  8022bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022c3:	eb e3                	jmp    8022a8 <ipc_recv+0x4c>

008022c5 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	57                   	push   %edi
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	83 ec 0c             	sub    $0xc,%esp
  8022ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022d7:	85 db                	test   %ebx,%ebx
  8022d9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022de:	0f 44 d8             	cmove  %eax,%ebx
  8022e1:	eb 05                	jmp    8022e8 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022e3:	e8 a9 ea ff ff       	call   800d91 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022e8:	ff 75 14             	pushl  0x14(%ebp)
  8022eb:	53                   	push   %ebx
  8022ec:	56                   	push   %esi
  8022ed:	57                   	push   %edi
  8022ee:	e8 4a ec ff ff       	call   800f3d <sys_ipc_try_send>
  8022f3:	83 c4 10             	add    $0x10,%esp
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 1b                	je     802315 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022fa:	79 e7                	jns    8022e3 <ipc_send+0x1e>
  8022fc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ff:	74 e2                	je     8022e3 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 a7 2b 80 00       	push   $0x802ba7
  802309:	6a 46                	push   $0x46
  80230b:	68 bc 2b 80 00       	push   $0x802bbc
  802310:	e8 e6 fe ff ff       	call   8021fb <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802315:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    

0080231d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802328:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80232e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802334:	8b 52 50             	mov    0x50(%edx),%edx
  802337:	39 ca                	cmp    %ecx,%edx
  802339:	74 11                	je     80234c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80233b:	83 c0 01             	add    $0x1,%eax
  80233e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802343:	75 e3                	jne    802328 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	eb 0e                	jmp    80235a <ipc_find_env+0x3d>
			return envs[i].env_id;
  80234c:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802352:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802357:	8b 40 48             	mov    0x48(%eax),%eax
}
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    

0080235c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802362:	89 d0                	mov    %edx,%eax
  802364:	c1 e8 16             	shr    $0x16,%eax
  802367:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802373:	f6 c1 01             	test   $0x1,%cl
  802376:	74 1d                	je     802395 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802378:	c1 ea 0c             	shr    $0xc,%edx
  80237b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802382:	f6 c2 01             	test   $0x1,%dl
  802385:	74 0e                	je     802395 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802387:	c1 ea 0c             	shr    $0xc,%edx
  80238a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802391:	ef 
  802392:	0f b7 c0             	movzwl %ax,%eax
}
  802395:	5d                   	pop    %ebp
  802396:	c3                   	ret    
  802397:	66 90                	xchg   %ax,%ax
  802399:	66 90                	xchg   %ax,%ax
  80239b:	66 90                	xchg   %ax,%ax
  80239d:	66 90                	xchg   %ax,%ax
  80239f:	90                   	nop

008023a0 <__udivdi3>:
  8023a0:	55                   	push   %ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 1c             	sub    $0x1c,%esp
  8023a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023b7:	85 d2                	test   %edx,%edx
  8023b9:	75 4d                	jne    802408 <__udivdi3+0x68>
  8023bb:	39 f3                	cmp    %esi,%ebx
  8023bd:	76 19                	jbe    8023d8 <__udivdi3+0x38>
  8023bf:	31 ff                	xor    %edi,%edi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f2                	mov    %esi,%edx
  8023c5:	f7 f3                	div    %ebx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 d9                	mov    %ebx,%ecx
  8023da:	85 db                	test   %ebx,%ebx
  8023dc:	75 0b                	jne    8023e9 <__udivdi3+0x49>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	31 d2                	xor    %edx,%edx
  8023eb:	89 f0                	mov    %esi,%eax
  8023ed:	f7 f1                	div    %ecx
  8023ef:	89 c6                	mov    %eax,%esi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f7                	mov    %esi,%edi
  8023f5:	f7 f1                	div    %ecx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	39 f2                	cmp    %esi,%edx
  80240a:	77 1c                	ja     802428 <__udivdi3+0x88>
  80240c:	0f bd fa             	bsr    %edx,%edi
  80240f:	83 f7 1f             	xor    $0x1f,%edi
  802412:	75 2c                	jne    802440 <__udivdi3+0xa0>
  802414:	39 f2                	cmp    %esi,%edx
  802416:	72 06                	jb     80241e <__udivdi3+0x7e>
  802418:	31 c0                	xor    %eax,%eax
  80241a:	39 eb                	cmp    %ebp,%ebx
  80241c:	77 a9                	ja     8023c7 <__udivdi3+0x27>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	eb a2                	jmp    8023c7 <__udivdi3+0x27>
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	31 ff                	xor    %edi,%edi
  80242a:	31 c0                	xor    %eax,%eax
  80242c:	89 fa                	mov    %edi,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	89 eb                	mov    %ebp,%ebx
  802471:	d3 e6                	shl    %cl,%esi
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 15                	jb     8024a0 <__udivdi3+0x100>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 04                	jae    802497 <__udivdi3+0xf7>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	74 09                	je     8024a0 <__udivdi3+0x100>
  802497:	89 d8                	mov    %ebx,%eax
  802499:	31 ff                	xor    %edi,%edi
  80249b:	e9 27 ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 1d ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024c7:	89 da                	mov    %ebx,%edx
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 43                	jne    802510 <__umoddi3+0x60>
  8024cd:	39 df                	cmp    %ebx,%edi
  8024cf:	76 17                	jbe    8024e8 <__umoddi3+0x38>
  8024d1:	89 f0                	mov    %esi,%eax
  8024d3:	f7 f7                	div    %edi
  8024d5:	89 d0                	mov    %edx,%eax
  8024d7:	31 d2                	xor    %edx,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 fd                	mov    %edi,%ebp
  8024ea:	85 ff                	test   %edi,%edi
  8024ec:	75 0b                	jne    8024f9 <__umoddi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f7                	div    %edi
  8024f7:	89 c5                	mov    %eax,%ebp
  8024f9:	89 d8                	mov    %ebx,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	f7 f5                	div    %ebp
  8024ff:	89 f0                	mov    %esi,%eax
  802501:	f7 f5                	div    %ebp
  802503:	89 d0                	mov    %edx,%eax
  802505:	eb d0                	jmp    8024d7 <__umoddi3+0x27>
  802507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250e:	66 90                	xchg   %ax,%ax
  802510:	89 f1                	mov    %esi,%ecx
  802512:	39 d8                	cmp    %ebx,%eax
  802514:	76 0a                	jbe    802520 <__umoddi3+0x70>
  802516:	89 f0                	mov    %esi,%eax
  802518:	83 c4 1c             	add    $0x1c,%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    
  802520:	0f bd e8             	bsr    %eax,%ebp
  802523:	83 f5 1f             	xor    $0x1f,%ebp
  802526:	75 20                	jne    802548 <__umoddi3+0x98>
  802528:	39 d8                	cmp    %ebx,%eax
  80252a:	0f 82 b0 00 00 00    	jb     8025e0 <__umoddi3+0x130>
  802530:	39 f7                	cmp    %esi,%edi
  802532:	0f 86 a8 00 00 00    	jbe    8025e0 <__umoddi3+0x130>
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	83 c4 1c             	add    $0x1c,%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5f                   	pop    %edi
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	ba 20 00 00 00       	mov    $0x20,%edx
  80254f:	29 ea                	sub    %ebp,%edx
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 44 24 08          	mov    %eax,0x8(%esp)
  802557:	89 d1                	mov    %edx,%ecx
  802559:	89 f8                	mov    %edi,%eax
  80255b:	d3 e8                	shr    %cl,%eax
  80255d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802561:	89 54 24 04          	mov    %edx,0x4(%esp)
  802565:	8b 54 24 04          	mov    0x4(%esp),%edx
  802569:	09 c1                	or     %eax,%ecx
  80256b:	89 d8                	mov    %ebx,%eax
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 e9                	mov    %ebp,%ecx
  802573:	d3 e7                	shl    %cl,%edi
  802575:	89 d1                	mov    %edx,%ecx
  802577:	d3 e8                	shr    %cl,%eax
  802579:	89 e9                	mov    %ebp,%ecx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 c7                	mov    %eax,%edi
  802583:	89 d1                	mov    %edx,%ecx
  802585:	89 f0                	mov    %esi,%eax
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	d3 e6                	shl    %cl,%esi
  80258f:	09 d8                	or     %ebx,%eax
  802591:	f7 74 24 08          	divl   0x8(%esp)
  802595:	89 d1                	mov    %edx,%ecx
  802597:	89 f3                	mov    %esi,%ebx
  802599:	f7 64 24 0c          	mull   0xc(%esp)
  80259d:	89 c6                	mov    %eax,%esi
  80259f:	89 d7                	mov    %edx,%edi
  8025a1:	39 d1                	cmp    %edx,%ecx
  8025a3:	72 06                	jb     8025ab <__umoddi3+0xfb>
  8025a5:	75 10                	jne    8025b7 <__umoddi3+0x107>
  8025a7:	39 c3                	cmp    %eax,%ebx
  8025a9:	73 0c                	jae    8025b7 <__umoddi3+0x107>
  8025ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025b3:	89 d7                	mov    %edx,%edi
  8025b5:	89 c6                	mov    %eax,%esi
  8025b7:	89 ca                	mov    %ecx,%edx
  8025b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025be:	29 f3                	sub    %esi,%ebx
  8025c0:	19 fa                	sbb    %edi,%edx
  8025c2:	89 d0                	mov    %edx,%eax
  8025c4:	d3 e0                	shl    %cl,%eax
  8025c6:	89 e9                	mov    %ebp,%ecx
  8025c8:	d3 eb                	shr    %cl,%ebx
  8025ca:	d3 ea                	shr    %cl,%edx
  8025cc:	09 d8                	or     %ebx,%eax
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	89 da                	mov    %ebx,%edx
  8025e2:	29 fe                	sub    %edi,%esi
  8025e4:	19 c2                	sbb    %eax,%edx
  8025e6:	89 f1                	mov    %esi,%ecx
  8025e8:	89 c8                	mov    %ecx,%eax
  8025ea:	e9 4b ff ff ff       	jmp    80253a <__umoddi3+0x8a>
